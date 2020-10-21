#####################################do file#####################################
#.do config file
#20140210 jason
#usage:
#dev_lib example: D:\\qsim_lib\\machxo3l_vlg
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
vmap ovi_machxo2 $dev_lib
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
vsim -novopt -lib work sim_top  -L ovi_machxo2
if {$gui_cmd == "cmd"} {
    add list -nodelta -hex -notrigger *
    configure list -usestrobe 1
    configure list -strobestart {50000 ps} -strobeperiod {5 ns}
    run 1 us
    write list sim_top.lst
    quit -f
} else {
    add wave *
    run 1 us
}
##<sim_end>

#<END>
#####################################do end#####################################
