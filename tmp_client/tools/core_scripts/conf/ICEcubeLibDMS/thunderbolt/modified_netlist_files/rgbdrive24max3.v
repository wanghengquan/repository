// Verilog netlist of
// "rgbdrive24max3"

// HDL models

// HDL file - umc40lp_ledio, rgb_ledio, functional.

//Verilog HDL for "umc40lp_ledio", "rgb_ledio" "functional"

`timescale 1ns / 10ps

module rgb_ledio ( RGB_PAD, cbit_rgb, nref, rgb_pwm, vccio, vref_in, vssio, poc );

input vref_in;
input vccio;
input poc;
input nref;
input vssio;
inout RGB_PAD;
input  [5:0] cbit_rgb;
input rgb_pwm;

wire [5:0] cbit_rgb_en;
reg RGB_PAD_out;

assign cbit_rgb_en[5] = cbit_rgb[5] & rgb_pwm;
assign cbit_rgb_en[4] = cbit_rgb[4] & rgb_pwm;
assign cbit_rgb_en[3] = cbit_rgb[3] & rgb_pwm;
assign cbit_rgb_en[2] = cbit_rgb[2] & rgb_pwm;
assign cbit_rgb_en[1] = cbit_rgb[1] & rgb_pwm;
assign cbit_rgb_en[0] = cbit_rgb[0] & rgb_pwm;

always @ (cbit_rgb_en or nref or poc or vref_in)
begin
	if (!nref | poc)
	RGB_PAD_out = 1'bz;
	else 
		begin
		casez (cbit_rgb_en)
		6'b1?????: RGB_PAD_out = vref_in;
		6'b?1????: RGB_PAD_out = vref_in;
		6'b??1???: RGB_PAD_out = vref_in;
		6'b???1??: RGB_PAD_out = vref_in;
		6'b????1?: RGB_PAD_out = vref_in;
		6'b?????1: RGB_PAD_out = vref_in;
		6'b000000: RGB_PAD_out = 1'bz;
		endcase
		end
end

assign RGB_PAD = RGB_PAD_out;
 
endmodule

// HDL file - umc40lp_ledio, thunder_rgb_bias, functional.

//Verilog HDL for "umc40lp_ledio", "thunder_rgb_bias" "functional"


module thunder_rgb_bias ( rgb_nref, rgb_vref_in, rgbled_en, vccio, cbit_rgb_en,
poc, vss_rgb, i200uref );

input vccio;
input poc;
input cbit_rgb_en;
input rgbled_en;
input i200uref;
input vss_rgb;
output rgb_vref_in;
output rgb_nref;

wire rgb_on = rgbled_en & cbit_rgb_en & i200uref;

reg rgb_nref, rgb_vref_in;

always @ (rgb_on)
begin
	if (rgb_on)
		begin
		rgb_nref = 1'b1;
		rgb_vref_in = 1'b1;
		end
	else 
		begin
		rgb_nref = 1'b0;
		rgb_vref_in = 1'b0;
		end 
end

endmodule

// HDL file - umc40lp_ledio, SUMB_bscan_HX8mA_sp, functional.


//Verilog HDL for "umc40lp_ledio", "SUMB_bscan_HX8mA_sp" "functional"

/*
module SUMB_bscan_HX8mA_sp ( DI, PAD, DO, REN, IE, VDDIO, OEN, PGATE, nor_in,
BSEN, POC );

  input DO;
  input OEN;
  output DI;
  input nor_in;
  input POC;
  input REN;
  input BSEN;
  input VDDIO;
  inout PAD;
  output PGATE;
  input IE;
  
  parameter PullTime = 100000 ;
 
  reg lastPAD, pull;
  //bufif1 (weak0,weak1) (C_buf, 1'b1, pull); //yn
  not    (RE, REN);
  //bufif0 (PAD, DO, OEN); //disable pullup here //yn
  nor (DO_OEN, DO, OEN); //yn
  bufif1 (PAD, 1'b0, DO_OEN); //yn
  pmos   (C_buf, PAD, 1'b0); //act as poly resistor

  buf    (PGATE, C_buf);
  or     (IE_BSEN, IE, BSEN);
  and     (C_buf1, C_buf, IE_BSEN);
  or     (DI, C_buf1, nor_in);
 
  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (DO => PAD)=(0, 0);
    (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => DI)=(0, 0);

    (PAD => PGATE)=(0, 0);
    (nor_in => DI)=(0, 0);
    (IE => DI)=(0, 0, 0, 0, 0, 0);
  endspecify

endmodule
// End HDL models
*/
// Library - umc40lp_ledio, Cell - rgb24max3, View - schematic
// LAST TIME SAVED: Dec 11 17:04:54 2013
// NETLIST TIME: Jan  6 16:23:10 2014
`timescale 1ns / 10ps 

