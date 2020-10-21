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
// File Name: ram_shift_register_module.v                                      //
// Owner: Jason Wang                                                           //
// Version History:                                                            //
//   Version    Data        Modifier         Comments                          //
//   V0.1     5.14.2015    Jason Wang    initial Version                      //
//                                                                             //
// ----------------------------------------------------------------------------//




//Verilog testbench modules of single port ram
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////Basic test///////////////////////////////
//----task write&read

`include "./RUT_lib/global_param_sets.v"
`include "./RUT_lib/memory/module_param_sets_03.v"
`include "./local_param_sets.v"

module task_sets_0303;

integer outlog;
initial outlog=$fopen("./outlog.log");


task automatic fixed_register_depth;
    ref [`DATA_WIDTH_0303 - 1:0] data;
    ref clk;
    ref clken;
    ref rst;
    ref [`DATA_WIDTH_0303 - 1:0] qout;
  
    integer i , j;
    reg [ `DATA_WIDTH_0303 - 1 :0] data_buffer [$];  //Systemverilog feature: queue
    reg [ `DATA_WIDTH_0303 - 1 :0] Q_buffer [$];
   
    begin 
   
	for ( i = 0; i < `FIXED_REG_DEPTH_0303; i = i + 1) begin          //write
        @(posedge clk);
        data = $random();
        data_buffer.push_back(data);
    end

    begin                                                              //read
        if  (`WITH_REG_0303 == 1) begin
            @(posedge clk)       
            for ( j = 0; j < `FIXED_REG_DEPTH_0303; j = j + 1) begin 
                @(posedge clk);       
                Q_buffer.push_back(qout);
            end
        end
        else begin       
            for ( j = 0; j < `FIXED_REG_DEPTH_0303; j = j + 1) begin 
                @(posedge clk);       
                Q_buffer.push_back(qout);
            end   
        end      
    end
    fixed_shift_register_check (clk, Q_buffer, data_buffer);
    end

endtask

task automatic fixed_register_depth_with_ini;
    ref [`DATA_WIDTH_0303 - 1:0] data;
    ref clk;
    ref clken;
    ref rst;
    ref [`DATA_WIDTH_0303 - 1:0] qout;
  
    integer i , j;
    reg [ `DATA_WIDTH_0303 - 1 :0] data_buffer [$];  //Systemverilog feature: queue
    reg [ `DATA_WIDTH_0303 - 1 :0] Q_buffer [$];
   
    begin 
   
	for ( i = 0; i < `FIXED_REG_DEPTH_0303; i = i + 1) begin          //write
        data_buffer.push_back(i);
    end

    begin                                                              //read
        if  (`WITH_REG_0303 == 1) begin
            @(posedge clk)       
            for ( j = 0; j < `FIXED_REG_DEPTH_0303; j = j + 1) begin 
                @(posedge clk);       
                Q_buffer.push_back(qout);
            end
        end
        else begin       
            for ( j = 0; j < `FIXED_REG_DEPTH_0303; j = j + 1) begin 
                @(posedge clk);       
                Q_buffer.push_back(qout);
            end   
        end      
    end
    fixed_shift_register_check (clk, Q_buffer, data_buffer);
    end

endtask


task automatic float_register_depth_lossy;
    ref [`DATA_WIDTH_0303 - 1:0] data;
    ref [`ADDRESS_WIDTH_0303 - 1:0] addr;
    ref clk;
    ref clken;
    ref rst;
    ref [`DATA_WIDTH_0303 - 1:0] qout;
  
    integer i , j;
    integer vaild_reg_depth;
    reg [ `DATA_WIDTH_0303 - 1 :0] data_buffer [$];  //Systemverilog feature: queue
    reg [ `DATA_WIDTH_0303 - 1 :0] Q_buffer [$];
   
    addr = `FLOAT_REG_DEPTH_0303 / 2;
    vaild_reg_depth = `FLOAT_REG_DEPTH_0303 - addr;
    $display ( "addr:%d",addr);
    $display ( "vaild_reg_depth:%d",vaild_reg_depth);
        
    begin 
	    for ( i = 0; i < vaild_reg_depth; i = i + 1) begin            //write
            @(negedge clk);
            data = $random();
            data_buffer.push_back(data);
        @(posedge clk); // wait last data write into the register
    end
    
    begin                                                              //read
        if  (`WITH_REG_0303 == 1) begin
            @(posedge clk); //first data come to output register    
            @(posedge clk); //first data generate to output wire    
            for ( j = 0; j < vaild_reg_depth; j = j + 1) begin 
                @(negedge clk);       
                Q_buffer.push_back(qout);
            end
        end
        else begin 
            @(posedge clk); //first data generate to output wire      
            for ( j = 0; j < vaild_reg_depth; j = j + 1) begin 
                @(negedge clk);       
                Q_buffer.push_back(qout);
            end   
        end      
    end
    float_register_depth_lossy_check (clk, addr, Q_buffer, data_buffer);
    end

endtask


task automatic float_register_depth_lossless;
    ref [`DATA_WIDTH_0303 - 1:0] data;
    ref [`ADDRESS_WIDTH_0303 - 1:0] addr;
    ref clk;
    ref clken;
    ref rst;
    ref [`DATA_WIDTH_0303 - 1:0] qout;
  
    integer i , j;
    integer vaild_reg_depth;
    reg [ `DATA_WIDTH_0303 - 1 :0] data_buffer [$];  //Systemverilog feature: queue
    reg [ `DATA_WIDTH_0303 - 1 :0] Q_buffer [$];
   
    addr = `FLOAT_REG_DEPTH_0303 / 3;
    vaild_reg_depth = addr;
    $display ( "addr:%d",addr);
    $display ( "vaild_reg_depth:%d",vaild_reg_depth);
        
    begin 
	    for ( i = 0; i < vaild_reg_depth; i = i + 1) begin            //write
            @(negedge clk);
            data = $random();
            data_buffer.push_back(data);
        @(posedge clk); // wait last data write into the register
    end
    
    begin                                                              //read
        if  (`WITH_REG_0303 == 1) begin
            @(posedge clk); //first data come to output register    
            @(posedge clk); //first data generate to output wire    
            for ( j = 0; j < vaild_reg_depth; j = j + 1) begin 
                @(negedge clk);       
                Q_buffer.push_back(qout);
            end
        end
        else begin 
            @(posedge clk); //first data generate to output wire      
            for ( j = 0; j < vaild_reg_depth; j = j + 1) begin 
                @(negedge clk);       
                Q_buffer.push_back(qout);
            end   
        end      
    end
    float_register_depth_lossless_check (clk, addr, Q_buffer, data_buffer);
    end

