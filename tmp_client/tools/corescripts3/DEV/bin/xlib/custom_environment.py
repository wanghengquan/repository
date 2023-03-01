#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 3:41 PM 3/18/2022
  file: custom_environment.py
  author: Shawn Yan
Description:

"""
import os


def env_device_is_apollo(raw_device):
    """SynTrace not support for Apollo device
    """
    raw_device = raw_device.lower()
    env_key = "ENV_DEVICE_IS_APOLLO"
    apollo_names = ("ap6a00", "latg1", "lav-at")
    for foo in apollo_names:
        if foo in raw_device:
            os.environ[env_key] = "yes"


def env_use_front_back_end_vendor():
    os.environ["USE_FE_BE_VENDOR"] = "yes"
