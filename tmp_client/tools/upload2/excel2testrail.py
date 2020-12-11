#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import re
import json
import csv
import argparse
from collections import OrderedDict
from LoppLagoonLake import xlsx2csv
from LoppLagoonLake import tools
from LoppLagoonLake import log4u
from LoppLagoonLake import links

__author__ = 'Shawn Yan'
__date__ = '14:42 2019/3/14'

LOGGER = log4u.create_self_logger(os.path.abspath("UploadSuites.log"))
SEL_SUITE_ID = 'SELECT id as suite_id, description from suites where name="{}" and project_id={} and is_copy=0'
SEL_SECTION_ID = 'SELECT id as section_id from sections where suite_id={} and name="{}" and is_copy=0'
SEL_CASE_TITLE_ID = 'SELECT * from cases where section_id={}'

DROP_DOWN_DICT = dict(custom_automated=dict(YES=1, NO=2),
                      custom_test_level={"1": 1, "2": 2, "3": 3},
                      custom_fpga_rtl=dict(YES=1, NO=2, unkonwn=3),
                      custom_test_bench=dict(YES=1, NO=2, unkonwn=3),
                      custom_smoke=dict(YES=1, NO=2),
                      custom_nouse=dict(YES=2, NO=1))


def get_drop_down_value(raw_case_data):
    for k, v in raw_case_data.items():
        v_dict = DROP_DOWN_DICT.get(k)
        if not v_dict:
            continue
        new_v = v_dict.get(v)
        raw_case_data[k] = new_v


