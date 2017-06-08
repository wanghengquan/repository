// Verilog netlist of
// "thunder_ams"

// HDL models

// HDL file - umc40lp_ams, thunder_ams_digital, functional.

// =============================================================================
// =============================================================================
//                          COPYRIGHT NOTICE
// Copyright (c) 2014                           Lattice Semiconductor Corporation
// ALL RIGHTS RESERVED
// This confidential and proprietary software may be used only as authorized by
// a licensing agreement from Lattice Semiconductor Corporation. The entire
// notice above must be reproduced on all authorized copies and copies may only
// be made to the extent permitted by a licensing agreement from Lattice
// Semiconductor Corporation.
//
// Lattice Semiconductor Corporation        TEL : 1-800-Lattice (USA and Canada)
// 5555 NE Moore Court                              408-826-6000 (other locations)
// Hillsboro, OR 97124                      web  : http://www.latticesemi.com/
// U.S.A                                    email: techsupport@latticesemi.com
//
//
// Module: thunder_ams_digital
// Author:
// Description:
//      Based on the Trents initial version
// Revision:
//      Initial check-in
//      1/7/2014 - renamed the iledir_source_enable
//
// ==============================================================================
// TODO list - everything -just starting
// TODO - output buffering - define some BUF
// TODO - delays - assuming no need to do so here. was mentioned for ref_on
// ==============================================================================

//Verilog HDL for "umc40lp_ams", "thunder_ams_digital" "functional"

module thunder_ams_digital  (
    hf_clk_div,
    hf_clk_out,
    hf_fabric_enable,
    hf_on,
    hf_osc_enable,
    hf_osc_out,
    hf_output_enable,
    hf_therm_trim,
    hf_trim,
    hf_trim_fabric,
    hf_trim_msb,
    hf_trim_nv,

    iledir_source_enable,
    iledir_fabric_enable,
    iledir_on,
    iledir_trim,
    iledir_trim_fabric,
    iledir_trim_nv,

    lf_clk_out,
    lf_fabric_enable,
    lf_on,
    lf_osc_enable,
    lf_osc_out,
    lf_output_enable,
    lf_therm_trim,
    lf_trim,
    lf_trim_fabric,
    lf_trim_msb,
    lf_trim_nv,
    ref_on
    );

parameter LF_DIV_STRT_CNT = 1 ; // =N maps to a N-stage ripple count on the LF clock, N must be >=1
parameter HF_DIV_STRT_CNT = 7 ; // =N maps to a N-stage ripple count on the HF clock, N must be >=1
// define the clock output signal drive here - for now using symmetrical x16
`define HF_CLK_BUFFER_TYPE SEH_BUF_S_16
`define LF_CLK_BUFFER_TYPE SEH_BUF_S_16

input       [9:0]   hf_trim_fabric;
input       [9:0]   hf_trim_nv;
output              hf_trim_msb;
output      [3:0]   hf_trim;
output reg  [14:0]  hf_therm_trim;
input               hf_fabric_enable;

input       [1:0]   hf_clk_div;
input               hf_osc_enable;      // from fabric - This flows through to enable the external oscillator
input               hf_osc_out;         // from analog - the raw clock from the oscillator
input               hf_output_enable;   // from fabric - This enables the cleanly 
output              hf_clk_out;         // to fabric 
output              hf_on;              // to analog   - enables the oscillator

input       [9:0]   iledir_trim_fabric;
input       [9:0]   iledir_trim_nv;
input               iledir_source_enable;
input               iledir_fabric_enable;
output      [7:0]   iledir_trim;
output              iledir_on;

input       [9:0]   lf_trim_fabric;
input       [9:0]   lf_trim_nv;
input               lf_fabric_enable;
input               lf_osc_enable;
input               lf_osc_out;
input               lf_output_enable;
output      [3:0]   lf_trim;
output reg  [14:0]  lf_therm_trim;
output              lf_trim_msb;
output              lf_clk_out;
output              lf_on;

