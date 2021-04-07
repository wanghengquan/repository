// Library - 8kblocks, Cell - ml_cram_logic_ice8p, View - schematic
// LAST TIME SAVED: Dec 11 08:34:58 2012
// NETLIST TIME: Feb 22 10:41:30 2013
`timescale 1ns / 1ns 

module ml_cram_logic_ice8p ( cram_pgateoff, cram_prec, cram_pullup_b,
     cram_rst, cram_vddoff, cram_wl_en, cram_write, smc_clk_out, por,
     smc_clk, smc_read, smc_rprec, smc_rpull_b, smc_rrst_pullwlen,
     smc_rwl_en, smc_seq_rst, smc_wcram_rst, smc_write, smc_wset_prec,
     smc_wset_precgnd, smc_wwlwrt_dis, smc_wwlwrt_en );

output  cram_pgateoff, cram_prec, cram_pullup_b, cram_rst, cram_vddoff,
     cram_wl_en, cram_write, smc_clk_out;

input  por, smc_clk, smc_read, smc_rprec, smc_rpull_b,
     smc_rrst_pullwlen, smc_rwl_en, smc_seq_rst, smc_wcram_rst,
     smc_write, smc_wset_prec, smc_wset_precgnd, smc_wwlwrt_dis,
     smc_wwlwrt_en;
supply1 vdd_;
supply0 gnd_;
wire vddp_ = test.cds_globalsInst.vddp_;
supply0 GND_;
supply1 VDD_;



NCAP_25_LP  C0 ( .PLUS(net314), .MINUS(GND_));
NCAP_25_LP  C1 ( .PLUS(net306), .MINUS(GND_));
NCAP_25_LP  C2 ( .PLUS(net326), .MINUS(GND_));
tielo I480 ( .tielo(net235));
nand2_hvt I213 ( .B(net311), .Y(net222), .A(net285));
mux2_hvt I295 ( .sel(net285), .out(net238), .in0(net293),
     .in1(net255));
mux2_hvt I429 ( .sel(net235), .out(net234), .in0(net230),
     .in1(net254));
mux2_hvt I428 ( .sel(net285), .out(net230), .in0(net319),
     .in1(cram_write_int));
mux2_hvt I430 ( .sel(net235), .out(net226), .in0(net254),
     .in1(net407));
nor2_hvt I391 ( .Y(net281), .B(reset_logic), .A(cram_rst));
nor2_hvt I414 ( .Y(net278), .B(smc_wwlwrt_en), .A(net276));
nor2_hvt I385 ( .Y(net368), .B(net274), .A(smc_rprec));
nor2_hvt I389 ( .Y(net272), .B(reset_logic), .A(net442));
nor2_hvt I392 ( .Y(net269), .B(cram_rst), .A(net240));
nor2_hvt I390 ( .Y(net266), .B(smc_seq_rst), .A(smc_write));
nor2_hvt I223 ( .Y(net263), .B(por), .A(net359));
nor2_hvt I366 ( .Y(net260), .B(net417), .A(reset_logic));
nor2_hvt I400 ( .Y(net257), .B(smc_wset_prec), .A(net255));
nor2_hvt I364 ( .Y(net254), .B(smc_seq_rst), .A(net426));
nor2_hvt I393 ( .Y(net251), .B(reset_logic), .A(set_wl_write));
nor2_hvt I398 ( .Y(net248), .B(net247), .A(smc_rpull_b));
nor2_hvt I329 ( .Y(net245), .B(smc_seq_rst), .A(net287));
nor2_hvt I402 ( .Y(net242), .B(smc_wset_precgnd), .A(net240));
inv_hvt I455 ( .Y(net341), .A(net278));
inv_hvt I256 ( .Y(set_wl_write), .A(net436));
inv_hvt I466 ( .Y(cram_rst_int_b), .A(net297));
inv_hvt I460 ( .Y(net335), .A(net248));
inv_hvt I463 ( .Y(net247), .A(net451));
inv_hvt I456 ( .Y(reset_logic), .A(net263));
inv_hvt I465 ( .Y(cram_rst), .A(cram_rst_int_b));
inv_hvt I443 ( .Y(cram_write_int), .A(net326));
inv_hvt I449 ( .Y(net325), .A(net251));
inv_hvt I3 ( .Y(sm_clk_b), .A(smc_clk));
inv_hvt I462 ( .Y(net321), .A(net247));
inv_hvt I421 ( .Y(net319), .A(net421));
inv_hvt I4 ( .Y(smc_clk_out), .A(sm_clk_b));
inv_hvt I435 ( .Y(net315), .A(net314));
inv_hvt I445 ( .Y(net326), .A(net307));
inv_hvt I453 ( .Y(net311), .A(net269));
inv_hvt I444 ( .Y(net306), .A(net315));
inv_hvt I442 ( .Y(net307), .A(net306));
inv_hvt I448 ( .Y(net443), .A(net281));
inv_hvt I450 ( .Y(net303), .A(net257));
inv_hvt I403 ( .Y(net444), .A(net242));
inv_hvt I454 ( .Y(dis_pgatewrt), .A(net260));
inv_hvt I468 ( .Y(net297), .A(net456));
inv_hvt I464 ( .Y(net295), .A(net222));
inv_hvt I346 ( .Y(net293), .A(net368));
inv_hvt I373 ( .Y(net314), .A(set_wl_write));
inv_hvt I459 ( .Y(net289), .A(smc_rwl_en));
inv_hvt I451 ( .Y(net287), .A(net238));
inv_hvt I452 ( .Y(net285), .A(net266));
inv_hvt I458 ( .Y(rst_rpull_rwl), .A(net272));
nor3_hvt I387 ( .C(reset_logic), .A(net368), .Y(net274),
     .B(smc_rwl_en));
nor3_hvt I469 ( .C(net355), .A(net355), .Y(net363), .B(net355));
nor3_hvt I386 ( .C(smc_read), .A(smc_write), .Y(net359),
     .B(smc_seq_rst));
nor3_hvt I217 ( .C(vdd_tieh), .A(vdd_tieh), .Y(net355), .B(vdd_tieh));
nor3_hvt I470 ( .C(net363), .A(net363), .Y(net351), .B(net363));
nor3_hvt I471 ( .C(net351), .A(net351), .Y(net347), .B(net351));
nor3_hvt I472 ( .C(net347), .A(net347), .Y(net343), .B(net347));
nand3_hvt I426 ( .A(vdd_tieh), .C(vdd_tieh), .B(vdd_tieh), .Y(net386));
nand3_hvt I479 ( .A(net378), .C(net378), .B(net378), .Y(net382));
nand3_hvt I478 ( .A(net374), .C(net374), .B(net374), .Y(net378));
nand3_hvt I477 ( .A(net370), .C(net370), .B(net370), .Y(net374));
nand3_hvt I476 ( .A(net386), .C(net386), .B(net386), .Y(net370));
ml_dff I406 ( .Q(net457), .QN(net456), .CLK(smc_clk_out),
     .D(smc_wcram_rst), .R(reset_logic));
ml_dff I407 ( .Q(net397), .QN(net451), .CLK(smc_clk_out), .D(net335),
     .R(rst_rpull_rwl));
ml_dff I413 ( .Q(net240), .QN(net446), .CLK(smc_clk_out), .D(net444),
     .R(net443));
ml_dff I108 ( .Q(net442), .QN(net402), .CLK(smc_clk_out),
     .D(smc_rrst_pullwlen), .R(reset_logic));
ml_dff I410 ( .Q(net276), .QN(net436), .CLK(smc_clk_out), .D(net341),
     .R(dis_pgatewrt));
ml_dff I412 ( .Q(net255), .QN(net394), .CLK(smc_clk_out), .D(net303),
     .R(net325));
ml_dff I405 ( .Q(net399), .QN(net426), .CLK(set_wl_write),
     .D(vdd_tieh), .R(dis_pgatewrt));
ml_dff I408 ( .Q(net400), .QN(net421), .CLK(net289), .D(vdd_tieh),
     .R(rst_rpull_rwl));
ml_dff I411 ( .Q(net417), .QN(net416), .CLK(smc_clk),
     .D(smc_wwlwrt_dis), .R(reset_logic));
ml_dff I431 ( .Q(net412), .QN(net411), .CLK(sm_clk_b), .D(net254),
     .R(dis_pgatewrt));
ml_dff I432 ( .Q(net407), .QN(net406), .CLK(smc_clk_out), .D(net412),
     .R(dis_pgatewrt));
tiehi I427 ( .tiehi(vdd_tieh));
sg_bufx10_ice8p I526 ( .out(cram_vddoff), .in(net295));
sg_bufx10_ice8p I447 ( .out(cram_write), .in(cram_write_int));
sg_bufx10_ice8p I467 ( .out(cram_pgateoff), .in(net226));
sg_bufx10_ice8p I457 ( .out(cram_wl_en), .in(net234));
sg_bufx10_ice8p I446 ( .out(cram_prec), .in(net245));
sg_bufx10_ice8p I461 ( .out(cram_pullup_b), .in(net321));

endmodule
