#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 15:36 2019/8/19
  file: pad2signal.py
  author: Yin Wang
Description:
  re-writen by Shawn @ 14:27 2020/5/20

"""
import os
import re
from . import xTools
from collections import OrderedDict


CONDITION = """
set expression {0}
if {{[catch {{condition new -name  {1} -expr $expression}}] != ""}} {{
    condition set -using {1} -expr $expression
}}"""
PREFIX = """
mmap new -reuse -name {Boolean as Logic} -radix %b -contents {{%c=FALSE -edgepriority 1 -shape low}
{%c=TRUE -edgepriority 1 -shape high}}
mmap new -reuse -name {Example Map} -radix %x -contents {{%b=11???? -bgcolor orange -label REG:%x -linecolor yellow -shape bus}
{%x=1F -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=2C -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=* -label %x -linecolor gray -shape bus}}"""
VIEW_WAVE = """
set id [waveform add  -signals [subst  {{
   {{[format {0}]}}
   }} ]]
waveform xview limits 0 1200000ns"""


class GenerateFileSVWF(object):
    def __init__(self, svwf_file, avc_file):
        self.svwf_file = svwf_file
        self.avc_file = avc_file
        self.p_position = re.compile(r"^(\w+)\[(\d+)\]")
        self._tb = "fc_tb."

    def process(self):
        if self.get_port_site_zipped():
            return 1
        self.create_group_data()
        new_lines = list()
        two_list = list()
        for k, v in list(self.group_data.items()):
            one = ", ".join([self._tb + foo[1] for foo in v])
            if len(v) == 1:
                two = k
            else:
                one = '{bus(%s)}' % one
                two = re.sub(r"\]$", ":{}]".format(v[-1][0]), k)
            x_two = two
            if '[' in two:
                two = '{%s}' % two
            new_lines.append(CONDITION.format(one, two))
            if '[' in x_two:
                two = '{\\%s}' % x_two
            two_list.append(two)

        new_lines.append(PREFIX)
        for cat in two_list:
            new_lines.append(VIEW_WAVE.format(cat))
        xTools.write_file(self.svwf_file, new_lines)

    def get_port_site_zipped(self):
        if not os.path.isfile(self.avc_file):
            print(("Not found {}".format(self.avc_file)))
            return 1
        self.port_site_zipped = None
        one = list()
        two = list()
        with open(self.avc_file) as ob:
            last_list = list()
            for line in ob:
                line = line.strip()
                line_list = line.split()
                if line_list[0] == "format":
                    two = line_list
                elif line_list[0] == "#":
                    one = line_list
                if one and two:
                    self.port_site_zipped = list(zip(one, two))
                    break
        if not self.port_site_zipped:
            print(("Error. not found port/site in {}".format(self.avc_file)))
            return 1

    def create_group_data(self):
        self.group_data = OrderedDict()
        next_one = ""
        key = "NA"
        for (port, site) in self.port_site_zipped:
            if port == "#":
                continue
            m_position = self.p_position.search(port)
            if not m_position:
                next_one = ""
                self.group_data[port] = [("-1", site)]
            else:
                if port != next_one:
                    key = port
                if key:
                    self.group_data.setdefault(key, list())
                    self.group_data[key].append((m_position.group(2), site))
                next_one = "{}[{}]".format(m_position.group(1), int(m_position.group(2)) - 1)


if __name__ == "__main__":
    tst_gen = GenerateFileSVWF(r"D:\_inside\simrel_test\new.svwf", r"D:\_inside\simrel_test\fc.avc")
    tst_gen.process()
