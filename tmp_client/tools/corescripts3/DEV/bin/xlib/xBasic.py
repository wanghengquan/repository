"""
Focus on Options.
The BasicRun is the basic class function block.
"""

import os
import sys
import glob
import optparse

from . import yTools

__author__ = 'syan'

class BasicRun:
    def __init__(self, private_options):
        self.run_options = private_options

    def process(self):
        if self.run_options_parser():
            return 1
        if not self.design:
            yTools.say_it("Error. Not found any design to run")
            return 1

        if self.scan_only or self.check_only:
            pass
        elif self.pre_process():
            return 1
        design_number = len(self.design)
        start_time = yTools.head_announce()
        sts = 0
        for i, design in enumerate(self.design):
            self.src_design = os.path.join(self.top_dir, design)
            self.job_design = os.path.join(self.job_dir, design, self.tag)
            if self.scan_only:
                self.run_scan_only()
                continue
            if self.check_only:
                self.run_check_only()
                continue
            _mark = design
            if design_number != 1:
                _mark += " (%d/%d)" % (i+1, design_number)
            play_time = yTools.play_announce(_mark, self.src_design, self.job_design)
            sub_sts = 0
            if yTools.wrap_md(self.job_design, "Job Results Path"):
                sub_sts = 1
            if not sub_sts:
                _recov = yTools.ChangeDir(self.job_design)
                sub_sts = self.run_design()
                _recov.comeback()
            if sub_sts:
                sts += 1
            yTools.stop_announce(sub_sts, _mark, play_time)
        yTools.root_announce(start_time)
        if sts == design_number: # all design failed
            return 1

    def pre_process(self):
        pass

    def run_design(self):
        pass

    def add_flow_options(self):
        pass

    def flatten_options(self):
        pass

    def run_scan_only(self):
        pass

    def run_check_only(self):
        pass

    def run_options_parser(self):
        if self._run_cmd_options_parser():
            return 1
        self._flatten_basic_options()
        if self.get_default_options():
            return 1
        self.merge_run_options()
        self.flatten_options()
        if self.debug:
            yTools.say_it(self.run_options, "Final Options:")

    def _run_cmd_options_parser(self):
        self.parser = optparse.OptionParser()
        self.set_default_and_choices()
        self._add_basic_options()
        self.add_flow_options()
        opts, args = self.parser.parse_args()
        self.cmd_options = eval(str(opts))
        if self._basic_check():
            return 1

    def get_default_options(self):
        self.conf_options = dict()
        if self.conf:
            ini_files = glob.glob(os.path.join(self.conf, "default.ini"))
            if ini_files:
                sts, self.conf_options = yTools.get_conf_options(ini_files)
                if sts:
                    return 1
            else:
                yTools.say_it("Warning. Not found default.ini in %s" % self.conf)

    def merge_run_options(self):
        yTools.dict_none_to_new(self.run_options, self.cmd_options)
        yTools.dict_none_to_new(self.run_options, self.conf_options.get("qa", dict()))

    def set_default_and_choices(self):
        self.syn_tools = ("synplify", "lse") # synthesis tools
        self.default_tag = "_scratch"
        self.lse_goals = ("Balanced", "Timing", "Area")

    def _add_basic_options(self):
        basic_group = optparse.OptionGroup(self.parser, "Basic Options")
        basic_group.add_option("--debug", action="store_true", help="print debug message")
        basic_group.add_option("--dry-run", action="store_true", help="dry run parts of the test flow")
        basic_group.add_option("--check-only", action="store_true", help="check results only")
        basic_group.add_option("--scan-only", action="store_true", help="scan results only")
        basic_group.add_option("--clean", action="store_true", help="clean up and run")
        basic_group.add_option("--top-dir", help="specify top source directory")
        basic_group.add_option("--job-dir", help="specify job working directory")
        basic_group.add_option("--tag", default=self.default_tag, help="specify tag folder name for test results")
        basic_group.add_option("--design", help="specify design name")
        basic_group.add_option("--conf", help="specify configuration path name")
        basic_group.add_option("--devkit", help="specify DEVKIT")
        self.parser.add_option_group(basic_group)

    def _flatten_basic_options(self):
        self.debug = self.cmd_options.get("debug")
        self.dry_run = self.cmd_options.get("dry_run")
        self.check_only = self.cmd_options.get("check_only")
        self.scan_rpt = self.cmd_options.get("scan_rpt")
        self.scan_pap_rpt = self.cmd_options.get("scan_pap_rpt")
        self.scan_only = self.cmd_options.get("scan_only")
        self.clean = self.cmd_options.get("clean")
        self.top_dir = self.cmd_options.get("top_dir")
        self.job_dir = self.cmd_options.get("job_dir")
        self.tag = self.cmd_options.get("tag")
        self.design = self.cmd_options.get("design")
        self.conf = self.cmd_options.get("conf")
        self.devkit = self.cmd_options.get("devkit")

    def _basic_check(self):
        top_dir = self.cmd_options.get("top_dir")
        job_dir = self.cmd_options.get("job_dir")
        design = self.cmd_options.get("design")
        conf = self.cmd_options.get("conf")
        # ----------------------
        # get design list
        if design:
            design = [design]
        else:
            design = list()
        # ----------------------
        # get top_dir and design list
        if top_dir:
            if yTools.not_exists(top_dir, "Top Source Directory"):
                return 1
            top_dir = os.path.abspath(top_dir)
            if not design:
                for item in os.listdir(top_dir):
                    abs_item = os.path.join(top_dir, item)
                    if os.path.isdir(abs_item):
                        design.append(item)
        else:
            if not design:
                t = os.path.split(os.getcwd())
                top_dir = t[0]
                design.append(t[1])
        # ----------------------
        # check conf value
        _base_scripts = os.path.abspath(sys.argv[0])
        conf_root_path = os.path.dirname(os.path.dirname(_base_scripts))
        if not conf:
            conf = "conf"
        if os.path.isdir(conf):
            conf = os.path.abspath(conf)
        else:
            conf = os.path.join(conf_root_path, conf)
            if yTools.not_exists(conf, "Default conf Path"):
                conf = ""  # will use command options only
            # new values after checking
        self.cmd_options["top_dir"] = top_dir
        self.cmd_options["design"] = design
        if not job_dir:
            self.cmd_options["job_dir"] = top_dir
        else:
            self.cmd_options["job_dir"]  = os.path.abspath(job_dir)
        self.cmd_options["conf"] = conf

