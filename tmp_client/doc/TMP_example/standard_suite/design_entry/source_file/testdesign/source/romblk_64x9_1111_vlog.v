/* Verilog netlist generated by SCUBA Diamond (64-bit) 3.5.0.98 */
/* Module Version: 2.8 */
/* scuba -w -arch sn5w00 -synth spectrum -lang verilog -bus_exp 7 -bb -n romblk_64x9_1111_vlog -type rom -addr_width 6 -data_width 9 -num_rows 64 -gsr enable -resetmode async -outData REGISTERED -memfile ini_mem -memformat bin  */
/* Thu May 28 17:04:31 2015 */


`timescale 1 ns / 1 ps
module romblk_64x9_1111_vlog (Address, OutClock, OutClockEn, Reset, Q)/* synthesis NGD_DRC_MASK=1 */;
    input wire [5:0] Address;
    input wire OutClock;
    input wire OutClockEn;
    input wire Reset;
    output wire [8:0] Q;

    wire qdataout8_ffin;
    wire qdataout7_ffin;
    wire qdataout6_ffin;
    wire qdataout5_ffin;
    wire qdataout4_ffin;
    wire qdataout3_ffin;
    wire qdataout2_ffin;
    wire qdataout1_ffin;
    wire qdataout0_ffin;

    FD1P3DX FF_8 (.D(qdataout8_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[8]))
             /* synthesis GSR="ENABLED" */;

    FD1P3DX FF_7 (.D(qdataout7_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[7]))
             /* synthesis GSR="ENABLED" */;

    FD1P3DX FF_6 (.D(qdataout6_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[6]))
             /* synthesis GSR="ENABLED" */;

    FD1P3DX FF_5 (.D(qdataout5_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[5]))
             /* synthesis GSR="ENABLED" */;

    FD1P3DX FF_4 (.D(qdataout4_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[4]))
             /* synthesis GSR="ENABLED" */;

    FD1P3DX FF_3 (.D(qdataout3_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[3]))
             /* synthesis GSR="ENABLED" */;

    FD1P3DX FF_2 (.D(qdataout2_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[2]))
             /* synthesis GSR="ENABLED" */;

    FD1P3DX FF_1 (.D(qdataout1_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[1]))
             /* synthesis GSR="ENABLED" */;

    FD1P3DX FF_0 (.D(qdataout0_ffin), .SP(OutClockEn), .CK(OutClock), .CD(Reset), 
        .Q(Q[0]))
             /* synthesis GSR="ENABLED" */;

    defparam mem_0_8.initval =  64'h109B161C1DC83A07 ;
    ROM64X1A mem_0_8 (.AD5(Address[5]), .AD4(Address[4]), .AD3(Address[3]), 
        .AD2(Address[2]), .AD1(Address[1]), .AD0(Address[0]), .DO0(qdataout8_ffin));

    defparam mem_0_7.initval =  64'h7E97040B0F3C4BE6 ;
    ROM64X1A mem_0_7 (.AD5(Address[5]), .AD4(Address[4]), .AD3(Address[3]), 
        .AD2(Address[2]), .AD1(Address[1]), .AD0(Address[0]), .DO0(qdataout7_ffin));

    defparam mem_0_6.initval =  64'hC8BA90869A4DBF34 ;
    ROM64X1A mem_0_6 (.AD5(Address[5]), .AD4(Address[4]), .AD3(Address[3]), 
        .AD2(Address[2]), .AD1(Address[1]), .AD0(Address[0]), .DO0(qdataout6_ffin));

    defparam mem_0_5.initval =  64'hBEF77AF5CD7F9171 ;
    ROM64X1A mem_0_5 (.AD5(Address[5]), .AD4(Address[4]), .AD3(Address[3]), 
        .AD2(Address[2]), .AD1(Address[1]), .AD0(Address[0]), .DO0(qdataout5_ffin));

    defparam mem_0_4.initval =  64'h7AA990D56C56F116 ;
    ROM64X1A mem_0_4 (.AD5(Address[5]), .AD4(Address[4]), .AD3(Address[3]), 
        .AD2(Address[2]), .AD1(Address[1]), .AD0(Address[0]), .DO0(qdataout4_ffin));

    defparam mem_0_3.initval =  64'h400BE13408F3153B ;
    ROM64X1A mem_0_3 (.AD5(Address[5]), .AD4(Address[4]), .AD3(Address[3]), 
        .AD2(Address[2]), .AD1(Address[1]), .AD0(Address[0]), .DO0(qdataout3_ffin));

    defparam mem_0_2.initval =  64'h09E0B171E0044426 ;
    ROM64X1A mem_0_2 (.AD5(Address[5]), .AD4(Address[4]), .AD3(Address[3]), 
        .AD2(Address[2]), .AD1(Address[1]), .AD0(Address[0]), .DO0(qdataout2_ffin));

    defparam mem_0_1.initval =  64'hA1ECC69061ED9A4C ;
    ROM64X1A mem_0_1 (.AD5(Address[5]), .AD4(Address[4]), .AD3(Address[3]), 
        .AD2(Address[2]), .AD1(Address[1]), .AD0(Address[0]), .DO0(qdataout1_ffin));

    defparam mem_0_0.initval =  64'h40A81B3BE4113AAC ;
    ROM64X1A mem_0_0 (.AD5(Address[5]), .AD4(Address[4]), .AD3(Address[3]), 
        .AD2(Address[2]), .AD1(Address[1]), .AD0(Address[0]), .DO0(qdataout0_ffin));



    // exemplar begin
    // exemplar attribute FF_8 GSR ENABLED
    // exemplar attribute FF_7 GSR ENABLED
    // exemplar attribute FF_6 GSR ENABLED
    // exemplar attribute FF_5 GSR ENABLED
    // exemplar attribute FF_4 GSR ENABLED
    // exemplar attribute FF_3 GSR ENABLED
    // exemplar attribute FF_2 GSR ENABLED
    // exemplar attribute FF_1 GSR ENABLED
    // exemplar attribute FF_0 GSR ENABLED
    // exemplar end

endmodule
