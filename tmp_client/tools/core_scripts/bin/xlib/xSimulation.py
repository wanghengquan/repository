import os
import re
import time
import glob

import xTools
import xReport
import xLatticeDev
import xLattice
import simLibrary
import utils

from Verilog_VCD import Verilog_VCD

__author__ = 'syan'

def dump_vcd_file(cur_dir=""):
    if not cur_dir:
        cur_dir = os.getcwd()
    if xTools.not_exists(cur_dir, "vcd path"):
        return 1
    for foo in os.listdir(cur_dir):
        fname, fext = os.path.splitext(foo)
        if fext.lower() != ".vcd":
            continue
        try:
            vcd_data = Verilog_VCD.parse_vcd(os.path.join(cur_dir, foo))
        except:
            xTools.say_it("Warning. Failed to dump from %s" % (os.path.join(cur_dir, foo)))
            return
        vcd_txt =  "%s_vcd.txt" % fname
        dump_file = os.path.join(cur_dir, vcd_txt)
        xTools.say_it("  Dumping %s to %s" % (foo, vcd_txt))
        dump_lines = list()
        keys = vcd_data.keys()
        keys.sort()
        for k in keys:
            v = vcd_data.get(k)
            nets = v.get("nets")[0]
            hier = nets.get("hier")
            if hier != "sim_top.uut":
                continue
            dump_lines.append("-" * 10)
            nets_keys = nets.keys()
            nets_keys.sort()
            dump_lines += ["%s : %s" % (nk, nets.get(nk)) for nk in nets_keys]
            dump_lines += xTools.distribute_list("time-value", v.get("tv"), 15)
        xTools.write_file(dump_file, dump_lines)


def get_real_hdl_file(real_hdl_file, run_scuba):
    if not run_scuba:
        return 0, real_hdl_file
    is_model_file = xReport.file_simple_parser(real_hdl_file, [re.compile("\S+scuba\.exe(.+)")], 80)
    if not is_model_file:
        return 0, real_hdl_file
    # find scuba command!
    fext = xTools.get_fext_lower(real_hdl_file)
    new_fext  = fext
    if fext == ".vhd":
        if run_scuba in ("verilog", "reverse"):
            new_fext = ".v"
    elif fext == ".v":
        if run_scuba in ("vhdl", "reverse"):
            new_fext = ".vhd"
    new_file = os.path.splitext(real_hdl_file)[0] + new_fext
    if new_fext == fext:
        return 0, new_file
    else:
        return 1, new_file

def get_new_real_path(do_file, line):
    do_dir = os.path.dirname(do_file)
    p_incdir = re.compile("\+incdir\+(\S+)")
    m_incdir = p_incdir.search(line)
    if m_incdir:
        return "\t\t+incdir+%s \\" % xTools.get_relative_path(m_incdir.group(1), do_dir)
    else:
        file_list = re.split("\s+", line)
        new_file_list = list()
        for item in file_list:
            if not item:
                new_file_list.append(item)
                continue
            fname, fext = os.path.splitext(item)
            if fext.lower() in (".v", ".sv", ".vhd"):
                if re.search("\+", item):
                    pass
                else:
                    item = xTools.get_relative_path(item, do_dir)
            new_file_list.append(item)
        line = " ".join(new_file_list)
        return line


