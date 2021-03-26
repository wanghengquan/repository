//
// Astro Hierarchical Verilog Dump:
// Generated on 09/18/2008 at 00:25:42
// Library Name :ECO_091708
// Cell Name    :smc_and_jtag
// Hierarchy delimiter:'/'
//


module cfg_smc (spi_clk_out_GB_G4B2I4ASTHIRNet247 , 
    spi_clk_out_GB_G4B2I2ASTHIRNet137 , spi_clk_out_GB_G4B2I3ASTHIRNet47 , 
    clk , rst_b , cnt_podt_out , startup_req , shutdown_req , 
    warmboot_req , reboot_source_nvcm , end_of_startup , end_of_shutdown , 
    md_jtag , spi_ss_in_b , cram_done , nvcm_boot , nvcm_rdy , 
    sample_mode_done , md_spi , cram_clr , cfg_ld_bstream , cfg_startup , 
    cfg_shutdown , cram_access_en , cram_clr_done , cram_clr_done_r , 
    fpga_operation , spi_master_go , smc_load_nvcm_bstream );
input  spi_clk_out_GB_G4B2I4ASTHIRNet247 ;
input  spi_clk_out_GB_G4B2I2ASTHIRNet137 ;
input  spi_clk_out_GB_G4B2I3ASTHIRNet47 ;
input  clk ;
input  rst_b ;
input  cnt_podt_out ;
input  startup_req ;
input  shutdown_req ;
input  warmboot_req ;
input  reboot_source_nvcm ;
input  end_of_startup ;
input  end_of_shutdown ;
input  md_jtag ;
input  spi_ss_in_b ;
input  cram_done ;
input  nvcm_boot ;
input  nvcm_rdy ;
output sample_mode_done ;
output md_spi ;
output cram_clr ;
output cfg_ld_bstream ;
output cfg_startup ;
output cfg_shutdown ;
output cram_access_en ;
output cram_clr_done ;
output cram_clr_done_r ;
output fpga_operation ;
output spi_master_go ;
output smc_load_nvcm_bstream ;

/* wire declarations */

wire n606 ;
wire n621 ;
wire n646 ;
wire n598 ;
wire n639 ;
wire n647 ;
wire n641 ;
wire n642 ;
wire cfg_state_0_ ;
wire n643 ;
wire n632 ;
wire cfg_next_2_ ;
wire n645 ;
wire n625 ;
wire n623 ;
wire n629 ;
wire n599 ;
wire n627 ;
wire n630 ;
wire n609 ;
wire n626 ;
wire n610 ;
wire cfg_state_2_ ;
wire n611 ;
wire n612 ;
wire n635 ;
wire n602 ;
wire n601 ;
wire n608 ;
wire cfg_next_1_ ;
wire n628 ;
wire n603 ;
wire n604 ;
wire n607 ;
wire n605 ;
wire n631 ;
wire n613 ;
wire n619 ;
wire n620 ;
wire n638 ;
wire n651 ;
wire n615 ;
wire n617 ;
wire n652 ;
wire n637 ;
wire n622 ;
wire cfg_next_3_ ;
wire n633 ;
wire n444 ;
wire n_199 ;
wire n648 ;
wire spi_master_go382 ;
wire n649 ;
wire cram_clr307 ;
wire n650 ;
wire cfg_ld_bstream516 ;
wire n644 ;
wire n640 ;
wire cfg_next_0_ ;
wire cfg_state_3_ ;
wire cfg_state_1_ ;
wire n636 ;
wire cram_access_en528 ;
wire cfg_shutdown522 ;
wire fpga_operation510 ;
wire n624 ;
wire n653 ;
wire n634 ;

CKND0HVT U185 (.I ( n606 ) , .ZN ( n621 ) ) ;
AO31D0HVT U221 (.B ( n646 ) , .A1 ( n598 ) , .Z ( n639 ) , .A3 ( n647 ) 
    , .A2 ( n641 ) ) ;
MUX2D0HVT U230 (.I1 ( n642 ) , .Z ( n647 ) , .S ( cfg_state_0_ ) , .I0 ( rst_b ) ) ;
CKND0HVT U192 (.I ( n643 ) , .ZN ( n632 ) ) ;
CKND0HVT U193 (.I ( cfg_next_2_ ) , .ZN ( n645 ) ) ;
CKND0HVT U194 (.I ( n625 ) , .ZN ( md_spi ) ) ;
CKND0HVT U195 (.I ( cram_done ) , .ZN ( n642 ) ) ;
CKND0HVT U201 (.I ( end_of_startup ) , .ZN ( n623 ) ) ;
CKND0HVT U173 (.I ( n598 ) , .ZN ( n629 ) ) ;
CKND0HVT U175 (.I ( n599 ) , .ZN ( n627 ) ) ;
CKND0HVT U177 (.I ( cfg_startup ) , .ZN ( n630 ) ) ;
NR3D0HVT U184 (.A1 ( n609 ) , .ZN ( n606 ) , .A2 ( n641 ) , .A3 ( n626 ) ) ;
NR3D0HVT U196 (.A1 ( cfg_state_0_ ) , .ZN ( n610 ) , .A2 ( n641 ) , .A3 ( n629 ) ) ;
NR3D0HVT U197 (.A1 ( cfg_state_2_ ) , .ZN ( n611 ) , .A2 ( cfg_state_0_ ) 
    , .A3 ( n626 ) ) ;
NR3D0HVT U198 (.A1 ( n641 ) , .ZN ( n612 ) , .A2 ( n609 ) , .A3 ( n629 ) ) ;
NR3D0HVT U174 (.A1 ( cfg_state_2_ ) , .ZN ( n599 ) , .A2 ( n609 ) , .A3 ( n626 ) ) ;
ND2D0HVT U178 (.ZN ( n635 ) , .A1 ( n602 ) , .A2 ( n601 ) ) ;
CKND0HVT U188 (.I ( n608 ) , .ZN ( cfg_next_1_ ) ) ;
CKND0HVT U191 (.I ( cnt_podt_out ) , .ZN ( n628 ) ) ;
OAI32D0HVT U180 (.ZN ( n603 ) , .A3 ( n625 ) , .B1 ( nvcm_rdy ) , .A1 ( n628 ) 
    , .A2 ( n627 ) , .B2 ( n643 ) ) ;
OAI211D0HVT U181 (.ZN ( cfg_next_2_ ) , .A1 ( n621 ) , .C ( n604 ) 
    , .A2 ( n607 ) , .B ( n605 ) ) ;
AOI211D0HVT U182 (.ZN ( n604 ) , .A2 ( n632 ) , .C ( n631 ) , .A1 ( nvcm_rdy ) 
    , .B ( cfg_startup ) ) ;
OAI21D0HVT U183 (.A2 ( n599 ) , .ZN ( n605 ) , .A1 ( n611 ) , .B ( n625 ) ) ;
AN3D0HVT U186 (.Z ( n607 ) , .A2 ( end_of_shutdown ) , .A1 ( warmboot_req ) 
    , .A3 ( reboot_source_nvcm ) ) ;
NR4D0HVT U187 (.A2 ( n613 ) , .A3 ( n619 ) , .A4 ( n620 ) , .A1 ( n638 ) 
    , .ZN ( n608 ) ) ;
NR4D0HVT U199 (.A2 ( n642 ) , .A3 ( n609 ) , .A4 ( n629 ) , .A1 ( cfg_state_2_ ) 
    , .ZN ( n613 ) ) ;
NR3D0HVT U176 (.A1 ( cfg_state_0_ ) , .ZN ( cfg_startup ) , .A2 ( n641 ) 
    , .A3 ( n626 ) ) ;
CKBD0HVT U200 (.I ( n651 ) , .Z ( sample_mode_done ) ) ;
CKND8HVT U202 (.I ( n615 ) , .ZN ( smc_load_nvcm_bstream ) ) ;
CKND8HVT U204 (.I ( n617 ) , .ZN ( cram_clr ) ) ;
INVD0HVT U203 (.ZN ( n617 ) , .I ( n652 ) ) ;
TIEHHVT U205 (.Z ( n637 ) ) ;
AO21D0HVT U214 (.B ( n611 ) , .A1 ( n599 ) , .Z ( n622 ) , .A2 ( n628 ) ) ;
AO21D0HVT U179 (.B ( n603 ) , .A1 ( n606 ) , .Z ( cfg_next_3_ ) , .A2 ( n607 ) ) ;
AO21D0HVT U206 (.B ( n612 ) , .A1 ( end_of_startup ) , .Z ( n646 ) 
    , .A2 ( cfg_startup ) ) ;
CKND16HVT U208 (.ZN ( n633 ) , .I ( n444 ) ) ;
CKND16HVT U215 (.ZN ( n444 ) , .I ( spi_clk_out_GB_G4B2I4ASTHIRNet247 ) ) ;
CKND1HVT U223 (.ZN ( n_199 ) , .I ( n648 ) ) ;
CKND1HVT U225 (.ZN ( spi_master_go382 ) , .I ( n649 ) ) ;
CKND1HVT U227 (.ZN ( cram_clr307 ) , .I ( n650 ) ) ;
CKND1HVT U228 (.ZN ( cfg_ld_bstream516 ) , .I ( n644 ) ) ;
CKND1HVT U229 (.ZN ( n640 ) , .I ( cfg_next_0_ ) ) ;
IND2D0HVT U189 (.A1 ( cfg_state_3_ ) , .B1 ( cfg_state_1_ ) , .ZN ( n626 ) ) ;
OA21D0HVT U210 (.B ( n612 ) , .A1 ( warmboot_req ) , .Z ( n619 ) 
    , .A2 ( shutdown_req ) ) ;
OR2D0HVT U211 (.A2 ( n636 ) , .A1 ( md_jtag ) , .Z ( n625 ) ) ;
OR2D0HVT U212 (.A2 ( n612 ) , .A1 ( n610 ) , .Z ( n631 ) ) ;
OR2D0HVT U216 (.A2 ( n639 ) , .A1 ( n638 ) , .Z ( cfg_next_0_ ) ) ;
OR2D0HVT U218 (.A2 ( cram_clr307 ) , .A1 ( cfg_ld_bstream516 ) 
    , .Z ( cram_access_en528 ) ) ;
OR2D0HVT U224 (.A2 ( n644 ) , .A1 ( n643 ) , .Z ( n649 ) ) ;
MOAI22D0HVT U213 (.ZN ( n620 ) , .B2 ( n610 ) , .A1 ( end_of_startup ) 
    , .A2 ( n630 ) , .B1 ( startup_req ) ) ;
MOAI22D0HVT U207 (.ZN ( n638 ) , .B2 ( n622 ) , .A1 ( end_of_shutdown ) 
    , .A2 ( n621 ) , .B1 ( md_spi ) ) ;
EDFCND1HVT sample_mode_done_reg (.E ( n_199 ) 
    , .CP ( spi_clk_out_GB_G4B2I2ASTHIRNet137 ) , .D ( n637 ) , .Q ( n651 ) 
    , .CDN ( rst_b ) ) ;
INR3D0HVT U217 (.ZN ( cfg_shutdown522 ) , .B2 ( n640 ) , .A1 ( cfg_next_2_ ) 
    , .B1 ( n608 ) ) ;
INR3D0HVT U219 (.ZN ( fpga_operation510 ) , .B2 ( n640 ) , .A1 ( cfg_next_2_ ) 
    , .B1 ( cfg_next_1_ ) ) ;
INR3D0HVT U190 (.B2 ( n643 ) , .A1 ( nvcm_boot ) , .ZN ( n624 ) , .B1 ( n625 ) ) ;
DFNCND1HVT cram_clr_done_r_reg (.Q ( cram_clr_done_r ) , .CDN ( rst_b ) 
    , .QN ( n601 ) , .D ( n635 ) , .CPN ( n633 ) ) ;
DFNCND1HVT cram_clr_done_reg (.Q ( cram_clr_done ) , .CDN ( rst_b ) 
    , .QN ( n602 ) , .D ( n611 ) , .CPN ( spi_clk_out_GB_G4B2I3ASTHIRNet47 ) ) ;
DFNCND1HVT smc_load_nvcm_bstream_reg (.Q ( n653 ) , .CDN ( rst_b ) 
    , .QN ( n615 ) , .D ( n634 ) , .CPN ( n633 ) ) ;
AO211D0HVT U209 (.Z ( n634 ) , .A2 ( n623 ) , .C ( reboot_source_nvcm ) 
    , .A1 ( n653 ) , .B ( n624 ) ) ;
DFCNQD1HVT cfg_state_reg_1_ (.D ( cfg_next_1_ ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet47 ) , .Q ( cfg_state_1_ ) 
    , .CDN ( rst_b ) ) ;
DFCNQD1HVT cfg_ld_bstream_reg (.D ( cfg_ld_bstream516 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet47 ) , .Q ( cfg_ld_bstream ) 
    , .CDN ( rst_b ) ) ;
DFCNQD1HVT cram_clr_reg (.D ( cram_clr307 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet47 ) , .Q ( n652 ) , .CDN ( rst_b ) ) ;
DFCNQD1HVT cfg_shutdown_reg (.D ( cfg_shutdown522 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet47 ) , .Q ( cfg_shutdown ) 
    , .CDN ( rst_b ) ) ;
DFCNQD1HVT spi_master_go_reg (.D ( spi_master_go382 ) 
    , .CP ( spi_clk_out_GB_G4B2I2ASTHIRNet137 ) , .Q ( spi_master_go ) 
    , .CDN ( rst_b ) ) ;
DFCND1HVT cfg_state_reg_2_ (.Q ( cfg_state_2_ ) , .CDN ( rst_b ) , .QN ( n641 ) 
    , .D ( cfg_next_2_ ) , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet47 ) ) ;
DFCND1HVT cfg_state_reg_0_ (.Q ( cfg_state_0_ ) , .CDN ( rst_b ) , .QN ( n609 ) 
    , .D ( cfg_next_0_ ) , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet47 ) ) ;
EDFCND1HVT md_spi_reg_reg (.E ( n_199 ) 
    , .CP ( spi_clk_out_GB_G4B2I2ASTHIRNet137 ) , .D ( spi_ss_in_b ) 
    , .QN ( n636 ) , .CDN ( rst_b ) ) ;
IND4D1HVT U171 (.ZN ( n643 ) , .A1 ( cfg_state_1_ ) , .B3 ( n609 ) 
    , .B2 ( n641 ) , .B1 ( cfg_state_3_ ) ) ;
NR2D0HVT U172 (.A1 ( cfg_state_3_ ) , .A2 ( cfg_state_1_ ) , .ZN ( n598 ) ) ;
OR3D0HVT U220 (.A1 ( cfg_next_1_ ) , .A2 ( cfg_next_0_ ) , .Z ( n644 ) 
    , .A3 ( n645 ) ) ;
OR3D0HVT U222 (.A1 ( n608 ) , .A2 ( cfg_next_0_ ) , .Z ( n648 ) 
    , .A3 ( cfg_next_2_ ) ) ;
OR3D0HVT U226 (.A1 ( n640 ) , .A2 ( cfg_next_1_ ) , .Z ( n650 ) 
    , .A3 ( cfg_next_2_ ) ) ;
DFCNQD1HVT fpga_operation_reg (.D ( fpga_operation510 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet47 ) , .Q ( fpga_operation ) 
    , .CDN ( rst_b ) ) ;
DFCNQD1HVT cram_access_en_reg (.D ( cram_access_en528 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet47 ) , .Q ( cram_access_en ) 
    , .CDN ( rst_b ) ) ;
DFCNQD1HVT cfg_state_reg_3_ (.D ( cfg_next_3_ ) 
    , .CP ( spi_clk_out_GB_G4B2I2ASTHIRNet137 ) , .Q ( cfg_state_3_ ) 
    , .CDN ( rst_b ) ) ;
endmodule




module bram_smc_DW01_dec_16_0 (A , SUM );
input  [15:0] A ;
output [15:0] SUM ;

/* wire declarations */

wire carry_11 ;
wire carry_12 ;
wire carry_2 ;
wire carry_3 ;
wire carry_5 ;
wire carry_6 ;
wire carry_10 ;
wire carry_7 ;
wire carry_8 ;
wire carry_13 ;
wire carry_14 ;
wire carry_15 ;
wire carry_9 ;
wire carry_4 ;

OR2D0HVT U1_B_11 (.A2 ( carry_11 ) , .A1 ( A[11] ) , .Z ( carry_12 ) ) ;
OR2D0HVT U1_B_2 (.A2 ( carry_2 ) , .A1 ( A[2] ) , .Z ( carry_3 ) ) ;
OR2D0HVT U1_B_5 (.A2 ( carry_5 ) , .A1 ( A[5] ) , .Z ( carry_6 ) ) ;
OR2D0HVT U1_B_10 (.A2 ( carry_10 ) , .A1 ( A[10] ) , .Z ( carry_11 ) ) ;
OR2D0HVT U1_B_1 (.A2 ( A[0] ) , .A1 ( A[1] ) , .Z ( carry_2 ) ) ;
INVD0HVT U6 (.I ( A[0] ) , .ZN ( SUM[0] ) ) ;
OR2D0HVT U1_B_7 (.A2 ( carry_7 ) , .A1 ( A[7] ) , .Z ( carry_8 ) ) ;
OR2D0HVT U1_B_12 (.A2 ( carry_12 ) , .A1 ( A[12] ) , .Z ( carry_13 ) ) ;
OR2D0HVT U1_B_6 (.A2 ( carry_6 ) , .A1 ( A[6] ) , .Z ( carry_7 ) ) ;
OR2D0HVT U1_B_13 (.A2 ( carry_13 ) , .A1 ( A[13] ) , .Z ( carry_14 ) ) ;
OR2D0HVT U1_B_14 (.A2 ( carry_14 ) , .A1 ( A[14] ) , .Z ( carry_15 ) ) ;
OR2D0HVT U1_B_8 (.A2 ( carry_8 ) , .A1 ( A[8] ) , .Z ( carry_9 ) ) ;
OR2D0HVT U1_B_3 (.A2 ( carry_3 ) , .A1 ( A[3] ) , .Z ( carry_4 ) ) ;
OR2D0HVT U1_B_4 (.A2 ( carry_4 ) , .A1 ( A[4] ) , .Z ( carry_5 ) ) ;
XNR2D0HVT U1_A_14 (.A2 ( carry_14 ) , .ZN ( SUM[14] ) , .A1 ( A[14] ) ) ;
XNR2D0HVT U1_A_8 (.A2 ( carry_8 ) , .ZN ( SUM[8] ) , .A1 ( A[8] ) ) ;
XNR2D0HVT U1_A_15 (.A2 ( carry_15 ) , .ZN ( SUM[15] ) , .A1 ( A[15] ) ) ;
XNR2D0HVT U1_A_9 (.A2 ( carry_9 ) , .ZN ( SUM[9] ) , .A1 ( A[9] ) ) ;
XNR2D0HVT U1_A_7 (.A2 ( carry_7 ) , .ZN ( SUM[7] ) , .A1 ( A[7] ) ) ;
XNR2D0HVT U1_A_12 (.A2 ( carry_12 ) , .ZN ( SUM[12] ) , .A1 ( A[12] ) ) ;
XNR2D0HVT U1_A_6 (.A2 ( carry_6 ) , .ZN ( SUM[6] ) , .A1 ( A[6] ) ) ;
OR2D0HVT U1_B_9 (.A2 ( carry_9 ) , .A1 ( A[9] ) , .Z ( carry_10 ) ) ;
XNR2D0HVT U1_A_2 (.A2 ( carry_2 ) , .ZN ( SUM[2] ) , .A1 ( A[2] ) ) ;
XNR2D0HVT U1_A_5 (.A2 ( carry_5 ) , .ZN ( SUM[5] ) , .A1 ( A[5] ) ) ;
XNR2D0HVT U1_A_10 (.A2 ( carry_10 ) , .ZN ( SUM[10] ) , .A1 ( A[10] ) ) ;
XNR2D0HVT U1_A_3 (.A2 ( carry_3 ) , .ZN ( SUM[3] ) , .A1 ( A[3] ) ) ;
XNR2D0HVT U1_A_4 (.A2 ( carry_4 ) , .ZN ( SUM[4] ) , .A1 ( A[4] ) ) ;
XNR2D0HVT U1_A_11 (.A2 ( carry_11 ) , .ZN ( SUM[11] ) , .A1 ( A[11] ) ) ;
XNR2D0HVT U1_A_13 (.A2 ( carry_13 ) , .ZN ( SUM[13] ) , .A1 ( A[13] ) ) ;
XNR2D0HVT U1_A_1 (.A2 ( A[0] ) , .ZN ( SUM[1] ) , .A1 ( A[1] ) ) ;
endmodule




module bram_smc_DW01_dec_9_0 (A , SUM );
input  [8:0] A ;
output [8:0] SUM ;

/* wire declarations */

wire carry_3 ;
wire carry_4 ;
wire carry_5 ;
wire carry_2 ;
wire carry_6 ;
wire carry_7 ;
wire carry_8 ;

INVD0HVT U6 (.I ( A[0] ) , .ZN ( SUM[0] ) ) ;
OR2D0HVT U1_B_3 (.A2 ( carry_3 ) , .A1 ( A[3] ) , .Z ( carry_4 ) ) ;
OR2D0HVT U1_B_4 (.A2 ( carry_4 ) , .A1 ( A[4] ) , .Z ( carry_5 ) ) ;
OR2D0HVT U1_B_2 (.A2 ( carry_2 ) , .A1 ( A[2] ) , .Z ( carry_3 ) ) ;
OR2D0HVT U1_B_5 (.A2 ( carry_5 ) , .A1 ( A[5] ) , .Z ( carry_6 ) ) ;
OR2D0HVT U1_B_1 (.A2 ( A[0] ) , .A1 ( A[1] ) , .Z ( carry_2 ) ) ;
OR2D0HVT U1_B_7 (.A2 ( carry_7 ) , .A1 ( A[7] ) , .Z ( carry_8 ) ) ;
OR2D0HVT U1_B_6 (.A2 ( carry_6 ) , .A1 ( A[6] ) , .Z ( carry_7 ) ) ;
XNR2D0HVT U1_A_6 (.A2 ( carry_6 ) , .ZN ( SUM[6] ) , .A1 ( A[6] ) ) ;
XNR2D0HVT U1_A_1 (.A2 ( A[0] ) , .ZN ( SUM[1] ) , .A1 ( A[1] ) ) ;
XNR2D0HVT U1_A_8 (.A2 ( carry_8 ) , .ZN ( SUM[8] ) , .A1 ( A[8] ) ) ;
XNR2D0HVT U1_A_7 (.A2 ( carry_7 ) , .ZN ( SUM[7] ) , .A1 ( A[7] ) ) ;
XNR2D0HVT U1_A_2 (.A2 ( carry_2 ) , .ZN ( SUM[2] ) , .A1 ( A[2] ) ) ;
XNR2D0HVT U1_A_5 (.A2 ( carry_5 ) , .ZN ( SUM[5] ) , .A1 ( A[5] ) ) ;
XNR2D0HVT U1_A_3 (.A2 ( carry_3 ) , .ZN ( SUM[3] ) , .A1 ( A[3] ) ) ;
XNR2D0HVT U1_A_4 (.A2 ( carry_4 ) , .ZN ( SUM[4] ) , .A1 ( A[4] ) ) ;
endmodule




module bram_smc_DW01_inc_8_0 (A , SUM );
input  [7:0] A ;
output [7:0] SUM ;

/* wire declarations */

wire carry_6 ;
wire carry_7 ;
wire carry_2 ;
wire carry_3 ;
wire carry_4 ;
wire carry_5 ;

HA1D0HVT U1_1_6 (.S ( SUM[6] ) , .A ( A[6] ) , .B ( carry_6 ) , .CO ( carry_7 ) ) ;
HA1D0HVT U1_1_2 (.S ( SUM[2] ) , .A ( A[2] ) , .B ( carry_2 ) , .CO ( carry_3 ) ) ;
HA1D0HVT U1_1_3 (.S ( SUM[3] ) , .A ( A[3] ) , .B ( carry_3 ) , .CO ( carry_4 ) ) ;
HA1D0HVT U1_1_4 (.S ( SUM[4] ) , .A ( A[4] ) , .B ( carry_4 ) , .CO ( carry_5 ) ) ;
HA1D0HVT U1_1_5 (.S ( SUM[5] ) , .A ( A[5] ) , .B ( carry_5 ) , .CO ( carry_6 ) ) ;
HA1D0HVT U1_1_1 (.S ( SUM[1] ) , .A ( A[1] ) , .B ( A[0] ) , .CO ( carry_2 ) ) ;
CKND0HVT U5 (.I ( A[0] ) , .ZN ( SUM[0] ) ) ;
CKXOR2D0HVT U6 (.Z ( SUM[7] ) , .A2 ( A[7] ) , .A1 ( carry_7 ) ) ;
endmodule




module bram_smc (flen , spi_clk_out_GB_G4B2I23ASTHIRNet280 , 
    spi_clk_out_GB_G4B2I15ASTHIRNet130 , spi_clk_out_GB_G4B2I25ASTHIRNet111 , 
    spi_clk_out_GB_G4B2I22ASTHIRNet75 , spi_clk_out_GB_G4B2I19ASTHIRNet55 , 
    baddr , fnum , start_fnum , bm_sa , rst_b , tm_dis_bram_clk_gating , 
    bm_banksel , cor_en_8bconfig , cor_security_rddis , 
    cor_security_wrtdis , gwe , bram_access_en , bram_reading , clk , 
    clk_b , bm_sweb , bm_sreb , bm_sclkrw , bm_wdummymux_en , 
    bm_rcapmux_en , bm_init , bram_wrt , bram_rd , 
    spi_clk_out_GB_G4B2I17ASTHIRNet238 , spi_clk_out_GB_G4B2I24ASTHIRNet217 , 
    clk_b_G5B1I1ASTHIRNet208 , spi_clk_out_GB_G4B2I21ASTHIRNet182 , 
    spi_clk_out_GB_G4B2I5ASTHIRNet172 , spi_clk_out_GB_G4B2I18ASTHIRNet150 , 
    bram_done , bm_clk );
input  [15:0] flen ;
input  spi_clk_out_GB_G4B2I23ASTHIRNet280 ;
input  spi_clk_out_GB_G4B2I15ASTHIRNet130 ;
input  spi_clk_out_GB_G4B2I25ASTHIRNet111 ;
input  spi_clk_out_GB_G4B2I22ASTHIRNet75 ;
input  spi_clk_out_GB_G4B2I19ASTHIRNet55 ;
input  [1:0] baddr ;
input  [8:0] fnum ;
input  [8:0] start_fnum ;
output [7:0] bm_sa ;
input  rst_b ;
input  tm_dis_bram_clk_gating ;
output [3:0] bm_banksel ;
input  cor_en_8bconfig ;
input  cor_security_rddis ;
input  cor_security_wrtdis ;
input  gwe ;
input  bram_access_en ;
output bram_reading ;
input  clk ;
input  clk_b ;
output bm_sweb ;
output bm_sreb ;
output bm_sclkrw ;
output bm_wdummymux_en ;
output bm_rcapmux_en ;
output bm_init ;
input  bram_wrt ;
input  bram_rd ;
input  spi_clk_out_GB_G4B2I17ASTHIRNet238 ;
input  spi_clk_out_GB_G4B2I24ASTHIRNet217 ;
input  clk_b_G5B1I1ASTHIRNet208 ;
input  spi_clk_out_GB_G4B2I21ASTHIRNet182 ;
input  spi_clk_out_GB_G4B2I5ASTHIRNet172 ;
input  spi_clk_out_GB_G4B2I18ASTHIRNet150 ;
output bram_done ;
output bm_clk ;

/* wire declarations */
wire flencnt_7_ ;
wire flencnt_6_ ;
wire flencnt_5_ ;
wire flencnt_4_ ;
wire flencnt_3_ ;
wire flencnt_2_ ;
wire flencnt_1_ ;
wire flencnt_0_ ;
wire flencnt_15_ ;
wire flencnt_14_ ;
wire flencnt_13_ ;
wire flencnt_12_ ;
wire flencnt_11_ ;
wire flencnt_10_ ;
wire flencnt_9_ ;
wire flencnt_8_ ;
wire flencnt356_7 ;
wire flencnt356_6 ;
wire flencnt356_5 ;
wire flencnt356_4 ;
wire flencnt356_3 ;
wire flencnt356_2 ;
wire flencnt356_1 ;
wire flencnt356_0 ;
wire flencnt356_15 ;
wire flencnt356_14 ;
wire flencnt356_13 ;
wire flencnt356_12 ;
wire flencnt356_11 ;
wire flencnt356_10 ;
wire flencnt356_9 ;
wire flencnt356_8 ;
wire fnumcnt_1_ ;
wire fnumcnt_0_ ;
wire fnumcnt435_0 ;
wire fnumcnt_8_ ;
wire fnumcnt_7_ ;
wire fnumcnt_6_ ;
wire fnumcnt_5_ ;
wire fnumcnt_4_ ;
wire fnumcnt_3_ ;
wire fnumcnt_2_ ;
wire fnumcnt435_8 ;
wire fnumcnt435_7 ;
wire fnumcnt435_6 ;
wire fnumcnt435_5 ;
wire fnumcnt435_4 ;
wire fnumcnt435_3 ;
wire fnumcnt435_2 ;
wire fnumcnt435_1 ;
wire n1155 ;
wire n1156 ;
wire n1157 ;
wire n1158 ;
wire n1159 ;
wire n1160 ;
wire bm_sa_Q692_1 ;
wire n1161 ;
wire bm_sa671_7 ;
wire bm_sa671_6 ;
wire bm_sa671_5 ;
wire bm_sa671_4 ;
wire bm_sa671_3 ;
wire bm_sa671_2 ;
wire bm_sa671_1 ;
wire bm_sa671_0 ;

wire n1049 ;
wire n1052 ;
wire n1054 ;
wire n1062 ;
wire n1115 ;
wire n1056 ;
wire n1163 ;
wire n1057 ;
wire n1135 ;
wire n1059 ;
wire n1116 ;
wire n1058 ;
wire n1120 ;
wire n1131 ;
wire n1061 ;
wire n_609 ;
wire n1113 ;
wire n1150 ;
wire n1125 ;
wire n1140 ;
wire n1151 ;
wire n1132 ;
wire n1068 ;
wire n1069 ;
wire n1070 ;
wire n1117 ;
wire n1067 ;
wire n1106 ;
wire n1107 ;
wire n1110 ;
wire n1112 ;
wire n1133 ;
wire n1129 ;
wire n1128 ;
wire n1130 ;
wire n1111 ;
wire n1108 ;
wire n1124 ;
wire n1126 ;
wire state_0_ ;
wire n434_0 ;
wire n1149 ;
wire n1164 ;
wire n1139 ;
wire n1109 ;
wire n1105 ;
wire n1136 ;
wire n1118 ;
wire n_642 ;
wire n1127 ;
wire bm_sweb735 ;
wire n1137 ;
wire n1119 ;
wire state_1_ ;
wire n1063 ;
wire flencnt354_14 ;
wire n1121 ;
wire dummycnt247_0 ;
wire n1064 ;
wire n1065 ;
wire n1066 ;
wire n1060 ;
wire flencnt354_12 ;
wire flencnt354_11 ;
wire flencnt354_10 ;
wire flencnt354_9 ;
wire flencnt354_8 ;
wire flencnt354_7 ;
wire flencnt354_3 ;
wire flencnt354_15 ;
wire flencnt354_4 ;
wire flencnt354_0 ;
wire flencnt354_5 ;
wire flencnt354_1 ;
wire flencnt354_2 ;
wire bm_sa669_7 ;
wire bm_sa669_6 ;
wire flencnt354_13 ;
wire bm_sa669_5 ;
wire fnumcnt433_7 ;
wire fnumcnt433_6 ;
wire bm_sa669_4 ;
wire fnumcnt433_5 ;
wire fnumcnt433_4 ;
wire bm_sa669_3 ;
wire flencnt354_6 ;
wire bm_sa669_0 ;
wire bm_sa669_1 ;
wire bm_sa669_2 ;
wire fnumcnt433_0 ;
wire fnumcnt433_3 ;
wire fnumcnt433_1 ;
wire fnumcnt433_2 ;
wire fnumcnt433_8 ;
wire n1100 ;
wire n1085 ;
wire rst_bASThfnNet22 ;
wire rst_bASThfnNet21 ;
wire next_1_ ;
wire n1134 ;
wire next_0_ ;
wire n1073 ;
wire n1154 ;
wire n1075 ;
wire n1166 ;
wire n1077 ;
wire n1162 ;
wire n1079 ;
wire n1165 ;
wire n1089 ;
wire n1091 ;
wire n1093 ;
wire n1095 ;
wire bram_clk_en_i ;
wire n246_0 ;
wire dummycnt245_3 ;
wire n1102 ;
wire n1098 ;
wire n1081 ;
wire n1083 ;
wire n1087 ;
wire dummycnt245_2 ;
wire n1101 ;
wire dummycnt245_1 ;
wire n1104 ;
wire dummycnt_1 ;
wire dummycnt245_0 ;
wire dummycnt_0 ;
wire n1138 ;
wire n1114 ;
wire n1051 ;
wire n1050 ;
wire n670_0 ;
wire bram_reading_int_d3 ;
wire n_654 ;
wire bram_reading_int ;
wire bram_done495 ;
wire bram_reading_int_d1 ;
wire bram_reading_int_d2 ;
wire bm_sclkrw789 ;
wire dummycnt247_3 ;
wire n1103 ;
wire n1141 ;
wire n1142 ;
wire n1143 ;
wire n1144 ;
wire n1145 ;
wire n1146 ;
wire n1147 ;
wire n1123 ;
wire n1153 ;
wire n1122 ;
wire n1152 ;
wire n1037 ;
wire n1148 ;
wire dummycnt247_2 ;
wire n1039 ;
wire n1048 ;
wire n1038 ;
wire n1042 ;
wire n1041 ;
wire n1040 ;
wire n1043 ;
wire n1046 ;
wire n1045 ;
wire n1044 ;
wire n1047 ;
wire n1053 ;
wire n1055 ;


bram_smc_DW01_dec_16_0 sub_241 (
    .A ( {flencnt_15_ , flencnt_14_ , flencnt_13_ , flencnt_12_ , 
	flencnt_11_ , flencnt_10_ , flencnt_9_ , flencnt_8_ , flencnt_7_ , 
	flencnt_6_ , flencnt_5_ , flencnt_4_ , flencnt_3_ , flencnt_2_ , 
	flencnt_1_ , flencnt_0_ } ) , 
    .SUM ( {flencnt356_15 , flencnt356_14 , flencnt356_13 , flencnt356_12 , 
	flencnt356_11 , flencnt356_10 , flencnt356_9 , flencnt356_8 , 
	flencnt356_7 , flencnt356_6 , flencnt356_5 , flencnt356_4 , 
	flencnt356_3 , flencnt356_2 , flencnt356_1 , flencnt356_0 } ) ) ;


bram_smc_DW01_dec_9_0 sub_260 (
    .A ( {fnumcnt_8_ , fnumcnt_7_ , fnumcnt_6_ , fnumcnt_5_ , fnumcnt_4_ , 
	fnumcnt_3_ , fnumcnt_2_ , fnumcnt_1_ , fnumcnt_0_ } ) , 
    .SUM ( {fnumcnt435_8 , fnumcnt435_7 , fnumcnt435_6 , fnumcnt435_5 , 
	fnumcnt435_4 , fnumcnt435_3 , fnumcnt435_2 , fnumcnt435_1 , 
	fnumcnt435_0 } ) ) ;


bram_smc_DW01_inc_8_0 add_330 (
    .A ( {n1155 , n1156 , n1157 , n1158 , n1159 , n1160 , bm_sa_Q692_1 , 
	n1161 } ) , 
    .SUM ( {bm_sa671_7 , bm_sa671_6 , bm_sa671_5 , bm_sa671_4 , bm_sa671_3 , 
	bm_sa671_2 , bm_sa671_1 , bm_sa671_0 } ) ) ;

NR3D0HVT U374 (.A1 ( fnumcnt_3_ ) , .ZN ( n1049 ) , .A2 ( fnumcnt_2_ ) 
    , .A3 ( fnumcnt_7_ ) ) ;
NR3D0HVT U377 (.A1 ( flencnt_14_ ) , .ZN ( n1052 ) , .A2 ( flencnt_12_ ) 
    , .A3 ( flencnt_5_ ) ) ;
NR3D0HVT U379 (.A1 ( flencnt_13_ ) , .ZN ( n1054 ) , .A2 ( flencnt_15_ ) 
    , .A3 ( flencnt_6_ ) ) ;
NR3D0HVT U399 (.A1 ( flencnt_1_ ) , .ZN ( n1062 ) , .A2 ( flencnt_0_ ) 
    , .A3 ( n1115 ) ) ;
MUX2ND0HVT U382 (.ZN ( n1056 ) , .I0 ( n1163 ) , .S ( bram_rd ) 
    , .I1 ( bram_wrt ) ) ;
NR2D3HVT U391 (.A1 ( n1057 ) , .A2 ( n1135 ) , .ZN ( n1059 ) ) ;
CKND0HVT U384 (.I ( n1057 ) , .ZN ( n1116 ) ) ;
CKND0HVT U390 (.I ( n1058 ) , .ZN ( n1120 ) ) ;
CKND0HVT U392 (.I ( n1059 ) , .ZN ( n1131 ) ) ;
CKND0HVT U397 (.I ( n1061 ) , .ZN ( n_609 ) ) ;
CKND0HVT U404 (.I ( n1113 ) , .ZN ( n1150 ) ) ;
IND2D0HVT U385 (.A1 ( n1113 ) , .B1 ( n1062 ) , .ZN ( n1125 ) ) ;
IND2D0HVT U405 (.A1 ( n1140 ) , .B1 ( cor_en_8bconfig ) , .ZN ( n1151 ) ) ;
IND2D0HVT U406 (.A1 ( n1132 ) , .B1 ( bram_access_en ) , .ZN ( n1140 ) ) ;
CKND0HVT U408 (.I ( n1068 ) , .ZN ( n1069 ) ) ;
CKND0HVT U409 (.I ( n1068 ) , .ZN ( n1070 ) ) ;
CKND0HVT U410 (.I ( n1117 ) , .ZN ( n1067 ) ) ;
CKND0HVT U415 (.I ( n1140 ) , .ZN ( n1106 ) ) ;
CKND0HVT U416 (.I ( n1151 ) , .ZN ( n1107 ) ) ;
CKND0HVT U417 (.I ( baddr[1] ) , .ZN ( n1110 ) ) ;
CKND0HVT U418 (.I ( bram_wrt ) , .ZN ( n1112 ) ) ;
CKND0HVT U419 (.I ( bram_rd ) , .ZN ( n1133 ) ) ;
OAI31D0HVT U389 (.A2 ( n1129 ) , .A1 ( n1128 ) , .ZN ( n1058 ) , .A3 ( n1130 ) 
    , .B ( n1131 ) ) ;
OAI31D1HVT U400 (.A2 ( baddr[1] ) , .A1 ( baddr[0] ) , .ZN ( n1111 ) 
    , .A3 ( n1140 ) , .B ( n1151 ) ) ;
OAI31D2HVT U401 (.A2 ( baddr[0] ) , .A1 ( n1110 ) , .ZN ( n1108 ) 
    , .A3 ( n1140 ) , .B ( n1151 ) ) ;
OA22D0HVT U402 (.A2 ( n1133 ) , .B1 ( cor_security_wrtdis ) , .Z ( n1132 ) 
    , .B2 ( n1112 ) , .A1 ( cor_security_rddis ) ) ;
INR3D0HVT U407 (.B2 ( n1124 ) , .A1 ( bram_wrt ) , .ZN ( n1126 ) 
    , .B1 ( state_0_ ) ) ;
CKND0HVT U425 (.I ( n1120 ) , .ZN ( n434_0 ) ) ;
CKND0HVT U442 (.I ( n1117 ) , .ZN ( n1149 ) ) ;
CKND0HVT U480 (.I ( n1164 ) , .ZN ( n1139 ) ) ;
BUFFD8HVT U412 (.Z ( bm_banksel[1] ) , .I ( n1109 ) ) ;
BUFFD8HVT U413 (.Z ( bm_banksel[2] ) , .I ( n1108 ) ) ;
BUFFD8HVT U414 (.Z ( bm_banksel[3] ) , .I ( n1105 ) ) ;
AO31D0HVT U423 (.B ( n1107 ) , .A1 ( baddr[0] ) , .Z ( n1105 ) , .A3 ( n1106 ) 
    , .A2 ( baddr[1] ) ) ;
AO31D0HVT U424 (.B ( n1107 ) , .A1 ( baddr[0] ) , .Z ( n1109 ) , .A3 ( n1106 ) 
    , .A2 ( n1110 ) ) ;
OAI22D0HVT U386 (.A2 ( n1136 ) , .A1 ( n1118 ) , .B2 ( n_642 ) , .ZN ( n1127 ) 
    , .B1 ( n1135 ) ) ;
OAI22D0HVT U388 (.A2 ( bm_sweb735 ) , .A1 ( n1137 ) , .B2 ( n1133 ) 
    , .ZN ( n1119 ) , .B1 ( n1135 ) ) ;
AN4D0HVT U387 (.A1 ( state_1_ ) , .Z ( n1063 ) , .A3 ( state_0_ ) 
    , .A2 ( bram_rd ) , .A4 ( n1125 ) ) ;
MUX2D0HVT U427 (.I1 ( flencnt356_14 ) , .Z ( flencnt354_14 ) , .S ( n1067 ) 
    , .I0 ( flen[14] ) ) ;
NR2D0HVT U443 (.ZN ( n1068 ) , .A2 ( n1117 ) , .A1 ( n1116 ) ) ;
NR2D0HVT U420 (.A1 ( n1121 ) , .A2 ( dummycnt247_0 ) , .ZN ( n1064 ) ) ;
NR2D0HVT U421 (.A1 ( n1112 ) , .A2 ( n1139 ) , .ZN ( n1065 ) ) ;
NR2D0HVT U422 (.A1 ( n1133 ) , .A2 ( n1139 ) , .ZN ( n1066 ) ) ;
NR2D0HVT U383 (.A1 ( bram_wrt ) , .A2 ( bram_rd ) , .ZN ( n1057 ) ) ;
NR2D0HVT U395 (.A1 ( bram_wrt ) , .A2 ( n1133 ) , .ZN ( n1060 ) ) ;
BUFFD8HVT U411 (.Z ( bm_banksel[0] ) , .I ( n1111 ) ) ;
MUX2D0HVT U429 (.I1 ( flencnt356_12 ) , .Z ( flencnt354_12 ) , .S ( n1067 ) 
    , .I0 ( flen[12] ) ) ;
MUX2D0HVT U430 (.I1 ( flencnt356_11 ) , .Z ( flencnt354_11 ) , .S ( n1067 ) 
    , .I0 ( flen[11] ) ) ;
MUX2D0HVT U431 (.I1 ( flencnt356_10 ) , .Z ( flencnt354_10 ) , .S ( n1067 ) 
    , .I0 ( flen[10] ) ) ;
MUX2D0HVT U432 (.I1 ( flencnt356_9 ) , .Z ( flencnt354_9 ) , .S ( n1067 ) 
    , .I0 ( flen[9] ) ) ;
MUX2D0HVT U433 (.I1 ( flencnt356_8 ) , .Z ( flencnt354_8 ) , .S ( n1067 ) 
    , .I0 ( flen[8] ) ) ;
MUX2D0HVT U434 (.I1 ( flencnt356_7 ) , .Z ( flencnt354_7 ) , .S ( n1149 ) 
    , .I0 ( flen[7] ) ) ;
MUX2D0HVT U435 (.I1 ( flencnt356_3 ) , .Z ( flencnt354_3 ) , .S ( n1149 ) 
    , .I0 ( flen[3] ) ) ;
MUX2D0HVT U426 (.I1 ( flencnt356_15 ) , .Z ( flencnt354_15 ) , .S ( n1067 ) 
    , .I0 ( flen[15] ) ) ;
MUX2D0HVT U437 (.I1 ( flencnt356_4 ) , .Z ( flencnt354_4 ) , .S ( n1149 ) 
    , .I0 ( flen[4] ) ) ;
MUX2D0HVT U438 (.I1 ( flencnt356_0 ) , .Z ( flencnt354_0 ) , .S ( n1149 ) 
    , .I0 ( flen[0] ) ) ;
MUX2D0HVT U439 (.I1 ( flencnt356_5 ) , .Z ( flencnt354_5 ) , .S ( n1149 ) 
    , .I0 ( flen[5] ) ) ;
MUX2D0HVT U440 (.I1 ( flencnt356_1 ) , .Z ( flencnt354_1 ) , .S ( n1149 ) 
    , .I0 ( flen[1] ) ) ;
MUX2D0HVT U441 (.I1 ( flencnt356_2 ) , .Z ( flencnt354_2 ) , .S ( n1149 ) 
    , .I0 ( flen[2] ) ) ;
MUX2D0HVT U446 (.I1 ( start_fnum[7] ) , .Z ( bm_sa669_7 ) , .S ( n1059 ) 
    , .I0 ( bm_sa671_7 ) ) ;
MUX2D0HVT U447 (.I1 ( start_fnum[6] ) , .Z ( bm_sa669_6 ) , .S ( n1059 ) 
    , .I0 ( bm_sa671_6 ) ) ;
MUX2D0HVT U428 (.I1 ( flencnt356_13 ) , .Z ( flencnt354_13 ) , .S ( n1067 ) 
    , .I0 ( flen[13] ) ) ;
MUX2D0HVT U449 (.I1 ( start_fnum[5] ) , .Z ( bm_sa669_5 ) , .S ( n1059 ) 
    , .I0 ( bm_sa671_5 ) ) ;
MUX2D0HVT U450 (.I1 ( fnum[7] ) , .Z ( fnumcnt433_7 ) , .S ( n1059 ) 
    , .I0 ( fnumcnt435_7 ) ) ;
MUX2D0HVT U451 (.I1 ( fnum[6] ) , .Z ( fnumcnt433_6 ) , .S ( n1059 ) 
    , .I0 ( fnumcnt435_6 ) ) ;
MUX2D0HVT U452 (.I1 ( start_fnum[4] ) , .Z ( bm_sa669_4 ) , .S ( n1059 ) 
    , .I0 ( bm_sa671_4 ) ) ;
MUX2D0HVT U453 (.I1 ( fnum[5] ) , .Z ( fnumcnt433_5 ) , .S ( n1059 ) 
    , .I0 ( fnumcnt435_5 ) ) ;
MUX2D0HVT U454 (.I1 ( fnum[4] ) , .Z ( fnumcnt433_4 ) , .S ( n1059 ) 
    , .I0 ( fnumcnt435_4 ) ) ;
MUX2D0HVT U455 (.I1 ( start_fnum[3] ) , .Z ( bm_sa669_3 ) , .S ( n1059 ) 
    , .I0 ( bm_sa671_3 ) ) ;
MUX2D0HVT U436 (.I1 ( flencnt356_6 ) , .Z ( flencnt354_6 ) , .S ( n1149 ) 
    , .I0 ( flen[6] ) ) ;
MUX2D0HVT U456 (.I1 ( start_fnum[0] ) , .Z ( bm_sa669_0 ) , .S ( n1059 ) 
    , .I0 ( bm_sa671_0 ) ) ;
MUX2D0HVT U457 (.I1 ( start_fnum[1] ) , .Z ( bm_sa669_1 ) , .S ( n1059 ) 
    , .I0 ( bm_sa671_1 ) ) ;
MUX2D0HVT U458 (.I1 ( start_fnum[2] ) , .Z ( bm_sa669_2 ) , .S ( n1059 ) 
    , .I0 ( bm_sa671_2 ) ) ;
MUX2D0HVT U459 (.I1 ( fnum[0] ) , .Z ( fnumcnt433_0 ) , .S ( n1059 ) 
    , .I0 ( fnumcnt435_0 ) ) ;
MUX2D0HVT U460 (.I1 ( fnum[3] ) , .Z ( fnumcnt433_3 ) , .S ( n1059 ) 
    , .I0 ( fnumcnt435_3 ) ) ;
MUX2D0HVT U461 (.I1 ( fnum[1] ) , .Z ( fnumcnt433_1 ) , .S ( n1059 ) 
    , .I0 ( fnumcnt435_1 ) ) ;
MUX2D0HVT U462 (.I1 ( fnum[2] ) , .Z ( fnumcnt433_2 ) , .S ( n1059 ) 
    , .I0 ( fnumcnt435_2 ) ) ;
MUX2D0HVT U448 (.I1 ( fnum[8] ) , .Z ( fnumcnt433_8 ) , .S ( n1059 ) 
    , .I0 ( fnumcnt435_8 ) ) ;
DFSND1HVT bm_sreb_reg (.D ( n1100 ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet182 ) , .QN ( n1085 ) , .Q ( n1163 ) 
    , .SDN ( rst_bASThfnNet22 ) ) ;
DFCND1HVT state_reg_1_ (.Q ( state_1_ ) , .CDN ( rst_bASThfnNet21 ) 
    , .QN ( n1124 ) , .D ( next_1_ ) , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet182 ) ) ;
DFCND1HVT state_reg_0_ (.Q ( state_0_ ) , .CDN ( rst_bASThfnNet22 ) 
    , .QN ( n1134 ) , .D ( next_0_ ) , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet182 ) ) ;
INVD0HVT U463 (.ZN ( n1073 ) , .I ( n1154 ) ) ;
INVD0HVT U465 (.ZN ( n1075 ) , .I ( n1166 ) ) ;
INVD0HVT U467 (.ZN ( n1077 ) , .I ( n1162 ) ) ;
INVD0HVT U469 (.ZN ( n1079 ) , .I ( n1165 ) ) ;
INVD2HVT U464 (.I ( n1073 ) , .ZN ( bm_clk ) ) ;
CKND8HVT U475 (.I ( n1089 ) , .ZN ( bm_sa[2] ) ) ;
CKND8HVT U476 (.I ( n1091 ) , .ZN ( bm_sa[3] ) ) ;
CKND8HVT U477 (.I ( n1093 ) , .ZN ( bm_sa[4] ) ) ;
CKND8HVT U478 (.I ( n1095 ) , .ZN ( bm_sa[5] ) ) ;
CKND8HVT U466 (.I ( n1075 ) , .ZN ( bm_rcapmux_en ) ) ;
CKND8HVT U468 (.I ( n1077 ) , .ZN ( bm_sweb ) ) ;
CKND8HVT U470 (.I ( n1079 ) , .ZN ( bm_wdummymux_en ) ) ;
CKLNQD8HVT BM_CLKb (.E ( bram_clk_en_i ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet172 ) , .Q ( n1154 ) 
    , .TE ( tm_dis_bram_clk_gating ) ) ;
EDFCND1HVT dummycnt_reg_3_ (.E ( n246_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet280 ) , .D ( dummycnt245_3 ) 
    , .QN ( n1102 ) , .CDN ( rst_bASThfnNet21 ) ) ;
CKND8HVT U479 (.I ( n1139 ) , .ZN ( bm_sclkrw ) ) ;
CKND8HVT U481 (.I ( n1098 ) , .ZN ( bm_sa[0] ) ) ;
CKND8HVT U506 (.I ( gwe ) , .ZN ( bm_init ) ) ;
CKND8HVT U471 (.I ( n1081 ) , .ZN ( bm_sa[7] ) ) ;
CKND8HVT U472 (.I ( n1083 ) , .ZN ( bm_sa[1] ) ) ;
CKND8HVT U473 (.I ( n1085 ) , .ZN ( bm_sreb ) ) ;
CKND8HVT U474 (.I ( n1087 ) , .ZN ( bm_sa[6] ) ) ;
EDFCND1HVT dummycnt_reg_2_ (.E ( n246_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet150 ) , .D ( dummycnt245_2 ) 
    , .QN ( n1101 ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT dummycnt_reg_1_ (.E ( n246_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet150 ) , .D ( dummycnt245_1 ) 
    , .QN ( n1104 ) , .Q ( dummycnt_1 ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT dummycnt_reg_0_ (.E ( n246_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet150 ) , .D ( dummycnt245_0 ) 
    , .QN ( dummycnt247_0 ) , .Q ( dummycnt_0 ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_15_ (.E ( n1069 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet280 ) , .D ( flencnt354_15 ) 
    , .Q ( flencnt_15_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_14_ (.E ( n1069 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet280 ) , .D ( flencnt354_14 ) 
    , .Q ( flencnt_14_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_13_ (.E ( n1070 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet280 ) , .D ( flencnt354_13 ) 
    , .Q ( flencnt_13_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_12_ (.E ( n1069 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet280 ) , .D ( flencnt354_12 ) 
    , .Q ( flencnt_12_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_11_ (.E ( n1069 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet280 ) , .D ( flencnt354_11 ) 
    , .Q ( flencnt_11_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_10_ (.E ( n1070 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet280 ) , .D ( flencnt354_10 ) 
    , .Q ( flencnt_10_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_9_ (.E ( n1070 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet111 ) , .D ( flencnt354_9 ) 
    , .Q ( flencnt_9_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_8_ (.E ( n1069 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet280 ) , .D ( flencnt354_8 ) 
    , .Q ( flencnt_8_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_7_ (.E ( n1070 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet111 ) , .D ( flencnt354_7 ) 
    , .Q ( flencnt_7_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_6_ (.E ( n1069 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet280 ) , .D ( flencnt354_6 ) 
    , .Q ( flencnt_6_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_5_ (.E ( n1070 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet238 ) , .D ( flencnt354_5 ) 
    , .Q ( flencnt_5_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_4_ (.E ( n1070 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet238 ) , .D ( flencnt354_4 ) 
    , .Q ( flencnt_4_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_3_ (.E ( n1069 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet238 ) , .D ( flencnt354_3 ) 
    , .Q ( flencnt_3_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_2_ (.E ( n1070 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet75 ) , .D ( flencnt354_2 ) 
    , .Q ( flencnt_2_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_1_ (.E ( n1070 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet238 ) , .D ( flencnt354_1 ) 
    , .QN ( n1138 ) , .Q ( flencnt_1_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT flencnt_reg_0_ (.E ( n1069 ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet182 ) , .D ( flencnt354_0 ) 
    , .QN ( n1114 ) , .Q ( flencnt_0_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT fnumcnt_reg_8_ (.E ( n434_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet111 ) , .D ( fnumcnt433_8 ) 
    , .Q ( fnumcnt_8_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT fnumcnt_reg_7_ (.E ( n434_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet111 ) , .D ( fnumcnt433_7 ) 
    , .Q ( fnumcnt_7_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT fnumcnt_reg_6_ (.E ( n1058 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet111 ) , .D ( fnumcnt433_6 ) 
    , .Q ( fnumcnt_6_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT fnumcnt_reg_5_ (.E ( n434_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet111 ) , .D ( fnumcnt433_5 ) 
    , .QN ( n1051 ) , .Q ( fnumcnt_5_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT fnumcnt_reg_4_ (.E ( n434_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet111 ) , .D ( fnumcnt433_4 ) 
    , .Q ( fnumcnt_4_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT fnumcnt_reg_3_ (.E ( n434_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet111 ) , .D ( fnumcnt433_3 ) 
    , .Q ( fnumcnt_3_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT fnumcnt_reg_2_ (.E ( n434_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet111 ) , .D ( fnumcnt433_2 ) 
    , .Q ( fnumcnt_2_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT fnumcnt_reg_1_ (.E ( n434_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet75 ) , .D ( fnumcnt433_1 ) 
    , .Q ( fnumcnt_1_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT fnumcnt_reg_0_ (.E ( n434_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet111 ) , .D ( fnumcnt433_0 ) 
    , .QN ( n1050 ) , .Q ( fnumcnt_0_ ) , .CDN ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT bm_sa_reg_7_ (.E ( n670_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet55 ) , .D ( bm_sa669_7 ) 
    , .QN ( n1081 ) , .Q ( n1155 ) , .CDN ( rst_bASThfnNet22 ) ) ;
EDFCND1HVT bm_sa_reg_6_ (.E ( n670_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet217 ) , .D ( bm_sa669_6 ) 
    , .QN ( n1087 ) , .Q ( n1156 ) , .CDN ( rst_bASThfnNet22 ) ) ;
EDFCND1HVT bm_sa_reg_5_ (.E ( n670_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet55 ) , .D ( bm_sa669_5 ) 
    , .QN ( n1095 ) , .Q ( n1157 ) , .CDN ( rst_bASThfnNet22 ) ) ;
EDFCND1HVT bm_sa_reg_4_ (.E ( n670_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet55 ) , .D ( bm_sa669_4 ) 
    , .QN ( n1093 ) , .Q ( n1158 ) , .CDN ( rst_bASThfnNet22 ) ) ;
DFCNQD1HVT bram_reading_int_d4_reg (.D ( bram_reading_int_d3 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet130 ) , .Q ( bram_reading ) 
    , .CDN ( rst_bASThfnNet22 ) ) ;
CKBD16HVT rst_b_regASThfnInst21 (.I ( rst_b ) , .Z ( rst_bASThfnNet21 ) ) ;
CKBD3HVT rst_b_regASThfnInst22 (.Z ( rst_bASThfnNet22 ) 
    , .I ( rst_bASThfnNet21 ) ) ;
EDFCND1HVT bm_sa_reg_3_ (.E ( n670_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet55 ) , .D ( bm_sa669_3 ) 
    , .QN ( n1091 ) , .Q ( n1159 ) , .CDN ( rst_bASThfnNet22 ) ) ;
EDFCND1HVT bm_sa_reg_2_ (.E ( n670_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet55 ) , .D ( bm_sa669_2 ) 
    , .QN ( n1089 ) , .Q ( n1160 ) , .CDN ( rst_bASThfnNet22 ) ) ;
EDFCND1HVT bm_sa_reg_1_ (.E ( n670_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet55 ) , .D ( bm_sa669_1 ) 
    , .QN ( n1083 ) , .Q ( bm_sa_Q692_1 ) , .CDN ( rst_bASThfnNet22 ) ) ;
EDFCND1HVT bm_sa_reg_0_ (.E ( n670_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet55 ) , .D ( bm_sa669_0 ) 
    , .QN ( n1098 ) , .Q ( n1161 ) , .CDN ( rst_bASThfnNet22 ) ) ;
EDFCND1HVT bram_reading_int_reg (.E ( n_654 ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet182 ) , .D ( n_609 ) 
    , .Q ( bram_reading_int ) , .CDN ( rst_bASThfnNet21 ) ) ;
DFCNQD1HVT bram_done_reg (.D ( bram_done495 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet130 ) , .Q ( bram_done ) 
    , .CDN ( rst_bASThfnNet22 ) ) ;
DFCNQD1HVT bram_reading_int_d1_reg (.D ( bram_reading_int ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet182 ) , .Q ( bram_reading_int_d1 ) 
    , .CDN ( rst_bASThfnNet22 ) ) ;
DFCNQD1HVT bm_rcapmux_en_reg (.D ( n1066 ) , .CP ( clk_b_G5B1I1ASTHIRNet208 ) 
    , .Q ( n1166 ) , .CDN ( rst_bASThfnNet22 ) ) ;
DFCNQD1HVT bram_reading_int_d3_reg (.D ( bram_reading_int_d2 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet130 ) , .Q ( bram_reading_int_d3 ) 
    , .CDN ( rst_bASThfnNet22 ) ) ;
DFCNQD1HVT bm_wdummymux_en_reg (.D ( n1065 ) 
    , .CP ( clk_b_G5B1I1ASTHIRNet208 ) , .Q ( n1165 ) , .CDN ( rst_bASThfnNet22 ) ) ;
DFCNQD1HVT bm_sweb_reg (.D ( bm_sweb735 ) , .CP ( clk_b_G5B1I1ASTHIRNet208 ) 
    , .Q ( n1162 ) , .CDN ( rst_bASThfnNet22 ) ) ;
DFCNQD1HVT bram_reading_int_d2_reg (.D ( bram_reading_int_d1 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet130 ) , .Q ( bram_reading_int_d2 ) 
    , .CDN ( rst_bASThfnNet22 ) ) ;
DFCNQD1HVT bm_sclkrw_reg (.D ( bm_sclkrw789 ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet182 ) , .Q ( n1164 ) 
    , .CDN ( rst_bASThfnNet22 ) ) ;
CKXOR2D0HVT U483 (.Z ( dummycnt247_3 ) , .A2 ( n1102 ) , .A1 ( n1103 ) ) ;
CKXOR2D0HVT U495 (.Z ( n1141 ) , .A2 ( flencnt_11_ ) , .A1 ( flen[11] ) ) ;
CKXOR2D0HVT U496 (.Z ( n1142 ) , .A2 ( flencnt_3_ ) , .A1 ( flen[3] ) ) ;
CKXOR2D0HVT U497 (.Z ( n1143 ) , .A2 ( flencnt_10_ ) , .A1 ( flen[10] ) ) ;
CKXOR2D0HVT U498 (.Z ( n1144 ) , .A2 ( flencnt_5_ ) , .A1 ( flen[5] ) ) ;
CKXOR2D0HVT U499 (.Z ( n1145 ) , .A2 ( flencnt_13_ ) , .A1 ( flen[13] ) ) ;
CKXOR2D0HVT U500 (.Z ( n1146 ) , .A2 ( flencnt_4_ ) , .A1 ( flen[4] ) ) ;
CKXOR2D0HVT U501 (.Z ( n1147 ) , .A2 ( flencnt_6_ ) , .A1 ( flen[6] ) ) ;
AO211D0HVT U490 (.Z ( next_0_ ) , .A2 ( n1124 ) , .C ( n1119 ) , .A1 ( n1123 ) 
    , .B ( n1063 ) ) ;
AO211D0HVT U491 (.Z ( next_1_ ) , .A2 ( n1126 ) , .C ( n1063 ) , .A1 ( n1125 ) 
    , .B ( n1127 ) ) ;
OA21D0HVT U492 (.B ( n1060 ) , .A1 ( n1064 ) , .Z ( n_654 ) , .A2 ( n1061 ) ) ;
AO21D0HVT U503 (.B ( n1060 ) , .A1 ( state_0_ ) , .Z ( n1123 ) , .A2 ( n1118 ) ) ;
AO21D0HVT U505 (.B ( n1133 ) , .A1 ( n1153 ) , .Z ( n1122 ) , .A2 ( n1152 ) ) ;
OR4D0HVT U504 (.Z ( n1152 ) , .A2 ( n1138 ) , .A4 ( n1150 ) , .A3 ( flencnt_0_ ) 
    , .A1 ( n1115 ) ) ;
CKAN2D1HVT U352 (.Z ( n1037 ) , .A1 ( dummycnt247_0 ) , .A2 ( n1104 ) ) ;
CKXOR2D0HVT U502 (.Z ( n1148 ) , .A2 ( flencnt_15_ ) , .A1 ( flen[15] ) ) ;
OR2D0HVT U494 (.A2 ( n1127 ) , .A1 ( n1062 ) , .Z ( n1117 ) ) ;
OR2D0HVT U484 (.A2 ( n1106 ) , .A1 ( bram_reading ) , .Z ( bram_clk_en_i ) ) ;
OR2D0HVT U485 (.A2 ( n1119 ) , .A1 ( n1118 ) , .Z ( n246_0 ) ) ;
OR2D0HVT U486 (.A2 ( n1059 ) , .A1 ( n1164 ) , .Z ( n670_0 ) ) ;
OR2D0HVT U487 (.A2 ( n1119 ) , .A1 ( dummycnt247_3 ) , .Z ( dummycnt245_3 ) ) ;
OR2D0HVT U488 (.A2 ( n1119 ) , .A1 ( dummycnt247_2 ) , .Z ( dummycnt245_2 ) ) ;
OR2D0HVT U489 (.A2 ( n1119 ) , .A1 ( dummycnt247_0 ) , .Z ( dummycnt245_0 ) ) ;
OR2D0HVT U493 (.A2 ( n1121 ) , .A1 ( dummycnt_0 ) , .Z ( n1118 ) ) ;
NR4D0HVT U359 (.A2 ( n1144 ) , .A3 ( n1141 ) , .A4 ( n1142 ) , .A1 ( n1143 ) 
    , .ZN ( n1039 ) ) ;
ND4D1HVT U372 (.A2 ( n1050 ) , .A3 ( n1049 ) , .A4 ( n1048 ) , .ZN ( n1113 ) 
    , .A1 ( n1051 ) ) ;
OAI33D0HVT U353 (.B1 ( n1121 ) , .B2 ( n_642 ) , .B3 ( dummycnt247_0 ) 
    , .A3 ( bram_wrt ) , .ZN ( bram_done495 ) , .A1 ( n1133 ) , .A2 ( n_609 ) ) ;
AO221D0HVT U354 (.B1 ( dummycnt_1 ) , .B2 ( dummycnt_0 ) , .C ( n1119 ) 
    , .A2 ( n1104 ) , .A1 ( dummycnt247_0 ) , .Z ( dummycnt245_1 ) ) ;
ND3D0HVT U355 (.A1 ( n1124 ) , .ZN ( n1136 ) , .A2 ( state_0_ ) , .A3 ( n1060 ) ) ;
ND3D0HVT U356 (.A1 ( n1150 ) , .ZN ( n1137 ) , .A2 ( state_1_ ) , .A3 ( n1134 ) ) ;
ND3D0HVT U357 (.A1 ( n1039 ) , .ZN ( n1130 ) , .A2 ( n1038 ) , .A3 ( n1113 ) ) ;
ND3D0HVT U394 (.A1 ( n1101 ) , .ZN ( n1121 ) , .A2 ( n1104 ) , .A3 ( n1102 ) ) ;
ND4D0HVT U360 (.A2 ( n1042 ) , .A3 ( n1041 ) , .A4 ( n1040 ) , .ZN ( n1129 ) 
    , .A1 ( n1043 ) ) ;
ND4D0HVT U365 (.A2 ( n1046 ) , .A3 ( n1045 ) , .A4 ( n1044 ) , .ZN ( n1128 ) 
    , .A1 ( n1047 ) ) ;
ND4D0HVT U371 (.A2 ( dummycnt_1 ) , .A3 ( n1101 ) , .A4 ( dummycnt247_0 ) 
    , .ZN ( n1153 ) , .A1 ( n1102 ) ) ;
NR4D0HVT U373 (.A2 ( fnumcnt_1_ ) , .A3 ( fnumcnt_6_ ) , .A4 ( fnumcnt_4_ ) 
    , .A1 ( fnumcnt_8_ ) , .ZN ( n1048 ) ) ;
NR4D0HVT U378 (.A2 ( flencnt_7_ ) , .A3 ( flencnt_2_ ) , .A4 ( flencnt_8_ ) 
    , .A1 ( flencnt_9_ ) , .ZN ( n1053 ) ) ;
NR4D0HVT U380 (.A2 ( flencnt_4_ ) , .A3 ( flencnt_10_ ) , .A4 ( flencnt_3_ ) 
    , .A1 ( flencnt_11_ ) , .ZN ( n1055 ) ) ;
NR4D0HVT U396 (.A2 ( n1114 ) , .A3 ( flencnt_1_ ) , .A4 ( n1115 ) 
    , .A1 ( n1113 ) , .ZN ( n1061 ) ) ;
NR4D0HVT U358 (.A2 ( n1148 ) , .A3 ( n1145 ) , .A4 ( n1146 ) , .A1 ( n1147 ) 
    , .ZN ( n1038 ) ) ;
XNR2D0HVT U368 (.A2 ( flencnt_8_ ) , .ZN ( n1046 ) , .A1 ( flen[8] ) ) ;
ND2D0HVT U370 (.ZN ( n1135 ) , .A1 ( n1124 ) , .A2 ( n1134 ) ) ;
ND2D0HVT U375 (.ZN ( n_642 ) , .A1 ( bram_wrt ) , .A2 ( n1133 ) ) ;
ND2D0HVT U381 (.ZN ( n1100 ) , .A1 ( n1116 ) , .A2 ( n1056 ) ) ;
ND2D0HVT U393 (.ZN ( bm_sclkrw789 ) , .A1 ( bm_sweb735 ) , .A2 ( n1122 ) ) ;
ND2D0HVT U398 (.ZN ( bm_sweb735 ) , .A1 ( n1062 ) , .A2 ( bram_wrt ) ) ;
ND2D0HVT U403 (.ZN ( n1103 ) , .A1 ( n1037 ) , .A2 ( n1101 ) ) ;
ND4D0HVT U376 (.A2 ( n1054 ) , .A3 ( n1053 ) , .A4 ( n1052 ) , .ZN ( n1115 ) 
    , .A1 ( n1055 ) ) ;
XNR2D0HVT U369 (.A2 ( flencnt_9_ ) , .ZN ( n1047 ) , .A1 ( flen[9] ) ) ;
XNR2D0HVT U482 (.A2 ( n1101 ) , .ZN ( dummycnt247_2 ) , .A1 ( n1037 ) ) ;
XNR2D0HVT U361 (.A2 ( flen[0] ) , .ZN ( n1040 ) , .A1 ( flencnt_0_ ) ) ;
XNR2D0HVT U362 (.A2 ( flencnt_12_ ) , .ZN ( n1041 ) , .A1 ( flen[12] ) ) ;
XNR2D0HVT U363 (.A2 ( flencnt_7_ ) , .ZN ( n1042 ) , .A1 ( flen[7] ) ) ;
XNR2D0HVT U364 (.A2 ( flen[14] ) , .ZN ( n1043 ) , .A1 ( flencnt_14_ ) ) ;
XNR2D0HVT U366 (.A2 ( flencnt_1_ ) , .ZN ( n1044 ) , .A1 ( flen[1] ) ) ;
XNR2D0HVT U367 (.A2 ( flen[2] ) , .ZN ( n1045 ) , .A1 ( flencnt_2_ ) ) ;
endmodule




module clk_gfsw_1 (clkout , osc_clkASTHIRNet252 , clksw1_outASTHIRNet198 , 
    n58ASTHIRNet176 , osc_clk_G1B8I1ASTHIRNet68 , rst_b , clka_BAR , 
    clkb , sel );
output clkout ;
input  osc_clkASTHIRNet252 ;
output clksw1_outASTHIRNet198 ;
input  n58ASTHIRNet176 ;
input  osc_clk_G1B8I1ASTHIRNet68 ;
input  rst_b ;
input  clka_BAR ;
input  clkb ;
input  sel ;

/* wire declarations */

wire n58_G2B3I1_1ASTHNet284 ;
wire n58_G2B2I1_1ASTHNet88 ;
wire n58_G2B1I1_1ASTHNet193 ;
wire n58_G2B11I1ASTHNet87 ;
wire n58_G2B10I1ASTHNet192 ;
wire n58_G2B9I1ASTHNet287 ;
wire n58_G2B8I1ASTHNet91 ;
wire n58_G2B7I1ASTHNet209 ;
wire n58_G2B6I1_1ASTHNet286 ;
wire n58_G2B5I1_1ASTHNet90 ;
wire n58_G2B4I1_1ASTHNet201 ;
wire rst_bASThfnNet10 ;
wire n49 ;
wire qa ;
wire n47 ;
wire n44 ;
wire n43 ;
wire n46 ;
wire n45 ;
wire n50 ;
wire n_21 ;
wire n_22 ;
wire n_38 ;
wire n_39 ;
wire qb ;
wire n48 ;

CKBD12HVT CKBD12HVTG2B3I1 (.Z ( n58_G2B3I1_1ASTHNet284 ) 
    , .I ( n58_G2B2I1_1ASTHNet88 ) ) ;
CKND2HVT CKND2HVTG2B2I1 (.ZN ( n58_G2B2I1_1ASTHNet88 ) 
    , .I ( n58_G2B1I1_1ASTHNet193 ) ) ;
INVD3HVT INVD3HVTG2B1I1 (.ZN ( n58_G2B1I1_1ASTHNet193 ) 
    , .I ( n58ASTHIRNet176 ) ) ;
CKBD6HVT CKBD6HVTG2B11I1 (.Z ( n58_G2B11I1ASTHNet87 ) 
    , .I ( n58_G2B10I1ASTHNet192 ) ) ;
CKBD6HVT CKBD6HVTG2B10I1 (.Z ( n58_G2B10I1ASTHNet192 ) 
    , .I ( n58_G2B9I1ASTHNet287 ) ) ;
CKBD6HVT CKBD6HVTG2B9I1 (.Z ( n58_G2B9I1ASTHNet287 ) 
    , .I ( n58_G2B8I1ASTHNet91 ) ) ;
CKBD6HVT CKBD6HVTG2B8I1 (.Z ( n58_G2B8I1ASTHNet91 ) 
    , .I ( n58_G2B7I1ASTHNet209 ) ) ;
CKBD6HVT CKBD6HVTG2B7I1 (.Z ( n58_G2B7I1ASTHNet209 ) 
    , .I ( n58_G2B6I1_1ASTHNet286 ) ) ;
CKBD6HVT CKBD6HVTG2B6I1_1 (.Z ( n58_G2B6I1_1ASTHNet286 ) 
    , .I ( n58_G2B5I1_1ASTHNet90 ) ) ;
CKBD8HVT CKBD8HVTG2B5I1 (.Z ( n58_G2B5I1_1ASTHNet90 ) 
    , .I ( n58_G2B4I1_1ASTHNet201 ) ) ;
CKBD12HVT CKBD12HVTG2B4I1_1 (.Z ( n58_G2B4I1_1ASTHNet201 ) 
    , .I ( n58_G2B3I1_1ASTHNet284 ) ) ;
CKBD16HVT rst_b_regASThfnInst10 (.I ( rst_b ) , .Z ( rst_bASThfnNet10 ) ) ;
CKND16HVT U13 (.I ( osc_clk_G1B8I1ASTHIRNet68 ) , .ZN ( n49 ) ) ;
CKND0HVT U14 (.I ( qa ) , .ZN ( n47 ) ) ;
BUFFD0HVT U15 (.I ( n44 ) , .Z ( n43 ) ) ;
CKBD0HVT U16 (.I ( n46 ) , .Z ( n44 ) ) ;
INVD0HVT U17 (.ZN ( n46 ) , .I ( n45 ) ) ;
INVD0HVT U19 (.ZN ( n50 ) , .I ( sel ) ) ;
INVD0HVT U18 (.I ( n50 ) , .ZN ( n45 ) ) ;
LHQD1HVT qa_reg (.D ( n_21 ) , .E ( n_22 ) , .Q ( qa ) ) ;
LHQD1HVT qb_reg (.D ( n_38 ) , .E ( n_39 ) , .Q ( qb ) ) ;
MOAI22D2HVT U20 (.ZN ( clksw1_outASTHIRNet198 ) , .B2 ( osc_clkASTHIRNet252 ) 
    , .A1 ( n58ASTHIRNet176 ) , .A2 ( n47 ) , .B1 ( qb ) ) ;
OR2XD1HVT U21 (.A2 ( n49 ) , .A1 ( n48 ) , .Z ( n_39 ) ) ;
OR2XD1HVT U22 (.A2 ( n58_G2B11I1ASTHNet87 ) , .A1 ( n48 ) , .Z ( n_22 ) ) ;
INR3D0HVT U23 (.ZN ( n_21 ) , .B2 ( sel ) , .A1 ( rst_bASThfnNet10 ) 
    , .B1 ( qb ) ) ;
INR3D0HVT U24 (.ZN ( n_38 ) , .B2 ( qa ) , .A1 ( rst_bASThfnNet10 ) 
    , .B1 ( n43 ) ) ;
CKND1HVT U25 (.ZN ( n48 ) , .I ( rst_bASThfnNet10 ) ) ;
endmodule




module clk_gfsw_0 (clkout , j_tck_GB_G2B8I1ASTHIRNet267 , 
    clksw1_outASTHIRNet200 , spi_clk_out_GBASTHIRNet159 , 
    j_tck_GBASTHIRNet99 , rst_b , clka , clkb , sel );
output clkout ;
input  j_tck_GB_G2B8I1ASTHIRNet267 ;
input  clksw1_outASTHIRNet200 ;
output spi_clk_out_GBASTHIRNet159 ;
input  j_tck_GBASTHIRNet99 ;
input  rst_b ;
input  clka ;
input  clkb ;
input  sel ;

/* wire declarations */

wire n_39 ;
wire n40 ;
wire n41 ;
wire n_22 ;
wire clk_gb ;
wire n39 ;
wire clksw1_out_G3B2I1_1ASTHNet195 ;
wire clksw1_out_G3B1I1_1ASTHNet283 ;
wire clksw1_out_G3B5I1ASTHNet191 ;
wire clksw1_out_G3B4I1ASTHNet285 ;
wire clksw1_out_G3B3I1_1ASTHNet89 ;
wire n42 ;
wire clksw1_out_G3B6I1ASTHNet63 ;
wire n_38 ;
wire qb ;
wire n_21 ;
wire qa ;
wire rst_bASThfnNet9 ;

IND2D0HVT U16 (.ZN ( n_39 ) , .A1 ( n40 ) , .B1 ( j_tck_GB_G2B8I1ASTHIRNet267 ) ) ;
OR2XD1HVT U17 (.A2 ( n41 ) , .A1 ( n40 ) , .Z ( n_22 ) ) ;
OR2D8HVT S_17 (.A2 ( clk_gb ) , .A1 ( n39 ) , .Z ( spi_clk_out_GBASTHIRNet159 ) ) ;
CKBD12HVT CKBD12HVTG3B2I1 (.Z ( clksw1_out_G3B2I1_1ASTHNet195 ) 
    , .I ( clksw1_out_G3B1I1_1ASTHNet283 ) ) ;
CKBD12HVT CKBD12HVTG3B1I1_1 (.Z ( clksw1_out_G3B1I1_1ASTHNet283 ) 
    , .I ( clksw1_outASTHIRNet200 ) ) ;
CKBD6HVT CKBD6HVTG3B5I1 (.Z ( clksw1_out_G3B5I1ASTHNet191 ) 
    , .I ( clksw1_out_G3B4I1ASTHNet285 ) ) ;
CKBD8HVT CKBD8HVTG3B4I1 (.Z ( clksw1_out_G3B4I1ASTHNet285 ) 
    , .I ( clksw1_out_G3B3I1_1ASTHNet89 ) ) ;
CKND0HVT U14 (.I ( sel ) , .ZN ( n42 ) ) ;
CKND8HVT U15 (.I ( clksw1_out_G3B6I1ASTHNet63 ) , .ZN ( n41 ) ) ;
LHQD1HVT qb_reg (.D ( n_38 ) , .E ( n_39 ) , .Q ( qb ) ) ;
LHQD1HVT qa_reg (.D ( n_21 ) , .E ( n_22 ) , .Q ( qa ) ) ;
INR3D0HVT U18 (.ZN ( n_21 ) , .B2 ( qb ) , .A1 ( rst_bASThfnNet9 ) , .B1 ( sel ) ) ;
INR3D0HVT U19 (.ZN ( n_38 ) , .B2 ( qa ) , .A1 ( rst_bASThfnNet9 ) , .B1 ( n42 ) ) ;
CKND1HVT U20 (.ZN ( n40 ) , .I ( rst_bASThfnNet9 ) ) ;
AN2D4HVT S_16 (.A2 ( j_tck_GBASTHIRNet99 ) , .Z ( clk_gb ) , .A1 ( qb ) ) ;
AN2D4HVT U13 (.Z ( n39 ) , .A1 ( clksw1_outASTHIRNet200 ) , .A2 ( qa ) ) ;
CKBD16HVT rst_b_regASThfnInst9 (.I ( rst_b ) , .Z ( rst_bASThfnNet9 ) ) ;
CKBD12HVT CKBD12HVTG3B6I1 (.Z ( clksw1_out_G3B6I1ASTHNet63 ) 
    , .I ( clksw1_out_G3B5I1ASTHNet191 ) ) ;
CKBD12HVT CKBD12HVTG3B3I1 (.Z ( clksw1_out_G3B3I1_1ASTHNet89 ) 
    , .I ( clksw1_out_G3B2I1_1ASTHNet195 ) ) ;
endmodule




module clkgen (osc_clk , clkout_b , j_tck_GB_G2B8I1ASTHIRNet269 , 
    osc_clkASTHIRNet254 , spi_clk_out_GBASTHIRNet161 , clk_bASTHIRNet147 , 
    j_tck_GBASTHIRNet101 , osc_clk_G1B8I1ASTHIRNet70 , rst_b , 
    spi_clk_out_GB_G4B1I2ASTHIRNet306 , cclk , tck , end_of_startup , 
    sample_mode_done , md_spi , md_jtag , clkout );
input  osc_clk ;
output clkout_b ;
input  j_tck_GB_G2B8I1ASTHIRNet269 ;
input  osc_clkASTHIRNet254 ;
output spi_clk_out_GBASTHIRNet161 ;
output clk_bASTHIRNet147 ;
input  j_tck_GBASTHIRNet101 ;
input  osc_clk_G1B8I1ASTHIRNet70 ;
input  rst_b ;
input  spi_clk_out_GB_G4B1I2ASTHIRNet306 ;
input  cclk ;
input  tck ;
input  end_of_startup ;
input  sample_mode_done ;
input  md_spi ;
input  md_jtag ;
output clkout ;

/* wire declarations */
wire clksw1_outASTHIRNet197 ;
wire n58ASTHIRNet174 ;
wire n55 ;
wire sel_jtag_clk ;

wire sel_spi_clk ;
wire n54 ;
wire n57 ;
wire n56 ;


clk_gfsw_1 clksw1 (.osc_clkASTHIRNet252 ( osc_clkASTHIRNet254 ) , 
    .clksw1_outASTHIRNet198 ( clksw1_outASTHIRNet197 ) , 
    .n58ASTHIRNet176 ( n58ASTHIRNet174 ) , 
    .osc_clk_G1B8I1ASTHIRNet68 ( osc_clk_G1B8I1ASTHIRNet70 ) , .rst_b ( rst_b ) , 
    .sel ( n55 ) ) ;


clk_gfsw_0 clksw2 (
    .j_tck_GB_G2B8I1ASTHIRNet267 ( j_tck_GB_G2B8I1ASTHIRNet269 ) , 
    .clksw1_outASTHIRNet200 ( clksw1_outASTHIRNet197 ) , 
    .spi_clk_out_GBASTHIRNet159 ( spi_clk_out_GBASTHIRNet161 ) , 
    .j_tck_GBASTHIRNet99 ( j_tck_GBASTHIRNet101 ) , .rst_b ( rst_b ) , 
    .sel ( sel_jtag_clk ) ) ;

BUFFD0HVT U7 (.I ( sel_spi_clk ) , .Z ( n54 ) ) ;
CKBD0HVT U8 (.I ( n54 ) , .Z ( n55 ) ) ;
CKBD0HVT U9 (.I ( n57 ) , .Z ( n56 ) ) ;
INVD0HVT U10 (.I ( sample_mode_done ) , .ZN ( n57 ) ) ;
OR2D0HVT U11 (.Z ( sel_spi_clk ) , .A1 ( md_spi ) , .A2 ( n56 ) ) ;
IND2D4HVT U12 (.A1 ( end_of_startup ) , .B1 ( cclk ) , .ZN ( n58ASTHIRNet174 ) ) ;
AN2D2HVT U13 (.A2 ( sample_mode_done ) , .Z ( sel_jtag_clk ) , .A1 ( md_jtag ) ) ;
CKND16HVT S_2 (.ZN ( clk_bASTHIRNet147 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet306 ) ) ;
endmodule




module rstbgen (osc_clk_G1B8I1ASTHIRNet66 , clk , por_b , creset_b , 
    rst_b );
input  osc_clk_G1B8I1ASTHIRNet66 ;
input  clk ;
input  por_b ;
input  creset_b ;
output rst_b ;

/* wire declarations */

wire n80 ;
wire n81 ;
wire rstff ;
wire osc_clk_G1B9I1ASTHNet264 ;

CKAN2D1HVT U23 (.Z ( n80 ) , .A1 ( creset_b ) , .A2 ( por_b ) ) ;
TIEHHVT U24 (.Z ( n81 ) ) ;
DFCND1HVT rstff_reg (.Q ( rstff ) , .CDN ( n80 ) , .D ( n81 ) 
    , .CP ( osc_clk_G1B9I1ASTHNet264 ) ) ;
DFCNQD1HVT rst_b_reg (.D ( rstff ) , .CP ( osc_clk_G1B9I1ASTHNet264 ) 
    , .Q ( rst_b ) , .CDN ( n80 ) ) ;
CKBD6HVT CKBD6HVTG1B9I1 (.Z ( osc_clk_G1B9I1ASTHNet264 ) 
    , .I ( osc_clk_G1B8I1ASTHIRNet66 ) ) ;
endmodule




module jtag_usercode_DW01_inc_5_0 (A , SUM );
input  [4:0] A ;
output [4:0] SUM ;

/* wire declarations */

wire carry_3 ;
wire carry_4 ;
wire carry_2 ;

HA1D0HVT U1_1_3 (.S ( SUM[3] ) , .A ( A[3] ) , .B ( carry_3 ) , .CO ( carry_4 ) ) ;
HA1D0HVT U1_1_2 (.S ( SUM[2] ) , .A ( A[2] ) , .B ( carry_2 ) , .CO ( carry_3 ) ) ;
HA1D0HVT U1_1_1 (.S ( SUM[1] ) , .A ( A[1] ) , .B ( A[0] ) , .CO ( carry_2 ) ) ;
CKND0HVT U5 (.I ( A[0] ) , .ZN ( SUM[0] ) ) ;
CKXOR2D0HVT U6 (.Z ( SUM[4] ) , .A2 ( A[4] ) , .A1 ( carry_4 ) ) ;
endmodule




module jtag_usercode (usercode_reg , j_tck , j_cap_dr , j_usercode , 
    j_sft_dr , j_usercode_tdo , j_tck_GB_G2B8I1ASTHIRNet271 );
input  [31:0] usercode_reg ;
input  j_tck ;
input  j_cap_dr ;
input  j_usercode ;
input  j_sft_dr ;
output j_usercode_tdo ;
input  j_tck_GB_G2B8I1ASTHIRNet271 ;

/* wire declarations */
wire usercode_cnt_1_ ;
wire usercode_cnt_0_ ;
wire usercode_cnt63_4 ;
wire usercode_cnt63_3 ;
wire usercode_cnt63_2 ;
wire usercode_cnt63_1 ;
wire usercode_cnt63_0 ;
wire usercode_cnt_4_ ;
wire usercode_cnt_3_ ;
wire usercode_cnt_2_ ;

wire n191 ;
wire n192 ;
wire n193 ;
wire n190 ;
wire n174 ;
wire n195 ;
wire n196 ;
wire n197 ;
wire n194 ;
wire n175 ;
wire n167 ;
wire n166 ;
wire n165 ;
wire n188 ;
wire n168 ;
wire n171 ;
wire n170 ;
wire n169 ;
wire n189 ;
wire n172 ;
wire n182 ;
wire n180 ;
wire n185 ;
wire n183 ;
wire n181 ;
wire n186 ;
wire n184 ;
wire n187 ;
wire n173 ;
wire n203 ;
wire n179 ;
wire n204 ;
wire n200 ;
wire n201 ;
wire n198 ;
wire n178 ;
wire n177 ;
wire n176 ;
wire n199 ;
wire n99 ;
wire n202 ;


jtag_usercode_DW01_inc_5_0 add_70 (
    .SUM ( {usercode_cnt63_4 , usercode_cnt63_3 , usercode_cnt63_2 , 
	usercode_cnt63_1 , usercode_cnt63_0 } ) , 
    .A ( {usercode_cnt_4_ , usercode_cnt_3_ , usercode_cnt_2_ , 
	usercode_cnt_1_ , usercode_cnt_0_ } ) ) ;

NR4D0HVT U50 (.A2 ( n191 ) , .A3 ( n192 ) , .A4 ( n193 ) , .A1 ( n190 ) 
    , .ZN ( n174 ) ) ;
NR4D0HVT U51 (.A2 ( n195 ) , .A3 ( n196 ) , .A4 ( n197 ) , .A1 ( n194 ) 
    , .ZN ( n175 ) ) ;
ND4D0HVT U38 (.A2 ( n167 ) , .A3 ( n166 ) , .A4 ( n165 ) , .ZN ( n188 ) 
    , .A1 ( n168 ) ) ;
ND4D0HVT U43 (.A2 ( n171 ) , .A3 ( n170 ) , .A4 ( n169 ) , .ZN ( n189 ) 
    , .A1 ( n172 ) ) ;
AOI22D0HVT U39 (.B1 ( usercode_reg[14] ) , .ZN ( n165 ) , .B2 ( n182 ) 
    , .A1 ( usercode_reg[15] ) , .A2 ( n180 ) ) ;
AOI22D0HVT U40 (.B1 ( usercode_reg[6] ) , .ZN ( n166 ) , .B2 ( n185 ) 
    , .A1 ( usercode_reg[7] ) , .A2 ( n183 ) ) ;
AOI22D0HVT U41 (.B1 ( usercode_reg[30] ) , .ZN ( n167 ) , .B2 ( n181 ) 
    , .A1 ( usercode_reg[31] ) , .A2 ( n186 ) ) ;
AOI22D0HVT U42 (.B1 ( usercode_reg[22] ) , .ZN ( n168 ) , .B2 ( n184 ) 
    , .A1 ( usercode_reg[23] ) , .A2 ( n187 ) ) ;
AOI22D0HVT U44 (.B1 ( usercode_reg[10] ) , .ZN ( n169 ) , .B2 ( n182 ) 
    , .A1 ( usercode_reg[11] ) , .A2 ( n180 ) ) ;
AOI22D0HVT U45 (.B1 ( usercode_reg[2] ) , .ZN ( n170 ) , .B2 ( n185 ) 
    , .A1 ( usercode_reg[3] ) , .A2 ( n183 ) ) ;
MUX3ND1HVT U48 (.I2 ( n173 ) , .S1 ( usercode_cnt_1_ ) , .I1 ( n174 ) 
    , .S0 ( usercode_cnt_2_ ) , .I0 ( n175 ) , .ZN ( j_usercode_tdo ) ) ;
MUX2ND0HVT U49 (.ZN ( n173 ) , .I0 ( n189 ) , .S ( usercode_cnt_2_ ) 
    , .I1 ( n188 ) ) ;
AO22D0HVT U56 (.B1 ( usercode_reg[8] ) , .B2 ( n182 ) , .Z ( n197 ) 
    , .A1 ( usercode_reg[9] ) , .A2 ( n180 ) ) ;
AO22D0HVT U57 (.B1 ( usercode_reg[0] ) , .B2 ( n185 ) , .Z ( n196 ) 
    , .A1 ( usercode_reg[1] ) , .A2 ( n183 ) ) ;
AO22D0HVT U58 (.B1 ( usercode_reg[24] ) , .B2 ( n181 ) , .Z ( n195 ) 
    , .A1 ( usercode_reg[25] ) , .A2 ( n186 ) ) ;
AO22D0HVT U59 (.B1 ( usercode_reg[16] ) , .B2 ( n184 ) , .Z ( n194 ) 
    , .A1 ( usercode_reg[17] ) , .A2 ( n187 ) ) ;
AO22D0HVT U52 (.B1 ( usercode_reg[12] ) , .B2 ( n182 ) , .Z ( n193 ) 
    , .A1 ( usercode_reg[13] ) , .A2 ( n180 ) ) ;
AO22D0HVT U53 (.B1 ( usercode_reg[4] ) , .B2 ( n185 ) , .Z ( n192 ) 
    , .A1 ( usercode_reg[5] ) , .A2 ( n183 ) ) ;
AOI22D0HVT U46 (.B1 ( usercode_reg[26] ) , .ZN ( n171 ) , .B2 ( n181 ) 
    , .A1 ( usercode_reg[27] ) , .A2 ( n186 ) ) ;
AOI22D0HVT U47 (.B1 ( usercode_reg[18] ) , .ZN ( n172 ) , .B2 ( n184 ) 
    , .A1 ( usercode_reg[19] ) , .A2 ( n187 ) ) ;
MUX2D0HVT U63 (.I1 ( usercode_cnt63_1 ) , .Z ( n203 ) , .S ( n179 ) 
    , .I0 ( usercode_cnt_1_ ) ) ;
MUX2D0HVT U65 (.I1 ( usercode_cnt63_0 ) , .Z ( n204 ) , .S ( n179 ) 
    , .I0 ( usercode_cnt_0_ ) ) ;
MUX2D0HVT U60 (.I1 ( usercode_cnt63_4 ) , .Z ( n200 ) , .S ( n179 ) 
    , .I0 ( usercode_cnt_4_ ) ) ;
MUX2D0HVT U61 (.I1 ( usercode_cnt63_3 ) , .Z ( n201 ) , .S ( n179 ) 
    , .I0 ( usercode_cnt_3_ ) ) ;
CKND0HVT U64 (.I ( j_cap_dr ) , .ZN ( n198 ) ) ;
CKAN2D1HVT U66 (.Z ( n179 ) , .A1 ( j_usercode ) , .A2 ( j_sft_dr ) ) ;
AO22D0HVT U54 (.B1 ( usercode_reg[28] ) , .B2 ( n181 ) , .Z ( n191 ) 
    , .A1 ( usercode_reg[29] ) , .A2 ( n186 ) ) ;
AO22D0HVT U55 (.B1 ( usercode_reg[20] ) , .B2 ( n184 ) , .Z ( n190 ) 
    , .A1 ( usercode_reg[21] ) , .A2 ( n187 ) ) ;
NR3D0HVT U73 (.A1 ( n178 ) , .ZN ( n186 ) , .A2 ( n177 ) , .A3 ( n176 ) ) ;
NR3D0HVT U74 (.A1 ( usercode_cnt_3_ ) , .ZN ( n187 ) , .A2 ( n178 ) 
    , .A3 ( n176 ) ) ;
NR3D0HVT U67 (.A1 ( usercode_cnt_4_ ) , .ZN ( n180 ) , .A2 ( n177 ) 
    , .A3 ( n176 ) ) ;
NR3D0HVT U68 (.A1 ( usercode_cnt_0_ ) , .ZN ( n181 ) , .A2 ( n178 ) 
    , .A3 ( n177 ) ) ;
NR3D0HVT U69 (.A1 ( usercode_cnt_0_ ) , .ZN ( n182 ) , .A2 ( usercode_cnt_4_ ) 
    , .A3 ( n177 ) ) ;
CKND16HVT U75 (.ZN ( n199 ) , .I ( n99 ) ) ;
CKND16HVT U76 (.ZN ( n99 ) , .I ( j_tck_GB_G2B8I1ASTHIRNet271 ) ) ;
MUX2D0HVT U62 (.I1 ( usercode_cnt63_2 ) , .Z ( n202 ) , .S ( n179 ) 
    , .I0 ( usercode_cnt_2_ ) ) ;
DFNSND1HVT usercode_cnt_reg_3_ (.SDN ( n198 ) , .CPN ( n199 ) , .D ( n201 ) 
    , .Q ( usercode_cnt_3_ ) , .QN ( n177 ) ) ;
DFNSND1HVT usercode_cnt_reg_2_ (.SDN ( n198 ) , .CPN ( n199 ) , .D ( n202 ) 
    , .Q ( usercode_cnt_2_ ) ) ;
DFNSND1HVT usercode_cnt_reg_1_ (.SDN ( n198 ) , .CPN ( n199 ) , .D ( n203 ) 
    , .Q ( usercode_cnt_1_ ) ) ;
DFNSND1HVT usercode_cnt_reg_0_ (.SDN ( n198 ) , .CPN ( n199 ) , .D ( n204 ) 
    , .Q ( usercode_cnt_0_ ) , .QN ( n176 ) ) ;
DFNSND1HVT usercode_cnt_reg_4_ (.SDN ( n198 ) , .CPN ( n199 ) , .D ( n200 ) 
    , .Q ( usercode_cnt_4_ ) , .QN ( n178 ) ) ;
NR3D0HVT U70 (.A1 ( usercode_cnt_3_ ) , .ZN ( n183 ) , .A2 ( usercode_cnt_4_ ) 
    , .A3 ( n176 ) ) ;
NR3D0HVT U71 (.A1 ( usercode_cnt_0_ ) , .ZN ( n184 ) , .A2 ( usercode_cnt_3_ ) 
    , .A3 ( n178 ) ) ;
NR3D0HVT U72 (.A1 ( usercode_cnt_0_ ) , .ZN ( n185 ) , .A2 ( usercode_cnt_3_ ) 
    , .A3 ( usercode_cnt_4_ ) ) ;
endmodule




module sdiomux (sdo , bm_bank_sdi , cm_sdi_u0 , clk_b_G5B1I2ASTHIRNet106 , 
    spi_clk_out_GB_G4B2I16ASTHIRNet38 , cm_sdi_u2 , cm_sdi_u1 , clk_b , 
    rst_b , md_spi , psdo , cm_sdi_u3 , clk , en_daisychain_cfg , 
    sample_mode_done , cram_clr_done , cram_clr_done_r , j_tdi , 
    j_usercode , psdi , spi_ss_out_b_int , spi_sdi , access_nvcm_reg , 
    smc_load_nvcm_bstream , nvcm_spi_sdo , nvcm_spi_sdo_oe_b , md_jtag , 
    en_8bconfig_b , md_spi_b , spi_ss_out_b , spi_sdo , sdi , 
    nvcm_spi_ss_b , nvcm_spi_sdi , j_usercode_tdo , spi_ss_in_b , 
    clk_b_G5B1I3ASTHIRNet295 , spi_clk_out_GB_G4B2I4ASTHIRNet245 , 
    clk_b_G5B1I1ASTHIRNet206 , spi_clk_out_GB_G4B2I18ASTHIRNet156 , 
    spi_clk_out_GB_G4B2I2ASTHIRNet141 , spi_clk_out_GB_G4B2I15ASTHIRNet128 , 
    spi_sdo_oe_b , j_tdo );
input  [7:0] sdo ;
output [3:0] bm_bank_sdi ;
output [1:0] cm_sdi_u0 ;
input  clk_b_G5B1I2ASTHIRNet106 ;
input  spi_clk_out_GB_G4B2I16ASTHIRNet38 ;
output [1:0] cm_sdi_u2 ;
output [1:0] cm_sdi_u1 ;
input  clk_b ;
input  rst_b ;
input  md_spi ;
output [7:1] psdo ;
output [1:0] cm_sdi_u3 ;
input  clk ;
input  en_daisychain_cfg ;
input  sample_mode_done ;
input  cram_clr_done ;
input  cram_clr_done_r ;
input  j_tdi ;
input  j_usercode ;
input  [7:1] psdi ;
input  spi_ss_out_b_int ;
input  spi_sdi ;
input  access_nvcm_reg ;
input  smc_load_nvcm_bstream ;
input  nvcm_spi_sdo ;
input  nvcm_spi_sdo_oe_b ;
input  md_jtag ;
input  en_8bconfig_b ;
output md_spi_b ;
output spi_ss_out_b ;
output spi_sdo ;
output sdi ;
output nvcm_spi_ss_b ;
output nvcm_spi_sdi ;
input  j_usercode_tdo ;
input  spi_ss_in_b ;
input  clk_b_G5B1I3ASTHIRNet295 ;
input  spi_clk_out_GB_G4B2I4ASTHIRNet245 ;
input  clk_b_G5B1I1ASTHIRNet206 ;
input  spi_clk_out_GB_G4B2I18ASTHIRNet156 ;
input  spi_clk_out_GB_G4B2I2ASTHIRNet141 ;
input  spi_clk_out_GB_G4B2I15ASTHIRNet128 ;
output spi_sdo_oe_b ;
output j_tdo ;

/* wire declarations */

wire n1078 ;
wire n1096 ;
wire n1080 ;
wire n1615 ;
wire n1076 ;
wire n1584 ;
wire n1074 ;
wire n1094 ;
wire n1092 ;
wire n1610 ;
wire n1614 ;
wire j_tdo_int_neg ;
wire n1600 ;
wire n1099 ;
wire n1572 ;
wire n1574 ;
wire n1576 ;
wire n1578 ;
wire n1580 ;
wire n1582 ;
wire n1608 ;
wire n1586 ;
wire n1588 ;
wire n1590 ;
wire n1592 ;
wire n1594 ;
wire n1596 ;
wire n1598 ;
wire spi_sdi_r ;
wire spi_sdo_int ;
wire val238_1 ;
wire n1611 ;
wire n1612 ;
wire n1082 ;
wire n1084 ;
wire n1613 ;
wire n1602 ;
wire n1604 ;
wire n1606 ;
wire rst_bASThfnNet24 ;
wire smc_spi_sdo_oe_b ;
wire smc_spi_sdo_oe_b779 ;
wire smc_spi_ss_out_b ;
wire n1616 ;
wire md_spi_b742 ;
wire n1097 ;
wire spi_sdo_r ;
wire psdi_int_5_ ;
wire psdi_int_6_ ;
wire psdi_int_4_ ;
wire psdi_int_2_ ;
wire cm_sdi_u3946_1 ;
wire sdi_int_7 ;
wire n1090 ;
wire sdi_int_3 ;
wire n1086 ;
wire sdi_int_1 ;
wire n1624 ;
wire n1630 ;
wire n1633 ;
wire n1628 ;
wire cm_sdi_u2940_1 ;
wire sdi_int_5 ;
wire psdi_int_1_ ;
wire psdi_int_7_ ;
wire psdi_int_3_ ;
wire n1629 ;
wire n1625 ;
wire n1627 ;
wire n1619 ;
wire n1618 ;
wire n1621 ;
wire n1626 ;
wire n1617 ;
wire psdo_Q484_4 ;
wire n1620 ;
wire bm_bank_sdi_Q900_0 ;
wire n1631 ;
wire n1623 ;
wire n1632 ;
wire n1622 ;
wire sdi_int_6 ;
wire sdi_int_4 ;
wire bm_bank_sdi884_1 ;
wire sdi_int_2 ;
wire cm_sdi_u3946_0 ;
wire bm_bank_sdi884_3 ;
wire cm_sdi_u1934_0 ;
wire cm_sdi_u2940_0 ;

MUX2ND0HVT U286 (.ZN ( n1078 ) , .I0 ( n1096 ) , .S ( access_nvcm_reg ) 
    , .I1 ( spi_sdi ) ) ;
MUX2ND0HVT U288 (.ZN ( n1080 ) , .I0 ( n1615 ) , .S ( access_nvcm_reg ) 
    , .I1 ( spi_ss_in_b ) ) ;
CKND6HVT U285 (.I ( n1076 ) , .ZN ( j_tdo ) ) ;
CKND8HVT U329 (.I ( n1584 ) , .ZN ( psdo[7] ) ) ;
CKND8HVT U283 (.I ( n1074 ) , .ZN ( spi_sdo_oe_b ) ) ;
CKND8HVT U287 (.I ( n1078 ) , .ZN ( nvcm_spi_sdi ) ) ;
CKND8HVT U289 (.I ( n1080 ) , .ZN ( nvcm_spi_ss_b ) ) ;
INR2D0HVT U290 (.ZN ( n1094 ) , .A1 ( spi_sdi ) , .B1 ( access_nvcm_reg ) ) ;
INR2D0HVT U296 (.ZN ( n1092 ) , .A1 ( sdi ) , .B1 ( n1610 ) ) ;
MUX2ND2HVT U282 (.ZN ( n1074 ) , .I0 ( n1614 ) , .S ( access_nvcm_reg ) 
    , .I1 ( nvcm_spi_sdo_oe_b ) ) ;
MUX2ND0HVT U284 (.ZN ( n1076 ) , .I0 ( j_tdo_int_neg ) , .S ( j_usercode ) 
    , .I1 ( j_usercode_tdo ) ) ;
CKND8HVT U345 (.I ( n1600 ) , .ZN ( bm_bank_sdi[1] ) ) ;
CKND8HVT U312 (.I ( n1099 ) , .ZN ( md_spi_b ) ) ;
CKND8HVT U315 (.I ( n1572 ) , .ZN ( bm_bank_sdi[2] ) ) ;
CKND8HVT U317 (.I ( n1574 ) , .ZN ( cm_sdi_u0[0] ) ) ;
CKND8HVT U319 (.I ( n1576 ) , .ZN ( cm_sdi_u3[1] ) ) ;
CKND8HVT U322 (.I ( n1578 ) , .ZN ( cm_sdi_u2[1] ) ) ;
CKND8HVT U325 (.I ( n1580 ) , .ZN ( psdo[5] ) ) ;
CKND8HVT U327 (.I ( n1582 ) , .ZN ( psdo[1] ) ) ;
CKND8HVT U353 (.I ( n1608 ) , .ZN ( bm_bank_sdi[0] ) ) ;
CKND8HVT U331 (.I ( n1586 ) , .ZN ( psdo[3] ) ) ;
CKND8HVT U333 (.I ( n1588 ) , .ZN ( cm_sdi_u1[0] ) ) ;
CKND8HVT U335 (.I ( n1590 ) , .ZN ( psdo[2] ) ) ;
CKND8HVT U337 (.I ( n1592 ) , .ZN ( cm_sdi_u1[1] ) ) ;
CKND8HVT U339 (.I ( n1594 ) , .ZN ( psdo[6] ) ) ;
CKND8HVT U341 (.I ( n1596 ) , .ZN ( cm_sdi_u2[0] ) ) ;
CKND8HVT U343 (.I ( n1598 ) , .ZN ( cm_sdi_u3[0] ) ) ;
MUX2D0HVT U299 (.I1 ( spi_sdi_r ) , .Z ( spi_sdo_int ) 
    , .S ( en_daisychain_cfg ) , .I0 ( sdo[0] ) ) ;
MUX2D0HVT U354 (.I1 ( nvcm_spi_sdo ) , .Z ( val238_1 ) 
    , .S ( smc_load_nvcm_bstream ) , .I0 ( n1094 ) ) ;
MUX2D2HVT U301 (.I1 ( nvcm_spi_sdo ) , .Z ( n1611 ) , .S ( access_nvcm_reg ) 
    , .I0 ( n1612 ) ) ;
MUX2D2HVT U292 (.I1 ( n1082 ) , .Z ( sdi ) , .S ( md_jtag ) , .I0 ( n1084 ) ) ;
NR2D0HVT U293 (.A1 ( en_daisychain_cfg ) , .A2 ( n1613 ) , .ZN ( n1084 ) ) ;
CKND8HVT U347 (.I ( n1602 ) , .ZN ( bm_bank_sdi[3] ) ) ;
CKND8HVT U349 (.I ( n1604 ) , .ZN ( psdo[4] ) ) ;
CKND8HVT U351 (.I ( n1606 ) , .ZN ( cm_sdi_u0[1] ) ) ;
BUFFD8HVT U300 (.Z ( spi_sdo ) , .I ( n1611 ) ) ;
DFSNQD1HVT smc_spi_sdo_oe_b_reg (.SDN ( rst_bASThfnNet24 ) 
    , .Q ( smc_spi_sdo_oe_b ) , .CP ( clk_b_G5B1I2ASTHIRNet106 ) 
    , .D ( smc_spi_sdo_oe_b779 ) ) ;
DFSNQD1HVT smc_spi_ss_out_b_reg (.SDN ( rst_bASThfnNet24 ) 
    , .Q ( smc_spi_ss_out_b ) , .CP ( clk_b_G5B1I2ASTHIRNet106 ) 
    , .D ( spi_ss_out_b_int ) ) ;
DFSNQD1HVT md_spi_b_reg (.SDN ( rst_bASThfnNet24 ) , .Q ( n1616 ) 
    , .CP ( clk_b_G5B1I1ASTHIRNet206 ) , .D ( md_spi_b742 ) ) ;
CKND0HVT U302 (.I ( en_8bconfig_b ) , .ZN ( n1097 ) ) ;
CKND0HVT U310 (.I ( en_8bconfig_b ) , .ZN ( n1610 ) ) ;
CKND0HVT U313 (.I ( md_spi ) , .ZN ( md_spi_b742 ) ) ;
MUX2D0HVT U298 (.I1 ( spi_sdo_r ) , .Z ( n1612 ) , .S ( cram_clr_done_r ) 
    , .I0 ( cram_clr_done ) ) ;
CKAN2D1HVT U306 (.Z ( psdi_int_5_ ) , .A1 ( psdi[5] ) , .A2 ( n1097 ) ) ;
CKAN2D1HVT U307 (.Z ( psdi_int_6_ ) , .A1 ( psdi[6] ) , .A2 ( n1610 ) ) ;
CKAN2D1HVT U308 (.Z ( psdi_int_4_ ) , .A1 ( psdi[4] ) , .A2 ( n1097 ) ) ;
CKAN2D1HVT U309 (.Z ( psdi_int_2_ ) , .A1 ( psdi[2] ) , .A2 ( n1097 ) ) ;
CKAN2D1HVT U320 (.Z ( cm_sdi_u3946_1 ) , .A1 ( sdi_int_7 ) , .A2 ( n1097 ) ) ;
CKAN2D1HVT U294 (.Z ( n1096 ) , .A1 ( n1612 ) , .A2 ( smc_load_nvcm_bstream ) ) ;
CKAN2D1HVT U295 (.Z ( n1090 ) , .A1 ( n1610 ) , .A2 ( sdi_int_3 ) ) ;
CKAN2D1HVT U297 (.Z ( n1086 ) , .A1 ( n1610 ) , .A2 ( sdi_int_1 ) ) ;
INVD0HVT U321 (.ZN ( n1578 ) , .I ( n1624 ) ) ;
INVD0HVT U324 (.ZN ( n1580 ) , .I ( n1630 ) ) ;
INVD0HVT U326 (.ZN ( n1582 ) , .I ( n1633 ) ) ;
INVD0HVT U328 (.ZN ( n1584 ) , .I ( n1628 ) ) ;
CKAN2D1HVT U323 (.Z ( cm_sdi_u2940_1 ) , .A1 ( sdi_int_5 ) , .A2 ( n1097 ) ) ;
CKAN2D1HVT U303 (.Z ( psdi_int_1_ ) , .A1 ( psdi[1] ) , .A2 ( n1097 ) ) ;
CKAN2D1HVT U304 (.Z ( psdi_int_7_ ) , .A1 ( psdi[7] ) , .A2 ( n1097 ) ) ;
CKAN2D1HVT U305 (.Z ( psdi_int_3_ ) , .A1 ( psdi[3] ) , .A2 ( n1097 ) ) ;
INVD0HVT U338 (.ZN ( n1594 ) , .I ( n1629 ) ) ;
INVD0HVT U340 (.ZN ( n1596 ) , .I ( n1625 ) ) ;
INVD0HVT U342 (.ZN ( n1598 ) , .I ( n1627 ) ) ;
INVD0HVT U344 (.ZN ( n1600 ) , .I ( n1619 ) ) ;
INVD0HVT U311 (.I ( n1616 ) , .ZN ( n1099 ) ) ;
INVD0HVT U314 (.ZN ( n1572 ) , .I ( n1618 ) ) ;
INVD0HVT U316 (.ZN ( n1574 ) , .I ( n1621 ) ) ;
INVD0HVT U318 (.ZN ( n1576 ) , .I ( n1626 ) ) ;
INVD0HVT U346 (.ZN ( n1602 ) , .I ( n1617 ) ) ;
INVD0HVT U348 (.ZN ( n1604 ) , .I ( psdo_Q484_4 ) ) ;
INVD0HVT U350 (.ZN ( n1606 ) , .I ( n1620 ) ) ;
INVD0HVT U352 (.ZN ( n1608 ) , .I ( bm_bank_sdi_Q900_0 ) ) ;
INVD0HVT U330 (.ZN ( n1586 ) , .I ( n1631 ) ) ;
INVD0HVT U332 (.ZN ( n1588 ) , .I ( n1623 ) ) ;
INVD0HVT U334 (.ZN ( n1590 ) , .I ( n1632 ) ) ;
INVD0HVT U336 (.ZN ( n1592 ) , .I ( n1622 ) ) ;
DFCNQD1HVT psdo_reg_6_ (.D ( sdo[6] ) , .CP ( clk_b_G5B1I3ASTHIRNet295 ) 
    , .Q ( n1629 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdo_reg_5_ (.D ( sdo[5] ) , .CP ( clk_b_G5B1I1ASTHIRNet206 ) 
    , .Q ( n1630 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdo_reg_4_ (.D ( sdo[4] ) , .CP ( clk_b_G5B1I3ASTHIRNet295 ) 
    , .Q ( psdo_Q484_4 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdo_reg_3_ (.D ( sdo[3] ) , .CP ( clk_b_G5B1I1ASTHIRNet206 ) 
    , .Q ( n1631 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdi_r_reg_7_ (.D ( psdi_int_7_ ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet156 ) , .Q ( sdi_int_7 ) 
    , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdi_r_reg_6_ (.D ( psdi_int_6_ ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet128 ) , .Q ( sdi_int_6 ) 
    , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdi_r_reg_5_ (.D ( psdi_int_5_ ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet156 ) , .Q ( sdi_int_5 ) 
    , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdi_r_reg_4_ (.D ( psdi_int_4_ ) 
    , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet38 ) , .Q ( sdi_int_4 ) 
    , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT bm_bank_sdi_reg_1_ (.D ( bm_bank_sdi884_1 ) 
    , .CP ( clk_b_G5B1I2ASTHIRNet106 ) , .Q ( n1619 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT bm_bank_sdi_reg_0_ (.D ( sdi ) , .CP ( clk_b_G5B1I2ASTHIRNet106 ) 
    , .Q ( bm_bank_sdi_Q900_0 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT cm_sdi_u0_reg_1_ (.D ( n1086 ) , .CP ( clk_b_G5B1I1ASTHIRNet206 ) 
    , .Q ( n1620 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT cm_sdi_u0_reg_0_ (.D ( sdi ) , .CP ( clk_b_G5B1I2ASTHIRNet106 ) 
    , .Q ( n1621 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdi_r_reg_3_ (.D ( psdi_int_3_ ) 
    , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet38 ) , .Q ( sdi_int_3 ) 
    , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdi_r_reg_2_ (.D ( psdi_int_2_ ) 
    , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet38 ) , .Q ( sdi_int_2 ) 
    , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdi_r_reg_1_ (.D ( psdi_int_1_ ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet156 ) , .Q ( sdi_int_1 ) 
    , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdo_reg_7_ (.D ( sdo[7] ) , .CP ( clk_b_G5B1I1ASTHIRNet206 ) 
    , .Q ( n1628 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT cm_sdi_u3_reg_1_ (.D ( cm_sdi_u3946_1 ) 
    , .CP ( clk_b_G5B1I1ASTHIRNet206 ) , .Q ( n1626 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT cm_sdi_u3_reg_0_ (.D ( cm_sdi_u3946_0 ) 
    , .CP ( clk_b_G5B1I1ASTHIRNet206 ) , .Q ( n1627 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT j_tdo_int_neg_reg (.D ( sdo[0] ) , .CP ( clk_b_G5B1I2ASTHIRNet106 ) 
    , .Q ( j_tdo_int_neg ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT spi_sdo_r_reg (.D ( spi_sdo_int ) 
    , .CP ( clk_b_G5B1I2ASTHIRNet106 ) , .Q ( spi_sdo_r ) 
    , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdo_reg_2_ (.D ( sdo[2] ) , .CP ( clk_b_G5B1I3ASTHIRNet295 ) 
    , .Q ( n1632 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT psdo_reg_1_ (.D ( sdo[1] ) , .CP ( clk_b_G5B1I3ASTHIRNet295 ) 
    , .Q ( n1633 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT bm_bank_sdi_reg_3_ (.D ( bm_bank_sdi884_3 ) 
    , .CP ( clk_b_G5B1I2ASTHIRNet106 ) , .Q ( n1617 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT bm_bank_sdi_reg_2_ (.D ( cm_sdi_u1934_0 ) 
    , .CP ( clk_b_G5B1I2ASTHIRNet106 ) , .Q ( n1618 ) , .CDN ( rst_bASThfnNet24 ) ) ;
IND2D0HVT U291 (.A1 ( smc_spi_ss_out_b ) , .B1 ( smc_load_nvcm_bstream ) 
    , .ZN ( n1615 ) ) ;
OR2D0HVT U356 (.A2 ( n1090 ) , .A1 ( n1092 ) , .Z ( bm_bank_sdi884_3 ) ) ;
OR2D0HVT U358 (.A2 ( n1086 ) , .A1 ( n1092 ) , .Z ( bm_bank_sdi884_1 ) ) ;
OR2D0HVT U361 (.A2 ( smc_spi_sdo_oe_b ) , .A1 ( smc_load_nvcm_bstream ) 
    , .Z ( n1614 ) ) ;
DFCNQD1HVT cm_sdi_u1_reg_1_ (.D ( n1090 ) , .CP ( clk_b_G5B1I1ASTHIRNet206 ) 
    , .Q ( n1622 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT cm_sdi_u1_reg_0_ (.D ( cm_sdi_u1934_0 ) 
    , .CP ( clk_b_G5B1I1ASTHIRNet206 ) , .Q ( n1623 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT cm_sdi_u2_reg_1_ (.D ( cm_sdi_u2940_1 ) 
    , .CP ( clk_b_G5B1I1ASTHIRNet206 ) , .Q ( n1624 ) , .CDN ( rst_bASThfnNet24 ) ) ;
DFCNQD1HVT cm_sdi_u2_reg_0_ (.D ( cm_sdi_u2940_0 ) 
    , .CP ( clk_b_G5B1I1ASTHIRNet206 ) , .Q ( n1625 ) , .CDN ( rst_bASThfnNet24 ) ) ;
AO21D0HVT U360 (.B ( n1092 ) , .A1 ( sdi_int_6 ) , .Z ( cm_sdi_u3946_0 ) 
    , .A2 ( n1610 ) ) ;
AO21D0HVT U357 (.B ( n1092 ) , .A1 ( sdi_int_2 ) , .Z ( cm_sdi_u1934_0 ) 
    , .A2 ( n1610 ) ) ;
AO21D0HVT U359 (.B ( n1092 ) , .A1 ( sdi_int_4 ) , .Z ( cm_sdi_u2940_0 ) 
    , .A2 ( n1610 ) ) ;
OR2D8HVT U362 (.A2 ( smc_spi_ss_out_b ) , .A1 ( smc_load_nvcm_bstream ) 
    , .Z ( spi_ss_out_b ) ) ;
CKBD16HVT rst_b_regASThfnInst24 (.I ( rst_b ) , .Z ( rst_bASThfnNet24 ) ) ;
DFCND1HVT j_tdi_r_reg (.Q ( n1082 ) , .CDN ( rst_bASThfnNet24 ) , .D ( j_tdi ) 
    , .CP ( spi_clk_out_GB_G4B2I4ASTHIRNet245 ) ) ;
DFCND1HVT spi_sdi_r_reg (.Q ( spi_sdi_r ) , .CDN ( rst_bASThfnNet24 ) 
    , .QN ( n1613 ) , .D ( val238_1 ) , .CP ( spi_clk_out_GB_G4B2I2ASTHIRNet141 ) ) ;
IND2D0HVT U355 (.ZN ( smc_spi_sdo_oe_b779 ) , .A1 ( md_jtag ) 
    , .B1 ( sample_mode_done ) ) ;
endmodule




module serial_crc (crc_out , clk , rst_b , enable , init , data_in , 
    spi_clk_out_GB_G4B2I10ASTHIRNet292 , spi_clk_out_GB_G4B2I15ASTHIRNet126 , 
    spi_clk_out_GB_G4B2I16ASTHIRNet42 );
output [15:0] crc_out ;
input  clk ;
input  rst_b ;
input  enable ;
input  init ;
input  data_in ;
input  spi_clk_out_GB_G4B2I10ASTHIRNet292 ;
input  spi_clk_out_GB_G4B2I15ASTHIRNet126 ;
input  spi_clk_out_GB_G4B2I16ASTHIRNet42 ;

/* wire declarations */

wire n149 ;
wire n148 ;
wire n150 ;
wire n153 ;
wire n146 ;
wire n124 ;
wire n154 ;
wire n125 ;
wire n155 ;
wire n126 ;
wire n157 ;
wire n128 ;
wire n159 ;
wire n130 ;
wire n123 ;
wire n152 ;
wire n127 ;
wire n156 ;
wire n129 ;
wire n158 ;
wire n131 ;
wire n160 ;
wire n132 ;
wire n161 ;
wire n133 ;
wire n162 ;
wire n134 ;
wire n163 ;
wire n122 ;
wire n151 ;
wire n143 ;
wire n135 ;
wire n164 ;
wire n139 ;
wire n144 ;
wire n136 ;
wire n145 ;
wire n137 ;
wire n147 ;
wire rst_bASThfnNet8 ;
wire n138 ;
wire n140 ;

ND2D0HVT U54 (.ZN ( n149 ) , .A1 ( n148 ) , .A2 ( crc_out[11] ) ) ;
ND2D0HVT U55 (.ZN ( n150 ) , .A1 ( n148 ) , .A2 ( crc_out[4] ) ) ;
ND2D0HVT U60 (.ZN ( n153 ) , .A1 ( n146 ) , .A2 ( n124 ) ) ;
ND2D0HVT U62 (.ZN ( n154 ) , .A1 ( n146 ) , .A2 ( n125 ) ) ;
ND2D0HVT U64 (.ZN ( n155 ) , .A1 ( n146 ) , .A2 ( n126 ) ) ;
ND2D0HVT U68 (.ZN ( n157 ) , .A1 ( n146 ) , .A2 ( n128 ) ) ;
ND2D0HVT U72 (.ZN ( n159 ) , .A1 ( n146 ) , .A2 ( n130 ) ) ;
IND2D0HVT U58 (.A1 ( init ) , .B1 ( n123 ) , .ZN ( n152 ) ) ;
IND2D0HVT U66 (.A1 ( init ) , .B1 ( n127 ) , .ZN ( n156 ) ) ;
IND2D0HVT U70 (.A1 ( init ) , .B1 ( n129 ) , .ZN ( n158 ) ) ;
IND2D0HVT U74 (.A1 ( init ) , .B1 ( n131 ) , .ZN ( n160 ) ) ;
IND2D0HVT U76 (.A1 ( init ) , .B1 ( n132 ) , .ZN ( n161 ) ) ;
IND2D0HVT U78 (.A1 ( init ) , .B1 ( n133 ) , .ZN ( n162 ) ) ;
IND2D0HVT U80 (.A1 ( init ) , .B1 ( n134 ) , .ZN ( n163 ) ) ;
IND2D0HVT U56 (.A1 ( init ) , .B1 ( n122 ) , .ZN ( n151 ) ) ;
MUX2ND0HVT U63 (.ZN ( n125 ) , .I0 ( crc_out[11] ) , .S ( enable ) 
    , .I1 ( crc_out[10] ) ) ;
MUX2ND0HVT U65 (.ZN ( n126 ) , .I0 ( crc_out[10] ) , .S ( enable ) 
    , .I1 ( crc_out[9] ) ) ;
MUX2ND0HVT U67 (.ZN ( n127 ) , .I0 ( crc_out[9] ) , .S ( enable ) 
    , .I1 ( crc_out[8] ) ) ;
MUX2ND0HVT U69 (.ZN ( n128 ) , .I0 ( crc_out[8] ) , .S ( enable ) 
    , .I1 ( crc_out[7] ) ) ;
MUX2ND0HVT U71 (.ZN ( n129 ) , .I0 ( crc_out[7] ) , .S ( enable ) 
    , .I1 ( crc_out[6] ) ) ;
MUX2ND0HVT U73 (.ZN ( n130 ) , .I0 ( crc_out[6] ) , .S ( enable ) 
    , .I1 ( crc_out[5] ) ) ;
MUX2ND0HVT U57 (.ZN ( n122 ) , .I0 ( crc_out[15] ) , .S ( enable ) 
    , .I1 ( crc_out[14] ) ) ;
NR2D0HVT U82 (.A1 ( n143 ) , .A2 ( n148 ) , .ZN ( n135 ) ) ;
AO211D0HVT U92 (.Z ( n164 ) , .A2 ( n143 ) , .C ( init ) , .A1 ( crc_out[0] ) 
    , .B ( n135 ) ) ;
CKXOR2D0HVT U93 (.Z ( n148 ) , .A2 ( n139 ) , .A1 ( data_in ) ) ;
MUX2ND0HVT U75 (.ZN ( n131 ) , .I0 ( crc_out[4] ) , .S ( enable ) 
    , .I1 ( crc_out[3] ) ) ;
MUX2ND0HVT U77 (.ZN ( n132 ) , .I0 ( crc_out[3] ) , .S ( enable ) 
    , .I1 ( crc_out[2] ) ) ;
MUX2ND0HVT U79 (.ZN ( n133 ) , .I0 ( crc_out[2] ) , .S ( enable ) 
    , .I1 ( crc_out[1] ) ) ;
MUX2ND0HVT U81 (.ZN ( n134 ) , .I0 ( crc_out[1] ) , .S ( enable ) 
    , .I1 ( crc_out[0] ) ) ;
MUX2ND0HVT U59 (.ZN ( n123 ) , .I0 ( crc_out[14] ) , .S ( enable ) 
    , .I1 ( crc_out[13] ) ) ;
MUX2ND0HVT U61 (.ZN ( n124 ) , .I0 ( crc_out[13] ) , .S ( enable ) 
    , .I1 ( crc_out[12] ) ) ;
CKND0HVT U91 (.I ( enable ) , .ZN ( n143 ) ) ;
CKND0HVT U83 (.I ( n135 ) , .ZN ( n144 ) ) ;
CKND0HVT U88 (.I ( init ) , .ZN ( n146 ) ) ;
OAI211D0HVT U85 (.ZN ( n136 ) , .A1 ( crc_out[11] ) , .C ( n146 ) , .A2 ( n144 ) 
    , .B ( n145 ) ) ;
OAI211D0HVT U86 (.ZN ( n137 ) , .A1 ( crc_out[4] ) , .C ( n146 ) , .A2 ( n144 ) 
    , .B ( n147 ) ) ;
CKBD16HVT rst_b_regASThfnInst8 (.I ( rst_b ) , .Z ( rst_bASThfnNet8 ) ) ;
MUX2D0HVT U89 (.I1 ( n149 ) , .Z ( n145 ) , .S ( enable ) , .I0 ( n138 ) ) ;
MUX2D0HVT U90 (.I1 ( n150 ) , .Z ( n147 ) , .S ( enable ) , .I0 ( n140 ) ) ;
DFSND1HVT lfsr_reg_15_ (.D ( n151 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet126 ) , .QN ( n139 ) 
    , .Q ( crc_out[15] ) , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_14_ (.D ( n152 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet126 ) , .Q ( crc_out[14] ) 
    , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_13_ (.D ( n153 ) 
    , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet42 ) , .Q ( crc_out[13] ) 
    , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_12_ (.D ( n136 ) 
    , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet42 ) , .QN ( n138 ) 
    , .Q ( crc_out[12] ) , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_11_ (.D ( n154 ) 
    , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet42 ) , .Q ( crc_out[11] ) 
    , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_10_ (.D ( n155 ) 
    , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet42 ) , .Q ( crc_out[10] ) 
    , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_9_ (.D ( n156 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet126 ) , .Q ( crc_out[9] ) 
    , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_8_ (.D ( n157 ) , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet42 ) 
    , .Q ( crc_out[8] ) , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_7_ (.D ( n158 ) , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet42 ) 
    , .Q ( crc_out[7] ) , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_6_ (.D ( n159 ) , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet42 ) 
    , .Q ( crc_out[6] ) , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_5_ (.D ( n137 ) , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet42 ) 
    , .QN ( n140 ) , .Q ( crc_out[5] ) , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_4_ (.D ( n160 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet126 ) , .Q ( crc_out[4] ) 
    , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_3_ (.D ( n161 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet292 ) , .Q ( crc_out[3] ) 
    , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_2_ (.D ( n162 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet292 ) , .Q ( crc_out[2] ) 
    , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_1_ (.D ( n163 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet292 ) , .Q ( crc_out[1] ) 
    , .SDN ( rst_bASThfnNet8 ) ) ;
DFSND1HVT lfsr_reg_0_ (.D ( n164 ) , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet42 ) 
    , .Q ( crc_out[0] ) , .SDN ( rst_bASThfnNet8 ) ) ;
endmodule




module spi_smc_DW01_dec_8_0 (A , SUM );
input  [7:0] A ;
output [7:0] SUM ;

/* wire declarations */

wire carry_3 ;
wire carry_4 ;
wire carry_5 ;
wire carry_2 ;
wire carry_6 ;
wire carry_7 ;

OR2D0HVT U1_B_3 (.A2 ( carry_3 ) , .A1 ( A[3] ) , .Z ( carry_4 ) ) ;
OR2D0HVT U1_B_4 (.A2 ( carry_4 ) , .A1 ( A[4] ) , .Z ( carry_5 ) ) ;
OR2D0HVT U1_B_2 (.A2 ( carry_2 ) , .A1 ( A[2] ) , .Z ( carry_3 ) ) ;
OR2D0HVT U1_B_5 (.A2 ( carry_5 ) , .A1 ( A[5] ) , .Z ( carry_6 ) ) ;
OR2D0HVT U1_B_1 (.A2 ( A[0] ) , .A1 ( A[1] ) , .Z ( carry_2 ) ) ;
OR2D0HVT U1_B_6 (.A2 ( carry_6 ) , .A1 ( A[6] ) , .Z ( carry_7 ) ) ;
XNR2D0HVT U1_A_1 (.A2 ( A[0] ) , .ZN ( SUM[1] ) , .A1 ( A[1] ) ) ;
XNR2D0HVT U1_A_7 (.A2 ( carry_7 ) , .ZN ( SUM[7] ) , .A1 ( A[7] ) ) ;
XNR2D0HVT U1_A_2 (.A2 ( carry_2 ) , .ZN ( SUM[2] ) , .A1 ( A[2] ) ) ;
XNR2D0HVT U1_A_5 (.A2 ( carry_5 ) , .ZN ( SUM[5] ) , .A1 ( A[5] ) ) ;
XNR2D0HVT U1_A_3 (.A2 ( carry_3 ) , .ZN ( SUM[3] ) , .A1 ( A[3] ) ) ;
XNR2D0HVT U1_A_4 (.A2 ( carry_4 ) , .ZN ( SUM[4] ) , .A1 ( A[4] ) ) ;
XNR2D0HVT U1_A_6 (.A2 ( carry_6 ) , .ZN ( SUM[6] ) , .A1 ( A[6] ) ) ;
INVD0HVT U6 (.I ( A[0] ) , .ZN ( SUM[0] ) ) ;
endmodule




module spi_smc_DW01_dec_6_0 (A , SUM );
input  [5:0] A ;
output [5:0] SUM ;

/* wire declarations */

wire carry_2 ;
wire carry_3 ;
wire carry_4 ;
wire carry_5 ;

OR2D0HVT U1_B_2 (.A2 ( carry_2 ) , .A1 ( A[2] ) , .Z ( carry_3 ) ) ;
OR2D0HVT U1_B_1 (.A2 ( A[0] ) , .A1 ( A[1] ) , .Z ( carry_2 ) ) ;
XNR2D0HVT U1_A_3 (.A2 ( carry_3 ) , .ZN ( SUM[3] ) , .A1 ( A[3] ) ) ;
XNR2D0HVT U1_A_4 (.A2 ( carry_4 ) , .ZN ( SUM[4] ) , .A1 ( A[4] ) ) ;
XNR2D0HVT U1_A_1 (.A2 ( A[0] ) , .ZN ( SUM[1] ) , .A1 ( A[1] ) ) ;
XNR2D0HVT U1_A_2 (.A2 ( carry_2 ) , .ZN ( SUM[2] ) , .A1 ( A[2] ) ) ;
XNR2D0HVT U1_A_5 (.A2 ( carry_5 ) , .ZN ( SUM[5] ) , .A1 ( A[5] ) ) ;
INVD0HVT U6 (.I ( A[0] ) , .ZN ( SUM[0] ) ) ;
OR2D0HVT U1_B_3 (.A2 ( carry_3 ) , .A1 ( A[3] ) , .Z ( carry_4 ) ) ;
OR2D0HVT U1_B_4 (.A2 ( carry_4 ) , .A1 ( A[4] ) , .Z ( carry_5 ) ) ;
endmodule




module spi_smc_DW01_dec_5_0 (A , SUM );
input  [4:0] A ;
output [4:0] SUM ;

/* wire declarations */

wire carry_3 ;
wire carry_4 ;
wire carry_2 ;

INVD0HVT U6 (.I ( A[0] ) , .ZN ( SUM[0] ) ) ;
OR2D0HVT U1_B_3 (.A2 ( carry_3 ) , .A1 ( A[3] ) , .Z ( carry_4 ) ) ;
OR2D0HVT U1_B_2 (.A2 ( carry_2 ) , .A1 ( A[2] ) , .Z ( carry_3 ) ) ;
OR2D0HVT U1_B_1 (.A2 ( A[0] ) , .A1 ( A[1] ) , .Z ( carry_2 ) ) ;
XNR2D0HVT U1_A_1 (.A2 ( A[0] ) , .ZN ( SUM[1] ) , .A1 ( A[1] ) ) ;
XNR2D0HVT U1_A_2 (.A2 ( carry_2 ) , .ZN ( SUM[2] ) , .A1 ( A[2] ) ) ;
XNR2D0HVT U1_A_3 (.A2 ( carry_3 ) , .ZN ( SUM[3] ) , .A1 ( A[3] ) ) ;
XNR2D0HVT U1_A_4 (.A2 ( carry_4 ) , .ZN ( SUM[4] ) , .A1 ( A[4] ) ) ;
endmodule




module spi_smc (spi_clk_out_GB_G4B2I1ASTHIRNet231 , 
    spi_clk_out_GB_G4B2I14ASTHIRNet224 , spi_clk_out_GB_G4B2I11ASTHIRNet221 , 
    spi_clk_out_GB_G4B2I8ASTHIRNet185 , spi_clk_out_GB_G4B2I5ASTHIRNet168 , 
    spi_clk_out_GB_G4B2I18ASTHIRNet152 , spi_clk_out_GB_G4B2I2ASTHIRNet143 , 
    spi_clk_out_GB_G4B2I13ASTHIRNet303 , spi_clk_out_GB_G4B2I10ASTHIRNet290 , 
    spi_clk_out_GB_G4B2I7ASTHIRNet263 , spi_clk_out_GB_G4B2I4ASTHIRNet241 , 
    sio_data_reg , clk , rst_b , crc_reg , sdi , cfg_startup , 
    usercode_reg , spi_clk_out_GB_G4B2I9ASTHIRNet86 , 
    spi_clk_out_GB_G4B2I6ASTHIRNet60 , cdone_in , spi_rxpreamble_fail , 
    bitstream_err , cor_dis_flashpd , cmdhead_cnt_ld , cmd_sr_datacnt_ld , 
    smc_status_ld , smc_crc_ld , smc_usercode_ld , md_spi , 
    spi_clk_out_GB_G4B2I15ASTHIRNet122 , spi_clk_out_GB_G4B2I12ASTHIRNet116 , 
    md_jtag , md_jtag_rst , j_cfg_enable , j_cfg_disable , j_cfg_program , 
    j_sft_dr , tx_spicmd_read_req , disable_flash_req_BAR , cmdhead_reg , 
    bs_smc_cmdhead_en , bs_smc_sdio_en , spi_rd_cmdaddr , 
    spi_ss_out_b_int , sr_datacnt_0 , cmdhead_cnt_0_BAR , spi_tx_done , 
    status_int );
input  spi_clk_out_GB_G4B2I1ASTHIRNet231 ;
input  spi_clk_out_GB_G4B2I14ASTHIRNet224 ;
input  spi_clk_out_GB_G4B2I11ASTHIRNet221 ;
input  spi_clk_out_GB_G4B2I8ASTHIRNet185 ;
input  spi_clk_out_GB_G4B2I5ASTHIRNet168 ;
input  spi_clk_out_GB_G4B2I18ASTHIRNet152 ;
input  spi_clk_out_GB_G4B2I2ASTHIRNet143 ;
input  spi_clk_out_GB_G4B2I13ASTHIRNet303 ;
input  spi_clk_out_GB_G4B2I10ASTHIRNet290 ;
input  spi_clk_out_GB_G4B2I7ASTHIRNet263 ;
input  spi_clk_out_GB_G4B2I4ASTHIRNet241 ;
output [31:0] sio_data_reg ;
input  clk ;
input  rst_b ;
input  [15:0] crc_reg ;
input  sdi ;
input  cfg_startup ;
input  [31:0] usercode_reg ;
input  spi_clk_out_GB_G4B2I9ASTHIRNet86 ;
input  spi_clk_out_GB_G4B2I6ASTHIRNet60 ;
input  cdone_in ;
input  spi_rxpreamble_fail ;
input  bitstream_err ;
input  cor_dis_flashpd ;
input  cmdhead_cnt_ld ;
input  cmd_sr_datacnt_ld ;
input  smc_status_ld ;
input  smc_crc_ld ;
input  smc_usercode_ld ;
input  md_spi ;
input  spi_clk_out_GB_G4B2I15ASTHIRNet122 ;
input  spi_clk_out_GB_G4B2I12ASTHIRNet116 ;
input  md_jtag ;
input  md_jtag_rst ;
input  j_cfg_enable ;
input  j_cfg_disable ;
input  j_cfg_program ;
input  j_sft_dr ;
input  tx_spicmd_read_req ;
input  disable_flash_req_BAR ;
output [7:0] cmdhead_reg ;
input  bs_smc_cmdhead_en ;
input  bs_smc_sdio_en ;
input  [31:0] spi_rd_cmdaddr ;
output spi_ss_out_b_int ;
output sr_datacnt_0 ;
output cmdhead_cnt_0_BAR ;
output spi_tx_done ;
input  [31:0] status_int ;

/* wire declarations */
wire spicnt_7_ ;
wire spicnt_6_ ;
wire spicnt_5_ ;
wire spicnt_4_ ;
wire spicnt_3_ ;
wire spicnt_2_ ;
wire spicnt_1_ ;
wire spicnt_0_ ;
wire spicnt348_7 ;
wire spicnt348_6 ;
wire spicnt348_5 ;
wire spicnt348_4 ;
wire spicnt348_3 ;
wire spicnt348_2 ;
wire spicnt348_1 ;
wire spicnt348_0 ;
wire sr_datacnt_3_ ;
wire sr_datacnt_2_ ;
wire sr_datacnt_1_ ;
wire sr_datacnt_0_ ;
wire sr_datacnt687_5 ;
wire sr_datacnt687_4 ;
wire sr_datacnt687_3 ;
wire sr_datacnt687_2 ;
wire sr_datacnt687_1 ;
wire sr_datacnt687_0 ;
wire sr_datacnt_5_ ;
wire sr_datacnt_4_ ;
wire cmdhead_cnt_1_ ;
wire cmdhead_cnt_0_ ;
wire cmdhead_cnt833_4 ;
wire cmdhead_cnt833_3 ;
wire cmdhead_cnt833_2 ;
wire cmdhead_cnt833_1 ;
wire cmdhead_cnt833_0 ;
wire cmdhead_cnt_4_ ;
wire cmdhead_cnt_3_ ;
wire cmdhead_cnt_2_ ;

wire n1271 ;
wire n1204 ;
wire n1307 ;
wire n1421 ;
wire n1182 ;
wire state_2_ ;
wire n1423 ;
wire n1183 ;
wire n1430 ;
wire n1531 ;
wire n1184 ;
wire n1178 ;
wire n1529 ;
wire n1177 ;
wire n1176 ;
wire n1179 ;
wire n1539 ;
wire n1541 ;
wire n1540 ;
wire n1310 ;
wire n1565 ;
wire n1265 ;
wire n1536 ;
wire n1221 ;
wire n1553 ;
wire n1191 ;
wire n1273 ;
wire n1559 ;
wire n1234 ;
wire n1198 ;
wire n1530 ;
wire n1235 ;
wire n1224 ;
wire n1236 ;
wire n1185 ;
wire n1425 ;
wire n1427 ;
wire n1186 ;
wire n1188 ;
wire n1228 ;
wire n1229 ;
wire n1200 ;
wire n1175 ;
wire n1268 ;
wire n1238 ;
wire n1272 ;
wire n1239 ;
wire n1537 ;
wire n1241 ;
wire n1230 ;
wire n1242 ;
wire state_0_ ;
wire n1222 ;
wire n1258 ;
wire n1259 ;
wire n1223 ;
wire n1232 ;
wire n1545 ;
wire n1546 ;
wire n1233 ;
wire n1197 ;
wire n1244 ;
wire n1263 ;
wire n1270 ;
wire n1249 ;
wire n1269 ;
wire n1543 ;
wire n1567 ;
wire n1181 ;
wire n1570 ;
wire n1243 ;
wire state_3_ ;
wire n1267 ;
wire n1561 ;
wire n1187 ;
wire n1411 ;
wire n1419 ;
wire n1417 ;
wire n1409 ;
wire n1237 ;
wire n1564 ;
wire n1528 ;
wire n1538 ;
wire n1199 ;
wire n1203 ;
wire n1542 ;
wire n1245 ;
wire sio_data_reg_int451_9 ;
wire n1202 ;
wire n1552 ;
wire n1210 ;
wire n1211 ;
wire sio_data_reg_int451_21 ;
wire n1209 ;
wire n1555 ;
wire n1215 ;
wire n1216 ;
wire sio_data_reg_int451_19 ;
wire n1214 ;
wire n1218 ;
wire n1219 ;
wire sio_data_reg_int451_23 ;
wire n1217 ;
wire n1571 ;
wire n1569 ;
wire n1180 ;
wire n1544 ;
wire n1195 ;
wire n1220 ;
wire n1429 ;
wire n1189 ;
wire n1533 ;
wire n1554 ;
wire n1266 ;
wire n1413 ;
wire n1415 ;
wire n1260 ;
wire n1532 ;
wire n1547 ;
wire n1557 ;
wire n1299 ;
wire n1275 ;
wire n1558 ;
wire n1251 ;
wire n1261 ;
wire state_1_ ;
wire n1264 ;
wire n1194 ;
wire n1196 ;
wire n1556 ;
wire n1300 ;
wire n1250 ;
wire n1283 ;
wire n1247 ;
wire cmdcode_byte_0ASTHNet34 ;
wire n1190 ;
wire n1407 ;
wire n1311 ;
wire n1563 ;
wire n1225 ;
wire sio_data_reg_int451_27 ;
wire n1226 ;
wire n1549 ;
wire n1550 ;
wire n1405 ;
wire n1201 ;
wire n1231 ;
wire n1309 ;
wire n1248 ;
wire n1548 ;
wire n1246 ;
wire n1206 ;
wire n1208 ;
wire n1213 ;
wire n1205 ;
wire sio_data_reg_int451_29 ;
wire n1207 ;
wire sio_data_reg_int451_24 ;
wire n1212 ;
wire sio_data_reg_int451_31 ;
wire n1551 ;
wire sr_datacnt685_5 ;
wire cmdhead_cnt831_4 ;
wire cmdhead_cnt831_3 ;
wire rst_bASThfnNet5 ;
wire rst_bASThfnNet6 ;
wire n1296 ;
wire sio_data_reg_int451_2 ;
wire n1286 ;
wire sio_data_reg_int451_13 ;
wire n1297 ;
wire sio_data_reg_int451_1 ;
wire n1262 ;
wire spicnt346_6 ;
wire spicnt346_5 ;
wire spicnt346_3 ;
wire n1290 ;
wire sio_data_reg_int451_8 ;
wire n1289 ;
wire sio_data_reg_int451_10 ;
wire n1294 ;
wire sio_data_reg_int451_4 ;
wire n1287 ;
wire sio_data_reg_int451_12 ;
wire n1293 ;
wire sio_data_reg_int451_5 ;
wire n1284 ;
wire sio_data_reg_int451_15 ;
wire n1295 ;
wire sio_data_reg_int451_3 ;
wire n1285 ;
wire sio_data_reg_int451_14 ;
wire n1279 ;
wire sio_data_reg_int451_18 ;
wire n1281 ;
wire sio_data_reg_int451_16 ;
wire n1280 ;
wire sio_data_reg_int451_17 ;
wire n1306 ;
wire sio_data_reg_int451_30 ;
wire n1301 ;
wire sio_data_reg_int451_28 ;
wire n1288 ;
wire sio_data_reg_int451_11 ;
wire n1298 ;
wire sio_data_reg_int451_0 ;
wire n1291 ;
wire sio_data_reg_int451_7 ;
wire n832_0 ;
wire cmdhead_cnt831_2 ;
wire cmdhead_cnt831_1 ;
wire n1305 ;
wire sio_data_reg_int451_26 ;
wire n1302 ;
wire sio_data_reg_int451_25 ;
wire n1292 ;
wire sio_data_reg_int451_6 ;
wire n1277 ;
wire sio_data_reg_int451_22 ;
wire n1278 ;
wire sio_data_reg_int451_20 ;
wire spicnt346_1 ;
wire n1304 ;
wire sr_datacnt685_2 ;
wire sr_datacnt685_1 ;
wire sr_datacnt685_0 ;
wire n_1545 ;
wire n1227 ;
wire cmdhead_cnt831_0 ;
wire spicnt346_2 ;
wire n1240 ;
wire n1308 ;
wire n1303 ;
wire n347_0 ;
wire spicnt346_0 ;
wire n1170 ;
wire n686_0 ;
wire spicnt346_7 ;
wire n1168 ;
wire spicnt346_4 ;
wire n1560 ;
wire n_1943 ;
wire n1167 ;
wire n1171 ;
wire n1174 ;
wire n1172 ;
wire n1173 ;
wire n1169 ;
wire n1192 ;
wire n1193 ;
wire sr_datacnt685_4 ;
wire sr_datacnt685_3 ;
wire n_1529 ;
wire n1403 ;
wire n1562 ;
wire n1566 ;
wire n1568 ;
wire n1534 ;
wire n1535 ;


spi_smc_DW01_dec_8_0 sub_285 (
    .A ( {spicnt_7_ , spicnt_6_ , spicnt_5_ , spicnt_4_ , spicnt_3_ , 
	spicnt_2_ , spicnt_1_ , spicnt_0_ } ) , 
    .SUM ( {spicnt348_7 , spicnt348_6 , spicnt348_5 , spicnt348_4 , 
	spicnt348_3 , spicnt348_2 , spicnt348_1 , spicnt348_0 } ) ) ;


spi_smc_DW01_dec_6_0 sub_337 (
    .SUM ( {sr_datacnt687_5 , sr_datacnt687_4 , sr_datacnt687_3 , 
	sr_datacnt687_2 , sr_datacnt687_1 , sr_datacnt687_0 } ) , 
    .A ( {sr_datacnt_5_ , sr_datacnt_4_ , sr_datacnt_3_ , sr_datacnt_2_ , 
	sr_datacnt_1_ , sr_datacnt_0_ } ) ) ;


spi_smc_DW01_dec_5_0 sub_355 (
    .SUM ( {cmdhead_cnt833_4 , cmdhead_cnt833_3 , cmdhead_cnt833_2 , 
	cmdhead_cnt833_1 , cmdhead_cnt833_0 } ) , 
    .A ( {cmdhead_cnt_4_ , cmdhead_cnt_3_ , cmdhead_cnt_2_ , cmdhead_cnt_1_ , 
	cmdhead_cnt_0_ } ) ) ;

NR2D2HVT U595 (.A1 ( smc_usercode_ld ) , .A2 ( n1271 ) , .ZN ( n1204 ) ) ;
NR2D0HVT U554 (.A1 ( n1307 ) , .A2 ( n1421 ) , .ZN ( n1182 ) ) ;
NR2D0HVT U555 (.A1 ( state_2_ ) , .A2 ( n1423 ) , .ZN ( n1183 ) ) ;
NR2D0HVT U558 (.A1 ( n1430 ) , .A2 ( n1531 ) , .ZN ( n1184 ) ) ;
ND3D0HVT U548 (.A1 ( n1178 ) , .ZN ( n1529 ) , .A2 ( n1177 ) , .A3 ( n1176 ) ) ;
ND3D0HVT U550 (.A1 ( n1179 ) , .ZN ( n1539 ) , .A2 ( n1541 ) 
    , .A3 ( cmd_sr_datacnt_ld ) ) ;
OAI31D1HVT U549 (.A2 ( cmdhead_reg[1] ) , .A1 ( n1540 ) , .ZN ( n1310 ) 
    , .A3 ( n1539 ) , .B ( n1565 ) ) ;
NR2D3HVT U617 (.A1 ( n1265 ) , .A2 ( n1536 ) , .ZN ( n1221 ) ) ;
NR2D2HVT U575 (.A1 ( n1221 ) , .A2 ( n1553 ) , .ZN ( n1191 ) ) ;
NR2D0HVT U665 (.A1 ( n1273 ) , .A2 ( n1559 ) , .ZN ( n1234 ) ) ;
NR2D0HVT U666 (.A1 ( n1198 ) , .A2 ( n1530 ) , .ZN ( n1235 ) ) ;
NR2D0HVT U667 (.A1 ( n1224 ) , .A2 ( n1530 ) , .ZN ( n1236 ) ) ;
NR2D0HVT U560 (.A1 ( state_2_ ) , .A2 ( n1531 ) , .ZN ( n1185 ) ) ;
NR2D0HVT U562 (.A1 ( n1425 ) , .A2 ( n1427 ) , .ZN ( n1186 ) ) ;
NR2D0HVT U567 (.A1 ( n1425 ) , .A2 ( n1307 ) , .ZN ( n1188 ) ) ;
NR2D0HVT U588 (.A1 ( n1228 ) , .A2 ( n1229 ) , .ZN ( n1200 ) ) ;
NR2D0HVT U547 (.A1 ( cmdhead_reg[1] ) , .A2 ( cmdhead_reg[0] ) , .ZN ( n1175 ) ) ;
NR2D0HVT U669 (.A1 ( n1268 ) , .A2 ( n1530 ) , .ZN ( n1238 ) ) ;
NR2D0HVT U670 (.A1 ( n1565 ) , .A2 ( n1272 ) , .ZN ( n1239 ) ) ;
NR2D0HVT U671 (.A1 ( disable_flash_req_BAR ) , .A2 ( n1537 ) , .ZN ( n1241 ) ) ;
NR2D0HVT U672 (.A1 ( smc_crc_ld ) , .A2 ( n1230 ) , .ZN ( n1242 ) ) ;
NR2D0HVT U619 (.A1 ( state_0_ ) , .A2 ( state_2_ ) , .ZN ( n1222 ) ) ;
NR2D0HVT U621 (.A1 ( n1258 ) , .A2 ( n1259 ) , .ZN ( n1223 ) ) ;
NR2D0HVT U663 (.A1 ( n1242 ) , .A2 ( n1310 ) , .ZN ( n1232 ) ) ;
NR2D0HVT U664 (.A1 ( n1545 ) , .A2 ( n1546 ) , .ZN ( n1233 ) ) ;
AOI21D0HVT U582 (.A2 ( n1307 ) , .ZN ( n1197 ) , .A1 ( n1244 ) , .B ( n1263 ) ) ;
AOI21D0HVT U706 (.A2 ( n1270 ) , .ZN ( n1249 ) , .A1 ( n1269 ) , .B ( n1271 ) ) ;
OAI21D0HVT U552 (.A2 ( n1543 ) , .ZN ( n1567 ) , .A1 ( n1181 ) , .B ( n1570 ) ) ;
MUX2D0HVT U553 (.I1 ( n1182 ) , .Z ( n1243 ) , .S ( state_3_ ) , .I0 ( n1267 ) ) ;
MUX2D0HVT U630 (.I1 ( n1185 ) , .Z ( n1561 ) , .S ( sr_datacnt_0 ) 
    , .I0 ( n1187 ) ) ;
MUX2D0HVT U631 (.I1 ( cdone_in ) , .Z ( n1307 ) , .S ( cfg_startup ) 
    , .I0 ( n1411 ) ) ;
MUX2D0HVT U644 (.I1 ( n1419 ) , .Z ( n1417 ) , .S ( md_jtag ) , .I0 ( n1409 ) ) ;
NR2D0HVT U668 (.A1 ( n1197 ) , .A2 ( n1530 ) , .ZN ( n1237 ) ) ;
CKND0HVT U583 (.I ( n1197 ) , .ZN ( n1258 ) ) ;
OAI221D0HVT U557 (.C ( n1564 ) , .A2 ( n1528 ) , .A1 ( n1267 ) , .ZN ( n1538 ) 
    , .B1 ( n1536 ) , .B2 ( n1199 ) ) ;
OAI221D0HVT U592 (.C ( n1203 ) , .A2 ( n1542 ) , .A1 ( n1245 ) 
    , .ZN ( sio_data_reg_int451_9 ) , .B1 ( n1202 ) , .B2 ( n1552 ) ) ;
OAI221D0HVT U603 (.C ( n1210 ) , .A2 ( n1272 ) , .A1 ( n1211 ) 
    , .ZN ( sio_data_reg_int451_21 ) , .B1 ( n1209 ) , .B2 ( n1555 ) ) ;
OAI221D0HVT U609 (.C ( n1215 ) , .A2 ( n1272 ) , .A1 ( n1216 ) 
    , .ZN ( sio_data_reg_int451_19 ) , .B1 ( n1214 ) , .B2 ( n1555 ) ) ;
OAI221D0HVT U612 (.C ( n1218 ) , .A2 ( n1272 ) , .A1 ( n1219 ) 
    , .ZN ( sio_data_reg_int451_23 ) , .B1 ( n1217 ) , .B2 ( n1555 ) ) ;
AOI21D0HVT U551 (.A2 ( n1571 ) , .ZN ( n1569 ) , .A1 ( n1180 ) , .B ( n1544 ) ) ;
AOI21D0HVT U581 (.A2 ( n1258 ) , .ZN ( n1195 ) , .A1 ( n1259 ) , .B ( n1223 ) ) ;
CKND0HVT U616 (.I ( n1220 ) , .ZN ( n1272 ) ) ;
CKND0HVT U556 (.I ( n1183 ) , .ZN ( n1425 ) ) ;
CKND0HVT U559 (.I ( n1184 ) , .ZN ( n1536 ) ) ;
CKND0HVT U561 (.I ( n1185 ) , .ZN ( n1564 ) ) ;
CKND0HVT U563 (.I ( n1186 ) , .ZN ( n1429 ) ) ;
CKND0HVT U565 (.I ( n1187 ) , .ZN ( n1528 ) ) ;
CKND0HVT U572 (.I ( n1189 ) , .ZN ( n1533 ) ) ;
CKND0HVT U576 (.I ( n1191 ) , .ZN ( n1554 ) ) ;
CKND0HVT U643 (.I ( n1267 ) , .ZN ( sr_datacnt_0 ) ) ;
CKND0HVT U587 (.I ( n1199 ) , .ZN ( n1265 ) ) ;
CKND0HVT U589 (.I ( n1200 ) , .ZN ( n1266 ) ) ;
CKND0HVT U593 (.I ( usercode_reg[9] ) , .ZN ( n1202 ) ) ;
CKND0HVT U596 (.I ( n1204 ) , .ZN ( n1542 ) ) ;
CKND0HVT U604 (.I ( spi_rd_cmdaddr[21] ) , .ZN ( n1209 ) ) ;
CKND0HVT U610 (.I ( spi_rd_cmdaddr[19] ) , .ZN ( n1214 ) ) ;
CKND0HVT U613 (.I ( spi_rd_cmdaddr[23] ) , .ZN ( n1217 ) ) ;
CKND0HVT U656 (.I ( smc_crc_ld ) , .ZN ( n1270 ) ) ;
CKND0HVT U618 (.I ( n1221 ) , .ZN ( n1555 ) ) ;
CKND0HVT U620 (.I ( n1222 ) , .ZN ( n1413 ) ) ;
CKND0HVT U622 (.I ( n1223 ) , .ZN ( n1415 ) ) ;
CKND0HVT U624 (.I ( n1224 ) , .ZN ( n1260 ) ) ;
CKND0HVT U634 (.I ( tx_spicmd_read_req ) , .ZN ( n1532 ) ) ;
CKND0HVT U637 (.I ( smc_status_ld ) , .ZN ( n1553 ) ) ;
CKND0HVT U642 (.I ( n1310 ) , .ZN ( n1547 ) ) ;
CKND0HVT U699 (.I ( n1557 ) , .ZN ( n1299 ) ) ;
CKND0HVT U647 (.I ( cmdhead_cnt_ld ) , .ZN ( n1275 ) ) ;
CKND0HVT U648 (.I ( md_jtag ) , .ZN ( n1558 ) ) ;
CKND0HVT U650 (.I ( md_spi ) , .ZN ( n1421 ) ) ;
CKND0HVT U651 (.I ( n1571 ) , .ZN ( n1543 ) ) ;
CKND0HVT U652 (.I ( n1570 ) , .ZN ( n1544 ) ) ;
CKND0HVT U654 (.I ( n1273 ) , .ZN ( n1565 ) ) ;
CKND0HVT U655 (.I ( n1249 ) , .ZN ( n1251 ) ) ;
MUX2ND0HVT U566 (.ZN ( n1261 ) , .I0 ( n1188 ) , .S ( state_1_ ) , .I1 ( n1222 ) ) ;
MUX2ND0HVT U579 (.ZN ( n1264 ) , .I0 ( n1195 ) , .S ( n1194 ) , .I1 ( n1196 ) ) ;
CKND0HVT U705 (.I ( n1556 ) , .ZN ( n1300 ) ) ;
CKND0HVT U657 (.I ( n1249 ) , .ZN ( n1250 ) ) ;
CKND0HVT U658 (.I ( state_2_ ) , .ZN ( n1430 ) ) ;
CKND0HVT U659 (.I ( state_0_ ) , .ZN ( n1423 ) ) ;
CKND0HVT U660 (.I ( cor_dis_flashpd ) , .ZN ( n1537 ) ) ;
CKND0HVT U691 (.I ( n1552 ) , .ZN ( n1283 ) ) ;
INVD0HVT U698 (.I ( n1557 ) , .ZN ( n1247 ) ) ;
BUFFD3HVT sio_data_reg_int_reg_0_ASTttcInst33 (.Z ( sio_data_reg[0] ) 
    , .I ( cmdcode_byte_0ASTHNet34 ) ) ;
OAI31D0HVT U580 (.A2 ( n1258 ) , .A1 ( n1198 ) , .ZN ( n1194 ) , .A3 ( n1260 ) 
    , .B ( n1268 ) ) ;
NR3D0HVT U574 (.A1 ( state_0_ ) , .ZN ( n1190 ) , .A2 ( n1430 ) , .A3 ( n1407 ) ) ;
NR3D0HVT U662 (.A1 ( cmdhead_reg[0] ) , .ZN ( n1230 ) , .A2 ( n1311 ) 
    , .A3 ( n1539 ) ) ;
NR3D0HVT U564 (.A1 ( state_0_ ) , .ZN ( n1187 ) , .A2 ( n1430 ) , .A3 ( n1427 ) ) ;
NR3D0HVT U571 (.A1 ( n1423 ) , .ZN ( n1189 ) , .A2 ( n1430 ) , .A3 ( n1427 ) ) ;
NR3D1HVT U661 (.A1 ( n1197 ) , .ZN ( n1229 ) , .A2 ( n1563 ) , .A3 ( n1224 ) ) ;
IND3D0HVT U626 (.B2 ( n1225 ) , .A1 ( n1239 ) , .ZN ( sio_data_reg_int451_27 ) 
    , .B1 ( n1226 ) ) ;
NR4D0HVT U584 (.A2 ( n1549 ) , .A3 ( n1550 ) , .A4 ( n1244 ) , .A1 ( n1538 ) 
    , .ZN ( n1198 ) ) ;
NR4D0HVT U673 (.A2 ( n1405 ) , .A3 ( n1425 ) , .A4 ( n1421 ) , .A1 ( state_1_ ) 
    , .ZN ( n1244 ) ) ;
INR3D0HVT U591 (.B2 ( n1545 ) , .A1 ( n1546 ) , .ZN ( n1201 ) , .B1 ( n1231 ) ) ;
INR3D0HVT U635 (.B2 ( n1241 ) , .A1 ( n1186 ) , .ZN ( n1309 ) 
    , .B1 ( tx_spicmd_read_req ) ) ;
INVD0HVT U700 (.I ( n1556 ) , .ZN ( n1248 ) ) ;
INVD0HVT U568 (.I ( n1198 ) , .ZN ( n1548 ) ) ;
INVD0HVT U675 (.I ( n1552 ) , .ZN ( n1246 ) ) ;
AOI22D0HVT U628 (.B1 ( crc_reg[11] ) , .ZN ( n1226 ) , .B2 ( n1247 ) 
    , .A1 ( usercode_reg[27] ) , .A2 ( n1248 ) ) ;
AOI22D0HVT U594 (.B1 ( status_int[9] ) , .ZN ( n1203 ) , .B2 ( n1191 ) 
    , .A1 ( n1221 ) , .A2 ( spi_rd_cmdaddr[9] ) ) ;
AOI22D0HVT U599 (.B1 ( crc_reg[13] ) , .ZN ( n1206 ) , .B2 ( n1247 ) 
    , .A1 ( usercode_reg[29] ) , .A2 ( n1248 ) ) ;
AOI22D0HVT U602 (.B1 ( crc_reg[8] ) , .ZN ( n1208 ) , .B2 ( n1247 ) 
    , .A1 ( usercode_reg[24] ) , .A2 ( n1248 ) ) ;
AOI22D0HVT U608 (.B1 ( crc_reg[15] ) , .ZN ( n1213 ) , .B2 ( n1247 ) 
    , .A1 ( usercode_reg[31] ) , .A2 ( n1248 ) ) ;
IND3D0HVT U597 (.B2 ( n1205 ) , .A1 ( n1239 ) , .ZN ( sio_data_reg_int451_29 ) 
    , .B1 ( n1206 ) ) ;
IND3D0HVT U600 (.B2 ( n1207 ) , .A1 ( n1239 ) , .ZN ( sio_data_reg_int451_24 ) 
    , .B1 ( n1208 ) ) ;
IND3D0HVT U606 (.B2 ( n1212 ) , .A1 ( n1239 ) , .ZN ( sio_data_reg_int451_31 ) 
    , .B1 ( n1213 ) ) ;
AOI222D0HVT U614 (.A2 ( n1299 ) , .A1 ( crc_reg[7] ) , .ZN ( n1218 ) 
    , .C2 ( n1300 ) , .B1 ( status_int[23] ) , .B2 ( n1191 ) 
    , .C1 ( usercode_reg[23] ) ) ;
AOI222D0HVT U627 (.A2 ( n1221 ) , .A1 ( spi_rd_cmdaddr[27] ) , .ZN ( n1225 ) 
    , .C2 ( n1220 ) , .B1 ( status_int[27] ) , .B2 ( n1191 ) 
    , .C1 ( sio_data_reg[26] ) ) ;
AOI222D0HVT U598 (.A2 ( n1221 ) , .A1 ( spi_rd_cmdaddr[29] ) , .ZN ( n1205 ) 
    , .C2 ( n1220 ) , .B1 ( status_int[29] ) , .B2 ( n1191 ) 
    , .C1 ( sio_data_reg[28] ) ) ;
AOI222D0HVT U601 (.A2 ( n1221 ) , .A1 ( spi_rd_cmdaddr[24] ) , .ZN ( n1207 ) 
    , .C2 ( n1220 ) , .B1 ( status_int[24] ) , .B2 ( n1191 ) 
    , .C1 ( sio_data_reg[23] ) ) ;
AOI222D0HVT U605 (.A2 ( n1299 ) , .A1 ( crc_reg[5] ) , .ZN ( n1210 ) 
    , .C2 ( n1300 ) , .B1 ( status_int[21] ) , .B2 ( n1191 ) 
    , .C1 ( usercode_reg[21] ) ) ;
AOI31D0HVT U623 (.B ( n1551 ) , .A1 ( n1222 ) , .ZN ( n1224 ) , .A3 ( n1243 ) 
    , .A2 ( state_1_ ) ) ;
IND2D0HVT U629 (.A1 ( n1271 ) , .B1 ( smc_usercode_ld ) , .ZN ( n1552 ) ) ;
IND2D0HVT U653 (.A1 ( n1417 ) , .B1 ( bs_smc_sdio_en ) , .ZN ( n1559 ) ) ;
CKAN2D1HVT U641 (.Z ( sr_datacnt685_5 ) , .A1 ( n1201 ) 
    , .A2 ( sr_datacnt687_5 ) ) ;
CKAN2D1HVT U645 (.Z ( cmdhead_cnt831_4 ) , .A1 ( cmdhead_cnt833_4 ) 
    , .A2 ( n1275 ) ) ;
CKAN2D1HVT U646 (.Z ( cmdhead_cnt831_3 ) , .A1 ( cmdhead_cnt833_3 ) 
    , .A2 ( n1275 ) ) ;
CKAN2D1HVT U633 (.Z ( n1409 ) , .A1 ( spi_ss_out_b_int ) , .A2 ( md_spi ) ) ;
CKBD16HVT rst_b_regASThfnInst5 (.I ( rst_b ) , .Z ( rst_bASThfnNet5 ) ) ;
CKBD4HVT rst_b_regASThfnInst6 (.Z ( rst_bASThfnNet6 ) , .I ( rst_bASThfnNet5 ) ) ;
AOI222D0HVT U607 (.A2 ( n1221 ) , .A1 ( spi_rd_cmdaddr[31] ) , .ZN ( n1212 ) 
    , .C2 ( n1220 ) , .B1 ( status_int[31] ) , .B2 ( n1191 ) 
    , .C1 ( sio_data_reg[30] ) ) ;
AOI222D0HVT U611 (.A2 ( n1299 ) , .A1 ( crc_reg[3] ) , .ZN ( n1215 ) 
    , .C2 ( n1300 ) , .B1 ( status_int[19] ) , .B2 ( n1191 ) 
    , .C1 ( usercode_reg[19] ) ) ;
AO221D0HVT U679 (.B1 ( usercode_reg[2] ) , .B2 ( n1283 ) , .C ( n1296 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[1] ) , .Z ( sio_data_reg_int451_2 ) ) ;
AO221D0HVT U680 (.B1 ( usercode_reg[13] ) , .B2 ( n1246 ) , .C ( n1286 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[12] ) , .Z ( sio_data_reg_int451_13 ) ) ;
AO221D0HVT U681 (.B1 ( usercode_reg[1] ) , .B2 ( n1246 ) , .C ( n1297 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[0] ) , .Z ( sio_data_reg_int451_1 ) ) ;
OA32D0HVT U636 (.Z ( n1262 ) , .B2 ( n1267 ) , .B1 ( n1528 ) 
    , .A3 ( tx_spicmd_read_req ) , .A2 ( disable_flash_req_BAR ) , .A1 ( n1429 ) ) ;
OA31D0HVT U649 (.B ( n1262 ) , .A3 ( n1261 ) , .Z ( n1268 ) , .A1 ( n1421 ) 
    , .A2 ( n1405 ) ) ;
CKAN2D1HVT U638 (.Z ( spicnt346_6 ) , .A1 ( spicnt348_6 ) , .A2 ( n1200 ) ) ;
CKAN2D1HVT U639 (.Z ( spicnt346_5 ) , .A1 ( spicnt348_5 ) , .A2 ( n1200 ) ) ;
CKAN2D1HVT U640 (.Z ( spicnt346_3 ) , .A1 ( spicnt348_3 ) , .A2 ( n1200 ) ) ;
AO221D0HVT U685 (.B1 ( usercode_reg[8] ) , .B2 ( n1283 ) , .C ( n1290 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[7] ) , .Z ( sio_data_reg_int451_8 ) ) ;
AO221D0HVT U686 (.B1 ( usercode_reg[10] ) , .B2 ( n1283 ) , .C ( n1289 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[9] ) , .Z ( sio_data_reg_int451_10 ) ) ;
AO221D0HVT U687 (.B1 ( usercode_reg[4] ) , .B2 ( n1283 ) , .C ( n1294 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[3] ) , .Z ( sio_data_reg_int451_4 ) ) ;
AO221D0HVT U688 (.B1 ( usercode_reg[12] ) , .B2 ( n1246 ) , .C ( n1287 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[11] ) , .Z ( sio_data_reg_int451_12 ) ) ;
AO221D0HVT U689 (.B1 ( usercode_reg[5] ) , .B2 ( n1246 ) , .C ( n1293 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[4] ) , .Z ( sio_data_reg_int451_5 ) ) ;
AO221D0HVT U676 (.B1 ( usercode_reg[15] ) , .B2 ( n1246 ) , .C ( n1284 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[14] ) , .Z ( sio_data_reg_int451_15 ) ) ;
AO221D0HVT U677 (.B1 ( usercode_reg[3] ) , .B2 ( n1283 ) , .C ( n1295 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[2] ) , .Z ( sio_data_reg_int451_3 ) ) ;
AO221D0HVT U678 (.B1 ( usercode_reg[14] ) , .B2 ( n1246 ) , .C ( n1285 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[13] ) , .Z ( sio_data_reg_int451_14 ) ) ;
AO221D0HVT U694 (.B1 ( spi_rd_cmdaddr[18] ) , .B2 ( n1221 ) , .C ( n1279 ) 
    , .A2 ( n1220 ) , .A1 ( sio_data_reg[17] ) , .Z ( sio_data_reg_int451_18 ) ) ;
AO221D0HVT U695 (.B1 ( spi_rd_cmdaddr[16] ) , .B2 ( n1221 ) , .C ( n1281 ) 
    , .A2 ( n1220 ) , .A1 ( sio_data_reg[15] ) , .Z ( sio_data_reg_int451_16 ) ) ;
AO221D0HVT U696 (.B1 ( spi_rd_cmdaddr[17] ) , .B2 ( n1221 ) , .C ( n1280 ) 
    , .A2 ( n1220 ) , .A1 ( sio_data_reg[16] ) , .Z ( sio_data_reg_int451_17 ) ) ;
AO221D0HVT U701 (.B1 ( usercode_reg[30] ) , .B2 ( n1248 ) , .C ( n1306 ) 
    , .A2 ( n1247 ) , .A1 ( crc_reg[14] ) , .Z ( sio_data_reg_int451_30 ) ) ;
AO221D0HVT U702 (.B1 ( usercode_reg[28] ) , .B2 ( n1248 ) , .C ( n1301 ) 
    , .A2 ( n1247 ) , .A1 ( crc_reg[12] ) , .Z ( sio_data_reg_int451_28 ) ) ;
AO221D0HVT U682 (.B1 ( usercode_reg[11] ) , .B2 ( n1283 ) , .C ( n1288 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[10] ) , .Z ( sio_data_reg_int451_11 ) ) ;
AO221D0HVT U683 (.B1 ( usercode_reg[0] ) , .B2 ( n1246 ) , .C ( n1298 ) 
    , .A2 ( n1204 ) , .A1 ( sdi ) , .Z ( sio_data_reg_int451_0 ) ) ;
AO221D0HVT U684 (.B1 ( usercode_reg[7] ) , .B2 ( n1283 ) , .C ( n1291 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[6] ) , .Z ( sio_data_reg_int451_7 ) ) ;
OR2D0HVT U729 (.A2 ( cmdhead_cnt_0_BAR ) , .A1 ( cmdhead_cnt_ld ) 
    , .Z ( n832_0 ) ) ;
OR2D0HVT U730 (.A2 ( cmdhead_cnt_ld ) , .A1 ( cmdhead_cnt833_2 ) 
    , .Z ( cmdhead_cnt831_2 ) ) ;
OR2D0HVT U731 (.A2 ( cmdhead_cnt_ld ) , .A1 ( cmdhead_cnt833_1 ) 
    , .Z ( cmdhead_cnt831_1 ) ) ;
AO221D0HVT U703 (.B1 ( usercode_reg[26] ) , .B2 ( n1248 ) , .C ( n1305 ) 
    , .A2 ( n1247 ) , .A1 ( crc_reg[10] ) , .Z ( sio_data_reg_int451_26 ) ) ;
AO221D0HVT U704 (.B1 ( usercode_reg[25] ) , .B2 ( n1248 ) , .C ( n1302 ) 
    , .A2 ( n1247 ) , .A1 ( crc_reg[9] ) , .Z ( sio_data_reg_int451_25 ) ) ;
AO221D0HVT U690 (.B1 ( usercode_reg[6] ) , .B2 ( n1246 ) , .C ( n1292 ) 
    , .A2 ( n1204 ) , .A1 ( sio_data_reg[5] ) , .Z ( sio_data_reg_int451_6 ) ) ;
AO221D0HVT U692 (.B1 ( spi_rd_cmdaddr[22] ) , .B2 ( n1221 ) , .C ( n1277 ) 
    , .A2 ( n1220 ) , .A1 ( sio_data_reg[21] ) , .Z ( sio_data_reg_int451_22 ) ) ;
AO221D0HVT U693 (.B1 ( spi_rd_cmdaddr[20] ) , .B2 ( n1221 ) , .C ( n1278 ) 
    , .A2 ( n1220 ) , .A1 ( sio_data_reg[19] ) , .Z ( sio_data_reg_int451_20 ) ) ;
OR2D0HVT U736 (.A2 ( n1266 ) , .A1 ( spicnt348_1 ) , .Z ( spicnt346_1 ) ) ;
OR2D0HVT U740 (.A2 ( n1304 ) , .A1 ( sr_datacnt687_2 ) , .Z ( sr_datacnt685_2 ) ) ;
OR2D0HVT U741 (.A2 ( n1304 ) , .A1 ( sr_datacnt687_1 ) , .Z ( sr_datacnt685_1 ) ) ;
OR2D0HVT U742 (.A2 ( n1304 ) , .A1 ( sr_datacnt687_0 ) , .Z ( sr_datacnt685_0 ) ) ;
OR2D0HVT U745 (.A2 ( state_3_ ) , .A1 ( state_1_ ) , .Z ( n1427 ) ) ;
OR2D0HVT U748 (.A2 ( n1407 ) , .A1 ( n1423 ) , .Z ( n1531 ) ) ;
OR2D0HVT U726 (.A2 ( n1260 ) , .A1 ( n1548 ) , .Z ( n1259 ) ) ;
OR2D0HVT U728 (.A2 ( n1272 ) , .A1 ( n1234 ) , .Z ( n_1545 ) ) ;
DFCNQD1HVT spi_tx_done_reg (.D ( n1227 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet185 ) , .Q ( spi_tx_done ) 
    , .CDN ( rst_bASThfnNet5 ) ) ;
OR2D0HVT U750 (.A2 ( n1540 ) , .A1 ( n1539 ) , .Z ( n1546 ) ) ;
OR2D0HVT U753 (.A2 ( n1552 ) , .A1 ( smc_crc_ld ) , .Z ( n1556 ) ) ;
OR2D0HVT U754 (.A2 ( n1270 ) , .A1 ( n1271 ) , .Z ( n1557 ) ) ;
OR2D0HVT U772 (.A2 ( smc_usercode_ld ) , .A1 ( n1234 ) , .Z ( n1269 ) ) ;
OR2D0HVT U773 (.A2 ( spi_rxpreamble_fail ) , .A1 ( bitstream_err ) 
    , .Z ( n1411 ) ) ;
OR2D0HVT U732 (.A2 ( cmdhead_cnt_ld ) , .A1 ( cmdhead_cnt833_0 ) 
    , .Z ( cmdhead_cnt831_0 ) ) ;
OR2D0HVT U735 (.A2 ( n1266 ) , .A1 ( spicnt348_2 ) , .Z ( spicnt346_2 ) ) ;
OR4D0HVT U727 (.Z ( n1263 ) , .A2 ( n1561 ) , .A4 ( n1240 ) , .A3 ( n1184 ) 
    , .A1 ( n1308 ) ) ;
OR4D0HVT U746 (.Z ( n1267 ) , .A2 ( sr_datacnt_2_ ) , .A4 ( n1529 ) 
    , .A3 ( sr_datacnt_0_ ) , .A1 ( sr_datacnt_5_ ) ) ;
OR4D0HVT U752 (.Z ( n1304 ) , .A2 ( n1232 ) , .A4 ( n1233 ) , .A3 ( n1303 ) 
    , .A1 ( n1310 ) ) ;
DFSND1HVT spi_ss_out_b_int_reg (.D ( n1264 ) 
    , .CP ( spi_clk_out_GB_G4B2I2ASTHIRNet143 ) , .QN ( n1196 ) 
    , .Q ( spi_ss_out_b_int ) , .SDN ( rst_bASThfnNet5 ) ) ;
DFCND1HVT state_reg_3_ (.Q ( state_3_ ) , .CDN ( rst_bASThfnNet5 ) 
    , .QN ( n1405 ) , .D ( n1238 ) , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet185 ) ) ;
DFCNQD1HVT state_reg_2_ (.D ( n1237 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet185 ) , .Q ( state_2_ ) 
    , .CDN ( rst_bASThfnNet5 ) ) ;
DFCNQD1HVT state_reg_1_ (.D ( n1236 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet185 ) , .Q ( state_1_ ) 
    , .CDN ( rst_bASThfnNet5 ) ) ;
DFCNQD1HVT state_reg_0_ (.D ( n1235 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet185 ) , .Q ( state_0_ ) 
    , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT spicnt_reg_0_ (.E ( n347_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet152 ) , .D ( spicnt346_0 ) 
    , .QN ( n1170 ) , .Q ( spicnt_0_ ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sr_datacnt_reg_5_ (.E ( n686_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet185 ) , .D ( sr_datacnt685_5 ) 
    , .Q ( sr_datacnt_5_ ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT spicnt_reg_7_ (.E ( n347_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet152 ) , .D ( spicnt346_7 ) 
    , .QN ( n1168 ) , .Q ( spicnt_7_ ) , .CDN ( rst_bASThfnNet6 ) ) ;
AO21D0HVT U733 (.B ( n1229 ) , .A1 ( n1200 ) , .Z ( spicnt346_7 ) 
    , .A2 ( spicnt348_7 ) ) ;
AO21D0HVT U734 (.B ( n1229 ) , .A1 ( spicnt348_4 ) , .Z ( spicnt346_4 ) 
    , .A2 ( n1200 ) ) ;
AO21D0HVT U737 (.B ( n1228 ) , .A1 ( spicnt348_0 ) , .Z ( spicnt346_0 ) 
    , .A2 ( n1200 ) ) ;
AO21D0HVT U759 (.B ( n1190 ) , .A1 ( n1548 ) , .Z ( n1563 ) , .A2 ( n1564 ) ) ;
OR4D0HVT U755 (.Z ( cmdhead_cnt_0_BAR ) , .A2 ( cmdhead_cnt_1_ ) 
    , .A4 ( n1560 ) , .A3 ( cmdhead_cnt_4_ ) , .A1 ( cmdhead_cnt_0_ ) ) ;
EDFCND1HVT cmdhead_reg_reg_6_ (.E ( n_1943 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet221 ) , .D ( cmdhead_reg[5] ) 
    , .Q ( cmdhead_reg[6] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT cmdhead_reg_reg_5_ (.E ( n_1943 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet221 ) , .D ( cmdhead_reg[4] ) 
    , .Q ( cmdhead_reg[5] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT spicnt_reg_6_ (.E ( n347_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet152 ) , .D ( spicnt346_6 ) 
    , .QN ( n1167 ) , .Q ( spicnt_6_ ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT spicnt_reg_5_ (.E ( n347_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet152 ) , .D ( spicnt346_5 ) 
    , .QN ( n1171 ) , .Q ( spicnt_5_ ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT spicnt_reg_4_ (.E ( n347_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet152 ) , .D ( spicnt346_4 ) 
    , .QN ( n1174 ) , .Q ( spicnt_4_ ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT spicnt_reg_3_ (.E ( n347_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet152 ) , .D ( spicnt346_3 ) 
    , .QN ( n1172 ) , .Q ( spicnt_3_ ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT spicnt_reg_2_ (.E ( n347_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet152 ) , .D ( spicnt346_2 ) 
    , .QN ( n1173 ) , .Q ( spicnt_2_ ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT spicnt_reg_1_ (.E ( n347_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet152 ) , .D ( spicnt346_1 ) 
    , .QN ( n1169 ) , .Q ( spicnt_1_ ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT cmdhead_cnt_reg_3_ (.E ( n832_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet231 ) , .D ( cmdhead_cnt831_3 ) 
    , .QN ( n1192 ) , .Q ( cmdhead_cnt_3_ ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT cmdhead_cnt_reg_2_ (.E ( n832_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet231 ) , .D ( cmdhead_cnt831_2 ) 
    , .QN ( n1193 ) , .Q ( cmdhead_cnt_2_ ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sr_datacnt_reg_4_ (.E ( n686_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet185 ) , .D ( sr_datacnt685_4 ) 
    , .QN ( n1178 ) , .Q ( sr_datacnt_4_ ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sr_datacnt_reg_3_ (.E ( n686_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet185 ) , .D ( sr_datacnt685_3 ) 
    , .QN ( n1176 ) , .Q ( sr_datacnt_3_ ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sr_datacnt_reg_2_ (.E ( n686_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I4ASTHIRNet241 ) , .D ( sr_datacnt685_2 ) 
    , .Q ( sr_datacnt_2_ ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sr_datacnt_reg_1_ (.E ( n686_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet185 ) , .D ( sr_datacnt685_1 ) 
    , .QN ( n1177 ) , .Q ( sr_datacnt_1_ ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sr_datacnt_reg_0_ (.E ( n686_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I4ASTHIRNet241 ) , .D ( sr_datacnt685_0 ) 
    , .Q ( sr_datacnt_0_ ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT cmdhead_reg_reg_7_ (.E ( n_1943 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet221 ) , .D ( cmdhead_reg[6] ) 
    , .Q ( cmdhead_reg[7] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_18_ (.E ( n_1545 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet303 ) , .D ( sio_data_reg_int451_18 ) 
    , .QN ( n1216 ) , .Q ( sio_data_reg[18] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_4_ (.E ( n1250 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet263 ) , .D ( sio_data_reg_int451_4 ) 
    , .Q ( sio_data_reg[4] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT cmdhead_reg_reg_4_ (.E ( n_1943 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet168 ) , .D ( cmdhead_reg[3] ) 
    , .Q ( cmdhead_reg[4] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT cmdhead_reg_reg_3_ (.E ( n_1943 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet168 ) , .D ( cmdhead_reg[2] ) 
    , .QN ( n1179 ) , .Q ( cmdhead_reg[3] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT cmdhead_reg_reg_2_ (.E ( n_1943 ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet60 ) , .D ( cmdhead_reg[1] ) 
    , .QN ( n1541 ) , .Q ( cmdhead_reg[2] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT cmdhead_reg_reg_1_ (.E ( n_1943 ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet60 ) , .D ( cmdhead_reg[0] ) 
    , .QN ( n1311 ) , .Q ( cmdhead_reg[1] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT cmdhead_reg_reg_0_ (.E ( n_1943 ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet60 ) , .D ( sdi ) , .QN ( n1540 ) 
    , .Q ( cmdhead_reg[0] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT cmdhead_cnt_reg_4_ (.E ( n832_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet231 ) , .D ( cmdhead_cnt831_4 ) 
    , .Q ( cmdhead_cnt_4_ ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_6_ (.E ( n1251 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet185 ) , .D ( sio_data_reg_int451_6 ) 
    , .Q ( sio_data_reg[6] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_17_ (.E ( n_1545 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet290 ) , .D ( sio_data_reg_int451_17 ) 
    , .Q ( sio_data_reg[17] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT cmdhead_cnt_reg_1_ (.E ( n832_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet231 ) , .D ( cmdhead_cnt831_1 ) 
    , .Q ( cmdhead_cnt_1_ ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT cmdhead_cnt_reg_0_ (.E ( n832_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet231 ) , .D ( cmdhead_cnt831_0 ) 
    , .Q ( cmdhead_cnt_0_ ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_0_ (.E ( n1251 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet185 ) , .D ( sio_data_reg_int451_0 ) 
    , .Q ( cmdcode_byte_0ASTHNet34 ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_15_ (.E ( n1251 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet263 ) , .D ( sio_data_reg_int451_15 ) 
    , .Q ( sio_data_reg[15] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_9_ (.E ( n1251 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet263 ) , .D ( sio_data_reg_int451_9 ) 
    , .Q ( sio_data_reg[9] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_26_ (.E ( n_1529 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet290 ) , .D ( sio_data_reg_int451_26 ) 
    , .Q ( sio_data_reg[26] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_12_ (.E ( n1250 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet263 ) , .D ( sio_data_reg_int451_12 ) 
    , .Q ( sio_data_reg[12] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_31_ (.E ( n_1529 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet122 ) , .D ( sio_data_reg_int451_31 ) 
    , .Q ( sio_data_reg[31] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_11_ (.E ( n1250 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet224 ) , .D ( sio_data_reg_int451_11 ) 
    , .Q ( sio_data_reg[11] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_22_ (.E ( n_1545 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet303 ) , .D ( sio_data_reg_int451_22 ) 
    , .QN ( n1219 ) , .Q ( sio_data_reg[22] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_13_ (.E ( n1251 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet263 ) , .D ( sio_data_reg_int451_13 ) 
    , .Q ( sio_data_reg[13] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_20_ (.E ( n_1545 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet116 ) , .D ( sio_data_reg_int451_20 ) 
    , .QN ( n1211 ) , .Q ( sio_data_reg[20] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_30_ (.E ( n_1529 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet290 ) , .D ( sio_data_reg_int451_30 ) 
    , .Q ( sio_data_reg[30] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_29_ (.E ( n_1529 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet122 ) , .D ( sio_data_reg_int451_29 ) 
    , .Q ( sio_data_reg[29] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_1_ (.E ( n1250 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet116 ) , .D ( sio_data_reg_int451_1 ) 
    , .Q ( sio_data_reg[1] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_8_ (.E ( n1250 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet116 ) , .D ( sio_data_reg_int451_8 ) 
    , .QN ( n1245 ) , .Q ( sio_data_reg[8] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_24_ (.E ( n_1529 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet86 ) , .D ( sio_data_reg_int451_24 ) 
    , .QN ( n1180 ) , .Q ( sio_data_reg[24] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_2_ (.E ( n1251 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet116 ) , .D ( sio_data_reg_int451_2 ) 
    , .Q ( sio_data_reg[2] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_16_ (.E ( n_1545 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet290 ) , .D ( sio_data_reg_int451_16 ) 
    , .Q ( sio_data_reg[16] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_25_ (.E ( n_1529 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet290 ) , .D ( sio_data_reg_int451_25 ) 
    , .Q ( sio_data_reg[25] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_3_ (.E ( n1250 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet116 ) , .D ( sio_data_reg_int451_3 ) 
    , .Q ( sio_data_reg[3] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_21_ (.E ( n_1545 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet263 ) , .D ( sio_data_reg_int451_21 ) 
    , .Q ( sio_data_reg[21] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_27_ (.E ( n_1529 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet86 ) , .D ( sio_data_reg_int451_27 ) 
    , .QN ( n1181 ) , .Q ( sio_data_reg[27] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_14_ (.E ( n1251 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet116 ) , .D ( sio_data_reg_int451_14 ) 
    , .Q ( sio_data_reg[14] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_28_ (.E ( n_1529 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet290 ) , .D ( sio_data_reg_int451_28 ) 
    , .Q ( sio_data_reg[28] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_7_ (.E ( n1250 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet224 ) , .D ( sio_data_reg_int451_7 ) 
    , .Q ( sio_data_reg[7] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_19_ (.E ( n_1545 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet263 ) , .D ( sio_data_reg_int451_19 ) 
    , .Q ( sio_data_reg[19] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_5_ (.E ( n1251 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet263 ) , .D ( sio_data_reg_int451_5 ) 
    , .Q ( sio_data_reg[5] ) , .CDN ( rst_bASThfnNet5 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_10_ (.E ( n1250 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet116 ) , .D ( sio_data_reg_int451_10 ) 
    , .Q ( sio_data_reg[10] ) , .CDN ( rst_bASThfnNet6 ) ) ;
EDFCND1HVT sio_data_reg_int_reg_23_ (.E ( n_1545 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet86 ) , .D ( sio_data_reg_int451_23 ) 
    , .Q ( sio_data_reg[23] ) , .CDN ( rst_bASThfnNet6 ) ) ;
AO211D0HVT U758 (.Z ( n1549 ) , .A2 ( state_1_ ) , .C ( n1543 ) , .A1 ( n1183 ) 
    , .B ( n1309 ) ) ;
AO211D0HVT U738 (.Z ( sr_datacnt685_4 ) , .A2 ( n1201 ) , .C ( n1303 ) 
    , .A1 ( sr_datacnt687_4 ) , .B ( n1233 ) ) ;
AO211D0HVT U739 (.Z ( sr_datacnt685_3 ) , .A2 ( n1201 ) , .C ( n1303 ) 
    , .A1 ( sr_datacnt687_3 ) , .B ( n1232 ) ) ;
OA21D0HVT U743 (.B ( n1265 ) , .A1 ( n1190 ) , .Z ( n1308 ) , .A2 ( n1189 ) ) ;
OA21D0HVT U744 (.B ( n1407 ) , .A1 ( state_1_ ) , .Z ( n1403 ) , .A2 ( n1405 ) ) ;
OR3D0HVT U747 (.A1 ( j_cfg_enable ) , .A2 ( j_cfg_disable ) , .Z ( n1530 ) 
    , .A3 ( md_jtag_rst ) ) ;
OR3D0HVT U749 (.A1 ( n1230 ) , .A2 ( n1310 ) , .Z ( n1545 ) , .A3 ( n1272 ) ) ;
OR3D0HVT U756 (.A1 ( n1240 ) , .A2 ( n1190 ) , .Z ( n1562 ) , .A3 ( n1544 ) ) ;
MOAI22D0HVT U539 (.A2 ( n1533 ) , .B1 ( n1240 ) , .A1 ( n1199 ) 
    , .B2 ( cor_dis_flashpd ) , .ZN ( n1550 ) ) ;
INR2XD1HVT U537 (.ZN ( n_1943 ) , .A1 ( bs_smc_cmdhead_en ) , .B1 ( n1417 ) ) ;
AOI211D0HVT U538 (.ZN ( n1240 ) , .A2 ( n1413 ) , .C ( n1427 ) , .A1 ( n1425 ) 
    , .B ( n1532 ) ) ;
OAI33D0HVT U540 (.A3 ( n1415 ) , .B3 ( n1224 ) , .B2 ( n1198 ) , .B1 ( n1268 ) 
    , .A2 ( n1413 ) , .A1 ( n1403 ) , .ZN ( n1227 ) ) ;
AO31D0HVT U760 (.B ( n1566 ) , .A1 ( sio_data_reg[29] ) , .Z ( n1306 ) 
    , .A3 ( n1220 ) , .A2 ( n1565 ) ) ;
AO31D0HVT U762 (.B ( n1568 ) , .A1 ( sio_data_reg[25] ) , .Z ( n1305 ) 
    , .A3 ( n1220 ) , .A2 ( n1565 ) ) ;
AO31D0HVT U751 (.B ( n1542 ) , .A1 ( n1231 ) , .Z ( n1303 ) , .A3 ( n1242 ) 
    , .A2 ( n1547 ) ) ;
AO211D0HVT U757 (.Z ( n1551 ) , .A2 ( n1186 ) , .C ( n1562 ) , .A1 ( n1241 ) 
    , .B ( n1538 ) ) ;
AO222D0HVT U763 (.A2 ( n1221 ) , .C1 ( n1569 ) , .C2 ( n1220 ) , .Z ( n1302 ) 
    , .B2 ( n1191 ) , .B1 ( status_int[25] ) , .A1 ( spi_rd_cmdaddr[25] ) ) ;
AO222D0HVT U764 (.A2 ( n1299 ) , .C1 ( usercode_reg[22] ) , .C2 ( n1300 ) 
    , .Z ( n1277 ) , .B2 ( n1191 ) , .B1 ( status_int[22] ) , .A1 ( crc_reg[6] ) ) ;
AO222D0HVT U765 (.A2 ( n1299 ) , .C1 ( usercode_reg[20] ) , .C2 ( n1300 ) 
    , .Z ( n1278 ) , .B2 ( n1191 ) , .B1 ( status_int[20] ) , .A1 ( crc_reg[4] ) ) ;
AO222D0HVT U767 (.A2 ( n1299 ) , .C1 ( usercode_reg[18] ) , .C2 ( n1300 ) 
    , .Z ( n1279 ) , .B2 ( n1191 ) , .B1 ( status_int[18] ) , .A1 ( crc_reg[2] ) ) ;
AO222D0HVT U768 (.A2 ( n1299 ) , .C1 ( usercode_reg[17] ) , .C2 ( n1300 ) 
    , .Z ( n1280 ) , .B2 ( n1191 ) , .B1 ( cdone_in ) , .A1 ( crc_reg[1] ) ) ;
MOAI22D0HVT U766 (.ZN ( n1297 ) , .B2 ( n1221 ) , .A1 ( n1421 ) , .A2 ( n1554 ) 
    , .B1 ( spi_rd_cmdaddr[1] ) ) ;
MOAI22D0HVT U770 (.ZN ( n1286 ) , .B2 ( n1221 ) , .A1 ( n1537 ) , .A2 ( n1554 ) 
    , .B1 ( spi_rd_cmdaddr[13] ) ) ;
MOAI22D0HVT U771 (.ZN ( n1298 ) , .B2 ( n1221 ) , .A1 ( n1554 ) , .A2 ( n1558 ) 
    , .B1 ( spi_rd_cmdaddr[0] ) ) ;
ND2D0HVT U569 (.ZN ( n1407 ) , .A1 ( n1405 ) , .A2 ( state_1_ ) ) ;
ND2D0HVT U570 (.ZN ( n1570 ) , .A1 ( n1189 ) , .A2 ( n1199 ) ) ;
ND2D0HVT U573 (.ZN ( n1571 ) , .A1 ( n1199 ) , .A2 ( n1190 ) ) ;
ND2D0HVT U577 (.ZN ( n1271 ) , .A1 ( n1555 ) , .A2 ( n1553 ) ) ;
ND2D0HVT U578 (.ZN ( n1560 ) , .A1 ( n1193 ) , .A2 ( n1192 ) ) ;
ND2D0HVT U625 (.ZN ( n1273 ) , .A1 ( n1571 ) , .A2 ( n1570 ) ) ;
AO222D0HVT U769 (.A2 ( n1299 ) , .C1 ( usercode_reg[16] ) , .C2 ( n1300 ) 
    , .Z ( n1281 ) , .B2 ( n1191 ) , .B1 ( status_int[16] ) , .A1 ( crc_reg[0] ) ) ;
AO222D0HVT U761 (.A2 ( n1221 ) , .C1 ( n1220 ) , .C2 ( n1567 ) , .Z ( n1301 ) 
    , .B2 ( n1191 ) , .B1 ( status_int[28] ) , .A1 ( spi_rd_cmdaddr[28] ) ) ;
AO22D0HVT U712 (.B1 ( status_int[7] ) , .B2 ( n1191 ) , .Z ( n1291 ) 
    , .A1 ( spi_rd_cmdaddr[7] ) , .A2 ( n1221 ) ) ;
AO22D0HVT U713 (.B1 ( status_int[2] ) , .B2 ( n1191 ) , .Z ( n1296 ) 
    , .A1 ( spi_rd_cmdaddr[2] ) , .A2 ( n1221 ) ) ;
AO22D0HVT U714 (.B1 ( status_int[5] ) , .B2 ( n1191 ) , .Z ( n1293 ) 
    , .A1 ( spi_rd_cmdaddr[5] ) , .A2 ( n1221 ) ) ;
AO22D0HVT U715 (.B1 ( status_int[12] ) , .B2 ( n1191 ) , .Z ( n1287 ) 
    , .A1 ( spi_rd_cmdaddr[12] ) , .A2 ( n1221 ) ) ;
ND3D1HVT U543 (.A2 ( n1565 ) , .ZN ( n_1529 ) , .A3 ( n1559 ) , .A1 ( n1220 ) ) ;
ND2D1HVT U632 (.ZN ( n1419 ) , .A1 ( j_cfg_program ) , .A2 ( j_sft_dr ) ) ;
ND2D1HVT U585 (.ZN ( n347_0 ) , .A1 ( n1199 ) , .A2 ( n1200 ) ) ;
ND2D0HVT U541 (.ZN ( n686_0 ) , .A1 ( sr_datacnt_0 ) , .A2 ( n1201 ) ) ;
AO22D0HVT U718 (.B1 ( status_int[26] ) , .B2 ( n1191 ) , .Z ( n1568 ) 
    , .A1 ( spi_rd_cmdaddr[26] ) , .A2 ( n1221 ) ) ;
AO22D0HVT U719 (.B1 ( status_int[30] ) , .B2 ( n1191 ) , .Z ( n1566 ) 
    , .A1 ( spi_rd_cmdaddr[30] ) , .A2 ( n1221 ) ) ;
AO22D0HVT U723 (.B1 ( status_int[14] ) , .B2 ( n1191 ) , .Z ( n1285 ) 
    , .A1 ( spi_rd_cmdaddr[14] ) , .A2 ( n1221 ) ) ;
AO22D0HVT U724 (.B1 ( status_int[15] ) , .B2 ( n1191 ) , .Z ( n1284 ) 
    , .A1 ( spi_rd_cmdaddr[15] ) , .A2 ( n1221 ) ) ;
AO22D0HVT U725 (.B1 ( status_int[10] ) , .B2 ( n1191 ) , .Z ( n1289 ) 
    , .A1 ( spi_rd_cmdaddr[10] ) , .A2 ( n1221 ) ) ;
AO22D0HVT U542 (.B1 ( spi_rd_cmdaddr[6] ) , .B2 ( n1221 ) , .Z ( n1292 ) 
    , .A1 ( n1191 ) , .A2 ( spi_rxpreamble_fail ) ) ;
AO22D0HVT U710 (.B1 ( status_int[4] ) , .B2 ( n1191 ) , .Z ( n1294 ) 
    , .A1 ( spi_rd_cmdaddr[4] ) , .A2 ( n1221 ) ) ;
AO22D0HVT U711 (.B1 ( status_int[8] ) , .B2 ( n1191 ) , .Z ( n1290 ) 
    , .A1 ( spi_rd_cmdaddr[8] ) , .A2 ( n1221 ) ) ;
NR2XD0HVT U586 (.A1 ( n1534 ) , .A2 ( n1535 ) , .ZN ( n1199 ) ) ;
NR2XD0HVT U615 (.A1 ( smc_crc_ld ) , .A2 ( n1542 ) , .ZN ( n1220 ) ) ;
ND4D0HVT U544 (.A2 ( n1169 ) , .A3 ( n1168 ) , .A4 ( n1167 ) , .ZN ( n1535 ) 
    , .A1 ( n1170 ) ) ;
ND4D0HVT U545 (.A2 ( n1173 ) , .A3 ( n1172 ) , .A4 ( n1171 ) , .ZN ( n1534 ) 
    , .A1 ( n1174 ) ) ;
AN4D0HVT U546 (.A1 ( cmd_sr_datacnt_ld ) , .Z ( n1231 ) , .A3 ( n1179 ) 
    , .A2 ( cmdhead_reg[2] ) , .A4 ( n1175 ) ) ;
AN4D0HVT U590 (.A1 ( n1533 ) , .Z ( n1228 ) , .A3 ( n1548 ) , .A2 ( n1531 ) 
    , .A4 ( n1258 ) ) ;
AO22D0HVT U716 (.B1 ( status_int[11] ) , .B2 ( n1191 ) , .Z ( n1288 ) 
    , .A1 ( spi_rd_cmdaddr[11] ) , .A2 ( n1221 ) ) ;
AO22D0HVT U717 (.B1 ( status_int[3] ) , .B2 ( n1191 ) , .Z ( n1295 ) 
    , .A1 ( spi_rd_cmdaddr[3] ) , .A2 ( n1221 ) ) ;
endmodule




module bstream_smc (spi_clk_out_GB_G4B1I1ASTHIRNet119 , 
    clk_b_G5B1I2ASTHIRNet108 , spi_clk_out_GB_G4B2I22ASTHIRNet73 , 
    spi_clk_out_GB_G4B2I19ASTHIRNet53 , spi_clk_out_GB_G4B2I1ASTHIRNet227 , 
    spi_clk_out_GB_G4B2I24ASTHIRNet213 , clk_b_G5B1I1ASTHIRNet204 , 
    spi_clk_out_GB_G4B2I21ASTHIRNet180 , spi_clk_out_GB_G4B2I5ASTHIRNet170 , 
    spi_clk_out_GB_G4B2I18ASTHIRNet154 , spi_clk_out_GB_G4B2I2ASTHIRNet139 , 
    spi_clk_out_GB_G4B2I15ASTHIRNet124 , smc_oscoff_b , gint_hz , gio_hz , 
    cfg_shutdown , clk_b_G5B1I3ASTHIRNet299 , 
    spi_clk_out_GB_G4B2I20ASTHIRNet260 , spi_clk_out_GB_G4B2I4ASTHIRNet243 , 
    spi_clk_out_GB_G4B2I17ASTHIRNet234 , j_idcode_reg , j_cfg_enable , 
    j_cfg_disable , j_cfg_program , j_sft_dr , cnt_podt_out , 
    smc_osc_fsel , coldboot_sel , framelen , gwe , cdone_in , framenum , 
    usercode_reg , cm_sdo_u3 , cdone_out , end_of_startup , cram_reading , 
    cram_done , bram_reading , bram_done , smc_podt_rst , smc_podt_off , 
    startup_req , shutdown_req , cor_security_rddis , cor_security_wrtdis , 
    spi_clk_out_GB_G4B2I3ASTHIRNet45 , spi_clk_out_GB_G4B2I16ASTHIRNet40 , 
    reboot_source_nvcm , cor_en_8bconfig , en_8bconfig_b , 
    en_daisychain_cfg , tm_dis_cram_clk_gating , cram_wrt , 
    spi_ss_out_b_int , access_nvcm_reg , bm_bank_sdo , cram_rd , 
    tm_dis_bram_clk_gating , bram_wrt , bram_rd , cor_en_oscclk , 
    warmboot_req , sdo , cm_monitor_cell , baddr , cm_sdo_u2 , 
    start_framenum , warmboot_sel , cm_sdo_u1 , cm_sdo_u0 , clk_b , 
    rst_b , md_spi , sdi , boot , cfg_ld_bstream , cfg_startup , 
    spi_master_go , fpga_operation , nvcm_relextspi , 
    smc_load_nvcm_bstream , bp0 , md_jtag , j_rst_b , clk );
input  spi_clk_out_GB_G4B1I1ASTHIRNet119 ;
input  clk_b_G5B1I2ASTHIRNet108 ;
input  spi_clk_out_GB_G4B2I22ASTHIRNet73 ;
input  spi_clk_out_GB_G4B2I19ASTHIRNet53 ;
input  spi_clk_out_GB_G4B2I1ASTHIRNet227 ;
input  spi_clk_out_GB_G4B2I24ASTHIRNet213 ;
input  clk_b_G5B1I1ASTHIRNet204 ;
input  spi_clk_out_GB_G4B2I21ASTHIRNet180 ;
input  spi_clk_out_GB_G4B2I5ASTHIRNet170 ;
input  spi_clk_out_GB_G4B2I18ASTHIRNet154 ;
input  spi_clk_out_GB_G4B2I2ASTHIRNet139 ;
input  spi_clk_out_GB_G4B2I15ASTHIRNet124 ;
input  smc_oscoff_b ;
input  gint_hz ;
input  gio_hz ;
input  cfg_shutdown ;
input  clk_b_G5B1I3ASTHIRNet299 ;
input  spi_clk_out_GB_G4B2I20ASTHIRNet260 ;
input  spi_clk_out_GB_G4B2I4ASTHIRNet243 ;
input  spi_clk_out_GB_G4B2I17ASTHIRNet234 ;
input  [31:0] j_idcode_reg ;
input  j_cfg_enable ;
input  j_cfg_disable ;
input  j_cfg_program ;
input  j_sft_dr ;
input  cnt_podt_out ;
output [1:0] smc_osc_fsel ;
input  [1:0] coldboot_sel ;
output [15:0] framelen ;
input  gwe ;
input  cdone_in ;
output [8:0] framenum ;
output [31:0] usercode_reg ;
input  [1:0] cm_sdo_u3 ;
input  cdone_out ;
input  end_of_startup ;
input  cram_reading ;
input  cram_done ;
input  bram_reading ;
input  bram_done ;
output smc_podt_rst ;
output smc_podt_off ;
output startup_req ;
output shutdown_req ;
output cor_security_rddis ;
output cor_security_wrtdis ;
input  spi_clk_out_GB_G4B2I3ASTHIRNet45 ;
input  spi_clk_out_GB_G4B2I16ASTHIRNet40 ;
output reboot_source_nvcm ;
output cor_en_8bconfig ;
output en_8bconfig_b ;
output en_daisychain_cfg ;
output tm_dis_cram_clk_gating ;
output cram_wrt ;
output spi_ss_out_b_int ;
output access_nvcm_reg ;
input  [3:0] bm_bank_sdo ;
output cram_rd ;
output tm_dis_bram_clk_gating ;
output bram_wrt ;
output bram_rd ;
output cor_en_oscclk ;
output warmboot_req ;
output [7:0] sdo ;
input  [3:0] cm_monitor_cell ;
output [1:0] baddr ;
input  [1:0] cm_sdo_u2 ;
output [8:0] start_framenum ;
input  [1:0] warmboot_sel ;
input  [1:0] cm_sdo_u1 ;
input  [1:0] cm_sdo_u0 ;
input  clk_b ;
input  rst_b ;
input  md_spi ;
input  sdi ;
input  boot ;
input  cfg_ld_bstream ;
input  cfg_startup ;
input  spi_master_go ;
input  fpga_operation ;
input  nvcm_relextspi ;
input  smc_load_nvcm_bstream ;
input  bp0 ;
input  md_jtag ;
input  j_rst_b ;
input  clk ;

/* wire declarations */
wire crc_reg_7_ ;
wire crc_reg_6_ ;
wire crc_reg_5_ ;
wire crc_reg_4_ ;
wire crc_reg_3_ ;
wire crc_reg_2_ ;
wire crc_reg_1_ ;
wire crc_reg_0_ ;
wire crc_reg_15_ ;
wire crc_reg_14_ ;
wire crc_reg_13_ ;
wire crc_reg_12_ ;
wire crc_reg_11_ ;
wire crc_reg_10_ ;
wire crc_reg_9_ ;
wire crc_reg_8_ ;
wire rst_bASThfnNet15 ;
wire crc16_en ;
wire n3052 ;
wire crc_data_in ;
wire spi_clk_out_GB_G4B2I10ASTHIRNet288 ;
wire spi_clk_out_GB_G4B2I14ASTHIRNet222 ;
wire spi_clk_out_GB_G4B2I11ASTHIRNet219 ;
wire spi_clk_out_GB_G4B2I8ASTHIRNet183 ;
wire cor_dis_flashpd ;
wire n3222 ;
wire n3223 ;
wire spi_clk_out_GB_G4B2I13ASTHIRNet301 ;
wire spi_clk_out_GB_G4B2I7ASTHIRNet261 ;
wire sio_data_reg_3 ;
wire sio_data_reg_2 ;
wire sio_data_reg_1 ;
wire cmdcode_byte_0 ;
wire sio_data_reg_11 ;
wire sio_data_reg_10 ;
wire sio_data_reg_9 ;
wire sio_data_reg_8 ;
wire sio_data_reg_7 ;
wire sio_data_reg_6 ;
wire sio_data_reg_5 ;
wire sio_data_reg_4 ;
wire sio_data_reg_19 ;
wire sio_data_reg_18 ;
wire sio_data_reg_17 ;
wire sio_data_reg_16 ;
wire sio_data_reg_15 ;
wire sio_data_reg_14 ;
wire sio_data_reg_13 ;
wire sio_data_reg_12 ;
wire sio_data_reg_27 ;
wire sio_data_reg_26 ;
wire sio_data_reg_25 ;
wire sio_data_reg_24 ;
wire sio_data_reg_23 ;
wire sio_data_reg_22 ;
wire sio_data_reg_21 ;
wire sio_data_reg_20 ;
wire sio_data_reg_31 ;
wire sio_data_reg_30 ;
wire sio_data_reg_29 ;
wire sio_data_reg_28 ;
wire spi_clk_out_GB_G4B2I9ASTHIRNet84 ;
wire spi_clk_out_GB_G4B2I6ASTHIRNet58 ;
wire spi_rxpreamble_fail ;
wire bitstream_err ;
wire cmdhead_cnt_ld ;
wire n3029 ;
wire n3030 ;
wire n3031 ;
wire n3032 ;
wire spi_clk_out_GB_G4B2I12ASTHIRNet114 ;
wire n2911 ;
wire n3006 ;
wire n3173 ;
wire cmdreg_code_1_ ;
wire cmdreg_code_0_ ;
wire cmdhead_reg_3 ;
wire cmdhead_reg_2 ;
wire cmdhead_reg_1 ;
wire cmdhead_reg_0 ;
wire n3017 ;
wire bs_smc_sdio_en ;
wire spi_rd_cmdaddr_1 ;
wire spi_rd_cmdaddr_0 ;
wire sr_datacnt_0 ;
wire cmdhead_cnt_0 ;
wire spi_tx_done ;
wire cmdreg_code_3_ ;
wire cmdreg_code_2_ ;
wire spi_rd_cmdaddr_9 ;
wire spi_rd_cmdaddr_8 ;
wire spi_rd_cmdaddr_7 ;
wire spi_rd_cmdaddr_6 ;
wire spi_rd_cmdaddr_5 ;
wire spi_rd_cmdaddr_4 ;
wire spi_rd_cmdaddr_3 ;
wire spi_rd_cmdaddr_2 ;
wire spi_rd_cmdaddr_17 ;
wire spi_rd_cmdaddr_16 ;
wire spi_rd_cmdaddr_15 ;
wire spi_rd_cmdaddr_14 ;
wire spi_rd_cmdaddr_13 ;
wire spi_rd_cmdaddr_12 ;
wire spi_rd_cmdaddr_11 ;
wire spi_rd_cmdaddr_10 ;
wire spi_rd_cmdaddr_25 ;
wire spi_rd_cmdaddr_24 ;
wire val2431_24 ;
wire spi_rd_cmdaddr_22 ;
wire spi_rd_cmdaddr_21 ;
wire val2431_21 ;
wire spi_rd_cmdaddr_19 ;
wire spi_rd_cmdaddr_18 ;
wire spi_rd_cmdaddr_31 ;
wire spi_rd_cmdaddr_30 ;
wire spi_rd_cmdaddr_29 ;
wire spi_rd_cmdaddr_28 ;
wire spi_rd_cmdaddr_27 ;
wire spi_rd_cmdaddr_26 ;
wire n3043 ;
wire cmdreg_err ;
wire cmdcode_err ;
wire crc_err ;
wire idcode_err ;

wire n3070 ;
wire n2894 ;
wire n3004 ;
wire n3093 ;
wire n3092 ;
wire bm_smc_sdo_en_int ;
wire n3182 ;
wire n2991 ;
wire n3178 ;
wire n3046 ;
wire n3142 ;
wire n3108 ;
wire n3021 ;
wire n3140 ;
wire n3144 ;
wire n2993 ;
wire cor_en_coldboot ;
wire n2909 ;
wire n3180 ;
wire n2956 ;
wire n2896 ;
wire n2958 ;
wire n3154 ;
wire n2967 ;
wire n2965 ;
wire n2964 ;
wire n3062 ;
wire n3064 ;
wire n3066 ;
wire n3068 ;
wire n_3948 ;
wire n3002 ;
wire n3001 ;
wire n3164 ;
wire n3019 ;
wire n3103 ;
wire n2966 ;
wire n2968 ;
wire n3211 ;
wire n2955 ;
wire n2954 ;
wire n3110 ;
wire n3176 ;
wire n3217 ;
wire spi_rd_cmdaddr_reg_7 ;
wire n3215 ;
wire n3155 ;
wire n3174 ;
wire n3214 ;
wire n3132 ;
wire n3134 ;
wire bs_state_2_ ;
wire n3007 ;
wire bs_state_0_ ;
wire n3175 ;
wire spi_rxpreamble_trycnt_0_ ;
wire spi_rxpreamble_trycnt_2_ ;
wire spi_rxpreamble_trycnt_1_ ;
wire warmboot_sel_int_0_ ;
wire warmboot_sel_int_1_ ;
wire n3158 ;
wire bs_state_1_ ;
wire n2953 ;
wire n2959 ;
wire n3099 ;
wire n2963 ;
wire n2962 ;
wire n3190 ;
wire n3226 ;
wire n3005 ;
wire n3126 ;
wire n2895 ;
wire n2957 ;
wire n3129 ;
wire n2951 ;
wire n2952 ;
wire n3137 ;
wire n3121 ;
wire cor_en_warmboot ;
wire warmboot_int ;
wire n_875 ;
wire bs_state_3_ ;
wire n2995 ;
wire n2969 ;
wire n3162 ;
wire n3115 ;
wire n2898 ;
wire n3149 ;
wire n3109 ;
wire n2899 ;
wire n3218 ;
wire n_5075 ;
wire n3219 ;
wire n_3685 ;
wire n2893 ;
wire n3193 ;
wire n2913 ;
wire n2912 ;
wire n3221 ;
wire n3220 ;
wire n3050 ;
wire n3159 ;
wire n2903 ;
wire n2905 ;
wire n2904 ;
wire n2906 ;
wire n3131 ;
wire n2907 ;
wire n2908 ;
wire n3118 ;
wire n2910 ;
wire n3177 ;
wire n3091 ;
wire n3130 ;
wire n2986 ;
wire n2987 ;
wire n2988 ;
wire n2989 ;
wire n3106 ;
wire n2990 ;
wire spi_rxpreamble_trycnt974_2 ;
wire spi_rxpreamble_trycnt974_0 ;
wire n3171 ;
wire n2915 ;
wire n2992 ;
wire n3185 ;
wire n3025 ;
wire n3141 ;
wire n2994 ;
wire n3117 ;
wire n2996 ;
wire n3095 ;
wire n2999 ;
wire n3045 ;
wire n3000 ;
wire n3107 ;
wire n3003 ;
wire n3038 ;
wire bm_smc_sdo_en ;
wire cm_smc_sdo_en ;
wire n3044 ;
wire n3008 ;
wire n3010 ;
wire n3015 ;
wire n3186 ;
wire n3196 ;
wire n3018 ;
wire n2897 ;
wire n3152 ;
wire n2914 ;
wire n3013 ;
wire n3138 ;
wire n3094 ;
wire n3026 ;
wire n3027 ;
wire n3028 ;
wire n3036 ;
wire n2961 ;
wire n3102 ;
wire n3016 ;
wire tm_en_cram_blsr_test ;
wire n3195 ;
wire bs_smc_sdo_en_reg ;
wire n3194 ;
wire n3009 ;
wire n3148 ;
wire cmdreg_err1327 ;
wire n2916 ;
wire n3153 ;
wire n2950 ;
wire n3024 ;
wire n3012 ;
wire n3058 ;
wire n3119 ;
wire n3172 ;
wire n3060 ;
wire n3114 ;
wire disable_flash_req ;
wire n3135 ;
wire sdo_rx_7_ ;
wire sdo_rx_5_ ;
wire n3101 ;
wire n3061 ;
wire n3116 ;
wire n3059 ;
wire n3123 ;
wire n3128 ;
wire n3145 ;
wire n3146 ;
wire n3105 ;
wire n3133 ;
wire n2998 ;
wire n3122 ;
wire n3213 ;
wire n3212 ;
wire n3150 ;
wire n3047 ;
wire n3227 ;
wire n3224 ;
wire n3187 ;
wire n3188 ;
wire n3166 ;
wire n3167 ;
wire n2960 ;
wire n3136 ;
wire n3034 ;
wire n3151 ;
wire idcode_err1526 ;
wire n3161 ;
wire n3163 ;
wire n3160 ;
wire n3208 ;
wire n3205 ;
wire n3206 ;
wire n3207 ;
wire n3040 ;
wire n3033 ;
wire n3037 ;
wire n3042 ;
wire n3157 ;
wire n2917 ;
wire n3216 ;
wire n3035 ;
wire n3183 ;
wire n3184 ;
wire rst_bASThfnNet16 ;
wire rst_bASThfnNet11 ;
wire n3041 ;
wire n3139 ;
wire n3022 ;
wire n3023 ;
wire n3165 ;
wire n3020 ;
wire n2948 ;
wire n2947 ;
wire n2946 ;
wire n3199 ;
wire n2949 ;
wire n2920 ;
wire n2919 ;
wire n2918 ;
wire n3202 ;
wire n2921 ;
wire rst_bASThfnNet12 ;
wire rst_bASThfnNet13 ;
wire rst_bASThfnNet14 ;
wire n2980 ;
wire n2979 ;
wire n2978 ;
wire n2981 ;
wire n2984 ;
wire n2983 ;
wire n2982 ;
wire n2985 ;
wire n2924 ;
wire n2923 ;
wire n2922 ;
wire n3201 ;
wire n2925 ;
wire n2928 ;
wire n2927 ;
wire n2926 ;
wire n3204 ;
wire n2929 ;
wire n2932 ;
wire n2931 ;
wire n2930 ;
wire n3203 ;
wire n2933 ;
wire n2936 ;
wire n2935 ;
wire n2934 ;
wire n3198 ;
wire n2937 ;
wire n2940 ;
wire n2939 ;
wire n2938 ;
wire n3197 ;
wire n2941 ;
wire n2944 ;
wire n2943 ;
wire n2942 ;
wire n3200 ;
wire n2945 ;
wire bram_wrt476 ;
wire cram_rd470 ;
wire n_2567 ;
wire cram_wrt464 ;
wire n975_0 ;
wire n2972 ;
wire n2971 ;
wire n2970 ;
wire n2973 ;
wire n2976 ;
wire n2975 ;
wire n2974 ;
wire n2977 ;
wire n_1346 ;
wire n_3949 ;
wire n_5241 ;
wire tm_cram_monitor_cell_mask_2_ ;
wire n3143 ;
wire tm_cram_monitor_cell_mask_1_ ;
wire n3100 ;
wire n3191 ;
wire n3192 ;
wire spi_rxpreamble_trycnt976_1 ;
wire add_735_carry_2 ;
wire n3156 ;
wire n_1324 ;
wire spi_ldbstream_trycnt_0_ ;
wire n3086 ;
wire n3168 ;
wire n3170 ;
wire n3089 ;
wire n3113 ;
wire spi_ldbstream_trycnt1059_1 ;
wire spi_ldbstream_trycnt_1_ ;
wire n3111 ;
wire n3112 ;
wire n3098 ;
wire sdo_rx_2_ ;
wire sdo_rx_1_ ;
wire sdo_rx_0_ ;
wire sdo_r_0 ;
wire n3087 ;
wire n3088 ;
wire bram_rd482 ;
wire sdi_d1 ;
wire sdo_rx_6_ ;
wire sdo_rx_4_ ;
wire sdo_rx_3_ ;
wire cm_smc_sdo_en_int_d1 ;
wire bm_smc_sdo_en_int_d2 ;
wire bm_smc_sdo_en_int_d3 ;
wire startup_req1213 ;
wire bm_smc_sdo_en_int_d1 ;
wire md_jtag_r ;
wire cm_smc_sdo_en_int_d2 ;
wire cm_smc_sdo_en_int_d3 ;
wire n3014 ;
wire smc_podt_rst1105 ;
wire bs_smc_sdo_en ;
wire n_1442 ;
wire n_1570 ;
wire spi_rxpreamble_trycnt974_1 ;
wire n_1768 ;
wire n_1854 ;
wire n_1970 ;
wire spi_rd_cmdaddr_reg_6 ;
wire n3096 ;
wire cor_en_rdcrc ;
wire n_1880 ;
wire spi_rd_cmdaddr_reg_14 ;
wire n2891 ;
wire n3011 ;
wire spi_rd_cmdaddr_reg_2 ;
wire spi_rd_cmdaddr_reg_0 ;
wire spi_rd_cmdaddr_reg_9 ;
wire spi_rd_cmdaddr_reg_4 ;
wire n2892 ;
wire tm_cram_monitor_cell_mask_0_ ;
wire n_5219 ;
wire n3097 ;
wire spi_rd_cmdaddr_reg_10 ;
wire n2902 ;
wire spi_rd_cmdaddr_reg_12 ;
wire spi_rd_cmdaddr_reg_18 ;
wire spi_rd_cmdaddr_reg_15 ;
wire tm_cram_monitor_cell_mask_3_ ;
wire spi_rd_cmdaddr_reg_17 ;
wire spi_rd_cmdaddr_reg_13 ;
wire spi_rd_cmdaddr_reg_20 ;
wire spi_rd_cmdaddr_reg_Q2111_22 ;
wire spi_rd_cmdaddr_reg_11 ;
wire n_5157 ;
wire spi_rd_cmdaddr_reg_5 ;
wire n3169 ;
wire n3209 ;
wire n3210 ;
wire spi_rd_cmdaddr_reg_3 ;
wire n2901 ;
wire n3181 ;
wire n3127 ;
wire n3120 ;
wire n3125 ;
wire n3179 ;
wire n2900 ;
wire n3124 ;
wire n3039 ;
wire n3104 ;
wire n3189 ;
wire n2997 ;


serial_crc CRC16 (
    .crc_out ( {crc_reg_15_ , crc_reg_14_ , crc_reg_13_ , crc_reg_12_ , 
	crc_reg_11_ , crc_reg_10_ , crc_reg_9_ , crc_reg_8_ , crc_reg_7_ , 
	crc_reg_6_ , crc_reg_5_ , crc_reg_4_ , crc_reg_3_ , crc_reg_2_ , 
	crc_reg_1_ , crc_reg_0_ } ) , 
    .rst_b ( rst_bASThfnNet15 ) , .enable ( crc16_en ) , .init ( n3052 ) , 
    .data_in ( crc_data_in ) , 
    .spi_clk_out_GB_G4B2I10ASTHIRNet292 ( spi_clk_out_GB_G4B2I10ASTHIRNet288 ) , 
    .spi_clk_out_GB_G4B2I15ASTHIRNet126 ( spi_clk_out_GB_G4B2I15ASTHIRNet124 ) , 
    .spi_clk_out_GB_G4B2I16ASTHIRNet42 ( spi_clk_out_GB_G4B2I16ASTHIRNet40 ) ) ;


spi_smc SPI_SMC (
    .spi_clk_out_GB_G4B2I1ASTHIRNet231 ( spi_clk_out_GB_G4B2I1ASTHIRNet227 ) , 
    .spi_clk_out_GB_G4B2I14ASTHIRNet224 ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , 
    .spi_clk_out_GB_G4B2I11ASTHIRNet221 ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) , 
    .spi_clk_out_GB_G4B2I8ASTHIRNet185 ( spi_clk_out_GB_G4B2I8ASTHIRNet183 ) , 
    .spi_clk_out_GB_G4B2I5ASTHIRNet168 ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , 
    .spi_clk_out_GB_G4B2I18ASTHIRNet152 ( spi_clk_out_GB_G4B2I18ASTHIRNet154 ) , 
    .spi_clk_out_GB_G4B2I2ASTHIRNet143 ( spi_clk_out_GB_G4B2I2ASTHIRNet139 ) , 
    .usercode_reg ( usercode_reg ) , 
    .spi_clk_out_GB_G4B2I13ASTHIRNet303 ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , 
    .spi_clk_out_GB_G4B2I10ASTHIRNet290 ( spi_clk_out_GB_G4B2I10ASTHIRNet288 ) , 
    .spi_clk_out_GB_G4B2I7ASTHIRNet263 ( spi_clk_out_GB_G4B2I7ASTHIRNet261 ) , 
    .spi_clk_out_GB_G4B2I4ASTHIRNet241 ( spi_clk_out_GB_G4B2I4ASTHIRNet243 ) , 
    .rst_b ( rst_bASThfnNet15 ) , 
    .status_int ( {cm_monitor_cell[3] , cm_monitor_cell[2] , cm_monitor_cell[1] , 
	cm_monitor_cell[0] , cor_security_wrtdis , cor_security_rddis , 
	coldboot_sel[1] , coldboot_sel[0] , warmboot_sel[1] , warmboot_sel[0] , 
	boot , fpga_operation , cfg_ld_bstream , cdone_out , cdone_in , gwe , 
	gio_hz , gint_hz , cor_dis_flashpd , cor_en_8bconfig , n3222 , 
	n3223 , smc_oscoff_b , cor_en_oscclk , n3043 , spi_rxpreamble_fail , 
	cmdreg_err , cmdcode_err , crc_err , idcode_err , md_spi , md_jtag } ) , 
    .sdi ( sdi ) , .cfg_startup ( cfg_startup ) , 
    .sio_data_reg ( {sio_data_reg_31 , sio_data_reg_30 , sio_data_reg_29 , 
	sio_data_reg_28 , sio_data_reg_27 , sio_data_reg_26 , sio_data_reg_25 , 
	sio_data_reg_24 , sio_data_reg_23 , sio_data_reg_22 , sio_data_reg_21 , 
	sio_data_reg_20 , sio_data_reg_19 , sio_data_reg_18 , sio_data_reg_17 , 
	sio_data_reg_16 , sio_data_reg_15 , sio_data_reg_14 , sio_data_reg_13 , 
	sio_data_reg_12 , sio_data_reg_11 , sio_data_reg_10 , sio_data_reg_9 , 
	sio_data_reg_8 , sio_data_reg_7 , sio_data_reg_6 , sio_data_reg_5 , 
	sio_data_reg_4 , sio_data_reg_3 , sio_data_reg_2 , sio_data_reg_1 , 
	cmdcode_byte_0 } ) , 
    .crc_reg ( {crc_reg_15_ , crc_reg_14_ , crc_reg_13_ , crc_reg_12_ , 
	crc_reg_11_ , crc_reg_10_ , crc_reg_9_ , crc_reg_8_ , crc_reg_7_ , 
	crc_reg_6_ , crc_reg_5_ , crc_reg_4_ , crc_reg_3_ , crc_reg_2_ , 
	crc_reg_1_ , crc_reg_0_ } ) , 
    .spi_clk_out_GB_G4B2I9ASTHIRNet86 ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) , 
    .spi_clk_out_GB_G4B2I6ASTHIRNet60 ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) , 
    .cdone_in ( cdone_in ) , .spi_rxpreamble_fail ( spi_rxpreamble_fail ) , 
    .bitstream_err ( bitstream_err ) , .cor_dis_flashpd ( cor_dis_flashpd ) , 
    .cmdhead_cnt_ld ( cmdhead_cnt_ld ) , .cmd_sr_datacnt_ld ( n3029 ) , 
    .smc_status_ld ( n3030 ) , .smc_crc_ld ( n3031 ) , 
    .smc_usercode_ld ( n3032 ) , .md_spi ( md_spi ) , 
    .spi_clk_out_GB_G4B2I15ASTHIRNet122 ( spi_clk_out_GB_G4B2I15ASTHIRNet124 ) , 
    .spi_clk_out_GB_G4B2I12ASTHIRNet116 ( spi_clk_out_GB_G4B2I12ASTHIRNet114 ) , 
    .md_jtag ( md_jtag ) , .md_jtag_rst ( n2911 ) , 
    .j_cfg_enable ( j_cfg_enable ) , .j_cfg_disable ( j_cfg_disable ) , 
    .j_cfg_program ( j_cfg_program ) , .j_sft_dr ( j_sft_dr ) , 
    .tx_spicmd_read_req ( n3006 ) , .disable_flash_req_BAR ( n3173 ) , 
    .bs_smc_cmdhead_en ( n3017 ) , .bs_smc_sdio_en ( bs_smc_sdio_en ) , 
    .spi_ss_out_b_int ( spi_ss_out_b_int ) , .sr_datacnt_0 ( sr_datacnt_0 ) , 
    .cmdhead_cnt_0_BAR ( cmdhead_cnt_0 ) , .spi_tx_done ( spi_tx_done ) , 
    .cmdhead_reg ( {cmdreg_code_3_ , cmdreg_code_2_ , cmdreg_code_1_ , cmdreg_code_0_ , 
	cmdhead_reg_3 , cmdhead_reg_2 , cmdhead_reg_1 , cmdhead_reg_0 } ) , 
    .spi_rd_cmdaddr ( {spi_rd_cmdaddr_31 , spi_rd_cmdaddr_30 , spi_rd_cmdaddr_29 , 
	spi_rd_cmdaddr_28 , spi_rd_cmdaddr_27 , spi_rd_cmdaddr_26 , 
	spi_rd_cmdaddr_25 , spi_rd_cmdaddr_24 , val2431_24 , 
	spi_rd_cmdaddr_22 , spi_rd_cmdaddr_21 , val2431_21 , 
	spi_rd_cmdaddr_19 , spi_rd_cmdaddr_18 , spi_rd_cmdaddr_17 , 
	spi_rd_cmdaddr_16 , spi_rd_cmdaddr_15 , spi_rd_cmdaddr_14 , 
	spi_rd_cmdaddr_13 , spi_rd_cmdaddr_12 , spi_rd_cmdaddr_11 , 
	spi_rd_cmdaddr_10 , spi_rd_cmdaddr_9 , spi_rd_cmdaddr_8 , 
	spi_rd_cmdaddr_7 , spi_rd_cmdaddr_6 , spi_rd_cmdaddr_5 , 
	spi_rd_cmdaddr_4 , spi_rd_cmdaddr_3 , spi_rd_cmdaddr_2 , 
	spi_rd_cmdaddr_1 , spi_rd_cmdaddr_0 } ) ) ;

CKND8HVT U1441 (.I ( n3070 ) , .ZN ( cram_wrt ) ) ;
OAI33D0HVT U1142 (.B1 ( n2894 ) , .B2 ( n3004 ) , .B3 ( n3093 ) , .A3 ( n3092 ) 
    , .ZN ( bm_smc_sdo_en_int ) , .A1 ( n3182 ) , .A2 ( n2991 ) ) ;
NR2XD2HVT U1381 (.A1 ( cmdreg_code_0_ ) , .A2 ( n3178 ) , .ZN ( n3046 ) ) ;
NR2XD0HVT U1366 (.A1 ( n3142 ) , .A2 ( n3108 ) , .ZN ( n3021 ) ) ;
NR2XD0HVT U1279 (.A1 ( n3140 ) , .A2 ( n3144 ) , .ZN ( n2993 ) ) ;
NR2D2HVT U1168 (.A1 ( cor_en_coldboot ) , .A2 ( warmboot_req ) , .ZN ( n2909 ) ) ;
MOAI22D0HVT U1144 (.ZN ( n3180 ) , .B2 ( n2956 ) , .A1 ( n2896 ) , .A2 ( n2958 ) 
    , .B1 ( n3154 ) ) ;
AN4D0HVT U1146 (.A1 ( sio_data_reg_21 ) , .Z ( n2967 ) 
    , .A3 ( sio_data_reg_17 ) , .A2 ( sio_data_reg_6 ) , .A4 ( sio_data_reg_5 ) ) ;
AN4D0HVT U1148 (.A1 ( sio_data_reg_15 ) , .Z ( n2965 ) , .A3 ( sio_data_reg_8 ) 
    , .A2 ( sio_data_reg_30 ) , .A4 ( sio_data_reg_23 ) ) ;
AN4D0HVT U1149 (.A1 ( sio_data_reg_4 ) , .Z ( n2964 ) , .A3 ( sio_data_reg_25 ) 
    , .A2 ( sio_data_reg_12 ) , .A4 ( sio_data_reg_27 ) ) ;
CKND8HVT U1435 (.I ( n3062 ) , .ZN ( smc_podt_rst ) ) ;
CKND8HVT U1436 (.I ( n3064 ) , .ZN ( smc_podt_off ) ) ;
CKND8HVT U1437 (.I ( n3066 ) , .ZN ( smc_osc_fsel[0] ) ) ;
CKND8HVT U1438 (.I ( n3068 ) , .ZN ( smc_osc_fsel[1] ) ) ;
ND2D0HVT U1296 (.ZN ( n_3948 ) , .A1 ( n3002 ) , .A2 ( n3001 ) ) ;
ND2D0HVT U1302 (.ZN ( n3164 ) , .A1 ( md_spi ) , .A2 ( cfg_ld_bstream ) ) ;
AN3D0HVT U1294 (.Z ( n3019 ) , .A2 ( cfg_ld_bstream ) , .A1 ( n3103 ) 
    , .A3 ( cnt_podt_out ) ) ;
AN3D0HVT U1147 (.Z ( n2966 ) , .A2 ( sio_data_reg_19 ) 
    , .A1 ( sio_data_reg_28 ) , .A3 ( sio_data_reg_11 ) ) ;
AN3D0HVT U1150 (.Z ( n2968 ) , .A2 ( sio_data_reg_29 ) 
    , .A1 ( sio_data_reg_26 ) , .A3 ( sio_data_reg_2 ) ) ;
MOAI22D0HVT U1496 (.ZN ( n3211 ) , .B2 ( n2955 ) , .A1 ( spi_tx_done ) 
    , .A2 ( n2954 ) , .B1 ( n2956 ) ) ;
MOAI22D0HVT U1501 (.ZN ( n3110 ) , .B2 ( n2909 ) , .A1 ( n3176 ) , .A2 ( n3217 ) 
    , .B1 ( spi_rd_cmdaddr_reg_7 ) ) ;
MOAI22D0HVT U1506 (.ZN ( n3215 ) , .B2 ( n3164 ) , .A1 ( n3155 ) , .A2 ( n3174 ) 
    , .B1 ( n3214 ) ) ;
ND3D0HVT U1248 (.A1 ( n3132 ) , .ZN ( n3134 ) , .A2 ( bs_state_2_ ) 
    , .A3 ( n3007 ) ) ;
ND3D0HVT U1291 (.A1 ( bs_state_0_ ) , .ZN ( n3175 ) , .A2 ( bs_state_2_ ) 
    , .A3 ( n3007 ) ) ;
ND3D0HVT U1295 (.A1 ( n2991 ) , .ZN ( n3093 ) , .A2 ( n3092 ) , .A3 ( n3182 ) ) ;
ND3D0HVT U1349 (.A1 ( spi_rxpreamble_trycnt_0_ ) , .ZN ( n3103 ) 
    , .A2 ( spi_rxpreamble_trycnt_2_ ) , .A3 ( spi_rxpreamble_trycnt_1_ ) ) ;
ND2D0HVT U1152 (.ZN ( n3217 ) , .A1 ( warmboot_sel_int_0_ ) 
    , .A2 ( warmboot_sel_int_1_ ) ) ;
ND2D0HVT U1224 (.ZN ( n3158 ) , .A1 ( n3155 ) , .A2 ( bs_state_1_ ) ) ;
ND2D0HVT U1228 (.ZN ( n2953 ) , .A1 ( sr_datacnt_0 ) , .A2 ( n2959 ) ) ;
ND2D0HVT U1244 (.ZN ( n3099 ) , .A1 ( n2963 ) , .A2 ( n2962 ) ) ;
MUX2ND0HVT U1153 (.ZN ( n3190 ) , .I0 ( cm_sdo_u0[1] ) , .S ( n3226 ) 
    , .I1 ( cm_sdo_u1[1] ) ) ;
AOI31D0HVT U1154 (.B ( n3005 ) , .A1 ( spi_rxpreamble_fail ) , .ZN ( n3126 ) 
    , .A3 ( n2895 ) , .A2 ( n2957 ) ) ;
AOI31D0HVT U1225 (.B ( n3134 ) , .A1 ( n2953 ) , .ZN ( n3129 ) , .A3 ( n2951 ) 
    , .A2 ( n2952 ) ) ;
AOI31D0HVT U1243 (.B ( n3137 ) , .A1 ( sio_data_reg_2 ) , .ZN ( n3121 ) 
    , .A3 ( n2993 ) , .A2 ( cmdcode_byte_0 ) ) ;
ND3D0HVT U1384 (.A1 ( cor_en_warmboot ) , .ZN ( n3176 ) , .A2 ( warmboot_int ) 
    , .A3 ( md_spi ) ) ;
ND3D0HVT U1151 (.A1 ( n3103 ) , .ZN ( n_875 ) , .A2 ( n2954 ) , .A3 ( n2895 ) ) ;
ND3D0HVT U1236 (.A1 ( bs_state_3_ ) , .ZN ( n3173 ) , .A2 ( bs_state_1_ ) 
    , .A3 ( n2995 ) ) ;
ND3D0HVT U1246 (.A1 ( n2969 ) , .ZN ( n3162 ) , .A2 ( n2993 ) , .A3 ( n2968 ) ) ;
NR2D0HVT U1160 (.A1 ( n3115 ) , .A2 ( n3158 ) , .ZN ( n2898 ) ) ;
NR2D0HVT U1161 (.A1 ( n3149 ) , .A2 ( n3109 ) , .ZN ( n2899 ) ) ;
INVD1HVT U1386 (.I ( n3218 ) , .ZN ( n_5075 ) ) ;
INVD1HVT U1404 (.I ( n3219 ) , .ZN ( n_3685 ) ) ;
INVD1HVT U1141 (.I ( n2893 ) , .ZN ( en_8bconfig_b ) ) ;
MUX2ND0HVT U1172 (.ZN ( n3193 ) , .I0 ( n2913 ) , .S ( baddr[1] ) 
    , .I1 ( n2912 ) ) ;
MUX2ND0HVT U1173 (.ZN ( n2912 ) , .I0 ( n3221 ) , .S ( n3226 ) , .I1 ( n3220 ) ) ;
MUX2ND0HVT U1297 (.ZN ( n3001 ) , .I0 ( bp0 ) , .S ( n3050 ) 
    , .I1 ( sio_data_reg_6 ) ) ;
NR2D0HVT U1162 (.A1 ( n3158 ) , .A2 ( n3159 ) , .ZN ( n2903 ) ) ;
NR2D0HVT U1163 (.A1 ( n2905 ) , .A2 ( n2904 ) , .ZN ( n3043 ) ) ;
NR2D0HVT U1164 (.A1 ( n2906 ) , .A2 ( n3131 ) , .ZN ( spi_rd_cmdaddr_1 ) ) ;
NR2D0HVT U1165 (.A1 ( n2907 ) , .A2 ( n3131 ) , .ZN ( spi_rd_cmdaddr_8 ) ) ;
NR2D0HVT U1166 (.A1 ( n3142 ) , .A2 ( n3149 ) , .ZN ( n2908 ) ) ;
NR2D0HVT U1170 (.A1 ( n3118 ) , .A2 ( n3149 ) , .ZN ( n2910 ) ) ;
NR2D0HVT U1174 (.A1 ( n3190 ) , .A2 ( n3177 ) , .ZN ( n2913 ) ) ;
NR2D0HVT U1140 (.A1 ( end_of_startup ) , .A2 ( n3091 ) , .ZN ( n2893 ) ) ;
NR2D0HVT U1233 (.A1 ( n3043 ) , .A2 ( n3130 ) , .ZN ( n2955 ) ) ;
NR2D0HVT U1269 (.A1 ( n2986 ) , .A2 ( n3131 ) , .ZN ( spi_rd_cmdaddr_16 ) ) ;
NR2D0HVT U1270 (.A1 ( n2987 ) , .A2 ( n3131 ) , .ZN ( spi_rd_cmdaddr_21 ) ) ;
NR2D0HVT U1271 (.A1 ( n2988 ) , .A2 ( n3131 ) , .ZN ( spi_rd_cmdaddr_19 ) ) ;
NR2D0HVT U1272 (.A1 ( n2989 ) , .A2 ( n3131 ) , .ZN ( val2431_24 ) ) ;
NR2D0HVT U1273 (.A1 ( n3106 ) , .A2 ( n2990 ) 
    , .ZN ( spi_rxpreamble_trycnt974_2 ) ) ;
NR2D0HVT U1275 (.A1 ( spi_rxpreamble_trycnt_0_ ) , .A2 ( n3106 ) 
    , .ZN ( spi_rxpreamble_trycnt974_0 ) ) ;
NR2D0HVT U1276 (.A1 ( n3171 ) , .A2 ( n2915 ) , .ZN ( n2991 ) ) ;
NR2D0HVT U1367 (.A1 ( n2992 ) , .A2 ( n3185 ) , .ZN ( n3025 ) ) ;
NR2D0HVT U1281 (.A1 ( n3141 ) , .A2 ( n3109 ) , .ZN ( n2994 ) ) ;
NR2D0HVT U1283 (.A1 ( bs_state_0_ ) , .A2 ( bs_state_2_ ) , .ZN ( n2995 ) ) ;
NR2D0HVT U1285 (.A1 ( n3117 ) , .A2 ( n3142 ) , .ZN ( n2996 ) ) ;
NR2D0HVT U1290 (.A1 ( n3141 ) , .A2 ( n3095 ) , .ZN ( n2999 ) ) ;
NR2D0HVT U1292 (.A1 ( spi_master_go ) , .A2 ( n3045 ) , .ZN ( n3000 ) ) ;
NR2D0HVT U1298 (.A1 ( n3107 ) , .A2 ( n3178 ) , .ZN ( n3003 ) ) ;
NR2D0HVT U1303 (.A1 ( n3141 ) , .A2 ( n3142 ) , .ZN ( n3005 ) ) ;
NR2D0HVT U1375 (.A1 ( n2991 ) , .A2 ( n3182 ) , .ZN ( n3038 ) ) ;
NR2D0HVT U1379 (.A1 ( bm_smc_sdo_en ) , .A2 ( cm_smc_sdo_en ) , .ZN ( n3044 ) ) ;
NR2D0HVT U1304 (.A1 ( bs_state_1_ ) , .A2 ( bs_state_3_ ) , .ZN ( n3007 ) ) ;
NR2D0HVT U1306 (.A1 ( n3118 ) , .A2 ( n3141 ) , .ZN ( n3008 ) ) ;
NR2D0HVT U1310 (.A1 ( n3108 ) , .A2 ( n3109 ) , .ZN ( n3010 ) ) ;
NR2D0HVT U1361 (.A1 ( n3117 ) , .A2 ( n3109 ) , .ZN ( n3015 ) ) ;
NR2D0HVT U1363 (.A1 ( n3186 ) , .A2 ( n3093 ) , .ZN ( n3017 ) ) ;
NR2D0HVT U1364 (.A1 ( n3004 ) , .A2 ( n3196 ) , .ZN ( n3018 ) ) ;
IND2D0HVT U1326 (.A1 ( n3177 ) , .B1 ( cm_sdo_u3[1] ) , .ZN ( n3220 ) ) ;
IND2D0HVT U1329 (.A1 ( n3177 ) , .B1 ( cm_sdo_u2[1] ) , .ZN ( n3221 ) ) ;
NR2D0HVT U1159 (.ZN ( n2897 ) , .A2 ( n3152 ) , .A1 ( n2914 ) ) ;
NR2D0HVT U1143 (.ZN ( n3013 ) , .A2 ( n3138 ) , .A1 ( n3121 ) ) ;
NR2D0HVT U1368 (.A1 ( n3094 ) , .A2 ( n3185 ) , .ZN ( n3026 ) ) ;
NR2D0HVT U1369 (.A1 ( n3004 ) , .A2 ( n3185 ) , .ZN ( n3027 ) ) ;
NR2D0HVT U1370 (.A1 ( n2991 ) , .A2 ( n3185 ) , .ZN ( n3028 ) ) ;
NR2D0HVT U1373 (.A1 ( warmboot_req ) , .A2 ( n2909 ) , .ZN ( n3036 ) ) ;
CKND0HVT U1242 (.I ( n2961 ) , .ZN ( n3102 ) ) ;
CKND0HVT U1278 (.I ( n2992 ) , .ZN ( n3182 ) ) ;
CKND0HVT U1155 (.I ( n3016 ) , .ZN ( n2895 ) ) ;
CKND0HVT U1157 (.I ( n2896 ) , .ZN ( n2957 ) ) ;
IND2D0HVT U1156 (.A1 ( cfg_shutdown ) , .B1 ( n2903 ) , .ZN ( n2896 ) ) ;
IND2D0HVT U1230 (.A1 ( n3115 ) , .B1 ( n3007 ) , .ZN ( n2954 ) ) ;
IND2D0HVT U1320 (.A1 ( n3092 ) , .B1 ( tm_en_cram_blsr_test ) , .ZN ( n3195 ) ) ;
IND2D0HVT U1323 (.A1 ( sio_data_reg_31 ) , .B1 ( bs_smc_sdo_en_reg ) 
    , .ZN ( n3194 ) ) ;
CKND0HVT U1309 (.I ( n3009 ) , .ZN ( n3148 ) ) ;
CKND0HVT U1311 (.I ( n3010 ) , .ZN ( cmdreg_err1327 ) ) ;
CKND0HVT U1169 (.I ( n2909 ) , .ZN ( n3131 ) ) ;
CKND0HVT U1179 (.I ( n2916 ) , .ZN ( n3153 ) ) ;
CKND0HVT U1223 (.I ( n2950 ) , .ZN ( n3095 ) ) ;
CKND0HVT U1229 (.I ( n2953 ) , .ZN ( n3024 ) ) ;
CKND0HVT U1231 (.I ( n2954 ) , .ZN ( n3006 ) ) ;
CKND0HVT U1234 (.I ( n2955 ) , .ZN ( n3154 ) ) ;
CKND0HVT U1341 (.I ( n3012 ) , .ZN ( n3058 ) ) ;
CKND0HVT U1342 (.I ( n3134 ) , .ZN ( n3119 ) ) ;
CKND0HVT U1280 (.I ( n2993 ) , .ZN ( n3108 ) ) ;
CKND0HVT U1284 (.I ( n2995 ) , .ZN ( n3159 ) ) ;
CKND0HVT U1286 (.I ( n2996 ) , .ZN ( n3172 ) ) ;
CKND0HVT U1293 (.I ( n3000 ) , .ZN ( n3106 ) ) ;
CKND0HVT U1299 (.I ( n3003 ) , .ZN ( n3218 ) ) ;
CKND0HVT U1301 (.I ( n3004 ) , .ZN ( n3186 ) ) ;
CKND0HVT U1351 (.I ( n3012 ) , .ZN ( n3060 ) ) ;
CKND0HVT U1353 (.I ( bram_done ) , .ZN ( n3174 ) ) ;
CKND0HVT U1315 (.I ( coldboot_sel[0] ) , .ZN ( n3114 ) ) ;
CKND0HVT U1319 (.I ( n3173 ) , .ZN ( disable_flash_req ) ) ;
CKND0HVT U1322 (.I ( sr_datacnt_0 ) , .ZN ( n3135 ) ) ;
CKND0HVT U1325 (.I ( n3220 ) , .ZN ( sdo_rx_7_ ) ) ;
CKND0HVT U1328 (.I ( n3221 ) , .ZN ( sdo_rx_5_ ) ) ;
CKND0HVT U1340 (.I ( n3175 ) , .ZN ( n3101 ) ) ;
CKND0HVT U1360 (.I ( cm_smc_sdo_en ) , .ZN ( n3177 ) ) ;
CKND0HVT U1383 (.I ( n3176 ) , .ZN ( warmboot_req ) ) ;
CKND0HVT U1344 (.I ( n3092 ) , .ZN ( n3094 ) ) ;
CKND0HVT U1345 (.I ( n3012 ) , .ZN ( n3061 ) ) ;
CKND0HVT U1346 (.I ( n3164 ) , .ZN ( n3116 ) ) ;
CKND0HVT U1347 (.I ( md_spi ) , .ZN ( n3130 ) ) ;
CKND0HVT U1348 (.I ( n3103 ) , .ZN ( spi_rxpreamble_fail ) ) ;
CKND0HVT U1350 (.I ( n3012 ) , .ZN ( n3059 ) ) ;
CKND0HVT U1406 (.I ( sio_data_reg_1 ) , .ZN ( n3140 ) ) ;
CKND0HVT U1409 (.I ( cmdcode_byte_0 ) , .ZN ( n3123 ) ) ;
CKND0HVT U1354 (.I ( cram_done ) , .ZN ( n3128 ) ) ;
CKND0HVT U1355 (.I ( cmdreg_code_3_ ) , .ZN ( n3145 ) ) ;
CKND0HVT U1356 (.I ( cmdreg_code_2_ ) , .ZN ( n3146 ) ) ;
CKND0HVT U1357 (.I ( cmdreg_code_1_ ) , .ZN ( n3105 ) ) ;
CKND0HVT U1358 (.I ( bs_state_3_ ) , .ZN ( n3155 ) ) ;
CKND0HVT U1359 (.I ( bs_state_2_ ) , .ZN ( n3133 ) ) ;
CKBD6HVT CKBD6HVTG4B2I7 (.Z ( spi_clk_out_GB_G4B2I7ASTHIRNet261 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet119 ) ) ;
CKBD6HVT CKBD6HVTG4B2I12 (.Z ( spi_clk_out_GB_G4B2I12ASTHIRNet114 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet119 ) ) ;
CKBD6HVT CKBD6HVTG4B2I13 (.Z ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet119 ) ) ;
CKBD6HVT CKBD6HVTG4B2I10 (.Z ( spi_clk_out_GB_G4B2I10ASTHIRNet288 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet119 ) ) ;
CKND0HVT U1410 (.I ( n2998 ) , .ZN ( n3052 ) ) ;
CKND0HVT U1394 (.I ( sio_data_reg_2 ) , .ZN ( n3122 ) ) ;
CKND0HVT U1396 (.I ( cmdreg_code_0_ ) , .ZN ( n3107 ) ) ;
CKND0HVT U1401 (.I ( sio_data_reg_3 ) , .ZN ( n3144 ) ) ;
OAI211D0HVT U1177 (.ZN ( n2915 ) , .A1 ( n3153 ) , .C ( n3213 ) , .A2 ( n3172 ) 
    , .B ( n3212 ) ) ;
INVD0HVT U1171 (.I ( n2914 ) , .ZN ( n3150 ) ) ;
INVD0HVT U1382 (.I ( n3047 ) , .ZN ( baddr[0] ) ) ;
INVD0HVT U1403 (.I ( n3219 ) , .ZN ( n3050 ) ) ;
INVD0HVT U1440 (.ZN ( n3070 ) , .I ( n3227 ) ) ;
INVD0HVT U1434 (.ZN ( n3062 ) , .I ( n3224 ) ) ;
CKBD6HVT CKBD6HVTG4B2I8 (.Z ( spi_clk_out_GB_G4B2I8ASTHIRNet183 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet119 ) ) ;
CKBD6HVT CKBD6HVTG4B2I6 (.Z ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet119 ) ) ;
AOI21D0HVT U1300 (.A2 ( n3187 ) , .ZN ( n3004 ) , .A1 ( n3119 ) , .B ( n3188 ) ) ;
NR4D0HVT U1237 (.A2 ( n3166 ) , .A3 ( n3167 ) , .A4 ( n3153 ) , .A1 ( n3021 ) 
    , .ZN ( n2959 ) ) ;
NR4D0HVT U1240 (.A2 ( cmdreg_code_0_ ) , .A3 ( cmdhead_reg_2 ) 
    , .A4 ( cmdhead_reg_3 ) , .A1 ( cmdhead_reg_1 ) , .ZN ( n2960 ) ) ;
NR4D0HVT U1247 (.A2 ( sio_data_reg_20 ) , .A3 ( sio_data_reg_24 ) 
    , .A4 ( sio_data_reg_31 ) , .A1 ( sio_data_reg_16 ) , .ZN ( n2969 ) ) ;
NR4D0HVT U1308 (.A2 ( cmdreg_code_3_ ) , .A3 ( n3105 ) , .A4 ( n3136 ) 
    , .A1 ( cmdreg_code_2_ ) , .ZN ( n3009 ) ) ;
NR4D0HVT U1176 (.A2 ( n3034 ) , .A3 ( n3151 ) , .A4 ( idcode_err1526 ) 
    , .A1 ( n3013 ) , .ZN ( n2914 ) ) ;
NR4D1HVT U1362 (.A2 ( n3161 ) , .A3 ( n3162 ) , .A4 ( n3163 ) , .A1 ( n3160 ) 
    , .ZN ( n3016 ) ) ;
NR4D1HVT U1376 (.A2 ( n3208 ) , .A3 ( n3205 ) , .A4 ( n3206 ) , .A1 ( n3207 ) 
    , .ZN ( n3040 ) ) ;
NR3D0HVT U1371 (.A1 ( bs_state_0_ ) , .ZN ( n3033 ) , .A2 ( n3133 ) 
    , .A3 ( n3158 ) ) ;
NR3D0HVT U1372 (.A1 ( n3146 ) , .ZN ( n3034 ) , .A2 ( n3145 ) , .A3 ( n3136 ) ) ;
NR3D0HVT U1374 (.A1 ( n3186 ) , .ZN ( n3037 ) , .A2 ( n3092 ) , .A3 ( n2992 ) ) ;
NR3D0HVT U1178 (.A1 ( n3042 ) , .ZN ( n2916 ) , .A2 ( n3152 ) , .A3 ( n3150 ) ) ;
OAI22D0HVT U1180 (.A2 ( n3157 ) , .A1 ( sr_datacnt_0 ) , .B2 ( n2917 ) 
    , .ZN ( n3171 ) , .B1 ( n3134 ) ) ;
OAI22D0HVT U1232 (.A2 ( n3128 ) , .A1 ( n3175 ) , .B2 ( n3135 ) , .ZN ( n3216 ) 
    , .B1 ( n3157 ) ) ;
AOI21D0HVT U1181 (.A2 ( n3166 ) , .ZN ( n2917 ) , .A1 ( n2916 ) , .B ( n3035 ) ) ;
AOI21D0HVT U1277 (.A2 ( n3183 ) , .ZN ( n2992 ) , .A1 ( n3119 ) , .B ( n3184 ) ) ;
CKBD4HVT rst_b_regASThfnInst16 (.Z ( rst_bASThfnNet16 ) 
    , .I ( rst_bASThfnNet11 ) ) ;
NR3D0HVT U1377 (.A1 ( cmdreg_code_0_ ) , .ZN ( n3041 ) , .A2 ( n3040 ) 
    , .A3 ( n3148 ) ) ;
NR3D0HVT U1380 (.A1 ( n3094 ) , .ZN ( n3045 ) , .A2 ( n2991 ) , .A3 ( n2992 ) ) ;
NR3D0HVT U1222 (.A1 ( cmdcode_byte_0 ) , .ZN ( n2950 ) , .A2 ( sio_data_reg_2 ) 
    , .A3 ( n3139 ) ) ;
NR3D0HVT U1226 (.A1 ( n3022 ) , .ZN ( n2951 ) , .A2 ( n3023 ) , .A3 ( n3035 ) ) ;
NR3D0HVT U1235 (.A1 ( spi_rxpreamble_fail ) , .ZN ( n2958 ) , .A2 ( n3165 ) 
    , .A3 ( n3164 ) ) ;
NR3D0HVT U1241 (.A1 ( cmdreg_code_2_ ) , .ZN ( n2961 ) , .A2 ( cmdreg_code_1_ ) 
    , .A3 ( n3136 ) ) ;
NR3D0HVT U1365 (.A1 ( n3132 ) , .ZN ( n3020 ) , .A2 ( n3133 ) , .A3 ( n3158 ) ) ;
ND4D0HVT U1217 (.A2 ( n2948 ) , .A3 ( n2947 ) , .A4 ( n2946 ) , .ZN ( n3199 ) 
    , .A1 ( n2949 ) ) ;
ND4D0HVT U1239 (.A2 ( cmdhead_reg_0 ) , .A3 ( n2960 ) , .A4 ( n2961 ) 
    , .ZN ( n3138 ) , .A1 ( n3145 ) ) ;
ND4D0HVT U1182 (.A2 ( n2920 ) , .A3 ( n2919 ) , .A4 ( n2918 ) , .ZN ( n3202 ) 
    , .A1 ( n2921 ) ) ;
CKBD16HVT rst_b_regASThfnInst11 (.I ( rst_b ) , .Z ( rst_bASThfnNet11 ) ) ;
CKBD4HVT rst_b_regASThfnInst12 (.Z ( rst_bASThfnNet12 ) 
    , .I ( rst_bASThfnNet11 ) ) ;
CKBD4HVT rst_b_regASThfnInst13 (.Z ( rst_bASThfnNet13 ) 
    , .I ( rst_bASThfnNet11 ) ) ;
CKBD4HVT rst_b_regASThfnInst14 (.Z ( rst_bASThfnNet14 ) 
    , .I ( rst_bASThfnNet11 ) ) ;
CKBD4HVT rst_b_regASThfnInst15 (.Z ( rst_bASThfnNet15 ) 
    , .I ( rst_bASThfnNet11 ) ) ;
ND4D0HVT U1259 (.A2 ( n2980 ) , .A3 ( n2979 ) , .A4 ( n2978 ) , .ZN ( n3208 ) 
    , .A1 ( n2981 ) ) ;
ND4D0HVT U1264 (.A2 ( n2984 ) , .A3 ( n2983 ) , .A4 ( n2982 ) , .ZN ( n3207 ) 
    , .A1 ( n2985 ) ) ;
ND4D0HVT U1187 (.A2 ( n2924 ) , .A3 ( n2923 ) , .A4 ( n2922 ) , .ZN ( n3201 ) 
    , .A1 ( n2925 ) ) ;
ND4D0HVT U1192 (.A2 ( n2928 ) , .A3 ( n2927 ) , .A4 ( n2926 ) , .ZN ( n3204 ) 
    , .A1 ( n2929 ) ) ;
ND4D0HVT U1197 (.A2 ( n2932 ) , .A3 ( n2931 ) , .A4 ( n2930 ) , .ZN ( n3203 ) 
    , .A1 ( n2933 ) ) ;
ND4D0HVT U1202 (.A2 ( n2936 ) , .A3 ( n2935 ) , .A4 ( n2934 ) , .ZN ( n3198 ) 
    , .A1 ( n2937 ) ) ;
ND4D0HVT U1207 (.A2 ( n2940 ) , .A3 ( n2939 ) , .A4 ( n2938 ) , .ZN ( n3197 ) 
    , .A1 ( n2941 ) ) ;
ND4D0HVT U1212 (.A2 ( n2944 ) , .A3 ( n2943 ) , .A4 ( n2942 ) , .ZN ( n3200 ) 
    , .A1 ( n2945 ) ) ;
OR2D0HVT U1447 (.A2 ( n2994 ) , .A1 ( n3020 ) , .Z ( bram_wrt476 ) ) ;
OR2D0HVT U1449 (.A2 ( n2999 ) , .A1 ( n3033 ) , .Z ( cram_rd470 ) ) ;
OR2D0HVT U1450 (.A2 ( sio_data_reg_7 ) , .A1 ( cor_security_wrtdis ) 
    , .Z ( n_2567 ) ) ;
OR2D0HVT U1451 (.A2 ( n3015 ) , .A1 ( n3101 ) , .Z ( cram_wrt464 ) ) ;
OR2D0HVT U1453 (.A2 ( n3106 ) , .A1 ( n3019 ) , .Z ( n975_0 ) ) ;
ND4D0HVT U1245 (.A2 ( n2966 ) , .A3 ( n2965 ) , .A4 ( n2964 ) , .ZN ( n3163 ) 
    , .A1 ( n2967 ) ) ;
ND4D0HVT U1249 (.A2 ( n2972 ) , .A3 ( n2971 ) , .A4 ( n2970 ) , .ZN ( n3206 ) 
    , .A1 ( n2973 ) ) ;
ND4D0HVT U1254 (.A2 ( n2976 ) , .A3 ( n2975 ) , .A4 ( n2974 ) , .ZN ( n3205 ) 
    , .A1 ( n2977 ) ) ;
OR2D0HVT U1455 (.A2 ( n3010 ) , .A1 ( n3034 ) , .Z ( n_1346 ) ) ;
OR2D0HVT U1457 (.A2 ( n3050 ) , .A1 ( smc_load_nvcm_bstream ) , .Z ( n_3949 ) ) ;
OR2D0HVT U1458 (.A2 ( n3021 ) , .A1 ( nvcm_relextspi ) , .Z ( n_5241 ) ) ;
OR2D0HVT U1466 (.A2 ( n3132 ) , .A1 ( bs_state_2_ ) , .Z ( n3115 ) ) ;
OR2D0HVT U1469 (.A2 ( n3138 ) , .A1 ( n3137 ) , .Z ( n3139 ) ) ;
OR2D0HVT U1470 (.A2 ( sio_data_reg_1 ) , .A1 ( sio_data_reg_3 ) , .Z ( n3117 ) ) ;
OR2D0HVT U1472 (.A2 ( n3140 ) , .A1 ( sio_data_reg_3 ) , .Z ( n3141 ) ) ;
OR2D0HVT U1289 (.A2 ( n3118 ) , .A1 ( n3117 ) , .Z ( n2998 ) ) ;
AO221D0HVT U1321 (.B1 ( tm_cram_monitor_cell_mask_2_ ) 
    , .B2 ( cm_monitor_cell[2] ) , .C ( n3143 ) , .A2 ( cm_monitor_cell[1] ) 
    , .A1 ( tm_cram_monitor_cell_mask_1_ ) , .Z ( n3100 ) ) ;
IOA21D0HVT U1335 (.A2 ( n3177 ) , .B ( n3193 ) , .ZN ( n3191 ) , .A1 ( n3192 ) ) ;
HA1D0HVT add_735_U1_1_1 (.S ( spi_rxpreamble_trycnt976_1 ) 
    , .A ( spi_rxpreamble_trycnt_1_ ) , .B ( spi_rxpreamble_trycnt_0_ ) 
    , .CO ( add_735_carry_2 ) ) ;
OR2D0HVT U1474 (.A2 ( n3144 ) , .A1 ( sio_data_reg_1 ) , .Z ( n3149 ) ) ;
OR2D0HVT U1477 (.A2 ( n3155 ) , .A1 ( bs_state_1_ ) , .Z ( n3156 ) ) ;
OR2D0HVT U1478 (.A2 ( n3156 ) , .A1 ( n3115 ) , .Z ( n3157 ) ) ;
OR2D0HVT U1489 (.A2 ( n3100 ) , .A1 ( n3041 ) , .Z ( n3151 ) ) ;
OR2D0HVT U1454 (.A2 ( n3013 ) , .A1 ( n3010 ) , .Z ( n_1324 ) ) ;
DFCND1HVT spi_ldbstream_trycnt_reg_0_ (.Q ( spi_ldbstream_trycnt_0_ ) 
    , .CDN ( rst_bASThfnNet14 ) , .QN ( n2904 ) , .D ( n3086 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet45 ) ) ;
DFCND1HVT bs_state_reg_0_ (.Q ( bs_state_0_ ) , .CDN ( rst_bASThfnNet14 ) 
    , .QN ( n3132 ) , .D ( n3025 ) , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) ) ;
CKBD8HVT CKBD8HVTG4B2I14 (.Z ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet119 ) ) ;
CKBD12HVT CKBD12HVTG4B2I11 (.Z ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet119 ) ) ;
CKBD12HVT CKBD12HVTG4B2I9 (.Z ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet119 ) ) ;
AOI211D0HVT U1378 (.ZN ( n3042 ) , .A2 ( n3168 ) , .C ( n3095 ) , .A1 ( n3130 ) 
    , .B ( n3149 ) ) ;
OA32D0HVT U1317 (.Z ( n3212 ) , .B2 ( n3164 ) , .B1 ( n3126 ) , .A3 ( n3156 ) 
    , .A2 ( n3159 ) , .A1 ( bram_done ) ) ;
AO221D0HVT U1318 (.B1 ( n3016 ) , .B2 ( n2903 ) , .C ( n3020 ) 
    , .A2 ( cmdhead_cnt_0 ) , .A1 ( n2898 ) , .Z ( n3170 ) ) ;
DFSND1HVT spi_rd_cmdaddr_reg_reg_24_ (.D ( n3089 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) , .Q ( spi_rd_cmdaddr_24 ) 
    , .SDN ( rst_bASThfnNet11 ) ) ;
LHCND1HVT warmboot_sel_int_reg_1_ (.E ( fpga_operation ) 
    , .Q ( warmboot_sel_int_1_ ) , .CDN ( rst_bASThfnNet16 ) 
    , .D ( warmboot_sel[1] ) ) ;
LHCND1HVT warmboot_sel_int_reg_0_ (.E ( fpga_operation ) 
    , .Q ( warmboot_sel_int_0_ ) , .QN ( n3113 ) , .CDN ( rst_bASThfnNet16 ) 
    , .D ( warmboot_sel[0] ) ) ;
CKXOR2D0HVT U1442 (.Z ( n3086 ) , .A2 ( spi_ldbstream_trycnt_0_ ) 
    , .A1 ( n3045 ) ) ;
CKXOR2D0HVT U1443 (.Z ( spi_ldbstream_trycnt1059_1 ) 
    , .A2 ( spi_ldbstream_trycnt_1_ ) , .A1 ( spi_ldbstream_trycnt_0_ ) ) ;
CKXOR2D0HVT U1484 (.Z ( n3111 ) , .A2 ( warmboot_sel_int_1_ ) 
    , .A1 ( warmboot_sel_int_0_ ) ) ;
CKXOR2D0HVT U1485 (.Z ( n3112 ) , .A2 ( coldboot_sel[1] ) 
    , .A1 ( coldboot_sel[0] ) ) ;
CKXOR2D0HVT U1486 (.Z ( n3098 ) , .A2 ( n3186 ) , .A1 ( n3092 ) ) ;
DFCNQD1HVT sdo_r_reg_2_ (.D ( sdo_rx_2_ ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet260 ) , .Q ( sdo[2] ) 
    , .CDN ( rst_bASThfnNet13 ) ) ;
DFCNQD1HVT sdo_r_reg_1_ (.D ( sdo_rx_1_ ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet213 ) , .Q ( sdo[1] ) 
    , .CDN ( rst_bASThfnNet13 ) ) ;
DFCNQD1HVT sdo_r_reg_0_ (.D ( sdo_rx_0_ ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) , .Q ( sdo_r_0 ) 
    , .CDN ( rst_bASThfnNet11 ) ) ;
DFCNQD1HVT bs_state_reg_3_ (.D ( n3028 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet45 ) , .Q ( bs_state_3_ ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
DFCNQD1HVT bs_state_reg_2_ (.D ( n3027 ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) , .Q ( bs_state_2_ ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
DFCNQD1HVT bs_state_reg_1_ (.D ( n3026 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet45 ) , .Q ( bs_state_1_ ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
DFSND1HVT spi_rd_cmdaddr_reg_reg_27_ (.D ( n3087 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) , .Q ( spi_rd_cmdaddr_27 ) 
    , .SDN ( rst_bASThfnNet11 ) ) ;
DFSND1HVT spi_rd_cmdaddr_reg_reg_25_ (.D ( n3088 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) , .Q ( spi_rd_cmdaddr_25 ) 
    , .SDN ( rst_bASThfnNet11 ) ) ;
DFCNQD1HVT bram_rd_reg (.D ( bram_rd482 ) , .CP ( clk_b_G5B1I1ASTHIRNet204 ) 
    , .Q ( bram_rd ) , .CDN ( rst_bASThfnNet12 ) ) ;
DFCNQD1HVT cram_rd_reg (.D ( cram_rd470 ) , .CP ( clk_b_G5B1I3ASTHIRNet299 ) 
    , .Q ( cram_rd ) , .CDN ( rst_bASThfnNet13 ) ) ;
DFCNQD1HVT sdi_d1_reg (.D ( sdi ) , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) 
    , .Q ( sdi_d1 ) , .CDN ( rst_bASThfnNet11 ) ) ;
DFCNQD1HVT sdo_r_reg_7_ (.D ( sdo_rx_7_ ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet180 ) , .Q ( sdo[7] ) 
    , .CDN ( rst_bASThfnNet12 ) ) ;
DFCNQD1HVT sdo_r_reg_6_ (.D ( sdo_rx_6_ ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet180 ) , .Q ( sdo[6] ) 
    , .CDN ( rst_bASThfnNet12 ) ) ;
DFCNQD1HVT sdo_r_reg_5_ (.D ( sdo_rx_5_ ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet180 ) , .Q ( sdo[5] ) 
    , .CDN ( rst_bASThfnNet12 ) ) ;
DFCNQD1HVT sdo_r_reg_4_ (.D ( sdo_rx_4_ ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet180 ) , .Q ( sdo[4] ) 
    , .CDN ( rst_bASThfnNet12 ) ) ;
DFCNQD1HVT sdo_r_reg_3_ (.D ( sdo_rx_3_ ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet124 ) , .Q ( sdo[3] ) 
    , .CDN ( rst_bASThfnNet12 ) ) ;
DFCNQD1HVT cm_smc_sdo_en_int_d1_reg (.D ( n3018 ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) , .Q ( cm_smc_sdo_en_int_d1 ) 
    , .CDN ( rst_bASThfnNet16 ) ) ;
DFCNQD1HVT bm_smc_sdo_en_int_d3_reg (.D ( bm_smc_sdo_en_int_d2 ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) , .Q ( bm_smc_sdo_en_int_d3 ) 
    , .CDN ( rst_bASThfnNet16 ) ) ;
DFCNQD1HVT startup_req_reg (.D ( startup_req1213 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet45 ) , .Q ( startup_req ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
DFCNQD1HVT bm_smc_sdo_en_int_d2_reg (.D ( bm_smc_sdo_en_int_d1 ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) , .Q ( bm_smc_sdo_en_int_d2 ) 
    , .CDN ( rst_bASThfnNet16 ) ) ;
DFCNQD1HVT bram_wrt_reg (.D ( bram_wrt476 ) , .CP ( clk_b_G5B1I1ASTHIRNet204 ) 
    , .Q ( bram_wrt ) , .CDN ( rst_bASThfnNet12 ) ) ;
DFCNQD1HVT md_jtag_r_reg (.D ( md_jtag ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet227 ) , .Q ( md_jtag_r ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
DFCNQD1HVT cm_smc_sdo_en_int_d2_reg (.D ( cm_smc_sdo_en_int_d1 ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) , .Q ( cm_smc_sdo_en_int_d2 ) 
    , .CDN ( rst_bASThfnNet16 ) ) ;
DFCNQD1HVT cm_smc_sdo_en_int_d4_reg (.D ( cm_smc_sdo_en_int_d3 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , .Q ( cm_smc_sdo_en ) 
    , .CDN ( rst_bASThfnNet16 ) ) ;
LHCNQD1HVT warmboot_int_reg (.D ( boot ) , .CDN ( rst_bASThfnNet15 ) 
    , .E ( fpga_operation ) , .Q ( warmboot_int ) ) ;
DFCNQD1HVT cm_smc_sdo_en_int_d3_reg (.D ( cm_smc_sdo_en_int_d2 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , .Q ( cm_smc_sdo_en_int_d3 ) 
    , .CDN ( rst_bASThfnNet16 ) ) ;
DFCNQD1HVT shutdown_req_reg (.D ( n3014 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet45 ) , .Q ( shutdown_req ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
DFCNQD1HVT smc_podt_rst_reg (.D ( smc_podt_rst1105 ) 
    , .CP ( spi_clk_out_GB_G4B2I2ASTHIRNet139 ) , .Q ( n3224 ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
DFCNQD1HVT bm_smc_sdo_en_int_d4_reg (.D ( bm_smc_sdo_en_int_d3 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , .Q ( bm_smc_sdo_en ) 
    , .CDN ( rst_bASThfnNet16 ) ) ;
DFCNQD1HVT cram_wrt_reg (.D ( cram_wrt464 ) , .CP ( clk_b_G5B1I1ASTHIRNet204 ) 
    , .Q ( n3227 ) , .CDN ( rst_bASThfnNet12 ) ) ;
DFCNQD1HVT bm_smc_sdo_en_int_d1_reg (.D ( bm_smc_sdo_en_int ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) , .Q ( bm_smc_sdo_en_int_d1 ) 
    , .CDN ( rst_bASThfnNet16 ) ) ;
DFCNQD1HVT bs_smc_sdo_en_reg_reg (.D ( bs_smc_sdo_en ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) , .Q ( bs_smc_sdo_en_reg ) 
    , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT framenum_reg_0_ (.E ( n_1442 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet234 ) , .D ( cmdcode_byte_0 ) 
    , .Q ( framenum[0] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT start_framenum_reg_8_ (.E ( n_1570 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet213 ) , .D ( sio_data_reg_8 ) 
    , .Q ( start_framenum[8] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT spi_rxpreamble_trycnt_reg_2_ (.E ( n975_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I4ASTHIRNet243 ) 
    , .D ( spi_rxpreamble_trycnt974_2 ) , .Q ( spi_rxpreamble_trycnt_2_ ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT spi_rxpreamble_trycnt_reg_1_ (.E ( n975_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I4ASTHIRNet243 ) 
    , .D ( spi_rxpreamble_trycnt974_1 ) , .Q ( spi_rxpreamble_trycnt_1_ ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT spi_rxpreamble_trycnt_reg_0_ (.E ( n975_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I4ASTHIRNet243 ) 
    , .D ( spi_rxpreamble_trycnt974_0 ) , .Q ( spi_rxpreamble_trycnt_0_ ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT spi_ldbstream_trycnt_reg_1_ (.E ( n3045 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet45 ) 
    , .D ( spi_ldbstream_trycnt1059_1 ) , .QN ( n2905 ) 
    , .Q ( spi_ldbstream_trycnt_1_ ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT framenum_reg_8_ (.E ( n_1442 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet73 ) , .D ( sio_data_reg_8 ) 
    , .Q ( framenum[8] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT framenum_reg_7_ (.E ( n_1442 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet234 ) , .D ( sio_data_reg_7 ) 
    , .Q ( framenum[7] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT start_framenum_reg_1_ (.E ( n_1570 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet53 ) , .D ( sio_data_reg_1 ) 
    , .Q ( start_framenum[1] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT start_framenum_reg_0_ (.E ( n_1570 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet213 ) , .D ( cmdcode_byte_0 ) 
    , .Q ( start_framenum[0] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT framenum_reg_6_ (.E ( n_1442 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet234 ) , .D ( sio_data_reg_6 ) 
    , .Q ( framenum[6] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT framenum_reg_5_ (.E ( n_1442 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet73 ) , .D ( sio_data_reg_5 ) 
    , .Q ( framenum[5] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT framenum_reg_4_ (.E ( n_1442 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet73 ) , .D ( sio_data_reg_4 ) 
    , .Q ( framenum[4] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT framenum_reg_3_ (.E ( n_1442 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet234 ) , .D ( sio_data_reg_3 ) 
    , .Q ( framenum[3] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT framenum_reg_2_ (.E ( n_1442 ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet180 ) , .D ( sio_data_reg_2 ) 
    , .Q ( framenum[2] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT framenum_reg_1_ (.E ( n_1442 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet234 ) , .D ( sio_data_reg_1 ) 
    , .Q ( framenum[1] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT framelen_reg_9_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet40 ) , .D ( sio_data_reg_9 ) 
    , .Q ( framelen[9] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT framelen_reg_8_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet180 ) , .D ( sio_data_reg_8 ) 
    , .Q ( framelen[8] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT start_framenum_reg_7_ (.E ( n_1570 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet213 ) , .D ( sio_data_reg_7 ) 
    , .Q ( start_framenum[7] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT start_framenum_reg_6_ (.E ( n_1570 ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet180 ) , .D ( sio_data_reg_6 ) 
    , .Q ( start_framenum[6] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT start_framenum_reg_5_ (.E ( n_1570 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet213 ) , .D ( sio_data_reg_5 ) 
    , .Q ( start_framenum[5] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT start_framenum_reg_4_ (.E ( n_1570 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet213 ) , .D ( sio_data_reg_4 ) 
    , .Q ( start_framenum[4] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT start_framenum_reg_3_ (.E ( n_1570 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet213 ) , .D ( sio_data_reg_3 ) 
    , .Q ( start_framenum[3] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT start_framenum_reg_2_ (.E ( n_1570 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet234 ) , .D ( sio_data_reg_2 ) 
    , .Q ( start_framenum[2] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT framelen_reg_1_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet234 ) , .D ( sio_data_reg_1 ) 
    , .Q ( framelen[1] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT framelen_reg_0_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet234 ) , .D ( cmdcode_byte_0 ) 
    , .Q ( framelen[0] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT framelen_reg_15_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet40 ) , .D ( sio_data_reg_15 ) 
    , .Q ( framelen[15] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT framelen_reg_14_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet154 ) , .D ( sio_data_reg_14 ) 
    , .Q ( framelen[14] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT framelen_reg_13_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I18ASTHIRNet154 ) , .D ( sio_data_reg_13 ) 
    , .Q ( framelen[13] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT framelen_reg_12_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet40 ) , .D ( sio_data_reg_12 ) 
    , .Q ( framelen[12] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT framelen_reg_11_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet124 ) , .D ( sio_data_reg_11 ) 
    , .Q ( framelen[11] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT framelen_reg_10_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I16ASTHIRNet40 ) , .D ( sio_data_reg_10 ) 
    , .Q ( framelen[10] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT usercode_reg_reg_29_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet288 ) , .D ( sio_data_reg_29 ) 
    , .Q ( usercode_reg[29] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_28_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet288 ) , .D ( sio_data_reg_28 ) 
    , .Q ( usercode_reg[28] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT framelen_reg_7_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet234 ) , .D ( sio_data_reg_7 ) 
    , .Q ( framelen[7] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT framelen_reg_6_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet180 ) , .D ( sio_data_reg_6 ) 
    , .Q ( framelen[6] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT framelen_reg_5_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet73 ) , .D ( sio_data_reg_5 ) 
    , .Q ( framelen[5] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT framelen_reg_4_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet73 ) , .D ( sio_data_reg_4 ) 
    , .Q ( framelen[4] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT framelen_reg_3_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I21ASTHIRNet180 ) , .D ( sio_data_reg_3 ) 
    , .Q ( framelen[3] ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT framelen_reg_2_ (.E ( n_1768 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet234 ) , .D ( sio_data_reg_2 ) 
    , .Q ( framelen[2] ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT usercode_reg_reg_21_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_21 ) 
    , .Q ( usercode_reg[21] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_20_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_20 ) 
    , .Q ( usercode_reg[20] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT baddr_reg_1_ (.E ( n_1854 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) , .D ( sio_data_reg_1 ) 
    , .Q ( baddr[1] ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT baddr_reg_0_ (.E ( n_1854 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) , .D ( cmdcode_byte_0 ) 
    , .QN ( n3047 ) , .Q ( n3226 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT oscfsel_reg_1_ (.E ( n_1970 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , .D ( sio_data_reg_1 ) 
    , .QN ( n3068 ) , .Q ( n3222 ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT oscfsel_reg_0_ (.E ( n_1970 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , .D ( cmdcode_byte_0 ) 
    , .QN ( n3066 ) , .Q ( n3223 ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT usercode_reg_reg_31_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) , .D ( sio_data_reg_31 ) 
    , .Q ( usercode_reg[31] ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT usercode_reg_reg_30_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet288 ) , .D ( sio_data_reg_30 ) 
    , .Q ( usercode_reg[30] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_13_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_13 ) 
    , .Q ( usercode_reg[13] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_12_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_12 ) 
    , .Q ( usercode_reg[12] ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT usercode_reg_reg_27_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet288 ) , .D ( sio_data_reg_27 ) 
    , .Q ( usercode_reg[27] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_26_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet288 ) , .D ( sio_data_reg_26 ) 
    , .Q ( usercode_reg[26] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_25_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet288 ) , .D ( sio_data_reg_25 ) 
    , .Q ( usercode_reg[25] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_24_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet288 ) , .D ( sio_data_reg_24 ) 
    , .Q ( usercode_reg[24] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_23_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I10ASTHIRNet288 ) , .D ( sio_data_reg_23 ) 
    , .Q ( usercode_reg[23] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_22_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_22 ) 
    , .Q ( usercode_reg[22] ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT usercode_reg_reg_5_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_5 ) 
    , .Q ( usercode_reg[5] ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT usercode_reg_reg_4_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_4 ) 
    , .Q ( usercode_reg[4] ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT usercode_reg_reg_19_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_19 ) 
    , .Q ( usercode_reg[19] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_18_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_18 ) 
    , .Q ( usercode_reg[18] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_17_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet261 ) , .D ( sio_data_reg_17 ) 
    , .Q ( usercode_reg[17] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_16_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet261 ) , .D ( sio_data_reg_16 ) 
    , .Q ( usercode_reg[16] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_15_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_15 ) 
    , .Q ( usercode_reg[15] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_14_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet261 ) , .D ( sio_data_reg_14 ) 
    , .Q ( usercode_reg[14] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_6_ (.E ( n3058 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_6 ) 
    , .Q ( spi_rd_cmdaddr_reg_6 ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT ctrlopt_reg5_3_ (.E ( n_3685 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_3 ) 
    , .QN ( n3096 ) , .Q ( cor_en_rdcrc ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT usercode_reg_reg_11_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_11 ) 
    , .Q ( usercode_reg[11] ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT usercode_reg_reg_10_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet261 ) , .D ( sio_data_reg_10 ) 
    , .Q ( usercode_reg[10] ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT usercode_reg_reg_9_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_9 ) 
    , .Q ( usercode_reg[9] ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT usercode_reg_reg_8_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet261 ) , .D ( sio_data_reg_8 ) 
    , .Q ( usercode_reg[8] ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT usercode_reg_reg_7_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_7 ) 
    , .Q ( usercode_reg[7] ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT usercode_reg_reg_6_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet183 ) , .D ( sio_data_reg_6 ) 
    , .Q ( usercode_reg[6] ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT idcode_err_reg (.E ( n_1880 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) , .D ( idcode_err1526 ) 
    , .Q ( idcode_err ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_14_ (.E ( n3059 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet114 ) , .D ( sio_data_reg_14 ) 
    , .Q ( spi_rd_cmdaddr_reg_14 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT usercode_reg_reg_3_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet114 ) , .D ( sio_data_reg_3 ) 
    , .Q ( usercode_reg[3] ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT usercode_reg_reg_2_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet183 ) , .D ( sio_data_reg_2 ) 
    , .Q ( usercode_reg[2] ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT usercode_reg_reg_1_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_1 ) 
    , .Q ( usercode_reg[1] ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT usercode_reg_reg_0_ (.E ( n3046 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet261 ) , .D ( cmdcode_byte_0 ) 
    , .Q ( usercode_reg[0] ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT ctrlopt_reg9_10_ (.E ( n_3685 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) , .D ( sio_data_reg_10 ) 
    , .QN ( n2891 ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT access_nvcm_reg_reg (.E ( n_5241 ) 
    , .CP ( clk_b_G5B1I2ASTHIRNet108 ) , .D ( n3021 ) , .Q ( access_nvcm_reg ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT testmode_reg_reg_4_ (.E ( n_5075 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , .D ( sio_data_reg_4 ) 
    , .Q ( tm_en_cram_blsr_test ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT ctrlopt_reg2_2_ (.E ( n_3685 ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) , .D ( sio_data_reg_2 ) 
    , .QN ( n3011 ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT ctrlopt_reg6_0_ (.E ( n3050 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet183 ) , .D ( cmdcode_byte_0 ) 
    , .Q ( cor_dis_flashpd ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_2_ (.E ( n3060 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) , .D ( sio_data_reg_2 ) 
    , .Q ( spi_rd_cmdaddr_reg_2 ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_0_ (.E ( n3058 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet114 ) , .D ( cmdcode_byte_0 ) 
    , .Q ( spi_rd_cmdaddr_reg_0 ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_9_ (.E ( n3058 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_9 ) 
    , .Q ( spi_rd_cmdaddr_reg_9 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_4_ (.E ( n3061 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_4 ) 
    , .Q ( spi_rd_cmdaddr_reg_4 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT ctrlopt_reg9_12_ (.E ( n_3685 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) , .D ( sio_data_reg_12 ) 
    , .QN ( n2892 ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT ctrlopt_reg7_4_ (.E ( n3050 ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) , .D ( sio_data_reg_4 ) 
    , .Q ( cor_en_coldboot ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT cmdreg_err_reg (.E ( n_1346 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , .D ( cmdreg_err1327 ) 
    , .QN ( n2962 ) , .Q ( cmdreg_err ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT testmode_reg_reg_0_ (.E ( n_5075 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet53 ) , .D ( cmdcode_byte_0 ) 
    , .Q ( tm_cram_monitor_cell_mask_0_ ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT stop_crc_reg (.E ( n_5219 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) , .D ( n2998 ) , .QN ( n3097 ) 
    , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_10_ (.E ( n3061 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) , .D ( sio_data_reg_10 ) 
    , .Q ( spi_rd_cmdaddr_reg_10 ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_23_ (.E ( n3061 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) , .D ( sio_data_reg_23 ) 
    , .QN ( n2989 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT ctrlopt_reg9_9_ (.E ( n_3685 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_9 ) 
    , .QN ( n2902 ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_19_ (.E ( n3060 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_19 ) 
    , .QN ( n2988 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_29_ (.E ( n3061 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet124 ) , .D ( sio_data_reg_29 ) 
    , .Q ( spi_rd_cmdaddr_29 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT testmode_reg_reg_7_ (.E ( n_5075 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , .D ( sio_data_reg_7 ) 
    , .Q ( tm_dis_bram_clk_gating ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_31_ (.E ( n3058 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) , .D ( sio_data_reg_31 ) 
    , .Q ( spi_rd_cmdaddr_31 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_28_ (.E ( n3058 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) , .D ( sio_data_reg_28 ) 
    , .Q ( spi_rd_cmdaddr_28 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT testmode_reg_reg_6_ (.E ( n3003 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet53 ) , .D ( sio_data_reg_6 ) 
    , .Q ( tm_dis_cram_clk_gating ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_12_ (.E ( n3060 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_12 ) 
    , .Q ( spi_rd_cmdaddr_reg_12 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_21_ (.E ( n3059 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet261 ) , .D ( sio_data_reg_21 ) 
    , .QN ( n2987 ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT ctrlopt_reg4_7_ (.E ( n3050 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) , .D ( n_2567 ) 
    , .Q ( cor_security_wrtdis ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_18_ (.E ( n3059 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_18 ) 
    , .Q ( spi_rd_cmdaddr_reg_18 ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_15_ (.E ( n3060 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet114 ) , .D ( sio_data_reg_15 ) 
    , .Q ( spi_rd_cmdaddr_reg_15 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT testmode_reg_reg_2_ (.E ( n_5075 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet53 ) , .D ( sio_data_reg_2 ) 
    , .Q ( tm_cram_monitor_cell_mask_2_ ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_16_ (.E ( n3058 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_16 ) 
    , .QN ( n2986 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT testmode_reg_reg_3_ (.E ( n_5075 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet53 ) , .D ( sio_data_reg_3 ) 
    , .Q ( tm_cram_monitor_cell_mask_3_ ) , .CDN ( rst_bASThfnNet12 ) ) ;
EDFCND1HVT spi_rxpreamble_trycnt_inc_reg (.E ( n3000 ) 
    , .CP ( spi_clk_out_GB_G4B2I2ASTHIRNet139 ) , .D ( n3019 ) , .QN ( n3165 ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_17_ (.E ( n3059 ) 
    , .CP ( spi_clk_out_GB_G4B2I7ASTHIRNet261 ) , .D ( sio_data_reg_17 ) 
    , .Q ( spi_rd_cmdaddr_reg_17 ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_30_ (.E ( n3061 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) , .D ( sio_data_reg_30 ) 
    , .Q ( spi_rd_cmdaddr_30 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT ctrlopt_reg8_5_ (.E ( n_3685 ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) , .D ( sio_data_reg_5 ) 
    , .Q ( cor_en_warmboot ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT ctrlopt_reg_1_ (.E ( n_3685 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet114 ) , .D ( sio_data_reg_1 ) 
    , .Q ( cor_en_oscclk ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT ctrlopt_reg10_6_ (.E ( n_3949 ) 
    , .CP ( spi_clk_out_GB_G4B2I8ASTHIRNet183 ) , .D ( n_3948 ) , .QN ( n3002 ) 
    , .Q ( cor_security_rddis ) , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_13_ (.E ( n3061 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet114 ) , .D ( sio_data_reg_13 ) 
    , .Q ( spi_rd_cmdaddr_reg_13 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_20_ (.E ( n3059 ) 
    , .CP ( spi_clk_out_GB_G4B2I14ASTHIRNet222 ) , .D ( sio_data_reg_20 ) 
    , .Q ( spi_rd_cmdaddr_reg_20 ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_22_ (.E ( n3061 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_22 ) 
    , .Q ( spi_rd_cmdaddr_reg_Q2111_22 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_11_ (.E ( n3060 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , .D ( sio_data_reg_11 ) 
    , .Q ( spi_rd_cmdaddr_reg_11 ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT testmode_reg_reg_5_ (.E ( n_5075 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , .D ( sio_data_reg_5 ) 
    , .QN ( n2894 ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_7_ (.E ( n3060 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) , .D ( sio_data_reg_7 ) 
    , .Q ( spi_rd_cmdaddr_reg_7 ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT crc_err_reg (.E ( n_5157 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) , .D ( n3041 ) , .Q ( crc_err ) 
    , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT testmode_reg_reg_8_ (.E ( n_5075 ) 
    , .CP ( spi_clk_out_GB_G4B2I6ASTHIRNet58 ) , .D ( sio_data_reg_8 ) 
    , .QN ( n3168 ) , .CDN ( rst_bASThfnNet15 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_26_ (.E ( n3058 ) 
    , .CP ( spi_clk_out_GB_G4B2I9ASTHIRNet84 ) , .D ( sio_data_reg_26 ) 
    , .Q ( spi_rd_cmdaddr_26 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT testmode_reg_reg_1_ (.E ( n_5075 ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet53 ) , .D ( sio_data_reg_1 ) 
    , .Q ( tm_cram_monitor_cell_mask_1_ ) , .CDN ( rst_bASThfnNet13 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_5_ (.E ( n3060 ) 
    , .CP ( spi_clk_out_GB_G4B2I11ASTHIRNet219 ) , .D ( sio_data_reg_5 ) 
    , .Q ( spi_rd_cmdaddr_reg_5 ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT cmdcode_err_reg (.E ( n_1324 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , .D ( cmdreg_err1327 ) 
    , .QN ( n2963 ) , .Q ( cmdcode_err ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_1_ (.E ( n3061 ) 
    , .CP ( spi_clk_out_GB_G4B2I12ASTHIRNet114 ) , .D ( sio_data_reg_1 ) 
    , .QN ( n2906 ) , .CDN ( rst_bASThfnNet11 ) ) ;
AO21D0HVT U1480 (.B ( n3023 ) , .A1 ( n3015 ) , .Z ( n3169 ) , .A2 ( n2916 ) ) ;
AO21D0HVT U1494 (.B ( n3209 ) , .A1 ( n2957 ) , .Z ( n3210 ) , .A2 ( n2958 ) ) ;
OA31D1HVT U1445 (.B ( n3097 ) , .A3 ( n3096 ) , .Z ( crc16_en ) 
    , .A1 ( cram_reading ) , .A2 ( bram_reading ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_8_ (.E ( n3059 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_8 ) 
    , .QN ( n2907 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT smc_podt_off_reg (.E ( n_875 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet45 ) , .D ( n2954 ) , .QN ( n3064 ) 
    , .CDN ( rst_bASThfnNet14 ) ) ;
EDFCND1HVT spi_rd_cmdaddr_reg_reg_3_ (.E ( n3059 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_3 ) 
    , .Q ( spi_rd_cmdaddr_reg_3 ) , .CDN ( rst_bASThfnNet11 ) ) ;
EDFCND1HVT ctrlopt_reg9_11_ (.E ( n_3685 ) 
    , .CP ( spi_clk_out_GB_G4B2I5ASTHIRNet170 ) , .D ( sio_data_reg_11 ) 
    , .QN ( n2901 ) , .CDN ( rst_bASThfnNet16 ) ) ;
EDFCND1HVT ctrlopt_reg3_8_ (.E ( n3050 ) 
    , .CP ( spi_clk_out_GB_G4B2I13ASTHIRNet301 ) , .D ( sio_data_reg_8 ) 
    , .QN ( n3091 ) , .Q ( cor_en_8bconfig ) , .CDN ( rst_bASThfnNet11 ) ) ;
AO211D0HVT U1500 (.Z ( n3181 ) , .A2 ( n3006 ) , .C ( n3216 ) 
    , .A1 ( spi_tx_done ) , .B ( n3170 ) ) ;
AO211D0HVT U1502 (.Z ( n3188 ) , .A2 ( n3174 ) , .C ( n3127 ) , .A1 ( n3020 ) 
    , .B ( n3029 ) ) ;
AO211D0HVT U1504 (.Z ( n3183 ) , .A2 ( n2914 ) , .C ( n3024 ) , .A1 ( n3042 ) 
    , .B ( n3169 ) ) ;
AO211D0HVT U1505 (.Z ( n3187 ) , .A2 ( n3135 ) , .C ( n3169 ) , .A1 ( n2959 ) 
    , .B ( n3022 ) ) ;
AO21D0HVT U1444 (.B ( n3037 ) , .A1 ( n3038 ) , .Z ( bs_smc_sdo_en ) 
    , .A2 ( n3092 ) ) ;
AO21D0HVT U1446 (.B ( n3037 ) , .A1 ( n3098 ) , .Z ( bs_smc_sdio_en ) 
    , .A2 ( n2992 ) ) ;
AO21D0HVT U1456 (.B ( n3010 ) , .A1 ( cmdreg_code_0_ ) , .Z ( n_1880 ) 
    , .A2 ( n3009 ) ) ;
AO21D0HVT U1463 (.B ( n3120 ) , .A1 ( n3024 ) , .Z ( cmdhead_cnt_ld ) 
    , .A2 ( n3119 ) ) ;
OR4D0HVT U1488 (.Z ( n3125 ) , .A2 ( n3204 ) , .A4 ( n3202 ) , .A3 ( n3201 ) 
    , .A1 ( n3203 ) ) ;
OR4D0HVT U1490 (.Z ( n3167 ) , .A2 ( n3015 ) , .A4 ( n2994 ) , .A3 ( n2996 ) 
    , .A1 ( n2999 ) ) ;
OR4D0HVT U1491 (.Z ( n3160 ) , .A2 ( sio_data_reg_13 ) , .A4 ( cmdcode_byte_0 ) 
    , .A3 ( sio_data_reg_9 ) , .A1 ( sio_data_reg_14 ) ) ;
OR4D0HVT U1492 (.Z ( n3161 ) , .A2 ( sio_data_reg_22 ) 
    , .A4 ( sio_data_reg_10 ) , .A3 ( sio_data_reg_7 ) , .A1 ( sio_data_reg_18 ) ) ;
OR4D0HVT U1448 (.Z ( bitstream_err ) , .A2 ( crc_err ) , .A4 ( n3100 ) 
    , .A3 ( n3099 ) , .A1 ( idcode_err ) ) ;
AO211D0HVT U1452 (.Z ( smc_podt_rst1105 ) , .A2 ( n3103 ) 
    , .C ( spi_master_go ) , .A1 ( cnt_podt_out ) , .B ( n3006 ) ) ;
AO211D0HVT U1475 (.Z ( n3152 ) , .A2 ( n2993 ) , .C ( n3005 ) , .A1 ( n2950 ) 
    , .B ( n3008 ) ) ;
AO211D0HVT U1499 (.Z ( n3179 ) , .A2 ( n3215 ) , .C ( n3033 ) , .A1 ( n2995 ) 
    , .B ( disable_flash_req ) ) ;
MUX4D0HVT U1129 (.I1 ( n2901 ) , .I0 ( n2902 ) , .I3 ( n2892 ) 
    , .S0 ( warmboot_sel_int_1_ ) , .Z ( n2900 ) , .S1 ( warmboot_sel_int_0_ ) 
    , .I2 ( n2891 ) ) ;
MUX4D0HVT U1175 (.I1 ( bm_bank_sdo[2] ) , .I0 ( bm_bank_sdo[0] ) 
    , .I3 ( bm_bank_sdo[3] ) , .S0 ( baddr[1] ) , .Z ( n3192 ) , .S1 ( n3226 ) 
    , .I2 ( bm_bank_sdo[1] ) ) ;
INR2D1HVT U1130 (.ZN ( n2911 ) , .A1 ( md_jtag_r ) , .B1 ( j_rst_b ) ) ;
OR4D0HVT U1495 (.Z ( n3184 ) , .A2 ( n3211 ) , .A4 ( n3210 ) , .A3 ( n3171 ) 
    , .A1 ( n3170 ) ) ;
OR4D0HVT U1468 (.Z ( n3137 ) , .A2 ( sio_data_reg_7 ) , .A4 ( sio_data_reg_5 ) 
    , .A3 ( sio_data_reg_6 ) , .A1 ( sio_data_reg_4 ) ) ;
OR4D0HVT U1481 (.Z ( n3178 ) , .A2 ( n3105 ) , .A4 ( n3136 ) 
    , .A3 ( cmdreg_code_2_ ) , .A1 ( n3145 ) ) ;
OR4D0HVT U1482 (.Z ( n3092 ) , .A2 ( n3180 ) , .A4 ( n3129 ) , .A3 ( n3181 ) 
    , .A1 ( n3179 ) ) ;
OR4D0HVT U1487 (.Z ( n3124 ) , .A2 ( n3200 ) , .A4 ( n3198 ) , .A3 ( n3197 ) 
    , .A1 ( n3199 ) ) ;
INR2D0HVT U1139 (.ZN ( n3039 ) , .A1 ( cfg_ld_bstream ) , .B1 ( bitstream_err ) ) ;
INR2D0HVT U1136 (.ZN ( n3029 ) , .A1 ( n2898 ) , .B1 ( cmdhead_cnt_0 ) ) ;
OAI32D2HVT U1131 (.ZN ( reboot_source_nvcm ) , .A3 ( n3149 ) , .B1 ( n2900 ) 
    , .A1 ( n3095 ) , .A2 ( n3168 ) , .B2 ( n3176 ) ) ;
AO31D0HVT U1459 (.B ( n3110 ) , .A1 ( coldboot_sel[0] ) 
    , .Z ( spi_rd_cmdaddr_7 ) , .A3 ( n3036 ) , .A2 ( coldboot_sel[1] ) ) ;
AO31D0HVT U1493 (.B ( n3101 ) , .A1 ( n2995 ) , .Z ( n3209 ) , .A3 ( n3116 ) 
    , .A2 ( n3007 ) ) ;
AO222D0HVT U1460 (.A2 ( n2909 ) , .C1 ( n3036 ) , .C2 ( n3112 ) 
    , .Z ( spi_rd_cmdaddr_6 ) , .B2 ( n3111 ) , .B1 ( warmboot_req ) 
    , .A1 ( spi_rd_cmdaddr_reg_6 ) ) ;
AO222D0HVT U1461 (.A2 ( n2909 ) , .C1 ( n3036 ) , .C2 ( n3114 ) 
    , .Z ( spi_rd_cmdaddr_5 ) , .B2 ( n3113 ) , .B1 ( warmboot_req ) 
    , .A1 ( spi_rd_cmdaddr_reg_5 ) ) ;
AO222D0HVT U1314 (.A1 ( n3016 ) , .Z ( n3120 ) , .C2 ( bram_done ) 
    , .B1 ( cram_done ) , .B2 ( n3101 ) , .C1 ( n3020 ) , .A2 ( n2903 ) ) ;
MUX2D0HVT U1343 (.I1 ( n3094 ) , .Z ( n3196 ) , .S ( n2992 ) , .I0 ( n3195 ) ) ;
MUX2D0HVT U1352 (.I1 ( n3194 ) , .Z ( sdo[0] ) , .S ( n3044 ) , .I0 ( sdo_r_0 ) ) ;
MUX2D0HVT U1132 (.I1 ( spi_rd_cmdaddr_27 ) , .Z ( n3087 ) , .S ( n3012 ) 
    , .I0 ( sio_data_reg_27 ) ) ;
MUX2D0HVT U1133 (.I1 ( spi_rd_cmdaddr_25 ) , .Z ( n3088 ) , .S ( n3012 ) 
    , .I0 ( sio_data_reg_25 ) ) ;
MUX2D0HVT U1316 (.I1 ( sdo[0] ) , .Z ( crc_data_in ) , .S ( cor_en_rdcrc ) 
    , .I0 ( sdi_d1 ) ) ;
MUX2D0HVT U1324 (.I1 ( sio_data_reg_24 ) , .Z ( n3089 ) , .S ( n3059 ) 
    , .I0 ( spi_rd_cmdaddr_24 ) ) ;
INR2D0HVT U1137 (.ZN ( n3030 ) , .A1 ( n2899 ) , .B1 ( n3153 ) ) ;
INR2D0HVT U1138 (.ZN ( n3031 ) , .A1 ( n2908 ) , .B1 ( n3153 ) ) ;
INR3D4HVT U1398 (.B2 ( n3105 ) , .A1 ( cmdreg_code_0_ ) , .ZN ( n_1442 ) 
    , .B1 ( n3104 ) ) ;
INR3D4HVT U1399 (.B2 ( cmdreg_code_0_ ) , .A1 ( cmdreg_code_3_ ) 
    , .ZN ( n_1570 ) , .B1 ( n3102 ) ) ;
INR3D4HVT U1413 (.B2 ( cmdreg_code_0_ ) , .A1 ( cmdreg_code_1_ ) 
    , .ZN ( n_1768 ) , .B1 ( n3104 ) ) ;
MUX2D0HVT U1331 (.I1 ( cm_sdo_u1[1] ) , .Z ( sdo_rx_3_ ) , .S ( cm_smc_sdo_en ) 
    , .I0 ( bm_bank_sdo[3] ) ) ;
MUX2D0HVT U1332 (.I1 ( cm_sdo_u1[0] ) , .Z ( sdo_rx_2_ ) , .S ( cm_smc_sdo_en ) 
    , .I0 ( bm_bank_sdo[2] ) ) ;
MUX2D0HVT U1333 (.I1 ( cm_sdo_u0[1] ) , .Z ( sdo_rx_1_ ) , .S ( cm_smc_sdo_en ) 
    , .I0 ( bm_bank_sdo[1] ) ) ;
MUX2D0HVT U1334 (.I1 ( n3189 ) , .Z ( sdo_rx_0_ ) , .S ( cor_en_8bconfig ) 
    , .I0 ( n3191 ) ) ;
MUX2D0HVT U1336 (.I1 ( cm_sdo_u0[0] ) , .Z ( n3189 ) , .S ( cm_smc_sdo_en ) 
    , .I0 ( bm_bank_sdo[0] ) ) ;
CKAN2D1HVT U1419 (.Z ( val2431_21 ) , .A1 ( spi_rd_cmdaddr_reg_20 ) 
    , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1420 (.Z ( spi_rd_cmdaddr_22 ) 
    , .A1 ( spi_rd_cmdaddr_reg_Q2111_22 ) , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1135 (.Z ( n3023 ) , .A1 ( n2994 ) , .A2 ( n2916 ) ) ;
CKAN2D1HVT U1158 (.Z ( n3035 ) , .A1 ( n2955 ) , .A2 ( n2897 ) ) ;
INR3D0HVT U1145 (.B2 ( n3115 ) , .A1 ( bs_state_1_ ) , .ZN ( n2956 ) 
    , .B1 ( n3155 ) ) ;
INR3D0HVT U1397 (.B2 ( cmdreg_code_3_ ) , .A1 ( cmdreg_code_0_ ) 
    , .ZN ( n_1854 ) , .B1 ( n3102 ) ) ;
INR3D0HVT U1439 (.B2 ( cmdreg_code_1_ ) , .A1 ( cmdreg_code_0_ ) 
    , .ZN ( n_1970 ) , .B1 ( n3104 ) ) ;
INR3D0HVT U1134 (.B2 ( cdone_in ) , .A1 ( cdone_out ) 
    , .ZN ( en_daisychain_cfg ) , .B1 ( n3011 ) ) ;
CKAN2D1HVT U1427 (.Z ( spi_rd_cmdaddr_2 ) , .A1 ( spi_rd_cmdaddr_reg_2 ) 
    , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1428 (.Z ( spi_rd_cmdaddr_4 ) , .A1 ( spi_rd_cmdaddr_reg_4 ) 
    , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1167 (.Z ( n3032 ) , .A1 ( n2916 ) , .A2 ( n2910 ) ) ;
CKAN2D1HVT U1238 (.Z ( n3022 ) , .A1 ( n2916 ) , .A2 ( n2999 ) ) ;
CKAN2D1HVT U1305 (.Z ( n3014 ) , .A1 ( fpga_operation ) , .A2 ( n3008 ) ) ;
CKAN2D1HVT U1327 (.Z ( sdo_rx_6_ ) , .A1 ( cm_sdo_u3[0] ) 
    , .A2 ( cm_smc_sdo_en ) ) ;
CKAN2D1HVT U1330 (.Z ( sdo_rx_4_ ) , .A1 ( cm_sdo_u2[0] ) 
    , .A2 ( cm_smc_sdo_en ) ) ;
CKAN2D1HVT U1337 (.Z ( spi_rxpreamble_trycnt974_1 ) 
    , .A1 ( spi_rxpreamble_trycnt976_1 ) , .A2 ( n3000 ) ) ;
CKAN2D1HVT U1432 (.Z ( spi_rd_cmdaddr_12 ) , .A1 ( spi_rd_cmdaddr_reg_12 ) 
    , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1433 (.Z ( spi_rd_cmdaddr_9 ) , .A1 ( spi_rd_cmdaddr_reg_9 ) 
    , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1421 (.Z ( spi_rd_cmdaddr_18 ) , .A1 ( spi_rd_cmdaddr_reg_18 ) 
    , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1422 (.Z ( spi_rd_cmdaddr_17 ) , .A1 ( spi_rd_cmdaddr_reg_17 ) 
    , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1423 (.Z ( spi_rd_cmdaddr_0 ) , .A1 ( spi_rd_cmdaddr_reg_0 ) 
    , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1424 (.Z ( spi_rd_cmdaddr_13 ) , .A1 ( spi_rd_cmdaddr_reg_13 ) 
    , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1425 (.Z ( spi_rd_cmdaddr_15 ) , .A1 ( spi_rd_cmdaddr_reg_15 ) 
    , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1426 (.Z ( spi_rd_cmdaddr_10 ) , .A1 ( spi_rd_cmdaddr_reg_10 ) 
    , .A2 ( n2909 ) ) ;
MAOI22D0HVT U1497 (.B1 ( spi_tx_done ) , .A2 ( n3154 ) , .A1 ( n2956 ) 
    , .B2 ( n3173 ) , .ZN ( n3213 ) ) ;
OA21D0HVT U1462 (.B ( n3005 ) , .A1 ( n3039 ) , .Z ( startup_req1213 ) 
    , .A2 ( n3116 ) ) ;
OA21D0HVT U1465 (.B ( n3128 ) , .A1 ( n3033 ) , .Z ( n3127 ) , .A2 ( n3101 ) ) ;
OA21D0HVT U1498 (.B ( n3007 ) , .A1 ( cfg_ld_bstream ) , .Z ( n3214 ) 
    , .A2 ( fpga_operation ) ) ;
OA211D0HVT U1464 (.Z ( idcode_err1526 ) , .C ( cmdreg_code_0_ ) , .B ( n3009 ) 
    , .A1 ( n3124 ) , .A2 ( n3125 ) ) ;
CKAN2D1HVT U1429 (.Z ( spi_rd_cmdaddr_3 ) , .A1 ( spi_rd_cmdaddr_reg_3 ) 
    , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1430 (.Z ( spi_rd_cmdaddr_11 ) , .A1 ( spi_rd_cmdaddr_reg_11 ) 
    , .A2 ( n2909 ) ) ;
CKAN2D1HVT U1431 (.Z ( spi_rd_cmdaddr_14 ) , .A1 ( spi_rd_cmdaddr_reg_14 ) 
    , .A2 ( n2909 ) ) ;
XNR2D0HVT U1196 (.A2 ( j_idcode_reg[11] ) , .ZN ( n2929 ) 
    , .A1 ( sio_data_reg_11 ) ) ;
XNR2D0HVT U1183 (.A2 ( j_idcode_reg[10] ) , .ZN ( n2918 ) 
    , .A1 ( sio_data_reg_10 ) ) ;
XNR2D0HVT U1184 (.A2 ( j_idcode_reg[17] ) , .ZN ( n2919 ) 
    , .A1 ( sio_data_reg_17 ) ) ;
XNR2D0HVT U1185 (.A2 ( j_idcode_reg[22] ) , .ZN ( n2920 ) 
    , .A1 ( sio_data_reg_22 ) ) ;
XNR2D0HVT U1186 (.A2 ( j_idcode_reg[5] ) , .ZN ( n2921 ) 
    , .A1 ( sio_data_reg_5 ) ) ;
AOI221D0HVT U1227 (.C ( n3152 ) , .ZN ( n2952 ) , .B2 ( n3099 ) , .A2 ( n2914 ) 
    , .A1 ( n3021 ) , .B1 ( n2897 ) ) ;
OAI21D1HVT U1282 (.A2 ( n3156 ) , .ZN ( bram_rd482 ) , .A1 ( n3159 ) 
    , .B ( n3172 ) ) ;
OAI21D0HVT U1307 (.A2 ( cmdreg_code_0_ ) , .ZN ( n_5157 ) , .A1 ( n3148 ) 
    , .B ( cmdreg_err1327 ) ) ;
XNR2D0HVT U1206 (.A2 ( j_idcode_reg[8] ) , .ZN ( n2937 ) 
    , .A1 ( sio_data_reg_8 ) ) ;
XNR2D0HVT U1188 (.A2 ( j_idcode_reg[4] ) , .ZN ( n2922 ) 
    , .A1 ( sio_data_reg_4 ) ) ;
XNR2D0HVT U1189 (.A2 ( j_idcode_reg[27] ) , .ZN ( n2923 ) 
    , .A1 ( sio_data_reg_27 ) ) ;
XNR2D0HVT U1190 (.A2 ( j_idcode_reg[12] ) , .ZN ( n2924 ) 
    , .A1 ( sio_data_reg_12 ) ) ;
XNR2D0HVT U1191 (.A2 ( j_idcode_reg[20] ) , .ZN ( n2925 ) 
    , .A1 ( sio_data_reg_20 ) ) ;
XNR2D0HVT U1193 (.A2 ( j_idcode_reg[28] ) , .ZN ( n2926 ) 
    , .A1 ( sio_data_reg_28 ) ) ;
XNR2D0HVT U1194 (.A2 ( j_idcode_reg[3] ) , .ZN ( n2927 ) 
    , .A1 ( sio_data_reg_3 ) ) ;
XNR2D0HVT U1195 (.A2 ( j_idcode_reg[19] ) , .ZN ( n2928 ) 
    , .A1 ( sio_data_reg_19 ) ) ;
XNR2D0HVT U1216 (.A2 ( j_idcode_reg[25] ) , .ZN ( n2945 ) 
    , .A1 ( sio_data_reg_25 ) ) ;
XNR2D0HVT U1198 (.A2 ( j_idcode_reg[21] ) , .ZN ( n2930 ) 
    , .A1 ( sio_data_reg_21 ) ) ;
XNR2D0HVT U1199 (.A2 ( j_idcode_reg[18] ) , .ZN ( n2931 ) 
    , .A1 ( sio_data_reg_18 ) ) ;
XNR2D0HVT U1200 (.A2 ( j_idcode_reg[9] ) , .ZN ( n2932 ) 
    , .A1 ( sio_data_reg_9 ) ) ;
XNR2D0HVT U1201 (.A2 ( j_idcode_reg[6] ) , .ZN ( n2933 ) 
    , .A1 ( sio_data_reg_6 ) ) ;
XNR2D0HVT U1203 (.A2 ( j_idcode_reg[16] ) , .ZN ( n2934 ) 
    , .A1 ( sio_data_reg_16 ) ) ;
XNR2D0HVT U1204 (.A2 ( j_idcode_reg[31] ) , .ZN ( n2935 ) 
    , .A1 ( sio_data_reg_31 ) ) ;
XNR2D0HVT U1205 (.A2 ( j_idcode_reg[23] ) , .ZN ( n2936 ) 
    , .A1 ( sio_data_reg_23 ) ) ;
XNR2D0HVT U1253 (.A2 ( sio_data_reg_3 ) , .ZN ( n2973 ) , .A1 ( crc_reg_3_ ) ) ;
XNR2D0HVT U1208 (.A2 ( j_idcode_reg[1] ) , .ZN ( n2938 ) 
    , .A1 ( sio_data_reg_1 ) ) ;
XNR2D0HVT U1209 (.A2 ( j_idcode_reg[26] ) , .ZN ( n2939 ) 
    , .A1 ( sio_data_reg_26 ) ) ;
XNR2D0HVT U1210 (.A2 ( j_idcode_reg[13] ) , .ZN ( n2940 ) 
    , .A1 ( sio_data_reg_13 ) ) ;
XNR2D0HVT U1211 (.A2 ( j_idcode_reg[29] ) , .ZN ( n2941 ) 
    , .A1 ( sio_data_reg_29 ) ) ;
XNR2D0HVT U1213 (.A2 ( j_idcode_reg[2] ) , .ZN ( n2942 ) 
    , .A1 ( sio_data_reg_2 ) ) ;
XNR2D0HVT U1214 (.A2 ( j_idcode_reg[30] ) , .ZN ( n2943 ) 
    , .A1 ( sio_data_reg_30 ) ) ;
XNR2D0HVT U1215 (.A2 ( j_idcode_reg[14] ) , .ZN ( n2944 ) 
    , .A1 ( sio_data_reg_14 ) ) ;
XNR2D0HVT U1263 (.A2 ( sio_data_reg_4 ) , .ZN ( n2981 ) , .A1 ( crc_reg_4_ ) ) ;
XNR2D0HVT U1218 (.A2 ( j_idcode_reg[15] ) , .ZN ( n2946 ) 
    , .A1 ( sio_data_reg_15 ) ) ;
XNR2D0HVT U1219 (.A2 ( j_idcode_reg[0] ) , .ZN ( n2947 ) 
    , .A1 ( cmdcode_byte_0 ) ) ;
XNR2D0HVT U1220 (.A2 ( j_idcode_reg[7] ) , .ZN ( n2948 ) 
    , .A1 ( sio_data_reg_7 ) ) ;
XNR2D0HVT U1221 (.A2 ( j_idcode_reg[24] ) , .ZN ( n2949 ) 
    , .A1 ( sio_data_reg_24 ) ) ;
XNR2D0HVT U1250 (.A2 ( sio_data_reg_8 ) , .ZN ( n2970 ) , .A1 ( crc_reg_8_ ) ) ;
XNR2D0HVT U1251 (.A2 ( sio_data_reg_1 ) , .ZN ( n2971 ) , .A1 ( crc_reg_1_ ) ) ;
XNR2D0HVT U1252 (.A2 ( sio_data_reg_15 ) , .ZN ( n2972 ) , .A1 ( crc_reg_15_ ) ) ;
XNR2D0HVT U1274 (.A2 ( spi_rxpreamble_trycnt_2_ ) , .ZN ( n2990 ) 
    , .A1 ( add_735_carry_2 ) ) ;
XNR2D0HVT U1255 (.A2 ( sio_data_reg_14 ) , .ZN ( n2974 ) , .A1 ( crc_reg_14_ ) ) ;
XNR2D0HVT U1256 (.A2 ( sio_data_reg_2 ) , .ZN ( n2975 ) , .A1 ( crc_reg_2_ ) ) ;
XNR2D0HVT U1257 (.A2 ( sio_data_reg_9 ) , .ZN ( n2976 ) , .A1 ( crc_reg_9_ ) ) ;
XNR2D0HVT U1258 (.A2 ( cmdcode_byte_0 ) , .ZN ( n2977 ) , .A1 ( crc_reg_0_ ) ) ;
XNR2D0HVT U1260 (.A2 ( sio_data_reg_7 ) , .ZN ( n2978 ) , .A1 ( crc_reg_7_ ) ) ;
XNR2D0HVT U1261 (.A2 ( sio_data_reg_10 ) , .ZN ( n2979 ) , .A1 ( crc_reg_10_ ) ) ;
XNR2D0HVT U1262 (.A2 ( sio_data_reg_12 ) , .ZN ( n2980 ) , .A1 ( crc_reg_12_ ) ) ;
OR3D0HVT U1476 (.A1 ( sio_data_reg_2 ) , .A2 ( n3123 ) , .Z ( n3109 ) 
    , .A3 ( n3139 ) ) ;
AO22D0HVT U1313 (.B1 ( tm_cram_monitor_cell_mask_3_ ) 
    , .B2 ( cm_monitor_cell[3] ) , .Z ( n3143 ) 
    , .A1 ( tm_cram_monitor_cell_mask_0_ ) , .A2 ( cm_monitor_cell[0] ) ) ;
OAI31D0HVT U1287 (.A2 ( n2997 ) , .A1 ( n3105 ) , .ZN ( n_5219 ) 
    , .A3 ( cmdhead_cnt_0 ) , .B ( n2998 ) ) ;
IND3D0HVT U1288 (.B2 ( n3145 ) , .A1 ( cmdreg_code_0_ ) , .ZN ( n2997 ) 
    , .B1 ( n3146 ) ) ;
XNR2D0HVT U1265 (.A2 ( sio_data_reg_13 ) , .ZN ( n2982 ) , .A1 ( crc_reg_13_ ) ) ;
XNR2D0HVT U1266 (.A2 ( sio_data_reg_5 ) , .ZN ( n2983 ) , .A1 ( crc_reg_5_ ) ) ;
XNR2D0HVT U1267 (.A2 ( sio_data_reg_11 ) , .ZN ( n2984 ) , .A1 ( crc_reg_11_ ) ) ;
XNR2D0HVT U1268 (.A2 ( sio_data_reg_6 ) , .ZN ( n2985 ) , .A1 ( crc_reg_6_ ) ) ;
OR3D0HVT U1312 (.A3 ( n3104 ) , .Z ( n3012 ) , .A2 ( cmdreg_code_1_ ) 
    , .A1 ( cmdreg_code_0_ ) ) ;
OR3D0HVT U1338 (.A3 ( n3136 ) , .Z ( n3104 ) , .A2 ( cmdreg_code_3_ ) 
    , .A1 ( n3146 ) ) ;
OR3D0HVT U1479 (.A1 ( n2899 ) , .A2 ( n2908 ) , .Z ( n3166 ) , .A3 ( n2910 ) ) ;
OR3D0HVT U1483 (.A1 ( j_cfg_disable ) , .A2 ( j_cfg_enable ) , .Z ( n3185 ) 
    , .A3 ( n2911 ) ) ;
OR3D0HVT U1503 (.A1 ( n3107 ) , .A2 ( n3145 ) , .Z ( n3219 ) , .A3 ( n3102 ) ) ;
OR3D0HVT U1467 (.A1 ( n3134 ) , .A2 ( cmdhead_cnt_0 ) , .Z ( n3136 ) 
    , .A3 ( n3135 ) ) ;
OR3D0HVT U1471 (.A1 ( n3123 ) , .A2 ( n3122 ) , .Z ( n3118 ) , .A3 ( n3139 ) ) ;
OR3D0HVT U1473 (.A1 ( cmdcode_byte_0 ) , .A2 ( n3122 ) , .Z ( n3142 ) 
    , .A3 ( n3139 ) ) ;
endmodule




module startup_shutdown (warmboot_req , cdone_in , end_of_shutdown , 
    cdone_out , spi_clk_out_GB_G4B2I3ASTHIRNet49 , clk , rst_b , 
    startup_req , shutdown_req , cor_en_oscclk , 
    spi_clk_out_GB_G4B2I1ASTHIRNet229 , spi_clk_out_GB_G4B2I2ASTHIRNet135 , 
    smc_oscoff_b , gint_hz , gio_hz , gwe , gsr , end_of_startup );
input  warmboot_req ;
input  cdone_in ;
output end_of_shutdown ;
output cdone_out ;
input  spi_clk_out_GB_G4B2I3ASTHIRNet49 ;
input  clk ;
input  rst_b ;
input  startup_req ;
input  shutdown_req ;
input  cor_en_oscclk ;
input  spi_clk_out_GB_G4B2I1ASTHIRNet229 ;
input  spi_clk_out_GB_G4B2I2ASTHIRNet135 ;
output smc_oscoff_b ;
output gint_hz ;
output gio_hz ;
output gwe ;
output gsr ;
output end_of_startup ;

/* wire declarations */

wire n493 ;
wire n501 ;
wire n500 ;
wire n503 ;
wire n474 ;
wire n472 ;
wire n471 ;
wire seqcnt160_0 ;
wire n498 ;
wire n480 ;
wire n478 ;
wire n476 ;
wire n510 ;
wire n482 ;
wire n481 ;
wire state_0_ ;
wire n477 ;
wire n504 ;
wire smc_oscoff_b_int1 ;
wire n473 ;
wire next_2_ ;
wire next_1_ ;
wire n508 ;
wire n502 ;
wire n486 ;
wire n489 ;
wire n491 ;
wire n514 ;
wire n475 ;
wire state_1_ ;
wire state_2_ ;
wire n497 ;
wire n495 ;
wire n485 ;
wire n511 ;
wire n512 ;
wire n496 ;
wire n479 ;
wire next_0_ ;
wire n505 ;
wire seqcnt_1 ;
wire seqcnt_0 ;
wire seqcnt158_1 ;
wire n159_0 ;
wire seqcnt158_0 ;
wire smc_oscoff_b_int ;
wire n515 ;
wire ginthz_int261 ;
wire n516 ;
wire giohz_int267 ;
wire smc_oscoff_b_int377 ;
wire n483 ;
wire n484 ;
wire seqcnt160_3 ;
wire n518 ;
wire n517 ;
wire seqcnt158_3 ;
wire seqcnt158_2 ;
wire cdone_out_int279 ;
wire gwe_int273 ;
wire seqcnt160_2 ;
wire n506 ;
wire n513 ;
wire n507 ;
wire n509 ;

CKND8HVT U184 (.I ( n493 ) , .ZN ( gsr ) ) ;
CKND6HVT U179 (.I ( n493 ) , .ZN ( gio_hz ) ) ;
OAI31D1HVT U152 (.A2 ( n501 ) , .A1 ( n500 ) , .ZN ( n503 ) , .A3 ( n474 ) 
    , .B ( n472 ) ) ;
CKAN2D1HVT U148 (.Z ( n471 ) , .A1 ( seqcnt160_0 ) , .A2 ( n498 ) ) ;
CKAN2D1HVT U154 (.Z ( n480 ) , .A1 ( n478 ) , .A2 ( n476 ) ) ;
AOI21D0HVT U149 (.A2 ( n510 ) , .ZN ( n472 ) , .A1 ( n482 ) , .B ( n481 ) ) ;
AOI21D0HVT U162 (.A2 ( state_0_ ) , .ZN ( n477 ) , .A1 ( n482 ) , .B ( n504 ) ) ;
NR2D0HVT U150 (.A1 ( smc_oscoff_b_int1 ) , .A2 ( warmboot_req ) , .ZN ( n473 ) ) ;
NR2D0HVT U155 (.A1 ( shutdown_req ) , .A2 ( warmboot_req ) , .ZN ( n474 ) ) ;
NR2D0HVT U160 (.A1 ( next_2_ ) , .A2 ( next_1_ ) , .ZN ( n476 ) ) ;
NR2D0HVT U173 (.A1 ( n508 ) , .A2 ( n502 ) , .ZN ( n482 ) ) ;
CKND8HVT U151 (.I ( n473 ) , .ZN ( smc_oscoff_b ) ) ;
CKND8HVT U178 (.I ( n486 ) , .ZN ( gint_hz ) ) ;
CKND8HVT U181 (.I ( n489 ) , .ZN ( cdone_out ) ) ;
CKND8HVT U183 (.I ( n491 ) , .ZN ( end_of_startup ) ) ;
ND2D0HVT U156 (.ZN ( n514 ) , .A1 ( n501 ) , .A2 ( n475 ) ) ;
ND2D0HVT U158 (.ZN ( n501 ) , .A1 ( state_1_ ) , .A2 ( state_2_ ) ) ;
ND2D0HVT U166 (.ZN ( n497 ) , .A1 ( n471 ) , .A2 ( n495 ) ) ;
MUX2ND0HVT U157 (.ZN ( n475 ) , .I0 ( n502 ) , .S ( n485 ) , .I1 ( n511 ) ) ;
MUX2ND0HVT U164 (.ZN ( n478 ) , .I0 ( n512 ) , .S ( state_0_ ) , .I1 ( n514 ) ) ;
ND4D1HVT U159 (.A2 ( n495 ) , .A3 ( n496 ) , .A4 ( seqcnt160_0 ) , .ZN ( n502 ) 
    , .A1 ( n498 ) ) ;
AN3D0HVT U161 (.Z ( n479 ) , .A2 ( next_0_ ) , .A1 ( next_2_ ) , .A3 ( next_1_ ) ) ;
NR2D0HVT U176 (.A1 ( state_1_ ) , .A2 ( state_2_ ) , .ZN ( n485 ) ) ;
CKND0HVT U163 (.I ( n477 ) , .ZN ( next_2_ ) ) ;
CKND0HVT U165 (.I ( n478 ) , .ZN ( next_0_ ) ) ;
CKND0HVT U167 (.I ( cdone_in ) , .ZN ( n511 ) ) ;
CKND0HVT U168 (.I ( n501 ) , .ZN ( n505 ) ) ;
CKND0HVT U169 (.I ( state_2_ ) , .ZN ( n510 ) ) ;
CKND0HVT U170 (.I ( state_1_ ) , .ZN ( n508 ) ) ;
CKND0HVT U171 (.I ( state_0_ ) , .ZN ( n500 ) ) ;
AO221D0HVT U153 (.B1 ( seqcnt160_0 ) , .B2 ( n498 ) , .C ( n503 ) 
    , .A2 ( seqcnt_1 ) , .A1 ( seqcnt_0 ) , .Z ( seqcnt158_1 ) ) ;
EDFCND1HVT seqcnt_reg_0_ (.E ( n159_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I2ASTHIRNet135 ) , .D ( seqcnt158_0 ) 
    , .QN ( seqcnt160_0 ) , .Q ( seqcnt_0 ) , .CDN ( rst_b ) ) ;
DFSNQD1HVT smc_oscoff_b_int1_reg (.SDN ( rst_b ) , .Q ( smc_oscoff_b_int1 ) 
    , .CP ( spi_clk_out_GB_G4B2I3ASTHIRNet49 ) , .D ( smc_oscoff_b_int ) ) ;
DFSNQD1HVT ginthz_int_reg (.SDN ( rst_b ) , .Q ( n515 ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet229 ) , .D ( ginthz_int261 ) ) ;
DFSNQD1HVT giohz_int_reg (.SDN ( rst_b ) , .Q ( n516 ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet229 ) , .D ( giohz_int267 ) ) ;
DFSNQD1HVT smc_oscoff_b_int_reg (.SDN ( rst_b ) , .Q ( smc_oscoff_b_int ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet229 ) , .D ( smc_oscoff_b_int377 ) ) ;
NR4D0HVT U172 (.A2 ( state_1_ ) , .A3 ( n500 ) , .A4 ( n511 ) , .A1 ( state_2_ ) 
    , .ZN ( n481 ) ) ;
NR3D0HVT U174 (.A1 ( state_1_ ) , .ZN ( n483 ) , .A2 ( n510 ) , .A3 ( n502 ) ) ;
NR3D0HVT U175 (.A1 ( next_0_ ) , .ZN ( n484 ) , .A2 ( n477 ) , .A3 ( next_1_ ) ) ;
CKXOR2D0HVT U187 (.Z ( seqcnt160_3 ) , .A2 ( n496 ) , .A1 ( n497 ) ) ;
INVD0HVT U180 (.ZN ( n489 ) , .I ( n518 ) ) ;
INVD0HVT U182 (.ZN ( n491 ) , .I ( n517 ) ) ;
INVD0HVT U177 (.I ( n515 ) , .ZN ( n486 ) ) ;
INVD0HVT U185 (.I ( n516 ) , .ZN ( n493 ) ) ;
EDFCND1HVT seqcnt_reg_3_ (.E ( n159_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I2ASTHIRNet135 ) , .D ( seqcnt158_3 ) 
    , .QN ( n496 ) , .CDN ( rst_b ) ) ;
EDFCND1HVT seqcnt_reg_2_ (.E ( n159_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I2ASTHIRNet135 ) , .D ( seqcnt158_2 ) 
    , .QN ( n495 ) , .CDN ( rst_b ) ) ;
EDFCND1HVT seqcnt_reg_1_ (.E ( n159_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I2ASTHIRNet135 ) , .D ( seqcnt158_1 ) 
    , .QN ( n498 ) , .Q ( seqcnt_1 ) , .CDN ( rst_b ) ) ;
DFCNQD1HVT state_reg_0_ (.D ( next_0_ ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet229 ) , .Q ( state_0_ ) , .CDN ( rst_b ) ) ;
DFCNQD1HVT end_of_shutdown_reg (.D ( n480 ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet229 ) , .Q ( end_of_shutdown ) 
    , .CDN ( rst_b ) ) ;
DFCNQD1HVT cdone_out_int_reg (.D ( cdone_out_int279 ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet229 ) , .Q ( n518 ) , .CDN ( rst_b ) ) ;
DFCNQD1HVT gwe_int_reg (.D ( gwe_int273 ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet229 ) , .Q ( gwe ) , .CDN ( rst_b ) ) ;
DFCNQD1HVT end_of_startup_reg (.D ( n479 ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet229 ) , .Q ( n517 ) , .CDN ( rst_b ) ) ;
DFCNQD1HVT state_reg_2_ (.D ( next_2_ ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet229 ) , .Q ( state_2_ ) , .CDN ( rst_b ) ) ;
DFCNQD1HVT state_reg_1_ (.D ( next_1_ ) 
    , .CP ( spi_clk_out_GB_G4B2I1ASTHIRNet229 ) , .Q ( state_1_ ) , .CDN ( rst_b ) ) ;
XNR2D0HVT U186 (.A2 ( n495 ) , .ZN ( seqcnt160_2 ) , .A1 ( n471 ) ) ;
OR3D0HVT U188 (.A1 ( cor_en_oscclk ) , .A2 ( n500 ) 
    , .Z ( smc_oscoff_b_int377 ) , .A3 ( n501 ) ) ;
OR2D0HVT U189 (.A2 ( n503 ) , .A1 ( n502 ) , .Z ( n159_0 ) ) ;
OR2D0HVT U193 (.A2 ( n479 ) , .A1 ( n484 ) , .Z ( gwe_int273 ) ) ;
OR2D0HVT U195 (.A2 ( n503 ) , .A1 ( seqcnt160_3 ) , .Z ( seqcnt158_3 ) ) ;
OR2D0HVT U196 (.A2 ( n503 ) , .A1 ( seqcnt160_2 ) , .Z ( seqcnt158_2 ) ) ;
OR2D0HVT U197 (.A2 ( n503 ) , .A1 ( seqcnt160_0 ) , .Z ( seqcnt158_0 ) ) ;
AO31D0HVT U190 (.B ( n476 ) , .A1 ( n478 ) , .Z ( ginthz_int261 ) 
    , .A3 ( next_1_ ) , .A2 ( next_2_ ) ) ;
AO31D0HVT U191 (.B ( n506 ) , .A1 ( state_0_ ) , .Z ( next_1_ ) , .A3 ( n474 ) 
    , .A2 ( n505 ) ) ;
AO21D0HVT U192 (.B ( n476 ) , .A1 ( n478 ) , .Z ( giohz_int267 ) 
    , .A2 ( next_1_ ) ) ;
AO21D0HVT U201 (.B ( n483 ) , .A1 ( n513 ) , .Z ( n512 ) , .A2 ( n510 ) ) ;
AO21D0HVT U203 (.B ( n482 ) , .A1 ( startup_req ) , .Z ( n513 ) , .A2 ( n508 ) ) ;
AO211D0HVT U194 (.Z ( cdone_out_int279 ) , .A2 ( next_1_ ) , .C ( n507 ) 
    , .A1 ( next_0_ ) , .B ( n484 ) ) ;
OA21D0HVT U198 (.B ( state_2_ ) , .A1 ( state_0_ ) , .Z ( n504 ) , .A2 ( n508 ) ) ;
OA21D0HVT U200 (.B ( n477 ) , .A1 ( next_1_ ) , .Z ( n507 ) , .A2 ( next_0_ ) ) ;
OA211D0HVT U199 (.Z ( n509 ) , .C ( n510 ) , .B ( state_1_ ) , .A1 ( n500 ) 
    , .A2 ( n502 ) ) ;
OR3D0HVT U202 (.A1 ( n509 ) , .A2 ( n483 ) , .Z ( n506 ) , .A3 ( n481 ) ) ;
endmodule




module cram_smc_DW01_dec_16_0 (A , SUM );
input  [15:0] A ;
output [15:0] SUM ;

/* wire declarations */

wire carry_11 ;
wire carry_12 ;
wire carry_2 ;
wire carry_3 ;
wire carry_5 ;
wire carry_6 ;
wire carry_10 ;
wire carry_7 ;
wire carry_8 ;
wire carry_13 ;
wire carry_14 ;
wire carry_15 ;
wire carry_9 ;
wire carry_4 ;

OR2D0HVT U1_B_11 (.A2 ( carry_11 ) , .A1 ( A[11] ) , .Z ( carry_12 ) ) ;
OR2D0HVT U1_B_2 (.A2 ( carry_2 ) , .A1 ( A[2] ) , .Z ( carry_3 ) ) ;
OR2D0HVT U1_B_5 (.A2 ( carry_5 ) , .A1 ( A[5] ) , .Z ( carry_6 ) ) ;
OR2D0HVT U1_B_10 (.A2 ( carry_10 ) , .A1 ( A[10] ) , .Z ( carry_11 ) ) ;
OR2D0HVT U1_B_1 (.A2 ( A[0] ) , .A1 ( A[1] ) , .Z ( carry_2 ) ) ;
INVD0HVT U6 (.I ( A[0] ) , .ZN ( SUM[0] ) ) ;
OR2D0HVT U1_B_7 (.A2 ( carry_7 ) , .A1 ( A[7] ) , .Z ( carry_8 ) ) ;
OR2D0HVT U1_B_12 (.A2 ( carry_12 ) , .A1 ( A[12] ) , .Z ( carry_13 ) ) ;
OR2D0HVT U1_B_6 (.A2 ( carry_6 ) , .A1 ( A[6] ) , .Z ( carry_7 ) ) ;
OR2D0HVT U1_B_13 (.A2 ( carry_13 ) , .A1 ( A[13] ) , .Z ( carry_14 ) ) ;
OR2D0HVT U1_B_14 (.A2 ( carry_14 ) , .A1 ( A[14] ) , .Z ( carry_15 ) ) ;
OR2D0HVT U1_B_8 (.A2 ( carry_8 ) , .A1 ( A[8] ) , .Z ( carry_9 ) ) ;
OR2D0HVT U1_B_3 (.A2 ( carry_3 ) , .A1 ( A[3] ) , .Z ( carry_4 ) ) ;
OR2D0HVT U1_B_4 (.A2 ( carry_4 ) , .A1 ( A[4] ) , .Z ( carry_5 ) ) ;
XNR2D0HVT U1_A_14 (.A2 ( carry_14 ) , .ZN ( SUM[14] ) , .A1 ( A[14] ) ) ;
XNR2D0HVT U1_A_8 (.A2 ( carry_8 ) , .ZN ( SUM[8] ) , .A1 ( A[8] ) ) ;
XNR2D0HVT U1_A_15 (.A2 ( carry_15 ) , .ZN ( SUM[15] ) , .A1 ( A[15] ) ) ;
XNR2D0HVT U1_A_9 (.A2 ( carry_9 ) , .ZN ( SUM[9] ) , .A1 ( A[9] ) ) ;
XNR2D0HVT U1_A_7 (.A2 ( carry_7 ) , .ZN ( SUM[7] ) , .A1 ( A[7] ) ) ;
XNR2D0HVT U1_A_12 (.A2 ( carry_12 ) , .ZN ( SUM[12] ) , .A1 ( A[12] ) ) ;
XNR2D0HVT U1_A_6 (.A2 ( carry_6 ) , .ZN ( SUM[6] ) , .A1 ( A[6] ) ) ;
OR2D0HVT U1_B_9 (.A2 ( carry_9 ) , .A1 ( A[9] ) , .Z ( carry_10 ) ) ;
XNR2D0HVT U1_A_2 (.A2 ( carry_2 ) , .ZN ( SUM[2] ) , .A1 ( A[2] ) ) ;
XNR2D0HVT U1_A_5 (.A2 ( carry_5 ) , .ZN ( SUM[5] ) , .A1 ( A[5] ) ) ;
XNR2D0HVT U1_A_10 (.A2 ( carry_10 ) , .ZN ( SUM[10] ) , .A1 ( A[10] ) ) ;
XNR2D0HVT U1_A_3 (.A2 ( carry_3 ) , .ZN ( SUM[3] ) , .A1 ( A[3] ) ) ;
XNR2D0HVT U1_A_4 (.A2 ( carry_4 ) , .ZN ( SUM[4] ) , .A1 ( A[4] ) ) ;
XNR2D0HVT U1_A_11 (.A2 ( carry_11 ) , .ZN ( SUM[11] ) , .A1 ( A[11] ) ) ;
XNR2D0HVT U1_A_13 (.A2 ( carry_13 ) , .ZN ( SUM[13] ) , .A1 ( A[13] ) ) ;
XNR2D0HVT U1_A_1 (.A2 ( A[0] ) , .ZN ( SUM[1] ) , .A1 ( A[1] ) ) ;
endmodule




module cram_smc_DW01_dec_9_1 (A , SUM );
input  [8:0] A ;
output [8:0] SUM ;

/* wire declarations */

wire carry_3 ;
wire carry_4 ;
wire carry_5 ;
wire carry_2 ;
wire carry_6 ;
wire carry_7 ;
wire carry_8 ;

INVD0HVT U6 (.I ( A[0] ) , .ZN ( SUM[0] ) ) ;
OR2D0HVT U1_B_3 (.A2 ( carry_3 ) , .A1 ( A[3] ) , .Z ( carry_4 ) ) ;
OR2D0HVT U1_B_4 (.A2 ( carry_4 ) , .A1 ( A[4] ) , .Z ( carry_5 ) ) ;
OR2D0HVT U1_B_2 (.A2 ( carry_2 ) , .A1 ( A[2] ) , .Z ( carry_3 ) ) ;
OR2D0HVT U1_B_5 (.A2 ( carry_5 ) , .A1 ( A[5] ) , .Z ( carry_6 ) ) ;
OR2D0HVT U1_B_1 (.A2 ( A[0] ) , .A1 ( A[1] ) , .Z ( carry_2 ) ) ;
OR2D0HVT U1_B_7 (.A2 ( carry_7 ) , .A1 ( A[7] ) , .Z ( carry_8 ) ) ;
OR2D0HVT U1_B_6 (.A2 ( carry_6 ) , .A1 ( A[6] ) , .Z ( carry_7 ) ) ;
XNR2D0HVT U1_A_6 (.A2 ( carry_6 ) , .ZN ( SUM[6] ) , .A1 ( A[6] ) ) ;
XNR2D0HVT U1_A_1 (.A2 ( A[0] ) , .ZN ( SUM[1] ) , .A1 ( A[1] ) ) ;
XNR2D0HVT U1_A_8 (.A2 ( carry_8 ) , .ZN ( SUM[8] ) , .A1 ( A[8] ) ) ;
XNR2D0HVT U1_A_7 (.A2 ( carry_7 ) , .ZN ( SUM[7] ) , .A1 ( A[7] ) ) ;
XNR2D0HVT U1_A_2 (.A2 ( carry_2 ) , .ZN ( SUM[2] ) , .A1 ( A[2] ) ) ;
XNR2D0HVT U1_A_5 (.A2 ( carry_5 ) , .ZN ( SUM[5] ) , .A1 ( A[5] ) ) ;
XNR2D0HVT U1_A_3 (.A2 ( carry_3 ) , .ZN ( SUM[3] ) , .A1 ( A[3] ) ) ;
XNR2D0HVT U1_A_4 (.A2 ( carry_4 ) , .ZN ( SUM[4] ) , .A1 ( A[4] ) ) ;
endmodule




module cram_smc_DW01_dec_9_0 (A , SUM );
input  [8:0] A ;
output [8:0] SUM ;

/* wire declarations */

wire carry_3 ;
wire carry_4 ;
wire carry_5 ;
wire carry_2 ;
wire carry_6 ;
wire carry_7 ;
wire carry_8 ;

INVD0HVT U6 (.I ( A[0] ) , .ZN ( SUM[0] ) ) ;
OR2D0HVT U1_B_3 (.A2 ( carry_3 ) , .A1 ( A[3] ) , .Z ( carry_4 ) ) ;
OR2D0HVT U1_B_4 (.A2 ( carry_4 ) , .A1 ( A[4] ) , .Z ( carry_5 ) ) ;
OR2D0HVT U1_B_2 (.A2 ( carry_2 ) , .A1 ( A[2] ) , .Z ( carry_3 ) ) ;
OR2D0HVT U1_B_5 (.A2 ( carry_5 ) , .A1 ( A[5] ) , .Z ( carry_6 ) ) ;
OR2D0HVT U1_B_1 (.A2 ( A[0] ) , .A1 ( A[1] ) , .Z ( carry_2 ) ) ;
OR2D0HVT U1_B_7 (.A2 ( carry_7 ) , .A1 ( A[7] ) , .Z ( carry_8 ) ) ;
OR2D0HVT U1_B_6 (.A2 ( carry_6 ) , .A1 ( A[6] ) , .Z ( carry_7 ) ) ;
XNR2D0HVT U1_A_6 (.A2 ( carry_6 ) , .ZN ( SUM[6] ) , .A1 ( A[6] ) ) ;
XNR2D0HVT U1_A_1 (.A2 ( A[0] ) , .ZN ( SUM[1] ) , .A1 ( A[1] ) ) ;
XNR2D0HVT U1_A_8 (.A2 ( carry_8 ) , .ZN ( SUM[8] ) , .A1 ( A[8] ) ) ;
XNR2D0HVT U1_A_7 (.A2 ( carry_7 ) , .ZN ( SUM[7] ) , .A1 ( A[7] ) ) ;
XNR2D0HVT U1_A_2 (.A2 ( carry_2 ) , .ZN ( SUM[2] ) , .A1 ( A[2] ) ) ;
XNR2D0HVT U1_A_5 (.A2 ( carry_5 ) , .ZN ( SUM[5] ) , .A1 ( A[5] ) ) ;
XNR2D0HVT U1_A_3 (.A2 ( carry_3 ) , .ZN ( SUM[3] ) , .A1 ( A[3] ) ) ;
XNR2D0HVT U1_A_4 (.A2 ( carry_4 ) , .ZN ( SUM[4] ) , .A1 ( A[4] ) ) ;
endmodule




module cram_smc (baddr , cm_banksel , spi_clk_out_GB_G4B1I2ASTHIRNet308 , 
    flen , spi_clk_out_GB_G4B2I25ASTHIRNet113 , 
    spi_clk_out_GB_G4B2I22ASTHIRNet77 , spi_clk_out_GB_G4B2I19ASTHIRNet57 , 
    stwrt_fnum , fnum , rst_b , tm_dis_cram_clk_gating , cram_wrt , 
    cor_en_8bconfig , cor_security_rddis , cor_security_wrtdis , 
    cram_access_en , cm_last_rsr , cram_reading , clk , clk_b , 
    smc_rsr_rst , smc_row_inc , smc_wset_prec , smc_wwlwrt_dis , 
    smc_wcram_rst , smc_wset_precgnd , cram_rd , cram_clr , data_muxsel1 , 
    smc_wdis_dclk , data_muxsel , smc_rpull_b , smc_rprec , 
    smc_rrst_pullwlen , cram_done , cm_clk , clk_b_G5B1I3ASTHIRNet297 , 
    spi_clk_out_GB_G4B2I23ASTHIRNet282 , spi_clk_out_GB_G4B2I20ASTHIRNet258 , 
    spi_clk_out_GB_G4B2I17ASTHIRNet236 , spi_clk_out_GB_G4B2I24ASTHIRNet215 , 
    spi_clk_out_GB_G4B2I15ASTHIRNet132 , smc_wwlwrt_en , smc_rwl_en );
input  [1:0] baddr ;
output [3:0] cm_banksel ;
input  spi_clk_out_GB_G4B1I2ASTHIRNet308 ;
input  [15:0] flen ;
input  spi_clk_out_GB_G4B2I25ASTHIRNet113 ;
input  spi_clk_out_GB_G4B2I22ASTHIRNet77 ;
input  spi_clk_out_GB_G4B2I19ASTHIRNet57 ;
input  [8:0] stwrt_fnum ;
input  [8:0] fnum ;
input  rst_b ;
input  tm_dis_cram_clk_gating ;
input  cram_wrt ;
input  cor_en_8bconfig ;
input  cor_security_rddis ;
input  cor_security_wrtdis ;
input  cram_access_en ;
input  cm_last_rsr ;
output cram_reading ;
input  clk ;
input  clk_b ;
output smc_rsr_rst ;
output smc_row_inc ;
output smc_wset_prec ;
output smc_wwlwrt_dis ;
output smc_wcram_rst ;
output smc_wset_precgnd ;
input  cram_rd ;
input  cram_clr ;
output data_muxsel1 ;
output smc_wdis_dclk ;
output data_muxsel ;
output smc_rpull_b ;
output smc_rprec ;
output smc_rrst_pullwlen ;
output cram_done ;
output cm_clk ;
input  clk_b_G5B1I3ASTHIRNet297 ;
input  spi_clk_out_GB_G4B2I23ASTHIRNet282 ;
input  spi_clk_out_GB_G4B2I20ASTHIRNet258 ;
input  spi_clk_out_GB_G4B2I17ASTHIRNet236 ;
input  spi_clk_out_GB_G4B2I24ASTHIRNet215 ;
input  spi_clk_out_GB_G4B2I15ASTHIRNet132 ;
output smc_wwlwrt_en ;
output smc_rwl_en ;

/* wire declarations */
wire flencnt_7_ ;
wire flencnt_6_ ;
wire flencnt_5_ ;
wire flencnt_4_ ;
wire flencnt_3_ ;
wire flencnt_2_ ;
wire flencnt_1_ ;
wire flencnt_0_ ;
wire flencnt_15_ ;
wire flencnt_14_ ;
wire flencnt_13_ ;
wire flencnt_12_ ;
wire flencnt_11_ ;
wire flencnt_10_ ;
wire flencnt_9_ ;
wire flencnt_8_ ;
wire flencnt898_7 ;
wire flencnt898_6 ;
wire flencnt898_5 ;
wire flencnt898_4 ;
wire flencnt898_3 ;
wire flencnt898_2 ;
wire flencnt898_1 ;
wire flencnt898_0 ;
wire flencnt898_15 ;
wire flencnt898_14 ;
wire flencnt898_13 ;
wire flencnt898_12 ;
wire flencnt898_11 ;
wire flencnt898_10 ;
wire flencnt898_9 ;
wire flencnt898_8 ;
wire fnumcnt_1_ ;
wire fnumcnt_0_ ;
wire fnumcnt977_0 ;
wire fnumcnt_8_ ;
wire fnumcnt_7_ ;
wire fnumcnt_6_ ;
wire fnumcnt_5_ ;
wire fnumcnt_4_ ;
wire fnumcnt_3_ ;
wire fnumcnt_2_ ;
wire fnumcnt977_8 ;
wire fnumcnt977_7 ;
wire fnumcnt977_6 ;
wire fnumcnt977_5 ;
wire fnumcnt977_4 ;
wire fnumcnt977_3 ;
wire fnumcnt977_2 ;
wire fnumcnt977_1 ;
wire stwrt_fnumcnt_1_ ;
wire stwrt_fnumcnt_0_ ;
wire stwrt_fnumcnt1055_0 ;
wire stwrt_fnumcnt_8_ ;
wire stwrt_fnumcnt_7_ ;
wire stwrt_fnumcnt_6_ ;
wire stwrt_fnumcnt_5_ ;
wire stwrt_fnumcnt_4_ ;
wire stwrt_fnumcnt_3_ ;
wire stwrt_fnumcnt_2_ ;
wire stwrt_fnumcnt1055_8 ;
wire stwrt_fnumcnt1055_7 ;
wire stwrt_fnumcnt1055_6 ;
wire stwrt_fnumcnt1055_5 ;
wire stwrt_fnumcnt1055_4 ;
wire stwrt_fnumcnt1055_3 ;
wire stwrt_fnumcnt1055_2 ;
wire stwrt_fnumcnt1055_1 ;

wire n1408 ;
wire n1526 ;
wire n1410 ;
wire n1518 ;
wire n1412 ;
wire n1522 ;
wire n1414 ;
wire n1525 ;
wire n1416 ;
wire n1517 ;
wire n1418 ;
wire n1524 ;
wire n1402 ;
wire n1515 ;
wire n1380 ;
wire n1465 ;
wire n1376 ;
wire n1445 ;
wire n1420 ;
wire n1516 ;
wire n1424 ;
wire n1519 ;
wire n1426 ;
wire n1527 ;
wire n1428 ;
wire n1521 ;
wire n1404 ;
wire n1513 ;
wire n1406 ;
wire n1520 ;
wire n_279 ;
wire n1378 ;
wire n1460 ;
wire n1434 ;
wire n1312 ;
wire n1432 ;
wire n1313 ;
wire n1447 ;
wire n1364 ;
wire auxcnt787_2 ;
wire n1367 ;
wire n1468 ;
wire auxcnt787_1 ;
wire n1368 ;
wire auxcnt787_0 ;
wire auxcnt_0_ ;
wire n1455 ;
wire dummycnt_0_ ;
wire n1369 ;
wire n1448 ;
wire n1398 ;
wire n1501 ;
wire n1439 ;
wire n1373 ;
wire n1317 ;
wire n1510 ;
wire n1363 ;
wire n1493 ;
wire n1492 ;
wire n1370 ;
wire n1479 ;
wire n1377 ;
wire n1484 ;
wire n1505 ;
wire n1467 ;
wire n1379 ;
wire n1464 ;
wire n1385 ;
wire n1474 ;
wire n1386 ;
wire n1478 ;
wire n1449 ;
wire n1500 ;
wire n1399 ;
wire n1400 ;
wire n1401 ;
wire n1469 ;
wire n1459 ;
wire state_2_ ;
wire n1496 ;
wire state_0_ ;
wire n1494 ;
wire n1443 ;
wire n1512 ;
wire n1441 ;
wire n1446 ;
wire n1436 ;
wire n1458 ;
wire auxcnt_1_ ;
wire n1452 ;
wire n1316 ;
wire n1506 ;
wire n1315 ;
wire n1314 ;
wire n1341 ;
wire n1490 ;
wire n1340 ;
wire n1339 ;
wire n1348 ;
wire n1487 ;
wire n1347 ;
wire n1346 ;
wire n1361 ;
wire n1498 ;
wire n1360 ;
wire n1359 ;
wire n1433 ;
wire n1454 ;
wire dummycnt_1_ ;
wire n1353 ;
wire dummycnt_3_ ;
wire n1354 ;
wire n1463 ;
wire n1374 ;
wire n1382 ;
wire n1318 ;
wire n1489 ;
wire n1350 ;
wire n1437 ;
wire n1388 ;
wire n1389 ;
wire n1473 ;
wire n1456 ;
wire n1394 ;
wire n1507 ;
wire n1395 ;
wire n1321 ;
wire n1320 ;
wire n1319 ;
wire n1483 ;
wire n1322 ;
wire state_1_ ;
wire n1453 ;
wire n1466 ;
wire n1372 ;
wire n1477 ;
wire n1508 ;
wire n1475 ;
wire n1384 ;
wire n1495 ;
wire n1390 ;
wire n1391 ;
wire n1325 ;
wire n1324 ;
wire n1323 ;
wire n1482 ;
wire n1326 ;
wire n1329 ;
wire n1328 ;
wire n1327 ;
wire n1481 ;
wire n1330 ;
wire n1333 ;
wire n1332 ;
wire n1331 ;
wire n1480 ;
wire n1334 ;
wire n1476 ;
wire n1470 ;
wire n1337 ;
wire n1336 ;
wire n1335 ;
wire n1491 ;
wire n1338 ;
wire n1344 ;
wire n1343 ;
wire n1342 ;
wire n1488 ;
wire n1345 ;
wire n1351 ;
wire n1349 ;
wire n1352 ;
wire n1357 ;
wire n1356 ;
wire n1355 ;
wire n1499 ;
wire n1358 ;
wire n1486 ;
wire n1485 ;
wire n1435 ;
wire dummycnt711_0 ;
wire n1371 ;
wire n788_0 ;
wire auxcnt789_0 ;
wire auxcnt_2_ ;
wire n1504 ;
wire dummycnt711_2 ;
wire smc_wset_precgnd538 ;
wire n1365 ;
wire next_1_ ;
wire n1462 ;
wire n1366 ;
wire next_0_ ;
wire n1497 ;
wire n1511 ;
wire n1381 ;
wire n1472 ;
wire n1383 ;
wire n1450 ;
wire n1457 ;
wire n1362 ;
wire smc_rsr_rst281 ;
wire smc_rpull_b508 ;
wire n976_0 ;
wire smc_rrst_pullwlen514 ;
wire n1375 ;
wire next_2_ ;
wire dummycnt711_3 ;
wire smc_rprec299 ;
wire n1461 ;
wire cram_done275 ;
wire n_472 ;
wire n1392 ;
wire dummycnt_2_ ;
wire n1393 ;
wire n1444 ;
wire n1440 ;
wire n1438 ;
wire n1442 ;
wire n1503 ;
wire n1502 ;
wire stwrt_fnumcnt1053_0 ;
wire stwrt_fnumcnt1053_8 ;
wire rst_bASThfnNet18 ;
wire n1509 ;
wire n1387 ;
wire fnumcnt975_8 ;
wire stwrt_fnumcnt1053_7 ;
wire stwrt_fnumcnt1053_6 ;
wire stwrt_fnumcnt1053_5 ;
wire stwrt_fnumcnt1053_4 ;
wire stwrt_fnumcnt1053_3 ;
wire stwrt_fnumcnt1053_2 ;
wire stwrt_fnumcnt1053_1 ;
wire flencnt896_8 ;
wire fnumcnt975_0 ;
wire fnumcnt975_1 ;
wire fnumcnt975_4 ;
wire fnumcnt975_2 ;
wire fnumcnt975_3 ;
wire fnumcnt975_5 ;
wire fnumcnt975_7 ;
wire flencnt896_3 ;
wire fnumcnt975_6 ;
wire flencnt896_15 ;
wire flencnt896_14 ;
wire flencnt896_13 ;
wire flencnt896_0 ;
wire flencnt896_1 ;
wire flencnt896_2 ;
wire flencnt896_4 ;
wire flencnt896_7 ;
wire flencnt896_9 ;
wire flencnt896_12 ;
wire flencnt896_11 ;
wire flencnt896_10 ;
wire flencnt896_5 ;
wire flencnt896_6 ;
wire cram_reading_int ;
wire cram_reading_int_d1 ;
wire rst_bASThfnNet19 ;
wire data_muxsel502 ;
wire spi_clk_out_GB_G4B2I26ASTHNet300 ;
wire cram_reading_int_d2 ;
wire data_muxsel1496 ;
wire smc_wcram_rst532 ;
wire cram_reading_int_d3 ;
wire smc_row_inc_en287 ;
wire smc_row_inc_en ;
wire aLogic0_ ;
wire cram_clk_en_i ;
wire n1422 ;
wire n710_0 ;
wire dummycnt709_2 ;
wire dummycnt709_1 ;
wire dummycnt709_0 ;
wire dummycnt709_3 ;
wire n1054_0 ;
wire n1471 ;
wire n1451 ;


cram_smc_DW01_dec_16_0 sub_445 (
    .A ( {flencnt_15_ , flencnt_14_ , flencnt_13_ , flencnt_12_ , 
	flencnt_11_ , flencnt_10_ , flencnt_9_ , flencnt_8_ , flencnt_7_ , 
	flencnt_6_ , flencnt_5_ , flencnt_4_ , flencnt_3_ , flencnt_2_ , 
	flencnt_1_ , flencnt_0_ } ) , 
    .SUM ( {flencnt898_15 , flencnt898_14 , flencnt898_13 , flencnt898_12 , 
	flencnt898_11 , flencnt898_10 , flencnt898_9 , flencnt898_8 , 
	flencnt898_7 , flencnt898_6 , flencnt898_5 , flencnt898_4 , 
	flencnt898_3 , flencnt898_2 , flencnt898_1 , flencnt898_0 } ) ) ;


cram_smc_DW01_dec_9_1 sub_470 (
    .A ( {fnumcnt_8_ , fnumcnt_7_ , fnumcnt_6_ , fnumcnt_5_ , fnumcnt_4_ , 
	fnumcnt_3_ , fnumcnt_2_ , fnumcnt_1_ , fnumcnt_0_ } ) , 
    .SUM ( {fnumcnt977_8 , fnumcnt977_7 , fnumcnt977_6 , fnumcnt977_5 , 
	fnumcnt977_4 , fnumcnt977_3 , fnumcnt977_2 , fnumcnt977_1 , 
	fnumcnt977_0 } ) ) ;


cram_smc_DW01_dec_9_0 sub_485 (
    .A ( {stwrt_fnumcnt_8_ , stwrt_fnumcnt_7_ , stwrt_fnumcnt_6_ , 
	stwrt_fnumcnt_5_ , stwrt_fnumcnt_4_ , stwrt_fnumcnt_3_ , 
	stwrt_fnumcnt_2_ , stwrt_fnumcnt_1_ , stwrt_fnumcnt_0_ } ) , 
    .SUM ( {stwrt_fnumcnt1055_8 , stwrt_fnumcnt1055_7 , stwrt_fnumcnt1055_6 , 
	stwrt_fnumcnt1055_5 , stwrt_fnumcnt1055_4 , stwrt_fnumcnt1055_3 , 
	stwrt_fnumcnt1055_2 , stwrt_fnumcnt1055_1 , stwrt_fnumcnt1055_0 } ) ) ;

INVD0HVT U637 (.ZN ( n1408 ) , .I ( n1526 ) ) ;
INVD0HVT U639 (.ZN ( n1410 ) , .I ( n1518 ) ) ;
INVD0HVT U641 (.ZN ( n1412 ) , .I ( n1522 ) ) ;
INVD0HVT U643 (.ZN ( n1414 ) , .I ( n1525 ) ) ;
INVD0HVT U645 (.ZN ( n1416 ) , .I ( n1517 ) ) ;
INVD0HVT U647 (.ZN ( n1418 ) , .I ( n1524 ) ) ;
INVD0HVT U631 (.ZN ( n1402 ) , .I ( n1515 ) ) ;
INVD0HVT U459 (.I ( n1380 ) , .ZN ( n1465 ) ) ;
INVD0HVT U467 (.I ( n1376 ) , .ZN ( n1445 ) ) ;
INVD0HVT U649 (.ZN ( n1420 ) , .I ( n1516 ) ) ;
INVD0HVT U652 (.ZN ( n1424 ) , .I ( n1519 ) ) ;
INVD0HVT U654 (.ZN ( n1426 ) , .I ( n1527 ) ) ;
INVD0HVT U656 (.ZN ( n1428 ) , .I ( n1521 ) ) ;
INVD0HVT U633 (.ZN ( n1404 ) , .I ( n1513 ) ) ;
INVD0HVT U635 (.ZN ( n1406 ) , .I ( n1520 ) ) ;
ND2D0HVT U542 (.ZN ( n_279 ) , .A1 ( n1378 ) , .A2 ( n1460 ) ) ;
ND2D0HVT U559 (.ZN ( n1434 ) , .A1 ( n1312 ) , .A2 ( n1432 ) ) ;
ND2D0HVT U461 (.ZN ( n1313 ) , .A1 ( n1447 ) , .A2 ( n1364 ) ) ;
ND2D0HVT U521 (.ZN ( auxcnt787_2 ) , .A1 ( n1367 ) , .A2 ( n1468 ) ) ;
ND2D0HVT U523 (.ZN ( auxcnt787_1 ) , .A1 ( n1368 ) , .A2 ( n1468 ) ) ;
ND2D0HVT U526 (.ZN ( auxcnt787_0 ) , .A1 ( auxcnt_0_ ) , .A2 ( n1468 ) ) ;
ND2D0HVT U541 (.ZN ( n1455 ) , .A1 ( dummycnt_0_ ) , .A2 ( cram_clr ) ) ;
INVD0HVT U528 (.I ( n1369 ) , .ZN ( n1468 ) ) ;
CKND0HVT U565 (.I ( n1448 ) , .ZN ( n1398 ) ) ;
CKND0HVT U582 (.I ( n1501 ) , .ZN ( n1439 ) ) ;
CKND0HVT U462 (.I ( n1313 ) , .ZN ( n1373 ) ) ;
CKND0HVT U466 (.I ( n1317 ) , .ZN ( n1510 ) ) ;
CKND0HVT U513 (.I ( n1363 ) , .ZN ( n1493 ) ) ;
CKND0HVT U515 (.I ( n1364 ) , .ZN ( n1492 ) ) ;
CKND0HVT U530 (.I ( n1370 ) , .ZN ( n1479 ) ) ;
CKND0HVT U538 (.I ( n1377 ) , .ZN ( n1484 ) ) ;
CKND0HVT U629 (.I ( n1448 ) , .ZN ( n1505 ) ) ;
CKND0HVT U658 (.I ( cram_wrt ) , .ZN ( n1467 ) ) ;
CKND0HVT U546 (.I ( n1379 ) , .ZN ( n1464 ) ) ;
CKND0HVT U556 (.I ( n1385 ) , .ZN ( n1474 ) ) ;
CKND0HVT U558 (.I ( n1386 ) , .ZN ( n1478 ) ) ;
CKND0HVT U562 (.I ( n1449 ) , .ZN ( n1500 ) ) ;
CKND0HVT U563 (.I ( n1399 ) , .ZN ( n1400 ) ) ;
CKND0HVT U564 (.I ( n1399 ) , .ZN ( n1401 ) ) ;
CKND0HVT U660 (.I ( cram_clr ) , .ZN ( n1469 ) ) ;
CKND0HVT U661 (.I ( cram_rd ) , .ZN ( n1459 ) ) ;
CKND0HVT U583 (.I ( state_2_ ) , .ZN ( n1496 ) ) ;
CKND0HVT U584 (.I ( state_0_ ) , .ZN ( n1494 ) ) ;
CKND0HVT U585 (.I ( baddr[1] ) , .ZN ( n1443 ) ) ;
CKND0HVT U586 (.I ( cor_en_8bconfig ) , .ZN ( n1512 ) ) ;
CKND0HVT U595 (.I ( baddr[0] ) , .ZN ( n1441 ) ) ;
CKND0HVT U612 (.I ( n1313 ) , .ZN ( n1446 ) ) ;
NR2D0HVT U630 (.ZN ( n1399 ) , .A2 ( n1448 ) , .A1 ( n1447 ) ) ;
ND3D0HVT U551 (.A1 ( n1436 ) , .ZN ( n1458 ) , .A2 ( auxcnt_1_ ) 
    , .A3 ( auxcnt_0_ ) ) ;
ND3D0HVT U463 (.A1 ( flencnt_1_ ) , .ZN ( n1452 ) , .A2 ( flencnt_0_ ) 
    , .A3 ( cram_wrt ) ) ;
ND3D0HVT U464 (.A1 ( n1316 ) , .ZN ( n1506 ) , .A2 ( n1315 ) , .A3 ( n1314 ) ) ;
ND3D0HVT U491 (.A1 ( n1341 ) , .ZN ( n1490 ) , .A2 ( n1340 ) , .A3 ( n1339 ) ) ;
ND3D0HVT U497 (.A1 ( n1348 ) , .ZN ( n1487 ) , .A2 ( n1347 ) , .A3 ( n1346 ) ) ;
ND3D0HVT U508 (.A1 ( n1361 ) , .ZN ( n1498 ) , .A2 ( n1360 ) , .A3 ( n1359 ) ) ;
ND3D0HVT U540 (.A1 ( n1433 ) , .ZN ( n1454 ) , .A2 ( n1432 ) 
    , .A3 ( dummycnt_1_ ) ) ;
NR2D0HVT U465 (.A1 ( n1468 ) , .A2 ( n1445 ) , .ZN ( n1317 ) ) ;
NR2D0HVT U505 (.A1 ( n1459 ) , .A2 ( n1433 ) , .ZN ( n1353 ) ) ;
NR2D0HVT U506 (.A1 ( dummycnt_3_ ) , .A2 ( n1493 ) , .ZN ( n1354 ) ) ;
NR2D0HVT U512 (.A1 ( n1469 ) , .A2 ( n1447 ) , .ZN ( n1363 ) ) ;
NR2D0HVT U535 (.A1 ( n1447 ) , .A2 ( n1463 ) , .ZN ( n1374 ) ) ;
NR2D0HVT U550 (.A1 ( cram_rd ) , .A2 ( cram_clr ) , .ZN ( n1382 ) ) ;
NR2D0HVT U555 (.A1 ( n1467 ) , .A2 ( n1468 ) , .ZN ( n1385 ) ) ;
NR2D0HVT U460 (.ZN ( n1380 ) , .A2 ( n1459 ) , .A1 ( n1376 ) ) ;
NR3D0HVT U468 (.A1 ( state_2_ ) , .ZN ( n1318 ) , .A2 ( state_0_ ) 
    , .A3 ( n1489 ) ) ;
NR3D0HVT U503 (.A1 ( flencnt_13_ ) , .ZN ( n1350 ) , .A2 ( flencnt_14_ ) 
    , .A3 ( flencnt_8_ ) ) ;
NR2D0HVT U557 (.A1 ( cram_rd ) , .A2 ( n1467 ) , .ZN ( n1386 ) ) ;
NR2D0HVT U560 (.A1 ( auxcnt_0_ ) , .A2 ( auxcnt_1_ ) , .ZN ( n1437 ) ) ;
NR2D0HVT U588 (.A1 ( dummycnt_0_ ) , .A2 ( n1454 ) , .ZN ( n1388 ) ) ;
NR2D0HVT U589 (.A1 ( cram_clr ) , .A2 ( n1474 ) , .ZN ( n1389 ) ) ;
NR2D0HVT U593 (.A1 ( n1473 ) , .A2 ( n1456 ) , .ZN ( n1394 ) ) ;
NR2D0HVT U594 (.A1 ( n1507 ) , .A2 ( n1377 ) , .ZN ( n1395 ) ) ;
ND4D0HVT U469 (.A2 ( n1321 ) , .A3 ( n1320 ) , .A4 ( n1319 ) , .ZN ( n1483 ) 
    , .A1 ( n1322 ) ) ;
NR3D0HVT U514 (.A1 ( state_2_ ) , .ZN ( n1364 ) , .A2 ( state_1_ ) 
    , .A3 ( state_0_ ) ) ;
NR3D0HVT U527 (.A1 ( flencnt_1_ ) , .ZN ( n1369 ) , .A2 ( flencnt_0_ ) 
    , .A3 ( n1453 ) ) ;
NR3D0HVT U533 (.A1 ( n1466 ) , .ZN ( n1372 ) , .A2 ( n1477 ) , .A3 ( n1508 ) ) ;
NR3D0HVT U545 (.A1 ( flencnt_1_ ) , .ZN ( n1379 ) , .A2 ( n1475 ) 
    , .A3 ( n1453 ) ) ;
NR3D0HVT U554 (.A1 ( dummycnt_1_ ) , .ZN ( n1384 ) , .A2 ( dummycnt_0_ ) 
    , .A3 ( n1459 ) ) ;
NR3D0HVT U590 (.A1 ( n1495 ) , .ZN ( n1390 ) , .A2 ( n1489 ) , .A3 ( n1317 ) ) ;
NR3D0HVT U591 (.A1 ( state_1_ ) , .ZN ( n1391 ) , .A2 ( n1449 ) , .A3 ( n1495 ) ) ;
ND4D0HVT U474 (.A2 ( n1325 ) , .A3 ( n1324 ) , .A4 ( n1323 ) , .ZN ( n1482 ) 
    , .A1 ( n1326 ) ) ;
ND4D0HVT U479 (.A2 ( n1329 ) , .A3 ( n1328 ) , .A4 ( n1327 ) , .ZN ( n1481 ) 
    , .A1 ( n1330 ) ) ;
ND4D0HVT U484 (.A2 ( n1333 ) , .A3 ( n1332 ) , .A4 ( n1331 ) , .ZN ( n1480 ) 
    , .A1 ( n1334 ) ) ;
ND4D0HVT U489 (.A2 ( n1476 ) , .A3 ( n1456 ) , .A4 ( n1475 ) , .ZN ( n1508 ) 
    , .A1 ( n1470 ) ) ;
ND4D0HVT U490 (.A2 ( n1337 ) , .A3 ( n1336 ) , .A4 ( n1335 ) , .ZN ( n1491 ) 
    , .A1 ( n1338 ) ) ;
ND4D0HVT U492 (.A2 ( n1344 ) , .A3 ( n1343 ) , .A4 ( n1342 ) , .ZN ( n1488 ) 
    , .A1 ( n1345 ) ) ;
ND4D0HVT U501 (.A2 ( n1351 ) , .A3 ( n1350 ) , .A4 ( n1349 ) , .ZN ( n1466 ) 
    , .A1 ( n1352 ) ) ;
ND4D0HVT U507 (.A2 ( n1357 ) , .A3 ( n1356 ) , .A4 ( n1355 ) , .ZN ( n1499 ) 
    , .A1 ( n1358 ) ) ;
XNR2D0HVT U471 (.A2 ( flen[9] ) , .ZN ( n1320 ) , .A1 ( flencnt_9_ ) ) ;
XNR2D0HVT U472 (.A2 ( flen[2] ) , .ZN ( n1321 ) , .A1 ( flencnt_2_ ) ) ;
XNR2D0HVT U473 (.A2 ( flen[5] ) , .ZN ( n1322 ) , .A1 ( flencnt_5_ ) ) ;
NR4D1HVT U537 (.A2 ( n1486 ) , .A3 ( n1487 ) , .A4 ( n1488 ) , .A1 ( n1485 ) 
    , .ZN ( n1377 ) ) ;
ND4D0HVT U520 (.A2 ( n1432 ) , .A3 ( n1435 ) , .A4 ( dummycnt711_0 ) 
    , .ZN ( n1449 ) , .A1 ( n1433 ) ) ;
ND4D0HVT U525 (.A2 ( n1371 ) , .A3 ( n1436 ) , .A4 ( n1468 ) , .ZN ( n788_0 ) 
    , .A1 ( auxcnt789_0 ) ) ;
ND4D0HVT U531 (.A2 ( n1371 ) , .A3 ( cram_wrt ) , .A4 ( auxcnt_2_ ) 
    , .ZN ( n1507 ) , .A1 ( auxcnt789_0 ) ) ;
ND4D0HVT U544 (.A2 ( dummycnt_0_ ) , .A3 ( n1435 ) , .A4 ( n1433 ) 
    , .ZN ( n1460 ) , .A1 ( n1432 ) ) ;
XNR2D0HVT U476 (.A2 ( flen[4] ) , .ZN ( n1324 ) , .A1 ( flencnt_4_ ) ) ;
XNR2D0HVT U477 (.A2 ( flen[10] ) , .ZN ( n1325 ) , .A1 ( flencnt_10_ ) ) ;
XNR2D0HVT U478 (.A2 ( flen[14] ) , .ZN ( n1326 ) , .A1 ( flencnt_14_ ) ) ;
XNR2D0HVT U480 (.A2 ( flen[11] ) , .ZN ( n1327 ) , .A1 ( flencnt_11_ ) ) ;
XNR2D0HVT U481 (.A2 ( flen[3] ) , .ZN ( n1328 ) , .A1 ( flencnt_3_ ) ) ;
XNR2D0HVT U482 (.A2 ( flen[1] ) , .ZN ( n1329 ) , .A1 ( flencnt_1_ ) ) ;
XNR2D0HVT U483 (.A2 ( flen[13] ) , .ZN ( n1330 ) , .A1 ( flencnt_13_ ) ) ;
XNR2D0HVT U470 (.A2 ( flen[6] ) , .ZN ( n1319 ) , .A1 ( flencnt_6_ ) ) ;
XNR2D0HVT U486 (.A2 ( flen[0] ) , .ZN ( n1332 ) , .A1 ( flencnt_0_ ) ) ;
XNR2D0HVT U487 (.A2 ( flen[7] ) , .ZN ( n1333 ) , .A1 ( flencnt_7_ ) ) ;
XNR2D0HVT U488 (.A2 ( flen[15] ) , .ZN ( n1334 ) , .A1 ( flencnt_15_ ) ) ;
XNR2D0HVT U493 (.A2 ( fnum[6] ) , .ZN ( n1342 ) , .A1 ( fnumcnt_6_ ) ) ;
XNR2D0HVT U494 (.A2 ( fnumcnt_2_ ) , .ZN ( n1343 ) , .A1 ( fnum[2] ) ) ;
XNR2D0HVT U495 (.A2 ( fnum[1] ) , .ZN ( n1344 ) , .A1 ( fnumcnt_1_ ) ) ;
XNR2D0HVT U496 (.A2 ( fnumcnt_8_ ) , .ZN ( n1345 ) , .A1 ( fnum[8] ) ) ;
XNR2D0HVT U475 (.A2 ( flen[8] ) , .ZN ( n1323 ) , .A1 ( flencnt_8_ ) ) ;
NR4D0HVT U529 (.A2 ( n1481 ) , .A3 ( n1482 ) , .A4 ( n1483 ) , .A1 ( n1480 ) 
    , .ZN ( n1370 ) ) ;
NR4D0HVT U536 (.A2 ( fnumcnt_6_ ) , .A3 ( n1490 ) , .A4 ( n1491 ) 
    , .A1 ( fnumcnt_8_ ) , .ZN ( n1376 ) ) ;
MUX2ND0HVT U504 (.ZN ( n1504 ) , .I0 ( n1354 ) , .S ( dummycnt_1_ ) 
    , .I1 ( n1353 ) ) ;
XNR2D0HVT U498 (.A2 ( fnum[5] ) , .ZN ( n1346 ) , .A1 ( fnumcnt_5_ ) ) ;
XNR2D0HVT U499 (.A2 ( fnum[7] ) , .ZN ( n1347 ) , .A1 ( fnumcnt_7_ ) ) ;
XNR2D0HVT U500 (.A2 ( fnum[4] ) , .ZN ( n1348 ) , .A1 ( fnumcnt_4_ ) ) ;
XNR2D0HVT U664 (.A2 ( n1432 ) , .ZN ( dummycnt711_2 ) , .A1 ( n1312 ) ) ;
XNR2D0HVT U485 (.A2 ( flen[12] ) , .ZN ( n1331 ) , .A1 ( flencnt_12_ ) ) ;
OAI22D0HVT U539 (.A2 ( n1455 ) , .A1 ( n1454 ) , .B2 ( flencnt_1_ ) 
    , .ZN ( smc_wset_precgnd538 ) , .B1 ( n1473 ) ) ;
IND2D0HVT U516 (.A1 ( n1390 ) , .B1 ( n1365 ) , .ZN ( next_1_ ) ) ;
IND2D0HVT U518 (.A1 ( n1462 ) , .B1 ( n1366 ) , .ZN ( next_0_ ) ) ;
AOI31D0HVT U517 (.B ( n1497 ) , .A1 ( cram_wrt ) , .ZN ( n1365 ) , .A3 ( n1510 ) 
    , .A2 ( n1318 ) ) ;
AOI31D0HVT U519 (.B ( n1390 ) , .A1 ( n1489 ) , .ZN ( n1366 ) , .A3 ( n1511 ) 
    , .A2 ( n1496 ) ) ;
NR4D0HVT U548 (.A2 ( n1465 ) , .A3 ( flencnt_0_ ) , .A4 ( n1453 ) 
    , .A1 ( n1456 ) , .ZN ( n1381 ) ) ;
NR4D0HVT U553 (.A2 ( n1476 ) , .A3 ( flencnt_1_ ) , .A4 ( n1472 ) 
    , .A1 ( n1465 ) , .ZN ( n1383 ) ) ;
NR4D0HVT U502 (.A2 ( flencnt_10_ ) , .A3 ( flencnt_9_ ) , .A4 ( n1506 ) 
    , .A1 ( flencnt_15_ ) , .ZN ( n1349 ) ) ;
AO21D0HVT U685 (.B ( n1450 ) , .A1 ( n1500 ) , .Z ( n1457 ) , .A2 ( cram_clr ) ) ;
AO21D0HVT U509 (.B ( n1362 ) , .A1 ( n1363 ) , .Z ( smc_rsr_rst281 ) 
    , .A2 ( n1450 ) ) ;
AO21D0HVT U543 (.B ( n1380 ) , .A1 ( cram_rd ) , .Z ( n1378 ) , .A2 ( n1464 ) ) ;
AO21D0HVT U547 (.B ( n1381 ) , .A1 ( cram_rd ) , .Z ( smc_rpull_b508 ) 
    , .A2 ( n1388 ) ) ;
AO21D0HVT U602 (.B ( n1446 ) , .A1 ( n1370 ) , .Z ( n976_0 ) , .A2 ( n1445 ) ) ;
AO21D0HVT U673 (.B ( n1391 ) , .A1 ( n1380 ) , .Z ( smc_rrst_pullwlen514 ) 
    , .A2 ( n1369 ) ) ;
OAI32D0HVT U510 (.ZN ( n1362 ) , .A3 ( n1479 ) , .B1 ( n1459 ) , .A1 ( n1478 ) 
    , .A2 ( n1484 ) , .B2 ( n1313 ) ) ;
OAI22D0HVT U511 (.A2 ( n1463 ) , .A1 ( n1375 ) , .B2 ( n1492 ) , .ZN ( next_2_ ) 
    , .B1 ( n1493 ) ) ;
CKXOR2D0HVT U522 (.Z ( n1367 ) , .A2 ( n1436 ) , .A1 ( n1437 ) ) ;
CKXOR2D0HVT U524 (.Z ( n1368 ) , .A2 ( auxcnt_0_ ) , .A1 ( auxcnt_1_ ) ) ;
CKXOR2D0HVT U665 (.Z ( dummycnt711_3 ) , .A2 ( n1433 ) , .A1 ( n1434 ) ) ;
CKXOR2D0HVT U686 (.Z ( n1485 ) , .A2 ( fnum[3] ) , .A1 ( fnumcnt_3_ ) ) ;
CKXOR2D0HVT U687 (.Z ( n1486 ) , .A2 ( fnum[0] ) , .A1 ( fnumcnt_0_ ) ) ;
AO22D0HVT U532 (.B1 ( n1373 ) , .B2 ( cram_rd ) , .Z ( smc_rprec299 ) 
    , .A1 ( n1380 ) , .A2 ( n1372 ) ) ;
AO22D0HVT U534 (.B1 ( n1376 ) , .B2 ( n1461 ) , .Z ( cram_done275 ) 
    , .A1 ( n1375 ) , .A2 ( n1374 ) ) ;
OAI211D0HVT U549 (.ZN ( n_472 ) , .A1 ( n1458 ) , .C ( n1474 ) , .A2 ( n1467 ) 
    , .B ( n1382 ) ) ;
AOI21D0HVT U592 (.A2 ( n1469 ) , .ZN ( n1392 ) , .A1 ( n1512 ) , .B ( n1501 ) ) ;
AO31D0HVT U552 (.B ( n1383 ) , .A1 ( dummycnt_2_ ) , .Z ( n1393 ) 
    , .A3 ( n1384 ) , .A2 ( dummycnt_3_ ) ) ;
AO31D0HVT U577 (.B ( n1392 ) , .A1 ( n1441 ) , .Z ( n1444 ) , .A3 ( n1439 ) 
    , .A2 ( n1443 ) ) ;
AO31D0HVT U580 (.B ( n1392 ) , .A1 ( baddr[1] ) , .Z ( n1440 ) , .A3 ( n1439 ) 
    , .A2 ( n1441 ) ) ;
AO31D0HVT U596 (.B ( n1392 ) , .A1 ( baddr[0] ) , .Z ( n1438 ) , .A3 ( n1439 ) 
    , .A2 ( baddr[1] ) ) ;
AO31D0HVT U597 (.B ( n1392 ) , .A1 ( baddr[0] ) , .Z ( n1442 ) , .A3 ( n1439 ) 
    , .A2 ( n1443 ) ) ;
AO31D0HVT U683 (.B ( n1462 ) , .A1 ( cram_clr ) , .Z ( n1450 ) , .A3 ( n1364 ) 
    , .A2 ( n1467 ) ) ;
IOA21D0HVT U561 (.A2 ( n1503 ) , .B ( cram_access_en ) , .ZN ( n1501 ) 
    , .A1 ( n1502 ) ) ;
MUX2D0HVT U574 (.I1 ( stwrt_fnum[0] ) , .Z ( stwrt_fnumcnt1053_0 ) 
    , .S ( smc_rsr_rst ) , .I0 ( stwrt_fnumcnt1055_0 ) ) ;
MUX2D0HVT U566 (.I1 ( stwrt_fnum[8] ) , .Z ( stwrt_fnumcnt1053_8 ) 
    , .S ( smc_rsr_rst ) , .I0 ( stwrt_fnumcnt1055_8 ) ) ;
BUFFD8HVT U576 (.Z ( cm_banksel[0] ) , .I ( n1444 ) ) ;
BUFFD8HVT U578 (.Z ( cm_banksel[1] ) , .I ( n1442 ) ) ;
BUFFD8HVT U579 (.Z ( cm_banksel[2] ) , .I ( n1440 ) ) ;
BUFFD8HVT U581 (.Z ( cm_banksel[3] ) , .I ( n1438 ) ) ;
CKBD16HVT rst_b_regASThfnInst18 (.I ( rst_b ) , .Z ( rst_bASThfnNet18 ) ) ;
OAI33D0HVT U587 (.B1 ( dummycnt711_0 ) , .B2 ( n1432 ) , .B3 ( n1504 ) 
    , .A3 ( n1509 ) , .ZN ( n1387 ) , .A1 ( n1465 ) , .A2 ( n1476 ) ) ;
MUX2D0HVT U610 (.I1 ( fnum[8] ) , .Z ( fnumcnt975_8 ) , .S ( n1446 ) 
    , .I0 ( fnumcnt977_8 ) ) ;
MUX2D0HVT U567 (.I1 ( stwrt_fnum[7] ) , .Z ( stwrt_fnumcnt1053_7 ) 
    , .S ( smc_rsr_rst ) , .I0 ( stwrt_fnumcnt1055_7 ) ) ;
MUX2D0HVT U568 (.I1 ( stwrt_fnum[6] ) , .Z ( stwrt_fnumcnt1053_6 ) 
    , .S ( smc_rsr_rst ) , .I0 ( stwrt_fnumcnt1055_6 ) ) ;
MUX2D0HVT U569 (.I1 ( stwrt_fnum[5] ) , .Z ( stwrt_fnumcnt1053_5 ) 
    , .S ( smc_rsr_rst ) , .I0 ( stwrt_fnumcnt1055_5 ) ) ;
MUX2D0HVT U570 (.I1 ( stwrt_fnum[4] ) , .Z ( stwrt_fnumcnt1053_4 ) 
    , .S ( smc_rsr_rst ) , .I0 ( stwrt_fnumcnt1055_4 ) ) ;
MUX2D0HVT U571 (.I1 ( stwrt_fnum[3] ) , .Z ( stwrt_fnumcnt1053_3 ) 
    , .S ( smc_rsr_rst ) , .I0 ( stwrt_fnumcnt1055_3 ) ) ;
MUX2D0HVT U572 (.I1 ( stwrt_fnum[2] ) , .Z ( stwrt_fnumcnt1053_2 ) 
    , .S ( smc_rsr_rst ) , .I0 ( stwrt_fnumcnt1055_2 ) ) ;
MUX2D0HVT U573 (.I1 ( stwrt_fnum[1] ) , .Z ( stwrt_fnumcnt1053_1 ) 
    , .S ( smc_rsr_rst ) , .I0 ( stwrt_fnumcnt1055_1 ) ) ;
MUX2D0HVT U619 (.I1 ( flencnt898_8 ) , .Z ( flencnt896_8 ) , .S ( n1398 ) 
    , .I0 ( flen[8] ) ) ;
MUX2D0HVT U603 (.I1 ( fnum[0] ) , .Z ( fnumcnt975_0 ) , .S ( n1446 ) 
    , .I0 ( fnumcnt977_0 ) ) ;
MUX2D0HVT U604 (.I1 ( fnum[1] ) , .Z ( fnumcnt975_1 ) , .S ( n1373 ) 
    , .I0 ( fnumcnt977_1 ) ) ;
MUX2D0HVT U605 (.I1 ( fnum[4] ) , .Z ( fnumcnt975_4 ) , .S ( n1446 ) 
    , .I0 ( fnumcnt977_4 ) ) ;
MUX2D0HVT U606 (.I1 ( fnum[2] ) , .Z ( fnumcnt975_2 ) , .S ( n1446 ) 
    , .I0 ( fnumcnt977_2 ) ) ;
MUX2D0HVT U607 (.I1 ( fnum[3] ) , .Z ( fnumcnt975_3 ) , .S ( n1446 ) 
    , .I0 ( fnumcnt977_3 ) ) ;
MUX2D0HVT U608 (.I1 ( fnum[5] ) , .Z ( fnumcnt975_5 ) , .S ( n1446 ) 
    , .I0 ( fnumcnt977_5 ) ) ;
MUX2D0HVT U609 (.I1 ( fnum[7] ) , .Z ( fnumcnt975_7 ) , .S ( n1373 ) 
    , .I0 ( fnumcnt977_7 ) ) ;
MUX2D0HVT U627 (.I1 ( flencnt898_3 ) , .Z ( flencnt896_3 ) , .S ( n1505 ) 
    , .I0 ( flen[3] ) ) ;
MUX2D0HVT U611 (.I1 ( fnum[6] ) , .Z ( fnumcnt975_6 ) , .S ( n1446 ) 
    , .I0 ( fnumcnt977_6 ) ) ;
MUX2D0HVT U613 (.I1 ( flencnt898_15 ) , .Z ( flencnt896_15 ) , .S ( n1398 ) 
    , .I0 ( flen[15] ) ) ;
MUX2D0HVT U614 (.I1 ( flencnt898_14 ) , .Z ( flencnt896_14 ) , .S ( n1398 ) 
    , .I0 ( flen[14] ) ) ;
MUX2D0HVT U615 (.I1 ( flencnt898_13 ) , .Z ( flencnt896_13 ) , .S ( n1398 ) 
    , .I0 ( flen[13] ) ) ;
MUX2D0HVT U616 (.I1 ( flencnt898_0 ) , .Z ( flencnt896_0 ) , .S ( n1505 ) 
    , .I0 ( flen[0] ) ) ;
MUX2D0HVT U617 (.I1 ( flencnt898_1 ) , .Z ( flencnt896_1 ) , .S ( n1505 ) 
    , .I0 ( flen[1] ) ) ;
MUX2D0HVT U618 (.I1 ( flencnt898_2 ) , .Z ( flencnt896_2 ) , .S ( n1505 ) 
    , .I0 ( flen[2] ) ) ;
MUX2D0HVT U628 (.I1 ( flencnt898_4 ) , .Z ( flencnt896_4 ) , .S ( n1505 ) 
    , .I0 ( flen[4] ) ) ;
MUX2D0HVT U620 (.I1 ( flencnt898_7 ) , .Z ( flencnt896_7 ) , .S ( n1398 ) 
    , .I0 ( flen[7] ) ) ;
MUX2D0HVT U621 (.I1 ( flencnt898_9 ) , .Z ( flencnt896_9 ) , .S ( n1505 ) 
    , .I0 ( flen[9] ) ) ;
MUX2D0HVT U622 (.I1 ( flencnt898_12 ) , .Z ( flencnt896_12 ) , .S ( n1398 ) 
    , .I0 ( flen[12] ) ) ;
MUX2D0HVT U623 (.I1 ( flencnt898_11 ) , .Z ( flencnt896_11 ) , .S ( n1505 ) 
    , .I0 ( flen[11] ) ) ;
MUX2D0HVT U624 (.I1 ( flencnt898_10 ) , .Z ( flencnt896_10 ) , .S ( n1398 ) 
    , .I0 ( flen[10] ) ) ;
MUX2D0HVT U625 (.I1 ( flencnt898_5 ) , .Z ( flencnt896_5 ) , .S ( n1505 ) 
    , .I0 ( flen[5] ) ) ;
MUX2D0HVT U626 (.I1 ( flencnt898_6 ) , .Z ( flencnt896_6 ) , .S ( n1398 ) 
    , .I0 ( flen[6] ) ) ;
DFCNQD1HVT cram_reading_int_d1_reg (.D ( cram_reading_int ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) , .Q ( cram_reading_int_d1 ) 
    , .CDN ( rst_bASThfnNet18 ) ) ;
DFCNQD1HVT smc_rsr_rst_reg (.D ( smc_rsr_rst281 ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) , .Q ( smc_rsr_rst ) 
    , .CDN ( rst_bASThfnNet18 ) ) ;
DFCNQD1HVT state_reg_2_ (.D ( next_2_ ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) , .Q ( state_2_ ) 
    , .CDN ( rst_bASThfnNet18 ) ) ;
DFCNQD1HVT state_reg_0_ (.D ( next_0_ ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) , .Q ( state_0_ ) 
    , .CDN ( rst_bASThfnNet18 ) ) ;
DFCNQD1HVT smc_wwlwrt_dis_reg (.D ( n1395 ) , .CP ( clk_b_G5B1I3ASTHIRNet297 ) 
    , .Q ( n1517 ) , .CDN ( rst_bASThfnNet19 ) ) ;
DFCNQD1HVT data_muxsel_reg (.D ( data_muxsel502 ) 
    , .CP ( clk_b_G5B1I3ASTHIRNet297 ) , .Q ( n1524 ) , .CDN ( rst_bASThfnNet18 ) ) ;
CKBD4HVT rst_b_regASThfnInst19 (.Z ( rst_bASThfnNet19 ) 
    , .I ( rst_bASThfnNet18 ) ) ;
CKBD12HVT CKBD12HVTG4B2I26 (.Z ( spi_clk_out_GB_G4B2I26ASTHNet300 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet308 ) ) ;
DFCNQD1HVT cram_reading_int_d2_reg (.D ( cram_reading_int_d1 ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) , .Q ( cram_reading_int_d2 ) 
    , .CDN ( rst_bASThfnNet18 ) ) ;
DFCNQD1HVT smc_rprec_reg (.D ( smc_rprec299 ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) , .Q ( n1526 ) 
    , .CDN ( rst_bASThfnNet19 ) ) ;
DFCNQD1HVT cram_done_reg (.D ( cram_done275 ) 
    , .CP ( spi_clk_out_GB_G4B2I15ASTHIRNet132 ) , .Q ( cram_done ) 
    , .CDN ( rst_bASThfnNet18 ) ) ;
DFCNQD1HVT data_muxsel1_reg (.D ( data_muxsel1496 ) 
    , .CP ( clk_b_G5B1I3ASTHIRNet297 ) , .Q ( n1522 ) , .CDN ( rst_bASThfnNet18 ) ) ;
DFCNQD1HVT smc_wcram_rst_reg (.D ( smc_wcram_rst532 ) 
    , .CP ( clk_b_G5B1I3ASTHIRNet297 ) , .Q ( n1518 ) , .CDN ( rst_bASThfnNet19 ) ) ;
DFCNQD1HVT cram_reading_int_d3_reg (.D ( cram_reading_int_d2 ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) , .Q ( cram_reading_int_d3 ) 
    , .CDN ( rst_bASThfnNet18 ) ) ;
DFCNQD1HVT smc_wset_precgnd_reg (.D ( smc_wset_precgnd538 ) 
    , .CP ( clk_b_G5B1I3ASTHIRNet297 ) , .Q ( n1519 ) , .CDN ( rst_bASThfnNet19 ) ) ;
DFCNQD1HVT smc_rrst_pullwlen_reg (.D ( smc_rrst_pullwlen514 ) 
    , .CP ( clk_b_G5B1I3ASTHIRNet297 ) , .Q ( n1527 ) , .CDN ( rst_bASThfnNet19 ) ) ;
INVD2HVT U632 (.I ( n1402 ) , .ZN ( smc_row_inc ) ) ;
INVD2HVT U634 (.I ( n1404 ) , .ZN ( cm_clk ) ) ;
DFCNQD1HVT smc_rpull_b_reg (.D ( smc_rpull_b508 ) 
    , .CP ( clk_b_G5B1I3ASTHIRNet297 ) , .Q ( n1525 ) , .CDN ( rst_bASThfnNet19 ) ) ;
DFCNQD1HVT cram_reading_int_d4_reg (.D ( cram_reading_int_d3 ) 
    , .CP ( spi_clk_out_GB_G4B2I17ASTHIRNet236 ) , .Q ( cram_reading ) 
    , .CDN ( rst_bASThfnNet18 ) ) ;
DFCNQD1HVT smc_wset_prec_reg (.D ( n1394 ) , .CP ( clk_b_G5B1I3ASTHIRNet297 ) 
    , .Q ( n1516 ) , .CDN ( rst_bASThfnNet19 ) ) ;
DFCNQD1HVT smc_rwl_en_reg (.D ( n1393 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .Q ( n1521 ) 
    , .CDN ( rst_bASThfnNet19 ) ) ;
DFCNQD1HVT smc_wwlwrt_en_reg (.D ( n1385 ) , .CP ( clk_b_G5B1I3ASTHIRNet297 ) 
    , .Q ( n1520 ) , .CDN ( rst_bASThfnNet19 ) ) ;
DFCNQD1HVT smc_row_inc_en_reg (.D ( smc_row_inc_en287 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .Q ( smc_row_inc_en ) 
    , .CDN ( rst_bASThfnNet19 ) ) ;
CKND8HVT U653 (.I ( n1424 ) , .ZN ( smc_wset_precgnd ) ) ;
CKND8HVT U636 (.I ( n1406 ) , .ZN ( smc_wwlwrt_en ) ) ;
CKND8HVT U638 (.I ( n1408 ) , .ZN ( smc_rprec ) ) ;
INR3D0HVT U659 (.B2 ( n1458 ) , .A1 ( cram_wrt ) , .ZN ( data_muxsel1496 ) 
    , .B1 ( n1377 ) ) ;
CKLNQD8HVT CM_ROW_INC (.E ( smc_row_inc_en ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .Q ( n1515 ) , .TE ( aLogic0_ ) ) ;
CKLNQD8HVT CM_CLKb (.E ( cram_clk_en_i ) 
    , .CP ( spi_clk_out_GB_G4B2I19ASTHIRNet57 ) , .Q ( n1513 ) 
    , .TE ( tm_dis_cram_clk_gating ) ) ;
TIELHVT U662 (.ZN ( aLogic0_ ) ) ;
DFCND1HVT state_reg_1_ (.Q ( state_1_ ) , .CDN ( rst_bASThfnNet18 ) 
    , .QN ( n1489 ) , .D ( next_1_ ) , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) ) ;
CKND8HVT U657 (.I ( n1428 ) , .ZN ( smc_rwl_en ) ) ;
CKND8HVT U640 (.I ( n1410 ) , .ZN ( smc_wcram_rst ) ) ;
CKND8HVT U642 (.I ( n1412 ) , .ZN ( data_muxsel1 ) ) ;
CKND8HVT U644 (.I ( n1414 ) , .ZN ( smc_rpull_b ) ) ;
CKND8HVT U646 (.I ( n1416 ) , .ZN ( smc_wwlwrt_dis ) ) ;
CKND8HVT U648 (.I ( n1418 ) , .ZN ( data_muxsel ) ) ;
CKND8HVT U650 (.I ( n1420 ) , .ZN ( smc_wset_prec ) ) ;
CKND8HVT U651 (.I ( n1422 ) , .ZN ( smc_wdis_dclk ) ) ;
EDFCND1HVT dummycnt_reg_2_ (.E ( n710_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .D ( dummycnt709_2 ) 
    , .QN ( n1432 ) , .Q ( dummycnt_2_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT dummycnt_reg_1_ (.E ( n710_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) , .D ( dummycnt709_1 ) 
    , .QN ( n1435 ) , .Q ( dummycnt_1_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT dummycnt_reg_0_ (.E ( n710_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) , .D ( dummycnt709_0 ) 
    , .QN ( dummycnt711_0 ) , .Q ( dummycnt_0_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT auxcnt_reg_2_ (.E ( n788_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .D ( auxcnt787_2 ) 
    , .QN ( n1436 ) , .Q ( auxcnt_2_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT auxcnt_reg_1_ (.E ( n788_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .D ( auxcnt787_1 ) 
    , .QN ( n1371 ) , .Q ( auxcnt_1_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT auxcnt_reg_0_ (.E ( n788_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .D ( auxcnt787_0 ) 
    , .QN ( auxcnt789_0 ) , .Q ( auxcnt_0_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_15_ (.E ( n1400 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet282 ) , .D ( flencnt896_15 ) 
    , .Q ( flencnt_15_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
CKND8HVT U655 (.I ( n1426 ) , .ZN ( smc_rrst_pullwlen ) ) ;
EDFCND1HVT flencnt_reg_13_ (.E ( n1401 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet282 ) , .D ( flencnt896_13 ) 
    , .Q ( flencnt_13_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_12_ (.E ( n1400 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet282 ) , .D ( flencnt896_12 ) 
    , .QN ( n1315 ) , .Q ( flencnt_12_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_11_ (.E ( n1400 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet113 ) , .D ( flencnt896_11 ) 
    , .QN ( n1316 ) , .Q ( flencnt_11_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_10_ (.E ( n1401 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet113 ) , .D ( flencnt896_10 ) 
    , .Q ( flencnt_10_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_9_ (.E ( n1401 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet113 ) , .D ( flencnt896_9 ) 
    , .Q ( flencnt_9_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_8_ (.E ( n1400 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet282 ) , .D ( flencnt896_8 ) 
    , .Q ( flencnt_8_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_7_ (.E ( n1401 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet113 ) , .D ( flencnt896_7 ) 
    , .QN ( n1314 ) , .Q ( flencnt_7_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT dummycnt_reg_3_ (.E ( n710_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) , .D ( dummycnt709_3 ) 
    , .QN ( n1433 ) , .Q ( dummycnt_3_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_5_ (.E ( n1401 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .D ( flencnt896_5 ) 
    , .QN ( n1352 ) , .Q ( flencnt_5_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_4_ (.E ( n1401 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .D ( flencnt896_4 ) 
    , .QN ( n1477 ) , .Q ( flencnt_4_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_3_ (.E ( n1400 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .D ( flencnt896_3 ) 
    , .QN ( n1476 ) , .Q ( flencnt_3_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_2_ (.E ( n1401 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .D ( flencnt896_2 ) 
    , .QN ( n1470 ) , .Q ( flencnt_2_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_1_ (.E ( n1401 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .D ( flencnt896_1 ) 
    , .QN ( n1456 ) , .Q ( flencnt_1_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT flencnt_reg_0_ (.E ( n1400 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .D ( flencnt896_0 ) 
    , .QN ( n1475 ) , .Q ( flencnt_0_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT fnumcnt_reg_8_ (.E ( n976_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet77 ) , .D ( fnumcnt975_8 ) 
    , .Q ( fnumcnt_8_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT flencnt_reg_14_ (.E ( n1400 ) 
    , .CP ( spi_clk_out_GB_G4B2I23ASTHIRNet282 ) , .D ( flencnt896_14 ) 
    , .Q ( flencnt_14_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT fnumcnt_reg_6_ (.E ( n976_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet77 ) , .D ( fnumcnt975_6 ) 
    , .Q ( fnumcnt_6_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT fnumcnt_reg_5_ (.E ( n976_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I26ASTHNet300 ) , .D ( fnumcnt975_5 ) 
    , .QN ( n1337 ) , .Q ( fnumcnt_5_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT fnumcnt_reg_4_ (.E ( n976_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet77 ) , .D ( fnumcnt975_4 ) 
    , .QN ( n1336 ) , .Q ( fnumcnt_4_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT fnumcnt_reg_3_ (.E ( n976_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet77 ) , .D ( fnumcnt975_3 ) 
    , .QN ( n1335 ) , .Q ( fnumcnt_3_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT fnumcnt_reg_2_ (.E ( n976_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet77 ) , .D ( fnumcnt975_2 ) 
    , .QN ( n1341 ) , .Q ( fnumcnt_2_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT fnumcnt_reg_1_ (.E ( n976_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet77 ) , .D ( fnumcnt975_1 ) 
    , .QN ( n1339 ) , .Q ( fnumcnt_1_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT fnumcnt_reg_0_ (.E ( n976_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet77 ) , .D ( fnumcnt975_0 ) 
    , .QN ( n1340 ) , .Q ( fnumcnt_0_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT flencnt_reg_6_ (.E ( n1400 ) 
    , .CP ( spi_clk_out_GB_G4B2I25ASTHIRNet113 ) , .D ( flencnt896_6 ) 
    , .QN ( n1351 ) , .Q ( flencnt_6_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT stwrt_fnumcnt_reg_7_ (.E ( n1054_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet215 ) , .D ( stwrt_fnumcnt1053_7 ) 
    , .QN ( n1355 ) , .Q ( stwrt_fnumcnt_7_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT stwrt_fnumcnt_reg_6_ (.E ( n1054_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet215 ) , .D ( stwrt_fnumcnt1053_6 ) 
    , .Q ( stwrt_fnumcnt_6_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT stwrt_fnumcnt_reg_5_ (.E ( n1054_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet215 ) , .D ( stwrt_fnumcnt1053_5 ) 
    , .QN ( n1359 ) , .Q ( stwrt_fnumcnt_5_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT stwrt_fnumcnt_reg_4_ (.E ( n1054_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet215 ) , .D ( stwrt_fnumcnt1053_4 ) 
    , .QN ( n1357 ) , .Q ( stwrt_fnumcnt_4_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT stwrt_fnumcnt_reg_3_ (.E ( n1054_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet215 ) , .D ( stwrt_fnumcnt1053_3 ) 
    , .QN ( n1360 ) , .Q ( stwrt_fnumcnt_3_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT stwrt_fnumcnt_reg_2_ (.E ( n1054_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet215 ) , .D ( stwrt_fnumcnt1053_2 ) 
    , .QN ( n1358 ) , .Q ( stwrt_fnumcnt_2_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT stwrt_fnumcnt_reg_1_ (.E ( n1054_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet215 ) , .D ( stwrt_fnumcnt1053_1 ) 
    , .Q ( stwrt_fnumcnt_1_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT fnumcnt_reg_7_ (.E ( n976_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I22ASTHIRNet77 ) , .D ( fnumcnt975_7 ) 
    , .QN ( n1338 ) , .Q ( fnumcnt_7_ ) , .CDN ( rst_bASThfnNet19 ) ) ;
OR3D0HVT U675 (.A1 ( flencnt_4_ ) , .A2 ( n1470 ) , .Z ( n1471 ) , .A3 ( n1466 ) ) ;
OR3D0HVT U677 (.A1 ( flencnt_3_ ) , .A2 ( n1467 ) , .Z ( n1473 ) , .A3 ( n1472 ) ) ;
OR3D0HVT U679 (.A1 ( state_2_ ) , .A2 ( n1494 ) , .Z ( n1495 ) , .A3 ( n1459 ) ) ;
OR3D0HVT U688 (.A1 ( n1475 ) , .A2 ( n1456 ) , .Z ( n1509 ) , .A3 ( n1471 ) ) ;
EDFCND1HVT stwrt_fnumcnt_reg_0_ (.E ( n1054_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I24ASTHIRNet215 ) , .D ( stwrt_fnumcnt1053_0 ) 
    , .QN ( n1361 ) , .Q ( stwrt_fnumcnt_0_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT cram_reading_int_reg (.E ( n_279 ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) , .D ( n1378 ) 
    , .Q ( cram_reading_int ) , .CDN ( rst_bASThfnNet18 ) ) ;
EDFCND1HVT smc_wdis_dclk_reg (.E ( n_472 ) , .CP ( clk_b_G5B1I3ASTHIRNet297 ) 
    , .D ( n1389 ) , .QN ( n1422 ) , .CDN ( rst_bASThfnNet19 ) ) ;
EDFCND1HVT stwrt_fnumcnt_reg_8_ (.E ( n1054_0 ) 
    , .CP ( spi_clk_out_GB_G4B2I20ASTHIRNet258 ) , .D ( stwrt_fnumcnt1053_8 ) 
    , .QN ( n1356 ) , .Q ( stwrt_fnumcnt_8_ ) , .CDN ( rst_bASThfnNet18 ) ) ;
OR2D0HVT U692 (.A2 ( n1459 ) , .A1 ( cor_security_rddis ) , .Z ( n1503 ) ) ;
OR2D0HVT U666 (.A2 ( n1439 ) , .A1 ( cram_reading ) , .Z ( cram_clk_en_i ) ) ;
OR2D0HVT U669 (.A2 ( n1457 ) , .A1 ( dummycnt711_3 ) , .Z ( dummycnt709_3 ) ) ;
OR2D0HVT U670 (.A2 ( n1457 ) , .A1 ( dummycnt711_2 ) , .Z ( dummycnt709_2 ) ) ;
OR2D0HVT U671 (.A2 ( n1457 ) , .A1 ( dummycnt711_0 ) , .Z ( dummycnt709_0 ) ) ;
OR2D0HVT U676 (.A2 ( n1471 ) , .A1 ( flencnt_0_ ) , .Z ( n1472 ) ) ;
OR2D0HVT U663 (.Z ( n1054_0 ) , .A1 ( smc_rsr_rst ) , .A2 ( n1451 ) ) ;
OR3D0HVT U667 (.A1 ( cram_clr ) , .A2 ( n1449 ) , .Z ( n710_0 ) , .A3 ( n1450 ) ) ;
MOAI22D0HVT U681 (.ZN ( n1497 ) , .B2 ( n1467 ) , .A1 ( n1478 ) , .A2 ( n1492 ) 
    , .B1 ( n1391 ) ) ;
MOAI22D0HVT U690 (.ZN ( n1511 ) , .B2 ( n1467 ) , .A1 ( n1500 ) , .A2 ( n1494 ) 
    , .B1 ( cram_rd ) ) ;
MOAI22D0HVT U691 (.ZN ( n1461 ) , .B2 ( cram_rd ) , .A1 ( n1478 ) 
    , .A2 ( n1460 ) , .B1 ( n1379 ) ) ;
OR4D0HVT U674 (.Z ( n1453 ) , .A2 ( flencnt_2_ ) , .A4 ( n1466 ) 
    , .A3 ( flencnt_3_ ) , .A1 ( flencnt_4_ ) ) ;
OR4D0HVT U680 (.Z ( n1463 ) , .A2 ( n1496 ) , .A4 ( state_0_ ) 
    , .A3 ( state_1_ ) , .A1 ( n1469 ) ) ;
OR4D0HVT U684 (.Z ( n1451 ) , .A2 ( stwrt_fnumcnt_1_ ) , .A4 ( n1499 ) 
    , .A3 ( n1498 ) , .A1 ( stwrt_fnumcnt_6_ ) ) ;
OR2D0HVT U678 (.A2 ( cram_rd ) , .A1 ( cram_wrt ) , .Z ( n1447 ) ) ;
OR2D0HVT U682 (.A2 ( n1497 ) , .A1 ( n1369 ) , .Z ( n1448 ) ) ;
OA21D0HVT U689 (.B ( n1469 ) , .A1 ( cor_security_wrtdis ) , .Z ( n1502 ) 
    , .A2 ( n1467 ) ) ;
CKAN2D1HVT U455 (.Z ( n1312 ) , .A1 ( dummycnt711_0 ) , .A2 ( n1435 ) ) ;
INR2D0HVT U456 (.ZN ( n1375 ) , .A1 ( cm_last_rsr ) , .B1 ( n1449 ) ) ;
AO32D0HVT U457 (.B1 ( n1364 ) , .A1 ( n1385 ) , .Z ( n1462 ) , .B2 ( cram_rd ) 
    , .A2 ( n1318 ) , .A3 ( n1376 ) ) ;
AO221D0HVT U458 (.B1 ( dummycnt_1_ ) , .B2 ( dummycnt_0_ ) , .C ( n1457 ) 
    , .A2 ( n1435 ) , .A1 ( dummycnt711_0 ) , .Z ( dummycnt709_1 ) ) ;
AO221D0HVT U575 (.B1 ( n1394 ) , .B2 ( n1459 ) , .C ( n1387 ) , .A2 ( n1451 ) 
    , .A1 ( n1386 ) , .Z ( smc_row_inc_en287 ) ) ;
MOAI22D0HVT U668 (.ZN ( smc_wcram_rst532 ) , .B2 ( cram_clr ) , .A1 ( n1452 ) 
    , .A2 ( n1453 ) , .B1 ( n1388 ) ) ;
MOAI22D0HVT U672 (.ZN ( data_muxsel502 ) , .B2 ( n1380 ) , .A1 ( n1459 ) 
    , .A2 ( n1460 ) , .B1 ( n1379 ) ) ;
endmodule




module config_top (cm_sdo_u0 , cm_sdo_u1 , cm_sdi_u2 , cm_sdi_u0 , 
    smc_rwl_en , data_muxsel1 , spi_clk_out , spi_sdo , 
    osc_clkASTHIRNet250 , spi_clk_out_GBASTHIRNet165 , warmboot_sel , 
    smc_osc_fsel , smc_row_inc , smc_wset_prec , smc_wwlwrt_dis , 
    smc_wcram_rst , smc_wset_precgnd , smc_wwlwrt_en , smc_wdis_dclk , 
    data_muxsel , j_idcode_reg , psdi , psdo , cm_banksel , cm_sdo_u3 , 
    bm_bank_sdi , cm_sdo_u2 , coldboot_sel , cm_sdi_u1 , smc_rpull_b , 
    smc_rprec , smc_rrst_pullwlen , bm_clk , bm_sweb , bm_sreb , 
    bm_bank_sdo , cm_sdi_u3 , cm_monitor_cell , 
    spi_clk_out_GBASTHIRNet163 , j_tck_GBASTHIRNet97 , bm_sa , bm_sclkrw , 
    bm_wdummymux_en , bm_rcapmux_en , bm_init , bm_banksel , 
    nvcm_spi_sdo_oe_b , nvcm_relextspi , nvcm_boot , nvcm_rdy , bp0 , 
    creset_b , osc_clk , por_b , md_jtag , j_tck , j_tdi , j_rst_b , 
    j_cfg_enable , j_cfg_disable , cnt_podt_out , nvcm_spi_sdo , 
    j_sft_dr , j_usercode , spi_ss_in_b , spi_clk_in , spi_sdi , 
    cm_last_rsr , cdone_in , boot , smc_podt_off , smc_oscoff_b , 
    gint_hz , gio_hz , gsr , en_8bconfig_b , j_cfg_program , j_cap_dr , 
    nvcm_spi_sdi , smc_load_nvcm_bstream , cdone_out , j_tdo , md_spi_b , 
    spi_ss_out_b , rst_b , smc_podt_rst , spi_sdo_oe_b , cm_clk , 
    smc_write , smc_read , smc_seq_rst , smc_rsr_rst , end_of_startup , 
    nvcm_spi_ss_b );
input  [1:0] cm_sdo_u0 ;
input  [1:0] cm_sdo_u1 ;
output [1:0] cm_sdi_u2 ;
output [1:0] cm_sdi_u0 ;
output smc_rwl_en ;
output data_muxsel1 ;
output spi_clk_out ;
output spi_sdo ;
input  osc_clkASTHIRNet250 ;
input  spi_clk_out_GBASTHIRNet165 ;
input  [1:0] warmboot_sel ;
output [1:0] smc_osc_fsel ;
output smc_row_inc ;
output smc_wset_prec ;
output smc_wwlwrt_dis ;
output smc_wcram_rst ;
output smc_wset_precgnd ;
output smc_wwlwrt_en ;
output smc_wdis_dclk ;
output data_muxsel ;
input  [31:0] j_idcode_reg ;
input  [7:1] psdi ;
output [7:1] psdo ;
output [3:0] cm_banksel ;
input  [1:0] cm_sdo_u3 ;
output [3:0] bm_bank_sdi ;
input  [1:0] cm_sdo_u2 ;
input  [1:0] coldboot_sel ;
output [1:0] cm_sdi_u1 ;
output smc_rpull_b ;
output smc_rprec ;
output smc_rrst_pullwlen ;
output bm_clk ;
output bm_sweb ;
output bm_sreb ;
input  [3:0] bm_bank_sdo ;
output [1:0] cm_sdi_u3 ;
input  [3:0] cm_monitor_cell ;
output spi_clk_out_GBASTHIRNet163 ;
input  j_tck_GBASTHIRNet97 ;
output [7:0] bm_sa ;
output bm_sclkrw ;
output bm_wdummymux_en ;
output bm_rcapmux_en ;
output bm_init ;
output [3:0] bm_banksel ;
input  nvcm_spi_sdo_oe_b ;
input  nvcm_relextspi ;
input  nvcm_boot ;
input  nvcm_rdy ;
input  bp0 ;
input  creset_b ;
input  osc_clk ;
input  por_b ;
input  md_jtag ;
input  j_tck ;
input  j_tdi ;
input  j_rst_b ;
input  j_cfg_enable ;
input  j_cfg_disable ;
input  cnt_podt_out ;
input  nvcm_spi_sdo ;
input  j_sft_dr ;
input  j_usercode ;
input  spi_ss_in_b ;
input  spi_clk_in ;
input  spi_sdi ;
input  cm_last_rsr ;
input  cdone_in ;
input  boot ;
output smc_podt_off ;
output smc_oscoff_b ;
output gint_hz ;
output gio_hz ;
output gsr ;
output en_8bconfig_b ;
input  j_cfg_program ;
input  j_cap_dr ;
output nvcm_spi_sdi ;
output smc_load_nvcm_bstream ;
output cdone_out ;
output j_tdo ;
output md_spi_b ;
output spi_ss_out_b ;
output rst_b ;
output smc_podt_rst ;
output spi_sdo_oe_b ;
output cm_clk ;
output smc_write ;
output smc_read ;
output smc_seq_rst ;
output smc_rsr_rst ;
output end_of_startup ;
output nvcm_spi_ss_b ;

/* wire declarations */
wire spi_clk_out_GB_G4B2I4ASTHIRNet239 ;
wire spi_clk_out_GB_G4B2I2ASTHIRNet133 ;
wire spi_clk_out_GB_G4B2I3ASTHIRNet43 ;
wire startup_req ;
wire shutdown_req ;
wire warmboot_req ;
wire reboot_source_nvcm ;
wire end_of_shutdown ;
wire cram_done ;
wire sample_mode_done ;
wire md_spi ;
wire cfg_ld_bstream ;
wire cfg_startup ;
wire cfg_shutdown ;
wire cram_access_en ;
wire cram_clr_done ;
wire cram_clr_done_r ;
wire fpga_operation ;
wire spi_master_go ;
wire framelen_5_ ;
wire framelen_4_ ;
wire framelen_3_ ;
wire framelen_2_ ;
wire framelen_1_ ;
wire framelen_0_ ;
wire spi_clk_out_GB_G4B2I23ASTHIRNet278 ;
wire framelen_13_ ;
wire framelen_12_ ;
wire framelen_11_ ;
wire framelen_10_ ;
wire framelen_9_ ;
wire framelen_8_ ;
wire framelen_7_ ;
wire framelen_6_ ;
wire spi_clk_out_GB_G4B2I15ASTHIRNet120 ;
wire spi_clk_out_GB_G4B2I25ASTHIRNet109 ;
wire spi_clk_out_GB_G4B2I22ASTHIRNet71 ;
wire spi_clk_out_GB_G4B2I19ASTHIRNet51 ;
wire baddr_1_ ;
wire baddr_0_ ;
wire framelen_15_ ;
wire framelen_14_ ;
wire framenum_7_ ;
wire framenum_6_ ;
wire framenum_5_ ;
wire framenum_4_ ;
wire framenum_3_ ;
wire framenum_2_ ;
wire framenum_1_ ;
wire framenum_0_ ;
wire start_framenum_6_ ;
wire start_framenum_5_ ;
wire start_framenum_4_ ;
wire start_framenum_3_ ;
wire start_framenum_2_ ;
wire start_framenum_1_ ;
wire start_framenum_0_ ;
wire framenum_8_ ;
wire start_framenum_7_ ;
wire tm_dis_bram_clk_gating ;
wire cor_en_8bconfig ;
wire cor_security_rddis ;
wire cor_security_wrtdis ;
wire gwe ;
wire bram_reading ;
wire bram_wrt ;
wire bram_rd ;
wire spi_clk_out_GB_G4B2I17ASTHIRNet232 ;
wire spi_clk_out_GB_G4B2I24ASTHIRNet211 ;
wire clk_b_G5B1I1ASTHIRNet202 ;
wire spi_clk_out_GB_G4B2I21ASTHIRNet178 ;
wire spi_clk_out_GB_G4B2I5ASTHIRNet166 ;
wire spi_clk_out_GB_G4B2I18ASTHIRNet148 ;
wire bram_done ;
wire j_tck_GB_G2B8I1ASTHIRNet265 ;
wire clk_bASTHIRNet145 ;
wire osc_clk_G1B8I1ASTHIRNet64 ;
wire spi_clk_out_GB_G4B1I2ASTHIRNet304 ;
wire rst_bASTHIRNet31 ;
wire usercode_reg_5_ ;
wire usercode_reg_4_ ;
wire usercode_reg_3_ ;
wire usercode_reg_2_ ;
wire usercode_reg_1_ ;
wire usercode_reg_0_ ;
wire usercode_reg_13_ ;
wire usercode_reg_12_ ;
wire usercode_reg_11_ ;
wire usercode_reg_10_ ;
wire usercode_reg_9_ ;
wire usercode_reg_8_ ;
wire usercode_reg_7_ ;
wire usercode_reg_6_ ;
wire usercode_reg_21_ ;
wire usercode_reg_20_ ;
wire usercode_reg_19_ ;
wire usercode_reg_18_ ;
wire usercode_reg_17_ ;
wire usercode_reg_16_ ;
wire usercode_reg_15_ ;
wire usercode_reg_14_ ;
wire usercode_reg_29_ ;
wire usercode_reg_28_ ;
wire usercode_reg_27_ ;
wire usercode_reg_26_ ;
wire usercode_reg_25_ ;
wire usercode_reg_24_ ;
wire usercode_reg_23_ ;
wire usercode_reg_22_ ;
wire j_usercode_tdo ;
wire usercode_reg_31_ ;
wire usercode_reg_30_ ;
wire sdo_5_ ;
wire sdo_4_ ;
wire sdo_3_ ;
wire sdo_2_ ;
wire sdo_1_ ;
wire sdo_0_ ;
wire clk_b_G5B1I2ASTHIRNet104 ;
wire spi_clk_out_GB_G4B2I16ASTHIRNet36 ;
wire sdo_7_ ;
wire sdo_6_ ;
wire en_daisychain_cfg ;
wire spi_ss_out_b_int ;
wire access_nvcm_reg ;
wire sdi ;
wire clk_b_G5B1I3ASTHIRNet293 ;
wire spi_clk_out_GB_G4B1I1ASTHIRNet117 ;
wire spi_clk_out_GB_G4B2I1ASTHIRNet225 ;
wire spi_clk_out_GB_G4B2I20ASTHIRNet256 ;
wire cram_reading ;
wire tm_dis_cram_clk_gating ;
wire n453 ;
wire cor_en_oscclk ;
wire start_framenum_8_ ;

wire j_tck_GB_G2B5I1ASTHNet277 ;
wire j_tck_GB_G2B4I1_1ASTHNet83 ;
wire j_tck_GB_G2B3I1_1ASTHNet190 ;
wire osc_clk_G1B1I1_1ASTHNet187 ;
wire j_tck_GB_G2B2I1_1ASTHNet275 ;
wire j_tck_GB_G2B1I1_1ASTHNet80 ;
wire j_tck_GB_G2B7I1ASTHNet61 ;
wire j_tck_GB_G2B6I1ASTHNet210 ;
wire osc_clk_G1B4I1_1ASTHNet189 ;
wire osc_clk_G1B3I1_1ASTHNet274 ;
wire osc_clk_G1B2I1_1ASTHNet79 ;
wire osc_clk_G1B7I1ASTHNet177 ;
wire osc_clk_G1B6I1ASTHNet255 ;
wire osc_clk_G1B5I1_1ASTHNet82 ;


cfg_smc CFG_SMC (
    .spi_clk_out_GB_G4B2I4ASTHIRNet247 ( spi_clk_out_GB_G4B2I4ASTHIRNet239 ) , 
    .spi_clk_out_GB_G4B2I2ASTHIRNet137 ( spi_clk_out_GB_G4B2I2ASTHIRNet133 ) , 
    .spi_clk_out_GB_G4B2I3ASTHIRNet47 ( spi_clk_out_GB_G4B2I3ASTHIRNet43 ) , 
    .rst_b ( rst_b ) , .cnt_podt_out ( cnt_podt_out ) , 
    .startup_req ( startup_req ) , .shutdown_req ( shutdown_req ) , 
    .warmboot_req ( warmboot_req ) , .reboot_source_nvcm ( reboot_source_nvcm ) , 
    .end_of_startup ( end_of_startup ) , .end_of_shutdown ( end_of_shutdown ) , 
    .md_jtag ( md_jtag ) , .spi_ss_in_b ( spi_ss_in_b ) , 
    .cram_done ( cram_done ) , .nvcm_boot ( nvcm_boot ) , .nvcm_rdy ( nvcm_rdy ) , 
    .sample_mode_done ( sample_mode_done ) , .md_spi ( md_spi ) , 
    .cram_clr ( smc_seq_rst ) , .cfg_ld_bstream ( cfg_ld_bstream ) , 
    .cfg_startup ( cfg_startup ) , .cfg_shutdown ( cfg_shutdown ) , 
    .cram_access_en ( cram_access_en ) , .cram_clr_done ( cram_clr_done ) , 
    .cram_clr_done_r ( cram_clr_done_r ) , .fpga_operation ( fpga_operation ) , 
    .spi_master_go ( spi_master_go ) , 
    .smc_load_nvcm_bstream ( smc_load_nvcm_bstream ) ) ;


bram_smc BRAM_SMC (
    .spi_clk_out_GB_G4B2I23ASTHIRNet280 ( spi_clk_out_GB_G4B2I23ASTHIRNet278 ) , 
    .spi_clk_out_GB_G4B2I15ASTHIRNet130 ( spi_clk_out_GB_G4B2I15ASTHIRNet120 ) , 
    .spi_clk_out_GB_G4B2I25ASTHIRNet111 ( spi_clk_out_GB_G4B2I25ASTHIRNet109 ) , 
    .spi_clk_out_GB_G4B2I22ASTHIRNet75 ( spi_clk_out_GB_G4B2I22ASTHIRNet71 ) , 
    .spi_clk_out_GB_G4B2I19ASTHIRNet55 ( spi_clk_out_GB_G4B2I19ASTHIRNet51 ) , 
    .baddr ( {baddr_1_ , baddr_0_ } ) , 
    .flen ( {framelen_15_ , framelen_14_ , framelen_13_ , framelen_12_ , 
	framelen_11_ , framelen_10_ , framelen_9_ , framelen_8_ , 
	framelen_7_ , framelen_6_ , framelen_5_ , framelen_4_ , framelen_3_ , 
	framelen_2_ , framelen_1_ , framelen_0_ } ) , 
    .fnum ( {framenum_8_ , framenum_7_ , framenum_6_ , framenum_5_ , 
	framenum_4_ , framenum_3_ , framenum_2_ , framenum_1_ , framenum_0_ } ) , 
    .start_fnum ( {1'b0, start_framenum_7_ , start_framenum_6_ , start_framenum_5_ , 
	start_framenum_4_ , start_framenum_3_ , start_framenum_2_ , 
	start_framenum_1_ , start_framenum_0_ } ) , 
    .rst_b ( rst_b ) , .tm_dis_bram_clk_gating ( tm_dis_bram_clk_gating ) , 
    .bm_banksel ( bm_banksel ) , .bm_sa ( bm_sa ) , 
    .cor_en_8bconfig ( cor_en_8bconfig ) , 
    .cor_security_rddis ( cor_security_rddis ) , 
    .cor_security_wrtdis ( cor_security_wrtdis ) , .gwe ( gwe ) , 
    .bram_access_en ( cfg_ld_bstream ) , .bram_reading ( bram_reading ) , 
    .bm_sweb ( bm_sweb ) , .bm_sreb ( bm_sreb ) , .bm_sclkrw ( bm_sclkrw ) , 
    .bm_wdummymux_en ( bm_wdummymux_en ) , .bm_rcapmux_en ( bm_rcapmux_en ) , 
    .bm_init ( bm_init ) , .bram_wrt ( bram_wrt ) , .bram_rd ( bram_rd ) , 
    .spi_clk_out_GB_G4B2I17ASTHIRNet238 ( spi_clk_out_GB_G4B2I17ASTHIRNet232 ) , 
    .spi_clk_out_GB_G4B2I24ASTHIRNet217 ( spi_clk_out_GB_G4B2I24ASTHIRNet211 ) , 
    .clk_b_G5B1I1ASTHIRNet208 ( clk_b_G5B1I1ASTHIRNet202 ) , 
    .spi_clk_out_GB_G4B2I21ASTHIRNet182 ( spi_clk_out_GB_G4B2I21ASTHIRNet178 ) , 
    .spi_clk_out_GB_G4B2I5ASTHIRNet172 ( spi_clk_out_GB_G4B2I5ASTHIRNet166 ) , 
    .spi_clk_out_GB_G4B2I18ASTHIRNet150 ( spi_clk_out_GB_G4B2I18ASTHIRNet148 ) , 
    .bram_done ( bram_done ) , .bm_clk ( bm_clk ) ) ;


clkgen CLKGEN (.j_tck_GB_G2B8I1ASTHIRNet269 ( j_tck_GB_G2B8I1ASTHIRNet265 ) , 
    .osc_clkASTHIRNet254 ( osc_clkASTHIRNet250 ) , 
    .spi_clk_out_GBASTHIRNet161 ( spi_clk_out_GBASTHIRNet163 ) , 
    .clk_bASTHIRNet147 ( clk_bASTHIRNet145 ) , 
    .j_tck_GBASTHIRNet101 ( j_tck_GBASTHIRNet97 ) , 
    .osc_clk_G1B8I1ASTHIRNet70 ( osc_clk_G1B8I1ASTHIRNet64 ) , .rst_b ( rst_b ) , 
    .spi_clk_out_GB_G4B1I2ASTHIRNet306 ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) , 
    .cclk ( spi_clk_in ) , .end_of_startup ( end_of_startup ) , 
    .sample_mode_done ( sample_mode_done ) , .md_spi ( md_spi ) , 
    .md_jtag ( md_jtag ) ) ;


rstbgen RSTBGEN (.osc_clk_G1B8I1ASTHIRNet66 ( osc_clk_G1B8I1ASTHIRNet64 ) , 
    .por_b ( por_b ) , .creset_b ( creset_b ) , .rst_b ( rst_bASTHIRNet31 ) ) ;


jtag_usercode JTAG_USERCODE (.j_cap_dr ( j_cap_dr ) , 
    .j_usercode ( j_usercode ) , .j_sft_dr ( j_sft_dr ) , 
    .j_usercode_tdo ( j_usercode_tdo ) , 
    .j_tck_GB_G2B8I1ASTHIRNet271 ( j_tck_GB_G2B8I1ASTHIRNet265 ) , 
    .usercode_reg ( {usercode_reg_31_ , usercode_reg_30_ , usercode_reg_29_ , 
	usercode_reg_28_ , usercode_reg_27_ , usercode_reg_26_ , 
	usercode_reg_25_ , usercode_reg_24_ , usercode_reg_23_ , 
	usercode_reg_22_ , usercode_reg_21_ , usercode_reg_20_ , 
	usercode_reg_19_ , usercode_reg_18_ , usercode_reg_17_ , 
	usercode_reg_16_ , usercode_reg_15_ , usercode_reg_14_ , 
	usercode_reg_13_ , usercode_reg_12_ , usercode_reg_11_ , 
	usercode_reg_10_ , usercode_reg_9_ , usercode_reg_8_ , 
	usercode_reg_7_ , usercode_reg_6_ , usercode_reg_5_ , usercode_reg_4_ , 
	usercode_reg_3_ , usercode_reg_2_ , usercode_reg_1_ , usercode_reg_0_ } ) ) ;


sdiomux SDIOMUX (.cm_sdi_u0 ( cm_sdi_u0 ) , 
    .clk_b_G5B1I2ASTHIRNet106 ( clk_b_G5B1I2ASTHIRNet104 ) , 
    .spi_clk_out_GB_G4B2I16ASTHIRNet38 ( spi_clk_out_GB_G4B2I16ASTHIRNet36 ) , 
    .sdo ( {sdo_7_ , sdo_6_ , sdo_5_ , sdo_4_ , sdo_3_ , sdo_2_ , sdo_1_ , 
	sdo_0_ } ) , 
    .cm_sdi_u2 ( cm_sdi_u2 ) , .cm_sdi_u1 ( cm_sdi_u1 ) , 
    .bm_bank_sdi ( bm_bank_sdi ) , .rst_b ( rst_b ) , .md_spi ( md_spi ) , 
    .psdo ( psdo ) , .cm_sdi_u3 ( cm_sdi_u3 ) , 
    .en_daisychain_cfg ( en_daisychain_cfg ) , 
    .sample_mode_done ( sample_mode_done ) , .cram_clr_done ( cram_clr_done ) , 
    .cram_clr_done_r ( cram_clr_done_r ) , .j_tdi ( j_tdi ) , 
    .j_usercode ( j_usercode ) , .psdi ( psdi ) , 
    .spi_ss_out_b_int ( spi_ss_out_b_int ) , .spi_sdi ( spi_sdi ) , 
    .access_nvcm_reg ( access_nvcm_reg ) , 
    .smc_load_nvcm_bstream ( smc_load_nvcm_bstream ) , 
    .nvcm_spi_sdo ( nvcm_spi_sdo ) , .nvcm_spi_sdo_oe_b ( nvcm_spi_sdo_oe_b ) , 
    .md_jtag ( md_jtag ) , .en_8bconfig_b ( en_8bconfig_b ) , 
    .md_spi_b ( md_spi_b ) , .spi_ss_out_b ( spi_ss_out_b ) , 
    .spi_sdo ( spi_sdo ) , .sdi ( sdi ) , .nvcm_spi_ss_b ( nvcm_spi_ss_b ) , 
    .nvcm_spi_sdi ( nvcm_spi_sdi ) , .j_usercode_tdo ( j_usercode_tdo ) , 
    .spi_ss_in_b ( spi_ss_in_b ) , 
    .clk_b_G5B1I3ASTHIRNet295 ( clk_b_G5B1I3ASTHIRNet293 ) , 
    .spi_clk_out_GB_G4B2I4ASTHIRNet245 ( spi_clk_out_GB_G4B2I4ASTHIRNet239 ) , 
    .clk_b_G5B1I1ASTHIRNet206 ( clk_b_G5B1I1ASTHIRNet202 ) , 
    .spi_clk_out_GB_G4B2I18ASTHIRNet156 ( spi_clk_out_GB_G4B2I18ASTHIRNet148 ) , 
    .spi_clk_out_GB_G4B2I2ASTHIRNet141 ( spi_clk_out_GB_G4B2I2ASTHIRNet133 ) , 
    .spi_clk_out_GB_G4B2I15ASTHIRNet128 ( spi_clk_out_GB_G4B2I15ASTHIRNet120 ) , 
    .spi_sdo_oe_b ( spi_sdo_oe_b ) , .j_tdo ( j_tdo ) ) ;


bstream_smc BSTREAM_SMC (
    .spi_clk_out_GB_G4B1I1ASTHIRNet119 ( spi_clk_out_GB_G4B1I1ASTHIRNet117 ) , 
    .clk_b_G5B1I2ASTHIRNet108 ( clk_b_G5B1I2ASTHIRNet104 ) , 
    .spi_clk_out_GB_G4B2I22ASTHIRNet73 ( spi_clk_out_GB_G4B2I22ASTHIRNet71 ) , 
    .spi_clk_out_GB_G4B2I19ASTHIRNet53 ( spi_clk_out_GB_G4B2I19ASTHIRNet51 ) , 
    .usercode_reg ( {usercode_reg_31_ , usercode_reg_30_ , usercode_reg_29_ , 
	usercode_reg_28_ , usercode_reg_27_ , usercode_reg_26_ , 
	usercode_reg_25_ , usercode_reg_24_ , usercode_reg_23_ , 
	usercode_reg_22_ , usercode_reg_21_ , usercode_reg_20_ , 
	usercode_reg_19_ , usercode_reg_18_ , usercode_reg_17_ , 
	usercode_reg_16_ , usercode_reg_15_ , usercode_reg_14_ , 
	usercode_reg_13_ , usercode_reg_12_ , usercode_reg_11_ , 
	usercode_reg_10_ , usercode_reg_9_ , usercode_reg_8_ , 
	usercode_reg_7_ , usercode_reg_6_ , usercode_reg_5_ , usercode_reg_4_ , 
	usercode_reg_3_ , usercode_reg_2_ , usercode_reg_1_ , usercode_reg_0_ } ) , 
    .spi_clk_out_GB_G4B2I1ASTHIRNet227 ( spi_clk_out_GB_G4B2I1ASTHIRNet225 ) , 
    .spi_clk_out_GB_G4B2I24ASTHIRNet213 ( spi_clk_out_GB_G4B2I24ASTHIRNet211 ) , 
    .clk_b_G5B1I1ASTHIRNet204 ( clk_b_G5B1I1ASTHIRNet202 ) , 
    .spi_clk_out_GB_G4B2I21ASTHIRNet180 ( spi_clk_out_GB_G4B2I21ASTHIRNet178 ) , 
    .spi_clk_out_GB_G4B2I5ASTHIRNet170 ( spi_clk_out_GB_G4B2I5ASTHIRNet166 ) , 
    .spi_clk_out_GB_G4B2I18ASTHIRNet154 ( spi_clk_out_GB_G4B2I18ASTHIRNet148 ) , 
    .spi_clk_out_GB_G4B2I2ASTHIRNet139 ( spi_clk_out_GB_G4B2I2ASTHIRNet133 ) , 
    .spi_clk_out_GB_G4B2I15ASTHIRNet124 ( spi_clk_out_GB_G4B2I15ASTHIRNet120 ) , 
    .smc_oscoff_b ( smc_oscoff_b ) , .gint_hz ( gint_hz ) , .gio_hz ( gio_hz ) , 
    .cfg_shutdown ( cfg_shutdown ) , 
    .clk_b_G5B1I3ASTHIRNet299 ( clk_b_G5B1I3ASTHIRNet293 ) , 
    .spi_clk_out_GB_G4B2I20ASTHIRNet260 ( spi_clk_out_GB_G4B2I20ASTHIRNet256 ) , 
    .spi_clk_out_GB_G4B2I4ASTHIRNet243 ( spi_clk_out_GB_G4B2I4ASTHIRNet239 ) , 
    .spi_clk_out_GB_G4B2I17ASTHIRNet234 ( spi_clk_out_GB_G4B2I17ASTHIRNet232 ) , 
    .j_cfg_enable ( j_cfg_enable ) , .j_cfg_disable ( j_cfg_disable ) , 
    .j_cfg_program ( j_cfg_program ) , .j_sft_dr ( j_sft_dr ) , 
    .cnt_podt_out ( cnt_podt_out ) , .coldboot_sel ( coldboot_sel ) , 
    .j_idcode_reg ( j_idcode_reg ) , .gwe ( gwe ) , .cdone_in ( cdone_in ) , 
    .smc_osc_fsel ( smc_osc_fsel ) , 
    .framelen ( {framelen_15_ , framelen_14_ , framelen_13_ , framelen_12_ , 
	framelen_11_ , framelen_10_ , framelen_9_ , framelen_8_ , 
	framelen_7_ , framelen_6_ , framelen_5_ , framelen_4_ , framelen_3_ , 
	framelen_2_ , framelen_1_ , framelen_0_ } ) , 
    .cm_sdo_u3 ( cm_sdo_u3 ) , 
    .framenum ( {framenum_8_ , framenum_7_ , framenum_6_ , framenum_5_ , 
	framenum_4_ , framenum_3_ , framenum_2_ , framenum_1_ , framenum_0_ } ) , 
    .cdone_out ( cdone_out ) , .end_of_startup ( end_of_startup ) , 
    .cram_reading ( cram_reading ) , .cram_done ( cram_done ) , 
    .bram_reading ( bram_reading ) , .bram_done ( bram_done ) , 
    .smc_podt_rst ( smc_podt_rst ) , .smc_podt_off ( smc_podt_off ) , 
    .startup_req ( startup_req ) , .shutdown_req ( shutdown_req ) , 
    .cor_security_rddis ( cor_security_rddis ) , 
    .cor_security_wrtdis ( cor_security_wrtdis ) , 
    .spi_clk_out_GB_G4B2I3ASTHIRNet45 ( spi_clk_out_GB_G4B2I3ASTHIRNet43 ) , 
    .spi_clk_out_GB_G4B2I16ASTHIRNet40 ( spi_clk_out_GB_G4B2I16ASTHIRNet36 ) , 
    .reboot_source_nvcm ( reboot_source_nvcm ) , 
    .cor_en_8bconfig ( cor_en_8bconfig ) , .en_8bconfig_b ( en_8bconfig_b ) , 
    .en_daisychain_cfg ( en_daisychain_cfg ) , 
    .tm_dis_cram_clk_gating ( tm_dis_cram_clk_gating ) , 
    .cram_wrt ( smc_write ) , .spi_ss_out_b_int ( spi_ss_out_b_int ) , 
    .access_nvcm_reg ( access_nvcm_reg ) , .cram_rd ( n453 ) , 
    .tm_dis_bram_clk_gating ( tm_dis_bram_clk_gating ) , .bram_wrt ( bram_wrt ) , 
    .bram_rd ( bram_rd ) , .cor_en_oscclk ( cor_en_oscclk ) , 
    .warmboot_req ( warmboot_req ) , .bm_bank_sdo ( bm_bank_sdo ) , 
    .baddr ( {baddr_1_ , baddr_0_ } ) , .cm_sdo_u2 ( cm_sdo_u2 ) , 
    .sdo ( {sdo_7_ , sdo_6_ , sdo_5_ , sdo_4_ , sdo_3_ , sdo_2_ , sdo_1_ , 
	sdo_0_ } ) , 
    .warmboot_sel ( warmboot_sel ) , .cm_monitor_cell ( cm_monitor_cell ) , 
    .cm_sdo_u0 ( cm_sdo_u0 ) , 
    .start_framenum ( {start_framenum_8_ , start_framenum_7_ , start_framenum_6_ , 
	start_framenum_5_ , start_framenum_4_ , start_framenum_3_ , 
	start_framenum_2_ , start_framenum_1_ , start_framenum_0_ } ) , 
    .rst_b ( rst_b ) , .md_spi ( md_spi ) , .sdi ( sdi ) , .boot ( boot ) , 
    .cfg_ld_bstream ( cfg_ld_bstream ) , .cfg_startup ( cfg_startup ) , 
    .cm_sdo_u1 ( cm_sdo_u1 ) , .spi_master_go ( spi_master_go ) , 
    .fpga_operation ( fpga_operation ) , .nvcm_relextspi ( nvcm_relextspi ) , 
    .smc_load_nvcm_bstream ( smc_load_nvcm_bstream ) , .bp0 ( bp0 ) , 
    .md_jtag ( md_jtag ) , .j_rst_b ( j_rst_b ) ) ;


startup_shutdown STARTUP_SHUTDOWN (.warmboot_req ( warmboot_req ) , 
    .cdone_in ( cdone_in ) , .end_of_shutdown ( end_of_shutdown ) , 
    .cdone_out ( cdone_out ) , 
    .spi_clk_out_GB_G4B2I3ASTHIRNet49 ( spi_clk_out_GB_G4B2I3ASTHIRNet43 ) , 
    .rst_b ( rst_b ) , .startup_req ( startup_req ) , 
    .shutdown_req ( shutdown_req ) , .cor_en_oscclk ( cor_en_oscclk ) , 
    .spi_clk_out_GB_G4B2I1ASTHIRNet229 ( spi_clk_out_GB_G4B2I1ASTHIRNet225 ) , 
    .spi_clk_out_GB_G4B2I2ASTHIRNet135 ( spi_clk_out_GB_G4B2I2ASTHIRNet133 ) , 
    .smc_oscoff_b ( smc_oscoff_b ) , .gint_hz ( gint_hz ) , .gio_hz ( gio_hz ) , 
    .gwe ( gwe ) , .gsr ( gsr ) , .end_of_startup ( end_of_startup ) ) ;


cram_smc CRAM_SMC (.baddr ( {baddr_1_ , baddr_0_ } ) , 
    .cm_banksel ( cm_banksel ) , 
    .spi_clk_out_GB_G4B1I2ASTHIRNet308 ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) , 
    .spi_clk_out_GB_G4B2I25ASTHIRNet113 ( spi_clk_out_GB_G4B2I25ASTHIRNet109 ) , 
    .spi_clk_out_GB_G4B2I22ASTHIRNet77 ( spi_clk_out_GB_G4B2I22ASTHIRNet71 ) , 
    .spi_clk_out_GB_G4B2I19ASTHIRNet57 ( spi_clk_out_GB_G4B2I19ASTHIRNet51 ) , 
    .flen ( {framelen_15_ , framelen_14_ , framelen_13_ , framelen_12_ , 
	framelen_11_ , framelen_10_ , framelen_9_ , framelen_8_ , 
	framelen_7_ , framelen_6_ , framelen_5_ , framelen_4_ , framelen_3_ , 
	framelen_2_ , framelen_1_ , framelen_0_ } ) , 
    .stwrt_fnum ( {start_framenum_8_ , start_framenum_7_ , start_framenum_6_ , 
	start_framenum_5_ , start_framenum_4_ , start_framenum_3_ , 
	start_framenum_2_ , start_framenum_1_ , start_framenum_0_ } ) , 
    .rst_b ( rst_b ) , .tm_dis_cram_clk_gating ( tm_dis_cram_clk_gating ) , 
    .cram_wrt ( smc_write ) , 
    .fnum ( {framenum_8_ , framenum_7_ , framenum_6_ , framenum_5_ , 
	framenum_4_ , framenum_3_ , framenum_2_ , framenum_1_ , framenum_0_ } ) , 
    .cor_en_8bconfig ( cor_en_8bconfig ) , 
    .cor_security_rddis ( cor_security_rddis ) , 
    .cor_security_wrtdis ( cor_security_wrtdis ) , 
    .cram_access_en ( cram_access_en ) , .cm_last_rsr ( cm_last_rsr ) , 
    .cram_reading ( cram_reading ) , .smc_rsr_rst ( smc_rsr_rst ) , 
    .smc_row_inc ( smc_row_inc ) , .smc_wset_prec ( smc_wset_prec ) , 
    .smc_wwlwrt_dis ( smc_wwlwrt_dis ) , .smc_wcram_rst ( smc_wcram_rst ) , 
    .smc_wset_precgnd ( smc_wset_precgnd ) , .cram_rd ( n453 ) , 
    .cram_clr ( smc_seq_rst ) , .data_muxsel1 ( data_muxsel1 ) , 
    .smc_wdis_dclk ( smc_wdis_dclk ) , .data_muxsel ( data_muxsel ) , 
    .smc_rpull_b ( smc_rpull_b ) , .smc_rprec ( smc_rprec ) , 
    .smc_rrst_pullwlen ( smc_rrst_pullwlen ) , .cram_done ( cram_done ) , 
    .cm_clk ( cm_clk ) , .clk_b_G5B1I3ASTHIRNet297 ( clk_b_G5B1I3ASTHIRNet293 ) , 
    .spi_clk_out_GB_G4B2I23ASTHIRNet282 ( spi_clk_out_GB_G4B2I23ASTHIRNet278 ) , 
    .spi_clk_out_GB_G4B2I20ASTHIRNet258 ( spi_clk_out_GB_G4B2I20ASTHIRNet256 ) , 
    .spi_clk_out_GB_G4B2I17ASTHIRNet236 ( spi_clk_out_GB_G4B2I17ASTHIRNet232 ) , 
    .spi_clk_out_GB_G4B2I24ASTHIRNet215 ( spi_clk_out_GB_G4B2I24ASTHIRNet211 ) , 
    .spi_clk_out_GB_G4B2I15ASTHIRNet132 ( spi_clk_out_GB_G4B2I15ASTHIRNet120 ) , 
    .smc_wwlwrt_en ( smc_wwlwrt_en ) , .smc_rwl_en ( smc_rwl_en ) ) ;

CKBD12HVT CKBD12HVTG4B2I16 (.Z ( spi_clk_out_GB_G4B2I16ASTHIRNet36 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) ) ;
CKBD12HVT CKBD12HVTG4B1I2 (.Z ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) 
    , .I ( spi_clk_out_GBASTHIRNet165 ) ) ;
CKBD12HVT CKBD12HVTG2B5I1 (.Z ( j_tck_GB_G2B5I1ASTHNet277 ) 
    , .I ( j_tck_GB_G2B4I1_1ASTHNet83 ) ) ;
CKBD12HVT CKBD12HVTG2B4I1_2 (.Z ( j_tck_GB_G2B4I1_1ASTHNet83 ) 
    , .I ( j_tck_GB_G2B3I1_1ASTHNet190 ) ) ;
CKBD12HVT CKBD12HVTG1B1I1 (.Z ( osc_clk_G1B1I1_1ASTHNet187 ) 
    , .I ( osc_clkASTHIRNet250 ) ) ;
INVD6HVT INVD6HVTG2B2I1 (.ZN ( j_tck_GB_G2B2I1_1ASTHNet275 ) 
    , .I ( j_tck_GB_G2B1I1_1ASTHNet80 ) ) ;
CKND16HVT CKND16HVTG2B1I1 (.ZN ( j_tck_GB_G2B1I1_1ASTHNet80 ) 
    , .I ( j_tck_GBASTHIRNet97 ) ) ;
CKBD12HVT CKBD12HVTG4B2I23 (.Z ( spi_clk_out_GB_G4B2I23ASTHIRNet278 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) ) ;
CKBD12HVT CKBD12HVTG4B2I24 (.Z ( spi_clk_out_GB_G4B2I24ASTHIRNet211 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) ) ;
CKBD12HVT CKBD12HVTG5B1I1_1 (.Z ( clk_b_G5B1I1ASTHIRNet202 ) 
    , .I ( clk_bASTHIRNet145 ) ) ;
CKBD12HVT CKBD12HVTG5B1I2_1 (.Z ( clk_b_G5B1I2ASTHIRNet104 ) 
    , .I ( clk_bASTHIRNet145 ) ) ;
CKBD12HVT CKBD12HVTG5B1I3_1 (.Z ( clk_b_G5B1I3ASTHIRNet293 ) 
    , .I ( clk_bASTHIRNet145 ) ) ;
CKBD12HVT CKBD12HVTG4B2I22 (.Z ( spi_clk_out_GB_G4B2I22ASTHIRNet71 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) ) ;
CKBD12HVT CKBD12HVTG4B2I25 (.Z ( spi_clk_out_GB_G4B2I25ASTHIRNet109 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) ) ;
CKBD12HVT CKBD12HVTG4B2I20 (.Z ( spi_clk_out_GB_G4B2I20ASTHIRNet256 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) ) ;
CKBD12HVT CKBD12HVTG4B2I2 (.Z ( spi_clk_out_GB_G4B2I2ASTHIRNet133 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet117 ) ) ;
CKBD12HVT CKBD12HVTG4B2I1 (.Z ( spi_clk_out_GB_G4B2I1ASTHIRNet225 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet117 ) ) ;
CKBD12HVT CKBD12HVTG4B2I5 (.Z ( spi_clk_out_GB_G4B2I5ASTHIRNet166 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet117 ) ) ;
CKBD12HVT CKBD12HVTG4B1I1 (.Z ( spi_clk_out_GB_G4B1I1ASTHIRNet117 ) 
    , .I ( spi_clk_out_GBASTHIRNet165 ) ) ;
CKBD12HVT CKBD12HVTG4B2I18 (.Z ( spi_clk_out_GB_G4B2I18ASTHIRNet148 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) ) ;
CKBD12HVT CKBD12HVTG4B2I15 (.Z ( spi_clk_out_GB_G4B2I15ASTHIRNet120 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) ) ;
CKBD12HVT CKBD12HVTG4B2I19 (.Z ( spi_clk_out_GB_G4B2I19ASTHIRNet51 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) ) ;
CKBD12HVT CKBD12HVTG4B2I21 (.Z ( spi_clk_out_GB_G4B2I21ASTHIRNet178 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) ) ;
CKBD6HVT CKBD6HVTG2B8I1_1 (.Z ( j_tck_GB_G2B8I1ASTHIRNet265 ) 
    , .I ( j_tck_GB_G2B7I1ASTHNet61 ) ) ;
CKBD6HVT CKBD6HVTG2B7I1_1 (.Z ( j_tck_GB_G2B7I1ASTHNet61 ) 
    , .I ( j_tck_GB_G2B6I1ASTHNet210 ) ) ;
CKBD6HVT CKBD6HVTG2B3I1 (.Z ( j_tck_GB_G2B3I1_1ASTHNet190 ) 
    , .I ( j_tck_GB_G2B2I1_1ASTHNet275 ) ) ;
CKBD8HVT CKBD8HVTG1B4I1_1 (.Z ( osc_clk_G1B4I1_1ASTHNet189 ) 
    , .I ( osc_clk_G1B3I1_1ASTHNet274 ) ) ;
CKBD8HVT CKBD8HVTG2B6I1 (.Z ( j_tck_GB_G2B6I1ASTHNet210 ) 
    , .I ( j_tck_GB_G2B5I1ASTHNet277 ) ) ;
CKBD12HVT CKBD12HVTG1B3I1_1 (.Z ( osc_clk_G1B3I1_1ASTHNet274 ) 
    , .I ( osc_clk_G1B2I1_1ASTHNet79 ) ) ;
CKBD12HVT CKBD12HVTG1B2I1_1 (.Z ( osc_clk_G1B2I1_1ASTHNet79 ) 
    , .I ( osc_clk_G1B1I1_1ASTHNet187 ) ) ;
CKBD12HVT CKBD12HVTG4B2I4 (.Z ( spi_clk_out_GB_G4B2I4ASTHIRNet239 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet117 ) ) ;
BUFFD3HVT rst_b_regASTttcInst31 (.Z ( rst_b ) , .I ( rst_bASTHIRNet31 ) ) ;
BUFFD8HVT U5 (.Z ( smc_read ) , .I ( n453 ) ) ;
CKBD6HVT CKBD6HVTG1B8I1 (.Z ( osc_clk_G1B8I1ASTHIRNet64 ) 
    , .I ( osc_clk_G1B7I1ASTHNet177 ) ) ;
CKBD6HVT CKBD6HVTG1B7I1_1 (.Z ( osc_clk_G1B7I1ASTHNet177 ) 
    , .I ( osc_clk_G1B6I1ASTHNet255 ) ) ;
CKBD6HVT CKBD6HVTG1B6I1_1 (.Z ( osc_clk_G1B6I1ASTHNet255 ) 
    , .I ( osc_clk_G1B5I1_1ASTHNet82 ) ) ;
CKBD6HVT CKBD6HVTG1B5I1_2 (.Z ( osc_clk_G1B5I1_1ASTHNet82 ) 
    , .I ( osc_clk_G1B4I1_1ASTHNet189 ) ) ;
CKBD6HVT CKBD6HVTG4B2I3 (.Z ( spi_clk_out_GB_G4B2I3ASTHIRNet43 ) 
    , .I ( spi_clk_out_GB_G4B1I1ASTHIRNet117 ) ) ;
CKBD6HVT CKBD6HVTG4B2I17 (.Z ( spi_clk_out_GB_G4B2I17ASTHIRNet232 ) 
    , .I ( spi_clk_out_GB_G4B1I2ASTHIRNet304 ) ) ;
endmodule




module tap_controller (j_hiz_b , j_idcode_reg , tck_padASTHIRNet103 , 
    j_usercode , idcode_msb20bits , j_tck_GBASTHIRNet95 , j_shift0 , 
    bschain_sdo , smc_sdo , gio_hz , tdo_pad , tdo_oe_pad , j_sft_dr , 
    tms_pad , tck_pad , j_smc_cap , j_rst_b , j_cfg_enable , 
    j_cfg_disable , j_cfg_program , md_jtag , trst_pad , tdi_pad , 
    j_mode , j_row_test , j_tck , j_tdi , bs_en , j_ceb0 , j_upd_dr , 
    j_cap_dr );
output j_hiz_b ;
output [31:0] j_idcode_reg ;
input  tck_padASTHIRNet103 ;
output j_usercode ;
input  [19:0] idcode_msb20bits ;
output j_tck_GBASTHIRNet95 ;
output j_shift0 ;
input  bschain_sdo ;
input  smc_sdo ;
input  gio_hz ;
output tdo_pad ;
output tdo_oe_pad ;
output j_sft_dr ;
input  tms_pad ;
input  tck_pad ;
output j_smc_cap ;
output j_rst_b ;
output j_cfg_enable ;
output j_cfg_disable ;
output j_cfg_program ;
output md_jtag ;
input  trst_pad ;
input  tdi_pad ;
output j_mode ;
output j_row_test ;
output j_tck ;
output j_tdi ;
output bs_en ;
output j_ceb0 ;
output j_upd_dr ;
output j_cap_dr ;

/* wire declarations */

wire tck_pad_G1B7I1ASTHNet144 ;
wire tck_pad_G1B6I1ASTHNet276 ;
wire tck_pad_G1B5I1ASTHNet81 ;
wire tck_pad_G1B4I1_1ASTHNet188 ;
wire n1485 ;
wire n1493 ;
wire n1311 ;
wire n1320 ;
wire n1333 ;
wire select_ir_scan ;
wire n1305 ;
wire n1408 ;
wire n1417 ;
wire n1414 ;
wire n1423 ;
wire n1420 ;
wire n1426 ;
wire n1429 ;
wire n1411 ;
wire n1432 ;
wire n1435 ;
wire n1438 ;
wire n1441 ;
wire n1444 ;
wire n1447 ;
wire n1450 ;
wire n1453 ;
wire n1312 ;
wire n1483 ;
wire latched_jtag_ir_4_ ;
wire trst_padASThfnNet4 ;
wire n1308 ;
wire n1307 ;
wire n1326 ;
wire n1350 ;
wire n1498 ;
wire n1336 ;
wire n1304 ;
wire n1456 ;
wire n1459 ;
wire n1462 ;
wire n1465 ;
wire n1497 ;
wire n1309 ;
wire n1492 ;
wire n1534 ;
wire n1502 ;
wire n1315 ;
wire n1500 ;
wire tms_q2 ;
wire tms_q1 ;
wire n1501 ;
wire tms_q3 ;
wire tms_q4 ;
wire n1302 ;
wire n1306 ;
wire n1548 ;
wire n1318 ;
wire n1478 ;
wire n_1627 ;
wire n1487 ;
wire latched_jtag_ir_neg_4_ ;
wire latched_jtag_ir_neg_3_ ;
wire n1499 ;
wire n1314 ;
wire n1313 ;
wire bypassed_tdo ;
wire latched_jtag_ir_neg_2_ ;
wire n1496 ;
wire latched_jtag_ir_neg_1_ ;
wire instruction_tdo ;
wire shift_ir_neg ;
wire n1491 ;
wire cfg_en ;
wire n1316 ;
wire n1479 ;
wire latched_jtag_ir_1_ ;
wire n1321 ;
wire latched_jtag_ir_3_ ;
wire n1348 ;
wire n1349 ;
wire n1494 ;
wire n1329 ;
wire n1480 ;
wire pause_ir ;
wire n1334 ;
wire latched_jtag_ir_neg_0_ ;
wire n1335 ;
wire n1310 ;
wire latched_jtag_ir_0_ ;
wire update_ir ;
wire jtag_ir_0 ;
wire jtag_ir798_3 ;
wire n1322 ;
wire capture_ir ;
wire n1323 ;
wire jtag_ir798_2 ;
wire n1324 ;
wire jtag_ir798_1 ;
wire n1325 ;
wire jtag_ir798_0 ;
wire n1317 ;
wire n1328 ;
wire pause_dr ;
wire n1330 ;
wire Ub ;
wire n1331 ;
wire n1481 ;
wire n1337 ;
wire idcode_reg_12_ ;
wire n1392 ;
wire n1338 ;
wire idcode_reg_9_ ;
wire n1393 ;
wire n1339 ;
wire idcode_reg_8_ ;
wire n1395 ;
wire n1340 ;
wire idcode_reg_7_ ;
wire n1394 ;
wire n1341 ;
wire idcode_reg_3_ ;
wire n1495 ;
wire n1332 ;
wire n1343 ;
wire n1344 ;
wire n1345 ;
wire n1353 ;
wire n1477 ;
wire shift_ir ;
wire n1347 ;
wire n1342 ;
wire idcode_reg_2_ ;
wire test_logic_reset ;
wire n1376 ;
wire n1468 ;
wire n1346 ;
wire Uh ;
wire n1327 ;
wire n1476 ;
wire n1352 ;
wire n1409 ;
wire n1412 ;
wire n1415 ;
wire n1439 ;
wire n1418 ;
wire n1421 ;
wire n1424 ;
wire n1427 ;
wire n1445 ;
wire n1448 ;
wire n1451 ;
wire n1430 ;
wire n1433 ;
wire n1436 ;
wire n1454 ;
wire n1457 ;
wire n1460 ;
wire n1463 ;
wire n1442 ;
wire n1466 ;
wire n1503 ;
wire trst_padASThfnNet3 ;
wire tck_pad_G1B8I1ASTHNet50 ;
wire tck_pad_G1B8I4ASTHNet62 ;
wire bypass_reg ;
wire U ;
wire tck_pad_G1B8I2ASTHNet248 ;
wire latched_jtag_ir_2_ ;
wire trst_padASThfnNet1 ;
wire tck_pad_G1B8I6ASTHNet194 ;
wire idcode_reg875_9 ;
wire idcode_reg_5_ ;
wire idcode_reg875_5 ;
wire idcode_reg_10_ ;
wire idcode_reg875_10 ;
wire tck_pad_G1B8I3ASTHNet173 ;
wire idcode_reg875_3 ;
wire idcode_reg_4_ ;
wire idcode_reg875_4 ;
wire n1351 ;
wire jtag_ir798_4 ;
wire jtag_ir_4 ;
wire test_logic_reset205 ;
wire idcode_reg_0_ ;
wire idcode_reg875_0 ;
wire tck_pad_G1B8I5ASTHNet272 ;
wire tck_pad_G1B3I1_1ASTHNet273 ;
wire tck_pad_G1B2I1_1ASTHNet78 ;
wire tck_pad_G1B1I1_1ASTHNet186 ;
wire n1378 ;
wire trst_padASThfnNet2 ;
wire n1452 ;
wire n1410 ;
wire n1413 ;
wire n1416 ;
wire n1419 ;
wire n1422 ;
wire n1425 ;
wire n1428 ;
wire n1467 ;
wire n1431 ;
wire n1434 ;
wire n1437 ;
wire n1440 ;
wire n1443 ;
wire n1446 ;
wire n1449 ;
wire update_dr ;
wire n1455 ;
wire n1458 ;
wire n1461 ;
wire n1464 ;
wire Ui ;
wire idcode_reg_11_ ;
wire exit2_ir ;
wire idcode_reg_6_ ;
wire exit1_dr ;
wire Ud ;
wire Uj ;
wire idcode_reg_1_ ;
wire Uc ;
wire run_test_idle ;
wire Uf ;
wire Ug ;
wire Ue ;
wire exit2_dr ;
wire exit1_ir ;
wire select_dr_scan ;
wire idcode_reg_22_ ;
wire n1537 ;
wire idcode_reg_21_ ;
wire n1532 ;
wire idcode_reg_23_ ;
wire n1524 ;
wire idcode_reg_20_ ;
wire n1544 ;
wire idcode_reg_24_ ;
wire n1543 ;
wire idcode_reg_19_ ;
wire n1525 ;
wire idcode_reg_25_ ;
wire n1528 ;
wire idcode_reg_18_ ;
wire n1529 ;
wire idcode_reg_26_ ;
wire n1539 ;
wire idcode_reg_17_ ;
wire n1540 ;
wire idcode_reg_27_ ;
wire n1526 ;
wire idcode_reg_16_ ;
wire n1527 ;
wire idcode_reg_28_ ;
wire n1542 ;
wire idcode_reg_15_ ;
wire n1541 ;
wire idcode_reg_29_ ;
wire n1536 ;
wire idcode_reg_14_ ;
wire n1533 ;
wire idcode_reg_30_ ;
wire n1531 ;
wire idcode_reg_13_ ;
wire n1538 ;
wire idcode_reg_31_ ;
wire n1530 ;
wire n1535 ;
wire n1504 ;
wire n1523 ;
wire n1522 ;
wire n1484 ;
wire n1519 ;
wire n1506 ;
wire n1507 ;
wire n1521 ;
wire n_1626 ;
wire n1514 ;
wire n1516 ;
wire n1512 ;
wire n1513 ;
wire n1511 ;
wire n1517 ;
wire n1510 ;
wire n1505 ;
wire n1508 ;
wire n1509 ;
wire n1518 ;
wire n1520 ;
wire n1515 ;
wire j_smc_capla ;
wire n1303 ;

CKBD6HVT CKBD6HVTG1B7I1 (.Z ( tck_pad_G1B7I1ASTHNet144 ) 
    , .I ( tck_pad_G1B6I1ASTHNet276 ) ) ;
CKBD6HVT CKBD6HVTG1B6I1 (.Z ( tck_pad_G1B6I1ASTHNet276 ) 
    , .I ( tck_pad_G1B5I1ASTHNet81 ) ) ;
CKBD6HVT CKBD6HVTG1B5I1_1 (.Z ( tck_pad_G1B5I1ASTHNet81 ) 
    , .I ( tck_pad_G1B4I1_1ASTHNet188 ) ) ;
IND4D1HVT U486 (.ZN ( n1485 ) , .A1 ( n1493 ) , .B3 ( j_sft_dr ) , .B2 ( n1311 ) 
    , .B1 ( n1320 ) ) ;
INR2D0HVT U487 (.ZN ( n1333 ) , .A1 ( select_ir_scan ) , .B1 ( tms_pad ) ) ;
CKND12HVT U490 (.I ( n1305 ) , .ZN ( j_hiz_b ) ) ;
CKND6HVT U549 (.I ( n1408 ) , .ZN ( j_idcode_reg[25] ) ) ;
CKND6HVT U550 (.I ( n1417 ) , .ZN ( j_idcode_reg[15] ) ) ;
CKND6HVT U551 (.I ( n1414 ) , .ZN ( j_idcode_reg[14] ) ) ;
CKND6HVT U552 (.I ( n1423 ) , .ZN ( j_idcode_reg[28] ) ) ;
CKND6HVT U553 (.I ( n1420 ) , .ZN ( j_idcode_reg[18] ) ) ;
CKND6HVT U555 (.I ( n1426 ) , .ZN ( j_idcode_reg[29] ) ) ;
CKND6HVT U556 (.I ( n1429 ) , .ZN ( j_idcode_reg[19] ) ) ;
CKND6HVT U548 (.I ( n1411 ) , .ZN ( j_idcode_reg[24] ) ) ;
CKND6HVT U557 (.I ( n1432 ) , .ZN ( j_idcode_reg[27] ) ) ;
CKND6HVT U558 (.I ( n1435 ) , .ZN ( j_idcode_reg[17] ) ) ;
CKND6HVT U559 (.I ( n1438 ) , .ZN ( j_idcode_reg[16] ) ) ;
CKND6HVT U560 (.I ( n1441 ) , .ZN ( j_idcode_reg[26] ) ) ;
CKND6HVT U561 (.I ( n1444 ) , .ZN ( j_idcode_reg[23] ) ) ;
CKND6HVT U562 (.I ( n1447 ) , .ZN ( j_idcode_reg[13] ) ) ;
CKND6HVT U563 (.I ( n1450 ) , .ZN ( j_idcode_reg[30] ) ) ;
CKND6HVT U564 (.I ( n1453 ) , .ZN ( j_idcode_reg[20] ) ) ;
ND3D0HVT U501 (.A1 ( n1312 ) , .ZN ( n1483 ) , .A2 ( n1311 ) 
    , .A3 ( latched_jtag_ir_4_ ) ) ;
ND3D0HVT U493 (.A1 ( trst_padASThfnNet4 ) , .ZN ( n1308 ) , .A2 ( n1307 ) 
    , .A3 ( n1326 ) ) ;
IND2D0HVT U497 (.A1 ( n1350 ) , .B1 ( bschain_sdo ) , .ZN ( n1498 ) ) ;
IND2D0HVT U488 (.A1 ( n1336 ) , .B1 ( n1304 ) , .ZN ( n1305 ) ) ;
CKND6HVT U565 (.I ( n1456 ) , .ZN ( j_idcode_reg[21] ) ) ;
CKND6HVT U566 (.I ( n1459 ) , .ZN ( j_idcode_reg[22] ) ) ;
CKND6HVT U567 (.I ( n1462 ) , .ZN ( j_idcode_reg[12] ) ) ;
CKND6HVT U568 (.I ( n1465 ) , .ZN ( j_idcode_reg[31] ) ) ;
ND2D0HVT U498 (.ZN ( n1497 ) , .A1 ( n1309 ) , .A2 ( smc_sdo ) ) ;
ND2D0HVT U500 (.ZN ( n1492 ) , .A1 ( n1320 ) , .A2 ( n1311 ) ) ;
ND2D0HVT U505 (.ZN ( n1534 ) , .A1 ( n1502 ) , .A2 ( n1315 ) ) ;
ND2D0HVT U520 (.ZN ( n1500 ) , .A1 ( tms_q2 ) , .A2 ( tms_q1 ) ) ;
ND2D0HVT U521 (.ZN ( n1501 ) , .A1 ( tms_q3 ) , .A2 ( tms_q4 ) ) ;
ND2D0HVT U491 (.A2 ( n1302 ) , .A1 ( n1483 ) , .ZN ( n1306 ) ) ;
ND2D0HVT U671 (.A2 ( n1548 ) , .A1 ( n1318 ) , .ZN ( n1478 ) ) ;
ND2D1HVT U670 (.ZN ( md_jtag ) , .A1 ( n_1627 ) , .A2 ( n1487 ) ) ;
OAI31D0HVT U502 (.A2 ( latched_jtag_ir_neg_4_ ) 
    , .A1 ( latched_jtag_ir_neg_3_ ) , .ZN ( n1499 ) , .A3 ( n1314 ) , .B ( n1313 ) ) ;
OAI31D0HVT U503 (.A2 ( latched_jtag_ir_neg_3_ ) 
    , .A1 ( latched_jtag_ir_neg_4_ ) , .ZN ( n1313 ) , .A3 ( n1350 ) 
    , .B ( bypassed_tdo ) ) ;
MUX3D0HVT U504 (.S1 ( latched_jtag_ir_neg_2_ ) , .I2 ( n1498 ) , .Z ( n1314 ) 
    , .I1 ( n1497 ) , .I0 ( n1496 ) , .S0 ( latched_jtag_ir_neg_1_ ) ) ;
MUX3D0HVT U676 (.I2 ( instruction_tdo ) , .S1 ( shift_ir_neg ) , .Z ( n1491 ) 
    , .I1 ( n1499 ) , .I0 ( smc_sdo ) , .S0 ( cfg_en ) ) ;
NR3D0HVT U507 (.A1 ( n1501 ) , .ZN ( n1316 ) , .A2 ( n1500 ) , .A3 ( n1479 ) ) ;
NR3D0HVT U518 (.A1 ( latched_jtag_ir_1_ ) , .ZN ( j_cfg_enable ) 
    , .A2 ( n1321 ) , .A3 ( n1483 ) ) ;
NR3D0HVT U543 (.A1 ( latched_jtag_ir_3_ ) , .ZN ( n1348 ) , .A2 ( n1349 ) 
    , .A3 ( n1492 ) ) ;
ND2D0HVT U524 (.ZN ( n1494 ) , .A1 ( tms_pad ) , .A2 ( n1502 ) ) ;
CKAN2D1HVT U513 (.Z ( n1329 ) , .A1 ( n1480 ) , .A2 ( pause_ir ) ) ;
MUX2ND0HVT U545 (.ZN ( n1350 ) , .I0 ( n1334 ) , .S ( latched_jtag_ir_neg_0_ ) 
    , .I1 ( n1335 ) ) ;
MUX2ND0HVT U499 (.ZN ( n1496 ) , .I0 ( bschain_sdo ) 
    , .S ( latched_jtag_ir_neg_0_ ) , .I1 ( n1310 ) ) ;
MUX2ND0HVT U506 (.ZN ( n1315 ) , .I0 ( latched_jtag_ir_0_ ) , .S ( update_ir ) 
    , .I1 ( jtag_ir_0 ) ) ;
MUX2ND0HVT U509 (.ZN ( jtag_ir798_3 ) , .I0 ( n1322 ) , .S ( capture_ir ) 
    , .I1 ( n1323 ) ) ;
MUX2ND0HVT U510 (.ZN ( jtag_ir798_2 ) , .I0 ( n1323 ) , .S ( capture_ir ) 
    , .I1 ( n1324 ) ) ;
MUX2ND0HVT U511 (.ZN ( jtag_ir798_1 ) , .I0 ( n1324 ) , .S ( capture_ir ) 
    , .I1 ( n1325 ) ) ;
MUX2ND0HVT U512 (.ZN ( jtag_ir798_0 ) , .I0 ( n1325 ) , .S ( capture_ir ) 
    , .I1 ( n1317 ) ) ;
CKAN2D1HVT U515 (.Z ( n1328 ) , .A1 ( n1480 ) , .A2 ( pause_dr ) ) ;
CKAN2D1HVT U516 (.Z ( n1330 ) , .A1 ( Ub ) , .A2 ( n1480 ) ) ;
CKAN2D1HVT U517 (.Z ( n1331 ) , .A1 ( n1481 ) , .A2 ( n1480 ) ) ;
CKAN2D1HVT U532 (.Z ( n1337 ) , .A1 ( idcode_reg_12_ ) , .A2 ( n1392 ) ) ;
CKAN2D1HVT U533 (.Z ( n1338 ) , .A1 ( idcode_reg_9_ ) , .A2 ( n1393 ) ) ;
CKAN2D1HVT U534 (.Z ( n1339 ) , .A1 ( idcode_reg_8_ ) , .A2 ( n1395 ) ) ;
CKAN2D1HVT U535 (.Z ( n1340 ) , .A1 ( idcode_reg_7_ ) , .A2 ( n1394 ) ) ;
CKAN2D1HVT U536 (.Z ( n1341 ) , .A1 ( idcode_reg_3_ ) , .A2 ( n1392 ) ) ;
NR2D0HVT U530 (.A1 ( n1494 ) , .A2 ( n1495 ) , .ZN ( n1332 ) ) ;
NR2D0HVT U538 (.A1 ( n1316 ) , .A2 ( n1322 ) , .ZN ( n1343 ) ) ;
NR2D0HVT U539 (.A1 ( n1316 ) , .A2 ( n1323 ) , .ZN ( n1344 ) ) ;
NR2D0HVT U540 (.A1 ( n1316 ) , .A2 ( n1324 ) , .ZN ( n1345 ) ) ;
NR2D0HVT U496 (.ZN ( n1353 ) , .A2 ( n1326 ) , .A1 ( n1477 ) ) ;
NR2XD0HVT U542 (.A1 ( shift_ir ) , .A2 ( j_sft_dr ) , .ZN ( n1347 ) ) ;
NR2XD0HVT U514 (.A1 ( j_sft_dr ) , .A2 ( j_smc_cap ) , .ZN ( n1318 ) ) ;
CKAN2D1HVT U537 (.Z ( n1342 ) , .A1 ( idcode_reg_2_ ) , .A2 ( n1393 ) ) ;
CKND8HVT U605 (.ZN ( j_rst_b ) , .I ( test_logic_reset ) ) ;
CKND8HVT U570 (.I ( n1376 ) , .ZN ( j_tdi ) ) ;
CKND8HVT U554 (.I ( n1468 ) , .ZN ( bs_en ) ) ;
CKND8HVT U492 (.I ( n1306 ) , .ZN ( j_row_test ) ) ;
CKND8HVT U495 (.I ( n1308 ) , .ZN ( j_ceb0 ) ) ;
NR2D0HVT U541 (.A1 ( n1316 ) , .A2 ( n1325 ) , .ZN ( n1346 ) ) ;
NR2D0HVT U522 (.A1 ( n1494 ) , .A2 ( n1318 ) , .ZN ( Uh ) ) ;
NR2D0HVT U529 (.A1 ( tms_pad ) , .A2 ( n1495 ) , .ZN ( n1327 ) ) ;
INVD0HVT U603 (.ZN ( n1476 ) , .I ( n1352 ) ) ;
INVD0HVT U607 (.ZN ( n1409 ) , .I ( n1408 ) ) ;
INVD0HVT U610 (.ZN ( n1412 ) , .I ( n1411 ) ) ;
INVD0HVT U613 (.ZN ( n1415 ) , .I ( n1414 ) ) ;
INVD0HVT U586 (.ZN ( n1392 ) , .I ( n1485 ) ) ;
INVD0HVT U587 (.ZN ( n1395 ) , .I ( n1485 ) ) ;
INVD0HVT U588 (.ZN ( n1393 ) , .I ( n1485 ) ) ;
INVD0HVT U589 (.ZN ( n1394 ) , .I ( n1485 ) ) ;
INVD0HVT U636 (.ZN ( n1438 ) , .I ( idcode_msb20bits[4] ) ) ;
INVD0HVT U637 (.ZN ( n1439 ) , .I ( n1438 ) ) ;
INVD0HVT U616 (.ZN ( n1418 ) , .I ( n1417 ) ) ;
INVD0HVT U618 (.ZN ( n1420 ) , .I ( idcode_msb20bits[6] ) ) ;
INVD0HVT U619 (.ZN ( n1421 ) , .I ( n1420 ) ) ;
INVD0HVT U621 (.ZN ( n1423 ) , .I ( idcode_msb20bits[16] ) ) ;
INVD0HVT U622 (.ZN ( n1424 ) , .I ( n1423 ) ) ;
INVD0HVT U625 (.ZN ( n1427 ) , .I ( n1426 ) ) ;
INVD0HVT U643 (.ZN ( n1445 ) , .I ( n1444 ) ) ;
INVD0HVT U646 (.ZN ( n1448 ) , .I ( n1447 ) ) ;
INVD0HVT U649 (.ZN ( n1451 ) , .I ( n1450 ) ) ;
INVD0HVT U627 (.ZN ( n1429 ) , .I ( idcode_msb20bits[7] ) ) ;
INVD0HVT U628 (.ZN ( n1430 ) , .I ( n1429 ) ) ;
INVD0HVT U630 (.ZN ( n1432 ) , .I ( idcode_msb20bits[15] ) ) ;
INVD0HVT U631 (.ZN ( n1433 ) , .I ( n1432 ) ) ;
INVD0HVT U634 (.ZN ( n1436 ) , .I ( n1435 ) ) ;
INVD0HVT U652 (.ZN ( n1454 ) , .I ( n1453 ) ) ;
INVD0HVT U654 (.ZN ( n1456 ) , .I ( idcode_msb20bits[9] ) ) ;
INVD0HVT U655 (.ZN ( n1457 ) , .I ( n1456 ) ) ;
INVD0HVT U657 (.ZN ( n1459 ) , .I ( idcode_msb20bits[10] ) ) ;
INVD0HVT U658 (.ZN ( n1460 ) , .I ( n1459 ) ) ;
INVD0HVT U661 (.ZN ( n1463 ) , .I ( n1462 ) ) ;
INVD0HVT U640 (.ZN ( n1442 ) , .I ( n1441 ) ) ;
INVD0HVT U642 (.ZN ( n1444 ) , .I ( idcode_msb20bits[11] ) ) ;
INVD1HVT U624 (.ZN ( n1426 ) , .I ( idcode_msb20bits[17] ) ) ;
INVD1HVT U606 (.ZN ( n1408 ) , .I ( idcode_msb20bits[13] ) ) ;
INVD1HVT U609 (.ZN ( n1411 ) , .I ( idcode_msb20bits[12] ) ) ;
INVD1HVT U612 (.ZN ( n1414 ) , .I ( idcode_msb20bits[2] ) ) ;
INVD0HVT U664 (.ZN ( n1466 ) , .I ( n1465 ) ) ;
INVD0HVT U678 (.ZN ( j_cfg_disable ) , .I ( n1503 ) ) ;
INVD0HVT U722 (.ZN ( n1477 ) , .I ( trst_padASThfnNet4 ) ) ;
INVD0HVT U651 (.ZN ( n1453 ) , .I ( idcode_msb20bits[8] ) ) ;
INVD1HVT U663 (.ZN ( n1465 ) , .I ( idcode_msb20bits[19] ) ) ;
INVD1HVT U666 (.ZN ( n1468 ) , .I ( trst_padASThfnNet3 ) ) ;
INVD1HVT U660 (.ZN ( n1462 ) , .I ( idcode_msb20bits[0] ) ) ;
INVD1HVT U639 (.ZN ( n1441 ) , .I ( idcode_msb20bits[14] ) ) ;
INVD1HVT U645 (.ZN ( n1447 ) , .I ( idcode_msb20bits[1] ) ) ;
INVD1HVT U648 (.ZN ( n1450 ) , .I ( idcode_msb20bits[18] ) ) ;
INVD1HVT U633 (.ZN ( n1435 ) , .I ( idcode_msb20bits[5] ) ) ;
INVD1HVT U615 (.ZN ( n1417 ) , .I ( idcode_msb20bits[3] ) ) ;
EDFCND1HVT jtag_ir_reg_3_ (.E ( Ub ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .D ( jtag_ir798_3 ) , .QN ( n1323 ) , .CDN ( trst_padASThfnNet3 ) ) ;
EDFCND1HVT jtag_ir_reg_2_ (.E ( Ub ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .D ( jtag_ir798_2 ) , .QN ( n1324 ) , .CDN ( trst_padASThfnNet3 ) ) ;
EDFCND1HVT jtag_ir_reg_1_ (.E ( Ub ) , .CP ( tck_pad_G1B8I4ASTHNet62 ) 
    , .D ( jtag_ir798_1 ) , .QN ( n1325 ) , .CDN ( trst_padASThfnNet3 ) ) ;
EDFCND1HVT jtag_ir_reg_0_ (.E ( Ub ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .D ( jtag_ir798_0 ) , .QN ( n1317 ) , .Q ( jtag_ir_0 ) 
    , .CDN ( trst_padASThfnNet4 ) ) ;
EDFCND1HVT bypass_reg_reg (.E ( j_sft_dr ) , .CP ( tck_pad_G1B8I4ASTHNet62 ) 
    , .D ( tdi_pad ) , .Q ( bypass_reg ) , .CDN ( trst_padASThfnNet3 ) ) ;
EDFCND1HVT latched_jtag_ir_reg_2_ (.E ( U ) , .CP ( tck_pad_G1B8I2ASTHNet248 ) 
    , .D ( n1345 ) , .QN ( n1311 ) , .Q ( latched_jtag_ir_2_ ) 
    , .CDN ( trst_padASThfnNet3 ) ) ;
EDFCND1HVT latched_jtag_ir_reg_3_ (.E ( U ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .D ( n1344 ) , .QN ( n1312 ) , .Q ( latched_jtag_ir_3_ ) 
    , .CDN ( trst_padASThfnNet4 ) ) ;
EDFCND1HVT latched_jtag_ir_reg_4_ (.E ( U ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .D ( n1343 ) , .QN ( n1320 ) , .Q ( latched_jtag_ir_4_ ) 
    , .CDN ( trst_padASThfnNet3 ) ) ;
DFSNQD1HVT idcode_reg_reg_9_ (.SDN ( trst_padASThfnNet1 ) 
    , .Q ( idcode_reg_9_ ) , .CP ( tck_pad_G1B8I6ASTHNet194 ) 
    , .D ( idcode_reg875_9 ) ) ;
DFSNQD1HVT idcode_reg_reg_5_ (.SDN ( trst_padASThfnNet1 ) 
    , .Q ( idcode_reg_5_ ) , .CP ( tck_pad_G1B8I6ASTHNet194 ) 
    , .D ( idcode_reg875_5 ) ) ;
DFSNQD1HVT idcode_reg_reg_10_ (.SDN ( trst_padASThfnNet1 ) 
    , .Q ( idcode_reg_10_ ) , .CP ( tck_pad_G1B8I6ASTHNet194 ) 
    , .D ( idcode_reg875_10 ) ) ;
DFSNQD1HVT idcode_reg_reg_3_ (.SDN ( trst_padASThfnNet1 ) 
    , .Q ( idcode_reg_3_ ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .D ( idcode_reg875_3 ) ) ;
DFSNQD1HVT idcode_reg_reg_4_ (.SDN ( trst_padASThfnNet1 ) 
    , .Q ( idcode_reg_4_ ) , .CP ( tck_pad_G1B8I6ASTHNet194 ) 
    , .D ( idcode_reg875_4 ) ) ;
DFSND1HVT latched_jtag_ir_reg_0_ (.D ( n1534 ) 
    , .CP ( tck_pad_G1B8I4ASTHNet62 ) , .QN ( n1321 ) , .Q ( latched_jtag_ir_0_ ) 
    , .SDN ( trst_padASThfnNet3 ) ) ;
EDFCND1HVT latched_jtag_ir_reg_1_ (.E ( U ) , .CP ( tck_pad_G1B8I4ASTHNet62 ) 
    , .D ( n1346 ) , .QN ( n1351 ) , .Q ( latched_jtag_ir_1_ ) 
    , .CDN ( trst_padASThfnNet3 ) ) ;
EDFCND1HVT jtag_ir_reg_4_ (.E ( Ub ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .D ( jtag_ir798_4 ) , .QN ( n1322 ) , .Q ( jtag_ir_4 ) 
    , .CDN ( trst_padASThfnNet3 ) ) ;
TIELHVT U577 (.ZN ( j_idcode_reg[7] ) ) ;
TIELHVT U728 (.ZN ( j_idcode_reg[8] ) ) ;
NR4D0HVT U547 (.A2 ( n1351 ) , .A3 ( latched_jtag_ir_3_ ) 
    , .A4 ( latched_jtag_ir_0_ ) , .A1 ( n1492 ) , .ZN ( j_usercode ) ) ;
NR4D0HVT U531 (.A2 ( n1349 ) , .A3 ( latched_jtag_ir_0_ ) , .A4 ( n1348 ) 
    , .A1 ( n1492 ) , .ZN ( n1336 ) ) ;
XOR2D0HVT U544 (.A2 ( latched_jtag_ir_0_ ) , .Z ( n1349 ) 
    , .A1 ( latched_jtag_ir_1_ ) ) ;
INVD4HVT U569 (.I ( tdi_pad ) , .ZN ( n1376 ) ) ;
DFSNQD1HVT test_logic_reset_reg (.SDN ( trst_padASThfnNet4 ) 
    , .Q ( test_logic_reset ) , .CP ( tck_pad_G1B8I4ASTHNet62 ) 
    , .D ( test_logic_reset205 ) ) ;
DFSNQD1HVT idcode_reg_reg_0_ (.SDN ( trst_padASThfnNet3 ) 
    , .Q ( idcode_reg_0_ ) , .CP ( tck_pad_G1B8I2ASTHNet248 ) 
    , .D ( idcode_reg875_0 ) ) ;
TIEHHVT U574 (.Z ( j_idcode_reg[3] ) ) ;
TIEHHVT U723 (.Z ( j_idcode_reg[0] ) ) ;
TIEHHVT U724 (.Z ( j_idcode_reg[4] ) ) ;
TIEHHVT U725 (.Z ( j_idcode_reg[9] ) ) ;
TIELHVT U572 (.ZN ( j_idcode_reg[11] ) ) ;
TIELHVT U573 (.ZN ( j_idcode_reg[2] ) ) ;
TIELHVT U575 (.ZN ( j_idcode_reg[6] ) ) ;
TIELHVT U576 (.ZN ( j_idcode_reg[1] ) ) ;
CKBD12HVT CKBD12HVTG1B8I3 (.Z ( tck_pad_G1B8I3ASTHNet173 ) 
    , .I ( tck_pad_G1B7I1ASTHNet144 ) ) ;
CKBD12HVT CKBD12HVTG1B8I5 (.Z ( tck_pad_G1B8I5ASTHNet272 ) 
    , .I ( tck_pad_G1B7I1ASTHNet144 ) ) ;
CKBD12HVT CKBD12HVTG1B3I1 (.Z ( tck_pad_G1B3I1_1ASTHNet273 ) 
    , .I ( tck_pad_G1B2I1_1ASTHNet78 ) ) ;
CKBD12HVT CKBD12HVTG1B2I1 (.Z ( tck_pad_G1B2I1_1ASTHNet78 ) 
    , .I ( tck_pad_G1B1I1_1ASTHNet186 ) ) ;
CKBD12HVT CKBD12HVTG1B1I1_2 (.Z ( tck_pad_G1B1I1_1ASTHNet186 ) 
    , .I ( tck_padASTHIRNet103 ) ) ;
TIEHHVT U726 (.Z ( j_idcode_reg[5] ) ) ;
TIEHHVT U727 (.Z ( j_idcode_reg[10] ) ) ;
TIEHHVT U571 (.Z ( n1378 ) ) ;
CKBD3HVT toplevelASThfnInst1 (.Z ( trst_padASThfnNet1 ) , .I ( trst_pad ) ) ;
CKBD3HVT toplevelASThfnInst2 (.Z ( trst_padASThfnNet2 ) , .I ( trst_pad ) ) ;
CKBD3HVT toplevelASThfnInst3 (.Z ( trst_padASThfnNet3 ) , .I ( trst_pad ) ) ;
CKBD3HVT toplevelASThfnInst4 (.Z ( trst_padASThfnNet4 ) , .I ( trst_pad ) ) ;
CKBD12HVT CKBD12HVTG1B8I1 (.Z ( tck_pad_G1B8I1ASTHNet50 ) 
    , .I ( tck_pad_G1B7I1ASTHNet144 ) ) ;
CKBD12HVT CKBD12HVTG1B8I2 (.Z ( tck_pad_G1B8I2ASTHNet248 ) 
    , .I ( tck_pad_G1B7I1ASTHNet144 ) ) ;
CKBD12HVT CKBD12HVTG1B8I4 (.Z ( tck_pad_G1B8I4ASTHNet62 ) 
    , .I ( tck_pad_G1B7I1ASTHNet144 ) ) ;
CKBD12HVT CKBD12HVTG1B8I6 (.Z ( tck_pad_G1B8I6ASTHNet194 ) 
    , .I ( tck_pad_G1B7I1ASTHNet144 ) ) ;
CKND1HVT U650 (.I ( n1450 ) , .ZN ( n1452 ) ) ;
CKND1HVT U608 (.I ( n1408 ) , .ZN ( n1410 ) ) ;
CKND1HVT U611 (.I ( n1411 ) , .ZN ( n1413 ) ) ;
CKND1HVT U614 (.I ( n1414 ) , .ZN ( n1416 ) ) ;
CKND1HVT U617 (.I ( n1417 ) , .ZN ( n1419 ) ) ;
CKND1HVT U620 (.I ( n1420 ) , .ZN ( n1422 ) ) ;
CKND1HVT U623 (.I ( n1423 ) , .ZN ( n1425 ) ) ;
CKND1HVT U626 (.I ( n1426 ) , .ZN ( n1428 ) ) ;
CKND1HVT U665 (.I ( n1465 ) , .ZN ( n1467 ) ) ;
CKND1HVT U629 (.I ( n1429 ) , .ZN ( n1431 ) ) ;
CKND1HVT U632 (.I ( n1432 ) , .ZN ( n1434 ) ) ;
CKND1HVT U635 (.I ( n1435 ) , .ZN ( n1437 ) ) ;
CKND1HVT U638 (.I ( n1438 ) , .ZN ( n1440 ) ) ;
CKND1HVT U641 (.I ( n1441 ) , .ZN ( n1443 ) ) ;
CKND1HVT U644 (.I ( n1444 ) , .ZN ( n1446 ) ) ;
CKND1HVT U647 (.I ( n1447 ) , .ZN ( n1449 ) ) ;
DFCNQD1HVT capture_dr_reg (.D ( n1327 ) , .CP ( tck_pad_G1B8I6ASTHNet194 ) 
    , .Q ( j_smc_cap ) , .CDN ( trst_padASThfnNet4 ) ) ;
INR3D0HVT U675 (.B1 ( n1483 ) , .A1 ( latched_jtag_ir_0_ ) , .B2 ( n1351 ) 
    , .ZN ( j_cfg_program ) ) ;
OR2D8HVT U673 (.Z ( j_mode ) , .A1 ( n1348 ) , .A2 ( n1336 ) ) ;
OR2D8HVT U669 (.Z ( j_upd_dr ) , .A1 ( update_dr ) , .A2 ( n1477 ) ) ;
CKND1HVT U653 (.I ( n1453 ) , .ZN ( n1455 ) ) ;
CKND1HVT U656 (.I ( n1456 ) , .ZN ( n1458 ) ) ;
CKND1HVT U659 (.I ( n1459 ) , .ZN ( n1461 ) ) ;
CKND1HVT U662 (.I ( n1462 ) , .ZN ( n1464 ) ) ;
DFCNQD1HVT shift_dr_reg (.D ( Ui ) , .CP ( tck_pad_G1B8I6ASTHNet194 ) 
    , .Q ( j_sft_dr ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT idcode_reg_reg_11_ (.D ( n1337 ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .Q ( idcode_reg_11_ ) , .CDN ( trst_padASThfnNet1 ) ) ;
DFCNQD1HVT tms_q3_reg (.D ( tms_q2 ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .Q ( tms_q3 ) , .CDN ( n1378 ) ) ;
DFCNQD1HVT idcode_reg_reg_2_ (.D ( n1341 ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .Q ( idcode_reg_2_ ) , .CDN ( trst_padASThfnNet3 ) ) ;
DFCNQD1HVT exit2_ir_reg (.D ( n1329 ) , .CP ( tck_pad_G1B8I4ASTHNet62 ) 
    , .Q ( exit2_ir ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT idcode_reg_reg_6_ (.D ( n1340 ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .Q ( idcode_reg_6_ ) , .CDN ( trst_padASThfnNet1 ) ) ;
DFCNQD1HVT exit1_dr_reg (.D ( Uh ) , .CP ( tck_pad_G1B8I6ASTHNet194 ) 
    , .Q ( exit1_dr ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT update_ir_reg (.D ( Ud ) , .CP ( tck_pad_G1B8I4ASTHNet62 ) 
    , .Q ( update_ir ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT tms_q1_reg (.D ( tms_pad ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .Q ( tms_q1 ) , .CDN ( n1378 ) ) ;
DFCNQD1HVT pause_dr_reg (.D ( Uj ) , .CP ( tck_pad_G1B8I6ASTHNet194 ) 
    , .Q ( pause_dr ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT idcode_reg_reg_1_ (.D ( n1342 ) , .CP ( tck_pad_G1B8I4ASTHNet62 ) 
    , .Q ( idcode_reg_1_ ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT idcode_reg_reg_8_ (.D ( n1338 ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .Q ( idcode_reg_8_ ) , .CDN ( trst_padASThfnNet1 ) ) ;
DFCNQD1HVT select_ir_scan_reg (.D ( n1332 ) , .CP ( tck_pad_G1B8I4ASTHNet62 ) 
    , .Q ( select_ir_scan ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT tms_q4_reg (.D ( tms_q3 ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .Q ( tms_q4 ) , .CDN ( n1378 ) ) ;
DFCNQD1HVT idcode_reg_reg_7_ (.D ( n1339 ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .Q ( idcode_reg_7_ ) , .CDN ( trst_padASThfnNet1 ) ) ;
DFCNQD1HVT run_test_idle_reg (.D ( Uc ) , .CP ( tck_pad_G1B8I4ASTHNet62 ) 
    , .Q ( run_test_idle ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT pause_ir_reg (.D ( Uf ) , .CP ( tck_pad_G1B8I4ASTHNet62 ) 
    , .Q ( pause_ir ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT update_dr_reg (.D ( Ug ) , .CP ( tck_pad_G1B8I6ASTHNet194 ) 
    , .Q ( update_dr ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT shift_ir_reg (.D ( Ue ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .Q ( shift_ir ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT exit2_dr_reg (.D ( n1328 ) , .CP ( tck_pad_G1B8I4ASTHNet62 ) 
    , .Q ( exit2_dr ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT capture_ir_reg (.D ( n1333 ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .Q ( capture_ir ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT tms_q2_reg (.D ( tms_q1 ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .Q ( tms_q2 ) , .CDN ( n1378 ) ) ;
DFCNQD1HVT exit1_ir_reg (.D ( n1330 ) , .CP ( tck_pad_G1B8I1ASTHNet50 ) 
    , .Q ( exit1_ir ) , .CDN ( trst_padASThfnNet4 ) ) ;
DFCNQD1HVT select_dr_scan_reg (.D ( n1331 ) , .CP ( tck_pad_G1B8I6ASTHNet194 ) 
    , .Q ( select_dr_scan ) , .CDN ( trst_padASThfnNet4 ) ) ;
MUX2D0HVT U681 (.I1 ( idcode_reg_22_ ) , .Z ( n1537 ) , .S ( n1395 ) 
    , .I0 ( n1457 ) ) ;
MUX2D0HVT U683 (.I1 ( idcode_reg_21_ ) , .Z ( n1532 ) , .S ( n1392 ) 
    , .I0 ( n1454 ) ) ;
MUX2D0HVT U685 (.I1 ( idcode_reg_23_ ) , .Z ( n1524 ) , .S ( n1392 ) 
    , .I0 ( n1460 ) ) ;
MUX2D0HVT U687 (.I1 ( idcode_reg_20_ ) , .Z ( n1544 ) , .S ( n1395 ) 
    , .I0 ( n1430 ) ) ;
MUX2D0HVT U689 (.I1 ( idcode_reg_24_ ) , .Z ( n1543 ) , .S ( n1392 ) 
    , .I0 ( n1445 ) ) ;
MUX2D0HVT U691 (.I1 ( idcode_reg_19_ ) , .Z ( n1525 ) , .S ( n1394 ) 
    , .I0 ( n1421 ) ) ;
MUX2D0HVT U693 (.I1 ( idcode_reg_25_ ) , .Z ( n1528 ) , .S ( n1394 ) 
    , .I0 ( n1412 ) ) ;
DFNSND1HVT tdo_oe_pad_reg (.SDN ( trst_padASThfnNet3 ) 
    , .CPN ( tck_pad_G1B8I2ASTHNet248 ) , .D ( n1347 ) , .QN ( n1352 ) ) ;
MUX2D0HVT U695 (.I1 ( idcode_reg_18_ ) , .Z ( n1529 ) , .S ( n1393 ) 
    , .I0 ( n1436 ) ) ;
MUX2D0HVT U697 (.I1 ( idcode_reg_26_ ) , .Z ( n1539 ) , .S ( n1393 ) 
    , .I0 ( n1409 ) ) ;
MUX2D0HVT U699 (.I1 ( idcode_reg_17_ ) , .Z ( n1540 ) , .S ( n1395 ) 
    , .I0 ( n1439 ) ) ;
MUX2D0HVT U701 (.I1 ( idcode_reg_27_ ) , .Z ( n1526 ) , .S ( n1395 ) 
    , .I0 ( n1442 ) ) ;
MUX2D0HVT U703 (.I1 ( idcode_reg_16_ ) , .Z ( n1527 ) , .S ( n1393 ) 
    , .I0 ( n1418 ) ) ;
MUX2D0HVT U705 (.I1 ( idcode_reg_28_ ) , .Z ( n1542 ) , .S ( n1392 ) 
    , .I0 ( n1433 ) ) ;
MUX2D0HVT U707 (.I1 ( idcode_reg_15_ ) , .Z ( n1541 ) , .S ( n1393 ) 
    , .I0 ( n1415 ) ) ;
MUX2D0HVT U709 (.I1 ( idcode_reg_29_ ) , .Z ( n1536 ) , .S ( n1394 ) 
    , .I0 ( n1424 ) ) ;
OA21D0HVT U735 (.B ( n1479 ) , .A1 ( test_logic_reset ) , .Z ( Uc ) 
    , .A2 ( n1481 ) ) ;
OA21D0HVT U730 (.B ( n1479 ) , .A1 ( pause_dr ) , .Z ( Uj ) , .A2 ( exit1_dr ) ) ;
MUX2D0HVT U711 (.I1 ( idcode_reg_14_ ) , .Z ( n1533 ) , .S ( n1394 ) 
    , .I0 ( n1448 ) ) ;
MUX2D0HVT U713 (.I1 ( idcode_reg_30_ ) , .Z ( n1531 ) , .S ( n1392 ) 
    , .I0 ( n1427 ) ) ;
MUX2D0HVT U715 (.I1 ( idcode_reg_13_ ) , .Z ( n1538 ) , .S ( n1393 ) 
    , .I0 ( n1463 ) ) ;
MUX2D0HVT U717 (.I1 ( idcode_reg_31_ ) , .Z ( n1530 ) , .S ( n1394 ) 
    , .I0 ( n1451 ) ) ;
MUX2D0HVT U719 (.I1 ( tdi_pad ) , .Z ( n1535 ) , .S ( n1395 ) , .I0 ( n1466 ) ) ;
MUX2D0HVT U720 (.I1 ( jtag_ir_4 ) , .Z ( jtag_ir798_4 ) , .S ( capture_ir ) 
    , .I0 ( tdi_pad ) ) ;
OR2D0HVT U686 (.Z ( n1504 ) , .A1 ( n1461 ) , .A2 ( trst_padASThfnNet2 ) ) ;
OR2D0HVT U688 (.Z ( n1523 ) , .A1 ( n1431 ) , .A2 ( trst_padASThfnNet2 ) ) ;
OR2D0HVT U690 (.Z ( n1522 ) , .A1 ( n1446 ) , .A2 ( trst_padASThfnNet2 ) ) ;
AO21D0HVT U737 (.B ( n1316 ) , .A1 ( tms_pad ) , .Z ( test_logic_reset205 ) 
    , .A2 ( n1484 ) ) ;
OA21D0HVT U731 (.B ( n1480 ) , .A1 ( exit2_dr ) , .Z ( Ug ) , .A2 ( exit1_dr ) ) ;
OA21D0HVT U732 (.B ( n1479 ) , .A1 ( pause_ir ) , .Z ( Uf ) , .A2 ( exit1_ir ) ) ;
OA21D0HVT U733 (.B ( n1479 ) , .A1 ( exit2_ir ) , .Z ( Ue ) , .A2 ( Ub ) ) ;
OA21D0HVT U734 (.B ( n1480 ) , .A1 ( exit2_ir ) , .Z ( Ud ) , .A2 ( exit1_ir ) ) ;
OR2D0HVT U700 (.Z ( n1519 ) , .A1 ( n1440 ) , .A2 ( trst_padASThfnNet2 ) ) ;
OR2D0HVT U702 (.Z ( n1506 ) , .A1 ( n1443 ) , .A2 ( trst_padASThfnNet1 ) ) ;
OR2D0HVT U704 (.Z ( n1507 ) , .A1 ( n1419 ) , .A2 ( trst_padASThfnNet2 ) ) ;
OR2D0HVT U706 (.Z ( n1521 ) , .A1 ( n1434 ) , .A2 ( trst_padASThfnNet1 ) ) ;
OR2D0HVT U677 (.Z ( n_1626 ) , .A1 ( j_cfg_disable ) , .A2 ( test_logic_reset ) ) ;
OR2D0HVT U680 (.Z ( n1514 ) , .A1 ( n1467 ) , .A2 ( trst_padASThfnNet1 ) ) ;
OR2D0HVT U682 (.Z ( n1516 ) , .A1 ( n1458 ) , .A2 ( trst_padASThfnNet2 ) ) ;
OR2D0HVT U684 (.Z ( n1512 ) , .A1 ( n1455 ) , .A2 ( trst_padASThfnNet2 ) ) ;
OR2D0HVT U712 (.Z ( n1513 ) , .A1 ( n1449 ) , .A2 ( trst_padASThfnNet1 ) ) ;
OR2D0HVT U714 (.Z ( n1511 ) , .A1 ( n1428 ) , .A2 ( trst_padASThfnNet1 ) ) ;
OR2D0HVT U716 (.Z ( n1517 ) , .A1 ( n1464 ) , .A2 ( trst_padASThfnNet1 ) ) ;
OR2D0HVT U718 (.Z ( n1510 ) , .A1 ( n1452 ) , .A2 ( trst_padASThfnNet1 ) ) ;
OR2D0HVT U692 (.Z ( n1505 ) , .A1 ( n1422 ) , .A2 ( trst_padASThfnNet1 ) ) ;
OR2D0HVT U694 (.Z ( n1508 ) , .A1 ( n1413 ) , .A2 ( trst_padASThfnNet2 ) ) ;
OR2D0HVT U696 (.Z ( n1509 ) , .A1 ( n1437 ) , .A2 ( trst_padASThfnNet2 ) ) ;
OR2D0HVT U698 (.Z ( n1518 ) , .A1 ( n1410 ) , .A2 ( trst_padASThfnNet1 ) ) ;
OR2D0HVT U744 (.A2 ( n1316 ) , .A1 ( update_ir ) , .Z ( U ) ) ;
OR2D0HVT U748 (.A2 ( test_logic_reset ) , .A1 ( select_ir_scan ) , .Z ( n1484 ) ) ;
OR2D0HVT S_300 (.A2 ( cfg_en ) , .A1 ( n_1626 ) , .Z ( n_1627 ) ) ;
OR2D0HVT U736 (.A2 ( capture_ir ) , .A1 ( shift_ir ) , .Z ( Ub ) ) ;
OR2D0HVT U738 (.A2 ( n1485 ) , .A1 ( idcode_reg_11_ ) , .Z ( idcode_reg875_10 ) ) ;
OR2D0HVT U739 (.A2 ( n1485 ) , .A1 ( idcode_reg_10_ ) , .Z ( idcode_reg875_9 ) ) ;
OR2D0HVT U708 (.Z ( n1520 ) , .A1 ( n1416 ) , .A2 ( trst_padASThfnNet2 ) ) ;
OR2D0HVT U710 (.Z ( n1515 ) , .A1 ( n1425 ) , .A2 ( trst_padASThfnNet1 ) ) ;
DFCSNQD1HVT idcode_reg_reg_24_ (.Q ( idcode_reg_24_ ) , .CDN ( n1508 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1528 ) ) ;
OR3D0HVT U745 (.A1 ( run_test_idle ) , .A2 ( update_dr ) , .Z ( n1481 ) 
    , .A3 ( update_ir ) ) ;
OR3D0HVT U746 (.A1 ( latched_jtag_ir_3_ ) , .A2 ( latched_jtag_ir_1_ ) 
    , .Z ( n1493 ) , .A3 ( n1321 ) ) ;
OR3D0HVT U747 (.A1 ( latched_jtag_ir_0_ ) , .A2 ( n1351 ) , .Z ( n1503 ) 
    , .A3 ( n1483 ) ) ;
OR2D0HVT U740 (.A2 ( n1485 ) , .A1 ( idcode_reg_6_ ) , .Z ( idcode_reg875_5 ) ) ;
OR2D0HVT U741 (.A2 ( n1485 ) , .A1 ( idcode_reg_5_ ) , .Z ( idcode_reg875_4 ) ) ;
OR2D0HVT U742 (.A2 ( n1485 ) , .A1 ( idcode_reg_4_ ) , .Z ( idcode_reg875_3 ) ) ;
OR2D0HVT U743 (.A2 ( n1485 ) , .A1 ( idcode_reg_1_ ) , .Z ( idcode_reg875_0 ) ) ;
DFCSNQD1HVT idcode_reg_reg_13_ (.Q ( idcode_reg_13_ ) , .CDN ( n1513 ) 
    , .SDN ( trst_padASThfnNet1 ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .D ( n1533 ) ) ;
DFCSNQD1HVT idcode_reg_reg_31_ (.Q ( idcode_reg_31_ ) , .CDN ( n1514 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .D ( n1535 ) ) ;
DFCSNQD1HVT idcode_reg_reg_28_ (.Q ( idcode_reg_28_ ) , .CDN ( n1515 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1536 ) ) ;
DFCSNQD1HVT idcode_reg_reg_21_ (.Q ( idcode_reg_21_ ) , .CDN ( n1516 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1537 ) ) ;
DFCSNQD1HVT idcode_reg_reg_22_ (.Q ( idcode_reg_22_ ) , .CDN ( n1504 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1524 ) ) ;
DFCSNQD1HVT idcode_reg_reg_18_ (.Q ( idcode_reg_18_ ) , .CDN ( n1505 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1525 ) ) ;
DFCSNQD1HVT idcode_reg_reg_26_ (.Q ( idcode_reg_26_ ) , .CDN ( n1506 ) 
    , .SDN ( trst_padASThfnNet1 ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .D ( n1526 ) ) ;
DFCSNQD1HVT idcode_reg_reg_15_ (.Q ( idcode_reg_15_ ) , .CDN ( n1507 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1527 ) ) ;
DFCSNQD1HVT idcode_reg_reg_14_ (.Q ( idcode_reg_14_ ) , .CDN ( n1520 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .D ( n1541 ) ) ;
DFCSNQD1HVT idcode_reg_reg_27_ (.Q ( idcode_reg_27_ ) , .CDN ( n1521 ) 
    , .SDN ( trst_padASThfnNet1 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1542 ) ) ;
DFCSNQD1HVT idcode_reg_reg_23_ (.Q ( idcode_reg_23_ ) , .CDN ( n1522 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1543 ) ) ;
DFCSNQD1HVT idcode_reg_reg_19_ (.Q ( idcode_reg_19_ ) , .CDN ( n1523 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1544 ) ) ;
DFCSNQD1HVT idcode_reg_reg_17_ (.Q ( idcode_reg_17_ ) , .CDN ( n1509 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1529 ) ) ;
DFCSNQD1HVT idcode_reg_reg_30_ (.Q ( idcode_reg_30_ ) , .CDN ( n1510 ) 
    , .SDN ( trst_padASThfnNet1 ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .D ( n1530 ) ) ;
DFCSNQD1HVT idcode_reg_reg_29_ (.Q ( idcode_reg_29_ ) , .CDN ( n1511 ) 
    , .SDN ( trst_padASThfnNet1 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1531 ) ) ;
DFCSNQD1HVT idcode_reg_reg_20_ (.Q ( idcode_reg_20_ ) , .CDN ( n1512 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1532 ) ) ;
DFNCND1HVT instruction_tdo_reg (.Q ( instruction_tdo ) 
    , .CDN ( trst_padASThfnNet3 ) , .D ( jtag_ir_0 ) 
    , .CPN ( tck_pad_G1B8I2ASTHNet248 ) ) ;
DFNCND1HVT shift_ir_neg_reg (.Q ( shift_ir_neg ) , .CDN ( trst_padASThfnNet3 ) 
    , .D ( shift_ir ) , .CPN ( tck_pad_G1B8I2ASTHNet248 ) ) ;
DFNCND1HVT latched_jtag_ir_neg_reg_4_ (.Q ( latched_jtag_ir_neg_4_ ) 
    , .CDN ( trst_padASThfnNet3 ) , .D ( latched_jtag_ir_4_ ) 
    , .CPN ( tck_pad_G1B8I2ASTHNet248 ) ) ;
LND1HVT shiftla_reg (.QN ( n1326 ) , .D ( j_sft_dr ) 
    , .EN ( tck_pad_G1B8I6ASTHNet194 ) ) ;
LNQD1HVT j_smc_capla_reg (.EN ( tck_pad_G1B8I6ASTHNet194 ) , .D ( j_smc_cap ) 
    , .Q ( j_smc_capla ) ) ;
DFCSNQD1HVT idcode_reg_reg_12_ (.Q ( idcode_reg_12_ ) , .CDN ( n1517 ) 
    , .SDN ( trst_padASThfnNet1 ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .D ( n1538 ) ) ;
DFCSNQD1HVT idcode_reg_reg_25_ (.Q ( idcode_reg_25_ ) , .CDN ( n1518 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I3ASTHNet173 ) 
    , .D ( n1539 ) ) ;
DFCSNQD1HVT idcode_reg_reg_16_ (.Q ( idcode_reg_16_ ) , .CDN ( n1519 ) 
    , .SDN ( trst_padASThfnNet2 ) , .CP ( tck_pad_G1B8I5ASTHNet272 ) 
    , .D ( n1540 ) ) ;
CKBD4HVT U729 (.I ( n1478 ) , .Z ( j_cap_dr ) ) ;
DFNCND1HVT shift_dr_neg_reg (.CDN ( trst_padASThfnNet4 ) , .QN ( n1548 ) 
    , .D ( j_sft_dr ) , .CPN ( tck_pad_G1B8I6ASTHNet194 ) ) ;
DFNCND1HVT latched_jtag_ir_neg_reg_3_ (.Q ( latched_jtag_ir_neg_3_ ) 
    , .CDN ( trst_padASThfnNet3 ) , .D ( latched_jtag_ir_3_ ) 
    , .CPN ( tck_pad_G1B8I2ASTHNet248 ) ) ;
DFNCND1HVT latched_jtag_ir_neg_reg_2_ (.Q ( latched_jtag_ir_neg_2_ ) 
    , .CDN ( trst_padASThfnNet3 ) , .QN ( n1334 ) , .D ( latched_jtag_ir_2_ ) 
    , .CPN ( tck_pad_G1B8I2ASTHNet248 ) ) ;
DFNCND1HVT latched_jtag_ir_neg_reg_1_ (.Q ( latched_jtag_ir_neg_1_ ) 
    , .CDN ( trst_padASThfnNet3 ) , .QN ( n1335 ) , .D ( latched_jtag_ir_1_ ) 
    , .CPN ( tck_pad_G1B8I2ASTHNet248 ) ) ;
DFNCND1HVT latched_jtag_ir_neg_reg_0_ (.Q ( latched_jtag_ir_neg_0_ ) 
    , .CDN ( trst_padASThfnNet3 ) , .QN ( n1309 ) , .D ( latched_jtag_ir_0_ ) 
    , .CPN ( tck_pad_G1B8I2ASTHNet248 ) ) ;
DFNCND1HVT bypassed_tdo_reg (.Q ( bypassed_tdo ) , .CDN ( trst_padASThfnNet3 ) 
    , .D ( bypass_reg ) , .CPN ( tck_pad_G1B8I2ASTHNet248 ) ) ;
DFNCND1HVT idcode_tdo_reg (.Q ( n1310 ) , .CDN ( trst_padASThfnNet3 ) 
    , .D ( idcode_reg_0_ ) , .CPN ( tck_pad_G1B8I2ASTHNet248 ) ) ;
CKND0HVT U489 (.I ( gio_hz ) , .ZN ( n1304 ) ) ;
CKBD8HVT CKBD8HVTG1B4I1 (.Z ( tck_pad_G1B4I1_1ASTHNet188 ) 
    , .I ( tck_pad_G1B3I1_1ASTHNet273 ) ) ;
BUFFD12HVT U753 (.I ( n1491 ) , .Z ( tdo_pad ) ) ;
BUFFD12HVT U756 (.I ( tck_padASTHIRNet103 ) , .Z ( j_tck_GBASTHIRNet95 ) ) ;
AN4D0HVT U483 (.A1 ( n1312 ) , .Z ( n1302 ) , .A3 ( latched_jtag_ir_4_ ) 
    , .A2 ( n1351 ) , .A4 ( latched_jtag_ir_0_ ) ) ;
AOI21D0HVT U484 (.A2 ( n1318 ) , .ZN ( Ui ) , .A1 ( n1303 ) , .B ( tms_pad ) ) ;
BUFFD8HVT U602 (.I ( n1476 ) , .Z ( tdo_oe_pad ) ) ;
BUFFD8HVT U546 (.I ( n1353 ) , .Z ( j_shift0 ) ) ;
CKND0HVT U494 (.I ( j_smc_capla ) , .ZN ( n1307 ) ) ;
CKND0HVT U508 (.I ( n1316 ) , .ZN ( n1502 ) ) ;
CKND0HVT U519 (.I ( j_cfg_enable ) , .ZN ( n1487 ) ) ;
CKND0HVT U523 (.I ( tms_pad ) , .ZN ( n1479 ) ) ;
CKND0HVT U525 (.I ( n1494 ) , .ZN ( n1480 ) ) ;
CKND0HVT U527 (.I ( md_jtag ) , .ZN ( cfg_en ) ) ;
CKND0HVT U528 (.I ( select_dr_scan ) , .ZN ( n1495 ) ) ;
CKND0HVT U485 (.I ( exit2_dr ) , .ZN ( n1303 ) ) ;
endmodule




module spare_module ();

/* wire declarations */

wire spare_net_TIELHVT_0 ;
wire spare_net_TIELHVT_1 ;
wire spare_net_TIELHVT_2 ;

CKBD1HVT spare_BUFFD3HVT_2 (.I ( spare_net_TIELHVT_0 ) ) ;
CKBD1HVT spare_BUFFD3HVT_1 (.I ( spare_net_TIELHVT_0 ) ) ;
CKBD1HVT spare_BUFFD3HVT_0 (.I ( spare_net_TIELHVT_0 ) ) ;
INVD1HVT spare_INVD4HVT_3 (.I ( spare_net_TIELHVT_1 ) ) ;
INVD1HVT spare_INVD4HVT_2 (.I ( spare_net_TIELHVT_1 ) ) ;
INVD1HVT spare_INVD4HVT_1 (.I ( spare_net_TIELHVT_1 ) ) ;
INVD1HVT spare_INVD4HVT_0 (.I ( spare_net_TIELHVT_1 ) ) ;
TIELHVT spare_TIELHVT_0 (.ZN ( spare_net_TIELHVT_0 ) ) ;
TIELHVT spare_TIELHVT_1 (.ZN ( spare_net_TIELHVT_1 ) ) ;
TIELHVT spare_TIELHVT_2 (.ZN ( spare_net_TIELHVT_2 ) ) ;
CKBD1HVT spare_BUFFD3HVT_3 (.I ( spare_net_TIELHVT_0 ) ) ;
ND2D0HVT spare_ND2D1HVT_3 (.A1 ( spare_net_TIELHVT_2 ) 
    , .A2 ( spare_net_TIELHVT_2 ) ) ;
ND2D0HVT spare_ND2D1HVT_2 (.A1 ( spare_net_TIELHVT_2 ) 
    , .A2 ( spare_net_TIELHVT_2 ) ) ;
ND2D0HVT spare_ND2D1HVT_1 (.A1 ( spare_net_TIELHVT_2 ) 
    , .A2 ( spare_net_TIELHVT_2 ) ) ;
ND2D0HVT spare_ND2D1HVT_0 (.A1 ( spare_net_TIELHVT_2 ) 
    , .A2 ( spare_net_TIELHVT_2 ) ) ;
EDFCND1HVT spare_EDFCND1HVT_0 (.E ( spare_net_TIELHVT_0 ) 
    , .CP ( spare_net_TIELHVT_0 ) , .D ( spare_net_TIELHVT_0 ) 
    , .CDN ( spare_net_TIELHVT_0 ) ) ;
EDFCND1HVT spare_EDFCND1HVT_1 (.E ( spare_net_TIELHVT_0 ) 
    , .CP ( spare_net_TIELHVT_0 ) , .D ( spare_net_TIELHVT_0 ) 
    , .CDN ( spare_net_TIELHVT_0 ) ) ;
DFCNQD1HVT spare_DFCNQD1HVT_1 (.D ( spare_net_TIELHVT_1 ) 
    , .CP ( spare_net_TIELHVT_1 ) , .CDN ( spare_net_TIELHVT_1 ) ) ;
DFCNQD1HVT spare_DFCNQD1HVT_0 (.D ( spare_net_TIELHVT_1 ) 
    , .CP ( spare_net_TIELHVT_1 ) , .CDN ( spare_net_TIELHVT_1 ) ) ;
MUX2D0HVT spare_MUX2D0HVT_2 (.I1 ( spare_net_TIELHVT_2 ) 
    , .S ( spare_net_TIELHVT_2 ) , .I0 ( spare_net_TIELHVT_2 ) ) ;
MUX2D0HVT spare_MUX2D0HVT_1 (.I1 ( spare_net_TIELHVT_2 ) 
    , .S ( spare_net_TIELHVT_2 ) , .I0 ( spare_net_TIELHVT_2 ) ) ;
MUX2D0HVT spare_MUX2D0HVT_0 (.I1 ( spare_net_TIELHVT_2 ) 
    , .S ( spare_net_TIELHVT_2 ) , .I0 ( spare_net_TIELHVT_2 ) ) ;
MUX2D0HVT spare_MUX2D0HVT_3 (.I1 ( spare_net_TIELHVT_2 ) 
    , .S ( spare_net_TIELHVT_2 ) , .I0 ( spare_net_TIELHVT_2 ) ) ;
NR2D0HVT spare_NR2D1HVT_2 (.A1 ( spare_net_TIELHVT_1 ) 
    , .A2 ( spare_net_TIELHVT_1 ) ) ;
NR2D0HVT spare_NR2D1HVT_1 (.A1 ( spare_net_TIELHVT_1 ) 
    , .A2 ( spare_net_TIELHVT_1 ) ) ;
NR2D0HVT spare_NR2D1HVT_0 (.A1 ( spare_net_TIELHVT_1 ) 
    , .A2 ( spare_net_TIELHVT_1 ) ) ;
NR2D0HVT spare_NR2D1HVT_3 (.A1 ( spare_net_TIELHVT_1 ) 
    , .A2 ( spare_net_TIELHVT_1 ) ) ;
endmodule




module smc_and_jtag (nvcm_spi_sdi , nvcm_spi_sdo , osc_clk , por_b , 
    rst_b , cnt_podt_out , smc_podt_rst , smc_podt_off , creset_b , 
    cdone_in , smc_oscoff_b , smc_osc_fsel , gint_hz , gsr , 
    nvcm_spi_ss_b , psdi , nvcm_spi_sdo_oe_b , nvcm_relextspi , 
    nvcm_boot , smc_load_nvcm_bstream , nvcm_rdy , bp0 , coldboot_sel , 
    cdone_out , spi_clk_in , psdo , boot , warmboot_sel , md_spi_b , 
    spi_ss_in_b , spi_ss_out_b , spi_sdi , spi_sdo , spi_sdo_oe_b , 
    end_of_startup , en_8bconfig_b , bm_clk , bm_banksel , bm_bank_sdi , 
    spi_clk_out , bm_bank_sdo , bm_init , cm_clk , bm_sweb , bm_sreb , 
    bm_sclkrw , bm_wdummymux_en , bm_rcapmux_en , bm_sa , cm_sdo_u2 , 
    cm_sdi_u0 , cm_sdi_u1 , cm_sdi_u2 , smc_row_inc , smc_wset_prec , 
    cm_sdi_u3 , cm_sdo_u0 , cm_sdo_u1 , smc_wdis_dclk , data_muxsel , 
    cm_sdo_u3 , smc_write , smc_read , smc_seq_rst , smc_rsr_rst , 
    smc_wwlwrt_dis , smc_wcram_rst , smc_wset_precgnd , smc_wwlwrt_en , 
    smc_rwl_en , data_muxsel1 , j_sft_dr , j_upd_dr , smc_rpull_b , 
    smc_rprec , smc_rrst_pullwlen , cm_last_rsr , cm_monitor_cell , 
    j_tdi , bs_en , tms_pad , tck_pad , trst_pad , tdi_pad , tdo_pad , 
    tdo_oe_pad , j_rst_b , j_hiz_b , j_mode , j_row_test , bschain_sdo , 
    j_tck , cm_banksel , j_ceb0 , j_shift0 , idcode_msb20bits );
output nvcm_spi_sdi ;
input  nvcm_spi_sdo ;
input  osc_clk ;
input  por_b ;
output rst_b ;
input  cnt_podt_out ;
output smc_podt_rst ;
output smc_podt_off ;
input  creset_b ;
input  cdone_in ;
output smc_oscoff_b ;
output [1:0] smc_osc_fsel ;
output gint_hz ;
output gsr ;
output nvcm_spi_ss_b ;
input  [7:1] psdi ;
input  nvcm_spi_sdo_oe_b ;
input  nvcm_relextspi ;
input  nvcm_boot ;
output smc_load_nvcm_bstream ;
input  nvcm_rdy ;
input  bp0 ;
input  [1:0] coldboot_sel ;
output cdone_out ;
input  spi_clk_in ;
output [7:1] psdo ;
input  boot ;
input  [1:0] warmboot_sel ;
output md_spi_b ;
input  spi_ss_in_b ;
output spi_ss_out_b ;
input  spi_sdi ;
output spi_sdo ;
output spi_sdo_oe_b ;
output end_of_startup ;
output en_8bconfig_b ;
output bm_clk ;
output [3:0] bm_banksel ;
output [3:0] bm_bank_sdi ;
output spi_clk_out ;
input  [3:0] bm_bank_sdo ;
output bm_init ;
output cm_clk ;
output bm_sweb ;
output bm_sreb ;
output bm_sclkrw ;
output bm_wdummymux_en ;
output bm_rcapmux_en ;
output [7:0] bm_sa ;
input  [1:0] cm_sdo_u2 ;
output [1:0] cm_sdi_u0 ;
output [1:0] cm_sdi_u1 ;
output [1:0] cm_sdi_u2 ;
output smc_row_inc ;
output smc_wset_prec ;
output [1:0] cm_sdi_u3 ;
input  [1:0] cm_sdo_u0 ;
input  [1:0] cm_sdo_u1 ;
output smc_wdis_dclk ;
output data_muxsel ;
input  [1:0] cm_sdo_u3 ;
output smc_write ;
output smc_read ;
output smc_seq_rst ;
output smc_rsr_rst ;
output smc_wwlwrt_dis ;
output smc_wcram_rst ;
output smc_wset_precgnd ;
output smc_wwlwrt_en ;
output smc_rwl_en ;
output data_muxsel1 ;
output j_sft_dr ;
output j_upd_dr ;
output smc_rpull_b ;
output smc_rprec ;
output smc_rrst_pullwlen ;
input  cm_last_rsr ;
input  [3:0] cm_monitor_cell ;
output j_tdi ;
output bs_en ;
input  tms_pad ;
input  tck_pad ;
input  trst_pad ;
input  tdi_pad ;
output tdo_pad ;
output tdo_oe_pad ;
output j_rst_b ;
output j_hiz_b ;
output j_mode ;
output j_row_test ;
input  bschain_sdo ;
output j_tck ;
output [3:0] cm_banksel ;
output j_ceb0 ;
output j_shift0 ;
input  [19:0] idcode_msb20bits ;

/* wire declarations */
wire spi_clk_out_GBASTHIRNet157 ;
wire [31:0] j_idcode_reg ;
wire j_tck_GBASTHIRNet93 ;
wire md_jtag ;
wire j_cfg_enable ;
wire j_cfg_disable ;
wire cnt_podt_out_eco ;
wire j_sft_drASTttcNet28 ;
wire j_usercode ;
wire gio_hz ;
wire en_8bconfig_bASTttcNet35 ;
wire j_cfg_program ;
wire j_smc_cap ;
wire j_tdo ;
wire rst_bASTttcNet29 ;
wire smc_rsr_rstASTttcNet32 ;



config_top Iconfig_top (.bm_bank_sdo ( bm_bank_sdo ) , 
    .cm_sdo_u0 ( cm_sdo_u0 ) , .cm_sdo_u1 ( cm_sdo_u1 ) , 
    .cm_sdi_u2 ( cm_sdi_u2 ) , .cm_sdi_u0 ( cm_sdi_u0 ) , 
    .smc_rwl_en ( smc_rwl_en ) , .data_muxsel1 ( data_muxsel1 ) , 
    .spi_sdo ( spi_sdo ) , .osc_clkASTHIRNet250 ( osc_clk ) , 
    .spi_clk_out_GBASTHIRNet165 ( spi_clk_out_GBASTHIRNet157 ) , 
    .warmboot_sel ( warmboot_sel ) , .smc_osc_fsel ( smc_osc_fsel ) , 
    .smc_row_inc ( smc_row_inc ) , .smc_wset_prec ( smc_wset_prec ) , 
    .smc_wwlwrt_dis ( smc_wwlwrt_dis ) , .smc_wcram_rst ( smc_wcram_rst ) , 
    .smc_wset_precgnd ( smc_wset_precgnd ) , .smc_wwlwrt_en ( smc_wwlwrt_en ) , 
    .smc_wdis_dclk ( smc_wdis_dclk ) , .data_muxsel ( data_muxsel ) , 
    .psdi ( psdi ) , .psdo ( psdo ) , .j_idcode_reg ( j_idcode_reg ) , 
    .cm_sdo_u3 ( cm_sdo_u3 ) , .bm_bank_sdi ( bm_bank_sdi ) , 
    .cm_sdo_u2 ( cm_sdo_u2 ) , .coldboot_sel ( coldboot_sel ) , 
    .cm_sdi_u1 ( cm_sdi_u1 ) , .cm_banksel ( cm_banksel ) , 
    .smc_rpull_b ( smc_rpull_b ) , .smc_rprec ( smc_rprec ) , 
    .smc_rrst_pullwlen ( smc_rrst_pullwlen ) , .bm_clk ( bm_clk ) , 
    .bm_sweb ( bm_sweb ) , .bm_sreb ( bm_sreb ) , .cm_sdi_u3 ( cm_sdi_u3 ) , 
    .cm_monitor_cell ( cm_monitor_cell ) , 
    .spi_clk_out_GBASTHIRNet163 ( spi_clk_out_GBASTHIRNet157 ) , 
    .j_tck_GBASTHIRNet97 ( j_tck_GBASTHIRNet93 ) , .bm_sclkrw ( bm_sclkrw ) , 
    .bm_wdummymux_en ( bm_wdummymux_en ) , .bm_rcapmux_en ( bm_rcapmux_en ) , 
    .bm_init ( bm_init ) , .bm_banksel ( bm_banksel ) , .bm_sa ( bm_sa ) , 
    .nvcm_spi_sdo_oe_b ( nvcm_spi_sdo_oe_b ) , 
    .nvcm_relextspi ( nvcm_relextspi ) , .nvcm_boot ( nvcm_boot ) , 
    .nvcm_rdy ( nvcm_rdy ) , .bp0 ( bp0 ) , .creset_b ( creset_b ) , 
    .por_b ( por_b ) , .md_jtag ( md_jtag ) , .j_tdi ( j_tdi ) , 
    .j_rst_b ( j_rst_b ) , .j_cfg_enable ( j_cfg_enable ) , 
    .j_cfg_disable ( j_cfg_disable ) , .cnt_podt_out ( cnt_podt_out_eco ) , 
    .nvcm_spi_sdo ( nvcm_spi_sdo ) , .j_sft_dr ( j_sft_drASTttcNet28 ) , 
    .j_usercode ( j_usercode ) , .spi_ss_in_b ( spi_ss_in_b ) , 
    .spi_clk_in ( spi_clk_in ) , .spi_sdi ( spi_sdi ) , 
    .cm_last_rsr ( cm_last_rsr ) , .cdone_in ( cdone_in ) , .boot ( boot ) , 
    .smc_podt_off ( smc_podt_off ) , .smc_oscoff_b ( smc_oscoff_b ) , 
    .gint_hz ( gint_hz ) , .gio_hz ( gio_hz ) , .gsr ( gsr ) , 
    .en_8bconfig_b ( en_8bconfig_bASTttcNet35 ) , 
    .j_cfg_program ( j_cfg_program ) , .j_cap_dr ( j_smc_cap ) , 
    .nvcm_spi_sdi ( nvcm_spi_sdi ) , 
    .smc_load_nvcm_bstream ( smc_load_nvcm_bstream ) , .cdone_out ( cdone_out ) , 
    .j_tdo ( j_tdo ) , .md_spi_b ( md_spi_b ) , .spi_ss_out_b ( spi_ss_out_b ) , 
    .rst_b ( rst_bASTttcNet29 ) , .smc_podt_rst ( smc_podt_rst ) , 
    .spi_sdo_oe_b ( spi_sdo_oe_b ) , .cm_clk ( cm_clk ) , 
    .smc_write ( smc_write ) , .smc_read ( smc_read ) , 
    .smc_seq_rst ( smc_seq_rst ) , .smc_rsr_rst ( smc_rsr_rstASTttcNet32 ) , 
    .end_of_startup ( end_of_startup ) , .nvcm_spi_ss_b ( nvcm_spi_ss_b ) ) ;


tap_controller Itap_controller (.j_hiz_b ( j_hiz_b ) , 
    .tck_padASTHIRNet103 ( tck_pad ) , .j_usercode ( j_usercode ) , 
    .j_tck_GBASTHIRNet95 ( j_tck_GBASTHIRNet93 ) , .j_shift0 ( j_shift0 ) , 
    .j_idcode_reg ( j_idcode_reg ) , .idcode_msb20bits ( idcode_msb20bits ) , 
    .bschain_sdo ( bschain_sdo ) , .smc_sdo ( j_tdo ) , .gio_hz ( gio_hz ) , 
    .tdo_pad ( tdo_pad ) , .tdo_oe_pad ( tdo_oe_pad ) , 
    .j_sft_dr ( j_sft_drASTttcNet28 ) , .tms_pad ( tms_pad ) , 
    .j_smc_cap ( j_smc_cap ) , .j_rst_b ( j_rst_b ) , 
    .j_cfg_enable ( j_cfg_enable ) , .j_cfg_disable ( j_cfg_disable ) , 
    .j_cfg_program ( j_cfg_program ) , .md_jtag ( md_jtag ) , 
    .trst_pad ( trst_pad ) , .tdi_pad ( tdi_pad ) , .j_mode ( j_mode ) , 
    .j_row_test ( j_row_test ) , .j_tdi ( j_tdi ) , .bs_en ( bs_en ) , 
    .j_ceb0 ( j_ceb0 ) , .j_upd_dr ( j_upd_dr ) ) ;


spare_module SPARE_GATES () ;

BUFFD8HVT shift_dr_regASTttcInst29 (.Z ( j_sft_dr ) 
    , .I ( j_sft_drASTttcNet28 ) ) ;
BUFFD8HVT rst_b_regASTttcInst30 (.Z ( rst_b ) , .I ( rst_bASTttcNet29 ) ) ;
BUFFD8HVT smc_rsr_rst_regASTttcInst32 (.Z ( smc_rsr_rst ) 
    , .I ( smc_rsr_rstASTttcNet32 ) ) ;
BUFFD8HVT U1141ASTttcInst34 (.Z ( en_8bconfig_b ) 
    , .I ( en_8bconfig_bASTttcNet35 ) ) ;
CKBD6HVT CKBD6HVTGB_1 (.Z ( spi_clk_out ) , .I ( spi_clk_out_GBASTHIRNet157 ) ) ;
CKBD6HVT CKBD6HVTGB (.Z ( j_tck ) , .I ( j_tck_GBASTHIRNet93 ) ) ;
DEL3HVT UECO_001 (.Z ( cnt_podt_out_eco ) , .I ( cnt_podt_out ) ) ;
endmodule