class BasicClassic(BasicRun):
    def __init__(self, private_options):
        BasicRun.__init__(self, private_options)

    def add_flow_options(self):
        cla_group = optparse.OptionGroup(self.parser, "Classic Flow Options")
        cla_group.add_option("--classic")
        cla_group.add_option("--synthesis", default="synplify", type="choice",
                             choices=self.syn_tools, help="specify synthesis tool name")
        cla_group.add_option("--goal", default="Balanced", type="choice",
                             choices=self.lse_goals, help="specify LSE/Synplify optimization goal")
        cla_group.add_option("--sim-func", action="store_true", help="run Functional Simulation")
        cla_group.add_option("--sim-time", action="store_true", help="run Timing Simulation")
        cla_group.add_option("--sim-all", action="store_true", help="run Functional and Timing Simulation")
        self.parser.add_option_group(cla_group)

    def flatten_options(self):
        self.classic = self.run_options.get("classic")
        self.synthesis = self.run_options.get("synthesis")
        self.goal = self.run_options.get("goal")
        self.sim_func = self.run_options.get("sim_func")
        self.sim_time = self.run_options.get("sim_time")
        self.sim_all = self.run_options.get("sim_all")
        if self.sim_all:
            self.sim_func = self.sim_time = 1

if __name__ == "__main__":
    t = BasicClassic(dict())
    t.process()


