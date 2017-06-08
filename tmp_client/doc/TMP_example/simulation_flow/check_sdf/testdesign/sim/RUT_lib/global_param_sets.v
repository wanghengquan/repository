// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> WHAT'S RUT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// ----------------------------------------------------------------------------//
//   Reusable Unified Testbench (RUT) is designed for team-based validation    //
// which can help to both raise our test level and reduce test cycle.          //
//   RUT deliver a common library which contain many packed tasks for different//
// modules.                                                                    //
//   RUT will use limited SystemVerilog features which will help to develop the//
// library greatly.                                                            //
//                                                                             //
// NOTE:                                                                       //
// Copyright by Software Validation team from Lattice Semiconductor Corporation//
// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> FILE DESCRIPTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// ----------------------------------------------------------------------------//
//   this file is used to contain all the pre-defined macros which will be used//
// in the RUT lib and testbench.                                               //
//   all macros have default values and each testbench can use local_param_sets//
// to overwrite.                                                               //
// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> VERSION CONTROL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// File Name: global_param_sets.v                                              //
// Owner: Yibin Sun                                                            //
// Version History:                                                            //
//   Version   Data        Modifier   Comments                                 //
//   V0.1      12.28.2014  Yibin      initial Version                          //
//                                                                             //
// ----------------------------------------------------------------------------//




//Global Macros, Parameters and settings for UUT
//all in capital


//NON-module related global Macros
// timescale
`timescale 1 ns / 1 ps

//random -- seed
`define SEED 1   // seed can be used to generate pseudo-random numbers and the results can be reproduced with the same seed

// system clock and clock enable
`define CLK_CYCLE         10.0    //clock period  NOTE: use real type: 10.0, do not use 10!!
`define DUTY_CYCLE        50    //duty cycle
`define HIGH_TIME         (`CLK_CYCLE / 100 * `DUTY_CYCLE)  //the clock should start with high level
`define LOW_TIME          (`CLK_CYCLE-`HIGH_TIME)
`define CLK_SHIFT         0.000     //phase shift, default is 0 degree, you can use CLK_CYCLE/16 to stand for 22.5 degree
`define CLK_SHIFT_VAL     (`CLK_SHIFT / 360 * `CLK_CYCLE ) 
`define CLK_JITTER        0     //clock jitter, use format like CLK_CYCLE/100. TBD!! it will be easy to generate random value between jitter range with SystemVerilog. 
`define CLK_EN_ASSERTION  100   //time to assert clock enable

// write clock and clock enable
`define WCLK_CYCLE         10.0    //clock period  NOTE: use real type: 10.0, do not use 10!!
`define WDUTY_CYCLE        50    //duty cycle
`define WHIGH_TIME         (`WCLK_CYCLE / 100 * `WDUTY_CYCLE)  //the clock should start with high level
`define WLOW_TIME          (`WCLK_CYCLE-`WHIGH_TIME)
`define WCLK_SHIFT         0.000     //phase shift, default is 0 degree, you can use CLK_CYCLE/16 to stand for 22.5 degree
`define WCLK_SHIFT_VAL     (`WCLK_SHIFT / 360 * `WCLK_CYCLE) 
`define WCLK_JITTER        0     //clock jitter, use format like CLK_CYCLE/100. TBD!! it will be easy to generate random value between jitter range with SystemVerilog. 
`define WCLK_EN_ASSERTION  100   //time to assert clock enable

// read clock and clock enable
`define RCLK_CYCLE         10.0    //clock period  NOTE: use real type: 10.0, do not use 10!!
`define RDUTY_CYCLE        50    //duty cycle
`define RHIGH_TIME         (`RCLK_CYCLE / 100 * `RDUTY_CYCLE)  //the clock should start with high level
`define RLOW_TIME          (`RCLK_CYCLE-`RHIGH_TIME)
`define RCLK_SHIFT         0.000     //phase shift, default is 0 degree, you can use CLK_CYCLE/16 to stand for 22.5 degree
`define RCLK_SHIFT_VAL     (`RCLK_SHIFT / 360 * `RCLK_CYCLE) 
`define RCLK_JITTER        0     //clock jitter, use format like CLK_CYCLE/100. TBD!! it will be easy to generate random value between jitter range with SystemVerilog. 
`define RCLK_EN_ASSERTION  100   //time to assert clock enable



// reset
//synchronous reset
`define SYNC_RST_HIGH_LOW      0    // active high or low  
`define SYNC_RST_ASSERT_CYCLE  10   // how many system clock cycle will reset assert
//asynchronous reset
`define ASYNC_RST_HIGH_LOW      0    // active high or low  
`define ASYNC_RST_ASSERT_LENGTH 93



//Mapping table
//Every module will be located in two dimensions: type and module, for example, single_port_ram will be ADDRESS_WIDTH_0301
//type
//sysIO_Logic  DSP  MEMORY
//01           02   03
//module
//01-sysIO_Logic
//gddr1248_rx     gddr7_rx   gddr1248_tx     gddr7_tx   
//01              02         03              04
//03-MEMORY
//single_port_ram    dual_port_ram
//01                 02



//For Generic DDR
//configuration
`define INDATA_WIDTH_0101      8 
`define GEARING_RATE_0101      1
`define OUTDATA_WIDTH_0101     `INDATA_WIDTH_0101 * `GEARING_RATE_0101 * 2
`define SEND_DATA_0101         64


//For Single_port_ram_module
//memory info
`define ADDRESS_WIDTH_0301   8 
`define ADDRESS_DEPTH_0301   2**`ADDRESS_WIDTH_0301
`define DATA_WIDTH_0301      16 
`define DATA_MAXIMUM_0301    16'hffff 

// Test PLL
`define CLKIN_FREQUENCY_0401	20    // clkin 20MHz
`define CLKOP_FREQUENCY_0401	100
`define CLKOS_FREQUENCY_0401	100	
`define CLKOS2_FREQUENCY_0401	100
`define CLKOS3_FREQUENCY_0401	100
`define CLKOP_PHASESHIFT_0401	0	  // clkop phase shift is 0 degree
`define CLKOS_PHASESHIFT_0401	0
`define CLKOS2_PHASESHIFT_0401	0
`define CLKOS3_PHASESHIFT_0401	0



