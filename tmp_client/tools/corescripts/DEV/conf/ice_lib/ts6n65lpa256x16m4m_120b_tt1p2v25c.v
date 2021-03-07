//****************************************************************************** */
//*                                                                              */
//*STATEMENT OF USE                                                              */
//*                                                                              */
//*This information contains confidential and proprietary information of TSMC.   */
//*No part of this information may be reproduced, transmitted, transcribed,      */
//*stored in a retrieval system, or translated into any human or computer        */
//*language, in any form or by any means, electronic, mechanical, magnetic,      */
//*optical, chemical, manual, or otherwise, without the prior written permission */
//*of TSMC. This information was prepared for informational purpose and is for   */
//*use by TSMC's customers only. TSMC reserves the right to make changes in the  */
//*information at any time and without notice.                                   */
//*                                                                              */
//****************************************************************************** */
//****************************************************************************** */
//*        Compiler Version : TSMC MEMORY COMPILER tsmcn65lp2prf_2006.09.01.a.120b */
//*        Memory Type      : TSMC 65nm Low Power Two Port Register File */
//*                           with BIST Interface */
//*        Library Name     : ts6n65lpa256x16m4m (user specify : TS6N65LPA256X16M4M) */
//*        Library Version  : 120b */
//*        Generated Time   : 2007/05/31, 18:18:15 */
//********************************************************************* *** **** */
 

`timescale 1ns/1ps

`celldefine

`ifdef UNIT_DELAY
`define SRAM_DELAY 0.010
`endif

`suppress_faults
`enable_portfaults

module TS6N65LPA256X16M4M
  (AA,
  D,
  BWEB,
  WEB,CLKW,
  AB,
  REB,CLKR,
  AMA,
  DM,
  BWEBM,
  WEBM,
  AMB,
  REBM,BIST,
  Q);

// Parameter declarations
parameter  N = 16;
parameter  W = 256;
parameter  M = 8;

// Input-Output declarations
   input [M-1:0] AA;                // Address write bus
   input [N-1:0] D;                 // Date input bus
   input [N-1:0] BWEB;              // BW data input bus
   input         WEB;               // Active-low Write enable
   input         CLKW;              // Clock A
   input [M-1:0] AB;                // Address read bus 
   input         REB;               // Active-low Read enable
   input         CLKR;              // Clock B

   input [M-1:0] AMA;               // Address write bus 
   input [N-1:0] DM;                // Date input bus  
   input [N-1:0] BWEBM;             // BW data input bus
   input         WEBM;              // Active-low Write enable
   input [M-1:0] AMB;               // Address read bus 
   input         REBM;              // Active-low Read enable 
   input         BIST;
   output [N-1:0] Q;                 // Data output bus

`ifdef no_warning
parameter MES_ALL = "OFF";
`else
parameter MES_ALL = "ON";
`endif


// Registers
reg [N-1:0] DL;

reg [N-1:0] BWEBL;

reg [M-1:0] AAL;
reg [M-1:0] ABL;

reg WEBL;
reg REBL;
wire [N-1:0] QL;

reg valid_mf;
reg valid_ck;
reg valid_bwa;
reg valid_bwb;
reg valid_wea;
reg valid_reb;
reg valid_aa;
reg valid_ab;
reg valid_csw;
reg valid_contention;

reg EN;
reg RDA, RDB;

wire [N-1:0] bBWEB;

wire [N-1:0] bD;

wire [M-1:0] bAA;
wire [M-1:0] bAB;

wire bWEB;
wire bREB;
wire bCLKW,bCLKR;

reg [N-1:0] bQ;
wire [N-1:0] bbQ;

wire [N-1:0] bBWEBM;
wire [N-1:0] bDM;
wire [M-1:0] bAMA;
wire [M-1:0] bAMB;
wire bWEBM;
wire bREBM;
wire bBIST;
wire NOBIST;

integer i;
 
// Address Inputs
buf sAA0 (bAA[0], AA[0]);
buf sAB0 (bAB[0], AB[0]);
buf sAA1 (bAA[1], AA[1]);
buf sAB1 (bAB[1], AB[1]);
buf sAA2 (bAA[2], AA[2]);
buf sAB2 (bAB[2], AB[2]);
buf sAA3 (bAA[3], AA[3]);
buf sAB3 (bAB[3], AB[3]);
buf sAA4 (bAA[4], AA[4]);
buf sAB4 (bAB[4], AB[4]);
buf sAA5 (bAA[5], AA[5]);
buf sAB5 (bAB[5], AB[5]);
buf sAA6 (bAA[6], AA[6]);
buf sAB6 (bAB[6], AB[6]);
buf sAA7 (bAA[7], AA[7]);
buf sAB7 (bAB[7], AB[7]);

