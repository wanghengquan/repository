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
// File Name: module_param_sets_03.v                                           //
// Owner: Dwyane Yang                                                          //
// Version History:                                                            //
//   Version    Data         Modifier        Comments                          //
//   V0.1     3.16.2015    Dwyane Yang    initial Version                      //
//                                                                             //
// ----------------------------------------------------------------------------//




/////////////////////////////////////////////////////////////////////////////
//Local Parameters and settings for specific components
//
//component:  03-memory
//single_port_ram    dual_port_ram   ram_shift_register
//01                 02              03
/////////////////////////////////////////////////////////////////////////////




////////////////////////module start: single_port_ram////////////////////////
//basic function
`define ADDRESS_WIDTH_0301   8 
`define ADDRESS_DEPTH_0301   2**`ADDRESS_WIDTH_0301
`define DATA_WIDTH_0301      16 
`define DATA_MAXIMUM_0301    16'hffff 

//configuration test
`define WITH_REG_0301  0

//constrained random test


//abnormal test


////////////////////////module end: single_port_ram//////////////////////////



////////////////////////module start: ram_shift_register/////////////////////
//basic function
`define ADDRESS_WIDTH_0303      8
`define DATA_WIDTH_0303         16 
`define FLOAT_REG_DEPTH_0303    2**`ADDRESS_WIDTH_0303
`define FIXED_REG_DEPTH_0303    16 

//configuration test
`define WITH_REG_0303           0

//constrained random test


//abnormal test


////////////////////////module end: ram_shift_register///////////////////////

