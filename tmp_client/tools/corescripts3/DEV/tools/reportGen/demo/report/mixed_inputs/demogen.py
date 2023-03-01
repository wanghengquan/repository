#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 4:46 PM 12/20/2021
  file: demogen.py
  author: Shawn Yan
Description:

"""

x = ("E30", "L26", "S21", "d1_M29")
y = ("lse", "syn")

for xx in x:
    for yy in y:
        section_name = "jedi_{}_{}".format(xx, yy)
        print("[sheet {}]".format(section_name))
        print("src = 142037")
        print("dst = 141233")
        print("section = {}".format(section_name))
        gn = "JediD1" if "d1" in xx else "Jedi"
        print("group_name = {} w {}".format(gn, yy))
        print("sub_name = {}".format(xx))
        print("")





