#device options
#set_option -technology SBTiCE65
set_option -part_companion ""

#implementation: "rev_1"
impl -add rev_1 -type fpga

#
#implementation attributes

set_option -vlog_std v2001
set_option -project_relative_includes 1

#compilation/mapping options

# mapper_options
set_option -frequency 100
set_option -write_verilog 1
set_option -write_vhdl 0

# Silicon Blue iCE65
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
project -result_file "./rev_1/test_syn.edf"
impl -active "rev_1"
