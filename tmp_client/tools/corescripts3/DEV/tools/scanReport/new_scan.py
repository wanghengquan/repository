#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 1:51 PM 4/10/2023
  file: new_scan.py
  author: Shawn Yan
Description:

"""
import os
import csv
import json
import argparse
from collections import OrderedDict

from scanLib import filelock3100 as filelock
from scanLib import buildPatterns
from scanLib import scanData
from scanLib import utils
from scanLib import compressData


class ScanResultData(object):
    def __init__(self):
        self._default_vendor = "Radiant"
        self._default_tag = "_scratch"
        self._default_output = "result_data.csv"
        root_now = os.path.dirname(os.path.abspath(__file__))
        self.yaml_folder = os.path.join(root_now, "scanLib", "patterns")

    def process(self, args=None):
        if self.get_options(args):
            return 1
        self.create_patterns_from_yaml_files()
        if self.source_data_files:
            self.raw_design = "CUSTOM"
        else:
            self.get_source_data_files()
        self.scan_source_data_files()
        self.transfer_report_data()
        self.dump_report_data()

    def get_options(self, args):
        parser = argparse.ArgumentParser()
        parser.add_argument("--debug", action="store_true", help="print debug message")
        parser.add_argument("-v", "--verbose", action="store_true", help="dump all report data")
        parser.add_argument("--top-dir", help="specify top working path")
        parser.add_argument("--design", help="specify design name")
        parser.add_argument("--info", help="specify design info file (Just for Vivado case)")
        v_hlp = "specify vendor tool name, default is {}".format(self._default_vendor)
        parser.add_argument("--vendor", choices=("Radiant", "Diamond", "Vivado"), help=v_hlp)
        parser.add_argument("--tag", help="specify tag name, default is {}".format(self._default_tag))
        parser.add_argument("-o", "--output", help="specify output file, default is {}".format(self._default_output))
        parser.add_argument("-f", "--file", nargs="+", help="shortcut for scanning a report file(s)")
        parser.add_argument("--ignore-clock", nargs="+", help="specify ignored custom clock(s) when scanning timing data")
        parser.add_argument("--care-clock", nargs="+", help="specify cared custom clock(s) when scanning timing data")
        parser.set_defaults(vendor=self._default_vendor, tag=self._default_tag, output=self._default_output)
        opts = parser.parse_args(args)
        self.debug = opts.debug
        self.verbose = opts.verbose
        self.top_dir = opts.top_dir
        self.raw_design = opts.design
        self.info = opts.info
        self.vendor = opts.vendor
        self.tag = opts.tag
        self.output = opts.output
        self.file_list = opts.file
        self.ignore_clock = opts.ignore_clock
        self.care_clock = opts.care_clock
        return self._options_sanity_check()

    def _options_sanity_check(self):
        self.source_data_files = dict()
        if self.file_list:
            inner_check_list = list()
            for a_file in self.file_list:
                if not os.path.isfile(a_file):
                    print("Warning. Not found file {}".format(a_file))
                else:
                    inner_check_list.append(os.path.join(a_file))
            if not inner_check_list:
                print("Error. Not found any file to scan. Exit...")
                return 1
            self.source_data_files["custom"] = inner_check_list
            return
        now_path = os.getcwd()
        top_dir_and_design_dict = dict(False_False=(os.path.dirname(now_path), os.path.basename(now_path)),
                                       True_True=(self.top_dir, self.raw_design),
                                       True_False=(self.top_dir, None),
                                       False_True=(os.getcwd(), self.raw_design))
        key = "{}_{}".format(bool(self.top_dir), bool(self.raw_design))
        self.top_dir, self.design = top_dir_and_design_dict.get(key)
        if self.design is None:
            print("Error. value for '--design' should be specified when --top-dir {}".format(self.top_dir))
            return 1
        if not os.path.isdir(self.top_dir):
            print("Error. Not found --top-dir={}".format(self.top_dir))
            return 1
        self.top_dir = os.path.abspath(self.top_dir)
        os.chdir(self.top_dir)
        self.design = os.path.abspath(self.design)
        self.output = os.path.abspath(self.output)
        os.chdir(now_path)
        print("Message: scanning design {}".format(self.design))

    def create_patterns_from_yaml_files(self):
        p_folders = list()
        for foo in os.listdir(self.yaml_folder):
            if self.vendor in foo:
                p_folders.append(os.path.join(self.yaml_folder, foo))
        self.first_yaml_patterns = buildPatterns.build_patterns(p_folders)
        if self.debug:
            for now_key, now_value in list(self.first_yaml_patterns.items()):
                print(now_key)
                print(now_value)
                print("-" * 20)

    def get_source_data_files(self):
        if self.vendor == "Vivado":
            abs_tag = self.design
        else:
            abs_tag = os.path.join(self.design, self.tag)
        if not os.path.isdir(abs_tag):
            print("Error. Not found tag path: {}".format(abs_tag))
            return
        files_finder = utils.FindFiles(abs_tag, self.vendor, self.info)
        files_finder.process()
        self.source_data_files = files_finder.get_report_files_dict()

    def scan_source_data_files(self):
        scanner = scanData.ScanData(self.first_yaml_patterns)
        # to avoid duplicate scanning
        tidy_files = list()
        for pb_or_target, raw_files in list(self.source_data_files.items()):
            tidy_files.extend(raw_files)
        tidy_files = list(set(tidy_files))
        self.tidy_file_data_dict = dict()
        for foo in tidy_files:
            e_time = utils.ElapsedTime()
            file_data = scanner.scan_file(foo)
            if self.debug:
                print("File: {} ({})".format(foo, e_time))
                print(json.dumps(file_data, indent=2))
            self.tidy_file_data_dict[foo] = file_data

    def transfer_report_data(self):
        compressor = compressData.CompressData(self.source_data_files, self.tidy_file_data_dict, self.ignore_clock, self.care_clock)
        compressor.process()
        self.single_line_data = compressor.get_compressed_data()

    def dump_report_data(self):
        # for TMP json data
        tmp_json_dict = dict(Report=self.single_line_data)
        print(json.dumps(tmp_json_dict))
        first_field_name = "Design"
        self.single_line_data["Design"] = self.raw_design
        self.output = os.path.abspath(self.output)  # for exception when --file
        report_path = os.path.dirname(self.output)
        if not os.path.isdir(report_path):
            os.makedirs(report_path)
        report_lock = os.path.splitext(self.output)[0] + ".updating_lock"
        file_locker = filelock.FileLock(report_lock, timeout=100)
        with file_locker:
            csv_odict = OrderedDict()
            new_added_keys = list(self.single_line_data.keys())
            now_keys = list()
            if os.path.isfile(self.output):
                with open(self.output) as csv_ob:
                    dw = csv.DictReader(csv_ob)
                    for idx, line_dict in enumerate(dw):
                        csv_odict[str(idx)] = line_dict
                        if not now_keys:
                            now_keys = list(line_dict.keys())
            final_keys = list(set(new_added_keys + now_keys))
            final_keys.sort(key=str.lower)
            # put Design at the first position
            if first_field_name in final_keys:
                final_keys.remove(first_field_name)
            final_keys.insert(0, first_field_name)
            csv_odict["new"] = self.single_line_data
            with open(self.output, 'w', newline="\n") as w_ob:
                print(",".join(final_keys), file=w_ob)
                for k, v in list(csv_odict.items()):
                    v_list = [str(v.get(kk)) for kk in final_keys]
                    print(",".join(v_list), file=w_ob)


if __name__ == "__main__":
    srd = ScanResultData()
    srd.process()
