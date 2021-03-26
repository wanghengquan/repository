""" run simulation flow with simrel.

--- Situation ---
SFang has already have the scripts for the simrel test flow.
1. convert_simrel_format.py to generate the avc file and prepare the simrel input files
2. launch shell script to run simulation flow and copy the result files to a dedicated
   path.

--- Task ---
compile a post-process scripts to run simrel, which can be used in BQS scripts.

--- Action ---
1. execute SFang's scripts to generate the avc file in _scratch/simrel folder
2. execute SFang's scripts to copy and rename the rbt file
3. parse the device from ldf file
4. get the simrel execution path by device name
5. generate the shell script to remove old files, link new files, run simrel
   and copy back results files to _scratch/simrel folder

--- Result ---
run simrel and copy results log to _scratch/simrel folder.


Usage:
python2.7 ../DEV/bin/run_lattice.py --file=../local.ini --top-dir=xxx --design=xxx

# file local.ini
[qa]
set_strategy= <{bit_out_format=Raw Bit File (ASCII)}>
post_process= ./run_simrel.py
diamond_lin = /public/install/diamond/3.7_x64
modelsim_path = /tools/dist/mentor/modelsim/10.1/modeltech/bin

run_modelsim = 1
sim_rtl = 1
run_export_bitstream = 1
synthesis = synplify

[environment]
BQS_SIMREL = /disks/qa_van/strdom/simrel
; default value is sim_rtl
; ; BQS_LST_TYPE = sim_map_vlg
; BQS_LST_TYPE = sim_rtl

-----------------
Tips:
   --file=../../local.ini : should be the relative path of executing path
   post_process=./run_simrel.py  : must in $design_path
   environment are used to specify the simrel path and lst file's type

"""


import os
import re
import sys
import time
import glob
import stat
import shutil
import configparser

__author__ = 'syan'


KEY_BQS_SIMREL = "BQS_SIMREL"
KEY_BQS_LST_TYPE = "BQS_LST_TYPE"
# --------------------------
# PUBLIC FUNCTIONS
# --------------------------

def say_it(msg):
    print(msg)

def wrap_cp_file(src, dst, force=True):
    """
    copy a file
    """
    abs_src = os.path.abspath(src)
    abs_dst = os.path.abspath(dst)
    if abs_src == abs_dst:
        return

    try:
        if os.path.isfile(abs_dst):
            if not force:
                return
            os.chmod(abs_dst, stat.S_IRWXU)
            os.remove(abs_dst)
        shutil.copy2(abs_src, abs_dst)
    except Exception as e:
        say_it("- Error. Not copy %s to %s" % (src, dst))
        say_it("- %s" % e)
        return 1

class ChangeDir:
    """change the current working directory to a new path.
       and can come back to the original current working directory
    """
    def __init__(self, new_path):
        self.cur_dir = os.getcwd()
        os.chdir(new_path)
    def comeback(self):
        os.chdir(self.cur_dir)

class ElapsedTime:
    """get elapsed time and timestamp
    """
    def __init__(self):
        self.etime = 0
    def get_play_time(self): return self.play_time
    def get_stop_time(self): return self.stop_time
    def play(self):
        self.play_time = time.ctime()
        self.start_time = time.time()
    def stop(self):
        self.stop_time = time.ctime()
        self.etime = time.time() - self.start_time
    def __str__(self):
        return "Elapsed Time: %.2f seconds" % self.etime

class AppConfig(configparser.ConfigParser):
    def __init__(self):
        configparser.ConfigParser.__init__(self)

    def optionxform(self, optionstr):
        """
        re-define optionxform, in the release version, return optionstr.lower()
        """
        return optionstr

def get_conf_options(conf_files, key_lower=True):
    """get configuration from conf_files, conf_files can be a file or a file list
       all option will not change the case when key_lower is False
    """
    # use <xx> <yy> ... to specify a list string for an option.
    p_multi = re.compile("<([^>]+)>")
    conf_options = dict()
    if key_lower:
        conf_parser = configparser.ConfigParser()
    else:
        conf_parser = AppConfig()
    try:
        conf_parser.read(conf_files)
        for section in conf_parser.sections():
            t_section = dict()
            for option in conf_parser.options(section):
                value = conf_parser.get(section, option)
                value_list = p_multi.findall(value)
                if value_list:
                    value = [item.strip() for item in value_list]
                t_section[option] = value
            conf_options[section] = t_section
        return 0, conf_options
    except Exception as e:
        print(("Error. Can not parse configuration file(s) %s" % conf_files))
        print(e)
        return 1, ""

