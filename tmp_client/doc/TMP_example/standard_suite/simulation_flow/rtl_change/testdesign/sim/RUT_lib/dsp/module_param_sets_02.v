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
// File Name: module_param_sets_02.v                                           //
// Owner: strdom fang                                                          //
// Version History:                                                            //
//   Version   Data        Modifier   Comments                                 //
//   V0.1      3.3.2015    strdom      initial Version                         //
//                                                                             //
// ----------------------------------------------------------------------------//




/////////////////////////////////////////////////////////////////////////////
//Local Parameters and settings for specific components
//
//component:  02-dsp
//mult   ...
//01     02         03              04
/////////////////////////////////////////////////////////////////////////////




//////////////////////////module start: gddr1248_rx//////////////////////////
//basic function
`define INDATA_WIDTH_0201      9 
`define OUTDATA_WIDTH_0201     (`INDATA_WIDTH_A * 2)
`define MAX_RANDOM             (2 ** `INDATA_WIDTH_0201 - 1)


//configuration test


//constrained random test


//abnormal test
///////////////////////////module end: gddr1248_rx///////////////////////////

