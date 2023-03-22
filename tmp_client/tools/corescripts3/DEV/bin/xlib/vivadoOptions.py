#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 8:59 AM 11/7/2022
  file: vivadoOptions.py
  author: Shawn Yan
Description:

"""
import os
import re
import argparse
from . import CONSTANTS
from .localCapuchin import xLogger
from .localCapuchin import xTools


class AlphaOptions(xLogger.Voice):
    def __init__(self):
        super(AlphaOptions, self).__init__()
        self.parser = argparse.ArgumentParser()
        self.opts = None

    def add_general_options(self, group_name):
        gg = self.parser.add_argument_group(group_name)
        gg.add_argument("-d", "--debug", action="store_true", help="print debug message")
        gg.add_argument("--top-dir", help="specify top source directory")
        gg.add_argument("--design", help="specify design name")
        gg.add_argument("--info", help="specify design .info file name")
        gg.add_argument("--check-conf", nargs="+", help="specify check configuration file(s)")
        gg.add_argument("--scan-report", action="store_true", help="scan and dump reports")
        gg.add_argument("--scan-report-only", action="store_true", help="scan and dump reports ONLY")
        gg.add_argument("--fmax-sort", choices=("max", "geomean"), default="max", help="specify fmax sort way")
        gg.add_argument("--solo", action="store_const", const="solo_", help="run SOLO flow based on current results")
        gg.set_defaults(solo="")

    def pick_general_options(self):
        self.debug = self.opts.debug
        self.top_dir = self.opts.top_dir
        self.design = self.opts.design
        self.info = self.opts.info
        self.check_conf = self.opts.check_conf
        self.scan_report = self.opts.scan_report
        self.scan_report_only = self.opts.scan_report_only
        self.fmax_sort = self.opts.fmax_sort
        self.solo = self.opts.solo
        # inference and check
        if not self.top_dir:
            if self.design:
                self.top_dir = os.getcwd()
            else:  # in design path
                self.top_dir, self.design = os.path.split(os.getcwd())
        if not self.design:
            self.say_error("Error. Not specify design name")
            return 1
        self.design_path = xTools.get_real_path(self.design, self.top_dir)
        if not os.path.exists(self.design_path):
            self.say_error("Error. Not found design {}".format(self.design_path))
            return 1
        # update itself
        self.top_dir = xTools.win2unix(self.top_dir)
        self.opts.top_dir, self.opts.design = self.top_dir, self.design
        self.opts.design_path = self.design_path
        self.default_conf_path = xTools.win2unix(os.path.join(os.path.abspath(__file__), "..", "..", "..", "conf"), 1)
        self.opts.default_conf_path = self.default_conf_path

    @staticmethod
    def build_choice_kwargs(declaration, dict_choice, nargs=None, default_index=None):
        kwargs = dict()
        kwargs["choices"] = raw_keys = list(dict_choice.keys())
        help_list = list()
        for k, v in list(dict_choice.items()):
            help_list.append("{}: {}".format(k, v.get("description")))
        help_string = "{} ({})".format(declaration, ", ".join(help_list))
        if default_index is not None:
            kwargs["default"] = default_value = raw_keys[default_index]
            help_string += ". Default is {}".format(default_value)
        kwargs["help"] = help_string
        if nargs:
            kwargs["nargs"] = nargs
        return kwargs


class BetaOptions(AlphaOptions):
    """Vivado Options
    """
    def __init__(self):
        super(BetaOptions, self).__init__()
        self.vivado_simulation_settings = CONSTANTS.VIVADO_SIMULATION_SETTINGS
        self.vivado_simulator_settings = CONSTANTS.VIVADO_SIMULATOR_SETTINGS
        self.vivado_synthesis_settings = CONSTANTS.VIVADO_SYNTHESIS_SETTINGS

    def add_vivado_general_options(self, group_name):
        vgg = self.parser.add_argument_group(group_name)
        vgg.add_argument("--path-vivado", help="specify Vivado installation path")

    def pick_vivado_general_options(self):
        self.path_vivado = self.opts.path_vivado

    def add_vivado_synthesis_options(self, group_name):
        vsg = self.parser.add_argument_group(group_name)
        x = self.build_choice_kwargs("Select Synthesis Tool:", self.vivado_synthesis_settings, default_index=0)
        vsg.add_argument("--synthesis", **x)
        vsg.add_argument("--path-synplify", help="specify SynplifyPro installation path")
        vsg.add_argument("--run-synthesis", action="store_true", help="run synthesis flow")

    def pick_vivado_synthesis_options(self):
        self.synthesis = self.opts.synthesis
        self.path_synplify = self.opts.path_synplify
        self.run_synthesis = self.opts.run_synthesis

    def add_vivado_implementation_options(self, group_name):
        vig = self.parser.add_argument_group(group_name)
        vig.add_argument("--run-impl", action="store_true", help="Run Implementation Flow")
        vig.add_argument("--run-bitstream", action="store_true", help="Run Generate Bitstream Flow")
        ex_group = vig.add_mutually_exclusive_group()
        ex_group.add_argument("--fmax-sweep", type=int, nargs=3, help="specify fmax sweeping range: (start end step)")
        _help = "specify fmax iteration setting: (adjust_percentage iteration_number"
        ex_group.add_argument("--fmax-iteration", type=float, nargs=2, help=_help)

    def pick_vivado_implementation_options(self):
        self.run_impl = self.opts.run_impl
        self.run_bitstream = self.opts.run_bitstream
        self.fmax_sweep = self.opts.fmax_sweep
        self.fmax_iteration = self.opts.fmax_iteration
        if self.fmax_sweep:
            self.fmax_sweep = (self.fmax_sweep[0], self.fmax_sweep[1]+1, self.fmax_sweep[2])

    def add_vivado_simulation_options(self, group_name):
        vmg = self.parser.add_argument_group(group_name)
        x = self.build_choice_kwargs("Select Simulator:", self.vivado_simulator_settings, default_index=0)
        vmg.add_argument("--simulator", **x)
        for i, (k, v) in enumerate(list(self.vivado_simulator_settings.items())):
            if not i:  # is Xilinx simulator by default
                continue
            vmg.add_argument("--path-{}".format(k), help="Specify {description} installation path".format(**v))
        vmg.add_argument("--path-gcc", help="specify GCC installation path")
        y = self.build_choice_kwargs("Run Simulation:", self.vivado_simulation_settings, nargs="+")
        vmg.add_argument("--run-simulation", **y)

    def pick_vivado_simulation_options(self):
        self.simulator = self.vivado_simulator_settings.get(self.opts.simulator).get("description")
        self.opts.simulator = self.simulator
        self.path_questa = self.opts.path_questa
        self.path_modelsim = self.opts.path_modelsim
        self.path_riviera = self.opts.path_riviera
        self.path_activehdl = self.opts.path_activehdl
        self.path_gcc = self.opts.path_gcc
        self.run_simulation = self.opts.run_simulation

    def pick_vivado_infer_options(self):
        if self.scan_report_only:
            self.run_synthesis = False
            self.run_impl = False
            self.run_bitstream = False
            self.run_simulation = list()
            self.fmax_sweep = None
            return
        if self.solo:
            return
        if self.run_simulation:
            if "psf" in self.run_simulation or "pst" in self.run_simulation:
                self.run_synthesis = self.opts.run_synthesis = True
            if "pif" in self.run_simulation or "pit" in self.run_simulation:
                self.run_synthesis = self.opts.run_synthesis = True
                self.run_impl = self.opts.run_impl = True
        if self.fmax_sweep or self.run_impl or self.fmax_iteration:
            self.run_synthesis = self.opts.run_synthesis = True
            self.run_impl = self.opts.run_impl = True


class GammaOptions(BetaOptions):
    pass


class DeltaOptions(GammaOptions):
    pass


class EpsilonOptions(DeltaOptions):
    pass


class FlowOptions(EpsilonOptions):
    def __init__(self, vendor):
        super(FlowOptions, self).__init__()
        self.vendor = vendor
        self.arg_groups = ("general", f"{vendor}_general", f"{vendor}_synthesis",
                           f"{vendor}_implementation", f"{vendor}_simulation", f"{vendor}_infer")

    def parse_command_options(self, args=None):
        if self._eval_add_pick_functions("self.add_{0}('{1}')", self.arg_groups[:-1]):
            return 1
        self.opts = self.parser.parse_args(args)
        self.opts_dict = self.opts.__dict__
        self.merge_external_path_environments()
        if self._eval_add_pick_functions("self.pick_{0}()", self.arg_groups):
            return 1
        self.say_debug(self.opts_dict, comments="Command Options:", debug=self.debug)

    def _eval_add_pick_functions(self, template, group_list):
        for ag in group_list:
            ag_list = list()
            partial_name = "{}_options".format(ag)
            ag_list.append(partial_name)
            partial_name_list = re.split("_", partial_name)
            partial_name_list = [foo.capitalize() for foo in partial_name_list]
            ag_list.append(" ".join(partial_name_list))
            func_string = template.format(*ag_list)
            try:
                sts = eval(func_string)
                if sts:
                    return 1
            except AttributeError:
                print("Failed to run 'OmegaOptions.{}()'".format(func_string))
                self.say_traceback()
                return 1

    def merge_external_path_environments(self):
        """ Environment like EXTERNAL_VIVADO_PATH
        """
        p_external = re.compile("EXTERNAL_(.+)_PATH", re.I)  # IGNORE CASE
        for key, value in list(os.environ.items()):
            m_key = p_external.search(key)
            if m_key:
                _name = "path_{}".format(m_key.group(1))
                _name = _name.lower()
                opt_value = self.opts_dict.get(_name)
                if not opt_value:  # command arguments has higher priority
                    self.opts_dict[_name] = value  # update itself