buf sAMA0 (bAMA[0], AMA[0]);
buf sAMB0 (bAMB[0], AMB[0]);
buf sAMA1 (bAMA[1], AMA[1]);
buf sAMB1 (bAMB[1], AMB[1]);
buf sAMA2 (bAMA[2], AMA[2]);
buf sAMB2 (bAMB[2], AMB[2]);
buf sAMA3 (bAMA[3], AMA[3]);
buf sAMB3 (bAMB[3], AMB[3]);
buf sAMA4 (bAMA[4], AMA[4]);
buf sAMB4 (bAMB[4], AMB[4]);
buf sAMA5 (bAMA[5], AMA[5]);
buf sAMB5 (bAMB[5], AMB[5]);
buf sAMA6 (bAMA[6], AMA[6]);
buf sAMB6 (bAMB[6], AMB[6]);
buf sAMA7 (bAMA[7], AMA[7]);
buf sAMB7 (bAMB[7], AMB[7]);

// Bit Write/Data Inputs 
buf sD0 (bD[0], D[0]);
buf sBWEB0 (bBWEB[0], BWEB[0]);
buf sD1 (bD[1], D[1]);
buf sBWEB1 (bBWEB[1], BWEB[1]);
buf sD2 (bD[2], D[2]);
buf sBWEB2 (bBWEB[2], BWEB[2]);
buf sD3 (bD[3], D[3]);
buf sBWEB3 (bBWEB[3], BWEB[3]);
buf sD4 (bD[4], D[4]);
buf sBWEB4 (bBWEB[4], BWEB[4]);
buf sD5 (bD[5], D[5]);
buf sBWEB5 (bBWEB[5], BWEB[5]);
buf sD6 (bD[6], D[6]);
buf sBWEB6 (bBWEB[6], BWEB[6]);
buf sD7 (bD[7], D[7]);
buf sBWEB7 (bBWEB[7], BWEB[7]);
buf sD8 (bD[8], D[8]);
buf sBWEB8 (bBWEB[8], BWEB[8]);
buf sD9 (bD[9], D[9]);
buf sBWEB9 (bBWEB[9], BWEB[9]);
buf sD10 (bD[10], D[10]);
buf sBWEB10 (bBWEB[10], BWEB[10]);
buf sD11 (bD[11], D[11]);
buf sBWEB11 (bBWEB[11], BWEB[11]);
buf sD12 (bD[12], D[12]);
buf sBWEB12 (bBWEB[12], BWEB[12]);
buf sD13 (bD[13], D[13]);
buf sBWEB13 (bBWEB[13], BWEB[13]);
buf sD14 (bD[14], D[14]);
buf sBWEB14 (bBWEB[14], BWEB[14]);
buf sD15 (bD[15], D[15]);
buf sBWEB15 (bBWEB[15], BWEB[15]);

buf sDM0 (bDM[0], DM[0]);
buf sBWEBM0 (bBWEBM[0], BWEBM[0]);
buf sDM1 (bDM[1], DM[1]);
buf sBWEBM1 (bBWEBM[1], BWEBM[1]);
buf sDM2 (bDM[2], DM[2]);
buf sBWEBM2 (bBWEBM[2], BWEBM[2]);
buf sDM3 (bDM[3], DM[3]);
buf sBWEBM3 (bBWEBM[3], BWEBM[3]);
buf sDM4 (bDM[4], DM[4]);
buf sBWEBM4 (bBWEBM[4], BWEBM[4]);
buf sDM5 (bDM[5], DM[5]);
buf sBWEBM5 (bBWEBM[5], BWEBM[5]);
buf sDM6 (bDM[6], DM[6]);
buf sBWEBM6 (bBWEBM[6], BWEBM[6]);
buf sDM7 (bDM[7], DM[7]);
buf sBWEBM7 (bBWEBM[7], BWEBM[7]);
buf sDM8 (bDM[8], DM[8]);
buf sBWEBM8 (bBWEBM[8], BWEBM[8]);
buf sDM9 (bDM[9], DM[9]);
buf sBWEBM9 (bBWEBM[9], BWEBM[9]);
buf sDM10 (bDM[10], DM[10]);
buf sBWEBM10 (bBWEBM[10], BWEBM[10]);
buf sDM11 (bDM[11], DM[11]);
buf sBWEBM11 (bBWEBM[11], BWEBM[11]);
buf sDM12 (bDM[12], DM[12]);
buf sBWEBM12 (bBWEBM[12], BWEBM[12]);
buf sDM13 (bDM[13], DM[13]);
buf sBWEBM13 (bBWEBM[13], BWEBM[13]);
buf sDM14 (bDM[14], DM[14]);
buf sBWEBM14 (bBWEBM[14], BWEBM[14]);
buf sDM15 (bDM[15], DM[15]);
buf sBWEBM15 (bBWEBM[15], BWEBM[15]);

// Input Controls
buf sWEB (bWEB, WEB);
buf sREB (bREB, REB);

buf sCLKW (bCLKW, CLKW);
buf sCLKR (bCLKR, CLKR);

buf sWE (WE, !bWEB);
buf sRE (RE, !bREB);

buf sWEBM (bWEBM, WEBM);
buf sREBM (bREBM, REBM);
buf sBIST (bBIST, BIST);

