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


//local Parameters and settings for system signals
`ifdef ASYNC_RST_HIGH_LOW
    `undef ASYNC_RST_HIGH_LOW
`endif
`define ASYNC_RST_HIGH_LOW          1    // active high or low  

`ifdef ASYNC_RST_ASSERT_LENGTH
    `undef ASYNC_RST_ASSERT_LENGTH
`endif
`define ASYNC_RST_ASSERT_LENGTH     20

`ifdef CLK_EN_ASSERTION
    `undef CLK_EN_ASSERTION
`endif
`define CLK_EN_ASSERTION            55

`ifdef CLOCK_DELAY
    `undef CLOCK_DELAY
`endif
`define CLOCK_DELAY                 2

//Local Parameters and settings for UUT
`ifdef SEED
    `undef SEED
`endif
`define SEED                        1

`ifdef ADDRESS_WIDTH_0303
    `undef ADDRESS_WIDTH_0303
`endif
`define ADDRESS_WIDTH_0303          4 

`ifdef DATA_WIDTH_0303
    `undef DATA_WIDTH_0303
`endif
`define DATA_WIDTH_0303             12 

`ifdef FLOAT_REG_DEPTH_0303
    `undef FLOAT_REG_DEPTH_0303
`endif
`define FLOAT_REG_DEPTH_0303        16

`ifdef FIXED_REG_DEPTH_0303
    `undef FIXED_REG_DEPTH_0303
`endif
`define FIXED_REG_DEPTH_0303        16 

`ifdef WITH_REG_0303
    `undef WITH_REG_0303
`endif
//without output register
`define WITH_REG_0303               1