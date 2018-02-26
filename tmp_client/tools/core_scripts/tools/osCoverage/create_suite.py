"""
QoR cases run smoke flow, more designs selected.
"""

import os
import re
import random
import optparse
from collections import Counter

from xlib.xTools import say_it, append_file, get_status_output, win2unix, not_exists, get_conf_options
from xlib.suite_conf import get_pool_list

__author__ = 'syan'

def export_file_from_svn(svn_url):
    export_cmd = "svn export %s" % svn_url
    sts, text = get_status_output(export_cmd)
    if sts:
        say_it(text)
        return 1

def get_random():
    return random.randint(0, 9)

def get_select_cases(case_list, ratio, min_number=4, max_number=15):
    len_case_list = len(case_list)
    target_number = int(len_case_list * ratio/10.0)
    if len_case_list < min_number:
        select_cases = case_list[:]
    else:
        if target_number < min_number:
            target_number = min_number
        elif target_number > max_number:
            target_number = max_number
        select_cases = random.sample(case_list, target_number)
    return select_cases


p_section = re.compile("\[([^\]]+)\](.*)")
def ini2dict(case_list_ini):
    ini_dict = dict()
    key = ""
    for line in open(case_list_ini):
        line = line.strip()
        if line.startswith("#"):
            continue
        if line.startswith(";"):
            continue
        if not line:
            continue
        line = win2unix(line, 0)
        m_section = p_section.search(line)
        if m_section:
            key = (m_section.group(1), m_section.group(2))
            continue
        if key:
            old_value = ini_dict.get(key, list())
            old_value.append(line)
            ini_dict[key] = old_value[:]
    return ini_dict

def remove_diamond(ori_options):
    ori_options = re.sub("--x86", "", ori_options)
    ori_options = re.sub("--diamond\S+", "", ori_options)
    # ori_options = re.sub("--flow\S+", "", ori_options)
    ori_options = ori_options.split()
    return " ".join(ori_options)

def get_svn_dirs_files(svn_path):
    svn_dirs, svn_files = list(), list()
    svn_ls_cmd = "svn ls %s" % svn_path
    sts, text = get_status_output(svn_ls_cmd)
    if sts:
        say_it("- Error. Failed to run %s" % svn_ls_cmd)
        return svn_dirs, svn_files
    p_dir = re.compile("\W$")
    for item in text:
        if p_dir.search(item):
            svn_dirs.append(p_dir.sub("", item))
        else:
            svn_files.append(item)
    return svn_dirs, svn_files

