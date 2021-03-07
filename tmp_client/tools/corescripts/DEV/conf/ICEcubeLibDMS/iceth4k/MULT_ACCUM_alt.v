`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:   Latticesemi Corporation
// Engineer:  
// 
// Create Date:    
// Design Name: 
// Module Name:    MULT_ACCUM

// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
module MULT_ACCUM(
    DIRECT_INPUT,
    MULT_INPUT,
    MULT_8x8,
    MULT_16x16,
    ADDSUB,
    CLK,
    CICAS,
    CI,
    SIGNEXTIN,
    SIGNEXTOUT,
    LDA,
    RST,
    ENA,
    COCAS,
    CO,
    O,
    OUTMUX_SEL,
    CARRYMUX_SEL,
    ADDER_A_IN_SEL,
    ADDER_B_IN_SEL
    );
	
    input [15:0] DIRECT_INPUT;
    input [15:0] MULT_INPUT;
    input [15:0] MULT_8x8;
    input [15:0] MULT_16x16;
    input ADDSUB;
    input CLK;
    input CICAS;
    input CI;
    input SIGNEXTIN;
    output SIGNEXTOUT;
    input LDA;
    input RST;
    input ENA;
    output COCAS;
    output CO;
    output [15:0] O;
    input [1:0] OUTMUX_SEL;
    input [1:0] CARRYMUX_SEL;
    input ADDER_A_IN_SEL;
    input [1:0] ADDER_B_IN_SEL;

	
    wire [15:0] ADDER_LOAD_MUX ;
    wire [15:0] ACCUMULATOR_REG ;
    wire [15:0] ADDER_SUM ;
    wire [15:0] ADDER_A_INPUT_MUX ;
    wire [15:0] ADDER_B_INPUT_MUX ;
    wire ADDER_CI ;
	 
    assign SIGNEXTOUT = ADDER_B_INPUT_MUX[15];
 

OUT_MUX_4 OUTPUT_MULTIPLEXER_TOP (
         .ADDER_COMBINATORIAL (ADDER_LOAD_MUX),
	 .ACCUM_REGISTER(ACCUMULATOR_REG) ,
	 .MULT_8x8(MULT_8x8) ,
	 .MULT_16x16(MULT_16x16),
	 .SELM(OUTMUX_SEL[1:0]) ,
	 .OUT(O)  
	 ) ;
	 
ACCUM_REG ACCUM_REG_TOP (
	.D(ADDER_LOAD_MUX) ,
	.Q(ACCUMULATOR_REG) ,
	.ENA(ENA) ,
	.CLK(CLK) ,
	.RST(RST)
	);
	
ACCUM_ADDER ACCUM_ADDER_TOP(
        .A(ADDER_A_INPUT_MUX) ,
        .B(ADDER_B_INPUT_MUX) ,
	.ADDSUB(ADDSUB) ,
	.CI(ADDER_CI) ,
	.SUM(ADDER_SUM) ,
	.COCAS(COCAS) ,
	.CO(CO)
	);	

LOAD_ADD_MUX LOAD_ADD_TOP (
        .ADDER(ADDER_SUM) ,
	.LOAD_DATA(DIRECT_INPUT) ,
	.LOAD(LDA),
	.OUT(ADDER_LOAD_MUX)
   );
	
ADDER_A_IN_MUX ADDER_A_IN_MUX_TOP (
        .ACCUMULATOR_REG(ACCUMULATOR_REG),
	.DIRECT_INPUT(DIRECT_INPUT) ,
	.SELM(ADDER_A_IN_SEL) ,
	.ADDER_A_MUX(ADDER_A_INPUT_MUX)
   );

ADDER_B_IN_MUX ADDER_B_IN_MUX_TOP (
        .MULT_INPUT(MULT_INPUT) ,
	.MULT_8x8(MULT_8x8) ,
	.MULT_16x16(MULT_16x16) ,
	.SIGNEXTIN(SIGNEXTIN) ,
	.SELM(ADDER_B_IN_SEL[1:0]) ,
	.ADDER_B_MUX(ADDER_B_INPUT_MUX)
	);	

CARRY_IN_MUX CARRY_IN_MUX_TOP (
	.CICAS(CICAS),
	.CI(CI),
	.CARRYMUX_SEL(CARRYMUX_SEL[1:0]),
	.ADDER_CI(ADDER_CI)
	);
	
endmodule

module OUT_MUX_4 (
        ADDER_COMBINATORIAL ,
	ACCUM_REGISTER ,
	MULT_8x8 ,
	MULT_16x16 ,
	SELM ,
	OUT  
	 ) ;

    input [15:0] ADDER_COMBINATORIAL ;
	input [15:0] ACCUM_REGISTER ;
	input [15:0] MULT_8x8 ;
	input [15:0] MULT_16x16 ;
	input [1:0] SELM ;
	output [15:0] OUT;  
	reg [15:0] OUT;  
	 
 
always @(SELM or ADDER_COMBINATORIAL or ACCUM_REGISTER or MULT_8x8 or MULT_16x16)
      case (SELM[1:0])
         2'b00: OUT = ADDER_COMBINATORIAL ; // Combinatorial output
         2'b01: OUT = ACCUM_REGISTER ; // Accumulator register output
         2'b10: OUT = MULT_8x8;  // MULT_8x8
         2'b11: OUT = MULT_16x16;  // MULT_16x16
      endcase	 

endmodule

module ACCUM_REG (
	D ,
	Q ,
	ENA ,
	CLK ,
	RST
	);

	input [15:0] D ;
	output [15:0] Q;
	reg [15:0] Q;
	input ENA ;
	input CLK ;
	input RST;
	
	always @(posedge CLK or posedge RST)
      if (RST) // Syncronous reset overrides all other controls
				Q <= 16'h0 ;
		else
			if(ENA) // Update Q whenever LOAD or ENAble asserted
			    Q <= #1 D ;
			else
				 Q <= #1 Q ;
		
endmodule 

module LOAD_ADD_MUX (
    ADDER ,
	LOAD_DATA ,
	LOAD,
	OUT
   );

	input [15:0] ADDER ;
	input [15:0] LOAD_DATA ;
	input LOAD;
	output [15:0] OUT;
   
	assign OUT = ( (LOAD) ? LOAD_DATA : ADDER ) ;
	
endmodule

module ADDER_A_IN_MUX (
    ACCUMULATOR_REG ,
	DIRECT_INPUT ,
	SELM ,
	ADDER_A_MUX
   );
	
    input [15:0] ACCUMULATOR_REG ;
	input [15:0] DIRECT_INPUT ;
	input SELM ;
	output [15:0] ADDER_A_MUX;

	assign ADDER_A_MUX = ( (SELM) ? DIRECT_INPUT : ACCUMULATOR_REG ) ;

endmodule

module ADDER_B_IN_MUX (
    MULT_INPUT ,
	MULT_8x8 ,
	MULT_16x16 ,
	SIGNEXTIN ,
	SELM ,
	ADDER_B_MUX
	);

    input [15:0] MULT_INPUT ;
	input [15:0] MULT_8x8 ;
	input [15:0] MULT_16x16 ;
	input SIGNEXTIN ;
	input [1:0] SELM ;
	output [15:0] ADDER_B_MUX;
	
//	wire [15:0] DIRECT_8x8_SELECT ;
//	assign DIRECT_8x8_SELECT = ( (SELM[0]) ? MULT_8x8   : MULT_INPUT) ;
//	assign ADDER_B_MUX       = ( (SELM[1:0]=2'b10) ? MULT_16x16 : DIRECT_8x8_SELECT) ;

	reg [15:0] ADDER_B_MUX;
	
always @(SELM or MULT_INPUT or MULT_8x8 or MULT_16x16 or SIGNEXTIN)
      case (SELM[1:0])
         2'b00: ADDER_B_MUX = MULT_INPUT ; 
         2'b01: ADDER_B_MUX = MULT_8x8 ; 
         2'b10: ADDER_B_MUX = MULT_16x16; 
         2'b11: ADDER_B_MUX = {16{SIGNEXTIN}}; 
      endcase	 
	
endmodule

module CARRY_IN_MUX (
	CICAS,
	CI,
	CARRYMUX_SEL,
	ADDER_CI
	);
	
	input CICAS;
	input CI;
	input [1:0] CARRYMUX_SEL;
	output ADDER_CI;
	reg ADDER_CI;
	
always @(CARRYMUX_SEL or CICAS or CI)
      case (CARRYMUX_SEL[1:0])
         2'b00: ADDER_CI = 0 ; 
         2'b01: ADDER_CI = 1 ; 
         2'b10: ADDER_CI = CICAS; 
         2'b11: ADDER_CI = CI; 
      endcase	 

endmodule
	
