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
import xTools
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
    def __init__(self, radiant_ins_path, installed_ip_path):
        self.ins_path = radiant_ins_path
        self.installed_ip_path = installed_ip_path
        self.xml_file = "metadata.xml"
        self.xml_files = list()
        self.p_name = re.compile("<lsccip:name>(.+)</lsccip:name>")

    def get_folder(self, module_name_in_ipx, apt_dict):
        xTools.say_it(" -- Searching IP path in {} and {}".format(self.ins_path, self.installed_ip_path))
        self.get_all_xml(os.path.join(self.ins_path, "ip"))
        if os.path.isdir(self.installed_ip_path):
            self.get_all_xml(self.installed_ip_path)
        _device, _arch = apt_dict.get("device", "no_device"), apt_dict.get("architecture", "no_arch")
        if 'ice40' in _device.lower() or 'ice40' in _arch.lower():
            dirs = ["iCE40UP", "common", "RadiantIPLocal"]
        elif "je5d" in _device.lower() or "je5d" in _arch.lower():
            dirs = ["je5d00", "common", "RadiantIPLocal", "lifcl"]
        elif "lifcl" in _device.lower() or "lifcl" in _arch.lower():
            dirs = ["lifcl", "common", "RadiantIPLocal"]
        else:
            dirs = ["lifcl", "common", "RadiantIPLocal", "je5d00", "iCE40UP"]
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
        dfs = os.listdir(ip_path)
        if self.xml_file in dfs:
            self.xml_files.append(os.path.join(ip_path, self.xml_file))
        else:
            for foo in dfs:
                abs_foo = os.path.join(ip_path, foo)
                if os.path.isdir(abs_foo):
                    self.get_all_xml(abs_foo)


class UpdateRadiantIP(object):
    def __init__(self, cfg_file, sbx_file, radiant_dpd):
        self.cfg_file = cfg_file
        self.sbx_file = sbx_file
        self.radiant_dpd = radiant_dpd  # dpd: digital-point-digital
        self.p_module = re.compile('RadiantModule.+\s+module="(.+?)"\s+')
        self.p_name = re.compile('RadiantModule.+\s+name="(.+?)"\s+')

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
        t = ParserIP(self.radiant_dpd, installed_ip_path)
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
                sts = xTools.run_command(cmd_line, "Update_%s.log" % self.ipx_name, "Update_%s.time" % self.ipx_name)
                # Stop to support old command
                # if sts:  # use old command
                #     cmd_line = "%s -o %s %s %s %s" % (ipgen_file, os.path.dirname(cfg_dir), pmi_folder,
                #                                       self.cfg_file, self.ipx_name)
                #     cmd_line = xTools.win2unix(cmd_line, 0)
                #     sts = xTools.run_command(cmd_line, "Upd_%s.log" % self.ipx_name, "Upd_%s.time" % self.ipx_name)
        _recov.comeback()
        return sts


def get_apt():
    xml_file = "component.xml"
    if not os.path.isfile(xml_file):
        return " ", dict()
    # <lsccip:device>iCE40UP5K</lsccip:device>
    # <lsccip:performanceGrade>High-Performance_1.2V</lsccip:performanceGrade>
    # <lsccip:architecture>ice40tp</lsccip:architecture>
    # <lsccip:package>CM225</lsccip:package>
    keys = ["architecture", "device", "package", "(performanceGrade|speed)"]
    short_k = ["-a", "-p", "-t", "-sp"]
    patterns = [(re.compile(":%s>(?P<sp>[^<]+)<" % k), k) for k in keys]
    apt = dict()
    for line in open(xml_file):
        for (p, k) in patterns:
            m = p.search(line)
            if m:
                apt[k] = m.group("sp")
    my_apt = " "
    if len(apt) == len(keys):
        for i, v in enumerate(keys):
            my_apt += " %s %s" % (short_k[i], apt.get(v))
    return my_apt, apt


if __name__ == "__main__":
    pass
