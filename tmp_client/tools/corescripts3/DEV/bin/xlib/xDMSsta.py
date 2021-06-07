#!/usr/bin/python  
# -*- coding: utf-8 -*-
"""
Hi Shawn,

I have a new request for routing DMS testing. Below is detail.

1.       The case only has one structural Verilog file, tbb file , info and conf file
2.       Using command "sv2udb  *.v  -o  test.udb  -w" to generate udb file
3.       Using command "par -p -k  test.udb  test_par.udb -w" to run PAR
4.       Using command "bitgen -w -simbitmap test_par.udb" to bitstream file(*.txt format)
5.       Using command "awk -f  /conf/thunderplus_NG/cbit_conv2mti_thunderplus.txt test_par.txt > dffess.do" to generate file "dffess.do"
6.       Using *.pad file, "conf\thunderplus_NG\SBT_ICE_packages_IO_table_ICE65L.csv" and "conf\thunderplus_NG\IO_thunderplus.txt" to generate file "io.v"
7.       Generate attached do file, modify the scripts path.
8.       Call Questa Sim to run the do file
9.       Check the conf file.

"""
import os
from . import xTools
from . import xDMS

__author__ = 'Shawn Yan'
__date__ = '13:35 2018/1/26'


SIM_DO = """vlib work
vmap Tplus_DMS %(conf_path)s/LIB_thunderplus
vlog +define+CHIP +incdir+%(conf_path)s/thunderplus_NG %(tb_file)s
vlog +define+CHIP %(conf_path)s/thunderplus_NG/via.v
vsim  +nowarnTFMPC -novopt -l sim.log -L Tplus_DMS -L work tb
do dffess.do
force -freeze {sim:/tb/chip/gsr } 1 0
run 1ns
force -freeze {sim:/tb/chip/gsr } 0 0
run -all
q -f

"""


class DMSStandalone:
    def __init__(self, scripts_options):
        self.scripts_options = scripts_options
        self.src_design = self.scripts_options.get("src_design")
        self.conf = self.scripts_options.get("conf")
        self.log_file = "_dms.log"
        self.time_file = "_dms.time"
        self.on_win, os_name = xTools.get_os_name()

    def process(self):
        xTools.say_it("Start DMS Standalone flow ...")
        if self.flow_sv2bit():
            return 1
        if xTools.wrap_md("DMS", "DMS Folder"):
            return 1
        _recov = xTools.ChangeDir("DMS")
        if self.flow_prepare_do():
            sts = 1
        elif self.flow_questasim():
            sts = 1
        else:
            sts = 0
        _recov.comeback()
        return sts

    def flow_sv2bit(self):
        src_files = self.scripts_options.get("src_files")
        if isinstance(src_files, str):
            src_files = [src_files]
        if len(src_files) != 1:
            xTools.say_it("Error. check src_files option")
            return 1
        udb_v = src_files[0]
        udb_v = xTools.get_relative_path(udb_v, self.src_design)
        if xTools.not_exists(udb_v, "map_udb_verilog file"):
            return 1
        cmd_list = ["sv2udb %s -o test.udb -w" % udb_v,
                    "par -p -k test.udb test_par.udb -w",
                    "bitgen -w -simbitmap test_par.udb"
                    ]
        for cmd in cmd_list:
            sts = xTools.run_command(cmd, self.log_file, self.time_file)
            if sts:
                return 1

    def flow_prepare_do(self):
        if xTools.not_exists(self.conf, "Conf Path"):
            return 1
        self.conf = xTools.get_relative_path(self.conf, os.getcwd())
        for_awk_file = os.path.join(self.conf, "thunderplus_NG", "cbit_conv2mti_thunderplus.txt")
        for_io_csv = os.path.join(self.conf, "thunderplus_NG", "SBT_ICE_packages_IO_table_ICE65L.csv")
        for_io_txt = os.path.join(self.conf, "thunderplus_NG", "IO_thunderplus.txt")
        for item in (for_awk_file, for_io_csv, for_io_txt):
            if xTools.not_exists(item, "Source conf file"):
                return 1
        if self.on_win:
            awk_exe = xTools.win2unix(os.path.join(self.conf, "bin", "awk.exe"))
            awk_cmd = "%s -f %s ../test_par.txt > dffess.do" % (awk_exe, for_awk_file)
        else:
            awk_cmd = "awk -f %s ../test_par.txt > dffess.do" % for_awk_file
        awk_cmd = xTools.win2unix(awk_cmd, 0)
        if xTools.run_command(awk_cmd, self.log_file, self.time_file):
            return 1
        xDMS.write_io_v_file("io.v", "../test_par.pad", for_io_csv, for_io_txt, "")

    def flow_questasim(self):
        questasim_path = self.scripts_options.get("questasim_path")
        if xTools.not_exists(questasim_path, "Questasim Path"):
            return 1
        sts = 0
        sim = self.scripts_options.get("sim", dict())
        tb = sim.get("tb_file")
        assert isinstance(tb, str), "tb should be a string"
        tb_file = xTools.get_relative_path(tb, self.src_design)
        if xTools.not_exists(tb_file, "Testbench file"):
            sts = 1
        if not sts:
            kwargs = {"conf_path": xTools.win2unix(self.conf, 0), "tb_file": tb_file}
            do_file = "vsim_DMS.do"
            xDMS.unzip_lib_file(self.conf)
            xTools.write_file(do_file, SIM_DO % kwargs)
            sim_cmd = '%s/vsim -l sim_log.txt -c -do "do %s"' % (questasim_path, do_file)
            sim_cmd = xTools.win2unix(sim_cmd, 0)
            sts = xTools.run_command(sim_cmd, self.log_file, self.time_file)
        return sts


if __name__ == "__main__":
    pass
