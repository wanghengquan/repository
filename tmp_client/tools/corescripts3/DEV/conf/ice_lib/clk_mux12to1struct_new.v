// Library - leafcell, Cell - clkmux12to1, View - schematic
// LAST TIME SAVED: May 30 15:38:24 2007
// NETLIST TIME: Oct 24 13:40:43 2007
`timescale 1ns / 100ps 

module clkmux12to1 ( inmuxo, cbit[4], cbit[3], cbit[2], cbit[1],
     cbit[0], cbitb[4], cbitb[3], cbitb[2], cbitb[1], cbitb[0],
     min[11:0], prog );
output  inmuxo;

input  prog;

input [0:4]  cbitb;
input [0:4]  cbit;
input [11:0]  min;



nand3_hvt I285 ( .Y(clkmuxob), .B(cbit[4]), .C(net103), .A(st3));
inv_hvt I287 ( .A(clkmuxob), .Y(inmuxo));
inv_hvt I286 ( .A(prog), .Y(net103));
txgate_hvt I247 ( .in(min[2]), .out(st01), .pp(cbit[0]),
     .nn(cbitb[0]));
txgate_hvt I260 ( .in(min[8]), .out(st04), .pp(cbit[0]),
     .nn(cbitb[0]));
txgate_hvt I261 ( .in(min[9]), .out(st04), .pp(cbitb[0]),
     .nn(cbit[0]));
txgate_hvt I265 ( .in(st05), .out(st12), .pp(cbitb[1]), .nn(cbit[1]));
txgate_hvt I262 ( .in(min[10]), .out(st05), .pp(cbit[0]),
     .nn(cbitb[0]));
txgate_hvt I257 ( .in(min[6]), .out(st03), .pp(cbit[0]),
     .nn(cbitb[0]));
txgate_hvt I254 ( .in(min[3]), .out(st01), .pp(cbitb[0]),
     .nn(cbit[0]));
txgate_hvt I244 ( .in(min[0]), .out(st00), .pp(cbit[0]),
     .nn(cbitb[0]));
txgate_hvt I253 ( .in(st02), .out(st11), .pp(cbit[1]), .nn(cbitb[1]));
txgate_hvt I251 ( .in(st20), .out(st3), .pp(cbit[3]), .nn(cbitb[3]));
txgate_hvt I249 ( .in(st01), .out(st10), .pp(cbitb[1]), .nn(cbit[1]));
txgate_hvt I274 ( .in(st03), .out(st11), .pp(cbitb[1]), .nn(cbit[1]));
txgate_hvt I252 ( .in(st11), .out(st20), .pp(cbitb[2]), .nn(cbit[2]));
txgate_hvt I276 ( .in(st21), .out(st3), .pp(cbitb[3]), .nn(cbit[3]));
txgate_hvt I263 ( .in(min[11]), .out(st05), .pp(cbitb[0]),
     .nn(cbit[0]));
txgate_hvt I248 ( .in(st00), .out(st10), .pp(cbit[1]), .nn(cbitb[1]));
txgate_hvt I255 ( .in(min[4]), .out(st02), .pp(cbit[0]),
     .nn(cbitb[0]));
txgate_hvt I275 ( .in(st12), .out(st21), .pp(cbit[2]), .nn(cbitb[2]));
txgate_hvt I250 ( .in(st10), .out(st20), .pp(cbit[2]), .nn(cbitb[2]));
txgate_hvt I264 ( .in(st04), .out(st12), .pp(cbit[1]), .nn(cbitb[1]));
txgate_hvt I258 ( .in(min[7]), .out(st03), .pp(cbitb[0]),
     .nn(cbit[0]));
txgate_hvt I256 ( .in(min[5]), .out(st02), .pp(cbitb[0]),
     .nn(cbit[0]));
txgate_hvt I246 ( .in(min[1]), .out(st00), .pp(cbitb[0]),
     .nn(cbit[0]));

endmodule
// Library - leafcell, Cell - clk_mux12to1, View - schematic
// LAST TIME SAVED: Oct 24 12:43:24 2007
// NETLIST TIME: Oct 24 13:40:43 2007
`timescale 1ns / 100ps

module clk_mux12to1 ( clk, clkb, cbit, cbitb, cenb, min, prog );

output  clk, clkb;

input  cenb, prog;

input [5:0]  cbitb;
input [5:0]  cbit;
input [11:0]  min;

wire clat, clat_;

assign #1 clat_ = clat;

nand3_hvt I300 ( .Y(net33), .B(net57), .C(cbit[4]), .A(cbit[5]));
mux2x1_hvt I298 ( .in1(clkm), .in0(negclk), .out(mclk), .sel(net33));
clkandnor22_hvt I292 ( .y(clatb), .a(cenb), .d(clat_), .c(mclk),
     .b(clkmb));
clkmux12to1 I282 ( clkm, cbit[4], cbit[3], cbit[2], cbit[1], cbit[0],
     cbitb[4], cbitb[3], cbitb[2], cbitb[1], cbitb[0], min[11:0],
     prog);
nand2_hvt I290 ( .B(clatb), .A(mclk), .Y(clkb));
inv_hvt I289 ( .A(clkb), .Y(clk));
inv_hvt I34 ( .A(mclk), .Y(clkmb));
inv_hvt I301 ( .A(prog), .Y(net57));
inv_hvt I302 ( .A(clkm), .Y(negclk));
inv_hvt Iinv_ckfb ( .A(clatb), .Y(clat));

endmodule
