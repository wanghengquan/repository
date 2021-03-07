
module spi_sci_int_reg_0 ( status, spi_rst_async, sb_clk_i, int_force, int_set, 
        int_clr, scan_test_mode );
  input spi_rst_async, sb_clk_i, int_force, int_set, int_clr, scan_test_mode;
  output status;
  wire   int_clk, N2, int_sts, int_rsta, N5, n1, n20, n3;

  SEH_FDPRBQ_V2_1P5 status_reg ( .D(int_sts), .CK(int_clk), .RD(n20), .Q(
        status) );
  SEH_EO2_G_1 U3 ( .A1(int_set), .A2(int_force), .X(N2) );
  SEH_MUX2_DG_1 U4 ( .D0(N2), .D1(sb_clk_i), .S(scan_test_mode), .X(int_clk)
         );
  SEH_INV_S_1 U5 ( .A(int_rsta), .X(n20) );
  SEH_MUX2_G_1 U6 ( .D0(N5), .D1(spi_rst_async), .S(scan_test_mode), .X(
        int_rsta) );
  SEH_OR2_1 U7 ( .A1(int_clr), .A2(spi_rst_async), .X(N5) );
  SEH_AOAI211_G_1 U8 ( .A1(n1), .A2(n3), .B(int_clr), .C(scan_test_mode), .X(
        int_sts) );
  SEH_INV_S_1 U9 ( .A(int_set), .X(n1) );
  SEH_INV_S_1 U10 ( .A(int_force), .X(n3) );
endmodule


module spi_sci_int_reg_4 ( status, spi_rst_async, sb_clk_i, int_force, int_set, 
        int_clr, scan_test_mode );
  input spi_rst_async, sb_clk_i, int_force, int_set, int_clr, scan_test_mode;
  output status;
  wire   int_clk, N2, int_sts, int_rsta, N5, n1, n20, n3;

  SEH_FDPRBQ_V2_1P5 status_reg ( .D(int_sts), .CK(int_clk), .RD(n20), .Q(
        status) );
  SEH_EO2_G_1 U3 ( .A1(int_set), .A2(int_force), .X(N2) );
  SEH_MUX2_DG_1 U4 ( .D0(N2), .D1(sb_clk_i), .S(scan_test_mode), .X(int_clk)
         );
  SEH_INV_S_1 U5 ( .A(int_rsta), .X(n20) );
  SEH_MUX2_G_1 U6 ( .D0(N5), .D1(spi_rst_async), .S(scan_test_mode), .X(
        int_rsta) );
  SEH_OR2_1 U7 ( .A1(int_clr), .A2(spi_rst_async), .X(N5) );
  SEH_AOAI211_G_1 U8 ( .A1(n1), .A2(n3), .B(int_clr), .C(scan_test_mode), .X(
        int_sts) );
  SEH_INV_S_1 U9 ( .A(int_set), .X(n1) );
  SEH_INV_S_1 U10 ( .A(int_force), .X(n3) );
endmodule


module spi_sci_int_reg_3 ( status, spi_rst_async, sb_clk_i, int_force, int_set, 
        int_clr, scan_test_mode );
  input spi_rst_async, sb_clk_i, int_force, int_set, int_clr, scan_test_mode;
  output status;
  wire   int_clk, N2, int_sts, int_rsta, N5, n1, n20, n3;

  SEH_FDPRBQ_V2_1P5 status_reg ( .D(int_sts), .CK(int_clk), .RD(n20), .Q(
        status) );
  SEH_EO2_G_1 U3 ( .A1(int_set), .A2(int_force), .X(N2) );
  SEH_MUX2_DG_1 U4 ( .D0(N2), .D1(sb_clk_i), .S(scan_test_mode), .X(int_clk)
         );
  SEH_INV_S_1 U5 ( .A(int_rsta), .X(n20) );
  SEH_MUX2_G_1 U6 ( .D0(N5), .D1(spi_rst_async), .S(scan_test_mode), .X(
        int_rsta) );
  SEH_OR2_1 U7 ( .A1(int_clr), .A2(spi_rst_async), .X(N5) );
  SEH_AOAI211_G_1 U8 ( .A1(n1), .A2(n3), .B(int_clr), .C(scan_test_mode), .X(
        int_sts) );
  SEH_INV_S_1 U9 ( .A(int_set), .X(n1) );
  SEH_INV_S_1 U10 ( .A(int_force), .X(n3) );
endmodule


module spi_sci_int_reg_2 ( status, spi_rst_async, sb_clk_i, int_force, int_set, 
        int_clr, scan_test_mode );
  input spi_rst_async, sb_clk_i, int_force, int_set, int_clr, scan_test_mode;
  output status;
  wire   int_clk, N2, int_sts, int_rsta, N5, n1, n20, n3;

  SEH_FDPRBQ_V2_1P5 status_reg ( .D(int_sts), .CK(int_clk), .RD(n20), .Q(
        status) );
  SEH_EO2_G_1 U3 ( .A1(int_set), .A2(int_force), .X(N2) );
  SEH_MUX2_DG_1 U4 ( .D0(N2), .D1(sb_clk_i), .S(scan_test_mode), .X(int_clk)
         );
  SEH_INV_S_1 U5 ( .A(int_rsta), .X(n20) );
  SEH_MUX2_G_1 U6 ( .D0(N5), .D1(spi_rst_async), .S(scan_test_mode), .X(
        int_rsta) );
  SEH_OR2_1 U7 ( .A1(int_clr), .A2(spi_rst_async), .X(N5) );
  SEH_AOAI211_G_1 U8 ( .A1(n1), .A2(n3), .B(int_clr), .C(scan_test_mode), .X(
        int_sts) );
  SEH_INV_S_1 U9 ( .A(int_set), .X(n1) );
  SEH_INV_S_1 U10 ( .A(int_force), .X(n3) );
endmodule


module spi_sci_int_reg_1 ( status, spi_rst_async, sb_clk_i, int_force, int_set, 
        int_clr, scan_test_mode );
  input spi_rst_async, sb_clk_i, int_force, int_set, int_clr, scan_test_mode;
  output status;
  wire   int_clk, N2, int_sts, int_rsta, N5, n1, n20, n3;

  SEH_FDPRBQ_V2_1P5 status_reg ( .D(int_sts), .CK(int_clk), .RD(n20), .Q(
        status) );
  SEH_EO2_G_1 U3 ( .A1(int_set), .A2(int_force), .X(N2) );
  SEH_MUX2_DG_1 U4 ( .D0(N2), .D1(sb_clk_i), .S(scan_test_mode), .X(int_clk)
         );
  SEH_INV_S_1 U5 ( .A(int_rsta), .X(n20) );
  SEH_MUX2_G_1 U6 ( .D0(N5), .D1(spi_rst_async), .S(scan_test_mode), .X(
        int_rsta) );
  SEH_OR2_1 U7 ( .A1(int_clr), .A2(spi_rst_async), .X(N5) );
  SEH_AOAI211_G_1 U8 ( .A1(n1), .A2(n3), .B(int_clr), .C(scan_test_mode), .X(
        int_sts) );
  SEH_INV_S_1 U9 ( .A(int_set), .X(n1) );
  SEH_INV_S_1 U10 ( .A(int_force), .X(n3) );
endmodule


