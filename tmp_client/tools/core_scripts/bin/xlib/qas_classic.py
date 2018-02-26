"""
[QAS Information]
Owner = Sean
QOR Level = 1
ID = 006_register_en_set
Keyword = LST
QAS Type = LST
[Case Information]
Family = LatticeECP4UM
Package = CABGA564
Module = register_en_set
Project = register_en_set
File List = 006_register_en_set.v,006_register_en_set_tb.v
Design = register_en_set
Device = LFE4UM-85F
Entry = Pure Verilog HDL
Speed = 8
[QAS Description]
; Test case for Synthesis Project
"""
import os
import re

import xTools

__author__ = 'syan'

class qasFileParser:
    def __init__(self, qas_file, debug):
        self.qas_file = qas_file
        self.debug = debug
        self.qas_root = os.path.dirname(qas_file)

        self.default_sim_top = "testbench"
        self.default_sim_time = "10 us"
        self.qas_info = dict()
        self.case_info_name = "Case Information"

    def get_qas_info(self):
        return self.qas_info

    def process(self):
        sts, qas_options = xTools.get_conf_options(self.qas_file, key_lower=False)
        if sts:
            return 1
        self.case_info = qas_options.get(self.case_info_name)
        if not self.case_info:
            xTools.say_it("Error. No [%s] in %s" % (self.case_info_name, self.qas_file))
            return 1
        xTools.say_it(self.case_info, "[%s]" % self.case_info_name, self.debug)

        if self.parse_file_list():
            return 1

    def parse_file_list(self):
        file_list = self.case_info.get("File List")
        if not file_list:
            xTools.say_it("Error. Not found File List in %s" % self.qas_file)
            return 1
        # ---------------------------------------------
        file_list = re.split(",", file_list)
        p_tb = re.compile("_tb\W")
        tb_file, src_files = "", list()
        for item in file_list:
            item =  item.strip()
            if not item: continue
            item = xTools.get_relative_path(item, self.qas_root)
            if p_tb.search(item):
                tb_file = item
            else:
                fext = xTools.get_fext_lower(item)
                if fext in (".v", ".vhd", ".sv"):
                    src_files.append(item)
                else:
                    xTools.say_it("Warning. Will skip the file %s" % item)
        return tb_file, src_files

if __name__ == "__main__":
    my_parser = qasFileParser(r"D:\TODO\011_register_en_reset_set\_qas.info", 1)
    my_parser.process()


