//   ==================================================================
//   >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
//   ------------------------------------------------------------------
//   Copyright (c) 2017 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED  
//   ------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement. 
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
//   --------------------------------------------------------------------
//
//                  Lattice SG Pte. Lt++++++++++++++++d.
//                  101 Thomson Road, United Square #07-02 
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
// --------------------------------------------------------------------
//
//  Project:           iCE5UP 5K RGB LED Tutorial 
//  File:              testbench.v
//  Title:             LED PWM control
//  Description:       Creates RGB PWM per control inputs
//                 
//
// --------------------------------------------------------------------
//
//------------------------------------------------------------
// Notes:
//
//
//------------------------------------------------------------
// Development History:
//
//   __DATE__ _BY_ _REV_ _DESCRIPTION___________________________
//   04/05/17  RK  1.0    Initial tutorial design for Lattice Radiant
//
//------------------------------------------------------------
// Dependencies:
//
// 
//
//------------------------------------------------------------



//------------------------------------------------------------
// 
//
//                     Testbench
//
//------------------------------------------------------------
`timescale 1ns/1ps
module tb;
	
//GSR GSR_INST ( .GSR(1));
//PUR PUR_INST ( .PUR(1));



reg clk12M;
reg rst;
reg [1:0]color_sel;
reg RGB_Blink_En;
wire REDn;
wire BLUn;
wire GRNn;
wire RED;
wire BLU;
wire GRN;

led_top dut(.clk12M(clk12M),
			.rst(rst),
			.color_sel(color_sel),
			.RGB_Blink_En(RGB_Blink_En),
			.REDn(REDn),
			.BLUn(BLUn),
			.GRNn(GRNn),
			.RED(RED),
			.BLU(BLU),
			.GRN(GRN)
			);     

initial
begin
    clk12M=1'b0;
end

always 
  #41.666666 clk12M=~clk12M;                             //clock generation
  

 initial
 begin             
 rst=1'b1; 
 color_sel=2'b01;
 RGB_Blink_En=1'b0; 
 #1000
 rst=1'b0;
 #3000000
 color_sel=2'b11;
 #3000000
 $stop;
 end 
 
 initial
	 begin
		 $monitor("time=%t,RGB_Blink_En=%d,rst=%d,color_sel=%2d, REDn=%d, BLUn=%d, GRNn=%d",$time,RGB_Blink_En,rst,color_sel,REDn,BLUn,GRNn);
	end

endmodule