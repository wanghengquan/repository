// ice384 chip instance // 

tri  cdone, vpp;
reg   creset_b, trstb;
tri [15:0]  pad_l;
tri [11:0]  pad_b;
tri [15:0]  pad_r;
tri [11:0]  pad_t;

`include "io.v"

chip_ice384 chip ( .cdone(cdone), .pad_b(pad_b), .pad_l(pad_l), .pad_r(pad_r),
        .pad_t(pad_t), .vpp(vpp), .creset_b(creset_b), .trstb(trstb) );

