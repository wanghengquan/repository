// *************************  -*- Mode: Verilog -*- *********************
// ============================================================================
//                          COPYRIGHT NOTICE
// Copyright (c) 2009             Lattice Semiconductor Corporation
// ALL RIGHTS RESERVED
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from Lattice Semiconductor Corporation. The entire
// notice above must be reproduced on all authorized copies and copies may
// only be made to the extent permitted by a licensing agreement from
// Lattice Semiconductor Corporation.
//
// Lattice Semiconductor Corporation       TEL : 1-800-Lattice (USA and Canada)
// 5555 NE Moore Court                           408-826-6000 (other locations)
// Hillsboro, OR 97124                    web  : http://www.latticesemi.com/
// U.S.A                                  email: techsupport@latticesemi.com
// ============================================================================
// Filename        : i2c_defines.v
// Description     : I2C IP defines, Address Mapping
// Author          : Wei Han
// Created On      : Fri Mar 22, 2013
// Last Modified By: $Author: weihan $
// Last Modified On: $Date: 2013-04-30 17:06:32-07 $
// Revision        : $Revision: 1.5 $
// Aliases         : $Aliases:  $
// 
// ****************************************************************************
// Revision History:
// $Log: logic_design#i2c_ip#design#rtl#i2c_defines.v,v $
// Revision 1.5  2013-04-30 17:06:32-07  weihan
// Add SBC Parameter
//
// Revision 1.4  2013-03-28 13:46:46-07  weihan
// Default Slave Address MSB -> 8'hF8
//
// Revision 1.3  2013-03-27 14:59:30-07  weihan
// Change BR Defalut to 7, based on 400KHz from 12MHz System Clock
//
// Revision 1.2  2013-03-27 13:57:54-07  weihan
// Change default Unit (75ns) count to 1, based on 12MHz clock
//
// Revision 1.1  2013-03-27 12:02:27-07  weihan
// Initial Check In
//
// Revision 1.1  2013-03-22 20:42:55-07  weihan
//

`ifndef SYS_DEFINES_V
 `define SYS_DEFINES_V

`define SBDW   8                    // System Bus Data Width
`define SBCW   3                    // Bit Counter Width for given SBDW
`define SBAW   8                    // System Bus Address width

`endif //!SYS_DEFINES_V

`ifndef I2C_DEFINES_V
 `define I2C_DEFINES_V

// I2C PORT Parameters
`define GENERAL_ADDR  7'b0000000    // Gerneral Call Address
`define HSMODE_ADDR   5'b00001      // HSMODE address
`define S10BIT_ADDR   5'b11110      // 10 bits addressing

`define GEN_UPDRST   8'b00000110
`define GEN_UPDADDR  8'b00000100
`define GEN_WKUPCMD  8'b11110011    // CMD to wakeup from standby/sleep (LSB=1)

`define I2CBRW 10                   // I2CBR Width

// I2C SCI Registers Address
`define ADDR_I2CCR1   4'b1000
`define ADDR_I2CCMDR  4'b1001
`define ADDR_I2CBRLSB 4'b1010
`define ADDR_I2CBRMSB 4'B1011
`define ADDR_I2CSR    4'b1100
`define ADDR_I2CTXDR  4'b1101
`define ADDR_I2CRXDR  4'b1110
`define ADDR_I2CGCDR  4'b1111
`define ADDR_I2CINTCR 4'b0111
`define ADDR_I2CINTSR 4'b0110
`define ADDR_I2CSADDR 4'b0011

// I2C SCI Registers Default Value
`define DEFAULT_I2CCR1   8'b00000000
`define DEFAULT_I2CINTCR 8'b00000000

`define DEFAULT_I2CBR    10'b0000000111   // 7 (6.5) based on 12MHz System Clock Frequency
`define DEFAULT_SADDRMSB  8'b11111000     // Default Slave Address MSB

`define DTRMW         4                   // SDA Unit Delay TRiM Width, to achieve 75ns unit delay.
`define F_SDA_DEL     12                  // MHz
`define T_SDA_DEL_075 75.0                // ns
`ifndef CONFORMAL_LEC
`define N_SDA_DEL_075 `T_SDA_DEL_075 * `F_SDA_DEL/1000 + 0.49
`else
// LEC doesn't evaluate the expression correctly,so we must do the math for it.
`define N_SDA_DEL_075 1                   // 0.9 Based on 12 MHz System Clock Frequency
`endif // conformal

`define INDEX_HGC     0
`define INDEX_TROE    1
`define INDEX_TRRDY   2
`define INDEX_ARBL    3

`define INDEX_INTFRC  6  
`define INDEX_INTCLR  7

`endif //!I2C_DEFINES_V
// *************************  -*- Mode: Verilog -*- *********************
// ============================================================================
//                          COPYRIGHT NOTICE
// Copyright (c) 2008             Lattice Semiconductor Corporation
// ALL RIGHTS RESERVED
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from Lattice Semiconductor Corporation. The entire
// notice above must be reproduced on all authorized copies and copies may
// only be made to the extent permitted by a licensing agreement from
// Lattice Semiconductor Corporation.
//
// Lattice Semiconductor Corporation       TEL : 1-800-Lattice (USA and Canada)
// 5555 NE Moore Court                           408-826-6000 (other locations)
// Hillsboro, OR 97124                    web  : http://www.latticesemi.com/
// U.S.A                                  email: techsupport@latticesemi.com
// ============================================================================
// Filename        : tech.v
// Description     : Tech Cell Mapping
// Author          : Wei Han
// Created On      : Wed Mar 26 18:04:22 2013
// Last Modified By: $Author: weihan $
// Last Modified On: $Date: 2013-04-16 13:47:21-07 $
// Revision        : $Revision: 1.4 $
// 
// ****************************************************************************
// Revision History:
// $Log: logic_design#spi_ip#design#rtl#tech.v,v $
// Revision 1.4  2013-04-16 13:47:21-07  weihan
// SYNP update for LEC
//
// Revision 1.3  2013-04-15 11:53:00-07  weihan
// TECH CELL Multiple Definition
//
// Revision 1.2  2013-04-10 19:33:42-07  weihan
// Synthesis friendly
//
// Revision 1.1  2013-04-09 19:48:35-07  weihan
// Initial Check In
//

`timescale 1 ns / 1 ps

// ****************************************************************************
// Synchronization Cell

`ifndef TECH_SYNC_STD_DEFINED

`define TECH_SYNC_STD_DEFINED

module SYNCP_STD
  (
    output      q,        // second flop's output
    input       d,        // data input to first flop
    input       ck,       // rising-edge clock
    input       cdn       // active-low asynchronous reset
   );

`ifdef SYNTHESIS
   wire         q0;
   
   SEH_FDPRBQ_1 u0
     (.Q        (q0),
      .D        (d),
      .CK       (ck),
      .RD       (cdn)
      );
   
   SEH_FDPRBQ_2 u
     (.Q        (q),
      .D        (q0),
      .CK       (ck),
      .RD       (cdn)
      );

   // synopsys dc_script_begin
   // set_dont_touch u true
   // synopsys dc_script_end

`else // !`ifdef SYNTHESIS
   
   reg          q1, q0;
   
   always @(posedge ck or negedge cdn)
     if (~cdn) q0 <= 1'b0;
     else      q0 <= d;

   always @(posedge ck or negedge cdn)
     if (~cdn) q1 <= 1'b0;
     else      q1 <= q0;

  assign q = q1;
   
`endif
   
endmodule // SYNCP_STD

`endif //  `ifndef TECH_SYNC_STD_DEFINED


// ****************************************************************************
// 4 INPUT MUX

`ifndef TECH_CKHS_MUX4X2_DEFINED

`define TECH_CKHS_MUX4X2_DEFINED

module CKHS_MUX4X2
  (
   output z,
   input  d3,
   input  d2,
   input  d1,
   input  d0,
   input  sd2,
   input  sd1
   );

`ifdef SYNTHESIS   
   SEH_MUX4_DG_2 u
     (.X	(z),
      .D3	(d3),
      .D2	(d2),
      .D1	(d1),
      .D0	(d0),
      .S1	(sd2),
      .S0	(sd1)
      );
   
   // synopsys dc_script_begin
   // set_dont_touch u true
   // synopsys dc_script_end

`else // !`ifdef SYNTHESIS

   reg    x;
   always @(/*AUTOSENSE*/d0 or d1 or d2 or d3 or sd1 or sd2)
     begin
        case ({sd2, sd1})
          2'b00   : x = d0;
          2'b01   : x = d1;
          2'b10   : x = d2;
          2'b11   : x = d3;
          default : x = d0;
        endcase // case ({sd2, sd1})
     end

   assign z = x;
   
`endif
   
endmodule // CKHS_MUX4X2

`endif //  `ifndef TECH_CKHS_MUX4X2_DEFINED

// ****************************************************************************
// 2 INPUT MUX

`ifndef TECH_CKHS_MUX2X2_DEFINED

`define TECH_CKHS_MUX2X2_DEFINED

module CKHS_MUX2X2
  (
   output z,
   input  d1,
   input  d0,
   input  sd
   );

`ifdef SYNTHESIS   
   SEH_MUX2_S_2 u
     (.X	(z),
      .D1	(d1),
      .D0	(d0),
      .S	(sd)
      );
   
   // synopsys dc_script_begin
   // set_dont_touch u true
   // synopsys dc_script_end

`else // !`ifdef SYNTHESIS

   assign z = sd ? d1 : d0;

`endif

endmodule // CKHS_MUX2X2

`endif //  `ifndef TECH_CKHS_MUX2X2_DEFINED

// ****************************************************************************
// X4 Buffer

`ifndef TECH_CKHS_BUFX4_DEFINED

`define TECH_CKHS_BUFX4_DEFINED

module CKHS_BUFX4
  (
   output z,
   input  a
   );
   
`ifdef SYNTHESIS 
 
   SEH_BUF_S_4 u
     (.X	(z),
      .A	(a)
      );
   
   // synopsys dc_script_begin
   // set_dont_touch u true
   // synopsys dc_script_end

`else // !`ifdef SYNTHESIS

   assign z = a;

`endif

endmodule // CKHS_BUFX4

`endif //  `ifndef TECH_CKHS_BUFX4_DEFINED

// ****************************************************************************
// X1 INVERTER

`ifndef TECH_CKHS_INVX1_DEFINED

`define TECH_CKHS_INVX1_DEFINED

module CKHS_INVX1
  (
    output	z,	// z = ~a
    input 	a
   );

`ifdef SYNTHESIS
   
   SEH_INV_S_1 u
     (.X	(z),
      .A	(a)
      );
   
   // synopsys dc_script_begin
   // set_dont_touch u true
   // synopsys dc_script_end

`else

   assign z = ~a;

`endif // !`ifdef SYNTHESIS
   
endmodule // CKHS_INVX1

`endif //  `ifndef TECH_CKHS_INVX1_DEFINED

