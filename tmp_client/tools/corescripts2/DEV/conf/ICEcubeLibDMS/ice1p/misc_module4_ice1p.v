// Library - leafcell, Cell - misc_module4_ice1p, View - schematic
// LAST TIME SAVED: Jun  2 10:50:29 2011
// NETLIST TIME: Jun  2 17:05:21 2011
`timescale 1ns / 1ns 

module misc_module4_ice1p ( S_R, .cbit_colcntl({cbit[60], cbit[56],
     cbit[52], cbit[48], cbit[44], cbit[40], cbit[32], cbit[3]}), clk,
     clkb, glb2local, sp4, bl, b, glb_netwk, l, lc_trk_g0, lc_trk_g1,
     lc_trk_g2, lc_trk_g3, m, min0, min1, min2, min3, pgate, prog, r,
     reset_b, sp12, vdd_cntl, wl );
output  S_R, clk, clkb;


input  prog;

output [63:0]  cbit;
output [7:0]  sp4;
output [3:0]  glb2local;

inout [3:0]  bl;

input [5:0]  lc_trk_g2;
input [15:0]  reset_b;
input [1:0]  l;
input [7:0]  min1;
input [5:0]  lc_trk_g1;
input [15:0]  pgate;
input [15:0]  vdd_cntl;
input [5:0]  lc_trk_g0;
input [7:0]  min3;
input [7:0]  min0;
input [7:0]  glb_netwk;
input [7:0]  sp12;
input [15:0]  wl;
input [1:0]  m;
input [7:0]  min2;
input [1:0]  b;
input [5:0]  lc_trk_g3;
input [1:0]  r;
supply1 vdd_;
supply0 gnd_;
//wire vddp_ = test.cds_globalsInst.vddp_;
supply0 GND_;
supply1 VDD_;

// Buses in the design

wire  [63:0]  cbitb;

wire  [15:0]  r_vdd;



inv_hvt I_inv2 ( .A(progb), .Y(progd));
inv_hvt I_inv1 ( .A(prog), .Y(progb));
pch_hvt  M0_15_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[15]), .D(r_vdd[15]));
pch_hvt  M0_14_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[14]), .D(r_vdd[14]));
pch_hvt  M0_13_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[13]), .D(r_vdd[13]));
pch_hvt  M0_12_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[12]), .D(r_vdd[12]));
pch_hvt  M0_11_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[11]), .D(r_vdd[11]));
pch_hvt  M0_10_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[10]), .D(r_vdd[10]));
pch_hvt  M0_9_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[9]), .D(r_vdd[9]));
pch_hvt  M0_8_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[8]), .D(r_vdd[8]));
pch_hvt  M0_7_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[7]), .D(r_vdd[7]));
pch_hvt  M0_6_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[6]), .D(r_vdd[6]));
pch_hvt  M0_5_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[5]), .D(r_vdd[5]));
pch_hvt  M0_4_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[4]), .D(r_vdd[4]));
pch_hvt  M0_3_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[3]), .D(r_vdd[3]));
pch_hvt  M0_2_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[2]), .D(r_vdd[2]));
pch_hvt  M0_1_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[1]), .D(r_vdd[1]));
pch_hvt  M0_0_ ( .S(vdd_), .B(vdd_), .G(vdd_cntl[0]), .D(r_vdd[0]));
clkmandcmuxrev0 I_clkmandcmuxrev0 ( .prog(progd),
     .lc_trk_g0(lc_trk_g0[5:0]), .lc_trk_g1(lc_trk_g1[5:0]),
     .lc_trk_g2(lc_trk_g2[5:0]), .lc_trk_g3(lc_trk_g3[5:0]), .clk(clk),
     .clkb(clkb), .glb_netwk(glb_netwk[7:0]), .s_r(S_R),
     .glb2local(glb2local[3:0]), .cbit({cbit[2], cbit[1], cbit[0],
     cbit[27], cbit[25], cbit[26], cbit[24], cbit[23], cbit[21],
     cbit[22], cbit[20], cbit[19], cbit[17], cbit[18], cbit[16],
     cbit[15], cbit[13], cbit[14], cbit[12], cbit[31], cbit[29],
     cbit[30], cbit[28], cbit[11], cbit[9], cbit[10], cbit[8],
     cbit[38], cbit[36], cbit[7], cbit[6], cbit[4]}), .min2(min2[7:0]),
     .min1(min1[7:0]), .min0(min0[7:0]), .min3(min3[7:0]),
     .cbitb({cbitb[2], cbitb[1], cbitb[0], cbitb[27], cbitb[25],
     cbitb[26], cbitb[24], cbitb[23], cbitb[21], cbitb[22], cbitb[20],
     cbitb[19], cbitb[17], cbitb[18], cbitb[16], cbitb[15], cbitb[13],
     cbitb[14], cbitb[12], cbitb[31], cbitb[29], cbitb[30], cbitb[28],
     cbitb[11], cbitb[9], cbitb[10], cbitb[8], cbitb[38], cbitb[36],
     cbitb[7], cbitb[6], cbitb[4]}));
sp12to4 I_sp12to4_7_ ( .prog(progd), .triout(sp4[7]),
     .cbitb(cbitb[62]), .drv(sp12[7]));
sp12to4 I_sp12to4_6_ ( .prog(progd), .triout(sp4[6]),
     .cbitb(cbitb[58]), .drv(sp12[6]));
sp12to4 I_sp12to4_5_ ( .prog(progd), .triout(sp4[5]),
     .cbitb(cbitb[54]), .drv(sp12[5]));
sp12to4 I_sp12to4_4_ ( .prog(progd), .triout(sp4[4]),
     .cbitb(cbitb[50]), .drv(sp12[4]));
sp12to4 I_sp12to4_3_ ( .prog(progd), .triout(sp4[3]),
     .cbitb(cbitb[46]), .drv(sp12[3]));
sp12to4 I_sp12to4_2_ ( .prog(progd), .triout(sp4[2]),
     .cbitb(cbitb[42]), .drv(sp12[2]));
sp12to4 I_sp12to4_1_ ( .prog(progd), .triout(sp4[1]), .cbitb(cbitb[5]),
     .drv(sp12[1]));
sp12to4 I_sp12to4_0_ ( .prog(progd), .triout(sp4[0]),
     .cbitb(cbitb[34]), .drv(sp12[0]));
sbox1 I_sbox1_1_ ( .l(l[1]), .cb({cbitb[63], cbitb[61], cbitb[59],
     cbitb[57], cbitb[55], cbitb[53], cbitb[51], cbitb[49]}), .r(r[1]),
     .t(m[1]), .b(b[1]), .c({cbit[63], cbit[61], cbit[59], cbit[57],
     cbit[55], cbit[53], cbit[51], cbit[49]}), .prog(progd));
sbox1 I_sbox1_0_ ( .l(l[0]), .cb({cbitb[47], cbitb[45], cbitb[43],
     cbitb[41], cbitb[39], cbitb[37], cbitb[35], cbitb[33]}), .r(r[0]),
     .t(m[0]), .b(b[0]), .c({cbit[47], cbit[45], cbit[43], cbit[41],
     cbit[39], cbit[37], cbit[35], cbit[33]}), .prog(progd));
cram16x4 I_cram16x4 ( .q(cbit[63:0]), .r_gnd(r_vdd[15:0]),
     .reset_b(reset_b[15:0]), .pgate(pgate[15:0]), .wl(wl[15:0]),
     .q_b(cbitb[63:0]), .bl(bl[3:0]));

endmodule
