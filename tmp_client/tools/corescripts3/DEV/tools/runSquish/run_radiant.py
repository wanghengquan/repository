import os
import re
import sys
import time
import getpass
import optparse

from xlib import xTools

__author__ = 'syan'

RADIANT_EXTERNAL_ENV_KEY = "EXTERNAL_RADIANT_PATH"
SQUISH_EXTERNAL_ENV_KEY = "EXTERNAL_SQUISH_PATH"

# RUN_SQUISH = '''#!/bin/sh
# %(set_path)s
# %(run_server)s
# %(sleep)s
# %(squishserver)s --config addAUT %(name_of_aut)s "%(path_to_aut)s"
# %(squishrunner)s --testcase %(testcase)s --lang %(language)s --wrapper %(wrapper)s --objectmap %(objectmap)s --reportgen xml2.1,"%(reportgen)s" --aut %(name_of_aut)s
# %(squishserver)s --stop
# '''


# RUN_SQUISH = '''#!/bin/sh
# %(set_path)s
# %(run_server)s
# %(sleep)s
# %(squishserver)s --config addAUT %(name_of_aut)s "%(path_to_aut)s"
# %(squishrunner)s --config setAUTTimeout 60
# %(squishrunner)s --config setResponseTimeout 60
# %(squishrunner)s --testcase %(testcase)s --lang %(language)s --wrapper %(wrapper)s --objectmap %(objectmap)s --cwd %(cwd)s --aut %(name_of_aut)s
# %(squishserver)s --stop
# '''


RUN_SQUISH = '''#!/bin/sh
%(given_dos_lines)s
%(set_path)s
%(run_server)s
%(sleep)s
%(squishserver)s --config addAUT %(name_of_aut)s "%(path_to_aut)s"
%(squishrunner)s --config setAUTTimeout 60
%(squishrunner)s --config setResponseTimeout 60
%(squishrunner)s --testcase %(testcase)s --lang %(language)s --wrapper %(wrapper)s --objectmap %(objectmap)s --cwd %(cwd)s --reportgen stdout,console.log
%(squishserver)s --stop
'''

GIVEN_DOS_LINES = r"""@echo off

set currPath=%~dp0
set parentPath=

:begin
FOR /F "tokens=1,* delims=\" %%i IN ("%currPath%")  DO (set front=%%i)
FOR /F "tokens=1,* delims=\" %%i IN ("%currPath%")  DO (set currPath=%%j)
if not "%parentPath%" == "" goto gotJpdaOpts

:gotJpdaOpts
if "%parentPath%%front%\"=="%~dp0" goto end
set realParentPath=%parentPath%%front%
set parentPath=%parentPath%%front%\
goto begin

:end
@echo on 
"""


def get_real_value(my_string, env_key):
    if my_string:
        t = my_string
    else:
        t = os.getenv(env_key)
    if t:
        return os.path.abspath(t)

def get_focus(a_file, pattern):
    foo = xTools.simple_parser(a_file, [pattern])
    if not foo:
        return ""
    else: # foo = line, m
        return foo[1].group(1)

def get_squish_file(testdata_path):
    map_files, conf_files = list(), list()
    for foo in os.listdir(testdata_path):
        fext = xTools.get_fext_lower(foo)
        abs_foo = os.path.join(testdata_path, foo)
        if fext == ".map":
            map_files.append(abs_foo)
        elif fext == ".conf":
            conf_files.append(abs_foo)
    return map_files, conf_files

