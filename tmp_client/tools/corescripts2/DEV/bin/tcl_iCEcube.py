#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 5:47 PM 10/25/2019
  file: tcl_iCEcube.py
  author: Shawn Yan
Description:
  File: flow.info
  [qa]
  architecture = SBTiCE40UP
  device = iCE40UP5K
  package = CM225
  top_module=ARITHMETICCODER
  src_files =
       <  ./common/STORE_BLOCK.vhd        >
       <  ./common/INPUT_CONTROL.vhd      >
       ...
       <  ./encoder/OUTPUT_UNIT.vhd       >

"""
import os
import re
import sys
import time
import argparse
import ConfigParser

LSE_TEMPLATE = """#-- Lattice, Inc.

#device
-a {architecture}
-d {device}
-t {package}
# -a SBTiCE40UP
# -d iCE40UP5K
# -t CM225
#constraint file

#options
-optimization_goal Area
-twr_paths 3
-bram_utilization 100.00
-ramstyle Auto
-romstyle Auto
-use_carry_chain 1
-carry_chain_length 0
-resource_sharing 1
-propagate_constants 1
-remove_duplicate_regs 1
-max_fanout 10000
-fsm_encoding_style Auto
-use_io_insertion 1
-use_io_reg auto
-resolve_mixed_drivers 0
-RWCheckOnRam 0
-fix_gated_clocks 1
-loop_limit 1950

{source_files}

#set result format/file last
-output_edif lse_flow_Implmnt/lse_flow.edf

#set log file
-logfile "lse_flow_Implmnt/lse_flow.log"
"""

SYNPLIFY_TEMPLATE = """#-- Synopsys, Inc.
#project files
{source_files}

impl -add synp_flow_Implmnt -type fpga

#implementation attributes
set_option -vlog_std v2001
set_option -project_relative_includes 1

#device options
set_option -technology {architecture}
set_option -part {device}
set_option -package {package}
set_option -speed_grade 
set_option -part_companion ""

#compilation/mapping options

# mapper_options
set_option -frequency auto
set_option -write_verilog 0
set_option -write_vhdl 0

# Silicon Blue iCE40UP
set_option -maxfan 10000
set_option -disable_io_insertion 0
set_option -pipe 1
set_option -retiming 0
set_option -update_models_cp 0
set_option -fixgatedclocks 2
set_option -fixgeneratedclocks 0

# NFilter
set_option -popfeed 0
set_option -constprop 0
set_option -createhierarchy 0

# sequential_optimization_options
set_option -symbolic_fsm_compiler 1

# Compiler Options
set_option -compiler_compatible 0
set_option -resource_sharing 1

#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#set result format/file last
project -result_format "edif"
project -result_file ./synp_flow_Implmnt/synp_flow.edf
project -log_file "./synp_flow_Implmnt/synp_flow.srr"
impl -active "synp_flow_Implmnt"
project -run synthesis -clean
"""

TCL_TEMPLATE = """set device  {device}-{package}             
set top_module {top_module}      
set proj_dir [pwd] 
set output_dir "{synthesis_short_name}_flow_Implmnt"   
set edif_file "{synthesis_short_name}_flow"      
set tool_options ":edifparser -y {synthesis_short_name}.pcf"   


########################################### #   Tool Interface      ############################################ 

set sbt_root $::env(SBT_DIR)     

append sbt_tcl $sbt_root "/tcl/sbt_backend_synpl.tcl"   
source $sbt_tcl   

