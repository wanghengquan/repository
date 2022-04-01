"""
mkdir p1/p2/p3
cd p1/p2//p3
mkdir jedi
cd jedi
setenv rsync_mirror /lsc/release/jedi/jedi_simrel/jedi_simrel_106
source $rsync_mirror/fsoc/amber/tools/jedi_simrel/data/bin/simenv.cshrc

"""

import os
import re
import glob
import time
import shutil
from . import xTools
import threading
from collections import OrderedDict
from . import pad2signal
from . import filelock
__author__ = 'syan'

TCL_NCV = """#NC Verilog command file
alias . run
alias quit exit

#force fc_tb.xfc.efb_hse_wrap.u_efb_top.config_plus_inst.config_core_inst.fl_blk.flash_blk.flash_sub_blockA.fl_dnld.ppt.mfg_ppt_abort 1

database -open -shm -into outwaves waves -default -incsize 2G
probe -create -database waves fc_tb                -depth 1   -waveform
probe -create -database waves fc_tb.xfc            -depth 1   -waveform
#probe -create -database waves fc_tb.xfc.efb_hse_wrap       -depth all -waveform
#probe -create -database waves fc_tb.xfc.flash_{sentry_pty}_A -depth all -waveform
#probe -create -database waves fc_tb.xfc.flash_{sentry_pty}_B -depth all -waveform
#probe -create -database waves fc_tb.xfc.flash_640_C -depth all -waveform
#probe -create -database waves fc_tb.xfc.por      -depth all -waveform
#probe -create -database waves fc_tb.xfc.iol3      -depth all -waveform
#probe -create -database waves fc_tb.xfc.pl3       -depth all -waveform
#probe -create -database waves fc_tb.xfc.r3c1      -depth all -waveform
#probe -create -database waves fc_tb.xfc.r3c2      -depth all -waveform
#probe -create -database waves fc_tb.xfc.pll_r1c1      -depth all -waveform

run
exit
"""

TCL_NCV_JEDI = """#NC Verilog command file
alias . run
alias quit exit

database -open -shm -into outwaves waves -default
database -open -shm -into outwaves waves -default -incsize 2G
probe -create -database waves fc_tb                -depth 1   -waveform
probe -create -database waves fc_tb.xfc            -depth 1   -waveform
#probe -create -database waves fc_tb.xfc.xgpt2        -depth all -waveform
#probe -create -database waves fc_tb.xfc.xgpiot2    -depth all -waveform

run
exit 
"""

TCL_NCV_JEDI_D1 = """#NC Verilog command file
alias . run
alias quit exit

database -open -shm -into outwaves waves -default
database -open -shm -into outwaves waves -default -incsize 2G
probe -create -database waves fc_tb                -depth 1   -waveform
probe -create -database waves fc_tb.xfc            -depth 1   -waveform
#probe -create -database waves fc_tb.xfc.xgpt2        -depth all -waveform
#probe -create -database waves fc_tb.xfc.xgpiot2    -depth all -waveform

# Local release based on 2020_05_29_jedi_D1_80k_RFS1p6
force fc_tb.xfc.gbuf_core.es_o_1 = 1'b0;

run
exit 
"""

FC_CTL = """
# Control file for running full chip simulation (use by the pli)
# Commands available:
# a. CTL_INSTR_POR                  ;  => calls por.v tasks
# b. CTL_INSTR_CONFIG <mem4> <rbt>  ;  => mem4 file are device dependent
# c. CTL_INSTR_RDBK   <mem4> <rbto> ;
# d. CTL_INSTR_AVC    <avc>         ;
# e. CTL_INSTR_END                  ;
# f. CTL_INSTR_END    <pkg>         ;  => remove force statement of these pins.

CTL_INSTR_POR                            ; # calls por
#CTL_INSTR_AVC    por.avc                 ; # call por avc
CTL_INSTR_REGFUSE feature_bit.sfb        ; # program feature bits of shadow registers
#CTL_INSTR_AVC    deviceid.avc            ; # pick UV or LV device before simulating
CTL_INSTR_CONFIG mem/sentry_{sentry_pty}.mem4 fc.rbt ;
CTL_INSTR_AVC    jtag_wakeup.avc         ; # run jtag wakeup for done to go high
CTL_INSTR_AVC    avc_change_freq.avc     ;
CTL_INSTR_AVC    fc.avc                  ; # functional pattern
CTL_INSTR_END                            ;
"""
AVC_CHANGE_FREQ_AVC = """format avc_freq1 avc_freq0;
r1 name %s
"""

CHANGE_AVC_DICT = {"5": "01", "0.5": "11", "1000": "00"}
# These are the supported values and the delay:
# {avc_freq2,avc_freq1,avc_freq0} == 3'b001 - #5 ns
# {avc_freq2,avc_freq1,avc_freq0} == 3'b011 - #0.5 ns
# {avc_freq2,avc_freq1,avc_freq0} == 3'b010 - #500 ns
# {avc_freq2,avc_freq1,avc_freq0} == 3'b100 - #1000 ns
# {avc_freq2,avc_freq1,avc_freq0} == 3'b101 - #330 ns
# {avc_freq2,avc_freq1,avc_freq0} == 3'b110 - #80 ns
# {avc_freq2,avc_freq1,avc_freq0} == 3'b111 - #1.1 ns
AVC_CHANGE_FREQ_AVC_JEDI_D1 = """format avc_freq2 avc_freq1 avc_freq0;
r1 name %s"""
CHANGE_AVC_DICT_JEDI_D1 = {"5": "001", "0.5": "011", "1000": "100"}


