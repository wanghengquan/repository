// Library - xpmem, Cell - ml_rowdrv2_last, View - schematic
// LAST TIME SAVED: Dec 12 09:52:59 2010
// NETLIST TIME: Mar 15 17:36:51 2011
`timescale 1ns / 1ns 

module ml_rowdrv2_last ( pgate, reset, smc_rsr_out, vddctrl, wl,
     wl_rd_sup, wl_rden_b, cram_pgateoff, cram_rst, cram_vddoff,
     cram_wl_en, por_rst, rsr_rst, smc_rsr_in, smc_rsr_inc, smc_write
     );
output  pgate, reset, smc_rsr_out, vddctrl, wl;

inout  wl_rd_sup, wl_rden_b;

input  cram_pgateoff, cram_rst, cram_vddoff, cram_wl_en, por_rst,
     rsr_rst, smc_rsr_in, smc_rsr_inc, smc_write;
/* wire vddp_ = test.cds_globalsInst.vddp_; */ supply1 vddp_;
supply0 gnd_;
supply1 vdd_;
supply0 GND_;
supply1 VDD_;



P_12_LLHVT  MP13 ( .D(wl), .B(vdd_), .G(act_wrt_b), .S(vdd_));
N_12_LLHVT  MN10 ( .D(wl), .B(gnd_), .G(off), .S(gnd_));
N_12_LLHVT  MN16 ( .D(wl_rden_b), .B(gnd_), .G(act_rd), .S(gnd_));
N_12_LLRVT  NM0 ( .D(wl), .B(gnd_), .G(act_rd), .S(wl_rd_sup));
P_12_LLRVT  MP0 ( .D(wl), .B(vdd_), .G(act_rd_b), .S(wl_rd_sup));
anor21_hvt I163 ( .A(smc_rsr_out), .B(cram_rst), .Y(net056),
     .C(por_rst));
nand2_hvt I182 ( .A(cram_wl_en), .Y(net057), .B(smc_rsr_out));
nand2_hvt I184 ( .A(smc_write), .Y(act_wrt_b), .B(net075));
nand2_hvt I171 ( .A(act_rd_b), .Y(off_b), .B(act_wrt_b));
nand2_hvt I159 ( .A(smc_rsr_out), .Y(net054), .B(cram_vddoff));
nand2_hvt I185 ( .A(net075), .Y(act_rd_b), .B(net073));
nand2_hvt I215 ( .A(smc_rsr_out), .Y(net0165), .B(cram_pgateoff));
inv_hvt I186 ( .A(net83), .Y(smc_rsr_out));
inv_hvt I167 ( .A(net054), .Y(vddctrl));
inv_hvt I165 ( .A(net056), .Y(reset));
inv_hvt I183 ( .A(off_b), .Y(off));
inv_hvt I170 ( .A(act_rd_b), .Y(act_rd));
inv_hvt I178 ( .A(smc_write), .Y(net073));
inv_hvt I180 ( .A(net057), .Y(net075));
inv_hvt I216 ( .A(net0165), .Y(pgate));
ml_dff_schematic I146 ( .R(rsr_rst), .D(smc_rsr_in), .CLK(smc_rsr_inc),
     .QN(net83), .Q(net0197));

endmodule
// Library - xpmem, Cell - ml_rowdrv2, View - schematic
// LAST TIME SAVED: Dec 12 09:52:59 2010
// NETLIST TIME: Mar 15 17:36:51 2011
`timescale 1ns / 1ns 

module ml_rowdrv2 ( pgate, reset, smc_rsr_out, vddctrl, wl, wl_rd_sup,
     wl_rden_b, cram_pgateoff, cram_rst, cram_vddoff, cram_wl_en,
     por_rst, rsr_rst, smc_rsr_in, smc_rsr_inc, smc_write );
output  pgate, reset, smc_rsr_out, vddctrl, wl;

inout  wl_rd_sup, wl_rden_b;

input  cram_pgateoff, cram_rst, cram_vddoff, cram_wl_en, por_rst,
     rsr_rst, smc_rsr_in, smc_rsr_inc, smc_write;
/* wire vddp_ = test.cds_globalsInst.vddp_; */ supply1 vddp_;
supply0 gnd_;
supply1 vdd_;
supply0 GND_;
supply1 VDD_;



P_12_LLHVT  MP13 ( .D(wl), .B(vdd_), .G(act_wrt_b), .S(vdd_));
N_12_LLHVT  MN16 ( .D(wl_rden_b), .B(gnd_), .G(act_rd), .S(gnd_));
N_12_LLHVT  MN10 ( .D(wl), .B(gnd_), .G(off), .S(gnd_));
N_12_LLRVT  M1 ( .D(wl), .B(gnd_), .G(act_rd), .S(wl_rd_sup));
P_12_LLRVT  MP0 ( .D(wl), .B(vdd_), .G(act_rd_b), .S(wl_rd_sup));
anor21_hvt I163 ( .A(smc_rsr_out), .B(cram_rst), .Y(net056),
     .C(por_rst));
nand2_hvt I182 ( .A(cram_wl_en), .Y(net057), .B(smc_rsr_out));
nand2_hvt I184 ( .A(smc_write), .Y(act_wrt_b), .B(net075));
nand2_hvt I171 ( .A(act_rd_b), .Y(off_b), .B(act_wrt_b));
nand2_hvt I159 ( .A(smc_rsr_out), .Y(net054), .B(cram_vddoff));
nand2_hvt I185 ( .A(net075), .Y(act_rd_b), .B(net073));
nand2_hvt I215 ( .A(smc_rsr_out), .Y(net0165), .B(cram_pgateoff));
inv_hvt I186 ( .A(net83), .Y(smc_rsr_out));
inv_hvt I167 ( .A(net054), .Y(vddctrl));
inv_hvt I165 ( .A(net056), .Y(reset));
inv_hvt I183 ( .A(off_b), .Y(off));
inv_hvt I170 ( .A(act_rd_b), .Y(act_rd));
inv_hvt I178 ( .A(smc_write), .Y(net073));
inv_hvt I180 ( .A(net057), .Y(net075));
inv_hvt I216 ( .A(net0165), .Y(pgate));
ml_dff_schematic I146 ( .R(rsr_rst), .D(smc_rsr_in), .CLK(smc_rsr_inc),
     .QN(net83), .Q(net0197));

endmodule