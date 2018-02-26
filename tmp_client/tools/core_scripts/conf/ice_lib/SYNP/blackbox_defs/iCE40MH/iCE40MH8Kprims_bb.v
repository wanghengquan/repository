//----------------------------------------------------------------- 
// File         : iCE40MH8Kprims_bb.v 
// Module       :   
// Description  : Black box definition for SB_MIPI_RX_2LANE  
//                                          SB_TMDS_deserializer
//                                           SB_PLL40_2F_PAD_DS,
//                                           SB_PLL40_PAD_DS
// Target Tools : Synplify Pro version 201103S - iCECube2 2011.09.  
// 
//                F-201109S Synplify Pro has MIPI, HDMI, MULTIPLIER, PLL_DS 
//                instantiation support. So black box definitons not required
//                - iCECube2 2011.12. 
//-------------------------------------------------------------------

//-------------------------------------------------------------------------
//   BlackBox : SB_MIPI_RX_2LANE 
//-------------------------------------------------------------------------
module    SB_MIPI_RX_2LANE(
        ENPDESER,
        PU,
        DP0,
        DN0,
        D0RXHSEN,
        D0DTXLPP,
        D0DTXLPN,
        D0TXLPEN,
        D0DRXLPP,
        D0DRXLPN,
        D0RXLPEN,
        D0DCDP,
        D0DCDN,
        D0CDEN,
        D0HSDESEREN,
        D0HSRXDATA,
        D0HSBYTECLKD,
        D0SYNC,
        D0ERRSYNC,
        D0NOSYNC,
        DP1,
        DN1,
        D1RXHSEN,
        D1DRXLPP,
        D1DRXLPN,
        D1RXLPEN,
        D1HSDESEREN,
        D1HSRXDATA,
        D1SYNC,
        D1ERRSYNC,
        D1NOSYNC,
        CKP,
        CKN,
        CLKRXHSEN,
        CLKDRXLPP,
        CLKDRXLPN,
        CLKRXLPEN,
        CLKHSBYTE
        )
  // black box definition, pad insertion not needed for 6 device pins       
  /* synthesis syn_black_box black_box_pad_pin="DP1,DN1,DP0,DN0,CKP,CKN"*/;
  

//Common Interface Pins
input           ENPDESER;
input 		PU;
// DATA0 Interface pins
input		DP0;
input		DN0;
input		D0RXHSEN;
input 	        D0DTXLPP;
input 		D0DTXLPN;
input  		D0TXLPEN;
output 		D0DRXLPP;
output  	D0DRXLPN;
input 		D0RXLPEN;
output 		D0DCDP;
output		D0DCDN;
input 		D0CDEN;
input		D0HSDESEREN;
output  [7:0]	D0HSRXDATA;
output 		D0HSBYTECLKD;
output  	D0SYNC;
output  	D0ERRSYNC;
output 		D0NOSYNC;
// DATA1 Interface Pins
input  		DP1;
input  		DN1;
input  		D1RXHSEN;
output          D1DRXLPP;
output  	D1DRXLPN;
input  	        D1RXLPEN;
input  	        D1HSDESEREN;
output  [7:0]   D1HSRXDATA;
output  	D1SYNC;
output  	D1ERRSYNC;
output  	D1NOSYNC;
// CLOCK Interface Pins
input           CKP;
input  		CKN;
input  		CLKRXHSEN;
output          CLKDRXLPP;
output  	CLKDRXLPN;
input  		CLKRXLPEN;
output          CLKHSBYTE;

endmodule

//----------------------------------------------------------------------
//     BlackBox: SB_TMDS_deserializer   
//----------------------------------------------------------------------

