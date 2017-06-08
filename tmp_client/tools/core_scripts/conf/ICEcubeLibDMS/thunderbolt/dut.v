wire  cdone;
// wire  irled; 
wire barcodepad;
//tri0 creset_b, trstb;
reg creset_b;
   
supply0 vpp, drivergnd, vpp2v5_bot, vpp2v5_top, vppfast, por, i200uref;
supply1 vdda_bot, vdda_top, vddio_bottombank, vddio_topbank, vddio_spi;

tri [13:0]  uio_bbank;
tri [12:0]  uio_tbank;
tri [3:0]   uio_spi;
tri [2:0]   rgb;

`include "io.v"

initial
begin
  creset_b = 1;

  #200 
  creset_b = 0;
end

//chip_thunder_121213 chip( .cdone(cdone), .drivergnd(drivergnd), .irled(irled), .por(por), .rgb0(rgb[0]), .rgb1(rgb[1]), .rgb2(rgb[2]), .uio_bbank(uio_bbank), .uio_tbank(uio_tbank), .vdda_top(vdda_top), .vddio_bottombank(vddio_bottombank), .vddio_spi(vddio_spi), .vddio_topbank(vddio_topbank), .vppfast(vppfast), .creset_b(creset_b) );

chip_1_45x1_45 chip( .barcodepad(uio_tbank[12]), .cdone(cdone), .drivergnd(drivergnd), .irled(uio_tbank[11]), .rgb0(rgb[0]), .rgb1(rgb[1]), .rgb2(rgb[2]), .uio_bbank(uio_bbank), .uio_spi(uio_spi), .uio_tbank(uio_tbank), .vdda_bot(vdda_bot), .vddio_bottombank(vddio_bottombank), .vddio_spi(vddio_spi), .vddio_topbank(vddio_topbank), .vppfast(vppfast), .creset_b(creset_b) );
//chip_tm1k1_4x1_4 chip( .barcodepad(barcodepad), .cdone(cdone), .drivergnd(drivergnd), .irled(irled), .rgb0(rgb[0]), .rgb1(rgb[1]), .rgb2(rgb[2]), .uio_bbank(uio_bbank), .uio_spi(uio_spi), .uio_tbank(uio_tbank), .vdda_bot(vdda_bot), .vddio_bottombank(vddio_bottombank), .vddio_spi(vddio_spi), .vddio_topbank(vddio_topbank), .vppfast(vppfast), .creset_b(creset_b) );
