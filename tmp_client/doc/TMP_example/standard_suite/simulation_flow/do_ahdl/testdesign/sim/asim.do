#####################################do file#####################################
#.do config file
#20140210 jason
#usage:
#dev_lib example: C:\\lscc\\diamond\\3.5_x64\\active-hdl\\Vlib\\ovi_machxo3l\\ovi_machxo3l.lib
#execute this file in CMD:vsimsa -l sim_log.txt -do <do file name> <dev_lib> <pri_lib> <cmd or gui>
#execute this file in GUI:do <do file name> <dev_lib> <pri_lib> [cmd or gui]

##########config start##########
if $3 = "cmd"
    onbreak {resume}
    onerror {quit}
    set IgnoreError 1
    set exitonerror 1
endif
#<START>

##<cfg_start>
set dev_lib $1
set pri_lib $2
set gui_cmd $3
##<cfg_end>

##<lib_start>
##<step1>construct a work lib
if $gui_cmd = "cmd"
    vlib work
else
    design create work .
    design open work
    adel -all
    cd ../../
endif
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
vsim -novopt +access +r -asdb rtl_top.asdb -lib work sim_top  -L ovi_machxo2
if $gui_cmd = "cmd"
    trace -ports /sim_top/*
    run 1 us
    asdb2ctf -writenew off -strobe -time 5ns -deltacolumn off -radix hex rtl_top.asdb rtl_top.lst
    quit
else
    add wave -noreg /sim_top/*
    run 1 us
endif
##<sim_end>

#<END>
#####################################do end#####################################
