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
// File Name: local_param_sets.v                                               //
// Owner: Jason wang                                                           //
// Version History:                                                            //
//   Version   Data        Modifier   Comments                                 //
//                                                                             //
// ----------------------------------------------------------------------------//


//Local Parameters and settings for UUT
`ifdef ADDRESS_WIDTH_0301
    `undef ADDRESS_WIDTH_0301
`endif
`define ADDRESS_WIDTH_0301   5 

`ifdef ADDRESS_DEPTH_0301
    `undef ADDRESS_DEPTH_0301
`endif
`define ADDRESS_DEPTH_0301   2**`ADDRESS_WIDTH_0301

`ifdef DATA_WIDTH_0301
    `undef DATA_WIDTH_0301
`endif
`define DATA_WIDTH_0301      8 

`ifdef DATA_MAXIMUM_0301
    `undef DATA_MAXIMUM_0301
`endif
`define DATA_MAXIMUM_0301    8'hff 
//configuration test
`ifdef WITH_REG_0301
    `undef WITH_REG_0301
`endif
//without output register
`define WITH_REG_0301 0

//clock info
`ifdef ASYNC_RST_HIGH_LOW
    `undef ASYNC_RST_HIGH_LOW
`endif
`define ASYNC_RST_HIGH_LOW      1    // active high or low  

`ifdef ASYNC_RST_ASSERT_LENGTH
    `undef ASYNC_RST_ASSERT_LENGTH
`endif
`define ASYNC_RST_ASSERT_LENGTH 20

`ifdef CLK_EN_ASSERTION
    `undef CLK_EN_ASSERTION
`endif
`define CLK_EN_ASSERTION  50

`ifdef CLOCK_DELAY
    `undef CLOCK_DELAY
`endif
`define CLOCK_DELAY 2
