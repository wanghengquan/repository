// Library - ice1chip, Cell - nvcm_ml_block_ice1f_june, View -
//schematic
// LAST TIME SAVED: Jun 29 10:02:26 2011
// NETLIST TIME: Jun 29 10:32:27 2011
`timescale 1ns / 1ns 

module nvcm_ml_block_ice1f_june ( bp0, fsm_recall, fsm_tm_margin0_read,
     nvcm_boot, nvcm_rdy, nvcm_relextspi, spi_sdo, spi_sdo_oe_b,
     tgnd_fsm, tvdd_fsm, vpp, clk, nvcm_ce_b, rst_b,
     smc_load_nvcm_bstream, spi_sdi, spi_ss_b );
output  bp0, fsm_recall, fsm_tm_margin0_read, nvcm_boot, nvcm_rdy,
     nvcm_relextspi, spi_sdo, spi_sdo_oe_b, tgnd_fsm, tvdd_fsm;

inout  vpp;

input  clk, nvcm_ce_b, rst_b, smc_load_nvcm_bstream, spi_sdi, spi_ss_b;
supply1 vdd_;
supply0 gnd_;
//wire vddp_ = test.cds_globalsInst.vddp_;
supply0 GND_;
supply1 VDD_;

// Buses in the design

wire  [8:0]  nv_dataout;

wire  [3:0]  fsm_blkadd;

wire  [2:0]  fsm_trim_vrdwl;

wire  [2:0]  fsm_trim_vpgmwl;

wire  [3:0]  fsm_trim_vbg;

wire  [2:0]  fsm_trim_rrefrd;

wire  [2:0]  fsm_trim_rrefpgm;

wire  [3:0]  fsm_trim_ipp;

wire  [3:0]  fsm_blkadd_b;

wire  [1:0]  fsm_tm_ref_buf;

wire  [11:0]  fsm_coladd;

wire  [8:0]  fsm_rowadd;


/*
nvcm_top_ice8p I_nvcm_top_ice8p ( .fsm_tm_bgr_dis(fsm_bgr_dis),
     .fsm_tm_allbank_sel(fsm_tm_allbank_sel),
     .fsm_coladd(fsm_coladd[11:0]), .nvcm_max_coladd({tgnd_fsm,
     tgnd_fsm, tgnd_fsm, tvdd_fsm, tgnd_fsm, tvdd_fsm, tgnd_fsm,
     tgnd_fsm, tgnd_fsm, tvdd_fsm, tvdd_fsm, tvdd_fsm}),
     .nvcm_max_rowadd({tgnd_fsm, tgnd_fsm, tvdd_fsm, tvdd_fsm,
     tgnd_fsm, tgnd_fsm, tvdd_fsm, tvdd_fsm, tvdd_fsm}),
     .status_wip(net249), .fsm_tm_ref(fsm_tm_ref_buf[1:0]),
     .fsm_tm_rprd(fsm_tm_rprd), .nvcm_boot(nvcm_boot),
     .spi_ss_b(spi_ss_b), .spi_sdi(spi_sdi),
     .smc_load_nvcm_bstream(smc_load_nvcm_bstream), .rst_b(rst_b),
     .nvcm_ce_b(nvcm_ce_b), .nv_dataout(nv_dataout[8:0]), .clk(clk),
     .spi_sdo_oe_b(spi_sdo_oe_b), .spi_sdo(spi_sdo),
     .nvcm_relextspi(nvcm_relextspi), .nvcm_rdy(nvcm_rdy),
     .fsm_ymuxdis(fsm_ymuxdis), .fsm_wren(fsm_wren),
     .fsm_wpen(fsm_wpen), .fsm_wgnden(fsm_wgnden),
     .fsm_vpxaset(fsm_vpxaset), .fsm_tm_xvbg(fsm_tm_xvbg),
     .fsm_trim_vrdwl(fsm_trim_vrdwl[2:0]),
     .fsm_trim_vpgmwl(fsm_trim_vpgmwl[2:0]),
     .fsm_trim_vbg(fsm_trim_vbg[3:0]),
     .fsm_trim_rrefrd(fsm_trim_rrefrd[2:0]),
     .fsm_trim_rrefpgm(fsm_trim_rrefpgm[2:0]),
     .fsm_trim_multibl_read(fsm_trim_multibl_read),
     .fsm_trim_ipp(fsm_trim_ipp[3:0]),
     .fsm_tm_xvpxa_int(fsm_tm_xvpxa_int), .fsm_tm_xvpp(fsm_tm_xvpp),
     .fsm_tm_xforce(fsm_tm_xforce), .fsm_tm_vwleqbl(fsm_tm_vwleqbl),
     .fsm_tm_trow(fsm_tm_trow), .fsm_tm_testdec_wr(fsm_tm_testdec_wr),
     .fsm_tm_testdec(fsm_tm_testdec), .fsm_tm_tcol(fsm_tm_tcol),
     .fsm_tm_rd_mode(fsm_tm_rd_mode),
     .fsm_tm_margin0_read(fsm_tm_margin0_read),
     .fsm_tm_dma(fsm_tm_dma), .fsm_tm_allwl_l(fsm_tm_allwl_l),
     .fsm_tm_allwl_h(fsm_tm_allwl_h), .fsm_tm_allbl_l(fsm_tm_allbl_l),
     .fsm_tm_allbl_h(fsm_tm_allbl_h), .fsm_sample(fsm_sample),
     .fsm_rowadd(fsm_rowadd[8:0]), .fsm_recall(fsm_recall),
     .fsm_rd(fsm_rd), .fsm_pumpen(fsm_pumpen), .fsm_pgmvfy(fsm_pgmvfy),
     .fsm_pgmien(fsm_pgmien), .fsm_pgmhv(fsm_pgmhv),
     .fsm_pgmdisc(fsm_pgmdisc), .fsm_pgm(fsm_pgm),
     .fsm_nvcmen(fsm_nvcmen), .fsm_nv_sisi_ui(fsm_nv_sisi_ui),
     .fsm_nv_rri_trim(fsm_nv_rri_trim), .fsm_nv_redrow(fsm_nv_redrow),
     .fsm_nv_bstream(fsm_nv_bstream), .fsm_lshven(fsm_lshven),
     .fsm_gwlbdis(fsm_gwlbdis), .fsm_din(fsm_din),
     .fsm_blkadd_b(fsm_blkadd_b[3:0]), .fsm_blkadd(fsm_blkadd[3:0]),
     .bp0(bp0));
ml_chip_nvcm_1f I_ml_chip_nvcm ( .fsm_tm_ref(fsm_tm_ref_buf[1:0]),
     .fsm_tm_rprd(fsm_tm_rprd), .fsm_bgr_dis(fsm_bgr_dis),
     .tm_allbank_sel(fsm_tm_allbank_sel), .fsm_coladd(fsm_coladd[9:0]),
     .tm_wleqbl(fsm_tm_vwleqbl), .tm_testdec_wr(fsm_tm_testdec_wr),
     .tm_tcol(fsm_tm_tcol), .tm_dma(fsm_tm_dma),
     .tm_allwl_l(fsm_tm_allwl_l), .tm_allwl_h(fsm_tm_allwl_h),
     .tm_allbl_l(fsm_tm_allbl_l), .tm_allbl_h(fsm_tm_allbl_h),
     .fsm_ymuxdis(fsm_ymuxdis), .fsm_wren(fsm_wren),
     .fsm_wpen(fsm_wpen), .fsm_wgnden(fsm_wgnden),
     .fsm_vrdwl(fsm_trim_vrdwl[2:0]), .fsm_vpxaset(fsm_vpxaset),
     .fsm_vpgmwl(fsm_trim_vpgmwl[2:0]),
     .fsm_trim_vbg(fsm_trim_vbg[3:0]),
     .fsm_trim_rrefrd(fsm_trim_rrefrd[2:0]),
     .fsm_trim_rrefpgm(fsm_trim_rrefpgm[2:0]),
     .fsm_trim_ipp(fsm_trim_ipp[3:0]),
     .fsm_tm_xvpxaint(fsm_tm_xvpxa_int), .fsm_tm_xvppint(fsm_tm_xvpp),
     .fsm_tm_xvbg(fsm_tm_xvbg), .fsm_tm_xforce(fsm_tm_xforce),
     .fsm_tm_trow(fsm_tm_trow), .fsm_tm_testdec(fsm_tm_testdec),
     .fsm_tm_rd_mode(fsm_tm_rd_mode), .fsm_sample(fsm_sample),
     .fsm_rst_b(rst_bd), .fsm_rowadd(fsm_rowadd[7:0]), .fsm_rd(fsm_rd),
     .fsm_pumpen(fsm_pumpen), .fsm_pgmvfy(fsm_pgmvfy),
     .fsm_pgmien(fsm_pgmien), .fsm_pgmhv(fsm_pgmhv),
     .fsm_pgmdisc(fsm_pgmdisc), .fsm_pgm(fsm_pgm),
     .fsm_nvcmen(fsm_nvcmen), .fsm_nv_sisi_ui(fsm_nv_sisi_ui),
     .fsm_nv_rrow(fsm_nv_redrow), .fsm_nv_rri_trim(fsm_nv_rri_trim),
     .fsm_nv_bstream(fsm_nv_bstream),
     .fsm_multibl_read(fsm_trim_multibl_read), .fsm_lshven(fsm_lshven),
     .fsm_gwlbdis(fsm_gwlbdis), .fsm_din(fsm_din),
     .fsm_blkadd_b(fsm_blkadd_b[3:0]), .fsm_blkadd(fsm_blkadd[3:0]),
     .nv_dataout(nv_dataout[8:0]), .vpp(vpp));
*/
tiehi I442 ( .tiehi(tvdd_fsm));
tielo I369 ( .tielo(tgnd_fsm));
sg_bufx10_ice8p I541 ( .in(rst_b), .out(rst_bd));

endmodule
