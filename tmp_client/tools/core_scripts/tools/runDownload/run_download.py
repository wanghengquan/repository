import os
import re
import sys
import glob
import optparse
from xlib import xTools

__author__ = 'syan'

def get_zipped_ports(raw_ports):
    _port_list = list()
    _port_dict = dict()
    for item in raw_ports:
        new_port = re.sub("\[\d+\]", "", item)
        lens = _port_dict.get(new_port)
        if lens:
            _port_dict[new_port] = lens + 1
        else:
            _port_dict[new_port] = 1
            _port_list.append(new_port)
    return [(item, _port_dict.get(item)) for item in _port_list]

def get_vertical_sites_from_ports(ports, ports_dict):
    """
    Maximum sites length is 7
    :param ports:
    :param ports_dict:
    :return:
    """
    longest_site = 7
    sites = list()
    for port in ports:
        _dict = ports_dict.get(port)
        _site = _dict.get("Site")
        sites.append(_site)
    target_sites = list()
    for i in range(longest_site):
        _list = list()
        for foo in sites:
            try:
                _char = foo[i]
            except IndexError:
                _char = " "
            _list.append(_char)
        target_sites.append(_list)
    return target_sites

class ParseFilePAD:
    """Parse pad file
    return pad_dict
           ports_in
           ports_out
    """
    def __init__(self, pad_file, bidi_as):
        self.pad_file = pad_file
        self.bidi_as = bidi_as

        self.pad_dict = dict()
        self.ports_in = list()
        self.ports_out = list()

        # | Port Name | Pin/Bank | Buffer Type  | Site  | ...
        self.p_port_title = re.compile("^\|\s+Port\s+Name")
        self.p_port_split = re.compile("\s*\|\s*")
        self.p_port_digital = re.compile("(\d+)")

        self.sts = self._process()

    def _process(self):
        if xTools.not_exists(self.pad_file, "pad file"):
            return 1
        self.__create_pad_dict()
        if self.__create_ports():
            return 1

    def __create_pad_dict(self):
        """
        +-----------+----------+--------------+-------+-----------+-----------------------------------+
        | Port Name | Pin/Bank | Buffer Type  | Site  | BC Enable | Properties                        |
        +-----------+----------+--------------+-------+-----------+-----------------------------------+
        | Aclr      | N16/8    | LVCMOS25_IN  | PB4B  |           | PULL:DOWN CLAMP:ON HYSTERESIS:ON  |
        | Clk_En    | G3/3     | LVCMOS25_IN  | PR29B |           | PULL:DOWN CLAMP:ON HYSTERESIS:ON  |
        | Clock     | B10/0    | LVCMOS25_IN  | PT29A |           | PULL:DOWN CLAMP:ON HYSTERESIS:ON  |
        | Q[0]      | F1/3     | LVCMOS25_OUT | PR35C |           | DRIVE:8mA CLAMP:ON SLEW:SLOW      |
        :return: dictionary, key: Port name
        """
        title_keys = list()
        for line in open(self.pad_file):
            line = line.strip()
            line_list = self.p_port_split.split(line)
            if not title_keys:
                if self.p_port_title.search(line):
                    title_keys = line_list
            else: # found title
                if not line:
                    break # break here
                t_dict = dict(zip(title_keys, line_list))
                port_name = t_dict.get("Port Name") # must has_key "Port Name"
                if port_name:
                    self.pad_dict[port_name] =  t_dict

    def __create_ports(self):
        """
        1. sorted all ports get like: A[4],A[3],...,A[0],CLK,DATA[31],DATA[30],...DATA[0],RST
        2. get input and output port list
        """
        def _new_key(raw_key):
            pieces = self.p_port_digital.split(raw_key)
            pieces[1::2] = map(int, pieces[1::2])
            return pieces
        sorted_ports = sorted(self.pad_dict.keys(), key=_new_key, reverse=True)
        for pn in sorted_ports:
            port_content = self.pad_dict.get(pn)
            buffer_type = port_content.get("Buffer Type")
            if buffer_type.endswith("_IN"):
                self.ports_in.append(pn)
            elif buffer_type.endswith("_OUT"):
                self.ports_out.append(pn)
            elif buffer_type.endswith("_BIDI"):
                if self.bidi_as == "in":
                    self.ports_in.append(pn)
                elif self.bidi_as == "out":
                    self.ports_out.append(pn)
                else:
                    xTools.say_it("Warning. Found BIDI port name: %s" % pn)
                    return 1
            else:
                xTools.say_it("Error. Not support Buffer Type: %s" % buffer_type)
                return 1

