`timescale 1ns / 1ns

module N_11_LPLVT (D,S,G, B);
inout D;
input G,S, B;
nmos (D, S, G); // D S G
//nmos (S, D, ~G); // D S G
endmodule

module P_11_LPLVT (D,S,G,B);
inout D;
input B,G,S;
pmos (D, S, G); // D S G
//pmos (S, D, ~G); // S D G
endmodule

module DION_11_LPRVT (PLUS, MINUS);
inout PLUS, MINUS;
endmodule

module	ioin_mux_v2	(
						inmuxo,
						cbit[3],cbit[2],cbit[1],cbit[0],
						cbitb[3],cbitb[2],cbitb[1],cbitb[0],
						min,
						prog
						);

input	[7:0]	min;
input	[3:0]	cbit;
input	[3:0]	cbitb;
input			prog;

output			inmuxo;
reg				inmuxo;

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$prog$inmuxo= 1.0,
      tphl$prog$inmuxo= 1.0,
      tplh$min0$inmuxo= 1.0,
      tphl$min0$inmuxo= 1.0,
      tplh$min1$inmuxo= 1.0,
      tphl$min1$inmuxo= 1.0,
      tplh$min2$inmuxo= 1.0,
      tphl$min2$inmuxo= 1.0,
      tplh$min3$inmuxo= 1.0,
      tphl$min3$inmuxo= 1.0,
      tplh$min4$inmuxo= 1.0,
      tphl$min4$inmuxo= 1.0,
      tplh$min5$inmuxo= 1.0,
      tphl$min5$inmuxo= 1.0,
      tplh$min6$inmuxo= 1.0,
      tphl$min6$inmuxo= 1.0,
      tplh$min7$inmuxo= 1.0,
      tphl$min7$inmuxo= 1.0;
    // path delays
     (prog *> inmuxo) = (tplh$prog$inmuxo, tphl$prog$inmuxo);
     (min[0] *> inmuxo) = (tplh$min0$inmuxo, tphl$min0$inmuxo);
     (min[1] *> inmuxo) = (tplh$min1$inmuxo, tphl$min1$inmuxo);
     (min[2] *> inmuxo) = (tplh$min2$inmuxo, tphl$min2$inmuxo);
     (min[3] *> inmuxo) = (tplh$min3$inmuxo, tphl$min3$inmuxo);
     (min[4] *> inmuxo) = (tplh$min4$inmuxo, tphl$min4$inmuxo);
     (min[5] *> inmuxo) = (tplh$min5$inmuxo, tphl$min5$inmuxo);
     (min[6] *> inmuxo) = (tplh$min6$inmuxo, tphl$min6$inmuxo);
     (min[7] *> inmuxo) = (tplh$min7$inmuxo, tphl$min7$inmuxo);
   endspecify
`endif

always @ (prog or min or cbit or cbitb)
begin
	if	(cbitb!== ~cbit)
		inmuxo	=	1'bx;	
	else if (cbitb[3])
		inmuxo	=	1'b0;
	else if (prog)
		inmuxo	=	1'b0;
	else case (cbit[2:0])
	   3'h0 : inmuxo	=	min[0];
	   3'h1 : inmuxo	=	min[1];
	   3'h2 : inmuxo	=	min[2];
	   3'h3 : inmuxo	=	min[3];
	   3'h4 : inmuxo	=	min[4];
	   3'h5 : inmuxo	=	min[5];
	   3'h6 : inmuxo	=	min[6];
	   3'h7 : inmuxo	=	min[7];
           default : inmuxo     =       1'bx;
           endcase
end		


endmodule

module	ioin_mux_v3	(
						inmuxo,
						cbit[3],cbit[2],cbit[1],cbit[0],
						cbitb[3],cbitb[2],cbitb[1],cbitb[0],
						min,
						prog
						);

input	[7:0]	min;
input	[3:0]	cbit;
input	[3:0]	cbitb;
input			prog;

output			inmuxo;
reg				inmuxo;

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$prog$inmuxo= 1.0,
      tphl$prog$inmuxo= 1.0,
      tplh$min0$inmuxo= 1.0,
      tphl$min0$inmuxo= 1.0,
      tplh$min1$inmuxo= 1.0,
      tphl$min1$inmuxo= 1.0,
      tplh$min2$inmuxo= 1.0,
      tphl$min2$inmuxo= 1.0,
      tplh$min3$inmuxo= 1.0,
      tphl$min3$inmuxo= 1.0,
      tplh$min4$inmuxo= 1.0,
      tphl$min4$inmuxo= 1.0,
      tplh$min5$inmuxo= 1.0,
      tphl$min5$inmuxo= 1.0,
      tplh$min6$inmuxo= 1.0,
      tphl$min6$inmuxo= 1.0,
      tplh$min7$inmuxo= 1.0,
      tphl$min7$inmuxo= 1.0;
    // path delays
     (prog *> inmuxo) = (tplh$prog$inmuxo, tphl$prog$inmuxo);
     (min[0] *> inmuxo) = (tplh$min0$inmuxo, tphl$min0$inmuxo);
     (min[1] *> inmuxo) = (tplh$min1$inmuxo, tphl$min1$inmuxo);
     (min[2] *> inmuxo) = (tplh$min2$inmuxo, tphl$min2$inmuxo);
     (min[3] *> inmuxo) = (tplh$min3$inmuxo, tphl$min3$inmuxo);
     (min[4] *> inmuxo) = (tplh$min4$inmuxo, tphl$min4$inmuxo);
     (min[5] *> inmuxo) = (tplh$min5$inmuxo, tphl$min5$inmuxo);
     (min[6] *> inmuxo) = (tplh$min6$inmuxo, tphl$min6$inmuxo);
     (min[7] *> inmuxo) = (tplh$min7$inmuxo, tphl$min7$inmuxo);
   endspecify
`endif

always @ (prog or min or cbit or cbitb)
begin
	if	(cbitb!== ~cbit)
		inmuxo	=	1'bx;	
	else if (cbitb[3])
		inmuxo	=	1'b0;
	else if (prog)
		inmuxo	=	1'b0;
	else case (cbit[2:0])
	   3'h0 : inmuxo	=	min[0];
	   3'h1 : inmuxo	=	min[1];
	   3'h2 : inmuxo	=	min[2];
	   3'h3 : inmuxo	=	min[3];
	   3'h4 : inmuxo	=	min[4];
	   3'h5 : inmuxo	=	min[5];
	   3'h6 : inmuxo	=	min[6];
	   3'h7 : inmuxo	=	min[7];
           default : inmuxo     =       1'bx;
           endcase
end		


endmodule

module nand4_25 (Y, A, B, C, D, G, Gb, P, Pb);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input G;
    input Gb;
    input P;
    input Pb;

assign Y = ~(A & B & C & D);

endmodule

module nand3_25 (Y, A, B, C, P, Pb, G, Gb);
    output Y;
    input A;
    input B;
    input C;
    input P, Pb, G, Gb;

	assign Y = ~(A & B & C);

endmodule

module nand2_25 (Y, A, B, P, Pb, G, Gb);
    output Y;
    input A;
    input B;
    inout P, Pb, G, Gb;

	assign Y = ~(A & B);

endmodule

module P_25_LP(D,S,G,B);
inout D;
input B,G,S;
pmos (D, S, G); // D S G for ltile
endmodule

module inv_25 ( OUT, G, Gb, IN, P, Pb );
    output OUT;
    input  G, Gb, IN, P, Pb;

	assign OUT = !IN;

endmodule

