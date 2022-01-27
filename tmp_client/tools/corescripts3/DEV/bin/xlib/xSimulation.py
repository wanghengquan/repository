import os
import re
import sys
import time
import glob
import shutil

from . import xTools
from . import xReport
from . import xLatticeDev
from . import xLattice
from . import simLibrary
from . import utils
from . import filelock

from . import yTimeout

from .Verilog_VCD import Verilog_VCD

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
            vcd_txt = "%s_vcd.txt" % fname
            dump_file = os.path.join(cur_dir, vcd_txt)
            xTools.say_it("  Dumping %s to %s" % (foo, vcd_txt))
            dump_lines = list()
            keys = list(vcd_data.keys())
            keys.sort()
            for k in keys:
                v = vcd_data.get(k)
                nets = v.get("nets")[0]
                hier = nets.get("hier")
                if hier != "sim_top.uut":
                    continue
                dump_lines.append("-" * 10)
                nets_keys = list(nets.keys())
                nets_keys.sort()
                dump_lines += ["%s : %s" % (nk, nets.get(nk)) for nk in nets_keys]
                dump_lines += xTools.distribute_list("time-value", v.get("tv"), 15)
            xTools.write_file(dump_file, dump_lines)
        except:
            xTools.say_it("Warning. Failed to dump from %s" % (os.path.join(cur_dir, foo)))
            xTools.say_tb_msg()
            return


def get_real_hdl_file(real_hdl_file, run_scuba):
    if not run_scuba:
        return 0, real_hdl_file
    is_model_file = xReport.file_simple_parser(real_hdl_file, [re.compile("\S+scuba\.exe(.+)")], 80)
    if not is_model_file:
        return 0, real_hdl_file
    # find scuba command!
    fext = xTools.get_fext_lower(real_hdl_file)
    new_fext = fext
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


def add_dbg_for_vlog(raw_line):
    if " -dbg " in raw_line:
        return raw_line
    return re.sub("vlog\s+", "vlog -dbg ", raw_line)


def get_new_real_path(do_file, line):
    do_dir = os.path.dirname(do_file)
    new_line = list()
    for foo in line.split():
        _x = list()
        for bar in foo.split("+"):
            if not bar:
                _x.append("")
            elif bar == "\\":
                _x.append(bar)
            else:
                new_bar = xTools.get_relative_path(bar, do_dir)
                _x.append(new_bar if os.path.exists(new_bar) else bar)
        new_line.append("+".join(_x))
    return " ".join(new_line)


