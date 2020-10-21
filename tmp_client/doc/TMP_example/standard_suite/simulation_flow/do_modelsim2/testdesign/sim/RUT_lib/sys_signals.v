// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> WHAT'S RUT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// ----------------------------------------------------------------------------//
//   Reusable Unified Testbench (RUT) is designed for team-based validation    //
// which can help to both raise our test level and reduce test cycle.          //
//   RUT deliver a common library which contain many packed tasks for different//
// modules.                                                                    //
//   RUT will use limited SystemVerilog features which will help to develop the//
// library greatly.                                                            //
//                                                                             //
// NOTE:                                                                       //
// Copyright by Software Validation team from Lattice Semiconductor Corporation//
// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> FILE DESCRIPTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// ----------------------------------------------------------------------------//
//   this file is used to generate system control signals like:                //
//   (1) clocks/clock enables (system clock, write clock and read clock)       //
//   (2) reset signal                                                          //
//                                                                             //
// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> VERSION CONTROL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// File Name: sys_signals.v                                                    //
// Owner: Yibin Sun                                                            //
// Version History:                                                            //
//   Version   Data        Modifier   Comments                                 //
//   V0.1      12.24.2014  Yibin      initial Version                          //
//                                                                             //
// ----------------------------------------------------------------------------//


`include "./RUT_lib/global_param_sets.v"
`include "./local_param_sets.v"

module sys_signals (
  output Sysclk,
  output reg Sysclk_En,
  output reg Wclk,
  output reg Wclk_En,
  output reg Rclk,
  output reg Rclk_En,  
  output reg async_rst,
  output reg sync_rst
);


/* START: system clock-Sysclk and clock enable generation */
  reg Sysclk_base;
  initial
    begin
	   Sysclk_base <= 1'b1;
       Sysclk_En <= 1'b0;
       # `CLK_EN_ASSERTION Sysclk_En <= 1'b1;
    end

  always begin
    # `HIGH_TIME  Sysclk_base <= 0;
    # `LOW_TIME   Sysclk_base <= 1;	
  end 

  assign # `CLK_SHIFT_VAL Sysclk = Sysclk_base;
  
/* END:*/ 


/* START: write clock-Wclk and clock enable generation */
  reg Wclk_base;
  initial
    begin
	   Wclk_base <= 1'b1;
       Wclk_En <= 1'b0;
       # `WCLK_EN_ASSERTION Wclk_En <= 1'b1;
    end

  always begin
    # `WHIGH_TIME  Wclk_base <= 0;
    # `WLOW_TIME   Wclk_base <= 1;	
  end 

  assign # `WCLK_SHIFT_VAL Wclk = Wclk_base;

/* END:*/ 


/* START: read clock-Rclk and clock enable generation */
  reg Rclk_base;
  initial
    begin
	   Rclk_base <= 1'b1;
       Rclk_En <= 1'b0;
       # `RCLK_EN_ASSERTION Rclk_En <= 1'b1;
    end

  always begin
    # `RHIGH_TIME  Rclk_base <= 0;
    # `RLOW_TIME   Rclk_base <= 1;	
  end 

  assign # `RCLK_SHIFT_VAL Rclk = Rclk_base;

/* END:*/ 




/* START: Asynchronous Reset */
  initial
    begin
      async_rst <= `ASYNC_RST_HIGH_LOW;
      # `ASYNC_RST_ASSERT_LENGTH async_rst <= ~async_rst;
    end
/* END:*/ 


/* START: Synchronous Reset */
  integer cnt;
  initial
    begin
	  sync_rst <= `SYNC_RST_HIGH_LOW;
	  for ( cnt = 0; cnt < `SYNC_RST_ASSERT_CYCLE + 1; cnt = cnt + 1)
	    @( posedge Sysclk);
      sync_rst <= ~sync_rst;
    end
/* END:*/ 
	





	
// Other requiremetns  


endmodule