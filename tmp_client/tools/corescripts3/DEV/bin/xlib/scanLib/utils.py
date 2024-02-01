#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 1:27 PM 3/20/2023
  file: utils.py
  author: Shawn Yan
Description:

"""
import os
import re
import glob
from . import xml2dict


class YieldLines(object):
    def __init__(self):
        self.report_file = ""

    def open_report(self):
        try:
            self.rob = open(self.report_file)
        except IOError:
            # print("Warning. Not found report file: {}".format(self.report_file))
            self.rob = None

    def close_report(self):
        if self.rob:
            self.rob.close()

    def yield_lines(self, report_file):
        self.report_file = report_file
        self.open_report()
        if self.rob:
            for i, line in enumerate(self.rob):
                line = line.strip()
                yield line
        self.close_report()

    def yield_head_lines(self, report_file, head=100):
        self.report_file = report_file
        self.open_report()
        if self.rob:
            for i, line in enumerate(self.rob):
                if i >= head:
                    break
                line = line.strip()
                yield line
        self.close_report()

    def yield_tail_lines(self, report_file, tail=100):
        self.report_file = report_file
        self.open_report()
        if self.rob:
            line_count = 1
            for line_count, line in enumerate(self.rob):
                pass
            start_line = line_count - tail
            self.close_report()
            self.open_report()
            for i, line in enumerate(self.rob):
                if i <= start_line:
                    continue
                line = line.strip()
                yield line
        self.close_report()

    def yield_hook_lines(self, report_file, hook_dict):
        hook_before = hook_dict.get("before", 0)
        hook_after = hook_dict.get("after", 0)
        hook_pattern = hook_dict.get("pattern")
        self.report_file = report_file
        self.open_report()
        if self.rob:
            hook_index = 0
            for idx, line in enumerate(self.rob):
                if hook_pattern.search(line):
                    hook_index = idx
            min_index = hook_index - hook_before
            max_index = hook_index + hook_after
            self.close_report()
            self.open_report()
            for idx, line in enumerate(self.rob):
                if idx < min_index:
                    continue
                elif idx > max_index:
                    break
                line = line.strip()
                yield line
        self.close_report()


def get_rd_active_data(rd_project_file):
    with open(rd_project_file) as ob:
        project_data = xml2dict.parse(ob)
    for dp_name in ("BaliProject", "RadiantProject"):
        x_project_dict = project_data.get(dp_name)
        if x_project_dict:
            break
    else:
        return dict(), dict()
    _di = x_project_dict.get("@default_implementation", "NONE")
    raw_impl = x_project_dict.get("Implementation", dict())
    raw_impl = [raw_impl] if isinstance(raw_impl, dict) else raw_impl
    for foo in raw_impl:
        if foo.get("@title") == _di:
            return x_project_dict, foo
    return x_project_dict, dict()


def get_exist_file(file_basename, folder1, folder2):
    for perhaps_folder in (folder1, folder2):
        perhaps_file = os.path.join(perhaps_folder, file_basename)
        if os.path.isfile(perhaps_file):
            return perhaps_file


class FindFiles(object):
    def __init__(self, abs_tag, vendor_name):
        self.report_files_dict = dict()
        self.abs_tag = abs_tag
        self.vendor_name = vendor_name

    def get_report_files_dict(self):
        return self.report_files_dict

    def process(self):
        self.get_project_dict()
        self.append_radiant_diamond_files()

    def get_project_dict(self):
        self.x_project, self.y_impl = dict(), dict()
        prj_file_ext_dict = dict(Radiant="*.rdf", Diamond="*.ldf", Vivado="*.xpr")
        project_files = glob.glob(os.path.join(self.abs_tag, prj_file_ext_dict.get(self.vendor_name)))
        if project_files:
            self.project_file = project_files[0]
            self.x_project, self.y_impl = get_rd_active_data(self.project_file)

    def append_radiant_diamond_files(self):
        if self.vendor_name not in ("Radiant", "Diamond"):
            return
        target_folders = glob.glob(os.path.join(self.abs_tag, "Target_*"))
        if not target_folders:
            target_folders = [self.abs_tag]
        if target_folders:
            for foo in target_folders:
                pd2 = os.path.dirname(self.project_file)
                pushbutton_or_target_name = os.path.basename(foo)
                if pushbutton_or_target_name == os.path.basename(self.abs_tag):
                    pushbutton_or_target_name = "pushbutton"
                this_list = list()
                # project file
                prj_file = get_exist_file(os.path.basename(self.project_file), foo, pd2)
                if prj_file:
                    this_list.append(prj_file)
                # result files
                _filename_prj = self.x_project.get("@title")
                _filename_impl = self.y_impl.get("@dir")
                _filename_only = "{}_{}".format(_filename_prj, _filename_impl)
                synthesis_name = self.y_impl.get("@synthesis")
                if synthesis_name == "synplify":
                    for fext in (".srr", ".vm"):
                        one_file = get_exist_file("{}/{}{}".format(_filename_impl, _filename_only, fext), foo, pd2)
                        if one_file:
                            this_list.append(one_file)
                else:  # LSE
                    one_file = get_exist_file("{}/synthesis.log".format(_filename_impl), foo, pd2)
                    if one_file:
                        this_list.append(one_file)
                for fext in (".mrp", ".par", ".twr", ".pad"):
                    one_file = get_exist_file('{}/{}{}'.format(_filename_impl, _filename_only, fext), foo, "NOT-FOLDER")
                    if one_file:
                        this_list.append(one_file)
                for udb2sv_file in ("test_udb2sv_map.v", "test_udb2sv_par.v"):
                    one_file = get_exist_file('{}/{}'.format(_filename_impl, udb2sv_file), foo, "NOT_FOLDER")
                    if one_file:
                        this_list.append(one_file)
                self.report_files_dict[pushbutton_or_target_name] = this_list


class ScanRadiantTimingReport(YieldLines):
    def __init__(self):
        super(ScanRadiantTimingReport, self).__init__()
        self.twr_data = dict()
        self.p_check_start_message_list = (re.compile(r"\d+\s+Setup at Speed Grade.+at\s+([-\d]+)\s+Degrees"),
                                           re.compile(r"([.\d]+)\s+(Setup)\s+Summary\s+Report"))
        self.p_yes = re.compile("^=+$")
        # report_type is 1
        self.p_sep = re.compile(r"\s*\|\s*")
        self.set_of_titles = {"SDC Constraint", "Target", "Slack", "Levels", "Frequency"}
        self.p_row = re.compile(r"^[-|\s]+$")
        # report_type is 2
        self.p_constraint = re.compile(r"(create(_|_generated_)clock\s+-name.+)")
        #             Target |           5.398 ns |        185.254 MHz
        # Actual (all paths) |           5.154 ns |        194.024 MHz
        self.p_target = re.compile(r"Target\s+\|\s+.+\s+([\d.]+)\s+MHz")
        self.p_actual = re.compile(r"Actual\s+\Wall\s+paths\W\s+.+\s+([\d.]+)\s+MHz")

    def get_twr_data(self):
        return self.twr_data

    def process(self, twr_file):
        self.twr_data = dict()
        if not os.path.isfile(twr_file):
            print("Error. Not found .twr file {}".format(twr_file))
            return
        start_message_line = self.get_start_line(twr_file)
        raw_twr_data = self.get_raw_twr_data(twr_file, start_message_line, 1)
        if not raw_twr_data:
            raw_twr_data = self.get_raw_twr_data(twr_file, start_message_line, 2)
        if raw_twr_data:
            self.create_twr_data(raw_twr_data)

    def get_start_line(self, twr_file):
        lines = self.yield_head_lines(twr_file)
        start_dict = dict()
        for foo in lines:
            for p_s in self.p_check_start_message_list:
                m_s = p_s.search(foo)
                if m_s:
                    key = m_s.group(1)
                    try:
                        key = int(key)
                    except ValueError:
                        pass
                    start_dict[key] = foo
                    break
        if not start_dict:
            print("Warning: Cannot find start mark in {}".format(twr_file))
            return ""
        _keys = list(start_dict.keys())
        _keys.sort()
        return start_dict[_keys[0]]

    def get_raw_twr_data(self, twr_file, start_message_line, report_type=1):
        clock_value_dict = dict()
        start = 0
        whole_lines = self.yield_lines(twr_file)
        summary_titles = list()
        table_lines = list()
        table_line = ""
        raw_key = ""
        while True:
            try:
                line = next(whole_lines)
            except StopIteration:
                break
            if not start:
                start = start_message_line in line
                if start:
                    next_line = next(whole_lines)
                    if not self.p_yes.search(next_line):
                        start = False
            else:
                if report_type == 1:
                    list_of_line = self.p_sep.split(line)
                    if not summary_titles:
                        set_of_line = set(list_of_line)
                        if not (self.set_of_titles - set_of_line):  # find title
                            summary_titles = list_of_line
                    else:
                        if not line:
                            break
                        if self.p_row.search(line):
                            continue
                        if len(list_of_line) == len(summary_titles):
                            table_lines.append(table_line + line)
                            table_line = ""
                        else:
                            table_line += line
                elif report_type == 2:
                    m_constraint = self.p_constraint.search(line)
                    if m_constraint:
                        raw_key = m_constraint.group(1)  # always
                        clock_value_dict.setdefault(raw_key, dict())
                    if raw_key:
                        m_target = self.p_target.search(line)
                        m_actual = self.p_actual.search(line)
                        if m_target:
                            clock_value_dict[raw_key]["Target"] = m_target.group(1)
                        elif m_actual:
                            clock_value_dict[raw_key]["Actual"] = m_actual.group(1)
        if table_lines:
            for foo in table_lines:
                foo_list = self.p_sep.split(foo)
                clock_value_dict[foo_list[0]] = dict(zip(summary_titles, foo_list))
        return clock_value_dict

    def create_twr_data(self, raw_twr_data):
        # p_clk_name = re.compile(r"\[get_(port|pin|net)s{*([^]]+)}*]")  # get_ports | get_pins | get_nets
        # when use Lattice Standard timing report format, use -name $clk_name.
        p_clk_name = re.compile(r"-name([^-]+)-")
        for k, v in list(raw_twr_data.items()):
            short_k = re.sub(r"\s", "", k)
            m_clk_name = p_clk_name.search(short_k)
            if m_clk_name:
                clk_name = m_clk_name.group(1)
                clk_name = clk_name.strip("{")
                clk_name = clk_name.strip("}")
                #
                _target, _actual = v.get("Target"), v.get("Actual")
                if _target and _actual:
                    self.twr_data[clk_name] = dict(target_fmax=_target, fmax=_actual)
                else:
                    _target = v.get("Target", "")
                    _actual = v.get("Frequency", "")
                    _target_list = _target.split()
                    _actual_list = _actual.split()
                    this_clk_data = dict()
                    if len(_target_list) == 2 and len(_actual_list) == 2:
                        if _target_list[-1] == "ns" and _actual_list[-1] == "MHz":
                            df = "{:.3f}".format(1000/float(_target_list[0]))
                            this_clk_data = dict(targetFmax=df, fmax=_actual_list[0])
                    else:
                        if len(_actual_list) == 2:
                            this_clk_data["fmax"] = _actual_list[0]
                            this_clk_data["targetFmax"] = _target
                    if this_clk_data:
                        this_clk_data["logic_level"] = v.get("Levels")
                        this_clk_data["Slack"] = re.sub(r"\sns", "", v.get("Slack", ""))
                        self.twr_data[clk_name] = this_clk_data
# end of file
