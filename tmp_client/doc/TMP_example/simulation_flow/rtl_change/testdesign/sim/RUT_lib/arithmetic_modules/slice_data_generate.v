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
// File Name: slice_data_generate.v                                            //
// Owner: Jeffre Ye                                                            //
// Version History:                                                            //
//	Version   	Data       	Modifier       	Comments                           //
//  V0.1      	2.28.2015 	Jeffre Ye    	initial Version                    //
//                                                                             //
// ----------------------------------------------------------------------------//




//Verilog testbench modules of Slice
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////Basic test///////////////////////////////


`include "./RUT_lib/global_param_sets.v"
`include "./RUT_lib/arithmetic_modules/module_param_sets_06.v"
`include "./local_param_sets.v"

module task_data;

	integer dout_file;
	initial dout_file=$fopen("./result.sim");

	
// generate two data	
task automatic two_data_gen;

	ref [`DATA_WIDTH_ADDER_0601 -1 :0] datain1;     // data 1
	input direction1;                          // data 1 direction: 1 is up, 0 is dowm
	input [`DATA_WIDTH_ADDER_0601 -1 :0] step1;     // data 1 step
	ref [`DATA_WIDTH_ADDER_0601 -1 :0] datain2;     // data 2                              
	input direction2;                          // data 2 direction: 1 is up, 0 is dowm
	input [`DATA_WIDTH_ADDER_0601 -1 :0] step2;     // data 2 step                         
	ref  Clock;                                //

	integer i = 0;

	for ( i = 0; i <= 2**(`DATA_WIDTH_ADDER_0601 - 2); i = i + 1) begin
			@ (posedge Clock)
				if (direction1 == 1) begin
					datain1 = datain1 + step1;
				end	
				else begin
					datain1 = datain1 - step1;
				end	
			
				if (direction2 == 1) begin
					datain2 = datain2 + step2;
				end	
				else begin
					datain2 = datain2 - step2;
				end	
	end		


endtask



// check Adder
task automatic adder_data_check;

	ref Clock;
	ref [`DATA_WIDTH_ADDER_0601 -1 :0] d1;
	ref [`DATA_WIDTH_ADDER_0601 -1 :0] d2;
	ref [`DATA_WIDTH_ADDER_0601 -1 :0] data_buffer;

	
	integer i = 0;
	for ( i = 0; i <= `CHECK_DATA_LEN_0600 - 1 ; i = i + 1) begin
		@(negedge Clock)
			if ((d1 + d2) == data_buffer) begin
				$fdisplay (dout_file, "match:  %d +  %d =  %d", d1, d2, data_buffer);
			end	
			else begin
				$fdisplay (dout_file, "fail:  %d +  %d !=  %d", d1, d2, data_buffer);
			end
	end		
	$fclose(dout_file);
 
	

endtask



// check Subtractor
task automatic subtractor_data_check;

	ref Clock;
	ref [`DATA_WIDTH_ADDER_0601 -1 :0] d1;
	ref [`DATA_WIDTH_ADDER_0601 -1 :0] d2;
	ref [`DATA_WIDTH_ADDER_0601 -1 :0] data_buffer;

	
	integer i = 0;
	for ( i = 0; i <= `CHECK_DATA_LEN_0600 - 1 ; i = i + 1) begin
		@(negedge Clock)
			if ((d1 - d2) == data_buffer) begin
				$fdisplay (dout_file, "match:  %d -  %d =  %d", d1, d2, data_buffer);
			end	
			else begin
				$fdisplay (dout_file, "fail:  %d -  %d !=  %d", d1, d2, data_buffer);
			end
	end		
	$fclose(dout_file);
 
	

endtask










endmodule