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
//   this file is used to contain the macros/parameters that are specific for  //
// the UUT.                                                                    //
//   this file has higher priority than global_param_sets.                     //
// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> VERSION CONTROL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// File Name: module_param_sets.v                                              //
// Owner: Jason Wang                                                           //
// Version History:                                                            //
//   Version   Data        Modifier   Comments                                 //
//   V0.1      3.9.2015    Jason      initial Version                          //
//                                                                             //
// ----------------------------------------------------------------------------//




/////////////////////////////////////////////////////////////////////////////
//Local Parameters and settings for specific components
//
//component:  04-sysclock
//pll  dll   dcc   ...
//01   02    03      
/////////////////////////////////////////////////////////////////////////////




//////////////////////////////module start: pll//////////////////////////////
//basic function
`define CLKIN_FREQUENCY_0401	50.0    // clkin 50ns  20MHz
`define CLKOP_FREQUENCY_0401	10.0    // clkop 10ns  100MHz
`define CLKOS_FREQUENCY_0401	10.0    // clkos 10ns  100MHz
`define CLKOS2_FREQUENCY_0401	10.0    // clkos2 10ns  100MHz
`define CLKOS3_FREQUENCY_0401	10.0    // clkos3 10ns  100MHz
`define CLKOP_PHASESHIFT_0401	0       // clkop phase shift is 0 degree
`define CLKOS_PHASESHIFT_0401	0
`define CLKOS2_PHASESHIFT_0401	0
`define CLKOS3_PHASESHIFT_0401	0

//configuration test


//constrained random test


//abnormal test


//////////////////////////////module end: DCC////////////////////////////////


//////////////////////////////module start: pll//////////////////////////////
//basic function
`define CLKIN_FREQUENCY_0403	50.0    // clkin 50ns  20MHz
`define CLKOUT_FREQUENCY_0403	50.0    // clkop 50ns  20MHz

//configuration test


//constrained random test


//abnormal test


//////////////////////////////module end: dcc////////////////////////////////