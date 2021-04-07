#!/usr/bin/python  
# -*- coding: utf-8 -*-
import os
import re
import glob

__author__ = 'Shawn Yan'
__date__ = '13:34 2018/9/18'


def get_clocks(mrp_file):
    p1 = re.compile("Number of Clocks:\s+(\d+)")
    p2 = re.compile("Number of Clock Enables")
    start = 0
    p_clocks = re.compile("Net\s+([^:]+):.+\(Driver:\s*(.+)\)")
    my_line = ""
    clocks_number = 0
    clocks = list()
    for line in open(mrp_file):
        if not start:
            start = p1.search(line)
            if start:
                clocks_number = int(start.group(1))
            continue
        if p2.search(line):
            break
        my_line += line.rstrip()
        m_clocks = p_clocks.search(my_line)
        if m_clocks:
            clocks.append([m_clocks.group(1), m_clocks.group(2)])
            my_line = ""
    assert clocks_number == len(clocks), "%s Wrong clock number: %s %s " % (mrp_file, clocks_number, clocks)
    return clocks


if __name__ == "__main__":
    dirs = [r"D:\chuang-qian-mingyue-guang\Radiant3506pb\ng_source_ldc",
            r"D:\chuang-qian-mingyue-guang\Radiant3506pb\ng_source_fdc",
            r"D:\chuang-qian-mingyue-guang\Radiant3506till_map\ng_source_fdc",
            r"D:\chuang-qian-mingyue-guang\Radiant3506till_map\ng_source_ldc"]
    big_dict = dict()
    for d in dirs:
        for design in os.listdir(d):
            mrp_files = glob.glob(os.path.join(d, design, "_scratch", "*", "*.mrp"))
            if not mrp_files:
                continue
            raw_clocks = get_clocks(mrp_files[0])
            _ports = [x for x in [item[1] for item in raw_clocks] if "Port" in x]
            _ports = [item.split()[-1] for item in _ports]
            _ports.sort()
            if design not in big_dict:
                big_dict[design] = _ports
            else:
                last_data = big_dict.get(design)
                if last_data != _ports:
                    print(last_data, _ports)
                    print("Check Design: %s %s" % (d, design))
    designs = list(big_dict.keys())
    designs.sort()
    for k in designs:
        v = big_dict.get(k)
        print('design_port_dict["%s"] = %s' % (k, v))