class CreateOSCoverageSuite:
    def __init__(self):
        self.default_svn = "http://linux12v"
        self.case_ini = "case_list.ini"
        self.cmd_ini = "common_command.ini"
        self.suite_case_file = "suite_case_list.log"
        self.suite_opt_file = "suite_options.log"
        self.p_more = re.compile("_(TOT|NOD)")


    def process(self):
        self.get_options()
        pool_list = get_pool_list()
        self.create_suite_opt_file()
        for suite in pool_list:
            self.parse_a_suite(suite)

    def parse_a_suite(self, suite):
        suite_path = "%s/%s" % (self.default_svn, suite)
        svn_dirs, svn_files = get_svn_dirs_files(suite_path)

        has_sub_ini_file = list() # only use sub case_list.ini if exists!
        for item in svn_dirs:
            new_item = "%s/%s" % (suite_path, item)
            _dirs, _files = get_svn_dirs_files(new_item)
            if self.case_ini in _files:
                has_sub_ini_file.append("%s/%s" % (suite, item))
        if has_sub_ini_file:
            for sub_dir in has_sub_ini_file:
                self.parse_suite_ini_file(sub_dir)
        else:
            self.parse_suite_ini_file(suite)

    def get_options(self):
        parser = optparse.OptionParser()
        parser.add_option("--svn", default=self.default_svn, help="specify svn URL root path, default is %s" % self.default_svn)
        parser.add_option("--ratio", type="int", default=1, help="specify the randomly selected cases ratio, range is 1-10, default is 1")
        parser.add_option("--diamond", default="empty_diamond", help="specify Diamond install path (On Windows)")
        parser.add_option("--diamond-lin", default="empty_diamond_lin", help="specify Diamond install path (on Linux)")
        parser.add_option("--x86", action="store_true", help="use Diamond x86 version")
        parser.add_option("--run-check", action="store_true", help="check the ini file only")
        parser.add_option("--check-designs", action="store_true", help="find repeated designs")
        opts, args = parser.parse_args()
        self.svn = opts.svn
        self.ratio = opts.ratio
        self.diamond = opts.diamond
        self.diamond_lin = opts.diamond_lin
        self.x86 = opts.x86
        self.run_check = opts.run_check
        self.check_designs = opts.check_designs
        if self.check_designs:
            self.run_check = 1

    def create_suite_opt_file(self):
        opt_lines = ""
        if self.diamond:
            opt_lines += " --diamond=%s" % win2unix(self.diamond, 0)
        if self.diamond_lin:
            opt_lines += " --diamond-lin=%s" % self.diamond_lin
        if self.x86:
            opt_lines += " --x86"
        append_file(self.suite_opt_file, opt_lines)

    def parse_suite_ini_file(self, suite):
        print "---------------"
        print suite
        suite_url = "%s/%s" % (self.svn, suite)
        for item in (self.case_ini, self.cmd_ini):
            ini_url = "%s/%s" % (suite_url, item)
            _exists, _no_use = get_status_output("svn ls %s" % ini_url)
            if _exists:
                continue
            if export_file_from_svn(ini_url):
                pass
        if not_exists(self.case_ini, "file"):
            return 1
        if not os.path.isfile(self.cmd_ini):
            cmd_dict = dict()
            pass # just give the warning message
        else:
            sts, cmd_dict = get_conf_options(self.cmd_ini, key_lower=False)
            if sts:
                return 1
        # -------------------
        cmd_section = cmd_dict.get("cmd", dict())
        ini_dict = ini2dict(self.case_ini)
        if self.run_check:
            self.run_check_flow(suite, ini_dict)
        else:
            self.dump_to_file(suite, ini_dict, cmd_section)
        # -------------------
        os.remove(self.case_ini)
        if os.path.isfile(self.cmd_ini):
            os.remove(self.cmd_ini)


    def run_check_flow(self, suite, ini_dict):
        for key, case_list in ini_dict.items():
            partial_path, public_opts = key
            print "parsing %s/%s, %s" % (suite, self.case_ini, partial_path)
            if self.check_designs:
                my_cnt = Counter(case_list)
                for design, cnt in my_cnt.items():
                    if cnt > 1:
                        print "repeated design: %s, %d" % (design, cnt)
                continue
            failed_designs = 0
            for case in case_list:
                case_list = case.split()
                real_case = case_list[0]
                real_case = self.p_more.sub("", real_case)
                case_url = "%s/%s/%s/%s" % (self.default_svn, suite, partial_path, real_case)
                _exists, _no_use = get_status_output("svn ls %s" % case_url)
                if _exists:
                    print "NotFound %s" % case_url
                    failed_designs += 1
                if failed_designs > 10:
                    print "... More than 10 designs not be found"
                    break
            print "-" * 10
            print
    p_tot = re.compile("(\S+_TOT)_(\S+)")
    def dump_to_file(self, suite, ini_dict, cmd_section):
        def get_new_ini_dict(ratio=self.ratio):
            new_ini_dict = dict()
            for key, case_list in ini_dict.items():
                select_cases = get_select_cases(case_list, ratio)
                new_ini_dict[key] = select_cases
            return new_ini_dict

        new_ini_dict = get_new_ini_dict()

        all_options = cmd_section.get("all", "")
        all_options = remove_diamond(all_options)
        has_tot = 0
        for key in cmd_section.keys():
            if key != "all":  # omit all if has _TOT
                has_tot = 1
                break
        else:
            for key, select_cases in new_ini_dict.items():
                partial_path, public_opts = key
                public_opts = remove_diamond(public_opts)
                private_options = cmd_section.get(partial_path, "")
                private_options = remove_diamond(private_options)
                line_list= ["SVN::%s/%s/%s %s %s %s" % (suite, partial_path, item, all_options, public_opts, private_options) for item in select_cases]
                append_file(self.suite_case_file, line_list)
        if has_tot:
            for key, value in cmd_section.items():
                m_tot = self.p_tot.search(key)
                if m_tot:
                    section_in_ini, tag = m_tot.group(1), "--tag=%s" % m_tot.group(2)
                else:
                    section_in_ini, tag = key, ""
                if re.search("Generic_QoR", suite):
                    tag += " --smoke "
                    new_ini_dict = get_new_ini_dict(2)
                else:
                    new_ini_dict = get_new_ini_dict()
                for key, select_cases in new_ini_dict.items():
                    partial_path, public_opts = key
                    if partial_path == section_in_ini:
                        public_opts = remove_diamond(public_opts)
                        private_options = value
                        private_options = remove_diamond(private_options)
                        line_list= ["SVN::%s/%s/%s %s %s %s %s" % (suite, re.sub("_TOT", "", partial_path), item, all_options, public_opts, private_options, tag) for item in select_cases]
                        append_file(self.suite_case_file, line_list)

if __name__ == "__main__":
    my_create = CreateOSCoverageSuite()
    my_create.process()