class UploadSuites(object):
    def __init__(self):
        self.db = links.get_guest_db()
        ## self.tr = links.get_tr_api()
        self.des_key = "description"
        self.cmd_key = "LaunchCommand"

    def process(self):
        self.get_options()
        self.tr = links.get_tr_api(self.username, self.password)
        if self.file_xlsx:
            self.upload_from_xlsx_file()
        else:
            self.upload_from_ini_file()
        LOGGER.info("END .......")
        LOGGER.info("-" * 50)

    def get_options(self):
        parser = argparse.ArgumentParser()
        parser.add_argument("-d", "--debug", action="store_true", help="print debug message")
        group = parser.add_mutually_exclusive_group(required=True)
        group.add_argument("-f", "--infile", help="specify input Suite Excel file")
        group.add_argument("--file-ini", help="specify input Suite ini file")
        parser.add_argument("-u", "--username", required=True, help="specify testrail user name.")
        parser.add_argument("-p", "--password", required=True, help="specify testrail password")
        parser.add_argument("-m", "--macro-only", action="store_true", help="Adding case MUST match the macro")
        opts = parser.parse_args()
        self.debug = opts.debug
        self.file_xlsx = opts.infile
        self.username = opts.username
        self.password = opts.password
        self.file_ini = opts.file_ini
        self.macro_only = opts.macro_only

    def upload_from_xlsx_file(self):
        LOGGER.info("Start upload suites by {}".format(self.file_xlsx))
        self.target_path = os.path.abspath("{}_tmp".format(tools.get_filename(self.file_xlsx)))
        self.tmp_ini_file = os.path.join(self.target_path, "local_tmp.ini")
        for func in (self.transfer_xlsx_to_csv,
                     self.parse_suite_sheet,
                     self.write_suite_content,
                     self.get_macros,
                     self.get_raw_cases,
                     self.write_section_cases,
                     self.upload_from_ini_file):
            if func():
                return 1

    def upload_from_ini_file(self):
        LOGGER.info("Start upload suites by {}".format(self.file_ini))
        options = tools.get_conf_file_options(self.file_ini)
        if not options:
            LOGGER.error("Cannot parse conf file: {}".format(self.file_ini))
            return 1
        self.case_data_parser = GetCasesData(self.db)
        if self.upload_suite(options):
            return 1
        self.upload_sections(options)

    def transfer_xlsx_to_csv(self):
        try:
            args = ["-a", self.file_xlsx, self.target_path]
            LOGGER.info("Extract Excel file: {}".format(self.file_xlsx))
            xlsx2csv.main(args)
        except:
            log4u.say_tb()
            return 1

    def write_suite_content(self):
        start = 0
        suite_dict = dict()
        pub_key = ["project_id", "suite_name"]

        for foo in self.suite_sheet_dict_list:
            _ = get_short_content(foo)
            foo_0, foo_1, foo_2 = _
            if not start:
                start = foo_0 == "[suite_info]"
                continue
            if foo_0 in ("[macro]", "END"):
                break
            if foo_0 in pub_key:
                suite_dict[foo_0] = foo_1
            else:
                suite_dict.setdefault(self.des_key, list())
                if foo_0:
                    suite_dict[self.des_key].append("[{}]".format(foo_0))
                if foo_1:
                    foo_1_list = tools.comma_split(foo_1, sep_mark=";")
                    suite_dict[self.des_key].extend(foo_1_list)
        lines = list()
        lines.append("[suite {}]".format(suite_dict.get("suite_name", "NoSuiteName")))
        lines.append("project_id = {}".format(suite_dict.get("project_id", "NoProjectID")))
        lines.append("{} = ".format(self.des_key))
        for bar in suite_dict.get(self.des_key, list()):
            lines.append("        {}".format(bar))
        lines.append(";;;;;;;;;; ")
        tools.write_file(self.tmp_ini_file, lines)

    def parse_suite_sheet(self):
        raw_suite_csv = os.path.join(self.target_path, "suite.csv")
        if tools.not_exists(raw_suite_csv, "Raw suite sheet"):
            return 1
        tools.update_file(raw_suite_csv, ["0,1,2,3,4,5"] + open(raw_suite_csv).readlines())
        csv_dict = csv.DictReader(open(raw_suite_csv))
        self.suite_sheet_dict_list = []
        for k in csv_dict:
            try:
                k.pop(None)
            except:
                pass
            self.suite_sheet_dict_list.append(k)

    def get_macros(self):
        self.macro_dict = dict()
        macro_no = 0
        for foo in self.suite_sheet_dict_list:
            _ = get_short_content(foo)
            foo_0, foo_1, foo_2 = _
            if "END" in foo_0:
                break
            if foo_0 == "[macro]":
                macro_no += 1
                self.macro_dict[macro_no] = list()
            if foo_0 in ("condition", "action"):
                self.macro_dict[macro_no].append(_)

    def get_raw_cases(self):
        self.raw_cases = list()
        for foo in os.listdir(self.target_path):
            if not foo.endswith(".csv"):
                continue
            if "case" not in foo:
                continue
            t = get_case_dict(os.path.join(self.target_path, foo))
            for raw_case in t:
                simple_case = dict()
                for k, v in raw_case.items():
                    if not v:
                        continue
                    if k == "Order":
                        continue
                    simple_case[k] = v
                else:
                    self.raw_cases.append(simple_case)

    def write_section_cases(self):
        self.get_final_cases()
        self.final_section_cases = dict()
        for foo in self.final_cases:
            section_name = foo.get("Section", "Test Cases")
            try:
                foo.pop("Section")
            except:
                pass
            self.final_section_cases.setdefault(section_name, list())
            self.final_section_cases[section_name].append(json.dumps(foo))
        case_lines = list()
        for section_name, cases in self.final_section_cases.items():
            case_lines.append("[section {}]".format(section_name))
            case_lines.append("cases = ")
            for bao in cases:
                case_lines.append("     {}".format(bao))
            case_lines.append(";;;;;;;;;; ")
        tools.write_file(self.tmp_ini_file, case_lines, append=True)
        self.file_ini = self.tmp_ini_file

    def get_final_cases(self):
        self.final_cases = list()
        for case in self.raw_cases:
            if not self.macro_dict:
                self.final_cases.append(case.copy())
                continue
            never_matched = 1
            for k, v in self.macro_dict.items():
                # matched?
                matched_list = list()
                try:
                    for foo in v:
                        if foo[0] != "condition":
                            continue
                        _matched = 0
                        now_value = case.get(foo[1])
                        if not now_value:
                            continue
                        this_value = foo[2]
                        this_value = this_value.strip("= ")
                        now_value_list = tools.comma_split(now_value, sep_mark=";")
                        if this_value in now_value_list:
                            _matched = 1
                        matched_list.append(_matched)
                except:
                    pass
                if matched_list:
                    if matched_list.count(0):
                        continue
                else:
                    # TODO: DO NOT add raw case currently
                    continue
                # action!
                never_matched = 0
                new_case = case.copy()
                for foo in v:
                    if foo[0] != "action":
                        continue
                    if foo[1] == "Section":
                        new_case[foo[1]] = foo[2]
                        continue
                    macro_settings = tools.comma_split(foo[2].strip(), sep_mark=";")   # ["aa=1", "bb=2]
                    original_settings = tools.comma_split(new_case.get(foo[1], ""), sep_mark=";")
                    if not original_settings:
                        new_case[foo[1]] = foo[2]
                    else:
                        _macro_dict = self.equal_string_list_to_dict(macro_settings)
                        _original_dict = self.equal_string_list_to_dict(original_settings)
                        new_dict = dict()
                        if foo[1] == self.cmd_key:
                            if _original_dict.get("override", "") == "local":
                                new_dict = _original_dict.copy()
                            else:
                                for kk, vv in _macro_dict.items():
                                    vvv = _original_dict.get(kk, "")
                                    if vvv:
                                        new_dict[kk] = "{} {}".format(vv, vvv)
                                    else:
                                        new_dict[kk] = vv
                                for ik, iv in _original_dict.items():
                                    if ik not in _macro_dict:
                                        new_dict[ik] = iv
                        else:
                            new_dict.update(_macro_dict)
                            for ik, iv in _original_dict.items():
                                if ik not in _macro_dict:
                                    new_dict[ik] = iv
                        _now_keys = new_dict.keys()
                        _now_keys.sort()
                        _show = ["{} = {}".format(k, new_dict.get(k, "")) for k in _now_keys]
                        new_case[foo[1]] = "\n".join(_show)
                self.final_cases.append(new_case)
            if never_matched:
                if not self.macro_only:
                    self.final_cases.append(case.copy())

    @staticmethod
    def equal_string_list_to_dict(equal_string_list):
        p = re.compile("^([^=]+)=(.+)")
        new_dict = dict()
        for es in equal_string_list:
            m = p.search(es)
            if not m:
                LOGGER.error("Unknown action: {}".format(es))
                tools.eexit()
            k = m.group(1).strip()
            v = " ".join(m.group(2).split())
            new_dict[k] = v
        return new_dict

    def upload_suite(self, options):
        for k, v in options.items():
            if "suite " not in k:
                continue
            real_suite_name = f_name(k)
            self.project_id = v.get("project_id")
            if not self.project_id:
                LOGGER.error("Not specified project_id")
                return 1
            suite_id = v.get("suite_id")
            this_data = v.get(self.des_key).strip()
            if not suite_id:
                res = self.db.get(SEL_SUITE_ID.format(real_suite_name, self.project_id))
                if res:
                    suite_id = res.get("suite_id")
                    des = res.get(self.des_key)
                    if des == this_data:
                        self.suite_id = suite_id
                        return
            suite_data = {self.des_key: this_data, "name": real_suite_name}
            if not suite_id:
                LOGGER.info("Will upload a total new suite: {}".format(real_suite_name))
                res = self.tr.send_post("/add_suite/{}".format(self.project_id), suite_data)
                suite_id = res.get("id")
            else:
                LOGGER.info("Will update the suite {}".format(real_suite_name))
                self.tr.send_post("/update_suite/{}".format(suite_id), suite_data)
            self.suite_id = suite_id
            break

    def upload_sections(self, options):
        keys = options.keys()
        keys.sort()
        for k in keys:
            if "suite " in k:
                continue
            v = options[k]
            section_name = f_name(k)
            section_id = v.get("section_id")
            if not section_id:
                res = self.db.get(SEL_SECTION_ID.format(self.suite_id, section_name))
                if res:
                    section_id = res.get("section_id")
            cases_data = self.case_data_parser.get_cases_data(v.get("cases"))
            if not cases_data:
                continue
            if cases_data == 1:
                return 1
            if section_id:
                self.update_this_section(section_name, section_id, cases_data)
            else:
                self.create_this_section(section_name, cases_data)

    def update_this_section(self, section_name, section_id, cases_data):
        LOGGER.info("Update section {}(id:{}) in suite {}".format(section_name, section_id, self.suite_id))
        cases_in_testrail = self.db.query(SEL_CASE_TITLE_ID.format(section_id))
        cases_in_testrail_dict = dict()
        for foo in cases_in_testrail:
            cases_in_testrail_dict[foo.get("title")] = foo
        _keys = cases_in_testrail_dict.keys()
        if len(_keys) != len(set(_keys)):
            LOGGER.error("Found Duplicated title in the current TMP suites")
            return 1
        for title, case_data in cases_data.items():
            if title in cases_in_testrail_dict:
                case_id = cases_in_testrail_dict.get(title).get("id")
                testrail_case_data = cases_in_testrail_dict.get(title)
                if is_same_design(testrail_case_data, case_data):
                    if self.debug:
                        pass
                        # LOGGER.info("Same settings for case {} ({})".format(title, case_id))
                else:
                    LOGGER.info("Update settings for case {} ({})".format(title, case_id))
                    log4u.say_it(case_data, "UPDATE:", show=self.debug)
                    if not self.debug:
                        self.tr.send_post("update_case/{}".format(case_id), case_data)
            else:
                LOGGER.info("create new design {} in section {}".format(title, section_name))
                if not self.debug:
                    self.tr.send_post("add_case/{}".format(section_id), case_data)

        for k, v in cases_in_testrail_dict.items():
            if k not in cases_data:
                case_id = v.get("id")
                LOGGER.info("Deleting case {} ({})".format(k, case_id))
                if not self.debug:
                    self.tr.send_post("delete_case/{}".format(case_id), dict())

    def create_this_section(self, section_name, cases_data):
        LOGGER.info("Start creating a new section {}".format(section_name))
        section_id = 0
        if not self.debug:
            section_data = dict(suite_id=self.suite_id, name=section_name)
            res = self.tr.send_post("add_section/{}".format(self.project_id), section_data)
            if not res:
                LOGGER.error("Failed to create section {}".format(section_name))
                return 1
            section_id = res.get("id")
        if not self.debug:
            if not section_id:
                return
        for title, case_data in cases_data.items():
            LOGGER.info("create new design {}".format(title))
            if not self.debug:
                self.tr.send_post("add_case/{}".format(section_id), case_data)


