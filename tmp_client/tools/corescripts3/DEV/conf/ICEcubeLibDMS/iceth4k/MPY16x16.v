`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:   Latticesemi Corporation
// Engineer:  
// 
// Create Date:    
// Design Name: 
// Module Name:    MPY16X16

// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////

`define  SIGNED_DATA		1'b1
`define  UNSIGNED_DATA		1'b0

///////////////////////////////////////////////////////////////////////
module booth_encoder(booth_single, booth_double, booth_negtive, multiplier, signed_mpy);
input	[7:0]multiplier;
output	[4:0]booth_single;
output	[4:0]booth_double;
output	[4:0]booth_negtive;
input	signed_mpy;

wire	[10:0]booth_in;
wire	[1:0]sign_ext;
assign sign_ext=(signed_mpy==1'b1)?{2{multiplier[7]}} : 2'b00;

assign booth_in={sign_ext ,multiplier[7:0],1'b0};


assign  booth_negtive[0]=booth_in[2];
assign  booth_negtive[1]=booth_in[4];
assign  booth_negtive[2]=booth_in[6];
assign  booth_negtive[3]=booth_in[8];
assign  booth_negtive[4]=booth_in[10];

assign  booth_single[0]=booth_in[0]^booth_in[1];
assign  booth_single[1]=booth_in[2]^booth_in[3];
assign  booth_single[2]=booth_in[4]^booth_in[5];
assign  booth_single[3]=booth_in[6]^booth_in[7];
assign  booth_single[4]=booth_in[8]^booth_in[9];


assign  booth_double[0]=~(~(booth_in[0] & booth_in[1] & ~booth_in[2]) & ~(~booth_in[0] & ~booth_in[1] & booth_in[2]));
assign  booth_double[1]=~(~(booth_in[2] & booth_in[3] & ~booth_in[4]) & ~(~booth_in[2] & ~booth_in[3] & booth_in[4]));
assign  booth_double[2]=~(~(booth_in[4] & booth_in[5] & ~booth_in[6]) & ~(~booth_in[4] & ~booth_in[5] & booth_in[6]));
assign  booth_double[3]=~(~(booth_in[6] & booth_in[7] & ~booth_in[8]) & ~(~booth_in[6] & ~booth_in[7] & booth_in[8]));
assign  booth_double[4]=~(~(booth_in[8] & booth_in[9] & ~booth_in[10]) & ~(~booth_in[8] & ~booth_in[9] & booth_in[10]));

endmodule // booth_encoder

///////////////////////////////////////////////////////////////////////
module booth_selector(pp_out,booth_single, booth_double, booth_negtive,multiplicand, signed_mpy);
input	[7:0]multiplicand;
input	[4:0]booth_single;
input	[4:0]booth_double;
input	[4:0]booth_negtive;
output	[44:0] pp_out;
integer	j;

reg		[8:0] pp0,pp1,pp2,pp3,pp4;

input	signed_mpy;
wire	sign_ext;
assign sign_ext=(signed_mpy==1'b1)?{multiplicand[7]} : 1'b0;


assign pp_out ={pp4, pp3, pp2, pp1, pp0};

wire	[9:0]bs_in;

assign  bs_in={sign_ext ,multiplicand[7:0],1'b0};


always @(booth_negtive or booth_single or bs_in or booth_double)

begin
	for (j=0; j<=8; j=j+1)
	begin
		pp0[j] = (booth_negtive[0]^ ~(~(booth_single[0] & bs_in[j+1]) & ~(booth_double[0] & bs_in[j])));
		pp1[j] = (booth_negtive[1]^ ~(~(booth_single[1] & bs_in[j+1]) & ~(booth_double[1] & bs_in[j])));
		pp2[j] = (booth_negtive[2]^ ~(~(booth_single[2] & bs_in[j+1]) & ~(booth_double[2] & bs_in[j])));
		pp3[j] = (booth_negtive[3]^ ~(~(booth_single[3] & bs_in[j+1]) & ~(booth_double[3] & bs_in[j])));
		pp4[j] = (booth_negtive[4]^ ~(~(booth_single[4] & bs_in[j+1]) & ~(booth_double[4] & bs_in[j])));
	end

end 

endmodule // booth_selector
///////////////////////////////////////////////////////////////////////
module MPY8x8(csa_a,csa_b,multiplicand,multiplier,signed_MPD,signed_MPR);
input	[7:0]multiplicand;
input	[7:0]multiplier;
input	signed_MPD, signed_MPR;

output [15:0] csa_a;
output [15:0] csa_b;

wire	[4:0]booth_single;
wire	[4:0]booth_double;
wire	[4:0]booth_negtive;
wire	[4:0]pp_sign;

wire	[44:0]pp_out;
wire	[8:0] PP0,PP1,PP2,PP3,PP4;

assign {PP4, PP3, PP2, PP1, PP0} = pp_out;

booth_encoder booth_encoder
(
.booth_single(booth_single), 
.booth_double(booth_double), 
.booth_negtive(booth_negtive), 
.multiplier(multiplier),
.signed_mpy(signed_MPR)
);


booth_selector booth_selector
(
.pp_out(pp_out),
.booth_single(booth_single), 
.booth_double(booth_double), 
.booth_negtive(booth_negtive),
.multiplicand(multiplicand),
.signed_mpy(signed_MPD)
);

wire	current_MPD_sign;
assign current_MPD_sign = multiplicand[7] & signed_MPD;
//assign pp_sign[0] = (booth_negtive[0] ^ current_MPD_sign) & (booth_single[0] | booth_double[0] | booth_negtive[0]) | (~booth_single[0] & ~booth_double[0] & booth_negtive[0]);
//assign pp_sign[1] = (booth_negtive[1] ^ current_MPD_sign) & (booth_single[1] | booth_double[1] | booth_negtive[1]) | (~booth_single[1] & ~booth_double[1] & booth_negtive[1]);
//assign pp_sign[2] = (booth_negtive[2] ^ current_MPD_sign) & (booth_single[2] | booth_double[2] | booth_negtive[2]) | (~booth_single[2] & ~booth_double[2] & booth_negtive[2]);
//assign pp_sign[3] = (booth_negtive[3] ^ current_MPD_sign) & (booth_single[3] | booth_double[3] | booth_negtive[3]) | (~booth_single[3] & ~booth_double[3] & booth_negtive[3]);
//assign pp_sign[4] = (booth_negtive[4] ^ current_MPD_sign) & (booth_single[4] | booth_double[4] | booth_negtive[4]) | (~booth_single[4] & ~booth_double[4] & booth_negtive[4]);

integer j;
reg [4:0] booth_single_b, booth_double_b, booth_negtive_b;

always @(booth_single or booth_double or booth_negtive)
begin
	for (j=0; j<=4; j=j+1)
	begin
		booth_single_b[j] = ~booth_single[j];
		booth_double_b[j] = ~booth_double[j];
		booth_negtive_b[j] = ~booth_negtive[j];
	end
end 

assign pp_sign[0] = (booth_negtive[0] ^ current_MPD_sign) & ~(booth_single_b[0] & booth_double_b[0] & booth_negtive_b[0]) | (booth_single_b[0] & booth_double_b[0] & booth_negtive[0]);
assign pp_sign[1] = (booth_negtive[1] ^ current_MPD_sign) & ~(booth_single_b[1] & booth_double_b[1] & booth_negtive_b[1]) | (booth_single_b[1] & booth_double_b[1] & booth_negtive[1]);
assign pp_sign[2] = (booth_negtive[2] ^ current_MPD_sign) & ~(booth_single_b[2] & booth_double_b[2] & booth_negtive_b[2]) | (booth_single_b[2] & booth_double_b[2] & booth_negtive[2]);
assign pp_sign[3] = (booth_negtive[3] ^ current_MPD_sign) & ~(booth_single_b[3] & booth_double_b[3] & booth_negtive_b[3]) | (booth_single_b[3] & booth_double_b[3] & booth_negtive[3]);
assign pp_sign[4] = (booth_negtive[4] ^ current_MPD_sign) & ~(booth_single_b[4] & booth_double_b[4] & booth_negtive_b[4]) | (booth_single_b[4] & booth_double_b[4] & booth_negtive[4]);
// Wallace CSA step#1

wire	FA1_R00C14_C, FA1_R00C14_S;
wire	FA1_R00C13_C, FA1_R00C13_S;
wire	FA1_R00C12_C, FA1_R00C12_S;

wire	FA1_R00C11_C, FA1_R00C11_S;
wire	HA1_R03C11_C, HA1_R03C11_S;

wire	FA1_R00C10_C, FA1_R00C10_S;
wire	HA1_R03C10_C, HA1_R03C10_S;

wire	FA1_R00C09_C, FA1_R00C09_S;
wire	HA1_R03C09_C, HA1_R03C09_S;

wire	FA1_R00C08_C, FA1_R00C08_S;
wire	FA1_R03C08_C, FA1_R03C08_S;

wire	FA1_R00C07_C, FA1_R00C07_S;
wire	FA1_R00C06_C, FA1_R00C06_S;
wire	HA1_R03C06_C, HA1_R03C06_S;

wire	FA1_R00C05_C, FA1_R00C05_S;
wire	FA1_R00C04_C, FA1_R00C04_S;

wire	FA1_R00C02_C, FA1_R00C02_S;


fa FA1_R00C14(.Cout(FA1_R00C14_C), .Sum(FA1_R00C14_S), .A(1'b1), .B(PP3[8]), .C(PP4[6]));

fa FA1_R00C13(.Cout(FA1_R00C13_C), .Sum(FA1_R00C13_S), .A(~pp_sign[2]), .B(PP3[7]), .C(PP4[5]));

fa FA1_R00C12(.Cout(FA1_R00C12_C), .Sum(FA1_R00C12_S), .A(1'b1), .B(PP2[8]), .C(PP3[6]));

fa FA1_R00C11(.Cout(FA1_R00C11_C), .Sum(FA1_R00C11_S), .A(~pp_sign[0]), .B(~pp_sign[1]), .C(PP2[7]));
ha HA1_R03C11(.Cout(HA1_R03C11_C), .Sum(HA1_R03C11_S), .A(PP3[5]), .B(PP4[3]));

fa FA1_R00C10(.Cout(FA1_R00C10_C), .Sum(FA1_R00C10_S), .A(pp_sign[0]), .B(PP1[8]), .C(PP2[6]));
ha HA1_R03C10(.Cout(HA1_R03C10_C), .Sum(HA1_R03C10_S), .A(PP3[4]), .B(PP4[2]));

fa FA1_R00C09(.Cout(FA1_R00C09_C), .Sum(FA1_R00C09_S), .A(pp_sign[0]), .B(PP1[7]), .C(PP2[5]));
ha HA1_R03C09(.Cout(HA1_R03C09_C), .Sum(HA1_R03C09_S), .A(PP3[3]), .B(PP4[1]));

fa FA1_R00C08(.Cout(FA1_R00C08_C), .Sum(FA1_R00C08_S), .A(PP0[8]), .B(PP1[6]), .C(PP2[4]));
fa FA1_R03C08(.Cout(FA1_R03C08_C), .Sum(FA1_R03C08_S), .A(PP3[2]), .B(PP4[0]), .C(booth_negtive[4]));

fa FA1_R00C07(.Cout(FA1_R00C07_C), .Sum(FA1_R00C07_S), .A(PP0[7]), .B(PP1[5]), .C(PP2[3]));
fa FA1_R00C06(.Cout(FA1_R00C06_C), .Sum(FA1_R00C06_S), .A(PP0[6]), .B(PP1[4]), .C(PP2[2]));
ha HA1_R03C06(.Cout(HA1_R03C06_C), .Sum(HA1_R03C06_S), .A(PP3[0]), .B(booth_negtive[3]));

fa FA1_R00C05(.Cout(FA1_R00C05_C), .Sum(FA1_R00C05_S), .A(PP0[5]), .B(PP1[3]), .C(PP2[1]));
fa FA1_R00C04(.Cout(FA1_R00C04_C), .Sum(FA1_R00C04_S), .A(PP0[4]), .B(PP1[2]), .C(PP2[0]));

fa FA1_R00C02(.Cout(FA1_R00C02_C), .Sum(FA1_R00C02_S), .A(PP0[2]), .B(PP1[0]), .C(booth_negtive[1]));

// Wallace CSA step#2

wire	FA2_R00C15_C, FA2_R00C15_S;
wire	HA2_R00C14_C, HA2_R00C14_S;
wire	HA2_R00C13_C, HA2_R00C13_S;

wire	FA2_R00C12_C, FA2_R00C12_S;
wire	FA2_R00C11_C, FA2_R00C11_S;
wire	FA2_R00C10_C, FA2_R00C10_S;
wire	FA2_R00C09_C, FA2_R00C09_S;
wire	FA2_R00C08_C, FA2_R00C08_S;
wire	FA2_R00C07_C, FA2_R00C07_S;
wire	FA2_R00C06_C, FA2_R00C06_S;

wire	FA2_R00C03_C, FA2_R00C03_S;


fa FA2_R00C15(.Cout(FA2_R00C15_C), .Sum(FA2_R00C15_S), .A(~pp_sign[3]), .B(PP4[7]), .C(FA1_R00C14_C));

ha HA2_R00C14(.Cout(HA2_R00C14_C), .Sum(HA2_R00C14_S), .A(FA1_R00C14_S), .B(FA1_R00C13_C));
ha HA2_R00C13(.Cout(HA2_R00C13_C), .Sum(HA2_R00C13_S), .A(FA1_R00C13_S), .B(FA1_R00C12_C));

fa FA2_R00C12(.Cout(FA2_R00C12_C), .Sum(FA2_R00C12_S), .A(FA1_R00C12_S), .B(FA1_R00C11_C), .C(HA1_R03C11_C));
fa FA2_R00C11(.Cout(FA2_R00C11_C), .Sum(FA2_R00C11_S), .A(FA1_R00C11_S), .B(FA1_R00C10_C), .C(HA1_R03C11_S));
fa FA2_R00C10(.Cout(FA2_R00C10_C), .Sum(FA2_R00C10_S), .A(FA1_R00C10_S), .B(FA1_R00C09_C), .C(HA1_R03C10_S));
fa FA2_R00C09(.Cout(FA2_R00C09_C), .Sum(FA2_R00C09_S), .A(FA1_R00C09_S), .B(FA1_R00C08_C), .C(HA1_R03C09_S));
fa FA2_R00C08(.Cout(FA2_R00C08_C), .Sum(FA2_R00C08_S), .A(FA1_R00C08_S), .B(FA1_R00C07_C), .C(FA1_R03C08_S));
fa FA2_R00C07(.Cout(FA2_R00C07_C), .Sum(FA2_R00C07_S), .A(FA1_R00C07_S), .B(FA1_R00C06_C), .C(HA1_R03C06_C));
fa FA2_R00C06(.Cout(FA2_R00C06_C), .Sum(FA2_R00C06_S), .A(FA1_R00C06_S), .B(FA1_R00C05_C), .C(HA1_R03C06_S));

fa FA2_R00C03(.Cout(FA2_R00C03_C), .Sum(FA2_R00C03_S), .A(PP0[3]), .B(PP1[1]), .C(FA1_R00C02_C));

// Wallace CSA step#3
wire	HA3_R00C15_C, HA3_R00C15_S;
wire	HA3_R00C14_C, HA3_R00C14_S;
wire	HA3_R00C13_C, HA3_R00C13_S;
wire	FA3_R00C12_C, FA3_R00C12_S;
wire	FA3_R00C11_C, FA3_R00C11_S;
wire	FA3_R00C10_C, FA3_R00C10_S;
wire	FA3_R00C09_C, FA3_R00C09_S;

wire	HA3_R00C08_C, HA3_R00C08_S;
wire	FA3_R00C07_C, FA3_R00C07_S;

wire	HA3_R00C05_C, HA3_R00C05_S;
wire	FA3_R00C04_C, FA3_R00C04_S;


ha HA3_R00C15(.Cout(HA3_R00C15_C), .Sum(HA3_R00C15_S), .A(FA2_R00C15_S), .B(HA2_R00C14_C));
ha HA3_R00C14(.Cout(HA3_R00C14_C), .Sum(HA3_R00C14_S), .A(HA2_R00C14_S), .B(HA2_R00C13_C));
ha HA3_R00C13(.Cout(HA3_R00C13_C), .Sum(HA3_R00C13_S), .A(HA2_R00C13_S), .B(FA2_R00C12_C));
fa FA3_R00C12(.Cout(FA3_R00C12_C), .Sum(FA3_R00C12_S), .A(FA2_R00C12_S), .B(FA2_R00C11_C), .C(PP4[4]));
fa FA3_R00C11(.Cout(FA3_R00C11_C), .Sum(FA3_R00C11_S), .A(FA2_R00C11_S), .B(FA2_R00C10_C), .C(HA1_R03C10_C));
fa FA3_R00C10(.Cout(FA3_R00C10_C), .Sum(FA3_R00C10_S), .A(FA2_R00C10_S), .B(FA2_R00C09_C), .C(HA1_R03C09_C));
fa FA3_R00C09(.Cout(FA3_R00C09_C), .Sum(FA3_R00C09_S), .A(FA2_R00C09_S), .B(FA2_R00C08_C), .C(FA1_R03C08_C));

ha HA3_R00C08(.Cout(HA3_R00C08_C), .Sum(HA3_R00C08_S), .A(FA2_R00C08_S), .B(FA2_R00C07_C));
fa FA3_R00C07(.Cout(FA3_R00C07_C), .Sum(FA3_R00C07_S), .A(FA2_R00C07_S), .B(FA2_R00C06_C), .C(PP3[1]));

ha HA3_R00C05(.Cout(HA3_R00C05_C), .Sum(HA3_R00C05_S), .A(FA1_R00C05_S), .B(FA1_R00C04_C));
fa FA3_R00C04(.Cout(FA3_R00C04_C), .Sum(FA3_R00C04_S), .A(FA1_R00C04_S), .B(booth_negtive[2]), .C(FA2_R00C03_C));


assign csa_a[0] = PP0[0];
assign csa_b[0] = booth_negtive[0];
assign csa_a[1] = PP0[1];
assign csa_b[1] = 1'b0;
assign csa_a[2] = FA1_R00C02_S;
assign csa_b[2] = 1'b0;
assign csa_a[3] = FA2_R00C03_S;
assign csa_b[3] = 1'b0;

assign csa_a[4] = FA3_R00C04_S;
assign csa_b[4] = 1'b0;

assign csa_a[5] = HA3_R00C05_S;
assign csa_b[5] = FA3_R00C04_C;
assign csa_a[6] = FA2_R00C06_S;
assign csa_b[6] = HA3_R00C05_C;
assign csa_a[7] = FA3_R00C07_S;
assign csa_b[7] = 1'b0;
assign csa_a[8] = HA3_R00C08_S;
assign csa_b[8] = FA3_R00C07_C;
assign csa_a[9] = FA3_R00C09_S;
assign csa_b[9] = HA3_R00C08_C;
assign csa_a[10] = FA3_R00C10_S;
assign csa_b[10] = FA3_R00C09_C;
assign csa_a[11] = FA3_R00C11_S;
assign csa_b[11] = FA3_R00C10_C;
assign csa_a[12] = FA3_R00C12_S;
assign csa_b[12] = FA3_R00C11_C;
assign csa_a[13] = HA3_R00C13_S;
assign csa_b[13] = FA3_R00C12_C;
assign csa_a[14] = HA3_R00C14_S;
assign csa_b[14] = HA3_R00C13_C;
assign csa_a[15] = HA3_R00C15_S;
assign csa_b[15] = HA3_R00C14_C;

endmodule // MPY8x8
///////////////////////////////////////////////////////////////////////
module MPY16X16(
clk,

IHRST,
ILRST,

FSEL,
GSEL,
HSEL,
JKSEL,
MPY_8X8_MODE,

ASGND,
BSGND,

A,
B,

OH_8X8,
OL_8X8,
O_16X16
);

input clk;

input IHRST;
input ILRST;

input FSEL;
input GSEL;
input HSEL;
input JKSEL;
input MPY_8X8_MODE;

input ASGND;
input BSGND;

input	[15:0]A;
input	[15:0]B;

output [15:0] OH_8X8;
output [15:0] OL_8X8;
output [31:0] O_16X16;


reg 	[31:0]csa_rega, csa_regb;
wire	[152:0]pp_out;

wire	[7:0] MPYG_mpd, MPYG_mpr;
wire	[7:0] MPYJ_mpd, MPYJ_mpr;
wire	[7:0] MPYF_mpd, MPYF_mpr;
wire	[7:0] MPYK_mpd, MPYK_mpr;

wire	MPYG_MPD_sign, MPYG_MPR_sign;
wire	MPYJ_MPD_sign, MPYJ_MPR_sign;
wire	MPYF_MPD_sign, MPYF_MPR_sign;
wire	MPYK_MPD_sign, MPYK_MPR_sign;

assign MPYG_mpd = A[7:0];
assign MPYG_mpr = B[7:0];
assign MPYG_MPD_sign = MPY_8X8_MODE ? ASGND : `UNSIGNED_DATA;
assign MPYG_MPR_sign = MPY_8X8_MODE ? BSGND : `UNSIGNED_DATA;

assign MPYJ_mpd = A[7:0];
assign MPYJ_mpr = B[15:8];
assign MPYJ_MPD_sign = `UNSIGNED_DATA;
assign MPYJ_MPR_sign = BSGND;

