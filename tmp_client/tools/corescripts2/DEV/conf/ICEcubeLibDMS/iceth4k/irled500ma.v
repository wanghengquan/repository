// Verilog netlist of
// "irled500ma"

// HDL models

// HDL file - umc40lp_ledio, ir_ledio, functional.

//Verilog HDL for "umc40lp_ledio", "ir_ledio" "functional"

`timescale 1ns / 10ps

module ir_ledio ( IR_PAD, cbit_ir, ir_pwm, nref, vccio, vref_in, vssio, poc);

input vref_in;
input vccio;
input poc;
input nref;
inout IR_PAD;
input vssio;
input ir_pwm;
input  [9:0] cbit_ir;

wire [9:0] cbit_ir_en;
reg IR_PAD_out;

assign cbit_ir_en[9] = cbit_ir[9] & ir_pwm;
assign cbit_ir_en[8] = cbit_ir[8] & ir_pwm;
assign cbit_ir_en[7] = cbit_ir[7] & ir_pwm;
assign cbit_ir_en[6] = cbit_ir[6] & ir_pwm;
assign cbit_ir_en[5] = cbit_ir[5] & ir_pwm;
assign cbit_ir_en[4] = cbit_ir[4] & ir_pwm;
assign cbit_ir_en[3] = cbit_ir[3] & ir_pwm;
assign cbit_ir_en[2] = cbit_ir[2] & ir_pwm;
assign cbit_ir_en[1] = cbit_ir[1] & ir_pwm;
assign cbit_ir_en[0] = cbit_ir[0] & ir_pwm;

always @ (cbit_ir_en or nref or poc or vref_in)
begin
	if (!nref | poc)
	IR_PAD_out = 1'bz;
	else 
		begin
		casez (cbit_ir_en)
		10'b1?????????: IR_PAD_out = vref_in;
		10'b?1????????: IR_PAD_out = vref_in;
		10'b??1???????: IR_PAD_out = vref_in;
		10'b???1??????: IR_PAD_out = vref_in;
		10'b????1?????: IR_PAD_out = vref_in;
		10'b?????1????: IR_PAD_out = vref_in;
		10'b??????1???: IR_PAD_out = vref_in;
		10'b???????1??: IR_PAD_out = vref_in;
		10'b????????1?: IR_PAD_out = vref_in;
		10'b?????????1: IR_PAD_out = vref_in;
		10'b0000000000: IR_PAD_out = 1'bz;
		endcase
		end
end

assign IR_PAD = IR_PAD_out;

endmodule


// HDL file - umc40lp_ledio, esd_btbdiodes, functional.

//Verilog HDL for "umc40lp_ledio", "esd_btbdiodes" "functional"


module esd_btbdiodes ( vssx );

  input vssx;
endmodule

// HDL file - umc40lp_ledio, thunder_ir_bias, functional.

//Verilog HDL for "umc40lp_ledio", "thunder_ir_bias" "functional"


module thunder_ir_bias ( ir_nref, ir_vref_in, i200uref, irled_en, rgbled_en,
vccio, cbit_ir_en, cbit_rgb_en, icc40u, poc, vssio_ir );

input vccio;
input poc;
input icc40u;
input cbit_rgb_en;
input rgbled_en;
output ir_vref_in;
output i200uref;
input irled_en;
input cbit_ir_en;
input vssio_ir;
output ir_nref;

wire ir_on = !icc40u & irled_en & cbit_ir_en;

reg ir_nref, ir_vref_in, i200uref;
  
always @ (ir_on)
begin
if (ir_on)
	begin
	ir_nref = 1'b1;
	ir_vref_in = 1'b1;
	i200uref = 1'b1;
	end
else 
	begin
	ir_nref = 1'b0;
	ir_vref_in = 1'b0;
	i200uref = 1'bz;
	end
end
  
endmodule
// End HDL models

// Library - umc40lp_ledio, Cell - irled500ma, View - schematic
// LAST TIME SAVED: Jan  3 17:18:45 2014
// NETLIST TIME: Jan  6 16:34:35 2014
`timescale 1ns / 10ps 

module irled500ma ( i200uref, drivergnd, ir_pad, vccio, cbit_ir, cbit_ir_en, cbit_rgb_en, icc40u, ir_pwm, irled_en, poc, rgbled_en );

output  i200uref;

inout  drivergnd, ir_pad, vccio;

input  cbit_ir_en, cbit_rgb_en, icc40u, ir_pwm, irled_en, poc, rgbled_en;

input [9:0]  cbit_ir;

// List of primary aliased buses



thunder_ir_bias BIAS ( .i200uref(i200uref), .vssio_ir(drivergnd), .poc(poc), .icc40u(icc40u), .cbit_rgb_en(cbit_rgb_en), .cbit_ir_en(cbit_ir_en), .ir_nref(ir_nref), .ir_vref_in(ir_vref), .irled_en(irled_en), .rgbled_en(rgbled_en), .vccio(vccio));
esd_btbdiodes I116 ( .vssx(drivergnd));
ir_ledio IR ( .poc(poc), .vssio(drivergnd), .vccio(vccio), .IR_PAD(ir_pad), .cbit_ir(cbit_ir[9:0]), .ir_pwm(ir_pwm), .nref(ir_nref), .vref_in(ir_vref));

endmodule
