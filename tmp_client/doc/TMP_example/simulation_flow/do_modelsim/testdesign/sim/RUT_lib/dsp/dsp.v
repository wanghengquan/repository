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
//  DSP module                                                                 //
// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> VERSION CONTROL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// File Name: dsp.v                                                            //
// Owner: strdom fang                                                           //
// Version History:                                                            //
//   Version   Data        Modifier   Comments                                 //
//   V0.1      3.3.2015   strdom      initial Version                          //
//                                                                             //
// ----------------------------------------------------------------------------//




//Verilog testbench modules of dsp
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////Basic test///////////////////////////////
`include "./RUT_lib/global_param_sets.v"
`include "./RUT_lib/dsp/module_param_sets_02.v"
`include "./local_param_sets.v"


module task_sets_dsp;

//---------------task start
task automatic configuration_test;
    ref Clock;
    ref ClkEn;
    ref Aclr;
    ref [`INDATA_WIDTH_0201-1:0] DataA;
    ref [`INDATA_WIDTH_0201-1:0] DataB;
    ref [`OUTDATA_WIDTH_0201-1:0] Result;
	reg [`OUTDATA_WIDTH_0201-1:0] local_result;
	
	begin
		@(posedge Clock);
		Aclr = 0;
		DataA = 2;
		DataB = 2;
		local_result = 4 ;   //constant data for check
		//----------------check clken=1
		ClkEn = 1;
		@(posedge Clock);   
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock);  //waiting for 4 clk cycle, 1 clk: dataA/dataB into reg; 2-3 clk for DSP, 4 clk for data check
		check_print_result(Result, local_result);
		@(posedge Clock);  // 1clk cycle
		check_print_result(Result, local_result);
		//----------------check clken=0
		ClkEn = 0;
		DataA = 3;
		DataB = 3;
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock);  //waiting for 4 clk cycle
		check_print_result(Result, local_result);
		@(posedge Clock);  // 1clk cycle
		check_print_result(Result, local_result);
		//----------------check rest=1
		Aclr = 1;
		local_result = 0;
		@(posedge Clock);
		check_print_result(Result, local_result);
		@(posedge Clock);  // 1clk cycle
		check_print_result(Result, local_result);
		//---------------for normal work
		Aclr = 0;
		ClkEn = 1;
		@(posedge Clock);   
	end
endtask

task automatic random_test;
    ref Clock;
    ref ClkEn;
    ref Aclr;
    ref [`INDATA_WIDTH_0201-1:0] DataA;
    ref [`INDATA_WIDTH_0201-1:0] DataB;
    ref [`OUTDATA_WIDTH_0201-1:0] Result;
	reg [`OUTDATA_WIDTH_0201-1:0] local_result;
    begin
       for ( int i = 0;  i < 20;  i++)        
        begin
          @(posedge Clock);
          DataA={$random} % `MAX_RANDOM; 
		  DataB={$random} % `MAX_RANDOM; 
		  local_result = DataA*DataB;
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock);  //waiting for 4 clk cycle
		  check_print_result(Result, local_result);
       end
     end
  endtask

task automatic total_order_test;
    ref Clock;
    ref ClkEn;
    ref Aclr;
    ref [`INDATA_WIDTH_0201-1:0] DataA;
    ref [`INDATA_WIDTH_0201-1:0] DataB;
    ref [`OUTDATA_WIDTH_0201-1:0] Result;
	reg [`OUTDATA_WIDTH_0201-1:0] local_result;
    begin
       for ( int i = 0;  i < `MAX_RANDOM;  i++)        
        begin
          @(posedge Clock);
          DataA = i; 
		  DataB = i; 
		  local_result = DataA*DataB;
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock);  //waiting for 4 clk cycle
		  check_print_result(Result, local_result);
       end
     end
  endtask



task automatic check_print_result;
    ref [`OUTDATA_WIDTH_0201-1:0] Result;
	ref [`OUTDATA_WIDTH_0201-1:0] local_result;
	integer outlog;
	begin		
		outlog=$fopen("./outlog.log", "a");
		if (Result!=local_result) begin
	       $display ( "fail: Result = %d, local_result = %d", Result, local_result);
	       $fdisplay( outlog, "fail: Result = %d, local_result = %d", Result, local_result);	       
           $stop;
		end
		else begin
	       $display ( "match: Result = %d, local_result = %d", Result, local_result);
	       $fdisplay( outlog, "match: Result = %d, local_result = %d", Result, local_result);		   
		end
		$fclose(outlog);
	end
endtask

	
endmodule
