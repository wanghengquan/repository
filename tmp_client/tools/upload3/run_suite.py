#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 8:36 PM 1/9/2023
  file: run_suite.py
  author: Shawn Yan
Description:
  Private package: capuchin (http://lsh-tmp/platform/trunk/python3/capuchin-master)
  Data Structure:
    suite_data_dict:
      key: suite::project_id+suite_name
      value: dict.fromkeys(project_id, suite_name, name, description, id)
    section_data_odict:
      key: section::project_id+suite_name+section_name
      value: dict.fromkeys(project_id, suite_name, section_name, name, suite_id, id)
    case_data_odict:
      key: case::project_id+suite_name+section_name+title
      value: dict.fromkeys(project_id, suite_name, section_name, title, suite_id, section_id, id, fields1, fields2, ...)
"""
import os
import re
import csv
import copy
import glob
import json
import argparse
from collections import OrderedDict
from capuchin import xTools
from capuchin import xExcel
from capuchin import xDatabase
from capuchin import xLogger
from capuchin import testrailAPI

SQL_FIELDS = 'SELECT `id`, `system_name`, `label`, `configs` FROM `fields` WHERE `is_active`=1 AND entity_id=1'
SQL_PRIORITIES = 'SELECT id, name, is_default FROM priorities WHERE is_deleted=0'
SQL_CASE_TYPES = 'SELECT id, name, is_default FROM case_types WHERE is_deleted=0'
SQL_SUITES = '''
  SELECT project_id, `id`, `name` as suite_name, `description`, 'name'
    FROM suites
    WHERE `name`="{suite_name}" AND project_id={project_id} AND is_copy=0'''
SQL_SECTIONS = '''
  SELECT A.`id`, A.`name` as section_name, A.`name`, B.project_id, B.name as suite_name, B.id as suite_id
    FROM sections A
    LEFT JOIN suites B ON B.id = A.suite_id
    WHERE A.suite_id={suite_id}'''
SQL_CASES = '''
  SELECT A.*, C.project_id, C.name as suite_name, B.name as section_name, C.id as suite_id
    FROM cases A
    JOIN sections B ON A.section_id=B.id
    JOIN suites C ON C.id=B.suite_id
    WHERE C.id={suite_id}'''


class FlowOptions(xLogger.Voice):
    def __init__(self):
        super(FlowOptions, self).__init__(None)
        self.agile_project_id = "7"
        self.parser = argparse.ArgumentParser()
        self.sub_parser = self.parser.add_subparsers(help="Operation")

    def get_options(self, args=None):
        self.add_upload_options()
        self.add_agile_options()
        self.add_upgrade_options()
        opts = self.parser.parse_args(args)
        self.operation = opts.operation
        self.suite_file = opts.suite_file
        x = os.path.splitext(os.path.basename(self.suite_file))[0]
        self.csv_folder = os.path.abspath("CSV_" + x.upper())
        self.debug = opts.debug
        self.clean = opts.clean
        self.testrail_api = None
        self.suite_sheets = None
        if self.operation in ("upload", "agile"):
            self.macro_only = opts.macro_only
            self.suite_sheets = opts.suites
            self.username = opts.username
            self.password = opts.password
            self.testrail_api = testrailAPI.TestrailWrapper(username=self.username, password=self.password)

    def add_upload_options(self):
        x = self.sub_parser.add_parser("upload", help="upload suite file to TMP")
        self._add_public_options(x)
        self._add_other_options(x)
        x.set_defaults(operation="upload")

    def add_agile_options(self):
        x = self.sub_parser.add_parser("agile", help="Agile suite for modified cases only")
        self._add_public_options(x)
        self._add_other_options(x)
        x.set_defaults(operation="agile")

    def add_upgrade_options(self):
        x = self.sub_parser.add_parser("upgrade", help="upgrade suite file")
        self._add_public_options(x)
        x.set_defaults(operation="upgrade")

    @staticmethod
    def _add_public_options(sub_parser):
        sub_parser.add_argument("-f", "--suite-file", required=True, help="specify Suite Excel file")
        sub_parser.add_argument("-d", "--debug", action="store_true", help="print debug message ONLY")
        sub_parser.add_argument("-c", "--clean", action="store_true", help="cleanup and run")

    @staticmethod
    def _add_other_options(sub_parser):
        _hlp = "handle cases that meet macro only, default is auto: 'no' if single suite sheet in Suite file else 'yes'"
        sub_parser.add_argument("-m", "--macro-only", choices=("yes", "no", "auto"), default="auto", help=_hlp)
        _help = "specify suite sheet name(s), default is all suites"
        sub_parser.add_argument("-s", "--suites", nargs="+", help=_help)
        sub_parser.add_argument("-u", "--username", required=True, help="specify TMP username")
        sub_parser.add_argument("-p", "--password", required=True, help="specify TMP password")


class FlowSuite(FlowOptions):
    def __init__(self):
        super(FlowSuite, self).__init__()
        self.p_quota = re.compile("DOUBLE-QUOTATION")
        self.ssc_keys_dict = dict(suite=("project_id", "suite_name"),
                                  section=("project_id", "suite_name", "section_name"),
                                  case=("project_id", "suite_name", "section_name", "title"))

    def process(self):
        self.get_options()
        self.extract_excel_to_csv_files()
        if self.operation == "upgrade":
            return
        else:
            self.testrail_db = xDatabase.get_db_link()
            self.say_info("* SEARCHING DATABASE {} on {}".format(self.testrail_db.database, self.testrail_db.host))
            self.get_field_configuration()
            if self.get_very_first_suite_data():
                return 1
            if self.get_very_first_case_data():
                return 1
            if self.get_input_data():
                return 1
            formal_tmp_data = self.get_tmp_data(self.input_data.get("suite"))
            if self.operation == "agile":
                agile_input_data = self.get_agile_data(self.input_data, formal_tmp_data)
                agile_tmp_data = self.get_tmp_data(agile_input_data.get("suite"))
                self.upload_cases(agile_input_data, agile_tmp_data)
            elif self.operation == "upload":
                self.upload_cases(self.input_data, formal_tmp_data)

    def extract_excel_to_csv_files(self):
        self.say_info("Try to extract suite Excel file {} to csv files ...".format(os.path.basename(self.suite_file)))
        if self.clean or not os.path.isdir(self.csv_folder):
            extractor = xExcel.Excel2csv()
            extractor.process(self.suite_file)
            extractor.dump_to_file(self.csv_folder)
        self.raw_csv_files = glob.glob(os.path.join(self.csv_folder, "Sheet*.csv"))
        self.raw_csv_files.sort(key=str.lower)

    def get_field_configuration(self):
        self.say_info("Try to get fields configuration ...")
        local_field_conf_json_file = "FIELD_CONFIGURATION.JSON"
        if self.clean or (not os.path.isfile(local_field_conf_json_file)):
            self.field_configuration = dict(Title=dict(system_name="title"))
            res_field = self.testrail_db.query(SQL_FIELDS)
            res_priority = self.testrail_db.query(SQL_PRIORITIES)
            res_type = self.testrail_db.query(SQL_CASE_TYPES)
            self._get_field_configuration_field(res_field)
            self._get_field_configuration_priority_or_type(res_priority, "Priority", "priority_id")
            self._get_field_configuration_priority_or_type(res_type, "Type", "type_id")
            xTools.dump_json(local_field_conf_json_file, self.field_configuration)
        else:
            self.field_configuration = xTools.load_json(local_field_conf_json_file)

    def _get_field_configuration_field(self, res_field):
        for foo in res_field:
            foo_configs = foo.get("configs")
            json_configs = json.loads(foo_configs)
            if not json_configs:
                raw_default_value, raw_items = None, dict()
            else:
                configs_options = json_configs[0].get("options", dict())
                raw_default_value, raw_items = configs_options.get("default_value"), configs_options.get("items")
                if raw_default_value:
                    try:
                        raw_default_value = int(raw_default_value)
                    except ValueError:
                        pass
                if raw_items:
                    item_lines = raw_items.splitlines()
                    raw_items = dict()
                    for bar in item_lines:
                        bar_list = xTools.comma_split(bar)
                        raw_items[bar_list[1]] = int(bar_list[0])
                else:
                    raw_items = dict()
            new_foo = dict(system_name=foo.get("system_name"), default_value=raw_default_value, items=raw_items)
            self.field_configuration[foo.get("label")] = new_foo

    def _get_field_configuration_priority_or_type(self, res_data, label_name, system_name):
        default_value, items = "", dict()
        for foo in res_data:
            _id, _name, _is_default = foo.get("id"), foo.get("name"), foo.get("is_default")
            if _is_default:
                default_value = _id
            items[_name] = _id
        new_data = dict(system_name=system_name, default_value=default_value, items=items)
        self.field_configuration[label_name] = new_data

    def get_very_first_suite_data(self):
        self.raw_suite_number = 0
        self.very_first_suite_data = OrderedDict()
        p_suite = re.compile(r"Sheet_(suit.+)\.csv", re.I)
        for csv_file in self.raw_csv_files:
            file_basename = os.path.basename(csv_file)
            m_suite = p_suite.search(file_basename)
            if not m_suite:
                continue
            self.raw_suite_number += 1
            suite_sheet_name = m_suite.group(1)
            if self.suite_sheets:
                if suite_sheet_name not in self.suite_sheets:
                    self.say_warning("Skip suite sheet: {}".format(suite_sheet_name))
                    continue
            this_sheet_data = OrderedDict()
            self.very_first_suite_data[suite_sheet_name] = this_sheet_data
            with open(csv_file) as ob:
                csv_reader = csv.reader(ob)
                macro_code, previous_title = 0, ""
                for item_list in csv_reader:
                    if item_list.count("") == len(item_list):  # empty line
                        continue
                    this_title = item_list[0]
                    if this_title:
                        previous_title = this_title
                    else:
                        this_title = previous_title
                    if this_title == "END":
                        break
                    if this_title == "[suite_info]":
                        section_dict = OrderedDict()
                        this_sheet_data.setdefault("suite_info", section_dict)
                        section_dict["Author"] = [item_list[1]]
                    elif this_title == "[macro]":
                        macro_code += 1
                        section_dict = OrderedDict()
                        this_sheet_data.setdefault("macro_{}".format(macro_code), section_dict)
                    else:
                        small_list = list()
                        if macro_code:
                            section_dict.setdefault(this_title, small_list)
                            section_dict[this_title].append({item_list[1]: item_list[2]})
                        else:
                            section_dict.setdefault(this_title, small_list)
                            section_dict[this_title].extend(self.split_with_semicolon(item_list[1]))
        if self._get_very_first_suite_data_sanity_check():
            return 1
        # self.say_debug(self.very_first_suite_data, "Very First suite data: ", self.debug)

    @staticmethod
    def split_with_semicolon(raw_string):
        temp_semicolon = "TEMP_SEMICOLON"
        raw_string = re.sub(r"\\;", temp_semicolon, raw_string)
        raw_list = re.split(r"\s*;\s*", raw_string)
        raw_list = [re.sub(temp_semicolon, ";", item) for item in raw_list]
        return raw_list

    def _get_very_first_suite_data_sanity_check(self):
        """MUST HAVE:
               project_id
               suite_name
           and suite_name is unique
        """
        real_suite_names = list()
        for k, v in list(self.very_first_suite_data.items()):
            section_suite_info = v.get("suite_info")
            if not section_suite_info:
                self.say_error("Error. Not found suite_info in Sheet_{}".format(k))
                return 1
            project_id = section_suite_info.get("project_id")
            suite_name = section_suite_info.get("suite_name")
            try:
                int(project_id[0])
            except (ValueError, TypeError, IndexError):
                self.say_error("Error. Not found valid project_id in Sheet_{}".format(k))
                return 1
            try:
                this_suite_name = suite_name[0]
                if not this_suite_name:
                    self.say_error("Error. Not found valid suite_name in Sheet_{}".format(k))
                    return 1
                if this_suite_name in real_suite_names:
                    self.say_error("Error. Duplicated suite_name {} in Sheet_{}".format(suite_name, k))
                    return 1
                real_suite_names.append(this_suite_name)
            except (TypeError, IndexError):
                self.say_error("Error. Not found valid suite_name in Sheet_{}".format(k))
                return 1

    def get_very_first_case_data(self):
        self.very_first_case_data = OrderedDict()
        p_case = re.compile(r"Sheet_(cas.+)\.csv", re.I)
        default_section_name = "Test Cases"
        flag_for_title_line = ("Title", "design_name", "Section")
        flag_set_for_title_line = set(flag_for_title_line)
        for csv_file in self.raw_csv_files:
            file_basename = os.path.basename(csv_file)
            m_case = p_case.search(file_basename)
            if not m_case:
                continue
            real_content_lines = list()
            with open(csv_file, "rb") as ob:  # when has UnicodeDecodeError string
                for line in ob:
                    line = line.decode()
                    if not real_content_lines:
                        line_list = xTools.comma_split(line)
                        if not (flag_set_for_title_line - set(line_list)):
                            real_content_lines.append(line)
                    else:
                        real_content_lines.append(line)
            csv_dict_reader = csv.DictReader(real_content_lines)
            if csv_dict_reader:
                for line_dict in csv_dict_reader:
                    valid_values = list(line_dict.values())
                    if valid_values.count("") == len(valid_values):
                        continue
                    _title, _design_name, _section = [line_dict.get(item) for item in flag_for_title_line]
                    if not _design_name:
                        self.say_error("Error. Not defined design_name in {}".format(line_dict))
                        return 1
                    if not _title:
                        line_dict["Title"] = _design_name
                    if not _section:
                        line_dict["Section"] = default_section_name
                    unique_key = "*{Section}::{Title}*".format(**line_dict)
                    if unique_key in self.very_first_case_data:
                        self.say_error("Error. Duplicated design: {}".format(unique_key))
                        return 1
                    self.very_first_case_data[unique_key] = line_dict
        # self.say_debug(self.very_first_case_data, "Very First case data: ", self.debug)

    def get_input_data(self):
        self.titles_for_case_custom_config = ("CaseInfo", "Environment", "System",
                                              "LaunchCommand", "Software", "Machine")
        self.titles_omit_for_case = ("Order", "Section", "design_name",
                                     "Sorting", "Create", "Update", "matched_times")
        self._in_suite_dict = dict()
        self._in_section_odict = OrderedDict()
        self._in_case_odict = OrderedDict()
        for suite_sheet_name, raw_suite_data in list(self.very_first_suite_data.items()):
            self._build_input_suite_data(raw_suite_data)
            self._build_input_section_and_case_data(raw_suite_data)
        self.input_data = dict(suite=self._in_suite_dict, section=self._in_section_odict, case=self._in_case_odict)

    def _build_input_suite_data(self, raw_suite_data):
        suite_info_dict = raw_suite_data.get("suite_info")
        self.using_project_id = suite_info_dict.get("project_id")[0]
        self.using_suite_name = suite_info_dict.get("suite_name")[0]
        self.using_author = suite_info_dict.get("Author")
        try:
            self.using_author = self.using_author[0]
        except (IndexError, TypeError):
            self.using_author = ""
        this_suite_data = dict(project_id=self.using_project_id, suite_name=self.using_suite_name,
                               name=self.using_suite_name)
        this_suite_data["description"] = self._get_input_data_suite_description(suite_info_dict)
        self._in_suite_dict[self.__get_ssc_key(this_suite_data, "suite")] = this_suite_data

    def __get_ssc_key(self, base_data_dict, type_name):
        new_key_list = [str(base_data_dict.get(item)) for item in self.ssc_keys_dict.get(type_name)]
        return "{}::{}".format(type_name, "+".join(new_key_list))

    @staticmethod
    def _get_input_data_suite_description(suite_info_dict):
        exclude_keys = ("Author", "project_id", "suite_name")
        description_list = list()
        for k, v in list(suite_info_dict.items()):
            if k in exclude_keys:
                continue
            description_list.append('[{}]'.format(k))
            if v.count("") != len(v):
                description_list.extend(v)
        return '\n'.join(description_list)

    def _build_input_section_and_case_data(self, raw_suite_data):
        copy_of_cases = copy.deepcopy(self.very_first_case_data)
        all_cases = list()
        for macro_code, macro_data in list(raw_suite_data.items()):
            if not macro_code.startswith("macro"):
                continue
            for no_use, one_case_data in list(copy_of_cases.items()):
                perhaps_case_data = copy.copy(one_case_data)
                tag_matched = True
                condition_list = macro_data.get("condition")  # [{'Flow': '=impl'}, {'Sorting': '=inference'}]
                for condition_dict in condition_list:
                    for field_name, raw_compare_value in list(condition_dict.items()):
                        value_golden = re.sub(r"^=\s*", "", raw_compare_value)
                        values_in_case = re.split(r";\s*", perhaps_case_data.get(field_name, ""))
                        if value_golden not in values_in_case:
                            tag_matched = False
                            break
                    if not tag_matched:
                        break
                if not tag_matched:
                    continue
                one_case_data.setdefault("matched_times", 0)
                one_case_data["matched_times"] += 1
                action_list = macro_data.get("action")
                # [{'Section': 'impl_lse_jedi'}, {'LaunchCommand': 'cmd = --synthesis=lse'}]
                for action_dict in action_list:
                    for new_field, new_value in list(action_dict.items()):
                        # LaunchCommand content in case level should be appended
                        if new_field == "LaunchCommand":
                            new_lc = new_value
                            old_lc = perhaps_case_data.get(new_field, "")
                            new_value = self.__get_lc_string(new_lc, old_lc)
                        perhaps_case_data[new_field] = new_value
                all_cases.append(perhaps_case_data)
        if self.macro_only == "yes":
            yes_macro = True
        elif self.macro_only == "no":
            yes_macro = False
        else:  # auto
            yes_macro = self.raw_suite_number > 1
        if not yes_macro:
            for no_use, one_case_data in list(copy_of_cases.items()):
                perhaps_case_data = copy.copy(one_case_data)
                if one_case_data.get("matched_times", 0) < 1:  # never selected before
                    all_cases.append(perhaps_case_data)
        for selected_case in all_cases:
            section_name = selected_case.get("Section")
            standard_case_dict = self._get_input_data_case(selected_case)
            this_section_data = dict()
            this_section_data["project_id"] = self.using_project_id
            this_section_data["suite_name"] = self.using_suite_name
            this_section_data["section_name"] = this_section_data["name"] = section_name
            standard_case_dict.update(this_section_data)
            key_for_section = self.__get_ssc_key(standard_case_dict, "section")
            if key_for_section not in self._in_section_odict:
                self._in_section_odict[key_for_section] = this_section_data
            key_for_case = self.__get_ssc_key(standard_case_dict, "case")
            self._in_case_odict[key_for_case] = standard_case_dict

    @staticmethod
    def __for_semicolon(raw_list):
        new_list = list()
        for foo in raw_list:
            foo = re.sub(';', "TEMP_SEMICOLON", foo)
            new_list.append(foo)
        return ";".join(new_list)

    def __get_lc_string(self, new_lc, old_lc):
        new_list = self.split_with_semicolon(new_lc)
        old_list = self.split_with_semicolon(old_lc)
        new_has_yes = self.__has_override_local(new_list)
        old_has_yes = self.__has_override_local(old_list)
        if old_has_yes:  # higher priority in case level
            return self.__for_semicolon(old_list)
        elif new_has_yes:
            return self.__for_semicolon(new_list)
        else:
            total_new_odict = OrderedDict()
            p_key_value = re.compile(r"([^=]+?)=(.+)")
            for foo in new_list:
                m_key_value = p_key_value.search(foo)
                if m_key_value:
                    total_new_odict[m_key_value.group(1).strip()] = m_key_value.group(2).strip()
            for bar in old_list:
                m_key_value = p_key_value.search(bar)
                if m_key_value:
                    k, v = m_key_value.group(1).strip(), m_key_value.group(2).strip()
                    if k == "cmd":
                        if k in total_new_odict:
                            total_new_odict[k] += " {}".format(v)
                        else:
                            total_new_odict[k] = v
                    else:
                        if k not in total_new_odict:   # macro has higher priority
                            total_new_odict[k] = v
            total_new_list = list()
            for kk, vv in list(total_new_odict.items()):
                vv = re.sub(';', "TEMP_SEMICOLON", vv)
                total_new_list.append("{} = {}".format(kk, vv))
            return ";".join(total_new_list)

    @staticmethod
    def __has_override_local(lc_list):
        yes_has = False
        o_l = "override=local"
        for foo in lc_list:
            if o_l in re.sub(r'\s', "", foo):
                yes_has = True
                break
        return yes_has

    def _get_input_data_case(self, raw_case_dict):
        new_dict = dict()
        cus_conf_dict = dict()
        for k, v in list(raw_case_dict.items()):
            if k in self.titles_omit_for_case:
                continue
            if k in self.titles_for_case_custom_config:
                if k == "CaseInfo":
                    cus_conf_dict[k] = temp_list = list()
                    temp_list.append('design_name = {design_name}'.format(**raw_case_dict))
                    if v:
                        temp_list.extend(self.split_with_semicolon(v))
                elif v:
                    cus_conf_dict[k] = temp_list = list()
                    temp_list.extend(self.split_with_semicolon(v))
            else:
                field_basic_data = self.field_configuration.get(k)
                if not field_basic_data:
                    continue
                this_key = field_basic_data.get("system_name")
                if not v:
                    v = field_basic_data.get("default_value")
                else:
                    x_dict = field_basic_data.get("items")
                    if x_dict:
                        vv = x_dict.get(v)
                        if vv is None:
                            self.say_error("Error. Unknown string {} in {}".format(v, raw_case_dict))
                            xTools.eexit()
                        v = vv
                new_dict[this_key] = v
        #
        cus_conf = list()
        for ordered_key in self.titles_for_case_custom_config:
            if ordered_key in cus_conf_dict:
                cus_conf.append('[{}]'.format(ordered_key))
                cus_conf.extend(cus_conf_dict.get(ordered_key))
        #
        new_dict["custom_config"] = "\n".join(cus_conf)
        author_name = new_dict.get("custom_author")
        if not author_name:
            new_dict["custom_author"] = self.using_author
        # use default value if a field is not in suite_file
        for label, label_data in list(self.field_configuration.items()):
            system_name, default_value = label_data.get("system_name"), label_data.get("default_value")
            if default_value is None:
                continue
            if new_dict.get(system_name) is None:
                new_dict[system_name] = default_value
        for k, v in list(new_dict.items()):
            try:
                new_dict[k] = self.p_quota.sub('"', v)
            except:
                pass
        return new_dict

    def get_tmp_data(self, suite_data_dict):
        _suite, _section, _case = dict(), OrderedDict(), OrderedDict()
        for suite_key, suite_data in list(suite_data_dict.items()):
            res_suites = self.testrail_db.query(SQL_SUITES.format(**suite_data))
            if not res_suites:
                continue
            if len(res_suites) != 1:
                self.say_error("Error. Duplicated suite_name: {suite_name}".format(**res_suites[0]))
                xTools.eexit()
            _suite[suite_key] = res_suites[0]
            using_suite_id = res_suites[0].get("id")
            res_sections = self.testrail_db.query(SQL_SECTIONS.format(suite_id=using_suite_id))
            for foo in res_sections:
                _section[self.__get_ssc_key(foo, "section")] = foo
            res_cases = self.testrail_db.query(SQL_CASES.format(suite_id=using_suite_id))
            for foo in res_cases:
                case_unique_key = self.__get_ssc_key(foo, "case")
                if case_unique_key in _case:
                    self.say_error("Error. Duplicated case(C{1}): {0}".format(case_unique_key, foo.get("id")))
                    xTools.eexit()
                _case[case_unique_key] = foo
        return dict(suite=_suite, section=_section, case=_case)

    def get_agile_data(self, new_data, old_data):
        _suite, _section, _case = dict(), OrderedDict(), OrderedDict()
        for k, v in list(new_data.get("suite").items()):
            v["project_id"] = self.agile_project_id
            _suite[self.__get_ssc_key(v, "suite")] = v
        new_case_odict, old_case_odict = new_data.get("case", dict()), old_data.get("case", dict())
        for key, new_case_data in list(new_case_odict.items()):
            old_case_data = old_case_odict.get(key)
            will_add_case_data = None
            if not old_case_data:
                will_add_case_data = new_case_data
            else:
                if self.__case_is_diff(new_case_data, old_case_data):
                    will_add_case_data = new_case_data
            if will_add_case_data:
                will_add_case_data["project_id"] = self.agile_project_id
                _case[self.__get_ssc_key(will_add_case_data, "case")] = will_add_case_data
        for key, case_data in list(_case.items()):
            _sec_data = {k: v for k, v in list(case_data.items()) if k in ("project_id", "suite_name", "section_name")}
            _sec_data["name"] = _sec_data["section_name"]
            section_key = self.__get_ssc_key(_sec_data, "section")
            if section_key not in _section:
                _section[section_key] = _sec_data
        agile_data = dict(suite=_suite, section=_section, case=_case)
        return agile_data

    @staticmethod
    def __string_is_diff(string_one, string_two, ignore_space=True):
        if ignore_space:
            string_one = string_one.replace(" ", "")
            string_two = string_two.replace(" ", "")
        sts_one, options_one = xTools.get_options(conf_string=string_one)
        sts_two, options_two = xTools.get_options(conf_string=string_two)

        if sts_one or sts_two:
            return string_one != string_two
        else:
            if options_one or options_two:
                return options_one != options_two
            return string_one != string_two

    def __case_is_diff(self, new_case_dict, old_case_dict):
        """
        ignore blank or None
        """
        _is_diff = False
        for field, new_value in list(new_case_dict.items()):
            if field in ("name", "project_id"):
                continue
            old_value = old_case_dict.get(field)
            if not new_value:
                new_value = ""
            if not old_value:
                old_value = ""
            new_value = str(new_value)
            old_value = str(old_value)
            if self.__string_is_diff(new_value, old_value):
                args = (old_case_dict.get("id"), field, new_value, old_value)
                _info = "Different Case: C{0} {1}\n-------------\n{2}\n===VS===\n{3}\n-------------".format(*args)
                for skip_string in ("custom_test_bench", "custom_fpga_rtl", "custom_automation_type", "custom_smoke",
                                    "custom_nouse", "custom_test_level", "custom_automated", "custom_author"):
                    if skip_string in _info:
                        break
                else:
                    try:
                        self.say_info(_info)
                    except UnicodeEncodeError:
                        self.say_info(repr(_info))
                _is_diff = 1
        return _is_diff

    def upload_cases(self, new_data, old_data):
        # ----- SUITE
        new_suite_dict, old_suite_dict = new_data.get("suite"), old_data.get("suite")
        for suite_key, new_suite_data in list(new_suite_dict.items()):
            old_suite_data = old_suite_dict.get(suite_key, dict())
            if not old_suite_data:  # create a new suite
                self.say_info("--SUITE-- add {}".format(new_suite_data))
                response = self.testrail_api.add_suite(new_suite_data.get("project_id"), new_suite_data)
                new_suite_data["id"] = response.get("id")  # append suite id
            else:
                if self.__string_is_diff(new_suite_data.get("description"), old_suite_data.get("description")):
                    self.say_info("--SUITE-- update {}".format(new_suite_data))
                    if not self.debug:
                        self.testrail_api.update_suite(old_suite_data.get("id"), new_suite_data)
                new_suite_data["id"] = old_suite_data.get("id")  # append suite id
        # ----- SECTION
        new_section_odict, old_section_odict = new_data.get("section"), old_data.get("section")
        for section_key, new_section_data in list(new_section_odict.items()):
            old_section_data = old_section_odict.get(section_key)
            if not old_section_data:
                self.say_info("---SECTION-- add {}".format(new_section_data))
                higher_level_data = new_suite_dict.get(self.__get_ssc_key(new_section_data, "suite"))
                project_id = new_section_data.get("project_id")
                new_section_data["suite_id"] = higher_level_data.get("id")
                response = self.testrail_api.add_section(project_id, new_section_data)
                new_section_data["id"] = response.get('id')
            else:
                new_section_data["id"] = old_section_data.get("id")
        # ----- CASE
        new_case_odict, old_case_odict = new_data.get("case"), old_data.get("case")
        for case_key, new_case_data in list(new_case_odict.items()):
            old_case_data = old_case_odict.get(case_key)
            if not old_case_data:
                higher_level_data = new_section_odict.get(self.__get_ssc_key(new_case_data, "section"))
                section_id = higher_level_data.get("id")
                self.say_info("----CASE-- add {}".format(case_key))
                self.testrail_api.add_case(section_id, new_case_data)
            else:
                if self.__case_is_diff(new_case_data, old_case_data):
                    self.say_info("----CASE-- update {}".format(case_key))
                    case_id = old_case_data.get("id")
                    self.testrail_api.update_case(case_id, new_case_data)
        for case_key, old_case_data in list(old_case_odict.items()):
            if case_key not in new_case_odict:
                self.say_info("----CASE-- delete (C{}){}".format(old_case_data.get("id"), case_key))
                self.testrail_api.delete_case(old_case_data.get("id"))
        # ---- delete section after delete case
        for section_key, old_section_data in list(old_section_odict.items()):
            if section_key not in new_section_odict:
                _info = "---SECTION-- delete {section_name} in suite {suite_name}".format(**old_section_data)
                self.say_info(_info)
                self.testrail_api.delete_section(old_section_data.get("id"))


if __name__ == "__main__":
    main_flow = FlowSuite()
    main_flow.process()
