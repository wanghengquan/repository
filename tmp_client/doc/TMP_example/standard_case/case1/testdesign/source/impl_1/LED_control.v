//   ==================================================================
//   >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
//   ------------------------------------------------------------------
//   Copyright (c) 2017 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED  
//   ------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement. 
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
//   --------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02 
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
// --------------------------------------------------------------------
//
//  Project:           iCE5UP 5K RGB LED Tutorial 
//  File:              LED_control.v
//  Title:             LED PWM control
//  Description:       Creates RGB PWM per control inputs
//                 
//
// --------------------------------------------------------------------
//
//------------------------------------------------------------
// Notes:
//
//
//------------------------------------------------------------
// Development History:
//
//   __DATE__ _BY_ _REV_ _DESCRIPTION___________________________
//   04/05/17  RK  1.0    Initial tutorial design for Lattice Radiant
//
//------------------------------------------------------------
// Dependencies:
//
// 
//
//------------------------------------------------------------


module LED_control (
        // inputs
        input   wire    clk12M,        // 12M clock
		input wire rst,                //Asynchronous reset
        input   wire    [1:0] color_sel,  // for selecting color using switches
		input   wire    RGB_Blink_En,     //Enabling Blink
        //outputs
        output  reg         red_pwm,       // Red
        output  reg         blu_pwm,       // Blue
        output  reg         grn_pwm       // Green
        );


//------------------------------
// INTERNAL SIGNAL DECLARATIONS: 
//------------------------------
// parameters (constants)
parameter     on_hi = 2'b10;
parameter     on_lo = 2'b01;
parameter     off   = 2'b00; 

parameter     LED_OFF   = 2'b00;
parameter     RAMP_UP   = 2'b01;
parameter     LED_ON    = 2'b10;
parameter     RAMP_DOWN = 2'b11;

parameter     on_max_cnt  = 28'h16E35ED;  // 1 sec steady

parameter Brightness=4'b0111; //50% Brightness
parameter BreatheRamp=4'b0111; //4x
parameter BlinkRate=4'b0101; //1sec


// wires (assigns)
wire [3:0]RGB_color;   
wire   [4:0] red_intensity;
wire   [4:0] grn_intensity;
wire   [4:0] blu_intensity;
wire clk24M;
wire LOCK;

// regs (always)
reg     [1:0] clk_div_cnt;      // 

reg     [3:0] RGB_color_s;    // sample values from SPI i/f      
reg     [3:0] Brightness_s;        
reg     [3:0] BreatheRamp_s;       
reg     [3:0] BlinkRate_s;         

reg     [1:0] red_set;		  // hi/lo/off
reg     [1:0] grn_set;		  
reg     [1:0] blu_set;		  

reg    [31:0] red_peak;		  // LED 'on' peak intensity (high precision)
reg    [31:0] grn_peak;
reg    [31:0] blu_peak;

reg    [27:0] off_max_cnt;  // LED off duration
reg     [3:0] step_shift;      // scaling calculation aid

reg    [27:0] ramp_max_cnt;			// LED ramp up/down duration
reg    [31:0] red_intensity_step;	// LED intensity step when ramping
reg    [31:0] grn_intensity_step;
reg    [31:0] blu_intensity_step;

reg     [1:0] blink_state;          // state variable
reg    [27:0] ramp_count;			// counter for LED on/off duration
reg    [27:0] steady_count;		    // counter for LED ramp up/down duration

reg    [31:0] red_accum;			// intensity accumulator during ramp
reg    [31:0] grn_accum;
reg    [31:0] blu_accum;

reg     [17:0] curr_red;				// current LED intensity ( /256 = PWM duty cycle)
reg     [17:0] curr_grn;
reg     [17:0] curr_blu;

reg     [17:0] pwm_count;            // PWM counter

reg [7:0] count = 8'b0;

//------------------------------
// PLL Instantiation
//------------------------------
//Block to reset the PLL initially

pll_24M __(.ref_clk_i(clk12M ), .rst_n_i(~rst), .lock_o(LOCK), .outcore_o( ), .outglobal_o(clk24M));

