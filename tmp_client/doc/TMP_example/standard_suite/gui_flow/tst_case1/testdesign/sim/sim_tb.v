//give a demo comments format that shows what's RUT and it's version later

`include "./RUT_lib/global_param_sets.v"
`include "./local_param_sets.v"

module sim_top;	
	reg sysclock;
    reg clki;
    reg rst ;
    reg clkop;
    reg clkos;
    reg lock;
    
    GSR GSR_INST (.GSR(1'b1));
    PUR PUR_INST (.PUR(1'b1));
    
   sys_signals sys_signals_inst( 
                         .Sysclk(sysclock),
						 .Sysclk_En(),
						 .Wclk(clki),
						 .Wclk_En(),
						 .Rclk(),
						 .Rclk_En(), 
                         .async_rst(rst),
						 .sync_rst()
                         );
  task_sets_0401 inst();
  
  
  module_top uut (.CLKI(clki), .RST(rst), .CLKOP(clkop), .CLKOS(clkos), .LOCK(lock);

   
    initial
      begin
        #100;
		inst.frequency_check (sysclock, clkop, lock);
		//inst.frequency_check (clkos, lock);
		//inst.phaseshift_check (clkop, clkos, lock);
        $stop  ;
      end

   initial
      begin
        $dumpfile ("./mydesign.dump");
        $dumpvars (0, sim_top.uut);
   end
      
endmodule