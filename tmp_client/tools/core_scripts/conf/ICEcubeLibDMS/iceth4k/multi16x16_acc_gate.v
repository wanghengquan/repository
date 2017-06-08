// Verilog file generated from Magma Bedrock database
// Thu Jan  2 17:43:20 2014
// Bedrock Root: Magma_root

// Entity:multi16x16_acc Model:multi16x16_acc Library:magma_checknetlist_lib
module multi16x16_acc (CLK, IHRST, ILRST, OHRST, OLRST, A, B, C, D, CBIT, AHLD, 
     BHLD, CHLD, DHLD, OHHLD, OLHLD, OHADS, OLADS, OHLDA, OLLDA, CICAS, CI, 
     SIGNEXTIN, SIGNEXTOUT, COCAS, CO, O, VDD, VSS);
  input CLK, IHRST, ILRST, OHRST, OLRST, AHLD, BHLD, CHLD, DHLD, OHHLD, OLHLD, 
     OHADS, OLADS, OHLDA, OLLDA, CICAS, CI, SIGNEXTIN, VDD, VSS;
  output SIGNEXTOUT, COCAS, CO;
  input [15:0] A;
  input [15:0] B;
  input [15:0] C;
  input [15:0] D;
  input [24:0] CBIT;
  output [31:0] O;
  wire [15:0] REG_A;
  wire [15:0] REG_B;
  wire [15:0] REG_C;
  wire [15:0] REG_D;
  wire [15:0] OH_8X8;
  wire [31:0] O_16X16;
  wire [15:0] OL_8X8;
  wire O_11_1, O_14_1, O_19_1, O_20_1, OLRST_1, COCAS_L, CO_L, MAC16_SIGNOUT_L, 
     n1, n2, n3, n4, n7, n8, CBIT_10_1, CBIT_22_1, CBIT_21_1, CBIT_21_2, 
     CBIT_20_1, CBIT_20_2, CBIT_19_1, CBIT_19_2, CBIT_18_1, CBIT_18_2, 
     CBIT_17_1, CBIT_17_2, CBIT_15_1, CBIT_15_2, CBIT_9_1, CBIT_9_2, CBIT_3_1, 
     CBIT_3_2, CBIT_2_1, CBIT_1_1, CBIT_1_2, CBIT_0_1, CBIT_0_2, CBIT_12_2, 
     CBIT_5_2, CBIT_16_3, CLK_1, CLK_2, CLK_3, CLK_4, CLK_5, CLK_6, CLK_7, 
     CLK_8, CLK_9, CLK_10, CLK_11, CLK_12, CLK_13, CLK_14, O_19_2, O_20_2, 
     O_14_2, O_11_2;
  SEH_DCAP8 standard_decap_74 ();
  SEH_DCAP8 standard_decap_90 ();
  SEH_DCAP4 standard_decap_99 ();
  SEH_INV_S_24 ONROUTE_2 (.A(O_20_2), .X(O[20]));
  SEH_DCAP8 standard_decap_3 ();
  SEH_INV_S_3 BW2_INV626 (.A(CBIT_19_1), .X(CBIT_19_2));
  SEH_DCAP4 standard_decap_6 ();
  SEH_DCAP4 standard_decap_17 ();
  SEH_DCAP8 standard_decap_31 ();
  SEH_DCAP4 standard_decap_21 ();
  SEH_INV_S_3 BW2_INV66 (.A(CBIT[1]), .X(CBIT_1_1));
  SEH_INV_S_3 BW2_INV2431 (.A(CBIT_3_1), .X(CBIT_3_2));
  SEH_DCAP8 standard_decap_2 ();
  SEH_INV_S_3 U22 (.A(DHLD), .X(n4));
  SEH_INV_S_3 BW2_INV591 (.A(CBIT_17_1), .X(CBIT_17_2));
  SEH_INV_S_3 BW2_INV655 (.A(CBIT_21_1), .X(CBIT_21_2));
  SEH_DCAP4 standard_decap_1 ();
  SEH_INV_S_3 BW2_INV653 (.A(CBIT_20_1), .X(CBIT_20_2));
  SEH_INV_S_3 BW2_INV620 (.A(CBIT_18_1), .X(CBIT_18_2));
  SEH_DCAP8 standard_decap_95 ();
  SEH_DCAP8 standard_decap_114 ();
  SEH_DCAP4 standard_decap_153 ();
  SEH_DCAP8 standard_decap_151 ();
  SEH_DCAP8 standard_decap_102 ();
  SEH_DCAP8 standard_decap_84 ();
  SEH_DCAP8 standard_decap_88 ();
  SEH_DCAP8 standard_decap_107 ();
  SEH_DCAP4 standard_decap_100 ();
  SEH_DCAP8 standard_decap_86 ();
  SEH_DCAP8 standard_decap_120 ();
  SEH_DCAP8 standard_decap_104 ();
  SEH_DCAP8 standard_decap_121 ();
  SEH_INV_S_3 BW2_INV686 (.A(CBIT_15_1), .X(CBIT_15_2));
  SEH_DCAP8 standard_decap_118 ();
  MPY16X16 MULTIPLER (.CLK(CLK_14), .IHRST(IHRST), .ILRST(ILRST), .FSEL(CBIT[4]), 
     .GSEL(CBIT_5_2), .HSEL(CBIT[7]), .JKSEL(CBIT[6]), .MPY_8X8_MODE(CBIT_22_1), 
     .ASGND(CBIT[23]), .BSGND(CBIT[24]), .A({REG_A[15], REG_A[14], REG_A[13], 
     REG_A[12], REG_A[11], REG_A[10], REG_A[9], REG_A[8], REG_A[7], REG_A[6], 
     n8, REG_A[4], REG_A[3], REG_A[2], REG_A[1], REG_A[0]}), .B(REG_B), 
     .OH_8X8(OH_8X8), .OL_8X8(OL_8X8), .O_16X16(O_16X16), .CLK_4(CLK_4), 
     .CLK_5(CLK_5), .CLK_6(CLK_6), .CLK_7(CLK_7), .CLK_8(CLK_8), .CLK_9(CLK_9), 
     .CLK_10(CLK_10), .CLK_11(CLK_11), .CLK_12(CLK_12), .CLK_13(CLK_13));
  SEH_DCAP8 standard_decap_119 ();
  SEH_INV_S_3 BW2_INV8120 (.A(CBIT_9_1), .X(CBIT_9_2));
  SEH_INV_S_3 BW2_INV74 (.A(CBIT[9]), .X(CBIT_9_1));
  SEH_DCAP8 standard_decap_45 ();
  SEH_DCAP8 standard_decap_69 ();
  SEH_DCAP4 standard_decap_72 ();
  SEH_DCAP4 standard_decap_77 ();
  SEH_DCAP8 standard_decap_60 ();
  SEH_DCAP8 standard_decap_44 ();
  SEH_DCAP8 standard_decap_66 ();
  SEH_DCAP8 standard_decap_63 ();
  SEH_DCAP8 standard_decap_52 ();
  SEH_BUF_20 CLK_L0_6 (.A(CLK_14), .X(CLK_7));
  SEH_DCAP8 standard_decap_71 ();
  SEH_DCAP8 standard_decap_51 ();
  SEH_DCAP4 standard_decap_50 ();
  SEH_DCAP8 standard_decap_65 ();
  MULT_ACCUM_0 LO_MAC (.DIRECT_INPUT(REG_D), .MULT_INPUT(REG_B), 
     .MULT_8x8(OL_8X8), .MULT_16x16({O_16X16[15], O_16X16[14], O_16X16[13], 
     O_16X16[12], O_16X16[11], O_16X16[10], O_16X16[9], O_16X16[8], O_16X16[7], 
     O_16X16[6], O_16X16[5], O_16X16[4], O_16X16[3], O_16X16[2], O_16X16[1], 
     O_16X16[0]}), .ADDSUB(OLADS), .CLK(CLK_14), .CICAS(CICAS), .CI(CI), 
     .SIGNEXTIN(SIGNEXTIN), .SIGNEXTOUT(MAC16_SIGNOUT_L), .LDA(OLLDA), 
     .RST(OLRST_1), .COCAS(COCAS_L), .CO(CO_L), .O({O[15], O_14_1, O[13], O[12], 
     O_11_1, O[10], O[9], O[8], O[7], O[6], O[5], O[4], O[3], O[2], O[1], O[0]}), 
     .OUTMUX_SEL({CBIT_16_3, CBIT_15_2}), .CARRYMUX_SEL({CBIT_21_2, CBIT_20_2}), 
     .ADDER_A_IN_SEL(CBIT_19_2), .ADDER_B_IN_SEL({CBIT_18_2, CBIT_17_2}), 
     .ENA_BAR(OLHLD), .CLK_1(CLK_1), .CLK_3(CLK_3), .CLK_4(CLK_4), 
     .CLK_6(CLK_6));
  SEH_DCAP8 standard_decap_152 ();
  SEH_DCAP4 standard_decap_148 ();
  SEH_DCAP4 standard_decap_14 ();
  SEH_DCAP8 standard_decap_78 ();
  SEH_BUF_D_3 CLK_L0_5 (.A(CLK_13), .X(CLK_6));
  SEH_DCAP8 standard_decap_70 ();
  SEH_DCAP4 standard_decap_73 ();
  SEH_DCAP4 standard_decap_68 ();
  SEH_DCAP8 standard_decap_57 ();
  SEH_DCAP4 standard_decap_75 ();
  SEH_BUF_4 CLK_L0_10 (.A(CLK_13), .X(CLK_11));
  SEH_DCAP4 standard_decap_76 ();
  SEH_DCAP8 standard_decap_79 ();
  SEH_DCAP8 standard_decap_59 ();
  SEH_DCAP8 standard_decap_43 ();
  SEH_DCAP8 standard_decap_56 ();
  SEH_DCAP8 standard_decap_48 ();
  SEH_BUF_S_32 CLK_L0 (.A(CLK_13), .X(CLK_1));
  SEH_DCAP4 standard_decap_54 ();
  SEH_DCAP4 standard_decap_80 ();
  SEH_DCAP4 standard_decap_62 ();
  SEH_DCAP8 standard_decap_64 ();
  SEH_DCAP8 standard_decap_126 ();
  SEH_DCAP4 standard_decap_105 ();
  SEH_DCAP8 standard_decap_109 ();
  SEH_DCAP4 standard_decap_89 ();
  SEH_DCAP4 standard_decap_112 ();
  SEH_DCAP8 standard_decap_92 ();
  SEH_INV_S_3 U8 (.A(n7), .X(n8));
  SEH_DCAP4 standard_decap_81 ();
  SEH_DCAP8 standard_decap_98 ();
  SEH_DCAP8 standard_decap_108 ();
  SEH_DCAP8 standard_decap_96 ();
  SEH_INV_S_3 U7 (.A(REG_A[5]), .X(n7));
  SEH_DCAP8 standard_decap_85 ();
  SEH_DCAP8 standard_decap_94 ();
  SEH_INV_S_24 ONROUTE (.A(O_19_2), .X(O[19]));
  SEH_DCAP8 standard_decap_103 ();
  SEH_DCAP8 standard_decap_82 ();
  REG_BYPASS_MUX_1 C_REG (.D(C), .Q(REG_C), .ENA(n3), .CLK(CLK_14), .RST(IHRST), 
     .SELM(CBIT_0_2), .CLK_2(CLK_2), .CLK_5(CLK_5));
  SEH_INV_S_24 ONROUTE_4 (.A(O_14_2), .X(O[14]));
  SEH_DCAP8 standard_decap_32 ();
  SEH_DCAP8 standard_decap_122 ();
  SEH_DCAP4 standard_decap_58 ();
  SEH_DCAP8 standard_decap_30 ();
  SEH_DCAP8 standard_decap_26 ();
  SEH_DCAP8 standard_decap_27 ();
  SEH_BUF_3 BW2_BUF67 (.A(CBIT[2]), .X(CBIT_2_1));
  SEH_DCAP4 standard_decap_46 ();
  SEH_DCAP8 standard_decap_28 ();
  SEH_DCAP4 standard_decap_42 ();
  SEH_BUF_24 CLK_L0_4 (.A(CLK_14), .X(CLK_5));
  SEH_DCAP4 standard_decap_55 ();
  SEH_DCAP4 standard_decap_61 ();
  SEH_BUF_3 BW2_BUF70_1 (.A(CBIT[5]), .X(CBIT_5_2));
  SEH_DCAP8 standard_decap_53 ();
  SEH_DCAP4 standard_decap_49 ();
  SEH_DCAP8 standard_decap_47 ();
  SEH_INV_S_3 ONROUTE_5 (.A(O_14_1), .X(O_14_2));
  SEH_BUF_S_32 CLK_L1_1 (.A(CLK), .X(CLK_13));
  SEH_BUF_16 CLK_L0_8 (.A(CLK_13), .X(CLK_9));
  SEH_BUF_8 CLK_L0_3 (.A(CLK_14), .X(CLK_4));
  SEH_BUF_24 CLK_L0_2 (.A(CLK_13), .X(CLK_3));
  SEH_DCAP4 standard_decap_41 ();
  SEH_INV_S_3 ONROUTE_7 (.A(O_11_1), .X(O_11_2));
  SEH_DCAP8 standard_decap_29 ();
  SEH_DCAP4 standard_decap_12 ();
  SEH_DCAP4 standard_decap_40 ();
  SEH_INV_S_24 ONROUTE_6 (.A(O_11_2), .X(O[11]));
  SEH_DCAP8 standard_decap_67 ();
  SEH_BUF_S_32 CLK_L0_1 (.A(CLK_14), .X(CLK_2));
  SEH_BUF_S_16 CLK_L1_2 (.A(CLK), .X(CLK_14));
  SEH_DCAP8 standard_decap_132 ();
  SEH_DCAP8 standard_decap_137 ();
  SEH_DCAP4 standard_decap_139 ();
  SEH_DCAP4 standard_decap_138 ();
  SEH_DCAP8 standard_decap_129 ();
  SEH_DCAP8 standard_decap_125 ();
  SEH_DCAP8 standard_decap_145 ();
  SEH_DCAP4 standard_decap_134 ();
  SEH_DCAP8 standard_decap_110 ();
  SEH_DCAP8 standard_decap_133 ();
  SEH_DCAP8 standard_decap_116 ();
  SEH_DCAP8 standard_decap_25 ();
  REG_BYPASS_MUX_0 D_REG (.D(D), .Q(REG_D), .ENA(n4), .CLK(CLK_4), .RST(ILRST), 
     .SELM(CBIT_3_2), .CLK_1(CLK_1), .CLK_3(CLK_3));
  SEH_DCAP8 standard_decap_124 ();
  SEH_DCAP8 standard_decap_115 ();
  SEH_DCAP8 standard_decap_113 ();
  SEH_DCAP4 standard_decap_93 ();
  SEH_BUF_3 BW1_BUF75 (.A(CBIT[10]), .X(CBIT_10_1));
  SEH_DCAP4 standard_decap_117 ();
  SEH_INV_S_3 ONROUTE_1 (.A(O_19_1), .X(O_19_2));
  SEH_INV_S_3 U23 (.A(AHLD), .X(n1));
  SEH_INV_S_3 BW2_INV84 (.A(CBIT[19]), .X(CBIT_19_1));
  SEH_DCAP8 standard_decap_91 ();
  SEH_DCAP4 standard_decap_97 ();
  SEH_DCAP4 standard_decap_87 ();
  SEH_INV_S_3 BW2_INV83 (.A(CBIT[18]), .X(CBIT_18_1));
  SEH_BUF_3 BW2_BUF77 (.A(CBIT[12]), .X(CBIT_12_2));
  SEH_INV_S_3 BW2_INV80 (.A(CBIT[15]), .X(CBIT_15_1));
  SEH_BUF_3 BW2_BUF87 (.A(CBIT[22]), .X(CBIT_22_1));
  SEH_DCAP8 standard_decap_101 ();
  SEH_INV_S_3 BW2_INV8125 (.A(CBIT_1_1), .X(CBIT_1_2));
  SEH_INV_S_3 BW2_INV82 (.A(CBIT[17]), .X(CBIT_17_1));
  SEH_DCAP4 standard_decap_83 ();
  SEH_BUF_24 CLK_L0_9 (.A(CLK_12), .X(CLK_10));
  SEH_BUF_24 CLK_L0_7 (.A(CLK_12), .X(CLK_8));
  SEH_INV_S_3 BW2_INV85 (.A(CBIT[20]), .X(CBIT_20_1));
  SEH_INV_S_3 BW2_INV86 (.A(CBIT[21]), .X(CBIT_21_1));
  SEH_BUF_3 BW2_BUF81 (.A(CBIT[16]), .X(CBIT_16_3));
  SEH_BUF_16 CLK_L1 (.A(CLK), .X(CLK_12));
  REG_BYPASS_MUX_2 B_REG (.D(B), .Q(REG_B), .ENA(n2), .CLK(CLK_13), .RST(ILRST), 
     .SELM(CBIT_2_1), .CLK_8(CLK_8), .CLK_10(CLK_10));
  SEH_DCAP8 standard_decap_144 ();
  SEH_DCAP4 standard_decap_136 ();
  SEH_DCAP8 standard_decap_142 ();
  SEH_DCAP8 standard_decap_131 ();
  SEH_DCAP4 standard_decap_130 ();
  SEH_DCAP8 standard_decap_128 ();
  SEH_DCAP8 standard_decap_4 ();
  SEH_DCAP8 standard_decap ();
  SEH_DCAP4 standard_decap_20 ();
  SEH_DCAP8 standard_decap_11 ();
  SEH_DCAP8 standard_decap_16 ();
  SEH_DCAP8 standard_decap_7 ();
  SEH_DCAP4 standard_decap_33 ();
  SEH_DCAP8 standard_decap_8 ();
  SEH_DCAP8 standard_decap_18 ();
  SEH_DCAP8 standard_decap_10 ();
  SEH_DCAP8 standard_decap_5 ();
  SEH_DCAP4 standard_decap_23 ();
  SEH_DCAP8 standard_decap_24 ();
  SEH_DCAP8 standard_decap_37 ();
  SEH_DCAP8 standard_decap_35 ();
  SEH_DCAP8 standard_decap_39 ();
  SEH_DCAP4 standard_decap_22 ();
  SEH_INV_S_3 BW2_INV68 (.A(CBIT[3]), .X(CBIT_3_1));
  SEH_DEL_L6_1 OPTHOLD_G_10 (.A(OLRST), .X(OLRST_1));
  SEH_DCAP8 standard_decap_143 ();
  SEH_DCAP8 standard_decap_135 ();
  SEH_DCAP8 standard_decap_140 ();
  SEH_DCAP8 standard_decap_146 ();
  SEH_DCAP4 standard_decap_9 ();
  SEH_DCAP4 standard_decap_19 ();
  SEH_DCAP4 standard_decap_127 ();
  SEH_DCAP8 standard_decap_155 ();
  SEH_INV_S_3 BW2_INV8127 (.A(CBIT_0_1), .X(CBIT_0_2));
  SEH_DCAP4 standard_decap_156 ();
  SEH_DCAP8 standard_decap_147 ();
  SEH_DCAP8 standard_decap_149 ();
  SEH_INV_S_3 BW2_INV65 (.A(CBIT[0]), .X(CBIT_0_1));
  SEH_DCAP8 standard_decap_15 ();
  SEH_INV_S_3 U20 (.A(BHLD), .X(n2));
  SEH_DCAP8 standard_decap_154 ();
  SEH_DCAP4 standard_decap_13 ();
  SEH_INV_S_3 U21 (.A(CHLD), .X(n3));
  SEH_DCAP8 standard_decap_123 ();
  SEH_DCAP8 standard_decap_150 ();
  SEH_DCAP8 standard_decap_36 ();
  SEH_DCAP8 standard_decap_111 ();
  SEH_DCAP4 standard_decap_106 ();
  SEH_INV_S_3 ONROUTE_3 (.A(O_20_1), .X(O_20_2));
  MULT_ACCUM_1 HI_MAC (.DIRECT_INPUT(REG_C), .MULT_INPUT(REG_A), 
     .MULT_8x8(OH_8X8), .MULT_16x16({O_16X16[31], O_16X16[30], O_16X16[29], 
     O_16X16[28], O_16X16[27], O_16X16[26], O_16X16[25], O_16X16[24], 
     O_16X16[23], O_16X16[22], O_16X16[21], O_16X16[20], O_16X16[19], 
     O_16X16[18], O_16X16[17], O_16X16[16]}), .ADDSUB(OHADS), .CLK(CLK_14), 
     .CICAS(COCAS_L), .CI(CO_L), .SIGNEXTIN(MAC16_SIGNOUT_L), 
     .SIGNEXTOUT(SIGNEXTOUT), .LDA(OHLDA), .RST(OHRST), .COCAS(COCAS), .CO(CO), 
     .O({O[31], O[30], O[29], O[28], O[27], O[26], O[25], O[24], O[23], O[22], 
     O[21], O_20_1, O_19_1, O[18], O[17], O[16]}), .OUTMUX_SEL({CBIT_9_2, CBIT[8]}), 
     .CARRYMUX_SEL({CBIT[14], CBIT[13]}), .ADDER_A_IN_SEL(CBIT_12_2), 
     .ADDER_B_IN_SEL({CBIT[11], CBIT_10_1}), .ENA_BAR(OHHLD), .CLK_2(CLK_2), 
     .CLK_5(CLK_5), .CLK_7(CLK_7));
  REG_BYPASS_MUX_3 A_REG (.D(A), .Q(REG_A), .ENA(n1), .CLK(CLK_13), .RST(IHRST), 
     .SELM(CBIT_1_2), .CLK_9(CLK_9), .CLK_11(CLK_11));
  SEH_DCAP8 standard_decap_34 ();
  SEH_DCAP8 standard_decap_141 ();
  SEH_DCAP8 standard_decap_38 ();
endmodule

// Entity:MPY16X16 Model:MPY16X16 Library:magma_checknetlist_lib
module MPY16X16 (CLK, IHRST, ILRST, FSEL, GSEL, HSEL, JKSEL, MPY_8X8_MODE, 
     ASGND, BSGND, A, B, OH_8X8, OL_8X8, O_16X16, CLK_4, CLK_5, CLK_6, CLK_7, 
     CLK_8, CLK_9, CLK_10, CLK_11, CLK_12, CLK_13);
  input CLK, IHRST, ILRST, FSEL, GSEL, HSEL, JKSEL, MPY_8X8_MODE, ASGND, BSGND, 
     CLK_4, CLK_5, CLK_6, CLK_7, CLK_8, CLK_9, CLK_10, CLK_11, CLK_12, CLK_13;
  input [15:0] A;
  input [15:0] B;
  output [15:0] OH_8X8;
  output [15:0] OL_8X8;
  output [31:0] O_16X16;
  wire [15:0] MPYG_o;
  wire [15:0] MPYJ_o;
  wire [15:0] MPYF_o;
  wire [15:0] MPYK_o;
  wire [15:0] MPYF_oreg;
  wire [15:0] MPYJ_oreg;
  wire [15:0] MPYK_oreg;
  wire [15:0] MPYG_oreg;
  wire [15:0] csa_oc;
  wire [31:0] mpy16_reg;
  wire \MPYG_csa_a[0] , \CLA16_G/r02/A_1 , \CLA16_G/r03/A_1 , \CLA16_G/r04/A_1 , 
     \CLA16_G/r05/A_1 , \MPYG_csa_a[5] , \MPYG_csa_a[6] , \CLA16_G/r08/A_1 , 
     \MPYG_csa_a[8] , \MPYG_csa_a[9] , \MPYG_csa_a[10] , \MPYG_csa_a[11] , 
     \MPYG_csa_a[12] , \MPYG_csa_a[13] , \MPYG_csa_a[14] , \MPYG_csa_a[15] , 
     \MPYG_csa_b[0] , \MPYG_csa_b[5] , \MPYG_csa_b[6] , \MPYG_csa_b[8] , 
     \MPYG_csa_b[9] , \MPYG_csa_b[10] , \MPYG_csa_b[11] , \MPYG_csa_b[12] , 
     \MPYG_csa_b[13] , \MPYG_csa_b[14] , \MPYG_csa_b[15] , \MPYJ_csa_a[0] , 
     \CLA16_J/r02/A_1 , \CLA16_J/r03/A_1 , \CLA16_J/r04/A_1 , \CLA16_J/r05/A_1 , 
     \MPYJ_csa_a[5] , \MPYJ_csa_a[6] , \CLA16_J/r08/A_1 , \MPYJ_csa_a[8] , 
     \MPYJ_csa_a[9] , \MPYJ_csa_a[10] , \MPYJ_csa_a[11] , \MPYJ_csa_a[12] , 
     \MPYJ_csa_a[13] , \MPYJ_csa_a[14] , \MPYJ_csa_a[15] , \MPYJ_csa_b[0] , 
     \MPYJ_csa_b[5] , \MPYJ_csa_b[6] , \MPYJ_csa_b[8] , \MPYJ_csa_b[9] , 
     \MPYJ_csa_b[10] , \MPYJ_csa_b[11] , \MPYJ_csa_b[12] , \MPYJ_csa_b[13] , 
     \MPYJ_csa_b[14] , \MPYJ_csa_b[15] , \MPYF_csa_a[0] , \CLA16_F/r02/A_1 , 
     \CLA16_F/r03/A_1 , \CLA16_F/r04/A_1 , \CLA16_F/r05/A_1 , \MPYF_csa_a[5] , 
     \MPYF_csa_a[6] , \CLA16_F/r08/A_1 , \MPYF_csa_a[8] , \MPYF_csa_a[9] , 
     \MPYF_csa_a[10] , \MPYF_csa_a[11] , \MPYF_csa_a[12] , \MPYF_csa_a[13] , 
     \MPYF_csa_a[14] , \MPYF_csa_a[15] , \MPYF_csa_b[0] , \MPYF_csa_b[5] , 
     \MPYF_csa_b[6] , \MPYF_csa_b[8] , \MPYF_csa_b[9] , \MPYF_csa_b[10] , 
     \MPYF_csa_b[11] , \MPYF_csa_b[12] , \MPYF_csa_b[13] , \MPYF_csa_b[14] , 
     \MPYF_csa_b[15] , \MPYK_csa_a[0] , \CLA16_K/r02/A_1 , \CLA16_K/r03/A_1 , 
     \CLA16_K/r04/A_1 , \CLA16_K/r05/A_1 , \MPYK_csa_a[5] , \MPYK_csa_a[6] , 
     \CLA16_K/r08/A_1 , \MPYK_csa_a[8] , \MPYK_csa_a[9] , \MPYK_csa_a[10] , 
     \MPYK_csa_a[11] , \MPYK_csa_a[12] , \MPYK_csa_a[13] , \MPYK_csa_a[14] , 
     \MPYK_csa_a[15] , \MPYK_csa_b[0] , \MPYK_csa_b[5] , \MPYK_csa_b[6] , 
     \MPYK_csa_b[8] , \MPYK_csa_b[9] , \MPYK_csa_b[10] , \MPYK_csa_b[11] , 
     \MPYK_csa_b[12] , \MPYK_csa_b[13] , \MPYK_csa_b[14] , \MPYK_csa_b[15] , 
     \csa_os[0] , \csa_os[1] , \csa_os[2] , \csa_os[3] , \csa_os[4] , 
     \csa_os[5] , \csa_os[6] , \csa_os[7] , \csa_os[8] , \csa_os[9] , 
     \csa_os[10] , \csa_os[11] , \csa_os[12] , \csa_os[13] , \csa_os[14] , 
     \csa_os[15] , \csa_os[16] , \csa_os[17] , \csa_os[18] , \csa_os[19] , 
     \csa_os[20] , \csa_os[21] , \csa_os[22] , \csa_os[23] , csa_os_0_1, 
     \cla_o[1] , \cla_o[2] , \cla_o[3] , \cla_o[4] , \cla_o[5] , \cla_o[6] , 
     \cla_o[7] , \cla_o[8] , \cla_o[9] , \cla_o[10] , \cla_o[11] , \cla_o[12] , 
     \cla_o[13] , \cla_o[14] , \cla_o[15] , \cla_o[16] , \cla_o[17] , 
     \cla_o[18] , \cla_o[19] , \cla_o[20] , \cla_o[21] , \cla_o[22] , 
     \cla_o[23] , n_Logic0_, MPYG_MPD_sign, MPYG_MPR_sign, cla24_g0, n2, n3, n4, 
     n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, 
     n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, 
     n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, 
     n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, 
     n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, 
     n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, 
     n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, 
     n109, n110, n111, n112, n113, n115, n116, n117, n118, n119, n120, n121, 
     n122, n123, n124, n125, n126, n128, n129, n130, n131, n132, n133, n134, 
     n135, n137, n151, n152, n162, n163, n164, n165, n166, n167, n168, n169, 
     n170, n171, n172, n173, n174, n175, n176, n177, n178, n179, n180, n181, 
     n182, n183, n184, n185, n186, n187, n188, n189, n190, n191, n192, n193, 
     n194, n195, n196, n197, n198, n199, n200, n201, n202, n203, n204, n205, 
     n206, n207, n208, n209, n210, n211, n212, n213, n214, n215, n216, n217, 
     n218, n219, n220, n221, n222, n223, n224, n225, n226, n227, n228, n229, 
     n230, n231, n232, n233, n234, n235, n236, n237, n238, n239, n240, n241, 
     n242, n243, n244, n245, n246, n247, n248, n249, n250, n251, n252, n253, 
     n254, n255, n256, n257, n1, n114, n127, n154, n155, n156, n157, n158, n159, 
     n276, n277, n278, n279, n280, n281, n282, n283, n284, n285, n286, n287, 
     n288, n289, n290, n291, n292, n293, n294, n295, n296, n297, n298, n299, 
     n300, n301, n302, n303, n304, n305, n306, n307, n308, n309, n310, n311, 
     SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, 
     SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5, SYNOPSYS_UNCONNECTED_6, 
     SYNOPSYS_UNCONNECTED_7, SYNOPSYS_UNCONNECTED_8, SYNOPSYS_UNCONNECTED_9, 
     SYNOPSYS_UNCONNECTED_10, SYNOPSYS_UNCONNECTED_11, SYNOPSYS_UNCONNECTED_12, 
     SYNOPSYS_UNCONNECTED_13, SYNOPSYS_UNCONNECTED_14, SYNOPSYS_UNCONNECTED_15, 
     SYNOPSYS_UNCONNECTED_16, SYNOPSYS_UNCONNECTED_17, SYNOPSYS_UNCONNECTED_18, 
     SYNOPSYS_UNCONNECTED_19, SYNOPSYS_UNCONNECTED_20, n153_1, n153_2, n153_3, 
     n153_5, n153_6, n153_7, n153_8, n153_9, n153_10, n153_11, n202_3, JKSEL_1, 
     HSEL_1, BSGND_1, ASGND_1, n202_1, n202_2, n202_4, BSGND_3, ASGND_3, FSEL_1, 
     CLK_1, CLK_2, CLK_3, CLK_12_1, CLK_13_1, CLK_14, CLK_15, CLK_16, IHRST_1, 
     ILRST_1, ILRST_2, ILRST_3;
  SEH_INV_S_3 U321 (.A(n152), .X(OH_8X8[0]));
  SEH_BUF_D_3 BW2_BUF1103_1 (.A(n202), .X(n202_4));
  SEH_OAI22_3 U25 (.A1(n305), .A2(n46), .B1(n299), .B2(n47), .X(n184));
  SEH_INV_S_3 U238 (.A(mpy16_reg[16]), .X(n18));
  SEH_INV_S_3 U381 (.A(n155), .X(n115));
  SEH_OAI22_3 U13 (.A1(n308), .A2(n22), .B1(n300), .B2(n23), .X(n172));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_11_ (.CK(CLK_5), .D(MPYF_o[11]), 
     .Q(MPYF_oreg[11]), .RD(n202_4));
  SEH_OAI21_S_3 U282 (.A1(n159), .A2(n122), .B(n118), .X(n255));
  SEH_OAI21_S_3 U280 (.A1(n116), .A2(n119), .B(n118), .X(n252));
  SEH_EN2_G_3 U268 (.A1(n159), .A2(OH_8X8[14]), .X(\csa_os[22] ));
  SEH_INV_S_3 U317 (.A(n121), .X(OH_8X8[11]));
  SEH_EN2_G_3 U262 (.A1(n116), .A2(OH_8X8[9]), .X(\csa_os[17] ));
  SEH_INV_S_3 U93 (.A(MPYJ_o[10]), .X(n103));
  SEH_OAI22_3 U57 (.A1(n307), .A2(n108), .B1(n295), .B2(n109), .X(n216));
  SEH_BUF_D_3 BW2_BUF8122 (.A(n202_1), .X(n202_2));
  SEH_OAI22_3 U98 (.A1(n106), .A2(n280), .B1(n276), .B2(n107), .X(n231));
  SEH_OAI22_3 U56 (.A1(n310), .A2(n106), .B1(n295), .B2(n107), .X(n215));
  SEH_AO22_DG_3 U287 (.A1(MPYF_o[6]), .A2(n284), .B1(MPYF_oreg[6]), .B2(n279), 
     .X(OH_8X8[6]));
  SEH_INV_S_3 U94 (.A(MPYJ_oreg[10]), .X(n102));
  SEH_AO22_DG_3 U285 (.A1(MPYF_o[4]), .A2(n284), .B1(MPYF_oreg[4]), .B2(n279), 
     .X(OH_8X8[4]));
  SEH_INV_S_3 U164 (.A(MPYJ_o[15]), .X(n113));
  SEH_OAI22_3 U101 (.A1(n108), .A2(n280), .B1(n276), .B2(n109), .X(n232));
  SEH_INV_S_3 U99 (.A(MPYJ_o[12]), .X(n107));
  SEH_OAI22_3 U58 (.A1(n308), .A2(n110), .B1(n295), .B2(n111), .X(n217));
  SEH_INV_S_3 U97 (.A(MPYJ_oreg[11]), .X(n104));
  SEH_OAI22_3 U95 (.A1(n104), .A2(n280), .B1(n276), .B2(n105), .X(n230));
  SEH_OAI22_3 U170 (.A1(n112), .A2(n281), .B1(n276), .B2(n113), .X(n234));
  SEH_INV_S_3 U354 (.A(n282), .X(n276));
  SEH_INV_S_3 U172 (.A(MPYJ_oreg[15]), .X(n112));
  SEH_AO22_DG_3 U283 (.A1(MPYF_o[2]), .A2(n284), .B1(MPYF_oreg[2]), .B2(n279), 
     .X(OH_8X8[2]));
  SEH_AO22_DG_3 U284 (.A1(MPYF_o[3]), .A2(n282), .B1(MPYF_oreg[3]), .B2(n279), 
     .X(OH_8X8[3]));
  SEH_BUF_3 U339 (.A(n282), .X(n280));
  SEH_INV_S_3 U96 (.A(MPYJ_o[11]), .X(n105));
  SEH_INV_S_3 U308 (.A(n151), .X(OH_8X8[1]));
  SEH_OAI22_3 U54 (.A1(n310), .A2(n102), .B1(n295), .B2(n103), .X(n213));
  SEH_AO22_DG_3 U286 (.A1(MPYF_o[5]), .A2(n283), .B1(MPYF_oreg[5]), .B2(n279), 
     .X(OH_8X8[5]));
  SEH_INV_S_3 U91 (.A(MPYJ_oreg[9]), .X(n100));
  SEH_OAI22_3 U53 (.A1(n310), .A2(n100), .B1(n298), .B2(n101), .X(n212));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_3_ (.CK(CLK_12_1), .D(MPYF_o[3]), 
     .Q(MPYF_oreg[3]), .RD(n202_1));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_15_ (.CK(CLK_13_1), .D(n218), .Q(MPYJ_oreg[15]), 
     .RD(n202_2));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_1_ (.CK(CLK_12_1), .D(MPYF_o[1]), 
     .Q(MPYF_oreg[1]), .RD(n202_1));
  SEH_OAI22_3 U92 (.A1(n102), .A2(n280), .B1(n276), .B2(n103), .X(n229));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_2_ (.CK(CLK_12_1), .D(MPYF_o[2]), 
     .Q(MPYF_oreg[2]), .RD(n202_1));
  SEH_BUF_3 U155 (.A(A[8]), .X(n154));
  SEH_AOI22_3 U309 (.A1(MPYF_o[1]), .A2(n283), .B1(MPYF_oreg[1]), .B2(n279), 
     .X(n151));
  SEH_BUF_3 BW2_BUF1103 (.A(n202), .X(n202_1));
  SEH_OAI22_3 U373 (.A1(n307), .A2(n112), .B1(n295), .B2(n113), .X(n218));
  SEH_OAI22_3 U55 (.A1(n309), .A2(n104), .B1(n295), .B2(n105), .X(n214));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_4_ (.CK(CLK_12_1), .D(MPYF_o[4]), 
     .Q(MPYF_oreg[4]), .RD(n202_1));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_13_ (.CK(CLK_12_1), .D(n216), .Q(MPYJ_oreg[13]), 
     .RD(n202_2));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_10_ (.CK(CLK_13_1), .D(n213), .Q(MPYJ_oreg[10]), 
     .RD(n202_2));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_12_ (.CK(CLK_13_1), .D(n215), .Q(MPYJ_oreg[12]), 
     .RD(n202_2));
  SEH_INV_S_3 U102 (.A(MPYJ_o[13]), .X(n109));
  SEH_OAI22_3 U104 (.A1(n110), .A2(n280), .B1(n276), .B2(n111), .X(n233));
  SEH_INV_S_3 U100 (.A(MPYJ_oreg[12]), .X(n106));
  SEH_INV_S_3 U103 (.A(MPYJ_oreg[13]), .X(n108));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_5_ (.CK(CLK_12_1), .D(MPYF_o[5]), 
     .Q(MPYF_oreg[5]), .RD(n202_1));
  SEH_BUF_3 U380 (.A(n310), .X(n308));
  SEH_BUF_3 U378 (.A(n284), .X(n282));
  SEH_INV_S_3 U90 (.A(MPYJ_o[9]), .X(n101));
  SEH_BUF_3 BW2_BUF496 (.A(BSGND), .X(BSGND_1));
  SEH_INV_S_3 U64 (.A(MPYJ_oreg[0]), .X(n82));
  SEH_INV_S_3 U63 (.A(MPYJ_o[0]), .X(n83));
  SEH_BUF_3 U379 (.A(n310), .X(n307));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_11_ (.CK(CLK_13_1), .D(n214), .Q(MPYJ_oreg[11]), 
     .RD(n202_2));
  SEH_BUF_3 BW2_BUF496_2 (.A(BSGND), .X(BSGND_3));
  SEH_BUF_3 BW2_BUF479 (.A(ASGND), .X(ASGND_1));
  SEH_AO22_DG_3 U296 (.A1(MPYF_o[7]), .A2(n283), .B1(MPYF_oreg[7]), .B2(n278), 
     .X(OH_8X8[7]));
  SEH_INV_S_3 U311 (.A(n124), .X(OH_8X8[14]));
  SEH_INV_S_3 U313 (.A(n123), .X(OH_8X8[13]));
  SEH_INV_S_3 U315 (.A(n122), .X(OH_8X8[12]));
  SEH_INV_S_3 U292 (.A(n119), .X(OH_8X8[9]));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_31_ (.CK(CLK_3), .D(n185), .Q(mpy16_reg[31]), 
     .RD(n153_11));
  SEH_DEL_L6_1 OPTHOLD_G (.A(IHRST), .X(IHRST_1));
  SEH_BUF_3 U335 (.A(n308), .X(n306));
  SEH_INV_S_3 U237 (.A(\cla_o[8] ), .X(n19));
  SEH_OAI22_3 U137 (.A1(n70), .A2(n114), .B1(n156), .B2(n71), .X(n245));
  SEH_OAI22_3 U30 (.A1(n305), .A2(n56), .B1(n298), .B2(n57), .X(n189));
  SEH_OAI22_3 U35 (.A1(n304), .A2(n66), .B1(n297), .B2(n67), .X(n194));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_10_ (.CK(CLK_14), .D(n196), .Q(MPYK_oreg[10]), 
     .RD(n153_9));
  SEH_INV_S_3 U141 (.A(MPYK_o[11]), .X(n73));
  SEH_INV_S_3 U228 (.A(\cla_o[11] ), .X(n25));
  SEH_INV_S_3 U353 (.A(n291), .X(n287));
  SEH_BUF_3 U341 (.A(n292), .X(n291));
  SEH_OAI22_3 U208 (.A1(n36), .A2(n291), .B1(n287), .B2(n37), .X(O_16X16[25]));
  SEH_OAI22_3 U205 (.A1(n38), .A2(n291), .B1(n287), .B2(n39), .X(O_16X16[26]));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_27_ (.CK(CLK_3), .D(n181), .Q(mpy16_reg[27]), 
     .RD(n153_11));
  SEH_INV_S_3 U207 (.A(mpy16_reg[26]), .X(n38));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_28_ (.CK(CLK_3), .D(n182), .Q(mpy16_reg[28]), 
     .RD(n153_11));
  SEH_INV_S_3 U206 (.A(\cla_o[18] ), .X(n39));
  SEH_INV_S_3 U200 (.A(\cla_o[20] ), .X(n43));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_26_ (.CK(CLK_3), .D(n180), .Q(mpy16_reg[26]), 
     .RD(n153_11));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_29_ (.CK(CLK_3), .D(n183), .Q(mpy16_reg[29]), 
     .RD(n153_11));
  SEH_BUF_3 U166 (.A(n116), .X(n159));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_23_ (.CK(CLK_9), .D(n177), .Q(mpy16_reg[23]), 
     .RD(n153_1));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_21_ (.CK(CLK_9), .D(n175), .Q(mpy16_reg[21]), 
     .RD(n153_1));
  SEH_EN2_G_3 U266 (.A1(n116), .A2(OH_8X8[10]), .X(\csa_os[18] ));
  SEH_INV_S_3 U294 (.A(n117), .X(OH_8X8[8]));
  SEH_OAI22_3 U310 (.A1(MPYF_oreg[11]), .A2(n283), .B1(MPYF_o[11]), .B2(n278), 
     .X(n121));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_9_ (.CK(CLK_7), .D(MPYF_o[9]), .Q(MPYF_oreg[9]), 
     .RD(n202_4));
  SEH_OAI22_3 U318 (.A1(MPYF_oreg[12]), .A2(n281), .B1(MPYF_o[12]), .B2(n278), 
     .X(n122));
  SEH_OAI22_3 U312 (.A1(MPYF_oreg[8]), .A2(n281), .B1(MPYF_o[8]), .B2(n278), 
     .X(n117));
  SEH_OAI22_3 U316 (.A1(MPYF_oreg[10]), .A2(n282), .B1(MPYF_o[10]), .B2(n278), 
     .X(n120));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_10_ (.CK(CLK_7), .D(MPYF_o[10]), 
     .Q(MPYF_oreg[10]), .RD(n202_4));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_8_ (.CK(CLK_7), .D(MPYF_o[8]), .Q(MPYF_oreg[8]), 
     .RD(n202_4));
  SEH_EN2_G_3 U270 (.A1(n159), .A2(OH_8X8[13]), .X(\csa_os[21] ));
  SEH_INV_S_3 U68 (.A(\cla_o[23] ), .X(n49));
  SEH_OAI22_3 U199 (.A1(n42), .A2(n291), .B1(n287), .B2(n43), .X(O_16X16[28]));
  SEH_INV_S_3 U219 (.A(mpy16_reg[22]), .X(n30));
  SEH_INV_S_3 U355 (.A(n280), .X(n278));
  SEH_OAI22_3 U192 (.A1(n46), .A2(n291), .B1(n287), .B2(n47), .X(O_16X16[30]));
  SEH_INV_S_3 U193 (.A(\cla_o[22] ), .X(n47));
  SEH_INV_S_3 U114 (.A(MPYK_o[2]), .X(n55));
  SEH_OAI22_3 U16 (.A1(n310), .A2(n28), .B1(n300), .B2(n29), .X(n175));
  SEH_OAI21_S_3 U288 (.A1(n159), .A2(n123), .B(n118), .X(n256));
  SEH_EN2_G_3 U264 (.A1(n159), .A2(OH_8X8[12]), .X(\csa_os[20] ));
  SEH_OAI22_3 U320 (.A1(MPYF_oreg[14]), .A2(n281), .B1(MPYF_o[14]), .B2(n278), 
     .X(n124));
  SEH_OAI21_S_3 U278 (.A1(n159), .A2(n121), .B(n118), .X(n254));
  SEH_OAI21_S_3 U149 (.A1(n159), .A2(n124), .B(n118), .X(n257));
  SEH_OAI21_S_3 U274 (.A1(n116), .A2(n120), .B(n118), .X(n253));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_8_ (.CK(CLK_13_1), .D(n211), .Q(MPYJ_oreg[8]), 
     .RD(n202_2));
  SEH_OAI22_3 U74 (.A1(n90), .A2(n282), .B1(n277), .B2(n91), .X(n223));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_7_ (.CK(CLK_13_1), .D(MPYF_o[7]), 
     .Q(MPYF_oreg[7]), .RD(n202));
  SEH_INV_S_3 U345 (.A(n309), .X(n295));
  SEH_INV_S_3 U351 (.A(n305), .X(n298));
  SEH_OAI22_3 U89 (.A1(n100), .A2(n280), .B1(n276), .B2(n101), .X(n228));
  SEH_INV_S_3 U88 (.A(MPYJ_oreg[8]), .X(n98));
  SEH_INV_S_3 U87 (.A(MPYJ_o[8]), .X(n99));
  SEH_DEL_L6_1 OPTHOLD_G_6 (.A(ILRST), .X(ILRST_1));
  SEH_OAI22_3 U17 (.A1(n306), .A2(n30), .B1(n300), .B2(n31), .X(n176));
  SEH_INV_S_3 U136 (.A(MPYK_oreg[9]), .X(n68));
  SEH_OAI22_3 U11 (.A1(n308), .A2(n18), .B1(n301), .B2(n19), .X(n170));
  SEH_OAI22_3 U125 (.A1(n62), .A2(n115), .B1(n155), .B2(n63), .X(n241));
  SEH_BUF_3 U156 (.A(FSEL_1), .X(n155));
  SEH_BUF_3 BW1_BUF500 (.A(HSEL), .X(HSEL_1));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_12_ (.CK(CLK_14), .D(n198), .Q(MPYK_oreg[12]), 
     .RD(n153_9));
  SEH_INV_S_3 U76 (.A(MPYJ_oreg[4]), .X(n90));
  SEH_OAI22_3 U47 (.A1(n302), .A2(n88), .B1(n296), .B2(n89), .X(n206));
  SEH_OAI22_3 U26 (.A1(n305), .A2(n48), .B1(n299), .B2(n49), .X(n185));
  SEH_INV_S_3 U212 (.A(\cla_o[16] ), .X(n35));
  SEH_INV_S_3 U198 (.A(mpy16_reg[29]), .X(n44));
  SEH_OAI22_3 U202 (.A1(n40), .A2(n291), .B1(n287), .B2(n41), .X(O_16X16[27]));
  SEH_OAI22_3 U22 (.A1(n306), .A2(n40), .B1(n299), .B2(n41), .X(n181));
  SEH_INV_S_3 U204 (.A(mpy16_reg[27]), .X(n40));
  SEH_OAI22_3 U23 (.A1(n306), .A2(n42), .B1(n299), .B2(n43), .X(n182));
  SEH_OAI22_3 U21 (.A1(n306), .A2(n38), .B1(n299), .B2(n39), .X(n180));
  SEH_INV_S_3 U203 (.A(\cla_o[19] ), .X(n41));
  SEH_INV_S_3 U209 (.A(\cla_o[17] ), .X(n37));
  SEH_BUF_16 CLK_L0_4 (.A(CLK_12), .X(CLK_13_1));
  SEH_OA2BB2_4 U152 (.A1(OH_8X8[15]), .A2(n311), .B1(n311), .B2(OH_8X8[15]), 
     .X(\csa_os[23] ));
  SEH_EN2_G_3 U260 (.A1(n116), .A2(OH_8X8[11]), .X(\csa_os[19] ));
  SEH_INV_S_3 U235 (.A(mpy16_reg[17]), .X(n20));
  SEH_OAI21_S_3 U276 (.A1(n116), .A2(n117), .B(n118), .X(n251));
  SEH_INV_S_3 U319 (.A(n120), .X(OH_8X8[10]));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_15_ (.CK(CLK_7), .D(MPYF_o[15]), 
     .Q(MPYF_oreg[15]), .RD(n202_4));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_12_ (.CK(CLK_7), .D(MPYF_o[12]), 
     .Q(MPYF_oreg[12]), .RD(n202_4));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_14_ (.CK(CLK_7), .D(MPYF_o[14]), 
     .Q(MPYF_oreg[14]), .RD(n202_4));
  SEH_OAI22_3 U167 (.A1(MPYF_oreg[13]), .A2(n281), .B1(MPYF_o[13]), .B2(n278), 
     .X(n123));
  SEH_OAI22_3 U314 (.A1(MPYF_oreg[9]), .A2(n281), .B1(MPYF_o[9]), .B2(n278), 
     .X(n119));
  SEH_OA22_4 U383 (.A1(MPYF_oreg[15]), .A2(n282), .B1(MPYF_o[15]), .B2(n279), 
     .X(OH_8X8[15]));
  SEH_INV_S_3 U201 (.A(mpy16_reg[28]), .X(n42));
  SEH_INV_S_3 U197 (.A(\cla_o[21] ), .X(n45));
  SEH_INV_S_3 U194 (.A(mpy16_reg[30]), .X(n46));
  SEH_OAI22_3 U196 (.A1(n44), .A2(n291), .B1(n287), .B2(n45), .X(O_16X16[29]));
  SEH_OAI22_3 U44 (.A1(n303), .A2(n82), .B1(n296), .B2(n83), .X(n203));
  SEH_OAI22_3 U230 (.A1(n22), .A2(n293), .B1(n286), .B2(n23), .X(O_16X16[18]));
  SEH_INV_S_3 U231 (.A(\cla_o[10] ), .X(n23));
  SEH_INV_S_3 U218 (.A(\cla_o[14] ), .X(n31));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_14_ (.CK(CLK_10), .D(n168), .Q(mpy16_reg[14]), 
     .RD(n153_6));
  SEH_BUF_3 U377 (.A(n293), .X(n292));
  SEH_OAI22_3 U24 (.A1(n305), .A2(n44), .B1(n299), .B2(n45), .X(n183));
  SEH_INV_S_3 U161 (.A(n159), .X(n311));
  SEH_AN2_S_3 U173 (.A1(ASGND_1), .A2(n250), .X(n125));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_30_ (.CK(CLK_3), .D(n184), .Q(mpy16_reg[30]), 
     .RD(n153_11));
  SEH_AOI22_3 U322 (.A1(MPYF_o[0]), .A2(n282), .B1(MPYF_oreg[0]), .B2(n279), 
     .X(n152));
  SEH_INV_S_3 U368 (.A(n282), .X(n279));
  SEH_BUF_3 U336 (.A(n307), .X(n305));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_18_ (.CK(CLK_9), .D(n172), .Q(mpy16_reg[18]), 
     .RD(n153_10));
  SEH_INV_S_3 U213 (.A(mpy16_reg[24]), .X(n34));
  SEH_INV_S_3 U222 (.A(mpy16_reg[21]), .X(n28));
  SEH_OAI22_3 U214 (.A1(n32), .A2(n293), .B1(n286), .B2(n33), .X(O_16X16[23]));
  SEH_INV_S_3 U232 (.A(mpy16_reg[18]), .X(n22));
  SEH_INV_S_3 U225 (.A(mpy16_reg[20]), .X(n26));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_24_ (.CK(CLK_3), .D(n178), .Q(mpy16_reg[24]), 
     .RD(n153_11));
  SEH_INV_S_3 U145 (.A(MPYK_oreg[12]), .X(n74));
  SEH_OAI22_3 U40 (.A1(n303), .A2(n76), .B1(n297), .B2(n77), .X(n199));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_5_ (.CK(CLK_16), .D(n208), .Q(MPYJ_oreg[5]), 
     .RD(n202_3));
  SEH_OAI22_3 U131 (.A1(n66), .A2(n114), .B1(n156), .B2(n67), .X(n243));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_15_ (.CK(CLK_2), .D(MPYG_o[15]), 
     .Q(MPYG_oreg[15]), .RD(n153_6));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_10_ (.CK(CLK_8), .D(n164), .Q(mpy16_reg[10]), 
     .RD(n153_6));
  SEH_AO2BB2_DG_3 U195 (.A1(n288), .A2(n133), .B1(mpy16_reg[2]), .B2(n289), 
     .X(O_16X16[2]));
  SEH_AOI22_3 U290 (.A1(MPYG_o[4]), .A2(n137), .B1(MPYG_oreg[4]), .B2(n157), 
     .X(n131));
  SEH_OAI22_3 U220 (.A1(n28), .A2(n292), .B1(n286), .B2(n29), .X(O_16X16[21]));
  SEH_OAI22_3 U158 (.A1(n80), .A2(n115), .B1(n156), .B2(n81), .X(n250));
  SEH_OAI22_3 U236 (.A1(n18), .A2(n290), .B1(n285), .B2(n19), .X(O_16X16[16]));
  SEH_INV_S_3 U183 (.A(mpy16_reg[8]), .X(n2));
  SEH_BUF_3 U376 (.A(n284), .X(n283));
  SEH_OAI22_3 U3 (.A1(n309), .A2(n2), .B1(n295), .B2(n3), .X(n162));
  SEH_INV_S_3 U191 (.A(mpy16_reg[31]), .X(n48));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_4_ (.CK(CLK_16), .D(n207), .Q(MPYJ_oreg[4]), 
     .RD(n202_3));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_7_ (.CK(CLK_16), .D(n210), .Q(MPYJ_oreg[7]), 
     .RD(n202_3));
  SEH_INV_S_3 U357 (.A(n293), .X(n286));
  SEH_OAI22_3 U211 (.A1(n34), .A2(n291), .B1(n286), .B2(n35), .X(O_16X16[24]));
  SEH_INV_S_3 U61 (.A(IHRST_1), .X(n202));
  SEH_OAI22_3 U140 (.A1(n72), .A2(n114), .B1(n155), .B2(n73), .X(n246));
  SEH_INV_S_3 U221 (.A(\cla_o[13] ), .X(n29));
  SEH_OAI22_3 U227 (.A1(n24), .A2(n292), .B1(n286), .B2(n25), .X(O_16X16[19]));
  SEH_OAI22_3 U20 (.A1(n306), .A2(n36), .B1(n299), .B2(n37), .X(n179));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_0_ (.CK(CLK_13_1), .D(MPYF_o[0]), 
     .Q(MPYF_oreg[0]), .RD(n202));
  SEH_AN2_S_3 U169 (.A1(BSGND_3), .A2(n234), .X(n126));
  SEH_INV_S_3 U352 (.A(n281), .X(n277));
  SEH_BUF_3 BW2_BUF479_2 (.A(ASGND), .X(ASGND_3));
  SEH_BUF_D_3 BW1_BUF3309 (.A(n202_2), .X(n202_3));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_9_ (.CK(CLK_13_1), .D(n212), .Q(MPYJ_oreg[9]), 
     .RD(n202_2));
  SEH_OAI22_3 U52 (.A1(n302), .A2(n98), .B1(n295), .B2(n99), .X(n211));
  SEH_OAI22_3 U86 (.A1(n98), .A2(n280), .B1(n276), .B2(n99), .X(n227));
  SEH_BUF_3 U338 (.A(n308), .X(n302));
  SEH_OAI22_3 U48 (.A1(n302), .A2(n90), .B1(n296), .B2(n91), .X(n207));
  SEH_BUF_12 CLK_L0_6 (.A(CLK_12), .X(CLK_15));
  SEH_BUF_3 U340 (.A(n283), .X(n281));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_6_ (.CK(CLK_15), .D(n192), .Q(MPYK_oreg[6]), 
     .RD(n153_9));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_3_ (.CK(CLK_16), .D(n206), .Q(MPYJ_oreg[3]), 
     .RD(n202_3));
  SEH_INV_S_3 U182 (.A(csa_os_0_1), .X(n3));
  SEH_INV_S_3 U73 (.A(MPYJ_oreg[3]), .X(n88));
  fa_4_fa_4 FA1_R00C04 (.Cout(csa_oc[4]), .Sum(\csa_os[4] ), .A(OL_8X8[12]), 
     .B(n223), .C(n239));
  SEH_INV_S_3 U130 (.A(MPYK_oreg[7]), .X(n64));
  SEH_OAI22_3 U15 (.A1(n309), .A2(n26), .B1(n300), .B2(n27), .X(n174));
  SEH_OAI22_3 U217 (.A1(n30), .A2(n292), .B1(n286), .B2(n31), .X(O_16X16[22]));
  SEH_BUF_D_3 BW1_BUF6901 (.A(n153_1), .X(n153_11));
  SEH_INV_S_3 U224 (.A(\cla_o[12] ), .X(n27));
  SEH_OAI22_3 U223 (.A1(n26), .A2(n292), .B1(n286), .B2(n27), .X(O_16X16[20]));
  SEH_INV_S_3 U234 (.A(\cla_o[9] ), .X(n21));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_14_ (.CK(CLK_14), .D(n200), .Q(MPYK_oreg[14]), 
     .RD(n153_8));
  SEH_OAI22_3 U38 (.A1(n303), .A2(n72), .B1(n297), .B2(n73), .X(n197));
  SEH_OAI22_3 U62 (.A1(n82), .A2(n281), .B1(n277), .B2(n83), .X(n219));
  SEH_INV_S_3 U139 (.A(MPYK_oreg[10]), .X(n70));
  SEH_INV_S_3 U150 (.A(MPYK_o[14]), .X(n79));
  SEH_INV_S_3 U148 (.A(MPYK_oreg[13]), .X(n76));
  SEH_ND2_S_2P5 U168 (.A1(n125), .A2(n126), .X(n118));
  SEH_OAI22_3 U189 (.A1(n48), .A2(n293), .B1(n287), .B2(n49), .X(O_16X16[31]));
  SEH_INV_S_3 U118 (.A(MPYK_oreg[3]), .X(n56));
  SEH_OAI22_3 U128 (.A1(n64), .A2(n114), .B1(n156), .B2(n65), .X(n242));
  SEH_BUF_D_3 BW1_BUF6897_1 (.A(n153_2), .X(n153_10));
  SEH_INV_S_3 U112 (.A(MPYK_oreg[1]), .X(n52));
  SEH_INV_S_3 U269 (.A(n131), .X(OL_8X8[4]));
  SEH_FDPHRBSBQ_1 mpy16_reg_reg_1_ (.CK(CLK_1), .D(OL_8X8[1]), .EN(n294), 
     .Q(mpy16_reg[1]), .RD(n153_3), .SD(n1));
  fa_12_fa_12 FA1_R00C12 (.Cout(csa_oc[12]), .Sum(\csa_os[12] ), .A(n231), 
     .B(n247), .C(OH_8X8[4]));
  SEH_OAI22_3 U245 (.A1(n12), .A2(n290), .B1(n285), .B2(n13), .X(O_16X16[13]));
  SEH_INV_S_3 U84 (.A(MPYJ_o[7]), .X(n97));
  SEH_OAI22_3 U46 (.A1(n302), .A2(n86), .B1(n296), .B2(n87), .X(n205));
  SEH_INV_S_3 U346 (.A(n306), .X(n297));
  SEH_OAI22_3 U36 (.A1(n304), .A2(n68), .B1(n297), .B2(n69), .X(n195));
  SEH_OAI22_3 U12 (.A1(n307), .A2(n20), .B1(n300), .B2(n21), .X(n171));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_22_ (.CK(CLK_9), .D(n176), .Q(mpy16_reg[22]), 
     .RD(n153_1));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_2_ (.CK(CLK_16), .D(n205), .Q(MPYJ_oreg[2]), 
     .RD(n202_3));
  SEH_BUF_4 CLK_L0_5 (.A(CLK_12), .X(CLK_14));
  SEH_BUF_3 U375 (.A(n310), .X(n309));
  SEH_INV_S_3 U348 (.A(n302), .X(n301));
  SEH_BUF_3 U344 (.A(n292), .X(n290));
  SEH_OAI22_3 U181 (.A1(n2), .A2(n292), .B1(n287), .B2(n3), .X(O_16X16[8]));
  SEH_INV_S_3 U133 (.A(MPYK_oreg[8]), .X(n66));
  SEH_INV_S_3 U371 (.A(n292), .X(n285));
  SEH_BUF_16 CLK_L0_3 (.A(CLK_12), .X(CLK_12_1));
  SEH_OAI22_3 U31 (.A1(n304), .A2(n58), .B1(n298), .B2(n59), .X(n190));
  SEH_INV_S_3 U215 (.A(\cla_o[15] ), .X(n33));
  SEH_INV_S_3 U216 (.A(mpy16_reg[23]), .X(n32));
  SEH_OAI22_3 U19 (.A1(n306), .A2(n34), .B1(n300), .B2(n35), .X(n178));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_25_ (.CK(CLK_3), .D(n179), .Q(mpy16_reg[25]), 
     .RD(n153_11));
  SEH_INV_S_3 U229 (.A(mpy16_reg[19]), .X(n24));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_17_ (.CK(CLK_9), .D(n171), .Q(mpy16_reg[17]), 
     .RD(n153_1));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_19_ (.CK(CLK_9), .D(n173), .Q(mpy16_reg[19]), 
     .RD(n153_1));
  SEH_INV_S_3 HFN1_INV_H1062 (.A(ILRST_1), .X(n153_1));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_20_ (.CK(CLK_9), .D(n174), .Q(mpy16_reg[20]), 
     .RD(n153_10));
  SEH_OAI22_3 U18 (.A1(n306), .A2(n32), .B1(n300), .B2(n33), .X(n177));
  SEH_OAI22_3 U14 (.A1(n307), .A2(n24), .B1(n300), .B2(n25), .X(n173));
  SEH_OAI22_3 U233 (.A1(n20), .A2(n293), .B1(n286), .B2(n21), .X(O_16X16[17]));
  SEH_OAI22_3 U7 (.A1(n310), .A2(n10), .B1(n301), .B2(n11), .X(n166));
  SEH_INV_S_3 U142 (.A(MPYK_oreg[11]), .X(n72));
  SEH_INV_S_3 U126 (.A(MPYK_o[6]), .X(n63));
  SEH_INV_S_3 U115 (.A(MPYK_oreg[2]), .X(n54));
  fa_6_fa_6 FA1_R00C06 (.Cout(csa_oc[6]), .Sum(\csa_os[6] ), .A(OL_8X8[14]), 
     .B(n225), .C(n241));
  SEH_INV_S_3 U117 (.A(MPYK_o[3]), .X(n57));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_16_ (.CK(CLK_16), .D(n170), .Q(mpy16_reg[16]), 
     .RD(n153_10));
  SEH_INV_S_3 U347 (.A(n303), .X(n300));
  SEH_OAI21_3 U272 (.A1(n125), .A2(n126), .B(n118), .X(n116));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_8_ (.CK(CLK_11), .D(n162), .Q(mpy16_reg[8]), 
     .RD(n153_10));
  SEH_BUF_S_32 CLK_L0_1 (.A(CLK_12), .X(CLK_2));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_0_ (.CK(CLK_16), .D(n203), .Q(MPYJ_oreg[0]), 
     .RD(n202_3));
  SEH_AOI22_3 U295 (.A1(MPYG_o[6]), .A2(n137), .B1(MPYG_oreg[6]), .B2(n157), 
     .X(n129));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_9_ (.CK(CLK_15), .D(n195), .Q(MPYK_oreg[9]), 
     .RD(n153_9));
  SEH_OAI22_3 U134 (.A1(n68), .A2(n114), .B1(n155), .B2(n69), .X(n244));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_15_ (.CK(CLK_14), .D(n201), .Q(MPYK_oreg[15]), 
     .RD(n153_8));
  SEH_OAI22_3 U33 (.A1(n304), .A2(n62), .B1(n298), .B2(n63), .X(n192));
  SEH_OAI22_3 U49 (.A1(n302), .A2(n92), .B1(n296), .B2(n93), .X(n208));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_2_ (.CK(CLK_15), .D(n188), .Q(MPYK_oreg[2]), 
     .RD(n153_2));
  SEH_INV_S_3 U67 (.A(MPYJ_oreg[1]), .X(n84));
  SEH_AO22_DG_3 U281 (.A1(MPYG_o[15]), .A2(n127), .B1(MPYG_oreg[15]), .B2(n158), 
     .X(OL_8X8[15]));
  SEH_INV_S_3 U252 (.A(\cla_o[3] ), .X(n9));
  SEH_AOI22_3 U175 (.A1(MPYG_o[0]), .A2(n137), .B1(MPYG_oreg[0]), .B2(n158), 
     .X(n135));
  SEH_OAI22_3 U242 (.A1(n14), .A2(n290), .B1(n285), .B2(n15), .X(O_16X16[14]));
  fa_10_fa_10 FA1_R00C10 (.Cout(csa_oc[10]), .Sum(\csa_os[10] ), .A(n229), 
     .B(n245), .C(OH_8X8[2]));
  SEH_AO22_DG_3 U190 (.A1(MPYG_o[10]), .A2(n137), .B1(MPYG_oreg[10]), .B2(n158), 
     .X(OL_8X8[10]));
  SEH_FDPHRBSBQ_1 mpy16_reg_reg_6_ (.CK(CLK_1), .D(OL_8X8[6]), .EN(n294), 
     .Q(mpy16_reg[6]), .RD(n153_5), .SD(n1));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_11_ (.CK(CLK_2), .D(MPYG_o[11]), 
     .Q(MPYG_oreg[11]), .RD(n153_5));
  SEH_OAI22_3 U143 (.A1(n74), .A2(n114), .B1(n155), .B2(n75), .X(n247));
  SEH_INV_S_3 U369 (.A(n309), .X(n294));
  SEH_AN2_S_3 U325 (.A1(ASGND_3), .A2(MPY_8X8_MODE), .X(MPYG_MPD_sign));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_4_ (.CK(CLK_6), .D(MPYG_o[4]), .Q(MPYG_oreg[4]), 
     .RD(n153_7));
  SEH_INV_S_3 U162 (.A(MPYK_o[15]), .X(n81));
  SEH_OAI22_3 U39 (.A1(n303), .A2(n74), .B1(n297), .B2(n75), .X(n198));
  SEH_INV_S_3 U153 (.A(n155), .X(n114));
  SEH_INV_S_3 U144 (.A(MPYK_o[12]), .X(n75));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_13_ (.CK(CLK_14), .D(n199), .Q(MPYK_oreg[13]), 
     .RD(n153_8));
  SEH_OAI22_3 U60 (.A1(n156), .A2(n79), .B1(n78), .B2(n114), .X(n249));
  SEH_INV_S_3 U81 (.A(MPYJ_o[6]), .X(n95));
  SEH_INV_S_3 U78 (.A(MPYJ_o[5]), .X(n93));
  SEH_INV_S_3 U247 (.A(mpy16_reg[13]), .X(n12));
  SEH_BUF_D_3 BW1_BUF3343 (.A(n153_8), .X(n153_9));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_4_ (.CK(CLK_14), .D(n190), .Q(MPYK_oreg[4]), 
     .RD(n153_8));
  SEH_OAI22_3 U28 (.A1(n305), .A2(n52), .B1(n298), .B2(n53), .X(n187));
  SEH_BUF_24 CLK_L0_2 (.A(CLK_12), .X(CLK_3));
  SEH_BUF_3 U342 (.A(n308), .X(n303));
  SEH_OAI22_3 U41 (.A1(n303), .A2(n78), .B1(n297), .B2(n79), .X(n200));
  SEH_INV_S_3 U210 (.A(mpy16_reg[25]), .X(n36));
  SEH_EN2_G_3 U171 (.A1(OH_8X8[8]), .A2(n116), .X(\csa_os[16] ));
  SEH_OAI22_3 U146 (.A1(n76), .A2(n114), .B1(n156), .B2(n77), .X(n248));
  SEH_INV_S_3 U151 (.A(MPYK_oreg[14]), .X(n78));
  SEH_INV_S_3 U147 (.A(MPYK_o[13]), .X(n77));
  SEH_OAI22_3 U50 (.A1(n302), .A2(n94), .B1(n296), .B2(n95), .X(n209));
  SEH_OAI22_3 U372 (.A1(n303), .A2(n80), .B1(n297), .B2(n81), .X(n201));
  SEH_INV_S_3 U138 (.A(MPYK_o[10]), .X(n71));
  SEH_INV_S_3 U66 (.A(MPYJ_o[1]), .X(n85));
  SEH_OAI22_3 U178 (.A1(n4), .A2(n293), .B1(n285), .B2(n5), .X(O_16X16[9]));
  SEH_OAI22_3 U71 (.A1(n88), .A2(n283), .B1(n277), .B2(n89), .X(n222));
  SEH_OAI22_3 U27 (.A1(n305), .A2(n50), .B1(n299), .B2(n51), .X(n186));
  SEH_INV_S_3 U384 (.A(MPY_8X8_MODE), .X(n310));
  fa_8_fa_8 FA1_R00C08 (.Cout(csa_oc[8]), .Sum(\csa_os[8] ), .A(n227), .B(n243), 
     .C(OH_8X8[0]));
  SEH_OAI22_3 U5 (.A1(n309), .A2(n6), .B1(n301), .B2(n7), .X(n164));
  SEH_INV_S_3 U121 (.A(MPYK_oreg[4]), .X(n58));
  SEH_INV_S_3 U177 (.A(MPYK_oreg[15]), .X(n80));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_3_ (.CK(CLK_15), .D(n189), .Q(MPYK_oreg[3]), 
     .RD(n153_2));
  SEH_INV_S_3 U123 (.A(MPYK_o[5]), .X(n61));
  SEH_INV_S_3 U127 (.A(MPYK_oreg[6]), .X(n62));
  SEH_INV_S_3 U349 (.A(n304), .X(n299));
  SEH_INV_S_3 U246 (.A(\cla_o[5] ), .X(n13));
  SEH_BUF_3 BW1_BUF503 (.A(JKSEL), .X(JKSEL_1));
  SEH_INV_S_3 U109 (.A(MPYK_oreg[0]), .X(n50));
  SEH_INV_S_3 U250 (.A(mpy16_reg[12]), .X(n10));
  SEH_BUF_6 CLK_L0_7 (.A(CLK), .X(CLK_16));
  SEH_BUF_3 U159 (.A(GSEL), .X(n157));
  SEH_OAI22_3 U45 (.A1(n303), .A2(n84), .B1(n296), .B2(n85), .X(n204));
  SEH_BUF_20 CLK_L0 (.A(CLK_13), .X(CLK_1));
  SEH_AOI22_3 U293 (.A1(MPYG_o[3]), .A2(n137), .B1(MPYG_oreg[3]), .B2(n158), 
     .X(n132));
  SEH_INV_S_3 U271 (.A(n132), .X(OL_8X8[3]));
  fcla16_5 CLA16_J (.Sum(MPYJ_o), .G(), .P(), .A({\MPYJ_csa_a[15] , 
     \MPYJ_csa_a[14] , \MPYJ_csa_a[13] , \MPYJ_csa_a[12] , \MPYJ_csa_a[11] , 
     \MPYJ_csa_a[10] , \MPYJ_csa_a[9] , \MPYJ_csa_a[8] , \CLA16_J/r08/A_1 , 
     \MPYJ_csa_a[6] , \MPYJ_csa_a[5] , \CLA16_J/r05/A_1 , \CLA16_J/r04/A_1 , 
     \CLA16_J/r03/A_1 , \CLA16_J/r02/A_1 , \MPYJ_csa_a[0] }), .B({
     \MPYJ_csa_b[15] , \MPYJ_csa_b[14] , \MPYJ_csa_b[13] , \MPYJ_csa_b[12] , 
     \MPYJ_csa_b[11] , \MPYJ_csa_b[10] , \MPYJ_csa_b[9] , \MPYJ_csa_b[8] , 
     n_Logic0_, \MPYJ_csa_b[6] , \MPYJ_csa_b[5] , n_Logic0_, n_Logic0_, 
     n_Logic0_, n_Logic0_, \MPYJ_csa_b[0] }), .Cin(n_Logic0_));
  SEH_AO22_DG_3 U259 (.A1(MPYG_o[11]), .A2(n127), .B1(MPYG_oreg[11]), .B2(n158), 
     .X(OL_8X8[11]));
  SEH_FDPHRBSBQ_1 mpy16_reg_reg_0_ (.CK(CLK_1), .D(OL_8X8[0]), .EN(n294), 
     .Q(mpy16_reg[0]), .RD(n153_3), .SD(n1));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_14_ (.CK(CLK_2), .D(MPYG_o[14]), 
     .Q(MPYG_oreg[14]), .RD(n153_5));
  SEH_OAI22_3 U113 (.A1(n54), .A2(n115), .B1(FSEL_1), .B2(n55), .X(n237));
  SEH_INV_S_3 U70 (.A(MPYJ_oreg[2]), .X(n86));
  SEH_INV_S_3 U163 (.A(\cla_o[1] ), .X(n5));
  fcla8 CLA24_8 (.Sum({\cla_o[23] , \cla_o[22] , \cla_o[21] , \cla_o[20] , 
     \cla_o[19] , \cla_o[18] , \cla_o[17] , \cla_o[16] }), .G(), .P(), .A({
     \csa_os[23] , \csa_os[22] , \csa_os[21] , \csa_os[20] , \csa_os[19] , 
     \csa_os[18] , \csa_os[17] , \csa_os[16] }), .B({n257, n256, n255, n254, n253, 
     n252, n251, csa_oc[15]}), .Cin(cla24_g0));
  SEH_INV_S_3 U370 (.A(n290), .X(n289));
  SEH_INV_S_3 U240 (.A(\cla_o[7] ), .X(n17));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_8_ (.CK(CLK_14), .D(n194), .Q(MPYK_oreg[8]), 
     .RD(n153_8));
  SEH_OAI22_3 U37 (.A1(n304), .A2(n70), .B1(n297), .B2(n71), .X(n196));
  SEH_INV_S_3 U124 (.A(MPYK_oreg[5]), .X(n60));
  SEH_INV_S_3 U135 (.A(MPYK_o[9]), .X(n69));
  SEH_INV_S_3 U129 (.A(MPYK_o[7]), .X(n65));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_10_ (.CK(CLK_6), .D(MPYG_o[10]), 
     .Q(MPYG_oreg[10]), .RD(n153_7));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_5_ (.CK(CLK_6), .D(MPYG_o[5]), .Q(MPYG_oreg[5]), 
     .RD(n153_7));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_6_ (.CK(CLK_6), .D(MPYG_o[6]), .Q(MPYG_oreg[6]), 
     .RD(n153_7));
  SEH_INV_S_3 U273 (.A(n133), .X(OL_8X8[2]));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_1_ (.CK(CLK_10), .D(n187), .Q(MPYK_oreg[1]), 
     .RD(n153_2));
  SEH_OAI22_3 U122 (.A1(n60), .A2(n115), .B1(FSEL_1), .B2(n61), .X(n240));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_15_ (.CK(CLK_8), .D(n169), .Q(mpy16_reg[15]), 
     .RD(n153_6));
  SEH_BUF_D_3 BW1_BUF6897 (.A(n153_2), .X(n153_8));
  SEH_INV_S_3 U132 (.A(MPYK_o[8]), .X(n67));
  SEH_BUF_3 BW1_BUF498 (.A(FSEL), .X(FSEL_1));
  SEH_INV_S_3 U120 (.A(MPYK_o[4]), .X(n59));
  SEH_OAI22_3 U107 (.A1(n50), .A2(n115), .B1(n156), .B2(n51), .X(n235));
  SEH_BUF_3 U337 (.A(n307), .X(n304));
  SEH_INV_S_3 U69 (.A(MPYJ_o[2]), .X(n87));
  SEH_OAI22_3 U83 (.A1(n96), .A2(n283), .B1(n277), .B2(n97), .X(n226));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_11_ (.CK(CLK_14), .D(n197), .Q(MPYK_oreg[11]), 
     .RD(n153_8));
  SEH_OAI22_3 U34 (.A1(n304), .A2(n64), .B1(n298), .B2(n65), .X(n193));
  SEH_OAI22_3 U77 (.A1(n92), .A2(n284), .B1(n277), .B2(n93), .X(n224));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_7_ (.CK(CLK_15), .D(n193), .Q(MPYK_oreg[7]), 
     .RD(n153_9));
  fa_15_fa_15 FA1_R00C15 (.Cout(csa_oc[15]), .Sum(\csa_os[15] ), .A(n234), 
     .B(n250), .C(OH_8X8[7]));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_9_ (.CK(CLK_10), .D(n163), .Q(mpy16_reg[9]), 
     .RD(n153_6));
  SEH_OAI22_3 U239 (.A1(n16), .A2(n290), .B1(n285), .B2(n17), .X(O_16X16[15]));
  SEH_INV_S_3 U241 (.A(mpy16_reg[15]), .X(n16));
  MPY8x8_3 MPY_G (.csa_a({\MPYG_csa_a[15] , \MPYG_csa_a[14] , \MPYG_csa_a[13] , 
     \MPYG_csa_a[12] , \MPYG_csa_a[11] , \MPYG_csa_a[10] , \MPYG_csa_a[9] , 
     \MPYG_csa_a[8] , \CLA16_G/r08/A_1 , \MPYG_csa_a[6] , \MPYG_csa_a[5] , 
     \CLA16_G/r05/A_1 , \CLA16_G/r04/A_1 , \CLA16_G/r03/A_1 , \CLA16_G/r02/A_1 , 
     \MPYG_csa_a[0] }), .csa_b({\MPYG_csa_b[15] , \MPYG_csa_b[14] , 
     \MPYG_csa_b[13] , \MPYG_csa_b[12] , \MPYG_csa_b[11] , \MPYG_csa_b[10] , 
     \MPYG_csa_b[9] , \MPYG_csa_b[8] , SYNOPSYS_UNCONNECTED_1, \MPYG_csa_b[6] , 
     \MPYG_csa_b[5] , SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, 
     SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5, \MPYG_csa_b[0] }), 
     .multiplicand({A[7], A[6], A[5], A[4], A[3], A[2], A[1], A[0]}), 
     .multiplier({B[7], B[6], B[5], B[4], B[3], B[2], B[1], B[0]}), 
     .signed_MPD(MPYG_MPD_sign), .signed_MPR(MPYG_MPR_sign));
  fcla16_6 CLA16_G (.Sum(MPYG_o), .G(), .P(), .A({\MPYG_csa_a[15] , 
     \MPYG_csa_a[14] , \MPYG_csa_a[13] , \MPYG_csa_a[12] , \MPYG_csa_a[11] , 
     \MPYG_csa_a[10] , \MPYG_csa_a[9] , \MPYG_csa_a[8] , \CLA16_G/r08/A_1 , 
     \MPYG_csa_a[6] , \MPYG_csa_a[5] , \CLA16_G/r05/A_1 , \CLA16_G/r04/A_1 , 
     \CLA16_G/r03/A_1 , \CLA16_G/r02/A_1 , \MPYG_csa_a[0] }), .B({
     \MPYG_csa_b[15] , \MPYG_csa_b[14] , \MPYG_csa_b[13] , \MPYG_csa_b[12] , 
     \MPYG_csa_b[11] , \MPYG_csa_b[10] , \MPYG_csa_b[9] , \MPYG_csa_b[8] , 
     n_Logic0_, \MPYG_csa_b[6] , \MPYG_csa_b[5] , n_Logic0_, n_Logic0_, 
     n_Logic0_, n_Logic0_, \MPYG_csa_b[0] }), .Cin(n_Logic0_));
  SEH_BUF_3 U157 (.A(FSEL), .X(n156));
  SEH_AN2_S_3 U324 (.A1(BSGND_1), .A2(MPY_8X8_MODE), .X(MPYG_MPR_sign));
  SEH_INV_S_3 U108 (.A(MPYK_o[0]), .X(n51));
  SEH_INV_S_3 U82 (.A(MPYJ_oreg[6]), .X(n94));
  SEH_OAI22_3 U110 (.A1(n52), .A2(n115), .B1(n155), .B2(n53), .X(n236));
  SEH_INV_S_3 U72 (.A(MPYJ_o[3]), .X(n89));
  SEH_AO22_DG_3 U165 (.A1(MPYG_o[8]), .A2(n127), .B1(MPYG_oreg[8]), .B2(n157), 
     .X(OL_8X8[8]));
  SEH_AO2BB2_DG_3 U185 (.A1(n288), .A2(n129), .B1(mpy16_reg[6]), .B2(n289), 
     .X(O_16X16[6]));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_13_ (.CK(CLK_2), .D(MPYG_o[13]), 
     .Q(MPYG_oreg[13]), .RD(n153_6));
  SEH_AO2BB2_DG_3 U187 (.A1(n288), .A2(n131), .B1(mpy16_reg[4]), .B2(n289), 
     .X(O_16X16[4]));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_3_ (.CK(CLK_6), .D(MPYG_o[3]), .Q(MPYG_oreg[3]), 
     .RD(n153_7));
  SEH_INV_S_3 U382 (.A(n157), .X(n137));
  SEH_BUF_D_3 BW1_BUF6326_1 (.A(n153_5), .X(n153_7));
  SEH_OAI22_3 U6 (.A1(n309), .A2(n8), .B1(n301), .B2(n9), .X(n165));
  fcla16_3 CLA16_K (.Sum(MPYK_o), .G(), .P(), .A({\MPYK_csa_a[15] , 
     \MPYK_csa_a[14] , \MPYK_csa_a[13] , \MPYK_csa_a[12] , \MPYK_csa_a[11] , 
     \MPYK_csa_a[10] , \MPYK_csa_a[9] , \MPYK_csa_a[8] , \CLA16_K/r08/A_1 , 
     \MPYK_csa_a[6] , \MPYK_csa_a[5] , \CLA16_K/r05/A_1 , \CLA16_K/r04/A_1 , 
     \CLA16_K/r03/A_1 , \CLA16_K/r02/A_1 , \MPYK_csa_a[0] }), .B({
     \MPYK_csa_b[15] , \MPYK_csa_b[14] , \MPYK_csa_b[13] , \MPYK_csa_b[12] , 
     \MPYK_csa_b[11] , \MPYK_csa_b[10] , \MPYK_csa_b[9] , \MPYK_csa_b[8] , 
     n_Logic0_, \MPYK_csa_b[6] , \MPYK_csa_b[5] , n_Logic0_, n_Logic0_, 
     n_Logic0_, n_Logic0_, \MPYK_csa_b[0] }), .Cin(n_Logic0_));
  fa_11_fa_11 FA1_R00C11 (.Cout(csa_oc[11]), .Sum(\csa_os[11] ), .A(n230), 
     .B(n246), .C(OH_8X8[3]));
  SEH_BUF_D_3 BW1_BUF6893 (.A(n153_3), .X(n153_5));
  SEH_INV_S_3 U350 (.A(n307), .X(n296));
  SEH_OAI22_3 U51 (.A1(n302), .A2(n96), .B1(n296), .B2(n97), .X(n210));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_5_ (.CK(CLK_15), .D(n191), .Q(MPYK_oreg[5]), 
     .RD(n153_8));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_1_ (.CK(CLK_15), .D(n204), .Q(MPYJ_oreg[1]), 
     .RD(n202_3));
  SEH_AO2BB2_DG_3 U184 (.A1(n288), .A2(n128), .B1(mpy16_reg[7]), .B2(n289), 
     .X(O_16X16[7]));
  SEH_AO2BB2_DG_3 U186 (.A1(n288), .A2(n130), .B1(mpy16_reg[5]), .B2(n289), 
     .X(O_16X16[5]));
  SEH_INV_S_3 HFN1_INV_H1062_2 (.A(ILRST_3), .X(n153_3));
  SEH_TIE1_G_1 U43 (.X(n1));
  SEH_INV_S_3 U154 (.A(n157), .X(n127));
  SEH_OAI22_3 U9 (.A1(n308), .A2(n14), .B1(n301), .B2(n15), .X(n168));
  SEH_INV_S_3 U249 (.A(\cla_o[4] ), .X(n11));
  SEH_BUF_D_3 BW1_BUF6326 (.A(n153_5), .X(n153_6));
  SEH_INV_S_3 HFN1_INV_H1062_1 (.A(ILRST_2), .X(n153_2));
  SEH_INV_S_3 U243 (.A(\cla_o[6] ), .X(n15));
  SEH_DEL_L6_1 OPTHOLD_G_7 (.A(ILRST), .X(ILRST_2));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_13_ (.CK(CLK_10), .D(n167), .Q(mpy16_reg[13]), 
     .RD(n153_2));
  SEH_INV_S_3 U180 (.A(mpy16_reg[9]), .X(n4));
  SEH_INV_S_3 U79 (.A(MPYJ_oreg[5]), .X(n92));
  SEH_OAI22_3 U254 (.A1(n6), .A2(n290), .B1(n285), .B2(n7), .X(O_16X16[10]));
  SEH_INV_S_3 U255 (.A(\cla_o[2] ), .X(n7));
  MPY8x8_1 MPY_F (.csa_a({\MPYF_csa_a[15] , \MPYF_csa_a[14] , \MPYF_csa_a[13] , 
     \MPYF_csa_a[12] , \MPYF_csa_a[11] , \MPYF_csa_a[10] , \MPYF_csa_a[9] , 
     \MPYF_csa_a[8] , \CLA16_F/r08/A_1 , \MPYF_csa_a[6] , \MPYF_csa_a[5] , 
     \CLA16_F/r05/A_1 , \CLA16_F/r04/A_1 , \CLA16_F/r03/A_1 , \CLA16_F/r02/A_1 , 
     \MPYF_csa_a[0] }), .csa_b({\MPYF_csa_b[15] , \MPYF_csa_b[14] , 
     \MPYF_csa_b[13] , \MPYF_csa_b[12] , \MPYF_csa_b[11] , \MPYF_csa_b[10] , 
     \MPYF_csa_b[9] , \MPYF_csa_b[8] , SYNOPSYS_UNCONNECTED_11, \MPYF_csa_b[6] , 
     \MPYF_csa_b[5] , SYNOPSYS_UNCONNECTED_12, SYNOPSYS_UNCONNECTED_13, 
     SYNOPSYS_UNCONNECTED_14, SYNOPSYS_UNCONNECTED_15, \MPYF_csa_b[0] }), 
     .multiplicand({A[15], A[14], A[13], A[12], A[11], A[10], A[9], n154}), 
     .multiplier({B[15], B[14], B[13], B[12], B[11], B[10], B[9], B[8]}), 
     .signed_MPD(ASGND_1), .signed_MPR(BSGND_3));
  SEH_FDPRBQ_V2_3 MPYK_oreg_reg_0_ (.CK(CLK_16), .D(n186), .Q(MPYK_oreg[0]), 
     .RD(n153_10));
  SEH_INV_S_3 U111 (.A(MPYK_o[1]), .X(n53));
  SEH_AO22_DG_3 U279 (.A1(MPYG_o[14]), .A2(n127), .B1(MPYG_oreg[14]), .B2(n157), 
     .X(OL_8X8[14]));
  SEH_OAI22_3 U65 (.A1(n84), .A2(n283), .B1(n277), .B2(n85), .X(n220));
  SEH_OAI22_3 U116 (.A1(n56), .A2(n115), .B1(n155), .B2(n57), .X(n238));
  SEH_BUF_3 U160 (.A(GSEL), .X(n158));
  SEH_AO22_DG_3 U179 (.A1(MPYG_o[9]), .A2(n127), .B1(MPYG_oreg[9]), .B2(GSEL), 
     .X(OL_8X8[9]));
  SEH_AO22_DG_3 U277 (.A1(MPYG_o[13]), .A2(n127), .B1(MPYG_oreg[13]), .B2(GSEL), 
     .X(OL_8X8[13]));
  SEH_INV_S_3 U386 (.A(HSEL_1), .X(n293));
  SEH_OAI22_3 U59 (.A1(n277), .A2(n87), .B1(n86), .B2(n284), .X(n221));
  SEH_OAI22_3 U248 (.A1(n10), .A2(n290), .B1(n285), .B2(n11), .X(O_16X16[12]));
  SEH_OAI22_3 U8 (.A1(n307), .A2(n12), .B1(n301), .B2(n13), .X(n167));
  MPY8x8_2 MPY_J (.csa_a({\MPYJ_csa_a[15] , \MPYJ_csa_a[14] , \MPYJ_csa_a[13] , 
     \MPYJ_csa_a[12] , \MPYJ_csa_a[11] , \MPYJ_csa_a[10] , \MPYJ_csa_a[9] , 
     \MPYJ_csa_a[8] , \CLA16_J/r08/A_1 , \MPYJ_csa_a[6] , \MPYJ_csa_a[5] , 
     \CLA16_J/r05/A_1 , \CLA16_J/r04/A_1 , \CLA16_J/r03/A_1 , \CLA16_J/r02/A_1 , 
     \MPYJ_csa_a[0] }), .csa_b({\MPYJ_csa_b[15] , \MPYJ_csa_b[14] , 
     \MPYJ_csa_b[13] , \MPYJ_csa_b[12] , \MPYJ_csa_b[11] , \MPYJ_csa_b[10] , 
     \MPYJ_csa_b[9] , \MPYJ_csa_b[8] , SYNOPSYS_UNCONNECTED_6, \MPYJ_csa_b[6] , 
     \MPYJ_csa_b[5] , SYNOPSYS_UNCONNECTED_7, SYNOPSYS_UNCONNECTED_8, 
     SYNOPSYS_UNCONNECTED_9, SYNOPSYS_UNCONNECTED_10, \MPYJ_csa_b[0] }), 
     .multiplicand({A[7], A[6], A[5], A[4], A[3], A[2], A[1], A[0]}), 
     .multiplier({B[15], B[14], B[13], B[12], B[11], B[10], B[9], B[8]}), 
     .signed_MPD(n_Logic0_), .signed_MPR(BSGND_1));
  fa_5_fa_5 FA1_R00C05 (.Cout(csa_oc[5]), .Sum(\csa_os[5] ), .A(OL_8X8[13]), 
     .B(n224), .C(n240));
  fa_14_fa_14 FA1_R00C14 (.Cout(csa_oc[14]), .Sum(\csa_os[14] ), .A(n233), 
     .B(n249), .C(OH_8X8[6]));
  fa_0 FA1_R00C00 (.Cout(csa_oc[0]), .Sum(\csa_os[0] ), .A(OL_8X8[8]), .B(n219), 
     .C(n235));
  fa_13_fa_13 FA1_R00C13 (.Cout(csa_oc[13]), .Sum(\csa_os[13] ), .A(n232), 
     .B(n248), .C(OH_8X8[5]));
  fcla16_2 CLA24_16 (.Sum({\cla_o[15] , \cla_o[14] , \cla_o[13] , \cla_o[12] , 
     \cla_o[11] , \cla_o[10] , \cla_o[9] , \cla_o[8] , \cla_o[7] , \cla_o[6] , 
     \cla_o[5] , \cla_o[4] , \cla_o[3] , \cla_o[2] , \cla_o[1] , csa_os_0_1}), 
     .G(cla24_g0), .P(), .A({\csa_os[15] , \csa_os[14] , \csa_os[13] , 
     \csa_os[12] , \csa_os[11] , \csa_os[10] , \csa_os[9] , \csa_os[8] , 
     \csa_os[7] , \csa_os[6] , \csa_os[5] , \csa_os[4] , \csa_os[3] , 
     \csa_os[2] , \csa_os[1] , \csa_os[0] }), .B({csa_oc[14], csa_oc[13], 
     csa_oc[12], csa_oc[11], csa_oc[10], csa_oc[9], csa_oc[8], csa_oc[7], 
     csa_oc[6], csa_oc[5], csa_oc[4], csa_oc[3], csa_oc[2], csa_oc[1], 
     csa_oc[0], n_Logic0_}), .Cin(n_Logic0_));
  SEH_OAI22_3 U10 (.A1(n309), .A2(n16), .B1(n301), .B2(n17), .X(n169));
  SEH_INV_S_3 U257 (.A(mpy16_reg[10]), .X(n6));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_11_ (.CK(CLK_8), .D(n165), .Q(mpy16_reg[11]), 
     .RD(n153_6));
  SEH_INV_S_3 U356 (.A(n293), .X(n288));
  SEH_INV_S_3 U244 (.A(mpy16_reg[14]), .X(n14));
  SEH_FDPRBQ_V2_3 mpy16_reg_reg_12_ (.CK(CLK_10), .D(n166), .Q(mpy16_reg[12]), 
     .RD(n153_2));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_13_ (.CK(CLK_7), .D(MPYF_o[13]), 
     .Q(MPYF_oreg[13]), .RD(n202_4));
  SEH_TIE0_G_1 U387 (.X(n_Logic0_));
  SEH_INV_S_3 U85 (.A(MPYJ_oreg[7]), .X(n96));
  SEH_INV_S_3 U75 (.A(MPYJ_o[4]), .X(n91));
  fcla16_4 CLA16_F (.Sum(MPYF_o), .G(), .P(), .A({\MPYF_csa_a[15] , 
     \MPYF_csa_a[14] , \MPYF_csa_a[13] , \MPYF_csa_a[12] , \MPYF_csa_a[11] , 
     \MPYF_csa_a[10] , \MPYF_csa_a[9] , \MPYF_csa_a[8] , \CLA16_F/r08/A_1 , 
     \MPYF_csa_a[6] , \MPYF_csa_a[5] , \CLA16_F/r05/A_1 , \CLA16_F/r04/A_1 , 
     \CLA16_F/r03/A_1 , \CLA16_F/r02/A_1 , \MPYF_csa_a[0] }), .B({
     \MPYF_csa_b[15] , \MPYF_csa_b[14] , \MPYF_csa_b[13] , \MPYF_csa_b[12] , 
     \MPYF_csa_b[11] , \MPYF_csa_b[10] , \MPYF_csa_b[9] , \MPYF_csa_b[8] , 
     n_Logic0_, \MPYF_csa_b[6] , \MPYF_csa_b[5] , n_Logic0_, n_Logic0_, 
     n_Logic0_, n_Logic0_, \MPYF_csa_b[0] }), .Cin(n_Logic0_));
  fa_3_fa_3 FA1_R00C03 (.Cout(csa_oc[3]), .Sum(\csa_os[3] ), .A(OL_8X8[11]), 
     .B(n222), .C(n238));
  fa_7_fa_7 FA1_R00C07 (.Cout(csa_oc[7]), .Sum(\csa_os[7] ), .A(OL_8X8[15]), 
     .B(n226), .C(n242));
  MPY8x8_0 MPY_K (.csa_a({\MPYK_csa_a[15] , \MPYK_csa_a[14] , \MPYK_csa_a[13] , 
     \MPYK_csa_a[12] , \MPYK_csa_a[11] , \MPYK_csa_a[10] , \MPYK_csa_a[9] , 
     \MPYK_csa_a[8] , \CLA16_K/r08/A_1 , \MPYK_csa_a[6] , \MPYK_csa_a[5] , 
     \CLA16_K/r05/A_1 , \CLA16_K/r04/A_1 , \CLA16_K/r03/A_1 , \CLA16_K/r02/A_1 , 
     \MPYK_csa_a[0] }), .csa_b({\MPYK_csa_b[15] , \MPYK_csa_b[14] , 
     \MPYK_csa_b[13] , \MPYK_csa_b[12] , \MPYK_csa_b[11] , \MPYK_csa_b[10] , 
     \MPYK_csa_b[9] , \MPYK_csa_b[8] , SYNOPSYS_UNCONNECTED_16, \MPYK_csa_b[6] , 
     \MPYK_csa_b[5] , SYNOPSYS_UNCONNECTED_17, SYNOPSYS_UNCONNECTED_18, 
     SYNOPSYS_UNCONNECTED_19, SYNOPSYS_UNCONNECTED_20, \MPYK_csa_b[0] }), 
     .multiplicand({A[15], A[14], A[13], A[12], A[11], A[10], A[9], A[8]}), 
     .multiplier({B[7], B[6], B[5], B[4], B[3], B[2], B[1], B[0]}), 
     .signed_MPD(ASGND_3), .signed_MPR(n_Logic0_));
  fa_2_fa_2 FA1_R00C02 (.Cout(csa_oc[2]), .Sum(\csa_os[2] ), .A(OL_8X8[10]), 
     .B(n221), .C(n237));
  fa_1_fa_1 FA1_R00C01 (.Cout(csa_oc[1]), .Sum(\csa_os[1] ), .A(OL_8X8[9]), 
     .B(n220), .C(n236));
  SEH_INV_S_3 U106 (.A(MPYJ_oreg[14]), .X(n110));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_14_ (.CK(CLK_12_1), .D(n217), .Q(MPYJ_oreg[14]), 
     .RD(n202_1));
  SEH_FDPRBQ_V2_3 MPYF_oreg_reg_6_ (.CK(CLK_12_1), .D(MPYF_o[6]), 
     .Q(MPYF_oreg[6]), .RD(n202_1));
  SEH_INV_S_3 U105 (.A(MPYJ_o[14]), .X(n111));
  SEH_FDPHRBSBQ_1 mpy16_reg_reg_2_ (.CK(CLK_1), .D(OL_8X8[2]), .EN(n294), 
     .Q(mpy16_reg[2]), .RD(n153_3), .SD(n1));
  SEH_FDPHRBSBQ_1 mpy16_reg_reg_3_ (.CK(CLK_1), .D(OL_8X8[3]), .EN(n294), 
     .Q(mpy16_reg[3]), .RD(n153_3), .SD(n1));
  SEH_OAI22_3 U80 (.A1(n94), .A2(n284), .B1(n277), .B2(n95), .X(n225));
  SEH_AO2BB2_DG_3 U226 (.A1(n288), .A2(n134), .B1(mpy16_reg[1]), .B2(n289), 
     .X(O_16X16[1]));
  SEH_FDPRBQ_V2_3 MPYJ_oreg_reg_6_ (.CK(CLK_15), .D(n209), .Q(MPYJ_oreg[6]), 
     .RD(n202_3));
  SEH_OAI22_3 U29 (.A1(n305), .A2(n54), .B1(n298), .B2(n55), .X(n188));
  SEH_OAI22_3 U119 (.A1(n58), .A2(n115), .B1(n156), .B2(n59), .X(n239));
  SEH_OAI22_3 U32 (.A1(n304), .A2(n60), .B1(n298), .B2(n61), .X(n191));
  fa_9_fa_9 FA1_R00C09 (.Cout(csa_oc[9]), .Sum(\csa_os[9] ), .A(n228), .B(n244), 
     .C(OH_8X8[1]));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_1_ (.CK(CLK_6), .D(MPYG_o[1]), .Q(MPYG_oreg[1]), 
     .RD(n153_7));
  SEH_AOI22_3 U174 (.A1(MPYG_o[5]), .A2(n137), .B1(MPYG_oreg[5]), .B2(n158), 
     .X(n130));
  SEH_INV_S_3 U385 (.A(JKSEL_1), .X(n284));
  SEH_AO2BB2_DG_3 U188 (.A1(n288), .A2(n132), .B1(mpy16_reg[3]), .B2(n289), 
     .X(O_16X16[3]));
  SEH_INV_S_3 U289 (.A(n135), .X(OL_8X8[0]));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_12_ (.CK(CLK_2), .D(MPYG_o[12]), 
     .Q(MPYG_oreg[12]), .RD(n153_5));
  SEH_INV_S_3 U265 (.A(n129), .X(OL_8X8[6]));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_7_ (.CK(CLK_2), .D(MPYG_o[7]), .Q(MPYG_oreg[7]), 
     .RD(n153_5));
  SEH_AO22_DG_3 U261 (.A1(MPYG_o[12]), .A2(n127), .B1(MPYG_oreg[12]), .B2(n157), 
     .X(OL_8X8[12]));
  SEH_AOI22_3 U256 (.A1(MPYG_o[7]), .A2(n127), .B1(MPYG_oreg[7]), .B2(n158), 
     .X(n128));
  SEH_INV_S_3 U267 (.A(n130), .X(OL_8X8[5]));
  SEH_FDPHRBSBQ_1 mpy16_reg_reg_5_ (.CK(CLK_1), .D(OL_8X8[5]), .EN(n294), 
     .Q(mpy16_reg[5]), .RD(n153_3), .SD(n1));
  SEH_DEL_L6_1 OPTHOLD_G_8 (.A(ILRST), .X(ILRST_3));
  SEH_FDPHRBSBQ_1 mpy16_reg_reg_4_ (.CK(CLK_4), .D(OL_8X8[4]), .EN(n294), 
     .Q(mpy16_reg[4]), .RD(n153_3), .SD(n1));
  SEH_FDPHRBSBQ_1 mpy16_reg_reg_7_ (.CK(CLK_1), .D(OL_8X8[7]), .EN(n294), 
     .Q(mpy16_reg[7]), .RD(n153_3), .SD(n1));
  SEH_OAI22_3 U4 (.A1(n308), .A2(n4), .B1(n301), .B2(n5), .X(n163));
  SEH_INV_S_3 U253 (.A(mpy16_reg[11]), .X(n8));
  SEH_AOI22_3 U176 (.A1(MPYG_o[1]), .A2(n137), .B1(MPYG_oreg[1]), .B2(n157), 
     .X(n134));
  SEH_OAI22_3 U251 (.A1(n8), .A2(n290), .B1(n285), .B2(n9), .X(O_16X16[11]));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_9_ (.CK(CLK_2), .D(MPYG_o[9]), .Q(MPYG_oreg[9]), 
     .RD(n153_6));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_8_ (.CK(CLK_2), .D(MPYG_o[8]), .Q(MPYG_oreg[8]), 
     .RD(n153_5));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_2_ (.CK(CLK_6), .D(MPYG_o[2]), .Q(MPYG_oreg[2]), 
     .RD(n153_7));
  SEH_FDPRBQ_V2_3 MPYG_oreg_reg_0_ (.CK(CLK_1), .D(MPYG_o[0]), .Q(MPYG_oreg[0]), 
     .RD(n153_7));
  SEH_INV_S_3 U275 (.A(n134), .X(OL_8X8[1]));
  SEH_AOI22_3 U291 (.A1(MPYG_o[2]), .A2(n137), .B1(MPYG_oreg[2]), .B2(n158), 
     .X(n133));
  SEH_INV_S_3 U263 (.A(n128), .X(OL_8X8[7]));
  SEH_AO2BB2_DG_3 U258 (.A1(n288), .A2(n135), .B1(mpy16_reg[0]), .B2(n289), 
     .X(O_16X16[0]));
endmodule

// Entity:MPY8x8_0 Model:MPY8x8_0 Library:magma_checknetlist_lib
module MPY8x8_0 (csa_a, csa_b, multiplicand, multiplier, signed_MPD, signed_MPR);
  input signed_MPD, signed_MPR;
  input [7:0] multiplicand;
  input [7:0] multiplier;
  output [15:0] csa_a;
  output [15:0] csa_b;
  wire [8:2] PP0;
  wire [8:0] PP1;
  wire [8:0] PP2;
  wire [8:0] PP3;
  wire [7:0] PP4;
  wire [4:0] booth_single;
  wire [3:0] booth_double;
  wire [3:1] booth_negtive;
  wire n_Logic1_, pp_sign_0_, FA1_R00C14_C, FA1_R00C14_S, FA1_R00C13_C, 
     FA1_R00C13_S, FA1_R00C12_C, FA1_R00C12_S, FA1_R00C11_C, FA1_R00C11_S, 
     HA1_R03C11_C, HA1_R03C11_S, FA1_R00C10_C, FA1_R00C10_S, HA1_R03C10_C, 
     HA1_R03C10_S, FA1_R00C09_C, FA1_R00C09_S, HA1_R03C09_C, HA1_R03C09_S, 
     FA1_R00C08_C, FA1_R00C08_S, FA1_R03C08_C, FA1_R03C08_S, FA1_R00C07_C, 
     FA1_R00C07_S, FA1_R00C06_C, FA1_R00C06_S, HA1_R03C06_C, HA1_R03C06_S, 
     FA1_R00C05_C, FA1_R00C05_S, FA1_R00C04_C, FA1_R00C04_S, FA1_R00C02_C, 
     FA2_R00C15_S, HA2_R00C14_C, HA2_R00C14_S, HA2_R00C13_C, HA2_R00C13_S, 
     FA2_R00C12_C, FA2_R00C12_S, FA2_R00C11_C, FA2_R00C11_S, FA2_R00C10_C, 
     FA2_R00C10_S, FA2_R00C09_C, FA2_R00C09_S, FA2_R00C08_C, FA2_R00C08_S, 
     FA2_R00C07_C, FA2_R00C07_S, FA2_R00C06_C, FA2_R00C03_C, n16, n29, n30, n31, 
     n32, n33, n34, n35, n36, n37, n40, n41, n42, n43, SYNOPSYS_UNCONNECTED_1, 
     SYNOPSYS_UNCONNECTED_2;
  ha_23 HA1_R03C11 (.Cout(HA1_R03C11_C), .Sum(HA1_R03C11_S), .A(PP3[5]), 
     .B(PP4[3]));
  fa_82 FA2_R00C11 (.Cout(FA2_R00C11_C), .Sum(FA2_R00C11_S), .A(FA1_R00C11_S), 
     .B(FA1_R00C10_C), .C(HA1_R03C11_S));
  ha_27 HA3_R00C15 (.Cout(), .Sum(csa_a[15]), .A(FA2_R00C15_S), .B(HA2_R00C14_C));
  fa_68 FA2_R00C08 (.Cout(FA2_R00C08_C), .Sum(FA2_R00C08_S), .A(FA1_R00C08_S), 
     .B(FA1_R00C07_C), .C(FA1_R03C08_S));
  fa_81 FA2_R00C12 (.Cout(FA2_R00C12_C), .Sum(FA2_R00C12_S), .A(FA1_R00C12_S), 
     .B(FA1_R00C11_C), .C(HA1_R03C11_C));
  fa_73 FA3_R00C11 (.Cout(csa_b[12]), .Sum(csa_a[11]), .A(FA2_R00C11_S), 
     .B(FA2_R00C10_C), .C(HA1_R03C10_C));
  fa_79 FA1_R00C02 (.Cout(FA1_R00C02_C), .Sum(csa_a[2]), .A(PP0[2]), .B(PP1[0]), 
     .C(booth_negtive[1]));
  fa_66 FA3_R00C07 (.Cout(csa_b[8]), .Sum(csa_a[7]), .A(FA2_R00C07_S), 
     .B(FA2_R00C06_C), .C(PP3[1]));
  fa_76 FA1_R00C06 (.Cout(FA1_R00C06_C), .Sum(FA1_R00C06_S), .A(PP0[6]), 
     .B(PP1[4]), .C(PP2[2]));
  fa_57 FA1_R00C14 (.Cout(FA1_R00C14_C), .Sum(FA1_R00C14_S), .A(n_Logic1_), 
     .B(PP3[8]), .C(PP4[6]));
  ha_25 HA1_R03C09 (.Cout(HA1_R03C09_C), .Sum(HA1_R03C09_S), .A(PP3[3]), 
     .B(PP4[1]));
  fa_83 FA2_R00C10 (.Cout(FA2_R00C10_C), .Sum(FA2_R00C10_S), .A(FA1_R00C10_S), 
     .B(FA1_R00C09_C), .C(HA1_R03C10_S));
  SEH_INV_S_3 U5 (.A(csa_b[0]), .X(n42));
  SEH_ND3_3 U6 (.A1(n37), .A2(n42), .A3(n41), .X(n43));
  SEH_EO2_G_3 U31 (.A1(n34), .A2(booth_negtive[3]), .X(n31));
  SEH_TIE0_G_1 U8 (.X(n16));
  SEH_EO2_G_3 U29 (.A1(n35), .A2(booth_negtive[2]), .X(n32));
  SEH_OAI21_S_3 U32 (.A1(booth_single[3]), .A2(booth_double[3]), .B(n37), 
     .X(n34));
  SEH_INV_S_3 U23 (.A(pp_sign_0_), .X(n40));
  SEH_TIE1_G_1 U3 (.X(n_Logic1_));
  SEH_INV_S_3 U22 (.A(multiplicand[7]), .X(n30));
  fa_84 FA2_R00C09 (.Cout(FA2_R00C09_C), .Sum(FA2_R00C09_S), .A(FA1_R00C09_S), 
     .B(FA1_R00C08_C), .C(HA1_R03C09_S));
  fa_75 FA3_R00C09 (.Cout(csa_b[10]), .Sum(csa_a[9]), .A(FA2_R00C09_S), 
     .B(FA2_R00C08_C), .C(FA1_R03C08_C));
  fa_67 FA3_R00C04 (.Cout(csa_b[5]), .Sum(csa_a[4]), .A(FA1_R00C04_S), 
     .B(booth_negtive[2]), .C(FA2_R00C03_C));
  fa_71 FA2_R00C03 (.Cout(FA2_R00C03_C), .Sum(csa_a[3]), .A(PP0[3]), .B(PP1[1]), 
     .C(FA1_R00C02_C));
  ha_26 HA3_R00C05 (.Cout(csa_b[6]), .Sum(csa_a[5]), .A(FA1_R00C05_S), 
     .B(FA1_R00C04_C));
  SEH_AOAI211_3 U7 (.A1(n37), .A2(n41), .B(n42), .C(n43), .X(pp_sign_0_));
  SEH_INV_S_3 U13 (.A(n30), .X(n29));
  SEH_OAI21_S_3 U30 (.A1(booth_single[2]), .A2(booth_double[2]), .B(n37), 
     .X(n35));
  SEH_AN2_S_3 U33 (.A1(signed_MPD), .A2(n29), .X(n37));
  SEH_OR2_2P5 U4 (.A1(booth_double[0]), .A2(booth_single[0]), .X(n41));
  SEH_EO2_G_3 U24 (.A1(n36), .A2(booth_negtive[1]), .X(n33));
  SEH_OAI21_S_3 U25 (.A1(booth_single[1]), .A2(booth_double[1]), .B(n37), 
     .X(n36));
  ha_29 HA3_R00C13 (.Cout(csa_b[14]), .Sum(csa_a[13]), .A(HA2_R00C13_S), 
     .B(FA2_R00C12_C));
  fa_58 FA1_R00C13 (.Cout(FA1_R00C13_C), .Sum(FA1_R00C13_S), .A(n32), .B(PP3[7]), 
     .C(PP4[5]));
  fa_60 FA1_R00C11 (.Cout(FA1_R00C11_C), .Sum(FA1_R00C11_S), .A(n40), .B(n33), 
     .C(PP2[7]));
  fa_64 FA1_R03C08 (.Cout(FA1_R03C08_C), .Sum(FA1_R03C08_S), .A(PP3[2]), 
     .B(PP4[0]), .C(n16));
  booth_selector_0 booth_selector (.pp_out({SYNOPSYS_UNCONNECTED_2, PP4[7], 
     PP4[6], PP4[5], PP4[4], PP4[3], PP4[2], PP4[1], PP4[0], PP3[8], PP3[7], 
     PP3[6], PP3[5], PP3[4], PP3[3], PP3[2], PP3[1], PP3[0], PP2[8], PP2[7], 
     PP2[6], PP2[5], PP2[4], PP2[3], PP2[2], PP2[1], PP2[0], PP1[8], PP1[7], 
     PP1[6], PP1[5], PP1[4], PP1[3], PP1[2], PP1[1], PP1[0], PP0[8], PP0[7], 
     PP0[6], PP0[5], PP0[4], PP0[3], PP0[2], csa_a[1], csa_a[0]}), 
     .booth_single(booth_single), .booth_double({n16, booth_double[3], 
     booth_double[2], booth_double[1], booth_double[0]}), .booth_negtive({n16, 
     booth_negtive[3], booth_negtive[2], booth_negtive[1], csa_b[0]}), 
     .multiplicand({n29, multiplicand[6], multiplicand[5], multiplicand[4], 
     multiplicand[3], multiplicand[2], multiplicand[1], multiplicand[0]}), 
     .signed_mpy(signed_MPD));
  fa_62 FA1_R00C09 (.Cout(FA1_R00C09_C), .Sum(FA1_R00C09_S), .A(pp_sign_0_), 
     .B(PP1[7]), .C(PP2[5]));
  ha_28 HA3_R00C14 (.Cout(csa_b[15]), .Sum(csa_a[14]), .A(HA2_R00C14_S), 
     .B(HA2_R00C13_C));
  fa_65 FA1_R00C07 (.Cout(FA1_R00C07_C), .Sum(FA1_R00C07_S), .A(PP0[7]), 
     .B(PP1[5]), .C(PP2[3]));
  fa_59 FA1_R00C12 (.Cout(FA1_R00C12_C), .Sum(FA1_R00C12_S), .A(n_Logic1_), 
     .B(PP2[8]), .C(PP3[6]));
  ha_24 HA1_R03C10 (.Cout(HA1_R03C10_C), .Sum(HA1_R03C10_S), .A(PP3[4]), 
     .B(PP4[2]));
  ha_33 HA2_R00C13 (.Cout(HA2_R00C13_C), .Sum(HA2_R00C13_S), .A(FA1_R00C13_S), 
     .B(FA1_R00C12_C));
  fa_74 FA3_R00C10 (.Cout(csa_b[11]), .Sum(csa_a[10]), .A(FA2_R00C10_S), 
     .B(FA2_R00C09_C), .C(HA1_R03C09_C));
  fa_72 FA3_R00C12 (.Cout(csa_b[13]), .Sum(csa_a[12]), .A(FA2_R00C12_S), 
     .B(FA2_R00C11_C), .C(PP4[4]));
  fa_69 FA2_R00C07 (.Cout(FA2_R00C07_C), .Sum(FA2_R00C07_S), .A(FA1_R00C07_S), 
     .B(FA1_R00C06_C), .C(HA1_R03C06_C));
  fa_78 FA1_R00C04 (.Cout(FA1_R00C04_C), .Sum(FA1_R00C04_S), .A(PP0[4]), 
     .B(PP1[2]), .C(PP2[0]));
  ha_31 HA1_R03C06 (.Cout(HA1_R03C06_C), .Sum(HA1_R03C06_S), .A(PP3[0]), 
     .B(booth_negtive[3]));
  fa_80 FA2_R00C15 (.Cout(), .Sum(FA2_R00C15_S), .A(n31), .B(PP4[7]), 
     .C(FA1_R00C14_C));
  ha_30 HA3_R00C08 (.Cout(csa_b[9]), .Sum(csa_a[8]), .A(FA2_R00C08_S), 
     .B(FA2_R00C07_C));
  booth_encoder_0 booth_encoder (.booth_single(booth_single), .booth_double({
     SYNOPSYS_UNCONNECTED_1, booth_double[3], booth_double[2], booth_double[1], 
     booth_double[0]}), .multiplier({multiplier[7], multiplier[6], multiplier[5], 
     multiplier[4], multiplier[3], multiplier[2], multiplier[1], multiplier[0]}), 
     .signed_mpy(n16), .booth_negtive_4_(), .booth_negtive_3_(booth_negtive[3]), 
     .booth_negtive_0_(csa_b[0]), .booth_negtive_1_(booth_negtive[1]), 
     .booth_negtive_2_(booth_negtive[2]));
  fa_70 FA2_R00C06 (.Cout(FA2_R00C06_C), .Sum(csa_a[6]), .A(FA1_R00C06_S), 
     .B(FA1_R00C05_C), .C(HA1_R03C06_S));
  fa_61 FA1_R00C10 (.Cout(FA1_R00C10_C), .Sum(FA1_R00C10_S), .A(pp_sign_0_), 
     .B(PP1[8]), .C(PP2[6]));
  fa_63 FA1_R00C08 (.Cout(FA1_R00C08_C), .Sum(FA1_R00C08_S), .A(PP0[8]), 
     .B(PP1[6]), .C(PP2[4]));
  ha_32 HA2_R00C14 (.Cout(HA2_R00C14_C), .Sum(HA2_R00C14_S), .A(FA1_R00C14_S), 
     .B(FA1_R00C13_C));
  fa_77 FA1_R00C05 (.Cout(FA1_R00C05_C), .Sum(FA1_R00C05_S), .A(PP0[5]), 
     .B(PP1[3]), .C(PP2[1]));
endmodule

// Entity:booth_encoder_0 Model:booth_encoder_0 Library:magma_checknetlist_lib
module booth_encoder_0 (booth_single, booth_double, multiplier, signed_mpy, 
     booth_negtive_4_, booth_negtive_3_, booth_negtive_0_, booth_negtive_1_, 
     booth_negtive_2_);
  input signed_mpy;
  output booth_negtive_4_, booth_negtive_3_, booth_negtive_0_, booth_negtive_1_, 
     booth_negtive_2_;
  input [7:0] multiplier;
  output [4:0] booth_single;
  output [4:0] booth_double;
  wire n26, n27, n6, n14, n16, n18, n20, n21, n22, n23, n24, n25;
  SEH_ND2_S_2P5 U27 (.A1(n14), .A2(n24), .X(n21));
  SEH_INV_S_3 U9 (.A(n27), .X(booth_double[1]));
  SEH_ND2_S_2P5 U22 (.A1(n16), .A2(n25), .X(n22));
  SEH_EO2_G_3 U24 (.A1(multiplier[2]), .A2(booth_negtive_0_), 
     .X(booth_single[1]));
  SEH_NR2_S_2P5 U16 (.A1(multiplier[0]), .A2(n14), .X(booth_double[0]));
  SEH_INV_S_3 U11 (.A(n14), .X(booth_negtive_0_));
  SEH_INV_S_3 U13 (.A(multiplier[3]), .X(n16));
  SEH_INV_S_3 U21 (.A(multiplier[7]), .X(n20));
  SEH_EO2_G_3 U25 (.A1(multiplier[4]), .A2(booth_negtive_1_), 
     .X(booth_single[2]));
  SEH_INV_S_3 U28 (.A(multiplier[2]), .X(n24));
  SEH_INV_S_3 U23 (.A(multiplier[4]), .X(n25));
  SEH_INV_S_3 U15 (.A(n20), .X(booth_negtive_3_));
  SEH_BUF_3 U2 (.A(booth_negtive_3_), .X(booth_single[4]));
  SEH_INV_S_3 U14 (.A(multiplier[5]), .X(n18));
  SEH_INV_S_3 U12 (.A(multiplier[1]), .X(n14));
  SEH_BUF_3 U17 (.A(multiplier[0]), .X(booth_single[0]));
  SEH_INV_S_3 U5 (.A(n16), .X(booth_negtive_1_));
  SEH_OA32_4 U8 (.A1(n14), .A2(booth_negtive_1_), .A3(n24), .B1(n16), .B2(n21), 
     .X(n27));
  SEH_OAI32_4 U4 (.A1(n16), .A2(booth_negtive_2_), .A3(n25), .B1(n18), .B2(n22), 
     .X(booth_double[2]));
  SEH_INV_S_3 U6 (.A(n26), .X(n6));
  SEH_INV_S_3 U10 (.A(n18), .X(booth_negtive_2_));
  SEH_NR2_S_2P5 U19 (.A1(n26), .A2(n23), .X(booth_double[3]));
  SEH_EO2_G_3 U26 (.A1(booth_negtive_2_), .A2(multiplier[6]), .X(n26));
  SEH_EO2_G_3 U20 (.A1(booth_negtive_3_), .A2(n18), .X(n23));
  SEH_INV_S_3 U7 (.A(n6), .X(booth_single[3]));
endmodule

// Entity:booth_selector_0 Model:booth_selector_0 Library:magma_checknetlist_lib
module booth_selector_0 (pp_out, booth_single, booth_double, booth_negtive, 
     multiplicand, signed_mpy);
  input signed_mpy;
  input [4:0] booth_single;
  input [4:0] booth_double;
  input [4:0] booth_negtive;
  input [7:0] multiplicand;
  output [44:0] pp_out;
  wire n47, n48, n49, n50, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, 
     n62, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, 
     n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, 
     n94, n95, n96, n97, n98, n99, n104, n110, n111, n112, n113, n114, n115, 
     n116;
  SEH_BUF_3 U9 (.A(booth_single[2]), .X(n54));
  SEH_INV_S_3 U25 (.A(n70), .X(n69));
  SEH_AN2_S_3 U90 (.A1(signed_mpy), .A2(multiplicand[7]), .X(n114));
  SEH_AOI22_3 U105 (.A1(booth_double[1]), .A2(multiplicand[2]), 
     .B1(multiplicand[3]), .B2(booth_single[1]), .X(n74));
  SEH_EN2_G_3 U52 (.A1(n65), .A2(n113), .X(pp_out[7]));
  SEH_EN2_G_3 U47 (.A1(n66), .A2(n77), .X(pp_out[15]));
  SEH_EN2_G_3 U67 (.A1(n65), .A2(n110), .X(pp_out[4]));
  SEH_EN2_G_3 U104 (.A1(n65), .A2(n111), .X(pp_out[5]));
  SEH_AOI22_3 U115 (.A1(booth_double[1]), .A2(multiplicand[4]), 
     .B1(multiplicand[5]), .B2(booth_single[1]), .X(n76));
  SEH_AOI22_3 U53 (.A1(multiplicand[6]), .A2(n47), .B1(booth_single[0]), 
     .B2(n69), .X(n113));
  SEH_BUF_3 U15 (.A(multiplicand[4]), .X(n60));
  SEH_EN2_G_3 U30 (.A1(n66), .A2(n73), .X(pp_out[11]));
  SEH_AOI22_3 U56 (.A1(booth_double[1]), .A2(multiplicand[3]), 
     .B1(multiplicand[4]), .B2(booth_single[1]), .X(n75));
  SEH_ND2_S_2P5 U62 (.A1(booth_single[3]), .A2(multiplicand[0]), .X(n90));
  SEH_AN2_S_3 U19 (.A1(booth_single[4]), .A2(n59), .X(pp_out[39]));
  SEH_AN2_S_3 U88 (.A1(booth_single[4]), .A2(n61), .X(pp_out[41]));
  SEH_AN2_S_3 U91 (.A1(booth_single[4]), .A2(n60), .X(pp_out[40]));
  SEH_AN2_S_3 U6 (.A1(booth_single[4]), .A2(multiplicand[0]), .X(pp_out[36]));
  SEH_AOI22_3 U38 (.A1(n49), .A2(multiplicand[1]), .B1(booth_single[2]), 
     .B2(multiplicand[2]), .X(n83));
  SEH_EN2_G_3 U55 (.A1(n66), .A2(n75), .X(pp_out[13]));
  SEH_EN2_G_3 U39 (.A1(n67), .A2(n84), .X(pp_out[21]));
  SEH_EN2_G_3 U35 (.A1(n67), .A2(n81), .X(pp_out[19]));
  SEH_ND2_S_2P5 U60 (.A1(n54), .A2(n56), .X(n80));
  SEH_AOI22_3 U36 (.A1(n49), .A2(multiplicand[0]), .B1(n54), 
     .B2(multiplicand[1]), .X(n81));
  SEH_EN2_G_3 U26 (.A1(n65), .A2(n112), .X(pp_out[6]));
  SEH_EN2_G_3 U54 (.A1(n66), .A2(n74), .X(pp_out[12]));
  SEH_EN2_G_3 U59 (.A1(n67), .A2(n80), .X(pp_out[18]));
  SEH_EN2_G_3 U37 (.A1(n67), .A2(n83), .X(pp_out[20]));
  SEH_EN2_G_3 U51 (.A1(n68), .A2(n92), .X(pp_out[29]));
  SEH_EN2_G_3 U61 (.A1(n68), .A2(n90), .X(pp_out[27]));
  SEH_AOI22_3 U50 (.A1(n50), .A2(n59), .B1(booth_single[3]), .B2(n60), .X(n95));
  SEH_AOI22_3 U70 (.A1(n50), .A2(n62), .B1(n55), .B2(n69), .X(n98));
  SEH_EN2_G_3 U49 (.A1(n68), .A2(n95), .X(pp_out[31]));
  SEH_AOI22_3 U42 (.A1(n49), .A2(multiplicand[3]), .B1(booth_single[2]), 
     .B2(multiplicand[4]), .X(n85));
  SEH_EN2_G_3 U41 (.A1(n67), .A2(n85), .X(pp_out[22]));
  SEH_BUF_3 U24 (.A(booth_negtive[3]), .X(n68));
  SEH_BUF_3 U5 (.A(booth_double[3]), .X(n50));
  SEH_AN2_S_3 U89 (.A1(booth_single[4]), .A2(n69), .X(pp_out[43]));
  SEH_AN2_S_3 U92 (.A1(booth_single[4]), .A2(n62), .X(pp_out[42]));
  SEH_EN2_G_3 U69 (.A1(n68), .A2(n98), .X(pp_out[34]));
  SEH_AOI22_3 U110 (.A1(n50), .A2(n60), .B1(booth_single[3]), .B2(n61), .X(n96));
  SEH_EN2_G_3 U46 (.A1(n68), .A2(n97), .X(pp_out[33]));
  SEH_AOI22_3 U45 (.A1(n49), .A2(n62), .B1(n54), .B2(n69), .X(n88));
  SEH_AOI22_3 U113 (.A1(n49), .A2(multiplicand[4]), .B1(booth_single[2]), 
     .B2(multiplicand[5]), .X(n86));
  SEH_BUF_3 U16 (.A(multiplicand[5]), .X(n61));
  SEH_AOI22_3 U27 (.A1(multiplicand[5]), .A2(n47), .B1(multiplicand[6]), 
     .B2(booth_single[0]), .X(n112));
  SEH_AOI22_3 U114 (.A1(booth_double[1]), .A2(multiplicand[5]), 
     .B1(multiplicand[6]), .B2(booth_single[1]), .X(n77));
  SEH_BUF_3 U13 (.A(multiplicand[2]), .X(n58));
  SEH_BUF_3 U4 (.A(booth_double[2]), .X(n49));
  SEH_AOI22_3 U86 (.A1(n55), .A2(n114), .B1(n50), .B2(n69), .X(n99));
  SEH_AOI22_3 U82 (.A1(n114), .A2(booth_single[1]), .B1(booth_double[1]), 
     .B2(multiplicand[7]), .X(n79));
  SEH_BUF_S_3 U10 (.A(booth_single[3]), .X(n55));
  SEH_AOI22_3 U68 (.A1(multiplicand[3]), .A2(n47), .B1(n60), 
     .B2(booth_single[0]), .X(n110));
  SEH_BUF_3 U23 (.A(booth_negtive[2]), .X(n67));
  SEH_AOI22_3 U33 (.A1(n50), .A2(n58), .B1(booth_single[3]), .B2(n59), .X(n94));
  SEH_AOI22_3 U40 (.A1(n49), .A2(multiplicand[2]), .B1(booth_single[2]), 
     .B2(multiplicand[3]), .X(n84));
  SEH_AOI22_3 U58 (.A1(n50), .A2(n56), .B1(n55), .B2(n57), .X(n91));
  SEH_AOI22_3 U106 (.A1(n50), .A2(multiplicand[1]), .B1(booth_single[3]), 
     .B2(multiplicand[2]), .X(n92));
  SEH_AOI22_3 U84 (.A1(booth_single[2]), .A2(n114), .B1(n49), .B2(n69), .X(n89));
  SEH_AOI22_3 U111 (.A1(n49), .A2(n61), .B1(booth_single[2]), 
     .B2(multiplicand[6]), .X(n87));
  SEH_EN2_G_3 U44 (.A1(n67), .A2(n88), .X(pp_out[25]));
  SEH_EN2_G_3 U43 (.A1(n67), .A2(n87), .X(pp_out[24]));
  SEH_AOI22_3 U109 (.A1(n50), .A2(n61), .B1(booth_single[3]), .B2(n62), .X(n97));
  SEH_EN2_G_3 U34 (.A1(n67), .A2(n86), .X(pp_out[23]));
  SEH_EN2_G_3 U83 (.A1(booth_negtive[2]), .A2(n89), .X(pp_out[26]));
  SEH_EN2_G_3 U81 (.A1(n66), .A2(n79), .X(pp_out[17]));
  SEH_AOI22_3 U64 (.A1(n58), .A2(n47), .B1(n59), .B2(n52), .X(n104));
  SEH_BUF_3 U7 (.A(booth_single[0]), .X(n52));
  SEH_EN2_G_3 U63 (.A1(n65), .A2(n104), .X(pp_out[3]));
  SEH_EN2_G_3 U79 (.A1(booth_negtive[0]), .A2(n115), .X(pp_out[8]));
  SEH_AOI22_3 U112 (.A1(multiplicand[4]), .A2(n47), .B1(multiplicand[5]), 
     .B2(booth_single[0]), .X(n111));
  SEH_BUF_3 U12 (.A(multiplicand[1]), .X(n57));
  SEH_EN2_G_3 U48 (.A1(n68), .A2(n96), .X(pp_out[32]));
  SEH_AN2_S_3 U18 (.A1(multiplicand[1]), .A2(booth_single[4]), .X(pp_out[37]));
  SEH_EN2_G_3 U32 (.A1(n68), .A2(n94), .X(pp_out[30]));
  SEH_EN2_G_3 U116 (.A1(n66), .A2(n76), .X(pp_out[14]));
  SEH_EN2_G_3 U57 (.A1(n68), .A2(n91), .X(pp_out[28]));
  SEH_AN2_S_3 U87 (.A1(n58), .A2(booth_single[4]), .X(pp_out[38]));
  SEH_EN2_G_3 U65 (.A1(n65), .A2(n93), .X(pp_out[2]));
  SEH_EN2_G_3 U73 (.A1(booth_negtive[1]), .A2(n116), .X(pp_out[9]));
  SEH_AOI22_3 U29 (.A1(booth_double[1]), .A2(multiplicand[6]), 
     .B1(multiplicand[7]), .B2(booth_single[1]), .X(n78));
  SEH_BUF_3 U14 (.A(multiplicand[3]), .X(n59));
  SEH_BUF_3 U3 (.A(booth_double[1]), .X(n48));
  SEH_BUF_3 U8 (.A(booth_single[1]), .X(n53));
  SEH_BUF_3 U21 (.A(booth_negtive[1]), .X(n66));
  SEH_AOI22_3 U80 (.A1(booth_single[0]), .A2(n114), .B1(n47), .B2(n69), .X(n115));
  SEH_AOI22_3 U66 (.A1(n57), .A2(n47), .B1(n58), .B2(booth_single[0]), .X(n93));
  SEH_ND2_S_2P5 U76 (.A1(n52), .A2(n56), .X(n71));
  SEH_EN2_G_3 U71 (.A1(n66), .A2(n72), .X(pp_out[10]));
  SEH_AOI22_3 U31 (.A1(n48), .A2(multiplicand[1]), .B1(multiplicand[2]), 
     .B2(n53), .X(n73));
  SEH_EN2_G_3 U85 (.A1(booth_negtive[3]), .A2(n99), .X(pp_out[35]));
  SEH_BUF_3 U2 (.A(booth_double[0]), .X(n47));
  SEH_INV_S_3 U20 (.A(multiplicand[7]), .X(n70));
  SEH_BUF_3 U17 (.A(multiplicand[6]), .X(n62));
  SEH_EN2_G_3 U28 (.A1(n66), .A2(n78), .X(pp_out[16]));
  SEH_AOI22_3 U72 (.A1(n48), .A2(n56), .B1(n57), .B2(n53), .X(n72));
  SEH_BUF_3 U11 (.A(multiplicand[0]), .X(n56));
  SEH_EN2_G_3 U75 (.A1(n65), .A2(n71), .X(pp_out[0]));
  SEH_AOI22_3 U78 (.A1(n47), .A2(n56), .B1(n57), .B2(n52), .X(n82));
  SEH_EN2_G_3 U77 (.A1(n65), .A2(n82), .X(pp_out[1]));
  SEH_ND2_S_2P5 U74 (.A1(multiplicand[0]), .A2(n53), .X(n116));
  SEH_BUF_3 U22 (.A(booth_negtive[0]), .X(n65));
endmodule

// Entity:fa_57 Model:fa_57 Library:magma_checknetlist_lib
module fa_57 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_58 Model:fa_58 Library:magma_checknetlist_lib
module fa_58 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_59 Model:fa_59 Library:magma_checknetlist_lib
module fa_59 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_60 Model:fa_60 Library:magma_checknetlist_lib
module fa_60 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_61 Model:fa_61 Library:magma_checknetlist_lib
module fa_61 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_62 Model:fa_62 Library:magma_checknetlist_lib
module fa_62 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_63 Model:fa_63 Library:magma_checknetlist_lib
module fa_63 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_64 Model:fa_64 Library:magma_checknetlist_lib
module fa_64 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_65 Model:fa_65 Library:magma_checknetlist_lib
module fa_65 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_66 Model:fa_66 Library:magma_checknetlist_lib
module fa_66 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_67 Model:fa_67 Library:magma_checknetlist_lib
module fa_67 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_68 Model:fa_68 Library:magma_checknetlist_lib
module fa_68 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_69 Model:fa_69 Library:magma_checknetlist_lib
module fa_69 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_70 Model:fa_70 Library:magma_checknetlist_lib
module fa_70 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_71 Model:fa_71 Library:magma_checknetlist_lib
module fa_71 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_72 Model:fa_72 Library:magma_checknetlist_lib
module fa_72 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_73 Model:fa_73 Library:magma_checknetlist_lib
module fa_73 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_74 Model:fa_74 Library:magma_checknetlist_lib
module fa_74 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_75 Model:fa_75 Library:magma_checknetlist_lib
module fa_75 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_76 Model:fa_76 Library:magma_checknetlist_lib
module fa_76 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_77 Model:fa_77 Library:magma_checknetlist_lib
module fa_77 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_78 Model:fa_78 Library:magma_checknetlist_lib
module fa_78 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_79 Model:fa_79 Library:magma_checknetlist_lib
module fa_79 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_80 Model:fa_80 Library:magma_checknetlist_lib
module fa_80 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_81 Model:fa_81 Library:magma_checknetlist_lib
module fa_81 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_82 Model:fa_82 Library:magma_checknetlist_lib
module fa_82 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_83 Model:fa_83 Library:magma_checknetlist_lib
module fa_83 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_84 Model:fa_84 Library:magma_checknetlist_lib
module fa_84 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_23 Model:ha_23 Library:magma_checknetlist_lib
module ha_23 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_24 Model:ha_24 Library:magma_checknetlist_lib
module ha_24 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_25 Model:ha_25 Library:magma_checknetlist_lib
module ha_25 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_26 Model:ha_26 Library:magma_checknetlist_lib
module ha_26 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_27 Model:ha_27 Library:magma_checknetlist_lib
module ha_27 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_28 Model:ha_28 Library:magma_checknetlist_lib
module ha_28 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_29 Model:ha_29 Library:magma_checknetlist_lib
module ha_29 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_30 Model:ha_30 Library:magma_checknetlist_lib
module ha_30 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_31 Model:ha_31 Library:magma_checknetlist_lib
module ha_31 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_32 Model:ha_32 Library:magma_checknetlist_lib
module ha_32 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_33 Model:ha_33 Library:magma_checknetlist_lib
module ha_33 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:MPY8x8_1 Model:MPY8x8_1 Library:magma_checknetlist_lib
module MPY8x8_1 (csa_a, csa_b, multiplicand, multiplier, signed_MPD, signed_MPR);
  input signed_MPD, signed_MPR;
  input [7:0] multiplicand;
  input [7:0] multiplier;
  output [15:0] csa_a;
  output [15:0] csa_b;
  wire [8:2] PP0;
  wire [8:0] PP1;
  wire [8:0] PP2;
  wire [8:0] PP3;
  wire [7:0] PP4;
  wire [4:0] booth_single;
  wire [3:0] booth_double;
  wire [4:1] booth_negtive;
  wire n_Logic1_, pp_sign_0_, FA1_R00C14_C, FA1_R00C14_S, FA1_R00C13_C, 
     FA1_R00C13_S, FA1_R00C12_C, FA1_R00C12_S, FA1_R00C11_C, FA1_R00C11_S, 
     HA1_R03C11_C, HA1_R03C11_S, FA1_R00C10_C, FA1_R00C10_S, HA1_R03C10_C, 
     HA1_R03C10_S, FA1_R00C09_C, FA1_R00C09_S, HA1_R03C09_C, HA1_R03C09_S, 
     FA1_R00C08_C, FA1_R00C08_S, FA1_R03C08_C, FA1_R03C08_S, FA1_R00C07_C, 
     FA1_R00C07_S, FA1_R00C06_C, FA1_R00C06_S, HA1_R03C06_C, HA1_R03C06_S, 
     FA1_R00C05_C, FA1_R00C05_S, FA1_R00C04_C, FA1_R00C04_S, FA1_R00C02_C, 
     FA2_R00C15_S, HA2_R00C14_C, HA2_R00C14_S, HA2_R00C13_C, HA2_R00C13_S, 
     FA2_R00C12_C, FA2_R00C12_S, FA2_R00C11_C, FA2_R00C11_S, FA2_R00C10_C, 
     FA2_R00C10_S, FA2_R00C09_C, FA2_R00C09_S, FA2_R00C08_C, FA2_R00C08_S, 
     FA2_R00C07_C, FA2_R00C07_S, FA2_R00C06_C, FA2_R00C03_C, n16, n17, n32, n33, 
     n34, n35, n36, n37, n38, n41, n42, n43, n44, SYNOPSYS_UNCONNECTED_1, 
     SYNOPSYS_UNCONNECTED_2;
  fa_16 FA3_R00C12 (.Cout(csa_b[13]), .Sum(csa_a[12]), .A(FA2_R00C12_S), 
     .B(FA2_R00C11_C), .C(PP4[4]));
  fa_22 FA1_R00C04 (.Cout(FA1_R00C04_C), .Sum(FA1_R00C04_S), .A(PP0[4]), 
     .B(PP1[2]), .C(PP2[0]));
  fa_6 FA1_R00C09 (.Cout(FA1_R00C09_C), .Sum(FA1_R00C09_S), .A(pp_sign_0_), 
     .B(PP1[7]), .C(PP2[5]));
  fa_28 FA2_R00C09 (.Cout(FA2_R00C09_C), .Sum(FA2_R00C09_S), .A(FA1_R00C09_S), 
     .B(FA1_R00C08_C), .C(HA1_R03C09_S));
  booth_selector_1 booth_selector (.pp_out({SYNOPSYS_UNCONNECTED_2, PP4[7], 
     PP4[6], PP4[5], PP4[4], PP4[3], PP4[2], PP4[1], PP4[0], PP3[8], PP3[7], 
     PP3[6], PP3[5], PP3[4], PP3[3], PP3[2], PP3[1], PP3[0], PP2[8], PP2[7], 
     PP2[6], PP2[5], PP2[4], PP2[3], PP2[2], PP2[1], PP2[0], PP1[8], PP1[7], 
     PP1[6], PP1[5], PP1[4], PP1[3], PP1[2], PP1[1], PP1[0], PP0[8], PP0[7], 
     PP0[6], PP0[5], PP0[4], PP0[3], PP0[2], csa_a[1], csa_a[0]}), 
     .booth_single(booth_single), .booth_double({n17, booth_double[3], 
     booth_double[2], booth_double[1], booth_double[0]}), .booth_negtive({n16, 
     booth_negtive[3], booth_negtive[2], booth_negtive[1], csa_b[0]}), 
     .multiplicand({multiplicand[7], multiplicand[6], multiplicand[5], 
     multiplicand[4], multiplicand[3], multiplicand[2], multiplicand[1], 
     multiplicand[0]}), .signed_mpy(signed_MPD));
  fa_15 FA2_R00C03 (.Cout(FA2_R00C03_C), .Sum(csa_a[3]), .A(PP0[3]), .B(PP1[1]), 
     .C(FA1_R00C02_C));
  ha_8 HA3_R00C08 (.Cout(csa_b[9]), .Sum(csa_a[8]), .A(FA2_R00C08_S), 
     .B(FA2_R00C07_C));
  fa_9 FA1_R00C07 (.Cout(FA1_R00C07_C), .Sum(FA1_R00C07_S), .A(PP0[7]), 
     .B(PP1[5]), .C(PP2[3]));
  fa_4 FA1_R00C11 (.Cout(FA1_R00C11_C), .Sum(FA1_R00C11_S), .A(n41), .B(n34), 
     .C(PP2[7]));
  ha_11 HA2_R00C13 (.Cout(HA2_R00C13_C), .Sum(HA2_R00C13_S), .A(FA1_R00C13_S), 
     .B(FA1_R00C12_C));
  ha_6 HA3_R00C14 (.Cout(csa_b[15]), .Sum(csa_a[14]), .A(HA2_R00C14_S), 
     .B(HA2_R00C13_C));
  fa_18 FA3_R00C10 (.Cout(csa_b[11]), .Sum(csa_a[10]), .A(FA2_R00C10_S), 
     .B(FA2_R00C09_C), .C(HA1_R03C09_C));
  SEH_OAI21_S_3 U26 (.A1(booth_single[1]), .A2(booth_double[1]), .B(n38), 
     .X(n37));
  SEH_OAI21_S_3 U31 (.A1(booth_single[2]), .A2(booth_double[2]), .B(n38), 
     .X(n36));
  SEH_INV_S_3 U24 (.A(pp_sign_0_), .X(n41));
  SEH_OAI21_S_3 U33 (.A1(booth_single[3]), .A2(booth_double[3]), .B(n38), 
     .X(n35));
  SEH_EO2_G_3 U30 (.A1(n36), .A2(booth_negtive[2]), .X(n33));
  SEH_TIE1_G_1 U3 (.X(n_Logic1_));
  SEH_EO2_G_3 U32 (.A1(n35), .A2(booth_negtive[3]), .X(n32));
  SEH_TIE0_G_1 U35 (.X(n17));
  fa_14 FA2_R00C06 (.Cout(FA2_R00C06_C), .Sum(csa_a[6]), .A(FA1_R00C06_S), 
     .B(FA1_R00C05_C), .C(HA1_R03C06_S));
  fa_26 FA2_R00C11 (.Cout(FA2_R00C11_C), .Sum(FA2_R00C11_S), .A(FA1_R00C11_S), 
     .B(FA1_R00C10_C), .C(HA1_R03C11_S));
  fa_24 FA2_R00C15 (.Cout(), .Sum(FA2_R00C15_S), .A(n32), .B(PP4[7]), 
     .C(FA1_R00C14_C));
  ha_3 HA1_R03C09 (.Cout(HA1_R03C09_C), .Sum(HA1_R03C09_S), .A(PP3[3]), 
     .B(PP4[1]));
  fa_20 FA1_R00C06 (.Cout(FA1_R00C06_C), .Sum(FA1_R00C06_S), .A(PP0[6]), 
     .B(PP1[4]), .C(PP2[2]));
  SEH_ND3_3 U6 (.A1(n38), .A2(n43), .A3(n42), .X(n44));
  SEH_AN2_S_3 U34 (.A1(signed_MPD), .A2(multiplicand[7]), .X(n38));
  SEH_OR2_2P5 U4 (.A1(booth_double[0]), .A2(booth_single[0]), .X(n42));
  SEH_INV_S_3 U5 (.A(csa_b[0]), .X(n43));
  SEH_BUF_3 U9 (.A(booth_negtive[4]), .X(n16));
  SEH_AOAI211_3 U7 (.A1(n38), .A2(n42), .B(n43), .C(n44), .X(pp_sign_0_));
  SEH_EO2_G_3 U25 (.A1(n37), .A2(booth_negtive[1]), .X(n34));
  fa_5 FA1_R00C10 (.Cout(FA1_R00C10_C), .Sum(FA1_R00C10_S), .A(pp_sign_0_), 
     .B(PP1[8]), .C(PP2[6]));
  fa_21 FA1_R00C05 (.Cout(FA1_R00C05_C), .Sum(FA1_R00C05_S), .A(PP0[5]), 
     .B(PP1[3]), .C(PP2[1]));
  fa_23 FA1_R00C02 (.Cout(FA1_R00C02_C), .Sum(csa_a[2]), .A(PP0[2]), .B(PP1[0]), 
     .C(booth_negtive[1]));
  fa_10 FA3_R00C07 (.Cout(csa_b[8]), .Sum(csa_a[7]), .A(FA2_R00C07_S), 
     .B(FA2_R00C06_C), .C(PP3[1]));
  fa_11 FA3_R00C04 (.Cout(csa_b[5]), .Sum(csa_a[4]), .A(FA1_R00C04_S), 
     .B(booth_negtive[2]), .C(FA2_R00C03_C));
  fa_8 FA1_R03C08 (.Cout(FA1_R03C08_C), .Sum(FA1_R03C08_S), .A(PP3[2]), 
     .B(PP4[0]), .C(booth_negtive[4]));
  fa_19 FA3_R00C09 (.Cout(csa_b[10]), .Sum(csa_a[9]), .A(FA2_R00C09_S), 
     .B(FA2_R00C08_C), .C(FA1_R03C08_C));
  ha_7 HA3_R00C13 (.Cout(csa_b[14]), .Sum(csa_a[13]), .A(HA2_R00C13_S), 
     .B(FA2_R00C12_C));
  fa_2 FA1_R00C13 (.Cout(FA1_R00C13_C), .Sum(FA1_R00C13_S), .A(n33), .B(PP3[7]), 
     .C(PP4[5]));
  booth_encoder_1 booth_encoder (.booth_single(booth_single), .booth_double({
     SYNOPSYS_UNCONNECTED_1, booth_double[3], booth_double[2], booth_double[1], 
     booth_double[0]}), .multiplier({multiplier[7], multiplier[6], multiplier[5], 
     multiplier[4], multiplier[3], multiplier[2], multiplier[1], multiplier[0]}), 
     .signed_mpy(signed_MPR), .booth_negtive_4_(booth_negtive[4]), 
     .booth_negtive_0_(csa_b[0]), .booth_negtive_1_(booth_negtive[1]), 
     .booth_negtive_2_(booth_negtive[2]), .booth_negtive_3_(booth_negtive[3]));
  fa_3 FA1_R00C12 (.Cout(FA1_R00C12_C), .Sum(FA1_R00C12_S), .A(n_Logic1_), 
     .B(PP2[8]), .C(PP3[6]));
  fa_1 FA1_R00C14 (.Cout(FA1_R00C14_C), .Sum(FA1_R00C14_S), .A(n_Logic1_), 
     .B(PP3[8]), .C(PP4[6]));
  ha_5 HA3_R00C15 (.Cout(), .Sum(csa_a[15]), .A(FA2_R00C15_S), .B(HA2_R00C14_C));
  ha_1 HA1_R03C11 (.Cout(HA1_R03C11_C), .Sum(HA1_R03C11_S), .A(PP3[5]), 
     .B(PP4[3]));
  ha_2 HA1_R03C10 (.Cout(HA1_R03C10_C), .Sum(HA1_R03C10_S), .A(PP3[4]), 
     .B(PP4[2]));
  fa_12 FA2_R00C08 (.Cout(FA2_R00C08_C), .Sum(FA2_R00C08_S), .A(FA1_R00C08_S), 
     .B(FA1_R00C07_C), .C(FA1_R03C08_S));
  fa_27 FA2_R00C10 (.Cout(FA2_R00C10_C), .Sum(FA2_R00C10_S), .A(FA1_R00C10_S), 
     .B(FA1_R00C09_C), .C(HA1_R03C10_S));
  fa_25 FA2_R00C12 (.Cout(FA2_R00C12_C), .Sum(FA2_R00C12_S), .A(FA1_R00C12_S), 
     .B(FA1_R00C11_C), .C(HA1_R03C11_C));
  ha_4 HA3_R00C05 (.Cout(csa_b[6]), .Sum(csa_a[5]), .A(FA1_R00C05_S), 
     .B(FA1_R00C04_C));
  fa_13 FA2_R00C07 (.Cout(FA2_R00C07_C), .Sum(FA2_R00C07_S), .A(FA1_R00C07_S), 
     .B(FA1_R00C06_C), .C(HA1_R03C06_C));
  ha_10 HA2_R00C14 (.Cout(HA2_R00C14_C), .Sum(HA2_R00C14_S), .A(FA1_R00C14_S), 
     .B(FA1_R00C13_C));
  fa_17 FA3_R00C11 (.Cout(csa_b[12]), .Sum(csa_a[11]), .A(FA2_R00C11_S), 
     .B(FA2_R00C10_C), .C(HA1_R03C10_C));
  ha_9 HA1_R03C06 (.Cout(HA1_R03C06_C), .Sum(HA1_R03C06_S), .A(PP3[0]), 
     .B(booth_negtive[3]));
  fa_7 FA1_R00C08 (.Cout(FA1_R00C08_C), .Sum(FA1_R00C08_S), .A(PP0[8]), 
     .B(PP1[6]), .C(PP2[4]));
endmodule

// Entity:booth_encoder_1 Model:booth_encoder_1 Library:magma_checknetlist_lib
module booth_encoder_1 (booth_single, booth_double, multiplier, signed_mpy, 
     booth_negtive_4_, booth_negtive_0_, booth_negtive_1_, booth_negtive_2_, 
     booth_negtive_3_);
  input signed_mpy;
  output booth_negtive_4_, booth_negtive_0_, booth_negtive_1_, booth_negtive_2_, 
     booth_negtive_3_;
  input [7:0] multiplier;
  output [4:0] booth_single;
  output [4:0] booth_double;
  wire n26, n10, n14, n16, n18, n20, n21, n22, n23, n24, n25;
  SEH_INV_S_3 U18 (.A(multiplier[7]), .X(n20));
  SEH_INV_S_3 U14 (.A(n20), .X(booth_negtive_3_));
  SEH_EO2_G_3 U17 (.A1(booth_negtive_3_), .A2(n18), .X(n23));
  SEH_INV_S_3 U12 (.A(multiplier[3]), .X(n16));
  SEH_INV_S_3 U13 (.A(multiplier[5]), .X(n18));
  SEH_NR2_S_2P5 U26 (.A1(multiplier[0]), .A2(n14), .X(booth_double[0]));
  SEH_AN2_S_3 U27 (.A1(booth_negtive_3_), .A2(signed_mpy), .X(booth_negtive_4_));
  SEH_NR2B_3 U28 (.A(booth_negtive_3_), .B(signed_mpy), .X(booth_single[4]));
  SEH_INV_S_3 U7 (.A(n10), .X(booth_single[3]));
  SEH_INV_S_3 U11 (.A(multiplier[1]), .X(n14));
  SEH_OAI32_4 U5 (.A1(n16), .A2(booth_negtive_2_), .A3(n25), .B1(n18), .B2(n22), 
     .X(booth_double[2]));
  SEH_EO2_G_3 U24 (.A1(multiplier[4]), .A2(booth_negtive_1_), 
     .X(booth_single[2]));
  SEH_ND2_S_2P5 U19 (.A1(n16), .A2(n25), .X(n22));
  SEH_INV_S_3 U20 (.A(multiplier[4]), .X(n25));
  SEH_INV_S_3 U10 (.A(n14), .X(booth_negtive_0_));
  SEH_INV_S_3 U9 (.A(n18), .X(booth_negtive_2_));
  SEH_INV_S_3 U8 (.A(n16), .X(booth_negtive_1_));
  SEH_EO2_G_3 U25 (.A1(booth_negtive_2_), .A2(multiplier[6]), .X(n26));
  SEH_NR2_S_2P5 U16 (.A1(n26), .A2(n23), .X(booth_double[3]));
  SEH_ND2_S_2P5 U21 (.A1(n14), .A2(n24), .X(n21));
  SEH_EO2_G_3 U23 (.A1(multiplier[2]), .A2(booth_negtive_0_), 
     .X(booth_single[1]));
  SEH_OAI32_4 U4 (.A1(n14), .A2(booth_negtive_1_), .A3(n24), .B1(n16), .B2(n21), 
     .X(booth_double[1]));
  SEH_BUF_3 U15 (.A(multiplier[0]), .X(booth_single[0]));
  SEH_INV_S_3 U6 (.A(n26), .X(n10));
  SEH_INV_S_3 U22 (.A(multiplier[2]), .X(n24));
endmodule

// Entity:booth_selector_1 Model:booth_selector_1 Library:magma_checknetlist_lib
module booth_selector_1 (pp_out, booth_single, booth_double, booth_negtive, 
     multiplicand, signed_mpy);
  input signed_mpy;
  input [4:0] booth_single;
  input [4:0] booth_double;
  input [4:0] booth_negtive;
  input [7:0] multiplicand;
  output [44:0] pp_out;
  wire n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, 
     n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n76, n77, 
     n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, 
     n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, 
     n106, n107, n108, n109, n110, n111, n112, n113, n114, n115, n116, n117, 
     n118, n119, n121, n122, n123, n124, n125, n126, n127;
  SEH_EN2_G_3 U60 (.A1(n76), .A2(n122), .X(pp_out[5]));
  SEH_AN2_S_3 U106 (.A1(signed_mpy), .A2(multiplicand[7]), .X(n125));
  SEH_AOI22_3 U71 (.A1(n48), .A2(n73), .B1(multiplicand[7]), 
     .B2(booth_single[1]), .X(n89));
  SEH_EN2_G_3 U96 (.A1(booth_negtive[0]), .A2(n126), .X(pp_out[8]));
  SEH_EN2_G_3 U70 (.A1(n77), .A2(n89), .X(pp_out[16]));
  SEH_INV_S_3 U28 (.A(n71), .X(n73));
  SEH_EN2_G_3 U117 (.A1(booth_negtive[4]), .A2(n119), .X(pp_out[43]));
  SEH_EN2_G_3 U114 (.A1(booth_negtive[4]), .A2(n116), .X(pp_out[40]));
  SEH_ND2_S_2P5 U118 (.A1(booth_single[4]), .A2(n72), .X(n118));
  SEH_ND2_S_2P5 U115 (.A1(booth_single[4]), .A2(n69), .X(n117));
  SEH_EN2_G_3 U107 (.A1(booth_negtive[4]), .A2(n117), .X(pp_out[41]));
  SEH_EN2_G_3 U116 (.A1(booth_negtive[4]), .A2(n118), .X(pp_out[42]));
  SEH_EN2_G_3 U56 (.A1(n78), .A2(n99), .X(pp_out[25]));
  SEH_ND2_S_2P5 U105 (.A1(booth_single[4]), .A2(n80), .X(n119));
  SEH_ND2_S_2P5 U41 (.A1(booth_single[3]), .A2(multiplicand[0]), .X(n101));
  SEH_EN2_G_3 U40 (.A1(n79), .A2(n101), .X(pp_out[27]));
  SEH_BUF_3 U36 (.A(booth_negtive[3]), .X(n79));
  SEH_EN2_G_3 U90 (.A1(n79), .A2(n109), .X(pp_out[34]));
  SEH_BUF_3 U33 (.A(booth_negtive[0]), .X(n76));
  SEH_BUF_3 U3 (.A(booth_double[1]), .X(n48));
  SEH_INV_S_3 U11 (.A(multiplicand[1]), .X(n56));
  SEH_EN2_G_3 U94 (.A1(n76), .A2(n93), .X(pp_out[1]));
  SEH_BUF_3 U10 (.A(multiplicand[0]), .X(n55));
  SEH_EN2_G_3 U92 (.A1(n77), .A2(n83), .X(pp_out[10]));
  SEH_INV_S_3 U22 (.A(n65), .X(n67));
  SEH_AOI22_3 U89 (.A1(n63), .A2(n47), .B1(n67), .B2(booth_single[0]), .X(n121));
  SEH_ND2_S_2P5 U30 (.A1(booth_single[4]), .A2(n67), .X(n116));
  SEH_EN2_G_3 U61 (.A1(n76), .A2(n123), .X(pp_out[6]));
  SEH_AOI22_3 U104 (.A1(n54), .A2(n125), .B1(n50), .B2(n80), .X(n110));
  SEH_AOI22_3 U123 (.A1(n50), .A2(n69), .B1(booth_single[3]), .B2(n72), .X(n108));
  SEH_EN2_G_3 U55 (.A1(n78), .A2(n98), .X(pp_out[24]));
  SEH_BUF_3 U35 (.A(booth_negtive[2]), .X(n78));
  SEH_BUF_3 U8 (.A(booth_single[2]), .X(n53));
  SEH_EN2_G_3 U84 (.A1(n76), .A2(n115), .X(pp_out[3]));
  SEH_EN2_G_3 U38 (.A1(n78), .A2(n91), .X(pp_out[18]));
  SEH_BUF_3 U7 (.A(booth_single[1]), .X(n52));
  SEH_AOI22_3 U93 (.A1(n48), .A2(multiplicand[0]), .B1(n58), .B2(n52), .X(n83));
  SEH_AOI22_3 U73 (.A1(n48), .A2(n58), .B1(n60), .B2(n52), .X(n84));
  SEH_INV_S_3 U12 (.A(n56), .X(n57));
  SEH_AOI22_3 U85 (.A1(n61), .A2(n47), .B1(n63), .B2(n51), .X(n115));
  SEH_EN2_G_3 U44 (.A1(n76), .A2(n82), .X(pp_out[0]));
  SEH_BUF_3 U4 (.A(booth_double[2]), .X(n49));
  SEH_INV_S_3 U18 (.A(n62), .X(n63));
  SEH_AOI22_3 U99 (.A1(n125), .A2(booth_single[1]), .B1(n48), 
     .B2(multiplicand[7]), .X(n90));
  SEH_AOI22_3 U75 (.A1(n48), .A2(n63), .B1(n67), .B2(booth_single[1]), .X(n86));
  SEH_EN2_G_3 U80 (.A1(n79), .A2(n105), .X(pp_out[30]));
  SEH_EN2_G_3 U98 (.A1(n77), .A2(n90), .X(pp_out[17]));
  SEH_BUF_3 U5 (.A(booth_double[3]), .X(n50));
  SEH_EN2_G_3 U108 (.A1(booth_negtive[4]), .A2(n112), .X(pp_out[37]));
  SEH_EN2_G_3 U59 (.A1(n79), .A2(n107), .X(pp_out[32]));
  SEH_AOI22_3 U125 (.A1(n49), .A2(n70), .B1(booth_single[2]), .B2(n72), .X(n98));
  SEH_EN2_G_3 U82 (.A1(n79), .A2(n106), .X(pp_out[31]));
  SEH_AOI22_3 U101 (.A1(booth_single[2]), .A2(n125), .B1(n49), .B2(n80), 
     .X(n100));
  SEH_AOI22_3 U52 (.A1(n49), .A2(n61), .B1(booth_single[2]), .B2(n63), .X(n95));
  SEH_EN2_G_3 U78 (.A1(n79), .A2(n102), .X(pp_out[28]));
  SEH_BUF_3 U9 (.A(booth_single[3]), .X(n54));
  SEH_EN2_G_3 U51 (.A1(n78), .A2(n95), .X(pp_out[21]));
  SEH_AOI22_3 U83 (.A1(n50), .A2(n63), .B1(booth_single[3]), .B2(n66), .X(n106));
  SEH_EN2_G_3 U63 (.A1(n76), .A2(n124), .X(pp_out[7]));
  SEH_INV_S_3 U24 (.A(n68), .X(n69));
  SEH_EN2_G_3 U65 (.A1(n79), .A2(n103), .X(pp_out[29]));
  SEH_INV_S_3 U23 (.A(multiplicand[5]), .X(n68));
  SEH_AOI22_3 U64 (.A1(n72), .A2(n47), .B1(booth_single[0]), .B2(n80), .X(n124));
  SEH_ND2_S_2P5 U109 (.A1(n57), .A2(booth_single[4]), .X(n112));
  SEH_EN2_G_3 U110 (.A1(booth_negtive[4]), .A2(n113), .X(pp_out[38]));
  SEH_EN2_G_3 U120 (.A1(booth_negtive[4]), .A2(n111), .X(pp_out[36]));
  SEH_BUF_3 U2 (.A(booth_double[0]), .X(n47));
  SEH_INV_S_3 U37 (.A(n81), .X(n80));
  SEH_INV_S_3 U26 (.A(multiplicand[6]), .X(n71));
  SEH_INV_S_3 U31 (.A(multiplicand[7]), .X(n81));
  SEH_AOI22_3 U97 (.A1(booth_single[0]), .A2(n125), .B1(n47), .B2(n80), .X(n126));
  SEH_EN2_G_3 U67 (.A1(n77), .A2(n88), .X(pp_out[15]));
  SEH_AOI22_3 U91 (.A1(n50), .A2(n73), .B1(n54), .B2(n80), .X(n109));
  SEH_EN2_G_3 U74 (.A1(n77), .A2(n86), .X(pp_out[13]));
  SEH_AOI22_3 U29 (.A1(n66), .A2(n47), .B1(n70), .B2(booth_single[0]), .X(n122));
  SEH_EN2_G_3 U58 (.A1(n79), .A2(n108), .X(pp_out[33]));
  SEH_EN2_G_3 U103 (.A1(booth_negtive[3]), .A2(n110), .X(pp_out[35]));
  SEH_EN2_G_3 U49 (.A1(n78), .A2(n94), .X(pp_out[20]));
  SEH_BUF_3 U6 (.A(booth_single[0]), .X(n51));
  SEH_INV_S_3 U15 (.A(n59), .X(n60));
  SEH_AOI22_3 U77 (.A1(n48), .A2(n60), .B1(n64), .B2(booth_single[1]), .X(n85));
  SEH_INV_S_3 U16 (.A(n59), .X(n61));
  SEH_AOI22_3 U87 (.A1(n57), .A2(n47), .B1(n61), .B2(booth_single[0]), .X(n104));
  SEH_EN2_G_3 U86 (.A1(n76), .A2(n104), .X(pp_out[2]));
  SEH_EN2_G_3 U72 (.A1(n77), .A2(n84), .X(pp_out[11]));
  SEH_AOI22_3 U48 (.A1(n49), .A2(multiplicand[0]), .B1(n53), .B2(n57), .X(n92));
  SEH_AOI22_3 U79 (.A1(n50), .A2(n55), .B1(n54), .B2(n58), .X(n102));
  SEH_AOI22_3 U50 (.A1(n49), .A2(n57), .B1(booth_single[2]), .B2(n61), .X(n94));
  SEH_INV_S_3 U13 (.A(n56), .X(n58));
  SEH_EN2_G_3 U47 (.A1(n78), .A2(n92), .X(pp_out[19]));
  SEH_EN2_G_3 U88 (.A1(n76), .A2(n121), .X(pp_out[4]));
  SEH_EN2_G_3 U42 (.A1(booth_negtive[1]), .A2(n127), .X(pp_out[9]));
  SEH_ND2_S_2P5 U43 (.A1(multiplicand[0]), .A2(n52), .X(n127));
  SEH_EN2_G_3 U76 (.A1(n77), .A2(n85), .X(pp_out[12]));
  SEH_INV_S_3 U14 (.A(multiplicand[2]), .X(n59));
  SEH_BUF_3 U34 (.A(booth_negtive[1]), .X(n77));
  SEH_AOI22_3 U95 (.A1(n47), .A2(n55), .B1(n57), .B2(n51), .X(n93));
  SEH_ND2_S_2P5 U45 (.A1(n51), .A2(n55), .X(n82));
  SEH_AOI22_3 U127 (.A1(n48), .A2(n69), .B1(n73), .B2(booth_single[1]), .X(n88));
  SEH_ND2_S_2P5 U102 (.A1(booth_single[4]), .A2(multiplicand[0]), .X(n111));
  SEH_AOI22_3 U57 (.A1(n49), .A2(n73), .B1(n53), .B2(n80), .X(n99));
  SEH_AOI22_3 U81 (.A1(n50), .A2(n61), .B1(booth_single[3]), .B2(n64), .X(n105));
  SEH_AOI22_3 U69 (.A1(n48), .A2(n66), .B1(n69), .B2(booth_single[1]), .X(n87));
  SEH_INV_S_3 U20 (.A(multiplicand[4]), .X(n65));
  SEH_INV_S_3 U27 (.A(n71), .X(n72));
  SEH_EN2_G_3 U68 (.A1(n77), .A2(n87), .X(pp_out[14]));
  SEH_ND2_S_2P5 U39 (.A1(n53), .A2(multiplicand[0]), .X(n91));
  SEH_EN2_G_3 U112 (.A1(booth_negtive[4]), .A2(n114), .X(pp_out[39]));
  SEH_AOI22_3 U62 (.A1(n70), .A2(n47), .B1(n72), .B2(booth_single[0]), .X(n123));
  SEH_AOI22_3 U124 (.A1(n50), .A2(n67), .B1(booth_single[3]), .B2(n70), .X(n107));
  SEH_EN2_G_3 U100 (.A1(booth_negtive[2]), .A2(n100), .X(pp_out[26]));
  SEH_ND2_S_2P5 U113 (.A1(booth_single[4]), .A2(n64), .X(n114));
  SEH_INV_S_3 U21 (.A(n65), .X(n66));
  SEH_AOI22_3 U126 (.A1(n49), .A2(n67), .B1(booth_single[2]), .B2(n69), .X(n97));
  SEH_ND2_S_2P5 U111 (.A1(n60), .A2(booth_single[4]), .X(n113));
  SEH_EN2_G_3 U46 (.A1(n78), .A2(n97), .X(pp_out[23]));
  SEH_INV_S_3 U25 (.A(n68), .X(n70));
  SEH_AOI22_3 U66 (.A1(n50), .A2(n58), .B1(booth_single[3]), .B2(n60), .X(n103));
  SEH_INV_S_3 U19 (.A(n62), .X(n64));
  SEH_AOI22_3 U54 (.A1(n49), .A2(n64), .B1(booth_single[2]), .B2(n66), .X(n96));
  SEH_EN2_G_3 U53 (.A1(n78), .A2(n96), .X(pp_out[22]));
  SEH_INV_S_3 U17 (.A(multiplicand[3]), .X(n62));
endmodule

// Entity:fa_1 Model:fa_1 Library:magma_checknetlist_lib
module fa_1 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_10 Model:fa_10 Library:magma_checknetlist_lib
module fa_10 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_11 Model:fa_11 Library:magma_checknetlist_lib
module fa_11 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_12 Model:fa_12 Library:magma_checknetlist_lib
module fa_12 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_13 Model:fa_13 Library:magma_checknetlist_lib
module fa_13 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_14 Model:fa_14 Library:magma_checknetlist_lib
module fa_14 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_15 Model:fa_15 Library:magma_checknetlist_lib
module fa_15 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_16 Model:fa_16 Library:magma_checknetlist_lib
module fa_16 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_17 Model:fa_17 Library:magma_checknetlist_lib
module fa_17 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_18 Model:fa_18 Library:magma_checknetlist_lib
module fa_18 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_19 Model:fa_19 Library:magma_checknetlist_lib
module fa_19 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_2 Model:fa_2 Library:magma_checknetlist_lib
module fa_2 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_20 Model:fa_20 Library:magma_checknetlist_lib
module fa_20 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_21 Model:fa_21 Library:magma_checknetlist_lib
module fa_21 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_22 Model:fa_22 Library:magma_checknetlist_lib
module fa_22 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_23 Model:fa_23 Library:magma_checknetlist_lib
module fa_23 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_24 Model:fa_24 Library:magma_checknetlist_lib
module fa_24 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_25 Model:fa_25 Library:magma_checknetlist_lib
module fa_25 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_26 Model:fa_26 Library:magma_checknetlist_lib
module fa_26 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_27 Model:fa_27 Library:magma_checknetlist_lib
module fa_27 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_28 Model:fa_28 Library:magma_checknetlist_lib
module fa_28 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_3 Model:fa_3 Library:magma_checknetlist_lib
module fa_3 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_4 Model:fa_4 Library:magma_checknetlist_lib
module fa_4 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_5 Model:fa_5 Library:magma_checknetlist_lib
module fa_5 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_6 Model:fa_6 Library:magma_checknetlist_lib
module fa_6 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_7 Model:fa_7 Library:magma_checknetlist_lib
module fa_7 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_8 Model:fa_8 Library:magma_checknetlist_lib
module fa_8 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_9 Model:fa_9 Library:magma_checknetlist_lib
module fa_9 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_1 Model:ha_1 Library:magma_checknetlist_lib
module ha_1 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_10 Model:ha_10 Library:magma_checknetlist_lib
module ha_10 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_11 Model:ha_11 Library:magma_checknetlist_lib
module ha_11 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_2 Model:ha_2 Library:magma_checknetlist_lib
module ha_2 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_3 Model:ha_3 Library:magma_checknetlist_lib
module ha_3 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_4 Model:ha_4 Library:magma_checknetlist_lib
module ha_4 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_5 Model:ha_5 Library:magma_checknetlist_lib
module ha_5 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_6 Model:ha_6 Library:magma_checknetlist_lib
module ha_6 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_7 Model:ha_7 Library:magma_checknetlist_lib
module ha_7 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_8 Model:ha_8 Library:magma_checknetlist_lib
module ha_8 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_9 Model:ha_9 Library:magma_checknetlist_lib
module ha_9 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:MPY8x8_2 Model:MPY8x8_2 Library:magma_checknetlist_lib
module MPY8x8_2 (csa_a, csa_b, multiplicand, multiplier, signed_MPD, signed_MPR);
  input signed_MPD, signed_MPR;
  input [7:0] multiplicand;
  input [7:0] multiplier;
  output [15:0] csa_a;
  output [15:0] csa_b;
  wire [8:2] PP0;
  wire [8:0] PP1;
  wire [8:0] PP2;
  wire [8:0] PP3;
  wire [7:0] PP4;
  wire [4:0] booth_single;
  wire [3:0] booth_double;
  wire [4:1] booth_negtive;
  wire n_Logic1_, FA1_R00C14_C, FA1_R00C14_S, FA1_R00C13_C, FA1_R00C13_S, 
     FA1_R00C12_C, FA1_R00C12_S, FA1_R00C11_C, FA1_R00C11_S, HA1_R03C11_C, 
     HA1_R03C11_S, FA1_R00C10_C, FA1_R00C10_S, HA1_R03C10_C, HA1_R03C10_S, 
     FA1_R00C09_C, FA1_R00C09_S, HA1_R03C09_C, HA1_R03C09_S, FA1_R00C08_C, 
     FA1_R00C08_S, FA1_R03C08_C, FA1_R03C08_S, FA1_R00C07_C, FA1_R00C07_S, 
     FA1_R00C06_C, FA1_R00C06_S, HA1_R03C06_C, HA1_R03C06_S, FA1_R00C05_C, 
     FA1_R00C05_S, FA1_R00C04_C, FA1_R00C04_S, FA1_R00C02_C, FA2_R00C15_S, 
     HA2_R00C14_C, HA2_R00C14_S, HA2_R00C13_C, HA2_R00C13_S, FA2_R00C12_C, 
     FA2_R00C12_S, FA2_R00C11_C, FA2_R00C11_S, FA2_R00C10_C, FA2_R00C10_S, 
     FA2_R00C09_C, FA2_R00C09_S, FA2_R00C08_C, FA2_R00C08_S, FA2_R00C07_C, 
     FA2_R00C07_S, FA2_R00C06_C, FA2_R00C03_C, n1, n8, n9, n10, n16, n17, n30, 
     n31, SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2;
  fa_111 FA2_R00C10 (.Cout(FA2_R00C10_C), .Sum(FA2_R00C10_S), .A(FA1_R00C10_S), 
     .B(FA1_R00C09_C), .C(HA1_R03C10_S));
  ha_38 HA3_R00C15 (.Cout(), .Sum(csa_a[15]), .A(FA2_R00C15_S), .B(HA2_R00C14_C));
  ha_40 HA3_R00C13 (.Cout(csa_b[14]), .Sum(csa_a[13]), .A(HA2_R00C13_S), 
     .B(FA2_R00C12_C));
  fa_101 FA3_R00C11 (.Cout(csa_b[12]), .Sum(csa_a[11]), .A(FA2_R00C11_S), 
     .B(FA2_R00C10_C), .C(HA1_R03C10_C));
  fa_87 FA1_R00C12 (.Cout(FA1_R00C12_C), .Sum(FA1_R00C12_S), .A(n_Logic1_), 
     .B(PP2[8]), .C(PP3[6]));
  fa_85 FA1_R00C14 (.Cout(FA1_R00C14_C), .Sum(FA1_R00C14_S), .A(n_Logic1_), 
     .B(PP3[8]), .C(PP4[6]));
  fa_95 FA3_R00C04 (.Cout(csa_b[5]), .Sum(csa_a[4]), .A(FA1_R00C04_S), 
     .B(booth_negtive[2]), .C(FA2_R00C03_C));
  ha_34 HA1_R03C11 (.Cout(HA1_R03C11_C), .Sum(HA1_R03C11_S), .A(PP3[5]), 
     .B(PP4[3]));
  ha_35 HA1_R03C10 (.Cout(HA1_R03C10_C), .Sum(HA1_R03C10_S), .A(PP3[4]), 
     .B(PP4[2]));
  ha_36 HA1_R03C09 (.Cout(HA1_R03C09_C), .Sum(HA1_R03C09_S), .A(PP3[3]), 
     .B(PP4[1]));
  fa_104 FA1_R00C06 (.Cout(FA1_R00C06_C), .Sum(FA1_R00C06_S), .A(PP0[6]), 
     .B(PP1[4]), .C(PP2[2]));
  fa_105 FA1_R00C05 (.Cout(FA1_R00C05_C), .Sum(FA1_R00C05_S), .A(PP0[5]), 
     .B(PP1[3]), .C(PP2[1]));
  SEH_INV_S_3 U4 (.A(booth_negtive[3]), .X(n10));
  SEH_TIE1_G_1 U3 (.X(n_Logic1_));
  ha HA2_R00C13 (.Cout(HA2_R00C13_C), .Sum(HA2_R00C13_S), .A(FA1_R00C13_S), 
     .B(FA1_R00C12_C));
  ha_43 HA2_R00C14 (.Cout(HA2_R00C14_C), .Sum(HA2_R00C14_S), .A(FA1_R00C14_S), 
     .B(FA1_R00C13_C));
  fa_109 FA2_R00C12 (.Cout(FA2_R00C12_C), .Sum(FA2_R00C12_S), .A(FA1_R00C12_S), 
     .B(FA1_R00C11_C), .C(HA1_R03C11_C));
  fa_97 FA2_R00C07 (.Cout(FA2_R00C07_C), .Sum(FA2_R00C07_S), .A(FA1_R00C07_S), 
     .B(FA1_R00C06_C), .C(HA1_R03C06_C));
  ha_41 HA3_R00C08 (.Cout(csa_b[9]), .Sum(csa_a[8]), .A(FA2_R00C08_S), 
     .B(FA2_R00C07_C));
  SEH_INV_S_3 U23 (.A(multiplicand[7]), .X(n31));
  SEH_INV_S_3 U14 (.A(n31), .X(n30));
  SEH_BUF_3 U9 (.A(booth_negtive[4]), .X(n16));
  SEH_TIE0_G_1 U7 (.X(n17));
  SEH_INV_S_3 U24 (.A(csa_b[0]), .X(n1));
  SEH_INV_S_3 U5 (.A(booth_negtive[1]), .X(n8));
  SEH_INV_S_3 U6 (.A(booth_negtive[2]), .X(n9));
  ha_39 HA3_R00C14 (.Cout(csa_b[15]), .Sum(csa_a[14]), .A(HA2_R00C14_S), 
     .B(HA2_R00C13_C));
  ha_37 HA3_R00C05 (.Cout(csa_b[6]), .Sum(csa_a[5]), .A(FA1_R00C05_S), 
     .B(FA1_R00C04_C));
  fa_94 FA3_R00C07 (.Cout(csa_b[8]), .Sum(csa_a[7]), .A(FA2_R00C07_S), 
     .B(FA2_R00C06_C), .C(PP3[1]));
  fa_86 FA1_R00C13 (.Cout(FA1_R00C13_C), .Sum(FA1_R00C13_S), .A(n9), .B(PP3[7]), 
     .C(PP4[5]));
  fa_99 FA2_R00C03 (.Cout(FA2_R00C03_C), .Sum(csa_a[3]), .A(PP0[3]), .B(PP1[1]), 
     .C(FA1_R00C02_C));
  fa_103 FA3_R00C09 (.Cout(csa_b[10]), .Sum(csa_a[9]), .A(FA2_R00C09_S), 
     .B(FA2_R00C08_C), .C(FA1_R03C08_C));
  fa_90 FA1_R00C09 (.Cout(FA1_R00C09_C), .Sum(FA1_R00C09_S), .A(csa_b[0]), 
     .B(PP1[7]), .C(PP2[5]));
  fa_91 FA1_R00C08 (.Cout(FA1_R00C08_C), .Sum(FA1_R00C08_S), .A(PP0[8]), 
     .B(PP1[6]), .C(PP2[4]));
  fa_100 FA3_R00C12 (.Cout(csa_b[13]), .Sum(csa_a[12]), .A(FA2_R00C12_S), 
     .B(FA2_R00C11_C), .C(PP4[4]));
  fa_88 FA1_R00C11 (.Cout(FA1_R00C11_C), .Sum(FA1_R00C11_S), .A(n1), .B(n8), 
     .C(PP2[7]));
  fa_106 FA1_R00C04 (.Cout(FA1_R00C04_C), .Sum(FA1_R00C04_S), .A(PP0[4]), 
     .B(PP1[2]), .C(PP2[0]));
  fa_108 FA2_R00C15 (.Cout(), .Sum(FA2_R00C15_S), .A(n10), .B(PP4[7]), 
     .C(FA1_R00C14_C));
  fa_89 FA1_R00C10 (.Cout(FA1_R00C10_C), .Sum(FA1_R00C10_S), .A(csa_b[0]), 
     .B(PP1[8]), .C(PP2[6]));
  fa_110 FA2_R00C11 (.Cout(FA2_R00C11_C), .Sum(FA2_R00C11_S), .A(FA1_R00C11_S), 
     .B(FA1_R00C10_C), .C(HA1_R03C11_S));
  fa FA2_R00C09 (.Cout(FA2_R00C09_C), .Sum(FA2_R00C09_S), .A(FA1_R00C09_S), 
     .B(FA1_R00C08_C), .C(HA1_R03C09_S));
  fa_93 FA1_R00C07 (.Cout(FA1_R00C07_C), .Sum(FA1_R00C07_S), .A(PP0[7]), 
     .B(PP1[5]), .C(PP2[3]));
  ha_42 HA1_R03C06 (.Cout(HA1_R03C06_C), .Sum(HA1_R03C06_S), .A(PP3[0]), 
     .B(booth_negtive[3]));
  booth_selector_2 booth_selector (.pp_out({SYNOPSYS_UNCONNECTED_2, PP4[7], 
     PP4[6], PP4[5], PP4[4], PP4[3], PP4[2], PP4[1], PP4[0], PP3[8], PP3[7], 
     PP3[6], PP3[5], PP3[4], PP3[3], PP3[2], PP3[1], PP3[0], PP2[8], PP2[7], 
     PP2[6], PP2[5], PP2[4], PP2[3], PP2[2], PP2[1], PP2[0], PP1[8], PP1[7], 
     PP1[6], PP1[5], PP1[4], PP1[3], PP1[2], PP1[1], PP1[0], PP0[8], PP0[7], 
     PP0[6], PP0[5], PP0[4], PP0[3], PP0[2], csa_a[1], csa_a[0]}), 
     .booth_single(booth_single), .booth_double({n17, booth_double[3], 
     booth_double[2], booth_double[1], booth_double[0]}), .booth_negtive({n16, 
     booth_negtive[3], booth_negtive[2], booth_negtive[1], csa_b[0]}), 
     .multiplicand({n30, multiplicand[6], multiplicand[5], multiplicand[4], 
     multiplicand[3], multiplicand[2], multiplicand[1], multiplicand[0]}), 
     .signed_mpy(n17));
  fa_98 FA2_R00C06 (.Cout(FA2_R00C06_C), .Sum(csa_a[6]), .A(FA1_R00C06_S), 
     .B(FA1_R00C05_C), .C(HA1_R03C06_S));
  fa_107 FA1_R00C02 (.Cout(FA1_R00C02_C), .Sum(csa_a[2]), .A(PP0[2]), .B(PP1[0]), 
     .C(booth_negtive[1]));
  fa_96 FA2_R00C08 (.Cout(FA2_R00C08_C), .Sum(FA2_R00C08_S), .A(FA1_R00C08_S), 
     .B(FA1_R00C07_C), .C(FA1_R03C08_S));
  booth_encoder_2 booth_encoder (.booth_single(booth_single), .booth_double({
     SYNOPSYS_UNCONNECTED_1, booth_double[3], booth_double[2], booth_double[1], 
     booth_double[0]}), .multiplier({multiplier[7], multiplier[6], multiplier[5], 
     multiplier[4], multiplier[3], multiplier[2], multiplier[1], multiplier[0]}), 
     .signed_mpy(signed_MPR), .booth_negtive_4_(booth_negtive[4]), 
     .booth_negtive_0_(csa_b[0]), .booth_negtive_1_(booth_negtive[1]), 
     .booth_negtive_2_(booth_negtive[2]), .booth_negtive_3_(booth_negtive[3]));
  fa_92 FA1_R03C08 (.Cout(FA1_R03C08_C), .Sum(FA1_R03C08_S), .A(PP3[2]), 
     .B(PP4[0]), .C(booth_negtive[4]));
  fa_102 FA3_R00C10 (.Cout(csa_b[11]), .Sum(csa_a[10]), .A(FA2_R00C10_S), 
     .B(FA2_R00C09_C), .C(HA1_R03C09_C));
endmodule

// Entity:booth_encoder_2 Model:booth_encoder_2 Library:magma_checknetlist_lib
module booth_encoder_2 (booth_single, booth_double, multiplier, signed_mpy, 
     booth_negtive_4_, booth_negtive_0_, booth_negtive_1_, booth_negtive_2_, 
     booth_negtive_3_);
  input signed_mpy;
  output booth_negtive_4_, booth_negtive_0_, booth_negtive_1_, booth_negtive_2_, 
     booth_negtive_3_;
  input [7:0] multiplier;
  output [4:0] booth_single;
  output [4:0] booth_double;
  wire n26, n27, n6, n14, n16, n18, n20, n21, n22, n23, n24, n25;
  SEH_OAI32_4 U4 (.A1(n16), .A2(booth_negtive_2_), .A3(n25), .B1(n18), .B2(n22), 
     .X(booth_double[2]));
  SEH_OA32_4 U7 (.A1(n14), .A2(booth_negtive_1_), .A3(n24), .B1(n16), .B2(n21), 
     .X(n27));
  SEH_EO2_G_3 U19 (.A1(booth_negtive_3_), .A2(n18), .X(n23));
  SEH_EO2_G_3 U27 (.A1(booth_negtive_2_), .A2(multiplier[6]), .X(n26));
  SEH_ND2_S_2P5 U21 (.A1(n16), .A2(n25), .X(n22));
  SEH_INV_S_3 U12 (.A(multiplier[1]), .X(n14));
  SEH_NR2_S_2P5 U18 (.A1(n26), .A2(n23), .X(booth_double[3]));
  SEH_INV_S_3 U14 (.A(multiplier[5]), .X(n18));
  SEH_INV_S_3 U20 (.A(multiplier[7]), .X(n20));
  SEH_INV_S_3 U24 (.A(multiplier[2]), .X(n24));
  SEH_INV_S_3 U15 (.A(n20), .X(booth_negtive_3_));
  SEH_ND2_S_2P5 U23 (.A1(n14), .A2(n24), .X(n21));
  SEH_BUF_3 U17 (.A(multiplier[0]), .X(booth_single[0]));
  SEH_NR2B_V1_3 U28 (.A(booth_negtive_3_), .B(signed_mpy), .X(booth_single[4]));
  SEH_INV_S_3 U10 (.A(n18), .X(booth_negtive_2_));
  SEH_INV_S_3 U2 (.A(n27), .X(booth_double[1]));
  SEH_INV_S_3 U5 (.A(n26), .X(n6));
  SEH_INV_S_3 U9 (.A(n16), .X(booth_negtive_1_));
  SEH_NR2_S_2P5 U16 (.A1(multiplier[0]), .A2(n14), .X(booth_double[0]));
  SEH_EO2_G_3 U25 (.A1(multiplier[2]), .A2(booth_negtive_0_), 
     .X(booth_single[1]));
  SEH_INV_S_3 U13 (.A(multiplier[3]), .X(n16));
  SEH_INV_S_3 U11 (.A(n14), .X(booth_negtive_0_));
  SEH_INV_S_3 U6 (.A(n6), .X(booth_single[3]));
  SEH_INV_S_3 U22 (.A(multiplier[4]), .X(n25));
  SEH_AN2_S_3 U29 (.A1(booth_negtive_3_), .A2(signed_mpy), .X(booth_negtive_4_));
  SEH_EO2_G_3 U26 (.A1(multiplier[4]), .A2(booth_negtive_1_), 
     .X(booth_single[2]));
endmodule

// Entity:booth_selector_2 Model:booth_selector_2 Library:magma_checknetlist_lib
module booth_selector_2 (pp_out, booth_single, booth_double, booth_negtive, 
     multiplicand, signed_mpy);
  input signed_mpy;
  input [4:0] booth_single;
  input [4:0] booth_double;
  input [4:0] booth_negtive;
  input [7:0] multiplicand;
  output [44:0] pp_out;
  wire n47, n49, n50, n55, n56, n57, n58, n59, n60, n61, n65, n66, n67, n68, 
     n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, 
     n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, 
     n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n110, n111, 
     n112, n113, n115, n116;
  SEH_EN2_G_3 U85 (.A1(n65), .A2(n82), .X(pp_out[1]));
  SEH_INV_S_3 U20 (.A(multiplicand[7]), .X(n70));
  SEH_EN2_G_3 U87 (.A1(booth_negtive[4]), .A2(n100), .X(pp_out[36]));
  SEH_AOI22_3 U60 (.A1(n50), .A2(multiplicand[1]), .B1(booth_single[3]), 
     .B2(multiplicand[2]), .X(n92));
  SEH_EN2_G_3 U53 (.A1(n66), .A2(n78), .X(pp_out[16]));
  SEH_INV_S_3 U26 (.A(n70), .X(n69));
  SEH_EN2_G_3 U81 (.A1(booth_negtive[1]), .A2(n116), .X(pp_out[9]));
  SEH_ND2_S_2P5 U8 (.A1(n47), .A2(n69), .X(n115));
  SEH_EN2_G_3 U88 (.A1(booth_negtive[0]), .A2(n115), .X(pp_out[8]));
  SEH_BUF_3 U5 (.A(booth_double[3]), .X(n50));
  SEH_AOI22_3 U54 (.A1(booth_double[1]), .A2(multiplicand[6]), 
     .B1(multiplicand[7]), .B2(booth_single[1]), .X(n78));
  SEH_ND2_S_2P5 U18 (.A1(booth_double[1]), .A2(multiplicand[7]), .X(n79));
  SEH_EN2_G_3 U105 (.A1(booth_negtive[4]), .A2(n103), .X(pp_out[39]));
  SEH_EN2_G_3 U99 (.A1(booth_negtive[4]), .A2(n107), .X(pp_out[42]));
  SEH_ND2_S_2P5 U3 (.A1(booth_single[4]), .A2(n60), .X(n105));
  SEH_ND2_S_2P5 U91 (.A1(booth_single[4]), .A2(n61), .X(n107));
  SEH_EN2_G_3 U69 (.A1(n68), .A2(n90), .X(pp_out[27]));
  SEH_BUF_3 U25 (.A(booth_negtive[3]), .X(n68));
  SEH_EN2_G_3 U94 (.A1(booth_negtive[3]), .A2(n99), .X(pp_out[35]));
  SEH_EN2_G_3 U97 (.A1(booth_negtive[4]), .A2(n106), .X(pp_out[41]));
  SEH_AOI22_3 U50 (.A1(n50), .A2(n60), .B1(booth_single[3]), .B2(n55), .X(n96));
  SEH_ND2_S_2P5 U93 (.A1(n50), .A2(n69), .X(n99));
  SEH_EN2_G_3 U116 (.A1(n65), .A2(n112), .X(pp_out[6]));
  SEH_EN2_G_3 U75 (.A1(n65), .A2(n111), .X(pp_out[5]));
  SEH_BUF_3 U23 (.A(booth_negtive[2]), .X(n67));
  SEH_EN2_G_3 U67 (.A1(n67), .A2(n80), .X(pp_out[18]));
  SEH_EN2_G_3 U63 (.A1(n68), .A2(n91), .X(pp_out[28]));
  SEH_BUF_3 U10 (.A(multiplicand[5]), .X(n55));
  SEH_ND2_S_2P5 U68 (.A1(booth_single[2]), .A2(n56), .X(n80));
  SEH_AOI22_3 U30 (.A1(n50), .A2(n55), .B1(booth_single[3]), .B2(n61), .X(n97));
  SEH_ND2_S_2P5 U21 (.A1(n49), .A2(n69), .X(n89));
  SEH_EN2_G_3 U107 (.A1(booth_negtive[4]), .A2(n105), .X(pp_out[40]));
  SEH_ND2_S_2P5 U9 (.A1(multiplicand[1]), .A2(booth_single[4]), .X(n101));
  SEH_ND2_S_2P5 U7 (.A1(booth_single[4]), .A2(n69), .X(n108));
  SEH_ND2_S_2P5 U89 (.A1(booth_single[4]), .A2(n55), .X(n106));
  SEH_EN2_G_3 U29 (.A1(n68), .A2(n97), .X(pp_out[33]));
  SEH_EN2_G_3 U109 (.A1(booth_negtive[4]), .A2(n108), .X(pp_out[43]));
  SEH_ND2_S_2P5 U70 (.A1(booth_single[3]), .A2(multiplicand[0]), .X(n90));
  SEH_AOI22_3 U78 (.A1(n50), .A2(n61), .B1(booth_single[3]), .B2(n69), .X(n98));
  SEH_EN2_G_3 U77 (.A1(n68), .A2(n98), .X(pp_out[34]));
  SEH_EN2_G_3 U31 (.A1(n67), .A2(n81), .X(pp_out[19]));
  SEH_EN2_G_3 U92 (.A1(booth_negtive[2]), .A2(n89), .X(pp_out[26]));
  SEH_EN2_G_3 U49 (.A1(n68), .A2(n96), .X(pp_out[32]));
  SEH_ND2_S_2P5 U19 (.A1(booth_single[4]), .A2(n59), .X(n103));
  SEH_EN2_G_3 U37 (.A1(n67), .A2(n86), .X(pp_out[23]));
  SEH_BUF_3 U13 (.A(multiplicand[2]), .X(n58));
  SEH_ND2_S_2P5 U84 (.A1(booth_single[0]), .A2(n56), .X(n71));
  SEH_BUF_3 U14 (.A(multiplicand[3]), .X(n59));
  SEH_BUF_3 U24 (.A(booth_negtive[0]), .X(n65));
  SEH_AOI22_3 U86 (.A1(n47), .A2(n56), .B1(n57), .B2(booth_single[0]), .X(n82));
  SEH_AOI22_3 U62 (.A1(multiplicand[6]), .A2(n47), .B1(booth_single[0]), 
     .B2(n69), .X(n113));
  SEH_AOI22_3 U72 (.A1(n58), .A2(n47), .B1(n59), .B2(booth_single[0]), .X(n104));
  SEH_BUF_3 U11 (.A(multiplicand[0]), .X(n56));
  SEH_AOI22_3 U66 (.A1(n57), .A2(n47), .B1(n58), .B2(booth_single[0]), .X(n93));
  SEH_AOI22_3 U46 (.A1(n50), .A2(n58), .B1(booth_single[3]), .B2(n59), .X(n94));
  SEH_ND2_S_2P5 U17 (.A1(n58), .A2(booth_single[4]), .X(n102));
  SEH_AOI22_3 U52 (.A1(booth_double[1]), .A2(multiplicand[5]), 
     .B1(multiplicand[6]), .B2(booth_single[1]), .X(n77));
  SEH_AOI22_3 U114 (.A1(n49), .A2(multiplicand[1]), .B1(booth_single[2]), 
     .B2(multiplicand[2]), .X(n83));
  SEH_BUF_3 U4 (.A(booth_double[2]), .X(n49));
  SEH_BUF_3 U22 (.A(booth_negtive[1]), .X(n66));
  SEH_EN2_G_3 U59 (.A1(n68), .A2(n92), .X(pp_out[29]));
  SEH_AOI22_3 U38 (.A1(n49), .A2(multiplicand[4]), .B1(booth_single[2]), 
     .B2(multiplicand[5]), .X(n86));
  SEH_BUF_3 U12 (.A(multiplicand[1]), .X(n57));
  SEH_EN2_G_3 U83 (.A1(n65), .A2(n71), .X(pp_out[0]));
  SEH_AOI22_3 U34 (.A1(n49), .A2(multiplicand[2]), .B1(booth_single[2]), 
     .B2(multiplicand[3]), .X(n84));
  SEH_EN2_G_3 U33 (.A1(n67), .A2(n84), .X(pp_out[21]));
  SEH_AOI22_3 U80 (.A1(booth_double[1]), .A2(n56), .B1(n57), 
     .B2(booth_single[1]), .X(n72));
  SEH_EN2_G_3 U61 (.A1(n65), .A2(n113), .X(pp_out[7]));
  SEH_EN2_G_3 U45 (.A1(n68), .A2(n94), .X(pp_out[30]));
  SEH_EN2_G_3 U55 (.A1(n66), .A2(n73), .X(pp_out[11]));
  SEH_EN2_G_3 U65 (.A1(n65), .A2(n93), .X(pp_out[2]));
  SEH_AOI22_3 U115 (.A1(booth_double[1]), .A2(multiplicand[2]), 
     .B1(multiplicand[3]), .B2(booth_single[1]), .X(n74));
  SEH_EN2_G_3 U43 (.A1(n66), .A2(n76), .X(pp_out[14]));
  SEH_EN2_G_3 U39 (.A1(n67), .A2(n87), .X(pp_out[24]));
  SEH_EN2_G_3 U90 (.A1(n66), .A2(n79), .X(pp_out[17]));
  SEH_EN2_G_3 U35 (.A1(n67), .A2(n85), .X(pp_out[22]));
  SEH_EN2_G_3 U51 (.A1(n66), .A2(n77), .X(pp_out[15]));
  SEH_AOI22_3 U44 (.A1(booth_double[1]), .A2(multiplicand[4]), 
     .B1(multiplicand[5]), .B2(booth_single[1]), .X(n76));
  SEH_EN2_G_3 U79 (.A1(n66), .A2(n72), .X(pp_out[10]));
  SEH_AOI22_3 U56 (.A1(booth_double[1]), .A2(multiplicand[1]), 
     .B1(multiplicand[2]), .B2(booth_single[1]), .X(n73));
  SEH_AOI22_3 U76 (.A1(multiplicand[4]), .A2(n47), .B1(multiplicand[5]), 
     .B2(booth_single[0]), .X(n111));
  SEH_EN2_G_3 U71 (.A1(n65), .A2(n104), .X(pp_out[3]));
  SEH_EN2_G_3 U103 (.A1(booth_negtive[4]), .A2(n102), .X(pp_out[38]));
  SEH_EN2_G_3 U47 (.A1(n68), .A2(n95), .X(pp_out[31]));
  SEH_AOI22_3 U48 (.A1(n50), .A2(n59), .B1(booth_single[3]), .B2(n60), .X(n95));
  SEH_BUF_3 U16 (.A(multiplicand[6]), .X(n61));
  SEH_AOI22_3 U28 (.A1(multiplicand[5]), .A2(n47), .B1(multiplicand[6]), 
     .B2(booth_single[0]), .X(n112));
  SEH_BUF_3 U15 (.A(multiplicand[4]), .X(n60));
  SEH_EN2_G_3 U27 (.A1(n66), .A2(n74), .X(pp_out[12]));
  SEH_AOI22_3 U40 (.A1(n49), .A2(multiplicand[5]), .B1(booth_single[2]), 
     .B2(multiplicand[6]), .X(n87));
  SEH_AOI22_3 U36 (.A1(n49), .A2(multiplicand[3]), .B1(booth_single[2]), 
     .B2(multiplicand[4]), .X(n85));
  SEH_AOI22_3 U58 (.A1(booth_double[1]), .A2(multiplicand[3]), 
     .B1(multiplicand[4]), .B2(booth_single[1]), .X(n75));
  SEH_ND2_S_2P5 U82 (.A1(multiplicand[0]), .A2(booth_single[1]), .X(n116));
  SEH_BUF_3 U2 (.A(booth_double[0]), .X(n47));
  SEH_EN2_G_3 U101 (.A1(booth_negtive[4]), .A2(n101), .X(pp_out[37]));
  SEH_ND2_S_2P5 U112 (.A1(booth_single[4]), .A2(multiplicand[0]), .X(n100));
  SEH_EN2_G_3 U113 (.A1(n67), .A2(n83), .X(pp_out[20]));
  SEH_AOI22_3 U74 (.A1(multiplicand[3]), .A2(n47), .B1(n60), 
     .B2(booth_single[0]), .X(n110));
  SEH_AOI22_3 U42 (.A1(n49), .A2(n61), .B1(booth_single[2]), .B2(n69), .X(n88));
  SEH_EN2_G_3 U57 (.A1(n66), .A2(n75), .X(pp_out[13]));
  SEH_AOI22_3 U64 (.A1(n50), .A2(n56), .B1(booth_single[3]), .B2(n57), .X(n91));
  SEH_EN2_G_3 U41 (.A1(n67), .A2(n88), .X(pp_out[25]));
  SEH_AOI22_3 U32 (.A1(n49), .A2(multiplicand[0]), .B1(booth_single[2]), 
     .B2(multiplicand[1]), .X(n81));
  SEH_EN2_G_3 U73 (.A1(n65), .A2(n110), .X(pp_out[4]));
endmodule

// Entity:fa Model:fa Library:magma_checknetlist_lib
module fa (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_100 Model:fa_100 Library:magma_checknetlist_lib
module fa_100 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_101 Model:fa_101 Library:magma_checknetlist_lib
module fa_101 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_102 Model:fa_102 Library:magma_checknetlist_lib
module fa_102 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_103 Model:fa_103 Library:magma_checknetlist_lib
module fa_103 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_104 Model:fa_104 Library:magma_checknetlist_lib
module fa_104 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_105 Model:fa_105 Library:magma_checknetlist_lib
module fa_105 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_106 Model:fa_106 Library:magma_checknetlist_lib
module fa_106 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_107 Model:fa_107 Library:magma_checknetlist_lib
module fa_107 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_108 Model:fa_108 Library:magma_checknetlist_lib
module fa_108 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_109 Model:fa_109 Library:magma_checknetlist_lib
module fa_109 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_110 Model:fa_110 Library:magma_checknetlist_lib
module fa_110 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_111 Model:fa_111 Library:magma_checknetlist_lib
module fa_111 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_85 Model:fa_85 Library:magma_checknetlist_lib
module fa_85 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_86 Model:fa_86 Library:magma_checknetlist_lib
module fa_86 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_87 Model:fa_87 Library:magma_checknetlist_lib
module fa_87 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_88 Model:fa_88 Library:magma_checknetlist_lib
module fa_88 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_89 Model:fa_89 Library:magma_checknetlist_lib
module fa_89 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_90 Model:fa_90 Library:magma_checknetlist_lib
module fa_90 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_91 Model:fa_91 Library:magma_checknetlist_lib
module fa_91 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_92 Model:fa_92 Library:magma_checknetlist_lib
module fa_92 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_93 Model:fa_93 Library:magma_checknetlist_lib
module fa_93 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_94 Model:fa_94 Library:magma_checknetlist_lib
module fa_94 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_95 Model:fa_95 Library:magma_checknetlist_lib
module fa_95 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_96 Model:fa_96 Library:magma_checknetlist_lib
module fa_96 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_97 Model:fa_97 Library:magma_checknetlist_lib
module fa_97 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_98 Model:fa_98 Library:magma_checknetlist_lib
module fa_98 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_99 Model:fa_99 Library:magma_checknetlist_lib
module fa_99 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:ha Model:ha Library:magma_checknetlist_lib
module ha (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_34 Model:ha_34 Library:magma_checknetlist_lib
module ha_34 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_35 Model:ha_35 Library:magma_checknetlist_lib
module ha_35 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_36 Model:ha_36 Library:magma_checknetlist_lib
module ha_36 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_37 Model:ha_37 Library:magma_checknetlist_lib
module ha_37 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_38 Model:ha_38 Library:magma_checknetlist_lib
module ha_38 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_39 Model:ha_39 Library:magma_checknetlist_lib
module ha_39 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_40 Model:ha_40 Library:magma_checknetlist_lib
module ha_40 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_41 Model:ha_41 Library:magma_checknetlist_lib
module ha_41 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_42 Model:ha_42 Library:magma_checknetlist_lib
module ha_42 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_43 Model:ha_43 Library:magma_checknetlist_lib
module ha_43 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:MPY8x8_3 Model:MPY8x8_3 Library:magma_checknetlist_lib
module MPY8x8_3 (csa_a, csa_b, multiplicand, multiplier, signed_MPD, signed_MPR);
  input signed_MPD, signed_MPR;
  input [7:0] multiplicand;
  input [7:0] multiplier;
  output [15:0] csa_a;
  output [15:0] csa_b;
  wire [8:2] PP0;
  wire [8:0] PP1;
  wire [8:0] PP2;
  wire [8:0] PP3;
  wire [7:0] PP4;
  wire [4:0] booth_single;
  wire [3:0] booth_double;
  wire [4:1] booth_negtive;
  wire n_Logic1_, pp_sign_0_, FA1_R00C14_C, FA1_R00C14_S, FA1_R00C13_C, 
     FA1_R00C13_S, FA1_R00C12_C, FA1_R00C12_S, FA1_R00C11_C, FA1_R00C11_S, 
     HA1_R03C11_C, HA1_R03C11_S, FA1_R00C10_C, FA1_R00C10_S, HA1_R03C10_C, 
     HA1_R03C10_S, FA1_R00C09_C, FA1_R00C09_S, HA1_R03C09_C, HA1_R03C09_S, 
     FA1_R00C08_C, FA1_R00C08_S, FA1_R03C08_C, FA1_R03C08_S, FA1_R00C07_C, 
     FA1_R00C07_S, FA1_R00C06_C, FA1_R00C06_S, HA1_R03C06_C, HA1_R03C06_S, 
     FA1_R00C05_C, FA1_R00C05_S, FA1_R00C04_C, FA1_R00C04_S, FA1_R00C02_C, 
     FA2_R00C15_S, HA2_R00C14_C, HA2_R00C14_S, HA2_R00C13_C, HA2_R00C13_S, 
     FA2_R00C12_C, FA2_R00C12_S, FA2_R00C11_C, FA2_R00C11_S, FA2_R00C10_C, 
     FA2_R00C10_S, FA2_R00C09_C, FA2_R00C09_S, FA2_R00C08_C, FA2_R00C08_S, 
     FA2_R00C07_C, FA2_R00C07_S, FA2_R00C06_C, FA2_R00C03_C, n1, n4, n5, n6, n7, 
     n8, n9, n10, n16, n17, n32, n33, n34, SYNOPSYS_UNCONNECTED_1, 
     SYNOPSYS_UNCONNECTED_2;
  fa_43 FA2_R00C03 (.Cout(FA2_R00C03_C), .Sum(csa_a[3]), .A(PP0[3]), .B(PP1[1]), 
     .C(FA1_R00C02_C));
  fa_32 FA1_R00C11 (.Cout(FA1_R00C11_C), .Sum(FA1_R00C11_S), .A(n1), .B(n8), 
     .C(PP2[7]));
  fa_37 FA1_R00C07 (.Cout(FA1_R00C07_C), .Sum(FA1_R00C07_S), .A(PP0[7]), 
     .B(PP1[5]), .C(PP2[3]));
  ha_19 HA3_R00C08 (.Cout(csa_b[9]), .Sum(csa_a[8]), .A(FA2_R00C08_S), 
     .B(FA2_R00C07_C));
  ha_22 HA2_R00C13 (.Cout(HA2_R00C13_C), .Sum(HA2_R00C13_S), .A(FA1_R00C13_S), 
     .B(FA1_R00C12_C));
  booth_selector_3 booth_selector (.pp_out({SYNOPSYS_UNCONNECTED_2, PP4[7], 
     PP4[6], PP4[5], PP4[4], PP4[3], PP4[2], PP4[1], PP4[0], PP3[8], PP3[7], 
     PP3[6], PP3[5], PP3[4], PP3[3], PP3[2], PP3[1], PP3[0], PP2[8], PP2[7], 
     PP2[6], PP2[5], PP2[4], PP2[3], PP2[2], PP2[1], PP2[0], PP1[8], PP1[7], 
     PP1[6], PP1[5], PP1[4], PP1[3], PP1[2], PP1[1], PP1[0], PP0[8], PP0[7], 
     PP0[6], PP0[5], PP0[4], PP0[3], PP0[2], csa_a[1], csa_a[0]}), 
     .booth_single(booth_single), .booth_double({n17, booth_double[3], 
     booth_double[2], booth_double[1], booth_double[0]}), .booth_negtive({n16, 
     booth_negtive[3], booth_negtive[2], booth_negtive[1], csa_b[0]}), 
     .multiplicand({multiplicand[7], multiplicand[6], multiplicand[5], 
     multiplicand[4], multiplicand[3], multiplicand[2], multiplicand[1], 
     multiplicand[0]}), .signed_mpy(signed_MPD));
  fa_44 FA3_R00C12 (.Cout(csa_b[13]), .Sum(csa_a[12]), .A(FA2_R00C12_S), 
     .B(FA2_R00C11_C), .C(PP4[4]));
  fa_50 FA1_R00C04 (.Cout(FA1_R00C04_C), .Sum(FA1_R00C04_S), .A(PP0[4]), 
     .B(PP1[2]), .C(PP2[0]));
  fa_56 FA2_R00C09 (.Cout(FA2_R00C09_C), .Sum(FA2_R00C09_S), .A(FA1_R00C09_S), 
     .B(FA1_R00C08_C), .C(HA1_R03C09_S));
  fa_34 FA1_R00C09 (.Cout(FA1_R00C09_C), .Sum(FA1_R00C09_S), .A(pp_sign_0_), 
     .B(PP1[7]), .C(PP2[5]));
  fa_54 FA2_R00C11 (.Cout(FA2_R00C11_C), .Sum(FA2_R00C11_S), .A(FA1_R00C11_S), 
     .B(FA1_R00C10_C), .C(HA1_R03C11_S));
  fa_41 FA2_R00C07 (.Cout(FA2_R00C07_C), .Sum(FA2_R00C07_S), .A(FA1_R00C07_S), 
     .B(FA1_R00C06_C), .C(HA1_R03C06_C));
  SEH_OAI21_S_3 U31 (.A1(booth_single[2]), .A2(booth_double[2]), .B(n4), .X(n6));
  SEH_EO2_G_3 U30 (.A1(n6), .A2(booth_negtive[2]), .X(n9));
  SEH_OAI21_S_3 U33 (.A1(booth_single[3]), .A2(booth_double[3]), .B(n4), .X(n7));
  SEH_AN2_S_3 U34 (.A1(signed_MPD), .A2(multiplicand[7]), .X(n4));
  SEH_EO2_G_3 U32 (.A1(n7), .A2(booth_negtive[3]), .X(n10));
  SEH_INV_S_3 U19 (.A(pp_sign_0_), .X(n1));
  SEH_BUF_3 U9 (.A(booth_negtive[4]), .X(n16));
  SEH_TIE1_G_1 U3 (.X(n_Logic1_));
  fa_48 FA1_R00C06 (.Cout(FA1_R00C06_C), .Sum(FA1_R00C06_S), .A(PP0[6]), 
     .B(PP1[4]), .C(PP2[2]));
  ha_17 HA3_R00C14 (.Cout(csa_b[15]), .Sum(csa_a[14]), .A(HA2_R00C14_S), 
     .B(HA2_R00C13_C));
  fa_52 FA2_R00C15 (.Cout(), .Sum(FA2_R00C15_S), .A(n10), .B(PP4[7]), 
     .C(FA1_R00C14_C));
  fa_47 FA3_R00C09 (.Cout(csa_b[10]), .Sum(csa_a[9]), .A(FA2_R00C09_S), 
     .B(FA2_R00C08_C), .C(FA1_R03C08_C));
  fa_40 FA2_R00C08 (.Cout(FA2_R00C08_C), .Sum(FA2_R00C08_S), .A(FA1_R00C08_S), 
     .B(FA1_R00C07_C), .C(FA1_R03C08_S));
  SEH_ND3_3 U6 (.A1(n4), .A2(n32), .A3(n33), .X(n34));
  SEH_AOAI211_3 U7 (.A1(n4), .A2(n33), .B(n32), .C(n34), .X(pp_sign_0_));
  SEH_INV_S_3 U4 (.A(csa_b[0]), .X(n32));
  SEH_OR2_2P5 U5 (.A1(booth_double[0]), .A2(booth_single[0]), .X(n33));
  SEH_TIE0_G_1 U35 (.X(n17));
  SEH_OAI21_S_3 U26 (.A1(booth_single[1]), .A2(booth_double[1]), .B(n4), .X(n5));
  SEH_EO2_G_3 U25 (.A1(n5), .A2(booth_negtive[1]), .X(n8));
  fa_33 FA1_R00C10 (.Cout(FA1_R00C10_C), .Sum(FA1_R00C10_S), .A(pp_sign_0_), 
     .B(PP1[8]), .C(PP2[6]));
  ha_12 HA1_R03C11 (.Cout(HA1_R03C11_C), .Sum(HA1_R03C11_S), .A(PP3[5]), 
     .B(PP4[3]));
  fa_29 FA1_R00C14 (.Cout(FA1_R00C14_C), .Sum(FA1_R00C14_S), .A(n_Logic1_), 
     .B(PP3[8]), .C(PP4[6]));
  ha_18 HA3_R00C13 (.Cout(csa_b[14]), .Sum(csa_a[13]), .A(HA2_R00C13_S), 
     .B(FA2_R00C12_C));
  ha_16 HA3_R00C15 (.Cout(), .Sum(csa_a[15]), .A(FA2_R00C15_S), .B(HA2_R00C14_C));
  ha_13 HA1_R03C10 (.Cout(HA1_R03C10_C), .Sum(HA1_R03C10_S), .A(PP3[4]), 
     .B(PP4[2]));
  fa_53 FA2_R00C12 (.Cout(FA2_R00C12_C), .Sum(FA2_R00C12_S), .A(FA1_R00C12_S), 
     .B(FA1_R00C11_C), .C(HA1_R03C11_C));
  fa_49 FA1_R00C05 (.Cout(FA1_R00C05_C), .Sum(FA1_R00C05_S), .A(PP0[5]), 
     .B(PP1[3]), .C(PP2[1]));
  fa_35 FA1_R00C08 (.Cout(FA1_R00C08_C), .Sum(FA1_R00C08_S), .A(PP0[8]), 
     .B(PP1[6]), .C(PP2[4]));
  booth_encoder_3 booth_encoder (.booth_single(booth_single), .booth_double({
     SYNOPSYS_UNCONNECTED_1, booth_double[3], booth_double[2], booth_double[1], 
     booth_double[0]}), .multiplier({multiplier[7], multiplier[6], multiplier[5], 
     multiplier[4], multiplier[3], multiplier[2], multiplier[1], multiplier[0]}), 
     .signed_mpy(signed_MPR), .booth_negtive_4_(booth_negtive[4]), 
     .booth_negtive_0_(csa_b[0]), .booth_negtive_1_(booth_negtive[1]), 
     .booth_negtive_2_(booth_negtive[2]), .booth_negtive_3_(booth_negtive[3]));
  fa_45 FA3_R00C11 (.Cout(csa_b[12]), .Sum(csa_a[11]), .A(FA2_R00C11_S), 
     .B(FA2_R00C10_C), .C(HA1_R03C10_C));
  fa_55 FA2_R00C10 (.Cout(FA2_R00C10_C), .Sum(FA2_R00C10_S), .A(FA1_R00C10_S), 
     .B(FA1_R00C09_C), .C(HA1_R03C10_S));
  fa_36 FA1_R03C08 (.Cout(FA1_R03C08_C), .Sum(FA1_R03C08_S), .A(PP3[2]), 
     .B(PP4[0]), .C(booth_negtive[4]));
  fa_39 FA3_R00C04 (.Cout(csa_b[5]), .Sum(csa_a[4]), .A(FA1_R00C04_S), 
     .B(booth_negtive[2]), .C(FA2_R00C03_C));
  fa_38 FA3_R00C07 (.Cout(csa_b[8]), .Sum(csa_a[7]), .A(FA2_R00C07_S), 
     .B(FA2_R00C06_C), .C(PP3[1]));
  fa_51 FA1_R00C02 (.Cout(FA1_R00C02_C), .Sum(csa_a[2]), .A(PP0[2]), .B(PP1[0]), 
     .C(booth_negtive[1]));
  ha_21 HA2_R00C14 (.Cout(HA2_R00C14_C), .Sum(HA2_R00C14_S), .A(FA1_R00C14_S), 
     .B(FA1_R00C13_C));
  fa_42 FA2_R00C06 (.Cout(FA2_R00C06_C), .Sum(csa_a[6]), .A(FA1_R00C06_S), 
     .B(FA1_R00C05_C), .C(HA1_R03C06_S));
  fa_46 FA3_R00C10 (.Cout(csa_b[11]), .Sum(csa_a[10]), .A(FA2_R00C10_S), 
     .B(FA2_R00C09_C), .C(HA1_R03C09_C));
  ha_15 HA3_R00C05 (.Cout(csa_b[6]), .Sum(csa_a[5]), .A(FA1_R00C05_S), 
     .B(FA1_R00C04_C));
  ha_14 HA1_R03C09 (.Cout(HA1_R03C09_C), .Sum(HA1_R03C09_S), .A(PP3[3]), 
     .B(PP4[1]));
  fa_31 FA1_R00C12 (.Cout(FA1_R00C12_C), .Sum(FA1_R00C12_S), .A(n_Logic1_), 
     .B(PP2[8]), .C(PP3[6]));
  ha_20 HA1_R03C06 (.Cout(HA1_R03C06_C), .Sum(HA1_R03C06_S), .A(PP3[0]), 
     .B(booth_negtive[3]));
  fa_30 FA1_R00C13 (.Cout(FA1_R00C13_C), .Sum(FA1_R00C13_S), .A(n9), .B(PP3[7]), 
     .C(PP4[5]));
endmodule

// Entity:booth_encoder_3 Model:booth_encoder_3 Library:magma_checknetlist_lib
module booth_encoder_3 (booth_single, booth_double, multiplier, signed_mpy, 
     booth_negtive_4_, booth_negtive_0_, booth_negtive_1_, booth_negtive_2_, 
     booth_negtive_3_);
  input signed_mpy;
  output booth_negtive_4_, booth_negtive_0_, booth_negtive_1_, booth_negtive_2_, 
     booth_negtive_3_;
  input [7:0] multiplier;
  output [4:0] booth_single;
  output [4:0] booth_double;
  wire n21, n2, n4, n7, n8, n9, n10, n14, n16, n18, n20;
  SEH_NR2_S_2P5 U25 (.A1(multiplier[0]), .A2(n14), .X(booth_double[0]));
  SEH_EO2_G_3 U23 (.A1(multiplier[2]), .A2(booth_negtive_0_), 
     .X(booth_single[1]));
  SEH_INV_S_3 U11 (.A(n14), .X(booth_negtive_0_));
  SEH_BUF_3 U8 (.A(multiplier[0]), .X(booth_single[0]));
  SEH_EO2_G_3 U26 (.A1(booth_negtive_2_), .A2(multiplier[6]), .X(n21));
  SEH_OAI32_4 U4 (.A1(n14), .A2(booth_negtive_1_), .A3(n4), .B1(n16), .B2(n9), 
     .X(booth_double[1]));
  SEH_OAI32_4 U5 (.A1(n16), .A2(booth_negtive_2_), .A3(n2), .B1(n18), .B2(n8), 
     .X(booth_double[2]));
  SEH_ND2_S_2P5 U21 (.A1(n14), .A2(n4), .X(n9));
  SEH_INV_S_3 U22 (.A(multiplier[2]), .X(n4));
  SEH_INV_S_3 U9 (.A(n16), .X(booth_negtive_1_));
  SEH_INV_S_3 U13 (.A(multiplier[3]), .X(n16));
  SEH_EO2_G_3 U17 (.A1(booth_negtive_3_), .A2(n18), .X(n7));
  SEH_AN2_S_3 U27 (.A1(booth_negtive_3_), .A2(signed_mpy), .X(booth_negtive_4_));
  SEH_NR2_S_2P5 U16 (.A1(n21), .A2(n7), .X(booth_double[3]));
  SEH_INV_S_3 U12 (.A(multiplier[1]), .X(n14));
  SEH_INV_S_3 U15 (.A(n20), .X(booth_negtive_3_));
  SEH_INV_S_3 U18 (.A(multiplier[7]), .X(n20));
  SEH_INV_S_3 U6 (.A(n21), .X(n10));
  SEH_INV_S_3 U14 (.A(multiplier[5]), .X(n18));
  SEH_ND2_S_2P5 U19 (.A1(n16), .A2(n2), .X(n8));
  SEH_INV_S_3 U10 (.A(n18), .X(booth_negtive_2_));
  SEH_INV_S_3 U7 (.A(n10), .X(booth_single[3]));
  SEH_EO2_G_3 U24 (.A1(multiplier[4]), .A2(booth_negtive_1_), 
     .X(booth_single[2]));
  SEH_INV_S_3 U20 (.A(multiplier[4]), .X(n2));
  SEH_NR2B_3 U28 (.A(booth_negtive_3_), .B(signed_mpy), .X(booth_single[4]));
endmodule

// Entity:booth_selector_3 Model:booth_selector_3 Library:magma_checknetlist_lib
module booth_selector_3 (pp_out, booth_single, booth_double, booth_negtive, 
     multiplicand, signed_mpy);
  input signed_mpy;
  input [4:0] booth_single;
  input [4:0] booth_double;
  input [4:0] booth_negtive;
  input [7:0] multiplicand;
  output [44:0] pp_out;
  wire n1, n2, n3, n4, n5, n6, n7, n9, n10, n11, n12, n13, n14, n15, n16, n17, 
     n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, 
     n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, 
     n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, 
     n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n78, n79, 
     n80, n81, n82, n83;
  SEH_AOI22_3 U83 (.A1(n54), .A2(n3), .B1(n50), .B2(n82), .X(n18));
  SEH_EN2_G_3 U102 (.A1(n79), .A2(n45), .X(pp_out[10]));
  SEH_EN2_G_3 U108 (.A1(n78), .A2(n46), .X(pp_out[0]));
  SEH_AOI22_3 U63 (.A1(booth_single[0]), .A2(n3), .B1(n47), .B2(n82), .X(n2));
  SEH_EN2_G_3 U70 (.A1(n79), .A2(n44), .X(pp_out[11]));
  SEH_AOI22_3 U103 (.A1(n48), .A2(n59), .B1(n63), .B2(n52), .X(n45));
  SEH_EN2_G_3 U50 (.A1(n81), .A2(n23), .X(pp_out[30]));
  SEH_EN2_G_3 U60 (.A1(n81), .A2(n25), .X(pp_out[29]));
  SEH_EN2_G_3 U52 (.A1(n81), .A2(n22), .X(pp_out[31]));
  SEH_INV_S_3 U28 (.A(multiplicand[6]), .X(n73));
  SEH_EN2_G_3 U90 (.A1(booth_negtive[4]), .A2(n17), .X(pp_out[36]));
  SEH_EN2_G_3 U115 (.A1(booth_negtive[4]), .A2(n16), .X(pp_out[37]));
  SEH_ND2_S_2P5 U116 (.A1(n62), .A2(booth_single[4]), .X(n16));
  SEH_ND2_S_2P5 U122 (.A1(booth_single[4]), .A2(n56), .X(n11));
  SEH_EN2_G_3 U94 (.A1(n81), .A2(n21), .X(pp_out[32]));
  SEH_EN2_G_3 U117 (.A1(booth_negtive[4]), .A2(n15), .X(pp_out[38]));
  SEH_EN2_G_3 U84 (.A1(n81), .A2(n26), .X(pp_out[28]));
  SEH_EN2_G_3 U92 (.A1(n81), .A2(n27), .X(pp_out[27]));
  SEH_ND2_S_2P5 U114 (.A1(booth_single[4]), .A2(n82), .X(n9));
  SEH_EN2_G_3 U48 (.A1(n80), .A2(n29), .X(pp_out[25]));
  SEH_EN2_G_3 U98 (.A1(n78), .A2(n24), .X(pp_out[2]));
  SEH_AOI22_3 U99 (.A1(n62), .A2(n47), .B1(n66), .B2(booth_single[0]), .X(n24));
  SEH_BUF_3 U2 (.A(booth_double[0]), .X(n47));
  SEH_EN2_G_3 U106 (.A1(booth_negtive[1]), .A2(n1), .X(pp_out[9]));
  SEH_INV_S_3 U20 (.A(n64), .X(n65));
  SEH_INV_S_3 U37 (.A(n83), .X(n82));
  SEH_INV_S_3 U32 (.A(multiplicand[7]), .X(n83));
  SEH_INV_S_3 U13 (.A(multiplicand[0]), .X(n58));
  SEH_ND2_S_2P5 U118 (.A1(n65), .A2(booth_single[4]), .X(n15));
  SEH_ND2_S_2P5 U124 (.A1(booth_single[4]), .A2(n74), .X(n10));
  SEH_EN2_G_3 U123 (.A1(booth_negtive[4]), .A2(n10), .X(pp_out[42]));
  SEH_ND2_S_2P5 U31 (.A1(booth_single[4]), .A2(n72), .X(n12));
  SEH_EN2_G_3 U58 (.A1(n78), .A2(n4), .X(pp_out[7]));
  SEH_AOI22_3 U55 (.A1(n71), .A2(n47), .B1(n57), .B2(booth_single[0]), .X(n6));
  SEH_EN2_G_3 U54 (.A1(n78), .A2(n6), .X(pp_out[5]));
  SEH_AOI22_3 U39 (.A1(n49), .A2(n62), .B1(booth_single[2]), .B2(n66), .X(n34));
  SEH_EN2_G_3 U38 (.A1(n80), .A2(n34), .X(pp_out[20]));
  SEH_EN2_G_3 U72 (.A1(n79), .A2(n43), .X(pp_out[12]));
  SEH_EN2_G_3 U42 (.A1(n80), .A2(n32), .X(pp_out[22]));
  SEH_AOI22_3 U73 (.A1(n48), .A2(n65), .B1(n69), .B2(booth_single[1]), .X(n43));
  SEH_INV_S_3 U16 (.A(multiplicand[1]), .X(n61));
  SEH_INV_S_3 U18 (.A(n61), .X(n63));
  SEH_BUF_3 U9 (.A(booth_single[3]), .X(n54));
  SEH_AN2_S_3 U112 (.A1(signed_mpy), .A2(multiplicand[7]), .X(n3));
  SEH_INV_S_3 U27 (.A(n70), .X(n72));
  SEH_EN2_G_3 U127 (.A1(booth_negtive[4]), .A2(n12), .X(pp_out[40]));
  SEH_EN2_G_3 U64 (.A1(n79), .A2(n41), .X(pp_out[14]));
  SEH_EN2_G_3 U76 (.A1(n79), .A2(n40), .X(pp_out[15]));
  SEH_AOI22_3 U57 (.A1(n57), .A2(n47), .B1(n74), .B2(booth_single[0]), .X(n5));
  SEH_AOI22_3 U101 (.A1(n68), .A2(n47), .B1(n72), .B2(booth_single[0]), .X(n7));
  SEH_AOI22_3 U59 (.A1(n74), .A2(n47), .B1(booth_single[0]), .B2(n82), .X(n4));
  SEH_AOI22_3 U97 (.A1(n66), .A2(n47), .B1(n68), .B2(n51), .X(n13));
  SEH_AOI22_3 U75 (.A1(n48), .A2(n68), .B1(n72), .B2(booth_single[1]), .X(n42));
  SEH_EN2_G_3 U74 (.A1(n79), .A2(n42), .X(pp_out[13]));
  SEH_EN2_G_3 U96 (.A1(n78), .A2(n13), .X(pp_out[3]));
  SEH_BUF_S_3 U8 (.A(booth_single[2]), .X(n53));
  SEH_INV_S_3 U21 (.A(n64), .X(n66));
  SEH_INV_S_3 U11 (.A(n55), .X(n56));
  SEH_AOI22_3 U85 (.A1(n50), .A2(n59), .B1(n54), .B2(n63), .X(n26));
  SEH_INV_S_3 U23 (.A(n67), .X(n68));
  SEH_EN2_G_3 U78 (.A1(booth_negtive[2]), .A2(n28), .X(pp_out[26]));
  SEH_INV_S_3 U12 (.A(n55), .X(n57));
  SEH_INV_S_3 U19 (.A(multiplicand[2]), .X(n64));
  SEH_AOI22_3 U87 (.A1(n50), .A2(n56), .B1(booth_single[3]), .B2(n74), .X(n20));
  SEH_AOI22_3 U51 (.A1(n50), .A2(n66), .B1(booth_single[3]), .B2(n69), .X(n23));
  SEH_AOI22_3 U77 (.A1(n48), .A2(n56), .B1(n75), .B2(booth_single[1]), .X(n40));
  SEH_INV_S_3 U10 (.A(multiplicand[5]), .X(n55));
  SEH_BUF_3 U36 (.A(booth_negtive[3]), .X(n81));
  SEH_INV_S_3 U17 (.A(n61), .X(n62));
  SEH_EN2_G_3 U100 (.A1(n78), .A2(n7), .X(pp_out[4]));
  SEH_EN2_G_3 U62 (.A1(booth_negtive[0]), .A2(n2), .X(pp_out[8]));
  SEH_AOI22_3 U71 (.A1(n48), .A2(n63), .B1(n65), .B2(n52), .X(n44));
  SEH_ND2_S_2P5 U109 (.A1(n51), .A2(n60), .X(n46));
  SEH_AOI22_3 U69 (.A1(n3), .A2(booth_single[1]), .B1(n48), .B2(multiplicand[7]), 
     .X(n38));
  SEH_ND2_S_2P5 U120 (.A1(booth_single[4]), .A2(n69), .X(n14));
  SEH_EN2_G_3 U86 (.A1(n81), .A2(n20), .X(pp_out[33]));
  SEH_ND2_S_2P5 U93 (.A1(booth_single[3]), .A2(n60), .X(n27));
  SEH_INV_S_3 U26 (.A(n70), .X(n71));
  SEH_EN2_G_3 U125 (.A1(booth_negtive[4]), .A2(n9), .X(pp_out[43]));
  SEH_EN2_G_3 U121 (.A1(booth_negtive[4]), .A2(n11), .X(pp_out[41]));
  SEH_ND2_S_2P5 U107 (.A1(n59), .A2(n52), .X(n1));
  SEH_BUF_3 U6 (.A(booth_single[0]), .X(n51));
  SEH_INV_S_3 U14 (.A(n58), .X(n59));
  SEH_BUF_3 U33 (.A(booth_negtive[0]), .X(n78));
  SEH_BUF_3 U7 (.A(booth_single[1]), .X(n52));
  SEH_INV_S_3 U15 (.A(n58), .X(n60));
  SEH_AOI22_3 U61 (.A1(n50), .A2(n63), .B1(booth_single[3]), .B2(n65), .X(n25));
  SEH_AOI22_3 U79 (.A1(n53), .A2(n3), .B1(n49), .B2(n82), .X(n28));
  SEH_BUF_3 U35 (.A(booth_negtive[2]), .X(n80));
  SEH_EN2_G_3 U88 (.A1(n80), .A2(n37), .X(pp_out[18]));
  SEH_EN2_G_3 U46 (.A1(n80), .A2(n30), .X(pp_out[24]));
  SEH_AOI22_3 U45 (.A1(n49), .A2(n72), .B1(booth_single[2]), .B2(n56), .X(n31));
  SEH_AOI22_3 U47 (.A1(n49), .A2(n57), .B1(booth_single[2]), .B2(n74), .X(n30));
  SEH_EN2_G_3 U40 (.A1(n80), .A2(n33), .X(pp_out[21]));
  SEH_EN2_G_3 U44 (.A1(n80), .A2(n31), .X(pp_out[23]));
  SEH_AOI22_3 U43 (.A1(n49), .A2(n69), .B1(booth_single[2]), .B2(n71), .X(n32));
  SEH_BUF_3 U34 (.A(booth_negtive[1]), .X(n79));
  SEH_BUF_3 U5 (.A(booth_double[3]), .X(n50));
  SEH_BUF_3 U3 (.A(booth_double[1]), .X(n48));
  SEH_BUF_3 U4 (.A(booth_double[2]), .X(n49));
  SEH_INV_S_3 U25 (.A(multiplicand[4]), .X(n70));
  SEH_AOI22_3 U53 (.A1(n50), .A2(n68), .B1(booth_single[3]), .B2(n71), .X(n22));
  SEH_ND2_S_2P5 U89 (.A1(n53), .A2(n60), .X(n37));
  SEH_EN2_G_3 U66 (.A1(n79), .A2(n39), .X(pp_out[16]));
  SEH_EN2_G_3 U80 (.A1(n80), .A2(n36), .X(pp_out[19]));
  SEH_EN2_G_3 U56 (.A1(n78), .A2(n5), .X(pp_out[6]));
  SEH_AOI22_3 U111 (.A1(n47), .A2(n60), .B1(n62), .B2(n51), .X(n35));
  SEH_EN2_G_3 U68 (.A1(n79), .A2(n38), .X(pp_out[17]));
  SEH_AOI22_3 U41 (.A1(n49), .A2(n66), .B1(booth_single[2]), .B2(n68), .X(n33));
  SEH_AOI22_3 U65 (.A1(n48), .A2(n71), .B1(n56), .B2(booth_single[1]), .X(n41));
  SEH_AOI22_3 U81 (.A1(n49), .A2(n60), .B1(n53), .B2(n62), .X(n36));
  SEH_EN2_G_3 U110 (.A1(n78), .A2(n35), .X(pp_out[1]));
  SEH_AOI22_3 U105 (.A1(n50), .A2(n75), .B1(n54), .B2(n82), .X(n19));
  SEH_ND2_S_2P5 U91 (.A1(booth_single[4]), .A2(n59), .X(n17));
  SEH_EN2_G_3 U82 (.A1(booth_negtive[3]), .A2(n18), .X(pp_out[35]));
  SEH_AOI22_3 U67 (.A1(n48), .A2(n75), .B1(multiplicand[7]), 
     .B2(booth_single[1]), .X(n39));
  SEH_INV_S_3 U30 (.A(n73), .X(n75));
  SEH_INV_S_3 U24 (.A(n67), .X(n69));
  SEH_INV_S_3 U22 (.A(multiplicand[3]), .X(n67));
  SEH_INV_S_3 U29 (.A(n73), .X(n74));
  SEH_EN2_G_3 U119 (.A1(booth_negtive[4]), .A2(n14), .X(pp_out[39]));
  SEH_EN2_G_3 U104 (.A1(n81), .A2(n19), .X(pp_out[34]));
  SEH_AOI22_3 U49 (.A1(n49), .A2(n75), .B1(booth_single[2]), .B2(n82), .X(n29));
  SEH_AOI22_3 U95 (.A1(n50), .A2(n72), .B1(booth_single[3]), .B2(n57), .X(n21));
endmodule

// Entity:fa_29 Model:fa_29 Library:magma_checknetlist_lib
module fa_29 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_30 Model:fa_30 Library:magma_checknetlist_lib
module fa_30 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_31 Model:fa_31 Library:magma_checknetlist_lib
module fa_31 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_32 Model:fa_32 Library:magma_checknetlist_lib
module fa_32 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_33 Model:fa_33 Library:magma_checknetlist_lib
module fa_33 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_34 Model:fa_34 Library:magma_checknetlist_lib
module fa_34 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_35 Model:fa_35 Library:magma_checknetlist_lib
module fa_35 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_36 Model:fa_36 Library:magma_checknetlist_lib
module fa_36 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_37 Model:fa_37 Library:magma_checknetlist_lib
module fa_37 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_38 Model:fa_38 Library:magma_checknetlist_lib
module fa_38 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_39 Model:fa_39 Library:magma_checknetlist_lib
module fa_39 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_40 Model:fa_40 Library:magma_checknetlist_lib
module fa_40 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_41 Model:fa_41 Library:magma_checknetlist_lib
module fa_41 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_42 Model:fa_42 Library:magma_checknetlist_lib
module fa_42 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_43 Model:fa_43 Library:magma_checknetlist_lib
module fa_43 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_44 Model:fa_44 Library:magma_checknetlist_lib
module fa_44 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_45 Model:fa_45 Library:magma_checknetlist_lib
module fa_45 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_46 Model:fa_46 Library:magma_checknetlist_lib
module fa_46 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_47 Model:fa_47 Library:magma_checknetlist_lib
module fa_47 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_48 Model:fa_48 Library:magma_checknetlist_lib
module fa_48 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_49 Model:fa_49 Library:magma_checknetlist_lib
module fa_49 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_50 Model:fa_50 Library:magma_checknetlist_lib
module fa_50 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_51 Model:fa_51 Library:magma_checknetlist_lib
module fa_51 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_52 Model:fa_52 Library:magma_checknetlist_lib
module fa_52 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_53 Model:fa_53 Library:magma_checknetlist_lib
module fa_53 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_54 Model:fa_54 Library:magma_checknetlist_lib
module fa_54 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_55 Model:fa_55 Library:magma_checknetlist_lib
module fa_55 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_56 Model:fa_56 Library:magma_checknetlist_lib
module fa_56 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  SEH_ADDF_V3_3 fa_inst (.A(A), .B(B), .CI(C), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_12 Model:ha_12 Library:magma_checknetlist_lib
module ha_12 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_13 Model:ha_13 Library:magma_checknetlist_lib
module ha_13 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_14 Model:ha_14 Library:magma_checknetlist_lib
module ha_14 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_15 Model:ha_15 Library:magma_checknetlist_lib
module ha_15 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_16 Model:ha_16 Library:magma_checknetlist_lib
module ha_16 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_17 Model:ha_17 Library:magma_checknetlist_lib
module ha_17 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_18 Model:ha_18 Library:magma_checknetlist_lib
module ha_18 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_19 Model:ha_19 Library:magma_checknetlist_lib
module ha_19 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_20 Model:ha_20 Library:magma_checknetlist_lib
module ha_20 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_21 Model:ha_21 Library:magma_checknetlist_lib
module ha_21 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:ha_22 Model:ha_22 Library:magma_checknetlist_lib
module ha_22 (Cout, Sum, A, B);
  input A, B;
  output Cout, Sum;
  SEH_ADDH_D_3 ha_inst (.A(A), .B(B), .CO(Cout), .S(Sum));
endmodule

// Entity:fa_0 Model:fa_0 Library:magma_checknetlist_lib
module fa_0 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(n3));
  SEH_EO2_G_3 U1 (.A1(C), .A2(n3), .X(Sum));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
endmodule

// Entity:fa_10_fa_10 Model:fa_10_fa_10 Library:magma_checknetlist_lib
module fa_10_fa_10 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
endmodule

// Entity:fa_11_fa_11 Model:fa_11_fa_11 Library:magma_checknetlist_lib
module fa_11_fa_11 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
endmodule

// Entity:fa_12_fa_12 Model:fa_12_fa_12 Library:magma_checknetlist_lib
module fa_12_fa_12 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
endmodule

// Entity:fa_13_fa_13 Model:fa_13_fa_13 Library:magma_checknetlist_lib
module fa_13_fa_13 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
endmodule

// Entity:fa_14_fa_14 Model:fa_14_fa_14 Library:magma_checknetlist_lib
module fa_14_fa_14 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
endmodule

// Entity:fa_15_fa_15 Model:fa_15_fa_15 Library:magma_checknetlist_lib
module fa_15_fa_15 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
endmodule

// Entity:fa_1_fa_1 Model:fa_1_fa_1 Library:magma_checknetlist_lib
module fa_1_fa_1 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
  SEH_EO2_G_3 U1 (.A1(C), .A2(n3), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(n3));
endmodule

// Entity:fa_2_fa_2 Model:fa_2_fa_2 Library:magma_checknetlist_lib
module fa_2_fa_2 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
endmodule

// Entity:fa_3_fa_3 Model:fa_3_fa_3 Library:magma_checknetlist_lib
module fa_3_fa_3 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
endmodule

// Entity:fa_4_fa_4 Model:fa_4_fa_4 Library:magma_checknetlist_lib
module fa_4_fa_4 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
endmodule

// Entity:fa_5_fa_5 Model:fa_5_fa_5 Library:magma_checknetlist_lib
module fa_5_fa_5 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
endmodule

// Entity:fa_6_fa_6 Model:fa_6_fa_6 Library:magma_checknetlist_lib
module fa_6_fa_6 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
endmodule

// Entity:fa_7_fa_7 Model:fa_7_fa_7 Library:magma_checknetlist_lib
module fa_7_fa_7 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
endmodule

// Entity:fa_8_fa_8 Model:fa_8_fa_8 Library:magma_checknetlist_lib
module fa_8_fa_8 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
endmodule

// Entity:fa_9_fa_9 Model:fa_9_fa_9 Library:magma_checknetlist_lib
module fa_9_fa_9 (Cout, Sum, A, B, C);
  input A, B, C;
  output Cout, Sum;
  wire n3;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(n3));
  SEH_AO22_DG_3 U3 (.A1(B), .A2(A), .B1(n3), .B2(C), .X(Cout));
  SEH_EO2_G_3 U2 (.A1(C), .A2(n3), .X(Sum));
endmodule

// Entity:fcla16_2 Model:fcla16_2 Library:magma_checknetlist_lib
module fcla16_2 (Sum, G, P, A, B, Cin);
  input Cin;
  output G, P;
  input [15:0] A;
  input [15:0] B;
  output [15:0] Sum;
  wire [15:1] gtemp1_b;
  wire [15:2] ptemp1;
  wire [3:1] pouta;
  wire \ctemp1[2] , \ctemp1[3] , \ctemp1[5] , \ctemp1[6] , \ctemp1[7] , 
     \ctemp1[9] , \ctemp1[10] , \ctemp1[11] , \ctemp1[13] , \ctemp1[14] , 
     \ctemp1[15] , \gouta[0] , \gouta[1] , \gouta[2] , \gouta[3] , gouta_0_1, 
     \ctemp2[2] , \ctemp2[3] , n1, n2, SYNOPSYS_UNCONNECTED_1, 
     SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, SYNOPSYS_UNCONNECTED_4, 
     SYNOPSYS_UNCONNECTED_5, SYNOPSYS_UNCONNECTED_6;
  mpfa_46 r10 (.g_b(gtemp1_b[9]), .p(ptemp1[9]), .Sum(Sum[9]), .A(A[9]), 
     .B(B[9]), .Cin(\ctemp1[9] ));
  mpfa_45 r11 (.g_b(gtemp1_b[10]), .p(ptemp1[10]), .Sum(Sum[10]), .A(A[10]), 
     .B(B[10]), .Cin(\ctemp1[10] ));
  mpfa_44 r12 (.g_b(gtemp1_b[11]), .p(ptemp1[11]), .Sum(Sum[11]), .A(A[11]), 
     .B(B[11]), .Cin(\ctemp1[11] ));
  mclg16_2 b5 (.cout({\ctemp2[3] , \ctemp2[2] , gouta_0_1, 
     SYNOPSYS_UNCONNECTED_6}), .g_o(G), .p_o(), .g({\gouta[3] , \gouta[2] , 
     \gouta[1] , \gouta[0] }), .p({pouta[3], pouta[2], pouta[1], n2}), .cin(n2));
  mclg4_10 b4 (.cout({\ctemp1[15] , \ctemp1[14] , \ctemp1[13] , 
     SYNOPSYS_UNCONNECTED_5}), .g_o(\gouta[3] ), .p_o(pouta[3]), .g_b({
     gtemp1_b[15], gtemp1_b[14], gtemp1_b[13], gtemp1_b[12]}), .p({ptemp1[15], 
     ptemp1[14], ptemp1[13], ptemp1[12]}), .cin(\ctemp2[3] ));
  mpfa_40 r16 (.g_b(gtemp1_b[15]), .p(ptemp1[15]), .Sum(Sum[15]), .A(A[15]), 
     .B(B[15]), .Cin(\ctemp1[15] ));
  mpfa_41 r15 (.g_b(gtemp1_b[14]), .p(ptemp1[14]), .Sum(Sum[14]), .A(A[14]), 
     .B(B[14]), .Cin(\ctemp1[14] ));
  mpfa_42 r14 (.g_b(gtemp1_b[13]), .p(ptemp1[13]), .Sum(Sum[13]), .A(A[13]), 
     .B(B[13]), .Cin(\ctemp1[13] ));
  mpfa_43 r13 (.g_b(gtemp1_b[12]), .p(ptemp1[12]), .Sum(Sum[12]), .A(A[12]), 
     .B(B[12]), .Cin(\ctemp2[3] ));
  mclg4_11 b3 (.cout({\ctemp1[11] , \ctemp1[10] , \ctemp1[9] , 
     SYNOPSYS_UNCONNECTED_4}), .g_o(\gouta[2] ), .p_o(pouta[2]), .g_b({
     gtemp1_b[11], gtemp1_b[10], gtemp1_b[9], gtemp1_b[8]}), .p({ptemp1[11], 
     ptemp1[10], ptemp1[9], ptemp1[8]}), .cin(\ctemp2[2] ));
  mpfa_55 r01 (.g_b(), .p(), .Sum(Sum[0]), .A(A[0]), .B(n2), .Cin(n2));
  mpfa_47 r09 (.g_b(gtemp1_b[8]), .p(ptemp1[8]), .Sum(Sum[8]), .A(A[8]), 
     .B(B[8]), .Cin(\ctemp2[2] ));
  mclg4_12 b2 (.cout({\ctemp1[7] , \ctemp1[6] , \ctemp1[5] , 
     SYNOPSYS_UNCONNECTED_3}), .g_o(\gouta[1] ), .p_o(pouta[1]), .g_b({
     gtemp1_b[7], gtemp1_b[6], gtemp1_b[5], gtemp1_b[4]}), .p({ptemp1[7], 
     ptemp1[6], ptemp1[5], ptemp1[4]}), .cin(gouta_0_1));
  mpfa_48 r08 (.g_b(gtemp1_b[7]), .p(ptemp1[7]), .Sum(Sum[7]), .A(A[7]), 
     .B(B[7]), .Cin(\ctemp1[7] ));
  mpfa_49 r07 (.g_b(gtemp1_b[6]), .p(ptemp1[6]), .Sum(Sum[6]), .A(A[6]), 
     .B(B[6]), .Cin(\ctemp1[6] ));
  mpfa_50 r06 (.g_b(gtemp1_b[5]), .p(ptemp1[5]), .Sum(Sum[5]), .A(A[5]), 
     .B(B[5]), .Cin(\ctemp1[5] ));
  mpfa_51 r05 (.g_b(gtemp1_b[4]), .p(ptemp1[4]), .Sum(Sum[4]), .A(A[4]), 
     .B(B[4]), .Cin(gouta_0_1));
  mclg4_13 b1 (.cout({\ctemp1[3] , \ctemp1[2] , SYNOPSYS_UNCONNECTED_1, 
     SYNOPSYS_UNCONNECTED_2}), .g_o(\gouta[0] ), .p_o(), .g_b({gtemp1_b[3], 
     gtemp1_b[2], gtemp1_b[1], n1}), .p({ptemp1[3], ptemp1[2], n2, n2}), .cin(n2));
  mpfa_52 r04 (.g_b(gtemp1_b[3]), .p(ptemp1[3]), .Sum(Sum[3]), .A(A[3]), 
     .B(B[3]), .Cin(\ctemp1[3] ));
  mpfa_53 r03 (.g_b(gtemp1_b[2]), .p(ptemp1[2]), .Sum(Sum[2]), .A(A[2]), 
     .B(B[2]), .Cin(\ctemp1[2] ));
  mpfa_54 r02 (.g_b(gtemp1_b[1]), .p(), .Sum(Sum[1]), .A(A[1]), .B(B[1]), 
     .Cin(n2));
  SEH_TIE1_G_1 U2 (.X(n1));
  SEH_TIE0_G_1 U1 (.X(n2));
endmodule

// Entity:mclg16_2 Model:mclg16_2 Library:magma_checknetlist_lib
module mclg16_2 (cout, g_o, p_o, g, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g;
  input [3:0] p;
  output [3:0] cout;
  wire n1, n4, n5;
  SEH_AO21_DG_3 U7 (.A1(g[0]), .A2(p[1]), .B(g[1]), .X(cout[2]));
  SEH_BUF_3 BL_ASSIGN_BUF21 (.A(g[0]), .X(cout[1]));
  SEH_AO21_DG_3 U5 (.A1(cout[2]), .A2(p[2]), .B(g[2]), .X(cout[3]));
  SEH_INV_S_3 U3 (.A(n1), .X(n5));
  SEH_AOAI211_3 U4 (.A1(g[0]), .A2(p[1]), .B(g[1]), .C(p[2]), .X(n1));
  SEH_OAOI211_3 U2 (.A1(g[2]), .A2(n5), .B(p[3]), .C(g[3]), .X(n4));
  SEH_INV_S_3 U1 (.A(n4), .X(g_o));
endmodule

// Entity:mclg4_10 Model:mclg4_10 Library:magma_checknetlist_lib
module mclg4_10 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AN4B_4 U1 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_AO21B_4 U9 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AO21B_4 U6 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AO21B_4 U5 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_INV_S_3 U7 (.A(p[3]), .X(n6));
  SEH_AOAI211_3 U8 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_INV_S_3 U4 (.A(g_b[0]), .X(n7));
  SEH_AOAI211_3 U2 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_INV_S_3 U3 (.A(g_b[1]), .X(n8));
endmodule

// Entity:mclg4_11 Model:mclg4_11 Library:magma_checknetlist_lib
module mclg4_11 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AO21B_4 U4 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AOAI211_3 U7 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_AO21B_4 U5 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AN4B_4 U1 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_AO21B_4 U9 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_INV_S_3 U8 (.A(g_b[0]), .X(n7));
  SEH_INV_S_3 U3 (.A(g_b[1]), .X(n8));
  SEH_INV_S_3 U2 (.A(p[3]), .X(n6));
  SEH_AOAI211_3 U6 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
endmodule

// Entity:mclg4_12 Model:mclg4_12 Library:magma_checknetlist_lib
module mclg4_12 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AN4B_4 U1 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_AO21B_4 U4 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AO21B_4 U8 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AO21B_4 U9 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_INV_S_3 U3 (.A(g_b[0]), .X(n7));
  SEH_INV_S_3 U2 (.A(p[3]), .X(n6));
  SEH_INV_S_3 U7 (.A(g_b[1]), .X(n8));
  SEH_AOAI211_3 U6 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_AOAI211_3 U5 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
endmodule

// Entity:mclg4_13 Model:mclg4_13 Library:magma_checknetlist_lib
module mclg4_13 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6;
  SEH_AO21B_4 U3 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_ND2_S_2P5 U5 (.A1(cout[2]), .A2(p[2]), .X(n5));
  SEH_AOAI211_3 U4 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_INV_S_3 U1 (.A(p[3]), .X(n6));
  SEH_INV_S_3 U2 (.A(g_b[1]), .X(cout[2]));
endmodule

// Entity:mpfa_40 Model:mpfa_40 Library:magma_checknetlist_lib
module mpfa_40 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_41 Model:mpfa_41 Library:magma_checknetlist_lib
module mpfa_41 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_42 Model:mpfa_42 Library:magma_checknetlist_lib
module mpfa_42 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_43 Model:mpfa_43 Library:magma_checknetlist_lib
module mpfa_43 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_44 Model:mpfa_44 Library:magma_checknetlist_lib
module mpfa_44 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_45 Model:mpfa_45 Library:magma_checknetlist_lib
module mpfa_45 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_46 Model:mpfa_46 Library:magma_checknetlist_lib
module mpfa_46 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_47 Model:mpfa_47 Library:magma_checknetlist_lib
module mpfa_47 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_48 Model:mpfa_48 Library:magma_checknetlist_lib
module mpfa_48 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_49 Model:mpfa_49 Library:magma_checknetlist_lib
module mpfa_49 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_50 Model:mpfa_50 Library:magma_checknetlist_lib
module mpfa_50 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_51 Model:mpfa_51 Library:magma_checknetlist_lib
module mpfa_51 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_52 Model:mpfa_52 Library:magma_checknetlist_lib
module mpfa_52 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_53 Model:mpfa_53 Library:magma_checknetlist_lib
module mpfa_53 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_54 Model:mpfa_54 Library:magma_checknetlist_lib
module mpfa_54 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_OA2BB2_4 U2 (.A1(A), .A2(B), .B1(B), .B2(A), .X(Sum));
  SEH_ND2_S_2P5 U1 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_55 Model:mpfa_55 Library:magma_checknetlist_lib
module mpfa_55 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_BUF_3 BL_ASSIGN_BUF20 (.A(A), .X(Sum));
endmodule

// Entity:fcla16_3 Model:fcla16_3 Library:magma_checknetlist_lib
module fcla16_3 (Sum, G, P, A, B, Cin);
  input Cin;
  output G, P;
  input [15:0] A;
  input [15:0] B;
  output [15:0] Sum;
  wire [2:1] pouta;
  wire \gtemp1_b[0] , \gtemp1_b[5] , \gtemp1_b[6] , \gtemp1_b[8] , 
     \gtemp1_b[9] , \gtemp1_b[10] , \gtemp1_b[11] , \gtemp1_b[12] , 
     \gtemp1_b[13] , \gtemp1_b[14] , \ptemp1[1] , \ptemp1[2] , \ptemp1[3] , 
     \ptemp1[4] , \ptemp1[5] , \ptemp1[6] , \ptemp1[7] , \ptemp1[8] , 
     \ptemp1[9] , \ptemp1[10] , \ptemp1[11] , \ptemp1[12] , \ptemp1[13] , 
     \ptemp1[14] , \ctemp1[1] , \ctemp1[2] , \ctemp1[3] , \ctemp1[5] , 
     \ctemp1[6] , \ctemp1[7] , \ctemp1[9] , \ctemp1[10] , \ctemp1[11] , 
     \ctemp1[13] , \ctemp1[14] , \ctemp1[15] , \gouta[0] , \gouta[1] , 
     \gouta[2] , gouta_0_1, \ctemp2[2] , \ctemp2[3] , n1, n2, 
     SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, 
     SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5;
  mpfa_66 r06 (.g_b(\gtemp1_b[5] ), .p(\ptemp1[5] ), .Sum(Sum[5]), .A(A[5]), 
     .B(B[5]), .Cin(\ctemp1[5] ));
  mpfa_56 r16 (.g_b(), .p(), .Sum(Sum[15]), .A(A[15]), .B(B[15]), 
     .Cin(\ctemp1[15] ));
  mclg4_15 b3 (.cout({\ctemp1[11] , \ctemp1[10] , \ctemp1[9] , 
     SYNOPSYS_UNCONNECTED_3}), .g_o(\gouta[2] ), .p_o(pouta[2]), .g_b({
     \gtemp1_b[11] , \gtemp1_b[10] , \gtemp1_b[9] , \gtemp1_b[8] }), .p({
     \ptemp1[11] , \ptemp1[10] , \ptemp1[9] , \ptemp1[8] }), .cin(\ctemp2[2] ));
  mpfa_69 r03 (.g_b(), .p(\ptemp1[2] ), .Sum(Sum[2]), .A(A[2]), .B(n2), 
     .Cin(\ctemp1[2] ));
  mpfa_63 r09 (.g_b(\gtemp1_b[8] ), .p(\ptemp1[8] ), .Sum(Sum[8]), .A(A[8]), 
     .B(B[8]), .Cin(\ctemp2[2] ));
  mclg16_3 b5 (.cout({\ctemp2[3] , \ctemp2[2] , gouta_0_1, 
     SYNOPSYS_UNCONNECTED_5}), .g_o(), .p_o(), .g({n2, \gouta[2] , \gouta[1] , 
     \gouta[0] }), .p({n2, pouta[2], pouta[1], n2}), .cin(n2));
  mpfa_58 r14 (.g_b(\gtemp1_b[13] ), .p(\ptemp1[13] ), .Sum(Sum[13]), .A(A[13]), 
     .B(B[13]), .Cin(\ctemp1[13] ));
  mclg4_17 b1 (.cout({\ctemp1[3] , \ctemp1[2] , \ctemp1[1] , 
     SYNOPSYS_UNCONNECTED_1}), .g_o(\gouta[0] ), .p_o(), .g_b({n1, n1, n1, 
     \gtemp1_b[0] }), .p({\ptemp1[3] , \ptemp1[2] , \ptemp1[1] , n2}), .cin(n2));
  mpfa_64 r08 (.g_b(), .p(\ptemp1[7] ), .Sum(Sum[7]), .A(A[7]), .B(n2), 
     .Cin(\ctemp1[7] ));
  mpfa_61 r11 (.g_b(\gtemp1_b[10] ), .p(\ptemp1[10] ), .Sum(Sum[10]), .A(A[10]), 
     .B(B[10]), .Cin(\ctemp1[10] ));
  mpfa_71 r01 (.g_b(\gtemp1_b[0] ), .p(), .Sum(Sum[0]), .A(A[0]), .B(B[0]), 
     .Cin(n2));
  mpfa_57 r15 (.g_b(\gtemp1_b[14] ), .p(\ptemp1[14] ), .Sum(Sum[14]), .A(A[14]), 
     .B(B[14]), .Cin(\ctemp1[14] ));
  mpfa_60 r12 (.g_b(\gtemp1_b[11] ), .p(\ptemp1[11] ), .Sum(Sum[11]), .A(A[11]), 
     .B(B[11]), .Cin(\ctemp1[11] ));
  mpfa_59 r13 (.g_b(\gtemp1_b[12] ), .p(\ptemp1[12] ), .Sum(Sum[12]), .A(A[12]), 
     .B(B[12]), .Cin(\ctemp2[3] ));
  mclg4_14 b4 (.cout({\ctemp1[15] , \ctemp1[14] , \ctemp1[13] , 
     SYNOPSYS_UNCONNECTED_4}), .g_o(), .p_o(), .g_b({n2, \gtemp1_b[14] , 
     \gtemp1_b[13] , \gtemp1_b[12] }), .p({n2, \ptemp1[14] , \ptemp1[13] , 
     \ptemp1[12] }), .cin(\ctemp2[3] ));
  mpfa_68 r04 (.g_b(), .p(\ptemp1[3] ), .Sum(Sum[3]), .A(A[3]), .B(n2), 
     .Cin(\ctemp1[3] ));
  mpfa_67 r05 (.g_b(), .p(\ptemp1[4] ), .Sum(Sum[4]), .A(A[4]), .B(n2), 
     .Cin(gouta_0_1));
  mpfa_65 r07 (.g_b(\gtemp1_b[6] ), .p(\ptemp1[6] ), .Sum(Sum[6]), .A(A[6]), 
     .B(B[6]), .Cin(\ctemp1[6] ));
  mpfa_62 r10 (.g_b(\gtemp1_b[9] ), .p(\ptemp1[9] ), .Sum(Sum[9]), .A(A[9]), 
     .B(B[9]), .Cin(\ctemp1[9] ));
  mclg4_16 b2 (.cout({\ctemp1[7] , \ctemp1[6] , \ctemp1[5] , 
     SYNOPSYS_UNCONNECTED_2}), .g_o(\gouta[1] ), .p_o(pouta[1]), .g_b({n1, 
     \gtemp1_b[6] , \gtemp1_b[5] , n1}), .p({\ptemp1[7] , \ptemp1[6] , 
     \ptemp1[5] , \ptemp1[4] }), .cin(gouta_0_1));
  mpfa_70 r02 (.g_b(), .p(\ptemp1[1] ), .Sum(Sum[1]), .A(A[1]), .B(n2), 
     .Cin(\ctemp1[1] ));
  SEH_TIE1_G_1 U2 (.X(n1));
  SEH_TIE0_G_1 U1 (.X(n2));
endmodule

// Entity:mclg16_3 Model:mclg16_3 Library:magma_checknetlist_lib
module mclg16_3 (cout, g_o, p_o, g, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g;
  input [3:0] p;
  output [3:0] cout;
  SEH_BUF_3 BL_ASSIGN_BUF24 (.A(g[0]), .X(cout[1]));
  SEH_AO21_DG_3 U1 (.A1(p[1]), .A2(g[0]), .B(g[1]), .X(cout[2]));
  SEH_AO21_DG_3 U4 (.A1(cout[2]), .A2(p[2]), .B(g[2]), .X(cout[3]));
endmodule

// Entity:mclg4_14 Model:mclg4_14 Library:magma_checknetlist_lib
module mclg4_14 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  SEH_AO21B_4 U1 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AO21B_4 U3 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_AO21B_4 U2 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
endmodule

// Entity:mclg4_15 Model:mclg4_15 Library:magma_checknetlist_lib
module mclg4_15 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AO21B_4 U2 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AN4B_4 U1 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_AOAI211_3 U8 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_INV_S_3 U5 (.A(g_b[1]), .X(n8));
  SEH_AO21B_4 U3 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_INV_S_3 U9 (.A(g_b[0]), .X(n7));
  SEH_INV_S_3 U4 (.A(p[3]), .X(n6));
  SEH_AOAI211_3 U7 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_AO21B_4 U6 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
endmodule

// Entity:mclg4_16 Model:mclg4_16 Library:magma_checknetlist_lib
module mclg4_16 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n9, n10;
  SEH_AO21B_4 U6 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_OAOI211_3 U4 (.A1(g_b[1]), .A2(n9), .B(g_b[2]), .C(n10), .X(g_o));
  SEH_INV_S_3 U2 (.A(p[3]), .X(n10));
  SEH_INV_S_3 U1 (.A(p[2]), .X(n9));
  SEH_AN2_S_3 U7 (.A1(cin), .A2(p[0]), .X(cout[1]));
  SEH_AN4_S_3 U5 (.A1(p[2]), .A2(p[0]), .A3(p[1]), .A4(p[3]), .X(p_o));
  SEH_AO21B_4 U3 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
endmodule

// Entity:mclg4_17 Model:mclg4_17 Library:magma_checknetlist_lib
module mclg4_17 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  SEH_AN4_S_3 U2 (.A1(cout[1]), .A2(p[1]), .A3(p[2]), .A4(p[3]), .X(g_o));
  SEH_INV_S_3 U1 (.A(g_b[0]), .X(cout[1]));
  SEH_AN2_S_3 U4 (.A1(cout[1]), .A2(p[1]), .X(cout[2]));
  SEH_AN2_S_3 U3 (.A1(cout[2]), .A2(p[2]), .X(cout[3]));
endmodule

// Entity:mpfa_56 Model:mpfa_56 Library:magma_checknetlist_lib
module mpfa_56 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO3_6 U1 (.A1(Cin), .A2(A), .A3(B), .X(Sum));
endmodule

// Entity:mpfa_57 Model:mpfa_57 Library:magma_checknetlist_lib
module mpfa_57 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_58 Model:mpfa_58 Library:magma_checknetlist_lib
module mpfa_58 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_59 Model:mpfa_59 Library:magma_checknetlist_lib
module mpfa_59 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_60 Model:mpfa_60 Library:magma_checknetlist_lib
module mpfa_60 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_61 Model:mpfa_61 Library:magma_checknetlist_lib
module mpfa_61 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U2 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_62 Model:mpfa_62 Library:magma_checknetlist_lib
module mpfa_62 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_63 Model:mpfa_63 Library:magma_checknetlist_lib
module mpfa_63 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_64 Model:mpfa_64 Library:magma_checknetlist_lib
module mpfa_64 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(A), .X(Sum));
  SEH_BUF_3 BL_ASSIGN_BUF19 (.A(A), .X(p));
endmodule

// Entity:mpfa_65 Model:mpfa_65 Library:magma_checknetlist_lib
module mpfa_65 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_66 Model:mpfa_66 Library:magma_checknetlist_lib
module mpfa_66 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_67 Model:mpfa_67 Library:magma_checknetlist_lib
module mpfa_67 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_BUF_3 BL_ASSIGN_BUF18 (.A(A), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
endmodule

// Entity:mpfa_68 Model:mpfa_68 Library:magma_checknetlist_lib
module mpfa_68 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
  SEH_BUF_3 BL_ASSIGN_BUF17 (.A(A), .X(p));
endmodule

// Entity:mpfa_69 Model:mpfa_69 Library:magma_checknetlist_lib
module mpfa_69 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
  SEH_BUF_3 BL_ASSIGN_BUF16 (.A(A), .X(p));
endmodule

// Entity:mpfa_70 Model:mpfa_70 Library:magma_checknetlist_lib
module mpfa_70 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
  SEH_BUF_3 BL_ASSIGN_BUF15 (.A(A), .X(p));
endmodule

// Entity:mpfa_71 Model:mpfa_71 Library:magma_checknetlist_lib
module mpfa_71 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(Sum));
  SEH_ND2_S_2P5 U1 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:fcla16_4 Model:fcla16_4 Library:magma_checknetlist_lib
module fcla16_4 (Sum, G, P, A, B, Cin);
  input Cin;
  output G, P;
  input [15:0] A;
  input [15:0] B;
  output [15:0] Sum;
  wire [2:1] pouta;
  wire \gtemp1_b[0] , \gtemp1_b[5] , \gtemp1_b[6] , \gtemp1_b[8] , 
     \gtemp1_b[9] , \gtemp1_b[10] , \gtemp1_b[11] , \gtemp1_b[12] , 
     \gtemp1_b[13] , \gtemp1_b[14] , \ptemp1[1] , \ptemp1[2] , \ptemp1[3] , 
     \ptemp1[4] , \ptemp1[5] , \ptemp1[6] , \ptemp1[7] , \ptemp1[8] , 
     \ptemp1[9] , \ptemp1[10] , \ptemp1[11] , \ptemp1[12] , \ptemp1[13] , 
     \ptemp1[14] , \ctemp1[1] , \ctemp1[2] , \ctemp1[3] , \ctemp1[5] , 
     \ctemp1[6] , \ctemp1[7] , \ctemp1[9] , \ctemp1[10] , \ctemp1[11] , 
     \ctemp1[13] , \ctemp1[14] , \ctemp1[15] , \gouta[0] , \gouta[1] , 
     \gouta[2] , gouta_0_1, \ctemp2[2] , \ctemp2[3] , n1, n2, 
     SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, 
     SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5;
  mpfa_75 r13 (.g_b(\gtemp1_b[12] ), .p(\ptemp1[12] ), .Sum(Sum[12]), .A(A[12]), 
     .B(B[12]), .Cin(\ctemp2[3] ));
  mpfa_76 r12 (.g_b(\gtemp1_b[11] ), .p(\ptemp1[11] ), .Sum(Sum[11]), .A(A[11]), 
     .B(B[11]), .Cin(\ctemp1[11] ));
  mpfa_78 r10 (.g_b(\gtemp1_b[9] ), .p(\ptemp1[9] ), .Sum(Sum[9]), .A(A[9]), 
     .B(B[9]), .Cin(\ctemp1[9] ));
  mclg4_20 b2 (.cout({\ctemp1[7] , \ctemp1[6] , \ctemp1[5] , 
     SYNOPSYS_UNCONNECTED_2}), .g_o(\gouta[1] ), .p_o(pouta[1]), .g_b({n1, 
     \gtemp1_b[6] , \gtemp1_b[5] , n1}), .p({\ptemp1[7] , \ptemp1[6] , 
     \ptemp1[5] , \ptemp1[4] }), .cin(gouta_0_1));
  mpfa_81 r07 (.g_b(\gtemp1_b[6] ), .p(\ptemp1[6] ), .Sum(Sum[6]), .A(A[6]), 
     .B(B[6]), .Cin(\ctemp1[6] ));
  mpfa_86 r02 (.g_b(), .p(\ptemp1[1] ), .Sum(Sum[1]), .A(A[1]), .B(n2), 
     .Cin(\ctemp1[1] ));
  mpfa_84 r04 (.g_b(), .p(\ptemp1[3] ), .Sum(Sum[3]), .A(A[3]), .B(n2), 
     .Cin(\ctemp1[3] ));
  mpfa_83 r05 (.g_b(), .p(\ptemp1[4] ), .Sum(Sum[4]), .A(A[4]), .B(n2), 
     .Cin(gouta_0_1));
  mclg4_18 b4 (.cout({\ctemp1[15] , \ctemp1[14] , \ctemp1[13] , 
     SYNOPSYS_UNCONNECTED_4}), .g_o(), .p_o(), .g_b({n2, \gtemp1_b[14] , 
     \gtemp1_b[13] , \gtemp1_b[12] }), .p({n2, \ptemp1[14] , \ptemp1[13] , 
     \ptemp1[12] }), .cin(\ctemp2[3] ));
  mpfa_73 r15 (.g_b(\gtemp1_b[14] ), .p(\ptemp1[14] ), .Sum(Sum[14]), .A(A[14]), 
     .B(B[14]), .Cin(\ctemp1[14] ));
  mpfa_74 r14 (.g_b(\gtemp1_b[13] ), .p(\ptemp1[13] ), .Sum(Sum[13]), .A(A[13]), 
     .B(B[13]), .Cin(\ctemp1[13] ));
  mclg4_19 b3 (.cout({\ctemp1[11] , \ctemp1[10] , \ctemp1[9] , 
     SYNOPSYS_UNCONNECTED_3}), .g_o(\gouta[2] ), .p_o(pouta[2]), .g_b({
     \gtemp1_b[11] , \gtemp1_b[10] , \gtemp1_b[9] , \gtemp1_b[8] }), .p({
     \ptemp1[11] , \ptemp1[10] , \ptemp1[9] , \ptemp1[8] }), .cin(\ctemp2[2] ));
  mpfa_87 r01 (.g_b(\gtemp1_b[0] ), .p(), .Sum(Sum[0]), .A(A[0]), .B(B[0]), 
     .Cin(n2));
  mpfa_79 r09 (.g_b(\gtemp1_b[8] ), .p(\ptemp1[8] ), .Sum(Sum[8]), .A(A[8]), 
     .B(B[8]), .Cin(\ctemp2[2] ));
  mpfa_80 r08 (.g_b(), .p(\ptemp1[7] ), .Sum(Sum[7]), .A(A[7]), .B(n2), 
     .Cin(\ctemp1[7] ));
  mpfa_85 r03 (.g_b(), .p(\ptemp1[2] ), .Sum(Sum[2]), .A(A[2]), .B(n2), 
     .Cin(\ctemp1[2] ));
  mclg4_21 b1 (.cout({\ctemp1[3] , \ctemp1[2] , \ctemp1[1] , 
     SYNOPSYS_UNCONNECTED_1}), .g_o(\gouta[0] ), .p_o(), .g_b({n1, n1, n1, 
     \gtemp1_b[0] }), .p({\ptemp1[3] , \ptemp1[2] , \ptemp1[1] , n2}), .cin(n2));
  mpfa_82 r06 (.g_b(\gtemp1_b[5] ), .p(\ptemp1[5] ), .Sum(Sum[5]), .A(A[5]), 
     .B(B[5]), .Cin(\ctemp1[5] ));
  mpfa_77 r11 (.g_b(\gtemp1_b[10] ), .p(\ptemp1[10] ), .Sum(Sum[10]), .A(A[10]), 
     .B(B[10]), .Cin(\ctemp1[10] ));
  mpfa_72 r16 (.g_b(), .p(), .Sum(Sum[15]), .A(A[15]), .B(B[15]), 
     .Cin(\ctemp1[15] ));
  mclg16_4 b5 (.cout({\ctemp2[3] , \ctemp2[2] , gouta_0_1, 
     SYNOPSYS_UNCONNECTED_5}), .g_o(), .p_o(), .g({n2, \gouta[2] , \gouta[1] , 
     \gouta[0] }), .p({n2, pouta[2], pouta[1], n2}), .cin(n2));
  SEH_TIE0_G_1 U1 (.X(n2));
  SEH_TIE1_G_1 U2 (.X(n1));
endmodule

// Entity:mclg16_4 Model:mclg16_4 Library:magma_checknetlist_lib
module mclg16_4 (cout, g_o, p_o, g, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g;
  input [3:0] p;
  output [3:0] cout;
  SEH_AO21_DG_3 U1 (.A1(p[1]), .A2(g[0]), .B(g[1]), .X(cout[2]));
  SEH_BUF_3 BL_ASSIGN_BUF23 (.A(g[0]), .X(cout[1]));
  SEH_AO21_DG_3 U4 (.A1(cout[2]), .A2(p[2]), .B(g[2]), .X(cout[3]));
endmodule

// Entity:mclg4_18 Model:mclg4_18 Library:magma_checknetlist_lib
module mclg4_18 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  SEH_AO21B_4 U3 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_AO21B_4 U2 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AO21B_4 U1 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
endmodule

// Entity:mclg4_19 Model:mclg4_19 Library:magma_checknetlist_lib
module mclg4_19 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AOAI211_3 U1 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_AN4B_4 U2 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_INV_S_3 U7 (.A(g_b[1]), .X(n8));
  SEH_AO21B_4 U4 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_AO21B_4 U3 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AOAI211_3 U8 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_AO21B_4 U5 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_INV_S_3 U6 (.A(p[3]), .X(n6));
  SEH_INV_S_3 U9 (.A(g_b[0]), .X(n7));
endmodule

// Entity:mclg4_20 Model:mclg4_20 Library:magma_checknetlist_lib
module mclg4_20 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n9, n10;
  SEH_AO21B_4 U2 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AN4_S_3 U5 (.A1(p[2]), .A2(p[0]), .A3(p[1]), .A4(p[3]), .X(p_o));
  SEH_OAOI211_3 U4 (.A1(g_b[1]), .A2(n9), .B(g_b[2]), .C(n10), .X(g_o));
  SEH_AN2_S_3 U7 (.A1(cin), .A2(p[0]), .X(cout[1]));
  SEH_AO21B_4 U6 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_INV_S_3 U3 (.A(p[3]), .X(n10));
  SEH_INV_S_3 U1 (.A(p[2]), .X(n9));
endmodule

// Entity:mclg4_21 Model:mclg4_21 Library:magma_checknetlist_lib
module mclg4_21 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  SEH_AN4_S_3 U2 (.A1(cout[1]), .A2(p[1]), .A3(p[2]), .A4(p[3]), .X(g_o));
  SEH_AN2_S_3 U4 (.A1(cout[1]), .A2(p[1]), .X(cout[2]));
  SEH_INV_S_3 U1 (.A(g_b[0]), .X(cout[1]));
  SEH_AN2_S_3 U3 (.A1(cout[2]), .A2(p[2]), .X(cout[3]));
endmodule

// Entity:mpfa_72 Model:mpfa_72 Library:magma_checknetlist_lib
module mpfa_72 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  wire n1;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(n1), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(n1));
endmodule

// Entity:mpfa_73 Model:mpfa_73 Library:magma_checknetlist_lib
module mpfa_73 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_74 Model:mpfa_74 Library:magma_checknetlist_lib
module mpfa_74 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_75 Model:mpfa_75 Library:magma_checknetlist_lib
module mpfa_75 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_76 Model:mpfa_76 Library:magma_checknetlist_lib
module mpfa_76 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_77 Model:mpfa_77 Library:magma_checknetlist_lib
module mpfa_77 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_78 Model:mpfa_78 Library:magma_checknetlist_lib
module mpfa_78 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_79 Model:mpfa_79 Library:magma_checknetlist_lib
module mpfa_79 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_80 Model:mpfa_80 Library:magma_checknetlist_lib
module mpfa_80 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_BUF_3 BL_ASSIGN_BUF14 (.A(A), .X(p));
  SEH_EO2_G_3 U2 (.A1(Cin), .A2(A), .X(Sum));
endmodule

// Entity:mpfa_81 Model:mpfa_81 Library:magma_checknetlist_lib
module mpfa_81 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_82 Model:mpfa_82 Library:magma_checknetlist_lib
module mpfa_82 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_83 Model:mpfa_83 Library:magma_checknetlist_lib
module mpfa_83 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_BUF_3 BL_ASSIGN_BUF13 (.A(A), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
endmodule

// Entity:mpfa_84 Model:mpfa_84 Library:magma_checknetlist_lib
module mpfa_84 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
  SEH_BUF_3 BL_ASSIGN_BUF12 (.A(A), .X(p));
endmodule

// Entity:mpfa_85 Model:mpfa_85 Library:magma_checknetlist_lib
module mpfa_85 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
  SEH_BUF_3 BL_ASSIGN_BUF11 (.A(A), .X(p));
endmodule

// Entity:mpfa_86 Model:mpfa_86 Library:magma_checknetlist_lib
module mpfa_86 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_BUF_3 BL_ASSIGN_BUF10 (.A(A), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
endmodule

// Entity:mpfa_87 Model:mpfa_87 Library:magma_checknetlist_lib
module mpfa_87 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U1 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(Sum));
endmodule

// Entity:fcla16_5 Model:fcla16_5 Library:magma_checknetlist_lib
module fcla16_5 (Sum, G, P, A, B, Cin);
  input Cin;
  output G, P;
  input [15:0] A;
  input [15:0] B;
  output [15:0] Sum;
  wire [2:1] pouta;
  wire \gtemp1_b[0] , \gtemp1_b[5] , \gtemp1_b[6] , \gtemp1_b[8] , 
     \gtemp1_b[9] , \gtemp1_b[10] , \gtemp1_b[11] , \gtemp1_b[12] , 
     \gtemp1_b[13] , \gtemp1_b[14] , \ptemp1[1] , \ptemp1[2] , \ptemp1[3] , 
     \ptemp1[4] , \ptemp1[5] , \ptemp1[6] , \ptemp1[7] , \ptemp1[8] , 
     \ptemp1[9] , \ptemp1[10] , \ptemp1[11] , \ptemp1[12] , \ptemp1[13] , 
     \ptemp1[14] , \ctemp1[1] , \ctemp1[2] , \ctemp1[3] , \ctemp1[5] , 
     \ctemp1[6] , \ctemp1[7] , \ctemp1[9] , \ctemp1[10] , \ctemp1[11] , 
     \ctemp1[13] , \ctemp1[14] , \ctemp1[15] , \gouta[0] , \gouta[1] , 
     \gouta[2] , gouta_0_1, \ctemp2[2] , \ctemp2[3] , n1, n2, 
     SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, 
     SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5;
  mpfa_101 r03 (.g_b(), .p(\ptemp1[2] ), .Sum(Sum[2]), .A(A[2]), .B(n2), 
     .Cin(\ctemp1[2] ));
  mpfa_103 r01 (.g_b(\gtemp1_b[0] ), .p(), .Sum(Sum[0]), .A(A[0]), .B(B[0]), 
     .Cin(n2));
  mclg16_5 b5 (.cout({\ctemp2[3] , \ctemp2[2] , gouta_0_1, 
     SYNOPSYS_UNCONNECTED_5}), .g_o(), .p_o(), .g({n2, \gouta[2] , \gouta[1] , 
     \gouta[0] }), .p({n2, pouta[2], pouta[1], n2}), .cin(n2));
  mclg4_25 b1 (.cout({\ctemp1[3] , \ctemp1[2] , \ctemp1[1] , 
     SYNOPSYS_UNCONNECTED_1}), .g_o(\gouta[0] ), .p_o(), .g_b({n1, n1, n1, 
     \gtemp1_b[0] }), .p({\ptemp1[3] , \ptemp1[2] , \ptemp1[1] , n2}), .cin(n2));
  mpfa_98 r06 (.g_b(\gtemp1_b[5] ), .p(\ptemp1[5] ), .Sum(Sum[5]), .A(A[5]), 
     .B(B[5]), .Cin(\ctemp1[5] ));
  mpfa_96 r08 (.g_b(), .p(\ptemp1[7] ), .Sum(Sum[7]), .A(A[7]), .B(n2), 
     .Cin(\ctemp1[7] ));
  mpfa_95 r09 (.g_b(\gtemp1_b[8] ), .p(\ptemp1[8] ), .Sum(Sum[8]), .A(A[8]), 
     .B(B[8]), .Cin(\ctemp2[2] ));
  mpfa_93 r11 (.g_b(\gtemp1_b[10] ), .p(\ptemp1[10] ), .Sum(Sum[10]), .A(A[10]), 
     .B(B[10]), .Cin(\ctemp1[10] ));
  mclg4_23 b3 (.cout({\ctemp1[11] , \ctemp1[10] , \ctemp1[9] , 
     SYNOPSYS_UNCONNECTED_3}), .g_o(\gouta[2] ), .p_o(pouta[2]), .g_b({
     \gtemp1_b[11] , \gtemp1_b[10] , \gtemp1_b[9] , \gtemp1_b[8] }), .p({
     \ptemp1[11] , \ptemp1[10] , \ptemp1[9] , \ptemp1[8] }), .cin(\ctemp2[2] ));
  mpfa_90 r14 (.g_b(\gtemp1_b[13] ), .p(\ptemp1[13] ), .Sum(Sum[13]), .A(A[13]), 
     .B(B[13]), .Cin(\ctemp1[13] ));
  mpfa_88 r16 (.g_b(), .p(), .Sum(Sum[15]), .A(A[15]), .B(B[15]), 
     .Cin(\ctemp1[15] ));
  mpfa_100 r04 (.g_b(), .p(\ptemp1[3] ), .Sum(Sum[3]), .A(A[3]), .B(n2), 
     .Cin(\ctemp1[3] ));
  mpfa_102 r02 (.g_b(), .p(\ptemp1[1] ), .Sum(Sum[1]), .A(A[1]), .B(n2), 
     .Cin(\ctemp1[1] ));
  mpfa_94 r10 (.g_b(\gtemp1_b[9] ), .p(\ptemp1[9] ), .Sum(Sum[9]), .A(A[9]), 
     .B(B[9]), .Cin(\ctemp1[9] ));
  mpfa_99 r05 (.g_b(), .p(\ptemp1[4] ), .Sum(Sum[4]), .A(A[4]), .B(n2), 
     .Cin(gouta_0_1));
  mpfa_97 r07 (.g_b(\gtemp1_b[6] ), .p(\ptemp1[6] ), .Sum(Sum[6]), .A(A[6]), 
     .B(B[6]), .Cin(\ctemp1[6] ));
  mclg4_24 b2 (.cout({\ctemp1[7] , \ctemp1[6] , \ctemp1[5] , 
     SYNOPSYS_UNCONNECTED_2}), .g_o(\gouta[1] ), .p_o(pouta[1]), .g_b({n1, 
     \gtemp1_b[6] , \gtemp1_b[5] , n1}), .p({\ptemp1[7] , \ptemp1[6] , 
     \ptemp1[5] , \ptemp1[4] }), .cin(gouta_0_1));
  mclg4_22 b4 (.cout({\ctemp1[15] , \ctemp1[14] , \ctemp1[13] , 
     SYNOPSYS_UNCONNECTED_4}), .g_o(), .p_o(), .g_b({n2, \gtemp1_b[14] , 
     \gtemp1_b[13] , \gtemp1_b[12] }), .p({n2, \ptemp1[14] , \ptemp1[13] , 
     \ptemp1[12] }), .cin(\ctemp2[3] ));
  mpfa_92 r12 (.g_b(\gtemp1_b[11] ), .p(\ptemp1[11] ), .Sum(Sum[11]), .A(A[11]), 
     .B(B[11]), .Cin(\ctemp1[11] ));
  mpfa_91 r13 (.g_b(\gtemp1_b[12] ), .p(\ptemp1[12] ), .Sum(Sum[12]), .A(A[12]), 
     .B(B[12]), .Cin(\ctemp2[3] ));
  mpfa_89 r15 (.g_b(\gtemp1_b[14] ), .p(\ptemp1[14] ), .Sum(Sum[14]), .A(A[14]), 
     .B(B[14]), .Cin(\ctemp1[14] ));
  SEH_TIE0_G_1 U1 (.X(n2));
  SEH_TIE1_G_1 U2 (.X(n1));
endmodule

// Entity:mclg16_5 Model:mclg16_5 Library:magma_checknetlist_lib
module mclg16_5 (cout, g_o, p_o, g, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g;
  input [3:0] p;
  output [3:0] cout;
  SEH_AO21_DG_3 U1 (.A1(p[1]), .A2(g[0]), .B(g[1]), .X(cout[2]));
  SEH_BUF_3 BL_ASSIGN_BUF25 (.A(g[0]), .X(cout[1]));
  SEH_AO21_DG_3 U4 (.A1(cout[2]), .A2(p[2]), .B(g[2]), .X(cout[3]));
endmodule

// Entity:mclg4_22 Model:mclg4_22 Library:magma_checknetlist_lib
module mclg4_22 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  SEH_AO21B_4 U2 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AO21B_4 U3 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_AO21B_4 U1 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
endmodule

// Entity:mclg4_23 Model:mclg4_23 Library:magma_checknetlist_lib
module mclg4_23 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_INV_S_3 U9 (.A(g_b[0]), .X(n7));
  SEH_INV_S_3 U4 (.A(p[3]), .X(n6));
  SEH_AO21B_4 U3 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AO21B_4 U5 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AO21B_4 U6 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_INV_S_3 U7 (.A(g_b[1]), .X(n8));
  SEH_AOAI211_3 U1 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_AN4B_4 U2 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_AOAI211_3 U8 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
endmodule

// Entity:mclg4_24 Model:mclg4_24 Library:magma_checknetlist_lib
module mclg4_24 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n9, n10;
  SEH_OAOI211_3 U3 (.A1(g_b[1]), .A2(n9), .B(g_b[2]), .C(n10), .X(g_o));
  SEH_AN4_S_3 U5 (.A1(p[2]), .A2(p[0]), .A3(p[1]), .A4(p[3]), .X(p_o));
  SEH_INV_S_3 U1 (.A(p[2]), .X(n9));
  SEH_AN2_S_3 U7 (.A1(cin), .A2(p[0]), .X(cout[1]));
  SEH_AO21B_4 U6 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AO21B_4 U4 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_INV_S_3 U2 (.A(p[3]), .X(n10));
endmodule

// Entity:mclg4_25 Model:mclg4_25 Library:magma_checknetlist_lib
module mclg4_25 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  SEH_AN4_S_3 U2 (.A1(cout[1]), .A2(p[1]), .A3(p[2]), .A4(p[3]), .X(g_o));
  SEH_INV_S_3 U1 (.A(g_b[0]), .X(cout[1]));
  SEH_AN2_S_3 U3 (.A1(cout[2]), .A2(p[2]), .X(cout[3]));
  SEH_AN2_S_3 U4 (.A1(cout[1]), .A2(p[1]), .X(cout[2]));
endmodule

// Entity:mpfa_100 Model:mpfa_100 Library:magma_checknetlist_lib
module mpfa_100 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_BUF_3 BL_ASSIGN_BUF7 (.A(A), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
endmodule

// Entity:mpfa_101 Model:mpfa_101 Library:magma_checknetlist_lib
module mpfa_101 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_BUF_3 BL_ASSIGN_BUF6 (.A(A), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
endmodule

// Entity:mpfa_102 Model:mpfa_102 Library:magma_checknetlist_lib
module mpfa_102 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_BUF_3 BL_ASSIGN_BUF5 (.A(A), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
endmodule

// Entity:mpfa_103 Model:mpfa_103 Library:magma_checknetlist_lib
module mpfa_103 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(Sum));
  SEH_ND2_S_2P5 U1 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_88 Model:mpfa_88 Library:magma_checknetlist_lib
module mpfa_88 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO3_3 U1 (.A1(Cin), .A2(A), .A3(B), .X(Sum));
endmodule

// Entity:mpfa_89 Model:mpfa_89 Library:magma_checknetlist_lib
module mpfa_89 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_90 Model:mpfa_90 Library:magma_checknetlist_lib
module mpfa_90 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_91 Model:mpfa_91 Library:magma_checknetlist_lib
module mpfa_91 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_92 Model:mpfa_92 Library:magma_checknetlist_lib
module mpfa_92 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_93 Model:mpfa_93 Library:magma_checknetlist_lib
module mpfa_93 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_94 Model:mpfa_94 Library:magma_checknetlist_lib
module mpfa_94 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_95 Model:mpfa_95 Library:magma_checknetlist_lib
module mpfa_95 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_96 Model:mpfa_96 Library:magma_checknetlist_lib
module mpfa_96 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(A), .X(Sum));
  SEH_BUF_3 BL_ASSIGN_BUF9 (.A(A), .X(p));
endmodule

// Entity:mpfa_97 Model:mpfa_97 Library:magma_checknetlist_lib
module mpfa_97 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_98 Model:mpfa_98 Library:magma_checknetlist_lib
module mpfa_98 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_99 Model:mpfa_99 Library:magma_checknetlist_lib
module mpfa_99 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
  SEH_BUF_3 BL_ASSIGN_BUF8 (.A(A), .X(p));
endmodule

// Entity:fcla16_6 Model:fcla16_6 Library:magma_checknetlist_lib
module fcla16_6 (Sum, G, P, A, B, Cin);
  input Cin;
  output G, P;
  input [15:0] A;
  input [15:0] B;
  output [15:0] Sum;
  wire [2:1] pouta;
  wire \gtemp1_b[0] , \gtemp1_b[5] , \gtemp1_b[6] , \gtemp1_b[8] , 
     \gtemp1_b[9] , \gtemp1_b[10] , \gtemp1_b[11] , \gtemp1_b[12] , 
     \gtemp1_b[13] , \gtemp1_b[14] , \ptemp1[1] , \ptemp1[2] , \ptemp1[3] , 
     \ptemp1[4] , \ptemp1[5] , \ptemp1[6] , \ptemp1[7] , \ptemp1[8] , 
     \ptemp1[9] , \ptemp1[10] , \ptemp1[11] , \ptemp1[12] , \ptemp1[13] , 
     \ptemp1[14] , \ctemp1[1] , \ctemp1[2] , \ctemp1[3] , \ctemp1[5] , 
     \ctemp1[6] , \ctemp1[7] , \ctemp1[9] , \ctemp1[10] , \ctemp1[11] , 
     \ctemp1[13] , \ctemp1[14] , \ctemp1[15] , \gouta[0] , \gouta[1] , 
     \gouta[2] , gouta_0_1, \ctemp2[2] , \ctemp2[3] , n1, n2, 
     SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, 
     SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5;
  mpfa_119 r01 (.g_b(\gtemp1_b[0] ), .p(), .Sum(Sum[0]), .A(A[0]), .B(B[0]), 
     .Cin(n2));
  mpfa_106 r14 (.g_b(\gtemp1_b[13] ), .p(\ptemp1[13] ), .Sum(Sum[13]), .A(A[13]), 
     .B(B[13]), .Cin(\ctemp1[13] ));
  mpfa_112 r08 (.g_b(), .p(\ptemp1[7] ), .Sum(Sum[7]), .A(A[7]), .B(n2), 
     .Cin(\ctemp1[7] ));
  mpfa_109 r11 (.g_b(\gtemp1_b[10] ), .p(\ptemp1[10] ), .Sum(Sum[10]), .A(A[10]), 
     .B(B[10]), .Cin(\ctemp1[10] ));
  mclg4_29 b1 (.cout({\ctemp1[3] , \ctemp1[2] , \ctemp1[1] , 
     SYNOPSYS_UNCONNECTED_1}), .g_o(\gouta[0] ), .p_o(), .g_b({n1, n1, n1, 
     \gtemp1_b[0] }), .p({\ptemp1[3] , \ptemp1[2] , \ptemp1[1] , n2}), .cin(n2));
  mclg16_6 b5 (.cout({\ctemp2[3] , \ctemp2[2] , gouta_0_1, 
     SYNOPSYS_UNCONNECTED_5}), .g_o(), .p_o(), .g({n2, \gouta[2] , \gouta[1] , 
     \gouta[0] }), .p({n2, pouta[2], pouta[1], n2}), .cin(n2));
  mpfa_114 r06 (.g_b(\gtemp1_b[5] ), .p(\ptemp1[5] ), .Sum(Sum[5]), .A(A[5]), 
     .B(B[5]), .Cin(\ctemp1[5] ));
  mpfa_111 r09 (.g_b(\gtemp1_b[8] ), .p(\ptemp1[8] ), .Sum(Sum[8]), .A(A[8]), 
     .B(B[8]), .Cin(\ctemp2[2] ));
  mpfa_104 r16 (.g_b(), .p(), .Sum(Sum[15]), .A(A[15]), .B(B[15]), 
     .Cin(\ctemp1[15] ));
  mclg4_27 b3 (.cout({\ctemp1[11] , \ctemp1[10] , \ctemp1[9] , 
     SYNOPSYS_UNCONNECTED_3}), .g_o(\gouta[2] ), .p_o(pouta[2]), .g_b({
     \gtemp1_b[11] , \gtemp1_b[10] , \gtemp1_b[9] , \gtemp1_b[8] }), .p({
     \ptemp1[11] , \ptemp1[10] , \ptemp1[9] , \ptemp1[8] }), .cin(\ctemp2[2] ));
  mpfa_117 r03 (.g_b(), .p(\ptemp1[2] ), .Sum(Sum[2]), .A(A[2]), .B(n2), 
     .Cin(\ctemp1[2] ));
  mpfa_116 r04 (.g_b(), .p(\ptemp1[3] ), .Sum(Sum[3]), .A(A[3]), .B(n2), 
     .Cin(\ctemp1[3] ));
  mpfa_118 r02 (.g_b(), .p(\ptemp1[1] ), .Sum(Sum[1]), .A(A[1]), .B(n2), 
     .Cin(\ctemp1[1] ));
  mpfa_110 r10 (.g_b(\gtemp1_b[9] ), .p(\ptemp1[9] ), .Sum(Sum[9]), .A(A[9]), 
     .B(B[9]), .Cin(\ctemp1[9] ));
  mpfa_115 r05 (.g_b(), .p(\ptemp1[4] ), .Sum(Sum[4]), .A(A[4]), .B(n2), 
     .Cin(gouta_0_1));
  mpfa_113 r07 (.g_b(\gtemp1_b[6] ), .p(\ptemp1[6] ), .Sum(Sum[6]), .A(A[6]), 
     .B(B[6]), .Cin(\ctemp1[6] ));
  mclg4_28 b2 (.cout({\ctemp1[7] , \ctemp1[6] , \ctemp1[5] , 
     SYNOPSYS_UNCONNECTED_2}), .g_o(\gouta[1] ), .p_o(pouta[1]), .g_b({n1, 
     \gtemp1_b[6] , \gtemp1_b[5] , n1}), .p({\ptemp1[7] , \ptemp1[6] , 
     \ptemp1[5] , \ptemp1[4] }), .cin(gouta_0_1));
  mclg4_26 b4 (.cout({\ctemp1[15] , \ctemp1[14] , \ctemp1[13] , 
     SYNOPSYS_UNCONNECTED_4}), .g_o(), .p_o(), .g_b({n2, \gtemp1_b[14] , 
     \gtemp1_b[13] , \gtemp1_b[12] }), .p({n2, \ptemp1[14] , \ptemp1[13] , 
     \ptemp1[12] }), .cin(\ctemp2[3] ));
  mpfa_108 r12 (.g_b(\gtemp1_b[11] ), .p(\ptemp1[11] ), .Sum(Sum[11]), .A(A[11]), 
     .B(B[11]), .Cin(\ctemp1[11] ));
  mpfa_107 r13 (.g_b(\gtemp1_b[12] ), .p(\ptemp1[12] ), .Sum(Sum[12]), .A(A[12]), 
     .B(B[12]), .Cin(\ctemp2[3] ));
  mpfa_105 r15 (.g_b(\gtemp1_b[14] ), .p(\ptemp1[14] ), .Sum(Sum[14]), .A(A[14]), 
     .B(B[14]), .Cin(\ctemp1[14] ));
  SEH_TIE0_G_1 U1 (.X(n2));
  SEH_TIE1_G_1 U2 (.X(n1));
endmodule

// Entity:mclg16_6 Model:mclg16_6 Library:magma_checknetlist_lib
module mclg16_6 (cout, g_o, p_o, g, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g;
  input [3:0] p;
  output [3:0] cout;
  SEH_BUF_3 BL_ASSIGN_BUF22 (.A(g[0]), .X(cout[1]));
  SEH_AO21_DG_3 U1 (.A1(p[1]), .A2(g[0]), .B(g[1]), .X(cout[2]));
  SEH_AO21_DG_3 U4 (.A1(cout[2]), .A2(p[2]), .B(g[2]), .X(cout[3]));
endmodule

// Entity:mclg4_26 Model:mclg4_26 Library:magma_checknetlist_lib
module mclg4_26 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  SEH_AO21B_4 U3 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_AO21B_4 U1 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AO21B_4 U2 (.A1(p[2]), .A2(cout[2]), .B(g_b[2]), .X(cout[3]));
endmodule

// Entity:mclg4_27 Model:mclg4_27 Library:magma_checknetlist_lib
module mclg4_27 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AO21B_4 U6 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AO21B_4 U4 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AO21B_4 U3 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_AOAI211_3 U1 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_AN4B_4 U2 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_INV_S_3 U7 (.A(g_b[1]), .X(n8));
  SEH_AOAI211_3 U8 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_INV_S_3 U9 (.A(g_b[0]), .X(n7));
  SEH_INV_S_3 U5 (.A(p[3]), .X(n6));
endmodule

// Entity:mclg4_28 Model:mclg4_28 Library:magma_checknetlist_lib
module mclg4_28 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n9, n10;
  SEH_AN2_S_3 U7 (.A1(cin), .A2(p[0]), .X(cout[1]));
  SEH_AN4_S_3 U5 (.A1(p[2]), .A2(p[0]), .A3(p[1]), .A4(p[3]), .X(p_o));
  SEH_OAOI211_3 U4 (.A1(g_b[1]), .A2(n9), .B(g_b[2]), .C(n10), .X(g_o));
  SEH_INV_S_3 U1 (.A(p[2]), .X(n9));
  SEH_AO21B_4 U2 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AO21B_4 U6 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_INV_S_3 U3 (.A(p[3]), .X(n10));
endmodule

// Entity:mclg4_29 Model:mclg4_29 Library:magma_checknetlist_lib
module mclg4_29 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  SEH_AN2_S_3 U4 (.A1(cout[1]), .A2(p[1]), .X(cout[2]));
  SEH_AN4_S_3 U2 (.A1(cout[1]), .A2(p[1]), .A3(p[2]), .A4(p[3]), .X(g_o));
  SEH_AN2_S_3 U3 (.A1(cout[2]), .A2(p[2]), .X(cout[3]));
  SEH_INV_S_3 U1 (.A(g_b[0]), .X(cout[1]));
endmodule

// Entity:mpfa_104 Model:mpfa_104 Library:magma_checknetlist_lib
module mpfa_104 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO3_3 U1 (.A1(Cin), .A2(A), .A3(B), .X(Sum));
endmodule

// Entity:mpfa_105 Model:mpfa_105 Library:magma_checknetlist_lib
module mpfa_105 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_106 Model:mpfa_106 Library:magma_checknetlist_lib
module mpfa_106 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_107 Model:mpfa_107 Library:magma_checknetlist_lib
module mpfa_107 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_108 Model:mpfa_108 Library:magma_checknetlist_lib
module mpfa_108 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_109 Model:mpfa_109 Library:magma_checknetlist_lib
module mpfa_109 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_110 Model:mpfa_110 Library:magma_checknetlist_lib
module mpfa_110 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_111 Model:mpfa_111 Library:magma_checknetlist_lib
module mpfa_111 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_112 Model:mpfa_112 Library:magma_checknetlist_lib
module mpfa_112 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(Cin), .A2(A), .X(Sum));
  SEH_BUF_3 BL_ASSIGN_BUF4 (.A(A), .X(p));
endmodule

// Entity:mpfa_113 Model:mpfa_113 Library:magma_checknetlist_lib
module mpfa_113 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_114 Model:mpfa_114 Library:magma_checknetlist_lib
module mpfa_114 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_115 Model:mpfa_115 Library:magma_checknetlist_lib
module mpfa_115 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_BUF_S_3 BL_ASSIGN_BUF3 (.A(A), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
endmodule

// Entity:mpfa_116 Model:mpfa_116 Library:magma_checknetlist_lib
module mpfa_116 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
  SEH_BUF_3 BL_ASSIGN_BUF2 (.A(A), .X(p));
endmodule

// Entity:mpfa_117 Model:mpfa_117 Library:magma_checknetlist_lib
module mpfa_117 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_BUF_S_3 BL_ASSIGN_BUF1 (.A(A), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
endmodule

// Entity:mpfa_118 Model:mpfa_118 Library:magma_checknetlist_lib
module mpfa_118 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(A), .X(Sum));
  SEH_BUF_3 BL_ASSIGN_BUF0 (.A(A), .X(p));
endmodule

// Entity:mpfa_119 Model:mpfa_119 Library:magma_checknetlist_lib
module mpfa_119 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(Sum));
  SEH_ND2_S_2P5 U1 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:fcla8 Model:fcla8 Library:magma_checknetlist_lib
module fcla8 (Sum, G, P, A, B, Cin);
  input Cin;
  output G, P;
  input [7:0] A;
  input [7:0] B;
  output [7:0] Sum;
  wire [6:0] gtemp1;
  wire [6:0] ptemp1;
  wire \ctemp1[1] , \ctemp1[2] , \ctemp1[3] , \ctemp1[5] , \ctemp1[6] , 
     \ctemp1[7] , gouta_0_, pouta_0_, n1, n2, SYNOPSYS_UNCONNECTED_1, 
     SYNOPSYS_UNCONNECTED_2;
  mclg4_9 b1 (.cout({\ctemp1[3] , \ctemp1[2] , \ctemp1[1] , 
     SYNOPSYS_UNCONNECTED_1}), .g_o(gouta_0_), .p_o(pouta_0_), .g_b({gtemp1[3], 
     gtemp1[2], gtemp1[1], gtemp1[0]}), .p({ptemp1[3], ptemp1[2], ptemp1[1], 
     ptemp1[0]}), .cin(Cin));
  mpfa_39 r01 (.g_b(gtemp1[0]), .p(ptemp1[0]), .Sum(Sum[0]), .A(A[0]), .B(B[0]), 
     .Cin(Cin));
  mpfa_32 r08 (.g_b(), .p(), .Sum(Sum[7]), .A(A[7]), .B(B[7]), .Cin(\ctemp1[7] ));
  mpfa_34 r06 (.g_b(gtemp1[5]), .p(ptemp1[5]), .Sum(Sum[5]), .A(A[5]), .B(B[5]), 
     .Cin(\ctemp1[5] ));
  mpfa_37 r03 (.g_b(gtemp1[2]), .p(ptemp1[2]), .Sum(Sum[2]), .A(A[2]), .B(B[2]), 
     .Cin(\ctemp1[2] ));
  mclg4_8 b2 (.cout({\ctemp1[7] , \ctemp1[6] , \ctemp1[5] , 
     SYNOPSYS_UNCONNECTED_2}), .g_o(), .p_o(), .g_b({n2, gtemp1[6], gtemp1[5], 
     gtemp1[4]}), .p({n2, ptemp1[6], ptemp1[5], ptemp1[4]}), .cin(n1));
  mpfa_33 r07 (.g_b(gtemp1[6]), .p(ptemp1[6]), .Sum(Sum[6]), .A(A[6]), .B(B[6]), 
     .Cin(\ctemp1[6] ));
  mpfa_35 r05 (.g_b(gtemp1[4]), .p(ptemp1[4]), .Sum(Sum[4]), .A(A[4]), .B(B[4]), 
     .Cin(n1));
  mpfa_36 r04 (.g_b(gtemp1[3]), .p(ptemp1[3]), .Sum(Sum[3]), .A(A[3]), .B(B[3]), 
     .Cin(\ctemp1[3] ));
  mpfa_38 r02 (.g_b(gtemp1[1]), .p(ptemp1[1]), .Sum(Sum[1]), .A(A[1]), .B(B[1]), 
     .Cin(\ctemp1[1] ));
  SEH_AO21_DG_3 U2 (.A1(pouta_0_), .A2(Cin), .B(gouta_0_), .X(n1));
  SEH_TIE0_G_1 U1 (.X(n2));
endmodule

// Entity:mclg4_8 Model:mclg4_8 Library:magma_checknetlist_lib
module mclg4_8 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  SEH_AO21B_4 U3 (.A1(p[2]), .A2(cout[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AO21B_4 U2 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AO21B_4 U1 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
endmodule

// Entity:mclg4_9 Model:mclg4_9 Library:magma_checknetlist_lib
module mclg4_9 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AO21B_4 U2 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_AO21B_4 U5 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AN4B_4 U1 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_AOAI211_3 U8 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_AO21B_4 U3 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_INV_S_3 U9 (.A(g_b[0]), .X(n7));
  SEH_INV_S_3 U6 (.A(g_b[1]), .X(n8));
  SEH_AOAI211_3 U7 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_INV_S_3 U4 (.A(p[3]), .X(n6));
endmodule

// Entity:mpfa_32 Model:mpfa_32 Library:magma_checknetlist_lib
module mpfa_32 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO3_4 U1 (.A1(Cin), .A2(A), .A3(B), .X(Sum));
endmodule

// Entity:mpfa_33 Model:mpfa_33 Library:magma_checknetlist_lib
module mpfa_33 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_34 Model:mpfa_34 Library:magma_checknetlist_lib
module mpfa_34 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_35 Model:mpfa_35 Library:magma_checknetlist_lib
module mpfa_35 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_36 Model:mpfa_36 Library:magma_checknetlist_lib
module mpfa_36 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_37 Model:mpfa_37 Library:magma_checknetlist_lib
module mpfa_37 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_38 Model:mpfa_38 Library:magma_checknetlist_lib
module mpfa_38 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_39 Model:mpfa_39 Library:magma_checknetlist_lib
module mpfa_39 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:MULT_ACCUM_0 Model:MULT_ACCUM_0 Library:magma_checknetlist_lib
module MULT_ACCUM_0 (DIRECT_INPUT, MULT_INPUT, MULT_8x8, MULT_16x16, ADDSUB, 
     CLK, CICAS, CI, SIGNEXTIN, SIGNEXTOUT, LDA, RST, COCAS, CO, O, OUTMUX_SEL, 
     CARRYMUX_SEL, ADDER_A_IN_SEL, ADDER_B_IN_SEL, ENA_BAR, CLK_1, CLK_3, CLK_4, 
     CLK_6);
  input ADDSUB, CLK, CICAS, CI, SIGNEXTIN, LDA, RST, ADDER_A_IN_SEL, ENA_BAR, 
     CLK_1, CLK_3, CLK_4, CLK_6;
  output SIGNEXTOUT, COCAS, CO;
  input [15:0] DIRECT_INPUT;
  input [15:0] MULT_INPUT;
  input [15:0] MULT_8x8;
  input [15:0] MULT_16x16;
  input [1:0] OUTMUX_SEL;
  input [1:0] CARRYMUX_SEL;
  input [1:0] ADDER_B_IN_SEL;
  output [15:0] O;
  wire [14:0] ADDER_B_INPUT_MUX;
  wire [15:0] ADDER_LOAD_MUX;
  wire [15:0] ACCUMULATOR_REG;
  wire [15:0] ADDER_A_INPUT_MUX;
  wire [15:0] ADDER_SUM;
  wire ADDER_CI, n3, MULT_16x16_8_1;
  ACCUM_ADDER_0 ACCUM_ADDER_TOP (.A(ADDER_A_INPUT_MUX), .B({SIGNEXTOUT, 
     ADDER_B_INPUT_MUX[14], ADDER_B_INPUT_MUX[13], ADDER_B_INPUT_MUX[12], 
     ADDER_B_INPUT_MUX[11], ADDER_B_INPUT_MUX[10], ADDER_B_INPUT_MUX[9], 
     ADDER_B_INPUT_MUX[8], ADDER_B_INPUT_MUX[7], ADDER_B_INPUT_MUX[6], 
     ADDER_B_INPUT_MUX[5], ADDER_B_INPUT_MUX[4], ADDER_B_INPUT_MUX[3], 
     ADDER_B_INPUT_MUX[2], ADDER_B_INPUT_MUX[1], ADDER_B_INPUT_MUX[0]}), 
     .ADDSUB(ADDSUB), .CI(ADDER_CI), .SUM(ADDER_SUM), .COCAS(COCAS), .CO(CO));
  CARRY_IN_MUX_0 CARRY_IN_MUX_TOP (.CICAS(CICAS), .CI(CI), .CARRYMUX_SEL({
     CARRYMUX_SEL[1], CARRYMUX_SEL[0]}), .ADDER_CI(ADDER_CI));
  ADDER_A_IN_MUX_0 ADDER_A_IN_MUX_TOP (.ACCUMULATOR_REG(ACCUMULATOR_REG), 
     .DIRECT_INPUT({DIRECT_INPUT[15], DIRECT_INPUT[14], DIRECT_INPUT[13], 
     DIRECT_INPUT[12], DIRECT_INPUT[11], DIRECT_INPUT[10], DIRECT_INPUT[9], 
     DIRECT_INPUT[8], DIRECT_INPUT[7], DIRECT_INPUT[6], DIRECT_INPUT[5], 
     DIRECT_INPUT[4], DIRECT_INPUT[3], DIRECT_INPUT[2], DIRECT_INPUT[1], 
     DIRECT_INPUT[0]}), .SELM(ADDER_A_IN_SEL), .ADDER_A_MUX(ADDER_A_INPUT_MUX));
  OUT_MUX_4_0 OUTPUT_MULTIPLEXER_TOP (.ADDER_COMBINATORIAL(ADDER_LOAD_MUX), 
     .ACCUM_REGISTER(ACCUMULATOR_REG), .MULT_8x8({MULT_8x8[15], MULT_8x8[14], 
     MULT_8x8[13], MULT_8x8[12], MULT_8x8[11], MULT_8x8[10], MULT_8x8[9], 
     MULT_8x8[8], MULT_8x8[7], MULT_8x8[6], MULT_8x8[5], MULT_8x8[4], 
     MULT_8x8[3], MULT_8x8[2], MULT_8x8[1], MULT_8x8[0]}), .MULT_16x16({
     MULT_16x16[15], MULT_16x16[14], MULT_16x16[13], MULT_16x16[12], 
     MULT_16x16[11], MULT_16x16[10], MULT_16x16[9], MULT_16x16_8_1, 
     MULT_16x16[7], MULT_16x16[6], MULT_16x16[5], MULT_16x16[4], MULT_16x16[3], 
     MULT_16x16[2], MULT_16x16[1], MULT_16x16[0]}), .SELM({OUTMUX_SEL[1], 
     OUTMUX_SEL[0]}), .OUT({O[15], O[14], O[13], O[12], O[11], O[10], O[9], O[8], 
     O[7], O[6], O[5], O[4], O[3], O[2], O[1], O[0]}));
  ADDER_B_IN_MUX_0 ADDER_B_IN_MUX_TOP (.MULT_INPUT({MULT_INPUT[15], 
     MULT_INPUT[14], MULT_INPUT[13], MULT_INPUT[12], MULT_INPUT[11], 
     MULT_INPUT[10], MULT_INPUT[9], MULT_INPUT[8], MULT_INPUT[7], MULT_INPUT[6], 
     MULT_INPUT[5], MULT_INPUT[4], MULT_INPUT[3], MULT_INPUT[2], MULT_INPUT[1], 
     MULT_INPUT[0]}), .MULT_8x8({MULT_8x8[15], MULT_8x8[14], MULT_8x8[13], 
     MULT_8x8[12], MULT_8x8[11], MULT_8x8[10], MULT_8x8[9], MULT_8x8[8], 
     MULT_8x8[7], MULT_8x8[6], MULT_8x8[5], MULT_8x8[4], MULT_8x8[3], 
     MULT_8x8[2], MULT_8x8[1], MULT_8x8[0]}), .MULT_16x16({MULT_16x16[15], 
     MULT_16x16[14], MULT_16x16[13], MULT_16x16[12], MULT_16x16[11], 
     MULT_16x16[10], MULT_16x16[9], MULT_16x16_8_1, MULT_16x16[7], 
     MULT_16x16[6], MULT_16x16[5], MULT_16x16[4], MULT_16x16[3], MULT_16x16[2], 
     MULT_16x16[1], MULT_16x16[0]}), .SIGNEXTIN(SIGNEXTIN), .SELM({
     ADDER_B_IN_SEL[1], ADDER_B_IN_SEL[0]}), .ADDER_B_MUX({SIGNEXTOUT, 
     ADDER_B_INPUT_MUX[14], ADDER_B_INPUT_MUX[13], ADDER_B_INPUT_MUX[12], 
     ADDER_B_INPUT_MUX[11], ADDER_B_INPUT_MUX[10], ADDER_B_INPUT_MUX[9], 
     ADDER_B_INPUT_MUX[8], ADDER_B_INPUT_MUX[7], ADDER_B_INPUT_MUX[6], 
     ADDER_B_INPUT_MUX[5], ADDER_B_INPUT_MUX[4], ADDER_B_INPUT_MUX[3], 
     ADDER_B_INPUT_MUX[2], ADDER_B_INPUT_MUX[1], ADDER_B_INPUT_MUX[0]}));
  LOAD_ADD_MUX_0 LOAD_ADD_TOP (.ADDER(ADDER_SUM), .LOAD_DATA({DIRECT_INPUT[15], 
     DIRECT_INPUT[14], DIRECT_INPUT[13], DIRECT_INPUT[12], DIRECT_INPUT[11], 
     DIRECT_INPUT[10], DIRECT_INPUT[9], DIRECT_INPUT[8], DIRECT_INPUT[7], 
     DIRECT_INPUT[6], DIRECT_INPUT[5], DIRECT_INPUT[4], DIRECT_INPUT[3], 
     DIRECT_INPUT[2], DIRECT_INPUT[1], DIRECT_INPUT[0]}), .LOAD(LDA), 
     .OUT(ADDER_LOAD_MUX));
  ACCUM_REG_0 ACCUM_REG_TOP (.D(ADDER_LOAD_MUX), .Q(ACCUMULATOR_REG), .ENA(n3), 
     .CLK(CLK), .RST(RST), .CLK_1(CLK_1), .CLK_3(CLK_3), .CLK_4(CLK_4), 
     .CLK_6(CLK_6));
  SEH_INV_S_3 U1 (.A(ENA_BAR), .X(n3));
  SEH_BUF_D_3 ONROUTE_9 (.A(MULT_16x16[8]), .X(MULT_16x16_8_1));
endmodule

// Entity:ACCUM_ADDER_0 Model:ACCUM_ADDER_0 Library:magma_checknetlist_lib
module ACCUM_ADDER_0 (A, B, ADDSUB, CI, SUM, COCAS, CO);
  input ADDSUB, CI;
  output COCAS, CO;
  input [15:0] A;
  input [15:0] B;
  output [15:0] SUM;
  wire [15:0] CLA16_SUM;
  wire [15:0] CLA16_A;
  wire CLA16_g, CLA16_p, n1, n2, n3, n4, ADDSUB_1;
  fcla16_0 CLA16_ADDER (.Sum(CLA16_SUM), .G(CLA16_g), .P(CLA16_p), .A(CLA16_A), 
     .B({B[15], B[14], B[13], B[12], B[11], B[10], B[9], B[8], B[7], B[6], B[5], 
     B[4], B[3], B[2], B[1], B[0]}), .Cin(CI));
  SEH_EO2_G_3 U22 (.A1(CLA16_SUM[0]), .A2(n2), .X(SUM[0]));
  SEH_EO2_G_3 U3 (.A1(COCAS), .A2(n2), .X(CO));
  SEH_EO2_G_3 U33 (.A1(A[12]), .A2(n3), .X(CLA16_A[12]));
  SEH_EO2_G_3 U31 (.A1(A[9]), .A2(n1), .X(CLA16_A[9]));
  SEH_EO2_G_3 U35 (.A1(A[10]), .A2(n4), .X(CLA16_A[10]));
  SEH_EO2_G_3 U27 (.A1(A[2]), .A2(n1), .X(CLA16_A[2]));
  SEH_EO2_G_3 U20 (.A1(CLA16_SUM[3]), .A2(n4), .X(SUM[3]));
  SEH_EO2_G_3 U9 (.A1(CLA16_SUM[8]), .A2(ADDSUB_1), .X(SUM[8]));
  SEH_EO2_G_3 U36 (.A1(A[11]), .A2(n3), .X(CLA16_A[11]));
  SEH_EO2_G_3 U30 (.A1(A[7]), .A2(n1), .X(CLA16_A[7]));
  SEH_EO2_G_3 U32 (.A1(A[8]), .A2(n1), .X(CLA16_A[8]));
  SEH_EO2_G_3 U10 (.A1(CLA16_SUM[10]), .A2(n2), .X(SUM[10]));
  SEH_EO2_G_3 U34 (.A1(A[13]), .A2(ADDSUB), .X(CLA16_A[13]));
  SEH_EO2_G_3 U37 (.A1(A[14]), .A2(ADDSUB), .X(CLA16_A[14]));
  SEH_AO21_DG_3 U6 (.A1(CLA16_p), .A2(CI), .B(CLA16_g), .X(COCAS));
  SEH_EO2_G_3 U23 (.A1(A[1]), .A2(ADDSUB_1), .X(CLA16_A[1]));
  SEH_EO2_G_3 U25 (.A1(A[4]), .A2(n1), .X(CLA16_A[4]));
  SEH_EO2_G_3 U7 (.A1(CLA16_SUM[6]), .A2(n3), .X(SUM[6]));
  SEH_BUF_3 U4 (.A(n4), .X(n1));
  SEH_EO2_G_3 U29 (.A1(A[6]), .A2(n1), .X(CLA16_A[6]));
  SEH_EO2_G_3 U38 (.A1(A[15]), .A2(n4), .X(CLA16_A[15]));
  SEH_BUF_3 BW1_BUF3860 (.A(ADDSUB), .X(ADDSUB_1));
  SEH_EO2_G_3 U11 (.A1(CLA16_SUM[11]), .A2(n2), .X(SUM[11]));
  SEH_EO2_G_3 U18 (.A1(CLA16_SUM[9]), .A2(n3), .X(SUM[9]));
  SEH_BUF_3 U2 (.A(ADDSUB_1), .X(n3));
  SEH_BUF_3 U5 (.A(n4), .X(n2));
  SEH_BUF_3 U1 (.A(ADDSUB_1), .X(n4));
  SEH_EO2_G_3 U28 (.A1(A[3]), .A2(n1), .X(CLA16_A[3]));
  SEH_EO2_G_3 U15 (.A1(CLA16_SUM[13]), .A2(n2), .X(SUM[13]));
  SEH_EO2_G_3 U17 (.A1(CLA16_SUM[12]), .A2(n2), .X(SUM[12]));
  SEH_EO2_G_3 U16 (.A1(CLA16_SUM[4]), .A2(n3), .X(SUM[4]));
  SEH_EO2_G_3 U12 (.A1(CLA16_SUM[14]), .A2(n2), .X(SUM[14]));
  SEH_EO2_G_3 U13 (.A1(CLA16_SUM[15]), .A2(n2), .X(SUM[15]));
  SEH_EO2_G_3 U24 (.A1(A[0]), .A2(n4), .X(CLA16_A[0]));
  SEH_EO2_G_3 U26 (.A1(A[5]), .A2(n1), .X(CLA16_A[5]));
  SEH_EO2_G_3 U14 (.A1(CLA16_SUM[5]), .A2(n4), .X(SUM[5]));
  SEH_EO2_G_3 U8 (.A1(CLA16_SUM[7]), .A2(n3), .X(SUM[7]));
  SEH_EO2_G_3 U19 (.A1(CLA16_SUM[2]), .A2(ADDSUB_1), .X(SUM[2]));
  SEH_EO2_G_3 U21 (.A1(CLA16_SUM[1]), .A2(n3), .X(SUM[1]));
endmodule

// Entity:fcla16_0 Model:fcla16_0 Library:magma_checknetlist_lib
module fcla16_0 (Sum, G, P, A, B, Cin);
  input Cin;
  output G, P;
  input [15:0] A;
  input [15:0] B;
  output [15:0] Sum;
  wire [15:0] gtemp1_b;
  wire [15:0] ptemp1;
  wire [3:0] gouta;
  wire [3:0] pouta;
  wire [3:1] ctemp2;
  wire \ctemp1[1] , \ctemp1[2] , \ctemp1[3] , \ctemp1[5] , \ctemp1[6] , 
     \ctemp1[7] , \ctemp1[9] , \ctemp1[10] , \ctemp1[11] , \ctemp1[13] , 
     \ctemp1[14] , \ctemp1[15] , SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2, 
     SYNOPSYS_UNCONNECTED_3, SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5;
  mpfa_15 r01 (.g_b(gtemp1_b[0]), .p(ptemp1[0]), .Sum(Sum[0]), .A(A[0]), 
     .B(B[0]), .Cin(Cin));
  mpfa_14 r02 (.g_b(gtemp1_b[1]), .p(ptemp1[1]), .Sum(Sum[1]), .A(A[1]), 
     .B(B[1]), .Cin(\ctemp1[1] ));
  mpfa_0 r16 (.g_b(gtemp1_b[15]), .p(ptemp1[15]), .Sum(Sum[15]), .A(A[15]), 
     .B(B[15]), .Cin(\ctemp1[15] ));
  mclg4_0 b4 (.cout({\ctemp1[15] , \ctemp1[14] , \ctemp1[13] , 
     SYNOPSYS_UNCONNECTED_4}), .g_o(gouta[3]), .p_o(pouta[3]), .g_b({gtemp1_b[15], 
     gtemp1_b[14], gtemp1_b[13], gtemp1_b[12]}), .p({ptemp1[15], ptemp1[14], 
     ptemp1[13], ptemp1[12]}), .cin(ctemp2[3]));
  mclg16_0 b5 (.cout({ctemp2[3], ctemp2[2], ctemp2[1], SYNOPSYS_UNCONNECTED_5}), 
     .g_o(G), .p_o(P), .g(gouta), .p(pouta), .cin(Cin));
  mpfa_10 r06 (.g_b(gtemp1_b[5]), .p(ptemp1[5]), .Sum(Sum[5]), .A(A[5]), 
     .B(B[5]), .Cin(\ctemp1[5] ));
  mpfa_1 r15 (.g_b(gtemp1_b[14]), .p(ptemp1[14]), .Sum(Sum[14]), .A(A[14]), 
     .B(B[14]), .Cin(\ctemp1[14] ));
  mpfa_2 r14 (.g_b(gtemp1_b[13]), .p(ptemp1[13]), .Sum(Sum[13]), .A(A[13]), 
     .B(B[13]), .Cin(\ctemp1[13] ));
  mpfa_3 r13 (.g_b(gtemp1_b[12]), .p(ptemp1[12]), .Sum(Sum[12]), .A(A[12]), 
     .B(B[12]), .Cin(ctemp2[3]));
  mclg4_1 b3 (.cout({\ctemp1[11] , \ctemp1[10] , \ctemp1[9] , 
     SYNOPSYS_UNCONNECTED_3}), .g_o(gouta[2]), .p_o(pouta[2]), .g_b({gtemp1_b[11], 
     gtemp1_b[10], gtemp1_b[9], gtemp1_b[8]}), .p({ptemp1[11], ptemp1[10], 
     ptemp1[9], ptemp1[8]}), .cin(ctemp2[2]));
  mpfa_4 r12 (.g_b(gtemp1_b[11]), .p(ptemp1[11]), .Sum(Sum[11]), .A(A[11]), 
     .B(B[11]), .Cin(\ctemp1[11] ));
  mpfa_5 r11 (.g_b(gtemp1_b[10]), .p(ptemp1[10]), .Sum(Sum[10]), .A(A[10]), 
     .B(B[10]), .Cin(\ctemp1[10] ));
  mpfa_6 r10 (.g_b(gtemp1_b[9]), .p(ptemp1[9]), .Sum(Sum[9]), .A(A[9]), .B(B[9]), 
     .Cin(\ctemp1[9] ));
  mpfa_7 r09 (.g_b(gtemp1_b[8]), .p(ptemp1[8]), .Sum(Sum[8]), .A(A[8]), .B(B[8]), 
     .Cin(ctemp2[2]));
  mclg4_2 b2 (.cout({\ctemp1[7] , \ctemp1[6] , \ctemp1[5] , 
     SYNOPSYS_UNCONNECTED_2}), .g_o(gouta[1]), .p_o(pouta[1]), .g_b({gtemp1_b[7], 
     gtemp1_b[6], gtemp1_b[5], gtemp1_b[4]}), .p({ptemp1[7], ptemp1[6], ptemp1[5], 
     ptemp1[4]}), .cin(ctemp2[1]));
  mpfa_8 r08 (.g_b(gtemp1_b[7]), .p(ptemp1[7]), .Sum(Sum[7]), .A(A[7]), .B(B[7]), 
     .Cin(\ctemp1[7] ));
  mpfa_9 r07 (.g_b(gtemp1_b[6]), .p(ptemp1[6]), .Sum(Sum[6]), .A(A[6]), .B(B[6]), 
     .Cin(\ctemp1[6] ));
  mpfa_13 r03 (.g_b(gtemp1_b[2]), .p(ptemp1[2]), .Sum(Sum[2]), .A(A[2]), 
     .B(B[2]), .Cin(\ctemp1[2] ));
  mpfa_11 r05 (.g_b(gtemp1_b[4]), .p(ptemp1[4]), .Sum(Sum[4]), .A(A[4]), 
     .B(B[4]), .Cin(ctemp2[1]));
  mclg4_3 b1 (.cout({\ctemp1[3] , \ctemp1[2] , \ctemp1[1] , 
     SYNOPSYS_UNCONNECTED_1}), .g_o(gouta[0]), .p_o(pouta[0]), .g_b({gtemp1_b[3], 
     gtemp1_b[2], gtemp1_b[1], gtemp1_b[0]}), .p({ptemp1[3], ptemp1[2], ptemp1[1], 
     ptemp1[0]}), .cin(Cin));
  mpfa_12 r04 (.g_b(gtemp1_b[3]), .p(ptemp1[3]), .Sum(Sum[3]), .A(A[3]), 
     .B(B[3]), .Cin(\ctemp1[3] ));
endmodule

// Entity:mclg16_0 Model:mclg16_0 Library:magma_checknetlist_lib
module mclg16_0 (cout, g_o, p_o, g, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g;
  input [3:0] p;
  output [3:0] cout;
  wire n1, n4, n5;
  SEH_OAOI211_3 U7 (.A1(g[2]), .A2(n5), .B(p[3]), .C(g[3]), .X(n4));
  SEH_AOAI211_G_3 U2 (.A1(g[0]), .A2(p[1]), .B(g[1]), .C(p[2]), .X(n1));
  SEH_AO21_DG_3 U8 (.A1(cin), .A2(p[0]), .B(g[0]), .X(cout[1]));
  SEH_AO21_DG_3 U4 (.A1(cout[2]), .A2(p[2]), .B(g[2]), .X(cout[3]));
  SEH_INV_S_3 U1 (.A(n1), .X(n5));
  SEH_AN4_S_3 U5 (.A1(p[0]), .A2(p[1]), .A3(p[2]), .A4(p[3]), .X(p_o));
  SEH_INV_S_3 U6 (.A(n4), .X(g_o));
  SEH_AO21_DG_3 U3 (.A1(cout[1]), .A2(p[1]), .B(g[1]), .X(cout[2]));
endmodule

// Entity:mclg4_0 Model:mclg4_0 Library:magma_checknetlist_lib
module mclg4_0 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AOAI211_3 U7 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_AO21B_4 U6 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AO21B_4 U5 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AN4B_4 U1 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_INV_S_3 U2 (.A(p[3]), .X(n6));
  SEH_AOAI211_3 U8 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_INV_S_3 U3 (.A(g_b[0]), .X(n7));
  SEH_INV_S_3 U9 (.A(g_b[1]), .X(n8));
  SEH_AO21B_4 U4 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
endmodule

// Entity:mclg4_1 Model:mclg4_1 Library:magma_checknetlist_lib
module mclg4_1 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AN4B_4 U1 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_AO21B_4 U6 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AOAI211_3 U7 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_INV_S_3 U2 (.A(p[3]), .X(n6));
  SEH_AO21B_4 U4 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_AO21B_4 U5 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_INV_S_3 U9 (.A(g_b[0]), .X(n7));
  SEH_INV_S_3 U3 (.A(g_b[1]), .X(n8));
  SEH_AOAI211_3 U8 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
endmodule

// Entity:mclg4_2 Model:mclg4_2 Library:magma_checknetlist_lib
module mclg4_2 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AOAI211_G_3 U7 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_AO21B_4 U6 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AN4B_4 U1 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_AOAI211_G_3 U8 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_INV_S_3 U9 (.A(g_b[1]), .X(n8));
  SEH_AO21B_4 U5 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AO21B_4 U4 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_INV_S_3 U2 (.A(p[3]), .X(n6));
  SEH_INV_S_3 U3 (.A(g_b[0]), .X(n7));
endmodule

// Entity:mclg4_3 Model:mclg4_3 Library:magma_checknetlist_lib
module mclg4_3 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AO21B_4 U5 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AOAI211_G_3 U6 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_INV_S_3 U2 (.A(p[3]), .X(n6));
  SEH_INV_S_3 U8 (.A(g_b[0]), .X(n7));
  SEH_AN4B_4 U1 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_AOAI211_G_3 U7 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_INV_S_3 U3 (.A(g_b[1]), .X(n8));
  SEH_AO21B_4 U4 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AO21B_4 U9 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
endmodule

// Entity:mpfa_0 Model:mpfa_0 Library:magma_checknetlist_lib
module mpfa_0 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_1 Model:mpfa_1 Library:magma_checknetlist_lib
module mpfa_1 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_10 Model:mpfa_10 Library:magma_checknetlist_lib
module mpfa_10 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_11 Model:mpfa_11 Library:magma_checknetlist_lib
module mpfa_11 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_12 Model:mpfa_12 Library:magma_checknetlist_lib
module mpfa_12 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_13 Model:mpfa_13 Library:magma_checknetlist_lib
module mpfa_13 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_14 Model:mpfa_14 Library:magma_checknetlist_lib
module mpfa_14 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_15 Model:mpfa_15 Library:magma_checknetlist_lib
module mpfa_15 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_2 Model:mpfa_2 Library:magma_checknetlist_lib
module mpfa_2 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_3 Model:mpfa_3 Library:magma_checknetlist_lib
module mpfa_3 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_4 Model:mpfa_4 Library:magma_checknetlist_lib
module mpfa_4 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_5 Model:mpfa_5 Library:magma_checknetlist_lib
module mpfa_5 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_6 Model:mpfa_6 Library:magma_checknetlist_lib
module mpfa_6 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_7 Model:mpfa_7 Library:magma_checknetlist_lib
module mpfa_7 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_8 Model:mpfa_8 Library:magma_checknetlist_lib
module mpfa_8 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_9 Model:mpfa_9 Library:magma_checknetlist_lib
module mpfa_9 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:ACCUM_REG_0 Model:ACCUM_REG_0 Library:magma_checknetlist_lib
module ACCUM_REG_0 (D, Q, ENA, CLK, RST, CLK_1, CLK_3, CLK_4, CLK_6);
  input ENA, CLK, RST, CLK_1, CLK_3, CLK_4, CLK_6;
  input [15:0] D;
  output [15:0] Q;
  wire n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, 
     n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, 
     n64, n65, n66, n67, n68, n69, n70, n71, n54_1, n54_2, CLK_2;
  SEH_FDPRBQ_V2_3 Q_reg_6_ (.CK(CLK_2), .D(n47), .Q(Q[6]), .RD(n54_1));
  SEH_AOI22_3 U13 (.A1(D[5]), .A2(n37), .B1(Q[5]), .B2(n35), .X(n65));
  SEH_AOI22_3 U34 (.A1(D[15]), .A2(n37), .B1(Q[15]), .B2(n70), .X(n55));
  SEH_INV_S_3 U24 (.A(n59), .X(n42));
  SEH_AOI22_3 U21 (.A1(D[9]), .A2(n37), .B1(Q[9]), .B2(n70), .X(n61));
  SEH_INV_S_3 U37 (.A(RST), .X(n54));
  SEH_FDPRBQ_V2_3 Q_reg_13_ (.CK(CLK_4), .D(n40), .Q(Q[13]), .RD(n54_2));
  SEH_AOI22_3 U27 (.A1(D[12]), .A2(n36), .B1(Q[12]), .B2(n70), .X(n58));
  SEH_AOI22_3 U11 (.A1(D[4]), .A2(ENA), .B1(Q[4]), .B2(n35), .X(n66));
  SEH_AOI22_3 U23 (.A1(D[10]), .A2(n36), .B1(Q[10]), .B2(n70), .X(n60));
  SEH_AOI22_3 U7 (.A1(D[2]), .A2(ENA), .B1(Q[2]), .B2(n35), .X(n68));
  SEH_FDPRBQ_V2_3 Q_reg_3_ (.CK(CLK_2), .D(n50), .Q(Q[3]), .RD(n54_2));
  SEH_INV_S_3 U28 (.A(n57), .X(n40));
  SEH_AOI22_3 U29 (.A1(D[13]), .A2(n37), .B1(Q[13]), .B2(n70), .X(n57));
  SEH_BUF_24 CLK_L0 (.A(CLK), .X(CLK_2));
  SEH_FDPRBQ_V2_3 Q_reg_9_ (.CK(CLK_2), .D(n44), .Q(Q[9]), .RD(n54_1));
  SEH_FDPRBQ_V2_3 Q_reg_11_ (.CK(CLK_2), .D(n42), .Q(Q[11]), .RD(n54_1));
  SEH_FDPRBQ_V2_3 Q_reg_5_ (.CK(CLK_1), .D(n48), .Q(Q[5]), .RD(n54_1));
  SEH_INV_S_3 U12 (.A(n65), .X(n48));
  SEH_INV_S_3 U20 (.A(n61), .X(n44));
  SEH_FDPRBQ_V2_3 Q_reg_4_ (.CK(CLK_1), .D(n49), .Q(Q[4]), .RD(n54_1));
  SEH_INV_S_3 U14 (.A(n64), .X(n47));
  SEH_INV_S_3 U10 (.A(n66), .X(n49));
  SEH_AOI22_3 U15 (.A1(D[6]), .A2(n36), .B1(Q[6]), .B2(n35), .X(n64));
  SEH_INV_S_3 U16 (.A(n63), .X(n46));
  SEH_BUF_3 U36 (.A(ENA), .X(n37));
  SEH_INV_S_3 U33 (.A(n55), .X(n38));
  SEH_FDPRBQ_V2_3 Q_reg_15_ (.CK(CLK_6), .D(n38), .Q(Q[15]), .RD(n54_2));
  SEH_INV_S_3 U38 (.A(n36), .X(n70));
  SEH_INV_S_3 U18 (.A(n62), .X(n45));
  SEH_AOI22_3 U19 (.A1(D[8]), .A2(n36), .B1(Q[8]), .B2(n70), .X(n62));
  SEH_AOI22_3 U25 (.A1(D[11]), .A2(n37), .B1(Q[11]), .B2(n70), .X(n59));
  SEH_INV_S_3 U26 (.A(n58), .X(n41));
  SEH_INV_S_3 U22 (.A(n60), .X(n43));
  SEH_INV_S_3 U30 (.A(n56), .X(n39));
  SEH_FDPRBQ_V2_3 Q_reg_14_ (.CK(CLK_3), .D(n39), .Q(Q[14]), .RD(n54_2));
  SEH_FDPRBQ_V2_3 Q_reg_8_ (.CK(CLK_2), .D(n45), .Q(Q[8]), .RD(n54_1));
  SEH_BUF_3 U35 (.A(ENA), .X(n36));
  SEH_INV_S_3 U6 (.A(n68), .X(n51));
  SEH_FDPRBQ_V2_3 Q_reg_2_ (.CK(CLK_1), .D(n51), .Q(Q[2]), .RD(n54_1));
  SEH_BUF_D_3 BW1_BUF4403 (.A(n54), .X(n54_1));
  SEH_AOI22_3 U17 (.A1(D[7]), .A2(n37), .B1(Q[7]), .B2(n35), .X(n63));
  SEH_FDPRBQ_V2_3 Q_reg_7_ (.CK(CLK_2), .D(n46), .Q(Q[7]), .RD(n54_1));
  SEH_INV_S_3 U32 (.A(n36), .X(n35));
  SEH_AOI22_3 U5 (.A1(D[1]), .A2(ENA), .B1(Q[1]), .B2(n35), .X(n69));
  SEH_FDPRBQ_V2_3 Q_reg_10_ (.CK(CLK_2), .D(n43), .Q(Q[10]), .RD(n54_2));
  SEH_FDPRBQ_V2_3 Q_reg_1_ (.CK(CLK_1), .D(n52), .Q(Q[1]), .RD(n54));
  SEH_FDPRBQ_V2_3 Q_reg_0_ (.CK(CLK_1), .D(n53), .Q(Q[0]), .RD(n54));
  SEH_AOI22_3 U9 (.A1(D[3]), .A2(ENA), .B1(Q[3]), .B2(n35), .X(n67));
  SEH_FDPRBQ_V2_3 Q_reg_12_ (.CK(CLK_2), .D(n41), .Q(Q[12]), .RD(n54_2));
  SEH_AOI22_3 U31 (.A1(D[14]), .A2(n36), .B1(Q[14]), .B2(n70), .X(n56));
  SEH_AOI22_3 U3 (.A1(ENA), .A2(D[0]), .B1(Q[0]), .B2(n35), .X(n71));
  SEH_INV_S_3 U8 (.A(n67), .X(n50));
  SEH_BUF_D_3 BW1_BUF4403_1 (.A(n54), .X(n54_2));
  SEH_INV_S_3 U2 (.A(n71), .X(n53));
  SEH_INV_S_3 U4 (.A(n69), .X(n52));
endmodule

// Entity:ADDER_A_IN_MUX_0 Model:ADDER_A_IN_MUX_0 Library:magma_checknetlist_lib
module ADDER_A_IN_MUX_0 (ACCUMULATOR_REG, DIRECT_INPUT, SELM, ADDER_A_MUX);
  input SELM;
  input [15:0] ACCUMULATOR_REG;
  input [15:0] DIRECT_INPUT;
  output [15:0] ADDER_A_MUX;
  wire n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, 
     n21, n22, n23, n24;
  SEH_AOI22_3 U8 (.A1(ACCUMULATOR_REG[0]), .A2(n24), .B1(DIRECT_INPUT[0]), 
     .B2(n3), .X(n4));
  SEH_AOI22_3 U20 (.A1(ACCUMULATOR_REG[7]), .A2(n24), .B1(DIRECT_INPUT[7]), 
     .B2(n3), .X(n21));
  SEH_AOI22_3 U28 (.A1(ACCUMULATOR_REG[13]), .A2(n1), .B1(DIRECT_INPUT[13]), 
     .B2(n3), .X(n8));
  SEH_AOI22_3 U34 (.A1(ACCUMULATOR_REG[14]), .A2(n1), .B1(DIRECT_INPUT[14]), 
     .B2(n3), .X(n9));
  SEH_INV_S_3 U27 (.A(n8), .X(ADDER_A_MUX[13]));
  SEH_INV_S_3 U33 (.A(n9), .X(ADDER_A_MUX[14]));
  SEH_AOI22_3 U22 (.A1(ACCUMULATOR_REG[9]), .A2(n1), .B1(SELM), 
     .B2(DIRECT_INPUT[9]), .X(n23));
  SEH_INV_S_3 U7 (.A(n4), .X(ADDER_A_MUX[0]));
  SEH_INV_S_3 U17 (.A(n16), .X(ADDER_A_MUX[6]));
  SEH_INV_S_3 U5 (.A(n11), .X(ADDER_A_MUX[1]));
  SEH_AOI22_3 U32 (.A1(ACCUMULATOR_REG[11]), .A2(n1), .B1(DIRECT_INPUT[11]), 
     .B2(n2), .X(n6));
  SEH_AOI22_3 U12 (.A1(ACCUMULATOR_REG[5]), .A2(n24), .B1(DIRECT_INPUT[5]), 
     .B2(n2), .X(n15));
  SEH_AOI22_3 U26 (.A1(ACCUMULATOR_REG[12]), .A2(n1), .B1(DIRECT_INPUT[12]), 
     .B2(n2), .X(n7));
  SEH_INV_S_3 U9 (.A(n14), .X(ADDER_A_MUX[4]));
  SEH_INV_S_3 U15 (.A(n13), .X(ADDER_A_MUX[3]));
  SEH_INV_S_3 U13 (.A(n12), .X(ADDER_A_MUX[2]));
  SEH_INV_S_3 U19 (.A(n21), .X(ADDER_A_MUX[7]));
  SEH_INV_S_3 U11 (.A(n15), .X(ADDER_A_MUX[5]));
  SEH_INV_S_3 U31 (.A(n6), .X(ADDER_A_MUX[11]));
  SEH_INV_S_3 U21 (.A(n23), .X(ADDER_A_MUX[9]));
  SEH_INV_S_3 U25 (.A(n7), .X(ADDER_A_MUX[12]));
  SEH_INV_S_3 U23 (.A(n22), .X(ADDER_A_MUX[8]));
  SEH_INV_S_3 U29 (.A(n5), .X(ADDER_A_MUX[10]));
  SEH_INV_S_3 U35 (.A(n10), .X(ADDER_A_MUX[15]));
  SEH_BUF_3 U3 (.A(SELM), .X(n3));
  SEH_BUF_3 U2 (.A(SELM), .X(n2));
  SEH_INV_S_3 U4 (.A(n2), .X(n24));
  SEH_AOI22_3 U6 (.A1(ACCUMULATOR_REG[1]), .A2(n24), .B1(DIRECT_INPUT[1]), 
     .B2(n2), .X(n11));
  SEH_AOI22_3 U10 (.A1(ACCUMULATOR_REG[4]), .A2(n24), .B1(DIRECT_INPUT[4]), 
     .B2(n3), .X(n14));
  SEH_AOI22_3 U18 (.A1(ACCUMULATOR_REG[6]), .A2(n24), .B1(DIRECT_INPUT[6]), 
     .B2(n2), .X(n16));
  SEH_AOI22_3 U14 (.A1(ACCUMULATOR_REG[2]), .A2(n24), .B1(DIRECT_INPUT[2]), 
     .B2(n3), .X(n12));
  SEH_AOI22_3 U16 (.A1(ACCUMULATOR_REG[3]), .A2(n24), .B1(DIRECT_INPUT[3]), 
     .B2(SELM), .X(n13));
  SEH_AOI22_3 U36 (.A1(ACCUMULATOR_REG[15]), .A2(n1), .B1(DIRECT_INPUT[15]), 
     .B2(SELM), .X(n10));
  SEH_AOI22_3 U24 (.A1(ACCUMULATOR_REG[8]), .A2(n1), .B1(DIRECT_INPUT[8]), 
     .B2(SELM), .X(n22));
  SEH_AOI22_3 U30 (.A1(ACCUMULATOR_REG[10]), .A2(n1), .B1(DIRECT_INPUT[10]), 
     .B2(SELM), .X(n5));
  SEH_INV_S_3 U1 (.A(n2), .X(n1));
endmodule

// Entity:ADDER_B_IN_MUX_0 Model:ADDER_B_IN_MUX_0 Library:magma_checknetlist_lib
module ADDER_B_IN_MUX_0 (MULT_INPUT, MULT_8x8, MULT_16x16, SIGNEXTIN, SELM, 
     ADDER_B_MUX);
  input SIGNEXTIN;
  input [15:0] MULT_INPUT;
  input [15:0] MULT_8x8;
  input [15:0] MULT_16x16;
  input [1:0] SELM;
  output [15:0] ADDER_B_MUX;
  wire n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, 
     n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, 
     n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, 
     n82;
  SEH_AOI22_3 U28 (.A1(MULT_8x8[13]), .A2(n38), .B1(MULT_INPUT[13]), .B2(n39), 
     .X(n50));
  SEH_INV_S_3 U27 (.A(MULT_16x16[13]), .X(n80));
  SEH_INV_S_3 U25 (.A(MULT_16x16[15]), .X(n82));
  SEH_AOI22_3 U26 (.A1(MULT_8x8[15]), .A2(n44), .B1(MULT_INPUT[15]), .B2(n45), 
     .X(n52));
  SEH_AOI22_3 U42 (.A1(MULT_8x8[1]), .A2(n38), .B1(MULT_INPUT[1]), .B2(n39), 
     .X(n53));
  SEH_OAI211_8 U3 (.A1(n65), .A2(n82), .B1(n64), .B2(n52), .X(ADDER_B_MUX[15]));
  SEH_BUF_3 U7 (.A(n65), .X(n41));
  SEH_OAI211_3 U2 (.A1(n65), .A2(n80), .B1(n64), .B2(n50), .X(ADDER_B_MUX[13]));
  SEH_OAI211_3 U1 (.A1(n65), .A2(n79), .B1(n64), .B2(n49), .X(ADDER_B_MUX[12]));
  SEH_INV_S_3 U55 (.A(MULT_16x16[7]), .X(n74));
  SEH_INV_S_3 U53 (.A(MULT_16x16[6]), .X(n73));
  SEH_INV_S_3 U39 (.A(MULT_16x16[14]), .X(n81));
  SEH_OAI211_3 U17 (.A1(n42), .A2(n70), .B1(n43), .B2(n55), .X(ADDER_B_MUX[3]));
  SEH_AOI22_3 U38 (.A1(MULT_8x8[10]), .A2(n38), .B1(MULT_INPUT[10]), .B2(n39), 
     .X(n47));
  SEH_AOI22_3 U56 (.A1(MULT_8x8[7]), .A2(n38), .B1(MULT_INPUT[7]), .B2(n39), 
     .X(n59));
  SEH_AOI22_3 U34 (.A1(MULT_8x8[8]), .A2(n44), .B1(MULT_INPUT[8]), .B2(n45), 
     .X(n60));
  SEH_INV_S_3 U31 (.A(MULT_16x16[9]), .X(n76));
  SEH_OAI211_3 U15 (.A1(n42), .A2(n81), .B1(n43), .B2(n51), .X(ADDER_B_MUX[14]));
  SEH_AOI22_3 U50 (.A1(MULT_8x8[2]), .A2(n44), .B1(MULT_INPUT[2]), .B2(n45), 
     .X(n54));
  SEH_BUF_3 U8 (.A(n64), .X(n43));
  SEH_AOI22_3 U52 (.A1(MULT_8x8[3]), .A2(n44), .B1(MULT_INPUT[3]), .B2(n45), 
     .X(n55));
  SEH_INV_S_3 U29 (.A(MULT_16x16[11]), .X(n78));
  SEH_AOI22_3 U30 (.A1(MULT_8x8[11]), .A2(n44), .B1(MULT_INPUT[11]), .B2(n45), 
     .X(n48));
  SEH_AOI22_3 U36 (.A1(MULT_8x8[12]), .A2(n44), .B1(MULT_INPUT[12]), .B2(n45), 
     .X(n49));
  SEH_OAI211_3 U14 (.A1(n41), .A2(n77), .B1(n40), .B2(n47), .X(ADDER_B_MUX[10]));
  SEH_AOI22_3 U46 (.A1(MULT_8x8[4]), .A2(n38), .B1(MULT_INPUT[4]), .B2(n39), 
     .X(n56));
  SEH_INV_S_3 U43 (.A(MULT_16x16[0]), .X(n67));
  SEH_AOI22_3 U32 (.A1(MULT_8x8[9]), .A2(n38), .B1(MULT_INPUT[9]), .B2(n39), 
     .X(n63));
  SEH_AOI22_3 U54 (.A1(MULT_8x8[6]), .A2(n38), .B1(MULT_INPUT[6]), .B2(n39), 
     .X(n58));
  SEH_OAI211_3 U21 (.A1(n41), .A2(n78), .B1(n40), .B2(n48), .X(ADDER_B_MUX[11]));
  SEH_OAI211_3 U19 (.A1(n42), .A2(n76), .B1(n43), .B2(n63), .X(ADDER_B_MUX[9]));
  SEH_OAI211_3 U18 (.A1(n41), .A2(n74), .B1(n40), .B2(n59), .X(ADDER_B_MUX[7]));
  SEH_OAI211_3 U20 (.A1(n41), .A2(n75), .B1(n40), .B2(n60), .X(ADDER_B_MUX[8]));
  SEH_AOI22_3 U44 (.A1(MULT_8x8[0]), .A2(n44), .B1(MULT_INPUT[0]), .B2(n45), 
     .X(n46));
  SEH_AOI22_3 U40 (.A1(MULT_8x8[14]), .A2(n44), .B1(MULT_INPUT[14]), .B2(n45), 
     .X(n51));
  SEH_BUF_3 U9 (.A(n65), .X(n42));
  SEH_BUF_3 U6 (.A(n64), .X(n40));
  SEH_OAI211_3 U13 (.A1(n41), .A2(n69), .B1(n40), .B2(n54), .X(ADDER_B_MUX[2]));
  SEH_OAI211_3 U12 (.A1(n42), .A2(n71), .B1(n43), .B2(n56), .X(ADDER_B_MUX[4]));
  SEH_OAI211_3 U22 (.A1(n42), .A2(n73), .B1(n43), .B2(n58), .X(ADDER_B_MUX[6]));
  SEH_OAI211_3 U11 (.A1(n41), .A2(n72), .B1(n40), .B2(n57), .X(ADDER_B_MUX[5]));
  SEH_OAI211_3 U16 (.A1(n41), .A2(n67), .B1(n40), .B2(n46), .X(ADDER_B_MUX[0]));
  SEH_INV_S_3 U47 (.A(MULT_16x16[5]), .X(n72));
  SEH_INV_S_3 U51 (.A(MULT_16x16[3]), .X(n70));
  SEH_OAI211_3 U10 (.A1(n42), .A2(n68), .B1(n43), .B2(n53), .X(ADDER_B_MUX[1]));
  SEH_AOI22_3 U48 (.A1(MULT_8x8[5]), .A2(n38), .B1(MULT_INPUT[5]), .B2(n39), 
     .X(n57));
  SEH_INV_S_3 U49 (.A(MULT_16x16[2]), .X(n69));
  SEH_INV_S_3 U45 (.A(MULT_16x16[4]), .X(n71));
  SEH_INV_S_3 U41 (.A(MULT_16x16[1]), .X(n68));
  SEH_NR2_S_2P5 U60 (.A1(SELM[0]), .A2(SELM[1]), .X(n61));
  SEH_ND2_S_2P5 U59 (.A1(SELM[1]), .A2(n66), .X(n65));
  SEH_ND3_3 U58 (.A1(SELM[1]), .A2(SELM[0]), .A3(SIGNEXTIN), .X(n64));
  SEH_INV_S_3 U57 (.A(SELM[0]), .X(n66));
  SEH_INV_S_3 U37 (.A(MULT_16x16[10]), .X(n77));
  SEH_INV_S_3 U33 (.A(MULT_16x16[8]), .X(n75));
  SEH_BUF_3 U4 (.A(n62), .X(n38));
  SEH_BUF_3 U23 (.A(n62), .X(n44));
  SEH_BUF_3 U24 (.A(n61), .X(n45));
  SEH_INV_S_3 U35 (.A(MULT_16x16[12]), .X(n79));
  SEH_NR2_S_2P5 U61 (.A1(n66), .A2(SELM[1]), .X(n62));
  SEH_BUF_3 U5 (.A(n61), .X(n39));
endmodule

// Entity:CARRY_IN_MUX_0 Model:CARRY_IN_MUX_0 Library:magma_checknetlist_lib
module CARRY_IN_MUX_0 (CICAS, CI, CARRYMUX_SEL, ADDER_CI);
  input CICAS, CI;
  output ADDER_CI;
  input [1:0] CARRYMUX_SEL;
  wire n7, n8;
  SEH_AOI21_3 U4 (.A1(CARRYMUX_SEL[1]), .A2(CICAS), .B(CARRYMUX_SEL[0]), .X(n8));
  SEH_INV_S_3 U3 (.A(CI), .X(n7));
  SEH_AOI31_3 U5 (.A1(CARRYMUX_SEL[1]), .A2(CARRYMUX_SEL[0]), .A3(n7), .B(n8), 
     .X(ADDER_CI));
endmodule

// Entity:LOAD_ADD_MUX_0 Model:LOAD_ADD_MUX_0 Library:magma_checknetlist_lib
module LOAD_ADD_MUX_0 (ADDER, LOAD_DATA, LOAD, OUT);
  input LOAD;
  input [15:0] ADDER;
  input [15:0] LOAD_DATA;
  output [15:0] OUT;
  wire n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, 
     n17, n22, n23, n24, n25, LOAD_1;
  SEH_INV_S_3 U24 (.A(n16), .X(OUT[4]));
  SEH_AOI22_3 U35 (.A1(ADDER[1]), .A2(n1), .B1(LOAD_DATA[1]), .B2(LOAD), .X(n13));
  SEH_AOI22_3 U17 (.A1(ADDER[14]), .A2(n2), .B1(LOAD_DATA[14]), .B2(LOAD), 
     .X(n11));
  SEH_INV_S_3 U32 (.A(n15), .X(OUT[3]));
  SEH_INV_S_3 U34 (.A(n13), .X(OUT[1]));
  SEH_INV_S_3 U36 (.A(n6), .X(OUT[0]));
  SEH_INV_S_3 U30 (.A(n14), .X(OUT[2]));
  SEH_INV_S_3 U6 (.A(n22), .X(OUT[6]));
  SEH_INV_S_3 U12 (.A(n7), .X(OUT[10]));
  SEH_INV_S_3 U16 (.A(n11), .X(OUT[14]));
  SEH_INV_S_3 U22 (.A(n10), .X(OUT[13]));
  SEH_AOI22_3 U23 (.A1(ADDER[13]), .A2(n1), .B1(LOAD_DATA[13]), .B2(LOAD), 
     .X(n10));
  SEH_INV_S_3 U28 (.A(n25), .X(OUT[9]));
  SEH_AOI22_3 U29 (.A1(ADDER[9]), .A2(n2), .B1(LOAD_DATA[9]), .B2(n5), .X(n25));
  SEH_AOI22_3 U25 (.A1(ADDER[4]), .A2(n2), .B1(LOAD_DATA[4]), .B2(n4), .X(n16));
  SEH_AOI22_3 U31 (.A1(ADDER[2]), .A2(n1), .B1(LOAD_DATA[2]), .B2(n4), .X(n14));
  SEH_INV_S_3 U14 (.A(n8), .X(OUT[11]));
  SEH_AOI22_3 U27 (.A1(ADDER[12]), .A2(n1), .B1(LOAD_DATA[12]), .B2(LOAD), 
     .X(n9));
  SEH_INV_S_3 U18 (.A(n12), .X(OUT[15]));
  SEH_INV_S_3 U3 (.A(n5), .X(n3));
  SEH_INV_S_3 U2 (.A(LOAD_1), .X(n2));
  SEH_BUF_3 U5 (.A(LOAD_1), .X(n5));
  SEH_AOI22_3 U21 (.A1(ADDER[5]), .A2(n2), .B1(LOAD_DATA[5]), .B2(n5), .X(n17));
  SEH_INV_S_3 U10 (.A(n24), .X(OUT[8]));
  SEH_INV_S_3 U1 (.A(n5), .X(n1));
  SEH_AOI22_3 U11 (.A1(ADDER[8]), .A2(n1), .B1(LOAD_DATA[8]), .B2(n5), .X(n24));
  SEH_INV_S_3 U26 (.A(n9), .X(OUT[12]));
  SEH_INV_S_3 U8 (.A(n23), .X(OUT[7]));
  SEH_BUF_3 BW1_BUF4291 (.A(LOAD), .X(LOAD_1));
  SEH_INV_S_3 U20 (.A(n17), .X(OUT[5]));
  SEH_INV_S_3 U4 (.A(n3), .X(n4));
  SEH_AOI22_3 U9 (.A1(ADDER[7]), .A2(n2), .B1(LOAD_DATA[7]), .B2(LOAD_1), 
     .X(n23));
  SEH_AOI22_3 U19 (.A1(ADDER[15]), .A2(n1), .B1(LOAD_DATA[15]), .B2(n4), .X(n12));
  SEH_AOI22_3 U13 (.A1(ADDER[10]), .A2(n2), .B1(LOAD_DATA[10]), .B2(n4), .X(n7));
  SEH_AOI22_3 U15 (.A1(ADDER[11]), .A2(n1), .B1(LOAD_DATA[11]), .B2(n5), .X(n8));
  SEH_AOI22_3 U37 (.A1(ADDER[0]), .A2(n2), .B1(LOAD_DATA[0]), .B2(n4), .X(n6));
  SEH_AOI22_3 U33 (.A1(ADDER[3]), .A2(n2), .B1(LOAD_DATA[3]), .B2(n5), .X(n15));
  SEH_AOI22_3 U7 (.A1(ADDER[6]), .A2(n1), .B1(LOAD_DATA[6]), .B2(n4), .X(n22));
endmodule

// Entity:OUT_MUX_4_0 Model:OUT_MUX_4_0 Library:magma_checknetlist_lib
module OUT_MUX_4_0 (ADDER_COMBINATORIAL, ACCUM_REGISTER, MULT_8x8, MULT_16x16, 
     SELM, OUT);
  input [15:0] ADDER_COMBINATORIAL;
  input [15:0] ACCUM_REGISTER;
  input [15:0] MULT_8x8;
  input [15:0] MULT_16x16;
  input [1:0] SELM;
  output [15:0] OUT;
  wire n102, n103, n104, n105, n106, n107, n108, n109, n110, n4, n5, n6, n7, 
     n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, 
     n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, 
     n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, 
     n99, n100, n101;
  SEH_INV_S_24 U7 (.A(n5), .X(OUT[10]));
  SEH_AN2_S_3 U13 (.A1(n100), .A2(n99), .X(n4));
  SEH_AOI22_3 U46 (.A1(MULT_16x16[1]), .A2(n48), .B1(MULT_8x8[1]), .B2(n52), 
     .X(n83));
  SEH_OR2_2P5 U23 (.A1(n101), .A2(SELM[1]), .X(n44));
  SEH_AOI22_3 U40 (.A1(MULT_16x16[4]), .A2(n48), .B1(MULT_8x8[4]), .B2(n52), 
     .X(n89));
  SEH_INV_S_24 U54 (.A(n107), .X(OUT[3]));
  SEH_INV_S_24 U58 (.A(n109), .X(OUT[1]));
  SEH_INV_S_24 U60 (.A(n110), .X(OUT[0]));
  SEH_INV_S_24 U56 (.A(n108), .X(OUT[2]));
  SEH_INV_S_24 U48 (.A(n102), .X(OUT[8]));
  SEH_AN2_S_3 U15 (.A1(n74), .A2(n73), .X(n6));
  SEH_INV_S_24 U50 (.A(n104), .X(OUT[6]));
  SEH_INV_S_3 U8 (.A(n6), .X(OUT[11]));
  SEH_INV_S_3 U11 (.A(n39), .X(OUT[14]));
  SEH_AOI22_3 U34 (.A1(MULT_16x16[13]), .A2(n48), .B1(MULT_8x8[13]), .B2(n52), 
     .X(n77));
  SEH_AN2_S_3 U19 (.A1(n82), .A2(n81), .X(n40));
  SEH_INV_S_24 U12 (.A(n40), .X(OUT[15]));
  SEH_AN2_S_3 U53 (.A1(n88), .A2(n87), .X(n107));
  SEH_AOI22_3 U47 (.A1(MULT_16x16[2]), .A2(n47), .B1(MULT_8x8[2]), .B2(n51), 
     .X(n85));
  SEH_AOI22_3 U41 (.A1(MULT_16x16[5]), .A2(n47), .B1(MULT_8x8[5]), .B2(n51), 
     .X(n91));
  SEH_AOI22_3 U45 (.A1(MULT_16x16[0]), .A2(n47), .B1(MULT_8x8[0]), .B2(n51), 
     .X(n69));
  SEH_AOI22_3 U39 (.A1(MULT_16x16[3]), .A2(n47), .B1(MULT_8x8[3]), .B2(n51), 
     .X(n87));
  SEH_AOI22_3 U69 (.A1(ACCUM_REGISTER[15]), .A2(n50), 
     .B1(ADDER_COMBINATORIAL[15]), .B2(n46), .X(n82));
  SEH_AOI22_3 U32 (.A1(MULT_16x16[15]), .A2(n48), .B1(MULT_8x8[15]), .B2(n52), 
     .X(n81));
  SEH_AOI22_3 U38 (.A1(MULT_16x16[9]), .A2(n48), .B1(MULT_8x8[9]), .B2(n52), 
     .X(n99));
  SEH_INV_S_24 U6 (.A(n4), .X(OUT[9]));
  SEH_INV_S_24 U9 (.A(n7), .X(OUT[12]));
  SEH_AN2_S_3 U17 (.A1(n78), .A2(n77), .X(n38));
  SEH_INV_S_24 U10 (.A(n38), .X(OUT[13]));
  SEH_AOI22_3 U66 (.A1(ACCUM_REGISTER[12]), .A2(n49), 
     .B1(ADDER_COMBINATORIAL[12]), .B2(n45), .X(n76));
  SEH_AN2_S_3 U55 (.A1(n86), .A2(n85), .X(n108));
  SEH_AOI22_3 U77 (.A1(ACCUM_REGISTER[7]), .A2(n50), .B1(ADDER_COMBINATORIAL[7]), 
     .B2(n46), .X(n96));
  SEH_AOI22_3 U75 (.A1(ACCUM_REGISTER[5]), .A2(n50), .B1(ADDER_COMBINATORIAL[5]), 
     .B2(n46), .X(n92));
  SEH_AOI22_3 U63 (.A1(ACCUM_REGISTER[9]), .A2(n50), .B1(ADDER_COMBINATORIAL[9]), 
     .B2(n46), .X(n100));
  SEH_AOI22_3 U65 (.A1(ACCUM_REGISTER[11]), .A2(n50), 
     .B1(ADDER_COMBINATORIAL[11]), .B2(n46), .X(n74));
  SEH_AOI22_3 U67 (.A1(ACCUM_REGISTER[13]), .A2(n50), 
     .B1(ADDER_COMBINATORIAL[13]), .B2(n46), .X(n78));
  SEH_INV_S_3 U29 (.A(n44), .X(n50));
  SEH_AN2_S_3 U2 (.A1(n92), .A2(n91), .X(n105));
  SEH_INV_S_3 U25 (.A(n43), .X(n46));
  SEH_INV_S_3 U24 (.A(n43), .X(n45));
  SEH_INV_S_3 U28 (.A(n44), .X(n49));
  SEH_AOI22_3 U33 (.A1(MULT_16x16[14]), .A2(n47), .B1(MULT_8x8[14]), .B2(n51), 
     .X(n79));
  SEH_AOI22_3 U64 (.A1(ACCUM_REGISTER[10]), .A2(n49), 
     .B1(ADDER_COMBINATORIAL[10]), .B2(n45), .X(n72));
  SEH_AOI22_3 U68 (.A1(ACCUM_REGISTER[14]), .A2(n49), 
     .B1(ADDER_COMBINATORIAL[14]), .B2(n45), .X(n80));
  SEH_AOI22_3 U74 (.A1(ACCUM_REGISTER[4]), .A2(n49), .B1(ADDER_COMBINATORIAL[4]), 
     .B2(n45), .X(n90));
  SEH_AOI22_3 U62 (.A1(ACCUM_REGISTER[8]), .A2(n49), .B1(ADDER_COMBINATORIAL[8]), 
     .B2(n45), .X(n98));
  SEH_AOI22_3 U76 (.A1(ACCUM_REGISTER[6]), .A2(n49), .B1(ADDER_COMBINATORIAL[6]), 
     .B2(n45), .X(n94));
  SEH_AOI22_3 U71 (.A1(ACCUM_REGISTER[1]), .A2(n50), .B1(ADDER_COMBINATORIAL[1]), 
     .B2(n46), .X(n84));
  SEH_AOI22_3 U72 (.A1(ACCUM_REGISTER[2]), .A2(n49), .B1(ADDER_COMBINATORIAL[2]), 
     .B2(n45), .X(n86));
  SEH_AOI22_3 U73 (.A1(ACCUM_REGISTER[3]), .A2(n50), .B1(ADDER_COMBINATORIAL[3]), 
     .B2(n46), .X(n88));
  SEH_AOI22_3 U70 (.A1(ACCUM_REGISTER[0]), .A2(n49), .B1(ADDER_COMBINATORIAL[0]), 
     .B2(n45), .X(n70));
  SEH_AN2_S_3 U57 (.A1(n84), .A2(n83), .X(n109));
  SEH_AN2_S_3 U59 (.A1(n70), .A2(n69), .X(n110));
  SEH_AN2_S_3 U14 (.A1(n72), .A2(n71), .X(n5));
  SEH_AOI22_3 U37 (.A1(MULT_16x16[10]), .A2(n47), .B1(MULT_8x8[10]), .B2(n51), 
     .X(n71));
  SEH_AOI22_3 U43 (.A1(MULT_16x16[7]), .A2(n47), .B1(MULT_8x8[7]), .B2(n51), 
     .X(n95));
  SEH_AN2_S_3 U1 (.A1(n90), .A2(n89), .X(n106));
  SEH_AN2_S_3 U3 (.A1(n94), .A2(n93), .X(n104));
  SEH_INV_S_3 U27 (.A(n42), .X(n48));
  SEH_AOI22_3 U36 (.A1(MULT_16x16[11]), .A2(n48), .B1(MULT_8x8[11]), .B2(n52), 
     .X(n73));
  SEH_AN2_S_3 U5 (.A1(n98), .A2(n97), .X(n102));
  SEH_AN2_S_3 U18 (.A1(n80), .A2(n79), .X(n39));
  SEH_AN2_S_3 U16 (.A1(n76), .A2(n75), .X(n7));
  SEH_AOI22_3 U35 (.A1(MULT_16x16[12]), .A2(n47), .B1(MULT_8x8[12]), .B2(n51), 
     .X(n75));
  SEH_AOI22_3 U44 (.A1(MULT_16x16[8]), .A2(n48), .B1(MULT_8x8[8]), .B2(n52), 
     .X(n97));
  SEH_INV_S_24 U51 (.A(n105), .X(OUT[5]));
  SEH_INV_S_24 U49 (.A(n103), .X(OUT[7]));
  SEH_INV_S_24 U52 (.A(n106), .X(OUT[4]));
  SEH_INV_S_3 U61 (.A(SELM[0]), .X(n101));
  SEH_OR2_2P5 U22 (.A1(SELM[0]), .A2(SELM[1]), .X(n43));
  SEH_ND2_S_2P5 U20 (.A1(SELM[1]), .A2(n101), .X(n41));
  SEH_INV_S_3 U31 (.A(n41), .X(n52));
  SEH_INV_S_3 U30 (.A(n41), .X(n51));
  SEH_INV_S_3 U26 (.A(n42), .X(n47));
  SEH_ND2_S_2P5 U21 (.A1(SELM[1]), .A2(SELM[0]), .X(n42));
  SEH_AOI22_3 U42 (.A1(MULT_16x16[6]), .A2(n48), .B1(MULT_8x8[6]), .B2(n52), 
     .X(n93));
  SEH_AN2_S_3 U4 (.A1(n96), .A2(n95), .X(n103));
endmodule

// Entity:MULT_ACCUM_1 Model:MULT_ACCUM_1 Library:magma_checknetlist_lib
module MULT_ACCUM_1 (DIRECT_INPUT, MULT_INPUT, MULT_8x8, MULT_16x16, ADDSUB, 
     CLK, CICAS, CI, SIGNEXTIN, SIGNEXTOUT, LDA, RST, COCAS, CO, O, OUTMUX_SEL, 
     CARRYMUX_SEL, ADDER_A_IN_SEL, ADDER_B_IN_SEL, ENA_BAR, CLK_2, CLK_5, CLK_7);
  input ADDSUB, CLK, CICAS, CI, SIGNEXTIN, LDA, RST, ADDER_A_IN_SEL, ENA_BAR, 
     CLK_2, CLK_5, CLK_7;
  output SIGNEXTOUT, COCAS, CO;
  input [15:0] DIRECT_INPUT;
  input [15:0] MULT_INPUT;
  input [15:0] MULT_8x8;
  input [15:0] MULT_16x16;
  input [1:0] OUTMUX_SEL;
  input [1:0] CARRYMUX_SEL;
  input [1:0] ADDER_B_IN_SEL;
  output [15:0] O;
  wire [14:0] ADDER_B_INPUT_MUX;
  wire [15:0] ADDER_LOAD_MUX;
  wire [15:0] ACCUMULATOR_REG;
  wire [15:0] ADDER_A_INPUT_MUX;
  wire [15:0] ADDER_SUM;
  wire ADDER_CI, n3, ADDER_B_IN_SEL_1_1, OUTMUX_SEL_0_1;
  ACCUM_ADDER_1 ACCUM_ADDER_TOP (.A(ADDER_A_INPUT_MUX), .B({SIGNEXTOUT, 
     ADDER_B_INPUT_MUX[14], ADDER_B_INPUT_MUX[13], ADDER_B_INPUT_MUX[12], 
     ADDER_B_INPUT_MUX[11], ADDER_B_INPUT_MUX[10], ADDER_B_INPUT_MUX[9], 
     ADDER_B_INPUT_MUX[8], ADDER_B_INPUT_MUX[7], ADDER_B_INPUT_MUX[6], 
     ADDER_B_INPUT_MUX[5], ADDER_B_INPUT_MUX[4], ADDER_B_INPUT_MUX[3], 
     ADDER_B_INPUT_MUX[2], ADDER_B_INPUT_MUX[1], ADDER_B_INPUT_MUX[0]}), 
     .ADDSUB(ADDSUB), .CI(ADDER_CI), .SUM(ADDER_SUM), .COCAS(COCAS), .CO(CO));
  CARRY_IN_MUX_1 CARRY_IN_MUX_TOP (.CICAS(CICAS), .CI(CI), .CARRYMUX_SEL({
     CARRYMUX_SEL[1], CARRYMUX_SEL[0]}), .ADDER_CI(ADDER_CI));
  ADDER_A_IN_MUX_1 ADDER_A_IN_MUX_TOP (.ACCUMULATOR_REG(ACCUMULATOR_REG), 
     .DIRECT_INPUT({DIRECT_INPUT[15], DIRECT_INPUT[14], DIRECT_INPUT[13], 
     DIRECT_INPUT[12], DIRECT_INPUT[11], DIRECT_INPUT[10], DIRECT_INPUT[9], 
     DIRECT_INPUT[8], DIRECT_INPUT[7], DIRECT_INPUT[6], DIRECT_INPUT[5], 
     DIRECT_INPUT[4], DIRECT_INPUT[3], DIRECT_INPUT[2], DIRECT_INPUT[1], 
     DIRECT_INPUT[0]}), .SELM(ADDER_A_IN_SEL), .ADDER_A_MUX(ADDER_A_INPUT_MUX));
  OUT_MUX_4_1 OUTPUT_MULTIPLEXER_TOP (.ADDER_COMBINATORIAL(ADDER_LOAD_MUX), 
     .ACCUM_REGISTER(ACCUMULATOR_REG), .MULT_8x8({MULT_8x8[15], MULT_8x8[14], 
     MULT_8x8[13], MULT_8x8[12], MULT_8x8[11], MULT_8x8[10], MULT_8x8[9], 
     MULT_8x8[8], MULT_8x8[7], MULT_8x8[6], MULT_8x8[5], MULT_8x8[4], 
     MULT_8x8[3], MULT_8x8[2], MULT_8x8[1], MULT_8x8[0]}), .MULT_16x16({
     MULT_16x16[15], MULT_16x16[14], MULT_16x16[13], MULT_16x16[12], 
     MULT_16x16[11], MULT_16x16[10], MULT_16x16[9], MULT_16x16[8], 
     MULT_16x16[7], MULT_16x16[6], MULT_16x16[5], MULT_16x16[4], MULT_16x16[3], 
     MULT_16x16[2], MULT_16x16[1], MULT_16x16[0]}), .SELM({OUTMUX_SEL[1], 
     OUTMUX_SEL_0_1}), .OUT({O[15], O[14], O[13], O[12], O[11], O[10], O[9], O[8], 
     O[7], O[6], O[5], O[4], O[3], O[2], O[1], O[0]}));
  LOAD_ADD_MUX_1 LOAD_ADD_TOP (.ADDER(ADDER_SUM), .LOAD_DATA({DIRECT_INPUT[15], 
     DIRECT_INPUT[14], DIRECT_INPUT[13], DIRECT_INPUT[12], DIRECT_INPUT[11], 
     DIRECT_INPUT[10], DIRECT_INPUT[9], DIRECT_INPUT[8], DIRECT_INPUT[7], 
     DIRECT_INPUT[6], DIRECT_INPUT[5], DIRECT_INPUT[4], DIRECT_INPUT[3], 
     DIRECT_INPUT[2], DIRECT_INPUT[1], DIRECT_INPUT[0]}), .LOAD(LDA), 
     .OUT(ADDER_LOAD_MUX));
  ACCUM_REG_1 ACCUM_REG_TOP (.D(ADDER_LOAD_MUX), .Q(ACCUMULATOR_REG), .ENA(n3), 
     .CLK(CLK), .RST(RST), .CLK_2(CLK_2), .CLK_5(CLK_5), .CLK_7(CLK_7));
  ADDER_B_IN_MUX_1 ADDER_B_IN_MUX_TOP (.MULT_INPUT({MULT_INPUT[15], 
     MULT_INPUT[14], MULT_INPUT[13], MULT_INPUT[12], MULT_INPUT[11], 
     MULT_INPUT[10], MULT_INPUT[9], MULT_INPUT[8], MULT_INPUT[7], MULT_INPUT[6], 
     MULT_INPUT[5], MULT_INPUT[4], MULT_INPUT[3], MULT_INPUT[2], MULT_INPUT[1], 
     MULT_INPUT[0]}), .MULT_8x8({MULT_8x8[15], MULT_8x8[14], MULT_8x8[13], 
     MULT_8x8[12], MULT_8x8[11], MULT_8x8[10], MULT_8x8[9], MULT_8x8[8], 
     MULT_8x8[7], MULT_8x8[6], MULT_8x8[5], MULT_8x8[4], MULT_8x8[3], 
     MULT_8x8[2], MULT_8x8[1], MULT_8x8[0]}), .MULT_16x16({MULT_16x16[15], 
     MULT_16x16[14], MULT_16x16[13], MULT_16x16[12], MULT_16x16[11], 
     MULT_16x16[10], MULT_16x16[9], MULT_16x16[8], MULT_16x16[7], MULT_16x16[6], 
     MULT_16x16[5], MULT_16x16[4], MULT_16x16[3], MULT_16x16[2], MULT_16x16[1], 
     MULT_16x16[0]}), .SIGNEXTIN(SIGNEXTIN), .SELM({ADDER_B_IN_SEL_1_1, 
     ADDER_B_IN_SEL[0]}), .ADDER_B_MUX({SIGNEXTOUT, ADDER_B_INPUT_MUX[14], 
     ADDER_B_INPUT_MUX[13], ADDER_B_INPUT_MUX[12], ADDER_B_INPUT_MUX[11], 
     ADDER_B_INPUT_MUX[10], ADDER_B_INPUT_MUX[9], ADDER_B_INPUT_MUX[8], 
     ADDER_B_INPUT_MUX[7], ADDER_B_INPUT_MUX[6], ADDER_B_INPUT_MUX[5], 
     ADDER_B_INPUT_MUX[4], ADDER_B_INPUT_MUX[3], ADDER_B_INPUT_MUX[2], 
     ADDER_B_INPUT_MUX[1], ADDER_B_INPUT_MUX[0]}));
  SEH_BUF_3 BW1_BUF283 (.A(ADDER_B_IN_SEL[1]), .X(ADDER_B_IN_SEL_1_1));
  SEH_BUF_3 BW1_BUF358 (.A(OUTMUX_SEL[0]), .X(OUTMUX_SEL_0_1));
  SEH_INV_S_3 U1 (.A(ENA_BAR), .X(n3));
endmodule

// Entity:ACCUM_ADDER_1 Model:ACCUM_ADDER_1 Library:magma_checknetlist_lib
module ACCUM_ADDER_1 (A, B, ADDSUB, CI, SUM, COCAS, CO);
  input ADDSUB, CI;
  output COCAS, CO;
  input [15:0] A;
  input [15:0] B;
  output [15:0] SUM;
  wire [15:0] CLA16_SUM;
  wire [15:0] CLA16_A;
  wire n7, n8, CLA16_g, CLA16_p, n3, n4, n5, n6, ADDSUB_1, ADDSUB_2;
  fcla16_1 CLA16_ADDER (.Sum(CLA16_SUM), .G(CLA16_g), .P(CLA16_p), .A(CLA16_A), 
     .B({B[15], B[14], B[13], B[12], B[11], B[10], B[9], B[8], B[7], B[6], B[5], 
     B[4], B[3], B[2], B[1], B[0]}), .Cin(CI));
  SEH_INV_S_24 U4 (.A(n7), .X(COCAS));
  SEH_EN2_G_3 U2 (.A1(COCAS), .A2(ADDSUB_1), .X(n8));
  SEH_INV_S_24 U3 (.A(n8), .X(CO));
  SEH_BUF_3 BW1_BUF2494 (.A(ADDSUB), .X(ADDSUB_1));
  SEH_EO2_G_3 U14 (.A1(CLA16_SUM[3]), .A2(n4), .X(SUM[3]));
  SEH_EO2_G_3 U16 (.A1(CLA16_SUM[11]), .A2(n6), .X(SUM[11]));
  SEH_EO2_G_3 U19 (.A1(CLA16_SUM[14]), .A2(n5), .X(SUM[14]));
  SEH_EO2_G_3 U10 (.A1(CLA16_SUM[6]), .A2(n4), .X(SUM[6]));
  SEH_EO2_G_3 U12 (.A1(CLA16_SUM[8]), .A2(n4), .X(SUM[8]));
  SEH_EO2_G_3 U29 (.A1(A[2]), .A2(ADDSUB_2), .X(CLA16_A[2]));
  SEH_EO2_G_3 U17 (.A1(CLA16_SUM[12]), .A2(ADDSUB_1), .X(SUM[12]));
  SEH_EO2_G_3 U31 (.A1(A[6]), .A2(n6), .X(CLA16_A[6]));
  SEH_EO2_G_3 U20 (.A1(CLA16_SUM[4]), .A2(n4), .X(SUM[4]));
  SEH_BUF_3 U6 (.A(n5), .X(n4));
  SEH_EO2_G_3 U18 (.A1(CLA16_SUM[13]), .A2(n6), .X(SUM[13]));
  SEH_EO2_G_3 U11 (.A1(CLA16_SUM[10]), .A2(n5), .X(SUM[10]));
  SEH_EO2_G_3 U35 (.A1(A[9]), .A2(n5), .X(CLA16_A[9]));
  SEH_AOI21_3 U1 (.A1(CLA16_p), .A2(CI), .B(CLA16_g), .X(n7));
  SEH_EO2_G_3 U36 (.A1(A[11]), .A2(n3), .X(CLA16_A[11]));
  SEH_EO2_G_3 U39 (.A1(A[13]), .A2(n3), .X(CLA16_A[13]));
  SEH_EO2_G_3 U25 (.A1(A[0]), .A2(n3), .X(CLA16_A[0]));
  SEH_BUF_3 BW2_BUF2494 (.A(ADDSUB), .X(ADDSUB_2));
  SEH_EO2_G_3 U40 (.A1(A[15]), .A2(n3), .X(CLA16_A[15]));
  SEH_EO2_G_3 U38 (.A1(A[14]), .A2(n3), .X(CLA16_A[14]));
  SEH_BUF_3 U24 (.A(ADDSUB_1), .X(n6));
  SEH_BUF_3 U23 (.A(n6), .X(n3));
  SEH_EO2_G_3 U33 (.A1(A[8]), .A2(n5), .X(CLA16_A[8]));
  SEH_EO2_G_3 U8 (.A1(CLA16_SUM[2]), .A2(n4), .X(SUM[2]));
  SEH_EO2_G_3 U15 (.A1(CLA16_SUM[7]), .A2(n4), .X(SUM[7]));
  SEH_EO2_G_3 U30 (.A1(A[3]), .A2(n5), .X(CLA16_A[3]));
  SEH_EO2_3 U7 (.A1(CLA16_SUM[15]), .A2(n6), .X(SUM[15]));
  SEH_EO2_G_3 U9 (.A1(CLA16_SUM[5]), .A2(n4), .X(SUM[5]));
  SEH_EO2_G_3 U13 (.A1(CLA16_SUM[9]), .A2(n5), .X(SUM[9]));
  SEH_EO2_G_3 U27 (.A1(A[4]), .A2(n6), .X(CLA16_A[4]));
  SEH_BUF_3 U5 (.A(ADDSUB_1), .X(n5));
  SEH_EO2_G_3 U22 (.A1(CLA16_SUM[0]), .A2(n6), .X(SUM[0]));
  SEH_EO2_G_3 U28 (.A1(A[5]), .A2(ADDSUB), .X(CLA16_A[5]));
  SEH_EO2_G_3 U26 (.A1(A[1]), .A2(n3), .X(CLA16_A[1]));
  SEH_EO2_G_3 U32 (.A1(A[7]), .A2(ADDSUB_2), .X(CLA16_A[7]));
  SEH_EO2_G_3 U21 (.A1(CLA16_SUM[1]), .A2(n4), .X(SUM[1]));
  SEH_EO2_G_3 U37 (.A1(A[12]), .A2(n3), .X(CLA16_A[12]));
  SEH_EO2_G_3 U34 (.A1(A[10]), .A2(n3), .X(CLA16_A[10]));
endmodule

// Entity:fcla16_1 Model:fcla16_1 Library:magma_checknetlist_lib
module fcla16_1 (Sum, G, P, A, B, Cin);
  input Cin;
  output G, P;
  input [15:0] A;
  input [15:0] B;
  output [15:0] Sum;
  wire [15:0] gtemp1_b;
  wire [15:0] ptemp1;
  wire [3:0] gouta;
  wire [3:0] pouta;
  wire [3:1] ctemp2;
  wire \ctemp1[1] , \ctemp1[2] , \ctemp1[3] , \ctemp1[5] , \ctemp1[6] , 
     \ctemp1[7] , \ctemp1[9] , \ctemp1[10] , \ctemp1[11] , \ctemp1[13] , 
     \ctemp1[14] , \ctemp1[15] , SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2, 
     SYNOPSYS_UNCONNECTED_3, SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5;
  mpfa_23 r09 (.g_b(gtemp1_b[8]), .p(ptemp1[8]), .Sum(Sum[8]), .A(A[8]), 
     .B(B[8]), .Cin(ctemp2[2]));
  mpfa_29 r03 (.g_b(gtemp1_b[2]), .p(ptemp1[2]), .Sum(Sum[2]), .A(A[2]), 
     .B(B[2]), .Cin(\ctemp1[2] ));
  mpfa_16 r16 (.g_b(gtemp1_b[15]), .p(ptemp1[15]), .Sum(Sum[15]), .A(A[15]), 
     .B(B[15]), .Cin(\ctemp1[15] ));
  mclg4_5 b3 (.cout({\ctemp1[11] , \ctemp1[10] , \ctemp1[9] , 
     SYNOPSYS_UNCONNECTED_3}), .g_o(gouta[2]), .p_o(pouta[2]), .g_b({gtemp1_b[11], 
     gtemp1_b[10], gtemp1_b[9], gtemp1_b[8]}), .p({ptemp1[11], ptemp1[10], 
     ptemp1[9], ptemp1[8]}), .cin(ctemp2[2]));
  mpfa_26 r06 (.g_b(gtemp1_b[5]), .p(ptemp1[5]), .Sum(Sum[5]), .A(A[5]), 
     .B(B[5]), .Cin(\ctemp1[5] ));
  mclg16_1 b5 (.cout({ctemp2[3], ctemp2[2], ctemp2[1], SYNOPSYS_UNCONNECTED_5}), 
     .g_o(G), .p_o(P), .g(gouta), .p(pouta), .cin(Cin));
  mclg4_7 b1 (.cout({\ctemp1[3] , \ctemp1[2] , \ctemp1[1] , 
     SYNOPSYS_UNCONNECTED_1}), .g_o(gouta[0]), .p_o(pouta[0]), .g_b({gtemp1_b[3], 
     gtemp1_b[2], gtemp1_b[1], gtemp1_b[0]}), .p({ptemp1[3], ptemp1[2], ptemp1[1], 
     ptemp1[0]}), .cin(Cin));
  mpfa_18 r14 (.g_b(gtemp1_b[13]), .p(ptemp1[13]), .Sum(Sum[13]), .A(A[13]), 
     .B(B[13]), .Cin(\ctemp1[13] ));
  mpfa_21 r11 (.g_b(gtemp1_b[10]), .p(ptemp1[10]), .Sum(Sum[10]), .A(A[10]), 
     .B(B[10]), .Cin(\ctemp1[10] ));
  mpfa_24 r08 (.g_b(gtemp1_b[7]), .p(ptemp1[7]), .Sum(Sum[7]), .A(A[7]), 
     .B(B[7]), .Cin(\ctemp1[7] ));
  mpfa_31 r01 (.g_b(gtemp1_b[0]), .p(ptemp1[0]), .Sum(Sum[0]), .A(A[0]), 
     .B(B[0]), .Cin(Cin));
  mpfa_27 r05 (.g_b(gtemp1_b[4]), .p(ptemp1[4]), .Sum(Sum[4]), .A(A[4]), 
     .B(B[4]), .Cin(ctemp2[1]));
  mpfa_28 r04 (.g_b(gtemp1_b[3]), .p(ptemp1[3]), .Sum(Sum[3]), .A(A[3]), 
     .B(B[3]), .Cin(\ctemp1[3] ));
  mpfa_20 r12 (.g_b(gtemp1_b[11]), .p(ptemp1[11]), .Sum(Sum[11]), .A(A[11]), 
     .B(B[11]), .Cin(\ctemp1[11] ));
  mpfa_25 r07 (.g_b(gtemp1_b[6]), .p(ptemp1[6]), .Sum(Sum[6]), .A(A[6]), 
     .B(B[6]), .Cin(\ctemp1[6] ));
  mclg4_6 b2 (.cout({\ctemp1[7] , \ctemp1[6] , \ctemp1[5] , 
     SYNOPSYS_UNCONNECTED_2}), .g_o(gouta[1]), .p_o(pouta[1]), .g_b({gtemp1_b[7], 
     gtemp1_b[6], gtemp1_b[5], gtemp1_b[4]}), .p({ptemp1[7], ptemp1[6], ptemp1[5], 
     ptemp1[4]}), .cin(ctemp2[1]));
  mpfa_22 r10 (.g_b(gtemp1_b[9]), .p(ptemp1[9]), .Sum(Sum[9]), .A(A[9]), 
     .B(B[9]), .Cin(\ctemp1[9] ));
  mpfa_30 r02 (.g_b(gtemp1_b[1]), .p(ptemp1[1]), .Sum(Sum[1]), .A(A[1]), 
     .B(B[1]), .Cin(\ctemp1[1] ));
  mpfa_19 r13 (.g_b(gtemp1_b[12]), .p(ptemp1[12]), .Sum(Sum[12]), .A(A[12]), 
     .B(B[12]), .Cin(ctemp2[3]));
  mpfa_17 r15 (.g_b(gtemp1_b[14]), .p(ptemp1[14]), .Sum(Sum[14]), .A(A[14]), 
     .B(B[14]), .Cin(\ctemp1[14] ));
  mclg4_4 b4 (.cout({\ctemp1[15] , \ctemp1[14] , \ctemp1[13] , 
     SYNOPSYS_UNCONNECTED_4}), .g_o(gouta[3]), .p_o(pouta[3]), .g_b({gtemp1_b[15], 
     gtemp1_b[14], gtemp1_b[13], gtemp1_b[12]}), .p({ptemp1[15], ptemp1[14], 
     ptemp1[13], ptemp1[12]}), .cin(ctemp2[3]));
endmodule

// Entity:mclg16_1 Model:mclg16_1 Library:magma_checknetlist_lib
module mclg16_1 (cout, g_o, p_o, g, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g;
  input [3:0] p;
  output [3:0] cout;
  wire n1, n4, n5;
  SEH_AO21_DG_3 U1 (.A1(cout[1]), .A2(p[1]), .B(g[1]), .X(cout[2]));
  SEH_AO21_DG_3 U5 (.A1(cin), .A2(p[0]), .B(g[0]), .X(cout[1]));
  SEH_INV_S_3 U6 (.A(n4), .X(g_o));
  SEH_OAOI211_3 U8 (.A1(g[2]), .A2(n5), .B(p[3]), .C(g[3]), .X(n4));
  SEH_AN4_S_3 U7 (.A1(p[0]), .A2(p[1]), .A3(p[2]), .A4(p[3]), .X(p_o));
  SEH_AO21_DG_3 U2 (.A1(cout[2]), .A2(p[2]), .B(g[2]), .X(cout[3]));
  SEH_INV_S_3 U3 (.A(n1), .X(n5));
  SEH_AOAI211_3 U4 (.A1(g[0]), .A2(p[1]), .B(g[1]), .C(p[2]), .X(n1));
endmodule

// Entity:mclg4_4 Model:mclg4_4 Library:magma_checknetlist_lib
module mclg4_4 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AO21B_4 U3 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AN4B_4 U5 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_AO21B_4 U1 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_AOAI211_3 U7 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_AO21B_4 U2 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_INV_S_3 U4 (.A(p[3]), .X(n6));
  SEH_AOAI211_3 U8 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_INV_S_3 U6 (.A(g_b[0]), .X(n7));
  SEH_INV_S_3 U9 (.A(g_b[1]), .X(n8));
endmodule

// Entity:mclg4_5 Model:mclg4_5 Library:magma_checknetlist_lib
module mclg4_5 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AO21B_4 U1 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_INV_S_3 U6 (.A(g_b[0]), .X(n7));
  SEH_INV_S_3 U9 (.A(g_b[1]), .X(n8));
  SEH_AOAI211_3 U7 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_AO21B_4 U2 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AO21B_4 U3 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_INV_S_3 U5 (.A(p[3]), .X(n6));
  SEH_AN4B_4 U4 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_AOAI211_3 U8 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
endmodule

// Entity:mclg4_6 Model:mclg4_6 Library:magma_checknetlist_lib
module mclg4_6 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AO21B_4 U2 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_AOAI211_3 U8 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_AOAI211_3 U7 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_AN4B_4 U4 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_AO21B_4 U1 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_AO21B_4 U3 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_INV_S_3 U9 (.A(g_b[1]), .X(n8));
  SEH_INV_S_3 U5 (.A(p[3]), .X(n6));
  SEH_INV_S_3 U6 (.A(g_b[0]), .X(n7));
endmodule

// Entity:mclg4_7 Model:mclg4_7 Library:magma_checknetlist_lib
module mclg4_7 (cout, g_o, p_o, g_b, p, cin);
  input cin;
  output g_o, p_o;
  input [3:0] g_b;
  input [3:0] p;
  output [3:0] cout;
  wire n5, n6, n7, n8;
  SEH_AO21B_4 U7 (.A1(cin), .A2(p[0]), .B(g_b[0]), .X(cout[1]));
  SEH_AN4B_4 U4 (.A(n6), .B1(p[0]), .B2(p[1]), .B3(p[2]), .X(p_o));
  SEH_INV_S_3 U6 (.A(g_b[0]), .X(n7));
  SEH_AOAI211_3 U8 (.A1(p[1]), .A2(n7), .B(n8), .C(p[2]), .X(n5));
  SEH_AO21B_4 U3 (.A1(cout[2]), .A2(p[2]), .B(g_b[2]), .X(cout[3]));
  SEH_AO21B_4 U2 (.A1(cout[1]), .A2(p[1]), .B(g_b[1]), .X(cout[2]));
  SEH_INV_S_3 U9 (.A(g_b[1]), .X(n8));
  SEH_AOAI211_3 U1 (.A1(g_b[2]), .A2(n5), .B(n6), .C(g_b[3]), .X(g_o));
  SEH_INV_S_3 U5 (.A(p[3]), .X(n6));
endmodule

// Entity:mpfa_16 Model:mpfa_16 Library:magma_checknetlist_lib
module mpfa_16 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U1 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_17 Model:mpfa_17 Library:magma_checknetlist_lib
module mpfa_17 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_18 Model:mpfa_18 Library:magma_checknetlist_lib
module mpfa_18 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_19 Model:mpfa_19 Library:magma_checknetlist_lib
module mpfa_19 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_20 Model:mpfa_20 Library:magma_checknetlist_lib
module mpfa_20 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_21 Model:mpfa_21 Library:magma_checknetlist_lib
module mpfa_21 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_22 Model:mpfa_22 Library:magma_checknetlist_lib
module mpfa_22 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_23 Model:mpfa_23 Library:magma_checknetlist_lib
module mpfa_23 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_24 Model:mpfa_24 Library:magma_checknetlist_lib
module mpfa_24 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_25 Model:mpfa_25 Library:magma_checknetlist_lib
module mpfa_25 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_26 Model:mpfa_26 Library:magma_checknetlist_lib
module mpfa_26 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_27 Model:mpfa_27 Library:magma_checknetlist_lib
module mpfa_27 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U2 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_28 Model:mpfa_28 Library:magma_checknetlist_lib
module mpfa_28 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
endmodule

// Entity:mpfa_29 Model:mpfa_29 Library:magma_checknetlist_lib
module mpfa_29 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(Cin), .A2(p), .X(Sum));
  SEH_EO2_G_3 U2 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
endmodule

// Entity:mpfa_30 Model:mpfa_30 Library:magma_checknetlist_lib
module mpfa_30 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U3 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U2 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:mpfa_31 Model:mpfa_31 Library:magma_checknetlist_lib
module mpfa_31 (g_b, p, Sum, A, B, Cin);
  input A, B, Cin;
  output g_b, p, Sum;
  SEH_EO2_G_3 U1 (.A1(A), .A2(B), .X(p));
  SEH_ND2_S_2P5 U2 (.A1(A), .A2(B), .X(g_b));
  SEH_EO2_G_3 U3 (.A1(Cin), .A2(p), .X(Sum));
endmodule

// Entity:ACCUM_REG_1 Model:ACCUM_REG_1 Library:magma_checknetlist_lib
module ACCUM_REG_1 (D, Q, ENA, CLK, RST, CLK_2, CLK_5, CLK_7);
  input ENA, CLK, RST, CLK_2, CLK_5, CLK_7;
  input [15:0] D;
  output [15:0] Q;
  wire n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, 
     n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, 
     n32, n33, n34, n35, n36, n37, n18_1, n18_2, CLK_1, RST_1;
  SEH_BUF_S_32 CLK_L0 (.A(CLK), .X(CLK_1));
  SEH_FDPRBQ_V2_3 Q_reg_14_ (.CK(CLK_2), .D(n33), .Q(Q[14]), .RD(n18_2));
  SEH_INV_S_3 U37 (.A(RST_1), .X(n18));
  SEH_DEL_L6_1 OPTHOLD_G_5 (.A(RST), .X(RST_1));
  SEH_INV_S_3 U6 (.A(n4), .X(n21));
  SEH_AOI22_3 U7 (.A1(D[2]), .A2(ENA), .B1(Q[2]), .B2(n35), .X(n4));
  SEH_FDPRBQ_V2_3 Q_reg_1_ (.CK(CLK_5), .D(n20), .Q(Q[1]), .RD(n18_1));
  SEH_AOI22_3 U5 (.A1(D[1]), .A2(ENA), .B1(Q[1]), .B2(n35), .X(n3));
  SEH_INV_S_3 U8 (.A(n5), .X(n22));
  SEH_FDPRBQ_V2_3 Q_reg_3_ (.CK(CLK_5), .D(n22), .Q(Q[3]), .RD(n18));
  SEH_AOI22_3 U9 (.A1(D[3]), .A2(ENA), .B1(Q[3]), .B2(n35), .X(n5));
  SEH_BUF_D_3 BW1_BUF3708 (.A(n18), .X(n18_1));
  SEH_INV_S_3 U33 (.A(n17), .X(n34));
  SEH_AOI22_3 U27 (.A1(D[12]), .A2(n36), .B1(Q[12]), .B2(n2), .X(n14));
  SEH_INV_S_3 U30 (.A(n16), .X(n33));
  SEH_INV_S_3 U26 (.A(n14), .X(n31));
  SEH_INV_S_3 U24 (.A(n13), .X(n30));
  SEH_INV_S_3 U20 (.A(n11), .X(n28));
  SEH_INV_S_3 U18 (.A(n10), .X(n27));
  SEH_INV_S_3 U22 (.A(n12), .X(n29));
  SEH_FDPRBQ_V2_3 Q_reg_2_ (.CK(CLK_7), .D(n21), .Q(Q[2]), .RD(n18_1));
  SEH_BUF_3 U35 (.A(ENA), .X(n36));
  SEH_FDPRBQ_V2_3 Q_reg_5_ (.CK(CLK_1), .D(n24), .Q(Q[5]), .RD(n18_1));
  SEH_INV_S_3 U14 (.A(n8), .X(n25));
  SEH_AOI22_3 U15 (.A1(D[6]), .A2(n36), .B1(Q[6]), .B2(n35), .X(n8));
  SEH_BUF_D_3 BW1_BUF2673 (.A(n18_1), .X(n18_2));
  SEH_BUF_3 U36 (.A(ENA), .X(n37));
  SEH_INV_S_3 U16 (.A(n9), .X(n26));
  SEH_INV_S_3 U12 (.A(n7), .X(n24));
  SEH_INV_S_3 U38 (.A(n36), .X(n2));
  SEH_FDPRBQ_V2_3 Q_reg_12_ (.CK(CLK_2), .D(n31), .Q(Q[12]), .RD(n18_2));
  SEH_AOI22_3 U34 (.A1(D[15]), .A2(n37), .B1(Q[15]), .B2(n2), .X(n17));
  SEH_AOI22_3 U31 (.A1(D[14]), .A2(n36), .B1(Q[14]), .B2(n2), .X(n16));
  SEH_FDPRBQ_V2_3 Q_reg_7_ (.CK(CLK_1), .D(n26), .Q(Q[7]), .RD(n18_1));
  SEH_FDPRBQ_V2_3 Q_reg_6_ (.CK(CLK_1), .D(n25), .Q(Q[6]), .RD(n18_1));
  SEH_INV_S_3 U28 (.A(n15), .X(n32));
  SEH_INV_S_3 U32 (.A(n36), .X(n35));
  SEH_AOI22_3 U19 (.A1(D[8]), .A2(n36), .B1(Q[8]), .B2(n2), .X(n10));
  SEH_AOI22_3 U17 (.A1(D[7]), .A2(n37), .B1(Q[7]), .B2(n35), .X(n9));
  SEH_AOI22_3 U29 (.A1(D[13]), .A2(n37), .B1(Q[13]), .B2(n2), .X(n15));
  SEH_AOI22_3 U25 (.A1(D[11]), .A2(n37), .B1(Q[11]), .B2(n2), .X(n13));
  SEH_AOI22_3 U23 (.A1(D[10]), .A2(n36), .B1(Q[10]), .B2(n2), .X(n12));
  SEH_AOI22_3 U21 (.A1(D[9]), .A2(n37), .B1(Q[9]), .B2(n2), .X(n11));
  SEH_FDPRBQ_V2_3 Q_reg_0_ (.CK(CLK_5), .D(n19), .Q(Q[0]), .RD(n18_1));
  SEH_INV_S_3 U10 (.A(n6), .X(n23));
  SEH_INV_S_3 U4 (.A(n3), .X(n20));
  SEH_INV_S_3 U2 (.A(n1), .X(n19));
  SEH_AOI22_3 U11 (.A1(D[4]), .A2(ENA), .B1(Q[4]), .B2(n35), .X(n6));
  SEH_FDPRBQ_V2_3 Q_reg_4_ (.CK(CLK_5), .D(n23), .Q(Q[4]), .RD(n18_1));
  SEH_FDPRBQ_V2_3 Q_reg_10_ (.CK(CLK_1), .D(n29), .Q(Q[10]), .RD(n18_2));
  SEH_FDPRBQ_V2_3 Q_reg_15_ (.CK(CLK_2), .D(n34), .Q(Q[15]), .RD(n18_2));
  SEH_AOI22_3 U13 (.A1(D[5]), .A2(n37), .B1(Q[5]), .B2(n35), .X(n7));
  SEH_FDPRBQ_V2_3 Q_reg_13_ (.CK(CLK_1), .D(n32), .Q(Q[13]), .RD(n18_2));
  SEH_FDPRBQ_V2_3 Q_reg_9_ (.CK(CLK_1), .D(n28), .Q(Q[9]), .RD(n18_2));
  SEH_FDPRBQ_V2_3 Q_reg_8_ (.CK(CLK_1), .D(n27), .Q(Q[8]), .RD(n18_2));
  SEH_AOI22_3 U3 (.A1(ENA), .A2(D[0]), .B1(Q[0]), .B2(n35), .X(n1));
  SEH_FDPRBQ_V2_3 Q_reg_11_ (.CK(CLK_1), .D(n30), .Q(Q[11]), .RD(n18_2));
endmodule

// Entity:ADDER_A_IN_MUX_1 Model:ADDER_A_IN_MUX_1 Library:magma_checknetlist_lib
module ADDER_A_IN_MUX_1 (ACCUMULATOR_REG, DIRECT_INPUT, SELM, ADDER_A_MUX);
  input SELM;
  input [15:0] ACCUMULATOR_REG;
  input [15:0] DIRECT_INPUT;
  output [15:0] ADDER_A_MUX;
  wire n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, 
     n31, n32, n33, n1, n2, n3;
  SEH_AOI22_3 U8 (.A1(ACCUMULATOR_REG[1]), .A2(n17), .B1(DIRECT_INPUT[1]), 
     .B2(n3), .X(n26));
  SEH_AOI22_3 U16 (.A1(ACCUMULATOR_REG[3]), .A2(n17), .B1(DIRECT_INPUT[3]), 
     .B2(SELM), .X(n24));
  SEH_AOI22_3 U36 (.A1(ACCUMULATOR_REG[15]), .A2(n1), .B1(DIRECT_INPUT[15]), 
     .B2(SELM), .X(n27));
  SEH_AOI22_3 U26 (.A1(ACCUMULATOR_REG[9]), .A2(n1), .B1(SELM), 
     .B2(DIRECT_INPUT[9]), .X(n18));
  SEH_INV_S_3 U4 (.A(n2), .X(n17));
  SEH_AOI22_3 U10 (.A1(ACCUMULATOR_REG[4]), .A2(n17), .B1(DIRECT_INPUT[4]), 
     .B2(n3), .X(n23));
  SEH_AOI22_3 U20 (.A1(ACCUMULATOR_REG[7]), .A2(n17), .B1(DIRECT_INPUT[7]), 
     .B2(n3), .X(n20));
  SEH_AOI22_3 U18 (.A1(ACCUMULATOR_REG[6]), .A2(n17), .B1(DIRECT_INPUT[6]), 
     .B2(n2), .X(n21));
  SEH_BUF_3 U2 (.A(SELM), .X(n2));
  SEH_AOI22_3 U6 (.A1(ACCUMULATOR_REG[0]), .A2(n17), .B1(DIRECT_INPUT[0]), 
     .B2(n2), .X(n33));
  SEH_AOI22_3 U22 (.A1(ACCUMULATOR_REG[8]), .A2(n1), .B1(DIRECT_INPUT[8]), 
     .B2(SELM), .X(n19));
  SEH_AOI22_3 U12 (.A1(ACCUMULATOR_REG[5]), .A2(n17), .B1(DIRECT_INPUT[5]), 
     .B2(n2), .X(n22));
  SEH_INV_S_3 U11 (.A(n22), .X(ADDER_A_MUX[5]));
  SEH_INV_S_3 U9 (.A(n23), .X(ADDER_A_MUX[4]));
  SEH_INV_S_3 U21 (.A(n19), .X(ADDER_A_MUX[8]));
  SEH_INV_S_3 U19 (.A(n20), .X(ADDER_A_MUX[7]));
  SEH_AOI22_3 U28 (.A1(ACCUMULATOR_REG[11]), .A2(n1), .B1(DIRECT_INPUT[11]), 
     .B2(n3), .X(n31));
  SEH_INV_S_3 U31 (.A(n28), .X(ADDER_A_MUX[14]));
  SEH_INV_S_3 U29 (.A(n30), .X(ADDER_A_MUX[12]));
  SEH_INV_S_3 U23 (.A(n32), .X(ADDER_A_MUX[10]));
  SEH_INV_S_3 U27 (.A(n31), .X(ADDER_A_MUX[11]));
  SEH_INV_S_3 U33 (.A(n29), .X(ADDER_A_MUX[13]));
  SEH_INV_S_3 U25 (.A(n18), .X(ADDER_A_MUX[9]));
  SEH_AOI22_3 U14 (.A1(ACCUMULATOR_REG[2]), .A2(n17), .B1(DIRECT_INPUT[2]), 
     .B2(n3), .X(n25));
  SEH_INV_S_3 U5 (.A(n33), .X(ADDER_A_MUX[0]));
  SEH_BUF_3 U3 (.A(SELM), .X(n3));
  SEH_AOI22_3 U30 (.A1(ACCUMULATOR_REG[12]), .A2(n1), .B1(DIRECT_INPUT[12]), 
     .B2(SELM), .X(n30));
  SEH_AOI22_3 U34 (.A1(ACCUMULATOR_REG[13]), .A2(n1), .B1(DIRECT_INPUT[13]), 
     .B2(n3), .X(n29));
  SEH_AOI22_3 U32 (.A1(ACCUMULATOR_REG[14]), .A2(n1), .B1(DIRECT_INPUT[14]), 
     .B2(n2), .X(n28));
  SEH_AOI22_3 U24 (.A1(ACCUMULATOR_REG[10]), .A2(n1), .B1(DIRECT_INPUT[10]), 
     .B2(n2), .X(n32));
  SEH_INV_S_3 U35 (.A(n27), .X(ADDER_A_MUX[15]));
  SEH_INV_S_3 U1 (.A(n2), .X(n1));
  SEH_INV_S_3 U13 (.A(n25), .X(ADDER_A_MUX[2]));
  SEH_INV_S_3 U15 (.A(n24), .X(ADDER_A_MUX[3]));
  SEH_INV_S_3 U7 (.A(n26), .X(ADDER_A_MUX[1]));
  SEH_INV_S_3 U17 (.A(n21), .X(ADDER_A_MUX[6]));
endmodule

// Entity:ADDER_B_IN_MUX_1 Model:ADDER_B_IN_MUX_1 Library:magma_checknetlist_lib
module ADDER_B_IN_MUX_1 (MULT_INPUT, MULT_8x8, MULT_16x16, SIGNEXTIN, SELM, 
     ADDER_B_MUX);
  input SIGNEXTIN;
  input [15:0] MULT_INPUT;
  input [15:0] MULT_8x8;
  input [15:0] MULT_16x16;
  input [1:0] SELM;
  output [15:0] ADDER_B_MUX;
  wire n48, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, 
     n16, n17, n20, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, 
     n35, n36, n37, n18, n19, n21, n22, n38, n39, n40, n41, n42, n43, n44, n45, 
     n46;
  SEH_INV_S_3 U40 (.A(MULT_16x16[5]), .X(n11));
  SEH_INV_S_3 U50 (.A(MULT_16x16[8]), .X(n8));
  SEH_INV_S_3 U14 (.A(n19), .X(n42));
  SEH_OR2_2P5 U2 (.A1(SELM[0]), .A2(SELM[1]), .X(n19));
  SEH_AN3_3 U4 (.A1(SELM[1]), .A2(SELM[0]), .A3(SIGNEXTIN), .X(n22));
  SEH_INV_S_3 U16 (.A(n18), .X(n44));
  SEH_INV_S_3 U44 (.A(MULT_16x16[3]), .X(n13));
  SEH_OR2_2P5 U1 (.A1(n17), .A2(SELM[1]), .X(n18));
  SEH_AN2_S_3 U3 (.A1(SELM[1]), .A2(n17), .X(n21));
  SEH_INV_S_3 U62 (.A(SELM[0]), .X(n17));
  SEH_INV_S_3 U17 (.A(n18), .X(n45));
  SEH_INV_S_3 U36 (.A(MULT_16x16[1]), .X(n15));
  SEH_INV_S_3 U54 (.A(MULT_16x16[12]), .X(n4));
  SEH_INV_S_3 U7 (.A(n48), .X(n46));
  SEH_OAI211_3 U30 (.A1(n41), .A2(n7), .B1(n39), .B2(n20), .X(ADDER_B_MUX[9]));
  SEH_INV_S_3 U33 (.A(MULT_16x16[13]), .X(n3));
  SEH_AOI22_3 U55 (.A1(MULT_8x8[12]), .A2(n45), .B1(MULT_INPUT[12]), .B2(n43), 
     .X(n34));
  SEH_INV_S_3 U60 (.A(MULT_16x16[11]), .X(n5));
  SEH_INV_S_3 U52 (.A(MULT_16x16[10]), .X(n6));
  SEH_AOI22_3 U5 (.A1(MULT_8x8[15]), .A2(n44), .B1(MULT_INPUT[15]), .B2(n42), 
     .X(n31));
  SEH_AOI22_3 U57 (.A1(MULT_8x8[14]), .A2(n44), .B1(MULT_INPUT[14]), .B2(n42), 
     .X(n32));
  SEH_AOI22_3 U53 (.A1(MULT_8x8[10]), .A2(n44), .B1(MULT_INPUT[10]), .B2(n42), 
     .X(n36));
  SEH_INV_S_3 U58 (.A(MULT_16x16[9]), .X(n7));
  SEH_OAI211_3 U8 (.A1(n40), .A2(n1), .B1(n39), .B2(n31), .X(n48));
  SEH_OAI211_3 U27 (.A1(n40), .A2(n6), .B1(n38), .B2(n36), .X(ADDER_B_MUX[10]));
  SEH_INV_S_3 U9 (.A(MULT_16x16[15]), .X(n1));
  SEH_AOI22_3 U61 (.A1(MULT_8x8[11]), .A2(n44), .B1(MULT_INPUT[11]), .B2(n42), 
     .X(n35));
  SEH_INV_S_3 U48 (.A(MULT_16x16[7]), .X(n9));
  SEH_INV_S_3 U15 (.A(n19), .X(n43));
  SEH_AOI22_3 U43 (.A1(MULT_8x8[2]), .A2(n45), .B1(MULT_INPUT[2]), .B2(n43), 
     .X(n29));
  SEH_OAI211_3 U22 (.A1(n41), .A2(n14), .B1(n39), .B2(n29), .X(ADDER_B_MUX[2]));
  SEH_INV_S_24 U6 (.A(n46), .X(ADDER_B_MUX[15]));
  SEH_OAI211_3 U31 (.A1(n40), .A2(n3), .B1(n39), .B2(n33), .X(ADDER_B_MUX[13]));
  SEH_OAI211_3 U28 (.A1(n41), .A2(n4), .B1(n38), .B2(n34), .X(ADDER_B_MUX[12]));
  SEH_OAI211_3 U32 (.A1(n41), .A2(n5), .B1(n39), .B2(n35), .X(ADDER_B_MUX[11]));
  SEH_OAI211_3 U29 (.A1(n40), .A2(n2), .B1(n38), .B2(n32), .X(ADDER_B_MUX[14]));
  SEH_AOI22_3 U63 (.A1(MULT_8x8[13]), .A2(n45), .B1(MULT_INPUT[13]), .B2(n43), 
     .X(n33));
  SEH_INV_S_3 U56 (.A(MULT_16x16[14]), .X(n2));
  SEH_AOI22_3 U59 (.A1(MULT_8x8[9]), .A2(n45), .B1(MULT_INPUT[9]), .B2(n43), 
     .X(n20));
  SEH_INV_S_3 U12 (.A(n21), .X(n40));
  SEH_AOI22_3 U51 (.A1(MULT_8x8[8]), .A2(n45), .B1(MULT_INPUT[8]), .B2(n43), 
     .X(n23));
  SEH_INV_S_3 U10 (.A(n22), .X(n38));
  SEH_INV_S_3 U13 (.A(n21), .X(n41));
  SEH_OAI211_3 U26 (.A1(n41), .A2(n8), .B1(n38), .B2(n23), .X(ADDER_B_MUX[8]));
  SEH_OAI211_3 U23 (.A1(n40), .A2(n13), .B1(n39), .B2(n28), .X(ADDER_B_MUX[3]));
  SEH_OAI211_3 U25 (.A1(n40), .A2(n9), .B1(n39), .B2(n24), .X(ADDER_B_MUX[7]));
  SEH_OAI211_3 U19 (.A1(n40), .A2(n15), .B1(n38), .B2(n30), .X(ADDER_B_MUX[1]));
  SEH_AOI22_3 U49 (.A1(MULT_8x8[7]), .A2(n44), .B1(MULT_INPUT[7]), .B2(n42), 
     .X(n24));
  SEH_AOI22_3 U37 (.A1(MULT_8x8[1]), .A2(n44), .B1(MULT_INPUT[1]), .B2(n42), 
     .X(n30));
  SEH_AOI22_3 U45 (.A1(MULT_8x8[3]), .A2(n44), .B1(MULT_INPUT[3]), .B2(n42), 
     .X(n28));
  SEH_INV_S_3 U34 (.A(MULT_16x16[0]), .X(n16));
  SEH_OAI211_3 U24 (.A1(n41), .A2(n10), .B1(n39), .B2(n25), .X(ADDER_B_MUX[6]));
  SEH_OAI211_3 U18 (.A1(n41), .A2(n16), .B1(n38), .B2(n37), .X(ADDER_B_MUX[0]));
  SEH_OAI211_3 U20 (.A1(n41), .A2(n12), .B1(n38), .B2(n27), .X(ADDER_B_MUX[4]));
  SEH_AOI22_3 U39 (.A1(MULT_8x8[4]), .A2(n45), .B1(MULT_INPUT[4]), .B2(n43), 
     .X(n27));
  SEH_AOI22_3 U35 (.A1(MULT_8x8[0]), .A2(n45), .B1(MULT_INPUT[0]), .B2(n43), 
     .X(n37));
  SEH_AOI22_3 U47 (.A1(MULT_8x8[6]), .A2(n45), .B1(MULT_INPUT[6]), .B2(n43), 
     .X(n25));
  SEH_INV_S_3 U11 (.A(n22), .X(n39));
  SEH_INV_S_3 U46 (.A(MULT_16x16[6]), .X(n10));
  SEH_INV_S_3 U42 (.A(MULT_16x16[2]), .X(n14));
  SEH_INV_S_3 U38 (.A(MULT_16x16[4]), .X(n12));
  SEH_AOI22_3 U41 (.A1(MULT_8x8[5]), .A2(n44), .B1(MULT_INPUT[5]), .B2(n42), 
     .X(n26));
  SEH_OAI211_3 U21 (.A1(n40), .A2(n11), .B1(n38), .B2(n26), .X(ADDER_B_MUX[5]));
endmodule

// Entity:CARRY_IN_MUX_1 Model:CARRY_IN_MUX_1 Library:magma_checknetlist_lib
module CARRY_IN_MUX_1 (CICAS, CI, CARRYMUX_SEL, ADDER_CI);
  input CICAS, CI;
  output ADDER_CI;
  input [1:0] CARRYMUX_SEL;
  wire n1, n2, n3;
  SEH_INV_S_3 U6 (.A(CI), .X(n1));
  SEH_AO31_4 U3 (.A1(CARRYMUX_SEL[1]), .A2(n2), .A3(CICAS), .B(n3), .X(ADDER_CI));
  SEH_INV_S_3 U5 (.A(CARRYMUX_SEL[0]), .X(n2));
  SEH_AOI21_3 U4 (.A1(n1), .A2(CARRYMUX_SEL[1]), .B(n2), .X(n3));
endmodule

// Entity:LOAD_ADD_MUX_1 Model:LOAD_ADD_MUX_1 Library:magma_checknetlist_lib
module LOAD_ADD_MUX_1 (ADDER, LOAD_DATA, LOAD, OUT);
  input LOAD;
  input [15:0] ADDER;
  input [15:0] LOAD_DATA;
  output [15:0] OUT;
  wire n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, 
     n32, n33, n1, n2, n3, n4, n5, LOAD_1;
  SEH_INV_S_3 U12 (.A(n21), .X(OUT[6]));
  SEH_INV_S_3 U18 (.A(n18), .X(OUT[9]));
  SEH_INV_S_3 U32 (.A(n23), .X(OUT[4]));
  SEH_INV_S_3 U8 (.A(n25), .X(OUT[2]));
  SEH_INV_S_3 U34 (.A(n26), .X(OUT[1]));
  SEH_INV_S_3 U36 (.A(n33), .X(OUT[0]));
  SEH_INV_S_3 U10 (.A(n22), .X(OUT[5]));
  SEH_INV_S_3 U22 (.A(n20), .X(OUT[7]));
  SEH_INV_S_3 U6 (.A(n27), .X(OUT[15]));
  SEH_INV_S_3 U30 (.A(n28), .X(OUT[14]));
  SEH_INV_S_3 U26 (.A(n30), .X(OUT[12]));
  SEH_AOI22_3 U27 (.A1(ADDER[12]), .A2(n1), .B1(LOAD_DATA[12]), .B2(LOAD), 
     .X(n30));
  SEH_INV_S_3 U3 (.A(n5), .X(n3));
  SEH_INV_S_3 U2 (.A(LOAD_1), .X(n2));
  SEH_AOI22_3 U35 (.A1(ADDER[1]), .A2(n1), .B1(LOAD_DATA[1]), .B2(LOAD), .X(n26));
  SEH_AOI22_3 U13 (.A1(ADDER[6]), .A2(n2), .B1(LOAD_DATA[6]), .B2(n4), .X(n21));
  SEH_AOI22_3 U17 (.A1(ADDER[8]), .A2(n2), .B1(LOAD_DATA[8]), .B2(LOAD_1), 
     .X(n19));
  SEH_AOI22_3 U21 (.A1(ADDER[3]), .A2(n2), .B1(LOAD_DATA[3]), .B2(n5), .X(n24));
  SEH_AOI22_3 U33 (.A1(ADDER[4]), .A2(n2), .B1(LOAD_DATA[4]), .B2(n5), .X(n23));
  SEH_AOI22_3 U11 (.A1(ADDER[5]), .A2(n1), .B1(LOAD_DATA[5]), .B2(n5), .X(n22));
  SEH_INV_S_3 U16 (.A(n19), .X(OUT[8]));
  SEH_AOI22_3 U15 (.A1(ADDER[10]), .A2(n1), .B1(LOAD_DATA[10]), .B2(n5), .X(n32));
  SEH_AOI22_3 U31 (.A1(ADDER[14]), .A2(n1), .B1(LOAD_DATA[14]), .B2(n4), .X(n28));
  SEH_AOI22_3 U25 (.A1(ADDER[11]), .A2(n2), .B1(LOAD_DATA[11]), .B2(n4), .X(n31));
  SEH_INV_S_3 U4 (.A(n3), .X(n4));
  SEH_AOI22_3 U7 (.A1(ADDER[15]), .A2(n1), .B1(LOAD_DATA[15]), .B2(n4), .X(n27));
  SEH_INV_S_3 U24 (.A(n31), .X(OUT[11]));
  SEH_INV_S_3 U14 (.A(n32), .X(OUT[10]));
  SEH_INV_S_3 U28 (.A(n29), .X(OUT[13]));
  SEH_INV_S_3 U20 (.A(n24), .X(OUT[3]));
  SEH_BUF_3 U5 (.A(LOAD_1), .X(n5));
  SEH_AOI22_3 U9 (.A1(ADDER[2]), .A2(n2), .B1(LOAD_DATA[2]), .B2(LOAD), .X(n25));
  SEH_AOI22_3 U29 (.A1(ADDER[13]), .A2(n2), .B1(LOAD_DATA[13]), .B2(n5), .X(n29));
  SEH_AOI22_3 U19 (.A1(ADDER[9]), .A2(n1), .B1(LOAD_DATA[9]), .B2(n4), .X(n18));
  SEH_BUF_3 BW1_BUF3598 (.A(LOAD), .X(LOAD_1));
  SEH_AOI22_3 U23 (.A1(ADDER[7]), .A2(n1), .B1(LOAD_DATA[7]), .B2(LOAD), .X(n20));
  SEH_AOI22_3 U37 (.A1(ADDER[0]), .A2(n2), .B1(LOAD_DATA[0]), .B2(n4), .X(n33));
  SEH_INV_S_3 U1 (.A(n5), .X(n1));
endmodule

// Entity:OUT_MUX_4_1 Model:OUT_MUX_4_1 Library:magma_checknetlist_lib
module OUT_MUX_4_1 (ADDER_COMBINATORIAL, ACCUM_REGISTER, MULT_8x8, MULT_16x16, 
     SELM, OUT);
  input [15:0] ADDER_COMBINATORIAL;
  input [15:0] ACCUM_REGISTER;
  input [15:0] MULT_8x8;
  input [15:0] MULT_16x16;
  input [1:0] SELM;
  output [15:0] OUT;
  wire n69, n70, n71, n72, n73, n74, n75, n76, n77, n1, n2, n3, n8, n9, n10, 
     n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, 
     n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n4, n5, n6, n7, 
     n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52;
  SEH_INV_S_24 U56 (.A(n77), .X(OUT[0]));
  SEH_AOI22_3 U12 (.A1(MULT_16x16[5]), .A2(n46), .B1(MULT_8x8[5]), .B2(n50), 
     .X(n15));
  SEH_AN2_S_3 U55 (.A1(n36), .A2(n37), .X(n77));
  SEH_AOI22_3 U14 (.A1(MULT_16x16[6]), .A2(n45), .B1(MULT_8x8[6]), .B2(n49), 
     .X(n13));
  SEH_AOI22_3 U73 (.A1(MULT_16x16[0]), .A2(n46), .B1(MULT_8x8[0]), .B2(n50), 
     .X(n37));
  SEH_AOI22_3 U16 (.A1(MULT_16x16[7]), .A2(n45), .B1(MULT_8x8[7]), .B2(n49), 
     .X(n11));
  SEH_AOI22_3 U74 (.A1(MULT_16x16[3]), .A2(n45), .B1(MULT_8x8[3]), .B2(n49), 
     .X(n19));
  SEH_AOI22_3 U10 (.A1(MULT_16x16[4]), .A2(n45), .B1(MULT_8x8[4]), .B2(n49), 
     .X(n17));
  SEH_AN2_S_3 U51 (.A1(n20), .A2(n21), .X(n75));
  SEH_AOI22_3 U17 (.A1(MULT_16x16[8]), .A2(n46), .B1(MULT_8x8[8]), .B2(n50), 
     .X(n9));
  SEH_INV_S_24 U54 (.A(n76), .X(OUT[1]));
  SEH_INV_S_24 U52 (.A(n75), .X(OUT[2]));
  SEH_AOI22_3 U75 (.A1(ACCUM_REGISTER[7]), .A2(n48), .B1(ADDER_COMBINATORIAL[7]), 
     .B2(n52), .X(n10));
  SEH_AOI22_3 U61 (.A1(ACCUM_REGISTER[10]), .A2(n48), 
     .B1(ADDER_COMBINATORIAL[10]), .B2(n52), .X(n34));
  SEH_AOI22_3 U69 (.A1(ACCUM_REGISTER[14]), .A2(n48), 
     .B1(ADDER_COMBINATORIAL[14]), .B2(n52), .X(n26));
  SEH_AOI22_3 U65 (.A1(ACCUM_REGISTER[12]), .A2(n48), 
     .B1(ADDER_COMBINATORIAL[12]), .B2(n52), .X(n30));
  SEH_AOI22_3 U67 (.A1(ACCUM_REGISTER[13]), .A2(n47), 
     .B1(ADDER_COMBINATORIAL[13]), .B2(n51), .X(n28));
  SEH_AOI22_3 U8 (.A1(ACCUM_REGISTER[2]), .A2(n47), .B1(ADDER_COMBINATORIAL[2]), 
     .B2(n51), .X(n20));
  SEH_AOI22_3 U72 (.A1(MULT_16x16[15]), .A2(n46), .B1(MULT_8x8[15]), .B2(n50), 
     .X(n25));
  SEH_AOI22_3 U62 (.A1(MULT_16x16[10]), .A2(n45), .B1(MULT_8x8[10]), .B2(n49), 
     .X(n35));
  SEH_AOI22_3 U60 (.A1(MULT_16x16[9]), .A2(n46), .B1(MULT_8x8[9]), .B2(n50), 
     .X(n3));
  SEH_INV_S_3 U43 (.A(n43), .X(n52));
  SEH_AOI22_3 U9 (.A1(ACCUM_REGISTER[3]), .A2(n48), .B1(ADDER_COMBINATORIAL[3]), 
     .B2(n52), .X(n18));
  SEH_AOI22_3 U7 (.A1(ACCUM_REGISTER[1]), .A2(n48), .B1(ADDER_COMBINATORIAL[1]), 
     .B2(n52), .X(n22));
  SEH_AN2_S_3 U30 (.A1(n26), .A2(n27), .X(n39));
  SEH_AOI22_3 U59 (.A1(ACCUM_REGISTER[9]), .A2(n47), .B1(ADDER_COMBINATORIAL[9]), 
     .B2(n51), .X(n2));
  SEH_AOI22_3 U11 (.A1(ACCUM_REGISTER[4]), .A2(n47), .B1(ADDER_COMBINATORIAL[4]), 
     .B2(n51), .X(n16));
  SEH_AOI22_3 U13 (.A1(ACCUM_REGISTER[5]), .A2(n47), .B1(ADDER_COMBINATORIAL[5]), 
     .B2(n51), .X(n14));
  SEH_AOI22_3 U6 (.A1(ACCUM_REGISTER[0]), .A2(n47), .B1(ADDER_COMBINATORIAL[0]), 
     .B2(n51), .X(n36));
  SEH_INV_S_24 U21 (.A(n7), .X(OUT[12]));
  SEH_INV_S_24 U20 (.A(n6), .X(OUT[11]));
  SEH_AOI22_3 U68 (.A1(MULT_16x16[13]), .A2(n46), .B1(MULT_8x8[13]), .B2(n50), 
     .X(n29));
  SEH_AN2_S_3 U27 (.A1(n32), .A2(n33), .X(n6));
  SEH_INV_S_3 U41 (.A(n41), .X(n50));
  SEH_AN2_S_3 U29 (.A1(n28), .A2(n29), .X(n38));
  SEH_ND2_S_2P5 U32 (.A1(SELM[1]), .A2(n1), .X(n41));
  SEH_INV_S_24 U22 (.A(n38), .X(OUT[13]));
  SEH_INV_S_24 U23 (.A(n39), .X(OUT[14]));
  SEH_INV_S_24 U24 (.A(n40), .X(OUT[15]));
  SEH_OR2_2P5 U35 (.A1(n1), .A2(SELM[1]), .X(n44));
  SEH_INV_S_3 U38 (.A(n44), .X(n47));
  SEH_AOI22_3 U66 (.A1(MULT_16x16[12]), .A2(n45), .B1(MULT_8x8[12]), .B2(n49), 
     .X(n31));
  SEH_AOI22_3 U63 (.A1(ACCUM_REGISTER[11]), .A2(n47), 
     .B1(ADDER_COMBINATORIAL[11]), .B2(n51), .X(n32));
  SEH_AOI22_3 U71 (.A1(ACCUM_REGISTER[15]), .A2(n47), 
     .B1(ADDER_COMBINATORIAL[15]), .B2(n51), .X(n24));
  SEH_AOI22_3 U15 (.A1(ACCUM_REGISTER[6]), .A2(n48), .B1(ADDER_COMBINATORIAL[6]), 
     .B2(n52), .X(n12));
  SEH_AOI22_3 U58 (.A1(ACCUM_REGISTER[8]), .A2(n48), .B1(ADDER_COMBINATORIAL[8]), 
     .B2(n52), .X(n8));
  SEH_INV_S_3 U39 (.A(n44), .X(n48));
  SEH_INV_S_3 U42 (.A(n43), .X(n51));
  SEH_INV_S_3 U40 (.A(n41), .X(n49));
  SEH_AN2_S_3 U28 (.A1(n30), .A2(n31), .X(n7));
  SEH_OR2_2P5 U34 (.A1(SELM[0]), .A2(SELM[1]), .X(n43));
  SEH_AN2_S_3 U31 (.A1(n24), .A2(n25), .X(n40));
  SEH_INV_S_3 U57 (.A(SELM[0]), .X(n1));
  SEH_AN2_S_3 U5 (.A1(n8), .A2(n9), .X(n69));
  SEH_AN2_S_3 U4 (.A1(n10), .A2(n11), .X(n70));
  SEH_AN2_S_3 U53 (.A1(n22), .A2(n23), .X(n76));
  SEH_ND2_S_2P5 U33 (.A1(SELM[1]), .A2(SELM[0]), .X(n42));
  SEH_AOI22_3 U76 (.A1(MULT_16x16[1]), .A2(n46), .B1(MULT_8x8[1]), .B2(n50), 
     .X(n23));
  SEH_INV_S_3 U37 (.A(n42), .X(n46));
  SEH_AN2_S_3 U2 (.A1(n14), .A2(n15), .X(n72));
  SEH_AOI22_3 U77 (.A1(MULT_16x16[2]), .A2(n45), .B1(MULT_8x8[2]), .B2(n49), 
     .X(n21));
  SEH_AOI22_3 U70 (.A1(MULT_16x16[14]), .A2(n45), .B1(MULT_8x8[14]), .B2(n49), 
     .X(n27));
  SEH_AOI22_3 U64 (.A1(MULT_16x16[11]), .A2(n46), .B1(MULT_8x8[11]), .B2(n50), 
     .X(n33));
  SEH_AN2_S_3 U26 (.A1(n34), .A2(n35), .X(n5));
  SEH_AN2_S_3 U25 (.A1(n2), .A2(n3), .X(n4));
  SEH_INV_S_3 U50 (.A(n74), .X(OUT[3]));
  SEH_INV_S_24 U47 (.A(n72), .X(OUT[5]));
  SEH_INV_S_24 U46 (.A(n71), .X(OUT[6]));
  SEH_INV_S_3 U48 (.A(n73), .X(OUT[4]));
  SEH_INV_S_24 U18 (.A(n4), .X(OUT[9]));
  SEH_INV_S_24 U19 (.A(n5), .X(OUT[10]));
  SEH_INV_S_24 U44 (.A(n69), .X(OUT[8]));
  SEH_INV_S_24 U45 (.A(n70), .X(OUT[7]));
  SEH_AN2_S_3 U3 (.A1(n12), .A2(n13), .X(n71));
  SEH_AN2_S_3 U49 (.A1(n18), .A2(n19), .X(n74));
  SEH_AN2_S_3 U1 (.A1(n16), .A2(n17), .X(n73));
  SEH_INV_S_3 U36 (.A(n42), .X(n45));
endmodule

// Entity:REG_BYPASS_MUX_0 Model:REG_BYPASS_MUX_0 Library:magma_checknetlist_lib
module REG_BYPASS_MUX_0 (D, Q, ENA, CLK, RST, SELM, CLK_1, CLK_3);
  input ENA, CLK, RST, SELM, CLK_1, CLK_3;
  input [15:0] D;
  output [15:0] Q;
  wire [15:0] REG_INTERNAL;
  wire n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, 
     n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, 
     n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, 
     n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, 
     n74_1, n74_2, n74_3, n74_4;
  SEH_INV_S_3 U68 (.A(REG_INTERNAL[0]), .X(n108));
  SEH_OAI22_3 U32 (.A1(n97), .A2(n75), .B1(n56), .B2(n96), .X(Q[5]));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_14_ (.CK(CLK_3), .D(n59), 
     .Q(REG_INTERNAL[14]), .RD(n74_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_4_ (.CK(CLK_1), .D(n69), .Q(REG_INTERNAL[4]), 
     .RD(n74_2));
  SEH_OAI22_3 U29 (.A1(n95), .A2(n75), .B1(SELM), .B2(n94), .X(Q[6]));
  SEH_OAI22_3 U23 (.A1(n91), .A2(n53), .B1(n56), .B2(n90), .X(Q[8]));
  SEH_OAI22_3 U20 (.A1(n89), .A2(n75), .B1(SELM), .B2(n88), .X(Q[9]));
  SEH_OAI22_3 U53 (.A1(n81), .A2(n53), .B1(n57), .B2(n80), .X(Q[13]));
  SEH_OAI22_3 U50 (.A1(n79), .A2(n53), .B1(n56), .B2(n78), .X(Q[14]));
  SEH_OAI22_3 U35 (.A1(n99), .A2(n75), .B1(n57), .B2(n98), .X(Q[4]));
  SEH_OAI22_3 U62 (.A1(n87), .A2(n53), .B1(n57), .B2(n86), .X(Q[10]));
  SEH_OAI22_3 U41 (.A1(n103), .A2(n75), .B1(n56), .B2(n102), .X(Q[2]));
  SEH_INV_S_3 U21 (.A(D[9]), .X(n88));
  SEH_INV_S_3 U48 (.A(D[15]), .X(n76));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_10_ (.CK(CLK), .D(n63), .Q(REG_INTERNAL[10]), 
     .RD(n74_1));
  SEH_INV_S_3 U58 (.A(REG_INTERNAL[12]), .X(n83));
  SEH_INV_S_3 U37 (.A(REG_INTERNAL[4]), .X(n99));
  SEH_INV_S_3 U74 (.A(n56), .X(n75));
  SEH_INV_S_3 U52 (.A(REG_INTERNAL[14]), .X(n79));
  SEH_INV_S_3 U19 (.A(n56), .X(n53));
  SEH_DEL_L6_1 OPTHOLD_G_4 (.A(n74), .X(n74_4));
  SEH_INV_S_3 U51 (.A(D[14]), .X(n78));
  SEH_INV_S_3 U57 (.A(D[12]), .X(n82));
  SEH_INV_S_3 U54 (.A(D[13]), .X(n80));
  SEH_INV_S_3 U63 (.A(D[10]), .X(n86));
  SEH_BUF_D_3 BW1_BUF1300 (.A(n74_3), .X(n74_1));
  SEH_INV_S_3 U60 (.A(D[11]), .X(n84));
  SEH_INV_S_3 U30 (.A(D[6]), .X(n94));
  SEH_INV_S_3 U72 (.A(RST), .X(n74));
  SEH_INV_S_3 U24 (.A(D[8]), .X(n90));
  SEH_INV_S_3 U33 (.A(D[5]), .X(n96));
  SEH_INV_S_3 U36 (.A(D[4]), .X(n98));
  SEH_INV_S_3 U27 (.A(D[7]), .X(n92));
  SEH_OAI22_3 U16 (.A1(n54), .A2(n79), .B1(n106), .B2(n78), .X(n59));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_9_ (.CK(CLK_3), .D(n64), .Q(REG_INTERNAL[9]), 
     .RD(n74_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_15_ (.CK(CLK), .D(n58), .Q(REG_INTERNAL[15]), 
     .RD(n74_1));
  SEH_OAI22_3 U11 (.A1(n55), .A2(n89), .B1(n106), .B2(n88), .X(n64));
  SEH_INV_S_3 U22 (.A(REG_INTERNAL[9]), .X(n89));
  SEH_INV_S_3 U39 (.A(D[3]), .X(n100));
  SEH_INV_S_3 U66 (.A(D[0]), .X(n107));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_8_ (.CK(CLK), .D(n65), .Q(REG_INTERNAL[8]), 
     .RD(n74_1));
  SEH_OAI22_3 U18 (.A1(n55), .A2(n77), .B1(n106), .B2(n76), .X(n58));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_12_ (.CK(CLK), .D(n61), .Q(REG_INTERNAL[12]), 
     .RD(n74_4));
  SEH_OAI22_3 U14 (.A1(ENA), .A2(n83), .B1(n106), .B2(n82), .X(n61));
  SEH_DEL_L6_1 OPTHOLD_G_3 (.A(n74), .X(n74_3));
  SEH_OAI22_3 U10 (.A1(ENA), .A2(n91), .B1(n106), .B2(n90), .X(n65));
  SEH_BUF_D_3 BW1_BUF3188 (.A(n74_1), .X(n74_2));
  SEH_BUF_3 U70 (.A(SELM), .X(n56));
  SEH_INV_S_3 U25 (.A(REG_INTERNAL[8]), .X(n91));
  SEH_BUF_3 U67 (.A(ENA), .X(n54));
  SEH_OAI22_3 U13 (.A1(n55), .A2(n85), .B1(n106), .B2(n84), .X(n62));
  SEH_BUF_3 U69 (.A(ENA), .X(n55));
  SEH_BUF_3 U71 (.A(SELM), .X(n57));
  SEH_OAI22_3 U8 (.A1(ENA), .A2(n95), .B1(n52), .B2(n94), .X(n67));
  SEH_INV_S_3 U73 (.A(n55), .X(n106));
  SEH_INV_S_3 U31 (.A(REG_INTERNAL[6]), .X(n95));
  SEH_INV_S_3 U61 (.A(REG_INTERNAL[11]), .X(n85));
  SEH_OAI22_3 U3 (.A1(n54), .A2(n105), .B1(n52), .B2(n104), .X(n72));
  SEH_OAI22_3 U4 (.A1(n54), .A2(n103), .B1(n52), .B2(n102), .X(n71));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_5_ (.CK(CLK_3), .D(n68), .Q(REG_INTERNAL[5]), 
     .RD(n74_2));
  SEH_OAI22_3 U5 (.A1(n54), .A2(n101), .B1(n52), .B2(n100), .X(n70));
  SEH_INV_S_3 U46 (.A(REG_INTERNAL[1]), .X(n105));
  SEH_INV_S_3 U17 (.A(ENA), .X(n52));
  SEH_OAI22_3 U2 (.A1(n54), .A2(n108), .B1(n107), .B2(n52), .X(n73));
  SEH_OAI22_3 U7 (.A1(n55), .A2(n97), .B1(n52), .B2(n96), .X(n68));
  SEH_OAI22_3 U38 (.A1(n101), .A2(n75), .B1(n57), .B2(n100), .X(Q[3]));
  SEH_INV_S_3 U55 (.A(REG_INTERNAL[13]), .X(n81));
  SEH_OAI22_3 U15 (.A1(n55), .A2(n81), .B1(n106), .B2(n80), .X(n60));
  SEH_INV_S_3 U49 (.A(REG_INTERNAL[15]), .X(n77));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_2_ (.CK(CLK_3), .D(n71), .Q(REG_INTERNAL[2]), 
     .RD(n74_2));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_7_ (.CK(CLK_3), .D(n66), .Q(REG_INTERNAL[7]), 
     .RD(n74_2));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_3_ (.CK(CLK_1), .D(n70), .Q(REG_INTERNAL[3]), 
     .RD(n74_2));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_1_ (.CK(CLK_1), .D(n72), .Q(REG_INTERNAL[1]), 
     .RD(n74_2));
  SEH_INV_S_3 U34 (.A(REG_INTERNAL[5]), .X(n97));
  SEH_INV_S_3 U28 (.A(REG_INTERNAL[7]), .X(n93));
  SEH_OAI22_3 U26 (.A1(n93), .A2(n75), .B1(n57), .B2(n92), .X(Q[7]));
  SEH_INV_S_3 U40 (.A(REG_INTERNAL[3]), .X(n101));
  SEH_OAI22_3 U9 (.A1(n55), .A2(n93), .B1(n52), .B2(n92), .X(n66));
  SEH_INV_S_3 U45 (.A(D[1]), .X(n104));
  SEH_INV_S_3 U43 (.A(REG_INTERNAL[2]), .X(n103));
  SEH_OAI22_3 U6 (.A1(n54), .A2(n99), .B1(n52), .B2(n98), .X(n69));
  SEH_OAI22_3 U56 (.A1(n83), .A2(n53), .B1(n57), .B2(n82), .X(Q[12]));
  SEH_OAI22_3 U65 (.A1(n108), .A2(n53), .B1(n57), .B2(n107), .X(Q[0]));
  SEH_OAI22_3 U44 (.A1(n105), .A2(n75), .B1(n57), .B2(n104), .X(Q[1]));
  SEH_OAI22_3 U59 (.A1(n85), .A2(n53), .B1(n56), .B2(n84), .X(Q[11]));
  SEH_OAI22_3 U47 (.A1(n77), .A2(n53), .B1(n56), .B2(n76), .X(Q[15]));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_0_ (.CK(CLK_3), .D(n73), .Q(REG_INTERNAL[0]), 
     .RD(n74_2));
  SEH_OAI22_3 U12 (.A1(ENA), .A2(n87), .B1(n106), .B2(n86), .X(n63));
  SEH_INV_S_3 U64 (.A(REG_INTERNAL[10]), .X(n87));
  SEH_INV_S_3 U42 (.A(D[2]), .X(n102));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_11_ (.CK(CLK), .D(n62), .Q(REG_INTERNAL[11]), 
     .RD(n74_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_13_ (.CK(CLK), .D(n60), .Q(REG_INTERNAL[13]), 
     .RD(n74_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_6_ (.CK(CLK_3), .D(n67), .Q(REG_INTERNAL[6]), 
     .RD(n74_2));
endmodule

// Entity:REG_BYPASS_MUX_1 Model:REG_BYPASS_MUX_1 Library:magma_checknetlist_lib
module REG_BYPASS_MUX_1 (D, Q, ENA, CLK, RST, SELM, CLK_2, CLK_5);
  input ENA, CLK, RST, SELM, CLK_2, CLK_5;
  input [15:0] D;
  output [15:0] Q;
  wire [15:0] REG_INTERNAL;
  wire n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, 
     n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, 
     n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, 
     n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, 
     n74_1, n74_2, CLK_1, RST_1;
  SEH_BUF_24 CLK_L0 (.A(CLK), .X(CLK_1));
  SEH_OAI22_3 U23 (.A1(n91), .A2(n53), .B1(n56), .B2(n90), .X(Q[8]));
  SEH_INV_S_3 U60 (.A(D[11]), .X(n84));
  SEH_INV_S_3 U72 (.A(RST_1), .X(n74));
  SEH_INV_S_3 U66 (.A(D[0]), .X(n107));
  SEH_INV_S_3 U30 (.A(D[6]), .X(n94));
  SEH_INV_S_3 U39 (.A(D[3]), .X(n100));
  SEH_INV_S_3 U63 (.A(D[10]), .X(n86));
  SEH_INV_S_3 U33 (.A(D[5]), .X(n96));
  SEH_INV_S_3 U27 (.A(D[7]), .X(n92));
  SEH_INV_S_3 U24 (.A(D[8]), .X(n90));
  SEH_INV_S_3 U21 (.A(D[9]), .X(n88));
  SEH_OAI22_3 U59 (.A1(n85), .A2(n53), .B1(n56), .B2(n84), .X(Q[11]));
  SEH_INV_S_3 U49 (.A(REG_INTERNAL[15]), .X(n77));
  SEH_OAI22_3 U50 (.A1(n79), .A2(n53), .B1(n56), .B2(n78), .X(Q[14]));
  SEH_OAI22_3 U20 (.A1(n89), .A2(n53), .B1(n57), .B2(n88), .X(Q[9]));
  SEH_OAI22_3 U56 (.A1(n83), .A2(n53), .B1(n57), .B2(n82), .X(Q[12]));
  SEH_INV_S_3 U19 (.A(n56), .X(n53));
  SEH_INV_S_3 U25 (.A(REG_INTERNAL[8]), .X(n91));
  SEH_INV_S_3 U52 (.A(REG_INTERNAL[14]), .X(n79));
  SEH_OAI22_3 U47 (.A1(n77), .A2(n53), .B1(n56), .B2(n76), .X(Q[15]));
  SEH_INV_S_3 U74 (.A(n56), .X(n75));
  SEH_INV_S_3 U46 (.A(REG_INTERNAL[1]), .X(n105));
  SEH_BUF_3 U71 (.A(SELM), .X(n57));
  SEH_OAI22_3 U35 (.A1(n99), .A2(n75), .B1(n57), .B2(n98), .X(Q[4]));
  SEH_OAI22_3 U53 (.A1(n81), .A2(n53), .B1(n57), .B2(n80), .X(Q[13]));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_15_ (.CK(CLK_2), .D(n58), 
     .Q(REG_INTERNAL[15]), .RD(n74_2));
  SEH_INV_S_3 U61 (.A(REG_INTERNAL[11]), .X(n85));
  SEH_OAI22_3 U16 (.A1(n54), .A2(n79), .B1(n106), .B2(n78), .X(n59));
  SEH_OAI22_3 U12 (.A1(n54), .A2(n87), .B1(n106), .B2(n86), .X(n63));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_8_ (.CK(CLK_1), .D(n65), .Q(REG_INTERNAL[8]), 
     .RD(n74_1));
  SEH_INV_S_3 U22 (.A(REG_INTERNAL[9]), .X(n89));
  SEH_OAI22_3 U62 (.A1(n87), .A2(n53), .B1(n57), .B2(n86), .X(Q[10]));
  SEH_OAI22_3 U38 (.A1(n101), .A2(n75), .B1(SELM), .B2(n100), .X(Q[3]));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_3_ (.CK(CLK_5), .D(n70), .Q(REG_INTERNAL[3]), 
     .RD(n74));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_1_ (.CK(CLK_5), .D(n72), .Q(REG_INTERNAL[1]), 
     .RD(n74));
  SEH_INV_S_3 U40 (.A(REG_INTERNAL[3]), .X(n101));
  SEH_INV_S_3 U43 (.A(REG_INTERNAL[2]), .X(n103));
  SEH_INV_S_3 U37 (.A(REG_INTERNAL[4]), .X(n99));
  SEH_INV_S_3 U68 (.A(REG_INTERNAL[0]), .X(n108));
  SEH_INV_S_3 U28 (.A(REG_INTERNAL[7]), .X(n93));
  SEH_BUF_3 U70 (.A(SELM), .X(n56));
  SEH_OAI22_3 U44 (.A1(n105), .A2(n75), .B1(n57), .B2(n104), .X(Q[1]));
  SEH_OAI22_3 U65 (.A1(n108), .A2(n75), .B1(n57), .B2(n107), .X(Q[0]));
  SEH_OAI22_3 U26 (.A1(n93), .A2(n75), .B1(n57), .B2(n92), .X(Q[7]));
  SEH_INV_S_3 U48 (.A(D[15]), .X(n76));
  SEH_INV_S_3 U58 (.A(REG_INTERNAL[12]), .X(n83));
  SEH_INV_S_3 U55 (.A(REG_INTERNAL[13]), .X(n81));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_12_ (.CK(CLK_2), .D(n61), 
     .Q(REG_INTERNAL[12]), .RD(n74_2));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_10_ (.CK(CLK_1), .D(n63), 
     .Q(REG_INTERNAL[10]), .RD(n74_2));
  SEH_OAI22_3 U14 (.A1(n54), .A2(n83), .B1(n106), .B2(n82), .X(n61));
  SEH_INV_S_3 U73 (.A(n54), .X(n106));
  SEH_BUF_D_3 BW1_BUF3190 (.A(n74_1), .X(n74_2));
  SEH_OAI22_3 U32 (.A1(n97), .A2(n75), .B1(n56), .B2(n96), .X(Q[5]));
  SEH_INV_S_3 U34 (.A(REG_INTERNAL[5]), .X(n97));
  SEH_OAI22_3 U41 (.A1(n103), .A2(n75), .B1(n56), .B2(n102), .X(Q[2]));
  SEH_OAI22_3 U29 (.A1(n95), .A2(n75), .B1(SELM), .B2(n94), .X(Q[6]));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_9_ (.CK(CLK_1), .D(n64), .Q(REG_INTERNAL[9]), 
     .RD(n74_2));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_14_ (.CK(CLK_2), .D(n59), 
     .Q(REG_INTERNAL[14]), .RD(n74_2));
  SEH_INV_S_3 U64 (.A(REG_INTERNAL[10]), .X(n87));
  SEH_INV_S_3 U54 (.A(D[13]), .X(n80));
  SEH_INV_S_3 U57 (.A(D[12]), .X(n82));
  SEH_INV_S_3 U51 (.A(D[14]), .X(n78));
  SEH_BUF_D_3 BW1_BUF1411 (.A(n74), .X(n74_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_4_ (.CK(CLK_1), .D(n69), .Q(REG_INTERNAL[4]), 
     .RD(n74_1));
  SEH_BUF_3 U67 (.A(ENA), .X(n54));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_6_ (.CK(CLK_1), .D(n67), .Q(REG_INTERNAL[6]), 
     .RD(n74_1));
  SEH_INV_S_3 U17 (.A(n54), .X(n52));
  SEH_BUF_3 U69 (.A(ENA), .X(n55));
  SEH_OAI22_3 U6 (.A1(ENA), .A2(n99), .B1(n52), .B2(n98), .X(n69));
  SEH_OAI22_3 U8 (.A1(n54), .A2(n95), .B1(n52), .B2(n94), .X(n67));
  SEH_OAI22_3 U9 (.A1(n55), .A2(n93), .B1(n52), .B2(n92), .X(n66));
  SEH_OAI22_3 U11 (.A1(n55), .A2(n89), .B1(n106), .B2(n88), .X(n64));
  SEH_OAI22_3 U13 (.A1(n55), .A2(n85), .B1(n106), .B2(n84), .X(n62));
  SEH_INV_S_3 U31 (.A(REG_INTERNAL[6]), .X(n95));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_0_ (.CK(CLK_1), .D(n73), .Q(REG_INTERNAL[0]), 
     .RD(n74_1));
  SEH_OAI22_3 U2 (.A1(ENA), .A2(n108), .B1(n107), .B2(n52), .X(n73));
  SEH_OAI22_3 U3 (.A1(ENA), .A2(n105), .B1(n52), .B2(n104), .X(n72));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_13_ (.CK(CLK_2), .D(n60), 
     .Q(REG_INTERNAL[13]), .RD(n74_2));
  SEH_OAI22_3 U4 (.A1(ENA), .A2(n103), .B1(n52), .B2(n102), .X(n71));
  SEH_OAI22_3 U10 (.A1(n54), .A2(n91), .B1(n106), .B2(n90), .X(n65));
  SEH_INV_S_3 U45 (.A(D[1]), .X(n104));
  SEH_INV_S_3 U42 (.A(D[2]), .X(n102));
  SEH_INV_S_3 U36 (.A(D[4]), .X(n98));
  SEH_OAI22_3 U5 (.A1(ENA), .A2(n101), .B1(n52), .B2(n100), .X(n70));
  SEH_DEL_L6_1 OPTHOLD_G_1 (.A(RST), .X(RST_1));
  SEH_OAI22_3 U7 (.A1(n55), .A2(n97), .B1(n52), .B2(n96), .X(n68));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_7_ (.CK(CLK_1), .D(n66), .Q(REG_INTERNAL[7]), 
     .RD(n74_1));
  SEH_OAI22_3 U15 (.A1(n55), .A2(n81), .B1(n106), .B2(n80), .X(n60));
  SEH_OAI22_3 U18 (.A1(n55), .A2(n77), .B1(n106), .B2(n76), .X(n58));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_11_ (.CK(CLK_2), .D(n62), 
     .Q(REG_INTERNAL[11]), .RD(n74_2));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_5_ (.CK(CLK_1), .D(n68), .Q(REG_INTERNAL[5]), 
     .RD(n74_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_2_ (.CK(CLK_5), .D(n71), .Q(REG_INTERNAL[2]), 
     .RD(n74_1));
endmodule

// Entity:REG_BYPASS_MUX_2 Model:REG_BYPASS_MUX_2 Library:magma_checknetlist_lib
module REG_BYPASS_MUX_2 (D, Q, ENA, CLK, RST, SELM, CLK_8, CLK_10);
  input ENA, CLK, RST, SELM, CLK_8, CLK_10;
  input [15:0] D;
  output [15:0] Q;
  wire [15:0] REG_INTERNAL;
  wire n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, 
     n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, 
     n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, 
     n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, 
     n74_1, n74_2, CLK_1, RST_1;
  SEH_OAI22_S_6 U59 (.A1(n85), .A2(n75), .B1(n56), .B2(n84), .X(Q[11]));
  SEH_INV_S_3 U17 (.A(n54), .X(n52));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_2_ (.CK(CLK_8), .D(n71), .Q(REG_INTERNAL[2]), 
     .RD(n74));
  SEH_OAI22_8 U50 (.A1(n79), .A2(n53), .B1(n57), .B2(n78), .X(Q[14]));
  SEH_OAI22_3 U2 (.A1(ENA), .A2(n108), .B1(n107), .B2(n52), .X(n73));
  SEH_OAI22_3 U8 (.A1(n54), .A2(n95), .B1(n52), .B2(n94), .X(n67));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_0_ (.CK(CLK_8), .D(n73), .Q(REG_INTERNAL[0]), 
     .RD(n74));
  SEH_OAI22_3 U16 (.A1(n54), .A2(n79), .B1(n106), .B2(n78), .X(n59));
  SEH_OAI22_3 U12 (.A1(n54), .A2(n87), .B1(n106), .B2(n86), .X(n63));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_6_ (.CK(CLK_1), .D(n67), .Q(REG_INTERNAL[6]), 
     .RD(n74_2));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_10_ (.CK(CLK_1), .D(n63), 
     .Q(REG_INTERNAL[10]), .RD(n74_2));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_14_ (.CK(CLK_1), .D(n59), 
     .Q(REG_INTERNAL[14]), .RD(n74_2));
  SEH_OAI22_3 U29 (.A1(n95), .A2(n53), .B1(n57), .B2(n94), .X(Q[6]));
  SEH_INV_S_3 U74 (.A(REG_INTERNAL[0]), .X(n108));
  SEH_INV_S_3 U43 (.A(REG_INTERNAL[2]), .X(n103));
  SEH_OAI22_8 U62 (.A1(n87), .A2(n53), .B1(n56), .B2(n86), .X(Q[10]));
  SEH_BUF_8 CLK_L0 (.A(CLK), .X(CLK_1));
  SEH_INV_S_3 U52 (.A(REG_INTERNAL[14]), .X(n79));
  SEH_OAI22_3 U14 (.A1(n54), .A2(n83), .B1(n106), .B2(n82), .X(n61));
  SEH_INV_S_3 U58 (.A(REG_INTERNAL[12]), .X(n83));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_12_ (.CK(CLK_10), .D(n61), 
     .Q(REG_INTERNAL[12]), .RD(n74_2));
  SEH_OAI22_3 U32 (.A1(n97), .A2(n75), .B1(n57), .B2(n96), .X(Q[5]));
  SEH_INV_S_3 U61 (.A(REG_INTERNAL[11]), .X(n85));
  SEH_OAI22_3 U7 (.A1(n55), .A2(n97), .B1(n52), .B2(n96), .X(n68));
  SEH_INV_S_3 U51 (.A(D[14]), .X(n78));
  SEH_INV_S_3 U48 (.A(D[15]), .X(n76));
  SEH_INV_S_3 U64 (.A(REG_INTERNAL[10]), .X(n87));
  SEH_OAI22_3 U71 (.A1(n108), .A2(n53), .B1(n57), .B2(n107), .X(Q[0]));
  SEH_OAI22_3 U35 (.A1(n99), .A2(n53), .B1(n56), .B2(n98), .X(Q[4]));
  SEH_INV_S_3 U19 (.A(n56), .X(n53));
  SEH_DEL_L6_1 OPTHOLD_G_9 (.A(RST), .X(RST_1));
  SEH_INV_S_3 U31 (.A(REG_INTERNAL[6]), .X(n95));
  SEH_OAI22_3 U41 (.A1(n103), .A2(n53), .B1(n57), .B2(n102), .X(Q[2]));
  SEH_BUF_S_3 U68 (.A(SELM), .X(n57));
  SEH_INV_S_3 U73 (.A(n54), .X(n106));
  SEH_OAI22_3 U10 (.A1(n54), .A2(n91), .B1(n106), .B2(n90), .X(n65));
  SEH_INV_S_3 U25 (.A(REG_INTERNAL[8]), .X(n91));
  SEH_INV_S_3 U34 (.A(REG_INTERNAL[5]), .X(n97));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_5_ (.CK(CLK_1), .D(n68), .Q(REG_INTERNAL[5]), 
     .RD(n74_2));
  SEH_INV_S_3 U22 (.A(REG_INTERNAL[9]), .X(n89));
  SEH_BUF_D_3 BW1_BUF3194 (.A(n74_1), .X(n74_2));
  SEH_OAI22_3 U26 (.A1(n93), .A2(n75), .B1(n56), .B2(n92), .X(Q[7]));
  SEH_INV_S_3 U69 (.A(n56), .X(n75));
  SEH_INV_S_3 U49 (.A(REG_INTERNAL[15]), .X(n77));
  SEH_BUF_3 U67 (.A(SELM), .X(n56));
  SEH_INV_S_3 U66 (.A(D[0]), .X(n107));
  SEH_INV_S_3 U30 (.A(D[6]), .X(n94));
  SEH_INV_S_3 U42 (.A(D[2]), .X(n102));
  SEH_INV_S_3 U27 (.A(D[7]), .X(n92));
  SEH_INV_S_3 U55 (.A(REG_INTERNAL[13]), .X(n81));
  SEH_INV_S_3 U36 (.A(D[4]), .X(n98));
  SEH_INV_S_3 U45 (.A(D[1]), .X(n104));
  SEH_OAI22_3 U4 (.A1(ENA), .A2(n103), .B1(n52), .B2(n102), .X(n71));
  SEH_OAI22_3 U38 (.A1(n101), .A2(n75), .B1(n57), .B2(n100), .X(Q[3]));
  SEH_OAI22_3 U44 (.A1(n105), .A2(n75), .B1(n56), .B2(n104), .X(Q[1]));
  SEH_INV_S_3 U40 (.A(REG_INTERNAL[3]), .X(n101));
  SEH_BUF_3 U23 (.A(ENA), .X(n54));
  SEH_BUF_D_3 BW1_BUF1815 (.A(n74), .X(n74_1));
  SEH_INV_S_3 U46 (.A(REG_INTERNAL[1]), .X(n105));
  SEH_INV_S_3 U70 (.A(RST_1), .X(n74));
  SEH_INV_S_3 U37 (.A(REG_INTERNAL[4]), .X(n99));
  SEH_INV_S_3 U63 (.A(D[10]), .X(n86));
  SEH_INV_S_3 U60 (.A(D[11]), .X(n84));
  SEH_INV_S_3 U21 (.A(D[9]), .X(n88));
  SEH_OAI22_3 U18 (.A1(n55), .A2(n77), .B1(n106), .B2(n76), .X(n58));
  SEH_INV_S_3 U57 (.A(D[12]), .X(n82));
  SEH_INV_S_3 U28 (.A(REG_INTERNAL[7]), .X(n93));
  SEH_BUF_3 U65 (.A(ENA), .X(n55));
  SEH_INV_S_3 U33 (.A(D[5]), .X(n96));
  SEH_OAI22_T_3 U47 (.A1(n77), .A2(n75), .B1(n57), .B2(n76), .X(Q[15]));
  SEH_OAI22_3 U5 (.A1(ENA), .A2(n101), .B1(n52), .B2(n100), .X(n70));
  SEH_OAI22_3 U3 (.A1(ENA), .A2(n105), .B1(n52), .B2(n104), .X(n72));
  SEH_OAI22_3 U15 (.A1(n55), .A2(n81), .B1(n106), .B2(n80), .X(n60));
  SEH_OAI22_3 U9 (.A1(n55), .A2(n93), .B1(n52), .B2(n92), .X(n66));
  SEH_OAI22_8 U53 (.A1(n81), .A2(n75), .B1(n56), .B2(n80), .X(Q[13]));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_15_ (.CK(CLK_1), .D(n58), 
     .Q(REG_INTERNAL[15]), .RD(n74_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_3_ (.CK(CLK_8), .D(n70), .Q(REG_INTERNAL[3]), 
     .RD(n74));
  SEH_OAI22_3 U11 (.A1(n55), .A2(n89), .B1(n106), .B2(n88), .X(n64));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_4_ (.CK(CLK_8), .D(n69), .Q(REG_INTERNAL[4]), 
     .RD(n74_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_9_ (.CK(CLK_10), .D(n64), .Q(REG_INTERNAL[9]), 
     .RD(n74_1));
  SEH_INV_S_3 U39 (.A(D[3]), .X(n100));
  SEH_OAI22_8 U72 (.A1(n91), .A2(n53), .B1(SELM), .B2(n90), .X(Q[8]));
  SEH_OAI22_S_6 U56 (.A1(n83), .A2(n53), .B1(n57), .B2(n82), .X(Q[12]));
  SEH_OAI22_S_6 U20 (.A1(n89), .A2(n75), .B1(SELM), .B2(n88), .X(Q[9]));
  SEH_INV_S_3 U54 (.A(D[13]), .X(n80));
  SEH_INV_S_3 U24 (.A(D[8]), .X(n90));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_8_ (.CK(CLK_10), .D(n65), .Q(REG_INTERNAL[8]), 
     .RD(n74_1));
  SEH_OAI22_3 U13 (.A1(n55), .A2(n85), .B1(n106), .B2(n84), .X(n62));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_1_ (.CK(CLK_8), .D(n72), .Q(REG_INTERNAL[1]), 
     .RD(n74_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_7_ (.CK(CLK_1), .D(n66), .Q(REG_INTERNAL[7]), 
     .RD(n74_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_13_ (.CK(CLK_1), .D(n60), 
     .Q(REG_INTERNAL[13]), .RD(n74_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_11_ (.CK(CLK_1), .D(n62), 
     .Q(REG_INTERNAL[11]), .RD(n74_2));
  SEH_OAI22_3 U6 (.A1(ENA), .A2(n99), .B1(n52), .B2(n98), .X(n69));
endmodule

// Entity:REG_BYPASS_MUX_3 Model:REG_BYPASS_MUX_3 Library:magma_checknetlist_lib
module REG_BYPASS_MUX_3 (D, Q, ENA, CLK, RST, SELM, CLK_9, CLK_11);
  input ENA, CLK, RST, SELM, CLK_9, CLK_11;
  input [15:0] D;
  output [15:0] Q;
  wire [15:0] REG_INTERNAL;
  wire n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, 
     n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, 
     n32, n33, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, 
     n48, n49, n50, n51, n34, n52, n53, n54, n55, n56, n57, n58, n35_1, n35_2, 
     CLK_1, RST_1;
  SEH_BUF_S_16 CLK_L0 (.A(CLK), .X(CLK_1));
  SEH_OAI22_S_8 U41 (.A1(n1), .A2(n34), .B1(n54), .B2(n2), .X(Q[0]));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_3_ (.CK(CLK_11), .D(n39), .Q(REG_INTERNAL[3]), 
     .RD(n35_2));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_4_ (.CK(CLK_11), .D(n40), .Q(REG_INTERNAL[4]), 
     .RD(n35_2));
  SEH_OAI22_S_8 U70 (.A1(n8), .A2(n52), .B1(SELM), .B2(n9), .X(Q[3]));
  SEH_OAI22_8 U62 (.A1(n24), .A2(n52), .B1(n54), .B2(n25), .X(Q[11]));
  SEH_OAI22_8 U44 (.A1(n30), .A2(n52), .B1(SELM), .B2(n31), .X(Q[14]));
  SEH_OAI22_S_8 U67 (.A1(n10), .A2(n34), .B1(n58), .B2(n11), .X(Q[4]));
  SEH_OAI22_S_8 U35 (.A1(n4), .A2(n52), .B1(n58), .B2(n5), .X(Q[1]));
  SEH_OAI22_S_8 U38 (.A1(n6), .A2(n34), .B1(SELM), .B2(n7), .X(Q[2]));
  SEH_OAI22_8 U53 (.A1(n28), .A2(n52), .B1(n54), .B2(n29), .X(Q[13]));
  SEH_OAI22_S_8 U59 (.A1(n22), .A2(n34), .B1(n54), .B2(n23), .X(Q[10]));
  SEH_INV_S_3 U29 (.A(n53), .X(n54));
  SEH_INV_S_3 U61 (.A(REG_INTERNAL[11]), .X(n24));
  SEH_OAI22_3 U7 (.A1(n57), .A2(n12), .B1(n55), .B2(n13), .X(n41));
  SEH_OAI22_S_6 U40 (.A1(n20), .A2(n52), .B1(n54), .B2(n21), .X(Q[9]));
  SEH_INV_S_3 U22 (.A(n58), .X(n52));
  SEH_BUF_3 U17 (.A(SELM), .X(n58));
  SEH_INV_S_3 U37 (.A(REG_INTERNAL[4]), .X(n10));
  SEH_INV_S_3 U20 (.A(n58), .X(n34));
  SEH_OAI22_S_8 U26 (.A1(n16), .A2(n34), .B1(n54), .B2(n17), .X(Q[7]));
  SEH_OAI22_3 U11 (.A1(n57), .A2(n20), .B1(n3), .B2(n21), .X(n45));
  SEH_OAI22_4 U47 (.A1(n32), .A2(n34), .B1(n54), .B2(n33), .X(Q[15]));
  SEH_OAI22_3 U32 (.A1(n12), .A2(n52), .B1(n58), .B2(n13), .X(Q[5]));
  SEH_INV_S_3 U58 (.A(REG_INTERNAL[12]), .X(n26));
  SEH_INV_S_3 U49 (.A(REG_INTERNAL[15]), .X(n32));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_9_ (.CK(CLK_1), .D(n45), .Q(REG_INTERNAL[9]), 
     .RD(n35_1));
  SEH_INV_S_3 U25 (.A(REG_INTERNAL[8]), .X(n18));
  SEH_INV_S_3 U64 (.A(REG_INTERNAL[10]), .X(n22));
  SEH_INV_S_3 U74 (.A(REG_INTERNAL[9]), .X(n20));
  SEH_INV_S_3 U55 (.A(REG_INTERNAL[13]), .X(n28));
  SEH_INV_S_3 U72 (.A(n57), .X(n3));
  SEH_INV_S_3 U34 (.A(REG_INTERNAL[5]), .X(n12));
  SEH_INV_S_3 U28 (.A(REG_INTERNAL[7]), .X(n16));
  SEH_INV_S_3 U46 (.A(REG_INTERNAL[1]), .X(n4));
  SEH_OAI22_3 U3 (.A1(n56), .A2(n4), .B1(n55), .B2(n5), .X(n37));
  SEH_OAI22_S_8 U56 (.A1(n14), .A2(n52), .B1(n58), .B2(n15), .X(Q[6]));
  SEH_OAI22_S_6 U19 (.A1(n18), .A2(n34), .B1(n58), .B2(n19), .X(Q[8]));
  SEH_INV_S_3 U23 (.A(n58), .X(n53));
  SEH_OAI22_3 U13 (.A1(n57), .A2(n24), .B1(n3), .B2(n25), .X(n47));
  SEH_INV_S_3 U31 (.A(REG_INTERNAL[6]), .X(n14));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_7_ (.CK(CLK_11), .D(n43), .Q(REG_INTERNAL[7]), 
     .RD(n35_1));
  SEH_INV_S_3 U52 (.A(REG_INTERNAL[14]), .X(n30));
  SEH_OAI22_3 U9 (.A1(n57), .A2(n16), .B1(n55), .B2(n17), .X(n43));
  SEH_OAI22_8 U50 (.A1(n26), .A2(n34), .B1(n54), .B2(n27), .X(Q[12]));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_11_ (.CK(CLK_1), .D(n47), 
     .Q(REG_INTERNAL[11]), .RD(n35_1));
  SEH_INV_S_3 U24 (.A(D[8]), .X(n19));
  SEH_INV_S_3 U33 (.A(D[5]), .X(n13));
  SEH_INV_S_3 U30 (.A(D[6]), .X(n15));
  SEH_INV_S_3 U65 (.A(ENA), .X(n55));
  SEH_INV_S_3 U60 (.A(D[11]), .X(n25));
  SEH_OAI22_3 U6 (.A1(n56), .A2(n10), .B1(n55), .B2(n11), .X(n40));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_1_ (.CK(CLK_11), .D(n37), .Q(REG_INTERNAL[1]), 
     .RD(n35_2));
  SEH_INV_S_3 U75 (.A(REG_INTERNAL[0]), .X(n1));
  SEH_INV_S_3 U43 (.A(REG_INTERNAL[2]), .X(n6));
  SEH_OAI22_3 U2 (.A1(n56), .A2(n1), .B1(n2), .B2(n55), .X(n36));
  SEH_INV_S_3 U73 (.A(REG_INTERNAL[3]), .X(n8));
  SEH_OAI22_3 U5 (.A1(n56), .A2(n8), .B1(n55), .B2(n9), .X(n39));
  SEH_INV_S_3 U42 (.A(D[2]), .X(n7));
  SEH_INV_S_3 U54 (.A(D[13]), .X(n29));
  SEH_INV_S_3 U57 (.A(D[12]), .X(n27));
  SEH_BUF_3 U69 (.A(ENA), .X(n57));
  SEH_INV_S_3 U36 (.A(D[4]), .X(n11));
  SEH_INV_S_3 U48 (.A(D[15]), .X(n33));
  SEH_INV_S_3 U71 (.A(RST_1), .X(n35));
  SEH_INV_S_3 U51 (.A(D[14]), .X(n31));
  SEH_INV_S_3 U21 (.A(D[9]), .X(n21));
  SEH_BUF_D_3 BW1_BUF1533 (.A(n35), .X(n35_1));
  SEH_INV_S_3 U63 (.A(D[10]), .X(n23));
  SEH_BUF_3 U68 (.A(ENA), .X(n56));
  SEH_OAI22_3 U16 (.A1(n56), .A2(n30), .B1(n3), .B2(n31), .X(n50));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_6_ (.CK(CLK_11), .D(n42), .Q(REG_INTERNAL[6]), 
     .RD(n35_2));
  SEH_INV_S_3 U27 (.A(D[7]), .X(n17));
  SEH_OAI22_3 U14 (.A1(ENA), .A2(n26), .B1(n3), .B2(n27), .X(n48));
  SEH_OAI22_3 U15 (.A1(n57), .A2(n28), .B1(n3), .B2(n29), .X(n49));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_8_ (.CK(CLK_1), .D(n44), .Q(REG_INTERNAL[8]), 
     .RD(n35_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_13_ (.CK(CLK_1), .D(n49), 
     .Q(REG_INTERNAL[13]), .RD(n35));
  SEH_OAI22_3 U12 (.A1(ENA), .A2(n22), .B1(n3), .B2(n23), .X(n46));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_10_ (.CK(CLK_1), .D(n46), 
     .Q(REG_INTERNAL[10]), .RD(n35_1));
  SEH_INV_S_3 U66 (.A(D[0]), .X(n2));
  SEH_INV_S_3 U39 (.A(D[3]), .X(n9));
  SEH_INV_S_3 U45 (.A(D[1]), .X(n5));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_12_ (.CK(CLK_9), .D(n48), 
     .Q(REG_INTERNAL[12]), .RD(n35));
  SEH_DEL_L6_1 OPTHOLD_G_2 (.A(RST), .X(RST_1));
  SEH_BUF_D_3 BW1_BUF3223 (.A(n35_1), .X(n35_2));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_0_ (.CK(CLK_11), .D(n36), .Q(REG_INTERNAL[0]), 
     .RD(n35_2));
  SEH_OAI22_3 U8 (.A1(ENA), .A2(n14), .B1(n55), .B2(n15), .X(n42));
  SEH_OAI22_3 U18 (.A1(n57), .A2(n32), .B1(n3), .B2(n33), .X(n51));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_15_ (.CK(CLK_1), .D(n51), 
     .Q(REG_INTERNAL[15]), .RD(n35));
  SEH_OAI22_3 U4 (.A1(n56), .A2(n6), .B1(n55), .B2(n7), .X(n38));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_14_ (.CK(CLK_1), .D(n50), 
     .Q(REG_INTERNAL[14]), .RD(n35_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_5_ (.CK(CLK_1), .D(n41), .Q(REG_INTERNAL[5]), 
     .RD(n35_1));
  SEH_FDPRBQ_V2_3 REG_INTERNAL_reg_2_ (.CK(CLK_11), .D(n38), .Q(REG_INTERNAL[2]), 
     .RD(n35_2));
  SEH_OAI22_3 U10 (.A1(ENA), .A2(n18), .B1(n3), .B2(n19), .X(n44));
endmodule
