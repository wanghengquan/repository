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
//   V0.2      1.7.2014    Yibin      fix bug - add flow control for uddcntln  //
//   V0.3      1.8.2014    Yibin      separate control signals, dataflow &     //
//                                    check into three different tasks due to  //
//                                    compatibility                            //
//                                                                             //
// ----------------------------------------------------------------------------//





`include "./RUT_lib/global_param_sets.v"
`include "./RUT_lib/sysio_logic/module_param_sets_01.v"
`include "./local_param_sets.v"

module task_sets_0101;


integer outlog;
initial outlog=$fopen("./outlog.log");


// >>>>>>>>>>>>>>>>>>>>>>>>>> BASIC TESTING : START <<<<<<<<<<<<<<<<<<<<<<<<<<<//
task automatic gddr1248_linear_read;
   ref Clock;
   ref freeze;
   ref uddcntln;
   ref [ `INDATA_WIDTH_0101 - 1 :0] Data;
   ref lock;
   ref sclk;
   ref [ `OUTDATA_WIDTH_0101 - 1 :0] Q;


   reg [ `INDATA_WIDTH_0101 - 1 :0] data_buffer [$];  //Systemverilog feature: queue
   
   begin 
     if(`xo3l == 1 )
       gddr1248_linear_read_controls_xo3(freeze, uddcntln, lock);

 	 fork
	   gddr1248_linear_read_data (Clock, Data, data_buffer);
	   gddr1248_linear_read_check (sclk, Q, data_buffer);
	 join
   end

endtask


//---- control signals

task automatic gddr1248_linear_read_controls_xo3;
  ref freeze; 
  ref uddcntln;
  ref lock;
  
  if (`default_mode_xo3 == 1) begin
    freeze = 0 ;
    uddcntln = 0 ;  // active low to trigger updating the dqs phase alignment
    @(lock)  //wait for DLL lock
    # `CLK_CYCLE uddcntln = 1 ;
  end
  
endtask


//---- data flow

task automatic gddr1248_linear_read_data;
  ref Clock;
  ref [ `INDATA_WIDTH_0101 - 1 :0] Data;
  ref [ `INDATA_WIDTH_0101 - 1 :0] data_buffer [$];
  
  integer i;
  integer j;
  
  for ( i = 0; i <= `SEND_DATA_0101 - 1; i = i + 1) begin
    for ( j = 0; j <= `GEARING_RATE_0101 * 2 -1 ; j = j + 1) begin
       @(Clock) 
	   Data = j + i * 2;
	   data_buffer.push_back(Data);
    end
  end
endtask


//---- check
task automatic gddr1248_linear_read_check;
  ref Clock;
  ref [ `OUTDATA_WIDTH_0101 - 1 :0] Q;
  ref [ `INDATA_WIDTH_0101 - 1 :0] data_buffer [$];
    
  integer i;
  integer j;
  reg [ `INDATA_WIDTH_0101 - 1 :0] buffer_tmp;
  reg [ `OUTDATA_WIDTH_0101 - 1 :0] Q_tmp;
  begin 
    @(posedge Clock)  //wait for the first data after lock single active
    @(posedge Clock)  //wait for the first data after lock single active
    
    for ( i = 0; i <= `SEND_DATA_0101 - 1; i = i + 1) begin
      @(posedge Clock)
      Q_tmp = Q;
      for ( j = 0; j <= `GEARING_RATE_0101 * 2 -1 ; j = j + 1) begin
	    buffer_tmp = data_buffer.pop_front();
	    if ( Q_tmp[`INDATA_WIDTH_0101 - 1 :0] != buffer_tmp) begin 
	       $display ( "fail: Q = %d, data_buffer = %d", Q_tmp[`INDATA_WIDTH_0101 - 1 :0], buffer_tmp);
	       $fdisplay( outlog, "fail: Q = %d, data_buffer = %d", Q_tmp[`INDATA_WIDTH_0101 - 1 :0], buffer_tmp);
	       $fclose(outlog);
           $stop;
    	  end
    	else begin
          $display ( "match: Q = %d, data_buffer = %d", Q_tmp[`INDATA_WIDTH_0101 - 1 :0], buffer_tmp);
          $fdisplay( outlog, "match: Q = %d, data_buffer = %d", Q_tmp[`INDATA_WIDTH_0101 - 1 :0], buffer_tmp);
    	  Q_tmp = Q_tmp >> `INDATA_WIDTH_0101;
    	end
       end
    end
    $display ( "pass" );
    $fdisplay( outlog, "pass" );
    $fclose(outlog);
  end
  
endtask


// >>>>>>>>>>>>>>>>>>>>>>>>>>> BASIC TESTING : END <<<<<<<<<<<<<<<<<<<<<<<<<<<<//




endmodule