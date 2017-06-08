//give a demo comments format that shows what's RUT and it's version later

`include "./RUT_lib/global_param_sets.v"
`include "./RUT_lib/sys_signals.v"
`include "./RUT_lib/sysio_logic/sdr_sets.v"
`include "./RUT_lib/sysio_logic/module_param_sets_01.v"
`include "./local_param_sets.v"

module sim_top;	
	
    reg Clock ;
    reg Reset ;
    reg [ `WIDTH_0001 - 1 :0] Data ;
    reg [ `WIDTH_0001 - 1 :0] Q ;
    reg sclk;
    
   GSR GSR_INST (.GSR(1'b1));
   PUR PUR_INST (.PUR(1'b1));
    
   sys_signals sys_signals_inst( 
                         .Sysclk(Clock),
 						 .Sysclk_En(),
 						 .Wclk(),
 						 .Wclk_En(),
 						 .Rclk(),
 						 .Rclk_En(),						 
                         .async_rst(Reset),
 						 .sync_rst()
                          );
   
   task_sets_0001 inst();
   
   
   top uut (
     .clkin(Clock),
     .reset(!Reset),
     .datain(Data),
     .wrapout(),   //no use, just used to keep the net name
     .sclk(sclk),
     .q(Q)
     );
   
   initial
     begin
       #20;
       inst.sdr_linear_rw (Reset, Clock, sclk, Data, Q);
       //configuration_test(Clock, WE, Address, Data ,Q );
       //random_test(Clock, WE, Address, Data ,Q );
       //abnormal_test(Clock, WE, Address, Data ,Q );
       $stop ;
     end

   initial
     begin
       $dumpfile ("./uut.vcd");
       $dumpvars (0, sim_top.uut);
     end
      
endmodule