module spi_sci ( spicr0, spicr1, spicr2, spibr, spicsr, spitxdr, spicr0_wt, 
        spicr1_wt, spicr2_wt, spibr_wt, spicsr_wt, spitxdr_wt, spirxdr_rd, 
        sb_dat_o, sb_ack_o, spi_irq, SB_ID, spi_rst_async, sb_clk_i, sb_we_i, 
        sb_stb_i, sb_adr_i, sb_dat_i, spisr, spirxdr, scan_test_mode );
  output [7:0] spicr0;
  output [7:0] spicr1;
  output [7:0] spicr2;
  output [7:0] spibr;
  output [7:0] spicsr;
  output [7:0] spitxdr;
  output [7:0] sb_dat_o;
  input [3:0] SB_ID;
  input [7:0] sb_adr_i;
  input [7:0] sb_dat_i;
  input [7:0] spisr;
  input [7:0] spirxdr;
  input spi_rst_async, sb_clk_i, sb_we_i, sb_stb_i, scan_test_mode;
  output spicr0_wt, spicr1_wt, spicr2_wt, spibr_wt, spicsr_wt, spitxdr_wt,
         spirxdr_rd, sb_ack_o, spi_irq;
  wire   n197, n198, n199, n200, n201, n202, n203, n204, n205, ip_stb,
         id_stb_dly, id_stb_pulse, N14, ack_reg, spiintcr7, spiintcr6,
         spiintcr5, spiintcr4, spiintcr3, spiintcr2, spiintcr1, spiintcr0, N47,
         N48, N49, N50, N51, N52, N53, N54, int_clr_mdf, int_mdf, int_clr_roe,
         int_roe, int_clr_toe, int_toe, int_clr_rrdy, int_rrdy, int_clr_trdy,
         int_trdy, n5, n6, n7, n8, n9, n10, n11, n12, n18, n29, n30, n32, n34,
         n36, n39, n490, n58, n60, n61, n62, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n105, n107, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n124, n125,
         n126, n127, n128, n129, n130, n131, n132, n133, n134, n135, n136,
         n137, n138, n139, n140, n141, n142, n143, n144, n145, n146, n147,
         n148, n149, n150, n151, n152, n153, n154, n155, n156, n157, n158,
         n159, n160, n161, n162, n163, n164, n165, n166, n167, n168, n169,
         n170, n171, n1, n2, n3, n4, n13, n1410, n15, n16, n19, n21, n23, n25,
         n27, n31, n35, n40, n41, n42, n43, n44, n45, n46, n470, n480, n500,
         n510, n520, n530, n540, n55, n56, n57, n59, n63, n102, n103, n104,
         n106, n172, n174, n175, n176, n177, n178, n179, n180, n181, n182,
         n183, n184, n185, n186, n187, n188, n189, n190, n191, n192, n193,
         n194, n195, n196, n206, n207;

  SEH_NR4_8 U176 ( .A1(n187), .A2(n186), .A3(sb_adr_i[0]), .A4(sb_adr_i[3]), 
        .X(n62) );
  SEH_FDPRBQ_V2_1P5 id_stb_dly_reg ( .D(n3), .CK(sb_clk_i), .RD(n43), .Q(
        id_stb_dly) );
  SEH_FDPRBQ_V2_1P5 ack_reg_reg ( .D(ip_stb), .CK(sb_clk_i), .RD(n40), .Q(
        ack_reg) );
  SEH_INV_S_1 U3 ( .A(sb_adr_i[0]), .X(n188) );
  SEH_INV_S_1 U4 ( .A(sb_adr_i[3]), .X(n184) );
  SEH_AO222_1 U5 ( .A1(spiintcr3), .A2(int_rrdy), .B1(spiintcr0), .B2(int_mdf), 
        .C1(spiintcr1), .C2(int_roe), .X(n1) );
  SEH_OR3B_2 U6 ( .B1(sb_adr_i[0]), .B2(sb_adr_i[1]), .A(n107), .X(n11) );
  SEH_OR3_1 U7 ( .A1(n178), .A2(n11), .A3(n58), .X(n2) );
  SEH_INV_S_2 U8 ( .A(n2), .X(n490) );
  SEH_AO21B_1 U9 ( .A1(n62), .A2(int_trdy), .B(n78), .X(n83) );
  SEH_AO21B_1 U10 ( .A1(n62), .A2(int_toe), .B(n78), .X(n93) );
  SEH_AN4_1 U11 ( .A1(n111), .A2(n112), .A3(n113), .A4(n114), .X(n3) );
  SEH_INV_S_1 U12 ( .A(n3), .X(n58) );
  SEH_AO221_0P5 U13 ( .A1(spiintcr2), .A2(int_toe), .B1(spiintcr4), .B2(
        int_trdy), .C(n1), .X(n205) );
  SEH_MUXI2_DG_0P5 U14 ( .D0(n190), .D1(n13), .S(n18), .X(n122) );
  SEH_OAO211_DG_1 U15 ( .A1(n187), .A2(n186), .B(n184), .C(n58), .X(n4) );
  SEH_INV_S_1 U16 ( .A(n4), .X(ip_stb) );
  SEH_NR2_G_1 U17 ( .A1(n5), .A2(n11), .X(spicr0_wt) );
  SEH_INV_S_1 U18 ( .A(sb_we_i), .X(n178) );
  SEH_NR2_G_1 U19 ( .A1(n5), .A2(n10), .X(spicr1_wt) );
  SEH_NR2_S_1 U20 ( .A1(n5), .A2(n12), .X(spibr_wt) );
  SEH_INV_S_2 U21 ( .A(sb_adr_i[1]), .X(n187) );
  SEH_NR2_T_1 U22 ( .A1(n187), .A2(n188), .X(n108) );
  SEH_NR2_S_3 U23 ( .A1(n184), .A2(sb_adr_i[2]), .X(n107) );
  SEH_ND4_S_3 U24 ( .A1(n62), .A2(spiintcr7), .A3(id_stb_pulse), .A4(n178), 
        .X(n61) );
  SEH_ND3_T_1P5 U26 ( .A1(sb_adr_i[2]), .A2(n184), .A3(n108), .X(n78) );
  SEH_ND3_T_4 U27 ( .A1(sb_adr_i[0]), .A2(n187), .A3(n107), .X(n10) );
  SEH_NR2B_V1DG_3 U28 ( .A(n29), .B(n10), .X(n39) );
  SEH_BUF_D_3 U29 ( .A(n45), .X(n40) );
  SEH_AN2_DG_12 U30 ( .A1(ack_reg), .A2(sb_stb_i), .X(sb_ack_o) );
  SEH_INV_S_1 U31 ( .A(spiintcr6), .X(n13) );
  SEH_INV_S_0P5 U32 ( .A(n13), .X(n1410) );
  SEH_INV_S_0P65 U33 ( .A(n13), .X(n15) );
  SEH_INV_2 U34 ( .A(n197), .X(n16) );
  SEH_INV_10 U35 ( .A(n16), .X(sb_dat_o[7]) );
  SEH_INV_2 U36 ( .A(n200), .X(n19) );
  SEH_INV_10 U37 ( .A(n19), .X(sb_dat_o[4]) );
  SEH_INV_2 U38 ( .A(n204), .X(n21) );
  SEH_INV_10 U39 ( .A(n21), .X(sb_dat_o[0]) );
  SEH_INV_2 U40 ( .A(n202), .X(n23) );
  SEH_INV_10 U41 ( .A(n23), .X(sb_dat_o[2]) );
  SEH_INV_2 U42 ( .A(n203), .X(n25) );
  SEH_INV_10 U43 ( .A(n25), .X(sb_dat_o[1]) );
  SEH_INV_2 U44 ( .A(n201), .X(n27) );
  SEH_INV_10 U45 ( .A(n27), .X(sb_dat_o[3]) );
  SEH_INV_2 U46 ( .A(n198), .X(n31) );
  SEH_INV_10 U47 ( .A(n31), .X(sb_dat_o[6]) );
  SEH_INV_2 U48 ( .A(n199), .X(n35) );
  SEH_INV_10 U49 ( .A(n35), .X(sb_dat_o[5]) );
  SEH_OAI22_S_1 U50 ( .A1(n192), .A2(n175), .B1(n39), .B2(n59), .X(n160) );
  SEH_INV_S_1P25 U51 ( .A(n39), .X(n175) );
  SEH_OAI22_0P75 U52 ( .A1(n189), .A2(n175), .B1(n39), .B2(n55), .X(n163) );
  SEH_OAI22_S_1 U53 ( .A1(n190), .A2(n175), .B1(n39), .B2(n56), .X(n162) );
  SEH_OAI22_S_1 U54 ( .A1(n193), .A2(n175), .B1(n39), .B2(n63), .X(n159) );
  SEH_OAI22_S_1 U55 ( .A1(n194), .A2(n175), .B1(n39), .B2(n102), .X(n158) );
  SEH_OAI22_S_1 U56 ( .A1(n191), .A2(n175), .B1(n39), .B2(n57), .X(n161) );
  SEH_OAI22_S_1 U57 ( .A1(n195), .A2(n175), .B1(n39), .B2(n103), .X(n157) );
  SEH_OAI22_S_1 U58 ( .A1(n196), .A2(n175), .B1(n39), .B2(n104), .X(n156) );
  SEH_BUF_D_12 U59 ( .A(n205), .X(spi_irq) );
  SEH_ND2_T_2 U60 ( .A1(n181), .A2(n29), .X(n18) );
  SEH_INV_S_1P5 U61 ( .A(n6), .X(n182) );
  SEH_ND2_G_1 U62 ( .A1(n108), .A2(n110), .X(n8) );
  SEH_INV_S_2 U63 ( .A(n12), .X(n180) );
  SEH_BUF_1 U64 ( .A(n177), .X(n43) );
  SEH_BUF_1 U65 ( .A(n177), .X(n44) );
  SEH_NR2_G_1 U67 ( .A1(n5), .A2(n8), .X(spicsr_wt) );
  SEH_ND2_1 U68 ( .A1(n107), .A2(n108), .X(n12) );
  SEH_INV_S_2 U70 ( .A(n9), .X(n179) );
  SEH_NR2_T_1 U71 ( .A1(n5), .A2(n6), .X(spitxdr_wt) );
  SEH_INV_S_1 U72 ( .A(n78), .X(n181) );
  SEH_OR2_1 U73 ( .A1(n5), .A2(n185), .X(n60) );
  SEH_ND3_T_1P5 U74 ( .A1(sb_adr_i[1]), .A2(n188), .A3(n107), .X(n9) );
  SEH_ND3_T_0P8 U76 ( .A1(n110), .A2(n187), .A3(sb_adr_i[0]), .X(n6) );
  SEH_ND2_2 U77 ( .A1(sb_we_i), .A2(id_stb_pulse), .X(n5) );
  SEH_INV_S_2 U78 ( .A(sb_dat_i[5]), .X(n191) );
  SEH_INV_S_2 U79 ( .A(sb_dat_i[6]), .X(n190) );
  SEH_INV_S_2 U80 ( .A(sb_dat_i[7]), .X(n189) );
  SEH_INV_S_2 U81 ( .A(sb_dat_i[0]), .X(n196) );
  SEH_INV_S_2 U82 ( .A(sb_dat_i[1]), .X(n195) );
  SEH_INV_S_2 U83 ( .A(sb_dat_i[3]), .X(n193) );
  SEH_INV_S_2 U84 ( .A(sb_dat_i[2]), .X(n194) );
  SEH_INV_S_2 U85 ( .A(sb_dat_i[4]), .X(n192) );
  SEH_INV_S_1 U86 ( .A(spicr1[4]), .X(n59) );
  SEH_INV_S_1 U87 ( .A(spicr1[2]), .X(n102) );
  SEH_INV_S_1 U88 ( .A(spicr1[1]), .X(n103) );
  SEH_INV_S_1 U89 ( .A(spicr1[0]), .X(n104) );
  SEH_INV_S_1 U90 ( .A(spicr0[2]), .X(n520) );
  SEH_INV_S_1 U91 ( .A(spicr0[1]), .X(n530) );
  SEH_INV_S_1 U92 ( .A(spicr0[0]), .X(n540) );
  SEH_INV_S_1 U93 ( .A(spicr1[6]), .X(n56) );
  SEH_INV_S_1 U94 ( .A(spicr1[3]), .X(n63) );
  SEH_INV_S_1 U95 ( .A(spicr0[5]), .X(n480) );
  SEH_INV_S_1 U96 ( .A(spicr0[4]), .X(n500) );
  SEH_INV_S_1 U97 ( .A(spicr0[6]), .X(n470) );
  SEH_INV_S_1 U98 ( .A(spicr0[3]), .X(n510) );
  SEH_INV_S_1 U99 ( .A(spicr0[7]), .X(n46) );
  SEH_INV_S_1 U100 ( .A(spicr1[5]), .X(n57) );
  SEH_INV_S_2 U101 ( .A(n490), .X(n174) );
  SEH_INV_S_2 U102 ( .A(n8), .X(n183) );
  SEH_INV_S_1 U103 ( .A(n18), .X(n176) );
  SEH_BUF_D_3 U104 ( .A(n44), .X(n41) );
  SEH_BUF_D_3 U105 ( .A(n43), .X(n42) );
  SEH_ND2_3 U106 ( .A1(n29), .A2(n182), .X(n30) );
  SEH_ND2_T_2 U107 ( .A1(n29), .A2(n183), .X(n32) );
  SEH_ND2_3 U108 ( .A1(n29), .A2(n180), .X(n34) );
  SEH_ND2_3 U109 ( .A1(n29), .A2(n179), .X(n36) );
  SEH_BUF_1 U110 ( .A(n177), .X(n45) );
  SEH_ND2_2 U111 ( .A1(ip_stb), .A2(n178), .X(n67) );
  SEH_OAI22_S_1 U113 ( .A1(n10), .A2(n104), .B1(n11), .B2(n540), .X(n105) );
  SEH_OAI22_S_1 U114 ( .A1(n10), .A2(n103), .B1(n11), .B2(n530), .X(n97) );
  SEH_OAI22_S_1 U115 ( .A1(n10), .A2(n102), .B1(n11), .B2(n520), .X(n92) );
  SEH_OAI22_S_1 U116 ( .A1(n10), .A2(n63), .B1(n11), .B2(n510), .X(n87) );
  SEH_OAI22_S_1 U117 ( .A1(n10), .A2(n59), .B1(n11), .B2(n500), .X(n82) );
  SEH_OAI22_S_1 U118 ( .A1(n10), .A2(n57), .B1(n11), .B2(n480), .X(n77) );
  SEH_OAI22_S_1 U119 ( .A1(n10), .A2(n56), .B1(n11), .B2(n470), .X(n73) );
  SEH_OAI22_S_1 U120 ( .A1(n10), .A2(n55), .B1(n11), .B2(n46), .X(n68) );
  SEH_INV_S_1 U121 ( .A(n62), .X(n185) );
  SEH_OAI22_S_1 U122 ( .A1(n18), .A2(n194), .B1(n176), .B2(n172), .X(n118) );
  SEH_OAI22_S_1 U123 ( .A1(n18), .A2(n192), .B1(n176), .B2(n106), .X(n120) );
  SEH_OAI22_S_1 U124 ( .A1(n194), .A2(n174), .B1(n490), .B2(n520), .X(n166) );
  SEH_OAI22_S_1 U125 ( .A1(n192), .A2(n174), .B1(n490), .B2(n500), .X(n168) );
  SEH_OAI22_S_1 U126 ( .A1(n196), .A2(n174), .B1(n490), .B2(n540), .X(n164) );
  SEH_OAI22_S_1 U127 ( .A1(n195), .A2(n174), .B1(n490), .B2(n530), .X(n165) );
  SEH_OAI22_S_1 U128 ( .A1(n193), .A2(n174), .B1(n490), .B2(n510), .X(n167) );
  SEH_OAI22_S_1 U129 ( .A1(n191), .A2(n174), .B1(n490), .B2(n480), .X(n169) );
  SEH_OAI22_S_1 U130 ( .A1(n190), .A2(n174), .B1(n490), .B2(n470), .X(n170) );
  SEH_OAI22_S_1 U131 ( .A1(n189), .A2(n174), .B1(n490), .B2(n46), .X(n171) );
  SEH_OAI21_G_1 U133 ( .A1(n195), .A2(n60), .B(n61), .X(int_clr_roe) );
  SEH_OAI21_G_1 U134 ( .A1(n194), .A2(n60), .B(n61), .X(int_clr_toe) );
  SEH_OAI21_G_1 U135 ( .A1(n193), .A2(n60), .B(n61), .X(int_clr_rrdy) );
  SEH_OAI21_G_1 U136 ( .A1(n192), .A2(n60), .B(n61), .X(int_clr_trdy) );
  SEH_OAI21_1 U137 ( .A1(n196), .A2(n60), .B(n61), .X(int_clr_mdf) );
  SEH_INV_S_1 U138 ( .A(spi_rst_async), .X(n177) );
  SEH_EN2_G_1 U139 ( .A1(sb_adr_i[6]), .A2(SB_ID[2]), .X(n111) );
  SEH_EN2_G_1 U140 ( .A1(sb_adr_i[5]), .A2(SB_ID[1]), .X(n112) );
  SEH_EN2_G_1 U141 ( .A1(sb_adr_i[7]), .A2(SB_ID[3]), .X(n114) );
  SEH_AN3_S_2 U142 ( .A1(n110), .A2(n188), .A3(sb_adr_i[1]), .X(n7) );
  SEH_AN3B_0P5 U143 ( .B1(n7), .B2(id_stb_pulse), .A(sb_we_i), .X(spirxdr_rd)
         );
  SEH_AO21B_1 U144 ( .A1(int_mdf), .A2(n62), .B(n78), .X(n109) );
  SEH_AO21B_1 U145 ( .A1(int_roe), .A2(n62), .B(n78), .X(n98) );
  SEH_AO21B_1 U146 ( .A1(int_rrdy), .A2(n62), .B(n78), .X(n88) );
  SEH_AO2BB2_DG_1 U147 ( .A1(n18), .A2(n196), .B1(n18), .B2(spiintcr0), .X(
        n116) );
  SEH_AO2BB2_DG_1 U148 ( .A1(n18), .A2(n195), .B1(n18), .B2(spiintcr1), .X(
        n117) );
  SEH_AO2BB2_DG_1 U149 ( .A1(n18), .A2(n193), .B1(n18), .B2(spiintcr3), .X(
        n119) );
  SEH_AO2BB2_DG_1 U150 ( .A1(n18), .A2(n191), .B1(n18), .B2(spiintcr5), .X(
        n121) );
  SEH_AO2BB2_DG_1 U151 ( .A1(n18), .A2(n189), .B1(n18), .B2(spiintcr7), .X(
        n123) );
  SEH_AOI31_G_1 U152 ( .A1(n99), .A2(n100), .A3(n101), .B(n67), .X(N47) );
  SEH_AOI22_1 U153 ( .A1(spisr[0]), .A2(n69), .B1(spitxdr[0]), .B2(n182), .X(
        n99) );
  SEH_AOI221_2 U154 ( .A1(spicr2[0]), .A2(n179), .B1(spibr[0]), .B2(n180), .C(
        n105), .X(n101) );
  SEH_AOI222_2 U155 ( .A1(spicsr[0]), .A2(n183), .B1(spiintcr0), .B2(n109), 
        .C1(spirxdr[0]), .C2(n7), .X(n100) );
  SEH_AOI31_G_1 U156 ( .A1(n94), .A2(n95), .A3(n96), .B(n67), .X(N48) );
  SEH_AOI22_1 U157 ( .A1(spisr[1]), .A2(n69), .B1(spitxdr[1]), .B2(n182), .X(
        n94) );
  SEH_AOI221_2 U158 ( .A1(spicr2[1]), .A2(n179), .B1(spibr[1]), .B2(n180), .C(
        n97), .X(n96) );
  SEH_AOI222_2 U159 ( .A1(spicsr[1]), .A2(n183), .B1(spiintcr1), .B2(n98), 
        .C1(spirxdr[1]), .C2(n7), .X(n95) );
  SEH_AOI31_G_1 U160 ( .A1(n89), .A2(n90), .A3(n91), .B(n67), .X(N49) );
  SEH_AOI22_1 U161 ( .A1(spisr[2]), .A2(n69), .B1(spitxdr[2]), .B2(n182), .X(
        n89) );
  SEH_AOI221_2 U162 ( .A1(spicr2[2]), .A2(n179), .B1(spibr[2]), .B2(n180), .C(
        n92), .X(n91) );
  SEH_AOI222_2 U163 ( .A1(spicsr[2]), .A2(n183), .B1(spiintcr2), .B2(n93), 
        .C1(spirxdr[2]), .C2(n7), .X(n90) );
  SEH_AOI31_G_1 U164 ( .A1(n84), .A2(n85), .A3(n86), .B(n67), .X(N50) );
  SEH_AOI22_1 U165 ( .A1(spisr[3]), .A2(n69), .B1(spitxdr[3]), .B2(n182), .X(
        n84) );
  SEH_AOI221_2 U166 ( .A1(spicr2[3]), .A2(n179), .B1(spibr[3]), .B2(n180), .C(
        n87), .X(n86) );
  SEH_AOI222_2 U167 ( .A1(spicsr[3]), .A2(n183), .B1(spiintcr3), .B2(n88), 
        .C1(spirxdr[3]), .C2(n7), .X(n85) );
  SEH_AOI31_G_1 U168 ( .A1(n79), .A2(n80), .A3(n81), .B(n67), .X(N51) );
  SEH_AOI22_1 U169 ( .A1(spisr[4]), .A2(n69), .B1(spitxdr[4]), .B2(n182), .X(
        n79) );
  SEH_AOI221_2 U170 ( .A1(spicr2[4]), .A2(n179), .B1(spibr[4]), .B2(n180), .C(
        n82), .X(n81) );
  SEH_AOI222_2 U171 ( .A1(spicsr[4]), .A2(n183), .B1(spiintcr4), .B2(n83), 
        .C1(spirxdr[4]), .C2(n7), .X(n80) );
  SEH_AOI31_G_1 U172 ( .A1(n74), .A2(n75), .A3(n76), .B(n67), .X(N52) );
  SEH_AOI22_1 U173 ( .A1(spisr[5]), .A2(n69), .B1(spitxdr[5]), .B2(n182), .X(
        n74) );
  SEH_AOI221_2 U174 ( .A1(spicr2[5]), .A2(n179), .B1(spibr[5]), .B2(n180), .C(
        n77), .X(n76) );
  SEH_AOI222_2 U175 ( .A1(spicsr[5]), .A2(n183), .B1(spiintcr5), .B2(n181), 
        .C1(spirxdr[5]), .C2(n7), .X(n75) );
  SEH_AOI31_G_1 U177 ( .A1(n70), .A2(n71), .A3(n72), .B(n67), .X(N53) );
  SEH_AOI22_1 U178 ( .A1(spisr[6]), .A2(n69), .B1(spitxdr[6]), .B2(n182), .X(
        n70) );
  SEH_AOI221_2 U179 ( .A1(spicr2[6]), .A2(n179), .B1(spibr[6]), .B2(n180), .C(
        n73), .X(n72) );
  SEH_AOI222_2 U180 ( .A1(spicsr[6]), .A2(n183), .B1(n1410), .B2(n181), .C1(
        spirxdr[6]), .C2(n7), .X(n71) );
  SEH_AOI31_G_1 U181 ( .A1(n64), .A2(n65), .A3(n66), .B(n67), .X(N54) );
  SEH_AOI22_1 U182 ( .A1(spisr[7]), .A2(n69), .B1(spitxdr[7]), .B2(n182), .X(
        n64) );
  SEH_AOI221_2 U183 ( .A1(spicr2[7]), .A2(n179), .B1(spibr[7]), .B2(n180), .C(
        n68), .X(n66) );
  SEH_AOI222_2 U184 ( .A1(spicsr[7]), .A2(n183), .B1(spiintcr7), .B2(n181), 
        .C1(spirxdr[7]), .C2(n7), .X(n65) );
  SEH_AO2BB2_DG_1 U185 ( .A1(n194), .A2(n30), .B1(n30), .B2(spitxdr[2]), .X(
        n126) );
  SEH_AO2BB2_DG_1 U186 ( .A1(n192), .A2(n30), .B1(n30), .B2(spitxdr[4]), .X(
        n128) );
  SEH_AO2BB2_DG_1 U187 ( .A1(n194), .A2(n32), .B1(n32), .B2(spicsr[2]), .X(
        n134) );
  SEH_AO2BB2_DG_1 U188 ( .A1(n192), .A2(n32), .B1(n32), .B2(spicsr[4]), .X(
        n136) );
  SEH_AO2BB2_DG_1 U189 ( .A1(n194), .A2(n34), .B1(n34), .B2(spibr[2]), .X(n142) );
  SEH_AO2BB2_DG_1 U190 ( .A1(n192), .A2(n34), .B1(n34), .B2(spibr[4]), .X(n144) );
  SEH_AO2BB2_DG_1 U191 ( .A1(n194), .A2(n36), .B1(n36), .B2(spicr2[2]), .X(
        n150) );
  SEH_AO2BB2_DG_1 U192 ( .A1(n192), .A2(n36), .B1(n36), .B2(spicr2[4]), .X(
        n152) );
  SEH_AO2BB2_DG_1 U193 ( .A1(n196), .A2(n30), .B1(n30), .B2(spitxdr[0]), .X(
        n124) );
  SEH_AO2BB2_DG_1 U194 ( .A1(n195), .A2(n30), .B1(n30), .B2(spitxdr[1]), .X(
        n125) );
  SEH_AO2BB2_DG_1 U195 ( .A1(n193), .A2(n30), .B1(n30), .B2(spitxdr[3]), .X(
        n127) );
  SEH_AO2BB2_DG_1 U196 ( .A1(n191), .A2(n30), .B1(n30), .B2(spitxdr[5]), .X(
        n129) );
  SEH_AO2BB2_DG_1 U197 ( .A1(n190), .A2(n30), .B1(n30), .B2(spitxdr[6]), .X(
        n130) );
  SEH_AO2BB2_DG_1 U198 ( .A1(n189), .A2(n30), .B1(n30), .B2(spitxdr[7]), .X(
        n131) );
  SEH_AO2BB2_DG_1 U199 ( .A1(n196), .A2(n32), .B1(n32), .B2(spicsr[0]), .X(
        n132) );
  SEH_AO2BB2_DG_1 U200 ( .A1(n195), .A2(n32), .B1(n32), .B2(spicsr[1]), .X(
        n133) );
  SEH_AO2BB2_DG_1 U201 ( .A1(n193), .A2(n32), .B1(n32), .B2(spicsr[3]), .X(
        n135) );
  SEH_AO2BB2_DG_1 U202 ( .A1(n191), .A2(n32), .B1(n32), .B2(spicsr[5]), .X(
        n137) );
  SEH_AO2BB2_DG_1 U203 ( .A1(n190), .A2(n32), .B1(n32), .B2(spicsr[6]), .X(
        n138) );
  SEH_AO2BB2_DG_1 U204 ( .A1(n189), .A2(n32), .B1(n32), .B2(spicsr[7]), .X(
        n139) );
  SEH_AO2BB2_DG_1 U205 ( .A1(n196), .A2(n34), .B1(n34), .B2(spibr[0]), .X(n140) );
  SEH_AO2BB2_DG_1 U206 ( .A1(n195), .A2(n34), .B1(n34), .B2(spibr[1]), .X(n141) );
  SEH_AO2BB2_DG_1 U207 ( .A1(n193), .A2(n34), .B1(n34), .B2(spibr[3]), .X(n143) );
  SEH_AO2BB2_DG_1 U208 ( .A1(n191), .A2(n34), .B1(n34), .B2(spibr[5]), .X(n145) );
  SEH_AO2BB2_DG_1 U209 ( .A1(n190), .A2(n34), .B1(n34), .B2(spibr[6]), .X(n146) );
  SEH_AO2BB2_DG_1 U210 ( .A1(n189), .A2(n34), .B1(n34), .B2(spibr[7]), .X(n147) );
  SEH_AO2BB2_DG_1 U211 ( .A1(n196), .A2(n36), .B1(n36), .B2(spicr2[0]), .X(
        n148) );
  SEH_AO2BB2_DG_1 U212 ( .A1(n195), .A2(n36), .B1(n36), .B2(spicr2[1]), .X(
        n149) );
  SEH_AO2BB2_DG_1 U213 ( .A1(n193), .A2(n36), .B1(n36), .B2(spicr2[3]), .X(
        n151) );
  SEH_AO2BB2_DG_1 U214 ( .A1(n191), .A2(n36), .B1(n36), .B2(spicr2[5]), .X(
        n153) );
  SEH_AO2BB2_DG_1 U215 ( .A1(n190), .A2(n36), .B1(n36), .B2(spicr2[6]), .X(
        n154) );
  SEH_AO2BB2_DG_1 U216 ( .A1(n189), .A2(n36), .B1(n36), .B2(spicr2[7]), .X(
        n155) );
  SEH_NR2B_V1_1 U217 ( .A(sb_stb_i), .B(n115), .X(n113) );
  SEH_EO2_G_1 U218 ( .A1(sb_adr_i[4]), .A2(SB_ID[0]), .X(n115) );
  SEH_NR2_S_0P5 U219 ( .A1(id_stb_dly), .A2(n58), .X(N14) );
  SEH_INV_S_1 U220 ( .A(spicr1[7]), .X(n55) );
  SEH_INV_S_1 U221 ( .A(spiintcr4), .X(n106) );
  SEH_INV_S_1 U222 ( .A(spiintcr2), .X(n172) );
  spi_sci_int_reg_0 intr_mdf ( .status(int_mdf), .spi_rst_async(spi_rst_async), 
        .sb_clk_i(sb_clk_i), .int_force(spiintcr6), .int_set(spisr[0]), 
        .int_clr(int_clr_mdf), .scan_test_mode(scan_test_mode) );
  spi_sci_int_reg_4 intr_roe ( .status(int_roe), .spi_rst_async(spi_rst_async), 
        .sb_clk_i(sb_clk_i), .int_force(spiintcr6), .int_set(spisr[1]), 
        .int_clr(int_clr_roe), .scan_test_mode(scan_test_mode) );
  spi_sci_int_reg_3 intr_toe ( .status(int_toe), .spi_rst_async(spi_rst_async), 
        .sb_clk_i(sb_clk_i), .int_force(spiintcr6), .int_set(spisr[2]), 
        .int_clr(int_clr_toe), .scan_test_mode(scan_test_mode) );
  spi_sci_int_reg_2 intr_rrdy ( .status(int_rrdy), .spi_rst_async(spi_rst_async), 
        .sb_clk_i(sb_clk_i), .int_force(n15), .int_set(spisr[3]), .int_clr(
        int_clr_rrdy), .scan_test_mode(scan_test_mode) );
  spi_sci_int_reg_1 intr_trdy ( .status(int_trdy), .spi_rst_async(spi_rst_async), 
        .sb_clk_i(sb_clk_i), .int_force(spiintcr6), .int_set(spisr[4]), 
        .int_clr(int_clr_trdy), .scan_test_mode(scan_test_mode) );
  SEH_FDPRBQ_V2_1P5 id_stb_pulse_reg ( .D(N14), .CK(sb_clk_i), .RD(n42), .Q(
        id_stb_pulse) );
  SEH_FDPRBQ_V2_1P5 spibr_reg6 ( .D(n146), .CK(sb_clk_i), .RD(n41), .Q(
        spibr[6]) );
  SEH_FDPRBQ_V2_1P5 spiintcr_reg5 ( .D(n121), .CK(sb_clk_i), .RD(n40), .Q(
        spiintcr5) );
  SEH_FDPRBQ_V2_1P5 spitxdr_reg3 ( .D(n127), .CK(sb_clk_i), .RD(n45), .Q(
        spitxdr[3]) );
  SEH_FDPRBQ_V2_1P5 spitxdr_reg2 ( .D(n126), .CK(sb_clk_i), .RD(n177), .Q(
        spitxdr[2]) );
  SEH_FDPRBQ_V2_1P5 spitxdr_reg7 ( .D(n131), .CK(sb_clk_i), .RD(n44), .Q(
        spitxdr[7]) );
  SEH_FDPRBQ_V2_1P5 spitxdr_reg0 ( .D(n124), .CK(sb_clk_i), .RD(n44), .Q(
        spitxdr[0]) );
  SEH_FDPRBQ_V2_1P5 spitxdr_reg5 ( .D(n129), .CK(sb_clk_i), .RD(n43), .Q(
        spitxdr[5]) );
  SEH_FDPRBQ_V2_1P5 spitxdr_reg4 ( .D(n128), .CK(sb_clk_i), .RD(n44), .Q(
        spitxdr[4]) );
  SEH_FDPRBQ_V2_1P5 spicr2_reg6 ( .D(n154), .CK(sb_clk_i), .RD(n42), .Q(
        spicr2[6]) );
  SEH_FDPRBQ_V2_1P5 spiintcr_reg3 ( .D(n119), .CK(sb_clk_i), .RD(n40), .Q(
        spiintcr3) );
  SEH_FDPRBQ_V2_1P5 spiintcr_reg1 ( .D(n117), .CK(sb_clk_i), .RD(n40), .Q(
        spiintcr1) );
  SEH_FDPRBQ_V2_1P5 spicr1_reg5 ( .D(n161), .CK(sb_clk_i), .RD(n42), .Q(
        spicr1[5]) );
  SEH_FDPRBQ_V2_1P5 spiintcr_reg0 ( .D(n116), .CK(sb_clk_i), .RD(n40), .Q(
        spiintcr0) );
  SEH_FDPRBQ_V2_1P5 spibr_reg2 ( .D(n142), .CK(sb_clk_i), .RD(n41), .Q(
        spibr[2]) );
  SEH_FDPRBQ_V2_1P5 spitxdr_reg6 ( .D(n130), .CK(sb_clk_i), .RD(n45), .Q(
        spitxdr[6]) );
  SEH_FDPRBQ_V2_1P5 spitxdr_reg1 ( .D(n125), .CK(sb_clk_i), .RD(n43), .Q(
        spitxdr[1]) );
  SEH_FDPRBQ_V2_1P5 spicsr_reg7 ( .D(n139), .CK(sb_clk_i), .RD(n41), .Q(
        spicsr[7]) );
  SEH_FDPRBQ_V2_1P5 spicsr_reg6 ( .D(n138), .CK(sb_clk_i), .RD(n41), .Q(
        spicsr[6]) );
  SEH_FDPRBQ_V2_1P5 spicsr_reg5 ( .D(n137), .CK(sb_clk_i), .RD(n177), .Q(
        spicsr[5]) );
  SEH_FDPRBQ_V2_1P5 spicsr_reg4 ( .D(n136), .CK(sb_clk_i), .RD(n43), .Q(
        spicsr[4]) );
  SEH_FDPRBQ_V2_1P5 spicsr_reg3 ( .D(n135), .CK(sb_clk_i), .RD(n44), .Q(
        spicsr[3]) );
  SEH_FDPRBQ_V2_1P5 spicsr_reg2 ( .D(n134), .CK(sb_clk_i), .RD(n45), .Q(
        spicsr[2]) );
  SEH_FDPRBQ_V2_1P5 spicsr_reg1 ( .D(n133), .CK(sb_clk_i), .RD(n42), .Q(
        spicsr[1]) );
  SEH_FDPRBQ_V2_1P5 spicsr_reg0 ( .D(n132), .CK(sb_clk_i), .RD(n40), .Q(
        spicsr[0]) );
  SEH_FDPRBQ_V2_1P5 spicr2_reg3 ( .D(n151), .CK(sb_clk_i), .RD(n41), .Q(
        spicr2[3]) );
  SEH_FDPRBQ_V2_1P5 spicr2_reg5 ( .D(n153), .CK(sb_clk_i), .RD(n42), .Q(
        spicr2[5]) );
  SEH_FDPRBQ_V2_1P5 spiintcr_reg7 ( .D(n123), .CK(sb_clk_i), .RD(n45), .Q(
        spiintcr7) );
  SEH_FDPRBQ_V2_1P5 spicr2_reg4 ( .D(n152), .CK(sb_clk_i), .RD(n41), .Q(
        spicr2[4]) );
  SEH_FDPRBQ_V2_1P5 spicr1_reg6 ( .D(n162), .CK(sb_clk_i), .RD(n42), .Q(
        spicr1[6]) );
  SEH_FDPRBQ_V2_1P5 spicr2_reg1 ( .D(n149), .CK(sb_clk_i), .RD(n41), .Q(
        spicr2[1]) );
  SEH_FDPRBQ_V2_1P5 spicr0_reg5 ( .D(n169), .CK(sb_clk_i), .RD(n40), .Q(
        spicr0[5]) );
  SEH_FDPRBQ_V2_1P5 spicr1_reg3 ( .D(n159), .CK(sb_clk_i), .RD(n42), .Q(
        spicr1[3]) );
  SEH_FDPRBQ_V2_1P5 spicr1_reg2 ( .D(n158), .CK(sb_clk_i), .RD(n42), .Q(
        spicr1[2]) );
  SEH_FDPRBQ_V2_1P5 spibr_reg3 ( .D(n143), .CK(sb_clk_i), .RD(n41), .Q(
        spibr[3]) );
  SEH_FDPRBQ_V2_1P5 spiintcr_reg2 ( .D(n118), .CK(sb_clk_i), .RD(n40), .Q(
        spiintcr2) );
  SEH_FDPRBQ_V2_1P5 spibr_reg1 ( .D(n141), .CK(sb_clk_i), .RD(n41), .Q(
        spibr[1]) );
  SEH_FDPRBQ_V2_1P5 spibr_reg0 ( .D(n140), .CK(sb_clk_i), .RD(n41), .Q(
        spibr[0]) );
  SEH_FDPRBQ_V2_1P5 spiintcr_reg4 ( .D(n120), .CK(sb_clk_i), .RD(n40), .Q(
        spiintcr4) );
  SEH_FDPRBQ_V2_1P5 spibr_reg7 ( .D(n147), .CK(sb_clk_i), .RD(n41), .Q(
        spibr[7]) );
  SEH_FDPRBQ_V2_1P5 spicr0_reg6 ( .D(n170), .CK(sb_clk_i), .RD(n42), .Q(
        spicr0[6]) );
  SEH_FDPRBQ_V2_1P5 spicr0_reg7 ( .D(n171), .CK(sb_clk_i), .RD(n41), .Q(
        spicr0[7]) );
  SEH_FDPRBQ_V2_1P5 spicr0_reg3 ( .D(n167), .CK(sb_clk_i), .RD(n42), .Q(
        spicr0[3]) );
  SEH_FDPRBQ_V2_1P5 spicr0_reg4 ( .D(n168), .CK(sb_clk_i), .RD(n41), .Q(
        spicr0[4]) );
  SEH_FDPRBQ_V2_1P5 spicr2_reg2 ( .D(n150), .CK(sb_clk_i), .RD(n41), .Q(
        spicr2[2]) );
  SEH_FDPRBQ_V2_1P5 spibr_reg4 ( .D(n144), .CK(sb_clk_i), .RD(n41), .Q(
        spibr[4]) );
  SEH_FDPRBQ_V2_1P5 spicr2_reg7 ( .D(n155), .CK(sb_clk_i), .RD(n42), .Q(
        spicr2[7]) );
  SEH_FDPRBQ_V2_1P5 spibr_reg5 ( .D(n145), .CK(sb_clk_i), .RD(n41), .Q(
        spibr[5]) );
  SEH_FDPRBQ_V2_1P5 spicr0_reg1 ( .D(n165), .CK(sb_clk_i), .RD(n42), .Q(
        spicr0[1]) );
  SEH_FDPRBQ_V2_1P5 spicr0_reg2 ( .D(n166), .CK(sb_clk_i), .RD(n42), .Q(
        spicr0[2]) );
  SEH_FDPRBQ_V2_1P5 spicr0_reg0 ( .D(n164), .CK(sb_clk_i), .RD(n42), .Q(
        spicr0[0]) );
  SEH_FDPRBQ_V2_1P5 spicr1_reg1 ( .D(n157), .CK(sb_clk_i), .RD(n42), .Q(
        spicr1[1]) );
  SEH_FDPRBQ_V2_1P5 spicr1_reg0 ( .D(n156), .CK(sb_clk_i), .RD(n42), .Q(
        spicr1[0]) );
  SEH_FDPRBQ_V2_1P5 spicr1_reg4 ( .D(n160), .CK(sb_clk_i), .RD(n42), .Q(
        spicr1[4]) );
  SEH_FDPRBQ_V2_1P5 spicr1_reg7 ( .D(n163), .CK(sb_clk_i), .RD(n42), .Q(
        spicr1[7]) );
  SEH_FDPRBQ_V2_1P5 spiintcr_reg6 ( .D(n122), .CK(sb_clk_i), .RD(n40), .Q(
        spiintcr6) );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg5 ( .D(N52), .CK(sb_clk_i), .RD(n40), .Q(n199)
         );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg3 ( .D(N50), .CK(sb_clk_i), .RD(n40), .Q(n201)
         );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg1 ( .D(N48), .CK(sb_clk_i), .RD(n40), .Q(n203)
         );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg2 ( .D(N49), .CK(sb_clk_i), .RD(n40), .Q(n202)
         );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg0 ( .D(N47), .CK(sb_clk_i), .RD(n40), .Q(n204)
         );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg4 ( .D(N51), .CK(sb_clk_i), .RD(n40), .Q(n200)
         );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg7 ( .D(N54), .CK(sb_clk_i), .RD(n40), .Q(n197)
         );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg6 ( .D(N53), .CK(sb_clk_i), .RD(n40), .Q(n198)
         );
  SEH_FDPRBQ_V2_3 spicr2_reg0 ( .D(n148), .CK(sb_clk_i), .RD(n41), .Q(
        spicr2[0]) );
  SEH_INV_S_1 U25 ( .A(sb_adr_i[2]), .X(n186) );
  SEH_NR2_G_1 U66 ( .A1(n5), .A2(n9), .X(spicr2_wt) );
  SEH_AN2_DG_1 U69 ( .A1(sb_adr_i[3]), .A2(sb_adr_i[2]), .X(n110) );
  SEH_ND2_G_1 U75 ( .A1(n3), .A2(sb_we_i), .X(n206) );
  SEH_INV_S_2 U112 ( .A(n206), .X(n29) );
  SEH_ND3B_V1DG_1 U132 ( .A(sb_adr_i[0]), .B1(n110), .B2(n187), .X(n207) );
  SEH_INV_S_2 U223 ( .A(n207), .X(n69) );
