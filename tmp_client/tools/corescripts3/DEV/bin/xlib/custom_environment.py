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
    if "ap6a00" in raw_device:
        os.environ[env_key] = "yes"
    elif "latg1" in raw_device:
        os.environ[env_key] = "yes"