def is_same_design(old_full_dict, new_dict):
    for k, v in new_dict.items():
        if k not in old_full_dict:
            continue
        old_v = old_full_dict.get(k)
        try:
            old_vv = re.sub("\s+", "", str(old_v))
            vv = re.sub("\s+", "", v)
            if old_vv != vv:
                return 0
        except:
            if old_v != v:
                return 0
    return 1


f_name = lambda x: " ".join(x.split()[1:])


def get_case_dict(csv_file):
    start_tag1 = "Order"
    start_tag2 = "Title"
    tmp_lines = list()
    with open(csv_file) as ob:
        start = 0
        for line in ob:
            if not start:
                line_list = tools.comma_split(line, sep_mark=",")
                if start_tag1 in line_list and start_tag2 in line_list:
                    start = 1
            if start:
                tmp_lines.append(line)
    return csv.DictReader(tmp_lines)


class GetCasesData(object):
    def __init__(self, db):
        self.db = db
        self.get_case_types()
        self.get_fields_system_name()
        self.get_priority_id()
        self.get_type_id()
        self.skip_always = ("Section", "Sorting", "design_name", 'CRs')
        self.custom_config_keys = ("CaseInfo", "Environment", "LaunchCommand", "Software", "System", "Machine")
        self.int_keys = ("custom_fpga_slice", "custom_fpga_pio", "custom_fpga_ebr", "custom_fpga_dsp")

    def get_case_types(self):
        sel_cmd = "SELECT id, name from case_types where is_deleted=0"
        self.case_types = dict()
        for foo in self.db.query(sel_cmd):
            self.case_types[foo.get("name")] = foo.get("id")

    def get_fields_system_name(self):
        sel_cmd = "SELECT system_name, label from fields where is_active=1 and entity_id=1"
        self.fields_system_name = dict()
        for foo in self.db.query(sel_cmd):
            self.fields_system_name[foo.get("label")] = foo.get("system_name")

    def get_priority_id(self):
        sel_cmd = "SELECT id, name from priorities"
        self.priorities = dict()
        for foo in self.db.query(sel_cmd):
            self.priorities[foo.get("name")] = foo.get("id")

    def get_type_id(self):
        sel_cmd = "SELECT id, name from case_types where is_deleted=0"
        self.types = dict()
        for foo in self.db.query(sel_cmd):
            self.types[foo.get("name")] = foo.get("id")

    def get_cases_data(self, cases_str):
        self.cases_data = OrderedDict()
        for one_case in cases_str.split("\n"):
            one_case = one_case.strip()
            if not one_case:
                continue
            t_c = self.get_title_case_data(one_case)
            if not t_c:
                return
            title, case_data = t_c
            if title in self.cases_data:
                LOGGER.error("Duplicated title {} !!!".format(title))
                return 1
            self.cases_data[title] = case_data
        return self.cases_data

    def get_title_case_data(self, one_case):
        raw_dict = json.loads(one_case)
        if "Title" not in raw_dict:
            raw_dict["Title"] = raw_dict.get("design_name")
        case_data = dict()
        ks = raw_dict.keys()
        ks.sort()
        for k in ks:
            v = raw_dict.get(k)
            if k in self.skip_always:
                continue
            if k == "Title":
                _title_is = raw_dict.get("Title")
                if _title_is is None:
                    return ""
                case_data["title"] = raw_dict.get("Title").strip()
                self.get_config(raw_dict)
                case_data["custom_config"] = self.config
            else:
                if k in self.fields_system_name:
                    case_data[self.fields_system_name[k]] = v
                elif k.lower() == "type":
                    type_id = self.types.get(v)
                    if type_id:
                        case_data["type_id"] = type_id
                    else:
                        LOGGER.warning("Unknown Type name: {} for {}".format(v, raw_dict))
                elif k == "Priority":
                    p_id = self.priorities.get(v)
                    if p_id:
                        case_data["priority_id"] = p_id
                    else:
                        LOGGER.warning("Unknown Priority name: {} for {}".format(v, raw_dict))
        # automated and nouse
        key_no_use = "custom_nouse"
        if case_data.get(key_no_use, "") != "YES":
            case_data[key_no_use] = "NO"
        key_automated = "custom_automated"
        if case_data.get(key_automated, "") != "NO":
            case_data[key_automated] = "YES"
        key_smoke = "custom_smoke"
        if case_data.get(key_smoke, "") != "YES":
            case_data[key_smoke] = "NO"
        for int_key in self.int_keys:
            this_value = case_data.get(int_key)
            if this_value:
                try:
                    int(this_value)
                except:
                    _ = re.sub("level", "", this_value)
                    try:
                        tt = int(_)
                        case_data[int_key] = str(tt)
                    except:
                        LOGGER.warning("{} is {}, not an integer".format(int_key, this_value))
                        case_data.pop(int_key)
        get_drop_down_value(case_data)
        return case_data["title"], case_data

    def get_config(self, raw_dict):
        _config = list()
        _design_name = "design_name = {}".format(raw_dict.get("design_name"))
        if "CaseInfo" not in raw_dict:
            raw_dict["CaseInfo"] = _design_name
        else:
            raw_info = raw_dict.get("CaseInfo")
            raw_info_list = tools.comma_split(raw_info, sep_mark="\n")
            for foo in raw_info_list:
                if foo.startswith("design_name"):
                    break
            else:
                raw_info_list.insert(0, _design_name)
            raw_dict["CaseInfo"] = "\n".join(raw_info_list)

        for k in self.custom_config_keys:
            v = raw_dict.get(k)
            if v:
                _config.append("[{}]".format(k))
                v_list = tools.comma_split(v, sep_mark=";")
                _config.extend(v_list)
        self.config = "\n".join(_config)


def get_case_data(one_case):
    raw_dict = json.loads(one_case)
    testrail_case_data = dict()
    testrail_case_data["title"] = raw_dict.get("title")
    return raw_dict


def get_short_content(raw_dict):
    _ = list()
    for item in ("0", "1", "2"):
        vv = raw_dict.get(item)
        if vv:
            vv = vv.strip()
        else:
            vv = ""
        _.append(vv)
    return _


if __name__ == "__main__":
    my_upload = UploadSuites()
    my_upload.process()
