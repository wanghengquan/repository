#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 11:02 AM 11/7/2022
  file: vivadoUtil.py
  author: Shawn Yan
Description:

"""
import os
import re
import shutil
import xml.etree.ElementTree as XMLElementTree


"""
Clock   Waveform(ns)       Period(ns)      Frequency(MHz)
-----   ------------       ----------      --------------
clk1m   {0.000 5.500}      11.000          90.909
clk22n  {0.000 5.500}      11.000          90.909
  ** OR/AND **
There are 2 register/latch pins with no clock driven by root clock pin: clk1m (HIGH)
There are 3 register/latch pins with no clock driven by root clock pin: clk22n (HIGH)
"""


def get_clocks_from_vivado_timing_summary_routed_rpt_file(rpt_file):
    p_rest = re.compile("Clock Summary")
    p1 = re.compile(r"driven by root clock pin: (\w+)")
    p2 = re.compile(r"Clock\s+Waveform.+Period")
    clocks = list()
    with open(rpt_file) as ob:
        for line in ob:
            if p_rest.search(line):
                break
            m1 = p1.search(line)
            if m1:
                clocks.append(m1.group(1))
    with open(rpt_file) as ob:
        start_tf = False
        for line in ob:
            start_tf = start_tf if start_tf else p2.search(line)
            if start_tf:
                line = line.strip()
                if not line:
                    break
                line_list = line.split()
                end_value = line_list[-1]
                try:
                    float(end_value)
                    clocks.append(line_list[0])
                except ValueError:
                    pass
    clocks = list(set(clocks))
    clocks.sort()
    return clocks


def set_clock_group(clk_list):
    new_list = ['-group [get_clocks {%s}]' % item for item in clk_list]
    new_string = " ".join(new_list)
    return "set_clock_groups %s -physically_exclusive" % new_string


def get_seconds(raw_time):
    raw_time_list = re.split(":", raw_time)
    if len(raw_time_list) == 1:
        return raw_time
    raw_time_list = [float(item) for item in raw_time_list]
    final_time = raw_time_list[0] * 3600 + raw_time_list[1] * 60 + raw_time_list[2]
    int_final_time = int(final_time)
    if int_final_time == final_time:
        return str(int_final_time)
    else:
        return "{:.2f}".format(final_time)


def cleanup_vivado_xdc(xpr_file):
    backup_xpr_file = xpr_file + ".bak"
    if not os.path.isfile(xpr_file):
        return  # do nothing
    if not os.path.isfile(backup_xpr_file):
        shutil.copy2(xpr_file, backup_xpr_file)
    xpr_parser = XMLElementTree.XMLParser(target=XMLElementTree.TreeBuilder(insert_comments=True))
    xpr_tree = XMLElementTree.parse(backup_xpr_file, parser=xpr_parser)
    constraint_hook = xpr_tree.find(".//FileSet[@Type='Constrs']")
    if constraint_hook:
        will_remove_sub_elements = list()
        for foo in list(constraint_hook):
            if foo.tag in ("File", "Config"):
                will_remove_sub_elements.append(foo)
        for bar in will_remove_sub_elements:
            constraint_hook.remove(bar)
        xpr_tree.write(xpr_file, encoding='utf-8', xml_declaration=True)
