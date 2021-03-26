// Verilog file generated from Magma Bedrock database
// Mon Jan 13 15:56:40 2014
// Bedrock Root: Magma_root

// Entity:ledd_ip Model:ledd_ip Library:magma_checknetlist_lib
module ledd_ip (pwm_out_r, pwm_out_g, pwm_out_b, ledd_on, ledd_rst_async, 
     ledd_clk, ledd_cs, ledd_den, ledd_adr, ledd_dat, ledd_exe, VDD, VSS);
  input ledd_rst_async, ledd_clk, ledd_cs, ledd_den, ledd_exe;
  output pwm_out_r, pwm_out_g, pwm_out_b, ledd_on;
  inout VDD, VSS;
  input [3:0] ledd_adr;
  input [7:0] ledd_dat;
  wire [7:0] leddcr0;
  wire [7:0] leddbr;
  wire [7:0] leddonr;
  wire [7:0] leddofr;
  wire [7:0] leddpwrr;
  wire [7:0] leddpwgr;
  wire [7:0] leddpwbr;
  wire \leddbcrr[0] , \leddbcrr[1] , \leddbcrr[2] , \leddbcrr[3] , 
     \leddbcrr[5] , \leddbcrr[6] , \leddbcrr[7] , \leddbcfr[0] , \leddbcfr[1] , 
     \leddbcfr[2] , \leddbcfr[3] , \leddbcfr[5] , \leddbcfr[6] , \leddbcfr[7] , 
     ledd_sci_inst_wena_leddpwbr, ledd_sci_inst_wena_leddpwgr, 
     ledd_sci_inst_wena_leddpwrr, ledd_sci_inst_wena_leddofr, 
     ledd_sci_inst_wena_leddonr, ledd_sci_inst_wena_leddbr, 
     ledd_sci_inst_wena_leddcr0, n1, n11, n12, n13, n14, n15, n16, n17, n18, 
     n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, 
     n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, leddcr0_6_1, leddcr0_6_2, 
     ledd_dat_7_1, ledd_dat_6_1, ledd_dat_5_1, ledd_dat_4_1, ledd_dat_3_1, 
     ledd_dat_2_1, ledd_dat_1_1, ledd_dat_0_1, ledd_clk_1, ledd_clk_2, 
     ledd_clk_3, ledd_clk_4;
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcfr_reg[6]/U5  (.D0(ledd_dat_6_1), 
     .D1(\leddbcfr[6] ), .S(n37), .X(n17));
  SEH_DCAP8 standard_decap_78 ();
  SEH_DCAP4 standard_decap_40 ();
  SEH_DCAP8 standard_decap_43 ();
  SEH_DCAP8 standard_decap_34 ();
  SEH_NR3_1 U28 (.A1(n30), .A2(n29), .A3(n27), .X(ledd_sci_inst_wena_leddofr));
  SEH_DCAP8 standard_decap_38 ();
  SEH_DCAP8 standard_decap_41 ();
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcfr_reg[5]/U5  (.D0(ledd_dat_5_1), 
     .D1(\leddbcfr[5] ), .S(n37), .X(n16));
  SEH_DCAP4 standard_decap_35 ();
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcrr_reg[6]/U5  (.D0(ledd_dat_6_1), 
     .D1(\leddbcrr[6] ), .S(n38), .X(n24));
  SEH_DCAP8 standard_decap_27 ();
  SEH_NR3_1 U27 (.A1(ledd_adr[1]), .A2(ledd_adr[0]), .A3(n27), 
     .X(ledd_sci_inst_wena_leddcr0));
  SEH_AN4B_1 U39 (.A(ledd_adr[3]), .B1(ledd_cs), .B2(ledd_den), .B3(ledd_adr[2]), 
     .X(n26));
  SEH_DCAP8 standard_decap_21 ();
  SEH_ND2_S_1 U34 (.A1(n29), .A2(ledd_adr[1]), .X(n31));
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcrr_reg[7]/U5  (.D0(ledd_dat_7_1), 
     .D1(\leddbcrr[7] ), .S(n38), .X(n25));
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcfr_reg[1]/U5  (.D0(ledd_dat_1_1), 
     .D1(\leddbcfr[1] ), .S(n37), .X(n13));
  SEH_DCAP8 standard_decap_26 ();
  SEH_INV_S_1 U37 (.A(ledd_adr[0]), .X(n29));
  SEH_DCAP4 standard_decap_7 ();
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcrr_reg[5]/U5  (.D0(ledd_dat_5_1), 
     .D1(\leddbcrr[5] ), .S(n38), .X(n23));
  SEH_DCAP8 standard_decap_19 ();
  SEH_ND2_S_1 U35 (.A1(n30), .A2(ledd_adr[0]), .X(n33));
  SEH_NR2_T_1 U24 (.A1(n31), .A2(n32), .X(ledd_sci_inst_wena_leddpwgr));
  SEH_NR3_2 U29 (.A1(n30), .A2(n29), .A3(n32), .X(ledd_sci_inst_wena_leddpwbr));
  SEH_INV_S_1 U36 (.A(ledd_adr[1]), .X(n30));
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcrr_reg[1]/U5  (.D0(ledd_dat_1_1), 
     .D1(\leddbcrr[1] ), .S(n38), .X(n20));
  SEH_BUF_2 ledd_clk_L1 (.A(ledd_clk_3), .X(ledd_clk_2));
  SEH_NR2_1 U25 (.A1(n31), .A2(n27), .X(ledd_sci_inst_wena_leddonr));
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcrr_reg[3]/U5  (.D0(ledd_dat_3_1), 
     .D1(\leddbcrr[3] ), .S(n38), .X(n22));
  SEH_ND2B_1 U33 (.A(ledd_adr[3]), .B(n28), .X(n32));
  SEH_NR2_1 U26 (.A1(n33), .A2(n27), .X(ledd_sci_inst_wena_leddbr));
  SEH_DCAP8 standard_decap_6 ();
  SEH_NR2_1 U23 (.A1(n33), .A2(n32), .X(ledd_sci_inst_wena_leddpwrr));
  SEH_AN3B_1 U20 (.A(ledd_adr[2]), .B1(ledd_den), .B2(ledd_cs), .X(n28));
  SEH_ND2_S_1 U32 (.A1(ledd_adr[3]), .A2(n28), .X(n27));
  SEH_TIE0_G_1 U38 (.X(n43));
  SEH_DCAP4 standard_decap ();
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcfr_reg[2]/U5  (.D0(ledd_dat_2_1), 
     .D1(\leddbcfr[2] ), .S(n37), .X(n14));
  ledd_ctrl ledd_ctrl_inst (.pwm_out_r(pwm_out_r), .pwm_out_g(pwm_out_g), 
     .pwm_out_b(pwm_out_b), .ledd_on(ledd_on), .ledd_rst_async(ledd_rst_async), 
     .ledd_clk(ledd_clk), .ledd_exe(ledd_exe), .leddcr0({leddcr0[7], 
     leddcr0_6_2, leddcr0[5], leddcr0[4], leddcr0[3], leddcr0[2], leddcr0[1], 
     leddcr0[0]}), .leddbr(leddbr), .leddonr(leddonr), .leddofr(leddofr), 
     .leddbcrr({\leddbcrr[7] , \leddbcrr[6] , \leddbcrr[5] , n43, \leddbcrr[3] , 
     \leddbcrr[2] , \leddbcrr[1] , \leddbcrr[0] }), .leddbcfr({\leddbcfr[7] , 
     \leddbcfr[6] , \leddbcfr[5] , n43, \leddbcfr[3] , \leddbcfr[2] , 
     \leddbcfr[1] , \leddbcfr[0] }), .leddpwrr(leddpwrr), .leddpwgr(leddpwgr), 
     .leddpwbr(leddpwbr), .ledd_clk_1(ledd_clk_1), .ledd_clk_3(ledd_clk_3), 
     .ledd_clk_4(ledd_clk_4));
  SEH_DCAP8 standard_decap_25 ();
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcrr_reg[2]/U5  (.D0(ledd_dat_2_1), 
     .D1(\leddbcrr[2] ), .S(n38), .X(n21));
  SEH_ND2B_2 U30 (.A(n33), .B(n26), .X(n38));
  SEH_INV_S_5 U22 (.A(ledd_rst_async), .X(n1));
  SEH_DCAP4 standard_decap_15 ();
  SEH_DCAP8 standard_decap_16 ();
  SEH_DCAP8 standard_decap_99 ();
  SEH_DCAP8 standard_decap_98 ();
  SEH_DCAP8 standard_decap_97 ();
  SEH_DCAP8 standard_decap_93 ();
  SEH_DCAP8 standard_decap_102 ();
  SEH_DCAP8 standard_decap_91 ();
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcfr_reg[3]/U5  (.D0(ledd_dat_3_1), 
     .D1(\leddbcfr[3] ), .S(n37), .X(n15));
  SEH_DCAP8 standard_decap_96 ();
  SEH_DCAP8 standard_decap_85 ();
  SEH_DCAP4 standard_decap_90 ();
  SEH_DCAP4 standard_decap_84 ();
  SEH_DCAP8 standard_decap_82 ();
  SEH_BUF_6 ledd_clk_L1_1 (.A(ledd_clk), .X(ledd_clk_4));
  SEH_DCAP8 standard_decap_95 ();
  SEH_DCAP8 standard_decap_20 ();
  SNPS_CLOCK_GATE_HIGH_ledd_sci_14 \clk_gate_ledd_sci_inst/leddpwgr_reg  (
     .CLK(ledd_clk_4), .EN(ledd_sci_inst_wena_leddpwgr), .ENCLK(n35), .TE(n43));
  SEH_INV_S_6 U21 (.A(ledd_rst_async), .X(n11));
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcfr_reg[0]/U5  (.D0(ledd_dat_0_1), 
     .D1(\leddbcfr[0] ), .S(n37), .X(n12));
  SEH_DCAP8 standard_decap_71 ();
  SEH_DCAP8 standard_decap_87 ();
  SEH_DCAP8 standard_decap_88 ();
  SEH_DCAP8 standard_decap_68 ();
  SEH_DCAP4 standard_decap_67 ();
  SEH_DCAP8 standard_decap_60 ();
  SEH_INV_S_4 BW2_INV1574 (.A(leddcr0_6_1), .X(leddcr0_6_2));
  SEH_DCAP8 standard_decap_66 ();
  SEH_DCAP4 standard_decap_59 ();
  SEH_DCAP8 standard_decap_46 ();
  SEH_DCAP8 standard_decap_74 ();
  SEH_DCAP8 standard_decap_37 ();
  SEH_DCAP8 standard_decap_72 ();
  SEH_BUF_S_32 ledd_clk_L0 (.A(ledd_clk_2), .X(ledd_clk_1));
  SEH_DCAP4 standard_decap_75 ();
  SEH_DCAP4 standard_decap_44 ();
  SNPS_CLOCK_GATE_HIGH_ledd_sci_15 \clk_gate_ledd_sci_inst/leddpwbr_reg  (
     .CLK(ledd_clk_4), .EN(ledd_sci_inst_wena_leddpwbr), .ENCLK(n34), .TE(n43));
  SEH_DCAP8 standard_decap_47 ();
  SEH_DCAP8 standard_decap_51 ();
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcrr_reg[0]/U5  (.D0(ledd_dat_0_1), 
     .D1(\leddbcrr[0] ), .S(n38), .X(n19));
  SEH_DCAP8 standard_decap_30 ();
  SEH_DCAP4 standard_decap_42 ();
  SNPS_CLOCK_GATE_HIGH_ledd_sci_10 \clk_gate_ledd_sci_inst/leddbr_reg  (
     .CLK(ledd_clk_4), .EN(ledd_sci_inst_wena_leddbr), .ENCLK(n41), .TE(n43));
  SEH_DCAP4 standard_decap_73 ();
  SEH_DCAP4 standard_decap_58 ();
  SEH_ND2B_2 U31 (.A(n31), .B(n26), .X(n37));
  SEH_DCAP8 standard_decap_52 ();
  SEH_BUF_3 BW2_BUF5 (.A(ledd_dat[0]), .X(ledd_dat_0_1));
  SEH_DCAP8 standard_decap_65 ();
  SEH_DCAP4 standard_decap_62 ();
  SEH_DCAP8 standard_decap_63 ();
  SEH_DCAP4 standard_decap_57 ();
  SEH_DCAP4 standard_decap_69 ();
  SEH_DCAP8 standard_decap_77 ();
  SEH_DCAP8 standard_decap_31 ();
  SEH_BUF_S_2 BW2_BUF12 (.A(ledd_dat[7]), .X(ledd_dat_7_1));
  SEH_DCAP8 standard_decap_10 ();
  SEH_DCAP8 standard_decap_4 ();
  SEH_DCAP4 standard_decap_1 ();
  SEH_DCAP8 standard_decap_23 ();
  SEH_DCAP4 standard_decap_24 ();
  SEH_DCAP8 standard_decap_28 ();
  SEH_DCAP8 standard_decap_5 ();
  SEH_DCAP4 standard_decap_18 ();
  SEH_DCAP8 standard_decap_14 ();
  SEH_DCAP8 standard_decap_3 ();
  SEH_BUF_3 BW2_BUF9 (.A(ledd_dat[4]), .X(ledd_dat_4_1));
  SEH_BUF_S_2 BW2_BUF11 (.A(ledd_dat[6]), .X(ledd_dat_6_1));
  SEH_DCAP8 standard_decap_17 ();
  SEH_BUF_S_2 BW2_BUF7 (.A(ledd_dat[2]), .X(ledd_dat_2_1));
  SEH_DCAP8 standard_decap_22 ();
  SEH_DCAP8 standard_decap_12 ();
  SEH_DCAP4 standard_decap_32 ();
  SEH_DCAP8 standard_decap_39 ();
  SEH_DCAP8 standard_decap_45 ();
  SEH_DCAP8 standard_decap_9 ();
  SEH_BUF_S_2 BW2_BUF6 (.A(ledd_dat[1]), .X(ledd_dat_1_1));
  SEH_BUF_S_3 ledd_clk_L2 (.A(ledd_clk), .X(ledd_clk_3));
  SEH_DCAP8 standard_decap_11 ();
  SEH_DCAP4 standard_decap_8 ();
  SEH_DCAP8 standard_decap_13 ();
  SEH_BUF_S_2 BW2_BUF8 (.A(ledd_dat[3]), .X(ledd_dat_3_1));
  SEH_DCAP8 standard_decap_2 ();
  SEH_DCAP8 standard_decap_48 ();
  SEH_INV_S_1 BW2_INV19 (.A(leddcr0[6]), .X(leddcr0_6_1));
  SEH_DCAP4 standard_decap_50 ();
  SEH_DCAP8 standard_decap_33 ();
  SEH_DCAP8 standard_decap_49 ();
  SNPS_CLOCK_GATE_HIGH_ledd_sci_13 \clk_gate_ledd_sci_inst/leddpwrr_reg  (
     .CLK(ledd_clk_4), .EN(ledd_sci_inst_wena_leddpwrr), .ENCLK(n36), .TE(n43));
  SNPS_CLOCK_GATE_HIGH_ledd_sci_12 \clk_gate_ledd_sci_inst/leddofr_reg  (
     .CLK(ledd_clk_3), .EN(ledd_sci_inst_wena_leddofr), .ENCLK(n39), .TE(n43));
  SEH_DCAP8 standard_decap_36 ();
  SEH_DCAP8 standard_decap_56 ();
  SEH_DCAP8 standard_decap_55 ();
  SEH_DCAP4 standard_decap_61 ();
  SEH_DCAP8 standard_decap_92 ();
  SEH_DCAP8 standard_decap_64 ();
  SEH_DCAP8 standard_decap_80 ();
  SEH_DCAP8 standard_decap_101 ();
  SEH_DCAP4 standard_decap_79 ();
  SEH_DCAP8 standard_decap_86 ();
  SEH_DCAP8 standard_decap_94 ();
  SEH_DCAP8 standard_decap_100 ();
  SEH_DCAP8 standard_decap_83 ();
  SEH_DCAP4 standard_decap_81 ();
  SEH_DCAP4 standard_decap_89 ();
  SEH_DCAP8 standard_decap_53 ();
  SEH_DCAP8 standard_decap_54 ();
  SNPS_CLOCK_GATE_HIGH_ledd_sci_11 \clk_gate_ledd_sci_inst/leddonr_reg  (
     .CLK(ledd_clk_3), .EN(ledd_sci_inst_wena_leddonr), .ENCLK(n40), .TE(n43));
  SNPS_CLOCK_GATE_HIGH_ledd_sci_9 \clk_gate_ledd_sci_inst/leddcr0_reg  (
     .CLK(ledd_clk_3), .EN(ledd_sci_inst_wena_leddcr0), .ENCLK(n42), .TE(n43));
  SEH_DCAP8 standard_decap_70 ();
  SEH_DCAP4 standard_decap_76 ();
  SEH_MUX2_G_1 \ledd_sci_inst/leddbcfr_reg[7]/U5  (.D0(ledd_dat_7_1), 
     .D1(\leddbcfr[7] ), .S(n37), .X(n18));
  SEH_BUF_S_2 BW2_BUF10 (.A(ledd_dat[5]), .X(ledd_dat_5_1));
  SEH_DCAP4 standard_decap_29 ();
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwbr_reg[0]  (.CK(n34), .D(ledd_dat[0]), .Q(leddpwbr[0]), 
     .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwbr_reg[1]  (.CK(n34), .D(ledd_dat_1_1), .Q(leddpwbr[1]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwbr_reg[2]  (.CK(n34), 
     .D(ledd_dat_2_1), .Q(leddpwbr[2]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwbr_reg[3]  (.CK(n34), .D(ledd_dat_3_1), 
     .Q(leddpwbr[3]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwbr_reg[4]  (.CK(n34), .D(ledd_dat_4_1), .Q(leddpwbr[4]), 
     .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwbr_reg[5]  (.CK(n34), .D(ledd_dat_5_1), .Q(leddpwbr[5]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwbr_reg[6]  (.CK(n34), 
     .D(ledd_dat_6_1), .Q(leddpwbr[6]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwbr_reg[7]  (.CK(n34), .D(ledd_dat_7_1), 
     .Q(leddpwbr[7]), .RD(n11));
  SEH_FDPRBQ_V2_3 \ledd_sci_inst/leddbr_reg[0]  (.CK(n41), .D(ledd_dat_0_1), .Q(leddbr[0]), 
     .RD(n1));
  SEH_FDPRBQ_V2_3 \ledd_sci_inst/leddbr_reg[1]  (.CK(n41), .D(ledd_dat_1_1), .Q(leddbr[1]), .RD(n1));
  SEH_FDPRBQ_V2_3 \ledd_sci_inst/leddbr_reg[2]  (.CK(n41), 
     .D(ledd_dat_2_1), .Q(leddbr[2]), .RD(n1));
  SEH_FDPRBQ_V2_3 \ledd_sci_inst/leddbr_reg[3]  (.CK(n41), .D(ledd_dat_3_1), 
     .Q(leddbr[3]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbr_reg[4]  (.CK(n41), .D(ledd_dat_4_1), .Q(leddbr[4]), .RD(n11));
  SEH_FDPRBQ_V2_3 \ledd_sci_inst/leddbr_reg[5]  (
     .CK(n41), .D(ledd_dat_5_1), .Q(leddbr[5]), .RD(n1));
  SEH_FDPRBQ_V2_3 \ledd_sci_inst/leddbr_reg[6]  (.CK(n41), 
     .D(ledd_dat_6_1), .Q(leddbr[6]), .RD(n1));
  SEH_FDPRBQ_V2_3 \ledd_sci_inst/leddbr_reg[7]  (.CK(n41), .D(ledd_dat_7_1), 
     .Q(leddbr[7]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddcr0_reg[0]  (.CK(n42), .D(ledd_dat_0_1), .Q(leddcr0[0]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddcr0_reg[1]  (
     .CK(n42), .D(ledd_dat_1_1), .Q(leddcr0[1]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddcr0_reg[2]  (.CK(n42), 
     .D(ledd_dat_2_1), .Q(leddcr0[2]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddcr0_reg[3]  (.CK(n42), .D(ledd_dat_3_1), 
     .Q(leddcr0[3]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddcr0_reg[4]  (.CK(n42), .D(ledd_dat_4_1), .Q(leddcr0[4]), 
     .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddcr0_reg[5]  (.CK(n42), .D(ledd_dat_5_1), .Q(leddcr0[5]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddcr0_reg[6]  (.CK(n42), 
     .D(ledd_dat_6_1), .Q(leddcr0[6]), .RD(n1));
  SEH_FDPRBQ_V2_3 \ledd_sci_inst/leddcr0_reg[7]  (.CK(n42), .D(ledd_dat_7_1), 
     .Q(leddcr0[7]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcrr_reg[0]  (.CK(ledd_clk_1), .D(n19), .Q(\leddbcrr[0] ), 
     .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcrr_reg[1]  (.CK(ledd_clk_1), .D(n20), .Q(\leddbcrr[1] ), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcrr_reg[2]  (.CK(ledd_clk_1), 
     .D(n21), .Q(\leddbcrr[2] ), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcrr_reg[3]  (.CK(ledd_clk_1), .D(n22), 
     .Q(\leddbcrr[3] ), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcrr_reg[5]  (.CK(ledd_clk_1), .D(n23), .Q(\leddbcrr[5] ), 
     .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcrr_reg[6]  (.CK(ledd_clk_1), .D(n24), .Q(\leddbcrr[6] ), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcrr_reg[7]  (.CK(ledd_clk_1), 
     .D(n25), .Q(\leddbcrr[7] ), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddofr_reg[0]  (.CK(n39), .D(ledd_dat_0_1), 
     .Q(leddofr[0]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddofr_reg[1]  (.CK(n39), .D(ledd_dat_1_1), .Q(leddofr[1]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddofr_reg[2]  (
     .CK(n39), .D(ledd_dat_2_1), .Q(leddofr[2]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddofr_reg[3]  (.CK(n39), 
     .D(ledd_dat_3_1), .Q(leddofr[3]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddofr_reg[4]  (.CK(n39), .D(ledd_dat_4_1), 
     .Q(leddofr[4]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddofr_reg[5]  (.CK(n39), .D(ledd_dat_5_1), .Q(leddofr[5]), 
     .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddofr_reg[6]  (.CK(n39), .D(ledd_dat_6_1), .Q(leddofr[6]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddofr_reg[7]  (.CK(n39), 
     .D(ledd_dat_7_1), .Q(leddofr[7]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcfr_reg[0]  (.CK(ledd_clk_1), .D(n12), 
     .Q(\leddbcfr[0] ), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcfr_reg[1]  (.CK(ledd_clk_1), .D(n13), .Q(\leddbcfr[1] ), 
     .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcfr_reg[2]  (.CK(ledd_clk_1), .D(n14), .Q(\leddbcfr[2] ), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcfr_reg[3]  (.CK(ledd_clk_1), 
     .D(n15), .Q(\leddbcfr[3] ), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcfr_reg[5]  (.CK(ledd_clk_1), .D(n16), 
     .Q(\leddbcfr[5] ), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcfr_reg[6]  (.CK(ledd_clk_1), .D(n17), .Q(\leddbcfr[6] ), 
     .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddbcfr_reg[7]  (.CK(ledd_clk_1), .D(n18), .Q(\leddbcfr[7] ), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddonr_reg[0]  (.CK(n40), 
     .D(ledd_dat_0_1), .Q(leddonr[0]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddonr_reg[1]  (.CK(n40), .D(ledd_dat_1_1), 
     .Q(leddonr[1]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddonr_reg[2]  (.CK(n40), .D(ledd_dat_2_1), .Q(leddonr[2]), 
     .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddonr_reg[3]  (.CK(n40), .D(ledd_dat_3_1), .Q(leddonr[3]), .RD(n11));
  SEH_FDPRBQ_V2_3 \ledd_sci_inst/leddonr_reg[4]  (.CK(n40), 
     .D(ledd_dat_4_1), .Q(leddonr[4]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddonr_reg[5]  (.CK(n40), .D(ledd_dat_5_1), 
     .Q(leddonr[5]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddonr_reg[6]  (.CK(n40), .D(ledd_dat_6_1), .Q(leddonr[6]), 
     .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddonr_reg[7]  (.CK(n40), .D(ledd_dat_7_1), .Q(leddonr[7]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwrr_reg[0]  (.CK(n36), 
     .D(ledd_dat_0_1), .Q(leddpwrr[0]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwrr_reg[1]  (.CK(n36), .D(ledd_dat_1_1), 
     .Q(leddpwrr[1]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwrr_reg[2]  (.CK(n36), .D(ledd_dat_2_1), .Q(leddpwrr[2]), 
     .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwrr_reg[3]  (.CK(n36), .D(ledd_dat_3_1), .Q(leddpwrr[3]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwrr_reg[4]  (.CK(n36), 
     .D(ledd_dat_4_1), .Q(leddpwrr[4]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwrr_reg[5]  (.CK(n36), .D(ledd_dat_5_1), 
     .Q(leddpwrr[5]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwrr_reg[6]  (.CK(n36), .D(ledd_dat_6_1), .Q(leddpwrr[6]), 
     .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwrr_reg[7]  (.CK(n36), .D(ledd_dat_7_1), .Q(leddpwrr[7]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwgr_reg[0]  (.CK(n35), 
     .D(ledd_dat[0]), .Q(leddpwgr[0]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwgr_reg[1]  (.CK(n35), .D(ledd_dat[1]), 
     .Q(leddpwgr[1]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwgr_reg[2]  (.CK(n35), .D(ledd_dat_2_1), .Q(leddpwgr[2]), 
     .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwgr_reg[3]  (.CK(n35), .D(ledd_dat[3]), .Q(leddpwgr[3]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwgr_reg[4]  (.CK(n35), 
     .D(ledd_dat_4_1), .Q(leddpwgr[4]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwgr_reg[5]  (.CK(n35), .D(ledd_dat_5_1), 
     .Q(leddpwgr[5]), .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwgr_reg[6]  (.CK(n35), .D(ledd_dat_6_1), .Q(leddpwgr[6]), 
     .RD(n11));
  SEH_FDPRBQ_1 \ledd_sci_inst/leddpwgr_reg[7]  (.CK(n35), .D(ledd_dat_7_1), .Q(leddpwgr[7]), .RD(n11));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_sci_10 Model:SNPS_CLOCK_GATE_HIGH_ledd_sci_10 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_sci_10 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_2 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_sci_11 Model:SNPS_CLOCK_GATE_HIGH_ledd_sci_11 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_sci_11 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_4 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_sci_12 Model:SNPS_CLOCK_GATE_HIGH_ledd_sci_12 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_sci_12 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_4 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_sci_13 Model:SNPS_CLOCK_GATE_HIGH_ledd_sci_13 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_sci_13 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_2 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_sci_14 Model:SNPS_CLOCK_GATE_HIGH_ledd_sci_14 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_sci_14 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_2 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_sci_15 Model:SNPS_CLOCK_GATE_HIGH_ledd_sci_15 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_sci_15 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_2 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_sci_9 Model:SNPS_CLOCK_GATE_HIGH_ledd_sci_9 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_sci_9 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_6 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:ledd_ctrl Model:ledd_ctrl Library:magma_checknetlist_lib
module ledd_ctrl (pwm_out_r, pwm_out_g, pwm_out_b, ledd_on, ledd_rst_async, 
     ledd_clk, ledd_exe, leddcr0, leddbr, leddonr, leddofr, leddbcrr, leddbcfr, 
     leddpwrr, leddpwgr, leddpwbr, ledd_clk_1, ledd_clk_3, ledd_clk_4);
  input ledd_rst_async, ledd_clk, ledd_exe, ledd_clk_1, ledd_clk_3, ledd_clk_4;
  output pwm_out_r, pwm_out_g, pwm_out_b, ledd_on;
  input [7:0] leddcr0;
  input [7:0] leddbr;
  input [7:0] leddonr;
  input [7:0] leddofr;
  input [7:0] leddbcrr;
  input [7:0] leddbcfr;
  input [7:0] leddpwrr;
  input [7:0] leddpwgr;
  input [7:0] leddpwbr;
  wire [3:0] state;
  wire [9:0] ledd_pscnt;
  wire [2:0] ledd_exe_sense;
  wire [7:0] ledd_pwmcnt;
  wire [3:0] next_state;
  wire [19:0] time_cnt;
  wire [8:0] t_mult;
  wire [3:0] mult_cnt;
  wire [7:0] skew_delay_g;
  wire [15:0] skew_delay_b;
  wire n910, n911, n912, n913, n4510, n4810, n7110, n7210, n7310, n7410, n7510, 
     n7610, n7710, n7810, n7910, n8010, ledd_ps32k, n920, n1200, n1210, n1220, 
     n1230, n1240, n1250, n1260, n1270, n2510, n2520, n2530, n2540, n2550, 
     n2560, n2570, n2580, n2590, n2600, n2610, n2620, n2630, n2640, n2650, 
     n2660, n2670, n2680, n2690, n2700, n2710, n3380, n3390, n3400, n3410, 
     ledd_pwm_out_r, ledd_pwm_out_g, ledd_pwm_out_b, n3440, n3540, n3550, 
     ledd_on_int, alt14_n129, net929, net932, net935, net938, net941, net944, 
     net947, net950, net953, pwmc_r_n118, pwmc_r_n104, pwmc_r_n103, pwmc_r_n102, 
     pwmc_r_n101, pwmc_r_n100, pwmc_r_n99, pwmc_r_n98, pwmc_r_n97, pwmc_r_n96, 
     pwmc_r_n95, pwmc_r_n94, pwmc_r_n93, pwmc_r_n92, pwmc_r_n91, pwmc_r_n90, 
     pwmc_r_n89, pwmc_r_n88, pwmc_r_n75, pwmc_r_n74, pwmc_r_n73, pwmc_r_n72, 
     pwmc_r_n71, pwmc_r_n70, pwmc_r_n69, pwmc_r_n68, pwmc_r_n67, pwmc_r_n66, 
     pwmc_r_n65, pwmc_r_n64, pwmc_r_n63, pwmc_r_n62, pwmc_r_n61, pwmc_r_n60, 
     pwmc_r_n59, pwmc_r_n22, \pwmc_r_step[0] , \pwmc_r_step[1] , 
     \pwmc_r_step[2] , \pwmc_r_step[3] , \pwmc_r_step[4] , \pwmc_r_step[5] , 
     \pwmc_r_step[6] , \pwmc_r_step[7] , \pwmc_r_step[8] , \pwmc_r_step[9] , 
     \pwmc_r_step[10] , \pwmc_r_step[11] , \pwmc_r_step[12] , \pwmc_r_step[13] , 
     \pwmc_r_step[14] , \pwmc_r_step[15] , \pwmc_r_accum[0] , \pwmc_r_accum[1] , 
     \pwmc_r_accum[2] , \pwmc_r_accum[3] , \pwmc_r_accum[4] , \pwmc_r_accum[5] , 
     \pwmc_r_accum[6] , \pwmc_r_accum[7] , \pwmc_r_accum[8] , \pwmc_r_accum[9] , 
     \pwmc_r_accum[10] , \pwmc_r_accum[11] , \pwmc_r_accum[12] , 
     \pwmc_r_accum[13] , \pwmc_r_accum[14] , \pwmc_r_accum[15] , 
     \pwmc_r_accum[16] , pwmc_g_n118, pwmc_g_n104, pwmc_g_n103, pwmc_g_n102, 
     pwmc_g_n101, pwmc_g_n100, pwmc_g_n99, pwmc_g_n98, pwmc_g_n97, pwmc_g_n96, 
     pwmc_g_n95, pwmc_g_n94, pwmc_g_n93, pwmc_g_n92, pwmc_g_n91, pwmc_g_n90, 
     pwmc_g_n89, pwmc_g_n75, pwmc_g_n74, pwmc_g_n73, pwmc_g_n72, pwmc_g_n71, 
     pwmc_g_n70, pwmc_g_n69, pwmc_g_n68, pwmc_g_n67, pwmc_g_n66, pwmc_g_n65, 
     pwmc_g_n64, pwmc_g_n63, pwmc_g_n62, pwmc_g_n61, pwmc_g_n60, pwmc_g_n59, 
     \pwmc_g_step[0] , \pwmc_g_step[1] , \pwmc_g_step[2] , \pwmc_g_step[3] , 
     \pwmc_g_step[4] , \pwmc_g_step[5] , \pwmc_g_step[6] , \pwmc_g_step[7] , 
     \pwmc_g_step[8] , \pwmc_g_step[9] , \pwmc_g_step[10] , \pwmc_g_step[11] , 
     \pwmc_g_step[12] , \pwmc_g_step[13] , \pwmc_g_step[14] , \pwmc_g_step[15] , 
     \pwmc_g_accum[0] , \pwmc_g_accum[1] , \pwmc_g_accum[2] , \pwmc_g_accum[3] , 
     \pwmc_g_accum[4] , \pwmc_g_accum[5] , \pwmc_g_accum[6] , \pwmc_g_accum[7] , 
     \pwmc_g_accum[8] , \pwmc_g_accum[9] , \pwmc_g_accum[10] , 
     \pwmc_g_accum[11] , \pwmc_g_accum[12] , \pwmc_g_accum[13] , 
     \pwmc_g_accum[14] , \pwmc_g_accum[15] , \pwmc_g_accum[16] , pwmc_b_net979, 
     pwmc_b_n118, pwmc_b_n104, pwmc_b_n103, pwmc_b_n102, pwmc_b_n101, 
     pwmc_b_n100, pwmc_b_n99, pwmc_b_n98, pwmc_b_n97, pwmc_b_n96, pwmc_b_n95, 
     pwmc_b_n94, pwmc_b_n93, pwmc_b_n92, pwmc_b_n91, pwmc_b_n90, pwmc_b_n89, 
     pwmc_b_n75, pwmc_b_n74, pwmc_b_n73, pwmc_b_n72, pwmc_b_n71, pwmc_b_n70, 
     pwmc_b_n69, pwmc_b_n68, pwmc_b_n67, pwmc_b_n66, pwmc_b_n65, pwmc_b_n64, 
     pwmc_b_n63, pwmc_b_n62, pwmc_b_n61, pwmc_b_n60, pwmc_b_n59, 
     \pwmc_b_step[0] , \pwmc_b_step[1] , \pwmc_b_step[2] , \pwmc_b_step[3] , 
     \pwmc_b_step[4] , \pwmc_b_step[5] , \pwmc_b_step[6] , \pwmc_b_step[7] , 
     \pwmc_b_step[8] , \pwmc_b_step[9] , \pwmc_b_step[10] , \pwmc_b_step[11] , 
     \pwmc_b_step[12] , \pwmc_b_step[13] , \pwmc_b_step[14] , \pwmc_b_step[15] , 
     \pwmc_b_accum[0] , \pwmc_b_accum[1] , \pwmc_b_accum[2] , \pwmc_b_accum[3] , 
     \pwmc_b_accum[4] , \pwmc_b_accum[5] , \pwmc_b_accum[6] , \pwmc_b_accum[7] , 
     \pwmc_b_accum[8] , \pwmc_b_accum[9] , \pwmc_b_accum[10] , 
     \pwmc_b_accum[11] , \pwmc_b_accum[12] , \pwmc_b_accum[13] , 
     \pwmc_b_accum[14] , \pwmc_b_accum[15] , \pwmc_b_accum[16] , n1, n292, n2, 
     n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, 
     n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, 
     n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, 
     n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, 
     n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, 
     n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, 
     n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, 
     n107, n108, n109, n110, n111, n112, n113, n114, n115, n116, n117, n118, 
     n119, n120, n121, n122, n123, n124, n125, n126, n127, n128, n129, n130, 
     n131, n132, n133, n134, n135, n136, n137, n138, n139, n140, n141, n142, 
     n143, n144, n145, n146, n148, n149, n150, n152, n154, n156, n160, n161, 
     n162, n163, n165, n166, n167, n169, n170, n171, n172, n173, n174, n175, 
     n176, n177, n178, n179, n180, n181, n182, n183, n184, n185, n186, n187, 
     n188, n189, n190, n191, n192, n193, n194, n195, n196, n197, n198, n199, 
     n200, n201, n202, n203, n204, n205, n206, n207, n208, n209, n210, n211, 
     n212, n213, n214, n215, n216, n217, n218, n219, n220, n221, n222, n223, 
     n224, n225, n226, n227, n228, n229, n230, n231, n232, n233, n234, n235, 
     n236, n237, n238, n239, n240, n241, n242, n243, n244, n245, n246, n247, 
     n248, n249, n250, n251, n252, n253, n254, n255, n256, n257, n258, n259, 
     n260, n261, n262, n263, n264, n265, n266, n267, n268, n269, n270, n271, 
     n272, n273, n274, n275, n276, n277, n278, n279, n280, n281, n282, n283, 
     n284, n286, n287, n288, n289, n290, n291, n293, n294, n295, n296, n297, 
     n298, n299, n300, n301, n302, n303, n304, n305, n306, n307, n308, n309, 
     n310, n311, n312, n313, n314, n315, n316, n317, n318, n319, n320, n321, 
     n322, n323, n324, n325, n326, n327, n328, n329, n330, n331, n332, n333, 
     n334, n335, n336, n337, n338, n339, n340, n341, n342, n343, n344, n345, 
     n346, n347, n348, n349, n350, n351, n352, n353, n354, n355, n356, n357, 
     n358, n359, n360, n361, n362, n363, n364, n365, n366, n367, n368, n369, 
     n370, n371, n372, n373, n374, n375, n376, n377, n378, n379, n380, n381, 
     n382, n383, n384, n385, n386, n387, n388, n389, n390, n391, n392, n393, 
     n394, n395, n396, n397, n398, n399, n400, n401, n402, n403, n404, n405, 
     n406, n407, n408, n409, n410, n411, n412, n413, n414, n415, n416, n417, 
     n418, n419, n420, n421, n422, n423, n424, n425, n426, n427, n428, n429, 
     n430, n431, n432, n433, n434, n435, n436, n437, n438, n439, n440, n441, 
     n442, n443, n444, n445, n446, n447, n448, n449, n450, n451, n452, n453, 
     n454, n455, n456, n457, n458, n459, n460, n461, n462, n463, n464, n466, 
     n467, n468, n469, n470, n471, n472, n473, n474, n475, n476, n477, n478, 
     n479, n480, n481, n482, n483, n484, n485, n486, n487, n488, n489, n490, 
     n491, n492, n493, n494, n495, n496, n497, n498, n499, n500, n501, n502, 
     n503, n504, n505, n506, n507, n508, n509, n510, n511, n512, n513, n514, 
     n515, n516, n517, n518, n519, n520, n521, n522, n523, n524, n525, n526, 
     n527, n528, n529, n530, n531, n532, n533, n534, n535, n536, n537, n538, 
     n539, n540, n541, n542, n543, n544, n545, n546, n547, n548, n549, n550, 
     n551, n552, n553, n554, n555, n556, n557, n558, n559, n560, n561, n562, 
     n563, n564, n565, n566, n567, n568, n569, n570, n571, n572, n573, n574, 
     n575, n576, n577, n578, n579, n580, n581, n582, n583, n584, n585, n586, 
     n587, n588, n589, n590, n591, n592, n593, n594, n595, n596, n597, n598, 
     n599, n600, n601, n602, n603, n604, n605, n606, n607, n608, n609, n610, 
     n611, n612, n613, n614, n615, n616, n617, n618, n619, n620, n621, n622, 
     n623, n624, n625, n626, n627, n628, n629, n630, n631, n632, n633, n634, 
     n635, n636, n637, n638, n639, n640, n641, n642, n643, n644, n645, n646, 
     n647, n648, n649, n650, n651, n652, n653, n654, n655, n656, n657, n658, 
     n659, n660, n661, n662, n663, n664, n665, n666, n667, n668, n669, n670, 
     n671, n672, n673, n674, n675, n676, n677, n678, n679, n680, n681, n682, 
     n683, n684, n685, n686, n687, n688, n689, n690, n691, n692, n693, n694, 
     n695, n696, n697, n698, n699, n700, n701, n702, n703, n704, n705, n706, 
     n707, n708, n709, n710, n711, n712, n713, n714, n715, n716, n717, n718, 
     n719, n720, n721, n722, n723, n724, n725, n726, n727, n728, n729, n730, 
     n731, n732, n733, n734, n735, n736, n737, n738, n739, n740, n741, n742, 
     n743, n744, n745, n746, n747, n748, n749, n750, n751, n752, n753, n754, 
     n755, n756, n757, n758, n759, n760, n761, n762, n763, n764, n765, n766, 
     n767, n768, n769, n770, n771, n772, n773, n774, n775, n776, n777, n778, 
     n779, n780, n781, n782, n783, n784, n785, n786, n787, n788, n789, n790, 
     n791, n792, n793, n794, n795, n796, n797, n798, n799, n800, n801, n802, 
     n803, n804, n805, n806, n807, n808, n809, n810, n811, n812, n813, n814, 
     n815, n816, n817, n818, n819, n820, n821, n822, n823, n824, n825, n826, 
     n827, n828, n829, n830, n831, n832, n833, n834, n835, n836, n837, n838, 
     n839, n840, n841, n842, n843, n844, n845, n846, n847, n848, n849, n850, 
     n851, n852, n853, n854, n855, n856, n857, n858, n859, n860, n861, n862, 
     n863, n864, n865, n866, n867, n868, n869, n870, n871, n872, n873, n874, 
     n875, n876, n877, n878, n879, n880, n881, n882, n883, n884, n885, n886, 
     n887, n888, n889, n890, n891, n892, n893, n894, n895, n896, n897, n898, 
     n899, n900, n901, n903, n904, n905, n906, n907, n908, n909, n167_1, n147_2, 
     n149_1, n159_2, n158_2, n162_2, n164_2, n168_2, n168, n902, n158, n159, 
     n162_1, n147, n909_1, n908_1, pwmc_r_n118_1;
  SEH_NR2_1 U539 (.A1(n170), .A2(n768), .X(n175));
  SEH_AOI21B_1 U89 (.A1(n757), .A2(n54), .B(leddpwrr[7]), .X(n79));
  SEH_MAJI3_1 U84 (.A1(n67), .A2(n763), .A3(n73), .X(n74));
  SEH_ND2B_1 U910 (.A(n443), .B(ledd_pwmcnt[5]), .X(n440));
  SEH_OAI21_S_1 U304 (.A1(time_cnt[0]), .A2(n282), .B(n242), .X(n2520));
  SEH_MUX2_G_1 U708 (.D0(n698), .D1(n697), .S(n696), .X(n699));
  SEH_MAJI3_1 U1060 (.A1(n901), .A2(n859), .A3(n857), .X(n860));
  SEH_MUX2_G_1 U593 (.D0(n527), .D1(n526), .S(n525), .X(n528));
  SEH_NR2_1 U32 (.A1(ledd_pwmcnt[1]), .A2(n25), .X(n26));
  SEH_AN2_S_1 U34 (.A1(n25), .A2(ledd_pwmcnt[1]), .X(n28));
  SEH_OAI211_1 U997 (.A1(n868), .A2(n684), .B1(n683), .B2(n682), .X(pwmc_g_n70));
  SEH_OAI211_1 U994 (.A1(n868), .A2(n675), .B1(n674), .B2(n673), .X(pwmc_g_n69));
  SEH_OAI211_1 U1021 (.A1(n902), .A2(n743), .B1(n742), .B2(n893), .X(pwmc_g_n95));
  SEH_OAI22_S_1 U784 (.A1(n902), .A2(n747), .B1(n897), .B2(n746), .X(pwmc_g_n97));
  SEH_AOI22_1 U341 (.A1(n900), .A2(\pwmc_g_step[5] ), .B1(leddpwgr[6]), 
     .B2(n162_2), .X(n742));
  SEH_OAI211_1 U947 (.A1(n868), .A2(n555), .B1(n554), .B2(n553), .X(pwmc_b_n71));
  SEH_OA22_1 U953 (.A1(n158_2), .A2(n573), .B1(n159_2), .B2(n574), .X(n569));
  SEH_AOI22_1 U255 (.A1(n148), .A2(n668), .B1(n147_2), .B2(n669), .X(n664));
  SEH_OAI22_S_1 U781 (.A1(n902), .A2(n584), .B1(n897), .B2(n541), 
     .X(pwmc_b_n100));
  SEH_EN2_1 U521 (.A1(\pwmc_g_step[9] ), .A2(n741), .X(n662));
  SEH_INV_S_1 U730 (.A(\pwmc_g_step[7] ), .X(n746));
  SEH_OAI211_1 U1022 (.A1(n902), .A2(n745), .B1(n744), .B2(n893), .X(pwmc_g_n96));
  SEH_MAJI3_1 U989 (.A1(\pwmc_g_step[8] ), .A2(\pwmc_g_accum[8] ), .A3(n658), 
     .X(n661));
  SEH_AOI22_1 U322 (.A1(n900), .A2(\pwmc_g_step[4] ), .B1(leddpwgr[5]), 
     .B2(n162_2), .X(n740));
  SEH_INV_S_1 U649 (.A(leddpwgr[0]), .X(n667));
  SEH_MAJI3_1 U986 (.A1(\pwmc_g_accum[7] ), .A2(n746), .A3(n655), .X(n659));
  SEH_MAJI3_1 U952 (.A1(n614), .A2(\pwmc_b_step[13] ), .A3(n566), .X(n574));
  SEH_MAJI3_1 U990 (.A1(\pwmc_g_step[8] ), .A2(n659), .A3(n739), .X(n660));
  SEH_AN2_S_1 U221 (.A1(\pwmc_b_step[13] ), .A2(n900), .X(pwmc_b_n103));
  SEH_MAJI3_1 U951 (.A1(n565), .A2(\pwmc_b_accum[13] ), .A3(\pwmc_b_step[13] ), 
     .X(n573));
  SEH_MUX2_G_1 U648 (.D0(n664), .D1(n663), .S(n662), .X(n665));
  SEH_AOI22_1 U244 (.A1(n148), .A2(n573), .B1(n149_1), .B2(n574), .X(n568));
  SEH_INV_S_1 U728 (.A(n661), .X(n668));
  SEH_INV_S_1 U377 (.A(n856), .X(n802));
  SEH_INV_S_1 U623 (.A(n523), .X(n532));
  SEH_AOI22_1 U239 (.A1(n161), .A2(n531), .B1(n147_2), .B2(n532), .X(n527));
  SEH_OAI211_1 U934 (.A1(n802), .A2(n530), .B1(n519), .B2(n801), .X(pwmc_b_n67));
  SEH_AOI22_1 U316 (.A1(n900), .A2(\pwmc_b_step[3] ), .B1(leddpwbr[4]), 
     .B2(n162_2), .X(n604));
  SEH_AOI22_1 U288 (.A1(n161), .A2(n524), .B1(n147_2), .B2(n523), .X(n526));
  SEH_MAJI3_1 U1057 (.A1(n847), .A2(\pwmc_r_accum[13] ), .A3(\pwmc_r_step[13] ), 
     .X(n857));
  SEH_AOI22_1 U251 (.A1(n148), .A2(n847), .B1(n149_1), .B2(n848), .X(n843));
  SEH_EN2_1 U526 (.A1(n869), .A2(\pwmc_r_step[15] ), .X(n862));
  SEH_OA22_1 U301 (.A1(n158_2), .A2(n847), .B1(n159_2), .B2(n848), .X(n842));
  SEH_INV_S_1 U624 (.A(\pwmc_b_accum[8] ), .X(n605));
  SEH_MAJI3_1 U939 (.A1(n607), .A2(\pwmc_b_step[9] ), .A3(n532), .X(n540));
  SEH_MAJI3_1 U935 (.A1(\pwmc_b_step[8] ), .A2(\pwmc_b_accum[8] ), .A3(n521), 
     .X(n524));
  SEH_NR2_1 U452 (.A1(n897), .A2(n859), .X(pwmc_r_n104));
  SEH_INV_S_1 U654 (.A(\pwmc_r_step[14] ), .X(n859));
  SEH_AOI22_1 U318 (.A1(n900), .A2(\pwmc_b_step[4] ), .B1(leddpwbr[5]), 
     .B2(n162_2), .X(n606));
  SEH_OAI211_1 U59 (.A1(n802), .A2(n812), .B1(n801), .B2(n50), .X(pwmc_r_n67));
  SEH_MUX2_G_1 U664 (.D0(n851), .D1(n850), .S(n849), .X(n852));
  SEH_MAJI3_1 U1058 (.A1(n899), .A2(\pwmc_r_step[13] ), .A3(n848), .X(n858));
  SEH_OAI211_1 U967 (.A1(n164_2), .A2(n607), .B1(n606), .B2(n163), 
     .X(pwmc_b_n94));
  SEH_EN2_1 U530 (.A1(n899), .A2(\pwmc_r_step[13] ), .X(n841));
  SEH_OAI211_1 U966 (.A1(n164_2), .A2(n605), .B1(n604), .B2(n163), 
     .X(pwmc_b_n93));
  SEH_OAI22_S_1 U783 (.A1(n902), .A2(n869), .B1(n897), .B2(n823), 
     .X(pwmc_r_n100));
  SEH_OAI22_S_1 U13 (.A1(leddcr0[6]), .A2(\pwmc_g_accum[15] ), .B1(n169), 
     .B2(\pwmc_g_accum[16] ), .X(n7));
  SEH_AOAI211_1 U44 (.A1(n768), .A2(n27), .B(n26), .C(n30), .X(n39));
  SEH_MAJI3_1 U904 (.A1(n412), .A2(n564), .A3(n437), .X(n414));
  SEH_MUX2_G_1 U391 (.D0(n427), .D1(leddpwbr[3]), .S(n438), .X(n433));
  SEH_MAJI3_1 U68 (.A1(leddpwrr[7]), .A2(n57), .A3(n54), .X(n58));
  SEH_NR2_1 U78 (.A1(n763), .A2(n67), .X(n68));
  SEH_ND2_S_1 U399 (.A1(n174), .A2(n328), .X(n1210));
  SEH_AOI21_S_1 U804 (.A1(leddpwrr[7]), .A2(n856), .B(n855), .X(n866));
  SEH_ND2_S_1 U321 (.A1(leddpwbr[0]), .A2(n162_2), .X(n596));
  SEH_NR2_1 U453 (.A1(n897), .A2(n840), .X(pwmc_r_n102));
  SEH_INV_S_2 U749 (.A(n801), .X(n855));
  SEH_EN2_1 U523 (.A1(n901), .A2(\pwmc_r_step[14] ), .X(n849));
  SEH_MAJ3_1 U17 (.A1(leddpwgr[6]), .A2(n9), .A3(n10), .X(n11));
  SEH_EN2_1 U515 (.A1(n721), .A2(\pwmc_g_step[15] ), .X(n715));
  SEH_OAI211_1 U1008 (.A1(n868), .A2(n709), .B1(n708), .B2(n707), .X(pwmc_g_n73));
  SEH_INV_S_1 U709 (.A(\pwmc_g_accum[13] ), .X(n748));
  SEH_INV_S_1 U575 (.A(n188), .X(n191));
  SEH_OAI211_1 U1059 (.A1(n868), .A2(n854), .B1(n853), .B2(n852), .X(pwmc_r_n73));
  SEH_NR2_1 U225 (.A1(n249), .A2(n248), .X(n251));
  SEH_AOI211_1 U848 (.A1(n253), .A2(n252), .B1(n255), .B2(n282), .X(n2580));
  SEH_OAI211_1 U817 (.A1(n189), .A2(ledd_pwmcnt[6]), .B1(n188), .B2(n192), 
     .X(n190));
  SEH_AOI22_1 U290 (.A1(n148), .A2(n702), .B1(n147_2), .B2(n703), .X(n698));
  SEH_ND2_S_1 U38 (.A1(n24), .A2(n31), .X(n32));
  SEH_AOI21_S_1 U357 (.A1(n856), .A2(leddpwgr[5]), .B(n855), .X(n700));
  SEH_MUX2_G_1 U393 (.D0(n430), .D1(n538), .S(n438), .X(n432));
  SEH_NR4_1 U912 (.A1(n564), .A2(n555), .A3(n547), .A4(n538), .X(n453));
  SEH_MAJI3_1 U66 (.A1(n2), .A2(n854), .A3(n765), .X(n56));
  SEH_OA21B_1 U1025 (.A1(n837), .A2(n759), .B(n755), .X(n756));
  SEH_AOAI211_1 U380 (.A1(n448), .A2(n768), .B(n447), .C(n446), .X(n451));
  SEH_NR2_1 U388 (.A1(ledd_pwmcnt[1]), .A2(n432), .X(n447));
  SEH_NR2_S_1 U83 (.A1(n69), .A2(ledd_pwmcnt[2]), .X(n73));
  SEH_AN2_S_1 U80 (.A1(n69), .A2(ledd_pwmcnt[2]), .X(n70));
  SEH_NR2_S_1 U386 (.A1(n436), .A2(ledd_pwmcnt[2]), .X(n429));
  SEH_INV_S_1 U661 (.A(n713), .X(n722));
  SEH_AOI22_1 U286 (.A1(n148), .A2(n710), .B1(n147_2), .B2(n711), .X(n705));
  SEH_MAJI3_1 U959 (.A1(\pwmc_b_accum[15] ), .A2(n587), .A3(n586), .X(n589));
  SEH_AOI22_1 U253 (.A1(n161), .A2(n685), .B1(n149_1), .B2(n686), .X(n681));
  SEH_INV_S_1 U606 (.A(leddpwbr[6]), .X(n583));
  SEH_OA22_1 U308 (.A1(n158_2), .A2(n685), .B1(n159_2), .B2(n686), .X(n680));
  SEH_INV_S_3 U751 (.A(n876), .X(n868));
  SEH_MUX2_G_1 U392 (.D0(n428), .D1(n547), .S(n438), .X(n436));
  SEH_NR2B_1 U442 (.A(n408), .B(n407), .X(n410));
  SEH_AO22_1 U79 (.A1(n60), .A2(n760), .B1(n829), .B2(n59), .X(n69));
  SEH_AO21B_1 U902 (.A1(n410), .A2(n428), .B(n409), .X(n411));
  SEH_ND2_S_1 U471 (.A1(n555), .A2(n427), .X(n408));
  SEH_EN2_1 U516 (.A1(n749), .A2(\pwmc_g_step[14] ), .X(n704));
  SEH_AOI211_1 U908 (.A1(ledd_pwmcnt[2]), .A2(n436), .B1(n435), .B2(n434), 
     .X(n446));
  SEH_ND2B_S_1 U69 (.A(n58), .B(n757), .X(n59));
  SEH_NR2_1 U92 (.A1(ledd_pwmcnt[6]), .A2(n78), .X(n83));
  SEH_AOI222_2 U828 (.A1(n239), .A2(n347), .B1(n455), .B2(leddofr[2]), .C1(n214), 
     .C2(leddonr[2]), .X(n224));
  SEH_MAJI3_1 U16 (.A1(n3), .A2(n709), .A3(n628), .X(n10));
  SEH_AOI22_1 U180 (.A1(n148), .A2(n857), .B1(n149_1), .B2(n858), .X(n850));
  SEH_AOI21_S_1 U802 (.A1(leddpwbr[7]), .A2(n856), .B(n855), .X(n582));
  SEH_NR2_1 U29 (.A1(n21), .A2(ledd_pwmcnt[2]), .X(n23));
  SEH_AOI211_1 U36 (.A1(ledd_pwmcnt[2]), .A2(n21), .B1(n28), .B2(n29), .X(n30));
  SEH_AOAI211_1 U47 (.A1(n24), .A2(n39), .B(n20), .C(n40), .X(n41));
  SEH_INV_S_1 U711 (.A(leddpwgr[4]), .X(n701));
  SEH_MAJI3_1 U87 (.A1(n61), .A2(n76), .A3(ledd_pwmcnt[5]), .X(n77));
  SEH_MUX2_G_1 U74 (.D0(n761), .D1(n820), .S(n59), .X(n64));
  SEH_OAI31_1 U100 (.A1(n846), .A2(n854), .A3(n89), .B(n84), .X(n90));
  SEH_MUX2_G_1 U88 (.D0(n55), .D1(n867), .S(n59), .X(n78));
  SEH_MAJI3_1 U93 (.A1(n758), .A2(n79), .A3(n83), .X(n84));
  SEH_INV_S_1 U748 (.A(ledd_pwmcnt[1]), .X(n170));
  SEH_MAJI3_1 U40 (.A1(n18), .A2(n33), .A3(ledd_pwmcnt[5]), .X(n34));
  SEH_MUX2_G_1 U20 (.D0(n9), .D1(n720), .S(n13), .X(n14));
  SEH_NR2_1 U35 (.A1(n763), .A2(n22), .X(n29));
  SEH_INV_S_1 U763 (.A(n213), .X(n212));
  SEH_INV_S_1 U586 (.A(time_cnt[6]), .X(n252));
  SEH_MUX2_G_1 U390 (.D0(n437), .D1(leddpwbr[4]), .S(n438), .X(n441));
  SEH_NR2_1 U427 (.A1(n192), .A2(n758), .X(n462));
  SEH_AOI22_1 U485 (.A1(leddcr0[6]), .A2(n749), .B1(n748), .B2(n169), .X(n628));
  SEH_MAJI3_1 U30 (.A1(n22), .A2(n763), .A3(n23), .X(n24));
  SEH_OAI22_S_1 U64 (.A1(leddcr0[6]), .A2(\pwmc_r_accum[15] ), .B1(n169), 
     .B2(\pwmc_r_accum[16] ), .X(n54));
  SEH_AOAI211_1 U360 (.A1(n452), .A2(n444), .B(n450), .C(n449), .X(n445));
  SEH_NR4_1 U98 (.A1(n820), .A2(n829), .A3(n837), .A4(n812), .X(n88));
  SEH_INV_S_1 U657 (.A(leddpwrr[1]), .X(n820));
  SEH_ND2_S_1 U86 (.A1(n766), .A2(n62), .X(n76));
  SEH_AN2_S_1 U385 (.A1(n432), .A2(ledd_pwmcnt[1]), .X(n435));
  SEH_MAJI3_1 U907 (.A1(n763), .A2(n433), .A3(n429), .X(n452));
  SEH_MAJI3_1 U1007 (.A1(n748), .A2(\pwmc_g_step[13] ), .A3(n703), .X(n711));
  SEH_OAI31_1 U909 (.A1(n447), .A2(n448), .A3(n768), .B(n446), .X(n444));
  SEH_OAI211_1 U809 (.A1(n175), .A2(ledd_pwmcnt[2]), .B1(n188), .B2(n178), 
     .X(n176));
  SEH_INV_S_1 U659 (.A(\pwmc_g_accum[15] ), .X(n721));
  SEH_MAJI3_1 U905 (.A1(n422), .A2(leddpwbr[6]), .A3(n416), .X(n418));
  SEH_AOI22_1 U65 (.A1(leddcr0[6]), .A2(\pwmc_r_accum[15] ), .B1(n169), 
     .B2(\pwmc_r_accum[14] ), .X(n55));
  SEH_MAJI3_1 U970 (.A1(n625), .A2(leddpwgr[1]), .A3(n616), .X(n617));
  SEH_MUX2_G_1 U213 (.D0(n439), .D1(leddpwbr[5]), .S(n438), .X(n443));
  SEH_INV_S_1 U645 (.A(leddpwbr[1]), .X(n538));
  SEH_MAJ3_1 U3 (.A1(n756), .A2(n846), .A3(n764), .X(n2));
  SEH_OA21B_1 U903 (.A1(n555), .A2(n427), .B(n411), .X(n412));
  SEH_INV_S_1 U655 (.A(leddpwrr[6]), .X(n867));
  SEH_MAJ3_1 U67 (.A1(leddpwrr[6]), .A2(n55), .A3(n56), .X(n57));
  SEH_AO22_1 U72 (.A1(n60), .A2(n764), .B1(leddpwrr[4]), .B2(n59), .X(n62));
  SEH_MUX2_G_1 U389 (.D0(n431), .D1(leddpwbr[0]), .S(n438), .X(n448));
  SEH_INV_S_1 U663 (.A(leddpwgr[6]), .X(n720));
  SEH_AOI21_S_1 U362 (.A1(n856), .A2(leddpwgr[6]), .B(n855), .X(n708));
  SEH_MUX2_G_1 U28 (.D0(n623), .D1(leddpwgr[3]), .S(n13), .X(n22));
  SEH_INV_S_1 U744 (.A(n187), .X(n189));
  SEH_AO2BB2_1 U73 (.A1(n62), .A2(n766), .B1(ledd_pwmcnt[5]), .B2(n61), .X(n63));
  SEH_OAI211_1 U810 (.A1(n194), .A2(n177), .B1(n328), .B2(n176), .X(n1220));
  SEH_AOI21_S_1 U788 (.A1(n170), .A2(n768), .B(n175), .X(n172));
  SEH_OA2BB2_1 U90 (.A1(ledd_pwmcnt[6]), .A2(n78), .B1(n758), .B2(n79), .X(n80));
  SEH_AOI22_1 U808 (.A1(ledd_pwmcnt[2]), .A2(n173), .B1(n172), .B2(n188), 
     .X(n174));
  SEH_NR2_1 U75 (.A1(ledd_pwmcnt[1]), .A2(n64), .X(n65));
  SEH_MAJI3_1 U1006 (.A1(n702), .A2(\pwmc_g_accum[13] ), .A3(\pwmc_g_step[13] ), 
     .X(n710));
  SEH_INV_S_1 U668 (.A(\pwmc_g_accum[14] ), .X(n749));
  SEH_INV_S_1 U662 (.A(\pwmc_g_step[14] ), .X(n712));
  SEH_MAJI3_1 U1013 (.A1(\pwmc_g_accum[15] ), .A2(n724), .A3(n723), .X(n726));
  SEH_AN2_S_1 U216 (.A1(\pwmc_g_step[13] ), .A2(n900), .X(pwmc_g_n103));
  SEH_AOI21_S_1 U42 (.A1(ledd_pwmcnt[6]), .A2(n14), .B(n35), .X(n36));
  SEH_MAJI3_1 U22 (.A1(n758), .A2(n8), .A3(n15), .X(n16));
  SEH_AOI22_1 U528 (.A1(ledd_pwmcnt[0]), .A2(n763), .B1(ledd_pwmcnt[3]), 
     .B2(n768), .X(n177));
  SEH_NR4_1 U48 (.A1(n701), .A2(n684), .A3(n675), .A4(n692), .X(n42));
  SEH_ND2_S_1 U463 (.A1(n251), .A2(time_cnt[5]), .X(n253));
  SEH_INV_S_1 U759 (.A(ledd_pscnt[3]), .X(n307));
  SEH_OAI211_1 U861 (.A1(time_cnt[17]), .A2(n277), .B1(n279), .B2(n276), 
     .X(n278));
  SEH_INV_S_1 U585 (.A(n266), .X(n267));
  SEH_NR2_1 U418 (.A1(n198), .A2(n354), .X(n202));
  SEH_MAJI3_1 U1010 (.A1(n712), .A2(n711), .A3(\pwmc_g_accum[14] ), .X(n714));
  SEH_INV_S_1 U750 (.A(leddpwgr[3]), .X(n692));
  SEH_INV_S_1 U46 (.A(n34), .X(n40));
  SEH_OAI21_1 U282 (.A1(\pwmc_g_accum[16] ), .A2(n729), .B(n728), .X(pwmc_g_n75));
  SEH_AOAI211_G_2 U326 (.A1(n461), .A2(n460), .B(n770), .C(n459), 
     .X(pwmc_b_n118));
  SEH_AOI22_1 U1014 (.A1(n876), .A2(leddpwgr[7]), .B1(\pwmc_g_accum[16] ), 
     .B2(n727), .X(n728));
  SEH_EN2_1 U513 (.A1(n748), .A2(\pwmc_g_step[13] ), .X(n696));
  SEH_OAI31_1 U50 (.A1(n720), .A2(n709), .A3(n43), .B(n16), .X(n44));
  SEH_AOI22_1 U24 (.A1(n17), .A2(n628), .B1(leddpwgr[5]), .B2(n13), .X(n18));
  SEH_AO22_1 U25 (.A1(n17), .A2(n627), .B1(leddpwgr[4]), .B2(n13), .X(n19));
  SEH_INV_S_1 U23 (.A(n13), .X(n17));
  SEH_AOI22_1 U473 (.A1(leddcr0[6]), .A2(n748), .B1(n747), .B2(n169), .X(n627));
  SEH_AOI211_1 U850 (.A1(n257), .A2(n256), .B1(n259), .B2(n282), .X(n2600));
  SEH_MAJ3_1 U4 (.A1(n622), .A2(n701), .A3(n627), .X(n3));
  SEH_OAI211_1 U1005 (.A1(n868), .A2(n701), .B1(n700), .B2(n699), .X(pwmc_g_n72));
  SEH_OAI21_S_1 U259 (.A1(n441), .A2(n766), .B(n440), .X(n450));
  SEH_AOAI211_1 U354 (.A1(n452), .A2(n451), .B(n450), .C(n449), .X(n457));
  SEH_NR2_1 U260 (.A1(n433), .A2(n763), .X(n434));
  SEH_OAI211_1 U1062 (.A1(n868), .A2(n867), .B1(n866), .B2(n865), .X(pwmc_r_n74));
  SEH_ND2_S_1 U496 (.A1(n175), .A2(ledd_pwmcnt[2]), .X(n178));
  SEH_AOI211_1 U81 (.A1(ledd_pwmcnt[1]), .A2(n64), .B1(n68), .B2(n70), .X(n71));
  SEH_AOAI211_1 U97 (.A1(n74), .A2(n85), .B(n63), .C(n86), .X(n87));
  SEH_ND4_S_1 U99 (.A1(leddpwrr[6]), .A2(leddpwrr[7]), .A3(n88), 
     .A4(leddbcfr[6]), .X(n89));
  SEH_OA22_1 U1004 (.A1(n158_2), .A2(n702), .B1(n159_2), .B2(n703), .X(n697));
  SEH_INV_S_1 U70 (.A(n59), .X(n60));
  SEH_AOI22_1 U71 (.A1(n60), .A2(n765), .B1(leddpwrr[5]), .B2(n59), .X(n61));
  SEH_ND4_S_1 U498 (.A1(leddpwbr[7]), .A2(leddpwbr[0]), .A3(leddbcfr[6]), 
     .A4(n453), .X(n454));
  SEH_OAI211_1 U812 (.A1(n766), .A2(n194), .B1(n328), .B2(n180), .X(n1230));
  SEH_OAI211_1 U811 (.A1(n179), .A2(ledd_pwmcnt[3]), .B1(n188), .B2(n181), 
     .X(n180));
  SEH_ND2_T_1 U19 (.A1(n757), .A2(n12), .X(n13));
  SEH_INV_S_24 U544 (.A(n150), .X(pwm_out_b));
  SEH_ND2_S_1 U432 (.A1(time_cnt[9]), .A2(n259), .X(n260));
  SEH_AOAI211_1 U43 (.A1(n37), .A2(n32), .B(n34), .C(n36), .X(n38));
  SEH_AOI21_S_1 U805 (.A1(leddpwgr[7]), .A2(n856), .B(n855), .X(n719));
  SEH_INV_S_1 U596 (.A(\pwmc_g_step[15] ), .X(n724));
  SEH_AOI22_1 U285 (.A1(n148), .A2(n713), .B1(n147_2), .B2(n714), .X(n717));
  SEH_MAJI3_1 U1012 (.A1(n722), .A2(n721), .A3(n724), .X(n725));
  SEH_ND2_S_1 U229 (.A1(n247), .A2(time_cnt[3]), .X(n249));
  SEH_INV_S_1 U745 (.A(ledd_pwmcnt[4]), .X(n766));
  SEH_ND2_S_1 U430 (.A1(n189), .A2(ledd_pwmcnt[6]), .X(n192));
  SEH_MUX2_G_1 U33 (.D0(n626), .D1(leddpwgr[0]), .S(n13), .X(n27));
  SEH_INV_S_1 U557 (.A(ledd_pwmcnt[3]), .X(n763));
  SEH_AO21B_1 U873 (.A1(leddbr[2]), .A2(n323), .B(n306), .X(n7310));
  SEH_AOI222_2 U834 (.A1(n239), .A2(n215), .B1(n455), .B2(leddofr[6]), .C1(n214), 
     .C2(leddonr[6]), .X(n229));
  SEH_EO2_1 U545 (.A1(leddcr0[5]), .A2(ledd_pwm_out_r), .X(n3440));
  SEH_OAI211_1 U820 (.A1(n768), .A2(n194), .B1(n328), .B2(n193), .X(n1270));
  SEH_AOI221_1 U836 (.A1(time_cnt[17]), .A2(n233), .B1(time_cnt[11]), .B2(n221), 
     .C(n220), .X(n222));
  SEH_INV_S_1 U587 (.A(time_cnt[4]), .X(n248));
  SEH_AOI22_1 U824 (.A1(n455), .A2(leddofr[7]), .B1(n214), .B2(leddonr[7]), 
     .X(n233));
  SEH_NR2_1 U441 (.A1(n255), .A2(time_cnt[7]), .X(n254));
  SEH_MUX2_G_1 U658 (.D0(n717), .D1(n716), .S(n715), .X(n718));
  SEH_INV_S_1 U45 (.A(n20), .X(n37));
  SEH_AOI21B_1 U14 (.A1(n757), .A2(n7), .B(leddpwgr[7]), .X(n8));
  SEH_INV_S_1 U669 (.A(leddpwgr[5]), .X(n709));
  SEH_AOI22_1 U15 (.A1(leddcr0[6]), .A2(\pwmc_g_accum[15] ), .B1(n169), 
     .B2(\pwmc_g_accum[14] ), .X(n9));
  SEH_AO2BB2_1 U26 (.A1(n19), .A2(n766), .B1(ledd_pwmcnt[5]), .B2(n18), .X(n20));
  SEH_ND2_S_1 U39 (.A1(n766), .A2(n19), .X(n33));
  SEH_ND2_S_1 U353 (.A1(n458), .A2(n445), .X(n460));
  SEH_OAI22_S_1 U800 (.A1(n726), .A2(n159_2), .B1(n158_2), .B2(n725), .X(n727));
  SEH_OA22_1 U305 (.A1(n158_2), .A2(n710), .B1(n159_2), .B2(n711), .X(n706));
  SEH_AOI21_S_1 U383 (.A1(ledd_pwmcnt[6]), .A2(n426), .B(n425), .X(n458));
  SEH_AOI22_1 U284 (.A1(n148), .A2(n722), .B1(n147_2), .B2(n723), .X(n716));
  SEH_MAJI3_1 U1009 (.A1(n749), .A2(n712), .A3(n710), .X(n713));
  SEH_NR2_1 U21 (.A1(n14), .A2(ledd_pwmcnt[6]), .X(n15));
  SEH_OAI211_1 U1011 (.A1(n868), .A2(n720), .B1(n719), .B2(n718), .X(pwmc_g_n74));
  SEH_MUX2_G_1 U667 (.D0(n706), .D1(n705), .S(n704), .X(n707));
  SEH_MAJ3_1 U18 (.A1(n11), .A2(leddpwgr[7]), .A3(n7), .X(n12));
  SEH_INV_S_1 U660 (.A(n714), .X(n723));
  SEH_AOI22_1 U287 (.A1(n148), .A2(n725), .B1(n147_2), .B2(n726), .X(n729));
  SEH_NR2_1 U455 (.A1(n897), .A2(n712), .X(pwmc_g_n104));
  SEH_AN2_S_1 U893 (.A1(n372), .A2(n371), .X(n388));
  SEH_ND2_S_1 U562 (.A1(time_cnt[0]), .A2(time_cnt[1]), .X(n245));
  SEH_AOI211_1 U851 (.A1(time_cnt[9]), .A2(n259), .B1(n282), .B2(n258), 
     .X(n2610));
  SEH_AOI211_1 U846 (.A1(n249), .A2(n248), .B1(n251), .B2(n282), .X(n2560));
  SEH_AO21B_1 U875 (.A1(leddbr[6]), .A2(n323), .B(n316), .X(n7710));
  SEH_MAJI3_1 U1023 (.A1(n761), .A2(leddpwrr[1]), .A3(n750), .X(n751));
  SEH_OAI211_1 U818 (.A1(n758), .A2(n194), .B1(n328), .B2(n190), .X(n1260));
  SEH_ND2_S_1 U461 (.A1(n179), .A2(ledd_pwmcnt[3]), .X(n181));
  SEH_AN2_S_1 U189 (.A1(n441), .A2(n766), .X(n442));
  SEH_AO211_2 U813 (.A1(n181), .A2(n766), .B1(n191), .B2(n184), .X(n182));
  SEH_OAI211_1 U814 (.A1(n194), .A2(n183), .B1(n328), .B2(n182), .X(n1240));
  SEH_INV_S_1 U558 (.A(ledd_pwmcnt[5]), .X(n767));
  SEH_OA31_1 U823 (.A1(n212), .A2(n202), .A3(n201), .B(n200), .X(n231));
  SEH_BUF_D_16 n908_L0 (.A(n908), .X(n908_1));
  SEH_AOAI211_G_2 U52 (.A1(n16), .A2(n38), .B(n770), .C(n45), .X(pwmc_g_n118));
  SEH_AOAI211_1 U91 (.A1(n81), .A2(n75), .B(n77), .C(n80), .X(n82));
  SEH_INV_S_1 U710 (.A(\pwmc_g_step[12] ), .X(n695));
  SEH_OA21B_1 U972 (.A1(n692), .A2(n623), .B(n621), .X(n622));
  SEH_NR2_1 U449 (.A1(n897), .A2(n695), .X(pwmc_g_n102));
  SEH_MAJI3_1 U1002 (.A1(n747), .A2(n695), .A3(n693), .X(n702));
  SEH_NR2_1 U205 (.A1(ledd_pscnt[2]), .A2(n305), .X(n308));
  SEH_AOAI211_1 U787 (.A1(n305), .A2(n304), .B(n325), .C(n303), .X(n7210));
  SEH_OAI211_1 U854 (.A1(time_cnt[11]), .A2(n262), .B1(n264), .B2(n276), 
     .X(n263));
  SEH_AOI22_1 U826 (.A1(n455), .A2(leddofr[1]), .B1(n214), .B2(leddonr[1]), 
     .X(n221));
  SEH_MUX2_G_1 U761 (.D0(leddbcfr[3]), .D1(leddbcrr[3]), .S(n209), .X(n358));
  SEH_OAI211_1 U940 (.A1(n868), .A2(n538), .B1(n537), .B2(n536), .X(pwmc_b_n69));
  SEH_NR3_1 U309 (.A1(n353), .A2(n360), .A3(n346), .X(net929));
  SEH_NR4_1 U832 (.A1(time_cnt[10]), .A2(n208), .A3(n207), .A4(n206), .X(n219));
  SEH_AOI22_1 U807 (.A1(n172), .A2(n173), .B1(n188), .B2(n768), .X(n171));
  SEH_NR2_1 U439 (.A1(time_cnt[18]), .A2(n233), .X(n208));
  SEH_AOAI211_1 U435 (.A1(n760), .A2(n752), .B(n754), .C(leddpwrr[2]), .X(n753));
  SEH_NR2B_1 U444 (.A(n752), .B(n751), .X(n754));
  SEH_AOI211_1 U847 (.A1(n251), .A2(time_cnt[5]), .B1(n282), .B2(n250), 
     .X(n2570));
  SEH_NR2_1 U222 (.A1(n253), .A2(n252), .X(n255));
  SEH_NR2_1 U264 (.A1(n257), .A2(n256), .X(n259));
  SEH_AOI211_1 U849 (.A1(n255), .A2(time_cnt[7]), .B1(n282), .B2(n254), 
     .X(n2590));
  SEH_NR2_1 U464 (.A1(n251), .A2(time_cnt[5]), .X(n250));
  SEH_AOI211_1 U843 (.A1(time_cnt[0]), .A2(time_cnt[1]), .B1(n282), .B2(n243), 
     .X(n2530));
  SEH_ND2_S_1 U443 (.A1(n255), .A2(time_cnt[7]), .X(n256));
  SEH_INV_S_1 U238 (.A(leddbcrr[6]), .X(n464));
  SEH_NR2_1 U433 (.A1(time_cnt[9]), .A2(n259), .X(n258));
  SEH_NR2_1 U502 (.A1(n247), .A2(time_cnt[3]), .X(n246));
  SEH_NR4_1 U891 (.A1(leddofr[4]), .A2(leddofr[6]), .A3(leddofr[7]), 
     .A4(leddofr[0]), .X(n372));
  SEH_ND2_S_1 U438 (.A1(n184), .A2(ledd_pwmcnt[5]), .X(n187));
  SEH_INV_S_1 U549 (.A(ledd_pwmcnt[6]), .X(n186));
  SEH_INV_S_2 U232 (.A(ledd_pwmcnt[7]), .X(n758));
  SEH_MAJI3_1 U911 (.A1(n767), .A2(n443), .A3(n442), .X(n449));
  SEH_NR2_1 U448 (.A1(n181), .A2(n766), .X(n184));
  SEH_OAI211_1 U816 (.A1(n186), .A2(n194), .B1(n328), .B2(n185), .X(n1250));
  SEH_INV_S_2 U747 (.A(ledd_pwmcnt[0]), .X(n768));
  SEH_AOI22_1 U518 (.A1(ledd_pwmcnt[0]), .A2(n767), .B1(ledd_pwmcnt[5]), 
     .B2(n768), .X(n183));
  SEH_AOI211_1 U845 (.A1(n247), .A2(time_cnt[3]), .B1(n282), .B2(n246), 
     .X(n2550));
  SEH_OAI211_1 U815 (.A1(n184), .A2(ledd_pwmcnt[5]), .B1(n188), .B2(n187), 
     .X(n185));
  SEH_AO211_2 U819 (.A1(n192), .A2(n758), .B1(n462), .B2(n191), .X(n193));
  SEH_NR2_1 U551 (.A1(time_cnt[0]), .A2(time_cnt[1]), .X(n243));
  SEH_AOI211_4 U132 (.A1(leddcr0[6]), .A2(n113), .B1(n329), .B2(n114), .X(n512));
  SEH_ND2_S_1 U85 (.A1(n72), .A2(n74), .X(n75));
  SEH_ND2_S_1 U420 (.A1(n354), .A2(n198), .X(n213));
  SNPS_CLOCK_GATE_HIGH_ledd_pwmc_6 \clk_gate_pwmc_r/accum_reg  (.CLK(ledd_clk), 
     .EN(pwmc_r_n22), .ENCLK(n909), .TE(pwmc_b_net979));
  SEH_AOI221_1 U838 (.A1(n225), .A2(time_cnt[13]), .B1(time_cnt[12]), .B2(n224), 
     .C(n223), .X(n226));
  SEH_OAI31_1 U37 (.A1(n768), .A2(n26), .A3(n27), .B(n30), .X(n31));
  SEH_NR2_1 U517 (.A1(n245), .A2(n244), .X(n247));
  SEH_AOI211_1 U844 (.A1(n245), .A2(n244), .B1(n247), .B2(n282), .X(n2540));
  SEH_INV_S_1 U588 (.A(time_cnt[2]), .X(n244));
  SEH_ND3_S_1 U428 (.A1(n347), .A2(n350), .A3(n360), .X(n363));
  SEH_AOI221_1 U835 (.A1(n275), .A2(n232), .B1(n229), .B2(time_cnt[17]), 
     .C(n216), .X(n217));
  SEH_INV_S_1 U766 (.A(n353), .X(n347));
  SEH_AOAI211_1 U413 (.A1(ledd_pscnt[2]), .A2(n305), .B(n308), .C(n320), 
     .X(n306));
  SEH_INV_S_1 U768 (.A(n350), .X(n354));
  SEH_ND2_S_1 U203 (.A1(n308), .A2(n307), .X(n310));
  SEH_OAI21_S_1 U193 (.A1(n358), .A2(n212), .B(n239), .X(n211));
  SEH_NR2_1 U852 (.A1(n261), .A2(n260), .X(n262));
  SEH_ND2_S_1 U190 (.A1(time_cnt[14]), .A2(n269), .X(n271));
  SEH_ND4B_2 U130 (.A(n112), .B1(n217), .B2(n218), .B3(n219), .X(n113));
  SEH_OAI221_1 U831 (.A1(time_cnt[13]), .A2(n224), .B1(time_cnt[14]), .B2(n225), 
     .C(n205), .X(n206));
  SEH_ND2_S_1 U415 (.A1(n463), .A2(n462), .X(n475));
  SEH_INV_S_1 U666 (.A(leddpwrr[5]), .X(n854));
  SEH_INV_S_1 U616 (.A(leddpwbr[4]), .X(n564));
  SEH_NR2_1 U450 (.A1(leddbcrr[6]), .A2(n595), .X(n197));
  SEH_BUF_D_8 BW2_BUF1568 (.A(n168), .X(n168_2));
  SEH_ND2B_1 U493 (.A(n455), .B(leddcr0[2]), .X(n770));
  SEH_ND2_S_1 U400 (.A1(n171), .A2(n328), .X(n1200));
  SEH_INV_S_1 U746 (.A(n178), .X(n179));
  SEH_NR2_1 U467 (.A1(n812), .A2(n762), .X(n750));
  SEH_INV_S_1 U95 (.A(n63), .X(n81));
  SEH_AOAI211_1 U351 (.A1(n458), .A2(n457), .B(n456), .C(n769), .X(n459));
  SEH_AO21B_1 U1024 (.A1(n754), .A2(n760), .B(n753), .X(n755));
  SEH_INV_S_1 U707 (.A(leddpwrr[2]), .X(n829));
  SEH_AOI22_1 U822 (.A1(n455), .A2(leddofr[4]), .B1(n214), .B2(leddonr[4]), 
     .X(n200));
  SEH_AOI211_1 U863 (.A1(time_cnt[19]), .A2(n283), .B1(n282), .B2(n281), 
     .X(n2710));
  SEH_NR2_1 U408 (.A1(n356), .A2(n213), .X(n215));
  SEH_AOI31_1 U884 (.A1(n347), .A2(n355), .A3(n354), .B(n358), .X(n349));
  SEH_NR2_1 U194 (.A1(n265), .A2(n264), .X(n266));
  SEH_NR2_1 U41 (.A1(n8), .A2(n758), .X(n35));
  SEH_AOAI211_1 U51 (.A1(n36), .A2(n41), .B(n44), .C(n769), .X(n45));
  SEH_ND4_S_1 U49 (.A1(leddpwgr[7]), .A2(leddpwgr[0]), .A3(leddbcfr[6]), 
     .A4(n42), .X(n43));
  SEH_INV_S_1 U713 (.A(\pwmc_g_accum[12] ), .X(n747));
  SEH_AOI21_S_1 U366 (.A1(n856), .A2(leddpwgr[4]), .B(n855), .X(n691));
  SEH_MUX2_G_1 U577 (.D0(n421), .D1(leddpwbr[7]), .S(n438), .X(n424));
  SEH_NR2_1 U384 (.A1(n426), .A2(ledd_pwmcnt[6]), .X(n423));
  SEH_INV_S_1 U96 (.A(n77), .X(n86));
  SEH_MAJI3_1 U1003 (.A1(n695), .A2(n694), .A3(\pwmc_g_accum[12] ), .X(n703));
  SEH_NR2_1 U387 (.A1(n424), .A2(n758), .X(n425));
  SEH_INV_S_1 U195 (.A(n194), .X(n173));
  SEH_INV_S_1 U568 (.A(n913), .X(n154));
  SEH_AOI211_G_1 U860 (.A1(n275), .A2(n274), .B1(n277), .B2(n282), .X(n2680));
  SEH_AOI211_1 U862 (.A1(n280), .A2(n279), .B1(n283), .B2(n282), .X(n2700));
  SEH_OAI211_1 U837 (.A1(time_cnt[10]), .A2(n234), .B1(n222), .B2(n280), 
     .X(n228));
  SNPS_CLOCK_GATE_HIGH_ledd_ctrl_9 clk_gate_state_reg (.CLK(ledd_clk_3), 
     .EN(n4810), .ENCLK(n903), .TE(pwmc_b_net979));
  SEH_AN2_S_1 U548 (.A1(ledd_exe), .A2(leddcr0[7]), .X(n4510));
  SEH_NR4_1 U892 (.A1(leddofr[5]), .A2(leddofr[3]), .A3(leddofr[2]), 
     .A4(leddofr[1]), .X(n371));
  SEH_INV_S_1 U760 (.A(n358), .X(n356));
  SEH_MUX2_G_1 U76 (.D0(n762), .D1(leddpwrr[0]), .S(n59), .X(n66));
  SEH_ND2_1 U416 (.A1(n463), .A2(leddcr0[2]), .X(n194));
  SEH_OAI31_1 U82 (.A1(n768), .A2(n65), .A3(n66), .B(n71), .X(n72));
  SEH_NR2_S_2 U411 (.A1(leddcr0[2]), .A2(n329), .X(n188));
  SEH_NR2_1 U373 (.A1(time_cnt[19]), .A2(n283), .X(n281));
  SEH_AOI211_G_1 U855 (.A1(n265), .A2(n264), .B1(n266), .B2(n282), .X(n2640));
  SEH_NR2_T_1 U472 (.A1(n455), .A2(leddcr0[2]), .X(n769));
  SEH_INV_S_1 U589 (.A(time_cnt[12]), .X(n265));
  SEH_AOI211_1 U853 (.A1(n261), .A2(n260), .B1(n262), .B2(n282), .X(n2620));
  SEH_INV_S_1 U583 (.A(n282), .X(n276));
  SEH_INV_S_1 U581 (.A(n270), .X(n2660));
  SEH_AOI221_1 U840 (.A1(n272), .A2(n232), .B1(n231), .B2(time_cnt[14]), 
     .C(n230), .X(n237));
  SEH_ND2_S_1 U469 (.A1(n837), .A2(n759), .X(n752));
  SEH_AOAI211_1 U412 (.A1(ledd_pscnt[4]), .A2(n310), .B(n313), .C(n320), 
     .X(n311));
  SEH_AO2BB2_1 U267 (.A1(n164_2), .A2(n749), .B1(n900), .B2(\pwmc_g_step[9] ), 
     .X(pwmc_g_n99));
  SEH_INV_S_1 U603 (.A(n577), .X(n586));
  SEH_INV_S_1 U610 (.A(\pwmc_b_accum[14] ), .X(n615));
  SEH_ND2_S_1 U263 (.A1(n355), .A2(n353), .X(n364));
  SEH_AOI21_S_1 U365 (.A1(n856), .A2(leddpwrr[2]), .B(n855), .X(n819));
  SEH_NR2_1 U423 (.A1(n347), .A2(n355), .X(n198));
  SEH_AOI22_T_1 U821 (.A1(n197), .A2(leddbcfr[2]), .B1(leddbcrr[2]), .B2(n209), 
     .X(n350));
  SEH_ND2_S_1 U298 (.A1(n242), .A2(n282), .X(n2510));
  SEH_ND2_S_1 U447 (.A1(n595), .A2(leddbcrr[5]), .X(n593));
  SEH_AO2BB2_1 U403 (.A1(ledd_pscnt[0]), .A2(n325), .B1(leddbr[0]), .B2(n323), 
     .X(n7110));
  SEH_AOI211_1 U839 (.A1(n229), .A2(time_cnt[16]), .B1(n228), .B2(n227), 
     .X(n238));
  SEH_AOI22_1 U552 (.A1(leddbcrr[6]), .A2(leddbcrr[7]), .B1(leddbcfr[7]), 
     .B2(n464), .X(n389));
  SEH_AOI22_S_2 U776 (.A1(leddbcrr[6]), .A2(leddbcrr[5]), .B1(leddbcfr[5]), 
     .B2(n464), .X(n594));
  SEH_NR2_1 U859 (.A1(n275), .A2(n274), .X(n277));
  SEH_OAI21_S_1 U396 (.A1(n229), .A2(time_cnt[16]), .B(n226), .X(n227));
  SEH_AOI22_1 U825 (.A1(n455), .A2(leddofr[0]), .B1(n214), .B2(leddonr[0]), 
     .X(n234));
  SEH_OAI22_S_1 U218 (.A1(time_cnt[17]), .A2(n233), .B1(n221), .B2(time_cnt[11]), 
     .X(n220));
  SEH_NR2_1 U395 (.A1(n272), .A2(n271), .X(n273));
  SEH_BUF_D_8 U563 (.A(n1), .X(n165));
  SEH_INV_S_1 U756 (.A(n463), .X(n329));
  SEH_AOI22_1 U833 (.A1(n455), .A2(leddofr[5]), .B1(n214), .B2(leddonr[5]), 
     .X(n210));
  SEH_INV_S_1 U574 (.A(n320), .X(n325));
  SEH_AOI222_2 U829 (.A1(n204), .A2(n239), .B1(n214), .B2(leddonr[3]), .C1(n455), 
     .C2(leddofr[3]), .X(n225));
  SEH_AOAI211_2 U398 (.A1(n212), .A2(n358), .B(n211), .C(n210), .X(n232));
  SEH_OAOI211_1 U404 (.A1(n308), .A2(n307), .B(n310), .C(n325), .X(n309));
  SEH_AO21_1 U779 (.A1(leddbr[3]), .A2(n323), .B(n309), .X(n7410));
  SEH_ND2_S_1 U429 (.A1(n347), .A2(n360), .X(n368));
  SEH_ND2_S_1 U422 (.A1(leddbr[1]), .A2(n323), .X(n303));
  SEH_ND2_S_1 U550 (.A1(ledd_pscnt[1]), .A2(ledd_pscnt[0]), .X(n304));
  SEH_OR2_1 U547 (.A1(ledd_pscnt[1]), .A2(ledd_pscnt[0]), .X(n305));
  SEH_MAJI3_1 U924 (.A1(\pwmc_b_step[4] ), .A2(\pwmc_b_accum[4] ), .A3(n497), 
     .X(n500));
  SEH_INV_S_1 U633 (.A(\pwmc_b_accum[3] ), .X(n494));
  SEH_MAJI3_1 U926 (.A1(n501), .A2(\pwmc_b_step[5] ), .A3(\pwmc_b_accum[5] ), 
     .X(n504));
  SEH_INV_S_1 U582 (.A(n278), .X(n2690));
  SEH_BUF_S_1 U8 (.A(n1), .X(n167));
  SEH_OA22_1 U988 (.A1(n158_2), .A2(n658), .B1(n159_2), .B2(n659), .X(n656));
  SEH_INV_S_1 U735 (.A(\pwmc_g_accum[2] ), .X(n636));
  SEH_INV_S_1 U725 (.A(\pwmc_g_accum[5] ), .X(n733));
  SEH_OAI22_S_1 U105 (.A1(n637), .A2(n159_2), .B1(n635), .B2(n158_2), .X(n94));
  SEH_MAJI3_1 U974 (.A1(n634), .A2(\pwmc_g_step[1] ), .A3(n633), .X(n637));
  SEH_OAI211_1 U1018 (.A1(n902), .A2(n737), .B1(n736), .B2(n893), .X(pwmc_g_n92));
  SEH_AOI22_1 U161 (.A1(n515), .A2(n147_2), .B1(n514), .B2(n161), .X(n136));
  SEH_MAJI3_1 U978 (.A1(n641), .A2(\pwmc_g_step[3] ), .A3(n640), .X(n642));
  SEH_MAJI3_1 U979 (.A1(\pwmc_g_step[4] ), .A2(\pwmc_g_accum[4] ), .A3(n644), 
     .X(n647));
  SEH_AOI22_S_1 U137 (.A1(n148), .A2(n632), .B1(n149_1), .B2(n633), .X(n118));
  SEH_MUXI2_1 U116 (.D0(n100), .D1(n101), .S(n102), .X(pwmc_g_n63));
  SEH_AOI22_1 U113 (.A1(n642), .A2(n147_2), .B1(n643), .B2(n148), .X(n100));
  SEH_MUX2_G_1 U151 (.D0(n126), .D1(n127), .S(n128), .X(pwmc_g_n62));
  SEH_INV_S_1 U733 (.A(n643), .X(n644));
  SEH_AOI22_1 U144 (.A1(n646), .A2(n149_1), .B1(n647), .B2(n148), .X(n123));
  SEH_MUXI2_1 U139 (.D0(n117), .D1(n118), .S(n119), .X(pwmc_g_n60));
  SEH_INV_S_1 U732 (.A(n647), .X(n648));
  SEH_MAJI3_1 U973 (.A1(\pwmc_g_step[1] ), .A2(\pwmc_g_accum[1] ), .A3(n632), 
     .X(n635));
  SEH_INV_S_1 U724 (.A(\pwmc_g_accum[3] ), .X(n641));
  SEH_MAJI3_1 U980 (.A1(\pwmc_g_step[4] ), .A2(n645), .A3(n731), .X(n646));
  SEH_INV_S_1 U722 (.A(\pwmc_g_accum[0] ), .X(n629));
  SEH_INV_S_1 U719 (.A(\pwmc_g_accum[4] ), .X(n731));
  SEH_AOI22_1 U136 (.A1(n630), .A2(n149_1), .B1(n631), .B2(n148), .X(n117));
  SEH_OAOI211_1 U279 (.A1(\pwmc_g_step[0] ), .A2(n629), .B(n630), .C(n771), 
     .X(pwmc_g_n59));
  SEH_OAI21_1 U107 (.A1(n92), .A2(n93), .B(n95), .X(pwmc_g_n61));
  SEH_AO22_1 U149 (.A1(n148), .A2(n639), .B1(n640), .B2(n149_1), .X(n127));
  SEH_OAI211_1 U1016 (.A1(n164_2), .A2(n733), .B1(n732), .B2(n163), 
     .X(pwmc_g_n90));
  SEH_INV_S_1 U731 (.A(n651), .X(n652));
  SEH_INV_S_1 U717 (.A(n650), .X(n653));
  SEH_MAJI3_1 U982 (.A1(n733), .A2(\pwmc_g_step[5] ), .A3(n649), .X(n650));
  SEH_ND2_S_1 U553 (.A1(\pwmc_g_step[0] ), .A2(\pwmc_g_accum[0] ), .X(n631));
  SEH_INV_S_1 U723 (.A(\pwmc_g_accum[1] ), .X(n634));
  SEH_MAJI3_1 U977 (.A1(n639), .A2(\pwmc_g_step[3] ), .A3(\pwmc_g_accum[3] ), 
     .X(n643));
  SEH_OA2BB2_1 U150 (.A1(\pwmc_g_step[3] ), .A2(n641), .B1(n641), 
     .B2(\pwmc_g_step[3] ), .X(n128));
  SEH_AOI22_1 U114 (.A1(n148), .A2(n644), .B1(n645), .B2(n149_1), .X(n101));
  SEH_INV_S_1 U720 (.A(n642), .X(n645));
  SEH_AOI22_1 U319 (.A1(n900), .A2(\pwmc_g_step[0] ), .B1(leddpwgr[1]), 
     .B2(n162_2), .X(n732));
  SEH_OA2BB2_1 U160 (.A1(n612), .A2(\pwmc_b_accum[7] ), .B1(\pwmc_b_accum[7] ), 
     .B2(n612), .X(n135));
  SEH_OAI22_S_1 U162 (.A1(n515), .A2(n159_2), .B1(n514), .B2(n158_2), .X(n137));
  SEH_INV_S_1 U637 (.A(\pwmc_b_accum[7] ), .X(n603));
  SEH_OAI211_1 U1015 (.A1(n164_2), .A2(n731), .B1(n163), .B2(n730), 
     .X(pwmc_g_n89));
  SEH_INV_S_1 U736 (.A(\pwmc_g_step[2] ), .X(n638));
  SEH_OA2BB2_1 U103 (.A1(n638), .A2(\pwmc_g_accum[2] ), .B1(\pwmc_g_accum[2] ), 
     .B2(n638), .X(n92));
  SEH_MUXI2_1 U63 (.D0(n51), .D1(n52), .S(n53), .X(pwmc_g_n65));
  SEH_OAOI211_1 U283 (.A1(\pwmc_b_step[0] ), .A2(n476), .B(n477), .C(n771), 
     .X(pwmc_b_n59));
  SEH_MAJI3_1 U925 (.A1(\pwmc_b_step[4] ), .A2(n498), .A3(n597), .X(n499));
  SEH_AOI22_1 U335 (.A1(n900), .A2(\pwmc_b_step[1] ), .B1(leddpwbr[2]), 
     .B2(n162_2), .X(n600));
  SEH_OAI211_1 U964 (.A1(n164_2), .A2(n601), .B1(n600), .B2(n163), 
     .X(pwmc_b_n91));
  SEH_AO2BB2_1 U268 (.A1(n164_2), .A2(n899), .B1(n900), .B2(\pwmc_r_step[8] ), 
     .X(pwmc_r_n98));
  SEH_AO2BB2_1 U265 (.A1(n164_2), .A2(n901), .B1(n900), .B2(\pwmc_r_step[9] ), 
     .X(pwmc_r_n99));
  SEH_BUF_D_16 n909_L0 (.A(n909), .X(n909_1));
  SEH_MAJI3_1 U981 (.A1(n648), .A2(\pwmc_g_step[5] ), .A3(\pwmc_g_accum[5] ), 
     .X(n651));
  SEH_INV_S_1 U638 (.A(\pwmc_b_step[7] ), .X(n612));
  SEH_AOI22_1 U248 (.A1(n148), .A2(n556), .B1(n149_1), .B2(n557), .X(n551));
  SEH_AOI21_S_1 U372 (.A1(n856), .A2(leddpwgr[1]), .B(n855), .X(n666));
  SEH_AOI22_1 U348 (.A1(n900), .A2(\pwmc_g_step[6] ), .B1(leddpwgr[7]), 
     .B2(n162_2), .X(n744));
  SEH_INV_S_1 U613 (.A(\pwmc_b_accum[13] ), .X(n614));
  SEH_AOAI211_G_1 U102 (.A1(n82), .A2(n84), .B(n770), .C(n91), .X(pwmc_r_n118));
  SEH_EO2_1 U477 (.A1(leddcr0[5]), .A2(n296), .X(n3540));
  SEH_AOI22_1 U440 (.A1(time_cnt[11]), .A2(n234), .B1(time_cnt[12]), .B2(n221), 
     .X(n203));
  SEH_AOI22_1 U178 (.A1(n161), .A2(n813), .B1(n149_1), .B2(n814), .X(n809));
  SEH_OA22_1 U302 (.A1(n158_2), .A2(n492), .B1(n159_2), .B2(n493), .X(n490));
  SEH_EN2_1 U512 (.A1(n488), .A2(\pwmc_b_accum[2] ), .X(n482));
  SEH_MAJI3_1 U930 (.A1(\pwmc_b_step[6] ), .A2(\pwmc_b_accum[6] ), .A3(n508), 
     .X(n514));
  SEH_MAJI3_1 U916 (.A1(\pwmc_b_step[1] ), .A2(\pwmc_b_accum[1] ), .A3(n479), 
     .X(n485));
  SEH_AOI22_1 U54 (.A1(n161), .A2(n479), .B1(n147_2), .B2(n480), .X(n47));
  SEH_INV_S_1 U629 (.A(n495), .X(n498));
  SEH_INV_S_1 U632 (.A(\pwmc_b_accum[1] ), .X(n481));
  SEH_INV_S_1 U634 (.A(\pwmc_b_accum[5] ), .X(n599));
  SEH_INV_S_1 U696 (.A(n806), .X(n813));
  SEH_AOI22_1 U9 (.A1(n495), .A2(n147_2), .B1(n496), .B2(n161), .X(n4));
  SEH_OA2BB2_1 U165 (.A1(n746), .A2(\pwmc_g_accum[7] ), .B1(\pwmc_g_accum[7] ), 
     .B2(n746), .X(n139));
  SEH_EN2_1 U514 (.A1(n614), .A2(\pwmc_b_step[13] ), .X(n559));
  SEH_ND2_S_1 U106 (.A1(n92), .A2(n94), .X(n95));
  SEH_OAI21_1 U164 (.A1(n135), .A2(n136), .B(n138), .X(pwmc_b_n66));
  SEH_INV_S_1 U721 (.A(n630), .X(n633));
  SEH_INV_S_1 U734 (.A(n631), .X(n632));
  SEH_AOI22_1 U145 (.A1(n148), .A2(n648), .B1(n649), .B2(n147_2), .X(n124));
  SEH_INV_S_1 U718 (.A(n646), .X(n649));
  SEH_MUXI2_1 U12 (.D0(n4), .D1(n5), .S(n6), .X(pwmc_b_n63));
  SEH_AOI22_1 U921 (.A1(n161), .A2(n492), .B1(n147_2), .B2(n493), .X(n491));
  SEH_INV_S_1 U640 (.A(n500), .X(n501));
  SEH_INV_S_1 U643 (.A(\pwmc_b_accum[2] ), .X(n486));
  SEH_NR2_T_1 U289 (.A1(n148), .A2(n149_1), .X(n771));
  SEH_INV_S_1 U729 (.A(\pwmc_g_accum[7] ), .X(n737));
  SEH_INV_S_1 U630 (.A(n477), .X(n480));
  SEH_AOI22_1 U53 (.A1(n477), .A2(n147_2), .B1(n478), .B2(n161), .X(n46));
  SEH_AOI21_S_1 U358 (.A1(n856), .A2(leddpwrr[4]), .B(n855), .X(n836));
  SEH_OA2BB2_1 U133 (.A1(\pwmc_g_step[8] ), .A2(n739), .B1(n739), 
     .B2(\pwmc_g_step[8] ), .X(n115));
  SEH_OA2BB2_1 U146 (.A1(\pwmc_g_step[5] ), .A2(n733), .B1(n733), 
     .B2(\pwmc_g_step[5] ), .X(n125));
  SEH_AOI22_1 U104 (.A1(n637), .A2(n149_1), .B1(n635), .B2(n148), .X(n93));
  SEH_ND2_S_1 U163 (.A1(n135), .A2(n137), .X(n138));
  SEH_AOI22_1 U60 (.A1(n650), .A2(n149_1), .B1(n651), .B2(n161), .X(n51));
  SEH_MUXI2_1 U147 (.D0(n123), .D1(n124), .S(n125), .X(pwmc_g_n64));
  SEH_ND2_S_1 U508 (.A1(\pwmc_b_step[0] ), .A2(n476), .X(n477));
  SEH_MAJI3_1 U927 (.A1(n599), .A2(\pwmc_b_step[5] ), .A3(n502), .X(n503));
  SEH_EN2_1 U505 (.A1(\pwmc_r_step[9] ), .A2(n890), .X(n807));
  SEH_AOI22_1 U325 (.A1(n900), .A2(\pwmc_b_step[0] ), .B1(leddpwbr[1]), 
     .B2(n162_2), .X(n598));
  SEH_MUX2_G_1 U598 (.D0(n518), .D1(n517), .S(n516), .X(n519));
  SEH_OAI211_1 U965 (.A1(n164_2), .A2(n603), .B1(n602), .B2(n163), 
     .X(pwmc_b_n92));
  SEH_AOI22_1 U334 (.A1(n900), .A2(\pwmc_g_step[3] ), .B1(leddpwgr[4]), 
     .B2(n162_2), .X(n738));
  SEH_AOI22_1 U166 (.A1(n655), .A2(n147_2), .B1(n654), .B2(n148), .X(n140));
  SEH_MUX2_G_1 U609 (.D0(n569), .D1(n568), .S(n567), .X(n570));
  SEH_OAI22_S_1 U214 (.A1(n232), .A2(n275), .B1(n229), .B2(time_cnt[17]), 
     .X(n216));
  SEH_NR4_2 U888 (.A1(n356), .A2(n355), .A3(n160), .A4(n354), .X(n366));
  SEH_OAI22_S_1 U406 (.A1(n225), .A2(time_cnt[13]), .B1(n224), .B2(time_cnt[12]), 
     .X(n223));
  SEH_MAJI3_1 U923 (.A1(n494), .A2(\pwmc_b_step[3] ), .A3(n493), .X(n495));
  SEH_INV_S_1 U584 (.A(n273), .X(n274));
  SEH_MUXI2_1 U591 (.D0(n507), .D1(n506), .S(n505), .X(pwmc_b_n65));
  SEH_INV_S_1 U626 (.A(n503), .X(n509));
  SEH_MAJI3_1 U920 (.A1(n488), .A2(n487), .A3(\pwmc_b_accum[2] ), .X(n493));
  SEH_AOI22_1 U918 (.A1(n161), .A2(n485), .B1(n147_2), .B2(n487), .X(n483));
  SEH_AOI22_1 U929 (.A1(n161), .A2(n504), .B1(n147_2), .B2(n503), .X(n506));
  SEH_INV_S_1 U625 (.A(\pwmc_b_accum[6] ), .X(n601));
  SEH_OA2BB2_1 U55 (.A1(\pwmc_b_step[1] ), .A2(n481), .B1(n481), 
     .B2(\pwmc_b_step[1] ), .X(n48));
  SEH_INV_S_1 U628 (.A(\pwmc_b_accum[4] ), .X(n597));
  SEH_MAJI3_1 U919 (.A1(n488), .A2(n486), .A3(n485), .X(n492));
  SEH_INV_S_1 U618 (.A(\pwmc_b_accum[11] ), .X(n611));
  SEH_OA22_1 U294 (.A1(n158_2), .A2(n485), .B1(n159_2), .B2(n487), .X(n484));
  SEH_MAJI3_1 U922 (.A1(n492), .A2(\pwmc_b_step[3] ), .A3(\pwmc_b_accum[3] ), 
     .X(n496));
  SEH_MAJI3_1 U949 (.A1(n558), .A2(n557), .A3(\pwmc_b_accum[12] ), .X(n566));
  SEH_MAJI3_1 U975 (.A1(n638), .A2(n636), .A3(n635), .X(n639));
  SEH_ND2_S_1 U532 (.A1(\pwmc_g_step[0] ), .A2(n629), .X(n630));
  SEH_AOI22_1 U10 (.A1(n161), .A2(n497), .B1(n147_2), .B2(n498), .X(n5));
  SEH_OA2BB2_1 U115 (.A1(\pwmc_g_step[4] ), .A2(n731), .B1(n731), 
     .B2(\pwmc_g_step[4] ), .X(n102));
  SEH_OAI22_S_1 U148 (.A1(n159_2), .A2(n640), .B1(n158_2), .B2(n639), .X(n126));
  SEH_OA2BB2_1 U138 (.A1(\pwmc_g_step[1] ), .A2(n634), .B1(n634), 
     .B2(\pwmc_g_step[1] ), .X(n119));
  SEH_MAJI3_1 U976 (.A1(n638), .A2(n637), .A3(\pwmc_g_accum[2] ), .X(n640));
  SEH_INV_S_1 U641 (.A(n496), .X(n497));
  SEH_EN2_1 U522 (.A1(\pwmc_b_step[3] ), .A2(n494), .X(n489));
  SEH_MUXI2_1 U595 (.D0(n491), .D1(n490), .S(n489), .X(pwmc_b_n62));
  SEH_AOI22_1 U126 (.A1(n161), .A2(n501), .B1(n147_2), .B2(n502), .X(n110));
  SEH_AOI22_1 U125 (.A1(n499), .A2(n147_2), .B1(n500), .B2(n161), .X(n109));
  SEH_ND2_S_1 U188 (.A1(time_cnt[17]), .A2(n277), .X(n279));
  SEH_AN2_S_1 U220 (.A1(\pwmc_b_step[11] ), .A2(n900), .X(pwmc_b_n101));
  SEH_MAJI3_1 U931 (.A1(\pwmc_b_step[6] ), .A2(n509), .A3(n601), .X(n515));
  SEH_INV_S_1 U769 (.A(n197), .X(n209));
  SEH_AOI211_1 U858 (.A1(n272), .A2(n271), .B1(n273), .B2(n282), .X(n2670));
  SEH_MUXI2_1 U128 (.D0(n109), .D1(n110), .S(n111), .X(pwmc_b_n64));
  SEH_MUXI2_1 U56 (.D0(n46), .D1(n47), .S(n48), .X(pwmc_b_n60));
  SEH_AOI22_1 U330 (.A1(n900), .A2(\pwmc_b_step[2] ), .B1(leddpwbr[3]), 
     .B2(n162_2), .X(n602));
  SEH_INV_S_3 U599 (.A(n158_2), .X(n161));
  SEH_INV_S_1 U639 (.A(n504), .X(n508));
  SEH_MAJI3_1 U917 (.A1(n481), .A2(\pwmc_b_step[1] ), .A3(n480), .X(n487));
  SEH_AOI22_1 U291 (.A1(n148), .A2(n661), .B1(n149_1), .B2(n660), .X(n663));
  SEH_OAI21_S_1 U169 (.A1(n139), .A2(n140), .B(n142), .X(pwmc_g_n66));
  SEH_MAJI3_1 U985 (.A1(n654), .A2(n746), .A3(n737), .X(n658));
  SEH_MAJI3_1 U945 (.A1(n548), .A2(\pwmc_b_accum[11] ), .A3(\pwmc_b_step[11] ), 
     .X(n556));
  SEH_MUX2_G_1 U607 (.D0(n552), .D1(n551), .S(n550), .X(n553));
  SEH_OAI211_1 U1019 (.A1(n902), .A2(n739), .B1(n738), .B2(n893), .X(pwmc_g_n93));
  SEH_ND2_S_1 U196 (.A1(time_cnt[11]), .A2(n262), .X(n264));
  SEH_OAI211_1 U857 (.A1(time_cnt[14]), .A2(n269), .B1(n271), .B2(n276), 
     .X(n270));
  SEH_AOAI211_1 U131 (.A1(n237), .A2(n238), .B(leddcr0[6]), .C(n236), .X(n114));
  SEH_AOI22_1 U830 (.A1(time_cnt[13]), .A2(n224), .B1(time_cnt[14]), .B2(n225), 
     .X(n205));
  SEH_NR2_1 U202 (.A1(ledd_pscnt[4]), .A2(n310), .X(n313));
  SEH_AO2BB2_1 U795 (.A1(n364), .A2(n346), .B1(n160), .B2(t_mult[8]), .X(net932));
  SEH_OAI21_1 U278 (.A1(\pwmc_r_accum[16] ), .A2(n878), .B(n877), .X(pwmc_r_n75));
  SEH_AOI21_S_1 U368 (.A1(n856), .A2(leddpwbr[2]), .B(n855), .X(n537));
  SEH_MUX2_G_1 U134 (.D0(n656), .D1(n657), .S(n115), .X(n116));
  SEH_BUF_S_1 U565 (.A(n1), .X(n168));
  SEH_AOI21_S_1 U374 (.A1(n856), .A2(leddpwbr[5]), .B(n855), .X(n563));
  SEH_EN2_1 U506 (.A1(n615), .A2(\pwmc_b_step[14] ), .X(n567));
  SEH_AOI22_1 U211 (.A1(n161), .A2(n521), .B1(n147_2), .B2(n522), .X(n518));
  SEH_INV_S_1 U627 (.A(n499), .X(n502));
  SEH_INV_S_1 U642 (.A(n478), .X(n479));
  SEH_ND2_S_1 U554 (.A1(\pwmc_b_step[0] ), .A2(\pwmc_b_accum[0] ), .X(n478));
  SEH_OA2BB2_1 U11 (.A1(\pwmc_b_step[4] ), .A2(n597), .B1(n597), 
     .B2(\pwmc_b_step[4] ), .X(n6));
  SEH_MUXI2_1 U594 (.D0(n484), .D1(n483), .S(n482), .X(pwmc_b_n61));
  SEH_OA2BB2_1 U127 (.A1(\pwmc_b_step[5] ), .A2(n599), .B1(n599), 
     .B2(\pwmc_b_step[5] ), .X(n111));
  SEH_MUX2_G_1 U646 (.D0(n809), .D1(n808), .S(n807), .X(n810));
  SEH_NR2_1 U191 (.A1(n268), .A2(n267), .X(n269));
  SEH_OAI211_1 U969 (.A1(n164_2), .A2(n611), .B1(n610), .B2(n163), 
     .X(pwmc_b_n96));
  SEH_MAJI3_1 U933 (.A1(\pwmc_b_accum[7] ), .A2(n612), .A3(n515), .X(n522));
  SEH_AOI22_1 U928 (.A1(n161), .A2(n508), .B1(n147_2), .B2(n509), .X(n507));
  SEH_MAJI3_1 U932 (.A1(n514), .A2(n612), .A3(n603), .X(n521));
  SEH_INV_S_1 U631 (.A(\pwmc_b_accum[0] ), .X(n476));
  SEH_OA22_1 U303 (.A1(n158_2), .A2(n521), .B1(n159_2), .B2(n522), .X(n517));
  SEH_INV_S_1 U644 (.A(\pwmc_b_step[2] ), .X(n488));
  SEH_OAI211_1 U962 (.A1(n164_2), .A2(n597), .B1(n163), .B2(n596), 
     .X(pwmc_b_n89));
  SEH_OAI211_1 U963 (.A1(n164_2), .A2(n599), .B1(n598), .B2(n163), 
     .X(pwmc_b_n90));
  SEH_INV_S_1 U315 (.A(n159_2), .X(n149));
  SEH_INV_S_1 U233 (.A(time_cnt[10]), .X(n261));
  SEH_NR2_1 U257 (.A1(n280), .A2(n279), .X(n283));
  SNPS_CLOCK_GATE_HIGH_ledd_ctrl_6 clk_gate_t_mult_reg_0 (.CLK(ledd_clk_3), 
     .EN(alt14_n129), .ENCLK(n906), .TE(pwmc_b_net979));
  SEH_EO2_1 U474 (.A1(leddcr0[5]), .A2(n301), .X(n3550));
  SEH_OAI22_S_1 U785 (.A1(n902), .A2(n613), .B1(n897), .B2(n612), .X(pwmc_b_n97));
  SEH_EN2_1 U527 (.A1(\pwmc_b_step[6] ), .A2(n601), .X(n505));
  SEH_INV_S_1 U615 (.A(\pwmc_b_accum[12] ), .X(n613));
  SEH_MAJI3_1 U948 (.A1(n613), .A2(n558), .A3(n556), .X(n565));
  SEH_ND2_S_1 U168 (.A1(n139), .A2(n141), .X(n142));
  SEH_OAI221_1 U827 (.A1(time_cnt[11]), .A2(n234), .B1(time_cnt[12]), .B2(n221), 
     .C(n203), .X(n207));
  SEH_MUX2_G_1 U765 (.D0(leddbcfr[1]), .D1(leddbcrr[1]), .S(n209), .X(n360));
  SEH_INV_S_1 U754 (.A(time_cnt[15]), .X(n272));
  SEH_AOI22_1 U841 (.A1(time_cnt[10]), .A2(n234), .B1(time_cnt[18]), .B2(n233), 
     .X(n235));
  SEH_INV_S_1 U556 (.A(time_cnt[8]), .X(n257));
  SEH_AOI211_1 U856 (.A1(n268), .A2(n267), .B1(n269), .B2(n282), .X(n2650));
  SEH_INV_S_1 U755 (.A(time_cnt[18]), .X(n280));
  SEH_INV_S_1 U580 (.A(n263), .X(n2630));
  SEH_ND2_S_1 U410 (.A1(n329), .A2(n328), .X(n920));
  SEH_INV_S_24 U541 (.A(n152), .X(pwm_out_r));
  SEH_BUF_S_4 BW2_BUF731 (.A(n149), .X(n149_1));
  SEH_AOI22_1 U489 (.A1(leddcr0[6]), .A2(n614), .B1(n613), .B2(n169), .X(n437));
  SEH_AOAI211_1 U101 (.A1(n80), .A2(n87), .B(n90), .C(n769), .X(n91));
  SEH_AOAI211_1 U436 (.A1(n428), .A2(n408), .B(n410), .C(leddpwbr[2]), .X(n409));
  SEH_OAI31_1 U886 (.A1(n352), .A2(n160), .A3(n360), .B(n351), .X(net944));
  SEH_INV_S_1 U726 (.A(\pwmc_g_accum[9] ), .X(n741));
  SEH_INV_S_1 U208 (.A(time_cnt[13]), .X(n268));
  SEH_FDPRBQ_1 pwm_out_g_reg (.CK(ledd_clk_1), .D(n3540), .Q(n911), .RD(n168_2));
  SEH_OAI211_1 U1050 (.A1(n868), .A2(n829), .B1(n828), .B2(n827), .X(pwmc_r_n70));
  SEH_NR4B_2 U842 (.A(n235), .B1(time_cnt[8]), .B2(time_cnt[9]), 
     .B3(time_cnt[19]), .X(n236));
  SEH_MAJI3_1 U983 (.A1(\pwmc_g_step[6] ), .A2(\pwmc_g_accum[6] ), .A3(n652), 
     .X(n654));
  SEH_MAJI3_1 U946 (.A1(n611), .A2(\pwmc_b_step[11] ), .A3(n549), .X(n557));
  SEH_OAI211_1 U1020 (.A1(n902), .A2(n741), .B1(n740), .B2(n893), .X(pwmc_g_n94));
  SEH_INV_S_1 U714 (.A(n660), .X(n669));
  SEH_MAJI3_1 U956 (.A1(n575), .A2(n574), .A3(\pwmc_b_accum[14] ), .X(n577));
  SEH_INV_S_1 U680 (.A(leddpwrr[4]), .X(n846));
  SEH_INV_S_1 U605 (.A(\pwmc_b_step[14] ), .X(n575));
  SEH_OAI211_1 U991 (.A1(n868), .A2(n667), .B1(n666), .B2(n665), .X(pwmc_g_n68));
  SEH_FDPRBQ_1 pwm_out_b_reg (.CK(ledd_clk_1), .D(n3550), .Q(n912), .RD(n168_2));
  SEH_OA22_1 U312 (.A1(n158_2), .A2(n565), .B1(n159_2), .B2(n566), .X(n560));
  SEH_OAI22_S_1 U167 (.A1(n655), .A2(n159_2), .B1(n654), .B2(n158_2), .X(n141));
  SEH_AOI22_1 U250 (.A1(n148), .A2(n565), .B1(n149_1), .B2(n566), .X(n561));
  SEH_NR2_S_1 U454 (.A1(n897), .A2(n558), .X(pwmc_b_n102));
  SEH_MUX2_G_1 U612 (.D0(n561), .D1(n560), .S(n559), .X(n562));
  SEH_OAI211_1 U135 (.A1(n802), .A2(n667), .B1(n801), .B2(n116), .X(pwmc_g_n67));
  SEH_INV_S_1 U715 (.A(\pwmc_g_accum[8] ), .X(n739));
  SEH_AOI22_1 U494 (.A1(leddcr0[6]), .A2(n741), .B1(n739), .B2(n169), .X(n626));
  SEH_OA22_1 U314 (.A1(n158_2), .A2(n556), .B1(n159_2), .B2(n557), .X(n552));
  SEH_AOI22_1 U987 (.A1(n148), .A2(n658), .B1(n149_1), .B2(n659), .X(n657));
  SEH_INV_S_1 U614 (.A(\pwmc_b_step[12] ), .X(n558));
  SEH_MAJI3_1 U1037 (.A1(\pwmc_r_step[6] ), .A2(n796), .A3(n884), .X(n798));
  SEH_INV_S_1 U697 (.A(\pwmc_r_accum[7] ), .X(n886));
  SEH_INV_S_1 U704 (.A(\pwmc_r_step[2] ), .X(n781));
  SEH_AOI221_1 U882 (.A1(n345), .A2(ledd_ps32k), .B1(n344), .B2(n343), .C(n401), 
     .X(n292));
  SEH_INV_S_1 U684 (.A(\pwmc_r_accum[8] ), .X(n888));
  SEH_MAJI3_1 U1039 (.A1(\pwmc_r_accum[7] ), .A2(n896), .A3(n798), .X(n804));
  SEH_INV_S_1 U685 (.A(\pwmc_r_accum[6] ), .X(n884));
  SEH_MAJI3_1 U1041 (.A1(\pwmc_r_step[8] ), .A2(\pwmc_r_accum[8] ), .A3(n803), 
     .X(n806));
  SEH_MAJI3_1 U1042 (.A1(\pwmc_r_step[8] ), .A2(n804), .A3(n888), .X(n805));
  SEH_MUXI2_1 U143 (.D0(n120), .D1(n121), .S(n122), .X(pwmc_r_n60));
  SEH_OA2BB2_1 U62 (.A1(\pwmc_g_step[6] ), .A2(n735), .B1(n735), 
     .B2(\pwmc_g_step[6] ), .X(n53));
  SEH_EN2_1 U529 (.A1(\pwmc_b_step[8] ), .A2(n605), .X(n516));
  SEH_INV_S_1 U716 (.A(\pwmc_g_accum[6] ), .X(n735));
  SEH_EN2_1 U536 (.A1(n611), .A2(\pwmc_b_step[11] ), .X(n542));
  SEH_AOI21_S_1 U369 (.A1(n856), .A2(leddpwbr[4]), .B(n855), .X(n554));
  SEH_OA22_1 U943 (.A1(n158_2), .A2(n548), .B1(n159_2), .B2(n549), .X(n543));
  SEH_AO2BB2_1 U269 (.A1(n164_2), .A2(n614), .B1(n900), .B2(\pwmc_b_step[8] ), 
     .X(pwmc_b_n98));
  SEH_MUX2_G_1 U650 (.D0(n864), .D1(n863), .S(n862), .X(n865));
  SEH_MAJI3_1 U1061 (.A1(n859), .A2(n858), .A3(\pwmc_r_accum[14] ), .X(n861));
  SEH_AOI22_1 U61 (.A1(n161), .A2(n652), .B1(n149_1), .B2(n653), .X(n52));
  SEH_AN2_S_1 U219 (.A1(\pwmc_r_step[13] ), .A2(n900), .X(pwmc_r_n103));
  SEH_AOI22_1 U336 (.A1(n900), .A2(\pwmc_b_step[6] ), .B1(leddpwbr[7]), 
     .B2(n162_2), .X(n610));
  SEH_OAI211_1 U1017 (.A1(n164_2), .A2(n735), .B1(n734), .B2(n893), 
     .X(pwmc_g_n91));
  SEH_AOI22_1 U327 (.A1(n900), .A2(\pwmc_g_step[2] ), .B1(leddpwgr[3]), 
     .B2(n162_2), .X(n736));
  SEH_INV_S_1 U705 (.A(\pwmc_r_step[10] ), .X(n823));
  SEH_MAJI3_1 U936 (.A1(\pwmc_b_step[8] ), .A2(n522), .A3(n605), .X(n523));
  SEH_AOI22_1 U337 (.A1(n900), .A2(\pwmc_g_step[1] ), .B1(leddpwgr[2]), 
     .B2(n162_2), .X(n734));
  SEH_ND2_S_1 U111 (.A1(n96), .A2(n98), .X(n99));
  SEH_MAJI3_1 U1028 (.A1(n781), .A2(n779), .A3(n778), .X(n782));
  SEH_OAI22_S_1 U171 (.A1(n798), .A2(n159_2), .B1(n797), .B2(n158_2), .X(n144));
  SEH_MAJI3_1 U1029 (.A1(n781), .A2(n780), .A3(\pwmc_r_accum[2] ), .X(n783));
  SEH_OA2BB2_1 U172 (.A1(n896), .A2(\pwmc_r_accum[7] ), .B1(\pwmc_r_accum[7] ), 
     .B2(n896), .X(n145));
  SEH_OA2BB2_1 U142 (.A1(\pwmc_r_step[1] ), .A2(n777), .B1(n777), 
     .B2(\pwmc_r_step[1] ), .X(n122));
  SEH_ND2_S_1 U173 (.A1(n145), .A2(n144), .X(n146));
  SEH_MAJI3_1 U984 (.A1(\pwmc_g_step[6] ), .A2(n653), .A3(n735), .X(n655));
  SEH_EN2_1 U520 (.A1(n613), .A2(\pwmc_b_step[12] ), .X(n550));
  SEH_ND2_S_1 U328 (.A1(leddpwgr[0]), .A2(n162_2), .X(n730));
  SEH_OAI21_S_1 U112 (.A1(n96), .A2(n97), .B(n99), .X(pwmc_r_n61));
  SEH_INV_S_1 U692 (.A(\pwmc_r_accum[1] ), .X(n777));
  SEH_INV_S_1 U691 (.A(\pwmc_r_accum[0] ), .X(n772));
  SEH_MAJI3_1 U1036 (.A1(\pwmc_r_step[6] ), .A2(\pwmc_r_accum[6] ), .A3(n795), 
     .X(n797));
  SEH_ND2_S_1 U542 (.A1(\pwmc_r_step[0] ), .A2(\pwmc_r_accum[0] ), .X(n774));
  SEH_OAOI211_1 U281 (.A1(\pwmc_r_step[0] ), .A2(n772), .B(n773), .C(n771), 
     .X(pwmc_r_n59));
  SEH_ND2_S_1 U509 (.A1(\pwmc_r_step[0] ), .A2(n772), .X(n773));
  SEH_MAJI3_1 U1026 (.A1(\pwmc_r_step[1] ), .A2(\pwmc_r_accum[1] ), .A3(n775), 
     .X(n778));
  SEH_OAI21_1 U174 (.A1(n145), .A2(n143), .B(n146), .X(pwmc_r_n66));
  SEH_MAJI3_1 U1027 (.A1(n777), .A2(\pwmc_r_step[1] ), .A3(n776), .X(n780));
  SEH_OA22_1 U295 (.A1(n158_2), .A2(n803), .B1(n159_2), .B2(n804), .X(n799));
  SEH_AOI22_1 U140 (.A1(n773), .A2(n147_2), .B1(n774), .B2(n148), .X(n120));
  SEH_AOI31_1 U897 (.A1(state[3]), .A2(n402), .A3(n385), .B(n391), .X(n386));
  SEH_AOAI211_1 U313 (.A1(n332), .A2(n331), .B(n289), .C(mult_cnt[3]), .X(n290));
  SEH_OAI21_S_1 U212 (.A1(1'b0), .A2(n160), .B(n291), .X(n288));
  SEH_AO32_1 U865 (.A1(mult_cnt[1]), .A2(n286), .A3(n162_1), .B1(n287), 
     .B2(n330), .X(n3390));
  SEH_ND2_S_1 U445 (.A1(mult_cnt[1]), .A2(n287), .X(n291));
  SEH_OAI22_S_1 U110 (.A1(n780), .A2(n159_2), .B1(n778), .B2(n158_2), .X(n98));
  SEH_INV_S_1 U690 (.A(n773), .X(n776));
  SEH_OR3_1 U333 (.A1(n475), .A2(n474), .A3(n473), .X(n159));
  SEH_AOI22_1 U344 (.A1(n900), .A2(\pwmc_r_step[0] ), .B1(leddpwrr[1]), 
     .B2(n162_2), .X(n881));
  SEH_OAI211_1 U1068 (.A1(n164_2), .A2(n884), .B1(n883), .B2(n893), 
     .X(pwmc_r_n91));
  SEH_OAI211_1 U1071 (.A1(n164_2), .A2(n890), .B1(n889), .B2(n163), 
     .X(pwmc_r_n94));
  SEH_AO2BB2_1 U796 (.A1(n355), .A2(n346), .B1(t_mult[7]), .B2(n160), .X(net935));
  SEH_AOI21_S_1 U363 (.A1(n856), .A2(leddpwrr[5]), .B(n855), .X(n845));
  SEH_INV_S_2 U742 (.A(n401), .X(n328));
  SEH_BUF_4 BW2_BUF49 (.A(n158), .X(n158_2));
  SEH_OAI211_2 U915 (.A1(n470), .A2(n475), .B1(n469), .B2(n471), .X(pwmc_r_n22));
  SEH_ND2_S_1 U204 (.A1(n336), .A2(leddcr0[1]), .X(n337));
  SEH_AOI31_1 U895 (.A1(n381), .A2(state[0]), .A3(n383), .B(n397), .X(n377));
  SEH_INV_S_1 U694 (.A(\pwmc_r_accum[5] ), .X(n882));
  SEH_ND2_S_1 U234 (.A1(state[1]), .A2(n195), .X(n375));
  SEH_NR2_S_2 U231 (.A1(n195), .A2(n376), .X(n241));
  SEH_MAJI3_1 U1034 (.A1(n791), .A2(\pwmc_r_step[5] ), .A3(\pwmc_r_accum[5] ), 
     .X(n794));
  SEH_NR2_T_1 U224 (.A1(n394), .A2(state[0]), .X(n511));
  SEH_ND2_S_1 U207 (.A1(state[3]), .A2(state[2]), .X(n196));
  SEH_INV_S_1 U693 (.A(\pwmc_r_accum[3] ), .X(n784));
  SEH_INV_S_1 U698 (.A(\pwmc_r_step[7] ), .X(n896));
  SEH_INV_S_1 U700 (.A(n790), .X(n791));
  SEH_MAJI3_1 U1035 (.A1(n882), .A2(\pwmc_r_step[5] ), .A3(n792), .X(n793));
  SEH_OAI211_1 U898 (.A1(n396), .A2(n387), .B1(n164_2), .B2(n386), 
     .X(next_state[1]));
  SEH_AOI22_1 U359 (.A1(n513), .A2(n399), .B1(n393), .B2(n380), .X(n387));
  SEH_AOI22_1 U141 (.A1(n148), .A2(n775), .B1(n147_2), .B2(n776), .X(n121));
  SEH_INV_S_1 U701 (.A(n786), .X(n787));
  SEH_INV_S_1 U689 (.A(n785), .X(n788));
  SEH_MAJI3_1 U1033 (.A1(\pwmc_r_step[4] ), .A2(n788), .A3(n880), .X(n789));
  SEH_MUXI2_1 U155 (.D0(n129), .D1(n130), .S(n131), .X(pwmc_r_n64));
  SEH_INV_S_1 U699 (.A(n794), .X(n795));
  SEH_AOI22_1 U152 (.A1(n789), .A2(n147_2), .B1(n790), .B2(n148), .X(n129));
  SEH_INV_S_1 U686 (.A(n793), .X(n796));
  SEH_NR2_S_2 U534 (.A1(n199), .A2(n375), .X(n240));
  SEH_AOI22_1 U118 (.A1(n148), .A2(n795), .B1(n796), .B2(n147_2), .X(n104));
  SEH_MUX2_G_1 U58 (.D0(n799), .D1(n800), .S(n49), .X(n50));
  SEH_AO221_1 U889 (.A1(n160), .A2(t_mult[3]), .B1(n162_2), .B2(n357), .C(n366), 
     .X(net947));
  SEH_NR3_1 U555 (.A1(skew_delay_b[3]), .A2(skew_delay_b[2]), 
     .A3(skew_delay_b[0]), .X(n338));
  SEH_INV_S_1 U703 (.A(\pwmc_r_accum[2] ), .X(n779));
  SEH_INV_S_1 U702 (.A(n774), .X(n775));
  SEH_AOI22_1 U121 (.A1(n785), .A2(n147_2), .B1(n786), .B2(n148), .X(n106));
  SEH_AOI22_1 U1040 (.A1(n148), .A2(n803), .B1(n149_1), .B2(n804), .X(n800));
  SEH_INV_S_1 U256 (.A(n160), .X(n162));
  SEH_AOI22_1 U170 (.A1(n798), .A2(n149_1), .B1(n797), .B2(n148), .X(n143));
  SEH_NR2B_2 U272 (.A(n402), .B(state[3]), .X(n370));
  SEH_NR4_1 U878 (.A1(skew_delay_b[14]), .A2(skew_delay_b[8]), 
     .A3(skew_delay_b[9]), .A4(skew_delay_b[15]), .X(n335));
  SEH_INV_S_1 \U345_1/C1_MP_INV  (.A(n162_2), .X(n162_1));
  SEH_OAI31_1 U300 (.A1(mult_cnt[3]), .A2(n331), .A3(n291), .B(n290), .X(n3410));
  SEH_INV_S_1 U579 (.A(n286), .X(n287));
  SEH_INV_S_1 U706 (.A(\pwmc_r_accum[10] ), .X(n892));
  SEH_NR2_S_2 U465 (.A1(n393), .A2(n369), .X(n239));
  SEH_INV_S_2 U590 (.A(n470), .X(n757));
  SEH_ND2_S_2P5 U462 (.A1(n511), .A2(n594), .X(n801));
  SEH_AO21B_1 U876 (.A1(n323), .A2(leddcr0[0]), .B(n322), .X(n7910));
  SEH_INV_S_5 U185 (.A(n158), .X(n148));
  SEH_NR4_1 U880 (.A1(skew_delay_b[4]), .A2(skew_delay_b[6]), 
     .A3(skew_delay_b[5]), .A4(skew_delay_b[7]), .X(n333));
  SEH_NR2_1 U466 (.A1(n513), .A2(n466), .X(n470));
  SEH_ND4_S_1 U183 (.A1(n902), .A2(n405), .A3(n404), .A4(n403), 
     .X(next_state[3]));
  SEH_INV_S_1 U500 (.A(n383), .X(n385));
  SEH_MUX2_G_1 U159 (.D0(n132), .D1(n133), .S(n134), .X(pwmc_r_n62));
  SEH_INV_S_1 U276 (.A(state[0]), .X(n195));
  SEH_NR2_1 U230 (.A1(n376), .A2(n375), .X(n382));
  SEH_AOI22_1 U117 (.A1(n793), .A2(n149_1), .B1(n794), .B2(n148), .X(n103));
  SEH_OA2BB2_1 U158 (.A1(\pwmc_r_step[3] ), .A2(n784), .B1(n784), 
     .B2(\pwmc_r_step[3] ), .X(n134));
  SEH_NR2_1 U206 (.A1(state[1]), .A2(n196), .X(n381));
  SEH_OA2BB2_1 U119 (.A1(\pwmc_r_step[6] ), .A2(n884), .B1(n884), 
     .B2(\pwmc_r_step[6] ), .X(n105));
  SEH_ND2_S_1 U273 (.A1(state[3]), .A2(n199), .X(n376));
  SEH_OAI211_1 U1069 (.A1(n164_2), .A2(n886), .B1(n885), .B2(n893), 
     .X(pwmc_r_n92));
  SEH_AOI22_1 U122 (.A1(n148), .A2(n787), .B1(n147_2), .B2(n788), .X(n107));
  SEH_AOI22_1 U240 (.A1(n148), .A2(n821), .B1(n149_1), .B2(n822), .X(n816));
  SEH_AOI22_1 U109 (.A1(n780), .A2(n147_2), .B1(n778), .B2(n148), .X(n97));
  SEH_OA2BB2_1 U108 (.A1(n781), .A2(\pwmc_r_accum[2] ), .B1(\pwmc_r_accum[2] ), 
     .B2(n781), .X(n96));
  SEH_INV_S_1 U277 (.A(state[2]), .X(n199));
  SEH_MAJI3_1 U1032 (.A1(\pwmc_r_step[4] ), .A2(\pwmc_r_accum[4] ), .A3(n787), 
     .X(n790));
  SEH_MUXI2_1 U124 (.D0(n106), .D1(n107), .S(n108), .X(pwmc_r_n63));
  SEH_OA2BB2_1 U154 (.A1(\pwmc_r_step[5] ), .A2(n882), .B1(n882), 
     .B2(\pwmc_r_step[5] ), .X(n131));
  SEH_OA22_1 U299 (.A1(n158_2), .A2(n821), .B1(n159_2), .B2(n822), .X(n817));
  SEH_MAJI3_1 U1031 (.A1(n784), .A2(\pwmc_r_step[3] ), .A3(n783), .X(n785));
  SEH_AOI22_1 U153 (.A1(n148), .A2(n791), .B1(n147_2), .B2(n792), .X(n130));
  SEH_MAJI3_1 U1030 (.A1(n782), .A2(\pwmc_r_step[3] ), .A3(\pwmc_r_accum[3] ), 
     .X(n786));
  SEH_INV_S_1 U687 (.A(n789), .X(n792));
  SEH_OAI22_S_1 U786 (.A1(n164_2), .A2(n898), .B1(n897), .B2(n896), 
     .X(pwmc_r_n97));
  SEH_ND2_S_1 U347 (.A1(leddpwrr[0]), .A2(n162_2), .X(n879));
  SEH_INV_S_1 U597 (.A(\pwmc_b_step[15] ), .X(n587));
  SEH_OA2BB2_1 U123 (.A1(\pwmc_r_step[4] ), .A2(n880), .B1(n880), 
     .B2(\pwmc_r_step[4] ), .X(n108));
  SEH_OAI22_S_1 U156 (.A1(n159_2), .A2(n783), .B1(n158_2), .B2(n782), .X(n132));
  SEH_AO22_1 U157 (.A1(n148), .A2(n782), .B1(n783), .B2(n147_2), .X(n133));
  SEH_INV_S_1 U274 (.A(mult_cnt[2]), .X(n331));
  SEH_MUXI2_1 U120 (.D0(n103), .D1(n104), .S(n105), .X(pwmc_r_n65));
  SEH_MAJI3_1 U1038 (.A1(n797), .A2(n896), .A3(n886), .X(n803));
  SEH_ND2_S_1 U382 (.A1(n512), .A2(n389), .X(n379));
  SEH_INV_S_1 U688 (.A(\pwmc_r_accum[4] ), .X(n880));
  SEH_INV_S_1 U743 (.A(n405), .X(n332));
  SEH_AOI22_1 U182 (.A1(n148), .A2(n830), .B1(n149_1), .B2(n831), .X(n826));
  SEH_NR2B_1 U501 (.A(n240), .B(state[3]), .X(n369));
  SEH_ND4_S_1 U772 (.A1(n160), .A2(n468), .A3(n801), .A4(n467), .X(n473));
  SEH_OAI211_1 U1067 (.A1(n164_2), .A2(n882), .B1(n881), .B2(n893), 
     .X(pwmc_r_n90));
  SEH_OAI211_1 U1070 (.A1(n164_2), .A2(n888), .B1(n887), .B2(n893), 
     .X(pwmc_r_n93));
  SEH_OAOI211_1 U401 (.A1(n318), .A2(n317), .B(n321), .C(n325), .X(n319));
  SEH_FDPRBQ_1 ledd_ps32k_reg (.CK(n903), .D(n292), .Q(ledd_ps32k), .RD(n166));
  SEH_MAJI3_1 U1047 (.A1(n892), .A2(n823), .A3(n821), .X(n830));
  SEH_OAI211_1 U957 (.A1(n868), .A2(n583), .B1(n582), .B2(n581), .X(pwmc_b_n74));
  SEH_NR2_1 U226 (.A1(leddpwbr[7]), .A2(n420), .X(n417));
  SEH_BUF_4 BW2_BUF1565 (.A(n159), .X(n159_2));
  SEH_OAO211_DG_4 U175 (.A1(n472), .A2(n475), .B(n471), .C(n473), .X(n158));
  SEH_NR4_1 U879 (.A1(skew_delay_b[11]), .A2(skew_delay_b[12]), 
     .A3(skew_delay_b[10]), .A4(skew_delay_b[13]), .X(n334));
  SEH_ND4_S_2 U511 (.A1(mult_cnt[3]), .A2(mult_cnt[0]), .A3(n331), .A4(n330), 
     .X(n383));
  SEH_ND2_S_1 U356 (.A1(n395), .A2(n394), .X(next_state[2]));
  SEH_NR3_2 U235 (.A1(state[1]), .A2(state[0]), .A3(state[2]), .X(n402));
  SEH_ND2_S_1 U561 (.A1(n402), .A2(n401), .X(n403));
  SEH_AOI22_1 U503 (.A1(state[0]), .A2(n381), .B1(state[3]), .B2(n402), .X(n405));
  SEH_INV_S_1 U682 (.A(\pwmc_r_accum[11] ), .X(n895));
  SEH_ND2_S_1 U437 (.A1(n900), .A2(t_mult[0]), .X(n471));
  SEH_OA2BB2_1 U57 (.A1(\pwmc_r_step[8] ), .A2(n888), .B1(n888), 
     .B2(\pwmc_r_step[8] ), .X(n49));
  SEH_ND2_S_1 U457 (.A1(n332), .A2(mult_cnt[0]), .X(n286));
  SEH_AOI22_1 U866 (.A1(mult_cnt[2]), .A2(n288), .B1(n291), .B2(n331), .X(n3400));
  SEH_INV_S_1 U578 (.A(n288), .X(n289));
  SEH_INV_S_1 U775 (.A(mult_cnt[1]), .X(n330));
  SEH_INV_S_1 U560 (.A(mult_cnt[0]), .X(n284));
  SEH_OAI32_1 U864 (.A1(n162_2), .A2(n284), .A3(n332), .B1(mult_cnt[0]), 
     .B2(n405), .X(n3380));
  SEH_AOAI211_1 U535 (.A1(n335), .A2(n334), .B(n339), .C(n333), .X(n336));
  SEH_INV_S_1 U424 (.A(n302), .X(n345));
  SEH_AOI22_1 U475 (.A1(leddcr0[6]), .A2(\pwmc_r_accum[11] ), 
     .B1(\pwmc_r_accum[10] ), .B2(n169), .X(n760));
  SEH_OAI22_S_1 U793 (.A1(n512), .A2(n384), .B1(n396), .B2(n474), .X(n391));
  SEH_NR2_1 U480 (.A1(state[1]), .A2(n373), .X(n393));
  SEH_INV_S_8 U177 (.A(ledd_rst_async), .X(n1));
  SEH_INV_S_1 U571 (.A(leddcr0[4]), .X(n297));
  SEH_BUF_4 BW2_BUF740 (.A(n162), .X(n162_2));
  SEH_ND2_G_4 U7 (.A1(n332), .A2(n383), .X(n897));
  SEH_AOI22_1 U332 (.A1(n900), .A2(\pwmc_r_step[4] ), .B1(leddpwrr[5]), 
     .B2(n162_2), .X(n889));
  SEH_INV_S_1 U678 (.A(\pwmc_r_step[12] ), .X(n840));
  SEH_BUF_4 BW2_BUF57 (.A(n147), .X(n147_2));
  SEH_INV_S_4 U223 (.A(n897), .X(n900));
  SEH_INV_S_1 U184 (.A(n159_2), .X(n147));
  SEH_NR2_S_3 U468 (.A1(n513), .A2(n240), .X(n214));
  SEH_AOI22_1 U484 (.A1(leddcr0[6]), .A2(\pwmc_r_accum[10] ), 
     .B1(\pwmc_r_accum[9] ), .B2(n169), .X(n761));
  SEH_AO21B_1 U883 (.A1(n160), .A2(t_mult[6]), .B(n359), .X(net938));
  SEH_ND2_S_1 U198 (.A1(n318), .A2(n317), .X(n321));
  SEH_MUX2_G_1 U656 (.D0(n817), .D1(n816), .S(n815), .X(n818));
  SEH_INV_S_1 U757 (.A(ledd_pscnt[7]), .X(n317));
  SEH_MUX2_G_1 U712 (.D0(n689), .D1(n688), .S(n687), .X(n690));
  SEH_AOI21_S_1 U371 (.A1(n856), .A2(leddpwgr[3]), .B(n855), .X(n683));
  SEH_AOAI211_1 U94 (.A1(n768), .A2(n66), .B(n65), .C(n71), .X(n85));
  SEH_OAI211_1 U954 (.A1(n868), .A2(n572), .B1(n571), .B2(n570), .X(pwmc_b_n73));
  SEH_BUF_S_2 U311 (.A(n893), .X(n163));
  SEH_MUX2_G_1 U670 (.D0(n834), .D1(n833), .S(n832), .X(n835));
  SEH_NR2_1 U379 (.A1(n388), .A2(n379), .X(n380));
  SEH_MUX2_G_1 U681 (.D0(n826), .D1(n825), .S(n824), .X(n827));
  SEH_INV_S_1 U740 (.A(n512), .X(n399));
  SEH_MAJI3_1 U1052 (.A1(n895), .A2(\pwmc_r_step[11] ), .A3(n831), .X(n839));
  SEH_MAJI3_1 U1051 (.A1(n830), .A2(\pwmc_r_accum[11] ), .A3(\pwmc_r_step[11] ), 
     .X(n838));
  SEH_AOI22_1 U249 (.A1(n148), .A2(n838), .B1(n149_1), .B2(n839), .X(n833));
  SEH_EN2_1 U525 (.A1(n895), .A2(\pwmc_r_step[11] ), .X(n824));
  SEH_OAOI211_1 U381 (.A1(n513), .A2(n466), .B(n512), .C(n511), .X(n468));
  SEH_ND2_S_1 U531 (.A1(n370), .A2(n328), .X(n4810));
  SEH_INV_S_1 U771 (.A(n472), .X(n513));
  SEH_OAOI211_1 U497 (.A1(n390), .A2(n389), .B(n388), .C(n396), .X(n392));
  SEH_INV_S_1 U753 (.A(n381), .X(n394));
  SEH_MAJI3_1 U1048 (.A1(n823), .A2(n822), .A3(\pwmc_r_accum[10] ), .X(n831));
  SEH_INV_S_1 U227 (.A(n466), .X(n474));
  SEH_AOI22_1 U343 (.A1(n900), .A2(\pwmc_r_step[6] ), .B1(leddpwrr[7]), 
     .B2(n162_2), .X(n894));
  SEH_INV_S_1 U739 (.A(n382), .X(n467));
  SEH_AOI211_1 U894 (.A1(n390), .A2(n388), .B1(state[1]), .B2(n379), .X(n374));
  SEH_OAI211_1 U1066 (.A1(n164_2), .A2(n880), .B1(n163), .B2(n879), 
     .X(pwmc_r_n89));
  SEH_BUF_D_4 BW2_BUF1566 (.A(n902), .X(n164_2));
  SEH_INV_S_1 U770 (.A(n241), .X(n373));
  SEH_NR3_1 U376 (.A1(n396), .A2(n374), .A3(n373), .X(n397));
  SEH_ND2_S_1 U350 (.A1(n160), .A2(n897), .X(alt14_n129));
  SEH_OA22_2 U186 (.A1(n328), .A2(n342), .B1(n399), .B2(n239), .X(n160));
  SEH_OAI211_1 U1073 (.A1(n164_2), .A2(n895), .B1(n894), .B2(n893), 
     .X(pwmc_r_n96));
  SEH_ND2_S_1 U228 (.A1(state[1]), .A2(n241), .X(n472));
  SEH_EN2_1 U540 (.A1(n898), .A2(\pwmc_r_step[12] ), .X(n832));
  SEH_AOAI211_1 U409 (.A1(ledd_pscnt[6]), .A2(n315), .B(n318), .C(n320), 
     .X(n316));
  SEH_INV_S_1 U741 (.A(n370), .X(n342));
  SEH_AO21_1 U778 (.A1(leddbr[5]), .A2(n323), .B(n314), .X(n7610));
  SEH_NR2_1 U197 (.A1(ledd_pscnt[8]), .A2(n321), .X(n327));
  SEH_NR2_1 U310 (.A1(n360), .A2(n359), .X(n365));
  SEH_OAI21_2 U425 (.A1(n370), .A2(n302), .B(n328), .X(n323));
  SEH_NR2B_2 U237 (.A(ledd_exe_sense[2]), .B(ledd_exe_sense[1]), .X(n401));
  SEH_MAJI3_1 U1044 (.A1(n813), .A2(\pwmc_r_step[9] ), .A3(\pwmc_r_accum[9] ), 
     .X(n821));
  SEH_MAJI3_1 U998 (.A1(n685), .A2(\pwmc_g_accum[11] ), .A3(\pwmc_g_step[11] ), 
     .X(n693));
  SEH_INV_S_1 U602 (.A(\pwmc_b_accum[15] ), .X(n584));
  SEH_MUX2_G_1 U767 (.D0(leddbcfr[0]), .D1(leddbcrr[0]), .S(n209), .X(n353));
  SEH_AOI21_S_1 U375 (.A1(n856), .A2(leddpwbr[3]), .B(n855), .X(n546));
  SEH_ND3_S_1 U346 (.A1(n350), .A2(n356), .A3(n162_2), .X(n346));
  SEH_AOI22_1 U491 (.A1(leddcr0[6]), .A2(\pwmc_g_accum[11] ), 
     .B1(\pwmc_g_accum[10] ), .B2(n169), .X(n624));
  SEH_TIE0_G_1 U806 (.X(pwmc_b_net979));
  SEH_OAI21_S_1 U405 (.A1(n572), .A2(n439), .B(n415), .X(n416));
  SEH_ND2_S_1 U349 (.A1(n160), .A2(t_mult[5]), .X(n348));
  SEH_AOI21_S_2 U320 (.A1(n512), .A2(n757), .B(n162_2), .X(n242));
  SEH_INV_S_1 U752 (.A(n594), .X(n510));
  SEH_NR3_2 U417 (.A1(n345), .A2(n401), .A3(n370), .X(n320));
  SEH_AN2_S_1 U215 (.A1(\pwmc_r_step[11] ), .A2(n900), .X(pwmc_r_n101));
  SEH_AOI22_1 U339 (.A1(n900), .A2(\pwmc_r_step[2] ), .B1(leddpwrr[3]), 
     .B2(n162_2), .X(n885));
  SEH_INV_S_1 U340 (.A(n473), .X(n469));
  SEH_AOI22_1 U482 (.A1(leddcr0[6]), .A2(n890), .B1(n888), .B2(n169), .X(n762));
  SEH_INV_S_1 U573 (.A(leddcr0[1]), .X(n340));
  SEH_AOI32_1 U872 (.A1(n300), .A2(leddcr0[4]), .A3(n299), .B1(n298), .B2(n297), 
     .X(n301));
  SEH_NR2_1 U378 (.A1(n399), .A2(n384), .X(n398));
  SEH_OAI22_S_1 U790 (.A1(n169), .A2(n898), .B1(n895), .B2(leddcr0[6]), .X(n759));
  SEH_AOI22_1 U323 (.A1(n900), .A2(\pwmc_r_step[3] ), .B1(leddpwrr[4]), 
     .B2(n162_2), .X(n887));
  SEH_OAI21_S_1 U292 (.A1(n160), .A2(n368), .B(n367), .X(net953));
  SEH_ND2B_1 U961 (.A(alt14_n129), .B(n164_2), .X(pwmc_r_n88));
  SEH_OAI211_8 U570 (.A1(n241), .A2(n240), .B1(n463), .B2(n242), .X(n282));
  SEH_ND2_S_1 U338 (.A1(n358), .A2(n162_2), .X(n362));
  SEH_NR2_S_3 U499 (.A1(n241), .A2(n466), .X(n455));
  SEH_AOI22_1 U342 (.A1(n900), .A2(\pwmc_r_step[1] ), .B1(leddpwrr[2]), 
     .B2(n162_2), .X(n883));
  SEH_AOI22_T_1 U780 (.A1(n513), .A2(n512), .B1(n511), .B2(n510), .X(n520));
  SEH_INV_S_3 U176 (.A(leddcr0[6]), .X(n169));
  SEH_AOI211_1 U890 (.A1(n160), .A2(t_mult[1]), .B1(n366), .B2(n365), .X(n367));
  SEH_MUX2_G_1 U601 (.D0(n580), .D1(n579), .S(n578), .X(n581));
  SEH_OAI211_1 U1072 (.A1(n164_2), .A2(n892), .B1(n891), .B2(n163), 
     .X(pwmc_r_n95));
  SEH_OAI211_8 U774 (.A1(n595), .A2(n594), .B1(n162_2), .B2(n593), .X(n893));
  SNPS_CLOCK_GATE_HIGH_ledd_ctrl_5 clk_gate_skew_delay_g_reg_0 (.CLK(ledd_clk_4), 
     .EN(leddcr0[4]), .ENCLK(n907), .TE(pwmc_b_net979));
  SEH_EN2_1 U524 (.A1(n743), .A2(\pwmc_g_step[10] ), .X(n670));
  SEH_INV_S_1 U210 (.A(ledd_pwm_out_g), .X(n293));
  SEH_NR2B_2 U559 (.A(leddcr0[3]), .B(n390), .X(n396));
  SEH_AOI32_2 U869 (.A1(n295), .A2(leddcr0[4]), .A3(n294), .B1(n297), .B2(n293), 
     .X(n296));
  SEH_OAO211_DG_4 U881 (.A1(skew_delay_b[1]), .A2(n341), .B(leddcr0[4]), 
     .C(state[3]), .X(ledd_on_int));
  SEH_INV_S_1 U275 (.A(ledd_ps32k), .X(n343));
  SEH_INV_S_1 U209 (.A(ledd_pwm_out_b), .X(n298));
  SEH_OA22_1 U307 (.A1(n158_2), .A2(n838), .B1(n159_2), .B2(n839), .X(n834));
  SEH_OAI211_1 U896 (.A1(leddbcrr[7]), .A2(n378), .B1(n377), .B2(n467), 
     .X(next_state[0]));
  SEH_OA22_1 U1049 (.A1(n158_2), .A2(n830), .B1(n159_2), .B2(n831), .X(n825));
  SEH_AOAI211_1 U495 (.A1(n340), .A2(n339), .B(n338), .C(n337), .X(n341));
  SEH_OAI221_1 U867 (.A1(leddcr0[1]), .A2(skew_delay_g[1]), .B1(n340), 
     .B2(skew_delay_g[7]), .C(leddcr0[0]), .X(n295));
  SEH_AOI21_S_1 U794 (.A1(n370), .A2(n401), .B(n398), .X(n378));
  SEH_AOI22_1 U293 (.A1(n161), .A2(n693), .B1(n147_2), .B2(n694), .X(n688));
  SEH_MUX2_G_1 U27 (.D0(n624), .D1(n684), .S(n13), .X(n21));
  SEH_OAI22_S_1 U397 (.A1(n232), .A2(n272), .B1(n231), .B2(time_cnt[14]), 
     .X(n230));
  SEH_OAI21_S_1 U280 (.A1(\pwmc_b_accum[16] ), .A2(n592), .B(n591), 
     .X(pwmc_b_n75));
  SEH_AOAI211_1 U329 (.A1(n363), .A2(n349), .B(n160), .C(n348), .X(net941));
  SEH_INV_S_1 U764 (.A(n360), .X(n355));
  SEH_MAJI3_1 U993 (.A1(n741), .A2(\pwmc_g_step[9] ), .A3(n669), .X(n677));
  SEH_MAJI3_1 U955 (.A1(n615), .A2(n575), .A3(n573), .X(n576));
  SEH_INV_S_1 U683 (.A(n805), .X(n814));
  SEH_INV_S_1 U566 (.A(n912), .X(n150));
  SEH_AOI22_1 U245 (.A1(n148), .A2(n585), .B1(n149_1), .B2(n586), .X(n579));
  SEH_AOI21_S_1 U803 (.A1(leddpwbr[6]), .A2(n856), .B(n855), .X(n571));
  SEH_ND2_S_1 U200 (.A1(n313), .A2(n312), .X(n315));
  SEH_ND2_1 U431 (.A1(n327), .A2(n326), .X(n302));
  SEH_ND2_S_1 U421 (.A1(leddcr0[1]), .A2(n323), .X(n324));
  SEH_OAOI211_1 U402 (.A1(n313), .A2(n312), .B(n315), .C(n325), .X(n314));
  SEH_AO21_1 U777 (.A1(leddbr[7]), .A2(n323), .B(n319), .X(n7810));
  SEH_OAI22_S_1 U792 (.A1(n169), .A2(\pwmc_b_accum[16] ), 
     .B1(\pwmc_b_accum[15] ), .B2(leddcr0[6]), .X(n420));
  SEH_INV_S_1 U773 (.A(ledd_pscnt[9]), .X(n326));
  SEH_AOI22_1 U254 (.A1(n148), .A2(n676), .B1(n147_2), .B2(n677), .X(n671));
  SEH_INV_S_1 U572 (.A(leddcr0[0]), .X(n339));
  SEH_ND2_S_1 U419 (.A1(n345), .A2(n342), .X(n344));
  SEH_NR2_1 U199 (.A1(ledd_pscnt[6]), .A2(n315), .X(n318));
  SEH_OAI221_1 U871 (.A1(leddcr0[1]), .A2(skew_delay_b[1]), .B1(n340), 
     .B2(skew_delay_b[7]), .C(n339), .X(n299));
  SEH_AOAI211_G_1 U414 (.A1(ledd_pscnt[8]), .A2(n321), .B(n327), .C(n320), 
     .X(n322));
  SEH_ND2_S_1 U352 (.A1(n160), .A2(t_mult[4]), .X(n351));
  SEH_AOI21_S_1 U798 (.A1(n160), .A2(t_mult[2]), .B(n365), .X(n361));
  SEH_INV_S_1 U758 (.A(ledd_pscnt[5]), .X(n312));
  SEH_FDPRBQ_1 \pwmc_b/ledd_pwmout_reg  (.CK(ledd_clk_1), .D(pwmc_b_n118), 
     .Q(ledd_pwm_out_b), .RD(n1));
  SEH_OAI31_1 U877 (.A1(n327), .A2(n326), .A3(n325), .B(n324), .X(n8010));
  SEH_AOI21_S_2 U426 (.A1(n169), .A2(n343), .B(n302), .X(n463));
  SEH_BUF_D_8 BW1_BUF745 (.A(n167), .X(n167_1));
  SEH_MUX2_G_1 U672 (.D0(n672), .D1(n671), .S(n670), .X(n673));
  SEH_MAJI3_1 U995 (.A1(n743), .A2(n678), .A3(n676), .X(n685));
  SNPS_CLOCK_GATE_HIGH_ledd_ctrl_8 clk_gate_ledd_pwmcnt_reg_0 (.CLK(ledd_clk_3), 
     .EN(n920), .ENCLK(n904), .TE(pwmc_b_net979));
  SEH_FDPRBQ_1 ledd_on_reg (.CK(ledd_clk_1), .D(ledd_on_int), .Q(n913), 
     .RD(n166));
  SEH_NR3_3 U271 (.A1(n381), .A2(n393), .A3(n466), .X(n595));
  SEH_FDPRBQ_V2_3 \pwmc_g/ledd_pwmout_reg  (.CK(ledd_clk_1), .D(pwmc_g_n118), 
     .Q(ledd_pwm_out_g), .RD(n168_2));
  SEH_NR2_S_2 U533 (.A1(n196), .A2(n375), .X(n466));
  SEH_ND2_S_1 U487 (.A1(n369), .A2(n390), .X(n384));
  SEH_AOAI211_1 U797 (.A1(n364), .A2(n363), .B(n362), .C(n361), .X(net950));
  SEH_OAI22_S_1 U801 (.A1(n589), .A2(n159_2), .B1(n158_2), .B2(n588), .X(n590));
  SEH_AOI22_1 U960 (.A1(leddpwbr[7]), .A2(n876), .B1(\pwmc_b_accum[16] ), 
     .B2(n590), .X(n591));
  SEH_OAI22_S_1 U782 (.A1(n902), .A2(n721), .B1(n897), .B2(n678), 
     .X(pwmc_g_n100));
  SEH_MAJI3_1 U906 (.A1(n758), .A2(n424), .A3(n423), .X(n461));
  SEH_INV_S_1 U727 (.A(\pwmc_g_accum[11] ), .X(n745));
  SEH_INV_S_1 U470 (.A(n420), .X(n421));
  SEH_ND2_S_1 U192 (.A1(time_cnt[15]), .A2(n231), .X(n218));
  SEH_FDPRBQ_V2_3 \pwmc_r/ledd_pwmout_reg  (.CK(ledd_clk_1), .D(pwmc_r_n118_1), 
     .Q(ledd_pwm_out_r), .RD(n165));
  SEH_INV_S_1 U451 (.A(n239), .X(n201));
  SEH_INV_S_1 U608 (.A(leddpwbr[3]), .X(n555));
  SEH_AOI21_S_1 U355 (.A1(n856), .A2(leddpwrr[6]), .B(n855), .X(n853));
  SEH_AOI22_1 U252 (.A1(n148), .A2(n576), .B1(n149_1), .B2(n577), .X(n580));
  SEH_MAJI3_1 U992 (.A1(n668), .A2(\pwmc_g_step[9] ), .A3(\pwmc_g_accum[9] ), 
     .X(n676));
  SEH_OAI211_1 U1053 (.A1(n868), .A2(n837), .B1(n836), .B2(n835), .X(pwmc_r_n71));
  SEH_INV_S_1 U673 (.A(leddpwgr[1]), .X(n675));
  SEH_ND2_S_1 U262 (.A1(n364), .A2(n368), .X(n204));
  SEH_OAI22_S_1 U789 (.A1(n169), .A2(n747), .B1(n745), .B2(leddcr0[6]), .X(n623));
  SEH_NR2B_1 U446 (.A(n618), .B(n617), .X(n620));
  SEH_MAJI3_1 U1045 (.A1(n890), .A2(\pwmc_r_step[9] ), .A3(n814), .X(n822));
  SEH_INV_S_1 U695 (.A(\pwmc_r_accum[9] ), .X(n890));
  SEH_EN2_1 U519 (.A1(n584), .A2(\pwmc_b_step[15] ), .X(n578));
  SEH_EN2_1 U507 (.A1(n892), .A2(\pwmc_r_step[10] ), .X(n815));
  SEH_ND2_S_1 U407 (.A1(n414), .A2(n413), .X(n415));
  SEH_INV_S_1 U737 (.A(\pwmc_g_step[10] ), .X(n678));
  SEH_INV_S_1 U611 (.A(leddpwbr[5]), .X(n572));
  SEH_AOI22_1 U478 (.A1(leddcr0[6]), .A2(\pwmc_b_accum[15] ), 
     .B1(\pwmc_b_accum[14] ), .B2(n169), .X(n422));
  SEH_INV_S_24 U546 (.A(n154), .X(ledd_on));
  SEH_NR2_S_4 U5 (.A1(n511), .A2(n382), .X(n902));
  SEH_AN2_S_1 U236 (.A1(ledd_exe_sense[2]), .A2(ledd_exe_sense[0]), .X(n390));
  SEH_OAI221_1 U868 (.A1(leddcr0[1]), .A2(skew_delay_g[0]), .B1(n340), 
     .B2(skew_delay_g[3]), .C(n339), .X(n294));
  SEH_AOI211_1 U900 (.A1(n400), .A2(n399), .B1(n398), .B2(n397), .X(n404));
  SEH_OAI221_1 U870 (.A1(leddcr0[1]), .A2(skew_delay_b[3]), .B1(n340), 
     .B2(skew_delay_b[15]), .C(leddcr0[0]), .X(n300));
  SEH_AOI22_1 U317 (.A1(n900), .A2(\pwmc_r_step[5] ), .B1(leddpwrr[6]), 
     .B2(n162_2), .X(n891));
  SEH_AOI21_S_1 U361 (.A1(n856), .A2(leddpwrr[1]), .B(n855), .X(n811));
  SEH_AOI31_1 U899 (.A1(n393), .A2(n512), .A3(n392), .B(n391), .X(n395));
  SEH_NR2_1 U492 (.A1(n396), .A2(n474), .X(n400));
  SEH_AOI22_1 U241 (.A1(n148), .A2(n806), .B1(n149_1), .B2(n805), .X(n808));
  SNPS_CLOCK_GATE_HIGH_ledd_ctrl_7 clk_gate_time_cnt_reg_0 (.CLK(ledd_clk_4), 
     .EN(n2510), .ENCLK(n905), .TE(pwmc_b_net979));
  SEH_INV_S_1 U567 (.A(n910), .X(n152));
  SEH_INV_S_1 U569 (.A(n911), .X(n156));
  SEH_FDPRBQ_1 pwm_out_r_reg (.CK(ledd_clk_1), .D(n3440), .Q(n910), .RD(n168_2));
  SNPS_CLOCK_GATE_HIGH_ledd_pwmc_7 \clk_gate_pwmc_r/step_reg  (.CLK(ledd_clk), 
     .EN(pwmc_r_n88), .ENCLK(n908), .TE(pwmc_b_net979));
  SEH_AOI21_S_1 U370 (.A1(n856), .A2(leddpwrr[3]), .B(n855), .X(n828));
  SEH_MAJI3_1 U996 (.A1(n678), .A2(n677), .A3(\pwmc_g_accum[10] ), .X(n686));
  SEH_AO2BB2_1 U270 (.A1(n902), .A2(n748), .B1(n900), .B2(\pwmc_g_step[8] ), 
     .X(pwmc_g_n98));
  SEH_AOI22_1 U481 (.A1(leddcr0[6]), .A2(\pwmc_g_accum[10] ), 
     .B1(\pwmc_g_accum[9] ), .B2(n169), .X(n625));
  SEH_MAJI3_1 U958 (.A1(n585), .A2(n584), .A3(n587), .X(n588));
  SEH_ND2_S_1 U201 (.A1(n572), .A2(n439), .X(n413));
  SEH_OA22_1 U296 (.A1(n158_2), .A2(n676), .B1(n159_2), .B2(n677), .X(n672));
  SEH_INV_S_1 U636 (.A(n524), .X(n531));
  SEH_MAJI3_1 U1055 (.A1(n840), .A2(n839), .A3(\pwmc_r_accum[12] ), .X(n848));
  SEH_MAJI3_1 U1054 (.A1(n898), .A2(n840), .A3(n838), .X(n847));
  SEH_AOI22_1 U490 (.A1(leddcr0[6]), .A2(n607), .B1(n605), .B2(n169), .X(n431));
  SEH_MUX2_G_1 U621 (.D0(n535), .D1(n534), .S(n533), .X(n536));
  SEH_INV_S_1 U665 (.A(\pwmc_r_accum[14] ), .X(n901));
  SEH_NR2_1 U460 (.A1(n530), .A2(n431), .X(n406));
  SEH_INV_S_1 U677 (.A(\pwmc_r_accum[13] ), .X(n899));
  SEH_NR2_S_6 U187 (.A1(leddcr0[6]), .A2(n520), .X(n856));
  SEH_AOI22_1 U488 (.A1(leddcr0[6]), .A2(n901), .B1(n899), .B2(n169), .X(n765));
  SEH_MAJI3_1 U1064 (.A1(\pwmc_r_accum[15] ), .A2(n872), .A3(n871), .X(n874));
  SEH_AOI22_1 U243 (.A1(n148), .A2(n548), .B1(n149_1), .B2(n549), .X(n544));
  SEH_AOI22_1 U331 (.A1(n900), .A2(\pwmc_b_step[5] ), .B1(leddpwbr[6]), 
     .B2(n162_2), .X(n608));
  SEH_OA22_1 U306 (.A1(n158_2), .A2(n857), .B1(n159_2), .B2(n858), .X(n851));
  SEH_OAI211_1 U968 (.A1(n164_2), .A2(n609), .B1(n608), .B2(n163), 
     .X(pwmc_b_n95));
  SEH_AOI22_1 U486 (.A1(leddcr0[6]), .A2(\pwmc_b_accum[10] ), 
     .B1(\pwmc_b_accum[9] ), .B2(n169), .X(n430));
  SEH_OA22_1 U297 (.A1(n158_2), .A2(n539), .B1(n159_2), .B2(n540), .X(n535));
  SEH_AOI22_1 U483 (.A1(leddcr0[6]), .A2(\pwmc_b_accum[11] ), 
     .B1(\pwmc_b_accum[10] ), .B2(n169), .X(n428));
  SEH_INV_S_1 U651 (.A(\pwmc_r_accum[15] ), .X(n869));
  SEH_INV_S_1 U679 (.A(\pwmc_r_accum[12] ), .X(n898));
  SEH_AOI22_1 U242 (.A1(n148), .A2(n539), .B1(n149_1), .B2(n540), .X(n534));
  SEH_EN2_1 U538 (.A1(n609), .A2(\pwmc_b_step[10] ), .X(n533));
  SEH_OAI211_1 U944 (.A1(n868), .A2(n547), .B1(n546), .B2(n545), .X(pwmc_b_n70));
  SEH_INV_S_1 U620 (.A(leddpwbr[2]), .X(n547));
  SEH_OAI211_1 U1056 (.A1(n868), .A2(n846), .B1(n845), .B2(n844), .X(pwmc_r_n72));
  SEH_AOI22_1 U179 (.A1(n161), .A2(n870), .B1(n149_1), .B2(n871), .X(n863));
  SEH_OAI22_S_1 U799 (.A1(n874), .A2(n159_2), .B1(n158_2), .B2(n873), .X(n875));
  SEH_INV_S_1 U600 (.A(leddpwbr[0]), .X(n530));
  SEH_NR2_S_2 U258 (.A1(n520), .A2(n169), .X(n876));
  SEH_AOI22_1 U476 (.A1(leddcr0[6]), .A2(n899), .B1(n898), .B2(n169), .X(n764));
  SEH_OAI211_1 U937 (.A1(n868), .A2(n530), .B1(n529), .B2(n528), .X(pwmc_b_n68));
  SEH_AOI21_S_1 U364 (.A1(n856), .A2(leddpwbr[1]), .B(n855), .X(n529));
  SEH_INV_S_1 U619 (.A(\pwmc_b_step[10] ), .X(n541));
  SEH_OAI211_1 U1043 (.A1(n868), .A2(n812), .B1(n811), .B2(n810), .X(pwmc_r_n68));
  SEH_AOI22_1 U181 (.A1(n148), .A2(n873), .B1(n149_1), .B2(n874), .X(n878));
  SEH_INV_S_1 U652 (.A(n861), .X(n871));
  SEH_MAJI3_1 U942 (.A1(n541), .A2(n540), .A3(\pwmc_b_accum[10] ), .X(n549));
  SEH_INV_S_1 U592 (.A(\pwmc_r_step[15] ), .X(n872));
  SEH_INV_S_1 U635 (.A(\pwmc_b_accum[9] ), .X(n607));
  SEH_INV_S_1 U653 (.A(n860), .X(n870));
  SEH_MAJI3_1 U941 (.A1(n609), .A2(n541), .A3(n539), .X(n548));
  SEH_EN2_1 U537 (.A1(\pwmc_b_step[9] ), .A2(n607), .X(n525));
  SEH_AOI22_1 U247 (.A1(n148), .A2(n860), .B1(n149_1), .B2(n861), .X(n864));
  SEH_AO2BB2_1 U266 (.A1(n164_2), .A2(n615), .B1(n900), .B2(\pwmc_b_step[9] ), 
     .X(pwmc_b_n99));
  SEH_OAI22_S_1 U791 (.A1(n169), .A2(n613), .B1(n611), .B2(leddcr0[6]), .X(n427));
  SEH_MAJI3_1 U1063 (.A1(n870), .A2(n869), .A3(n872), .X(n873));
  SEH_MUX2_G_1 U77 (.D0(n759), .D1(leddpwrr[3]), .S(n59), .X(n67));
  SEH_MAJI3_1 U901 (.A1(n430), .A2(leddpwbr[1]), .A3(n406), .X(n407));
  SEH_BUF_D_8 U564 (.A(n1), .X(n166));
  SEH_INV_S_1 U762 (.A(time_cnt[16]), .X(n275));
  SEH_BUF_1 ONROUTE_1 (.A(pwmc_r_n118), .X(pwmc_r_n118_1));
  SEH_INV_S_24 U543 (.A(n156), .X(pwm_out_g));
  SEH_NR2_S_1 U129 (.A1(n231), .A2(time_cnt[15]), .X(n112));
  SEH_INV_S_1 U622 (.A(\pwmc_b_accum[10] ), .X(n609));
  SEH_MUX2_G_1 U617 (.D0(n544), .D1(n543), .S(n542), .X(n545));
  SEH_MUX2_G_1 U676 (.D0(n843), .D1(n842), .S(n841), .X(n844));
  SEH_MAJI3_1 U938 (.A1(n531), .A2(\pwmc_b_step[9] ), .A3(\pwmc_b_accum[9] ), 
     .X(n539));
  SEH_AOI221_1 U887 (.A1(n356), .A2(n355), .B1(n358), .B2(n360), .C(n353), 
     .X(n357));
  SEH_INV_S_1 U604 (.A(n576), .X(n585));
  SEH_AO21B_1 U874 (.A1(leddbr[4]), .A2(n323), .B(n311), .X(n7510));
  SEH_AOI32_1 U885 (.A1(n356), .A2(n354), .A3(n353), .B1(n358), .B2(n350), 
     .X(n352));
  SEH_NR2_1 U456 (.A1(n897), .A2(n575), .X(pwmc_b_n104));
  SEH_AOI22_1 U1065 (.A1(n876), .A2(leddpwrr[7]), .B1(\pwmc_r_accum[16] ), 
     .B2(n875), .X(n877));
  SEH_INV_S_1 U647 (.A(leddpwrr[0]), .X(n812));
  SEH_INV_S_1 U671 (.A(leddpwrr[3]), .X(n837));
  SEH_AOI22_1 U479 (.A1(leddcr0[6]), .A2(n615), .B1(n614), .B2(n169), .X(n439));
  SEH_OAI211_1 U950 (.A1(n868), .A2(n564), .B1(n563), .B2(n562), .X(pwmc_b_n72));
  SEH_ND2_S_1 U458 (.A1(n692), .A2(n623), .X(n618));
  SEH_MUX2_G_1 U674 (.D0(n681), .D1(n680), .S(n679), .X(n682));
  SEH_EN2_1 U510 (.A1(n747), .A2(\pwmc_g_step[12] ), .X(n687));
  SEH_MAJI3_1 U999 (.A1(n745), .A2(\pwmc_g_step[11] ), .A3(n686), .X(n694));
  SEH_AOI22_1 U246 (.A1(n148), .A2(n588), .B1(n149_1), .B2(n589), .X(n592));
  SEH_AN2_S_1 U217 (.A1(\pwmc_g_step[11] ), .A2(n900), .X(pwmc_g_n101));
  SEH_NR2_1 U261 (.A1(n418), .A2(n417), .X(n419));
  SEH_MUX2_G_1 U576 (.D0(n422), .D1(n583), .S(n438), .X(n426));
  SEH_OAI211_1 U1046 (.A1(n868), .A2(n820), .B1(n819), .B2(n818), .X(pwmc_r_n69));
  SEH_OA22_1 U1000 (.A1(n158_2), .A2(n693), .B1(n159_2), .B2(n694), .X(n689));
  SEH_MUX2_G_1 U31 (.D0(n625), .D1(n675), .S(n13), .X(n25));
  SEH_ND3_S_1 U324 (.A1(n356), .A2(n354), .A3(n162_2), .X(n359));
  SEH_NR2_1 U459 (.A1(n667), .A2(n626), .X(n616));
  SEH_AOI21_S_1 U367 (.A1(n856), .A2(leddpwgr[2]), .B(n855), .X(n674));
  SEH_OAI211_1 U1001 (.A1(n868), .A2(n692), .B1(n691), .B2(n690), .X(pwmc_g_n71));
  SEH_INV_S_1 U738 (.A(\pwmc_g_accum[10] ), .X(n743));
  SEH_AOAI211_1 U434 (.A1(n624), .A2(n618), .B(n620), .C(leddpwgr[2]), .X(n619));
  SEH_INV_S_1 U675 (.A(leddpwgr[2]), .X(n684));
  SEH_AOAI211_3 U394 (.A1(leddpwbr[7]), .A2(n420), .B(n419), .C(n757), .X(n438));
  SEH_EN2_1 U504 (.A1(n745), .A2(\pwmc_g_step[11] ), .X(n679));
  SEH_OAI31_1 U913 (.A1(n583), .A2(n572), .A3(n454), .B(n461), .X(n456));
  SEH_AO21B_1 U971 (.A1(n620), .A2(n624), .B(n619), .X(n621));
  SEH_FDPRBQ_V2_3 \pwmc_b/accum_reg[0]  (.CK(n909_1), 
     .D(pwmc_b_n59), .Q(\pwmc_b_accum[0] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[1]  (.CK(n909_1), 
     .D(pwmc_b_n60), .Q(\pwmc_b_accum[1] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[2]  (.CK(n909_1), .D(pwmc_b_n61), 
     .Q(\pwmc_b_accum[2] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[3]  (.CK(n909_1), .D(pwmc_b_n62), 
     .Q(\pwmc_b_accum[3] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[4]  (.CK(n909_1), .D(pwmc_b_n63), 
     .Q(\pwmc_b_accum[4] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[5]  (.CK(n909_1), .D(pwmc_b_n64), 
     .Q(\pwmc_b_accum[5] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[6]  (.CK(n909_1), .D(pwmc_b_n65), 
     .Q(\pwmc_b_accum[6] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[7]  (.CK(n909_1), .D(pwmc_b_n66), 
     .Q(\pwmc_b_accum[7] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[8]  (.CK(n909_1), .D(pwmc_b_n67), 
     .Q(\pwmc_b_accum[8] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[9]  (.CK(n909_1), .D(pwmc_b_n68), 
     .Q(\pwmc_b_accum[9] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[10]  (.CK(n909_1), .D(pwmc_b_n69), 
     .Q(\pwmc_b_accum[10] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[11]  (.CK(n909_1), .D(pwmc_b_n70), 
     .Q(\pwmc_b_accum[11] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[12]  (.CK(n909_1), .D(pwmc_b_n71), 
     .Q(\pwmc_b_accum[12] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[13]  (.CK(n909_1), .D(pwmc_b_n72), 
     .Q(\pwmc_b_accum[13] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[14]  (.CK(n909_1), .D(pwmc_b_n73), 
     .Q(\pwmc_b_accum[14] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[15]  (.CK(n909_1), .D(pwmc_b_n74), 
     .Q(\pwmc_b_accum[15] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_b/accum_reg[16]  (.CK(n909_1), .D(pwmc_b_n75), 
     .Q(\pwmc_b_accum[16] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[0]  (.CK(n908_1), .D(pwmc_g_n89), 
     .Q(\pwmc_g_step[0] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[1]  (.CK(n908_1), .D(pwmc_g_n90), 
     .Q(\pwmc_g_step[1] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[2]  (.CK(n908_1), .D(pwmc_g_n91), 
     .Q(\pwmc_g_step[2] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[3]  (.CK(n908_1), .D(pwmc_g_n92), 
     .Q(\pwmc_g_step[3] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[4]  (.CK(n908_1), .D(pwmc_g_n93), 
     .Q(\pwmc_g_step[4] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[5]  (.CK(n908_1), .D(pwmc_g_n94), 
     .Q(\pwmc_g_step[5] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[6]  (.CK(n908_1), .D(pwmc_g_n95), 
     .Q(\pwmc_g_step[6] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[7]  (.CK(n908_1), .D(pwmc_g_n96), 
     .Q(\pwmc_g_step[7] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[8]  (.CK(n908_1), .D(pwmc_g_n97), 
     .Q(\pwmc_g_step[8] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[9]  (.CK(n908_1), .D(pwmc_g_n98), 
     .Q(\pwmc_g_step[9] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[10]  (.CK(n908_1), .D(pwmc_g_n99), 
     .Q(\pwmc_g_step[10] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[11]  (.CK(n908_1), .D(pwmc_g_n100), 
     .Q(\pwmc_g_step[11] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[12]  (.CK(n908_1), .D(pwmc_g_n101), 
     .Q(\pwmc_g_step[12] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[13]  (.CK(n908_1), .D(pwmc_g_n102), 
     .Q(\pwmc_g_step[13] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[14]  (.CK(n908_1), .D(pwmc_g_n103), 
     .Q(\pwmc_g_step[14] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_g/step_reg[15]  (.CK(n908_1), .D(pwmc_g_n104), 
     .Q(\pwmc_g_step[15] ), .RD(n165));
  SEH_FDPSBQ_1 \ledd_pwmcnt_reg[0]  (.CK(n904), .D(n1200), .Q(ledd_pwmcnt[0]), 
     .SD(n165));
  SEH_FDPSBQ_1 \ledd_pwmcnt_reg[1]  (.CK(n904), .D(n1210), .Q(ledd_pwmcnt[1]), .SD(n1));
  SEH_FDPSBQ_1 \ledd_pwmcnt_reg[2]  (.CK(n904), 
     .D(n1220), .Q(ledd_pwmcnt[2]), .SD(n168_2));
  SEH_FDPSBQ_1 \ledd_pwmcnt_reg[3]  (.CK(n904), .D(n1230), 
     .Q(ledd_pwmcnt[3]), .SD(n167_1));
  SEH_FDPSBQ_1 \ledd_pwmcnt_reg[4]  (.CK(n904), .D(n1240), .Q(ledd_pwmcnt[4]), 
     .SD(n168_2));
  SEH_FDPSBQ_1 \ledd_pwmcnt_reg[5]  (.CK(n904), .D(n1250), .Q(ledd_pwmcnt[5]), .SD(n166));
  SEH_FDPSBQ_2 \ledd_pwmcnt_reg[6]  (.CK(n904), 
     .D(n1260), .Q(ledd_pwmcnt[6]), .SD(n167_1));
  SEH_FDPSBQ_1 \ledd_pwmcnt_reg[7]  (.CK(n904), .D(n1270), 
     .Q(ledd_pwmcnt[7]), .SD(n168_2));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[0]  (.CK(n909_1), .D(pwmc_r_n59), 
     .Q(\pwmc_r_accum[0] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[1]  (.CK(n909_1), .D(pwmc_r_n60), 
     .Q(\pwmc_r_accum[1] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[2]  (.CK(n909_1), .D(pwmc_r_n61), 
     .Q(\pwmc_r_accum[2] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[3]  (.CK(n909_1), .D(pwmc_r_n62), 
     .Q(\pwmc_r_accum[3] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[4]  (.CK(n909_1), .D(pwmc_r_n63), 
     .Q(\pwmc_r_accum[4] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[5]  (.CK(n909_1), .D(pwmc_r_n64), 
     .Q(\pwmc_r_accum[5] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[6]  (.CK(n909_1), .D(pwmc_r_n65), 
     .Q(\pwmc_r_accum[6] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[7]  (.CK(n909_1), .D(pwmc_r_n66), 
     .Q(\pwmc_r_accum[7] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[8]  (.CK(n909_1), .D(pwmc_r_n67), 
     .Q(\pwmc_r_accum[8] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[9]  (.CK(n909_1), .D(pwmc_r_n68), 
     .Q(\pwmc_r_accum[9] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[10]  (.CK(n909_1), .D(pwmc_r_n69), 
     .Q(\pwmc_r_accum[10] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[11]  (.CK(n909_1), .D(pwmc_r_n70), 
     .Q(\pwmc_r_accum[11] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[12]  (.CK(n909_1), .D(pwmc_r_n71), 
     .Q(\pwmc_r_accum[12] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[13]  (.CK(n909_1), .D(pwmc_r_n72), 
     .Q(\pwmc_r_accum[13] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[14]  (.CK(n909_1), .D(pwmc_r_n73), 
     .Q(\pwmc_r_accum[14] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[15]  (.CK(n909_1), .D(pwmc_r_n74), 
     .Q(\pwmc_r_accum[15] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_r/accum_reg[16]  (.CK(n909_1), .D(pwmc_r_n75), 
     .Q(\pwmc_r_accum[16] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[0]  (.CK(n908_1), .D(pwmc_r_n89), 
     .Q(\pwmc_r_step[0] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[1]  (.CK(n908_1), .D(pwmc_r_n90), 
     .Q(\pwmc_r_step[1] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[2]  (.CK(n908_1), .D(pwmc_r_n91), 
     .Q(\pwmc_r_step[2] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[3]  (.CK(n908_1), .D(pwmc_r_n92), 
     .Q(\pwmc_r_step[3] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[4]  (.CK(n908_1), .D(pwmc_r_n93), 
     .Q(\pwmc_r_step[4] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[5]  (.CK(n908_1), .D(pwmc_r_n94), 
     .Q(\pwmc_r_step[5] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[6]  (.CK(n908_1), .D(pwmc_r_n95), 
     .Q(\pwmc_r_step[6] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[7]  (.CK(n908_1), .D(pwmc_r_n96), 
     .Q(\pwmc_r_step[7] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[8]  (.CK(n908_1), .D(pwmc_r_n97), 
     .Q(\pwmc_r_step[8] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[9]  (.CK(n908_1), .D(pwmc_r_n98), 
     .Q(\pwmc_r_step[9] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[10]  (.CK(n908_1), .D(pwmc_r_n99), 
     .Q(\pwmc_r_step[10] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[11]  (.CK(n908_1), .D(pwmc_r_n100), 
     .Q(\pwmc_r_step[11] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[12]  (.CK(n908_1), .D(pwmc_r_n101), 
     .Q(\pwmc_r_step[12] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[13]  (.CK(n908_1), .D(pwmc_r_n102), 
     .Q(\pwmc_r_step[13] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_r/step_reg[14]  (.CK(n908_1), .D(pwmc_r_n103), 
     .Q(\pwmc_r_step[14] ), .RD(n1));
  SEH_FDPRBQ_V2_3 \pwmc_r/step_reg[15]  (.CK(n908_1), .D(pwmc_r_n104), 
     .Q(\pwmc_r_step[15] ), .RD(n166));
  SEH_FDPRBQ_1 \ledd_pscnt_reg[0]  (.CK(n903), .D(n7110), .Q(ledd_pscnt[0]), 
     .RD(n165));
  SEH_FDPRBQ_V2_3 \ledd_pscnt_reg[1]  (.CK(n903), .D(n7210), .Q(ledd_pscnt[1]), .RD(n1));
  SEH_FDPRBQ_V2_3 \ledd_pscnt_reg[2]  (.CK(n903), 
     .D(n7310), .Q(ledd_pscnt[2]), .RD(n165));
  SEH_FDPRBQ_V2_3 \ledd_pscnt_reg[3]  (.CK(n903), .D(n7410), 
     .Q(ledd_pscnt[3]), .RD(n166));
  SEH_FDPRBQ_1 \ledd_pscnt_reg[4]  (.CK(n903), .D(n7510), .Q(ledd_pscnt[4]), 
     .RD(n168_2));
  SEH_FDPRBQ_V2_3 \ledd_pscnt_reg[5]  (.CK(n903), .D(n7610), .Q(ledd_pscnt[5]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_pscnt_reg[6]  (.CK(n903), 
     .D(n7710), .Q(ledd_pscnt[6]), .RD(n167_1));
  SEH_FDPRBQ_V2_3 \ledd_pscnt_reg[7]  (.CK(n903), .D(n7810), 
     .Q(ledd_pscnt[7]), .RD(n165));
  SEH_FDPRBQ_1 \ledd_pscnt_reg[8]  (.CK(n903), .D(n7910), .Q(ledd_pscnt[8]), 
     .RD(n1));
  SEH_FDPRBQ_1 \ledd_pscnt_reg[9]  (.CK(n903), .D(n8010), .Q(ledd_pscnt[9]), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[0]  (.CK(n909_1), 
     .D(pwmc_g_n59), .Q(\pwmc_g_accum[0] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[1]  (.CK(n909_1), 
     .D(pwmc_g_n60), .Q(\pwmc_g_accum[1] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[2]  (.CK(n909_1), 
     .D(pwmc_g_n61), .Q(\pwmc_g_accum[2] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[3]  (.CK(n909_1), .D(pwmc_g_n62), 
     .Q(\pwmc_g_accum[3] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[4]  (.CK(n909_1), .D(pwmc_g_n63), 
     .Q(\pwmc_g_accum[4] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[5]  (.CK(n909_1), .D(pwmc_g_n64), 
     .Q(\pwmc_g_accum[5] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[6]  (.CK(n909_1), .D(pwmc_g_n65), 
     .Q(\pwmc_g_accum[6] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[7]  (.CK(n909_1), .D(pwmc_g_n66), 
     .Q(\pwmc_g_accum[7] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[8]  (.CK(n909_1), .D(pwmc_g_n67), 
     .Q(\pwmc_g_accum[8] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[9]  (.CK(n909_1), .D(pwmc_g_n68), 
     .Q(\pwmc_g_accum[9] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[10]  (.CK(n909_1), .D(pwmc_g_n69), 
     .Q(\pwmc_g_accum[10] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[11]  (.CK(n909_1), .D(pwmc_g_n70), 
     .Q(\pwmc_g_accum[11] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[12]  (.CK(n909_1), .D(pwmc_g_n71), 
     .Q(\pwmc_g_accum[12] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[13]  (.CK(n909_1), .D(pwmc_g_n72), 
     .Q(\pwmc_g_accum[13] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[14]  (.CK(n909_1), .D(pwmc_g_n73), 
     .Q(\pwmc_g_accum[14] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[15]  (.CK(n909_1), .D(pwmc_g_n74), 
     .Q(\pwmc_g_accum[15] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_g/accum_reg[16]  (.CK(n909_1), .D(pwmc_g_n75), 
     .Q(\pwmc_g_accum[16] ), .RD(n165));
  SEH_FDPSBQ_1 \time_cnt_reg[0]  (.CK(n905), .D(n2520), .Q(time_cnt[0]), 
     .SD(n166));
  SEH_FDPRBQ_1 \time_cnt_reg[1]  (.CK(n905), .D(n2530), .Q(time_cnt[1]), .RD(n167_1));
  SEH_FDPRBQ_V2_3 \time_cnt_reg[2]  (.CK(n905), 
     .D(n2540), .Q(time_cnt[2]), .RD(n165));
  SEH_FDPRBQ_1 \time_cnt_reg[3]  (.CK(n905), .D(n2550), .Q(time_cnt[3]), 
     .RD(n166));
  SEH_FDPRBQ_V2_3 \time_cnt_reg[4]  (.CK(n905), .D(n2560), .Q(time_cnt[4]), .RD(n167_1));
  SEH_FDPRBQ_1 \time_cnt_reg[5]  (.CK(n905), 
     .D(n2570), .Q(time_cnt[5]), .RD(n168_2));
  SEH_FDPRBQ_V2_3 \time_cnt_reg[6]  (.CK(n905), .D(n2580), 
     .Q(time_cnt[6]), .RD(n166));
  SEH_FDPRBQ_1 \time_cnt_reg[7]  (.CK(n905), .D(n2590), .Q(time_cnt[7]), .RD(n1));
  SEH_FDPRBQ_1 \time_cnt_reg[8]  (
     .CK(n905), .D(n2600), .Q(time_cnt[8]), .RD(n168_2));
  SEH_FDPRBQ_1 \time_cnt_reg[9]  (.CK(n905), .D(n2610), 
     .Q(time_cnt[9]), .RD(n166));
  SEH_FDPRBQ_1 \time_cnt_reg[10]  (.CK(n905), .D(n2620), .Q(time_cnt[10]), 
     .RD(n167_1));
  SEH_FDPRBQ_1 \time_cnt_reg[11]  (.CK(n905), .D(n2630), .Q(time_cnt[11]), .RD(n167_1));
  SEH_FDPRBQ_1 \time_cnt_reg[12]  (.CK(n905), 
     .D(n2640), .Q(time_cnt[12]), .RD(n1));
  SEH_FDPRBQ_1 \time_cnt_reg[13]  (.CK(n905), .D(n2650), .Q(time_cnt[13]), 
     .RD(n165));
  SEH_FDPRBQ_1 \time_cnt_reg[14]  (.CK(n905), .D(n2660), .Q(time_cnt[14]), .RD(n166));
  SEH_FDPRBQ_1 \time_cnt_reg[15]  (.CK(n905), 
     .D(n2670), .Q(time_cnt[15]), .RD(n1));
  SEH_FDPRBQ_1 \time_cnt_reg[16]  (.CK(n905), .D(n2680), .Q(time_cnt[16]), 
     .RD(n165));
  SEH_FDPRBQ_1 \time_cnt_reg[17]  (.CK(n905), .D(n2690), .Q(time_cnt[17]), .RD(n168_2));
  SEH_FDPRBQ_1 \time_cnt_reg[18]  (.CK(n905), 
     .D(n2700), .Q(time_cnt[18]), .RD(n168_2));
  SEH_FDPRBQ_1 \time_cnt_reg[19]  (.CK(n905), .D(n2710), 
     .Q(time_cnt[19]), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[0]  (.CK(n908_1), .D(pwmc_b_n89), 
     .Q(\pwmc_b_step[0] ), .RD(n165));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[1]  (.CK(n908_1), .D(pwmc_b_n90), 
     .Q(\pwmc_b_step[1] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[2]  (.CK(n908_1), .D(pwmc_b_n91), 
     .Q(\pwmc_b_step[2] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[3]  (.CK(n908_1), .D(pwmc_b_n92), 
     .Q(\pwmc_b_step[3] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[4]  (.CK(n908_1), .D(pwmc_b_n93), 
     .Q(\pwmc_b_step[4] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[5]  (.CK(n908_1), .D(pwmc_b_n94), 
     .Q(\pwmc_b_step[5] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[6]  (.CK(n908_1), .D(pwmc_b_n95), 
     .Q(\pwmc_b_step[6] ), .RD(n167_1));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[7]  (.CK(n908_1), .D(pwmc_b_n96), 
     .Q(\pwmc_b_step[7] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[8]  (.CK(n908_1), .D(pwmc_b_n97), 
     .Q(\pwmc_b_step[8] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[9]  (.CK(n908_1), .D(pwmc_b_n98), 
     .Q(\pwmc_b_step[9] ), .RD(n1));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[10]  (.CK(n908_1), .D(pwmc_b_n99), 
     .Q(\pwmc_b_step[10] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[11]  (.CK(n908_1), .D(pwmc_b_n100), 
     .Q(\pwmc_b_step[11] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[12]  (.CK(n908_1), .D(pwmc_b_n101), 
     .Q(\pwmc_b_step[12] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[13]  (.CK(n908_1), .D(pwmc_b_n102), 
     .Q(\pwmc_b_step[13] ), .RD(n168_2));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[14]  (.CK(n908_1), .D(pwmc_b_n103), 
     .Q(\pwmc_b_step[14] ), .RD(n166));
  SEH_FDPRBQ_1 \pwmc_b/step_reg[15]  (.CK(n908_1), .D(pwmc_b_n104), 
     .Q(\pwmc_b_step[15] ), .RD(n168_2));
  SEH_FDPRBQ_V2_3 \skew_delay_g_reg[0]  (.CK(n907), .D(ledd_pwm_out_g), 
     .Q(skew_delay_g[0]), .RD(n1));
  SEH_FDPRBQ_V2_3 \skew_delay_g_reg[1]  (.CK(n907), .D(skew_delay_g[0]), 
     .Q(skew_delay_g[1]), .RD(n1));
  SEH_FDPRBQ_V2_3 \skew_delay_g_reg[2]  (.CK(n907), .D(skew_delay_g[1]), 
     .Q(skew_delay_g[2]), .RD(n167_1));
  SEH_FDPRBQ_1 \skew_delay_g_reg[3]  (.CK(n907), .D(skew_delay_g[2]), 
     .Q(skew_delay_g[3]), .RD(n166));
  SEH_FDPRBQ_V2_3 \skew_delay_g_reg[4]  (.CK(n907), .D(skew_delay_g[3]), 
     .Q(skew_delay_g[4]), .RD(n166));
  SEH_FDPRBQ_V2_3 \skew_delay_g_reg[5]  (.CK(n907), .D(skew_delay_g[4]), 
     .Q(skew_delay_g[5]), .RD(n165));
  SEH_FDPRBQ_V2_3 \skew_delay_g_reg[6]  (.CK(n907), .D(skew_delay_g[5]), 
     .Q(skew_delay_g[6]), .RD(n165));
  SEH_FDPRBQ_V2_3 \skew_delay_g_reg[7]  (.CK(n907), .D(skew_delay_g[6]), 
     .Q(skew_delay_g[7]), .RD(n167_1));
  SEH_FDPRBQ_V2_3 \skew_delay_b_reg[0]  (.CK(n907), .D(ledd_pwm_out_b), 
     .Q(skew_delay_b[0]), .RD(n165));
  SEH_FDPRBQ_1 \skew_delay_b_reg[1]  (.CK(n907), .D(skew_delay_b[0]), 
     .Q(skew_delay_b[1]), .RD(n165));
  SEH_FDPRBQ_V2_3 \skew_delay_b_reg[2]  (.CK(n907), .D(skew_delay_b[1]), 
     .Q(skew_delay_b[2]), .RD(n165));
  SEH_FDPRBQ_1 \skew_delay_b_reg[3]  (.CK(n907), .D(skew_delay_b[2]), 
     .Q(skew_delay_b[3]), .RD(n165));
  SEH_FDPRBQ_V2_3 \skew_delay_b_reg[4]  (.CK(n907), .D(skew_delay_b[3]), 
     .Q(skew_delay_b[4]), .RD(n165));
  SEH_FDPRBQ_V2_3 \skew_delay_b_reg[5]  (.CK(n907), .D(skew_delay_b[4]), 
     .Q(skew_delay_b[5]), .RD(n165));
  SEH_FDPRBQ_V2_3 \skew_delay_b_reg[6]  (.CK(n907), .D(skew_delay_b[5]), 
     .Q(skew_delay_b[6]), .RD(n165));
  SEH_FDPRBQ_1 \skew_delay_b_reg[7]  (.CK(n907), .D(skew_delay_b[6]), 
     .Q(skew_delay_b[7]), .RD(n1));
  SEH_FDPRBQ_V2_3 \skew_delay_b_reg[8]  (.CK(n907), .D(skew_delay_b[7]), 
     .Q(skew_delay_b[8]), .RD(n1));
  SEH_FDPRBQ_V2_3 \skew_delay_b_reg[9]  (.CK(n907), .D(skew_delay_b[8]), 
     .Q(skew_delay_b[9]), .RD(n166));
  SEH_FDPRBQ_1 \skew_delay_b_reg[10]  (.CK(n907), .D(skew_delay_b[9]), 
     .Q(skew_delay_b[10]), .RD(n167_1));
  SEH_FDPRBQ_1 \skew_delay_b_reg[11]  (.CK(n907), .D(skew_delay_b[10]), 
     .Q(skew_delay_b[11]), .RD(n166));
  SEH_FDPRBQ_1 \skew_delay_b_reg[12]  (.CK(n907), .D(skew_delay_b[11]), 
     .Q(skew_delay_b[12]), .RD(n168_2));
  SEH_FDPRBQ_1 \skew_delay_b_reg[13]  (.CK(n907), .D(skew_delay_b[12]), 
     .Q(skew_delay_b[13]), .RD(n165));
  SEH_FDPRBQ_1 \skew_delay_b_reg[14]  (.CK(n907), .D(skew_delay_b[13]), 
     .Q(skew_delay_b[14]), .RD(n167_1));
  SEH_FDPRBQ_1 \skew_delay_b_reg[15]  (.CK(n907), .D(skew_delay_b[14]), 
     .Q(skew_delay_b[15]), .RD(n168_2));
  SEH_FDPRBQ_1 \ledd_exe_sense_reg[0]  (.CK(ledd_clk_1), .D(ledd_exe_sense[1]), 
     .Q(ledd_exe_sense[0]), .RD(n1));
  SEH_FDPRBQ_1 \ledd_exe_sense_reg[1]  (.CK(ledd_clk_1), .D(ledd_exe_sense[2]), 
     .Q(ledd_exe_sense[1]), .RD(n168_2));
  SEH_FDPRBQ_1 \ledd_exe_sense_reg[2]  (.CK(ledd_clk_1), .D(n4510), 
     .Q(ledd_exe_sense[2]), .RD(n1));
  SEH_FDPRBQ_V2_3 \t_mult_reg[0]  (.CK(n906), .D(net953), .Q(t_mult[0]), 
     .RD(n167_1));
  SEH_FDPRBQ_V2_3 \t_mult_reg[1]  (.CK(n906), .D(net950), .Q(t_mult[1]), .RD(n167_1));
  SEH_FDPRBQ_V2_3 \t_mult_reg[2]  (.CK(n906), 
     .D(net947), .Q(t_mult[2]), .RD(n1));
  SEH_FDPRBQ_1 \t_mult_reg[3]  (.CK(n906), .D(net944), .Q(t_mult[3]), 
     .RD(n165));
  SEH_FDPRBQ_V2_3 \t_mult_reg[4]  (.CK(n906), .D(net941), .Q(t_mult[4]), .RD(n1));
  SEH_FDPRBQ_V2_3 \t_mult_reg[5]  (.CK(n906), 
     .D(net938), .Q(t_mult[5]), .RD(n168_2));
  SEH_FDPRBQ_V2_3 \t_mult_reg[6]  (.CK(n906), .D(net935), .Q(t_mult[6]), 
     .RD(n1));
  SEH_FDPRBQ_V2_3 \t_mult_reg[7]  (.CK(n906), .D(net932), .Q(t_mult[7]), .RD(n167_1));
  SEH_FDPRBQ_V2_3 \t_mult_reg[8]  (.CK(n906), 
     .D(net929), .Q(t_mult[8]), .RD(n167_1));
  SEH_FDPRBQ_1 \state_reg[0]  (.CK(ledd_clk_1), .D(next_state[0]), 
     .Q(state[0]), .RD(n1));
  SEH_FDPRBQ_1 \state_reg[1]  (.CK(ledd_clk_1), .D(next_state[1]), .Q(state[1]), 
     .RD(n168_2));
  SEH_FDPRBQ_1 \state_reg[2]  (.CK(ledd_clk_1), .D(next_state[2]), .Q(state[2]), .RD(n165));
  SEH_FDPRBQ_1 \state_reg[3]  (
     .CK(n903), .D(next_state[3]), .Q(state[3]), .RD(n1));
  SEH_FDPRBQ_1 \mult_cnt_reg[0]  (.CK(n903), .D(n3380), 
     .Q(mult_cnt[0]), .RD(n1));
  SEH_FDPRBQ_1 \mult_cnt_reg[1]  (.CK(n903), .D(n3390), .Q(mult_cnt[1]), .RD(n166));
  SEH_FDPRBQ_1 \mult_cnt_reg[2]  (
     .CK(n908_1), .D(n3400), .Q(mult_cnt[2]), .RD(n1));
  SEH_FDPRBQ_1 \mult_cnt_reg[3]  (.CK(n908_1), .D(n3410), 
     .Q(mult_cnt[3]), .RD(n168_2));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_ctrl_5 Model:SNPS_CLOCK_GATE_HIGH_ledd_ctrl_5 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_ctrl_5 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_8 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_ctrl_6 Model:SNPS_CLOCK_GATE_HIGH_ledd_ctrl_6 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_ctrl_6 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_2 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_ctrl_7 Model:SNPS_CLOCK_GATE_HIGH_ledd_ctrl_7 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_ctrl_7 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_8 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_ctrl_8 Model:SNPS_CLOCK_GATE_HIGH_ledd_ctrl_8 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_ctrl_8 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_4 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_ctrl_9 Model:SNPS_CLOCK_GATE_HIGH_ledd_ctrl_9 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_ctrl_9 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_8 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_pwmc_6 Model:SNPS_CLOCK_GATE_HIGH_ledd_pwmc_6 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_pwmc_6 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_2 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule

// Entity:SNPS_CLOCK_GATE_HIGH_ledd_pwmc_7 Model:SNPS_CLOCK_GATE_HIGH_ledd_pwmc_7 Library:magma_checknetlist_lib
module SNPS_CLOCK_GATE_HIGH_ledd_pwmc_7 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;
  SEH_CKGTPLT_V5_1 latch (.CK(CLK), .EN(EN), .Q(ENCLK), .SE(TE));
endmodule
