`timescale 1 ns / 1 ps

`celldefine

module osc_clkm (ENA_CLKM, CLKM);

  input  ENA_CLKM;
  output CLKM;

  reg OSCb;
  realtime half_clk;
  reg ENA_CLKM_n;

  initial
  begin
     OSCb = 1'b0;
     ENA_CLKM_n = 1'b1;
     half_clk = 10;

     forever begin
        #(half_clk) OSCb = ~OSCb;
     end
  end

  always @ (negedge OSCb)
  begin
     ENA_CLKM_n <= ENA_CLKM;
  end

  assign CLKM = (OSCb & ENA_CLKM_n);
  
endmodule

`endcelldefine