def hex2bin_character(hex_char):
    """transfer hex character to bin string.

       :param hex_char: 0, 1, 2, ..., d, e, f, Others
       :return: 0000, 0001, 0010, ... 1101, ,1110, 1111, XXXX
    """
    try:
        dec = int(hex_char.upper(), 16)
    except ValueError:
        return "XXXX"
    return bin(dec)[2:].rjust(4, "0")  # remove 0b


def hex2bin_string(hex_str, sim_vendor_name):
    if sim_vendor_name == "Riviera":
        hex_str = re.sub("[zZxX]", "X", hex_str)
        return hex_str

    p_skit_char = re.compile("[^\s;,_-]")
    hex_str = list(filter(p_skit_char.search, hex_str))
    return "".join(map(hex2bin_character, hex_str))


def get_lst_dict(lst_file):
    """ get data dictionary from Modelsim/ActiveHDL lst file
    yield: {'ps': '50000', 'WE': '1', 'Reset': '0',
            'Address': '002',
            'ramdq_1024x32_1111111_vlog_gen_out': '00000002',
            'Q': '00000000', 'VCCI_sig': '1',
            'index': '00000006', 'ClockEn': '1',
            'Clock': '0', 'Data': '78b8bed6'}
    """
    p_start_data = re.compile("^\s*\d+\s+")
    p_lst_port = re.compile("/([^/]+)$")
    start_data = 0
    title_dict = dict()  # value: title, key: end index
    keys = list()
    for line in open(lst_file):
        if not start_data:
            start_data = p_start_data.search(line)
        line_list = line.strip().split()
        if not start_data:
            non_line_list = re.split("\S+", line)
            my_key = 0
            for i, item in enumerate(line_list):
                my_key += (len(item) + len(non_line_list[i]))
                title_dict[my_key] = item
        else:
            if not keys:
                _keys = list(title_dict.keys())
                _keys.sort()
                keys = list()
                for item in _keys:
                    _t = title_dict[item]
                    m_lst_port = p_lst_port.search(_t)
                    if m_lst_port:
                        # /tb_mac_18x19/UUT/LD /tb_mac_18x19/UUT/OVERFLOW --> OVERFLOW
                        if "\\" in _t:
                            keys.append(_t)
                        else:
                            keys.append(m_lst_port.group(1))
                    else:
                        keys.append(_t)
            yield dict(list(zip(keys, line_list)))


def _get_pad_dict(pad_file, p_start, p_split, title):
    titles = list()
    pad_dict = dict()
    with open(pad_file) as pad_ob:
        for line in pad_ob:
            line = line.strip()
            line_list = p_split.split(line)
            if not titles:
                if p_start.search(line):
                    titles = line_list
                continue
            else:
                if not line:
                    break
                t_dict = dict(list(zip(titles, line_list)))
                item = t_dict.get(title)
                if item:
                    if "Reserved:" not in item:  # | AA21/2 | Reserved: sysCONFIG | | LVCMOS25_BIDI | PB46B | SI/SISPI
                        pad_dict[item] = t_dict
    return pad_dict


def get_pad_dict(pad_file):
    """
    :return: 'Q[10]' : {'': '', 'Buffer Type': 'LVCMOS25_OUT', 'BC Enable': '',
                        'Site': 'PL14A', 'Pin/Bank': 'D4/7', 'Port Name': 'Q[10]',
                        'Properties': 'DRIVE:8mA CLAMP:ON SLEW:SLOW'}
    """
    p_start = re.compile("^\|\s+Pin/Bank")
    p_split = re.compile("\s*\|\s*")
    return _get_pad_dict(pad_file, p_start, p_split, "Pin Info")


def get_diff_pad_dict(pad_file, pad_dict):
    p_start = re.compile("^\|\s+Pin/Bank")
    p_split = re.compile("\s*\|\s*")
    _diff_pad_dict = _get_pad_dict(pad_file, p_start, p_split, "Pin Info")
    t = dict()
    for pin_bank, pb_dict in list(_diff_pad_dict.items()):
        pin_info = pb_dict.get("Pin Info")
        buffer_type = pb_dict.get("Buffer Type")
        site = pb_dict.get("Site")
        if buffer_type != "LVDS25_IN":
            continue
        for a, b in list(pad_dict.items()):
            if b.get("Buffer Type") == buffer_type:
                a_site = b.get("Site")
                new_site = a_site[:-1] + chr(ord(a_site[-1]) + 1)
                if new_site == site:
                    pb_dict["raw_pin"] = a
                    t[pin_info] = pb_dict
                    break
    return t

