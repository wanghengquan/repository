////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// TSMC Library/IP Product
/// Filename: tpdn65lpgv2_memio_mddr.v
/// Technology: CLN65LP
/// Product Type: Specialty I/O
/// Product Name: tpdn65lpgv2_memio_mddr
/// Version: 130a
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// type: PMEMIODIF
`celldefine
module PMEMIODIF (I, OEN, PADP, ,PADN, C, PWD,DS,S0,S1,A2,A6);
    input I, OEN,PWD,DS,S0,S1,A2,A6;
    inout PADP, PADN;
    output C;

    not         (I_B,I);
    bufif0	(PADN, I_B, OEN);
    not         (PWDB, PWD);
    bufif0      (PADP, I, OEN);
    and         (C, PADP, PWDB);
    buf (A2N,A2);
    buf (A6N,A6);
    buf (S0N,S0);
    buf (S1N,S1);
    buf (DSN,DS);

    always @(PADP or PADN) begin
     if (PADP === 1'bx && !$test$plusargs("bus_conflict_off") && $countdrivers(PADP))
     $display("ERROR : %t +++BUS CONFLICT++ : %m", $realtime);
     if ((PADN === 1'bx) && (!$test$plusargs("bus_conflict_off")) && ($countdrivers(PADN)))
     $display("ERROR : %t +++BUS CONFLICT++ : %m", $realtime);
    end

    specify
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (I => PADP)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (I => PADP)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (I => PADP)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (I => PADP)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (OEN => PADP)=(0, 0, 0, 0, 0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (OEN => PADP)=(0, 0, 0, 0, 0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (OEN => PADP)=(0, 0, 0, 0, 0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (OEN => PADP)=(0, 0, 0, 0, 0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (PADP => C)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (PADP => C)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (PADP => C)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (PADP => C)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (PWD => C)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (PWD => C)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (PWD => C)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (PWD => C)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (I => PADN)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (I => PADN)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (I => PADN)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (I => PADN)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (OEN => PADN)=(0, 0, 0, 0, 0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (OEN => PADN)=(0, 0, 0, 0, 0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (OEN => PADN)=(0, 0, 0, 0, 0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (OEN => PADN)=(0, 0, 0, 0, 0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (PADN => C)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (PADN => C)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (PADN => C)=(0, 0);
       if (DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (PADN => C)=(0, 0);
    endspecify
endmodule
`endcelldefine


// type: PMEMIO
`celldefine
module PMEMIOPL (I, OEN, PAD, C, PWD,S0,S1,LVCMOS,DS,A2,A6);
    input I, OEN,PWD,S0,S1,LVCMOS,DS,A2,A6;
    inout PAD;
    output C;

    bufif0	(PAD, I, OEN);
    not         (PWDB, PWD);
    and         (C, PAD, PWDB);
    buf (A2N,A2);
    buf (A6N,A6);
    buf (S0N,S0);
    buf (S1N,S1);
    buf (LVCMOSN,LVCMOS);
    buf (DSN,DS);
 
    always @(PAD)
       begin
         if (!$test$plusargs("bus_conflict_off"))
            if ($countdrivers(PAD) && (PAD === 1'bx))
                $display("%t ++BUS CONFLICT++ : %m", $realtime);
       end
    specify
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (I => PAD)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (I => PAD)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (I => PAD)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (I => PAD)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (OEN => PAD)=(0, 0, 0, 0, 0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (OEN => PAD)=(0, 0, 0, 0, 0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (OEN => PAD)=(0, 0, 0, 0, 0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (OEN => PAD)=(0, 0, 0, 0, 0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (PAD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (PAD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (PAD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (PAD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (PWD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (PWD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (PWD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (PWD => C)=(0, 0);
    endspecify
endmodule
`endcelldefine


// type: PRCUTSSTLL
`celldefine
//module PRCUTSSTLSTDL ();
//endmodule
`endcelldefine


// type: PRCUTSSTLR
`celldefine
//module PRCUTSSTLSTDR ();
//endmodule
`endcelldefine


// type: PNOPIN
`celldefine
module PVD25POCSSTL ();
endmodule
`endcelldefine


// type: PNOPIN
`celldefine
module PVD25SSTL ();
endmodule
`endcelldefine


// type: PNOPIN
`celldefine
module PVDDPSSTL ();
endmodule
`endcelldefine


// type: PVDDSSTL
`celldefine
module PVDDSSTL (VDDC);
   inout VDDC;
   supply1 VDDC;
endmodule
`endcelldefine


// type: PVDDSSTLD
`celldefine
module PVDDSSTLD (VDDD,VDDSSTLD);
    inout   VDDD,VDDSSTLD;
    supply1 VDDD,VDDSSTLD;
endmodule
`endcelldefine


// type: PVDDSSTLE
`celldefine
module PVDDSSTLE ();
endmodule
`endcelldefine


// type: PVREFSSTL
`celldefine
module PVREFSSTL ();

endmodule
`endcelldefine


// type: PNOPIN
`celldefine
module PVSSPSSTL ();
endmodule
`endcelldefine


// type: PNOPIN
`celldefine
module PVSSRSSTL ();
endmodule
`endcelldefine


// type: PVSSSSTL
`celldefine
module PVSSSSTL (VSSC);
   inout VSSC;
   supply0 VSSC;
endmodule
`endcelldefine


// type: PVSSSSTLD
`celldefine
module PVSSSSTLD (VSSD);
    inout   VSSD;
    supply0 VSSD;
endmodule
`endcelldefine

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// TSMC Library/IP Product
/// Filename: tpdn65lpgv2_memio_mddr.v
/// Technology: CLN65LP
/// Product Type: Specialty I/O
/// Product Name: tpdn65lpgv2_memio_mddr
/// Version: 130a
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/10ps

// type: PMEMIO
`celldefine
module PMEMIO (I, OEN, PAD, C, PWD,S0,S1,LVCMOS,DS,A2,A6,VREF,NET107);
    input I, OEN,PWD,S0,S1,LVCMOS,DS,A2,A6,VREF;
    inout PAD;
    output C;
    output NET107;

    bufif0	(PAD, I, OEN);
    not         (PWDB, PWD);
    and         (C, PAD, PWDB);
    buf (NET107,PAD);
    buf (A2N,A2);
    buf (A6N,A6);
    buf (S0N,S0);
    buf (S1N,S1);
    buf (LVCMOSN,LVCMOS);
    buf (DSN,DS);
 
    always @(PAD)
       begin
         if (!$test$plusargs("bus_conflict_off"))
            if ($countdrivers(PAD) && (PAD === 1'bx))
                $display("%t ++BUS CONFLICT++ : %m", $realtime);
       end
    specify
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (I => PAD)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (I => PAD)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (I => PAD)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (I => PAD)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (OEN => PAD)=(0, 0, 0, 0, 0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (OEN => PAD)=(0, 0, 0, 0, 0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (OEN => PAD)=(0, 0, 0, 0, 0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (OEN => PAD)=(0, 0, 0, 0, 0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (PAD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (PAD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (PAD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (PAD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b0) (PWD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b0 && S1 == 1'b1) (PWD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b0) (PWD => C)=(0, 0);
if (LVCMOS == 1'b1 && DS == 1'b0 && S0 == 1'b1 && S1 == 1'b1) (PWD => C)=(0, 0);
    endspecify
endmodule
`endcelldefine

module LVDS_con (input_, VREF, Top_Pad_input, cbit_7);
    output input_;
    input VREF;
    input Top_Pad_input;
    input cbit_7;
assign input_ = (cbit_7)? Top_Pad_input : VREF;
endmodule

