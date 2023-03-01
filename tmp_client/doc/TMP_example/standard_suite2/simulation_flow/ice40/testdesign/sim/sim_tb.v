`timescale 1ns/100ps
module tb ();

   reg[7:0] addr; 
   reg we; 
   reg clk; 
   reg[7:0] data_in; 
   wire[7:0] data_out; 
   parameter clk_period = 20; 
   parameter data_width  = 8;
   parameter addr_width  = 8;

   top uut (
      .addr(addr), 
      .we(we), 
      .clk(clk), 
      .data_in(data_in), 
      .data_out(data_out)
   ); 

   always 
   begin : clock
      clk <= 1'b0 ; 
      #((clk_period / 2)); 
      clk <= 1'b1 ; 
      #((clk_period / 2)); 
   end 
   
   /* add self check here */
    integer outlog;
    initial outlog=$fopen("./outlog.log");
	
   always @(negedge clk)
   begin
       data_in = $random ;  
   end 
   
   reg[7:0] addr_cnt=0;
   always @(negedge clk)
   begin
      addr_cnt <= addr_cnt + 1;
	  if (addr_cnt == 11111111)
	  begin
	   addr_cnt <= 0;
	  end
	  addr <= addr_cnt;
   end
   	
   wire[7:0] dataout_sim;
   reg[data_width - 1:0] mem[2 ** addr_width-1:0]; 
   always @(posedge clk)
   begin
         if (we == 1'b1)
         begin
            mem[(addr)] <= data_in ; 
         end 
   end
   
   assign dataout_sim = mem[(addr)] ;
  
   
    initial
	#(clk_period*270)
 	forever
 		@(negedge clk)
 		begin
			if( dataout_sim === data_out ) begin
				$fdisplay (outlog, "PASS");
				$display ("PASS");
			end
 			else begin
 				$fdisplay (outlog, "FAIL");	
				$display ("FAIL, time:%d", $time);
			end
 		end
	
    /*						*/
	
	initial
	begin
	we <= 1'b0 ; 
    #(clk_period * 3); 
    we <= 1'b1 ;
	#(clk_period * 512);	
	end

   
endmodule
