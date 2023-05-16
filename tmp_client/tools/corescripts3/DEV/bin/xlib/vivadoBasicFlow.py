#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 9:00 AM 11/7/2022
  file: vivadoBasicFlow.py
  author: Shawn Yan
Description:

"""
import os
import getpass
from .localCapuchin import xTools
from .vivadoOptions import FlowOptions


class BasicFlow(FlowOptions):
    def __init__(self, vendor):
        super(BasicFlow, self).__init__(vendor)

    def process(self):
        if self.parse_command_options():
            return 1
        timer = xTools.ElapsedTime()
        try:
            sts = self.inner_process()
        except:
            self.say_traceback()
            sts = 201
        self.say_info("Total {}".format(timer))
        return sts

    def inner_process(self):
        sts = 0
        _prepare_list = [self.public_head_announce,
                         self.public_set_environment,
                         self.public_parse_case_options,
                         self.basic_very_first_process]
        _flow_list = [self.basic_flow_processes, self.basic_very_end_process]
        more_list = list() if self.scan_report_only else _flow_list
        function_list = _prepare_list + more_list
        for func in function_list:
            sts = func()
            if sts:
                break
        _other_list = [self.basic_scan_process, self.public_check_process]
        for func in _other_list:
            func()
        return sts

    def public_head_announce(self):
        pc_name, os_name = xTools.get_pc_os_name()
        kwargs = dict(v_c=self.vendor.capitalize(), d_p=self.design_path,
                      o_n=os_name, p_n=pc_name, p_u=getpass.getuser(), t_s=xTools.get_shanghai_time())
        lines = list()
        lines.append("* -----------------------------")
        lines.append("* Vendor: {v_c}")
        lines.append("* Design: {d_p}")
        lines.append("* Platform: {o_n}, {p_n} ({p_u})")
        lines.append("* Time: {t_s}")
        lines.append("* -----------------------------")
        self.say_info("\n".join(lines).format(**kwargs))
        return 0

    def public_set_environment(self):
        default_ini_file = os.path.join(self.default_conf_path, "vivado", "default.ini")
        sts, options = xTools.get_options(default_ini_file, key_is_lower=False)
        if sts:
            self.say_error(options)
            return sts
        section_environment = options.get("environment")
        if section_environment:
            lif_key = "LM_LICENSE_FILE"
            lif = section_environment.get(lif_key)
            if lif:
                lif_list = xTools.comma_split(lif)
                os.environ[lif_key] = os.pathsep.join(lif_list)

    def public_parse_case_options(self):
        info_files = xTools.get_files(self.design_path, self.info, ".info")
        if len(info_files) != 1:
            self.say_error("Error. Found {} info files in {}".format(len(info_files), self.design_path))
            return 1
        sts, self.info_dict = xTools.get_options(info_files, key_is_lower=False)
        self.info_file = info_files[0]
        if sts:
            self.say_error(self.info_dict)
            return 1
        if not self.info_dict:
            self.say_error("Error. No section/value in {}".format(info_files[0]))
            return 1

    def basic_very_first_process(self):
        return

    def basic_flow_processes(self):
        return

    def basic_very_end_process(self):
        return

    def basic_scan_process(self):
        return

    def public_check_process(self):
        return

