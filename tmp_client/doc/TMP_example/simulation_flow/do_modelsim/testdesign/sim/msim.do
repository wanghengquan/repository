#####################################do file#####################################
#.do config file
#20140210 jason
#usage: 
#dev_lib example: D:\diamond_lib\msim_lib\ovi_lifdb1
#execute this file in CMD:vsim -l sim_log.txt -c -do "do <do file name> <dev_lib> <pri_lib> <cmd or gui>"
#execute this file in GUI:do <do file name> <dev_lib> <pri_lib> <cmd or gui>
##########config start##########
if {$3 == "cmd"} {
    onbreak {resume}
    onerror {quit -f}
}
#<START>

##<cfg_start>
set IgnoreError 1
set dev_lib $1
set pri_lib $2
set gui_cmd $3
##<cfg_end>

##get device simulation module
##<lib_start>
##<step1>construct a work lib
vlib work
##<step2>connect some other lib
vmap ovi_lifdb1 $dev_lib
##<lib_end>

##compile source files if you use VHDL please use vcom
##<source_start>
vlog		../source/rtl_top.v
vlog		../models/module_top.v
##<source_end>

##<tb_start>
vlog	-sv ./RUT_lib/sys_signals.v
vlog	-sv ./RUT_lib/memory/single_port_ram_module.v
vlog	-sv ./sim_tb.v
##<tb_end>

##prepare for simulation
##<pre_start>
radix -hex
##<pre_end>

##start to run simulation
##<sim_start>
vsim -novopt -lib work sim_top  -L ovi_lifdb1
if {$gui_cmd == "cmd"} {
    run 1us
    quit
} else {
    add wave *
    run 1 us
}
##<sim_end>

#<END>
#####################################do end#####################################
