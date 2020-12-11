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
// File Name: dcc_clock_check.v                                                //
// Owner: Jason Wang                                                           //
// Version History:                                                            //
//   Version   Data        Modifier   Comments                                 //
//   V0.1      4.27.2015   Jason      initial Version                          //
//                                                                             //
// ----------------------------------------------------------------------------//




//Verilog testbench modules of single port ram
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////Basic test///////////////////////////////
//----task write&read

`include "./RUT_lib/global_param_sets.v"
`include "./RUT_lib/sysclock/module_param_sets_04.v"
`include "./local_param_sets.v"


`timescale 1 ns / 1 ps;
module task_sets_0403;


integer outlog;
initial outlog=$fopen("./outlog.log");

task automatic frequency_check;
   ref clki;
   ref clko;
   ref clke;
   
   integer in_raise = 0;
   integer in_fall = 0;
   integer out_raise = 0;
   integer out_fall = 0;
   integer in_cycle = 0;
   integer out_cycle = 0;
  begin 
    $display ( "Process: frequency check");
    @(clke)  //wait for clock enable
    # `CLOCK_DELAY;
    fork
    @(posedge clki)
    begin
        in_raise = $realtime;
    end
    @(negedge clki)
    begin
        in_fall = $realtime;
    end    
    
    @(posedge clko)
    begin
        out_raise = $realtime;
    end
    
    @(negedge clko)
    begin
        out_fall = $realtime;
    end      
    join
    in_cycle = (in_fall - in_raise) * 2;
    out_cycle = (out_fall - out_raise) * 2;
    $display (">>>in cycle:%d", in_cycle);
    $display (">>>out cycle:%d", out_cycle);
    if (in_cycle ==  out_cycle || in_cycle ==  -out_cycle)
        begin
            $display ( "pass: frequency match");
            $fdisplay( outlog, "pass: frequency match");
        end
    else
        begin
            $display ("fail: frequency not match");
            $display (">>>in raise:%d", in_raise);
            $display (">>>in fall:%d", in_fall);
            $display (">>>out raise:%d", out_raise);
            $display (">>>out fall:%d", out_fall);
            $display (">>>in cycle:%d", in_cycle);
            $display (">>>out cycle:%d", out_cycle);
            $fdisplay( outlog, "fail: frequency not match");
        end	 
  end
endtask

endmodule
