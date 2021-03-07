`timescale 1ns/10ps


//*************************************
//***     UMC 40 nm IO Verilog     ***
//*************************************

`timescale 1 ns/1 ps

`celldefine

module SDDIOBREAK_sbt_a (VDDIO);
   inout VDDIO;
   supply1 VDDIO;

   specify
   endspecify

endmodule

`endcelldefine

//*************************************
//***     UMC 40 nm IO Verilog     ***
//*************************************

`timescale 1 ns/1 ps

`celldefine

module SCORNER_sbt_a (VDDIO);
   inout VDDIO;
   supply1 VDDIO;

   specify
   endspecify

endmodule

`endcelldefine

//*************************************
//***     UMC 40 nm IO Verilog     ***
//*************************************
/*
`timescale 1 ns/1 ps

`celldefine

module SDDIOBREAK_sbt_a (VDDIO);
   inout VDDIO;
   supply1 VDDIO;

   specify
   endspecify

endmodule

`endcelldefine
*/
//*************************************
//***     UMC 40 nm IO Verilog     ***
//*************************************

`timescale 1 ns/1 ps

`celldefine

module SVDD_sbt_a ();

   specify
   endspecify

endmodule

`endcelldefine

//*************************************
//***     UMC 40 nm IO Verilog     ***
//*************************************

`timescale 1 ns/1 ps

`celldefine

module SVDDIO_sbt_a (VDDIO);
   inout VDDIO;
   supply1 VDDIO;

   specify
   endspecify

endmodule

`endcelldefine

//*************************************
//***     UMC 40 nm IO Verilog     ***
//*************************************

`timescale 1 ns/1 ps

`celldefine

module SVSS_sbt_a (VDDIO);
   inout VDDIO;
   supply1 VDDIO;

   specify
   endspecify

endmodule

`endcelldefine

//*************************************
//***     UMC 40 nm IO Verilog     ***
//*************************************

`timescale 1 ns/1 ps

`celldefine

module SFILLER20 (VDDIO);
   inout VDDIO;
   supply1 VDDIO;

   specify
   endspecify

endmodule

`endcelldefine



`celldefine
module SUMB_sbt_8mA (DO, OEN, REN, IE, nor_in, PGATE, PAD, DI, VDDIO);
  input VDDIO;
  input DO, OEN, REN, IE, nor_in;
  inout PAD;
  output DI;
  output PGATE;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  bufif0 (PAD, DO, OEN);
  pmos   (C_buf, PAD, 1'b0);

  buf    (PGATE, C_buf);
  and     (C_buf1, C_buf, IE);
  or     (DI, C_buf1, nor_in);
  
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
    (DO => PAD)=(0, 0);
    (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => DI)=(0, 0);

    (PAD => PGATE)=(0, 0);
    (nor_in => DI)=(0, 0);
    (IE => DI)=(0, 0, 0, 0, 0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module SUMB_bscan_8mA (DO, OEN, REN, IE, BSEN, nor_in, PGATE, PAD, DI, VDDIO);
  input VDDIO;
  input DO, OEN, REN, IE, BSEN, nor_in;
  inout PAD;
  output DI;
  output PGATE;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  bufif0 (PAD, DO, OEN);
  pmos   (C_buf, PAD, 1'b0);

  buf    (PGATE, C_buf);
  or     (IE_BSEN, IE, BSEN);
  and     (C_buf1, C_buf, IE_BSEN);
  or     (DI, C_buf1, nor_in);
  
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
    (DO => PAD)=(0, 0);
    (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => DI)=(0, 0);

    (PAD => PGATE)=(0, 0);
    (nor_in => DI)=(0, 0);
    (IE => DI)=(0, 0, 0, 0, 0, 0);
  endspecify

endmodule
`endcelldefine


`celldefine
module SUMB_sbt_8mA_PD (DO, OEN, REN, IE, nor_in, PGATE, PAD, DI, VDDIO);
  input VDDIO;
  input DO, OEN, REN, IE, nor_in;
  inout PAD;
  output DI;
  output PGATE;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  bufif0 (PAD, DO, OEN);
  pmos   (C_buf, PAD, 1'b0);

  buf    (PGATE, C_buf);
  and     (C_buf1, C_buf, IE);
  or     (DI, C_buf1, nor_in);
  
  always @(PAD or RE) begin

    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);

    if (PAD === 1'bz && RE) begin
       if (lastPAD === 1'b0) pull=0;
       else pull <= #PullTime 0;
    end
    else pull=1;

    lastPAD=PAD;

  end

  specify
    (DO => PAD)=(0, 0);
    (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => DI)=(0, 0);

    (PAD => PGATE)=(0, 0);
    (nor_in => DI)=(0, 0);
    (IE => DI)=(0, 0, 0, 0, 0, 0);
  endspecify

endmodule
`endcelldefine