module rgb24max3 ( rgb0, rgb1, rgb2, cbit_rgb0[5:0], cbit_rgb1[5:0], cbit_rgb2[5:0], cbit_rgb_en, i200uref, poc, rgb_pwm[2], rgb_pwm[1], rgb_pwm[0], rgbled_en, vccio );
inout  rgb0, rgb1, rgb2;

input  cbit_rgb_en, i200uref, poc, rgbled_en, vccio;

input [5:0]  cbit_rgb0;
input [5:0]  cbit_rgb2;
input [5:0]  cbit_rgb1;
input [0:2]  rgb_pwm;

// List of primary aliased buses



thunder_rgb_bias RGB_BIAS ( .i200uref(i200uref), .vss_rgb(vss_), .poc(poc), .cbit_rgb_en(cbit_rgb_en), .rgb_nref(rgb_nref), .rgb_vref_in(rgb_vref), .rgbled_en(rgbled_en), .vccio(vccio));
rgb_ledio RGB0 ( .poc(poc), .RGB_PAD(rgb0), .cbit_rgb(cbit_rgb0[5:0]), .nref(rgb_nref), .rgb_pwm(rgb_pwm[0]), .vccio(vccio), .vref_in(rgb_vref), .vssio(vss_));
rgb_ledio RGB2 ( .poc(poc), .RGB_PAD(rgb2), .cbit_rgb(cbit_rgb2[5:0]), .nref(rgb_nref), .rgb_pwm(rgb_pwm[2]), .vccio(vccio), .vref_in(rgb_vref), .vssio(vss_));
rgb_ledio RGB1 ( .poc(poc), .RGB_PAD(rgb1), .cbit_rgb(cbit_rgb1[5:0]), .nref(rgb_nref), .rgb_pwm(rgb_pwm[1]), .vccio(vccio), .vref_in(rgb_vref), .vssio(vss_));

endmodule

// Library - umc40nm_io, Cell - SVSS_sbt_a, View - schematic
// LAST TIME SAVED: Sep 19 13:49:21 2012
// NETLIST TIME: Jan  6 16:23:10 2014
`timescale 1ns / 10ps 

module SVSS_sbt_a ( VDDIO );
input  VDDIO;


endmodule
// Library - umc40lp_ledio, Cell - rgbdrive24max3, View - schematic
// LAST TIME SAVED: Jan  3 16:26:55 2014
// NETLIST TIME: Jan  6 16:23:10 2014
`timescale 1ns / 10ps 

module rgbdrive24max3 ( RGB0_DI, RGB1_DI, RGB2_DI, rgb0, rgb1, rgb2, vccio, BSEN, RGB0_DO, RGB0_IE, RGB0_OEN, RGB1_DO, RGB1_IE, RGB1_OEN, RGB2_DO, RGB2_IE, RGB2_OEN, cbit_rgb0, cbit_rgb1, cbit_rgb2, cbit_rgb_en, i200uref, nor_in, poc, rgb_pwm, rgbled_en );

output  RGB0_DI, RGB1_DI, RGB2_DI;

inout  rgb0, rgb1, rgb2, vccio;

input  BSEN, RGB0_DO, RGB0_IE, RGB0_OEN, RGB1_DO, RGB1_IE, RGB1_OEN, RGB2_DO, RGB2_IE, RGB2_OEN, cbit_rgb_en, i200uref, nor_in, poc, rgbled_en;

input [5:0]  cbit_rgb1;
input [5:0]  cbit_rgb2;
input [2:0]  rgb_pwm;
input [5:0]  cbit_rgb0;

// List of primary aliased buses



SUMB_bscan_HX8mA_sp I64 ( .POC(poc), .BSEN(BSEN), .OEN(RGB2_OEN), .IE(RGB2_IE), .REN(BSEN), .DO(RGB2_DO), .PAD(rgb2), .DI(RGB2_DI), .VDDIO(vccio), .nor_in(nor_in), .PGATE(net038));
SUMB_bscan_HX8mA_sp I59 ( .POC(poc), .BSEN(BSEN), .OEN(RGB0_OEN), .IE(RGB0_IE), .REN(BSEN), .DO(RGB0_DO), .PAD(rgb0), .DI(RGB0_DI), .VDDIO(vccio), .nor_in(nor_in), .PGATE(net039));
SUMB_bscan_HX8mA_sp I17 ( .POC(poc), .BSEN(BSEN), .OEN(RGB1_OEN), .IE(RGB1_IE), .REN(BSEN), .DO(RGB1_DO), .PAD(rgb1), .DI(RGB1_DI), .VDDIO(vccio), .nor_in(nor_in), .PGATE(net63));
rgb24max3 I43 ( rgb0, rgb1, rgb2, cbit_rgb0[5:0], cbit_rgb1[5:0], cbit_rgb2[5:0], cbit_rgb_en, i200uref, poc, rgb_pwm[2], rgb_pwm[1], rgb_pwm[0], rgbled_en, vccio);
SVSS_sbt_a I76 ( .VDDIO(vccio));

endmodule