endmodule


module CKHS_INVX1 ( z, a );
  input a;
  output z;


  SEH_INV_S_1 u ( .A(a), .X(z) );
endmodule


module CKHS_MUX2X2 ( z, d1, d0, sd );
  input d1, d0, sd;
  output z;


  SEH_MUX2_S_2 u ( .D0(d0), .D1(d1), .S(sd), .X(z) );
endmodule


module CKHS_BUFX4_0 ( z, a );
  input a;
  output z;


  SEH_BUF_S_4 u ( .A(a), .X(z) );
endmodule


module CKHS_MUX4X2 ( z, d3, d2, d1, d0, sd2, sd1 );
  input d3, d2, d1, d0, sd2, sd1;
  output z;


  SEH_MUX4_DG_2 u ( .D0(d0), .D1(d1), .D2(d2), .D3(d3), .S0(sd1), .S1(sd2), 
        .X(z) );
endmodule


module CKHS_BUFX4_2 ( z, a );
  input a;
  output z;
  wire   n3, n1;

  SEH_BUF_S_4 u ( .A(a), .X(n3) );
  SEH_INV_S_2 U1 ( .A(n3), .X(n1) );
  SEH_INV_S_12 U2 ( .A(n1), .X(z) );
endmodule


module CKHS_BUFX4_1 ( z, a );
  input a;
  output z;


  SEH_BUF_S_4 u ( .A(a), .X(z) );
