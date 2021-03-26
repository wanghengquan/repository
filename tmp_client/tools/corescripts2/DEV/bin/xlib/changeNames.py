#!/usr/bin/python
# -*- coding: utf-8 -*-
# Created on 13:36 2017/11/9
#
import re
import random
import string

from hdlparse import verilog_parser as VP
from hdlparse import xVHDL
import xTools

__author__ = 'Shawn Yan'


def modify_line(line, src, dst, is_verilog):
    if is_verilog:
        if src not in line:
            return line
    else:
        if src.lower() not in line.lower():
            return line
    # previous process can shorten the runtime
    if is_verilog:
        p1 = re.compile("^(\s*)%s(\W)" % src)
        p2 = re.compile("(\W)%s(\W)" % src)
    else:
        p1 = re.compile("^(\s*)%s(\W)" % src, re.I)
        p2 = re.compile("(\W)%s(\W)" % src, re.I)
    # p = p2 if p2.search(line) else p1. Example result => result,
    new_line = p1.sub("\g<1>%s\g<2>" % dst, line)
    new_line = p2.sub("\g<1>%s\g<2>" % dst, new_line)
    return new_line


def change_names(top_name, source_files):
    try:
        t = ChangeNames4Verilog(top_name, source_files)
        t.process()
    except:
        xTools.say_tb_msg()


class ChangeNames4Verilog(object):
    """
    INCLUDE VERILOG AND VHDL, KEEP THE OLD CLASS NAME.
    """
    def __init__(self, top_name, source_files, debug=0):
        self.top_name = top_name
        self.source_files = source_files
        self.debug = debug
        self.seed = string.ascii_letters + string.digits + "_"
        self.used_names = list()
        self.kept_names = ("add", "RGB", "count", "RGB0", "RGB1", "RGB2",
                           "if", "1", "b1")

    def process(self):
        self.create_verilog_file_list()
        self.create_verilog_file_dict()
        self.create_names_map()
        self.update_files()

    def get_random_string(self, min_length=8, max_length=60):
        inner_names = ("_c", "_c_0", "_c_1", "c_i", "")
        while True:
            string_len = random.randint(min_length, max_length)
            new_string = "".join(random.sample(self.seed, string_len))
            new_string = re.sub("^[\d_]+", "", new_string)
            new_string = re.sub("[\d_]+$", "", new_string)
            if not new_string:
                continue
            new_string += random.choice(inner_names)
            if new_string in self.used_names:
                continue
            else:
                self.used_names.append(new_string)
                return new_string

    def create_verilog_file_list(self):
        self.verilog_file_list = list()
        for hdl_file in self.source_files:
            if hdl_file.get("type_short") not in ("Verilog", "VHDL", "Reveal", "RVA", "PDC", "LDC"):
                continue
            elif hdl_file.get("excluded") == "TRUE":
                continue
            elif hdl_file.get("syn_sim") == "SimOnly":
                continue
            self.verilog_file_list.append(hdl_file.get("name"))
        xTools.say_it(self.verilog_file_list, "Verilog File List:", self.debug)

    def create_verilog_file_dict(self):
        self.verilog_file_dict = dict()
        for v_file in self.verilog_file_list:
            lower_file = v_file.lower()
            if lower_file.endswith(".v"):
                parser = VP.VerilogExtractor()
                matched_results = parser.extract_objects(v_file)
                self.verilog_file_dict.setdefault(v_file, list())
                for m in matched_results:
                    t = dict(top=m.name, ports=[(port.name, port.mode, port.data_type) for port in m.ports])
                    self.verilog_file_dict[v_file].append(t)
            elif lower_file.endswith(".vhd"):
                parser = xVHDL.VHDLParser()
                self.verilog_file_dict[v_file] = [parser.get_vhdl_names(v_file)]
        xTools.say_it(self.verilog_file_dict, "Verilog File Dict:", self.debug)

    def create_names_map(self):
        self.name_map = dict()
        for v_file, v_file_content in self.verilog_file_dict.items():
            for foo in v_file_content:
                _top = foo.get("top")
                _ports = foo.get("ports")
                if not _top:
                    continue
                cur_names = [_top] + [_p[0] for _p in _ports]
                for bar in cur_names:
                    if bar not in self.name_map:
                        if bar == self.top_name:
                            new_bar = bar
                        elif bar in self.kept_names:
                            new_bar = bar
                        else:
                            new_bar = self.get_random_string()
                        self.name_map[bar] = new_bar
        xTools.say_it(self.name_map, "Names Mapping:", self.debug)

    def update_files(self):
        if not self.name_map:
            return
        for v_file in self.verilog_file_list:
            ori_v_lines = xTools.get_original_lines(v_file)
            v_ob = open(v_file, "w")
            is_verilog = v_file.lower().endswith(".v")
            for line in ori_v_lines:
                for old_name, new_name in self.name_map.items():
                    line = modify_line(line, old_name, new_name, is_verilog)
                v_ob.write(line)
            v_ob.close()


if __name__ == "__main__":
    import os, shutil
    file1 = r"D:\test\test1114\shawn.vhd.original_bak"
    file2 = r"D:\test\test1114\shawn.vhd"
    os.remove(file2)
    shutil.copy2(file1, file2)
    my_tst = ChangeNames4Verilog("nothing", [{"type_short": "VHDL", "name": file2}])
    my_tst.process()

