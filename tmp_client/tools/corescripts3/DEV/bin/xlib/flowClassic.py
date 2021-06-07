import os
import re
import sys
import time

from .xBasic import BasicClassic
from . import xClassic
from .xReport import ScanClassicRpt
from . import yTools

check_lib = os.path.join(os.path.dirname(__file__),'..','..','tools','check')
check_lib = os.path.abspath(check_lib)
sys.path.insert(0, check_lib)
import check

__author__ = 'syan'


def update_lct_file_if_necessary(lct_file, goal):
    if goal == "Area":
        setting = "Nodes_collapsing_mode = Area;"
    else:
        setting = "Nodes_collapsing_mode = Fmax;"
    lct_file_lines = yTools.get_original_lines(lct_file)
    new_lct_lines = list()
    p_start = re.compile("\[Global Constraints\]")
    p_setting = re.compile("Nodes_collapsing_mode")
    start = 0
    for line in lct_file_lines:
        line = line.strip()
        if not start:
            if p_start.search(line):
                start = 1
                new_lct_lines.append(line)
                continue
        elif start==1:
            if re.search("\[", line):
                new_lct_lines.append(setting)
                start = 2
        if start == 2 or not start:
            new_lct_lines.append(line)
        else:
            if p_setting.search(line):
                continue
            else:
                new_lct_lines.append(line)
    yTools.write_file(lct_file,new_lct_lines)


