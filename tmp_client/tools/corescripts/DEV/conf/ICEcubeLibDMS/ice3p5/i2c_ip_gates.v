
module i2c_sci_int_reg_0 ( status, rst_async, sb_clk_i, int_force, int_set, 
        int_clr, scan_test_mode );
  input rst_async, sb_clk_i, int_force, int_set, int_clr, scan_test_mode;
  output status;
  wire   int_clk, N2, int_sts, int_rsta, N5, n1, n20, n3;

  SEH_FDPRBQ_V2_1P5 status_reg ( .D(int_sts), .CK(int_clk), .RD(n20), .Q(
        status) );
  SEH_INV_S_1 U3 ( .A(int_rsta), .X(n20) );
  SEH_MUX2_G_1 U4 ( .D0(N5), .D1(rst_async), .S(scan_test_mode), .X(int_rsta)
         );
  SEH_OR2_1 U5 ( .A1(int_clr), .A2(rst_async), .X(N5) );
  SEH_AOAI211_G_1 U6 ( .A1(n1), .A2(n3), .B(int_clr), .C(scan_test_mode), .X(
        int_sts) );
  SEH_INV_S_1 U7 ( .A(int_set), .X(n1) );
  SEH_INV_S_1 U8 ( .A(int_force), .X(n3) );
  SEH_MUX2_G_1 U9 ( .D0(N2), .D1(sb_clk_i), .S(scan_test_mode), .X(int_clk) );
  SEH_EO2_0P5 U10 ( .A1(int_set), .A2(int_force), .X(N2) );
endmodule


module i2c_sci_int_reg_3 ( status, rst_async, sb_clk_i, int_force, int_set, 
        int_clr, scan_test_mode );
  input rst_async, sb_clk_i, int_force, int_set, int_clr, scan_test_mode;
  output status;
  wire   int_clk, N2, int_sts, int_rsta, N5, n1, n20, n3;

  SEH_FDPRBQ_V2_1P5 status_reg ( .D(int_sts), .CK(int_clk), .RD(n20), .Q(
        status) );
  SEH_INV_S_1 U3 ( .A(int_rsta), .X(n20) );
  SEH_MUX2_G_1 U4 ( .D0(N5), .D1(rst_async), .S(scan_test_mode), .X(int_rsta)
         );
  SEH_OR2_1 U5 ( .A1(int_clr), .A2(rst_async), .X(N5) );
  SEH_AOAI211_G_1 U6 ( .A1(n1), .A2(n3), .B(int_clr), .C(scan_test_mode), .X(
        int_sts) );
  SEH_INV_S_1 U7 ( .A(int_set), .X(n1) );
  SEH_INV_S_1 U8 ( .A(int_force), .X(n3) );
  SEH_MUX2_G_1 U9 ( .D0(N2), .D1(sb_clk_i), .S(scan_test_mode), .X(int_clk) );
  SEH_EO2_0P5 U10 ( .A1(int_set), .A2(int_force), .X(N2) );
endmodule


module i2c_sci_int_reg_2 ( status, rst_async, sb_clk_i, int_force, int_set, 
        int_clr, scan_test_mode );
  input rst_async, sb_clk_i, int_force, int_set, int_clr, scan_test_mode;
  output status;
  wire   int_clk, N2, int_sts, int_rsta, N5, n1, n20, n3;

  SEH_FDPRBQ_V2_1P5 status_reg ( .D(int_sts), .CK(int_clk), .RD(n20), .Q(
        status) );
  SEH_INV_S_1 U3 ( .A(int_rsta), .X(n20) );
  SEH_MUX2_G_1 U4 ( .D0(N5), .D1(rst_async), .S(scan_test_mode), .X(int_rsta)
         );
  SEH_OR2_1 U5 ( .A1(int_clr), .A2(rst_async), .X(N5) );
  SEH_AOAI211_G_1 U6 ( .A1(n1), .A2(n3), .B(int_clr), .C(scan_test_mode), .X(
        int_sts) );
  SEH_INV_S_1 U7 ( .A(int_set), .X(n1) );
  SEH_INV_S_1 U8 ( .A(int_force), .X(n3) );
  SEH_MUX2_G_1 U9 ( .D0(N2), .D1(sb_clk_i), .S(scan_test_mode), .X(int_clk) );
  SEH_EO2_0P5 U10 ( .A1(int_set), .A2(int_force), .X(N2) );
endmodule


module i2c_sci_int_reg_1 ( status, rst_async, sb_clk_i, int_force, int_set, 
        int_clr, scan_test_mode );
  input rst_async, sb_clk_i, int_force, int_set, int_clr, scan_test_mode;
  output status;
  wire   int_clk, N2, int_sts, int_rsta, N5, n1, n20, n3;

  SEH_FDPRBQ_V2_1P5 status_reg ( .D(int_sts), .CK(int_clk), .RD(n20), .Q(
        status) );
  SEH_INV_S_1 U3 ( .A(int_rsta), .X(n20) );
  SEH_MUX2_G_1 U4 ( .D0(N5), .D1(rst_async), .S(scan_test_mode), .X(int_rsta)
         );
  SEH_OR2_1 U5 ( .A1(int_clr), .A2(rst_async), .X(N5) );
  SEH_AOAI211_G_1 U6 ( .A1(n1), .A2(n3), .B(int_clr), .C(scan_test_mode), .X(
        int_sts) );
  SEH_INV_S_1 U7 ( .A(int_set), .X(n1) );
  SEH_INV_S_1 U8 ( .A(int_force), .X(n3) );
  SEH_MUX2_G_1 U9 ( .D0(N2), .D1(sb_clk_i), .S(scan_test_mode), .X(int_clk) );
  SEH_EO2_0P5 U10 ( .A1(int_set), .A2(int_force), .X(N2) );
endmodule


