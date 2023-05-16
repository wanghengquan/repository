#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 2:05 PM 3/16/2023
  file: scanData.py
  author: Shawn Yan
Description:

"""
from . import utils
# for eval operation
from . import adapters


class ScanData(object):
    def __init__(self, yaml_patterns):
        self.yaml_patterns = yaml_patterns
        self.search_patterns = dict()  # PEP8
        self.group_patterns = dict()   # PEP8

    def scan_file(self, report_file):
        file_data = dict()
        self.report_file = report_file
        for file_keyword, self.search_patterns in list(self.yaml_patterns.items()):
            if self.skip_report_file_yes():
                continue
            for group_code, self.group_patterns in list(self.search_patterns.items()):
                if not group_code.startswith("group"):
                    continue
                group_data = self.get_group_data()
                file_data.update(group_data)
        return file_data

    def skip_report_file_yes(self):
        yes_skipped = True
        p_check_filename = self.search_patterns.get("name_pattern")
        p_check_content = self.search_patterns.get("content_pattern")
        if p_check_filename or p_check_content:
            a_yes_skipped = b_yes_skipped = None
            if p_check_filename:
                if p_check_filename.search(self.report_file):
                    a_yes_skipped = False
                else:
                    a_yes_skipped = True
            if p_check_content:
                head_lines = utils.YieldLines().yield_head_lines(self.report_file)
                b_yes_skipped = True
                try:
                    for line in head_lines:
                        if p_check_content.search(line):
                            b_yes_skipped = False
                            break
                except UnicodeDecodeError:
                    pass
            if p_check_filename and p_check_content:
                yes_skipped = a_yes_skipped or b_yes_skipped
                return yes_skipped
            elif p_check_filename:
                return a_yes_skipped
            elif p_check_content:
                return b_yes_skipped
        print("Warning. Unknown file name: {}".format(self.report_file))
        return yes_skipped

    def get_group_data(self):
        this_data = dict()
        fields_dict_list = self.group_patterns.get("fields")
        if not fields_dict_list:
            return this_data   # no data
        use_func_bool = self.group_patterns.get("use_func")

        if use_func_bool:
            self._get_group_data_by_function(this_data, fields_dict_list)
        else:
            self._get_group_data_by_patterns(this_data, fields_dict_list)
        return this_data

    def _get_group_data_by_function(self, temp_group_data, fields_dict_list):
        for one_field_dict in fields_dict_list:
            field_func = one_field_dict.get("func")
            if not field_func:
                print("Warning. No func name specified for {}".format(one_field_dict))
                continue
            func_string = "adapters.{}('{}')".format(field_func, utils.dos2unix(self.report_file))
            func_res = eval(func_string)
            self.enrich_data(temp_group_data, one_field_dict, func_res)

    def _get_group_data_by_patterns(self, temp_group_data, fields_dict_list):
        greedy_bool = self.group_patterns.get("greedy")
        head_int = self.group_patterns.get("head")
        tail_int = self.group_patterns.get("tail")
        hook_dict = self.group_patterns.get("hook")
        basic_producer = utils.YieldLines()
        if head_int:
            searching_lines = basic_producer.yield_head_lines(self.report_file, head_int)
        elif tail_int:
            searching_lines = basic_producer.yield_tail_lines(self.report_file, tail_int)
        elif hook_dict:
            searching_lines = basic_producer.yield_hook_lines(self.report_file, hook_dict)
        else:
            searching_lines = basic_producer.yield_lines(self.report_file)
        for line in searching_lines:
            for one_field_dict in fields_dict_list:
                f_name = one_field_dict.get("name")
                f_names = one_field_dict.get("names")
                f_pattern = one_field_dict.get("pattern")
                perhaps_names = [f_name] if f_name else f_names
                # initialize them
                already_searched = False
                for x in perhaps_names:
                    temp_group_data.setdefault(x, None)
                    already_searched = temp_group_data.get(x)
                if already_searched and (not greedy_bool):
                    continue
                f_match = f_pattern.search(line)
                if f_match:
                    re_match_res = self.get_re_match_res_dict(f_match)
                    self.enrich_data(temp_group_data, one_field_dict, re_match_res)

    @staticmethod
    def enrich_data(data_dict, one_field_dict, result_data):
        column_name = one_field_dict.get("name")
        column_alias = one_field_dict.get("alias")
        column_names = one_field_dict.get("names")
        column_nickname = one_field_dict.get("nickname")   # use func return value
        # column_uncertain_name = one_field_dict.get("uncertain_name")
        if column_nickname:
            data_dict[column_nickname] = result_data
        elif column_name:
            this_value = result_data.get("index0", result_data.get(column_name))
            if column_alias:
                this_value = column_alias.get(this_value, column_alias.get("default", this_value))
            data_dict[column_name] = this_value
        elif column_names:
            for i, x in enumerate(column_names):
                this_value = result_data.get("index{}".format(i), result_data.get(x))
                data_dict[x] = this_value
        else:  # column_uncertain_name, use result directly
            for k, v in list(result_data.items()):
                data_dict[k] = v

    @staticmethod
    def get_re_match_res_dict(re_match):
        re_dict = re_match.groupdict()
        if not re_dict:  # use index groups()
            for idx, foo in enumerate(re_match.groups()):
                re_dict["index{}".format(idx)] = foo
        return re_dict
