import os
import re
import sys
import stat
import shlex
import getpass
import optparse
import shutil

from xlib import xTools

__author__ = 'syan'

RUN_SQUISH = """#!/bin/sh
%(run_server)s
%(sleep)s
%(squishserver)s --config addAUT %(name_of_aut)s "%(path_to_aut)s"
%(squishrunner)s --testsuite "%(testsuite)s" %(testcase)s --reportgen xml2.1,"%(reportgen)s" --cwd %(cwd)s --aut %(name_of_aut)s
%(squishserver)s --stop
"""

def kill_cmd(pid, on_win=True):
    if on_win:
        import win32con, win32api
        handle = win32api.OpenProcess(win32con.PROCESS_TERMINATE, 0, pid)
        win32api.TerminateProcess(handle, 0)
        win32api.CloseHandle(handle)
    else:
        kill_cmd_str = "kill -9 %d" % pid
        sts, text = xTools.get_status_output(kill_cmd_str)
        if sts:
            return 1

class RunSquish:
    def __init__(self):
        _xlib = os.path.join(xTools.get_file_dir(sys.argv[0]), "xlib")
        self.xlib = os.path.abspath(_xlib)
        self.user = getpass.getuser()
        # //////////////////////////
        # // Frank Chen need more check for the following suites
        # //
        self.prc_check_suites = ("suite_BE_21_PIO_DRC", "suite_BE_01_SSO")

    def process(self):
        self.run_option_parser()
        self.on_win, self.nt_lin = xTools.get_os_name(self.x86)
        if self.kill_all_squish_processes():
            return 1
        if self.kill_all:
            return
        if self.sanity_check():
            return 1

        if self.run_it():
            return 1

        self.behavior_check()

    def behavior_check(self):
        suite_name = os.path.basename(os.path.dirname(self.suite))
        if suite_name not in self.prc_check_suites:
            return
        case_log_dir = os.path.dirname(self.suite)
        # mush have "case" and "log" directory
        _dir_list = os.listdir(case_log_dir)
        if "case" not in _dir_list:
            return -1
        if "log" not in _dir_list:
            return -2
        cur_dir = os.getcwd()
        os.chdir(case_log_dir)
        if suite_name == "suite_BE_01_SSO":
            cmd_lines_a = [r'cp ./case/*.ini ./log/',
                           r'cp ./case/scan_result.bat ./log/',]
            cmd_lines_b = [r'svn export http://d50534/auto/bqs_scripts/trunk  --username=public --password=lattice --force',
                           r'call scan_result.bat']
        else:
            cmd_lines_a = [r'cp ./case/*.ini ./log/',
                           r'cp ./case/run.bat ./log/',]
            cmd_lines_b = [r'svn export http://d50534/auto/trunk   --username=public --password=lattice --force',
                           r'call run.bat']
        sts = 0
        for cmd in cmd_lines_a:
            if os.system(cmd):
                sts = "Failed to run %s" % cmd
                break
        os.chdir("log")
        if not sts:
            for cmd in cmd_lines_b:
                if os.system(cmd):
                    sts = "Failed to run %s" % cmd
                    break
        os.chdir(cur_dir)
        return sts

    def run_option_parser(self):
        parser = optparse.OptionParser()
        parser.add_option("--debug", action="store_true", help="print debug message")
        parser.add_option("--diamond", help="specify Diamond install path")
        parser.add_option("--squish", help="specify Squish install path")
        parser.add_option("--suite", help="specify Squish Suite path")
        parser.add_option("--case", help="specify Squish case name")
        parser.add_option("--x86", action="store_true", help="run with x86 vendor tools")
        parser.add_option("--rpt-dir", default="results", help="specify final report path")
        parser.add_option("--kill-all", action="store_true", help="kill all processes about Squish")
        parser.add_option("--timeout", type="int", default=0, help="specify timeout value")
        parser.add_option("--smoke", action="store_true", help="run smoke regression test only")
        parser.add_option("--aut", help="specify the AUT file name")
        parser.add_option("--dev-path", help="specify DEV(core scripts) path")
        parser.add_option("--test-id", help="show test id in command line")

        opts, args = parser.parse_args()
        self.debug = opts.debug
        self.diamond = opts.diamond
        self.squish = opts.squish
        self.suite = opts.suite
        self.case = opts.case
        self.x86 = opts.x86
        self.rpt_dir = opts.rpt_dir
        self.kill_all = opts.kill_all
        self.timeout = opts.timeout
        self.smoke = opts.smoke
        self.aut_name = opts.aut
        self.dev_path = opts.dev_path

        if not self.diamond:
            self.diamond = os.getenv("DIAMOND_")
        if not self.squish:
            self.squish = os.getenv("SQUISH_")
        if self.dev_path:
            if xTools.not_exists(self.dev_path, "DEV Path"):
                return 1
            os.environ["EXTERNAL_DEV_PATH"] = xTools.win2unix(self.dev_path)

    def kill_all_squish_processes(self):
        if self.on_win:
            ps_cmd = "%s -ef" % os.path.join(self.xlib, "ps")
        else:
            ps_cmd = "ps -ef | grep %s" % self.user

        sts, tasklist = xTools.get_status_output(ps_cmd)
        if sts:
            xTools.say_it("-Error. Failed to run %s" % ps_cmd)
            return 1
        xTools.say_it(tasklist, "Tasklist:", self.debug)

        kill_list = ("squishrunner", "squishserver")
        kill_pattern = [re.compile(item, re.I) for item in kill_list]
        for item in tasklist:
            item = item.strip()
            for p in kill_pattern:
                m = p.search(item)
                if m:
                    break
            else:
                continue
            item_list = re.split("\s+", item)
            pid = int(item_list[1])
            kill_cmd(pid, self.on_win)

    def sanity_check(self):
        if xTools.not_exists(self.diamond, "Diamond Install Path"):
            return 1
        self.diamond = os.path.abspath(self.diamond)

        if xTools.not_exists(self.squish, "Squish Install Path"):
            return 1
        self.squish = os.path.abspath(self.squish)
        self.squishserver = os.path.join(self.squish, "bin", "squishserver")
        self.squishrunner = os.path.join(self.squish, "bin", "squishrunner")
        self.dllpreload = os.path.join(self.squish, "bin", "dllpreload")

        if xTools.not_exists(self.suite, "Test Suite Path"):
            return 1
        self.suite = os.path.abspath(self.suite)

        if xTools.wrap_md(self.rpt_dir, "Report Path"):
            return 2
        self.rpt_dir = os.path.abspath(self.rpt_dir)

        if self.aut_name:
            real_aut_file_name = xTools.get_fname(self.aut_name)
            if self.on_win:
                real_aut_file_name += ".exe"
            self.aut = os.path.join(self.diamond, "bin", self.nt_lin, real_aut_file_name)
        else:
            if self.on_win:
                self.aut = os.path.join(self.diamond, "bin", self.nt_lin, "pnmain.exe")
            else:
                self.aut = os.path.join(self.diamond, "bin", self.nt_lin, "diamond")
        if xTools.not_exists(self.aut, "AUT Path"):
            return 1

    def run_it(self):
        if self.create_aut():
            return 1
        if self.copy_layout():
            return 1
        if self.run_suite():
            return 1

    def create_aut(self):
        self.aut_file = os.path.join(self.rpt_dir, "tmp_aut.bat")
        tmp_aut_lines = list()
        if self.on_win:
            tmp_aut_lines.append("set SQUISH_LIBQTDIR=%s" % os.path.dirname(self.aut))
            tmp_aut_lines.append("%s %s" % (self.dllpreload, self.aut))
        else:
            tmp_aut_lines.append("#!/bin/sh")
            tmp_aut_lines.append(self.aut)
        xTools.write_file(self.aut_file, tmp_aut_lines)
        os.chmod(self.aut_file, stat.S_IRWXU)

    def copy_layout(self):
        for foo in os.listdir(self.suite):
            fname, fext = os.path.splitext(foo)
            if fext.lower() == ".ini":
                src_ini = os.path.join(self.suite, foo)
                if self.on_win:
                    dst_ini = os.path.join(r"C:\Users\%s\AppData\Roaming\LatticeSemi\pnlayout" % self.user, foo)
                else:
                    dst_ini = os.path.join("/users/%s/.config/LatticeSemi/pnlayout" % self.user, foo)
                if xTools.wrap_cp_file(src_ini, dst_ini):
                    xTools.say_it("Failed to copy from {} to {}".format(src_ini, dst_ini))
                    return 1

    def copy_all_suite_2_rpt_dir(self):
        new_suite_dir = os.path.join(self.rpt_dir, os.path.basename(self.suite))
        if os.path.isdir(new_suite_dir):
            self.suite = new_suite_dir
            return
        try:
            shutil.copytree(self.suite, new_suite_dir)
        except Exception as e:
            print(e)
            return 1

        parent_dir = os.path.dirname(self.suite)
        for foo in os.listdir(parent_dir):
            if foo == "case":
                src_foo = os.path.join(parent_dir, foo)
                dst_foo = os.path.join(self.rpt_dir, foo)
                if os.path.isdir(dst_foo):
                    continue
                try:
                    shutil.copytree(src_foo, dst_foo)
                except Exception as e:
                    print(e)
                    return 1
        self.suite = new_suite_dir  # use the copied one!

    def run_suite(self):
        if self.copy_all_suite_2_rpt_dir():
            return 1
        flow_dict = dict(
            name_of_aut=os.path.basename(self.aut_file),
            path_to_aut=os.path.dirname(self.aut_file),

            squishserver=self.squishserver,
            squishrunner=self.squishrunner,

            testsuite=self.suite,
            reportgen=os.path.join(self.rpt_dir, "report.xml"),
            cwd=self.rpt_dir,
        )

        if self.on_win:
            flow_dict["run_server"] = 'start "SquishServer Window" /B "%s" --verbose' % self.squishserver
            flow_dict["sleep"] = "%s 5" % os.path.join(self.xlib, "sleep")
        else:
            flow_dict["run_server"] = "%s &"  % self.squishserver
            flow_dict["sleep"] = "sleep 5"
        if self.case:
            flow_dict["testcase"] = "--testcase %s" % self.case
        else:
            flow_dict["testcase"] = ""

        if self.update_for_smoke_test():
            return 1

        run_lines = RUN_SQUISH % flow_dict
        run_suite_file = os.path.join(self.rpt_dir, "run_squish.bat")
        xTools.write_file(run_suite_file, run_lines)

        if self.on_win:
            sts = xTools.run_command(run_suite_file,
                os.path.join(self.rpt_dir, "run_squish.log"),
                os.path.join(self.rpt_dir, "run_squish.time"))
        else:
            sts = xTools.run_command("sh %s" % run_suite_file,
                os.path.join(self.rpt_dir, "run_squish.log"),
                os.path.join(self.rpt_dir, "run_squish.time"))
        return sts

    def update_for_smoke_test(self):
        _root_dir = self.suite
        if self.case:
            _root_dir = os.path.join(self.suite, self.case)
        if xTools.not_exists(_root_dir, "Root Suite/Case Path"):
            return 1
        for root, dirs, files in os.walk(_root_dir):
            for item in files:
                fext = xTools.get_fext_lower(item)
                if fext == ".tsv":
                    tsv_file = os.path.join(root, item)
                    if self.update_tsv_file(tsv_file):
                        return 1

    def update_tsv_file(self, tsv_file):
        tsv_lines = xTools.get_original_lines(tsv_file)
        new_tsv_lines = list()
        i, smoke_idx = 0, -1
        for line in tsv_lines:
            line = line.strip()
            line_list = shlex.split(line)
            new_line = "\t".join(line_list)
            if not self.smoke:
                new_tsv_lines.append(new_line)
                continue
            if not i:  # the title line
                new_tsv_lines.append(new_line)
                try:
                    smoke_idx = line_list.index("smoke")
                except ValueError:
                    pass
                i = 1
            else:    # the design case info line
                if smoke_idx < 0:  # no smoke tag
                    new_tsv_lines.append(new_line)
                else:   # has smoke tag
                    try:
                        smoke_tag = line_list[smoke_idx]
                    except IndexError:
                        smoke_tag = "0"
                    if smoke_tag == "0":
                        pass
                    else:
                        new_tsv_lines.append(new_line)

        if xTools.write_file(tsv_file, new_tsv_lines):
            return 1

if __name__ == "__main__":
    my_flow = RunSquish()
    final_sts = my_flow.process()
    sys.exit(final_sts)