P_PORT = re.compile("(\S+)\[(\d+)\]")


def get_sorted_ports(raw_ports):
    def _new_key(raw_key):
        m_port = P_PORT.search(raw_key)
        if m_port:
            return "%s_%05d" % (m_port.group(1), int(m_port.group(2)))
        else:
            return raw_key
    return sorted(raw_ports, key=_new_key, reverse=1)


def get_zipped_ports(raw_ports):
    """
    ... Q[31]   Q[30]   Q[29]   Q[28]   Q[27]   Q[26]   Q[25]   Q[24]   Q[23] ...
    -->
    ['WE', 'Reset', 'Data', 'ClockEn', 'Clock', 'Address', 'Q']
    """
    zipped_ports = list()
    port_width = dict()
    for item in raw_ports:
        m_port = P_PORT.search(item)
        if m_port:
            port_name = m_port.group(1)
            position = int(m_port.group(2))
        else:
            port_name = item
            position = 0
        if port_name not in zipped_ports:
            zipped_ports.append(port_name)
            port_width.setdefault(port_name, [position])
        else:
            port_width.get(port_name).append(position)
    return zipped_ports, port_width


def _get_list(raw_string):
    if raw_string:
        raw_string = raw_string.strip()
        if raw_string:
            _ = re.split(",", raw_string)
            _ = [item.strip() for item in _]
            return _


def get_in_out_bidi_vref(sorted_ports, pad_dict, simrel_options):
    ports_in, ports_out = list(), list()
    ports_bidi, ports_vref = list(), list()
    bidi_in = _get_list(simrel_options.get("bidi_in"))
    bidi_out = _get_list(simrel_options.get("bidi_out"))
    for port_name in sorted_ports:
        pad_content = pad_dict.get(port_name)
        buffer_type = pad_content.get("Buffer Type")
        if re.search("_IN$", buffer_type):
            ports_in.append(port_name)
        elif re.search("_OUT$", buffer_type):
            ports_out.append(port_name)
        elif re.search("_BIDI$", buffer_type):
            if bidi_in:
                if "__all__" in bidi_in:
                    ports_in.append(port_name)
                elif port_name in bidi_in:
                    ports_in.append(port_name)
                else:
                    ports_out.append(port_name)
            elif bidi_out:
                if "__all__" in bidi_out:
                    ports_out.append(port_name)
                elif port_name in bidi_out:
                    ports_out.append(port_name)
                else:
                    ports_in.append(port_name)
            else:
                ports_bidi.append(port_name)
        elif port_name.startswith("VREF"):
            ports_vref.append(port_name)
    return ports_in, ports_out, ports_bidi, ports_vref


class GetActiveInput(object):
    """
    raw_settings = dict(active_input="sel_1")
    raw_settings = dict(active_output="n_sel_2")
    raw_settings = dict(active_input_1="sel_2 : bidi_1, bidi_3[4:0]",
                        active_output_1="sel_1 : bidi_2",
                        active_output_2="sel_3 : bidi_3[9:5]")
    """
    def __init__(self, raw_settings):
        self.raw_settings = raw_settings
        self.tag_input = "active_input"
        self.tab_output = "active_output"
        self.p_select_ports = re.compile("([^:]+):(.+)")
        self.p_position = re.compile(r"""(?P<port_name>[^\]]+)
                                         \[
                                         (?P<position>[^\]]+)
                                         \]""", re.VERBOSE)
        self.p_position_2 = re.compile(r"(\d+):(\d+)")
        self.input_output = dict()

    def port_to_list(self, raw_ports):
        new_list = list()
        raw_list = re.split(",", raw_ports)
        for foo in raw_list:
            foo = re.sub(r"\s", "", foo)
            m_position = self.p_position.search(foo)
            if m_position:
                m_p2 = self.p_position_2.search(m_position.group('position'))
                if m_p2:
                    left, right = m_p2.group(1), m_p2.group(2)
                    left, right = int(left), int(right)
                    max_position = max(left, right)
                    min_position = min(left, right)
                    for i in range(min_position, max_position+1):
                        new_list.append("{}[{}]".format(m_position.group('port_name'), i))
                else:
                    new_list.append(foo)
            else:
                new_list.append(foo)
        return new_list

    def process(self):
        if not self.raw_settings:
            return
        for k, v in list(self.raw_settings.items()):
            v = v.strip()
            if k.startswith(self.tag_input):
                new_key = "input"
            elif k.startswith(self.tab_output):
                new_key = "output"
            else:
                continue
            self.input_output.setdefault(new_key, dict())
            m_s_p = self.p_select_ports.search(v)
            if not m_s_p:
                self.input_output[new_key][v] = None
            else:
                select_signal = m_s_p.group(1)
                select_signal = select_signal.strip()
                ports = m_s_p.group(2)
                self.input_output[new_key][select_signal] = self.port_to_list(ports)
        return self.check_define_port_one_time_only()

    def define_input(self, inner_name, lst_data):
        for i_o, sp_dict in list(self.input_output.items()):
            if not sp_dict:
                continue
            got_it = None
            for s, p in list(sp_dict.items()):
                select_01 = lst_data.get(s)
                if select_01 is None:
                    xTools.say_it("Error. Not found select_signal {} value".format(s))
                    return
                if p is None:
                    if select_01 == "1":
                        got_it = i_o
                        break
                    else:  # if select_01 == "0":
                        got_it = "output" if i_o == "input" else "input"
                        break
                bus_name = re.sub(r"[-\+]$", "", inner_name)   # bidi_2[17]-, bidi_2[17]+
                bus_name = re.sub(r"\[\d+\]", "", bus_name)
                #
                if bus_name in p or inner_name in p:
                    got_it = i_o if select_01 == "1" else ("output" if i_o == "input" else "input")
                    break
            if got_it:
                return got_it

    def check_define_port_one_time_only(self):
        sts = 0
        # if None is port list, only input is valid when input is not None
        _input = self.input_output.get("input")
        if _input:
            for k, v in list(_input.items()):
                if v is None:
                    self.input_output["output"] = None
        full_list = list()
        for i_o, sp_dict in list(self.input_output.items()):
            if not sp_dict:
                continue
            for s, p in list(sp_dict.items()):
                if p is None:
                    continue
                for sub_port in p:
                    bus_name = re.sub(r"\[\d+\]", "", sub_port)
                    if bus_name in full_list or sub_port in full_list:
                        sts = 1
                        xTools.say_it("Error. Duplicate select signal for {}".format(sub_port))
                    else:
                        full_list.append(sub_port)
        return sts


