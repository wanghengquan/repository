#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 9:10 AM 11/7/2022
  file: vivadoBasicScan.py
  author: Shawn Yan
Description:

"""
import os
import re
import yaml
from statistics import geometric_mean
from .localCapuchin import xTools
from .localTexttables import DictReader
from .localTexttables import Dialect


class VivadoDialect(Dialect):
    header_delimiter = '-'
    top_border = '-'
    bottom_border = '-'
    left_border = '|'
    cell_delimiter = '|'
    right_border = '|'
    corner_border = '+'
    strip = True


class ScanVivadoTable(object):
    def __init__(self):
        self.p_next_line = re.compile("^-+$")
        self.p_border = re.compile(r"^\+-(.+)-\+$")
        self.p_cell_width = re.compile("(-+)")
        self.stop_if_match_border_times = 3
        self.table_data_dict_list = list()

    def get_table_data_dict_list(self):
        return self.table_data_dict_list

    def read_table(self, report_file, table_name_string, table_name_pattern):
        self.table_data_dict_list = list()
        self.report_file = report_file
        self.table_name_string = table_name_string
        self.table_name_pattern = table_name_pattern
        self.match_border_times = 0
        self._get_raw_table_lines()
        if self.raw_table_lines and self.raw_width_list:
            for foo in DictReader(self.raw_table_lines, self.raw_width_list, dialect=VivadoDialect):
                self.table_data_dict_list.append(foo)

    def _get_raw_table_lines(self):
        self.raw_table_lines = list()
        self.raw_width_list = list()
        if not os.path.exists(self.report_file):
            return "Not found report file: {}".format(self.report_file)
        with open(self.report_file) as rob:
            start_table = None
            while True:
                line = rob.readline()
                if not line:
                    break  # no new line
                line = line.strip()
                if not start_table:
                    m_table_name = self.table_name_pattern.search(line)
                    if m_table_name:
                        next_line = rob.readline()
                        next_line = next_line.strip()
                        start_table = self.p_next_line.search(next_line)
                    continue

                m_border = self.p_border.search(line)
                if m_border:
                    self.match_border_times += 1
                if line:
                    self.raw_table_lines.append(line)
                if self.match_border_times == 2:
                    if not line:
                        return "Cannot get table strings for {}".format(self.table_name_string)
                if self.match_border_times == self.stop_if_match_border_times:
                    cell_list = self.p_cell_width.findall(line)
                    self.raw_width_list = [len(foo) for foo in cell_list]
                    break


def get_valid_lines(rpt_file, head_n=0, tail_n=0, start_pattern=None, end_pattern=None):
    file_line_number = xTools.get_file_line_count(rpt_file)  # very fast
    if head_n:
        min_index, max_index = 0, head_n
    elif tail_n:
        min_index, max_index = file_line_number - tail_n, file_line_number
    else:
        min_index = max_index = 0
    if file_line_number == 0:  # Not found file
        yield None
    else:
        with open(rpt_file) as ob:
            if start_pattern and end_pattern:
                will_yield = False
            else:
                will_yield = True
            for line_number, line in enumerate(ob):
                if min_index or max_index:
                    if line_number < min_index:
                        continue
                    elif line_number > max_index:
                        continue
                if will_yield:
                    if end_pattern:
                        if end_pattern.search(line):
                            break
                    yield line.strip()
                else:
                    if start_pattern:
                        will_yield = start_pattern.search(line)
                        if will_yield:
                            yield line.rstrip()


class ScanVivadoTimingReport(object):
    def __init__(self, report_file):
        self.report_file = report_file
        self.p_start_constraint = re.compile(r"^Clock\s+Waveform\(ns\)")
        self.p_start_worst_slack = re.compile(r"Clock\s+WNS\(ns\)")
        self.p_end = re.compile(r"^\s*$")

    def process(self):
        self.get_clock_constraint_period()
        self.get_clock_worst_slack()
        self.calculate_frequency()

    def get_clock_constraint_period(self):
        """
        Clock      Waveform(ns)         Period(ns)      Frequency(MHz)
        -----      ------------         ----------      --------------
        clk_1_mhz  {0.000 3.846}        7.692           130.005
        clk_8_mhz  {0.000 3.846}        7.692           130.005
        """
        valid_lines = get_valid_lines(self.report_file, start_pattern=self.p_start_constraint, end_pattern=self.p_end)
        self.clock_constraint_dict = dict()
        for foo in valid_lines:
            if foo is None:
                continue
            foo_list = foo.split()
            try:
                float(foo_list[-1])
                self.clock_constraint_dict[foo_list[0]] = float(foo_list[-2])
            except ValueError:
                continue

    def get_clock_worst_slack(self):
        """
        Clock             WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints    ...
        -----             -------      -------  ---------------------  -------------------    ...
        clk_1_mhz         -16.123      -63.896                      4                  529    ...
        clk_8_mhz          -0.872       -0.872                      1                  144    ...
        """
        valid_lines = get_valid_lines(self.report_file, start_pattern=self.p_start_worst_slack, end_pattern=self.p_end)
        self.clock_worst_slack_dict = dict()
        for foo in valid_lines:
            if foo is None:
                continue
            foo_list = foo.split()
            try:
                wns_float = float(foo_list[1])
                self.clock_worst_slack_dict[foo_list[0]] = wns_float
            except ValueError:
                continue

    def calculate_frequency(self):
        self.frequency_dict = dict()
        for clock_name, clock_period in list(self.clock_constraint_dict.items()):
            worst_slack_value = self.clock_worst_slack_dict.get(clock_name)
            if worst_slack_value:
                self.frequency_dict[clock_name] = dict(targetFmax=1000 / clock_period,
                                                       fmax=1000 / (clock_period - worst_slack_value),
                                                       slack=worst_slack_value)


def macro_get_twr_data(report_file, fmax_sort="max"):
    scanner = ScanVivadoTimingReport(report_file)
    scanner.process()
    if fmax_sort == "max":
        twr_dict = dict(clkName="", targetFmax="", fmax="")
        for clock_name, tfs_dict in list(scanner.frequency_dict.items()):
            previous_fmax = twr_dict.get("fmax")
            fmax, target_fmax = tfs_dict.get("fmax"), tfs_dict.get("targetFmax")
            if (not previous_fmax) or previous_fmax > fmax:
                twr_dict = dict(clkName=clock_name, targetFmax=target_fmax, fmax=fmax)
        for k, v in list(twr_dict.items()):
            if isinstance(v, float):
                v = "{:.3f}".format(v)  # to str
            twr_dict[k] = v
    elif fmax_sort == "geomean":
        twr_dict = dict(itr_no="", geoFmax="")
        p_tag = re.compile(r'target_iteration_(\d+)')
        m_tag = p_tag.search(report_file)
        twr_dict["itr_no"] = m_tag.group(1) if m_tag else "pushbutton"
        raw_fmax_list = [foo.get("fmax") for foo in list(scanner.frequency_dict.values())]
        print(raw_fmax_list)
        twr_dict["geoFmax"] = geometric_mean(raw_fmax_list)
    else:
        twr_dict = dict(log="failed to scan twr files")
    return [twr_dict]  # dict in a list


def create_regexp(raw_string):
    raw_string = re.sub(r"\s+", r"\\s+", raw_string)
    return re.compile(raw_string)


def recursive_string2regexp(raw_dict):
    for k, v in list(raw_dict.items()):
        if k.endswith("_PATTERN") or k.endswith("pattern"):
            if isinstance(v, str):
                v = [v]  # to list
            raw_dict[k] = [create_regexp(item) for item in v]
        elif k == "name":
            if isinstance(v, str):
                raw_dict[k] = [v]  # to list
        else:
            if k == "FIELDS":
                for foo in v:
                    recursive_string2regexp(foo)
            else:
                if isinstance(v, dict):
                    recursive_string2regexp(v)


def yaml2dict(yaml_file):
    with open(yaml_file) as ob:
        yaml_dict = yaml.safe_load(ob)
    recursive_string2regexp(yaml_dict)
    return yaml_dict


def get_base_data_list(raw_value, patterns):
    alias_dict = patterns.get("alias")
    raw_group = patterns.get("group")
    if alias_dict:
        raw_value = alias_dict.get(raw_value, raw_value)
    raw_name = patterns.get("name")
    line_data = list()
    for n in raw_name:
        _ = dict()
        _[n] = raw_value
        if raw_group:
            _["group"] = raw_group
        line_data.append(_)
    return line_data


def get_data_from_a_line(line, patterns):
    for p in patterns.get("pattern"):  # MUST exist!
        m = p.search(line)
        if m:
            raw_value = m.group(1)
            return get_base_data_list(raw_value, patterns)


def get_fields_data(report_file, field_settings, head_n, tail_n):
    """
    field_settings is a list
    for remove processed one, change to dictionary
    """
    settings_yes, settings_no = dict(), dict()
    fields_data = list()
    for i, foo in enumerate(field_settings):
        if "start_pattern" in foo or "end_pattern" in foo:
            settings_yes[i] = foo
        else:
            settings_no[i] = foo
    if settings_no:
        valid_lines = get_valid_lines(report_file, head_n, tail_n)
        for line in valid_lines:
            if not settings_no:
                break  # find all value
            for k, _pats in list(settings_no.items()):
                line_data = get_data_from_a_line(line, _pats)
                if line_data:
                    fields_data.extend(line_data)
                    settings_no.pop(k)
    if settings_yes:
        for k, _pats in list(settings_yes.items()):
            valid_lines = get_valid_lines(report_file, head_n, tail_n,
                                          _pats.get("start_pattern"), _pats.get("end_pattern"))
            for line in valid_lines:
                line_data = get_data_from_a_line(line, _pats)
                if line_data:
                    settings_yes.pop(k)
                    fields_data.extend(line_data)

    # set default value
    for foo in (settings_yes, settings_no):
        if not foo:
            continue
        for k, v in list(foo.items()):
            raw_value = v.get("default", "")
            fields_data.extend(get_base_data_list(raw_value, v))
    return fields_data


def scan_file(report_file, report_patterns, fmax_sort):
    capital_group = report_patterns.get("GROUP", "Default")
    capital_macro = report_patterns.get("MACRO")
    capital_fields = report_patterns.get("FIELDS")
    report_data = list()
    if capital_macro:
        func_string = '{}(r"{}", "{}")'.format(capital_macro, report_file, fmax_sort)
        report_data = eval(func_string)
    elif capital_fields:
        capital_head = report_patterns.get("HEAD", 0)
        capital_tail = report_patterns.get("TAIL", 0)
        report_data.extend(get_fields_data(report_file, capital_fields, capital_head, capital_tail))
    else:  # Vivado text table
        vivado_scanner = ScanVivadoTable()
        for key1, value1 in list(report_patterns.items()):
            if not isinstance(value1, dict):
                continue
            table_name_pattern = value1.get("TABLE_NAME_PATTERN")
            if not table_name_pattern:
                continue
            vivado_scanner.read_table(report_file, key1, table_name_pattern[0])
            raw_table_data = vivado_scanner.get_table_data_dict_list()
            capital_fields = value1.get("FIELDS")
            for foo in capital_fields:
                raw_value = ""
                for bar in raw_table_data:
                    if bar.get(foo.get("raw_title")) == foo.get("raw_name"):
                        raw_value = bar.get(foo.get("sel_title"))
                        break
                _name = foo.get("name")
                _group = foo.get("group")
                for _n in _name:
                    _ = dict()
                    _[_n] = raw_value
                    if _group:
                        _["group"] = _group
                    report_data.append(_)
    for foo in report_data:
        foo.setdefault("group", capital_group)
    return report_data
