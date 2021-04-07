tri  cdone, vpp;

reg  creset_b, trstb, vdda;

tri [23:0]  uio_lbank;
tri [24:0]  uio_rbank;
tri [23:0]  uio_bbank;
tri [23:0]  uio_tbank;

`include "io.v"

chip_ice1f chip ( .cdone(cdone), .uio_bbank(uio_bbank), .uio_lbank(uio_lbank), .uio_rbank(uio_rbank), .uio_tbank(uio_tbank), .vpp(vpp), .creset_b(creset_b), .trstb(trstb), .vdda(vdda) );

initial begin
vdda = 1'b1;
end
