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
ORIGIANL_CONF = """[configuration information]
area = active-hdl
type = simulation

[method]
check_lines_1 = 1

[check_lines_1]
title = sim_check
file = ./*tag*/sim_par_vlg/run_sim_par_vlg.log
check_1  = sim_pass
"""


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


def _wrap_run_command(design, cmd_line):
    print(cmd_line)
    sts, text = xTools.get_status_output(cmd_line)
    error_message = _find_error(text)
    if error_message:
        assert 0, "Failed to {}, {}".format(design, error_message)


def _execute_test(design, synthesis, devkit, py, others):
    build_env_name = "EXTERNAL_RADIANT_PATH" if py == "run_radiant.py" else "EXTERNAL_DIAMOND_PATH"
    build_env = os.getenv(build_env_name)
    assert build_env, "Error. Not specified {}".format(build_env_name)
    cmd_line = "{} {}/{} --top-dir {}/cases --synthesis {}".format(sys.executable, BIN_DIR, py, TESTS_DIR, synthesis)
    cmd_line += " --devkit {} --design {} --tag flow_{} {}".format(devkit, design, synthesis, others)
    cmd_line = xTools.win2unix(cmd_line)
    _wrap_run_command(design, cmd_line)


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


def _test_radiant_simulation_library(oem_sim_library=False):
    """
    set EXTERNAL_RADIANT_PATH=C:\radiant_auto\ng3_2.383
    pytest -vs -m "radiant_simulation"
    """
    print()
    design_name = "radiant_oem_simulation" if oem_sim_library else "radiant_custom_simulation"
    design_dir = os.path.join(TESTS_DIR, "cases", design_name)
    recov = xTools.ChangeDir(design_dir)
    sds_files_dir = os.path.abspath("sds_files")
    xTools.wrap_rm_rf(sds_files_dir, 'sds folder')
    xTools.wrap_md(sds_files_dir)
    _rtf = xTools.win2unix(os.path.join(os.getenv("EXTERNAL_RADIANT_PATH", "SHOULD_SET_FOUNDRY_ENV"), "ispfpga"))
    sds_cmd = "{0}/bin/nt64/sdsgen.exe -o {1} -rtf {0}".format(_rtf, sds_files_dir)
    _wrap_run_command(design_name, sds_cmd)
    devices = list()
    for foo in os.listdir(sds_files_dir):
        abs_foo = os.path.join(sds_files_dir, foo)
        sts, options = xTools.get_options(abs_foo, key_is_lower=False)
        if options:
            x = options.get("Generic Devices")
            x_keys = list(x.keys())
            x_keys.sort()
            devices.append(x_keys[-1])
    recov.comeback()

    for d in devices:
        d = re.sub(r"\$.+$", "", d)
        t_n = re.sub(r"\W", "_", d)
        if oem_sim_library:
            _a = "--tag oem_{}".format(t_n)
        else:
            _a = "--tag custom_{} -lno".format(t_n)
        _execute_test(design_name, "synplify", d, "run_radiant.py", "--sim-all {}".format(_a))
        with open(os.path.join(design_dir, "bqs.conf"), "w") as ob:
            print(ORIGIANL_CONF, file=ob)


@pytest.mark.radiant_simulation
@pytest.mark.radiant_oem_simulation
def test_radiant_oem_simulation_library():
    _test_radiant_simulation_library(oem_sim_library=True)


@pytest.mark.radiant_simulation
@pytest.mark.radiant_custom_simulation
def test_radiant_custom_simulation_library():
    _test_radiant_simulation_library(oem_sim_library=False)