assign MPYF_mpd = A[15:8];
assign MPYF_mpr = B[15:8];
assign MPYF_MPD_sign = ASGND;
assign MPYF_MPR_sign = BSGND;

assign MPYK_mpd = A[15:8];
assign MPYK_mpr = B[7:0];
assign MPYK_MPD_sign = ASGND;
assign MPYK_MPR_sign = `UNSIGNED_DATA;

wire	[15:0] MPYG_csa_a, MPYG_csa_b;
wire	[15:0] MPYJ_csa_a, MPYJ_csa_b;
wire	[15:0] MPYF_csa_a, MPYF_csa_b;
wire	[15:0] MPYK_csa_a, MPYK_csa_b;

wire	[15:0] MPYG_o, MPYG_out;
wire	[15:0] MPYJ_o, MPYJ_out;
wire	[15:0] MPYF_o, MPYF_out;
wire	[15:0] MPYK_o, MPYK_out;
reg	[15:0] MPYG_oreg, MPYJ_oreg;
reg	[15:0] MPYF_oreg, MPYK_oreg;

wire	MPYJ_out_sign, MPYK_out_sign;
wire	MPYJK_g, MPYJK_p;

assign MPYJ_out_sign = BSGND ? MPYJ_out[15] : `UNSIGNED_DATA;
assign MPYK_out_sign = ASGND ? MPYK_out[15] : `UNSIGNED_DATA;

assign MPYJK_g = MPYJ_out_sign & MPYK_out_sign;
assign MPYJK_p = MPYJ_out_sign ^ MPYK_out_sign;


MPY8x8 MPY_G(.csa_a(MPYG_csa_a),.csa_b(MPYG_csa_b),.multiplicand(MPYG_mpd),.multiplier(MPYG_mpr),.signed_MPD(MPYG_MPD_sign),.signed_MPR(MPYG_MPR_sign));
MPY8x8 MPY_J(.csa_a(MPYJ_csa_a),.csa_b(MPYJ_csa_b),.multiplicand(MPYJ_mpd),.multiplier(MPYJ_mpr),.signed_MPD(MPYJ_MPD_sign),.signed_MPR(MPYJ_MPR_sign));
MPY8x8 MPY_F(.csa_a(MPYF_csa_a),.csa_b(MPYF_csa_b),.multiplicand(MPYF_mpd),.multiplier(MPYF_mpr),.signed_MPD(MPYF_MPD_sign),.signed_MPR(MPYF_MPR_sign));
MPY8x8 MPY_K(.csa_a(MPYK_csa_a),.csa_b(MPYK_csa_b),.multiplicand(MPYK_mpd),.multiplier(MPYK_mpr),.signed_MPD(MPYK_MPD_sign),.signed_MPR(MPYK_MPR_sign));



wire	[15:0] MPYG_cla_ina, MPYG_cla_inb;

assign MPYG_cla_ina = MPYG_csa_a;
assign MPYG_cla_inb = MPYG_csa_b;

wire	CLA16_G_g, CLA16_G_p, MPYG_ci;
assign MPYG_ci = 1'b0;

/*
DW01_add #(16) 
CLA16_G(
.SUM(MPYG_o[15:0]),
.A(MPYG_cla_ina[15:0]),
.B(MPYG_cla_inb[15:0]), 
.CI(MPYG_ci)
);
*/

fcla16 CLA16_G(
.Sum(MPYG_o[15:0]),
.A(MPYG_cla_ina[15:0]),
.B(MPYG_cla_inb[15:0]), 
.G(CLA16_G_g),
.P(CLA16_G_p),
.Cin(MPYG_ci)
);


/*
DW01_add #(16) 
fcla16 
CLA16_J(
.SUM(MPYJ_o[15:0]),
.A(MPYJ_csa_a[15:0]),
.B(MPYJ_csa_b[15:0]), 
.CI(1'b0)
);
*/

fcla16 CLA16_J(
.Sum(MPYJ_o[15:0]),
.A(MPYJ_csa_a[15:0]),
.B(MPYJ_csa_b[15:0]), 
.Cin(1'b0)
);


/*
DW01_add #(16) 
fcla16 
CLA16_F(
.SUM(MPYF_o[15:0]),
.A(MPYF_csa_a[15:0]),
.B(MPYF_csa_b[15:0]), 
.CI(1'b0)
);
*/

fcla16 CLA16_F(
.Sum(MPYF_o[15:0]),
.A(MPYF_csa_a[15:0]),
.B(MPYF_csa_b[15:0]), 
.Cin(1'b0)
);


/*
DW01_add #(16) 
fcla16 
CLA16_K(
.SUM(MPYK_o[15:0]),
.A(MPYK_csa_a[15:0]),
.B(MPYK_csa_b[15:0]), 
.CI(1'b0)
);
*/

fcla16 CLA16_K(
.Sum(MPYK_o[15:0]),
.A(MPYK_csa_a[15:0]),
.B(MPYK_csa_b[15:0]), 
.Cin(1'b0)
);



always @(posedge clk or posedge IHRST)
begin
  if (IHRST)
    MPYF_oreg <= #1 0;
  else
    MPYF_oreg <= #1 MPYF_o;
end

always @(posedge clk or posedge IHRST)
begin
  if (IHRST)
    MPYJ_oreg <= #1 0;
  else if (MPY_8X8_MODE)
    MPYJ_oreg <= #1 MPYJ_oreg;
  else
    MPYJ_oreg <= #1 MPYJ_o;
end

always @(posedge clk or posedge ILRST)
begin
  if (ILRST)
    MPYK_oreg <= #1 0;
  else if (MPY_8X8_MODE)
    MPYK_oreg <= #1 MPYK_oreg;
  else
    MPYK_oreg <= #1 MPYK_o;
end

always @(posedge clk or posedge ILRST)
begin
  if (ILRST)
    MPYG_oreg <= #1 0;
  else
    MPYG_oreg <= #1 MPYG_o;
end

 assign MPYG_out = GSEL ? MPYG_oreg : MPYG_o;
 assign MPYJ_out = JKSEL ? MPYJ_oreg : MPYJ_o;

 assign MPYF_out = JKSEL ? MPYF_oreg : MPYF_o;
 assign MPYK_out = FSEL ? MPYK_oreg : MPYK_o;

wire [23:0] csa_oc;
wire [23:0] csa_os;
wire MPYJK_g_b;
assign MPYJK_g_b = ~MPYJK_g;

assign csa_os[23] = MPYJK_p ^ MPYF_out[15];
assign csa_oc[23] = ~(MPYJK_g_b & ~(MPYJK_p & MPYF_out[15]));
assign csa_os[22] = MPYJK_p ^ MPYF_out[14];
assign csa_oc[22] = ~(MPYJK_g_b & ~(MPYJK_p & MPYF_out[14]));
assign csa_os[21] = MPYJK_p ^ MPYF_out[13];
assign csa_oc[21] = ~(MPYJK_g_b & ~(MPYJK_p & MPYF_out[13]));
assign csa_os[20] = MPYJK_p ^ MPYF_out[12];
assign csa_oc[20] = ~(MPYJK_g_b & ~(MPYJK_p & MPYF_out[12]));
assign csa_os[19] = MPYJK_p ^ MPYF_out[11];
assign csa_oc[19] = ~(MPYJK_g_b & ~(MPYJK_p & MPYF_out[11]));
assign csa_os[18] = MPYJK_p ^ MPYF_out[10];
assign csa_oc[18] = ~(MPYJK_g_b & ~(MPYJK_p & MPYF_out[10]));
assign csa_os[17] = MPYJK_p ^ MPYF_out[9];
assign csa_oc[17] = ~(MPYJK_g_b & ~(MPYJK_p & MPYF_out[9]));
assign csa_os[16] = MPYJK_p ^ MPYF_out[8];
assign csa_oc[16] = ~(MPYJK_g_b & ~(MPYJK_p & MPYF_out[8]));

fa FA1_R00C15(.Cout(csa_oc[15]), .Sum(csa_os[15]), .A(MPYJ_out[15]), .B(MPYK_out[15]), .C(MPYF_out[7]));
fa FA1_R00C14(.Cout(csa_oc[14]), .Sum(csa_os[14]), .A(MPYJ_out[14]), .B(MPYK_out[14]), .C(MPYF_out[6]));
fa FA1_R00C13(.Cout(csa_oc[13]), .Sum(csa_os[13]), .A(MPYJ_out[13]), .B(MPYK_out[13]), .C(MPYF_out[5]));
fa FA1_R00C12(.Cout(csa_oc[12]), .Sum(csa_os[12]), .A(MPYJ_out[12]), .B(MPYK_out[12]), .C(MPYF_out[4]));
fa FA1_R00C11(.Cout(csa_oc[11]), .Sum(csa_os[11]), .A(MPYJ_out[11]), .B(MPYK_out[11]), .C(MPYF_out[3]));
fa FA1_R00C10(.Cout(csa_oc[10]), .Sum(csa_os[10]), .A(MPYJ_out[10]), .B(MPYK_out[10]), .C(MPYF_out[2]));
fa FA1_R00C09(.Cout(csa_oc[9]),  .Sum(csa_os[9]),  .A(MPYJ_out[9]),  .B(MPYK_out[9]),  .C(MPYF_out[1]));
fa FA1_R00C08(.Cout(csa_oc[8]),  .Sum(csa_os[8]),  .A(MPYJ_out[8]),  .B(MPYK_out[8]),  .C(MPYF_out[0]));

fa FA1_R00C07(.Cout(csa_oc[7]), .Sum(csa_os[7]), .A(MPYG_out[15]), .B(MPYJ_out[7]), .C(MPYK_out[7]));
fa FA1_R00C06(.Cout(csa_oc[6]), .Sum(csa_os[6]), .A(MPYG_out[14]), .B(MPYJ_out[6]), .C(MPYK_out[6]));
fa FA1_R00C05(.Cout(csa_oc[5]), .Sum(csa_os[5]), .A(MPYG_out[13]), .B(MPYJ_out[5]), .C(MPYK_out[5]));
fa FA1_R00C04(.Cout(csa_oc[4]), .Sum(csa_os[4]), .A(MPYG_out[12]), .B(MPYJ_out[4]), .C(MPYK_out[4]));
fa FA1_R00C03(.Cout(csa_oc[3]), .Sum(csa_os[3]), .A(MPYG_out[11]), .B(MPYJ_out[3]), .C(MPYK_out[3]));
fa FA1_R00C02(.Cout(csa_oc[2]), .Sum(csa_os[2]), .A(MPYG_out[10]), .B(MPYJ_out[2]), .C(MPYK_out[2]));
fa FA1_R00C01(.Cout(csa_oc[1]), .Sum(csa_os[1]), .A(MPYG_out[9]),  .B(MPYJ_out[1]), .C(MPYK_out[1]));
fa FA1_R00C00(.Cout(csa_oc[0]), .Sum(csa_os[0]), .A(MPYG_out[8]),  .B(MPYJ_out[0]), .C(MPYK_out[0]));


wire 	[23:0] cla_ina;
wire 	[23:0] cla_inb;

wire 	[23:0] cla_o;
wire	cla24_g0, cla24_p0;
wire	cla24_g1, cla24_p1;

wire	cla24_cin, cla24_16_cout;

assign cla_ina = csa_os;
assign cla_inb = {csa_oc[22:0],1'b0};
assign cla24_cin = 1'b0 ;


fcla16 CLA24_16(
.Sum(cla_o[15:0]),
.G(cla24_g0),
.P(cla24_p0), 
.A(cla_ina[15:0]),
.B(cla_inb[15:0]), 
.Cin(cla24_cin)
);
assign cla24_16_cout = ~(~cla24_g0 & ~(cla24_p0 & cla24_cin));


/*
DW01_add #(16) 
CLA24_16(
.SUM(cla_o[15:0]),
.A(cla_ina[15:0]),
.B(cla_inb[15:0]), 
.CO(cla24_16_cout),
.CI(cla24_cin)
);
*/

fcla8 CLA24_8(
.Sum(cla_o[23:16]),
.G(cla24_g1),
.P(cla24_p1), 
.A(cla_ina[23:16]),
.B(cla_inb[23:16]), 
.Cin(cla24_16_cout)
);

/*
DW01_add #(8) 
CLA24_8(
.SUM(cla_o[23:16]),
.A(cla_ina[23:16]),
.B(cla_inb[23:16]), 
.CI(cla24_16_cout)
);
*/
reg 	[31:0]mpy16_reg;

always @(posedge clk or posedge ILRST)
begin
  if (ILRST)
    mpy16_reg <= #1 0;
  else if (MPY_8X8_MODE)
    mpy16_reg <= #1 mpy16_reg;
  else
    mpy16_reg <= #1 {cla_o,MPYG_out[7:0]};
end

assign O_16X16[31:0] = HSEL ? mpy16_reg : {cla_o,MPYG_out[7:0]};

assign OH_8X8 = MPYF_out[15:0];
assign OL_8X8 = MPYG_out[15:0];

endmodule // MPY16x16


///////////////////////////////////////////////////////////////////////
