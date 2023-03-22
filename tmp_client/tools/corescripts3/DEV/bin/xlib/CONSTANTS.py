#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 8:58 AM 11/7/2022
  file: CONSTANTS.py
  author: Shawn Yan
Description:

"""
from collections import OrderedDict

# START V-I-V-A-D-O C-O-N-S-T-A-N-T-S /////////////////
__title = ("description", "sim_mode_and_type", "exec_path")
__behav = ("Behavioral", "", "behav")
__psf = ("Post-Synthesis Functional", "-mode post-synthesis -type functional", "synth/func")
__pst = ("Post-Synthesis Timing", "-mode post-synthesis -type timing", "synth/timing")
__pif = ("Post-Implementation Functional", "-mode post-implementation -type functional", "impl/func")
__pit = ("Post-Implementation Timing", "-mode post-implementation -type timing", "impl/timing")
VIVADO_SIMULATION_SETTINGS = OrderedDict()
VIVADO_SIMULATION_SETTINGS["behav"] = dict(zip(__title, __behav))
VIVADO_SIMULATION_SETTINGS["psf"] = dict(zip(__title, __psf))
VIVADO_SIMULATION_SETTINGS["pst"] = dict(zip(__title, __pst))
VIVADO_SIMULATION_SETTINGS["pif"] = dict(zip(__title, __pif))
VIVADO_SIMULATION_SETTINGS["pit"] = dict(zip(__title, __pit))

VIVADO_SIMULATOR_SETTINGS = OrderedDict()
VIVADO_SIMULATOR_SETTINGS["xsim"] = dict(description="XSim")
VIVADO_SIMULATOR_SETTINGS["questa"] = dict(description="Questa")
VIVADO_SIMULATOR_SETTINGS["modelsim"] = dict(description="ModelSim")
VIVADO_SIMULATOR_SETTINGS["riviera"] = dict(description="Riviera")
VIVADO_SIMULATOR_SETTINGS["activehdl"] = dict(description="ActiveHDL")

VIVADO_SYNTHESIS_SETTINGS = OrderedDict()
VIVADO_SYNTHESIS_SETTINGS["xsyn"] = dict(description="Xilinx Vivado Synthesis")
VIVADO_SYNTHESIS_SETTINGS["synplify"] = dict(description="SynplifyPro")

FMT_OPEN_PROJECT = "open_project {xpr_file}"
STR_CLOSE_PROJECT = "close_project"
STR_LAUNCH_SYNTHESIS = """
set_property AUTO_INCREMENTAL_CHECKPOINT 0 [get_runs synth_1]
set r [catch {reset_run synth_1} msg]
launch_runs synth_1 -jobs 6
wait_on_run synth_1
""".strip()
FMT_LAUNCH_IMPLEMENTATION = """
set r [catch {{reset_run impl_1}} msg]
launch_runs impl_1 {impl_to_bitstream} -jobs 6
wait_on_run impl_1
""".strip()
FMT_COMPILE_SIM_LIB = "compile_simlib -simulator_exec_path {{{simulator_path}}}  -simulator {simulator_lower} "
FMT_COMPILE_SIM_LIB += " -gcc_exec_path {{{gcc_path}}} -family kintex7 -language all -library all -dir {{{ovi_lib}}}"
FMT_SET_TARGET_SIMULATOR = "set_property target_simulator {simulator_name} [current_project]"
FMT_SET_SIMULATOR_LIBRARY = "set_property compxlib.{simulator_lower}_compiled_library_dir {ovi_lib} [current_project]"
FMT_SET_SIMULATION_RUNTIME = "set_property -name {simulator_lower}.simulate.runtime} -value {{{sim_time}}} "
FMT_SET_SIMULATION_RUNTIME += " -objects [get_filesets sim_1]"
STR_SET_GEN_SIM_SCRIPTS_ONLY = "set_property generate_scripts_only 1 [current_fileset -simset]"
FMT_LAUNCH_SIMULATION = """
# ----- Simulation: {sim_mode_and_type}
set r [catch {{reset_simulation -simset sim_1 -mode {sim_mode_and_type}}} msg]
launch_simulation {simulator_and_gcc} {sim_mode_and_type}
cd {simulation_results_directory}
set start_time [clock seconds]
set r [catch {{exec compile.bat}} msg]
set r [catch {{exec elaborate.bat}} msg]
set r [catch {{exec simulate.bat}} msg]
set end_time [clock seconds]
set elapsed_time [expr $end_time - $start_time]
set fp [open "{simulation_type}.elapsed" w]
set format_time [clock format $end_time -format {{%D %T}}]
puts $fp "$format_time -- Elapsed Time: $elapsed_time seconds"
close $fp
""".strip()
FMT_TCL_SYNPLIFY = """
history clear
project -load {synplify_project_file}
project -run
project -close
""".strip()
FMT_XDC = "create_clock -period {period} -name {clk_name} -waveform {{0.000 {half_period}}} [get_ports {clk_name}]"
FMT_ADD_XDC = """
set r [catch {{ remove_files -fileset constrs_1 {xdc_file} }} msg]
add_files -fileset constrs_1 -norecurse {xdc_file}
set_property target_constrs_file {xdc_file} [current_fileset -constrset]
""".strip()
# END OF V-I-V-A-D-O C-O-N-S-T-A-N-T-S ////////////////

