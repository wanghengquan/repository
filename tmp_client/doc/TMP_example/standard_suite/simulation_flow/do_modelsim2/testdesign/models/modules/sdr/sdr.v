/* Verilog netlist generated by SCUBA Diamond (64-bit) 3.5.0.91 */
/* Module Version: 5.8 */
/* D:\diamond3.5.0.91\diamond\3.5_x64\ispfpga\bin\nt64\scuba.exe -w -n sdr -lang verilog -synth lse -bus_exp 7 -bb -arch sn5w00 -type iol -mode Receive -io_type LVCMOS25 -width 8 -freq_in 100 -aligned -del -1 -gear 1 -fdc //d27550/test_dir/BE_Validation/TRTS/01_Projects/04_snow/04_sysIO_Logic/01_SDR/01_RX_B16_F200_normal/models/modules/sdr/sdr.fdc  */
/* Mon May 11 16:17:54 2015 */


`timescale 1 ns / 1 ps
module sdr (clkin, reset, sclk, datain, q)/* synthesis NGD_DRC_MASK=1 */;
    input wire clkin;
    input wire reset;
    input wire [7:0] datain;
    output wire sclk;
    output wire [7:0] q;

    wire buf_clkin;
    wire scuba_vhi;
    wire dataini_t7;
    wire dataini_t6;
    wire dataini_t5;
    wire dataini_t4;
    wire dataini_t3;
    wire dataini_t2;
    wire dataini_t1;
    wire dataini_t0;
    wire buf_dataini7;
    wire buf_dataini6;
    wire buf_dataini5;
    wire buf_dataini4;
    wire buf_dataini3;
    wire buf_dataini2;
    wire buf_dataini1;
    wire buf_dataini0;

    IB Inst3_IB (.I(clkin), .O(buf_clkin))
             /* synthesis IO_TYPE="LVCMOS25" */;

    IFS1P3DX Inst2_IFS1P3DX7 (.D(dataini_t7), .SP(scuba_vhi), .SCLK(buf_clkin), 
        .CD(reset), .Q(q[7]));

    IFS1P3DX Inst2_IFS1P3DX6 (.D(dataini_t6), .SP(scuba_vhi), .SCLK(buf_clkin), 
        .CD(reset), .Q(q[6]));

    IFS1P3DX Inst2_IFS1P3DX5 (.D(dataini_t5), .SP(scuba_vhi), .SCLK(buf_clkin), 
        .CD(reset), .Q(q[5]));

    IFS1P3DX Inst2_IFS1P3DX4 (.D(dataini_t4), .SP(scuba_vhi), .SCLK(buf_clkin), 
        .CD(reset), .Q(q[4]));

    IFS1P3DX Inst2_IFS1P3DX3 (.D(dataini_t3), .SP(scuba_vhi), .SCLK(buf_clkin), 
        .CD(reset), .Q(q[3]));

    IFS1P3DX Inst2_IFS1P3DX2 (.D(dataini_t2), .SP(scuba_vhi), .SCLK(buf_clkin), 
        .CD(reset), .Q(q[2]));

    IFS1P3DX Inst2_IFS1P3DX1 (.D(dataini_t1), .SP(scuba_vhi), .SCLK(buf_clkin), 
        .CD(reset), .Q(q[1]));

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    IFS1P3DX Inst2_IFS1P3DX0 (.D(dataini_t0), .SP(scuba_vhi), .SCLK(buf_clkin), 
        .CD(reset), .Q(q[0]));

    IB Inst1_IB7 (.I(datain[7]), .O(buf_dataini7))
             /* synthesis IO_TYPE="LVCMOS25" */;

    IB Inst1_IB6 (.I(datain[6]), .O(buf_dataini6))
             /* synthesis IO_TYPE="LVCMOS25" */;

    IB Inst1_IB5 (.I(datain[5]), .O(buf_dataini5))
             /* synthesis IO_TYPE="LVCMOS25" */;

    IB Inst1_IB4 (.I(datain[4]), .O(buf_dataini4))
             /* synthesis IO_TYPE="LVCMOS25" */;

    IB Inst1_IB3 (.I(datain[3]), .O(buf_dataini3))
             /* synthesis IO_TYPE="LVCMOS25" */;

    IB Inst1_IB2 (.I(datain[2]), .O(buf_dataini2))
             /* synthesis IO_TYPE="LVCMOS25" */;

    IB Inst1_IB1 (.I(datain[1]), .O(buf_dataini1))
             /* synthesis IO_TYPE="LVCMOS25" */;

    IB Inst1_IB0 (.I(datain[0]), .O(buf_dataini0))
             /* synthesis IO_TYPE="LVCMOS25" */;

    assign sclk = buf_clkin;
    assign dataini_t7 = buf_dataini7;
    assign dataini_t6 = buf_dataini6;
    assign dataini_t5 = buf_dataini5;
    assign dataini_t4 = buf_dataini4;
    assign dataini_t3 = buf_dataini3;
    assign dataini_t2 = buf_dataini2;
    assign dataini_t1 = buf_dataini1;
    assign dataini_t0 = buf_dataini0;


    // exemplar begin
    // exemplar attribute Inst3_IB IO_TYPE LVCMOS25
    // exemplar attribute Inst1_IB7 IO_TYPE LVCMOS25
    // exemplar attribute Inst1_IB6 IO_TYPE LVCMOS25
    // exemplar attribute Inst1_IB5 IO_TYPE LVCMOS25
    // exemplar attribute Inst1_IB4 IO_TYPE LVCMOS25
    // exemplar attribute Inst1_IB3 IO_TYPE LVCMOS25
    // exemplar attribute Inst1_IB2 IO_TYPE LVCMOS25
    // exemplar attribute Inst1_IB1 IO_TYPE LVCMOS25
    // exemplar attribute Inst1_IB0 IO_TYPE LVCMOS25
    // exemplar end

endmodule
