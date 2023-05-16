#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 1:59 PM 3/16/2023
  file: buildPatterns.py
  author: Shawn Yan
Description:

"""
import os
import re
import yaml


def create_regexp(raw_string):
    raw_string = re.sub(r"\s+", r"\\s+", raw_string)
    return re.compile(raw_string)


def recursive_string2regexp(raw_dict):
    if not raw_dict:
        return
    for k, v in list(raw_dict.items()):
        if k.endswith("pattern"):
            raw_dict[k] = create_regexp(v)
        elif k.endswith("patterns"):
            raw_dict[k] = [create_regexp(item) for item in v]
        else:
            if k == "fields":
                if not v:
                    continue
                for foo in v:
                    if isinstance(foo, dict):
                        recursive_string2regexp(foo)
            else:
                if isinstance(v, dict):
                    recursive_string2regexp(v)


def build_patterns(yaml_folders):
    first_yaml_patterns = dict()
    yaml_files = list()
    for _folder in yaml_folders:
        if os.path.isdir(_folder):
            for _file in os.listdir(_folder):
                if _file.endswith(".yaml"):
                    abs_yaml = os.path.join(_folder, _file)
                    yaml_files.append(abs_yaml)
    for abs_yaml in yaml_files:
        with open(abs_yaml) as rob:
            original_yaml_dict = yaml.safe_load(rob)
            if not original_yaml_dict:
                print("Warning. Not found any patterns in {}".format(abs_yaml))
                continue
            recursive_string2regexp(original_yaml_dict)
            #
            for this_key, this_value in list(original_yaml_dict.items()):
                if this_key in first_yaml_patterns:
                    print("Warning. Duplicated KEY: {}".format(this_key))
                first_yaml_patterns[this_key] = this_value
    return first_yaml_patterns