module SB_TMDS_deserializer(
                                //TMDS input interface
  input TMDSch0p,             //TMDS ch 0 differential input pos
  input TMDSch0n,             //TMDS ch 0 differential input neg
  input TMDSch1p,             //TMDS ch 1 differential input pos
  input TMDSch1n,             //TMDS ch 1 differential input neg
  input TMDSch2p,             //TMDS ch 2 differential input pos
  input TMDSch2n,             //TMDS ch 2 differential input neg
  input TMDSclkp,             //TMDS clock differential input pos
  input TMDSclkn,             //TMDS clock differential input neg
                                
                                //Receive controller interface
  input RSTNdeser,             //Reset deserailzier logics- active low
  input RSTNpll,               //Reset deserializer PLL- active low
  input EN,                     //Enable deserializer- active high
  input [3:0] PHASELch0,       //Clock phase delay compensation select for ch 0
  input [3:0] PHASELch1,       //Clock phase delay compensation select for ch 1
  input [3:0] PHASELch2,       //Clock phase delay compensation select for ch 2
  output PLLlock,              //PLL lock signal- active high
  output PLLOUTGLOBALclkx1,    //PLL output on global n/w 
  output PLLOUTCOREclkx1,    	//PLL output on global n/w 
  output PLLOUTGLOBALclkx5,    //PLL output on global n/w 
  output PLLOUTCOREclkx5,    	//PLL output on global n/w
  output [9:0] RAWDATAch0,     //Recovered ch 0 10-bit data 
  output [9:0] RAWDATAch1,     //Recovered ch 1 10-bit data
  output [9:0] RAWDATAch2,      //Recovered ch 2 10-bit data
  input	EXTFEEDBACK,  			//Driven by core logic. Not required HDMI mode.
  input	[7:0] DYNAMICDELAY,  	//Driven by core logic. Not required for HDMI mode.
  input	BYPASS,				//Driven by core logic. Not required for HDMI mode.
  input	LATCHINPUTVALUE, 	//iCEGate signal. Not required for HDMI mode
  //Test Pins
  output	SDO,				//Output of PLL
  input	SDI,				//Driven by core logic
  input	SCLK				//Driven by core logic
  )
  // black box definitions - Pad insertion not required for these 8 device pins  
  /* synthesis syn_black_box black_box_pad_pin="TMDSch0p, TMDSch0n, TMDSch1p, TMDSch1n, TMDSch2p, TMDSch2n, TMDSclkp, TMDSclkn "*/;

   parameter   FEEDBACK_PATH = "PHASE_AND_DELAY";
   parameter   SHIFTREG_DIV_MODE=2'b11;
   parameter   PLLOUT_SELECT_PORTA  = "GENCLK";
   parameter   PLLOUT_SELECT_PORTB  = "SHIFTREG_0deg";
   parameter DELAY_ADJUSTMENT_MODE_FEEDBACK = "FIXED";
   parameter DELAY_ADJUSTMENT_MODE_RELATIVE = "FIXED";
        

endmodule


//--------------------------------------------------
//     BlackBox: SB_PLL40_2F_PAD_DS
//----------------------------------------------------

module SB_PLL40_2F_PAD_DS (
		PACKAGEPIN,		
		PACKAGEPINB,		
		PLLOUTCOREA,		//DIN0 output to core logic
		PLLOUTGLOBALA,	   	//PLL output to global network
        PLLOUTCOREB,		//PLL output to core logic
		PLLOUTGLOBALB,	   	//PLL output to global network
		EXTFEEDBACK,  			//Driven by core logic
		DYNAMICDELAY,		//Driven by core logic
		LOCK,				//Output of PLL
		BYPASS,				//Driven by core logic
		RESETB,				//Driven by core logic
		SDI,				//Driven by core logic. Test Pin
		SDO,				//Output to RB Logic Tile. Test Pin
		SCLK,				//Driven by core logic. Test Pin
		LATCHINPUTVALUE 	//iCEGate signal
)/* synthesis syn_black_box black_box_pad_pin="PACKAGEPIN,PACKAGEPINB"*/;
inout 	PACKAGEPIN;		
inout 	PACKAGEPINB;		
output  PLLOUTCOREA;		//PLL output to core logic
output	PLLOUTGLOBALA;	   	//PLL output to global network
output  PLLOUTCOREB;		//PLL output to core logic
output	PLLOUTGLOBALB;	   	//PLL output to global network
input	EXTFEEDBACK;  			//Driven by core logic
input	[7:0] DYNAMICDELAY;  	//Driven by core logic
output	LOCK;				//Output of PLL
input	BYPASS;				//Driven by core logic
input	RESETB;				//Driven by core logic
input	LATCHINPUTVALUE; 	//iCEGate signal
//Test Pins
output	SDO;				//Output of PLL
input	SDI;				//Driven by core logic
input	SCLK;				//Driven by core logic

