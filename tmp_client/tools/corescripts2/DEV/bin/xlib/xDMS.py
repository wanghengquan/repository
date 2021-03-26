"""
Start the RunDMSFlow at $top_dir/$design/_scratch directory
Environment already settled in parent scripts.
"""

import os
import re
import csv
import xTools
import zipfile
import filelock

__author__ = 'syan'

# /////////////////////////////
# Questasim do file template
#vlog +define+CHIP +incdir+%s/thunderplus_NG %s
qsim_template = r"""
vlib work
vmap Tplus_DMS %(conf)s/LIB_thunderplus
vlog +define+CHIP +incdir+%(conf)s/thunderplus_NG %(tb_file)s
vlog +define+CHIP %(conf)s/thunderplus_NG/via.v
vsim  +nowarnTFMPC -novopt -l sim.log -L Tplus_DMS -L work %(tb_name)s
do dffess.do
%(user_do)s
run -all
"""


def unzip_single(src_file, dest_dir, password=None):
    if password:
        password = password.encode()
    zf = zipfile.ZipFile(src_file)
    try:
        zf.extractall(path=dest_dir, pwd=password)
    except RuntimeError as e:
        print(e)
    zf.close()


def __unzip_lib_file(zip_file_path):
    zip_file = os.path.join(zip_file_path, "LIB_thunderplus.zip")
    if not os.path.isfile(zip_file):
        print("Error. not found lib zip file: {}".format(zip_file))
        return 1
    lib_dir = os.path.abspath(os.path.splitext(zip_file)[0])
    if not os.path.isdir(lib_dir):
        print("unzipping lib file: {}".format(zip_file))
        unzip_single(zip_file, os.path.dirname(lib_dir))


def unzip_lib_file(zip_file_path):
    lock_file = os.path.join(zip_file_path, 'unzipping.lock')   # should be the same path for flows
    filelock.safe_run_function(__unzip_lib_file, args=(zip_file_path,), func_lock_file=lock_file)


def get_pin_type_from_lsedata(lsedata_file):
    """
    :param lsedata_file:
    :return:  a dictionary:
       - clk                 : in
       - datain[0]           : in
       - datain[1]           : in
       - dataout[0]          : out
       - dataout[1]          : out
       - enable              : in
    Key lines:
    <unit name = "register_en">
    ...
    <pins>
        <pitem  name = "datain[1]"  direction = "in"  />
        <pitem  name = "datain[0]"  direction = "in"  />
        <pitem  name = "clk"  direction = "in"  />
        <pitem  name = "enable"  direction = "in"  />
        <pitem  name = "dataout[1]"  direction = "out"  />
        <pitem  name = "dataout[0]"  direction = "out"  />
    </pins>
    """
    pin_type_dict = dict()
    p_unit = re.compile("^<unit\s+name")
    pins_start = "<pins>"
    pins_end = "</pins>"
    p_pin_type = re.compile('<pitem\s+name\s+=\s+"([^"]+)"\s+direction\s+=\s+"([^"]+)"')

    start_mark = 0
    for line in open(lsedata_file):
        line = line.strip()
        if not start_mark:
            if p_unit.search(line):
                start_mark = 1
        elif start_mark == 1:
            if line == pins_start:
                start_mark = 2
        if start_mark == 2:
            if line == pins_end:
                break
            m_pin_type = p_pin_type.search(line)
            if m_pin_type:
                pin_type_dict[m_pin_type.group(1)] = m_pin_type.group(2)
    return pin_type_dict