p_name_index = re.compile(r"^(_*)([^[]+)\[(\d+)\](\W*)")


def get_avc_bin_code(lst_data, ports_in, ports_bidi, ports_vref, ports_plus, ports_minus,
                     sim_vendor_name, active_class):
    bin_code = ""
    one_time_dict = dict()
    for (_ports, is_minus) in ((ports_plus, False), (ports_minus, True)):
        for show_name, inner_name in list(_ports.items()):
            if inner_name in ports_vref:
                bin_code += "0" if is_minus else "1"
            else:
                m_name_index = p_name_index.search(show_name)
                if m_name_index:
                    port_name = m_name_index.group(2)
                    port_index = int(m_name_index.group(3))
                else:
                    port_name = show_name.strip("_")
                    port_index = 0
                try:
                    if port_name in one_time_dict:
                        _value_in_lst = one_time_dict.get(port_name)
                    else:
                        xxx = hex2bin_string(lst_data.get(port_name), sim_vendor_name)
                        _value_in_lst = xxx[::-1]
                        one_time_dict[port_name] = _value_in_lst
                    try:
                        raw_value = _value_in_lst[port_index]
                    except Exception:
                        raw_value = "0"
                except Exception:
                    print(("Error. Cannot get value for port: {}".format(port_name)))
                    raw_value = "0"
                is_input = False  # only define True conditions later
                if inner_name in ports_in:
                    is_input = True
                if inner_name in ports_bidi:
                    if active_class:
                        input_or_output = active_class.define_input(inner_name, lst_data)
                        if input_or_output is None:
                            assert 0, "please check active_input or active_output settings for {}".format(inner_name)
                        if input_or_output == "input":
                            is_input = True
                        else:
                            is_input = False
                    else:
                        assert 0, "please check active_input or active_output settings for {}".format(inner_name)
                if is_minus:
                    if raw_value == "0":
                        raw_value = "1"
                    elif raw_value == "1":
                        raw_value = "0"
                    elif raw_value in ("X", "Z"):
                        raw_value = raw_value
                    else:
                        raw_value = "1"
                if is_input:
                    new_value = re.sub("[Xx]", "0", raw_value)
                else:
                    new_value = re.sub("0", "L", raw_value)
                    new_value = re.sub("1", "H", new_value)
                bin_code += new_value
    return bin_code


def get_avc_bin_code_old(lst_data, ports_in, ports_out, sim_vendor_name):
    zipped_in, ports_in_width = get_zipped_ports(ports_in)
    zipped_out, ports_out_width = get_zipped_ports(ports_out)

    def get_code(ports_list, ports_width):
        _code = list()
        for _port in ports_list:
            bin_code = hex2bin_string(lst_data.get(_port), sim_vendor_name)
            code_position = ports_width.get(_port)  # [7, 3, 2, 1, 0]
            len_position = len(code_position)       # 5
            real_width = len(bin_code)              # bin_code: 10001001
            # CHECK MAX LENGTH, fill it with 0
            if real_width != code_position[0] + 1:
                bin_code = "0" * (code_position[0] + 1 - real_width) + bin_code
            if real_width > len_position:
                _my_code = list()
                _d = list(bin_code)
                _d.reverse()
                for _posi in code_position:
                    _my_code.append(_d[_posi])
                bin_code = "".join(_my_code)
            _code.append(bin_code)
        return _code

    code_in = "".join(get_code(zipped_in, ports_in_width))
    code_out = "".join(get_code(zipped_out, ports_out_width))

    # code_in: set as 0 for non-0 and non-1
    # code_out: 1 -> H, 0 -> L, Others -> X
    code_in = re.sub("X", "0", code_in)
    code_out = re.sub("0", "L", code_out)
    code_out = re.sub("1", "H", code_out)
    return "%s%s" % (code_in, code_out)


