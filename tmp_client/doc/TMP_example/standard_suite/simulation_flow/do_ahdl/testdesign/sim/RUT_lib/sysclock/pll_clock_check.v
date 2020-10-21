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
//   this file contain all the tasks/functions that can be used to verify      //
// generic ddr module                                                          //
// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> VERSION CONTROL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// File Name: gddr_rx_sets.v                                                   //
// Owner: Yibin Sun                                                            //
// Version History:                                                            //
//   Version   Data        Modifier   Comments                                 //
//   V0.1      12.30.2014  Yibin      initial Version                          //
//                                                                             //
// ----------------------------------------------------------------------------//




//Verilog testbench modules of single port ram
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////Basic test///////////////////////////////
//----task write&read

`include "./global_param_sets.v"
`include "../local_param_sets.v"

module task_sets_0401;


integer outlog;
initial outlog=$fopen("./outlog.log");

task automatic frequency_check;
   ref sysclock;
   ref clkop;
   ref lock;
 
   integer i;
   integer j;
   begin 
	 
	 @(lock)  //wait for DLL lock
	 wait (clkop == 1'b1);
	 flag = 0;
	 fork
	 always @(clkop)
	 begin
	 	flag = flag + 1;
	 end
	 	 
	 always @(posedge sysclock); //wait for a clock so that the first value 0 can be put into Data of gddr
	 begin
	 	if (flag = 1)
	 		j = j + 1;
	 	if(flag = 2)
	 		j = j + 1;
	 		
	 	if (j == xxx)
	 	begin
	 		$display ( "pass: frequency match");
	        $fdisplay( outlog, "pass: frequency match");
	    end
	    else
	    begin
	    	$display ( "fail: frequency not match");
	        $fdisplay( outlog, "fail: frequency not match");
	    end
	 join
	 
	 end
endtask

endmodule