//Feedback
parameter FEEDBACK_PATH = "SIMPLE";	//String  (simple, delay, phase_and_delay, external) 
parameter DELAY_ADJUSTMENT_MODE_FEEDBACK = "FIXED"; 
parameter DELAY_ADJUSTMENT_MODE_RELATIVE = "FIXED"; 
parameter SHIFTREG_DIV_MODE = 2'b00; //00-->Divide by 4, 01-->Divide by 7, 11-->Divide by 5.
parameter FDA_FEEDBACK = 4'b0000; 		//Integer. 

//Output 
parameter FDA_RELATIVE = 4'b0000; 		//Integer. 
parameter PLLOUT_SELECT_PORTA = "GENCLK"; //
parameter PLLOUT_SELECT_PORTB = "GENCLK"; //

//Use the Spreadsheet to populate the values below.
parameter DIVR = 4'b0000; 	//determine a good default value
parameter DIVF = 7'b0000000; //determine a good default value
parameter DIVQ = 3'b000; 	//determine a good default value
parameter FILTER_RANGE = 3'b000; 	//determine a good default value

//Additional cbits
parameter ENABLE_ICEGATE_PORTA = 1'b0;
parameter ENABLE_ICEGATE_PORTB = 1'b0;

//Test Mode parameter
parameter TEST_MODE = 1'b0;
parameter EXTERNAL_DIVIDE_FACTOR = 1; //Not used by model. Added for PLL Config GUI.


endmodule // SB_PLL40_2F_PAD_DS


//-------------------------------------------------------
//   BlackBox:  SB_PLL40_PAD_DS
//------------------------------------------------------

module SB_PLL40_PAD_DS (
		PACKAGEPIN,		
		PACKAGEPINB,		
		PLLOUTCORE,		//PLL output to core logic
		PLLOUTGLOBAL,	   	//PLL output to global network
		EXTFEEDBACK,  			//Driven by core logic
		DYNAMICDELAY,		//Driven by core logic
		LOCK,				//Output of PLL
		BYPASS,				//Driven by core logic
		RESETB,				//Driven by core logic
		SDI,				//Driven by core logic. Test Pin
		SDO,				//Output to RB Logic Tile. Test Pin
		SCLK,				//Driven by core logic. Test Pin
		LATCHINPUTVALUE 	//iCEGate signal
)/* synthesis syn_black_box black_box_pad_pin="PACKAGEPIN,PACKAGEPINB"*/;
inout 	PACKAGEPIN;		
inout 	PACKAGEPINB;		
output 	PLLOUTCORE;		//PLL output to core logic
output	PLLOUTGLOBAL;	   	//PLL output to global network
input	EXTFEEDBACK;  			//Driven by core logic
input	[7:0] DYNAMICDELAY;  	//Driven by core logic
output	LOCK;				//Output of PLL
input	BYPASS;				//Driven by core logic
input	RESETB;				//Driven by core logic
input	LATCHINPUTVALUE; 	//iCEGate signal
//Test Pins
output	SDO;				//Output of PLL
input	SDI;				//Driven by core logic
input	SCLK;				//Driven by core logic


//Feedback
parameter FEEDBACK_PATH = "SIMPLE";	//String  (simple, delay, phase_and_delay, external) 
parameter DELAY_ADJUSTMENT_MODE_FEEDBACK = "FIXED"; 
parameter DELAY_ADJUSTMENT_MODE_RELATIVE = "FIXED"; 
parameter SHIFTREG_DIV_MODE = 2'b00; //00-->Divide by 4, 01-->Divide by 7, 11-->Divide by 5.
parameter FDA_FEEDBACK = 4'b0000; 		//Integer. 

parameter FDA_RELATIVE = 4'b0000; 		//Integer. 
parameter PLLOUT_SELECT = "GENCLK"; //

//Use the Spreadsheet to populate the values below.
parameter DIVR = 4'b0000; 	//determine a good default value
parameter DIVF = 7'b0000000; //determine a good default value
parameter DIVQ = 3'b000; 	//determine a good default value
parameter FILTER_RANGE = 3'b000; 	//determine a good default value

//Additional cbits
parameter ENABLE_ICEGATE = 1'b0;

//Test Mode parameter
parameter TEST_MODE = 1'b0;
parameter EXTERNAL_DIVIDE_FACTOR = 1; //Not used by model. Added for PLL Config GUI.

endmodule // SB_PLL40_PAD_DS

//----------------------------------------------------------------------------------------------------------------------