class FlowClassic(BasicClassic):
    def __init__(self, private_options):
        BasicClassic.__init__(self, private_options)
        self.default_devkit = "LC4256ZE-5TN144C"
        self.kwargs = dict()

    def run_scan_only(self):
        _recov = yTools.ChangeDir(self.job_design)
        rpt_file, lco_file = "", ""
        for foo in os.listdir("."):
            fext = yTools.get_fext_lower(foo)
            if fext == ".rpt":
                rpt_file = foo
            elif fext == ".lco":
                lco_file = foo

        report_csv_file = os.path.abspath(os.path.join(self.job_design, "..", "..", "report.csv"))
        t = ScanClassicRpt()
        t.reset()
        if not os.path.isfile(report_csv_file):
            yTools.write_file(report_csv_file, ",".join(["design"] + t.get_title() + ["fmax"]))
        t.scan_report(rpt_file)
        if os.path.isfile(lco_file):
            lco_file_bak = lco_file + ".bak"
            bak_ob = open(lco_file_bak, "w")
            for line in open(lco_file):
                if line.startswith("//"):
                    continue
                bak_ob.write(line)
            bak_ob.close()
            sts, lco_dict = yTools.get_conf_options(lco_file_bak, key_lower=False)
            os.remove(lco_file_bak)
            # [Timing Results]
            # Fmax = 57.64;
            # Logic_level = 4;
            timing_results = lco_dict.get("Timing Results", dict())
            fmax = timing_results.get("Fmax", "NA")
            if fmax:
                fmax = re.sub(";", "", fmax)
        else:
            fmax = "NO_LCO_FILE"

        data = [os.path.basename(self.src_design)] + t.get_data() + [fmax]
        yTools.append_file(report_csv_file, ",".join(data))
        _recov.comeback()

    def pre_process(self):
        sds_file = os.path.join(self.classic, "ispcpld", "config", "lc4k.sds")
        if yTools.not_exists(sds_file, "ispMACH 4000 sds file"):
            return 1
        sts, self.sds_dict = yTools.get_conf_options(sds_file)
        if sts:
            return 1
        self.classic = os.path.abspath(self.classic)
        os.environ["PATH"] = "%s;%s" % (os.path.join(self.classic, "ispcpld", "BIN"), os.getenv("PATH", ""))
        os.environ["MY_CLASSIC"] = self.classic

    def run_design(self):
        if self.get_original_kwargs():
            return 1
        if self.update_kwargs():
            return 1

        # ////////////////////
        self.design = self.kwargs.get("design", "no_design")
        self.kwargs["prj_dir"] = yTools.win2unix(self.job_design)
        self.topmodule = self.kwargs.get("topmodule", self.design)
        # ////////////////////
        if self.create_lct_file():
            return 1
        sts = self.launch_test_flow()
        self.run_scan_only()
        sts2 = self.run_check_only()
        if sts2:
            return 1
        return sts

    def run_check_only(self):
        import glob
        conf_file = glob.glob("*.conf")
        if not conf_file:
            return
        self.qas = ""
        report_path = self.run_options.get("cwd")
        report = "check_flow.csv"
        _job_dir, _design = os.path.split(os.path.dirname(self.job_design))
        ta_check = check.TA(_job_dir, _design, report_path, report,
                            self.qas, self.tag, rerun_path=report_path,
                            conf_file=self.run_options.get("check_conf"))
        sts, text = ta_check.process()
        yTools.say_it(text)        
        return sts

    def get_original_kwargs(self):
        self.has_syn_file = ""
        qas_file = os.path.join(self.src_design, "_qas.info")
        syn_files = yTools.find_by_fext(self.src_design, ".syn")
        if not syn_files:
            fit_dir = os.path.join(self.src_design, "fit")
            if os.path.isdir(fit_dir):
                syn_files = yTools.find_by_fext(fit_dir, ".syn")
        len_syn = len(syn_files)
        if os.path.isfile(qas_file):
            return self.start_from_qas(qas_file)
        elif len_syn == 1:
            self.has_syn_file = syn_files[0]
            return self.start_from_syn(syn_files[0])
        else:
            yTools.say_it("Error. Found %d Classic Project file in %s" % (len_syn, self.src_design))
            return 1

    def start_from_qas(self, qas_file):
        if not self.devkit:
            yTools.say_it("Message: use default devkit: %s" % self.default_devkit)
            self.devkit = self.default_devkit
        self.kwargs["devkit"] = self.devkit
        self.kwargs.update(xClassic.qas_kwargs(qas_file))
        yTools.say_it(self.kwargs, "original kwargs from qas info file:", self.debug)

    def start_from_syn(self, syn_file):
        my_parser = xClassic.ProjectKwargs(syn_file, self.devkit)
        my_parser.process()
        self.kwargs = my_parser.get_prj_kwargs()

        self.kwargs["lct_file"] = yTools.get_fname(syn_file) + ".lct"
        yTools.say_it(self.kwargs, "original kwargs from syn file:", self.debug)

    def update_kwargs(self):
        self.kwargs["date"] = time.strftime('%X')
        self.kwargs["time"] = time.strftime('%x')
        self.kwargs["synthesis_tool"] = self.synthesis
        if self.goal == "Area":
            self.kwargs["frequency"] = "1"
            self.kwargs["global"] = "Nodes_collapsing_mode = Area;"
        else:
            self.kwargs["frequency"] = "200"
            self.kwargs["global"] = ""

        if self.check_module():
            return 1
        if self.check_devkit():
            return 1
        yTools.say_it(self.kwargs, "kwargs for classic command", self.debug)

    def check_module(self):
        module = self.kwargs.get("module")
        if not module:
            yTools.say_it("Error. No source file specified")
            return 1
        final_module = list()
        _base_dir = self.src_design
        if self.has_syn_file:
            _base_dir = os.path.dirname(self.has_syn_file)
        for item in module:
            new_item = yTools.get_relative_path(item, _base_dir)
            fext = yTools.get_fext_lower(item)
            if fext == ".lpf":
                continue
            if re.search("_tb\.", item):
                self.kwargs["stimulus"] = [new_item]
                continue
            final_module.append(new_item)
        self.kwargs["module"] = final_module

        final_fext = [yTools.get_fext_lower(item) for item in final_module]
        set_final_fext = set(final_fext)
        final_fext_list = list(set_final_fext)
        # Design Entry Type=ABEL/Schematic, Schematic/VHDL, Schematic/Verilog HDL, EDIF, Pure Verilog HDL, Pure VHDL
        if ".abl" in final_fext_list:
            entry_type = "ABEL/Schematic"
        elif ".sch" in final_fext_list:
            if ".vhd" in final_fext_list:
                entry_type = "Schematic/VHDL"
            elif ".v" in final_fext_list:
                entry_type = "Schematic/Verilog HDL"
            else:
                entry_type = "ABEL/Schematic"
        elif ".vhd" in final_fext_list:
            entry_type = "Pure VHDL"
        elif ".v" in final_fext_list:
            entry_type = "Pure Verilog HDL"
        else:
            entry_type = "EDIF"
        self.kwargs["source_format"] = self.entry_type = entry_type
        self.kwargs["sds_source_format"] = re.sub("\s+", "_", entry_type)

    def check_devkit(self):
        """
        devkit comes from old ispLEVER project file
        but the same devkit should be PartNumber in the lct file, otherwise the
        """
        _devkit = self.kwargs.get("devkit")
        if not _devkit:
            yTools.say_it("Error. Not found devkit for Classic case")
            return 1
        section_ds = self.sds_dict.get("Device Support")
        section_gd = self.sds_dict.get("Generic Devices")
        #section_ot = self.sds_dict.get("Operating Temperature")
        section_dev_sts = self.sds_dict.get("Device Status")
        # LC4032B-10T44I=m4s_32_30,LC4032B,-10,44TQFP,IND,LSI4K-H32/30,lc4k32b,lc4k,P
        # Format=DevFile,Device,Speed,Package,Condition,Info,VCIfile,DevKit,Status
        devkit_lower = _devkit.lower()
        devkit_lower = re.sub("ces$", "c", devkit_lower)
        value = section_gd.get(devkit_lower)
        value_title = section_ds.get("format")
        self.kwargs["pkgname"] = section_ds.get("pkgname")
        self.kwargs["devtargetlse"] = section_ds.get("devtargetlse")
        self.kwargs["diename"] = section_ds.get("diename")
        self.section_ds = section_ds
        value_title = value_title.lower()  # LOWER
        if not value:
            yTools.say_it("Error. Unknown Classic device: %s" % _devkit)
            return 1

        value_list = re.split("\s*,\s*", value.strip())
        title_list = re.split("\s*,\s*", value_title.strip())
        prefix = "sds_"
        for i, item in enumerate(title_list):
            key = prefix + item
            value_item = value_list[i]
            if item == "status":
                self.kwargs[key] = section_dev_sts.get(value_item.lower())
            else:
                self.kwargs[key] = value_item

    def create_lct_file(self):
        lct_file = self.kwargs.get("lct_file")
        lct_template = os.path.join(self.conf, "classic", "lct.template")
        if yTools.not_exists(lct_template, "LCT Template File"):
            return 1
        dst_lct_file = self.design + ".lct"
        if self.devkit:
            yTools.generate_file(dst_lct_file, lct_template, self.kwargs)
        else:
            src_lct_file = yTools.get_relative_path(lct_file, self.src_design)
            if not os.path.isfile(src_lct_file):
                src_lci_file = os.path.splitext(src_lct_file)[0] + ".lci"
                if os.path.isfile(src_lci_file):
                    src_lct_file = src_lci_file
                else:
                    for foo in os.listdir(self.src_design):
                        fext = os.path.splitext(foo.lower())[1]
                        if fext in (".lci", ".lct"):
                            src_lct_file = os.path.join(self.src_design, foo)
                            break
                    else:
                        yTools.say_it("Error. not found any lct file")
                        return 1

            if yTools.wrap_cp_file(src_lct_file, dst_lct_file):
                return 1
            update_lct_file_if_necessary(dst_lct_file, self.goal)
        if yTools.wrap_cp_file(dst_lct_file, self.design+".lci"):
            return 1

    def launch_test_flow(self):
        self.kwargs["install_dir"] = yTools.win2unix(self.classic)
        self.kwargs["cpld_bin"] = yTools.win2unix(os.path.join(self.classic, "ispcpld", "BIN"))

        command_ini_file = "command.ini"
        if not os.path.isfile(command_ini_file):
            command_ini_file = os.path.join(self.conf, "classic", command_ini_file)
        if yTools.not_exists(command_ini_file, "Command Initial File"):
            return 1
        sts, self.cmd_dict = yTools.get_conf_options(command_ini_file)
        if sts:
            return 1
        self.main_cmd_dict = self.cmd_dict.get("command")

        if self.launch_pre_command_flow():
            return 1
        if self.sim_func or self.sim_time:
            self.create_sim_kwargs()
            if self.sim_func:
                if self.run_functional_simulation():
                    return 1
            if self.sim_time:
                if self.launch_main_flow():
                    return 1
                if self.run_timing_simulation():
                    return 1
        else:
            if self.launch_main_flow():
                return 1


    def launch_pre_command_flow(self):
        pre_kwargs = dict(install_dir = self.kwargs.get("install_dir"),
            cpld_bin = self.kwargs.get("cpld_bin"),
            design = self.kwargs.get("design"),
            topmodule = self.kwargs.get("topmodule")
        )
        pre_cmd_dict = self.cmd_dict.get("pre_command")
        pre_log, pre_time = "pre_command.log", "pre_command.time"
        if not pre_cmd_dict:
            yTools.say_it("Error. Not any [pre_command] section in the command initial file")
            return 1
        # ------------------
        template_dict = dict()
        template_dict[".v"] = "vlog2jhd"
        template_dict[".vhd"] = "vhd2jhd"
        template_dict[".sch"] = "sch2jhd"
        template_dict[".ed*"] = "edif2blf"
        template_dict[".abl"] = "ahdl2blf"

        for src in self.kwargs.get("module"):
            if yTools.not_exists(src, "source file"):
                return 1

            fext = yTools.get_fext_lower(src)
            fname = yTools.get_fname(src)
            pre_kwargs["src"] = src
            pre_kwargs["fname"] = fname
            if fext.startswith(".ed"):
                fext == ".ed*"
            cmd_template = pre_cmd_dict.get(template_dict.get(fext, ""))
            if not cmd_template:
                continue
            sts, cmd = yTools.get_cmd(cmd_template, pre_kwargs)
            if sts:
                return 1
            if yTools.run_command(cmd, pre_log, pre_time):
                return 1

    def launch_main_flow(self):
        self.c_log_file, self.c_time_file = "classic_flow.log", "classic_flow.time"
        self.create_kwargs_for_syn()
        if self.entry_type == "Pure VHDL":
            self.run_synthesis_flow_vhd()
        elif self.entry_type == "Pure Verilog HDL":
            self.run_synthesis_flow_v()

        self.run_command_group()

    def run_command_group(self):
        self.create_rs1_rs2_file()

        cmd_group = self.main_cmd_dict.get("cmd_group")

        for item in cmd_group:
            item = item.strip()
            sts, cmd = yTools.get_cmd(item, self.kwargs)
            if sts:
                return 1
            if yTools.run_command(cmd, self.c_log_file, self.c_time_file):
                return 1

    def create_kwargs_for_syn(self):
        t_kwargs = dict()
        t_kwargs["topmodule"] = self.topmodule
        t_kwargs["prj_dir"] = self.kwargs.get("prj_dir")
        t_kwargs["devtargetlse"] = self.kwargs.get("devtargetlse")
        t_kwargs["device"] = self.section_ds.get("device")
        vhd_files = " ".join(self.kwargs.get("module"))
        t_kwargs["vhd_files"] = vhd_files
        t_kwargs["install_dir"] = self.kwargs.get("install_dir")
        v_files = self.kwargs.get("module")
        t_kwargs["v_files"] = " ".join(v_files)
        h_files = self.design + ".h"
        yTools.write_file(h_files, "")
        t_kwargs["h_files"] = h_files
        t_kwargs["lse_goal"] = self.goal
        self.kwargs["env_file"] = self.topmodule + "_lse.env"
        self.syn_kwargs = t_kwargs
        if self.goal == "Area":
            self.syn_kwargs["frequency"] = "1"
            self.syn_kwargs["global"] = "Nodes_collapsing_mode = Area;"
        else:
            self.syn_kwargs["frequency"] = "200"
            self.syn_kwargs["global"] = ""


    def create_rs1_rs2_file(self):
        line = "-i %(design)s.bl5 -lci %(design)s.lct -d %(sds_devfile)s -lco %(design)s.lco -html_rpt -fti "
        line += "%(design)s.fti -fmt PLA -tto %(design)s.tt4 -eqn %(design)s.eq3 -tmv NoInput.tmv -rpt_num 1"
        sts, line_str = yTools.get_cmd(line, self.kwargs)
        if sts:
            return 1
        rs1_line = "%s -nojed" % line_str
        rs2_line = line_str
        yTools.write_file(self.kwargs.get("design") + ".rs1", rs1_line)
        yTools.write_file(self.kwargs.get("design") + ".rs2", rs2_line)

    def run_synthesis_flow_vhd(self):
        if self.synthesis == "synplify":
            return self.run_vhd_synplify()
        elif self.synthesis == "lse":
            return self.run_vhd_lse()

    def run_vhd_synplify(self):
        classic_cmd_file = self.topmodule + ".cmd"
        sts, synplify_vhd_template = xClassic.get_template_file(self.conf, "synplify_vhd.template")
        if sts:
            return 1
        yTools.generate_file(classic_cmd_file, synplify_vhd_template, self.syn_kwargs)
        cmd_list = ("synpwrap", "edif2blf")
        if self.run_command_list(cmd_list):
            return 1

    def run_vhd_lse(self):
        env_file = self.topmodule + "_lse.env"
        synproj_file = self.topmodule + ".synproj"
        xClassic.create_lse_env_file(env_file)
        sts, lse_v_template = xClassic.get_template_file(self.conf, "lse_vhd.template")
        if sts:
            return 1
        yTools.generate_file(synproj_file, lse_v_template, self.syn_kwargs)
        cmd_list = ("syndos", "edif2blf")
        if self.run_command_list(cmd_list):
            return 1

    def run_synthesis_flow_v(self):
        if self.synthesis == "synplify":
            return self.run_v_synplify()
        elif self.synthesis == "lse":
            return self.run_v_lse()

    def run_v_lse(self, ):
        env_file = self.topmodule + "_lse.env"
        synproj_file = self.topmodule + ".synproj"
        xClassic.create_lse_env_file(env_file)
        sts, lse_v_template = xClassic.get_template_file(self.conf, "lse_v.template")
        if sts:
            return 1

        yTools.generate_file(synproj_file, lse_v_template, self.syn_kwargs)
        cmd_list = ("syndos", "edif2blf")
        if self.run_command_list(cmd_list):
            return 1

    def run_v_synplify(self):
        classic_cmd_file = self.topmodule + ".cmd"
        sts, synplify_v_template = xClassic.get_template_file(self.conf, "synplify_v.template")
        if sts:
            return 1
        yTools.generate_file(classic_cmd_file, synplify_v_template, self.syn_kwargs)

        cmd_list = ("synpwrap_v", "edif2blf")
        if self.run_command_list(cmd_list):
            return 1

    def run_command_list(self, cmd_list):
        for item in cmd_list:
            sts, cmd = yTools.get_cmd(self.main_cmd_dict.get(item), self.kwargs)
            if sts:
                return 1
            if yTools.run_command(cmd, self.c_log_file, self.c_time_file):
                return 1

    def run_functional_simulation(self):
       self._run_simulation("sim_functional", self.kwargs.get("module"), "")


    def run_timing_simulation(self):
        rsp_file =self.design + ".rsp"
        xClassic.create_rsp_file(rsp_file, self.kwargs)
        if self.run_command_list(["sdf"]):
            return 1
        if self.entry_type == "Pure Verilog HDL":
            source_files = [self.design + ".vo"]
        else:
            source_files = [ self.design + ".vho"]
        self._run_simulation("sim_timing", source_files, "")

    def create_sim_kwargs(self):
        #yTools.say_it(self.kwargs)
        self.sim_kwargs = dict()
        self.sim_kwargs["sim_time"] = "10 us"
        self.sim_kwargs["uut_name"] = self.kwargs.get("uut_name")
        self.sim_kwargs["src_top_module"] = self.kwargs.get("topmodule")
        self.sim_kwargs["resolution"] = ""
        self.sim_kwargs["sim_top"] = "testbench"
        self.sim_kwargs["lib_name"] = "ovi_lc4k"
        self.p_src_start = re.compile("source_start")
        self.p_src_end = re.compile("source_end")
        self.p_tb_start = re.compile("tb_start")
        self.p_tb_end = re.compile("tb_end")
        self.do_template = os.path.join(self.conf, "sim", "ahdl_do.template")
        self.tb_file = self.kwargs["tb_file_is"]

    def _run_simulation(self, sim_path, source_files, user_options):
        if yTools.wrap_md(sim_path, "Simulation Path"):
            return 1
        if self.copy_tb_files(sim_path):
            return 1

        _recov = yTools.ChangeDir(sim_path)
        do_lines = list()
        start_source = start_tb = 0
        for line in open(self.do_template):
            line = line.rstrip()
            if re.search("%", line):
                line = line % self.sim_kwargs
                do_lines.append(line)
                continue
            if start_source:
                if self.p_src_end.search(line):
                    if not user_options: # RTL simulation
                        source_files = [yTools.get_relative_path(item, self.job_design) for item in source_files]
                    v_v_line = self.add_vlog_vcom_lines(source_files)
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
                    v_v_line = self.add_vlog_vcom_lines(self.final_tb_files)
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

        if self.use_vhd:
            new_do_lines = [re.sub("ovi_", "", item) for item in do_lines]
        else:
            new_do_lines = do_lines[:]

        yTools.write_file(do_file, new_do_lines)
        tt = "ovi_%s" % self.kwargs.get("diename")

        self.dev_lib = os.path.join(self.classic, "active-hdl", "Vlib", tt, tt+".LIB")
        self.pri_lib = "work"
        sim_cmd = "vsimsa.bat -l sim_log.txt -do %s %s %s cmd" % (do_file, self.dev_lib, self.pri_lib)
        sim_cmd = yTools.win2unix(sim_cmd, 0)
        if self.use_vhd:
            sim_cmd = re.sub("ovi_", "", sim_cmd)
        sts = yTools.run_command(sim_cmd, "run_%s.log" % sim_path, "run_%s.time" % sim_path)
        _recov.comeback()
        return sts

    def add_vlog_vcom_lines(self, src_files):
        self.use_vhd = 0
        v_v_lines = list()
        for item in src_files:
            fext = yTools.get_fext_lower(item)
            item = yTools.win2unix(item, 0)
            if fext in (".v", ".vo", ".sv"):
                v_v_lines.append("vlog %s" % item)
            elif fext in (".vho", ".vhd", ".vhdl"):
                v_v_lines.append("vcom %s" % item)
                if  not self.use_vhd:
                    self.use_vhd = 1
            elif fext == ".lpf":
                continue
            else:
                yTools.say_it("-Warning. Unknown file: %s" % item)
                continue
        return v_v_lines

    def copy_tb_files(self, sim_path):
        if self.tb_file:
            _tb_file = yTools.to_abs_list(self.tb_file, self.src_design)
        else:
            raw_tb_file = yTools.get_content_in_start_end(self.do_template, re.compile("tb_start"), re.compile("tb_end"))
            if not raw_tb_file:
                yTools.say_it("Error. Not found raw tb files in %s" % self.do_template)
                return 1
            _tb_file = list()
            for item in raw_tb_file:
                item_list = re.split("\s+", item)
                pre_com = item_list[0].lower()
                if pre_com in ("vlog", "vcom"):
                    _tb_file.append(item_list[-1])
            if not _tb_file:
                yTools.say_it("-Error. Not found tb files in %s" % self.do_template)
                return 1
            _tb_file = yTools.to_abs_list(_tb_file, os.path.dirname(self.do_template))
        self.final_tb_files = list()
        for item in _tb_file:
            base_item = os.path.basename(item)
            yTools.wrap_cp_file(item, os.path.join(sim_path, base_item))
            self.final_tb_files.append(base_item)