def get_file_line_count(a_file):
    """get the line number of a file
    """
    count = -1
    try:
        for count, line in enumerate(open(a_file, "rU")):
            pass
    except IOError:
        pass
    count += 1
    return count

def simple_parser(a_file, patterns, but_lines=0):
    """simple parser for a file with patterns
       return results if a pattern is matched!
       but_lines means only search the last $but_lines content.
    """
    file_lines_number = get_file_line_count(a_file)
    if not file_lines_number:
        return
    start_line = 0
    if but_lines:
        start_line = file_lines_number - but_lines
    i = 0
    for line in open(a_file):
        i += 1
        if line < start_line:
            continue
        line = line.strip()
        for p in patterns:
            m = p.search(line)
            if m:
                return line, m
    return

def hex2bin_character(hex_char):
    """transfer hex character to bin string.

       :param hex_char: 0, 1, 2, ..., d, e, f, Others
       :return: 0000, 0001, 0010, ... 1101, ,1110, 1111, XXXX
    """
    try:
        dec = int(hex_char.upper(), 16)
    except ValueError:
        return "XXXX"
    return bin(dec)[2:].rjust(4, "0")

def hex2bin_string(hex_str):
    """transfer hex string to bin string.
    wrapper of hex2bin_character().
    """
    skip_chars = (" ", "_", ",", ";")
    bin_list = list()
    for item in hex_str:
        if item in skip_chars:
            continue
        bin_list.append(hex2bin_character(item))
    return "".join(bin_list)

def get_status_output(cmd):
    """
    return (status, output) of executing cmd in a shell.
    source from commands.py <def getstatusoutput(cmd)>.
    """
    on_win = (sys.platform[:3] == "win")
    if not on_win:
        cmd = "{ " + cmd + "; }"
    pipe = os.popen(cmd + " 2>&1", "r")
    text = list()
    for item in pipe:
        text.append(item.rstrip())
    try:
        sts = pipe.close()
        if sts is None: sts = 0
        if not on_win:
            sts = (sts >> 8)
    except IOError:
        sts = 1
    if sts is None: sts = 0
    return sts, text

def _get_end_index(raw_string, my_string):
    try:
        start_index = raw_string.index(my_string)
    except ValueError:
        raise ValueError("Cannot get index for '%s' from '%s'" % (my_string, raw_string.strip()))
    return start_index + len(my_string)

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
            for item in line_list:
                title_dict[_get_end_index(line, item)] = item
        else:
            if not keys:
                _keys = list(title_dict.keys())
                _keys.sort()
                keys = list()
                for item in _keys:
                    _t = title_dict[item]
                    m_lst_port = p_lst_port.search(_t)
                    if m_lst_port:
                        keys.append(m_lst_port.group(1))
                    else:
                        keys.append(_t)
            yield dict(list(zip(keys, line_list)))

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
            t_dict = dict(list(zip(title_keys, line_list)))
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

def get_in_out(sorted_ports, pad_dict):
    ports_in, ports_out = list(), list()
    for port_name in sorted_ports:
        pad_content = pad_dict.get(port_name)
        buffer_type = pad_content.get("Buffer Type")
        if re.search("_IN$", buffer_type):
            ports_in.append(port_name)
        elif re.search("_OUT$", buffer_type):
            ports_out.append(port_name)
        else:
            print("Warning. Found Buffer Type: %s" % buffer_type)
            return "", ""
    return ports_in, ports_out


def get_avc_bin_code(lst_data, ports_in, ports_out):
    zipped_in, ports_in_width= get_zipped_ports(ports_in)
    zipped_out, ports_out_width= get_zipped_ports(ports_out)
    def get_code(ports_list, ports_width):
        _code = list()
        for _port in ports_list:
            bin_code = hex2bin_string(lst_data.get(_port))
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

