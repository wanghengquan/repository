#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 3:27 PM 12/1/2021
  file: reportgen.py
  author: Shawn Yan
Description:

"""
import os
from xlib import xOptions
from xlib import xDump
from xlib import xReport


class ValidationReport(xOptions.XOptions):
    def __init__(self):
        _root_path = os.path.dirname(os.path.abspath(__file__))
        _conf_path = os.path.join(_root_path, "conf")
        super(ValidationReport, self).__init__(_conf_path)

    def process(self, args=None):
        options_ns = self.get_options_ns(args)  # name space
        options_ns.root_file = os.path.abspath(__file__)
        if options_ns.op_dump:
            flow_cls = xDump.DataDump(options_ns)
            flow_cls.process()
        elif options_ns.op_report:
            flow_cls = xReport.DataReport(options_ns)
            flow_cls.process()


if __name__ == "__main__":
    v_r = ValidationReport()
    v_r.process()
