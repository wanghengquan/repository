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
// File Name: module_param_sets_06.v                                           //
// Owner: Jeffrey Ye                                                           //
// Version History:                                                            //
//   Version   Data        	Modifier   		Comments                           //
//   V0.1      3.16.2015   	Jeffrey Ye  	initial Version                    //
//                                                                             //
// ----------------------------------------------------------------------------//




/////////////////////////////////////////////////////////////////////////////
//Local Parameters and settings for specific components
//
//component:  06-arithmetic_modules
//global Adder	Adder_Sub Comp Comp_Multi Convert Counter	 
//00     01   	02        03   04         05      06
/////////////////////////////////////////////////////////////////////////////




//////////////////////////module start: //////////////////////////
//basic function
`define DATA_WIDTH_ADDER_0601 8 
`define CHECK_DATA_LEN_0600 100 

//configuration test


//constrained random test


//abnormal test


///////////////////////////module end: ///////////////////////////

