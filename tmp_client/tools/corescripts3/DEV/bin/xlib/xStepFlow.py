#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  Date: 9:58 2023/8/9
  File: xStepFlow.py
  Author: Shawn Yan
Description:

"""
import os
import re
import glob
from . import xTools


def set_par_threads(raw_par_command, thread_number_int):
    cmd_list = raw_par_command.split()
    new_cmd_list = list()
    for i, foo in enumerate(cmd_list):
        if i:  # not the first one
            if cmd_list[i - 1] == "-exp":
                foo_list = re.split(":", foo)
                new_foo_list = list()
                for bar in foo_list:
                    if "maxThreads" in bar:
                        continue
                    new_foo_list.append(bar)
                if thread_number_int >= 0:
                    new_foo_list.append("maxThreads={}".format(thread_number_int))
                foo = ":".join(new_foo_list)
        new_cmd_list.append(foo)
    return " ".join(new_cmd_list)


class StepFlow(object):
    def __init__(self, step_list, step_times, par_threads):
        self.step_list = step_list
        self.step_times = step_times
        self.par_threads = par_threads
        self.p_command_line = re.compile("Command Line:(.+)", re.I)
        mrp_files = glob.glob("*/*.mrp")
        par_files = glob.glob("*/*.par")
        p_syn_udb = re.compile("_syn.udb$")
        p_new_syn_udb = re.compile("^(?!(lattice_workdir)).+_syn.udb$")
        p_map_udb = re.compile("_map.udb$")
        p_par_udb = re.compile(r"((?!(syn|map|rtl)).{3})(\.udb)$")
        self.flow_dict = dict(
            map=dict(cmd_file=mrp_files, p_raw_in=p_syn_udb, p_raw_out=p_map_udb, p_new_in=p_new_syn_udb),
            placer=dict(cmd_file=par_files, p_raw_in=p_map_udb, p_raw_out=p_par_udb, p_new_in=p_map_udb),
            router=dict(cmd_file=par_files, p_raw_in=p_map_udb, p_raw_out=p_par_udb, p_new_in=p_par_udb),
            par=dict(cmd_file=par_files, p_raw_in=p_map_udb, p_raw_out=p_par_udb, p_new_in=p_map_udb))

    def process(self):
        for step_name in self.step_list:
            real_command = self.get_real_command(step_name)
            if not real_command:
                xTools.say_it("Error. Not found step {} command".format(step_name))
                continue
            if step_name == "par" and self.par_threads and len(self.par_threads) > 1:
                self.run_step_par_with_threads(real_command)
                continue
            for time_number in range(self.step_times):
                show_number = "_{}".format(time_number) if self.step_times > 1 else ""
                working_dir = "step_{}{}".format(step_name, show_number)
                if step_name == "par" and self.par_threads:  # single thread number
                    real_command = set_par_threads(real_command, self.par_threads[0])
                    working_dir += "T{}".format(self.par_threads[0])
                xTools.wrap_md(working_dir, "step folder")
                os.chdir(working_dir)
                xTools.run_command(real_command, "run_{}.log".format(step_name), "run_{}.time".format(step_name))
                udb2sv_cmd = "udb2sv -w -view physical step_{0}.udb -o test_udb2sv_step_{0}{1}.v".format(step_name, show_number)
                xTools.run_command(udb2sv_cmd, "run_{}.log".format(step_name), "run_{}.time".format(step_name))
                os.chdir("..")

    def run_step_par_with_threads(self, raw_par_command):
        for thread_number_int in self.par_threads:
            if thread_number_int < 0:
                thread_number_str = "NA"
            else:
                thread_number_str = str(thread_number_int)
            working_dir = "step_par_threads{}".format(thread_number_str)
            xTools.wrap_md(working_dir, "step folder")
            os.chdir(working_dir)
            new_par_with_threads = set_par_threads(raw_par_command, thread_number_int)
            xTools.run_command(new_par_with_threads, "run_par.log", "run_par.time")
            udb2sv_cmd = "udb2sv -w -view physical step_par.udb -o test_udb2sv_{}.v".format(working_dir)
            xTools.run_command(udb2sv_cmd, "run_par.log", "run_par.time")
            os.chdir("..")

    @staticmethod
    def _get_new_line(raw_line):
        raw_line = raw_line.strip()
        raw_line = re.sub(r"\\", " ", raw_line)
        if re.search(r"\s+-\S+$", raw_line):
            raw_line += " "
        if re.search(r"^-\S+", raw_line):
            raw_line = " " + raw_line
        return raw_line

    def get_real_command(self, step_name):
        udb_files = glob.glob("*/*.udb")
        step_dict = self.flow_dict.get(step_name)
        cmd_file = step_dict.get("cmd_file")
        p_raw_in, p_raw_out, p_new_in = [step_dict.get(item) for item in ("p_raw_in", "p_raw_out", "p_new_in")]
        if not cmd_file:
            return ""
        start_command_line = False
        raw_command_lines = list()
        with open(cmd_file[0]) as ob:
            for line in ob:
                line = line.strip()
                if not start_command_line:
                    start_command_line = self.p_command_line.search(line)
                    if start_command_line:
                        raw_command_lines.append(self._get_new_line(start_command_line.group(1)))
                else:
                    if not line:
                        break
                    raw_command_lines.append(self._get_new_line(line))
        cmd_string = "".join(raw_command_lines)
        cmd_string = cmd_string.strip()
        cmd_list = cmd_string.split()
        new_cmd_list = list()
        for foo in cmd_list:
            if foo.endswith(".pdc"):
                foo = self.get_real_pdc_file(foo)
            elif foo.endswith(".mrp"):
                foo = os.path.basename(foo)
            elif p_raw_in.search(foo):
                for bar in udb_files:
                    if p_new_in.search(os.path.basename(bar)):
                        foo = xTools.win2unix(bar)
                        break
            elif p_raw_out.search(foo):
                foo = "step_{}.udb".format(step_name)
            new_cmd_list.append(foo)
        not_run_router, not_run_placer = "-r", "-p"
        for arg in (not_run_placer, not_run_router):
            if arg in new_cmd_list:
                new_cmd_list.remove(arg)
        if step_name == "placer":
            new_cmd_list.insert(1, not_run_router)
        elif step_name == "router":
            new_cmd_list.insert(1, not_run_placer)
        return " ".join(new_cmd_list)

    @staticmethod
    def get_real_pdc_file(pdc_string):
        tag_folder = os.getcwd()
        real_design_path = os.path.dirname(tag_folder)
        design_name = os.path.basename(real_design_path)
        pdc_string = xTools.win2unix(pdc_string, use_abs=0)
        new_pdc_string = re.sub(".+/{}/".format(design_name), xTools.win2unix(real_design_path) + "/", pdc_string)
        new_pdc_string = xTools.win2unix(new_pdc_string, use_abs=0)
        return new_pdc_string
