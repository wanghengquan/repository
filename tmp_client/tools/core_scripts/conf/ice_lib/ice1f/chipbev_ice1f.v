//************************************************
//   file name: chipbev_ice8.v
//Title:    ioin_mux_ref
//Design:   ioin_mux_ref.v
//Author:   Simon
//Company:  SiliconBlue Technologies, Inc.
//revision: July 15, 2007
//************************************************
module	ioin_mux	(
						inmuxo,
						cbit,
						cbitb,
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

module pch_hvt(D,S,G,B);
inout S;
input B,G,D;

pmos (D, S, G); // D S G
//pmos (S, D, ~G); // S D G
pulldown(S);

endmodule

module pch(D,S,G,B);
inout D;
input B,G,S;

pmos (D, S, G); // D S G
//pmos (S, D, ~G); // S D G
endmodule

module pch_25(D,S,G,B);
inout D;
input B,G,S;

pmos (D, S, G); // D S G
//pmos (S, D, ~G); // S D G
endmodule

module nch_hvt(D,S,G,B);
inout D;
input B,G,S;

nmos (D, S, G); // D S G
//nmos (S, D, ~G); // D S G
endmodule

module nch_25(D,S,G,B);
inout D;
input B,G,S;

nmos (D, S, G); // D S G
//nmos (S, D, ~G); // D S G
endmodule

module nch_na25(D,S,G,B);
inout D;
input B,G,S;

nmos (D, S, G); // D S G
//nmos (S, D, ~G); // D S G
endmodule

module nch(D,S,G,B);
inout D;
input B,G,S;

nmos (D, S, G); // D S G
//nmos (S, D, ~G); // D S G
endmodule

module rppolywo_m  (MINUS, PLUS, BULK);
inout MINUS, PLUS, BULK;
tran t1 (MINUS,PLUS);

endmodule

module rppolywo  (MINUS, PLUS, BULK);
inout MINUS, PLUS, BULK;
tran t1 (MINUS,PLUS);
endmodule`timescale 1ns / 1ns

module and2p_18 (y, a, b, bb);

    output y;
    input a;
    input b;
    input bb;



    reg y;
    always @ (a or b or bb)
    begin

    	if ((bb == 1'b1)&&(b == 1'b0))
		y = 1 'b0;
    	else if ((b == 1'b1)&&(bb == 1'b0))
		y = a;
	else if (bb == b)
		y = 1 'bz;

    end

endmodule
module and2p_18_g (y, a, b, bb, gnd_node);
    output y;
    input a;
    input b;
    input bb;
    input gnd_node;

reg y;
always @ (a or b or bb or gnd_node)
begin

    if ((bb == 1'b1)&&(b == 1'b0)&&(gnd_node == 0))
	    y = 1 'b0;
    else if ((b == 1'b1)&&(bb == 1'b0)&&(gnd_node == 0))
	    y = a;
    else if ((bb == b)&&(gnd_node == 0))
	y = 1 'bz;

end

endmodule
`timescale 1ns / 1ns

module and2p_25 (y, a, b, bb);

    output y;
    input a;
    input b;
    input bb;

    reg y;
    always @ (a or b or bb)
    begin

    	if ((bb == 1'b1)&&(b == 1'b0))
		y = 1 'b0;
    	else if ((b == 1'b1)&&(bb == 1'b0))
		y = a;
	else if (bb == b)
		y = 1 'bz;

    end

endmodule
module and2p_25_g (y, a, b, bb, gnd_node);
    output y;
    input a;
    input b;
    input bb;
    input gnd_node;

reg y;
always @ (a or b or bb or gnd_node)
begin

    if ((bb == 1'b1)&&(b == 1'b0)&&(gnd_node == 0))
	    y = 1 'b0;
    else if ((b == 1'b1)&&(bb == 1'b0)&&(gnd_node == 0))
	    y = a;
    else if ((bb == b)&&(gnd_node == 0))
	y = 1 'bz;

end

endmodule
`timescale 1ns / 1ns

module and2p_33 (y, a, b, bb);

    output y;
    input a;
    input b;
    input bb;


    reg y;
    always @ (a or b or bb)
    begin

    	if ((bb == 1'b1)&&(b == 1'b0))
		y = 1 'b0;
    	else if ((b == 1'b1)&&(bb == 1'b0))
		y = a;
	else if (bb == b)
		y = 1 'bz;

    end

endmodule
module and2p_33_g (y, a, b, bb, gnd_node);
    output y;
    input a;
    input b;
    input bb;
    input gnd_node;


reg y;
always @ (a or b or bb or gnd_node)
begin

    if ((bb == 1'b1)&&(b == 1'b0)&&(gnd_node == 0))
	    y = 1 'b0;
    else if ((b == 1'b1)&&(bb == 1'b0)&&(gnd_node == 0))
	    y = a;
    else if ((bb == b)&&(gnd_node == 0))
	y = 1 'bz;

end

endmodule
`timescale 1ns / 1ns

module and2p (y, a, b, bb);

    output y;
    input a;
    input b;
    input bb;


    reg y;
    always @ (a or b or bb)
    begin

    	if ((bb == 1'b1)&&(b == 1'b0))
		y = 1 'b0;
    	else if ((b == 1'b1)&&(bb == 1'b0))
		y = a;
	else if (bb == b)
		y = 1 'bz;

    end

endmodule
module and2p_g (y, a, b, bb, gnd_node);
    output y;
    input a;
    input b;
    input bb;
    input gnd_node;


reg y;
always @ (a or b or bb or gnd_node)
begin

    if ((bb == 1'b1)&&(b == 1'b0)&&(gnd_node == 0))
	    y = 1 'b0;
    else if ((b == 1'b1)&&(bb == 1'b0)&&(gnd_node == 0))
	    y = a;
    else if ((bb == b)&&(gnd_node == 0))
	y = 1 'bz;

end

endmodule
`timescale 1ns / 1ns

module and2p_hvt (y, a, b, bb);

    output y;
    input a;
    input b;
    input bb;


    reg y;
    always @ (a or b or bb)
    begin

    	if ((bb == 1'b1)&&(b == 1'b0))
		y = 1 'b0;
    	else if ((b == 1'b1)&&(bb == 1'b0))
		y = a;
	else if (bb == b)
		y = 1 'bz;

    end

endmodule
module and2p_hvt_g (y, a, b, bb, gnd_node);
    output y;
    input a;
    input b;
    input bb;
    input gnd_node;

reg y;
always @ (a or b or bb or gnd_node)
begin

    if ((bb == 1'b1)&&(b == 1'b0)&&(gnd_node == 0))
	    y = 1 'b0;
    else if ((b == 1'b1)&&(bb == 1'b0)&&(gnd_node == 0))
	    y = a;
    else if ((bb == b)&&(gnd_node == 0))
	y = 1 'bz;

end

endmodule
module anor21_18 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;
 

reg Y;
always @ (A or B or C )

Y = ~(C | (B*A));

endmodule
module anor21_18_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

assign Y = ~(C | (B*A));

endmodule
module anor21_25 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;
 

assign Y = ~(C | (B*A));

endmodule
module anor21_25_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

assign Y = ~(C | (B*A));

endmodule
module anor21_33 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;
 

assign Y = ~(C | (B*A));

endmodule
module anor21_33_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

initial
begin
	Y = 1;
end

reg Y;
always @ (A or B or C or gnd_node)

assign Y = ~(C | (B*A));

endmodule
module anor21 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;
 

reg Y;
always @ (A or B or C )

Y = ~(C | (B*A));

endmodule
module anor21_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

initial
begin
	Y = 1;
end

reg Y;
always @ (A or B or C or gnd_node)

assign Y = ~(C | (B*A));

endmodule
module anor21_hvt (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;
 

initial
begin
	Y = 1;
end

reg Y;
always @ (A or B or C )

assign Y = ~(C | (B*A));

endmodule
module anor21_hvt_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

initial
begin
	Y = 1;
end

reg Y;
always @ (A or B or C or gnd_node)

assign Y = ~(C | (B*A));

endmodule
`timescale 1ns / 1ns

module bus_keeper_33 (Y, A);
    output Y;
    input A;


reg Y;
always @ (A)
begin
if (A)
	Y=1'b0;
else 
	Y = 1'b1;
if (A == 1'bx)
	Y = 1'bx;
end

endmodule
`timescale 1ns / 1ns

module bus_keeper_hvt (Y, A);
    output Y;
    input A;


reg Y;
always @ (A)
begin
if (A)
	Y=1'b0;
else 
	Y = 1'b1;
if (A == 1'bx)
	Y = 1'bx;
end

endmodule
module capacitor (MINUS, PLUS);
    inout MINUS;
    inout PLUS;

endmodule
`timescale 1ns / 1ns

module exor2_18 (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = (A & !B) | (!A & B);


endmodule
module exor2_18_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;


	assign Y = (A & !B) | (!A & B);

endmodule
`timescale 1ns / 1ns

module exor2_25 (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = (A & !B) | (!A & B);


endmodule
module exor2_25_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;

	assign Y = (A & !B) | (!A & B);

endmodule
`timescale 1ns / 1ns

module exor2_33 (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = (A & !B) | (!A & B);


endmodule
module exor2_33_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;


	assign Y = (A & !B) | (!A & B);

endmodule
`timescale 1ns / 1ns

module exor2 (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = (A & !B) | (!A & B);


endmodule
module exor2_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;

reg Y;
always @ (A or B or gnd_node)


	assign Y = (A & !B) | (!A & B);

endmodule
`timescale 1ns / 1ns

module exor2_hvt (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = (A & !B) | (!A & B);


endmodule
module exor2_hvt_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;

	assign Y = (A & !B) | (!A & B);

endmodule
`timescale 1ns / 1ns

module inv_18 (Y, A);
    output Y;
    input A;

	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_18_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;

	assign Y = !A;

endmodule
`timescale 1ns / 1ns
/*
module inv_25 (Y, A);
    output Y;
    input A;
*/
module inv_25 ( OUT, G, Gb, IN, P, Pb );
output  OUT;

input  G, Gb, IN, P, Pb;

	assign OUT = !IN;

endmodule
`timescale 1ns / 1ns

module inv_25_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;

	assign Y = !A;

endmodule
module inv_25_hv (out, in, vhi);
    output out;
    input in;
    input vhi;

assign out = ~in;

endmodule
`timescale 1ns / 1ns

module inv_33 (Y, A);
    output Y;
    input A;

	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_33_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;

	assign Y = !A;

endmodule
module inv_33_hv (out, in, vhi);
    output out;
    input in;
    input vhi;

assign out = ~in;

endmodule
`timescale 1ns / 1ns

module inv (Y, A);
    output Y;
    input A;

	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;


	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_hvt (Y, A);
    output Y;
    input A;

	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_hvt_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;


	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_tri_2_18 (Y, A, T, Tb);
    output Y;
    input A;
    input T;
    input Tb;



    reg Y;
    always @ (A or T or Tb)
    
    begin
    if      ((T == 1)&&(Tb == 0))
	Y = !A;
    else 
	Y = 1'b z;

    end

endmodule
module inv_tri_2_18_g (Y, A, T, Tb, gnd_node);
    output Y;
    input A;
    input T;
    input Tb;
    input gnd_node;

reg Y;
always @ (A or T or Tb or gnd_node)

begin
	if      ((T == 1)&&(Tb == 0)&&(gnd_node == 0))
		Y = !A;
    else
	    Y = 1'b z;

end

endmodule
`timescale 1ns / 1ns

module inv_tri_2_25 (Y, A, T, Tb);
    output Y;
    input A;
    input T;
    input Tb;



    reg Y;
    always @ (A or T or Tb)
    
    begin
    if      ((T == 1)&&(Tb == 0))
	Y = !A;
    else 
	Y = 1'b z;

    end

endmodule
module inv_tri_2_25_g (Y, A, T, Tb, gnd_node);
    output Y;
    input A;
    input T;
    input Tb;
    input gnd_node;

reg Y;
always @ (A or T or Tb or gnd_node)

begin
	if      ((T == 1)&&(Tb == 0)&&(gnd_node == 0))
		Y = !A;
    else
	    Y = 1'b z;

end

endmodule
`timescale 1ns / 1ns

module inv_tri_2_33 (Y, A, T, Tb);
    output Y;
    input A;
    input T;
    input Tb;


    reg Y;
    always @ (A or T or Tb)
    
    begin
    if      ((T == 1)&&(Tb == 0))
	Y = !A;
    else 
	Y = 1'b z;

    end

endmodule
module inv_tri_2_33_g (Y, A, T, Tb, gnd_node);
    output Y;
    input A;
    input T;
    input Tb;
    input gnd_node;

reg Y;
always @ (A or T or Tb or gnd_node)

begin
	if      ((T == 1)&&(Tb == 0)&&(gnd_node == 0))
		Y = !A;
    else
	    Y = 1'b z;

end

endmodule
`timescale 1ns / 1ns

module inv_tri_2 (Y, A, T, Tb);
    output Y;
    input A;
    input T;
    input Tb;



    reg Y;
    always @ (A or T or Tb)
    
    begin
    if      ((T == 1'b1)&&(Tb == 1'b0))
	Y = !A;
    else if      ((T == 1'b0)&&(Tb == 1'b1)) Y = 1'bz;
    else	Y = 1'bx;

    end

endmodule
module inv_tri_2_g (Y, A, T, Tb, gnd_node);
    output Y;
    input A;
    input T;
    input Tb;
    input gnd_node;

reg Y;
always @ (A or T or Tb or gnd_node)

begin
	if      ((T == 1)&&(Tb == 0)&&(gnd_node == 0))
		Y = !A;
    else
	    Y = 1'b z;

end

endmodule
module inv_tri_2_hvt (Y, A, T, Tb);
    output Y;
    input A;
    input T;
    input Tb;

reg Y;
always @ (A or T or Tb)

begin
	if      ((T == 1'b1)&&(Tb == 1'b0))
		Y = !A;
    else if      ((T == 1'b0)&&(Tb == 1'b1)) Y = 1'b z;
    else    Y = 1'b z;

end

endmodule
module inv_tri_2_hvt_g (Y, A, T, Tb, gnd_node);
    output Y;
    input A;
    input T;
    input Tb;
    input gnd_node;

reg Y;
always @ (A or T or Tb or gnd_node)

begin
	if      ((T == 1)&&(Tb == 0)&&(gnd_node == 0))
		Y = !A;
    else
	    Y = 1'b z;

end

endmodule
`timescale 1ns / 1ns

module inv_w_pd_18 (Y, A);
    output Y;
    input A;
	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pd_18_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;
	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pd_25 (Y, A);
    output Y;
    input A;
	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pd_25_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;
	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pd_33 (Y, A);
    output Y;
    input A;
	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pd_33_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;
	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pd (Y, A);
    output Y;
    input A;
	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pd_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;
	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pd_hvt (Y, A);
    output Y;
    input A;
	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pd_hvt_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;
	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pu_18 (Y, A);
    output Y;
    input A;
    	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pu_18_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;
    	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pu_25 (Y, A);
    output Y;
    input A;
    	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pu_25_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;
    	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pu_33 (Y, A);
    output Y;
    input A;
    	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pu_33_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;
    	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pu (Y, A);
    output Y;
    input A;
    	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pu_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;
    	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pu_hvt (Y, A);
    output Y;
    input A;
    	
	assign Y = !A;

endmodule
`timescale 1ns / 1ns

module inv_w_pu_hvt_g (Y, A, gnd_node);
    output Y;
    input A;
    input gnd_node;
    	
	assign Y = !A;

endmodule
module mux2 (out, in0, in1, sel);
    output out;
    input in0;
    input in1;
    input sel;

    assign out = (sel) ? in1 : in0;

endmodule
module mux2_g (out, in0, in1, sel, gnd_node);
    output out;
    input in0;
    input in1;
    input sel;
    input gnd_node;

    assign out = (sel) ? in1 : in0;

endmodule
module mux2_hvt (out, in0, in1, sel);
    output out;
    input in0;
    input in1;
    input sel;

    assign out = (sel) ? in1 : in0;

endmodule
module mux2_hvt_g (out, in0, in1, sel, gnd_node);
    output out;
    input in0;
    input in1;
    input sel;
    input gnd_node;

    assign out = (sel) ? in1 : in0;

endmodule
`timescale 1ns / 1ns

module mux3_18 (out, in0, in1, in2, sel);

output out;
input in0;
input in1;
input in2;
input [3:0] sel;

    reg out;
    always @ (sel or in0 or in1 or in2)
	begin

    	if      (sel == 4'b1001)
		out = in0;
	else if (sel == 4'b1010)
		out = in1;
	else if (sel == 4'b1100)
		out = in2;
	else 
		out = 1'bz;
	end

endmodule

`timescale 1ns / 1ns

module mux3_25 (out, in0, in1, in2, sel);

output out;
input in0;
input in1;
input in2;
input [3:0] sel;

    reg out;
    always @ (sel or in0 or in1 or in2)
	begin

    	if      (sel == 4'b1001)
		out = in0;
	else if (sel == 4'b1010)
		out = in1;
	else if (sel == 4'b1100)
		out = in2;
	else 
		out = 1'bz;
	end

endmodule

`timescale 1ns / 1ns

module mux3 (out, in0, in1, in2, sel);

output out;
input in0;
input in1;
input in2;
input [3:0] sel;

    reg out;
    always @ (sel or in0 or in1 or in2)
	begin

    	if      (sel == 4'b1001)
		out = in0;
	else if (sel == 4'b1010)
		out = in1;
	else if (sel == 4'b1100)
		out = in2;
	else 
		out = 1'bz;
	end

endmodule

`timescale 1ns / 1ns

module mux3_hvt (out, in0, in1, in2, sel);

output out;
input in0;
input in1;
input in2;
input [3:0] sel;

    reg out;
    always @ (sel or in0 or in1 or in2)
	begin

    	if      (sel == 4'b1001)
		out = in0;
	else if (sel == 4'b1010)
		out = in1;
	else if (sel == 4'b1100)
		out = in2;
	else 
		out = 1'bz;
	end

endmodule

`timescale 1ns / 1ns

module mux4_18 (out, in0, in1, in2, in3, sel);

output out;
input in0;
input in1;
input in2;
input in3;
input [4:0] sel;

    reg out;
    always @ (in0 or in1 or in2 or in3 or sel)
	begin

    	if      (sel == 5'b10001)
		out = in0;
	else if (sel == 5'b10010)
		out = in1;
	else if (sel == 5'b10100)
		out = in2;
	else if (sel == 5'b11000)
		out = in3;
	else 
		out = 1'bz;
	end

endmodule

`timescale 1ns / 1ns

module mux4_25 (out, in0, in1, in2, in3, sel);

output out;
input in0;
input in1;
input in2;
input in3;
input [4:0] sel;

    reg out;
    always @ (in0 or in1 or in2 or in3 or sel)
	begin

    	if      (sel == 5'b10001)
		out = in0;
	else if (sel == 5'b10010)
		out = in1;
	else if (sel == 5'b10100)
		out = in2;
	else if (sel == 5'b11000)
		out = in3;
	else 
		out = 1'bz;
	end

endmodule


`timescale 1ns / 1ns

module mux4 (out, in0, in1, in2, in3, sel);

output out;
input in0;
input in1;
input in2;
input in3;
input [4:0] sel;

    reg out;
    always @ (in0 or in1 or in2 or in3 or sel)
	begin

    	if      (sel == 5'b10001)
		out = in0;
	else if (sel == 5'b10010)
		out = in1;
	else if (sel == 5'b10100)
		out = in2;
	else if (sel == 5'b11000)
		out = in3;
	else 
		out = 1'bz;
	end

endmodule

`timescale 1ns / 1ns

module mux4_hvt (out, in0, in1, in2, in3, sel);

output out;
input in0;
input in1;
input in2;
input in3;
input [4:0] sel;

    reg out;
    always @ (in0 or in1 or in2 or in3 or sel)
	begin

    	if      (sel == 5'b10001)
		out = in0;
	else if (sel == 5'b10010)
		out = in1;
	else if (sel == 5'b10100)
		out = in2;
	else if (sel == 5'b11000)
		out = in3;
	else 
		out = 1'bz;
	end

endmodule

`timescale 1ns / 1ns

module mux5_18 (out, in0, in1, in2, in3, in4, sel);

output out;
input in0;
input in1;
input in2;
input in3;
input in4;
input [5:0] sel;

    reg out;
    always @ (in0 or in1 or in2 or in3 or in4 or sel)
	begin

    	if      (sel == 6'b100001)
		out = in0;
	else if (sel == 6'b100010)
		out = in1;
	else if (sel == 6'b100100)
		out = in2;
	else if (sel == 6'b101000)
		out = in3;
	else if (sel == 6'b110000)
		out = in4;
	else 
		out = 1'bz;
	end

endmodule

`timescale 1ns / 1ns

module mux5_25 (out, in0, in1, in2, in3, in4, sel);

output out;
input in0;
input in1;
input in2;
input in3;
input in4;
input [5:0] sel;

    reg out;
    always @ (in0 or in1 or in2 or in3 or in4 or sel)
	begin

    	if      (sel == 6'b100001)
		out = in0;
	else if (sel == 6'b100010)
		out = in1;
	else if (sel == 6'b100100)
		out = in2;
	else if (sel == 6'b101000)
		out = in3;
	else if (sel == 6'b110000)
		out = in4;
	else 
		out = 1'bz;
	end

endmodule



`timescale 1ns / 1ns

module mux5 (out, in0, in1, in2, in3, in4, sel);

output out;
input in0;
input in1;
input in2;
input in3;
input in4;
input [5:0] sel;

    reg out;
    always @ (in0 or in1 or in2 or in3 or in4 or sel)
	begin

    	if      (sel == 6'b100001)
		out = in0;
	else if (sel == 6'b100010)
		out = in1;
	else if (sel == 6'b100100)
		out = in2;
	else if (sel == 6'b101000)
		out = in3;
	else if (sel == 6'b110000)
		out = in4;
	else 
		out = 1'bz;
	end

endmodule

`timescale 1ns / 1ns

module mux5_hvt (out, in0, in1, in2, in3, in4, sel);

output out;
input in0;
input in1;
input in2;
input in3;
input in4;
input [5:0] sel;

    reg out;
    always @ (in0 or in1 or in2 or in3 or in4 or sel)
	begin

    	if      (sel == 6'b100001)
		out = in0;
	else if (sel == 6'b100010)
		out = in1;
	else if (sel == 6'b100100)
		out = in2;
	else if (sel == 6'b101000)
		out = in3;
	else if (sel == 6'b110000)
		out = in4;
	else 
		out = 1'bz;
	end

endmodule

`timescale 1ns / 1ns

module nand2_18 (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = ~(A & B);

endmodule
module nand2_18_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;

initial
begin
	Y = 1;
end

reg Y;
always @ (A or B or gnd_node)
if (gnd_node == 1'b0)
	Y = ~(A & B);
else   Y = 1'bz;
endmodule
`timescale 1ns / 1ns
/*
module nand2_25 (Y, A, B);
    output Y;
    input A;
    input B;
*/
module nand2_25 ( Y, A, B, G, Gb, P, Pb );
output  Y;

input  A, B, G, Gb, P, Pb;

	assign Y = ~(A & B);

endmodule
module nand2_25_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;

reg Y;
always @ (A or B or gnd_node)
if(gnd_node == 1'b0) Y = ~(A & B);
else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module nand2_33 (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = ~(A & B);

endmodule
module nand2_33_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;

reg Y;
always @ (A or B or gnd_node)
if (gnd_node == 1'b0) Y = ~(A & B);
else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module nand2_33_hv (out, in1, in2, vdd33);
    output out;
    input vdd33;
    input in1;
    input in2;

	assign out = ~(in1 & in2);

endmodule
`timescale 1ns / 1ns

module nand2 (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = ~(A & B);

endmodule
module nand2_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;

reg Y;
always @ (A or B or gnd_node)
if (gnd_node == 1'b0) Y = ~(A & B);
else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module nand2_hvt (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = ~(A & B);

endmodule
module nand2_hvt_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;

reg Y;
always @ (A or B or gnd_node)
if (gnd_node == 1'b0) Y = ~(A & B);
else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module nand3_18 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;

	assign Y = ~(A & B & C);

endmodule
module nand3_18_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

reg Y;
	always @ (A or B or C or gnd_node)
	if (gnd_node == 1'b0) Y = ~(A & B & C);
	else Y = 1'bz;

endmodule
`timescale 1ns / 1ns
/*
module nand3_25 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;
*/
module nand3_25 ( Y, A, B, C, G, Gb, P, Pb );
output  Y;

input  A, B, C, G, Gb, P, Pb;

	assign Y = ~(A & B & C);

endmodule
module nand3_25_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

reg Y;
	always @ (A or B or C or gnd_node)
	if (gnd_node == 1'b0) Y = ~(A & B & C);
	else Y = 1'bz;

endmodule
`timescale 1ns / 1ns

module nand3_33 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;

	assign Y = ~(A & B & C);

endmodule
module nand3_33_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

reg Y;
	always @ (A or B or C or gnd_node)
	if (gnd_node == 1'b0) Y = ~(A & B & C);
	else Y =1'bz;

endmodule
`timescale 1ns / 1ns

module nand3 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;

	assign Y = ~(A & B & C);

endmodule
module nand3_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

reg Y;
	always @ (A or B or C or gnd_node)
	if (gnd_node == 1'b0) Y = ~(A & B & C);
	else Y = 1'bz;

endmodule
`timescale 1ns / 1ns

module nand3_hvt (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;

	assign Y = ~(A & B & C);

endmodule
module nand3_hvt_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

reg Y;
	always @ (A or B or C or gnd_node)
	if (gnd_node == 1'b0) Y = ~(A & B & C);
	else Y = 1'bz;

endmodule
`timescale 1ns / 1ns

module nand4_18 (Y, A, B, C, D);
    output Y;
    input A;
    input B;
    input C;
    input D;

assign Y = ~(A & B & C & D);

endmodule
module nand4_18_g (Y, A, B, C, D, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input gnd_node;

reg Y;
always @ (A or B or C or D or gnd_node)
if (gnd_node == 1'b0) Y = ~(A & B & C & D);
else Y = 1'bz;

endmodule
`timescale 1ns / 1ns

module nand4_25 (Y, A, B, C, D);
    output Y;
    input A;
    input B;
    input C;
    input D;

assign Y = ~(A & B & C & D);

endmodule
module nand4_25_g (Y, A, B, C, D, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input gnd_node;

reg Y;
always @ (A or B or C or D)
if( gnd_node == 1'b0) Y = ~(A & B & C & D);
else Y = 1'bz;


endmodule
`timescale 1ns / 1ns

module nand4_33 (Y, A, B, C, D);
    output Y;
    input A;
    input B;
    input C;
    input D;

assign Y = ~(A & B & C & D);

endmodule
module nand4_33_g (Y, A, B, C, D, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input gnd_node;

reg Y;
always @ (A or B or C or D)
if( gnd_node == 1'b0) Y = ~(A & B & C & D);
else Y = 1'bz;

endmodule
`timescale 1ns / 1ns

module nand4 (Y, A, B, C, D);
    output Y;
    input A;
    input B;
    input C;
    input D;

assign Y = ~(A & B & C & D);

endmodule
module nand4_g (Y, A, B, C, D, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input gnd_node;

reg Y;
always @ (A or B or C or D)
if ( gnd_node == 1'b0) Y = ~(A & B & C & D);
else Y = 1'bz;

endmodule
`timescale 1ns / 1ns

module nand4_hvt (Y, A, B, C, D);
    output Y;
    input A;
    input B;
    input C;
    input D;

assign Y = ~(A & B & C & D);

endmodule
module nand4_hvt_g (Y, A, B, C, D, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input D;
    input gnd_node;

reg Y;
always @ (A or B or C or D)
if( gnd_node == 1'b0) Y = ~(A & B & C & D);
else Y = 1'bz;

endmodule
`timescale 1ns / 1ns

module nor2_18 (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = ~(A | B);

endmodule
module nor2_18_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;
reg Y;
always @ (A or B or gnd_node)
if (gnd_node == 1'b0)  Y = ~(A | B);
else  Y = 1'bz;

endmodule
`timescale 1ns / 1ns

module nor2_33 (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = ~(A | B);

endmodule
module nor2_33_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;

reg Y;
always @ (A or B or gnd_node)

if ( gnd_node == 1'b0)  Y = ~(A | B);
else Y = 1'bz;

endmodule
`timescale 1ns / 1ns

module nor2 (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = ~(A | B);

endmodule
module nor2_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;

reg Y;
always @ (A or B or gnd_node)
if ( gnd_node == 1'b0) Y = ~(A | B);
else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module nor2_hvt (Y, A, B);
    output Y;
    input A;
    input B;

	assign Y = ~(A | B);

endmodule
module nor2_hvt_g (Y, A, B, gnd_node);
    output Y;
    input A;
    input B;
    input gnd_node;

reg Y;
always @ (A or B or gnd_node)
if ( gnd_node == 1'b0) Y = ~(A | B);
else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module nor3_18 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;

	assign Y = ~(A | B |C);

endmodule
module nor3_18_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

reg Y;
always @ (A or B or C or gnd_node)
	if ( gnd_node == 1'b0) Y = ~(A | B |C);
	 else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module nor3_33 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;

	assign Y = ~(A | B |C);

endmodule
module nor3_33_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

reg Y;
always @ (A or B or C or gnd_node)
	if (gnd_node == 1'b0) Y = ~(A | B |C);
	else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module nor3 (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;

	assign Y = ~(A | B |C);

endmodule
module nor3_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

reg Y;
always @ (A or B or C or gnd_node)
	if (gnd_node == 1'b0)  Y = ~(A | B |C);
	else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module nor3_hvt (Y, A, B, C);
    output Y;
    input A;
    input B;
    input C;

	assign Y = ~(A | B |C);

endmodule
module nor3_hvt_g (Y, A, B, C, gnd_node);
    output Y;
    input A;
    input B;
    input C;
    input gnd_node;

reg Y;
always @ (A or B or C or gnd_node)
	if ( gnd_node == 1'b0) Y = ~(A | B |C);
	else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module nor4_hvt (Y, A, B, C, D);
    output Y;
    input A;
    input B;
    input C;
    input D;

	assign Y = ~(A | B |C | D);

endmodule
`timescale 1ns / 1ns

module oai21x2_18 (Y, A0, A1, B0);
    output Y;
    input A0;
    input A1;
    input B0;

    reg Y;
    always @ (A0 or A1 or B0)

    if (B0 == 1 'b0) begin
		Y = 1 'b1;
	end else begin
		Y = !(A0 | A1);
	end

endmodule
module oai21x2_18_g (Y, A0, A1, B0, gnd_node);
    output Y;
    input A0;
    input A1;
    input B0;
    input gnd_node;

reg Y;
always @ (A0 or A1 or B0 or gnd_node)
if ( gnd_node == 1'b0) begin
    if (B0 == 1 'b0) begin
	    Y = 1 'b1;
    end else begin
	    Y = !(A0 | A1);
end
end else Y = 1'bz;

endmodule
`timescale 1ns / 1ns

module oai21x2_25 (Y, A0, A1, B0);
    output Y;
    input A0;
    input A1;
    input B0;

    reg Y;
    always @ (A0 or A1 or B0)

    if (B0 == 1 'b0) begin
		Y = 1 'b1;
	end else begin
		Y = !(A0 | A1);
	end

endmodule
module oai21x2_25_g (Y, A0, A1, B0, gnd_node);
    output Y;
    input A0;
    input A1;
    input B0;
    input gnd_node;

reg Y;
always @ (A0 or A1 or B0 or gnd_node)
if ( gnd_node == 1'b0 ) begin
    if (B0 == 1 'b0) begin
	    Y = 1 'b1;
    end else begin
	    Y = !(A0 | A1);
end
end else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module oai21x2_33 (Y, A0, A1, B0);
    output Y;
    input A0;
    input A1;
    input B0;

    reg Y;
    always @ (A0 or A1 or B0)

    if (B0 == 1 'b0) begin
		Y = 1 'b1;
	end else begin
		Y = !(A0 | A1);
	end

endmodule
module oai21x2_33_g (Y, A0, A1, B0, gnd_node);
    output Y;
    input A0;
    input A1;
    input B0;
    input gnd_node;

reg Y;
always @ (A0 or A1 or B0)
if ( gnd_node == 1'b0) begin
    if (B0 == 1 'b0) begin
	    Y = 1 'b1;
    end else begin
	    Y = !(A0 | A1);
end
end else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module oai21x2 (Y, A0, A1, B0);
    output Y;
    input A0;
    input A1;
    input B0;

    reg Y;
    always @ (A0 or A1 or B0)

    if (B0 == 1 'b0) begin
		Y = 1 'b1;
	end else begin
		Y = !(A0 | A1);
	end

endmodule
module oai21x2_g (Y, A0, A1, B0, gnd_node);
    output Y;
    input A0;
    input A1;
    input B0;
    input gnd_node;

reg Y;
always @ (A0 or A1 or B0)

    if (B0 == 1 'b0) begin
	    Y = 1 'b1;
    end else begin
	    Y = !(A0 | A1);
end

endmodule
`timescale 1ns / 1ns

module oai21x2_hvt (Y, A0, A1, B0);
    output Y;
    input A0;
    input A1;
    input B0;

    reg Y;
    always @ (A0 or A1 or B0)

    if (B0 == 1 'b0) begin
		Y = 1 'b1;
	end else begin
		Y = !(A0 | A1);
	end

endmodule
module oai21x2_hvt_g (Y, A0, A1, B0, gnd_node);
    output Y;
    input A0;
    input A1;
    input B0;
    input gnd_node;

reg Y;
always @ (A0 or A1 or B0 or gnd_node)
if ( gnd_node == 1'b0) begin
    if (B0 == 1 'b0) begin
	    Y = 1 'b1;
    end else begin
	    Y = !(A0 | A1);
end
end else Y = 1'bz;
endmodule
`timescale 1ns / 1ns

module resistor (MINUS, PLUS);
	inout MINUS;
	inout	PLUS;

tran t1(MINUS, PLUS);
endmodule
`timescale 1ns / 1ns

module res (MINUS, PLUS);
	inout MINUS;
	inout	PLUS;

tran t1(MINUS, PLUS);
endmodule
`timescale 1ns / 1ns

module slt_mx_18 (out, in, slt);
    output out;
    input in;
    input slt;

	reg out;
	always @ (in or slt)
	if (slt == 1 'b1) begin
		out = in;
	end else begin
		out = 1 'b z;
	end
endmodule
`timescale 1ns / 1ns

module slt_mx_25 (out, in, slt);
    output out;
    input in;
    input slt;

	reg out;
	always @ (in or slt)
	if (slt == 1 'b1) begin
		out = in;
	end else begin
		out = 1 'b z;
	end
endmodule
`timescale 1ns / 1ns

module slt_mx_33 (out, in, slt);
    output out;
    input in;
    input slt;

	reg out;
	always @ (in or slt)
	if (slt == 1 'b1) begin
		out = in;
	end else begin
		out = 1 'b z;
	end
endmodule
`timescale 1ns / 1ns

module slt_mx (out, in, slt);
    output out;
    input in;
    input slt;

	reg out;
	always @ (in or slt)
	if (slt == 1 'b1) begin
		out = in;
	end else begin
		out = 1 'b z;
	end
endmodule
`timescale 1ns / 1ns

module slt_mx_hvt (out, in, slt);
    output out;
    input in;
    input slt;

	reg out;
	always @ (in or slt)
	if (slt == 1 'b1) begin
		out = in;
	end else begin
		out = 1 'b z;
	end
endmodule
`timescale 1ns / 1ns

module txgate_18 (out, in, nn, pp);
    output out;
    input in;
    input nn;
    input pp;

	reg out;
	always @ (in or nn or pp)

	if ((nn == 1 'b1)&& (pp == 1 'b0)) begin
		out = in;
	end else begin
		out = 1'bz;
	end
endmodule
`timescale 1ns / 1ns

module txgate_25 (out, in, nn, pp);
    output out;
    input in;
    input nn;
    input pp;

	reg out;
	always @ (in or nn or pp)

	if ((nn == 1 'b1)&& (pp == 1 'b0)) begin
		out = in;
	end else begin
		out = 1'bz;
	end
endmodule
`timescale 1ns / 1ns

module txgate_33 (out, in, nn, pp);
    output out;
    input in;
    input nn;
    input pp;

	reg out;
	always @ (in or nn or pp)

	if ((nn == 1 'b1)&& (pp == 1 'b0)) begin
		out = in;
	end else begin
		out = 1'bz;
	end
endmodule
`timescale 1ns / 1ns

module txgate (out, in, nn, pp);
    output out;
    input in;
    input nn;
    input pp;

	reg out;
	always @ (in or nn or pp)

	if ((nn == 1 'b1)&& (pp == 1 'b0)) begin
		out = in;
	end else begin
		out = 1'bz;
	end
endmodule
`timescale 1ns / 1ns

module txgate_hvt (out, in, nn, pp);
    output out;
    input in;
    input nn;
    input pp;

	reg out;
	always @ (in or nn or pp)

	if ((nn == 1 'b1)&& (pp == 1 'b0)) begin
		out = in;
	end else if ((nn == 1 'b0)&& (pp == 1 'b1)) begin
		out = 1'bz;
	end /* else  out = 1'bx; */
endmodule
module anor31_hvt (Y, A, B, C, D);
    output Y;
    input A;
    input B;
    input C;
    input D;
 

assign Y = ~(D | (C*B*A));

endmodule
module clkandnor22_hvt (y, a, b, c, d);
    output y;
    input a;
    input b;
    input c;
    input d;

    assign y = !((a & b) | (c & d));

endmodule
module lclmuxdbuf (Y, A, T);
    output Y;
    input A;
    input T;
reg Y;
always @(A or T)
if (T == 1'b1) Y = A;
else if (T == 1'b0) Y = 1'bz;
else Y = 1'bx;
endmodule
module longdbuf (Y, A, T);
    output Y;
    input A;
    input T;
    reg Y;
    always @(A or T)
if (T == 1'b1) Y = A;
else if (T == 1'b0) Y = 1'bz;
else Y = 1'bx;
endmodule
module mux2_4lutx1_hvt_g (out, in0, in1, sel, sel_b);
    output out;
    input in0;
    input in1;
    input sel;
    input sel_b;

    assign out = (sel) ? in1 : in0;

endmodule
module mux2x1_hvt (out, in0, in1, sel);
    output out;
    input in0;
    input in1;
    input sel;

    assign out = (sel) ? in1 : in0;

endmodule
module sp12to4 (triout, cbitb, prog, drv);
    output triout;
    input cbitb;
    input prog;
    input drv;
reg triout;
  always @(drv or cbitb or prog)
   if ((prog ==1'b0) && (cbitb ==1'b0)) triout=drv;
   else if ((prog ==1'b1) || (cbitb ==1'b1)) triout=1'bz;
   else triout=1'bx;

endmodule
module spn4dbuf (Y, A, T);
    output Y;
    input A;
    input T;
    reg Y;
    always @(A or T)
    if (T ==1'b1) Y=A;
    else if (T ==1'b0) Y=1'bz;
    else Y=1'bx;

endmodule
//************************************************
//Title:    ce_clkm8to1_ref
//Design:   ce_clkm8to1_ref.v
//Author:   Simon
//Company:  SiliconBlue Technologies, Inc.
//revision: Jun. 14, 2007
//************************************************
module	ce_clkm8to1	(
						moutb,
						cbit,
						cbitb,
						min,
						prog
						);

input	[7:0]	min;
input	[3:0]	cbit;
input	[3:0]	cbitb;
input			prog;

output			moutb;
reg				mout;

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$prog$moutb= 1.0,
      tphl$prog$moutb= 1.0,
      tplh$min0$moutb= 1.0,
      tphl$min0$moutb= 1.0,
      tplh$min1$moutb= 1.0,
      tphl$min1$moutb= 1.0,
      tplh$min2$moutb= 1.0,
      tphl$min2$moutb= 1.0,
      tplh$min3$moutb= 1.0,
      tphl$min3$moutb= 1.0,
      tplh$min4$moutb= 1.0,
      tphl$min4$moutb= 1.0,
      tplh$min5$moutb= 1.0,
      tphl$min5$moutb= 1.0,
      tplh$min6$moutb= 1.0,
      tphl$min6$moutb= 1.0,
      tplh$min7$moutb= 1.0,
      tphl$min7$moutb= 1.0;
    // path delays
     (prog *> moutb) = (tplh$prog$moutb, tphl$prog$moutb);
     (min[0] *> moutb) = (tplh$min0$moutb, tphl$min0$moutb);
     (min[1] *> moutb) = (tplh$min1$moutb, tphl$min1$moutb);
     (min[2] *> moutb) = (tplh$min2$moutb, tphl$min2$moutb);
     (min[3] *> moutb) = (tplh$min3$moutb, tphl$min3$moutb);
     (min[4] *> moutb) = (tplh$min4$moutb, tphl$min4$moutb);
     (min[5] *> moutb) = (tplh$min5$moutb, tphl$min5$moutb);
     (min[6] *> moutb) = (tplh$min6$moutb, tphl$min6$moutb);
     (min[7] *> moutb) = (tplh$min7$moutb, tphl$min7$moutb);
   endspecify
`endif

always @ (min or cbit or cbitb)
begin
	if	(cbitb!== ~cbit)
		mout	=	1'bx;
	else
		mout	=	min[cbit[2:0]];
end		
    //nor M1 (moutb, cbitb[3], prog, mout);
    assign moutb = (prog || cbitb[3] ) ? 0 : ~mout;
	


endmodule



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

assign	clk	=	~(sel_temp || prog || cbitb[4] || cenb);

endmodule
//************************************************
//Title:    clk_mux8to1
//Design:   clk_mux8to1.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//revision: May 30, 2007
//************************************************
module	clk_mux8to1	(
					min,
					cbit,
					cbitb,
					inmuxo,
					prog
					);

input	[7:0]	min;
input	[3:0]	cbit;
input	[3:0]	cbitb;
input			prog;

output			inmuxo;

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


reg	inmuxo;

always @ (cbit or cbitb or prog or min)
begin
	if	(cbit[3]==1'b0 || prog ==1'b1)
		inmuxo	=	1'bz;
	else if	(prog ==1'b0 && cbit[3] ==1'b1)
	        case(cbit[2:0])
	        3'h0 : inmuxo	=	min[0];
	        3'h1 : inmuxo	=	min[1];
	        3'h2 : inmuxo	=	min[2];
	        3'h3 : inmuxo	=	min[3];
	        3'h4 : inmuxo	=	min[4];
	        3'h5 : inmuxo	=	min[5];
	        3'h6 : inmuxo	=	min[6];
	        3'h7 : inmuxo	=	min[7];
	        default : inmuxo = 1'bx;
	        endcase
		//inmuxo	=	min[cbit[2:0]];
	else
		inmuxo	=	1'bx;
end
endmodule
//************************************************
//Title:    sbox1m3to1
//Design:   sbox1m3to1.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//Version:  D0.1
//
//INIT: June 22, 2007
//
//Revision : 
//************************************************
`timescale 1ns/10ps
module sbox1m3to1 (in0, in1, in2, op, prog, c, cb);

//port signals
input in0, in1, in2;
output op;
input [1:0] c, cb;
input  prog;

reg op;

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$in0$op= 1.0,
      tphl$in0$op= 1.0,
      tplh$in1$op= 1.0,
      tphl$in1$op= 1.0,
      tplh$in2$op= 1.0,
      tphl$in2$op= 1.0,
      tplh$c1$op= 1.0,
      tphl$c1$op= 1.0,
      tplh$c0$op= 1.0,
      tphl$c0$op= 1.0,
      tplh$cb1$op= 1.0,
      tphl$cb1$op= 1.0,
      tplh$cb0$op= 1.0,
      tphl$cb0$op= 1.0,
      tplh$prog$op= 1.0,
      tphl$prog$op= 1.0;

    // path delays
     (in0 *> op) = (tplh$in0$op, tphl$in0$op);
     (in1 *> op) = (tplh$in1$op, tphl$in1$op);
     (in2 *> op) = (tplh$in2$op, tphl$in2$op);
     (c1 *> op) = (tplh$c1$op, tphl$c1$op);
     (c0 *> op) = (tplh$c0$op, tphl$c0$op);
     (cb1 *> op) = (tplh$cb1$op, tphl$cb1$op);
     (cb0 *> op) = (tplh$cb0$op, tphl$cb0$op);
     (prog *> op) = (tplh$prog$op, tphl$prog$op);
  endspecify
`endif


always @(in0 or in1 or in2 or prog or c[1:0] or cb[1:0])
   if (prog) op = 1'bz;
   else if (c[1:0]==2'b00 && cb[1:0]==2'b11) op = 1'bz;
   else if (!prog && c[1:0]==2'b01 && cb[1:0]==2'b10) op = in0;
   else if (!prog && c[1:0]==2'b10 && cb[1:0]==2'b01) op = in1;
   else if (!prog && c[1:0]==2'b11 && cb[1:0]==2'b00) op = in2;
   else op = 1'bx;

endmodule // sbox1m3to1

//************************************************
//Title:    mux_4carry
//Design:   mux_4carry.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//revision: Sep 6, 2007
//************************************************
`timescale 1ns/10ps
module mux_4carry (lcl_cin, cin, cbit, cbitb, prog);

//the output signal
output lcl_cin;

//the input signals
input cin, prog;
input [1:0] cbit, cbitb;

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$cin$out = 1.0,
      tphl$cin$out = 1.0,
      tplh$prog$out = 1.0,
      tphl$prog$out = 1.0;

    // path delays
     (prog *> lcl_cin) = (tplh$prog$out, tphl$prog$out);
     (cin  *> lcl_cin) = (tplh$cin$out, tphl$cin$out);
  endspecify
`endif

//
reg  lcl_cin;

always @(cin or cbit or cbitb or prog) begin
     if (prog===1'b1) lcl_cin <= 1'b1;
     else if (prog===1'b0) begin
           if (cbit != ~cbitb) lcl_cin <= 1'bx;
           else begin
					case	(cbit[1:0])
					2'b00	:	lcl_cin	=	1'b0;
					2'b01	:	lcl_cin	=	1'b1;
					2'b10	:	begin
								if	(cin===1'bz)
									lcl_cin	=	1'bx;
								else
									lcl_cin	=	cin;
								end
					2'b11	:	begin
								if	(cin===1'bz)
									lcl_cin	=	1'bx;
								else
									lcl_cin	=	cin;
								end
					2'b1z	:	begin
								if	(cin===1'bz)
									lcl_cin	=	1'bx;
								else
									lcl_cin	=	cin;
								end
					2'b1x	:	begin
								if	(cin===1'bz)
									lcl_cin	=	1'bx;
								else
									lcl_cin	=	cin;
								end
					default	:	lcl_cin	=	1'bx;
					endcase
		end
	end
     else lcl_cin	=	1'bx;
   end

endmodule // mux_4carry
//************************************************
//Title:    odrv12
//Design:   odrv12.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//revision: May 30, 2007
//************************************************
module	odrv12	(
					slfop,
					cbitb,
					prog,
					sp12
					);

input		slfop;
input		cbitb;
input		prog;

output		sp12;

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$slf$sp12= 1.0,
      tphl$slf$sp12= 1.0,
      tplh$prog$sp12= 1.0,
      tphl$prog$sp12= 1.0;
 
    // path delays
     (prog *> sp12) = (tplh$prog$sp12, tphl$prog$sp12);
     (slfop  *> sp12) = (tplh$slf$sp12, tphl$slf$sp12);
  endspecify
`endif


reg	sp12;

always @ (cbitb or prog or slfop)
begin
	if	(cbitb==1'b1 || prog==1'b1)
		sp12	=	1'bz;
	else if	(cbitb==1'b0 && prog==1'b0)
		sp12	=	slfop;
	else
		sp12	=	1'bx;
end

endmodule	//	odrv12_ref//************************************************
//Title:    odrv4
//Design:   odrv4_ref.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//revision: May 30, 2007
//************************************************
module	odrv4	(
					slfop,
					cbitb,
					prog,
					sp4
					);

input		slfop;
input		cbitb;
input		prog;

output		sp4;

`ifdef TIMINGCHECK
specify
    // delay parameters
    specparam
      tplh$slfop$sp4= 1.0,
      tphl$slfop$sp4= 1.0,
      tplh$prog$sp4= 1.0,
      tphl$prog$sp4= 1.0;
 
    // path delays
     (prog *> sp4) = (tplh$prog$sp4, tphl$prog$sp4);
     (slfop *> sp4) = (tplh$slfop$sp4, tphl$slfop$sp4);
  endspecify
`endif


reg	sp4;

always @ (cbitb or prog or slfop)
begin
	if	(cbitb==1'b1 || prog==1'b1)
		sp4	=	1'bz;
	else if	(cbitb==1'b0 && prog==1'b0)
		sp4	=	slfop;
	else
		sp4	=	1'bx;
end
endmodule	//	odrv4//************************************************
//Title:    sbox7to1
//Design:   sbox7to1
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//revision: May 30, 2007
//************************************************
`timescale 1ns/10ps
module sbox7to1_220 (                   out, 
					c, 
					cb, 
                                        in0, 
					in1,
					in2,
					in3,
					in4,
					in5,
					in6,
					prog);

//the output signal
output out;

//the input signals
input in0, in1, in2, in3;
input in4, in5, in6;
input [2:0] c, cb;
input  prog;

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$in0$out= 1.0,
      tphl$in0$out= 1.0,
      tplh$in1$out= 1.0,
      tphl$in1$out= 1.0,
      tplh$in2$out= 1.0,
      tphl$in2$out= 1.0,
      tplh$in3$out= 1.0,
      tphl$in3$out= 1.0,
      tplh$in4$out= 1.0,
      tphl$in4$out= 1.0,
      tplh$in5$out= 1.0,
      tphl$in5$out= 1.0,
      tplh$in6$out= 1.0,
      tphl$in6$out= 1.0,
      tplh$prog$out= 1.0,
      tphl$prog$out= 1.0;
	  
    // path delays
     (prog *> out) = (tplh$prog$out, tphl$prog$out);
     (in0  *> out) = (tplh$in0$out, tphl$in0$out);
     (in1  *> out) = (tplh$in1$out, tphl$in1$out);
     (in2  *> out) = (tplh$in2$out, tphl$in2$out);
     (in3  *> out) = (tplh$in3$out, tphl$in3$out);
     (in4  *> out) = (tplh$in4$out, tphl$in4$out);
     (in5  *> out) = (tplh$in5$out, tphl$in5$out);
     (in6  *> out) = (tplh$in6$out, tphl$in6$out);
  endspecify
`endif

//
reg  out;

always @(out or in0 or in1 or in2 or in3 or in4 or in5 or in6 or c or cb or prog)
begin
	if (c != ~cb) out <= 1'bx;
	else
	begin
	case	(prog)
	1'b1	:	out	<=	1'bz;
	1'b0	:	begin
				case	(c)
				3'b000:
				    out = 1'bz;
				3'b001:
				    out = in0;   
				3'b010:
				    out = in1;    
				3'b011:
				    out = in2;    
				3'b100:
				    out = in3;    
				3'b101:
				    out = in4;   
				3'b110:
				    out = in5;    
				3'b111:
				    out = in6;
				default:
				    out = 1'bx;
				endcase
				end
	default	:	begin
				if	(c==3'b000)
					out	=	1'bz;
				else
					out	=	1'bx;
				end
	endcase
	end
end

endmodule // sbox7to1
//************************************************
//Title:    sr_clkm8to1_ref
//Design:   sr_clkm8to1_ref.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//revision: Jun. 14, 2007
//************************************************
module	sr_clkm8to1	(
						mout,
						cbit,
						cbitb,
						min,
						prog
						);


input	[7:0]	min;
input	[3:0]	cbit;
input	[3:0]	cbitb;
input			prog;

output			mout;

reg	sel_temp;

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$prog$mout= 1.0,
      tphl$prog$mout= 1.0,
      tplh$min0$mout= 1.0,
      tphl$min0$mout= 1.0,
      tplh$min1$mout= 1.0,
      tphl$min1$mout= 1.0,
      tplh$min2$mout= 1.0,
      tphl$min2$mout= 1.0,
      tplh$min3$mout= 1.0,
      tphl$min3$mout= 1.0,
      tplh$min4$mout= 1.0,
      tphl$min4$mout= 1.0,
      tplh$min5$mout= 1.0,
      tphl$min5$mout= 1.0,
      tplh$min6$mout= 1.0,
      tphl$min6$mout= 1.0,
      tplh$min7$mout= 1.0,
      tphl$min7$mout= 1.0;
    // path delays
     (prog *> mout) = (tplh$prog$mout, tphl$prog$mout);
     (min[0] *> mout) = (tplh$min0$mout, tphl$min0$mout);
     (min[1] *> mout) = (tplh$min1$mout, tphl$min1$mout);
     (min[2] *> mout) = (tplh$min2$mout, tphl$min2$mout);
     (min[3] *> mout) = (tplh$min3$mout, tphl$min3$mout);
     (min[4] *> mout) = (tplh$min4$mout, tphl$min4$mout);
     (min[5] *> mout) = (tplh$min5$mout, tphl$min5$mout);
     (min[6] *> mout) = (tplh$min6$mout, tphl$min6$mout);
     (min[7] *> mout) = (tplh$min7$mout, tphl$min7$mout);
   endspecify
`endif


always @ (min or cbit or cbitb or prog)
begin
	if	(cbit!=~cbitb)
		sel_temp	=	1'bx;
	else
		sel_temp	=	~min[cbit[2:0]];
end

assign	mout = ~|{prog,cbitb[3],sel_temp};

endmodule
//************************************************
//Title:    o_mux
//Design:   o_mux.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//Version:  D0.2
//
//INIT: March 15, 2007
//
//Revision : June 9, 2007  Modify module name and
//             change function
//************************************************
`timescale 1ns/10ps
`celldefine
module o_mux (out, in0, in1, cbit, prog);

//the output signal
output out;

//the input signals
input in0, in1, cbit, prog;

  primit_o_mux (out, in0, in1, cbit, prog);

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$in0$out = 1.0,
      tphl$in0$out = 1.0,
      tplh$in1$out = 1.0,
      tphl$in1$out = 1.0,
      tplh$prog$out = 1.0,
      tphl$prog$out = 1.0,
      tplh$cbit$out = 1.0,
      tphl$cbit$out = 1.0;

    // path delays
     (prog *> out) = (tplh$prog$out, tphl$prog$out);
     (cbit *> out) = (tplh$cbit$out, tphl$cbit$out);
     (in0 *> out) = (tplh$in0$out, tphl$in0$out);
     (in1 *> out) = (tplh$in1$out, tphl$in1$out);
  endspecify
`endif

endmodule // o_mux
`endcelldefine

//************************************************
//Title:    primit_o_mux
//Design:   o_mux.v
//Author:  
//Company: SiliconBlue technologies, Inc.
//revision: March 15, 2007
//************************************************

primitive primit_o_mux (y, a0, a1, c, p);
   output y;  
   input  a0, a1, c, p;

   table

// a0 a1 c  p  :  y
//
   ?  0  ?  1  :  0;
   ?  1  ?  1  :  1;
   ?  x  ?  1  :  x;
   0  ?  0  0  :  0;
   1  ?  0  0  :  1;
   ?  0  1  0  :  0;
   ?  1  1  0  :  1;
   ?  0  1  ?  :  0;
   ?  1  1  ?  :  1;
   endtable
endprimitive // primit_o_mux


//************************************************
//Title:    in_mux
//Design:   in_mux.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//Version:  D0.2
//
//INIT: March 15, 2007
//
//Revision : June 9, 2007  Modify module name
//************************************************
`timescale 1ns/10ps
`celldefine
module in_mux (inmuxo, cbit, cbitb, min, prog);

//the output signal
output inmuxo;

//the input signals
input [15:0] min;
input [4:0] cbit, cbitb;
input  prog;

  primit_in_mux (inmuxo, min[15], min[14], min[13], min[12], min[11],
      min[10], min[9], min[8], min[7], min[6], min[5], min[4], 
      min[3], min[2], min[1], min[0], cbit[4], cbit[3], cbit[2], 
      cbit[1], cbit[0], cbitb[4], cbitb[3], cbitb[2], cbitb[1], cbitb[0], prog);

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
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
      tphl$min7$inmuxo= 1.0,
      tplh$min8$inmuxo= 1.0,
      tphl$min8$inmuxo= 1.0,
      tplh$min9$inmuxo= 1.0,
      tphl$min9$inmuxo= 1.0,
      tplh$min10$inmuxo= 1.0,
      tphl$min10$inmuxo= 1.0,
      tplh$min11$inmuxo= 1.0,
      tphl$min11$inmuxo= 1.0,
      tplh$min12$inmuxo= 1.0,
      tphl$min12$inmuxo= 1.0,
      tplh$min13$inmuxo= 1.0,
      tphl$min13$inmuxo= 1.0,
      tplh$min14$inmuxo= 1.0,
      tphl$min14$inmuxo= 1.0,
      tplh$min15$inmuxo= 1.0,
      tphl$min15$inmuxo= 1.0,
      tplh$prog$inmuxo= 1.0,
      tphl$prog$inmuxo= 1.0,
      tplh$cbit4$inmuxo= 1.0,
      tphl$cbit4$inmuxo= 1.0,
      tplh$cbit3$inmuxo= 1.0,
      tphl$cbit3$inmuxo= 1.0,
      tplh$cbit2$inmuxo= 1.0,
      tphl$cbit2$inmuxo= 1.0,
      tplh$cbit1$inmuxo= 1.0,
      tphl$cbit1$inmuxo= 1.0,
      tplh$cbit0$inmuxo= 1.0,
      tphl$cbit0$inmuxo= 1.0,
      tplh$cbitb4$inmuxo= 1.0,
      tphl$cbitb4$inmuxo= 1.0,
      tplh$cbitb3$inmuxo= 1.0,
      tphl$cbitb3$inmuxo= 1.0,
      tplh$cbitb2$inmuxo= 1.0,
      tphl$cbitb2$inmuxo= 1.0,
      tplh$cbitb1$inmuxo= 1.0,
      tphl$cbitb1$inmuxo= 1.0,
      tplh$cbitb0$inmuxo= 1.0,
      tphl$cbitb0$inmuxo= 1.0;

    // path delays
     (prog *> inmuxo) = (tplh$prog$inmuxo, tphl$prog$inmuxo);
     (cbit[4] *> inmuxo) = (tplh$cbit4$inmuxo, tphl$cbit4$inmuxo);
     (cbit[3] *> inmuxo) = (tplh$cbit3$inmuxo, tphl$cbit3$inmuxo);
     (cbit[2] *> inmuxo) = (tplh$cbit2$inmuxo, tphl$cbit2$inmuxo);
     (cbit[1] *> inmuxo) = (tplh$cbit1$inmuxo, tphl$cbit1$inmuxo);
     (cbit[0] *> inmuxo) = (tplh$cbit0$inmuxo, tphl$cbit0$inmuxo);
     (cbitb[4] *> inmuxo) = (tplh$cbitb4$inmuxo, tphl$cbitb4$inmuxo);
     (cbitb[3] *> inmuxo) = (tplh$cbitb3$inmuxo, tphl$cbitb3$inmuxo);
     (cbitb[2] *> inmuxo) = (tplh$cbitb2$inmuxo, tphl$cbitb2$inmuxo);
     (cbitb[1] *> inmuxo) = (tplh$cbitb1$inmuxo, tphl$cbitb1$inmuxo);
     (cbitb[0] *> inmuxo) = (tplh$cbitb0$inmuxo, tphl$cbitb0$inmuxo);
     (min[0] *> inmuxo) = (tplh$min0$inmuxo, tphl$min0$inmuxo);
     (min[1] *> inmuxo) = (tplh$min1$inmuxo, tphl$min1$inmuxo);
     (min[2] *> inmuxo) = (tplh$min2$inmuxo, tphl$min2$inmuxo);
     (min[3] *> inmuxo) = (tplh$min3$inmuxo, tphl$min3$inmuxo);
     (min[4] *> inmuxo) = (tplh$min4$inmuxo, tphl$min4$inmuxo);
     (min[5] *> inmuxo) = (tplh$min5$inmuxo, tphl$min5$inmuxo);
     (min[6] *> inmuxo) = (tplh$min6$inmuxo, tphl$min6$inmuxo);
     (min[7] *> inmuxo) = (tplh$min7$inmuxo, tphl$min7$inmuxo);
     (min[8] *> inmuxo) = (tplh$min8$inmuxo, tphl$min8$inmuxo);
     (min[9] *> inmuxo) = (tplh$min9$inmuxo, tphl$min9$inmuxo);
     (min[10] *> inmuxo) = (tplh$min10$inmuxo, tphl$min10$inmuxo);
     (min[11] *> inmuxo) = (tplh$min11$inmuxo, tphl$min11$inmuxo);
     (min[12] *> inmuxo) = (tplh$min12$inmuxo, tphl$min12$inmuxo);
     (min[13] *> inmuxo) = (tplh$min13$inmuxo, tphl$min12$inmuxo);
     (min[14] *> inmuxo) = (tplh$min14$inmuxo, tphl$min14$inmuxo);
     (min[15] *> inmuxo) = (tplh$min15$inmuxo, tphl$min15$inmuxo);
  endspecify
`endif

endmodule // in_mux
`endcelldefine

//************************************************
//Title:    primit_in_mux
//Design:   in_mux.v
//Author:  
//Company: SiliconBlue technologies, Inc.
//revision: March 15, 2007
//************************************************

primitive primit_in_mux (y, mf, me, md, mc, mb, ma, m9, m8, m7,
     m6, m5, m4, m3, m2, m1, m0, c4, c3, c2, c1, c0, d4, d3, d2, d1, d0, p);
     
   output y;  
   input mf, me, md, mc, mb, ma, m9, m8, m7, 
         m6, m5, m4, m3, m2, m1, m0, c4, c3, c2, c1, c0, d4, d3, d2, d1, d0, p;

   table

// mf me md mc mb ma m9 m8 m7 m6 m5 m4 m3 m2 m1 m0 c4 c3 c2 c1 c0 d4 d3 d2 d1 d0 p  :  y
//
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  1  0  0  0  0  0  1  1  1  1  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  0  0  0  0  1  1  1  1  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  1  0  0  0  1  0  1  1  1  0  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  1  0  0  0  1  0  1  1  1  0  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  1  0  0  1  0  0  1  1  0  1  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  1  0  0  1  0  0  1  1  0  1  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  1  0  0  1  1  0  1  1  0  0  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  1  0  0  1  1  0  1  1  0  0  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  1  0  1  0  0  0  1  0  1  1  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  1  0  1  0  0  0  1  0  1  1  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  ?  1  0  1  0  1  0  1  0  1  0  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  1  0  1  0  1  0  1  0  1  0  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  ?  ?  1  0  1  1  0  0  1  0  0  1  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  ?  1  0  1  1  0  0  1  0  0  1  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  ?  ?  ?  1  0  1  1  1  0  1  0  0  0  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  ?  ?  1  0  1  1  1  0  1  0  0  0  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  0  0  0  0  1  1  1  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  0  0  0  0  1  1  1  0  :  1;
   ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  0  1  0  0  1  1  0  0  :  0;
   ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  0  1  0  0  1  1  0  0  :  1;
   ?  ?  ?  ?  ?  0  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  1  0  0  0  1  0  1  0  :  0;
   ?  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  1  0  0  0  1  0  1  0  :  1;
   ?  ?  ?  ?  0  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  1  1  0  0  1  0  0  0  :  0;
   ?  ?  ?  ?  1  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  1  1  0  0  1  0  0  0  :  1;
   ?  ?  ?  0  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  0  0  0  0  0  1  1  0  :  0;
   ?  ?  ?  1  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  0  0  0  0  0  1  1  0  :  1;
   ?  ?  0  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  0  1  0  0  0  1  0  0  :  0;
   ?  ?  1  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  0  1  0  0  0  1  0  0  :  1;
   ?  0  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  1  0  0  0  0  0  1  0  :  0;
   ?  1  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  1  0  0  0  0  0  1  0  :  1;
   0  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  1  1  0  0  0  0  0  0  :  0;
   1  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  1  1  0  0  0  0  0  0  :  1;
// mf me md mc mb ma m9 m8 m7 m6 m5 m4 m3 m2 m1 m0 c4 c3 c2 c1 c0 d4 d3 d2 d1 d0 p  :  y  
/*
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  0  ?  ?  ?  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  1  ?  ?  ?  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  0  ?  ?  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  1  ?  ?  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  0  ?  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  1  ?  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  0  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  1  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  0  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  1  0  :  x;
*/
   endtable
endprimitive // primit_in_mux


//************************************************
//Title:    g_mux
//Design:   g_mux.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//Version:  D0.2
//
//INIT: March 15, 2007
//
//Revision : June 9, 2007  Modify module name
//************************************************
`timescale 1ns/10ps
`celldefine
module g_mux (inmuxo, cbit, cbitb, min, prog);

//the output signal
output inmuxo;

//the input signals
input [15:0] min;
input [4:0] cbit, cbitb;
input  prog;

  primit_g_mux (n3, min[15], min[14], min[13], min[12], min[11],
      min[10], min[9], min[8], min[7], min[6], min[5], min[4], 
      min[3], min[2], min[1], min[0], cbit[4], cbit[3], cbit[2], 
      cbit[1], cbit[0], cbitb[4], cbitb[3], cbitb[2], cbitb[1], cbitb[0], prog);
  not(n0, cbit[4]);
  and(n1, n0, cbitb[4]);
  or (n2, prog, n1);
  bufif0(inmuxo, n3, n2);

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
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
      tphl$min7$inmuxo= 1.0,
      tplh$min8$inmuxo= 1.0,
      tphl$min8$inmuxo= 1.0,
      tplh$min9$inmuxo= 1.0,
      tphl$min9$inmuxo= 1.0,
      tplh$min10$inmuxo= 1.0,
      tphl$min10$inmuxo= 1.0,
      tplh$min11$inmuxo= 1.0,
      tphl$min11$inmuxo= 1.0,
      tplh$min12$inmuxo= 1.0,
      tphl$min12$inmuxo= 1.0,
      tplh$min13$inmuxo= 1.0,
      tphl$min13$inmuxo= 1.0,
      tplh$min14$inmuxo= 1.0,
      tphl$min14$inmuxo= 1.0,
      tplh$min15$inmuxo= 1.0,
      tphl$min15$inmuxo= 1.0,
      tplh$prog$inmuxo= 1.0,
      tphl$prog$inmuxo= 1.0,
      tplh$cbit4$inmuxo= 1.0,
      tphl$cbit4$inmuxo= 1.0,
      tplh$cbit3$inmuxo= 1.0,
      tphl$cbit3$inmuxo= 1.0,
      tplh$cbit2$inmuxo= 1.0,
      tphl$cbit2$inmuxo= 1.0,
      tplh$cbit1$inmuxo= 1.0,
      tphl$cbit1$inmuxo= 1.0,
      tplh$cbit0$inmuxo= 1.0,
      tphl$cbit0$inmuxo= 1.0,
      tplh$cbitb4$inmuxo= 1.0,
      tphl$cbitb4$inmuxo= 1.0,
      tplh$cbitb3$inmuxo= 1.0,
      tphl$cbitb3$inmuxo= 1.0,
      tplh$cbitb2$inmuxo= 1.0,
      tphl$cbitb2$inmuxo= 1.0,
      tplh$cbitb1$inmuxo= 1.0,
      tphl$cbitb1$inmuxo= 1.0,
      tplh$cbitb0$inmuxo= 1.0,
      tphl$cbitb0$inmuxo= 1.0;

    // path delays
     (prog *> inmuxo) = (tplh$prog$inmuxo, tphl$prog$inmuxo);
     (cbit[4] *> inmuxo) = (tplh$cbit4$inmuxo, tphl$cbit4$inmuxo);
     (cbit[3] *> inmuxo) = (tplh$cbit3$inmuxo, tphl$cbit3$inmuxo);
     (cbit[2] *> inmuxo) = (tplh$cbit2$inmuxo, tphl$cbit2$inmuxo);
     (cbit[1] *> inmuxo) = (tplh$cbit1$inmuxo, tphl$cbit1$inmuxo);
     (cbit[0] *> inmuxo) = (tplh$cbit0$inmuxo, tphl$cbit0$inmuxo);
     (cbitb[4] *> inmuxo) = (tplh$cbitb4$inmuxo, tphl$cbitb4$inmuxo);
     (cbitb[3] *> inmuxo) = (tplh$cbitb3$inmuxo, tphl$cbitb3$inmuxo);
     (cbitb[2] *> inmuxo) = (tplh$cbitb2$inmuxo, tphl$cbitb2$inmuxo);
     (cbitb[1] *> inmuxo) = (tplh$cbitb1$inmuxo, tphl$cbitb1$inmuxo);
     (cbitb[0] *> inmuxo) = (tplh$cbitb0$inmuxo, tphl$cbitb0$inmuxo);
     (min[0] *> inmuxo) = (tplh$min0$inmuxo, tphl$min0$inmuxo);
     (min[1] *> inmuxo) = (tplh$min1$inmuxo, tphl$min1$inmuxo);
     (min[2] *> inmuxo) = (tplh$min2$inmuxo, tphl$min2$inmuxo);
     (min[3] *> inmuxo) = (tplh$min3$inmuxo, tphl$min3$inmuxo);
     (min[4] *> inmuxo) = (tplh$min4$inmuxo, tphl$min4$inmuxo);
     (min[5] *> inmuxo) = (tplh$min5$inmuxo, tphl$min5$inmuxo);
     (min[6] *> inmuxo) = (tplh$min6$inmuxo, tphl$min6$inmuxo);
     (min[7] *> inmuxo) = (tplh$min7$inmuxo, tphl$min7$inmuxo);
     (min[8] *> inmuxo) = (tplh$min8$inmuxo, tphl$min8$inmuxo);
     (min[9] *> inmuxo) = (tplh$min9$inmuxo, tphl$min9$inmuxo);
     (min[10] *> inmuxo) = (tplh$min10$inmuxo, tphl$min10$inmuxo);
     (min[11] *> inmuxo) = (tplh$min11$inmuxo, tphl$min11$inmuxo);
     (min[12] *> inmuxo) = (tplh$min12$inmuxo, tphl$min12$inmuxo);
     (min[13] *> inmuxo) = (tplh$min13$inmuxo, tphl$min12$inmuxo);
     (min[14] *> inmuxo) = (tplh$min14$inmuxo, tphl$min14$inmuxo);
     (min[15] *> inmuxo) = (tplh$min15$inmuxo, tphl$min15$inmuxo);
  endspecify
`endif

endmodule // g_mux
`endcelldefine

//************************************************
//Title:    primit_g_mux
//Design:   g_mux.v
//Author:  
//Company: SiliconBlue technologies, Inc.
//revision: March 15, 2007
//************************************************

primitive primit_g_mux (y, mf, me, md, mc, mb, ma, m9, m8, m7,
     m6, m5, m4, m3, m2, m1, m0, c4, c3, c2, c1, c0, d4, d3, d2, d1, d0, p);
     
   output y;  
   input mf, me, md, mc, mb, ma, m9, m8, m7, 
         m6, m5, m4, m3, m2, m1, m0, c4, c3, c2, c1, c0, d4, d3, d2, d1, d0, p;

   table

// mf me md mc mb ma m9 m8 m7 m6 m5 m4 m3 m2 m1 m0 c4 c3 c2 c1 c0 d4 d3 d2 d1 d0 p  :  y
//
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  1  0  0  0  0  0  1  1  1  1  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  0  0  0  0  1  1  1  1  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  1  0  0  0  1  0  1  1  1  0  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  1  0  0  0  1  0  1  1  1  0  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  1  0  0  1  0  0  1  1  0  1  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  1  0  0  1  0  0  1  1  0  1  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  1  0  0  1  1  0  1  1  0  0  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  1  0  0  1  1  0  1  1  0  0  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  1  0  1  0  0  0  1  0  1  1  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  1  0  1  0  0  0  1  0  1  1  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  ?  1  0  1  0  1  0  1  0  1  0  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  1  0  1  0  1  0  1  0  1  0  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  ?  ?  1  0  1  1  0  0  1  0  0  1  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  ?  1  0  1  1  0  0  1  0  0  1  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  ?  ?  ?  1  0  1  1  1  0  1  0  0  0  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  ?  ?  1  0  1  1  1  0  1  0  0  0  0  :  1;
   ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  0  0  0  0  1  1  1  0  :  0;
   ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  0  0  0  0  1  1  1  0  :  1;
   ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  0  1  0  0  1  1  0  0  :  0;
   ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  0  1  0  0  1  1  0  0  :  1;
   ?  ?  ?  ?  ?  0  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  1  0  0  0  1  0  1  0  :  0;
   ?  ?  ?  ?  ?  1  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  1  0  0  0  1  0  1  0  :  1;
   ?  ?  ?  ?  0  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  1  1  0  0  1  0  0  0  :  0;
   ?  ?  ?  ?  1  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  0  1  1  0  0  1  0  0  0  :  1;
   ?  ?  ?  0  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  0  0  0  0  0  1  1  0  :  0;
   ?  ?  ?  1  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  0  0  0  0  0  1  1  0  :  1;
   ?  ?  0  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  0  1  0  0  0  1  0  0  :  0;
   ?  ?  1  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  0  1  0  0  0  1  0  0  :  1;
   ?  0  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  1  0  0  0  0  0  1  0  :  0;
   ?  1  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  1  0  0  0  0  0  1  0  :  1;
   0  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  1  1  0  0  0  0  0  0  :  0;
   1  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  1  1  1  1  0  0  0  0  0  0  :  1;
// mf me md mc mb ma m9 m8 m7 m6 m5 m4 m3 m2 m1 m0 c4 c3 c2 c1 c0 d4 d3 d2 d1 d0 p  :  y  
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  0  ?  ?  ?  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  1  ?  ?  ?  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  0  ?  ?  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  1  ?  ?  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  0  ?  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  1  ?  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  0  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  1  ?  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  0  ?  ?  ?  ?  0  0  :  x;
   ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  ?  1  ?  ?  ?  ?  1  0  :  x;

   endtable
endprimitive // primit_g_mux


//************************************************
//Title:    cram_cell_4
//Design:   cram_cell_4.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//Version:  D0.1
//
//INIT: June 9, 2007
//
//************************************************
`timescale 1ns/10ps
`celldefine
module eh_cram_cell_4 (q, q_b, bl, pgate, r_vdd, wl, reset);

//bi-direct Signals
inout bl;

//output signals
output q, q_b;

//input signals
input wl, reset, r_vdd, pgate;

//internal signals
reg q, q_b;
reg blout;
reg oe=1;
wire blin;

assign blin = bl;
assign bl = (!oe) ? blout : 1'bz; 

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$wl$q = 1.0,
      tphl$wl$q = 1.0,
      tplh$reset$q = 1.0,
      tphl$reset$q = 1.0,
      tplh$r_vdd$q = 1.0,
      tphl$r_vdd$q = 1.0,
      tplh$pgate$q = 1.0,
      tphl$pgate$q = 1.0,
      tplh$bl$q = 1.0,
      tphl$bl$q = 1.0,
      tplh$wl$q_b = 1.0,
      tphl$wl$q_b = 1.0,
      tplh$reset$q_b = 1.0,
      tphl$reset$q_b = 1.0,
      tplh$r_vdd$q_b = 1.0,
      tphl$r_vdd$q_b = 1.0,
      tplh$pgate$q_b = 1.0,
      tphl$pgate$q_b = 1.0,
      tplh$bl$q_b = 1.0,
      tphl$bl$q_b = 1.0,
      tplh$wl$bl = 1.0,
      tphl$wl$bl = 1.0,
      tplh$reset$bl = 1.0,
      tphl$reset$bl = 1.0,
      tplh$r_vdd$bl = 1.0,
      tphl$r_vdd$bl = 1.0,
      tplh$pgate$bl = 1.0,
      tphl$pgate$bl = 1.0;
      
    // path delays
     (wl *> q) = (tplh$wl$q, tphl$wl$q);
     (reset *> q) = (tplh$reset$q, tphl$reset$q);
     (r_vdd *> q) = (tplh$r_vdd$q, tphl$r_vdd$q);
     (pgate *> q) = (tplh$pgate$q, tphl$pgate$q);
     (bl *> q) = (tplh$bl$q, tphl$bl$q);
     (wl *> q_b) = (tplh$wl$q_b, tphl$wl$q_b);
     (reset *> q_b) = (tplh$reset$q_b, tphl$reset$q_b);
     (r_vdd *> q_b) = (tplh$r_vdd$q_b, tphl$r_vdd$q_b);
     (pgate *> q_b) = (tplh$pgate$q_b, tphl$pgate$q_b);
     (bl *> q_b) = (tplh$bl$q_b, tphl$bl$q_b);
     (wl *> bl) = (tplh$wl$bl, tphl$wl$bl);
     (reset *> bl) = (tplh$reset$bl, tphl$reset$bl);
     (r_vdd *> bl) = (tplh$r_vdd$bl, tphl$r_vdd$bl);
     (pgate *> bl) = (tplh$pgate$bl, tphl$pgate$bl);
  endspecify
`endif

always @ (wl or reset or pgate or r_vdd or blin) begin
   if (!wl & reset & !pgate & (r_vdd!==1)) begin blout=0; oe =1'b1; q = 1'b0; q_b = 1'b1; end
   else if (wl & !reset & pgate & r_vdd & ~blin) begin blout = 0; oe = 1'b1; q = 1'b1; q_b = 1'b0; end
   else if (wl & !reset & !pgate & r_vdd) begin blout = !q; oe = 1'b0; q = q; q_b = q_b; end
   else if (!wl & !reset & !pgate & r_vdd) begin blout = 0; oe = 1'b1; q = q; q_b = q_b; end
   end

endmodule  //cram_cell_4
`endcelldefine
//************************************************
//Title:    coredffr
//Design:   cordeffr.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//Version:  D0.2
//
//INIT: March 15, 2007
//
//Revision : June 9, 2007  Modify name, add purst.
//           and change polarity
//************************************************
`timescale 1ns/10ps
module coredffr (q, d, purst, S_R, cbit, clk, clkb);
output q;
input d, purst, S_R, clk, clkb;
input [1:0] cbit;


`ifdef TIMINGCHECK
reg NOTIFIER;

  specify
    specparam
    tplh$sr$q = 1.0,
    tphl$sr$q = 1.0,
    tplh$purst$q = 1.0,
    tphl$purst$q  = 1.0,
    tplh$clk$q = 1.0,
    tphl$clk$q = 1.0,
    tsetup$d$clk = 1.0,
    thold$d$clk	= 1.0,
    tsetup$srsr$clk = 1.0,
    thold$srsr$clk = 1.0,
    tminpwh$sr     = 1.0,
    tminpwl$clk    = 1.0,
    tminpwh$clk    = 1.0;

//path delays
    if (S_R == 1'b0)
      (posedge clk *> (q +: d)) = (tplh$clk$q, tphl$clk$q);
    (posedge purst *> (q  +: 0) ) = (tplh$purst$q, tphl$purst$q);
    if (cbit[1:0] == 2'b10)
      (posedge S_R *> (q  +: 1) ) = (tplh$sr$q, tphl$sr$q);
    if (cbit[1:0] == 2'b11)
      (posedge S_R *> (q  +: 0) ) = (tplh$sr$q, tphl$sr$q);
    if (cbit[1:0] == 2'b00)
      (posedge clk *> (q +: 1)) = (tplh$sr$q, tphl$sr$q);
    if (cbit[1:0] == 2'b01)
      (posedge clk *> (q +: 0)) = (tplh$sr$q, tphl$sr$q);

//timing checks     
    $setuphold(posedge clk &&& (S_R == 1'b0), posedge d, tsetup$d$clk, thold$d$clk, NOTIFIER);
    $setuphold(posedge clk &&& (S_R == 1'b0), negedge d, tsetup$d$clk, thold$d$clk, NOTIFIER);    
    $setuphold(posedge clk &&& (cbit[1] == 1'b0), posedge S_R , tsetup$srsr$clk, thold$srsr$clk, NOTIFIER);
    $width(posedge S_R &&& (cbit[1] == 1'b1), tminpwh$sr, 0, NOTIFIER);
    $width(negedge clk, tminpwl$clk, 0, NOTIFIER);
    $width(posedge clk, tminpwh$clk, 0, NOTIFIER); 
   endspecify
`endif

reg qint;  
wire intasr;
assign intasr = purst || (S_R && cbit[1]);

assign q = (((purst ^ S_R ^ cbit[0] ^ cbit[1])==1) || ((purst ^ S_R ^ cbit[0] ^ cbit[1])==0)) ? qint : 1'bx;

always @(posedge intasr or posedge clk)
   if (S_R && cbit===2'b11) qint <= 1;
   else if (!purst && S_R && cbit===2'b10) qint <= 0;
   else if (purst && !S_R) qint <= 0;
   else begin
      if (!purst && S_R && cbit===2'b00) qint <= 1'b0;
      else if (!purst && S_R && cbit===2'b01) qint <= 1'b1;
      else if (!purst&& !S_R) qint <= d;
      end
      
endmodule // coredffr

//************************************************
//Title:    clut4
//Design:   clut4.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//Version:  D0.2
//
//INIT: March 15, 2007
//
//Revision : June 9, 2007  Modify port names
//************************************************
`timescale 1ns/10ps
module clut4 (lut4, in0, in1, in2, in3, in0b, in1b, in2b, in3b, cbit);

//the output signal
output lut4;

//the input signals
input in0, in1, in2, in3, in0b, in1b, in2b, in3b;
input [15:0] cbit;

reg lut4;
      
`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$cbit0$lut4= 1.0,
      tphl$cbit0$lut4= 1.0,
      tplh$cbit1$lut4= 1.0,
      tphl$cbit1$lut4= 1.0,
      tplh$cbit2$lut4= 1.0,
      tphl$cbit2$lut4= 1.0,
      tplh$cbit3$lut4= 1.0,
      tphl$cbit3$lut4= 1.0,
      tplh$cbit4$lut4= 1.0,
      tphl$cbit4$lut4= 1.0,
      tplh$cbit5$lut4= 1.0,
      tphl$cbit5$lut4= 1.0,
      tplh$cbit6$lut4= 1.0,
      tphl$cbit6$lut4= 1.0,
      tplh$cbit7$lut4= 1.0,
      tphl$cbit7$lut4= 1.0,
      tplh$cbit8$lut4= 1.0,
      tphl$cbit8$lut4= 1.0,
      tplh$cbit9$lut4= 1.0,
      tphl$cbit9$lut4= 1.0,
      tplh$cbit10$lut4= 1.0,
      tphl$cbit10$lut4= 1.0,
      tplh$cbit11$lut4= 1.0,
      tphl$cbit11$lut4= 1.0,
      tplh$cbit12$lut4= 1.0,
      tphl$cbit12$lut4= 1.0,
      tplh$cbit13$lut4= 1.0,
      tphl$cbit13$lut4= 1.0,
      tplh$cbit14$lut4= 1.0,
      tphl$cbit14$lut4= 1.0,
      tplh$cbit15$lut4= 1.0,
      tphl$cbit15$lut4= 1.0,
      tplh$in3$lut4= 1.0,
      tphl$in3$lut4= 1.0,
      tplh$in2$lut4= 1.0,
      tphl$in2$lut4= 1.0,
      tplh$in1$lut4= 1.0,
      tphl$in1$lut4= 1.0,
      tplh$in0$lut4= 1.0,
      tphl$in0$lut4= 1.0;
      tplh$in3b$lut4= 1.0,
      tphl$in3b$lut4= 1.0,
      tplh$in2b$lut4= 1.0,
      tphl$in2b$lut4= 1.0,
      tplh$in1b$lut4= 1.0,
      tphl$in1b$lut4= 1.0,
      tplh$in0b$lut4= 1.0,
      tphl$in0b$lut4= 1.0;

    // path delays
     (cbit[15] *> lut4) = (tplh$cbit15$lut4, tphl$cbit15$lut4);
     (cbit[14] *> lut4) = (tplh$cbit14$lut4, tphl$cbit14$lut4);
     (cbit[13] *> lut4) = (tplh$cbit13$lut4, tphl$cbit13$lut4);
     (cbit[12] *> lut4) = (tplh$cbit12$lut4, tphl$cbit12$lut4);
     (cbit[11] *> lut4) = (tplh$cbit11$lut4, tphl$cbit11$lut4);
     (cbit[10] *> lut4) = (tplh$cbit10$lut4, tphl$cbit10$lut4);
     (cbit[9] *> lut4) = (tplh$cbit9$lut4, tphl$cbit9$lut4);
     (cbit[8] *> lut4) = (tplh$cbit8$lut4, tphl$cbit8$lut4);
     (cbit[7] *> lut4) = (tplh$cbit7$lut4, tphl$cbit7$lut4);
     (cbit[6] *> lut4) = (tplh$cbit6$lut4, tphl$cbit6$lut4);
     (cbit[5] *> lut4) = (tplh$cbit5$lut4, tphl$cbit5$lut4);
     (cbit[4] *> lut4) = (tplh$cbit4$lut4, tphl$cbit4$lut4);
     (cbit[3] *> lut4) = (tplh$cbit3$lut4, tphl$cbit3$lut4);
     (cbit[2] *> lut4) = (tplh$cbit2$lut4, tphl$cbit2$lut4);
     (cbit[1] *> lut4) = (tplh$cbit1$lut4, tphl$cbit1$lut4);
     (cbit[0] *> lut4) = (tplh$cbit0$lut4, tphl$cbit0$lut4);
     (in3 *> lut4) = (tplh$in3$lut4, tphl$in3$lut4);
     (in2 *> lut4) = (tplh$in2$lut4, tphl$in2$lut4);
     (in1 *> lut4) = (tplh$in1$lut4, tphl$in1$lut4);
     (in0 *> lut4) = (tplh$in0$lut4, tphl$in0$lut4);     
     (in3b *> lut4) = (tplh$in3b$lut4, tphl$in3b$lut4);
     (in2b *> lut4) = (tplh$in2b$lut4, tphl$in2b$lut4);
     (in1b *> lut4) = (tplh$in1b$lut4, tphl$in1b$lut4);
     (in0b *> lut4) = (tplh$in0b$lut4, tphl$in0b$lut4);     
  endspecify
`endif

   always @(in0 or in1 or in2 or in3 or in0b or in1b or in2b or in3b or cbit)
      if ({in3, in2, in1, in0} != ~{in3b, in2b, in1b, in0b}) lut4 = 1'bx;
      //else if (cbit == 16'h0) lut4= 1'b0;
      else
      case ({in3, in2, in1, in0})
         4'b0000: lut4 = cbit[0] ;
         4'b0001: lut4 = cbit[1] ;
         4'b0010: lut4 = cbit[2] ;
         4'b0011: lut4 = cbit[3] ;
         4'b0100: lut4 = cbit[4] ;
         4'b0101: lut4 = cbit[5] ;
         4'b0110: lut4 = cbit[6] ;
         4'b0111: lut4 = cbit[7] ;
         4'b1000: lut4 = cbit[8] ;
         4'b1001: lut4 = cbit[9] ;
         4'b1010: lut4 = cbit[10] ;
         4'b1011: lut4 = cbit[11] ;
         4'b1100: lut4 = cbit[12] ;
         4'b1101: lut4 = cbit[13] ;
         4'b1110: lut4 = cbit[14] ;
         4'b1111: lut4 = cbit[15] ;
         default: lut4 = 1'bx;
        endcase


endmodule // clut4

//************************************************
//Title:    carry_logic
//Design:   carry_logic.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//Version:  D0.1
//
//INIT: June 8, 2007
//************************************************
`timescale 1ns/10ps
`celldefine
module carry_logic (cout, carry_in, a, a_bar, b, b_bar, vg_en);

//the output signal
output cout;

//the input signals
input carry_in, a, a_bar, b, b_bar, vg_en;

`ifdef TIMINGCHECK  
  specify
    // delay parameters
    specparam
      tplh$carry_in$cout= 1.0,
      tphl$carry_in$cout= 1.0,
      tplh$a$cout= 1.0,
      tphl$a$cout= 1.0,
      tplh$a_bar$cout= 1.0,
      tphl$a_bar$cout= 1.0,
      tplh$b$cout= 1.0,
      tphl$b$cout= 1.0,
      tplh$b_bar$cout= 1.0,
      tphl$b_bar$cout= 1.0,
      tplh$vg_en$cout= 1.0,
      tphl$vg_en$cout= 1.0;

    // path delays
     (carry_in *> cout) = (tplh$carry_in$cout, tphl$carry_in$cout);
     (a *> cout) = (tplh$a$cout, tphl$a$cout);
     (a_bar *> cout) = (tplh$a_bar$cout, tphl$a_bar$cout);
     (b *> cout) = (tplh$b$cout, tphl$b$cout);
     (b_bar *> cout) = (tplh$b_bar$cout, tphl$b_bar$cout);
     (vg_en *> cout) = (tplh$vg_en$cout, tphl$vg_en$cout); 
  endspecify
`endif
  
  primit_carry_logic (cout, vg_en, carry_in, a, b );

endmodule // carry_logic
`endcelldefine

//************************************************
//Title:    primit_carry_logic
//Design:   carry_logic.v
//Author:  
//Company: SiliconBlue technologies, Inc.
//revision: June 9, 2007
//************************************************

primitive primit_carry_logic (y, v, c, a, b);
   output y;  
   input  v, c, a, b;

   table

// v  c  a  b  :  y
//
   0  ?  ?  ?  :  1;
   1  0  0  0  :  0;
   1  0  0  1  :  0;
   1  0  1  0  :  0;
   1  0  1  1  :  1;
   1  1  0  0  :  0;
   1  1  0  1  :  1;
   1  1  1  0  :  1;
   1  1  1  1  :  1;
   endtable
endprimitive // primit_o_mux

module bus_keeper_18_g (Y, A, gnd_node);
    inout Y;
    input A;
    input gnd_node;

reg Y_reg;
assign Y = Y_reg;
always @ (A or gnd_node)
begin
if ((A)&&(gnd_node == 0))
	Y_reg=1'b0;
else
	Y_reg = 1'b1;
if (A == 1'bx)
	Y_reg = 1'bx;
	end

endmodule

module bus_keeper_18 (Y, A);
    output Y;
    input A;


reg Y_reg;
assign Y = Y_reg;
always @ (A)
begin
if (A)
	Y_reg=1'b0;
else 
	Y_reg = 1'b1;
if (A == 1'bx)
	Y_reg = 1'bx;
end

endmodule

module bus_keeper_33_g (Y, A, gnd_node);
    inout Y;
    input A;
    input gnd_node;

reg Y_reg;
assign Y = Y_reg;
always @ (A or gnd_node)
begin
if ((A)&&(gnd_node == 0))
	Y_reg=1'b0;
else
	Y_reg = 1'b1;
if (A == 1'bx)
	Y_reg = 1'bx;
	end

endmodule

module bus_keeper_hvt_g (Y, A, gnd_node);
    inout Y;
    input A;
    input gnd_node;

reg Y_reg;
assign Y = Y_reg;
always @ (A or gnd_node)
begin
if ((A)&&(gnd_node == 0))
	Y_reg=1'b0;
else
	Y_reg = 1'b1;
if (A == 1'bx)
	Y_reg = 1'bx;
	end

endmodule

module cram_cell_3 (q, q_b, bl, r_gnd, reset_b, wl);
    output q;
    output q_b;
    inout bl;
    input r_gnd;
    input reset_b;
    input wl;
reg q,blreg;
always @(bl or r_gnd or reset_b or wl)
if ((r_gnd == 1'b0) && (reset_b == 1'b0)) q = 1'b0;
else if ((wl == 1'b1) && (bl == 1'b0)) q = 1'b1;

assign q_b = !q;

always @(q or wl)
if (wl == 1'b1) blreg = q;
endmodule

module creset_filter ( out, in );

  input in;
  output out;
  
  buf #(0,20) (out, in);
  
endmodule

`define por_delay 100
module eh_core_pup_2 ( por_b );
output por_b;
reg por_b = 0;

initial begin
# `por_delay ;
por_b = 1;
end
endmodule

module eh_io_pup_2 ( por_b, core_por_b, vdd_io );

  input core_por_b;
  input vdd_io;
  output por_b;

  assign por_b = core_por_b & vdd_io;

endmodule

module ml_rowdrvsup2 ( wl_rd_sup, wl_rden_b );

  inout wl_rden_b;
  inout wl_rd_sup;
  assign wl_rd_sup = ~wl_rden_b;
  pullup(wl_rden_b);
endmodule

module mux2_defaultHigh (Y, A, S0);
    output Y;
    input A;
    input S0;
reg Y;
always @ (A or S0)
if (S0 == 1'b0) Y=1'b1;
else Y = A;
endmodule

module oscillator_biasp (biasp, en);
    output biasp;
    input en;
assign biasp = !en;
endmodule
module oscillator_stage (stage_out, bias_p, opt_, stage_in);
    output stage_out;
    input bias_p;
    input [4:0] opt_;
    input stage_in;
reg stage_out;
always @ (bias_p or opt_[4] or opt_[3] or opt_[2] or opt_[1] or opt_[0] or stage_in)

begin
 if ((bias_p == 1'b0) && ((opt_[4] == 1'b1) || (opt_[3] == 1'b1) || (opt_[2] == 1'b1) || (opt_[1] == 1'b1) || (opt_[0] == 1'b1))) stage_out = !stage_in; 
else stage_out = 1'bz;

end


endmodule

module rf_4k ( AA, D, BWEB, WEB, CLKW, AB, REB, CLKR, AMA, BWEBM, WEBM, AMB,
    REBM, BIST, Q, DM );

  input WEBM;
  input  [7:0] AMB;
  input  [7:0] AMA;
  input WEB;
  input CLKW;
  input  [7:0] AB;
  input  [15:0] DM;
  input CLKR;
  input BIST;
  input  [15:0] BWEBM;
  input  [15:0] D;
  input  [15:0] BWEB;
  input  [7:0] AA;
  output  [15:0] Q;
  input REBM;
  input REB;
  
  TS6N65LPA256X16M4M I_TS6N65LPA256X16M4M
  (
  .AA(AA),
  .D(D),
  .BWEB(BWEB),
  .WEB(WEB),.CLKW(CLKW),
  .AB(AB),
  .REB(REB),.CLKR(CLKR),
  .AMA(AMA),
  .DM({DM[15],DM[14:0]}),
  .BWEBM(BWEBM),
  .WEBM(WEBM),
  .AMB(AMB),
  .REBM(REBM),.BIST(BIST),
  .Q(Q)
  );
    
endmodule

module rf_dffr_4x (q, q_b, clk, d, reset);
    output q, q_b;
    input clk;
    input d;
    input reset;


reg data;

always @(posedge reset) data = 0;

always @(posedge clk)
begin
     if (reset) data = 0;
     else       data = d;
end

assign q = data;
assign q_b = ~q;
 
   
endmodule

module tiehi ( tiehi );

  output tiehi;
  buf (tiehi, 1'b1);
  
endmodule
//Verilog HDL for "leafcell", "tielo" "functional"

`timescale 1ns/1ns

module tielo ( tielo );

  output tielo;
  buf (tielo, 1'b0);
  
endmodule

module bus_keeper_g (Y, A, gnd_node);
    inout Y;
    input A;
    input gnd_node;

reg Y_reg;
assign Y = Y_reg;
always @ (A or gnd_node)
begin
if ((A)&&(gnd_node == 0))
	Y_reg=1'b0;
else
	Y_reg = 1'b1;
if (A == 1'bx)
	Y_reg = 1'bx;
	end

endmodule

module ml_osc(clk_out, smc_osc_fsel, smc_oscen );
   input         smc_oscen;
   input  [1:0]  smc_osc_fsel;
   output        clk_out;

   integer on_delay = 230;
   integer period_50m = 20;
   integer period_30m = 33;
   integer period_10m = 100;
   integer clkperiod;

//Signal declaration   
wire [3:0] sel_trim;
wire clk_out;
wire oscen_b;
reg clk_dffin;
reg clkby2_b;
initial clk_dffin = 0;

//oscillator turn-on delay
reg oscstate;
initial oscstate=0;
always @(posedge smc_oscen or negedge smc_oscen)
  if (smc_oscen) #on_delay oscstate <= 1;
  else if (~smc_oscen) oscstate <= 0;

//2x oscillator
always @(sel_trim or smc_oscen) begin
  if (sel_trim==4'b1110) clkperiod = period_10m/4;
  else if (sel_trim==4'b1010) clkperiod = period_30m/4;
  else clkperiod = period_50m/4; 
  disable generator; 
  end    
always begin : generator
   forever #clkperiod clk_dffin = ~clk_dffin && oscstate;
   end

//Ouput clock divider
assign oscen_b = ~smc_oscen;
assign clk_out = ~clkby2_b;
always @(posedge clk_dffin or posedge oscen_b)
   if (oscen_b) clkby2_b <= 1;
   else clkby2_b <= ~clkby2_b;

//losc_logic sub-block;
osc_logic osc_logic (.clkin(clk_out), .smc_oscen(smc_oscen), .smc_osc_fsel(smc_osc_fsel), .sel_trim(sel_trim) );

      
endmodule  // lml_osc

module osc_logic (clkin, smc_oscen, smc_osc_fsel, sel_trim);
   input clkin;
   input smc_oscen;
   input [1:0] smc_osc_fsel;
   output [3:0] sel_trim;

//Signal declaration 
wire [2:0] in_sel;
wire clkin_buf_b;
wire reset_ff;
wire clkin_buf;
wire clkin_buf_delay;
reg i174q;
reg i238q;
reg i242q;
reg i243q;
reg i245q;
reg i244q;

//Combinational Logic
assign sel_trim[3] = 1'b1;
assign sel_trim[2] = (clkin_buf_delay) ? ~i238q : ~i174q;
assign sel_trim[1] = (clkin_buf_delay) ? ~i243q : ~i242q;
assign sel_trim[0] = (clkin_buf_delay) ?  i244q :  i245q;
assign in_sel[2] = ~(smc_osc_fsel[1] || smc_osc_fsel[0]); 
assign in_sel[1] = ~smc_osc_fsel[1];
assign clkin_buf_b= ~clkin;
assign reset_ff = ~smc_oscen;
assign clkin_buf = clkin;
assign #1 clkin_buf_delay = clkin_buf;

//Register frequecy select
always @(posedge clkin_buf_b or posedge reset_ff) begin
   if (reset_ff) begin 
      i174q <= 0;
      i242q <= 0;
      i245q <= 0;
      end
   else begin
      i174q <= ~in_sel[2];
      i242q <= ~in_sel[1];
      i245q <= smc_osc_fsel[1];
      end      
end
   
always @(posedge clkin_buf or posedge reset_ff) begin
   if (reset_ff) begin 
      i238q <= 0;
      i243q <= 0;
      i244q <= 0;
      end
   else begin
      i238q <= ~in_sel[2];
      i243q <= ~in_sel[1];
      i244q <= smc_osc_fsel[1];
      end      
end
 
endmodule // osc_logic

module rm7 (MINUS, PLUS);
	inout MINUS;
	inout	PLUS;

tran t1(MINUS, PLUS);
endmodule

module rm6 (MINUS, PLUS);
	inout MINUS;
	inout	PLUS;

tran t1(MINUS, PLUS);
endmodule

module rm5 (MINUS, PLUS);
	inout MINUS;
	inout	PLUS;

tran t1(MINUS, PLUS);
endmodule

module tiehi4x ( tiehi );

  output tiehi;
  buf (tiehi, 1'b1);
  
endmodule

module tielo4x ( tielo );

  output tielo;
  buf (tielo, 1'b0);
  
endmodule

//************************************************
//Title:    dffrqn
//Design:   dffrqn.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//Version:  D0.1
//
//INIT: Dec 11, 2007
//
//Revision : 
//           
//************************************************
module dffrqn ( q, qn, clk, d, r );

output  q, qn;
input  clk, d, r;

`ifdef TIMINGCHECK
reg NOTIFIER;

  specify
    specparam
    tplh$r$q = 1.0,
    tphl$r$q = 1.0,
    tplh$r$qn = 1.0,
    tphl$r$qn = 1.0,
    tplh$clk$q = 1.0,
    tphl$clk$q = 1.0,
    tplh$clk$qn = 1.0,
    tphl$clk$qn = 1.0,
    tsetup$d$clk = 1.0,
    thold$d$clk	= 1.0,
    tminpwh$r     = 1.0,
    tminpwl$clk    = 1.0,
    tminpwh$clk    = 1.0;

//path delays
    if (r == 1'b0)
      (posedge clk *> (q +: d)) = (tplh$clk$q, tphl$clk$q);
    if (r == 1'b0)
      (posedge clk *> (qn +: d)) = (tplh$clk$qn, tphl$clk$qn);
    (posedge r *> (q  +: 0) ) = (tplh$r$q, tphl$r$q);
    (posedge r *> (qn  +: 0) ) = (tplh$r$qn, tphl$r$qn);
      
//timing checks     
    $setuphold(posedge clk &&& (r == 1'b0), posedge d, tsetup$d$clk, thold$d$clk, NOTIFIER);
    $setuphold(posedge clk &&& (r == 1'b0), negedge d, tsetup$d$clk, thold$d$clk, NOTIFIER);    
    $width(posedge), tminpwh$r, 0, NOTIFIER);
    $width(negedge clk, tminpwl$clk, 0, NOTIFIER);
    $width(posedge clk, tminpwh$clk, 0, NOTIFIER); 
   endspecify
`endif

reg q, qn;

always @(posedge clk or posedge r) 
   if (r) begin q <= 0; qn <= 1; end
   else begin q <= d; qn <= ~d; end
endmodule

//************************************************
//Title:    dffrckb
//Design:   dffrckb.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//Version:  D0.1
//
//INIT: Dec 11, 2007
//
//Revision : 
//           
//************************************************
module dffrckb ( q, qn, clk, d, e, r );
output  q, qn;
input  clk, d, e, r;

`ifdef TIMINGCHECK
reg NOTIFIER;

  specify
    specparam
    tplh$r$q = 1.0,
    tphl$r$q = 1.0,
    tplh$r$qn = 1.0,
    tphl$r$qn = 1.0,
    tplh$clk$q = 1.0,
    tphl$clk$q = 1.0,
    tplh$clk$qn = 1.0,
    tphl$clk$qn = 1.0,
    tsetup$d$clk = 1.0,
    thold$d$clk	= 1.0,
    tsetup$e$clk = 1.0,
    thold$e$clk	= 1.0,
    tminpwh$r     = 1.0,
    tminpwl$clk    = 1.0,
    tminpwh$clk    = 1.0;

//path delays
    if (r == 1'b0 &&& (e == 1'b1))
      (negedge clk *> (q +: d)) = (tplh$clk$q, tphl$clk$q);
    if (r == 1'b0 &&& (e == 1'b1))
      (negedge clk *> (qn +: d)) = (tplh$clk$qn, tphl$clk$qn);
    (negedge r *> (q  +: 0) ) = (tplh$r$q, tphl$r$q);
    (negedge r *> (qn  +: 0) ) = (tplh$r$qn, tphl$r$qn);
      
//timing checks     
    $setuphold(negedge clk &&& (r == 1'b0), posedge d, tsetup$d$clk, thold$d$clk, NOTIFIER);
    $setuphold(negedge clk &&& (r == 1'b0), negedge d, tsetup$d$clk, thold$d$clk, NOTIFIER);  
    $setuphold(negedge clk &&& (r == 1'b0), posedge e, tsetup$e$clk, thold$e$clk, NOTIFIER);  
    $setuphold(negedge clk &&& (r == 1'b0), negedge e, tsetup$e$clk, thold$e$clk, NOTIFIER);  
    $width(posedge), tminpwh$r, 0, NOTIFIER);
    $width(negedge clk, tminpwl$clk, 0, NOTIFIER);
    $width(posedge clk, tminpwh$clk, 0, NOTIFIER); 
   endspecify
`endif

reg q, qn;

always @(negedge clk or posedge r) 
   if (r) begin q <= 0; qn <= 1; end
   else if (e) begin q <= d; qn <= ~d; end

endmodule

//************************************************
//Title:    clk_mux2to1
//Design:   clk_mux2to1.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//revision: Jan 24, 2008
//************************************************

module clk_mux2to1 ( clk, cbit, cbitb, min, prog );

output  clk;
input  cbit, cbitb, prog;
input [1:0]  min;

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$cbit$clk= 1.0,
      tphl$cbit$clk= 1.0,
      tplh$cbitb$clk= 1.0,
      tphl$cbitb$clk= 1.0,
      tplh$prog$clk= 1.0,
      tphl$prog$clk= 1.0,
      tplh$min0$clk= 1.0,
      tphl$min0$clk= 1.0,
      tplh$min1$clk= 1.0,
      tphl$min1$clk= 1.0,
    // path delays
     (cbit *> clk) = (tplh$cbit$clk, tphl$cbit$clk);
     (cbitb *> clk) = (tplh$cbitb$clk, tphl$cbitb$clk);
     (prog *> clk) = (tplh$prog$clk, tphl$prog$clk);
     (min[0] *> clk) = (tplh$min0$clk, tphl$min0$clk);
     (min[1] *> clk) = (tplh$min1$clk, tphl$min1$clk);
   endspecify
`endif

reg clk;

always @ (cbit or cbitb or prog or min) begin
   if (prog==1) clk <= 0;
   else if (prog==0 && cbit==0) clk <= min[0];
   else if (prog==0 && cbit==1) clk <= min[1];
   else clk <= 1'bx;

end

endmodule //clk_mux2to1

//************************************************
//Title:    clk_mux2to18k
//Design:   clk_mux2to18k.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//revision: Jan 24, 2008
//************************************************

module clk_mux2to18k ( clk, cbit, cbitb, min, prog );

output  clk;
input  cbit, cbitb, prog;
input [1:0]  min;

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$cbit$clk= 1.0,
      tphl$cbit$clk= 1.0,
      tplh$cbitb$clk= 1.0,
      tphl$cbitb$clk= 1.0,
      tplh$prog$clk= 1.0,
      tphl$prog$clk= 1.0,
      tplh$min0$clk= 1.0,
      tphl$min0$clk= 1.0,
      tplh$min1$clk= 1.0,
      tphl$min1$clk= 1.0,
    // path delays
     (cbit *> clk) = (tplh$cbit$clk, tphl$cbit$clk);
     (cbitb *> clk) = (tplh$cbitb$clk, tphl$cbitb$clk);
     (prog *> clk) = (tplh$prog$clk, tphl$prog$clk);
     (min[0] *> clk) = (tplh$min0$clk, tphl$min0$clk);
     (min[1] *> clk) = (tplh$min1$clk, tphl$min1$clk);
   endspecify
`endif

reg clk;

always @ (cbit or cbitb or prog or min) begin
   if (prog==1) clk <= 0;
   else if (prog==0 && cbit==0) clk <= min[0];
   else if (prog==0 && cbit==1) clk <= min[1];
   else clk <= 1'bx;

end

endmodule //clk_mux2to18k

//************************************************
//Title:    cebdffrqn
//Design:   cebdffrqn.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//Version:  D0.1
//
//INIT: Jan 31, 2008
//
//Revision : 
//           
//************************************************
module cebdffrqn ( q, qn, clk, d, r, ceb );

output  q, qn;
input  clk, d, r, ceb;

`ifdef TIMINGCHECK
reg NOTIFIER;

  specify
    specparam
    tplh$r$q = 1.0,
    tphl$r$q = 1.0,
    tplh$r$qn = 1.0,
    tphl$r$qn = 1.0,
    tplh$clk$q = 1.0,
    tphl$clk$q = 1.0,
    tplh$clk$qn = 1.0,
    tphl$clk$qn = 1.0,
    tsetup$d$clk = 1.0,
    thold$d$clk	= 1.0,
    tsetup$ceb$clk = 1.0,
    thold$ceb$clk = 1.0,
    tminpwh$r = 1.0,
    tminpwl$clk = 1.0,
    tminpwh$clk = 1.0;

//path delays
    if (r == 1'b0)
      (posedge clk *> (q +: d)) = (tplh$clk$q, tphl$clk$q);
    if (r == 1'b0)
      (posedge clk *> (qn +: d)) = (tplh$clk$qn, tphl$clk$qn);
    (posedge r *> (q  +: 0) ) = (tplh$r$q, tphl$r$q);
    (posedge r *> (qn  +: 0) ) = (tplh$r$qn, tphl$r$qn);
      
//timing checks     
    $setuphold(posedge clk &&& (r == 1'b0), posedge d, tsetup$d$clk, thold$d$clk, NOTIFIER);
    $setuphold(posedge clk &&& (r == 1'b0), negedge d, tsetup$d$clk, thold$d$clk, NOTIFIER);    
    $setuphold(posedge clk &&& (r == 1'b0), posedge ceb, tsetup$ceb$clk, thold$ceb$clk, NOTIFIER);
    $setuphold(posedge clk &&& (r == 1'b0), negedge ceb, tsetup$ceb$clk, thold$ceb$clk, NOTIFIER);
    $width(posedge), tminpwh$r, 0, NOTIFIER);
    $width(negedge clk, tminpwl$clk, 0, NOTIFIER);
    $width(posedge clk, tminpwh$clk, 0, NOTIFIER); 
   endspecify
`endif

reg q, qn;

always @(posedge clk or posedge r) 
   if (r) begin q <= 0; qn <= 1; end
   else if (ceb==0) begin q <= d; qn <= ~d; end
   
endmodule  //cebdffrqn

module eh_io_pup_2_new ( por_b, core_por_b, vdd_io );

  input core_por_b;
  input vdd_io;
  output por_b;

  assign por_b = core_por_b & vdd_io;

endmodule