class RunSquishCase:
    def __init__(self):
        _xlib = os.path.join(xTools.get_file_dir(sys.argv[0]), "xlib")
        self.xlib = os.path.abspath(_xlib)

    def process(self):
        xTools.say_it("---- Start running Squish test case ...")
        os.environ["SKIP_UPLOAD_CHECK"] = "1"
        xTools.set_lm_license_environment(__file__)
        sts = self._process()
        xTools.say_it("---- End of running Squish test case ...")
        xTools.ultimate_process(self.design)
        return sts

    def _process(self):
        if self.run_option_parser():
            return 1
        if self.copy_layout_file():
            return 1
        return self.run_batch_file()  # return real check status

    def run_option_parser(self):
        parser = optparse.OptionParser()
        parser.add_option("--top-dir", help="specify top source path")
        parser.add_option("--design", help="specify design name")
        parser.add_option("--radiant", help="specify radiant path")
        parser.add_option("--aut", help="specify Squish AUT name")
        parser.add_option("--squish", help="specify Squish path")
        parser.add_option("--dev-path", help="specify DEV(core scripts) path")
        parser.add_option("--x86", action="store_true", help="run with x86 build")
        opts, args = parser.parse_args()
        self.top_dir = opts.top_dir
        self.design = opts.design
        self.radiant = opts.radiant
        self.aut = opts.aut
        self.squish = opts.squish
        self.dev_path = opts.dev_path
        self.x86 = opts.x86
        self.on_win, self.nt_lin = xTools.get_os_name(self.x86)
        return self._check_options()

    def _check_options(self):
        if not self.top_dir:
            self.top_dir = os.getcwd()
        else:
            if xTools.not_exists(self.top_dir, "Top Source Path"):
                return 1
        self.design = xTools.get_abs_path(self.design, self.top_dir)
        if xTools.not_exists(self.design, "Design absolute path"):
            return 1

        self.radiant = get_real_value(self.radiant, RADIANT_EXTERNAL_ENV_KEY)
        self.squish = get_real_value(self.squish, SQUISH_EXTERNAL_ENV_KEY)

        if xTools.not_exists(self.radiant, "radiant Path"):
            return 1
        if xTools.not_exists(self.squish, "Squish Path"):
            return 1
        if self.on_win:
            self.squish_server = os.path.join(self.squish, "bin", "squishserver.exe")
            self.squish_runner = os.path.join(self.squish, "bin", "squishrunner.exe")
        else:
            self.squish_server = os.path.join(self.squish, "bin", "squishserver")
            self.squish_runner = os.path.join(self.squish, "bin", "squishrunner")

        if self.dev_path:
            if xTools.not_exists(self.dev_path, "DEV Path"):
                return 1
            os.environ["EXTERNAL_DEV_PATH"] = xTools.win2unix(self.dev_path)

    def copy_layout_file(self):
        user = getpass.getuser()
        testdata_path = os.path.join(self.design, "testdata")
        if xTools.not_exists(testdata_path, "testdata path"):
            return 1
        if self.on_win:            
            layout_path = os.path.join(r"C:\Users\%s\AppData\Roaming\LatticeSemi\DiamondNG" % user)
        else:
            layout_path = "/users/%s/.config/LatticeSemi/DiamondNG" % user
        for foo in os.listdir(testdata_path):
            if xTools.get_fext_lower(foo) == ".ini": # found layout file
                src_foo = os.path.join(testdata_path, foo)
                dst_foo = os.path.join(layout_path, foo)
                if xTools.wrap_cp_file(src_foo, dst_foo):
                    return 1

    def update_path(self, raw_path, design_path):
        if not raw_path:
            return raw_path
        unix_path = xTools.win2unix(raw_path)
        unix_design_path = xTools.win2unix(design_path)
        replace_name = "%CASE_PATH%" if self.on_win else "${CASE_PATH}"
        unix_path = re.sub(unix_design_path, replace_name, unix_path)
        return unix_path

    def run_batch_file(self):
        xTools.very_first_process(self.design)
        testrun_path = os.path.join(self.design, "_scratch_cmd")
        if xTools.wrap_md(testrun_path, "TestRun Path"):
            return 1
        _recov = xTools.ChangeDir(testrun_path)
        squish_map_files, squish_conf_files = get_squish_file(os.path.join(self.design, "testdata"))
        if len(squish_map_files) != 1:
            xTools.say_it("Error. Found map files: %s" % squish_map_files)
            return 1
        if len(squish_conf_files) != 1:
            xTools.say_it("Error. Found conf files: %s" % squish_conf_files)
            return 1

        batch_kwargs = {"squishserver" : self.squish_server, "squishrunner" : self.squish_runner,
                        "path_to_aut" : os.path.join(self.radiant, "bin", self.nt_lin),
                        "testcase" : self.design,
                        "reportgen" : os.path.abspath("report_%s.xml" % time.strftime("%m%d%H%M")),
                        "objectmap" : squish_map_files[0],
                        "language" : get_focus(squish_conf_files[0], re.compile("LANGUAGE=(\w+)", re.I)),
                        "wrapper" : get_focus(squish_conf_files[0], re.compile("WRAPPERS=(\w+)", re.I)),
                        "cwd" : os.getcwd(),
                        # ------------
                        }
        for k in ("testcase", "reportgen", "objectmap", "cwd"):
            batch_kwargs[k] = self.update_path(batch_kwargs.get(k), self.design)
        if not self.aut:
            if self.on_win:
                name_of_aut = "pnmain"
            else:
                name_of_aut = "radiant"
        else:
            bin_a = os.path.join(self.radiant, "bin", self.nt_lin)
            bin_b = os.path.join(self.radiant, "ispfpga", "bin", self.nt_lin)
            bin_c = os.path.join(self.radiant, "programmer", "bin", self.nt_lin)
            maybe_one = (self.aut, self.aut + ".exe", self.aut + ".sh")
            maybe_two = (os.getcwd(), bin_a, bin_b, bin_c)
            name_of_aut = ""
            for one in maybe_one:
                for two in maybe_two:
                    new_path = xTools.get_abs_path(one, two)
                    if os.path.isfile(new_path):
                        name_of_aut = os.path.basename(new_path)  # use name only for Windows and Linux
                        if self.aut != name_of_aut:
                            name_of_aut = re.sub(r"\.exe", "", name_of_aut)
                        batch_kwargs["path_to_aut"] = os.path.dirname(new_path)
                        break
                if name_of_aut:
                    break
            if not name_of_aut:
                xTools.say_it("Error. Cannot find aut: %s" % self.aut)
                return 1
        batch_kwargs["set_path"] = xTools.get_environment(self.radiant, self.nt_lin, self.squish)
        if self.on_win:
            batch_kwargs["run_server"] = r'start "Squishserver Window" /B "%s" --verbose' % self.squish_server
            batch_kwargs["sleep"] = "%s 5" % os.path.join(self.xlib, "sleep.exe")
        else:
            batch_kwargs["run_server"] = "%s &" % self.squish_server
            batch_kwargs["sleep"] = "sleep 5"
        batch_kwargs["name_of_aut"] = name_of_aut

        batch_file = "run_squish.bat"
        batch_kwargs["given_dos_lines"] = GIVEN_DOS_LINES if self.on_win else ""
        xTools.write_file("run_squish.bat", RUN_SQUISH % batch_kwargs)
        if self.on_win:
            sts, txt = xTools.get_status_output(batch_file)
        else:
            sts, txt = xTools.get_status_output("sh %s" % batch_file)
        xTools.say_it("Status: %s" % sts)
        xTools.say_it(txt, "Detail:")
        xTools.write_file("runtime_console.log", txt)
        check_sts = get_final_status(txt)
        _recov.comeback()
        return check_sts

def get_final_status(a_list):
    p = re.compile("^Final check status:(.+)")
    for line in a_list:
        line = line.strip()
        m = p.search(line)
        if m:
            try:
                return int(m.group(1))
            except ValueError:
                return 0
    return 0

if __name__ == "__main__":
    my_tst = RunSquishCase()
    sts = my_tst.process()
    sys.exit(sts)