def get_pin_type_from_pad_file(pad_file):
    """
    Use pad file instead of lsedata file. (by JYe)
    +-------------+----------+---------------+-------+------------+
    | Port Name   | Pin/Bank | Buffer Type   | Site  | Properties |
    +-------------+----------+---------------+-------+------------+
    | B1          | 23/0     | I3C_BIDI      | PR20A |            |
    | B2          | 25/0     | I3C_BIDI      | PR20B |            |
    | CURREN      | 38/0     | LVCMOS25_IN   | PR9B  | PULL:100K  |

    get more: Pin number.
    """
    p1 = "Pinout by Port Name"
    start = 0
    pin_type_dict = dict()
    port_site_list = list()
    with open(pad_file) as pad_ob:
        for line in pad_ob:
            if not start:
                start = line.startswith(p1)
                continue
            line = line.strip()
            if not line:
                break
            line_list = re.split("\s*\|\s*", line)
            if len(line_list) < 5:   # ['', 'RGB1PWM', '42/0', 'LVCMOS25_IN', 'PR9A', 'PULL:100K', '']
                continue
            buf_type = line_list[3]
            if buf_type == "Buffer Type":
                continue  # skip itself
            pin_bank = re.sub("/\d+", "", line_list[2])
            port_name = line_list[1]
            t = re.split("_", buf_type.lower())[-1]
            t_map = {"in": "in", "output": "out", "out": "out", "bidi": "inout", "bidir": "inout"}
            if t in t_map:
                pin_type_dict[port_name] = t_map.get(t)
                port_site_list.append([port_name, pin_bank])
            else:
                # try to get real type from .mrp file
                mrp_file = os.path.splitext(pad_file)[0] + ".mrp"
                p = re.compile("\|\s+%s\s+\|\s+(\w+)" % port_name)
                for line in open(mrp_file):
                    m = p.search(line)
                    if m:
                        pin_type_dict[port_name] = t_map.get(m.group(1).lower())
                        port_site_list.append([port_name, pin_bank])

    return pin_type_dict, port_site_list


def write_io_v_file(io_v_file, pad_file, pac_cfg_file, io_cfg_file, lsedata_file):
    """

    :param io_v_file:
    :param pad_file:
    :param pac_cfg_file:
    :param io_cfg_file:
    :return:
    """
    p_package = re.compile("PACKAGE:\s+(\S+)")
    package = ""
    for line in open(pad_file):
        line = line.strip()
        if not package:
            m_package = p_package.search(line)
            if m_package:
                package = m_package.group(1)
                break
    if not package:
        xTools.say_it("Error. Not found package in %s" % pad_file)
        return 1
    # ////////////////
    site_pre_io = dict()
    csv_lines = list()
    for line in open(pac_cfg_file):
        line = line.strip()
        if re.search("Pad Number", line): # title
            line_list = re.split("\s*,\s*", line)
            line = ",".join(line_list)
        csv_lines.append(line)
    csv_dict_list = csv.DictReader(csv_lines)
    for line_dict in csv_dict_list:
        site_pre_io[line_dict.get(package)] = re.sub("\s+", "",line_dict.get("Pre-IO Coordinate"))
    # ///////////////////
    io_bank = dict()
    p = re.compile("\((.+)\)\s+(\S+)")
    for line in open(io_cfg_file):
        m = p.search(line)
        if m:
            key = m.group(1)
            key = re.sub("\s+", "", key)
            io_bank[key] = m.group(2)
    # ///////////////////////
    pin_type_dict, port_site_list = get_pin_type_from_pad_file(pad_file)
    target_ob = open(io_v_file, "w")
    for (port, site) in port_site_list:
        port = re.sub("_to_IOPAD", "", port)  # remove 'to_IOPAD' in 'addr_pad[10]_to_IOPAD'
        port = re.sub("_pad$", "", port)
        port = re.sub("_pad\[", "[", port)
        pre_io_for_site = site_pre_io.get(site)
        if not pre_io_for_site:
            xTools.say_it("Error. Not found Pre-IO for %s" % site)
            return 1
        foo = io_bank.get(pre_io_for_site)
        if not foo:
            xTools.say_it("Error. Not found final location for %s" % site)
            return 1
        port_type = pin_type_dict.get(port)
        if port_type == "in":
            print >> target_ob, "assign %s = %s;" % (foo, port)
        elif port_type == "out":
            print >> target_ob, "assign %s = %s;" % (port, foo)
        elif port_type == "inout":
            # via via_miso(uio_bbank[5],miso);
            print >> target_ob, "via via_%s(%s, %s);" % (port, foo, port)
        else:
            xTools.say_it("Error. please check port: %s buffer type name" % port)
            return 1
    target_ob.close()

