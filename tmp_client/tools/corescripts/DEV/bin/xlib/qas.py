"""
convert QAS information to standard BQS information
"""
import os
import re
import xLatticeDev
import xLattice
import xTools

from xTools import get_fname, get_fext_lower, win2unix, say_it, get_relative_path, simple_parser

__author__ = 'syan'

qas_check_conf_template = """[configuration information]
area = %(_design_name)s

[method]
sim_check_block_1 = 1

[sim_check_block_1]
title = mapvlog_vs_rtl
golden_file = ./_scratch/sim_map_vlg/%(src_top_module)s.lst
compare_file  = ./_scratch/sim_rtl/%(src_top_module)s.lst
"""

def get_file_list(section_case, src_design):
    # say_it(section_case, "Section Case:")
    _file_list = section_case.get("file list")
    _file_list = re.split(",", _file_list)
    _file_list = [item.strip() for item in _file_list]

    file_list = list()
    tb_file = ""
    uut_name = ""
    p_tb = re.compile("(\w+)_tb$", re.I)

    for item in _file_list:
        fname = get_fname(item)
        fext = get_fext_lower(item)
        item = win2unix(item, 0)
        m_tb = p_tb.search(fname)
        if m_tb:
            tb_file = item
            continue
        if fext in (".v", ".vhd", ".sv"):
            file_list.append(item)
        else:
            say_it("Warning. %s found in _qas.info" % item)

    if tb_file:
        new_tb_file = get_relative_path(tb_file, src_design)
        if not os.path.isfile(new_tb_file):
            say_it("-Error. Not found testbench file: %s" % tb_file)
        else:
            base_module_name = ""
            for item in ("module", "project"):
                base_module_name = section_case.get(item)
                if base_module_name:
                    base_module_name = get_fname(base_module_name)
                    break
            if not base_module_name:
                say_it("Error. Not found base module name")
                return tb_file, file_list, uut_name

            p_uut_name_verilog = re.compile("%s\s+(\w+)" % base_module_name)
            # add_16_SIGNED post(
            p_uut_name_vhdl = re.compile("(\S+)\s*:\s*%s" % base_module_name)
            # uut: mac_ecp4_m5678_09x09_ir_or_dc_mclk_up PORT MAP(
            fext = get_fext_lower(new_tb_file)
            if fext == ".v":
                matched_uut_name = simple_parser(new_tb_file, [p_uut_name_verilog,])
            else:
                matched_uut_name = simple_parser(new_tb_file, [p_uut_name_vhdl,])
            if not matched_uut_name:
                say_it("-Warning. can not find uut name in %s" % tb_file)
            else:
                uut_name = matched_uut_name[1].group(1)
    return tb_file, file_list, uut_name

def get_devkit_from_qas(xml_path, section_case):
    big_version, small_version = xLattice.get_diamond_version()
    xml_file = os.path.join(xml_path, "DiamondDevFile_%s%s.xml" % (big_version, small_version))
    my_parser = xLatticeDev.DevkitParser(xml_file)
    if my_parser.process():
        return
    device = section_case.get("device")
    speed = section_case.get("speed")
    package = section_case.get("package")
    family = section_case.get("family")
    if not device:
        say_it("-Warning. No device found in _qas.info")
        return
    if not speed:
        say_it("-Warning. No speed found in _qas.info")
        return
    if not package:
        say_it("-Warning. No package found in _qas.info")
        return
    if not family:
        say_it("-Warning. No family found in _qas.info")
        return

    device = device.lower()
    speed = speed.lower()
    package = package.lower()
    family = family.lower()

    devkit_detail = my_parser.devkit_dict
    for key, value in devkit_detail.items():
        if value.get("ori_opt") != "COM":
            continue

        _family = value.get("family")
        if _family.lower() != family:
            continue
        _pty = value.get("pty")
        if _pty.lower() != device:
            continue
        _pkg = value.get("pkg")
        if _pkg.lower() != package:
            continue
        _spd = value.get("spd")
        if _spd.lower() ==  speed:
            return key
    say_it("-Warning. Can not find standard devkit for <%s %s %s %s>" % (family, device, package, speed))
    return

def get_qa_options(xml_path, section_case, is_ng_flow):
    qa_options = dict()
    if is_ng_flow:
        devkit = "do not care"
    else:
        devkit = get_devkit_from_qas(xml_path, section_case)
        if not devkit:
            say_it("-Warning. Not get right devkit from qas info file")
    qa_options["devkit"] = devkit
    qa_options["project_name"] = section_case.get("project", "PrjName")
    qa_options["impl_name"] = section_case.get("impl_name", "DmTest")
    try:
        my_module = get_fname(section_case.get("module"))
    except:
        my_module = ""
    qa_options["src_top_module"]= qa_options["top_module"] = my_module
    return qa_options

def get_sim_options():
    sim_options = dict()
    sim_options["sim_top"] = "testbench"
    sim_options["sim_time"] = "10 us"
    return sim_options

def get_local_bqs_options(xml_path, local_options, src_design, is_ng_flow):
    section_case = local_options.get("Case Information")

    local_bqs_options = dict()
    tb_file, file_list, uut_name = get_file_list(section_case, src_design)
    if not tb_file:
        say_it("-Warning. No tb file found")

    if not file_list:
        say_it("-Error. No source file list found.")
        return

    qa_options = get_qa_options(xml_path, section_case, is_ng_flow)
    if not qa_options:
        return
    qa_options["src_files"] = file_list

    sim_options = get_sim_options()
    if tb_file:
        sim_options["tb_file"] = tb_file
    if uut_name:
        sim_options["uut_name"] = uut_name
    _src_top_module = qa_options.get("src_top_module")
    sim_options["src_top_module"] = _src_top_module
    sim_options["resolution"] = "1ns"
    for key in ("resolution", "questasim_resolution"):
        value = section_case.get(key)
        if value:
            sim_options[key] = value

    local_bqs_options["qa"] = qa_options
    local_bqs_options["sim"] = sim_options
    return local_bqs_options

if __name__ == "__main__":
    get_devkit_from_qas(r"C:\_since114\ff\conf", dict())




