import os
import re
import glob
import time

import xTools

__author__ = 'syan'

def hex2bin_character(hex_char):
    """transfer hex character to bin string.

       :param hex_char: 0, 1, 2, ..., d, e, f, Others
       :return: 0000, 0001, 0010, ... 1101, ,1110, 1111, XXXX
    """
    try:
        dec = int(hex_char.upper(), 16)
    except ValueError:
        return "XXXX"
    return bin(dec)[2:].rjust(4, "0") # remove 0b

def hex2bin_string(hex_str, sim_vendor_name):
    if sim_vendor_name == "Riviera":
        hex_str = re.sub("[zZxX]", "X", hex_str)
        return hex_str

    p_skit_char = re.compile("[^\s;,_-]")
    hex_str = filter(p_skit_char.search, hex_str)
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
    title_dict = dict() # value: title, key: end index
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
                _keys = title_dict.keys()
                _keys.sort()
                keys = list()
                for item in _keys:
                    _t = title_dict[item]
                    m_lst_port = p_lst_port.search(_t)
                    if m_lst_port:
                        # /tb_mac_18x19/UUT/LD /tb_mac_18x19/UUT/OVERFLOW --> OVERFLOW
                        keys.append(m_lst_port.group(1))
                    else:
                        keys.append(_t)
            yield dict(zip(keys, line_list))

def get_pad_dict(pad_file):
    """
    :return: 'Q[10]' : {'': '', 'Buffer Type': 'LVCMOS25_OUT', 'BC Enable': '',
                        'Site': 'PL14A', 'Pin/Bank': 'D4/7', 'Port Name': 'Q[10]',
                        'Properties': 'DRIVE:8mA CLAMP:ON SLEW:SLOW'}
    """
    p_start = re.compile("^\|\s+Port\s+Name")
    p_split = re.compile("\s*\|\s*")
    title_keys = list()
    pad_dict = dict()
    for line in open(pad_file):
        line = line.strip()
        line_list = p_split.split(line)
        if title_keys:
            if not line:
                break
            t_dict = dict(zip(title_keys, line_list))
            port_name = t_dict.get("Port Name")
            if port_name:
                pad_dict[port_name] =  t_dict
        else:
            if p_start.search(line):
                title_keys = line_list
    return pad_dict

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
        else:
            port_name = item
        if not port_name in zipped_ports:
            zipped_ports.append(port_name)
            port_width.setdefault(port_name, 1)
        else:
            port_width[port_name] = port_width.get(port_name) + 1
    return zipped_ports, port_width

def get_in_out(sorted_ports, pad_dict, bidi_type):
    ports_in, ports_out = list(), list()
    for port_name in sorted_ports:
        pad_content = pad_dict.get(port_name)
        buffer_type = pad_content.get("Buffer Type")
        if re.search("_IN$", buffer_type):
            ports_in.append(port_name)
        elif re.search("_OUT$", buffer_type):
            ports_out.append(port_name)
        elif re.search("_BIDI$", buffer_type):
            if bidi_type == "in":
                ports_in.append(port_name)
            elif bidi_type == "out":
                ports_out.append(port_name)
            else:
                xTools.say_it("Warning. Cannot deal with BIDI port!")
                return "", ""
        else:
            xTools.say_it("Warning. Cannot deal with Buffer Type: %s" % buffer_type)
            return "", ""
    return ports_in, ports_out


def get_avc_bin_code(lst_data, ports_in, ports_out, sim_vendor_name):
    zipped_in, ports_in_width= get_zipped_ports(ports_in)
    zipped_out, ports_out_width= get_zipped_ports(ports_out)
    def get_code(ports_list, ports_width):
        _code = list()
        for _port in ports_list:
            bin_code = hex2bin_string(lst_data.get(_port), sim_vendor_name)
            code_width = ports_width.get(_port)
            #
            real_width = len(bin_code)
            if real_width == code_width:
                pass
            elif real_width > code_width:
                start_pos = 0 -  code_width
                bin_code = bin_code[start_pos:]
            else:
                bin_code = "0" * (code_width - real_width) + bin_code
            _code.append(bin_code)
        return _code

    code_in = "".join(get_code(zipped_in, ports_in_width))
    code_out = "".join(get_code(zipped_out, ports_out_width))

    # code_in: set as 0 for non-0 and non-1
    # code_out: 1 -> H, 0 -> L, Others -> X
    code_in = re.sub("X", "0", code_in)
    code_out = re.sub("0", "L", code_out)
    code_out = re.sub("1", "H", code_out)
    return "r1 name  %s%s;" % (code_in, code_out)


def generate_simvision_tcl_file(simvision_tcl_file, ports_in, ports_out, pad_dictionary):
    def __get_port_site(ports, pad_dict):
        port_site_dict = dict()
        p_port_name = re.compile('\[\d+\]')
        for item in ports:
            new_name = p_port_name.sub("", item)
            site = "fc_tb." + pad_dict.get(item).get("Site").lower()
            if port_site_dict.has_key(new_name):
                port_site_dict[new_name].append(site)
            else:
                port_site_dict.setdefault(new_name, [site])

        t_lines = list()
        # for key, value in port_site_dict.items():
        keys = port_site_dict.keys()
        keys.sort()
        for key in keys:
            value = port_site_dict.get(key)
            value_lens = len(value)
            if value_lens == 1:
                t_lines.append("# %s" % key)
                _sig = value[0]
            else:
                t_lines.append("# %s[%d:0]" % (key, value_lens-1))
                _sig = '{ %s }' % " ".join(value)
            t_lines.append('waveform add -at top -signals %s -using "Waveform 1"' % _sig)
        return t_lines

    tcl_lines = list()
    tcl_lines.append("# /// INPUTS")
    tcl_lines += __get_port_site(ports_in, pad_dictionary)

    tcl_lines.append("")
    tcl_lines.append("# /// OUTPUTS")
    tcl_lines += __get_port_site(ports_out, pad_dictionary)
    xTools.write_file(simvision_tcl_file, tcl_lines)


