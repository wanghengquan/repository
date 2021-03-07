#!/usr/bin/python  
# -*- coding: utf-8 -*-
import os
import argparse

svn_url = "http://lshlabd0011/radiant/trunk/general/impl_00_synthesis_engine/QoR"
radiant_dict = {"3506": "D:/radiant_auto/radiant3506",
                "11b2": "D:/radiant_auto/radiant11b2"}
pub_string = "--devkit=iCE40UP5K-CM225I --goal=timing --scan-rpt"
syn_dict = {"ng_source_fdc": "--synthesis=synplify", "ng_source_ldc": "--synthesis=lse"}


class RunThunderPlus(object):
    def __init__(self):
        self.radiant_bin = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "bin", "run_radiant.py"))

    def process(self):
        self.get_options()
        self.get_case_sources()
        self.get_common_string()
        self.write_lines()

    def get_options(self):
        parser = argparse.ArgumentParser()
        parser.add_argument("--radiant", choices=radiant_dict.keys(), help="specify radiant build name")
        parser.add_argument("--pushbutton", action="store_true", help="run pushbutton flow")
        parser.add_argument("--name", default="runThunderPlus", help="specify run name")
        opts = parser.parse_args()
        self.radiant = opts.radiant
        self.pushbutton = opts.pushbutton
        self.name = os.path.abspath(opts.name)

    def get_case_sources(self):
        if not os.path.isdir(self.name):
            svn_cmd = "svn export %s %s" % (svn_url, self.name)
            os.popen(svn_cmd)

    def get_common_string(self):
        self.common_string1 = "python {} --top-dir={}".format(self.radiant_bin, self.name)
        self.pb_or_sweep = "--pushbutton" if self.pushbutton else "--fmax-sweep=10 200 10"
        self.common_string2 = "{} --radiant={}".format(pub_string, radiant_dict.get(self.radiant, "NotFoundRadiant"))

    def write_lines(self):
        lines_file = os.path.join(self.name, "run_all.lines")
        lines_ob = open(lines_file, 'w')
        for k, v in syn_dict.items():
            _path = os.path.join(self.name, k)
            for design in os.listdir(_path):
                abs_design = os.path.join(_path, design)
                if os.path.isfile(abs_design):
                    continue
                print >> lines_ob, r"{}\{} --design={} {} {} {}".format(self.common_string1, k, design, v,
                                                                        self.pb_or_sweep, self.common_string2)
        lines_ob.close()


if __name__ == "__main__":
    t = RunThunderPlus()
    t.process()
