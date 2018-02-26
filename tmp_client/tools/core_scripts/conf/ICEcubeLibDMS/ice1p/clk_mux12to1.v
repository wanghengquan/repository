`timescale 1ns / 100ps

module	clk_mux12to1	(
							clk,
							clkb,
							cbit,
							cbitb,
							cenb,
							min,
							prog
							);

input	[11:0]	min;
input	[5:0]	cbit;
input	[5:0]	cbitb;
input			cenb;
input			prog;

output			clk;
output			clkb;


assign	clkb=~clk;

reg		sel_temp;

always	@ (min, cbit, cbitb, cenb, prog)
begin
	if	(cbit!=~cbitb)
		sel_temp	=	1'bx;
	else
	if	(cbit[5]===1'b1)
		case	(cbit[3:0])
		4'b0000	:	sel_temp = min[0];
		4'b0001	:	sel_temp = min[1];
		4'b0010	:	sel_temp = min[2];
		4'b0011	:	sel_temp = min[3];
		4'b0100	:	sel_temp = min[4];
		4'b0101	:	sel_temp = min[5];
		4'b0110	:	sel_temp = min[6];
		4'b0111	:	sel_temp = min[7];
		4'b1000	:	sel_temp = min[8];
		4'b1001	:	sel_temp = min[9];
		4'b1010	:	sel_temp = min[10];
		4'b1011	:	sel_temp = min[11];
		default	:	sel_temp = 1'bx;
		endcase
	else
	if	(cbit[5]===1'b0)
		case	(cbit[3:0])
		4'b0000	:	sel_temp = ~min[0];
		4'b0001	:	sel_temp = ~min[1];
		4'b0010	:	sel_temp = ~min[2];
		4'b0011	:	sel_temp = ~min[3];
		4'b0100	:	sel_temp = ~min[4];
		4'b0101	:	sel_temp = ~min[5];
		4'b0110	:	sel_temp = ~min[6];
		4'b0111	:	sel_temp = ~min[7];
		4'b1000	:	sel_temp = ~min[8];
		4'b1001	:	sel_temp = ~min[9];
		4'b1010	:	sel_temp = ~min[10];
		4'b1011	:	sel_temp = ~min[11];
		default	:	sel_temp = 1'bx;
		endcase
	else
		sel_temp = 1'bx;	
end

reg ceb = 0;
wire ceb_wire;
assign ceb_wire = prog || cbitb[4] || cenb;
always @(sel_temp or ceb_wire)
	if (sel_temp)
		ceb = ceb_wire;
assign clk = ~(sel_temp || ceb);

// assign	clk	=	~(sel_temp || prog || cbitb[4] || cenb);

endmodule

module	clk_mux12to1_icc	(
							clk,
							clkb,
							cbit,
							cbitb,
							cenb,
							min,
							prog
							);

input	[11:0]	min;
input	[5:0]	cbit;
input	[5:0]	cbitb;
input			cenb;
input			prog;

output			clk;
output			clkb;


assign	clkb=~clk;

reg		sel_temp;

always	@ (min, cbit, cbitb, cenb, prog)
begin
	if	(cbit!=~cbitb)
		sel_temp	=	1'bx;
	else
	if	(cbit[5]===1'b1)
		case	(cbit[3:0])
		4'b0000	:	sel_temp = min[0];
		4'b0001	:	sel_temp = min[1];
		4'b0010	:	sel_temp = min[2];
		4'b0011	:	sel_temp = min[3];
		4'b0100	:	sel_temp = min[4];
		4'b0101	:	sel_temp = min[5];
		4'b0110	:	sel_temp = min[6];
		4'b0111	:	sel_temp = min[7];
		4'b1000	:	sel_temp = min[8];
		4'b1001	:	sel_temp = min[9];
		4'b1010	:	sel_temp = min[10];
		4'b1011	:	sel_temp = min[11];
		default	:	sel_temp = 1'bx;
		endcase
	else
	if	(cbit[5]===1'b0)
		case	(cbit[3:0])
		4'b0000	:	sel_temp = ~min[0];
		4'b0001	:	sel_temp = ~min[1];
		4'b0010	:	sel_temp = ~min[2];
		4'b0011	:	sel_temp = ~min[3];
		4'b0100	:	sel_temp = ~min[4];
		4'b0101	:	sel_temp = ~min[5];
		4'b0110	:	sel_temp = ~min[6];
		4'b0111	:	sel_temp = ~min[7];
		4'b1000	:	sel_temp = ~min[8];
		4'b1001	:	sel_temp = ~min[9];
		4'b1010	:	sel_temp = ~min[10];
		4'b1011	:	sel_temp = ~min[11];
		default	:	sel_temp = 1'bx;
		endcase
	else
		sel_temp = 1'bx;	
end

reg ceb = 0;
wire ceb_wire;
assign ceb_wire = prog || cbitb[4] || cenb;
always @(sel_temp or ceb_wire)
	if (sel_temp)
		ceb = ceb_wire;
assign clk = ~(sel_temp || ceb);

// assign	clk	=	~(sel_temp || prog || cbitb[4] || cenb);

endmodule
