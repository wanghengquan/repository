#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 2:22 PM 3/15/2023
  file: adapters.py.py
  author: Shawn Yan
Description:

"""
import os
import re
import hashlib
from . import utils


def get_text_file_sha1(data_file):
    """
    skip lines:
        verilog comments: //
        Tue Mar 21 06:34:18 2023
        db:timestamp ="1679380235"
    """
    skip_line_patterns = (re.compile("^//"), re.compile(r"([\d:]{8})\s+20"), re.compile("timestamp"))
    sha1_box = hashlib.sha1()
    lines = utils.YieldLines().yield_lines(data_file)
    for line in lines:
        line = line.strip()
        if not line:
            continue
        for sp in skip_line_patterns:
            if sp.search(line):
                break
        else:
            line = line.encode(encoding='utf-8')
            sha1_box.update(line)
    return dict(index0=sha1_box.hexdigest())


def get_text_file_tag_and_sha1(data_file):
    key = os.path.dirname(data_file)
    par_file = os.path.join(key, "step_par.par")
    key = os.path.basename(key)

    my_dict = get_text_file_sha1(data_file)
    res = dict()
    res[key + "_udb2sv_sha1"] = my_dict.get("index0")
    if os.path.isfile(par_file):
        par_data = utils.get_par_data(key, par_file)
        res.update(par_data)
    return res


def get_lse_vm_sha1(data_file):
    key = utils.get_real_key(data_file)
    key += "lse_vm_sha1"

    my_dict = get_text_file_sha1(data_file)
    res = dict()
    res[key] = my_dict.get("index0")
    return res


def get_synplify_vm_sha1(data_file):
    key = utils.get_real_key(data_file)
    key += "synplify_vm_sha1"

    my_dict = get_text_file_sha1(data_file)
    res = dict()
    res[key] = my_dict.get("index0")
    return res


def get_file_size(a_file):
    """ In MB
    """
    if os.path.isfile(a_file):
        size_number = '{:.3f}'.format(os.path.getsize(a_file)/1024/1024)
    else:
        size_number = '-1'
    return dict(index0=size_number)


def get_project_hdl_type_and_synthesis(a_file):
    ignore_types = ("PDC", "SDC", "FDC", "LDC", "SPF", "LPF", "LPC",  "Unknown")
    x_project, y_impl = utils.get_rd_active_data(a_file)
    source_list = y_impl.get("Source")
    source_list = source_list if isinstance(source_list, list) else [source_list]  # one source only
    type_set = set()
    for foo in source_list:
        _ts = foo.get("@type_short")
        chk_ts = _ts in ignore_types
        chk_ex = foo.get("@excluded") == "TRUE"
        chk_ss = foo.get("@syn_sim") == "SimOnly"
        if chk_ts or chk_ex or chk_ss:
            continue
        type_set.add(_ts)
    type_list = list(type_set)
    type_list.sort()
    return dict(HDL_type=";".join(type_list), synthesis=y_impl.get("@synthesis"))


def get_radiant_twr_data(twr_file, use_ht_data="yes"):
    extractor = utils.ScanRadiantTimingReport(use_ht_data)
    extractor.process(twr_file)
    return extractor.get_twr_data()


def get_diamond_twr_data(twr_file):
    extractor = utils.ScanDiamondTimingReport()
    extractor.process(twr_file)
    return extractor.get_twr_data()


def get_vivado_twr_data(timing_report_file):
    extractor = utils.ScanVivadoTimingReport(timing_report_file)
    extractor.process()
    return extractor.get_twr_data()


def get_lse_lut4_carry_io(synthesis_log):
    if not os.path.isfile(synthesis_log):
        return dict()
    raw_lut4 = raw_carry = None
    raw_io_list = list()
    start_message = "Begin Area Report"
    end_message = "End Area Report"
    p_name_value = re.compile(r"(\S+)\s+=>\s+(\d+)")
    with open(synthesis_log) as ob:
        start = 0
        for line in ob:
            if not start:
                start = start_message in line
            else:
                m_name_value = p_name_value.search(line)
                if m_name_value:
                    _name, _value = m_name_value.group(1), m_name_value.group(2)
                    if _name == "CCU2":
                        raw_carry = _value
                    elif _name == "LUT4":
                        raw_lut4 = _value
                    elif _name in ("BB", "IB", "OB", "BB_B"):
                        raw_io_list.append(_value)
                if end_message in line:
                    break
    if raw_lut4 and raw_carry:
        real_lut4 = str(eval("{} + 2 * {}".format(raw_lut4, raw_carry)))
    elif raw_lut4:
        real_lut4 = raw_lut4
    else:
        real_lut4 = None
    if raw_io_list:
        raw_io = str(eval(" + ".join(raw_io_list)))
    else:
        raw_io = None
    return dict(lse_lut4=real_lut4, lse_carry=raw_carry, lse_io=raw_io)


def get_clk_data_from_mrp(mrp_file):
    start_pattern = re.compile(r"Number\s+of\s+[cC]locks:\s+(\d+)")
    end_patterns = (re.compile(r"Number\s+of"), re.compile("Top.+highest fanout"))
    return utils.get_number_loads_name(mrp_file, "clk", start_pattern, end_patterns)


def get_clken_data_from_mrp(mrp_file):
    start_pattern = re.compile(r"Number\s+of\s+Clock\s+Enables:\s+(\d+)")
    end_patterns = (re.compile(r"Number\s+of"), re.compile("Top.+highest fanout"))
    return utils.get_number_loads_name(mrp_file, "clkEn", start_pattern, end_patterns)


def get_lsr_data_from_mrp(mrp_file):
    start_pattern = re.compile(r"Number\s+of\s+LSRs:\s+(\d+)")
    end_patterns = (re.compile(r"Number\s+of"), re.compile("Top.+highest fanout"))
    return utils.get_number_loads_name(mrp_file, "LSR", start_pattern, end_patterns)


def get_carry_from_mrp(mrp_file):
    mrp_lines = utils.YieldLines().yield_head_lines(mrp_file, 200)
    p_carry = [re.compile(r"Number\s+used\s+as\s+ripple\s+logic:\s+(\d+)"),
               re.compile(r"Number\s+of\s+ripple\s+logic:\s+(\d+)")]
    for line in mrp_lines:
        for p in p_carry:
            m = p.search(line)
            if m:
                raw_number = int(m.group(1))
                return dict(index0=str(int(raw_number / 2)))
    return dict()


def get_simulation_data(log_file):
    sim_type = re.sub("run_", "", os.path.splitext(os.path.basename(log_file))[0])
    p_run_time = re.compile(r"Elapsed\s+Time:\s+(\S+)\s+seconds")  # Elapsed Time: 9.40 seconds
    p_start = re.compile(r"Loading\s+work")
    p_memory = re.compile(r"mem:\s+size\s+during\s+sim.+\s+(\S+)\s+Mb")  # mem: size during sim (VSZ)   502.86 Mb
    p_cpu_time = re.compile(r"Elapsed\s+time:\s+([\d:]+)")   # End time: 13:42:45 on Apr 06,2023, Elapsed time: 0:00:05
    data_dict = dict()
    report_lines = utils.YieldLines().yield_lines(log_file)
    start_tag = False

    # -------------
    def sub_search(report_dict, index_name, message_line, pattern):
        if index_name in report_dict:
            return
        m = pattern.search(message_line)
        if m:
            report_dict[index_name] = m.group(1)
    # -------------

    for line in report_lines:
        sub_search(data_dict, "{}_time".format(sim_type), line, p_run_time)
        if not start_tag:
            start_tag = p_start.search(line)
        else:
            sub_search(data_dict, "{}_cpu_time".format(sim_type), line, p_cpu_time)
            sub_search(data_dict, "{}_Memory".format(sim_type), line, p_memory)

    p_sim_tools = dict(Modelsim=re.compile(r"ModelSim\s+-\s+Lattice\s+FPGA\s+Edition\s+vmap\s+(\S+)"),
                       Questasim=re.compile(r"QuestaSim\S+\s+vmap\s+(\S+)"),
                       vcs=re.compile(r"Compiler\s+version\s+([^;]+);.+Runtime\s+version"),
                       xrun=re.compile(r"xrun:\s+([^:]+):.+Copyright"))
    sim_tool = None
    report_lines = utils.YieldLines().yield_lines(log_file)
    for line in report_lines:
        for k, v in list(p_sim_tools.items()):
            m = v.search(line)
            if m:
                sim_tool = "{}_{}".format(k, m.group(1))
                break
        if sim_tool:
            break
    if sim_tool:
        data_dict["sim_tool"] = sim_tool
    return data_dict


def get_time_and_memory(data_file):
    """
       Total CPU Time: 1 secs
       Total REAL Time: 0 secs
       Peak Memory Usage: 260 MB
    """
    crp_data = dict()
    p_cpu_time = re.compile(r"Total\s+CPU\s+Time:\s+(.+)")
    p_real_time = re.compile(r"Total\s+REAL\s+Time:\s+(.+)")
    p_peak_memory = re.compile(r"Peak\s+Memory\s+Usage:\s+(\S+)")
    crp_patterns = dict(index0=p_cpu_time, index1=p_real_time, index2=p_peak_memory)
    tail_lines = utils.YieldLines().yield_tail_lines(data_file, 100)
    for line in tail_lines:
        for index_name, pattern in list(crp_patterns.items()):
            if index_name not in crp_data:
                m = pattern.search(line)
                if m:
                    crp_data[index_name] = m.group(1)
                    continue
    return crp_data


def get_vivado_utilization_slice_logic(data_file):
    titles_dict = dict(LUT="Slice LUTs", Register="Slice Registers", F7Mux="F7 Muxes", F8Mux="F8 Muxes")
    return utils.get_vivado_utilization_data(data_file, "Slice Logic", titles_dict)


def get_vivado_utilization_slice_logic_distribution(data_file):
    titles_dict = dict(Slice='Slice')
    return utils.get_vivado_utilization_data(data_file, "Slice Logic Distribution", titles_dict)


def get_vivado_utilization_dsp(data_file):
    return utils.get_vivado_utilization_data(data_file, "DSP", dict(DSP="DSPs"))


def get_vivado_utilization_memory(data_file):
    return utils.get_vivado_utilization_data(data_file, "Memory", dict(distributed_RAM="Block RAM Tile"))


def get_radiant_worst_slack(data_file):
    data_lines = utils.YieldLines().yield_lines(data_file)
    p_or1 = re.compile("Hold at Speed .+ Degrees")
    p_or2 = re.compile("Hold Summary Report")
    p_and3 = re.compile("^=+$")
    m_or1 = m_or2 = m_and3 = False
    start_index = 0
    for i, line in enumerate(data_lines):
        m_or = m_or1 or m_or2
        if m_or:
            if p_and3.search(line):
                start_index = i
                break
            else:
                m_or1 = m_or2 = False
        else:
            m_or1 = p_or1.search(line)
            m_or2 = p_or2.search(line)
    #
    p_title = re.compile(r"Listing\s+\d+\s+End\s+Points\s+\|\s+Slack")
    p_slack_number = re.compile(r"\|\s+([-.\d]+)\s+ns$")
    data_lines = utils.YieldLines().yield_lines(data_file)
    start_title = False
    for i, line in enumerate(data_lines):
        if i < start_index:
            continue
        if not start_title:
            start_title = p_title.search(line)
        else:  # use the first one
            m_slack_number = p_slack_number.search(line)
            if m_slack_number:
                return dict(index0=m_slack_number.group(1))
    return dict()

# END OF FILE