`celldefine
module SUMB_sbt_HX (DO, OEN, REN, IE, nor_in, PGATE, PAD, DI, VDDIO);
  input VDDIO;
  input DO, OEN, REN, IE, nor_in;
  inout PAD;
  output DI;
  output PGATE;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  bufif0 (PAD, DO, OEN);
  pmos   (C_buf, PAD, 1'b0);

  buf    (PGATE, C_buf);
  and     (C_buf1, C_buf, IE);
  or     (DI, C_buf1, nor_in);
  
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
    (DO => PAD)=(0, 0);
    (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => DI)=(0, 0);

    (PAD => PGATE)=(0, 0);
    (nor_in => DI)=(0, 0);
    (IE => DI)=(0, 0, 0, 0, 0, 0);
  endspecify

endmodule
`endcelldefine

`celldefine
module SUMB_bscan_HX (DO, OEN, REN, IE, BSEN, nor_in, PGATE, PAD, DI, VDDIO);
  input VDDIO;
  input DO, OEN, REN, IE, BSEN, nor_in;
  inout PAD;
  output DI;
  output PGATE;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  bufif0 (PAD, DO, OEN);
  pmos   (C_buf, PAD, 1'b0);

  buf    (PGATE, C_buf);
  or     (IE_BSEN, IE, BSEN);
  and     (C_buf1, C_buf, IE_BSEN);
  or     (DI, C_buf1, nor_in);
  
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
    (DO => PAD)=(0, 0);
    (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => DI)=(0, 0);

    (PAD => PGATE)=(0, 0);
    (nor_in => DI)=(0, 0);
    (IE => DI)=(0, 0, 0, 0, 0, 0);
  endspecify

endmodule
`endcelldefine

`endcelldefine

`celldefine
module SUMB_bscan_HX8mA (DO, OEN, REN, IE, BSEN, nor_in, PGATE, PAD, DI, VDDIO);
  input VDDIO;
  input DO, OEN, REN, IE, BSEN, nor_in;
  inout PAD;
  output DI;
  output PGATE;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b1, pull);
  not    (RE, REN);
  bufif0 (PAD, DO, OEN);
  pmos   (C_buf, PAD, 1'b0);

  buf    (PGATE, C_buf);
  or     (IE_BSEN, IE, BSEN);
  and     (C_buf1, C_buf, IE_BSEN);
  or     (DI, C_buf1, nor_in);
  
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
    (DO => PAD)=(0, 0);
    (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => DI)=(0, 0);

    (PAD => PGATE)=(0, 0);
    (nor_in => DI)=(0, 0);
    (IE => DI)=(0, 0, 0, 0, 0, 0);
  endspecify

endmodule
`endcelldefine

/*
`celldefine
module io_r2rinbuf_comptbl ( out, vddio, cbit[2], cbit[3], cbit[4],
     in_neg_25, in_pos_25, tiegnd );
output  out;

inout  vddio;

input  in_neg_25, in_pos_25, tiegnd;

input [4:2]  cbit;

wire cbitb4, lvdsen_n, lvdsen;
   
  not (cbitb4, cbit[4]);
  or  (lvdsen_n, cbit[2], cbit[3], cbitb4);
  not (lvdsen, lvdsen_n);
  and (out,in_pos_25, lvdsen);

  specify
    (in_pos_25 => out)=(0, 0);
    (cbit[2] => out)=(0, 0, 0, 0, 0, 0);
    (cbit[3] => out)=(0, 0, 0, 0, 0, 0);
    (cbit[4] => out)=(0, 0, 0, 0, 0, 0);
  endspecify
  
endmodule
`endcelldefine
*/

`celldefine
module LVDS_INBUFFER (in_padp, in_padn,lvdsen,nor_in, vddio);
  input in_padp, in_padn, lvdsen;
  input vddio;
  output nor_in;

  and (nor_in,in_padp, lvdsen);

  specify
    (in_padp => nor_in)=(0, 0);
    (lvdsen => nor_in)=(0, 0, 0, 0, 0, 0);
  endspecify
endmodule
`endcelldefine
