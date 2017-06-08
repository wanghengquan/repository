`timescale 1ns/10ps

`celldefine
module PDDW08SDGZ_G (I, OEN, REN, PAD, C, POC, VDDIO);
   input POC, VDDIO;
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
module PVDD1DGZ_G (VDD);
    inout   VDD;
    tran (VDD,VDD);
endmodule
`endcelldefine

`celldefine
module PVDD2DGZ_G (VDDPST);
    inout   VDDPST;
    tran (VDDPST,VDDPST);
endmodule
`endcelldefine

`celldefine
module PVDD2POC_G (POC, VDDPST);
    inout   POC;
    inout   VDDPST;
    tran (VDDPST,VDDPST);
endmodule
`endcelldefine

`celldefine
module PVSS3DGZ_G (VDDPST, VSS);
    inout   VDDPST;
    inout   VSS;
    tran (VSS,VSS);
endmodule
`endcelldefine

`celldefine
module PDUW08SDGZ_G_NOR (I, OEN, REN, IE, indiff, PAD4LVDS, PAD, C, POC, VDDIO);
  input POC, VDDIO;
  input I, OEN, REN, IE, indiff;
  inout PAD;
  output C;
  output PAD4LVDS;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  buf    (PAD4LVDS, C_buf);
  and     (C_buf1, C_buf, IE);
  or     (C, C_buf1, indiff);
  
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

    (PAD => PAD4LVDS)=(0, 0);
    (indiff => C)=(0, 0);
    (IE => C)=(0, 0, 0, 0, 0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module PDUW08SDGZ_G_NOR_525M (I, OEN, REN, IE, indiff, PAD4LVDS, PAD, C, POC, VDDIO);
  input POC, VDDIO;
  input I, OEN, REN, IE, indiff;
  inout PAD;
  output C;
  output PAD4LVDS;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  buf    (PAD4LVDS, C_buf);
  and     (C_buf1, C_buf, IE);
  or     (C, C_buf1, indiff);
  
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

    (PAD => PAD4LVDS)=(0, 0);
    (indiff => C)=(0, 0);
    (IE => C)=(0, 0, 0, 0, 0, 0);
  endspecify

endmodule
`endcelldefine


`celldefine
module LVDS_INBUFFER (in_padp, in_padn,lvdsen,indiff, vddio);
  input in_padp, in_padn, lvdsen;
  input vddio;
  output indiff;

  and (indiff,in_padp, lvdsen);

  specify
    (in_padp => indiff)=(0, 0);
    (lvdsen => indiff)=(0, 0, 0, 0, 0, 0);
  endspecify
endmodule
`endcelldefine

`celldefine
module LVDS_INBUFFER_ICE1F (in_padp, in_padn,indiff, vddio, cbit);
  input in_padp, in_padn;
  input vddio;
  input [4:2] cbit;
  output indiff;
  wire cbitb4, lvdsen_n, lvdsen;
   
   not (cbitb4, cbit[4]);
  
   or  (lvdsen_n, cbit[2], cbit[3], cbitb4);
   not (lvdsen, lvdsen_n);
  and (indiff,in_padp, lvdsen);

  specify
    (in_padp => indiff)=(0, 0);
    (cbit[2] => indiff)=(0, 0, 0, 0, 0, 0);
    (cbit[3] => indiff)=(0, 0, 0, 0, 0, 0);
    (cbit[4] => indiff)=(0, 0, 0, 0, 0, 0);
  endspecify
endmodule
`endcelldefine