output              ref_on;


wire [8:0] lf_trim_muxed;
wire [8:0] hf_trim_muxed;


//Trim Signal Muxes
//lf trim
assign lf_trim_muxed = lf_fabric_enable ? lf_trim_fabric[8:0]: lf_trim_nv[8:0];
//hf trim
assign hf_trim_muxed = hf_fabric_enable ? hf_trim_fabric[8:0]: hf_trim_nv[8:0];
//iled trim
assign iledir_trim = iledir_fabric_enable ? iledir_trim_fabric[7:0]: iledir_trim_nv[7:0];


//Trim Decode
assign lf_trim_msb = lf_trim_muxed[8];
assign lf_trim[3:0] = lf_trim_muxed[3:0];

assign hf_trim_msb = hf_trim_muxed[8];
assign hf_trim[3:0] = hf_trim_muxed[3:0];

//Bin2Therm decoder for bits 7:4
//lf
always @(*) begin
    case(lf_trim_muxed[7:4])
        4'h0:lf_therm_trim =15'h0000; 
        4'h1:lf_therm_trim =15'h0001; 
        4'h2:lf_therm_trim =15'h0003; 
        4'h3:lf_therm_trim =15'h0007; 
        4'h4:lf_therm_trim =15'h000f; 
        4'h5:lf_therm_trim =15'h001f; 
        4'h6:lf_therm_trim =15'h003f; 
        4'h7:lf_therm_trim =15'h007f; 
        4'h8:lf_therm_trim =15'h00ff; 
        4'h9:lf_therm_trim =15'h01ff; 
        4'ha:lf_therm_trim =15'h03ff; 
        4'hb:lf_therm_trim =15'h07ff; 
        4'hc:lf_therm_trim =15'h0fff; 
        4'hd:lf_therm_trim =15'h1fff; 
        4'he:lf_therm_trim =15'h3fff; 
        4'hf:lf_therm_trim =15'h7fff; 
        //default: lf_therm_trim=15'h0000;
   endcase
end
//hf
always @(*) begin
    case(hf_trim_muxed[7:4])
        4'h0:hf_therm_trim =15'h0000; 
        4'h1:hf_therm_trim =15'h0001; 
        4'h2:hf_therm_trim =15'h0003; 
        4'h3:hf_therm_trim =15'h0007; 
        4'h4:hf_therm_trim =15'h000f; 
        4'h5:hf_therm_trim =15'h001f; 
        4'h6:hf_therm_trim =15'h003f; 
        4'h7:hf_therm_trim =15'h007f; 
        4'h8:hf_therm_trim =15'h00ff; 
        4'h9:hf_therm_trim =15'h01ff; 
        4'ha:hf_therm_trim =15'h03ff; 
        4'hb:hf_therm_trim =15'h07ff; 
        4'hc:hf_therm_trim =15'h0fff; 
        4'hd:hf_therm_trim =15'h1fff; 
        4'he:hf_therm_trim =15'h3fff; 
        4'hf:hf_therm_trim =15'h7fff; 
        //default: hf_therm_trim=15'h0000;
   endcase
end

// High Frequency (hf_*) and Low Frequency (lf_*) dividers
reg lf_clk_out_pre;
reg hf_clk_out_pre;
reg [2:0] lf_div_count; // fixed divide by 16 count rools at 7 and clock toggles
reg [1:0] hf_div_count; // variable divide 2,4,8 count rolls at 3 and clock toggles

// synchronous gating of hf good & output_enable
reg hf_output_enable_rank_1 ;
reg hf_output_enable_synched ;
reg lf_output_enable_rank_1 ;
reg lf_output_enable_synched ;