def generate_simvision_tcl_file(simvision_tcl_file, ports_in, ports_out, ports_bidi, pad_dictionary):
    def __get_port_site(ports, pad_dict):
        port_site_dict = dict()
        for item in ports:
            m_name_index = p_name_index.search(item)
            if m_name_index:
                new_name = m_name_index.group(2)+m_name_index.group(4)
                new_index = m_name_index.group(3)
            else:
                new_name = item
                new_index = 0
            site = "fc_tb." + pad_dict.get(item).get("Site").lower()
            this_one = (str(new_index), site)
            if new_name in port_site_dict:
                port_site_dict[new_name].append(this_one)
            else:
                port_site_dict.setdefault(new_name, [this_one])

        t_lines = list()
        # for key, value in port_site_dict.items():
        keys = list(port_site_dict.keys())
        keys.sort()
        for key in keys:
            value = port_site_dict.get(key)
            value_lens = len(value)
            if value_lens == 1:
                t_lines.append("# %s" % key)
                _sig = value[0][1]
            else:
                t_lines.append("# %s [%s]" % (key, ", ".join([x[0] for x in value])))
                _sig = '{ %s }' % " ".join([x[1] for x in value])
            t_lines.append('waveform add -at top -signals %s -using "Waveform 1"' % _sig)
        return t_lines

    tcl_lines = list()
    tcl_lines.append("# /// INPUTS")
    tcl_lines += __get_port_site(ports_in, pad_dictionary)

    tcl_lines.append("")
    tcl_lines.append("# /// OUTPUTS")
    tcl_lines += __get_port_site(ports_out, pad_dictionary)

    if ports_bidi:
        tcl_lines.append("")
        tcl_lines.append("# /// BIDIS")
        tcl_lines += __get_port_site(ports_bidi, pad_dictionary)

    xTools.write_file(simvision_tcl_file, tcl_lines)


def _add_space(a_list, space_number=8):
    _ = [item.ljust(space_number) for item in a_list]
    return " ".join(_)


def generate_avc_file(avc_file, lst_file, pad_file, sim_vendor_name, simrel_options):
    pad_dict = get_pad_dict(pad_file)
    sorted_ports = get_sorted_ports(list(pad_dict.keys()))
    ports_in, ports_out, ports_bidi, ports_vref = get_in_out_bidi_vref(sorted_ports, pad_dict, simrel_options)
    if not ports_in:
        return 1
    tcl_file = os.path.join(os.path.dirname(avc_file), "run_simvision.tcl")
    generate_simvision_tcl_file(tcl_file, ports_in, ports_out, ports_bidi, pad_dict)
    avc_ob = open(avc_file, "w")
    print("#  port name in design", file=avc_ob)
    lst_dict = get_lst_dict(lst_file)
    ports_all = ports_vref + ports_in + ports_out + ports_bidi
    ports_plus, ports_minus = OrderedDict(), OrderedDict()
    for foo in ports_all:
        try_key = foo[:-1]
        if foo.endswith("-"):
            key = "_" + try_key
            ports_minus[key] = foo
        else:
            if foo.endswith("+"):
                key = try_key
            else:
                key = foo
            ports_plus[key] = foo
    second_line_list = list()
    third_line_list = list()
    for bar in (ports_plus, ports_minus):
        second_line_list.extend(list(bar.keys()))
        for cat, raw_cat in list(bar.items()):
            third_line_list.append(pad_dict.get(raw_cat).get("Site", "").lower())
    second_line, third_line = ["#     "], ["format"]
    if len(second_line) != len(third_line):
        print("Never got here! 03842390217")
        return 1
    for i, item2nd in enumerate(second_line_list):
        item3rd = third_line_list[i]
        lens = max(len(item2nd), len(item3rd), 8)
        second_line.append(item2nd.rjust(lens))
        third_line.append(item3rd.rjust(lens))
    third_line.append(";")
    print(" ".join(second_line), file=avc_ob)
    print(" ".join(third_line), file=avc_ob)
    if simrel_options.get("avc_file"):
        return   # do not run following lines
    else:
        get_active = GetActiveInput(simrel_options)
        sts = get_active.process()
    if sts:
        xTools.say_it("Error. Failed to read active_input/active_output settings")
        return 1
    for item in lst_dict:
        ps = item.get("ps")
        if not ps:
            fs = item.get("fs")
            if not fs:
                continue
        avc_bin_code = get_avc_bin_code(item, ports_in, ports_bidi, ports_vref, ports_plus,
                                        ports_minus, sim_vendor_name, get_active)
        print("r1 name  %s;" % avc_bin_code, file=avc_ob)
    avc_ob.close()
# --------------------------
# END OF PUBLIC FUNCTIONS
# --------------------------