class RunSimulationFlow:
    def __init__(self, flow_options, final_ldf_file, final_ldf_dict):
        self.flow_options = flow_options
        self.is_ng_flow = flow_options.get("is_ng_flow")
        self.final_ldf_dict = final_ldf_dict
        self.final_ldf_file = final_ldf_file
        self.conf = flow_options.get("conf")
        self.run_scuba = flow_options.get("run_scuba")
        self.with_sdf = flow_options.get("with_sdf")
        self.sdf_file = ""  # will be defined in main simulation function

        self.p_src_start = re.compile("<source_start>")
        self.p_src_end = re.compile("<source_end>")
        self.p_tb_start = re.compile("<tb_start>")
        self.p_tb_end = re.compile("<tb_end>")
        self.use_vhd = 0

    def process(self):
        sim_vendor_bin = os.getenv("SIM_VENDOR_BIN")
        if xTools.not_exists(sim_vendor_bin, "Simulation tool bin path"):
            return 1
        self.sim_vendor_bin = xTools.win2unix(sim_vendor_bin)
        self.flatten_options()
        user_options = self.get_user_options()
        sts = 0
        task_list = xLattice.get_task_list(self.flow_options, user_options)
        if task_list:
            sts = xLattice.run_ldf_file("run_pb.tcl", self.final_ldf_file, task_list, list(), self.is_ng_flow)
            if sts:
                xTools.say_it("-Warning. errors found in normal implementation flow")

        for (sim_type, sim_path, sim_func) in (
            (self.sim_rtl, "sim_rtl", self.run_rtl_simulation),
            (self.sim_syn_vhd, "sim_syn_vhd", self.run_syn_vhd_simulation),
            (self.sim_syn_vlg, "sim_syn_vlg", self.run_syn_vlg_simulation),
            (self.sim_map_vhd, "sim_map_vhd", self.run_map_vhd_simulation),
            (self.sim_map_vlg, "sim_map_vlg", self.run_map_vlg_simulation),
            (self.sim_par_vhd, "sim_par_vhd", self.run_par_vhd_simulation),
            (self.sim_par_vlg, "sim_par_vlg", self.run_par_vlg_simulation),
            ):
            if sim_type:
                sts = sim_func(sim_path)

        if self.run_simrel:
            sts = self.run_simrel_flow()
        return sts

    def run_simrel_flow(self):
        _t = os.path.abspath(os.path.join(os.getcwd(), ".."))
        my_recov = xTools.ChangeDir(_t)
        import xSimrel
        bidi_type_name = ""
        simrel_section = self.flow_options.get("simrel")
        if simrel_section:
            _bidi_type = simrel_section.get("bidi_type")
            if _bidi_type:
                bidi_type_name = _bidi_type.lower()
        sts = xSimrel.main(self.simrel_path, self.run_simrel, self.sim_vendor_name, bidi_type_name)
        my_recov.comeback()
        return sts
    def get_user_options(self):
        user_options = dict()
        for (sim_type, flow_opt) in (
            (self.sim_map_vhd, "run_map_vhd"),
            (self.sim_map_vlg, "run_map_vlg"),
            (self.sim_par_vhd, "run_export_vhd"),
            (self.sim_par_vlg, "run_export_vlg"),
            ):
            if sim_type:
                user_options[flow_opt] = 1
        return user_options


    def flatten_options(self):
        foundry_path = os.getenv("FOUNDRY")
        if xTools.not_exists(foundry_path, "Foundry Path"):
            return 1

        self.src_design = self.flow_options.get("src_design")
        self.dst_design = self.flow_options.get("dst_design")
        self.synthesis = self.flow_options.get("synthesis")
        if not self.synthesis:
            self.synthesis = "synplify"

        self.sim_rtl = xTools.get_true(self.flow_options, "sim_rtl")
        self.sim_syn_vlg = xTools.get_true(self.flow_options, "sim_syn_vlg")
        self.sim_syn_vhd = xTools.get_true(self.flow_options, "sim_syn_vhd")

        self.sim_map_vlg = xTools.get_true(self.flow_options, "sim_map_vlg")
        self.sim_map_vhd = xTools.get_true(self.flow_options, "sim_map_vhd")
        self.sim_par_vlg = xTools.get_true(self.flow_options, "sim_par_vlg")
        self.sim_par_vhd = xTools.get_true(self.flow_options, "sim_par_vhd")
        self.sim_all = xTools.get_true(self.flow_options, "sim_all")
        self.simrel_path = self.flow_options.get("simrel_path")
        self.run_simrel = self.flow_options.get("run_simrel")
        self.pmi = xTools.get_true(self.flow_options, "pmi")
        self.lst_precision = self.flow_options.get("lst_precision")
        if self.sim_all:
            self.sim_rtl = self.sim_map_vhd = self.sim_map_vlg = self.sim_par_vhd = self.sim_par_vlg = 1
            self.sim_syn_vlg = 1
        if self.is_ng_flow:
            self.sim_map_vhd = self.sim_map_vlg = 0
        others_path = self.flow_options.get("others_path")
        if others_path:
            others_path = os.path.join(self.src_design, others_path)
            if os.path.isdir(others_path):
                self.others_path = others_path
        else:
            self.others_path = ""

        sim_section = self.flow_options.get("sim")
        if not sim_section:
            xTools.say_it("-Error. Not any simulation settings found.")
            return 1
        self.dev_lib = sim_section.get("dev_lib")
        self.pri_lib = sim_section.get("pri_lib")
        self.src_lib = sim_section.get("src_lib")

        diamond = os.path.dirname(foundry_path)
        self.diamond = diamond = xTools.win2unix(diamond)
        if self.pri_lib:
            self.pri_lib = re.sub('\$diamond', diamond, xTools.win2unix(self.pri_lib, 0))
        else:
            self.pri_lib = "work"
        if self.src_lib:
            self.src_lib = re.sub('\$diamond', diamond, xTools.win2unix(self.src_lib, 0))
        else:
            self.src_lib = ""

        self.tb_file = sim_section.get("tb_file")
        self.tb_vector = sim_section.get("tb_vector")
        self.sim_top = sim_section.get("sim_top")
        if not self.sim_top:
            self.sim_top = "sim_top"
        self.src_top_module = sim_section.get("src_top_module")
        if not self.src_top_module:
            self.src_top_module = self.sim_top
        self.uut_name = sim_section.get("uut_name")
        self.resolution = sim_section.get("resolution")
        if not self.uut_name:
            self.uut_name = "UUT"
        self.sim_time = sim_section.get("sim_time")
        self.do_msim = sim_section.get("do_msim")
        self.do_qsim = sim_section.get("do_qsim")
        self.do_ahdl = sim_section.get("do_asim")
        self.do_riviera = sim_section.get("do_rsim")

        _conf = self.flow_options.get("conf")
        if not self.do_msim:
            self.do_msim = os.path.join(_conf, "sim", "msim_do.template")
        if not self.do_qsim:
            self.do_qsim = os.path.join(_conf, "sim", "qsim_do.template")
        if not self.do_riviera:
            self.do_riviera = os.path.join(_conf, "sim", "rsim_do.template")
        if not self.do_ahdl:
            if self.pmi:
                self.do_ahdl = os.path.join(_conf, "sim", "pmi_ahdl.template")
            else:
                self.do_ahdl = os.path.join(_conf, "sim", "ahdl_do.template")

        self.run_modelsim = xTools.get_true(self.flow_options, "run_modelsim")
        self.run_questasim = xTools.get_true(self.flow_options, "run_questasim")
        self.run_riviera = xTools.get_true(self.flow_options, "run_riviera")

        if self.run_modelsim:
            self.do_template = self.do_msim
            self.sim_vendor_name = "Modelsim"
        elif self.run_questasim:
            self.do_template = self.do_qsim
            self.sim_vendor_name = "QuestaSim"
        elif self.run_riviera:
            self.do_template = self.do_riviera
            self.sim_vendor_name = "Riviera"
        else:
            self.do_template = self.do_ahdl
            self.sim_vendor_name = "Active"
        if not os.path.isfile(self.do_template):
            self.do_template = xTools.get_abs_path(self.do_template, self.src_design)
        if xTools.not_exists(self.do_template, "DO Template File"):
            return 1

        bali_node = self.final_ldf_dict.get("bali")
        impl_node = self.final_ldf_dict.get("impl")

        self.impl_name = bali_node.get("default_implementation")
        self.impl_dir = impl_node.get("dir")
        if not self.impl_dir:
            self.impl_dir = self.impl_name

        self.project_name = bali_node.get("title")
        device = bali_node.get("device")
        if not self.is_ng_flow:
            big_version, small_version = xLattice.get_diamond_version()
            xml_file = os.path.join(_conf, "DiamondDevFile_%s%s.xml" % (big_version, small_version))
            self.devkit_parser = xLatticeDev.DevkitParser(xml_file)
            if self.devkit_parser.process():
                return 1
            std_devkit = self.devkit_parser.get_std_devkit(device)
            if not std_devkit:
                xTools.say_it("Error. Unknown device %s" % device)
                return 1
            family_name = std_devkit.get("family")
        else:
            d_lower = device.lower()
            if d_lower.startswith("ice40up"):
                family_name = 'iCE40UP'
            else:
                xTools.say_it("Error. Not support %s simulation flow now." % device)
                return 1
        conf_file = os.path.join(_conf, "sim", "map_lib.ini")
        if xTools.not_exists(conf_file, "Simulation Library Pairs File"):
            return 1
        sts, raw_lib_dict = xTools.get_conf_options(conf_file)
        if sts:
            return 1
        my_dict = raw_lib_dict.get("family_map_sim_lib")
        fam_lower = family_name.lower()
        map_lib_name = my_dict.get(fam_lower)
        if not map_lib_name:
            map_lib_name =  fam_lower
            xTools.say_it("Message: Use map lib name: %s" %fam_lower)

        if self.dev_lib:
            map_lib_name = self.dev_lib
            map_lib_name = re.sub("ovi_", "", map_lib_name)
        else:
            if self.run_modelsim or self.run_questasim or self.run_riviera:
                self.create_dev_lib(map_lib_name)
            else:
                self.dev_lib = os.path.join(foundry_path, "..", "active-hdl", "Vlib", "ovi_" + map_lib_name,
                                            "ovi_"+ map_lib_name+".lib")
        self.dev_lib = os.path.abspath(self.dev_lib)

        self.do_args = dict()
        self.do_args["sim_top"] = self.sim_top
        self.do_args["src_top_module"]  = self.src_top_module
        self.do_args["uut_name"] = self.uut_name
        self.do_args["lib_name"] = "ovi_" + map_lib_name
        self.do_args["dev_name"] = map_lib_name
        self.do_args["diamond"] = os.path.dirname(foundry_path)  # On Linux, ENV-KEY FOUNDRY and foundry are different
        if self.resolution:
            self.do_args["resolution"] = "-t %s" % self.resolution
        else:
            self.do_args["resolution"] = ""


        if self.sim_time:
            _sim_time = self.sim_time
        else:
            _sim_time = "10 us"
        self.do_args["sim_time"] = _sim_time

    def create_dev_lib(self, map_lib_name):
        _diamond = os.path.dirname(os.getenv("FOUNDRY"))

        # the ORDER must be ("vhdl", "verilog")
        for hdl_type in ("vhdl", "verilog"):
            my_create = simLibrary.GetSimulationLibrary(_diamond, self.sim_vendor_name, self.sim_vendor_bin,
                                                        hdl_type, map_lib_name, self.conf, self.is_ng_flow)
            my_create.process()
            self.dev_lib = my_create.get_sim_lib_path()

    def run_rtl_simulation(self, sim_path):
        source_files = list()
        source_node = self.final_ldf_dict.get("source")
        for item in source_node:
            if item.get("excluded") == "TRUE":
                continue
            if item.get("syn_sim") == "SimOnly":
                continue
            type_short = item.get("type_short")
            if type_short in ("Verilog", "VHDL"):
                src_file = item.get("name")
                source_files.append(src_file)
        if len(source_files) == 1:
            if self.pmi:
                src_file = source_files[0]
                src_file = re.sub("_syn\.", ".", src_file)
                if os.path.isfile(src_file):
                    source_files = [src_file]
        return self._run_simulation(sim_path, source_files, "")

    def run_syn_vhd_simulation(self, sim_path):
        if self.synthesis == "lse":
            xTools.say_it("Error. when synthesis is lse, --run-syn-vlg supported only")
            return
        else:
            glob_pattern = os.path.join(self.impl_dir, "*.vhm")
            source_files = glob.glob(glob_pattern)
            if source_files:
                source_file = source_files[0]
            else:
                glob_pattern = os.path.join(self.impl_dir, "*.vhm")
                source_files = glob.glob(glob_pattern)
                if source_files:
                    source_file = source_files[0]
                else:
                    xTools.say_it("Error. Not found .vhm file for post Synplify simulation flow")
                    return 1
        if xTools.not_exists(source_file, "Post synthesis Simulation VHDL File"):
            return 1
        source_files = [os.path.join("..", source_file)]
        user_options = dict(run_syn_vhd=1)
        return self._run_simulation(sim_path, source_files, user_options)

    def run_syn_vlg_simulation(self, sim_path):
        if self.synthesis == "lse":
            glob_pattern = os.path.join(self.impl_dir, "*_prim.v")
            source_files = glob.glob(glob_pattern)
            if source_files:
                source_file = source_files[0]
            else:
                glob_pattern = os.path.join(self.impl_dir, "*.vm")
                source_files = glob.glob(glob_pattern)
                if source_files:
                    source_file = source_files[0]
                else:
                    xTools.say_it("Error. Not found _prim.v or .vm file for post lse simulation flow")
                    return 1
        else:
            glob_pattern = os.path.join(self.impl_dir, "*.vm")
            source_files = glob.glob(glob_pattern)
            if source_files:
                source_file = source_files[0]
            else:
                glob_pattern = os.path.join(self.impl_dir, "*.vm")
                source_files = glob.glob(glob_pattern)
                if source_files:
                    source_file = source_files[0]
                else:
                    xTools.say_it("Error. Not found _prim.v or .vm file for post Synplify simulation flow")
                    return 1
        if xTools.not_exists(source_file, "Post synthesis Simulation Verilog File"):
            return 1
        source_files = [os.path.join("..", source_file)]
        user_options = dict(run_syn_vlg=1)
        return self._run_simulation(sim_path, source_files, user_options)


    def run_map_vhd_simulation(self, sim_path):
        source_file = os.path.join(self.impl_dir, "%s_%s_mapvho.vho" % (self.project_name, self.impl_name))
        if xTools.not_exists(source_file, "Simulation Map VHDL File"):
            return 1
        source_files = [os.path.join("..", source_file)]
        self.sdf_file = os.path.splitext(source_file)[0] + ".sdf"
        user_options = dict(run_map_vhd=1)
        return self._run_simulation(sim_path, source_files, user_options)

    def run_map_vlg_simulation(self, sim_path):
        source_file = os.path.join(self.impl_dir, "%s_%s_mapvo.vo" % (self.project_name, self.impl_name))
        if xTools.not_exists(source_file, "Simulation Map Verilog File"):
            return 1
        source_files = [os.path.join("..", source_file)]
        self.sdf_file = os.path.splitext(source_file)[0] + ".sdf"
        user_options = dict(run_map_vlg=1)
        return self._run_simulation(sim_path, source_files, user_options)

    def run_par_vhd_simulation(self, sim_path):
        source_file = os.path.join(self.impl_dir, "%s_%s_vho.vho" % (self.project_name, self.impl_name))
        if xTools.not_exists(source_file, "Simulation Export VHDL File"):
            return 1
        source_files = [os.path.join("..", source_file)]
        self.sdf_file = os.path.splitext(source_file)[0] + ".sdf"
        user_options = dict(run_export_vhd=1)
        return self._run_simulation(sim_path, source_files, user_options)

    def run_par_vlg_simulation(self, sim_path):
        source_file = os.path.join(self.impl_dir, "%s_%s_vo.vo" % (self.project_name, self.impl_name))
        if xTools.not_exists(source_file, "Simulation Export Verilog File"):
            return 1
        source_files = [os.path.join("..", source_file)]
        self.sdf_file = os.path.splitext(source_file)[0] + ".sdf"
        user_options = dict(run_export_vlg=1)
        return self._run_simulation(sim_path, source_files, user_options)

    def copy_other_files(self):
        if self.others_path:
            hot_files = (".ngc", ".hex", ".mif", ".ngo", ".txt", ".mem", "", ".prf", ".rom")
            for foo in os.listdir(self.others_path):
                fname, fext = os.path.splitext(foo.lower())
                if fext in hot_files:
                    abs_foo = os.path.join(self.others_path, foo)
                    xTools.wrap_cp_file(abs_foo, foo)

    def add_sdf_file_if_need(self, vsim_line):
        if not self.with_sdf:
            return vsim_line
        _sdf_file = os.path.join("..", self.sdf_file)
        if not os.path.isfile(_sdf_file):
            return vsim_line

        my_sdf = ' -sdfmax /%(sim_top)s/%(uut_name)s=' % self.do_args
        my_sdf += '"%s" ' % xTools.win2unix(_sdf_file, 0)
        vsim_line = re.sub("\s+-L\s+", my_sdf + "-L ", vsim_line)
        return vsim_line

    def _run_simulation(self, sim_path, source_files, user_options):
        if xTools.wrap_md(sim_path, "Simulation Path"):
            return 1

        _recov = xTools.ChangeDir(sim_path)
        if self.copy_tb_files(""):
            _recov.comeback()
            return 1
        use_source_do_file = 0
        if not user_options: # rtl simulation
            if self.others_path:
                self.copy_other_files()
            src_lines = xTools.get_content_in_start_end(self.do_template, self.p_src_start, self.p_src_end)
            for src in src_lines:
                if re.search("(vlog|vcom)", src):
                    use_source_do_file = 1

        do_lines = list()
        need_remove_ovi = 0
        if use_source_do_file:  # modify do file and use it!
            start_source = 0
            start_tb = 0
            for line in open(self.do_template):
                line = line.rstrip()
                m_src_start = self.p_src_start.search(line)
                m_src_end = self.p_src_end.search(line)
                m_tb_start = self.p_tb_start.search(line)
                m_tb_end = self.p_tb_end.search(line)
                if not start_source:
                    start_source = m_src_start
                if m_src_end:
                    start_source = 0

                if not start_tb:
                    start_tb = m_tb_start
                if m_tb_end:
                    start_tb = 0

                if not (start_source or start_tb):
                    do_lines.append(line)
                elif start_source or start_tb:
                    new_line = get_new_real_path(self.do_template, line)
                    if start_source:
                        line_list = re.split("\s+", line.strip())
                        if line_list[0] in ("vlog", "vcom"):
                            hdl_file = line_list[-1]
                            real_hdl_file = xTools.get_relative_path(hdl_file, os.getcwd())
                            if not os.path.isfile(real_hdl_file):
                                real_hdl_file = xTools.get_relative_path(hdl_file, os.path.dirname(self.do_template))
                            if not os.path.isfile(real_hdl_file):
                                pass
                            else:
                                modified, real_hdl_file = get_real_hdl_file(real_hdl_file, self.run_scuba)
                                cur_fext = xTools.get_fext_lower(real_hdl_file)
                                if modified:
                                    if cur_fext == ".vhd":
                                        line_list = ["vcom", ""]
                                    else:
                                        line_list = ["vlog", ""]
                                line_list[-1] = real_hdl_file
                                if not need_remove_ovi:
                                    if xTools.get_fext_lower(real_hdl_file) in (".vho", ".vhd", ".vhdl"):
                                        need_remove_ovi = 1
                                new_line = " ".join(line_list)
                    do_lines.append(new_line)
        else:
            start_source = start_tb = 0
            for line in open(self.do_template):
                line = line.rstrip()
                if re.search("%", line):
                    line = line % self.do_args
                    do_lines.append(line)
                    continue
                if start_source:
                    if self.p_src_end.search(line):
                        if not user_options: # RTL simulation
                            source_files = [xTools.get_relative_path(item, self.dst_design) for item in source_files]
                        v_v_line = self.add_vlog_vcom_lines(source_files)
                        if not v_v_line:
                            #Sometimes only has a testbench file, no source files found
                            xTools.say_it("Warning. Not any source files for running %s" % sim_path)
                            xTools.say_it("")
                            #_recov.comeback()
                            #return 1
                        need_remove_ovi = self.use_vhd
                        if v_v_line:
                            do_lines += v_v_line[:]
                        start_source = 0
                        do_lines.append(line)
                    continue
                else:
                    start_source = self.p_src_start.search(line)
                    if start_source:
                        do_lines.append(line)
                        continue

                if start_tb:
                    if self.p_tb_end.search(line):
                        _kk = self.use_vhd
                        v_v_line = self.add_vlog_vcom_lines(self.final_tb_files, add_tb=1)
                        self.use_vhd = _kk
                        do_lines += v_v_line[:]
                        start_tb = 0
                        do_lines.append(line)
                    continue
                else:
                    start_tb = self.p_tb_start.search(line)
                    if start_tb:
                        do_lines.append(line)
                        continue
                do_lines.append(line)
        do_file = "do_%s.do" % sim_path

        new_do_lines = list()
        lib_name = xTools.get_fname(self.dev_lib)
        if need_remove_ovi:
            lib_name = re.sub("ovi_", "", lib_name)

        p1 = re.compile("vmap\s+(\S+)\s+(\$dev_lib)")
        p2 = ""
        tmp_lib_name = ""
        for _ in do_lines:
            if p1:
                m1 = p1.search(_)
                if m1:
                    p1 = ""
                    p2 = re.compile("vsim.+\s+-L\s+%s" % m1.group(1))
                    tmp_lib_name = m1.group(1)
                    _ = "vmap %s %s" % (lib_name, m1.group(2))
            elif p2:
                m2 = p2.search(_)
                if m2:
                    p2 = ""
                    _ = re.sub("-L\s+%s" % tmp_lib_name, "-L %s" % lib_name, _)
                    _ = self.add_sdf_file_if_need(_)
            new_do_lines.append(_)
        xTools.write_file(do_file, new_do_lines)
        utils.update_simulation_do_file(self.sim_vendor_name, do_file, self.lst_precision)

        args = "%s %s %s cmd %s %s" % (do_file, self.dev_lib, self.pri_lib, self.diamond, self.src_lib)


        if self.run_modelsim or self.run_questasim:
            sim_cmd = '%s/vsim -l sim_log.txt -c -do "do %s"' % (self.sim_vendor_bin, args)
        else:
            sim_cmd = "%s/vsimsa -l sim_log.txt -do %s" % (self.sim_vendor_bin, args)
        sim_cmd = xTools.win2unix(sim_cmd, 0)
        if need_remove_ovi:
            sim_cmd = re.sub("ovi_", "", sim_cmd)
        # /*
        #  * If license not found, will launch again in 10 times.
        #  */
        log_file = "run_%s.log" % sim_path
        time_file = "run_%s.time" % sim_path
        sts = 0
        for i in range(10):
            if xTools.remove_dir_without_error(log_file):
                _recov.comeback()
                return 1
            sts = xTools.run_command(sim_cmd, log_file, time_file)
            if sts:
                if xTools.simple_parser(log_file, [re.compile("Unable to checkout a license")]):
                    xTools.say_it("Warning. No licence for running simulation. waiting ...")
                    time.sleep(i*10)
                else:
                    break
            else:
                break
        dump_vcd_file()

        _recov.comeback()
        return sts

    def copy_tb_files(self, sim_path):
        """
         -1.0---- DO NOT COPY TEST BENCH FILEs ----
         -2.0---- Copy all files/dirs under sim path
         -3.0---- Updated 2.0, copy all files/dirs under the customer's do file folder
        """
        p_template = re.compile("""\W
                                   conf
                                   \W
                                   sim
                                   \W
                                   .+
                                   \.template$
                                """, re.X)
        if not sim_path:
            sim_path = os.getcwd()
        ori_sim_path = os.path.join(self.src_design, "sim")
        if not os.path.isdir(ori_sim_path):
            if p_template.search(self.do_template):
                pass
            else:
                ori_sim_path = os.path.dirname(self.do_template)
        if os.path.isdir(ori_sim_path):
            if wrap_cp_dir(ori_sim_path, sim_path):
                xTools.say_it("Error. Failed to copy path from %s to %s" % (ori_sim_path, sim_path))
                return 1

        # /*
        #  *normal_tb: True if no content between <tb_start> and <tb_end>
        #  * First try to get the tb file from template file
        #  * Then the tb_file in the info file.
        #  */
        self.normal_tb = 0
        raw_tb_file = xTools.get_content_in_start_end(self.do_template, self.p_tb_start, self.p_tb_end)
        _tb_file = list()
        if raw_tb_file:
            for item in raw_tb_file:
                if re.search("\.\.\.", item):
                    continue
                new_item = get_new_real_path(self.do_template, item)
                _tb_file.append(new_item)

        if not _tb_file:
            if self.tb_file:
                _tb_file = xTools.to_abs_list(self.tb_file, self.src_design)
                _tb_file = xTools.get_src_files(_tb_file, sim_path)
                _tb_file = [_[-1] for _ in _tb_file]
                self.normal_tb = 1
            else:
                xTools.say_it("Warning. Not found any testbench file")
                # return 1
        if not _tb_file:
            xTools.say_it("Warning. Not found any testbench file in the design configuration")
            # return 1
        if self.tb_vector:
            _tb_vector_files = xTools.to_abs_list(self.tb_vector, self.src_design)
            for item in _tb_vector_files:
                xTools.wrap_cp_file(item, os.path.join(sim_path, os.path.basename(item)))
        self.final_tb_files = _tb_file[:]

    def add_vlog_vcom_lines(self, src_files, add_tb=0):
        self.use_vhd = 0
        if add_tb and not self.normal_tb:  # use them directly.
            v_v_lines = src_files[:]
        else:
            v_v_lines = list()
            for item in src_files:
                fext = xTools.get_fext_lower(item)
                item = xTools.win2unix(item, 0)
                if fext in (".v", ".vo", ".sv", ".vm"):
                    v_v_lines.append("vlog %s" % item)
                elif fext in (".vho", ".vhd", ".vhdl", ".vhm"):
                    v_v_lines.append("vcom %s" % item)
                    if  not self.use_vhd:
                        self.use_vhd = 1
                elif fext == ".lpf":
                    continue
                else:
                    xTools.say_it("-Warning. Unknown file: %s" % item)
                    continue
        return v_v_lines


def wrap_cp_dir(src, dst):
    if xTools.wrap_md(dst, "new folder"):
        return 1
    for foo in os.listdir(src):
        src_foo = os.path.join(src, foo)
        dst_foo = os.path.join(dst, foo)
        if os.path.isdir(src_foo):
            if wrap_cp_dir(src_foo, dst_foo):
                return 1
        else:
            if xTools.wrap_cp_file(src_foo, dst_foo):
                return 1


if __name__ == "__main__":
    # pp = RunSimulationFlow(dict(sim=dict(a=1)), "a_file", dict())
    # pp.process()
    #
    dump_vcd_file(r"D:\sfang")
    #