run_sbt_backend_auto $device $top_module $proj_dir $output_dir $tool_options $edif_file  """


def get_status_output(cmd):
    """
    return (status, output) of executing cmd in a shell.
    source from commands.py <def getstatusoutput(cmd)>.
    """
    on_win = (sys.platform[:3] == "win")
    if not on_win:
        cmd = "{ " + cmd + "; }"
    pipe = os.popen(cmd + " 2>&1", "r")
    text = list()
    for item in pipe:
        text.append(item.rstrip())
    try:
        sts = pipe.close()
        if sts is None:
            sts = 0
        if not on_win:
            sts = (sts >> 8)
    except IOError:
        sts = 1
    if sts is None:
        sts = 0
    return sts, text


def win2unix(a_path, use_abs=1):
    """
    transfer a path to unix format
    """
    if use_abs:
        a_path = os.path.abspath(a_path)
    return re.sub(r"\\", "/", a_path)


class AppConfig(ConfigParser.ConfigParser):
    def __init__(self):
        ConfigParser.ConfigParser.__init__(self)

    def optionxform(self, optionstr):
        """
        re-define optionxform, in the release version, return optionstr.lower()
        """
        return optionstr


def get_conf_options(conf_files, key_lower=True):
    """
    get configuration from conf_files, conf_files can be a file or a file list
    all option will not change the case when key_lower is False
    """
    # use <xx> <yy> ... to specify a list string for an option.
    p_multi = re.compile("<([^>]+)>")
    conf_options = dict()
    if key_lower:
        conf_parser = ConfigParser.ConfigParser()
    else:
        conf_parser = AppConfig()
    try:
        conf_parser.read(conf_files)
        for section in conf_parser.sections():
            t_section = dict()
            for option in conf_parser.options(section):
                value = conf_parser.get(section, option)
                value = win2unix(value, 0)
                value_list = p_multi.findall(value)
                if value_list:
                    value = [item.strip() for item in value_list]
                t_section[option] = value
            conf_options[section] = t_section
        return 0, conf_options
    except Exception, e:
        print("Error. Can not parse configuration file(s) %s" % conf_files)
        print(e)
        return 1, ""


class ChangeDir:
    """
    Change the current working directory to a new path.
    and can come back to the original current working directory
    """

    def __init__(self, new_path):
        self.cur_dir = os.getcwd()
        os.chdir(new_path)

    def comeback(self):
        os.chdir(self.cur_dir)


def wrap_md(a_path, comments):
    """
    return 1 if failed to make a new folder if it doesn't exist
    """
    if not a_path:
        print("-- Error. No value specified for %s" % comments)
        return 1
    if not os.path.isdir(a_path):
        try:
            os.makedirs(a_path)
        except Exception, e:
            print("-- Error. can not makedir %s <%s>" % (a_path, comments))
            print(e)
            print("")
            return 1


class SimpleiCEcubeFlow(object):
    def __init__(self):
        pass

    def process(self):
        print("Start running iCEcube tcl flow ...")
        if self.get_options():
            return 1
        self.tag_dir = os.path.join(self.top_dir, self.case, self.tag)
        if wrap_md(self.tag_dir, "TAG Path"):
            return 1
        _recov = ChangeDir(self.tag_dir)
        if not self.synthesis_done:
            if self.generate_synthesis_project_file():
                return 1
        self.run_tcl_flow()

        _recov.comeback()

    def get_options(self):
        parser = argparse.ArgumentParser()
        parser.add_argument("--ice", help="specify iCEcube install path")
        parser.add_argument("--architecture", help="specify architecture name")
        parser.add_argument("--device", help="specify device name")
        parser.add_argument("--package", help="specify package name")
        parser.add_argument("--speed", help="specify speed name")
        parser.add_argument("--tcl-path", help="specify tcl path")
        parser.add_argument("--synthesis", choices=("synplify", "lse"), default="lse", help="specify synthesis name, "
                                                                                            "default is lse")
        parser.add_argument("--synthesis-done", action="store_true", help="use current synthesis result file")
        parser.add_argument("--top-dir", help="specify top case path")
        parser.add_argument("--case", help="specify case name")
        parser.add_argument("--quiet", action="store_true", help="run quietly")
        parser.add_argument("--tag", help="specify result path, default is _scratch", default="_scratch")
        opts = parser.parse_args()
        self.ice = opts.ice
        self.architecture = opts.architecture
        self.device = opts.device
        self.package = opts.package
        self.speed = opts.speed
        self.tcl_path = opts.tcl_path
        self.synthesis = opts.synthesis
        self.synthesis_done = opts.synthesis_done
        self.top_dir = opts.top_dir
        self.case = opts.case
        self.quiet = opts.quiet
        self.tag = opts.tag
        if not self.top_dir and not self.case:
            self.top_dir, self.case = os.path.dirname(os.getcwd()), os.path.basename(os.getcwd())
        elif not self.top_dir:
            self.top_dir = os.getcwd()
        if not os.path.isdir(self.top_dir):
            print("Error. Not found top_dir: {}".format(self.top_dir))
            return 1
        case_path = os.path.join(self.top_dir, self.case)
        if not os.path.isdir(case_path):
            print("Error. Not found case: {}".format(case_path))
            return 1
        if not os.path.isdir(self.ice):
            print("Error. Not found iCEcube install path: {}".format(self.ice))
            return 1
        if self.tcl_path:
            if not os.path.isdir(self.tcl_path):
                print("Error. Not found TCL path: {}".format(self.tcl_path))

    def generate_synthesis_project_file(self):
        info_file = os.path.join(self.top_dir, self.case, "flow.info")
        if not os.path.isfile(info_file):
            print("Error. Not found info file: {}".format(info_file))
            return 1
        sts, info_options = get_conf_options(info_file)
        if sts:
            return 1
        real_options = info_options.get("qa")
        top = real_options.get("top_module")
        if not top:
            print("Error. Not found top_module name in {}".format(info_file))
            return 1
        self.arguments = dict()
        self.arguments["top_module"] = top
        self.arguments["architecture"] = self.architecture
        self.arguments["device"] = self.device
        self.arguments["package"] = self.package
        self.arguments["speed"] = self.speed
        self.arguments["synthesis_short_name"] = "lse" if self.synthesis == "lse" else "synp"
        _src_files = real_options.get("src_files")
        src_files = list()
        ###########
        go_here = ChangeDir(os.path.join(self.top_dir, self.case))
        for foo in _src_files:
            abs_foo = os.path.abspath(foo)
            rel_foo = os.path.relpath(abs_foo, self.tag_dir)
            src_files.append(win2unix(rel_foo, 0))
        go_here.comeback()
        ###########
        source_files = list()
        if self.synthesis == "synplify":
            for x in src_files:
                hdl_type = "-vhdl" if x.lower().endswith(".vhd") else "-verilog"
                source_files.append('add_file {} -lib work "{}"'.format(hdl_type, x))
        else:
            for x in src_files:
                hdl_type = "-lib work -vhd" if x.lower().endswith(".vhd") else "-ver"
                source_files.append('{} "{}"'.format(hdl_type, x))
        self.arguments["source_files"] = "\n".join(source_files)
        for k, v in self.arguments.items():
            if not v:
                self.arguments[k] = real_options.get(k, "")

        if self.synthesis == "lse":
            self.synthesis_project_file = "run_lse.prj"
            tmpl = LSE_TEMPLATE
        else:
            self.synthesis_project_file = "run_syn.prj"
            tmpl = SYNPLIFY_TEMPLATE
        with open(self.synthesis_project_file, "w") as ob:
            ob.write(tmpl.format(**self.arguments))

    def run_tcl_flow(self):
        cmd_lines = list()
        os_name = "nt" if sys.platform.startswith("win") else "lin64"
        os_type_name = "win32" if sys.platform.startswith("win") else "linux"
        ###
        self.opt_path_x = os.path.join(self.ice, "sbt_backend", "bin", os_type_name, "opt")
        self.lse_bin_x = os.path.join(self.ice, "LSE", "bin", os_name)
        self.synp_bin_x = os.path.join(self.opt_path_x, "synpwrap")
        ###

        if not self.synthesis_done:
            if self.synthesis == "lse":
                cmd_lines.append("{}/synthesis -f {}".format(self.lse_bin_x, self.synthesis_project_file))
            else:
                cmd_lines.append("{}/synpwrap -prj {} -log icelog.log".format(self.synp_bin_x, self.synthesis_project_file))
        self.create_env_dict()
        real_tcl_path = "{}/".format(self.tcl_path) if self.tcl_path else ""
        tcl_file = "iCEcube2_flow.tcl"
        with open(tcl_file, "w") as ob:
            ob.write(TCL_TEMPLATE.format(**self.arguments))
        cmd_lines.append("{}tclsh iCEcube2_flow.tcl".format(real_tcl_path))

        real_cmd_lines = list()
        for foo in cmd_lines:
            real_cmd_lines.append(win2unix(foo, 0))

        batch_log = "batch_flow.log"
        with open(batch_log, "a") as ob:
            for k, v in self.env_dict.items():
                print >> ob, "set {}={}".format(k, v)
            for bar in real_cmd_lines:
                print >> ob, bar
            print >> ob, "Time: {}".format(time.ctime())
            print >> ob, "-" * 20

        for cmd_line in real_cmd_lines:
            print("... running {}".format(cmd_line))
            if self.quiet:
                sts, res = get_status_output(cmd_line)
                with open("flow_steps.log", "a") as ob:
                    print >> ob, "\n".join(res)
                    print >> ob, "Time: {}".format(time.ctime())
                    print >> ob, "-" * 20
            else:
                sts = os.system(cmd_line)
            if sts:
                print("Failed to execute {}".format(cmd_line))
                return 1

    def create_env_dict(self):
        self.env_dict = dict()
        self.env_dict["SBT_DIR"] = os.path.join(self.ice, "sbt_backend")
        if self.synthesis == "lse":
            self.env_dict["FOUNDRY"] = os.path.join(self.ice, "LSE")
            if not sys.platform.startswith("win"):
                self.env_dict["LD_LIBRARY_PATH"] = "{}:{}:{}".format(self.opt_path_x, self.lse_bin_x, os.getenv("LD_LIBRARY_PATH"))
        else:
            self.env_dict["SYNPLIFY_PATH"] = os.path.join(self.ice, "synpbase")
            self.env_dict["LD_LIBRARY_PATH"] = "{}:{}:{}".format(self.opt_path_x, self.synp_bin_x, os.getenv("LD_LIBRARY_PATH"))
        for k, v in self.env_dict.items():
            os.environ[k] = v


if __name__ == "__main__":
    my_flow = SimpleiCEcubeFlow()
    my_flow.process()

