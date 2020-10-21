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
// sdr module                                                                  //
// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> VERSION CONTROL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// File Name: gddr_rx_sets.v                                                   //
// Owner: Yibin Sun                                                            //
// Version History:                                                            //
//   Version   Data        Modifier   Comments                                 //
//   V0.1      5.12.2015   Yibin      initial Version                          //
//                                                                             //
// ----------------------------------------------------------------------------//





`include "./RUT_lib/global_param_sets.v"
`include "./RUT_lib/sysio_logic/module_param_sets_01.v"
`include "./local_param_sets.v"

module task_sets_0001;


integer outlog;
initial outlog=$fopen("./outlog.log");

task endup;
  $fclose(outlog);
  $stop;
endtask

// >>>>>>>>>>>>>>>>>>>>>>>>>> BASIC TESTING : START <<<<<<<<<<<<<<<<<<<<<<<<<<<//
task automatic sdr_linear_rw;
   ref Reset;
   ref Clock;
   ref sclk;
   ref [ `WIDTH_0001 - 1 :0] Data;
   ref [ `WIDTH_0001 - 1 :0] Q;
   `ifdef sdr_tri_mode_for_write
     ref tristate;
   `endif
   
   reg [ `WIDTH_0001 - 1 :0] data_buffer [$];  //Systemverilog feature: queue
   
   begin
     wait (Reset == 1);
     
     `ifdef sdr_tri_mode_for_write
       control_signals (0, Clock, tristate);
       control_signals (1, Clock, tristate);
     `endif 	 
     fork
     `ifdef sdr_read
	   sdr_linear_read_data (Clock, Data, data_buffer);   //use input clock to sample input data
	   sdr_linear_read_check (sclk, Q, data_buffer);      //use internal generated sclk to sample output data from interface
     `endif
     `ifdef sdr_write
	   sdr_linear_write_data (Clock, Data, data_buffer);   //use input clock to sample input data
	   sdr_linear_write_check (sclk, Q, data_buffer);      //use internal generated sclk to sample output data from interface
     `endif     
	 join
   end

endtask