// Output Data
buf sQ0 (Q[0], bbQ[0]);
buf sQ1 (Q[1], bbQ[1]);
buf sQ2 (Q[2], bbQ[2]);
buf sQ3 (Q[3], bbQ[3]);
buf sQ4 (Q[4], bbQ[4]);
buf sQ5 (Q[5], bbQ[5]);
buf sQ6 (Q[6], bbQ[6]);
buf sQ7 (Q[7], bbQ[7]);
buf sQ8 (Q[8], bbQ[8]);
buf sQ9 (Q[9], bbQ[9]);
buf sQ10 (Q[10], bbQ[10]);
buf sQ11 (Q[11], bbQ[11]);
buf sQ12 (Q[12], bbQ[12]);
buf sQ13 (Q[13], bbQ[13]);
buf sQ14 (Q[14], bbQ[14]);
buf sQ15 (Q[15], bbQ[15]);

assign bbQ=bQ;

buf sNOBIST (NOBIST, !bBIST);
and sANOBIST (ANOBIST, !bWEB, !bBIST);
and sBNOBIST (BNOBIST, !bREB, !bBIST);

and sABIST (ABIST, !bWEBM, bBIST);
and sBBIST (BBIST, !bREBM, bBIST);

wire AeqB, BeqA;
wire AbeforeB, BbeforeA;

real CLKR_time, CLKW_time;
 
`ifdef UNIT_DELAY
wire AeqBL;
assign AeqBL = ( (AAL == ABL) ) ? 1'b1:1'b0;
`else

wire CLK_same;   
assign CLK_same = ((CLKR_time == CLKW_time)?1'b1:1'b0);

assign AeqB = ( ((bAA == bAB) && CLK_same && !bBIST) || ((AAL == bAB) && !CLK_same && !bBIST) || ((bAMA == bAMB) && CLK_same && bBIST) || ((AAL == bAMB) && !CLK_same && bBIST)) ? 1'b1:1'b0;
assign BeqA = ( ((bAB == bAA) && CLK_same && !bBIST) || ((ABL == bAA) && !CLK_same && !bBIST) || ((bAMB == bAMA) && CLK_same && bBIST) || ((ABL == bAMA) && !CLK_same && bBIST)) ? 1'b1:1'b0;

assign AbeforeB = (((!bWEB && !bREB && CLK_same && !bBIST) || (!WEBL && !bREB && !CLK_same && !bBIST) || (!bWEBM && !bREBM && CLK_same && bBIST) || (!WEBL && !bREBM && !CLK_same && bBIST )) && AeqB) ? 1'b1:1'b0;

assign BbeforeA = (((!bREB && !bWEB && CLK_same && !bBIST) || (!REBL && !bWEB && !CLK_same && !bBIST) || (!bREBM && !bWEBM && CLK_same && bBIST) || (!REBL && !bWEBM && !CLK_same && bBIST )) && BeqA) ? 1'b1:1'b0;