//--------------------------------EOF-----------------------------------------
// *************************  -*- Mode: Verilog -*- *********************
// ============================================================================
//                          COPYRIGHT NOTICE
// Copyright (c) 2008             Lattice Semiconductor Corporation
// ALL RIGHTS RESERVED
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from Lattice Semiconductor Corporation. The entire
// notice above must be reproduced on all authorized copies and copies may
// only be made to the extent permitted by a licensing agreement from
// Lattice Semiconductor Corporation.
//
// Lattice Semiconductor Corporation       TEL : 1-800-Lattice (USA and Canada)
// 5555 NE Moore Court                           408-826-6000 (other locations)
// Hillsboro, OR 97124                    web  : http://www.latticesemi.com/
// U.S.A                                  email: techsupport@latticesemi.com
// ============================================================================
// Filename        : i2c_sci.v
// Description     : System Control Interface for I2C IP
// Author          : Wei Han
// Created On      : Fri. Mar. 22 18:04:22 2013
// Last Modified By: $Author: weihan $
// Last Modified On: $Date: 2013-04-30 17:57:38-07 $
// Revision        : $Revision: 1.5 $
//
// ****************************************************************************
// Revision History:
// $Log: logic_design#i2c_ip#design#rtl#i2c_sci.v,v $
// Revision 1.5  2013-04-30 17:57:38-07  weihan
// ADD SB_SCI_INT_REG_V for I2C and SPI co-exist.
//
// Revision 1.4  2013-04-18 10:09:04-07  weihan
// Remove unused reg dat declaration
//
// Revision 1.3  2013-04-08 19:00:40-07  weihan
// WT INTSR, instead of SR, to clear INTSR
//
// Revision 1.2  2013-03-27 22:02:37-07  weihan
// ...No comments entered during checkin...
//
// Revision 1.1  2013-03-27 12:03:25-07  weihan
// Initial Check In
//

