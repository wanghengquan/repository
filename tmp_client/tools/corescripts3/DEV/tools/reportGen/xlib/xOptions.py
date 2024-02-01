#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 3:41 PM 12/1/2021
  file: xOptions.py
  author: Shawn Yan
Description:

"""
import copy
import os
import argparse
from capuchin import xTools
from capuchin import xLogger


class XOptions(object):
    def __init__(self, default_conf_path):
        self.default_conf_path = default_conf_path

    def get_options_ns(self, args=None):
        """ get option's NameSpace"""
        parser = argparse.ArgumentParser()
        self.operation_parser = parser.add_subparsers(help="Operation", required=True)
        self._set_dump_parser()
        self._set_report_parser()
        opts = parser.parse_args(args)
        opts.default_conf_path = self.default_conf_path
        return opts

    def _set_dump_parser(self):
        x = self.operation_parser.add_parser("dump", help="Dump data from TMP database")
        self.__general_options(x)
        x.add_argument("-i", "--plan-run-id", required=True, type=int, nargs="+", help="specify test plan/run id(s)")
        x.add_argument("-s", "--section", nargs="+", help="specify suite's section name(s)")
        x.add_argument("-t", "--fields", help="dump data in fields only. fields list was defined in dump-configuration")
        _h = "dump test data into different file which is apart by section name"
        x.add_argument("-a", "--apart-by-section", action="store_true", help=_h)
        x.add_argument("--sort-key", choices=("id", "fmax"), help="specify sort key for case data, default is id")
        x.add_argument("-CDI", "--custom-dump-ini", help="specify custom dump.ini file")
        x.add_argument("--sha", action="store_true", help="generate SHA1-Comparison sheets")
        x.add_argument("--simple", action="store_true", help="do not dump runtime/memory data for checking SHA1 code")
        x.set_defaults(op_dump=True, op_report=False, export_type="csv", sort_key='id')

    def _set_report_parser(self):
        y = self.operation_parser.add_parser("report", help="generate Excel report file")
        self.__general_options(y)
        y.add_argument("-f", "--report-conf", nargs="+", help="specify report configuration file(s)")

        y.add_argument("-a", "--src", help="specify source report file or source run id")
        y.add_argument("-b", "--dst", help="specify destination report file or destination run id")
        y.add_argument("--src-name", help="specify source name, will be shown in Excel")
        y.add_argument("--dst-name", help="specify destination name, will be shown in Excel")

        y.add_argument("--src-section", nargs="+", help="specify source data section")
        y.add_argument("--dst-section", nargs="+", help="specify destination data section")
        _hlp = "specify section, will be used as src_section or dst_section ONLY when they are not specified."
        y.add_argument("--section", nargs="+", help=_hlp)

        y.add_argument("--src-titles", help="specify source data titles")
        y.add_argument("--dst-titles", help="specify destination data titles")
        _hlp = "specify titles, will be used as src_titles or dst_titles ONLY when they are not specified."
        y.add_argument("--titles", help=_hlp)
        y.add_argument("--compare-titles", help="specify compare titles")

        y.add_argument("--group-name", help="specify group name in summary sheet")
        y.add_argument("--sub-name", help="specify sub name in summary sheet")
        y.add_argument("--sheet-name", help="specify sheet name, should be less than 31 characters")

        _c_c, _help = ("AVERAGE", "STDEVPA", "GEOMEAN"), "specify statistical method(s)"
        y.add_argument("-c", "--calculate", choices=_c_c, nargs="+", help=_help)
        y.add_argument("--case-group-name", help="specify ordered cases group name")
        y.add_argument("--force", action="store_true", help="dump report from database by force")
        y.add_argument("--add-test-id", action="store_true", help="add column xTestID in final report")
        y.add_argument("--no-ad-data", action="store_true", help="Do not show AD_xxx data")

        y.set_defaults(op_dump=False, op_report=True, calculate=["AVERAGE"],
                       src_section=list(), dst_section=list(), section=list(),
                       output_excel="final_report.xlsx")

    @staticmethod
    def __general_options(branch_parser):
        branch_parser.add_argument("-d", "--debug", action="store_true", help="print debug message")
        branch_parser.add_argument("-o", "--output", default=os.getcwd(), help="specify output directory")
        branch_parser.add_argument("-e", "--output-excel", help="specify output Excel file name")
        branch_parser.add_argument("--use-all-data", action="store_true", help="try to use all available result data")
        branch_parser.add_argument("--best-fmax", action="store_true", help="select the best fmax value for a design")


