"""

Tips:
    1) already set path/foundry environment
"""


import os
import re
import xTools
import xLatticeDev

__author__ = 'syan'


class ConvertScubaCase:
    def __init__(self, design_path, devkit, xml_file, scuba_type, flow_options):
        self.design_path =design_path
        self.devkit= devkit
        self.xml_file = xml_file
        self.scuba_type = scuba_type
        self.source_path_name = "source"
        self.flow_options = flow_options

    def process(self):
        if not self.devkit:
            xTools.say_it("Error. Devkit should be specified for scuba test flow")
            return 1

        if self.scuba_type == "verilog":
            self.ext, self.short_hdl = ".v", "vlg"
            self.tb_file = "stim"
        elif self.scuba_type == "vhdl":
            self.ext, self.short_hdl = ".vhd", "vhd"
            self.tb_file = "vhdl_stim"
        else:
            # never got here
            xTools.say_it("Error. Unknown scuba type name: %s" % self.scuba_type)
            return 1
        sts = self.create_device_base_name()
        if not sts:
            _recov = xTools.ChangeDir(self.design_path)

            for func in (self.run_scuba_in_scr, self.generate_info_file, self.generate_conf_file):
                sts = func()
                if sts: break
            _recov.comeback()
        return sts

    def create_device_base_name(self):
        dev_parser = xLatticeDev.DevkitParser(self.xml_file)
        sts = dev_parser.process()
        if sts:
            return 1
        std_devkit = dev_parser.get_std_devkit(self.devkit)
        if not std_devkit:
            xTools.say_it("Error. Unknown devkit: %s" % self.devkit)
            return 1
        ach = std_devkit.get("ach")
        self.device_base_name = ach
        if not ach:
            xTools.say_it("Error. Not found ach name for %s" % self.devkit)
            return 1

    def run_scuba_in_scr(self):
        """
        change mem file path spelling
        """
        p_mem = re.compile("-memfile\s+(\S+)")
        scr_file = self.scuba_type + ".scr"
        if xTools.not_exists(scr_file, "Scuba SCR file"):
            return 1
        p_scuba = re.compile("scuba(\.exe)*", re.I)
        p_module_name = re.compile("\s+-n\s+(\S+)")

        ori_cmd_line = ""
        for line in open(scr_file):
            line = line.strip()
            if p_scuba.search(line):
                ori_cmd_line = line
                break
        if not ori_cmd_line:
            xTools.say_it("Error. Not found scuba command line in %s" % scr_file)
            return 1
        new_cmd_line = re.sub("-arch\s+BASE", "-arch %s" % self.device_base_name, ori_cmd_line)
        new_cmd_line = p_scuba.sub("scuba", new_cmd_line)
        m_mem = p_mem.search(new_cmd_line)
        if m_mem:
            mem_file = m_mem.group(1)
            new_cmd_line = p_mem.sub("-memfile %s" % xTools.win2unix(mem_file), new_cmd_line)
        m_module_name = p_module_name.search(new_cmd_line)
        if m_module_name:
            self.module_name = m_module_name.group(1)
            if xTools.wrap_md(self.source_path_name, "scuba results path"):
                return 1
            my_recov = xTools.ChangeDir(self.source_path_name)
            sts = xTools.run_command(new_cmd_line, "_run_scuba.log", "_run_scuba.time")
            my_recov.comeback()
            if sts:
                return 1
        else:
            xTools.say_it("Error. Not found module name in %s" % scr_file)
            return 1

    def generate_info_file(self):
        info_file = "_bqs_scuba.info"
        info_lines = list()
        info_lines.append("[qa]")
        info_lines.append("devkit = %s" % self.devkit)
        info_lines.append("src_files = ./source/%s%s" % (self.module_name, self.ext))
        info_lines.append("top_module = %s" % self.module_name)
        info_lines.append("")

        if xTools.wrap_md("sim", "Simulation File Path"):
            return 1
        will_copy_file = list()
        will_copy_file.append((self.tb_file, "./sim/%s.v" % self.tb_file))
        tb_vector = ""
        for foo in os.listdir("."):
            fname, fext = os.path.splitext(foo.lower())
            if fext == ".in" or foo == "beh_out":
                if fext == ".in":
                    tb_vector = foo
                will_copy_file.append((foo, "./sim/%s" % foo))
            if foo == "ini_mem":
                will_copy_file.append((foo, "./%s/%s" % (self.source_path_name, foo)))
        for (src, dst) in will_copy_file:
            if xTools.wrap_cp_file(src, dst):
                pass
                # Douglas need to run flow only 
                # return 1

        info_lines.append("[sim]")
        info_lines.append("sim_top   = test_lattice_sim")
        info_lines.append("uut_name  = post")
        info_lines.append("sim_time  = -all")
        info_lines.append("tb_file   = ./sim/%s.v" % self.tb_file)
        if tb_vector:
            info_lines.append("tb_vector = ./sim/%s" % tb_vector)
        xTools.write_file(info_file, info_lines)

    def add_block(self, title, sim_path, golden_file, out_vector_file):
        block_name = "sim_check_block_%d" % (len(self.check_block)+1)
        self.check_block.append(block_name)
        self.conf_lines.append("[%s]" % block_name)
        self.conf_lines.append("title = %s" % title)
        self.conf_lines.append("golden_file = ./sim/%s" % golden_file)
        self.conf_lines.append("compare_file  = ./_scratch/%s/%s" % (sim_path, out_vector_file))
        self.conf_lines.append("")

    def generate_conf_file(self):
        conf_file = "_bqs_scuba.conf"
        golden_file="beh_out"
        out_vector_file = self.module_name + ".sim"
        t_kwargs = dict(golden_file=golden_file,
            out_vector_file =out_vector_file,
            short_hdl=self.short_hdl, hdl_type=self.scuba_type,
            area_name="%s_%s" % (os.path.basename(self.design_path), self.devkit))
        self.sim_rtl = xTools.get_true(self.flow_options, "sim_rtl")
        self.sim_map_vlg = xTools.get_true(self.flow_options, "sim_map_vlg")
        self.sim_map_vhd = xTools.get_true(self.flow_options, "sim_map_vhd")
        self.sim_par_vlg = xTools.get_true(self.flow_options, "sim_par_vlg")
        self.sim_par_vhd = xTools.get_true(self.flow_options, "sim_par_vhd")
        self.sim_all = xTools.get_true(self.flow_options, "sim_all")
        self.conf_lines = list()
        self.conf_lines.append("[configuration information]")
        self.conf_lines.append("area = %(area_name)s" % t_kwargs)
        self.conf_lines.append("type = %(hdl_type)s" % t_kwargs)
        self.check_block = list()
        if self.sim_all or self.sim_rtl:
            self.add_block("sim_rtl", "sim_rtl", golden_file, out_vector_file)
        if self.short_hdl == "vlg":
            if self.sim_all or self.sim_map_vlg:
                self.add_block("sim_map_vlg", "sim_map_vlg", golden_file, out_vector_file)
            if self.sim_all or self.sim_par_vlg:
                self.add_block("sim_par_vlg", "sim_par_vlg", golden_file, out_vector_file)
        else: # vhd
            if self.sim_all or self.sim_map_vhd:
                self.add_block("sim_map_vhd", "sim_map_vhd", golden_file, out_vector_file)
            if self.sim_all or self.sim_par_vhd:
                self.add_block("sim_par_vhd", "sim_par_vhd", golden_file, out_vector_file)
        self.conf_lines.append("[method]")
        for blk in self.check_block:
            self.conf_lines.append("%s = 1" % blk)
        xTools.write_file(conf_file, self.conf_lines)

