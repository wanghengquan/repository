#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 3:47 PM 12/1/2021
  file: xDump.py
  author: Shawn Yan
Description:

"""
import os
import json
from collections import OrderedDict
from capuchin import xTools
from capuchin import xDatabase
from .xOptions import DeployOptions
from .xExcel import set_cell_value
from .xExcel import BasicExcel
from . import xUtils


class DataDump(DeployOptions):
    def __init__(self, opts_ns):
        super(DataDump, self).__init__(opts_ns)
        self.db = xDatabase.get_db_link()
        self.csv_files = list()

    def process(self):
        self.say_info("Try to dump data from database ...")
        if self.deploy_options():
            return 1
        self.get_plan_run_id_name_dict()
        self.query_data()
        if self.output_excel:
            self.export2xlsx()
        else:
            self.export2csv()

    def get_plan_run_id_name_dict(self):
        """
        key: run_id
        value: run_id, run_name, plan_name, plan_id
        """
        self.plan_run_dict = dict()
        for pr_id in self.plan_run_id:
            ret1 = self.db.get(xUtils.SELECT_RUN_ID_ATTRIBUTES.format(pr_id=pr_id))
            if not ret1:
                self.say_error("Not found plan/run ID: {}".format(pr_id))
                continue
            raw_name, raw_id = ret1.get("name"), ret1.get("id")
            if ret1.get("is_plan"):
                plan_name, plan_id = raw_name, raw_id
                ret2 = self.db.query(xUtils.SELECT_RUNS_BY_PLAN_ID.format(plan_id=plan_id))
                for foo in ret2:
                    key = foo.get("id")
                    value = dict(run_id=key, run_name=foo.get("name"), plan_name=plan_name, plan_id=plan_id)
                    self.plan_run_dict[key] = value
            else:
                run_name, run_id = raw_name, raw_id
                plan_id = ret1.get("plan_id")
                if plan_id:
                    ret3 = self.db.get(xUtils.SELECT_PLAN_NAME.format(plan_id=plan_id))
                    plan_name = ret3.get("name")
                else:
                    plan_name = ""
                key = run_id
                value = dict(run_id=run_id, run_name=run_name, plan_name=plan_name, plan_id=plan_id)
                self.plan_run_dict[key] = value
        self.say_debug(json.dumps(self.plan_run_dict, indent=2), comments="Plan/Run Dictionary:", debug=self.debug)

    def query_data(self):
        """
        query data by run_id, if not found lrf.run_x, will try to execute another sql command
        """
        for run_id, v in list(self.plan_run_dict.items()):
            sql_commands = (xUtils.SELECT_WITH_DETAIL.format(sort_key=self.sort_key, run_id=run_id),
                            xUtils.SELECT_WITHOUT_DETAIL.format(run_id=run_id))
            for _cmd in sql_commands:
                try:
                    ret = self.db.query(_cmd)
                    if ret:
                        self.plan_run_dict[run_id]["db_data"] = ret  # update to dictionary
                        break
                except:
                    self.say_traceback()
            else:
                self.say_error("Error. Failed to dump data for Run {}".format(run_id))

    def _yield_name_and_data(self, for_csv=True):
        """
        yield sheet/file name and detail data
        """
        content_keys = ("plan_id", "plan_name", "run_id", "run_name")
        for k, v in list(self.plan_run_dict.items()):
            titles, file_ob_dict = "", dict()
            if self.fields:
                titles = self.fields
                titles = xUtils.get_real_titles(titles, for_database=True)
            name_long, name_short = self._get_names(v)
            raw_data = v.get("db_data")
            if not titles:
                titles = xUtils.get_real_titles(list(raw_data[0].keys()), for_database=True)

            content_data = dict(zip(content_keys, [v.get(foo) for foo in content_keys]))
            for d in raw_data:
                if self.apart_by_section:
                    if for_csv:
                        file_sheet_name = "{}_Section_{}.csv".format(name_short, d.get("xSectionName"))
                    else:
                        file_sheet_name = "{}_{}".format(name_short, d.get("xSectionName"))
                        if len(file_sheet_name) > 30:
                            file_sheet_name = "{}_Section_{}".format(name_short, d.get("xSectionID"))
                else:
                    if for_csv:
                        file_sheet_name = name_long + ".csv"
                    else:
                        file_sheet_name = name_short
                values = [set_cell_value(d.get(foo), for_csv=for_csv) for foo in titles]
                if self.section:
                    if d.get("xSectionName") not in self.section:
                        continue
                yield dict(name=file_sheet_name, titles=xUtils.get_real_titles(titles, for_database=False),
                           values=values, content_data=content_data, section_name=d.get("xSectionName"))

    @staticmethod
    def _get_names(d):
        in_plan = d.get("plan_id")
        _long, _short = "Run{run_id}_{run_name}", "R{run_id}"
        if in_plan:
            _long = "Plan{plan_id}_{plan_name}_" + _long
            _short = "P{plan_id}_" + _short
        _long, _short = _long.format(**d), _short.format(**d)
        return xUtils.space2underline(_long), xUtils.space2underline(_short)

    def export2csv(self):
        file_and_ob_dict = dict()
        for n_d in self._yield_name_and_data(for_csv=True):
            filename, titles, values = n_d.get("name"), n_d.get("titles"), n_d.get("values")
            if filename in file_and_ob_dict:
                file_ob = file_and_ob_dict.get(filename)
            else:
                abs_file = os.path.join(self.output, filename)
                self.csv_files.append(abs_file)
                file_ob = open(abs_file, "w")
                file_and_ob_dict[filename] = file_ob
                print(",".join(titles), file=file_ob)
            print(",".join(values), file=file_ob)

        for ff, fo in list(file_and_ob_dict.items()):
            fo.close()

    def export2xlsx(self):
        self.local_excel = BasicExcel()
        self.font_bold = self.local_excel.font_bold
        self.font_link = self.local_excel.font_link
        self.alignment_center = self.local_excel.alignment_center
        sheet_row_dict = OrderedDict()
        for n_d in self._yield_name_and_data(for_csv=False):
            sheet_name, titles, values = n_d.get("name"), n_d.get("titles"), n_d.get("values")
            now_ws_list = sheet_row_dict.get(sheet_name)
            if not now_ws_list:
                now_ws = self.local_excel.wb.create_sheet(sheet_name)
                row_data = list()
                for i, t in enumerate(titles):
                    row_data.append(dict(value=t, cell_range=dict(row=1, column=i+1),
                                         font=self.font_bold, alignment=self.alignment_center))
                self.local_excel.write_row_cells(now_ws, row_data)
                now_ws.freeze_panes = "F2"
                sheet_row_dict[sheet_name] = [now_ws, n_d.get("content_data"), n_d.get("section_name")]
            else:
                now_ws = now_ws_list[0]
            now_ws.append(values)
        self._write_content_sheet(sheet_row_dict)
        output_excel_file = os.path.splitext(self.output_excel)[0]
        output_excel_file = xTools.get_real_path(output_excel_file, self.output)
        self.local_excel.save_to_excel(output_excel_file + ".xlsx")

    def _write_content_sheet(self, sheet_row_dict):
        if len(sheet_row_dict) == 1:
            return
        content_ws = self.local_excel.wb.create_sheet("Content", 0)
        content_titles = ["Sheet Name", "Plan ID", "Plan Name", "Run ID", "Run Name"]
        if self.apart_by_section:
            content_titles.append("Section Name")
        row_data = list()
        for i, t in enumerate(content_titles):
            row_data.append(dict(cell_range=dict(row=1, column=i + 1), value=t, alignment=self.alignment_center,
                                 font=self.font_bold, border=self.local_excel.borders_lrtb["1111"]))
        self.local_excel.write_row_cells(content_ws, row_data)
        row = 1
        longest_plan_name = longest_run_name = longest_section_name = 13
        for k, v in list(sheet_row_dict.items()):
            row += 1
            detail_data = list()
            detail_data.append(dict(cell_range=dict(row=row, column=1), value=k, hyperlink="#'{}'!A1".format(k),
                                    font=self.font_link))
            pr_data, section_name = v[1], v[2]
            detail_data.append(dict(cell_range=dict(row=row, column=2), value=pr_data.get("plan_id")))
            detail_data.append(dict(cell_range=dict(row=row, column=3), value=pr_data.get("plan_name")))
            detail_data.append(dict(cell_range=dict(row=row, column=4, value=pr_data.get("run_id"))))
            detail_data.append(dict(cell_range=dict(row=row, column=5), value=pr_data.get("run_name")))
            if self.apart_by_section:
                detail_data.append(dict(cell_range=dict(row=row, column=6), value=section_name))
            longest_plan_name = max(longest_plan_name, len(pr_data.get("plan_name")))
            longest_run_name = max(longest_run_name, len(pr_data.get("run_name")))
            longest_section_name = max(longest_section_name, len(section_name))
            for foo in detail_data:
                foo["border"] = self.local_excel.borders_lrtb["0000"]
            self.local_excel.write_row_cells(content_ws, detail_data)
        #
        self.local_excel.set_column_width(content_ws, 1, 32)
        self.local_excel.set_column_width(content_ws, 3, 2 + longest_plan_name)
        self.local_excel.set_column_width(content_ws, 5, 2 + longest_run_name)
        self.local_excel.set_column_width(content_ws, 6, 2 + longest_section_name)