def generate_avc_file(avc_file, lst_file, pad_file, sim_vendor_name, bidi_type):
    pad_dict = get_pad_dict(pad_file)
    sorted_ports = get_sorted_ports(pad_dict.keys())
    ports_in, ports_out = get_in_out(sorted_ports, pad_dict, bidi_type)
    if not ports_in:
        return 1
    # print sorted_ports
    # print ports_in, ports_out
    # print pad_dict
    tcl_file = os.path.join(os.path.dirname(avc_file), "run_simvision.tcl")
    generate_simvision_tcl_file(tcl_file, ports_in, ports_out, pad_dict)
    avc_ob = open(avc_file, "w")
    print >> avc_ob, "#  port name in design"
    ports_in_out = ports_in + ports_out
    print >> avc_ob, "# %s" % "   ".join(ports_in_out)
    print >> avc_ob, "format    %s ;" % "  ".join([pad_dict.get(item).get("Site").lower() for item in ports_in_out])
    lst_dict = get_lst_dict(lst_file)
    for item in lst_dict:
        ps = item.get("ps")
        if not ps: 
            fs = item.get("fs")
            if not fs:
                continue
        avc_bin_code = get_avc_bin_code(item, ports_in, ports_out, sim_vendor_name)
        print >> avc_ob, avc_bin_code
    avc_ob.close()

# --------------------------
# END OF PUBLIC FUNCTIONS
# --------------------------
def run_sim_ncv(simrel_dir, rbt_avc_folder):
    xTools.say_it(" -- Go to %s and run SimREL flow ..." % simrel_dir)
    _recov = xTools.ChangeDir(simrel_dir)
    src_files = ("fc.avc", "fc.rbt")
    temp_sh_file = "temp.sh"
    dst_files = ("fc.log", "fc.out", "irun.log", temp_sh_file)
    temp_sh = open(temp_sh_file, "w")
    for _file in (src_files + dst_files[:-1]):
        print >> temp_sh, "rm %s" % _file
    for _file in src_files:
        print >> temp_sh, "ln -s %s/%s %s" % (rbt_avc_folder, _file, _file)
    print >> temp_sh, "sim_ncv"
    temp_sh.close()
    sts = os.system("sh %s" % temp_sh_file)    
    if sts:
        xTools.say_it("Failed to run simrel flow...")
        return sts
    # copy files
    t_copy = open("copy_files", "w")
    for _file in dst_files:
        print >> t_copy,  "cp -f %s %s/." % (_file, rbt_avc_folder)        
    print >> t_copy, "cp -rf outwaves %s/outwaves" % rbt_avc_folder
    t_copy.close()
    # execute it!
    sts = os.system("sh copy_files")        
    _recov.comeback()
    
def get_simrel_path(simrel_dirname, device):
    device = device.lower()
    p = re.compile("LFE5UM-(\d+)F", re.I)
    m = p.search(device)
    simrel_root, simrel_family = simrel_dirname, ""
    if m:
        simrel_family = os.path.join("sapphire", "sa_%sh" % m.group(1), "ncv")
    elif re.search("lif-", device):
        simrel_family = os.path.join("snow", "snow_5", "ncv")
    else:
        xTools.say_it("Error. Unknown device: %s" % device)
        return "", "", ""

    while True:
        xTools.say_it(" -- Searching real simrel path ...")
        time.sleep(5)
        for foo in os.listdir(simrel_root):
            abs_foo = os.path.join(simrel_root, foo)
            if os.path.isdir(abs_foo):
                check_file = os.path.join(abs_foo, "check_running.log")
                if os.path.isfile(check_file):
                    continue
                else:
                    t = open(check_file, "w")
                    t.close()
                    return simrel_root, foo, simrel_family


def main(simrel_dirname, lst_type_name, sim_vendor_name, bidi_type):
    """
    current working directory is $top_dir/$design

    """
    xTools.say_it("")
    xTools.say_it("--------------------------------------")
    xTools.say_it("Start simrel flow .... [%s]" % time.ctime())
    design_path = os.getcwd()
    tag_path = os.path.join(design_path, "_scratch")
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

    if generate_avc_file(avc_file, lst_file, pad_file, sim_vendor_name, bidi_type):
        return 1
    # -------------------------
    ldf_file_pattern = os.path.join(tag_path, "*.ldf")
    ldf_files = glob.glob(ldf_file_pattern)
    if not ldf_files:
        xTools.say_it("Error. Not found any ldf file in %s" % tag_path)
        return 1
    my_device = xTools.simple_parser(ldf_files[0], [re.compile('\s+device="([^"]+)"'), ])
    if not my_device:
        xTools.say_it("Error. Never got here. No device specified in ldf file.")
        return 1
    # -----------------------------

    simrel_root, branch_name, simrel_family = get_simrel_path(simrel_dirname, my_device[1].group(1))
    if not simrel_root:
        return 1
    my_simrel_path = os.path.join(simrel_root, branch_name, simrel_family)
    if not os.path.isdir(my_simrel_path):
        xTools.say_it("Error. Not found simrel_path:%s" % my_simrel_path)
        return 1
    xTools.say_it(" Found simrel path: %s" % my_simrel_path)
    run_sim_ncv(my_simrel_path, save_path)

    check_log = os.path.join(simrel_root, branch_name, "check_running.log")
    if os.path.isfile(check_log):
        xTools.rm_with_error(check_log)


if __name__ == "__main__":
    pass
