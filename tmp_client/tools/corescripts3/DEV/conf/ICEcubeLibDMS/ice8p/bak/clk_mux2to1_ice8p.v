// Library - ice8chip, Cell - clk_mux2to1_ice8p, View - schematic
// LAST TIME SAVED: Nov  9 10:58:23 2010
// NETLIST TIME: Nov 19 10:33:39 2010
`timescale 1ns / 1ns 

module clk_mux2to1_ice8p ( gnet, bl, min0, min1, min2, min3, pgate_l,
     pgate_r, prog, reset_l, reset_r, vdd_cntl_l, vdd_cntl_r, wl_l,
     wl_r );


input  prog;

output [3:0]  gnet;

inout [3:0]  bl;

input [1:0]  min2;
input [1:0]  pgate_l;
input [1:0]  reset_l;
input [1:0]  min0;
input [1:0]  reset_r;
input [1:0]  min1;
input [1:0]  min3;
input [1:0]  vdd_cntl_r;
input [1:0]  wl_l;
input [1:0]  vdd_cntl_l;
input [1:0]  pgate_r;
input [1:0]  wl_r;
supply1 vdd_;
supply0 gnd_;
/* wire vddp_ = test.cds_globalsInst.vddp_; */ supply1 vddp_;
supply0 GND_;
supply1 VDD_;

// Buses in the design

wire  [1:0]  r_vdd;

wire  [7:0]  cbitb;

wire  [7:0]  cbit;

wire  [1:0]  l_vdd;



clk_mux_2to1_ice8p I_clkmux3 ( .prog(prog), .cbit(cbit[3]),
     .cbitb(cbitb[3]), .min(min3[1:0]), .clk(gnet[3]));
clk_mux_2to1_ice8p I_clkmux1 ( .prog(prog), .cbit(cbit[1]),
     .cbitb(cbitb[1]), .min(min1[1:0]), .clk(gnet[1]));
clk_mux_2to1_ice8p I_clkmux2 ( .prog(prog), .cbit(cbit[2]),
     .cbitb(cbitb[2]), .min(min2[1:0]), .clk(gnet[2]));
clk_mux_2to1_ice8p I_clkmux0 ( .prog(prog), .cbit(cbit[0]),
     .cbitb(cbitb[0]), .min(min0[1:0]), .clk(gnet[0]));
pch_hvt  I_pch_hvt_l_1_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl_l[1]),
     .D(l_vdd[0]));
pch_hvt  I_pch_hvt_l_0_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl_l[0]),
     .D(l_vdd[1]));
pch_hvt  M0_1_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl_r[1]), .D(r_vdd[1]));
pch_hvt  M0_0_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl_r[0]), .D(r_vdd[0]));
cram2x2 I_cram2x2_lft ( .bl(bl[1:0]), .q_b(cbitb[3:0]),
     .reset(reset_l[1:0]), .q(cbit[3:0]), .wl(wl_l[1:0]),
     .r_vdd({l_vdd[0], l_vdd[1]}), .pgate(pgate_l[1:0]));
cram2x2 I_cram2x2_rgt ( .bl(bl[3:2]), .q_b(cbitb[7:4]),
     .reset(reset_r[1:0]), .q(cbit[7:4]), .wl(wl_r[1:0]),
     .r_vdd(r_vdd[1:0]), .pgate(pgate_r[1:0]));

endmodule
