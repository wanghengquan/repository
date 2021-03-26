// Verilog file generated from Magma Bedrock database
// Wed Apr 23 16:45:20 2008
// Bedrock Root: Magma_root

// Entity:smc_and_jtag Model:smc_and_jtag Library:L1
module smc_and_jtag (osc_clk, por_b, rst_b, cnt_podt_out, smc_podt_rst, 
     smc_podt_off, smc_oscoff_b, smc_osc_fsel, gint_hz, gsr, en_8bconfig_b, 
     end_of_startup, nvcm_spi_ss_b, nvcm_spi_sdi, nvcm_spi_sdo, 
     nvcm_spi_sdo_oe_b, nvcm_relextspi, nvcm_boot, smc_load_nvcm_bstream, 
     nvcm_rdy, bp0, creset_b, cdone_in, cdone_out, psdi, psdo, coldboot_sel, 
     boot, warmboot_sel, md_spi_b, spi_ss_in_b, spi_ss_out_b, spi_clk_in, 
     spi_clk_out, spi_sdi, spi_sdo, spi_sdo_oe_b, cm_clk, smc_write, smc_read, 
     smc_seq_rst, cm_banksel, cm_sdi_u0, cm_sdo_u0, cm_sdi_u1, cm_sdo_u1, 
     cm_sdi_u2, cm_sdo_u2, cm_sdi_u3, cm_sdo_u3, smc_rsr_rst, smc_row_inc, 
     smc_wset_prec, smc_wwlwrt_dis, smc_wcram_rst, smc_wset_precgnd, 
     smc_wwlwrt_en, smc_rwl_en, data_muxsel1, smc_wdis_dclk, data_muxsel, 
     smc_rpull_b, smc_rprec, smc_rrst_pullwlen, cm_last_rsr, cm_monitor_cell, 
     bm_clk, bm_banksel, bm_bank_sdi, bm_bank_sdo, bm_sa, bm_sweb, bm_sreb, 
     bm_sclkrw, bm_wdummymux_en, bm_rcapmux_en, bm_init, tms_pad, tck_pad, 
     trst_pad, tdi_pad, tdo_pad, tdo_oe_pad, j_sft_dr, j_upd_dr, j_rst_b, 
     j_hiz_b, j_mode, j_row_test, bschain_sdo, j_tck, j_tdi, bs_en, j_ceb0, 
     j_shift0);
  input osc_clk, por_b, cnt_podt_out, nvcm_spi_sdo, nvcm_spi_sdo_oe_b, 
     nvcm_relextspi, nvcm_boot, nvcm_rdy, bp0, creset_b, cdone_in, boot, 
     spi_ss_in_b, spi_clk_in, spi_sdi, cm_last_rsr, tms_pad, tck_pad, trst_pad, 
     tdi_pad, bschain_sdo;
  output rst_b, smc_podt_rst, smc_podt_off, smc_oscoff_b, gint_hz, gsr, 
     en_8bconfig_b, end_of_startup, nvcm_spi_ss_b, nvcm_spi_sdi, 
     smc_load_nvcm_bstream, cdone_out, md_spi_b, spi_ss_out_b, spi_clk_out, 
     spi_sdo, spi_sdo_oe_b, cm_clk, smc_write, smc_read, smc_seq_rst, 
     smc_rsr_rst, smc_row_inc, smc_wset_prec, smc_wwlwrt_dis, smc_wcram_rst, 
     smc_wset_precgnd, smc_wwlwrt_en, smc_rwl_en, data_muxsel1, smc_wdis_dclk, 
     data_muxsel, smc_rpull_b, smc_rprec, smc_rrst_pullwlen, bm_clk, bm_sweb, 
     bm_sreb, bm_sclkrw, bm_wdummymux_en, bm_rcapmux_en, bm_init, tdo_pad, 
     tdo_oe_pad, j_sft_dr, j_upd_dr, j_rst_b, j_hiz_b, j_mode, j_row_test, 
     j_tck, j_tdi, bs_en, j_ceb0, j_shift0;
  input [7:1] psdi;
  input [1:0] coldboot_sel;
  input [1:0] warmboot_sel;
  input [1:0] cm_sdo_u0;
  input [1:0] cm_sdo_u1;
  input [1:0] cm_sdo_u2;
  input [1:0] cm_sdo_u3;
  input [3:0] cm_monitor_cell;
  input [3:0] bm_bank_sdo;
  output [1:0] smc_osc_fsel;
  output [7:1] psdo;
  output [3:0] cm_banksel;
  output [1:0] cm_sdi_u0;
  output [1:0] cm_sdi_u1;
  output [1:0] cm_sdi_u2;
  output [1:0] cm_sdi_u3;
  output [3:0] bm_banksel;
  output [3:0] bm_bank_sdi;
  output [7:0] bm_sa;
  wire bm_bank_sdo_0_1, bm_bank_sdo_1_1, bm_bank_sdo_2_1, bm_bank_sdo_3_1, 
     cm_monitor_cell_0_1, cm_monitor_cell_1_1, cm_monitor_cell_2_1, 
     cm_monitor_cell_3_1, cm_sdo_u0_0_1, cm_sdo_u0_1_1, cm_sdo_u1_0_1, 
     cm_sdo_u1_1_1, cm_sdo_u2_0_1, cm_sdo_u2_1_1, cm_sdo_u3_0_1, cm_sdo_u3_1_1, 
     coldboot_sel_0_1, coldboot_sel_1_1, psdi_1_1, psdi_2_1, psdi_3_1, psdi_4_1, 
     psdi_5_1, psdi_6_1, psdi_7_1, warmboot_sel_0_1, warmboot_sel_1_1, 
     bm_bank_sdi_0_1, bm_bank_sdi_1_1, bm_bank_sdi_2_1, bm_bank_sdi_3_1, 
     bm_banksel_0_1, bm_banksel_1_1, bm_banksel_2_1, bm_banksel_3_1, bm_sa_0_1, 
     bm_sa_1_1, bm_sa_2_1, bm_sa_3_1, bm_sa_4_1, bm_sa_5_1, bm_sa_6_1, 
     bm_sa_7_1, cm_banksel_0_1, cm_banksel_1_1, cm_banksel_2_1, cm_banksel_3_1, 
     cm_sdi_u0_0_1, cm_sdi_u0_1_1, cm_sdi_u1_0_1, cm_sdi_u1_1_1, cm_sdi_u2_0_1, 
     cm_sdi_u2_1_1, cm_sdi_u3_0_1, cm_sdi_u3_1_1, psdo_1_1, psdo_2_1, psdo_3_1, 
     psdo_4_1, psdo_5_1, psdo_6_1, psdo_7_1, smc_osc_fsel_0_1, smc_osc_fsel_1_1, 
     \j_idcode_reg[0] , \j_idcode_reg[1] , \j_idcode_reg[2] , \j_idcode_reg[3] , 
     \j_idcode_reg[4] , \j_idcode_reg[5] , \j_idcode_reg[6] , \j_idcode_reg[7] , 
     \j_idcode_reg[8] , \j_idcode_reg[9] , \j_idcode_reg[10] , 
     \j_idcode_reg[11] , \j_idcode_reg[12] , \j_idcode_reg[13] , 
     \j_idcode_reg[14] , \j_idcode_reg[15] , \j_idcode_reg[16] , 
     \j_idcode_reg[17] , \j_idcode_reg[18] , \j_idcode_reg[19] , 
     \j_idcode_reg[20] , \j_idcode_reg[21] , \j_idcode_reg[22] , 
     \j_idcode_reg[23] , \j_idcode_reg[24] , \j_idcode_reg[25] , 
     \j_idcode_reg[26] , \j_idcode_reg[27] , \j_idcode_reg[28] , 
     \j_idcode_reg[29] , \j_idcode_reg[30] , \j_idcode_reg[31] , boot_1, bp0_1, 
     bschain_sdo_1, cdone_in_1, cm_last_rsr_1, cnt_podt_out_1, creset_b_1, 
     nvcm_boot_1, nvcm_rdy_1, nvcm_relextspi_1, nvcm_spi_sdo_1, 
     nvcm_spi_sdo_oe_b_1, osc_clk_1, por_b_1, spi_clk_in_1, spi_sdi_2, 
     spi_ss_in_b_1, tck_pad_1, tdi_pad_1, tms_pad_1, trst_pad_1, bm_clk_1, 
     bm_init_1, bm_rcapmux_en_1, Iconfig_top_BRAM_SMC_bm_sclkrw_2, bm_sreb_1, 
     bm_sweb_1, bm_wdummymux_en_1, bs_en_1, cdone_out_1, cm_clk_1, 
     data_muxsel_1, data_muxsel1_1, en_8bconfig_b_1, 
     Iconfig_top_CFG_SMC_end_of_startup_2, gint_hz_1, gsr_1, j_ceb0_1, 
     j_hiz_b_1, j_mode_1, j_row_test_1, j_rst_b_1, j_sft_dr_1, j_shift0_1, 
     j_tdi_1, j_upd_dr_1, md_spi_b_1, nvcm_spi_sdi_1, nvcm_spi_ss_b_1, 
     Iconfig_top_CLKGEN_clksw2_rst_b_2, smc_load_nvcm_bstream_1, smc_oscoff_b_1, 
     smc_podt_off_1, smc_podt_rst_1, smc_read_1, smc_row_inc_1, smc_rprec_1, 
     smc_rpull_b_1, smc_rrst_pullwlen_1, Iconfig_top_CRAM_SMC_smc_rsr_rst_3, 
     smc_rwl_en_1, smc_seq_rst_1, smc_wcram_rst_1, smc_wdis_dclk_1, smc_write_1, 
     smc_wset_prec_1, smc_wset_precgnd_1, smc_wwlwrt_dis_1, smc_wwlwrt_en_1, 
     spi_sdo_1, spi_sdo_oe_b_1, spi_ss_out_b_1, tdo_oe_pad_1, tdo_pad_1, gio_hz, 
     j_cfg_disable, j_cfg_enable, j_cfg_program, j_smc_cap, j_tdo, j_usercode, 
     md_jtag, bm_banksel_0_3, bm_banksel_1_3, cm_banksel_0_3, cm_banksel_1_3, 
     j_ceb0_2, tdo_pad_2, bm_banksel_2_2, bm_banksel_3_2, cm_banksel_2_2, 
     cm_banksel_3_2, smc_wdis_dclk_2, bm_rcapmux_en_2, bm_sweb_2, 
     bm_wdummymux_en_2, smc_podt_rst_2, data_muxsel_2, data_muxsel1_2, 
     smc_rprec_2, smc_rpull_b_2, smc_rrst_pullwlen_2, smc_rwl_en_2, 
     smc_wcram_rst_2, smc_wset_prec_2, smc_wset_precgnd_2, smc_wwlwrt_dis_2, 
     smc_wwlwrt_en_2, spi_sdo_3, nvcm_spi_ss_b_3, spi_sdo_oe_b_3, 
     spi_ss_out_b_3, j_upd_dr_2, j_row_test_2, bm_sclkrw_1, smc_podt_off_2, 
     smc_rsr_rst_1, smc_load_nvcm_bstream_3, j_sft_dr_2, smc_seq_rst_2, 
     smc_write_3, smc_read_3, end_of_startup_1, cdone_out_2, rst_b_1, j_tck_1, 
     bm_clk_2, spi_sdo_2, smc_write_2, cm_banksel_0_2, cm_banksel_1_2, 
     smc_read_2, bm_banksel_1_2, bm_banksel_0_2, spi_sdo_oe_b_2, 
     smc_load_nvcm_bstream_2, nvcm_spi_ss_b_2, spi_ss_out_b_2, spi_sdi_1, 
     spi_clk_out_10, spi_clk_out_12, tck_pad_2, tck_pad_3, tck_pad_4, tck_pad_5, 
     tck_pad_6, osc_clk_4, osc_clk_2, osc_clk_5, osc_clk_6, osc_clk_7, 
     spi_clk_in_2, spi_clk_in_3, spi_clk_in_4, spi_clk_in_5, spi_clk_in_6, 
     spi_clk_in_7, osc_clk_8, tck_pad_7, tck_pad_8, 
     Iconfig_top_CRAM_SMC_smc_rsr_rst_4, j_smc_cap_1, j_smc_cap_2, j_smc_cap_3, 
     Iconfig_top_CRAM_SMC_smc_rsr_rst_5, smc_seq_rst_3, smc_write_4, 
     j_cfg_enable_1, smc_read_4, j_cfg_disable_1, j_rst_b_2, md_jtag_1, 
     smc_load_nvcm_bstream_4, j_smc_cap_4, VSS_magmatienet_29, 
     VSS_magmatienet_28, VSS_magmatienet_12, VSS_magmatienet_7, 
     VSS_magmatienet_5, VSS_magmatienet_30, VSS_magmatienet_21, 
     VSS_magmatienet_17, VSS_magmatienet_6, VSS_magmatienet_13, 
     VSS_magmatienet_10, VSS_magmatienet_14, VSS_magmatienet_19, 
     VSS_magmatienet_15, VSS_magmatienet_31, VSS_magmatienet_22, 
     VSS_magmatienet_16, VSS_magmatienet_3, VSS_magmatienet_1, 
     VSS_magmatienet_2, VSS_magmatienet_23, VSS_magmatienet_9, 
     VSS_magmatienet_11, VSS_magmatienet_0, VSS_magmatienet_18, 
     VSS_magmatienet_20, VSS_magmatienet_24, VSS_magmatienet_25, 
     VSS_magmatienet_4, VSS_magmatienet_26, VSS_magmatienet_8, 
     VSS_magmatienet_27;
  BUFFD3HVT BUFFD3HVT_SPARE_9 (.I(VSS_magmatienet_26), .Z());
  BUFFD4HVT BL1_BUF61 (.I(Iconfig_top_CFG_SMC_end_of_startup_2), 
     .Z(end_of_startup_1));
  TIELHVT VSS_magmatiecell_18 (.ZN(VSS_magmatienet_18));
  tap_controller Itap_controller (.tms_pad(tms_pad_1), .tck_pad(), 
     .trst_pad(trst_pad_1), .tdi_pad(tdi_pad_1), .tdo_pad(tdo_pad_1), 
     .tdo_oe_pad(tdo_oe_pad_1), .j_sft_dr(j_sft_dr_1), .j_upd_dr(j_upd_dr_1), 
     .j_cap_dr(), .j_smc_cap(j_smc_cap), .j_rst_b(j_rst_b_1), 
     .j_cfg_enable(j_cfg_enable), .j_cfg_disable(j_cfg_disable), 
     .j_cfg_program(j_cfg_program), .md_jtag(md_jtag), .j_usercode(j_usercode), 
     .j_hiz_b(j_hiz_b_1), .j_mode(j_mode_1), .j_row_test(j_row_test_1), 
     .bschain_sdo(bschain_sdo_1), .smc_sdo(j_tdo), .gio_hz(gio_hz), .j_tck(), 
     .j_tdi(j_tdi_1), .bs_en(bs_en_1), .j_idcode_reg({\j_idcode_reg[31] , 
     \j_idcode_reg[30] , \j_idcode_reg[29] , \j_idcode_reg[28] , 
     \j_idcode_reg[27] , \j_idcode_reg[26] , \j_idcode_reg[25] , 
     \j_idcode_reg[24] , \j_idcode_reg[23] , \j_idcode_reg[22] , 
     \j_idcode_reg[21] , \j_idcode_reg[20] , \j_idcode_reg[19] , 
     \j_idcode_reg[18] , \j_idcode_reg[17] , \j_idcode_reg[16] , 
     \j_idcode_reg[15] , \j_idcode_reg[14] , \j_idcode_reg[13] , 
     \j_idcode_reg[12] , \j_idcode_reg[11] , \j_idcode_reg[10] , 
     \j_idcode_reg[9] , \j_idcode_reg[8] , \j_idcode_reg[7] , \j_idcode_reg[6] , 
     \j_idcode_reg[5] , \j_idcode_reg[4] , \j_idcode_reg[3] , \j_idcode_reg[2] , 
     \j_idcode_reg[1] , \j_idcode_reg[0] }), .j_ceb0(j_ceb0_1), 
     .j_shift0(j_shift0_1), .tck_pad_6(tck_pad_3), 
     .j_cfg_enable_1(j_cfg_enable_1), .j_cfg_disable_1(j_cfg_disable_1), 
     .tck_pad_7(tck_pad_4), .tck_pad_5(tck_pad_2), .j_smc_cap_1(j_smc_cap_1), 
     .j_rst_b_2(j_rst_b_2));
  BUFFD8HVT BUF_MPIN_out_spi_sdo (.I(spi_sdo_3), .Z(spi_sdo));
  TIELHVT VSS_magmatiecell_24 (.ZN(VSS_magmatienet_24));
  BUFFD4HVT BL1_BUF18 (.I(bm_wdummymux_en_1), .Z(bm_wdummymux_en_2));
  BUFFD1HVT OPTHOLD_G_37 (.I(Iconfig_top_CRAM_SMC_smc_rsr_rst_3), 
     .Z(Iconfig_top_CRAM_SMC_smc_rsr_rst_4));
  TIELHVT VSS_magmatiecell_9 (.ZN(VSS_magmatienet_9));
  MUX2D0HVT MUX2D0HVT_SPARE_2 (.I0(VSS_magmatienet_10), .I1(VSS_magmatienet_10), 
     .S(VSS_magmatienet_10), .Z());
  BUFFD4HVT BL1_BUF23 (.I(smc_rpull_b_1), .Z(smc_rpull_b_2));
  BUFFD4HVT BL1_BUF21 (.I(data_muxsel1_1), .Z(data_muxsel1_2));
  BUFFD8HVT BUF_MPIN_out_j_ceb0 (.I(j_ceb0_2), .Z(j_ceb0));
  BUFFD8HVT BUF_MPIN_out_bm_banksel_3 (.I(bm_banksel_3_2), .Z(bm_banksel[3]));
  BUFFD8HVT BUF_MPIN_out_bm_sa_0 (.I(bm_sa_0_1), .Z(bm_sa[0]));
  BUFFD8HVT BUF_MPIN_out_bm_bank_sdi_2 (.I(bm_bank_sdi_2_1), .Z(bm_bank_sdi[2]));
  BUFFD8HVT BUF_MPIN_out_j_shift0 (.I(j_shift0_1), .Z(j_shift0));
  BUFFD8HVT BUF_MPIN_out_j_rst_b (.I(j_rst_b_1), .Z(j_rst_b));
  CKBD1HVT BUF_MPIN_in_boot (.I(boot), .Z(boot_1));
  CKBD1HVT BUF_MPIN_in_bm_bank_sdo_1 (.I(bm_bank_sdo[1]), .Z(bm_bank_sdo_1_1));
  BUFFD8HVT BUF_MPIN_out_bm_sa_5 (.I(bm_sa_5_1), .Z(bm_sa[5]));
  INVD2HVT BL1_R_INV_9 (.I(cm_banksel_1_1), .ZN(cm_banksel_1_2));
  BUFFD8HVT BUF_MPIN_out_cm_sdi_u1_0 (.I(cm_sdi_u1_0_1), .Z(cm_sdi_u1[0]));
  BUFFD8HVT BUF_MPIN_out_j_upd_dr (.I(j_upd_dr_2), .Z(j_upd_dr));
  EDFCND1HVT EDFCND1HVT_SPARE_1 (.CDN(VSS_magmatienet_21), 
     .CP(VSS_magmatienet_21), .D(VSS_magmatienet_21), .E(VSS_magmatienet_21), 
     .Q(), .QN());
  BUFFD1HVT OPTHOLD_G_594 (.I(j_smc_cap_4), .Z(j_smc_cap_3));
  TIELHVT VSS_magmatiecell_23 (.ZN(VSS_magmatienet_23));
  BUFFD8HVT BUF_MPIN_out_smc_osc_fsel_0 (.I(smc_osc_fsel_0_1), 
     .Z(smc_osc_fsel[0]));
  TIELHVT VSS_magmatiecell_27 (.ZN(VSS_magmatienet_27));
  BUFFD1HVT OPTHOLD_G_60 (.I(j_smc_cap), .Z(j_smc_cap_2));
  BUFFD8HVT BUF_MPIN_out_bm_bank_sdi_1 (.I(bm_bank_sdi_1_1), .Z(bm_bank_sdi[1]));
  BUFFD8HVT BUF_MPIN_out_bm_sa_2 (.I(bm_sa_2_1), .Z(bm_sa[2]));
  TIELHVT VSS_magmatiecell_25 (.ZN(VSS_magmatienet_25));
  DFCNQD1HVT DFCNQD1HVT_SPARE_3 (.CDN(VSS_magmatienet_14), 
     .CP(VSS_magmatienet_14), .D(VSS_magmatienet_14), .Q());
  CKBD1HVT BUF_MPIN_in_nvcm_spi_sdo_oe_b (.I(nvcm_spi_sdo_oe_b), 
     .Z(nvcm_spi_sdo_oe_b_1));
  NR2D1HVT NR2D1HVT_SPARE_4 (.A1(VSS_magmatienet_15), .A2(VSS_magmatienet_15), 
     .ZN());
  BUFFD8HVT BL2_ASSIGN_BUF0 (.I(tck_pad_3), .Z(j_tck_1));
  TIELHVT VSS_magmatiecell_20 (.ZN(VSS_magmatienet_20));
  BUFFD4HVT BL1_BUF10 (.I(tdo_pad_1), .Z(tdo_pad_2));
  INVD8HVT BL1_R_INV_23 (.I(smc_load_nvcm_bstream_2), 
     .ZN(smc_load_nvcm_bstream_3));
  BUFFD2HVT BUF_MPIN_in_tms_pad (.I(tms_pad), .Z(tms_pad_1));
  BUFFD8HVT BUF_MPIN_out_cm_sdi_u2_0 (.I(cm_sdi_u2_0_1), .Z(cm_sdi_u2[0]));
  CKBD1HVT BUF_MPIN_in_cm_sdo_u2_0 (.I(cm_sdo_u2[0]), .Z(cm_sdo_u2_0_1));
  INVD8HVT BL1_R_INV_6 (.I(cm_banksel_0_2), .ZN(cm_banksel_0_3));
  BUFFD8HVT BUF_MPIN_out_bm_rcapmux_en (.I(bm_rcapmux_en_2), .Z(bm_rcapmux_en));
  BUFFD8HVT BUF_MPIN_out_j_tck (.I(j_tck_1), .Z(j_tck));
  EDFCND1HVT EDFCND1HVT_SPARE_4 (.CDN(VSS_magmatienet_30), 
     .CP(VSS_magmatienet_1), .D(VSS_magmatienet_1), .E(VSS_magmatienet_1), .Q(), 
     .QN());
  TIELHVT VSS_magmatiecell_30 (.ZN(VSS_magmatienet_30));
  BUFFD8HVT BUF_MPIN_out_psdo_7 (.I(psdo_7_1), .Z(psdo[7]));
  CKBD1HVT CLK_SYNC_SKEW_15 (.I(osc_clk_4), .Z(osc_clk_8));
  TIELHVT VSS_magmatiecell_12 (.ZN(VSS_magmatienet_12));
  BUFFD2HVT BUF_MPIN_in_spi_ss_in_b (.I(spi_ss_in_b), .Z(spi_ss_in_b_1));
  BUFFD4HVT BL1_BUF75 (.I(cdone_out_1), .Z(cdone_out_2));
  ND2D1HVT ND2D1HVT_SPARE_7 (.A1(VSS_magmatienet_30), .A2(VSS_magmatienet_30), 
     .ZN());
  CKBD16HVT BUF_MPIN_in_spi_clk_in (.I(spi_clk_in), .Z(spi_clk_in_1));
  CKBD4HVT CLK_SYNC_SKEW_7 (.I(spi_clk_in_4), .Z(spi_clk_in_5));
  CKBD1HVT CLK_SYNC_SKEW_4 (.I(spi_clk_in_1), .Z(spi_clk_in_2));
  TIELHVT VSS_magmatiecell_0 (.ZN(VSS_magmatienet_0));
  TIELHVT VSS_magmatiecell_7 (.ZN(VSS_magmatienet_7));
  BUFFD4HVT BL1_BUF19 (.I(smc_podt_rst_1), .Z(smc_podt_rst_2));
  CKBD4HVT CLK_SYNC_SKEW_2 (.I(osc_clk_5), .Z(osc_clk_6));
  ND2D1HVT ND2D1HVT_SPARE_2 (.A1(VSS_magmatienet_22), .A2(VSS_magmatienet_22), 
     .ZN());
  BUFFD2HVT BUF_MPIN_in_nvcm_spi_sdo (.I(nvcm_spi_sdo), .Z(nvcm_spi_sdo_1));
  BUFFD8HVT BUF_MPIN_out_nvcm_spi_sdi (.I(nvcm_spi_sdi_1), .Z(nvcm_spi_sdi));
  CKBD1HVT CLK_SYNC_SKEW (.I(osc_clk_1), .Z(osc_clk_2));
  BUFFD3HVT BUFFD3HVT_SPARE_4 (.I(VSS_magmatienet_21), .Z());
  NR2D1HVT NR2D1HVT_SPARE_6 (.A1(VSS_magmatienet_17), .A2(VSS_magmatienet_17), 
     .ZN());
  BUFFD2HVT BUF_MPIN_in_creset_b (.I(creset_b), .Z(creset_b_1));
  BUFFD8HVT BUF_MPIN_out_psdo_3 (.I(psdo_3_1), .Z(psdo[3]));
  BUFFD8HVT BUF_MPIN_out_smc_read (.I(smc_read_3), .Z(smc_read));
  BUFFD8HVT BUF_MPIN_out_smc_rprec (.I(smc_rprec_2), .Z(smc_rprec));
  BUFFD8HVT BUF_MPIN_out_data_muxsel (.I(data_muxsel_2), .Z(data_muxsel));
  BUFFD4HVT BL1_BUF29 (.I(smc_wwlwrt_dis_1), .Z(smc_wwlwrt_dis_2));
  BUFFD2HVT BUF_MPIN_in_cm_monitor_cell_1 (.I(cm_monitor_cell[1]), 
     .Z(cm_monitor_cell_1_1));
  BUFFD8HVT BUF_MPIN_out_smc_write (.I(smc_write_3), .Z(smc_write));
  BUFFD8HVT BUF_MPIN_out_smc_wdis_dclk (.I(smc_wdis_dclk_2), .Z(smc_wdis_dclk));
  INVD8HVT BL1_R_INV_4 (.I(smc_write_2), .ZN(smc_write_3));
  MUX2D0HVT MUX2D0HVT_SPARE_5 (.I0(VSS_magmatienet_4), .I1(VSS_magmatienet_4), 
     .S(VSS_magmatienet_4), .Z());
  ND2D1HVT ND2D1HVT_SPARE_3 (.A1(VSS_magmatienet_2), .A2(VSS_magmatienet_2), 
     .ZN());
  BUFFD3HVT BUFFD3HVT_SPARE_1 (.I(VSS_magmatienet_11), .Z());
  BUFFD1HVT OPTHOLD_G_628 (.I(smc_write_1), .Z(smc_write_4));
  BUFFD8HVT BUF_MPIN_out_smc_podt_off (.I(smc_podt_off_2), .Z(smc_podt_off));
  CKBD1HVT BUF_MPIN_in_nvcm_rdy (.I(nvcm_rdy), .Z(nvcm_rdy_1));
  EDFCND1HVT EDFCND1HVT_SPARE (.CDN(VSS_magmatienet_24), .CP(VSS_magmatienet_24), 
     .D(VSS_magmatienet_24), .E(VSS_magmatienet_24), .Q(), .QN());
  CKBD12HVT CLK_SYNC_SKEW_17 (.I(tck_pad_7), .Z(tck_pad_8));
  CKBD1HVT CLK_SYNC_SKEW_9 (.I(spi_clk_in_2), .Z(spi_clk_in_7));
  DFCNQD1HVT DFCNQD1HVT_SPARE (.CDN(VSS_magmatienet_24), .CP(VSS_magmatienet_24), 
     .D(VSS_magmatienet_24), .Q());
  BUFFD6HVT BL2_BUF1 (.I(bm_clk_1), .Z(bm_clk_2));
  BUFFD4HVT BL1_BUF16 (.I(bm_rcapmux_en_1), .Z(bm_rcapmux_en_2));
  BUFFD8HVT BUF_MPIN_out_smc_rsr_rst (.I(smc_rsr_rst_1), .Z(smc_rsr_rst));
  TIELHVT VSS_magmatiecell_13 (.ZN(VSS_magmatienet_13));
  BUFFD4HVT BL1_BUF20 (.I(data_muxsel_1), .Z(data_muxsel_2));
  BUFFD4HVT BL1_BUF46 (.I(Iconfig_top_CRAM_SMC_smc_rsr_rst_3), .Z(smc_rsr_rst_1));
  BUFFD8HVT BUF_MPIN_out_bm_init (.I(bm_init_1), .Z(bm_init));
  BUFFD8HVT BUF_MPIN_out_gint_hz (.I(gint_hz_1), .Z(gint_hz));
  BUFFD8HVT BUF_MPIN_out_bm_sreb (.I(bm_sreb_1), .Z(bm_sreb));
  BUFFD8HVT BUF_MPIN_out_bm_sa_6 (.I(bm_sa_6_1), .Z(bm_sa[6]));
  BUFFD8HVT BUF_MPIN_out_j_hiz_b (.I(j_hiz_b_1), .Z(j_hiz_b));
  BUFFD8HVT BUF_MPIN_out_j_sft_dr (.I(j_sft_dr_2), .Z(j_sft_dr));
  CKBD1HVT BUF_MPIN_in_warmboot_sel_1 (.I(warmboot_sel[1]), .Z(warmboot_sel_1_1));
  INVD8HVT BL1_R_INV_16 (.I(bm_banksel_1_2), .ZN(bm_banksel_1_3));
  CKBD1HVT BUF_MPIN_in_bm_bank_sdo_2 (.I(bm_bank_sdo[2]), .Z(bm_bank_sdo_2_1));
  BUFFD8HVT BUF_MPIN_out_cm_sdi_u0_1 (.I(cm_sdi_u0_1_1), .Z(cm_sdi_u0[1]));
  BUFFD8HVT BUF_MPIN_out_cm_sdi_u0_0 (.I(cm_sdi_u0_0_1), .Z(cm_sdi_u0[0]));
  CKBD1HVT BUF_MPIN_in_cm_sdo_u0_0 (.I(cm_sdo_u0[0]), .Z(cm_sdo_u0_0_1));
  BUFFD4HVT BL1_BUF9 (.I(j_ceb0_1), .Z(j_ceb0_2));
  MUX2D0HVT MUX2D0HVT_SPARE_7 (.I0(VSS_magmatienet_16), .I1(VSS_magmatienet_16), 
     .S(VSS_magmatienet_16), .Z());
  BUFFD1HVT OPTHOLD_G_842 (.I(md_jtag), .Z(md_jtag_1));
  BUFFD3HVT BUFFD3HVT_SPARE_6 (.I(VSS_magmatienet_29), .Z());
  BUFFD8HVT BUF_MPIN_out_smc_osc_fsel_1 (.I(smc_osc_fsel_1_1), 
     .Z(smc_osc_fsel[1]));
  INVD4HVT INVD4HVT_SPARE_4 (.I(VSS_magmatienet_27), .ZN());
  BUFFD1HVT OPTHOLD_G_701 (.I(j_rst_b_1), .Z(j_rst_b_2));
  BUFFD8HVT BUF_MPIN_out_bm_sa_1 (.I(bm_sa_1_1), .Z(bm_sa[1]));
  BUFFD8HVT BUF_MPIN_out_bm_bank_sdi_3 (.I(bm_bank_sdi_3_1), .Z(bm_bank_sdi[3]));
  BUFFD8HVT BL1_R_BUF_9 (.I(spi_sdi_2), .Z(spi_sdi_1));
  CKBD16HVT tck_pad_1_L1 (.I(tck_pad_6), .Z(tck_pad_5));
  CKBD16HVT BUF_MPIN_in_tck_pad (.I(tck_pad), .Z(tck_pad_1));
  CKBD1HVT BUF_MPIN_in_psdi_4 (.I(psdi[4]), .Z(psdi_4_1));
  EDFCND1HVT EDFCND1HVT_SPARE_3 (.CDN(VSS_magmatienet_15), 
     .CP(VSS_magmatienet_15), .D(VSS_magmatienet_15), .E(VSS_magmatienet_15), 
     .Q(), .QN());
  DFCNQD1HVT DFCNQD1HVT_SPARE_2 (.CDN(VSS_magmatienet_20), 
     .CP(VSS_magmatienet_20), .D(VSS_magmatienet_20), .Q());
  CKBD1HVT BUF_MPIN_in_tdi_pad (.I(tdi_pad), .Z(tdi_pad_1));
  CKBD1HVT BUF_MPIN_in_bp0 (.I(bp0), .Z(bp0_1));
  CKBD1HVT BUF_MPIN_in_cm_sdo_u3_0 (.I(cm_sdo_u3[0]), .Z(cm_sdo_u3_0_1));
  CKBD1HVT BUF_MPIN_in_cm_sdo_u1_0 (.I(cm_sdo_u1[0]), .Z(cm_sdo_u1_0_1));
  BUFFD8HVT BUF_MPIN_out_cm_sdi_u3_0 (.I(cm_sdi_u3_0_1), .Z(cm_sdi_u3[0]));
  INVD8HVT BL1_R_INV_8 (.I(cm_banksel_1_2), .ZN(cm_banksel_1_3));
  BUFFD8HVT BUF_MPIN_out_psdo_2 (.I(psdo_2_1), .Z(psdo[2]));
  BUFFD8HVT BUF_MPIN_out_psdo_4 (.I(psdo_4_1), .Z(psdo[4]));
  BUFFD8HVT BUF_MPIN_out_md_spi_b (.I(md_spi_b_1), .Z(md_spi_b));
  BUFFD8HVT BUF_MPIN_out_psdo_6 (.I(psdo_6_1), .Z(psdo[6]));
  NR2D1HVT NR2D1HVT_SPARE_3 (.A1(VSS_magmatienet_12), .A2(VSS_magmatienet_12), 
     .ZN());
  TIELHVT VSS_magmatiecell_14 (.ZN(VSS_magmatienet_14));
  INVD8HVT BL1_R_INV_27 (.I(spi_ss_out_b_2), .ZN(spi_ss_out_b_3));
  MUX2D0HVT MUX2D0HVT_SPARE_9 (.I0(VSS_magmatienet_1), .I1(VSS_magmatienet_1), 
     .S(VSS_magmatienet_1), .Z());
  MUX2D0HVT MUX2D0HVT_SPARE_1 (.I0(VSS_magmatienet_20), .I1(VSS_magmatienet_20), 
     .S(VSS_magmatienet_20), .Z());
  INVD4HVT INVD4HVT_SPARE_6 (.I(VSS_magmatienet_6), .ZN());
  INVD2HVT BL1_R_INV_3 (.I(spi_sdo_1), .ZN(spi_sdo_2));
  INVD2HVT BL1_R_INV_22 (.I(spi_sdo_oe_b_1), .ZN(spi_sdo_oe_b_2));
  ND2D1HVT ND2D1HVT_SPARE_6 (.A1(VSS_magmatienet_0), .A2(VSS_magmatienet_0), 
     .ZN());
  INVD4HVT INVD4HVT_SPARE_1 (.I(VSS_magmatienet_7), .ZN());
  BUFFD1HVT OPTHOLD_G_695 (.I(j_cfg_disable), .Z(j_cfg_disable_1));
  BUFFD4HVT BL1_BUF41 (.I(smc_podt_off_1), .Z(smc_podt_off_2));
  CKBD16HVT BUF_MPIN_in_osc_clk (.I(osc_clk), .Z(osc_clk_1));
  TIELHVT VSS_magmatiecell_22 (.ZN(VSS_magmatienet_22));
  INVD8HVT BL1_R_INV_25 (.I(nvcm_spi_ss_b_2), .ZN(nvcm_spi_ss_b_3));
  CKBD16HVT spi_clk_out_1_L1_1 (.I(spi_clk_out_12), .Z(spi_clk_out_10));
  BUFFD8HVT BUF_MPIN_out_en_8bconfig_b (.I(en_8bconfig_b_1), .Z(en_8bconfig_b));
  TIELHVT VSS_magmatiecell_31 (.ZN(VSS_magmatienet_31));
  TIELHVT VSS_magmatiecell_17 (.ZN(VSS_magmatienet_17));
  BUFFD8HVT BUF_MPIN_out_bs_en (.I(bs_en_1), .Z(bs_en));
  BUFFD4HVT BL1_BUF55 (.I(smc_seq_rst_1), .Z(smc_seq_rst_2));
  BUFFD8HVT BUF_MPIN_out_smc_rpull_b (.I(smc_rpull_b_2), .Z(smc_rpull_b));
  BUFFD4HVT BL1_BUF15 (.I(smc_wdis_dclk_1), .Z(smc_wdis_dclk_2));
  CKBD1HVT BUF_MPIN_in_cm_monitor_cell_3 (.I(cm_monitor_cell[3]), 
     .Z(cm_monitor_cell_3_1));
  BUFFD4HVT BL1_BUF30 (.I(smc_wwlwrt_en_1), .Z(smc_wwlwrt_en_2));
  BUFFD8HVT BUF_MPIN_out_smc_wset_prec (.I(smc_wset_prec_2), .Z(smc_wset_prec));
  BUFFD8HVT BUF_MPIN_out_smc_wwlwrt_en (.I(smc_wwlwrt_en_2), .Z(smc_wwlwrt_en));
  BUFFD4HVT BL1_BUF26 (.I(smc_wcram_rst_1), .Z(smc_wcram_rst_2));
  BUFFD8HVT BUF_MPIN_out_cm_banksel_3 (.I(cm_banksel_3_2), .Z(cm_banksel[3]));
  BUFFD3HVT BUFFD3HVT_SPARE_7 (.I(VSS_magmatienet_2), .Z());
  BUFFD1HVT OPTHOLD_G_627 (.I(smc_seq_rst_1), .Z(smc_seq_rst_3));
  INVD4HVT INVD4HVT_SPARE_7 (.I(VSS_magmatienet_11), .ZN());
  BUFFD8HVT BUF_MPIN_out_end_of_startup (.I(end_of_startup_1), 
     .Z(end_of_startup));
  BUFFD1HVT OPTHOLD_G_881 (.I(smc_load_nvcm_bstream_1), 
     .Z(smc_load_nvcm_bstream_4));
  MUX2D0HVT MUX2D0HVT_SPARE_6 (.I0(VSS_magmatienet_18), .I1(VSS_magmatienet_18), 
     .S(VSS_magmatienet_18), .Z());
  CKBD1HVT CLK_SYNC_SKEW_5 (.I(spi_clk_in_7), .Z(spi_clk_in_3));
  TIELHVT VSS_magmatiecell_29 (.ZN(VSS_magmatienet_29));
  TIELHVT VSS_magmatiecell_19 (.ZN(VSS_magmatienet_19));
  BUFFD4HVT BL1_BUF17 (.I(bm_sweb_1), .Z(bm_sweb_2));
  INVD4HVT INVD4HVT_SPARE_2 (.I(VSS_magmatienet_9), .ZN());
  TIELHVT VSS_magmatiecell_10 (.ZN(VSS_magmatienet_10));
  ND2D1HVT ND2D1HVT_SPARE_9 (.A1(VSS_magmatienet_13), .A2(VSS_magmatienet_13), 
     .ZN());
  BUFFD4HVT BL1_BUF24 (.I(smc_rrst_pullwlen_1), .Z(smc_rrst_pullwlen_2));
  TIELHVT VSS_magmatiecell_4 (.ZN(VSS_magmatienet_4));
  BUFFD8HVT BUF_MPIN_out_bm_banksel_0 (.I(bm_banksel_0_3), .Z(bm_banksel[0]));
  BUFFD8HVT BUF_MPIN_out_bm_bank_sdi_0 (.I(bm_bank_sdi_0_1), .Z(bm_bank_sdi[0]));
  BUFFD8HVT BUF_MPIN_out_bm_sclkrw (.I(bm_sclkrw_1), .Z(bm_sclkrw));
  BUFFD8HVT BUF_MPIN_out_bm_clk (.I(bm_clk_2), .Z(bm_clk));
  BUFFD8HVT BUF_MPIN_out_j_mode (.I(j_mode_1), .Z(j_mode));
  BUFFD4HVT BL1_BUF37 (.I(j_row_test_1), .Z(j_row_test_2));
  CKBD1HVT BUF_MPIN_in_warmboot_sel_0 (.I(warmboot_sel[0]), .Z(warmboot_sel_0_1));
  CKBD1HVT BUF_MPIN_in_bm_bank_sdo_0 (.I(bm_bank_sdo[0]), .Z(bm_bank_sdo_0_1));
  INVD2HVT BL1_R_INV_20 (.I(bm_banksel_0_1), .ZN(bm_banksel_0_2));
  INVD2HVT BL1_R_INV_7 (.I(cm_banksel_0_1), .ZN(cm_banksel_0_2));
  CKBD1HVT BUF_MPIN_in_cm_sdo_u0_1 (.I(cm_sdo_u0[1]), .Z(cm_sdo_u0_1_1));
  BUFFD4HVT BL1_BUF36 (.I(j_upd_dr_1), .Z(j_upd_dr_2));
  TIELHVT VSS_magmatiecell_21 (.ZN(VSS_magmatienet_21));
  TIELHVT VSS_magmatiecell_16 (.ZN(VSS_magmatienet_16));
  BUFFD3HVT BUFFD3HVT_SPARE_8 (.I(VSS_magmatienet_25), .Z());
  BUFFD3HVT BUFFD3HVT_SPARE_2 (.I(VSS_magmatienet_29), .Z());
  CKBD12HVT tck_pad_1_L3 (.I(tck_pad_4), .Z(tck_pad_2));
  BUFFD3HVT BUFFD3HVT_SPARE_3 (.I(VSS_magmatienet_23), .Z());
  BUFFD4HVT BL1_BUF53 (.I(j_sft_dr_1), .Z(j_sft_dr_2));
  BUFFD8HVT BUF_MPIN_out_bm_sa_4 (.I(bm_sa_4_1), .Z(bm_sa[4]));
  BUFFD8HVT BUF_MPIN_out_bm_banksel_1 (.I(bm_banksel_1_3), .Z(bm_banksel[1]));
  CKBD12HVT CLK_SYNC_SKEW_16 (.I(tck_pad_5), .Z(tck_pad_7));
  TIELHVT VSS_magmatiecell_26 (.ZN(VSS_magmatienet_26));
  CKBD1HVT BUF_MPIN_in_psdi_6 (.I(psdi[6]), .Z(psdi_6_1));
  BUFFD8HVT BUF_MPIN_out_tdo_oe_pad (.I(tdo_oe_pad_1), .Z(tdo_oe_pad));
  BUFFD3HVT BUFFD3HVT_SPARE_5 (.I(VSS_magmatienet_20), .Z());
  BUFFD8HVT BUF_MPIN_out_tdo_pad (.I(tdo_pad_2), .Z(tdo_pad));
  ND2D1HVT ND2D1HVT_SPARE (.A1(VSS_magmatienet_28), .A2(VSS_magmatienet_28), 
     .ZN());
  BUFFD8HVT BUF_MPIN_out_smc_load_nvcm_bstream (.I(smc_load_nvcm_bstream_3), 
     .Z(smc_load_nvcm_bstream));
  CKBD1HVT BUF_MPIN_in_cm_sdo_u3_1 (.I(cm_sdo_u3[1]), .Z(cm_sdo_u3_1_1));
  BUFFD8HVT BUF_MPIN_out_cm_sdi_u2_1 (.I(cm_sdi_u2_1_1), .Z(cm_sdi_u2[1]));
  BUFFD4HVT BL1_BUF13 (.I(cm_banksel_2_1), .Z(cm_banksel_2_2));
  BUFFD4HVT BL1_BUF14 (.I(cm_banksel_3_1), .Z(cm_banksel_3_2));
  BUFFD8HVT BUF_MPIN_out_psdo_5 (.I(psdo_5_1), .Z(psdo[5]));
  DFCNQD1HVT DFCNQD1HVT_SPARE_1 (.CDN(VSS_magmatienet_30), 
     .CP(VSS_magmatienet_30), .D(VSS_magmatienet_3), .Q());
  DFCNQD1HVT DFCNQD1HVT_SPARE_4 (.CDN(VSS_magmatienet_14), 
     .CP(VSS_magmatienet_12), .D(VSS_magmatienet_12), .Q());
  CKBD1HVT BUF_MPIN_in_psdi_2 (.I(psdi[2]), .Z(psdi_2_1));
  CKBD1HVT osc_clk_1_L0 (.I(osc_clk_7), .Z(osc_clk_4));
  CKBD3HVT tck_pad_1_L0 (.I(tck_pad_1), .Z(tck_pad_6));
  BUFFD2HVT BUF_MPIN_in_cdone_in (.I(cdone_in), .Z(cdone_in_1));
  NR2D1HVT NR2D1HVT_SPARE_2 (.A1(VSS_magmatienet_1), .A2(VSS_magmatienet_1), 
     .ZN());
  TIELHVT VSS_magmatiecell_6 (.ZN(VSS_magmatienet_6));
  TIELHVT VSS_magmatiecell_5 (.ZN(VSS_magmatienet_5));
  INVD8HVT BL1_R_INV_2 (.I(spi_sdo_2), .ZN(spi_sdo_3));
  BUFFD8HVT BUF_MPIN_out_spi_ss_out_b (.I(spi_ss_out_b_3), .Z(spi_ss_out_b));
  BUFFD2HVT BUF_MPIN_in_coldboot_sel_1 (.I(coldboot_sel[1]), 
     .Z(coldboot_sel_1_1));
  ND2D1HVT ND2D1HVT_SPARE_5 (.A1(VSS_magmatienet_2), .A2(VSS_magmatienet_2), 
     .ZN());
  CKBD1HVT BUF_MPIN_in_cnt_podt_out (.I(cnt_podt_out), .Z(cnt_podt_out_1));
  CKBD16HVT CLK_SYNC_SKEW_3 (.I(osc_clk_6), .Z(osc_clk_7));
  BUFFD1HVT OPTHOLD_G_654 (.I(j_cfg_enable), .Z(j_cfg_enable_1));
  INVD2HVT BL1_R_INV_26 (.I(nvcm_spi_ss_b_1), .ZN(nvcm_spi_ss_b_2));
  BUFFD8HVT BUF_MPIN_out_nvcm_spi_ss_b (.I(nvcm_spi_ss_b_3), .Z(nvcm_spi_ss_b));
  CKBD2HVT CLK_SYNC_SKEW_1 (.I(osc_clk_2), .Z(osc_clk_5));
  BUFFD3HVT BUFFD3HVT_SPARE (.I(VSS_magmatienet_31), .Z());
  NR2D1HVT NR2D1HVT_SPARE (.A1(VSS_magmatienet_17), .A2(VSS_magmatienet_17), 
     .ZN());
  MUX2D0HVT MUX2D0HVT_SPARE_8 (.I0(VSS_magmatienet_30), .I1(VSS_magmatienet_6), 
     .S(VSS_magmatienet_30), .Z());
  BUFFD8HVT BUF_MPIN_out_psdo_1 (.I(psdo_1_1), .Z(psdo[1]));
  BUFFD8HVT BUF_MPIN_out_cm_clk (.I(cm_clk_1), .Z(cm_clk));
  CKBD1HVT BUF_MPIN_in_cm_last_rsr (.I(cm_last_rsr), .Z(cm_last_rsr_1));
  INVD2HVT BL1_R_INV_5 (.I(smc_write_1), .ZN(smc_write_2));
  BUFFD1HVT OPTHOLD_G_689 (.I(smc_read_1), .Z(smc_read_4));
  BUFFD8HVT BUF_MPIN_out_smc_wwlwrt_dis (.I(smc_wwlwrt_dis_2), 
     .Z(smc_wwlwrt_dis));
  BUFFD8HVT BUF_MPIN_out_smc_wcram_rst (.I(smc_wcram_rst_2), .Z(smc_wcram_rst));
  BUFFD8HVT BUF_MPIN_out_smc_rwl_en (.I(smc_rwl_en_2), .Z(smc_rwl_en));
  BUFFD2HVT BUF_MPIN_in_cm_monitor_cell_0 (.I(cm_monitor_cell[0]), 
     .Z(cm_monitor_cell_0_1));
  BUFFD1HVT OPTHOLD_G_608 (.I(Iconfig_top_CRAM_SMC_smc_rsr_rst_3), 
     .Z(Iconfig_top_CRAM_SMC_smc_rsr_rst_5));
  TIELHVT VSS_magmatiecell_8 (.ZN(VSS_magmatienet_8));
  NR2D1HVT NR2D1HVT_SPARE_7 (.A1(VSS_magmatienet_10), .A2(VSS_magmatienet_10), 
     .ZN());
  MUX2D0HVT MUX2D0HVT_SPARE (.I0(VSS_magmatienet_5), .I1(VSS_magmatienet_5), 
     .S(VSS_magmatienet_5), .Z());
  config_top Iconfig_top (.osc_clk(), .por_b(por_b_1), 
     .rst_b(Iconfig_top_CLKGEN_clksw2_rst_b_2), .cnt_podt_out(cnt_podt_out_1), 
     .smc_podt_rst(smc_podt_rst_1), .smc_podt_off(smc_podt_off_1), 
     .smc_oscoff_b(smc_oscoff_b_1), .smc_osc_fsel({smc_osc_fsel_1_1, 
     smc_osc_fsel_0_1}), .gint_hz(gint_hz_1), .gio_hz(gio_hz), .gsr(gsr_1), 
     .en_8bconfig_b(en_8bconfig_b_1), 
     .end_of_startup(Iconfig_top_CFG_SMC_end_of_startup_2), 
     .nvcm_spi_ss_b(nvcm_spi_ss_b_1), .nvcm_spi_sdi(nvcm_spi_sdi_1), 
     .nvcm_spi_sdo(nvcm_spi_sdo_1), .nvcm_spi_sdo_oe_b(nvcm_spi_sdo_oe_b_1), 
     .nvcm_relextspi(nvcm_relextspi_1), .nvcm_boot(nvcm_boot_1), 
     .smc_load_nvcm_bstream(smc_load_nvcm_bstream_1), .nvcm_rdy(nvcm_rdy_1), 
     .bp0(bp0_1), .creset_b(creset_b_1), .cdone_in(cdone_in_1), 
     .cdone_out(cdone_out_1), .psdi({psdi_7_1, psdi_6_1, psdi_5_1, psdi_4_1, 
     psdi_3_1, psdi_2_1, psdi_1_1}), .psdo({psdo_7_1, psdo_6_1, psdo_5_1, 
     psdo_4_1, psdo_3_1, psdo_2_1, psdo_1_1}), .coldboot_sel({coldboot_sel_1_1, 
     coldboot_sel_0_1}), .boot(boot_1), .warmboot_sel({warmboot_sel_1_1, 
     warmboot_sel_0_1}), .md_jtag(md_jtag), .j_tck(), .j_tdi(j_tdi_1), 
     .j_tdo(j_tdo), .j_rst_b(j_rst_b_1), .j_cfg_enable(j_cfg_enable), 
     .j_cfg_disable(j_cfg_disable), .j_cfg_program(j_cfg_program), 
     .j_cap_dr(j_smc_cap), .j_sft_dr(j_sft_dr_1), .j_idcode_reg({
     \j_idcode_reg[31] , \j_idcode_reg[30] , \j_idcode_reg[29] , 
     \j_idcode_reg[28] , \j_idcode_reg[27] , \j_idcode_reg[26] , 
     \j_idcode_reg[25] , \j_idcode_reg[24] , \j_idcode_reg[23] , 
     \j_idcode_reg[22] , \j_idcode_reg[21] , \j_idcode_reg[20] , 
     \j_idcode_reg[19] , \j_idcode_reg[18] , \j_idcode_reg[17] , 
     \j_idcode_reg[16] , \j_idcode_reg[15] , \j_idcode_reg[14] , 
     \j_idcode_reg[13] , \j_idcode_reg[12] , \j_idcode_reg[11] , 
     \j_idcode_reg[10] , \j_idcode_reg[9] , \j_idcode_reg[8] , 
     \j_idcode_reg[7] , \j_idcode_reg[6] , \j_idcode_reg[5] , \j_idcode_reg[4] , 
     \j_idcode_reg[3] , \j_idcode_reg[2] , \j_idcode_reg[1] , \j_idcode_reg[0] }), 
     .j_usercode(j_usercode), .md_spi_b(md_spi_b_1), 
     .spi_ss_in_b(spi_ss_in_b_1), .spi_ss_out_b(spi_ss_out_b_1), .spi_clk_in(), 
     .spi_clk_out(), .spi_sdi(spi_sdi_1), .spi_sdo(spi_sdo_1), 
     .spi_sdo_oe_b(spi_sdo_oe_b_1), .cm_clk(cm_clk_1), .smc_write(smc_write_1), 
     .smc_read(smc_read_1), .smc_seq_rst(smc_seq_rst_1), .cm_banksel({
     cm_banksel_3_1, cm_banksel_2_1, cm_banksel_1_1, cm_banksel_0_1}), 
     .cm_sdi_u0({cm_sdi_u0_1_1, cm_sdi_u0_0_1}), .cm_sdo_u0({cm_sdo_u0_1_1, 
     cm_sdo_u0_0_1}), .cm_sdi_u1({cm_sdi_u1_1_1, cm_sdi_u1_0_1}), .cm_sdo_u1({
     cm_sdo_u1_1_1, cm_sdo_u1_0_1}), .cm_sdi_u2({cm_sdi_u2_1_1, cm_sdi_u2_0_1}), 
     .cm_sdo_u2({cm_sdo_u2_1_1, cm_sdo_u2_0_1}), .cm_sdi_u3({cm_sdi_u3_1_1, 
     cm_sdi_u3_0_1}), .cm_sdo_u3({cm_sdo_u3_1_1, cm_sdo_u3_0_1}), 
     .smc_rsr_rst(Iconfig_top_CRAM_SMC_smc_rsr_rst_3), 
     .smc_row_inc(smc_row_inc_1), .smc_wset_prec(smc_wset_prec_1), 
     .smc_wwlwrt_dis(smc_wwlwrt_dis_1), .smc_wcram_rst(smc_wcram_rst_1), 
     .smc_wset_precgnd(smc_wset_precgnd_1), .smc_wwlwrt_en(smc_wwlwrt_en_1), 
     .smc_rwl_en(smc_rwl_en_1), .data_muxsel1(data_muxsel1_1), 
     .smc_wdis_dclk(smc_wdis_dclk_1), .data_muxsel(data_muxsel_1), 
     .smc_rpull_b(smc_rpull_b_1), .smc_rprec(smc_rprec_1), 
     .smc_rrst_pullwlen(smc_rrst_pullwlen_1), .cm_last_rsr(cm_last_rsr_1), 
     .cm_monitor_cell({cm_monitor_cell_3_1, cm_monitor_cell_2_1, 
     cm_monitor_cell_1_1, cm_monitor_cell_0_1}), .bm_clk(bm_clk_1), .bm_banksel({
     bm_banksel_3_1, bm_banksel_2_1, bm_banksel_1_1, bm_banksel_0_1}), 
     .bm_bank_sdi({bm_bank_sdi_3_1, bm_bank_sdi_2_1, bm_bank_sdi_1_1, 
     bm_bank_sdi_0_1}), .bm_bank_sdo({bm_bank_sdo_3_1, bm_bank_sdo_2_1, 
     bm_bank_sdo_1_1, bm_bank_sdo_0_1}), .bm_sa({bm_sa_7_1, bm_sa_6_1, bm_sa_5_1, 
     bm_sa_4_1, bm_sa_3_1, bm_sa_2_1, bm_sa_1_1, bm_sa_0_1}), .bm_sweb(bm_sweb_1), 
     .bm_sreb(bm_sreb_1), .bm_sclkrw(Iconfig_top_BRAM_SMC_bm_sclkrw_2), 
     .bm_wdummymux_en(bm_wdummymux_en_1), .bm_rcapmux_en(bm_rcapmux_en_1), 
     .bm_init(bm_init_1), .spi_clk_out_11(spi_clk_out_10), 
     .osc_clk_2(osc_clk_1), .osc_clk_5(osc_clk_4), 
     .smc_load_nvcm_bstream_4(smc_load_nvcm_bstream_4), 
     .smc_write_4(smc_write_4), .spi_clk_in_2(spi_clk_in_1), 
     .smc_read_4(smc_read_4), 
     .Iconfig_top_CRAM_SMC_smc_rsr_rst_5(Iconfig_top_CRAM_SMC_smc_rsr_rst_5), 
     .Iconfig_top_CRAM_SMC_smc_rsr_rst_4(Iconfig_top_CRAM_SMC_smc_rsr_rst_4), 
     .smc_seq_rst_3(smc_seq_rst_3), .spi_clk_out_13(spi_clk_out_12), 
     .tck_pad_8(tck_pad_8), .md_jtag_1(md_jtag_1), .spi_clk_in_6(spi_clk_in_6), 
     .tck_pad_4(tck_pad_2), .tck_pad_3(tck_pad_1), .osc_clk_8(osc_clk_8));
  TIELHVT VSS_magmatiecell_28 (.ZN(VSS_magmatienet_28));
  INVD2HVT BL1_R_INV_24 (.I(smc_load_nvcm_bstream_1), 
     .ZN(smc_load_nvcm_bstream_2));
  EDFCND1HVT EDFCND1HVT_SPARE_2 (.CDN(VSS_magmatienet_31), 
     .CP(VSS_magmatienet_31), .D(VSS_magmatienet_31), .E(VSS_magmatienet_31), 
     .Q(), .QN());
  BUFFD4HVT BUF_MPIN_in_spi_sdi (.I(spi_sdi), .Z(spi_sdi_2));
  INVD4HVT INVD4HVT_SPARE_5 (.I(VSS_magmatienet_19), .ZN());
  INVD4HVT INVD4HVT_SPARE_8 (.I(VSS_magmatienet_9), .ZN());
  BUFFD4HVT BL1_BUF39 (.I(Iconfig_top_BRAM_SMC_bm_sclkrw_2), .Z(bm_sclkrw_1));
  BUFFD8HVT BUF_MPIN_out_smc_rrst_pullwlen (.I(smc_rrst_pullwlen_2), 
     .Z(smc_rrst_pullwlen));
  INVD4HVT INVD4HVT_SPARE_3 (.I(VSS_magmatienet_13), .ZN());
  INVD8HVT BL1_R_INV_10 (.I(smc_read_2), .ZN(smc_read_3));
  INVD2HVT BL1_R_INV_11 (.I(smc_read_1), .ZN(smc_read_2));
  BUFFD8HVT BUF_MPIN_out_bm_banksel_2 (.I(bm_banksel_2_2), .Z(bm_banksel[2]));
  BUFFD8HVT BUF_MPIN_out_j_row_test (.I(j_row_test_2), .Z(j_row_test));
  BUFFD8HVT BUF_MPIN_out_bm_wdummymux_en (.I(bm_wdummymux_en_2), 
     .Z(bm_wdummymux_en));
  BUFFD8HVT BUF_MPIN_out_gsr (.I(gsr_1), .Z(gsr));
  BUFFD8HVT BUF_MPIN_out_bm_sweb (.I(bm_sweb_2), .Z(bm_sweb));
  INVD8HVT BL1_R_INV_19 (.I(bm_banksel_0_2), .ZN(bm_banksel_0_3));
  BUFFD4HVT BL1_BUF12 (.I(bm_banksel_3_1), .Z(bm_banksel_3_2));
  INVD2HVT BL1_R_INV_17 (.I(bm_banksel_1_1), .ZN(bm_banksel_1_2));
  BUFFD4HVT BL1_BUF11 (.I(bm_banksel_2_1), .Z(bm_banksel_2_2));
  CKBD1HVT BUF_MPIN_in_bm_bank_sdo_3 (.I(bm_bank_sdo[3]), .Z(bm_bank_sdo_3_1));
  BUFFD8HVT BUF_MPIN_out_cm_banksel_1 (.I(cm_banksel_1_3), .Z(cm_banksel[1]));
  BUFFD8HVT BUF_MPIN_out_cm_sdi_u1_1 (.I(cm_sdi_u1_1_1), .Z(cm_sdi_u1[1]));
  CKBD1HVT BUF_MPIN_in_cm_sdo_u1_1 (.I(cm_sdo_u1[1]), .Z(cm_sdo_u1_1_1));
  CKBD1HVT BUF_MPIN_in_por_b (.I(por_b), .Z(por_b_1));
  BUFFD1HVT OPTHOLD_G_980 (.I(j_smc_cap_2), .Z(j_smc_cap_4));
  MUX2D0HVT MUX2D0HVT_SPARE_4 (.I0(VSS_magmatienet_23), .I1(VSS_magmatienet_23), 
     .S(VSS_magmatienet_23), .Z());
  ND2D1HVT ND2D1HVT_SPARE_8 (.A1(VSS_magmatienet_23), .A2(VSS_magmatienet_23), 
     .ZN());
  BUFFD8HVT BUF_MPIN_out_smc_oscoff_b (.I(smc_oscoff_b_1), .Z(smc_oscoff_b));
  ND2D1HVT ND2D1HVT_SPARE_1 (.A1(VSS_magmatienet_27), .A2(VSS_magmatienet_27), 
     .ZN());
  BUFFD1HVT OPTHOLD_G_59 (.I(j_smc_cap_3), .Z(j_smc_cap_1));
  BUFFD8HVT BUF_MPIN_out_bm_sa_3 (.I(bm_sa_3_1), .Z(bm_sa[3]));
  BUFFD8HVT BUF_MPIN_out_bm_sa_7 (.I(bm_sa_7_1), .Z(bm_sa[7]));
  CKBD16HVT CLK_SYNC_SKEW_8 (.I(spi_clk_in_5), .Z(spi_clk_in_6));
  INVD8HVT BL1_R_INV_21 (.I(spi_sdo_oe_b_2), .ZN(spi_sdo_oe_b_3));
  CKBD1HVT BUF_MPIN_in_nvcm_boot (.I(nvcm_boot), .Z(nvcm_boot_1));
  CKBD1HVT BUF_MPIN_in_psdi_7 (.I(psdi[7]), .Z(psdi_7_1));
  BUFFD4HVT BL1_BUF80 (.I(Iconfig_top_CLKGEN_clksw2_rst_b_2), .Z(rst_b_1));
  CKBD1HVT BUF_MPIN_in_nvcm_relextspi (.I(nvcm_relextspi), .Z(nvcm_relextspi_1));
  CKBD1HVT BUF_MPIN_in_trst_pad (.I(trst_pad), .Z(trst_pad_1));
  TIELHVT VSS_magmatiecell_15 (.ZN(VSS_magmatienet_15));
  BUFFD8HVT BUF_MPIN_out_data_muxsel1 (.I(data_muxsel1_2), .Z(data_muxsel1));
  BUFFD8HVT BUF_MPIN_out_cm_sdi_u3_1 (.I(cm_sdi_u3_1_1), .Z(cm_sdi_u3[1]));
  CKBD1HVT BUF_MPIN_in_cm_sdo_u2_1 (.I(cm_sdo_u2[1]), .Z(cm_sdo_u2_1_1));
  BUFFD8HVT BUF_MPIN_out_cm_banksel_0 (.I(cm_banksel_0_3), .Z(cm_banksel[0]));
  BUFFD8HVT BUF_MPIN_out_j_tdi (.I(j_tdi_1), .Z(j_tdi));
  NR2D1HVT NR2D1HVT_SPARE_1 (.A1(VSS_magmatienet_24), .A2(VSS_magmatienet_24), 
     .ZN());
  TIELHVT VSS_magmatiecell_1 (.ZN(VSS_magmatienet_1));
  CKBD1HVT BUF_MPIN_in_psdi_1 (.I(psdi[1]), .Z(psdi_1_1));
  NR2D1HVT NR2D1HVT_SPARE_9 (.A1(VSS_magmatienet_30), .A2(VSS_magmatienet_30), 
     .ZN());
  MUX2D0HVT MUX2D0HVT_SPARE_3 (.I0(VSS_magmatienet_12), .I1(VSS_magmatienet_12), 
     .S(VSS_magmatienet_12), .Z());
  INVD2HVT BL1_R_INV_28 (.I(spi_ss_out_b_1), .ZN(spi_ss_out_b_2));
  CKBD1HVT BUF_MPIN_in_psdi_3 (.I(psdi[3]), .Z(psdi_3_1));
  CKBD1HVT BUF_MPIN_in_psdi_5 (.I(psdi[5]), .Z(psdi_5_1));
  NR2D1HVT NR2D1HVT_SPARE_8 (.A1(VSS_magmatienet_5), .A2(VSS_magmatienet_5), 
     .ZN());
  BUFFD8HVT BUF_MPIN_out_cdone_out (.I(cdone_out_2), .Z(cdone_out));
  CKBD2HVT CLK_SYNC_SKEW_6 (.I(spi_clk_in_3), .Z(spi_clk_in_4));
  BUFFD8HVT BUF_MPIN_out_spi_sdo_oe_b (.I(spi_sdo_oe_b_3), .Z(spi_sdo_oe_b));
  BUFFD2HVT BUF_MPIN_in_coldboot_sel_0 (.I(coldboot_sel[0]), 
     .Z(coldboot_sel_0_1));
  BUFFD8HVT BUF_MPIN_out_rst_b (.I(rst_b_1), .Z(rst_b));
  BUFFD8HVT BUF_MPIN_out_smc_podt_rst (.I(smc_podt_rst_2), .Z(smc_podt_rst));
  CKBD16HVT tck_pad_1_L2 (.I(tck_pad_5), .Z(tck_pad_4));
  CKBD12HVT tck_pad_1_L3_1 (.I(tck_pad_4), .Z(tck_pad_3));
  NR2D1HVT NR2D1HVT_SPARE_5 (.A1(VSS_magmatienet_28), .A2(VSS_magmatienet_28), 
     .ZN());
  BUFFD8HVT BUF_MPIN_out_spi_clk_out (.I(spi_clk_out_10), .Z(spi_clk_out));
  TIELHVT VSS_magmatiecell_3 (.ZN(VSS_magmatienet_3));
  INVD4HVT INVD4HVT_SPARE (.I(VSS_magmatienet_17), .ZN());
  INVD4HVT INVD4HVT_SPARE_9 (.I(VSS_magmatienet_31), .ZN());
  BUFFD2HVT BUF_MPIN_in_bschain_sdo (.I(bschain_sdo), .Z(bschain_sdo_1));
  BUFFD4HVT BL1_BUF22 (.I(smc_rprec_1), .Z(smc_rprec_2));
  BUFFD8HVT BUF_MPIN_out_smc_row_inc (.I(smc_row_inc_1), .Z(smc_row_inc));
  BUFFD8HVT BUF_MPIN_out_smc_seq_rst (.I(smc_seq_rst_2), .Z(smc_seq_rst));
  BUFFD4HVT BL1_BUF25 (.I(smc_rwl_en_1), .Z(smc_rwl_en_2));
  CKBD1HVT BUF_MPIN_in_cm_monitor_cell_2 (.I(cm_monitor_cell[2]), 
     .Z(cm_monitor_cell_2_1));
  BUFFD8HVT BUF_MPIN_out_smc_wset_precgnd (.I(smc_wset_precgnd_2), 
     .Z(smc_wset_precgnd));
  BUFFD4HVT BL1_BUF27 (.I(smc_wset_prec_1), .Z(smc_wset_prec_2));
  BUFFD4HVT BL1_BUF28 (.I(smc_wset_precgnd_1), .Z(smc_wset_precgnd_2));
  BUFFD8HVT BUF_MPIN_out_cm_banksel_2 (.I(cm_banksel_2_2), .Z(cm_banksel[2]));
  TIELHVT VSS_magmatiecell_2 (.ZN(VSS_magmatienet_2));
  ND2D1HVT ND2D1HVT_SPARE_4 (.A1(VSS_magmatienet_8), .A2(VSS_magmatienet_8), 
     .ZN());
  TIELHVT VSS_magmatiecell_11 (.ZN(VSS_magmatienet_11));
endmodule

// Entity:config_top Model:config_top Library:L1
module config_top (osc_clk, por_b, rst_b, cnt_podt_out, smc_podt_rst, 
     smc_podt_off, smc_oscoff_b, smc_osc_fsel, gint_hz, gio_hz, gsr, 
     en_8bconfig_b, end_of_startup, nvcm_spi_ss_b, nvcm_spi_sdi, nvcm_spi_sdo, 
     nvcm_spi_sdo_oe_b, nvcm_relextspi, nvcm_boot, smc_load_nvcm_bstream, 
     nvcm_rdy, bp0, creset_b, cdone_in, cdone_out, psdi, psdo, coldboot_sel, 
     boot, warmboot_sel, md_jtag, j_tck, j_tdi, j_tdo, j_rst_b, j_cfg_enable, 
     j_cfg_disable, j_cfg_program, j_cap_dr, j_sft_dr, j_idcode_reg, j_usercode, 
     md_spi_b, spi_ss_in_b, spi_ss_out_b, spi_clk_in, spi_clk_out, spi_sdi, 
     spi_sdo, spi_sdo_oe_b, cm_clk, smc_write, smc_read, smc_seq_rst, 
     cm_banksel, cm_sdi_u0, cm_sdo_u0, cm_sdi_u1, cm_sdo_u1, cm_sdi_u2, 
     cm_sdo_u2, cm_sdi_u3, cm_sdo_u3, smc_rsr_rst, smc_row_inc, smc_wset_prec, 
     smc_wwlwrt_dis, smc_wcram_rst, smc_wset_precgnd, smc_wwlwrt_en, smc_rwl_en, 
     data_muxsel1, smc_wdis_dclk, data_muxsel, smc_rpull_b, smc_rprec, 
     smc_rrst_pullwlen, cm_last_rsr, cm_monitor_cell, bm_clk, bm_banksel, 
     bm_bank_sdi, bm_bank_sdo, bm_sa, bm_sweb, bm_sreb, bm_sclkrw, 
     bm_wdummymux_en, bm_rcapmux_en, bm_init, spi_clk_out_11, osc_clk_2, 
     osc_clk_5, smc_load_nvcm_bstream_4, smc_write_4, spi_clk_in_2, smc_read_4, 
     Iconfig_top_CRAM_SMC_smc_rsr_rst_5, Iconfig_top_CRAM_SMC_smc_rsr_rst_4, 
     smc_seq_rst_3, spi_clk_out_13, tck_pad_8, md_jtag_1, spi_clk_in_6, 
     tck_pad_4, tck_pad_3, osc_clk_8);
  input osc_clk, por_b, cnt_podt_out, nvcm_spi_sdo, nvcm_spi_sdo_oe_b, 
     nvcm_relextspi, nvcm_boot, nvcm_rdy, bp0, creset_b, cdone_in, boot, 
     md_jtag, j_tck, j_tdi, j_rst_b, j_cfg_enable, j_cfg_disable, j_cfg_program, 
     j_cap_dr, j_sft_dr, j_usercode, spi_ss_in_b, spi_clk_in, spi_sdi, 
     cm_last_rsr, spi_clk_out_11, osc_clk_2, osc_clk_5, smc_load_nvcm_bstream_4, 
     smc_write_4, spi_clk_in_2, smc_read_4, Iconfig_top_CRAM_SMC_smc_rsr_rst_5, 
     Iconfig_top_CRAM_SMC_smc_rsr_rst_4, smc_seq_rst_3, tck_pad_8, md_jtag_1, 
     spi_clk_in_6, tck_pad_4, tck_pad_3, osc_clk_8;
  output rst_b, smc_podt_rst, smc_podt_off, smc_oscoff_b, gint_hz, gio_hz, gsr, 
     en_8bconfig_b, end_of_startup, nvcm_spi_ss_b, nvcm_spi_sdi, 
     smc_load_nvcm_bstream, cdone_out, j_tdo, md_spi_b, spi_ss_out_b, 
     spi_clk_out, spi_sdo, spi_sdo_oe_b, cm_clk, smc_write, smc_read, 
     smc_seq_rst, smc_rsr_rst, smc_row_inc, smc_wset_prec, smc_wwlwrt_dis, 
     smc_wcram_rst, smc_wset_precgnd, smc_wwlwrt_en, smc_rwl_en, data_muxsel1, 
     smc_wdis_dclk, data_muxsel, smc_rpull_b, smc_rprec, smc_rrst_pullwlen, 
     bm_clk, bm_sweb, bm_sreb, bm_sclkrw, bm_wdummymux_en, bm_rcapmux_en, 
     bm_init, spi_clk_out_13;
  input [7:1] psdi;
  input [1:0] coldboot_sel;
  input [1:0] warmboot_sel;
  input [31:0] j_idcode_reg;
  input [1:0] cm_sdo_u0;
  input [1:0] cm_sdo_u1;
  input [1:0] cm_sdo_u2;
  input [1:0] cm_sdo_u3;
  input [3:0] cm_monitor_cell;
  input [3:0] bm_bank_sdo;
  output [1:0] smc_osc_fsel;
  output [7:1] psdo;
  output [3:0] cm_banksel;
  output [1:0] cm_sdi_u0;
  output [1:0] cm_sdi_u1;
  output [1:0] cm_sdi_u2;
  output [1:0] cm_sdi_u3;
  output [3:0] bm_banksel;
  output [3:0] bm_bank_sdi;
  output [7:0] bm_sa;
  wire spi_clk_out_1, en_8bconfig_b_1, gint_hz_1, smc_oscoff_b_1, 
     access_nvcm_reg, baddr_0_, baddr_1_, bram_done, bram_rd, bram_reading, 
     bram_wrt, cfg_ld_bstream, cfg_shutdown, cfg_startup, clk_b, 
     cor_en_8bconfig, cor_en_oscclk, cor_security_rddis, cor_security_wrtdis, 
     cram_access_en, cram_clr_done, cram_clr_done_r, cram_done, cram_reading, 
     en_daisychain_cfg, end_of_shutdown, fpga_operation, framelen_0_, 
     framelen_10_, framelen_11_, framelen_12_, framelen_13_, framelen_14_, 
     framelen_15_, framelen_1_, framelen_2_, framelen_3_, framelen_4_, 
     framelen_5_, framelen_6_, framelen_7_, framelen_8_, framelen_9_, 
     framenum_0_, framenum_1_, framenum_2_, framenum_3_, framenum_4_, 
     framenum_5_, framenum_6_, framenum_7_, gwe, j_usercode_tdo, md_spi, 
     reboot_source_nvcm, sample_mode_done, sdi, sdo_0_, sdo_1_, sdo_2_, sdo_3_, 
     sdo_4_, sdo_5_, sdo_6_, sdo_7_, shutdown_req, spi_master_go, 
     spi_ss_out_b_int, start_framenum_0_, start_framenum_1_, start_framenum_2_, 
     start_framenum_3_, start_framenum_4_, start_framenum_5_, start_framenum_6_, 
     start_framenum_7_, startup_req, tm_dis_bram_clk_gating, 
     tm_dis_cram_clk_gating, usercode_reg_0_, usercode_reg_10_, 
     usercode_reg_11_, usercode_reg_12_, usercode_reg_13_, usercode_reg_14_, 
     usercode_reg_15_, usercode_reg_16_, usercode_reg_17_, usercode_reg_18_, 
     usercode_reg_19_, usercode_reg_1_, usercode_reg_20_, usercode_reg_21_, 
     usercode_reg_22_, usercode_reg_23_, usercode_reg_24_, usercode_reg_25_, 
     usercode_reg_26_, usercode_reg_27_, usercode_reg_28_, usercode_reg_29_, 
     usercode_reg_2_, usercode_reg_30_, usercode_reg_31_, usercode_reg_3_, 
     usercode_reg_4_, usercode_reg_5_, usercode_reg_6_, usercode_reg_7_, 
     usercode_reg_8_, usercode_reg_9_, warmboot_req, spi_clk_out_2, 
     spi_clk_out_3, spi_clk_out_4, spi_clk_out_5, spi_clk_out_6, spi_clk_out_7, 
     spi_clk_out_8, spi_clk_out_9, spi_clk_out_12, spi_clk_out_14, osc_clk_4, 
     osc_clk_3, cor_en_8bconfig_1, spi_master_go_1, spi_master_go_2, 
     cfg_ld_bstream_1, sample_mode_done_1, sdi_1, bram_wrt_1, framelen_2_1, 
     framelen_0_1, framelen_6_1, framelen_5_1, framelen_4_1, framelen_7_1, 
     framenum_6_1, framenum_2_1, framelen_3_1, framenum_1_1, framelen_1_1, 
     framenum_5_1, framelen_10_1, framenum_7_1, start_framenum_3_1, 
     framelen_15_1, framenum_3_1, framenum_4_1, framenum_0_1, framelen_13_1, 
     framelen_9_1, framelen_12_1, framelen_8_1, framelen_14_1, framelen_11_1, 
     end_of_shutdown_1, tm_dis_cram_clk_gating_1, tm_dis_cram_clk_gating_2, 
     tm_dis_bram_clk_gating_1, tm_dis_bram_clk_gating_2, bram_reading_1, 
     cram_reading_1, spi_ss_out_b_int_1, usercode_reg_1_1, fpga_operation_1, 
     usercode_reg_6_1, cor_security_rddis_1, cor_en_oscclk_1, 
     start_framenum_1_1, start_framenum_6_1, start_framenum_5_1, 
     start_framenum_0_1, start_framenum_7_1, start_framenum_4_1, 
     start_framenum_2_1, cor_security_wrtdis_1, cram_clr_done_1, 
     cram_clr_done_r_1, tm_dis_bram_clk_gating_3, tm_dis_cram_clk_gating_3, 
     cram_clr_done_r_2, en_8bconfig_b_2, cram_done_1, sample_mode_done_2, 
     shutdown_req_1, sdi_2, cfg_ld_bstream_2, sdi_3, start_framenum_5_2, 
     start_framenum_6_2, start_framenum_7_2, start_framenum_4_2, framelen_9_2, 
     framenum_6_2, framelen_7_2, framelen_4_2, framenum_2_2, cor_en_oscclk_2, 
     start_framenum_1_2, framelen_2_2, framelen_12_2, start_framenum_2_2, 
     framenum_4_2, framenum_1_2, framenum_3_2, framelen_6_2, framelen_8_2, 
     framelen_11_2, framenum_0_2, framelen_5_2, framenum_7_2, framelen_0_2, 
     framelen_10_2, start_framenum_0_2, framenum_5_2, framelen_1_2, 
     framelen_13_2, framelen_14_2, framelen_3_2, spi_master_go_3, framelen_15_2, 
     framelen_7_3, framelen_2_3, framelen_4_3, framelen_9_3, framelen_0_3, 
     framelen_12_3, framelen_1_3, framelen_6_3, framelen_5_3, framelen_3_3, 
     framelen_15_3, framelen_13_3, framelen_10_3, framenum_6_3, framenum_0_3, 
     framenum_4_3, framenum_1_3, framenum_3_3, framenum_2_3, framenum_7_3, 
     framenum_5_3, tm_dis_bram_clk_gating_4, tm_dis_bram_clk_gating_5, 
     tm_dis_cram_clk_gating_4, usercode_reg_25_1, start_framenum_5_3, 
     start_framenum_1_3, framelen_11_3, sample_mode_done_3, startup_req_1, 
     bram_reading_2, spi_ss_out_b_int_2, usercode_reg_16_1, 
     cor_security_rddis_2, en_8bconfig_b_3;
  BUFFD1HVT OPTHOLD_G_136 (.I(framelen_0_), .Z(framelen_0_1));
  BUFFD1HVT OPTHOLD_G_748 (.I(framenum_1_1), .Z(framenum_1_2));
  clkgen CLKGEN (.rst_b(rst_b), .osc_clk(), .cclk(), .tck(), 
     .sample_mode_done(sample_mode_done), .md_spi(md_spi), .md_jtag(md_jtag), 
     .clkout(), .clkout_b(), .sample_mode_done_2(sample_mode_done_2), 
     .spi_clk_in_2(spi_clk_in_2), .spi_clk_out_2(spi_clk_out_1), 
     .tck_pad_2(tck_pad_3), .osc_clk_2(osc_clk_2), 
     .sample_mode_done_1(sample_mode_done_1), .spi_clk_out_14(spi_clk_out_14), 
     .tck_pad_8(tck_pad_8), .osc_clk_8(osc_clk_8), .spi_clk_in_6(spi_clk_in_6), 
     .clk_b_1(clk_b));
  jtag_usercode JTAG_USERCODE (.j_tck(), .j_cap_dr(j_cap_dr), .usercode_reg({
     usercode_reg_31_, usercode_reg_30_, usercode_reg_29_, usercode_reg_28_, 
     usercode_reg_27_, usercode_reg_26_, usercode_reg_25_, usercode_reg_24_, 
     usercode_reg_23_, usercode_reg_22_, usercode_reg_21_, usercode_reg_20_, 
     usercode_reg_19_, usercode_reg_18_, usercode_reg_17_, usercode_reg_16_, 
     usercode_reg_15_, usercode_reg_14_, usercode_reg_13_, usercode_reg_12_, 
     usercode_reg_11_, usercode_reg_10_, usercode_reg_9_, usercode_reg_8_, 
     usercode_reg_7_, usercode_reg_6_, usercode_reg_5_, usercode_reg_4_, 
     usercode_reg_3_, usercode_reg_2_, usercode_reg_1_, usercode_reg_0_}), 
     .j_usercode(j_usercode), .j_sft_dr(j_sft_dr), 
     .j_usercode_tdo(j_usercode_tdo), .tck_pad_3(tck_pad_4));
  cfg_smc CFG_SMC (.clk(), .rst_b(rst_b), .cnt_podt_out(cnt_podt_out), 
     .startup_req(startup_req), .shutdown_req(shutdown_req), 
     .warmboot_req(warmboot_req), .reboot_source_nvcm(reboot_source_nvcm), 
     .end_of_startup(end_of_startup), .end_of_shutdown(end_of_shutdown), 
     .sample_mode_done(sample_mode_done), .md_jtag(md_jtag), .md_spi(md_spi), 
     .spi_ss_in_b(spi_ss_in_b), .cram_clr(smc_seq_rst), .cram_done(cram_done), 
     .cfg_ld_bstream(cfg_ld_bstream), .cfg_startup(cfg_startup), 
     .cfg_shutdown(cfg_shutdown), .cram_access_en(cram_access_en), 
     .cram_clr_done(cram_clr_done), .cram_clr_done_r(cram_clr_done_r), 
     .fpga_operation(fpga_operation), .spi_master_go(spi_master_go), 
     .nvcm_boot(nvcm_boot), .smc_load_nvcm_bstream(smc_load_nvcm_bstream), 
     .nvcm_rdy(nvcm_rdy), .sample_mode_done_3(sample_mode_done_3), 
     .cram_clr_done_1(cram_clr_done_1), .cram_clr_done_r_2(cram_clr_done_r_2), 
     .smc_load_nvcm_bstream_4(smc_load_nvcm_bstream_4), 
     .spi_clk_out_13(spi_clk_out_13), .shutdown_req_1(shutdown_req_1), 
     .end_of_shutdown_1(end_of_shutdown_1), .cram_done_1(cram_done_1), 
     .spi_clk_out_6(spi_clk_out_5), .spi_clk_out_11(spi_clk_out_11));
  cram_smc CRAM_SMC (.clk(), .clk_b(), .rst_b(rst_b), 
     .tm_dis_cram_clk_gating(tm_dis_cram_clk_gating), .cram_wrt(smc_write), 
     .cram_rd(smc_read), .cram_clr(smc_seq_rst), 
     .cor_en_8bconfig(cor_en_8bconfig), .cor_security_rddis(cor_security_rddis), 
     .cor_security_wrtdis(cor_security_wrtdis), .cram_access_en(cram_access_en), 
     .baddr({baddr_1_, baddr_0_}), .flen({framelen_15_, framelen_14_, 
     framelen_13_, framelen_12_, framelen_11_, framelen_10_, framelen_9_, 
     framelen_8_, framelen_7_, framelen_6_, framelen_5_, framelen_4_, 
     framelen_3_, framelen_2_, framelen_1_, framelen_0_}), .fnum({framenum_7_, 
     framenum_6_, framenum_5_, framenum_4_, framenum_3_, framenum_2_, 
     framenum_1_, framenum_0_}), .stwrt_fnum({start_framenum_7_, 
     start_framenum_6_, start_framenum_5_, start_framenum_4_, start_framenum_3_, 
     start_framenum_2_, start_framenum_1_, start_framenum_0_}), 
     .cram_reading(cram_reading), .cram_done(cram_done), .cm_clk(cm_clk), 
     .cm_banksel({cm_banksel[3], cm_banksel[2], cm_banksel[1], cm_banksel[0]}), 
     .smc_rsr_rst(smc_rsr_rst), .smc_row_inc(smc_row_inc), 
     .smc_wset_prec(smc_wset_prec), .smc_wwlwrt_dis(smc_wwlwrt_dis), 
     .smc_wcram_rst(smc_wcram_rst), .smc_wset_precgnd(smc_wset_precgnd), 
     .smc_wwlwrt_en(smc_wwlwrt_en), .smc_rwl_en(smc_rwl_en), 
     .data_muxsel1(data_muxsel1), .smc_wdis_dclk(smc_wdis_dclk), 
     .data_muxsel(data_muxsel), .smc_rpull_b(smc_rpull_b), 
     .smc_rprec(smc_rprec), .smc_rrst_pullwlen(smc_rrst_pullwlen), 
     .cm_last_rsr(cm_last_rsr), .framelen_10_2(framelen_10_2), 
     .framelen_12_2(framelen_12_2), .framelen_13_2(framelen_13_2), 
     .framelen_8_2(framelen_8_2), .framelen_14_2(framelen_14_2), 
     .framelen_9_2(framelen_9_2), .spi_clk_out_12(spi_clk_out_12), 
     .framelen_11_2(framelen_11_2), .framelen_9_3(framelen_9_3), 
     .framelen_15_2(framelen_15_2), .framelen_7_3(framelen_7_3), 
     .framelen_7_2(framelen_7_2), .framelen_12_3(framelen_12_3), 
     .framelen_10_3(framelen_10_3), .framelen_0_3(framelen_0_3), 
     .framelen_1_3(framelen_1_3), .framelen_2_3(framelen_2_3), 
     .framelen_4_2(framelen_4_2), .framelen_3_3(framelen_3_3), 
     .framelen_2_2(framelen_2_2), .framelen_6_3(framelen_6_3), 
     .framelen_6_2(framelen_6_2), .framelen_13_3(framelen_13_3), 
     .framelen_4_3(framelen_4_3), .framelen_5_2(framelen_5_2), 
     .framelen_15_3(framelen_15_3), .framelen_5_3(framelen_5_3), 
     .framelen_1_2(framelen_1_2), .framelen_3_2(framelen_3_2), 
     .framenum_3_3(framenum_3_3), .framelen_0_2(framelen_0_2), 
     .framenum_3_2(framenum_3_2), .framenum_4_2(framenum_4_2), 
     .framenum_4_3(framenum_4_3), .framenum_2_3(framenum_2_3), 
     .framenum_1_3(framenum_1_3), .framenum_2_2(framenum_2_2), 
     .framenum_1_2(framenum_1_2), .framenum_0_2(framenum_0_2), 
     .spi_clk_out_7(spi_clk_out_6), .smc_write_4(smc_write_4), 
     .framenum_0_3(framenum_0_3), .framenum_5_2(framenum_5_2), 
     .framenum_5_3(framenum_5_3), .clk_b_2(clk_b), 
     .start_framenum_0_1(start_framenum_0_1), 
     .start_framenum_1_2(start_framenum_1_2), .framenum_6_2(framenum_6_2), 
     .framenum_7_3(framenum_7_3), .framenum_6_3(framenum_6_3), 
     .framenum_7_2(framenum_7_2), .smc_read_4(smc_read_4), 
     .start_framenum_5_2(start_framenum_5_2), 
     .start_framenum_4_2(start_framenum_4_2), 
     .start_framenum_3_1(start_framenum_3_1), 
     .Iconfig_top_CRAM_SMC_smc_rsr_rst_5(Iconfig_top_CRAM_SMC_smc_rsr_rst_5), 
     .Iconfig_top_CRAM_SMC_smc_rsr_rst_4(Iconfig_top_CRAM_SMC_smc_rsr_rst_4), 
     .start_framenum_2_2(start_framenum_2_2), 
     .start_framenum_6_2(start_framenum_6_2), 
     .start_framenum_7_2(start_framenum_7_2), .smc_seq_rst_3(smc_seq_rst_3), 
     .cram_reading_1(cram_reading_1), 
     .tm_dis_cram_clk_gating_1(tm_dis_cram_clk_gating_1));
  BUFFD1HVT OPTHOLD_G_760 (.I(framenum_5_1), .Z(framenum_5_2));
  BUFFD1HVT OPTHOLD_G_747 (.I(framenum_4_1), .Z(framenum_4_2));
  BUFFD1HVT OPTHOLD_G_844 (.I(framenum_0_), .Z(framenum_0_3));
  BUFFD1HVT OPTHOLD_G_151 (.I(framenum_5_), .Z(framenum_5_1));
  BUFFD1HVT OPTHOLD_G_755 (.I(framenum_7_1), .Z(framenum_7_2));
  BUFFD1HVT OPTHOLD_G_145 (.I(framenum_6_), .Z(framenum_6_1));
  BUFFD1HVT OPTHOLD_G_862 (.I(tm_dis_cram_clk_gating), 
     .Z(tm_dis_cram_clk_gating_4));
  CKBD16HVT spi_clk_out_1_L1_4 (.I(spi_clk_out_13), .Z(spi_clk_out_2));
  BUFFD1HVT OPTHOLD_G_33 (.I(spi_master_go_2), .Z(spi_master_go_1));
  CKBD16HVT spi_clk_out_1_L1_3 (.I(spi_clk_out_13), .Z(spi_clk_out_3));
  BUFFD1HVT OPTHOLD_G_688 (.I(sdi), .Z(sdi_3));
  BUFFD1HVT OPTHOLD_G_1138 (.I(spi_ss_out_b_int), .Z(spi_ss_out_b_int_2));
  BUFFD1HVT OPTHOLD_G_726 (.I(start_framenum_5_1), .Z(start_framenum_5_2));
  BUFFD1HVT OPTHOLD_G_745 (.I(start_framenum_2_), .Z(start_framenum_2_2));
  BUFFD1HVT OPTHOLD_G_843 (.I(framenum_6_), .Z(framenum_6_3));
  BUFFD1HVT OPTHOLD_G_529 (.I(start_framenum_6_2), .Z(start_framenum_6_1));
  BUFFD1HVT OPTHOLD_G_532 (.I(start_framenum_7_2), .Z(start_framenum_7_1));
  BUFFD1HVT OPTHOLD_G_1134 (.I(bram_reading), .Z(bram_reading_2));
  BUFFD1HVT OPTHOLD_G_296 (.I(tm_dis_bram_clk_gating_4), 
     .Z(tm_dis_bram_clk_gating_2));
  BUFFD1HVT OPTHOLD_G_326 (.I(bram_reading_2), .Z(bram_reading_1));
  BUFFD1HVT OPTHOLD_G_295 (.I(tm_dis_bram_clk_gating_3), 
     .Z(tm_dis_bram_clk_gating_1));
  BUFFD1HVT OPTHOLD_G_534 (.I(start_framenum_2_2), .Z(start_framenum_2_1));
  BUFFD1HVT OPTHOLD_G_732 (.I(start_framenum_4_), .Z(start_framenum_4_2));
  BUFFD1HVT OPTHOLD_G_533 (.I(start_framenum_4_2), .Z(start_framenum_4_1));
  BUFFD1HVT OPTHOLD_G_752 (.I(framelen_11_1), .Z(framelen_11_2));
  BUFFD1HVT OPTHOLD_G_161 (.I(framelen_12_), .Z(framelen_12_1));
  BUFFD1HVT OPTHOLD_G_164 (.I(framelen_14_), .Z(framelen_14_1));
  BUFFD1HVT OPTHOLD_G_160 (.I(framelen_9_), .Z(framelen_9_1));
  BUFFD1HVT OPTHOLD_G_790 (.I(framelen_10_), .Z(framelen_10_3));
  BUFFD1HVT OPTHOLD_G_144 (.I(framelen_7_3), .Z(framelen_7_1));
  BUFFD1HVT OPTHOLD_G_784 (.I(framelen_1_), .Z(framelen_1_3));
  BUFFD1HVT OPTHOLD_G_786 (.I(framelen_5_), .Z(framelen_5_3));
  BUFFD1HVT OPTHOLD_G_852 (.I(framenum_5_), .Z(framenum_5_3));
  BUFFD1HVT OPTHOLD_G_850 (.I(framenum_7_), .Z(framenum_7_3));
  BUFFD1HVT OPTHOLD_G_76 (.I(bram_wrt), .Z(bram_wrt_1));
  BUFFD1HVT OPTHOLD_G_678 (.I(cfg_ld_bstream), .Z(cfg_ld_bstream_2));
  BUFFD1HVT OPTHOLD_G_780 (.I(framelen_4_), .Z(framelen_4_3));
  BUFFD1HVT OPTHOLD_G_779 (.I(framelen_2_), .Z(framelen_2_3));
  BUFFD1HVT OPTHOLD_G_148 (.I(framelen_3_), .Z(framelen_3_1));
  BUFFD4HVT BW1_BUF1387 (.I(en_8bconfig_b_1), .Z(en_8bconfig_b));
  BUFFD1HVT OPTHOLD_G_765 (.I(framelen_14_1), .Z(framelen_14_2));
  BUFFD1HVT OPTHOLD_G_620 (.I(en_8bconfig_b_1), .Z(en_8bconfig_b_2));
  BUFFD1HVT OPTHOLD_G_751 (.I(framelen_8_1), .Z(framelen_8_2));
  BUFFD1HVT OPTHOLD_G_781 (.I(framelen_9_), .Z(framelen_9_3));
  BUFFD1HVT OPTHOLD_G_785 (.I(framelen_6_), .Z(framelen_6_3));
  BUFFD1HVT OPTHOLD_G_789 (.I(framelen_13_), .Z(framelen_13_3));
  BUFFD1HVT OPTHOLD_G_915 (.I(framelen_11_), .Z(framelen_11_3));
  BUFFD1HVT OPTHOLD_G_155 (.I(framelen_15_), .Z(framelen_15_1));
  CKBD16HVT spi_clk_out_1_L1_7 (.I(spi_clk_out_14), .Z(spi_clk_out_8));
  BUFFD1HVT OPTHOLD_G_739 (.I(framenum_2_1), .Z(framenum_2_2));
  BUFFD1HVT OPTHOLD_G_753 (.I(framenum_0_1), .Z(framenum_0_2));
  BUFFD1HVT OPTHOLD_G_149 (.I(framenum_1_), .Z(framenum_1_1));
  BUFFD1HVT OPTHOLD_G_756 (.I(framelen_0_1), .Z(framelen_0_2));
  BUFFD1HVT OPTHOLD_G_749 (.I(framenum_3_1), .Z(framenum_3_2));
  BUFFD1HVT OPTHOLD_G_743 (.I(framelen_2_1), .Z(framelen_2_2));
  BUFFD1HVT OPTHOLD_G_143 (.I(framelen_4_3), .Z(framelen_4_1));
  BUFFD1HVT OPTHOLD_G_146 (.I(framenum_2_), .Z(framenum_2_1));
  BUFFD1HVT OPTHOLD_G_769 (.I(framelen_15_1), .Z(framelen_15_2));
  BUFFD1HVT OPTHOLD_G_848 (.I(framenum_2_), .Z(framenum_2_3));
  BUFFD1HVT OPTHOLD_G_733 (.I(framelen_9_1), .Z(framelen_9_2));
  BUFFD1HVT OPTHOLD_G_740 (.I(cor_en_oscclk), .Z(cor_en_oscclk_2));
  BUFFD1HVT OPTHOLD_G_622 (.I(cram_done), .Z(cram_done_1));
  BUFFD1HVT OPTHOLD_G_584 (.I(cram_clr_done_r_1), .Z(cram_clr_done_r_2));
  CKBD16HVT spi_clk_out_1_L0 (.I(spi_clk_out_1), .Z(spi_clk_out_13));
  CKBD16HVT spi_clk_out_1_L1 (.I(spi_clk_out_13), .Z(spi_clk_out_5));
  BUFFD1HVT OPTHOLD_G_355 (.I(usercode_reg_6_), .Z(usercode_reg_6_1));
  BUFFD1HVT OPTHOLD_G_1131 (.I(startup_req), .Z(startup_req_1));
  BUFFD2HVT OPTHOLD_G_918 (.I(sample_mode_done_1), .Z(sample_mode_done_3));
  BUFFD1HVT OPTHOLD_G_768 (.I(spi_master_go_1), .Z(spi_master_go_3));
  BUFFD1HVT OPTHOLD_G_646 (.I(shutdown_req), .Z(shutdown_req_1));
  CKBD16HVT spi_clk_out_1_L1_6 (.I(spi_clk_out_14), .Z(spi_clk_out_4));
  CKBD16HVT spi_clk_out_1_L1_9 (.I(spi_clk_out_14), .Z(spi_clk_out_7));
  startup_shutdown STARTUP_SHUTDOWN (.clk(), .rst_b(rst_b), 
     .startup_req(startup_req), .shutdown_req(shutdown_req), 
     .cor_en_oscclk(cor_en_oscclk), .warmboot_req(warmboot_req), 
     .smc_oscoff_b(smc_oscoff_b_1), .gint_hz(gint_hz_1), .gio_hz(gio_hz), 
     .gwe(gwe), .gsr(gsr), .end_of_startup(end_of_startup), 
     .end_of_shutdown(end_of_shutdown), .cdone_in(cdone_in), 
     .cdone_out(cdone_out), .spi_clk_out_11(spi_clk_out_11), 
     .cor_en_oscclk_1(cor_en_oscclk_1), .shutdown_req_1(shutdown_req_1), 
     .startup_req_1(startup_req_1));
  BUFFD1HVT OPTHOLD_G_337 (.I(spi_ss_out_b_int_2), .Z(spi_ss_out_b_int_1));
  bram_smc BRAM_SMC (.clk(), .clk_b(), .rst_b(rst_b), 
     .tm_dis_bram_clk_gating(tm_dis_bram_clk_gating), .bram_wrt(bram_wrt), 
     .bram_rd(bram_rd), .cor_en_8bconfig(cor_en_8bconfig), 
     .cor_security_rddis(cor_security_rddis), 
     .cor_security_wrtdis(cor_security_wrtdis), .gwe(gwe), 
     .bram_access_en(cfg_ld_bstream), .baddr({baddr_1_, baddr_0_}), .flen({
     framelen_15_, framelen_14_, framelen_13_, framelen_12_, framelen_11_, 
     framelen_10_, framelen_9_, framelen_8_, framelen_7_, framelen_6_, 
     framelen_5_, framelen_4_, framelen_3_, framelen_2_, framelen_1_, 
     framelen_0_}), .fnum({framenum_7_, framenum_6_, framenum_5_, framenum_4_, 
     framenum_3_, framenum_2_, framenum_1_, framenum_0_}), .start_fnum({
     start_framenum_7_, start_framenum_6_, start_framenum_5_, start_framenum_4_, 
     start_framenum_3_, start_framenum_2_, start_framenum_1_, start_framenum_0_}), 
     .bram_reading(bram_reading), .bram_done(bram_done), .bm_clk(bm_clk), 
     .bm_banksel({bm_banksel[3], bm_banksel[2], bm_banksel[1], bm_banksel[0]}), 
     .bm_sa({bm_sa[7], bm_sa[6], bm_sa[5], bm_sa[4], bm_sa[3], bm_sa[2], 
     bm_sa[1], bm_sa[0]}), .bm_sweb(bm_sweb), .bm_sreb(bm_sreb), 
     .bm_sclkrw(bm_sclkrw), .bm_wdummymux_en(bm_wdummymux_en), 
     .bm_rcapmux_en(bm_rcapmux_en), .bm_init(bm_init), 
     .framelen_11_2(framelen_11_2), .framelen_14_2(framelen_14_2), 
     .framelen_13_2(framelen_13_2), .framelen_12_2(framelen_12_2), 
     .framelen_9_2(framelen_9_2), .framelen_10_2(framelen_10_2), 
     .framelen_5_2(framelen_5_2), .framelen_15_2(framelen_15_2), 
     .framelen_8_2(framelen_8_2), .framelen_7_2(framelen_7_2), 
     .framelen_0_2(framelen_0_2), .spi_clk_out_13(spi_clk_out_12), 
     .spi_clk_out_12(spi_clk_out_9), .framelen_6_2(framelen_6_2), 
     .framelen_3_2(framelen_3_2), .framelen_1_2(framelen_1_2), 
     .framelen_4_2(framelen_4_2), .framelen_2_2(framelen_2_2), 
     .framenum_2_2(framenum_2_2), .framenum_3_2(framenum_3_2), 
     .framenum_4_2(framenum_4_2), .framenum_0_2(framenum_0_2), 
     .bram_wrt_1(bram_wrt_1), .framenum_1_2(framenum_1_2), 
     .framenum_5_2(framenum_5_2), .framenum_7_2(framenum_7_2), 
     .framenum_6_2(framenum_6_2), .bram_reading_1(bram_reading_1), 
     .cfg_ld_bstream_2(cfg_ld_bstream_2), 
     .start_framenum_0_2(start_framenum_0_2), 
     .start_framenum_1_2(start_framenum_1_2), 
     .start_framenum_6_1(start_framenum_6_1), 
     .start_framenum_7_1(start_framenum_7_1), 
     .start_framenum_5_2(start_framenum_5_2), 
     .start_framenum_3_1(start_framenum_3_1), 
     .start_framenum_4_1(start_framenum_4_1), 
     .start_framenum_2_1(start_framenum_2_1), 
     .tm_dis_bram_clk_gating_1(tm_dis_bram_clk_gating_1), .clk_b_2(clk_b), 
     .spi_clk_out_10(spi_clk_out_8), .spi_clk_out_7(spi_clk_out_6), 
     .spi_clk_out_5(spi_clk_out_4));
  sdiomux SDIOMUX (.clk(), .clk_b(), .rst_b(rst_b), .md_spi(md_spi), 
     .md_jtag(md_jtag), .en_8bconfig_b(en_8bconfig_b_1), 
     .en_daisychain_cfg(en_daisychain_cfg), .sample_mode_done(sample_mode_done), 
     .spi_sdo_oe_b(spi_sdo_oe_b), .cram_clr_done(cram_clr_done), 
     .cram_clr_done_r(cram_clr_done_r), .j_tdi(j_tdi), .j_tdo(j_tdo), 
     .j_usercode(j_usercode), .j_usercode_tdo(j_usercode_tdo), 
     .md_spi_b(md_spi_b), .spi_ss_in_b(spi_ss_in_b), 
     .spi_ss_out_b(spi_ss_out_b), .spi_ss_out_b_int(spi_ss_out_b_int), 
     .spi_sdi(spi_sdi), .spi_sdo(spi_sdo), .sdi(sdi), .sdo({sdo_7_, sdo_6_, 
     sdo_5_, sdo_4_, sdo_3_, sdo_2_, sdo_1_, sdo_0_}), .bm_bank_sdi({
     bm_bank_sdi[3], bm_bank_sdi[2], bm_bank_sdi[1], bm_bank_sdi[0]}), 
     .cm_sdi_u0({cm_sdi_u0[1], cm_sdi_u0[0]}), .cm_sdi_u1({cm_sdi_u1[1], 
     cm_sdi_u1[0]}), .cm_sdi_u2({cm_sdi_u2[1], cm_sdi_u2[0]}), .cm_sdi_u3({
     cm_sdi_u3[1], cm_sdi_u3[0]}), .psdi({psdi[7], psdi[6], psdi[5], psdi[4], 
     psdi[3], psdi[2], psdi[1]}), .psdo({psdo[7], psdo[6], psdo[5], psdo[4], 
     psdo[3], psdo[2], psdo[1]}), .access_nvcm_reg(access_nvcm_reg), 
     .smc_load_nvcm_bstream(smc_load_nvcm_bstream), 
     .nvcm_spi_ss_b(nvcm_spi_ss_b), .nvcm_spi_sdi(nvcm_spi_sdi), 
     .nvcm_spi_sdo(nvcm_spi_sdo), .nvcm_spi_sdo_oe_b(nvcm_spi_sdo_oe_b), 
     .en_8bconfig_b_3(en_8bconfig_b_3), .clk_b_2(clk_b), 
     .en_8bconfig_b_2(en_8bconfig_b_2), .spi_clk_out_10(spi_clk_out_9), 
     .spi_clk_out_8(spi_clk_out_7));
  bstream_smc BSTREAM_SMC (.clk(), .clk_b(), .rst_b(rst_b), .md_spi(md_spi), 
     .smc_osc_fsel({smc_osc_fsel[1], smc_osc_fsel[0]}), .sdi(sdi), .sdo({sdo_7_, 
     sdo_6_, sdo_5_, sdo_4_, sdo_3_, sdo_2_, sdo_1_, sdo_0_}), 
     .spi_ss_out_b_int(spi_ss_out_b_int), .coldboot_sel({coldboot_sel[1], 
     coldboot_sel[0]}), .boot(boot), .warmboot_sel({warmboot_sel[1], 
     warmboot_sel[0]}), .cfg_ld_bstream(cfg_ld_bstream), 
     .cfg_startup(cfg_startup), .cfg_shutdown(cfg_shutdown), 
     .spi_master_go(spi_master_go), .fpga_operation(fpga_operation), 
     .nvcm_relextspi(nvcm_relextspi), .access_nvcm_reg(access_nvcm_reg), 
     .smc_load_nvcm_bstream(smc_load_nvcm_bstream), .bp0(bp0), 
     .md_jtag(md_jtag), .j_rst_b(j_rst_b), .j_cfg_enable(j_cfg_enable), 
     .j_cfg_disable(j_cfg_disable), .j_cfg_program(j_cfg_program), 
     .j_sft_dr(j_sft_dr), .j_idcode_reg({j_idcode_reg[31], j_idcode_reg[30], 
     j_idcode_reg[29], j_idcode_reg[28], j_idcode_reg[27], j_idcode_reg[26], 
     j_idcode_reg[25], j_idcode_reg[24], j_idcode_reg[23], j_idcode_reg[22], 
     j_idcode_reg[21], j_idcode_reg[20], j_idcode_reg[19], j_idcode_reg[18], 
     j_idcode_reg[17], j_idcode_reg[16], j_idcode_reg[15], j_idcode_reg[14], 
     j_idcode_reg[13], j_idcode_reg[12], j_idcode_reg[11], j_idcode_reg[10], 
     j_idcode_reg[9], j_idcode_reg[8], j_idcode_reg[7], j_idcode_reg[6], 
     j_idcode_reg[5], j_idcode_reg[4], j_idcode_reg[3], j_idcode_reg[2], 
     j_idcode_reg[1], j_idcode_reg[0]}), .usercode_reg({usercode_reg_31_, 
     usercode_reg_30_, usercode_reg_29_, usercode_reg_28_, usercode_reg_27_, 
     usercode_reg_26_, usercode_reg_25_, usercode_reg_24_, usercode_reg_23_, 
     usercode_reg_22_, usercode_reg_21_, usercode_reg_20_, usercode_reg_19_, 
     usercode_reg_18_, usercode_reg_17_, usercode_reg_16_, usercode_reg_15_, 
     usercode_reg_14_, usercode_reg_13_, usercode_reg_12_, usercode_reg_11_, 
     usercode_reg_10_, usercode_reg_9_, usercode_reg_8_, usercode_reg_7_, 
     usercode_reg_6_, usercode_reg_5_, usercode_reg_4_, usercode_reg_3_, 
     usercode_reg_2_, usercode_reg_1_, usercode_reg_0_}), 
     .cnt_podt_out(cnt_podt_out), .smc_podt_rst(smc_podt_rst), 
     .smc_podt_off(smc_podt_off), .smc_oscoff_b(smc_oscoff_b_1), 
     .gint_hz(gint_hz_1), .gio_hz(gio_hz), .gwe(gwe), .cdone_in(cdone_in), 
     .cdone_out(cdone_out), .cm_monitor_cell({cm_monitor_cell[3], 
     cm_monitor_cell[2], cm_monitor_cell[1], cm_monitor_cell[0]}), 
     .startup_req(startup_req), .shutdown_req(shutdown_req), 
     .cor_security_rddis(cor_security_rddis), 
     .cor_security_wrtdis(cor_security_wrtdis), .cor_en_oscclk(cor_en_oscclk), 
     .warmboot_req(warmboot_req), .reboot_source_nvcm(reboot_source_nvcm), 
     .cor_en_8bconfig(cor_en_8bconfig), .en_8bconfig_b(en_8bconfig_b_1), 
     .en_daisychain_cfg(en_daisychain_cfg), .baddr({baddr_1_, baddr_0_}), 
     .framelen({framelen_15_, framelen_14_, framelen_13_, framelen_12_, 
     framelen_11_, framelen_10_, framelen_9_, framelen_8_, framelen_7_, 
     framelen_6_, framelen_5_, framelen_4_, framelen_3_, framelen_2_, 
     framelen_1_, framelen_0_}), .framenum({framenum_7_, framenum_6_, framenum_5_, 
     framenum_4_, framenum_3_, framenum_2_, framenum_1_, framenum_0_}), 
     .start_framenum({start_framenum_7_, start_framenum_6_, start_framenum_5_, 
     start_framenum_4_, start_framenum_3_, start_framenum_2_, start_framenum_1_, 
     start_framenum_0_}), .tm_dis_cram_clk_gating(tm_dis_cram_clk_gating), 
     .cram_wrt(smc_write), .cram_rd(smc_read), .cm_sdo_u0({cm_sdo_u0[1], 
     cm_sdo_u0[0]}), .cm_sdo_u1({cm_sdo_u1[1], cm_sdo_u1[0]}), .cm_sdo_u2({
     cm_sdo_u2[1], cm_sdo_u2[0]}), .cm_sdo_u3({cm_sdo_u3[1], cm_sdo_u3[0]}), 
     .cram_reading(cram_reading), .cram_done(cram_done), 
     .tm_dis_bram_clk_gating(tm_dis_bram_clk_gating), .bram_wrt(bram_wrt), 
     .bram_rd(bram_rd), .bm_bank_sdo({bm_bank_sdo[3], bm_bank_sdo[2], 
     bm_bank_sdo[1], bm_bank_sdo[0]}), .bram_reading(bram_reading), 
     .bram_done(bram_done), .spi_clk_out_15(spi_clk_out_5), 
     .spi_clk_out_18(spi_clk_out_9), .sdi_2(sdi_2), 
     .cor_security_wrtdis_1(cor_security_wrtdis_1), 
     .usercode_reg_25_1(usercode_reg_25_1), 
     .cor_security_rddis_1(cor_security_rddis_1), .clk_b_2(clk_b), 
     .spi_clk_out_16(spi_clk_out_7), .spi_clk_out_14(spi_clk_out_4), 
     .fpga_operation_1(fpga_operation_1), .cor_en_oscclk_2(cor_en_oscclk_2), 
     .cfg_ld_bstream_1(cfg_ld_bstream_1), .spi_master_go_3(spi_master_go_3), 
     .spi_ss_out_b_int_1(spi_ss_out_b_int_1), .spi_clk_out_12(spi_clk_out_3), 
     .spi_clk_out_19(spi_clk_out_11), .spi_clk_out_20(spi_clk_out_12), 
     .spi_clk_out_17(spi_clk_out_8), .usercode_reg_16_1(usercode_reg_16_1), 
     .usercode_reg_6_1(usercode_reg_6_1), .usercode_reg_1_1(usercode_reg_1_1), 
     .spi_clk_out_6(spi_clk_out_2), .cor_en_8bconfig_1(cor_en_8bconfig_1), 
     .md_jtag_1(md_jtag_1), .spi_clk_out_21(spi_clk_out_14));
  rstbgen RSTBGEN (.clk(), .por_b(por_b), .creset_b(creset_b), .rst_b(rst_b), 
     .osc_clk_4(osc_clk_4));
  BUFFD1HVT OPTHOLD_G_845 (.I(framenum_4_), .Z(framenum_4_3));
  BUFFD1HVT OPTHOLD_G_903 (.I(start_framenum_1_), .Z(start_framenum_1_3));
  BUFFD1HVT OPTHOLD_G_1141 (.I(cor_security_rddis), .Z(cor_security_rddis_2));
  BUFFD1HVT OPTHOLD_G_846 (.I(framenum_1_), .Z(framenum_1_3));
  BUFFD1HVT OPTHOLD_G_528 (.I(start_framenum_1_3), .Z(start_framenum_1_1));
  BUFFD1HVT OPTHOLD_G_153 (.I(framenum_7_), .Z(framenum_7_1));
  BUFFD1HVT OPTHOLD_G_566 (.I(tm_dis_cram_clk_gating_4), 
     .Z(tm_dis_cram_clk_gating_3));
  BUFFD1HVT OPTHOLD_G_859 (.I(tm_dis_bram_clk_gating_2), 
     .Z(tm_dis_bram_clk_gating_5));
  BUFFD1HVT OPTHOLD_G_72 (.I(sdi_3), .Z(sdi_1));
  BUFFD1HVT OPTHOLD_G_344 (.I(fpga_operation), .Z(fpga_operation_1));
  BUFFD1HVT OPTHOLD_G_18 (.I(cor_en_8bconfig), .Z(cor_en_8bconfig_1));
  BUFFD4HVT BW1_BUF764 (.I(smc_oscoff_b_1), .Z(smc_oscoff_b));
  BUFFD4HVT BW1_BUF752 (.I(gint_hz_1), .Z(gint_hz));
  BUFFD1HVT OPTHOLD_G_741 (.I(start_framenum_1_1), .Z(start_framenum_1_2));
  BUFFD1HVT OPTHOLD_G_154 (.I(start_framenum_3_), .Z(start_framenum_3_1));
  BUFFD1HVT OPTHOLD_G_899 (.I(start_framenum_5_), .Z(start_framenum_5_3));
  CKBD16HVT spi_clk_out_1_L1_2 (.I(spi_clk_out_13), .Z(spi_clk_out_12));
  BUFFD1HVT OPTHOLD_G_730 (.I(start_framenum_7_), .Z(start_framenum_7_2));
  BUFFD1HVT OPTHOLD_G_530 (.I(start_framenum_5_3), .Z(start_framenum_5_1));
  BUFFD1HVT OPTHOLD_G_294 (.I(tm_dis_cram_clk_gating_3), 
     .Z(tm_dis_cram_clk_gating_2));
  BUFFD1HVT OPTHOLD_G_330 (.I(cram_reading), .Z(cram_reading_1));
  BUFFD1HVT OPTHOLD_G_293 (.I(tm_dis_cram_clk_gating_2), 
     .Z(tm_dis_cram_clk_gating_1));
  BUFFD1HVT OPTHOLD_G_563 (.I(tm_dis_bram_clk_gating_5), 
     .Z(tm_dis_bram_clk_gating_3));
  BUFFD1HVT OPTHOLD_G_858 (.I(tm_dis_bram_clk_gating), 
     .Z(tm_dis_bram_clk_gating_4));
  BUFFD1HVT OPTHOLD_G_728 (.I(start_framenum_6_), .Z(start_framenum_6_2));
  BUFFD1HVT OPTHOLD_G_165 (.I(framelen_11_3), .Z(framelen_11_1));
  BUFFD1HVT OPTHOLD_G_162 (.I(framelen_8_), .Z(framelen_8_1));
  BUFFD1HVT OPTHOLD_G_787 (.I(framelen_3_), .Z(framelen_3_3));
  BUFFD1HVT OPTHOLD_G_152 (.I(framelen_10_3), .Z(framelen_10_1));
  BUFFD1HVT OPTHOLD_G_757 (.I(framelen_10_1), .Z(framelen_10_2));
  BUFFD1HVT OPTHOLD_G_778 (.I(framelen_7_), .Z(framelen_7_3));
  BUFFD1HVT OPTHOLD_G_744 (.I(framelen_12_1), .Z(framelen_12_2));
  BUFFD1HVT OPTHOLD_G_782 (.I(framelen_0_), .Z(framelen_0_3));
  BUFFD1HVT OPTHOLD_G_734 (.I(framenum_6_1), .Z(framenum_6_2));
  BUFFD1HVT OPTHOLD_G_531 (.I(start_framenum_0_2), .Z(start_framenum_0_1));
  BUFFD1HVT OPTHOLD_G_759 (.I(start_framenum_0_), .Z(start_framenum_0_2));
  BUFFD1HVT OPTHOLD_G_890 (.I(usercode_reg_25_), .Z(usercode_reg_25_1));
  BUFFD1HVT OPTHOLD_G_847 (.I(framenum_3_), .Z(framenum_3_3));
  BUFFD1HVT OPTHOLD_G_142 (.I(framelen_5_), .Z(framelen_5_1));
  BUFFD1HVT OPTHOLD_G_783 (.I(framelen_12_), .Z(framelen_12_3));
  BUFFD1HVT OPTHOLD_G_677 (.I(sdi_1), .Z(sdi_2));
  CKBD4HVT osc_clk_1_L1 (.I(osc_clk_5), .Z(osc_clk_3));
  BUFFD1HVT OPTHOLD_F_6 (.I(en_8bconfig_b_1), .Z(en_8bconfig_b_3));
  BUFFD1HVT OPTHOLD_G_644 (.I(sample_mode_done), .Z(sample_mode_done_2));
  BUFFD1HVT OPTHOLD_G_764 (.I(framelen_13_1), .Z(framelen_13_2));
  BUFFD1HVT OPTHOLD_G_159 (.I(framelen_13_), .Z(framelen_13_1));
  BUFFD1HVT OPTHOLD_G_754 (.I(framelen_5_1), .Z(framelen_5_2));
  BUFFD1HVT OPTHOLD_G_138 (.I(framelen_6_), .Z(framelen_6_1));
  BUFFD1HVT OPTHOLD_G_788 (.I(framelen_15_), .Z(framelen_15_3));
  BUFFD1HVT OPTHOLD_G_535 (.I(cor_security_wrtdis), .Z(cor_security_wrtdis_1));
  CKBD16HVT spi_clk_out_1_L1_8 (.I(spi_clk_out_14), .Z(spi_clk_out_9));
  BUFFD1HVT OPTHOLD_G_150 (.I(framelen_1_), .Z(framelen_1_1));
  BUFFD1HVT OPTHOLD_G_157 (.I(framenum_4_), .Z(framenum_4_1));
  BUFFD1HVT OPTHOLD_G_762 (.I(framelen_1_1), .Z(framelen_1_2));
  BUFFD1HVT OPTHOLD_G_766 (.I(framelen_3_1), .Z(framelen_3_2));
  BUFFD1HVT OPTHOLD_G_156 (.I(framenum_3_), .Z(framenum_3_1));
  BUFFD1HVT OPTHOLD_G_133 (.I(framelen_2_), .Z(framelen_2_1));
  CKBD16HVT spi_clk_out_1_L1_5 (.I(spi_clk_out_14), .Z(spi_clk_out_6));
  BUFFD1HVT OPTHOLD_G_750 (.I(framelen_6_1), .Z(framelen_6_2));
  BUFFD1HVT OPTHOLD_G_737 (.I(framelen_7_1), .Z(framelen_7_2));
  BUFFD1HVT OPTHOLD_G_738 (.I(framelen_4_1), .Z(framelen_4_2));
  BUFFD1HVT OPTHOLD_G_338 (.I(usercode_reg_1_), .Z(usercode_reg_1_1));
  BUFFD1HVT OPTHOLD_G_543 (.I(cram_clr_done), .Z(cram_clr_done_1));
  BUFFD1HVT OPTHOLD_G_544 (.I(cram_clr_done_r), .Z(cram_clr_done_r_1));
  BUFFD1HVT OPTHOLD_G_524 (.I(cor_en_oscclk_2), .Z(cor_en_oscclk_1));
  BUFFD1HVT OPTHOLD_G_58 (.I(cfg_ld_bstream_2), .Z(cfg_ld_bstream_1));
  BUFFD1HVT OPTHOLD_G_1139 (.I(usercode_reg_16_), .Z(usercode_reg_16_1));
  BUFFD1HVT OPTHOLD_G_34 (.I(spi_master_go), .Z(spi_master_go_2));
  CKBD1HVT osc_clk_1_L2 (.I(osc_clk_3), .Z(osc_clk_4));
  BUFFD1HVT OPTHOLD_G_158 (.I(framenum_0_), .Z(framenum_0_1));
  BUFFD1HVT OPTHOLD_G_363 (.I(cor_security_rddis_2), .Z(cor_security_rddis_1));
  BUFFD1HVT OPTHOLD_G_173 (.I(end_of_shutdown), .Z(end_of_shutdown_1));
  CKBD16HVT spi_clk_out_1_L0_1 (.I(spi_clk_out_1), .Z(spi_clk_out_14));
endmodule

// Entity:bram_smc Model:bram_smc Library:L1
module bram_smc (clk, clk_b, rst_b, tm_dis_bram_clk_gating, bram_wrt, bram_rd, 
     cor_en_8bconfig, cor_security_rddis, cor_security_wrtdis, gwe, 
     bram_access_en, baddr, flen, fnum, start_fnum, bram_reading, bram_done, 
     bm_clk, bm_banksel, bm_sa, bm_sweb, bm_sreb, bm_sclkrw, bm_wdummymux_en, 
     bm_rcapmux_en, bm_init, framelen_11_2, framelen_14_2, framelen_13_2, 
     framelen_12_2, framelen_9_2, framelen_10_2, framelen_5_2, framelen_15_2, 
     framelen_8_2, framelen_7_2, framelen_0_2, spi_clk_out_13, spi_clk_out_12, 
     framelen_6_2, framelen_3_2, framelen_1_2, framelen_4_2, framelen_2_2, 
     framenum_2_2, framenum_3_2, framenum_4_2, framenum_0_2, bram_wrt_1, 
     framenum_1_2, framenum_5_2, framenum_7_2, framenum_6_2, bram_reading_1, 
     cfg_ld_bstream_2, start_framenum_0_2, start_framenum_1_2, 
     start_framenum_6_1, start_framenum_7_1, start_framenum_5_2, 
     start_framenum_3_1, start_framenum_4_1, start_framenum_2_1, 
     tm_dis_bram_clk_gating_1, clk_b_2, spi_clk_out_10, spi_clk_out_7, 
     spi_clk_out_5);
  input clk, clk_b, rst_b, tm_dis_bram_clk_gating, bram_wrt, bram_rd, 
     cor_en_8bconfig, cor_security_rddis, cor_security_wrtdis, gwe, 
     bram_access_en, framelen_11_2, framelen_14_2, framelen_13_2, framelen_12_2, 
     framelen_9_2, framelen_10_2, framelen_5_2, framelen_15_2, framelen_8_2, 
     framelen_7_2, framelen_0_2, spi_clk_out_13, spi_clk_out_12, framelen_6_2, 
     framelen_3_2, framelen_1_2, framelen_4_2, framelen_2_2, framenum_2_2, 
     framenum_3_2, framenum_4_2, framenum_0_2, bram_wrt_1, framenum_1_2, 
     framenum_5_2, framenum_7_2, framenum_6_2, bram_reading_1, cfg_ld_bstream_2, 
     start_framenum_0_2, start_framenum_1_2, start_framenum_6_1, 
     start_framenum_7_1, start_framenum_5_2, start_framenum_3_1, 
     start_framenum_4_1, start_framenum_2_1, tm_dis_bram_clk_gating_1, clk_b_2, 
     spi_clk_out_10, spi_clk_out_7, spi_clk_out_5;
  output bram_reading, bram_done, bm_clk, bm_sweb, bm_sreb, bm_sclkrw, 
     bm_wdummymux_en, bm_rcapmux_en, bm_init;
  input [1:0] baddr;
  input [15:0] flen;
  input [7:0] fnum;
  input [7:0] start_fnum;
  output [3:0] bm_banksel;
  output [7:0] bm_sa;
  wire bm_sa634_0, bm_sa634_1, bm_sa634_2, bm_sa634_3, bm_sa634_4, bm_sa634_5, 
     bm_sa634_6, bm_sa634_7, bm_sa636_0, bm_sa636_1, bm_sa636_2, bm_sa636_3, 
     bm_sa636_4, bm_sa636_5, bm_sa636_6, bm_sa636_7, bm_sa_Q657_1, bm_sclkrw754, 
     bm_sweb700, bram_clk_en_i, bram_done460, bram_reading_int, 
     bram_reading_int_d1, bram_reading_int_d2, bram_reading_int_d3, 
     dummycnt245_0, dummycnt245_1, dummycnt245_2, dummycnt245_3, dummycnt247_0, 
     dummycnt247_2, dummycnt247_3, dummycnt_0, dummycnt_1, flencnt322_0, 
     flencnt322_1, flencnt322_10, flencnt322_11, flencnt322_12, flencnt322_13, 
     flencnt322_14, flencnt322_15, flencnt322_2, flencnt322_3, flencnt322_4, 
     flencnt322_5, flencnt322_6, flencnt322_7, flencnt322_8, flencnt322_9, 
     flencnt323_0, flencnt323_1, flencnt323_10, flencnt323_11, flencnt323_12, 
     flencnt323_13, flencnt323_14, flencnt323_15, flencnt323_2, flencnt323_3, 
     flencnt323_4, flencnt323_5, flencnt323_6, flencnt323_7, flencnt323_8, 
     flencnt323_9, flencnt_0_, flencnt_10_, flencnt_11_, flencnt_12_, 
     flencnt_13_, flencnt_14_, flencnt_15_, flencnt_1_, flencnt_2_, flencnt_3_, 
     flencnt_4_, flencnt_5_, flencnt_6_, flencnt_7_, flencnt_8_, flencnt_9_, 
     fnumcnt398_0, fnumcnt398_1, fnumcnt398_2, fnumcnt398_3, fnumcnt398_4, 
     fnumcnt398_5, fnumcnt398_6, fnumcnt398_7, fnumcnt400_0, fnumcnt400_1, 
     fnumcnt400_2, fnumcnt400_3, fnumcnt400_4, fnumcnt400_5, fnumcnt400_6, 
     fnumcnt400_7, fnumcnt_0_, fnumcnt_1_, fnumcnt_2_, fnumcnt_3_, fnumcnt_4_, 
     fnumcnt_5_, fnumcnt_6_, fnumcnt_7_, n1000, n1006, n1008, n1012, n1014, 
     n1016, n1018, n1020, n1023, n1025, n1026, n1027, n1028, n1029, n1038, 
     n1039, n1040, n1042, n1044, n1045, n1046, n1047, n1048, n1050, n1052, 
     n1053, n1054, n1055, n1056, n1057, n1060, n1061, n1062, n1063, n1065, 
     n1066, n1067, n1068, n1070, n1071, n1072, n1073, n1074, n1075, n1076, 
     n1077, bm_sreb_1, n246_0, n635_0, n960, n961, n962, n963, n964, n965, n966, 
     n967, n968, n969, n970, n971, n972, n973, n974, n975, n976, n977, n978, 
     n979, n980, n981, n982, n983, n984, n986, n987, n988, n989, n990, n991, 
     n992, n993, n994, n995, n996, n998, n999, n_632, n_644, next_0_, next_1_, 
     state_0_, state_1_, U466_N3, U364_N3, U465_N5, U457_N3, bram_wrt_3, 
     bram_rd_1, n988_1, n1040_1, n993_1, n994_1, baddr_0_1, rst_b_1, rst_b_2, 
     n994_2, n635_1, dummycnt_2, dummycnt_3, state_1_1, state_0_1, 
     dummycnt247_1, flencnt_1_1, flencnt_0_1, bram_reading_int_d3_1, 
     bram_reading_int_d3_2, bram_reading_int_d2_1, bram_reading_int_d2_2, 
     bram_reading_int_d2_3, bram_reading_int_d1_1, bram_reading_int_d1_2, 
     bram_reading_int_1, bram_reading_int_2, bram_reading_int_3, bm_sreb_2, 
     bram_rd_2, U466_N3_1, bm_sclkrw754_1, next_0_1, bram_done460_1, next_1_1, 
     dummycnt245_4, fnumcnt398_8, fnumcnt398_9, fnumcnt398_10, fnumcnt398_11, 
     fnumcnt398_12, fnumcnt398_13, bm_sa634_8, fnumcnt398_14, fnumcnt398_15, 
     bm_sa634_9, bm_sa634_10, bm_sa634_11, bm_sa634_12, bm_sa634_13, 
     bm_sa634_14, bm_sa634_15, bm_sweb700_1, flencnt322_16, flencnt322_17, 
     flencnt322_18, flencnt322_19, flencnt322_20, flencnt322_21, flencnt322_22, 
     flencnt322_23, flencnt322_24, flencnt322_25, flencnt322_26, flencnt322_27, 
     flencnt322_28, flencnt322_29, flencnt322_30, flencnt322_31, 
     bram_reading_int_d3_3, bram_reading_int_d3_4, bram_reading_int_d1_3, 
     bram_reading_int_d2_4, bram_reading_int_4, n635_2, n1040_2, n1054_1, 
     n1045_1, state_1_2, dummycnt247_4, n991_1, flencnt_1_2, flencnt_0_2, 
     bm_sreb_3, bm_sreb_4, bram_reading_int_d1_4, bram_reading_int_d1_5, 
     bram_rd_3, bram_rd_4, bram_reading_int_d2_5, bram_wrt_2, 
     bram_reading_int_d3_5, bram_reading_int_5, U457_N3_1, bm_sweb700_2, 
     bram_wrt_4, bm_sclkrw754_2, bram_clk_en_i_1, next_1_2, dummycnt245_5, 
     dummycnt245_6, bm_sa634_16, dummycnt245_7, bm_sa634_17, bm_sa634_18, 
     bm_sa634_19, fnumcnt398_16, bm_sa634_20, bm_sa634_21, next_0_2, 
     fnumcnt398_17, fnumcnt398_18, fnumcnt398_19, fnumcnt398_20, bm_sa634_22, 
     bm_sa634_23, fnumcnt398_21, fnumcnt398_22, fnumcnt398_23, fnumcnt398_24, 
     bram_done460_2, bram_done460_3, dummycnt245_8, dummycnt245_9, 
     flencnt322_32, flencnt322_33, flencnt322_34, flencnt322_35, flencnt322_36, 
     flencnt322_37, flencnt322_38, flencnt322_39, flencnt322_40, flencnt322_41, 
     flencnt322_42, flencnt322_43, flencnt322_44, flencnt322_45, flencnt322_46, 
     flencnt322_47, flencnt322_48, flencnt322_49, flencnt322_50, flencnt322_51, 
     flencnt322_52, flencnt322_53, flencnt322_54, flencnt322_55, flencnt322_56, 
     n1027_1, dummycnt_4;
  ND3D1HVT U378_C2 (.A1(n1029), .A2(n1027), .A3(n1026), .ZN(n1042));
  OR2D1HVT U453_C1 (.A1(n1040_2), .A2(dummycnt247_2), .Z(dummycnt245_2));
  ND2D1HVT U384_C1 (.A1(n960), .A2(n1026), .ZN(n1028));
  bram_smc_DW01_dec_8_0 sub_254 (.A({fnumcnt_7_, fnumcnt_6_, fnumcnt_5_, 
     fnumcnt_4_, fnumcnt_3_, fnumcnt_2_, fnumcnt_1_, fnumcnt_0_}), .SUM({
     fnumcnt400_7, fnumcnt400_6, fnumcnt400_5, fnumcnt400_4, fnumcnt400_3, 
     fnumcnt400_2, fnumcnt400_1, fnumcnt400_0}));
  AO211D1HVT U363_C2 (.A1(bm_sreb_3), .A2(bram_rd_1), .B(n998), .C(U364_N3), 
     .Z(n1025));
  OA22D1HVT U385_C3 (.A1(cor_security_rddis), .A2(bram_rd_1), 
     .B1(cor_security_wrtdis), .B2(bram_wrt_3), .Z(n1050));
  MUX2D1HVT U423_C4 (.I0(fnumcnt400_5), .I1(framenum_5_2), .S(n989), 
     .Z(fnumcnt398_5));
  EDFCND1HVT fnumcnt_reg_5_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(fnumcnt398_8), .E(n995), .Q(fnumcnt_5_), .QN(n978));
  BUFFD1HVT OPTHOLD_G_498 (.I(flencnt322_54), .Z(flencnt322_31));
  BUFFD1HVT OPTHOLD_G_647 (.I(n1054), .Z(n1054_1));
  NR2D4HVT U375_C1 (.A1(n998), .A2(n1055), .ZN(n989));
  DFCND1HVT state_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_10), .D(next_1_1), 
     .Q(state_1_), .QN(n1045));
  EDFCND1HVT bm_sa_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_13), .D(bm_sa634_8), 
     .E(n635_2), .Q(n1075), .QN(n1016));
  INVD6HVT U438_C1 (.I(n1008), .ZN(bm_sa[1]));
  BUFFD1HVT OPTHOLD_G_469 (.I(bm_sa634_20), .Z(bm_sa634_14));
  BUFFD1HVT OPTHOLD_G_568 (.I(bram_reading_int_d3_2), .Z(bram_reading_int_d3_4));
  BUFFD1HVT OPTHOLD_G_1043 (.I(bm_sa634_3), .Z(bm_sa634_18));
  BUFFD4HVT BW1_BUF2450 (.I(bm_sreb_1), .Z(bm_sreb));
  INVD4HVT U469_C1 (.I(gwe), .ZN(bm_init));
  INVD4HVT U441_C1 (.I(n1014), .ZN(bm_sa[2]));
  INVD4HVT U443_C1 (.I(n1018), .ZN(bm_sa[4]));
  BUFFD1HVT OPTHOLD_G_944 (.I(U457_N3), .Z(U457_N3_1));
  BUFFD1HVT OPTHOLD_G_581 (.I(bram_reading_int_d2), .Z(bram_reading_int_d2_4));
  BUFFD1HVT OPTHOLD_G_310 (.I(bram_reading_int_d2_2), .Z(bram_reading_int_d2_1));
  EDFCND1HVT bm_sa_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_13), .D(bm_sa634_10), 
     .E(n635_2), .Q(n1072), .QN(n1012));
  BUFFD1HVT OPTHOLD_G_1060 (.I(fnumcnt398_0), .Z(fnumcnt398_23));
  BUFFD1HVT OPTHOLD_G_1098 (.I(flencnt322_2), .Z(flencnt322_54));
  BUFFD1HVT OPTHOLD_G_1037 (.I(next_1_), .Z(next_1_2));
  BUFFD1HVT OPTHOLD_G_459 (.I(fnumcnt398_23), .Z(fnumcnt398_12));
  EDFCND1HVT bm_sa_reg_4_ (.CDN(rst_b_2), .CP(spi_clk_out_13), .D(bm_sa634_13), 
     .E(n635_2), .Q(n1074), .QN(n1018));
  BUFFD1HVT OPTHOLD_G_448 (.I(bm_sclkrw754), .Z(bm_sclkrw754_1));
  BUFFD1HVT OPTHOLD_G_895 (.I(bram_reading_int_d3_3), .Z(bram_reading_int_d3_5));
  BUFFD1HVT OPTHOLD_G_470 (.I(bm_sa634_23), .Z(bm_sa634_15));
  NR3D1HVT U359_C2 (.A1(flencnt_5_), .A2(flencnt_14_), .A3(flencnt_12_), 
     .ZN(n981));
  MUX2D1HVT U407_C4 (.I0(framelen_7_2), .I1(flencnt323_7), .S(n1068), 
     .Z(flencnt322_7));
  XNR2D1HVT U341_C1 (.A1(flencnt_7_), .A2(flen[7]), .ZN(n963));
  ND4D1HVT U338_C3 (.A1(n964), .A2(n963), .A3(n962), .A4(n961), .ZN(n1065));
  XNR2D1HVT U342_C1 (.A1(flencnt_14_), .A2(flen[14]), .ZN(n964));
  BUFFD1HVT OPTHOLD_G_1137 (.I(dummycnt_2), .Z(dummycnt_4));
  BUFFD1HVT OPTHOLD_G_617 (.I(n1040), .Z(n1040_2));
  BUFFD1HVT OPTHOLD_G_889 (.I(bram_reading_int_d2_1), .Z(bram_reading_int_d2_5));
  BUFFD1HVT OPTHOLD_G_607 (.I(n635_1), .Z(n635_2));
  EDFCND1HVT fnumcnt_reg_7_ (.CDN(rst_b_2), .CP(spi_clk_out_5), 
     .D(fnumcnt398_22), .E(n995), .Q(fnumcnt_7_), .QN(n976));
  BUFFD1HVT OPTHOLD_G_317 (.I(bram_reading_int_d1_2), .Z(bram_reading_int_d1_1));
  DFSNQD1HVT bm_sreb_reg (.CP(spi_clk_out_12), .D(n1025), .Q(bm_sreb_1), 
     .SDN(rst_b_2));
  BUFFD1HVT OPTHOLD_G_1075 (.I(flencnt322_24), .Z(flencnt322_33));
  BUFFD1HVT OPTHOLD_G_1097 (.I(flencnt322_16), .Z(flencnt322_53));
  BUFFD1HVT OPTHOLD_G_489 (.I(flencnt322_46), .Z(flencnt322_22));
  BUFFD1HVT OPTHOLD_G_481 (.I(flencnt322_52), .Z(flencnt322_16));
  BUFFD1HVT OPTHOLD_G_1088 (.I(flencnt322_5), .Z(flencnt322_44));
  BUFFD1HVT OPTHOLD_G_1092 (.I(flencnt322_6), .Z(flencnt322_48));
  BUFFD1HVT OPTHOLD_G_496 (.I(flencnt322_1), .Z(flencnt322_29));
  BUFFD1HVT OPTHOLD_G_484 (.I(flencnt322_34), .Z(flencnt322_18));
  BUFFD1HVT OPTHOLD_G_495 (.I(flencnt322_48), .Z(flencnt322_28));
  MUX2D1HVT U405_C4 (.I0(framelen_9_2), .I1(flencnt323_9), .S(n1068), 
     .Z(flencnt322_9));
  MUX2D1HVT U402_C4 (.I0(framelen_12_2), .I1(flencnt323_12), .S(n1068), 
     .Z(flencnt322_12));
  BUFFD1HVT OPTHOLD_G_1096 (.I(flencnt322_11), .Z(flencnt322_52));
  EDFCND1HVT fnumcnt_reg_4_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(fnumcnt398_17), .E(n995), .Q(fnumcnt_4_), .QN(n979));
  MUX2D1HVT U429_C4 (.I0(fnumcnt400_2), .I1(framenum_2_2), .S(n989), 
     .Z(fnumcnt398_2));
  BUFFD1HVT OPTHOLD_G_856 (.I(flencnt_1_), .Z(flencnt_1_2));
  BUFFD1HVT OPTHOLD_G_84 (.I(state_0_), .Z(state_0_1));
  XNR2D1HVT U344_C1 (.A1(flencnt_4_), .A2(flen[4]), .ZN(n965));
  ND4D1HVT U343_C3 (.A1(n968), .A2(n967), .A3(n966), .A4(n965), .ZN(n1067));
  INVD1HVT U369_C3_MP_INV (.I(n988), .ZN(n988_1));
  MUX2D1HVT U413_C4 (.I0(framelen_1_2), .I1(flencnt323_1), .S(n1068), 
     .Z(flencnt322_1));
  CKXOR2D1HVT U461_C1 (.A1(flencnt_2_), .A2(flen[2]), .Z(n1062));
  EDFCND1HVT fnumcnt_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(fnumcnt398_18), .E(n995), .Q(fnumcnt_2_), .QN(n980));
  CKXOR2D1HVT U459_C1 (.A1(flencnt_8_), .A2(flen[8]), .Z(n1060));
  ND4D1HVT U356_C3 (.A1(n1027), .A2(n1026), .A3(dummycnt_1), .A4(dummycnt247_1), 
     .ZN(n1070));
  BUFFD1HVT OPTHOLD_G_125 (.I(flencnt_0_2), .Z(flencnt_0_1));
  DFCNQD1HVT bram_reading_int_d4_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(bram_reading_int_d3_5), .Q(bram_reading));
  OAI22D2HVT U368_C3 (.A1(n1055), .A2(bram_rd_1), .B1(n1057), .B2(bm_sweb700), 
     .ZN(n1040));
  BUFFD1HVT OPTHOLD_G_877 (.I(bram_reading_int_d1_3), .Z(bram_reading_int_d1_5));
  ND2D1HVT U365_C1 (.A1(n992), .A2(n988), .ZN(n1046));
  BUFFD1HVT OPTHOLD_G_886 (.I(bram_rd_2), .Z(bram_rd_4));
  BUFFD1HVT OPTHOLD_G_657 (.I(n1045), .Z(n1045_1));
  OAI21D1HVT U457_C1 (.A1(n1042), .A2(dummycnt247_1), .B(n991_1), .ZN(U457_N3));
  ND2D1HVT U357_C1 (.A1(bram_wrt), .A2(bram_rd_1), .ZN(n_632));
  BUFFD1HVT OPTHOLD_G_333 (.I(bram_reading_int), .Z(bram_reading_int_3));
  INVD1HVT U379_C1_MP_INV (.I(bram_rd), .ZN(bram_rd_1));
  AN4D1HVT U367_C3 (.A1(state_1_2), .A2(state_0_1), .A3(n1046), .A4(bram_rd), 
     .Z(n996));
  BUFFD1HVT OPTHOLD_G_455 (.I(fnumcnt398_21), .Z(fnumcnt398_8));
  OR2D1HVT U452_C1 (.A1(n1040_2), .A2(dummycnt247_3), .Z(dummycnt245_3));
  EDFCND1HVT dummycnt_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(dummycnt245_6), .E(n246_0), .Q(), .QN(n1027));
  BUFFD1HVT OPTHOLD_G_450 (.I(bram_done460_3), .Z(bram_done460_1));
  BUFFD1HVT OPTHOLD_G_1051 (.I(fnumcnt398_13), .Z(fnumcnt398_18));
  BUFFD1HVT OPTHOLD_G_318 (.I(bram_reading_int_d1_5), .Z(bram_reading_int_d1_2));
  ND4D1HVT U353_C3 (.A1(n976), .A2(n975), .A3(n974), .A4(n973), .ZN(n1053));
  MUX2D1HVT U432_C4 (.I0(fnumcnt400_1), .I1(framenum_1_2), .S(n989), 
     .Z(fnumcnt398_1));
  BUFFD1HVT OPTHOLD_G_312 (.I(bram_reading_int_d2_4), .Z(bram_reading_int_d2_3));
  BUFFD1HVT OPTHOLD_G_490 (.I(flencnt322_55), .Z(flencnt322_23));
  BUFFD1HVT OPTHOLD_G_588 (.I(bram_reading_int_2), .Z(bram_reading_int_4));
  DFCND1HVT state_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_10), .D(next_0_1), 
     .Q(state_0_), .QN(n1054));
  BUFFD1HVT OPTHOLD_G_1034 (.I(bram_clk_en_i), .Z(bram_clk_en_i_1));
  INVD6HVT U447_C1 (.I(n1023), .ZN(bm_sa[0]));
  BUFFD1HVT OPTHOLD_G_342 (.I(bram_rd_3), .Z(bram_rd_2));
  BUFFD1HVT OPTHOLD_G_885 (.I(bram_rd_1), .Z(bram_rd_3));
  BUFFD1HVT OPTHOLD_G_465 (.I(bm_sa634_19), .Z(bm_sa634_10));
  INVD1HVT U467_C3_MP_INV (.I(n993), .ZN(n993_1));
  INVD2HVT BL1_R_INV_18 (.I(n994_2), .ZN(n994));
  CKND1HVT U393_C3_MP_INV (.I(baddr[0]), .ZN(baddr_0_1));
  OAI31D1HVT U467_C3 (.A1(n993_1), .A2(baddr[1]), .A3(baddr[0]), .B(n994_1), 
     .ZN(bm_banksel[0]));
  INVD4HVT U444_C1 (.I(n1020), .ZN(bm_sa[5]));
  BUFFD1HVT OPTHOLD_G_311 (.I(bram_reading_int_d2_3), .Z(bram_reading_int_d2_2));
  EDFCND1HVT bm_sa_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_13), .D(bm_sa634_9), 
     .E(n635_2), .Q(n1077), .QN(n1023));
  EDFCND1HVT bm_sa_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_13), .D(bm_sa634_15), 
     .E(n635_2), .Q(bm_sa_Q657_1), .QN(n1008));
  BUFFD1HVT OPTHOLD_G_1040 (.I(bm_sa634_12), .Z(bm_sa634_16));
  BUFFD1HVT OPTHOLD_G_1100 (.I(flencnt322_15), .Z(flencnt322_56));
  MUX2D1HVT U417_C4 (.I0(bm_sa636_7), .I1(start_framenum_7_1), .S(n989), 
     .Z(bm_sa634_7));
  BUFFD1HVT OPTHOLD_G_1099 (.I(flencnt322_3), .Z(flencnt322_55));
  BUFFD1HVT OPTHOLD_G_451 (.I(next_1_2), .Z(next_1_1));
  BUFFD1HVT OPTHOLD_G_1055 (.I(bm_sa634_1), .Z(bm_sa634_23));
  BUFFD1HVT OPTHOLD_G_1048 (.I(bm_sa634_2), .Z(bm_sa634_21));
  MUX2D1HVT U425_C4 (.I0(bm_sa636_3), .I1(start_framenum_3_1), .S(n989), 
     .Z(bm_sa634_3));
  EDFCND1HVT bm_sa_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_13), .D(bm_sa634_11), 
     .E(n635_2), .Q(n1076), .QN(n1014));
  BUFFD1HVT OPTHOLD_G_1082 (.I(flencnt322_10), .Z(flencnt322_38));
  NR3D1HVT U361_C2 (.A1(flencnt_6_), .A2(flencnt_15_), .A3(flencnt_13_), 
     .ZN(n983));
  BUFFD1HVT OPTHOLD_G_567 (.I(bram_reading_int_d3_1), .Z(bram_reading_int_d3_3));
  ND4D1HVT U358_C3 (.A1(n984), .A2(n983), .A3(n982), .A4(n981), .ZN(n1038));
  DFCNQD1HVT flencnt_reg_7_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(flencnt322_47), .Q(flencnt_7_));
  BUFFD1HVT OPTHOLD_G_452 (.I(dummycnt245_8), .Z(dummycnt245_4));
  BUFFD1HVT OPTHOLD_G_865 (.I(bm_sreb_1), .Z(bm_sreb_4));
  BUFFD1HVT OPTHOLD_G_1039 (.I(dummycnt245_3), .Z(dummycnt245_6));
  BUFFD1HVT OPTHOLD_G_1053 (.I(fnumcnt398_3), .Z(fnumcnt398_20));
  EDFCND1HVT fnumcnt_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_5), 
     .D(fnumcnt398_14), .E(n995), .Q(fnumcnt_6_), .QN(n974));
  OR2D1HVT U374_C1 (.A1(n989), .A2(bm_sclkrw), .Z(n635_0));
  DFCNQD1HVT bm_sweb_reg (.CDN(rst_b_2), .CP(clk_b_2), .D(bm_sweb700_1), 
     .Q(bm_sweb));
  AO221D1HVT U334_C4 (.A1(dummycnt_1), .A2(dummycnt_2), .B1(n1029), 
     .B2(dummycnt247_4), .C(n1040), .Z(dummycnt245_1));
  XNR2D1HVT U340_C1 (.A1(flencnt_12_), .A2(flen[12]), .ZN(n962));
  BUFFD1HVT OPTHOLD_G_491 (.I(flencnt322_32), .Z(flencnt322_24));
  BUFFD1HVT OPTHOLD_G_1074 (.I(flencnt322_9), .Z(flencnt322_32));
  BUFFD1HVT OPTHOLD_G_493 (.I(flencnt322_44), .Z(flencnt322_26));
  BUFFD1HVT OPTHOLD_G_1090 (.I(flencnt322_7), .Z(flencnt322_46));
  DFCNQD1HVT flencnt_reg_12_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(flencnt322_41), .Q(flencnt_12_));
  BUFFD1HVT OPTHOLD_G_487 (.I(flencnt322_36), .Z(flencnt322_20));
  CKXOR2D1HVT U460_C1 (.A1(flencnt_9_), .A2(flen[9]), .Z(n1061));
  DFCNQD1HVT flencnt_reg_14_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(flencnt322_43), .Q(flencnt_14_));
  DFCNQD1HVT flencnt_reg_13_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(flencnt322_35), .Q(flencnt_13_));
  DFCNQD1HVT flencnt_reg_5_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(flencnt322_45), .Q(flencnt_5_));
  ND4D1HVT U354_C3 (.A1(n980), .A2(n979), .A3(n978), .A4(n977), .ZN(n1052));
  MUX2D1HVT U431_C4 (.I0(fnumcnt400_0), .I1(framenum_0_2), .S(n989), 
     .Z(fnumcnt398_0));
  MUX2D1HVT U410_C4 (.I0(framelen_4_2), .I1(flencnt323_4), .S(n1068), 
     .Z(flencnt322_4));
  BUFFD1HVT OPTHOLD_G_1089 (.I(flencnt322_26), .Z(flencnt322_45));
  MUX2D1HVT U409_C4 (.I0(framelen_6_2), .I1(flencnt323_6), .S(n1068), 
     .Z(flencnt322_6));
  BUFFD1HVT OPTHOLD_G_1031 (.I(bm_sclkrw754_1), .Z(bm_sclkrw754_2));
  NR4D1HVT U371_C3 (.A1(n1063), .A2(n1062), .A3(n1061), .A4(n1060), .ZN(n987));
  CKXOR2D1HVT U462_C1 (.A1(flencnt_1_), .A2(flen[1]), .Z(n1063));
  DFCNQD1HVT flencnt_reg_11_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(flencnt322_53), .Q(flencnt_11_));
  MUX2D1HVT U408_C4 (.I0(framelen_3_2), .I1(flencnt323_3), .S(n1068), 
     .Z(flencnt322_3));
  DFCNQD1HVT flencnt_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(flencnt322_23), .Q(flencnt_3_));
  MUX2D1HVT U411_C4 (.I0(framelen_0_2), .I1(flencnt323_0), .S(n1068), 
     .Z(flencnt322_0));
  NR2D1HVT U395_C1 (.A1(bram_wrt), .A2(bram_rd), .ZN(n998));
  BUFFD1HVT OPTHOLD_G_332 (.I(bram_reading_int_5), .Z(bram_reading_int_2));
  OR2D1HVT U458_C1 (.A1(n1042), .A2(dummycnt_2), .Z(n1039));
  IIND4D1HVT U335_C5 (.A1(flencnt_1_1), .A2(n1038), .B1(n988), .B2(flencnt_0_1), 
     .ZN(n991));
  NR3D1HVT U382_C2 (.A1(n1038), .A2(flencnt_1_2), .A3(flencnt_0_2), .ZN(n992));
  OR2D1HVT U451_C1 (.A1(n1040_2), .A2(n1039), .Z(n246_0));
  BUFFD1HVT OPTHOLD_G_716 (.I(n991), .Z(n991_1));
  OAI22D1HVT U366_C3 (.A1(n1056), .A2(n1039), .B1(n_632), .B2(n1055), .ZN(n1048));
  BUFFD1HVT OPTHOLD_G_123 (.I(flencnt_1_2), .Z(flencnt_1_1));
  AO211D1HVT U455_C3 (.A1(n1045_1), .A2(n1044), .B(n996), .C(n1040_2), 
     .Z(next_0_));
  DFCNQD1HVT bram_reading_int_d1_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(bram_reading_int_1), .Q(bram_reading_int_d1));
  ND2D1HVT U381_C1 (.A1(n992), .A2(bram_wrt_1), .ZN(bm_sweb700));
  EDFCND1HVT dummycnt_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(dummycnt245_9), .E(n246_0), .Q(dummycnt_1), .QN(n1029));
  EDFCND1HVT dummycnt_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(dummycnt245_5), .E(n246_0), .Q(), .QN(n1026));
  CKAN2D1HVT U331_C1 (.A1(n1029), .A2(dummycnt247_4), .Z(n960));
  bram_smc_DW01_dec_16_0 sub_239 (.A({flencnt_15_, flencnt_14_, flencnt_13_, 
     flencnt_12_, flencnt_11_, flencnt_10_, flencnt_9_, flencnt_8_, flencnt_7_, 
     flencnt_6_, flencnt_5_, flencnt_4_, flencnt_3_, flencnt_2_, flencnt_1_, 
     flencnt_0_}), .SUM({flencnt323_15, flencnt323_14, flencnt323_13, 
     flencnt323_12, flencnt323_11, flencnt323_10, flencnt323_9, flencnt323_8, 
     flencnt323_7, flencnt323_6, flencnt323_5, flencnt323_4, flencnt323_3, 
     flencnt323_2, flencnt323_1, flencnt323_0}), .flencnt_1_1(flencnt_1_1), 
     .flencnt_0_1(flencnt_0_1));
  MUX2D1HVT U424_C4 (.I0(fnumcnt400_4), .I1(framenum_4_2), .S(n989), 
     .Z(fnumcnt398_4));
  DFCNQD1HVT flencnt_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(flencnt322_27), .Q(flencnt_0_));
  EDFCND1HVT fnumcnt_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(fnumcnt398_11), .E(n995), .Q(fnumcnt_1_), .QN(n973));
  BUFFD1HVT OPTHOLD_G_1095 (.I(flencnt322_30), .Z(flencnt322_51));
  BUFFD1HVT OPTHOLD_G_456 (.I(fnumcnt398_20), .Z(fnumcnt398_9));
  MUX2D1HVT U430_C4 (.I0(bm_sa636_2), .I1(start_framenum_2_1), .S(n989), 
     .Z(bm_sa634_2));
  DFCNQD1HVT bram_reading_int_d2_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(bram_reading_int_d1_1), .Q(bram_reading_int_d2));
  DFCNQD1HVT bram_reading_int_d3_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(bram_reading_int_d2_5), .Q(bram_reading_int_d3));
  MUX2D1HVT U422_C4 (.I0(bm_sa636_4), .I1(start_framenum_4_1), .S(n989), 
     .Z(bm_sa634_4));
  BUFFD1HVT OPTHOLD_G_9 (.I(n635_0), .Z(n635_1));
  BUFFD1HVT OPTHOLD_G_892 (.I(bram_wrt_3), .Z(bram_wrt_2));
  BUFFD1HVT OPTHOLD_G_466 (.I(bm_sa634_21), .Z(bm_sa634_11));
  BUFFD1HVT OPTHOLD_G_1044 (.I(bm_sa634_6), .Z(bm_sa634_19));
  INVD1HVT U467_C3_MP_INV_1 (.I(n994), .ZN(n994_1));
  AO31D1HVT U394_C3 (.A1(n993), .A2(baddr[1]), .A3(baddr[0]), .B(n994), 
     .Z(bm_banksel[3]));
  INVD4HVT U437_C1 (.I(n1006), .ZN(bm_sa[7]));
  INVD4HVT U442_C1 (.I(n1016), .ZN(bm_sa[3]));
  BUFFD1HVT OPTHOLD_G_331 (.I(bram_reading_int_4), .Z(bram_reading_int_1));
  MUX2D1HVT U426_C4 (.I0(bm_sa636_0), .I1(start_framenum_0_2), .S(n989), 
     .Z(bm_sa634_0));
  BUFFD1HVT OPTHOLD_G_307 (.I(bram_reading_int_d3), .Z(bram_reading_int_d3_2));
  MUX2D1HVT U428_C4 (.I0(bm_sa636_1), .I1(start_framenum_1_2), .S(n989), 
     .Z(bm_sa634_1));
  EDFCND1HVT bm_sa_reg_7_ (.CDN(rst_b_2), .CP(spi_clk_out_13), .D(bm_sa634_14), 
     .E(n635_2), .Q(n1071), .QN(n1006));
  MUX2D1HVT U418_C4 (.I0(bm_sa636_6), .I1(start_framenum_6_1), .S(n989), 
     .Z(bm_sa634_6));
  BUFFD1HVT OPTHOLD_G_1052 (.I(fnumcnt398_1), .Z(fnumcnt398_19));
  BUFFD1HVT OPTHOLD_G_458 (.I(fnumcnt398_19), .Z(fnumcnt398_11));
  DFCNQD1HVT bm_rcapmux_en_reg (.CDN(rst_b_2), .CP(clk_b_2), .D(n1000), 
     .Q(bm_rcapmux_en));
  BUFFD1HVT OPTHOLD_G_977 (.I(bm_sweb700), .Z(bm_sweb700_2));
  CKLNQD1HVT BM_CLKb (.CP(spi_clk_out_13), .E(bram_clk_en_i_1), .Q(bm_clk), 
     .TE(tm_dis_bram_clk_gating_1));
  DFCNQD1HVT bm_wdummymux_en_reg (.CDN(rst_b_2), .CP(clk_b_2), .D(n999), 
     .Q(bm_wdummymux_en));
  MUX2D1HVT U399_C4 (.I0(framelen_15_2), .I1(flencnt323_15), .S(n1068), 
     .Z(flencnt322_15));
  NR4D1HVT U360_C3 (.A1(flencnt_9_), .A2(flencnt_8_), .A3(flencnt_7_), 
     .A4(flencnt_2_), .ZN(n982));
  MUX2D1HVT U406_C4 (.I0(framelen_8_2), .I1(flencnt323_8), .S(n1068), 
     .Z(flencnt322_8));
  NR4D1HVT U362_C3 (.A1(flencnt_4_), .A2(flencnt_3_), .A3(flencnt_11_), 
     .A4(flencnt_10_), .ZN(n984));
  BUFFD1HVT OPTHOLD_G_1072 (.I(dummycnt245_1), .Z(dummycnt245_8));
  BUFFD1HVT OPTHOLD_G_1084 (.I(flencnt322_12), .Z(flencnt322_40));
  INVD6HVT BW1_INV4244 (.I(rst_b_1), .ZN(rst_b_2));
  CKXOR2D1HVT U449_C1 (.A1(n1028), .A2(n1027_1), .Z(dummycnt247_3));
  MUX2D1HVT U420_C4 (.I0(fnumcnt400_7), .I1(framenum_7_2), .S(n989), 
     .Z(fnumcnt398_7));
  BUFFD1HVT OPTHOLD_G_1050 (.I(fnumcnt398_10), .Z(fnumcnt398_17));
  INR2D1HVT U396_C1 (.A1(bm_sclkrw), .B1(bram_wrt_2), .ZN(n999));
  DFCNQD1HVT bm_sclkrw_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(bm_sclkrw754_2), .Q(bm_sclkrw));
  XNR2D1HVT U352_C1 (.A1(flencnt_10_), .A2(flen[10]), .ZN(n972));
  MUX2D1HVT U401_C4 (.I0(framelen_13_2), .I1(flencnt323_13), .S(n1068), 
     .Z(flencnt322_13));
  MUX2D1HVT U404_C4 (.I0(framelen_10_2), .I1(flencnt323_10), .S(n1068), 
     .Z(flencnt322_10));
  BUFFD1HVT OPTHOLD_G_1056 (.I(fnumcnt398_5), .Z(fnumcnt398_21));
  BUFFD1HVT OPTHOLD_G_1094 (.I(flencnt322_4), .Z(flencnt322_50));
  BUFFD1HVT OPTHOLD_G_1045 (.I(fnumcnt398_6), .Z(fnumcnt398_16));
  BUFFD1HVT OPTHOLD_G_483 (.I(flencnt322_42), .Z(flencnt322_17));
  BUFFD1HVT OPTHOLD_G_1080 (.I(flencnt322_8), .Z(flencnt322_36));
  BUFFD1HVT OPTHOLD_G_1086 (.I(flencnt322_14), .Z(flencnt322_42));
  BUFFD1HVT OPTHOLD_G_1083 (.I(flencnt322_19), .Z(flencnt322_39));
  MUX2D1HVT U403_C4 (.I0(framelen_11_2), .I1(flencnt323_11), .S(n1068), 
     .Z(flencnt322_11));
  BUFFD1HVT OPTHOLD_G_460 (.I(fnumcnt398_2), .Z(fnumcnt398_13));
  BUFFD1HVT OPTHOLD_G_449 (.I(next_0_2), .Z(next_0_1));
  BUFFD1HVT OPTHOLD_G_462 (.I(fnumcnt398_16), .Z(fnumcnt398_14));
  EDFCND1HVT fnumcnt_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_7), .D(fnumcnt398_9), 
     .E(n995), .Q(fnumcnt_3_), .QN(n977));
  BUFFD1HVT OPTHOLD_G_1081 (.I(flencnt322_20), .Z(flencnt322_37));
  XNR2D1HVT U347_C1 (.A1(flencnt_6_), .A2(flen[6]), .ZN(n968));
  DFCNQD1HVT flencnt_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(flencnt322_49), .Q(flencnt_6_));
  BUFFD1HVT OPTHOLD_G_1079 (.I(flencnt322_18), .Z(flencnt322_35));
  BUFFD1HVT OPTHOLD_G_457 (.I(fnumcnt398_4), .Z(fnumcnt398_10));
  BUFFD1HVT OPTHOLD_G_1073 (.I(dummycnt245_4), .Z(dummycnt245_9));
  DFCNQD1HVT flencnt_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(flencnt322_31), .Q(flencnt_2_));
  XNR2D1HVT U346_C1 (.A1(flencnt_15_), .A2(flen[15]), .ZN(n967));
  BUFFD1HVT OPTHOLD_G_712 (.I(dummycnt247_0), .Z(dummycnt247_4));
  BUFFD1HVT OPTHOLD_G_857 (.I(flencnt_0_), .Z(flencnt_0_2));
  ND3D1HVT U337_C2 (.A1(state_1_1), .A2(n988), .A3(n1054_1), .ZN(n1057));
  BUFFD1HVT OPTHOLD_G_1030 (.I(bram_wrt_1), .Z(bram_wrt_4));
  OA21D1HVT U466_C1 (.A1(n1038), .A2(U465_N5), .B(n1070), .Z(U466_N3));
  OAI33D4HVT U332_C5 (.A1(n991_1), .A2(bram_wrt), .A3(bram_rd_1), .B1(n_632), 
     .B2(n1042), .B3(dummycnt247_1), .ZN(bram_done460));
  NR2D4HVT U463_C1 (.A1(n992), .A2(n1048), .ZN(n1068));
  EDFCNQD1HVT bram_reading_int_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(n991_1), .E(n_644), .Q(bram_reading_int));
  BUFFD1HVT OPTHOLD_G_494 (.I(flencnt322_0), .Z(flencnt322_27));
  INVD1HVT U454_C1_MP_INV (.I(n1040_2), .ZN(n1040_1));
  BUFFD1HVT OPTHOLD_G_122 (.I(dummycnt247_4), .Z(dummycnt247_1));
  BUFFD1HVT OPTHOLD_G_20 (.I(dummycnt_3), .Z(dummycnt_2));
  AO211D1HVT U456_C3 (.A1(n1047), .A2(n1046), .B(n996), .C(n1048), .Z(next_1_));
  bram_smc_DW01_inc_8_0 add_320 (.A({n1071, n1072, n1073, n1074, n1075, n1076, 
     bm_sa_Q657_1, n1077}), .SUM({bm_sa636_7, bm_sa636_6, bm_sa636_5, bm_sa636_4, 
     bm_sa636_3, bm_sa636_2, bm_sa636_1, bm_sa636_0}));
  BUFFD1HVT OPTHOLD_G_1087 (.I(flencnt322_17), .Z(flencnt322_43));
  BUFFD1HVT OPTHOLD_G_1063 (.I(bram_done460), .Z(bram_done460_3));
  XNR2D1HVT U448_C1 (.A1(n960), .A2(n1026), .ZN(dummycnt247_2));
  NR2D1HVT U364_C1 (.A1(bram_wrt_3), .A2(bram_rd_1), .ZN(U364_N3));
  OAI21D1HVT U377_C1 (.A1(bram_rd_1), .A2(U466_N3_1), .B(bm_sweb700), 
     .ZN(bm_sclkrw754));
  BUFFD1HVT OPTHOLD_G_1093 (.I(flencnt322_28), .Z(flencnt322_49));
  EDFCND1HVT fnumcnt_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(fnumcnt398_24), .E(n995), .Q(fnumcnt_0_), .QN(n975));
  ND2D1HVT U355_C1 (.A1(n1054), .A2(n1045), .ZN(n1055));
  BUFFD1HVT OPTHOLD_G_1049 (.I(next_0_), .Z(next_0_2));
  BUFFD1HVT OPTHOLD_G_573 (.I(bram_reading_int_d1_4), .Z(bram_reading_int_d1_3));
  NR3D1HVT U386_C3 (.A1(state_0_1), .A2(n1045_1), .A3(bram_wrt_3), .ZN(n1047));
  BUFFD1HVT OPTHOLD_G_375 (.I(U466_N3), .Z(U466_N3_1));
  BUFFD1HVT OPTHOLD_G_675 (.I(state_1_1), .Z(state_1_2));
  BUFFD1HVT OPTHOLD_G_468 (.I(bm_sa634_17), .Z(bm_sa634_13));
  BUFFD1HVT OPTHOLD_G_461 (.I(bm_sa634_18), .Z(bm_sa634_8));
  BUFFD1HVT OPTHOLD_G_472 (.I(bm_sweb700_2), .Z(bm_sweb700_1));
  BUFFD1HVT OPTHOLD_G_1042 (.I(bm_sa634_4), .Z(bm_sa634_17));
  ND2D1HVT U383_C1_INV (.A1(n993), .A2(cor_en_8bconfig), .ZN(n994_2));
  AO31D1HVT U468_C3 (.A1(n993), .A2(baddr[1]), .A3(baddr_0_1), .B(n994), 
     .Z(bm_banksel[2]));
  OAI31D1HVT U393_C3 (.A1(n993_1), .A2(baddr[1]), .A3(baddr_0_1), .B(n994_1), 
     .ZN(bm_banksel[1]));
  INVD4HVT U440_C1 (.I(n1012), .ZN(bm_sa[6]));
  INR2XD2HVT U333_C2 (.A1(cfg_ld_bstream_2), .B1(n1050), .ZN(n993));
  BUFFD1HVT OPTHOLD_G_1054 (.I(bm_sa634_0), .Z(bm_sa634_22));
  BUFFD1HVT OPTHOLD_G_464 (.I(bm_sa634_22), .Z(bm_sa634_9));
  BUFFD1HVT OPTHOLD_G_914 (.I(bram_reading_int_3), .Z(bram_reading_int_5));
  EDFCND1HVT bm_sa_reg_5_ (.CDN(rst_b_2), .CP(spi_clk_out_13), .D(bm_sa634_16), 
     .E(n635_2), .Q(n1073), .QN(n1020));
  BUFFD1HVT OPTHOLD_G_876 (.I(bram_reading_int_d1), .Z(bram_reading_int_d1_4));
  BUFFD1HVT OPTHOLD_G_1057 (.I(fnumcnt398_15), .Z(fnumcnt398_22));
  MUX2D1HVT U419_C4 (.I0(bm_sa636_5), .I1(start_framenum_5_2), .S(n989), 
     .Z(bm_sa634_5));
  BUFFD1HVT OPTHOLD_G_467 (.I(bm_sa634_5), .Z(bm_sa634_12));
  BUFFD1HVT OPTHOLD_G_864 (.I(bm_sreb_2), .Z(bm_sreb_3));
  BUFFD1HVT OPTHOLD_G_1046 (.I(bm_sa634_7), .Z(bm_sa634_20));
  BUFFD1HVT OPTHOLD_G_306 (.I(bram_reading_int_d3_4), .Z(bram_reading_int_d3_1));
  DFCNQD1HVT flencnt_reg_15_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(flencnt322_21), .Q(flencnt_15_));
  DFCNQD1HVT flencnt_reg_8_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(flencnt322_37), .Q(flencnt_8_));
  BUFFD1HVT OPTHOLD_G_35 (.I(state_1_), .Z(state_1_1));
  XNR2D1HVT U345_C1 (.A1(flencnt_13_), .A2(flen[13]), .ZN(n966));
  XNR2D1HVT U350_C1 (.A1(flencnt_11_), .A2(flen[11]), .ZN(n970));
  INVD1HVT BW1_INV_D4244 (.I(rst_b), .ZN(rst_b_1));
  BUFFD1HVT OPTHOLD_G_1133 (.I(n1027), .Z(n1027_1));
  BUFFD1HVT OPTHOLD_G_1061 (.I(fnumcnt398_12), .Z(fnumcnt398_24));
  BUFFD1HVT OPTHOLD_G_488 (.I(flencnt322_56), .Z(flencnt322_21));
  MUX2D1HVT U421_C4 (.I0(fnumcnt400_6), .I1(framenum_6_2), .S(n989), 
     .Z(fnumcnt398_6));
  INR2D1HVT U397_C1 (.A1(bm_sclkrw), .B1(bram_rd_4), .ZN(n1000));
  OR2D1HVT U450_C1 (.A1(n993), .A2(bram_reading_1), .Z(bram_clk_en_i));
  DFCNQD1HVT bram_done_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(bram_done460_2), .Q(bram_done));
  ND4D1HVT U348_C3 (.A1(n972), .A2(n971), .A3(n970), .A4(n969), .ZN(n1066));
  BUFFD1HVT OPTHOLD_G_1078 (.I(flencnt322_13), .Z(flencnt322_34));
  BUFFD1HVT OPTHOLD_G_497 (.I(flencnt322_50), .Z(flencnt322_30));
  MUX2D1HVT U400_C4 (.I0(framelen_14_2), .I1(flencnt323_14), .S(n1068), 
     .Z(flencnt322_14));
  DFCNQD1HVT flencnt_reg_9_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(flencnt322_33), .Q(flencnt_9_));
  BUFFD1HVT OPTHOLD_G_492 (.I(flencnt322_40), .Z(flencnt322_25));
  BUFFD1HVT OPTHOLD_G_486 (.I(flencnt322_38), .Z(flencnt322_19));
  XNR2D1HVT U351_C1 (.A1(flencnt_5_), .A2(flen[5]), .ZN(n971));
  BUFFD1HVT OPTHOLD_G_1085 (.I(flencnt322_25), .Z(flencnt322_41));
  BUFFD1HVT OPTHOLD_G_1038 (.I(dummycnt245_2), .Z(dummycnt245_5));
  MUX2D1HVT U412_C4 (.I0(framelen_5_2), .I1(flencnt323_5), .S(n1068), 
     .Z(flencnt322_5));
  NR2XD1HVT U372_C1 (.A1(n1053), .A2(n1052), .ZN(n988));
  MUX2D1HVT U427_C4 (.I0(fnumcnt400_3), .I1(framenum_3_2), .S(n989), 
     .Z(fnumcnt398_3));
  IND3D1HVT U465_C2 (.A1(flencnt_0_), .B1(n988_1), .B2(flencnt_1_1), 
     .ZN(U465_N5));
  AO31D1HVT U369_C3 (.A1(n988_1), .A2(n987), .A3(n986), .B(n989), .Z(n995));
  XNR2D1HVT U339_C1 (.A1(flencnt_0_), .A2(flen[0]), .ZN(n961));
  DFCNQD1HVT flencnt_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(flencnt322_29), .Q(flencnt_1_));
  XNR2D1HVT U349_C1 (.A1(flencnt_3_), .A2(flen[3]), .ZN(n969));
  MUX2D1HVT U414_C4 (.I0(framelen_2_2), .I1(flencnt323_2), .S(n1068), 
     .Z(flencnt322_2));
  DFCNQD1HVT flencnt_reg_10_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(flencnt322_39), .Q(flencnt_10_));
  DFCNQD1HVT flencnt_reg_4_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(flencnt322_51), .Q(flencnt_4_));
  BUFFD1HVT OPTHOLD_G_1041 (.I(dummycnt245_0), .Z(dummycnt245_7));
  NR3D1HVT U370_C2 (.A1(n1067), .A2(n1066), .A3(n1065), .ZN(n986));
  INVD1HVT U386_C3_MP_INV (.I(bram_wrt_4), .ZN(bram_wrt_3));
  BUFFD1HVT OPTHOLD_G_463 (.I(fnumcnt398_7), .Z(fnumcnt398_15));
  AO21D1HVT U464_C2 (.A1(state_0_1), .A2(n1039), .B(n990), .Z(n1044));
  BUFFD1HVT OPTHOLD_G_21 (.I(dummycnt_0), .Z(dummycnt_3));
  BUFFD1HVT OPTHOLD_G_1062 (.I(bram_done460_1), .Z(bram_done460_2));
  ND2D1HVT U454_C1 (.A1(n1040_1), .A2(dummycnt_4), .ZN(dummycnt245_0));
  BUFFD1HVT OPTHOLD_G_334 (.I(bm_sreb_4), .Z(bm_sreb_2));
  CKAN2D1HVT U457_C2 (.A1(n990), .A2(U457_N3_1), .Z(n_644));
  BUFFD1HVT OPTHOLD_G_1091 (.I(flencnt322_22), .Z(flencnt322_47));
  ND3D1HVT U336_C2 (.A1(state_0_1), .A2(n990), .A3(n1045), .ZN(n1056));
  EDFCND1HVT dummycnt_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_10), 
     .D(dummycnt245_7), .E(n246_0), .Q(dummycnt_0), .QN(dummycnt247_0));
  NR2D1HVT U379_C1 (.A1(bram_wrt), .A2(bram_rd_1), .ZN(n990));
endmodule

// Entity:bram_smc_DW01_dec_16_0 Model:bram_smc_DW01_dec_16_0 Library:L1
module bram_smc_DW01_dec_16_0 (A, SUM, flencnt_1_1, flencnt_0_1);
  input flencnt_1_1, flencnt_0_1;
  input [15:0] A;
  output [15:0] SUM;
  wire carry_10, carry_11, carry_12, carry_13, carry_14, carry_15, carry_2, 
     carry_3, carry_4, carry_5, carry_6, carry_7, carry_8, carry_9;
  OR2D1HVT U1_B_5_C1 (.A1(carry_5), .A2(A[5]), .Z(carry_6));
  XNR2D1HVT U1_A_6_C1 (.A1(carry_6), .A2(A[6]), .ZN(SUM[6]));
  XNR2D1HVT U1_A_5_C1 (.A1(carry_5), .A2(A[5]), .ZN(SUM[5]));
  OR2D1HVT U1_B_7_C1 (.A1(carry_7), .A2(A[7]), .Z(carry_8));
  XNR2D1HVT U1_A_8_C1 (.A1(carry_8), .A2(A[8]), .ZN(SUM[8]));
  OR2D1HVT U1_B_9_C1 (.A1(carry_9), .A2(A[9]), .Z(carry_10));
  OR2D1HVT U1_B_13_C1 (.A1(carry_13), .A2(A[13]), .Z(carry_14));
  OR2D1HVT U1_B_11_C1 (.A1(carry_11), .A2(A[11]), .Z(carry_12));
  XNR2D1HVT U1_A_12_C1 (.A1(carry_12), .A2(A[12]), .ZN(SUM[12]));
  OR2D1HVT U1_B_10_C1 (.A1(carry_10), .A2(A[10]), .Z(carry_11));
  XNR2D1HVT U1_A_10_C1 (.A1(carry_10), .A2(A[10]), .ZN(SUM[10]));
  XNR2D1HVT U1_A_13_C1 (.A1(carry_13), .A2(A[13]), .ZN(SUM[13]));
  XNR2D1HVT U1_A_3_C1 (.A1(carry_3), .A2(A[3]), .ZN(SUM[3]));
  OR2D1HVT U1_B_3_C1 (.A1(carry_3), .A2(A[3]), .Z(carry_4));
  INVD1HVT U6_C1 (.I(flencnt_0_1), .ZN(SUM[0]));
  OR2D1HVT U1_B_4_C1 (.A1(carry_4), .A2(A[4]), .Z(carry_5));
  IND2D1HVT U1_B_1_C1 (.A1(A[1]), .B1(SUM[0]), .ZN(carry_2));
  XNR2D1HVT U1_A_1_C1 (.A1(flencnt_1_1), .A2(flencnt_0_1), .ZN(SUM[1]));
  OR2D1HVT U1_B_8_C1 (.A1(carry_8), .A2(A[8]), .Z(carry_9));
  XNR2D1HVT U1_A_14_C1 (.A1(carry_14), .A2(A[14]), .ZN(SUM[14]));
  OR2D1HVT U1_B_12_C1 (.A1(carry_12), .A2(A[12]), .Z(carry_13));
  XNR2D1HVT U1_A_11_C1 (.A1(carry_11), .A2(A[11]), .ZN(SUM[11]));
  XNR2D1HVT U1_A_9_C1 (.A1(carry_9), .A2(A[9]), .ZN(SUM[9]));
  XNR2D1HVT U1_A_15_C1 (.A1(carry_15), .A2(A[15]), .ZN(SUM[15]));
  XNR2D1HVT U1_A_7_C1 (.A1(carry_7), .A2(A[7]), .ZN(SUM[7]));
  OR2D1HVT U1_B_6_C1 (.A1(carry_6), .A2(A[6]), .Z(carry_7));
  OR2D1HVT U1_B_14_C1 (.A1(carry_14), .A2(A[14]), .Z(carry_15));
  XNR2D1HVT U1_A_4_C1 (.A1(carry_4), .A2(A[4]), .ZN(SUM[4]));
  XNR2D1HVT U1_A_2_C1 (.A1(carry_2), .A2(A[2]), .ZN(SUM[2]));
  OR2D1HVT U1_B_2_C1 (.A1(carry_2), .A2(A[2]), .Z(carry_3));
endmodule

// Entity:bram_smc_DW01_dec_8_0 Model:bram_smc_DW01_dec_8_0 Library:L1
module bram_smc_DW01_dec_8_0 (A, SUM);
  input [7:0] A;
  output [7:0] SUM;
  wire carry_2, carry_3, carry_4, carry_5, carry_6, carry_7;
  XNR2D1HVT U1_A_4_C1 (.A1(carry_4), .A2(A[4]), .ZN(SUM[4]));
  XNR2D1HVT U1_A_1_C1 (.A1(A[1]), .A2(A[0]), .ZN(SUM[1]));
  OR2D1HVT U1_B_4_C1 (.A1(carry_4), .A2(A[4]), .Z(carry_5));
  XNR2D1HVT U1_A_2_C1 (.A1(carry_2), .A2(A[2]), .ZN(SUM[2]));
  OR2D1HVT U1_B_2_C1 (.A1(carry_2), .A2(A[2]), .Z(carry_3));
  XNR2D1HVT U1_A_3_C1 (.A1(carry_3), .A2(A[3]), .ZN(SUM[3]));
  OR2D1HVT U1_B_3_C1 (.A1(carry_3), .A2(A[3]), .Z(carry_4));
  IND2D1HVT U1_B_1_C1 (.A1(A[1]), .B1(SUM[0]), .ZN(carry_2));
  INVD1HVT U6_C1 (.I(A[0]), .ZN(SUM[0]));
  OR2D1HVT U1_B_5_C1 (.A1(carry_5), .A2(A[5]), .Z(carry_6));
  XNR2D1HVT U1_A_5_C1 (.A1(carry_5), .A2(A[5]), .ZN(SUM[5]));
  XNR2D1HVT U1_A_6_C1 (.A1(carry_6), .A2(A[6]), .ZN(SUM[6]));
  OR2D1HVT U1_B_6_C1 (.A1(carry_6), .A2(A[6]), .Z(carry_7));
  XNR2D1HVT U1_A_7_C1 (.A1(carry_7), .A2(A[7]), .ZN(SUM[7]));
endmodule

// Entity:bram_smc_DW01_inc_8_0 Model:bram_smc_DW01_inc_8_0 Library:L1
module bram_smc_DW01_inc_8_0 (A, SUM);
  input [7:0] A;
  output [7:0] SUM;
  wire carry_2, carry_3, carry_4, carry_5, carry_6, carry_7;
  HA1D1HVT U1_1_2 (.A(A[2]), .B(carry_2), .CO(carry_3), .S(SUM[2]));
  HA1D1HVT U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2), .S(SUM[1]));
  INVD1HVT U5_C1 (.I(A[0]), .ZN(SUM[0]));
  HA1D1HVT U1_1_4 (.A(A[4]), .B(carry_4), .CO(carry_5), .S(SUM[4]));
  CKXOR2D1HVT U6_C1 (.A1(carry_7), .A2(A[7]), .Z(SUM[7]));
  HA1D1HVT U1_1_5 (.A(A[5]), .B(carry_5), .CO(carry_6), .S(SUM[5]));
  HA1D1HVT U1_1_6 (.A(A[6]), .B(carry_6), .CO(carry_7), .S(SUM[6]));
  HA1D1HVT U1_1_3 (.A(A[3]), .B(carry_3), .CO(carry_4), .S(SUM[3]));
endmodule

// Entity:bstream_smc Model:bstream_smc Library:L1
module bstream_smc (clk, clk_b, rst_b, md_spi, smc_osc_fsel, sdi, sdo, 
     spi_ss_out_b_int, coldboot_sel, boot, warmboot_sel, cfg_ld_bstream, 
     cfg_startup, cfg_shutdown, spi_master_go, fpga_operation, nvcm_relextspi, 
     access_nvcm_reg, smc_load_nvcm_bstream, bp0, md_jtag, j_rst_b, 
     j_cfg_enable, j_cfg_disable, j_cfg_program, j_sft_dr, j_idcode_reg, 
     usercode_reg, cnt_podt_out, smc_podt_rst, smc_podt_off, smc_oscoff_b, 
     gint_hz, gio_hz, gwe, cdone_in, cdone_out, cm_monitor_cell, startup_req, 
     shutdown_req, cor_security_rddis, cor_security_wrtdis, cor_en_oscclk, 
     warmboot_req, reboot_source_nvcm, cor_en_8bconfig, en_8bconfig_b, 
     en_daisychain_cfg, baddr, framelen, framenum, start_framenum, 
     tm_dis_cram_clk_gating, cram_wrt, cram_rd, cm_sdo_u0, cm_sdo_u1, cm_sdo_u2, 
     cm_sdo_u3, cram_reading, cram_done, tm_dis_bram_clk_gating, bram_wrt, 
     bram_rd, bm_bank_sdo, bram_reading, bram_done, spi_clk_out_15, 
     spi_clk_out_18, sdi_2, cor_security_wrtdis_1, usercode_reg_25_1, 
     cor_security_rddis_1, clk_b_2, spi_clk_out_16, spi_clk_out_14, 
     fpga_operation_1, cor_en_oscclk_2, cfg_ld_bstream_1, spi_master_go_3, 
     spi_ss_out_b_int_1, spi_clk_out_12, spi_clk_out_19, spi_clk_out_20, 
     spi_clk_out_17, usercode_reg_16_1, usercode_reg_6_1, usercode_reg_1_1, 
     spi_clk_out_6, cor_en_8bconfig_1, md_jtag_1, spi_clk_out_21);
  input clk, clk_b, rst_b, md_spi, sdi, boot, cfg_ld_bstream, cfg_startup, 
     cfg_shutdown, spi_master_go, fpga_operation, nvcm_relextspi, 
     smc_load_nvcm_bstream, bp0, md_jtag, j_rst_b, j_cfg_enable, j_cfg_disable, 
     j_cfg_program, j_sft_dr, cnt_podt_out, smc_oscoff_b, gint_hz, gio_hz, gwe, 
     cdone_in, cdone_out, cram_reading, cram_done, bram_reading, bram_done, 
     spi_clk_out_15, spi_clk_out_18, sdi_2, cor_security_wrtdis_1, 
     usercode_reg_25_1, cor_security_rddis_1, clk_b_2, spi_clk_out_16, 
     spi_clk_out_14, fpga_operation_1, cor_en_oscclk_2, cfg_ld_bstream_1, 
     spi_master_go_3, spi_ss_out_b_int_1, spi_clk_out_12, spi_clk_out_19, 
     spi_clk_out_20, spi_clk_out_17, usercode_reg_16_1, usercode_reg_6_1, 
     usercode_reg_1_1, spi_clk_out_6, cor_en_8bconfig_1, md_jtag_1, 
     spi_clk_out_21;
  output spi_ss_out_b_int, access_nvcm_reg, smc_podt_rst, smc_podt_off, 
     startup_req, shutdown_req, cor_security_rddis, cor_security_wrtdis, 
     cor_en_oscclk, warmboot_req, reboot_source_nvcm, cor_en_8bconfig, 
     en_8bconfig_b, en_daisychain_cfg, tm_dis_cram_clk_gating, cram_wrt, 
     cram_rd, tm_dis_bram_clk_gating, bram_wrt, bram_rd;
  input [1:0] coldboot_sel;
  input [1:0] warmboot_sel;
  input [31:0] j_idcode_reg;
  input [3:0] cm_monitor_cell;
  input [1:0] cm_sdo_u0;
  input [1:0] cm_sdo_u1;
  input [1:0] cm_sdo_u2;
  input [1:0] cm_sdo_u3;
  input [3:0] bm_bank_sdo;
  output [1:0] smc_osc_fsel;
  output [7:0] sdo;
  output [31:0] usercode_reg;
  output [1:0] baddr;
  output [15:0] framelen;
  output [7:0] framenum;
  output [7:0] start_framenum;
  wire baddr_1_1, Uc_0_, Uc_1_, Uc_2_, Uc_3_, add_733_carry_2, bitstream_err, 
     bm_smc_sdo_en, bm_smc_sdo_en_int, bm_smc_sdo_en_int_d1, 
     bm_smc_sdo_en_int_d2, bm_smc_sdo_en_int_d3, bram_rd477, bram_wrt471, 
     bs_smc_sdio_en, bs_smc_sdo_en, bs_smc_sdo_en_reg, bs_state_0_, bs_state_1_, 
     bs_state_2_, bs_state_3_, cm_smc_sdo_en_int_d1, cm_smc_sdo_en_int_d2, 
     cm_smc_sdo_en_int_d3, cmdcode_byte_0, cmdcode_err, cmdhead_cnt_0, 
     cmdhead_cnt_ld, cmdhead_reg_0, cmdhead_reg_1, cmdhead_reg_2, cmdhead_reg_3, 
     cmdreg_code_0_, cmdreg_code_1_, cmdreg_code_2_, cmdreg_code_3_, cmdreg_err, 
     cor_dis_flashpd, cor_en_coldboot, cor_en_rdcrc, cor_en_warmboot, 
     cram_rd465, cram_wrt459, crc16_en, crc_data_in, crc_err, crc_reg_0_, 
     crc_reg_10_, crc_reg_11_, crc_reg_12_, crc_reg_13_, crc_reg_14_, 
     crc_reg_15_, crc_reg_1_, crc_reg_2_, crc_reg_3_, crc_reg_4_, crc_reg_5_, 
     crc_reg_6_, crc_reg_7_, crc_reg_8_, crc_reg_9_, idcode_err, idcode_err1521, 
     md_jtag_r, n2882, n2883, n2885, n2886, n2889, n2891, n2894, n2895, n2896, 
     n2897, n2898, n2899, n2900, n2901, n2902, n2903, n2905, n2906, n2907, 
     n2908, n2909, n2910, n2911, n2912, n2913, n2914, n2915, n2916, n2917, 
     n2918, n2919, n2920, n2921, n2922, n2923, n2924, n2925, n2926, n2927, 
     n2928, n2929, n2930, n2931, n2932, n2933, n2934, n2935, n2936, n2937, 
     n2938, n2939, n2940, n2941, n2942, n2943, n2945, n2946, n2948, n2949, 
     n2950, n2951, n2952, n2954, n2956, n2958, n2959, n2960, n2961, n2962, 
     n2963, n2964, n2965, n2966, n2967, n2968, n2969, n2970, n2971, n2972, 
     n2973, n2974, n2975, n2976, n2977, n2978, n2979, n2980, n2981, n2982, 
     n2983, n2984, n2985, n2986, n2988, n2989, n2992, n2993, n2994, n2995, 
     n2996, n2997, n2998, n3000, n3001, n3002, n3003, n3004, n3005, n3006, 
     n3007, n3008, n3009, n3010, n3011, n3012, n3013, n3015, n3016, n3017, 
     n3018, n3019, n3020, n3021, n3022, n3023, n3024, n3025, n3026, n3027, 
     n3030, n3031, n3032, n3033, n3034, n3055, n3057, n3069, n3070, n3071, 
     n3072, n3073, n3074, n3076, n3079, n3080, n3081, n3085, n3087, n3089, 
     n3090, n3091, n3092, n3093, n3094, n3096, n3097, n3098, n3100, n3101, 
     n3102, n3106, n3107, n3108, n3113, n3115, n3117, n3118, n3119, n3127, 
     n3132, n3133, n3134, n3136, n3137, n3138, n3139, n3140, n3142, n3143, 
     n3144, n3145, n3146, n3147, n3148, n3150, n3152, n3155, n3157, n3158, 
     n3160, n3162, n3164, n3167, n3168, n3169, n3171, n3174, n3175, n3176, 
     n3177, n3178, n3179, n3180, n3181, n3182, n3183, n3184, n3185, n3186, 
     n3187, n3189, n3190, n3191, n3192, n3194, n3195, n3197, n3199, n3200, 
     n3201, n3202, n3203, n970_0, n_1530, n_1810, n_1836, n_1926, n_3904, 
     n_3905, n_5113, n_5197, sdi_d1, sdo_r_0, sdo_rx_0_, sdo_rx_1_, sdo_rx_2_, 
     sdo_rx_3_, sdo_rx_4_, sdo_rx_6_, sio_data_reg_1, sio_data_reg_10, 
     sio_data_reg_11, sio_data_reg_12, sio_data_reg_13, sio_data_reg_14, 
     sio_data_reg_15, sio_data_reg_16, sio_data_reg_17, sio_data_reg_18, 
     sio_data_reg_19, sio_data_reg_2, sio_data_reg_20, sio_data_reg_21, 
     sio_data_reg_22, sio_data_reg_23, sio_data_reg_24, sio_data_reg_25, 
     sio_data_reg_26, sio_data_reg_27, sio_data_reg_28, sio_data_reg_29, 
     sio_data_reg_3, sio_data_reg_30, sio_data_reg_31, sio_data_reg_4, 
     sio_data_reg_5, sio_data_reg_6, sio_data_reg_7, sio_data_reg_8, 
     sio_data_reg_9, smc_podt_rst1100, spi_ldbstream_trycnt1054_1, 
     spi_ldbstream_trycnt_0_, spi_ldbstream_trycnt_1_, spi_rd_cmdaddr_0, 
     spi_rd_cmdaddr_1, spi_rd_cmdaddr_10, spi_rd_cmdaddr_11, spi_rd_cmdaddr_12, 
     spi_rd_cmdaddr_13, spi_rd_cmdaddr_14, spi_rd_cmdaddr_15, spi_rd_cmdaddr_16, 
     spi_rd_cmdaddr_17, spi_rd_cmdaddr_18, spi_rd_cmdaddr_19, spi_rd_cmdaddr_2, 
     spi_rd_cmdaddr_21, spi_rd_cmdaddr_22, spi_rd_cmdaddr_24, spi_rd_cmdaddr_25, 
     spi_rd_cmdaddr_26, spi_rd_cmdaddr_27, spi_rd_cmdaddr_28, spi_rd_cmdaddr_29, 
     spi_rd_cmdaddr_3, spi_rd_cmdaddr_30, spi_rd_cmdaddr_31, spi_rd_cmdaddr_4, 
     spi_rd_cmdaddr_5, spi_rd_cmdaddr_6, spi_rd_cmdaddr_7, spi_rd_cmdaddr_8, 
     spi_rd_cmdaddr_9, spi_rd_cmdaddr_reg_0, spi_rd_cmdaddr_reg_10, 
     spi_rd_cmdaddr_reg_11, spi_rd_cmdaddr_reg_12, spi_rd_cmdaddr_reg_13, 
     spi_rd_cmdaddr_reg_14, spi_rd_cmdaddr_reg_15, spi_rd_cmdaddr_reg_17, 
     spi_rd_cmdaddr_reg_18, spi_rd_cmdaddr_reg_2, spi_rd_cmdaddr_reg_20, 
     spi_rd_cmdaddr_reg_3, spi_rd_cmdaddr_reg_4, spi_rd_cmdaddr_reg_5, 
     spi_rd_cmdaddr_reg_6, spi_rd_cmdaddr_reg_7, spi_rd_cmdaddr_reg_9, 
     spi_rd_cmdaddr_reg_Q2106_22, spi_rxpreamble_trycnt969_0, 
     spi_rxpreamble_trycnt969_1, spi_rxpreamble_trycnt969_2, 
     spi_rxpreamble_trycnt971_1, spi_rxpreamble_trycnt_0_, 
     spi_rxpreamble_trycnt_1_, spi_rxpreamble_trycnt_2_, spi_tx_done, 
     sr_datacnt_0, tm_en_cram_blsr_test, val2426_21, val2426_24, warmboot_int, 
     warmboot_sel_int_0_, warmboot_sel_int_1_, U1466_N3, U1131_N4, U1452_N5, 
     U1173_N6, U1382_N3, U1153_N5, ctrlopt_reg9_9__N12, ctrlopt_reg9_9__N13, 
     cmdreg_err_reg_N13, stop_crc_reg_IQ, stop_crc_reg_N13, 
     ctrlopt_reg9_12__N12, ctrlopt_reg9_12__N13, U1146_N5, U1297_N3, 
     ctrlopt_reg4_7__N13, U1232_N3, spi_rxpreamble_trycnt_inc_reg_IQ, 
     ctrlopt_reg2_2__IQ, U1491_N7, U1290_N4, U1349_N6, U1298_N3, 
     cmdcode_err_reg_N13, U1483_N5, smc_podt_off_reg_N13, U1479_N5, U1241_N3, 
     U1381_N3, ctrlopt_reg9_10__N12, ctrlopt_reg9_10__N13, U1486_N5, U1289_N5, 
     U1224_N5, U1177_N5, ctrlopt_reg9_11__N12, ctrlopt_reg9_11__N13, U1312_N7, 
     clk_1, n2995_1, bs_state_3_1, bs_state_1_1, cmdreg_code_2_1, 
     cmdreg_code_0_1, n2883_1, n3085_1, n2989_1, n3073_1, sio_data_reg_32, 
     sio_data_reg_33, sio_data_reg_34, sio_data_reg_35, sio_data_reg_36, 
     sio_data_reg_37, cmdcode_byte_1, n2986_1, sio_data_reg_38, n3097_1, 
     n3090_1, n2983_1, n2997_1, n3117_1, cmdreg_code_3_1, n3106_1, n3031_1, 
     md_spi_1, sr_datacnt_1, bs_state_2_1, n2985_1, n2907_1, n2948_1, n3152_1, 
     n2946_1, n3115_1, n2980_1, stop_crc_reg_IQ_1, n2900_1, coldboot_sel_0_1, 
     cor_en_8bconfig_2, n2993_1, bram_done_1, n2981_1, cmdreg_code_1_1, 
     cor_en_rdcrc_1, cm_smc_sdo_en_1, sio_data_reg_39, n3153_1, n3197_1, N4455, 
     N4300, N3759, N574, N576, n2982_1, n3000_1, rst_b_1, rst_b_2, rst_b_3, 
     rst_b_4, n2982_2, n3000_2, smc_write_3, smc_read_3, n3119_1, n2951_1, 
     n3115_2, cram_wrt459_1, sdo_rx_4_1, cmdreg_code_0_2, cmdreg_code_1_2, 
     cmdcode_byte_2, cmdcode_byte_3, sio_data_reg_40, sio_data_reg_41, n3197_2, 
     cmdreg_code_3_2, sio_data_reg_42, sio_data_reg_43, sio_data_reg_44, 
     sio_data_reg_45, N576_1, sio_data_reg_46, sio_data_reg_47, sio_data_reg_48, 
     n3087_1, sio_data_reg_49, sio_data_reg_50, sio_data_reg_51, 
     sio_data_reg_52, sio_data_reg_53, sio_data_reg_54, sio_data_reg_55, 
     cmdreg_code_2_2, sio_data_reg_56, sio_data_reg_57, sio_data_reg_58, 
     sio_data_reg_59, sio_data_reg_60, sio_data_reg_61, sio_data_reg_62, 
     sio_data_reg_63, sio_data_reg_64, sio_data_reg_65, sio_data_reg_66, 
     sio_data_reg_67, sio_data_reg_68, sio_data_reg_69, sio_data_reg_70, 
     sio_data_reg_71, sio_data_reg_72, sio_data_reg_73, sio_data_reg_74, 
     sio_data_reg_75, n_1927, crc_reg_11_1, crc_reg_10_1, crc_reg_9_1, 
     crc_reg_14_1, crc_reg_8_1, crc_reg_13_1, crc_reg_3_1, crc_reg_7_1, 
     crc_reg_1_1, crc_reg_2_1, sio_data_reg_76, sio_data_reg_77, crc_reg_6_1, 
     spi_ldbstream_trycnt_0_1, spi_ldbstream_trycnt_0_2, sio_data_reg_78, 
     sio_data_reg_79, sio_data_reg_80, cmdhead_reg_4, cmdhead_reg_5, 
     cmdhead_reg_6, cmdhead_reg_7, cmdhead_reg_8, cmdhead_reg_9, 
     bm_smc_sdo_en_int_d3_1, bm_smc_sdo_en_int_d3_2, bm_smc_sdo_en_int_d2_1, 
     bm_smc_sdo_en_int_d2_2, cm_smc_sdo_en_int_d2_1, cm_smc_sdo_en_int_d2_2, 
     bm_smc_sdo_en_int_d1_1, bm_smc_sdo_en_int_d1_2, cm_smc_sdo_en_int_d1_1, 
     cm_smc_sdo_en_int_d1_2, cm_smc_sdo_en_int_d1_3, cm_smc_sdo_en_int_d3_1, 
     cm_smc_sdo_en_int_d3_2, cmdhead_reg_10, spi_rd_cmdaddr_reg_1, 
     spi_ldbstream_trycnt1054_2, n2902_1, n2975_1, tm_en_cram_blsr_test_1, 
     tm_en_cram_blsr_test_2, n2882_1, smc_podt_off_reg_N13_1, 
     ctrlopt_reg4_7__N13_1, ctrlopt_reg9_11__N13_1, ctrlopt_reg9_12__N13_1, 
     ctrlopt_reg9_10__N13_1, ctrlopt_reg9_9__N13_1, n3071_1, n3072_1, n3070_1, 
     stop_crc_reg_N13_1, cmdreg_err_reg_N13_1, cmdcode_err_reg_N13_1, 
     bm_smc_sdo_en_int_1, n3069_1, U1349_N6_1, spi_rxpreamble_trycnt969_3, 
     spi_rxpreamble_trycnt969_4, spi_rxpreamble_trycnt969_5, sdo_rx_0_1, 
     cmdcode_err_1, cmdreg_err_1, crc_reg_12_1, spi_rd_cmdaddr_32, 
     spi_rd_cmdaddr_33, spi_rd_cmdaddr_34, spi_rxpreamble_trycnt_0_1, 
     spi_rxpreamble_trycnt_2_1, stop_crc_reg_IQ_2, spi_ldbstream_trycnt_1_1, 
     sio_data_reg_81, sio_data_reg_82, sio_data_reg_83, sio_data_reg_84, 
     sio_data_reg_85, sio_data_reg_86, sio_data_reg_87, sio_data_reg_88, 
     sio_data_reg_89, sio_data_reg_90, sio_data_reg_91, sio_data_reg_92, 
     sio_data_reg_93, cm_smc_sdo_en_int_d2_3, cm_smc_sdo_en_int_d1_4, 
     cm_smc_sdo_en_int_d3_3, bm_smc_sdo_en_int_d1_3, bm_smc_sdo_en_int_d3_3, 
     bm_smc_sdo_en_int_d2_3, cmdhead_reg_11, cmdhead_reg_12, sio_data_reg_94, 
     cmdhead_reg_13, sio_data_reg_95, sio_data_reg_96, cmdhead_reg_14, 
     cmdreg_code_2_3, cmdreg_code_0_3, cmdreg_code_3_3, n3155_1, n3087_2, 
     cmdreg_code_2_4, cmdreg_code_1_3, cmdreg_code_3_4, n_1531, n3009_1, N576_2, 
     n2993_2, sio_data_reg_97, sio_data_reg_98, sio_data_reg_99, 
     sio_data_reg_100, sio_data_reg_101, sio_data_reg_102, sio_data_reg_103, 
     n3115_3, sio_data_reg_104, sio_data_reg_105, sio_data_reg_106, 
     sio_data_reg_107, sio_data_reg_108, sio_data_reg_109, sio_data_reg_110, 
     sio_data_reg_111, n3162_1, spi_rxpreamble_trycnt_0_2, sio_data_reg_112, 
     sio_data_reg_113, sio_data_reg_114, sio_data_reg_115, sio_data_reg_116, 
     sio_data_reg_117, sio_data_reg_118, sio_data_reg_119, sio_data_reg_120, 
     sio_data_reg_121, sio_data_reg_122, sio_data_reg_123, sio_data_reg_124, 
     sio_data_reg_125, sio_data_reg_126, stop_crc_reg_IQ_3, bs_state_2_2, 
     sio_data_reg_127, sio_data_reg_128, sio_data_reg_129, sio_data_reg_130, 
     sio_data_reg_131, sio_data_reg_132, crc_reg_10_2, n3085_2, crc_reg_1_2, 
     crc_reg_2_2, crc_reg_8_2, crc_reg_12_2, spi_rd_cmdaddr_35, 
     spi_rd_cmdaddr_36, crc_reg_5_1, sio_data_reg_133, sio_data_reg_134, 
     sio_data_reg_135, sio_data_reg_136, cor_dis_flashpd_1, sio_data_reg_137, 
     spi_rxpreamble_trycnt_1_1, N4300_1, N3759_1, N574_1, N4455_1, 
     cm_smc_sdo_en_int_d3_4, cm_smc_sdo_en_int_d1_5, crc_reg_13_2, 
     bm_smc_sdo_en_int_d1_4, bm_smc_sdo_en_int_d1_5, 
     spi_rd_cmdaddr_reg_Q2106_23, cm_smc_sdo_en_int_d2_4, 
     cm_smc_sdo_en_int_d2_5, cmdhead_reg_15, cmdhead_reg_16, 
     spi_rd_cmdaddr_reg_19, bm_smc_sdo_en_int_d2_4, bm_smc_sdo_en_int_d2_5, 
     bm_smc_sdo_en_int_d3_4, spi_ldbstream_trycnt_0_3, cmdhead_reg_17, 
     spi_ldbstream_trycnt_1_2, spi_ldbstream_trycnt_1_3, cmdhead_reg_18, 
     cmdhead_reg_19, smc_podt_rst1100_1, crc_reg_8_3, n2882_2, n2882_3, n2979_1, 
     smc_podt_off_reg_N13_2, ctrlopt_reg4_7__N13_2, ctrlopt_reg4_7__N13_3, 
     n_3906, ctrlopt_reg9_11__N13_2, n3071_2, n3070_2, n3002_1, 
     cmdcode_err_reg_N13_2, cmdcode_err_reg_N13_3, cmdreg_err_reg_N13_2, 
     n3018_1, n3016_1, n3007_1, crc_reg_4_1, crc_reg_9_2, crc_reg_3_2, 
     crc_reg_0_1, tm_en_cram_blsr_test_3, n3199_1, cmdreg_code_2_5, 
     bm_smc_sdo_en_int_d3_5, VDD_magmatienet_0, VDD_magmatienet_1, 
     VDD_magmatienet_2, VDD_magmatienet_3, VDD_magmatienet_4, VDD_magmatienet_5, 
     VDD_magmatienet_6, VDD_magmatienet_7, VDD_magmatienet_8, VSS_magmatienet_0, 
     VSS_magmatienet_1, VSS_magmatienet_2, VSS_magmatienet_3, VSS_magmatienet_4, 
     VSS_magmatienet_5, VSS_magmatienet_6, VSS_magmatienet_7, VSS_magmatienet_8, 
     VSS_magmatienet_9, VSS_magmatienet_10, VSS_magmatienet_11, 
     VSS_magmatienet_12, VSS_magmatienet_13, VSS_magmatienet_14, 
     VSS_magmatienet_15, VSS_magmatienet_16, VSS_magmatienet_17, 
     VSS_magmatienet_18, VSS_magmatienet_19, VSS_magmatienet_20, 
     VSS_magmatienet_21, VSS_magmatienet_22, sio_data_reg_138, sio_data_reg_139, 
     sio_data_reg_140, sio_data_reg_141, sio_data_reg_142, sio_data_reg_143, 
     cm_smc_sdo_en_int_d1_6, N576_3, sio_data_reg_144, rst_b_5, rst_b_6, 
     sio_data_reg_145, sio_data_reg_146, sio_data_reg_147, sio_data_reg_148;
  BUFFD1HVT OPTHOLD_G_118 (.I(crc_reg_3_), .Z(crc_reg_3_1));
  XNR2D1HVT U1250_C1 (.A1(sio_data_reg_7), .A2(crc_reg_7_), .ZN(n2961));
  BUFFD1HVT OPTHOLD_G_771 (.I(sio_data_reg_5), .Z(sio_data_reg_136));
  TIELHVT VSS_magmatiecell_11 (.ZN(VSS_magmatienet_11));
  serial_crc CRC16 (.clk(), .rst_b(rst_b), .enable(crc16_en), .init(n2988), 
     .data_in(crc_data_in), .crc_out({crc_reg_15_, crc_reg_14_, crc_reg_13_, 
     crc_reg_12_, crc_reg_11_, crc_reg_10_, crc_reg_9_, crc_reg_8_, crc_reg_7_, 
     crc_reg_6_, crc_reg_5_, crc_reg_4_, crc_reg_3_, crc_reg_2_, crc_reg_1_, 
     crc_reg_0_}), .crc_reg_3_1(crc_reg_3_1), .crc_reg_3_2(crc_reg_3_2), 
     .crc_reg_2_2(crc_reg_2_2), .crc_reg_4_1(crc_reg_4_1), 
     .crc_reg_1_2(crc_reg_1_2), .spi_clk_out_10(spi_clk_out_18), 
     .crc_reg_12_1(crc_reg_12_1), .crc_reg_11_1(crc_reg_11_1), 
     .crc_reg_9_2(crc_reg_9_2), .crc_reg_9_1(crc_reg_9_1), 
     .crc_reg_8_2(crc_reg_8_2), .crc_reg_10_2(crc_reg_10_2), 
     .crc_reg_6_1(crc_reg_6_1), .crc_reg_14_1(crc_reg_14_1), 
     .crc_reg_13_2(crc_reg_13_2), .crc_reg_13_1(crc_reg_13_1), 
     .crc_reg_5_1(crc_reg_5_1), .crc_reg_7_1(crc_reg_7_1), 
     .spi_clk_out_8(spi_clk_out_16));
  EDFCND1HVT framelen_reg_15_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_108), .E(n3199_1), .Q(framelen[15]), .QN());
  INVD1HVT U1464_C2_MP_INV (.I(n2907), .ZN(n2907_1));
  NR2D1HVT U1382_C2 (.A1(n2997), .A2(U1382_N3), .ZN(n3030));
  NR3D1HVT U1238_C2_INV (.A1(n3117), .A2(cmdreg_code_3_4), .A3(cmdreg_code_1_3), 
     .ZN(n2951_1));
  NR2D1HVT U1177_C3 (.A1(idcode_err1521), .A2(U1177_N5), .ZN(n2905));
  INVD1HVT U1240_C3_MP_INV_2 (.I(sio_data_reg_5), .ZN(sio_data_reg_36));
  BUFFD1HVT OPTHOLD_G_289 (.I(cmdhead_reg_9), .Z(cmdhead_reg_8));
  BUFFD3HVT BW2_BUF4994 (.I(sio_data_reg_142), .Z(sio_data_reg_148));
  BUFFD1HVT OPTHOLD_G_381 (.I(smc_podt_off_reg_N13), .Z(smc_podt_off_reg_N13_1));
  NR2D1HVT U1165_C1 (.A1(n2900_1), .A2(n2897), .ZN(spi_rd_cmdaddr_1));
  EDFCND1HVT usercode_reg_reg_13_ (.CDN(rst_b_5), .CP(spi_clk_out_12), 
     .D(sio_data_reg_148), .E(n2982_2), .Q(usercode_reg[13]), .QN());
  BUFFD1HVT OPTHOLD_G_555 (.I(sio_data_reg_132), .Z(sio_data_reg_89));
  BUFFD1HVT OPTHOLD_G_669 (.I(sio_data_reg_92), .Z(sio_data_reg_121));
  BUFFD1HVT OPTHOLD_G_662 (.I(sio_data_reg_87), .Z(sio_data_reg_114));
  BUFFD1HVT OPTHOLD_G_341 (.I(spi_rd_cmdaddr_reg_0), .Z(spi_rd_cmdaddr_reg_1));
  EDFCND1HVT usercode_reg_reg_14_ (.CDN(rst_b_5), .CP(spi_clk_out_12), 
     .D(sio_data_reg_147), .E(n2982_2), .Q(usercode_reg[14]), .QN());
  BUFFD1HVT OPTHOLD_G_932 (.I(n2979), .Z(n2979_1));
  EDFCND1HVT start_framenum_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_20), 
     .D(sio_data_reg_101), .E(n_1531), .Q(start_framenum[6]), .QN());
  AO221D1HVT U1337_C3 (.A1(n2903), .A2(baddr[1]), .B1(n3169), .B2(N576), 
     .C(U1173_N6), .Z(n3168));
  BUFFD1HVT OPTHOLD_G_558 (.I(sio_data_reg_61), .Z(sio_data_reg_92));
  XNR2D1HVT U1207_C1 (.A1(sio_data_reg_15), .A2(VSS_magmatienet_16), .ZN(n2927));
  TIELHVT VSS_magmatiecell_19 (.ZN(VSS_magmatienet_19));
  INVD1HVT U1336_C4_MP_INV (.I(cor_en_8bconfig_1), .ZN(cor_en_8bconfig_2));
  XNR2D1HVT U1212_C1 (.A1(sio_data_reg_30), .A2(VSS_magmatienet_1), .ZN(n2931));
  INR2D1HVT U1329_C1 (.A1(cm_sdo_u3[0]), .B1(N576_3), .ZN(sdo_rx_6_));
  MUX3D1HVT U1336_C4 (.I0(cm_sdo_u0[0]), .I1(bm_bank_sdo[0]), .I2(n3168), 
     .S0(N576_2), .S1(cor_en_8bconfig_2), .Z(sdo_rx_0_));
  BUFFD1HVT OPTHOLD_G_75 (.I(n_1926), .Z(n_1927));
  INVD1HVT U1271_C1_MP_INV (.I(n2900), .ZN(n2900_1));
  BUFFD3HVT BW2_BUF3113 (.I(rst_b_4), .Z(rst_b_5));
  EDFCND1HVT framenum_reg_7_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_145), .E(n3009_1), .Q(framenum[7]), .QN());
  BUFFD1HVT OPTHOLD_G_55 (.I(sio_data_reg_23), .Z(sio_data_reg_65));
  TIELHVT VSS_magmatiecell_5 (.ZN(VSS_magmatienet_5));
  CKMUX2D2HVT U1129_C4 (.I0(spi_rd_cmdaddr_33), .I1(sio_data_reg_133), 
     .S(n3000_2), .Z(n3070));
  XNR2D1HVT U1192_C1 (.A1(sio_data_reg_4), .A2(VDD_magmatienet_3), .ZN(n2915));
  TIEHHVT VDD_magmatiecell_3 (.Z(VDD_magmatienet_3));
  BUFFD3HVT OPTHOLD_G_5 (.I(sio_data_reg_138), .Z(sio_data_reg_40));
  BUFFD1HVT OPTHOLD_G_50 (.I(sio_data_reg_26), .Z(sio_data_reg_60));
  TIEHHVT VDD_magmatiecell_5 (.Z(VDD_magmatienet_5));
  AO221D1HVT U1312_C4 (.A1(cm_monitor_cell[1]), .A2(Uc_1_), 
     .B1(cm_monitor_cell[2]), .B2(Uc_2_), .C(U1312_N7), .Z(n3080));
  EDFCND1HVT usercode_reg_reg_29_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(sio_data_reg_85), .E(n2982_2), .Q(usercode_reg[29]), .QN());
  AN3D1HVT U1146_C2 (.A1(sio_data_reg_5), .A2(sio_data_reg_30), 
     .A3(sio_data_reg_23), .Z(U1146_N5));
  NR2D1HVT U1171_C1 (.A1(n3106), .A2(n3090), .ZN(n2901));
  AO32D1HVT U1485_C4 (.A1(warmboot_sel_int_1_), .A2(warmboot_sel_int_0_), 
     .A3(warmboot_req), .B1(spi_rd_cmdaddr_reg_7), .B2(n2900), .Z(n3091));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_6_ (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(sio_data_reg_101), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_6), .QN());
  AO31D1HVT U1447_C3 (.A1(n3026), .A2(coldboot_sel[1]), .A3(coldboot_sel[0]), 
     .B(n3091), .Z(spi_rd_cmdaddr_7));
  BUFFD1HVT OPTHOLD_G_592 (.I(cmdhead_reg_18), .Z(cmdhead_reg_14));
  BUFFD1HVT OPTHOLD_G_906 (.I(spi_ldbstream_trycnt_0_1), 
     .Z(spi_ldbstream_trycnt_0_3));
  DFCNQD1HVT startup_req_reg (.CDN(rst_b_6), .CP(spi_clk_out_15), .D(n3001), 
     .Q(startup_req));
  NR2D1HVT U1274_C1 (.A1(spi_rxpreamble_trycnt_0_1), .A2(n2989), 
     .ZN(spi_rxpreamble_trycnt969_0));
  HA1D1HVT add_733_U1_1_1 (.A(spi_rxpreamble_trycnt_1_1), 
     .B(spi_rxpreamble_trycnt_0_2), .CO(add_733_carry_2), 
     .S(spi_rxpreamble_trycnt971_1));
  OR4XD1HVT U1476_C3 (.A1(sio_data_reg_22), .A2(sio_data_reg_20), 
     .A3(sio_data_reg_18), .A4(sio_data_reg_16), .Z(n3186));
  BUFFD1HVT OPTHOLD_G_53 (.I(sio_data_reg_64), .Z(sio_data_reg_63));
  EDFCND1HVT start_framenum_reg_4_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_99), .E(n_1531), .Q(start_framenum[4]), .QN());
  BUFFD1HVT OPTHOLD_G_880 (.I(crc_reg_13_1), .Z(crc_reg_13_2));
  INVD1HVT U1324_C2_MP_INV (.I(sio_data_reg_31), .ZN(sio_data_reg_39));
  XNR2D1HVT U1265_C1 (.A1(sio_data_reg_8), .A2(crc_reg_8_), .ZN(n2973));
  INVD1HVT U1487_C2_MP_INV (.I(cmdreg_code_0_), .ZN(cmdreg_code_0_1));
  NR2D3HVT U1340_C1 (.A1(n3155_1), .A2(cmdreg_code_0_1), .ZN(n3009));
  INVD1HVT U1435_C3_MP_INV (.I(cor_en_rdcrc), .ZN(cor_en_rdcrc_1));
  BUFFD1HVT OPTHOLD_G_83 (.I(crc_reg_11_), .Z(crc_reg_11_1));
  BUFFD1HVT OPTHOLD_G_673 (.I(sio_data_reg_67), .Z(sio_data_reg_125));
  CKAN2D1HVT U1148_C1 (.A1(n2994), .A2(cfg_ld_bstream_1), .Z(n3001));
  OA32D1HVT U1136_C4 (.A1(n3085_1), .A2(n3005), .A3(n2885), .B1(n3089), 
     .B2(n2983), .Z(n3107));
  NR2D1HVT U1158_C1 (.A1(n3127), .A2(n2905), .ZN(n2886));
  NR2D1HVT U1366_C1 (.A1(n3142), .A2(n3090), .ZN(n3003));
  BUFFD8HVT BW1_BUF712 (.I(rst_b_1), .Z(rst_b_2));
  BUFFD1HVT OPTHOLD_G_723 (.I(crc_reg_1_1), .Z(crc_reg_1_2));
  BUFFD1HVT OPTHOLD_G_1008 (.I(n3007), .Z(n3007_1));
  BUFFD1HVT OPTHOLD_G_322 (.I(bm_smc_sdo_en_int_d1_5), 
     .Z(bm_smc_sdo_en_int_d1_2));
  BUFFD1HVT OPTHOLD_G_900 (.I(bm_smc_sdo_en_int_d2), .Z(bm_smc_sdo_en_int_d2_4));
  BUFFD1HVT OPTHOLD_G_902 (.I(bm_smc_sdo_en_int_d3_5), 
     .Z(bm_smc_sdo_en_int_d3_4));
  BUFFD8HVT BL1_R_BUF_1 (.I(smc_read_3), .Z(cram_rd));
  BUFFD1HVT OPTHOLD_G_593 (.I(cmdreg_code_2_2), .Z(cmdreg_code_2_3));
  DFCNQD1HVT ctrlopt_reg4_7_ (.CDN(rst_b_1), .CP(spi_clk_out_18), 
     .D(ctrlopt_reg4_7__N13_3), .Q(cor_security_wrtdis));
  EDFCND1HVT framelen_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_97), .E(n3199_1), .Q(framelen[2]), .QN());
  BUFFD1HVT OPTHOLD_G_1144 (.I(cmdreg_code_2_), .Z(cmdreg_code_2_5));
  BUFFD1HVT OPTHOLD_G_24 (.I(sio_data_reg_11), .Z(sio_data_reg_49));
  BUFFD1HVT OPTHOLD_G_546 (.I(spi_ldbstream_trycnt_1_2), 
     .Z(spi_ldbstream_trycnt_1_1));
  BUFFD1HVT OPTHOLD_G_973 (.I(cmdcode_err_reg_N13), .Z(cmdcode_err_reg_N13_2));
  INVD1HVT U1385_C2_MP_INV_1 (.I(n2980), .ZN(n2980_1));
  INVD1HVT U1372_C1_MP_INV (.I(n2981), .ZN(n2981_1));
  BUFFD4HVT BW1_BUF712_1 (.I(rst_b_2), .Z(rst_b_3));
  BUFFD1HVT OPTHOLD_G_339 (.I(cmdhead_reg_1), .Z(cmdhead_reg_10));
  DFCNQD1HVT bm_smc_sdo_en_int_d1_reg (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(bm_smc_sdo_en_int_1), .Q(bm_smc_sdo_en_int_d1));
  XNR2D1HVT U1470_C1 (.A1(n3073_1), .A2(n2993_1), .ZN(n3081));
  IAO21D1HVT U1453_C2 (.A1(n3152), .A2(n3023), .B(cram_done), .ZN(n3108));
  DFCNQD1HVT cmdreg_err_reg (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(cmdreg_err_reg_N13_1), .Q(cmdreg_err));
  BUFFD1HVT OPTHOLD_G_710 (.I(crc_reg_10_1), .Z(crc_reg_10_2));
  DFNCND1HVT ctrlopt_reg9_12_ (.CDN(rst_b_2), .CPN(clk_1), 
     .D(ctrlopt_reg9_12__N13_1), .Q(), .QN(N3759));
  ND3D1HVT U1452_C2 (.A1(sio_data_reg_1), .A2(n3106_1), .A3(cmdcode_byte_0), 
     .ZN(U1452_N5));
  INVD1HVT U1452_C2_MP_INV (.I(n3106), .ZN(n3106_1));
  EDFCNQD1HVT ctrlopt_reg7_4_ (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(sio_data_reg_99), .E(n3197_2), .Q(cor_en_coldboot));
  INVD1HVT U1456_C2_MP_INV (.I(cmdcode_byte_0), .ZN(cmdcode_byte_1));
  CKXOR2D1HVT U1430_C1 (.A1(spi_ldbstream_trycnt_0_3), .A2(n3034), .Z(n3069));
  AO211D1HVT U1489_C3 (.A1(n3031), .A2(n2905), .B(n3146), .C(n2943), .Z(n3160));
  CKAN2D1HVT U1227_C1 (.A1(sr_datacnt_0), .A2(n2949), .Z(n2943));
  IND3D1HVT U1455_C2 (.A1(cmdhead_cnt_0), .B1(sr_datacnt_0), .B2(n3115), 
     .ZN(n3117));
  IND3D1HVT U1224_C2 (.A1(n2943), .B1(n2941), .B2(n2942), .ZN(U1224_N5));
  AO211D1HVT U1484_C3 (.A1(spi_tx_done), .A2(n2883), .B(n3195), .C(n3147), 
     .Z(n3158));
  ND2D1HVT U1298_C1 (.A1(cmdreg_code_1_3), .A2(cmdreg_code_0_3), .ZN(U1298_N3));
  IND4D1HVT U1289_C2 (.A1(cmdhead_cnt_0), .B1(cmdreg_code_3_1), 
     .B2(cmdreg_code_1_2), .B3(U1290_N4), .ZN(U1289_N5));
  NR2D1HVT ctrlopt_reg9_9__C8 (.A1(n3197), .A2(N4455_1), 
     .ZN(ctrlopt_reg9_9__N12));
  XNR2D1HVT U1249_C1 (.A1(sio_data_reg_14), .A2(crc_reg_14_), .ZN(n2960));
  CKMUX2D2HVT U1130_C4 (.I0(spi_rd_cmdaddr_34), .I1(sio_data_reg_135), 
     .S(n3000_2), .Z(n3071));
  BUFFD3HVT BW2_BUF3113_1 (.I(rst_b_4), .Z(rst_b_6));
  EDFCND1HVT usercode_reg_reg_26_ (.CDN(rst_b_2), .CP(spi_clk_out_16), 
     .D(sio_data_reg_113), .E(n2982_2), .Q(usercode_reg[26]), .QN());
  EDFCND1HVT framelen_reg_14_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_147), .E(n3199), .Q(framelen[14]), .QN());
  BUFFD1HVT OPTHOLD_G_597 (.I(cmdreg_code_3_), .Z(cmdreg_code_3_3));
  INVD1HVT U1128_C4_MP_INV (.I(warmboot_req), .ZN(n3153_1));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_7_ (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(sio_data_reg_145), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_7), .QN());
  OA21D1HVT cmdreg_err_reg_C9 (.A1(n3024), .A2(cmdreg_err_1), .B(n2998), 
     .Z(cmdreg_err_reg_N13));
  OA21D1HVT cmdcode_err_reg_C9 (.A1(n3004), .A2(cmdcode_err_1), .B(n2998), 
     .Z(cmdcode_err_reg_N13));
  IIND4D1HVT U1236_C4 (.A1(cmdhead_reg_4), .A2(n2951), .B1(cmdhead_reg_8), 
     .B2(n2950), .ZN(n3118));
  BUFFD1HVT OPTHOLD_G_57 (.I(sio_data_reg_19), .Z(sio_data_reg_67));
  BUFFD1HVT OPTHOLD_G_645 (.I(sio_data_reg_15), .Z(sio_data_reg_111));
  BUFFD1HVT OPTHOLD_G_658 (.I(spi_rxpreamble_trycnt_0_), 
     .Z(spi_rxpreamble_trycnt_0_2));
  EDFCND1HVT usercode_reg_reg_10_ (.CDN(rst_b_5), .CP(spi_clk_out_15), 
     .D(sio_data_reg_109), .E(n2982_2), .Q(usercode_reg[10]), .QN());
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_20_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_126), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_20), .QN());
  BUFFD3HVT OPTHOLD_G_640 (.I(sio_data_reg_51), .Z(sio_data_reg_110));
  BUFFD1HVT OPTHOLD_G_553 (.I(sio_data_reg_123), .Z(sio_data_reg_87));
  BUFFD1HVT OPTHOLD_G_557 (.I(sio_data_reg_63), .Z(sio_data_reg_91));
  EDFCND1HVT usercode_reg_reg_11_ (.CDN(rst_b_5), .CP(spi_clk_out_12), 
     .D(sio_data_reg_106), .E(n2982_2), .Q(usercode_reg[11]), .QN());
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_14_ (.CDN(rst_b_5), .CP(spi_clk_out_6), 
     .D(sio_data_reg_147), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_14), .QN());
  INVD4HVT U1426_C1 (.I(n3055), .ZN(smc_osc_fsel[0]));
  TIELHVT VSS_magmatiecell_13 (.ZN(VSS_magmatienet_13));
  BUFFD1HVT OPTHOLD_G_660 (.I(sio_data_reg_81), .Z(sio_data_reg_112));
  BUFFD1HVT OPTHOLD_G_62 (.I(sio_data_reg_69), .Z(sio_data_reg_68));
  DFCNQD1HVT sdo_r_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_12), .D(sdo_rx_0_1), 
     .Q(sdo_r_0));
  TIELHVT VSS_magmatiecell_16 (.ZN(VSS_magmatienet_16));
  XNR2D1HVT U1222_C1 (.A1(sio_data_reg_16), .A2(VSS_magmatienet_18), .ZN(n2939));
  TIELHVT VSS_magmatiecell_17 (.ZN(VSS_magmatienet_17));
  TIELHVT VSS_magmatiecell_1 (.ZN(VSS_magmatienet_1));
  INR2D1HVT U1331_C2 (.A1(cm_sdo_u2[1]), .B1(N576_1), .ZN(n3201));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_21_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_120), .E(n3000_2), .Q(), .QN(n2976));
  EDFCND1HVT usercode_reg_reg_0_ (.CDN(rst_b_5), .CP(spi_clk_out_15), 
     .D(cmdcode_byte_2), .E(n2982_2), .Q(usercode_reg[0]), .QN());
  BUFFD1HVT OPTHOLD_G_521 (.I(cmdcode_err), .Z(cmdcode_err_1));
  EDFCND1HVT framenum_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_101), .E(n3009_1), .Q(framenum[6]), .QN());
  AN4D1HVT U1143_C3 (.A1(sio_data_reg_29), .A2(sio_data_reg_27), 
     .A3(sio_data_reg_19), .A4(sio_data_reg_17), .Z(n2956));
  BUFFD1HVT OPTHOLD_G_30 (.I(sio_data_reg_15), .Z(sio_data_reg_55));
  XNR2D1HVT U1197_C1 (.A1(sio_data_reg_3), .A2(VDD_magmatienet_1), .ZN(n2919));
  EDFCND1HVT testmode_reg_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_18), 
     .D(sio_data_reg_97), .E(n2992), .Q(Uc_2_), .QN());
  TIEHHVT VDD_magmatiecell_4 (.Z(VDD_magmatienet_4));
  XNR2D1HVT U1193_C1 (.A1(sio_data_reg_12), .A2(VDD_magmatienet_2), .ZN(n2916));
  BUFFD1HVT OPTHOLD_G_550 (.I(sio_data_reg_129), .Z(sio_data_reg_84));
  BUFFD1HVT OPTHOLD_F_1 (.I(sio_data_reg_46), .Z(sio_data_reg_139));
  XNR2D1HVT U1196_C1 (.A1(sio_data_reg_1), .A2(VSS_magmatienet_10), .ZN(n2918));
  TIELHVT VSS_magmatiecell_3 (.ZN(VSS_magmatienet_3));
  BUFFD1HVT OPTHOLD_G_67 (.I(sio_data_reg_18), .Z(sio_data_reg_73));
  AO211D1HVT U1463_C2 (.A1(n3097_1), .A2(n3090_1), .B(n2901), .C(n2899), 
     .Z(n3143));
  CKXOR2D1HVT U1469_C1 (.A1(coldboot_sel[1]), .A2(coldboot_sel[0]), .Z(n3093));
  CKAN2D1HVT U1417_C1 (.A1(spi_rd_cmdaddr_reg_3), .A2(n2900), 
     .Z(spi_rd_cmdaddr_3));
  BUFFD1HVT OPTHOLD_G_600 (.I(cmdreg_code_2_), .Z(cmdreg_code_2_4));
  BUFFD1HVT OPTHOLD_G_897 (.I(cmdhead_reg_11), .Z(cmdhead_reg_16));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_0_ (.CDN(rst_b_4), .CP(spi_clk_out_15), 
     .D(cmdcode_byte_2), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_0), .QN());
  INVD1HVT spi_rxpreamble_trycnt_inc_reg_MP_INV (.I(n2989), .ZN(n2989_1));
  BUFFD1HVT OPTHOLD_G_964 (.I(n3002), .Z(n3002_1));
  EDFCND1HVT spi_rxpreamble_trycnt_reg_2_ (.CDN(rst_b_6), .CP(spi_clk_out_15), 
     .D(spi_rxpreamble_trycnt969_4), .E(n970_0), .Q(spi_rxpreamble_trycnt_2_), 
     .QN());
  CKAN2D1HVT U1412_C1 (.A1(spi_rd_cmdaddr_reg_19), .A2(n2900), 
     .Z(spi_rd_cmdaddr_18));
  BUFFD1HVT OPTHOLD_G_6 (.I(sio_data_reg_137), .Z(sio_data_reg_41));
  XNR2D1HVT U1208_C1 (.A1(VDD_magmatienet_6), .A2(cmdcode_byte_0), .ZN(n2928));
  DFCNQD1HVT cram_wrt_reg (.CDN(rst_b_1), .CP(clk_b_2), .D(cram_wrt459), 
     .Q(smc_write_3));
  NR2D1HVT U1131_C3 (.A1(cdone_in), .A2(U1131_N4), .ZN(en_daisychain_cfg));
  BUFFD1HVT OPTHOLD_G_26 (.I(sio_data_reg_12), .Z(sio_data_reg_51));
  ND2D1HVT U1131_C2 (.A1(ctrlopt_reg2_2__IQ), .A2(cdone_out), .ZN(U1131_N4));
  BUFFD1HVT OPTHOLD_G_595 (.I(cmdreg_code_0_), .Z(cmdreg_code_0_3));
  TIELHVT VSS_magmatiecell_0 (.ZN(VSS_magmatienet_0));
  BUFFD1HVT OPTHOLD_G_767 (.I(sio_data_reg_78), .Z(sio_data_reg_135));
  BUFFD1HVT OPTHOLD_G_536 (.I(spi_rd_cmdaddr_25), .Z(spi_rd_cmdaddr_34));
  OAI22D1HVT U1480_C4 (.A1(n2946_1), .A2(n2945), .B1(spi_tx_done), .B2(n2883_1), 
     .ZN(n3190));
  OAI211D1HVT U1178_C3 (.A1(n2986), .A2(n2907), .B(n3192), .C(n3191), .ZN(n2906));
  OR2D1HVT U1287_C1 (.A1(n3089), .A2(n3076), .Z(n2986));
  AOI221D1HVT U1226_C4 (.A1(n3011), .A2(n2905), .B1(n3079), .B2(n2886), 
     .C(n3127), .ZN(n2942));
  AO21D1HVT ctrlopt_reg9_11__C9 (.A1(sio_data_reg_49), .A2(n3197), 
     .B(ctrlopt_reg9_11__N12), .Z(ctrlopt_reg9_11__N13));
  DFCNQD1HVT bram_wrt_reg (.CDN(rst_b_1), .CP(clk_b_2), .D(bram_wrt471), 
     .Q(bram_wrt));
  DFCNQD1HVT cm_smc_sdo_en_int_d2_reg (.CDN(rst_b_2), .CP(spi_clk_out_16), 
     .D(cm_smc_sdo_en_int_d1_5), .Q(cm_smc_sdo_en_int_d2));
  BUFFD1HVT OPTHOLD_G_386 (.I(ctrlopt_reg9_12__N13), .Z(ctrlopt_reg9_12__N13_1));
  BUFFD1HVT OPTHOLD_G_975 (.I(cmdreg_err_reg_N13), .Z(cmdreg_err_reg_N13_2));
  BUFFD1HVT OPTHOLD_G_324 (.I(cm_smc_sdo_en_int_d1_3), 
     .Z(cm_smc_sdo_en_int_d1_2));
  NR2D1HVT ctrlopt_reg9_12__C8 (.A1(n3197), .A2(N3759_1), 
     .ZN(ctrlopt_reg9_12__N12));
  BUFFD1HVT OPTHOLD_G_390 (.I(n3071), .Z(n3071_1));
  XNR2D1HVT U1252_C1 (.A1(sio_data_reg_12), .A2(crc_reg_12_), .ZN(n2962));
  EDFCND1HVT framenum_reg_4_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_99), .E(n3009_1), .Q(framenum[4]), .QN());
  EDFCND1HVT framenum_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_98), .E(n3009_1), .Q(framenum[3]), .QN());
  BUFFD1HVT OPTHOLD_G_129 (.I(crc_reg_2_), .Z(crc_reg_2_1));
  EDFCND1HVT access_nvcm_reg_reg (.CDN(rst_b_3), .CP(clk_b_2), .D(n3011), 
     .E(n_5197), .Q(access_nvcm_reg), .QN());
  NR2D1HVT U1372_C1 (.A1(n3162_1), .A2(n2981_1), .ZN(n3015));
  AN3D1HVT U1385_C2 (.A1(n3073_1), .A2(n2981), .A3(n2980_1), .Z(n3034));
  DFCND1HVT bs_state_reg_0_ (.CDN(rst_b_4), .CP(spi_clk_out_14), .D(n3015), 
     .Q(bs_state_0_), .QN(n3113));
  ND3D1HVT U1245_C2_INV (.A1(n3113), .A2(n2995_1), .A3(bs_state_2_2), 
     .ZN(n3115_2));
  DFCNQD1HVT cm_smc_sdo_en_int_d1_reg (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(n3007_1), .Q(cm_smc_sdo_en_int_d1));
  AOI21D1HVT U1349_C3 (.A1(tm_en_cram_blsr_test_1), .A2(n3073), .B(n2981_1), 
     .ZN(U1349_N6));
  BUFFD1HVT OPTHOLD_G_422 (.I(bm_smc_sdo_en_int), .Z(bm_smc_sdo_en_int_1));
  BUFFD1HVT OPTHOLD_G_872 (.I(cm_smc_sdo_en_int_d3_3), 
     .Z(cm_smc_sdo_en_int_d3_4));
  NR2D1HVT U1161_C1 (.A1(n3134), .A2(n3098), .ZN(n2889));
  ND4D1HVT U1139_C3 (.A1(n3117_1), .A2(cmdreg_code_3_1), .A3(cmdreg_code_2_5), 
     .A4(cmdreg_code_1_), .ZN(n3155));
  ND2D1HVT U1324_C2 (.A1(sio_data_reg_39), .A2(bs_smc_sdo_en_reg), .ZN(n3171));
  NR3D2HVT U1342_C3 (.A1(n2951), .A2(cmdreg_code_2_2), .A3(cmdreg_code_0_1), 
     .ZN(n_1810));
  INVD1HVT BW1_INV_D1694 (.I(n2982), .ZN(n2982_1));
  INVD1HVT U1181_C3_MP_INV (.I(n3115_3), .ZN(n3115_1));
  BUFFD1HVT OPTHOLD_G_717 (.I(n3085), .Z(n3085_2));
  BUFFD1HVT OPTHOLD_G_913 (.I(cmdhead_reg_4), .Z(cmdhead_reg_19));
  OR3XD1HVT U1479_C2 (.A1(n3190), .A2(n3148), .A3(n3147), .Z(U1479_N5));
  AO211D1HVT U1300_C2 (.A1(n3164), .A2(n3115), .B(n3108), .C(U1486_N5), 
     .Z(n2993));
  ND3D2HVT U1233_C2 (.A1(n2985_1), .A2(bs_state_3_), .A3(bs_state_1_), 
     .ZN(n3150));
  INVD1HVT U1370_C2_MP_INV (.I(bs_state_2_), .ZN(bs_state_2_1));
  AO211D1HVT U1276_C2 (.A1(n3160), .A2(n3115), .B(n3189), .C(U1479_N5), 
     .Z(n2981));
  BUFFD1HVT OPTHOLD_G_589 (.I(cmdhead_reg_19), .Z(cmdhead_reg_13));
  NR2D1HVT U1290_C2 (.A1(cmdreg_code_2_2), .A2(cmdreg_code_0_2), .ZN(U1290_N4));
  BUFFD3HVT OPTHOLD_G_611 (.I(sio_data_reg_43), .Z(sio_data_reg_97));
  BUFFD1HVT OPTHOLD_G_19 (.I(sio_data_reg_8), .Z(sio_data_reg_48));
  INVD1HVT U1478_C2_MP_INV (.I(n2948), .ZN(n2948_1));
  XNR2D1HVT U1203_C1 (.A1(sio_data_reg_25), .A2(VSS_magmatienet_11), .ZN(n2924));
  EDFCND1HVT framelen_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_101), .E(n3199_1), .Q(framelen[6]), .QN());
  DFNCND1HVT ctrlopt_reg9_11_ (.CDN(rst_b_2), .CPN(clk_1), 
     .D(ctrlopt_reg9_11__N13_1), .Q(), .QN(N4300));
  ND2D1HVT U1160_C1 (.A1(md_spi), .A2(cfg_ld_bstream), .ZN(n3140));
  OR2D1HVT U1159_C1 (.A1(cmdreg_err), .A2(cmdcode_err), .Z(n3079));
  INVD1HVT U1279_C2_MP_INV (.I(cmdreg_code_1_), .ZN(cmdreg_code_1_1));
  AOI21D1HVT U1140_C1 (.A1(n2952), .A2(U1452_N5), .B(n3118), .ZN(n3004));
  INVD1HVT U1240_C3_MP_INV_3 (.I(sio_data_reg_4), .ZN(sio_data_reg_37));
  NR3D1HVT U1279_C2 (.A1(n3087), .A2(cmdreg_code_1_1), .A3(cmdreg_code_0_3), 
     .ZN(n2982));
  BUFFD1HVT OPTHOLD_G_140 (.I(sio_data_reg_24), .Z(sio_data_reg_80));
  CKAN2D1HVT U1411_C1 (.A1(spi_rd_cmdaddr_reg_20), .A2(n2900), .Z(val2426_21));
  NR2D1HVT U1166_C1 (.A1(n2900_1), .A2(n2898), .ZN(spi_rd_cmdaddr_8));
  EDFCND1HVT usercode_reg_reg_1_ (.CDN(rst_b_5), .CP(spi_clk_out_15), 
     .D(sio_data_reg_40), .E(n2982_2), .Q(usercode_reg[1]), .QN());
  BUFFD3HVT OPTHOLD_G_637 (.I(sio_data_reg_53), .Z(sio_data_reg_107));
  EDFCND1HVT usercode_reg_reg_22_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_112), .E(n2982_2), .Q(usercode_reg[22]), .QN());
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_12_ (.CDN(rst_b_4), .CP(spi_clk_out_12), 
     .D(sio_data_reg_110), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_12), .QN());
  BUFFD1HVT OPTHOLD_G_668 (.I(sio_data_reg_89), .Z(sio_data_reg_120));
  CKAN2D1HVT U1420_C1 (.A1(spi_rd_cmdaddr_reg_11), .A2(n2900), 
     .Z(spi_rd_cmdaddr_11));
  BUFFD1HVT OPTHOLD_G_539 (.I(spi_rxpreamble_trycnt_2_), 
     .Z(spi_rxpreamble_trycnt_2_1));
  EDFCND1HVT usercode_reg_reg_28_ (.CDN(rst_b_2), .CP(spi_clk_out_19), 
     .D(sio_data_reg_116), .E(n2982_2), .Q(usercode_reg[28]), .QN());
  BUFFD1HVT OPTHOLD_G_956 (.I(ctrlopt_reg4_7__N13), .Z(ctrlopt_reg4_7__N13_2));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_30_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(sio_data_reg_121), .E(n3000_2), .Q(spi_rd_cmdaddr_30), .QN());
  TIELHVT VSS_magmatiecell_15 (.ZN(VSS_magmatienet_15));
  XNR2D1HVT U1218_C1 (.A1(sio_data_reg_29), .A2(VSS_magmatienet_14), .ZN(n2936));
  BUFFD1HVT OPTHOLD_G_551 (.I(sio_data_reg_70), .Z(sio_data_reg_85));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_29_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(sio_data_reg_85), .E(n3000_2), .Q(spi_rd_cmdaddr_29), .QN());
  MUX4D1HVT U1176 (.I0(bm_bank_sdo[0]), .I1(bm_bank_sdo[2]), .I2(bm_bank_sdo[1]), 
     .I3(bm_bank_sdo[3]), .S0(baddr[1]), .S1(baddr[0]), .Z(n3169));
  BUFFD1HVT OPTHOLD_G_391 (.I(n3072), .Z(n3072_1));
  BUFFD1HVT OPTHOLD_G_559 (.I(sio_data_reg_74), .Z(sio_data_reg_93));
  BUFFD1HVT OPTHOLD_G_549 (.I(sio_data_reg_72), .Z(sio_data_reg_83));
  EDFCND1HVT usercode_reg_reg_4_ (.CDN(rst_b_3), .CP(spi_clk_out_14), 
     .D(sio_data_reg_99), .E(n2982_2), .Q(usercode_reg[4]), .QN());
  BUFFD3HVT OPTHOLD_G_16 (.I(sio_data_reg_7), .Z(sio_data_reg_46));
  BUFFD1HVT OPTHOLD_G_28 (.I(sio_data_reg_14), .Z(sio_data_reg_53));
  BUFFD1HVT OPTHOLD_G_962 (.I(n3071_1), .Z(n3071_2));
  DFSND1HVT spi_rd_cmdaddr_reg_reg_27_ (.CP(spi_clk_out_18), .D(n3070_1), 
     .Q(spi_rd_cmdaddr_27), .QN(), .SDN(rst_b_2));
  ND4D1HVT U1189_C3 (.A1(n2916), .A2(n2915), .A3(n2914), .A4(n2913), .ZN(n3182));
  ND4D1HVT U1199_C3 (.A1(n2924), .A2(n2923), .A3(n2922), .A4(n2921), .ZN(n3184));
  BUFFD1HVT OPTHOLD_G_116 (.I(crc_reg_8_3), .Z(crc_reg_8_1));
  BUFFD1HVT OPTHOLD_G_117 (.I(crc_reg_13_), .Z(crc_reg_13_1));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_28_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(sio_data_reg_116), .E(n3000_2), .Q(spi_rd_cmdaddr_28), .QN());
  EDFCND1HVT testmode_reg_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_14), 
     .D(cmdcode_byte_2), .E(n2992), .Q(Uc_0_), .QN());
  DFSND1HVT spi_rd_cmdaddr_reg_reg_24_ (.CP(spi_clk_out_12), .D(n3072_1), 
     .Q(spi_rd_cmdaddr_24), .QN(), .SDN(rst_b_2));
  BUFFD1HVT OPTHOLD_G_139 (.I(sio_data_reg_80), .Z(sio_data_reg_79));
  EDFCND1HVT ctrlopt_reg_1_ (.CDN(rst_b_4), .CP(spi_clk_out_15), 
     .D(sio_data_reg_40), .E(n3197_2), .Q(cor_en_oscclk), .QN());
  BUFFD1HVT OPTHOLD_G_1 (.I(cmdreg_code_1_), .Z(cmdreg_code_1_2));
  NR2XD3HVT U1169_C1 (.A1(warmboot_req), .A2(cor_en_coldboot), .ZN(n2900));
  INVD1HVT U1449_C5_MP_INV (.I(coldboot_sel[0]), .ZN(coldboot_sel_0_1));
  INVD4HVT BW1_INV1694 (.I(n2982_1), .ZN(n2982_2));
  CKAN2D1HVT U1419_C1 (.A1(spi_rd_cmdaddr_reg_2), .A2(n2900), 
     .Z(spi_rd_cmdaddr_2));
  AN3D1HVT U1294_C2 (.A1(n3085_1), .A2(cnt_podt_out), .A3(cfg_ld_bstream_1), 
     .Z(n3008));
  XNR2D1HVT U1273_C1 (.A1(spi_rxpreamble_trycnt_2_1), .A2(add_733_carry_2), 
     .ZN(n2979));
  BUFFD1HVT OPTHOLD_G_907 (.I(cmdhead_reg_8), .Z(cmdhead_reg_17));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_17_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_122), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_17), .QN());
  BUFFD1HVT OPTHOLD_G_48 (.I(sio_data_reg_16), .Z(sio_data_reg_58));
  BUFFD1HVT OPTHOLD_G_664 (.I(sio_data_reg_84), .Z(sio_data_reg_116));
  EDFCND1HVT framelen_reg_8_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_146), .E(n3199), .Q(framelen[8]), .QN());
  XNR2D1HVT U1257_C1 (.A1(sio_data_reg_2), .A2(crc_reg_2_), .ZN(n2966));
  XNR2D1HVT U1263_C1 (.A1(sio_data_reg_10), .A2(crc_reg_10_), .ZN(n2971));
  ND4D1HVT U1256_C3 (.A1(n2969), .A2(n2968), .A3(n2967), .A4(n2966), .ZN(n3177));
  BUFFD1HVT OPTHOLD_G_113 (.I(crc_reg_10_), .Z(crc_reg_10_1));
  BUFFD1HVT OPTHOLD_G_12 (.I(sio_data_reg_2), .Z(sio_data_reg_43));
  EDFCNQD4HVT ctrlopt_reg3_8_ (.CDN(rst_b_2), .CP(spi_clk_out_18), 
     .D(sio_data_reg_146), .E(n3197_2), .Q(cor_en_8bconfig));
  EDFCND1HVT usercode_reg_reg_25_ (.CDN(rst_b_2), .CP(spi_clk_out_16), 
     .D(sio_data_reg_95), .E(n2982_2), .Q(usercode_reg[25]), .QN());
  IND2D1HVT U1230_C1 (.A1(n3032), .B1(md_spi), .ZN(n2945));
  NR2D1HVT U1283_C1 (.A1(n3142), .A2(n3096), .ZN(n2984));
  NR2D1HVT U1164_C1 (.A1(n2896), .A2(n2895), .ZN(n3032));
  NR4D1HVT U1234_C3 (.A1(n3144), .A2(n3143), .A3(n3011), .A4(n2907), .ZN(n2949));
  EDFCND1HVT framelen_reg_11_ (.CDN(rst_b_2), .CP(spi_clk_out_18), 
     .D(sio_data_reg_106), .E(n3199_1), .Q(framelen[11]), .QN());
  BUFFD1HVT OPTHOLD_G_316 (.I(bm_smc_sdo_en_int_d2_4), 
     .Z(bm_smc_sdo_en_int_d2_2));
  BUFFD1HVT OPTHOLD_G_385 (.I(ctrlopt_reg9_11__N13_2), 
     .Z(ctrlopt_reg9_11__N13_1));
  BUFFD1HVT OPTHOLD_G_959 (.I(ctrlopt_reg9_11__N13), .Z(ctrlopt_reg9_11__N13_2));
  BUFFD1HVT OPTHOLD_G_299 (.I(bm_smc_sdo_en_int_d3_3), 
     .Z(bm_smc_sdo_en_int_d3_1));
  EDFCND1HVT framelen_reg_9_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_104), .E(n3199_1), .Q(framelen[9]), .QN());
  XNR2D1HVT U1260_C1 (.A1(sio_data_reg_4), .A2(crc_reg_4_), .ZN(n2969));
  DFCNQD1HVT bs_smc_sdo_en_reg_reg (.CDN(rst_b_2), .CP(spi_clk_out_16), 
     .D(bs_smc_sdo_en), .Q(bs_smc_sdo_en_reg));
  BUFFD1HVT OPTHOLD_G_517 (.I(sdo_rx_0_), .Z(sdo_rx_0_1));
  EDFCND1HVT framelen_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_40), .E(n3199_1), .Q(framelen[1]), .QN());
  BUFFD3HVT BW2_BUF4992 (.I(sio_data_reg_140), .Z(sio_data_reg_146));
  BUFFD1HVT OPTHOLD_G_735 (.I(spi_rd_cmdaddr_24), .Z(spi_rd_cmdaddr_35));
  BUFFD1HVT OPTHOLD_G_134 (.I(spi_ldbstream_trycnt_0_2), 
     .Z(spi_ldbstream_trycnt_0_1));
  NR2D1HVT U1375_C1 (.A1(n3162_1), .A2(n2980), .ZN(n3018));
  DFCNQD1HVT bs_state_reg_1_ (.CDN(rst_b_4), .CP(spi_clk_out_15), .D(n3016_1), 
     .Q(bs_state_1_));
  BUFFD1HVT OPTHOLD_F_10 (.I(cm_smc_sdo_en_int_d1_1), .Z(cm_smc_sdo_en_int_d1_6));
  EDFCNQD2HVT ctrlopt_reg10_6_ (.CDN(rst_b_3), .CP(spi_clk_out_14), .D(n_3906), 
     .E(n_3905), .Q(cor_security_rddis));
  BUFFD1HVT OPTHOLD_G_576 (.I(cm_smc_sdo_en_int_d1_6), 
     .Z(cm_smc_sdo_en_int_d1_4));
  BUFFD4HVT BW1_BUF712_2 (.I(rst_b_3), .Z(rst_b_4));
  NR2D1HVT U1163_C1 (.A1(n3134), .A2(n2985), .ZN(n2894));
  OAI33D4HVT U1137_C5 (.A1(n3073_1), .A2(n2981), .A3(n2980), .B1(n3074), 
     .B2(n2993_1), .B3(n2882_3), .ZN(bm_smc_sdo_en_int));
  INVD1HVT U1474_C3_MP_INV (.I(n2986), .ZN(n2986_1));
  DFNCND1HVT ctrlopt_reg9_10_ (.CDN(rst_b_2), .CPN(clk_1), 
     .D(ctrlopt_reg9_10__N13_1), .Q(), .QN(N574));
  BUFFD1HVT OPTHOLD_G_319 (.I(cm_smc_sdo_en_int_d2_2), 
     .Z(cm_smc_sdo_en_int_d2_1));
  BUFFD1HVT OPTHOLD_G_10 (.I(cmdreg_code_3_3), .Z(cmdreg_code_3_2));
  INVD1HVT U1462_C1_MP_INV_1 (.I(sio_data_reg_2), .ZN(sio_data_reg_33));
  INVD1HVT U1280_C2_MP_INV (.I(sio_data_reg_137), .ZN(sio_data_reg_38));
  DFCNQD1HVT smc_podt_off_reg (.CDN(rst_b_6), .CP(spi_clk_out_15), 
     .D(smc_podt_off_reg_N13_2), .Q(smc_podt_off));
  INVD1HVT U1478_C2_MP_INV_1 (.I(n3152), .ZN(n3152_1));
  OAI211D1HVT U1478_C2 (.A1(n2948_1), .A2(n2885), .B(n3152_1), .C(U1153_N5), 
     .ZN(n3189));
  AO21D1HVT U1486_C2 (.A1(n3010), .A2(bram_done_1), .B(n3019), .Z(U1486_N5));
  IOA21D1HVT U1483_C2 (.A1(n3194), .A2(n2985_1), .B(n3150), .ZN(U1483_N5));
  INVD1HVT U1229_C3_MP_INV (.I(sr_datacnt_0), .ZN(sr_datacnt_1));
  OR3XD1HVT U1153_C2 (.A1(n3140), .A2(n2995), .A3(n2985), .Z(U1153_N5));
  BUFFD1HVT OPTHOLD_G_925 (.I(n2882_1), .Z(n2882_3));
  BUFFD1HVT OPTHOLD_G_288 (.I(cmdhead_reg_3), .Z(cmdhead_reg_7));
  BUFFD1HVT OPTHOLD_G_1127 (.I(crc_reg_4_), .Z(crc_reg_4_1));
  XNR2D1HVT U1253_C1 (.A1(sio_data_reg_6), .A2(crc_reg_6_), .ZN(n2963));
  BUFFD1HVT OPTHOLD_G_13 (.I(sio_data_reg_3), .Z(sio_data_reg_44));
  BUFFD1HVT OPTHOLD_G_327 (.I(cm_smc_sdo_en_int_d3_2), 
     .Z(cm_smc_sdo_en_int_d3_1));
  TIELHVT VSS_magmatiecell_4 (.ZN(VSS_magmatienet_4));
  BUFFD1HVT OPTHOLD_G_393 (.I(stop_crc_reg_N13), .Z(stop_crc_reg_N13_1));
  BUFFD1HVT OPTHOLD_G_285 (.I(cmdhead_reg_2), .Z(cmdhead_reg_5));
  INVD1HVT U1480_C4_MP_INV (.I(n2946), .ZN(n2946_1));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_4_ (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(sio_data_reg_99), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_4), .QN());
  BUFFD1HVT OPTHOLD_G_601 (.I(cmdreg_code_1_), .Z(cmdreg_code_1_3));
  EDFCNQD1HVT idcode_err_reg (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(idcode_err1521), .E(n_1836), .Q(idcode_err));
  EDFCNQD1HVT crc_err_reg (.CDN(rst_b_3), .CP(spi_clk_out_16), .D(n3030), 
     .E(n_5113), .Q(crc_err));
  BUFFD1HVT OPTHOLD_G_761 (.I(sio_data_reg_76), .Z(sio_data_reg_133));
  BUFFD3HVT OPTHOLD_G_8 (.I(n3197), .Z(n3197_2));
  EDFCNQD1HVT ctrlopt_reg6_0_ (.CDN(rst_b_6), .CP(spi_clk_out_15), 
     .D(cmdcode_byte_3), .E(n3197_2), .Q(cor_dis_flashpd));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_10_ (.CDN(rst_b_5), .CP(spi_clk_out_15), 
     .D(sio_data_reg_109), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_10), .QN());
  EDFCND1HVT usercode_reg_reg_15_ (.CDN(rst_b_5), .CP(spi_clk_out_12), 
     .D(sio_data_reg_108), .E(n2982_2), .Q(usercode_reg[15]), .QN());
  EDFCND1HVT usercode_reg_reg_23_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_118), .E(n2982_2), .Q(usercode_reg[23]), .QN());
  BUFFD1HVT OPTHOLD_G_556 (.I(sio_data_reg_130), .Z(sio_data_reg_90));
  NR2D1HVT U1271_C1 (.A1(n2978), .A2(n2900_1), .ZN(val2426_24));
  BUFFD1HVT OPTHOLD_G_791 (.I(cor_dis_flashpd), .Z(cor_dis_flashpd_1));
  BUFFD1HVT OPTHOLD_G_425 (.I(spi_rxpreamble_trycnt969_1), 
     .Z(spi_rxpreamble_trycnt969_3));
  DFCNQD1HVT md_jtag_r_reg (.CDN(rst_b_6), .CP(spi_clk_out_6), .D(md_jtag_1), 
     .Q(md_jtag_r));
  XNR2D1HVT U1205_C1 (.A1(sio_data_reg_8), .A2(VSS_magmatienet_13), .ZN(n2925));
  BUFFD1HVT OPTHOLD_G_54 (.I(sio_data_reg_17), .Z(sio_data_reg_64));
  TIELHVT VSS_magmatiecell_20 (.ZN(VSS_magmatienet_20));
  NR3D1HVT U1173_C3 (.A1(n3167), .A2(N576), .A3(baddr[1]), .ZN(U1173_N6));
  BUFFD1HVT OPTHOLD_G_923 (.I(crc_reg_8_), .Z(crc_reg_8_3));
  ND4D1HVT U1214_C3 (.A1(n2936), .A2(n2935), .A3(n2934), .A4(n2933), .ZN(n3181));
  XNR2D1HVT U1206_C1 (.A1(sio_data_reg_23), .A2(VSS_magmatienet_19), .ZN(n2926));
  BUFFD1HVT OPTHOLD_G_670 (.I(sio_data_reg_91), .Z(sio_data_reg_122));
  BUFFD1HVT OPTHOLD_G_15 (.I(N576_2), .Z(N576_1));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_16_ (.CDN(rst_b_4), .CP(spi_clk_out_12), 
     .D(sio_data_reg_143), .E(n3000_2), .Q(), .QN(n2975));
  EDFCND1HVT usercode_reg_reg_20_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_126), .E(n2982_2), .Q(usercode_reg[20]), .QN());
  EDFCND1HVT usercode_reg_reg_3_ (.CDN(rst_b_3), .CP(spi_clk_out_14), 
     .D(sio_data_reg_98), .E(n2982_2), .Q(usercode_reg[3]), .QN());
  EDFCND1HVT start_framenum_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_98), .E(n_1531), .Q(start_framenum[3]), .QN());
  EDFCND1HVT start_framenum_reg_7_ (.CDN(rst_b_2), .CP(spi_clk_out_20), 
     .D(sio_data_reg_145), .E(n_1531), .Q(start_framenum[7]), .QN());
  BUFFD1HVT OPTHOLD_G_17 (.I(sio_data_reg_6), .Z(sio_data_reg_47));
  BUFFD1HVT OPTHOLD_G_52 (.I(sio_data_reg_30), .Z(sio_data_reg_62));
  TIELHVT VSS_magmatiecell_7 (.ZN(VSS_magmatienet_7));
  XNR2D1HVT U1202_C1 (.A1(sio_data_reg_13), .A2(VSS_magmatienet_9), .ZN(n2923));
  TIEHHVT VDD_magmatiecell_2 (.Z(VDD_magmatienet_2));
  BUFFD1HVT OPTHOLD_G_29 (.I(sio_data_reg_13), .Z(sio_data_reg_54));
  BUFFD3HVT BW2_BUF4991 (.I(sio_data_reg_139), .Z(sio_data_reg_145));
  XNR2D1HVT U1198_C1 (.A1(sio_data_reg_28), .A2(VDD_magmatienet_5), .ZN(n2920));
  BUFFD1HVT OPTHOLD_G_523 (.I(crc_reg_12_2), .Z(crc_reg_12_1));
  CKMUX2D2HVT U1326_C4 (.I0(spi_rd_cmdaddr_32), .I1(sio_data_reg_134), 
     .S(n3000_2), .Z(n3072));
  IND3D1HVT U1457_C2 (.A1(n3119), .B1(sio_data_reg_137), .B2(cmdcode_byte_0), 
     .ZN(n3096));
  OR3XD1HVT U1280_C2 (.A1(sio_data_reg_38), .A2(n3119), .A3(cmdcode_byte_0), 
     .Z(n2983));
  BUFFD1HVT OPTHOLD_G_974 (.I(cmdcode_err_reg_N13_1), .Z(cmdcode_err_reg_N13_3));
  CKAN2D1HVT U1421_C1 (.A1(spi_rd_cmdaddr_reg_4), .A2(n2900), 
     .Z(spi_rd_cmdaddr_4));
  AO222D1HVT U1449_C5 (.A1(n3026), .A2(coldboot_sel_0_1), .B1(warmboot_req), 
     .B2(n3094), .C1(spi_rd_cmdaddr_reg_5), .C2(n2900), .Z(spi_rd_cmdaddr_5));
  AN3D4HVT U1388_C2 (.A1(warmboot_int), .A2(md_spi), .A3(cor_en_warmboot), 
     .Z(warmboot_req));
  BUFFD1HVT OPTHOLD_G_909 (.I(spi_ldbstream_trycnt_1_1), 
     .Z(spi_ldbstream_trycnt_1_3));
  OR2D1HVT U1292_C1 (.A1(spi_master_go_3), .A2(n3034), .Z(n2989));
  BUFFD1HVT OPTHOLD_G_346 (.I(spi_ldbstream_trycnt1054_1), 
     .Z(spi_ldbstream_trycnt1054_2));
  EDFCND1HVT usercode_reg_reg_18_ (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(sio_data_reg_117), .E(n2982_2), .Q(usercode_reg[18]), .QN());
  EDFCND1HVT testmode_reg_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_20), 
     .D(sio_data_reg_101), .E(n2992), .Q(tm_dis_cram_clk_gating), .QN());
  TIEHHVT VDD_magmatiecell_6 (.Z(VDD_magmatienet_6));
  EDFCNQD1HVT ctrlopt_reg5_3_ (.CDN(rst_b_1), .CP(spi_clk_out_18), 
     .D(sio_data_reg_98), .E(n3197_2), .Q(cor_en_rdcrc));
  EDFCND1HVT framenum_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(cmdcode_byte_2), .E(n3009_1), .Q(framenum[0]), .QN());
  XNR2D1HVT U1247_C1 (.A1(sio_data_reg_15), .A2(crc_reg_15_), .ZN(n2958));
  OR2D1HVT U1381_C1 (.A1(n3177), .A2(n3176), .Z(U1381_N3));
  ND4D1HVT U1251_C3 (.A1(n2965), .A2(n2964), .A3(n2963), .A4(n2962), .ZN(n3174));
  XNR2D1HVT U1188_C1 (.A1(sio_data_reg_9), .A2(VDD_magmatienet_0), .ZN(n2912));
  BUFFD1HVT OPTHOLD_F (.I(sio_data_reg_1), .Z(sio_data_reg_138));
  OA211D1HVT U1451_C3 (.A1(n3102), .A2(n3101), .B(n2997_1), .C(cmdreg_code_0_2), 
     .Z(idcode_err1521));
  ND2D1HVT U1244_C2 (.A1(sio_data_reg_3), .A2(sio_data_reg_33), .ZN(n3097));
  INR2D1HVT U1157_C1 (.A1(n2886), .B1(n2945), .ZN(n3025));
  ND2D1HVT U1462_C1 (.A1(sio_data_reg_32), .A2(sio_data_reg_33), .ZN(n3142));
  MAOI22D1HVT U1481_C4 (.A1(n2946), .A2(n2945), .B1(spi_tx_done), .B2(n3150), 
     .ZN(n3192));
  BUFFD1HVT BL1_BUF69 (.I(rst_b), .Z(rst_b_1));
  AO21D1HVT ctrlopt_reg9_10__C9 (.A1(sio_data_reg_52), .A2(n3197), 
     .B(ctrlopt_reg9_10__N12), .Z(ctrlopt_reg9_10__N13));
  BUFFD1HVT OPTHOLD_G_537 (.I(spi_rxpreamble_trycnt_0_2), 
     .Z(spi_rxpreamble_trycnt_0_1));
  DFCNQD1HVT bm_smc_sdo_en_int_d4_reg (.CDN(rst_b_2), .CP(spi_clk_out_16), 
     .D(bm_smc_sdo_en_int_d3_1), .Q(bm_smc_sdo_en));
  BUFFD1HVT OPTHOLD_G_388 (.I(ctrlopt_reg9_9__N13), .Z(ctrlopt_reg9_9__N13_1));
  BUFFD1HVT OPTHOLD_G_1135 (.I(crc_reg_9_1), .Z(crc_reg_9_2));
  AO21D1HVT ctrlopt_reg9_12__C9 (.A1(sio_data_reg_51), .A2(n3197), 
     .B(ctrlopt_reg9_12__N12), .Z(ctrlopt_reg9_12__N13));
  BUFFD1HVT OPTHOLD_G_315 (.I(bm_smc_sdo_en_int_d2_5), 
     .Z(bm_smc_sdo_en_int_d2_1));
  EDFCNQD1HVT ctrlopt_reg2_2_ (.CDN(rst_b_2), .CP(spi_clk_out_16), 
     .D(sio_data_reg_97), .E(n3197_2), .Q(ctrlopt_reg2_2__IQ));
  EDFCND1HVT framelen_reg_7_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_145), .E(n3199_1), .Q(framelen[7]), .QN());
  BUFFD1HVT OPTHOLD_G_725 (.I(crc_reg_8_1), .Z(crc_reg_8_2));
  XNR2D1HVT U1248_C1 (.A1(crc_reg_0_), .A2(cmdcode_byte_0), .ZN(n2959));
  NR2D1HVT U1373_C1 (.A1(n3162_1), .A2(n3073), .ZN(n3016));
  ND2D1HVT U1183_C1 (.A1(bs_state_3_1), .A2(bs_state_1_), .ZN(n3134));
  NR3D1HVT U1376_C2 (.A1(n3134), .A2(bs_state_2_1), .A3(bs_state_0_), .ZN(n3023));
  OR2D1HVT U1454_C1 (.A1(n3113), .A2(bs_state_2_2), .Z(n3098));
  DFCNQD1HVT bs_state_reg_2_ (.CDN(rst_b_4), .CP(spi_clk_out_14), .D(n3017), 
     .Q(bs_state_2_));
  BUFFD1HVT OPTHOLD_G_602 (.I(cmdreg_code_3_2), .Z(cmdreg_code_3_4));
  BUFFD1HVT OPTHOLD_G_888 (.I(bm_smc_sdo_en_int_d1_3), 
     .Z(bm_smc_sdo_en_int_d1_5));
  AN3D1HVT U1379_C2 (.A1(n3073), .A2(n2993_1), .A3(n2981), .Z(n3027));
  BUFFD1HVT OPTHOLD_G_724 (.I(crc_reg_2_1), .Z(crc_reg_2_2));
  BUFFD1HVT OPTHOLD_G_428 (.I(spi_rxpreamble_trycnt969_0), 
     .Z(spi_rxpreamble_trycnt969_5));
  INVD1HVT U1307_C3_MP_INV (.I(n3117), .ZN(n3117_1));
  NR2D1HVT ctrlopt_reg9_10__C8 (.A1(n3197), .A2(N574_1), 
     .ZN(ctrlopt_reg9_10__N12));
  DFCNQD1HVT cmdcode_err_reg (.CDN(rst_b_3), .CP(spi_clk_out_14), 
     .D(cmdcode_err_reg_N13_3), .Q(cmdcode_err));
  INVD1HVT BW1_INV_D869 (.I(n3000), .ZN(n3000_1));
  INVD1HVT U1486_C2_MP_INV (.I(bram_done), .ZN(bram_done_1));
  OA31D1HVT smc_podt_off_reg_C9 (.A1(smc_podt_off), .A2(n3085_2), .A3(n3005), 
     .B(n2883_1), .Z(smc_podt_off_reg_N13));
  BUFFD1HVT OPTHOLD_G_986 (.I(n3016), .Z(n3016_1));
  OAI22D1HVT U1181_C3 (.A1(n3115_1), .A2(n2908), .B1(sr_datacnt_0), .B2(n3133), 
     .ZN(n3148));
  AO221D1HVT U1318_C4 (.A1(n2889), .A2(cmdhead_cnt_0), .B1(n3005), .B2(n2894), 
     .C(n3010), .Z(n3147));
  OR2D1HVT U1446_C1 (.A1(nvcm_relextspi), .A2(n3011), .Z(n_5197));
  INVD1HVT U1374_C1_MP_INV (.I(n2993_2), .ZN(n2993_1));
  NR2XD1HVT U1149_C1 (.A1(n3098), .A2(n2995), .ZN(n2883));
  INR2D1HVT U1235_C1 (.A1(n2974), .B1(n2907), .ZN(n3012));
  EDFCND1HVT testmode_reg_reg_4_ (.CDN(rst_b_3), .CP(spi_clk_out_14), 
     .D(sio_data_reg_99), .E(n2992), .Q(tm_en_cram_blsr_test), .QN());
  BUFFD1HVT OPTHOLD_G_525 (.I(spi_rd_cmdaddr_35), .Z(spi_rd_cmdaddr_32));
  NR4D8HVT U1367_C3 (.A1(n3139), .A2(n3138), .A3(n3137), .A4(n3136), .ZN(n3005));
  BUFFD3HVT OPTHOLD_G_612 (.I(sio_data_reg_44), .Z(sio_data_reg_98));
  ND4D1HVT U1184_C3 (.A1(n2912), .A2(n2911), .A3(n2910), .A4(n2909), .ZN(n3183));
  BUFFD1HVT OPTHOLD_G_119 (.I(crc_reg_7_), .Z(crc_reg_7_1));
  DFCNQD1HVT sdo_r_reg_4_ (.CDN(rst_b_2), .CP(spi_clk_out_17), .D(sdo_rx_4_), 
     .Q(sdo[4]));
  ND2D1HVT U1232_C1 (.A1(spi_rxpreamble_trycnt_inc_reg_IQ), .A2(n3085_1), 
     .ZN(U1232_N3));
  BUFFD1HVT OPTHOLD_G_861 (.I(N4300), .Z(N4300_1));
  INVD6HVT BL1_R_INV_13 (.I(n2951_1), .ZN(n2951));
  NR3D3HVT U1278_C2 (.A1(n3087_1), .A2(cmdreg_code_1_2), .A3(cmdreg_code_0_2), 
     .ZN(n_1530));
  AN4D1HVT U1240_C3 (.A1(sio_data_reg_34), .A2(sio_data_reg_35), 
     .A3(sio_data_reg_36), .A4(sio_data_reg_37), .Z(n2952));
  EDFCND1HVT testmode_reg_reg_8_ (.CDN(rst_b_3), .CP(spi_clk_out_14), 
     .D(sio_data_reg_146), .E(n2992), .Q(), .QN(n3145));
  BUFFD1HVT OPTHOLD_F_4 (.I(sio_data_reg_105), .Z(sio_data_reg_142));
  EDFCND1HVT usercode_reg_reg_8_ (.CDN(rst_b_5), .CP(spi_clk_out_15), 
     .D(sio_data_reg_146), .E(n2982_2), .Q(usercode_reg[8]), .QN());
  EDFCND1HVT usercode_reg_reg_9_ (.CDN(rst_b_5), .CP(spi_clk_out_15), 
     .D(sio_data_reg_104), .E(n2982_2), .Q(usercode_reg[9]), .QN());
  BUFFD1HVT OPTHOLD_G_423 (.I(n3069), .Z(n3069_1));
  EDFCND1HVT usercode_reg_reg_12_ (.CDN(rst_b_5), .CP(spi_clk_out_12), 
     .D(sio_data_reg_110), .E(n2982_2), .Q(usercode_reg[12]), .QN());
  EDFCND1HVT usercode_reg_reg_16_ (.CDN(rst_b_4), .CP(spi_clk_out_12), 
     .D(sio_data_reg_143), .E(n2982_2), .Q(usercode_reg[16]), .QN());
  NR2D1HVT U1269_C1 (.A1(n2976), .A2(n2900_1), .ZN(spi_rd_cmdaddr_21));
  CKAN2D1HVT U1409_C1 (.A1(spi_rd_cmdaddr_reg_Q2106_23), .A2(n2900), 
     .Z(spi_rd_cmdaddr_22));
  CKAN2D1HVT U1414_C1 (.A1(spi_rd_cmdaddr_reg_13), .A2(n2900), 
     .Z(spi_rd_cmdaddr_13));
  BUFFD1HVT OPTHOLD_G_922 (.I(smc_podt_rst1100), .Z(smc_podt_rst1100_1));
  BUFFD1HVT OPTHOLD_G_65 (.I(sio_data_reg_115), .Z(sio_data_reg_71));
  CKMUX2D2HVT U1174_C4 (.I0(n3201), .I1(n3200), .S(baddr[0]), .Z(n2903));
  EDFCND2HVT baddr_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(cmdcode_byte_3), .E(n_1810), .Q(baddr[0]), .QN());
  XNR2D1HVT U1211_C1 (.A1(sio_data_reg_18), .A2(VSS_magmatienet_22), .ZN(n2930));
  XNR2D1HVT U1217_C1 (.A1(sio_data_reg_6), .A2(VSS_magmatienet_15), .ZN(n2935));
  TIELHVT VSS_magmatiecell_14 (.ZN(VSS_magmatienet_14));
  EDFCND1HVT usercode_reg_reg_30_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(sio_data_reg_121), .E(n2982_2), .Q(usercode_reg[30]), .QN());
  MUX2ND2HVT U1152_C4 (.I0(cm_sdo_u0[1]), .I1(cm_sdo_u1[1]), .S(baddr[0]), 
     .ZN(n3167));
  MUX2D1HVT U1335_C4 (.I0(cm_sdo_u0[1]), .I1(bm_bank_sdo[1]), .S(N576_1), 
     .Z(sdo_rx_1_));
  EDFCND1HVT usercode_reg_reg_7_ (.CDN(rst_b_5), .CP(spi_clk_out_12), 
     .D(sio_data_reg_145), .E(n2982_2), .Q(usercode_reg[7]), .QN());
  BUFFD3HVT OPTHOLD_G_636 (.I(sio_data_reg_49), .Z(sio_data_reg_106));
  EDFCND1HVT usercode_reg_reg_2_ (.CDN(rst_b_3), .CP(spi_clk_out_14), 
     .D(sio_data_reg_97), .E(n2982_2), .Q(usercode_reg[2]), .QN());
  EDFCND1HVT framenum_reg_5_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_42), .E(n3009_1), .Q(framenum[5]), .QN());
  BUFFD1HVT OPTHOLD_G_69 (.I(sio_data_reg_31), .Z(sio_data_reg_75));
  XNR2D1HVT U1191_C1 (.A1(sio_data_reg_11), .A2(VSS_magmatienet_5), .ZN(n2914));
  BUFFD3HVT OPTHOLD_G_3 (.I(cmdcode_byte_0), .Z(cmdcode_byte_2));
  DFCNQD1HVT sdo_r_reg_5_ (.CDN(rst_b_2), .CP(spi_clk_out_18), .D(n3201), 
     .Q(sdo[5]));
  XNR2D1HVT U1200_C1 (.A1(sio_data_reg_10), .A2(VDD_magmatienet_4), .ZN(n2921));
  BUFFD3HVT OPTHOLD_G_616 (.I(sio_data_reg_47), .Z(sio_data_reg_101));
  AN4D1HVT U1241_C1 (.A1(sio_data_reg_28), .A2(sio_data_reg_26), 
     .A3(sio_data_reg_25), .A4(n2956), .Z(U1241_N3));
  EDFCND1HVT baddr_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_20), 
     .D(sio_data_reg_41), .E(n_1810), .Q(baddr_1_1), .QN());
  EDFCND1HVT testmode_reg_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_20), 
     .D(sio_data_reg_40), .E(n2992), .Q(Uc_1_), .QN());
  BUFFD1HVT OPTHOLD_G_46 (.I(sio_data_reg_57), .Z(sio_data_reg_56));
  BUFFD1HVT OPTHOLD_G_727 (.I(crc_reg_12_), .Z(crc_reg_12_2));
  INVD1HVT smc_podt_off_reg_C9_MP_INV (.I(n2883), .ZN(n2883_1));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_5_ (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(sio_data_reg_42), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_5), .QN());
  ND3D1HVT U1242_C2 (.A1(sio_data_reg_6), .A2(sio_data_reg_12), 
     .A3(sio_data_reg_1), .ZN(n3187));
  BUFFD1HVT OPTHOLD_G_891 (.I(spi_rd_cmdaddr_reg_Q2106_22), 
     .Z(spi_rd_cmdaddr_reg_Q2106_23));
  OR3XD1HVT U1477_C2 (.A1(n3187), .A2(n3186), .A3(n3106), .Z(n3138));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_9_ (.CDN(rst_b_4), .CP(spi_clk_out_15), 
     .D(sio_data_reg_104), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_9), .QN());
  BUFFD1HVT OPTHOLD_G_349 (.I(n2902), .Z(n2902_1));
  NR2D1HVT U1272_C1 (.A1(n2989), .A2(n2979_1), .ZN(spi_rxpreamble_trycnt969_2));
  EDFCND1HVT spi_rxpreamble_trycnt_reg_1_ (.CDN(rst_b_6), .CP(spi_clk_out_15), 
     .D(spi_rxpreamble_trycnt969_3), .E(n970_0), .Q(spi_rxpreamble_trycnt_1_), 
     .QN());
  BUFFD1HVT OPTHOLD_G_671 (.I(sio_data_reg_58), .Z(sio_data_reg_123));
  EDFCND1HVT testmode_reg_reg_7_ (.CDN(rst_b_2), .CP(spi_clk_out_20), 
     .D(sio_data_reg_145), .E(n2992), .Q(tm_dis_bram_clk_gating), .QN());
  EDFCND1HVT start_framenum_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_97), .E(n_1531), .Q(start_framenum[2]), .QN());
  BUFFD1HVT OPTHOLD_G_569 (.I(cm_smc_sdo_en_int_d2_5), 
     .Z(cm_smc_sdo_en_int_d2_3));
  XNR2D1HVT U1255_C1 (.A1(sio_data_reg_9), .A2(crc_reg_9_), .ZN(n2965));
  MUX2D1HVT U1316_C4 (.I0(sdi_d1), .I1(sdo[0]), .S(cor_en_rdcrc), 
     .Z(crc_data_in));
  DFCNQD1HVT sdi_d1_reg (.CDN(rst_b_2), .CP(spi_clk_out_18), .D(sdi_2), 
     .Q(sdi_d1));
  BUFFD1HVT OPTHOLD_G (.I(cmdreg_code_0_3), .Z(cmdreg_code_0_2));
  BUFFD1HVT OPTHOLD_G_590 (.I(sio_data_reg_135), .Z(sio_data_reg_95));
  DFCNQD1HVT sdo_r_reg_7_ (.CDN(rst_b_2), .CP(spi_clk_out_18), .D(n3200), 
     .Q(sdo[7]));
  AO21D1HVT ctrlopt_reg4_7__C9 (.A1(sio_data_reg_46), .A2(n3197), 
     .B(cor_security_wrtdis_1), .Z(ctrlopt_reg4_7__N13));
  INVD1HVT U1459_C3_MP_INV (.I(n2983), .ZN(n2983_1));
  INVD1HVT U1179_C2_MP_INV (.I(n3031), .ZN(n3031_1));
  BUFFD1HVT OPTHOLD_G_625 (.I(n3115), .Z(n3115_3));
  NR2XD2HVT U1291_C1 (.A1(n3090), .A2(n3089), .ZN(n2988));
  DFCNQD1HVT sdo_r_reg_3_ (.CDN(rst_b_1), .CP(spi_clk_out_18), .D(sdo_rx_3_), 
     .Q(sdo[3]));
  INVD1HVT stop_crc_reg_C9_MP_INV (.I(stop_crc_reg_IQ), .ZN(stop_crc_reg_IQ_1));
  BUFFD1HVT OPTHOLD_G_875 (.I(cm_smc_sdo_en_int_d1_4), 
     .Z(cm_smc_sdo_en_int_d1_5));
  BUFFD1HVT OPTHOLD_G_599 (.I(n3087), .Z(n3087_2));
  BUFFD1HVT OPTHOLD_G_887 (.I(bm_smc_sdo_en_int_d1), .Z(bm_smc_sdo_en_int_d1_4));
  EDFCND1HVT framelen_reg_5_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_42), .E(n3199_1), .Q(framelen[5]), .QN());
  BUFFD1HVT OPTHOLD_G_284 (.I(cmdhead_reg_5), .Z(cmdhead_reg_4));
  INVD1HVT U1451_C3_MP_INV (.I(n2997), .ZN(n2997_1));
  LHCNDD2HVT warmboot_sel_int_reg_1_ (.CDN(rst_b_3), .D(warmboot_sel[1]), 
     .E(fpga_operation), .Q(warmboot_sel_int_1_), .QN());
  EDFCND1HVT framelen_reg_4_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_99), .E(n3199_1), .Q(framelen[4]), .QN());
  BUFFD1HVT OPTHOLD_G_661 (.I(sio_data_reg_82), .Z(sio_data_reg_113));
  BUFFD3HVT OPTHOLD_G_11 (.I(sio_data_reg_136), .Z(sio_data_reg_42));
  ND3D1HVT U1295_C2 (.A1(n3073_1), .A2(n2981), .A3(n2980), .ZN(n3074));
  BUFFD1HVT OPTHOLD_G_1142 (.I(tm_en_cram_blsr_test_2), 
     .Z(tm_en_cram_blsr_test_3));
  DFCNQD1HVT bs_state_reg_3_ (.CDN(rst_b_4), .CP(spi_clk_out_15), .D(n3018_1), 
     .Q(bs_state_3_));
  BUFFD1HVT OPTHOLD_G_908 (.I(spi_ldbstream_trycnt_1_), 
     .Z(spi_ldbstream_trycnt_1_2));
  BUFFD1HVT OPTHOLD_G_424 (.I(U1349_N6), .Z(U1349_N6_1));
  BUFFD1HVT OPTHOLD_G_958 (.I(n_3904), .Z(n_3906));
  BUFFD1HVT OPTHOLD_G_582 (.I(bm_smc_sdo_en_int_d2_1), 
     .Z(bm_smc_sdo_en_int_d2_3));
  AO21D1HVT U1450_C2 (.A1(n3115), .A2(n2943), .B(n3100), .Z(cmdhead_cnt_ld));
  BUFFD1HVT OPTHOLD_G_396 (.I(cmdcode_err_reg_N13_2), .Z(cmdcode_err_reg_N13_1));
  AO21D1HVT U1464_C2 (.A1(n3003), .A2(n2907_1), .B(n3013), .Z(n3146));
  BUFFD1HVT OPTHOLD_G_323 (.I(cm_smc_sdo_en_int_d1_2), 
     .Z(cm_smc_sdo_en_int_d1_1));
  DFNCND2HVT cm_smc_sdo_en_int_d4_reg (.CDN(rst_b_2), .CPN(clk_1), 
     .D(cm_smc_sdo_en_int_d3_1), .Q(cm_smc_sdo_en_1), .QN(N576));
  BUFFD1HVT OPTHOLD_G_27 (.I(sio_data_reg_144), .Z(sio_data_reg_52));
  ND2D1HVT U1147_C2 (.A1(sio_data_reg_32), .A2(sio_data_reg_100), .ZN(n3089));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_2_ (.CDN(rst_b_3), .CP(spi_clk_out_14), 
     .D(sio_data_reg_97), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_2), .QN());
  EDFCNQD1HVT spi_rxpreamble_trycnt_inc_reg (.CDN(rst_b_6), .CP(spi_clk_out_15), 
     .D(n3008), .E(n2989_1), .Q(spi_rxpreamble_trycnt_inc_reg_IQ));
  INR2D1HVT U1132_C1 (.A1(n2984), .B1(n2907), .ZN(n3013));
  BUFFD1HVT OPTHOLD_G_955 (.I(smc_podt_off_reg_N13_1), 
     .Z(smc_podt_off_reg_N13_2));
  OR3XD1HVT U1466_C1 (.A1(n3157), .A2(n3023), .A3(U1483_N5), .Z(U1466_N3));
  AO222D1HVT U1314_C5 (.A1(n3005), .A2(n2894), .B1(n3010), .B2(bram_done), 
     .C1(n3152), .C2(cram_done), .Z(n3100));
  AO21D1HVT U1491_C4 (.A1(bs_state_3_), .A2(bram_done), .B(U1491_N7), .Z(n3194));
  MOAI22D1HVT U1229_C3 (.A1(sr_datacnt_1), .A2(n3133), .B1(n3152), 
     .B2(cram_done), .ZN(n3195));
  BUFFD1HVT OPTHOLD_G_870 (.I(N4455), .Z(N4455_1));
  NR2XD2HVT U1298_C2 (.A1(n3087_2), .A2(U1298_N3), .ZN(n2992));
  AO21D1HVT ctrlopt_reg9_9__C9 (.A1(sio_data_reg_50), .A2(n3197), 
     .B(ctrlopt_reg9_9__N12), .Z(ctrlopt_reg9_9__N13));
  BUFFD1HVT OPTHOLD_G_49 (.I(sio_data_reg_60), .Z(sio_data_reg_59));
  BUFFD1HVT OPTHOLD_G_863 (.I(N3759), .Z(N3759_1));
  AOI21D1HVT U1182_C2 (.A1(n3143), .A2(n2907_1), .B(n3025), .ZN(n2908));
  BUFFD1HVT OPTHOLD_G_350 (.I(n2975), .Z(n2975_1));
  EDFCND1HVT framelen_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(cmdcode_byte_2), .E(n3199_1), .Q(framelen[0]), .QN());
  ND4D1HVT U1307_C3 (.A1(n3117_1), .A2(cmdreg_code_3_1), .A3(cmdreg_code_2_1), 
     .A4(cmdreg_code_1_2), .ZN(n2997));
  INVD1HVT U1383_C3_MP_INV (.I(md_spi), .ZN(md_spi_1));
  INR2D1HVT U1135_C2 (.A1(n2899), .B1(n2907), .ZN(n3021));
  OR4XD1HVT U1177_C2 (.A1(n3080), .A2(n3030), .A3(n3024), .A4(n3004), 
     .Z(U1177_N5));
  INVD1HVT U1462_C1_MP_INV (.I(sio_data_reg_3), .ZN(sio_data_reg_32));
  OAI21D1HVT U1306_C2 (.A1(n2997), .A2(cmdreg_code_0_2), .B(n2998), .ZN(n_5113));
  BUFFD1HVT OPTHOLD_G_522 (.I(cmdreg_err), .Z(cmdreg_err_1));
  BUFFD1HVT OPTHOLD_G_672 (.I(sio_data_reg_86), .Z(sio_data_reg_124));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_8_ (.CDN(rst_b_5), .CP(spi_clk_out_15), 
     .D(sio_data_reg_146), .E(n3000_2), .Q(), .QN(n2898));
  EDFCND1HVT oscfsel_reg_1_ (.CDN(rst_b_6), .CP(spi_clk_out_15), 
     .D(sio_data_reg_40), .E(n_1927), .Q(n3202), .QN(n3057));
  CKAN2D1HVT U1422_C1 (.A1(spi_rd_cmdaddr_reg_12), .A2(n2900), 
     .Z(spi_rd_cmdaddr_12));
  EDFCND1HVT usercode_reg_reg_6_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_101), .E(n2982_2), .Q(usercode_reg[6]), .QN());
  NR2D1HVT U1268_C1 (.A1(n2975_1), .A2(n2900_1), .ZN(spi_rd_cmdaddr_16));
  BUFFD1HVT OPTHOLD_G_63 (.I(sio_data_reg_22), .Z(sio_data_reg_69));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_13_ (.CDN(rst_b_5), .CP(spi_clk_out_12), 
     .D(sio_data_reg_148), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_13), .QN());
  CKAN2D1HVT U1415_C1 (.A1(spi_rd_cmdaddr_reg_15), .A2(n2900), 
     .Z(spi_rd_cmdaddr_15));
  INVD4HVT U1427_C1 (.I(n3057), .ZN(smc_osc_fsel[1]));
  BUFFD1HVT OPTHOLD_G_665 (.I(sio_data_reg_83), .Z(sio_data_reg_117));
  XNR2D1HVT U1216_C1 (.A1(sio_data_reg_22), .A2(VSS_magmatienet_21), .ZN(n2934));
  XNR2D1HVT U1215_C1 (.A1(sio_data_reg_17), .A2(VSS_magmatienet_20), .ZN(n2933));
  BUFFD2HVT BW1_BUF1377 (.I(baddr_1_1), .Z(baddr[1]));
  ND4D1HVT U1204_C3 (.A1(n2928), .A2(n2927), .A3(n2926), .A4(n2925), .ZN(n3179));
  XNR2D1HVT U1221_C1 (.A1(sio_data_reg_14), .A2(VDD_magmatienet_8), .ZN(n2938));
  TIELHVT VSS_magmatiecell_18 (.ZN(VSS_magmatienet_18));
  TIELHVT VSS_magmatiecell_2 (.ZN(VSS_magmatienet_2));
  BUFFD1HVT OPTHOLD_G_682 (.I(sio_data_reg_59), .Z(sio_data_reg_128));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_22_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_112), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_Q2106_22), .QN());
  BUFFD1HVT OPTHOLD_G_686 (.I(sio_data_reg_66), .Z(sio_data_reg_132));
  BUFFD1HVT OPTHOLD_G_746 (.I(crc_reg_5_), .Z(crc_reg_5_1));
  EDFCND1HVT start_framenum_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_20), 
     .D(cmdcode_byte_2), .E(n_1531), .Q(start_framenum[0]), .QN());
  EDFCND1HVT usercode_reg_reg_31_ (.CDN(rst_b_2), .CP(spi_clk_out_16), 
     .D(sio_data_reg_119), .E(n2982_2), .Q(usercode_reg[31]), .QN());
  INVD2HVT BL1_R_INV_29 (.I(sdo_rx_4_1), .ZN(sdo_rx_4_));
  BUFFD1HVT OPTHOLD_G_667 (.I(sio_data_reg_88), .Z(sio_data_reg_119));
  DFCNQD1HVT sdo_r_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_18), .D(sdo_rx_6_), 
     .Q(sdo[6]));
  TIELHVT VSS_magmatiecell_9 (.ZN(VSS_magmatienet_9));
  BUFFD1HVT OPTHOLD_G_685 (.I(sio_data_reg_75), .Z(sio_data_reg_131));
  EDFCND1HVT usercode_reg_reg_24_ (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(sio_data_reg_96), .E(n2982_2), .Q(usercode_reg[24]), .QN());
  BUFFD1HVT OPTHOLD_G_47 (.I(sio_data_reg_28), .Z(sio_data_reg_57));
  BUFFD1HVT OPTHOLD_G_548 (.I(sio_data_reg_128), .Z(sio_data_reg_82));
  XNR2D1HVT U1195_C1 (.A1(sio_data_reg_20), .A2(VSS_magmatienet_3), .ZN(n2917));
  BUFFD1HVT OPTHOLD_G_66 (.I(sio_data_reg_73), .Z(sio_data_reg_72));
  CKAN2D1HVT U1304_C1 (.A1(n2996), .A2(fpga_operation_1), .Z(n3002));
  AN3D1HVT U1134_C2 (.A1(n3097_1), .A2(n3090_1), .A3(n2907_1), .Z(n3020));
  CKXOR2D1HVT U1468_C1 (.A1(warmboot_sel_int_1_), .A2(warmboot_sel_int_0_), 
     .Z(n3092));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_3_ (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(sio_data_reg_98), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_3), .QN());
  LHCNDD2HVT warmboot_sel_int_reg_0_ (.CDN(rst_b_3), .D(warmboot_sel[0]), 
     .E(fpga_operation), .Q(warmboot_sel_int_0_), .QN(n3094));
  CKAN2D1HVT U1423_C1 (.A1(spi_rd_cmdaddr_reg_9), .A2(n2900), 
     .Z(spi_rd_cmdaddr_9));
  LHCNDQD1HVT warmboot_int_reg (.CDN(rst_b_4), .D(boot), .E(fpga_operation), 
     .Q(warmboot_int));
  AO211D1HVT U1440_C3 (.A1(n3085_1), .A2(cnt_podt_out), .B(spi_master_go_3), 
     .C(n2883), .Z(smc_podt_rst1100));
  IND2D1HVT U1441_C1 (.A1(n3008), .B1(n2989_1), .ZN(n970_0));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_18_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_117), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_18), .QN());
  EDFCND1HVT start_framenum_reg_5_ (.CDN(rst_b_2), .CP(spi_clk_out_20), 
     .D(sio_data_reg_42), .E(n_1531), .Q(start_framenum[5]), .QN());
  TIELHVT VSS_magmatiecell_12 (.ZN(VSS_magmatienet_12));
  BUFFD8HVT BL1_R_BUF (.I(smc_write_3), .Z(cram_wrt));
  BUFFD1HVT OPTHOLD_G_676 (.I(stop_crc_reg_IQ_1), .Z(stop_crc_reg_IQ_3));
  BUFFD1HVT OPTHOLD_G_552 (.I(sio_data_reg_125), .Z(sio_data_reg_86));
  BUFFD1HVT OPTHOLD_G_328 (.I(cm_smc_sdo_en_int_d3_4), 
     .Z(cm_smc_sdo_en_int_d3_2));
  BUFFD1HVT OPTHOLD_G_25 (.I(sio_data_reg_9), .Z(sio_data_reg_50));
  XNR2D1HVT U1185_C1 (.A1(sio_data_reg_26), .A2(VSS_magmatienet_0), .ZN(n2909));
  OA31D1HVT U1435_C3 (.A1(cram_reading), .A2(cor_en_rdcrc_1), .A3(bram_reading), 
     .B(stop_crc_reg_IQ_3), .Z(crc16_en));
  DFCNQD1HVT sdo_r_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_17), .D(sdo_rx_2_), 
     .Q(sdo[2]));
  IND2D1HVT U1309_C1 (.A1(n3096), .B1(n3097_1), .ZN(n2998));
  NR2D1HVT U1266_C1 (.A1(n3142), .A2(n2983), .ZN(n2974));
  OAI32D2HVT U1128_C4 (.A1(n3145), .A2(n3097), .A3(n3076), .B1(n3153_1), 
     .B2(n2891), .ZN(reboot_source_nvcm));
  IND3D1HVT U1179_C2 (.A1(n3127), .B1(n2905), .B2(n3031_1), .ZN(n2907));
  NR2D1HVT ctrlopt_reg9_11__C8 (.A1(n3197), .A2(N4300_1), 
     .ZN(ctrlopt_reg9_11__N12));
  BUFFD1HVT OPTHOLD_G_957 (.I(ctrlopt_reg4_7__N13_1), .Z(ctrlopt_reg4_7__N13_3));
  MUX4D1HVT U1125 (.I0(N4455), .I1(N4300), .I2(N574), .I3(N3759), 
     .S0(warmboot_sel_int_1_), .S1(warmboot_sel_int_0_), .Z(n2891));
  BUFFD1HVT OPTHOLD_G_321 (.I(bm_smc_sdo_en_int_d1_2), 
     .Z(bm_smc_sdo_en_int_d1_1));
  BUFFD1HVT OPTHOLD_G_1136 (.I(crc_reg_3_1), .Z(crc_reg_3_2));
  BUFFD1HVT OPTHOLD_G_542 (.I(stop_crc_reg_IQ_3), .Z(stop_crc_reg_IQ_2));
  EDFCND1HVT framelen_reg_10_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_109), .E(n3199_1), .Q(framelen[10]), .QN());
  DFCNQD1HVT cram_rd_reg (.CDN(rst_b_1), .CP(clk_b_2), .D(cram_rd465), 
     .Q(smc_read_3));
  BUFFD1HVT OPTHOLD_G_14 (.I(sio_data_reg_4), .Z(sio_data_reg_45));
  BUFFD1HVT OPTHOLD_G_663 (.I(sio_data_reg_29), .Z(sio_data_reg_115));
  BUFFD1HVT OPTHOLD_G_894 (.I(cm_smc_sdo_en_int_d2), .Z(cm_smc_sdo_en_int_d2_5));
  BUFFD1HVT OPTHOLD_F_2 (.I(sio_data_reg_103), .Z(sio_data_reg_140));
  BUFFD1HVT OPTHOLD_G_614 (.I(sio_data_reg_2), .Z(sio_data_reg_100));
  INVD4HVT BL1_R_INV_15 (.I(n3115_2), .ZN(n3115));
  NR2D1HVT U1297_C1 (.A1(sio_data_reg_35), .A2(n3197_1), .ZN(U1297_N3));
  NR3D1HVT U1370_C2 (.A1(n3134), .A2(n3113), .A3(bs_state_2_1), .ZN(n3010));
  INVD1HVT U1303_C1_MP_INV (.I(bs_state_3_), .ZN(bs_state_3_1));
  BUFFD1HVT OPTHOLD_G_364 (.I(tm_en_cram_blsr_test_3), 
     .Z(tm_en_cram_blsr_test_1));
  OR2D1HVT U1445_C1 (.A1(smc_load_nvcm_bstream), .A2(n3197), .Z(n_3905));
  AO211D1HVT U1296_C1 (.A1(n3197_1), .A2(bp0), .B(cor_security_rddis_1), 
     .C(U1297_N3), .Z(n_3904));
  BUFFD1HVT OPTHOLD_G_579 (.I(bm_smc_sdo_en_int_d1_4), 
     .Z(bm_smc_sdo_en_int_d1_3));
  ND2D1HVT U1303_C1 (.A1(bs_state_3_1), .A2(bs_state_1_1), .ZN(n2995));
  AN3D1HVT U1377_C2 (.A1(n3117_1), .A2(cmdreg_code_3_2), .A3(cmdreg_code_2_2), 
     .Z(n3024));
  CKND1HVT ctrlopt_reg9_11__MP_INV_1 (.I(spi_clk_out_21), .ZN(clk_1));
  NR4D1HVT U1237_C3 (.A1(cmdreg_code_2_4), .A2(cmdreg_code_0_), 
     .A3(cmdhead_reg_6), .A4(cmdhead_reg_1), .ZN(n2950));
  ND2D1HVT U1282_C1 (.A1(sio_data_reg_3), .A2(sio_data_reg_2), .ZN(n3106));
  IND2D1HVT U1155_C2 (.A1(cfg_shutdown), .B1(n2894), .ZN(n2885));
  INR2D1HVT U1168_C1 (.A1(n2901), .B1(n2907), .ZN(n3022));
  BUFFD1HVT OPTHOLD_G_983 (.I(n3018), .Z(n3018_1));
  IND2D1HVT U1438_C1 (.A1(n3003), .B1(n3152_1), .ZN(cram_wrt459_1));
  NR2D1HVT U1368_C1 (.A1(n3074), .A2(n2993), .ZN(n3006));
  ND2D1HVT U1460_C1 (.A1(bs_state_3_), .A2(bs_state_1_1), .ZN(n3132));
  BUFFD1HVT OPTHOLD_G_366 (.I(n2882_2), .Z(n2882_1));
  CKXOR2D1HVT U1431_C1 (.A1(spi_ldbstream_trycnt_1_3), 
     .A2(spi_ldbstream_trycnt_0_1), .Z(spi_ldbstream_trycnt1054_1));
  NR3D1HVT U1225_C2 (.A1(n3025), .A2(n3013), .A3(n3012), .ZN(n2941));
  BUFFD1HVT OPTHOLD_G_365 (.I(tm_en_cram_blsr_test), .Z(tm_en_cram_blsr_test_2));
  BUFFD1HVT OPTHOLD_G_866 (.I(N574), .Z(N574_1));
  OR4XD1HVT U1475_C3 (.A1(sio_data_reg_31), .A2(sio_data_reg_24), 
     .A3(sio_data_reg_13), .A4(sio_data_reg_10), .Z(n3137));
  EDFCND1HVT spi_ldbstream_trycnt_reg_1_ (.CDN(rst_b_4), .CP(spi_clk_out_15), 
     .D(spi_ldbstream_trycnt1054_2), .E(n3034), .Q(spi_ldbstream_trycnt_1_), 
     .QN(n2896));
  BUFFD1HVT OPTHOLD_G_130 (.I(sio_data_reg_77), .Z(sio_data_reg_76));
  EDFCND1HVT framelen_reg_13_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_148), .E(n3199), .Q(framelen[13]), .QN());
  NR2D1HVT U1384_C1 (.A1(cm_smc_sdo_en_1), .A2(bm_smc_sdo_en), .ZN(n3033));
  INVD1HVT U1463_C2_MP_INV (.I(n3097), .ZN(n3097_1));
  OR4XD1HVT U1436_C3 (.A1(n3080), .A2(n3079), .A3(idcode_err), .A4(crc_err), 
     .Z(bitstream_err));
  INR2D1HVT U1127_C2_INV (.A1(n2952), .B1(n3118), .ZN(n3119_1));
  NR3D1HVT U1311_C2 (.A1(n2951), .A2(cmdreg_code_2_1), .A3(cmdreg_code_0_3), 
     .ZN(n3000));
  NR3D2HVT U1428_C3 (.A1(n2951), .A2(cmdreg_code_2_1), .A3(cmdreg_code_0_1), 
     .ZN(n_1926));
  OAI21D1HVT U1444_C2 (.A1(n2997), .A2(cmdreg_code_0_1), .B(n2998), .ZN(n_1836));
  BUFFD3HVT OPTHOLD_G_639 (.I(sio_data_reg_52), .Z(sio_data_reg_109));
  EDFCND1HVT usercode_reg_reg_5_ (.CDN(rst_b_3), .CP(spi_clk_out_14), 
     .D(sio_data_reg_42), .E(n2982_2), .Q(usercode_reg[5]), .QN());
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_1_ (.CDN(rst_b_5), .CP(spi_clk_out_15), 
     .D(sio_data_reg_40), .E(n3000_2), .Q(), .QN(n2897));
  CKAN2D1HVT U1418_C1 (.A1(spi_rd_cmdaddr_reg_10), .A2(n2900), 
     .Z(spi_rd_cmdaddr_10));
  BUFFD1HVT OPTHOLD_G_638 (.I(sio_data_reg_55), .Z(sio_data_reg_108));
  BUFFD1HVT OPTHOLD_G_547 (.I(sio_data_reg_127), .Z(sio_data_reg_81));
  BUFFD1HVT OPTHOLD_F_5 (.I(sio_data_reg_114), .Z(sio_data_reg_143));
  CKAN2D1HVT U1410_C1 (.A1(spi_rd_cmdaddr_reg_17), .A2(n2900), 
     .Z(spi_rd_cmdaddr_17));
  BUFFD1HVT OPTHOLD_G_1140 (.I(crc_reg_0_), .Z(crc_reg_0_1));
  OR3XD1HVT U1467_C2 (.A1(n2902), .A2(j_cfg_enable), .A3(j_cfg_disable), 
     .Z(n3162));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_23_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_118), .E(n3000_2), .Q(), .QN(n2978));
  BUFFD1HVT OPTHOLD_G_577 (.I(cm_smc_sdo_en_int_d3), .Z(cm_smc_sdo_en_int_d3_3));
  TIELHVT VSS_magmatiecell_21 (.ZN(VSS_magmatienet_21));
  BUFFD1HVT OPTHOLD_G_963 (.I(n3070), .Z(n3070_2));
  TIELHVT VSS_magmatiecell_22 (.ZN(VSS_magmatienet_22));
  ND4D1HVT U1219_C3 (.A1(n2940), .A2(n2939), .A3(n2938), .A4(n2937), .ZN(n3180));
  ND4D1HVT U1209_C3 (.A1(n2932), .A2(n2931), .A3(n2930), .A4(n2929), .ZN(n3178));
  BUFFD1HVT OPTHOLD_G_51 (.I(sio_data_reg_62), .Z(sio_data_reg_61));
  MUX2D1HVT U1333_C4 (.I0(cm_sdo_u1[1]), .I1(bm_bank_sdo[3]), .S(N576_1), 
     .Z(sdo_rx_3_));
  MUX2D1HVT U1334_C4 (.I0(cm_sdo_u1[0]), .I1(bm_bank_sdo[2]), .S(N576_1), 
     .Z(sdo_rx_2_));
  BUFFD1HVT OPTHOLD_G_684 (.I(sio_data_reg_65), .Z(sio_data_reg_130));
  BUFFD3HVT OPTHOLD_G_635 (.I(sio_data_reg_54), .Z(sio_data_reg_105));
  NR2D1HVT U1270_C1 (.A1(n2977), .A2(n2900_1), .ZN(spi_rd_cmdaddr_19));
  BUFFD1HVT OPTHOLD_G_605 (.I(n3009), .Z(n3009_1));
  ND4D1HVT U1241_C3 (.A1(sio_data_reg_21), .A2(n2954), .A3(U1241_N3), 
     .A4(U1146_N5), .ZN(n3139));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_31_ (.CDN(rst_b_2), .CP(spi_clk_out_18), 
     .D(sio_data_reg_119), .E(n3000_2), .Q(spi_rd_cmdaddr_31), .QN());
  BUFFD1HVT OPTHOLD_G_554 (.I(sio_data_reg_131), .Z(sio_data_reg_88));
  BUFFD1HVT OPTHOLD_G_132 (.I(crc_reg_6_), .Z(crc_reg_6_1));
  OR4XD1HVT U1472_C3 (.A1(n3185), .A2(n3184), .A3(n3183), .A4(n3182), .Z(n3102));
  XNR2D1HVT U1190_C1 (.A1(sio_data_reg_19), .A2(VSS_magmatienet_7), .ZN(n2913));
  AN4D1HVT U1145_C3 (.A1(sio_data_reg_8), .A2(sio_data_reg_4), 
     .A3(sio_data_reg_15), .A4(sio_data_reg_11), .Z(n2954));
  BUFFD1HVT OPTHOLD_G_131 (.I(sio_data_reg_27), .Z(sio_data_reg_77));
  TIELHVT VSS_magmatiecell_10 (.ZN(VSS_magmatienet_10));
  INVD2HVT U1429_C1 (.I(cor_en_8bconfig_1), .ZN(en_8bconfig_b));
  BUFFD3HVT BW2_BUF4993 (.I(sio_data_reg_141), .Z(sio_data_reg_147));
  NR2D1HVT U1167_C1 (.A1(n3106), .A2(n3076), .ZN(n2899));
  BUFFD3HVT OPTHOLD_G_634 (.I(sio_data_reg_50), .Z(sio_data_reg_104));
  BUFFD1HVT OPTHOLD_G_683 (.I(sio_data_reg_56), .Z(sio_data_reg_129));
  BUFFD1HVT OPTHOLD_G_137 (.I(sio_data_reg_25), .Z(sio_data_reg_78));
  NR2D1HVT U1378_C1 (.A1(warmboot_req), .A2(n2900), .ZN(n3026));
  EDFCNQD1HVT ctrlopt_reg8_5_ (.CDN(rst_b_4), .CP(spi_clk_out_14), 
     .D(sio_data_reg_42), .E(n3197_2), .Q(cor_en_warmboot));
  INVD1HVT U1294_C2_MP_INV (.I(n3085_2), .ZN(n3085_1));
  AN3D1HVT U1354_C2 (.A1(spi_rxpreamble_trycnt_2_), 
     .A2(spi_rxpreamble_trycnt_1_), .A3(spi_rxpreamble_trycnt_0_2), .Z(n3085));
  DFCNQD1HVT smc_podt_rst_reg (.CDN(rst_b_6), .CP(spi_clk_out_15), 
     .D(smc_podt_rst1100_1), .Q(smc_podt_rst));
  EDFCND1HVT usercode_reg_reg_17_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_122), .E(n2982_2), .Q(usercode_reg[17]), .QN());
  TIEHHVT VDD_magmatiecell_7 (.Z(VDD_magmatienet_7));
  XNR2D1HVT U1213_C1 (.A1(sio_data_reg_5), .A2(VDD_magmatienet_7), .ZN(n2932));
  BUFFD1HVT OPTHOLD_G_527 (.I(spi_rd_cmdaddr_36), .Z(spi_rd_cmdaddr_33));
  XNR2D1HVT U1262_C1 (.A1(sio_data_reg_3), .A2(crc_reg_3_), .ZN(n2970));
  XNR2D1HVT U1254_C1 (.A1(sio_data_reg_1), .A2(crc_reg_1_), .ZN(n2964));
  BUFFD1HVT OPTHOLD_G_22 (.I(n3087), .Z(n3087_1));
  XNR2D1HVT U1258_C1 (.A1(sio_data_reg_11), .A2(crc_reg_11_), .ZN(n2967));
  BUFFD1HVT OPTHOLD_G_736 (.I(spi_rd_cmdaddr_27), .Z(spi_rd_cmdaddr_36));
  TIELHVT VSS_magmatiecell_6 (.ZN(VSS_magmatienet_6));
  BUFFD3HVT OPTHOLD_G_795 (.I(sio_data_reg_138), .Z(sio_data_reg_137));
  NR2D1HVT U1305_C1 (.A1(n3096), .A2(n3089), .ZN(n2996));
  OR4XD1HVT U1474_C3 (.A1(n3003), .A2(n2986_1), .A3(n2984), .A4(n2974), 
     .Z(n3144));
  NR2D1HVT U1232_C2 (.A1(n3140), .A2(U1232_N3), .ZN(n2948));
  OAI21D2HVT U1284_C2 (.A1(n3132), .A2(n2985), .B(n2986), .ZN(bram_rd477));
  EDFCND1HVT framelen_reg_12_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_110), .E(n3199_1), .Q(framelen[12]), .QN());
  BUFFD1HVT OPTHOLD_G_325 (.I(cm_smc_sdo_en_int_d1), .Z(cm_smc_sdo_en_int_d1_3));
  BUFFD1HVT OPTHOLD_G_300 (.I(bm_smc_sdo_en_int_d3), .Z(bm_smc_sdo_en_int_d3_2));
  BUFFD1HVT OPTHOLD_G_387 (.I(ctrlopt_reg9_10__N13), .Z(ctrlopt_reg9_10__N13_1));
  BUFFD1HVT OPTHOLD_G_763 (.I(sio_data_reg_79), .Z(sio_data_reg_134));
  BUFFD1HVT OPTHOLD_G_1145 (.I(bm_smc_sdo_en_int_d3_2), 
     .Z(bm_smc_sdo_en_int_d3_5));
  BUFFD1HVT OPTHOLD_G_598 (.I(n3155), .Z(n3155_1));
  XNR2D1HVT U1186_C1 (.A1(sio_data_reg_27), .A2(VSS_magmatienet_4), .ZN(n2910));
  BUFFD1HVT OPTHOLD_G_674 (.I(sio_data_reg_93), .Z(sio_data_reg_126));
  EDFCND1HVT framelen_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_98), .E(n3199_1), .Q(framelen[3]), .QN());
  XNR2D1HVT U1264_C1 (.A1(sio_data_reg_13), .A2(crc_reg_13_), .ZN(n2972));
  OR4XD1HVT U1138_C3 (.A1(sio_data_reg_9), .A2(sio_data_reg_7), 
     .A3(sio_data_reg_14), .A4(cmdcode_byte_0), .Z(n3136));
  NR2D1HVT U1374_C1 (.A1(n3162_1), .A2(n2993_1), .ZN(n3017));
  BUFFD1HVT OPTHOLD_G_896 (.I(cmdhead_reg_6), .Z(cmdhead_reg_15));
  BUFFD1HVT OPTHOLD_G_924 (.I(n2882), .Z(n2882_2));
  OR2D1HVT U1285_C1 (.A1(bs_state_2_), .A2(bs_state_0_), .Z(n2985));
  DFCNQD1HVT bm_smc_sdo_en_int_d2_reg (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(bm_smc_sdo_en_int_d1_1), .Q(bm_smc_sdo_en_int_d2));
  BUFFD1HVT OPTHOLD_G_893 (.I(cm_smc_sdo_en_int_d2_3), 
     .Z(cm_smc_sdo_en_int_d2_4));
  AO21D1HVT U1437_C2 (.A1(n3081), .A2(n2981_1), .B(n3027), .Z(bs_smc_sdio_en));
  NR3D1HVT U1142_C3 (.A1(n3098), .A2(bs_state_3_1), .A3(bs_state_1_1), 
     .ZN(n2946));
  INVD1HVT U1483_C2_MP_INV (.I(n2985), .ZN(n2985_1));
  OA32D1HVT U1317_C4 (.A1(n3132), .A2(n2985), .A3(bram_done), .B1(n3140), 
     .B2(n3107), .Z(n3191));
  AOI21D1HVT stop_crc_reg_C9 (.A1(stop_crc_reg_IQ_2), .A2(U1289_N5), .B(n2988), 
     .ZN(stop_crc_reg_N13));
  BUFFD1HVT OPTHOLD_F_12 (.I(sio_data_reg_10), .Z(sio_data_reg_144));
  INVD4HVT BW1_INV869 (.I(n3000_1), .ZN(n3000_2));
  BUFFD1HVT OPTHOLD_G_42 (.I(cmdreg_code_2_4), .Z(cmdreg_code_2_2));
  OR3XD1HVT U1458_C2 (.A1(sio_data_reg_1), .A2(n3119), .A3(cmdcode_byte_0), 
     .Z(n3076));
  DFCND1HVT spi_ldbstream_trycnt_reg_0_ (.CDN(rst_b_6), .CP(spi_clk_out_15), 
     .D(n3069_1), .Q(spi_ldbstream_trycnt_0_), .QN(n2895));
  BUFFD8HVT BL1_R_BUF_2 (.I(cram_wrt459_1), .Z(cram_wrt459));
  BUFFD1HVT OPTHOLD_G_680 (.I(bs_state_2_), .Z(bs_state_2_2));
  AO211D1HVT U1490_C3 (.A1(sr_datacnt_1), .A2(n2949), .B(n3146), .C(n3012), 
     .Z(n3164));
  BUFFD1HVT OPTHOLD_G_135 (.I(spi_ldbstream_trycnt_0_), 
     .Z(spi_ldbstream_trycnt_0_2));
  OR2D1HVT U1439_C1 (.A1(n3023), .A2(n2974), .Z(cram_rd465));
  OR2D1HVT U1461_C1 (.A1(n3132), .A2(n3098), .Z(n3133));
  EDFCND1HVT testmode_reg_reg_5_ (.CDN(rst_b_3), .CP(spi_clk_out_14), 
     .D(sio_data_reg_42), .E(n2992), .Q(), .QN(n2882));
  INVD1HVT U1307_C3_MP_INV_1 (.I(cmdreg_code_3_2), .ZN(cmdreg_code_3_1));
  spi_smc SPI_SMC (.clk(), .rst_b(rst_b), .sdi(sdi), .cfg_startup(cfg_startup), 
     .cdone_in(cdone_in), .spi_rxpreamble_fail(n3085), 
     .bitstream_err(bitstream_err), .cor_dis_flashpd(cor_dis_flashpd), 
     .tx_spicmd_read_req(n2883), .disable_flash_req_BAR(n3150), 
     .cmdhead_cnt_ld(cmdhead_cnt_ld), .cmd_sr_datacnt_ld(n3019), 
     .smc_status_ld(n3020), .smc_crc_ld(n3021), .smc_usercode_ld(n3022), 
     .md_spi(md_spi), .bs_smc_cmdhead_en(n3006), 
     .bs_smc_sdio_en(bs_smc_sdio_en), .md_jtag(md_jtag), .md_jtag_rst(n2902), 
     .j_cfg_enable(j_cfg_enable), .j_cfg_disable(j_cfg_disable), 
     .j_cfg_program(j_cfg_program), .j_sft_dr(j_sft_dr), 
     .spi_ss_out_b_int(spi_ss_out_b_int), .sio_data_reg({sio_data_reg_31, 
     sio_data_reg_30, sio_data_reg_29, sio_data_reg_28, sio_data_reg_27, 
     sio_data_reg_26, sio_data_reg_25, sio_data_reg_24, sio_data_reg_23, 
     sio_data_reg_22, sio_data_reg_21, sio_data_reg_20, sio_data_reg_19, 
     sio_data_reg_18, sio_data_reg_17, sio_data_reg_16, sio_data_reg_15, 
     sio_data_reg_14, sio_data_reg_13, sio_data_reg_12, sio_data_reg_11, 
     sio_data_reg_10, sio_data_reg_9, sio_data_reg_8, sio_data_reg_7, 
     sio_data_reg_6, sio_data_reg_5, sio_data_reg_4, sio_data_reg_3, 
     sio_data_reg_2, sio_data_reg_1, cmdcode_byte_0}), .cmdhead_reg({
     cmdreg_code_3_, cmdreg_code_2_, cmdreg_code_1_, cmdreg_code_0_, 
     cmdhead_reg_3, cmdhead_reg_2, cmdhead_reg_1, cmdhead_reg_0}), 
     .spi_rd_cmdaddr({spi_rd_cmdaddr_31, spi_rd_cmdaddr_30, spi_rd_cmdaddr_29, 
     spi_rd_cmdaddr_28, spi_rd_cmdaddr_27, spi_rd_cmdaddr_26, spi_rd_cmdaddr_25, 
     spi_rd_cmdaddr_24, val2426_24, spi_rd_cmdaddr_22, spi_rd_cmdaddr_21, 
     val2426_21, spi_rd_cmdaddr_19, spi_rd_cmdaddr_18, spi_rd_cmdaddr_17, 
     spi_rd_cmdaddr_16, spi_rd_cmdaddr_15, spi_rd_cmdaddr_14, spi_rd_cmdaddr_13, 
     spi_rd_cmdaddr_12, spi_rd_cmdaddr_11, spi_rd_cmdaddr_10, spi_rd_cmdaddr_9, 
     spi_rd_cmdaddr_8, spi_rd_cmdaddr_7, spi_rd_cmdaddr_6, spi_rd_cmdaddr_5, 
     spi_rd_cmdaddr_4, spi_rd_cmdaddr_3, spi_rd_cmdaddr_2, spi_rd_cmdaddr_1, 
     spi_rd_cmdaddr_0}), .status_int({cm_monitor_cell[3], cm_monitor_cell[2], 
     cm_monitor_cell[1], cm_monitor_cell[0], cor_security_wrtdis, 
     cor_security_rddis, coldboot_sel[1], coldboot_sel[0], warmboot_sel[1], 
     warmboot_sel[0], boot, fpga_operation, cfg_ld_bstream, cdone_out, cdone_in, 
     gwe, gio_hz, gint_hz, cor_dis_flashpd, cor_en_8bconfig, n3202, n3203, 
     smc_oscoff_b, cor_en_oscclk, n3032, n3085, cmdreg_err, cmdcode_err, 
     crc_err, idcode_err, md_spi, md_jtag}), .crc_reg({crc_reg_15_, crc_reg_14_, 
     crc_reg_13_, crc_reg_12_, crc_reg_11_, crc_reg_10_, crc_reg_9_, crc_reg_8_, 
     crc_reg_7_, crc_reg_6_, crc_reg_5_, crc_reg_4_, crc_reg_3_, crc_reg_2_, 
     crc_reg_1_, crc_reg_0_}), .usercode_reg({usercode_reg[31], usercode_reg[30], 
     usercode_reg[29], usercode_reg[28], usercode_reg[27], usercode_reg[26], 
     usercode_reg[25], usercode_reg[24], usercode_reg[23], usercode_reg[22], 
     usercode_reg[21], usercode_reg[20], usercode_reg[19], usercode_reg[18], 
     usercode_reg[17], usercode_reg[16], usercode_reg[15], usercode_reg[14], 
     usercode_reg[13], usercode_reg[12], usercode_reg[11], usercode_reg[10], 
     usercode_reg[9], usercode_reg[8], usercode_reg[7], usercode_reg[6], 
     usercode_reg[5], usercode_reg[4], usercode_reg[3], usercode_reg[2], 
     usercode_reg[1], usercode_reg[0]}), .sr_datacnt_0(sr_datacnt_0), 
     .cmdhead_cnt_0_BAR(cmdhead_cnt_0), .spi_tx_done(spi_tx_done), 
     .spi_clk_out_12(spi_clk_out_15), .spi_clk_out_6(spi_clk_out_6), 
     .sio_data_reg_59(sio_data_reg_59), .spi_rd_cmdaddr_36(spi_rd_cmdaddr_36), 
     .crc_reg_10_2(crc_reg_10_2), .crc_reg_9_1(crc_reg_9_1), 
     .usercode_reg_25_1(usercode_reg_25_1), .cmdhead_reg_16(cmdhead_reg_16), 
     .cmdhead_reg_14(cmdhead_reg_14), .cmdreg_code_0_2(cmdreg_code_0_2), 
     .cmdreg_code_1_2(cmdreg_code_1_2), .cmdreg_code_2_3(cmdreg_code_2_3), 
     .cmdhead_reg_13(cmdhead_reg_13), .sdi_2(sdi_2), 
     .cmdhead_reg_12(cmdhead_reg_12), .crc_reg_3_1(crc_reg_3_1), 
     .cfg_ld_bstream_1(cfg_ld_bstream_1), .cor_en_oscclk_2(cor_en_oscclk_2), 
     .n3085_2(n3085_2), .spi_ss_out_b_int_1(spi_ss_out_b_int_1), 
     .spi_clk_out_11(spi_clk_out_14), .crc_reg_12_2(crc_reg_12_2), 
     .crc_reg_8_1(crc_reg_8_1), .crc_reg_11_1(crc_reg_11_1), 
     .sio_data_reg_65(sio_data_reg_65), .spi_rd_cmdaddr_35(spi_rd_cmdaddr_35), 
     .sio_data_reg_63(sio_data_reg_63), .crc_reg_14_1(crc_reg_14_1), 
     .sio_data_reg_61(sio_data_reg_61), .sio_data_reg_115(sio_data_reg_115), 
     .crc_reg_13_1(crc_reg_13_1), .sio_data_reg_56(sio_data_reg_56), 
     .spi_clk_out_8(spi_clk_out_12), .spi_clk_out_13(spi_clk_out_16), 
     .usercode_reg_6_1(usercode_reg_6_1), .sio_data_reg_136(sio_data_reg_136), 
     .crc_reg_0_1(crc_reg_0_1), .usercode_reg_16_1(usercode_reg_16_1), 
     .crc_reg_7_1(crc_reg_7_1), .sio_data_reg_125(sio_data_reg_125), 
     .crc_reg_5_1(crc_reg_5_1), .usercode_reg_1_1(usercode_reg_1_1), 
     .sio_data_reg_111(sio_data_reg_111), .cor_en_8bconfig_1(cor_en_8bconfig_1), 
     .sio_data_reg_66(sio_data_reg_66), .sio_data_reg_123(sio_data_reg_123), 
     .cor_dis_flashpd_1(cor_dis_flashpd_1), .n2902_1(n2902_1), 
     .spi_clk_out_15(spi_clk_out_19), .spi_clk_out_14(spi_clk_out_18));
  ND4D1HVT U1246_C3 (.A1(n2961), .A2(n2960), .A3(n2959), .A4(n2958), .ZN(n3175));
  XNR2D1HVT U1187_C1 (.A1(sio_data_reg_2), .A2(VSS_magmatienet_6), .ZN(n2911));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_26_ (.CDN(rst_b_2), .CP(spi_clk_out_18), 
     .D(sio_data_reg_113), .E(n3000_2), .Q(spi_rd_cmdaddr_26), .QN());
  EDFCND1HVT framenum_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_40), .E(n3009_1), .Q(framenum[1]), .QN());
  BUFFD1HVT OPTHOLD_G_320 (.I(cm_smc_sdo_en_int_d2_4), 
     .Z(cm_smc_sdo_en_int_d2_2));
  INVD3HVT BL1_R_INV_12 (.I(n3119_1), .ZN(n3119));
  NR2D1HVT U1302_C1 (.A1(n3089), .A2(n2983), .ZN(n2994));
  BUFFD1HVT OPTHOLD_G_68 (.I(sio_data_reg_20), .Z(sio_data_reg_74));
  INVD1HVT U1465_C2_MP_INV (.I(cmdreg_code_2_4), .ZN(cmdreg_code_2_1));
  BUFFD1HVT OPTHOLD_G_290 (.I(cmdhead_reg_0), .Z(cmdhead_reg_9));
  BUFFD1HVT OPTHOLD_G_287 (.I(cmdhead_reg_7), .Z(cmdhead_reg_6));
  BUFFD1HVT OPTHOLD_G_587 (.I(sio_data_reg_133), .Z(sio_data_reg_94));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_19_ (.CDN(rst_b_3), .CP(spi_clk_out_14), 
     .D(sio_data_reg_124), .E(n3000_2), .Q(), .QN(n2977));
  EDFCND1HVT oscfsel_reg_0_ (.CDN(rst_b_6), .CP(spi_clk_out_15), 
     .D(cmdcode_byte_2), .E(n_1927), .Q(n3203), .QN(n3055));
  BUFFD1HVT OPTHOLD_G_910 (.I(cmdhead_reg_10), .Z(cmdhead_reg_18));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_15_ (.CDN(rst_b_5), .CP(spi_clk_out_12), 
     .D(sio_data_reg_108), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_15), .QN());
  EDFCND1HVT usercode_reg_reg_21_ (.CDN(rst_b_4), .CP(spi_clk_out_12), 
     .D(sio_data_reg_120), .E(n2982_2), .Q(usercode_reg[21]), .QN());
  BUFFD1HVT OPTHOLD_G_666 (.I(sio_data_reg_90), .Z(sio_data_reg_118));
  BUFFD1HVT OPTHOLD_G_56 (.I(sio_data_reg_21), .Z(sio_data_reg_66));
  EDFCND1HVT spi_rd_cmdaddr_reg_reg_11_ (.CDN(rst_b_5), .CP(spi_clk_out_12), 
     .D(sio_data_reg_106), .E(n3000_2), .Q(spi_rd_cmdaddr_reg_11), .QN());
  CKAN2D1HVT U1416_C1 (.A1(spi_rd_cmdaddr_reg_14), .A2(n2900), 
     .Z(spi_rd_cmdaddr_14));
  INR2D1HVT U1126_C2 (.A1(md_jtag_r), .B1(j_rst_b), .ZN(n2902));
  BUFFD1HVT OPTHOLD_F_3 (.I(sio_data_reg_107), .Z(sio_data_reg_141));
  BUFFD1HVT OPTHOLD_F_11 (.I(N576_1), .Z(N576_3));
  BUFFD1HVT OPTHOLD_G_384 (.I(ctrlopt_reg4_7__N13_2), .Z(ctrlopt_reg4_7__N13_1));
  BUFFD1HVT OPTHOLD_G_392 (.I(n3070_2), .Z(n3070_1));
  OR4XD1HVT U1471_C3 (.A1(n3181), .A2(n3180), .A3(n3179), .A4(n3178), .Z(n3101));
  XNR2D1HVT U1210_C1 (.A1(sio_data_reg_21), .A2(VSS_magmatienet_17), .ZN(n2929));
  TIEHHVT VDD_magmatiecell_8 (.Z(VDD_magmatienet_8));
  XNR2D1HVT U1223_C1 (.A1(sio_data_reg_24), .A2(VSS_magmatienet_2), .ZN(n2940));
  INR2D1HVT U1328_C2 (.A1(cm_sdo_u3[1]), .B1(N576_1), .ZN(n3200));
  BUFFD1HVT OPTHOLD_G_609 (.I(N576), .Z(N576_2));
  BUFFD1HVT OPTHOLD_G_4 (.I(cmdcode_byte_0), .Z(cmdcode_byte_3));
  BUFFD1HVT OPTHOLD_G_681 (.I(sio_data_reg_68), .Z(sio_data_reg_127));
  EDFCND1HVT start_framenum_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_14), 
     .D(sio_data_reg_40), .E(n_1531), .Q(start_framenum[1]), .QN());
  BUFFD1HVT OPTHOLD_G_604 (.I(n_1530), .Z(n_1531));
  IND2D1HVT U1332_C1_INV (.A1(N576_1), .B1(cm_sdo_u2[0]), .ZN(sdo_rx_4_1));
  TIEHHVT VDD_magmatiecell_1 (.Z(VDD_magmatienet_1));
  EDFCND1HVT testmode_reg_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_18), 
     .D(sio_data_reg_98), .E(n2992), .Q(Uc_3_), .QN());
  TIELHVT VSS_magmatiecell_8 (.ZN(VSS_magmatienet_8));
  XNR2D1HVT U1201_C1 (.A1(sio_data_reg_31), .A2(VSS_magmatienet_8), .ZN(n2922));
  EDFCND1HVT usercode_reg_reg_27_ (.CDN(rst_b_2), .CP(spi_clk_out_16), 
     .D(sio_data_reg_94), .E(n2982_2), .Q(usercode_reg[27]), .QN());
  BUFFD1HVT OPTHOLD_G_115 (.I(crc_reg_14_), .Z(crc_reg_14_1));
  ND4D1HVT U1194_C3 (.A1(n2920), .A2(n2919), .A3(n2918), .A4(n2917), .ZN(n3185));
  AO22D1HVT U1312_C3 (.A1(cm_monitor_cell[0]), .A2(Uc_0_), 
     .B1(cm_monitor_cell[3]), .B2(Uc_3_), .Z(U1312_N7));
  BUFFD1HVT OPTHOLD_G_64 (.I(sio_data_reg_71), .Z(sio_data_reg_70));
  OR3XD1HVT U1456_C2 (.A1(sio_data_reg_1), .A2(n3119), .A3(cmdcode_byte_1), 
     .Z(n3090));
  INVD1HVT U1463_C2_MP_INV_1 (.I(n3090), .ZN(n3090_1));
  BUFFD3HVT OPTHOLD_G_619 (.I(sio_data_reg_48), .Z(sio_data_reg_103));
  INVD1HVT U1240_C3_MP_INV_1 (.I(sio_data_reg_102), .ZN(sio_data_reg_35));
  AO222D1HVT U1448_C5 (.A1(n3093), .A2(n3026), .B1(warmboot_req), .B2(n3092), 
     .C1(spi_rd_cmdaddr_reg_6), .C2(n2900), .Z(spi_rd_cmdaddr_6));
  BUFFD1HVT OPTHOLD_G_586 (.I(cmdhead_reg_17), .Z(cmdhead_reg_12));
  CKAN2D1HVT U1413_C1 (.A1(spi_rd_cmdaddr_reg_1), .A2(n2900), 
     .Z(spi_rd_cmdaddr_0));
  DFCNQD1HVT shutdown_req_reg (.CDN(rst_b_6), .CP(spi_clk_out_15), .D(n3002_1), 
     .Q(shutdown_req));
  EDFCND1HVT spi_rxpreamble_trycnt_reg_0_ (.CDN(rst_b_6), .CP(spi_clk_out_15), 
     .D(spi_rxpreamble_trycnt969_5), .E(n970_0), .Q(spi_rxpreamble_trycnt_0_), 
     .QN());
  INR2D1HVT U1339_C1 (.A1(spi_rxpreamble_trycnt971_1), .B1(n2989), 
     .ZN(spi_rxpreamble_trycnt969_1));
  EDFCND1HVT usercode_reg_reg_19_ (.CDN(rst_b_3), .CP(spi_clk_out_16), 
     .D(sio_data_reg_124), .E(n2982_2), .Q(usercode_reg[19]), .QN());
  XNR2D1HVT U1220_C1 (.A1(sio_data_reg_7), .A2(VSS_magmatienet_12), .ZN(n2937));
  DFCNQD1HVT bram_rd_reg (.CDN(rst_b_1), .CP(clk_b_2), .D(bram_rd477), 
     .Q(bram_rd));
  EDFCND1HVT framenum_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_17), 
     .D(sio_data_reg_97), .E(n3009_1), .Q(framenum[2]), .QN());
  BUFFD1HVT OPTHOLD_G_114 (.I(crc_reg_9_), .Z(crc_reg_9_1));
  ND4D1HVT U1261_C3 (.A1(n2973), .A2(n2972), .A3(n2971), .A4(n2970), .ZN(n3176));
  BUFFD1HVT OPTHOLD_G_128 (.I(crc_reg_1_), .Z(crc_reg_1_1));
  TIEHHVT VDD_magmatiecell_0 (.Z(VDD_magmatienet_0));
  DFCNQD1HVT sdo_r_reg_1_ (.CDN(rst_b_1), .CP(spi_clk_out_18), .D(sdo_rx_1_), 
     .Q(sdo[1]));
  XNR2D1HVT U1259_C1 (.A1(sio_data_reg_5), .A2(crc_reg_5_), .ZN(n2968));
  AO211D1HVT U1459_C3 (.A1(n3097_1), .A2(n2983_1), .B(n2996), .C(n2994), 
     .Z(n3127));
  MOAI22D1HVT U1141_C4 (.A1(n2948), .A2(n2885), .B1(n2946), .B2(n2945), 
     .ZN(n3157));
  NR2D1HVT U1371_C1 (.A1(n3106), .A2(n2983), .ZN(n3011));
  AOI211D1HVT U1383_C3 (.A1(n3145), .A2(md_spi_1), .B(n3097), .C(n3076), 
     .ZN(n3031));
  DFCNQD1HVT bm_smc_sdo_en_int_d3_reg (.CDN(rst_b_2), .CP(spi_clk_out_16), 
     .D(bm_smc_sdo_en_int_d2_3), .Q(bm_smc_sdo_en_int_d3));
  DFNCND1HVT ctrlopt_reg9_9_ (.CDN(rst_b_2), .CPN(clk_1), 
     .D(ctrlopt_reg9_9__N13_1), .Q(), .QN(N4455));
  BUFFD3HVT OPTHOLD_G_613 (.I(sio_data_reg_45), .Z(sio_data_reg_99));
  BUFFD1HVT OPTHOLD_G_901 (.I(bm_smc_sdo_en_int_d2_2), 
     .Z(bm_smc_sdo_en_int_d2_5));
  DFCNQD1HVT stop_crc_reg (.CDN(rst_b_2), .CP(spi_clk_out_18), 
     .D(stop_crc_reg_N13_1), .Q(stop_crc_reg_IQ));
  DFCNQD1HVT cm_smc_sdo_en_int_d3_reg (.CDN(rst_b_2), .CP(spi_clk_out_16), 
     .D(cm_smc_sdo_en_int_d2_1), .Q(cm_smc_sdo_en_int_d3));
  NR3D8HVT U1487_C2 (.A1(n3087_2), .A2(cmdreg_code_1_2), .A3(cmdreg_code_0_1), 
     .ZN(n3197));
  BUFFD1HVT OPTHOLD_G_580 (.I(bm_smc_sdo_en_int_d3_4), 
     .Z(bm_smc_sdo_en_int_d3_3));
  OAI31D1HVT U1382_C1 (.A1(n3175), .A2(n3174), .A3(U1381_N3), 
     .B(cmdreg_code_0_1), .ZN(U1382_N3));
  BUFFD3HVT OPTHOLD_G_1143 (.I(n3199), .Z(n3199_1));
  NR2D4HVT U1488_C1 (.A1(n3155_1), .A2(cmdreg_code_0_2), .ZN(n3199));
  DFSND1HVT spi_rd_cmdaddr_reg_reg_25_ (.CP(spi_clk_out_16), .D(n3071_2), 
     .Q(spi_rd_cmdaddr_25), .QN(), .SDN(rst_b_2));
  BUFFD1HVT OPTHOLD_G_585 (.I(cmdhead_reg_15), .Z(cmdhead_reg_11));
  AN3D1HVT U1267_C2 (.A1(n2995_1), .A2(bs_state_2_), .A3(bs_state_0_), .Z(n3152));
  INVD1HVT U1296_C1_MP_INV (.I(n3197), .ZN(n3197_1));
  INVD1HVT U1385_C2_MP_INV (.I(n3073), .ZN(n3073_1));
  INVD1HVT U1303_C1_MP_INV_1 (.I(bs_state_1_), .ZN(bs_state_1_1));
  AOI211XD1HVT U1369_C1 (.A1(n3073), .A2(n2981_1), .B(n2993_1), .C(U1349_N6_1), 
     .ZN(n3007));
  BUFFD1HVT OPTHOLD_G_610 (.I(n2993), .Z(n2993_2));
  AO31D1HVT U1432_C2 (.A1(n3073_1), .A2(n2981_1), .A3(n2980_1), .B(n3027), 
     .Z(bs_smc_sdo_en));
  BUFFD1HVT OPTHOLD_G_395 (.I(cmdreg_err_reg_N13_2), .Z(cmdreg_err_reg_N13_1));
  BUFFD1HVT OPTHOLD_G_591 (.I(sio_data_reg_134), .Z(sio_data_reg_96));
  IND3D2HVT U1465_C2 (.A1(n3117), .B1(cmdreg_code_2_1), .B2(cmdreg_code_3_3), 
     .ZN(n3087));
  MUX2D1HVT U1357_C4 (.I0(sdo_r_0), .I1(n3171), .S(n3033), .Z(sdo[0]));
  INVD1HVT U1240_C3_MP_INV (.I(sio_data_reg_7), .ZN(sio_data_reg_34));
  BUFFD1HVT OPTHOLD_G_898 (.I(spi_rd_cmdaddr_reg_18), .Z(spi_rd_cmdaddr_reg_19));
  AOI211XD1HVT U1466_C3 (.A1(n3115_3), .A2(U1224_N5), .B(n3158), .C(U1466_N3), 
     .ZN(n3073));
  BUFFD1HVT OPTHOLD_G_796 (.I(spi_rxpreamble_trycnt_1_), 
     .Z(spi_rxpreamble_trycnt_1_1));
  BUFFD1HVT OPTHOLD_G_426 (.I(spi_rxpreamble_trycnt969_2), 
     .Z(spi_rxpreamble_trycnt969_4));
  NR2D1HVT U1275_C1 (.A1(n3148), .A2(n2906), .ZN(n2980));
  INVD1HVT U1245_C2_MP_INV (.I(n2995), .ZN(n2995_1));
  INR2D1HVT U1133_C2 (.A1(n2889), .B1(cmdhead_cnt_0), .ZN(n3019));
  BUFFD1HVT OPTHOLD_G_649 (.I(n3162), .Z(n3162_1));
  OA211D1HVT U1491_C3 (.A1(fpga_operation), .A2(cfg_ld_bstream), .B(n3140), 
     .C(n2995_1), .Z(U1491_N7));
  OR2D1HVT U1433_C1 (.A1(n3010), .A2(n2984), .Z(bram_wrt471));
  BUFFD1HVT OPTHOLD_G_618 (.I(sio_data_reg_6), .Z(sio_data_reg_102));
endmodule

// Entity:serial_crc Model:serial_crc Library:L1
module serial_crc (clk, rst_b, enable, init, data_in, crc_out, crc_reg_3_1, 
     crc_reg_3_2, crc_reg_2_2, crc_reg_4_1, crc_reg_1_2, spi_clk_out_10, 
     crc_reg_12_1, crc_reg_11_1, crc_reg_9_2, crc_reg_9_1, crc_reg_8_2, 
     crc_reg_10_2, crc_reg_6_1, crc_reg_14_1, crc_reg_13_2, crc_reg_13_1, 
     crc_reg_5_1, crc_reg_7_1, spi_clk_out_8);
  input clk, rst_b, enable, init, data_in, crc_reg_3_1, crc_reg_3_2, 
     crc_reg_2_2, crc_reg_4_1, crc_reg_1_2, spi_clk_out_10, crc_reg_12_1, 
     crc_reg_11_1, crc_reg_9_2, crc_reg_9_1, crc_reg_8_2, crc_reg_10_2, 
     crc_reg_6_1, crc_reg_14_1, crc_reg_13_2, crc_reg_13_1, crc_reg_5_1, 
     crc_reg_7_1, spi_clk_out_8;
  output [15:0] crc_out;
  wire n135, n136, n137, n138, n139, n140, n145, n147, n148, n151, n152, n153, 
     n154, n155, n156, n157, n158, n159, n160, n161, n162, n163, n164, U75_N6, 
     U59_N6, U67_N6, U79_N6, U71_N6, U63_N6, U77_N6, U61_N6, U69_N6, U57_N6, 
     U81_N3, U73_N6, U89_N3, U65_N6, U90_N3, init_1, enable_1, N3784, enable_2, 
     rst_b_1, enable_3, N3784_1, n159_1, n163_1, n162_1, n161_1, n151_1, n154_1, 
     n152_1, n153_1, n156_1, n137_1, n164_1, n136_1, N3784_2, n158_1, n157_1, 
     n160_1, n155_1, n151_2, n137_2, n136_2;
  BUFFD1HVT OPTHOLD_G_979 (.I(n136), .Z(n136_2));
  DFSND1HVT lfsr_reg_10_ (.CP(spi_clk_out_10), .D(n155_1), .Q(crc_out[10]), 
     .QN(), .SDN(rst_b_1));
  DFSND1HVT lfsr_reg_11_ (.CP(spi_clk_out_10), .D(n154_1), .Q(crc_out[11]), 
     .QN(), .SDN(rst_b_1));
  AO211D1HVT U76_C2 (.A1(enable_3), .A2(crc_reg_2_2), .B(init), .C(U77_N6), 
     .Z(n161));
  INR2D1HVT U75_C3 (.A1(crc_reg_4_1), .B1(enable_3), .ZN(U75_N6));
  INR2D1HVT U77_C3 (.A1(crc_reg_3_1), .B1(enable_3), .ZN(U77_N6));
  BUFFD1HVT OPTHOLD_G_400 (.I(n151_2), .Z(n151_1));
  AO211D1HVT U80_C1 (.A1(enable_1), .A2(crc_reg_1_2), .B(init), .C(U81_N3), 
     .Z(n163));
  BUFFD1HVT OPTHOLD_G_401 (.I(n154), .Z(n154_1));
  BUFFD1HVT OPTHOLD_G_397 (.I(n163), .Z(n163_1));
  BUFFD1HVT OPTHOLD_G_976 (.I(n151), .Z(n151_2));
  BUFFD1HVT OPTHOLD_G_398 (.I(n162), .Z(n162_1));
  INR2D1HVT U71_C3 (.A1(crc_reg_7_1), .B1(enable_3), .ZN(U71_N6));
  BUFFD1HVT OPTHOLD_G_978 (.I(n137), .Z(n137_2));
  BUFFD1HVT OPTHOLD_G_402 (.I(n152), .Z(n152_1));
  BUFFD1HVT OPTHOLD_G_403 (.I(n153), .Z(n153_1));
  BUFFD1HVT OPTHOLD_G_967 (.I(n158), .Z(n158_1));
  DFSND1HVT lfsr_reg_14_ (.CP(spi_clk_out_10), .D(n152_1), .Q(crc_out[14]), 
     .QN(), .SDN(rst_b_1));
  INR2D1HVT U57_C3 (.A1(crc_out[15]), .B1(enable_3), .ZN(U57_N6));
  AO211D1HVT U56_C2 (.A1(enable_3), .A2(crc_reg_14_1), .B(init), .C(U57_N6), 
     .Z(n151));
  INVD1HVT BW1_INV_D3610 (.I(enable), .ZN(enable_2));
  INVD2HVT BW1_INV3610 (.I(enable_2), .ZN(enable_3));
  AO211D1HVT U58_C2 (.A1(enable_3), .A2(crc_reg_13_2), .B(init), .C(U59_N6), 
     .Z(n152));
  DFSND1HVT lfsr_reg_15_ (.CP(spi_clk_out_10), .D(n151_1), .Q(crc_out[15]), 
     .QN(n139), .SDN(rst_b_1));
  DFSND1HVT lfsr_reg_13_ (.CP(spi_clk_out_10), .D(n153_1), .Q(crc_out[13]), 
     .QN(), .SDN(rst_b_1));
  AO211D1HVT U72_C1 (.A1(enable_3), .A2(crc_reg_5_1), .B(init), .C(U73_N6), 
     .Z(n159));
  BUFFD1HVT OPTHOLD_G_407 (.I(n136_2), .Z(n136_1));
  INR2D1HVT U69_C3 (.A1(crc_reg_8_2), .B1(enable_3), .ZN(U69_N6));
  AO211D1HVT U70_C2 (.A1(enable_3), .A2(crc_reg_6_1), .B(init), .C(U71_N6), 
     .Z(n158));
  AO211D1HVT U66_C1 (.A1(enable_3), .A2(crc_reg_8_2), .B(init), .C(U67_N6), 
     .Z(n156));
  BUFFD1HVT OPTHOLD_G_405 (.I(n137_2), .Z(n137_1));
  INR2D1HVT U67_C3 (.A1(crc_reg_9_1), .B1(enable_3), .ZN(U67_N6));
  DFSND1HVT lfsr_reg_8_ (.CP(spi_clk_out_10), .D(n157_1), .Q(crc_out[8]), .QN(), 
     .SDN(rst_b_1));
  DFSND1HVT lfsr_reg_9_ (.CP(spi_clk_out_10), .D(n156_1), .Q(crc_out[9]), .QN(), 
     .SDN(rst_b_1));
  NR2D1HVT U81_C1 (.A1(enable_1), .A2(N3784_2), .ZN(U81_N3));
  INR2D1HVT U79_C3 (.A1(crc_reg_2_2), .B1(enable_3), .ZN(U79_N6));
  AO211D1HVT U78_C2 (.A1(enable_3), .A2(crc_reg_1_2), .B(init), .C(U79_N6), 
     .Z(n162));
  AO211D1HVT U64_C2 (.A1(enable_3), .A2(crc_reg_9_2), .B(init), .C(U65_N6), 
     .Z(n155));
  DFSND1HVT lfsr_reg_7_ (.CP(spi_clk_out_10), .D(n158_1), .Q(crc_out[7]), .QN(), 
     .SDN(rst_b_1));
  INR2D1HVT U73_C3 (.A1(crc_reg_6_1), .B1(enable_3), .ZN(U73_N6));
  INR2D1HVT U59_C3 (.A1(crc_reg_14_1), .B1(enable_3), .ZN(U59_N6));
  BUFFD1HVT OPTHOLD_G_742 (.I(N3784_1), .Z(N3784_2));
  AO211D1HVT U60_C2 (.A1(enable_3), .A2(crc_reg_12_1), .B(init), .C(U61_N6), 
     .Z(n153));
  OAI211D1HVT U92_C3 (.A1(enable_3), .A2(N3784_2), .B(n135), .C(init_1), 
     .ZN(n164));
  AO21D1HVT U89_C4 (.A1(n138), .A2(enable_1), .B(U89_N3), .Z(n145));
  OAI211D2HVT U85_C3 (.A1(n135), .A2(crc_reg_11_1), .B(n145), .C(init_1), 
     .ZN(n136));
  DFSND1HVT lfsr_reg_12_ (.CP(spi_clk_out_10), .D(n136_1), .Q(crc_out[12]), 
     .QN(n138), .SDN(rst_b_1));
  INVD1HVT U92_C3_MP_INV_1 (.I(init), .ZN(init_1));
  OAI211D1HVT U86_C3 (.A1(n135), .A2(crc_out[4]), .B(n147), .C(init_1), 
     .ZN(n137));
  IND2D1HVT U82_C1 (.A1(n148), .B1(enable_3), .ZN(n135));
  AOI21D1HVT U89_C1 (.A1(n148), .A2(crc_reg_11_1), .B(enable_1), .ZN(U89_N3));
  BUFFD1HVT OPTHOLD_G_141 (.I(N3784), .Z(N3784_1));
  INR2D1HVT U65_C3 (.A1(crc_reg_10_2), .B1(enable_3), .ZN(U65_N6));
  DFSND1HVT lfsr_reg_6_ (.CP(spi_clk_out_10), .D(n159_1), .Q(crc_out[6]), .QN(), 
     .SDN(rst_b_1));
  BUFFD1HVT OPTHOLD_G_406 (.I(n164), .Z(n164_1));
  INR2D1HVT U61_C3 (.A1(crc_reg_13_1), .B1(enable_3), .ZN(U61_N6));
  AO211D1HVT U68_C1 (.A1(enable_3), .A2(crc_reg_7_1), .B(init), .C(U69_N6), 
     .Z(n157));
  AO21D1HVT U90_C4 (.A1(n140), .A2(enable_1), .B(U90_N3), .Z(n147));
  DFSND1HVT lfsr_reg_0_ (.CP(spi_clk_out_10), .D(n164_1), .Q(crc_out[0]), 
     .QN(N3784), .SDN(rst_b_1));
  CKXOR2D1HVT U93_C1 (.A1(n139), .A2(data_in), .Z(n148));
  DFSND1HVT lfsr_reg_5_ (.CP(spi_clk_out_10), .D(n137_1), .Q(crc_out[5]), 
     .QN(n140), .SDN(rst_b_1));
  INR2D1HVT U63_C3 (.A1(crc_reg_11_1), .B1(enable_3), .ZN(U63_N6));
  AO211D1HVT U62_C1 (.A1(enable_3), .A2(crc_reg_10_2), .B(init), .C(U63_N6), 
     .Z(n154));
  INVD1HVT U80_C1_MP_INV (.I(enable_3), .ZN(enable_1));
  AOI21D1HVT U90_C1 (.A1(n148), .A2(crc_out[4]), .B(enable_1), .ZN(U90_N3));
  BUFFD1HVT OPTHOLD_G_968 (.I(n157), .Z(n157_1));
  BUFFD1HVT OPTHOLD_G_970 (.I(n155), .Z(n155_1));
  BUFFD1HVT OPTHOLD_G_969 (.I(n160), .Z(n160_1));
  BUFFD1HVT OPTHOLD_G_394 (.I(n159), .Z(n159_1));
  BUFFD1HVT OPTHOLD_G_399 (.I(n161), .Z(n161_1));
  BUFFD2HVT BL1_BUF70 (.I(rst_b), .Z(rst_b_1));
  BUFFD1HVT OPTHOLD_G_404 (.I(n156), .Z(n156_1));
  DFSND1HVT lfsr_reg_1_ (.CP(spi_clk_out_10), .D(n163_1), .Q(crc_out[1]), .QN(), 
     .SDN(rst_b_1));
  DFSND1HVT lfsr_reg_2_ (.CP(spi_clk_out_10), .D(n162_1), .Q(crc_out[2]), .QN(), 
     .SDN(rst_b_1));
  AO211D1HVT U74_C2 (.A1(enable_3), .A2(crc_reg_3_2), .B(init), .C(U75_N6), 
     .Z(n160));
  DFSND1HVT lfsr_reg_4_ (.CP(spi_clk_out_10), .D(n160_1), .Q(crc_out[4]), .QN(), 
     .SDN(rst_b_1));
  DFSND1HVT lfsr_reg_3_ (.CP(spi_clk_out_8), .D(n161_1), .Q(crc_out[3]), .QN(), 
     .SDN(rst_b_1));
endmodule

// Entity:spi_smc Model:spi_smc Library:L1
module spi_smc (clk, rst_b, sdi, cfg_startup, cdone_in, spi_rxpreamble_fail, 
     bitstream_err, cor_dis_flashpd, tx_spicmd_read_req, disable_flash_req_BAR, 
     cmdhead_cnt_ld, cmd_sr_datacnt_ld, smc_status_ld, smc_crc_ld, 
     smc_usercode_ld, md_spi, bs_smc_cmdhead_en, bs_smc_sdio_en, md_jtag, 
     md_jtag_rst, j_cfg_enable, j_cfg_disable, j_cfg_program, j_sft_dr, 
     spi_ss_out_b_int, sio_data_reg, cmdhead_reg, spi_rd_cmdaddr, status_int, 
     crc_reg, usercode_reg, sr_datacnt_0, cmdhead_cnt_0_BAR, spi_tx_done, 
     spi_clk_out_12, spi_clk_out_6, sio_data_reg_59, spi_rd_cmdaddr_36, 
     crc_reg_10_2, crc_reg_9_1, usercode_reg_25_1, cmdhead_reg_16, 
     cmdhead_reg_14, cmdreg_code_0_2, cmdreg_code_1_2, cmdreg_code_2_3, 
     cmdhead_reg_13, sdi_2, cmdhead_reg_12, crc_reg_3_1, cfg_ld_bstream_1, 
     cor_en_oscclk_2, n3085_2, spi_ss_out_b_int_1, spi_clk_out_11, crc_reg_12_2, 
     crc_reg_8_1, crc_reg_11_1, sio_data_reg_65, spi_rd_cmdaddr_35, 
     sio_data_reg_63, crc_reg_14_1, sio_data_reg_61, sio_data_reg_115, 
     crc_reg_13_1, sio_data_reg_56, spi_clk_out_8, spi_clk_out_13, 
     usercode_reg_6_1, sio_data_reg_136, crc_reg_0_1, usercode_reg_16_1, 
     crc_reg_7_1, sio_data_reg_125, crc_reg_5_1, usercode_reg_1_1, 
     sio_data_reg_111, cor_en_8bconfig_1, sio_data_reg_66, sio_data_reg_123, 
     cor_dis_flashpd_1, n2902_1, spi_clk_out_15, spi_clk_out_14);
  input clk, rst_b, sdi, cfg_startup, cdone_in, spi_rxpreamble_fail, 
     bitstream_err, cor_dis_flashpd, tx_spicmd_read_req, disable_flash_req_BAR, 
     cmdhead_cnt_ld, cmd_sr_datacnt_ld, smc_status_ld, smc_crc_ld, 
     smc_usercode_ld, md_spi, bs_smc_cmdhead_en, bs_smc_sdio_en, md_jtag, 
     md_jtag_rst, j_cfg_enable, j_cfg_disable, j_cfg_program, j_sft_dr, 
     spi_clk_out_12, spi_clk_out_6, sio_data_reg_59, spi_rd_cmdaddr_36, 
     crc_reg_10_2, crc_reg_9_1, usercode_reg_25_1, cmdhead_reg_16, 
     cmdhead_reg_14, cmdreg_code_0_2, cmdreg_code_1_2, cmdreg_code_2_3, 
     cmdhead_reg_13, sdi_2, cmdhead_reg_12, crc_reg_3_1, cfg_ld_bstream_1, 
     cor_en_oscclk_2, n3085_2, spi_ss_out_b_int_1, spi_clk_out_11, crc_reg_12_2, 
     crc_reg_8_1, crc_reg_11_1, sio_data_reg_65, spi_rd_cmdaddr_35, 
     sio_data_reg_63, crc_reg_14_1, sio_data_reg_61, sio_data_reg_115, 
     crc_reg_13_1, sio_data_reg_56, spi_clk_out_8, spi_clk_out_13, 
     usercode_reg_6_1, sio_data_reg_136, crc_reg_0_1, usercode_reg_16_1, 
     crc_reg_7_1, sio_data_reg_125, crc_reg_5_1, usercode_reg_1_1, 
     sio_data_reg_111, cor_en_8bconfig_1, sio_data_reg_66, sio_data_reg_123, 
     cor_dis_flashpd_1, n2902_1, spi_clk_out_15, spi_clk_out_14;
  output spi_ss_out_b_int, sr_datacnt_0, cmdhead_cnt_0_BAR, spi_tx_done;
  input [31:0] spi_rd_cmdaddr;
  input [31:0] status_int;
  input [15:0] crc_reg;
  input [31:0] usercode_reg;
  output [31:0] sio_data_reg;
  output [7:0] cmdhead_reg;
  wire sio_data_reg_14_1, sio_data_reg_13_1, sio_data_reg_12_1, 
     sio_data_reg_11_1, sio_data_reg_10_1, sio_data_reg_9_1, sio_data_reg_8_1, 
     sio_data_reg_7_1, sio_data_reg_6_1, sio_data_reg_5_1, sio_data_reg_4_1, 
     sio_data_reg_3_1, sio_data_reg_2_1, sio_data_reg_1_1, sio_data_reg_0_1, 
     cmdhead_cnt831_0, cmdhead_cnt831_1, cmdhead_cnt831_2, cmdhead_cnt831_3, 
     cmdhead_cnt831_4, cmdhead_cnt833_0, cmdhead_cnt833_1, cmdhead_cnt833_2, 
     cmdhead_cnt833_3, cmdhead_cnt833_4, cmdhead_cnt_0_, cmdhead_cnt_1_, 
     cmdhead_cnt_2_, cmdhead_cnt_3_, cmdhead_cnt_4_, n1142, n1143, n1144, n1145, 
     n1146, n1147, n1148, n1149, n1150, n1151, n1152, n1153, n1154, n1155, 
     n1156, n1158, n1159, n1160, n1161, n1162, n1164, n1165, n1167, n1168, 
     n1169, n1170, n1172, n1173, n1174, n1175, n1176, n1178, n1179, n1180, 
     n1182, n1185, n1186, n1187, n1190, n1191, n1193, n1194, n1195, n1196, 
     n1197, n1198, n1199, n1200, n1202, n1203, n1204, n1205, n1206, n1207, 
     n1208, n1209, n1210, n1211, n1212, n1213, n1214, n1215, n1216, n1217, 
     n1218, n1219, n1220, n1224, n1235, n1237, n1238, n1240, n1244, n1245, 
     n1247, n1249, n1253, n1254, n1255, n1256, n1336, n1360, n1447, n1448, 
     n1449, n1450, n1451, n1452, n1453, n1456, n1457, n1458, n1459, n1460, 
     n1465, n1466, n1470, n1474, n1475, n1476, n1479, n1480, n1483, n1484, 
     n1485, n1486, n1490, n1491, n1494, n1495, n1496, n1497, n1501, n1502, 
     n1504, n1505, n1506, n1511, n1512, n1513, n1514, n1515, n1516, n347_0, 
     n686_0, n832_0, n_1529, n_1545, n_1943, sio_data_reg_int451_0, 
     sio_data_reg_int451_1, sio_data_reg_int451_10, sio_data_reg_int451_11, 
     sio_data_reg_int451_12, sio_data_reg_int451_13, sio_data_reg_int451_14, 
     sio_data_reg_int451_15, sio_data_reg_int451_16, sio_data_reg_int451_17, 
     sio_data_reg_int451_18, sio_data_reg_int451_19, sio_data_reg_int451_2, 
     sio_data_reg_int451_20, sio_data_reg_int451_21, sio_data_reg_int451_22, 
     sio_data_reg_int451_23, sio_data_reg_int451_24, sio_data_reg_int451_25, 
     sio_data_reg_int451_26, sio_data_reg_int451_27, sio_data_reg_int451_28, 
     sio_data_reg_int451_29, sio_data_reg_int451_3, sio_data_reg_int451_30, 
     sio_data_reg_int451_31, sio_data_reg_int451_4, sio_data_reg_int451_5, 
     sio_data_reg_int451_6, sio_data_reg_int451_7, sio_data_reg_int451_8, 
     sio_data_reg_int451_9, spicnt346_0, spicnt346_1, spicnt346_2, spicnt346_3, 
     spicnt346_4, spicnt346_5, spicnt346_6, spicnt346_7, spicnt348_0, 
     spicnt348_1, spicnt348_2, spicnt348_3, spicnt348_4, spicnt348_5, 
     spicnt348_6, spicnt348_7, spicnt_0_, spicnt_1_, spicnt_2_, spicnt_3_, 
     spicnt_4_, spicnt_5_, spicnt_6_, spicnt_7_, sr_datacnt685_0, 
     sr_datacnt685_1, sr_datacnt685_2, sr_datacnt685_3, sr_datacnt685_4, 
     sr_datacnt685_5, sr_datacnt687_0, sr_datacnt687_1, sr_datacnt687_2, 
     sr_datacnt687_3, sr_datacnt687_4, sr_datacnt687_5, sr_datacnt_0_, 
     sr_datacnt_1_, sr_datacnt_2_, sr_datacnt_3_, sr_datacnt_4_, sr_datacnt_5_, 
     state_0_, state_1_, state_2_, state_3_, U661_N3, U644_N6, U693_N7, U553_N3, 
     U695_N7, U631_N6, U743_N3, U696_N7, U727_N5, U566_N6, U597_N4, U606_N4, 
     U751_N5, U688_N7, U685_N7, U612_N6, U690_N7, U682_N7, U684_N7, U683_N7, 
     U592_N6, U686_N7, U626_N4, U694_N7, U600_N4, U609_N6, U757_N5, U691_N7, 
     U689_N7, U692_N7, U603_N6, U758_N5, state_2_1, n1195_1, n1179_1, n1175_1, 
     n1199_1, n1197_1, state_0_1, tx_spicmd_read_req_1, n1174_1, n1243_1, 
     n1161_1, state_1_1, md_spi_1, n1172_1, n1159_1, smc_crc_ld_1, n1497_1, 
     n1515_1, n1516_1, n1166_1, n1249_1, n1173_1, n1198_1, n1170_1, rst_b_1, 
     n1196_1, rst_b_2, rst_b_3, n1166_3, n1196_2, n1166, cmdhead_cnt_1, 
     cmdreg_code_1_4, cmdhead_reg_4_1, cmdreg_code_1_3, sio_data_reg_0_2, 
     n1475_1, sr_datacnt_4_1, cmdhead_cnt_3_1, cmdhead_cnt_0_1, sr_datacnt_0_1, 
     spicnt_0_1, cmdhead_cnt833_5, spicnt348_8, cmdhead_cnt_2_1, spicnt_2_1, 
     spicnt_7_1, spicnt_4_1, cmdhead_cnt833_6, spicnt_6_1, sr_datacnt687_6, 
     cmdhead_cnt833_7, sr_datacnt687_7, spicnt348_9, n1213_1, n1211_1, n1202_1, 
     sio_data_reg_int451_32, sio_data_reg_int451_33, sio_data_reg_int451_34, 
     sio_data_reg_int451_35, sio_data_reg_int451_36, sio_data_reg_int451_37, 
     sio_data_reg_int451_38, sio_data_reg_int451_39, sio_data_reg_int451_40, 
     sio_data_reg_int451_41, sio_data_reg_int451_42, sio_data_reg_int451_43, 
     sio_data_reg_int451_44, sio_data_reg_int451_45, sio_data_reg_int451_46, 
     sio_data_reg_int451_47, sio_data_reg_int451_48, sio_data_reg_int451_49, 
     sio_data_reg_int451_50, sio_data_reg_int451_51, sio_data_reg_int451_52, 
     sio_data_reg_int451_53, sio_data_reg_int451_54, sio_data_reg_int451_55, 
     sio_data_reg_int451_56, sio_data_reg_int451_57, sio_data_reg_int451_58, 
     sio_data_reg_int451_59, cmdhead_reg_4_2, n_1944, sr_datacnt_5_1, n1475_2, 
     n1475_3, state_1_2, n1244_1, spicnt_5_2, sr_datacnt_3_2, spicnt_3_2, 
     sr_datacnt_2_2, cmdhead_cnt_1_1, sr_datacnt_1_1, cmdhead_cnt_0_2, 
     spicnt_1_1, n1199_2, sr_datacnt687_8, cmdhead_cnt_4_1, spicnt348_10, 
     cmdhead_cnt833_8, cmdhead_cnt833_9, sr_datacnt687_9, sr_datacnt687_10, 
     cmdhead_cnt833_10, spicnt348_11, sr_datacnt687_11, spicnt348_12, 
     spicnt348_13, cmdhead_cnt833_11, spicnt348_14, spicnt348_15, n1212_1, 
     n1213_2, n1240_1, n1202_2, n1202_3, spicnt346_8, spicnt346_9, 
     cmdhead_cnt831_5, cmdhead_cnt831_6, sio_data_reg_int451_60, 
     sio_data_reg_int451_61, sio_data_reg_int451_62, sio_data_reg_int451_63, 
     sio_data_reg_int451_64, sio_data_reg_int451_65, sio_data_reg_int451_66, 
     sio_data_reg_int451_67, sio_data_reg_int451_68, sio_data_reg_int451_69, 
     sio_data_reg_int451_70, sio_data_reg_int451_71, sio_data_reg_int451_72, 
     sio_data_reg_int451_73, sio_data_reg_int451_74, sio_data_reg_int451_75, 
     sio_data_reg_int451_76, sio_data_reg_int451_77, sio_data_reg_int451_78, 
     sio_data_reg_int451_79, sio_data_reg_int451_80, sio_data_reg_int451_81, 
     sio_data_reg_int451_82, sio_data_reg_int451_83, sio_data_reg_int451_84, 
     sio_data_reg_int451_85, sio_data_reg_int451_86, sio_data_reg_int451_87, 
     sio_data_reg_int451_88, sio_data_reg_int451_89, sio_data_reg_int451_90, 
     sio_data_reg_int451_91, sio_data_reg_int451_92, sio_data_reg_int451_93, 
     sio_data_reg_int451_94, sio_data_reg_int451_95, sio_data_reg_int451_96, 
     sio_data_reg_int451_97, n1211_2, n1213_3;
  EDFCND1HVT sio_data_reg_int_reg_0_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_int451_62), .E(n1224), .Q(sio_data_reg_0_1), .QN());
  NR2D1HVT U547_C1 (.A1(cmdhead_reg[1]), .A2(cmdhead_reg[0]), .ZN(n1150));
  ND3D1HVT U550_C2 (.A1(n1486), .A2(n1154), .A3(cmd_sr_datacnt_ld), .ZN(n1484));
  spi_smc_DW01_dec_8_0 sub_285 (.A({spicnt_7_, spicnt_6_, spicnt_5_, spicnt_4_, 
     spicnt_3_, spicnt_2_, spicnt_1_, spicnt_0_}), .SUM({spicnt348_7, spicnt348_6, 
     spicnt348_5, spicnt348_4, spicnt348_3, spicnt348_2, spicnt348_1, 
     spicnt348_0}), .spicnt_1_1(spicnt_1_1), .spicnt_0_1(spicnt_0_1), 
     .spicnt_2_1(spicnt_2_1), .spicnt_7_1(spicnt_7_1), .spicnt_3_2(spicnt_3_2), 
     .spicnt_5_2(spicnt_5_2), .spicnt_6_1(spicnt_6_1), .spicnt_4_1(spicnt_4_1));
  EDFCND1HVT sio_data_reg_int_reg_26_ (.CDN(rst_b_2), .CP(spi_clk_out_13), 
     .D(sio_data_reg_int451_85), .E(n_1529), .Q(sio_data_reg[26]), .QN());
  AO22D1HVT U683_C3 (.A1(sio_data_reg[2]), .A2(n1179), .B1(usercode_reg[3]), 
     .B2(n1497), .Z(U683_N7));
  BUFFD1HVT OPTHOLD_G_434 (.I(sio_data_reg_int451_22), 
     .Z(sio_data_reg_int451_46));
  EDFCND1HVT sio_data_reg_int_reg_29_ (.CDN(rst_b_2), .CP(spi_clk_out_8), 
     .D(sio_data_reg_int451_94), .E(n_1529), .Q(sio_data_reg[29]), .QN());
  BUFFD1HVT OPTHOLD_G_1025 (.I(sio_data_reg_int451_29), 
     .Z(sio_data_reg_int451_93));
  AOI222D1HVT U607_C5 (.A1(sio_data_reg_61), .A2(n1195), .B1(spi_rd_cmdaddr[31]), 
     .B2(n1196_2), .C1(status_int[31]), .C2(n1166_3), .ZN(n1187));
  AO221D1HVT U702_C4 (.A1(n1502), .A2(crc_reg_14_1), .B1(usercode_reg[30]), 
     .B2(n1501), .C(n1452), .Z(sio_data_reg_int451_30));
  BUFFD1HVT OPTHOLD_G_1026 (.I(sio_data_reg_int451_59), 
     .Z(sio_data_reg_int451_94));
  BUFFD1HVT OPTHOLD_G_420 (.I(sio_data_reg_int451_10), 
     .Z(sio_data_reg_int451_43));
  IND3D1HVT U571_C2 (.A1(n1470), .B1(state_2_), .B2(state_0_), .ZN(n1164));
  BUFFD3HVT BW2_BUF2767 (.I(n1211), .Z(n1211_2));
  NR2D1HVT U667_C1 (.A1(n1475_2), .A2(n1199_1), .ZN(n1211));
  INVD1HVT U666_C1_MP_INV (.I(n1173), .ZN(n1173_1));
  IND2D1HVT U558_C1 (.A1(n1476), .B1(state_2_), .ZN(n1159));
  OR3XD1HVT U747_C2 (.A1(n2902_1), .A2(j_cfg_enable), .A3(j_cfg_disable), 
     .Z(n1475));
  BUFFD1HVT OPTHOLD_G_960 (.I(n1213_1), .Z(n1213_2));
  AO21D1HVT U733_C2 (.A1(spicnt348_14), .A2(n1175_1), .B(n1204), .Z(spicnt346_7));
  ND4D1HVT U544_C3 (.A1(n1145), .A2(n1144), .A3(n1143), .A4(n1142), .ZN(n1480));
  EDFCND1HVT spicnt_reg_4_ (.CDN(rst_b_3), .CP(spi_clk_out_6), .D(spicnt346_4), 
     .E(n347_0), .Q(spicnt_4_), .QN(n1149));
  BUFFD1HVT OPTHOLD_G_954 (.I(n1212), .Z(n1212_1));
  BUFFD1HVT OPTHOLD_G_433 (.I(sio_data_reg_int451_80), 
     .Z(sio_data_reg_int451_45));
  BUFFD1HVT OPTHOLD_G_993 (.I(sio_data_reg_int451_32), 
     .Z(sio_data_reg_int451_66));
  ND2D1HVT U603_C2 (.A1(spi_rd_cmdaddr[21]), .A2(n1196_2), .ZN(U603_N6));
  AO221D1HVT U675_C4 (.A1(sio_data_reg_123), .A2(n1195), .B1(spi_rd_cmdaddr[17]), 
     .B2(n1196_2), .C(n1256), .Z(sio_data_reg_int451_17));
  EDFCND1HVT sio_data_reg_int_reg_10_ (.CDN(rst_b_3), .CP(spi_clk_out_6), 
     .D(sio_data_reg_int451_74), .E(n1224), .Q(sio_data_reg_10_1), .QN());
  BUFFD1HVT OPTHOLD_G_1010 (.I(sio_data_reg_int451_42), 
     .Z(sio_data_reg_int451_78));
  BUFFD1HVT OPTHOLD_G_343 (.I(spicnt348_1), .Z(spicnt348_8));
  OR2D1HVT U740_C1 (.A1(sr_datacnt687_9), .A2(n1450), .Z(sr_datacnt685_2));
  AO221D1HVT U682_C4 (.A1(spi_rd_cmdaddr[15]), .A2(n1196_2), .B1(status_int[15]), 
     .B2(n1166_3), .C(U682_N7), .Z(sio_data_reg_int451_15));
  AO22D1HVT U684_C3 (.A1(sio_data_reg[13]), .A2(n1179), .B1(usercode_reg[14]), 
     .B2(n1497), .Z(U684_N7));
  BUFFD2HVT BW1_BUF2665 (.I(sio_data_reg_14_1), .Z(sio_data_reg[14]));
  DFCNQD1HVT state_reg_2_ (.CDN(rst_b_3), .CP(spi_clk_out_15), .D(n1212_1), 
     .Q(state_2_));
  IND2D1HVT U743_C1 (.A1(n1165), .B1(n1164), .ZN(U743_N3));
  OR4XD1HVT U584_C3 (.A1(n1495), .A2(n1494), .A3(n1483), .A4(n1219), .Z(n1173));
  OR4XD1HVT U757_C3 (.A1(n1515), .A2(n1215), .A3(n1165), .A4(U757_N5), .Z(n1496));
  BUFFD3HVT BW1_BUF2678 (.I(sio_data_reg_1_1), .Z(sio_data_reg[1]));
  OR3XD1HVT U749_C2 (.A1(n1456), .A2(n1205), .A3(n1195_1), .Z(n1490));
  OR2D1HVT U758_C3 (.A1(n1516), .A2(U758_N5), .Z(n1494));
  OAI221D1HVT U557_C4 (.A1(n1174_1), .A2(n1159), .B1(n1243_1), .B2(n1162), 
     .C(n1160), .ZN(n1483));
  BUFFD1HVT OPTHOLD_G_990 (.I(sio_data_reg_int451_33), 
     .Z(sio_data_reg_int451_63));
  AO22D1HVT U682_C3 (.A1(sio_data_reg[14]), .A2(n1179), .B1(usercode_reg[15]), 
     .B2(n1497), .Z(U682_N7));
  BUFFD1HVT OPTHOLD_G_1001 (.I(sio_data_reg_int451_39), 
     .Z(sio_data_reg_int451_73));
  BUFFD2HVT BW1_BUF2667 (.I(sio_data_reg_12_1), .Z(sio_data_reg[12]));
  OAI211D1HVT U603_C4 (.A1(n1195_1), .A2(n1186), .B(n1185), .C(U603_N6), 
     .ZN(sio_data_reg_int451_21));
  EDFCND1HVT sio_data_reg_int_reg_22_ (.CDN(rst_b_2), .CP(spi_clk_out_8), 
     .D(sio_data_reg_int451_46), .E(n_1545), .Q(sio_data_reg[22]), .QN(n1194));
  BUFFD1HVT OPTHOLD_G_353 (.I(spicnt_4_), .Z(spicnt_4_1));
  BUFFD1HVT OPTHOLD_G_772 (.I(spicnt_3_), .Z(spicnt_3_2));
  AO211D1HVT U582_C2 (.A1(n1453), .A2(n1219), .B(n1215), .C(U727_N5), .Z(n1172));
  AO22D1HVT U688_C3 (.A1(sio_data_reg[10]), .A2(n1179), .B1(usercode_reg[11]), 
     .B2(n1497), .Z(U688_N7));
  NR2D1HVT U617_C1 (.A1(n1174), .A2(n1159), .ZN(n1196));
  AO221D1HVT U688_C4 (.A1(spi_rd_cmdaddr[11]), .A2(n1196_2), .B1(status_int[11]), 
     .B2(n1166_3), .C(U688_N7), .Z(sio_data_reg_int451_11));
  AO221D1HVT U678_C4 (.A1(sio_data_reg_125), .A2(n1195), .B1(spi_rd_cmdaddr[20]), 
     .B2(n1196_2), .C(n1254), .Z(sio_data_reg_int451_20));
  BUFFD1HVT OPTHOLD_G_1021 (.I(sio_data_reg_int451_53), 
     .Z(sio_data_reg_int451_89));
  INVD1HVT U753_C1_MP_INV (.I(n1497), .ZN(n1497_1));
  EDFCND1HVT sio_data_reg_int_reg_19_ (.CDN(rst_b_2), .CP(spi_clk_out_13), 
     .D(sio_data_reg_int451_92), .E(n_1545), .Q(sio_data_reg[19]), .QN());
  AO222D1HVT U764_C5 (.A1(n1502), .A2(crc_reg[6]), .B1(status_int[22]), 
     .B2(n1166_3), .C1(usercode_reg[22]), .C2(n1501), .Z(n1253));
  AO221D1HVT U692_C4 (.A1(spi_rd_cmdaddr[10]), .A2(n1196_2), .B1(status_int[10]), 
     .B2(n1166_3), .C(U692_N7), .Z(sio_data_reg_int451_10));
  EDFCND1HVT cmdhead_reg_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_13), 
     .D(cmdreg_code_1_2), .E(n_1944), .Q(cmdhead_reg[6]), .QN());
  EDFCND1HVT cmdhead_cnt_reg_3_ (.CDN(rst_b_3), .CP(spi_clk_out_15), 
     .D(cmdhead_cnt831_6), .E(n832_0), .Q(cmdhead_cnt_3_), .QN(n1167));
  BUFFD1HVT OPTHOLD_G_912 (.I(cmdhead_cnt_4_), .Z(cmdhead_cnt_4_1));
  BUFFD1HVT OPTHOLD_G_169 (.I(cmdhead_cnt_0_), .Z(cmdhead_cnt_0_1));
  OR2D1HVT U732_C1 (.A1(cmdhead_cnt_ld), .A2(cmdhead_cnt833_5), 
     .Z(cmdhead_cnt831_0));
  OR2D1HVT U731_C1 (.A1(cmdhead_cnt_ld), .A2(cmdhead_cnt833_6), 
     .Z(cmdhead_cnt831_1));
  ND2D1HVT U578_C1 (.A1(n1168), .A2(n1167), .ZN(n1505));
  BUFFD1HVT OPTHOLD_G_984 (.I(cmdhead_cnt831_2), .Z(cmdhead_cnt831_5));
  BUFFD1HVT OPTHOLD_G_1016 (.I(sio_data_reg_int451_26), 
     .Z(sio_data_reg_int451_84));
  BUFFD1HVT OPTHOLD_G_437 (.I(sio_data_reg_int451_81), 
     .Z(sio_data_reg_int451_49));
  BUFFD1HVT OPTHOLD_G_1013 (.I(sio_data_reg_int451_17), 
     .Z(sio_data_reg_int451_81));
  EDFCND1HVT spicnt_reg_3_ (.CDN(rst_b_3), .CP(spi_clk_out_6), .D(spicnt346_3), 
     .E(n347_0), .Q(spicnt_3_), .QN(n1147));
  AOI21D1HVT U566_C4 (.A1(state_1_2), .A2(n1197_1), .B(U566_N6), .ZN(n1237));
  BUFFD2HVT BW1_BUF2673 (.I(sio_data_reg_6_1), .Z(sio_data_reg[6]));
  INVD1HVT U623_C3_MP_INV (.I(n1197), .ZN(n1197_1));
  NR2D3HVT U753_C1 (.A1(smc_crc_ld), .A2(n1497_1), .ZN(n1501));
  BUFFD1HVT OPTHOLD_G_436 (.I(sio_data_reg_int451_25), 
     .Z(sio_data_reg_int451_48));
  BUFFD1HVT OPTHOLD_G_1017 (.I(sio_data_reg_int451_50), 
     .Z(sio_data_reg_int451_85));
  AO221D1HVT U704_C4 (.A1(n1502), .A2(crc_reg_10_2), .B1(usercode_reg[26]), 
     .B2(n1501), .C(n1451), .Z(sio_data_reg_int451_26));
  AO222D1HVT U763_C5 (.A1(n1514), .A2(n1195), .B1(spi_rd_cmdaddr[25]), 
     .B2(n1196_2), .C1(status_int[25]), .C2(n1166_3), .Z(n1448));
  BUFFD1HVT OPTHOLD_G_415 (.I(sio_data_reg_int451_70), 
     .Z(sio_data_reg_int451_38));
  BUFFD1HVT OPTHOLD_G_1028 (.I(sio_data_reg_int451_24), 
     .Z(sio_data_reg_int451_96));
  BUFFD8HVT BL1_R_BUF_8 (.I(cmdhead_reg_4_2), .Z(cmdhead_reg[4]));
  EDFCND1HVT cmdhead_reg_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_11), 
     .D(cmdhead_reg_13), .E(n_1944), .Q(cmdhead_reg[3]), .QN(n1154));
  DFCNQD1HVT spi_tx_done_reg (.CDN(rst_b_3), .CP(spi_clk_out_12), .D(n1202_3), 
     .Q(spi_tx_done));
  NR2XD2HVT U754_C1 (.A1(smc_crc_ld_1), .A2(n1247), .ZN(n1502));
  INR2D1HVT U575_C1 (.A1(smc_status_ld), .B1(n1196_2), .ZN(n1166));
  INVD1HVT U754_C1_MP_INV (.I(smc_crc_ld), .ZN(smc_crc_ld_1));
  BUFFD1HVT OPTHOLD_G_996 (.I(sio_data_reg_int451_40), 
     .Z(sio_data_reg_int451_69));
  BUFFD2HVT BW1_BUF2677 (.I(sio_data_reg_2_1), .Z(sio_data_reg[2]));
  BUFFD2HVT BW1_BUF2670 (.I(sio_data_reg_9_1), .Z(sio_data_reg[9]));
  AO222D2HVT U767_C5 (.A1(n1502), .A2(crc_reg[2]), .B1(status_int[18]), 
     .B2(n1166_3), .C1(usercode_reg[18]), .C2(n1501), .Z(n1255));
  AO221D1HVT U693_C4 (.A1(spi_rd_cmdaddr[4]), .A2(n1196_2), .B1(status_int[4]), 
     .B2(n1166_3), .C(U693_N7), .Z(sio_data_reg_int451_4));
  EDFCND1HVT sio_data_reg_int_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_13), 
     .D(sio_data_reg_int451_73), .E(n1224), .Q(sio_data_reg_3_1), .QN());
  AO221D1HVT U691_C4 (.A1(spi_rd_cmdaddr[8]), .A2(n1196_2), .B1(cor_en_oscclk_2), 
     .B2(n1166_3), .C(U691_N7), .Z(sio_data_reg_int451_8));
  OA21D1HVT U744_C2 (.A1(state_1_2), .A2(n1459), .B(n1460), .Z(n1458));
  INVD1HVT U552_C2_MP_INV (.I(n1515), .ZN(n1515_1));
  EDFCND1HVT sio_data_reg_int_reg_27_ (.CDN(rst_b_2), .CP(spi_clk_out_13), 
     .D(sio_data_reg_int451_56), .E(n_1529), .Q(sio_data_reg[27]), .QN(n1156));
  ND2D1HVT U597_C3 (.A1(n1180), .A2(U597_N4), .ZN(sio_data_reg_int451_29));
  AO221D1HVT U677_C4 (.A1(sio_data_reg_63), .A2(n1195), .B1(spi_rd_cmdaddr[18]), 
     .B2(n1196_2), .C(n1255), .Z(sio_data_reg_int451_18));
  OAI21D1HVT U553_C4 (.A1(state_3_), .A2(sr_datacnt_0), .B(U553_N3), .ZN(n1218));
  AOI21D1HVT U581_C2 (.A1(n1235), .A2(n1172), .B(n1198), .ZN(n1170));
  INVD1HVT U673_C3_MP_INV (.I(md_spi), .ZN(md_spi_1));
  INVD1HVT U540_C5_MP_INV (.I(n1198), .ZN(n1198_1));
  INVD1HVT U661_C2_MP_INV (.I(n1199_2), .ZN(n1199_1));
  BUFFD1HVT OPTHOLD_G_931 (.I(spicnt348_4), .Z(spicnt348_12));
  DFSNQD1HVT spi_ss_out_b_int_reg (.CP(spi_clk_out_15), .D(n1240_1), 
     .Q(spi_ss_out_b_int), .SDN(rst_b_3));
  IAO21D1HVT U631_C3 (.A1(spi_rxpreamble_fail), .A2(bitstream_err), 
     .B(cfg_startup), .ZN(U631_N6));
  OR2D1HVT U772_C1 (.A1(smc_usercode_ld), .A2(n1209), .Z(n1245));
  EDFCND1HVT cmdhead_reg_reg_1_ (.CDN(rst_b_3), .CP(spi_clk_out_11), 
     .D(cmdhead_reg_12), .E(n_1944), .Q(cmdhead_reg[1]), .QN(n1457));
  BUFFD1HVT OPTHOLD_G_1004 (.I(sio_data_reg_int451_36), 
     .Z(sio_data_reg_int451_76));
  BUFFD1HVT OPTHOLD_G_1003 (.I(sio_data_reg_int451_37), 
     .Z(sio_data_reg_int451_75));
  AO222D2HVT U765_C5 (.A1(n1502), .A2(crc_reg[4]), .B1(status_int[20]), 
     .B2(n1166_3), .C1(usercode_reg[20]), .C2(n1501), .Z(n1254));
  AOI21D1HVT U551_C2 (.A1(n1516_1), .A2(n1155), .B(n1515), .ZN(n1514));
  BUFFD1HVT OPTHOLD_G_444 (.I(sio_data_reg_int451_95), 
     .Z(sio_data_reg_int451_56));
  BUFFD1HVT OPTHOLD_G_1022 (.I(sio_data_reg_int451_21), 
     .Z(sio_data_reg_int451_90));
  AOI221D1HVT U597_C2 (.A1(n1502), .A2(crc_reg_13_1), .B1(usercode_reg[29]), 
     .B2(n1501), .C(n1214), .ZN(U597_N4));
  AO222D1HVT U761_C5 (.A1(n1512), .A2(n1195), .B1(spi_rd_cmdaddr[28]), 
     .B2(n1196_2), .C1(status_int[28]), .C2(n1166_3), .Z(n1447));
  AOI222D1HVT U601_C5 (.A1(sio_data_reg_65), .A2(n1195), .B1(spi_rd_cmdaddr_35), 
     .B2(n1196_2), .C1(status_int[24]), .C2(n1166_3), .ZN(n1182));
  AOI221D1HVT U606_C2 (.A1(n1502), .A2(crc_reg[15]), .B1(usercode_reg[31]), 
     .B2(n1501), .C(n1214), .ZN(U606_N4));
  INR2D1HVT U639_C1 (.A1(spicnt348_13), .B1(n1175), .ZN(spicnt346_5));
  OR2D1HVT U742_C1 (.A1(sr_datacnt687_8), .A2(n1450), .Z(sr_datacnt685_0));
  INVD1HVT U574_C2_MP_INV (.I(state_2_), .ZN(state_2_1));
  NR2D1HVT U668_C1 (.A1(n1475_2), .A2(n1172_1), .ZN(n1212));
  INVD1HVT U661_C1_MP_INV (.I(n1172), .ZN(n1172_1));
  INVD1HVT U619_C1_MP_INV (.I(state_0_), .ZN(state_0_1));
  ND2D1HVT U619_C1 (.A1(state_2_1), .A2(state_0_1), .ZN(n1197));
  INVD1HVT U727_C2_MP_INV (.I(n1159), .ZN(n1159_1));
  IND2D1HVT U736_C1 (.A1(spicnt348_8), .B1(n1175_1), .ZN(spicnt346_1));
  BUFFD1HVT OPTHOLD_G_940 (.I(cmdhead_cnt833_4), .Z(cmdhead_cnt833_11));
  IND2D1HVT U735_C1 (.A1(spicnt348_10), .B1(n1175_1), .ZN(spicnt346_2));
  ND2D1HVT U632_C1 (.A1(j_sft_dr), .A2(j_cfg_program), .ZN(n1466));
  INR2D1HVT U638_C1 (.A1(spicnt348_9), .B1(n1175), .ZN(spicnt346_6));
  BUFFD1HVT OPTHOLD_G_758 (.I(spicnt_5_), .Z(spicnt_5_2));
  EDFCND1HVT sio_data_reg_int_reg_12_ (.CDN(rst_b_2), .CP(spi_clk_out_8), 
     .D(sio_data_reg_int451_63), .E(n1224), .Q(sio_data_reg_12_1), .QN());
  BUFFD1HVT OPTHOLD_G_442 (.I(sio_data_reg_int451_91), 
     .Z(sio_data_reg_int451_54));
  BUFFD1HVT OPTHOLD_G_441 (.I(sio_data_reg_int451_90), 
     .Z(sio_data_reg_int451_53));
  EDFCND1HVT sr_datacnt_reg_3_ (.CDN(rst_b_3), .CP(spi_clk_out_6), 
     .D(sr_datacnt685_3), .E(n686_0), .Q(sr_datacnt_3_), .QN(n1151));
  AO211D1HVT U739_C3 (.A1(sr_datacnt687_3), .A2(n1176), .B(n1449), .C(n1207), 
     .Z(sr_datacnt685_3));
  AO221D1HVT U686_C4 (.A1(n1166_3), .A2(cor_dis_flashpd_1), 
     .B1(spi_rd_cmdaddr[13]), .B2(n1196_2), .C(U686_N7), 
     .Z(sio_data_reg_int451_13));
  BUFFD2HVT BW1_BUF2668 (.I(sio_data_reg_11_1), .Z(sio_data_reg[11]));
  EDFCND1HVT sio_data_reg_int_reg_14_ (.CDN(rst_b_3), .CP(spi_clk_out_6), 
     .D(sio_data_reg_int451_65), .E(n1224), .Q(sio_data_reg_14_1), .QN());
  BUFFD1HVT OPTHOLD_G_994 (.I(sio_data_reg_int451_34), 
     .Z(sio_data_reg_int451_67));
  AO221D1HVT U684_C4 (.A1(spi_rd_cmdaddr[14]), .A2(n1196_2), .B1(status_int[14]), 
     .B2(n1166_3), .C(U684_N7), .Z(sio_data_reg_int451_14));
  EDFCND1HVT spicnt_reg_0_ (.CDN(rst_b_3), .CP(spi_clk_out_6), .D(spicnt346_9), 
     .E(n347_0), .Q(spicnt_0_), .QN(n1145));
  IND2D1HVT U560_C1 (.A1(n1476), .B1(state_2_1), .ZN(n1160));
  AO22D1HVT U692_C3 (.A1(sio_data_reg[9]), .A2(n1179), .B1(usercode_reg[10]), 
     .B2(n1497), .Z(U692_N7));
  INR2D1HVT U671_C1 (.A1(cor_dis_flashpd), .B1(disable_flash_req_BAR), 
     .ZN(n1216));
  NR2D1HVT U562_C1 (.A1(n1470), .A2(n1158), .ZN(n1161));
  AO221D1HVT U687_C4 (.A1(sio_data_reg[0]), .A2(n1179), .B1(usercode_reg_1_1), 
     .B2(n1497), .C(n1360), .Z(sio_data_reg_int451_1));
  NR2D1HVT U672_C1 (.A1(smc_crc_ld), .A2(n1205), .ZN(n1217));
  MOAI22D1HVT U539_C4 (.A1(n1174_1), .A2(n1164), .B1(n1215), 
     .B2(cor_dis_flashpd_1), .ZN(n1495));
  NR2D3HVT U570_C1 (.A1(n1174), .A2(n1164), .ZN(n1515));
  INVD1HVT BW1_INV_D4441 (.I(n1196), .ZN(n1196_1));
  EDFCND1HVT sio_data_reg_int_reg_21_ (.CDN(rst_b_2), .CP(spi_clk_out_8), 
     .D(sio_data_reg_int451_89), .E(n_1545), .Q(sio_data_reg[21]), .QN());
  BUFFD1HVT OPTHOLD_G_999 (.I(sio_data_reg_int451_38), 
     .Z(sio_data_reg_int451_71));
  AO22D1HVT U694_C3 (.A1(sio_data_reg[11]), .A2(n1179), .B1(usercode_reg[12]), 
     .B2(n1497), .Z(U694_N7));
  EDFCND1HVT sio_data_reg_int_reg_16_ (.CDN(rst_b_2), .CP(spi_clk_out_8), 
     .D(sio_data_reg_int451_79), .E(n_1545), .Q(sio_data_reg[16]), .QN());
  BUFFD1HVT OPTHOLD_G_418 (.I(sio_data_reg_int451_64), 
     .Z(sio_data_reg_int451_41));
  BUFFD1HVT OPTHOLD_G_421 (.I(sio_data_reg_int451_77), 
     .Z(sio_data_reg_int451_44));
  EDFCND1HVT sr_datacnt_reg_2_ (.CDN(rst_b_3), .CP(spi_clk_out_6), 
     .D(sr_datacnt685_2), .E(n686_0), .Q(sr_datacnt_2_), .QN());
  BUFFD1HVT OPTHOLD_G_917 (.I(cmdhead_cnt833_1), .Z(cmdhead_cnt833_8));
  OR4XD1HVT U752_C3 (.A1(n1456), .A2(n1449), .A3(n1208), .A4(n1207), .Z(n1450));
  BUFFD2HVT BW1_BUF2669 (.I(sio_data_reg_10_1), .Z(sio_data_reg[10]));
  BUFFD1HVT OPTHOLD_G_377 (.I(spicnt348_15), .Z(spicnt348_9));
  AOI222D1HVT U605_C5 (.A1(n1502), .A2(crc_reg_5_1), .B1(status_int[21]), 
     .B2(n1166_3), .C1(usercode_reg[21]), .C2(n1501), .ZN(n1185));
  NR2D3HVT U625_C1 (.A1(n1516), .A2(n1515), .ZN(n1249));
  IND2D2HVT U728_C1 (.A1(n1209), .B1(n1195), .ZN(n_1545));
  OAI211D1HVT U609_C4 (.A1(n1195_1), .A2(n1191), .B(n1190), .C(U609_N6), 
     .ZN(sio_data_reg_int451_19));
  AOI222D1HVT U614_C5 (.A1(n1502), .A2(crc_reg_7_1), .B1(status_int[23]), 
     .B2(n1166_3), .C1(usercode_reg[23]), .C2(n1501), .ZN(n1193));
  BUFFD4HVT BW1_BUF4450 (.I(rst_b_2), .Z(rst_b_3));
  BUFFD1HVT OPTHOLD_G_596 (.I(cmdhead_reg_4_1), .Z(cmdhead_reg_4_2));
  BUFFD1HVT OPTHOLD_G_382 (.I(n1213_3), .Z(n1213_1));
  BUFFD1HVT OPTHOLD_G_345 (.I(cmdhead_cnt_2_), .Z(cmdhead_cnt_2_1));
  BUFFD1HVT OPTHOLD_G_389 (.I(n1202_2), .Z(n1202_1));
  EDFCND1HVT cmdhead_cnt_reg_0_ (.CDN(rst_b_3), .CP(spi_clk_out_15), 
     .D(cmdhead_cnt831_0), .E(n832_0), .Q(cmdhead_cnt_0_), .QN());
  BUFFD1HVT OPTHOLD_G_961 (.I(n1240), .Z(n1240_1));
  EDFCND1HVT cmdhead_cnt_reg_2_ (.CDN(rst_b_3), .CP(spi_clk_out_15), 
     .D(cmdhead_cnt831_5), .E(n832_0), .Q(cmdhead_cnt_2_), .QN(n1168));
  BUFFD1HVT OPTHOLD_G_1014 (.I(sio_data_reg_int451_30), 
     .Z(sio_data_reg_int451_82));
  BUFFD1HVT OPTHOLD_G_987 (.I(sio_data_reg_int451_1), .Z(sio_data_reg_int451_60));
  BUFFD1HVT OPTHOLD_G_1011 (.I(sio_data_reg_int451_16), 
     .Z(sio_data_reg_int451_79));
  BUFFD1HVT OPTHOLD_G_946 (.I(spicnt348_7), .Z(spicnt348_14));
  DFCNQD1HVT state_reg_1_ (.CDN(rst_b_3), .CP(spi_clk_out_15), .D(n1211_1), 
     .Q(state_1_));
  AO22D1HVT U693_C3 (.A1(sio_data_reg[3]), .A2(n1179), .B1(usercode_reg[4]), 
     .B2(n1497), .Z(U693_N7));
  EDFCND1HVT cmdhead_reg_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_11), 
     .D(cmdhead_reg_14), .E(n_1944), .Q(cmdhead_reg[2]), .QN(n1486));
  BUFFD1HVT OPTHOLD_G_361 (.I(sr_datacnt687_1), .Z(sr_datacnt687_6));
  ND3D2HVT U543_C2 (.A1(n1504), .A2(n1249), .A3(n1195), .ZN(n_1529));
  INVD4HVT BW1_INV4450 (.I(rst_b_1), .ZN(rst_b_2));
  BUFFD1HVT OPTHOLD_G_1015 (.I(sio_data_reg_int451_51), 
     .Z(sio_data_reg_int451_83));
  AO22D1HVT U720_C3 (.A1(spi_rd_cmdaddr[26]), .A2(n1196_2), .B1(status_int[26]), 
     .B2(n1166_3), .Z(n1513));
  BUFFD1HVT OPTHOLD_G_776 (.I(cmdhead_cnt_0_1), .Z(cmdhead_cnt_0_2));
  BUFFD1HVT OPTHOLD_G_416 (.I(sio_data_reg_int451_72), 
     .Z(sio_data_reg_int451_39));
  BUFFD1HVT OPTHOLD_G_995 (.I(sio_data_reg_int451_8), .Z(sio_data_reg_int451_68));
  EDFCND1HVT cmdhead_reg_reg_7_ (.CDN(rst_b_2), .CP(spi_clk_out_13), 
     .D(cmdreg_code_2_3), .E(n_1944), .Q(cmdhead_reg[7]), .QN());
  BUFFD1HVT OPTHOLD_G_354 (.I(cmdhead_cnt833_8), .Z(cmdhead_cnt833_6));
  BUFFD1HVT OPTHOLD_G_920 (.I(cmdhead_cnt833_2), .Z(cmdhead_cnt833_9));
  EDFCND1HVT sio_data_reg_int_reg_4_ (.CDN(rst_b_2), .CP(spi_clk_out_11), 
     .D(sio_data_reg_int451_75), .E(n1224), .Q(sio_data_reg_4_1), .QN());
  BUFFD1HVT OPTHOLD_G_690 (.I(state_1_), .Z(state_1_2));
  AO21D4HVT U700_C2 (.A1(smc_crc_ld_1), .A2(n1245), .B(n1247), .Z(n1224));
  OR2D1HVT U577_C1 (.A1(smc_status_ld), .A2(n1196_2), .Z(n1247));
  BUFFD2HVT BW1_BUF2672 (.I(sio_data_reg_7_1), .Z(sio_data_reg[7]));
  OR2D1HVT U750_C1 (.A1(n1485), .A2(n1484), .Z(n1491));
  BUFFD2HVT BW1_BUF2675 (.I(sio_data_reg_4_1), .Z(sio_data_reg[4]));
  AO221D1HVT U695_C4 (.A1(spi_rd_cmdaddr[5]), .A2(n1196_2), .B1(status_int[5]), 
     .B2(n1166_3), .C(U695_N7), .Z(sio_data_reg_int451_5));
  EDFCND1HVT sio_data_reg_int_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_11), 
     .D(sio_data_reg_int451_61), .E(n1224), .Q(sio_data_reg_6_1), .QN());
  ND2D1HVT U592_C2 (.A1(usercode_reg[9]), .A2(n1497), .ZN(U592_N6));
  ND2D1HVT U600_C3 (.A1(n1182), .A2(U600_N4), .ZN(sio_data_reg_int451_24));
  OAI21D1HVT U552_C2 (.A1(n1516), .A2(n1156), .B(n1515_1), .ZN(n1512));
  NR3D1HVT U566_C3 (.A1(state_1_2), .A2(n1453), .A3(n1158), .ZN(U566_N6));
  AOI222D1HVT U598_C5 (.A1(sio_data_reg_56), .A2(n1195), .B1(spi_rd_cmdaddr[29]), 
     .B2(n1196_2), .C1(status_int[29]), .C2(n1166_3), .ZN(n1180));
  BUFFD1HVT OPTHOLD_G_347 (.I(spicnt_2_), .Z(spicnt_2_1));
  INVD1HVT U579_C4_MP_INV (.I(n1170), .ZN(n1170_1));
  BUFFD4HVT BW1_BUF4113 (.I(n1166), .Z(n1166_3));
  BUFFD1HVT OPTHOLD_G_719 (.I(n1244), .Z(n1244_1));
  EDFCND1HVT sio_data_reg_int_reg_9_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_int451_78), .E(n1224), .Q(sio_data_reg_9_1), .QN());
  NR2D1HVT U621_C1 (.A1(n1235), .A2(n1172), .ZN(n1198));
  BUFFD1HVT OPTHOLD_G_7 (.I(sio_data_reg_0_1), .Z(sio_data_reg_0_2));
  ND2D1HVT U726_C1 (.A1(n1199_1), .A2(n1173_1), .ZN(n1235));
  EDFCND1HVT cmdhead_reg_reg_0_ (.CDN(rst_b_3), .CP(spi_clk_out_11), .D(sdi_2), 
     .E(n_1944), .Q(cmdhead_reg[0]), .QN(n1485));
  BUFFD1HVT OPTHOLD_G_446 (.I(sio_data_reg_int451_96), 
     .Z(sio_data_reg_int451_58));
  BUFFD1HVT OPTHOLD_G_687 (.I(n1475), .Z(n1475_3));
  spi_smc_DW01_dec_5_0 sub_355 (.A({cmdhead_cnt_4_, cmdhead_cnt_3_, 
     cmdhead_cnt_2_, cmdhead_cnt_1_, cmdhead_cnt_0_}), .SUM({cmdhead_cnt833_4, 
     cmdhead_cnt833_3, cmdhead_cnt833_2, cmdhead_cnt833_1, cmdhead_cnt833_0}), 
     .cmdhead_cnt_3_1(cmdhead_cnt_3_1), .cmdhead_cnt_0_2(cmdhead_cnt_0_2), 
     .cmdhead_cnt_2_1(cmdhead_cnt_2_1), .cmdhead_cnt_4_1(cmdhead_cnt_4_1), 
     .cmdhead_cnt_1_1(cmdhead_cnt_1_1));
  AOI222D1HVT U627_C5 (.A1(sio_data_reg_59), .A2(n1195), .B1(spi_rd_cmdaddr_36), 
     .B2(n1196_2), .C1(status_int[27]), .C2(n1166_3), .ZN(n1200));
  INVD1HVT U758_C2_MP_INV_1 (.I(state_1_), .ZN(state_1_1));
  BUFFD1HVT OPTHOLD_G_1020 (.I(sio_data_reg_int451_23), 
     .Z(sio_data_reg_int451_88));
  BUFFD1HVT OPTHOLD_G_438 (.I(sio_data_reg_int451_84), 
     .Z(sio_data_reg_int451_50));
  BUFFD1HVT OPTHOLD_G_1018 (.I(sio_data_reg_int451_28), 
     .Z(sio_data_reg_int451_86));
  BUFFD1HVT OPTHOLD_G_414 (.I(sio_data_reg_int451_4), .Z(sio_data_reg_int451_37));
  ND2D1HVT U626_C3 (.A1(n1200), .A2(U626_N4), .ZN(sio_data_reg_int451_27));
  EDFCND1HVT sio_data_reg_int_reg_31_ (.CDN(rst_b_2), .CP(spi_clk_out_14), 
     .D(sio_data_reg_int451_97), .E(n_1529), .Q(sio_data_reg[31]), .QN());
  INR2D1HVT U640_C1 (.A1(spicnt348_11), .B1(n1175), .ZN(spicnt346_3));
  IND2D1HVT U748_C1 (.A1(n1460), .B1(state_0_), .ZN(n1476));
  BUFFD1HVT OPTHOLD_G_650 (.I(n1475_1), .Z(n1475_2));
  NR2D1HVT U666_C1 (.A1(n1475_2), .A2(n1173_1), .ZN(n1210));
  AOI211D1HVT U538_C3 (.A1(n1197), .A2(n1158), .B(tx_spicmd_read_req_1), 
     .C(n1470), .ZN(n1215));
  NR2D1HVT U661_C2 (.A1(n1199_1), .A2(U661_N3), .ZN(n1204));
  BUFFD1HVT OPTHOLD_G_777 (.I(spicnt_1_), .Z(spicnt_1_1));
  AO21D1HVT U737_C2 (.A1(spicnt348_0), .A2(n1175_1), .B(n1203), .Z(spicnt346_0));
  EDFCND1HVT spicnt_reg_6_ (.CDN(rst_b_3), .CP(spi_clk_out_6), .D(spicnt346_6), 
     .E(n347_0), .Q(spicnt_6_), .QN(n1142));
  OR2D1HVT U588_C1 (.A1(n1204), .A2(n1203), .Z(n1175));
  INVD1HVT U733_C2_MP_INV (.I(n1175), .ZN(n1175_1));
  EDFCND1HVT spicnt_reg_5_ (.CDN(rst_b_3), .CP(spi_clk_out_6), .D(spicnt346_5), 
     .E(n347_0), .Q(spicnt_5_), .QN(n1146));
  BUFFD1HVT OPTHOLD_G_939 (.I(spicnt348_5), .Z(spicnt348_13));
  BUFFD1HVT OPTHOLD_G_1012 (.I(sio_data_reg_int451_20), 
     .Z(sio_data_reg_int451_80));
  BUFFD1HVT OPTHOLD_G_411 (.I(sio_data_reg_int451_15), 
     .Z(sio_data_reg_int451_34));
  BUFFD1HVT OPTHOLD_G_1023 (.I(sio_data_reg_int451_19), 
     .Z(sio_data_reg_int451_91));
  EDFCND1HVT sr_datacnt_reg_4_ (.CDN(rst_b_3), .CP(spi_clk_out_6), 
     .D(sr_datacnt685_4), .E(n686_0), .Q(sr_datacnt_4_), .QN(n1153));
  BUFFD1HVT OPTHOLD_G_615 (.I(sr_datacnt_5_), .Z(sr_datacnt_5_1));
  EDFCND1HVT sio_data_reg_int_reg_13_ (.CDN(rst_b_3), .CP(spi_clk_out_6), 
     .D(sio_data_reg_int451_44), .E(n1224), .Q(sio_data_reg_13_1), .QN());
  EDFCND1HVT sr_datacnt_reg_1_ (.CDN(rst_b_3), .CP(spi_clk_out_6), 
     .D(sr_datacnt685_1), .E(n686_0), .Q(sr_datacnt_1_), .QN(n1152));
  BUFFD1HVT OPTHOLD_G_916 (.I(spicnt348_2), .Z(spicnt348_10));
  BUFFD1HVT OPTHOLD_G_770 (.I(sr_datacnt_3_), .Z(sr_datacnt_3_2));
  BUFFD1HVT OPTHOLD_G_921 (.I(sr_datacnt687_2), .Z(sr_datacnt687_9));
  EDFCND1HVT spicnt_reg_1_ (.CDN(rst_b_3), .CP(spi_clk_out_6), .D(spicnt346_1), 
     .E(n347_0), .Q(spicnt_1_), .QN(n1144));
  AO211D1HVT U661_C1 (.A1(n1173), .A2(n1160), .B(n1172_1), .C(n1165), 
     .Z(U661_N3));
  AO21D1HVT U757_C2 (.A1(n1216), .A2(n1161), .B(n1483), .Z(U757_N5));
  INVD1HVT U758_C2_MP_INV (.I(n1161), .ZN(n1161_1));
  NR2D1HVT U664_C1 (.A1(n1491), .A2(n1490), .ZN(n1208));
  IND3D1HVT U751_C2 (.A1(n1456), .B1(n1206), .B2(n1217), .ZN(U751_N5));
  OA32D1HVT U636_C4 (.A1(tx_spicmd_read_req), .A2(n1161_1), 
     .A3(disable_flash_req_BAR), .B1(n1243_1), .B2(n1162), .Z(n1238));
  INR2XD1HVT U573_C1 (.A1(n1165), .B1(n1174), .ZN(n1516));
  BUFFD1HVT OPTHOLD_G_435 (.I(sio_data_reg_int451_18), 
     .Z(sio_data_reg_int451_47));
  NR2D1HVT U663_C1 (.A1(n1456), .A2(n1217), .ZN(n1207));
  AO221D1HVT U674_C4 (.A1(sio_data_reg_66), .A2(n1195), .B1(spi_rd_cmdaddr[22]), 
     .B2(n1196_2), .C(n1253), .Z(sio_data_reg_int451_22));
  AO221D1HVT U676_C4 (.A1(sio_data_reg_111), .A2(n1195), .B1(spi_rd_cmdaddr[16]), 
     .B2(n1196_2), .C(n1336), .Z(sio_data_reg_int451_16));
  AO22D1HVT U686_C3 (.A1(sio_data_reg[12]), .A2(n1179), .B1(usercode_reg[13]), 
     .B2(n1497), .Z(U686_N7));
  EDFCND1HVT sio_data_reg_int_reg_23_ (.CDN(rst_b_2), .CP(spi_clk_out_8), 
     .D(sio_data_reg_int451_55), .E(n_1545), .Q(sio_data_reg[23]), .QN());
  EDFCND1HVT sr_datacnt_reg_0_ (.CDN(rst_b_3), .CP(spi_clk_out_6), 
     .D(sr_datacnt685_0), .E(n686_0), .Q(sr_datacnt_0_), .QN());
  BUFFD1HVT OPTHOLD_G_348 (.I(spicnt_7_), .Z(spicnt_7_1));
  NR4D1HVT U673_C3 (.A1(state_1_2), .A2(n1459), .A3(n1158), .A4(md_spi_1), 
     .ZN(n1219));
  EDFCND1HVT sr_datacnt_reg_5_ (.CDN(rst_b_3), .CP(spi_clk_out_6), 
     .D(sr_datacnt685_5), .E(n686_0), .Q(sr_datacnt_5_), .QN());
  ND2D1HVT U585_C1 (.A1(n1175_1), .A2(n1174_1), .ZN(n347_0));
  BUFFD1HVT OPTHOLD_G_992 (.I(sio_data_reg_int451_41), 
     .Z(sio_data_reg_int451_65));
  AO22D1HVT U689_C3 (.A1(sdi), .A2(n1179), .B1(usercode_reg[0]), .B2(n1497), 
     .Z(U689_N7));
  AO222D2HVT U769_C5 (.A1(n1502), .A2(crc_reg_0_1), .B1(status_int[16]), 
     .B2(n1166_3), .C1(usercode_reg_16_1), .C2(n1501), .Z(n1336));
  BUFFD3HVT BW1_BUF2674 (.I(sio_data_reg_5_1), .Z(sio_data_reg[5]));
  ND2D1HVT U609_C2 (.A1(spi_rd_cmdaddr[19]), .A2(n1196_2), .ZN(U609_N6));
  NR2D1HVT U670_C1 (.A1(n1249), .A2(n1195_1), .ZN(n1214));
  AO22D1HVT U696_C3 (.A1(sio_data_reg_136), .A2(n1179), .B1(usercode_reg_6_1), 
     .B2(n1497), .Z(U696_N7));
  INR2XD1HVT U537_C2 (.A1(bs_smc_cmdhead_en), .B1(n1465), .ZN(n_1943));
  EDFCND1HVT cmdhead_cnt_reg_4_ (.CDN(rst_b_3), .CP(spi_clk_out_15), 
     .D(cmdhead_cnt831_4), .E(n832_0), .Q(cmdhead_cnt_4_), .QN());
  OR2D1HVT U730_C1 (.A1(cmdhead_cnt_ld), .A2(cmdhead_cnt833_9), 
     .Z(cmdhead_cnt831_2));
  BUFFD1HVT OPTHOLD_G_965 (.I(n1202), .Z(n1202_2));
  BUFFD1HVT OPTHOLD_G_774 (.I(cmdhead_cnt_1_), .Z(cmdhead_cnt_1_1));
  BUFFD1HVT OPTHOLD_G_927 (.I(cmdhead_cnt833_3), .Z(cmdhead_cnt833_10));
  OR2D1HVT U729_C1 (.A1(cmdhead_cnt_ld), .A2(cmdhead_cnt_0_BAR), .Z(n832_0));
  BUFFD1HVT OPTHOLD_G_383 (.I(n1211_2), .Z(n1211_1));
  BUFFD1HVT OPTHOLD_G_439 (.I(sio_data_reg_int451_82), 
     .Z(sio_data_reg_int451_51));
  BUFFD1HVT OPTHOLD_G_926 (.I(sr_datacnt687_6), .Z(sr_datacnt687_10));
  BUFFD1HVT OPTHOLD_G_413 (.I(sio_data_reg_int451_5), .Z(sio_data_reg_int451_36));
  BUFFD1HVT OPTHOLD_G_356 (.I(spicnt_6_), .Z(spicnt_6_1));
  AOI22D1HVT U594_C3 (.A1(spi_rd_cmdaddr[9]), .A2(n1196_2), .B1(status_int[9]), 
     .B2(n1166_3), .ZN(n1178));
  EDFCND1HVT sio_data_reg_int_reg_5_ (.CDN(rst_b_2), .CP(spi_clk_out_11), 
     .D(sio_data_reg_int451_76), .E(n1224), .Q(sio_data_reg_5_1), .QN());
  BUFFD1HVT OPTHOLD_G_949 (.I(spicnt348_6), .Z(spicnt348_15));
  NR2XD2HVT U595_C1 (.A1(smc_usercode_ld), .A2(n1247), .ZN(n1179));
  INVD1HVT BW1_INV_D4450 (.I(rst_b), .ZN(rst_b_1));
  BUFFD1HVT OPTHOLD_G_2 (.I(cmdreg_code_1_4), .Z(cmdreg_code_1_3));
  AO31D1HVT U762_C3 (.A1(sio_data_reg[25]), .A2(n1249), .A3(n1195), .B(n1513), 
     .Z(n1451));
  AO221D1HVT U705_C4 (.A1(n1502), .A2(crc_reg_9_1), .B1(usercode_reg_25_1), 
     .B2(n1501), .C(n1448), .Z(sio_data_reg_int451_25));
  BUFFD1HVT OPTHOLD_G_998 (.I(sio_data_reg_int451_2), .Z(sio_data_reg_int451_70));
  BUFFD1HVT OPTHOLD_G_336 (.I(cmdhead_cnt833_0), .Z(cmdhead_cnt833_5));
  IND2D1HVT U653_C2 (.A1(n1465), .B1(bs_smc_sdio_en), .ZN(n1504));
  BUFFD8HVT BL1_R_BUF_7 (.I(cmdreg_code_1_3), .Z(cmdhead_reg[5]));
  BUFFD1HVT OPTHOLD_G_971 (.I(spicnt346_7), .Z(spicnt346_8));
  EDFCND1HVT sio_data_reg_int_reg_7_ (.CDN(rst_b_3), .CP(spi_clk_out_11), 
     .D(sio_data_reg_int451_66), .E(n1224), .Q(sio_data_reg_7_1), .QN());
  EDFCND1HVT sio_data_reg_int_reg_8_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_int451_35), .E(n1224), .Q(sio_data_reg_8_1), .QN(n1220));
  INVD1HVT U766_C4_MP_INV (.I(n1166), .ZN(n1166_1));
  AO221D1HVT U690_C4 (.A1(spi_rd_cmdaddr[7]), .A2(n1196_2), .B1(status_int[7]), 
     .B2(n1166_3), .C(U690_N7), .Z(sio_data_reg_int451_7));
  BUFFD2HVT BW1_BUF2671 (.I(sio_data_reg_8_1), .Z(sio_data_reg[8]));
  NR3D1HVT U662_C2 (.A1(n1484), .A2(n1457), .A3(cmdhead_reg[0]), .ZN(n1205));
  INVD1HVT U665_C1_MP_INV (.I(n1249), .ZN(n1249_1));
  NR2D1HVT U665_C1 (.A1(n1504), .A2(n1249_1), .ZN(n1209));
  AO221D1HVT U685_C4 (.A1(spi_rd_cmdaddr[2]), .A2(n1196_2), .B1(status_int[2]), 
     .B2(n1166_3), .C(U685_N7), .Z(sio_data_reg_int451_2));
  OR2D1HVT U745_C1 (.A1(state_3_), .A2(state_1_), .Z(n1470));
  BUFFD3HVT BW2_BUF2769 (.I(n1213), .Z(n1213_3));
  AOI221D1HVT U600_C2 (.A1(n1502), .A2(crc_reg_8_1), .B1(usercode_reg[24]), 
     .B2(n1501), .C(n1214), .ZN(U600_N4));
  AO31D1HVT U760_C3 (.A1(sio_data_reg_115), .A2(n1249), .A3(n1195), .B(n1511), 
     .Z(n1452));
  AO22D1HVT U721_C3 (.A1(spi_rd_cmdaddr[30]), .A2(n1196_2), .B1(status_int[30]), 
     .B2(n1166_3), .Z(n1511));
  BUFFD1HVT OPTHOLD_G_371 (.I(cmdhead_cnt833_11), .Z(cmdhead_cnt833_7));
  IND3D1HVT U553_C1 (.A1(n1453), .B1(state_3_), .B2(md_spi), .ZN(U553_N3));
  BUFFD1HVT OPTHOLD_G_166 (.I(sr_datacnt_4_), .Z(sr_datacnt_4_1));
  DFCND1HVT state_reg_3_ (.CDN(rst_b_3), .CP(spi_clk_out_15), .D(n1213_2), 
     .Q(state_3_), .QN(n1459));
  OA31D1HVT U649_C3 (.A1(n1459), .A2(n1237), .A3(md_spi_1), .B(n1238), .Z(n1244));
  AO31D1HVT U623_C3 (.A1(state_1_2), .A2(n1218), .A3(n1197_1), .B(n1496), 
     .Z(n1199));
  MUX2D1HVT U579_C4 (.I0(n1170_1), .I1(spi_ss_out_b_int_1), .S(n1169), .Z(n1240));
  AO21D1HVT U631_C4 (.A1(cfg_startup), .A2(cdone_in), .B(U631_N6), .Z(n1453));
  BUFFD1HVT OPTHOLD_G_172 (.I(spicnt_0_), .Z(spicnt_0_1));
  spi_smc_DW01_dec_6_0 sub_337 (.A({sr_datacnt_5_, sr_datacnt_4_, sr_datacnt_3_, 
     sr_datacnt_2_, sr_datacnt_1_, sr_datacnt_0_}), .SUM({sr_datacnt687_5, 
     sr_datacnt687_4, sr_datacnt687_3, sr_datacnt687_2, sr_datacnt687_1, 
     sr_datacnt687_0}), .sr_datacnt_5_1(sr_datacnt_5_1), 
     .sr_datacnt_4_1(sr_datacnt_4_1), .sr_datacnt_2_2(sr_datacnt_2_2), 
     .sr_datacnt_3_2(sr_datacnt_3_2), .sr_datacnt_1_1(sr_datacnt_1_1), 
     .sr_datacnt_0_1(sr_datacnt_0_1));
  AN4D1HVT U546_C3 (.A1(n1154), .A2(n1150), .A3(cmdhead_reg[2]), 
     .A4(cmd_sr_datacnt_ld), .Z(n1206));
  EDFCND1HVT cmdhead_cnt_reg_1_ (.CDN(rst_b_3), .CP(spi_clk_out_15), 
     .D(cmdhead_cnt831_1), .E(n832_0), .Q(cmdhead_cnt_1_), .QN());
  BUFFD1HVT OPTHOLD_G_606 (.I(n_1943), .Z(n_1944));
  EDFCND1HVT sio_data_reg_int_reg_24_ (.CDN(rst_b_2), .CP(spi_clk_out_13), 
     .D(sio_data_reg_int451_58), .E(n_1529), .Q(sio_data_reg[24]), .QN(n1155));
  AOI222D1HVT U611_C5 (.A1(n1502), .A2(crc_reg_3_1), .B1(cfg_ld_bstream_1), 
     .B2(n1166_3), .C1(usercode_reg[19]), .C2(n1501), .ZN(n1190));
  BUFFD1HVT OPTHOLD_G_440 (.I(sio_data_reg_int451_86), 
     .Z(sio_data_reg_int451_52));
  BUFFD1HVT OPTHOLD_G_447 (.I(sio_data_reg_int451_93), 
     .Z(sio_data_reg_int451_59));
  AO221D1HVT U703_C4 (.A1(n1502), .A2(crc_reg_12_2), .B1(usercode_reg[28]), 
     .B2(n1501), .C(n1447), .Z(sio_data_reg_int451_28));
  EDFCND1HVT sio_data_reg_int_reg_28_ (.CDN(rst_b_2), .CP(spi_clk_out_11), 
     .D(sio_data_reg_int451_87), .E(n_1529), .Q(sio_data_reg[28]), .QN());
  EDFCND1HVT sio_data_reg_int_reg_30_ (.CDN(rst_b_2), .CP(spi_clk_out_8), 
     .D(sio_data_reg_int451_83), .E(n_1529), .Q(sio_data_reg[30]), .QN());
  ND2D1HVT U606_C3 (.A1(n1187), .A2(U606_N4), .ZN(sio_data_reg_int451_31));
  BUFFD1HVT OPTHOLD_G_410 (.I(sio_data_reg_int451_12), 
     .Z(sio_data_reg_int451_33));
  BUFFD1HVT OPTHOLD_G_170 (.I(sr_datacnt_0_), .Z(sr_datacnt_0_1));
  NR3D1HVT U574_C2 (.A1(state_2_1), .A2(state_0_), .A3(n1460), .ZN(n1165));
  ND2D1HVT U555_C1 (.A1(state_2_1), .A2(state_0_), .ZN(n1158));
  DFCNQD1HVT state_reg_0_ (.CDN(rst_b_3), .CP(spi_clk_out_15), .D(n1210), 
     .Q(state_0_));
  OR3XD1HVT U564_C2 (.A1(state_2_1), .A2(state_0_), .A3(n1470), .Z(n1162));
  ND2D1HVT U569_C1 (.A1(state_1_2), .A2(n1459), .ZN(n1460));
  AN4D1HVT U590_C3 (.A1(n1476), .A2(n1173), .A3(n1172), .A4(n1164), .Z(n1203));
  BUFFD1HVT OPTHOLD_G_966 (.I(n1202_1), .Z(n1202_3));
  AO21D1HVT U734_C2 (.A1(spicnt348_12), .A2(n1175_1), .B(n1204), .Z(spicnt346_4));
  OR2D1HVT U586_C1 (.A1(n1480), .A2(n1479), .Z(n1174));
  EDFCND1HVT spicnt_reg_7_ (.CDN(rst_b_3), .CP(spi_clk_out_6), .D(spicnt346_8), 
     .E(n347_0), .Q(spicnt_7_), .QN(n1143));
  ND4D1HVT U545_C3 (.A1(n1149), .A2(n1148), .A3(n1147), .A4(n1146), .ZN(n1479));
  BUFFD1HVT OPTHOLD_G_1005 (.I(sio_data_reg_int451_13), 
     .Z(sio_data_reg_int451_77));
  BUFFD1HVT OPTHOLD_G_1027 (.I(sio_data_reg_int451_27), 
     .Z(sio_data_reg_int451_95));
  ND2D1HVT U612_C2 (.A1(spi_rd_cmdaddr[23]), .A2(n1196_2), .ZN(U612_N6));
  BUFFD1HVT OPTHOLD_G_443 (.I(sio_data_reg_int451_88), 
     .Z(sio_data_reg_int451_55));
  NR4D8HVT U746_C3 (.A1(sr_datacnt_5_1), .A2(sr_datacnt_2_), .A3(sr_datacnt_0_), 
     .A4(n1474), .ZN(sr_datacnt_0));
  EDFCND1HVT sio_data_reg_int_reg_11_ (.CDN(rst_b_3), .CP(spi_clk_out_6), 
     .D(sio_data_reg_int451_69), .E(n1224), .Q(sio_data_reg_11_1), .QN());
  CKAN2D1HVT U641_C1 (.A1(sr_datacnt687_7), .A2(n1176), .Z(sr_datacnt685_5));
  BUFFD2HVT BW1_BUF2666 (.I(sio_data_reg_13_1), .Z(sio_data_reg[13]));
  ND3D1HVT U548_C2 (.A1(n1153), .A2(n1152), .A3(n1151), .ZN(n1474));
  BUFFD1HVT OPTHOLD_G_773 (.I(sr_datacnt_2_), .Z(sr_datacnt_2_2));
  BUFFD1HVT OPTHOLD_G_929 (.I(spicnt348_3), .Z(spicnt348_11));
  BUFFD1HVT OPTHOLD_G_972 (.I(spicnt346_0), .Z(spicnt346_9));
  AO211D1HVT U727_C2 (.A1(n1174), .A2(U743_N3), .B(n1506), .C(n1159_1), 
     .Z(U727_N5));
  EDFCND1HVT sio_data_reg_int_reg_1_ (.CDN(rst_b_3), .CP(spi_clk_out_12), 
     .D(sio_data_reg_int451_60), .E(n1224), .Q(sio_data_reg_1_1), .QN());
  INVD1HVT U557_C4_MP_INV_1 (.I(sr_datacnt_0), .ZN(n1243_1));
  OAI32D1HVT U758_C2 (.A1(tx_spicmd_read_req), .A2(n1216), .A3(n1161_1), 
     .B1(state_1_1), .B2(n1158), .ZN(U758_N5));
  MOAI22D1HVT U766_C4 (.A1(n1166_1), .A2(md_spi_1), .B1(spi_rd_cmdaddr[1]), 
     .B2(n1196_2), .ZN(n1360));
  INR3D1HVT U591_C3 (.A1(n1491), .B1(n1206), .B2(n1490), .ZN(n1176));
  AO22D1HVT U691_C3 (.A1(sio_data_reg[7]), .A2(n1179), .B1(usercode_reg[8]), 
     .B2(n1497), .Z(U691_N7));
  ND2D1HVT U751_C3 (.A1(n1179), .A2(U751_N5), .ZN(n1449));
  INVD4HVT BW1_INV4441 (.I(n1196_1), .ZN(n1196_2));
  EDFCND1HVT sio_data_reg_int_reg_15_ (.CDN(rst_b_2), .CP(spi_clk_out_8), 
     .D(sio_data_reg_int451_67), .E(n1224), .Q(sio_data_reg[15]), .QN());
  OAI211D1HVT U612_C4 (.A1(n1195_1), .A2(n1194), .B(n1193), .C(U612_N6), 
     .ZN(sio_data_reg_int451_23));
  AO221D1HVT U694_C4 (.A1(spi_rd_cmdaddr[12]), .A2(n1196_2), 
     .B1(cor_en_8bconfig_1), .B2(n1166_3), .C(U694_N7), 
     .Z(sio_data_reg_int451_12));
  EDFCND1HVT sio_data_reg_int_reg_20_ (.CDN(rst_b_2), .CP(spi_clk_out_8), 
     .D(sio_data_reg_int451_45), .E(n_1545), .Q(sio_data_reg[20]), .QN(n1186));
  BUFFD1HVT OPTHOLD_G_417 (.I(sio_data_reg_int451_11), 
     .Z(sio_data_reg_int451_40));
  BUFFD1HVT OPTHOLD_G_991 (.I(sio_data_reg_int451_14), 
     .Z(sio_data_reg_int451_64));
  EDFCND1HVT spicnt_reg_2_ (.CDN(rst_b_3), .CP(spi_clk_out_6), .D(spicnt346_2), 
     .E(n347_0), .Q(spicnt_2_), .QN(n1148));
  MUX2ND1HVT U630_C4 (.I0(n1162), .I1(n1160), .S(sr_datacnt_0), .ZN(n1506));
  AO211D1HVT U738_C3 (.A1(sr_datacnt687_11), .A2(n1176), .B(n1449), .C(n1208), 
     .Z(sr_datacnt685_4));
  ND2D1HVT U541_C1 (.A1(sr_datacnt_0), .A2(n1176), .ZN(n686_0));
  INVD1HVT U557_C4_MP_INV (.I(n1174), .ZN(n1174_1));
  INVD1HVT U749_C2_MP_INV (.I(n1195), .ZN(n1195_1));
  BUFFD1HVT OPTHOLD_G_988 (.I(sio_data_reg_int451_6), .Z(sio_data_reg_int451_61));
  AO22D1HVT U695_C3 (.A1(sio_data_reg[4]), .A2(n1179), .B1(usercode_reg[5]), 
     .B2(n1497), .Z(U695_N7));
  AO22D1HVT U690_C3 (.A1(sio_data_reg[6]), .A2(n1179), .B1(usercode_reg[7]), 
     .B2(n1497), .Z(U690_N7));
  EDFCND1HVT sio_data_reg_int_reg_18_ (.CDN(rst_b_2), .CP(spi_clk_out_11), 
     .D(sio_data_reg_int451_47), .E(n_1545), .Q(sio_data_reg[18]), .QN(n1191));
  EDFCND1HVT cmdhead_reg_reg_5_ (.CDN(rst_b_2), .CP(spi_clk_out_13), 
     .D(cmdreg_code_0_2), .E(n_1944), .Q(cmdreg_code_1_4), .QN());
  BUFFD1HVT OPTHOLD_G_419 (.I(sio_data_reg_int451_9), .Z(sio_data_reg_int451_42));
  AO221D1HVT U689_C4 (.A1(n1166_3), .A2(md_jtag), .B1(spi_rd_cmdaddr[0]), 
     .B2(n1196_2), .C(U689_N7), .Z(sio_data_reg_int451_0));
  BUFFD1HVT OPTHOLD_G_167 (.I(cmdhead_cnt_3_), .Z(cmdhead_cnt_3_1));
  BUFFD1HVT OPTHOLD_G_409 (.I(sio_data_reg_int451_7), .Z(sio_data_reg_int451_32));
  NR4D1HVT U755_C3_INV (.A1(n1505), .A2(cmdhead_cnt_4_), .A3(cmdhead_cnt_1_), 
     .A4(cmdhead_cnt_0_), .ZN(cmdhead_cnt_1));
  INR2D1HVT U646_C1 (.A1(cmdhead_cnt833_10), .B1(cmdhead_cnt_ld), 
     .ZN(cmdhead_cnt831_3));
  INVD8HVT BL1_R_INV_14 (.I(cmdhead_cnt_1), .ZN(cmdhead_cnt_0_BAR));
  BUFFD1HVT OPTHOLD_G_1029 (.I(sio_data_reg_int451_57), 
     .Z(sio_data_reg_int451_97));
  OR2D1HVT U741_C1 (.A1(sr_datacnt687_10), .A2(n1450), .Z(sr_datacnt685_1));
  BUFFD1HVT OPTHOLD_G_871 (.I(sr_datacnt687_0), .Z(sr_datacnt687_8));
  BUFFD1HVT OPTHOLD_G_775 (.I(sr_datacnt_1_), .Z(sr_datacnt_1_1));
  NR2D4HVT U615_C1 (.A1(smc_crc_ld), .A2(n1179_1), .ZN(n1195));
  BUFFD1HVT OPTHOLD_G_23 (.I(n1475_3), .Z(n1475_1));
  BUFFD1HVT OPTHOLD_G_412 (.I(sio_data_reg_int451_68), 
     .Z(sio_data_reg_int451_35));
  AO22D1HVT U685_C3 (.A1(sio_data_reg[1]), .A2(n1179), .B1(usercode_reg[2]), 
     .B2(n1497), .Z(U685_N7));
  OAI211D1HVT U592_C4 (.A1(n1220), .A2(n1179_1), .B(n1178), .C(U592_N6), 
     .ZN(sio_data_reg_int451_9));
  BUFFD1HVT OPTHOLD_G_445 (.I(sio_data_reg_int451_31), 
     .Z(sio_data_reg_int451_57));
  BUFFD1HVT OPTHOLD_G_1019 (.I(sio_data_reg_int451_52), 
     .Z(sio_data_reg_int451_87));
  BUFFD1HVT OPTHOLD_G_1024 (.I(sio_data_reg_int451_54), 
     .Z(sio_data_reg_int451_92));
  INR2D1HVT U645_C1 (.A1(cmdhead_cnt833_7), .B1(cmdhead_cnt_ld), 
     .ZN(cmdhead_cnt831_4));
  BUFFD1HVT OPTHOLD_G_1000 (.I(sio_data_reg_int451_3), 
     .Z(sio_data_reg_int451_72));
  EDFCND1HVT sio_data_reg_int_reg_25_ (.CDN(rst_b_2), .CP(spi_clk_out_13), 
     .D(sio_data_reg_int451_48), .E(n_1529), .Q(sio_data_reg[25]), .QN());
  EDFCND1HVT cmdhead_reg_reg_4_ (.CDN(rst_b_2), .CP(spi_clk_out_11), 
     .D(cmdhead_reg_16), .E(n_1944), .Q(cmdhead_reg_4_1), .QN());
  BUFFD1HVT OPTHOLD_G_930 (.I(sr_datacnt687_4), .Z(sr_datacnt687_11));
  BUFFD1HVT OPTHOLD_G_797 (.I(n1199), .Z(n1199_2));
  AO222D1HVT U768_C5 (.A1(n1166_3), .A2(cdone_in), .B1(n1502), .B2(crc_reg[1]), 
     .C1(usercode_reg[17]), .C2(n1501), .Z(n1256));
  AO221D1HVT U696_C4 (.A1(spi_rd_cmdaddr[6]), .A2(n1196_2), .B1(n3085_2), 
     .B2(n1166_3), .C(U696_N7), .Z(sio_data_reg_int451_6));
  INR2XD2HVT U629_C2 (.A1(smc_usercode_ld), .B1(n1247), .ZN(n1497));
  BUFFD2HVT BW1_BUF2676 (.I(sio_data_reg_3_1), .Z(sio_data_reg[3]));
  OAI31D2HVT U549_C3 (.A1(n1485), .A2(n1484), .A3(cmdhead_reg[1]), .B(n1249), 
     .ZN(n1456));
  EDFCND1HVT sio_data_reg_int_reg_2_ (.CDN(rst_b_3), .CP(spi_clk_out_11), 
     .D(sio_data_reg_int451_71), .E(n1224), .Q(sio_data_reg_2_1), .QN());
  INVD1HVT U538_C3_MP_INV (.I(tx_spicmd_read_req), .ZN(tx_spicmd_read_req_1));
  AO221D1HVT U683_C4 (.A1(spi_rd_cmdaddr[3]), .A2(n1196_2), .B1(status_int[3]), 
     .B2(n1166_3), .C(U683_N7), .Z(sio_data_reg_int451_3));
  BUFFD1HVT OPTHOLD_G_989 (.I(sio_data_reg_int451_0), .Z(sio_data_reg_int451_62));
  NR2D1HVT U669_C1 (.A1(n1475_2), .A2(n1244_1), .ZN(n1213));
  INVD1HVT U551_C2_MP_INV (.I(n1516), .ZN(n1516_1));
  AOI221D1HVT U626_C2 (.A1(n1502), .A2(crc_reg_11_1), .B1(usercode_reg[27]), 
     .B2(n1501), .C(n1214), .ZN(U626_N4));
  BUFFD1HVT OPTHOLD_G_985 (.I(cmdhead_cnt831_3), .Z(cmdhead_cnt831_6));
  EDFCND1HVT sio_data_reg_int_reg_17_ (.CDN(rst_b_2), .CP(spi_clk_out_8), 
     .D(sio_data_reg_int451_49), .E(n_1545), .Q(sio_data_reg[17]), .QN());
  BUFFD1HVT OPTHOLD_G_1002 (.I(sio_data_reg_int451_43), 
     .Z(sio_data_reg_int451_74));
  OAI31D1HVT U580_C3 (.A1(n1199_2), .A2(n1173_1), .A3(n1172), .B(n1244_1), 
     .ZN(n1169));
  BUFFD4HVT BW1_BUF2679 (.I(sio_data_reg_0_2), .Z(sio_data_reg[0]));
  OAI33D4HVT U540_C5 (.A1(n1244_1), .A2(n1199_1), .A3(n1173_1), .B1(n1458), 
     .B2(n1198_1), .B3(n1197), .ZN(n1202));
  INVD1HVT U615_C1_MP_INV (.I(n1179), .ZN(n1179_1));
  IOA21D1HVT U644_C4 (.A1(n1466), .A2(md_jtag), .B(U644_N6), .ZN(n1465));
  IND3D1HVT U644_C3 (.A1(md_jtag), .B1(spi_ss_out_b_int), .B2(md_spi), 
     .ZN(U644_N6));
  BUFFD1HVT OPTHOLD_G_374 (.I(sr_datacnt687_5), .Z(sr_datacnt687_7));
endmodule

// Entity:spi_smc_DW01_dec_5_0 Model:spi_smc_DW01_dec_5_0 Library:L1
module spi_smc_DW01_dec_5_0 (A, SUM, cmdhead_cnt_3_1, cmdhead_cnt_0_2, 
     cmdhead_cnt_2_1, cmdhead_cnt_4_1, cmdhead_cnt_1_1);
  input cmdhead_cnt_3_1, cmdhead_cnt_0_2, cmdhead_cnt_2_1, cmdhead_cnt_4_1, 
     cmdhead_cnt_1_1;
  input [4:0] A;
  output [4:0] SUM;
  wire carry_2, carry_3, carry_4;
  XNR2D1HVT U1_A_3_C1 (.A1(carry_3), .A2(cmdhead_cnt_3_1), .ZN(SUM[3]));
  OR2D1HVT U1_B_3_C1 (.A1(carry_3), .A2(cmdhead_cnt_3_1), .Z(carry_4));
  XNR2D1HVT U1_A_4_C1 (.A1(carry_4), .A2(cmdhead_cnt_4_1), .ZN(SUM[4]));
  XNR2D1HVT U1_A_2_C1 (.A1(carry_2), .A2(cmdhead_cnt_2_1), .ZN(SUM[2]));
  INVD1HVT U6_C1 (.I(cmdhead_cnt_0_2), .ZN(SUM[0]));
  IND2D1HVT U1_B_1_C1 (.A1(cmdhead_cnt_1_1), .B1(SUM[0]), .ZN(carry_2));
  XNR2D1HVT U1_A_1_C1 (.A1(cmdhead_cnt_1_1), .A2(cmdhead_cnt_0_2), .ZN(SUM[1]));
  OR2D1HVT U1_B_2_C1 (.A1(carry_2), .A2(A[2]), .Z(carry_3));
endmodule

// Entity:spi_smc_DW01_dec_6_0 Model:spi_smc_DW01_dec_6_0 Library:L1
module spi_smc_DW01_dec_6_0 (A, SUM, sr_datacnt_5_1, sr_datacnt_4_1, 
     sr_datacnt_2_2, sr_datacnt_3_2, sr_datacnt_1_1, sr_datacnt_0_1);
  input sr_datacnt_5_1, sr_datacnt_4_1, sr_datacnt_2_2, sr_datacnt_3_2, 
     sr_datacnt_1_1, sr_datacnt_0_1;
  input [5:0] A;
  output [5:0] SUM;
  wire carry_2, carry_3, carry_4, carry_5, sr_datacnt_2_1, sr_datacnt_3_1, 
     sr_datacnt_0_2;
  BUFFD1HVT OPTHOLD_G_352 (.I(sr_datacnt_3_2), .Z(sr_datacnt_3_1));
  INVD1HVT U6_C1 (.I(sr_datacnt_0_2), .ZN(SUM[0]));
  OR2D1HVT U1_B_3_C1 (.A1(carry_3), .A2(sr_datacnt_3_2), .Z(carry_4));
  XNR2D1HVT U1_A_5_C1 (.A1(carry_5), .A2(sr_datacnt_5_1), .ZN(SUM[5]));
  XNR2D1HVT U1_A_4_C1 (.A1(carry_4), .A2(sr_datacnt_4_1), .ZN(SUM[4]));
  OR2D1HVT U1_B_4_C1 (.A1(carry_4), .A2(sr_datacnt_4_1), .Z(carry_5));
  OR2D1HVT U1_B_2_C1 (.A1(carry_2), .A2(sr_datacnt_2_2), .Z(carry_3));
  XNR2D1HVT U1_A_2_C1 (.A1(carry_2), .A2(sr_datacnt_2_1), .ZN(SUM[2]));
  BUFFD1HVT OPTHOLD_G_351 (.I(sr_datacnt_2_2), .Z(sr_datacnt_2_1));
  XNR2D1HVT U1_A_3_C1 (.A1(carry_3), .A2(sr_datacnt_3_1), .ZN(SUM[3]));
  BUFFD1HVT OPTHOLD_G_947 (.I(sr_datacnt_0_1), .Z(sr_datacnt_0_2));
  XNR2D1HVT U1_A_1_C1 (.A1(sr_datacnt_1_1), .A2(sr_datacnt_0_1), .ZN(SUM[1]));
  IND2D1HVT U1_B_1_C1 (.A1(sr_datacnt_1_1), .B1(SUM[0]), .ZN(carry_2));
endmodule

// Entity:spi_smc_DW01_dec_8_0 Model:spi_smc_DW01_dec_8_0 Library:L1
module spi_smc_DW01_dec_8_0 (A, SUM, spicnt_1_1, spicnt_0_1, spicnt_2_1, 
     spicnt_7_1, spicnt_3_2, spicnt_5_2, spicnt_6_1, spicnt_4_1);
  input spicnt_1_1, spicnt_0_1, spicnt_2_1, spicnt_7_1, spicnt_3_2, spicnt_5_2, 
     spicnt_6_1, spicnt_4_1;
  input [7:0] A;
  output [7:0] SUM;
  wire carry_2, carry_3, carry_4, carry_5, carry_6, carry_7, spicnt_5_1, 
     spicnt_3_1;
  BUFFD1HVT OPTHOLD_G_359 (.I(spicnt_3_2), .Z(spicnt_3_1));
  OR2D1HVT U1_B_5_C1 (.A1(carry_5), .A2(spicnt_5_2), .Z(carry_6));
  BUFFD1HVT OPTHOLD_G_358 (.I(spicnt_5_2), .Z(spicnt_5_1));
  OR2D1HVT U1_B_4_C1 (.A1(carry_4), .A2(A[4]), .Z(carry_5));
  INVD1HVT U6_C1 (.I(spicnt_0_1), .ZN(SUM[0]));
  XNR2D1HVT U1_A_1_C1 (.A1(spicnt_1_1), .A2(spicnt_0_1), .ZN(SUM[1]));
  XNR2D1HVT U1_A_2_C1 (.A1(carry_2), .A2(spicnt_2_1), .ZN(SUM[2]));
  IND2D1HVT U1_B_1_C1 (.A1(spicnt_1_1), .B1(SUM[0]), .ZN(carry_2));
  XNR2D1HVT U1_A_7_C1 (.A1(carry_7), .A2(spicnt_7_1), .ZN(SUM[7]));
  OR2D1HVT U1_B_2_C1 (.A1(carry_2), .A2(A[2]), .Z(carry_3));
  OR2D1HVT U1_B_6_C1 (.A1(carry_6), .A2(A[6]), .Z(carry_7));
  XNR2D1HVT U1_A_6_C1 (.A1(carry_6), .A2(spicnt_6_1), .ZN(SUM[6]));
  XNR2D1HVT U1_A_3_C1 (.A1(carry_3), .A2(spicnt_3_1), .ZN(SUM[3]));
  XNR2D1HVT U1_A_4_C1 (.A1(carry_4), .A2(spicnt_4_1), .ZN(SUM[4]));
  XNR2D1HVT U1_A_5_C1 (.A1(carry_5), .A2(spicnt_5_1), .ZN(SUM[5]));
  OR2D1HVT U1_B_3_C1 (.A1(carry_3), .A2(spicnt_3_2), .Z(carry_4));
endmodule

// Entity:cfg_smc Model:cfg_smc Library:L1
module cfg_smc (clk, rst_b, cnt_podt_out, startup_req, shutdown_req, 
     warmboot_req, reboot_source_nvcm, end_of_startup, end_of_shutdown, 
     sample_mode_done, md_jtag, md_spi, spi_ss_in_b, cram_clr, cram_done, 
     cfg_ld_bstream, cfg_startup, cfg_shutdown, cram_access_en, cram_clr_done, 
     cram_clr_done_r, fpga_operation, spi_master_go, nvcm_boot, 
     smc_load_nvcm_bstream, nvcm_rdy, sample_mode_done_3, cram_clr_done_1, 
     cram_clr_done_r_2, smc_load_nvcm_bstream_4, spi_clk_out_13, shutdown_req_1, 
     end_of_shutdown_1, cram_done_1, spi_clk_out_6, spi_clk_out_11);
  input clk, rst_b, cnt_podt_out, startup_req, shutdown_req, warmboot_req, 
     reboot_source_nvcm, end_of_startup, end_of_shutdown, md_jtag, spi_ss_in_b, 
     cram_done, nvcm_boot, nvcm_rdy, sample_mode_done_3, cram_clr_done_1, 
     cram_clr_done_r_2, smc_load_nvcm_bstream_4, spi_clk_out_13, shutdown_req_1, 
     end_of_shutdown_1, cram_done_1, spi_clk_out_6, spi_clk_out_11;
  output sample_mode_done, md_spi, cram_clr, cfg_ld_bstream, cfg_startup, 
     cfg_shutdown, cram_access_en, cram_clr_done, cram_clr_done_r, 
     fpga_operation, spi_master_go, smc_load_nvcm_bstream;
  wire cfg_next_0_, cfg_next_2_, cfg_next_3_, cfg_shutdown522, cfg_state_0_, 
     cfg_state_1_, cfg_state_2_, cfg_state_3_, cram_access_en528, 
     fpga_operation510, n598, n599, n604, n605, n606, n607, n608, n609, n610, 
     n611, n612, n613, n615, n616, n618, n622, n630, n631, n632, n634, n637, 
     n639, n640, n642, n643, n644, n645, n646, sample_mode_done_reg_N13, 
     U180_N3, U218_N3, U182_N3, U190_N4, U199_N5, cnt_podt_out_1, cfg_startup_1, 
     cfg_next_2_1, n621_1, cfg_next_0_1, rst_b_1, n607_1, n645_1, n608_1, clk_1, 
     smc_load_nvcm_bstream_1, reboot_source_nvcm_1, rst_b_2, 
     smc_load_nvcm_bstream_3, n608_2, n639_1, n631_1, smc_load_nvcm_bstream_2, 
     cfg_next_0_2, cfg_next_3_1, cfg_next_0_3, n608_3, cfg_next_2_2, 
     cfg_state_2_1, cfg_state_1_1, cfg_state_3_1, smc_load_nvcm_bstream_5, 
     n631_2, cfg_next_3_2, n645_2, n609_1;
  BUFFD1HVT OPTHOLD_G_335 (.I(smc_load_nvcm_bstream_5), 
     .Z(smc_load_nvcm_bstream_2));
  DFCNQD2HVT cfg_ld_bstream_reg (.CDN(rst_b_2), .CP(spi_clk_out_6), .D(n640), 
     .Q(cfg_ld_bstream));
  IND2D1HVT U221_C1 (.A1(n639_1), .B1(n640), .ZN(n645));
  DFCND1HVT cfg_state_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_6), 
     .D(cfg_next_0_2), .Q(cfg_state_0_), .QN(n609));
  OAI211D1HVT U181_C3 (.A1(n607), .A2(n606), .B(n605), .C(n604), 
     .ZN(cfg_next_2_));
  NR3D1HVT U176_C2 (.A1(n637), .A2(n622), .A3(cfg_state_0_), .ZN(cfg_startup));
  INVD1HVT U211_C2_MP_INV (.I(cnt_podt_out), .ZN(cnt_podt_out_1));
  NR3D1HVT U198_C2 (.A1(n637), .A2(n609), .A3(n598), .ZN(n612));
  ND2D1HVT U180_C1 (.A1(n599), .A2(cnt_podt_out), .ZN(U180_N3));
  INVD1HVT U179_C2_MP_INV (.I(n607), .ZN(n607_1));
  BUFFD1HVT OPTHOLD_G_171 (.I(n639), .Z(n639_1));
  AO21D1HVT U211_C2 (.A1(n599), .A2(cnt_podt_out_1), .B(n611), .Z(n618));
  BUFFD1HVT OPTHOLD_G_882 (.I(smc_load_nvcm_bstream_1), 
     .Z(smc_load_nvcm_bstream_5));
  MOAI22D1HVT U204_C4 (.A1(n606), .A2(end_of_shutdown_1), .B1(md_spi), .B2(n618), 
     .ZN(n634));
  INVD1HVT U206_C3_MP_INV_1 (.I(reboot_source_nvcm), .ZN(reboot_source_nvcm_1));
  IND3D1HVT U199_C2 (.A1(cfg_state_2_), .B1(cfg_state_0_), .B2(cram_done_1), 
     .ZN(U199_N5));
  NR2D1HVT U218_C1 (.A1(cfg_state_2_1), .A2(n598), .ZN(U218_N3));
  NR4D1HVT U182_C3 (.A1(n612), .A2(n610), .A3(cfg_startup), .A4(U182_N3), 
     .ZN(n604));
  NR3D1HVT U196_C2 (.A1(n637), .A2(n598), .A3(cfg_state_0_), .ZN(n610));
  AO211D1HVT U213_C1 (.A1(n643), .A2(U218_N3), .B(n642), .C(n634), 
     .Z(cfg_next_0_));
  MUX2ND1HVT U227_C4 (.I0(rst_b_1), .I1(cram_done_1), .S(cfg_state_0_), 
     .ZN(n643));
  OR4XD1HVT U187_C3 (.A1(n634), .A2(n616), .A3(n615), .A4(n613), .Z(n608));
  INVD1HVT U210_C4_MP_INV (.I(cfg_startup), .ZN(cfg_startup_1));
  OR2D1HVT U215_C1 (.A1(n646), .A2(n640), .Z(cram_access_en528));
  BUFFD1HVT OPTHOLD_G_982 (.I(n645_1), .Z(n645_2));
  DFCNQD4HVT cram_clr_reg (.CDN(rst_b_2), .CP(spi_clk_out_6), .D(n646), 
     .Q(cram_clr));
  DFCNQD1HVT cram_access_en_reg (.CDN(rst_b_2), .CP(spi_clk_out_6), 
     .D(cram_access_en528), .Q(cram_access_en));
  BUFFD1HVT OPTHOLD_G_793 (.I(cfg_state_1_), .Z(cfg_state_1_1));
  BUFFD1HVT OPTHOLD_G_794 (.I(cfg_state_3_), .Z(cfg_state_3_1));
  DFCNQD1HVT spi_master_go_reg (.CDN(rst_b_2), .CP(spi_clk_out_6), .D(n645_2), 
     .Q(spi_master_go));
  NR2D1HVT U199_C3 (.A1(n598), .A2(U199_N5), .ZN(n613));
  INVD1HVT U227_C4_MP_INV (.I(rst_b_2), .ZN(rst_b_1));
  INVD1HVT spi_master_go_reg_MP_INV (.I(n645), .ZN(n645_1));
  MOAI22D1HVT U210_C4 (.A1(end_of_startup), .A2(cfg_startup_1), .B1(startup_req), 
     .B2(n610), .ZN(n616));
  AO21D1HVT U203_C2 (.A1(end_of_startup), .A2(cfg_startup), .B(n612), .Z(n642));
  AN3D1HVT U186_C2 (.A1(warmboot_req), .A2(reboot_source_nvcm), 
     .A3(end_of_shutdown_1), .Z(n607));
  OA21D1HVT U207_C2 (.A1(warmboot_req), .A2(shutdown_req_1), .B(n612), .Z(n615));
  IND4D1HVT U171_C4 (.A1(cfg_state_1_1), .B1(n637), .B2(n609), 
     .B3(cfg_state_3_1), .ZN(n639));
  INR2D1HVT U182_C1 (.A1(nvcm_rdy), .B1(n639), .ZN(U182_N3));
  INVD1HVT U219_C2_MP_INV (.I(cfg_next_2_2), .ZN(cfg_next_2_1));
  DFCND1HVT cfg_state_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_6), 
     .D(cfg_next_2_2), .Q(cfg_state_2_), .QN(n637));
  NR3D1HVT U174_C2 (.A1(n622), .A2(n609), .A3(cfg_state_2_1), .ZN(n599));
  BUFFD1HVT OPTHOLD_G_697 (.I(cfg_state_2_), .Z(cfg_state_2_1));
  OAI21D1HVT U183_C2 (.A1(n611), .A2(n599), .B(n621_1), .ZN(n605));
  INVD1HVT U217_C2_MP_INV (.I(n608_2), .ZN(n608_1));
  NR3D1HVT U197_C2 (.A1(n622), .A2(cfg_state_2_1), .A3(cfg_state_0_), .ZN(n611));
  AN3D1HVT U217_C2 (.A1(n608_1), .A2(cfg_next_2_2), .A3(cfg_next_0_1), .Z(n640));
  AN3D1HVT U223_C2 (.A1(n608_1), .A2(cfg_next_2_1), .A3(cfg_next_0_3), .Z(n646));
  BUFFD1HVT OPTHOLD_G_905 (.I(n631), .Z(n631_2));
  DFCNQD1HVT cram_clr_done_r_reg (.CDN(rst_b_2), .CP(clk_1), .D(n631_1), 
     .Q(cram_clr_done_r));
  BUFFD1HVT OPTHOLD_G_373 (.I(cfg_next_0_3), .Z(cfg_next_0_2));
  OR2D1HVT U172_C1 (.A1(cfg_state_3_), .A2(cfg_state_1_), .Z(n598));
  OAI221D1HVT U206_C3 (.A1(n639), .A2(U190_N4), .B1(smc_load_nvcm_bstream_2), 
     .B2(end_of_startup), .C(reboot_source_nvcm_1), .ZN(n630));
  INVD1HVT U219_C2_MP_INV_1 (.I(cfg_next_0_3), .ZN(cfg_next_0_1));
  AN3D1HVT U214_C3 (.A1(n608_3), .A2(cfg_next_2_2), .A3(cfg_next_0_3), 
     .Z(cfg_shutdown522));
  ND2D1HVT U190_C2 (.A1(nvcm_boot), .A2(md_spi), .ZN(U190_N4));
  AN3D1HVT U216_C3 (.A1(n608_1), .A2(cfg_next_2_2), .A3(cfg_next_0_3), 
     .Z(fpga_operation510));
  INVD1HVT U183_C2_MP_INV (.I(md_spi), .ZN(n621_1));
  IND2D1HVT U189_C2 (.A1(cfg_state_3_1), .B1(cfg_state_1_1), .ZN(n622));
  OAI222D1HVT U179_C2 (.A1(n607_1), .A2(n606), .B1(n621_1), .B2(U180_N3), 
     .C1(nvcm_rdy), .C2(n639_1), .ZN(cfg_next_3_));
  OR3XD1HVT U184_C2 (.A1(n637), .A2(n622), .A3(n609_1), .Z(n606));
  DFCNQD1HVT cfg_state_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_11), 
     .D(cfg_next_3_1), .Q(cfg_state_3_));
  DFCNQD1HVT cram_clr_done_reg (.CDN(rst_b_2), .CP(clk_1), .D(n611), 
     .Q(cram_clr_done));
  BUFFD2HVT BL1_BUF72 (.I(rst_b), .Z(rst_b_2));
  BUFFD1HVT OPTHOLD_G_329 (.I(n631_2), .Z(n631_1));
  CKND1HVT smc_load_nvcm_bstream_reg_MP_INV (.I(spi_clk_out_13), .ZN(clk_1));
  DFCNQD1HVT smc_load_nvcm_bstream_reg (.CDN(rst_b_2), .CP(clk_1), .D(n630), 
     .Q(smc_load_nvcm_bstream_3));
  OR2D1HVT U178_C1 (.A1(cram_clr_done_r_2), .A2(cram_clr_done_1), .Z(n631));
  BUFFD1HVT OPTHOLD_G_1125 (.I(n609), .Z(n609_1));
  BUFFD8HVT BL1_R_BUF_4 (.I(smc_load_nvcm_bstream_3), .Z(smc_load_nvcm_bstream));
  BUFFD1HVT OPTHOLD_G_642 (.I(n608), .Z(n608_3));
  BUFFD1HVT OPTHOLD_G_631 (.I(cfg_next_0_), .Z(cfg_next_0_3));
  BUFFD1HVT OPTHOLD_G_74 (.I(n608_3), .Z(n608_2));
  DFCNQD1HVT fpga_operation_reg (.CDN(rst_b_2), .CP(spi_clk_out_6), 
     .D(fpga_operation510), .Q(fpga_operation));
  DFCNQD1HVT sample_mode_done_reg (.CDN(rst_b_2), .CP(spi_clk_out_6), 
     .D(sample_mode_done_reg_N13), .Q(sample_mode_done));
  BUFFD1HVT OPTHOLD_G_408 (.I(cfg_next_3_2), .Z(cfg_next_3_1));
  DFCNQD1HVT cfg_shutdown_reg (.CDN(rst_b_2), .CP(spi_clk_out_6), 
     .D(cfg_shutdown522), .Q(cfg_shutdown));
  NR2XD3HVT U208_C1 (.A1(n632), .A2(md_jtag), .ZN(md_spi));
  BUFFD1HVT OPTHOLD_G_981 (.I(cfg_next_3_), .Z(cfg_next_3_2));
  OR2D1HVT sample_mode_done_reg_C9 (.A1(sample_mode_done_3), .A2(n644), 
     .Z(sample_mode_done_reg_N13));
  BUFFD1HVT OPTHOLD_G_653 (.I(cfg_next_2_), .Z(cfg_next_2_2));
  EDFCND1HVT md_spi_reg_reg (.CDN(rst_b_2), .CP(spi_clk_out_6), .D(spi_ss_in_b), 
     .E(n644), .Q(), .QN(n632));
  INVD1HVT U206_C3_MP_INV (.I(smc_load_nvcm_bstream_4), 
     .ZN(smc_load_nvcm_bstream_1));
  DFCNQD1HVT cfg_state_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_6), .D(n608_2), 
     .Q(cfg_state_1_));
  AN3D1HVT U219_C2 (.A1(n608_3), .A2(cfg_next_2_1), .A3(cfg_next_0_1), .Z(n644));
endmodule

// Entity:clkgen Model:clkgen Library:L1
module clkgen (rst_b, osc_clk, cclk, tck, sample_mode_done, md_spi, md_jtag, 
     clkout, clkout_b, sample_mode_done_2, spi_clk_in_2, spi_clk_out_2, 
     tck_pad_2, osc_clk_2, sample_mode_done_1, spi_clk_out_14, tck_pad_8, 
     osc_clk_8, spi_clk_in_6, clk_b_1);
  input rst_b, osc_clk, cclk, tck, sample_mode_done, md_spi, md_jtag, 
     sample_mode_done_2, spi_clk_in_2, tck_pad_2, osc_clk_2, spi_clk_out_14, 
     tck_pad_8, osc_clk_8, spi_clk_in_6;
  output clkout, clkout_b, spi_clk_out_2, sample_mode_done_1, clk_b_1;
  wire clksw1_out, sel_jtag_clk, sel_spi_clk, clksw1_out_1, clksw1_out_2, 
     clksw1_out_3, clksw1_out_4, clksw1_out_5;
  clk_gfsw_0 clksw2 (.rst_b(rst_b), .clka(), .clkb(), .sel(sel_jtag_clk), 
     .clkout(), .spi_clk_out_2(spi_clk_out_2), .tck_pad_2(tck_pad_2), 
     .clksw1_out_1(clksw1_out), .tck_pad_8(tck_pad_8), 
     .clksw1_out_3(clksw1_out_3));
  clk_gfsw_1 clksw1 (.rst_b(rst_b), .clka(), .clkb(), .sel(sel_spi_clk), 
     .clkout(), .clksw1_out_1(clksw1_out), .osc_clk_2(osc_clk_2), 
     .spi_clk_in_2(spi_clk_in_2), .spi_clk_in_6(spi_clk_in_6), 
     .osc_clk_8(osc_clk_8));
  CKAN2D1HVT U12_C1 (.A1(sample_mode_done_2), .A2(md_jtag), .Z(sel_jtag_clk));
  IND2D2HVT U11_C1 (.A1(md_spi), .B1(sample_mode_done_1), .ZN(sel_spi_clk));
  CKBD1HVT CLK_SYNC_SKEW_12 (.I(clksw1_out_2), .Z(clksw1_out_3));
  CKBD1HVT CLK_SYNC_SKEW_14 (.I(clksw1_out_4), .Z(clksw1_out_5));
  CKBD1HVT CLK_SYNC_SKEW_13 (.I(clksw1_out_1), .Z(clksw1_out_4));
  CKBD1HVT CLK_SYNC_SKEW_11 (.I(clksw1_out_5), .Z(clksw1_out_2));
  CKBD1HVT CLK_SYNC_SKEW_10 (.I(clksw1_out), .Z(clksw1_out_1));
  CKND16HVT S_0_C1 (.I(spi_clk_out_14), .ZN(clk_b_1));
  BUFFD2HVT OPTHOLD_G_70 (.I(sample_mode_done_2), .Z(sample_mode_done_1));
endmodule

// Entity:clk_gfsw_0 Model:clk_gfsw_0 Library:L1
module clk_gfsw_0 (rst_b, clka, clkb, sel, clkout, spi_clk_out_2, tck_pad_2, 
     clksw1_out_1, tck_pad_8, clksw1_out_3);
  input rst_b, clka, clkb, sel, tck_pad_2, clksw1_out_1, tck_pad_8, 
     clksw1_out_3;
  output clkout, spi_clk_out_2;
  wire clk_gb, n39, n40, n41, n_21, n_22, n_38, n_39, qa, qb, U19_N4, n_40, 
     n_23;
  ND2D1HVT U19_C2 (.A1(sel), .A2(rst_b), .ZN(U19_N4));
  INVD1HVT U20_C1 (.I(rst_b), .ZN(n40));
  INR3D1HVT U18_C3 (.A1(rst_b), .B1(sel), .B2(qb), .ZN(n_21));
  LNQD1HVT qa_reg (.D(n_21), .EN(n_23), .Q(qa));
  CKND1HVT qa_reg_MP_INV (.I(n_22), .ZN(n_23));
  OR2D1HVT U17 (.A1(n40), .A2(n41), .Z(n_22));
  LNQD1HVT qb_reg (.D(n_38), .EN(n_40), .Q(qb));
  NR2D1HVT U19_C3 (.A1(qa), .A2(U19_N4), .ZN(n_38));
  CKND1HVT qb_reg_MP_INV (.I(n_39), .ZN(n_40));
  IND2D1HVT U16 (.A1(n40), .B1(tck_pad_8), .ZN(n_39));
  CKND1HVT U15_C1 (.I(clksw1_out_3), .ZN(n41));
  OR2D8HVT S_17 (.A1(n39), .A2(clk_gb), .Z(spi_clk_out_2));
  AN2D2HVT U13 (.A1(clksw1_out_1), .A2(qa), .Z(n39));
  AN2D4HVT S_16 (.A1(qb), .A2(tck_pad_2), .Z(clk_gb));
endmodule

// Entity:clk_gfsw_1 Model:clk_gfsw_1 Library:L1
module clk_gfsw_1 (rst_b, clka, clkb, sel, clkout, clksw1_out_1, osc_clk_2, 
     spi_clk_in_2, spi_clk_in_6, osc_clk_8);
  input rst_b, clka, clkb, sel, osc_clk_2, spi_clk_in_2, spi_clk_in_6, 
     osc_clk_8;
  output clkout, clksw1_out_1;
  wire n47, n48, n49, n_21, n_22, n_38, n_39, qa, qb, U24_N4, n_40, n_23;
  INVD1HVT U25_C1 (.I(rst_b), .ZN(n48));
  INR3D1HVT U23_C3 (.A1(rst_b), .B1(sel), .B2(qb), .ZN(n_21));
  OR2D1HVT U22 (.A1(n48), .A2(n47), .Z(n_22));
  NR2D1HVT U24_C3 (.A1(qa), .A2(U24_N4), .ZN(n_38));
  LNQD1HVT qb_reg (.D(n_38), .EN(n_40), .Q(qb));
  CKND1HVT qa_reg_MP_INV (.I(n_22), .ZN(n_23));
  LNQD1HVT qa_reg (.D(n_21), .EN(n_23), .Q(qa));
  ND2D1HVT U24_C2 (.A1(sel), .A2(rst_b), .ZN(U24_N4));
  CKND1HVT qb_reg_MP_INV (.I(n_39), .ZN(n_40));
  AO22D4HVT U13 (.A1(spi_clk_in_2), .A2(qa), .B1(qb), .B2(osc_clk_2), 
     .Z(clksw1_out_1));
  CKND1HVT U14_C1 (.I(osc_clk_8), .ZN(n49));
  CKND1HVT U15_C1 (.I(spi_clk_in_6), .ZN(n47));
  OR2D1HVT U21 (.A1(n48), .A2(n49), .Z(n_39));
endmodule

// Entity:cram_smc Model:cram_smc Library:L1
module cram_smc (clk, clk_b, rst_b, tm_dis_cram_clk_gating, cram_wrt, cram_rd, 
     cram_clr, cor_en_8bconfig, cor_security_rddis, cor_security_wrtdis, 
     cram_access_en, baddr, flen, fnum, stwrt_fnum, cram_reading, cram_done, 
     cm_clk, cm_banksel, smc_rsr_rst, smc_row_inc, smc_wset_prec, 
     smc_wwlwrt_dis, smc_wcram_rst, smc_wset_precgnd, smc_wwlwrt_en, smc_rwl_en, 
     data_muxsel1, smc_wdis_dclk, data_muxsel, smc_rpull_b, smc_rprec, 
     smc_rrst_pullwlen, cm_last_rsr, framelen_10_2, framelen_12_2, 
     framelen_13_2, framelen_8_2, framelen_14_2, framelen_9_2, spi_clk_out_12, 
     framelen_11_2, framelen_9_3, framelen_15_2, framelen_7_3, framelen_7_2, 
     framelen_12_3, framelen_10_3, framelen_0_3, framelen_1_3, framelen_2_3, 
     framelen_4_2, framelen_3_3, framelen_2_2, framelen_6_3, framelen_6_2, 
     framelen_13_3, framelen_4_3, framelen_5_2, framelen_15_3, framelen_5_3, 
     framelen_1_2, framelen_3_2, framenum_3_3, framelen_0_2, framenum_3_2, 
     framenum_4_2, framenum_4_3, framenum_2_3, framenum_1_3, framenum_2_2, 
     framenum_1_2, framenum_0_2, spi_clk_out_7, smc_write_4, framenum_0_3, 
     framenum_5_2, framenum_5_3, clk_b_2, start_framenum_0_1, 
     start_framenum_1_2, framenum_6_2, framenum_7_3, framenum_6_3, framenum_7_2, 
     smc_read_4, start_framenum_5_2, start_framenum_4_2, start_framenum_3_1, 
     Iconfig_top_CRAM_SMC_smc_rsr_rst_5, Iconfig_top_CRAM_SMC_smc_rsr_rst_4, 
     start_framenum_2_2, start_framenum_6_2, start_framenum_7_2, smc_seq_rst_3, 
     cram_reading_1, tm_dis_cram_clk_gating_1);
  input clk, clk_b, rst_b, tm_dis_cram_clk_gating, cram_wrt, cram_rd, cram_clr, 
     cor_en_8bconfig, cor_security_rddis, cor_security_wrtdis, cram_access_en, 
     cm_last_rsr, framelen_10_2, framelen_12_2, framelen_13_2, framelen_8_2, 
     framelen_14_2, framelen_9_2, spi_clk_out_12, framelen_11_2, framelen_9_3, 
     framelen_15_2, framelen_7_3, framelen_7_2, framelen_12_3, framelen_10_3, 
     framelen_0_3, framelen_1_3, framelen_2_3, framelen_4_2, framelen_3_3, 
     framelen_2_2, framelen_6_3, framelen_6_2, framelen_13_3, framelen_4_3, 
     framelen_5_2, framelen_15_3, framelen_5_3, framelen_1_2, framelen_3_2, 
     framenum_3_3, framelen_0_2, framenum_3_2, framenum_4_2, framenum_4_3, 
     framenum_2_3, framenum_1_3, framenum_2_2, framenum_1_2, framenum_0_2, 
     spi_clk_out_7, smc_write_4, framenum_0_3, framenum_5_2, framenum_5_3, 
     clk_b_2, start_framenum_0_1, start_framenum_1_2, framenum_6_2, 
     framenum_7_3, framenum_6_3, framenum_7_2, smc_read_4, start_framenum_5_2, 
     start_framenum_4_2, start_framenum_3_1, Iconfig_top_CRAM_SMC_smc_rsr_rst_5, 
     Iconfig_top_CRAM_SMC_smc_rsr_rst_4, start_framenum_2_2, start_framenum_6_2, 
     start_framenum_7_2, smc_seq_rst_3, cram_reading_1, 
     tm_dis_cram_clk_gating_1;
  output cram_reading, cram_done, cm_clk, smc_rsr_rst, smc_row_inc, 
     smc_wset_prec, smc_wwlwrt_dis, smc_wcram_rst, smc_wset_precgnd, 
     smc_wwlwrt_en, smc_rwl_en, data_muxsel1, smc_wdis_dclk, data_muxsel, 
     smc_rpull_b, smc_rprec, smc_rrst_pullwlen;
  input [1:0] baddr;
  input [15:0] flen;
  input [7:0] fnum;
  input [7:0] stwrt_fnum;
  output [3:0] cm_banksel;
  wire auxcnt787_0, auxcnt787_1, auxcnt787_2, auxcnt789_0, auxcnt_0_, auxcnt_1_, 
     auxcnt_2_, cram_clk_en_i, cram_done275, cram_reading_int, 
     cram_reading_int_d1, cram_reading_int_d2, cram_reading_int_d3, 
     data_muxsel1496, data_muxsel502, dummycnt709_0, dummycnt709_1, 
     dummycnt709_2, dummycnt709_3, dummycnt711_0, dummycnt711_2, dummycnt711_3, 
     dummycnt_0_, dummycnt_1_, dummycnt_2_, dummycnt_3_, flencnt864_0, 
     flencnt864_1, flencnt864_10, flencnt864_11, flencnt864_12, flencnt864_13, 
     flencnt864_14, flencnt864_15, flencnt864_2, flencnt864_3, flencnt864_4, 
     flencnt864_5, flencnt864_6, flencnt864_7, flencnt864_8, flencnt864_9, 
     flencnt865_0, flencnt865_1, flencnt865_10, flencnt865_11, flencnt865_12, 
     flencnt865_13, flencnt865_14, flencnt865_15, flencnt865_2, flencnt865_3, 
     flencnt865_4, flencnt865_5, flencnt865_6, flencnt865_7, flencnt865_8, 
     flencnt865_9, flencnt_0_, flencnt_10_, flencnt_11_, flencnt_12_, 
     flencnt_13_, flencnt_14_, flencnt_15_, flencnt_1_, flencnt_2_, flencnt_3_, 
     flencnt_4_, flencnt_5_, flencnt_6_, flencnt_7_, flencnt_8_, flencnt_9_, 
     fnumcnt940_0, fnumcnt940_1, fnumcnt940_2, fnumcnt940_3, fnumcnt940_4, 
     fnumcnt940_5, fnumcnt940_6, fnumcnt940_7, fnumcnt942_0, fnumcnt942_1, 
     fnumcnt942_2, fnumcnt942_3, fnumcnt942_4, fnumcnt942_5, fnumcnt942_6, 
     fnumcnt942_7, fnumcnt_0_, fnumcnt_1_, fnumcnt_2_, fnumcnt_3_, fnumcnt_4_, 
     fnumcnt_5_, fnumcnt_6_, fnumcnt_7_, n1019_0, n1257, n1258, n1259, n1260, 
     n1261, n1262, n1263, n1264, n1265, n1266, n1267, n1268, n1269, n1270, 
     n1271, n1272, n1273, n1274, n1275, n1276, n1277, n1278, n1279, n1280, 
     n1281, n1282, n1283, n1284, n1285, n1286, n1287, n1288, n1289, n1290, 
     n1291, n1292, n1293, n1294, n1295, n1296, n1297, n1298, n1300, n1301, 
     n1302, n1303, n1304, n1305, n1306, n1307, n1308, n1310, n1311, n1312, 
     n1313, n1314, n1316, n1317, n1318, n1319, n1320, n1321, n1322, n1323, 
     n1324, n1325, n1326, n1327, n1328, n1329, n1330, n1331, n1350, n1351, 
     n1352, n1353, n1354, n1355, n1363, n1364, n1365, n1366, n1367, n1370, 
     n1371, n1373, n1374, n1375, n1376, n1378, n1379, n1380, n1385, n1386, 
     n1387, n1393, n1394, n1395, n1396, n1397, n1398, n1399, n1400, n1401, 
     n1402, n1403, n1408, n1410, n1411, n1412, n1413, n1415, n1423, n1424, 
     n1427, n1428, n1429, n710_0, n788_0, n941_0, n_472, next_0_, next_1_, 
     next_2_, smc_row_inc_en, smc_row_inc_en287, smc_rprec299, smc_rpull_b508, 
     smc_rrst_pullwlen514, smc_rsr_rst281, smc_wcram_rst532, 
     smc_wset_precgnd538, state_0_, state_1_, state_2_, stwrt_fnumcnt1018_0, 
     stwrt_fnumcnt1018_1, stwrt_fnumcnt1018_2, stwrt_fnumcnt1018_3, 
     stwrt_fnumcnt1018_4, stwrt_fnumcnt1018_5, stwrt_fnumcnt1018_6, 
     stwrt_fnumcnt1018_7, stwrt_fnumcnt1020_0, stwrt_fnumcnt1020_1, 
     stwrt_fnumcnt1020_2, stwrt_fnumcnt1020_3, stwrt_fnumcnt1020_4, 
     stwrt_fnumcnt1020_5, stwrt_fnumcnt1020_6, stwrt_fnumcnt1020_7, 
     stwrt_fnumcnt_0_, stwrt_fnumcnt_1_, stwrt_fnumcnt_2_, stwrt_fnumcnt_3_, 
     stwrt_fnumcnt_4_, stwrt_fnumcnt_5_, stwrt_fnumcnt_6_, stwrt_fnumcnt_7_, 
     U435_N5, U549_N3, U532_N8, U533_N3, U533_N6, U639_N3, U528_N5, U480_N3, 
     cram_reading_int_reg_N13, U633_N5, n1306_1, cram_wrt_1, flencnt_2_1, 
     flencnt_1_1, cram_rd_1, n1313_1, flencnt_3_1, state_0_1, cram_clr_1, 
     state_2_1, n1363_1, n1258_1, n1310_1, n1301_1, n1318_1, flencnt_0_1, 
     n1322_1, n1364_1, smc_rsr_rst_1, n1373_1, n1415_1, n1327_1, baddr_0_1, 
     cram_clr_2, cram_wrt_2, cram_rd_2, rst_b_1, rst_b_2, n1366_1, n1306_2, 
     n788_1, n1354_1, n1401_1, state_0_2, state_2_2, state_2_3, auxcnt_0_1, 
     auxcnt_0_2, cram_reading_int_1, cram_reading_int_2, dummycnt_3_1, n1410_1, 
     flencnt_0_2, smc_row_inc_en_1, smc_row_inc_en_2, cram_reading_int_d3_1, 
     cram_reading_int_d3_2, cram_reading_int_d1_1, cram_reading_int_d1_2, 
     cram_reading_int_d1_3, cram_reading_int_d2_1, cram_reading_int_d2_2, 
     dummycnt711_1, n1305_1, n1304_1, stwrt_fnumcnt1018_8, stwrt_fnumcnt1018_9, 
     stwrt_fnumcnt1018_10, stwrt_fnumcnt1018_11, stwrt_fnumcnt1018_12, 
     stwrt_fnumcnt1018_13, stwrt_fnumcnt1018_14, stwrt_fnumcnt1018_15, 
     cram_reading_int_reg_N13_1, next_0_1, n1328_1, next_2_1, fnumcnt940_8, 
     fnumcnt940_9, next_1_1, fnumcnt940_10, fnumcnt940_11, fnumcnt940_12, 
     fnumcnt940_13, fnumcnt940_14, fnumcnt940_15, smc_rprec299_1, flencnt864_16, 
     flencnt864_17, flencnt864_18, flencnt864_19, flencnt864_20, flencnt864_21, 
     flencnt864_22, flencnt864_23, flencnt864_24, flencnt864_25, flencnt864_26, 
     flencnt864_27, flencnt864_28, flencnt864_29, flencnt864_30, flencnt864_31, 
     dummycnt709_4, dummycnt_0_1, dummycnt_1_1, flencnt_4_1, dummycnt_2_1, 
     smc_row_inc_en_3, cram_reading_int_d2_3, cram_reading_int_d3_3, 
     cram_reading_int_d3_4, cram_reading_int_d1_4, cram_reading_int_3, n1019_1, 
     cram_clr_3, cram_wrt_3, n788_2, cram_rd_3, flencnt_3_2, flencnt_0_3, 
     n1353_1, n1301_2, n1350_1, dummycnt711_4, n1306_3, cram_reading_int_4, 
     auxcnt_1_1, state_1_1, smc_row_inc_en_4, dummycnt711_5, 
     cram_reading_int_d1_5, cram_reading_int_5, cram_reading_int_d2_4, 
     cram_reading_int_d2_5, cram_reading_int_d3_5, dummycnt711_6, dummycnt711_7, 
     stwrt_fnumcnt1018_16, stwrt_fnumcnt1018_17, stwrt_fnumcnt1018_18, 
     stwrt_fnumcnt1018_19, stwrt_fnumcnt1018_20, stwrt_fnumcnt1018_21, 
     stwrt_fnumcnt1018_22, stwrt_fnumcnt1018_23, auxcnt787_3, auxcnt787_4, 
     cram_reading_int_reg_N13_2, cram_reading_int_reg_N13_3, next_0_2, next_0_3, 
     n1328_2, cram_clk_en_i_1, cram_done275_1, smc_rsr_rst281_1, fnumcnt940_16, 
     fnumcnt940_17, next_1_2, fnumcnt940_18, fnumcnt940_19, fnumcnt940_20, 
     fnumcnt940_21, fnumcnt940_22, fnumcnt940_23, flencnt864_32, flencnt864_33, 
     flencnt864_34, flencnt864_35, flencnt864_36, flencnt864_37, flencnt864_38, 
     flencnt864_39, smc_row_inc_en287_1, flencnt864_40, flencnt864_41, 
     flencnt864_42, flencnt864_43, flencnt864_44, dummycnt709_5, smc_rprec299_2, 
     smc_rprec299_3, flencnt864_45, flencnt864_46, flencnt864_47, flencnt864_48, 
     flencnt864_49, flencnt864_50, flencnt864_51, dummycnt_3_2, dummycnt_1_2, 
     n1373_2, VSS_magmatienet_0;
  DFCNQD4HVT cram_done_reg (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(cram_done275_1), .Q(cram_done));
  BUFFD1HVT OPTHOLD_G_570 (.I(cram_reading_int_d2_2), .Z(cram_reading_int_d2_3));
  MUX2D1HVT U538_C4 (.I0(fnumcnt942_0), .I1(framenum_0_2), .S(n1310), 
     .Z(fnumcnt940_0));
  cram_smc_DW01_dec_16_0 sub_443 (.A({flencnt_15_, flencnt_14_, flencnt_13_, 
     flencnt_12_, flencnt_11_, flencnt_10_, flencnt_9_, flencnt_8_, flencnt_7_, 
     flencnt_6_, flencnt_5_, flencnt_4_, flencnt_3_, flencnt_2_, flencnt_1_, 
     flencnt_0_}), .SUM({flencnt865_15, flencnt865_14, flencnt865_13, 
     flencnt865_12, flencnt865_11, flencnt865_10, flencnt865_9, flencnt865_8, 
     flencnt865_7, flencnt865_6, flencnt865_5, flencnt865_4, flencnt865_3, 
     flencnt865_2, flencnt865_1, flencnt865_0}), .flencnt_3_2(flencnt_3_2), 
     .flencnt_0_2(flencnt_0_2));
  CKXOR2D1HVT U493_C1 (.A1(auxcnt_1_1), .A2(auxcnt_0_1), .Z(n1305));
  CKXOR2D1HVT U491_C1 (.A1(n1355), .A2(n1354_1), .Z(n1304));
  ND4D1HVT U469_C3 (.A1(n1294), .A2(n1293), .A3(n1292), .A4(n1291), .ZN(n1394));
  XNR2D1HVT U472_C1 (.A1(fnumcnt_0_), .A2(framenum_0_3), .ZN(n1293));
  NR4D1HVT U523_C3 (.A1(n1386), .A2(n1318), .A3(flencnt_3_1), .A4(flencnt_1_), 
     .ZN(n1320));
  BUFFD1HVT OPTHOLD_G_513 (.I(flencnt864_42), .Z(flencnt864_29));
  BUFFD1HVT BL1_BUF56 (.I(smc_write_4), .Z(cram_wrt_2));
  NR2D1HVT U506_C1 (.A1(n1403), .A2(n1402), .ZN(n1313));
  DFCNQD1HVT smc_wset_precgnd_reg (.CDN(rst_b_2), .CP(clk_b_2), 
     .D(smc_wset_precgnd538), .Q(smc_wset_precgnd));
  DFCNQD1HVT smc_wwlwrt_dis_reg (.CDN(rst_b_2), .CP(clk_b_2), .D(n1331), 
     .Q(smc_wwlwrt_dis));
  BUFFD1HVT OPTHOLD_G_453 (.I(cram_reading_int_reg_N13_2), 
     .Z(cram_reading_int_reg_N13_1));
  BUFFD1HVT OPTHOLD_G_583 (.I(cram_reading_int_4), .Z(cram_reading_int_3));
  TIELHVT VSS_magmatiecell_0 (.ZN(VSS_magmatienet_0));
  CKLNQD6HVT CM_CLKb (.CP(spi_clk_out_12), .E(cram_clk_en_i_1), .Q(cm_clk), 
     .TE(tm_dis_cram_clk_gating_1));
  BUFFD2HVT BL1_BUF54 (.I(smc_seq_rst_3), .Z(cram_clr_2));
  INVD1HVT U645_C3_MP_INV (.I(n1415), .ZN(n1415_1));
  BUFFD1HVT OPTHOLD_G_298 (.I(smc_row_inc_en_4), .Z(smc_row_inc_en_2));
  INVD1HVT cram_reading_int_reg_C9_MP_INV (.I(n1373), .ZN(n1373_1));
  MOAI22D1HVT U613_C4 (.A1(n1366), .A2(n1365), .B1(n1324), .B2(cram_clr_2), 
     .ZN(smc_wcram_rst532));
  OAI211D1HVT U519_C3 (.A1(n1371), .A2(cram_wrt_1), .B(n1322), .C(n1319), 
     .ZN(n_472));
  BUFFD1HVT OPTHOLD_G_884 (.I(cram_reading_int_d2_3), .Z(cram_reading_int_d2_5));
  MUX2D1HVT U541_C4 (.I0(stwrt_fnumcnt1020_5), .I1(start_framenum_5_2), 
     .S(Iconfig_top_CRAM_SMC_smc_rsr_rst_4), .Z(stwrt_fnumcnt1018_5));
  EDFCND1HVT stwrt_fnumcnt_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(stwrt_fnumcnt1018_16), .E(n1019_1), .Q(stwrt_fnumcnt_3_), .QN(n1275));
  EDFCND1HVT stwrt_fnumcnt_reg_5_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(stwrt_fnumcnt1018_21), .E(n1019_1), .Q(stwrt_fnumcnt_5_), .QN(n1276));
  BUFFD1HVT OPTHOLD_G_928 (.I(stwrt_fnumcnt1018_11), .Z(stwrt_fnumcnt1018_16));
  DFCNQD1HVT cram_reading_int_d2_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(cram_reading_int_d1_1), .Q(cram_reading_int_d2));
  XNR2D1HVT U610_C1 (.A1(n1352), .A2(dummycnt_3_1), .ZN(dummycnt711_3));
  BUFFD1HVT OPTHOLD_G_883 (.I(cram_reading_int_d2_1), .Z(cram_reading_int_d2_4));
  BUFFD1HVT OPTHOLD_G_934 (.I(stwrt_fnumcnt1018_0), .Z(stwrt_fnumcnt1018_18));
  BUFFD1HVT OPTHOLD_G_1064 (.I(smc_rsr_rst281), .Z(smc_rsr_rst281_1));
  OAI32D1HVT U509_C3 (.A1(n1367), .A2(dummycnt711_0), .A3(cram_clr_1), 
     .B1(n1387), .B2(flencnt_1_), .ZN(smc_wset_precgnd538));
  BUFFD1HVT OPTHOLD_G_340 (.I(dummycnt711_4), .Z(dummycnt711_1));
  BUFFD1HVT OPTHOLD_G_376 (.I(stwrt_fnumcnt1018_5), .Z(stwrt_fnumcnt1018_13));
  ND4D1HVT U514_C3 (.A1(n1353_1), .A2(n1351), .A3(n1350_1), .A4(dummycnt_0_), 
     .ZN(n1373));
  BUFFD1HVT OPTHOLD_G_368 (.I(stwrt_fnumcnt1018_18), .Z(stwrt_fnumcnt1018_9));
  BUFFD1HVT OPTHOLD_G_860 (.I(smc_row_inc_en), .Z(smc_row_inc_en_4));
  BUFFD1HVT OPTHOLD_G_538 (.I(flencnt_4_), .Z(flencnt_4_1));
  DFCNQD1HVT cram_reading_int_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(cram_reading_int_reg_N13_3), .Q(cram_reading_int));
  BUFFD1HVT OPTHOLD_G_869 (.I(dummycnt711_1), .Z(dummycnt711_5));
  NR3D1HVT U524_C2 (.A1(dummycnt_1_1), .A2(dummycnt_0_1), .A3(cram_rd_1), 
     .ZN(n1321));
  OAI32D1HVT U438_C4 (.A1(n1322), .A2(n1313_1), .A3(n1258_1), .B1(n1301_2), 
     .B2(cram_rd_1), .ZN(n1376));
  BUFFD1HVT OPTHOLD_G_1068 (.I(fnumcnt940_4), .Z(fnumcnt940_18));
  AO22D1HVT U504_C3 (.A1(n1312), .A2(n1311), .B1(n1375), .B2(n1313), 
     .Z(cram_done275));
  BUFFD1HVT OPTHOLD_G_87 (.I(state_2_3), .Z(state_2_2));
  ND3D1HVT U468_C2 (.A1(state_2_2), .A2(state_0_1), .A3(n1401_1), .ZN(n1410));
  IND2D1HVT U480_C1 (.A1(n1395), .B1(n1314), .ZN(U480_N3));
  BUFFD1HVT OPTHOLD_G_1123 (.I(flencnt864_13), .Z(flencnt864_50));
  BUFFD1HVT OPTHOLD_G_1065 (.I(fnumcnt940_11), .Z(fnumcnt940_16));
  MUX2D1HVT U545_C4 (.I0(stwrt_fnumcnt1020_1), .I1(start_framenum_1_2), 
     .S(Iconfig_top_CRAM_SMC_smc_rsr_rst_4), .Z(stwrt_fnumcnt1018_1));
  INR2XD1HVT U549_C3 (.A1(cram_access_en), .B1(U549_N3), .ZN(n1415));
  DFCNQD1HVT smc_rrst_pullwlen_reg (.CDN(rst_b_2), .CP(clk_b_2), 
     .D(smc_rrst_pullwlen514), .Q(smc_rrst_pullwlen));
  BUFFD1HVT OPTHOLD_G_911 (.I(dummycnt711_2), .Z(dummycnt711_6));
  BUFFD1HVT OPTHOLD_G_575 (.I(cram_reading_int_d3), .Z(cram_reading_int_d3_4));
  BUFFD1HVT OPTHOLD_G_480 (.I(fnumcnt940_22), .Z(fnumcnt940_13));
  MUX2D1HVT U585_C4 (.I0(framelen_0_2), .I1(flencnt865_0), .S(n1429), 
     .Z(flencnt864_0));
  XNR2D1HVT U458_C1 (.A1(flencnt_13_), .A2(framelen_13_3), .ZN(n1270));
  XNR2D1HVT U461_C1 (.A1(flencnt_0_3), .A2(framelen_0_3), .ZN(n1272));
  OR4XD1HVT U626_C3 (.A1(n1400), .A2(n1399), .A3(n1398), .A4(n1397), .Z(n1396));
  ND4D1HVT U454_C3 (.A1(n1270), .A2(n1269), .A3(n1268), .A4(n1267), .ZN(n1398));
  XNR2D1HVT U447_C1 (.A1(flencnt_2_), .A2(framelen_2_3), .ZN(n1261));
  EDFCND1HVT fnumcnt_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(fnumcnt940_16), .E(n941_0), .Q(fnumcnt_6_), .QN(n1287));
  BUFFD1HVT OPTHOLD_G_624 (.I(cram_clr_2), .Z(cram_clr_3));
  BUFFD1HVT OPTHOLD_G_478 (.I(fnumcnt940_6), .Z(fnumcnt940_11));
  INVD1HVT U468_C2_MP_INV (.I(state_0_2), .ZN(state_0_1));
  MUX2D1HVT U576_C4 (.I0(framelen_14_2), .I1(flencnt865_14), .S(n1429), 
     .Z(flencnt864_14));
  BUFFD1HVT OPTHOLD_G_511 (.I(flencnt864_46), .Z(flencnt864_27));
  DFCNQD1HVT flencnt_reg_9_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_37), .Q(flencnt_9_));
  DFCNQD1HVT flencnt_reg_11_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_35), .Q(flencnt_11_));
  BUFFD1HVT OPTHOLD_G_1113 (.I(flencnt864_14), .Z(flencnt864_43));
  BUFFD1HVT OPTHOLD_G_502 (.I(flencnt864_34), .Z(flencnt864_18));
  BUFFD1HVT OPTHOLD_G_1059 (.I(cram_done275), .Z(cram_done275_1));
  DFCNQD1HVT flencnt_reg_13_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_20), .Q(flencnt_13_));
  XNR2D1HVT U446_C1 (.A1(flencnt_9_), .A2(framelen_9_3), .ZN(n1260));
  BUFFD1HVT OPTHOLD_G_503 (.I(flencnt864_40), .Z(flencnt864_19));
  DFCNQD1HVT flencnt_reg_7_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_39), .Q(flencnt_7_));
  BUFFD1HVT OPTHOLD_G_1066 (.I(fnumcnt940_2), .Z(fnumcnt940_17));
  INVD1HVT U557_C2_MP_INV (.I(n1363), .ZN(n1363_1));
  DFCNQD1HVT cram_reading_int_d4_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(cram_reading_int_d3_5), .Q(cram_reading));
  INVD1HVT U434_C4_MP_INV (.I(cram_clr_2), .ZN(cram_clr_1));
  BUFFD1HVT OPTHOLD_G_515 (.I(flencnt864_3), .Z(flencnt864_31));
  BUFFD1HVT OPTHOLD_G_950 (.I(auxcnt787_0), .Z(auxcnt787_3));
  BUFFD1HVT OPTHOLD_G_504 (.I(flencnt864_50), .Z(flencnt864_20));
  BUFFD1HVT OPTHOLD_G_121 (.I(auxcnt_0_), .Z(auxcnt_0_2));
  INVD4HVT BL1_R_INV_30 (.I(n1366_1), .ZN(n1366));
  BUFFD1HVT OPTHOLD_G_176 (.I(flencnt_0_3), .Z(flencnt_0_2));
  MUX2D1HVT U570_C4 (.I0(fnumcnt942_3), .I1(framenum_3_2), .S(n1310), 
     .Z(fnumcnt940_3));
  EDFCND1HVT fnumcnt_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(fnumcnt940_23), .E(n941_0), .Q(fnumcnt_0_), .QN(n1288));
  BUFFD1HVT OPTHOLD_G_1104 (.I(flencnt864_18), .Z(flencnt864_35));
  BUFFD1HVT OPTHOLD_G_120 (.I(auxcnt_0_2), .Z(auxcnt_0_1));
  INVD1HVT U622_C2_MP_INV (.I(flencnt_2_), .ZN(flencnt_2_1));
  EDFCND1HVT auxcnt_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_7), .D(auxcnt787_2), 
     .E(n788_2), .Q(auxcnt_2_), .QN(n1354));
  BUFFD1HVT OPTHOLD_G_1033 (.I(cram_reading_int_reg_N13_1), 
     .Z(cram_reading_int_reg_N13_3));
  IND2D1HVT U485_C2 (.A1(n1325), .B1(n1302), .ZN(next_1_));
  EDFCND1HVT fnumcnt_reg_5_ (.CDN(rst_b_2), .CP(spi_clk_out_7), .D(fnumcnt940_8), 
     .E(n941_0), .Q(fnumcnt_5_), .QN(n1289));
  INVD1HVT U438_C4_MP_INV (.I(n1258), .ZN(n1258_1));
  NR3D1HVT U443_C2 (.A1(state_2_2), .A2(state_0_2), .A3(n1401_1), .ZN(n1258));
  INVD1HVT U619_C2_MP_INV (.I(n1318), .ZN(n1318_1));
  BUFFD1HVT OPTHOLD_G_309 (.I(cram_reading_int_d2), .Z(cram_reading_int_d2_2));
  BUFFD1HVT OPTHOLD_G_367 (.I(stwrt_fnumcnt1018_2), .Z(stwrt_fnumcnt1018_8));
  OAI21D1HVT U630_C2 (.A1(n1363_1), .A2(cram_clr_1), .B(n1364_1), .ZN(n1370));
  XNR2D1HVT U473_C1 (.A1(fnumcnt_4_), .A2(framenum_4_3), .ZN(n1294));
  BUFFD1HVT OPTHOLD_G_482 (.I(fnumcnt940_19), .Z(fnumcnt940_14));
  BUFFD1HVT OPTHOLD_G_71 (.I(n1354), .Z(n1354_1));
  EDFCND1HVT fnumcnt_reg_2_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(fnumcnt940_12), .E(n941_0), .Q(fnumcnt_2_), .QN(n1284));
  ND2D1HVT U492_C1 (.A1(n1306_3), .A2(n1305_1), .ZN(auxcnt787_1));
  OR3XD1HVT U622_C2 (.A1(n1378), .A2(flencnt_4_), .A3(flencnt_2_1), .Z(n1385));
  INR3D1HVT U437_C3 (.A1(n1427), .B1(n1401_1), .B2(n1408), .ZN(n1325));
  NR2D1HVT U507_C1 (.A1(n1394), .A2(n1393), .ZN(n1314));
  ND4D1HVT U638_C3 (.A1(flencnt_3_1), .A2(flencnt_2_1), .A3(flencnt_1_1), 
     .A4(flencnt_0_1), .ZN(n1424));
  OAI21D2HVT U498_C2 (.A1(n1396), .A2(n1313), .B(n1310_1), .ZN(n941_0));
  ND4D1HVT U494_C3 (.A1(n1354), .A2(n1308), .A3(n1306), .A4(auxcnt789_0), 
     .ZN(n788_0));
  ND4D1HVT U467_C3 (.A1(n1290), .A2(n1289), .A3(n1288), .A4(n1287), .ZN(n1402));
  BUFFD1HVT OPTHOLD_G_1120 (.I(flencnt864_15), .Z(flencnt864_47));
  OR2D1HVT U614_C1 (.A1(n1370), .A2(dummycnt711_7), .Z(dummycnt709_3));
  BUFFD1HVT OPTHOLD_G_729 (.I(cram_reading_int_1), .Z(cram_reading_int_4));
  BUFFD1HVT OPTHOLD_G_303 (.I(cram_reading_int_d1_2), .Z(cram_reading_int_d1_1));
  BUFFD1HVT OPTHOLD_G_297 (.I(smc_row_inc_en_3), .Z(smc_row_inc_en_1));
  EDFCND1HVT stwrt_fnumcnt_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(stwrt_fnumcnt1018_14), .E(n1019_1), .Q(stwrt_fnumcnt_6_), .QN(n1278));
  BUFFD1HVT OPTHOLD_G_937 (.I(stwrt_fnumcnt1018_13), .Z(stwrt_fnumcnt1018_21));
  OAI31D1HVT U645_C3 (.A1(n1415_1), .A2(baddr[1]), .A3(baddr[0]), .B(n1327_1), 
     .ZN(cm_banksel[0]));
  AO31D1HVT U559_C3 (.A1(n1415), .A2(baddr[1]), .A3(baddr[0]), .B(n1327), 
     .Z(cm_banksel[3]));
  OAI211D1HVT U528_C3 (.A1(n1395), .A2(n1307), .B(U532_N8), .C(U528_N5), 
     .ZN(n1323));
  NR2D1HVT U556_C1 (.A1(n1367), .A2(dummycnt_0_), .ZN(n1324));
  AOI21D1HVT U533_C1 (.A1(dummycnt_3_2), .A2(cram_rd_2), .B(n1353_1), 
     .ZN(U533_N3));
  AN4D1HVT U489_C3 (.A1(n1353_1), .A2(n1351), .A3(n1350), .A4(dummycnt711_0), 
     .Z(n1363));
  BUFFD1HVT OPTHOLD_G_512 (.I(flencnt864_0), .Z(flencnt864_28));
  BUFFD1HVT OPTHOLD_G_477 (.I(fnumcnt940_0), .Z(fnumcnt940_10));
  NR2D1HVT U499_C1 (.A1(n1413), .A2(n1412), .ZN(n1307));
  BUFFD1HVT OPTHOLD_G_1116 (.I(smc_rprec299), .Z(smc_rprec299_2));
  ND4D1HVT U465_C3 (.A1(n1282), .A2(n1281), .A3(n1280), .A4(n1279), .ZN(n1412));
  ND2D1HVT U440_C2 (.A1(smc_rsr_rst_1), .A2(n1307), .ZN(n1019_0));
  DFCNQD1HVT smc_wset_prec_reg (.CDN(rst_b_2), .CP(clk_b_2), .D(n1330), 
     .Q(smc_wset_prec));
  BUFFD1HVT OPTHOLD_G_379 (.I(stwrt_fnumcnt1018_23), .Z(stwrt_fnumcnt1018_15));
  DFCNQD1HVT smc_rwl_en_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), .D(n1328_2), 
     .Q(smc_rwl_en));
  BUFFD1HVT OPTHOLD_G_476 (.I(next_1_2), .Z(next_1_1));
  DFCNQD1HVT cram_reading_int_d1_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(cram_reading_int_5), .Q(cram_reading_int_d1));
  NR2D1HVT U520_C1 (.A1(cram_rd_3), .A2(cram_clr_2), .ZN(n1319));
  OR2D1HVT U616_C1 (.A1(n1370), .A2(dummycnt711_5), .Z(dummycnt709_0));
  BUFFD1HVT OPTHOLD_G_1035 (.I(next_0_), .Z(next_0_2));
  EDFCND1HVT dummycnt_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(dummycnt709_4), .E(n710_0), .Q(dummycnt_1_), .QN(n1353));
  BUFFD1HVT OPTHOLD_G_1124 (.I(flencnt864_10), .Z(flencnt864_51));
  AO21D1HVT U527_C2 (.A1(n1330), .A2(cram_rd_1), .B(n1323), 
     .Z(smc_row_inc_en287));
  NR2D1HVT U561_C1 (.A1(n1322), .A2(cram_clr_2), .ZN(n1329));
  BUFFD1HVT OPTHOLD_G_372 (.I(stwrt_fnumcnt1018_20), .Z(stwrt_fnumcnt1018_12));
  OR2D1HVT U615_C1 (.A1(n1370), .A2(dummycnt711_6), .Z(dummycnt709_2));
  OAI22D1HVT U642_C4 (.A1(cram_wrt_2), .A2(cram_rd_1), .B1(state_0_1), 
     .B2(n1363), .ZN(n1428));
  INVD1HVT U629_C3_MP_INV (.I(n1301_2), .ZN(n1301_1));
  MOAI22D1HVT U628_C4 (.A1(n1395), .A2(n1301), .B1(n1326), .B2(cram_wrt_1), 
     .ZN(n1411));
  NR2D1HVT U505_C1 (.A1(n1410), .A2(n1300), .ZN(n1311));
  BUFFD1HVT OPTHOLD_G_362 (.I(n1304), .Z(n1304_1));
  INVD1HVT U627_C2_MP_INV (.I(state_2_2), .ZN(state_2_1));
  EDFCND1HVT stwrt_fnumcnt_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(stwrt_fnumcnt1018_10), .E(n1019_1), .Q(stwrt_fnumcnt_1_), .QN(n1281));
  MUX2D1HVT U546_C4 (.I0(stwrt_fnumcnt1020_0), .I1(start_framenum_0_1), 
     .S(Iconfig_top_CRAM_SMC_smc_rsr_rst_4), .Z(stwrt_fnumcnt1018_0));
  BUFFD1HVT OPTHOLD_G_127 (.I(cram_reading_int), .Z(cram_reading_int_2));
  BUFFD1HVT OPTHOLD_G_1109 (.I(smc_row_inc_en287), .Z(smc_row_inc_en287_1));
  EDFCNQD1HVT smc_wdis_dclk_reg (.CDN(rst_b_2), .CP(clk_b_2), .D(n1329), 
     .E(n_472), .Q(smc_wdis_dclk));
  DFCNQD1HVT smc_rpull_b_reg (.CDN(rst_b_2), .CP(clk_b_2), .D(smc_rpull_b508), 
     .Q(smc_rpull_b));
  BUFFD1HVT OPTHOLD_G_1101 (.I(flencnt864_12), .Z(flencnt864_32));
  CKBD3HVT BL1_BUF62 (.I(rst_b), .Z(rst_b_1));
  XNR2D1HVT U457_C1 (.A1(flencnt_1_), .A2(framelen_1_3), .ZN(n1269));
  ND4D1HVT U459_C3 (.A1(n1274), .A2(n1273), .A3(n1272), .A4(n1271), .ZN(n1397));
  ND4D1HVT U449_C3 (.A1(n1266), .A2(n1265), .A3(n1264), .A4(n1263), .ZN(n1399));
  DFCNQD1HVT flencnt_reg_5_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_49), .Q(flencnt_5_));
  XNR2D1HVT U448_C1 (.A1(flencnt_5_), .A2(framelen_5_3), .ZN(n1262));
  XNR2D1HVT U456_C1 (.A1(flencnt_3_2), .A2(framelen_3_3), .ZN(n1268));
  OA221D1HVT U549_C1 (.A1(cram_rd_1), .A2(cor_security_rddis), .B1(cram_wrt_1), 
     .B2(cor_security_wrtdis), .C(cram_clr_1), .Z(U549_N3));
  NR2D1HVT U562_C1 (.A1(n1387), .A2(flencnt_1_1), .ZN(n1330));
  AO31D1HVT U629_C3 (.A1(n1301_1), .A2(cram_wrt_1), .A3(cram_clr_3), .B(n1376), 
     .Z(n1364));
  IND2D1HVT U487_C2 (.A1(n1376), .B1(n1303), .ZN(next_0_));
  DFCNQD1HVT flencnt_reg_15_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_22), .Q(flencnt_15_));
  BUFFD1HVT OPTHOLD_G_1103 (.I(flencnt864_11), .Z(flencnt864_34));
  OR4XD1HVT U633_C3 (.A1(flencnt_7_), .A2(flencnt_12_), .A3(flencnt_11_), 
     .A4(U633_N5), .Z(n1380));
  BUFFD1HVT OPTHOLD_G_500 (.I(flencnt864_32), .Z(flencnt864_16));
  DFCNQD1HVT flencnt_reg_14_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_44), .Q(flencnt_14_));
  BUFFD1HVT OPTHOLD_G_1076 (.I(fnumcnt940_7), .Z(fnumcnt940_22));
  BUFFD1HVT OPTHOLD_G_1111 (.I(flencnt864_19), .Z(flencnt864_41));
  BUFFD1HVT OPTHOLD_G_509 (.I(flencnt864_36), .Z(flencnt864_25));
  BUFFD1HVT OPTHOLD_G_479 (.I(fnumcnt940_17), .Z(fnumcnt940_12));
  XNR2D1HVT U455_C1 (.A1(flencnt_11_), .A2(flen[11]), .ZN(n1267));
  XNR2D1HVT U450_C1 (.A1(flencnt_8_), .A2(flen[8]), .ZN(n1263));
  BUFFD1HVT OPTHOLD_G_878 (.I(cram_reading_int_d1), .Z(cram_reading_int_d1_5));
  BUFFD1HVT OPTHOLD_G_696 (.I(n1350), .Z(n1350_1));
  MOAI22D1HVT U643_C4 (.A1(n1395), .A2(n1373_2), .B1(n1317), .B2(cram_rd_2), 
     .ZN(n1375));
  INVD4HVT BL1_R_INV_31 (.I(n1306_2), .ZN(n1306));
  BUFFD1HVT OPTHOLD_G_85 (.I(n1401), .Z(n1401_1));
  MUX2D1HVT U571_C4 (.I0(fnumcnt942_2), .I1(framenum_2_2), .S(n1310), 
     .Z(fnumcnt940_2));
  XNR2D1HVT U476_C1 (.A1(fnumcnt_2_), .A2(framenum_2_3), .ZN(n1296));
  DFCNQD1HVT flencnt_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(flencnt864_26), .Q(flencnt_1_));
  NR4D1HVT U621_C3_INV (.A1(n1378), .A2(flencnt_4_), .A3(flencnt_3_2), 
     .A4(flencnt_2_), .ZN(n1366_1));
  MUX2D1HVT U578_C4 (.I0(framelen_12_2), .I1(flencnt865_12), .S(n1429), 
     .Z(flencnt864_12));
  EDFCND1HVT fnumcnt_reg_3_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(fnumcnt940_14), .E(n941_0), .Q(fnumcnt_3_), .QN(n1290));
  DFCNQD1HVT flencnt_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(flencnt864_31), .Q(flencnt_3_));
  XNR2D1HVT U462_C1 (.A1(flencnt_7_), .A2(framelen_7_3), .ZN(n1273));
  INVD1HVT U528_C2_MP_INV (.I(flencnt_3_2), .ZN(flencnt_3_1));
  ND2D1HVT U490_C1 (.A1(n1306_3), .A2(n1304_1), .ZN(auxcnt787_2));
  EDFCND1HVT fnumcnt_reg_7_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(fnumcnt940_13), .E(n941_0), .Q(fnumcnt_7_), .QN(n1285));
  INVD1HVT U525_C1_MP_INV (.I(n1306), .ZN(n1306_1));
  BUFFD1HVT OPTHOLD_G_718 (.I(n1306), .Z(n1306_3));
  BUFFD1HVT OPTHOLD_G_485 (.I(fnumcnt940_18), .Z(fnumcnt940_15));
  BUFFD1HVT OPTHOLD_G_86 (.I(state_0_), .Z(state_0_2));
  BUFFD1HVT OPTHOLD_G_1130 (.I(n1373), .Z(n1373_2));
  NR2D1HVT U563_C1 (.A1(n1423), .A2(n1314), .ZN(n1331));
  ND3D1HVT U636_C2 (.A1(flencnt_1_), .A2(flencnt_0_), .A3(cram_wrt_3), 
     .ZN(n1365));
  OR3XD1HVT U612_C2 (.A1(n1364), .A2(n1363_1), .A3(cram_clr_3), .Z(n710_0));
  NR3D1HVT U605_C3 (.A1(n1371), .A2(n1314), .A3(cram_wrt_1), 
     .ZN(data_muxsel1496));
  ND4D1HVT U444_C3 (.A1(n1262), .A2(n1261), .A3(n1260), .A4(n1259), .ZN(n1400));
  BUFFD1HVT OPTHOLD_G_1114 (.I(flencnt864_17), .Z(flencnt864_44));
  EDFCND1HVT fnumcnt_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(fnumcnt940_20), .E(n941_0), .Q(fnumcnt_1_), .QN(n1283));
  cram_smc_DW01_dec_8_1 sub_464 (.A({fnumcnt_7_, fnumcnt_6_, fnumcnt_5_, 
     fnumcnt_4_, fnumcnt_3_, fnumcnt_2_, fnumcnt_1_, fnumcnt_0_}), .SUM({
     fnumcnt942_7, fnumcnt942_6, fnumcnt942_5, fnumcnt942_4, fnumcnt942_3, 
     fnumcnt942_2, fnumcnt942_1, fnumcnt942_0}));
  BUFFD1HVT OPTHOLD_G_302 (.I(cram_reading_int_d3_4), .Z(cram_reading_int_d3_2));
  NR2XD2HVT U641_C1 (.A1(n1411), .A2(n1306_1), .ZN(n1429));
  MUX2D1HVT U572_C4 (.I0(fnumcnt942_5), .I1(framenum_5_2), .S(n1310), 
     .Z(fnumcnt940_5));
  BUFFD1HVT OPTHOLD_G_691 (.I(flencnt_3_), .Z(flencnt_3_2));
  BUFFD1HVT OPTHOLD_G_626 (.I(cram_wrt_2), .Z(cram_wrt_3));
  ND2D1HVT U639_C1 (.A1(flencnt_1_), .A2(flencnt_0_3), .ZN(U639_N3));
  BUFFD1HVT OPTHOLD_G_879 (.I(cram_reading_int_3), .Z(cram_reading_int_5));
  OR2D1HVT U623_C1 (.A1(n1385), .A2(flencnt_0_3), .Z(n1386));
  BUFFD1HVT OPTHOLD_G_1115 (.I(dummycnt709_1), .Z(dummycnt709_5));
  BUFFD1HVT OPTHOLD_G_578 (.I(cram_reading_int_d1_3), .Z(cram_reading_int_d1_4));
  EDFCND1HVT stwrt_fnumcnt_reg_7_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(stwrt_fnumcnt1018_15), .E(n1019_1), .Q(stwrt_fnumcnt_7_), .QN(n1280));
  BUFFD1HVT OPTHOLD_G_471 (.I(n1328), .Z(n1328_1));
  BUFFD1HVT OPTHOLD_G_564 (.I(smc_row_inc_en_2), .Z(smc_row_inc_en_3));
  MUX2D1HVT U540_C4 (.I0(stwrt_fnumcnt1020_6), .I1(start_framenum_6_2), 
     .S(Iconfig_top_CRAM_SMC_smc_rsr_rst_4), .Z(stwrt_fnumcnt1018_6));
  OA21D1HVT U529_C3 (.A1(cram_clr_2), .A2(cor_en_8bconfig), .B(n1415), .Z(n1327));
  AO31D1HVT U646_C3 (.A1(n1415), .A2(baddr[1]), .A3(baddr_0_1), .B(n1327), 
     .Z(cm_banksel[2]));
  INVD1HVT U645_C3_MP_INV_1 (.I(n1327), .ZN(n1327_1));
  BUFFD1HVT OPTHOLD_G_370 (.I(stwrt_fnumcnt1018_3), .Z(stwrt_fnumcnt1018_11));
  IAO21D1HVT U533_C3 (.A1(dummycnt_3_), .A2(n1300), .B(dummycnt_1_2), 
     .ZN(U533_N6));
  BUFFD1HVT OPTHOLD_G_711 (.I(dummycnt711_0), .Z(dummycnt711_4));
  OA21D1HVT cram_reading_int_reg_C9 (.A1(n1373_1), .A2(cram_reading_int_4), 
     .B(n1316), .Z(cram_reading_int_reg_N13));
  DFCNQD1HVT cram_reading_int_d3_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(cram_reading_int_d2_4), .Q(cram_reading_int_d3));
  INVD1HVT U440_C2_MP_INV (.I(Iconfig_top_CRAM_SMC_smc_rsr_rst_5), 
     .ZN(smc_rsr_rst_1));
  MUX2D1HVT U543_C4 (.I0(stwrt_fnumcnt1020_3), .I1(start_framenum_3_1), 
     .S(Iconfig_top_CRAM_SMC_smc_rsr_rst_5), .Z(stwrt_fnumcnt1018_3));
  MUX2D1HVT U542_C4 (.I0(stwrt_fnumcnt1020_4), .I1(start_framenum_4_2), 
     .S(Iconfig_top_CRAM_SMC_smc_rsr_rst_4), .Z(stwrt_fnumcnt1018_4));
  ND4D1HVT U464_C3 (.A1(n1278), .A2(n1277), .A3(n1276), .A4(n1275), .ZN(n1413));
  DFCNQD1HVT smc_rsr_rst_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(smc_rsr_rst281_1), .Q(smc_rsr_rst));
  DFCNQD1HVT smc_wwlwrt_en_reg (.CDN(rst_b_2), .CP(clk_b_2), .D(n1322_1), 
     .Q(smc_wwlwrt_en));
  BUFFD1HVT OPTHOLD_G_516 (.I(dummycnt709_5), .Z(dummycnt709_4));
  BUFFD1HVT OPTHOLD_G_1112 (.I(flencnt864_4), .Z(flencnt864_42));
  DFCNQD1HVT data_muxsel1_reg (.CDN(rst_b_2), .CP(clk_b_2), .D(data_muxsel1496), 
     .Q(data_muxsel1));
  DFCNQD1HVT smc_rprec_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(smc_rprec299_3), .Q(smc_rprec));
  BUFFD1HVT OPTHOLD_G_693 (.I(n1353), .Z(n1353_1));
  BUFFD1HVT OPTHOLD_G_936 (.I(stwrt_fnumcnt1018_4), .Z(stwrt_fnumcnt1018_20));
  AO31D1HVT U522_C3 (.A1(n1321), .A2(dummycnt_3_1), .A3(dummycnt_2_1), .B(n1320), 
     .Z(n1328));
  BUFFD1HVT OPTHOLD_G_945 (.I(stwrt_fnumcnt1018_6), .Z(stwrt_fnumcnt1018_22));
  OR4XD1HVT U532_C3 (.A1(n1350_1), .A2(dummycnt711_4), .A3(U533_N6), 
     .A4(U533_N3), .Z(U532_N8));
  ND3D1HVT U511_C2 (.A1(n1351), .A2(n1350), .A3(dummycnt_1_), .ZN(n1367));
  BUFFD1HVT OPTHOLD_G_369 (.I(stwrt_fnumcnt1018_17), .Z(stwrt_fnumcnt1018_10));
  BUFFD1HVT OPTHOLD_G_1067 (.I(next_1_), .Z(next_1_2));
  EDFCND1HVT dummycnt_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(dummycnt709_2), .E(n710_0), .Q(dummycnt_2_), .QN(n1350));
  ND2D1HVT U525_C1 (.A1(n1306_1), .A2(cram_wrt_3), .ZN(n1322));
  BUFFD1HVT OPTHOLD_G_1108 (.I(flencnt864_23), .Z(flencnt864_39));
  AOI31D1HVT U488_C3 (.A1(state_2_1), .A2(n1428), .A3(n1401_1), .B(n1325), 
     .ZN(n1303));
  OR3XD1HVT U483_C2 (.A1(state_2_2), .A2(state_1_1), .A3(state_0_2), .Z(n1301));
  BUFFD1HVT OPTHOLD_G_508 (.I(flencnt864_48), .Z(flencnt864_24));
  BUFFD1HVT OPTHOLD_G_514 (.I(flencnt864_45), .Z(flencnt864_30));
  XNR2D1HVT U475_C1 (.A1(fnumcnt_6_), .A2(framenum_6_3), .ZN(n1295));
  BUFFD1HVT OPTHOLD_G_168 (.I(n1410), .Z(n1410_1));
  BUFFD1HVT OPTHOLD_G_694 (.I(n1301), .Z(n1301_2));
  EDFCND1HVT stwrt_fnumcnt_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(stwrt_fnumcnt1018_9), .E(n1019_1), .Q(stwrt_fnumcnt_0_), .QN(n1277));
  INVD1HVT smc_wwlwrt_en_reg_MP_INV (.I(n1322), .ZN(n1322_1));
  BUFFD1HVT OPTHOLD_G_454 (.I(next_0_2), .Z(next_0_1));
  BUFFD1HVT OPTHOLD_G_1102 (.I(flencnt864_16), .Z(flencnt864_33));
  DFCNQD1HVT flencnt_reg_2_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_30), .Q(flencnt_2_));
  DFCNQD1HVT flencnt_reg_4_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_29), .Q(flencnt_4_));
  MUX2D1HVT U588_C4 (.I0(framelen_6_2), .I1(flencnt865_6), .S(n1429), 
     .Z(flencnt864_6));
  BUFFD1HVT OPTHOLD_G_473 (.I(next_2_), .Z(next_2_1));
  BUFFD1HVT OPTHOLD_G_360 (.I(n1305), .Z(n1305_1));
  MUX2D1HVT U590_C4 (.I0(framelen_4_2), .I1(flencnt865_4), .S(n1429), 
     .Z(flencnt864_4));
  XNR2D1HVT U451_C1 (.A1(flencnt_4_), .A2(framelen_4_3), .ZN(n1264));
  BUFFD1HVT OPTHOLD_G_305 (.I(cram_reading_int_d1_5), .Z(cram_reading_int_d1_3));
  DFCNQD1HVT state_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_12), .D(next_0_3), 
     .Q(state_0_));
  NR3D1HVT U557_C2 (.A1(state_1_1), .A2(n1408), .A3(n1363_1), .ZN(n1326));
  OAI222D1HVT U479_C2 (.A1(n1310_1), .A2(cram_rd_1), .B1(n1364_1), .B2(n1300), 
     .C1(n1396), .C2(U480_N3), .ZN(smc_rsr_rst281));
  MUX2D1HVT U582_C4 (.I0(framelen_8_2), .I1(flencnt865_8), .S(n1429), 
     .Z(flencnt864_8));
  DFCNQD1HVT flencnt_reg_12_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_33), .Q(flencnt_12_));
  BUFFD1HVT OPTHOLD_G_1071 (.I(fnumcnt940_5), .Z(fnumcnt940_21));
  MUX2D1HVT U583_C4 (.I0(framelen_9_2), .I1(flencnt865_9), .S(n1429), 
     .Z(flencnt864_9));
  DFCNQD1HVT flencnt_reg_10_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_21), .Q(flencnt_10_));
  BUFFD1HVT OPTHOLD_G_507 (.I(flencnt864_38), .Z(flencnt864_23));
  BUFFD1HVT OPTHOLD_G_1069 (.I(fnumcnt940_3), .Z(fnumcnt940_19));
  MUX2D1HVT U575_C4 (.I0(framelen_15_2), .I1(flencnt865_15), .S(n1429), 
     .Z(flencnt864_15));
  BUFFD1HVT OPTHOLD_G_1036 (.I(next_0_1), .Z(next_0_3));
  MUX2D1HVT U581_C4 (.I0(framelen_7_2), .I1(flencnt865_7), .S(n1429), 
     .Z(flencnt864_7));
  XNR2D1HVT U460_C1 (.A1(flencnt_12_), .A2(framelen_12_3), .ZN(n1271));
  XNR2D1HVT U452_C1 (.A1(flencnt_10_), .A2(framelen_10_3), .ZN(n1265));
  BUFFD1HVT OPTHOLD_G_1058 (.I(cram_clk_en_i), .Z(cram_clk_en_i_1));
  BUFFD1HVT OPTHOLD_G_1117 (.I(smc_rprec299_1), .Z(smc_rprec299_3));
  INVD1HVT U479_C2_MP_INV (.I(n1364), .ZN(n1364_1));
  MUX2D1HVT U573_C4 (.I0(fnumcnt942_1), .I1(framenum_1_2), .S(n1310), 
     .Z(fnumcnt940_1));
  BUFFD4HVT BW1_BUF4211 (.I(rst_b_1), .Z(rst_b_2));
  ND4D1HVT U466_C3 (.A1(n1286), .A2(n1285), .A3(n1284), .A4(n1283), .ZN(n1403));
  BUFFD1HVT OPTHOLD_G_1128 (.I(dummycnt_3_), .Z(dummycnt_3_2));
  EDFCND1HVT auxcnt_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_7), .D(auxcnt787_3), 
     .E(n788_2), .Q(auxcnt_0_), .QN(auxcnt789_0));
  MUX2D1HVT U589_C4 (.I0(framelen_3_2), .I1(flencnt865_3), .S(n1429), 
     .Z(flencnt864_3));
  MUX2D1HVT U569_C4 (.I0(fnumcnt942_4), .I1(framenum_4_2), .S(n1310), 
     .Z(fnumcnt940_4));
  EDFCND1HVT fnumcnt_reg_4_ (.CDN(rst_b_2), .CP(spi_clk_out_7), 
     .D(fnumcnt940_15), .E(n941_0), .Q(fnumcnt_4_), .QN(n1286));
  XNR2D1HVT U453_C1 (.A1(flencnt_14_), .A2(flen[14]), .ZN(n1266));
  ND4D1HVT U500_C3 (.A1(n1308), .A2(cram_wrt_3), .A3(auxcnt_2_), 
     .A4(auxcnt789_0), .ZN(n1423));
  ND2D1HVT U442_C1 (.A1(n1313), .A2(n1306_1), .ZN(n1427));
  BUFFD1HVT OPTHOLD_G_505 (.I(flencnt864_51), .Z(flencnt864_21));
  AOI31D1HVT U486_C3 (.A1(n1427), .A2(n1258), .A3(cram_wrt_2), .B(n1411), 
     .ZN(n1302));
  BUFFD1HVT OPTHOLD_G_126 (.I(cram_reading_int_2), .Z(cram_reading_int_1));
  DFCND1HVT state_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_7), .D(next_1_1), 
     .Q(state_1_), .QN(n1401));
  BUFFD1HVT OPTHOLD_G_692 (.I(flencnt_0_), .Z(flencnt_0_3));
  INVD1HVT U498_C2_MP_INV (.I(n1310), .ZN(n1310_1));
  INVD1HVT U562_C1_MP_INV (.I(flencnt_1_), .ZN(flencnt_1_1));
  BUFFD1HVT OPTHOLD_G_935 (.I(stwrt_fnumcnt1018_8), .Z(stwrt_fnumcnt1018_19));
  MOAI22D1HVT U617_C4 (.A1(n1373), .A2(cram_rd_1), .B1(n1318_1), .B2(n1317), 
     .ZN(data_muxsel502));
  INVD2HVT U527_C2_MP_INV (.I(cram_rd_2), .ZN(cram_rd_1));
  cram_smc_DW01_dec_8_0 sub_476 (.A({stwrt_fnumcnt_7_, stwrt_fnumcnt_6_, 
     stwrt_fnumcnt_5_, stwrt_fnumcnt_4_, stwrt_fnumcnt_3_, stwrt_fnumcnt_2_, 
     stwrt_fnumcnt_1_, stwrt_fnumcnt_0_}), .SUM({stwrt_fnumcnt1020_7, 
     stwrt_fnumcnt1020_6, stwrt_fnumcnt1020_5, stwrt_fnumcnt1020_4, 
     stwrt_fnumcnt1020_3, stwrt_fnumcnt1020_2, stwrt_fnumcnt1020_1, 
     stwrt_fnumcnt1020_0}));
  OR4XD1HVT U620_C3 (.A1(n1380), .A2(n1379), .A3(flencnt_6_), .A4(flencnt_5_), 
     .Z(n1378));
  MUX2D1HVT U580_C4 (.I0(framelen_5_2), .I1(flencnt865_5), .S(n1429), 
     .Z(flencnt864_5));
  BUFFD1HVT OPTHOLD_G_301 (.I(cram_reading_int_d3_2), .Z(cram_reading_int_d3_1));
  XNR2D1HVT U477_C1 (.A1(fnumcnt_1_), .A2(framenum_1_3), .ZN(n1297));
  BUFFD1HVT OPTHOLD_G_308 (.I(cram_reading_int_d2_5), .Z(cram_reading_int_d2_1));
  BUFFD1HVT OPTHOLD_G_506 (.I(flencnt864_47), .Z(flencnt864_22));
  XNR2D1HVT U478_C1 (.A1(fnumcnt_5_), .A2(framenum_5_3), .ZN(n1298));
  OR3XD1HVT U624_C2 (.A1(n1386), .A2(flencnt_3_2), .A3(cram_wrt_1), .Z(n1387));
  OAI32D2HVT U501_C2 (.A1(n1424), .A2(n1378), .A3(U435_N5), .B1(n1310_1), 
     .B2(cram_rd_1), .ZN(smc_rprec299));
  NR2D1HVT U531_C1 (.A1(auxcnt_1_1), .A2(auxcnt_0_1), .ZN(n1355));
  ND3D1HVT U521_C2 (.A1(n1354), .A2(auxcnt_1_), .A3(auxcnt_0_), .ZN(n1371));
  BUFFD1HVT OPTHOLD_G_933 (.I(stwrt_fnumcnt1018_1), .Z(stwrt_fnumcnt1018_17));
  DFCNQD1HVT smc_wcram_rst_reg (.CDN(rst_b_2), .CP(clk_b_2), 
     .D(smc_wcram_rst532), .Q(smc_wcram_rst));
  BUFFD1HVT OPTHOLD_G_520 (.I(dummycnt_0_), .Z(dummycnt_0_1));
  BUFFD1HVT OPTHOLD_G_574 (.I(cram_reading_int_d3_1), .Z(cram_reading_int_d3_3));
  BUFFD1HVT OPTHOLD_G_499 (.I(smc_rprec299_2), .Z(smc_rprec299_1));
  MUX2D1HVT U539_C4 (.I0(stwrt_fnumcnt1020_7), .I1(start_framenum_7_2), 
     .S(Iconfig_top_CRAM_SMC_smc_rsr_rst_4), .Z(stwrt_fnumcnt1018_7));
  OR2D1HVT U611_C1 (.A1(n1415), .A2(cram_reading_1), .Z(cram_clk_en_i));
  OAI31D1HVT U558_C3 (.A1(n1415_1), .A2(baddr[1]), .A3(baddr_0_1), .B(n1327_1), 
     .ZN(cm_banksel[1]));
  CKND1HVT U558_C3_MP_INV (.I(baddr[0]), .ZN(baddr_0_1));
  CKAN2D1HVT U436_C2 (.A1(n1363), .A2(cm_last_rsr), .Z(n1312));
  AO221D1HVT U439_C4 (.A1(dummycnt_1_1), .A2(dummycnt_0_1), .B1(n1353_1), 
     .B2(dummycnt711_4), .C(n1370), .Z(dummycnt709_1));
  DFCNQD1HVT smc_row_inc_en_reg (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(smc_row_inc_en287_1), .Q(smc_row_inc_en));
  CKAN2D1HVT U433_C1 (.A1(n1353_1), .A2(dummycnt711_0), .Z(n1257));
  BUFFD1HVT OPTHOLD_G_1121 (.I(flencnt864_5), .Z(flencnt864_48));
  BUFFD1HVT OPTHOLD_G_510 (.I(flencnt864_1), .Z(flencnt864_26));
  BUFFD1HVT OPTHOLD_G_545 (.I(dummycnt_2_), .Z(dummycnt_2_1));
  BUFFD1HVT OPTHOLD_G_603 (.I(n1019_0), .Z(n1019_1));
  EDFCND1HVT stwrt_fnumcnt_reg_4_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(stwrt_fnumcnt1018_12), .E(n1019_1), .Q(stwrt_fnumcnt_4_), .QN(n1279));
  DFCNQD1HVT data_muxsel_reg (.CDN(rst_b_2), .CP(clk_b_2), .D(data_muxsel502), 
     .Q(data_muxsel));
  CKLNQD6HVT CM_ROW_INC (.CP(spi_clk_out_12), .E(smc_row_inc_en_1), 
     .Q(smc_row_inc), .TE(VSS_magmatienet_0));
  BUFFD1HVT OPTHOLD_G_378 (.I(stwrt_fnumcnt1018_22), .Z(stwrt_fnumcnt1018_14));
  ND2D1HVT U530_C1 (.A1(n1350_1), .A2(n1257), .ZN(n1352));
  EDFCND1HVT dummycnt_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(dummycnt709_3), .E(n710_0), .Q(dummycnt_3_), .QN(n1351));
  BUFFD1HVT OPTHOLD_G_1032 (.I(cram_reading_int_reg_N13), 
     .Z(cram_reading_int_reg_N13_2));
  BUFFD1HVT OPTHOLD_G_304 (.I(cram_reading_int_d1_4), .Z(cram_reading_int_d1_2));
  EDFCND1HVT dummycnt_reg_0_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(dummycnt709_0), .E(n710_0), .Q(dummycnt_0_), .QN(dummycnt711_0));
  MOAI22D1HVT U618_C4 (.A1(n1374), .A2(n1366), .B1(n1324), .B2(cram_rd_3), 
     .ZN(smc_rpull_b508));
  BUFFD1HVT OPTHOLD_G_1047 (.I(n1328_1), .Z(n1328_2));
  BUFFD1HVT OPTHOLD_G_919 (.I(dummycnt711_3), .Z(dummycnt711_7));
  BUFFD1HVT OPTHOLD_G_849 (.I(state_1_), .Z(state_1_1));
  BUFFD1HVT OPTHOLD_G_948 (.I(stwrt_fnumcnt1018_7), .Z(stwrt_fnumcnt1018_23));
  BUFFD1HVT OPTHOLD_G_659 (.I(cram_rd_2), .Z(cram_rd_3));
  XNR2D1HVT U609_C1 (.A1(n1350_1), .A2(n1257), .ZN(dummycnt711_2));
  BUFFD1HVT OPTHOLD_G_731 (.I(auxcnt_1_), .Z(auxcnt_1_1));
  BUFFD1HVT OPTHOLD_G_526 (.I(dummycnt_1_), .Z(dummycnt_1_1));
  BUFFD1HVT OPTHOLD_G_643 (.I(n788_1), .Z(n788_2));
  AOI21D4HVT U502_C2 (.A1(cram_wrt_1), .A2(cram_rd_1), .B(n1301_2), .ZN(n1310));
  OAI32D2HVT U434_C4 (.A1(n1410_1), .A2(n1312), .A3(cram_clr_1), .B1(n1301_2), 
     .B2(n1300), .ZN(next_2_));
  ND2D1HVT U625_C1 (.A1(cram_wrt_2), .A2(cram_rd_1), .ZN(n1395));
  ND2D1HVT U517_C1 (.A1(n1313_1), .A2(cram_rd_2), .ZN(n1318));
  MUX2D1HVT U537_C4 (.I0(fnumcnt942_6), .I1(framenum_6_2), .S(n1310), 
     .Z(fnumcnt940_6));
  MUX2D1HVT U536_C4 (.I0(fnumcnt942_7), .I1(framenum_7_2), .S(n1310), 
     .Z(fnumcnt940_7));
  BUFFD1HVT OPTHOLD_G_1129 (.I(dummycnt_1_), .Z(dummycnt_1_2));
  BUFFD1HVT OPTHOLD_G_163 (.I(dummycnt_3_), .Z(dummycnt_3_1));
  BUFFD1HVT OPTHOLD_G_1118 (.I(flencnt864_2), .Z(flencnt864_45));
  OR3XD1HVT U633_C2 (.A1(flencnt_9_), .A2(flencnt_15_), .A3(flencnt_10_), 
     .Z(U633_N5));
  BUFFD1HVT OPTHOLD_G_1107 (.I(flencnt864_7), .Z(flencnt864_38));
  BUFFD1HVT OPTHOLD_G_1105 (.I(flencnt864_9), .Z(flencnt864_36));
  XNR2D1HVT U463_C1 (.A1(flencnt_15_), .A2(framelen_15_3), .ZN(n1274));
  BUFFD1HVT OPTHOLD_G_32 (.I(n788_0), .Z(n788_1));
  MUX2D1HVT U587_C4 (.I0(framelen_2_2), .I1(flencnt865_2), .S(n1429), 
     .Z(flencnt864_2));
  BUFFD1HVT OPTHOLD_G_1077 (.I(fnumcnt940_10), .Z(fnumcnt940_23));
  XNR2D1HVT U445_C1 (.A1(flencnt_6_), .A2(framelen_6_3), .ZN(n1259));
  ND4D1HVT U474_C3 (.A1(n1298), .A2(n1297), .A3(n1296), .A4(n1295), .ZN(n1393));
  ND3D1HVT U627_C2 (.A1(state_2_1), .A2(state_0_2), .A3(cram_rd_2), .ZN(n1408));
  AO21D1HVT U619_C2 (.A1(n1318_1), .A2(n1306_1), .B(n1326), 
     .Z(smc_rrst_pullwlen514));
  OAI21D1HVT U513_C2 (.A1(n1317), .A2(cram_rd_1), .B(n1318), .ZN(n1316));
  MUX2D1HVT U577_C4 (.I0(framelen_13_2), .I1(flencnt865_13), .S(n1429), 
     .Z(flencnt864_13));
  ND2D1HVT U495_C1 (.A1(n1306_3), .A2(auxcnt_0_1), .ZN(auxcnt787_0));
  BUFFD1HVT OPTHOLD_G_474 (.I(fnumcnt940_21), .Z(fnumcnt940_8));
  BUFFD1HVT OPTHOLD_G_501 (.I(flencnt864_43), .Z(flencnt864_17));
  DFCNQD1HVT flencnt_reg_8_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_41), .Q(flencnt_8_));
  BUFFD1HVT OPTHOLD_G_1106 (.I(flencnt864_25), .Z(flencnt864_37));
  BUFFD1HVT OPTHOLD_G_1119 (.I(flencnt864_6), .Z(flencnt864_46));
  MUX2D1HVT U579_C4 (.I0(framelen_11_2), .I1(flencnt865_11), .S(n1429), 
     .Z(flencnt864_11));
  BUFFD1HVT OPTHOLD_G_1110 (.I(flencnt864_8), .Z(flencnt864_40));
  BUFFD1HVT OPTHOLD_G_951 (.I(auxcnt787_1), .Z(auxcnt787_4));
  BUFFD1HVT OPTHOLD_G_1122 (.I(flencnt864_24), .Z(flencnt864_49));
  OR3XD1HVT U634_C2 (.A1(flencnt_8_), .A2(flencnt_14_), .A3(flencnt_13_), 
     .Z(n1379));
  ND3D1HVT U637_C2 (.A1(n1318_1), .A2(flencnt_1_), .A3(flencnt_0_1), .ZN(n1374));
  EDFCND1HVT stwrt_fnumcnt_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_12), 
     .D(stwrt_fnumcnt1018_19), .E(n1019_1), .Q(stwrt_fnumcnt_2_), .QN(n1282));
  MUX2D1HVT U586_C4 (.I0(framelen_1_2), .I1(flencnt865_1), .S(n1429), 
     .Z(flencnt864_1));
  MUX2D1HVT U544_C4 (.I0(stwrt_fnumcnt1020_2), .I1(start_framenum_2_2), 
     .S(Iconfig_top_CRAM_SMC_smc_rsr_rst_4), .Z(stwrt_fnumcnt1018_2));
  BUFFD1HVT OPTHOLD_G_1070 (.I(fnumcnt940_9), .Z(fnumcnt940_20));
  BUFFD1HVT OPTHOLD_G_904 (.I(cram_reading_int_d3_3), .Z(cram_reading_int_d3_5));
  XNR2D1HVT U471_C1 (.A1(fnumcnt_3_), .A2(framenum_3_3), .ZN(n1292));
  NR3D1HVT U496_C2_INV (.A1(n1366), .A2(flencnt_1_), .A3(flencnt_0_3), 
     .ZN(n1306_2));
  MUX2D1HVT U584_C4 (.I0(framelen_10_2), .I1(flencnt865_10), .S(n1429), 
     .Z(flencnt864_10));
  DFCNQD1HVT flencnt_reg_0_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_28), .Q(flencnt_0_));
  EDFCND1HVT auxcnt_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_7), .D(auxcnt787_4), 
     .E(n788_2), .Q(auxcnt_1_), .QN(n1308));
  DFCNQD1HVT flencnt_reg_6_ (.CDN(rst_b_1), .CP(spi_clk_out_7), 
     .D(flencnt864_27), .Q(flencnt_6_));
  OR4XD1HVT U528_C2 (.A1(n1385), .A2(n1318), .A3(flencnt_3_1), .A4(U639_N3), 
     .Z(U528_N5));
  BUFFD1HVT OPTHOLD_G_475 (.I(fnumcnt940_1), .Z(fnumcnt940_9));
  INVD1HVT U517_C1_MP_INV (.I(n1313), .ZN(n1313_1));
  ND2D1HVT U435_C3 (.A1(n1318_1), .A2(flencnt_4_1), .ZN(U435_N5));
  INVD1HVT U638_C3_MP_INV (.I(flencnt_0_3), .ZN(flencnt_0_1));
  BUFFD1HVT OPTHOLD_G_88 (.I(state_2_), .Z(state_2_3));
  DFCNQD1HVT state_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_7), .D(next_2_1), 
     .Q(state_2_));
  INVD1HVT U519_C3_MP_INV (.I(cram_wrt_2), .ZN(cram_wrt_1));
  BUFFD1HVT BL1_BUF58 (.I(smc_read_4), .Z(cram_rd_2));
  XNR2D1HVT U470_C1 (.A1(fnumcnt_7_), .A2(framenum_7_3), .ZN(n1291));
  NR3D1HVT U515_C2 (.A1(n1366), .A2(flencnt_1_), .A3(flencnt_0_1), .ZN(n1317));
  ND3D1HVT U481_C2 (.A1(cram_wrt_1), .A2(cram_rd_1), .A3(cram_clr_3), .ZN(n1300));
endmodule

// Entity:cram_smc_DW01_dec_16_0 Model:cram_smc_DW01_dec_16_0 Library:L1
module cram_smc_DW01_dec_16_0 (A, SUM, flencnt_3_2, flencnt_0_2);
  input flencnt_3_2, flencnt_0_2;
  input [15:0] A;
  output [15:0] SUM;
  wire carry_10, carry_11, carry_12, carry_13, carry_14, carry_15, carry_2, 
     carry_3, carry_4, carry_5, carry_6, carry_7, carry_8, carry_9;
  OR2D1HVT U1_B_6_C1 (.A1(carry_6), .A2(A[6]), .Z(carry_7));
  OR2D1HVT U1_B_8_C1 (.A1(carry_8), .A2(A[8]), .Z(carry_9));
  XNR2D1HVT U1_A_14_C1 (.A1(carry_14), .A2(A[14]), .ZN(SUM[14]));
  XNR2D1HVT U1_A_11_C1 (.A1(carry_11), .A2(A[11]), .ZN(SUM[11]));
  OR2D1HVT U1_B_11_C1 (.A1(carry_11), .A2(A[11]), .Z(carry_12));
  XNR2D1HVT U1_A_10_C1 (.A1(carry_10), .A2(A[10]), .ZN(SUM[10]));
  XNR2D1HVT U1_A_12_C1 (.A1(carry_12), .A2(A[12]), .ZN(SUM[12]));
  OR2D1HVT U1_B_9_C1 (.A1(carry_9), .A2(A[9]), .Z(carry_10));
  OR2D1HVT U1_B_10_C1 (.A1(carry_10), .A2(A[10]), .Z(carry_11));
  XNR2D1HVT U1_A_13_C1 (.A1(carry_13), .A2(A[13]), .ZN(SUM[13]));
  OR2D1HVT U1_B_13_C1 (.A1(carry_13), .A2(A[13]), .Z(carry_14));
  XNR2D1HVT U1_A_9_C1 (.A1(carry_9), .A2(A[9]), .ZN(SUM[9]));
  OR2D1HVT U1_B_3_C1 (.A1(carry_3), .A2(flencnt_3_2), .Z(carry_4));
  XNR2D1HVT U1_A_4_C1 (.A1(carry_4), .A2(A[4]), .ZN(SUM[4]));
  OR2D1HVT U1_B_4_C1 (.A1(carry_4), .A2(A[4]), .Z(carry_5));
  IND2D1HVT U1_B_1_C1 (.A1(A[1]), .B1(SUM[0]), .ZN(carry_2));
  XNR2D1HVT U1_A_3_C1 (.A1(carry_3), .A2(flencnt_3_2), .ZN(SUM[3]));
  XNR2D1HVT U1_A_2_C1 (.A1(carry_2), .A2(A[2]), .ZN(SUM[2]));
  OR2D1HVT U1_B_12_C1 (.A1(carry_12), .A2(A[12]), .Z(carry_13));
  XNR2D1HVT U1_A_8_C1 (.A1(carry_8), .A2(A[8]), .ZN(SUM[8]));
  OR2D1HVT U1_B_14_C1 (.A1(carry_14), .A2(A[14]), .Z(carry_15));
  XNR2D1HVT U1_A_15_C1 (.A1(carry_15), .A2(A[15]), .ZN(SUM[15]));
  XNR2D1HVT U1_A_7_C1 (.A1(carry_7), .A2(A[7]), .ZN(SUM[7]));
  OR2D1HVT U1_B_7_C1 (.A1(carry_7), .A2(A[7]), .Z(carry_8));
  INVD1HVT U6_C1 (.I(flencnt_0_2), .ZN(SUM[0]));
  XNR2D1HVT U1_A_5_C1 (.A1(carry_5), .A2(A[5]), .ZN(SUM[5]));
  OR2D1HVT U1_B_5_C1 (.A1(carry_5), .A2(A[5]), .Z(carry_6));
  XNR2D1HVT U1_A_6_C1 (.A1(carry_6), .A2(A[6]), .ZN(SUM[6]));
  XNR2D1HVT U1_A_1_C1 (.A1(A[1]), .A2(flencnt_0_2), .ZN(SUM[1]));
  OR2D1HVT U1_B_2_C1 (.A1(carry_2), .A2(A[2]), .Z(carry_3));
endmodule

// Entity:cram_smc_DW01_dec_8_0 Model:cram_smc_DW01_dec_8_0 Library:L1
module cram_smc_DW01_dec_8_0 (A, SUM);
  input [7:0] A;
  output [7:0] SUM;
  wire carry_2, carry_3, carry_4, carry_5, carry_6, carry_7;
  OR2D1HVT U1_B_2_C1 (.A1(carry_2), .A2(A[2]), .Z(carry_3));
  IND2D1HVT U1_B_1_C1 (.A1(A[1]), .B1(SUM[0]), .ZN(carry_2));
  INVD1HVT U6_C1 (.I(A[0]), .ZN(SUM[0]));
  XNR2D1HVT U1_A_1_C1 (.A1(A[1]), .A2(A[0]), .ZN(SUM[1]));
  XNR2D1HVT U1_A_2_C1 (.A1(carry_2), .A2(A[2]), .ZN(SUM[2]));
  XNR2D1HVT U1_A_5_C1 (.A1(carry_5), .A2(A[5]), .ZN(SUM[5]));
  OR2D1HVT U1_B_4_C1 (.A1(carry_4), .A2(A[4]), .Z(carry_5));
  OR2D1HVT U1_B_3_C1 (.A1(carry_3), .A2(A[3]), .Z(carry_4));
  XNR2D1HVT U1_A_4_C1 (.A1(carry_4), .A2(A[4]), .ZN(SUM[4]));
  XNR2D1HVT U1_A_3_C1 (.A1(carry_3), .A2(A[3]), .ZN(SUM[3]));
  XNR2D1HVT U1_A_6_C1 (.A1(carry_6), .A2(A[6]), .ZN(SUM[6]));
  OR2D1HVT U1_B_5_C1 (.A1(carry_5), .A2(A[5]), .Z(carry_6));
  XNR2D1HVT U1_A_7_C1 (.A1(carry_7), .A2(A[7]), .ZN(SUM[7]));
  OR2D1HVT U1_B_6_C1 (.A1(carry_6), .A2(A[6]), .Z(carry_7));
endmodule

// Entity:cram_smc_DW01_dec_8_1 Model:cram_smc_DW01_dec_8_1 Library:L1
module cram_smc_DW01_dec_8_1 (A, SUM);
  input [7:0] A;
  output [7:0] SUM;
  wire carry_2, carry_3, carry_4, carry_5, carry_6, carry_7;
  XNR2D1HVT U1_A_3_C1 (.A1(carry_3), .A2(A[3]), .ZN(SUM[3]));
  IND2D1HVT U1_B_1_C1 (.A1(A[1]), .B1(SUM[0]), .ZN(carry_2));
  XNR2D1HVT U1_A_2_C1 (.A1(carry_2), .A2(A[2]), .ZN(SUM[2]));
  XNR2D1HVT U1_A_4_C1 (.A1(carry_4), .A2(A[4]), .ZN(SUM[4]));
  OR2D1HVT U1_B_2_C1 (.A1(carry_2), .A2(A[2]), .Z(carry_3));
  OR2D1HVT U1_B_3_C1 (.A1(carry_3), .A2(A[3]), .Z(carry_4));
  INVD1HVT U6_C1 (.I(A[0]), .ZN(SUM[0]));
  XNR2D1HVT U1_A_1_C1 (.A1(A[1]), .A2(A[0]), .ZN(SUM[1]));
  OR2D1HVT U1_B_6_C1 (.A1(carry_6), .A2(A[6]), .Z(carry_7));
  OR2D1HVT U1_B_5_C1 (.A1(carry_5), .A2(A[5]), .Z(carry_6));
  XNR2D1HVT U1_A_5_C1 (.A1(carry_5), .A2(A[5]), .ZN(SUM[5]));
  OR2D1HVT U1_B_4_C1 (.A1(carry_4), .A2(A[4]), .Z(carry_5));
  XNR2D1HVT U1_A_6_C1 (.A1(carry_6), .A2(A[6]), .ZN(SUM[6]));
  XNR2D1HVT U1_A_7_C1 (.A1(carry_7), .A2(A[7]), .ZN(SUM[7]));
endmodule

// Entity:jtag_usercode Model:jtag_usercode Library:L1
module jtag_usercode (j_tck, j_cap_dr, usercode_reg, j_usercode, j_sft_dr, 
     j_usercode_tdo, tck_pad_3);
  input j_tck, j_cap_dr, j_usercode, j_sft_dr, tck_pad_3;
  output j_usercode_tdo;
  input [31:0] usercode_reg;
  wire n165, n166, n167, n168, n169, n170, n171, n172, n173, n174, n175, n176, 
     n177, n178, n179, n180, n181, n182, n183, n184, n185, n186, n187, n191, 
     n195, n196, n197, n198, n200, n201, n202, n203, n204, usercode_cnt63_0, 
     usercode_cnt63_1, usercode_cnt63_2, usercode_cnt63_3, usercode_cnt63_4, 
     usercode_cnt_0_, usercode_cnt_1_, usercode_cnt_2_, usercode_cnt_3_, 
     usercode_cnt_4_, U39_N3, U39_N5, U40_N3, U40_N5, usercode_cnt_0_1, n201_1, 
     n202_1, n204_1, n200_1, n203_1, usercode_cnt_4_1, usercode_cnt_1_1, 
     usercode_cnt63_5, n200_2, n201_2, n202_2, n203_2;
  jtag_usercode_DW01_inc_5_0 add_70 (.A({usercode_cnt_4_, usercode_cnt_3_, 
     usercode_cnt_2_, usercode_cnt_1_, usercode_cnt_0_}), .SUM({usercode_cnt63_4, 
     usercode_cnt63_3, usercode_cnt63_2, usercode_cnt63_1, usercode_cnt63_0}), 
     .usercode_cnt_4_1(usercode_cnt_4_1), .usercode_cnt_0_1(usercode_cnt_0_1), 
     .usercode_cnt_1_1(usercode_cnt_1_1));
  BUFFD1HVT OPTHOLD_G_429 (.I(n202_2), .Z(n202_1));
  BUFFD1HVT OPTHOLD_G_427 (.I(n201_2), .Z(n201_1));
  BUFFD1HVT OPTHOLD_G_839 (.I(usercode_cnt63_0), .Z(usercode_cnt63_5));
  BUFFD1HVT OPTHOLD_G_1007 (.I(n202), .Z(n202_2));
  BUFFD1HVT OPTHOLD_G_1006 (.I(n201), .Z(n201_2));
  AO221D1HVT U40_C1 (.A1(usercode_reg[26]), .A2(n180), .B1(usercode_reg[27]), 
     .B2(n185), .C(n191), .Z(U40_N3));
  AOI22D1HVT U49_C3 (.A1(usercode_reg[24]), .A2(n180), .B1(usercode_reg[25]), 
     .B2(n185), .ZN(n173));
  AO221D1HVT U39_C1 (.A1(usercode_reg[30]), .A2(n180), .B1(usercode_reg[31]), 
     .B2(n185), .C(n187), .Z(U39_N3));
  AOI22D1HVT U44_C3 (.A1(usercode_reg[28]), .A2(n180), .B1(usercode_reg[29]), 
     .B2(n185), .ZN(n169));
  BUFFD1HVT OPTHOLD_G_1009 (.I(n203_1), .Z(n203_2));
  MUX2D1HVT U62_C4 (.I0(usercode_cnt_1_1), .I1(usercode_cnt63_1), .S(n178), 
     .Z(n203));
  NR3D1HVT U70_C2 (.A1(usercode_cnt_3_), .A2(usercode_cnt_0_), .A3(n177), 
     .ZN(n183));
  MUX2D1HVT U60_C4 (.I0(usercode_cnt_3_), .I1(usercode_cnt63_3), .S(n178), 
     .Z(n201));
  MUX2D1HVT U61_C4 (.I0(usercode_cnt_2_), .I1(usercode_cnt63_2), .S(n178), 
     .Z(n202));
  NR3D1HVT U73_C2 (.A1(usercode_cnt_3_), .A2(n177), .A3(n175), .ZN(n186));
  BUFFD1HVT OPTHOLD_G_431 (.I(n200_2), .Z(n200_1));
  MUX2D1HVT U59_C4 (.I0(usercode_cnt_4_1), .I1(usercode_cnt63_4), .S(n178), 
     .Z(n200));
  BUFFD1HVT OPTHOLD_G_430 (.I(n204), .Z(n204_1));
  NR3D1HVT U67_C2 (.A1(usercode_cnt_0_), .A2(n177), .A3(n176), .ZN(n180));
  NR3D2HVT U72_C2 (.A1(n177), .A2(n176), .A3(n175), .ZN(n185));
  BUFFD1HVT OPTHOLD_G_518 (.I(usercode_cnt_4_), .Z(usercode_cnt_4_1));
  AOI221D1HVT U39_C3 (.A1(usercode_reg[14]), .A2(n181), .B1(usercode_reg[15]), 
     .B2(n179), .C(U39_N5), .ZN(n165));
  MUX2ND1HVT U38_C4 (.I0(n166), .I1(n165), .S(usercode_cnt_2_), .ZN(n195));
  MUX3D1HVT U75_C8 (.I0(n197), .I1(n196), .I2(n195), .S0(usercode_cnt_2_), 
     .S1(usercode_cnt_1_), .Z(j_usercode_tdo));
  DFNSND1HVT usercode_cnt_reg_0_ (.CPN(tck_pad_3), .D(n204_1), 
     .Q(usercode_cnt_0_), .QN(n175), .SDN(n198));
  DFNSND1HVT usercode_cnt_reg_1_ (.CPN(tck_pad_3), .D(n203_2), 
     .Q(usercode_cnt_1_), .QN(), .SDN(n198));
  MUX2D1HVT U64_C4 (.I0(usercode_cnt_0_1), .I1(usercode_cnt63_5), .S(n178), 
     .Z(n204));
  BUFFD1HVT OPTHOLD_G_997 (.I(n200), .Z(n200_2));
  DFNSND1HVT usercode_cnt_reg_4_ (.CPN(tck_pad_3), .D(n200_1), 
     .Q(usercode_cnt_4_), .QN(n177), .SDN(n198));
  AOI22D1HVT U45_C3 (.A1(usercode_reg[20]), .A2(n183), .B1(usercode_reg[21]), 
     .B2(n186), .ZN(n170));
  AO22D1HVT U54_C3 (.A1(usercode_reg[22]), .A2(n183), .B1(usercode_reg[23]), 
     .B2(n186), .Z(n187));
  AO22D1HVT U58_C3 (.A1(usercode_reg[18]), .A2(n183), .B1(usercode_reg[19]), 
     .B2(n186), .Z(n191));
  AO221D1HVT U40_C2 (.A1(usercode_reg[2]), .A2(n184), .B1(usercode_reg[3]), 
     .B2(n182), .C(U40_N3), .Z(U40_N5));
  AOI22D1HVT U48_C3 (.A1(usercode_reg[0]), .A2(n184), .B1(usercode_reg[1]), 
     .B2(n182), .ZN(n172));
  ND4D1HVT U46_C3 (.A1(n174), .A2(n173), .A3(n172), .A4(n171), .ZN(n197));
  AOI22D1HVT U43_C3 (.A1(usercode_reg[4]), .A2(n184), .B1(usercode_reg[5]), 
     .B2(n182), .ZN(n168));
  BUFFD1HVT OPTHOLD_G_432 (.I(n203), .Z(n203_1));
  AOI221D1HVT U40_C3 (.A1(usercode_reg[10]), .A2(n181), .B1(usercode_reg[11]), 
     .B2(n179), .C(U40_N5), .ZN(n166));
  AOI22D1HVT U47_C3 (.A1(usercode_reg[8]), .A2(n181), .B1(usercode_reg[9]), 
     .B2(n179), .ZN(n171));
  AO221D1HVT U39_C2 (.A1(usercode_reg[6]), .A2(n184), .B1(usercode_reg[7]), 
     .B2(n182), .C(U39_N3), .Z(U39_N5));
  AOI22D1HVT U42_C3 (.A1(usercode_reg[12]), .A2(n181), .B1(usercode_reg[13]), 
     .B2(n179), .ZN(n167));
  BUFFD1HVT OPTHOLD_G_82 (.I(usercode_cnt_0_), .Z(usercode_cnt_0_1));
  DFNSND1HVT usercode_cnt_reg_2_ (.CPN(tck_pad_3), .D(n202_1), 
     .Q(usercode_cnt_2_), .QN(), .SDN(n198));
  BUFFD1HVT OPTHOLD_G_706 (.I(usercode_cnt_1_), .Z(usercode_cnt_1_1));
  NR3D1HVT U69_C2 (.A1(usercode_cnt_4_), .A2(usercode_cnt_3_), .A3(n175), 
     .ZN(n182));
  AN3D1HVT U71_C2 (.A1(n177), .A2(n176), .A3(n175), .Z(n184));
  NR3D1HVT U66_C2 (.A1(usercode_cnt_4_), .A2(n176), .A3(n175), .ZN(n179));
  NR3D1HVT U68_C2 (.A1(usercode_cnt_4_), .A2(usercode_cnt_0_), .A3(n176), 
     .ZN(n181));
  DFNSND1HVT usercode_cnt_reg_3_ (.CPN(tck_pad_3), .D(n201_1), 
     .Q(usercode_cnt_3_), .QN(n176), .SDN(n198));
  INVD1HVT U63_C1 (.I(j_cap_dr), .ZN(n198));
  CKAN2D1HVT U65_C1 (.A1(j_usercode), .A2(j_sft_dr), .Z(n178));
  ND4D1HVT U41_C3 (.A1(n170), .A2(n169), .A3(n168), .A4(n167), .ZN(n196));
  AOI22D1HVT U50_C3 (.A1(usercode_reg[16]), .A2(n183), .B1(usercode_reg[17]), 
     .B2(n186), .ZN(n174));
endmodule

// Entity:jtag_usercode_DW01_inc_5_0 Model:jtag_usercode_DW01_inc_5_0 Library:L1
module jtag_usercode_DW01_inc_5_0 (A, SUM, usercode_cnt_4_1, usercode_cnt_0_1, 
     usercode_cnt_1_1);
  input usercode_cnt_4_1, usercode_cnt_0_1, usercode_cnt_1_1;
  input [4:0] A;
  output [4:0] SUM;
  wire carry_2, carry_3, carry_4;
  INVD1HVT U5_C1 (.I(usercode_cnt_0_1), .ZN(SUM[0]));
  HA1D1HVT U1_1_2 (.A(A[2]), .B(carry_2), .CO(carry_3), .S(SUM[2]));
  HA1D1HVT U1_1_3 (.A(A[3]), .B(carry_3), .CO(carry_4), .S(SUM[3]));
  HA1D1HVT U1_1_1 (.A(usercode_cnt_1_1), .B(usercode_cnt_0_1), .CO(carry_2), 
     .S(SUM[1]));
  CKXOR2D1HVT U6_C1 (.A1(carry_4), .A2(usercode_cnt_4_1), .Z(SUM[4]));
endmodule

// Entity:rstbgen Model:rstbgen Library:L1
module rstbgen (clk, por_b, creset_b, rst_b, osc_clk_4);
  input clk, por_b, creset_b, osc_clk_4;
  output rst_b;
  wire n80, rstff, rstff_1, rstff_2, rstff_3, rstff_4, rstff_5, rstff_6, 
     VDD_magmatienet_0;
  DFCNQD1HVT rstff_reg (.CDN(n80), .CP(osc_clk_4), .D(VDD_magmatienet_0), 
     .Q(rstff));
  BUFFD1HVT OPTHOLD_G_868 (.I(rstff_1), .Z(rstff_6));
  BUFFD1HVT OPTHOLD_G_314 (.I(rstff_4), .Z(rstff_2));
  BUFFD1HVT OPTHOLD_G_572 (.I(rstff), .Z(rstff_4));
  BUFFD1HVT OPTHOLD_G_313 (.I(rstff_5), .Z(rstff_1));
  DFCNQD4HVT rst_b_reg (.CDN(n80), .CP(osc_clk_4), .D(rstff_6), .Q(rst_b));
  BUFFD1HVT OPTHOLD_G_867 (.I(rstff_3), .Z(rstff_5));
  BUFFD1HVT OPTHOLD_G_571 (.I(rstff_2), .Z(rstff_3));
  CKAN2D1HVT U23_C1 (.A1(por_b), .A2(creset_b), .Z(n80));
  TIEHHVT VDD_magmatiecell_0 (.Z(VDD_magmatienet_0));
endmodule

// Entity:sdiomux Model:sdiomux Library:L1
module sdiomux (clk, clk_b, rst_b, md_spi, md_jtag, en_8bconfig_b, 
     en_daisychain_cfg, sample_mode_done, spi_sdo_oe_b, cram_clr_done, 
     cram_clr_done_r, j_tdi, j_tdo, j_usercode, j_usercode_tdo, md_spi_b, 
     spi_ss_in_b, spi_ss_out_b, spi_ss_out_b_int, spi_sdi, spi_sdo, sdi, sdo, 
     bm_bank_sdi, cm_sdi_u0, cm_sdi_u1, cm_sdi_u2, cm_sdi_u3, psdi, psdo, 
     access_nvcm_reg, smc_load_nvcm_bstream, nvcm_spi_ss_b, nvcm_spi_sdi, 
     nvcm_spi_sdo, nvcm_spi_sdo_oe_b, en_8bconfig_b_3, clk_b_2, en_8bconfig_b_2, 
     spi_clk_out_10, spi_clk_out_8);
  input clk, clk_b, rst_b, md_spi, md_jtag, en_8bconfig_b, en_daisychain_cfg, 
     sample_mode_done, cram_clr_done, cram_clr_done_r, j_tdi, j_usercode, 
     j_usercode_tdo, spi_ss_in_b, spi_ss_out_b_int, spi_sdi, access_nvcm_reg, 
     smc_load_nvcm_bstream, nvcm_spi_sdo, nvcm_spi_sdo_oe_b, en_8bconfig_b_3, 
     clk_b_2, en_8bconfig_b_2, spi_clk_out_10, spi_clk_out_8;
  output spi_sdo_oe_b, j_tdo, md_spi_b, spi_ss_out_b, spi_sdo, sdi, 
     nvcm_spi_ss_b, nvcm_spi_sdi;
  input [7:0] sdo;
  input [7:1] psdi;
  output [3:0] bm_bank_sdi;
  output [1:0] cm_sdi_u0;
  output [1:0] cm_sdi_u1;
  output [1:0] cm_sdi_u2;
  output [1:0] cm_sdi_u3;
  output [7:1] psdo;
  wire md_spi_b_1, bm_bank_sdi884_1, bm_bank_sdi884_3, bm_bank_sdi_0_1, 
     cm_sdi_u1934_0, cm_sdi_u2940_0, cm_sdi_u2940_1, cm_sdi_u3946_0, 
     cm_sdi_u3946_1, j_tdo_int_neg, nvcm_spi_sdi_1, n1087, n1089, n1091, n1092, 
     n1093, n1121, bm_bank_sdi_3_1, bm_bank_sdi_2_1, bm_bank_sdi_1_1, 
     cm_sdi_u0_1_1, cm_sdi_u0_0_1, cm_sdi_u1_1_1, cm_sdi_u1_0_1, cm_sdi_u2_1_1, 
     cm_sdi_u2_0_1, cm_sdi_u3_1_1, cm_sdi_u3_0_1, psdo_7_1, psdo_6_1, psdo_5_1, 
     psdo_3_1, psdo_2_1, psdo_1_1, psdi_int_1_, psdi_int_2_, psdi_int_3_, 
     psdi_int_4_, psdi_int_5_, psdi_int_6_, psdi_int_7_, psdo_4_1, sdi_int_1, 
     sdi_int_2, sdi_int_3, sdi_int_4, sdi_int_5, sdi_int_6, sdi_int_7, 
     smc_spi_sdo_oe_b, smc_spi_sdo_oe_b779, smc_spi_ss_out_b, spi_sdi_r, 
     spi_sdo_r, U287_N6, U293_N6, U285_N6, U289_N3, en_daisychain_cfg_1, 
     smc_load_nvcm_bstream_1, access_nvcm_reg_1, en_8bconfig_b_1, md_spi_1, 
     rst_b_1, rst_b_2, psdi_int_7_1, psdi_int_5_1, spi_sdo_oe_b_3, 
     nvcm_spi_ss_b_3, spi_ss_out_b_3;
  DFCNQD1HVT psdo_reg_2_ (.CDN(rst_b_2), .CP(clk_b_2), .D(sdo[2]), .Q(psdo_2_1));
  DFCNQD1HVT psdo_reg_4_ (.CDN(rst_b_2), .CP(clk_b_2), .D(sdo[4]), .Q(psdo_4_1));
  BUFFD4HVT BW1_BUF2175 (.I(psdo_3_1), .Z(psdo[3]));
  DFCNQD1HVT psdo_reg_5_ (.CDN(rst_b_2), .CP(clk_b_2), .D(sdo[5]), .Q(psdo_5_1));
  BUFFD4HVT BW1_BUF2176 (.I(psdo_2_1), .Z(psdo[2]));
  BUFFD4HVT BW1_BUF2174 (.I(psdo_5_1), .Z(psdo[5]));
  BUFFD4HVT BW1_BUF2185 (.I(psdo_4_1), .Z(psdo[4]));
  DFCNQD1HVT psdo_reg_6_ (.CDN(rst_b_2), .CP(clk_b_2), .D(sdo[6]), .Q(psdo_6_1));
  INVD1HVT BW1_INV_D4403 (.I(rst_b), .ZN(rst_b_1));
  DFCNQD1HVT psdi_r_reg_4_ (.CDN(rst_b_2), .CP(spi_clk_out_8), .D(psdi_int_4_), 
     .Q(sdi_int_4));
  DFCNQD1HVT psdi_r_reg_7_ (.CDN(rst_b_2), .CP(spi_clk_out_10), .D(psdi_int_7_), 
     .Q(sdi_int_7));
  DFCNQD1HVT psdo_reg_1_ (.CDN(rst_b_2), .CP(clk_b_2), .D(sdo[1]), .Q(psdo_1_1));
  BUFFD4HVT BW1_BUF2136 (.I(bm_bank_sdi_0_1), .Z(bm_bank_sdi[0]));
  BUFFD4HVT BW1_BUF2164 (.I(cm_sdi_u0_1_1), .Z(cm_sdi_u0[1]));
  DFCNQD1HVT cm_sdi_u0_reg_0_ (.CDN(rst_b_2), .CP(clk_b_2), .D(sdi), 
     .Q(cm_sdi_u0_0_1));
  DFCNQD1HVT bm_bank_sdi_reg_3_ (.CDN(rst_b_2), .CP(clk_b_2), 
     .D(bm_bank_sdi884_3), .Q(bm_bank_sdi_3_1));
  BUFFD4HVT BW1_BUF2166 (.I(cm_sdi_u1_1_1), .Z(cm_sdi_u1[1]));
  BUFFD6HVT BW1_BUF2162 (.I(bm_bank_sdi_2_1), .Z(bm_bank_sdi[2]));
  DFCNQD1HVT bm_bank_sdi_reg_2_ (.CDN(rst_b_2), .CP(clk_b_2), .D(cm_sdi_u1934_0), 
     .Q(bm_bank_sdi_2_1));
  BUFFD4HVT BW1_BUF2167 (.I(cm_sdi_u1_0_1), .Z(cm_sdi_u1[0]));
  MUX2D1HVT U291_C4 (.I0(j_tdo_int_neg), .I1(j_usercode_tdo), .S(j_usercode), 
     .Z(j_tdo));
  DFCNQD1HVT bm_bank_sdi_reg_0_ (.CDN(rst_b_2), .CP(clk_b_2), .D(sdi), 
     .Q(bm_bank_sdi_0_1));
  DFCNQD1HVT bm_bank_sdi_reg_1_ (.CDN(rst_b_2), .CP(clk_b_2), 
     .D(bm_bank_sdi884_1), .Q(bm_bank_sdi_1_1));
  BUFFD4HVT BW1_BUF2163 (.I(bm_bank_sdi_1_1), .Z(bm_bank_sdi[1]));
  BUFFD4HVT BW1_BUF2161 (.I(bm_bank_sdi_3_1), .Z(bm_bank_sdi[3]));
  INR2D1HVT U314_C1 (.A1(sdi_int_5), .B1(en_8bconfig_b), .ZN(cm_sdi_u2940_1));
  DFCNQD1HVT cm_sdi_u2_reg_1_ (.CDN(rst_b_2), .CP(clk_b_2), .D(cm_sdi_u2940_1), 
     .Q(cm_sdi_u2_1_1));
  DFCNQD1HVT cm_sdi_u1_reg_1_ (.CDN(rst_b_2), .CP(clk_b_2), .D(n1091), 
     .Q(cm_sdi_u1_1_1));
  INR2D1HVT U283_C2 (.A1(sdi_int_3), .B1(en_8bconfig_b), .ZN(n1091));
  OR2D1HVT U335_C1 (.A1(n1092), .A2(n1089), .Z(bm_bank_sdi884_1));
  OR2D1HVT U333_C1 (.A1(n1092), .A2(n1091), .Z(bm_bank_sdi884_3));
  CKAN2D1HVT U296_C2 (.A1(sdi), .A2(en_8bconfig_b), .Z(n1092));
  BUFFD4HVT BW1_BUF2170 (.I(cm_sdi_u3_1_1), .Z(cm_sdi_u3[1]));
  BUFFD4HVT BW1_BUF2171 (.I(cm_sdi_u3_0_1), .Z(cm_sdi_u3[0]));
  BUFFD4HVT BW1_BUF2169 (.I(cm_sdi_u2_0_1), .Z(cm_sdi_u2[0]));
  BUFFD4HVT BW1_BUF2168 (.I(cm_sdi_u2_1_1), .Z(cm_sdi_u2[1]));
  BUFFD4HVT BW1_BUF2165 (.I(cm_sdi_u0_0_1), .Z(cm_sdi_u0[0]));
  IND2D2HVT U340_C1 (.A1(smc_spi_ss_out_b), .B1(smc_load_nvcm_bstream_1), 
     .ZN(spi_ss_out_b_3));
  DFCNQD1HVT j_tdo_int_neg_reg (.CDN(rst_b_2), .CP(clk_b_2), .D(sdo[0]), 
     .Q(j_tdo_int_neg));
  DFCNQD1HVT cm_sdi_u0_reg_1_ (.CDN(rst_b_2), .CP(clk_b_2), .D(n1089), 
     .Q(cm_sdi_u0_1_1));
  DFCNQD1HVT cm_sdi_u1_reg_0_ (.CDN(rst_b_2), .CP(clk_b_2), .D(cm_sdi_u1934_0), 
     .Q(cm_sdi_u1_0_1));
  DFCNQD1HVT cm_sdi_u2_reg_0_ (.CDN(rst_b_2), .CP(clk_b_2), .D(cm_sdi_u2940_0), 
     .Q(cm_sdi_u2_0_1));
  INVD1HVT U337_C2_MP_INV (.I(en_8bconfig_b), .ZN(en_8bconfig_b_1));
  AO21D1HVT U334_C2 (.A1(sdi_int_2), .A2(en_8bconfig_b_1), .B(n1092), 
     .Z(cm_sdi_u1934_0));
  AO21D1HVT U336_C2 (.A1(sdi_int_4), .A2(en_8bconfig_b_1), .B(n1092), 
     .Z(cm_sdi_u2940_0));
  AO21D1HVT U337_C2 (.A1(sdi_int_6), .A2(en_8bconfig_b_1), .B(n1092), 
     .Z(cm_sdi_u3946_0));
  INR2D1HVT U282_C2 (.A1(sdi_int_1), .B1(en_8bconfig_b), .ZN(n1089));
  DFCNQD1HVT cm_sdi_u3_reg_1_ (.CDN(rst_b_2), .CP(clk_b_2), .D(cm_sdi_u3946_1), 
     .Q(cm_sdi_u3_1_1));
  DFCNQD1HVT cm_sdi_u3_reg_0_ (.CDN(rst_b_2), .CP(clk_b_2), .D(cm_sdi_u3946_0), 
     .Q(cm_sdi_u3_0_1));
  BUFFD8HVT BL1_R_BUF_6 (.I(spi_ss_out_b_3), .Z(spi_ss_out_b));
  CKMUX2D4HVT U339_C4 (.I0(n1121), .I1(nvcm_spi_sdo), .S(access_nvcm_reg), 
     .Z(spi_sdo));
  AO21D1HVT U287_C4 (.A1(spi_ss_in_b), .A2(access_nvcm_reg), .B(U287_N6), 
     .Z(nvcm_spi_ss_b_3));
  BUFFD8HVT BL1_R_BUF_5 (.I(nvcm_spi_ss_b_3), .Z(nvcm_spi_ss_b));
  IOA21D4HVT U293_C4 (.A1(n1087), .A2(md_jtag), .B(U293_N6), .ZN(sdi));
  OA21D1HVT U287_C3 (.A1(smc_spi_ss_out_b), .A2(smc_load_nvcm_bstream_1), 
     .B(access_nvcm_reg_1), .Z(U287_N6));
  CKAN2D2HVT U289_C1 (.A1(spi_sdi), .A2(access_nvcm_reg), .Z(U289_N3));
  INVD1HVT U289_C4_MP_INV (.I(access_nvcm_reg), .ZN(access_nvcm_reg_1));
  INR2D1HVT U284_C2 (.A1(spi_sdi), .B1(access_nvcm_reg), .ZN(n1093));
  IND3D1HVT U293_C3 (.A1(md_jtag), .B1(spi_sdi_r), .B2(en_daisychain_cfg_1), 
     .ZN(U293_N6));
  BUFFD8HVT BL1_R_BUF_3 (.I(spi_sdo_oe_b_3), .Z(spi_sdo_oe_b));
  INVD1HVT spi_sdo_r_reg_MP_INV (.I(en_daisychain_cfg), .ZN(en_daisychain_cfg_1));
  MUX2D1HVT U300_C4 (.I0(cram_clr_done), .I1(spi_sdo_r), .S(cram_clr_done_r), 
     .Z(n1121));
  INVD1HVT spi_sdi_r_reg_MP_INV (.I(smc_load_nvcm_bstream), 
     .ZN(smc_load_nvcm_bstream_1));
  BUFFD6HVT BW1_BUF2146 (.I(nvcm_spi_sdi_1), .Z(nvcm_spi_sdi));
  DFCNQD1HVT j_tdi_r_reg (.CDN(rst_b_2), .CP(spi_clk_out_8), .D(j_tdi), 
     .Q(n1087));
  SDFCNQD1HVT spi_sdo_r_reg (.CDN(rst_b_2), .CP(clk_b_2), .D(spi_sdi_r), 
     .Q(spi_sdo_r), .SE(en_daisychain_cfg_1), .SI(sdo[0]));
  AO31D1HVT U289_C4 (.A1(smc_load_nvcm_bstream), .A2(n1121), 
     .A3(access_nvcm_reg_1), .B(U289_N3), .Z(nvcm_spi_sdi_1));
  SDFCNQD1HVT spi_sdi_r_reg (.CDN(rst_b_2), .CP(spi_clk_out_8), .D(nvcm_spi_sdo), 
     .Q(spi_sdi_r), .SE(smc_load_nvcm_bstream_1), .SI(n1093));
  OA21D1HVT U285_C3 (.A1(smc_spi_sdo_oe_b), .A2(smc_load_nvcm_bstream), 
     .B(access_nvcm_reg_1), .Z(U285_N6));
  IND2D1HVT U332_C2 (.A1(md_jtag), .B1(sample_mode_done), 
     .ZN(smc_spi_sdo_oe_b779));
  DFSNQD1HVT smc_spi_sdo_oe_b_reg (.CP(clk_b_2), .D(smc_spi_sdo_oe_b779), 
     .Q(smc_spi_sdo_oe_b), .SDN(rst_b_2));
  DFSNQD1HVT smc_spi_ss_out_b_reg (.CP(clk_b_2), .D(spi_ss_out_b_int), 
     .Q(smc_spi_ss_out_b), .SDN(rst_b_2));
  AO21D1HVT U285_C4 (.A1(nvcm_spi_sdo_oe_b), .A2(access_nvcm_reg), .B(U285_N6), 
     .Z(spi_sdo_oe_b_3));
  INVD2HVT BL1_R_INV (.I(psdi_int_7_1), .ZN(psdi_int_7_));
  INR2D1HVT U304_C1 (.A1(psdi[3]), .B1(en_8bconfig_b_2), .ZN(psdi_int_3_));
  DFCNQD1HVT psdi_r_reg_1_ (.CDN(rst_b_2), .CP(spi_clk_out_10), .D(psdi_int_1_), 
     .Q(sdi_int_1));
  DFCNQD1HVT psdo_reg_7_ (.CDN(rst_b_2), .CP(clk_b_2), .D(sdo[7]), .Q(psdo_7_1));
  INR2D1HVT U312_C1 (.A1(sdi_int_7), .B1(en_8bconfig_b), .ZN(cm_sdi_u3946_1));
  DFCNQD1HVT psdi_r_reg_5_ (.CDN(rst_b_2), .CP(spi_clk_out_10), .D(psdi_int_5_), 
     .Q(sdi_int_5));
  DFCNQD1HVT psdi_r_reg_2_ (.CDN(rst_b_2), .CP(spi_clk_out_8), .D(psdi_int_2_), 
     .Q(sdi_int_2));
  DFCNQD1HVT psdi_r_reg_3_ (.CDN(rst_b_2), .CP(spi_clk_out_8), .D(psdi_int_3_), 
     .Q(sdi_int_3));
  DFCNQD1HVT psdi_r_reg_6_ (.CDN(rst_b_2), .CP(spi_clk_out_8), .D(psdi_int_6_), 
     .Q(sdi_int_6));
  DFSNQD1HVT md_spi_b_reg (.CP(clk_b_2), .D(md_spi_1), .Q(md_spi_b_1), 
     .SDN(rst_b_2));
  INVD1HVT md_spi_b_reg_MP_INV (.I(md_spi), .ZN(md_spi_1));
  BUFFD4HVT BW1_BUF2120 (.I(md_spi_b_1), .Z(md_spi_b));
  INR2D1HVT U302_C1 (.A1(psdi[1]), .B1(en_8bconfig_b_2), .ZN(psdi_int_1_));
  BUFFD4HVT BW1_BUF2172 (.I(psdo_7_1), .Z(psdo[7]));
  INVD4HVT BW1_INV4403 (.I(rst_b_1), .ZN(rst_b_2));
  DFCNQD1HVT psdo_reg_3_ (.CDN(rst_b_2), .CP(clk_b_2), .D(sdo[3]), .Q(psdo_3_1));
  BUFFD4HVT BW1_BUF2177 (.I(psdo_1_1), .Z(psdo[1]));
  BUFFD4HVT BW1_BUF2173 (.I(psdo_6_1), .Z(psdo[6]));
  INR2D1HVT U307_C1 (.A1(psdi[4]), .B1(en_8bconfig_b_2), .ZN(psdi_int_4_));
  INVD2HVT BL1_R_INV_1 (.I(psdi_int_5_1), .ZN(psdi_int_5_));
  INR2D1HVT U306_C1 (.A1(psdi[6]), .B1(en_8bconfig_b_2), .ZN(psdi_int_6_));
  IND2D1HVT U305_C1_INV (.A1(en_8bconfig_b_3), .B1(psdi[5]), .ZN(psdi_int_5_1));
  INR2D1HVT U308_C1 (.A1(psdi[2]), .B1(en_8bconfig_b_2), .ZN(psdi_int_2_));
  IND2D1HVT U303_C1_INV (.A1(en_8bconfig_b_3), .B1(psdi[7]), .ZN(psdi_int_7_1));
endmodule

// Entity:startup_shutdown Model:startup_shutdown Library:L1
module startup_shutdown (clk, rst_b, startup_req, shutdown_req, cor_en_oscclk, 
     warmboot_req, smc_oscoff_b, gint_hz, gio_hz, gwe, gsr, end_of_startup, 
     end_of_shutdown, cdone_in, cdone_out, spi_clk_out_11, cor_en_oscclk_1, 
     shutdown_req_1, startup_req_1);
  input clk, rst_b, startup_req, shutdown_req, cor_en_oscclk, warmboot_req, 
     cdone_in, spi_clk_out_11, cor_en_oscclk_1, shutdown_req_1, startup_req_1;
  output smc_oscoff_b, gint_hz, gio_hz, gwe, gsr, end_of_startup, 
     end_of_shutdown, cdone_out;
  wire gsr_1, cdone_out_int279, ginthz_int261, giohz_int267, gwe_int273, n159_0, 
     n471, n472, n474, n475, n476, n477, n478, n479, n480, n481, n482, n483, 
     n484, n485, n489, n490, n491, n492, n494, n495, n496, n500, n502, n505, 
     n506, next_1_, seqcnt158_0, seqcnt158_1, seqcnt158_2, seqcnt158_3, 
     seqcnt160_0, seqcnt160_2, seqcnt160_3, seqcnt_0, seqcnt_1, 
     smc_oscoff_b_int, smc_oscoff_b_int1, smc_oscoff_b_int377, state_0_, 
     state_1_, state_2_, U185_N5, U164_N3, U192_N3, state_0_1, state_2_1, 
     state_1_1, n495_1, next_1_1, n478_1, n496_1, rst_b_1, n477_1, state_0_2, 
     seqcnt160_1, state_2_2, state_1_2, smc_oscoff_b_int_1, smc_oscoff_b_int_2, 
     smc_oscoff_b_int377_1, seqcnt158_4, smc_oscoff_b_int_3, n477_2, n159_1, 
     state_2_3, n496_2, state_0_3, state_1_3, n478_2, n489_1, n492_1, 
     seqcnt160_4, next_1_2, smc_oscoff_b_int_4, smc_oscoff_b_int_5, U192_N3_1, 
     seqcnt158_5, seqcnt158_6, seqcnt158_7, cdone_out_int279_1, seqcnt158_8, 
     n490_1;
  BUFFD1HVT OPTHOLD_G_943 (.I(seqcnt158_2), .Z(seqcnt158_7));
  EDFCND1HVT seqcnt_reg_2_ (.CDN(rst_b_1), .CP(spi_clk_out_11), .D(seqcnt158_7), 
     .E(n159_1), .Q(), .QN(n489));
  EDFCND1HVT seqcnt_reg_1_ (.CDN(rst_b_1), .CP(spi_clk_out_11), .D(seqcnt158_8), 
     .E(n159_1), .Q(seqcnt_1), .QN(n492));
  BUFFD1HVT OPTHOLD_G_630 (.I(state_2_), .Z(state_2_3));
  INVD1HVT U193_C3_MP_INV (.I(n495), .ZN(n495_1));
  BUFFD1HVT OPTHOLD_G_941 (.I(seqcnt158_3), .Z(seqcnt158_5));
  CKXOR2D1HVT U181_C1 (.A1(n491), .A2(n490_1), .Z(seqcnt160_3));
  BUFFD1HVT OPTHOLD_G_714 (.I(n492), .Z(n492_1));
  BUFFD1HVT OPTHOLD_G_73 (.I(state_0_3), .Z(state_0_2));
  BUFFD1HVT OPTHOLD_G_713 (.I(n489), .Z(n489_1));
  BUFFD1HVT OPTHOLD_G_633 (.I(n496), .Z(n496_2));
  AO221D1HVT U153_C4 (.A1(seqcnt160_1), .A2(n492_1), .B1(seqcnt_1), 
     .B2(seqcnt_0), .C(n496), .Z(seqcnt158_1));
  BUFFD1HVT OPTHOLD_G_357 (.I(smc_oscoff_b_int377), .Z(smc_oscoff_b_int377_1));
  BUFFD1HVT OPTHOLD_G_175 (.I(state_1_3), .Z(state_1_2));
  BUFFD1HVT OPTHOLD_G_621 (.I(n477), .Z(n477_2));
  BUFFD1HVT OPTHOLD_G_651 (.I(state_1_), .Z(state_1_3));
  BUFFD1HVT OPTHOLD_G_292 (.I(smc_oscoff_b_int_5), .Z(smc_oscoff_b_int_2));
  BUFFD1HVT OPTHOLD_G_291 (.I(smc_oscoff_b_int_4), .Z(smc_oscoff_b_int_1));
  BUFFD1HVT OPTHOLD_G_952 (.I(cdone_out_int279), .Z(cdone_out_int279_1));
  BUFFD1HVT OPTHOLD_G_873 (.I(smc_oscoff_b_int_2), .Z(smc_oscoff_b_int_4));
  BUFFD1HVT OPTHOLD_G_565 (.I(smc_oscoff_b_int), .Z(smc_oscoff_b_int_3));
  BUFFD4HVT BW1_BUF753 (.I(gsr_1), .Z(gsr));
  DFCNQD1HVT state_reg_0_ (.CDN(rst_b_1), .CP(spi_clk_out_11), .D(n478_2), 
     .Q(state_0_));
  INVD1HVT U175_C2_MP_INV (.I(next_1_), .ZN(next_1_1));
  AN3D1HVT U161_C2 (.A1(next_1_), .A2(n478_2), .A3(n477_1), .Z(n479));
  AO211D1HVT U188_C3 (.A1(next_1_), .A2(n478), .B(n500), .C(n484), 
     .Z(cdone_out_int279));
  NR2D1HVT U160_C1 (.A1(next_1_), .A2(n477_2), .ZN(n476));
  IAO21D1HVT U194_C2 (.A1(next_1_), .A2(n478), .B(n477_2), .ZN(n500));
  INVD1HVT U175_C2_MP_INV_1 (.I(n478_2), .ZN(n478_1));
  AO21D1HVT U186_C2 (.A1(next_1_), .A2(n478_1), .B(n476), .Z(giohz_int267));
  DFSNQD1HVT giohz_int_reg (.CP(spi_clk_out_11), .D(giohz_int267), .Q(gsr_1), 
     .SDN(rst_b_1));
  AO31D1HVT U184_C3 (.A1(next_1_), .A2(n478_1), .A3(n477_1), .B(n476), 
     .Z(ginthz_int261));
  BUFFD1HVT OPTHOLD_G_31 (.I(n477_2), .Z(n477_1));
  BUFFD2HVT BL1_ASSIGN_BUF3 (.I(gsr_1), .Z(gio_hz));
  INR2D1HVT U159_C1 (.A1(n476), .B1(n478_2), .ZN(n480));
  DFSNQD1HVT smc_oscoff_b_int_reg (.CP(spi_clk_out_11), 
     .D(smc_oscoff_b_int377_1), .Q(smc_oscoff_b_int), .SDN(rst_b_1));
  DFCNQD4HVT cdone_out_int_reg (.CDN(rst_b_1), .CP(spi_clk_out_11), 
     .D(cdone_out_int279_1), .Q(cdone_out));
  DFSNQD1HVT smc_oscoff_b_int1_reg (.CP(spi_clk_out_11), .D(smc_oscoff_b_int_1), 
     .Q(smc_oscoff_b_int1), .SDN(rst_b_1));
  BUFFD1HVT OPTHOLD_G_938 (.I(U192_N3), .Z(U192_N3_1));
  BUFFD1HVT OPTHOLD_G_174 (.I(state_2_), .Z(state_2_2));
  OR2D1HVT U150_C1 (.A1(warmboot_req), .A2(smc_oscoff_b_int1), .Z(smc_oscoff_b));
  BUFFD1HVT OPTHOLD_G_652 (.I(n478), .Z(n478_2));
  OR2D1HVT U187_C1 (.A1(n484), .A2(n479), .Z(gwe_int273));
  DFCNQD1HVT gwe_int_reg (.CDN(rst_b_1), .CP(spi_clk_out_11), .D(gwe_int273), 
     .Q(gwe));
  AN3D1HVT U175_C2 (.A1(next_1_1), .A2(n478_1), .A3(n477_2), .Z(n484));
  DFSNQD1HVT ginthz_int_reg (.CP(spi_clk_out_11), .D(ginthz_int261), .Q(gint_hz), 
     .SDN(rst_b_1));
  AOI21D1HVT U149_C2 (.A1(state_2_1), .A2(n482), .B(n481), .ZN(n472));
  NR2D1HVT U154_C1 (.A1(warmboot_req), .A2(shutdown_req_1), .ZN(n474));
  BUFFD1HVT OPTHOLD_G_380 (.I(seqcnt158_1), .Z(seqcnt158_4));
  DFCNQD1HVT state_reg_1_ (.CDN(rst_b_1), .CP(spi_clk_out_11), .D(next_1_2), 
     .Q(state_1_));
  AOI21D1HVT U164_C1 (.A1(n494), .A2(n475), .B(state_0_1), .ZN(U164_N3));
  DFCNQD1HVT end_of_startup_reg (.CDN(rst_b_1), .CP(spi_clk_out_11), .D(n479), 
     .Q(end_of_startup));
  BUFFD1HVT OPTHOLD_G_792 (.I(next_1_), .Z(next_1_2));
  DFCNQD1HVT end_of_shutdown_reg (.CDN(rst_b_1), .CP(spi_clk_out_11), .D(n480), 
     .Q(end_of_shutdown));
  DFCNQD1HVT state_reg_2_ (.CDN(rst_b_1), .CP(spi_clk_out_11), .D(n477_1), 
     .Q(state_2_));
  NR2D1HVT U173_C1 (.A1(state_1_1), .A2(n495), .ZN(n482));
  INVD1HVT U173_C1_MP_INV (.I(state_1_3), .ZN(state_1_1));
  ND2D1HVT U192_C1 (.A1(state_1_), .A2(state_0_1), .ZN(U192_N3));
  AO22D1HVT U162_C2 (.A1(state_0_2), .A2(n482), .B1(state_2_3), .B2(U192_N3_1), 
     .Z(n477));
  AN3D1HVT U174_C2 (.A1(state_2_3), .A2(state_1_1), .A3(n495_1), .Z(n483));
  MUX2D1HVT U156_C4 (.I0(n495_1), .I1(cdone_in), .S(n485), .Z(n475));
  AOI211D1HVT U193_C3 (.A1(state_0_3), .A2(n495_1), .B(state_2_3), .C(state_1_1), 
     .ZN(n502));
  AO21D1HVT U195_C2 (.A1(state_2_1), .A2(n506), .B(n483), .Z(n505));
  AN4D1HVT U172_C3 (.A1(state_2_1), .A2(state_1_1), .A3(state_0_3), 
     .A4(cdone_in), .Z(n481));
  INR3D1HVT U185_C2 (.A1(n474), .B1(state_0_1), .B2(n494), .ZN(U185_N5));
  OAI31D2HVT U152_C3 (.A1(state_0_1), .A2(n494), .A3(n474), .B(n472), .ZN(n496));
  OR4XD1HVT U185_C3 (.A1(n502), .A2(n483), .A3(n481), .A4(U185_N5), .Z(next_1_));
  NR2D1HVT U176_C1 (.A1(state_2_3), .A2(state_1_3), .ZN(n485));
  INVD1HVT U149_C2_MP_INV (.I(state_2_3), .ZN(state_2_1));
  AO21D1HVT U197_C2 (.A1(state_1_1), .A2(startup_req_1), .B(n482), .Z(n506));
  OR2D1HVT U189_C1 (.A1(seqcnt160_3), .A2(n496_2), .Z(seqcnt158_3));
  CKAN2D1HVT U148_C1 (.A1(seqcnt160_4), .A2(n492_1), .Z(n471));
  OR2D1HVT U190_C1 (.A1(seqcnt160_2), .A2(n496_2), .Z(seqcnt158_2));
  ND2D1HVT U166_C1 (.A1(n489_1), .A2(n471), .ZN(n491));
  BUFFD1HVT OPTHOLD_G_1132 (.I(n490), .Z(n490_1));
  ND4D1HVT U158_C3 (.A1(seqcnt160_0), .A2(n492), .A3(n490), .A4(n489), .ZN(n495));
  OR3XD1HVT U182_C2 (.A1(state_0_1), .A2(n494), .A3(cor_en_oscclk_1), 
     .Z(smc_oscoff_b_int377));
  BUFFD1HVT OPTHOLD_G_942 (.I(seqcnt158_0), .Z(seqcnt158_6));
  ND2D1HVT U157_C1 (.A1(state_2_2), .A2(state_1_2), .ZN(n494));
  INVD1HVT U182_C2_MP_INV (.I(state_0_2), .ZN(state_0_1));
  AO21D1HVT U164_C4 (.A1(state_0_1), .A2(n505), .B(U164_N3), .Z(n478));
  BUFFD1HVT OPTHOLD_G_874 (.I(smc_oscoff_b_int_3), .Z(smc_oscoff_b_int_5));
  EDFCND1HVT seqcnt_reg_0_ (.CDN(rst_b_1), .CP(spi_clk_out_11), .D(seqcnt158_6), 
     .E(n159_1), .Q(seqcnt_0), .QN(seqcnt160_0));
  EDFCND1HVT seqcnt_reg_3_ (.CDN(rst_b_1), .CP(spi_clk_out_11), .D(seqcnt158_5), 
     .E(n159_1), .Q(), .QN(n490));
  BUFFD1HVT OPTHOLD_G_641 (.I(state_0_), .Z(state_0_3));
  OR2D1HVT U191_C1 (.A1(seqcnt160_1), .A2(n496_2), .Z(seqcnt158_0));
  BUFFD1HVT OPTHOLD_G_715 (.I(seqcnt160_0), .Z(seqcnt160_4));
  BUFFD2HVT BL1_BUF63 (.I(rst_b), .Z(rst_b_1));
  BUFFD1HVT OPTHOLD_G_147 (.I(seqcnt160_4), .Z(seqcnt160_1));
  INVD1HVT U183_C1_MP_INV (.I(n496), .ZN(n496_1));
  ND2D1HVT U183_C1 (.A1(n496_1), .A2(n495_1), .ZN(n159_0));
  XNR2D1HVT U180_C1 (.A1(n489_1), .A2(n471), .ZN(seqcnt160_2));
  BUFFD1HVT OPTHOLD_G_953 (.I(seqcnt158_4), .Z(seqcnt158_8));
  BUFFD1HVT OPTHOLD_G_623 (.I(n159_0), .Z(n159_1));
endmodule

// Entity:tap_controller Model:tap_controller Library:L1
module tap_controller (tms_pad, tck_pad, trst_pad, tdi_pad, tdo_pad, tdo_oe_pad, 
     j_sft_dr, j_upd_dr, j_cap_dr, j_smc_cap, j_rst_b, j_cfg_enable, 
     j_cfg_disable, j_cfg_program, md_jtag, j_usercode, j_hiz_b, j_mode, 
     j_row_test, bschain_sdo, smc_sdo, gio_hz, j_tck, j_tdi, bs_en, 
     j_idcode_reg, j_ceb0, j_shift0, tck_pad_6, j_cfg_enable_1, j_cfg_disable_1, 
     tck_pad_7, tck_pad_5, j_smc_cap_1, j_rst_b_2);
  input tms_pad, tck_pad, trst_pad, tdi_pad, bschain_sdo, smc_sdo, gio_hz, 
     tck_pad_6, j_cfg_enable_1, j_cfg_disable_1, tck_pad_7, tck_pad_5, 
     j_smc_cap_1, j_rst_b_2;
  output tdo_pad, tdo_oe_pad, j_sft_dr, j_upd_dr, j_cap_dr, j_smc_cap, j_rst_b, 
     j_cfg_enable, j_cfg_disable, j_cfg_program, md_jtag, j_usercode, j_hiz_b, 
     j_mode, j_row_test, j_tck, j_tdi, bs_en, j_ceb0, j_shift0;
  output [31:0] j_idcode_reg;
  wire cell78_U11_CONTROL2, cell78_U15_CONTROL2, cell78_U16_CONTROL2, 
     cell78_U17_CONTROL2, cell78_U18_CONTROL2, cell78_U20_CONTROL2, 
     cell78_U22_CONTROL2, cell78_U23_CONTROL2, cell78_U29_CONTROL1, 
     cell78_U30_CONTROL1, idcode_reg870_0, idcode_reg870_10, idcode_reg870_12, 
     idcode_reg870_14, idcode_reg870_28, idcode_reg870_3, idcode_reg870_4, 
     idcode_reg870_5, idcode_reg870_9, idcode_reg_0, idcode_reg_10, 
     idcode_reg_11, idcode_reg_12, idcode_reg_13, idcode_reg_14, idcode_reg_15, 
     idcode_reg_16, idcode_reg_17, idcode_reg_18, idcode_reg_19, idcode_reg_1, 
     idcode_reg_20, idcode_reg_21, idcode_reg_22, idcode_reg_23, idcode_reg_24, 
     idcode_reg_25, idcode_reg_26, idcode_reg_27, idcode_reg_28, idcode_reg_29, 
     idcode_reg_2, idcode_reg_30, idcode_reg_31, idcode_reg_3, idcode_reg_4, 
     idcode_reg_5, idcode_reg_6, idcode_reg_7, idcode_reg_8, idcode_reg_9, 
     jtag_ir793_0, jtag_ir793_1, jtag_ir793_2, jtag_ir793_3, jtag_ir793_4, 
     jtag_ir_0, latched_jtag_ir_4, latched_jtag_ir_neg_0, latched_jtag_ir_neg_1, 
     latched_jtag_ir_neg_2, latched_jtag_ir_neg_3, latched_jtag_ir_neg_4, 
     bypass_reg, bypassed_tdo, capture_ir, cfg_en, exit1_dr, exit1_ir, exit2_dr, 
     exit2_ir, instruction_tdo, j_smc_capla, n1313, n1316, n1317, n1319, n1320, 
     n1322, n1331, n1332, n1333, n1334, n1335, n1336, n1337, n1340, n1341, 
     n1342, n1343, n1344, n1345, n1346, n1347, n1348, n1349, n1350, n1351, 
     n1352, n1353, n1354, n1355, n1356, n1357, n1358, n1359, n1360, n1361, 
     n1362, n1363, n1364, n1365, n1366, n1367, n1368, n1369, n1370, n1371, 
     n1440, n1442, n1443, n1451, n1454, n1456, n1457, n1458, n1459, n1461, 
     n1464, n_1626, n_1627, pause_dr, pause_ir, run_test_idle, select_ir_scan, 
     shift_ir, shift_ir_neg, test_logic_reset200, tms_q1, tms_q2, tms_q3, 
     tms_q4, update_dr, update_ir, U502_N3, latched_jtag_ir_reg_2_N13, U524_N6, 
     jtag_ir_reg_2_N12, jtag_ir_reg_2_N13, latched_jtag_ir_reg_1_N13, 
     jtag_ir_reg_4_N12, jtag_ir_reg_4_N13, latched_jtag_ir_reg_3_N13, 
     jtag_ir_reg_3_N12, jtag_ir_reg_3_N13, tdo_oe_pad_1, U532_N3, U658_N3, 
     jtag_ir_reg_1_N12, jtag_ir_reg_1_N13, U686_N3, shift_dr_neg_reg_IQ, 
     tck_pad_1, tms_pad_1, n1454_1, n1440_1, exit2_dr_1, 
     latched_jtag_ir_neg_0_1, latched_jtag_ir_4_1, trst_pad_1, j_sft_dr_1, 
     cell78_U29_CONTROL1_1, n1320_1, latched_jtag_ir_3_2, latched_jtag_ir_2_2, 
     latched_jtag_ir_1_2, latched_jtag_ir_0_2, capture_ir_1, j_rst_b_1, N734, 
     N4271, N4037, N4301, N573, N575, N4332, N4288, N1492, N730, n1443_1, 
     trst_pad_3, j_sft_dr_2, n1443_2, trst_pad_4, trst_pad_5, trst_pad_6, 
     trst_pad_7, capture_ir_2, update_ir_1, update_ir_2, N4301_1, N4301_2, 
     N1492_1, N1492_2, cell78_U29_CONTROL1_2, latched_jtag_ir_1_3, N734_1, 
     N734_2, cell78_U30_CONTROL1_1, N730_1, N4271_1, exit1_ir_1, exit1_ir_2, 
     exit1_dr_1, exit1_dr_2, exit2_dr_2, exit2_dr_3, pause_dr_1, pause_dr_2, 
     exit2_ir_1, exit2_ir_2, pause_ir_1, pause_ir_2, select_ir_scan_1, 
     select_ir_scan_2, n1440_2, tms_q2_1, tms_q2_2, tms_q2_3, tms_q1_1, 
     tms_q1_2, tms_q1_3, tms_q3_1, tms_q3_2, tms_q3_3, n1320_2, idcode_reg_32, 
     idcode_reg_33, idcode_reg_34, idcode_reg_35, idcode_reg_36, idcode_reg_37, 
     idcode_reg_38, idcode_reg_39, idcode_reg_40, idcode_reg_41, idcode_reg_42, 
     idcode_reg_43, idcode_reg_44, idcode_reg_45, idcode_reg_46, idcode_reg_47, 
     idcode_reg_48, idcode_reg_49, idcode_reg_50, idcode_reg_51, idcode_reg_52, 
     idcode_reg_53, idcode_reg_54, idcode_reg_55, idcode_reg_56, idcode_reg_57, 
     idcode_reg_58, idcode_reg_59, idcode_reg_60, idcode_reg_61, idcode_reg_62, 
     idcode_reg_63, idcode_reg_64, idcode_reg_65, idcode_reg_66, idcode_reg_67, 
     idcode_reg_68, idcode_reg_69, idcode_reg_70, idcode_reg_71, idcode_reg_72, 
     idcode_reg_73, idcode_reg_74, idcode_reg_75, idcode_reg_76, idcode_reg_77, 
     idcode_reg_78, idcode_reg_79, idcode_reg_80, idcode_reg_81, idcode_reg_82, 
     idcode_reg_83, idcode_reg_84, idcode_reg_85, idcode_reg_86, idcode_reg_87, 
     j_sft_dr_3, jtag_ir793_5, jtag_ir_reg_3_N13_1, jtag_ir_reg_1_N13_1, 
     idcode_reg870_15, idcode_reg870_13, idcode_reg870_6, idcode_reg870_1, 
     cell78_U23_CONTROL2_1, idcode_reg870_16, idcode_reg870_29, 
     idcode_reg870_17, idcode_reg870_11, cell78_U18_CONTROL2_1, 
     cell78_U11_CONTROL2_1, idcode_reg870_18, n1337_1, n1331_1, 
     cell78_U15_CONTROL2_1, n1343_1, n1352_1, n1349_1, n1348_1, n1357_1, 
     n1351_1, n1358_1, n1354_1, n1359_1, n1356_1, n1353_1, n1361_1, n1344_1, 
     n1347_1, n1360_1, n1342_1, n1350_1, n1345_1, n1341_1, n1362_1, n1346_1, 
     n1355_1, test_logic_reset200_1, n1464_1, cell78_U22_CONTROL2_1, 
     cell78_U17_CONTROL2_1, n1364_1, latched_jtag_ir_reg_3_N13_1, 
     latched_jtag_ir_reg_1_N13_1, latched_jtag_ir_reg_2_N13_1, n1333_1, n1332_1, 
     n1336_1, jtag_ir_1, latched_jtag_ir_2_3, latched_jtag_ir_3_3, tms_q3_4, 
     tms_q2_4, tms_q1_4, cell78_U29_CONTROL1_3, j_sft_dr_4, shift_ir_1, N4301_3, 
     N1492_3, N1492_4, exit2_ir_3, exit2_dr_4, exit1_dr_3, pause_dr_3, N730_2, 
     exit1_ir_3, select_ir_scan_3, jtag_ir_2, pause_ir_3, n1440_3, 
     latched_jtag_ir_1_4, N4332_1, j_rst_b_3, idcode_reg_88, idcode_reg_89, 
     idcode_reg_90, tms_q3_5, idcode_reg_91, idcode_reg_92, idcode_reg_93, 
     tms_q2_5, tms_q2_6, idcode_reg_94, idcode_reg_95, idcode_reg_96, 
     idcode_reg_97, idcode_reg_98, idcode_reg_99, idcode_reg_100, 
     idcode_reg_101, idcode_reg_102, idcode_reg_103, tms_q1_5, idcode_reg_104, 
     idcode_reg_105, idcode_reg_106, idcode_reg_107, idcode_reg_108, 
     idcode_reg_109, idcode_reg_110, idcode_reg_111, idcode_reg_112, exit2_ir_4, 
     idcode_reg_113, exit2_dr_5, idcode_reg_114, idcode_reg_115, idcode_reg_116, 
     idcode_reg_117, exit2_dr_6, idcode_reg_118, idcode_reg_119, exit1_dr_4, 
     pause_dr_4, jtag_ir_reg_2_N13_1, n1440_4, n1464_2, 
     latched_jtag_ir_reg_3_N13_2, latched_jtag_ir_reg_2_N13_2, 
     latched_jtag_ir_reg_2_N13_3, N4271_2, idcode_reg_120, exit1_ir_4, 
     idcode_reg_121, idcode_reg_122, n1320_3;
  supply1 VDD;
  supply0 VSS;
  assign j_idcode_reg[31] = 1'b0;
  assign j_idcode_reg[30] = 1'b0;
  assign j_idcode_reg[29] = 1'b0;
  assign j_idcode_reg[28] = 1'b1;
  assign j_idcode_reg[27] = 1'b0;
  assign j_idcode_reg[26] = 1'b0;
  assign j_idcode_reg[25] = 1'b0;
  assign j_idcode_reg[24] = 1'b0;
  assign j_idcode_reg[23] = 1'b0;
  assign j_idcode_reg[22] = 1'b0;
  assign j_idcode_reg[21] = 1'b0;
  assign j_idcode_reg[20] = 1'b0;
  assign j_idcode_reg[19] = 1'b0;
  assign j_idcode_reg[18] = 1'b0;
  assign j_idcode_reg[17] = 1'b0;
  assign j_idcode_reg[16] = 1'b0;
  assign j_idcode_reg[15] = 1'b0;
  assign j_idcode_reg[14] = 1'b1;
  assign j_idcode_reg[13] = 1'b0;
  assign j_idcode_reg[12] = 1'b1;
  assign j_idcode_reg[11] = 1'b0;
  assign j_idcode_reg[10] = 1'b1;
  assign j_idcode_reg[9] = 1'b1;
  assign j_idcode_reg[8] = 1'b0;
  assign j_idcode_reg[7] = 1'b0;
  assign j_idcode_reg[6] = 1'b0;
  assign j_idcode_reg[5] = 1'b1;
  assign j_idcode_reg[4] = 1'b1;
  assign j_idcode_reg[3] = 1'b1;
  assign j_idcode_reg[2] = 1'b0;
  assign j_idcode_reg[1] = 1'b0;
  assign j_idcode_reg[0] = 1'b1;
  BUFFD1HVT OPTHOLD_G_207 (.I(idcode_reg_63), .Z(idcode_reg_62));
  BUFFD1HVT OPTHOLD_G_217 (.I(idcode_reg_106), .Z(idcode_reg_72));
  BUFFD1HVT OPTHOLD_G_258 (.I(n1358), .Z(n1358_1));
  DFCNQD1HVT shift_ir_neg_reg (.CDN(trst_pad_7), .CP(tck_pad_1), .D(shift_ir), 
     .Q(shift_ir_neg));
  BUFFD1HVT OPTHOLD_G_181 (.I(idcode_reg_114), .Z(idcode_reg_36));
  BUFFD1HVT OPTHOLD_G_228 (.I(idcode_reg_94), .Z(idcode_reg_83));
  DFCNQD1HVT latched_jtag_ir_neg_reg_3 (.CDN(trst_pad_7), .CP(tck_pad_1), 
     .D(latched_jtag_ir_3_2), .Q(latched_jtag_ir_neg_3));
  NR2D1HVT U577_C1 (.A1(n1320_1), .A2(N4271_1), .ZN(n1365));
  BUFFD1HVT OPTHOLD_G_250 (.I(n1331), .Z(n1331_1));
  LNQD1HVT j_smc_capla_reg (.D(j_smc_cap_1), .EN(tck_pad_5), .Q(j_smc_capla));
  DFQD1HVT tms_q4_reg (.CP(tck_pad_5), .D(tms_q3_5), .Q(tms_q4));
  BUFFD1HVT OPTHOLD_G_106 (.I(tms_q2), .Z(tms_q2_3));
  INR3D1HVT U511_C2 (.A1(N575), .B1(trst_pad_1), .B2(j_smc_capla), .ZN(j_ceb0));
  BUFFD1HVT OPTHOLD_G_721 (.I(N4332), .Z(N4332_1));
  NR2D1HVT U551_C1 (.A1(N1492_3), .A2(n1454_1), .ZN(n1336));
  BUFFD1HVT OPTHOLD_G_215 (.I(idcode_reg_11), .Z(idcode_reg_70));
  BUFFD1HVT OPTHOLD_G_629 (.I(cell78_U29_CONTROL1), .Z(cell78_U29_CONTROL1_3));
  BUFFD1HVT OPTHOLD_G_838 (.I(pause_dr), .Z(pause_dr_4));
  LND1HVT shiftla_reg (.D(j_sft_dr_4), .EN(tck_pad_5), .Q(), .QN(N575));
  OR3XD1HVT U685_C2 (.A1(update_ir_1), .A2(update_dr), .A3(run_test_idle), 
     .Z(n1440));
  BUFFD1HVT OPTHOLD_G_278 (.I(n1364), .Z(n1364_1));
  BUFFD1HVT OPTHOLD_G_519 (.I(jtag_ir_2), .Z(jtag_ir_1));
  DFCNQD1HVT exit2_dr_reg (.CDN(trst_pad_7), .CP(tck_pad_5), .D(n1332_1), 
     .Q(exit2_dr));
  NR2D1HVT U550_C1 (.A1(tms_pad), .A2(N1492_3), .ZN(n1331));
  AOI21D1HVT U503_C2 (.A1(n1322), .A2(exit2_dr_5), .B(tms_pad), 
     .ZN(cell78_U15_CONTROL2));
  NR2D1HVT U502_C1 (.A1(latched_jtag_ir_3_2), .A2(latched_jtag_ir_1_2), 
     .ZN(U502_N3));
  DFCNQD1HVT latched_jtag_ir_neg_reg_0 (.CDN(trst_pad_7), .CP(tck_pad_1), 
     .D(latched_jtag_ir_0_2), .Q(latched_jtag_ir_neg_0));
  BUFFD1HVT OPTHOLD_G_93 (.I(exit2_dr_3), .Z(exit2_dr_2));
  AN4D1HVT U509_C1 (.A1(n1442), .A2(latched_jtag_ir_4), .A3(latched_jtag_ir_0_2), 
     .A4(U502_N3), .Z(j_row_test));
  BUFFD1HVT OPTHOLD_G_275 (.I(n1464), .Z(n1464_1));
  INVD1HVT U518_C1_MP_INV (.I(latched_jtag_ir_4), .ZN(latched_jtag_ir_4_1));
  BUFFD1HVT OPTHOLD_G_709 (.I(n1440_2), .Z(n1440_3));
  INR2D1HVT U535_C1 (.A1(pause_dr_3), .B1(n1454_1), .ZN(n1332));
  BUFFD1HVT OPTHOLD_G_283 (.I(n1332), .Z(n1332_1));
  DFCNQD1HVT update_ir_reg (.CDN(trst_pad_7), .CP(tck_pad_5), 
     .D(cell78_U22_CONTROL2_1), .Q(update_ir));
  BUFFD1HVT OPTHOLD_G_240 (.I(idcode_reg870_0), .Z(idcode_reg870_1));
  BUFFD1HVT OPTHOLD_G_840 (.I(jtag_ir_reg_2_N13), .Z(jtag_ir_reg_2_N13_1));
  BUFFD1HVT OPTHOLD_G_632 (.I(j_sft_dr_2), .Z(j_sft_dr_4));
  DFNCND1HVT jtag_ir_reg_2 (.CDN(trst_pad_7), .CPN(tck_pad_1), 
     .D(jtag_ir_reg_2_N13_1), .Q(), .QN(N730));
  BUFFD1HVT OPTHOLD_G_99 (.I(pause_ir_2), .Z(pause_ir_1));
  BUFFD1HVT OPTHOLD_G_267 (.I(n1342), .Z(n1342_1));
  MUX2ND1HVT U530_C4 (.I0(N4271_2), .I1(N730_1), .S(capture_ir_2), 
     .ZN(jtag_ir793_2));
  BUFFD1HVT OPTHOLD_G_100 (.I(pause_ir), .Z(pause_ir_2));
  INVD1HVT U576_C1_MP_INV (.I(n1320_3), .ZN(n1320_1));
  BUFFD1HVT OPTHOLD_G_98 (.I(exit2_ir_4), .Z(exit2_ir_2));
  INVD1HVT U536_C1_MP_INV (.I(cell78_U29_CONTROL1_2), .ZN(cell78_U29_CONTROL1_1));
  NR4D1HVT U618_C2 (.A1(n1451), .A2(N4332), .A3(j_sft_dr_1), .A4(U686_N3), 
     .ZN(n1443));
  ND2D1HVT U686_C1 (.A1(N4037), .A2(N573), .ZN(U686_N3));
  BUFFD1HVT OPTHOLD_G_834 (.I(exit2_dr), .Z(exit2_dr_6));
  MUX3D1HVT U522_C8 (.I0(n1456), .I1(n1457), .I2(n1458), 
     .S0(latched_jtag_ir_neg_1), .S1(latched_jtag_ir_neg_2), .Z(n1317));
  BUFFD1HVT OPTHOLD_G_703 (.I(N730), .Z(N730_2));
  OAI31D1HVT U520_C3 (.A1(n1317), .A2(latched_jtag_ir_neg_4), 
     .A3(latched_jtag_ir_neg_3), .B(n1316), .ZN(n1459));
  DFCNQD1HVT latched_jtag_ir_neg_reg_1 (.CDN(trst_pad_7), .CP(tck_pad_1), 
     .D(latched_jtag_ir_1_2), .Q(latched_jtag_ir_neg_1));
  BUFFD1HVT OPTHOLD_G_698 (.I(exit2_ir_1), .Z(exit2_ir_3));
  BUFFD1HVT OPTHOLD_G_704 (.I(exit1_ir_1), .Z(exit1_ir_3));
  BUFFD1HVT OPTHOLD_G_702 (.I(pause_dr_1), .Z(pause_dr_3));
  DFQD1HVT tms_q3_reg (.CP(tck_pad_6), .D(tms_q2_6), .Q(tms_q3));
  BUFFD1HVT OPTHOLD_G_40 (.I(N4301_2), .Z(N4301_1));
  AO21D1HVT jtag_ir_reg_3_C9 (.A1(jtag_ir793_3), .A2(cell78_U29_CONTROL1), 
     .B(jtag_ir_reg_3_N12), .Z(jtag_ir_reg_3_N13));
  AOI21D1HVT U532_C4 (.A1(N734_1), .A2(capture_ir_1), .B(U532_N3), 
     .ZN(jtag_ir793_0));
  BUFFD1HVT OPTHOLD_G_254 (.I(n1349), .Z(n1349_1));
  DFCNQD1HVT idcode_reg_reg_23 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1356_1), 
     .Q(idcode_reg_23));
  BUFFD1HVT OPTHOLD_G_244 (.I(idcode_reg870_4), .Z(idcode_reg870_17));
  CKAN2D1HVT U567_C1 (.A1(n1443_2), .A2(idcode_reg_86), .Z(n1355));
  BUFFD1HVT OPTHOLD_G_221 (.I(idcode_reg_121), .Z(idcode_reg_76));
  IND2D1HVT U683_C1 (.A1(idcode_reg_54), .B1(n1443_2), .ZN(idcode_reg870_28));
  CKAN2D1HVT U569_C1 (.A1(n1443_2), .A2(idcode_reg_89), .Z(n1357));
  BUFFD1HVT OPTHOLD_G_261 (.I(n1356), .Z(n1356_1));
  BUFFD1HVT OPTHOLD_G_183 (.I(idcode_reg_112), .Z(idcode_reg_38));
  BUFFD1HVT OPTHOLD_G_828 (.I(idcode_reg_28), .Z(idcode_reg_113));
  INR2D1HVT U505_C2 (.A1(select_ir_scan_3), .B1(tms_pad), .ZN(n1337));
  BUFFD1HVT OPTHOLD_G_810 (.I(idcode_reg_122), .Z(idcode_reg_97));
  DFNCND1HVT latched_jtag_ir_reg_2 (.CDN(trst_pad_7), .CPN(tck_pad_1), 
     .D(latched_jtag_ir_reg_2_N13_3), .Q(latched_jtag_ir_2_2), .QN(N4288));
  BUFFD1HVT OPTHOLD_G_825 (.I(idcode_reg_52), .Z(idcode_reg_111));
  BUFFD1HVT OPTHOLD_G_263 (.I(n1361), .Z(n1361_1));
  BUFFD1HVT OPTHOLD_G_189 (.I(idcode_reg_110), .Z(idcode_reg_44));
  BUFFD1HVT OPTHOLD_G_220 (.I(idcode_reg_98), .Z(idcode_reg_75));
  DFCNQD1HVT idcode_reg_reg_30 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1362_1), 
     .Q(idcode_reg_30));
  BUFFD1HVT OPTHOLD_G_824 (.I(idcode_reg_45), .Z(idcode_reg_110));
  BUFFD1HVT OPTHOLD_G_799 (.I(idcode_reg_66), .Z(idcode_reg_89));
  BUFFD1HVT OPTHOLD_G_224 (.I(idcode_reg_80), .Z(idcode_reg_79));
  DFSNQD1HVT idcode_reg_reg_28 (.CP(tck_pad_6), .D(idcode_reg870_29), 
     .Q(idcode_reg_28), .SDN(trst_pad_6));
  BUFFD1HVT OPTHOLD_G_197 (.I(idcode_reg_53), .Z(idcode_reg_52));
  BUFFD1HVT OPTHOLD_G_817 (.I(tms_q1_1), .Z(tms_q1_5));
  BUFFD1HVT OPTHOLD_G_212 (.I(idcode_reg_88), .Z(idcode_reg_67));
  BUFFD1HVT OPTHOLD_G_811 (.I(idcode_reg_76), .Z(idcode_reg_98));
  BUFFD1HVT OPTHOLD_G_196 (.I(idcode_reg_1), .Z(idcode_reg_51));
  BUFFD1HVT OPTHOLD_G_229 (.I(idcode_reg_20), .Z(idcode_reg_84));
  BUFFD1HVT OPTHOLD_G_177 (.I(idcode_reg_33), .Z(idcode_reg_32));
  CKAN2D1HVT U556_C1 (.A1(n1443_2), .A2(idcode_reg_107), .Z(n1344));
  CKAN2D1HVT U555_C1 (.A1(n1443_2), .A2(idcode_reg_109), .Z(n1343));
  BUFFD1HVT OPTHOLD_G_36 (.I(capture_ir), .Z(capture_ir_2));
  CKAN2D1HVT U561_C1 (.A1(n1443_2), .A2(idcode_reg_71), .Z(n1349));
  BUFFD1HVT OPTHOLD_G_233 (.I(j_sft_dr_4), .Z(j_sft_dr_3));
  CKAN2D1HVT U562_C1 (.A1(n1443_2), .A2(idcode_reg_116), .Z(n1350));
  DFCNQD1HVT bypassed_tdo_reg (.CDN(trst_pad_7), .CP(tck_pad_1), .D(bypass_reg), 
     .Q(bypassed_tdo));
  BUFFD4HVT BL1_ASSIGN_BUF2 (.I(trst_pad_7), .Z(bs_en));
  BUFFD1HVT OPTHOLD_G_191 (.I(idcode_reg_99), .Z(idcode_reg_46));
  BUFFD1HVT OPTHOLD_G_110 (.I(tms_q3_2), .Z(tms_q3_1));
  DFCNQD1HVT idcode_reg_reg_7 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1344_1), 
     .Q(idcode_reg_7));
  BUFFD1HVT OPTHOLD_G_266 (.I(n1360), .Z(n1360_1));
  DFCNQD1HVT idcode_reg_reg_11 (.CDN(trst_pad_7), .CP(tck_pad_5), .D(n1346_1), 
     .Q(idcode_reg_11));
  CKND4HVT shift_dr_neg_reg_MP_INV (.I(tck_pad_7), .ZN(tck_pad_1));
  DFSNQD1HVT idcode_reg_reg_4 (.CP(tck_pad_6), .D(idcode_reg870_17), 
     .Q(idcode_reg_4), .SDN(trst_pad_7));
  BUFFD1HVT OPTHOLD_G_560 (.I(tms_q3_1), .Z(tms_q3_4));
  DFSNQD1HVT idcode_reg_reg_5 (.CP(tck_pad_6), .D(idcode_reg870_16), 
     .Q(idcode_reg_5), .SDN(trst_pad_7));
  BUFFD1HVT OPTHOLD_G_815 (.I(idcode_reg_31), .Z(idcode_reg_102));
  BUFFD1HVT OPTHOLD_G_246 (.I(cell78_U18_CONTROL2), .Z(cell78_U18_CONTROL2_1));
  BUFFD1HVT OPTHOLD_G_262 (.I(n1353), .Z(n1353_1));
  DFQD1HVT tms_q2_reg (.CP(tck_pad_6), .D(tms_q1_4), .Q(tms_q2));
  CKAN2D1HVT U563_C1 (.A1(n1443_2), .A2(idcode_reg_117), .Z(n1351));
  BUFFD1HVT OPTHOLD_G_190 (.I(idcode_reg_15), .Z(idcode_reg_45));
  BUFFD1HVT OPTHOLD_G_235 (.I(jtag_ir_reg_3_N13), .Z(jtag_ir_reg_3_N13_1));
  BUFFD1HVT OPTHOLD_G_260 (.I(n1359), .Z(n1359_1));
  BUFFD1HVT OPTHOLD_G_206 (.I(idcode_reg_119), .Z(idcode_reg_61));
  OAI21D1HVT U525_C2 (.A1(tms_pad_1), .A2(n1319), .B(n1320_2), 
     .ZN(test_logic_reset200));
  BUFFD1HVT OPTHOLD_G_803 (.I(idcode_reg_85), .Z(idcode_reg_92));
  IND2D1HVT U680_C1 (.A1(idcode_reg_101), .B1(n1443_2), .ZN(idcode_reg870_10));
  BUFFD1HVT OPTHOLD_G_280 (.I(latched_jtag_ir_reg_1_N13), 
     .Z(latched_jtag_ir_reg_1_N13_1));
  DFCNQD1HVT update_dr_reg (.CDN(trst_pad_7), .CP(tck_pad_5), 
     .D(cell78_U17_CONTROL2_1), .Q(update_dr));
  DFCNQD1HVT idcode_tdo_reg (.CDN(trst_pad_7), .CP(tck_pad_1), .D(idcode_reg_0), 
     .Q(n1313));
  NR2XD8HVT U514_C1 (.A1(trst_pad_1), .A2(N575), .ZN(j_shift0));
  IAO21D1HVT U668_C2 (.A1(pause_dr_3), .A2(exit1_dr_3), .B(tms_pad), 
     .ZN(cell78_U11_CONTROL2));
  DFCNQD1HVT pause_dr_reg (.CDN(trst_pad_7), .CP(tck_pad_5), 
     .D(cell78_U11_CONTROL2_1), .Q(pause_dr));
  BUFFD4HVT BW1_BUF3447 (.I(j_rst_b_3), .Z(j_rst_b));
  BUFFD1HVT OPTHOLD_G_104 (.I(tms_q2_2), .Z(tms_q2_1));
  BUFFD1HVT OPTHOLD_G_90 (.I(exit1_ir), .Z(exit1_ir_2));
  BUFFD1HVT BL1_BUF50 (.I(j_sft_dr), .Z(j_sft_dr_2));
  DFCNQD1HVT capture_dr_reg (.CDN(trst_pad_7), .CP(tck_pad_5), .D(n1331_1), 
     .Q(j_smc_cap));
  INVD1HVT U503_C2_MP_INV (.I(exit2_dr_4), .ZN(exit2_dr_1));
  NR2D1HVT U534_C1 (.A1(j_smc_cap_1), .A2(j_sft_dr_4), .ZN(n1322));
  BUFFD1HVT OPTHOLD_G_279 (.I(latched_jtag_ir_reg_3_N13), 
     .Z(latched_jtag_ir_reg_3_N13_1));
  BUFFD1HVT OPTHOLD_G_277 (.I(cell78_U17_CONTROL2), .Z(cell78_U17_CONTROL2_1));
  INR2D1HVT U537_C1 (.A1(n1440_3), .B1(n1454_1), .ZN(n1335));
  MUX2D1HVT latched_jtag_ir_reg_1_C9 (.I0(latched_jtag_ir_1_4), .I1(n1367), 
     .S(cell78_U30_CONTROL1), .Z(latched_jtag_ir_reg_1_N13));
  DFNCND1HVT latched_jtag_ir_reg_1 (.CDN(trst_pad_7), .CPN(tck_pad_1), 
     .D(latched_jtag_ir_reg_1_N13_1), .Q(latched_jtag_ir_1_2), .QN(N573));
  NR3D1HVT U538_C2 (.A1(n1442), .A2(latched_jtag_ir_1_3), .A3(N4332), 
     .ZN(j_cfg_enable));
  NR4D1HVT U584_C3 (.A1(n1451), .A2(latched_jtag_ir_3_2), .A3(N573), 
     .A4(latched_jtag_ir_0_2), .ZN(j_usercode));
  BUFFD1HVT OPTHOLD_G_829 (.I(exit2_dr_1), .Z(exit2_dr_5));
  BUFFD1HVT OPTHOLD_G_809 (.I(idcode_reg_4), .Z(idcode_reg_96));
  BUFFD1HVT OPTHOLD_G_699 (.I(exit2_dr_2), .Z(exit2_dr_4));
  BUFFD1HVT OPTHOLD_G_720 (.I(latched_jtag_ir_1_3), .Z(latched_jtag_ir_1_4));
  DFCNQD1HVT exit1_dr_reg (.CDN(trst_pad_7), .CP(tck_pad_5), 
     .D(cell78_U16_CONTROL2), .Q(exit1_dr));
  CKAN2D1HVT U544_C1 (.A1(tms_pad), .A2(n1320_3), .Z(n1454));
  AO211D1HVT U523_C1 (.A1(update_ir_1), .A2(jtag_ir_1), .B(n1320_1), .C(U524_N6), 
     .Z(n1464));
  BUFFD1HVT OPTHOLD_G_97 (.I(exit2_ir_2), .Z(exit2_ir_1));
  ND2D1HVT U541_C1 (.A1(tms_q4), .A2(tms_q3_1), .ZN(n1461));
  NR2D1HVT U536_C1 (.A1(n1454_1), .A2(cell78_U29_CONTROL1_1), .ZN(n1334));
  DFCNQD1HVT capture_ir_reg (.CDN(trst_pad_7), .CP(tck_pad_5), .D(n1337_1), 
     .Q(capture_ir));
  NR2D1HVT U576_C1 (.A1(n1320_1), .A2(N4301_1), .ZN(n1364));
  BUFFD1HVT OPTHOLD_G_80 (.I(N730_2), .Z(N730_1));
  AO21D1HVT jtag_ir_reg_2_C9 (.A1(jtag_ir793_2), .A2(cell78_U29_CONTROL1_3), 
     .B(jtag_ir_reg_2_N12), .Z(jtag_ir_reg_2_N13));
  BUFFD1HVT OPTHOLD_G_180 (.I(idcode_reg_36), .Z(idcode_reg_35));
  BUFFD1HVT OPTHOLD_G_107 (.I(tms_q1_2), .Z(tms_q1_1));
  NR2D1HVT U578_C1 (.A1(n1320_1), .A2(N730_1), .ZN(n1366));
  BUFFD1HVT OPTHOLD_G_78 (.I(N734), .Z(N734_2));
  DFNSND1HVT latched_jtag_ir_reg_0 (.CPN(tck_pad_1), .D(n1464_2), 
     .Q(latched_jtag_ir_0_2), .QN(N4332), .SDN(trst_pad_7));
  BUFFD1HVT OPTHOLD_G_38 (.I(update_ir_2), .Z(update_ir_1));
  MUX2D1HVT U583_C4 (.I0(latched_jtag_ir_neg_2), .I1(latched_jtag_ir_neg_1), 
     .S(latched_jtag_ir_neg_0), .Z(n1371));
  BUFFD1HVT OPTHOLD_G_61 (.I(latched_jtag_ir_1_2), .Z(latched_jtag_ir_1_3));
  IND2D1HVT U515_C2 (.A1(n1371), .B1(bschain_sdo), .ZN(n1458));
  BUFFD1HVT OPTHOLD_G_236 (.I(jtag_ir_reg_1_N13), .Z(jtag_ir_reg_1_N13_1));
  INVD1HVT U548_C1 (.I(md_jtag), .ZN(cfg_en));
  NR2D1HVT jtag_ir_reg_3_C8 (.A1(N4271_1), .A2(cell78_U29_CONTROL1), 
     .ZN(jtag_ir_reg_3_N12));
  DFCNQD1HVT exit2_ir_reg (.CDN(trst_pad_7), .CP(tck_pad_5), .D(n1333_1), 
     .Q(exit2_ir));
  DFNCND1HVT jtag_ir_reg_3 (.CDN(trst_pad_7), .CPN(tck_pad_1), 
     .D(jtag_ir_reg_3_N13_1), .Q(), .QN(N4271));
  EDFCNQD1HVT jtag_ir_reg_0 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(jtag_ir793_5), 
     .E(cell78_U29_CONTROL1_2), .Q(jtag_ir_0));
  BUFFD1HVT OPTHOLD_G_268 (.I(n1350), .Z(n1350_1));
  BUFFD1HVT OPTHOLD_G_101 (.I(select_ir_scan_2), .Z(select_ir_scan_1));
  BUFFD1HVT OPTHOLD_G_541 (.I(latched_jtag_ir_3_2), .Z(latched_jtag_ir_3_3));
  BUFFD3HVT BW2_BUF2111 (.I(idcode_reg_41), .Z(idcode_reg_122));
  INVD8HVT BW1_INV4504_3 (.I(trst_pad_3), .ZN(trst_pad_7));
  BUFFD1HVT OPTHOLD_G_187 (.I(idcode_reg_5), .Z(idcode_reg_42));
  BUFFD1HVT OPTHOLD_G_184 (.I(idcode_reg_40), .Z(idcode_reg_39));
  BUFFD1HVT OPTHOLD_G_202 (.I(idcode_reg_91), .Z(idcode_reg_57));
  BUFFD1HVT OPTHOLD_G_201 (.I(idcode_reg_57), .Z(idcode_reg_56));
  BUFFD1HVT OPTHOLD_G_802 (.I(idcode_reg_22), .Z(idcode_reg_91));
  BUFFD1HVT OPTHOLD_G_805 (.I(tms_q2_1), .Z(tms_q2_5));
  INVD1HVT U525_C2_MP_INV (.I(tms_pad), .ZN(tms_pad_1));
  BUFFD1HVT OPTHOLD_G_821 (.I(idcode_reg_87), .Z(idcode_reg_107));
  BUFFD1HVT OPTHOLD_G_812 (.I(idcode_reg_47), .Z(idcode_reg_99));
  DFCNQD1HVT instruction_tdo_reg (.CDN(trst_pad_7), .CP(tck_pad_1), 
     .D(jtag_ir_0), .Q(instruction_tdo));
  DFCNQD1HVT idcode_reg_reg_16 (.CDN(trst_pad_7), .CP(tck_pad_5), .D(n1349_1), 
     .Q(idcode_reg_16));
  BUFFD1HVT OPTHOLD_G_813 (.I(idcode_reg_27), .Z(idcode_reg_100));
  INVD1HVT BW1_INV4504_2 (.I(trst_pad_3), .ZN(trst_pad_6));
  DFCNQD1HVT idcode_reg_reg_25 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1358_1), 
     .Q(idcode_reg_25));
  BUFFD1HVT OPTHOLD_G_822 (.I(idcode_reg_73), .Z(idcode_reg_108));
  BUFFD1HVT OPTHOLD_G_798 (.I(idcode_reg_25), .Z(idcode_reg_88));
  BUFFD1HVT OPTHOLD_F_9 (.I(idcode_reg_24), .Z(idcode_reg_121));
  DFCNQD1HVT idcode_reg_reg_29 (.CDN(trst_pad_4), .CP(tck_pad_6), .D(n1361_1), 
     .Q(idcode_reg_29));
  BUFFD1HVT OPTHOLD_G_232 (.I(idcode_reg_8), .Z(idcode_reg_87));
  INVD1HVT BW1_INV4504_1 (.I(trst_pad_3), .ZN(trst_pad_5));
  BUFFD1HVT OPTHOLD_G_252 (.I(n1343), .Z(n1343_1));
  CKAN2D1HVT U565_C1 (.A1(n1443_2), .A2(idcode_reg_108), .Z(n1353));
  DFSNQD1HVT idcode_reg_reg_14 (.CP(tck_pad_6), .D(idcode_reg870_15), 
     .Q(idcode_reg_14), .SDN(trst_pad_7));
  BUFFD1HVT OPTHOLD_F_7 (.I(idcode_reg_68), .Z(idcode_reg_120));
  BUFFD1HVT OPTHOLD_G_200 (.I(idcode_reg_29), .Z(idcode_reg_55));
  BUFFD1HVT OPTHOLD_G_562 (.I(tms_q1_5), .Z(tms_q1_4));
  CKAN2D1HVT U557_C1 (.A1(n1443_2), .A2(idcode_reg_39), .Z(n1345));
  BUFFD1HVT OPTHOLD_G_79 (.I(cell78_U30_CONTROL1), .Z(cell78_U30_CONTROL1_1));
  BUFFD1HVT OPTHOLD_G_282 (.I(n1333), .Z(n1333_1));
  BUFFD1HVT OPTHOLD_G_259 (.I(n1354), .Z(n1354_1));
  BUFFD1HVT OPTHOLD_G_219 (.I(idcode_reg_21), .Z(idcode_reg_74));
  DFCNQD1HVT idcode_reg_reg_26 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1359_1), 
     .Q(idcode_reg_26));
  BUFFD1HVT OPTHOLD_G_253 (.I(n1352), .Z(n1352_1));
  BUFFD1HVT OPTHOLD_G_77 (.I(N734_2), .Z(N734_1));
  NR2D1HVT jtag_ir_reg_4_C8 (.A1(N4301_1), .A2(cell78_U29_CONTROL1_3), 
     .ZN(jtag_ir_reg_4_N12));
  NR2D1HVT U580_C1 (.A1(shift_ir), .A2(j_sft_dr_2), .ZN(n1368));
  DFCNQD1HVT idcode_reg_reg_2 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1342_1), 
     .Q(idcode_reg_2));
  BUFFD1HVT OPTHOLD_G_41 (.I(N4301_3), .Z(N4301_2));
  INVD1HVT BW1_INV_D3863 (.I(n1443), .ZN(n1443_1));
  DFSNQD1HVT idcode_reg_reg_9 (.CP(tck_pad_6), .D(idcode_reg870_18), 
     .Q(idcode_reg_9), .SDN(trst_pad_7));
  BUFFD1HVT OPTHOLD_G_816 (.I(idcode_reg_23), .Z(idcode_reg_103));
  DFCNQD1HVT idcode_reg_reg_15 (.CDN(trst_pad_7), .CP(tck_pad_5), .D(n1348_1), 
     .Q(idcode_reg_15));
  BUFFD1HVT OPTHOLD_G_192 (.I(idcode_reg_6), .Z(idcode_reg_47));
  BUFFD1HVT OPTHOLD_G_561 (.I(tms_q2_5), .Z(tms_q2_4));
  DFCNQD1HVT idcode_reg_reg_13 (.CDN(trst_pad_7), .CP(tck_pad_5), .D(n1347_1), 
     .Q(idcode_reg_13));
  BUFFD1HVT OPTHOLD_G_210 (.I(idcode_reg_19), .Z(idcode_reg_65));
  BUFFD1HVT OPTHOLD_G_208 (.I(idcode_reg_100), .Z(idcode_reg_63));
  BUFFD1HVT OPTHOLD_G_204 (.I(idcode_reg_18), .Z(idcode_reg_59));
  DFCNQD1HVT idcode_reg_reg_18 (.CDN(trst_pad_7), .CP(tck_pad_5), .D(n1351_1), 
     .Q(idcode_reg_18));
  OR2D1HVT U674_C1 (.A1(shift_ir_1), .A2(capture_ir_2), .Z(cell78_U29_CONTROL1));
  BUFFD1HVT OPTHOLD_G_223 (.I(idcode_reg_118), .Z(idcode_reg_78));
  NR2D1HVT U532_C1 (.A1(jtag_ir_2), .A2(capture_ir_1), .ZN(U532_N3));
  BUFFD1HVT OPTHOLD_G_837 (.I(exit1_dr), .Z(exit1_dr_4));
  BUFFD1HVT OPTHOLD_G_265 (.I(n1347), .Z(n1347_1));
  BUFFD1HVT OPTHOLD_G_251 (.I(cell78_U15_CONTROL2), .Z(cell78_U15_CONTROL2_1));
  DFCNQD1HVT shift_dr_reg (.CDN(trst_pad_7), .CP(tck_pad_5), 
     .D(cell78_U15_CONTROL2_1), .Q(j_sft_dr));
  BUFFD1HVT OPTHOLD_G_109 (.I(tms_q1), .Z(tms_q1_3));
  DFNCND1HVT jtag_ir_reg_4 (.CDN(trst_pad_7), .CPN(tck_pad_1), 
     .D(jtag_ir_reg_4_N13), .Q(), .QN(N4301));
  DFCNQD1HVT run_test_idle_reg (.CDN(trst_pad_7), .CP(tck_pad_5), 
     .D(cell78_U23_CONTROL2_1), .Q(run_test_idle));
  BUFFD1HVT OPTHOLD_G_806 (.I(tms_q2_4), .Z(tms_q2_6));
  BUFFD1HVT OPTHOLD_G_92 (.I(exit1_dr_4), .Z(exit1_dr_2));
  BUFFD1HVT OPTHOLD_G_269 (.I(n1345), .Z(n1345_1));
  DFNCND1HVT select_dr_scan_reg (.CDN(trst_pad_7), .CPN(tck_pad_1), .D(n1335), 
     .Q(), .QN(N1492));
  BUFFD1HVT OPTHOLD_F_8 (.I(exit1_ir_3), .Z(exit1_ir_4));
  BUFFD1HVT OPTHOLD_G_43 (.I(N1492_2), .Z(N1492_1));
  IND2D1HVT U547_C1 (.A1(update_dr), .B1(trst_pad_7), .ZN(j_upd_dr));
  NR2D1HVT U542_C1 (.A1(n1454_1), .A2(n1322), .ZN(cell78_U16_CONTROL2));
  OA21D1HVT U669_C2 (.A1(exit2_dr_4), .A2(exit1_dr_3), .B(n1454), 
     .Z(cell78_U17_CONTROL2));
  BUFFD1HVT OPTHOLD_G_281 (.I(latched_jtag_ir_reg_2_N13_2), 
     .Z(latched_jtag_ir_reg_2_N13_1));
  INVD1HVT U618_C2_MP_INV (.I(j_sft_dr_2), .ZN(j_sft_dr_1));
  INVD1HVT U673_C2_MP_INV (.I(n1440_3), .ZN(n1440_1));
  NR3D1HVT U687_C2 (.A1(n1442), .A2(N573), .A3(latched_jtag_ir_0_2), 
     .ZN(j_cfg_disable));
  ND3D1HVT U519_C2 (.A1(latched_jtag_ir_4), .A2(N4037), .A3(N4288), .ZN(n1442));
  BUFFD1HVT OPTHOLD_G_39 (.I(update_ir), .Z(update_ir_2));
  BUFFD1HVT OPTHOLD_G_124 (.I(n1320_3), .Z(n1320_2));
  NR3D1HVT U581_C2 (.A1(n1451), .A2(n1370), .A3(latched_jtag_ir_3_2), .ZN(n1369));
  ND2D1HVT U518_C1 (.A1(latched_jtag_ir_4_1), .A2(N4288), .ZN(n1451));
  BUFFD1HVT OPTHOLD_G_854 (.I(latched_jtag_ir_reg_2_N13), 
     .Z(latched_jtag_ir_reg_2_N13_2));
  BUFFD1HVT OPTHOLD_G_96 (.I(pause_dr_4), .Z(pause_dr_2));
  BUFFD1HVT OPTHOLD_G_705 (.I(select_ir_scan_1), .Z(select_ir_scan_3));
  DFNSND1HVT test_logic_reset_reg (.CPN(tck_pad_1), .D(test_logic_reset200_1), 
     .Q(), .QN(j_rst_b_1), .SDN(trst_pad_7));
  INR2D1HVT U526_C1 (.A1(j_rst_b_2), .B1(select_ir_scan_3), .ZN(n1319));
  BUFFD1HVT OPTHOLD_G_656 (.I(N1492_1), .Z(N1492_3));
  BUFFD1HVT OPTHOLD_G_540 (.I(latched_jtag_ir_2_2), .Z(latched_jtag_ir_2_3));
  MUX2D1HVT latched_jtag_ir_reg_2_C9 (.I0(latched_jtag_ir_2_3), .I1(n1366), 
     .S(cell78_U30_CONTROL1), .Z(latched_jtag_ir_reg_2_N13));
  EDFCNQD1HVT latched_jtag_ir_reg_4 (.CDN(trst_pad_7), .CP(tck_pad_5), 
     .D(n1364_1), .E(cell78_U30_CONTROL1_1), .Q(latched_jtag_ir_4));
  BUFFD1HVT OPTHOLD_G_222 (.I(idcode_reg_78), .Z(idcode_reg_77));
  NR2D1HVT U579_C1 (.A1(n1320_1), .A2(N734_1), .ZN(n1367));
  INR2D1HVT U533_C1 (.A1(pause_ir_3), .B1(n1454_1), .ZN(n1333));
  BUFFD1HVT OPTHOLD_G_193 (.I(idcode_reg_49), .Z(idcode_reg_48));
  BUFFD1HVT OPTHOLD_G_800 (.I(idcode_reg_55), .Z(idcode_reg_90));
  IAO21D1HVT U670_C2 (.A1(pause_ir_3), .A2(exit1_ir_3), .B(tms_pad), 
     .ZN(cell78_U18_CONTROL2));
  MUX2D1HVT latched_jtag_ir_reg_3_C9 (.I0(latched_jtag_ir_3_3), .I1(n1365), 
     .S(cell78_U30_CONTROL1), .Z(latched_jtag_ir_reg_3_N13));
  NR4D2HVT U552_C3 (.A1(n1451), .A2(n1370), .A3(n1369), .A4(latched_jtag_ir_0_2), 
     .ZN(n1340));
  BUFFD1HVT OPTHOLD_G_679 (.I(N1492), .Z(N1492_4));
  ND2D1HVT U516_C1 (.A1(smc_sdo), .A2(latched_jtag_ir_neg_0_1), .ZN(n1457));
  BUFFD1HVT OPTHOLD_G_819 (.I(idcode_reg_50), .Z(idcode_reg_105));
  OAI31D1HVT U521_C3 (.A1(n1371), .A2(latched_jtag_ir_neg_4), 
     .A3(latched_jtag_ir_neg_3), .B(bypassed_tdo), .ZN(n1316));
  BUFFD1HVT OPTHOLD_G_188 (.I(idcode_reg_96), .Z(idcode_reg_43));
  IND2D4HVT U652_C1 (.A1(j_cfg_enable_1), .B1(n_1627), .ZN(md_jtag));
  DFNCND1HVT jtag_ir_reg_1 (.CDN(trst_pad_7), .CPN(tck_pad_1), 
     .D(jtag_ir_reg_1_N13_1), .Q(), .QN(N734));
  BUFFD1HVT OPTHOLD_G_45 (.I(cell78_U29_CONTROL1_3), .Z(cell78_U29_CONTROL1_2));
  BUFFD1HVT OPTHOLD_G_205 (.I(idcode_reg_61), .Z(idcode_reg_60));
  BUFFD1HVT OPTHOLD_G_264 (.I(n1344), .Z(n1344_1));
  BUFFD1HVT OPTHOLD_G_257 (.I(n1351), .Z(n1351_1));
  NR2D1HVT jtag_ir_reg_1_C8 (.A1(N734_1), .A2(cell78_U29_CONTROL1), 
     .ZN(jtag_ir_reg_1_N12));
  BUFFD1HVT OPTHOLD_G_112 (.I(tms_q3), .Z(tms_q3_3));
  BUFFD1HVT OPTHOLD_G_186 (.I(idcode_reg_42), .Z(idcode_reg_41));
  CKAN2D1HVT U566_C1 (.A1(n1443_2), .A2(idcode_reg_56), .Z(n1354));
  BUFFD1HVT OPTHOLD_G_216 (.I(idcode_reg_72), .Z(idcode_reg_71));
  DFCNQD1HVT idcode_reg_reg_22 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1355_1), 
     .Q(idcode_reg_22));
  BUFFD1HVT OPTHOLD_G_211 (.I(idcode_reg_67), .Z(idcode_reg_66));
  BUFFD1HVT OPTHOLD_G_203 (.I(idcode_reg_59), .Z(idcode_reg_58));
  BUFFD1HVT OPTHOLD_G_832 (.I(idcode_reg_58), .Z(idcode_reg_116));
  BUFFD1HVT OPTHOLD_G_243 (.I(idcode_reg870_28), .Z(idcode_reg870_29));
  IND2D1HVT U655_C1 (.A1(j_cfg_disable_1), .B1(j_rst_b_3), .ZN(n_1626));
  OA21D1HVT U672_C2 (.A1(exit2_ir_3), .A2(exit1_ir_4), .B(n1454), 
     .Z(cell78_U22_CONTROL2));
  BUFFD1HVT OPTHOLD_G_851 (.I(n1464_1), .Z(n1464_2));
  DFCNQD1HVT latched_jtag_ir_neg_reg_2 (.CDN(trst_pad_7), .CP(tck_pad_1), 
     .D(latched_jtag_ir_2_2), .Q(latched_jtag_ir_neg_2));
  BUFFD1HVT OPTHOLD_G_818 (.I(idcode_reg_3), .Z(idcode_reg_104));
  BUFFD1HVT OPTHOLD_G_242 (.I(idcode_reg870_5), .Z(idcode_reg870_16));
  CKAN2D1HVT U572_C1 (.A1(n1443_2), .A2(idcode_reg_34), .Z(n1360));
  DFCNQD1HVT idcode_reg_reg_19 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1352_1), 
     .Q(idcode_reg_19));
  BUFFD1HVT OPTHOLD_G_273 (.I(n1355), .Z(n1355_1));
  BUFFD8HVT BL1_ASSIGN_BUF1 (.I(tdi_pad), .Z(j_tdi));
  CKAN2D1HVT U568_C1 (.A1(n1443_2), .A2(idcode_reg_75), .Z(n1356));
  DFCNQD1HVT idcode_reg_reg_31 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1363), 
     .Q(idcode_reg_31));
  DFCNQD1HVT idcode_reg_reg_21 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1354_1), 
     .Q(idcode_reg_21));
  BUFFD1HVT OPTHOLD_G_182 (.I(idcode_reg_38), .Z(idcode_reg_37));
  BUFFD1HVT OPTHOLD_G_833 (.I(idcode_reg_64), .Z(idcode_reg_117));
  BUFFD1HVT OPTHOLD_G_198 (.I(idcode_reg_30), .Z(idcode_reg_53));
  IND2D1HVT U679_C1 (.A1(idcode_reg_92), .B1(n1443_2), .ZN(idcode_reg870_9));
  BUFFD1HVT OPTHOLD_G_231 (.I(idcode_reg_103), .Z(idcode_reg_86));
  IND2D1HVT U682_C1 (.A1(idcode_reg_44), .B1(n1443_2), .ZN(idcode_reg870_14));
  BUFFD1HVT OPTHOLD_G_178 (.I(idcode_reg_104), .Z(idcode_reg_33));
  IND2D1HVT U675_C1 (.A1(idcode_reg_105), .B1(n1443_2), .ZN(idcode_reg870_0));
  IND2D1HVT U681_C1 (.A1(idcode_reg_93), .B1(n1443_2), .ZN(idcode_reg870_12));
  BUFFD4HVT BW1_BUF3801 (.I(tdo_oe_pad_1), .Z(tdo_oe_pad));
  BUFFD1HVT OPTHOLD_G_227 (.I(idcode_reg_7), .Z(idcode_reg_82));
  CKAN2D1HVT U571_C1 (.A1(n1443_2), .A2(idcode_reg_62), .Z(n1359));
  BUFFD1HVT OPTHOLD_G_214 (.I(idcode_reg_95), .Z(idcode_reg_69));
  BUFFD1HVT OPTHOLD_G_209 (.I(idcode_reg_65), .Z(idcode_reg_64));
  DFCNQD1HVT idcode_reg_reg_17 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1350_1), 
     .Q(idcode_reg_17));
  AO21D1HVT U658_C4 (.A1(tdi_pad), .A2(capture_ir_1), .B(U658_N3), 
     .Z(jtag_ir793_4));
  DFCNQD1HVT shift_ir_reg (.CDN(trst_pad_7), .CP(tck_pad_6), 
     .D(cell78_U20_CONTROL2), .Q(shift_ir));
  DFSNQD1HVT idcode_reg_reg_10 (.CP(tck_pad_5), .D(idcode_reg870_11), 
     .Q(idcode_reg_10), .SDN(trst_pad_7));
  EDFCND1HVT bypass_reg_reg (.CDN(trst_pad_7), .CP(tck_pad_6), .D(tdi_pad), 
     .E(j_sft_dr_3), .Q(bypass_reg), .QN());
  DFSNQD1HVT idcode_reg_reg_0 (.CP(tck_pad_6), .D(idcode_reg870_1), 
     .Q(idcode_reg_0), .SDN(trst_pad_7));
  BUFFD1HVT OPTHOLD_G_270 (.I(n1341), .Z(n1341_1));
  CKAN2D1HVT U560_C1 (.A1(n1443_2), .A2(idcode_reg_60), .Z(n1348));
  BUFFD1HVT OPTHOLD_G_855 (.I(latched_jtag_ir_reg_2_N13_1), 
     .Z(latched_jtag_ir_reg_2_N13_3));
  CKAN2D1HVT U558_C1 (.A1(n1443_2), .A2(idcode_reg_37), .Z(n1346));
  DFCNQD1HVT idcode_reg_reg_6 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1343_1), 
     .Q(idcode_reg_6));
  DFSNQD1HVT idcode_reg_reg_3 (.CP(tck_pad_6), .D(idcode_reg870_6), 
     .Q(idcode_reg_3), .SDN(trst_pad_7));
  BUFFD1HVT OPTHOLD_G_249 (.I(n1337), .Z(n1337_1));
  BUFFD1HVT OPTHOLD_G_194 (.I(idcode_reg_13), .Z(idcode_reg_49));
  CKAN2D1HVT U570_C1 (.A1(n1443_2), .A2(idcode_reg_120), .Z(n1358));
  BUFFD1HVT OPTHOLD_G_185 (.I(idcode_reg_115), .Z(idcode_reg_40));
  BUFFD1HVT OPTHOLD_G_826 (.I(idcode_reg_12), .Z(idcode_reg_112));
  INVD1HVT U658_C4_MP_INV (.I(capture_ir_2), .ZN(capture_ir_1));
  BUFFD1HVT OPTHOLD_G_111 (.I(tms_q3_3), .Z(tms_q3_2));
  OR2D8HVT U650_C1 (.A1(n1369), .A2(n1340), .Z(j_mode));
  IND2D1HVT U684_C1 (.A1(update_ir_1), .B1(n1320_3), .ZN(cell78_U30_CONTROL1));
  NR2D1HVT U658_C1 (.A1(N4301_1), .A2(capture_ir_1), .ZN(U658_N3));
  INVD1HVT U514_C1_MP_INV (.I(trst_pad_7), .ZN(trst_pad_1));
  BUFFD1HVT OPTHOLD_G_241 (.I(cell78_U23_CONTROL2), .Z(cell78_U23_CONTROL2_1));
  AO21D1HVT jtag_ir_reg_4_C9 (.A1(jtag_ir793_4), .A2(cell78_U29_CONTROL1_3), 
     .B(jtag_ir_reg_4_N12), .Z(jtag_ir_reg_4_N13));
  AOI21D1HVT U673_C2 (.A1(j_rst_b_2), .A2(n1440_1), .B(tms_pad), 
     .ZN(cell78_U23_CONTROL2));
  NR2XD8HVT U506_C2 (.A1(n1340), .A2(gio_hz), .ZN(j_hiz_b));
  BUFFD1HVT OPTHOLD_G_91 (.I(exit1_dr_2), .Z(exit1_dr_1));
  NR2D1HVT U524_C3 (.A1(update_ir_1), .A2(N4332_1), .ZN(U524_N6));
  BUFFD1HVT OPTHOLD_G_272 (.I(n1346), .Z(n1346_1));
  DFCNQD1HVT select_ir_scan_reg (.CDN(trst_pad_7), .CP(tck_pad_5), .D(n1336_1), 
     .Q(select_ir_scan));
  BUFFD1HVT OPTHOLD_G_44 (.I(N1492_4), .Z(N1492_2));
  BUFFD1HVT OPTHOLD_G_707 (.I(jtag_ir_0), .Z(jtag_ir_2));
  BUFFD1HVT OPTHOLD_G_95 (.I(pause_dr_2), .Z(pause_dr_1));
  BUFFD1HVT OPTHOLD_G_89 (.I(exit1_ir_2), .Z(exit1_ir_1));
  BUFFD1HVT OPTHOLD_G_700 (.I(exit1_dr_1), .Z(exit1_dr_3));
  BUFFD1HVT OPTHOLD_G_274 (.I(test_logic_reset200), .Z(test_logic_reset200_1));
  BUFFD1HVT OPTHOLD_G_276 (.I(cell78_U22_CONTROL2), .Z(cell78_U22_CONTROL2_1));
  IND2D1HVT U648_C1 (.A1(shift_dr_neg_reg_IQ), .B1(n1322), .ZN(j_cap_dr));
  BUFFD1HVT OPTHOLD_G_827 (.I(exit2_ir), .Z(exit2_ir_4));
  BUFFD1HVT OPTHOLD_G_648 (.I(shift_ir), .Z(shift_ir_1));
  BUFFD1HVT OPTHOLD_G_830 (.I(idcode_reg_14), .Z(idcode_reg_114));
  BUFFD1HVT OPTHOLD_G_836 (.I(idcode_reg_16), .Z(idcode_reg_119));
  BUFFD1HVT OPTHOLD_G_835 (.I(idcode_reg_2), .Z(idcode_reg_118));
  CKXOR2D1HVT U582_C1 (.A1(N573), .A2(N4332), .Z(n1370));
  BUFFD1HVT OPTHOLD_G_801 (.I(tms_q3_4), .Z(tms_q3_5));
  BUFFD1HVT OPTHOLD_G_94 (.I(exit2_dr_6), .Z(exit2_dr_3));
  BUFFD1HVT OPTHOLD_G_807 (.I(idcode_reg_84), .Z(idcode_reg_94));
  DFCNQD1HVT shift_dr_neg_reg (.CDN(trst_pad_7), .CP(tck_pad_1), .D(j_sft_dr_2), 
     .Q(shift_dr_neg_reg_IQ));
  INVD1HVT U551_C1_MP_INV (.I(n1454), .ZN(n1454_1));
  BUFFD1HVT OPTHOLD_G_1126 (.I(N4271), .Z(N4271_2));
  BUFFD1HVT OPTHOLD_G_247 (.I(cell78_U11_CONTROL2), .Z(cell78_U11_CONTROL2_1));
  BUFFD1HVT OPTHOLD_G_103 (.I(n1440_4), .Z(n1440_2));
  DFCNQD1HVT pause_ir_reg (.CDN(trst_pad_7), .CP(tck_pad_5), 
     .D(cell78_U18_CONTROL2_1), .Q(pause_ir));
  MUX2ND1HVT U531_C4 (.I0(N730_2), .I1(N734_1), .S(capture_ir_2), 
     .ZN(jtag_ir793_1));
  BUFFD1HVT OPTHOLD_G_81 (.I(N4271), .Z(N4271_1));
  BUFFD1HVT OPTHOLD_G_105 (.I(tms_q2_3), .Z(tms_q2_2));
  BUFFD1HVT OPTHOLD_G_237 (.I(idcode_reg870_14), .Z(idcode_reg870_15));
  NR2D1HVT jtag_ir_reg_2_C8 (.A1(N730_1), .A2(cell78_U29_CONTROL1_3), 
     .ZN(jtag_ir_reg_2_N12));
  BUFFD1HVT OPTHOLD_G_248 (.I(idcode_reg870_9), .Z(idcode_reg870_18));
  DFCNQD1HVT exit1_ir_reg (.CDN(trst_pad_7), .CP(tck_pad_5), .D(n1334), 
     .Q(exit1_ir));
  DFNCND1HVT latched_jtag_ir_reg_3 (.CDN(trst_pad_7), .CPN(tck_pad_1), 
     .D(latched_jtag_ir_reg_3_N13_2), .Q(latched_jtag_ir_3_2), .QN(N4037));
  NR3D1HVT U653_C3 (.A1(n1442), .A2(N573), .A3(N4332), .ZN(j_cfg_program));
  BUFFD1HVT OPTHOLD_G_102 (.I(select_ir_scan), .Z(select_ir_scan_2));
  INVD1HVT U516_C1_MP_INV (.I(latched_jtag_ir_neg_0), 
     .ZN(latched_jtag_ir_neg_0_1));
  MUX2ND1HVT U517_C4 (.I0(bschain_sdo), .I1(n1313), .S(latched_jtag_ir_neg_0), 
     .ZN(n1456));
  MUX3D1HVT U654_C8 (.I0(n1459), .I1(smc_sdo), .I2(instruction_tdo), 
     .S0(md_jtag), .S1(shift_ir_neg), .Z(tdo_pad));
  OR2D1HVT S_300 (.A1(n_1626), .A2(cfg_en), .Z(n_1627));
  AO21D1HVT jtag_ir_reg_1_C9 (.A1(jtag_ir793_1), .A2(cell78_U29_CONTROL1), 
     .B(jtag_ir_reg_1_N12), .Z(jtag_ir_reg_1_N13));
  BUFFD1HVT OPTHOLD_G_655 (.I(N4301), .Z(N4301_3));
  IND4D2HVT U527_C2 (.A1(n1461), .B1(tms_q2_1), .B2(tms_q1_1), .B3(tms_pad), 
     .ZN(n1320));
  IAO21D1HVT U671_C2 (.A1(exit2_ir_3), .A2(cell78_U29_CONTROL1_3), .B(tms_pad), 
     .ZN(cell78_U20_CONTROL2));
  BUFFD1HVT OPTHOLD_G_108 (.I(tms_q1_3), .Z(tms_q1_2));
  MUX2ND1HVT U529_C4 (.I0(N4301_3), .I1(N4271_1), .S(capture_ir_2), 
     .ZN(jtag_ir793_3));
  BUFFD3HVT BW2_BUF609 (.I(n1320), .Z(n1320_3));
  BUFFD1HVT OPTHOLD_G_239 (.I(idcode_reg870_3), .Z(idcode_reg870_6));
  DFCNQD1HVT idcode_reg_reg_24 (.CDN(trst_pad_5), .CP(tck_pad_6), .D(n1357_1), 
     .Q(idcode_reg_24));
  CKAN2D1HVT U564_C1 (.A1(n1443_2), .A2(idcode_reg_83), .Z(n1352));
  BUFFD1HVT OPTHOLD_G_256 (.I(n1357), .Z(n1357_1));
  CKAN2D1HVT U574_C1 (.A1(n1443_2), .A2(idcode_reg_79), .Z(n1362));
  BUFFD1HVT OPTHOLD_G_804 (.I(idcode_reg_48), .Z(idcode_reg_93));
  BUFFD1HVT OPTHOLD_G_808 (.I(idcode_reg_26), .Z(idcode_reg_95));
  INVD1HVT BW1_INV4504 (.I(trst_pad_3), .ZN(trst_pad_4));
  BUFFD1HVT OPTHOLD_G_823 (.I(idcode_reg_81), .Z(idcode_reg_109));
  BUFFD1HVT OPTHOLD_G_722 (.I(j_rst_b_1), .Z(j_rst_b_3));
  BUFFD1HVT OPTHOLD_G_708 (.I(pause_ir_1), .Z(pause_ir_3));
  DFCNQD1HVT latched_jtag_ir_neg_reg_4 (.CDN(trst_pad_7), .CP(tck_pad_1), 
     .D(latched_jtag_ir_4), .Q(latched_jtag_ir_neg_4));
  BUFFD1HVT OPTHOLD_G_195 (.I(idcode_reg_51), .Z(idcode_reg_50));
  BUFFD1HVT OPTHOLD_G_286 (.I(n1336), .Z(n1336_1));
  DFCNQD1HVT idcode_reg_reg_20 (.CDN(trst_pad_7), .CP(tck_pad_5), .D(n1353_1), 
     .Q(idcode_reg_20));
  BUFFD1HVT OPTHOLD_G_255 (.I(n1348), .Z(n1348_1));
  BUFFD1HVT OPTHOLD_G_230 (.I(idcode_reg_10), .Z(idcode_reg_85));
  BUFFD1HVT OPTHOLD_G_271 (.I(n1362), .Z(n1362_1));
  BUFFD1HVT OPTHOLD_G_831 (.I(idcode_reg_9), .Z(idcode_reg_115));
  BUFFD1HVT OPTHOLD_G_820 (.I(idcode_reg_17), .Z(idcode_reg_106));
  BUFFD1HVT OPTHOLD_G_226 (.I(idcode_reg_82), .Z(idcode_reg_81));
  BUFFD1HVT OPTHOLD_G_213 (.I(idcode_reg_69), .Z(idcode_reg_68));
  INVD1HVT BW1_INV_D4504 (.I(trst_pad), .ZN(trst_pad_3));
  CKAN2D1HVT U573_C1 (.A1(n1443_2), .A2(idcode_reg_111), .Z(n1361));
  IND2D1HVT U677_C1 (.A1(idcode_reg_97), .B1(n1443_2), .ZN(idcode_reg870_4));
  CKAN2D1HVT U559_C1 (.A1(n1443_2), .A2(idcode_reg_35), .Z(n1347));
  BUFFD1HVT OPTHOLD_G_245 (.I(idcode_reg870_10), .Z(idcode_reg870_11));
  IND2D1HVT U678_C1 (.A1(idcode_reg_46), .B1(n1443_2), .ZN(idcode_reg870_5));
  BUFFD1HVT OPTHOLD_G_841 (.I(n1440), .Z(n1440_4));
  DFSNQD1HVT idcode_reg_reg_12 (.CP(tck_pad_6), .D(idcode_reg870_13), 
     .Q(idcode_reg_12), .SDN(trst_pad_7));
  DFCNQD1HVT idcode_reg_reg_1 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1341_1), 
     .Q(idcode_reg_1));
  BUFFD1HVT OPTHOLD_G_814 (.I(idcode_reg_70), .Z(idcode_reg_101));
  CKAN2D1HVT U575_C1 (.A1(tdi_pad), .A2(n1443_2), .Z(n1363));
  DFCNQD1HVT idcode_reg_reg_27 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1360_1), 
     .Q(idcode_reg_27));
  BUFFD1HVT OPTHOLD_G_225 (.I(idcode_reg_102), .Z(idcode_reg_80));
  BUFFD1HVT OPTHOLD_G_853 (.I(latched_jtag_ir_reg_3_N13_1), 
     .Z(latched_jtag_ir_reg_3_N13_2));
  DFQD1HVT tms_q1_reg (.CP(tck_pad_5), .D(tms_pad), .Q(tms_q1));
  BUFFD1HVT OPTHOLD_G_179 (.I(idcode_reg_113), .Z(idcode_reg_34));
  IND2D1HVT U676_C1 (.A1(idcode_reg_43), .B1(n1443_2), .ZN(idcode_reg870_3));
  INVD2HVT BW1_INV3863 (.I(n1443_1), .ZN(n1443_2));
  DFSNQD1HVT tdo_oe_pad_reg (.CP(tck_pad_1), .D(n1368), .Q(tdo_oe_pad_1), 
     .SDN(trst_pad_7));
  DFCNQD1HVT idcode_reg_reg_8 (.CDN(trst_pad_7), .CP(tck_pad_6), .D(n1345_1), 
     .Q(idcode_reg_8));
  BUFFD1HVT OPTHOLD_G_234 (.I(jtag_ir793_0), .Z(jtag_ir793_5));
  BUFFD1HVT OPTHOLD_G_218 (.I(idcode_reg_74), .Z(idcode_reg_73));
  CKAN2D1HVT U553_C1 (.A1(n1443_2), .A2(idcode_reg_77), .Z(n1341));
  BUFFD1HVT OPTHOLD_G_238 (.I(idcode_reg870_12), .Z(idcode_reg870_13));
  BUFFD1HVT OPTHOLD_G_199 (.I(idcode_reg_90), .Z(idcode_reg_54));
  CKAN2D1HVT U554_C1 (.A1(n1443_2), .A2(idcode_reg_32), .Z(n1342));
endmodule
