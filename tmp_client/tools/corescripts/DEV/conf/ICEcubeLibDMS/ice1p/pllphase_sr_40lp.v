// Library - leafcell, Cell - pllphase_sr_40lp, View - schematic
// LAST TIME SAVED: Jun  6 17:32:49 2011
// NETLIST TIME: Jun 29 10:32:23 2011
`timescale 1ns / 1ns 

module pllphase_sr_40lp ( f_dvd2, f_dvd4_p0, f_dvd4_p90, f_out, CLK,
     cbit, sr, tiehi, tielo );
output  f_dvd2, f_dvd4_p0, f_dvd4_p90, f_out;

input  CLK, cbit, sr, tiehi, tielo;
supply1 vdd_;
supply0 gnd_;
//wire vddp_ = test.cds_globalsInst.vddp_;
supply0 GND_;
supply1 VDD_;

// Buses in the design

wire  [0:1]  qn;



mux2_hvt I_MUX4DIV7 ( .in1(net077), .in0(net051), .out(net038),
     .sel(cbit));
// inv_tri_2_hvt I21 ( .Tb(net0136), .T(net0136), .A(net0136),
     // .Y(net0113));
inv I21 ( net0113, net0136 );
nor2_hvt I22 ( .A(net0113), .B(tielo), .Y(net0116));
inv_hvt I26 ( .A(net089), .Y(net086));
inv_hvt I27 ( .A(CLK), .Y(net089));
inv_hvt I23 ( .A(net0116), .Y(net044));
inv_hvt I20 ( .A(net0138), .Y(net0136));
inv_hvt I19 ( .A(net0101), .Y(net0138));
inv_hvt I28 ( .A(net086), .Y(net057));
inv_hvt I29 ( .A(net057), .Y(net080));
inv_hvt I30 ( .A(net080), .Y(net088));
inv_hvt I31 ( .A(net088), .Y(net0101));
inv_hvt I8 ( .A(qn[1]), .Y(f_dvd4_p90));
inv_hvt I7 ( .A(net0100), .Y(f_dvd2));
inv_hvt I6 ( .A(net044), .Y(f_out));
inv_hvt I5 ( .A(qn[0]), .Y(f_dvd4_p0));
pll_ml_dff I2 ( .R(sr), .D(net056), .CLK(CLK), .QN(qn[1]), .Q(net051));
pll_ml_dff I0 ( .R(sr), .D(net054), .CLK(CLK), .QN(qn[0]), .Q(net056));
pll_ml_dff I3 ( .R(sr), .D(net051), .CLK(CLK), .QN(net061),
     .Q(net040));
pll_ml_dff I12 ( .R(sr), .D(net0100), .CLK(CLK), .QN(net0100),
     .Q(net067));
dffs I10 ( .D(net082), .QN(net071), .Q(net054), .CLK(CLK), .S(sr));
dffs I9 ( .D(net053), .QN(net076), .Q(net077), .CLK(CLK), .S(sr));
dffs I11 ( .D(net038), .QN(net081), .Q(net082), .CLK(CLK), .S(sr));
dffs I4 ( .D(net040), .CLK(CLK), .QN(net087), .Q(net053), .S(sr));

endmodule
