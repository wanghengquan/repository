`timescale 1ns/100ps
module testbench ();

   reg [7:0] d;
   reg clk;
   reg reset;
   reg sysclk;
   reg start;
   wire[7:0] sum;
   wire ready;
   GSR GSR_INST (.GSR_N(1'b1));

   vlog_statmchs_sum3 uut (
      .reset(reset),
      .d(d),
      .start(start),
      .clk(clk),
      .ready(ready),
      .sum(sum)
   );

   always
   begin: clk_gen
      clk <= 1'b1;
      #30;
      clk <= 1'b0;
      #30;
      $display("sim_pass");
   end
   always
   begin: sysclk_gen
      sysclk <= 1'b1;
      #137;
      sysclk <= 1'b0;
      #137;
   end
   always
   begin: reset_gen
      reset <= 1'b1;
      #139;
      reset <= 1'b0;
      #1237;
   end
   always
   begin: start_gen
      start <= 1'b0;
      #222;
      start <= 1'b1;
      #139;
      start <= 1'b0;
      #1237;
   end
   always @(posedge sysclk)
   begin : stim_in
        #56;
        d <= $random;
        $display("sim_pass");
   end

endmodule