def get_position_value_dict(raw_string):
    """ create a dictionary to record the string position
    :param raw_string: '                   /tb_barrel_shifter_9_1_0_0/Reset            /tb_barrel_shifter_9_1_0_0/index'
    :return:{51: '/tb_barrel_shifter_9_1_0_0/Reset', 95: '/tb_barrel_shifter_9_1_0_0/index'}
    """
    raw_list = re.split("(\s+)", raw_string)
    position = 0
    pv_dict = dict()
    for item in raw_list:
        position += len(item)
        item = item.strip()
        if not item:
            continue
        pv_dict[position] = item
    return pv_dict

def get_lst_dict(lst_file):
    ports_dict = dict()
    p_start_data = re.compile("^\s+\d+\s+")
    start_mark = 0
    p_lst_port = re.compile("/([^/]+)$")
    for line in open(lst_file):
        line = line.rstrip()
        if not line:
            continue
        line_dict = get_position_value_dict(line)
        if not start_mark:
            start_mark = p_start_data.search(line)
        if not start_mark:
            ports_dict.update(line_dict)
        else:
            t_dict = dict()
            for key, value in ports_dict.items(): # key: position, value: port name
                m = p_lst_port.search(value)
                if m:
                    t_dict[m.group(1)] = line_dict.get(key)
            yield t_dict

def _is_a_file(file_string, default_path, comments):
    if not file_string:
        xTools.say_it("Error. no value for %s" % comments)
        return
    if os.path.isfile(file_string):
        return os.path.abspath(file_string)
    else:
        file_string = xTools.get_abs_path(file_string, default_path)
        if xTools.not_exists(file_string, comments):
            return
        return file_string

def hex2bin_character(hex_char):
    """transfer hex character to bin string.

       :param hex_char: 0, 1, 2, ..., d, e, f, Others
       :return: 0000, 0001, 0010, ... 1101, ,1110, 1111, XXXX
    """
    try:
        dec = int(hex_char, 16)
    except ValueError:
        return "XXXX"
    return bin(dec)[2:].rjust(4, "0") # remove 0b

def hex2bin_string(hex_str, is_bin):
    if is_bin:
        hex_str = re.sub("[zZxX]", "X", hex_str)
        return hex_str

    p_skit_char = re.compile("[^\s;,_-]")
    hex_str = filter(p_skit_char.search, hex_str)
    bin_string = "".join(map(hex2bin_character, hex_str))
    if bin_string[0] == "X":
        prefix = "X"
    else:
        prefix = "0"
    return prefix * 30 + bin_string


def get_bin_data(zipped_ports, raw_lst, is_bin, is_input):

    bin_data = list()
    for (port_name, width) in zipped_ports:
        raw_data = raw_lst.get(port_name)
        if not raw_data:
            xTools.say_it("Error. Please check Port Name: %s" % port_name)
            return 1, bin_data
        raw_bin_data = hex2bin_string(raw_data, is_bin)
        if not is_input:
            raw_bin_data =  re.sub("1", "H", raw_bin_data)
            raw_bin_data = re.sub("[^H]", "L", raw_bin_data)
        bin_data.append(raw_bin_data[-width:])
    return 0, bin_data

