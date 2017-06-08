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
//Each item will be located in two dimensions -- component and module.
//component order will be provided here, module order will be provided in local_param_sets which is developped by each owner.
//sysio_logic  dsp  memory   sysclock  efb_power_pcs  arithmetic_modules
//01           02   03       04        05             06


`include "./RUT_lib/sysio_logic/module_param_sets_01.v"
`include "./RUT_lib/dsp/module_param_sets_02.v"
`include "./RUT_lib/memory/module_param_sets_03.v"
`include "./RUT_lib/sysclock/module_param_sets_04.v"
`include "./RUT_lib/efb_power_pcs/module_param_sets_05.v"
`include "./RUT_lib/arithmetic_modules/module_param_sets_06.v"




//Supported Family
`define sapphire 0
`define xo3l     0
`define snow     0
