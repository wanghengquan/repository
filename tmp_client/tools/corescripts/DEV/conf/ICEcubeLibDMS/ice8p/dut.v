tri  cdone, vpp;

reg  creset_b, trstb, vdda_bot, vdda_top;

tri [59:0]  uio_tbank;
tri [51:0]  uio_lbank;
tri [56:0]  uio_bbank;
tri [58:0]  uio_rbank;

`include "io.v"


chip_ice8p chip ( .cdone(cdone), .uio_bbank(uio_bbank), .uio_lbank(uio_lbank), .uio_rbank(uio_rbank), .uio_tbank(uio_tbank), .vpp(vpp), .creset_b(creset_b), .trstb(trstb), .vdda_bot(vdda_bot), .vdda_top(vdda_top) );

initial begin
vdda_bot = 1'b1;
vdda_top = 1'b1;
end