def generate_avc_file(avc_file, lst_file, pad_file):
    pad_dict = get_pad_dict(pad_file)
    sorted_ports = get_sorted_ports(list(pad_dict.keys()))
    ports_in, ports_out = get_in_out(sorted_ports, pad_dict)
    if not ports_in:
        return 1
    avc_ob = open(avc_file, "w")
    print("#  port name in design", file=avc_ob)
    ports_in_out = ports_in + ports_out
    print("# %s" % "   ".join(ports_in_out), file=avc_ob)
    print("format    %s ;" % "  ".join([pad_dict.get(item).get("Site").lower() for item in ports_in_out]), file=avc_ob)
    lst_dict = get_lst_dict(lst_file)
    for item in lst_dict:
        ps = item.get("ps")
        if not ps: continue
        avc_bin_code = get_avc_bin_code(item, ports_in, ports_out)
        print(avc_bin_code, file=avc_ob)
    avc_ob.close()

# --------------------------
# END OF PUBLIC FUNCTIONS
# --------------------------
def run_sim_ncv(simrel_dir, rbt_avc_folder):
    print(" -- Go to %s and run SimREL flow ..." % simrel_dir)
    _recov = ChangeDir(simrel_dir)
    src_files = ("fc.avc", "fc.rbt")
    temp_sh_file = "temp.sh"
    dst_files = ("fc.log", "fc.out", "irun.log", temp_sh_file)
    temp_sh = open(temp_sh_file, "w")
    for _file in (src_files + dst_files):
        print("rm %s" % _file, file=temp_sh)
    for _file in src_files:
        print("ln -s %s/%s %s" % (rbt_avc_folder, _file, _file), file=temp_sh)
    print("sim_ncv", file=temp_sh)
    for _file in dst_files:
        print("cp %s %s/." % (_file, rbt_avc_folder), file=temp_sh)
    temp_sh.close()

    sts = os.system("sh %s" % temp_sh_file)
    _recov.comeback()
    if sts:
        say_it("Failed to run simrel flow...")
        return sts


def get_simrel_path(simrel_dirname, device):
    device = device.lower()
    p = re.compile("LFE5UM-(\d+)F", re.I)
    m = p.search(device)
    if m:
        return os.path.join(simrel_dirname, "sapphire", "sa_%sh" % m.group(1), "ncv")
    elif re.search("lif-", device):
        return os.path.join(simrel_dirname, "snow", "ncv")


def main(simrel_dirname, lst_type_name):
    """
    current working directory is $top_dir/$design

    """
    print("")
    print("--------------------------------------")
    print("Start simrel flow .... [%s]" % time.ctime())
    design_path = os.getcwd()
    tag_path = os.path.join(design_path, "_scratch")
    save_path = os.path.join(tag_path, "simrel")
    print("-- Starting copy and generate files in %s" % save_path)
    if not os.path.isdir(save_path):
        try:
            os.makedirs(save_path)
        except OSError:
            print(("Error. Can not create path %s" % save_path))
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
        print(("Error. Not found lst/pad file in %s" % tag_path))
        return 1
    dst_rbt = os.path.join(save_path, "fc.rbt")
    avc_file = os.path.join(save_path, "fc.avc")
    if wrap_cp_file(rbt_files[0], dst_rbt):
        return 1

    if generate_avc_file(avc_file, lst_file, pad_file):
        return 1
    # -------------------------
    ldf_file_pattern = os.path.join(tag_path, "*.ldf")
    ldf_files = glob.glob(ldf_file_pattern)
    if not ldf_files:
        print(("Error. Not found any ldf file in %s" % tag_path))
        return 1
    my_device = simple_parser(ldf_files[0], [re.compile('\s+device="([^"]+)"'), ])
    if not my_device:
        print("Error. Never got here. No device specified in ldf file.")
        return 1
    # -----------------------------

    simrel_path = get_simrel_path(simrel_dirname, my_device[1].group(1))
    if not simrel_path:
        return 1
    if not os.path.isdir(simrel_path):
        print("Error. Not found simrel_path:%s" % simrel_path)
        return 1
    run_sim_ncv(simrel_path, save_path)

if __name__ == "__main__":
    my_simrel_dirname = os.getenv(KEY_BQS_SIMREL)
    if not my_simrel_dirname:
        print("Error. You must set environment for %s" % KEY_BQS_SIMREL)
        sys.exit(1)

    my_lst_type_name = os.getenv(KEY_BQS_LST_TYPE, "sim_rtl")

    main(my_simrel_dirname, my_lst_type_name)

