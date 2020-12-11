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
// File Name: module_param_sets_01.v                                            //
// Owner: Yibin Sun                                                            //
// Version History:                                                            //
//   Version   Data        Modifier   Comments                                 //
//   V0.1      3.4.2015    Yibin      initial Version                          //
//                                                                             //
// ----------------------------------------------------------------------------//




/////////////////////////////////////////////////////////////////////////////
//Local Parameters and settings for specific components
//
//component:  01-sysio_logic
//gddr1248_rx     gddr7_rx   gddr1248_tx     gddr7_tx
//01              02         03              04
/////////////////////////////////////////////////////////////////////////////




//////////////////////////module start: gddr1248_rx//////////////////////////
//basic function
`define INDATA_WIDTH_0101      8
`define GEARING_RATE_0101      1
`define OUTDATA_WIDTH_0101     `INDATA_WIDTH_0101 * `GEARING_RATE_0101 * 2
`define SEND_DATA_0101         64

`define default_mode_xo3       0
`define tristate_mode_xo3      0

//configuration test
`define DEFAULT_MODE_XO3L  0
`define TRISTATE_MODE_XO3L 0

//constrained random test


//abnormal test
///////////////////////////module end: gddr1248_rx///////////////////////////




///////////////////////////module start: gddr7_rx////////////////////////////
//basic function
`define INDATA_WIDTH_0102      0
`define GEARING_RATE_0102      0
`define OUTDATA_WIDTH_0102     0
`define SEND_DATA_0102         0

//configuration test
//`define DEFAULT_MODE_XO3L  0    --same as gddr1248_rx
//`define TRISTATE_MODE_XO3L 0   --same as gddr1248_rx

//constrained random test


//abnormal test

/////////////////////////////module end: gddr7_rx///////////////////////////