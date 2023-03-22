#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 8:54 AM 11/1/2021
  file: xUtils.py
  author: Shawn Yan
Description:

"""
import os
import re
import csv
from openpyxl.utils import get_column_letter
from collections import OrderedDict
from capuchin import xTools
from . import xExcel
from . import xOptions
from . import xDump

SELECT_RUN_ID_ATTRIBUTES = "SELECT id, name, is_plan, plan_id FROM runs WHERE id={pr_id}"
SELECT_PLAN_NAME = "SELECT id, name FROM runs WHERE id={plan_id} and is_plan=1"
SELECT_RUNS_BY_PLAN_ID = "SELECT id, name FROM runs WHERE plan_id={plan_id}"
SELECT_WITH_DETAIL = """
SELECT
    CONCAT('T', A.id) AS xTestID,
    A.case_id AS xCaseID,
    B.section_id AS xSectionID,
    C.name AS xSectionName,
    B.title AS xRawCase,
    D.label AS xStatusName,
    E.*
FROM
    tests A
LEFT JOIN cases B ON
    B.id = A.case_id
LEFT JOIN sections C ON
    C.id = B.section_id
LEFT JOIN statuses D ON
    A.status_id = D.id
LEFT JOIN(
    SELECT
        *
    FROM
        lrf.run_{run_id}
    WHERE
        {sort_key} IN(
        SELECT
            MAX({sort_key})
        FROM
            lrf.run_{run_id}
        GROUP BY
            testId
    )
) E
ON
    E.testId = A.id
WHERE
    A.run_id = {run_id} AND A.is_selected = 1 AND(
        B.`custom_nouse` = 1 OR B.`custom_nouse` IS NULL
    )
ORDER BY
    xSectionID,
    xTestID
"""
SELECT_WITHOUT_DETAIL = """
SELECT
    CONCAT('T', A.id) AS xTestID,
    A.case_id AS xCaseID,
    B.section_id AS xSectionID,
    C.name AS xSectionName,
    B.title AS xRawCase,
    D.label AS xStatusName
FROM
    tests A
LEFT JOIN cases B ON
    B.id = A.case_id
LEFT JOIN sections C ON
    C.id = B.section_id
LEFT JOIN statuses D ON
    A.status_id = D.id
WHERE
    A.run_id = {run_id} AND A.is_selected = 1 AND(
        B.`custom_nouse` = 1 OR B.`custom_nouse` IS NULL
    )
ORDER BY
    xSectionID,
    xTestID