endmodule


module spi_div_6_01 ( clk_out, hlf_cyc, clk_in, clk_en, clk_run, clk_tog, 
        clk_pol, div_exp, div );
  input [5:0] div;
  input clk_in, clk_en, clk_run, clk_tog, clk_pol, div_exp;
  output clk_out, hlf_cyc;
  wire   clk_out_mx, cfg_ckp, div_even, cfg_ckn, cfg_ckb, div_ext6, div_ext5,
         div_ext4, div_ext3, div_ext2, div_ext1, div_ext0, div_ext_half6,
         div_ext_half5, div_ext_half4, div_ext_half3, div_ext_half2,
         div_ext_half1, div_ext_half0, div_cnt6, div_cnt5, div_cnt4, div_cnt3,
         div_cnt2, div_cnt1, div_cnt0, N29, N30, N31, n8, n9, n33, n34, n35,
         n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49,
         n50, n51, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64,
         n65, n66, add_134carry2, add_134carry3, add_134carry4, add_134carry5,
         n1, n2, n3, n4, n5, n6, n7, n11, n12, n13, n14, n15, n16, n17, n18,
         n19, n20, n21, n22, n23, n24, n27, n28, n290, n300, n310, n67, n68,
         n69, n70, n71, n72, n73, n74, n75;

  SEH_FDNRBQ_V2_1 cfg_ckn_reg ( .D(cfg_ckp), .CK(clk_in), .RD(clk_en), .Q(
        cfg_ckn) );
  SEH_ADDH_1 add_134U1_1_4 ( .A(div_ext5), .B(add_134carry4), .CO(
        add_134carry5), .S(div_ext_half4) );
  SEH_ADDH_1 add_134U1_1_3 ( .A(div_ext4), .B(add_134carry3), .CO(
        add_134carry4), .S(div_ext_half3) );
  SEH_ADDH_1 add_134U1_1_2 ( .A(div_ext3), .B(add_134carry2), .CO(
        add_134carry3), .S(div_ext_half2) );
  SEH_ADDH_1 add_134U1_1_1 ( .A(div_ext2), .B(div_ext1), .CO(add_134carry2), 
        .S(div_ext_half1) );
  SEH_ADDH_1 add_134U1_1_5 ( .A(div_ext6), .B(add_134carry5), .CO(
        div_ext_half6), .S(div_ext_half5) );
  SEH_NR4_2 U4 ( .A1(n48), .A2(n49), .A3(n50), .A4(n51), .X(n47) );
  SEH_AO22_DG_1 U5 ( .A1(div_ext6), .A2(div[3]), .B1(n1), .B2(div[4]), .X(
        div_ext4) );
  SEH_INV_S_1 U6 ( .A(n53), .X(n1) );
  SEH_OR2_1 U7 ( .A1(n11), .A2(div_cnt2), .X(n12) );
  SEH_INV_S_1 U9 ( .A(n2), .X(div_ext2) );
  SEH_AOAI211_G_1 U11 ( .A1(div_cnt0), .A2(div_cnt1), .B(n3), .C(n36), .X(n41)
         );
  SEH_INV_S_1 U12 ( .A(n11), .X(n3) );
  SEH_AOAI211_0P75 U13 ( .A1(n11), .A2(div_cnt2), .B(n4), .C(n36), .X(n40) );
  SEH_INV_S_0P8 U14 ( .A(n12), .X(n4) );
  SEH_INV_S_1 U16 ( .A(n5), .X(div_ext3) );
  SEH_OA32_1 U17 ( .A1(n16), .A2(n24), .A3(n33), .B1(n9), .B2(n34), .X(n6) );
  SEH_INV_S_1 U18 ( .A(n6), .X(n58) );
  SEH_AOA211_DG_1 U19 ( .A1(n12), .A2(div_cnt3), .B(n13), .C(n36), .X(n7) );
  SEH_INV_S_1 U20 ( .A(n7), .X(n39) );
  SEH_NR2_S_1 U21 ( .A1(div[1]), .A2(div[0]), .X(n55) );
  SEH_INV_S_1 U23 ( .A(div[3]), .X(n68) );
  SEH_ND2_G_1 U24 ( .A1(div_exp), .A2(div[5]), .X(n54) );
  SEH_INV_S_1 U25 ( .A(div[0]), .X(n71) );
  SEH_ND4_S_1P5 U26 ( .A1(n55), .A2(n69), .A3(n57), .A4(n68), .X(n56) );
  SEH_OAI221_2 U28 ( .A1(n55), .A2(n54), .B1(n290), .B2(n56), .C(n70), .X(
        div_ext1) );
  SEH_EO2_G_1 U29 ( .A1(div_cnt6), .A2(n15), .X(N31) );
  SEH_NR2_G_1 U30 ( .A1(div_cnt5), .A2(n14), .X(n15) );
  SEH_OAI221_1 U31 ( .A1(n300), .A2(n35), .B1(n36), .B2(n17), .C(n43), .X(n65)
         );
  SEH_OAI221_1 U32 ( .A1(div_ext_half0), .A2(n35), .B1(n36), .B2(n19), .C(n41), 
        .X(n63) );
  SEH_OAI221_1 U33 ( .A1(n2), .A2(n35), .B1(n36), .B2(n20), .C(n40), .X(n62)
         );
  SEH_OAI221_1 U34 ( .A1(n5), .A2(n35), .B1(n36), .B2(n21), .C(n39), .X(n61)
         );
  SEH_EN2_G_1 U35 ( .A1(div_cnt5), .A2(n14), .X(N30) );
  SEH_ND2_T_0P65 U36 ( .A1(n13), .A2(n22), .X(n14) );
  SEH_OAI221_1 U37 ( .A1(n28), .A2(n35), .B1(n36), .B2(n23), .C(n37), .X(n59)
         );
  SEH_NR2_S_1 U38 ( .A1(n12), .A2(div_cnt3), .X(n13) );
  SEH_NR2B_V1DG_4 U39 ( .A(clk_run), .B(n16), .X(n36) );
  SEH_ND4_S_1P5 U40 ( .A1(n44), .A2(n45), .A3(n46), .A4(n47), .X(n33) );
  SEH_NR2_T_1 U41 ( .A1(n54), .A2(n71), .X(div_ext6) );
  SEH_INV_S_1 U43 ( .A(n35), .X(n16) );
  SEH_INV_S_1 U44 ( .A(div_exp), .X(n290) );
  SEH_INV_S_1 U45 ( .A(div[2]), .X(n69) );
  SEH_INV_S_1 U47 ( .A(div[4]), .X(n67) );
  SEH_INV_S_1 U48 ( .A(div[1]), .X(n70) );
  SEH_INV_S_1 U49 ( .A(div_cnt5), .X(n23) );
  SEH_INV_S_1 U50 ( .A(div_cnt4), .X(n22) );
  SEH_INV_S_1 U51 ( .A(div_cnt6), .X(n18) );
  SEH_INV_S_1 U53 ( .A(n66), .X(n8) );
  SEH_OAI221_1 U54 ( .A1(n27), .A2(n35), .B1(n36), .B2(n22), .C(n38), .X(n60)
         );
  SEH_INV_S_1 U55 ( .A(div_ext4), .X(n27) );
  SEH_ND2_0P8 U56 ( .A1(N29), .A2(n36), .X(n38) );
  SEH_ND2_G_1 U57 ( .A1(n35), .A2(n33), .X(hlf_cyc) );
  SEH_EO2_G_1 U58 ( .A1(n22), .A2(div_ext_half4), .X(n45) );
  SEH_EO2_G_1 U59 ( .A1(n18), .A2(div_ext_half6), .X(n46) );
  SEH_EO2_G_1 U60 ( .A1(n23), .A2(div_ext_half5), .X(n44) );
  SEH_ND3_1 U61 ( .A1(n56), .A2(n54), .A3(n71), .X(div_ext0) );
  SEH_ND2_G_1 U62 ( .A1(cfg_ckn), .A2(cfg_ckp), .X(n66) );
  SEH_OAI221_1 U63 ( .A1(n35), .A2(n310), .B1(n36), .B2(n18), .C(n42), .X(n64)
         );
  SEH_ND2_S_0P5 U64 ( .A1(N31), .A2(n36), .X(n42) );
  SEH_INV_S_1 U65 ( .A(div_ext5), .X(n28) );
  SEH_ND2_S_0P5 U66 ( .A1(N30), .A2(n36), .X(n37) );
  SEH_INV_S_1 U67 ( .A(div_cnt3), .X(n21) );
  SEH_INV_S_1 U70 ( .A(div_ext0), .X(n300) );
  SEH_ND2_G_1 U71 ( .A1(n17), .A2(n36), .X(n43) );
  SEH_NR2_S_0P8 U72 ( .A1(n24), .A2(n35), .X(n34) );
  SEH_INV_S_1 U73 ( .A(clk_tog), .X(n24) );
  SEH_INV_S_1 U74 ( .A(cfg_ckp), .X(n9) );
  SEH_EO2_G_1 U75 ( .A1(div_ext_half0), .A2(div_cnt0), .X(n51) );
  SEH_EO2_G_1 U76 ( .A1(div_ext_half1), .A2(div_cnt1), .X(n50) );
  SEH_EO2_G_1 U77 ( .A1(div_ext_half3), .A2(div_cnt3), .X(n48) );
  SEH_EO2_G_1 U78 ( .A1(div_ext_half2), .A2(div_cnt2), .X(n49) );
  SEH_OR2_1 U79 ( .A1(div_cnt1), .A2(div_cnt0), .X(n11) );
  SEH_NR2_G_1 U80 ( .A1(div[5]), .A2(div[4]), .X(n57) );
  SEH_INV_S_1 U81 ( .A(div_cnt0), .X(n17) );
  SEH_INV_S_1 U82 ( .A(div_cnt1), .X(n19) );
  SEH_INV_S_1 U83 ( .A(div_cnt2), .X(n20) );
  SEH_INV_0P5 U84 ( .A(div_ext1), .X(div_ext_half0) );
  SEH_OAI21_0P5 U85 ( .A1(n13), .A2(n22), .B(n14), .X(N29) );
  CKHS_MUX4X2 mux_CTS_even ( .z(clk_out_mx), .d3(n9), .d2(n66), .d1(cfg_ckp), 
        .d0(n8), .sd2(clk_pol), .sd1(div_even) );
  CKHS_BUFX4_2 buf_CTS_clk_out ( .z(clk_out), .a(clk_out_mx) );
  CKHS_BUFX4_1 buf_CTS_ckb ( .z(cfg_ckb), .a(cfg_ckp) );
  SEH_FDPRBQ_V2_1P5 cfg_ckp_reg ( .D(n58), .CK(clk_in), .RD(clk_en), .Q(
        cfg_ckp) );
  SEH_FDPRBQ_V2_1P5 div_cnt_reg0 ( .D(n65), .CK(clk_in), .RD(clk_en), .Q(
        div_cnt0) );
  SEH_FDPRBQ_V2_1P5 div_cnt_reg4 ( .D(n60), .CK(clk_in), .RD(clk_en), .Q(
        div_cnt4) );
  SEH_FDPRBQ_V2_1P5 div_cnt_reg5 ( .D(n59), .CK(clk_in), .RD(clk_en), .Q(
        div_cnt5) );
  SEH_FDPRBQ_V2_1P5 div_cnt_reg6 ( .D(n64), .CK(clk_in), .RD(clk_en), .Q(
        div_cnt6) );
  SEH_FDPRBQ_V2_1P5 div_cnt_reg1 ( .D(n63), .CK(clk_in), .RD(clk_en), .Q(
        div_cnt1) );
  SEH_FDPRBQ_V2_1P5 div_cnt_reg2 ( .D(n62), .CK(clk_in), .RD(clk_en), .Q(
        div_cnt2) );
  SEH_FDPRBQ_V2_1P5 div_cnt_reg3 ( .D(n61), .CK(clk_in), .RD(clk_en), .Q(
        div_cnt3) );
  SEH_FDNRBSBQ_1 div_even_reg ( .D(div_ext0), .CK(cfg_ckb), .RD(n75), .SD(
        clk_en), .Q(div_even) );
  SEH_TIE1_G_1 U3 ( .X(n75) );
  SEH_AN4B_1 U8 ( .B1(n19), .B2(n20), .B3(n17), .A(n72), .X(n74) );
  SEH_OR4_1 U10 ( .A1(div_cnt6), .A2(div_cnt5), .A3(div_cnt4), .A4(div_cnt3), 
        .X(n72) );
  SEH_OA22_DG_1 U15 ( .A1(n69), .A2(n310), .B1(n53), .B2(n68), .X(n5) );
  SEH_OA22_DG_1 U22 ( .A1(n70), .A2(n310), .B1(n53), .B2(n69), .X(n2) );
  SEH_AO2BB2_DG_1 U27 ( .A1(n310), .A2(n67), .B1(n73), .B2(div[5]), .X(
        div_ext5) );
  SEH_INV_S_1 U42 ( .A(n53), .X(n73) );
  SEH_INV_1 U46 ( .A(div_ext6), .X(n310) );
  SEH_AN3_1 U52 ( .A1(div[5]), .A2(div[0]), .A3(div_exp), .X(n53) );
  SEH_INV_S_2 U68 ( .A(n74), .X(n35) );
