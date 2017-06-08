import os
import re
import sys
import glob
import copy
import random
import optparse

import xTools

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
        for section, options in new_options.items():
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
        self.parser = optparse.OptionParser()
        self.add_public_options()
        if self.run_vendor == "lattice":
            self.add_lattice_options()
        opts, args = self.parser.parse_args()
        _cmd_opts = eval(str(opts))
        xTools.dict_none_to_new(self.scripts_options, _cmd_opts)
        self.debug = self.scripts_options.get("debug")
        xTools.say_it(self.scripts_options, "Command Options", self.debug)

    def add_public_options(self):
        _choice_scuba_type = ("vhdl", "verilog")
        pub_group = optparse.OptionGroup(self.parser, "Public Options")
        pub_group.add_option("-d", "--debug", action="store_true", help="print debug message")
        pub_group.add_option("--copy-all", action="store_true", help="copy all files in ldf_dir to working directory")
        pub_group.add_option("--set-env", help="specify users environment value (a=1;b=2)")

        pub_group.add_option("-D", "--dry-run", action="store_true",
            help="Dry run the test flow, generate the Lattice Diamond File(.ldf) only")
        # - pub_group.add_option("-q", "--quiet", action="store_true", help="print as little as possible")
        pub_group.add_option("-R", "--scan-rpt", action="store_true", help="scan reports after flow done")

        pub_group.add_option("-F", "--file", help="specify user configuration file, which format is" +
                                                  " same as the conf/default.ini file")
        pub_group.add_option("--conf", help="specify the configuration path name.")
        pub_group.add_option("--top-dir", help="specify the top source path name")
        pub_group.add_option("--design", help="specify the design name")
        pub_group.add_option("--info", help="specify info file name")
        pub_group.add_option("--job-dir", help="specify the job working path name")
        pub_group.add_option("--tag", default="_scratch", help="specify the job tag name, default is _scratch, " +
                                                               "which is created in the design job working path")
        pub_group.add_option("--qas", action="store_true", help="will run qas test flow")
        pub_group.add_option("--dsp", action="store_true", help="will run DSP test flow")
        pub_group.add_option("--pmi", action="store_true", help="run PMI implementation and simulation flow")
        pub_group.add_option("--scuba-type", type="choice", choices=_choice_scuba_type,
            help="specify scuba test flow source type name")
        pub_group.add_option("--scuba-only", action="store_true", help="run scuba flow only for IPExpress cases")
        pub_group.add_option("--check-rpt", help="specify the check report file")
        pub_group.add_option("--check-only", action="store_true", help="check results only")
        pub_group.add_option("--check-conf", help="specify the check conf FILE NAME")
        pub_group.add_option("--pre-process", help="run pre-process for a case")
        pub_group.add_option("--post-process", help="run post-process for a case")
        pub_group.add_option("--loose-match", action="store_true", help="match the Diamond install path loosely")
        self.parser.add_option_group(pub_group)

    def add_lattice_options(self):
        self.add_diamond_options()
        self.add_project_options()
        self.add_impl_options()
        self.add_simulation_options()

    def add_simulation_options(self):
        sim_group = optparse.OptionGroup(self.parser, "Simulation Options")
        sim_group.add_option("--modelsim-path", help="specify Modelsim install path")
        sim_group.add_option("--questasim-path", help="specify Questasim install path")
        sim_group.add_option("--riviera-path", help="specify Riviera install path")
        sim_group.add_option("--simrel-path", help="specify Simrel install path")
        sim_group.add_option("--sim-modelsim",  dest="run_modelsim", action="store_true", help="run simulation with Modelsim")
        sim_group.add_option("--sim-questasim", dest="run_questasim", action="store_true", help="run simulation with Questasim")
        sim_group.add_option("--sim-riviera",   dest="run_riviera", action="store_true", help="run simulation with Riviera")
        sim_group.add_option("--sim-rtl",     action="store_true", help="run rtl simulation")
        sim_group.add_option("--sim-syn-vhd", action="store_true", help="run post synthesis simulation(VHDL)")
        sim_group.add_option("--sim-syn-vlg", action="store_true", help="run post synthesis simulation(Verilog)")
        if self.is_ng_flow:
            sim_group.add_option("--dms", action="store_true", help="run DiamondNG DMS flow")
        else:
            sim_group.add_option("--sim-map-vhd", action="store_true", help="run MapVHDL simulation")
            sim_group.add_option("--sim-map-vlg", action="store_true", help="run MapVerilog simulation")
        sim_group.add_option("--sim-par-vhd", action="store_true", help="run ParVHDL simulation")
        sim_group.add_option("--sim-par-vlg", action="store_true", help="run PARVerilog simulation")
        sim_group.add_option("--sim-all", action="store_true", help="run all simulation flow")
        sim_group.add_option("--lst-precision", type="int", default=5, help="specify lst precision number, default is 5 ns")
        sim_group.add_option("--with-sdf", action="store_true", help="run post-map/par simulation flow with sdf file")
        simrel_types = ("sim_rtl", "sim_map_vlg", "sim_map_vhd", "sim_par_vlg", "sim_par_vhd")
        sim_group.add_option("--run-simrel", type="choice", choices=simrel_types, help="run simrel flow and specify the lst file type,"
                                                                                        "valid choices are: %s" % ", ".join(simrel_types))
        self.parser.add_option_group(sim_group)

    def add_diamond_options(self):
        diamond_group = optparse.OptionGroup(self.parser, "Diamond Options")
        diamond_group.add_option("-X", "--x86", action="store_true", help="run with x86 vendor tools")
        diamond_group.add_option("--diamond", help="specify Diamond install path")
        diamond_group.add_option("--diamond-lin", help="specify Diamond install path(Linux)")
        diamond_group.add_option("--diamond-sol", help="specify Diamond install path(Solaris)")
        diamond_group.add_option("--diamond-fe", help="specify Diamond install path for running synthesis")
        diamond_group.add_option("--diamond-be", help="specify Diamond install path for running mpar")
        self.parser.add_option_group(diamond_group)

    def add_project_options(self):
        _choice_synthesis = ("synplify", "lse", "precision")
        _choice_strategy = ("area", "timing", "quick")
        _choice_goal = ("area", "timing", "balanced")
        frontend_group = optparse.OptionGroup(self.parser, "Project Options")
        # /*
        #  * change run_scuba function from boolean to choices
        #  */
        # frontend_group.add_option("--run-scuba", action="store_true", help="run scuba to update the model files")
        scuba_choice = ("normal", "reverse", "verilog", "vhdl")
        frontend_group.add_option("--run-scuba", type="choice", choices=scuba_choice,
                                  help="update models with users definition, valid choices are: %s" % ",".join(scuba_choice))
        frontend_group.add_option("--devkit", help="specify the devkit name")
        frontend_group.add_option("--random-devkit", metavar="dev1,dev2,dev3,dev4", help="specify random devkit list")
        frontend_group.add_option("--synthesis", type="choice", choices=_choice_synthesis,
            help="specify synthesis name, else use default one")
        frontend_group.add_option("--use-sdc", action="store_true", help="use sdc file for synthesis flow if found it")
        frontend_group.add_option("--strategy", type="choice", choices=_choice_strategy,
            help="specify Diamond strategy name, if None, use Strategy1 or design current strategy")
        frontend_group.add_option("--goal", type="choice", choices=_choice_goal,
            help="specify synthesis optimization goal")
        frontend_group.add_option("--fanout", type="int", help="specify fanout limitation number")
        frontend_group.add_option("--frequency", type="int", help="specify the synthesis frequency constraint number")
        frontend_group.add_option("--mixed-drivers", action="store_true", help="set Resolve Mixed Drivers True")
        frontend_group.add_option("--block-lpf", action="store_true",
            help="Do NOT transmit constraint from sdc/ldc to lpf/prf file")
        frontend_group.add_option("--set-strategy",
            help='set strategy, example:--set-strategy="syn_res_sharing=False maptrce_check_unconstrained_connections=True')
        frontend_group.add_option("--empty-lpf", action="store_true",
            help="use default lpf file to run the first step flow")
        frontend_group.add_option("--use-ori-clks", action="store_true", help="use original clocks in the flow")

        frontend_group.add_option("--synthesis-done", action="store_true", help="synthesis already done")

        frontend_group.add_option("--clean", action="store_true", help="clean the working path before running the flow")
        self.parser.add_option_group(frontend_group)

    def add_impl_options(self):
        backend_group = optparse.OptionGroup(self.parser, "Implementation Options")
        backend_group.add_option("--pushbutton", action="store_true", help="default pushbutton flow, run till the par trace")
        backend_group.add_option("--run-synthesis", action="store_true", help="run synthesis flow")
        backend_group.add_option("--run-translate", action="store_true", help="run Translate Design flow")
        backend_group.add_option("--run-ncl", action="store_true", help="run NCD2NCL flow")
        backend_group.add_option("--map-done", action="store_true", help="map flow already done")
        backend_group.add_option("--run-map", action="store_true", help="run Map flow")
        backend_group.add_option("--run-map-trce", dest="run_map_trace", action="store_true", help="run Map Trace trace flow")
        if not self.is_ng_flow:
            backend_group.add_option("--run-map-vlg", action="store_true", help="generate Map Verilog Simulation File")
            backend_group.add_option("--run-map-vhd", action="store_true", help="generate Map VHDL Simulation File")
        backend_group.add_option("--run-par", action="store_true", help="run PAR flow")
        backend_group.add_option("--run-par-trce", dest="run_par_trace", action="store_true", help="run Place & Route Trace flow")
        backend_group.add_option("--run-par-iota", dest="run_par_ta", action="store_true", help="run I/O Timing Analysis flow")
        backend_group.add_option("--run-par-power", action="store_true", help="run par powercal flow")
        backend_group.add_option("--run-export-ibis", action="store_true", help="run Export IBIS Model flow")
        backend_group.add_option("--run-export-ami", action="store_true", help="run Export IBIS AMI Model flow")
        backend_group.add_option("--run-export-vlg", action="store_true", help="generate Export Verilog Simulation File")
        backend_group.add_option("--run-export-vhd", action="store_true", help="generate Export VHDL Simulation File")
        backend_group.add_option("--run-export-jedec", action="store_true", help="generate Export JEDEC File")
        backend_group.add_option("--run-export-bitstream", action="store_true", help="generate Export Bitstream File")
        backend_group.add_option("--run-export-prom", action="store_true", help="generate Export PROM File")
        backend_group.add_option("--run-export-xo3l", action="store_true", help="generate xo3l export files")
        backend_group.add_option("--till-map", action="store_true", help="run till map trace flow")
        backend_group.add_option("--synthesis-only", action="store_true", help="run synthesis only")

        backend_group.add_option("--fmax-sweep", type="int", nargs=3, metavar="<from> <to> <step>",
            help="specify fmax sweeping range")
        backend_group.add_option("--seed-sweep", type="int", nargs=3, metavar="<from> <to> <step>",
            help="specify seed sweeping range")
        backend_group.add_option("--fmax-seed", action="store_true", help="run seed sweeping for every fmax points")
        backend_group.add_option("--double-step", action="store_true", help="double the running step for running faster")
        backend_group.add_option("--smoke", action="store_true", help="run smoke test")
        self.parser.add_option_group(backend_group)

    def flatten_options_1st(self):
        self.dry_run = self.scripts_options.get("dry_run")
        self.copy_all = self.scripts_options.get("copy_all")
        self.quiet = self.scripts_options.get("quiet")
        self.scan_only = self.scripts_options.get("scan_only")
        self.conf = self.scripts_options.get("conf")
        self.top_dir = self.scripts_options.get("top_dir")
        self.design = self.scripts_options.get("design")
        self.info_file_name = self.scripts_options.get("info")
        self.job_dir = self.scripts_options.get("job_dir")
        self.tag = self.scripts_options.get("tag")
        self.qas = self.scripts_options.get("qas")
        self.dsp = self.scripts_options.get("dsp")
        self.scuba_type = self.scripts_options.get("scuba_type")
        self.scuba_only = self.scripts_options.get("scuba_only")
        self.check_rpt = self.scripts_options.get("check_rpt")
        self.run_ice = self.scripts_options.get("run_ice")
        self.check_only = self.scripts_options.get("check_only")
        self.check_conf = self.scripts_options.get("check_conf")
        if self.check_conf:
            fname, fext = os.path.splitext(self.check_conf)
            if not fext:
                self.check_conf = fname + ".conf"
        self.scan_rpt = self.scripts_options.get("scan_rpt")
        self.devkit = self.scripts_options.get("devkit")
        self.random_devkit = self.scripts_options.get("random_devkit")
        self.run_simrel = self.scripts_options.get("run_simrel")
        if self.run_simrel:
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


        if not self.devkit:
            if self.random_devkit:
                random_devkit = re.split(",", self.random_devkit)
                one_devkit = random.choice(random_devkit)
                self.devkit = one_devkit.strip()
                xTools.say_it("* MSG: select devkit %s from %s" % (self.devkit, random_devkit))
                self.scripts_options["devkit"] = self.devkit

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
        for key, value in os.environ.items():
            key = key.upper()
            if key.startswith("EXTERNAL_"):
                key_list = re.split("_", key)
                path_name = "_".join(key_list[1:]).lower()
                if path_name in ("diamond_path", "diamondng_path", "radiant_path"):
                    self._new_content("diamond", value)
                    self._new_content("diamond_lin", value)
                    self._new_content("diamond_sol", value)
                else:
                    # ("modelsim_path", "questasim_path", "riviera_path", "icecube_path"):
                    self._new_content(path_name, value)

if __name__ == "__main__":
    my_test = XOptions(dict())
    my_test.run_option_parser()