`endif

`ifdef UNIT_DELAY
`else
specify
   specparam PATHPULSE$CLKR$Q = ( 0, 0.001 );

specparam
ckpl = 0.2204259,
ckph = 0.2749548,
ckwp = 0.9104716,
ckrp = 1.1142150,
cksep = 0.715,

aas = 0.2842985,
aah = 0.0000000,
abs = 0.2831748,
abh = 0.0000000,
ds = 0.3097849,
dh = 0.0000000,
wes = 0.2744826,
weh = 0.0000000,
res = 0.2745434,
reh = 0.0000000,
bws = 0.2656174,
bwh = 0.0000000,

amas = 0.2845931,
amah = 0.0000000,
ambs = 0.2835549,
ambh = 0.0000000,
dms = 0.3100949,
dmh = 0.0000000,
wems = 0.2744074,
wemh = 0.0000000,
rems = 0.2738100,
remh = 0.0000000,
bwms = 0.2647100,
bwmh = 0.0000000,
bists = 1.577,
bisth = 0.000,
ckq = 0.6730462,
ckqh = 0.5296029;

  $recovery (posedge CLKW, posedge CLKR &&& AbeforeB, cksep, valid_contention);
  $recovery (posedge CLKR, posedge CLKW &&& BbeforeA, cksep, valid_contention);

  $setuphold (posedge CLKW &&& ABIST, posedge AMA[0], amas, amah, valid_aa);
  $setuphold (posedge CLKW &&& ABIST, negedge AMA[0], amas, amah, valid_aa);
  $setuphold (posedge CLKR &&& BBIST, posedge AMB[0], ambs, ambh, valid_ab);
  $setuphold (posedge CLKR &&& BBIST, negedge AMB[0], ambs, ambh, valid_ab);
 
  $setuphold (posedge CLKW &&& ANOBIST, posedge AA[0], aas, aah, valid_aa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge AA[0], aas, aah, valid_aa);
  $setuphold (posedge CLKR &&& BNOBIST, posedge AB[0], abs, abh, valid_ab);
  $setuphold (posedge CLKR &&& BNOBIST, negedge AB[0], abs, abh, valid_ab);
  $setuphold (posedge CLKW &&& ABIST, posedge AMA[1], amas, amah, valid_aa);
  $setuphold (posedge CLKW &&& ABIST, negedge AMA[1], amas, amah, valid_aa);
  $setuphold (posedge CLKR &&& BBIST, posedge AMB[1], ambs, ambh, valid_ab);
  $setuphold (posedge CLKR &&& BBIST, negedge AMB[1], ambs, ambh, valid_ab);
 
  $setuphold (posedge CLKW &&& ANOBIST, posedge AA[1], aas, aah, valid_aa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge AA[1], aas, aah, valid_aa);
  $setuphold (posedge CLKR &&& BNOBIST, posedge AB[1], abs, abh, valid_ab);
  $setuphold (posedge CLKR &&& BNOBIST, negedge AB[1], abs, abh, valid_ab);
  $setuphold (posedge CLKW &&& ABIST, posedge AMA[2], amas, amah, valid_aa);
  $setuphold (posedge CLKW &&& ABIST, negedge AMA[2], amas, amah, valid_aa);
  $setuphold (posedge CLKR &&& BBIST, posedge AMB[2], ambs, ambh, valid_ab);
  $setuphold (posedge CLKR &&& BBIST, negedge AMB[2], ambs, ambh, valid_ab);
 
  $setuphold (posedge CLKW &&& ANOBIST, posedge AA[2], aas, aah, valid_aa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge AA[2], aas, aah, valid_aa);
  $setuphold (posedge CLKR &&& BNOBIST, posedge AB[2], abs, abh, valid_ab);
  $setuphold (posedge CLKR &&& BNOBIST, negedge AB[2], abs, abh, valid_ab);
  $setuphold (posedge CLKW &&& ABIST, posedge AMA[3], amas, amah, valid_aa);
  $setuphold (posedge CLKW &&& ABIST, negedge AMA[3], amas, amah, valid_aa);
  $setuphold (posedge CLKR &&& BBIST, posedge AMB[3], ambs, ambh, valid_ab);
  $setuphold (posedge CLKR &&& BBIST, negedge AMB[3], ambs, ambh, valid_ab);
 
  $setuphold (posedge CLKW &&& ANOBIST, posedge AA[3], aas, aah, valid_aa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge AA[3], aas, aah, valid_aa);
  $setuphold (posedge CLKR &&& BNOBIST, posedge AB[3], abs, abh, valid_ab);
  $setuphold (posedge CLKR &&& BNOBIST, negedge AB[3], abs, abh, valid_ab);
  $setuphold (posedge CLKW &&& ABIST, posedge AMA[4], amas, amah, valid_aa);
  $setuphold (posedge CLKW &&& ABIST, negedge AMA[4], amas, amah, valid_aa);
  $setuphold (posedge CLKR &&& BBIST, posedge AMB[4], ambs, ambh, valid_ab);
  $setuphold (posedge CLKR &&& BBIST, negedge AMB[4], ambs, ambh, valid_ab);
 
  $setuphold (posedge CLKW &&& ANOBIST, posedge AA[4], aas, aah, valid_aa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge AA[4], aas, aah, valid_aa);
  $setuphold (posedge CLKR &&& BNOBIST, posedge AB[4], abs, abh, valid_ab);
  $setuphold (posedge CLKR &&& BNOBIST, negedge AB[4], abs, abh, valid_ab);
  $setuphold (posedge CLKW &&& ABIST, posedge AMA[5], amas, amah, valid_aa);
  $setuphold (posedge CLKW &&& ABIST, negedge AMA[5], amas, amah, valid_aa);
  $setuphold (posedge CLKR &&& BBIST, posedge AMB[5], ambs, ambh, valid_ab);
  $setuphold (posedge CLKR &&& BBIST, negedge AMB[5], ambs, ambh, valid_ab);
 
  $setuphold (posedge CLKW &&& ANOBIST, posedge AA[5], aas, aah, valid_aa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge AA[5], aas, aah, valid_aa);
  $setuphold (posedge CLKR &&& BNOBIST, posedge AB[5], abs, abh, valid_ab);
  $setuphold (posedge CLKR &&& BNOBIST, negedge AB[5], abs, abh, valid_ab);
  $setuphold (posedge CLKW &&& ABIST, posedge AMA[6], amas, amah, valid_aa);
  $setuphold (posedge CLKW &&& ABIST, negedge AMA[6], amas, amah, valid_aa);
  $setuphold (posedge CLKR &&& BBIST, posedge AMB[6], ambs, ambh, valid_ab);
  $setuphold (posedge CLKR &&& BBIST, negedge AMB[6], ambs, ambh, valid_ab);
 
  $setuphold (posedge CLKW &&& ANOBIST, posedge AA[6], aas, aah, valid_aa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge AA[6], aas, aah, valid_aa);
  $setuphold (posedge CLKR &&& BNOBIST, posedge AB[6], abs, abh, valid_ab);
  $setuphold (posedge CLKR &&& BNOBIST, negedge AB[6], abs, abh, valid_ab);
  $setuphold (posedge CLKW &&& ABIST, posedge AMA[7], amas, amah, valid_aa);
  $setuphold (posedge CLKW &&& ABIST, negedge AMA[7], amas, amah, valid_aa);
  $setuphold (posedge CLKR &&& BBIST, posedge AMB[7], ambs, ambh, valid_ab);
  $setuphold (posedge CLKR &&& BBIST, negedge AMB[7], ambs, ambh, valid_ab);
 
  $setuphold (posedge CLKW &&& ANOBIST, posedge AA[7], aas, aah, valid_aa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge AA[7], aas, aah, valid_aa);
  $setuphold (posedge CLKR &&& BNOBIST, posedge AB[7], abs, abh, valid_ab);
  $setuphold (posedge CLKR &&& BNOBIST, negedge AB[7], abs, abh, valid_ab);

  $setuphold (posedge CLKW &&& ANOBIST, posedge D[0], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[0], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[0], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[0], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[0], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[0], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[0], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[0], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[1], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[1], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[1], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[1], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[1], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[1], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[1], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[1], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[2], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[2], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[2], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[2], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[2], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[2], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[2], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[2], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[3], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[3], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[3], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[3], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[3], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[3], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[3], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[3], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[4], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[4], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[4], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[4], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[4], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[4], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[4], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[4], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[5], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[5], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[5], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[5], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[5], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[5], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[5], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[5], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[6], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[6], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[6], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[6], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[6], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[6], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[6], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[6], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[7], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[7], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[7], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[7], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[7], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[7], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[7], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[7], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[8], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[8], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[8], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[8], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[8], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[8], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[8], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[8], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[9], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[9], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[9], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[9], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[9], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[9], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[9], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[9], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[10], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[10], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[10], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[10], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[10], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[10], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[10], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[10], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[11], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[11], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[11], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[11], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[11], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[11], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[11], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[11], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[12], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[12], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[12], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[12], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[12], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[12], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[12], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[12], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[13], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[13], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[13], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[13], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[13], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[13], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[13], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[13], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[14], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[14], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[14], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[14], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[14], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[14], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[14], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[14], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, posedge D[15], ds, dh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge D[15], ds, dh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge DM[15], dms, dmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge DM[15], dms, dmh, valid_bwa);

  $setuphold (posedge CLKW &&& ANOBIST, posedge BWEB[15], bws, bwh, valid_bwa);
  $setuphold (posedge CLKW &&& ANOBIST, negedge BWEB[15], bws, bwh, valid_bwa);

  $setuphold (posedge CLKW &&& ABIST, posedge BWEBM[15], bwms, bwmh, valid_bwa);
  $setuphold (posedge CLKW &&& ABIST, negedge BWEBM[15], bwms, bwmh, valid_bwa);

  $setuphold (posedge CLKW &&& NOBIST, posedge WEB, wes, weh, valid_wea);
  $setuphold (posedge CLKW &&& NOBIST, negedge WEB, wes, weh, valid_wea);
  $setuphold (posedge CLKR &&& NOBIST, posedge REB, res, reh, valid_reb);
  $setuphold (posedge CLKR &&& NOBIST, negedge REB, res, reh, valid_reb);
 
  $setuphold (posedge CLKW &&& BIST, posedge WEBM, wes, weh, valid_wea);
  $setuphold (posedge CLKW &&& BIST, negedge WEBM, wes, weh, valid_wea);
  $setuphold (posedge CLKR &&& BIST, posedge REBM, res, reh, valid_reb);
  $setuphold (posedge CLKR &&& BIST, negedge REBM, res, reh, valid_reb);
 
  $setuphold (posedge CLKW, posedge BIST, bists, bisth, valid_aa);
  $setuphold (posedge CLKW, negedge BIST, bists, bisth, valid_aa);
  $setuphold (posedge CLKR, posedge BIST, bists, bisth, valid_ab);
  $setuphold (posedge CLKR, negedge BIST, bists, bisth, valid_ab);
 
  $width (negedge CLKW, ckpl, 0, valid_ck);
  $width (posedge CLKW, ckph, 0, valid_ck);
  $width (negedge CLKR, ckpl, 0, valid_ck);
  $width (posedge CLKR, ckph, 0, valid_ck);
  $period (negedge CLKW, ckwp, valid_ck);
  $period (posedge CLKR, ckrp, valid_ck);

(posedge CLKR => (Q[0] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[1] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[2] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[3] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[4] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[5] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[6] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[7] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[8] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[9] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[10] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[11] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[12] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[13] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[14] +: 1'bx)) = (ckq,ckq,ckqh);
(posedge CLKR => (Q[15] +: 1'bx)) = (ckq,ckq,ckqh);

endspecify
`endif