"""


def space2underline(raw_string):
    return re.sub(r"\s+", "_", raw_string)


def get_real_titles(raw_list, for_database=True):
    """
    link the title names in common report and database
    for example: Design in common report and design in database
    """
    # name_change_dict = dict(design="Design", version="Version", device="Device")
    name_change_dict = dict(design="Design")
    new_list = list()
    for foo in raw_list:
        foo_lower = foo.lower()
        if foo_lower in name_change_dict:
            if for_database:
                new_list.append(foo_lower)
            else:
                new_list.append(name_change_dict.get(foo_lower))
        else:
            new_list.append(foo)
    skip_when_dump_jason_string = "created_on"
    if skip_when_dump_jason_string in new_list:
        new_list.remove(skip_when_dump_jason_string)
    return new_list


def get_real_list(general_conf_dict, higher_dict, base_dict, keys, default_string=""):
    my_string = default_string

    for k in keys:
        v = higher_dict.get(k)
        if v:
            my_string = v
            break
    else:
        for k in keys:
            v = base_dict.get(k)
            if v:
                my_string = v
                break
    if "_titles" in keys[0]:
        # titles can a be config name which can be found in report_cong.ini, or like "LUT,Register"
        list_in_conf = general_conf_dict.get(my_string)
        if list_in_conf:
            my_string = list_in_conf
    if isinstance(my_string, list):
        return my_string
    return xTools.comma_split(my_string)


def get_design_names(original_data, case_group_name, src_designs, dst_designs):
    """
    If there are very same few common designs in src_designs and dst_designs,
    will return common designs + src_designs + dst_designs
    """
    if case_group_name:
        if case_group_name in original_data:
            return original_data.get(case_group_name)
        else:
            print("Warning. unknown case's group name: {}".format(case_group_name))
    set_src = set(src_designs)
    set_dst = set(dst_designs)
    set_common = set_src & set_dst
    design_names = list()
    if len(set_common) < min(len(set_src), len(set_dst)) / 3:
        for k in src_designs:
            if k in set_common:
                design_names.append(k)
        for k in src_designs:
            if k not in set_common:
                design_names.append(k)
        for k in dst_designs:
            if k not in set_common:
                design_names.append(k)
    else:
        design_names = src_designs[:]
        for i, k in enumerate(dst_designs):
            if k not in design_names:
                design_names.insert(i, k)
    return design_names


def string_2_int_float_percentage(raw_string):
    if not raw_string:
        return "NA", False
    if raw_string == "None":
        return "NA", False
    if not isinstance(raw_string, str):
        return raw_string, False
    p_float = re.compile(r"^\d+\.\d+$")
    p_percentage = re.compile(r"^([\d.]+)%$")
    raw_string = raw_string.strip()
    m_percentage = p_percentage.search(raw_string)
    if m_percentage:
        return float(m_percentage.group(1)) / 100, True
    if p_float.search(raw_string):
        return float(raw_string), False
    else:
        if raw_string.isdigit():
            return int(raw_string), False
    return raw_string, False


def get_raw(data_name, whole_dict, all_data, force_dump, say_error, raw_only=False):
    class GetRealData(object):
        def __init__(self):
            names = dict(SRC=("src", "src_section"), DST=("dst", "dst_section"))
            self.now_name, self.now_sections = [whole_dict.get(foo) for foo in names.get(data_name)]
            self.default_conf_path = whole_dict.get("default_conf_path")
            self.report_conf = whole_dict.get("report_conf")
            self.output = whole_dict.get("output")

        def get_csv_data_alike(self):
            file_root_path = os.path.dirname(self.report_conf) if self.report_conf else ""
            _recovery = xTools.ChangeDir(file_root_path) if file_root_path else None
            file_name, sheet_name = self.get_file_sheet_name()
            if _recovery:
                _recovery.comeback()
            unique_key = "{}::{}".format(file_name, sheet_name)
            if unique_key in all_data:  # same file, different section data, to save time
                return all_data.get(unique_key)
            if isinstance(file_name, int):
                temp_xlsx = "temp_data_{}.xlsx".format(file_name)
                abs_temp_xlsx = os.path.join(self.output, "temp_files", temp_xlsx)
                if force_dump or (not os.path.isfile(abs_temp_xlsx)):
                    self.dump_data_from_db(file_name, temp_xlsx)
                file_name = abs_temp_xlsx
            new_data = list()
            if file_name.endswith(".csv"):
                with open(file_name) as ob:
                    csv_dict = csv.DictReader(ob)
                    for foo in csv_dict:
                        new_data.append(foo)
            else:
                excel_reader = xExcel.Excel2csv()
                excel_reader.process(file_name, sheet_name)
                raw_return_data = excel_reader.get_csv_dict_alike()
                assert len(raw_return_data) == 1, "Get more than 1 sheet data from {}::{}".format(file_name, sheet_name)
                for _k, _v in list(raw_return_data.items()):
                    new_data = _v
            all_data[unique_key] = new_data  # in case of parsing it twice
            return new_data

        def get_file_sheet_name(self):
            file_name, sheet_name = None, None
            p_excel_sheet = re.compile("(.+)::(.+)")
            if os.path.isfile(self.now_name):
                file_name = os.path.abspath(self.now_name)
            else:
                try:
                    x = int(self.now_name)
                    file_name = x
                except ValueError:
                    m_excel_sheet = p_excel_sheet.search(self.now_name)
                    if m_excel_sheet:
                        file_name, sheet_name = m_excel_sheet.group(1), m_excel_sheet.group(2)
                    else:
                        say_error("@E: Unknown src or dst value: {}".format(self.now_name))
            if file_name and isinstance(file_name, str):
                file_name = os.path.abspath(file_name)
            assert file_name is not None, "Failed to get data by {}".format(self.now_name)
            return file_name, sheet_name

        def dump_data_from_db(self, run_id, temp_xlsx):
            dump_options = xOptions.XOptions(self.default_conf_path)
            dump_args = ["dump", "-i", str(run_id), "-o", os.path.join(self.output, "temp_files"), "-e", temp_xlsx]
            dump_options_ns = dump_options.get_options_ns(dump_args)
            dump_options_ns.root_file = ""  # for debug only, previous dump_args DO NOT has --debug
            dump_flow = xDump.DataDump(dump_options_ns)
            dump_flow.process()

        def process(self, csv_data_alike):
            if raw_only:
                return csv_data_alike
            design_data = OrderedDict()
            for foo in csv_data_alike:
                if self.now_sections:
                    my_section = foo.get("xSectionName")
                    if my_section not in self.now_sections:
                        continue
                my_design = foo.get("Design")
                if not my_design:
                    say_error("@E: Failed to get data from {}".format(foo))
                    continue
                my_design = os.path.basename(my_design)
                if my_design in design_data:
                    say_error("@W: duplicated {} in {}:{}".format(my_design, self.now_name, self.now_sections))
                else:
                    design_data[my_design] = foo
            return design_data

    extractor = GetRealData()
    full_csv_data = extractor.get_csv_data_alike()
    return extractor.process(full_csv_data)


def get_range_formula(compare_list, formula_range):
    if not formula_range:
        return "-"
    formula_range_list = xTools.comma_split(formula_range)
    if len(compare_list) == 1:
        final_formula = ['COUNTIF({}, "{}")'.format(foo, compare_list[0]) for foo in formula_range_list]
    else:
        final_formula = ['COUNTIFS({0}, "{1}", {0}, "{2}")'.format(foo, compare_list[0], compare_list[1])
                         for foo in formula_range_list]
    return "={}".format("+".join(final_formula))


def extract_original_summary_data(excel_data_dict):
    temp_summary_data = OrderedDict()
    vendor_tool_versions = set()
    now_version_keys = ("version", "#version")
    for sheet_name, ready_data in list(excel_data_dict.items()):
        group_name = ready_data.get("group_name", "GroupName")
        sub_name = ready_data.get("sub_name", "SubName")
        temp_summary_data.setdefault(group_name, OrderedDict())
        x = temp_summary_data[group_name][sub_name] = OrderedDict()
        _f, _w = ready_data.get("failed_cases_number"), ready_data.get("whole_cases_number")
        _s = ready_data.get("skipped_cases_number")
        x["failed_number"], x["whole_number"] = _f, _w
        x["skipped_number"] = _s
        x["sheet_name"] = sheet_name
        row_data_dict = ready_data.get("row_data")
        for kk, vv in list(row_data_dict.items()):
            if kk == "AVERAGE" or "change " in kk:
                for vs_title, vs_content in list(vv.items()):
                    if not vs_title.startswith('VS_'):
                        continue
                    x.setdefault(vs_title, dict())
                    x[vs_title][kk] = vv.get(vs_title).get("cell_range")
            else:
                if not kk.startswith("ID_"):
                    continue
                for version_key in now_version_keys:
                    my_version = vv.get(version_key)
                    if my_version:
                        version_string = my_version.get("value")
                        if version_string != "NA":
                            vendor_tool_versions.add(version_string)
    v_t_v = list(vendor_tool_versions)
    v_t_v.sort()
    return temp_summary_data, v_t_v


def row_col_loc(row_col_dict):
    x = get_column_letter(row_col_dict.get("column"))
    return "!{}{}".format(x, row_col_dict.get("row"))


class CreateSummaryCells(object):
    def __init__(self, original_summary_data):
        self.original_summary_data = original_summary_data

    def process(self):
        self.get_left_max_width()
        self.value_dict = OrderedDict()
        self.add_left_table()
        self.add_right_table()

    def add_left_table(self):
        for group_number, (g_name, g_data) in enumerate(list(self.original_summary_data.items())):
            value_list = list()
            self.tmp_vs_titles = self.get_vs_titles(g_data)
            self.tmp_left_min_height = self.get_left_min_height(g_data)
            x = ["Group{}".format(group_number), g_name]
            value_list.append(x)
            x = ["Pass/Skipped/Total", self.get_pass_total(g_data), ""] + self.get_sub_and_link(g_data) + ["Average"]
            value_list.append(x)
            for t in self.tmp_vs_titles:
                x = ["", "", t]
                for foo, bar in list(g_data.items()):
                    x.append("='{}'{}".format(bar.get("sheet_name"), row_col_loc(bar.get(t).get("AVERAGE"))))
                x.append(self.average_and_average(g_data))
                value_list.append(x)
            # at least 9 rows
            now_row_number = len(value_list)
            for i in range(now_row_number, max(9, now_row_number+2)):
                value_list.append(list())
            self.change_height_and_width(value_list)
            self.value_dict[g_name] = value_list

    @staticmethod
    def average_and_average(g_data):
        numerator_list, denominator_list = list(), list()
        for i, (sub_name, sub_data) in enumerate(list(g_data.items())):
            fn, wn = sub_data.get("failed_number"), sub_data.get("whole_number")
            sn = sub_data.get("skipped_number")
            pn = wn - fn - sn
            if pn <= 0:
                continue
            denominator_list.append(str(pn))
            numerator_list.append("_{}_*{}".format(len(g_data) - i, pn))
        if not denominator_list:
            return "-"
        return "NEW_AVERAGE:::{}:::{}".format(" + ".join(numerator_list), " + ".join(denominator_list))

    @staticmethod
    def get_sub_and_link(g_data):
        sub_names = list()
        for k, v in list(g_data.items()):
            sub_name = k
            sheet_name = v.get("sheet_name")
            sub_names.append("LINK::::{}::::{}".format(sub_name, sheet_name))
        return sub_names

    def get_left_max_width(self):
        _max = 0
        for g_name, g_data in list(self.original_summary_data.items()):
            _max = max(_max, len(g_data))
        self.left_max_width = _max + 7

    @staticmethod
    def get_vs_titles(g_data):
        for sub_name, sub_data in list(g_data.items()):
            _titles = list()
            for k, v in list(sub_data.items()):
                if k.startswith("VS_"):
                    _titles.append(k)
            return _titles

    @staticmethod
    def get_pass_total(g_data):
        _f, _t, _s = 0, 0, 0
        for k, v in list(g_data.items()):
            _f += v.get("failed_number")
            _t += v.get("whole_number")
            _s += v.get("skipped_number")
        return "{}/{}/{}".format(_t - _f, _s, _t)

    def get_left_min_height(self, g_data):
        vs_titles = self.get_vs_titles(g_data)
        return max(6, len(vs_titles)) + 2

    def change_height_and_width(self, value_list):
        for foo in value_list:
            new_blank = self.left_max_width - len(foo)
            if new_blank > 0:
                foo.extend([""] * new_blank)
        new_row = self.tmp_left_min_height - len(value_list)
        if new_row > 0:
            value_list.extend([""] * new_row)

    def get_real_value_list(self):
        v_list = list()
        for k, v in list(self.value_dict.items()):
            v_list.extend(v)
        return v_list

    def add_right_table(self):
        for g_name, g_data in list(self.original_summary_data.items()):
            old_values = self.value_dict.get(g_name)
            vs_titles = self.get_vs_titles(g_data)
            old_values[1].extend([""] + vs_titles)
            range_name_list = self.get_range_names(g_data, vs_titles[0])
            for i, range_name in enumerate(range_name_list):
                t_list = old_values[i + 2]
                if not isinstance(t_list, list):
                    continue
                t_list.append(range_name)
                for vt in vs_titles:
                    cell_position = list()
                    for sub_name, sub_data in list(g_data.items()):
                        vt_data = sub_data.get(vt)
                        range_row_col = vt_data.get(range_name)
                        cell_position.append("'{}'{}".format(sub_data.get("sheet_name"), row_col_loc(range_row_col)))
                    t_list.append("=SUM({})".format(",".join(cell_position)))

    @staticmethod
    def get_range_names(g_data, a_title):
        rn_list = list()
        for sub_name, sub_data in list(g_data.items()):
            title_data = sub_data.get(a_title)
            for _t, _change in (title_data.items()):
                if "change " in _t:
                    rn_list.append(_t)
            return rn_list


def get_value_list(original_summary_data):
    gv = CreateSummaryCells(original_summary_data)
    gv.process()
    return gv.get_real_value_list()


def get_real_list_from_set(whole_list, sub_set):
    real_list = list()
    for foo in whole_list:
        if foo in sub_set:
            real_list.append(foo)
    return "_".join(real_list)


def get_vs_name(sheet_pos_idx, src_name, dst_name):
    if not src_name:
        return dst_name
    if not dst_name:
        return src_name
    src_list = re.split("_", src_name)
    dst_list = re.split("_", dst_name)
    src_set, dst_set = set(src_list), set(dst_list)
    same_items = src_set & dst_set
    left_vs = dst_set - src_set
    right_vs = src_set - dst_set
    name1 = get_real_list_from_set(src_list, same_items)
    name2 = get_real_list_from_set(dst_list, left_vs)
    name3 = get_real_list_from_set(src_list, right_vs)
    if name2 or name3:
        name23 = "_{}VS{}".format(name2, name3)
    else:
        name23 = ""
    if sheet_pos_idx is None:
        return "{}{}".format(name1, name23)
    name23_lens = len(name23)
    if name23_lens > 30:
        return "{}{}".format(sheet_pos_idx, name23[:28])
    else:
        name1_lens = len(name1)
        if name1_lens + name23_lens > 27:
            name1 = re.sub("_", "", name1)
        name1_lens = len(name1)
        if name1_lens + name23_lens > 25:
            name1 = name1[:25-name23_lens]
        final_name = "{}_{}{}".format(sheet_pos_idx, name1, name23)
        return final_name