class RunDownload:
    def __init__(self):
        __xlib = os.path.join( os.path.dirname(sys.argv[0]), "xlib")
        self.xlib = os.path.abspath(__xlib)
        self.p_sim_log = re.compile("^run_sim_.*\.log")
        self.p_riviera = re.compile("Aldec,\s+Inc\.\s+Riviera")

    def process(self):
        xTools.say_it("--Start Generating Download files...")
        self.run_option_parser()
        if self.sanity_check():
            return 1

        for i, design in enumerate(self.designs):
            xTools.say_it("  <%03d> Design:%s" % (i, design))
            self.dsn = design
            self.run_a_design()
        xTools.say_it("--Successfully generating the download files.")

    def run_option_parser(self):
        _cwd = os.getcwd()
        _makejdv = "makejdv.exe"
        _lst_list = ("sim_rtl", "sim_map_vlg", "sim_par_vlg", "sim_map_vhd", "sim_par_vhd")
        _bidi_as_list = ("in", "out")
        parser = optparse.OptionParser()
        parser.add_option("--debug", action="store_true", help="print debug message")
        parser.add_option("--top-dir", default=_cwd, help="specify top results path, default is %s" % _cwd)
        parser.add_option("--design", help="specify design name, if not specified, all folders under $top_dir "
                                           "will be treated as a design name")
        parser.add_option("--makejdv", default=_makejdv, help="specify makejdv.exe file, "
                          "default is %s, default dirname is %s" % (_makejdv, self.xlib) )
        parser.add_option("--package", help="specify package file, default dirname is %s" % self.xlib)
        parser.add_option("--target-dir", default=_cwd, help="specify target path for download test, default is %s" % _cwd)
        parser.add_option("--verbose", action="store_true", help="copy more files to target path")
        parser.add_option("--step", type="int", help="specify lst line window width")
        parser.add_option("--lineno", type="int", help="specify the maximum data number in jdv file")
        parser.add_option("--lst-from", type="choice", default=_lst_list[0], choices=_lst_list,
                          help="specify lst file type. default is %s" % _lst_list[0])
        parser.add_option("--bidi-as", type="choice", choices=_bidi_as_list,
                          help="treat bidi port as %s" % "/".join(_bidi_as_list))
        opts, args = parser.parse_args()

        self.debug = opts.debug
        self.top_dir = opts.top_dir
        self.design = opts.design
        self.makejdv = opts.makejdv
        self.package = opts.package
        self.target_dir = opts.target_dir
        self.verbose = opts.verbose
        self.step = opts.step
        self.lineno = opts.lineno
        self.lst_from = opts.lst_from
        self.bidi_as = opts.bidi_as
        xTools.say_it(eval(str(opts)), "Raw Options:", self.debug)

    def sanity_check(self):
        if xTools.not_exists(self.top_dir, "top result path"):
            return 1
        # get designs
        self.designs = list()
        if self.design:
            self.designs.append(self.design)
        else:
            for foo in os.listdir(self.top_dir):
                check_folder = os.path.join(self.top_dir, foo, "_scratch")
                if os.path.isdir(check_folder):
                    self.designs.append(foo)
            if not self.designs:
                xTools.say_it("Error. Not found any designs in %s" % self.top_dir)
                return 1
        self.makejdv = _is_a_file(self.makejdv, self.xlib, "MAKEJDV EXE FILE")
        self.package = _is_a_file(self.package, self.xlib, "PACKAGE FILE")
        if not self.makejdv:
            return 1
        if not self.package:
            return 1
        if xTools.wrap_md(self.target_dir, "Target Path"):
            return 1
        self.target_dir = os.path.abspath(self.target_dir)

    def run_a_design(self):
        if self.get_lst_file():
            return 1
        if self.get_other_files():
            return 1
        if self.parse_pad_file():
            return 1
        self.lst_dict = get_lst_dict(self.lst_file)
        if self.generate_sim_file():
            return 1
        self.copy_files()

    def parse_pad_file(self):
        pad_parser = ParseFilePAD(self.pad_file, self.bidi_as)
        if pad_parser.sts:
            return 1
        self.ports_in, self.ports_out = pad_parser.ports_in, pad_parser.ports_out
        self.pad_dict = pad_parser.pad_dict
        xTools.say_it(self.pad_dict, "PAD dictionary:", self.debug)
        xTools.say_it(self.ports_in, "INPUT ports:", self.debug)
        xTools.say_it(self.ports_out, "OUTPUT ports:", self.debug)

    def get_lst_file(self):
        sim_dir = os.path.join(self.top_dir, self.dsn, "_scratch", self.lst_from)
        if xTools.not_exists(sim_dir, "simulation result path"):
            return 1
        self.is_riviera = 0
        self.lst_file = ""
        for foo in os.listdir(sim_dir):
            abs_foo = os.path.join(sim_dir, foo)
            if not self.is_riviera:
                if self.p_sim_log.search(foo):
                    self.is_riviera = xTools.simple_parser(abs_foo, [self.p_riviera,])
                    if self.is_riviera:
                        self.is_riviera = 1
            if foo.lower().endswith(".lst"):
                self.lst_file = abs_foo
        if not self.lst_file:
            xTools.say_it("Error. Not found lst file in %s" % sim_dir)
            return 1
        xTools.say_it("LST File: %s" % self.lst_file, "", self.debug)

    def get_other_files(self):
        impl_pattern = os.path.join(self.top_dir, self.dsn, "_scratch", "*", "*.dir")
        impl_folder = glob.glob(impl_pattern)
        if not impl_folder:
            xTools.say_it("Error. Not found implementation folder like %s" % impl_pattern)
            return 1
        self.basic_impl = os.path.splitext(impl_folder[0])[0]
        xTools.say_it("Basic Implementation string: %s" % self.basic_impl, "", self.debug)
        self.pad_file = self.basic_impl + ".pad"
        if xTools.not_exists(self.pad_file, "pad file"):
            return 1

    def generate_sim_file(self):
        self.final_dir = os.path.join(self.target_dir, self.dsn)
        if xTools.wrap_md(self.final_dir, "Dump Folder"):
            return 1
        self.target_sim_file = os.path.join(self.final_dir, "%s.sim" % os.path.basename(self.basic_impl))
        sim_lines = list()
        # ////////////////
        anchor_a = " " * 5
        anchor_b = " " * 5
        anchor_c = " " * 10
        init_length = 4
        ports_in_len = len(self.ports_in)
        ports_out_len = len(self.ports_out)
        # more
        total_blanks = anchor_a + " "* init_length + anchor_b
        # ////////////////
        sim_lines.append(total_blanks + "inputs".ljust(ports_in_len) + anchor_c + "outputs")
        vertical_sites_in = get_vertical_sites_from_ports(self.ports_in, self.pad_dict)
        vertical_sites_out = get_vertical_sites_from_ports(self.ports_out, self.pad_dict)
        for i, vsi in enumerate(vertical_sites_in):
            vso = vertical_sites_out[i]
            if vsi.count(" ") == len(vsi) and vso.count(" ") == len(vso):
                break
            sim_lines.append(total_blanks + "".join(vsi) + anchor_c + "".join(vso))
        sim_lines.append("-" * len(total_blanks) +  "B" * ports_in_len + "-" * len(anchor_c) + "B" * ports_out_len)
        sim_lines.append("-" * len(anchor_a) + "init" + " " * len(anchor_b) +  "x" * ports_in_len + "-" * len(anchor_c) + "x" * ports_out_len)
        # ///////////////////
        _lineno = -1
        real_lineno = -1
        for lst_content in self.lst_dict:
            _lineno += 1
            if self.step:
                if _lineno % self.step:
                    continue
            if self.lineno:
                if real_lineno == self.lineno:
                    break
            sts, data_in = get_bin_data(get_zipped_ports(self.ports_in), lst_content, self.is_riviera, is_input=True)
            if sts:
                return 1
            sts, data_out = get_bin_data(get_zipped_ports(self.ports_out), lst_content, self.is_riviera, is_input=False)
            if sts:
                return 1
            real_lineno += 1
            if not real_lineno:
                continue
            new_line = anchor_a + str(real_lineno).rjust(init_length) + anchor_b + "".join(data_in) + anchor_c + "".join(data_out)
            sim_lines.append(new_line)
        xTools.write_file(self.target_sim_file, sim_lines)

    def copy_files(self):
        for fext in (".rbt", ".jed", ".bit"):
            src_file = self.basic_impl + fext
            if os.path.isfile(src_file):
                dst_file = os.path.join(self.final_dir, os.path.basename(src_file))
                if xTools.wrap_cp_file(src_file, dst_file):
                    return 1
        if self.verbose:
            for src in (self.lst_file, self.pad_file):
                dst = os.path.join(self.final_dir, os.path.basename(src))
                if xTools.wrap_cp_file(src, dst):
                    return 1

        _recov = xTools.ChangeDir(self.final_dir)
        # makejdv.exe   bsdllcmxo2-1200zehetqfp144.package AND2_8_FD1P3AX.sim   AND2_8_FD1P3AX.pinlist AND2_8_FD1P3AX.jdv xxxxx 0
        bn = os.path.basename(self.basic_impl)
        cmd = "%s %s %s.sim %s.pinlist %s.jdv  csBGA_132 0" % (self.makejdv, self.package, bn, bn, bn)
        xTools.run_command(cmd, "_run.log", "_run.time")
        _recov.comeback()

if __name__ == "__main__":
    my_run = RunDownload()
    my_run.process()


