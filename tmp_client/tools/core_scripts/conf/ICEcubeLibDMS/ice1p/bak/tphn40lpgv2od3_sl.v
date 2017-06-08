/////////////////////////////////////////////////////////////////////////////////////////////
/// TSMC Library/IP Product
/// Filename: tphn40lpgv2od3_sl.v
/// Technology: cln40lp
/// Product Type: Standard I/O
/// Product Name: tphn40lpgv2od3_sl
/// Version: 120a
////////////////////////////////////////////////////////////////////////////////////////////
////
///  STATEMENT OF USE
///
///  This information contains confidential and proprietary information of TSMC.
///  No part of this information may be reproduced, transmitted, transcribed,
///  stored in a retrieval system, or translated into any human or computer
///  language, in any form or by any means, electronic, mechanical, magnetic,
///  optical, chemical, manual, or otherwise, without the prior written permission
///  of TSMC.  This information was prepared for informational purpose and is for
///  use by TSMC's customers only.  TSMC reserves the right to make changes in the
///  information at any time and without notice.
///
////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/10ps

`celldefine
module PCLAMP1ANA_G (VDDESD,VSSESD);
    inout   VDDESD,VSSESD;
    tran (VDDESD,VDDESD);
    tran (VSSESD,VSSESD);
endmodule
`endcelldefine

`celldefine
module PCLAMP2ANA_G (VDDESD,VSSESD);
    inout   VDDESD,VSSESD;
    tran (VDDESD,VDDESD);
    tran (VSSESD,VSSESD);
endmodule
`endcelldefine

`celldefine
module PCLAMPA_G (VDDESD,VSSESD);
    inout   VDDESD,VSSESD;
    tran (VDDESD,VDDESD);
    tran (VSSESD,VSSESD);
endmodule
`endcelldefine

`celldefine
module PCLAMPAC_G (VDDESD,VSSESD);
    inout   VDDESD,VSSESD;
    tran (VDDESD,VDDESD);
    tran (VSSESD,VSSESD);
endmodule
`endcelldefine

`celldefine
module PDB3A_G (AIO);
   inout AIO;
   tran (AIO,AIO);
endmodule
`endcelldefine

`celldefine
module PDB3AC_G (AIO);
   inout AIO;
   tran (AIO,AIO);
endmodule
`endcelldefine

`celldefine
module PDDW04DGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDDW04SDGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDDW08DGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDDW08SDGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDDW12DGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDDW12SDGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDDW16DGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDDW16SDGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDUW04DGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDUW04SDGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDUW08DGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDUW08SDGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDUW12DGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDUW12SDGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDUW16DGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDUW16SDGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDXOE1DG_G (XC, XOUT, XIN, E);
    input XIN, E;
    output XC, XOUT;
    not                  (XC, XOUT);
    nand                 (XOUT, E, XIN);
    specify
       (E => XC)=(0, 0);
       (E => XOUT)=(0, 0);
       (XIN => XC)=(0, 0);
       (XIN => XOUT)=(0, 0);
    endspecify
endmodule
`endcelldefine

`celldefine
module PDXOE2DG_G (XC, XOUT, XIN, E);
    input XIN, E;
    output XC, XOUT;
    not                  (XC, XOUT);
    nand                 (XOUT, E, XIN);
    specify
       (E => XC)=(0, 0);
       (E => XOUT)=(0, 0);
       (XIN => XC)=(0, 0);
       (XIN => XOUT)=(0, 0);
    endspecify
endmodule
`endcelldefine

`celldefine
module PDXOE3DG_G (XC, XOUT, XIN, E);
    input XIN, E;
    output XC, XOUT;
    not                  (XC, XOUT);
    nand                 (XOUT, E, XIN);
    specify
       (E => XC)=(0, 0);
       (E => XOUT)=(0, 0);
       (XIN => XC)=(0, 0);
       (XIN => XOUT)=(0, 0);
    endspecify
endmodule
`endcelldefine

`celldefine
module PENDCAP_G ();
endmodule
`endcelldefine

`celldefine
module PENDCAPA_G ();
endmodule
`endcelldefine

`celldefine
module PRCUT_G ();
endmodule
`endcelldefine

`celldefine
module PRCUTA_G ();
endmodule
`endcelldefine

`celldefine
module PRDW08DGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PRDW08SDGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PRDW12DGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PRDW12SDGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PRDW16DGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PRDW16SDGZ_G (I, OEN, REN, PAD, C);
   input I, OEN, REN;
   inout PAD;
   output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;
    lastPAD=PAD;
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PRUW08DGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PRUW08SDGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PRUW12DGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PRUW12SDGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PRUW16DGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PRUW16SDGZ_G (I, OEN, REN, PAD, C);
  input I, OEN, REN;
  inout PAD;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b1) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0;

    lastPAD=PAD;

  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PVBUS_G (VBUS);
    inout   VBUS;
    tran (VBUS,VBUS);
endmodule
`endcelldefine

`celldefine
module PVDD1ANA_G (AVDD);
    inout   AVDD;
    tran (AVDD,AVDD);
endmodule
`endcelldefine

`celldefine
module PVDD1DGZ_G (VDD);
    inout   VDD;
    tran (VDD,VDD);
endmodule
`endcelldefine

`celldefine
module PVDD2ANA_G (AVDD);
    inout   AVDD;
    tran (AVDD,AVDD);
endmodule
`endcelldefine

`celldefine
module PVDD2DGZ_G (VDDPST);
    inout   VDDPST;
    tran (VDDPST,VDDPST);
endmodule
`endcelldefine

`celldefine
module PVDD2POC_G (VDDPST);
    inout   VDDPST;
    tran (VDDPST,VDDPST);
endmodule
`endcelldefine

`celldefine
module PVDD3A_G (AVDD,TAVDD);
    inout   AVDD,TAVDD;
    tran (AVDD,TAVDD);
endmodule
`endcelldefine

`celldefine
module PVDD3AC_G (AVDD,TACVDD);
    inout   AVDD,TACVDD;
    tran (AVDD,TACVDD);
endmodule
`endcelldefine

`celldefine
module PVSS1ANA_G (AVSS);
    inout   AVSS;
    tran (AVSS,AVSS);
endmodule

`endcelldefine

`celldefine
module PVSS1DGZ_G (VSS);
    inout   VSS;
    tran (VSS,VSS);
endmodule
`endcelldefine

`celldefine
module PVSS2A_G (VSS);
    inout   VSS;
    tran (VSS,VSS);
endmodule
`endcelldefine

`celldefine
module PVSS2AC_G (VSS);
    inout   VSS;
    tran (VSS,VSS);
endmodule
`endcelldefine

`celldefine
module PVSS2ANA_G (AVSS);
    inout   AVSS;
    tran (AVSS,AVSS);
endmodule

`endcelldefine

`celldefine
module PVSS2DGZ_G (VSSPST);
    inout   VSSPST;
    tran (VSSPST,VSSPST);
endmodule
`endcelldefine

`celldefine
module PVSS3A_G (AVSS,TAVSS);
    inout   AVSS,TAVSS;
    tran (AVSS,TAVSS);
endmodule
`endcelldefine

`celldefine
module PVSS3AC_G (AVSS,TACVSS);
    inout   AVSS,TACVSS;
    tran (AVSS,TACVSS);
endmodule
`endcelldefine

`celldefine
module PVSS3DGZ_G (VSS);
    inout   VSS;
    tran (VSS,VSS);
endmodule
`endcelldefine