initial
begin
  assign EN = 1;
  RDB = 1'b0;
end

always @(bCLKW)
   if (bCLKW === 1'bx)
   begin
      if( MES_ALL=="ON" && $realtime != 0) $display("CLKW Unknown >>");
      AAL <= {M{1'bx}};
      BWEBL <= {N{1'b0}};
   end

always @(bCLKR)
   if (bCLKR === 1'bx)
   begin
      if( MES_ALL=="ON" && $realtime != 0) $display("CLKR Unknown >>");
      ABL <= {M{1'bx}};
   end

always @(bBIST)
   if (bBIST === 1'bx)
   begin
      if( MES_ALL=="ON" && $realtime != 0)
         $display("BIST Unknown, Core Unknown at %t. >>", $realtime);
      AAL <= {M{1'bx}};
      BWEBL <= {N{1'b0}};
   end

always @(posedge bCLKW)
   begin                                // begin always @(posedge bCLKA)
      if (!bBIST)
      begin                             // begin if (!bBIST)
         WEBL = bWEB;
         AAL = bAA;
         DL = bD;
         if (bWEB !== 1'b1) 
         begin                         // begin if (bWEB !== 1'b1) 
            for (i = 0; i < N; i = i + 1) 
            begin                      // begin for...
               if (!bBWEB[i] && !bWEB) BWEBL[i] = 1'b0;
               if (((bBWEB[i] || bBWEB[i]===1'bx) && bWEB===1'bx) || (bWEB && bBWEB[i] ===1'bx))
               begin                   // if (((...
                  BWEBL[i] = 1'b0; 
                  DL[i] = 1'bx;
               end                     // end if (((...
            end                        // end for (
         end
      end

      if (bBIST)
      begin                             // begin if (!bBIST)
         WEBL = bWEBM;
         AAL = bAMA; 
         DL = bDM; 
         if (bWEBM !== 1'b1) 
         begin                         // begin if (bWEBM !== 1'b1)
            for (i = 0; i < N; i = i + 1) 
            begin                      // begin for...   
               if (!bBWEBM[i] && !bWEBM) BWEBL[i] = 1'b0;
               if (((bBWEBM[i] || bBWEBM[i]===1'bx) && bWEBM===1'bx) || (bWEBM && bBWEBM[i] ===1'bx))
               begin                   // if (((...
                  BWEBL[i] = 1'b0; 
                  DL[i] = 1'bx;   
               end                     // end if (((...  
            end                        // end for (   
         end    
      end

   end                                 // end always @(posedge bCLKW)


always @(posedge bCLKR)
   begin                                // begin always @(posedge bCLKR)
      if (!bBIST) REBL = bREB;
      if (!bBIST && !bREB) 
      begin
         ABL = bAB;
         RDB = #0 ~RDB;
      end

      if (!bBIST && bREB === 1'bx) ABL <= {M{1'bx}};

      if (bBIST) REBL = bREBM;
      if (bBIST && !bREBM)
      begin                             // begin if (!bBIST)
         ABL = bAMB;
         RDB = #0 ~RDB;
      end

      if (bBIST && bREBM === 1'bx) ABL <= {M{1'bx}};

   end                                 // end always @(posedge bCLKR)


always @(RDB or QL) 
   begin
     `ifdef UNIT_DELAY
          #(`SRAM_DELAY);
      `endif
      bQ = QL;
      `ifdef UNIT_DELAY
          if (AeqBL && !WEBL && !REBL) bQ = {N{1'bx}};
      `endif
   end

always @(negedge CLKW) BWEBL = {N{1'b1}};
 
`ifdef UNIT_DELAY
always @(posedge AeqBL) 
   if (!WEBL && !REBL) bQ = {N{1'bx}};
`else
always @(valid_aa) AAL = {M{1'bx}};

always @(valid_ab) ABL = {M{1'bx}};

always @(valid_contention) bQ = #0.01 {N{1'bx}};

always @(valid_ck)
   begin
   AAL = {M{1'bx}};
   BWEBL = {N{1'bx}};
   end
 
always @(valid_bwa) DL = {N{1'bx}};
 
always @(valid_wea)
   begin
      BWEBL = {N{1'b0}};
      DL = {N{1'bx}};
   end
 
always @(valid_reb)
   begin
      bQ = #0.01 {N{1'bx}};
   end
`endif

TS6N65LPA256X16M4M_Int_Array #(1,1,W,N,M,MES_ALL) MX (.D({DL}),.BW({BWEBL}),
         .AW({AAL}),.EN(EN),.RDB(RDB),.AR({ABL}),.Q({QL}));
 
endmodule

`disable_portfaults
`nosuppress_faults
`endcelldefine

/*
   The module ports are parameterizable vectors.
*/

module TS6N65LPA256X16M4M_Int_Array (D, BW, AW, EN, RDB, AR, Q);
parameter Nread = 2;   // Number of Read Ports
parameter Nwrite = 2;  // Number of Write Ports
parameter Nword = 2;   // Number of Words
parameter Ndata = 1;   // Number of Data Bits / Word
parameter Naddr = 1;   // Number of Address Bits / Word
parameter MES_ALL = "ON";
parameter dly = 0.001;
// Cannot define inputs/outputs as memories
input  [Ndata*Nwrite-1:0] D;  // Data Word(s)
input  [Ndata*Nwrite-1:0] BW; // Negative Bit Write Enable
input  [Naddr*Nwrite-1:0] AW; // Write Address(es)
input  EN;                    // Positive Write Enable
input  RDB;                   // Read Toggle
input  [Naddr*Nread-1:0] AR;  // Read Address(es)
output [Ndata*Nread-1:0] Q;   // Output Data Word(s)
reg    [Ndata*Nread-1:0] Q;
reg [Ndata-1:0] mem [Nword-1:0];
reg chgmem;            // Toggled when write to mem
reg [Nwrite-1:0] wwe;  // Positive Word Write Enable for each Port
reg we;                // Positive Write Enable for all Ports
integer waddr[Nwrite-1:0]; // Write Address for each Enabled Port
integer address;       // Current address
reg [Naddr-1:0] abuf;  // Address of current port
reg [Ndata-1:0] dbuf;  // Data for current port
reg [Ndata-1:0] bwbuf; // Bit Write enable for current port
reg dup;               // Is the address a duplicate?
integer log;           // Log file descriptor
integer ip, ip2, ib, iw, iwb; // Vector indices


initial
   begin
   $timeformat (-9, 2, " ns", 9);
   if (log[0] === 1'bx)
      log = 1;
   chgmem = 1'b0;
   end


always @(D or BW or AW or EN)
   begin: WRITE //{
   if (EN !== 1'b0)
      begin //{ Possible write
      we = 1'b0;
      // Mark any write enabled ports & get write addresses
      for (ip = 0 ; ip < Nwrite ; ip = ip + 1)
         begin //{
         ib = ip * Ndata;
         iw = ib + Ndata;
         while (ib < iw && BW[ib] === 1'b1)
            ib = ib + 1;
         if (ib == iw)
            wwe[ip] = 1'b0;
         else
            begin //{ ip write enabled
            iw = ip * Naddr;
            for (ib = 0 ; ib < Naddr ; ib = ib + 1)
               begin //{
               abuf[ib] = AW[iw+ib];
               if (abuf[ib] !== 1'b0 && abuf[ib] !== 1'b1)
                  ib = Naddr;
               end //}
            if (ib == Naddr)
               begin //{
               if (abuf < Nword)
                  begin //{ Valid address
                  waddr[ip] = abuf;
                  wwe[ip] = 1'b1;
                  if (we == 1'b0)
                     begin
                     chgmem = ~chgmem;
                     we = EN;
                     end
                  end //}
               else
                  begin //{ Out of range address
                  wwe[ip] = 1'b0;
                  if( MES_ALL=="ON" && $realtime != 0)
                       $fdisplay (log,
                             "\nWarning! Int_Array instance, %m:",
                             "\n\t Port %0d", ip,
                             " write address x'%0h'", abuf,
                             " out of range at time %t.", $realtime,
                             "\n\t Port %0d data not written to memory.", ip);
                  end //}
               end //}
            else
               begin //{ Unknown write address
               if( MES_ALL=="ON" && $realtime != 0)
                    $fdisplay (log,
                          "\nWarning! Int_Array instance, %m:",
                          "\n\t Port %0d", ip,
                          " write address unknown at time %t.", $realtime,
                          "\n\t Entire memory set to unknown.");
               for (ib = 0 ; ib < Ndata ; ib = ib + 1)
                  dbuf[ib] = 1'bx;
               for (iw = 0 ; iw < Nword ; iw = iw + 1)
                  mem[iw] = dbuf;
               chgmem = ~chgmem;
               disable WRITE;
               end //}
            end //} ip write enabled
         end //} for ip
      if (we === 1'b1)
         begin //{ active write enable
         for (ip = 0 ; ip < Nwrite ; ip = ip + 1)
            begin //{
            if (wwe[ip])
               begin //{ write enabled bits of write port ip
               address = waddr[ip];
               dbuf = mem[address];
               iw = ip * Ndata;
               for (ib = 0 ; ib < Ndata ; ib = ib + 1)
                  begin //{
                  iwb = iw + ib;
                  if (BW[iwb] === 1'b0)
                     dbuf[ib] = D[iwb];
                  else if (BW[iwb] !== 1'b1)
                     dbuf[ib] = 1'bx;
                  end //}
               // Check other ports for same address &
               // common write enable bits active
               dup = 0;
               for (ip2 = ip + 1 ; ip2 < Nwrite ; ip2 = ip2 + 1)
                  begin //{
                  if (wwe[ip2] && address == waddr[ip2])
                     begin //{
                     // initialize bwbuf if first dup
                     if (!dup)
                        begin
                        for (ib = 0 ; ib < Ndata ; ib = ib + 1)
                           bwbuf[ib] = BW[iw+ib];
                        dup = 1;
                        end
                     iw = ip2 * Ndata;
                     for (ib = 0 ; ib < Ndata ; ib = ib + 1)
                        begin //{
                        iwb = iw + ib;
                        // New: Always set X if BW X
                        if (BW[iwb] === 1'b0)
                           begin //{
                           if (bwbuf[ib] !== 1'b1)
                              begin
                              if (D[iwb] !== dbuf[ib])
                                 dbuf[ib] = 1'bx;
                              end
                           else
                              begin
                              dbuf[ib] = D[iwb];
                              bwbuf[ib] = 1'b0;
                              end
                           end //}
                        else if (BW[iwb] !== 1'b1)
                           begin
                           dbuf[ib] = 1'bx;
                           bwbuf[ib] = 1'bx;
                           end
                        end //} for each bit
                        wwe[ip2] = 1'b0;
                     end //} Port ip2 address matches port ip
                  end //} for each port beyond ip (ip2=ip+1)
               // Write dbuf to memory
               mem[address] = dbuf;
               end //} wwe[ip] - write port ip enabled
            end //} for each write port ip
         end //} active write enable
      else if (we !== 1'b0)
         begin //{ unknown write enable
         for (ip = 0 ; ip < Nwrite ; ip = ip + 1)
            begin //{
            if (wwe[ip])
               begin //{ write X to enabled bits of write port ip
               address = waddr[ip];
               dbuf = mem[address];
               iw = ip * Ndata;
               for (ib = 0 ; ib < Ndata ; ib = ib + 1)
                  begin //{ 
                 if (BW[iw+ib] !== 1'b1)
                     dbuf[ib] = 1'bx;
                  end //} 
               mem[address] = dbuf;
               if( MES_ALL=="ON" && $realtime != 0)
                    $fdisplay (log,
                          "\nWarning! Int_Array instance, %m:",
                          "\n\t Enable pin unknown at time %t.", $realtime,
                          "\n\t Enabled bits at port %0d", ip,
                          " write address x'%0h' set unknown.", address);
               end //} wwe[ip] - write port ip enabled
            end //} for each write port ip
         end //} unknown write enable
      end //} possible write (EN != 0)
   end //} always @(D or BW or AW or EN)


// Read memory
always @(RDB or AR)
   begin //{
   for (ip = 0 ; ip < Nread ; ip = ip + 1)
      begin //{
      iw = ip * Naddr;
      for (ib = 0 ; ib < Naddr ; ib = ib + 1)
         begin
         abuf[ib] = AR[iw+ib];
         if (abuf[ib] !== 0 && abuf[ib] !== 1)
            ib = Naddr;
         end
      iw = ip * Ndata;
      if (ib == Naddr && abuf < Nword)
         begin //{ Read valid address
         dbuf = mem[abuf];

         for (ib = 0 ; ib < Ndata ; ib = ib + 1)
            begin
            if (Q[iw+ib] == dbuf[ib])
                Q[iw+ib] <= #(dly) dbuf[ib];
//                Q[iw+ib] <= dbuf[ib];
            else
                begin
//                Q[iw+ib] <= #0.001 1'bx;
                Q[iw+ib] <= #(dly) dbuf[ib];
                Q[iw+ib] <= dbuf[ib];
                end // else
            end // for
         end //} valid address
      else
         begin //{ Invalid address
         if( MES_ALL=="ON" && $realtime != 0)
               $fwrite (log, "\nWarning! Int_Array instance, %m:",
                       "\n\t Port %0d read address", ip);
         if (ib > Naddr)
         if( MES_ALL=="ON" && $realtime != 0)
            $fwrite (log, " unknown");
         else
         if( MES_ALL=="ON" && $realtime != 0)
            $fwrite (log, " x'%0h' out of range", abuf);
         if( MES_ALL=="ON" && $realtime != 0)
            $fdisplay (log,
                    " at time %t.", $realtime,
                    "\n\t Port %0d outputs set to unknown.", ip);
         for (ib = 0 ; ib < Ndata ; ib = ib + 1)
            Q[iw+ib] <= #(dly) 1'bx;
//            Q[iw+ib] <= 1'bx;
         end //} invalid address
      end //} for each read port ip
   end //} always @(chgmem or AR)


// Task for loading contents of a memory
task load;   //{ USAGE: initial inst.load ("file_name");
   input [256*8:1] file;  // Max 256 character File Name
   begin
   $display ("\n%m: Reading file, %0s, into memory", file);
   $readmemb (file, mem, 0, Nword-1);
   end
endtask //}


// Task for displaying contents of a memory
task show;   //{ USAGE: inst.show (low, high);
   input [31:0] low, high;
   integer i;
   begin //{
   $display ("\n%m: Memory content dump");
   if (low < 0 || low > high || high >= Nword)
      $display ("Error! Invalid address range (%0d, %0d).", low, high,
                "\nUsage: %m (low, high);",
                "\n       where low >= 0 and high <= %0d.", Nword-1);
   else
      begin
      $display ("\n    Address\tValue");
      for (i = low ; i <= high ; i = i + 1)
         $display ("%d\t%b", i, mem[i]);
      end
   end //}
endtask //}

endmodule

// cdb6.1128
