module top (addr, we, clk, data_in, data_out);

   parameter data_width  = 8;
   parameter addr_width  = 8;
   input[addr_width - 1:0] addr; 
   input we; 
   input clk; 
   input[data_width - 1:0] data_in; 
   output[data_width - 1:0] data_out; 
   wire[data_width - 1:0] data_out;

   reg[data_width - 1:0] mem[2 ** addr_width-1:0]; 

   always @(posedge clk)
   begin
         if (we == 1'b1)
         begin
            mem[(addr)] <= data_in ; 
         end 
   end 
   assign data_out = mem[(addr)] ;
endmodule
