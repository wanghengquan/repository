#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 13:28 2019/7/19
  file: wrap_scanner.py
  author: Shawn Yan
Description:
  Only when copy_to is specified, the script will copy source / unzip zip file / scan results.

"""
import os
import argparse
from nam import tools
from nam import xSync

base_folder = os.path.dirname(os.path.abspath(__file__))


class WrapScanner(object):
    def __init__(self):
        pass

    def process(self):
        if self.get_options():
            return 1
        if self.copy_to:
            this_copy = xSync.SyncFolder(self.source, self.copy_to)
            this_copy.process()
            this_unzip = tools.SearchNames(self.copy_to, ["*.zip"], function=tools.unzip_file, is_greedy=True)
            this_unzip.process()
            self.this_result_path = self.copy_to
        else:
            self.this_result_path = self.source
        self.case_list = list()
        self.get_cases(self.this_result_path)
        self.scan_cases()

    def get_options(self):
        parser = argparse.ArgumentParser()
        parser.add_argument("--diamond", action="store_true", help="scan Diamond results")
        parser.add_argument("--source", help="specify source result folder")
        parser.add_argument("--copy-to", help="specify local result folder for copying source results")
        parser.add_argument("--report", help="specify final report name")
        opts = parser.parse_args()
        self.diamond = opts.diamond
        self.source = opts.source
        self.copy_to = opts.copy_to
        self.report = opts.report
        if tools.not_exists(self.source, "source path"):
            return 1
        self.source = os.path.abspath(self.source)
        if self.copy_to:
            if tools.wrap_md(self.copy_to, "local path"):
                return 1
            self.copy_to = os.path.abspath(self.copy_to)
        if not self.report:
            x = self.copy_to if self.copy_to else self.source
            x = os.path.basename(x)
            self.report = x
        _ = os.path.splitext(self.report)[0] + ".csv"
        self.report = os.path.abspath(_)

    def get_cases(self, top_dir):
        fds = os.listdir(top_dir)
        if "_scratch" in fds:
            self.case_list.append(top_dir)
        else:
            for foo in fds:
                abs_foo = os.path.join(top_dir, foo)
                if os.path.isdir(abs_foo):
                    self.get_cases(abs_foo)

    def scan_cases(self):
        if not self.case_list:
            print("Error. Not found any $design/_scratch folder in {}".format(self.this_result_path))
        else:
            public_cmd = list()
            public_cmd.append("python {}".format(os.path.relpath(os.path.join(base_folder, "scan_report.py"))))
            public_cmd.append("--software diamond" if self.diamond else "")
            public_cmd.append("--rpt-dir {}".format(os.path.dirname(self.report)))
            public_cmd.append("--rpt-file {}".format(os.path.basename(self.report)))

            for case in self.case_list:
                print("Scanning {}".format(case))
                design_cmd = ["--top-dir {}".format(os.path.dirname(case)),
                              "--design {}".format(os.path.basename(case))]
                cmd = " ".join(public_cmd + design_cmd)
                print(" Running {}".format(cmd))
                tools.get_status_output(cmd)


if __name__ == "__main__":
    scanner = WrapScanner()
    scanner.process()
