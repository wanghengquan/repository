#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 8:56 AM 11/7/2022
  file: run_vivado.py
  author: Shawn Yan
Description:

"""
import sys
from xlib import flowVivado

vivado_flow = flowVivado.FlowVivado()
sts = vivado_flow.process()
sys.exit(sts)
