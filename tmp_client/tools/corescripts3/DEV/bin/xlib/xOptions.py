import os
import re
import sys
import glob
import copy
import random
import argparse

from . import xTools

__author__ = 'syan'


class XOptions:
    def __init__(self, private_options):
        self.scripts_options = private_options
        self.is_ng_flow = private_options.get("is_ng_flow")
        self.scripts_options["cwd"] = os.getcwd()
        self.run_vendor = private_options.get("run_vendor", "lattice")

        self.section_qa = "qa"
        self.section_command = "command"

    def run_option_parser(self):
        self.run_cmd_line_parser()

        if self.merge_ex_env():
            return 1

        if self.merge_file_options():
            return 1

        if self.merge_conf_options():
            return 1

        if self.flatten_options_1st():
            return 1

    def merge_file_options(self):
        user_file = self.scripts_options.get("file")
        if not user_file:
            return
        elif user_file:
            if xTools.not_exists(user_file, "User Configuration File"):
                return 1
        sts, file_options = xTools.get_conf_options(user_file)
        if sts:
            return 1
        self._merge_options(file_options)
        xTools.say_it(self.scripts_options, "Merge User Configuration Options", self.debug)

    def merge_conf_options(self):
        '''
        get the conf file setting, and merge them with command options
        '''
        _conf = self.scripts_options.get("conf")
        if not _conf:
            _conf = os.path.join(os.path.dirname(sys.argv[0]), "..", "conf")
        if os.path.isdir(_conf):
            pass
        else:
            if xTools.not_exists(_conf, "Default Configuration Path"):
                return 1
        _conf = os.path.abspath(_conf)

        self.scripts_options["conf"] = _conf

        conf_files = glob.glob(os.path.join(_conf, "*.ini"))
        if not conf_files:
            xTools.say_it("-Error. Not found any ini file under %s" % _conf)
            return 1
        sts, conf_options = xTools.get_conf_options(conf_files)
        if sts:
            return 1
        self._merge_options(conf_options)
        xTools.say_it(self.scripts_options, "Merge User/Default Configuration Options", self.debug)

    def _merge_options(self, new_options):
        for section, options in list(new_options.items()):
            if section not in ("qa", "environment", "command", "cmd_flow", "sim"):
                pass
                # xTools.say_it("-Warning. Found unknown section name: %s" % section)
            if section == self.section_qa:
                xTools.dict_none_to_new(self.scripts_options, options)
            elif section == self.section_command:
                old_cmd = self.scripts_options.get(self.section_command, dict())
                new_cmd = copy.copy(options)
                xTools.dict_none_to_new(new_cmd, old_cmd)
                self.scripts_options[self.section_command] = new_cmd
            else:
                old_cmd = self.scripts_options.get(section, dict())
                xTools.dict_none_to_new(old_cmd, options)
                self.scripts_options[section] = old_cmd

    def run_cmd_line_parser(self):
        self.parser = argparse.ArgumentParser()
        self.add_public_options()
        if self.run_vendor == "lattice":
            self.add_lattice_options()
        opts = self.parser.parse_args()
        self.original_options = opts.__dict__
        xTools.dict_none_to_new(self.scripts_options, self.original_options)
        self.debug = self.scripts_options.get("debug")
        xTools.say_it(self.scripts_options, "Command Options", self.debug)

    def add_public_options(self):
        _choice_scuba_type = ("vhdl", "verilog")
        pub_group = self.parser.add_argument_group("Public Options")
        pub_group.add_argument("-d", "--debug", action="store_true", help="print debug message")
        pub_group.add_argument("--copy-all", action="store_true", help="copy all files in ldf_dir to working directory")
        _hlp = "specify user's environment value (append action)"
        _hlp += ' example: --set-env=a=1 --set-env="b=2;9;x"'
        pub_group.add_argument("-E", "--set-env", action="append", help=_hlp)
        pub_group.add_argument("-D", "--dry-run", action="store_true",
                             help="Dry run the test flow, generate the Lattice Diamond File(.ldf) only")
        # - pub_group.add_argument("-q", "--quiet", action="store_true", help="print as little as possible")
        pub_group.add_argument("-R", "--scan-rpt", action="store_true", help="scan reports after flow done")
        pub_group.add_argument("--scan-pap-rpt", action="store_true", help="scan reports after flow done")

        pub_group.add_argument("-F", "--file", help="specify user configuration file, which format is" +
                                                  " same as the conf/default.ini file")
        pub_group.add_argument("--conf", help="specify the configuration path name.")
        pub_group.add_argument("--top-dir", help="specify the top source path name")
        pub_group.add_argument("--design", help="specify the design name")
        pub_group.add_argument("--info", help="specify info file name")
        pub_group.add_argument("--job-dir", help="specify the job working path name")
        pub_group.add_argument("-T", "--timeout", type=int, default=0, help="specify pnmainc timeout value")
        _hlp = "specify the job tag name, default is _scratch, which is created in the design job working path"
        pub_group.add_argument("--tag", default="_scratch", help=_hlp)
        pub_group.add_argument("--bak-tag", help="specify backup tag, will try to copy all files in $tag directory")
        pub_group.add_argument("--qas", action="store_true", help="will run qas test flow")
        pub_group.add_argument("--dsp", action="store_true", help="will run DSP test flow")
        pub_group.add_argument("--pmi", action="store_true", help="run PMI implementation and simulation flow")
        pub_group.add_argument("--scuba-type", choices=_choice_scuba_type,
            help="specify scuba test flow source type name")
        pub_group.add_argument("--scuba-only", action="store_true", help="run scuba flow only for IPExpress cases")
        pub_group.add_argument("--check-rpt", help="specify the check report file")
        pub_group.add_argument("--check-only", action="store_true", help="check results only")
        pub_group.add_argument("--no-check", action="store_true", help="do not check results, always passed")
        pub_group.add_argument("--scan-only", action="store_true", help="scan and check results only")
        pub_group.add_argument("--check-conf", help="specify the check conf FILE NAME")
        pub_group.add_argument("--pre-process", help="run pre-process for a case")
        pub_group.add_argument("--post-process", help="run post-process for a case")
        pub_group.add_argument("--loose-match", action="store_true", help="match the Diamond install path loosely")
        pub_group.add_argument("--change-names", action="store_true", help="Change module/port name in HDL files")
        self.valid_check_items = ("gbb", "impl", "sim", "cov")
        pub_group.add_argument("--check-sections", choices=self.valid_check_items, nargs="+",
                               help="specify sections")
        pub_group.add_argument("--check-smart", action="store_true", help="check results smartly")
        pub_group.add_argument("--check-logic-timing-not", action="store_true", help="DO NOT check logic timing")
        pub_group.add_argument("--toe", action="store_true", help="trial and error")

        # self.parser.add_argument_group(pub_group)

    def add_lattice_options(self):
        self.add_diamond_options()
        self.add_project_options()
        self.add_impl_options()
        self.add_simulation_options()

    def add_simulation_options(self):
        sim_group = self.parser.add_argument_group("Simulation Options")
        sim_group.add_argument("--modelsim-path", help="specify Modelsim install path")
        sim_group.add_argument("--questasim-path", help="specify Questasim install path")
        sim_group.add_argument("--riviera-path", help="specify Riviera install path")
        sim_group.add_argument("--activehdl-path", help="specify ActiveHDL install path")
        sim_group.add_argument("--simrel-path", help="specify Simrel install path")

        _h0 = "If no value for this option, will try to compile/search the library with given simulation tool"
        _h1 = "Valid when 'library-path' is empty." \
              "1. yes: use precompiled simulation library, block flow if not found the library(questasim/riviera)" \
              "2. no: compile library with simulator" \
              "3. auto: default.active-hdl/modelsim: use pre-compiled library;others: compile library"
        sim_group.add_argument("--library-path", help=_h0)
        sim_group.add_argument("-l", "--library-precompiled", choices=("yes", "no", "auto"), help=_h1)

        ex_group = sim_group.add_mutually_exclusive_group()
        ex_group.add_argument("--sim-modelsim",  dest="run_modelsim", action="store_true", help="run simulation with Modelsim")
        ex_group.add_argument("--sim-questasim", dest="run_questasim", action="store_true", help="run simulation with Questasim")
        ex_group.add_argument("--sim-riviera",   dest="run_riviera", action="store_true", help="run simulation with Riviera")
        ex_group.add_argument("--sim-activehdl", dest="run_activehdl", action="store_true", help="run simulation with ActiveHDL")
        ex_group.add_argument("--sim-vcs", dest="run_vcs", action="store_true", help="run simulation with VCS")
        ex_group.add_argument("--sim-xrun", dest="run_xrun", action="store_true", help="run simulation with XRUN")

        sim_group.add_argument("--sim-rtl",     action="store_true", help="run rtl simulation")
        sim_group.add_argument("--sim-syn-vhd", action="store_true", help="run post synthesis simulation(VHDL)")
        sim_group.add_argument("--sim-syn-vlg", action="store_true", help="run post synthesis simulation(Verilog)")
        sim_group.add_argument("--sim-postsyn-vm", action="store_true",
                               help="run post synthesis simulation with vm file( Radiant )")
        sim_group.add_argument("--sim-no-lst", action="store_true", help="do not dump lst file in simulation flow")
        if self.is_ng_flow:
            sim_group.add_argument("--dms", action="store_true", help="run Radiant DMS flow")
            sim_group.add_argument("--dms-standalone", action="store_true", help="run Radiant DMS standalone flow")
        else:
            sim_group.add_argument("--sim-map-vhd", action="store_true", help="run MapVHDL simulation")
            sim_group.add_argument("--sim-map-vlg", action="store_true", help="run MapVerilog simulation")
        sim_group.add_argument("--sim-par-vhd", action="store_true", help="run ParVHDL simulation")
        sim_group.add_argument("--sim-par-vlg", action="store_true", help="run PARVerilog simulation")
        sim_group.add_argument("--sim-bit-vlg", action="store_true", help="run BIT Verilog simulation")
        sim_group.add_argument("--sim-all", action="store_true", help="run all simulation flow")
        lp_choices = ("5", "1000", "0.5")
        sim_group.add_argument("--lst-precision", choices=lp_choices,
                             default="5", help="specify lst precision number, default is 5 ns")
        sdf_choices = ("min", "typ", "max")
        sim_group.add_argument("--sim-with-sdf", choices=sdf_choices,
                             help="specify the type of running post-map/par simulation flow with sdf file,"
                                  " valid choices are %s" % ",".join(sdf_choices))
        simrel_types = ("sim_rtl", "sim_map_vlg", "sim_map_vhd", "sim_par_vlg", "sim_par_vhd")
        _h2 = "run simrel flow and specify the lst file type, valid choices are: %s" % ", ".join(simrel_types)
        sim_group.add_argument("--run-simrel", choices=simrel_types, help=_h2)
        sim_group.add_argument("--simrel-copy-wave", action="store_true", help="copy back Simrel outwaves")
        sim_group.add_argument("--sim-coverage", action="store_true", help="run Questasim coverage flow")
        sim_group.add_argument("--sim-coverage-args", default="sbecft", help="Questasim coverage flow arguments")
        # self.parser.add_argument_group(sim_group)

    def add_diamond_options(self):
        diamond_group = self.parser.add_argument_group("Diamond Options")
        diamond_group.add_argument("-X", "--x86", action="store_true", help="run with x86 vendor tools")
        if not self.is_ng_flow:
            diamond_group.add_argument("--diamond", help="specify Diamond install path")
            diamond_group.add_argument("--diamond-lin", help="specify Diamond install path(Linux)")
            diamond_group.add_argument("--diamond-sol", help="specify Diamond install path(Solaris)")
            diamond_group.add_argument("--diamond-fe", help="specify Diamond install path for running synthesis")
            diamond_group.add_argument("--diamond-be", help="specify Diamond install path for running mpar")
        else:
            diamond_group.add_argument("--radiant", help="specify Radiant install path")
            diamond_group.add_argument("--radiant-lin", help="specify Radiant install path(Linux)")
            diamond_group.add_argument("--radiant-sol", help="specify Radiant install path(Solaris)")
            diamond_group.add_argument("--radiant-fe", help="specify Radiant install path for running synthesis")
            diamond_group.add_argument("--radiant-be", help="specify Radiant install path for running mpar")
        # self.parser.add_argument_group(diamond_group)

    def add_project_options(self):
        _choice_synthesis = ("synplify", "lse", "precision")
        _choice_strategy = ("area", "timing", "default")
        _choice_goal = ("area", "timing", "balanced")
        _choice_performance = ("0", "7", "8", "9", "10", "11", "12", "High-Performance_1.0V_Typical")
        frontend_group = self.parser.add_argument_group("Project Options")
        # /*
        #  * change run_scuba function from boolean to choices
        #  */
        # frontend_group.add_argument("--run-scuba", action="store_true", help="run scuba to update the model files")
        scuba_choice = ("normal", "reverse", "verilog", "vhdl")
        frontend_group.add_argument("--run-scuba", choices=scuba_choice,
                                  help="update models with users definition, valid choices are: %s" % ",".join(scuba_choice))
        frontend_group.add_argument("--run-ipgen", action="store_true", help="run ipgen in models folder for Radiant flow")
        frontend_group.add_argument("--run-ignore-tcl", action="store_true", help="Ignore customer's tcl file")
        frontend_group.add_argument("--devkit", help="specify the devkit name")
        frontend_group.add_argument("--gen-pdc", action="store_true", help="Radiant auto-generate pdc file for QoR")
        # frontend_group.add_argument("--performance", choices=_choice_performance,
        #                           help="specify Radiant device performance grade. "
        #                                "valid choices are: %s" % str(_choice_performance))
        frontend_group.add_argument("--performance", help="specify Radiant device performance grade.")

        frontend_group.add_argument("--random-devkit", metavar="dev1,dev2,dev3,dev4", help="specify random devkit list")
        frontend_group.add_argument("--synthesis", choices=_choice_synthesis,
            help="specify synthesis name, else use default one")
        frontend_group.add_argument("--use-sdc", action="store_true", help="use sdc file for synthesis flow if found it")
        frontend_group.add_argument("--strategy", choices=_choice_strategy,
            help="specify Diamond strategy name, if None, use Strategy1 or design current strategy")
        frontend_group.add_argument("--goal", choices=_choice_goal,
            help="specify synthesis optimization goal")
        frontend_group.add_argument("--fanout", type=int, help="specify fanout limitation number")
        frontend_group.add_argument("--frequency", type=int, help="specify the synthesis frequency constraint number")
        frontend_group.add_argument("--mixed-drivers", action="store_true", help="set Resolve Mixed Drivers True")
        frontend_group.add_argument("--block-lpf", action="store_true",
            help="Do NOT transmit constraint from sdc/ldc to lpf/prf file")
        frontend_group.add_argument("--set-strategy", action="append",
            help='set strategy, example:--set-strategy="syn_res_sharing=False maptrce_check_unconstrained_connections=True')
        frontend_group.add_argument("--empty-lpf", action="store_true",
            help="use default lpf file to run the first step flow")
        frontend_group.add_argument("--lpf-factor", type=float, help="specify constraints factor for lpf file")
        frontend_group.add_argument("--use-ori-clks", action="store_true", help="use original clocks in the flow")

        frontend_group.add_argument("--synthesis-done", action="store_true", help="synthesis already done")

        frontend_group.add_argument("--clean", action="store_true", help="clean the working path before running the flow")
        # self.parser.add_argument_group(frontend_group)

    def add_impl_options(self):
        backend_group = self.parser.add_argument_group("Implementation Options")
        backend_group.add_argument("--pushbutton", action="store_true", help="default pushbutton flow, run till the par trace")
        backend_group.add_argument("--run-synthesis", action="store_true", help="run synthesis flow")
        backend_group.add_argument("--run-translate", action="store_true", help="run Translate Design flow")
        backend_group.add_argument("--run-ncl", action="store_true", help="run NCD2NCL flow")
        backend_group.add_argument("--run-udb", action="store_true", help="run Radiant udb2sv/udb2txt flow")
        _choice_udb2sv = ("rtl", "syn", "map", "par")
        backend_group.add_argument("--run-udb2sv", choices=_choice_udb2sv, nargs="+", help="execute udb2sv command with udb file(s)")
        backend_group.add_argument("--map-done", action="store_true", help="map flow already done")
        backend_group.add_argument("--run-map", action="store_true", help="run Map flow")
        backend_group.add_argument("--run-map-trce", dest="run_map_trace", action="store_true", help="run Map Trace trace flow")
        if not self.is_ng_flow:
            backend_group.add_argument("--run-map-vlg", action="store_true", help="generate Map Verilog Simulation File")
            backend_group.add_argument("--run-map-vhd", action="store_true", help="generate Map VHDL Simulation File")
        else:
            backend_group.add_argument("--run-synthesis-trce", dest="run_synthesis_trace", action="store_true",
                                       help="run Radiant synthesis trace flow")
        backend_group.add_argument("--run-par", action="store_true", help="run PAR flow")
        backend_group.add_argument("--run-par-trce", dest="run_par_trace", action="store_true", help="run Place & Route Trace flow")
        backend_group.add_argument("--run-par-iota", dest="run_par_ta", action="store_true", help="run I/O Timing Analysis flow")
        backend_group.add_argument("--run-par-power", action="store_true", help="run par powercal flow")
        backend_group.add_argument("--run-export-ibis", action="store_true", help="run Export IBIS Model flow")
        backend_group.add_argument("--run-export-ami", action="store_true", help="run Export IBIS AMI Model flow")
        backend_group.add_argument("--run-export-vlg", action="store_true", help="generate Export Verilog Simulation File")
        backend_group.add_argument("--run-export-vhd", action="store_true", help="generate Export VHDL Simulation File")
        backend_group.add_argument("--run-export-jedec", action="store_true", help="generate Export JEDEC File")
        backend_group.add_argument("--run-export-bitstream", action="store_true", help="generate Export Bitstream File")
        backend_group.add_argument("--run-export-prom", action="store_true", help="generate Export PROM File")
        backend_group.add_argument("--run-export-xo3l", action="store_true", help="generate xo3l export files")
        backend_group.add_argument("--run-export-rbt", action="store_true", help="generate .rbt file instead of .bit file")
        backend_group.add_argument("--till-map", action="store_true", help="run till map trace flow")
        backend_group.add_argument("--synthesis-only", action="store_true", help="run synthesis only")

        backend_group.add_argument("--fmax-sweep", metavar="<from,to,step>",
            help="specify fmax sweeping range")
        backend_group.add_argument("--fmax-in-whole", action="store_true", help="use fmax in the whole test flow")
        backend_group.add_argument("--seed-sweep", metavar="<from,to,step>",
            help="specify seed sweeping range")
        backend_group.add_argument("--fmax-seed", action="store_true", help="run seed sweeping for every fmax points")
        backend_group.add_argument("--fmax-center", metavar="<initial_frequency,increase_percentage,total_points>",
                                 help="specify fmax-center arguments")
        backend_group.add_argument("--pap-range", type=int, nargs=2, help="specify pap range, for example: 70 80")
        backend_group.add_argument("--pdc4center", action="store_true", help="inner switch for fmax center methodology")
        backend_group.add_argument("--double-step", action="store_true", help="double the running step for running faster")
        backend_group.add_argument("--smoke", action="store_true", help="run smoke test")
        # self.parser.add_argument_group(backend_group)

    def flatten_options_1st(self):
        self.dry_run = self.scripts_options.get("dry_run")
        self.copy_all = self.scripts_options.get("copy_all")
        self.quiet = self.scripts_options.get("quiet")
        self.scan_only = self.scripts_options.get("scan_only")
        self.conf = self.scripts_options.get("conf")
        self.top_dir = self.scripts_options.get("top_dir")
        self.design = self.scripts_options.get("design")
        self.timeout = self.scripts_options.get("timeout")
        self.dms_standalone = self.scripts_options.get("dms_standalone")
        if self.timeout:
            os.environ["YOSE_TIMEOUT"] = str(self.timeout)
        self.toe = self.scripts_options.get("toe")
        if self.toe:
            os.environ["trial_and_error"] = "1"
        self.info_file_name = self.scripts_options.get("info")
        self.job_dir = self.scripts_options.get("job_dir")
        self.tag = self.scripts_options.get("tag")
        self.qas = self.scripts_options.get("qas")
        self.dsp = self.scripts_options.get("dsp")
        self.scuba_type = self.scripts_options.get("scuba_type")
        self.run_ipgen = self.scripts_options.get("run_ipgen")
        self.run_ignore_tcl = self.scripts_options.get("run_ignore_tcl")
        self.scuba_only = self.scripts_options.get("scuba_only")
        self.check_rpt = self.scripts_options.get("check_rpt")
        self.run_ice = self.scripts_options.get("run_ice")
        self.check_only = self.scripts_options.get("check_only")
        self.check_conf = self.scripts_options.get("check_conf")
        if self.check_conf:
            fname, fext = os.path.splitext(self.check_conf)
            if not fext:
                self.check_conf = fname + ".conf"
            self.scripts_options["check_conf"] = self.check_conf
        self.scan_rpt = self.scripts_options.get("scan_rpt")
        self.scan_pap_rpt = self.scripts_options.get("scan_pap_rpt")
        self.devkit = self.scripts_options.get("devkit")
        self.random_devkit = self.scripts_options.get("random_devkit")
        self.run_simrel = self.scripts_options.get("run_simrel")
        self.run_export_rbt = self.scripts_options.get("run_export_rbt")
        if self.run_simrel or self.run_export_rbt:
            _t = "{bit_out_format=Raw Bit File (ASCII)}"
            self.scripts_options["run_export_bitstream"] = 1
            _set_strategy = self.scripts_options.get("set_strategy")
            if not _set_strategy:
                _set_strategy = _t
            else:
                if type(_set_strategy) is list:
                    _set_strategy.append(_t)
                else:
                    _set_strategy += ", %s" % _t
            self.scripts_options["set_strategy"] = _set_strategy
        for a in ("diamond", "radiant"):
            for b in ("be", "fe"):
                if self.scripts_options.get("{}_{}".format(a, b)):
                    self.scripts_options["run_synthesis"] = True

        if not self.devkit:
            if self.random_devkit:
                random_devkit = re.split(",", self.random_devkit)
                one_devkit = random.choice(random_devkit)
                self.devkit = one_devkit.strip()
                xTools.say_it("* MSG: select devkit %s from %s" % (self.devkit, random_devkit))
                self.scripts_options["devkit"] = self.devkit

        x = self.scripts_options.get("sim_bit_vlg")
        if x:
            on_win, os_name = xTools.get_os_name()
            if on_win:
                print("Warning. Cannot run sim-bit-vlg flow on Windows")
                self.scripts_options["sim_bit_vlg"] = None

    def _new_content(self, key, value):
        cmd_value = self.scripts_options.get(key)
        if cmd_value:
            pass
        else:
            self.scripts_options[key] = value

    def merge_ex_env(self):
        """Merge environment by user settings.
        now it only support external_xxx
        """
        for key, value in list(os.environ.items()):
            key = key.upper()
            if key.startswith("EXTERNAL_"):
                key_list = re.split("_", key)
                path_name = "_".join(key_list[1:]).lower()
                if path_name in ("diamond_path", "diamondng_path"):
                    self._new_content("diamond", value)
                    self._new_content("diamond_lin", value)
                    self._new_content("diamond_sol", value)
                elif path_name == "radiant_path":
                    self._new_content("radiant", value)
                    self._new_content("radiant_lin", value)
                    self._new_content("radiant_sol", value)
                else:
                    got_it = 0
                    for a in ("radiant", "diamond"):
                        for b in ("be", "fe"):
                            my_path_name = "{}_{}".format(a, b)
                            if my_path_name in path_name:
                                self._new_content(my_path_name, value)
                                got_it = 1
                                break
                        if got_it:
                            break
                    else:
                        # ("modelsim_path", "questasim_path", "riviera_path", "icecube_path"):
                        # # and more like library_path, library_precompiled
                        self._new_content(path_name, value)


if __name__ == "__main__":
    my_test = XOptions(dict())
    my_test.run_option_parser()