module i2c_sci ( i2ccr1, i2ccmdr, i2ctxdr, i2cbr, i2csaddr, i2ccr1_wt, 
        i2ccmdr_wt, i2cbr_wt, i2ctxdr_wt, i2csaddr_wt, i2crxdr_rd, i2cgcdr_rd, 
        trim_sda_del, sb_dat_o, sb_ack_o, i2c_irq, SB_ID, i2c_rst_async, 
        sb_clk_i, sb_we_i, sb_stb_i, sb_adr_i, sb_dat_i, i2csr, i2crxdr, 
        i2cgcdr, scan_test_mode );
  output [7:0] i2ccr1;
  output [7:0] i2ccmdr;
  output [7:0] i2ctxdr;
  output [9:0] i2cbr;
  output [7:0] i2csaddr;
  output [3:0] trim_sda_del;
  output [7:0] sb_dat_o;
  input [3:0] SB_ID;
  input [7:0] sb_adr_i;
  input [7:0] sb_dat_i;
  input [7:0] i2csr;
  input [7:0] i2crxdr;
  input [7:0] i2cgcdr;
  input i2c_rst_async, sb_clk_i, sb_we_i, sb_stb_i, scan_test_mode;
  output i2ccr1_wt, i2ccmdr_wt, i2cbr_wt, i2ctxdr_wt, i2csaddr_wt, i2crxdr_rd,
         i2cgcdr_rd, sb_ack_o, i2c_irq;
  wire   n184, n185, n186, n187, n188, n189, n190, n191, n192, n193, ip_stb,
         id_stb_dly, id_stb_pulse, N15, ack_reg, i2cbrmsb3, i2cbrmsb2,
         i2cintcr7, i2cintcr6, i2cintcr5, i2cintcr4, i2cintcr3, i2cintcr2,
         i2cintcr1, i2cintcr0, N52, N53, N54, N55, N56, N57, N58, N59,
         int_clr_arbl, int_arbl, int_clr_trrdy, int_trrdy, int_clr_troe,
         int_troe, int_clr_hgc, int_hgc, n5, n23, n24, n26, n32, n33, n34, n35,
         n36, n38, n39, n40, n41, n43, n44, n45, n48, n49, n50, n51, n530,
         n550, n580, n590, n60, n61, n62, n64, n65, n67, n68, n69, n70, n71,
         n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85,
         n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n100,
         n101, n102, n103, n104, n105, n110, n111, n112, n113, n114, n115,
         n116, n117, n118, n119, n120, n121, n122, n123, n124, n125, n126,
         n127, n128, n129, n130, n131, n132, n133, n134, n135, n136, n137,
         n138, n139, n140, n141, n142, n143, n144, n145, n146, n147, n148,
         n149, n150, n151, n152, n153, n154, n155, n156, n157, n158, n159,
         n160, n161, n162, n163, n164, n165, n166, n167, n168, n169, n170,
         n171, n172, n2, n3, n4, n6, n16, n17, n18, n19, n20, n21, n22, n25,
         n27, n28, n29, n30, n31, n37, n42, n46, n47, n520, n540, n560, n570,
         n63, n66, n99, n106, n107, n108, n109, n173, n174, n175, n176, n177,
         n178, n179, n180, n181, n182, n183;

  SEH_FDPRBQ_V2_1P5 i2cintcr_reg0 ( .D(n117), .CK(sb_clk_i), .RD(n4), .Q(
        i2cintcr0) );
  SEH_FDPRBQ_V2_1P5 i2cintcr_reg1 ( .D(n118), .CK(sb_clk_i), .RD(n3), .Q(
        i2cintcr1) );
  SEH_FDPRBQ_V2_1P5 i2cintcr_reg2 ( .D(n119), .CK(sb_clk_i), .RD(n6), .Q(
        i2cintcr2) );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg1 ( .D(N53), .CK(sb_clk_i), .RD(n6), .Q(n190)
         );
  SEH_FDPRBQ_V2_1P5 id_stb_dly_reg ( .D(n520), .CK(sb_clk_i), .RD(n4), .Q(
        id_stb_dly) );
  SEH_FDPRBQ_V2_1P5 id_stb_pulse_reg ( .D(N15), .CK(sb_clk_i), .RD(n3), .Q(
        id_stb_pulse) );
  SEH_FDPRBQ_V2_1P5 ack_reg_reg ( .D(ip_stb), .CK(sb_clk_i), .RD(n570), .Q(
        ack_reg) );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg7 ( .D(N59), .CK(sb_clk_i), .RD(n6), .Q(n184)
         );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg6 ( .D(N58), .CK(sb_clk_i), .RD(n4), .Q(n185)
         );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg5 ( .D(N57), .CK(sb_clk_i), .RD(n3), .Q(n186)
         );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg4 ( .D(N56), .CK(sb_clk_i), .RD(n570), .Q(n187) );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg0 ( .D(N52), .CK(sb_clk_i), .RD(n6), .Q(n191)
         );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg2 ( .D(N54), .CK(sb_clk_i), .RD(n4), .Q(n189)
         );
  SEH_FDPRBQ_V2_1P5 sb_dat_o_reg3 ( .D(N55), .CK(sb_clk_i), .RD(n3), .Q(n188)
         );
  SEH_FDPRBQ_V2_1P5 i2ctxdr_reg7 ( .D(n156), .CK(sb_clk_i), .RD(n570), .Q(
        i2ctxdr[7]) );
  SEH_FDPRBQ_V2_1P5 i2ctxdr_reg6 ( .D(n155), .CK(sb_clk_i), .RD(n6), .Q(
        i2ctxdr[6]) );
  SEH_FDPRBQ_V2_1P5 i2ctxdr_reg5 ( .D(n154), .CK(sb_clk_i), .RD(n4), .Q(
        i2ctxdr[5]) );
  SEH_FDPRBQ_V2_1P5 i2ctxdr_reg4 ( .D(n153), .CK(sb_clk_i), .RD(n3), .Q(
        i2ctxdr[4]) );
  SEH_FDPRBQ_V2_1P5 i2ctxdr_reg3 ( .D(n152), .CK(sb_clk_i), .RD(n570), .Q(
        i2ctxdr[3]) );
  SEH_FDPRBQ_V2_1P5 i2ctxdr_reg2 ( .D(n151), .CK(sb_clk_i), .RD(n6), .Q(
        i2ctxdr[2]) );
  SEH_FDPRBQ_V2_1P5 i2ctxdr_reg1 ( .D(n150), .CK(sb_clk_i), .RD(n4), .Q(
        i2ctxdr[1]) );
  SEH_FDPRBQ_V2_1P5 i2ctxdr_reg0 ( .D(n149), .CK(sb_clk_i), .RD(n3), .Q(
        i2ctxdr[0]) );
  SEH_FDPRBQ_V2_1P5 i2cbrmsb_reg7 ( .D(n140), .CK(sb_clk_i), .RD(n570), .Q(
        trim_sda_del[3]) );
  SEH_FDPRBQ_V2_1P5 i2cbrmsb_reg6 ( .D(n139), .CK(sb_clk_i), .RD(n6), .Q(
        trim_sda_del[2]) );
  SEH_FDPRBQ_V2_1P5 i2cbrmsb_reg5 ( .D(n138), .CK(sb_clk_i), .RD(n4), .Q(
        trim_sda_del[1]) );
  SEH_FDPRBQ_V2_1P5 i2cbrmsb_reg4 ( .D(n137), .CK(sb_clk_i), .RD(n3), .Q(
        trim_sda_del[0]) );
  SEH_FDPRBQ_V2_1P5 i2cbrmsb_reg3 ( .D(n136), .CK(sb_clk_i), .RD(n570), .Q(
        i2cbrmsb3) );
  SEH_FDPRBQ_V2_1P5 i2cbrmsb_reg2 ( .D(n135), .CK(sb_clk_i), .RD(n6), .Q(
        i2cbrmsb2) );
  SEH_FDPRBQ_V2_1P5 i2cbrmsb_reg1 ( .D(n134), .CK(sb_clk_i), .RD(n4), .Q(
        i2cbr[9]) );
  SEH_FDPRBQ_V2_1P5 i2cbrmsb_reg0 ( .D(n133), .CK(sb_clk_i), .RD(n3), .Q(
        i2cbr[8]) );
  SEH_FDPRBQ_V2_1P5 i2cbrlsb_reg7 ( .D(n148), .CK(sb_clk_i), .RD(n570), .Q(
        i2cbr[7]) );
  SEH_FDPRBQ_V2_1P5 i2cbrlsb_reg6 ( .D(n147), .CK(sb_clk_i), .RD(n6), .Q(
        i2cbr[6]) );
  SEH_FDPRBQ_V2_1P5 i2cbrlsb_reg5 ( .D(n146), .CK(sb_clk_i), .RD(n4), .Q(
        i2cbr[5]) );
  SEH_FDPRBQ_V2_1P5 i2cbrlsb_reg4 ( .D(n145), .CK(sb_clk_i), .RD(n3), .Q(
        i2cbr[4]) );
  SEH_FDPRBQ_V2_1P5 i2cbrlsb_reg3 ( .D(n144), .CK(sb_clk_i), .RD(n570), .Q(
        i2cbr[3]) );
  SEH_FDPRBQ_V2_1P5 i2cbrlsb_reg2 ( .D(n143), .CK(sb_clk_i), .RD(n6), .Q(
        i2cbr[2]) );
  SEH_FDPRBQ_V2_1P5 i2cbrlsb_reg1 ( .D(n142), .CK(sb_clk_i), .RD(n4), .Q(
        i2cbr[1]) );
  SEH_FDPRBQ_V2_1P5 i2cbrlsb_reg0 ( .D(n141), .CK(sb_clk_i), .RD(n3), .Q(
        i2cbr[0]) );
  SEH_FDPRBQ_V2_1P5 i2ccr1_reg7 ( .D(n172), .CK(sb_clk_i), .RD(n570), .Q(
        i2ccr1[7]) );
  SEH_FDPRBQ_V2_1P5 i2ccr1_reg6 ( .D(n171), .CK(sb_clk_i), .RD(n6), .Q(
        i2ccr1[6]) );
  SEH_FDPRBQ_V2_1P5 i2ccr1_reg5 ( .D(n170), .CK(sb_clk_i), .RD(n4), .Q(
        i2ccr1[5]) );
  SEH_FDPRBQ_V2_1P5 i2ccr1_reg4 ( .D(n169), .CK(sb_clk_i), .RD(n3), .Q(
        i2ccr1[4]) );
  SEH_FDPRBQ_V2_1P5 i2ccr1_reg3 ( .D(n168), .CK(sb_clk_i), .RD(n570), .Q(
        i2ccr1[3]) );
  SEH_FDPRBQ_V2_1P5 i2ccr1_reg2 ( .D(n167), .CK(sb_clk_i), .RD(n6), .Q(
        i2ccr1[2]) );
  SEH_FDPRBQ_V2_1P5 i2ccr1_reg1 ( .D(n166), .CK(sb_clk_i), .RD(n4), .Q(
        i2ccr1[1]) );
  SEH_FDPRBQ_V2_1P5 i2ccr1_reg0 ( .D(n165), .CK(sb_clk_i), .RD(n3), .Q(
        i2ccr1[0]) );
  SEH_FDPRBQ_V2_1P5 i2ccmdr_reg7 ( .D(n164), .CK(sb_clk_i), .RD(n570), .Q(
        i2ccmdr[7]) );
  SEH_FDPRBQ_V2_1P5 i2ccmdr_reg6 ( .D(n163), .CK(sb_clk_i), .RD(n6), .Q(
        i2ccmdr[6]) );
  SEH_FDPRBQ_V2_1P5 i2ccmdr_reg5 ( .D(n162), .CK(sb_clk_i), .RD(n4), .Q(
        i2ccmdr[5]) );
  SEH_FDPRBQ_V2_1P5 i2ccmdr_reg4 ( .D(n161), .CK(sb_clk_i), .RD(n3), .Q(
        i2ccmdr[4]) );
  SEH_FDPRBQ_V2_1P5 i2ccmdr_reg3 ( .D(n160), .CK(sb_clk_i), .RD(n570), .Q(
        i2ccmdr[3]) );
  SEH_FDPRBQ_V2_1P5 i2ccmdr_reg2 ( .D(n159), .CK(sb_clk_i), .RD(n6), .Q(
        i2ccmdr[2]) );
  SEH_FDPRBQ_V2_1P5 i2ccmdr_reg1 ( .D(n158), .CK(sb_clk_i), .RD(n4), .Q(
        i2ccmdr[1]) );
  SEH_FDPRBQ_V2_1P5 i2ccmdr_reg0 ( .D(n157), .CK(sb_clk_i), .RD(n3), .Q(
        i2ccmdr[0]) );
  SEH_FDPRBQ_V2_1P5 i2csaddr_reg7 ( .D(n132), .CK(sb_clk_i), .RD(n570), .Q(
        i2csaddr[7]) );
  SEH_FDPRBQ_V2_1P5 i2csaddr_reg6 ( .D(n131), .CK(sb_clk_i), .RD(n6), .Q(
        i2csaddr[6]) );
  SEH_FDPRBQ_V2_1P5 i2csaddr_reg5 ( .D(n130), .CK(sb_clk_i), .RD(n4), .Q(
        i2csaddr[5]) );
  SEH_FDPRBQ_V2_1P5 i2csaddr_reg4 ( .D(n129), .CK(sb_clk_i), .RD(n3), .Q(
        i2csaddr[4]) );
  SEH_FDPRBQ_V2_1P5 i2csaddr_reg3 ( .D(n128), .CK(sb_clk_i), .RD(n3), .Q(
        i2csaddr[3]) );
  SEH_FDPRBQ_V2_1P5 i2csaddr_reg2 ( .D(n127), .CK(sb_clk_i), .RD(n6), .Q(
        i2csaddr[2]) );
  SEH_FDPRBQ_V2_1P5 i2csaddr_reg1 ( .D(n126), .CK(sb_clk_i), .RD(n4), .Q(
        i2csaddr[1]) );
  SEH_FDPRBQ_V2_1P5 i2csaddr_reg0 ( .D(n125), .CK(sb_clk_i), .RD(n3), .Q(
        i2csaddr[0]) );
  SEH_FDPRBQ_V2_1P5 i2cintcr_reg7 ( .D(n124), .CK(sb_clk_i), .RD(n4), .Q(
        i2cintcr7) );
  SEH_FDPRBQ_V2_1P5 i2cintcr_reg6 ( .D(n123), .CK(sb_clk_i), .RD(n6), .Q(
        i2cintcr6) );
  SEH_FDPRBQ_V2_1P5 i2cintcr_reg5 ( .D(n122), .CK(sb_clk_i), .RD(n4), .Q(
        i2cintcr5) );
  SEH_FDPRBQ_V2_1P5 i2cintcr_reg4 ( .D(n121), .CK(sb_clk_i), .RD(n3), .Q(
        i2cintcr4) );
  SEH_FDPRBQ_V2_1P5 i2cintcr_reg3 ( .D(n120), .CK(sb_clk_i), .RD(n6), .Q(
        i2cintcr3) );
  SEH_OR2_1 U3 ( .A1(n88), .A2(n48), .X(n44) );
  SEH_OAI221_0P5 U4 ( .A1(n42), .A2(n16), .B1(n37), .B2(n19), .C(n580), .X(
        n193) );
  SEH_ND2_S_0P5 U5 ( .A1(ack_reg), .A2(sb_stb_i), .X(n192) );
  SEH_INV_8 U6 ( .A(n192), .X(sb_ack_o) );
  SEH_INV_S_0P5 U7 ( .A(n570), .X(n2) );
  SEH_INV_S_0P5 U8 ( .A(n2), .X(n3) );
  SEH_INV_S_0P5 U9 ( .A(n2), .X(n4) );
  SEH_INV_S_0P5 U10 ( .A(n2), .X(n6) );
  SEH_BUF_D_8 U11 ( .A(n184), .X(sb_dat_o[7]) );
  SEH_BUF_D_8 U12 ( .A(n185), .X(sb_dat_o[6]) );
  SEH_BUF_D_8 U13 ( .A(n186), .X(sb_dat_o[5]) );
  SEH_BUF_D_8 U14 ( .A(n187), .X(sb_dat_o[4]) );
  SEH_BUF_D_8 U15 ( .A(n188), .X(sb_dat_o[3]) );
  SEH_BUF_D_8 U16 ( .A(n189), .X(sb_dat_o[2]) );
  SEH_BUF_D_8 U17 ( .A(n190), .X(sb_dat_o[1]) );
  SEH_BUF_D_8 U18 ( .A(n191), .X(sb_dat_o[0]) );
  SEH_BUF_D_8 U19 ( .A(n193), .X(i2c_irq) );
  SEH_NR3_G_1 U20 ( .A1(n174), .A2(sb_adr_i[0]), .A3(n550), .X(n35) );
  SEH_NR2_G_1 U21 ( .A1(n63), .A2(n43), .X(n24) );
  SEH_NR3_T_0P8 U22 ( .A1(n175), .A2(sb_adr_i[1]), .A3(n550), .X(n39) );
  SEH_ND2_G_1 U23 ( .A1(sb_adr_i[3]), .A2(n173), .X(n550) );
  SEH_ND2_G_1 U24 ( .A1(id_stb_pulse), .A2(sb_we_i), .X(n48) );
  SEH_NR3_T_0P8 U25 ( .A1(sb_adr_i[0]), .A2(sb_adr_i[1]), .A3(n550), .X(n41)
         );
  SEH_ND3_1 U26 ( .A1(n103), .A2(n109), .A3(sb_adr_i[2]), .X(n23) );
  SEH_ND4_S_1 U27 ( .A1(n112), .A2(n113), .A3(n114), .A4(n115), .X(n43) );
  SEH_ND4_S_1 U28 ( .A1(n66), .A2(id_stb_pulse), .A3(i2cintcr7), .A4(n63), .X(
        n45) );
  SEH_INV_S_1 U29 ( .A(n26), .X(n540) );
  SEH_INV_S_1 U30 ( .A(n51), .X(n106) );
  SEH_ND2_G_1 U31 ( .A1(n99), .A2(n24), .X(n26) );
  SEH_ND2_G_1 U32 ( .A1(n33), .A2(n24), .X(n32) );
  SEH_ND2_G_1 U33 ( .A1(n35), .A2(n24), .X(n34) );
  SEH_ND2_G_1 U34 ( .A1(n108), .A2(n24), .X(n36) );
  SEH_INV_S_1 U35 ( .A(n5), .X(n560) );
  SEH_INV_S_1 U36 ( .A(n530), .X(n107) );
  SEH_INV_S_1 U37 ( .A(n50), .X(n99) );
  SEH_ND2_G_1 U38 ( .A1(n110), .A2(n175), .X(n51) );
  SEH_INV_S_1 U39 ( .A(n49), .X(n108) );
  SEH_NR2B_1 U40 ( .A(n39), .B(n48), .X(i2ccmdr_wt) );
  SEH_INV_S_1 U41 ( .A(sb_adr_i[0]), .X(n175) );
  SEH_NR3_G_1 U42 ( .A1(n48), .A2(n174), .A3(n550), .X(i2cbr_wt) );
  SEH_NR2_G_1 U43 ( .A1(n50), .A2(n48), .X(i2csaddr_wt) );
  SEH_ND3_1 U44 ( .A1(n173), .A2(n109), .A3(n103), .X(n50) );
  SEH_NR2_G_1 U45 ( .A1(n174), .A2(n175), .X(n103) );
  SEH_NR2B_1 U46 ( .A(n41), .B(n48), .X(i2ccr1_wt) );
  SEH_NR2B_1 U47 ( .A(n111), .B(sb_adr_i[0]), .X(n67) );
  SEH_NR2B_1 U48 ( .A(n103), .B(n550), .X(n33) );
  SEH_ND2_G_1 U49 ( .A1(ip_stb), .A2(n63), .X(n62) );
  SEH_ND2_G_1 U50 ( .A1(n41), .A2(n24), .X(n40) );
  SEH_ND2B_1 U51 ( .A(n23), .B(n24), .X(n5) );
  SEH_ND2_G_1 U52 ( .A1(n39), .A2(n24), .X(n38) );
  SEH_NR3_G_1 U53 ( .A1(n173), .A2(n174), .A3(n109), .X(n110) );
  SEH_INV_S_1 U54 ( .A(n88), .X(n66) );
  SEH_OAI22_S_1 U55 ( .A1(n5), .A2(n183), .B1(n560), .B2(n47), .X(n117) );
  SEH_OAI22_S_1 U56 ( .A1(n5), .A2(n182), .B1(n560), .B2(n46), .X(n118) );
  SEH_OAI22_S_1 U57 ( .A1(n5), .A2(n181), .B1(n560), .B2(n42), .X(n119) );
  SEH_OAI22_S_1 U58 ( .A1(n5), .A2(n180), .B1(n560), .B2(n37), .X(n120) );
  SEH_OAI22_S_1 U59 ( .A1(n5), .A2(n179), .B1(n560), .B2(n31), .X(n121) );
  SEH_OAI22_S_1 U60 ( .A1(n5), .A2(n178), .B1(n560), .B2(n30), .X(n122) );
  SEH_OAI22_S_1 U61 ( .A1(n5), .A2(n177), .B1(n560), .B2(n29), .X(n123) );
  SEH_OAI22_S_1 U62 ( .A1(n5), .A2(n176), .B1(n560), .B2(n28), .X(n124) );
  SEH_ND2_G_1 U63 ( .A1(n111), .A2(sb_adr_i[0]), .X(n49) );
  SEH_OAI22_S_1 U64 ( .A1(n179), .A2(n26), .B1(n540), .B2(n27), .X(n129) );
  SEH_OAI22_S_1 U65 ( .A1(n178), .A2(n26), .B1(n540), .B2(n25), .X(n130) );
  SEH_OAI22_S_1 U66 ( .A1(n177), .A2(n26), .B1(n540), .B2(n22), .X(n131) );
  SEH_OAI22_S_1 U67 ( .A1(n176), .A2(n26), .B1(n540), .B2(n21), .X(n132) );
  SEH_NR2_G_1 U68 ( .A1(n49), .A2(n48), .X(i2ctxdr_wt) );
  SEH_ND2_G_1 U69 ( .A1(n110), .A2(sb_adr_i[0]), .X(n530) );
  SEH_INV_S_1 U70 ( .A(n43), .X(n520) );
  SEH_OAI21_G_1 U71 ( .A1(n181), .A2(n44), .B(n45), .X(int_clr_trrdy) );
  SEH_OAI21_G_1 U72 ( .A1(n182), .A2(n44), .B(n45), .X(int_clr_troe) );
  SEH_OAI21_G_1 U73 ( .A1(n183), .A2(n44), .B(n45), .X(int_clr_hgc) );
  SEH_OAI21_G_1 U74 ( .A1(n180), .A2(n44), .B(n45), .X(int_clr_arbl) );
  SEH_INV_S_1 U75 ( .A(i2c_rst_async), .X(n570) );
  SEH_INV_S_1 U76 ( .A(sb_adr_i[2]), .X(n173) );
  SEH_INV_S_0P5 U77 ( .A(sb_adr_i[1]), .X(n174) );
  SEH_INV_S_1 U78 ( .A(sb_adr_i[3]), .X(n109) );
  SEH_AOI31_G_1 U79 ( .A1(n94), .A2(n95), .A3(n96), .B(n62), .X(N53) );
  SEH_AOI22_1 U80 ( .A1(i2ccr1[1]), .A2(n41), .B1(i2ccmdr[1]), .B2(n39), .X(
        n94) );
  SEH_AOI221_1 U81 ( .A1(i2ctxdr[1]), .A2(n108), .B1(i2crxdr[1]), .B2(n106), 
        .C(n97), .X(n96) );
  SEH_AOI222_0P5 U82 ( .A1(i2cbr[1]), .A2(n35), .B1(i2cbr[9]), .B2(n33), .C1(
        i2csr[1]), .C2(n67), .X(n95) );
  SEH_AOI31_G_1 U83 ( .A1(n89), .A2(n90), .A3(n91), .B(n62), .X(N54) );
  SEH_AOI22_1 U84 ( .A1(i2ccr1[2]), .A2(n41), .B1(i2ccmdr[2]), .B2(n39), .X(
        n89) );
  SEH_AOI221_1 U85 ( .A1(i2ctxdr[2]), .A2(n108), .B1(i2crxdr[2]), .B2(n106), 
        .C(n92), .X(n91) );
  SEH_AOI222_0P5 U86 ( .A1(i2cbr[2]), .A2(n35), .B1(i2cbrmsb2), .B2(n33), .C1(
        i2csr[2]), .C2(n67), .X(n90) );
  SEH_NR3_G_1 U87 ( .A1(n51), .A2(sb_we_i), .A3(n20), .X(i2crxdr_rd) );
  SEH_AOI22_1 U88 ( .A1(int_hgc), .A2(i2cintcr0), .B1(int_troe), .B2(i2cintcr1), .X(n580) );
  SEH_ND4_1 U89 ( .A1(sb_adr_i[2]), .A2(sb_adr_i[1]), .A3(n175), .A4(n109), 
        .X(n88) );
  SEH_EN2_S_0P5 U90 ( .A1(sb_adr_i[6]), .A2(SB_ID[2]), .X(n112) );
  SEH_EN2_S_0P5 U91 ( .A1(sb_adr_i[5]), .A2(SB_ID[1]), .X(n113) );
  SEH_EN2_S_0P5 U92 ( .A1(sb_adr_i[7]), .A2(SB_ID[3]), .X(n115) );
  SEH_AOI31_G_1 U93 ( .A1(n100), .A2(n101), .A3(n102), .B(n62), .X(N52) );
  SEH_AOI22_1 U94 ( .A1(i2ccr1[0]), .A2(n41), .B1(i2ccmdr[0]), .B2(n39), .X(
        n100) );
  SEH_AOI222_0P5 U95 ( .A1(i2cbr[0]), .A2(n35), .B1(i2cbr[8]), .B2(n33), .C1(
        i2csr[0]), .C2(n67), .X(n101) );
  SEH_AOI221_1 U96 ( .A1(i2ctxdr[0]), .A2(n108), .B1(i2crxdr[0]), .B2(n106), 
        .C(n104), .X(n102) );
  SEH_OAI221_0P5 U97 ( .A1(n23), .A2(n31), .B1(n50), .B2(n27), .C(n82), .X(n81) );
  SEH_ND2_G_1 U98 ( .A1(i2cgcdr[4]), .A2(n107), .X(n82) );
  SEH_OAI221_0P5 U99 ( .A1(n23), .A2(n30), .B1(n50), .B2(n25), .C(n77), .X(n76) );
  SEH_ND2_G_1 U100 ( .A1(i2cgcdr[5]), .A2(n107), .X(n77) );
  SEH_OAI221_0P5 U101 ( .A1(n23), .A2(n29), .B1(n50), .B2(n22), .C(n72), .X(
        n71) );
  SEH_ND2_G_1 U102 ( .A1(i2cgcdr[6]), .A2(n107), .X(n72) );
  SEH_OAI221_0P5 U103 ( .A1(n23), .A2(n28), .B1(n50), .B2(n21), .C(n65), .X(
        n64) );
  SEH_ND2_G_1 U104 ( .A1(i2cgcdr[7]), .A2(n107), .X(n65) );
  SEH_NR3_T_0P65 U105 ( .A1(n173), .A2(sb_adr_i[1]), .A3(n109), .X(n111) );
  SEH_NR3_1 U106 ( .A1(n530), .A2(sb_we_i), .A3(n20), .X(i2cgcdr_rd) );
  SEH_INV_S_0P5 U107 ( .A(sb_we_i), .X(n63) );
  SEH_AOI31_G_1 U108 ( .A1(n83), .A2(n84), .A3(n85), .B(n62), .X(N55) );
  SEH_AOI22_1 U109 ( .A1(i2ccr1[3]), .A2(n41), .B1(i2ccmdr[3]), .B2(n39), .X(
        n83) );
  SEH_AOI222_0P5 U110 ( .A1(i2cbr[3]), .A2(n35), .B1(i2cbrmsb3), .B2(n33), 
        .C1(i2csr[3]), .C2(n67), .X(n84) );
  SEH_AOI221_1 U111 ( .A1(i2ctxdr[3]), .A2(n108), .B1(i2crxdr[3]), .B2(n106), 
        .C(n86), .X(n85) );
  SEH_AOI31_G_1 U112 ( .A1(n78), .A2(n79), .A3(n80), .B(n62), .X(N56) );
  SEH_AOI22_1 U113 ( .A1(i2ccr1[4]), .A2(n41), .B1(i2ccmdr[4]), .B2(n39), .X(
        n78) );
  SEH_AOI222_0P5 U114 ( .A1(i2cbr[4]), .A2(n35), .B1(trim_sda_del[0]), .B2(n33), .C1(i2csr[4]), .C2(n67), .X(n79) );
  SEH_AOI221_1 U115 ( .A1(i2ctxdr[4]), .A2(n108), .B1(i2crxdr[4]), .B2(n106), 
        .C(n81), .X(n80) );
  SEH_AOI31_G_1 U116 ( .A1(n73), .A2(n74), .A3(n75), .B(n62), .X(N57) );
  SEH_AOI22_1 U117 ( .A1(i2ccr1[5]), .A2(n41), .B1(i2ccmdr[5]), .B2(n39), .X(
        n73) );
  SEH_AOI222_0P5 U118 ( .A1(i2cbr[5]), .A2(n35), .B1(trim_sda_del[1]), .B2(n33), .C1(i2csr[5]), .C2(n67), .X(n74) );
  SEH_AOI221_1 U119 ( .A1(i2ctxdr[5]), .A2(n108), .B1(i2crxdr[5]), .B2(n106), 
        .C(n76), .X(n75) );
  SEH_AOI31_G_1 U120 ( .A1(n68), .A2(n69), .A3(n70), .B(n62), .X(N58) );
  SEH_AOI22_1 U121 ( .A1(i2ccr1[6]), .A2(n41), .B1(i2ccmdr[6]), .B2(n39), .X(
        n68) );
  SEH_AOI222_0P5 U122 ( .A1(i2cbr[6]), .A2(n35), .B1(trim_sda_del[2]), .B2(n33), .C1(i2csr[6]), .C2(n67), .X(n69) );
  SEH_AOI221_1 U123 ( .A1(i2ctxdr[6]), .A2(n108), .B1(i2crxdr[6]), .B2(n106), 
        .C(n71), .X(n70) );
  SEH_AOI31_G_1 U124 ( .A1(n590), .A2(n60), .A3(n61), .B(n62), .X(N59) );
  SEH_AOI22_1 U125 ( .A1(i2ccr1[7]), .A2(n41), .B1(i2ccmdr[7]), .B2(n39), .X(
        n590) );
  SEH_AOI222_0P5 U126 ( .A1(i2cbr[7]), .A2(n35), .B1(trim_sda_del[3]), .B2(n33), .C1(i2csr[7]), .C2(n67), .X(n60) );
  SEH_AOI221_1 U127 ( .A1(i2ctxdr[7]), .A2(n108), .B1(i2crxdr[7]), .B2(n106), 
        .C(n64), .X(n61) );
  SEH_AO2BB2_DG_1 U128 ( .A1(n183), .A2(n32), .B1(n32), .B2(i2cbr[8]), .X(n133) );
  SEH_AO2BB2_DG_1 U129 ( .A1(n182), .A2(n32), .B1(n32), .B2(i2cbr[9]), .X(n134) );
  SEH_AO2BB2_DG_1 U130 ( .A1(n181), .A2(n32), .B1(n32), .B2(i2cbrmsb2), .X(
        n135) );
  SEH_AO2BB2_DG_1 U131 ( .A1(n180), .A2(n32), .B1(n32), .B2(i2cbrmsb3), .X(
        n136) );
  SEH_AO2BB2_DG_1 U132 ( .A1(n183), .A2(n34), .B1(n34), .B2(i2cbr[0]), .X(n141) );
  SEH_AO2BB2_DG_1 U133 ( .A1(n182), .A2(n34), .B1(n34), .B2(i2cbr[1]), .X(n142) );
  SEH_AO2BB2_DG_1 U134 ( .A1(n181), .A2(n34), .B1(n34), .B2(i2cbr[2]), .X(n143) );
  SEH_AO2BB2_DG_1 U135 ( .A1(n180), .A2(n34), .B1(n34), .B2(i2cbr[3]), .X(n144) );
  SEH_AO2BB2_DG_1 U136 ( .A1(n183), .A2(n36), .B1(n36), .B2(i2ctxdr[0]), .X(
        n149) );
  SEH_AO2BB2_DG_1 U137 ( .A1(n182), .A2(n36), .B1(n36), .B2(i2ctxdr[1]), .X(
        n150) );
  SEH_AO2BB2_DG_1 U138 ( .A1(n181), .A2(n36), .B1(n36), .B2(i2ctxdr[2]), .X(
        n151) );
  SEH_AO2BB2_DG_1 U139 ( .A1(n180), .A2(n36), .B1(n36), .B2(i2ctxdr[3]), .X(
        n152) );
  SEH_AO2BB2_DG_1 U140 ( .A1(n183), .A2(n38), .B1(n38), .B2(i2ccmdr[0]), .X(
        n157) );
  SEH_AO2BB2_DG_1 U141 ( .A1(n182), .A2(n38), .B1(n38), .B2(i2ccmdr[1]), .X(
        n158) );
  SEH_AO2BB2_DG_1 U142 ( .A1(n181), .A2(n38), .B1(n38), .B2(i2ccmdr[2]), .X(
        n159) );
  SEH_AO2BB2_DG_1 U143 ( .A1(n180), .A2(n38), .B1(n38), .B2(i2ccmdr[3]), .X(
        n160) );
  SEH_AO2BB2_DG_1 U144 ( .A1(n183), .A2(n40), .B1(n40), .B2(i2ccr1[0]), .X(
        n165) );
  SEH_AO2BB2_DG_1 U145 ( .A1(n182), .A2(n40), .B1(n40), .B2(i2ccr1[1]), .X(
        n166) );
  SEH_AO2BB2_DG_1 U146 ( .A1(n181), .A2(n40), .B1(n40), .B2(i2ccr1[2]), .X(
        n167) );
  SEH_AO2BB2_DG_1 U147 ( .A1(n180), .A2(n40), .B1(n40), .B2(i2ccr1[3]), .X(
        n168) );
  SEH_AO2BB2_DG_1 U148 ( .A1(n179), .A2(n40), .B1(n40), .B2(i2ccr1[4]), .X(
        n169) );
  SEH_AO2BB2_DG_1 U149 ( .A1(n178), .A2(n40), .B1(n40), .B2(i2ccr1[5]), .X(
        n170) );
  SEH_AO2BB2_DG_1 U150 ( .A1(n177), .A2(n40), .B1(n40), .B2(i2ccr1[6]), .X(
        n171) );
  SEH_AO2BB2_DG_1 U151 ( .A1(n176), .A2(n40), .B1(n40), .B2(i2ccr1[7]), .X(
        n172) );
  SEH_AO2BB2_DG_1 U152 ( .A1(n179), .A2(n32), .B1(n32), .B2(trim_sda_del[0]), 
        .X(n137) );
  SEH_AO2BB2_DG_1 U153 ( .A1(n178), .A2(n32), .B1(n32), .B2(trim_sda_del[1]), 
        .X(n138) );
  SEH_AO2BB2_DG_1 U154 ( .A1(n177), .A2(n32), .B1(n32), .B2(trim_sda_del[2]), 
        .X(n139) );
  SEH_AO2BB2_DG_1 U155 ( .A1(n176), .A2(n32), .B1(n32), .B2(trim_sda_del[3]), 
        .X(n140) );
  SEH_AO2BB2_DG_1 U156 ( .A1(n179), .A2(n38), .B1(n38), .B2(i2ccmdr[4]), .X(
        n161) );
  SEH_AO2BB2_DG_1 U157 ( .A1(n178), .A2(n38), .B1(n38), .B2(i2ccmdr[5]), .X(
        n162) );
  SEH_AO2BB2_DG_1 U158 ( .A1(n177), .A2(n38), .B1(n38), .B2(i2ccmdr[6]), .X(
        n163) );
  SEH_AO2BB2_DG_1 U159 ( .A1(n176), .A2(n38), .B1(n38), .B2(i2ccmdr[7]), .X(
        n164) );
  SEH_AO2BB2_DG_1 U160 ( .A1(n179), .A2(n34), .B1(n34), .B2(i2cbr[4]), .X(n145) );
  SEH_AO2BB2_DG_1 U161 ( .A1(n178), .A2(n34), .B1(n34), .B2(i2cbr[5]), .X(n146) );
  SEH_AO2BB2_DG_1 U162 ( .A1(n177), .A2(n34), .B1(n34), .B2(i2cbr[6]), .X(n147) );
  SEH_AO2BB2_DG_1 U163 ( .A1(n176), .A2(n34), .B1(n34), .B2(i2cbr[7]), .X(n148) );
  SEH_AO2BB2_DG_1 U164 ( .A1(n179), .A2(n36), .B1(n36), .B2(i2ctxdr[4]), .X(
        n153) );
  SEH_AO2BB2_DG_1 U165 ( .A1(n178), .A2(n36), .B1(n36), .B2(i2ctxdr[5]), .X(
        n154) );
  SEH_AO2BB2_DG_1 U166 ( .A1(n177), .A2(n36), .B1(n36), .B2(i2ctxdr[6]), .X(
        n155) );
  SEH_AO2BB2_DG_1 U167 ( .A1(n176), .A2(n36), .B1(n36), .B2(i2ctxdr[7]), .X(
        n156) );
  SEH_OA31_1 U168 ( .A1(n66), .A2(sb_adr_i[3]), .A3(n103), .B(n520), .X(ip_stb) );
  SEH_INV_S_1 U169 ( .A(i2cintcr2), .X(n42) );
  SEH_INV_S_1 U170 ( .A(i2cintcr3), .X(n37) );
  SEH_NR2_G_1 U171 ( .A1(id_stb_dly), .A2(n43), .X(N15) );
  SEH_NR2B_1 U172 ( .A(sb_stb_i), .B(n116), .X(n114) );
  SEH_EO2_0P5 U173 ( .A1(sb_adr_i[4]), .A2(SB_ID[0]), .X(n116) );
  SEH_AO221_0P5 U174 ( .A1(i2cgcdr[0]), .A2(n107), .B1(i2csaddr[0]), .B2(n99), 
        .C(n105), .X(n104) );
  SEH_OAOI211_1 U175 ( .A1(n88), .A2(n18), .B(n23), .C(n47), .X(n105) );
  SEH_INV_S_1 U176 ( .A(int_hgc), .X(n18) );
  SEH_AO221_0P5 U177 ( .A1(i2cgcdr[1]), .A2(n107), .B1(i2csaddr[1]), .B2(n99), 
        .C(n98), .X(n97) );
  SEH_OAOI211_1 U178 ( .A1(n88), .A2(n17), .B(n23), .C(n46), .X(n98) );
  SEH_INV_S_1 U179 ( .A(int_troe), .X(n17) );
  SEH_AO221_0P5 U180 ( .A1(i2cgcdr[2]), .A2(n107), .B1(i2csaddr[2]), .B2(n99), 
        .C(n93), .X(n92) );
  SEH_OAOI211_1 U181 ( .A1(n88), .A2(n16), .B(n23), .C(n42), .X(n93) );
  SEH_AO221_0P5 U182 ( .A1(i2cgcdr[3]), .A2(n107), .B1(i2csaddr[3]), .B2(n99), 
        .C(n87), .X(n86) );
  SEH_OAOI211_1 U183 ( .A1(n88), .A2(n19), .B(n23), .C(n37), .X(n87) );
  SEH_AO22_DG_1 U184 ( .A1(sb_dat_i[0]), .A2(n540), .B1(n26), .B2(i2csaddr[0]), 
        .X(n125) );
  SEH_AO22_DG_1 U185 ( .A1(sb_dat_i[1]), .A2(n540), .B1(n26), .B2(i2csaddr[1]), 
        .X(n126) );
  SEH_AO22_DG_1 U186 ( .A1(sb_dat_i[2]), .A2(n540), .B1(n26), .B2(i2csaddr[2]), 
        .X(n127) );
  SEH_AO22_DG_1 U187 ( .A1(sb_dat_i[3]), .A2(n540), .B1(n26), .B2(i2csaddr[3]), 
        .X(n128) );
  SEH_INV_S_1 U188 ( .A(sb_dat_i[0]), .X(n183) );
  SEH_INV_S_1 U189 ( .A(sb_dat_i[1]), .X(n182) );
  SEH_INV_S_1 U190 ( .A(sb_dat_i[2]), .X(n181) );
  SEH_INV_S_1 U191 ( .A(sb_dat_i[3]), .X(n180) );
  SEH_INV_S_1 U192 ( .A(sb_dat_i[4]), .X(n179) );
  SEH_INV_S_1 U193 ( .A(sb_dat_i[5]), .X(n178) );
  SEH_INV_S_1 U194 ( .A(sb_dat_i[6]), .X(n177) );
  SEH_INV_S_1 U195 ( .A(sb_dat_i[7]), .X(n176) );
  SEH_INV_S_1 U196 ( .A(i2cintcr6), .X(n29) );
  SEH_INV_S_1 U197 ( .A(id_stb_pulse), .X(n20) );
  SEH_INV_S_1 U198 ( .A(i2csaddr[4]), .X(n27) );
  SEH_INV_S_1 U199 ( .A(i2csaddr[5]), .X(n25) );
  SEH_INV_S_1 U200 ( .A(i2csaddr[7]), .X(n21) );
  SEH_INV_S_1 U201 ( .A(i2csaddr[6]), .X(n22) );
  SEH_INV_S_1 U202 ( .A(i2cintcr1), .X(n46) );
  SEH_INV_S_1 U203 ( .A(i2cintcr0), .X(n47) );
  SEH_INV_S_1 U204 ( .A(i2cintcr7), .X(n28) );
  SEH_INV_S_1 U205 ( .A(i2cintcr4), .X(n31) );
  SEH_INV_S_1 U206 ( .A(i2cintcr5), .X(n30) );
  SEH_INV_S_1 U207 ( .A(int_arbl), .X(n19) );
  SEH_INV_S_1 U208 ( .A(int_trrdy), .X(n16) );
  i2c_sci_int_reg_0 intr_arbl ( .status(int_arbl), .rst_async(i2c_rst_async), 
        .sb_clk_i(sb_clk_i), .int_force(i2cintcr6), .int_set(i2csr[3]), 
        .int_clr(int_clr_arbl), .scan_test_mode(scan_test_mode) );
  i2c_sci_int_reg_3 intr_trrdy ( .status(int_trrdy), .rst_async(i2c_rst_async), 
        .sb_clk_i(sb_clk_i), .int_force(i2cintcr6), .int_set(i2csr[2]), 
        .int_clr(int_clr_trrdy), .scan_test_mode(scan_test_mode) );
  i2c_sci_int_reg_2 intr_troe ( .status(int_troe), .rst_async(i2c_rst_async), 
        .sb_clk_i(sb_clk_i), .int_force(i2cintcr6), .int_set(i2csr[1]), 
        .int_clr(int_clr_troe), .scan_test_mode(scan_test_mode) );
  i2c_sci_int_reg_1 intr_hgc ( .status(int_hgc), .rst_async(i2c_rst_async), 
        .sb_clk_i(sb_clk_i), .int_force(i2cintcr6), .int_set(i2csr[0]), 
        .int_clr(int_clr_hgc), .scan_test_mode(scan_test_mode) );
