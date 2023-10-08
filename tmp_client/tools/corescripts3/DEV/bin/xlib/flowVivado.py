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
import sys
import glob
import copy
import shutil

from . import vivadoBasicFlow
from . import vivadoBasicScan
from . import CONSTANTS
from . import vivadoUtil
from . import xTools as originalTools
from .localCapuchin import xTools


class FlowVivado(vivadoBasicFlow.BasicFlow):
    def __init__(self):
        super(FlowVivado, self).__init__("vivado")
        self.p_clock_custom_hdl = re.compile(r"-name([^-]+)-.+\[get_[^s]+s(.+)\]")

    def basic_very_first_process(self):
        """try to get all possible key-value dictionary
        """
        self.kwargs = dict()
        self.section_qa_dict = self.info_dict.get("qa", dict())
        self.section_sim_dict = self.info_dict.get("sim", dict())
        if not self.ignore_clock:
            self.ignore_clock = originalTools.set_as_list(self.section_qa_dict.get("ignore_clock"))
        if not self.care_clock:
            self.care_clock = originalTools.set_as_list(self.section_qa_dict.get("care_clock"))
        self.xpr_file = self.section_qa_dict.get("xpr_file")
        if not self.xpr_file:
            self.say_error("Error. Not specify xpr file in {}".format(self.info_file))
            return 1
        self.kwargs["xpr_file"] = self.xpr_file
        if self.run_synthesis or self.run_impl or self.run_simulation or self.run_bitstream or self.run_power \
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
            self.get_clock_custom_hdl_dict_and_original_xdc_lines()
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
            self.get_clock_custom_hdl_dict_and_original_xdc_lines()
            self.move_and_clean_working_directory("target_iteration_00")
            self.run_impl = self.run_synthesis = True
            if not (self.clock_custom_hdc_dict or self.original_xdc_lines):
                print("Error. Cannot find the original xdc file")
                return
            good_clock_frequency_slack, trial_times = None, 0
            for iteration_number in range(1, int(self.fmax_iteration[-1]+1)):
                if trial_times > 2:
                    break
                self.say_info("* Running Fmax Iteration Number: {}".format(iteration_number))
                self.get_clock_frequency_slack()
                if not self.c_f_s:
                    if not good_clock_frequency_slack:
                        print("Error. Not found any data in timing report")
                        return
                    trial_times += 1
                else:
                    good_clock_frequency_slack = copy.copy(self.c_f_s)
                    trial_times = 0
                vivadoUtil.cleanup_vivado_xdc(self.xpr_file)
                target_folder = "target_iteration_{:02d}".format(iteration_number)
                self.tcl_lines = list()
                self.add_iteration_xdc_file(iteration_number, good_clock_frequency_slack, trial_times)
                self.prepare_synthesis_lines(in_sweeping_flow=True)
                self.prepare_impl_lines()
                self.run_vivado_tcl(f"run_{target_folder}")
                self.move_and_clean_working_directory(target_folder)
        else:
            self.prepare_synthesis_lines()
            self.prepare_impl_lines()
            self.prepare_simulation_lines()
            if self.run_power:
                self.add_power_settings_to_xdc_file()
            self.run_vivado_tcl("run_test_flow")

    def add_power_settings_to_xdc_file(self):
        p_xdc = re.compile(r'<File Path="(.+\.xdc)">')
        p_dollar = re.compile(r"^\$\w+/")
        base_dir = os.path.dirname(self.xpr_file)
        xdc_files = list()
        with open(self.xpr_file) as ob:
            for line in ob:
                m_xdc = p_xdc.search(line)
                if m_xdc:
                    xdc_files.append(m_xdc.group(1))
        for xdc_file in xdc_files:
            xdc_file = p_dollar.sub(base_dir + "/", xdc_file)
            if os.path.isfile(xdc_file):
                xdc_file = os.path.abspath(xdc_file)
                xdc_lines = open(xdc_file).readlines()

                with open(xdc_file, "w", newline="\n") as xdc_ob:
                    for line in xdc_lines:
                        line = line.rstrip()
                        simple_line = line.strip()
                        if simple_line.startswith("set_operating") or simple_line.startswith("set_switching"):
                            continue
                        print(line, file=xdc_ob)
                    print('set_operating_conditions -process {}'.format(self.pwr_type), file=xdc_ob)
                    print('set_operating_conditions -ambient_temp {}'.format(self.pwr_at), file=xdc_ob)
                    print('set_operating_conditions -thetaja {}'.format(self.pwr_etga), file=xdc_ob)
                    print('set_switching_activity -default_toggle_rate {}'.format(self.pwr_af), file=xdc_ob)

    def get_clock_custom_hdl_dict_and_original_xdc_lines(self):
        self.clock_custom_hdc_dict = dict()
        self.original_xdc_lines = list()
        runme_log_files = glob.glob(os.path.join(self.kwargs["point_runs"], "*", "runme.log"))
        if not runme_log_files:
            return
        p_xdc_file = re.compile(r"Parsing\s+XDC\s+File\s+\[(\S+)\]$")
        xdc_file = ""
        for one_log in runme_log_files:
            if xdc_file:
                break
            with open(one_log) as ob:
                for line in ob:
                    line = line.strip()
                    m_xdc_file = p_xdc_file.search(line)
                    if m_xdc_file:
                        xdc_file = m_xdc_file.group(1)
                        break
        if not xdc_file:
            return
        with open(xdc_file) as xdc_ob:
            for line in xdc_ob:
                short_line = line.strip()
                line = line.rstrip()
                if short_line.startswith("#"):
                    continue
                self.original_xdc_lines.append(line)
                m_clock_custom_hdl = self.p_clock_custom_hdl.search(short_line)
                if m_clock_custom_hdl:
                    self.clock_custom_hdc_dict[m_clock_custom_hdl.group(1)] = m_clock_custom_hdl.group(2)

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
        if self.run_impl or self.run_bitstream or self.run_power:
            self.kwargs["impl_to_bitstream"] = "-to_step write_bitstream" if self.run_bitstream else ""
            self.tcl_lines.append(CONSTANTS.FMT_LAUNCH_IMPLEMENTATION.format(**self.kwargs))
            if self.run_power:
                self.tcl_lines.append('open_run impl_1')
                self.tcl_lines.append('report_power -file {./power_result.txt}')

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
                if self.fixed_clock:
                    clk_fixed_fre = self.fixed_clock.get(clk)
                    if clk_fixed_fre:
                        whole_period = 1000 / clk_fixed_fre
                half_period = whole_period / 2
                t_kw = dict(period="{:.3f}".format(whole_period),
                            half_period="{:.3f}".format(half_period),
                            clk_name=clk)
                print(CONSTANTS.FMT_XDC.format(**t_kw), file=wob)
            if len(self.port_clocks) > 1:
                print(vivadoUtil.set_clock_group(self.port_clocks), file=wob)
        self.tcl_lines.append(CONSTANTS.FMT_ADD_XDC.format(xdc_file=xdc_file))

    def add_iteration_xdc_file(self, itr_number, good_clock_frequency_slack, trial_times):
        """
        based on original xdc lines
        :param itr_number:
        :param good_clock_frequency_slack:
        :param trial_times:
        :return:
        """
        self.kwargs["itr_number"] = "{:02d}".format(itr_number)
        xdc_file = "{point_srcs}/target_iteration_{itr_number}.xdc".format(**self.kwargs)
        with open(xdc_file, "w", newline="\n") as wob:
            for line in self.original_xdc_lines:
                short_line = re.sub(r"\s+", "", line)
                m_clock_custom_hdl = self.p_clock_custom_hdl.search(short_line)
                if m_clock_custom_hdl:
                    custom_clock, hdl_clock = m_clock_custom_hdl.group(1), m_clock_custom_hdl.group(2)
                    if custom_clock not in good_clock_frequency_slack:
                        print(line, file=wob)  # use raw line
                    else:
                        final_fmax = 0
                        if self.fixed_clock:
                            fixed_value = self.fixed_clock.get(custom_clock, self.fixed_clock.get(hdl_clock))
                            if fixed_value:
                                final_fmax = fixed_value
                        if not final_fmax:
                            last_timing_data = good_clock_frequency_slack.get(custom_clock)
                            if last_timing_data:
                                last_fmax = last_timing_data.get("fmax")
                                last_slack = last_timing_data.get("slack")
                                if not trial_times:
                                    now_change_ratio = self.fmax_iteration[0]
                                else:
                                    now_change_ratio = (self.fmax_iteration[0] / 2) ** trial_times
                                print("# {}, Ratio: {}".format(last_timing_data, now_change_ratio), file=wob)
                                if last_slack > 0:
                                    final_fmax = (1 + now_change_ratio / 100) * last_fmax
                                else:
                                    final_fmax = (1 + now_change_ratio / 200) * last_fmax
                        if not final_fmax:
                            print(line, file=wob)
                        else:
                            whole_period = 1000 / final_fmax
                            half_period = whole_period / 2
                            line = re.sub(r"-period \S+", "-period {:.3f}".format(whole_period), line)
                            line = re.sub(r"-waveform\s+\{.+\}", "-waveform {0.000 %.3f}" % half_period, line)
                            print(line, file=wob)
                else:
                    print(line, file=wob)
        self.tcl_lines.append(CONSTANTS.FMT_ADD_XDC.format(xdc_file=xdc_file))

    def move_and_clean_working_directory(self, target_folder):
        my_target = "{}/{}".format(self.kwargs["project_root"], target_folder)
        if os.path.isdir(my_target):
            shutil.rmtree(my_target)
        if not os.path.isdir(my_target):
            os.mkdir(my_target)
        # for _src_path in (self.kwargs["point_runs"], self.kwargs["point_srcs"]):
        #    shutil.copytree(_src_path, os.path.join(my_target, os.path.basename(_src_path)))
        # when a lot of files under my_test.srcs folder, flow will be crashed!
        src_runs = self.kwargs["point_runs"]
        dst_runs = os.path.join(my_target, os.path.basename(src_runs))
        shutil.copytree(src_runs, dst_runs)

        src_srcs = self.kwargs["point_srcs"]
        dst_srcs = os.path.join(my_target, os.path.basename(src_srcs))
        if not os.path.isdir(src_srcs):
            return
        if not os.path.isdir(dst_srcs):
            os.makedirs(dst_srcs)
        for foo in os.listdir(src_srcs):
            src_foo = os.path.join(src_srcs, foo)
            dst_foo = os.path.join(dst_srcs, foo)
            if os.path.isfile(src_foo):
                shutil.copy2(src_foo, dst_foo)

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
        scan_py = os.path.join(os.path.dirname(__file__), '..', '..', 'tools', 'scanReport', "new_scan.py")
        scan_py = os.path.abspath(scan_py)
        args = "--top-dir {} --design {} --vendor Vivado  --info {}".format(os.path.dirname(self.design_path), os.path.basename(self.design_path),
                                                                            os.path.basename(self.info_file))
        if self.ignore_clock:
            args += " --ignore-clock {}".format(" ".join(self.ignore_clock))
        if self.care_clock:
            args += " --care-clock {}".format(" ".join(self.care_clock))
        cmd_line = "{} {} {}".format(sys.executable, scan_py, args)
        cmd_line = xTools.win2unix(cmd_line, 0)
        originalTools.say_it(" Launching %s" % cmd_line)
        sts, text = xTools.get_status_output(cmd_line)
        originalTools.say_raw(text)