def run_sim_ncv(general_options, simrel_dir, rbt_avc_folder, simrel_options, use_original_ctl):
    """ Since the remote workstation cannot read local file, link is unused.
        copy it!
    """
    xTools.say_it(" -- Go to %s and run SimREL flow ..." % simrel_dir)
    _recov = xTools.ChangeDir(simrel_dir)

    #Jason added for cov_work remove --2018/01/27
    cov_work_path = os.path.join(simrel_dir, 'cov_work')
    if os.path.exists(cov_work_path):
        xTools.rm_with_error(cov_work_path)  # do not care
        # shutil.rmtree(cov_work_path)
    original_fc_ctl = "fc.ctl.original"
    if not os.path.isfile(original_fc_ctl):
        shutil.copy2("fc.ctl", original_fc_ctl)

    ''' 
    if "sentry" in simrel_dir or "snow" in simrel_dir:
        src_files = ("fc.avc", "fc.rbt", "fc.ctl", "avc_change_freq.avc", "tcl_ncv")
    else:
        src_files = ("fc.avc", "fc.rbt", "fc.ctl", "tcl_ncv")
    '''
    # always copy avc file
    src_files = ("fc.avc", "fc.rbt", "fc.ctl", "avc_change_freq.avc", "tcl_ncv")
    temp_sh_file = "temp.sh"
    dst_files = ("fc.log", "fc.out", "fc.err", "irun.log", "xirun.log", "xrun.log",
                 "fc.ctl", "tcl_ncv",
                 "x_simrel_flow.log", "x_simrel_flow.time", temp_sh_file)
    temp_sh = open(temp_sh_file, "w")
    # /////////////////
    # check source file, then run remove flow
    # for _file in (src_files + dst_files[:-1]):
    #    print >> temp_sh, "rm %s" % _file
    for _file in src_files:
        a = os.path.join(rbt_avc_folder, _file)
        if os.path.isfile(a):
            print("rm -f %s" % _file, file=temp_sh)
        print("cp -f %s %s" % (a, _file), file=temp_sh)
    for _file in dst_files[:-1]:
        if _file in ("fc.ctl", "tcl_ncv"):
            continue
        if os.path.isfile(_file):
            print("rm %s" % _file, file=temp_sh)
    if use_original_ctl:
        x = "fc.ctl"
        if os.path.isfile(x):
            print("rm -f {}".format(x), file=temp_sh)
        print("cp {} fc.ctl".format(original_fc_ctl), file=temp_sh)
    _txt_file = "bitstream_lmmi.txt"  # perl scripts cannot chmod this file with different user
    if os.path.isfile("rbt_to_sspi_init_bus.pl"):
        if os.path.isfile(_txt_file):
            print("rm -rf {}".format(_txt_file), file=temp_sh)
        print("perl rbt_to_sspi_init_bus.pl fc.rbt", file=temp_sh)
    print("# use original fc.tcl file: {}".format(use_original_ctl), file=temp_sh)
    print("# Date: {} CWD: {}".format(time.ctime(), os.getcwd()), file=temp_sh)
    temp_sh.close()

    os.system("sh {}".format(temp_sh_file))
    real_ncv = "xsim_ncv" if re.search(r"\Wxncv", simrel_dir) else "sim_ncv"
    real_ncv = os.path.abspath(real_ncv)
    xTools.say_it("Running {}".format(real_ncv))
    sts = os.system("{} > x_simrel_flow.log".format(real_ncv))
    if sts:
        xTools.say_it("Failed to run simrel flow...")
        return sts
    xTools.say_it("Try to copy back results ...")
    # copy files
    t_copy = open("copy_files", "w")
    for _file in dst_files:
        print("cp -f %s %s/." % (_file, rbt_avc_folder), file=t_copy)
    _copy_wave = simrel_options.get("copy_wave")
    will_copy = 0
    if _copy_wave is None:
        results = xTools.simple_parser("fc.err", [re.compile("Inputs"), ])
        if results:
            will_copy = 1
        if not will_copy:
            results = xTools.simple_parser("fc.log",  [re.compile("Inputs"), ])
            if results:
                will_copy = 1
    else:
        _bool_copy_wave = xTools.get_true(simrel_options, "copy_wave")
        if _bool_copy_wave:
            will_copy = 1
    if not will_copy:
        will_copy = xTools.get_true(general_options, "simrel_copy_wave")
    if will_copy:
        print("cp -rf outwaves %s/outwaves" % rbt_avc_folder, file=t_copy)
    # remove results
    for r in ("outwaves", "*.log", "*.out"):
        print("rm -rf {}".format(r), file=t_copy)
    t_copy.close()
    # execute it!
    os.system("sh copy_files")
    _recov.comeback()
    xTools.say_it("Simrel flow is Done.")


