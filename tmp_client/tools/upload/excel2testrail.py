"""
python excel2testrail.py suite_info.xlsx [debug]

if has debug or any characters, will run debug flow
"""

import os
import optparse
from xlib import xTools
from xlib import xlsx2csv
from xlib import main
from xlib import parse_sheet_case
from xlib import parse_sheet_suite

__author__ = 'syan'

class Excel2TestRail:
    def __init__(self):
        pass

    def process(self):
        self.run_option_parser()
        excel_file = self.infile
        debug = self.debug
        self.tmp_dir = xTools.get_fname(excel_file) + "_temp"
        if xTools.not_exists(excel_file, "User Input Excel File"):
            return 1
        if xTools.rm_with_error(self.tmp_dir):
            return 1
        if xTools.wrap_md(self.tmp_dir, "Temporary Path"):
            return 1
        xTools.say_it("Input Excel File: %s" % excel_file)
        # generate suite.csv and case.csv
        xlsx2csv.main(["-a", os.path.abspath(excel_file), self.tmp_dir])
        self.new_ini_file = os.path.join(self.tmp_dir, "_suite_section_case.ini")
        self.write_suite_ini_lines()
        self.write_section_ini_lines()
        if debug:
            return
        upload = main.CommandEntry()
        new_args = ["--file=%s" % self.new_ini_file, "--clean"]
        if self.testrail:
            new_args.append("--testrail=%s" % self.testrail)
        if self.username:
            new_args.append("--username=%s" % self.username)
        if self.password:
            new_args.append("--password=%s" % self.password)
        upload.process(new_args)

    def run_option_parser(self):
        parser = optparse.OptionParser()
        parser.add_option("-d", "--debug", action="store_true", help="Debug only")
        parser.add_option("-f", "--infile", help="specify Excel conf file")
        parser.add_option("-u", "--username", help="specify testrail user name.")
        parser.add_option("-p", "--password", help="specify testrail password")
        parser.add_option("-t", "--testrail", help="specify testrail URL, format: http://$server/testrail")

        opts, args = parser.parse_args()
        self.debug = opts.debug
        self.infile = opts.infile
        self.username = opts.username
        self.password = opts.password
        self.testrail = opts.testrail

    def write_suite_ini_lines(self):
        suite_file = os.path.join(self.tmp_dir, "suite.csv")
        suite_lines = parse_sheet_suite.create_suite_ini_lines(suite_file)
        xTools.write_file(self.new_ini_file, suite_lines)

    def write_section_ini_lines(self):
        suite_file = os.path.join(self.tmp_dir, "suite.csv")
        case_file = os.path.join(self.tmp_dir, "case.csv")
        section_lines = parse_sheet_case.get_section_ini_lines(case_file, suite_file)
        real_lines = list()
        for key, value in section_lines.items():
            for item in value:
                real_lines.append(item)
            real_lines.append(";; ----------------")
        xTools.append_file(self.new_ini_file, real_lines)

if __name__ == "__main__":
    tst = Excel2TestRail()
    tst.process()