endtask


//----task outputfile_check
task automatic fixed_shift_register_check;
    ref clk;
    ref [ `DATA_WIDTH_0303 - 1 :0] Q_buffer [$];
    ref [ `DATA_WIDTH_0303 - 1 :0] data_buffer [$];
    
    integer i;
    integer j;
    integer status = 1;
    reg [ `DATA_WIDTH_0303 - 1 :0] buffer_tmp;
    reg [ `DATA_WIDTH_0303 - 1 :0] Q_tmp;
    begin 
        @(posedge clk)  //wait for the first data after lock single active
        @(posedge clk)  //wait for the first data after lock single active
        
            for ( j = 0; j <= `FIXED_REG_DEPTH_0303  -1 ; j = j + 1) begin
                buffer_tmp = data_buffer.pop_front();
                Q_tmp = Q_buffer.pop_front();
                if ( Q_tmp != buffer_tmp) begin 
                        $display ( "fail: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
                    	$fdisplay( outlog, "fail: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
                        status = 0;
                        //$stop;
                end
                else begin
                        $display ( "match: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
                        $fdisplay( outlog, "match: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
                    Q_tmp = Q_tmp >> `DATA_WIDTH_0303;
                end
            end
        if (status == 1)
        	begin
        		$display ( "pass" );
        		$fdisplay( outlog, "pass" );
        	end
        else
        	begin
            	$display ( "fail" );
        		$fdisplay( outlog, "fail" );
        	end
        $fclose(outlog);
    end
  
endtask

task automatic float_register_depth_lossy_check;
    ref clk;
    ref [`ADDRESS_WIDTH_0303 - 1:0] addr;
    ref [ `DATA_WIDTH_0303 - 1 :0] Q_buffer [$];
    ref [ `DATA_WIDTH_0303 - 1 :0] data_buffer [$]; 
    
    integer i;
    integer j;
    integer status = 1;
    reg [ `DATA_WIDTH_0303 - 1 :0] buffer_tmp;
    reg [ `DATA_WIDTH_0303 - 1 :0] Q_tmp;
    
    integer reg_depth;
    addr = `FLOAT_REG_DEPTH_0303 / 2;  
    reg_depth = `FLOAT_REG_DEPTH_0303 - addr; 
        
    begin 
        @(posedge clk)  //wait for the first data after lock single active
        @(posedge clk)  //wait for the first data after lock single active
        
            for ( j = 0; j <= reg_depth  -1 ; j = j + 1) begin
                buffer_tmp = data_buffer.pop_front();
                Q_tmp = Q_buffer.pop_front();
                if ( Q_tmp != buffer_tmp) begin 
                        $display ( "fail: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
                    	$fdisplay( outlog, "fail: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
                        status = 0;
                        //$stop;
                end
                else begin
                        $display ( "match: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
                        $fdisplay( outlog, "match: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
                    Q_tmp = Q_tmp >> `DATA_WIDTH_0303;
                end
            end
        if (status == 1)
        	begin
        		$display ( "pass" );
        		$fdisplay( outlog, "pass" );
        	end
        else
        	begin
            	$display ( "fail" );
        		$fdisplay( outlog, "fail" );
        	end
        $fclose(outlog);
    end
  
endtask


task automatic float_register_depth_lossless_check;
    ref clk;
    ref [`ADDRESS_WIDTH_0303 - 1:0] addr;
    ref [ `DATA_WIDTH_0303 - 1 :0] Q_buffer [$];
    ref [ `DATA_WIDTH_0303 - 1 :0] data_buffer [$]; 
    
    integer i;
    integer j;
    integer status = 1;
    reg [ `DATA_WIDTH_0303 - 1 :0] buffer_tmp;
    reg [ `DATA_WIDTH_0303 - 1 :0] Q_tmp;
    
    integer reg_depth;
    addr = `FLOAT_REG_DEPTH_0303 / 3;  
    reg_depth = addr; 
        
    begin 
        @(posedge clk)  //wait for the first data after lock single active
        @(posedge clk)  //wait for the first data after lock single active
        
            for ( j = 0; j <= reg_depth  -1 ; j = j + 1) begin
                buffer_tmp = data_buffer.pop_front();
                Q_tmp = Q_buffer.pop_front();
                if ( Q_tmp != buffer_tmp) begin 
                        $display ( "fail: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
                    	$fdisplay( outlog, "fail: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
                        status = 0;
                        //$stop;
                end
                else begin
                        $display ( "match: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
                        $fdisplay( outlog, "match: Q = %d, data_buffer = %d", Q_tmp, buffer_tmp);
                    Q_tmp = Q_tmp >> `DATA_WIDTH_0303;
                end
            end
        if (status == 1)
        	begin
        		$display ( "pass" );
        		$fdisplay( outlog, "pass" );
        	end
        else
        	begin
            	$display ( "fail" );
        		$fdisplay( outlog, "fail" );
        	end
        $fclose(outlog);
    end
  
endtask

endmodule