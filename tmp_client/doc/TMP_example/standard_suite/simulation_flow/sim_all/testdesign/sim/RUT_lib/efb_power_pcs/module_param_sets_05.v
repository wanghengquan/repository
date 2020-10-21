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
// File Name: module_param_sets_05.v                                           //
// Owner: Weixing Tan                                                          //
// Version History:                                                            //
//   Version   Data        Modifier   Comments                                 //
//   V0.1      3.16.2015    Weixing Tan      initial Version                   //
//                                                                             //
// ----------------------------------------------------------------------------//




/////////////////////////////////////////////////////////////////////////////
//Local Parameters and settings for specific components
//
//component:  05-efb_power_pcs
//efb             power          pcs
//01              02               03
/////////////////////////////////////////////////////////////////////////////




//////////////////////////module start: efb_i2c.v//////////////////////////
//basic function
`define I2C_1_CR_0501   8'h40 //read_write
`define I2C_1_CMDR_0501   8'h41 //read_write
`define I2C_1_BR0_0501   8'h42 //read_write
`define I2C_1_BR1_0501   8'h43 //read_write
`define I2C_1_TXDR_0501   8'h44 //write
`define I2C_1_SR_0501   8'h45 //read
`define I2C_1_GCDR_0501   8'h46 //read
`define I2C_1_RXDR_0501   8'h47 //read
`define I2C_1_IRQ_0501   8'h48 //read_write
`define I2C_1_IRQ_EN_0501   8'h49 //read_write

`define I2C_2_CR_0501   8'h4A //read_write
`define I2C_2_CMDR_0501   8'h4B //read_write
`define I2C_2_BR0_0501   8'h4C //read_write
`define I2C_2_BR1_0501   8'h4D //read_write
`define I2C_2_TXDR_0501   8'h4E //write
`define I2C_2_SR_0501   8'h4F //read
`define I2C_2_GCDR_0501   8'h50 //read
`define I2C_2_RXDR_0501   8'h51 //read
`define I2C_2_IRQ_0501   8'h52 //read_write
`define I2C_2_IRQ_EN_0501   8'h53 //read_write

`define I2C_SLAVE_ADDRESS_0501    7'b1000010  //I2C2_SLAVE_ADDR
//`define I2C_MASTER_ADDRESS   7'b1010101

`define I2C_WRITE_0501   1'b0
`define I2C_READ_0501    1'b1



//configuration test



//constrained random test



//abnormal test
///////////////////////////module end: efb_i2c.v///////////////////////////









///////////////////////////module start: efb_spi////////////////////////////
//basic function


//configuration test



//constrained random test


//abnormal test

/////////////////////////////module end: efb_spi///////////////////////////