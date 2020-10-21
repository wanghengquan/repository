#####################################do file#####################################
#.do config file
#20140210 jason
#usage: 
#dev_lib example: D:/BQS_script/test_case/Vlib/ovi_machxo3l
#execute this file in CMD:vsim -l sim_log.txt -c -do "do <do file name> <dev_lib> <pri_lib> <cmd or gui>"
#execute this file in GUI:do <do file name> <dev_lib> <pri_lib> <cmd or gui>
##########config start##########
#<START>
if {$3 == "cmd"} {
    onbreak {resume}
    onerror {quit -f}
}
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
vmap ovi_ecp5u $dev_lib
##<lib_end>

##compile source files if you use VHDL please use vcom
##<source_start>
vlog		../models/modules/sdr/sdr.v
vlog		../source/top.v
##<source_end>

##<tb_start>
vlog	-sv ./sim_tb.v
##vlog	-sv ./local_param_sets.v
##vlog	-sv ./RUT_lib/sys_signals.v
##vlog	-sv ./RUT_lib/sysio_logic/sdr_sets.v
##vlog	-sv ./RUT_lib/sysio_logic/module_param_sets_01.v
##<tb_end>

##prepare for simulation
##<pre_start>
radix -hex
##<pre_end>

##start to run simulation
##<sim_start>
vsim -novopt -lib work sim_top  -L ovi_ecp5u
if {$gui_cmd == "cmd"} {
    run 10us
    quit
} else {
    add wave *
    run 10 us
}
##<sim_end>

#<END>
#####################################do end#####################################