//---- control signals
task automatic control_signals;
  input bit step;
  ref Clock;
  ref tristate;

  if(step == 1'b0)  //initial state
    tristate = 1;   //high Z  
  else
    tristate = ~tristate;
  
  @(posedge Clock);
  @(posedge Clock);
endtask

//---- data flow for write

task automatic sdr_linear_write_data;
  ref Clock;
  ref [ `WIDTH_0001 - 1 :0] Data;
  ref [ `WIDTH_0001 - 1 :0] data_buffer [$];
  
  integer i;
  
  for ( i = 0; i <= `SEND_DATA_0001 - 1; i = i + 1) begin
    @(posedge Clock);
    //@(Clock);
    Data = i;
    data_buffer.push_back(Data);
  end
endtask


//---- check for write
task automatic sdr_linear_write_check;
  ref Clock;
  ref [ `WIDTH_0001 - 1 :0] Q;
  ref [ `WIDTH_0001 - 1 :0] data_buffer [$];
    
  integer i;
  integer j;
  reg [ `WIDTH_0001 - 1 :0] buffer_tmp;
  reg [ `WIDTH_0001 - 1 :0] Q_tmp;
  begin 
    
    for ( i = 0; i <= `SEND_DATA_0001 - 1; i = i + 1) begin
      //@(posedge Clock);
      Q_tmp = Q;
      @(posedge Clock);   //unlike read, this clock waiting should be moved after Q_tmp = Q; which is execution order:
                          //this Clock(clkout) is driven by system Clock, but not like the one for read (system clock).
	  buffer_tmp = data_buffer.pop_front();
	  if ( Q_tmp != buffer_tmp) begin 
	       $display ( "fail: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
	       $fdisplay( outlog, "fail: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
	       $fclose(outlog);
           $stop;
      end
      else begin
          $display ( "match: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
          $fdisplay( outlog, "match: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
      end
    end
    $display ( "pass" );
    $fdisplay( outlog, "pass" );
    //$fclose(outlog);
  end
  
endtask


//---- data flow for read

task automatic sdr_linear_read_data;
  ref Clock;
  ref [ `WIDTH_0001 - 1 :0] Data;
  ref [ `WIDTH_0001 - 1 :0] data_buffer [$];
  
  integer i;
  
  for ( i = 0; i <= `SEND_DATA_0001 - 1; i = i + 1) begin
    @(Clock);
    @(Clock);
    Data = i;
    data_buffer.push_back(Data);
  end
endtask


//---- check for read
task automatic sdr_linear_read_check;
  ref Clock;
  ref [ `WIDTH_0001 - 1 :0] Q;
  ref [ `WIDTH_0001 - 1 :0] data_buffer [$];
    
  integer i;
  integer j;
  reg [ `WIDTH_0001 - 1 :0] buffer_tmp;
  reg [ `WIDTH_0001 - 1 :0] Q_tmp;
  begin 
    @(posedge Clock);  //wait for the first data after lock single active
    @(posedge Clock);  //wait for the first data after lock single active
    
    for ( i = 0; i <= `SEND_DATA_0001 - 1; i = i + 1) begin
      @(posedge Clock);
      Q_tmp = Q;
	  buffer_tmp = data_buffer.pop_front();
	  if ( Q_tmp != buffer_tmp) begin 
	       $display ( "fail: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
	       $fdisplay( outlog, "fail: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
	       $fclose(outlog);
           $stop;
      end
      else begin
          $display ( "match: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
          $fdisplay( outlog, "match: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
      end
    end
    $display ( "pass" );
    $fdisplay( outlog, "pass" );
    //$fclose(outlog);
  end
  
endtask

// >>>>>>>>>>>>>>>>>>>>>>>>>>> BASIC TESTING : END <<<<<<<<<<<<<<<<<<<<<<<<<<<<//





// >>>>>>>>>>>>>>>>>>>>>> CONFIGURATION TESTING : START <<<<<<<<<<<<<<<<<<<<<<<//
task automatic sdr_linear_read_with_datadelay;
   ref Clock;
   ref sclk;
   ref [ `WIDTH_0001 - 1 :0] Data;
   ref [ `WIDTH_0001 - 1 :0] Q;
   ref [ `WIDTH_0001 - 1 :0] data_direction;
   ref [ `WIDTH_0001 - 1 :0] data_loadn;
   ref [ `WIDTH_0001 - 1 :0] data_move;
   ref [ `WIDTH_0001 - 1 :0] data_cflag;  
   
   
   reg [ `WIDTH_0001 - 1 :0] data_buffer [$];  //Systemverilog feature: queue
   
   begin
     
     controls_initial (Clock, data_direction, data_loadn, data_move);

     begin
 	   fork
	     sdr_linear_read_data (Clock, Data, data_buffer);   //use input clock to sample input data
	     sdr_linear_read_check (sclk, Q, data_buffer);      //use internal generated sclk to sample output data from interface
       join  
	   
       begin //reduce
         data_delay_inserted (.direction(1), .delay_value(10), .reset_load_n(1), .Clock(Clock), .data_direction(data_direction), .data_loadn(data_loadn), .data_move(data_move), .data_cflag(data_cflag));
  	     fork
           sdr_linear_read_data (Clock, Data, data_buffer);   //use input clock to sample input data
	       sdr_linear_read_check (sclk, Q, data_buffer);      //use internal generated sclk to sample output data from interface
	     join
	   end
       
	   begin //reset
         data_delay_inserted (.direction(0), .delay_value(1000), .reset_load_n(0), .Clock(Clock), .data_direction(data_direction), .data_loadn(data_loadn), .data_move(data_move), .data_cflag(data_cflag));
   	     fork
           sdr_linear_read_data (Clock, Data, data_buffer);   //use input clock to sample input data
	       sdr_linear_read_check (sclk, Q, data_buffer);      //use internal generated sclk to sample output data from interface
	     join
	   end
	  
	   begin //increase to max
         data_delay_inserted (.direction(0), .delay_value(1000), .reset_load_n(1), .Clock(Clock), .data_direction(data_direction), .data_loadn(data_loadn), .data_move(data_move), .data_cflag(data_cflag));
	     fork
   	       sdr_linear_read_data (Clock, Data, data_buffer);   //use input clock to sample input data
	       sdr_linear_read_check (sclk, Q, data_buffer);      //use internal generated sclk to sample output data from interface	   
	     join
	   end  
     end
   end
endtask


//---- control signals
task automatic controls_initial;
   ref Clock;
   ref [ `WIDTH_0001 - 1 :0] data_direction;
   ref [ `WIDTH_0001 - 1 :0] data_loadn;
   ref [ `WIDTH_0001 - 1 :0] data_move;
   
    data_direction = -1;
    data_loadn = -1;
    data_move = -1;  
    @ (posedge Clock);
    @ (posedge Clock);
endtask

task automatic data_delay_inserted;
      input bit direction;                        //direction
      input integer delay_value;                  //delay value for data path
      input bit reset_load_n;                     //reset the delay value to default setting
      ref Clock;
      ref [ `WIDTH_0001 - 1 :0] data_direction;   //"1" to decrease delay & "0" to increase delay
      ref [ `WIDTH_0001 - 1 :0] data_loadn;       //"0" on LOADN will reset to default Delay setting
      ref [ `WIDTH_0001 - 1 :0] data_move;        //"Pulse" on MOVE will change delay setting. DIRECTION will be sampled at "falling edge" of MOVE
	  ref [ `WIDTH_0001 - 1 :0] data_cflag;       //Flag indicating the delay counter has reached max (when moving up) or min (when moving down) value
      
      integer i = 0 ; 
      
  begin
    if (!reset_load_n) begin
      data_loadn = 'd0;
      @ (posedge Clock);
      @ (posedge Clock);
      data_loadn = -1;
    end  
    else begin
      if( direction == 0 )  //increase the delay
         data_direction = 'd0;
      else                    //decrease the delay
         data_direction = -1;  
      for (i = 0; i <= delay_value - 1; i = i + 1 ) begin
        if( data_cflag == 0) begin
          data_move ='d0;
          @ (posedge Clock);
          @ (posedge Clock);
          data_move =2'b11;
          @ (posedge Clock);
          @ (posedge Clock);
        end
        else
          break;
      end
    end
  end
  
endtask


// >>>>>>>>>>>>>>>>>>>>>> CONFIGURATION TESTING : START <<<<<<<<<<<<<<<<<<<<<<<//




endmodule