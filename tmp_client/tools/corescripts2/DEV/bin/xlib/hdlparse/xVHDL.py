#!/usr/bin/python  
# -*- coding: utf-8 -*-
# Created on 8:27 2017/11/14
# 
import re

__author__ = 'Shawn Yan'


class VHDLParser:
    def __init__(self):
        self.p_entity = re.compile("entity\s+(\w+)\s+is", re.I)
        self.p_end_entity = re.compile("end\s+entity", re.I)
        self.p_port_start = re.compile("port\s*\(", re.I)
        self.p_port = re.compile("(.+?):\s+(\w+)\s+(\w+)")

    def get_vhdl_names(self, vhdl_file):
        focus_lines = list()
        start_entity = 0
        start_port = 0
        vhdl_dict = dict()
        p_another_end_entity = None

        with open(vhdl_file) as hd:
            for line in hd:
                if line.strip().startswith("--"):
                    continue
                if not start_entity:
                    start_entity = self.p_entity.search(line)
                    if start_entity:
                        vhdl_dict["top"] = start_entity.group(1)
                        p_another_end_entity = re.compile("end %s" % start_entity.group(1), re.I)
                    continue
                if self.p_end_entity.search(line):
                    break
                if p_another_end_entity:
                    if p_another_end_entity.search(line):
                        break
                if not start_port:
                    start_port = self.p_port_start.search(line)
                if start_port:
                    focus_lines.append(line.strip())

        ports = list()
        for foo in focus_lines:
            m_port = self.p_port.search(foo)
            if m_port:
                # clka,clkb   : in std_logic ;
                # sset        : in std_logic ;
                # port (O1 : out std_logic;
                _port = m_port.group(1)
                _port = _port.split(",")
                for mi in _port:
                    mi = mi.strip()
                    if not mi:
                        continue
                    mi = re.sub("^.+\W+", "", mi)
                    ports.append((mi, m_port.group(2), m_port.group(3)))
        vhdl_dict["ports"] = ports
        return vhdl_dict

if __name__ == "__main__":
    import os
    tst_parser = VHDLParser()
    for a, b, c in os.walk(r"D:\RadiantQoRonTMP\one\results\prj6"):
        for item in c:
            if item.endswith(".vhd"):
                hdl_file = os.path.join(a, item)
                print hdl_file
                print tst_parser.get_vhdl_names(hdl_file)
                raw_input("pause")

