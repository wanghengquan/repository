"""
Get IP name and IP folder dictionary.
import os
import re
p = re.compile("<lsccip:name>(\w+)</lsccip:name>")
top_dir = "D:/lscc/radiant/1.0/ip/pmi"
for foo in os.listdir(top_dir):
    abs_foo = os.path.join(top_dir, foo)
    if not os.path.isdir(abs_foo):
        continue
    xml_file = os.path.join(abs_foo, "metadata.xml")
    for line in open(xml_file):
        m = p.search(line)
        if m:
            real_name = m.group(1)
            print '"%s": "%s",' % (real_name, foo)
            break
    else:
        print "Checking %s" % abs_foo
"""

import os
import re
from . import xTools
import getpass

__author__ = 'syan'

"""
 generator="ipgen" module="multiplier" name="shawn_mul" source_format="Verilog" version="1.0">
 generator="ipgen" module="adder" name="shawn_adder" source_format="Verilog" version="1.0">
 generator="ipgen" module="complex_mult" name="shawn_complex_mult" source_format="Verilog" version="1.0">
 generator="ipgen" module="spi_i2c" name="shawn_i2c" source_format="Verilog" version="1.0">
 generator="ipgen" module="mult_accumulate" name="shawn_mult_accu" source_format="Verilog" version="1.0">
 generator="ipgen" module="mult_add_sub" name="shawn_mult_add_sub" source_format="Verilog" version="1.0">
 generator="ipgen" module="pll" name="shawn_pll" source_format="Verilog" version="1.0">
 generator="ipgen" module="ram_dp" name="shawn_ram_dp" source_format="Verilog" version="1.0">
 generator="ipgen" module="ram_dq" name="shawn_ram_dq" source_format="Verilog" version="1.0">
 generator="ipgen" module="subtractor" name="shawn_sub" source_format="Verilog" version="1.0">
"""


class ParserIP(object):
    def __init__(self, radiant_ins_path, installed_ip_path, general_options):
        self.ins_path = radiant_ins_path
        self.installed_ip_path = installed_ip_path
        self.xml_file = "metadata.xml"
        self.xml_files = list()
        self.general_options = general_options
        self.p_name = re.compile("<lsccip:name>(.+)</lsccip:name>")

    def get_folder(self, module_name_in_ipx, apt_dict):
        xTools.say_it(" -- Searching IP path in {} and {}".format(self.ins_path, self.installed_ip_path))
        self.get_all_xml(os.path.join(self.ins_path, "ip"))
        if os.path.isdir(self.installed_ip_path):
            self.get_all_xml(self.installed_ip_path)
        _device, _arch = apt_dict.get("device", "no_device"), apt_dict.get("architecture", "no_arch")
        ip_paths = self.general_options.get("family_radiant_ip_path")
        lower_device, lower_arch = _device.lower(), _arch.lower()
        for k, v in list(ip_paths.items()):
            k = k.lower()
            if k in lower_device or k in lower_arch:
                list_string = v
                break
        else:
            xTools.say_it("Error. not found ip search path list for {}".format(_device))
            return
        list_string = re.sub(r"\s", "", list_string)
        dirs = re.split(",", list_string)
        not_found_ip_dir = 1
        for dd in dirs:
            for met in self.xml_files:
                if dd not in met:
                    continue
                not_found_ip_dir = 0
                with open(met) as ob:
                    for line in ob:
                        m_name = self.p_name.search(line)
                        if m_name:
                            my_name = m_name.group(1)
                            if my_name == module_name_in_ipx:
                                return os.path.dirname(met)
        if not_found_ip_dir:
            xTools.say_it("  Error. Not found ip dir for xml files")
            xTools.say_it("    XML files are: {}".format(self.xml_files))

    def get_all_xml(self, ip_path):
        try:
            dfs = os.listdir(ip_path)
            if self.xml_file in dfs:
                self.xml_files.append(os.path.join(ip_path, self.xml_file))
            else:
                for foo in dfs:
                    abs_foo = os.path.join(ip_path, foo)
                    if os.path.isdir(abs_foo):
                        self.get_all_xml(abs_foo)
        except FileNotFoundError:
            return


