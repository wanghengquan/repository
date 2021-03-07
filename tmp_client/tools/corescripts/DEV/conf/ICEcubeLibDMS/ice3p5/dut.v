tri0  cdone; 
//tri0 creset_b, trstb;
reg creset_b;
   
supply0 vpp;
supply1 vdda_bot, vdda_top, vddio_bottombank, vddio_topbank, vddio_spi;

tri [33:0]  uio_tbank;
tri [25:0]  uio_bbank;

`include "via.v"
`include "io.v"

initial
begin
  creset_b = 1;
  #200 
  creset_b = 0;
end

chip_ice4phx0nvcm chip( .cdone(cdone), .uio_bbank(uio_bbank), .uio_tbank(uio_tbank), .vdda_bot(vdda_bot), .vdda_top(vdda_top), .vddio_bottombank(vddio_bottombank), .vddio_spi(vddio_spi), .vddio_topbank(vddio_topbank), .creset_b(creset_b) );

