#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import re
import time
import sys
import traceback
import argparse

__author__ = 'Shawn Yan'
__date__ = '14:39 2019/3/26'

BASE_FOLDER = os.path.dirname(os.path.abspath(__file__))
BASE_SVN_URL = "http://lsh-tmp/platform"


def win2unix(a_path, use_abs=0):
    """
    transfer a path to unix format
    """
    if use_abs:
        a_path = os.path.abspath(a_path)
    return re.sub(r"\\", "/", a_path)


class ChangeDir:
    """Change the current working directory to a new path.
    and can come back to the original current working directory
    """
    def __init__(self, new_path):
        self.cur_dir = os.getcwd()
        os.chdir(new_path)

    def comeback(self):
        os.chdir(self.cur_dir)


def get_status_output(cmd):
    """
    return (status, output) of executing cmd in a shell.
    source from commands.py <def getstatusoutput(cmd)>.
    """
    on_win = (sys.platform[:3] == "win")
    if not on_win:
        cmd = "{ " + cmd + "; }"
    pipe = os.popen(cmd + " 2>&1", "r")
    text = pipe.read()
    sts = pipe.close()
    if sts is None:
        sts = 0
    if text[-1:] == '\n':
        text = text[:-1]
    return sts, text


def get_current_revision():
    sub_commands = ("svn cleanup", "svn update", "svn info {}".format(BASE_SVN_URL))
    current_revision = 0
    for i, sub_command in enumerate(sub_commands):
        sts, text = get_status_output(sub_command)
        if i == len(sub_commands) - 1:  # svn info
            p_revision = re.compile(r"Last\s+Changed\s+Rev:\s+(\d+)")
            m_revision = p_revision.search(text)
            if m_revision:
                current_revision = int(m_revision.group(1))
    assert current_revision != 0, "Cannot get current revision"
    return current_revision


def update_revision_record_py(current_revision, msg):
    py_file = os.path.join(BASE_FOLDER, "bin", "xlib", "revision_record.py")
    assert os.path.isfile(py_file), "Not found {}".format(py_file)

    src_lines = open(py_file).readlines()
    src_lines[0] = "# {}".format(src_lines[0])
    new_line = 'REVISION = ("{}", "{}", "{}")\n'.format(current_revision+1, time.ctime(), msg)
    exec(new_line)  # try to execute new line before checking into subversion
    src_lines.insert(0, new_line)
    ob = open(py_file, 'w')
    ob.writelines(src_lines)
    ob.close()


class CommitUpdates(object):
    def __init__(self):
        _pub = "http://lsh-tmp/platform/trunk/bqs_scripts/regression_suite"
        self.suite_files = dict(radiant=("{}/radiant_suite".format(_pub), "radiant_regression.xlsx"),
                                diamond=("{}/diamond_suite".format(_pub), "diamond_regression.xlsx"))
        self.default_client = r"C:\shawnProgramFiles\TMP_Client\bin\clientc.exe"

    def process(self):
        self.get_options()
        if self.simple:
            sts = self.simple_check()
        else:
            sts = self.regression_flow_check()
        if sts:
            return
        self.commit_new()

    def get_options(self):
        parser = argparse.ArgumentParser()
        parser.add_argument("--debug", action="store_true", help="print debug message only")
        parser.add_argument("-m", "--message", required=True, help="specify commit message")
        parser.add_argument("-s", "--simple", action="store_true", help="run simple check before committing")
        parser.add_argument("--diamond", help="specify Diamond install path")
        parser.add_argument("--radiant", help="specify Radiant install path")
        parser.add_argument("--client", help="specify client path")
        parser.set_defaults(client=self.default_client)
        opts = parser.parse_args()
        self.debug = opts.debug
        self.message = opts.message
        self.simple = opts.simple
        self.diamond = opts.diamond
        self.radiant = opts.radiant
        self.client = opts.client

    @staticmethod
    def simple_check():
        base_scripts = ("run_classic.py", "run_lattice.py", "run_diamond.py",
                        "tcl_iCEcube.py", "run_radiant.py", "run_diamondng.py")
        try:
            for x in base_scripts:
                cmd_line = "{} {}/bin/{} --help".format(sys.executable, BASE_FOLDER, x)
                cmd_line = win2unix(cmd_line)
                print("Try to run: {}".format(cmd_line))
                sts, text = get_status_output(cmd_line)
                if sts:
                    print(text)
                    return 1
        except Exception:
            print((traceback.format_exc()))
            return 1

    def regression_flow_check(self):
        check_dict = dict()
        if self.diamond:
            check_dict["diamond"] = self.diamond
        if self.radiant:
            check_dict["radiant"] = self.radiant
        if not check_dict:
            print("--diamond or/and --radiant should be specified for running regression test flow.")
            return 1

        for vendor, install_path in list(check_dict.items()):
            chk_path = os.path.join(install_path, "bin")
            if not os.path.isdir(chk_path):
                print(("Error. Not found {}".format(chk_path)))
                return 1
            os.environ["EXTERNAL_{}_PATH".format(vendor.upper())] = win2unix(install_path, 1)
            suite_file_url_list = self.suite_files.get(vendor)
            export_cmd = "svn export {0}/{1} {1} --force".format(*suite_file_url_list)
            print(export_cmd)
            _sts, _text = get_status_output(export_cmd)
            if _sts:
                print(_text)
                return 1
            tmp_command = "{} -c -i all -f {} -w {}".format(self.client, suite_file_url_list[1],
                                                            os.path.dirname(BASE_FOLDER))
            print(("Running {}".format(tmp_command)))
            _sts, _text = get_status_output(tmp_command)
            if self.debug:
                print("TMP client log:")
                print("Final status: ", _sts)
                print(_text)
            if _sts:
                return _sts

    def commit_new(self):
        if self.debug:
            print("DEBUG! you can use svn status/diff/info to check your updates again.")
            return
        recov = ChangeDir(BASE_FOLDER)
        current_revision = get_current_revision()
        update_revision_record_py(current_revision, self.message)
        cin_cmd = 'svn commit -m "{}"'.format(self.message)
        sts, text = get_status_output(cin_cmd)
        if sts:
            print(text)
        recov.comeback()


if __name__ == "__main__":
    tc = CommitUpdates()
    tc.process()
