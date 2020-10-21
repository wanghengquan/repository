///////////////////////////////////////////////////////////////////////
//
//  8 by 8 multiply and accumulate, registered input & output RTL code
//
//  this design should be mampped into single MULT9X9MAC
//
///////////////////////////////////////////////////////////////////////

`timescale 100 ps/100 ps
`define OSIZE 16
`define DSIZE 8

module mac8x8 (dataout, x, y, clk, rst);

 output [`OSIZE:0] dataout;
 input [`DSIZE-1:0] x, y;
 input clk, rst;
 reg  [`OSIZE:0] dataout;
 reg [`DSIZE-1:0] x_reg, y_reg;
 wire [`OSIZE-1:0] multout;
 wire [`OSIZE:0] sum_out;

 assign multout = x_reg * y_reg;
 assign sum_out = multout + dataout; 

 always @(posedge clk or posedge rst)
 begin
   if (rst)
   begin
      x_reg = 0;
      y_reg = 0;
      dataout = 0;
   end
   else
   begin
      x_reg = x;
      y_reg = y;
      dataout = sum_out;
   end
 end
endmodule

