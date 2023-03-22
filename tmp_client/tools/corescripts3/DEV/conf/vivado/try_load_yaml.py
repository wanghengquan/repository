#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 10:19 AM 11/8/2022
  file: try_load_yaml.py
  author: Shawn Yan
Description:

"""
import yaml
import json

with open("general.yaml") as ob:
    dd = yaml.safe_load(ob)

print(json.dumps(dd, indent=2))
