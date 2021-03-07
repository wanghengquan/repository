#!/usr/bin/python  
# -*- coding: utf-8 -*-
import os
import re
import glob

__author__ = 'Shawn Yan'
__date__ = '14:34 2018/9/18'


def get_design_twr_file(top_dir):
    design_twr_list = list()
    for design in os.listdir(top_dir):
        mrp_files = glob.glob(os.path.join(top_dir, design, "_scratch", "*", "*.mrp"))
        if not mrp_files:
            continue
        design_twr_list.append([design, os.path.splitext(mrp_files[0])[0] + ".twr"])
    return design_twr_list


def get_port_period(twr_file):
    try:
        twr_lines = open(twr_file)
    except:
        print "Not found %s" % twr_file
        return
    start0 = start1 = 0
    ps0, ps1 = re.compile("End of Table of Contents"), re.compile("Setup Constraint Slack Summary")
    hot_lines = list()
    for line in twr_lines:
        if not start0:
            start0 = ps0.search(line)
            continue
        if not start1:
            start1 = ps1.search(line)
            continue
        hot_lines.append(line)
        line = line.strip()
        if not line:
            break
    port_period_list = list()
    p1 = re.compile("-name\s+\{([^\}]+)\}")
    p2 = re.compile("([\d\.]+)\s+ns\s+\|\s+[\d\.]+\s+MHz")
    port_name = "NO_PORT"
    for i, foo in enumerate(hot_lines):
        m1 = p1.search(foo)
        m2 = p2.search(foo)
        if m1:
            port_name = m1.group(1)
        elif m2:
            port_period_list.append([port_name, float(m2.group(1))])
    return port_period_list


if __name__ == "__main__":
    design_twr_list = get_design_twr_file(r"D:\chuang-qian-mingyue-guang\Radiant3506_1MHz\ng_source_ldc")
    print 'ldc_dict = dict()'
    for (design, twr_file) in design_twr_list:
        #print design, twr_file
        print 'ldc_dict["%s"] = %s' % (design, get_port_period(twr_file))
    print "# ---------------------"
    design_twr_list = get_design_twr_file(r"D:\chuang-qian-mingyue-guang\Radiant3506_1MHz\ng_source_fdc")
    print 'fdc_dict = dict()'
    for (design, twr_file) in design_twr_list:
        #print design, twr_file
        print 'fdc_dict["%s"] = %s' % (design, get_port_period(twr_file))
    print "# ---------------------"