endmodule


module SYNCP_STD_0 ( q, d, ck, cdn );
  input d, ck, cdn;
  output q;
  wire   q0;

  SEH_FDPRBQ_2 u ( .D(q0), .CK(ck), .RD(cdn), .Q(q) );
  SEH_FDPRBQ_V2_1P5 u0 ( .D(d), .CK(ck), .RD(cdn), .Q(q0) );
endmodule


module SYNCP_STD_1 ( q, d, ck, cdn );
  input d, ck, cdn;
  output q;
  wire   q0;

  SEH_FDPRBQ_2 u ( .D(q0), .CK(ck), .RD(cdn), .Q(q) );
  SEH_FDPRBQ_V2_1P5 u0 ( .D(d), .CK(ck), .RD(cdn), .Q(q0) );
endmodule


module spi_port ( mclk_o, mclk_oe, mosi_o, mosi_oe, miso_o, miso_oe, mcsn_o, 
        mcsn_oe, spisr, spirxdr, spi_wkup, spi_rst_async, sck_tcv, mosi_i, 
        miso_i, scsn_usr, sb_clk_i, spicr0, spicr1, spicr2, spibr, spicsr, 
        spitxdr, spicr0_wt, spicr1_wt, spicr2_wt, spibr_wt, spicsr_wt, 
        spitxdr_wt, spirxdr_rd );
  output [7:0] mcsn_o;
  output [7:0] mcsn_oe;
  output [7:0] spisr;
  output [7:0] spirxdr;
  input [7:0] spicr0;
  input [7:0] spicr1;
  input [7:0] spicr2;
  input [7:0] spibr;
  input [7:0] spicsr;
  input [7:0] spitxdr;
  input spi_rst_async, sck_tcv, mosi_i, miso_i, scsn_usr, sb_clk_i, spicr0_wt,
         spicr1_wt, spicr2_wt, spibr_wt, spicsr_wt, spitxdr_wt, spirxdr_rd;
  output mclk_o, mclk_oe, mosi_o, mosi_oe, miso_o, miso_oe, spi_wkup;
  wire   Logic1, n302, n303, n304, n305, n306, n307, n308, n309, n310, n311,
         n312, n313, n314, n315, n316, n317, n318, n319, n320, n321, n322,
         sck_tcv_inv, sck_tcv_fin, spi_port_sck_tcv_inv, sck_tcv_early_fin,
         sck_tcv_early, spi_master, mst_next3, mst_next1, mst_next0,
         mst_state3, mst_state2, mst_state1, mst_state0, spi_mfin_sync,
         mclk_en, mclk_run, hlf_cyc, dly_cnt3, dly_cnt2, dly_cnt1, dly_cnt0,
         N113, N114, N115, N116, byte_bndy, byte_bndy_early, tcv_cnt2,
         tcv_cnt1, tcv_cnt0, N135, byte_bndy_nd, spi_mhld_act, byte_bndy_sync1,
         byte_bndy_sync0, byte_bndy_nd_sync1, byte_bndy_nd_sync0,
         spi_trn_cap_sync1, spi_trn_cap_sync0, spi_trn_cap,
         spi_trn_nb_cap_sync1, spi_trn_nb_cap_sync0, spi_trn_cap_nb,
         spi_rcv_upd_sync0, mclk_sense, mcsn_sense, spi_trdy_sample_sense1,
         spi_trdy_sample_sense0, spi_trdy_sample, spi_trdy_sample_flag,
         spi_trdy_srmok, spi_rrdy_sample, rcv_rdy, tcv_reg7, tcv_reg6,
         tcv_reg5, tcv_reg4, tcv_reg3, tcv_reg2, tcv_reg1, tcv_reg0, trn_reg,
         n1, n3, n4, n5, n6, n8, n10, n14, n15, n18, n19, n20, n23, n25, n27,
         n29, n31, n33, n34, n38, n39, n42, n43, n44, n45, n47, n49, n50, n52,
         n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66,
         n67, n68, n69, n70, n72, n73, n74, n75, n78, n80, n81, n82, n84, n89,
         n93, n95, n102, n103, n105, n106, n107, n110, n111, n1130, n1150,
         n117, n118, n120, n122, n123, n125, n126, n128, n129, n131, n132,
         n1350, n136, n137, n138, n140, n141, n142, n143, n145, n146, n152,
         n154, n157, n158, n159, n161, n162, n163, n165, n166, n167, n169,
         n170, n171, n172, n173, n174, n175, n176, n177, n178, n179, n180,
         n181, n182, n183, n184, n189, n190, n192, n193, n196, n197, n198,
         n199, n200, n201, n202, n203, n204, n205, n206, n207, n208, n209,
         n210, n211, n212, n213, n214, n215, n216, n217, n218, n219, n220,
         n221, n222, n223, n224, n225, n226, n227, n228, n229, n230, n231,
         n232, n233, n7, n9, n11, n13, n16, n17, n21, n22, n24, n26, n28, n30,
         n32, n35, n37, n41, n48, n71, n79, n85, n87, n90, n92, n96, n98, n100,
         n104, n109, n1140, n119, n124, n130, n139, n144, n147, n148, n149,
         n151, n155, n156, n160, n164, n168, n185, n187, n188, n191, n194,
         n195, n234, n235, n236, n237, n238, n239, n240, n241, n243, n244,
         n245, n246, n247, n248, n249, n258, n259, n261, n262, n263, n265,
         n266, n267, n268, n269, n270, n271, n272, n273, n274, n275, n276,
         n277, n278, n279, n280, n281, n282, n283, n284, n285, n286, n287,
         n288, n289, n290, n291, n292, n293, n294, n295, n296, n297, n298,
         n299, n300, n301, n324, n325, n326, n327, n328, n329, n330;

  SEH_OAI32_4 U159 ( .A1(n120), .A2(mst_state1), .A3(n122), .B1(n194), .B2(
        n123), .X(mst_next3) );
  SEH_FDPQ_V2_1 spi_trn_cap_sync_reg1 ( .D(spi_trn_cap_sync0), .CK(sb_clk_i), 
        .Q(spi_trn_cap_sync1) );
  SEH_FDPQ_V2_1 spi_tip_sync_reg ( .D(n234), .CK(sb_clk_i), .Q(spisr[7]) );
  SEH_FDPQ_V2_1 spi_busy_sync_reg ( .D(n155), .CK(sb_clk_i), .Q(spisr[6]) );
  SEH_FDPQ_V2_1 spi_trn_cap_sync_reg0 ( .D(spi_trn_cap), .CK(sb_clk_i), .Q(
        spi_trn_cap_sync0) );
  SEH_FDPQ_V2_1 spi_trn_nb_cap_sync_reg1 ( .D(spi_trn_nb_cap_sync0), .CK(
        sb_clk_i), .Q(spi_trn_nb_cap_sync1) );
  SEH_FDPQ_V2_1 spi_trn_nb_cap_sync_reg0 ( .D(spi_trn_cap_nb), .CK(sb_clk_i), 
        .Q(spi_trn_nb_cap_sync0) );
  SEH_FDPQB_V2_2 spi_rcv_upd_sync_reg1 ( .D(spi_rcv_upd_sync0), .CK(sb_clk_i), 
        .QN(n193) );
  SEH_FDPCBQ_1 spi_rcv_upd_sync_reg0 ( .D(n235), .RS(rcv_rdy), .CK(sb_clk_i), 
        .Q(spi_rcv_upd_sync0) );
  SEH_FDPRBQ_V2_1P5 spi_mhld_act_reg ( .D(n229), .CK(sck_tcv_early), .RD(n155), 
        .Q(spi_mhld_act) );
  SEH_FDPQ_V2_1 byte_bndy_sync_reg0 ( .D(spi_mhld_act), .CK(sb_clk_i), .Q(
        byte_bndy_sync0) );
  SEH_FDPQ_V2_1 byte_bndy_sync_reg1 ( .D(byte_bndy_sync0), .CK(sb_clk_i), .Q(
        byte_bndy_sync1) );
  SEH_FDPRBQ_V2_1P5 spi_rrdy_sample_reg ( .D(n179), .CK(sck_tcv_fin), .RD(n155), .Q(spi_rrdy_sample) );
  SEH_FDNQ_1 byte_bndy_nd_sync_reg1 ( .D(byte_bndy_nd_sync0), .CK(sb_clk_i), 
        .Q(byte_bndy_nd_sync1) );
  SEH_FDNQ_1 byte_bndy_nd_sync_reg0 ( .D(byte_bndy_nd), .CK(sb_clk_i), .Q(
        byte_bndy_nd_sync0) );
  SEH_FDPSBQ_1 spi_trdy_srmok_reg ( .D(n181), .CK(sck_tcv_fin), .SD(n155), .Q(
        spi_trdy_srmok) );
  SEH_FDPQ_V2_1 rcv_reg_reg7 ( .D(n203), .CK(sck_tcv_fin), .Q(spirxdr[7]) );
  SEH_FDPQ_V2_1 rcv_reg_reg6 ( .D(n202), .CK(sck_tcv_fin), .Q(spirxdr[6]) );
  SEH_FDPQ_V2_1 rcv_reg_reg5 ( .D(n201), .CK(sck_tcv_fin), .Q(spirxdr[5]) );
  SEH_FDPQ_V2_1 rcv_reg_reg4 ( .D(n200), .CK(sck_tcv_fin), .Q(spirxdr[4]) );
  SEH_FDPQ_V2_1 rcv_reg_reg3 ( .D(n199), .CK(sck_tcv_fin), .Q(spirxdr[3]) );
  SEH_FDPQ_V2_1 rcv_reg_reg2 ( .D(n198), .CK(sck_tcv_fin), .Q(spirxdr[2]) );
  SEH_FDPQ_V2_1 rcv_reg_reg1 ( .D(n197), .CK(sck_tcv_fin), .Q(spirxdr[1]) );
  SEH_FDPQ_V2_1 rcv_reg_reg0 ( .D(n196), .CK(sck_tcv_fin), .Q(spirxdr[0]) );
  SEH_FDPRBQ_V2_1P5 rcv_rdy_reg ( .D(n180), .CK(sck_tcv_fin), .RD(n155), .Q(
        rcv_rdy) );
  SEH_FDPSBQ_1 mcsn_o_reg7 ( .D(n233), .CK(sb_clk_i), .SD(n191), .Q(n307) );
  SEH_FDPSBQ_1 mcsn_o_reg6 ( .D(n221), .CK(sb_clk_i), .SD(n191), .Q(n308) );
  SEH_FDPSBQ_1 mcsn_o_reg5 ( .D(n222), .CK(sb_clk_i), .SD(n191), .Q(n309) );
  SEH_FDPSBQ_1 mcsn_o_reg4 ( .D(n223), .CK(sb_clk_i), .SD(n330), .Q(n310) );
  SEH_FDPSBQ_1 mcsn_o_reg3 ( .D(n224), .CK(sb_clk_i), .SD(n330), .Q(n311) );
  SEH_FDPSBQ_1 mcsn_o_reg2 ( .D(n225), .CK(sb_clk_i), .SD(n191), .Q(n312) );
  SEH_FDPSBQ_1 mcsn_o_reg1 ( .D(n226), .CK(sb_clk_i), .SD(n191), .Q(n313) );
  SEH_FDPSBQ_1 mcsn_o_reg0 ( .D(n227), .CK(sb_clk_i), .SD(n191), .Q(n314) );
  SEH_FDPRBSBQ_1 tcv_reg_reg7 ( .D(n212), .CK(sck_tcv_fin), .RD(n177), .SD(
        n178), .Q(tcv_reg7) );
  SEH_FDPRBSBQ_1 tcv_reg_reg0 ( .D(n211), .CK(sck_tcv_fin), .RD(n175), .SD(
        n176), .Q(tcv_reg0) );
  SEH_FDPSBQ_1 byte_bndy_early_reg ( .D(N135), .CK(sck_tcv_early), .SD(n155), 
        .Q(byte_bndy_early) );
  SEH_FDPSBQ_1 tcv_cnt_reg0 ( .D(n232), .CK(sck_tcv_fin), .SD(n155), .Q(
        tcv_cnt0) );
  SEH_FDPSBQ_1 tcv_cnt_reg1 ( .D(n231), .CK(sck_tcv_fin), .SD(n155), .Q(
        tcv_cnt1) );
  SEH_FDPSBQ_1 tcv_cnt_reg2 ( .D(n230), .CK(sck_tcv_fin), .SD(n155), .Q(
        tcv_cnt2) );
  SEH_FDPSBQ_1 tcv_reg_reg4 ( .D(n207), .CK(sck_tcv_fin), .SD(n155), .Q(
        tcv_reg4) );
  SEH_FDPSBQ_1 tcv_reg_reg3 ( .D(n208), .CK(sck_tcv_fin), .SD(n155), .Q(
        tcv_reg3) );
  SEH_FDPSBQ_1 tcv_reg_reg5 ( .D(n206), .CK(sck_tcv_fin), .SD(n155), .Q(
        tcv_reg5) );
  SEH_FDPSBQ_1 tcv_reg_reg1 ( .D(n210), .CK(sck_tcv_fin), .SD(n155), .Q(
        tcv_reg1) );
  SEH_FDPSBQ_1 tcv_reg_reg2 ( .D(n209), .CK(sck_tcv_fin), .SD(n155), .Q(
        tcv_reg2) );
  SEH_FDPSBQ_1 tcv_reg_reg6 ( .D(n205), .CK(sck_tcv_fin), .SD(n155), .Q(
        tcv_reg6) );
  SEH_FDNRBSBQ_1 byte_bndy_nd_reg ( .D(byte_bndy_early), .CK(sck_tcv_early), 
        .RD(Logic1), .SD(n155), .Q(byte_bndy_nd) );
  SEH_MUX2_0P5 byte_bndy_regU5 ( .D0(n22), .D1(byte_bndy), .S(n288), .X(n144)
         );
  SEH_FDPSBQ_1 byte_bndy_reg ( .D(n144), .CK(sck_tcv_fin), .SD(n155), .Q(
        byte_bndy) );
  SEH_MUX2_0P5 spi_trdy_sample_regU5 ( .D0(spisr[4]), .D1(spi_trdy_sample), 
        .S(n184), .X(n139) );
  SEH_FDPRBSBQ_1 spi_trdy_sample_reg ( .D(n139), .CK(sck_tcv_fin), .RD(n182), 
        .SD(n183), .Q(spi_trdy_sample) );
  SEH_OA41_1 U16 ( .A1(n149), .A2(n11), .A3(n243), .A4(n158), .B(n167), .X(n7)
         );
  SEH_INV_S_1 U17 ( .A(n7), .X(n163) );
  SEH_INV_S_1 U18 ( .A(n95), .X(n243) );
  SEH_AN4_1 U19 ( .A1(n247), .A2(n246), .A3(mst_state2), .A4(mst_state0), .X(
        n9) );
  SEH_INV_S_1 U20 ( .A(n9), .X(n128) );
  SEH_OR3_1 U21 ( .A1(dly_cnt2), .A2(dly_cnt3), .A3(n17), .X(n122) );
  SEH_INV_S_2 U23 ( .A(n11), .X(n93) );
  SEH_INV_S_1 U24 ( .A(mst_state3), .X(n246) );
  SEH_AO221_0P5 U25 ( .A1(n118), .A2(n290), .B1(n13), .B2(n16), .C(spi_master), 
        .X(n67) );
  SEH_INV_S_1 U27 ( .A(spi_trdy_sample), .X(n13) );
  SEH_INV_S_1 U28 ( .A(n4), .X(n16) );
  SEH_OR3_1 U29 ( .A1(n195), .A2(dly_cnt0), .A3(dly_cnt1), .X(n17) );
  SEH_INV_S_1 U30 ( .A(n17), .X(n157) );
  SEH_ND4_S_1 U32 ( .A1(n307), .A2(n308), .A3(n309), .A4(n310), .X(n26) );
  SEH_OAO211_DG_1 U33 ( .A1(n263), .A2(n1350), .B(n9), .C(n190), .X(n21) );
  SEH_ND4_S_1 U35 ( .A1(n311), .A2(n312), .A3(n313), .A4(n314), .X(n24) );
  SEH_NR2_T_0P5 U36 ( .A1(n149), .A2(n243), .X(n125) );
  SEH_AOI21_T_0P5 U37 ( .A1(n54), .A2(n292), .B(n45), .X(n53) );
  SEH_AOI31_G_1 U38 ( .A1(spisr[3]), .A2(spi_rcv_upd_sync0), .A3(n193), .B(n74), .X(n75) );
  SEH_AN3_1 U39 ( .A1(n261), .A2(tcv_cnt1), .A3(tcv_cnt2), .X(n22) );
  SEH_INV_S_1 U40 ( .A(n22), .X(n184) );
  SEH_OAI2111_2 U41 ( .A1(n247), .A2(n122), .B1(n140), .B2(n141), .B3(n142), 
        .X(mst_next0) );
  SEH_INV_S_1 U42 ( .A(mst_state1), .X(n247) );
  SEH_OAI221_1 U43 ( .A1(n282), .A2(n188), .B1(n38), .B2(n39), .C(n185), .X(
        n204) );
  SEH_AOI22_0P75 U44 ( .A1(n1130), .A2(n3), .B1(n235), .B2(n5), .X(n111) );
  SEH_NR2_S_1 U45 ( .A1(n3), .A2(n4), .X(spi_trn_cap_nb) );
  SEH_NR2_T_1 U46 ( .A1(n72), .A2(n73), .X(n70) );
  SEH_INV_S_1 U47 ( .A(n1350), .X(n283) );
  SEH_NR4_4 U48 ( .A1(spicr2_wt), .A2(spicr1_wt), .A3(spicr0_wt), .A4(spibr_wt), .X(n136) );
  SEH_OAI22_2 U49 ( .A1(spicr2[0]), .A2(n266), .B1(n265), .B2(n292), .X(n5) );
  SEH_OR2_1 U50 ( .A1(n24), .A2(n26), .X(n14) );
  SEH_OA311_1 U51 ( .A1(n262), .A2(spi_trn_nb_cap_sync0), .A3(n269), .B1(n284), 
        .B2(n283), .X(n28) );
  SEH_INV_S_1 U52 ( .A(n28), .X(n84) );
  SEH_INV_S_12 U54 ( .A(n96), .X(miso_oe) );
  SEH_AO32_0P5 U55 ( .A1(n70), .A2(spicr1[7]), .A3(n1), .B1(n188), .B2(n72), 
        .X(n306) );
  SEH_OAI22_2 U56 ( .A1(trn_reg), .A2(spicr1[4]), .B1(n111), .B2(n289), .X(
        n110) );
  SEH_AO32_0P5 U57 ( .A1(n70), .A2(spicr1[7]), .A3(n14), .B1(n188), .B2(n73), 
        .X(n304) );
  SEH_ND3_T_0P8 U58 ( .A1(n1150), .A2(n272), .A3(spi_trdy_sample), .X(n66) );
  SEH_OAI221_1 U59 ( .A1(spi_rrdy_sample), .A2(n290), .B1(spicr1[3]), .B2(n117), .C(n118), .X(n1150) );
  SEH_NR2B_V1DG_3 U60 ( .A(n67), .B(n3), .X(n55) );
  SEH_AN4B_2 U61 ( .B1(n148), .B2(n136), .B3(n137), .A(n138), .X(n190) );
  SEH_ND2B_1 U62 ( .A(spicsr_wt), .B(n136), .X(n1350) );
  SEH_ND2_G_1 U64 ( .A1(n3), .A2(n156), .X(n43) );
  SEH_NR2_S_3 U65 ( .A1(n66), .A2(n3), .X(n45) );
  SEH_AOI221_2 U66 ( .A1(spitxdr[6]), .A2(n55), .B1(n238), .B2(tcv_reg6), .C(
        n45), .X(n49) );
  SEH_ND3_3 U67 ( .A1(n241), .A2(n246), .A3(mst_state2), .X(n120) );
  SEH_INV_S_1 U68 ( .A(spisr[4]), .X(n263) );
  SEH_NR2_S_1 U69 ( .A1(n270), .A2(n118), .X(n4) );
  SEH_ND2_G_1 U70 ( .A1(n306), .A2(n110), .X(n305) );
  SEH_ND2_G_1 U71 ( .A1(n304), .A2(n110), .X(n303) );
  SEH_OAI2111_2 U72 ( .A1(n293), .A2(n93), .B1(n125), .B2(n120), .B3(n126), 
        .X(n189) );
  SEH_OR4_1 U74 ( .A1(mst_next0), .A2(mst_next1), .A3(n189), .A4(mst_next3), 
        .X(n30) );
  SEH_INV_S_2 U75 ( .A(n314), .X(n98) );
  SEH_INV_S_2 U76 ( .A(n313), .X(n100) );
  SEH_INV_S_2 U77 ( .A(n312), .X(n104) );
  SEH_INV_S_2 U78 ( .A(n311), .X(n109) );
  SEH_INV_S_2 U79 ( .A(n310), .X(n1140) );
  SEH_INV_S_2 U80 ( .A(n309), .X(n119) );
  SEH_INV_S_2 U81 ( .A(n308), .X(n124) );
  SEH_INV_S_2 U82 ( .A(n307), .X(n130) );
  SEH_AN2_S_1 U83 ( .A1(spicr1[6]), .A2(n1), .X(spi_wkup) );
  SEH_INV_S_2 U84 ( .A(n319), .X(n35) );
  SEH_INV_S_10 U85 ( .A(n35), .X(mcsn_oe[3]) );
  SEH_INV_S_1 U86 ( .A(n311), .X(n319) );
  SEH_INV_S_2 U87 ( .A(n320), .X(n37) );
  SEH_INV_S_10 U88 ( .A(n37), .X(mcsn_oe[2]) );
  SEH_INV_S_1 U89 ( .A(n312), .X(n320) );
  SEH_INV_S_2 U90 ( .A(n321), .X(n41) );
  SEH_INV_S_10 U91 ( .A(n41), .X(mcsn_oe[1]) );
  SEH_INV_S_1 U92 ( .A(n313), .X(n321) );
  SEH_INV_S_2 U93 ( .A(n322), .X(n48) );
  SEH_INV_S_10 U94 ( .A(n48), .X(mcsn_oe[0]) );
  SEH_INV_S_1 U95 ( .A(n314), .X(n322) );
  SEH_INV_S_2 U96 ( .A(n315), .X(n71) );
  SEH_INV_S_10 U97 ( .A(n71), .X(mcsn_oe[7]) );
  SEH_INV_S_1 U98 ( .A(n307), .X(n315) );
  SEH_INV_S_2 U99 ( .A(n316), .X(n79) );
  SEH_INV_S_10 U100 ( .A(n79), .X(mcsn_oe[6]) );
  SEH_INV_S_1 U101 ( .A(n308), .X(n316) );
  SEH_INV_S_2 U102 ( .A(n317), .X(n85) );
  SEH_INV_S_10 U103 ( .A(n85), .X(mcsn_oe[5]) );
  SEH_INV_S_1 U104 ( .A(n309), .X(n317) );
  SEH_INV_S_2 U105 ( .A(n318), .X(n87) );
  SEH_INV_S_10 U106 ( .A(n87), .X(mcsn_oe[4]) );
  SEH_INV_S_1 U107 ( .A(n310), .X(n318) );
  SEH_INV_S_1 U108 ( .A(mst_state2), .X(n258) );
  SEH_NR3_2 U109 ( .A1(mst_state1), .A2(mst_state2), .A3(n241), .X(n80) );
  SEH_INV_S_2 U110 ( .A(n305), .X(n90) );
  SEH_INV_S_10 U111 ( .A(n90), .X(miso_o) );
  SEH_INV_S_2 U112 ( .A(n303), .X(n92) );
  SEH_INV_S_10 U113 ( .A(n92), .X(mosi_o) );
  SEH_INV_S_2 U114 ( .A(n306), .X(n96) );
  SEH_AOI32_1 U115 ( .A1(n131), .A2(n241), .A3(mst_state1), .B1(mst_state0), 
        .B2(n258), .X(n132) );
  SEH_ND2_G_1 U117 ( .A1(n3), .A2(n156), .X(n147) );
  SEH_OAI221_1 U118 ( .A1(spicr2[0]), .A2(n60), .B1(n280), .B2(n147), .C(n61), 
        .X(n210) );
  SEH_AOI22_S_0P5 U119 ( .A1(n238), .A2(tcv_reg0), .B1(n235), .B2(n265), .X(
        n60) );
  SEH_OAI221_1 U120 ( .A1(n279), .A2(n43), .B1(spicr2[0]), .B2(n58), .C(n59), 
        .X(n209) );
  SEH_OAI221_1 U121 ( .A1(n42), .A2(n292), .B1(n275), .B2(n43), .C(n44), .X(
        n205) );
  SEH_AOI22_1 U122 ( .A1(n238), .A2(tcv_reg7), .B1(n235), .B2(n266), .X(n42)
         );
  SEH_INV_S_1P5 U123 ( .A(n156), .X(n238) );
  SEH_INV_S_1 U125 ( .A(n129), .X(n148) );
  SEH_INV_S_1 U126 ( .A(n129), .X(n149) );
  SEH_AOI222_2 U127 ( .A1(spicr0[4]), .A2(n149), .B1(dly_cnt1), .B2(n163), 
        .C1(spicr0[7]), .C2(n243), .X(n166) );
  SEH_AOI222_2 U129 ( .A1(spicr0[0]), .A2(n240), .B1(spicr0[6]), .B2(n243), 
        .C1(spicr0[3]), .C2(n148), .X(n170) );
  SEH_INV_S_0P65 U130 ( .A(n3), .X(n235) );
  SEH_INV_10 U131 ( .A(n259), .X(mclk_oe) );
  SEH_INV_2 U132 ( .A(n302), .X(n259) );
  SEH_INV_2 U133 ( .A(n304), .X(n151) );
  SEH_INV_10 U134 ( .A(n151), .X(mosi_oe) );
  SEH_OR2_1 U137 ( .A1(n3), .A2(n5), .X(n185) );
  SEH_OR2_DG_4 U138 ( .A1(n14), .A2(n1), .X(n155) );
  SEH_AOI22_1 U139 ( .A1(tcv_reg7), .A2(n292), .B1(tcv_reg0), .B2(spicr2[0]), 
        .X(n38) );
  SEH_ND2_G_1 U140 ( .A1(n188), .A2(n3), .X(n39) );
  SEH_NR2_S_3 U141 ( .A1(n14), .A2(n1), .X(n6) );
  SEH_ND2_0P8 U142 ( .A1(n188), .A2(n3), .X(n156) );
  SEH_AOI21_S_1 U143 ( .A1(spitxdr[7]), .A2(n67), .B(n267), .X(n10) );
  SEH_AOI21_S_1 U144 ( .A1(spitxdr[0]), .A2(n67), .B(n267), .X(n8) );
  SEH_INV_S_1 U145 ( .A(n8), .X(n265) );
  SEH_INV_S_1 U146 ( .A(n10), .X(n266) );
  SEH_AOI21B_3 U147 ( .A1(n120), .A2(n82), .B(hlf_cyc), .X(n158) );
  SEH_ND2_G_1 U148 ( .A1(n172), .A2(n258), .X(n82) );
  SEH_INV_S_1 U158 ( .A(spicr2[7]), .X(n291) );
  SEH_INV_S_1 U161 ( .A(spi_master), .X(n272) );
  SEH_ND2_G_1 U162 ( .A1(spicr2[5]), .A2(n291), .X(n118) );
  SEH_INV_S_1 U163 ( .A(spi_trdy_srmok), .X(n270) );
  SEH_NR2B_2 U164 ( .A(spicr1[1]), .B(spicr1[0]), .X(n72) );
  SEH_AOI22_1 U165 ( .A1(n238), .A2(tcv_reg4), .B1(spitxdr[4]), .B2(n55), .X(
        n52) );
  SEH_AOI22_1 U166 ( .A1(n238), .A2(tcv_reg5), .B1(spitxdr[5]), .B2(n55), .X(
        n47) );
  SEH_NR2B_2 U167 ( .A(spicr1[0]), .B(spicr1[1]), .X(n73) );
  SEH_INV_S_2 U168 ( .A(spicr2[0]), .X(n292) );
  SEH_ND2_T_1 U169 ( .A1(n155), .A2(spicr1[7]), .X(n63) );
  SEH_ND2_2 U170 ( .A1(rcv_rdy), .A2(n249), .X(n20) );
  SEH_ND2_G_1 U171 ( .A1(n68), .A2(n69), .X(n64) );
  SEH_AOAI211_0P75 U172 ( .A1(spi_master), .A2(n70), .B(n73), .C(miso_i), .X(
        n68) );
  SEH_AOAI211_0P75 U173 ( .A1(n70), .A2(n272), .B(n72), .C(mosi_i), .X(n69) );
  SEH_AO22_DG_1 U174 ( .A1(n238), .A2(tcv_reg2), .B1(spitxdr[2]), .B2(n55), 
        .X(n57) );
  SEH_AO22_DG_1 U175 ( .A1(n238), .A2(tcv_reg3), .B1(spitxdr[3]), .B2(n55), 
        .X(n54) );
  SEH_ND2_T_1 U176 ( .A1(mst_state3), .A2(n247), .X(n123) );
  SEH_INV_S_1 U177 ( .A(spicr1[7]), .X(n288) );
  SEH_NR2_T_1 U178 ( .A1(n123), .A2(mst_state0), .X(n172) );
  SEH_ND2_2 U179 ( .A1(n172), .A2(mst_state2), .X(n95) );
  SEH_ND2_G_1 U180 ( .A1(spicr1[4]), .A2(n240), .X(n154) );
  SEH_INV_S_1 U181 ( .A(tcv_cnt0), .X(n261) );
  SEH_INV_S_1 U182 ( .A(dly_cnt2), .X(n244) );
  SEH_INV_S_1 U183 ( .A(spicsr[3]), .X(n298) );
  SEH_INV_S_1 U184 ( .A(spicsr[7]), .X(n294) );
  SEH_INV_S_1 U185 ( .A(spicsr[1]), .X(n300) );
  SEH_INV_S_1 U186 ( .A(spicsr[5]), .X(n296) );
  SEH_INV_S_1 U187 ( .A(spicsr[2]), .X(n299) );
  SEH_INV_S_1 U188 ( .A(spicsr[0]), .X(n301) );
  SEH_INV_S_1 U189 ( .A(spicsr[6]), .X(n295) );
  SEH_INV_S_1 U190 ( .A(spicsr[4]), .X(n297) );
  SEH_INV_S_1 U191 ( .A(tcv_reg6), .X(n275) );
  SEH_INV_S_1 U192 ( .A(tcv_reg5), .X(n276) );
  SEH_INV_S_1 U193 ( .A(tcv_reg4), .X(n277) );
  SEH_INV_S_1 U194 ( .A(tcv_reg1), .X(n280) );
  SEH_INV_S_1 U196 ( .A(tcv_reg3), .X(n278) );
  SEH_INV_S_1 U197 ( .A(tcv_reg2), .X(n279) );
  SEH_EO2_G_1 U198 ( .A1(spicr2[1]), .A2(spicr2[2]), .X(spi_port_sck_tcv_inv)
         );
  SEH_ND3_1 U199 ( .A1(spicr1[2]), .A2(spicr1[7]), .A3(spicr2[7]), .X(n164) );
  SEH_INV_S_1 U200 ( .A(spitxdr_wt), .X(n284) );
  SEH_INV_S_1 U201 ( .A(n105), .X(n249) );
  SEH_INV_S_1 U202 ( .A(n158), .X(n195) );
  SEH_ND2B_1 U203 ( .A(n82), .B(n194), .X(n78) );
  SEH_INV_S_1 U204 ( .A(n122), .X(n194) );
  SEH_INV_S_1 U205 ( .A(n14), .X(n192) );
  SEH_ND2_G_1 U206 ( .A1(n265), .A2(n6), .X(n176) );
  SEH_ND2_G_1 U207 ( .A1(n266), .A2(n6), .X(n178) );
  SEH_ND3B_V1DG_1 U208 ( .A(n190), .B1(n120), .B2(n82), .X(mclk_run) );
  SEH_INV_S_1 U209 ( .A(n66), .X(n267) );
  SEH_ND2_2 U210 ( .A1(n248), .A2(n292), .X(n18) );
  SEH_OAI221_1 U211 ( .A1(n52), .A2(n292), .B1(n278), .B2(n147), .C(n56), .X(
        n208) );
  SEH_AOI21_S_1 U212 ( .A1(n57), .A2(n292), .B(n45), .X(n56) );
  SEH_OAI221_1 U213 ( .A1(n47), .A2(n292), .B1(n277), .B2(n147), .C(n53), .X(
        n207) );
  SEH_OAI221_1 U214 ( .A1(n276), .A2(n43), .B1(n49), .B2(n292), .C(n50), .X(
        n206) );
  SEH_OAI21_G_1 U215 ( .A1(n45), .A2(n236), .B(n292), .X(n50) );
  SEH_INV_S_1 U216 ( .A(n52), .X(n236) );
  SEH_ND2_G_1 U217 ( .A1(n188), .A2(n22), .X(n105) );
  SEH_INV_S_1 U218 ( .A(n20), .X(n248) );
  SEH_INV_S_1 U219 ( .A(n64), .X(n271) );
  SEH_NR2_G_1 U220 ( .A1(n261), .A2(n63), .X(n107) );
  SEH_EO2_G_1 U221 ( .A1(n261), .A2(n63), .X(n232) );
  SEH_OAI21_G_1 U222 ( .A1(n234), .A2(n188), .B(n105), .X(N135) );
  SEH_INV_S_2 U223 ( .A(n93), .X(n240) );
  SEH_OAI221_1 U224 ( .A1(n294), .A2(n93), .B1(n130), .B2(n240), .C(n95), .X(
        n233) );
  SEH_OAI221_1 U225 ( .A1(n301), .A2(n93), .B1(n98), .B2(n240), .C(n95), .X(
        n227) );
  SEH_OAI221_1 U226 ( .A1(n300), .A2(n93), .B1(n100), .B2(n240), .C(n95), .X(
        n226) );
  SEH_OAI221_1 U227 ( .A1(n299), .A2(n93), .B1(n104), .B2(n240), .C(n95), .X(
        n225) );
  SEH_OAI221_1 U228 ( .A1(n298), .A2(n93), .B1(n109), .B2(n240), .C(n95), .X(
        n224) );
  SEH_OAI221_1 U229 ( .A1(n297), .A2(n93), .B1(n1140), .B2(n240), .C(n95), .X(
        n223) );
  SEH_OAI221_1 U230 ( .A1(n296), .A2(n93), .B1(n119), .B2(n240), .C(n95), .X(
        n222) );
  SEH_OAI221_1 U231 ( .A1(n295), .A2(n93), .B1(n124), .B2(n240), .C(n95), .X(
        n221) );
  SEH_OR4_1 U234 ( .A1(n301), .A2(n300), .A3(n299), .A4(n298), .X(n187) );
  SEH_ND2_G_1 U235 ( .A1(n80), .A2(n246), .X(n81) );
  SEH_OAI22_S_1 U237 ( .A1(n184), .A2(n13), .B1(n22), .B2(n270), .X(n181) );
  SEH_ND2_G_1 U238 ( .A1(n6), .A2(n263), .X(n182) );
  SEH_ND2_G_1 U239 ( .A1(n5), .A2(n6), .X(n173) );
  SEH_ND2B_1 U240 ( .A(n5), .B(n6), .X(n174) );
  SEH_ND2_G_1 U241 ( .A1(n8), .A2(n6), .X(n175) );
  SEH_ND2_G_1 U242 ( .A1(n10), .A2(n6), .X(n177) );
  SEH_OAI22_S_1 U243 ( .A1(tcv_reg0), .A2(n292), .B1(tcv_reg7), .B2(spicr2[0]), 
        .X(n1130) );
  SEH_INV_S_1 U244 ( .A(trn_reg), .X(n282) );
  SEH_INV_S_1 U246 ( .A(byte_bndy_nd_sync1), .X(n239) );
  SEH_ND2B_1 U247 ( .A(n123), .B(mst_state2), .X(n141) );
  SEH_OA311_1 U248 ( .A1(mst_state3), .A2(mst_state2), .A3(n143), .B1(n81), 
        .B2(n128), .X(n142) );
  SEH_AOAI211_1 U249 ( .A1(n136), .A2(n137), .B(n138), .C(n149), .X(n140) );
  SEH_ND2B_1 U250 ( .A(spirxdr_rd), .B(n283), .X(n74) );
  SEH_INV_S_1 U251 ( .A(n117), .X(n290) );
  SEH_AO2BB2_DG_1 U252 ( .A1(n74), .A2(n75), .B1(spisr[1]), .B2(n75), .X(n213)
         );
  SEH_OAI22_S_1 U253 ( .A1(n269), .A2(n89), .B1(spi_trdy_sample_sense1), .B2(
        n268), .X(n220) );
  SEH_AO22_DG_1 U254 ( .A1(n9), .A2(spitxdr_wt), .B1(n268), .B2(
        spi_trdy_sample_sense1), .X(n89) );
  SEH_INV_S_1 U255 ( .A(spi_trdy_sample_sense0), .X(n268) );
  SEH_AOAI211_G_1 U257 ( .A1(n263), .A2(n102), .B(spitxdr_wt), .C(n283), .X(
        n228) );
  SEH_ND2B_1 U258 ( .A(spi_trn_cap_sync0), .B(spi_trn_cap_sync1), .X(n102) );
  SEH_AOA211_DG_1 U259 ( .A1(spi_master), .A2(n1), .B(spisr[0]), .C(n283), .X(
        n215) );
  SEH_AO32_0P5 U260 ( .A1(n84), .A2(n284), .A3(n283), .B1(spisr[2]), .B2(n28), 
        .X(n219) );
  SEH_INV_S_1 U261 ( .A(spi_trn_nb_cap_sync1), .X(n262) );
  SEH_AO22_DG_1 U262 ( .A1(spi_master), .A2(spicsr_wt), .B1(n78), .B2(
        spi_mfin_sync), .X(n216) );
  SEH_AOI221_2 U263 ( .A1(spitxdr[1]), .A2(n55), .B1(n238), .B2(tcv_reg1), .C(
        n45), .X(n58) );
  SEH_ND2_2 U264 ( .A1(n248), .A2(spicr2[0]), .X(n15) );
  SEH_OAI21_G_1 U265 ( .A1(n45), .A2(n57), .B(spicr2[0]), .X(n61) );
  SEH_OAI21_S_1 U266 ( .A1(n45), .A2(n54), .B(spicr2[0]), .X(n59) );
  SEH_OAI221_1 U267 ( .A1(n15), .A2(n280), .B1(n271), .B2(n18), .C(n19), .X(
        n196) );
  SEH_ND2_G_1 U268 ( .A1(spirxdr[0]), .A2(n20), .X(n19) );
  SEH_OAI221_1 U269 ( .A1(n15), .A2(n279), .B1(n18), .B2(n281), .C(n23), .X(
        n197) );
  SEH_ND2_G_1 U270 ( .A1(spirxdr[1]), .A2(n20), .X(n23) );
  SEH_OAI221_1 U271 ( .A1(n15), .A2(n278), .B1(n280), .B2(n18), .C(n25), .X(
        n198) );
  SEH_ND2_G_1 U272 ( .A1(spirxdr[2]), .A2(n20), .X(n25) );
  SEH_OAI221_1 U273 ( .A1(n15), .A2(n277), .B1(n18), .B2(n279), .C(n27), .X(
        n199) );
  SEH_ND2_G_1 U274 ( .A1(spirxdr[3]), .A2(n20), .X(n27) );
  SEH_OAI221_1 U275 ( .A1(n15), .A2(n276), .B1(n18), .B2(n278), .C(n29), .X(
        n200) );
  SEH_ND2_G_1 U276 ( .A1(spirxdr[4]), .A2(n20), .X(n29) );
  SEH_OAI221_1 U277 ( .A1(n15), .A2(n275), .B1(n18), .B2(n277), .C(n31), .X(
        n201) );
  SEH_ND2_G_1 U278 ( .A1(spirxdr[5]), .A2(n20), .X(n31) );
  SEH_OAI221_1 U279 ( .A1(n15), .A2(n274), .B1(n18), .B2(n276), .C(n33), .X(
        n202) );
  SEH_ND2_G_1 U280 ( .A1(spirxdr[6]), .A2(n20), .X(n33) );
  SEH_OAI21_0P75 U281 ( .A1(n45), .A2(n237), .B(n292), .X(n44) );
  SEH_INV_S_1 U282 ( .A(n47), .X(n237) );
  SEH_OAI221_1 U283 ( .A1(n271), .A2(n15), .B1(n18), .B2(n275), .C(n34), .X(
        n203) );
  SEH_ND2_G_1 U284 ( .A1(spirxdr[7]), .A2(n20), .X(n34) );
  SEH_OAI22_S_1 U285 ( .A1(n188), .A2(n274), .B1(n65), .B2(n63), .X(n212) );
  SEH_OA2BB2_0P5 U286 ( .A1(spicr2[0]), .A2(n64), .B1(n49), .B2(spicr2[0]), 
        .X(n65) );
  SEH_OAI22_S_1 U287 ( .A1(n188), .A2(n281), .B1(n62), .B2(n63), .X(n211) );
  SEH_OA22_DG_1 U288 ( .A1(n271), .A2(spicr2[0]), .B1(n292), .B2(n58), .X(n62)
         );
  SEH_AO32_0P5 U289 ( .A1(spicr2[6]), .A2(n249), .A3(n103), .B1(spi_mhld_act), 
        .B2(n63), .X(n229) );
  SEH_NR2_G_1 U290 ( .A1(n291), .A2(n263), .X(n103) );
  SEH_OA21_1 U291 ( .A1(n13), .A2(spi_mhld_act), .B(spi_trn_cap_nb), .X(
        spi_trn_cap) );
  SEH_EO2_G_1 U292 ( .A1(tcv_cnt1), .A2(n107), .X(n231) );
  SEH_INV_S_1 U293 ( .A(spicr1[4]), .X(n289) );
  SEH_EN2_G_1 U294 ( .A1(tcv_cnt2), .A2(n106), .X(n230) );
  SEH_ND2_G_1 U295 ( .A1(n107), .A2(tcv_cnt1), .X(n106) );
  SEH_ND2_G_1 U296 ( .A1(dly_cnt0), .A2(n158), .X(n167) );
  SEH_OAI2111_1 U297 ( .A1(dly_cnt0), .A2(n195), .B1(n169), .B2(n154), .B3(
        n170), .X(N113) );
  SEH_NR2B_1 U299 ( .A(dly_cnt0), .B(n158), .X(n171) );
  SEH_OAI221_1 U300 ( .A1(n152), .A2(n245), .B1(n154), .B2(n285), .C(n122), 
        .X(N116) );
  SEH_INV_S_1 U301 ( .A(spicr0[2]), .X(n285) );
  SEH_AOI21_S_0P5 U302 ( .A1(dly_cnt2), .A2(n158), .B(n159), .X(n152) );
  SEH_OAI211_1 U303 ( .A1(n154), .A2(n286), .B1(n161), .B2(n162), .X(N115) );
  SEH_INV_S_1 U304 ( .A(spicr0[1]), .X(n286) );
  SEH_AOI32_1 U305 ( .A1(n240), .A2(n289), .A3(spicr0[2]), .B1(n157), .B2(n244), .X(n161) );
  SEH_AOI22_S_0P5 U306 ( .A1(dly_cnt2), .A2(n159), .B1(spicr0[5]), .B2(n148), 
        .X(n162) );
  SEH_OAI211_1 U307 ( .A1(n154), .A2(n287), .B1(n165), .B2(n166), .X(N114) );
  SEH_INV_S_1 U308 ( .A(spicr0[0]), .X(n287) );
  SEH_AOI31_G_1 U309 ( .A1(n240), .A2(n289), .A3(spicr0[1]), .B(n157), .X(n165) );
  SEH_AO21B_1 U311 ( .A1(mclk_en), .A2(n78), .B(n81), .X(n218) );
  SEH_INV_S_1 U312 ( .A(n131), .X(n293) );
  SEH_OA31_1 U313 ( .A1(mcsn_sense), .A2(n258), .A3(n123), .B(n128), .X(n126)
         );
  SEH_AOI32_1 U314 ( .A1(spicr2[7]), .A2(n131), .A3(n145), .B1(mst_state0), 
        .B2(n146), .X(n143) );
  SEH_EO2_G_1 U315 ( .A1(spicr2[1]), .A2(mclk_sense), .X(n146) );
  SEH_OAI31_1 U316 ( .A1(tcv_cnt0), .A2(tcv_cnt2), .A3(tcv_cnt1), .B(n273), 
        .X(n180) );
  SEH_INV_S_1 U317 ( .A(rcv_rdy), .X(n273) );
  SEH_INV_S_0P8 U318 ( .A(byte_bndy), .X(n234) );
  SEH_OAI21_G_1 U319 ( .A1(n259), .A2(n80), .B(n81), .X(n217) );
  SEH_INV_S_1 U321 ( .A(tcv_reg0), .X(n281) );
  SEH_INV_S_1 U322 ( .A(tcv_reg7), .X(n274) );
  SEH_INV_S_1 U323 ( .A(spi_trdy_sample_flag), .X(n269) );
  SEH_INV_S_1 U324 ( .A(dly_cnt3), .X(n245) );
  SEH_AO22_DG_1 U325 ( .A1(n22), .A2(spisr[3]), .B1(n184), .B2(spi_rrdy_sample), .X(n179) );
  SEH_EO2_DG_1 U326 ( .A1(mclk_o), .A2(spi_port_sck_tcv_inv), .X(
        sck_tcv_early_fin) );
  SEH_ND2_G_1 U327 ( .A1(spisr[4]), .A2(n6), .X(n183) );
  CKHS_INVX1 u_sclk_inv ( .z(sck_tcv_inv), .a(sck_tcv) );
  CKHS_MUX2X2 u_sclk_mux ( .z(sck_tcv_fin), .d1(sck_tcv_inv), .d0(sck_tcv), 
        .sd(spi_port_sck_tcv_inv) );
  CKHS_BUFX4_0 u_sck_tcv_early_buf ( .z(sck_tcv_early), .a(sck_tcv_early_fin)
         );
  spi_div_6_01 mclk_divider ( .clk_out(mclk_o), .hlf_cyc(hlf_cyc), .clk_in(
        sb_clk_i), .clk_en(mclk_en), .clk_run(mclk_run), .clk_tog(n190), 
        .clk_pol(spicr2[2]), .div_exp(spibr[7]), .div(spibr[5:0]) );
  SYNCP_STD_0 mclk_sync ( .q(mclk_sense), .d(sck_tcv_fin), .ck(sb_clk_i), 
        .cdn(Logic1) );
  SYNCP_STD_1 mcsn_sync ( .q(mcsn_sense), .d(n192), .ck(sb_clk_i), .cdn(Logic1) );
  SEH_FDPRBQ_V2_1P5 spi_trdy_sample_sense_reg1 ( .D(spi_trdy_sample_sense0), 
        .CK(sb_clk_i), .RD(n32), .Q(spi_trdy_sample_sense1) );
  SEH_FDPRBQ_V2_1P5 spi_trdy_sample_sense_reg0 ( .D(spi_trdy_sample), .CK(
        sb_clk_i), .RD(n32), .Q(spi_trdy_sample_sense0) );
  SEH_FDPRBQ_V2_1P5 mclk_oe_reg ( .D(n217), .CK(sb_clk_i), .RD(n32), .Q(n302)
         );
  SEH_FDPRBQ_V2_1P5 spi_trdy_sample_flag_reg ( .D(n220), .CK(sb_clk_i), .RD(
        n330), .Q(spi_trdy_sample_flag) );
  SEH_FDPRBQ_V2_1P5 spi_mdf_reg ( .D(n215), .CK(sb_clk_i), .RD(n32), .Q(
        spisr[0]) );
  SEH_FDPRBQ_V2_1P5 mst_state_reg2 ( .D(n189), .CK(sb_clk_i), .RD(n32), .Q(
        mst_state2) );
  SEH_FDPRBQ_V2_1P5 spi_rrdy_reg ( .D(n214), .CK(sb_clk_i), .RD(n32), .Q(
        spisr[3]) );
  SEH_FDPRBQ_V2_1P5 spi_toe_reg ( .D(n219), .CK(sb_clk_i), .RD(n32), .Q(
        spisr[2]) );
  SEH_FDPRBQ_V2_1P5 spi_roe_reg ( .D(n213), .CK(sb_clk_i), .RD(n32), .Q(
        spisr[1]) );
  SEH_FDPRBQ_V2_1P5 dly_cnt_reg0 ( .D(N113), .CK(sb_clk_i), .RD(n32), .Q(
        dly_cnt0) );
  SEH_FDPRBQ_V2_1P5 dly_cnt_reg1 ( .D(N114), .CK(sb_clk_i), .RD(n32), .Q(
        dly_cnt1) );
  SEH_FDPRBQ_V2_1P5 mst_state_reg3 ( .D(mst_next3), .CK(sb_clk_i), .RD(n32), 
        .Q(mst_state3) );
  SEH_FDPRBQ_V2_1P5 dly_cnt_reg2 ( .D(N115), .CK(sb_clk_i), .RD(n330), .Q(
        dly_cnt2) );
  SEH_FDPRBQ_V2_1P5 dly_cnt_reg3 ( .D(N116), .CK(sb_clk_i), .RD(n330), .Q(
        dly_cnt3) );
  SEH_FDPRBQ_V2_1P5 spi_mfin_sync_reg ( .D(n216), .CK(sb_clk_i), .RD(n330), 
        .Q(spi_mfin_sync) );
  SEH_FDPRBQ_V2_1P5 mst_state_reg0 ( .D(mst_next0), .CK(sb_clk_i), .RD(n330), 
        .Q(mst_state0) );
  SEH_FDPRBQ_V2_1P5 mst_state_reg1 ( .D(mst_next1), .CK(sb_clk_i), .RD(n330), 
        .Q(mst_state1) );
  SEH_FDPRBQ_V2_1P5 spi_master_reg ( .D(n30), .CK(sb_clk_i), .RD(n330), .Q(
        spi_master) );
  SEH_FDNRBSBQ_1 trn_reg_reg ( .D(n204), .CK(sck_tcv_fin), .RD(n173), .SD(n174), .Q(trn_reg) );
  SEH_FDPSBQ_2 spi_trdy_reg ( .D(n228), .CK(sb_clk_i), .SD(n330), .Q(spisr[4])
         );
  SEH_FDPRBQ_V2_3 mclk_en_reg ( .D(n218), .CK(sb_clk_i), .RD(n330), .Q(mclk_en) );
  SEH_TIE1_G_1 U3 ( .X(Logic1) );
  SEH_INV_1 U4 ( .A(Logic1), .X(spisr[5]) );
  SEH_AN2_S_8 U5 ( .A1(n160), .A2(spicr1[7]), .X(n188) );
  SEH_OR2_3 U6 ( .A1(n14), .A2(n1), .X(n160) );
  SEH_ND2_3 U7 ( .A1(n188), .A2(byte_bndy), .X(n3) );
  SEH_AN4_1 U8 ( .A1(mst_state1), .A2(n241), .A3(n258), .A4(n246), .X(n11) );
  SEH_INV_S_1 U9 ( .A(mst_state0), .X(n241) );
  SEH_NR3_1 U10 ( .A1(n288), .A2(spisr[4]), .A3(mst_state1), .X(n145) );
  SEH_AN3_1 U11 ( .A1(byte_bndy_sync0), .A2(n283), .A3(n324), .X(n138) );
  SEH_INV_S_1 U12 ( .A(byte_bndy_sync1), .X(n324) );
  SEH_AO21B_1 U13 ( .A1(n158), .A2(dly_cnt1), .B(n7), .X(n159) );
  SEH_OR4B_1 U14 ( .B1(mst_state3), .B2(n258), .B3(n247), .A(mst_state0), .X(
        n129) );
  SEH_AO221_0P5 U15 ( .A1(mst_state1), .A2(n325), .B1(n246), .B2(n326), .C(n21), .X(mst_next1) );
  SEH_INV_S_1 U22 ( .A(n120), .X(n325) );
  SEH_INV_S_1 U26 ( .A(n132), .X(n326) );
  SEH_OA311_1 U31 ( .A1(n291), .A2(spi_mfin_sync), .A3(n288), .B1(n239), .B2(
        byte_bndy_nd_sync0), .X(n327) );
  SEH_INV_S_1 U34 ( .A(n327), .X(n137) );
  SEH_OR5_1 U53 ( .A1(n297), .A2(n296), .A3(n295), .A4(n294), .A5(n187), .X(
        n131) );
  SEH_ND4_S_1 U63 ( .A1(n129), .A2(n93), .A3(n95), .A4(n171), .X(n169) );
  SEH_AOA211_DG_1 U73 ( .A1(spi_rcv_upd_sync0), .A2(n193), .B(spisr[3]), .C(
        n328), .X(n214) );
  SEH_INV_S_1 U116 ( .A(n74), .X(n328) );
  SEH_AN2_2 U124 ( .A1(n164), .A2(n168), .X(n1) );
  SEH_INV_S_2 U128 ( .A(scsn_usr), .X(n168) );
  SEH_BUF_S_2 U135 ( .A(n330), .X(n191) );
  SEH_AN3B_1 U136 ( .B1(spicr2[3]), .B2(n291), .A(spicr2[4]), .X(n117) );
  SEH_INV_2 U149 ( .A(n32), .X(n329) );
  SEH_INV_S_3 U150 ( .A(spi_rst_async), .X(n32) );
  SEH_INV_S_2 U151 ( .A(n329), .X(n330) );
  SEH_INV_10 U152 ( .A(n98), .X(mcsn_o[0]) );
  SEH_INV_10 U153 ( .A(n100), .X(mcsn_o[1]) );
  SEH_INV_10 U154 ( .A(n104), .X(mcsn_o[2]) );
  SEH_INV_10 U155 ( .A(n109), .X(mcsn_o[3]) );
  SEH_INV_10 U156 ( .A(n1140), .X(mcsn_o[4]) );
  SEH_INV_10 U157 ( .A(n119), .X(mcsn_o[5]) );
  SEH_INV_10 U160 ( .A(n124), .X(mcsn_o[6]) );
  SEH_INV_10 U195 ( .A(n130), .X(mcsn_o[7]) );
