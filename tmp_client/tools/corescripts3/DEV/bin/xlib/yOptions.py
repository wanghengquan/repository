import os
import re
import sys
import glob
import optparse

from . import xTools

__author__ = 'syan'

class RunOptions:
    def __init__(self, private_options):
        self.run_options = private_options
        self.run_options["cwd"] = os.getcwd()


    def run_options_parser(self):
        if self._run_cmd_options_parser():
            return 1
        self._flatten_basic_options()
        if self.get_conf_options():
            return 1
        self.merge_run_options()
        self.flatten_options()

    def _run_cmd_options_parser(self):
        self.parser = optparse.OptionParser()
        self.set_default_and_choices()
        self._add_basic_options()
        self.add_options()
        opts, args = self.parser.parse_args()
        self.cmd_options = eval(str(opts))
        if self._basic_check():
            return 1

    def add_options(self):
        pass

    def get_conf_options(self):
        self.conf_options = dict()

    def merge_run_options(self):
        pass

    def flatten_options(self):
        pass


    def set_default_and_choices(self):
        self.syn_tools = ("synplify", "lse") # synthesis tools
        self.default_tag = "_scratch"

    def _add_basic_options(self):
        basic_group = optparse.OptionGroup(self.parser, "Basic Options")
        basic_group.add_option("--debug", action="store_true", help="print debug message")
        basic_group.add_option("--dry-run", action="store_true", help="dry run parts of the test flow")
        basic_group.add_option("--check-only", action="store_true", help="check results only")
        basic_group.add_option("--check-conf", help="specify the check conf FILE NAME")
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
            if xTools.not_exists(top_dir, "Top Source Directory"):
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
            if xTools.not_exists(conf, "Default conf Path"):
                conf = ""  # will use command options only
        # new values after checking
        self.cmd_options["top_dir"] = top_dir
        self.cmd_options["design"] = design
        if not job_dir:
            self.cmd_options["job_dir"] = top_dir
        self.cmd_options["conf"] = conf

class ClassicOptions(RunOptions):
    def __init__(self, private_options):
        RunOptions.__init__(self, private_options)

    def add_options(self):
        cla_group = optparse.OptionGroup(self.parser, "Classic Flow Options")
        cla_group.add_option("--classic")
        self.parser.add_option_group(cla_group)

    def get_conf_options(self):
        self.conf_options = dict()
        if self.conf:
            ini_files = glob.glob(os.path.join(self.conf, "*.ini"))
            if ini_files:
                sts, self.conf_options = xTools.get_conf_options(ini_files)
                if sts:
                    return 1
            else:
                xTools.say_it("Warning. No ini file found in %s" % self.conf)

    def merge_run_options(self):
        xTools.dict_none_to_new(self.run_options, self.cmd_options)
        xTools.dict_none_to_new(self.run_options, self.conf_options.get("qa", dict()))
        if self.debug:
            xTools.say_it(self.run_options, "Final Options:")

    def flatten_options(self):
        self.classic = self.run_options.get("classic")

if __name__ == "__main__":
    t = ClassicOptions(dict())
    t.run_options_parser()


