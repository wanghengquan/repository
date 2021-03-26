`timescale 1ns/10ps

`celldefine
module LVDS_INBUFFER_ice1f (indiff, in_padn, in_padp, vddio, cbit[2], cbit[3], cbit[4]);
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
