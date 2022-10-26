#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 9:52 AM 9/2/2022
  file: gen_avc.py
  author: Shawn Yan
Description:

"""
import os
import sys
import argparse

lib_path = os.path.dirname(os.path.abspath(__file__))
lib_path = os.path.abspath(os.path.join(lib_path, "..", "..", "bin"))
sys.path.insert(0, lib_path)
from xlib import xSimrel

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--pad-file", help="specify pad file")
parser.add_argument("-l", "--lst-file", help="specify lst file")
opts = parser.parse_args()
pad_file = opts.pad_file
lst_file = opts.lst_file
shawn = dict()
shawn["active_input_1"] = "ddr_dq_oe[0]:ddr_dq_io[0]"
shawn["active_input_2"] = "ddr_dq_oe[1]:ddr_dq_io[1]"
shawn["active_input_3"] = "ddr_dq_oe[2]:ddr_dq_io[2]"
shawn["active_input_4"] = "ddr_dq_oe[3]:ddr_dq_io[3]"
shawn["active_input_5"] = "ddr_dq_oe[4]:ddr_dq_io[4]"
shawn["active_input_6"] = "ddr_dq_oe[5]:ddr_dq_io[5]"
shawn["active_input_7"] = "ddr_dq_oe[6]:ddr_dq_io[6]"
shawn["active_input_8"] = "ddr_dq_oe[7]:ddr_dq_io[7]"
shawn["active_input_9"] = "ddr_dq_oe[8]:ddr_dq_io[8]"
shawn["active_input_10"] = "ddr_dq_oe[9]:ddr_dq_io[9]"
shawn["active_input_11"] = "ddr_dq_oe[10]:ddr_dq_io[10]"
shawn["active_input_12"] = "ddr_dq_oe[11]:ddr_dq_io[11]"
shawn["active_input_13"] = "ddr_dq_oe[12]:ddr_dq_io[12]"
shawn["active_input_14"] = "ddr_dq_oe[13]:ddr_dq_io[13]"
shawn["active_input_15"] = "ddr_dq_oe[14]:ddr_dq_io[14]"
shawn["active_input_16"] = "ddr_dq_oe[15]:ddr_dq_io[15]"
shawn["active_input_17"] = "ddr_dmi_oe[0]:ddr_dmi_io[0]"
shawn["active_input_18"] = "ddr_dmi_oe[1]:ddr_dmi_io[1]"
shawn["active_input_19"] = "ddr_dqs_oe[0]:ddr_dqs_io[0]+"
shawn["active_input_20"] = "ddr_dqs_oe[1]:ddr_dqs_io[1]+"
shawn["active_input_21"] = "ddr_dqs_oe[0]:ddr_dqs_io[0]-"
shawn["active_input_22"] = "ddr_dqs_oe[1]:ddr_dqs_io[1]-"
shawn["active_input_23"] = "direction_r[0]:LED[0]"
shawn["active_input_24"] = "direction_r[1]:LED[1]"
shawn["active_input_25"] = "direction_r[2]:LED[2]"
shawn["active_input_26"] = "direction_r[3]:LED[3]"
shawn["active_input_27"] = "direction_r[4]:LED[4]"
shawn["active_input_28"] = "direction_r[5]:LED[5]"
shawn["active_input_29"] = "direction_r[6]:LED[6]"
shawn["active_input_30"] = "direction_r[7]:LED[7]"
shawn["active_output_30"] = "LED[8]"
shawn["active_output_30"] = "LED[9]"

# generate_avc_file(avc_file, lst_file, pad_file, sim_vendor_name, simrel_options):
xSimrel.generate_avc_file("test.avc", lst_file, pad_file, "Modelsim", shawn)