class RunSimulationFlow:
    def __init__(self, flow_options, final_ldf_file, final_ldf_dict):
        self.flow_options = flow_options
        self.is_ng_flow = flow_options.get("is_ng_flow")
        self.final_ldf_dict = final_ldf_dict
        self.final_ldf_file = final_ldf_file
        self.conf = flow_options.get("conf")
        self.run_scuba = flow_options.get("run_scuba")
        self.sim_with_sdf = flow_options.get("sim_with_sdf")
        self.sdf_file = ""  # will be defined in main simulation function
        self.local_lib = list()

        self.p_src_start = re.compile("<source_start>")
        self.p_src_end = re.compile("<source_end>")
        self.p_tb_start = re.compile("<tb_start>")
        self.p_tb_end = re.compile("<tb_end>")
        self.p_vlog_vcom = re.compile("^(vlog|vcom)", re.I)
        self.use_vhd = 0

    def run_udb2_flow(self):
        if not self.is_ng_flow:
            return
        if not self.flow_options.get("run_udb"):
            return
        _recov = xTools.ChangeDir(self.impl_name)
        udb_file = "%s_%s.udb" % (self.project_name, self.impl_name)
        cmd_lines = [("udb2sv -view physical %s -o test_udb2sv.v" % udb_file, "flow_udb2sv"),
                     #("udb2txt %s -o test_udb2txt.xml" % udb_file, "flow_udb2txt"),
                     #("bitgen -dw -simbitmap %s" % udb_file, "flow_bitgen")
                    ]
        for cl, t in cmd_lines:
            xTools.run_command(cl, "%s.log" % t, "%s.time" % t)  # Do not care return code
        _recov.comeback()

    def run_udb2sv_flow(self):
        if not self.is_ng_flow:
            return
        udb2sv_cmd_list = self.flow_options.get("run_udb2sv")
        if not udb2sv_cmd_list:
            return
        cmd_args = dict(rtl=("rtl", "_rtl", "_rtl"),
                        syn=("logical", "_syn", "_syn"),
                        map=("physical", "_map", "_map"),
                        par=("physical", "", "_par"),)
        cmd_tmpl = "udb2sv -w -view {0} %s_%s{1}.udb -o test_udb2sv{2}.v" % (self.project_name, self.impl_name)
        _recov = xTools.ChangeDir(self.impl_name)
        for x in udb2sv_cmd_list:
            my_cmd = cmd_tmpl.format(*cmd_args.get(x))
            xTools.run_command(my_cmd, "udb2sv_%s.log" % x, "udb2sv_%s.time" % x)  # Do not care return code
        _recov.comeback()

    def process(self):
        sim_vendor_bin = os.getenv("SIM_VENDOR_BIN")
        if sim_vendor_bin not in ("VCS", "XRUN"):
            if xTools.not_exists(sim_vendor_bin, "Simulation tool bin path"):
                return 1
        self.sim_vendor_bin = xTools.win2unix(sim_vendor_bin)
        if self.flatten_options():
            return 1
        user_options = self.get_user_options()
        sts = 0
        dnio = False if self.is_ng_flow else True
        if self.is_ng_flow:
            if user_options:
                user_options["run_synthesis"] = 1
            if user_options.get("run_map_vhd") or user_options.get("run_map_vlg"):
                user_options["run_map_trace"] = 1
            if user_options.get("run_export_vhd") or user_options.get("run_export_vlg"):
                user_options["run_par_trace"] = 1
        task_list = xLattice.get_task_list(self.flow_options, user_options, donot_infer_options=dnio)
        if task_list:
            sts = xLattice.run_ldf_file("run_pb.tcl", self.final_ldf_file, task_list, list(), self.is_ng_flow)
            if sts:
                xTools.say_it("-Warning. errors found in normal implementation flow")
            self.run_udb2sv_flow()
            self.run_udb2_flow()
        if self.get_pmi_file():
            return 1

        for (sim_type, sim_path, sim_func) in (
            (self.sim_rtl, "sim_rtl", self.run_rtl_simulation),
            (self.sim_syn_vhd, "sim_syn_vhd", self.run_syn_vhd_simulation),
            (self.sim_syn_vlg, "sim_syn_vlg", self.run_syn_vlg_simulation),
            (self.sim_map_vhd, "sim_map_vhd", self.run_map_vhd_simulation),
            (self.sim_map_vlg, "sim_map_vlg", self.run_map_vlg_simulation),
            (self.sim_par_vhd, "sim_par_vhd", self.run_par_vhd_simulation),
            (self.sim_par_vlg, "sim_par_vlg", self.run_par_vlg_simulation),
            (self.sim_bit_vlg, "sim_bit_vlg", self.run_bit_vlg_simulation),
        ):
            if sim_type:
                if sim_path == "sim_syn_vlg":
                    self.generate_syn_vo_file()
                sts = sim_func(sim_path)
        if self.local_lib:
            for ll in self.local_lib:
                shutil.rmtree(ll, ignore_errors=True)

        if self.run_simrel:
            sts = self.run_simrel_flow()
        if self.flow_options.get("dms"):
            from . import xDMS
            dms_flow = xDMS.RunDMSFlow(self.project_name, self.impl_name, self.impl_dir,
                                       self.flow_options.get("conf"),
                                       self.flow_options.get("questasim_path"),
                                       self.flow_options.get("sim"))
            dms_flow.process()
        return sts

    def generate_syn_vo_file(self):
        if not self.is_ng_flow:
            return
        udb_files = glob.glob(os.path.join(os.getcwd(), self.impl_dir, "*_syn.udb"))
        if udb_files:
            syn_udb_file = os.path.basename(udb_files[0])
            syn_vo_file = os.path.splitext(syn_udb_file)[0] + ".vo"
            # log2sim -w -o "vhdl_DmTest_syn.vo" "vhdl_DmTest.udb"
            cmd = 'log2sim -w -o "{0}/{1}" "{0}/{2}"'.format(self.impl_dir, syn_vo_file, syn_udb_file)
            xTools.run_command(cmd, "log2sim.log", "log2sim.time")

    def run_simrel_flow(self):
        _t = os.path.abspath(os.path.join(os.getcwd(), ".."))
        my_recov = xTools.ChangeDir(_t)
        from . import xSimrel
        avc_file = ""
        simrel_section = self.flow_options.get("simrel", dict())
        if simrel_section:
            _avc_file = simrel_section.get("avc_file")
            if _avc_file:
                _avc_file = xTools.get_abs_path(_avc_file, self.src_design)
                if xTools.not_exists(_avc_file, "customer AVC file"):
                    return 1
                avc_file = _avc_file
        old_log_name = os.getenv("BQS_L_O_G", "")
        os.environ["BQS_L_O_G"] = ""
        sts = xSimrel.main(self.flow_options, self.simrel_path, self.run_simrel, self.sim_vendor_name,
                           simrel_section, avc_file, self.lst_precision, os.path.basename(self.dst_design),
                           info_dirname=self.src_design)
        os.environ["BQS_L_O_G"] = old_log_name
        my_recov.comeback()
        return sts

    def get_user_options(self):
        user_options = dict()
        for (sim_type, flow_opt) in (
            (self.sim_map_vhd, "run_map_vhd"),
            (self.sim_map_vlg, "run_map_vlg"),
            (self.sim_par_vhd, "run_export_vhd"),
            (self.sim_par_vlg, "run_export_vlg"),
            (self.sim_bit_vlg, "run_export_vlg"),
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
        self.sim_bit_vlg = xTools.get_true(self.flow_options, "sim_bit_vlg")
        self.sim_par_vhd = xTools.get_true(self.flow_options, "sim_par_vhd")
        self.sim_postsyn_vm = xTools.get_true(self.flow_options, "sim_postsyn_vm")
        self.sim_no_lst = xTools.get_true(self.flow_options, "sim_no_lst")
        self.sim_all = xTools.get_true(self.flow_options, "sim_all")
        self.simrel_path = self.flow_options.get("simrel_path")
        self.run_simrel = self.flow_options.get("run_simrel")
        self.pmi = xTools.get_true(self.flow_options, "pmi")
        self.lst_precision = self.flow_options.get("lst_precision")
        if self.sim_all:
            self.sim_rtl = self.sim_map_vhd = self.sim_map_vlg = self.sim_par_vhd = self.sim_par_vlg = 1
            if self.is_ng_flow:
                self.sim_par_vhd = 0
                self.sim_bit_vlg = 0 if sys.platform.startswith("win") else 1
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
        self.suppress = sim_section.get("suppress")
        self.questasim_resolution = sim_section.get("questasim_resolution")
        if not self.uut_name:
            self.uut_name = "UUT"
        self.sim_time = sim_section.get("sim_time")
        self.do_msim = sim_section.get("do_msim")
        self.do_qsim = sim_section.get("do_qsim")
        self.do_ahdl = sim_section.get("do_asim")
        self.do_riviera = sim_section.get("do_rsim")
        self.do_vcs = sim_section.get("do_vcs")
        self.do_xrun = sim_section.get("do_xrun")
        self.use_dbg_in_riviera = xTools.get_true(sim_section, "use_dbg_in_riviera")

        _conf = self.flow_options.get("conf")
        if not self.do_msim:
            if self.run_simrel:
                self.do_msim = os.path.join(_conf, "sim", "msim_do_simrel.template")
            else:
                self.do_msim = os.path.join(_conf, "sim", "msim_do.template")
        if not self.do_qsim:
            self.do_qsim = os.path.join(_conf, "sim", "qsim_do.template")
        if not self.do_riviera:
            self.do_riviera = os.path.join(_conf, "sim", "rsim_do.template")
        if not self.do_ahdl:
            self.do_ahdl = os.path.join(_conf, "sim", "ahdl_do.template")
        if not self.do_vcs:
            self.do_vcs = os.path.join(_conf, "sim", "vcs_do.template")
        if not self.do_xrun:
            self.do_xrun = os.path.join(_conf, "sim", "xrun_do.template")

        self.run_modelsim = xTools.get_true(self.flow_options, "run_modelsim")
        self.run_questasim = xTools.get_true(self.flow_options, "run_questasim")
        self.run_riviera = xTools.get_true(self.flow_options, "run_riviera")
        self.run_activehdl = xTools.get_true(self.flow_options, "run_activehdl")
        self.run_vcs = xTools.get_true(self.flow_options, "run_vcs")
        self.run_xrun = xTools.get_true(self.flow_options, "run_xrun")

        if self.run_modelsim:
            self.do_template = self.do_msim
            self.sim_vendor_name = "Modelsim"
        elif self.run_questasim:
            self.do_template = self.do_qsim
            self.sim_vendor_name = "QuestaSim"
        elif self.run_riviera:
            self.do_template = self.do_riviera
            self.sim_vendor_name = "Riviera"
        elif self.run_vcs:
            self.do_template = self.do_vcs
            self.sim_vendor_name = "vcs"
        elif self.run_xrun:
            self.do_template = self.do_xrun
            self.sim_vendor_name = "xrun"
        else:
            self.do_template = self.do_ahdl
            self.sim_vendor_name = "Active"
            skip_env_key = "ALDEC_LICENSE_FILE"
            if skip_env_key in os.environ:
                os.environ.pop(skip_env_key)
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
            family_name = device.lower()
        if self.is_ng_flow:
            radiant_sim_map_dict = self.flow_options.get("family_radiant_map_sim_lib", dict())
            for k, v in list(radiant_sim_map_dict.items()):
                if family_name.startswith(k):
                    map_lib_name = v
                    break
            else:  # change 5k to None, \d\d to 00
                family_name_list = family_name.split("-|_")
                perhaps_name = family_name_list[0]
                perhaps_name = re.sub(r"\d+k$", "", perhaps_name)
                perhaps_name = re.sub(r"\d+$", "00", perhaps_name)
                map_lib_name = perhaps_name
                print("Warning. use perhaps simulation library name: {}".format(map_lib_name))
        else:
            my_dict = self.flow_options.get("family_diamond_map_sim_lib")
            map_lib_name = my_dict.get(family_name.lower())
        if not map_lib_name:
            map_lib_name = family_name.lower()
            xTools.say_it("Message: Use map lib name: %s" % map_lib_name)
        if not self.run_vcs:  # compile library when running
            if self.dev_lib:  # cross simulation test!
                map_lib_name = self.dev_lib
                map_lib_name = re.sub("ovi_", "", map_lib_name)
            else:
                if self.build_this_dev_lib(_conf, map_lib_name, family_name):
                    return 1
            self.dev_lib = os.path.abspath(self.dev_lib)
            if xTools.not_exists(self.dev_lib, "General Simulation Lib path"):
                return 1
        else:
            self.pmi_lib = ""

        self.do_args = dict()
        self.do_args["sim_top"] = self.sim_top
        self.do_args["src_top_module"] = self.src_top_module
        self.do_args["uut_name"] = self.uut_name
        self.do_args["lib_name"] = "ovi_" + map_lib_name
        self.do_args["dev_name"] = map_lib_name
        self.do_args["dev_name_lower"] = map_lib_name.lower()

        if os.path.exists(self.pmi_lib):
            self.do_args["vmap_pmi"] = "vmap pmi_work {}".format(self.pmi_lib)
            if self.sim_vendor_name == "Active":
                self.do_args["pmi_work"] = "-PL pmi_work"
            else:
                self.do_args["pmi_work"] = "-L pmi_work"
        else:
            self.do_args["vmap_pmi"] = "# vmap pmi_work {}".format(self.pmi_lib)
            self.do_args["pmi_work"] = ""
        self.add_black_box_args(map_lib_name)

        self.do_args["diamond"] = os.path.dirname(foundry_path)  # On Linux, ENV-KEY FOUNDRY and foundry are different
        self.do_args["active-hdl"] = os.path.dirname(self.sim_vendor_bin)

        res = self.questasim_resolution if self.sim_vendor_name == "QuestaSim" else self.resolution
        self.do_args["resolution"] = "-t %s" % res if res else ""
        self.do_args["suppress"] = "-suppress {}".format(self.suppress) if self.suppress else ""
        if self.sim_time:
            _sim_time = self.sim_time
        else:
            _sim_time = "10 us"
        self.do_args["sim_time"] = _sim_time

    def add_black_box_args(self, dev_name):
        self.do_args["black_boxes_0"] = ""
        self.do_args["black_boxes_1"] = ""
        base_dir = os.path.dirname(os.getenv("FOUNDRY"))
        if not os.path.isdir(base_dir):
            return
        bb_dir = os.path.join(base_dir, "cae_library", "simulation", "blackbox")
        if not os.path.isdir(bb_dir):
            return
        chk_dir = os.path.join(bb_dir, "{}_black_boxes".format(dev_name))
        chk_file = os.path.join(bb_dir, "{}_black_boxes-aldec.vp".format(dev_name))

        if self.sim_vendor_name in ("Riviera", "Active"):
            if os.path.isfile(chk_file):
                x = "vlog -v2k5 -work black_box $lsc_dir/cae_library/simulation/blackbox"
                self.do_args["black_boxes_0"] = "{}/{}".format(x, os.path.basename(chk_file))
        else:
            if os.path.isdir(chk_dir):
                y = "vmap black_box $lsc_dir/cae_library/simulation/blackbox"
                self.do_args["black_boxes_0"] = "{}/{}".format(y, os.path.basename(chk_dir))
                self.do_args["black_boxes_1"] = "vlog -work black_box -refresh"

    def create_dev_lib(self, map_lib_name, sim_lib_folder):
        _diamond = os.path.dirname(os.getenv("FOUNDRY"))

        # the ORDER must be ("vhdl", "verilog")
        for hdl_type in ("vhdl", "verilog"):
            my_create = simLibrary.GetSimulationLibrary(_diamond, self.sim_vendor_name, self.sim_vendor_bin, hdl_type,
                                                        map_lib_name, self.conf, self.is_ng_flow, sim_lib_folder,
                                                        self.flow_options)
            my_create.process()
            self.dev_lib = my_create.get_sim_lib_path()
            if "Active" in self.sim_vendor_name:
                self.dev_lib = os.path.join(self.dev_lib, "{}.lib".format(os.path.basename(self.dev_lib)))

    def create_pmi_lib(self, sim_lib_folder):
        _diamond = os.path.dirname(os.getenv("FOUNDRY"))
        my_create = simLibrary.GetSimulationLibrary(_diamond, self.sim_vendor_name, self.sim_vendor_bin,
                                                    "verilog", "pmi", self.conf, self.is_ng_flow, sim_lib_folder,
                                                    self.flow_options)
        my_create.process()
        self.pmi_lib = my_create.get_sim_lib_path()
        if "Active" in self.sim_vendor_name:
            self.pmi_lib = os.path.join(self.pmi_lib, "pmi.lib")

    def get_pmi_file(self):
        radiant_point_path = os.path.dirname(os.getenv("FOUNDRY", "NoFoundryPath"))
        try:
            pmi_v_file = "pmi_%s.v" % self.do_args.get("dev_name", "NoDevName")
        except Exception:
            print("No found do_args dictionary, check previous failed logs")
            return 1
        if os.getenv("BALI_USE_FOUNDRY_OUTSIDE") == "1":
            _pmi_v = os.path.join(radiant_point_path, "env", "rtf", "ip", "pmi", pmi_v_file)
        else:
            _pmi_v = os.path.join(radiant_point_path, "ip", "pmi", pmi_v_file)
        self.this_pmi_file = _pmi_v

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
            elif type_short == "IPX":
                ipx_file = item.get("name")
                module_file = utils.get_module_file(ipx_file)
                if module_file:
                    if self.is_ng_flow:
                        pass
                        # source_files.insert(0, self.this_pmi_file)
                    source_files.append(module_file)
                else:
                    xTools.say_it("Warning. Not found verilog file for %s" % ipx_file)
            elif type_short == "SBX":
                sbx_file = item.get("name")
                module_file = utils.get_module_file_from_sbx(sbx_file)
                if module_file:
                    source_files.append(module_file)
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
            search_order = ("%s_%s_syn.vo" % (self.project_name, self.impl_name),
                            "%s_%s.vm" % (self.project_name, self.impl_name),
                            "%s_prim.v" % self.project_name,
                            "*_prim.v")
        else:
            search_order = ("%s_%s_syn.vo" % (self.project_name, self.impl_name),
                            "%s_%s.vm" % (self.project_name, self.impl_name))
        for so in search_order:
            if self.sim_postsyn_vm:
                if ".vo" in so:
                    continue
            files = glob.glob(os.path.join(self.impl_dir, so))
            if files:
                source_file = files[0]
                break
        else:
            keyword = "Warning" if self.sim_all else "Error"
            xTools.say_it("{}. Not found syn_vlg simulation file.".format(keyword))
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

    def run_bit_vlg_simulation(self, sim_path):
        udb_file = "%s_%s.udb" % (self.project_name, self.impl_name)
        source_file = utils.generate_bit2sim_vo_file(self.impl_dir, udb_file, os.getenv("FOUNDRY"))
        if xTools.not_exists(source_file, "Simulation bit2sim Verilog File"):
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
        if not self.sim_with_sdf:
            return vsim_line
        _sdf_file = os.path.join("..", self.sdf_file)
        if not os.path.isfile(_sdf_file):
            return vsim_line
        my_sdf = ' -sdf%s ' % self.sim_with_sdf

        my_sdf += '/%(sim_top)s/%(uut_name)s=' % self.do_args
        my_sdf += '%s ' % xTools.win2unix(_sdf_file, 0)
        vsim_line = re.sub("\s+-L\s+", my_sdf + "-L ", vsim_line, count=1)
        return vsim_line

    def modify_dbg(self, raw_line):
        chk_line = raw_line.strip()
        if self.sim_vendor_name != "Riviera":
            pass
        elif self.use_dbg_in_riviera is None:
            pass
        elif not chk_line.startswith('vsim '):
            pass
        else:
            raw_line = re.sub(r"\s+-dbg\s+", " ", raw_line)
            if self.use_dbg_in_riviera:
                raw_line = re.sub(r"vsim\s+", "vsim -dbg ", raw_line)
        return raw_line

    def try_to_update_file_if_scuba(self, ovi_tag, raw_line):
        raw_line = raw_line.strip()
        if self.p_vlog_vcom.search(raw_line):
            return ovi_tag, raw_line
        raw_line_list = raw_line.split()
        new_line_list = list()
        for foo in raw_line_list:
            if os.path.exists(foo):
                modified, real_hdl_file = get_real_hdl_file(foo, self.run_scuba)
                cur_fext = xTools.get_fext_lower(real_hdl_file)
                if modified:
                    if new_line_list[0].lower() in ("vcom", "vlog"):
                        new_line_list[0] = "vcom" if cur_fext == ".vhd" else "vlog"
                    new_line_list.append(real_hdl_file)
                else:
                    new_line_list.append(foo)
                if not ovi_tag:
                    if cur_fext in (".vho", ".vhd", ".vhdl"):
                        ovi_tag = 1
            else:
                new_line_list.append(foo)
        return ovi_tag, " ".join(new_line_list)

    @staticmethod
    def group_by_file_extension(raw_files):
        group_list = list()
        group_name, _ = "", list()
        for i, foo in enumerate(raw_files):
            fext = os.path.splitext(foo)[1]
            if group_name:
                if fext == group_name:
                    _.append(foo)
                else:
                    group_name = fext
                    group_list.append(_[:])
                    _ = [foo]
            else:
                group_name = fext
                _.append(foo)
        if _:
            group_list.append(_[:])
        return group_list

    def get_vcs_lines(self, hdl_files, is_source_file=False):
        lines = list()
        group_hdl_files = self.group_by_file_extension(hdl_files)
        for foo in group_hdl_files:
            fext = os.path.splitext(foo[0])[1]
            all_files = " ".join(foo)
            if fext.lower() in (".vho", ".vhd", ".vhdl", ".vhm"):
                lines.append("vhdlan %s" % all_files)
            else:
                if self.is_thunder_plus:
                    if is_source_file:
                        lines.append("vlogan -v2005 -timescale=1ns/1ps %s $VERILOG_READY" % all_files)
                    else:
                        lines.append("vlogan -v2005 %s $VERILOG_READY" % all_files)
                else:
                    lines.append("vlogan -sverilog %s $VERILOG_READY" % all_files)
        return "\n".join(lines)

    def get_xrun_lines(self, hdl_files):
        lines = list()
        for foo in hdl_files:
            fext = xTools.get_fext_lower(foo)
            if fext in (".vho", ".vhd", ".vhdl", ".vhm"):
                lines.append("xrun -v200x -compile {}".format(foo))
            elif fext == ".v":
                lines.append("xrun -compile {}".format(foo))
            elif fext == ".vo":
                lines.append("xrun -compile {} -vlog_ext +.vo ".format(foo))
        return "\n".join(lines)

    def run_simulation_flow_with_vcs(self, sim_path, source_files, user_options):
        with open("ucli.cmd", "w", newline="\n") as ob:
            print("run %(sim_time)s" % self.do_args, file=ob)
            print("quit", file=ob)
        if not user_options:  # RTL simulation
            source_files = [xTools.get_relative_path(item, self.dst_design) for item in source_files]
        if self.is_ng_flow and "ice" in self.do_args.get("dev_name", "").lower():
            self.is_thunder_plus = True
        else:
            self.is_thunder_plus = False

        self.do_args["source_files"] = self.get_vcs_lines(source_files, is_source_file=True)
        self.do_args["tb_files"] = self.get_vcs_lines(self.final_tb_files)
        x = "do_{}".format(sim_path)
        y = "run_{}".format(sim_path)
        sh_file = "{}.sh".format(x)
        with open(sh_file, "w", newline="\n") as wob:
            with open(self.do_vcs) as rob:
                for line in rob:
                    line = line.rstrip()
                    if self.is_thunder_plus:
                        new_line = re.sub(r"-y \$\{_UAP\}", " ", line)
                        new_line = re.sub(r"\+\$\{_UAP\}", "", new_line)
                        new_line = re.sub(r"-sverilog", "-v2005 ", new_line)
                    else:
                        new_line = line
                    print(new_line % self.do_args, file=wob)
        xTools.run_command("sh {} {}".format(sh_file, self.do_args["diamond"]), "{}.log".format(y), "{}.time".format(y))

    def run_simulation_flow_with_xrun(self, sim_path, source_files, user_options):
        with open("ucli.tcl", "w", newline="\n") as ob:
            print("run %(sim_time)s" % self.do_args, file=ob)
            print("exit 0", file=ob)
        if not user_options:  # RTL simulation
            source_files = [xTools.get_relative_path(item, self.dst_design) for item in source_files]
        self.do_args["source_files"] = self.get_xrun_lines(source_files)
        self.do_args["tb_files"] = self.get_xrun_lines(self.final_tb_files)
        self.do_args["dev_lib"] = os.path.join(os.path.dirname(self.dev_lib), re.sub("^ovi_", "", os.path.basename(self.dev_lib)))
        self.do_args["pmi_lib"] = self.pmi_lib
        x = "do_{}".format(sim_path)
        y = "run_{}".format(sim_path)
        sh_file = "{}.sh".format(x)
        with open(sh_file, "w", newline="\n") as wob:
            with open(self.do_xrun) as rob:
                for line in rob:
                    line = line.rstrip()
                    real_line = line % self.do_args
                    if re.search(r"xrun\s+-(compile|batch)", real_line):
                        line += " -timescale '1ns/1ps'"
                    print(line % self.do_args, file=wob)
        xTools.run_command("sh {} {}".format(sh_file, self.do_args["diamond"]), "{}.log".format(y), "{}.time".format(y))

    def _run_simulation(self, sim_path, source_files, user_options):
        if self.is_ng_flow:
            pass  # DO NOT INCLUDE PMI File
            # if self.this_pmi_file not in source_files:
            #     source_files.insert(0, self.this_pmi_file)
        if xTools.wrap_md(sim_path, "Simulation Path"):
            return 1

        _recov = xTools.ChangeDir(sim_path)
        if self.copy_tb_files(""):
            _recov.comeback()
            return 1
        if self.run_vcs:
            self.run_simulation_flow_with_vcs(sim_path, source_files, user_options)
            _recov.comeback()
            return
        if self.run_xrun:
            self.run_simulation_flow_with_xrun(sim_path, source_files, user_options)
            _recov.comeback()
            return
        use_source_do_file = 0
        if not user_options:  # rtl simulation
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
                        need_remove_ovi, new_line = self.try_to_update_file_if_scuba(need_remove_ovi, new_line)
                    do_lines.append(new_line)
        else:
            start_source = start_tb = 0
            for line in open(self.do_template):
                line = line.rstrip()
                if re.search("%", line):
                    line = line % self.do_args
                    line = self.modify_dbg(line)
                    do_lines.append(line)
                    continue
                if start_source:
                    if self.p_src_end.search(line):
                        if not user_options:  # RTL simulation
                            source_files = [xTools.get_relative_path(item, self.dst_design) for item in source_files]
                        v_v_line = self.add_vlog_vcom_lines(source_files)

                        if not v_v_line:
                            # Sometimes only has a test bench file, no source files found
                            xTools.say_it("Warning. Not any source files for running %s" % sim_path)
                            xTools.say_it("")
                            # _recov.comeback()
                            # return 1
                        if self.sim_vendor_name == "Riviera":
                            v_v_line = list(map(add_dbg_for_vlog, v_v_line))
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
                        if self.sim_vendor_name == "Riviera":
                            v_v_line = list(map(add_dbg_for_vlog, v_v_line))
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
        p_gen_lst = re.compile("(asdb2ctf|asdb2lst|write\s+list).+\.lst")
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
            if self.sim_no_lst:
                if p_gen_lst.search(_):
                    _ = "## {}".format(_)
            new_do_lines.append(_)
        xTools.write_file(do_file, new_do_lines)
        utils.update_simulation_do_file(self.sim_vendor_name, do_file, self.lst_precision, self.sim_no_lst)

        # sometimes the simulation libraries are not complete for temporary device, so try to find an exist one
        unique_one = self.get_lib_path_if_only_has_one(self.dev_lib)
        if unique_one:
            self.dev_lib = unique_one
            need_remove_ovi = 0

        args = "%s %s %s cmd %s %s" % (do_file, self.dev_lib, self.pri_lib, self.diamond, self.src_lib)
        rerun_sim_cmd = None
        if self.run_modelsim:
            self.copy_modelsim_ini_file()
            sim_cmd = '%s/vsim -l sim_log.txt -c -do "do %s"' % (self.sim_vendor_bin, args)
        elif self.run_questasim:
            rerun_sim_cmd = '%s/vsim -l sim_log.txt -c -do "do %s"' % (self.sim_vendor_bin, args)
            if need_remove_ovi:
                x = re.sub("ovi_", "", self.dev_lib)
            else:
                x = self.dev_lib
            local_lib = os.path.abspath("../%s" % os.path.basename(x))
            if not os.path.isdir(local_lib):
                shutil.copytree(x, local_lib)
            new_args = "%s %s %s cmd %s %s" % (do_file, local_lib, self.pri_lib, self.diamond, self.src_lib)
            sim_cmd = '%s/vsim -l sim_log.txt -c -do "do %s"' % (self.sim_vendor_bin, new_args)
            if local_lib not in self.local_lib:
                self.local_lib.append(local_lib)
        else:
            sim_cmd = "%s/vsimsa -l sim_log.txt -do %s" % (self.sim_vendor_bin, args)
        sim_cmd = xTools.win2unix(sim_cmd, 0)
        if need_remove_ovi:
            sim_cmd = re.sub("ovi_", "", sim_cmd)
            if rerun_sim_cmd:
                rerun_sim_cmd = re.sub("ovi_", "", rerun_sim_cmd)
        # /*
        #  * If license not found, will launch again in 10 times.
        #  */
        log_file = "run_%s.log" % sim_path
        time_file = "run_%s.time" % sim_path
        sts = 0

        def _func():
            if rerun_sim_cmd:
                xTools.append_file(time_file, ["REM For debugging only", "REM %s" % rerun_sim_cmd], append=True)
            more_cmd = "TRIAL_AND_ERROR_" if os.getenv("trial_and_error") else ""
            return xTools.run_command(more_cmd + sim_cmd, log_file, time_file)

        yose_timeout = os.getenv("YOSE_TIMEOUT")
        if yose_timeout:
            yose_timeout = int(yose_timeout)
        else:
            yose_timeout = 0
        for i in range(10):
            if xTools.remove_dir_without_error(log_file):
                _recov.comeback()
                return 1
            if yose_timeout:
                results = yTimeout.run_func_with_timeout(_func, yose_timeout)
                sts = results[0]
            else:
                sts = _func()
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

    @staticmethod
    def get_lib_path_if_only_has_one(now_dev_lib):
        """
        sometimes the simulation libraries are not complete for temporary device, so try to find an unique exist one
        """
        _root, _path = os.path.split(now_dev_lib)
        _clean_path = re.sub("ovi_", "", _path)
        one = os.path.join(_root, _clean_path)
        two = os.path.join(_root, f"ovi_{_clean_path}")
        one_is, two_is = os.path.isdir(one), os.path.isdir(two)
        if one_is and two_is:
            return
        if one_is:
            return one
        if two_is:
            return two

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
            ori_sim_path = os.path.join(self.src_design, "test" + "design", "sim")
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
                if re.search(r"\.\.\.", item):
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
                got_sim_only = False
                self.normal_tb = 1
                ipx_tb = ""
                raw_source_list = self.final_ldf_dict.get("source")
                for item in raw_source_list:
                    _n_a_m_e = xTools.get_abs_path(item.get("name"), "..")  # # cwd is _scratch\sim_xxx
                    if item.get("excluded") == "TRUE":
                        continue
                    elif item.get("syn_sim") == "SimOnly":
                        _tb_file.append(_n_a_m_e)
                        got_sim_only = True
                    elif item.get("type_short") == "IPX":
                        ipx_tb = utils.prepare_ipx_testbench_files(os.path.abspath(_n_a_m_e), os.getcwd())
                if ipx_tb and not got_sim_only:  # SinOnly File has higher priority
                    _tb_file.append(ipx_tb)
                if not _tb_file:
                    xTools.say_it("Warning. Not found any testbench file")
        if not _tb_file:
            xTools.say_it("Warning. Not found any testbench file in the design configuration")
            # return 1
        if self.tb_vector:
            _tb_vector_files = xTools.to_abs_list(self.tb_vector, self.src_design)
            for item in _tb_vector_files:
                xTools.wrap_cp_file(item, os.path.join(sim_path, os.path.basename(item)))
        self.final_tb_files = _tb_file[:]

    def add_vlog_vcom_lines(self, src_files, add_tb=0):
        p_for_pmi = re.compile(r"\Wip\Wpmi\Wpmi")
        self.use_vhd = 0
        if add_tb and not self.normal_tb:  # use them directly.
            v_v_lines = src_files[:]
        else:
            v_v_lines = list()
            for item in src_files:
                fext = xTools.get_fext_lower(item)
                item = xTools.win2unix(item, 0)
                if not os.path.isfile(item):
                    xTools.say_it("Warning. Not found file {}".format(item))
                    continue
                if fext in (".v", ".vo", ".sv", ".vm"):
                    if p_for_pmi.search(item):
                        v_v_lines.append("vlog %s +incdir+%s" % (item, os.path.dirname(item)))
                    else:
                        x = " "
                        if fext == ".sv":
                            if self.sim_vendor_name == "Active":
                                x = "-sv2k12 "
                            if self.sim_vendor_name in ("Active", "Modelsim"):
                                if add_tb and (os.path.basename(os.getcwd()) != "sim_rtl"):
                                    if xTools.simple_parser(item, [re.compile(r"ifdef\s+SV_IO_UNFOLD")]):
                                        x = "+define+SV_IO_UNFOLD " + x
                        this_line = "vlog %s %s" % (x, item)
                        if fext == ".v":
                            this_line += ' +incdir+{}'.format(os.path.dirname(item))
                        v_v_lines.append(this_line)
                elif fext in (".vho", ".vhd", ".vhdl", ".vhm"):
                    v_v_lines.append("vcom %s" % item)
                    if not self.use_vhd:
                        self.use_vhd = 1
                elif fext == ".lpf":
                    continue
                else:
                    xTools.say_it("-Warning. Unknown file: %s" % item)
                    continue
        return v_v_lines

    def create_lock_file_folder(self):
        diamond_version = xLattice.get_diamond_version()
        if os.getenv("YOSE_RADIANT"):
            _t = "Radiant"
        else:
            _t = "Diamond"
        ver_name = _t + "".join(diamond_version)
        x = simLibrary.get_sim_tool_version(self.sim_vendor_bin)
        if x:
            x_sim_vendor_name = "{}_{}".format(x[0], x[1])
        else:
            if self.run_xrun:
                sts, text = xTools.get_status_output("xrun -helpargs")
                p = re.compile("xrun:\s+([^:]+):.+Cadence")  # xrun: 20.09-s004: (c) Copyright 1995-2020 Cadence Design Systems, Inc.
                for line in text:
                    m = p.search(line)
                    if m:
                        x_sim_vendor_name = "xrun_{}".format(m.group(1))
                        break
                else:
                    x_sim_vendor_name = "xrun"
            else:
                x_sim_vendor_name = self.sim_vendor_name
        #
        real_path = os.path.join(self.flow_options.get("conf"), x_sim_vendor_name, ver_name)
        self.lock_file_folder = xTools.win2unix(real_path)
        xTools.wrap_md(self.lock_file_folder, "folder_for_putting_lock_file")

    def build_this_dev_lib(self, _conf, map_lib_name, family_name):
        self.original_library_path = self.flow_options.get("library_path")
        self.ori_library_precompiled = self.flow_options.get("library_precompiled")
        if self.ori_library_precompiled:
            self.ori_library_precompiled = self.ori_library_precompiled.lower()
        if self.run_xrun:
            self.ori_library_precompiled = "no"

        _name = "ovi_{}".format(map_lib_name)
        if self.original_library_path:
            if self.run_activehdl:
                self.dev_lib = os.path.join(self.original_library_path, _name, _name + ".lib")
                self.pmi_lib = os.path.join(self.original_library_path, "pmi", "pmi.lib")
            else:
                # /public/tmp_work_space/DEV/conf/Riviera_2016.06.92.6242/Radiant2.10110/ovi_iCE40UP
                # /public/tmp_work_space/DEV/conf/Questa_10.4g/Radiant2.3t200
                #
                self.dev_lib = os.path.join(self.original_library_path, _name)
                self.pmi_lib = os.path.join(self.original_library_path, "pmi_work")
            return   # use it!
        self.create_lock_file_folder()

        def try_to_compile_local_lib():
            _lock_file = os.path.join(self.lock_file_folder, "compile_{}_library.lock".format(map_lib_name))
            filelock.safe_run_function(self.create_dev_lib, args=(map_lib_name, self.lock_file_folder),
                                       func_lock_file=_lock_file,
                                       timeout=3600)

            _lock_file = os.path.join(self.lock_file_folder, "compile_pmi_library.lock")
            filelock.safe_run_function(self.create_pmi_lib, args=(self.lock_file_folder,),
                                       func_lock_file=_lock_file,
                                       timeout=3600)

        ###########
        closest_path = os.getenv("CLOSEST_SIM_LIB", "NO_CLOSEST_SIM_LIB")
        if self.run_activehdl:
            perhaps_dev_lib = os.path.join(closest_path, "..", "Vlib", _name, _name + ".lib")
        elif self.run_modelsim:
            perhaps_dev_lib = os.path.join(os.path.dirname(closest_path), "lib", _name)
        else:
            perhaps_dev_lib = os.path.join(closest_path, "..", "Vlib", _name)
        perhaps_dev_lib = xTools.win2unix(perhaps_dev_lib, use_abs=False)
        ###########
        perhaps_pmi_lib = re.sub(_name, "pmi_work", perhaps_dev_lib)
        perhaps_pmi_lib = re.sub("ovi_", "", perhaps_pmi_lib)

        if self.ori_library_precompiled == "yes":
            self.dev_lib = perhaps_dev_lib
            self.pmi_lib = perhaps_pmi_lib
        elif self.ori_library_precompiled == "no":
            try_to_compile_local_lib()
        elif self.ori_library_precompiled == "auto" or not self.ori_library_precompiled:
            if self.run_modelsim or self.run_activehdl:
                self.dev_lib = perhaps_dev_lib
                self.pmi_lib = perhaps_pmi_lib
                self.ori_library_precompiled = "yes"
            else:
                self.ori_library_precompiled = "no"
                try_to_compile_local_lib()
        else:
            xTools.say_it("Error. Unknown library-precompiled value: {}".format(self.ori_library_precompiled))
            return 1
        if not os.path.exists(self.dev_lib):
            xTools.say_it("Error. Not found simulation library: {}".format(self.dev_lib))
            return 1
        if not os.path.exists(self.pmi_lib):
            xTools.say_it("Warning. Not found simulation library: {}".format(self.pmi_lib))
            return 0

    def copy_modelsim_ini_file(self):
        """vmap will modify modelsim.ini file, it will be failed to read this file when using many threads simulation.
        and the vmap uses local modelsim.ini file firstly, so copy to local path
        """
        source_file = os.path.join(self.sim_vendor_bin, "..", "modelsim.ini")
        if os.path.isfile(source_file):
            source_file = os.path.abspath(source_file)
            xTools.say_it("Try to copy file to local: {}".format(source_file))
            xTools.wrap_cp_file(source_file, "./modelsim.ini", force=True)
        if self.ori_library_precompiled == "no":
            remove_device_links("modelsim.ini")


def remove_device_links(m_ini):
    original_lines = open(m_ini).readlines()
    p1 = re.compile(r"ovi_(S+)\s+=")
    device_list = list()
    for foo in original_lines:
        m1 = p1.search(foo)
        if m1:
            device_list.append(m1.group(1))
            device_list.append("ovi_" + m1.group(1))
    p2 = re.compile(r"(\S+)\s+=")
    with open(m_ini, "w") as wob:
        for line in original_lines:
            line = line.rstrip()
            m2 = p2.search(line)
            if m2:
                key = m2.group(1)
                if key in device_list:
                    continue
            print(line, file=wob)


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