//Selecting color using "color_sel"
assign RGB_color = {2'b0,color_sel};

//   Capture stable parameters in local clock domain
always @ (posedge clk24M or posedge rst)
    if (rst) begin
      RGB_color_s   <= 4'b0000;
      Brightness_s  <= 4'b0111;
      BreatheRamp_s <= 4'b0000;
      BlinkRate_s   <= 4'b0101;
    end else if(!RGB_Blink_En) begin
      RGB_color_s   <= RGB_color   ;
      Brightness_s  <= Brightness  ;
      BreatheRamp_s <= 4'b0000 ;
      BlinkRate_s   <= 4'b0000  ;
    end else begin   
      RGB_color_s   <= RGB_color   ;
      Brightness_s  <= Brightness  ;
      BreatheRamp_s <= BreatheRamp ;
      BlinkRate_s   <= BlinkRate   ;
      end


// interpret 'brightness' setting
assign red_intensity =  Brightness_s + 1'b1;
assign grn_intensity = Brightness_s + 1'b1;
assign blu_intensity = Brightness_s + 1'b1;


// interpret 'color' setting
always @ (RGB_color_s)	 
  case (RGB_color_s)
    4'b0000:   begin red_set   <= on_hi; grn_set   <= off;   blu_set   <= off;   end //Red
    4'b0001:   begin red_set   <= on_hi; grn_set   <= on_lo; blu_set   <= off;   end //Orange
    4'b0010:   begin red_set   <= off;   grn_set   <= on_hi; blu_set   <= off;   end //Green
    4'b0011:   begin red_set   <= off;   grn_set   <= on_hi; blu_set   <= on_hi; end //Cyan
    4'b0100:   begin red_set   <= off;   grn_set   <= on_hi; blu_set   <= on_lo; end //SpringGreen
    4'b0101:   begin red_set   <= on_hi; grn_set   <= on_hi; blu_set   <= off;   end //Yellow
    4'b0110:   begin red_set   <= on_lo; grn_set   <= on_hi; blu_set   <= off;   end //Chartreuse
    4'b0111:   begin red_set   <= off;   grn_set   <= on_lo; blu_set   <= on_hi; end //Azure
    4'b1000:   begin red_set   <= off;   grn_set   <= off;   blu_set   <= on_hi; end //Blue
    4'b1001:   begin red_set   <= on_lo; grn_set   <= off;   blu_set   <= on_hi; end //Violet
    4'b1010:   begin red_set   <= on_hi; grn_set   <= off;   blu_set   <= on_hi; end //Magenta
    4'b1011:   begin red_set   <= on_hi; grn_set   <= off;   blu_set   <= on_lo; end //Rose
    4'b1111:   begin red_set   <= on_hi; grn_set   <= on_hi; blu_set   <= on_hi; end //White
    default: begin red_set   <= off;   grn_set   <= off;   blu_set   <= off;   end //2'b00
  endcase

// set peak values per 'brightness' and 'color'
//   when color setting is 'on_lo', then peak intensity is divided by 2
always @ (posedge clk24M or posedge rst)
    if (rst) begin
      red_peak <= 32'b0;
    end else begin
      case (red_set)
        on_hi:  red_peak <= {red_intensity, 27'h000};       // 100%
        on_lo:  red_peak <= {1'b0,red_intensity, 26'h000}; // 50%
        default: red_peak <= 32'h00000;
      endcase
    end
    
always @ (posedge clk24M or posedge rst)
    if (rst) begin
      grn_peak <= 32'b0;
    end else begin
      case (grn_set)
        on_hi:  grn_peak <= {grn_intensity, 27'h000};       // 100%
        on_lo:  grn_peak <= {1'b0,grn_intensity, 26'h000}; // 50%
        default: grn_peak <= 32'h00000;
      endcase
    end
  
always @ (posedge clk24M or posedge rst)
    if (rst) begin
      blu_peak <= 32'b0;
    end else begin
      case (blu_set)
        on_hi:  blu_peak <= {blu_intensity, 27'h000};       // 100%
        on_lo:  blu_peak <= {1'b0,blu_intensity, 26'h000}; // 50%
        default: blu_peak <= 32'h00000;
      endcase
    end
  
// interpret 'Blink rate' setting
//   'off_max_cnt' is time spent in 'LED_OFF' states
//   'step_shift' is used to scale the intensity step size.
//   Stated period is blink rate with no ramp.  Ramping adds to the period.
always @ (posedge clk24M or posedge rst)
    if (rst) begin
      off_max_cnt <= 28'h0 - 1;
      //step_shift     <=  4'b0;
    end else begin
      case (BlinkRate_s)
        4'b0001:   begin off_max_cnt   <= 28'h016E35F; end // 1/16sec
        4'b0010:   begin off_max_cnt   <= 28'h02DC6BE; end // 1/8 sec
        4'b0011:   begin off_max_cnt   <= 28'h05B8D7B; end // 1/4 sec
        4'b0100:   begin off_max_cnt   <= 28'h0B71AF6; end // 1/2 sec
        4'b0101:   begin off_max_cnt   <= 28'h16E35ED; end // 1 sec
        4'b0110:   begin off_max_cnt   <= 28'h2DC6BDA; end // 2 sec
        4'b0111:   begin off_max_cnt   <= 28'h5B8D7B3; end // 4 sec


        default: begin off_max_cnt   <= 28'h0; end //
      endcase
    end


// interpret 'Breathe Ramp' setting
//     'ramp_max_cnt' is time spent in 'RAMP_UP', RAMP_DOWN' states
//     '***_intensity_step' is calculated to add to color accumulators each ramp step
always @ (posedge clk24M or posedge rst)
    if (rst) begin
      ramp_max_cnt        <= 28'b0;
      red_intensity_step  <= 28'b0;
      grn_intensity_step  <= 28'b0;
      blu_intensity_step  <= 28'b0;
    end else begin
      case (BreatheRamp_s)
        4'b0001: begin
                ramp_max_cnt   <= 28'h016E35F;  // 1/16sec
                red_intensity_step  <= red_peak >> (21) ;
                grn_intensity_step  <= grn_peak >> (21) ;
                blu_intensity_step  <= blu_peak >> (21) ;
              end                 
        4'b0010: begin
                ramp_max_cnt   <= 28'h02DC6BE;  // 1/8 sec
               red_intensity_step  <= red_peak >> (22) ;
                grn_intensity_step  <= grn_peak >> (22) ;
                blu_intensity_step  <= blu_peak >> (22) ;                
              end                 
        4'b0011: begin
                ramp_max_cnt   <= 28'h05B8D7B;  // 1/4 sec
                red_intensity_step  <= red_peak >> (23) ;
                grn_intensity_step  <= grn_peak >> (23) ;
                blu_intensity_step  <= blu_peak >> (23) ;                 
              end                 
        4'b0100: begin
		ramp_max_cnt   <=28'h0B71AF6;
               red_intensity_step  <= red_peak >> (24) ;//1/2
                grn_intensity_step  <= grn_peak >> (24) ;
                blu_intensity_step  <= blu_peak >> (24) ;               
              end                 
        4'b0101: begin
                ramp_max_cnt   <= 28'h16E35ED;     // 1 sec
              red_intensity_step  <= red_peak >> (25) ;
                grn_intensity_step  <= grn_peak >> (25) ;
                blu_intensity_step  <= blu_peak >> (25) ;
				              
              end                 
        4'b0110: begin
	ramp_max_cnt   <= 28'h2DC6BDA;
	      red_intensity_step  <= red_peak >> (26) ; //2 sec
                grn_intensity_step  <= grn_peak >> (26) ;
                blu_intensity_step  <= blu_peak >> (26) ;
                                 
              end                 
        4'b0111: begin
                ramp_max_cnt   <= 28'h5B8D7B3;  // 4 sec
               red_intensity_step  <= red_peak >> (27) ;
                grn_intensity_step  <= grn_peak >> (27) ;
                blu_intensity_step  <= blu_peak >> (27) ;                 
              end                 
        default: begin
                ramp_max_cnt        <= 28'd0; 
                red_intensity_step  <= 28'b0;
                grn_intensity_step  <= 28'b0;
                blu_intensity_step  <= 28'b0;
              end                 
      endcase
    end

//  state machine to create LED ON/OFF/RAMP periods
//   state machine is held (no cycles) if LED is steady state on/off
//   state machine is reset to LED_ON state whenever parameters are updated.
always @ (posedge clk24M or posedge rst)
    if (rst) begin
      blink_state <= LED_OFF;
      ramp_count   <= 28'b0;
      steady_count <= 28'b0;
    end else begin
      if(BlinkRate_s == 4'b0000) begin
        blink_state <= LED_ON;
        ramp_count   <= 0;
        steady_count <= 0;
      end else if (BlinkRate_s == 4'b1000) begin
        blink_state <= LED_OFF;
        ramp_count   <= 0;
        steady_count <= 0;
      end else begin
        case (blink_state)
          LED_OFF:  begin
                      if(steady_count >= off_max_cnt) begin
                        ramp_count   <= 0;
                        steady_count <= 0;
                        blink_state <= RAMP_UP;
                      end else begin
                        steady_count <= steady_count + 1;
                      end
                    end
          RAMP_UP:  begin
                      if(ramp_count >= ramp_max_cnt) begin
                        ramp_count   <= 0;
                        steady_count <= 0;
                        blink_state <= LED_ON;
                      end else begin
                        ramp_count <= ramp_count + 1;
                      end
                    end
          LED_ON:  begin
                      if(steady_count >= on_max_cnt) begin
                        ramp_count   <= 0;
                        steady_count <= 0;
                        blink_state <= RAMP_DOWN;
                      end else begin
                        steady_count <= steady_count + 1;
                      end
                    end
          RAMP_DOWN:  begin
                      if(ramp_count >= ramp_max_cnt) begin
                        ramp_count   <= 0;
                        steady_count <= 0;
                        blink_state <= LED_OFF;
                      end else begin
                        ramp_count <= ramp_count + 1;
                      end
                    end
          default:  begin
                      blink_state <= LED_OFF;
                      ramp_count   <= 28'b0;
                      steady_count <= 28'b0;
                    end
        endcase
      end
    end


// RampUP/DN accumulators
always @ (posedge clk24M or posedge rst)
    if (rst) begin
      red_accum <= 32'b0;
      grn_accum <= 32'b0;
      blu_accum <= 32'b0;
    end else begin
      case (blink_state)
        LED_OFF:  begin
                    red_accum <= 0;
                    grn_accum <= 0;
                    blu_accum <= 0;
                  end
        LED_ON:   begin
//                    red_accum <= red_accum;
//                    grn_accum <= grn_accum;
//                    blu_accum <= blu_accum;
                    red_accum <= red_peak;
                    grn_accum <= grn_peak;
                    blu_accum <= blu_peak;
                  end
        RAMP_UP:  begin
                    red_accum <= red_accum + red_intensity_step;
                    grn_accum <= grn_accum + grn_intensity_step;
                    blu_accum <= blu_accum + blu_intensity_step;
                  end
        RAMP_DOWN: begin
                    red_accum <= red_accum - red_intensity_step;
                    grn_accum <= grn_accum - grn_intensity_step;
                    blu_accum <= blu_accum - blu_intensity_step;
                  end
        default: begin
                    red_accum <= 0;
                    grn_accum <= 0;
                    blu_accum <= 0;
                  end
      endcase
    end


// set PWM duty cycle. 8-bit resolution 0x100 is 100% on
always @ (posedge clk24M or posedge rst)
    if (rst) begin
	curr_red <= 18'b0;
      curr_grn <= 18'b0;
      curr_blu <= 18'b0;
    end else begin
      case (blink_state)
        LED_ON: begin
                    curr_red <= red_peak[31:14]; // there should be no discrepancy between _peak and _accum in this state
                    curr_grn <= grn_peak[31:14];
                    curr_blu <= blu_peak[31:14];
                  end
        RAMP_UP: begin
                    curr_red <= red_accum[31:14];
                    curr_grn <= grn_accum[31:14];
                    curr_blu <= blu_accum[31:14];
                  end
        RAMP_DOWN: begin
                    curr_red <= red_accum[31:14];
                    curr_grn <= grn_accum[31:14];
                    curr_blu <= blu_accum[31:14];
                  end
        LED_OFF: begin
                    curr_red <= 0;
                    curr_grn <= 0;
                    curr_blu <= 0;
                  end
        default: begin
                    curr_red <= 0;
                    curr_grn <= 0;
                    curr_blu <= 0;
                  end
      endcase
    end

// generate PWM outputs
always @ (posedge clk24M or posedge rst)
    if (rst) begin
      pwm_count <= 18'b0;
      red_pwm   <= 0;
      grn_pwm   <= 0;
      blu_pwm   <= 0;
    end else begin
      if(pwm_count < 131071)
        pwm_count <= pwm_count + 1;
      else
        pwm_count <= 0;
      
      if(pwm_count < curr_red)       
        red_pwm <= 1;
      else
        red_pwm <= 0;

      if(pwm_count < curr_grn)
        grn_pwm <= 1;
      else
        grn_pwm <= 0;

      if(pwm_count < curr_blu)    
        blu_pwm <= 1;
      else
        blu_pwm <= 0;  
		
    end


endmodule