// lf divider 
//
always @ (posedge lf_osc_out or negedge lf_osc_enable ) begin
    if(!lf_osc_enable) begin
        lf_div_count    <= 0;
        lf_clk_out_pre  <= 0;
    end else begin
        if ( lf_clk_out_pre | lf_output_enable_synched ) begin
            lf_clk_out_pre  <= (lf_div_count == 3'b111 ) ? ~lf_clk_out_pre : lf_clk_out_pre ;
            lf_div_count    <= (lf_div_count == 3'b111 ) ?               0 : lf_div_count+1 ;
        end
    end
end

// hf divider and clock gate
//
// Avoiding sim startup nonsense, made this a function
function [1:0] f_hf_preload (input [1:0] hf_clk_div_select ) ;
begin
    case(hf_clk_div_select)
        2'b00: f_hf_preload = 2'b11; // div 1 - not used in divider
        2'b01: f_hf_preload = 2'b11; // div 2
        2'b10: f_hf_preload = 2'b10; // div 4
        2'b11: f_hf_preload = 2'b00; // div 8
    endcase
end
endfunction 
// Declaring for clarity
// In this case we do not divide the clock at all
wire hf_using_raw_clock = (hf_clk_div == 2'b00 );

always @ (posedge hf_osc_out or negedge hf_osc_enable ) begin
    if(~hf_osc_enable) begin
        hf_clk_out_pre <= 0;
        hf_div_count   <= 0;
    end else begin
        if ( ~hf_using_raw_clock & ( hf_clk_out_pre | hf_output_enable_synched )) begin
            hf_clk_out_pre  <= (hf_div_count == 3'b11) ? ~hf_clk_out_pre   : hf_clk_out_pre   ;
            hf_div_count    <= (hf_div_count == 3'b11) ? f_hf_preload(hf_clk_div) : hf_div_count + 1 ;
        end else begin
            hf_clk_out_pre  <= 0;
            hf_div_count    <= 0;
        end
    end
end

// raw hf clockgate
// using an AND based gate, opens and closes on negedge
reg hf_clkgate ;
always @ (negedge hf_osc_out or negedge hf_osc_enable ) begin
    if(~hf_osc_enable) begin
        hf_clkgate <= 0 ;
    end else begin
        hf_clkgate <= ( hf_output_enable_synched & hf_using_raw_clock ) ;
    end
end
wire hf_clk_gated = hf_osc_out & hf_clkgate ;

//Power On Control

assign ref_on    = hf_osc_enable | lf_osc_enable | iledir_source_enable;
assign hf_on     = hf_osc_enable;
assign lf_on     = lf_osc_enable;
assign iledir_on = iledir_source_enable;

//Clock output gating

// assign hf_clk_out = hf_output_enable & hf_clk_out_pre; 
// assign lf_clk_out = lf_output_enable & lf_clk_out_pre; 

//
// Generate blocks - START ---------------------------------------------
//
genvar i;
// HF ripple count and good flag
//
reg  [HF_DIV_STRT_CNT-1 :0] hf_clk_ripple ;
wire [HF_DIV_STRT_CNT   :0] hf_clk_div_wires = { hf_clk_ripple, hf_osc_out } ;
reg hf_clk_good ;

generate
    for (i=0;i<HF_DIV_STRT_CNT;i=i+1) begin : hf_ripple
        always @( negedge hf_clk_div_wires[i] or negedge hf_osc_enable ) begin
            if (~hf_osc_enable ) hf_clk_ripple[i] <= 0 ; 
            else hf_clk_ripple[i] <= ~ hf_clk_ripple[i] ; // toggle
        end
    end
endgenerate

always @( posedge hf_clk_div_wires[HF_DIV_STRT_CNT] or negedge hf_osc_enable ) begin
    if (~hf_osc_enable ) hf_clk_good <= 0 ; 
    else hf_clk_good <= 1 ;
end
// End of HF ripple count

// LF ripple count and good flag
//
reg  [LF_DIV_STRT_CNT-1 :0] lf_clk_ripple ;
wire [LF_DIV_STRT_CNT   :0] lf_clk_div_wires = { lf_clk_ripple, lf_osc_out } ;
reg lf_clk_good ;

generate
    for (i=0;i<LF_DIV_STRT_CNT;i=i+1) begin : lf_ripple
        always @( negedge lf_clk_div_wires[i] or negedge lf_osc_enable ) begin
            if (~lf_osc_enable ) lf_clk_ripple[i] <= 0 ; 
            else lf_clk_ripple[i] <= ~ lf_clk_ripple[i] ; // toggle
        end
    end
endgenerate

always @( posedge lf_clk_div_wires[LF_DIV_STRT_CNT] or negedge lf_osc_enable ) begin
    if (~lf_osc_enable ) lf_clk_good <= 0 ; 
    else lf_clk_good <= 1 ;
end
// End of LF ripple count

//
// Generate blocks - END ---------------------------------------------
//

// Synchronized enable for hf clocks 
always @(posedge hf_osc_out or negedge hf_osc_enable ) begin 
    if (~hf_osc_enable ) begin
        hf_output_enable_rank_1 <= 0;
        hf_output_enable_synched <= 0;
    end else begin
        hf_output_enable_rank_1 <= hf_clk_good & hf_output_enable ;
        hf_output_enable_synched <= hf_output_enable_rank_1 ;
    end
end

// Synchronized enable for lf clocks 
always @(posedge lf_osc_out or negedge lf_osc_enable ) begin
    if (~lf_osc_enable ) begin
        lf_output_enable_rank_1 <= 0;
        lf_output_enable_synched <= 0;
    end else begin
        lf_output_enable_rank_1 <= lf_clk_good & lf_output_enable ;
        lf_output_enable_synched <= lf_output_enable_rank_1 ;
    end
end

// combine the clocks and buffer
wire hf_clk_out_unbuffered = hf_clk_out_pre | hf_clk_gated ; 
wire lf_clk_out_unbuffered = lf_clk_out_pre; 
// Add specific drive cells BUFX16
`ifdef SYNTHESIS
    // Buffer type set with a define along with params at top of file
    `HF_CLK_BUFFER_TYPE u_hf_clkbuf (.X(hf_clk_out),.A(hf_clk_out_unbuffered) );
    `LF_CLK_BUFFER_TYPE u_lf_clkbuf (.X(lf_clk_out),.A(lf_clk_out_unbuffered) );
    // synopsys dc_tcl_script_begin
    // set_dont_touch u_hf_clkbuf
    // set_dont_touch [get_nets hf_clk_out]
    // set_dont_touch u_lf_clkbuf
    // set_dont_touch [get_nets lf_clk_out]
    // synopsys dc_tcl_script_end
`else
    buf (hf_clk_out,hf_clk_out_unbuffered);
    buf (lf_clk_out,lf_clk_out_unbuffered);
`endif

endmodule

// HDL file - umc40lp_ams, thunder_ams_analog, functional.

//Verilog HDL for "umc40lp_ams", "thunder_ams_analog" "functional"


module thunder_ams_analog( hf_osc_out, iledir_out, lf_osc_out, vgnda, vsupa,
hf_on, hf_trim, iledir_on, iledir_trim, lf_on, lf_trim, ref_on, hf_therm_trim, lf_therm_trim, hf_trim_msb, lf_trim_msb );

  output hf_osc_out;
  input ref_on;
  input  [3:0] lf_trim;
  input  [14:0] lf_therm_trim;
  input  lf_trim_msb;
  input iledir_on;
  input  [3:0] hf_trim;
  input  [14:0] hf_therm_trim;
  input  hf_trim_msb;
  output lf_osc_out;
  output iledir_out;
  inout vsupa;
  input lf_on;
  input hf_on;
  inout vgnda;
  input  [7:0] iledir_trim;


parameter real lf_base=3125;//6.25us (div16) for 160khz tt
parameter real hf_base=10;  //20ns

reg lf_osc_out=1'b0;
reg hf_osc_out=1'b0;

real fast_delay=10;  //20ns
real slow_delay=3125; //6.25us (div16) for 160khz tt
real iled_val=40; //40u default
real lf_lsb = 12.5; //0.2%
real hf_lsb = 0.04; //0.2%

real max_fast_delay=26;
real max_slow_delay=7812;

wire [8:0] effective_lf_trim;
wire [8:0] effective_hf_trim;

reg [3:0] lf_therm_bin;
reg [3:0] hf_therm_bin;

wire [8:0] combined_lf_trim;
wire [8:0] combined_hf_trim;


assign combined_lf_trim ={lf_trim_msb,lf_therm_bin,lf_trim[3:0]};
assign combined_hf_trim ={hf_trim_msb,hf_therm_bin,hf_trim[3:0]};


assign effective_lf_trim=combined_lf_trim;
assign effective_hf_trim=combined_hf_trim;



initial 
    begin
        lf_osc_out=0;
        hf_osc_out=0;
    end

//Therm2bin for therm_trims
//lf

always @(*)
    begin
        case(lf_therm_trim)
            15'h0000: lf_therm_bin=4'h0;
            15'h0001: lf_therm_bin=4'h1; 
            15'h0003: lf_therm_bin=4'h2; 
            15'h0007: lf_therm_bin=4'h3; 
            15'h000f: lf_therm_bin=4'h4; 
            15'h001f: lf_therm_bin=4'h5; 
            15'h003f: lf_therm_bin=4'h6; 
            15'h007f: lf_therm_bin=4'h7; 
            15'h00ff: lf_therm_bin=4'h8; 
            15'h01ff: lf_therm_bin=4'h9; 
            15'h03ff: lf_therm_bin=4'ha; 
            15'h07ff: lf_therm_bin=4'hb; 
            15'h0fff: lf_therm_bin=4'hc; 
            15'h1fff: lf_therm_bin=4'hd; 
            15'h3fff: lf_therm_bin=4'he; 
            15'h7fff: lf_therm_bin=4'hf; 
            default: lf_therm_bin=4'h0;
       endcase
    end
//hf
always @(*)
    begin
        case(hf_therm_trim)
            15'h0000: hf_therm_bin=4'h0;
            15'h0001: hf_therm_bin=4'h1; 
            15'h0003: hf_therm_bin=4'h2; 
            15'h0007: hf_therm_bin=4'h3; 
            15'h000f: hf_therm_bin=4'h4; 
            15'h001f: hf_therm_bin=4'h5; 
            15'h003f: hf_therm_bin=4'h6; 
            15'h007f: hf_therm_bin=4'h7; 
            15'h00ff: hf_therm_bin=4'h8; 
            15'h01ff: hf_therm_bin=4'h9; 
            15'h03ff: hf_therm_bin=4'ha; 
            15'h07ff: hf_therm_bin=4'hb; 
            15'h0fff: hf_therm_bin=4'hc; 
            15'h1fff: hf_therm_bin=4'hd; 
            15'h3fff: hf_therm_bin=4'he; 
            15'h7fff: hf_therm_bin=4'hf; 
            default: hf_therm_bin='h0;
       endcase
    end




always @(*)
    begin
        //osc delay based on trim 
        slow_delay = max_slow_delay - effective_lf_trim*lf_lsb;    
        fast_delay = max_fast_delay - effective_hf_trim*hf_lsb;    
    end

//LF osc
always #slow_delay lf_osc_out = !lf_osc_out && lf_on && ref_on;

//LF osc
always #fast_delay hf_osc_out = !hf_osc_out && hf_on && ref_on;

//Iledir No rnm, so no trim checks
assign iledir_out = (iledir_on && ref_on) ? 1'b0: 1'bz;

endmodule

// End HDL models

// Library - umc40lp_ams, Cell - thunder_ams, View - schematic
// LAST TIME SAVED: Jan  8 09:58:32 2014
// NETLIST TIME: Jan 13 15:18:46 2014
`timescale 1ns / 10ps 

module thunder_ams ( hf_clk_out, iledir_out, lf_clk_out, vgnda, vsupa,
hf_clk_div, hf_fabric_enable, hf_osc_enable, hf_output_enable,
hf_trim_fabric, hf_trim_nv, iledir_fabric_enable, iledir_source_enable,
iledir_trim_fabric, iledir_trim_nv, lf_fabric_enable, lf_osc_enable,
lf_output_enable, lf_trim_fabric, lf_trim_nv, VCC, VSS );

output  hf_clk_out, iledir_out, lf_clk_out;

inout  vgnda, vsupa;
inout  VCC, VSS;

input  hf_fabric_enable, hf_osc_enable, hf_output_enable, iledir_fabric_enable, iledir_source_enable, lf_fabric_enable, lf_osc_enable, lf_output_enable;

input [9:0]  lf_trim_nv;
input [1:0]  hf_clk_div;
input [9:0]  iledir_trim_fabric;
input [9:0]  hf_trim_fabric;
input [9:0]  hf_trim_nv;
input [9:0]  lf_trim_fabric;
input [9:0]  iledir_trim_nv;
supply1 vcc_;
supply0 vss_;

// Buses in the design

wire  [7:0]  iledir_trim;

wire  [3:0]  hf_trim;

wire  [14:0]  hf_therm_trim;

wire  [14:0]  lf_therm_trim;

wire  [3:0]  lf_trim;

// List of primary aliased buses



NCAP_25_LP  C1 ( .MINUS(vss_), .PLUS(vcc_));
NCAP_25_LP  C0 ( .MINUS(vgnda), .PLUS(vsupa));
thunder_ams_analog ana ( .hf_trim_msb(hf_trim_msb), .iledir_trim(iledir_trim[7:0]), .lf_trim_msb(lf_trim_msb), .lf_therm_trim(lf_therm_trim[14:0]), .lf_trim(lf_trim[3:0]), .hf_therm_trim(hf_therm_trim[14:0]), .hf_trim(hf_trim[3:0]), .vgnda(vgnda), .vsupa(vsupa), .hf_osc_out(hf_osc_out), .iledir_out(iledir_out), .lf_osc_out(lf_osc_out), .hf_on(hf_on), .iledir_on(iledir_on), .lf_on(lf_on), .ref_on(ref_on));
thunder_ams_digital dig ( .iledir_source_enable(iledir_source_enable), .lf_therm_trim(lf_therm_trim[14:0]), .lf_trim_msb(lf_trim_msb), .hf_therm_trim(hf_therm_trim[14:0]), .hf_trim_msb(hf_trim_msb), .lf_trim(lf_trim[3:0]), .iledir_trim(iledir_trim[7:0]), .hf_trim(hf_trim[3:0]), .hf_clk_div(hf_clk_div[1:0]), .lf_osc_enable(lf_osc_enable), .hf_osc_out(hf_osc_out), .lf_osc_out(lf_osc_out), .ref_on(ref_on), .iledir_on(iledir_on), .lf_on(lf_on), .hf_on(hf_on), .hf_clk_out(hf_clk_out), .lf_clk_out(lf_clk_out), .hf_fabric_enable(hf_fabric_enable), .hf_osc_enable(hf_osc_enable), .hf_output_enable(hf_output_enable), .hf_trim_fabric(hf_trim_fabric[9:0]), .hf_trim_nv(hf_trim_nv[9:0]), .iledir_fabric_enable(iledir_fabric_enable), .iledir_trim_fabric(iledir_trim_fabric[9:0]), .iledir_trim_nv(iledir_trim_nv[9:0]), .lf_fabric_enable(lf_fabric_enable), .lf_output_enable(lf_output_enable), .lf_trim_fabric(lf_trim_fabric[9:0]), .lf_trim_nv(lf_trim_nv[9:0]));

endmodule
