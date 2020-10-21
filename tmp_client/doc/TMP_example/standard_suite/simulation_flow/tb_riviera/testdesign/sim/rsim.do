#####################################do file#####################################
#.do config file
#20140210 jason
#usage:
#dev_lib example:C:\\Users\\lattice.lsh-piano-vm3\\Desktop\\macro_file\\demo\\sim\\rsim_lib\\ovi_machxo3\\ovi_machxo3.lib
#execute this file in CMD:vsimsa -l sim_log.txt -do <do file name> <dev_lib> <pri_lib> <cmd or gui>
#execute this file in GUI:do <do file name> <dev_lib> <pri_lib> [cmd or gui]

##########config start##########
#<START>

##<cfg_start>
set IgnoreError 1
set dev_lib $1
set pri_lib $2
set gui_cmd $3
##<cfg_end>

##<lib_start>
##<step1>construct a work lib
vlib work
##<step2>connect some other lib
vmap ovi_machxo3l $dev_lib
##<lib_end>

##compile source files if you use VHDL please use vcom
##<source_start>
vlog ../source/top.v
##<source_end>

##<tb_start>
vlog ./sim_tb.v
##<tb_end>

##prepare for simulation
##<pre_start>
radix -hex
##<pre_end>

##start to run simulation
##<sim_start>
vsim  +access +r -lib work sim_top  -L ovi_machxo3l
if {$gui_cmd == "cmd"} {
    wave -noreg post/*
    run 1 us
    quit
} else {
    wave -noreg post/*
    run 1 us
}
##<sim_end>

#<END>
#####################################do end#####################################