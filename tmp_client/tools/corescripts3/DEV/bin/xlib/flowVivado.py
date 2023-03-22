#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 8:57 AM 11/7/2022
  file: flowVivado.py
  author: Shawn Yan
Description:

"""
import os
import re
import shutil
import glob
import json

from . import vivadoBasicFlow
from . import vivadoBasicScan
from . import CONSTANTS
from . import vivadoUtil
from .localCapuchin import xTools


class FlowVivado(vivadoBasicFlow.BasicFlow):
    def __init__(self):
        super(FlowVivado, self).__init__("vivado")

    def basic_very_first_process(self):
        """try to get all possible key-value dictionary
        """
        self.kwargs = dict()
        self.section_qa_dict = self.info_dict.get("qa", dict())
        self.section_sim_dict = self.info_dict.get("sim", dict())
        self.xpr_file = self.section_qa_dict.get("xpr_file")
        if not self.xpr_file:
            self.say_error("Error. Not specify xpr file in {}".format(self.info_file))
            return 1
        self.kwargs["xpr_file"] = self.xpr_file
        if self.run_synthesis or self.run_impl or self.run_simulation or self.run_bitstream \
                or (self.solo and self.fmax_sweep):
            self.kwargs["vivado_path"] = self.path_vivado
        if self.run_synthesis and self.synthesis == "synplify":
            self.kwargs["synplify_path"] = self.path_synplify
            spf_key = "synplify_project_file"
            self.kwargs[spf_key] = self.section_qa_dict.get(spf_key)
        self.use_vivado_simulator = (self.simulator == "XSim")
        if self.run_simulation and (not self.use_vivado_simulator):
            self.kwargs["simulator_path"] = self.opts_dict.get("path_{}".format(self.simulator.lower()))
            self.kwargs["gcc_path"] = self.opts_dict.get("path_gcc")
        self.working_path = os.path.dirname(self.info_file)
        self.recovery = xTools.ChangeDir(self.working_path)
        check_exists = 0
        for k, v in list(self.kwargs.items()):
            if not v:
                self.say_error("Error. No value for {}".format(k))
                check_exists = 1
            else:
                v = xTools.get_real_path(v, os.getcwd())
                if not os.path.exists(v):
                    self.say_error(f"Error. Not found {v} for {k}")
                    check_exists = 1
                else:
                    self.kwargs[k] = v
        if check_exists:
            return check_exists
        self.xpr_file = self.kwargs.get("xpr_file")
        self.kwargs["project_name"] = self.project_name = xTools.get_file_name_only(self.xpr_file)
        self.project_root = os.path.dirname(self.xpr_file)
        _basic_path = "{}/{}.".format(self.project_root, self.project_name)
        self.kwargs["project_root"] = self.project_root
        self.kwargs["point_runs"] = _basic_path + "runs"
        self.kwargs["point_srcs"] = point_srcs = _basic_path + "srcs"
        self.kwargs["simulator_lower"] = self.simulator.lower()
        self.kwargs["simulator_name"] = self.simulator
        self.kwargs["more_tcl"] = self.section_qa_dict.get("more_tcl")
        xTools.wrap_md(point_srcs, "PreSetSrcsFolder")  # when a case do not have this folder

    def basic_flow_processes(self):
        self.tcl_lines = list()
        if self.fmax_sweep:
            vivadoUtil.cleanup_vivado_xdc(self.xpr_file)
            self.prepare_synthesis_lines()
            self.prepare_impl_lines()
            self.run_vivado_tcl("run_impl_flow")
            if self.get_clocks():
                return
            self.run_impl = self.run_synthesis = True
            for fmax_point in range(*self.fmax_sweep):
                self.say_info("* Running Fmax {:07.3f} MHz".format(fmax_point))
                target_folder = "target_fmax_{:07.3f}".format(fmax_point)
                self.tcl_lines = list()
                self.add_fmax_xdc_file(fmax_point)
                self.prepare_synthesis_lines(in_sweeping_flow=True)
                self.prepare_impl_lines()
                self.run_vivado_tcl(f"run_{target_folder}")
                self.move_and_clean_working_directory(target_folder)
        elif self.fmax_iteration:
            self.prepare_synthesis_lines()
            self.prepare_impl_lines()
            self.run_vivado_tcl("run_impl_flow")
            self.move_and_clean_working_directory("target_iteration_00")
            self.run_impl = self.run_synthesis = True
            for iteration_number in range(1, int(self.fmax_iteration[-1]+1)):
                self.say_info("* Running Fmax Iteration Number: {}".format(iteration_number))
                if self.get_clock_frequency_slack():  # self.c_f_s
                    return 1
                vivadoUtil.cleanup_vivado_xdc(self.xpr_file)
                target_folder = "target_iteration_{:02d}".format(iteration_number)
                self.tcl_lines = list()
                self.add_iteration_xdc_file(iteration_number)
                self.prepare_synthesis_lines(in_sweeping_flow=True)
                self.prepare_impl_lines()
                self.run_vivado_tcl(f"run_{target_folder}")
                self.move_and_clean_working_directory(target_folder)
        else:
            self.prepare_synthesis_lines()
            self.prepare_impl_lines()
            self.prepare_simulation_lines()
            self.run_vivado_tcl("run_test_flow")

    def prepare_synthesis_lines(self, in_sweeping_flow=False):
        if not self.run_synthesis:
            return
        if self.synthesis == "xsyn":
            self.tcl_lines.append(CONSTANTS.STR_LAUNCH_SYNTHESIS)
        elif self.synthesis == "synplify":
            if in_sweeping_flow:
                return
            return self._run_synplify_flow()

    def _run_synplify_flow(self):
        self.say_info("* Running Synplify Flow ...")
        tcl_file = "{}flow_synplify.tcl".format(self.solo)
        xTools.write_file(tcl_file, CONSTANTS.FMT_TCL_SYNPLIFY.format(**self.kwargs))
        cmd_line = "%s/synplify_pro.exe -batch -log syn_flow.log -tcl %s" % (self.kwargs["synplify_path"], tcl_file)
        self.say_info("Running Command: {} [{}]".format(cmd_line, xTools.get_shanghai_time()))
        sts, text = xTools.get_status_output(cmd_line)
        return sts

    def prepare_impl_lines(self):
        if self.run_impl or self.run_bitstream:
            self.kwargs["impl_to_bitstream"] = "-to_step write_bitstream" if self.run_bitstream else ""
            self.tcl_lines.append(CONSTANTS.FMT_LAUNCH_IMPLEMENTATION.format(**self.kwargs))

    def prepare_simulation_lines(self):
        if not self.run_simulation:
            return
        if not self.use_vivado_simulator:
            self.compile_simulation_library_and_update_kwargs()
        self.tcl_lines.append(CONSTANTS.FMT_SET_TARGET_SIMULATOR.format(**self.kwargs))
        if not self.use_vivado_simulator:
            self.tcl_lines.append(CONSTANTS.FMT_SET_SIMULATOR_LIBRARY.format(**self.kwargs))
        self.tcl_lines.append(CONSTANTS.STR_SET_GEN_SIM_SCRIPTS_ONLY)
        sim_time = self.section_sim_dict.get("sim_time")
        if sim_time:
            sim_time = re.sub(r"\s+", "", sim_time)
            self.kwargs["sim_time"] = sim_time
            self.tcl_lines.append(CONSTANTS.FMT_SET_SIMULATION_RUNTIME.format(**self.kwargs))
        if self.use_vivado_simulator:
            x = ""
        else:
            x = "-install_path {simulator_path} -gcc_install_path {gcc_path}".format(**self.kwargs)
        self.kwargs["simulator_and_gcc"] = x
        sim_1_path = "{}/{}.sim/sim_1".format(os.path.dirname(self.xpr_file), self.kwargs["project_name"])
        for k, v in list(self.vivado_simulation_settings.items()):
            if k in self.run_simulation:
                _res_path = "{}/{}/{}".format(sim_1_path, v.get("exec_path"), self.kwargs["simulator_lower"])
                self.kwargs["simulation_type"] = k
                self.kwargs["sim_mode_and_type"] = v.get("sim_mode_and_type")
                self.kwargs["simulation_results_directory"] = _res_path
                self.tcl_lines.append(CONSTANTS.FMT_LAUNCH_SIMULATION.format(**self.kwargs))

    def run_vivado_tcl(self, flow_name, tcl_lines=None):
        if not (tcl_lines or self.tcl_lines):
            return
        if not tcl_lines:
            tcl_lines = self.tcl_lines[:]
            tcl_lines.insert(0, CONSTANTS.FMT_OPEN_PROJECT.format(**self.kwargs))
            tcl_lines.insert(1, "update_compile_order -fileset sources_1")
            x_lines = self.kwargs.get("more_tcl")
            if x_lines:
                x_lines = x_lines.splitlines()
                x_lines.reverse()
                for foo in x_lines:
                    tcl_lines.insert(1, foo)
            tcl_lines.append(CONSTANTS.STR_CLOSE_PROJECT)
        new_flow_name = self.solo + flow_name
        tcl_file, log_file, time_file = [new_flow_name + foo for foo in (".tcl", ".log", ".time")]
        with open(tcl_file, "w") as wob:
            for line in tcl_lines:
                line = xTools.win2unix(line)
                print(line, file=wob)
        cmd_line = "{}/bin/vivado.bat -mode batch -source {}".format(self.kwargs.get("vivado_path"), tcl_file)
        sts = xTools.run_command(cmd_line, log_file, time_file)
        return sts

    def get_clocks(self):
        rpt_root = "{point_runs}/impl_1".format(**self.kwargs)
        rpt_pattern = "timing_summary_routed.rpt"
        rpt_files = xTools.get_files(rpt_root, rpt_pattern, ".no_use")
        if rpt_files:
            self.port_clocks = vivadoUtil.get_clocks_from_vivado_timing_summary_routed_rpt_file(rpt_files[0])
        if not self.port_clocks:
            self.say_warning("Warning. Not found any port clocks")
            return 1

    def get_clock_frequency_slack(self):
        rpt_root = "{point_runs}/impl_1".format(**self.kwargs)
        rpt_pattern = "timing_summary_routed.rpt"
        rpt_files = xTools.get_files(rpt_root, rpt_pattern, ".no_use")
        if rpt_files:
            scanner = vivadoBasicScan.ScanVivadoTimingReport(rpt_files[0])
            scanner.process()
            self.c_f_s = scanner.frequency_dict
        else:
            self.say_warning("Warning. Not found any clock values")
            return 1

    def add_fmax_xdc_file(self, fmax_value):
        self.kwargs["fmax_value"] = fmax_value
        xdc_file = "{point_srcs}/target_fmax_{fmax_value}.xdc".format(**self.kwargs)
        with open(xdc_file, "w") as wob:
            for clk in self.port_clocks:
                whole_period = 1000 / fmax_value
                half_period = whole_period / 2
                t_kw = dict(period="{:.3f}".format(whole_period),
                            half_period="{:.3f}".format(half_period),
                            clk_name=clk)
                print(CONSTANTS.FMT_XDC.format(**t_kw), file=wob)
            if len(self.port_clocks) > 1:
                print(vivadoUtil.set_clock_group(self.port_clocks), file=wob)
        self.tcl_lines.append(CONSTANTS.FMT_ADD_XDC.format(xdc_file=xdc_file))

    def add_iteration_xdc_file(self, itr_number):
        self.kwargs["itr_number"] = "{:02d}".format(itr_number)
        xdc_file = "{point_srcs}/target_iteration_{itr_number}.xdc".format(**self.kwargs)
        with open(xdc_file, "w") as wob:
            for clk_name, c_f_s in list(self.c_f_s.items()):
                _fmax, _slack = c_f_s.get("fmax"), c_f_s.get("slack")
                if _slack > 0:
                    _fmax = (1 + self.fmax_iteration[0] / 100) * _fmax
                else:
                    _fmax = (1 + self.fmax_iteration[0] / 200) * _fmax
                whole_period = 1000 / _fmax
                half_period = whole_period / 2
                t_kw = dict(period="{:.3f}".format(whole_period),
                            half_period="{:.3f}".format(half_period),
                            clk_name=clk_name)
                print("# {} {}".format(clk_name, c_f_s), file=wob)
                print(CONSTANTS.FMT_XDC.format(**t_kw), file=wob)
            if len(self.c_f_s) > 1:
                print(vivadoUtil.set_clock_group(list(self.c_f_s.keys())), file=wob)
        self.tcl_lines.append(CONSTANTS.FMT_ADD_XDC.format(xdc_file=xdc_file))

    def move_and_clean_working_directory(self, target_folder):
        my_target = "{}/{}".format(self.kwargs["project_root"], target_folder)
        if os.path.isdir(my_target):
            shutil.rmtree(my_target)
        if not os.path.isdir(my_target):
            os.mkdir(my_target)
        for _src_path in (self.kwargs["point_runs"], self.kwargs["point_srcs"]):
            shutil.copytree(_src_path, os.path.join(my_target, os.path.basename(_src_path)))

    def compile_simulation_library_and_update_kwargs(self):
        self.say_info("* Prepare or check {} Simulation Lib [{}]...".format(self.simulator, xTools.get_shanghai_time()))
        ovi_root = os.path.join(self.default_conf_path, "lib_{}".format(self.simulator))
        res = xTools.wrap_md(ovi_root, "LocalSimLib")
        if res:
            self.say_error(res)
            return 1
        ovi_path = self.kwargs["ovi_lib"] = os.path.join(ovi_root, "ovi_kintex7")

        def compile_lib():
            if os.path.isdir(ovi_path):
                return
            one_line = CONSTANTS.FMT_COMPILE_SIM_LIB.format(**self.kwargs)
            return self.run_vivado_tcl("compile_{}_lib".format(self.simulator), tcl_lines=[one_line])

        my_recovery = xTools.ChangeDir(ovi_root)
        lock_file = "__compiling_{}_library.lock".format(self.simulator)
        sts = xTools.safe_run_function(compile_lib, func_lock_file=lock_file, timeout=3600)
        my_recovery.comeback()
        return sts

    def basic_scan_process(self):
        if not (self.scan_report or self.scan_report_only):
            return
        self.say_info("Scanning reports ...")
        target_folders = glob.glob(os.path.join(self.project_root, "target_*"))
        if not target_folders:
            target_folders = [self.project_root]
        yaml_file = "{}/vivado/general.yaml".format(self.default_conf_path)
        self.yaml_dict = vivadoBasicScan.yaml2dict(yaml_file)
        result_list = [self.scan_one_point(foo) for foo in target_folders]
        # find the max fmax/geoFmax
        real_title = "fmax" if self.fmax_sort=="max" else "geoFmax"
        final_report_data = dict()
        for foo in result_list:
            if not final_report_data:
                final_report_data = foo
            else:
                previous_fmax = final_report_data.get("Timing", dict()).get(real_title, 0)
                now_fmax = foo.get("Timing", dict()).get(real_title, 0)
                previous_fmax = previous_fmax if previous_fmax else 0
                now_fmax = now_fmax if now_fmax else 0
                if float(now_fmax) > float(previous_fmax):
                    final_report_data = foo
        self.say_info(json.dumps(final_report_data))
        with open(os.path.join(self.working_path, "resource_utilization.data"), "w") as ob:
            print(json.dumps(final_report_data, indent=2), file=ob)

    def scan_one_point(self, point_directory):
        impl_path = os.path.join(point_directory, self.project_name + ".runs", "impl_1")
        sim_path = os.path.join(point_directory, self.project_name + ".sim", "sim_1")
        scan_files = dict(file_xpr=self.xpr_file)
        if os.path.join(impl_path):
            x = xTools.get_files(impl_path, "", "timing_summary_routed.rpt", get_single=True)
            y = xTools.get_files(impl_path, "", "utilization_placed.rpt", get_single=True)
            z = xTools.get_files(impl_path, "", "runme.log", get_single=True)
            scan_files["file_timing_summary_routed_rpt"] = x
            scan_files["file_utilization_placed_rpt"] = y
            scan_files["file_impl_runme_log"] = z
        if os.path.isdir(sim_path):
            for _type, _detail in list(CONSTANTS.VIVADO_SIMULATION_SETTINGS.items()):
                path_list = (sim_path, _detail.get("exec_path"), self.kwargs["simulator_lower"], _type + ".elapsed")
                etime_file = os.path.join(*path_list)
                if os.path.isfile(etime_file):
                    scan_files["file_{}_elapsed".format(_type)] = etime_file
        one_point_data = list()
        for file_type, file_name in list(scan_files.items()):
            file_data_list = vivadoBasicScan.scan_file(file_name, self.yaml_dict.get(file_type), self.fmax_sort)
            one_point_data.extend(file_data_list)
        final_data = dict()
        for foo in one_point_data:
            group_name = foo.get("group", "Default")
            final_data.setdefault(group_name, dict())
            for title, value in list(foo.items()):
                if title == "group":
                    continue
                if title.endswith("_time"):
                    value = vivadoUtil.get_seconds(value)
                final_data[group_name][title] = value
        return final_data
