`include "base_add_params.v"
module comp_add (
	clk,
	rst,	
	DataIn_A,	
	DataIn_B,	
	con1,
	con2,
	DataOut);

input		clk;
input		rst;
input   [`data_wide/2-1:0]  con1;
input   [`data_wide/2-1:0] 	con2;
input	[`data_wide-1:0]	DataIn_A;
input	[`data_wide-1:0]	DataIn_B;
//input           add_n_sub;
output	[2*`data_wide-1:0]	DataOut;

reg 	[2*`data_wide-1:0]	DataOut;
reg     [`data_wide-1:0]	DataIn_A_int, DataIn_B_int;

    always @ (posedge clk or posedge rst)                                
      if (rst) 
      		DataOut <= 2*`data_wide-1'h0;                                        
      else begin        
            DataIn_A_int <= DataIn_A;
            DataIn_B_int <= DataIn_B;                                         
         if (con1 < con2) 
         	  DataOut <= DataIn_A_int * DataIn_B_int + DataIn_A_int;  
         else DataOut <= DataIn_A_int/5 - DataIn_B_int;                 
      end                                                              

       
endmodule