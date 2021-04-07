###################################################################
## script to compile  device netlist    (co-verification)        ## 
###################################################################

my $modelsim_path="/tools/dist/mentor/modelsim/10.1/modeltech/bin";
system ("clear all"); 
print "Modesim path :$modelsim_path\n";
print "Started DMS Simulation Lib (../LIB_ice384p) compilations ....\n";  
print "Modelsim compilation in progress  ......\n";  
print "------------------------------------------------------\n"; 
### create device lib. 
#system("$modelsim_path/vlib LIB_ice384p");

### 32 bit compilation. (Do not change file compilation order)   

system("$modelsim_path/vlog -32 -work ../LIB_ice384p chip_ice384struct.v chipbev_ice8p_4ice384.v chipbev_ice8p_addition_4ice384.v  chipbev_ice1p_4ice384.v chipbev_ice1p_additon_4ice384.v  UMC40LP_GPIO_sbt.v ice384extra.v nvcm_top_gate_20111213.v  smc_and_jtag_gate_20111216.v  um40npkhdst.v nvcm_defines.v  nvcm_model.v > modelsim32bit_compile.log ");

print "Completed LIB compilation . Refer modelsim32bit_compile.log \n";  
