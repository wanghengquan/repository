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
// Title       : smc_defines
// Design      : smc
// Author      : Jianguo Wang
// Company     : SiliconBlue Technology Corporation
//
//-------------------------------------------------------------------------------
//
// File        : smc_defines.v
// Revision    : 0.2
// Date		   : February 26, 2008
//
//-------------------------------------------------------------------------------
//
// Description :  define parameters for SMC(Sate Machine Controller)
// 
//-------------------------------------------------------------------------------
// 4K 2port RF parameter declarations
`define  RF4K_N  16
`define  RF4K_W  256
`define  RF4K_M  8

// jianguo 09/16/2010 begin
`define  RF16K_M  10
// jianguo 09/16/2010 end

// smc parameter declarations
`define  BADDR_BN  2	// bit number to represent bank address
`define  FLEN_BN  16 // bit number to represent frame length in word (2 bytes) 
// jianguo 09/16/2010 begin
//`define  FNUM_BN  9	// bit number to represent max frame number,
`define  FNUM_BN  11	// bit number to represent max frame number,
// jianguo 09/16/2010 end
							// MAX Logical Tile is 256/8(each LT is 8wlx64bl cram) =32 per each cram block
`define  ICE_LTNUM  20	//  Logic Tile # for ICE & ICE-F family 
`define  BM_FLEN  ((`ICE_LTNUM /4) * 16)   // BRAM frame length in bits


`define  CRC16_BN  16	// bit number to represent crc register
`define  STATUSREG_BN  32	// bit number to represent STATUS register 
`define  IDCODE_BN  32	// bit number to represent IDCODE register 
`define  USERCODE_BN  32	// bit number to represent USERCODE register
`define  CTRLOPT_BN  16	// bit number to represent control optional register
`define  OSC_FS_BN  2	// bit number to trim osc frequency 
`define  TM_REG_BN  16
`define  PREAMBLE_BYTES  32'h7e_aa_99_7e

// bstream_smc register address definition
`define  CMD_REG_ADDR  4'd0
`define  BADDR_REG_ADDR   4'd1  
`define  CRCCK_REG_ADDR   4'd2  
`define  IDCK_REG_ADDR   4'd3  
`define  SPIRDCMD_REG_ADDR   4'd4  
`define  OSCFSEL_REG_ADDR   4'd5  
`define  FRAMELEN_REG_ADDR   4'd6  
`define  FRAMENUM_REG_ADDR   4'd7  
`define  START_FRAMENUM_REG_ADDR   4'd8  
`define  CTRLOPT_REG_ADDR   4'd9  
`define  USERCODE_REG_ADDR   4'd10  
`define  TESTMODE_REG_ADDR   4'd11

`define	 CMD_REG_LEN  4'd1
// bstream_smc command code definition
`define  NOOP_CODE   8'd0  
`define  CRAM_WRT_CODE   8'd1  
`define  CRAM_RD_CODE   8'd2  
`define  BRAM_WRT_CODE   8'd3  
`define  BRAM_RD_CODE   8'd4  
`define  RST_CRC_CODE   8'd5  
`define  STARTUP_CODE   8'd6  
`define  SHUTDOWN_CODE   8'd7  
`define  RELD_SPI_CODE   8'd8  
`define  STATUS_RD_CODE   8'd9  
`define  DESYNCH_CODE   8'd10  
`define  RST_ERR_CODE   8'd11  
`define  CRCREG_RD_CODE   8'd12  
`define  USERCODE_RD_CODE   8'd13  
// add for NVCM by Jianguo 022608		
`define  ACCESS_NVCM_CODE   8'd14  

// bstream_smc status register bit position
`define  STAT_MD_JTAG	0
`define  STAT_MD_SPI		1
`define  STAT_IDCODE_ERR	2
`define  STAT_CRC_ERR	3
`define  STAT_CMDCODE_ERR	4
`define  STAT_CMDREG_ERR	5
`define  STAT_SPI_RXPREAMBLE_FAIL  6
`define  STAT_SPI_LDBSTREAM_FAIL  7
`define  STAT_COR_EN_OSCCLK	8
`define  STAT_OSCOFF_B	9
`define  STAT_OSC_FSEL	`OSC_FS_BN -1+10:10
`define  STAT_COR_EN_8BCONFIG	12
`define  STAT_COR_DIS_FLASHPD 13
`define  STAT_GINT_HZ	14
`define  STAT_GIO_HZ	15
`define  STAT_GWE	16
`define  STAT_CDONE_IN	17
`define  STAT_CDONE_OUT	18
`define  STAT_LD_BSTREAM 19
`define  STAT_FPGA_OPERATION 20
`define  STAT_BOOT	21
`define  STAT_WARMBOOT_SEL 23:22
`define  STAT_COLDBOOT_SEL 25:24
`define  STAT_SECURITY_RDDIS 26
`define  STAT_SECURITY_WRTDIS 27
`define  STAT_CRAM_MONITOR_CELL	31:28

// bstream_smc counter bit number
`define SRCNT_BN 6
`define CMDHEAD_CNT_BN 5

// Default SPI read command & Address
`define	DEFAULT_SPI_RDCMD 8'h0b
`define	DEFAULT_SPI_RDADDR 24'h00_00_00
`define	FLASH_SPICMD_PD 8'hb9
`define	FLASH_SPICMD_RES 8'hab

// Control optional register (ctrlopt) bit definition
`define COR_DIS_FLASHPD_POS 0
`define COR_EN_OSCCLK_POS 1
`define COR_EN_DAISYCHAIN_POS 2
`define COR_EN_RDCRC_POS 3
`define COR_EN_COLDBOOT_POS 4
`define COR_EN_WARMBOOT_POS 5
`define COR_SECURITY_RDDIS_POS 6
`define COR_SECURITY_WRTDIS_POS 7
`define COR_EN_8BCONFIG_POS 8
`define COR_NVCM_WBOOT_MASK_POS 12:9 // just place hold, will implement on ICE-F
// TestMode register bit definition
`define TM_CRAM_MONITOR_CELL_MASK_POS 3:0
`define TM_EN_CRAM_BLSR_TEST_POS 4
`define TM_EN_BRAM_SR_TEST_POS 5
`define TM_DIS_CRAM_CLK_GATING_POS 6
`define TM_DIS_BRAM_CLK_GATING_POS 7
// add for NVCM by Jianguo 022608		
`define TM_EN_REBOOT_FROM_NVCM_POS 8
// add for force IDCODE & CRC Check by Jianguo 042711		
`define TM_DIS_IDCRC_CHK_POS 9  
