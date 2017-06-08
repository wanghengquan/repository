///////////////////////////////////////////////////////////////////////
//
// Revision History:
// ??/??/????      :  Initial  
// 10/17/2014      : FP -- CR 2735 fix -- reverted creset_b 
//
// End Revision History:
///////////////////////////////////////////////////////////////////////
//
//
tri0  cdone;
tri1  [0:0] irled; 
//tri0 creset_b, trstb;
reg creset_b;
   
supply0 vpp, drivergnd, vpp2v5_bot, vpp2v5_top, vppfast, por, i200uref;
supply1 vdda_bot, vdda_top, vddio_bottombank, vddio_topbank, vddio_spi;

tri [16:0]  uio_tbank;
tri [35:0]  uio_bbank;
tri [2:0]   rgb;

`include "io.v"
`include "via.v"

initial
begin
//  creset_b = 1;
  creset_b = 0;

  #10 
//  creset_b = 0;
  creset_b = 1;
end

chip_thunder_121213 chip( .cdone(cdone), .drivergnd(drivergnd), .irled(irled[0]), .por(por), .rgb0(rgb[0]), .rgb1(rgb[1]), .rgb2(rgb[2]), .uio_bbank(uio_bbank), .uio_tbank({dummy, uio_tbank}), .vddio_bottombank(vddio_bottombank), .vddio_spi(vddio_spi), .vddio_topbank(vddio_topbank), .vppfast(vppfast), .creset_b(creset_b) );