class DeployOptions(xLogger.Voice):
    def __init__(self, opts):
        self.opts = opts
        self.debug = self.opts.debug
        self.output = self.opts.output
        self.root_file = self.opts.root_file
        logger = xLogger.create_flow_logger_by_itself(self.root_file) if self.debug else None
        super(DeployOptions, self).__init__(logger)

    def deploy_options(self):
        self.default_conf_path = self.opts.default_conf_path
        if self._get_default_conf_options():
            return 1
        self.use_all_data = self.opts.use_all_data
        self.best_fmax = self.opts.best_fmax
        if self.opts.op_dump:
            self.plan_run_id = self.opts.plan_run_id
            self.section = self.opts.section
            self.fields = self.opts.fields
            self.apart_by_section = self.opts.apart_by_section
            self.output_excel = self.opts.output_excel
            self.custom_dump_ini = self.opts.custom_dump_ini
            self.sort_key = self.opts.sort_key
            self.report_conf_file_list = None  # for report only
            self.sha = self.opts.sha
            self.simple = self.opts.simple
            if self.sha:
                if not self.output_excel:
                    self.output_excel = "Raw_SHA1_sheets"
            if self.__reset_fields():
                return 1
        if self.opts.op_report:
            self.report_conf_file_list = self.opts.report_conf
            self.src = self.opts.src
            self.dst = self.opts.dst
            self.src_name = self.opts.src_name
            self.dst_name = self.opts.dst_name

            self.src_section = self.opts.src_section
            self.dst_section = self.opts.dst_section
            self.section = self.opts.section
            self.opts.src_section = self.src_section = self.src_section if self.src_section else self.section
            self.opts.dst_section = self.dst_section = self.dst_section if self.dst_section else self.section
            self.opts.section = None

            self.src_titles = self.opts.src_titles
            self.dst_titles = self.opts.dst_titles
            self.titles = self.opts.titles
            self.opts.src_titles = self.src_titles = self.src_titles if self.src_titles else self.titles
            self.opts.dst_titles = self.dst_titles = self.dst_titles if self.dst_titles else self.titles
            self.opts.titles = None

            self.compare_titles = self.opts.compare_titles

            self.group_name = self.opts.group_name
            self.sub_name = self.opts.sub_name
            self.sheet_name = self.opts.sheet_name

            self.calculate = self.opts.calculate
            self.case_group_name = self.opts.case_group_name
            self.force = self.opts.force
            self.add_test_id = self.opts.add_test_id
            self.output_excel = self.opts.output_excel
            self.no_ad_data = self.opts.no_ad_data

        if self._prepare_output_path():
            return 1
        if self.report_conf_file_list:
            for foo in self.report_conf_file_list:
                if not os.path.isfile(foo):
                    self.say_error("@E: Not found report conf file: {}".format(foo))
                    return 1
        else:
            self.report_conf_file_list = [""]
        self.deploy_detail_options()
        self.say_debug(vars(self.opts), "Command Options:", debug=self.debug)
        self.say_debug(self.default_conf_options, "Default Conf Options:", debug=self.debug)

    def deploy_detail_options(self):
        self.detail_options = self.default_conf_options.get("report_detail")

    def __reset_fields(self):
        if not self.fields:
            return
        predefine_dump_conf = self.default_conf_options.get("dump_titles", dict())
        custom_dump_conf = dict()
        if self.custom_dump_ini:
            sts, custom_dump_conf_options = xTools.get_options(self.custom_dump_ini)
            if sts:
                self.say_error("Error. Failed to parse options from {}".format(self.custom_dump_ini))
                return 1
            custom_dump_conf = custom_dump_conf_options.get("dump_titles", dict())
        real_fields = custom_dump_conf.get(self.fields, predefine_dump_conf.get(self.fields))
        if real_fields is None:
            self.say_warning("Warning. fields {} not in predefined dump settings".format(self.fields))
            real_fields = self.fields
        self.fields = xTools.comma_split(real_fields)
        if "Design" not in self.fields:
            self.fields.insert(0, "Design")

    def _prepare_output_path(self):
        self.output = os.path.abspath(self.output)
        if not os.path.isdir(self.output):
            try:
                os.makedirs(self.output)
            except (FileNotFoundError, PermissionError):
                self.say_error("Error. Failed to create output folder: {}".format(self.output))
                return 1
        self.opts.output = self.output

    def _get_default_conf_options(self):
        if not os.path.isdir(self.default_conf_path):
            self.say_error("Error. Failed to read configurations from {}".format(self.default_conf_path))
            return 1
        conf_files = list()
        for foo in os.listdir(self.default_conf_path):
            if foo.endswith(".ini"):
                conf_files.append(os.path.join(self.default_conf_path, foo))
        if not conf_files:
            self.say_error("Error. Not found any ini file under {}".format(self.default_conf_path))
            return 1
        sts, self.default_conf_options = xTools.get_options(conf_files, key_is_lower=False)
        if sts:
            self.say_traceback()
            return 1
