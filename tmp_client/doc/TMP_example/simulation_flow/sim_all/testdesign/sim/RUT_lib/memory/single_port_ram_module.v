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
// Owner: Dwyane Yang                                                          //
// Version History:                                                            //
//   Version    Data        Modifier         Comments                          //
//   V0.1     3.16.2015    Dwyane Yang    initial Version                      //
//                                                                             //
// ----------------------------------------------------------------------------//




//Verilog testbench modules of single port ram
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////Basic test///////////////////////////////
//----task write&read

`include "./RUT_lib/global_param_sets.v"
`include "./RUT_lib/memory/module_param_sets_03.v"
`include "./local_param_sets.v"

module task_sets_0301;

integer outlog;
initial outlog=$fopen("./outlog.log");

task automatic typical_read_write;
   ref Clock;
   ref We;
   ref [`ADDRESS_WIDTH_0301 - 1 :0] Address;
   ref [`DATA_WIDTH_0301 - 1:0] Data;
   ref [`DATA_WIDTH_0301 - 1:0] Q;
 
   integer i , j;
   reg [ `DATA_WIDTH_0301 - 1 :0] data_buffer [$];  //Systemverilog feature: queue
   reg [ `DATA_WIDTH_0301 - 1 :0] Q_buffer [$];
   
   begin 
    We = 1 ;
    Data = 0 ;
	Address = 0 ;

	  for ( i = 0; i < `ADDRESS_DEPTH_0301; i = i + 1) begin          //write
         @(negedge Clock);
         Address  = i;
         Data = i;
         data_buffer.push_back(Data);
      end
      
      We = 0;
      
      
      fork 

        begin
          for ( i = 0; i < `ADDRESS_DEPTH_0301; i = i + 1) begin        //read
             @(negedge Clock);
             Address  = i;  
          end
        end
                            
        begin
            if  (`WITH_REG_0301 == 1) begin
              @(posedge Clock)
              @(posedge Clock)        
              for ( j = 0; j < `ADDRESS_DEPTH_0301; j = j + 1) begin 
                 @(posedge Clock);       
                 Q_buffer.push_back(Q);
              end
            end
            else begin 
              @(posedge Clock)      
              for ( j = 0; j < `ADDRESS_DEPTH_0301; j = j + 1) begin 
                 @(posedge Clock);       
                 Q_buffer.push_back(Q);
              end   
            end      
        end
      join

      typical_read_write_check (Clock, Q_buffer, data_buffer);
  end

endtask

task automatic typical_read;
   ref Clock;
   ref We;
   ref [`ADDRESS_WIDTH_0301 - 1 :0] Address;
   ref [`DATA_WIDTH_0301 - 1:0] Data;
   ref [`DATA_WIDTH_0301 - 1:0] Q;
 
   integer i , j;
   reg [ `DATA_WIDTH_0301 - 1 :0] data_buffer [$];  //Systemverilog feature: queue
   reg [ `DATA_WIDTH_0301 - 1 :0] Q_buffer [$];
   
   begin 
    We = 0 ;
    Data = 0 ;
	Address = 0 ;

	  for ( i = 0; i <= `ADDRESS_DEPTH_0301; i = i + 1) begin          //write
         @(negedge Clock);
         data_buffer.push_back(i);
      end
      
      We = 0;
      
      
      fork 

        begin
          for ( i = 0; i < `ADDRESS_DEPTH_0301; i = i + 1) begin        //read
             @(negedge Clock);
             Address  = i;  
          end
        end
                            
        begin
            if  (`WITH_REG_0301 == 1) begin
              @(posedge Clock)
              @(posedge Clock)        
              for ( j = 0; j < `ADDRESS_DEPTH_0301; j = j + 1) begin 
                 @(posedge Clock);       
                 Q_buffer.push_back(Q);
              end
            end
            else begin 
              @(posedge Clock)      
              for ( j = 0; j < `ADDRESS_DEPTH_0301; j = j + 1) begin 
                 @(posedge Clock);       
                 Q_buffer.push_back(Q);
              end   
            end      
        end
      join

      typical_read_write_check (Clock, Q_buffer, data_buffer);
  end

endtask

//----task outputfile_check
task automatic typical_read_write_check;
  ref Clock;
  ref [ `DATA_WIDTH_0301 - 1 :0] Q_buffer [$];
  ref [ `DATA_WIDTH_0301 - 1 :0] data_buffer [$];
    
  integer i;
  integer j;
  reg [ `DATA_WIDTH_0301 - 1 :0] buffer_tmp;
  reg [ `DATA_WIDTH_0301 - 1 :0] Q_tmp;
  begin 
    @(posedge Clock)  //wait for the first data after lock single active
    @(posedge Clock)  //wait for the first data after lock single active
 
      for ( j = 0; j <= `ADDRESS_DEPTH_0301  -1 ; j = j + 1) begin
	    buffer_tmp = data_buffer.pop_front();
	    Q_tmp = Q_buffer.pop_front();
	    if ( Q_tmp != buffer_tmp) begin 
	       $display ( "fail: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
	       $fdisplay( outlog, "fail: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
	       $fclose(outlog);
           //$stop;
    	  end
    	else begin
          $display ( "match: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
          $fdisplay( outlog, "match: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
    	  Q_tmp = Q_tmp >> `DATA_WIDTH_0301;
    	end
       end
       
    $display ( "pass" );
    $fdisplay( outlog, "pass" );
    $fclose(outlog);
  end
  
endtask


////----task outputfile_check
//task outputfile_check;
//  input ina;
//  input inb;
//
//  begin 
//    if ( ina == inb )
//      $display ( "pass" );
//    else  begin 
//      $display ( "fail: data =%d, Q =%d", ina, inb );
//      $stop;
//    end
//  end
//
//endtask

  
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