module i2c_sci (/*AUTOARG*/
   // Outputs
   i2ccr1, i2ccmdr, i2ctxdr, i2cbr, i2csaddr, i2ccr1_wt, i2ccmdr_wt,
   i2cbr_wt, i2ctxdr_wt, i2csaddr_wt, i2crxdr_rd, i2cgcdr_rd,
   trim_sda_del, sb_dat_o, sb_ack_o, i2c_irq,
   // Inputs
   SB_ID, i2c_rst_async, sb_clk_i, sb_we_i, sb_stb_i, sb_adr_i,
   sb_dat_i, i2csr, i2crxdr, i2cgcdr, scan_test_mode
   );

   // INPUTS
   // From IP TOP Tie High/Tie Low
   input [`SBAW-5:0] SB_ID;
   
   // From full chip POR ...
   input i2c_rst_async;

   // From System Bus
   input sb_clk_i;
   input sb_we_i;
   input sb_stb_i;

   input [`SBAW-1:0] sb_adr_i;
   input [`SBDW-1:0] sb_dat_i;

   // From I2C_port logc
   input [`SBDW-1:0] i2csr, i2crxdr, i2cgcdr;

   // From SCAN TEST Control
   input             scan_test_mode;
   
   // OUTPUTS
   // To I2C Port Logic
   output [`SBDW-1:0]   i2ccr1, i2ccmdr, i2ctxdr;
   output [`I2CBRW-1:0] i2cbr;
   output [`SBDW-1:0]   i2csaddr;
   
   output               i2ccr1_wt, i2ccmdr_wt, i2cbr_wt, i2ctxdr_wt, i2csaddr_wt;
   output               i2crxdr_rd, i2cgcdr_rd;

   output [`DTRMW-1:0]  trim_sda_del;
   
   // To Sysem Bus
   output [`SBDW-1:0]   sb_dat_o;
   output               sb_ack_o;
   
   // To System Host
   output               i2c_irq;
   
   // REGS
   reg                  ack_reg;
   reg                  id_stb_dly, id_stb_pulse;
   
   reg [`SBDW-1:0]      i2ccr1, i2ccmdr, i2ctxdr;
   reg [`SBDW-1:0]      i2cbrlsb;
   reg [`SBDW-1:0]      i2cbrmsb;
   reg [`SBDW-1:0]      i2csaddr, i2cintcr;
   
   reg [`SBDW-1:0]      rdmux_dat;
   reg [`SBDW-1:0]      sb_dat_o;
   
   // WIRES
   wire                 sb_id_match, sb_ip_match;
   wire                 id_wstb;
   wire                 id_rstb_pulse, id_wstb_pulse;
   wire                 ip_rstb;
   
   wire                 i2ccr1_wt, i2ccmdr_wt, i2cbr_wt, i2ctxdr_wt;
   wire                 i2cbrlsb_wt, i2cbrmsb_wt;
   wire                 i2csaddr_wt;
   wire                 i2crxdr_rd, i2cgcdr_rd;
   wire                 i2cintsr_wt, i2cintsr_rd;
   
   wire                 irq_arbl, irq_trrdy, irq_troe, irq_hgc;
   
   // LOGIC

   // SCI Registers
   assign sb_id_match = (sb_adr_i[`SBAW-1:4] == SB_ID);
   assign sb_ip_match = sb_id_match & (sb_adr_i[3] | (sb_adr_i[3:0] == `ADDR_I2CINTCR) | 
                                                     (sb_adr_i[3:0] == `ADDR_I2CINTSR) |
                                                     (sb_adr_i[3:0] == `ADDR_I2CSADDR));

   assign id_stb      = sb_id_match & sb_stb_i;
   assign ip_stb      = sb_ip_match & sb_stb_i;
   
   assign ip_rstb     = ip_stb & ~sb_we_i;

   assign id_wstb     = id_stb &  sb_we_i;
   
   // SB STB Pulse
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async) id_stb_dly <= 1'b0;
     else               id_stb_dly <= id_stb;

   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async) id_stb_pulse <= 1'b0;
     else               id_stb_pulse <= id_stb & ~id_stb_dly;

   assign id_rstb_pulse = id_stb_pulse & ~sb_we_i;
   assign id_wstb_pulse = id_stb_pulse &  sb_we_i;

   // ACK OUTPUT
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async) ack_reg <= 1'b0;
     else               ack_reg <= ip_stb;
   
   assign sb_ack_o = sb_stb_i & ack_reg;
   
   // System Bus Addassable Registers
   // I2CCR1
   wire i2ccr1_match = (sb_adr_i[3:0] == `ADDR_I2CCR1);
   wire wena_i2ccr1  = id_wstb & i2ccr1_match;
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)    i2ccr1 <= `DEFAULT_I2CCR1;
     else if (wena_i2ccr1) i2ccr1 <= sb_dat_i;

   assign i2ccr1_wt = id_wstb_pulse & i2ccr1_match;

   // I2CCMDR
   wire i2ccmdr_match = (sb_adr_i[3:0] == `ADDR_I2CCMDR);
   wire wena_i2ccmdr  = id_wstb & i2ccmdr_match;
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)     i2ccmdr <= {`SBDW{1'b0}};
     else if (wena_i2ccmdr) i2ccmdr <= sb_dat_i;

   assign i2ccmdr_wt = id_wstb_pulse & i2ccmdr_match;

   // I2CTXDR
   wire i2ctxdr_match = (sb_adr_i[3:0] == `ADDR_I2CTXDR);
   wire wena_i2ctxdr  = id_wstb & i2ctxdr_match;
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)     i2ctxdr <= {`SBDW{1'b0}};
     else if (wena_i2ctxdr) i2ctxdr <= sb_dat_i;

   assign i2ctxdr_wt = id_wstb_pulse & i2ctxdr_match;

   // I2CBRLSB
   wire i2cbrlsb_match = (sb_adr_i[3:0] == `ADDR_I2CBRLSB);
   wire wena_i2cbrlsb  = id_wstb & i2cbrlsb_match;
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)      i2cbrlsb <= {`SBDW{1'b0}};
     else if (wena_i2cbrlsb) i2cbrlsb <= sb_dat_i;

   assign i2cbrlsb_wt = id_wstb_pulse & i2cbrlsb_match;

   // I2CBRMSB
   wire i2cbrmsb_match = (sb_adr_i[3:0] == `ADDR_I2CBRMSB);
   wire wena_i2cbrmsb  = id_wstb & i2cbrmsb_match;
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)      i2cbrmsb <= {`SBDW{1'b0}};
     else if (wena_i2cbrmsb) i2cbrmsb <= sb_dat_i;

   assign i2cbrmsb_wt = id_wstb_pulse & i2cbrmsb_match;

   // I2CBR
   assign i2cbr = {i2cbrmsb[`I2CBRW-`SBDW-1:0], i2cbrlsb};

   assign i2cbr_wt = i2cbrmsb_wt | i2cbrlsb_wt;
   // assign i2cbr_wt = i2cbrmsb_wt;

   assign trim_sda_del[3:0] = i2cbrmsb[`SBDW-1:`SBDW-4];
   
   // I2CSADDR
   wire i2csaddr_match = (sb_adr_i[3:0] == `ADDR_I2CSADDR);
   wire wena_i2csaddr  = id_wstb & i2csaddr_match;
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)      i2csaddr <= {`SBDW{1'b0}};
     else if (wena_i2csaddr) i2csaddr <= sb_dat_i;

   assign i2csaddr_wt = id_wstb_pulse & i2csaddr_match;
   
   // I2CINTCR
   wire i2cintcr_match = (sb_adr_i [3:0] == `ADDR_I2CINTCR);
   wire wena_i2cintcr  = id_wstb & i2cintcr_match;
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)      i2cintcr <= `DEFAULT_I2CINTCR;
     else if (wena_i2cintcr) i2cintcr <= sb_dat_i;

   // I2CRXDR RD PULSE
   assign i2crxdr_rd = id_rstb_pulse & (sb_adr_i[3:0] == `ADDR_I2CRXDR);

   // I2CTCDR RD PULSE
   assign i2cgcdr_rd = id_rstb_pulse & (sb_adr_i[3:0] == `ADDR_I2CGCDR);
   
   // sb_dat_o MUX
   always @(/*AUTOSENSE*/`ADDR_I2CBRLSB or `ADDR_I2CBRMSB
            or `ADDR_I2CCMDR or `ADDR_I2CCR1 or `ADDR_I2CGCDR
            or `ADDR_I2CINTCR or `ADDR_I2CINTSR or `ADDR_I2CRXDR
            or `ADDR_I2CSADDR or `ADDR_I2CSR or `ADDR_I2CTXDR or `SBDW
            or i2cbrlsb or i2cbrmsb or i2ccmdr or i2ccr1 or i2cgcdr
            or i2cintcr or i2crxdr or i2csaddr or i2csr or i2ctxdr
            or irq_arbl or irq_hgc or irq_troe or irq_trrdy
            or sb_adr_i)
     begin
      case (sb_adr_i[3:0])
        `ADDR_I2CCR1  : rdmux_dat = i2ccr1;
        `ADDR_I2CCMDR : rdmux_dat = i2ccmdr;
        `ADDR_I2CBRLSB: rdmux_dat = i2cbrlsb;
        `ADDR_I2CBRMSB: rdmux_dat = i2cbrmsb;
        `ADDR_I2CSR   : rdmux_dat = i2csr;
        `ADDR_I2CTXDR : rdmux_dat = i2ctxdr;
        `ADDR_I2CRXDR : rdmux_dat = i2crxdr;
        `ADDR_I2CGCDR : rdmux_dat = i2cgcdr;
        `ADDR_I2CINTCR: rdmux_dat = i2cintcr;
        `ADDR_I2CINTSR: rdmux_dat = {{4{1'b0}}, irq_arbl, irq_trrdy, irq_troe, irq_hgc};
        `ADDR_I2CSADDR: rdmux_dat = i2csaddr;
        default       : rdmux_dat = {`SBDW{1'b0}};
      endcase // case (adr_i[3:0])
   end // always @ (...

   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async) sb_dat_o <= 0;
     else if (ip_rstb)  sb_dat_o <= rdmux_dat;
     else               sb_dat_o <= 0;

   // ****************************************************************************************
   // Interrupt Lotic
   // ****************************************************************************************
   wire match_intsr = (sb_adr_i[3:0] == `ADDR_I2CINTSR);
   assign i2cintsr_wt = id_wstb_pulse & match_intsr;
   assign i2cintsr_rd = id_rstb_pulse & match_intsr;

   wire int_clr_all = i2cintcr[`INDEX_INTCLR] & i2cintsr_rd;
   
   wire int_force = i2cintcr[`INDEX_INTFRC];
   
   // IRQ ARBL
   wire int_arbl;
   wire int_set_arbl = i2csr[`INDEX_ARBL];
   wire int_clr_arbl = (i2cintsr_wt & sb_dat_i[`INDEX_ARBL]) | int_clr_all;
   sci_int_reg intr_arbl(
                         // Outputs
                         .status                (int_arbl),
                         // Inputs
                         .rst_async             (i2c_rst_async),
                         .sb_clk_i              (sb_clk_i),
                         .int_force             (int_force),
                         .int_set               (int_set_arbl),
                         .int_clr               (int_clr_arbl),
                         .scan_test_mode        (scan_test_mode));

   assign irq_arbl = i2cintcr[`INDEX_ARBL] & int_arbl;

   // IRQ TRRDY
   wire int_trrdy;
   wire int_set_trrdy = i2csr[`INDEX_TRRDY];
   wire int_clr_trrdy = (i2cintsr_wt & sb_dat_i[`INDEX_TRRDY]) | int_clr_all;
   sci_int_reg intr_trrdy(
                          // Outputs
                          .status                (int_trrdy),
                          // Inputs
                          .rst_async             (i2c_rst_async),
                          .sb_clk_i              (sb_clk_i),
                          .int_force             (int_force),
                          .int_set               (int_set_trrdy),
                          .int_clr               (int_clr_trrdy),
                          .scan_test_mode        (scan_test_mode));

   assign irq_trrdy = i2cintcr[`INDEX_TRRDY] & int_trrdy;

   // IRQ TROD
   wire int_troe;
   wire int_set_troe = i2csr[`INDEX_TROE];
   wire int_clr_troe = (i2cintsr_wt & sb_dat_i[`INDEX_TROE]) | int_clr_all;
   sci_int_reg intr_troe(
                         // Outputs
                         .status                (int_troe),
                         // Inputs
                         .rst_async             (i2c_rst_async),
                         .sb_clk_i              (sb_clk_i),
                         .int_force             (int_force),
                         .int_set               (int_set_troe),
                         .int_clr               (int_clr_troe),
                         .scan_test_mode        (scan_test_mode));
   
   assign irq_troe = i2cintcr[`INDEX_TROE] & int_troe;

   // IRQ HGC
   wire int_hgc;
   wire int_set_hgc = i2csr[`INDEX_HGC];
   wire int_clr_hgc = (i2cintsr_wt & sb_dat_i[`INDEX_HGC]) | int_clr_all;
   sci_int_reg intr_hgc(
                        // Outputs
                        .status                (int_hgc),
                        // Inputs
                        .rst_async             (i2c_rst_async),
                        .sb_clk_i              (sb_clk_i),
                        .int_force             (int_force),
                        .int_set               (int_set_hgc),
                        .int_clr               (int_clr_hgc),
                        .scan_test_mode        (scan_test_mode));
   
   assign irq_hgc = i2cintcr[`INDEX_HGC] & int_hgc;

   assign i2c_irq = irq_arbl | irq_trrdy | irq_troe | irq_hgc;
   
endmodule // i2c_sci


`ifndef SB_SCI_INT_REG_V

`define SB_SCI_INT_REG_V

module sci_int_reg(/*AUTOARG*/
   // Outputs
   status,
   // Inputs
   rst_async, sb_clk_i, int_force, int_set, int_clr, scan_test_mode
   );

   // INPUTS
   input rst_async;
   input sb_clk_i;
   input int_force;
   input int_set;
   input int_clr;
   input scan_test_mode;

   // OUTPUTS
   output status;

   // REGISTERS
   reg    status;

   // WIRES
   wire   int_clk;      // either the set signal or forceint
   wire   int_rsta;	// asynchronous reset or clear on write
   wire   int_sts;      // value to set (normally=1 scan mode = (set|forceint)

  assign int_clk  = scan_test_mode ? sb_clk_i : (int_set ^ int_force);
  assign int_sts  = scan_test_mode ?((int_set | int_force) & ~int_clr): 1;
  assign int_rsta = scan_test_mode ? rst_async : (int_clr | rst_async );

  ///////////////////////////////////////////////
  // D flip-flop captures interruptable events //
  always @(posedge int_clk or posedge int_rsta)
    if (int_rsta) status <= 1'b0;
    else          status <= int_sts;

endmodule //sci_int_reg

`endif //!SB_SCI_INT_REG_V

//--------------------------------EOF-----------------------------------------
// *************************  -*- Mode: Verilog -*- *********************
// ============================================================================
//                          COPYRIGHT NOTICE
// Copyright (c) 2008             Lattice Semiconductor Corporation
// ALL RIGHTS RESERVED
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from Lattice Semiconductor Corporation. The entire
// notice above must be reproduced on all authorized copies and copies may
// only be made to the extent permitted by a licensing agreement from
// Lattice Semiconductor Corporation.
//
// Lattice Semiconductor Corporation       TEL : 1-800-Lattice (USA and Canada)
// 5555 NE Moore Court                           408-826-6000 (other locations)
// Hillsboro, OR 97124                    web  : http://www.latticesemi.com/
// U.S.A                                  email: techsupport@latticesemi.com
// ============================================================================
// Filename        : i2c_port.v
// Description     : I2C port
// Author          : Wei Han
// Created On      : Wed Dec  3 18:04:22 2008
// Last Modified By: $Author: weihan $
// Last Modified On: $Date: 2013-05-02 18:06:54-07 $
// Revision        : $Revision: 1.6 $
//
// ****************************************************************************
// Revision History:
// $Log: logic_design#i2c_ip#design#rtl#i2c_port.v,v $
// Revision 1.6  2013-05-02 18:06:54-07  weihan
// Fix NEC bug on tx side.
//
// Revision 1.5  2013-04-23 15:34:03-07  weihan
// Fix issue on clock stretching lock up
//
// Revision 1.4  2013-04-09 19:48:24-07  weihan
// Synthesis friendly
//
// Revision 1.3  2013-03-28 13:46:50-07  weihan
// Default Slave Address MSB -> 8'hF8
//
// Revision 1.2  2013-03-27 16:29:14-07  weihan
// Modify the 300ns delay logic
//
// Revision 1.1  2013-03-27 12:03:21-07  weihan
// Initial Check In
//

`timescale 1ns/1ps

module i2c_port (/*AUTOARG*/
   // Outputs
   sda_out, sda_oe, scl_out, scl_oe, i2crxdr, i2cgcdr, i2csr,
   i2c_hsmode, i2c_wkup,
   // Inputs
   ADDR_LSB_USR, i2c_rst_async, sda_in, scl_in, del_clk, sb_clk_i,
   i2ccr1, i2ccmdr, i2ctxdr, i2cbr, i2csaddr, i2ccr1_wt, i2ccmdr_wt,
   i2cbr_wt, i2ctxdr_wt, i2csaddr_wt, i2crxdr_rd, i2cgcdr_rd,
   trim_sda_del, scan_test_mode
   );

   // INPUTS
   // From Top Level Tie High/Tie Low
   input [1:0] ADDR_LSB_USR;

   // From full chip POR ...
   input i2c_rst_async;

   // From I2C Bus
   input sda_in;
   input scl_in;

   // From System Bus
   input del_clk;
   
   input sb_clk_i;
   
   // From SCI
   input [`SBDW-1:0]   i2ccr1, i2ccmdr, i2ctxdr;
   input [`I2CBRW-1:0] i2cbr;
   input [`SBDW-1:0]   i2csaddr;
   
   input        i2ccr1_wt, i2ccmdr_wt, i2cbr_wt, i2ctxdr_wt, i2csaddr_wt;
   input        i2crxdr_rd, i2cgcdr_rd;

   // From Trim Reg
   input [3:0]  trim_sda_del;

   // SCAN TEST SUPPORT
   input 	scan_test_mode;    // SCAN TEST SUPPORT
   
   // OUTPUTS
   // Port
   output       sda_out, sda_oe;
   output       scl_out, scl_oe;
   // To SCI
   output [7:0] i2crxdr;
   output [7:0] i2cgcdr;
   output [7:0] i2csr;

   // IO if needed
   output       i2c_hsmode;    // Potentially send out to turn on optional pull up current source
   
   // Power Manager
   output       i2c_wkup;      // Signal to wakeup from standy/sleep mode, Rising edge detect at Power Manager Block

   //*****************************************
   // Define states of the state machine
   //*****************************************
   parameter    TR_IDLE = 3'b000;
   parameter    TR_ADDR = 3'b001;
   parameter    TR_ACKA = 3'b011;
   parameter    TR_INFO = 3'b010;
   parameter    TR_ACKB = 3'b110;
   parameter    TR_RDAT = 3'b111;
   parameter    TR_ACKD = 3'b101;

   parameter    MC_IDLE = 4'b0000;
   parameter    MC_STAP = 4'b0010;
   parameter    MC_STAA = 4'b1000;
   parameter    MC_STAB = 4'b1001;
   parameter    MC_STAC = 4'b1011;
   parameter    MC_STAD = 4'b1010;
   parameter    MC_TRCA = 4'b1110;
   parameter    MC_TRCB = 4'b1111;
   parameter    MC_TRCC = 4'b1101;
   parameter    MC_TRCD = 4'b1100;
   parameter    MC_STRP = 4'b0011;
   parameter    MC_STOP = 4'b0001;
   parameter    MC_STOA = 4'b0100;
   parameter    MC_STOB = 4'b0110;
   parameter    MC_STOC = 4'b0111;
   parameter    MC_STOD = 4'b0101;

   // WIRES
   wire scl_clk = scl_in;
   wire trst_addr, trst_acka, trst_info, trst_ackb, trst_ackd;

   wire addr_gen, addr_hsmode, addr_10bit, addr_match2, addr_info;
   wire addr_musr7, addr_musr10;
   wire addr_mcfg7, addr_mcfg10;
   wire addr_match7, addr_match10;
   wire addr_ok, addr_ok_usr7, addr_ok_usr10, addr_ok_usr;

   wire info_updrst, info_updaddr, info_wkup, info_haddr;

   wire i2c_trn, i2c_rcv;
   wire i2c_trn_sync_mux;    // AEFB 00

   wire cap_txdr_act_nst, cap_txdr_act_syn, cap_txdr_act, cap_txdr_fin;
   wire rcv_rst, trcv_rst, trcv_all, trcv_shift, trcv_done;

   wire acka, ackb, ackd;
   wire i2c_troe, i2c_trrdy;

   wire rcv_addr_upd, rcv_info_upd, rcv_data_upd;
   wire upd_gcsr, upd_gcdr, upd_rxdr;

   wire tr_sda_ack, tr_sda_en, tr_sda_out;
   wire trst_ack_all;
   wire start_arbl;
   wire cmd_exec_en, cmd_exec_run, cmd_exec_fin;
   wire cmd_start, cmd_stop, cmd_rd, cmd_wt, cmd_rdwt;
   wire exec_start, exec_stop, exec_rd, exec_wt;
   wire rdwt_eval;
   
   wire [7:0] i2c_trn_dat;

   wire       sda_out_int;
   wire       sda_out_sense;

   wire       clk_str_cyc;

   wire       trst_rw_ok;
   wire       clk_en, clk_max;
   
   wire       trcv_start_pulse;
   wire       i2c_sb_rst;
   wire       exec_stsp;
   wire       mc_next_busy;
   wire       trst_busy;
   
   wire       trcv_cnt6_pulse, trcv_cnt6_sense;
   wire       ckstr_cnt_en;

   // REGISTERS
   reg       trcv_start, trcv_stop, trcv_arbl;
   reg [2:0] trcv_start_sync;
   reg [2:0] tr_state, tr_next;
   reg [7:0] trn_reg, rcv_reg;
   reg [2:0] trcv_cnt;
   reg       trn_rw, rcv_rw, rcv_arc, trn_ack;
   reg [6:0] rcv_addr;
   reg [7:0] rcv_info;
   reg [7:0] rcv_data;

   reg i2c_hsmode;

   reg i2c_hgc, i2c_arbl, i2c_trdy, i2c_toe, i2c_rrdy, i2c_roe;

   reg trst_ack_all_nd, trst_ack_all_pd;
   reg trcv_start_rst_d;
   reg exec_start_d;

   reg sda_out_sense_r;

   reg i2c_rcv_ok;
   reg tr_scl_out;

   reg mc_trn_pre, mc_trn_en;
   reg mc_sda_pre, mc_sda_out;
   reg mc_scl_pre, mc_scl_out;
   reg del_zero_states;
   
   reg [2:0] del_cnt_set_sense;

   reg trst_idle;
   reg trst_tip;
   reg trst_data;
   reg trcv_cnt6;

   reg mcst_master;
   reg cmd_exec_active;
   reg cmd_exec_wt;
   reg [1:0] exec_stsp_det;

   reg        trst_arc_d_sync, trst_arc_d_sync0;
   reg        trst_rw_ok_sync, trst_rw_ok_sync0;
   reg        i2c_rarc_sync, i2c_rarc_sync0;
   reg        i2c_srw_sync, i2c_srw_sync0;
   reg        i2c_arbl_sync, i2c_arbl_sync0;
   reg        i2c_tip_sync, i2c_tip_sync0;
   reg        i2c_busy_sync, i2c_busy_sync0;
   reg        i2c_scl_sense, i2c_scl_sense0;
   reg        mst_scl_sense, mst_scl_sense0;
   reg 	      i2c_trn_sync, i2c_trn_sync0;
   reg 	      i2c_rcv_sync, i2c_rcv_sync0;
   reg 	      addr_ok_usr_sync, addr_ok_usr_sync0;
   reg        addr_ok_sync, addr_ok_sync0;           // AEFB 00
   
   reg [2:0]  trcv_cnt6_sync;
   reg [1:0]  upd_rxdr_sync, upd_gcdr_sync, upd_gcsr_sync;
   reg [1:0]  cap_txdr_sync;
   
   reg        mcmd_stcmd, mcmd_start, mcmd_stop, cmd_exec_en_d;

   reg [15:0] clk_cnt;
   reg [3:0]  mc_state, mc_next;

   reg [7:0] i2crxdr;
   reg [7:0]  i2cgcdr;

   reg 	      ckstr_flag;
   
   //*****************************************
   // SCL SIDE
   //*****************************************

   // *****************************************
   // I2C Control Register Definition
   // *****************************************
   wire         i2c_en      = i2ccr1[7];
   wire         i2c_gcen    = i2c_en & i2ccr1[6];
   wire         i2c_wkupen  = i2c_en & i2ccr1[5];
   wire [1:0]   sda_del_sel = i2ccr1[3:2];

   wire         i2c_sta     = i2ccmdr[7];
   wire         i2c_sto     = i2ccmdr[6];
   wire         i2c_rd      = i2ccmdr[5] | i2ccmdr[1];
   wire         i2c_wt      = i2ccmdr[4];
   wire         i2c_nack    = i2ccmdr[3];
   wire         i2c_cksdis  = i2ccmdr[2];
   wire 	i2c_rbufdis = i2ccmdr[1];
   // wire      i2c_iack    = i2ccmdr[0];

   wire         i2c_rwbit   = i2ctxdr[0];

   // *****************************************
   // Generate start and stop Flag
   // *****************************************
   assign i2c_sb_rst = (i2ccr1_wt | i2cbr_wt | i2csaddr_wt);
   
   wire trcv_async_rst = ~scan_test_mode & (trcv_stop | i2c_rst_async | (i2ccr1_wt & ~i2c_en));
   // wire trcv_async_rst = por | (~scan_test_mode & trcv_stop);

   // Detect I2C Cycle Start
   // wire trcv_start_rst0 = i2c_rst_async | trcv_stop;
   always @(posedge scl_clk or posedge trcv_async_rst)
     if (trcv_async_rst) trcv_start_rst_d <= 1'b0;
     else                trcv_start_rst_d <= trcv_start;

   wire trcv_start_rst = i2c_rst_async | trcv_start_rst_d;
   always @(negedge sda_in or posedge trcv_start_rst)
     if (trcv_start_rst) trcv_start <= 1'b0;
     else                trcv_start <= trcv_start | scl_in; 

   // Detect I2C Cycle Stop
   wire trcv_stop_rst = (i2c_rst_async | trcv_start);
   always @(posedge sda_in or posedge trcv_stop_rst)
     if (trcv_stop_rst) trcv_stop <= 1'b0;
     else               trcv_stop <= scl_in;

   // Detect I2C Arbitration Lost
   wire trcv_arbl_rst = (trst_idle | i2c_rst_async);
   wire trcv_arbl_set = tr_sda_en & ~sda_in & sda_out;
   always @(posedge scl_clk or posedge trcv_arbl_rst)
     if (trcv_arbl_rst)      trcv_arbl <= 1'b0;
     else if (trcv_arbl_set) trcv_arbl <= 1'b1;

   // I2C HS_MODE flag
   wire hsmode_det = trst_acka & addr_hsmode;
   always @(negedge scl_clk or posedge i2c_rst_async)
     if (i2c_rst_async)   i2c_hsmode <= 1'b0;
     else if (trcv_stop)  i2c_hsmode <= 1'b0;
     else if (hsmode_det) i2c_hsmode <= 1'b1;

   always @(negedge scl_clk or posedge i2c_rst_async)
     if (i2c_rst_async) trst_ack_all_nd <= 1'b0;
     else               trst_ack_all_nd <= trst_ack_all;

   always @(posedge scl_clk or posedge i2c_rst_async)
     if (i2c_rst_async) trst_ack_all_pd <= 1'b0;
     else               trst_ack_all_pd <= trst_ack_all_nd;

   assign clk_str_cyc = trst_ack_all_nd & ~trst_ack_all_pd;
   
   // *****************************************
   // FSM check the addr byte and track rw opp
   // *****************************************
   // assign trst_idle = (tr_state == TR_IDLE);
   always @(negedge scl_clk or posedge trcv_async_rst)
     if (trcv_async_rst)  trst_idle <= 1'b1;
     else if (trcv_stop)  trst_idle <= 1'b1;
     else if (trcv_start) trst_idle <= 1'b0;
     else                 trst_idle <= (tr_next ==  TR_IDLE);
   
   assign trst_addr = (tr_state == TR_ADDR);
   assign trst_acka = (tr_state == TR_ACKA);
   assign trst_info = (tr_state == TR_INFO);
   assign trst_ackb = (tr_state == TR_ACKB);
   assign trst_ackd = (tr_state == TR_ACKD);

   assign trst_ack_all = (trst_acka | trst_ackb | trst_ackd);

   // assign trst_tip   = trcv_all;
   // always @(negedge scl_clk or posedge trcv_async_rst)
   //   if (trcv_async_rst) trst_tip <= 1'b0;
   //   else                trst_tip <= ~trcv_stop & (trcv_start || tr_next ==  TR_RDAT || tr_next ==  TR_INFO || tr_next ==  TR_ADDR);
   always @(posedge scl_clk or posedge trcv_async_rst)         // PSM WH : FB-09
     if (trcv_async_rst) trst_tip <= 1'b0;                     // PSM WH : FB-09
     else                trst_tip <= ~trst_ack_all;            // PSM WH : FB-09
   
   // assign trst_data = (tr_state == TR_RDAT);
   always @(negedge scl_clk or posedge trcv_async_rst)
     if (trcv_async_rst)              trst_data <= 1'b0;
     else if (trcv_stop | trcv_start) trst_data <= 1'b0;
     else                             trst_data <= (tr_next ==  TR_RDAT);
   
   assign trst_busy = ~trst_idle;
   
   // Conbinational Next State Logic
   always @(/*AUTOSENSE*/addr_info or tr_state or trcv_done)
     begin
        case (tr_state)
          TR_IDLE :                      tr_next = TR_IDLE;
          TR_ADDR : begin
             if (trcv_done)              tr_next = TR_ACKA;
             else                        tr_next = TR_ADDR;
          end
          TR_ACKA : begin
             if (addr_info)              tr_next = TR_INFO;
             else                        tr_next = TR_RDAT;
          end
          TR_INFO : begin
             if (trcv_done)              tr_next = TR_ACKB;
             else                        tr_next = TR_INFO;
          end
          TR_ACKB :                      tr_next = TR_RDAT;
          TR_RDAT : begin
             if (trcv_done)              tr_next = TR_ACKD;
             else                        tr_next = TR_RDAT;
          end
          TR_ACKD :                      tr_next = TR_RDAT;
          default :                      tr_next = TR_IDLE;
        endcase // case(tr_state)
     end // always @ (...

   // Sequential block
   always @(negedge scl_clk or posedge trcv_async_rst)
     if (trcv_async_rst)  tr_state <= TR_IDLE;
     else if (trcv_stop)  tr_state <= TR_IDLE;
     else if (trcv_start) tr_state <= TR_ADDR;
     else                 tr_state <= tr_next;

   // *****************************************
   // Receiver
   // *****************************************
   assign rcv_rst    = trst_idle;
   assign trcv_rst   = trst_idle | trst_ack_all | (trcv_start & ~trcv_start_rst_d);
   assign trcv_all   = trst_addr | trst_info | trst_data;
   assign trcv_shift = trcv_all & ~clk_str_cyc;
   assign trcv_done  = (trcv_cnt == 3'b111);

   // assign trcv_cnt6  = (trcv_cnt == 3'b110);
   always @(posedge scl_clk or posedge trcv_async_rst)
     if (trcv_async_rst)  trcv_cnt6 <= 1'b0;
     else if (trcv_rst)   trcv_cnt6 <= 1'b0;
     else if (trcv_shift) trcv_cnt6 <= (trcv_cnt == 3'b101);
	    
   wire   trn_reg_rst_0 = ~trcv_async_rst & (cap_txdr_act & ~i2c_trn_dat[0]);
   wire   trn_reg_set_0 = trcv_async_rst  | (cap_txdr_act &  i2c_trn_dat[0]);
   always @(negedge scl_clk or posedge trn_reg_rst_0 or posedge trn_reg_set_0)
     if (trn_reg_rst_0)      trn_reg[0] <= 1'b0;
     else if (trn_reg_set_0) trn_reg[0] <= 1'b1;
     else if (trcv_shift)    trn_reg[0] <= 1'b1;

   wire   trn_reg_rst_1 = ~trcv_async_rst & (cap_txdr_act & ~i2c_trn_dat[1]);
   wire   trn_reg_set_1 = trcv_async_rst  | (cap_txdr_act &  i2c_trn_dat[1]);
   always @(negedge scl_clk or posedge trn_reg_rst_1 or posedge trn_reg_set_1)
     if (trn_reg_rst_1)      trn_reg[1] <= 1'b0;
     else if (trn_reg_set_1) trn_reg[1] <= 1'b1;
     else if (trcv_shift)    trn_reg[1] <= trn_reg[0];

   wire   trn_reg_rst_2 = ~trcv_async_rst & (cap_txdr_act & ~i2c_trn_dat[2]);
   wire   trn_reg_set_2 = trcv_async_rst  | (cap_txdr_act &  i2c_trn_dat[2]);
   always @(negedge scl_clk or posedge trn_reg_rst_2 or posedge trn_reg_set_2)
     if (trn_reg_rst_2)      trn_reg[2] <= 1'b0;
     else if (trn_reg_set_2) trn_reg[2] <= 1'b1;
     else if (trcv_shift)    trn_reg[2] <= trn_reg[1];

   wire   trn_reg_rst_3 = ~trcv_async_rst & (cap_txdr_act & ~i2c_trn_dat[3]);
   wire   trn_reg_set_3 = trcv_async_rst  | (cap_txdr_act &  i2c_trn_dat[3]);
   always @(negedge scl_clk or posedge trn_reg_rst_3 or posedge trn_reg_set_3)
     if (trn_reg_rst_3)      trn_reg[3] <= 1'b0;
     else if (trn_reg_set_3) trn_reg[3] <= 1'b1;
     else if (trcv_shift)    trn_reg[3] <= trn_reg[2];

   wire   trn_reg_rst_4 = ~trcv_async_rst & (cap_txdr_act & ~i2c_trn_dat[4]);
   wire   trn_reg_set_4 = trcv_async_rst  | (cap_txdr_act &  i2c_trn_dat[4]);
   always @(negedge scl_clk or posedge trn_reg_rst_4 or posedge trn_reg_set_4)
     if (trn_reg_rst_4)      trn_reg[4] <= 1'b0;
     else if (trn_reg_set_4) trn_reg[4] <= 1'b1;
     else if (trcv_shift)    trn_reg[4] <= trn_reg[3];

   wire   trn_reg_rst_5 = ~trcv_async_rst & (cap_txdr_act & ~i2c_trn_dat[5]);
   wire   trn_reg_set_5 = trcv_async_rst  | (cap_txdr_act &  i2c_trn_dat[5]);
   always @(negedge scl_clk or posedge trn_reg_rst_5 or posedge trn_reg_set_5)
     if (trn_reg_rst_5)      trn_reg[5] <= 1'b0;
     else if (trn_reg_set_5) trn_reg[5] <= 1'b1;
     else if (trcv_shift)    trn_reg[5] <= trn_reg[4];
   
   wire   trn_reg_rst_6 = ~trcv_async_rst & (cap_txdr_act & ~i2c_trn_dat[6]);
   wire   trn_reg_set_6 = trcv_async_rst  | (cap_txdr_act &  i2c_trn_dat[6]);
   always @(negedge scl_clk or posedge trn_reg_rst_6 or posedge trn_reg_set_6)
     if (trn_reg_rst_6)      trn_reg[6] <= 1'b0;
     else if (trn_reg_set_6) trn_reg[6] <= 1'b1;
     else if (trcv_shift)    trn_reg[6] <= trn_reg[5];

   wire   trn_reg_rst_7 = ~trcv_async_rst & (cap_txdr_act & ~i2c_trn_dat[7]);
   wire   trn_reg_set_7 = trcv_async_rst  | (cap_txdr_act &  i2c_trn_dat[7]);
   always @(negedge scl_clk or posedge trn_reg_rst_7 or posedge trn_reg_set_7)
     if (trn_reg_rst_7)      trn_reg[7] <= 1'b0;
     else if (trn_reg_set_7) trn_reg[7] <= 1'b1;
     else if (trcv_shift)    trn_reg[7] <= trn_reg[6];
   
   
   always @(posedge scl_clk or posedge trcv_async_rst)
     if (trcv_async_rst) rcv_reg <= {8{1'b1}};
     else if (rcv_rst)   rcv_reg <= {8{1'b1}};
     else if (trcv_all)  rcv_reg <= {rcv_reg[6:0], sda_in};

   always @(posedge scl_clk or posedge trcv_async_rst)
     if (trcv_async_rst)  trcv_cnt <= 3'b000;
     else if (trcv_rst)   trcv_cnt <= 3'b000;
     else if (trcv_shift) trcv_cnt <= trcv_cnt + 1;

   assign rcv_addr_upd = trst_addr & trcv_done;
   always @(negedge scl_clk or posedge trcv_async_rst)
     if (trcv_async_rst)    rcv_addr <= 7'b1111111;
     else if (trcv_start)   rcv_addr <= 7'b1111111;
     else if (rcv_addr_upd) rcv_addr <= rcv_reg[7:1];

   always @(negedge scl_clk or posedge trcv_async_rst)
     if (trcv_async_rst)    rcv_rw <= 1'b0;
     else if (trcv_start)   rcv_rw <= 1'b0;
     else if (rcv_addr_upd) rcv_rw <= rcv_reg[0];

   wire   rcv_info_rst = trcv_stop | (rcv_addr_upd & ~rcv_reg[0]);
   assign rcv_info_upd = trst_info & trcv_done;
   always @(negedge scl_clk or posedge trcv_async_rst)
     if (trcv_async_rst)    rcv_info <= 8'b11111111;
     else if (rcv_info_rst) rcv_info <= 8'b11111111;
     else if (rcv_info_upd) rcv_info <= rcv_reg;

   assign rcv_data_upd = trst_data & trcv_done;
   always @(negedge scl_clk or posedge i2c_rst_async)                         // Do not reset for STOP, Give time to SB host to take data
     if (i2c_rst_async)     rcv_data <= 8'b11111111;
     else if (rcv_data_upd) rcv_data <= rcv_reg;

   always @(posedge scl_clk or posedge trcv_async_rst)
     if (trcv_async_rst)    rcv_arc <= 1'b1;
     else if (trst_ack_all) rcv_arc <= sda_in;

   always @(negedge scl_clk or posedge trcv_async_rst)
     if (trcv_async_rst)            trn_ack <= 1'b1;
     else if (trcv_all & trcv_done) trn_ack <= ~i2c_nack;

   // Receiving Information Decoding
   wire [7:0] slave_addr_msb = (|i2csaddr) ? i2csaddr : `DEFAULT_SADDRMSB;
   
   wire   gen_match   = (rcv_addr[6:0] == `GENERAL_ADDR) & ~rcv_rw;
   assign addr_gen    = i2c_gcen & gen_match;                                  // ACK
   assign addr_hsmode = i2c_en & (rcv_addr[6:2] == `HSMODE_ADDR);              // NO ACK
   assign addr_10bit  = i2c_en & (rcv_addr[6:2] == `S10BIT_ADDR);              // ACK
   assign addr_match2 = i2c_en & (rcv_addr[1:0] == slave_addr_msb[7:6]);
   
   assign addr_info    = gen_match | (addr_10bit & ~rcv_rw);                   // Need Info

   assign info_updrst  = addr_gen & (rcv_info == `GEN_UPDRST);  // Update partial slave addr from pin and reset
   assign info_updaddr = addr_gen & (rcv_info == `GEN_UPDADDR); // Update partial slave address from pin only (RSVD)
   assign info_wkup    = addr_gen & (rcv_info == `GEN_WKUPCMD); // For Wakeup from standby/sleep mode
   assign info_haddr   = addr_gen & rcv_info[0];

   wire   info_all = info_updrst | info_updaddr | info_wkup | info_haddr; 

   wire [9:0] slave_addr_10bit = {rcv_addr[1:0], rcv_info};
   wire [9:0] slave_addr_usr;

   assign slave_addr_usr = {slave_addr_msb, ADDR_LSB_USR};
   assign addr_musr7     = i2c_en & (rcv_addr[6:0] == slave_addr_usr[6:0]);
   assign addr_musr10    = i2c_en & (slave_addr_10bit == slave_addr_usr) & addr_10bit;
   
   assign addr_match7    = addr_musr7;
   assign addr_match10   = addr_musr10;
   
   // CFG FIFO Operation
   assign i2c_trn_dat = i2ctxdr;
   
   assign trst_rw_ok    = trst_data & rcv_rw;
   
   assign addr_ok       = addr_match7 | addr_match10 | mcst_master;
   assign addr_ok_usr7  = addr_musr7 | mcst_master;
   assign addr_ok_usr10 = addr_musr10 | mcst_master;
   assign addr_ok_usr   = addr_ok_usr7 | addr_ok_usr10;

   assign i2c_wkup = (i2c_wkupen & (addr_musr7 | addr_musr10)) | info_wkup;

   wire i2c_trn_mst = (trst_addr | ~trn_rw) & mc_trn_en;                                    // AEFB 00
   assign i2c_trn = mcst_master ? i2c_trn_mst : (rcv_rw & addr_ok);                         // AEFB 00
   assign i2c_trn_sync_mux = mcst_master ? i2c_trn_mst : (i2c_srw_sync & addr_ok_sync);     // AEFB 00
   
   assign i2c_rcv = ~i2c_trn & (addr_ok | info_haddr);

   wire   rst_rcv_ok = i2c_rst_async | trcv_start_pulse;
   always @(posedge scl_clk or posedge rst_rcv_ok)
     if (rst_rcv_ok)                 i2c_rcv_ok <= 1'b0;
     else if (trst_data & trcv_cnt6) i2c_rcv_ok <= i2c_rcv;
   
   // Determine the ACK
   assign acka = ~mcst_master & (addr_gen | (addr_10bit & addr_match2) | addr_match7) & trn_ack;
   assign ackb = ~mcst_master & (info_all | addr_match10) & trn_ack;
   assign ackd = (i2c_rcv & trn_ack);

   assign tr_sda_ack = (trst_acka & acka) | (trst_ackb & ackb) | (trst_ackd & ackd);
   assign tr_sda_en  = trcv_all & i2c_trn & (~rcv_arc | mcst_master);
   assign tr_sda_out = tr_sda_en ? trn_reg[7] : ~tr_sda_ack;

   // Wishbone registers control signal
   wire rcv_mon_srcv = (i2c_rcv & i2c_rrdy & ~i2c_cksdis);
   assign upd_gcsr = info_haddr & trst_ackb & scl_in;
   assign upd_gcdr = info_all & trst_ackb & scl_in;
   // assign upd_rxdr = i2c_rcv_ok & clk_str_cyc & (i2c_rbufdis | ~rcv_mon_srcv);
   assign upd_rxdr = i2c_rcv_ok & trst_arc_d_sync & (i2c_rbufdis | ~rcv_mon_srcv);    // SH feedback from NEC issue.
   
   //*****************************************
   // sb_clk domain
   //*****************************************
   wire   i2c_arbl_pulse;

   wire   mcst_staa, mcst_stac, mcst_trcb, mcst_trcc, mcst_stob, mcst_stoc;
   // wire   mcst_stab, mcst_trcd;
   // wire   i2c_intf;

   wire [7:0] i2csr;
   wire [9:0] div_fin;

   //************** Synchronizers **************
   always @(posedge sb_clk_i or posedge i2c_rst_async)
       if (i2c_rst_async)    trst_arc_d_sync0 <= 1'b0;
       else		     trst_arc_d_sync0 <= clk_str_cyc;
   always @(posedge sb_clk_i or posedge i2c_rst_async) 
       if (i2c_rst_async)    trst_arc_d_sync  <= 1'b0;
       else		     trst_arc_d_sync  <= trst_arc_d_sync0;

   always @(posedge sb_clk_i) i2c_rarc_sync0 <= rcv_arc;
   always @(posedge sb_clk_i) i2c_rarc_sync  <= i2c_rarc_sync0;

   always @(posedge sb_clk_i) i2c_srw_sync0 <= rcv_rw;
   always @(posedge sb_clk_i) i2c_srw_sync  <= i2c_srw_sync0;

   always @(posedge sb_clk_i) i2c_arbl_sync0 <= trcv_arbl;
   always @(posedge sb_clk_i) i2c_arbl_sync  <= i2c_arbl_sync0;
   assign i2c_arbl_pulse = i2c_arbl_sync0 & ~i2c_arbl_sync;

   // always @(posedge sb_clk_i) i2c_tip_sync0 <= trst_tip;
   always @(posedge sb_clk_i) i2c_tip_sync0 <= trst_tip | trcv_start | trcv_start_rst_d;    // PSM WH : FB-09
   always @(posedge sb_clk_i) i2c_tip_sync  <= i2c_tip_sync0;

   always @(posedge sb_clk_i) i2c_busy_sync0 <= trst_busy;
   always @(posedge sb_clk_i) i2c_busy_sync  <= i2c_busy_sync0;

   always @(posedge sb_clk_i) trst_rw_ok_sync0 <= trst_rw_ok;
   always @(posedge sb_clk_i) trst_rw_ok_sync  <= trst_rw_ok_sync0;

   always @(posedge sb_clk_i) addr_ok_sync0 <= addr_ok;                      // AEFB 00
   always @(posedge sb_clk_i) addr_ok_sync  <= addr_ok_sync0;                // AEFB 00
   

   always @(negedge scl_clk or posedge i2c_rst_async)
       if (i2c_rst_async)    i2c_trn_sync0 <= 1'b0;
       else                  i2c_trn_sync0 <= ~rcv_arc & i2c_trn;
   always @(posedge sb_clk_i) i2c_trn_sync  <= i2c_trn_sync0;

   always @(negedge scl_clk or posedge i2c_rst_async)
       if (i2c_rst_async)    i2c_rcv_sync0 <= 1'b0;
       else                  i2c_rcv_sync0 <= i2c_rcv;
   always @(posedge sb_clk_i) i2c_rcv_sync  <= i2c_rcv_sync0;

   always @(posedge scl_clk or posedge i2c_rst_async)
       if (i2c_rst_async)    addr_ok_usr_sync0 <= 1'b0;
       else                  addr_ok_usr_sync0 <= addr_ok_usr;
   always @(posedge sb_clk_i) addr_ok_usr_sync  <= addr_ok_usr_sync0;

   //******** Synchronized Pulse Generation ******
   always @(posedge sb_clk_i) upd_rxdr_sync[1:0] <= {upd_rxdr_sync[0], upd_rxdr};
   wire   upd_rxdr_pulse = i2c_rbufdis ? (upd_rxdr_sync[0] & ~upd_rxdr_sync[1]) : (~upd_rxdr_sync[0] & upd_rxdr_sync[1]);

   always @(posedge sb_clk_i) upd_gcdr_sync[1:0] <= {upd_gcdr_sync[0], upd_gcdr};
   wire   upd_gcdr_pulse = upd_gcdr_sync[0] & ~upd_gcdr_sync[1];

   always @(posedge sb_clk_i) upd_gcsr_sync[1:0] <= {upd_gcsr_sync[0], upd_gcsr};
   wire   upd_gcsr_pulse = upd_gcsr_sync[0] & ~upd_gcsr_sync[1];

   // Sense SCL rising
   always @(posedge sb_clk_i) i2c_scl_sense0 <= scl_in;
   always @(posedge sb_clk_i) i2c_scl_sense  <= i2c_scl_sense0;

   // Sense master SCL drive high
   always @(posedge sb_clk_i) mst_scl_sense0 <= mc_scl_out;
   always @(posedge sb_clk_i) mst_scl_sense  <= mst_scl_sense0;

   // Sync trcv cnt6
   always @(posedge sb_clk_i) trcv_cnt6_sync[2:0] <= {trcv_cnt6_sync[1:0], trcv_cnt6};
   assign trcv_cnt6_pulse = ~mcst_master & trcv_cnt6_sync[0] & ~trcv_cnt6_sync[1];
   assign trcv_cnt6_sense = ~mcst_master & trcv_cnt6_sync[2] & i2c_scl_sense & ~clk_max;

   // **************************************************
   // Slave Clock Stretching Logic
   // **************************************************
   wire   i2c_mon_strn   = (i2c_trn_sync & i2c_trdy & ~i2c_cksdis);
   wire   i2c_mon_srcv   = (i2c_rcv_sync & i2c_rrdy & ~i2c_cksdis);
   wire   i2c_mon_slv    = i2c_mon_strn | i2c_mon_srcv;
   wire   i2c_ckstr_qual = ~mcst_master & trst_arc_d_sync;
   wire   i2c_ckstr_det  = i2c_ckstr_qual & addr_ok_usr_sync & ~i2c_cksdis;

   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)                    tr_scl_out <= 1'b1;
     else if (i2c_sb_rst)                  tr_scl_out <= 1'b1;
     else if (i2c_ckstr_det & i2c_mon_slv) tr_scl_out <= 1'b0;
     else if (i2c_ckstr_qual & clk_en)     tr_scl_out <= 1'b1;
   
   assign ckstr_cnt_en  = i2c_ckstr_qual & ~i2c_mon_slv;
   
   // **************************************************
   // SCL generation counter
   // **************************************************
   assign div_fin = (|i2cbr) ? i2cbr : `DEFAULT_I2CBR;

   assign clk_en  = (clk_cnt == {16{1'b0}});
   assign clk_max = (clk_cnt == {16{1'b1}});
   
   // Detect clock stretching
   assign exec_stsp       = exec_start | exec_stop;
   wire   mc_slaves_ckstr = mst_scl_sense & ~i2c_scl_sense;
   wire   mc_master_ckstr = cmd_exec_active & ~i2c_cksdis & ((~trst_rw_ok_sync & i2c_trdy) | (trst_rw_ok_sync & i2c_rrdy) | ~rdwt_eval) & ~exec_stsp;  // Add rdwt_eval prevent clk miscount
   wire   mc_ckstr        = mc_slaves_ckstr | mc_master_ckstr;

   // Flag indicate that clk stretch happened
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)        ckstr_flag <= 1'b0;
     else if (mcst_trcb)       ckstr_flag <= 1'b0;
     else if (mc_master_ckstr) ckstr_flag <= 1'b1;

   // clock cnt control
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async) exec_stsp_det <= 2'b00;
     else               exec_stsp_det <= {exec_stsp, exec_stsp_det[1]};
   wire   clk_cnt_stsp_set = exec_stsp_det[1] & ~exec_stsp_det[0];
   wire   mcst_start       = exec_stsp_det[0];
   
   wire clk_cnt_rst  = (~i2c_en | trcv_cnt6_pulse) & ~clk_en;
   wire clk_cnt_set  = (mc_next_busy & clk_en) | clk_cnt_stsp_set;
   wire clk_dcnt_run = ((mc_next_busy | mcst_master) & ~mc_ckstr) | ckstr_cnt_en;
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     begin
       if (i2c_rst_async)        clk_cnt <= {16{1'b0}};
       else if (i2c_sb_rst)      clk_cnt <= {16{1'b0}};
       else if (clk_cnt_rst)     clk_cnt <= {16{1'b0}};
       else if (trcv_cnt6_sense) clk_cnt <= clk_cnt + 1;
       else if (clk_cnt_set)     clk_cnt <= {{6{1'b0}}, div_fin};
       else if (clk_dcnt_run)    clk_cnt <= clk_cnt - 1;
     end

   // **************************************************

   // Master Command Execution
   // **************************************************

   // New Command Flag
   wire ncmd_rst = i2c_sb_rst | start_arbl;
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     begin
       if (i2c_rst_async)     mcmd_stcmd <= 1'b0;
       else if (ncmd_rst)     mcmd_stcmd <= 1'b0;
       else if (cmd_exec_fin) mcmd_stcmd <= 1'b0;
       else if (i2ccmdr_wt)   mcmd_stcmd <= i2c_sta;
     end

   always @(posedge sb_clk_i or posedge i2c_rst_async)
     begin
       if (i2c_rst_async)               mcmd_start <= 1'b0;
       else if (ncmd_rst)               mcmd_start <= 1'b0;
       else if (cmd_exec_fin)           mcmd_start <= 1'b0;
       else if (mcmd_stcmd & ~i2c_trdy) mcmd_start <= 1'b1;
     end
   
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     begin
       if (i2c_rst_async)             mcmd_stop <= 1'b0;
       else if (i2c_sb_rst)           mcmd_stop <= 1'b0;
       else if (cmd_exec_fin)         mcmd_stop <= 1'b0;
       else if (i2ccmdr_wt & i2c_sto) mcmd_stop <= 1'b1;
     end

   assign cmd_start   = i2c_en & i2c_sta & cmd_wt;                          // start cmd must include wt
   assign cmd_stop    = i2c_en & i2c_sto & ~i2c_sta;
   assign cmd_rd      = i2c_en & i2c_rd  & ~i2c_wt;
   assign cmd_wt      = i2c_en & i2c_wt  & ~i2c_rd;

   // assign cmd_exec_active = (mcst_trcd & trst_arc_d_sync);
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)   cmd_exec_active <= 1'b0;
     else if (i2c_sb_rst) cmd_exec_active <= 1'b0;
     else                 cmd_exec_active <= clk_en ? (mc_next == MC_TRCD) & trst_arc_d_sync : cmd_exec_active;

   assign cmd_exec_en = (~mcst_master | cmd_exec_active);
   
   assign start_arbl = i2ccmdr_wt & cmd_start & ~mcst_master & i2c_busy_sync;

   always @(posedge sb_clk_i) cmd_exec_en_d <= cmd_exec_en;

   assign cmd_exec_run = (cmd_exec_en) & ~start_arbl;
   
   // assign cmd_exec_wt  = (cmd_exec_active | mcst_stab) & ~start_arbl;
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)   cmd_exec_wt <= 1'b0;
     else if (i2c_sb_rst) cmd_exec_wt <= 1'b0;
     else                 cmd_exec_wt <= clk_en ? ((((mc_next == MC_TRCD) & trst_arc_d_sync) | (mc_next == MC_STAB)) & ~start_arbl) : cmd_exec_wt;
   
   assign cmd_exec_fin = ~cmd_exec_en & cmd_exec_en_d;

   assign exec_start   = cmd_start & cmd_exec_run & mcmd_start;
   assign exec_stop    = cmd_stop  & cmd_exec_run & mcmd_stop;
   assign exec_rd      = cmd_rd    & cmd_exec_run;
   assign exec_wt      = cmd_wt    & cmd_exec_wt;

   wire   cap_txdr_mstr    = exec_wt;
   wire   cap_txdr_slv_en  = i2c_trn & ~i2c_mon_strn;
   wire   cap_txdr_slv     = cap_txdr_slv_en & clk_str_cyc;
   wire   cap_txdr_slv_syn = cap_txdr_slv_en & trst_arc_d_sync;                              // SH NEC 2nd
   assign cap_txdr_act_nst = (cap_txdr_mstr | cap_txdr_slv);
   assign cap_txdr_act_syn = (cap_txdr_mstr | cap_txdr_slv_syn);                             // SH NEC 2nd
   assign cap_txdr_act     = ~scan_test_mode & cap_txdr_act_nst;

   always @(posedge sb_clk_i) cap_txdr_sync <= {cap_txdr_sync[0], cap_txdr_act_syn};         // SH NEC 2nd
   
   assign cap_txdr_fin     = ~cap_txdr_sync[0] & cap_txdr_sync[1];
   
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     begin
       if (i2c_rst_async)   trn_rw <= 1'b0;
       else if (i2c_sb_rst) trn_rw <= 1'b0;
       else if (exec_start) trn_rw <= (i2c_sta & i2c_rwbit);
     end

   // **************************************************
   // FSM for START/STOP Generation and SCL Generation
   // **************************************************
   assign mc_next_busy = (mc_next != MC_IDLE);
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)   mcst_master <= 1'b0;
     else if (i2c_sb_rst) mcst_master <= 1'b0;
     else                 mcst_master <= clk_en ? mc_next_busy : mcst_master;
   
   assign mcst_staa   = (mc_state == MC_STAA);
   // assign mcst_stab   = (mc_state == MC_STAB);
   assign mcst_stac   = (mc_state == MC_STAC);
   assign mcst_trcb   = (mc_state == MC_TRCB);
   assign mcst_trcc   = (mc_state == MC_TRCC);
   // assign mcst_trcd   = (mc_state == MC_TRCD);
   assign mcst_stob   = (mc_state == MC_STOB);
   assign mcst_stoc   = (mc_state == MC_STOC);

   assign rdwt_eval = ( exec_rd & trn_rw) | (exec_wt & ~trn_rw);

   wire   mcst_exec_start = mcst_start & exec_start;
   wire   mcst_exec_stop  = mcst_start & exec_stop;
   
   // Conbinational Next State Logic
   always @(/*AUTOSENSE*/ckstr_flag or exec_start or exec_stop
            or mc_state or mcst_exec_start or mcst_exec_stop
            or rdwt_eval or trst_arc_d_sync)
     begin
        case (mc_state)
          MC_IDLE : begin
             if (mcst_exec_start)      mc_next = MC_STAP;
             else if (mcst_exec_stop)  mc_next = MC_STOP;
             else                      mc_next = MC_IDLE;
          end
          MC_STAP :                    mc_next = MC_STAA;
          MC_STAA :                    mc_next = MC_STAB;
          MC_STAB :                    mc_next = MC_STAC;
          MC_STAC :                    mc_next = MC_STAD;
          MC_STAD :                    mc_next = MC_TRCA;

          MC_TRCA :                    mc_next = MC_TRCB;
          MC_TRCB :                    mc_next = MC_TRCC;
          MC_TRCC :                    mc_next = MC_TRCD;
          MC_TRCD : begin
             if (trst_arc_d_sync) begin
                if (exec_start)        mc_next = MC_STRP;
                else if (exec_stop)    mc_next = MC_STOA;
                else if (rdwt_eval) begin
		   if (ckstr_flag)     mc_next = MC_STAD;    // Change from TRCA to STAD for full 1st bit setup time after clock stretch
		   else                mc_next = MC_TRCA;
		end
                else                   mc_next = MC_TRCD;
             end
             else                      mc_next = MC_TRCA;
          end
          MC_STRP :                    mc_next = MC_STAA;
	  MC_STOP :                    mc_next = MC_STOA;
          MC_STOA :                    mc_next = MC_STOB;
          MC_STOB :                    mc_next = MC_STOC;
          MC_STOC :                    mc_next = MC_STOD;
          MC_STOD :                    mc_next = MC_IDLE;
          default :                    mc_next = MC_IDLE;
        endcase // case(mc_state)
     end // always @ (...

   // Sequential block
   wire arbl_det = ((mcst_trcb | mcst_trcc) & i2c_arbl);
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)   mc_state <= MC_IDLE;
     else if (i2c_sb_rst) mc_state <= MC_IDLE;
     else if (arbl_det)   mc_state <= MC_IDLE;
     else                 mc_state <= clk_en ? mc_next : mc_state;

   always @(negedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)   mc_trn_en <= 1'b0;
     else if (i2c_sb_rst) mc_trn_en <= 1'b0;
     // else if (clk_en)     mc_trn_en <= mc_trn_pre;
     else                 mc_trn_en <= mc_trn_pre;
   
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)   mc_sda_out <= 1'b1;
     else if (i2c_sb_rst) mc_sda_out <= 1'b1;
     // else if (clk_en)     mc_sda_out <= mc_sda_pre;
     else                 mc_sda_out <= mc_sda_pre;
   
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)   mc_scl_out <= 1'b1;
     else if (i2c_sb_rst) mc_scl_out <= 1'b1;
     // else if (clk_en)     mc_scl_out <= mc_scl_pre;
     else                 mc_scl_out <= mc_scl_pre;

   wire del_zero_nxt_sts = ((mc_next == MC_STAA) | (mc_next == MC_STAB) | (mc_next == MC_STAC) |
			    (mc_next == MC_STOA) | (mc_next == MC_STOB) | (mc_next == MC_STOC));
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)   del_zero_states <= 1'b0;
     else if (i2c_sb_rst) del_zero_states <= 1'b0;
     else                 del_zero_states <= del_zero_nxt_sts;
   
   // SDA_OUT AND SCL_OUT
   always @(/*AUTOSENSE*/mc_next)
     begin
        case (mc_next)
          MC_IDLE : begin
             mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b1;
             mc_trn_pre = 1'b0;
          end
	  MC_STAP : begin
	     mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b1;
             mc_trn_pre = 1'b0;
          end
          MC_STAA : begin
             mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b1;
             mc_trn_pre = 1'b0;
          end
          MC_STAB : begin
             mc_sda_pre = 1'b0;
             mc_scl_pre = 1'b1;
             mc_trn_pre = 1'b0;
          end
          MC_STAC : begin
             mc_sda_pre = 1'b0;
             mc_scl_pre = 1'b0;
             mc_trn_pre = 1'b0;
          end
          MC_STAD : begin
             mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b0;
             mc_trn_pre = 1'b1;
          end
          MC_TRCA : begin
             mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b0;
             mc_trn_pre = 1'b1;
          end
          MC_TRCB : begin
             mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b1;
             mc_trn_pre = 1'b1;
          end
          MC_TRCC : begin
             mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b1;
             mc_trn_pre = 1'b1;
          end
          MC_TRCD : begin
             mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b0;
             mc_trn_pre = 1'b1;
          end
          MC_STRP : begin
             mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b0;
             mc_trn_pre = 1'b0;
          end
	  MC_STOP : begin
	     mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b0;
             mc_trn_pre = 1'b0;
          end
          MC_STOA : begin
             mc_sda_pre = 1'b0;
             mc_scl_pre = 1'b0;
             mc_trn_pre = 1'b0;
          end
          MC_STOB : begin
             mc_sda_pre = 1'b0;
             mc_scl_pre = 1'b1;
             mc_trn_pre = 1'b0;
          end
          MC_STOC : begin
             mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b1;
             mc_trn_pre = 1'b0;
          end
          MC_STOD : begin
             mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b1;
             mc_trn_pre = 1'b0;
          end
          default : begin
             mc_sda_pre = 1'b1;
             mc_scl_pre = 1'b1;
             mc_trn_pre = 1'b0;
          end
        endcase // case(mc_state)
     end // always @ (...


   //*****************************************
   // Interrupt Flags
   //*****************************************
   always @(posedge sb_clk_i) trcv_start_sync <= {trcv_start, trcv_start_sync[2:1]};
   assign trcv_start_pulse = (trcv_start_sync[2] | trcv_start_sync[1]) & ~trcv_start_sync[0];
   
   wire   i2c_int_rst = i2c_sb_rst | trcv_start_pulse;

   // Hardware General Call Received Flag
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)       i2c_hgc <= 1'b0;
     else if (i2c_int_rst)    i2c_hgc <= 1'b0;
     else if (i2cgcdr_rd)     i2c_hgc <= 1'b0;
     else if (upd_gcsr_pulse) i2c_hgc <= 1'b1;

   // Arbitration Lost Flag
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)       i2c_arbl <= 1'b0;
     else if (i2c_int_rst)    i2c_arbl <= 1'b0;
     else if (i2c_arbl_pulse) i2c_arbl <= 1'b1;
     else if (start_arbl)     i2c_arbl <= 1'b1;

   // Transmitter Register Ready Flag
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)     i2c_trdy <= 1'b1;
     else if (i2ctxdr_wt)   i2c_trdy <= 1'b0;
     else if (i2c_int_rst)  i2c_trdy <= 1'b1;
     else if (cap_txdr_fin) i2c_trdy <= 1'b1;

   // Transmitter Register Overrun Error Flag
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)    i2c_toe <= 1'b0;
     else if (i2c_int_rst) i2c_toe <= 1'b0;
     else if (i2ctxdr_wt)  i2c_toe <= ~i2c_trdy ? ~i2c_trdy : i2c_toe;

   // Receiving Register Ready Flag
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)       i2c_rrdy <= 1'b0;
     else if (i2crxdr_rd)     i2c_rrdy <= 1'b0;
     else if (i2c_int_rst)    i2c_rrdy <= 1'b0;
     else if (upd_rxdr_pulse) i2c_rrdy <= 1'b1;

   // Receiving Register Overrun Error Flag
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)    i2c_roe <= 1'b0;
     else if (i2c_int_rst) i2c_roe <= 1'b0;
     else if (i2crxdr_rd)  i2c_roe <= 1'b0;
     else if (upd_rxdr_pulse) i2c_roe <= i2c_rrdy ? i2c_rrdy : i2c_roe;

   assign i2c_trrdy = i2c_trn_sync_mux ? i2c_trdy : i2c_rrdy;                       // AEFB 00
   // assign i2c_troe  = i2c_trn ? i2c_toe : i2c_roe;
   assign i2c_troe  = i2c_trn ? ((~i2c_tip_sync & rcv_arc) | i2c_toe) : i2c_roe;    // PSM WH : FB-10

   //*****************************************
   // Output Regs
   //*****************************************
   // General Call Info Register
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)       i2cgcdr <= {8{1'b0}};
     else if (i2c_sb_rst)     i2cgcdr <= {8{1'b0}};
     else if (upd_gcdr_pulse) i2cgcdr <= rcv_info;

   // Receiving Data Register
   always @(posedge sb_clk_i or posedge i2c_rst_async)
     if (i2c_rst_async)       i2crxdr <= {8{1'b0}};
     else if (i2c_sb_rst)     i2crxdr <= {8{1'b0}};
     else if (upd_rxdr_pulse) i2crxdr <= rcv_data;

   // I2C Status Register
   // assign i2csr = {(i2c_tip_sync | mcst_master), i2c_busy_sync, i2c_rarc_sync, i2c_srw_sync, i2c_arbl, i2c_trrdy, i2c_troe, i2c_hgc};
   assign i2csr = {i2c_tip_sync, i2c_busy_sync, i2c_rarc_sync, i2c_srw_sync, i2c_arbl, i2c_trrdy, i2c_troe, i2c_hgc};  // PSM WH : FB-09 / FB-10

   //*****************************************
   // SDA, SCL Output
   //*****************************************
   assign sda_out_int = mc_sda_out & tr_sda_out;

   assign scl_out = mc_scl_out & tr_scl_out;
   assign scl_oe  = ~scl_out;

   //*****************************************
   // 300 ns for SDA
   //*****************************************
   reg [1:0] sda_out_det;
   reg [5:0] sda_del_cnt;
   reg [5:0] n_del_cnt;
   reg       sda_del_cnt_en;
   reg 	     sda_no_del;
   
   wire      sda_del_cnt_up;
   // wire [3:0] n_del = (|trim_sda_del) ? trim_sda_del : `N_SDA_DEL_075;
   wire [3:0] n_del = trim_sda_del;
   
   wire       del_rstn_async_logic = ~(i2c_rst_async | i2c_sb_rst);
   wire       del_rstn_async;
   SYNCP_STD rstn_sync (.d(1'b1), .ck(del_clk), .cdn(del_rstn_async_logic), .q(del_rstn_async));  // async on, sync off
   wire       del_rst_async = ~del_rstn_async;
       
   always @(posedge del_clk or posedge del_rst_async) 
     if (del_rst_async) sda_no_del <= 1'b0;
     else               sda_no_del <= (del_zero_states | (&sda_del_sel));

   always @(/*AS*/n_del or sda_del_sel)
     begin
        case (sda_del_sel)
          2'b00   : n_del_cnt = {n_del, 1'b0, 1'b0};
          2'b01   : n_del_cnt = {1'b0, n_del, 1'b0};
          2'b10   : n_del_cnt = {1'b0, 1'b0, n_del};
          2'b11   : n_del_cnt = {6{1'b0}};
          default : n_del_cnt = {6{1'b0}};
        endcase // case(sda_del_sel)
     end

   assign sda_del_cnt_up = ~(|sda_del_cnt);
   // assign sda_del_cnt_up = (sda_del_cnt == 6'b000011);    // PSM WH : WJ C&V - Consider synchronization and transition latency. More acruate in actual delay

   always @(posedge del_clk or posedge del_rst_async) 
     if (del_rst_async) sda_out_det <= {2{1'b0}};
     else               sda_out_det <= {sda_out_int, sda_out_det[1]};
   wire   sda_out_pulse = sda_out_det[0] ^ sda_out_det[1];

   always @(posedge del_clk or posedge del_rst_async)
     if (del_rst_async)       sda_del_cnt_en <= 1'b0;
     else if (sda_del_cnt_up) sda_del_cnt_en <= 1'b0;
     else if (sda_out_pulse)  sda_del_cnt_en <= 1'b1;

   always @(posedge del_clk or posedge del_rst_async) 
     if (del_rst_async) del_cnt_set_sense <= {3'b100};
     else               del_cnt_set_sense <= {i2ccr1_wt, del_cnt_set_sense[2:1]};
   wire   sda_del_cnt_set = del_cnt_set_sense[1] & ~del_cnt_set_sense[0];
   
   always @(posedge del_clk or posedge del_rst_async)
     if (del_rst_async)                         sda_del_cnt <= {6{1'b0}};
     else if (sda_del_cnt_set | sda_del_cnt_up) sda_del_cnt <= n_del_cnt;
     else if (sda_del_cnt_en)                   sda_del_cnt <= sda_del_cnt - 1;

   always @(posedge del_clk or posedge del_rst_async)
     if (del_rst_async)       sda_out_sense_r <= 1'b1;
     else if (sda_del_cnt_up) sda_out_sense_r <= sda_out_int;

   assign  sda_out_sense = (sda_no_del) ? sda_out_int : sda_out_sense_r;

   // assign  sda_out = sda_out_sense;
   assign sda_out = sda_out_sense;
   assign sda_oe  = ~sda_out;
   
endmodule // i2c_port



//--------------------------------EOF-----------------------------------------
// *************************  -*- Mode: Verilog -*- *********************
// ============================================================================
//                          COPYRIGHT NOTICE
// Copyright (c) 2008             Lattice Semiconductor Corporation
// ALL RIGHTS RESERVED
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from Lattice Semiconductor Corporation. The entire
// notice above must be reproduced on all authorized copies and copies may
// only be made to the extent permitted by a licensing agreement from
// Lattice Semiconductor Corporation.
//
// Lattice Semiconductor Corporation       TEL : 1-800-Lattice (USA and Canada)
// 5555 NE Moore Court                           408-826-6000 (other locations)
// Hillsboro, OR 97124                    web  : http://www.latticesemi.com/
// U.S.A                                  email: techsupport@latticesemi.com
// ============================================================================
// Filename        : i2c_ip.v
// Description     : I2C IP
// Author          : Wei Han
// Created On      : Fri. Mar. 22 18:04:22 2013
// Last Modified By: $Author: weihan $
// Last Modified On: $Date: 2013-03-27 21:34:08-07 $
// Revision        : $Revision: 1.2 $
//
// ****************************************************************************
// Revision History:
// $Log: logic_design#i2c_ip#design#rtl#i2c_ip.v,v $
// Revision 1.2  2013-03-27 21:34:08-07  weihan
// ...No comments entered during checkin...
//
// Revision 1.1  2013-03-27 12:03:16-07  weihan
// Initial Check In
//
 // JAY : added VDD,VSS for DMS 
`timescale 1ns/1ps

module i2c_ip (/*AUTOARG*/
   // Outputs
   sda_out, sda_oe, scl_out, scl_oe, sb_dat_o, sb_ack_o, i2c_irq,
   i2c_wkup,
   // Inputs
   SB_ID, ADDR_LSB_USR, i2c_rst_async, sda_in, scl_in, del_clk,
   sb_clk_i, sb_we_i, sb_stb_i, sb_adr_i, sb_dat_i, scan_test_mode , VDD,VSS
   );

    input VDD,VSS; 
   // INPUTS
   // From IP TOP Tie High/Tie Low
   input [`SBAW-5:0] SB_ID;
   input [1:0]       ADDR_LSB_USR;
   
   // From full chip POR ...
   input i2c_rst_async;

   // From I2C Bus
   input sda_in, scl_in;
   
   // From System Bus
   input del_clk;               // Could tie to sb_clk_i outside if there is no other High Frequency Source

   input sb_clk_i;
   input sb_we_i;
   input sb_stb_i;

   input [`SBAW-1:0] sb_adr_i;
   input [`SBDW-1:0] sb_dat_i;

   // From CFG Trim Control
   // input [3:0]       trim_sda_del;    Not Support by default

   // From SCAN TEST Control
   input             scan_test_mode;
   
   
   // OUTPUTS
   // To I2C Bus
   output            sda_out, sda_oe;
   output            scl_out, scl_oe;
   
   // To Sysem Bus
   output [`SBDW-1:0]   sb_dat_o;
   output               sb_ack_o;
   
   // To System Host
   output               i2c_irq;

   // Optional system function
   // output               i2c_hsmode;    // Potentially send out to turn on optional pull up current source
   output               i2c_wkup;         // Signal to wakeup from standy/sleep mode, Rising edge detect at Power Manager Block
   
   // REGS


   // WIRES
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 i2c_hsmode;             // From i2c_port_inst of i2c_port.v
   wire [`I2CBRW-1:0]   i2cbr;                  // From i2c_sci_inst of i2c_sci.v
   wire                 i2cbr_wt;               // From i2c_sci_inst of i2c_sci.v
   wire [`SBDW-1:0]     i2ccmdr;                // From i2c_sci_inst of i2c_sci.v
   wire                 i2ccmdr_wt;             // From i2c_sci_inst of i2c_sci.v
   wire [`SBDW-1:0]     i2ccr1;                 // From i2c_sci_inst of i2c_sci.v
   wire                 i2ccr1_wt;              // From i2c_sci_inst of i2c_sci.v
   wire [7:0]           i2cgcdr;                // From i2c_port_inst of i2c_port.v
   wire                 i2cgcdr_rd;             // From i2c_sci_inst of i2c_sci.v
   wire [7:0]           i2crxdr;                // From i2c_port_inst of i2c_port.v
   wire                 i2crxdr_rd;             // From i2c_sci_inst of i2c_sci.v
   wire [`SBDW-1:0]     i2csaddr;               // From i2c_sci_inst of i2c_sci.v
   wire                 i2csaddr_wt;            // From i2c_sci_inst of i2c_sci.v
   wire [7:0]           i2csr;                  // From i2c_port_inst of i2c_port.v
   wire [`SBDW-1:0]     i2ctxdr;                // From i2c_sci_inst of i2c_sci.v
   wire                 i2ctxdr_wt;             // From i2c_sci_inst of i2c_sci.v
   wire [`DTRMW-1:0]    trim_sda_del;           // From i2c_sci_inst of i2c_sci.v
   // End of automatics


   // LOGIC
   
   i2c_sci i2c_sci_inst (/*AUTOINST*/
                         // Outputs
                         .i2ccr1                (i2ccr1[`SBDW-1:0]),
                         .i2ccmdr               (i2ccmdr[`SBDW-1:0]),
                         .i2ctxdr               (i2ctxdr[`SBDW-1:0]),
                         .i2cbr                 (i2cbr[`I2CBRW-1:0]),
                         .i2csaddr              (i2csaddr[`SBDW-1:0]),
                         .i2ccr1_wt             (i2ccr1_wt),
                         .i2ccmdr_wt            (i2ccmdr_wt),
                         .i2cbr_wt              (i2cbr_wt),
                         .i2ctxdr_wt            (i2ctxdr_wt),
                         .i2csaddr_wt           (i2csaddr_wt),
                         .i2crxdr_rd            (i2crxdr_rd),
                         .i2cgcdr_rd            (i2cgcdr_rd),
                         .trim_sda_del          (trim_sda_del[`DTRMW-1:0]),
                         .sb_dat_o              (sb_dat_o[`SBDW-1:0]),
                         .sb_ack_o              (sb_ack_o),
                         .i2c_irq               (i2c_irq),
                         // Inputs
                         .SB_ID                 (SB_ID[`SBAW-5:0]),
                         .i2c_rst_async         (i2c_rst_async),
                         .sb_clk_i              (sb_clk_i),
                         .sb_we_i               (sb_we_i),
                         .sb_stb_i              (sb_stb_i),
                         .sb_adr_i              (sb_adr_i[`SBAW-1:0]),
                         .sb_dat_i              (sb_dat_i[`SBDW-1:0]),
                         .i2csr                 (i2csr[`SBDW-1:0]),
                         .i2crxdr               (i2crxdr[`SBDW-1:0]),
                         .i2cgcdr               (i2cgcdr[`SBDW-1:0]),
                         .scan_test_mode        (scan_test_mode));

   i2c_port i2c_port_inst (/*AUTOINST*/
                           // Outputs
                           .sda_out             (sda_out),
                           .sda_oe              (sda_oe),
                           .scl_out             (scl_out),
                           .scl_oe              (scl_oe),
                           .i2crxdr             (i2crxdr[7:0]),
                           .i2cgcdr             (i2cgcdr[7:0]),
                           .i2csr               (i2csr[7:0]),
                           .i2c_hsmode          (i2c_hsmode),
                           .i2c_wkup            (i2c_wkup),
                           // Inputs
                           .ADDR_LSB_USR        (ADDR_LSB_USR[1:0]),
                           .i2c_rst_async       (i2c_rst_async),
                           .sda_in              (sda_in),
                           .scl_in              (scl_in),
                           .del_clk             (del_clk),
                           .sb_clk_i            (sb_clk_i),
                           .i2ccr1              (i2ccr1[`SBDW-1:0]),
                           .i2ccmdr             (i2ccmdr[`SBDW-1:0]),
                           .i2ctxdr             (i2ctxdr[`SBDW-1:0]),
                           .i2cbr               (i2cbr[`I2CBRW-1:0]),
                           .i2csaddr            (i2csaddr[`SBDW-1:0]),
                           .i2ccr1_wt           (i2ccr1_wt),
                           .i2ccmdr_wt          (i2ccmdr_wt),
                           .i2cbr_wt            (i2cbr_wt),
                           .i2ctxdr_wt          (i2ctxdr_wt),
                           .i2csaddr_wt         (i2csaddr_wt),
                           .i2crxdr_rd          (i2crxdr_rd),
                           .i2cgcdr_rd          (i2cgcdr_rd),
                           .trim_sda_del        (trim_sda_del[3:0]),
                           .scan_test_mode      (scan_test_mode));


endmodule // i2c_ip

//--------------------------------EOF-----------------------------------------