class UpdateRadiantIP(object):
    def __init__(self, cfg_file, sbx_file, general_options, abs_rdf_file, radiant_dpd):
        self.cfg_file = cfg_file
        self.sbx_file = sbx_file
        self.general_options = general_options
        self.radiant_dpd = radiant_dpd  # dpd: digital-point-digital
        self.p_module = re.compile('RadiantModule.+\s+module="(.+?)"\s+')
        self.p_name = re.compile('RadiantModule.+\s+name="(.+?)"\s+')
        if os.path.isfile(abs_rdf_file):
            self.root_rdf_path = os.path.dirname(abs_rdf_file)
        else:
            self.root_rdf_path = ""

    def process(self):
        if xTools.not_exists(self.cfg_file, "Radiant IP configuration file"):
            return 1
        self.cfg_file = os.path.abspath(self.cfg_file)
        _ = self.process_ipx_file()
        if _ == 1:
            return 1
        elif _ == 2:  # It is not a ip cfg file
            return
        if self.process_generate():
            return 1

    def process_ipx_file(self):
        ipx_file = os.path.splitext(self.cfg_file)[0] + ".ipx"
        if xTools.not_exists(ipx_file, "Radiant IP ipx file"):
            return 2
        with open(ipx_file) as f:
            for line in f:
                m_module = self.p_module.search(line)
                m_name = self.p_name.search(line)
                if m_module:
                    self.ipx_module = m_module.group(1)
                    xTools.say_it(" -- Get module name {} from {}".format(self.ipx_module, ipx_file))
                    self.ipx_name = m_name.group(1)
                    break
            else:
                xTools.say_it("Error. Not found module/name in ipx file: %s" % ipx_file)
                return 1

    def get_pmi_folder(self, apt_dict, on_win):
        user = getpass.getuser()
        if on_win:
            installed_ip_path = r"C:\Users\%s\RadiantIPLocal" % user
        else:
            installed_ip_path = "/users/%s/RadiantIPLocal" % user
        t = ParserIP(self.radiant_dpd, installed_ip_path, self.general_options)
        return t.get_folder(self.ipx_module, apt_dict)

    def process_generate(self):
        cfg_dir = os.path.dirname(self.cfg_file)
        if self.sbx_file:
            proj_dir = os.path.dirname(self.sbx_file)
        else:
            proj_dir = cfg_dir  # never got here
        _recov = xTools.ChangeDir(cfg_dir)
        sts = xTools.not_exists(self.radiant_dpd, "Radiant path")
        if not sts:
            on_win, os_name = xTools.get_os_name()
            ipgen_file = os.path.join(self.radiant_dpd, "ispfpga", "bin", os_name, "ipgen")
            apt_str, apt_dict = get_apt()
            update_design_xml_file()
            pmi_folder = self.get_pmi_folder(apt_dict, on_win)
            if not pmi_folder:
                xTools.say_it("Error. Not found ip path for %s" % self.ipx_module)
                _recov.comeback()
                return 1
            # pmi_folder = os.path.join(self.radiant_dpd, pmi_folder)
            sts = xTools.not_exists(pmi_folder, "PMI Folder")
            if not sts:
                # usage: ipgen.EXE [-h] [-o OUTPUT_DIR] [-proj_dir PROJ_DIR] [--force-run] -ip
                #                  IP_MODULE_DIR -cfg IP_CONFIG_FILE -name IP_INSTANCE_NAME
                #                  [-a ARCHITECTURE] [-p DEVICE] [-t PACKAGE] [-sp PERFORMANCE]
                # update for new Radiant, Jeffrey Ye
                # cmd_line = "%s -o %s -ip %s -cfg %s -name %s %s" % (ipgen_file, os.path.dirname(cfg_dir), pmi_folder,
                cmd_line = "%s -o %s -proj_dir %s -ip %s -cfg %s -name %s %s" % (ipgen_file, cfg_dir, proj_dir, pmi_folder,
                                                                    self.cfg_file,
                                                                    self.ipx_name, apt_str)
                cmd_line = xTools.win2unix(cmd_line, 0)
                log_prefix = os.path.join(os.getcwd(), "Update_{}".format(self.ipx_name))
                log_file, time_file = log_prefix + ".log", log_prefix + ".time"
                if self.root_rdf_path:
                    _rr = xTools.ChangeDir(self.root_rdf_path)
                    sts = xTools.run_command(cmd_line, log_file, time_file)
                    _rr.comeback()
                    if sts:  # seldom
                        sts = xTools.run_command(cmd_line, log_file, time_file)
                else:  # never
                    sts = xTools.run_command(cmd_line, log_file, time_file)
        _recov.comeback()
        return sts


def get_apt():
    keys = ["architecture", "device", "package", "(performanceGrade|speed)"]
    short_k = ["-a", "-p", "-t", "-sp"]
    _ut24cp_list = ["UT24CP", "UT24CP100", "BBG484", "8_High-Performance_1.0V"]
    _ut24c_list = ["UT24C", "UT24C40", "CABGA256", "7_High-Performance_1.0V"]
    custom_ipgen_env = os.getenv("EXTERNAL_IPGEN_ARGS")
    if not custom_ipgen_env:
        xml_file = "component.xml"
        if not os.path.isfile(xml_file):
            return " ", dict()
        # <lsccip:device>iCE40UP5K</lsccip:device>
        # <lsccip:performanceGrade>High-Performance_1.2V</lsccip:performanceGrade>
        # <lsccip:architecture>ice40tp</lsccip:architecture>
        # <lsccip:package>CM225</lsccip:package>
        patterns = [(re.compile(":%s>(?P<sp>[^<]+)<" % k), k) for k in keys]
        apt = dict()
        for line in open(xml_file):
            for (p, k) in patterns:
                m = p.search(line)
                if m:
                    apt[k] = m.group("sp")
    else:
        custom_ipgen_env = custom_ipgen_env.lower()
        if custom_ipgen_env == "ut24c":
            apt = dict(zip(keys, _ut24c_list))
        elif custom_ipgen_env == "ut24cp":
            apt = dict(zip(keys, _ut24cp_list))
        else:
            print("Error. Unknown env value EXTERNAL_IPGEN_ARGS: {}".format(custom_ipgen_env))
            apt = dict()
    my_apt = " "
    if len(apt) == len(keys):
        for i, v in enumerate(keys):
            my_apt += " %s %s" % (short_k[i], apt.get(v))
    return my_apt, apt


def update_design_xml_file():
    d_xml = "design.xml"
    if not os.path.isfile(d_xml):
        return
    p = re.compile('referenceId="TABLE_FULL_PATH">(.+)</ipxact:configurableElementValue>')
    with open(d_xml) as rd_ob:
        for line in rd_ob:
            if p.search(line):
                break
        else:
            return  # Do not need to update
    new_lines = list()
    with open(d_xml) as rd_ob:
        for line in rd_ob:
            m = p.search(line)
            if m:
                now_file = m.group(1)
                new_file = xTools.win2unix(os.path.basename(now_file))
                if not os.path.isfile(new_file):
                    print("Warning. not found file {}".format(new_file))
                    return
                line = re.sub(now_file, new_file, line)
            new_lines.append(line)
    with open(d_xml, "w") as wr_ob:
        for line in new_lines:
            print(line, file=wr_ob, end="")