def get_simrel_path(general_options, simrel_dirname, device):
    device = device.lower()
    simrel_root = simrel_dirname
    simrel_family = ""
    path_config = general_options.get("family_simrel_path")
    for k, v in list(path_config.items()):
        if simrel_family:
            break
        p = re.compile(k)
        m = p.search(device)
        if m:
            try:
                pkg_number = int(m.group(1))
            except:
                pkg_number = -1
            if pkg_number < 0:
                simrel_family = v
            else:
                v_lines = v.splitlines()
                for foo in v_lines:
                    foo = re.sub(r"\s", "", foo)
                    foo_list = re.split(",", foo)
                    if foo_list[0] == "default":
                        simrel_family = foo_list[1]
                        break
                    else:
                        judge_string = "{}{}".format(pkg_number, foo_list[0])
                        if eval(judge_string):
                            simrel_family = foo_list[1]
                            break
    if not simrel_family:
        xTools.say_it("Error. Unknown device: %s" % device)
        return "", "", ""

    i = 0
    while True:
        xTools.say_it(" -- <{}> Searching real simrel path in {} for {} ...".format(i, simrel_root, simrel_family))
        time.sleep(5)
        i += 1
        for foo in set(os.listdir(simrel_root)):
            abs_foo = os.path.join(simrel_root, foo)
            if os.path.isdir(abs_foo):
                check_file = os.path.join(abs_foo, "check_running.log")
                try:
                    if time.time() - os.path.getctime(check_file) > 212000:
                        xTools.rm_with_error(check_file)
                except:
                    pass
                if os.path.isfile(check_file):
                    continue
                else:
                    t = open(check_file, "w")
                    print(os.getcwd(), file=t)
                    print(xTools.get_machine_name(), file=t)
                    print(time.ctime(), file=t)
                    t.close()
                    return simrel_root, foo, simrel_family


def get_simrel_id(timeout_py_file):
    log_file = "x_simrel_flow.log"
    temp_log_file = "temp_log_file_for_getting_job_id"
    p_id = re.compile(r'jobid\s+?=\s*?(\d+)', re.I)
    job_id = None
    x = None
    for i in range(10):
        time.sleep(10)
        if not os.path.isfile(log_file):
            continue
        try:
            shutil.copy2(log_file, temp_log_file)
            x = xTools.simple_parser(temp_log_file, [p_id])
            os.remove(temp_log_file)
        except Exception:
            continue
        if x:
            job_id = x[1].group(1)
            break
    if not job_id:
        new_line = "# abnormal results. cannot find Simrel job id"
    else:
        new_line = 'os.system("nc stop {}")'.format(job_id)
    xTools.append_file(timeout_py_file, new_line)


