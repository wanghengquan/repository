// Copyright (C) 2007 SiliconBlue Technology Corporation (jianguo@siliconbluetech.com)

//****************************************************************************** */
//*                                                                              */
//*STATEMENT OF USE                                                              */
//*                                                                              */
//*This information contains confidential and proprietary information of SBT.    */
//*No part of this information may be reproduced, transmitted, transcribed,      */
//*stored in a retrieval system, or translated into any human or computer        */
//*language, in any form or by any means, electronic, mechanical, magnetic,      */
//*optical, chemical, manual, or otherwise, without the prior written permission */
//*of SBT. This information was prepared for informational purpose and is for    */
//*use by SBT's customers only. SBT reserves the right to make changes in the    */
//*information at any time and without notice.                                   */
//*                                                                              */
//****************************************************************************** */
//-------------------------------------------------------------------------------
//
// Title       : nvcm_defines
// Design      : ICE-F SMC & NVCM-FSM
// Author      : Jianguo Wang
// Company     : SiliconBlue Technology Corporation
//
//-------------------------------------------------------------------------------
//
// File        : nvcm_defines.v
// Revision    : 0.3
// Date		   : Dec 16, 2007
// Date		   : March 25, 2008
// Date		   : April 28, 2008
// Date		   : June 20, 2008 modified for iCEF8
// Date		   : Jan. 09, 2009 modified for iCEF12P
//
//-------------------------------------------------------------------------------
//
// Description :  define parameters for NVCM FSM
// 
//-------------------------------------------------------------------------------

// Shared parameter declarations

//`define ICEF8
//`define ICEF12
//`define ICEF1
`define ICEF_P384


`define PAGE_DATA_BN 64
`define PAGE_BN 72
`define SPI_ADD_BN 24

//`define MAX_NV_RRITRIM_ROWADD 9'h01
// Jianguo modified on 4/21/2011
//`define MAX_RRITRIM_BYTES 9'h28
`define MAX_RRITRIM_BYTES 9'h3C
// Jianguo modified on 4/21/2011
//`define RECALL_NV_BYTES 6'h27
`define RECALL_NV_BYTES 6'h3B


`ifdef ICEF12
	`define MAX_COLADD 12'd703
	`define MAX_ROWADD 9'd291
`endif
`ifdef ICEF8
	`define MAX_COLADD 12'd655
	`define MAX_ROWADD 9'd207
`endif 
`ifdef ICEF1
	`define MAX_COLADD 12'd327
	`define MAX_ROWADD 9'd103
`endif 
`ifdef ICEF_P384
	`define MAX_COLADD 12'd327
//	`define MAX_ROWADD 9'd19
// Per Mitch's change from 9'd19 to 9'd23
	`define MAX_ROWADD 9'd23
`endif 


// Jianguo modified on 2/11/09
//`define MAX_COLADD 12'd704
//`define MAX_ROWADD 9'd300

`define MAX_ICEF2_COLADD 9'd213
`define MAX_ICEF2_ROWADD 9'd183

`define MAX_ICEF4_COLADD 9'd327
`define MAX_ICEF4_ROWADD 9'd207
	
// Jianguo modified on 9/9/2010
//`define MAX_ICEF8_COLADD 10'd655
//`define MAX_ICEF8_ROWADD 9'd207
`define MAX_ICEF8_COLADD 12'd655
`define MAX_ICEF8_ROWADD 9'd207

// Jianguo modified on 2/11/09
`define MAX_ICEF12_COLADD 12'd703
`define MAX_ICEF12_ROWADD 9'd291

`define MAX_ICEF1_COLADD 12'd327
`define MAX_ICEF1_ROWADD 9'd103

`define MAX_BLKADD_BN 4
// Jianguo modified on 1/7/2011
`define MAX_COLADD_BN 12 // ICE12P=704
`define MAX_ROWADD_BN 9	 // ICE12P=300

// SPI FSM Module parameter declarations
`define SPI_PGMEN       8'h06
`define SPI_PGMDIS      8'h04
`define SPI_WRTSR       8'h01
`define SPI_RDSR        8'h05
`define SPI_READ        8'h03
`define SPI_FASTREAD    8'h0B
`define SPI_DP 	        8'hB9
`define SPI_RES 	    8'hAB
`define SPI_PAGEPGM     8'h02
`define SPI_BYTEPGM     8'h80

`define SPI_RELEXTSPI   	8'h81

`define SPI_PAGEWRT_RF   	8'h82
`define SPI_BYTEWRT_RF   	8'h83
`define SPI_READ_RF		   	8'h84
`define SPI_RECALL			8'h85

`define SPI_TMPGM	 	    8'h86
`define SPI_TMREAD	     	8'h87
`define SPI_TMRST	     	8'h88
`define SPI_RDSR1	     	8'h89

`define   STATUS_BUSY_POS 0
`define   STATUS_SPI_PGMEN_POS 1
`define   STATUS_BP0_POS 2
`define   STATUS_BP1_POS 3
`define   STATUS_BP2_POS 4
`define   STATUS_NVCM_BOOT_POS 5
`define   STATUS_NV_REDROW_POS 6
`define   STATUS_NV_RRITRIM_POS 7
`define   STATUS_NV_SSIUI_POS 8
`define   STATUS_FSM_RRITRIM_RD_POS 9
`define   STATUS_ECC_ERROR_POS 11:10
`define   STATUS_NONBLANKBIT_POS 12
`define   STATUS_PGMVFYFAIL_POS 14:13

`define	TRIM_VBG_BN 4
`define	TRIM_IPP_BN 4
`define	TRIM_IPP_STEP_BN 2
`define	TRIM_PPULSE_NUM_BN 4
// modified by jianguo 042808
//`define	TRIM_PPULSE_WIDTH_BN 3
`define	TRIM_PPULSE_WIDTH_BN 4
`define	RRI_ITEMS 16

`define TRIM_REG0_ADD 6'h20
// Jianguo added on 4/22/2011
`define VID_ADD 6'h28

`define DEFAULT_TRIM_REG0 8'b0000_0000
`define DEFAULT_TRIM_REG1 8'b0000_0000
`define DEFAULT_TRIM_REG2 8'b0000_0000
`define DEFAULT_TRIM_REG3 8'b0000_0000
`define DEFAULT_TRIM_REG4 8'b0000_0000

`define DEFAULT_TM_REG0 8'b0000_0000
`define DEFAULT_TM_REG1 8'b0000_0000
`define DEFAULT_TM_REG2 8'b0000_0000