class RunDMSFlow:
    def __init__(self, project_name,  impl_name, impl_dir, conf_path, questasim_path, sim_section):
        self.basename = "%s_%s" % (project_name, impl_name)
        self.root_file_name = os.path.join(os.getcwd(), impl_dir, self.basename)
        self.conf = xTools.win2unix(conf_path, 0)
        self.questasim_path = questasim_path
        self.base_do = "dffess.do"
        self.sim_section = sim_section
        self.on_win, os_name = xTools.get_os_name()

    def process(self):
        dms_folder = os.path.abspath("DMS")
        if xTools.wrap_md(dms_folder, "DMS folder"):
            return 1
        _recov = xTools.ChangeDir(dms_folder)
        sts = self.run_bitgen_flow()
        if not sts:
            sts = self.generate_do_file()
        if not sts:
            sts = self.generate_io_v_file()
        if not sts:
            sts = self.run_questa_simulation_flow()
        _recov.comeback()
        return sts

    def run_bitgen_flow(self):
        udb_file = self.root_file_name + ".udb"
        if xTools.not_exists(udb_file, "UDB file"):
            return 1
        cmd = "bitgen -dw -simbitmap %s"  % xTools.get_relative_path(udb_file, os.getcwd())
        sts = xTools.run_command(cmd, "dms_flow.log", "dms_flow.time")
        return sts

    def generate_do_file(self):
        awk_scripts = os.path.join(self.conf, "thunderplus_NG", "cbit_conv2mti_thunderplus.txt")
        awk_data = self.root_file_name + ".txt"
        if xTools.not_exists(awk_scripts, "awk scripts file"):
            return 1
        if xTools.not_exists(awk_data, "awk data file"):
            return 1
        awk_scripts = xTools.get_relative_path(awk_scripts, os.getcwd())
        awk_data = xTools.get_relative_path(awk_data, os.getcwd())
        if self.on_win:
            awk_exe = xTools.win2unix(os.path.join(self.conf, "bin", "awk.exe"))
            awk_cmd = "%s -f %s %s > %s" % (awk_exe, awk_scripts, awk_data, self.base_do)
        else:
            awk_cmd = "awk -f %s %s > %s" % (awk_scripts, awk_data, self.base_do)
        awk_cmd = xTools.win2unix(awk_cmd, 0)
        return xTools.run_command(awk_cmd, "dms_flow.log", "dms_flow.time")

    def generate_io_v_file(self):
        pad_file = self.root_file_name + '.pad'
        pac_cfg_file = os.path.join(self.conf, "thunderplus_NG", "SBT_ICE_packages_IO_table_ICE65L.csv")
        io_cfg_file = os.path.join(self.conf, "thunderplus_NG", "IO_thunderplus.txt")
        lsedata_file = self.root_file_name + ".lsedata"
        # ///////////////// check them
        check_list =((pad_file, "pad file"), (pac_cfg_file, "DMS Package Config csv file"),
                     (io_cfg_file, "DMS IO Config txt file"))
        for (raw_file, comments) in check_list:
            if xTools.not_exists(raw_file, comments):
                return 1
        target_file = "io.v"
        return write_io_v_file(target_file, pad_file, pac_cfg_file, io_cfg_file, lsedata_file)

    def run_questa_simulation_flow(self):
        do_file = "run_DMS.do"
        self._info_dir = os.path.abspath(os.path.join(os.getcwd(), "..", ".."))
        tb_file = xTools.get_relative_path(self.sim_section.get("tb_file", 'noTestbenchFile'), self._info_dir)
        if xTools.not_exists(tb_file, "Testbench File"):
            return 1
        # copy tb_vector file if needed!
        self.copy_tb_vector_file()
#        tb_file_dir=os.path.get_dirname(tb_file)
        tb_name = xTools.get_top_name(tb_file)
        user_do = self.sim_section.get("user_do")
        if not user_do:
            user_do = ""
        else:
            user_do = xTools.get_relative_path(user_do, self._info_dir)
            if xTools.not_exists(user_do, "USER DO FILE"):
                return 1
            user_do = "do %s" % user_do
        kwargs = {"conf": self.conf, "tb_file": tb_file, "tb_name": tb_name, "user_do": user_do}
        unzip_lib_file(self.conf)
        xTools.write_file(do_file, qsim_template % kwargs)
        run_sim_cmd = '%s/vsim -l sim_log.txt -c -do "do %s"' % (self.questasim_path, do_file)
        run_sim_cmd = xTools.win2unix(run_sim_cmd, 0)
        return xTools.run_command(run_sim_cmd,  "dms_flow.log", "dms_flow.time")

    def copy_tb_vector_file(self):
        tb_vector = self.sim_section.get("tb_vector")
        if tb_vector:
            src_file = xTools.get_relative_path(tb_vector, self._info_dir)
            dst_file = os.path.basename(tb_vector)
            xTools.wrap_cp_file(src_file, dst_file)


if __name__ == "__main__":
    write_io_v_file("iii.v", r"D:\laxidolami\dsdf\top_impl1.pad",
                    r"D:\laxidolami\dsdf\conf\thunderplus_NG\SBT_ICE_packages_IO_table_ICE65L.csv",
                    r"D:\laxidolami\dsdf\conf\thunderplus_NG\IO_thunderplus.txt",
                    "")