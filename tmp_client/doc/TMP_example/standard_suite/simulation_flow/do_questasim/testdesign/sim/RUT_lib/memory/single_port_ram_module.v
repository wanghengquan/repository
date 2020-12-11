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
// single port ram                                                             //
// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> VERSION CONTROL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// File Name: single_port_ram_module.v                                         //
// Owner: Yibin Sun                                                            //
// Version History:                                                            //
//   Version   Data        Modifier   Comments                                 //
//   V0.1      12.28.2014  Yibin      initial Version                          //
//                                                                             //
// ----------------------------------------------------------------------------//




//Verilog testbench modules of single port ram
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////Basic test///////////////////////////////
//----task write&read

`include "./global_param_sets.v"
`include "../local_param_sets.v"

module task_sets_0301;

task automatic linear_read_write;
   ref Clock;
   ref We;
   ref [`ADDRESS_WIDTH_0301 - 1 :0] Address;
   ref [`DATA_WIDTH_0301 - 1:0] Data;
   ref [`DATA_WIDTH_0301 - 1:0] Q;
 
   integer i;
   
   begin 
    We = 1 ;
    Data = 0 ;
	Address = 0 ;
	
	for ( i = 0; i <= `ADDRESS_DEPTH_0301; i = i + 1) begin          //write
       @(posedge Clock);
       Address  = i;
       Data = i;
    end

    We = 0;
    
   `ifdef  WITH_REG_0301
      for ( i = 0; i < `ADDRESS_DEPTH_0301; i = i + 1) begin        //read
         @(posedge Clock);
         #1 Address  = i;
         repeat (3) @(posedge Clock);
         outputfile_check (i,Q);
      end
    `else 
      for ( i = 0 ;  i < `ADDRESS_DEPTH_0301; i = i + 1) begin        //read
         @(posedge Clock);
         Address  = i;
         repeat (2) @(posedge Clock);
         outputfile_check (i,Q);
      end
    `endif      
  end

endtask


//----task outputfile_check
task outputfile_check;
  input ina;
  input inb;

  begin 
    if ( ina == inb )
      $display ( "pass" );
    else  begin 
      $display ( "fail: data =%d, Q =%d", ina, inb );
      $stop;
    end
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