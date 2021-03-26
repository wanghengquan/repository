`timescale 1 ns / 1 ps

`celldefine

module osc_clkk (ENA_CLKK, CLKK);

  input  ENA_CLKK;
  output CLKK;

  reg OSCb;
  realtime half_clk;
  reg ENA_CLKK_n;

  initial
  begin
     OSCb = 1'b0;
     ENA_CLKK_n = 1'b1;
     half_clk = 20;

     forever begin
        #(half_clk) OSCb = ~OSCb;
     end
  end

  always @ (negedge OSCb)
  begin
     ENA_CLKK_n <= ENA_CLKK;
  end

  assign CLKK = (OSCb & ENA_CLKK_n);
  
endmodule

`endcelldefine