endmodule


module SYNCP_STD ( q, d, ck, cdn );
  input d, ck, cdn;
  output q;
  wire   q0;

  SEH_FDPRBQ_2 u ( .D(q0), .CK(ck), .RD(cdn), .Q(q) );
  SEH_FDPRBQ_V2_1P5 u0 ( .D(d), .CK(ck), .RD(cdn), .Q(q0) );
endmodule


module i2c_port_DW01_dec_1 ( A, SUM );
  input [15:0] A;
  output [15:0] SUM;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15;

  SEH_OR2_1 U1 ( .A1(A[1]), .A2(A[0]), .X(n10) );
  SEH_INV_S_1 U2 ( .A(A[10]), .X(n1) );
  SEH_AO21_0P65 U3 ( .A1(n2), .A2(A[9]), .B(n3), .X(SUM[9]) );
  SEH_AO21B_1 U4 ( .A1(n4), .A2(A[8]), .B(n2), .X(SUM[8]) );
  SEH_AO21B_1 U5 ( .A1(n5), .A2(A[7]), .B(n4), .X(SUM[7]) );
  SEH_AO21B_1 U6 ( .A1(n6), .A2(A[6]), .B(n5), .X(SUM[6]) );
  SEH_AO21B_1 U7 ( .A1(n7), .A2(A[5]), .B(n6), .X(SUM[5]) );
  SEH_AO21B_1 U8 ( .A1(n8), .A2(A[4]), .B(n7), .X(SUM[4]) );
  SEH_AO21B_1 U9 ( .A1(n9), .A2(A[3]), .B(n8), .X(SUM[3]) );
  SEH_AO21B_1 U10 ( .A1(n10), .A2(A[2]), .B(n9), .X(SUM[2]) );
  SEH_AO21B_1 U11 ( .A1(A[0]), .A2(A[1]), .B(n10), .X(SUM[1]) );
  SEH_EO2_0P5 U12 ( .A1(A[15]), .A2(n11), .X(SUM[15]) );
  SEH_NR2_0P5 U13 ( .A1(A[14]), .A2(n12), .X(n11) );
  SEH_EN2_0P5 U14 ( .A1(A[14]), .A2(n12), .X(SUM[14]) );
  SEH_AO21B_1 U15 ( .A1(n13), .A2(A[13]), .B(n12), .X(SUM[13]) );
  SEH_OR2_0P65 U16 ( .A1(n13), .A2(A[13]), .X(n12) );
  SEH_AO21B_1 U17 ( .A1(n14), .A2(A[12]), .B(n13), .X(SUM[12]) );
  SEH_OR2_0P65 U18 ( .A1(n14), .A2(A[12]), .X(n13) );
  SEH_AO21B_1 U19 ( .A1(n15), .A2(A[11]), .B(n14), .X(SUM[11]) );
  SEH_OR2_0P65 U20 ( .A1(n15), .A2(A[11]), .X(n14) );
  SEH_OAI21_0P5 U21 ( .A1(n3), .A2(n1), .B(n15), .X(SUM[10]) );
  SEH_ND2_0P5 U22 ( .A1(n3), .A2(n1), .X(n15) );
  SEH_NR2_0P5 U23 ( .A1(n2), .A2(A[9]), .X(n3) );
  SEH_OR2_0P65 U24 ( .A1(n4), .A2(A[8]), .X(n2) );
  SEH_OR2_0P65 U25 ( .A1(n5), .A2(A[7]), .X(n4) );
  SEH_OR2_0P65 U26 ( .A1(n6), .A2(A[6]), .X(n5) );
  SEH_OR2_0P65 U27 ( .A1(n7), .A2(A[5]), .X(n6) );
  SEH_OR2_0P65 U28 ( .A1(n8), .A2(A[4]), .X(n7) );
  SEH_OR2_0P65 U29 ( .A1(n9), .A2(A[3]), .X(n8) );
  SEH_OR2_0P65 U30 ( .A1(n10), .A2(A[2]), .X(n9) );
  SEH_INV_0P5 U31 ( .A(A[0]), .X(SUM[0]) );
endmodule


module i2c_port_DW01_inc_0 ( A, SUM );
  input [15:0] A;
  output [15:0] SUM;
  wire   carry15, carry14, carry13, carry12, carry11, carry10, carry9, carry8,
         carry7, carry6, carry5, carry4, carry3, carry2;

  SEH_ADDH_1 U1_1_14 ( .A(A[14]), .B(carry14), .CO(carry15), .S(SUM[14]) );
  SEH_ADDH_1 U1_1_9 ( .A(A[9]), .B(carry9), .CO(carry10), .S(SUM[9]) );
  SEH_ADDH_1 U1_1_11 ( .A(A[11]), .B(carry11), .CO(carry12), .S(SUM[11]) );
  SEH_ADDH_1 U1_1_8 ( .A(A[8]), .B(carry8), .CO(carry9), .S(SUM[8]) );
  SEH_ADDH_1 U1_1_4 ( .A(A[4]), .B(carry4), .CO(carry5), .S(SUM[4]) );
  SEH_ADDH_1 U1_1_12 ( .A(A[12]), .B(carry12), .CO(carry13), .S(SUM[12]) );
  SEH_ADDH_1 U1_1_5 ( .A(A[5]), .B(carry5), .CO(carry6), .S(SUM[5]) );
  SEH_ADDH_1 U1_1_7 ( .A(A[7]), .B(carry7), .CO(carry8), .S(SUM[7]) );
  SEH_ADDH_1 U1_1_3 ( .A(A[3]), .B(carry3), .CO(carry4), .S(SUM[3]) );
  SEH_ADDH_1 U1_1_13 ( .A(A[13]), .B(carry13), .CO(carry14), .S(SUM[13]) );
  SEH_ADDH_1 U1_1_6 ( .A(A[6]), .B(carry6), .CO(carry7), .S(SUM[6]) );
  SEH_ADDH_1 U1_1_2 ( .A(A[2]), .B(carry2), .CO(carry3), .S(SUM[2]) );
  SEH_ADDH_1 U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry2), .S(SUM[1]) );
  SEH_ADDH_1 U1_1_10 ( .A(A[10]), .B(carry10), .CO(carry11), .S(SUM[10]) );
  SEH_EO2_0P5 U1 ( .A1(carry15), .A2(A[15]), .X(SUM[15]) );
  SEH_INV_0P5 U2 ( .A(A[0]), .X(SUM[0]) );
endmodule


