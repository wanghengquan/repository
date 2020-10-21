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

module task_sets_0101;


integer outlog;
initial outlog=$fopen("./outlog.log");

task automatic gddr1248_linear_read;
   ref Clock;
   ref freeze;
   ref uddcntln;
   ref [ `INDATA_WIDTH_0101 - 1 :0] Data;
   ref lock;
   ref sclk;
   ref [ `OUTDATA_WIDTH_0101 - 1 :0] Q;

   integer i;
   integer j;

   reg [ `INDATA_WIDTH_0101 - 1 :0] data_buffer [$];  //Systemverilog feature: queue
   begin 
     freeze = 0 ;
     uddcntln = 1 ;
     Data = 0;
	 
	 @(lock)  //wait for DLL lock
	 @(Clock) //wait for a clock so that the first value 0 can be put into Data of gddr
	 fork
	   for ( i = 0; i <= `SEND_DATA_0101 - 1; i = i + 1) begin
         for ( j = 0; j <= `GEARING_RATE_0101 * 2 -1 ; j = j + 1) begin
           @(Clock) 
		   Data = j + i * 2;
		   data_buffer.push_back(Data);
         end
       end
	   gddr1248_linear_read_check (sclk, Q, data_buffer);
	 join
   end

endtask


//----task outputfile_check
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

  
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////Configuration test/////////////////////
//  task  automatic configuration_test ( input Clock,  ref we , ref [3:0] add , ref [15:0] data ,ref [15:0] Q ) ;
//    begin
//      int i=10;
//      we=1;
//      add  = i;
//      data = 16'h1111;
//      repeat (2) @(posedge Clock);
//      we=0;
//      # ( `CLK_CYCLE / 2) ;
//      if (Q==i)
//      $display ( "configuration : read before write" );  //read before write
//      else if (Q==data)
//      $display ( "configuration : write through" );      //write through
//      else
//      $display ( "configuration : normal" );             //normal
//      end
//  endtask
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////Random test/////////////////////
//  task  automatic random_test ( input Clock,  ref we , ref [3:0] add , ref [15:0] data ,ref [15:0] Q ) ;
//    begin
//       for ( int i = 0;  i < `ADDRESS_DEPTH;  i++)        
//        begin
//          @(posedge Clock);
//          we = $random(`SEED) % 2;
//          add = $random(`SEED) %`ADDRESS_DEPTH;                 //----address random
//          data =  $random(`SEED) %`DATA_MAXIMUM;                   //----date random
//       end
//     end
//  endtask
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////Abnormal test/////////////////////
//  task  automatic abnormal_test ( input Clock,  ref we , ref [3:0] add , ref [15:0] data ,ref [15:0] Q ) ;
//    begin
//    # ( `CLK_CYCLE / 2) ;
//      we = 1 ;
//      for ( int i = 0;  i <= `ADDRESS_DEPTH;  i++) begin     
//        @(posedge Clock);
//         #1 add  = `ADDRESS_DEPTH + i;                 //----address overflow 
//         data = `DATA_MAXIMUM + i;                     //----data overflow
//          end
//      we = 0;
//      for ( int i = 0;  i < `ADDRESS_DEPTH;  i++) begin      
//        @(posedge Clock);
//         #1 add  = i;
//         repeat (3) @(posedge Clock);
//          end
//      end
//  endtask    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////Optional test/////////////////////



endmodule