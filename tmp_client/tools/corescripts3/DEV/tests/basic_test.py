#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 9:43 AM 9/18/2021
  file: basic_test.py
  author: Shawn Yan
Prepare:
  python -m  pip install pytest
  python -m  pip install pytest-xdist
Description:
  pytest -vs
  pytest -vs -m "radiant" -n 4

cases:
  vhdl case: http://lsh-tmp/radiant/trunk/general/analysis_01_simulation/simulator_aldec/028_vhdl_misc_resrcshr_on
  verilog case: http://lsh-tmp/radiant/trunk/general/analysis_01_simulation/simulator_aldec/125_vlog_statmchs_sum3

"""
import os
import re
import sys
import pytest
from capuchin import xTools
from capuchin import xConfigparser

TESTS_DIR = os.path.dirname(os.path.abspath(__file__))
BIN_DIR = os.path.abspath(os.path.join(TESTS_DIR, "..", "bin"))


def _remove_temp_sub_folder(sub_folders):
    for skip_name in (".svn", "__pycache__", ".pytest_cache", ".idea"):
        if skip_name in sub_folders:
            sub_folders.remove(skip_name)


def test_general():
    conf_path = os.path.abspath(os.path.join(TESTS_DIR, "..", "conf"))
    file_parser = xConfigparser.ConfigParser()
    for a, b, c in os.walk(conf_path):
        _remove_temp_sub_folder(b)
        for foo in c:
            if foo.endswith(".ini"):
                abs_foo = os.path.join(a, foo)
                print("Check ini file: {}".format(abs_foo))
                with open(abs_foo) as ob:
                    file_parser.read_file(ob)


def _find_error(command_console_log):
    p_error = [re.compile(r"^([^:]+Error):\s+(.+)"),
               re.compile("error: argument"),
               ]
    logs = command_console_log.splitlines()
    for foo in logs[-8:]:
        foo = foo.strip()
        for p in p_error:
            m_error = p.search(foo)
            if m_error:
                return foo


def _execute_test(design, synthesis, devkit, py, others):
    build_env_name = "EXTERNAL_RADIANT_PATH" if py == "run_radiant.py" else "EXTERNAL_DIAMOND_PATH"
    build_env = os.getenv(build_env_name)
    assert build_env, "Error. Not specified {}".format(build_env_name)
    cmd_line = "{} {}/{} --top-dir {}/cases --synthesis {}".format(sys.executable, BIN_DIR, py, TESTS_DIR, synthesis)
    cmd_line += " --devkit {} --design {} --tag flow_{} {}".format(devkit, design, synthesis, others)
    cmd_line = xTools.win2unix(cmd_line)
    print(cmd_line)
    sts, text = xTools.get_status_output(cmd_line)
    error_message = _find_error(text)
    if error_message:
        assert 0, "Failed to {}, {}".format(design, error_message)


"""
import random

radiant_devices = ("ap6a00-65-9FBG484C", "iCE40UP5K-FWG49ITR", "LFCPNX-100-9LFG672C",
                   "LIFCL-40-8BG400C", "LFMXO5-25-9BBG400C")
radiant_lines = list()
radiant_lines.append(dict(design="radiant_vhdl_a", synthesis="lse", others="--sim-all -lyes"))
radiant_lines.append(dict(design="radiant_vhdl_b", synthesis="synplify", others="--sim-all -lno"))
radiant_lines.append(dict(design="radiant_verilog_a", synthesis="lse", others="--sim-all -lno"))
radiant_lines.append(dict(design="radiant_verilog_b", synthesis="synplify", others="--sim-all -lyes"))

diamond_devices = ("LFE5U-85F-7BG554C", "LCMXO3D-9400HE-6BG484C", "LCMXO3LF-9400E-6BG400C", "LFE3-70E-7FN1156C",
                   "LFSC3GA80E-6FF1704C", "LFXP2-8E-7FT256C")
diamond_lines = list()
diamond_lines.append(dict(design="diamond_vhdl_a", synthesis="lse", others="--sim-all -lyes"))
diamond_lines.append(dict(design="diamond_vhdl_b", synthesis="synplify", others="--sim-all -lno"))
diamond_lines.append(dict(design="diamond_verilog_a", synthesis="lse", others="--sim-all -lno"))
diamond_lines.append(dict(design="diamond_verilog_b", synthesis="synplify", others="--sim-all -lyes"))

template = '''def test_{design}():
    print()
    _execute_test("{design}", "{synthesis}", "{devkit}", "{py}", "{others}")   
    
'''


def generate_py_lines(vendor, raw_lines, raw_devices):
    my_devices = random.sample(raw_devices, len(raw_lines))
    for i, foo in enumerate(raw_lines):
        foo["devkit"] = my_devices[i]
        print("@pytest.mark.{}".format(vendor))
        print("@pytest.mark.{}".format(foo.get("design")[:-2]))
        foo["py"] = "run_diamond.py" if vendor == "diamond" else "run_radiant.py"
        if "-lno" in foo.get("others"):
            print("@pytest.mark.sim_lib")
        print(template.format(**foo))


generate_py_lines("diamond", diamond_lines, diamond_devices)
generate_py_lines("radiant", radiant_lines, radiant_devices)
"""


@pytest.mark.diamond
@pytest.mark.diamond_vhdl
def test_diamond_vhdl_a():
    print()
    _execute_test("diamond_vhdl_a", "lse", "LCMXO3D-9400HE-6BG484C", "run_diamond.py", "--sim-all -lyes")


@pytest.mark.diamond
@pytest.mark.diamond_vhdl
@pytest.mark.sim_lib
def test_diamond_vhdl_b():
    print()
    _execute_test("diamond_vhdl_b", "synplify", "LFSC3GA80E-6FF1704C", "run_diamond.py", "--sim-all -lno")


@pytest.mark.diamond
@pytest.mark.diamond_verilog
@pytest.mark.sim_lib
def test_diamond_verilog_a():
    print()
    _execute_test("diamond_verilog_a", "lse", "LFXP2-8E-7FT256C", "run_diamond.py", "--sim-all -lno")


@pytest.mark.diamond
@pytest.mark.diamond_verilog
def test_diamond_verilog_b():
    print()
    _execute_test("diamond_verilog_b", "synplify", "LFE5U-85F-7BG554C", "run_diamond.py", "--sim-all -lyes")


@pytest.mark.radiant
@pytest.mark.radiant_vhdl
def test_radiant_vhdl_a():
    print()
    _execute_test("radiant_vhdl_a", "lse", "LFCPNX-100-9LFG672C", "run_radiant.py", "--sim-all -lyes")


@pytest.mark.radiant
@pytest.mark.radiant_vhdl
@pytest.mark.sim_lib
def test_radiant_vhdl_b():
    print()
    _execute_test("radiant_vhdl_b", "synplify", "ap6a00-65-9FBG484C", "run_radiant.py", "--sim-all -lno")


@pytest.mark.radiant
@pytest.mark.radiant_verilog
@pytest.mark.sim_lib
def test_radiant_verilog_a():
    print()
    _execute_test("radiant_verilog_a", "lse", "LFMXO5-25-9BBG400C", "run_radiant.py", "--sim-all -lno")


@pytest.mark.radiant
@pytest.mark.radiant_verilog
def test_radiant_verilog_b():
    print()
    _execute_test("radiant_verilog_b", "synplify", "LIFCL-40-8BG400C", "run_radiant.py", "--sim-all -lyes")