endmodule


module spi_ip ( mclk_o, mclk_oe, mosi_o, mosi_oe, miso_o, miso_oe, mcsn_o, 
        mcsn_oe, sb_dat_o, sb_ack_o, spi_irq, spi_wkup, SB_ID, spi_rst_async, 
        sck_tcv, mosi_i, miso_i, scsn_usr, sb_clk_i, sb_we_i, sb_stb_i, 
        sb_adr_i, sb_dat_i, scan_test_mode, VDD, VSS );
  output [7:0] mcsn_o;
  output [7:0] mcsn_oe;
  output [7:0] sb_dat_o;
  input VDD, VSS;
  input [3:0] SB_ID;
  input [7:0] sb_adr_i;
  input [7:0] sb_dat_i;
  input spi_rst_async, sck_tcv, mosi_i, miso_i, scsn_usr, sb_clk_i, sb_we_i,
         sb_stb_i, scan_test_mode;
  output mclk_o, mclk_oe, mosi_o, mosi_oe, miso_o, miso_oe, sb_ack_o, spi_irq,
         spi_wkup;
  wire   n18, spicr07, spicr06, spicr05, spicr04, spicr03, spicr02, spicr01,
         spicr00, spicr17, spicr16, spicr15, spicr14, spicr13, spicr12,
         spicr11, spicr10, spicr27, spicr26, spicr25, spicr24, spicr23,
         spicr22, spicr21, spicr20, spibr7, spibr6, spibr5, spibr4, spibr3,
         spibr2, spibr1, spibr0, spicsr7, spicsr6, spicsr5, spicsr4, spicsr3,
         spicsr2, spicsr1, spicsr0, spitxdr7, spitxdr6, spitxdr5, spitxdr4,
         spitxdr3, spitxdr2, spitxdr1, spitxdr0, spicr0_wt, spicr1_wt,
         spicr2_wt, spibr_wt, spicsr_wt, spitxdr_wt, spirxdr_rd, spisr7,
         spisr6, spisr4, spisr3, spisr2, spisr1, spisr0, spirxdr7, spirxdr6,
         spirxdr5, spirxdr4, spirxdr3, spirxdr2, spirxdr1, spirxdr0, n1, n2,
         n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17,
         SYN_UC_1;

  SEH_TIE0_G_1 U1 ( .X(n1) );
  SEH_INV_S_1 U2 ( .A(sb_stb_i), .X(n6) );
  SEH_INV_S_1 U3 ( .A(sb_adr_i[0]), .X(n14) );
  SEH_INV_S_1 U4 ( .A(sb_we_i), .X(n12) );
  SEH_INV_S_1 U5 ( .A(sb_adr_i[2]), .X(n10) );
  SEH_INV_S_1 U6 ( .A(n8), .X(n9) );
  SEH_INV_S_1 U7 ( .A(sb_adr_i[1]), .X(n8) );
  SEH_INV_S_2 U8 ( .A(n18), .X(n2) );
  SEH_INV_S_10 U9 ( .A(n2), .X(spi_wkup) );
  SEH_INV_0P65 U10 ( .A(sb_adr_i[3]), .X(n4) );
  SEH_INV_S_1 U11 ( .A(n4), .X(n5) );
  SEH_INV_S_1 U12 ( .A(n6), .X(n7) );
  SEH_INV_S_1 U13 ( .A(n10), .X(n11) );
  SEH_INV_S_1 U14 ( .A(n12), .X(n13) );
  SEH_INV_2 U15 ( .A(n14), .X(n15) );
  SEH_BUF_D_3 U16 ( .A(scan_test_mode), .X(n16) );
  SEH_BUF_S_2 U17 ( .A(spi_rst_async), .X(n17) );
  spi_sci spi_sci_inst ( .spicr0({spicr07, spicr06, spicr05, spicr04, spicr03, 
        spicr02, spicr01, spicr00}), .spicr1({spicr17, spicr16, spicr15, 
        spicr14, spicr13, spicr12, spicr11, spicr10}), .spicr2({spicr27, 
        spicr26, spicr25, spicr24, spicr23, spicr22, spicr21, spicr20}), 
        .spibr({spibr7, spibr6, spibr5, spibr4, spibr3, spibr2, spibr1, spibr0}), .spicsr({spicsr7, spicsr6, spicsr5, spicsr4, spicsr3, spicsr2, spicsr1, 
        spicsr0}), .spitxdr({spitxdr7, spitxdr6, spitxdr5, spitxdr4, spitxdr3, 
        spitxdr2, spitxdr1, spitxdr0}), .spicr0_wt(spicr0_wt), .spicr1_wt(
        spicr1_wt), .spicr2_wt(spicr2_wt), .spibr_wt(spibr_wt), .spicsr_wt(
        spicsr_wt), .spitxdr_wt(spitxdr_wt), .spirxdr_rd(spirxdr_rd), 
        .sb_dat_o(sb_dat_o), .sb_ack_o(sb_ack_o), .spi_irq(spi_irq), .SB_ID(
        SB_ID), .spi_rst_async(n17), .sb_clk_i(sb_clk_i), .sb_we_i(n13), 
        .sb_stb_i(n7), .sb_adr_i({sb_adr_i[7:4], n5, n11, n9, n15}), 
        .sb_dat_i(sb_dat_i), .spisr({spisr7, spisr6, n1, spisr4, spisr3, 
        spisr2, spisr1, spisr0}), .spirxdr({spirxdr7, spirxdr6, spirxdr5, 
        spirxdr4, spirxdr3, spirxdr2, spirxdr1, spirxdr0}), .scan_test_mode(
        n16) );
  spi_port spi_port_inst ( .mclk_o(mclk_o), .mclk_oe(mclk_oe), .mosi_o(mosi_o), 
        .mosi_oe(mosi_oe), .miso_o(miso_o), .miso_oe(miso_oe), .mcsn_o(mcsn_o), 
        .mcsn_oe(mcsn_oe), .spisr({spisr7, spisr6, SYN_UC_1, spisr4, spisr3, 
        spisr2, spisr1, spisr0}), .spirxdr({spirxdr7, spirxdr6, spirxdr5, 
        spirxdr4, spirxdr3, spirxdr2, spirxdr1, spirxdr0}), .spi_wkup(n18), 
        .spi_rst_async(n17), .sck_tcv(sck_tcv), .mosi_i(mosi_i), .miso_i(
        miso_i), .scsn_usr(scsn_usr), .sb_clk_i(sb_clk_i), .spicr0({spicr07, 
        spicr06, spicr05, spicr04, spicr03, spicr02, spicr01, spicr00}), 
        .spicr1({spicr17, spicr16, spicr15, spicr14, spicr13, spicr12, spicr11, 
        spicr10}), .spicr2({spicr27, spicr26, spicr25, spicr24, spicr23, 
        spicr22, spicr21, spicr20}), .spibr({spibr7, spibr6, spibr5, spibr4, 
        spibr3, spibr2, spibr1, spibr0}), .spicsr({spicsr7, spicsr6, spicsr5, 
        spicsr4, spicsr3, spicsr2, spicsr1, spicsr0}), .spitxdr({spitxdr7, 
        spitxdr6, spitxdr5, spitxdr4, spitxdr3, spitxdr2, spitxdr1, spitxdr0}), 
        .spicr0_wt(spicr0_wt), .spicr1_wt(spicr1_wt), .spicr2_wt(spicr2_wt), 
        .spibr_wt(spibr_wt), .spicsr_wt(spicsr_wt), .spitxdr_wt(spitxdr_wt), 
        .spirxdr_rd(spirxdr_rd) );
endmodule

