`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////////////
module ha (Cout, Sum, A, B);
input A, B;
output Cout, Sum;
/*
assign Cout = A & B;
assign Sum  = A ^ B;
*/

SEH_ADDH_1 ha_inst(
.A(A), 
.B(B), 
.S(Sum), 
.CO(Cout)
);
endmodule // ha


///////////////////////////////////////////////////////////////////////
module fa (Cout, Sum, A, B, C);
input A, B, C;
output Cout, Sum;

//assign Cout = ((A&B) | (B&C) |(A&C));
/*
assign Cout = ~(~(A&B) & ~(B&C) & ~(A&C));
assign Sum  = A^B^C;
*/

SEH_ADDF_D_1 fa_inst(
.A(A), 
.B(B), 
.CI(C),
.S(Sum), 
.CO(Cout)
);

endmodule // fa


/*
///////////////////////////////////////////////////////////////////////
module rfa (g, p,Sum, A, B, Cin);
input A, B, Cin;
output g, p, Sum;

assign g = A & B;
assign p = A ^ B;

assign Sum  = p ^ Cin;

endmodule // rfa


///////////////////////////////////////////////////////////////////////
module clg4 (cout, g, p, cin);
input [3:0] g, p;
input cin;
output [3:0] cout;
wire	s1, s2, s3, s4, s5, s6;

assign s1 = p[0] & cin;
assign cout[1] =g[0] | s1;
assign s2 = p[1] & g[0];
assign s3 = p[1] & p[0] & cin;
assign cout[2] =g[1] | s2 | s3;
assign s4 = p[2] & g[1];
assign s5 = p[2] & p[1] & g[0];
assign s6 = p[2] & p[1] & p[0] & cin;
assign cout[3] =g[2] | s4 | s5 | s6;

endmodule // clg4


///////////////////////////////////////////////////////////////////////
module bclg4 (cout, gout, pout, g, p, cin);
input [3:0] g, p;
input cin;
output [3:0] cout;
output gout, pout;
wire	s1, s2, s3, s4, s5, s6;
wire	t1, t2, t3;

assign s1=p[0] & cin;

assign cout[1]=g[0] | s1;

assign s2=p[1] & g[0];

assign s3=p[1] & p[0] & cin;

assign cout[2]=g[1] | s2 | s3;

assign s4=p[2] & g[1];

assign s5=p[2] & p[1] & g[0];

assign s6=p[2] & p[1] & p[0] & cin;

assign cout[3]=g[2] | s4 | s5 | s6;

assign t1 = p[3] & g[2];

assign t2 = p[3] & p[2] & g[1];

assign t3 = p[3] & p[2] & p[1] & g[0];

assign gout = g[3] | t1 | t2 | t3;

assign pout = p[0] & p[1] & p[2] & p[3];

endmodule // bclg4
*/

/*
///////////////////////////////////////////////////////////////////////
module cla8 (Sum, G, P, A, B, Cin);
input [7:0] A, B;
input Cin;
output [7:0] Sum;
output G, P;
wire	[7:0] gtemp1;
wire	[7:0] ptemp1;
wire	[7:0] ctemp1;
wire	 ctemp2;

wire	[1:0] gouta, pouta;

rfa r01 (gtemp1[0], ptemp1[0], Sum[0], A[0], B[0], Cin);
rfa r02 (gtemp1[1], ptemp1[1], Sum[1], A[1], B[1], ctemp1[1]);
rfa r03 (gtemp1[2], ptemp1[2], Sum[2], A[2], B[2], ctemp1[2]);
rfa r04 (gtemp1[3], ptemp1[3], Sum[3], A[3], B[3], ctemp1[3]);
bclg4 b1 (ctemp1[3:0], gouta[0], pouta[0], gtemp1[3:0], ptemp1[3:0], Cin);

rfa r05 (gtemp1[4], ptemp1[4], Sum[4], A[4], B[4], ctemp2);
rfa r06 (gtemp1[5], ptemp1[5], Sum[5], A[5], B[5], ctemp1[5]);
rfa r07 (gtemp1[6], ptemp1[6], Sum[6], A[6], B[6], ctemp1[6]);
rfa r08 (gtemp1[7], ptemp1[7], Sum[7], A[7], B[7], ctemp1[7]);
bclg4 b2 (ctemp1[7:4], gouta[1], pouta[1], gtemp1[7:4], ptemp1[7:4], ctemp2);

assign ctemp2=gouta[0] | pouta[0] & Cin;

assign G = gouta[1] | pouta[1] & gouta[0];
assign P = pouta[1] & pouta[0];

endmodule // cla8
*/

///////////////////////////////////////////////////////////////////////
/*
module cla16 (Sum, G, P, A, B, Cin);
input [15:0] A, B;
input Cin;
output [15:0] Sum;
output G, P;
wire	[15:0] gtemp1;
wire	[15:0] ptemp1;
wire	[15:0] ctemp1;
wire	[3:0] ctemp2;

wire	[3:0] gouta, pouta;

rfa r01 (gtemp1[0], ptemp1[0], Sum[0], A[0], B[0], Cin);
rfa r02 (gtemp1[1], ptemp1[1], Sum[1], A[1], B[1], ctemp1[1]);
rfa r03 (gtemp1[2], ptemp1[2], Sum[2], A[2], B[2], ctemp1[2]);
rfa r04 (gtemp1[3], ptemp1[3], Sum[3], A[3], B[3], ctemp1[3]);
bclg4 b1 (ctemp1[3:0], gouta[0], pouta[0], gtemp1[3:0], ptemp1[3:0], Cin);

rfa r05 (gtemp1[4], ptemp1[4], Sum[4], A[4], B[4], ctemp2[1]);
rfa r06 (gtemp1[5], ptemp1[5], Sum[5], A[5], B[5], ctemp1[5]);
rfa r07 (gtemp1[6], ptemp1[6], Sum[6], A[6], B[6], ctemp1[6]);
rfa r08 (gtemp1[7], ptemp1[7], Sum[7], A[7], B[7], ctemp1[7]);
bclg4 b2 (ctemp1[7:4], gouta[1], pouta[1], gtemp1[7:4], ptemp1[7:4], ctemp2[1]);

rfa r09 (gtemp1[8], ptemp1[8], Sum[8], A[8], B[8], ctemp2[2]);
rfa r10 (gtemp1[9], ptemp1[9], Sum[9], A[9], B[9], ctemp1[9]);
rfa r11 (gtemp1[10], ptemp1[10], Sum[10], A[10], B[10], ctemp1[10]);
rfa r12 (gtemp1[11], ptemp1[11], Sum[11], A[11], B[11], ctemp1[11]);
bclg4 b3 (ctemp1[11:8], gouta[2], pouta[2], gtemp1[11:8], ptemp1[11:8], ctemp2[2]);

rfa r13 (gtemp1[12], ptemp1[12], Sum[12], A[12], B[12], ctemp2[3]);
rfa r14 (gtemp1[13], ptemp1[13], Sum[13], A[13], B[13], ctemp1[13]);
rfa r15 (gtemp1[14], ptemp1[14], Sum[14], A[14], B[14], ctemp1[14]);
rfa r16 (gtemp1[15], ptemp1[15], Sum[15], A[15], B[15], ctemp1[15]);
bclg4 b4 (ctemp1[15:12], gouta[3], pouta[3], gtemp1[15:12], ptemp1[15:12], ctemp2[3]);

bclg4 b5 (ctemp2, G, P, gouta, pouta, Cin);
endmodule // cla16
*/

///////////////////////////////////////////////////////////////////////
module mpfa (g_b, p,Sum, A, B, Cin);
input A, B, Cin;
output g_b, p, Sum;
/*
assign g_b = ~(A & B);
assign p = A ^ B;

assign Sum  = p ^ Cin;
*/
wire con1;
SEH_ADDHCSCOB_1 mpfa_inst(
.A(A), 
.B(B), 
.CI(Cin), 
.S(Sum), 
.CO0(g_b), 
.CO1(con1)
);

assign p = A ^ B;

endmodule // mpfa

///////////////////////////////////////////////////////////////////////
module mclg4 (cout, g_o, p_o, g_b, p, cin);
input [3:0] g_b, p;
input cin;
output [3:0] cout;
output g_o, p_o;

wire	s1, s2, s3, s4, s5, s6,s7,s8,s9;

wire  [2:0] g;
assign g[0] =~g_b[0];
assign g[1] =~g_b[1];
assign g[2] =~g_b[2];

assign s1 = ~(p[0] & cin);
assign cout[1] =~(g_b[0] & s1);

assign s2 = ~(p[1] & g[0]);
assign s3 = ~(p[1] & p[0] & cin);
assign cout[2] =~(g_b[1] & s2 & s3);

assign s4 = ~(p[2] & g[1]);
assign s5 = ~(p[2] & p[1] & g[0]);
assign s6 = ~(p[2] & p[1] & p[0] & cin);
assign cout[3] =~(g_b[2] & s4 & s5 & s6);

assign s7 =~(p[3] & g[2]);
assign s8 =~(p[3] & p[2] & g[1]);
assign s9 =~(p[3] & p[2] & p[1] & g[0]);
assign g_o =~(g_b[3] & s7 & s8 & s9);

assign p_o =(p[3] & p[2] & p[1] & p[0]);

endmodule // mclg4

///////////////////////////////////////////////////////////////////////
module mclg16 (cout, g_o, p_o, g, p, cin);
input [3:0] g, p;
input cin;
output [3:0] cout;
output g_o, p_o;

wire	s1, s2, s3, s4, s5, s6, s7,s8,s9;

assign s1 = ~(p[0] & cin);
assign cout[1] =~(~g[0] & s1);

assign s2 = ~(p[1] & g[0]);
assign s3 = ~(p[1] & p[0] & cin);
assign cout[2] =~(~g[1] & s2 & s3);

assign s4 = ~(p[2] & g[1]);
assign s5 = ~(p[2] & p[1] & g[0]);
assign s6 = ~(p[2] & p[1] & p[0] & cin);
assign cout[3] =~(~g[2] & s4 & s5 & s6);

assign s7 =~(p[3] & g[2]);
assign s8 =~(p[3] & p[2] & g[1]);
assign s9 =~(p[3] & p[2] & p[1] & g[0]);
assign g_o =~(~g[3] & s7 & s8 & s9);

assign p_o =(p[3] & p[2] & p[1] & p[0]);

endmodule // mclg16
///////////////////////////////////////////////////////////////////////
module fcla16 (Sum, G, P, A, B, Cin);
input [15:0] A, B;
input Cin;
output [15:0] Sum;
output G, P;
wire	[15:0] gtemp1_b;
wire	[15:0] ptemp1;
wire	[15:0] ctemp1;
wire	[3:0] ctemp2;

wire	[3:0] gouta, pouta;
mpfa r01 (.g_b(gtemp1_b[0]), .p(ptemp1[0]), .Sum(Sum[0]), .A(A[0]), .B(B[0]), .Cin(Cin));
mpfa r02 (.g_b(gtemp1_b[1]), .p(ptemp1[1]), .Sum(Sum[1]), .A(A[1]), .B(B[1]), .Cin(ctemp1[1]));
mpfa r03 (.g_b(gtemp1_b[2]), .p(ptemp1[2]), .Sum(Sum[2]), .A(A[2]), .B(B[2]), .Cin(ctemp1[2]));
mpfa r04 (.g_b(gtemp1_b[3]), .p(ptemp1[3]), .Sum(Sum[3]), .A(A[3]), .B(B[3]), .Cin(ctemp1[3]));
mclg4 b1 (.cout(ctemp1[3:0]), .g_o(gouta[0]), .p_o(pouta[0]), .g_b(gtemp1_b[3:0]), .p(ptemp1[3:0]), .cin(Cin));

mpfa r05 (.g_b(gtemp1_b[4]), .p(ptemp1[4]), .Sum(Sum[4]), .A(A[4]), .B(B[4]), .Cin(ctemp2[1]));
mpfa r06 (.g_b(gtemp1_b[5]), .p(ptemp1[5]), .Sum(Sum[5]), .A(A[5]), .B(B[5]), .Cin(ctemp1[5]));
mpfa r07 (.g_b(gtemp1_b[6]), .p(ptemp1[6]), .Sum(Sum[6]), .A(A[6]), .B(B[6]), .Cin(ctemp1[6]));
mpfa r08 (.g_b(gtemp1_b[7]), .p(ptemp1[7]), .Sum(Sum[7]), .A(A[7]), .B(B[7]), .Cin(ctemp1[7]));
mclg4 b2 (.cout(ctemp1[7:4]), .g_o(gouta[1]), .p_o(pouta[1]), .g_b(gtemp1_b[7:4]), .p(ptemp1[7:4]), .cin(ctemp2[1]));

mpfa r09 (.g_b(gtemp1_b[8]), .p(ptemp1[8]), .Sum(Sum[8]), .A(A[8]), .B(B[8]), .Cin(ctemp2[2]));
mpfa r10 (.g_b(gtemp1_b[9]), .p(ptemp1[9]), .Sum(Sum[9]), .A(A[9]), .B(B[9]), .Cin(ctemp1[9]));
mpfa r11 (.g_b(gtemp1_b[10]), .p(ptemp1[10]), .Sum(Sum[10]), .A(A[10]), .B(B[10]), .Cin(ctemp1[10]));
mpfa r12 (.g_b(gtemp1_b[11]), .p(ptemp1[11]), .Sum(Sum[11]), .A(A[11]), .B(B[11]), .Cin(ctemp1[11]));
mclg4 b3 (.cout(ctemp1[11:8]), .g_o(gouta[2]), .p_o(pouta[2]), .g_b(gtemp1_b[11:8]), .p(ptemp1[11:8]), .cin(ctemp2[2]));

mpfa r13 (.g_b(gtemp1_b[12]), .p(ptemp1[12]), .Sum(Sum[12]), .A(A[12]), .B(B[12]), .Cin(ctemp2[3]));
mpfa r14 (.g_b(gtemp1_b[13]), .p(ptemp1[13]), .Sum(Sum[13]), .A(A[13]), .B(B[13]), .Cin(ctemp1[13]));
mpfa r15 (.g_b(gtemp1_b[14]), .p(ptemp1[14]), .Sum(Sum[14]), .A(A[14]), .B(B[14]), .Cin(ctemp1[14]));
mpfa r16 (.g_b(gtemp1_b[15]), .p(ptemp1[15]), .Sum(Sum[15]), .A(A[15]), .B(B[15]), .Cin(ctemp1[15]));
mclg4 b4 (.cout(ctemp1[15:12]), .g_o(gouta[3]), .p_o(pouta[3]), .g_b(gtemp1_b[15:12]), .p(ptemp1[15:12]), .cin(ctemp2[3]));

mclg16 b5 (.cout(ctemp2), .g_o(G), .p_o(P), .g(gouta), .p(pouta), .cin(Cin));
endmodule // fcla16

///////////////////////////////////////////////////////////////////////
module fcla8 (Sum, G, P, A, B, Cin);
input [7:0] A, B;
input Cin;
output [7:0] Sum;
output G, P;
wire	[7:0] gtemp1;
wire	[7:0] ptemp1;
wire	[7:0] ctemp1;
wire	 ctemp2;

wire	[1:0] gouta, pouta;

mpfa r01 (.g_b(gtemp1[0]), .p(ptemp1[0]), .Sum(Sum[0]), .A(A[0]), .B(B[0]), .Cin(Cin));
mpfa r02 (.g_b(gtemp1[1]), .p(ptemp1[1]), .Sum(Sum[1]), .A(A[1]), .B(B[1]), .Cin(ctemp1[1]));
mpfa r03 (.g_b(gtemp1[2]), .p(ptemp1[2]), .Sum(Sum[2]), .A(A[2]), .B(B[2]), .Cin(ctemp1[2]));
mpfa r04 (.g_b(gtemp1[3]), .p(ptemp1[3]), .Sum(Sum[3]), .A(A[3]), .B(B[3]), .Cin(ctemp1[3]));
mclg4 b1 (.cout(ctemp1[3:0]), .g_o(gouta[0]), .p_o(pouta[0]), .g_b(gtemp1[3:0]), .p(ptemp1[3:0]), .cin(Cin));

mpfa r05 (.g_b(gtemp1[4]), .p(ptemp1[4]), .Sum(Sum[4]), .A(A[4]), .B(B[4]), .Cin(ctemp2));
mpfa r06 (.g_b(gtemp1[5]), .p(ptemp1[5]), .Sum(Sum[5]), .A(A[5]), .B(B[5]), .Cin(ctemp1[5]));
mpfa r07 (.g_b(gtemp1[6]), .p(ptemp1[6]), .Sum(Sum[6]), .A(A[6]), .B(B[6]), .Cin(ctemp1[6]));
mpfa r08 (.g_b(gtemp1[7]), .p(ptemp1[7]), .Sum(Sum[7]), .A(A[7]), .B(B[7]), .Cin(ctemp1[7]));
mclg4 b2 (.cout(ctemp1[7:4]), .g_o(gouta[1]), .p_o(pouta[1]), .g_b(gtemp1[7:4]), .p(ptemp1[7:4]), .cin(ctemp2));

assign ctemp2=~(~gouta[0] & ~(pouta[0] & Cin));

assign G = ~(~gouta[1] & ~(pouta[1] & gouta[0]));
assign P = pouta[1] & pouta[0];

endmodule // fcla8