def main(general_options, simrel_dirname, lst_type_name, sim_vendor_name, simrel_options, fixed_avc_file, lst_precision,
         tag_name, info_dirname=""):
    """
    current working directory is $top_dir/$design

    """
    xTools.say_it("")
    xTools.say_it("--------------------------------------")
    xTools.say_it("Start simrel flow .... [%s]" % time.ctime())
    design_path = os.getcwd()
    tag_path = os.path.join(design_path, tag_name)
    save_path = os.path.join(tag_path, "simrel")
    xTools.say_it("-- Starting copy and generate files in %s" % save_path)
    if not os.path.isdir(save_path):
        try:
            os.makedirs(save_path)
        except OSError:
            xTools.say_it("Error. Can not create path %s" % save_path)
            return 1

    lst_files = glob.glob(os.path.join(tag_path, lst_type_name, "*.lst"))
    pad_files = glob.glob(os.path.join(tag_path, "*", "*.pad"))
    rbt_files = glob.glob(os.path.join(tag_path, "*", "*.rbt"))
    ebrinit_value = simrel_options.get("ebrinit")
    if not pad_files:
        xTools.say_it("Error. Not found pad file under {}".format(tag_path))
        return 1
    if (not rbt_files) or ebrinit_value:
        pad_file_dirname = os.path.dirname(pad_files[0])
        _recov = xTools.ChangeDir(pad_file_dirname)
        prf_files = glob.glob("*.prf")

        cmd_args = {"bin_path": os.getenv("MY_B_BIN", "NoBinPath"),
                    "ncd_file": xTools.get_fname(pad_files[0])+".ncd",
                    "rbt_file": "temp.rbt",
                    "prf_file": prf_files[0],
                    "ebrinit": ""}
        if ebrinit_value:
            cmd_args["ebrinit"] = "-ebrinit %s" % ebrinit_value

        cmd = "%(bin_path)s/bitgen -g RamCfg:Reset -w %(ebrinit)s -b %(ncd_file)s %(rbt_file)s %(prf_file)s" % cmd_args
        xTools.run_command(cmd, "generate_rbt.log", "generate_rbt.time")
        rbt_files = [os.path.abspath(cmd_args.get("rbt_file"))]
        _recov.comeback()
    lst_file, pad_file = "", ""
    if lst_files:
        lst_file = lst_files[0]
        if pad_files:
            pad_file = pad_files[0]
    if (not lst_file) or (not pad_file):
        xTools.say_it("Error. Not found lst/pad file in %s" % tag_path)
        return 1
    dst_rbt = os.path.join(save_path, "fc.rbt")
    avc_file = os.path.join(save_path, "fc.avc")
    if xTools.wrap_cp_file(rbt_files[0], dst_rbt):
        return 1
    if fixed_avc_file:
        xTools.wrap_cp_file(fixed_avc_file, avc_file)
    elif generate_avc_file(avc_file, lst_file, pad_file, sim_vendor_name, simrel_options):
        return 1
    ###
    # generate svwf file
    svwf_file = os.path.join(os.path.dirname(avc_file), 'test.svwf')
    my_gen = pad2signal.GenerateFileSVWF(svwf_file, avc_file)
    my_gen.process()
    # -------------------------
    for prj in ("*.ldf", "*.rdf"):
        ldf_file_pattern = os.path.join(tag_path, prj)
        ldf_files = glob.glob(ldf_file_pattern)
        if ldf_files:
            break
    else:
        xTools.say_it("Error. Not found any ldf/rdf file in %s" % tag_path)
        return 1
    my_device = xTools.simple_parser(ldf_files[0], [re.compile('\s+device="([^"]+)"'), ])
    if not my_device:
        xTools.say_it("Error. Never got here. No device specified in ldf file.")
        return 1
    # simrel_root, branch_name, simrel_family = get_simrel_path(general_options, simrel_dirname, my_device[1].group(1))
    this_args = (general_options, simrel_dirname, my_device[1].group(1))
    temp_recov = xTools.ChangeDir(simrel_dirname)
    simrel_root, branch_name, simrel_family = None, None, None
    try:
        simrel_root, branch_name, simrel_family = filelock.safe_run_function(get_simrel_path, args=this_args)
    except:
        xTools.say_tb_msg()
        xTools.say_it("Failed to get simrel path")
    temp_recov.comeback()
    if not simrel_root:
        return 1
    # -----------------------------
    # ////////////////
    p_sentry_pty = re.compile("sentry_(\d+)")
    m_sentry_pty = p_sentry_pty.search(simrel_family)
    kw_sentry = dict()
    kw_sentry["sentry_pty"] = m_sentry_pty.group(1) if m_sentry_pty else "10000"
    src_file = ""
    dst_file = os.path.join(save_path, "tcl_ncv")
    tcl_ncv_file = simrel_options.get("tcl_ncv")
    if tcl_ncv_file:
        src_file = xTools.get_abs_path(tcl_ncv_file, info_dirname)
        if xTools.not_exists(src_file, "Customer tcl_ncv file"):
            src_file = ""
    if not src_file:
        if "sentry" in simrel_family:
            xTools.write_file(dst_file, TCL_NCV.format(**kw_sentry))
        elif "jedi_d1" in simrel_family:
            xTools.write_file(dst_file, TCL_NCV_JEDI_D1)
        elif "jedi" in simrel_family:
            xTools.write_file(dst_file, TCL_NCV_JEDI)
    else:
        xTools.wrap_cp_file(src_file, dst_file)

    # -------------------
    # --------- generate files
    _is_jedi_d1 = "jedi_d1_80k" in simrel_family
    _avc_dict = CHANGE_AVC_DICT_JEDI_D1 if _is_jedi_d1 else CHANGE_AVC_DICT
    _avc_template = AVC_CHANGE_FREQ_AVC_JEDI_D1 if _is_jedi_d1 else AVC_CHANGE_FREQ_AVC
    code = _avc_dict.get(lst_precision)
    if code:
        change_string = "{};  # change delay to {}ns"
    else:
        code = _avc_dict.get("5")
        change_string = "{};  # unknown lst_precision value: {}, use 5ns by default"
    change_string = change_string.format(code, lst_precision)
    xTools.write_file(os.path.join(save_path, "avc_change_freq.avc"), _avc_template % change_string)

    _ctl_file = simrel_options.get("ctl_file")
    use_original_ctl = 1
    final_ctl = os.path.join(save_path, "fc.ctl")
    if _ctl_file:  # use user ctl file
        _ctl_file = xTools.get_abs_path(_ctl_file, info_dirname)
        xTools.wrap_cp_file(_ctl_file, final_ctl)
        use_original_ctl = 0
    else:  # use default or original file
        if "sentry" in simrel_family:
            xTools.write_file(final_ctl, FC_CTL.format(**kw_sentry))
            use_original_ctl = 0

    check_log = os.path.join(simrel_root, branch_name, "check_running.log")
    timeout_py = xTools.win2unix(os.path.join(tag_path, "..", "_timeout.py"))
    xTools.append_file(timeout_py, ['os.remove("%s")' % xTools.win2unix(check_log), ""])

    my_simrel_path = os.path.join(simrel_root, branch_name, simrel_family)
    if not os.path.isdir(my_simrel_path):
        xTools.say_it("Error. Not found simrel_path:%s" % my_simrel_path)
        return 1
    xTools.say_it(" Found simrel path: %s" % my_simrel_path)
    thread_get_id = threading.Thread(target=get_simrel_id, args=(timeout_py, ))
    thread_get_id.setDaemon(True)
    thread_get_id.start()
    run_sim_ncv(general_options, my_simrel_path, save_path, simrel_options, use_original_ctl)
    if os.path.isfile(check_log):
        xTools.rm_with_error(check_log)


if __name__ == "__main__":
    generate_avc_file("test.avc", "dataset.lst", "top_impl.pad", "Riviera", dict())
