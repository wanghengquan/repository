//give a demo comments format that shows what's RUT and it's version later

`include "./local_param_sets.v"

`timescale 1 ns / 1 ps
module sim_top;	
    reg [`ADDRESS_WIDTH_0303 - 1 : 0]	addr ;
    reg [`DATA_WIDTH_0303 - 1 : 0]	data ;
    reg clk;
    reg clken;
    reg rst ;    
    reg [`DATA_WIDTH_0303 - 1 : 0]	qout;    
    
   GSR GSR_INST (.GSR(1'b1));
   PUR PUR_INST (.PUR(1'b1));
    
   sys_signals sys_signals_inst( 
                         .Sysclk(clk),
 						 .Sysclk_En(clken),
 						 .Wclk(),
 						 .Wclk_En(),
 						 .Rclk(),
 						 .Rclk_En(),						 
                         .async_rst(rst),
 						 .sync_rst()
                          );
   
   task_sets_0303 inst();
   
   rtl_top uut (
     .addr(addr),
     .data(data),
     .clk(clk),
     .clken(clken),
     .rst(rst),
     .qout(qout)
     );    
    
   initial
     begin
       #55;
       inst.float_register_depth_lossless (data, addr, clk, clken, rst, qout);
     end

   initial
     begin
       $dumpfile ("./uut.vcd");
       $dumpvars (0, sim_top.uut);
     end
      
endmodule