//give a demo comments format that shows what's RUT and it's version later

`include "./local_param_sets.v"

`timescale 1 ns / 1 ps
module sim_top;	
    reg	[`ADDRESS_WIDTH_0301 - 1 : 0]	Address ;
    reg [`DATA_WIDTH_0301 - 1 : 0]	Data ;
    reg Clock;
    reg We ;
    reg ClockEn;
    reg [`DATA_WIDTH_0301 - 1 : 0]	Q;    
    
   GSR GSR_INST (.GSR(1'b1));
   PUR PUR_INST (.PUR(1'b1));
    
   sys_signals sys_signals_inst( 
                         .Sysclk(Clock),
 						 .Sysclk_En(ClockEn),
 						 .Wclk(),
 						 .Wclk_En(),
 						 .Rclk(),
 						 .Rclk_En(),						 
                         .async_rst(),
 						 .sync_rst()
                          );
   
   task_sets_0301 inst();
   
   
   rtl_top uut (
     .addr(Address),
     .data(Data),
     .clk(Clock),
     .we(We),
     .clken(ClockEn),
     .qout(Q)
     );     
     
   initial
     begin
       #50;
       inst.typical_read_write (Clock, We, Address, Data, Q);
     end

   initial
     begin
       $dumpfile ("./uut.vcd");
       $dumpvars (0, sim_top.uut);
     end
      
endmodule