module i2c_port ( sda_out, sda_oe, scl_out, scl_oe, i2crxdr, i2cgcdr, i2csr, 
        i2c_hsmode, i2c_wkup, ADDR_LSB_USR, i2c_rst_async, sda_in, scl_in, 
        del_clk, sb_clk_i, i2ccr1, i2ccmdr, i2ctxdr, i2cbr, i2csaddr, 
        i2ccr1_wt, i2ccmdr_wt, i2cbr_wt, i2ctxdr_wt, i2csaddr_wt, i2crxdr_rd, 
        i2cgcdr_rd, trim_sda_del, scan_test_mode );
  output [7:0] i2crxdr;
  output [7:0] i2cgcdr;
  output [7:0] i2csr;
  input [1:0] ADDR_LSB_USR;
  input [7:0] i2ccr1;
  input [7:0] i2ccmdr;
  input [7:0] i2ctxdr;
  input [9:0] i2cbr;
  input [7:0] i2csaddr;
  input [3:0] trim_sda_del;
  input i2c_rst_async, sda_in, scl_in, del_clk, sb_clk_i, i2ccr1_wt,
         i2ccmdr_wt, i2cbr_wt, i2ctxdr_wt, i2csaddr_wt, i2crxdr_rd, i2cgcdr_rd,
         scan_test_mode;
  output sda_out, sda_oe, scl_out, scl_oe, i2c_hsmode, i2c_wkup;
  wire   Logic1, n400, n402, n404, trcv_stop, trcv_start_rst_d, trcv_start,
         N66, trst_idle, trcv_arbl, trst_ack_all_nd, trst_ack_all_pd, N73,
         tr_state2, tr_state1, tr_state0, trst_tip, trst_data, N78, N105, N106,
         N107, trcv_cnt2, trcv_cnt1, trcv_cnt0, trcv_cnt6, trn_reg7, trn_reg6,
         trn_reg5, trn_reg4, trn_reg3, trn_reg2, trn_reg1, trn_reg0, rcv_reg7,
         rcv_reg6, rcv_reg5, rcv_reg4, rcv_reg3, rcv_reg2, rcv_reg1, rcv_reg0,
         rcv_addr6, rcv_addr5, rcv_addr4, rcv_addr3, rcv_addr2, rcv_addr1,
         rcv_addr0, rcv_rw, rcv_info7, rcv_info6, rcv_info5, rcv_info4,
         rcv_info3, rcv_info2, rcv_info1, rcv_info0, rcv_data7, rcv_data6,
         rcv_data5, rcv_data4, rcv_data3, rcv_data2, rcv_data1, rcv_data0,
         rcv_arc, trn_ack, mcst_master, trn_rw, mc_trn_en, addr_ok_sync,
         i2c_rcv_ok, i2c_rrdy, upd_gcsr, upd_gcdr, trst_arc_d_sync, upd_rxdr,
         trst_arc_d_sync0, i2c_rarc_sync0, i2c_srw_sync0, i2c_arbl_sync0, N171,
         i2c_tip_sync0, i2c_busy_sync0, trst_rw_ok_sync0, trst_rw_ok_sync,
         addr_ok_sync0, i2c_trn_sync0, N172, i2c_trn_sync, i2c_rcv_sync0,
         i2c_rcv_sync, addr_ok_usr_sync0, addr_ok_usr_sync, upd_rxdr_sync0,
         upd_gcdr_sync1, upd_gcdr_sync0, upd_gcsr_sync0, i2c_scl_sense0,
         i2c_scl_sense, mst_scl_sense0, mc_scl_out, trcv_cnt6_sync2,
         trcv_cnt6_sync1, trcv_cnt6_sync0, i2c_trdy, tr_scl_out, clk_cnt15,
         clk_cnt14, clk_cnt13, clk_cnt12, clk_cnt11, clk_cnt10, clk_cnt9,
         clk_cnt8, clk_cnt7, clk_cnt6, clk_cnt5, clk_cnt4, clk_cnt3, clk_cnt2,
         clk_cnt1, clk_cnt0, exec_stsp, cmd_exec_active, ckstr_flag,
         exec_stsp_det1, exec_stsp_det0, N193, N194, N195, N196, N197, N198,
         N199, N200, N201, N202, N203, N204, N205, N206, N207, N208, N210,
         N211, N212, N213, N214, N215, N216, N217, N218, N219, N220, N221,
         N222, N223, N224, N225, mcmd_stcmd, mcmd_start, mcmd_stop,
         cmd_exec_en_d, cmd_exec_wt, cap_txdr_sync1, cap_txdr_sync0, mc_state3,
         mc_state2, mc_state1, mc_state0, N376, mc_sda_out, N377, N378,
         del_zero_states, N379, trcv_start_sync2, trcv_start_sync1,
         trcv_start_sync0, i2c_toe, i2c_roe, sda_out_int, del_rstn_async,
         sda_no_del, N488, sda_del_cnt5, sda_del_cnt4, sda_del_cnt3,
         sda_del_cnt2, sda_del_cnt1, sda_del_cnt0, sda_out_det1, sda_out_det0,
         sda_del_cnt_en, del_cnt_set_sense2, del_cnt_set_sense1,
         del_cnt_set_sense0, N505, N506, N507, N508, N509, sda_out_sense_r,
         n13, n14, n16, n17, n18, n20, n23, n24, n25, n27, n30, n31, n34, n36,
         n38, n39, n41, n42, n43, n44, n45, n46, n47, n48, n50, n51, n52, n53,
         n54, n55, n58, n67, n68, n71, n730, n74, n75, n76, n77, n780, n79,
         n80, n81, n83, n84, n86, n88, n90, n93, n95, n98, n101, n104, n1070,
         n110, n111, n114, n115, n118, n122, n123, n125, n129, n130, n131,
         n132, n133, n136, n140, n141, n144, n145, n146, n149, n150, n151,
         n153, n154, n156, n157, n158, n159, n161, n164, n167, n169, n1710,
         n177, n178, n180, n181, n182, n183, n185, n186, n188, n190, n1930,
         n1940, n1950, n1960, n1970, n1980, n1990, n2010, n2030, n2040, n2050,
         n2060, n2080, n2110, n2120, n2130, n2150, n2170, n2180, n2190, n2210,
         n2230, n2240, n2250, n226, n227, n229, n230, n239, n240, n241, n244,
         n245, n246, n248, n249, n251, n254, n257, n263, n265, n267, n271,
         n274, n275, n276, n277, n279, n280, n281, n282, n284, n285, n288,
         n289, n290, n291, n292, n293, n294, n295, n297, n298, n299, n301,
         n303, n304, n305, n307, n308, n310, n311, n312, n313, n315, n317,
         n318, n320, n321, n322, n323, n324, n325, n326, n327, n328, n329,
         n330, n334, n335, n336, n337, n338, n339, n340, n341, n342, n343,
         n344, n345, n346, n347, n348, n349, n350, n351, n352, n353, n354,
         n355, n356, n357, n359, n360, n361, n362, n363, n364, n365, n366,
         n367, n368, n369, n370, n371, n372, n373, n374, n375, n3760, n3770,
         n3780, n3790, n380, n381, n382, n383, n384, n385, n386, n389, n391,
         n393, n395, n397, n399, n401, n403, n420, n421, n422, n424, n425,
         n426, n427, n428, n429, n432, n433, n434, n435, n436, n437, n438,
         n439, n440, n441, n442, n443, n444, n445, n446, n447, n448, n449,
         n450, n451, n452, n453, n454, n455, n456, n457, n458, n459, n460,
         n461, n462, n463, n464, n465, n466, n467, n468, n469, n470, n471,
         n472, n473, n474, n475, n476, n477, n478, n479, n480, n481, n482,
         n483, n484, n485, n486, n487, n4880, n489, n490, n491, n492, n493,
         n494, n495, n496, n497, n498, n499, n500, n501, n502, n503, n504,
         n5050, n5060, n5070, n5080, n5090, n510, n511, n512, n513, n514, n515,
         n516, n517, n518, n519, n520, n521, n522, n523, n524, n525, n526,
         n527, n528, n529, n530, n1, n2, n3, n4, n5, n9, n10, n11, n12, n15,
         n19, n21, n22, n26, n28, n29, n32, n33, n35, n37, n40, n49, n56, n57,
         n59, n60, n61, n62, n63, n64, n65, n660, n69, n70, n72, n82, n85, n87,
         n89, n91, n92, n94, n96, n97, n99, n100, n102, n103, n1050, n1060,
         n108, n109, n112, n113, n116, n117, n119, n120, n121, n124, n126,
         n127, n128, n134, n135, n137, n138, n139, n142, n143, n147, n148,
         n152, n155, n160, n162, n163, n165, n168, n170, n1720, n173, n174,
         n175, n176, n179, n184, n187, n189, n191, n192, n2000, n2020, n2070,
         n209, n2100, n2140, n2160, n2200, n2220, n228, n231, n232, n233, n234,
         n235, n236, n237, n238, n242, n243, n247, n250, n252, n253, n255,
         n256, n258, n259, n260, n261, n262, n264, n266, n268, n269, n270,
         n272, n273, n278, n283, n286, n287, n296, n300, n302, n306, n309,
         n314, n316, n319, n331, n332, n333, n358, n387, n388, n390, n392,
         n394, n396, n398;

  SEH_FDPTQ_1 cmd_exec_en_d_reg ( .D(cmd_exec_active), .SS(n232), .CK(sb_clk_i), .Q(cmd_exec_en_d) );
  SEH_FDAO22PQ_1 cap_txdr_sync_reg0 ( .A1(n433), .A2(cmd_exec_wt), .B1(n364), 
        .B2(trst_arc_d_sync), .CK(sb_clk_i), .Q(cap_txdr_sync0) );
  SEH_INV_0P5 U379 ( .A(scl_in), .X(n18) );
  SEH_FDPRBQ_V2_1P5 trcv_stop_reg ( .D(scl_in), .CK(sda_in), .RD(n421), .Q(
        trcv_stop) );
  SEH_FDNRBQ_V2_1 trcv_start_reg ( .D(N66), .CK(sda_in), .RD(n420), .Q(
        trcv_start) );
  SEH_FDPRBQ_V2_1P5 trst_tip_reg ( .D(n424), .CK(scl_in), .RD(n11), .Q(
        trst_tip) );
  SEH_FDPQ_V2_1 cap_txdr_sync_reg1 ( .D(cap_txdr_sync0), .CK(sb_clk_i), .Q(
        cap_txdr_sync1) );
  SEH_FDNRBQ_V2_1 i2c_hsmode_reg ( .D(n5090), .CK(scl_in), .RD(n3), .Q(
        i2c_hsmode) );
  SEH_FDPQ_V2_1 addr_ok_usr_sync_reg ( .D(addr_ok_usr_sync0), .CK(sb_clk_i), 
        .Q(addr_ok_usr_sync) );
  SEH_FDPRBQ_V2_1P5 trcv_arbl_reg ( .D(n385), .CK(scl_in), .RD(n384), .Q(
        trcv_arbl) );
  SEH_FDPQB_V2_2 i2c_arbl_sync_reg ( .D(i2c_arbl_sync0), .CK(sb_clk_i), .QN(
        n426) );
  SEH_FDPRBQ_V2_1P5 sda_out_det_reg0 ( .D(sda_out_det1), .CK(del_clk), .RD(
        del_rstn_async), .Q(sda_out_det0) );
  SEH_FDPRBQ_V2_1P5 sda_out_det_reg1 ( .D(sda_out_int), .CK(del_clk), .RD(
        del_rstn_async), .Q(sda_out_det1) );
  SEH_FDPQ_V2_1 i2c_arbl_sync0_reg ( .D(trcv_arbl), .CK(sb_clk_i), .Q(
        i2c_arbl_sync0) );
  SEH_FDNRBSBQ_1 trn_reg_reg0 ( .D(n381), .CK(scl_in), .RD(n3790), .SD(n380), 
        .Q(trn_reg0) );
  SEH_FDNRBSBQ_1 trn_reg_reg1 ( .D(n475), .CK(scl_in), .RD(n3770), .SD(n3780), 
        .Q(trn_reg1) );
  SEH_FDNRBSBQ_1 trn_reg_reg2 ( .D(n474), .CK(scl_in), .RD(n375), .SD(n3760), 
        .Q(trn_reg2) );
  SEH_FDNRBSBQ_1 trn_reg_reg3 ( .D(n473), .CK(scl_in), .RD(n373), .SD(n374), 
        .Q(trn_reg3) );
  SEH_FDNRBSBQ_1 trn_reg_reg4 ( .D(n472), .CK(scl_in), .RD(n371), .SD(n372), 
        .Q(trn_reg4) );
  SEH_FDNRBSBQ_1 trn_reg_reg5 ( .D(n471), .CK(scl_in), .RD(n369), .SD(n370), 
        .Q(trn_reg5) );
  SEH_FDNRBSBQ_1 trn_reg_reg6 ( .D(n470), .CK(scl_in), .RD(n367), .SD(n368), 
        .Q(trn_reg6) );
  SEH_FDPRBQ_V2_1P5 trcv_cnt6_reg ( .D(n510), .CK(scl_in), .RD(n11), .Q(
        trcv_cnt6) );
  SEH_FDPQ_V2_1 trcv_cnt6_sync_reg2 ( .D(trcv_cnt6_sync1), .CK(sb_clk_i), .Q(
        trcv_cnt6_sync2) );
  SEH_FDPQ_V2_1 upd_gcdr_sync_reg1 ( .D(upd_gcdr_sync0), .CK(sb_clk_i), .Q(
        upd_gcdr_sync1) );
  SEH_FDPQB_V2_2 mst_scl_sense_reg ( .D(mst_scl_sense0), .CK(sb_clk_i), .QN(
        n429) );
  SEH_FDPQ_V2_1 i2c_rcv_sync_reg ( .D(i2c_rcv_sync0), .CK(sb_clk_i), .Q(
        i2c_rcv_sync) );
  SEH_FDPQ_V2_1 trcv_cnt6_sync_reg0 ( .D(trcv_cnt6), .CK(sb_clk_i), .Q(
        trcv_cnt6_sync0) );
  SEH_FDPRBQ_V2_1P5 del_cnt_set_sense_reg0 ( .D(del_cnt_set_sense1), .CK(
        del_clk), .RD(del_rstn_async), .Q(del_cnt_set_sense0) );
  SEH_FDPRBQ_V2_1P5 sda_del_cnt_en_reg ( .D(n456), .CK(del_clk), .RD(
        del_rstn_async), .Q(sda_del_cnt_en) );
  SEH_FDPQ_V2_1 addr_ok_sync_reg ( .D(addr_ok_sync0), .CK(sb_clk_i), .Q(
        addr_ok_sync) );
  SEH_FDPQ_V2_1 i2c_rarc_sync_reg ( .D(i2c_rarc_sync0), .CK(sb_clk_i), .Q(
        i2csr[5]) );
  SEH_FDPQ_V2_1 trcv_start_sync_reg2 ( .D(trcv_start), .CK(sb_clk_i), .Q(
        trcv_start_sync2) );
  SEH_FDPQ_V2_1 trcv_start_sync_reg1 ( .D(trcv_start_sync2), .CK(sb_clk_i), 
        .Q(trcv_start_sync1) );
  SEH_FDPQB_V2_2 upd_gcsr_sync_reg1 ( .D(upd_gcsr_sync0), .CK(sb_clk_i), .QN(
        n428) );
  SEH_FDPQ_V2_1 i2c_scl_sense_reg ( .D(i2c_scl_sense0), .CK(sb_clk_i), .Q(
        i2c_scl_sense) );
  SEH_FDPQ_V2_1 trcv_start_sync_reg0 ( .D(trcv_start_sync1), .CK(sb_clk_i), 
        .Q(trcv_start_sync0) );
  SEH_FDPRBQ_V2_1P5 del_cnt_set_sense_reg1 ( .D(del_cnt_set_sense2), .CK(
        del_clk), .RD(del_rstn_async), .Q(del_cnt_set_sense1) );
  SEH_FDPRBQ_V2_1P5 sda_del_cnt_reg2 ( .D(n452), .CK(del_clk), .RD(
        del_rstn_async), .Q(sda_del_cnt2) );
  SEH_FDPQ_V2_1 upd_gcsr_sync_reg0 ( .D(upd_gcsr), .CK(sb_clk_i), .Q(
        upd_gcsr_sync0) );
  SEH_FDPQ_V2_1 trcv_cnt6_sync_reg1 ( .D(trcv_cnt6_sync0), .CK(sb_clk_i), .Q(
        trcv_cnt6_sync1) );
  SEH_FDPQ_V2_1 upd_gcdr_sync_reg0 ( .D(upd_gcdr), .CK(sb_clk_i), .Q(
        upd_gcdr_sync0) );
  SEH_FDPQ_V2_1 trst_rw_ok_sync_reg ( .D(trst_rw_ok_sync0), .CK(sb_clk_i), .Q(
        trst_rw_ok_sync) );
  SEH_FDPQ_V2_1 i2c_trn_sync_reg ( .D(i2c_trn_sync0), .CK(sb_clk_i), .Q(
        i2c_trn_sync) );
  SEH_FDPQB_V2_2 upd_rxdr_sync_reg1 ( .D(upd_rxdr_sync0), .CK(sb_clk_i), .QN(
        n427) );
  SEH_FDPRBQ_V2_1P5 sda_del_cnt_reg5 ( .D(n455), .CK(del_clk), .RD(
        del_rstn_async), .Q(sda_del_cnt5) );
  SEH_FDPQ_V2_1 i2c_tip_sync_reg ( .D(i2c_tip_sync0), .CK(sb_clk_i), .Q(
        i2csr[7]) );
  SEH_FDPRBQ_V2_1P5 sda_del_cnt_reg1 ( .D(n453), .CK(del_clk), .RD(
        del_rstn_async), .Q(sda_del_cnt1) );
  SEH_FDPQ_V2_1 upd_rxdr_sync_reg0 ( .D(upd_rxdr), .CK(sb_clk_i), .Q(
        upd_rxdr_sync0) );
  SEH_FDPQ_V2_1 i2c_srw_sync_reg ( .D(i2c_srw_sync0), .CK(sb_clk_i), .Q(
        i2csr[4]) );
  SEH_FDPRBQ_V2_1P5 sda_del_cnt_reg3 ( .D(n451), .CK(del_clk), .RD(
        del_rstn_async), .Q(sda_del_cnt3) );
  SEH_FDPRBQ_V2_1P5 sda_del_cnt_reg0 ( .D(n454), .CK(del_clk), .RD(
        del_rstn_async), .Q(sda_del_cnt0) );
  SEH_FDPRBQ_V2_1P5 trcv_start_rst_d_reg ( .D(trcv_start), .CK(scl_in), .RD(
        n11), .Q(trcv_start_rst_d) );
  SEH_FDPRBQ_V2_1P5 sda_del_cnt_reg4 ( .D(n450), .CK(del_clk), .RD(
        del_rstn_async), .Q(sda_del_cnt4) );
  SEH_FDPSBQ_1 i2c_trdy_reg ( .D(n468), .CK(sb_clk_i), .SD(n4), .Q(i2c_trdy)
         );
  SEH_FDPSBQ_1 mc_scl_out_reg ( .D(N378), .CK(sb_clk_i), .SD(n5), .Q(
        mc_scl_out) );
  SEH_FDPSBQ_1 tr_scl_out_reg ( .D(n435), .CK(sb_clk_i), .SD(n5), .Q(
        tr_scl_out) );
  SEH_FDPSBQ_1 mc_sda_out_reg ( .D(N377), .CK(sb_clk_i), .SD(n3), .Q(
        mc_sda_out) );
  SEH_FDPSBQ_1 sda_out_sense_r_reg ( .D(n386), .CK(del_clk), .SD(
        del_rstn_async), .Q(sda_out_sense_r) );
  SEH_FDPRBQ_V2_1P5 sda_no_del_reg ( .D(N488), .CK(del_clk), .RD(
        del_rstn_async), .Q(sda_no_del) );
  SEH_FDPSBQ_1 rcv_reg_reg1 ( .D(n524), .CK(scl_in), .SD(n10), .Q(rcv_reg1) );
  SEH_FDPSBQ_1 rcv_reg_reg2 ( .D(n523), .CK(scl_in), .SD(n10), .Q(rcv_reg2) );
  SEH_FDPSBQ_1 rcv_reg_reg3 ( .D(n522), .CK(scl_in), .SD(n10), .Q(rcv_reg3) );
  SEH_FDPSBQ_1 rcv_reg_reg5 ( .D(n520), .CK(scl_in), .SD(n10), .Q(rcv_reg5) );
  SEH_FDPSBQ_1 rcv_reg_reg6 ( .D(n519), .CK(scl_in), .SD(n10), .Q(rcv_reg6) );
  SEH_FDPSBQ_1 rcv_reg_reg7 ( .D(n518), .CK(scl_in), .SD(n10), .Q(rcv_reg7) );
  SEH_FDPSBQ_1 rcv_reg_reg4 ( .D(n521), .CK(scl_in), .SD(n10), .Q(rcv_reg4) );
  SEH_FDPSBQ_1 rcv_arc_reg ( .D(n500), .CK(scl_in), .SD(n10), .Q(rcv_arc) );
  SEH_FDPSBQ_1 rcv_reg_reg0 ( .D(n525), .CK(scl_in), .SD(n10), .Q(rcv_reg0) );
  SEH_FDPQ_V2_1 i2c_busy_sync_reg ( .D(i2c_busy_sync0), .CK(sb_clk_i), .Q(
        i2csr[6]) );
  SEH_FDPRBQ_V2_1P5 trcv_cnt_reg2 ( .D(n526), .CK(scl_in), .RD(n11), .Q(
        trcv_cnt2) );
  SEH_FDPRBQ_V2_1P5 trcv_cnt_reg1 ( .D(n527), .CK(scl_in), .RD(n11), .Q(
        trcv_cnt1) );
  SEH_FDPRBQ_V2_1P5 trcv_cnt_reg0 ( .D(n528), .CK(scl_in), .RD(n11), .Q(
        trcv_cnt0) );
  SEH_FDNRBSBQ_1 trn_reg_reg7 ( .D(n469), .CK(scl_in), .RD(n365), .SD(n366), 
        .Q(trn_reg7) );
  SEH_FDNRBQ_V2_1 mc_trn_en_reg ( .D(N376), .CK(sb_clk_i), .RD(n2), .Q(
        mc_trn_en) );
  SEH_FDNRBQ_V2_1 rcv_rw_reg ( .D(n529), .CK(scl_in), .RD(n11), .Q(rcv_rw) );
  SEH_FDNRBQ_V2_1 trst_data_reg ( .D(N78), .CK(scl_in), .RD(n11), .Q(trst_data) );
  SEH_FDNRBQ_V2_1 tr_state_reg1 ( .D(N106), .CK(scl_in), .RD(n11), .Q(
        tr_state1) );
  SEH_FDNRBQ_V2_1 tr_state_reg0 ( .D(N105), .CK(scl_in), .RD(n11), .Q(
        tr_state0) );
  SEH_FDNRBQ_V2_1 tr_state_reg2 ( .D(N107), .CK(scl_in), .RD(n11), .Q(
        tr_state2) );
  SEH_FDPQ_V2_1 i2c_tip_sync0_reg ( .D(N171), .CK(sb_clk_i), .Q(i2c_tip_sync0)
         );
  SEH_FDPQ_V2_1 i2c_busy_sync0_reg ( .D(n85), .CK(sb_clk_i), .Q(i2c_busy_sync0) );
  SEH_FDPQ_V2_1 addr_ok_sync0_reg ( .D(n425), .CK(sb_clk_i), .Q(addr_ok_sync0)
         );
  SEH_FDPSBQ_1 del_cnt_set_sense_reg2 ( .D(i2ccr1_wt), .CK(del_clk), .SD(
        del_rstn_async), .Q(del_cnt_set_sense2) );
  SEH_FDNRBQ_V2_1 i2c_rcv_sync0_reg ( .D(n35), .CK(scl_in), .RD(n2), .Q(
        i2c_rcv_sync0) );
  SEH_FDPQ_V2_1 mst_scl_sense0_reg ( .D(mc_scl_out), .CK(sb_clk_i), .Q(
        mst_scl_sense0) );
  SEH_FDPQ_V2_1 i2c_rarc_sync0_reg ( .D(rcv_arc), .CK(sb_clk_i), .Q(
        i2c_rarc_sync0) );
  SEH_FDPQ_V2_1 i2c_srw_sync0_reg ( .D(rcv_rw), .CK(sb_clk_i), .Q(
        i2c_srw_sync0) );
  SEH_FDPQ_V2_1 i2c_scl_sense0_reg ( .D(scl_in), .CK(sb_clk_i), .Q(
        i2c_scl_sense0) );
  SEH_FDPCBQ_1 trst_rw_ok_sync0_reg ( .D(trst_data), .RS(rcv_rw), .CK(sb_clk_i), .Q(trst_rw_ok_sync0) );
  SEH_FDPRBQ_V2_1P5 trst_arc_d_sync_reg ( .D(trst_arc_d_sync0), .CK(sb_clk_i), 
        .RD(n3), .Q(trst_arc_d_sync) );
  SEH_FDPRBQ_V2_1P5 exec_stsp_det_reg0 ( .D(exec_stsp_det1), .CK(sb_clk_i), 
        .RD(n5), .Q(exec_stsp_det0) );
  SEH_FDPRBQ_V2_1P5 i2c_arbl_reg ( .D(n489), .CK(sb_clk_i), .RD(n2), .Q(
        i2csr[3]) );
  SEH_FDPRBQ_V2_1P5 i2c_toe_reg ( .D(n467), .CK(sb_clk_i), .RD(n4), .Q(i2c_toe) );
  SEH_FDPRBQ_V2_1P5 exec_stsp_det_reg1 ( .D(exec_stsp), .CK(sb_clk_i), .RD(n4), 
        .Q(exec_stsp_det1) );
  SEH_FDPRBQ_V2_1P5 trn_rw_reg ( .D(n483), .CK(sb_clk_i), .RD(n4), .Q(trn_rw)
         );
  SEH_FDPRBQ_V2_1P5 i2c_hgc_reg ( .D(n498), .CK(sb_clk_i), .RD(n3), .Q(
        i2csr[0]) );
  SEH_FDPRBQ_V2_1P5 mcmd_stop_reg ( .D(n486), .CK(sb_clk_i), .RD(n4), .Q(
        mcmd_stop) );
  SEH_FDPRBQ_V2_1P5 i2c_rrdy_reg ( .D(n458), .CK(sb_clk_i), .RD(n4), .Q(
        i2c_rrdy) );
  SEH_FDPRBQ_V2_1P5 mcmd_start_reg ( .D(n484), .CK(sb_clk_i), .RD(n4), .Q(
        mcmd_start) );
  SEH_FDPRBQ_V2_1P5 i2c_roe_reg ( .D(n457), .CK(sb_clk_i), .RD(n4), .Q(i2c_roe) );
  SEH_FDPRBQ_V2_1P5 mcmd_stcmd_reg ( .D(n485), .CK(sb_clk_i), .RD(n4), .Q(
        mcmd_stcmd) );
  SEH_FDPRBQ_V2_1P5 ckstr_flag_reg ( .D(n434), .CK(sb_clk_i), .RD(n4), .Q(
        ckstr_flag) );
  SEH_FDPRBQ_V2_1P5 mc_state_reg1 ( .D(n478), .CK(sb_clk_i), .RD(n4), .Q(
        mc_state1) );
  SEH_FDPRBQ_V2_1P5 mc_state_reg2 ( .D(n479), .CK(sb_clk_i), .RD(n2), .Q(
        mc_state2) );
  SEH_FDPRBQ_V2_1P5 mc_state_reg0 ( .D(n477), .CK(sb_clk_i), .RD(n4), .Q(
        mc_state0) );
  SEH_FDPRBQ_V2_1P5 mc_state_reg3 ( .D(n4880), .CK(sb_clk_i), .RD(n3), .Q(
        mc_state3) );
  SEH_FDPRBQ_V2_1P5 cmd_exec_active_reg ( .D(n487), .CK(sb_clk_i), .RD(n5), 
        .Q(cmd_exec_active) );
  SEH_FDPRBQ_V2_1P5 cmd_exec_wt_reg ( .D(n482), .CK(sb_clk_i), .RD(n5), .Q(
        cmd_exec_wt) );
  SEH_FDPRBQ_V2_1P5 del_zero_states_reg ( .D(N379), .CK(sb_clk_i), .RD(n5), 
        .Q(del_zero_states) );
  SEH_FDPRBQ_V2_1P5 mcst_master_reg ( .D(n476), .CK(sb_clk_i), .RD(n5), .Q(
        mcst_master) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg9 ( .D(n480), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt9) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg8 ( .D(n441), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt8) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg7 ( .D(n442), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt7) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg6 ( .D(n443), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt6) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg5 ( .D(n444), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt5) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg4 ( .D(n445), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt4) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg3 ( .D(n446), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt3) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg15 ( .D(n481), .CK(sb_clk_i), .RD(n2), .Q(
        clk_cnt15) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg14 ( .D(n436), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt14) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg13 ( .D(n437), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt13) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg12 ( .D(n438), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt12) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg11 ( .D(n439), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt11) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg10 ( .D(n440), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt10) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg2 ( .D(n447), .CK(sb_clk_i), .RD(n5), .Q(
        clk_cnt2) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg1 ( .D(n448), .CK(sb_clk_i), .RD(n3), .Q(
        clk_cnt1) );
  SEH_FDPRBQ_V2_1P5 clk_cnt_reg0 ( .D(n449), .CK(sb_clk_i), .RD(n2), .Q(
        clk_cnt0) );
  SEH_FDPRBQ_V2_1P5 i2crxdr_reg7 ( .D(n459), .CK(sb_clk_i), .RD(n4), .Q(
        i2crxdr[7]) );
  SEH_FDPRBQ_V2_1P5 i2crxdr_reg6 ( .D(n460), .CK(sb_clk_i), .RD(n4), .Q(
        i2crxdr[6]) );
  SEH_FDPRBQ_V2_1P5 i2crxdr_reg5 ( .D(n461), .CK(sb_clk_i), .RD(n4), .Q(
        i2crxdr[5]) );
  SEH_FDPRBQ_V2_1P5 i2crxdr_reg4 ( .D(n462), .CK(sb_clk_i), .RD(n4), .Q(
        i2crxdr[4]) );
  SEH_FDPRBQ_V2_1P5 i2crxdr_reg3 ( .D(n463), .CK(sb_clk_i), .RD(n4), .Q(
        i2crxdr[3]) );
  SEH_FDPRBQ_V2_1P5 i2crxdr_reg2 ( .D(n464), .CK(sb_clk_i), .RD(n4), .Q(
        i2crxdr[2]) );
  SEH_FDPRBQ_V2_1P5 i2crxdr_reg1 ( .D(n465), .CK(sb_clk_i), .RD(n4), .Q(
        i2crxdr[1]) );
  SEH_FDPRBQ_V2_1P5 i2crxdr_reg0 ( .D(n466), .CK(sb_clk_i), .RD(n4), .Q(
        i2crxdr[0]) );
  SEH_FDPRBQ_V2_1P5 i2cgcdr_reg1 ( .D(n491), .CK(sb_clk_i), .RD(n2), .Q(
        i2cgcdr[1]) );
  SEH_FDPRBQ_V2_1P5 i2cgcdr_reg3 ( .D(n493), .CK(sb_clk_i), .RD(n2), .Q(
        i2cgcdr[3]) );
  SEH_FDPRBQ_V2_1P5 i2cgcdr_reg0 ( .D(n490), .CK(sb_clk_i), .RD(n3), .Q(
        i2cgcdr[0]) );
  SEH_FDPRBQ_V2_1P5 i2cgcdr_reg2 ( .D(n492), .CK(sb_clk_i), .RD(n3), .Q(
        i2cgcdr[2]) );
  SEH_FDPRBQ_V2_1P5 i2cgcdr_reg7 ( .D(n497), .CK(sb_clk_i), .RD(n2), .Q(
        i2cgcdr[7]) );
  SEH_FDPRBQ_V2_1P5 i2cgcdr_reg6 ( .D(n496), .CK(sb_clk_i), .RD(n3), .Q(
        i2cgcdr[6]) );
  SEH_FDPRBQ_V2_1P5 i2cgcdr_reg5 ( .D(n495), .CK(sb_clk_i), .RD(n2), .Q(
        i2cgcdr[5]) );
  SEH_FDPRBQ_V2_1P5 i2cgcdr_reg4 ( .D(n494), .CK(sb_clk_i), .RD(n3), .Q(
        i2cgcdr[4]) );
  SEH_FDPRBQ_V2_1P5 trst_arc_d_sync0_reg ( .D(n422), .CK(sb_clk_i), .RD(n2), 
        .Q(trst_arc_d_sync0) );
  SEH_FDPRBQ_V2_1P5 addr_ok_usr_sync0_reg ( .D(n425), .CK(scl_in), .RD(n3), 
        .Q(addr_ok_usr_sync0) );
  SEH_FDPRBQ_V2_1P5 i2c_rcv_ok_reg ( .D(n383), .CK(scl_in), .RD(n382), .Q(
        i2c_rcv_ok) );
  SEH_FDNRBQ_V2_1 i2c_trn_sync0_reg ( .D(N172), .CK(scl_in), .RD(n2), .Q(
        i2c_trn_sync0) );
  SEH_FDNRBSBQ_1 trn_ack_reg ( .D(n499), .CK(scl_in), .RD(Logic1), .SD(n432), 
        .Q(trn_ack) );
  SEH_FDNRBSBQ_1 trst_idle_reg ( .D(N73), .CK(scl_in), .RD(Logic1), .SD(n11), 
        .Q(trst_idle) );
  SEH_FDNRBSBQ_1 rcv_data_reg7 ( .D(n403), .CK(scl_in), .RD(Logic1), .SD(n3), 
        .Q(rcv_data7) );
  SEH_FDNRBSBQ_1 rcv_data_reg6 ( .D(n401), .CK(scl_in), .RD(Logic1), .SD(n3), 
        .Q(rcv_data6) );
  SEH_FDNRBSBQ_1 rcv_data_reg5 ( .D(n399), .CK(scl_in), .RD(Logic1), .SD(n3), 
        .Q(rcv_data5) );
  SEH_FDNRBSBQ_1 rcv_data_reg4 ( .D(n397), .CK(scl_in), .RD(Logic1), .SD(n3), 
        .Q(rcv_data4) );
  SEH_FDNRBSBQ_1 rcv_data_reg3 ( .D(n395), .CK(scl_in), .RD(Logic1), .SD(n2), 
        .Q(rcv_data3) );
  SEH_FDNRBSBQ_1 rcv_data_reg2 ( .D(n393), .CK(scl_in), .RD(Logic1), .SD(n2), 
        .Q(rcv_data2) );
  SEH_FDNRBSBQ_1 rcv_data_reg1 ( .D(n391), .CK(scl_in), .RD(Logic1), .SD(n2), 
        .Q(rcv_data1) );
  SEH_FDNRBSBQ_1 rcv_data_reg0 ( .D(n389), .CK(scl_in), .RD(Logic1), .SD(n2), 
        .Q(rcv_data0) );
  SEH_FDNRBSBQ_1 rcv_addr_reg3 ( .D(n514), .CK(scl_in), .RD(Logic1), .SD(n11), 
        .Q(rcv_addr3) );
  SEH_FDNRBSBQ_1 rcv_info_reg7 ( .D(n5080), .CK(scl_in), .RD(Logic1), .SD(n11), 
        .Q(rcv_info7) );
  SEH_FDNRBSBQ_1 rcv_info_reg6 ( .D(n5070), .CK(scl_in), .RD(Logic1), .SD(n10), 
        .Q(rcv_info6) );
  SEH_FDNRBSBQ_1 rcv_info_reg5 ( .D(n5060), .CK(scl_in), .RD(Logic1), .SD(n10), 
        .Q(rcv_info5) );
  SEH_FDNRBSBQ_1 rcv_info_reg4 ( .D(n5050), .CK(scl_in), .RD(Logic1), .SD(n10), 
        .Q(rcv_info4) );
  SEH_FDNRBSBQ_1 rcv_info_reg3 ( .D(n504), .CK(scl_in), .RD(Logic1), .SD(n10), 
        .Q(rcv_info3) );
  SEH_FDNRBSBQ_1 rcv_info_reg2 ( .D(n503), .CK(scl_in), .RD(Logic1), .SD(n10), 
        .Q(rcv_info2) );
  SEH_FDNRBSBQ_1 rcv_info_reg1 ( .D(n502), .CK(scl_in), .RD(Logic1), .SD(n10), 
        .Q(rcv_info1) );
  SEH_FDNRBSBQ_1 rcv_info_reg0 ( .D(n501), .CK(scl_in), .RD(Logic1), .SD(n10), 
        .Q(rcv_info0) );
  SEH_FDNRBSBQ_1 rcv_addr_reg6 ( .D(n511), .CK(scl_in), .RD(Logic1), .SD(n11), 
        .Q(rcv_addr6) );
  SEH_FDNRBSBQ_1 rcv_addr_reg5 ( .D(n512), .CK(scl_in), .RD(Logic1), .SD(n11), 
        .Q(rcv_addr5) );
  SEH_FDNRBSBQ_1 rcv_addr_reg4 ( .D(n513), .CK(scl_in), .RD(Logic1), .SD(n11), 
        .Q(rcv_addr4) );
  SEH_FDNRBSBQ_1 rcv_addr_reg2 ( .D(n515), .CK(scl_in), .RD(Logic1), .SD(n11), 
        .Q(rcv_addr2) );
  SEH_FDNRBSBQ_1 rcv_addr_reg1 ( .D(n516), .CK(scl_in), .RD(Logic1), .SD(n10), 
        .Q(rcv_addr1) );
  SEH_FDNRBSBQ_1 rcv_addr_reg0 ( .D(n517), .CK(scl_in), .RD(Logic1), .SD(n11), 
        .Q(rcv_addr0) );
  SEH_FDNRBQ_V2_1 trst_ack_all_nd_reg ( .D(n57), .CK(scl_in), .RD(n2), .Q(
        trst_ack_all_nd) );
  SEH_FDPRBQ_V2_1P5 trst_ack_all_pd_reg ( .D(trst_ack_all_nd), .CK(scl_in), 
        .RD(n3), .Q(trst_ack_all_pd) );
  SEH_TIE1_G_1 U3 ( .X(Logic1) );
  SEH_AO21_1 U4 ( .A1(trcv_cnt0), .A2(n31), .B(n251), .X(n263) );
  SEH_AOA211_DG_1 U5 ( .A1(mcmd_stcmd), .A2(n266), .B(mcmd_start), .C(n1), .X(
        n484) );
  SEH_INV_S_1 U6 ( .A(n2080), .X(n1) );
  SEH_OAI2111_1 U7 ( .A1(n2070), .A2(n228), .B1(n148), .B2(n311), .B3(n312), 
        .X(n2030) );
  SEH_INV_S_0P5 U8 ( .A(i2c_rst_async), .X(n2) );
  SEH_INV_S_0P5 U9 ( .A(i2c_rst_async), .X(n3) );
  SEH_INV_1 U10 ( .A(i2c_rst_async), .X(n4) );
  SEH_INV_1 U11 ( .A(i2c_rst_async), .X(n5) );
  SEH_BUF_D_8 U12 ( .A(n402), .X(scl_oe) );
  SEH_INV_8 U13 ( .A(n402), .X(scl_out) );
  SEH_ND2_G_1 U14 ( .A1(tr_scl_out), .A2(mc_scl_out), .X(n402) );
  SEH_BUF_D_8 U15 ( .A(n404), .X(i2c_wkup) );
  SEH_AO2BB2_DG_1 U16 ( .A1(n280), .A2(n281), .B1(i2ccr1[5]), .B2(n282), .X(
        n404) );
  SEH_INV_8 U17 ( .A(n32), .X(sda_oe) );
  SEH_INV_8 U18 ( .A(n400), .X(sda_out) );
  SEH_OA2BB2_1 U19 ( .A1(sda_out_int), .A2(sda_no_del), .B1(sda_no_del), .B2(
        n187), .X(n400) );
  SEH_NR3_G_1 U20 ( .A1(i2csaddr_wt), .A2(i2ccr1_wt), .A3(i2cbr_wt), .X(n75)
         );
  SEH_OAI2111_1 U21 ( .A1(exec_stsp), .A2(n191), .B1(n297), .B2(n2210), .B3(
        n298), .X(n294) );
  SEH_ND3B_V1DG_1 U22 ( .A(n181), .B1(n180), .B2(n182), .X(n93) );
  SEH_NR2B_1 U23 ( .A(n180), .B(n182), .X(n79) );
  SEH_INV_S_1 U24 ( .A(n10), .X(n12) );
  SEH_AOI32_1 U25 ( .A1(n282), .A2(n232), .A3(rcv_rw), .B1(n324), .B2(
        mc_trn_en), .X(n30) );
  SEH_ND4_S_1 U26 ( .A1(i2ccr1[7]), .A2(n1050), .A3(rcv_addr3), .A4(n363), .X(
        n52) );
  SEH_ND4_S_1 U27 ( .A1(n344), .A2(n345), .A3(n346), .A4(n347), .X(n55) );
  SEH_ND4_S_1 U28 ( .A1(n325), .A2(n326), .A3(n327), .A4(n328), .X(n48) );
  SEH_EO2_0P5 U29 ( .A1(n100), .A2(n338), .X(n54) );
  SEH_EO2_0P5 U30 ( .A1(n96), .A2(n336), .X(n53) );
  SEH_ND3_1 U31 ( .A1(tr_state0), .A2(n87), .A3(tr_state2), .X(n43) );
  SEH_ND4_S_1 U32 ( .A1(mcmd_start), .A2(n313), .A3(i2ccmdr[7]), .A4(n433), 
        .X(n2050) );
  SEH_NR4B_1 U33 ( .A(n320), .B1(n287), .B2(n163), .B3(i2ccmdr[7]), .X(n310)
         );
  SEH_OAI211_1 U34 ( .A1(n301), .A2(n2050), .B1(n148), .B2(n303), .X(n290) );
  SEH_OAI21_G_1 U35 ( .A1(n2070), .A2(n228), .B(n307), .X(n292) );
  SEH_OAI211_1 U36 ( .A1(trcv_start_rst_d), .A2(n29), .B1(n424), .B2(n85), .X(
        n251) );
  SEH_ND3_1 U37 ( .A1(trcv_cnt1), .A2(trcv_cnt0), .A3(trcv_cnt2), .X(n67) );
  SEH_NR4_2 U38 ( .A1(n67), .A2(n87), .A3(tr_state0), .A4(tr_state2), .X(n244)
         );
  SEH_AOI21_S_1 U39 ( .A1(n91), .A2(n246), .B(trcv_stop), .X(n245) );
  SEH_ND3_1 U40 ( .A1(mc_state2), .A2(mc_state0), .A3(mc_state3), .X(n2210) );
  SEH_OAOI211_1 U41 ( .A1(n287), .A2(n1980), .B(n76), .C(n286), .X(n180) );
  SEH_OR3B_1 U42 ( .B1(upd_gcdr_sync1), .B2(n286), .A(upd_gcdr_sync0), .X(n229) );
  SEH_ND4_S_1 U43 ( .A1(n2230), .A2(n2240), .A3(n2250), .A4(n226), .X(n76) );
  SEH_ND4_S_1 U44 ( .A1(trcv_cnt6_sync2), .A2(i2c_scl_sense), .A3(n1930), .A4(
        n232), .X(n182) );
  SEH_INV_S_1 U45 ( .A(trcv_start), .X(n29) );
  SEH_INV_S_1 U46 ( .A(n186), .X(n138) );
  SEH_INV_S_1 U47 ( .A(n2180), .X(n142) );
  SEH_INV_S_1 U48 ( .A(n141), .X(n176) );
  SEH_INV_S_1 U49 ( .A(n294), .X(n152) );
  SEH_INV_S_1 U50 ( .A(n313), .X(n163) );
  SEH_INV_S_1 U51 ( .A(n75), .X(n286) );
  SEH_INV_S_1 U52 ( .A(n14), .X(n35) );
  SEH_INV_S_1 U53 ( .A(n31), .X(n62) );
  SEH_INV_S_1 U54 ( .A(n267), .X(n26) );
  SEH_INV_S_1 U55 ( .A(n257), .X(n28) );
  SEH_INV_S_1 U56 ( .A(n305), .X(n191) );
  SEH_INV_S_1 U57 ( .A(n299), .X(n192) );
  SEH_INV_S_1 U58 ( .A(n424), .X(n57) );
  SEH_ND4_S_1 U59 ( .A1(n147), .A2(n152), .A3(n143), .A4(n139), .X(n186) );
  SEH_INV_S_1 U60 ( .A(n93), .X(n137) );
  SEH_NR2_G_1 U61 ( .A1(n286), .A2(n158), .X(n159) );
  SEH_ND2_G_1 U62 ( .A1(n143), .A2(n294), .X(n2180) );
  SEH_ND2_G_1 U63 ( .A1(n142), .A2(n147), .X(n288) );
  SEH_INV_S_1 U64 ( .A(n167), .X(n2100) );
  SEH_NR2_G_1 U65 ( .A1(n179), .A2(n130), .X(n141) );
  SEH_INV_S_1 U66 ( .A(n12), .X(n11) );
  SEH_INV_S_1 U67 ( .A(n30), .X(n33) );
  SEH_ND2_G_1 U68 ( .A1(n55), .A2(n48), .X(n282) );
  SEH_INV_S_1 U69 ( .A(n52), .X(n103) );
  SEH_OAI21_G_1 U70 ( .A1(n425), .A2(n49), .B(n30), .X(n14) );
  SEH_NR2_G_1 U71 ( .A1(n87), .A2(n271), .X(n45) );
  SEH_INV_S_1 U72 ( .A(n9), .X(n63) );
  SEH_AOAI211_G_1 U73 ( .A1(n45), .A2(n46), .B(n47), .C(n232), .X(n44) );
  SEH_OAI311_1 U74 ( .A1(n52), .A2(n53), .A3(n54), .B1(n55), .B2(n40), .X(n46)
         );
  SEH_AOI31_G_1 U75 ( .A1(n48), .A2(n20), .A3(n16), .B(n17), .X(n47) );
  SEH_INV_S_1 U76 ( .A(n50), .X(n40) );
  SEH_NR2_G_1 U77 ( .A1(n2200), .A2(n274), .X(n277) );
  SEH_INV_S_1 U78 ( .A(n54), .X(n99) );
  SEH_INV_S_1 U79 ( .A(n53), .X(n94) );
  SEH_INV_S_1 U80 ( .A(n20), .X(n49) );
  SEH_INV_S_1 U81 ( .A(n274), .X(n65) );
  SEH_ND2_G_1 U82 ( .A1(n299), .A2(n2070), .X(n297) );
  SEH_INV_S_1 U83 ( .A(n2030), .X(n147) );
  SEH_ND2_G_1 U84 ( .A1(n2050), .A2(n162), .X(exec_stsp) );
  SEH_INV_S_1 U85 ( .A(n310), .X(n162) );
  SEH_INV_S_1 U86 ( .A(n292), .X(n139) );
  SEH_AOI211_G_1 U87 ( .A1(n147), .A2(n295), .B1(n286), .B2(n152), .X(N376) );
  SEH_ND2_G_1 U88 ( .A1(n139), .A2(n290), .X(n295) );
  SEH_INV_S_1 U89 ( .A(n304), .X(n155) );
  SEH_NR2_G_1 U90 ( .A1(n2170), .A2(n2130), .X(n313) );
  SEH_NR2_G_1 U91 ( .A1(n251), .A2(n62), .X(n267) );
  SEH_NR2_G_1 U92 ( .A1(n63), .A2(n422), .X(n31) );
  SEH_NR3_G_1 U93 ( .A1(n318), .A2(n287), .A3(n296), .X(n433) );
  SEH_AO2BB2_DG_1 U94 ( .A1(n38), .A2(n187), .B1(sda_out_int), .B2(n38), .X(
        n386) );
  SEH_INV_S_1 U95 ( .A(n244), .X(n61) );
  SEH_NR2_G_1 U96 ( .A1(n323), .A2(n2000), .X(n305) );
  SEH_ND2_G_1 U97 ( .A1(n246), .A2(n29), .X(n257) );
  SEH_NR2_G_1 U98 ( .A1(n65), .A2(n67), .X(n246) );
  SEH_AN3B_1 U99 ( .B1(n17), .B2(n43), .A(n45), .X(n424) );
  SEH_OAI221_0P5 U100 ( .A1(n91), .A2(n61), .B1(n244), .B2(n134), .C(n245), 
        .X(n501) );
  SEH_OAI221_0P5 U101 ( .A1(n92), .A2(n61), .B1(n244), .B2(n128), .C(n245), 
        .X(n502) );
  SEH_OAI221_0P5 U102 ( .A1(n97), .A2(n61), .B1(n244), .B2(n127), .C(n245), 
        .X(n503) );
  SEH_OAI221_0P5 U103 ( .A1(n102), .A2(n61), .B1(n244), .B2(n126), .C(n245), 
        .X(n504) );
  SEH_OAI221_0P5 U104 ( .A1(n1060), .A2(n61), .B1(n244), .B2(n124), .C(n245), 
        .X(n5050) );
  SEH_OAI221_0P5 U105 ( .A1(n108), .A2(n61), .B1(n244), .B2(n121), .C(n245), 
        .X(n5060) );
  SEH_OAI221_0P5 U106 ( .A1(n112), .A2(n61), .B1(n244), .B2(n120), .C(n245), 
        .X(n5070) );
  SEH_OAI221_0P5 U107 ( .A1(n116), .A2(n61), .B1(n244), .B2(n119), .C(n245), 
        .X(n5080) );
  SEH_OAI221_0P5 U108 ( .A1(n28), .A2(n117), .B1(n116), .B2(n257), .C(n29), 
        .X(n511) );
  SEH_OAI221_0P5 U109 ( .A1(n28), .A2(n113), .B1(n112), .B2(n257), .C(n29), 
        .X(n512) );
  SEH_OAI221_0P5 U110 ( .A1(n28), .A2(n109), .B1(n108), .B2(n257), .C(n29), 
        .X(n513) );
  SEH_OAI221_0P5 U111 ( .A1(n28), .A2(n1050), .B1(n102), .B2(n257), .C(n29), 
        .X(n515) );
  SEH_OAI221_0P5 U112 ( .A1(n28), .A2(n100), .B1(n97), .B2(n257), .C(n29), .X(
        n516) );
  SEH_OAI221_0P5 U113 ( .A1(n28), .A2(n96), .B1(n92), .B2(n257), .C(n29), .X(
        n517) );
  SEH_OAI221_0P5 U114 ( .A1(n91), .A2(n9), .B1(n63), .B2(n396), .C(n85), .X(
        n525) );
  SEH_OAI221_0P5 U115 ( .A1(n112), .A2(n9), .B1(n63), .B2(n108), .C(n85), .X(
        n519) );
  SEH_OAI221_0P5 U116 ( .A1(n108), .A2(n9), .B1(n63), .B2(n1060), .C(n85), .X(
        n520) );
  SEH_OAI221_0P5 U117 ( .A1(n102), .A2(n9), .B1(n63), .B2(n97), .C(n85), .X(
        n522) );
  SEH_OAI221_0P5 U118 ( .A1(n97), .A2(n9), .B1(n63), .B2(n92), .C(n85), .X(
        n523) );
  SEH_OAI221_0P5 U119 ( .A1(n92), .A2(n9), .B1(n63), .B2(n91), .C(n85), .X(
        n524) );
  SEH_OAI221_0P5 U120 ( .A1(n1060), .A2(n9), .B1(n63), .B2(n102), .C(n85), .X(
        n521) );
  SEH_OAI221_0P5 U121 ( .A1(n116), .A2(n9), .B1(n63), .B2(n112), .C(n85), .X(
        n518) );
  SEH_ND2_G_1 U122 ( .A1(n2000), .A2(n228), .X(n299) );
  SEH_INV_S_1 U123 ( .A(n359), .X(n59) );
  SEH_OAI221_0P5 U124 ( .A1(n360), .A2(n87), .B1(n271), .B2(n67), .C(n43), .X(
        n359) );
  SEH_NR2_G_1 U125 ( .A1(n60), .A2(n67), .X(n360) );
  SEH_INV_S_1 U126 ( .A(n2210), .X(n2020) );
  SEH_OAI22_S_1 U127 ( .A1(n424), .A2(n396), .B1(n57), .B2(n135), .X(n500) );
  SEH_INV_S_1 U128 ( .A(n322), .X(n148) );
  SEH_OAI221_0P5 U129 ( .A1(n228), .A2(n323), .B1(n323), .B2(n299), .C(n298), 
        .X(n322) );
  SEH_INV_S_1 U130 ( .A(n285), .X(n37) );
  SEH_AN3B_1 U131 ( .B1(N107), .B2(n285), .A(n59), .X(N78) );
  SEH_OR4B_1 U132 ( .B1(n79), .B2(n137), .B3(n80), .A(n180), .X(n83) );
  SEH_INV_S_1 U133 ( .A(n290), .X(n143) );
  SEH_AO221_0P5 U134 ( .A1(N203), .A2(n79), .B1(N220), .B2(n80), .C(n90), .X(
        n440) );
  SEH_NR2_G_1 U135 ( .A1(n253), .A2(n83), .X(n90) );
  SEH_OAI21_G_1 U136 ( .A1(n2210), .A2(n189), .B(n2100), .X(n169) );
  SEH_OAI221_0P5 U137 ( .A1(n152), .A2(n292), .B1(n294), .B2(n2030), .C(n293), 
        .X(N377) );
  SEH_OAI32_1 U138 ( .A1(n76), .A2(n138), .A3(n286), .B1(n232), .B2(n167), .X(
        n476) );
  SEH_OAI211_1 U139 ( .A1(n2210), .A2(n189), .B1(n169), .B2(n75), .X(n1710) );
  SEH_AOI21_S_1 U140 ( .A1(n2030), .A2(n292), .B(n286), .X(n293) );
  SEH_ND2_G_1 U141 ( .A1(n75), .A2(n76), .X(n167) );
  SEH_AN2_1 U142 ( .A1(n156), .A2(n75), .X(n158) );
  SEH_NR2B_1 U143 ( .A(n229), .B(n286), .X(n230) );
  SEH_OAI22_S_1 U144 ( .A1(n2070), .A2(n169), .B1(n147), .B2(n1710), .X(n479)
         );
  SEH_NR2_G_1 U145 ( .A1(n156), .A2(n173), .X(n154) );
  SEH_INV_S_1 U146 ( .A(n157), .X(n1720) );
  SEH_NR2_G_1 U147 ( .A1(n286), .A2(n2130), .X(n2010) );
  SEH_OAI22_S_1 U148 ( .A1(n2000), .A2(n169), .B1(n152), .B2(n1710), .X(n4880)
         );
  SEH_ND2_G_1 U149 ( .A1(n2010), .A2(n2120), .X(n2080) );
  SEH_OAI22_S_1 U150 ( .A1(n231), .A2(n169), .B1(n139), .B2(n1710), .X(n477)
         );
  SEH_OAI22_S_1 U151 ( .A1(n228), .A2(n169), .B1(n143), .B2(n1710), .X(n478)
         );
  SEH_AOAI211_G_1 U152 ( .A1(n288), .A2(n289), .B(n286), .C(N377), .X(N379) );
  SEH_ND3_1 U153 ( .A1(n290), .A2(n2030), .A3(n152), .X(n289) );
  SEH_OAI211_1 U154 ( .A1(n291), .A2(n292), .B1(n288), .B2(n293), .X(N378) );
  SEH_AOI22_1 U155 ( .A1(n147), .A2(n143), .B1(n152), .B2(n290), .X(n291) );
  SEH_AO2BB2_DG_1 U156 ( .A1(n151), .A2(n264), .B1(n153), .B2(n151), .X(n457)
         );
  SEH_AOI21_S_1 U157 ( .A1(n262), .A2(n153), .B(n154), .X(n151) );
  SEH_INV_S_1 U158 ( .A(n153), .X(n173) );
  SEH_NR4_1 U159 ( .A1(n234), .A2(n253), .A3(n255), .A4(n256), .X(n1970) );
  SEH_NR4_1 U160 ( .A1(n258), .A2(n235), .A3(n209), .A4(n236), .X(n1960) );
  SEH_NR2_G_1 U161 ( .A1(n269), .A2(n179), .X(n130) );
  SEH_INV_S_1 U162 ( .A(n145), .X(n179) );
  SEH_NR2_G_1 U163 ( .A1(n25), .A2(n12), .X(n24) );
  SEH_ND2_G_1 U164 ( .A1(n11), .A2(n25), .X(n23) );
  SEH_ND2_G_1 U165 ( .A1(n24), .A2(n302), .X(n3790) );
  SEH_NR2_G_1 U166 ( .A1(i2c_rst_async), .A2(n286), .X(n530) );
  SEH_INV_S_1 U167 ( .A(scan_test_mode), .X(n398) );
  SEH_NR2_G_1 U168 ( .A1(n232), .A2(n277), .X(n324) );
  SEH_NR3_G_1 U169 ( .A1(n117), .A2(n109), .A3(n113), .X(n363) );
  SEH_EO2_0P5 U170 ( .A1(i2csaddr[1]), .A2(n126), .X(n325) );
  SEH_EO2_0P5 U171 ( .A1(i2csaddr[2]), .A2(n124), .X(n326) );
  SEH_NR3_G_1 U172 ( .A1(n341), .A2(n342), .A3(n343), .X(n327) );
  SEH_NR2_G_1 U173 ( .A1(n30), .A2(rcv_arc), .X(N172) );
  SEH_OA311_1 U174 ( .A1(n39), .A2(trn_reg7), .A3(n63), .B1(n41), .B2(
        mc_sda_out), .X(sda_out_int) );
  SEH_ND2_G_1 U175 ( .A1(n42), .A2(trn_ack), .X(n41) );
  SEH_AOI21_S_1 U176 ( .A1(n33), .A2(mcst_master), .B(N172), .X(n39) );
  SEH_OAOI211_1 U177 ( .A1(n14), .A2(n43), .B(n44), .C(n36), .X(n42) );
  SEH_AN6_1 U178 ( .A1(n329), .A2(n330), .A3(n103), .A4(n99), .A5(n94), .A6(
        n334), .X(n328) );
  SEH_EO2_0P5 U179 ( .A1(rcv_info7), .A2(n340), .X(n329) );
  SEH_EO2_0P5 U180 ( .A1(rcv_info5), .A2(n339), .X(n330) );
  SEH_EO2_0P5 U181 ( .A1(rcv_info6), .A2(n335), .X(n334) );
  SEH_INV_S_1 U182 ( .A(rcv_addr5), .X(n113) );
  SEH_INV_S_1 U183 ( .A(rcv_addr4), .X(n109) );
  SEH_BUF_1 U184 ( .A(n241), .X(n9) );
  SEH_OAI311_1 U185 ( .A1(n87), .A2(tr_state2), .A3(tr_state0), .B1(n65), .B2(
        n660), .X(n241) );
  SEH_INV_S_1 U186 ( .A(trst_data), .X(n660) );
  SEH_ND3_1 U187 ( .A1(tr_state1), .A2(n60), .A3(tr_state2), .X(n17) );
  SEH_ND4_S_1 U188 ( .A1(rcv_info2), .A2(n126), .A3(n50), .A4(n51), .X(n16) );
  SEH_NR4_1 U189 ( .A1(rcv_info7), .A2(rcv_info6), .A3(rcv_info5), .A4(
        rcv_info4), .X(n51) );
  SEH_AOI211_G_1 U190 ( .A1(n232), .A2(rcv_arc), .B1(n63), .B2(n30), .X(n36)
         );
  SEH_NR4_1 U191 ( .A1(rcv_addr3), .A2(rcv_addr4), .A3(rcv_addr5), .A4(
        rcv_addr6), .X(n249) );
  SEH_NR2_G_1 U192 ( .A1(n337), .A2(i2csaddr[7]), .X(n338) );
  SEH_NR2_G_1 U193 ( .A1(n337), .A2(i2csaddr[6]), .X(n336) );
  SEH_ND4_S_1 U194 ( .A1(n249), .A2(n96), .A3(n362), .A4(n100), .X(n284) );
  SEH_NR2_G_1 U195 ( .A1(rcv_rw), .A2(rcv_addr2), .X(n362) );
  SEH_EO2_0P5 U196 ( .A1(rcv_addr3), .A2(i2csaddr[1]), .X(n352) );
  SEH_EO2_0P5 U197 ( .A1(rcv_addr5), .A2(n339), .X(n344) );
  SEH_EO2_0P5 U198 ( .A1(rcv_addr6), .A2(n335), .X(n345) );
  SEH_NR2_G_1 U199 ( .A1(n287), .A2(n352), .X(n346) );
  SEH_EO2_0P5 U200 ( .A1(rcv_info1), .A2(ADDR_LSB_USR[1]), .X(n343) );
  SEH_EO2_0P5 U201 ( .A1(rcv_addr4), .A2(i2csaddr[2]), .X(n351) );
  SEH_EO2_0P5 U202 ( .A1(rcv_info2), .A2(i2csaddr[0]), .X(n342) );
  SEH_NR4_1 U203 ( .A1(n348), .A2(n349), .A3(n350), .A4(n351), .X(n347) );
  SEH_EO2_0P5 U204 ( .A1(rcv_addr1), .A2(ADDR_LSB_USR[1]), .X(n349) );
  SEH_EO2_0P5 U205 ( .A1(rcv_addr0), .A2(ADDR_LSB_USR[0]), .X(n350) );
  SEH_EO2_0P5 U206 ( .A1(rcv_addr2), .A2(i2csaddr[0]), .X(n348) );
  SEH_EO2_0P5 U207 ( .A1(rcv_info0), .A2(ADDR_LSB_USR[0]), .X(n341) );
  SEH_AN3B_1 U208 ( .B1(i2ccr1[6]), .B2(i2ccr1[7]), .A(n284), .X(n50) );
  SEH_ND2_G_1 U209 ( .A1(tr_state0), .A2(n82), .X(n271) );
  SEH_NR2_G_1 U210 ( .A1(n271), .A2(tr_state1), .X(n274) );
  SEH_INV_S_1 U211 ( .A(tr_state1), .X(n87) );
  SEH_ND2_G_1 U212 ( .A1(n50), .A2(rcv_info0), .X(n20) );
  SEH_INV_S_1 U213 ( .A(tr_state0), .X(n60) );
  SEH_INV_S_1 U214 ( .A(rcv_info3), .X(n126) );
  SEH_INV_S_1 U215 ( .A(tr_state2), .X(n82) );
  SEH_INV_S_1 U216 ( .A(rcv_info4), .X(n124) );
  SEH_INV_S_1 U217 ( .A(rcv_addr2), .X(n1050) );
  SEH_INV_S_1 U218 ( .A(rcv_addr1), .X(n100) );
  SEH_INV_S_1 U219 ( .A(rcv_addr0), .X(n96) );
  SEH_INV_S_1 U220 ( .A(rcv_addr6), .X(n117) );
  SEH_OR2_1 U221 ( .A1(n282), .A2(mcst_master), .X(n425) );
  SEH_ND4_S_1 U222 ( .A1(rcv_info1), .A2(rcv_info6), .A3(n127), .A4(n126), .X(
        n280) );
  SEH_ND4_S_1 U223 ( .A1(n49), .A2(rcv_info4), .A3(rcv_info7), .A4(rcv_info5), 
        .X(n281) );
  SEH_AOI31_G_1 U224 ( .A1(mc_state0), .A2(n2070), .A3(n192), .B(n2020), .X(
        n312) );
  SEH_OAI311_1 U225 ( .A1(n268), .A2(n310), .A3(n155), .B1(n2050), .B2(n305), 
        .X(n311) );
  SEH_OAI41_1 U226 ( .A1(n2200), .A2(n315), .A3(n287), .A4(n163), .B(n317), 
        .X(n304) );
  SEH_ND2_G_1 U227 ( .A1(n318), .A2(n296), .X(n315) );
  SEH_ND3_1 U228 ( .A1(n433), .A2(n2200), .A3(cmd_exec_wt), .X(n317) );
  SEH_AN2_1 U229 ( .A1(i2ccmdr[6]), .A2(mcmd_stop), .X(n320) );
  SEH_AOI31_G_1 U230 ( .A1(n192), .A2(n231), .A3(exec_stsp_det0), .B(n305), 
        .X(n301) );
  SEH_AOI33_1 U231 ( .A1(n304), .A2(n162), .A3(n305), .B1(mc_state0), .B2(
        n2070), .B3(mc_state3), .X(n303) );
  SEH_AOI33_1 U232 ( .A1(n228), .A2(n2070), .A3(n308), .B1(n305), .B2(
        trst_arc_d_sync), .B3(n165), .X(n307) );
  SEH_OAI31_1 U233 ( .A1(n162), .A2(mc_state0), .A3(n2220), .B(n2000), .X(n308) );
  SEH_INV_S_1 U234 ( .A(n2050), .X(n165) );
  SEH_AN4_1 U235 ( .A1(i2csr[6]), .A2(i2ccmdr_wt), .A3(n321), .A4(i2ccmdr[7]), 
        .X(n2130) );
  SEH_AN2_1 U236 ( .A1(n433), .A2(n232), .X(n321) );
  SEH_INV_S_1 U237 ( .A(rcv_info2), .X(n127) );
  SEH_AO31_1 U238 ( .A1(n32), .A2(n396), .A3(n36), .B(trcv_arbl), .X(n385) );
  SEH_INV_S_0P5 U239 ( .A(n400), .X(n32) );
  SEH_OAI22_S_1 U240 ( .A1(n33), .A2(n264), .B1(n30), .B2(n279), .X(i2csr[1])
         );
  SEH_OA21B_1 U241 ( .A1(i2csr[7]), .A2(n135), .B(i2c_toe), .X(n279) );
  SEH_OAI32_1 U242 ( .A1(n251), .A2(n31), .A3(n89), .B1(n69), .B2(n254), .X(
        n510) );
  SEH_INV_S_1 U243 ( .A(trcv_cnt6), .X(n89) );
  SEH_OAI32_1 U244 ( .A1(n251), .A2(n267), .A3(n69), .B1(trcv_cnt0), .B2(n26), 
        .X(n528) );
  SEH_OAI32_1 U245 ( .A1(n26), .A2(trcv_cnt1), .A3(n69), .B1(n263), .B2(n70), 
        .X(n527) );
  SEH_ND3_1 U246 ( .A1(trcv_cnt2), .A2(n70), .A3(n267), .X(n254) );
  SEH_INV_S_1 U247 ( .A(mcst_master), .X(n232) );
  SEH_INV_S_1 U248 ( .A(i2ccr1[7]), .X(n287) );
  SEH_NR2_G_1 U249 ( .A1(n232), .A2(cmd_exec_active), .X(n2170) );
  SEH_OAI211_1 U250 ( .A1(n263), .A2(n72), .B1(n265), .B2(n254), .X(n526) );
  SEH_ND4_S_1 U251 ( .A1(n267), .A2(trcv_cnt1), .A3(trcv_cnt0), .A4(n72), .X(
        n265) );
  SEH_INV_S_1 U252 ( .A(trcv_cnt2), .X(n72) );
  SEH_OR2_1 U253 ( .A1(i2ccmdr[1]), .A2(i2ccmdr[5]), .X(n318) );
  SEH_INV_S_1 U254 ( .A(i2ccmdr[4]), .X(n296) );
  SEH_NR2B_1 U255 ( .A(trst_arc_d_sync), .B(n13), .X(upd_rxdr) );
  SEH_OAI41_1 U256 ( .A1(i2ccmdr[2]), .A2(i2ccmdr[1]), .A3(n14), .A4(n262), 
        .B(i2c_rcv_ok), .X(n13) );
  SEH_AO2BB2_DG_1 U257 ( .A1(n266), .A2(n275), .B1(n275), .B2(i2c_rrdy), .X(
        i2csr[2]) );
  SEH_AOAI211_G_1 U258 ( .A1(i2csr[4]), .A2(addr_ok_sync), .B(mcst_master), 
        .C(n276), .X(n275) );
  SEH_OAI21_G_1 U259 ( .A1(n277), .A2(n259), .B(mcst_master), .X(n276) );
  SEH_INV_S_1 U260 ( .A(mc_trn_en), .X(n259) );
  SEH_OAI21_G_1 U261 ( .A1(rcv_rw), .A2(n52), .B(n284), .X(n357) );
  SEH_AN2_1 U262 ( .A1(n353), .A2(n354), .X(n337) );
  SEH_NR4_1 U263 ( .A1(i2csaddr[7]), .A2(i2csaddr[6]), .A3(i2csaddr[5]), .A4(
        i2csaddr[4]), .X(n354) );
  SEH_NR4_1 U264 ( .A1(i2csaddr[3]), .A2(i2csaddr[2]), .A3(i2csaddr[1]), .A4(
        i2csaddr[0]), .X(n353) );
  SEH_AOI31_G_1 U265 ( .A1(i2c_trn_sync), .A2(n300), .A3(i2c_trdy), .B(n30), 
        .X(n364) );
  SEH_NR2B_1 U266 ( .A(trst_ack_all_nd), .B(trst_ack_all_pd), .X(n422) );
  SEH_INV_S_1 U267 ( .A(mc_state2), .X(n2070) );
  SEH_NR3_G_1 U268 ( .A1(n20), .A2(n17), .A3(n18), .X(upd_gcsr) );
  SEH_AOAI211_G_1 U269 ( .A1(tr_state1), .A2(n357), .B(n60), .C(n361), .X(n285) );
  SEH_ND2_G_1 U270 ( .A1(tr_state2), .A2(tr_state1), .X(n361) );
  SEH_NR2_G_1 U271 ( .A1(n337), .A2(i2csaddr[3]), .X(n339) );
  SEH_NR2_G_1 U272 ( .A1(n337), .A2(i2csaddr[4]), .X(n335) );
  SEH_OAI31_1 U273 ( .A1(n16), .A2(n17), .A3(n18), .B(n56), .X(upd_gcdr) );
  SEH_INV_S_1 U274 ( .A(upd_gcsr), .X(n56) );
  SEH_NR3_G_1 U275 ( .A1(trcv_stop), .A2(trcv_start), .A3(n355), .X(N107) );
  SEH_AOI22_1 U276 ( .A1(tr_state1), .A2(n356), .B1(tr_state2), .B2(tr_state0), 
        .X(n355) );
  SEH_OAI221_0P5 U277 ( .A1(tr_state0), .A2(n67), .B1(n60), .B2(n357), .C(n82), 
        .X(n356) );
  SEH_INV_S_1 U278 ( .A(mc_state1), .X(n228) );
  SEH_INV_S_1 U279 ( .A(trst_idle), .X(n85) );
  SEH_ND2B_1 U280 ( .A(n67), .B(trst_data), .X(n58) );
  SEH_INV_S_1 U281 ( .A(mc_state3), .X(n2000) );
  SEH_AO2BB2_DG_1 U282 ( .A1(n14), .A2(n34), .B1(n34), .B2(i2c_rcv_ok), .X(
        n383) );
  SEH_ND2_G_1 U283 ( .A1(trst_data), .A2(trcv_cnt6), .X(n34) );
  SEH_INV_S_1 U284 ( .A(mc_state0), .X(n231) );
  SEH_OA32_1 U285 ( .A1(n228), .A2(mc_state0), .A3(n2000), .B1(trst_arc_d_sync), .B2(n191), .X(n298) );
  SEH_INV_S_1 U286 ( .A(rcv_reg0), .X(n91) );
  SEH_ND2_G_1 U287 ( .A1(mc_state2), .A2(n231), .X(n323) );
  SEH_AO2BB2_DG_1 U288 ( .A1(n58), .A2(n91), .B1(n58), .B2(rcv_data0), .X(n389) );
  SEH_AO2BB2_DG_1 U289 ( .A1(n58), .A2(n92), .B1(n58), .B2(rcv_data1), .X(n391) );
  SEH_AO2BB2_DG_1 U290 ( .A1(n58), .A2(n97), .B1(n58), .B2(rcv_data2), .X(n393) );
  SEH_AO2BB2_DG_1 U291 ( .A1(n58), .A2(n102), .B1(n58), .B2(rcv_data3), .X(
        n395) );
  SEH_AO2BB2_DG_1 U292 ( .A1(n58), .A2(n1060), .B1(n58), .B2(rcv_data4), .X(
        n397) );
  SEH_AO2BB2_DG_1 U293 ( .A1(n58), .A2(n108), .B1(n58), .B2(rcv_data5), .X(
        n399) );
  SEH_AO2BB2_DG_1 U294 ( .A1(n58), .A2(n112), .B1(n58), .B2(rcv_data6), .X(
        n401) );
  SEH_AO2BB2_DG_1 U295 ( .A1(n58), .A2(n116), .B1(n58), .B2(rcv_data7), .X(
        n403) );
  SEH_NR3_G_1 U296 ( .A1(n59), .A2(trcv_stop), .A3(trcv_start), .X(N106) );
  SEH_NR2_G_1 U297 ( .A1(n337), .A2(i2csaddr[5]), .X(n340) );
  SEH_AO2BB2_DG_1 U298 ( .A1(i2ccmdr[3]), .A2(n240), .B1(n240), .B2(trn_ack), 
        .X(n499) );
  SEH_ND2B_1 U299 ( .A(n67), .B(n9), .X(n240) );
  SEH_AOI21_S_1 U300 ( .A1(n37), .A2(n29), .B(trcv_stop), .X(N105) );
  SEH_INV_S_1 U301 ( .A(exec_stsp_det0), .X(n2220) );
  SEH_INV_S_1 U302 ( .A(trn_rw), .X(n2200) );
  SEH_AO32_0P5 U303 ( .A1(rcv_rw), .A2(n29), .A3(n64), .B1(rcv_reg0), .B2(n28), 
        .X(n529) );
  SEH_INV_S_1 U304 ( .A(n246), .X(n64) );
  SEH_AO221_0P5 U305 ( .A1(n257), .A2(rcv_addr3), .B1(rcv_reg4), .B2(n28), .C(
        trcv_start), .X(n514) );
  SEH_INV_S_1 U306 ( .A(ckstr_flag), .X(n268) );
  SEH_AO31_1 U307 ( .A1(n37), .A2(n29), .A3(n59), .B(trcv_stop), .X(N73) );
  SEH_AO22_DG_1 U308 ( .A1(n31), .A2(trn_reg6), .B1(n62), .B2(trn_reg7), .X(
        n469) );
  SEH_AO22_DG_1 U309 ( .A1(n31), .A2(trn_reg5), .B1(n62), .B2(trn_reg6), .X(
        n470) );
  SEH_AO22_DG_1 U310 ( .A1(n31), .A2(trn_reg4), .B1(n62), .B2(trn_reg5), .X(
        n471) );
  SEH_AO22_DG_1 U311 ( .A1(n31), .A2(trn_reg3), .B1(n62), .B2(trn_reg4), .X(
        n472) );
  SEH_AO22_DG_1 U312 ( .A1(n31), .A2(trn_reg2), .B1(n62), .B2(trn_reg3), .X(
        n473) );
  SEH_AO22_DG_1 U313 ( .A1(n31), .A2(trn_reg1), .B1(n62), .B2(trn_reg2), .X(
        n474) );
  SEH_AO22_DG_1 U314 ( .A1(n31), .A2(trn_reg0), .B1(n62), .B2(trn_reg1), .X(
        n475) );
  SEH_OR2_1 U315 ( .A1(trn_reg0), .A2(n31), .X(n381) );
  SEH_AO2BB2_DG_1 U316 ( .A1(n134), .A2(n229), .B1(i2cgcdr[0]), .B2(n230), .X(
        n490) );
  SEH_AO2BB2_DG_1 U317 ( .A1(n128), .A2(n229), .B1(i2cgcdr[1]), .B2(n230), .X(
        n491) );
  SEH_AO2BB2_DG_1 U318 ( .A1(n127), .A2(n229), .B1(i2cgcdr[2]), .B2(n230), .X(
        n492) );
  SEH_AO2BB2_DG_1 U319 ( .A1(n126), .A2(n229), .B1(i2cgcdr[3]), .B2(n230), .X(
        n493) );
  SEH_AO2BB2_DG_1 U320 ( .A1(n124), .A2(n229), .B1(i2cgcdr[4]), .B2(n230), .X(
        n494) );
  SEH_AO2BB2_DG_1 U321 ( .A1(n121), .A2(n229), .B1(i2cgcdr[5]), .B2(n230), .X(
        n495) );
  SEH_AO2BB2_DG_1 U322 ( .A1(n120), .A2(n229), .B1(i2cgcdr[6]), .B2(n230), .X(
        n496) );
  SEH_AO2BB2_DG_1 U323 ( .A1(n119), .A2(n229), .B1(i2cgcdr[7]), .B2(n230), .X(
        n497) );
  SEH_INV_S_1 U324 ( .A(rcv_reg6), .X(n112) );
  SEH_INV_S_1 U325 ( .A(rcv_reg5), .X(n108) );
  SEH_INV_S_1 U326 ( .A(rcv_reg3), .X(n102) );
  SEH_INV_S_1 U327 ( .A(rcv_reg2), .X(n97) );
  SEH_INV_S_1 U328 ( .A(rcv_reg1), .X(n92) );
  SEH_INV_S_1 U329 ( .A(rcv_reg4), .X(n1060) );
  SEH_INV_S_1 U330 ( .A(rcv_reg7), .X(n116) );
  SEH_INV_S_1 U331 ( .A(rcv_info5), .X(n121) );
  SEH_INV_S_1 U332 ( .A(rcv_info7), .X(n119) );
  SEH_INV_S_1 U333 ( .A(rcv_info6), .X(n120) );
  SEH_OA21B_1 U334 ( .A1(n248), .A2(i2c_hsmode), .B(trcv_stop), .X(n5090) );
  SEH_AN4B_1 U335 ( .B1(i2ccr1[7]), .B2(n45), .B3(n249), .A(n1050), .X(n248)
         );
  SEH_INV_S_1 U336 ( .A(rcv_info0), .X(n134) );
  SEH_INV_S_1 U337 ( .A(rcv_info1), .X(n128) );
  SEH_AO22_DG_1 U338 ( .A1(n158), .A2(rcv_data0), .B1(i2crxdr[0]), .B2(n159), 
        .X(n466) );
  SEH_AO22_DG_1 U339 ( .A1(n158), .A2(rcv_data1), .B1(i2crxdr[1]), .B2(n159), 
        .X(n465) );
  SEH_AO22_DG_1 U340 ( .A1(n158), .A2(rcv_data2), .B1(i2crxdr[2]), .B2(n159), 
        .X(n464) );
  SEH_AO22_DG_1 U341 ( .A1(n158), .A2(rcv_data3), .B1(i2crxdr[3]), .B2(n159), 
        .X(n463) );
  SEH_AO22_DG_1 U342 ( .A1(n158), .A2(rcv_data4), .B1(i2crxdr[4]), .B2(n159), 
        .X(n462) );
  SEH_AO22_DG_1 U343 ( .A1(n158), .A2(rcv_data5), .B1(i2crxdr[5]), .B2(n159), 
        .X(n461) );
  SEH_AO22_DG_1 U344 ( .A1(n158), .A2(rcv_data6), .B1(i2crxdr[6]), .B2(n159), 
        .X(n460) );
  SEH_AO22_DG_1 U345 ( .A1(n158), .A2(rcv_data7), .B1(i2crxdr[7]), .B2(n159), 
        .X(n459) );
  SEH_OAI2111_1 U346 ( .A1(n155), .A2(n188), .B1(n160), .B2(n300), .B3(
        cmd_exec_active), .X(n71) );
  SEH_OA2BB2_1 U347 ( .A1(trst_rw_ok_sync), .A2(n262), .B1(i2c_trdy), .B2(
        trst_rw_ok_sync), .X(n188) );
  SEH_INV_S_1 U348 ( .A(exec_stsp), .X(n160) );
  SEH_AN4_1 U349 ( .A1(n181), .A2(n180), .A3(n183), .A4(n182), .X(n80) );
  SEH_OAI21_G_1 U350 ( .A1(n260), .A2(n77), .B(n185), .X(n183) );
  SEH_INV_S_1 U351 ( .A(n780), .X(n260) );
  SEH_OAI221_0P5 U352 ( .A1(mcst_master), .A2(n186), .B1(n429), .B2(
        i2c_scl_sense), .C(n71), .X(n185) );
  SEH_ND4_S_1 U353 ( .A1(n137), .A2(n333), .A3(n122), .A4(n123), .X(n114) );
  SEH_NR3_G_1 U354 ( .A1(i2cbr[1]), .A2(i2cbr[3]), .A3(i2cbr[2]), .X(n122) );
  SEH_AN6_1 U355 ( .A1(n314), .A2(n309), .A3(n316), .A4(n394), .A5(n392), .A6(
        n306), .X(n123) );
  SEH_OAI221_0P5 U356 ( .A1(n252), .A2(n83), .B1(n93), .B2(n394), .C(n95), .X(
        n441) );
  SEH_AOI22_1 U357 ( .A1(N201), .A2(n79), .B1(N218), .B2(n80), .X(n95) );
  SEH_OAI221_0P5 U358 ( .A1(n250), .A2(n83), .B1(n93), .B2(n306), .C(n98), .X(
        n442) );
  SEH_AOI22_1 U359 ( .A1(N200), .A2(n79), .B1(N217), .B2(n80), .X(n98) );
  SEH_OAI221_0P5 U360 ( .A1(n247), .A2(n83), .B1(n93), .B2(n309), .C(n101), 
        .X(n443) );
  SEH_AOI22_1 U361 ( .A1(N199), .A2(n79), .B1(N216), .B2(n80), .X(n101) );
  SEH_OAI221_0P5 U362 ( .A1(n243), .A2(n83), .B1(n93), .B2(n314), .C(n104), 
        .X(n444) );
  SEH_AOI22_1 U363 ( .A1(N198), .A2(n79), .B1(N215), .B2(n80), .X(n104) );
  SEH_OAI221_0P5 U364 ( .A1(n242), .A2(n83), .B1(n93), .B2(n316), .C(n1070), 
        .X(n445) );
  SEH_AOI22_1 U365 ( .A1(N197), .A2(n79), .B1(N214), .B2(n80), .X(n1070) );
  SEH_OAI221_0P5 U366 ( .A1(n238), .A2(n83), .B1(n93), .B2(n319), .C(n110), 
        .X(n446) );
  SEH_INV_S_1 U367 ( .A(i2cbr[3]), .X(n319) );
  SEH_AOI22_1 U368 ( .A1(N196), .A2(n79), .B1(N213), .B2(n80), .X(n110) );
  SEH_OAI221_0P5 U369 ( .A1(n233), .A2(n83), .B1(n93), .B2(n392), .C(n177), 
        .X(n480) );
  SEH_AOI22_1 U370 ( .A1(N202), .A2(n79), .B1(N219), .B2(n80), .X(n177) );
  SEH_OA2BB2_1 U371 ( .A1(exec_stsp_det1), .A2(n2220), .B1(n138), .B2(n76), 
        .X(n181) );
  SEH_AO221_0P5 U372 ( .A1(N208), .A2(n79), .B1(N225), .B2(n80), .C(n178), .X(
        n481) );
  SEH_NR2_G_1 U373 ( .A1(n209), .A2(n83), .X(n178) );
  SEH_AO221_0P5 U374 ( .A1(N207), .A2(n79), .B1(N224), .B2(n80), .C(n81), .X(
        n436) );
  SEH_NR2_G_1 U375 ( .A1(n235), .A2(n83), .X(n81) );
  SEH_AO221_0P5 U376 ( .A1(N206), .A2(n79), .B1(N223), .B2(n80), .C(n84), .X(
        n437) );
  SEH_NR2_G_1 U377 ( .A1(n258), .A2(n83), .X(n84) );
  SEH_AO221_0P5 U378 ( .A1(N205), .A2(n79), .B1(N222), .B2(n80), .C(n86), .X(
        n438) );
  SEH_NR2_G_1 U380 ( .A1(n256), .A2(n83), .X(n86) );
  SEH_AO221_0P5 U381 ( .A1(N204), .A2(n79), .B1(N221), .B2(n80), .C(n88), .X(
        n439) );
  SEH_NR2_G_1 U382 ( .A1(n255), .A2(n83), .X(n88) );
  SEH_AO221_0P5 U383 ( .A1(N195), .A2(n79), .B1(N212), .B2(n80), .C(n111), .X(
        n447) );
  SEH_OAI221_0P5 U384 ( .A1(n237), .A2(n83), .B1(n93), .B2(n331), .C(n114), 
        .X(n111) );
  SEH_INV_S_1 U385 ( .A(i2cbr[2]), .X(n331) );
  SEH_AO221_0P5 U386 ( .A1(N194), .A2(n79), .B1(N211), .B2(n80), .C(n115), .X(
        n448) );
  SEH_OAI221_0P5 U387 ( .A1(n236), .A2(n83), .B1(n93), .B2(n332), .C(n114), 
        .X(n115) );
  SEH_INV_S_1 U388 ( .A(i2cbr[1]), .X(n332) );
  SEH_AO221_0P5 U389 ( .A1(N193), .A2(n79), .B1(N210), .B2(n80), .C(n118), .X(
        n449) );
  SEH_OAI221_0P5 U390 ( .A1(n234), .A2(n83), .B1(n93), .B2(n333), .C(n114), 
        .X(n118) );
  SEH_AN3B_1 U391 ( .B1(trcv_cnt6_sync0), .B2(n232), .A(trcv_cnt6_sync1), .X(
        n1980) );
  SEH_AOAI211_G_1 U392 ( .A1(n174), .A2(n175), .B(trcv_start_sync0), .C(n75), 
        .X(n157) );
  SEH_ND3_1 U393 ( .A1(trst_arc_d_sync), .A2(n2030), .A3(n139), .X(n2040) );
  SEH_OAI41_1 U394 ( .A1(n2100), .A2(n286), .A3(n2180), .A4(n2040), .B(n2190), 
        .X(n487) );
  SEH_ND2_G_1 U395 ( .A1(n2100), .A2(cmd_exec_active), .X(n2190) );
  SEH_NR2_G_1 U396 ( .A1(i2crxdr_rd), .A2(n157), .X(n153) );
  SEH_OAOI211_1 U397 ( .A1(n2050), .A2(n302), .B(n2060), .C(n286), .X(n483) );
  SEH_ND2_G_1 U398 ( .A1(trn_rw), .A2(n2050), .X(n2060) );
  SEH_AOI22_1 U399 ( .A1(n268), .A2(n71), .B1(mc_state1), .B2(n2020), .X(n434)
         );
  SEH_AO32_0P5 U400 ( .A1(n1), .A2(n168), .A3(i2ccmdr[7]), .B1(mcmd_stcmd), 
        .B2(n2110), .X(n485) );
  SEH_INV_S_1 U402 ( .A(n2110), .X(n168) );
  SEH_NR2_G_1 U403 ( .A1(n2080), .A2(i2ccmdr_wt), .X(n2110) );
  SEH_AO2BB2_DG_1 U404 ( .A1(n154), .A2(n173), .B1(i2c_rrdy), .B2(n154), .X(
        n458) );
  SEH_AOA211_DG_1 U405 ( .A1(n266), .A2(i2ctxdr_wt), .B(i2c_toe), .C(n1720), 
        .X(n467) );
  SEH_AO32_0P5 U406 ( .A1(n75), .A2(n2140), .A3(n2120), .B1(mcmd_stop), .B2(
        n2150), .X(n486) );
  SEH_INV_S_1 U407 ( .A(n2150), .X(n2140) );
  SEH_AOI211_G_1 U408 ( .A1(i2ccmdr_wt), .A2(i2ccmdr[6]), .B1(n2160), .B2(n286), .X(n2150) );
  SEH_INV_S_1 U409 ( .A(n2120), .X(n2160) );
  SEH_AO32_0P5 U410 ( .A1(n1990), .A2(n142), .A3(n2010), .B1(cmd_exec_wt), 
        .B2(n2100), .X(n482) );
  SEH_OAOI211_1 U411 ( .A1(n2030), .A2(n139), .B(n2040), .C(n2100), .X(n1990)
         );
  SEH_AO32_0P5 U412 ( .A1(n170), .A2(n283), .A3(n1720), .B1(i2csr[0]), .B2(
        n239), .X(n498) );
  SEH_INV_S_1 U413 ( .A(i2cgcdr_rd), .X(n283) );
  SEH_INV_S_1 U414 ( .A(n239), .X(n170) );
  SEH_AOI211_G_1 U415 ( .A1(upd_gcsr_sync0), .A2(n428), .B1(i2cgcdr_rd), .B2(
        n157), .X(n239) );
  SEH_INV_S_1 U416 ( .A(sda_out_sense_r), .X(n187) );
  SEH_AOAI211_G_1 U417 ( .A1(n730), .A2(addr_ok_usr_sync), .B(n74), .C(n75), 
        .X(n435) );
  SEH_NR2_G_1 U418 ( .A1(n77), .A2(n780), .X(n730) );
  SEH_OA21B_1 U419 ( .A1(n76), .A2(n77), .B(tr_scl_out), .X(n74) );
  SEH_AOI31_G_1 U420 ( .A1(n164), .A2(n266), .A3(n1720), .B(i2ctxdr_wt), .X(
        n468) );
  SEH_ND2B_1 U421 ( .A(cap_txdr_sync0), .B(cap_txdr_sync1), .X(n164) );
  SEH_NR2_G_1 U422 ( .A1(n227), .A2(n157), .X(n489) );
  SEH_AOI211_G_1 U423 ( .A1(n426), .A2(i2c_arbl_sync0), .B1(i2csr[3]), .B2(
        n2130), .X(n227) );
  SEH_INV_S_1 U424 ( .A(sda_in), .X(n396) );
  SEH_ND4_S_1 U425 ( .A1(n1940), .A2(n1950), .A3(n1960), .A4(n1970), .X(n1930)
         );
  SEH_NR4_1 U426 ( .A1(n247), .A2(n250), .A3(n252), .A4(n233), .X(n1940) );
  SEH_NR4_1 U427 ( .A1(n237), .A2(n238), .A3(n242), .A4(n243), .X(n1950) );
  SEH_NR4_1 U428 ( .A1(clk_cnt1), .A2(clk_cnt15), .A3(clk_cnt14), .A4(
        clk_cnt13), .X(n2240) );
  SEH_NR4_1 U429 ( .A1(clk_cnt12), .A2(clk_cnt11), .A3(clk_cnt10), .A4(
        clk_cnt0), .X(n2230) );
  SEH_NR4_1 U430 ( .A1(clk_cnt5), .A2(clk_cnt4), .A3(clk_cnt3), .A4(clk_cnt2), 
        .X(n2250) );
  SEH_NR4_1 U431 ( .A1(clk_cnt9), .A2(clk_cnt8), .A3(clk_cnt7), .A4(clk_cnt6), 
        .X(n226) );
  SEH_INV_S_1 U432 ( .A(clk_cnt0), .X(n234) );
  SEH_INV_S_1 U433 ( .A(i2c_rrdy), .X(n262) );
  SEH_INV_S_1 U434 ( .A(clk_cnt10), .X(n253) );
  SEH_INV_S_1 U435 ( .A(clk_cnt12), .X(n256) );
  SEH_INV_S_1 U436 ( .A(clk_cnt13), .X(n258) );
  SEH_INV_S_1 U437 ( .A(clk_cnt11), .X(n255) );
  SEH_INV_S_1 U438 ( .A(clk_cnt14), .X(n235) );
  SEH_INV_S_1 U439 ( .A(clk_cnt5), .X(n243) );
  SEH_INV_S_1 U440 ( .A(clk_cnt1), .X(n236) );
  SEH_INV_S_1 U441 ( .A(clk_cnt9), .X(n233) );
  SEH_INV_S_1 U442 ( .A(clk_cnt4), .X(n242) );
  SEH_INV_S_1 U443 ( .A(clk_cnt8), .X(n252) );
  SEH_INV_S_1 U444 ( .A(clk_cnt3), .X(n238) );
  SEH_INV_S_1 U445 ( .A(clk_cnt7), .X(n250) );
  SEH_INV_S_1 U446 ( .A(clk_cnt15), .X(n209) );
  SEH_OAI32_1 U447 ( .A1(i2ccmdr[1]), .A2(upd_rxdr_sync0), .A3(n427), .B1(n261), .B2(n161), .X(n156) );
  SEH_INV_S_1 U448 ( .A(upd_rxdr_sync0), .X(n261) );
  SEH_ND2_G_1 U449 ( .A1(n427), .A2(i2ccmdr[1]), .X(n161) );
  SEH_AN4B_1 U450 ( .B1(n150), .B2(n272), .B3(n273), .A(sda_del_cnt1), .X(n38)
         );
  SEH_NR3_G_1 U451 ( .A1(sda_del_cnt3), .A2(sda_del_cnt5), .A3(sda_del_cnt4), 
        .X(n150) );
  SEH_OR3B_1 U452 ( .B1(i2ccr1[2]), .B2(n145), .A(i2ccr1[3]), .X(n133) );
  SEH_NR3_G_1 U453 ( .A1(i2ccr1[2]), .A2(i2ccr1[3]), .A3(n145), .X(n131) );
  SEH_ND3B_V1DG_1 U454 ( .A(i2ccr1[3]), .B1(n179), .B2(i2ccr1[2]), .X(n125) );
  SEH_AOI21_G_1 U455 ( .A1(n184), .A2(del_cnt_set_sense1), .B(n38), .X(n145)
         );
  SEH_INV_S_1 U456 ( .A(del_cnt_set_sense0), .X(n184) );
  SEH_AOAI211_G_1 U457 ( .A1(i2c_rcv_sync), .A2(i2c_rrdy), .B(n190), .C(n300), 
        .X(n780) );
  SEH_NR2B_1 U458 ( .A(i2c_trn_sync), .B(n266), .X(n190) );
  SEH_OR2_1 U459 ( .A1(sda_del_cnt1), .A2(sda_del_cnt0), .X(n15) );
  SEH_OAI221_0P5 U460 ( .A1(n133), .A2(n390), .B1(n176), .B2(n272), .C(n144), 
        .X(n454) );
  SEH_ND2_G_1 U461 ( .A1(n272), .A2(n130), .X(n144) );
  SEH_OAI221_0P5 U462 ( .A1(n125), .A2(n390), .B1(n133), .B2(n388), .C(n140), 
        .X(n453) );
  SEH_AOI22_1 U463 ( .A1(sda_del_cnt1), .A2(n141), .B1(N505), .B2(n130), .X(
        n140) );
  SEH_OAI221_0P5 U464 ( .A1(n125), .A2(n358), .B1(n176), .B2(n270), .C(n129), 
        .X(n450) );
  SEH_INV_S_1 U465 ( .A(sda_del_cnt4), .X(n270) );
  SEH_AOI22_1 U466 ( .A1(N508), .A2(n130), .B1(trim_sda_del[2]), .B2(n131), 
        .X(n129) );
  SEH_ND2_G_1 U467 ( .A1(cmd_exec_en_d), .A2(n2170), .X(n2120) );
  SEH_INV_S_1 U468 ( .A(i2c_trdy), .X(n266) );
  SEH_ND2_G_1 U469 ( .A1(trst_arc_d_sync), .A2(n232), .X(n77) );
  SEH_INV_S_1 U470 ( .A(i2csr[3]), .X(n189) );
  SEH_INV_S_1 U471 ( .A(trcv_cnt0), .X(n69) );
  SEH_INV_S_1 U472 ( .A(trim_sda_del[2]), .X(n387) );
  SEH_INV_S_1 U473 ( .A(i2ccmdr[2]), .X(n300) );
  SEH_AOI21_S_1 U474 ( .A1(n149), .A2(n269), .B(n38), .X(n456) );
  SEH_EN2_S_0P5 U475 ( .A1(sda_out_det1), .A2(sda_out_det0), .X(n149) );
  SEH_INV_S_1 U476 ( .A(clk_cnt6), .X(n247) );
  SEH_INV_S_1 U477 ( .A(clk_cnt2), .X(n237) );
  SEH_INV_S_1 U478 ( .A(rcv_arc), .X(n135) );
  SEH_INV_S_1 U479 ( .A(trim_sda_del[1]), .X(n388) );
  SEH_INV_S_1 U480 ( .A(trim_sda_del[3]), .X(n358) );
  SEH_INV_S_1 U481 ( .A(i2cbr[8]), .X(n394) );
  SEH_INV_S_1 U482 ( .A(trcv_cnt1), .X(n70) );
  SEH_INV_S_1 U483 ( .A(i2cbr[5]), .X(n314) );
  SEH_INV_S_1 U484 ( .A(i2cbr[4]), .X(n316) );
  SEH_INV_S_1 U485 ( .A(i2cbr[9]), .X(n392) );
  SEH_INV_S_1 U486 ( .A(i2cbr[7]), .X(n306) );
  SEH_INV_S_1 U487 ( .A(i2cbr[6]), .X(n309) );
  SEH_AO221_0P5 U488 ( .A1(N507), .A2(n130), .B1(trim_sda_del[1]), .B2(n131), 
        .C(n132), .X(n451) );
  SEH_OAI222_1 U489 ( .A1(n358), .A2(n133), .B1(n125), .B2(n387), .C1(n176), 
        .C2(n278), .X(n132) );
  SEH_INV_S_1 U490 ( .A(sda_del_cnt3), .X(n278) );
  SEH_AO221_0P5 U491 ( .A1(N506), .A2(n130), .B1(trim_sda_del[0]), .B2(n131), 
        .C(n136), .X(n452) );
  SEH_OAI222_1 U492 ( .A1(n387), .A2(n133), .B1(n125), .B2(n388), .C1(n176), 
        .C2(n273), .X(n136) );
  SEH_INV_S_1 U493 ( .A(i2cbr[0]), .X(n333) );
  SEH_INV_S_1 U494 ( .A(sda_del_cnt2), .X(n273) );
  SEH_INV_S_1 U495 ( .A(sda_del_cnt_en), .X(n269) );
  SEH_INV_S_1 U496 ( .A(sda_del_cnt0), .X(n272) );
  SEH_INV_S_1 U497 ( .A(trcv_start_sync1), .X(n175) );
  SEH_AO221_0P5 U498 ( .A1(n141), .A2(sda_del_cnt5), .B1(trim_sda_del[3]), 
        .B2(n131), .C(n146), .X(n455) );
  SEH_AN2_1 U499 ( .A1(N509), .A2(n130), .X(n146) );
  SEH_INV_S_1 U500 ( .A(i2c_roe), .X(n264) );
  SEH_INV_S_1 U501 ( .A(trcv_start_sync2), .X(n174) );
  SEH_INV_S_1 U502 ( .A(i2ctxdr[0]), .X(n302) );
  SEH_INV_S_1 U503 ( .A(trim_sda_del[0]), .X(n390) );
  SEH_OR3_1 U504 ( .A1(trst_tip), .A2(trcv_start_rst_d), .A3(trcv_start), .X(
        N171) );
  SEH_AO21_1 U505 ( .A1(i2ccr1[3]), .A2(i2ccr1[2]), .B(del_zero_states), .X(
        N488) );
  SEH_AOAI211_G_1 U506 ( .A1(n422), .A2(n364), .B(n27), .C(n398), .X(n25) );
  SEH_AN2_1 U507 ( .A1(cmd_exec_wt), .A2(n433), .X(n27) );
  SEH_OAI21_G_1 U508 ( .A1(i2ctxdr[7]), .A2(n12), .B(n23), .X(n366) );
  SEH_OAI21_G_1 U509 ( .A1(i2ctxdr[6]), .A2(n12), .B(n23), .X(n368) );
  SEH_OAI21_G_1 U510 ( .A1(i2ctxdr[5]), .A2(n12), .B(n23), .X(n370) );
  SEH_OAI21_G_1 U511 ( .A1(i2ctxdr[4]), .A2(n12), .B(n23), .X(n372) );
  SEH_OAI21_G_1 U512 ( .A1(i2ctxdr[3]), .A2(n12), .B(n23), .X(n374) );
  SEH_OAI21_G_1 U513 ( .A1(i2ctxdr[2]), .A2(n12), .B(n23), .X(n3760) );
  SEH_OAI21_G_1 U514 ( .A1(i2ctxdr[1]), .A2(n12), .B(n23), .X(n3780) );
  SEH_OAI21_G_1 U515 ( .A1(i2ctxdr[0]), .A2(n12), .B(n23), .X(n380) );
  SEH_NR2_G_1 U516 ( .A1(trcv_start), .A2(i2c_rst_async), .X(n421) );
  SEH_ND2B_1 U517 ( .A(i2ctxdr[7]), .B(n24), .X(n365) );
  SEH_ND2B_1 U518 ( .A(i2ctxdr[6]), .B(n24), .X(n367) );
  SEH_ND2B_1 U519 ( .A(i2ctxdr[5]), .B(n24), .X(n369) );
  SEH_ND2B_1 U520 ( .A(i2ctxdr[4]), .B(n24), .X(n371) );
  SEH_ND2B_1 U521 ( .A(i2ctxdr[3]), .B(n24), .X(n373) );
  SEH_ND2B_1 U522 ( .A(i2ctxdr[2]), .B(n24), .X(n375) );
  SEH_ND2B_1 U523 ( .A(i2ctxdr[1]), .B(n24), .X(n3770) );
  SEH_AOA211_DG_1 U524 ( .A1(n174), .A2(n175), .B(trcv_start_sync0), .C(n2), 
        .X(n382) );
  SEH_NR2_G_1 U525 ( .A1(trst_idle), .A2(i2c_rst_async), .X(n384) );
  SEH_NR2_G_1 U526 ( .A1(trcv_start_rst_d), .A2(i2c_rst_async), .X(n420) );
  SEH_BUF_1 U527 ( .A(n432), .X(n10) );
  SEH_ND2_G_1 U528 ( .A1(n398), .A2(n68), .X(n432) );
  SEH_AO211_1 U529 ( .A1(n287), .A2(i2ccr1_wt), .B1(i2c_rst_async), .B2(
        trcv_stop), .X(n68) );
  SEH_ND2_G_1 U530 ( .A1(n29), .A2(n18), .X(N66) );
  SEH_AO21B_1 U531 ( .A1(sda_del_cnt0), .A2(sda_del_cnt1), .B(n15), .X(N505)
         );
  SEH_OR2_0P65 U532 ( .A1(n15), .A2(sda_del_cnt2), .X(n19) );
  SEH_AO21B_1 U533 ( .A1(n15), .A2(sda_del_cnt2), .B(n19), .X(N506) );
  SEH_OR2_0P65 U534 ( .A1(n19), .A2(sda_del_cnt3), .X(n21) );
  SEH_AO21B_1 U535 ( .A1(n19), .A2(sda_del_cnt3), .B(n21), .X(N507) );
  SEH_EN2_0P5 U536 ( .A1(sda_del_cnt4), .A2(n21), .X(N508) );
  SEH_NR2_0P5 U537 ( .A1(sda_del_cnt4), .A2(n21), .X(n22) );
  SEH_EO2_0P5 U538 ( .A1(sda_del_cnt5), .A2(n22), .X(N509) );
  SYNCP_STD rstn_sync ( .q(del_rstn_async), .d(Logic1), .ck(del_clk), .cdn(
        n530) );
  i2c_port_DW01_dec_1 sub_709_S2 ( .A({clk_cnt15, clk_cnt14, clk_cnt13, 
        clk_cnt12, clk_cnt11, clk_cnt10, clk_cnt9, clk_cnt8, clk_cnt7, 
        clk_cnt6, clk_cnt5, clk_cnt4, clk_cnt3, clk_cnt2, clk_cnt1, clk_cnt0}), 
        .SUM({N225, N224, N223, N222, N221, N220, N219, N218, N217, N216, N215, 
        N214, N213, N212, N211, N210}) );
  i2c_port_DW01_inc_0 add_707_S2 ( .A({clk_cnt15, clk_cnt14, clk_cnt13, 
        clk_cnt12, clk_cnt11, clk_cnt10, clk_cnt9, clk_cnt8, clk_cnt7, 
        clk_cnt6, clk_cnt5, clk_cnt4, clk_cnt3, clk_cnt2, clk_cnt1, clk_cnt0}), 
        .SUM({N208, N207, N206, N205, N204, N203, N202, N201, N200, N199, N198, 
        N197, N196, N195, N194, N193}) );
endmodule


module i2c_ip ( sda_out, sda_oe, scl_out, scl_oe, sb_dat_o, sb_ack_o, i2c_irq, 
        i2c_wkup, SB_ID, ADDR_LSB_USR, i2c_rst_async, sda_in, scl_in, del_clk, 
        sb_clk_i, sb_we_i, sb_stb_i, sb_adr_i, sb_dat_i, scan_test_mode, VDD, VSS );
  output [7:0] sb_dat_o;
  input VDD, VSS;
  input [3:0] SB_ID;
  input [1:0] ADDR_LSB_USR;
  input [7:0] sb_adr_i;
  input [7:0] sb_dat_i;
  input i2c_rst_async, sda_in, scl_in, del_clk, sb_clk_i, sb_we_i, sb_stb_i,
         scan_test_mode;
  output sda_out, sda_oe, scl_out, scl_oe, sb_ack_o, i2c_irq, i2c_wkup;
  wire   i2ccr17, i2ccr16, i2ccr15, i2ccr14, i2ccr13, i2ccr12, i2ccr11,
         i2ccr10, i2ccmdr7, i2ccmdr6, i2ccmdr5, i2ccmdr4, i2ccmdr3, i2ccmdr2,
         i2ccmdr1, i2ccmdr0, i2ctxdr7, i2ctxdr6, i2ctxdr5, i2ctxdr4, i2ctxdr3,
         i2ctxdr2, i2ctxdr1, i2ctxdr0, i2cbr9, i2cbr8, i2cbr7, i2cbr6, i2cbr5,
         i2cbr4, i2cbr3, i2cbr2, i2cbr1, i2cbr0, i2csaddr7, i2csaddr6,
         i2csaddr5, i2csaddr4, i2csaddr3, i2csaddr2, i2csaddr1, i2csaddr0,
         i2ccr1_wt, i2ccmdr_wt, i2cbr_wt, i2ctxdr_wt, i2csaddr_wt, i2crxdr_rd,
         i2cgcdr_rd, trim_sda_del3, trim_sda_del2, trim_sda_del1,
         trim_sda_del0, i2csr7, i2csr6, i2csr5, i2csr4, i2csr3, i2csr2, i2csr1,
         i2csr0, i2crxdr7, i2crxdr6, i2crxdr5, i2crxdr4, i2crxdr3, i2crxdr2,
         i2crxdr1, i2crxdr0, i2cgcdr7, i2cgcdr6, i2cgcdr5, i2cgcdr4, i2cgcdr3,
         i2cgcdr2, i2cgcdr1, i2cgcdr0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10,
         n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24,
         n25, n26, n27, SYN_UC_1;

  SEH_INV_S_0P5 U1 ( .A(sb_dat_i[0]), .X(n1) );
  SEH_INV_S_0P5 U2 ( .A(n1), .X(n2) );
  SEH_INV_S_0P5 U3 ( .A(sb_dat_i[1]), .X(n3) );
  SEH_INV_S_0P5 U4 ( .A(n3), .X(n4) );
  SEH_INV_S_0P5 U5 ( .A(sb_dat_i[2]), .X(n5) );
  SEH_INV_S_0P5 U6 ( .A(n5), .X(n6) );
  SEH_INV_S_0P5 U7 ( .A(sb_dat_i[3]), .X(n7) );
  SEH_INV_S_0P5 U8 ( .A(n7), .X(n8) );
  SEH_INV_S_0P5 U9 ( .A(sb_stb_i), .X(n9) );
  SEH_INV_S_0P5 U10 ( .A(n9), .X(n10) );
  SEH_INV_S_0P5 U11 ( .A(ADDR_LSB_USR[0]), .X(n11) );
  SEH_INV_S_0P5 U12 ( .A(n11), .X(n12) );
  SEH_INV_S_0P5 U13 ( .A(ADDR_LSB_USR[1]), .X(n13) );
  SEH_INV_S_0P5 U14 ( .A(n13), .X(n14) );
  SEH_INV_S_0P5 U15 ( .A(sb_adr_i[2]), .X(n15) );
  SEH_INV_S_0P5 U16 ( .A(n15), .X(n16) );
  SEH_INV_S_0P5 U17 ( .A(sb_adr_i[3]), .X(n17) );
  SEH_INV_S_0P5 U18 ( .A(n17), .X(n18) );
  SEH_INV_S_0P5 U19 ( .A(sda_in), .X(n19) );
  SEH_INV_S_0P5 U20 ( .A(n19), .X(n20) );
  SEH_INV_S_0P5 U21 ( .A(sb_we_i), .X(n21) );
  SEH_INV_S_0P5 U22 ( .A(n21), .X(n22) );
  SEH_INV_S_0P5 U23 ( .A(sb_adr_i[1]), .X(n23) );
  SEH_INV_S_0P5 U24 ( .A(n23), .X(n24) );
  SEH_BUF_1 U25 ( .A(i2c_rst_async), .X(n27) );
  SEH_BUF_1 U26 ( .A(sb_adr_i[0]), .X(n26) );
  SEH_BUF_1 U27 ( .A(scan_test_mode), .X(n25) );
  i2c_sci i2c_sci_inst ( .i2ccr1({i2ccr17, i2ccr16, i2ccr15, i2ccr14, i2ccr13, 
        i2ccr12, i2ccr11, i2ccr10}), .i2ccmdr({i2ccmdr7, i2ccmdr6, i2ccmdr5, 
        i2ccmdr4, i2ccmdr3, i2ccmdr2, i2ccmdr1, i2ccmdr0}), .i2ctxdr({i2ctxdr7, 
        i2ctxdr6, i2ctxdr5, i2ctxdr4, i2ctxdr3, i2ctxdr2, i2ctxdr1, i2ctxdr0}), 
        .i2cbr({i2cbr9, i2cbr8, i2cbr7, i2cbr6, i2cbr5, i2cbr4, i2cbr3, i2cbr2, 
        i2cbr1, i2cbr0}), .i2csaddr({i2csaddr7, i2csaddr6, i2csaddr5, 
        i2csaddr4, i2csaddr3, i2csaddr2, i2csaddr1, i2csaddr0}), .i2ccr1_wt(
        i2ccr1_wt), .i2ccmdr_wt(i2ccmdr_wt), .i2cbr_wt(i2cbr_wt), .i2ctxdr_wt(
        i2ctxdr_wt), .i2csaddr_wt(i2csaddr_wt), .i2crxdr_rd(i2crxdr_rd), 
        .i2cgcdr_rd(i2cgcdr_rd), .trim_sda_del({trim_sda_del3, trim_sda_del2, 
        trim_sda_del1, trim_sda_del0}), .sb_dat_o(sb_dat_o), .sb_ack_o(
        sb_ack_o), .i2c_irq(i2c_irq), .SB_ID(SB_ID), .i2c_rst_async(n27), 
        .sb_clk_i(sb_clk_i), .sb_we_i(n22), .sb_stb_i(n10), .sb_adr_i({
        sb_adr_i[7:4], n18, n16, n24, n26}), .sb_dat_i({sb_dat_i[7:4], n8, n6, 
        n4, n2}), .i2csr({i2csr7, i2csr6, i2csr5, i2csr4, i2csr3, i2csr2, 
        i2csr1, i2csr0}), .i2crxdr({i2crxdr7, i2crxdr6, i2crxdr5, i2crxdr4, 
        i2crxdr3, i2crxdr2, i2crxdr1, i2crxdr0}), .i2cgcdr({i2cgcdr7, i2cgcdr6, 
        i2cgcdr5, i2cgcdr4, i2cgcdr3, i2cgcdr2, i2cgcdr1, i2cgcdr0}), 
        .scan_test_mode(n25) );
  i2c_port i2c_port_inst ( .sda_out(sda_out), .sda_oe(sda_oe), .scl_out(
        scl_out), .scl_oe(scl_oe), .i2crxdr({i2crxdr7, i2crxdr6, i2crxdr5, 
        i2crxdr4, i2crxdr3, i2crxdr2, i2crxdr1, i2crxdr0}), .i2cgcdr({i2cgcdr7, 
        i2cgcdr6, i2cgcdr5, i2cgcdr4, i2cgcdr3, i2cgcdr2, i2cgcdr1, i2cgcdr0}), 
        .i2csr({i2csr7, i2csr6, i2csr5, i2csr4, i2csr3, i2csr2, i2csr1, i2csr0}), .i2c_hsmode(SYN_UC_1), .i2c_wkup(i2c_wkup), .ADDR_LSB_USR({n14, n12}), 
        .i2c_rst_async(n27), .sda_in(n20), .scl_in(scl_in), .del_clk(del_clk), 
        .sb_clk_i(sb_clk_i), .i2ccr1({i2ccr17, i2ccr16, i2ccr15, i2ccr14, 
        i2ccr13, i2ccr12, i2ccr11, i2ccr10}), .i2ccmdr({i2ccmdr7, i2ccmdr6, 
        i2ccmdr5, i2ccmdr4, i2ccmdr3, i2ccmdr2, i2ccmdr1, i2ccmdr0}), 
        .i2ctxdr({i2ctxdr7, i2ctxdr6, i2ctxdr5, i2ctxdr4, i2ctxdr3, i2ctxdr2, 
        i2ctxdr1, i2ctxdr0}), .i2cbr({i2cbr9, i2cbr8, i2cbr7, i2cbr6, i2cbr5, 
        i2cbr4, i2cbr3, i2cbr2, i2cbr1, i2cbr0}), .i2csaddr({i2csaddr7, 
        i2csaddr6, i2csaddr5, i2csaddr4, i2csaddr3, i2csaddr2, i2csaddr1, 
        i2csaddr0}), .i2ccr1_wt(i2ccr1_wt), .i2ccmdr_wt(i2ccmdr_wt), 
        .i2cbr_wt(i2cbr_wt), .i2ctxdr_wt(i2ctxdr_wt), .i2csaddr_wt(i2csaddr_wt), .i2crxdr_rd(i2crxdr_rd), .i2cgcdr_rd(i2cgcdr_rd), .trim_sda_del({
        trim_sda_del3, trim_sda_del2, trim_sda_del1, trim_sda_del0}), 
        .scan_test_mode(n25) );
endmodule

