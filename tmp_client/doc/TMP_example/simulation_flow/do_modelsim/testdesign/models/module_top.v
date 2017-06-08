/* Verilog netlist generated by SCUBA Diamond (64-bit) 3.5.0.91 */
/* Module Version: 3.8 */
/* C:\lscc\diamond\3.5_x64\ispfpga\bin\nt64\scuba.exe -w -n module_top -lang verilog -synth lse -bus_exp 7 -bb -arch sn5w00 -type sspram -addr_width 5 -num_rows 32 -data_width 8 -outData UNREGISTERED -fdc C:/Users/jwang1/Desktop/snow_module/spram/module_top/module_top.fdc  */
/* Tue May 12 10:07:30 2015 */


`timescale 1 ns / 1 ps
module module_top (Address, Data, Clock, WE, ClockEn, Q)/* synthesis NGD_DRC_MASK=1 */;
    input wire [4:0] Address;
    input wire [7:0] Data;
    input wire Clock;
    input wire WE;
    input wire ClockEn;
    output wire [7:0] Q;

    wire addr4_inv;
    wire scuba_vhi;
    wire mdL0_0_7;
    wire mdL0_0_6;
    wire mdL0_0_5;
    wire mdL0_0_4;
    wire mdL0_0_3;
    wire mdL0_0_2;
    wire mdL0_0_1;
    wire mdL0_0_0;
    wire dec0_wre3;
    wire mdL0_1_7;
    wire mdL0_1_6;
    wire mdL0_1_5;
    wire mdL0_1_4;
    wire mdL0_1_3;
    wire mdL0_1_2;
    wire mdL0_1_1;
    wire mdL0_1_0;
    wire dec1_wre7;

    INV INV_0 (.A(Address[4]), .Z(addr4_inv));

    defparam LUT4_1.initval =  16'h8000 ;
    ROM16X1A LUT4_1 (.AD3(WE), .AD2(ClockEn), .AD1(addr4_inv), .AD0(scuba_vhi), 
        .DO0(dec0_wre3));

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    defparam LUT4_0.initval =  16'h8000 ;
    ROM16X1A LUT4_0 (.AD3(WE), .AD2(ClockEn), .AD1(Address[4]), .AD0(scuba_vhi), 
        .DO0(dec1_wre7));

    MUX21 mux_7 (.D0(mdL0_0_7), .D1(mdL0_1_7), .SD(Address[4]), .Z(Q[7]));

    MUX21 mux_6 (.D0(mdL0_0_6), .D1(mdL0_1_6), .SD(Address[4]), .Z(Q[6]));

    MUX21 mux_5 (.D0(mdL0_0_5), .D1(mdL0_1_5), .SD(Address[4]), .Z(Q[5]));

    MUX21 mux_4 (.D0(mdL0_0_4), .D1(mdL0_1_4), .SD(Address[4]), .Z(Q[4]));

    MUX21 mux_3 (.D0(mdL0_0_3), .D1(mdL0_1_3), .SD(Address[4]), .Z(Q[3]));

    MUX21 mux_2 (.D0(mdL0_0_2), .D1(mdL0_1_2), .SD(Address[4]), .Z(Q[2]));

    MUX21 mux_1 (.D0(mdL0_0_1), .D1(mdL0_1_1), .SD(Address[4]), .Z(Q[1]));

    MUX21 mux_0 (.D0(mdL0_0_0), .D1(mdL0_1_0), .SD(Address[4]), .Z(Q[0]));

    defparam mem_0_0.initval = "0x0000000000000000" ;
    SPR16X4C mem_0_0 (.DI0(Data[4]), .DI1(Data[5]), .DI2(Data[6]), .DI3(Data[7]), 
        .CK(Clock), .WRE(dec0_wre3), .AD0(Address[0]), .AD1(Address[1]), 
        .AD2(Address[2]), .AD3(Address[3]), .DO0(mdL0_0_4), .DO1(mdL0_0_5), 
        .DO2(mdL0_0_6), .DO3(mdL0_0_7))
             /* synthesis MEM_INIT_FILE="(0-15)(0-3)" */
             /* synthesis MEM_LPC_FILE="module_top.lpc" */
             /* synthesis COMP="mem_0_0" */;

    defparam mem_0_1.initval = "0x0000000000000000" ;
    SPR16X4C mem_0_1 (.DI0(Data[0]), .DI1(Data[1]), .DI2(Data[2]), .DI3(Data[3]), 
        .CK(Clock), .WRE(dec0_wre3), .AD0(Address[0]), .AD1(Address[1]), 
        .AD2(Address[2]), .AD3(Address[3]), .DO0(mdL0_0_0), .DO1(mdL0_0_1), 
        .DO2(mdL0_0_2), .DO3(mdL0_0_3))
             /* synthesis MEM_INIT_FILE="(0-15)(4-7)" */
             /* synthesis MEM_LPC_FILE="module_top.lpc" */
             /* synthesis COMP="mem_0_1" */;

    defparam mem_1_0.initval = "0x0000000000000000" ;
    SPR16X4C mem_1_0 (.DI0(Data[4]), .DI1(Data[5]), .DI2(Data[6]), .DI3(Data[7]), 
        .CK(Clock), .WRE(dec1_wre7), .AD0(Address[0]), .AD1(Address[1]), 
        .AD2(Address[2]), .AD3(Address[3]), .DO0(mdL0_1_4), .DO1(mdL0_1_5), 
        .DO2(mdL0_1_6), .DO3(mdL0_1_7))
             /* synthesis MEM_INIT_FILE="(16-31)(0-3)" */
             /* synthesis MEM_LPC_FILE="module_top.lpc" */
             /* synthesis COMP="mem_1_0" */;

    defparam mem_1_1.initval = "0x0000000000000000" ;
    SPR16X4C mem_1_1 (.DI0(Data[0]), .DI1(Data[1]), .DI2(Data[2]), .DI3(Data[3]), 
        .CK(Clock), .WRE(dec1_wre7), .AD0(Address[0]), .AD1(Address[1]), 
        .AD2(Address[2]), .AD3(Address[3]), .DO0(mdL0_1_0), .DO1(mdL0_1_1), 
        .DO2(mdL0_1_2), .DO3(mdL0_1_3))
             /* synthesis MEM_INIT_FILE="(16-31)(4-7)" */
             /* synthesis MEM_LPC_FILE="module_top.lpc" */
             /* synthesis COMP="mem_1_1" */;



    // exemplar begin
    // exemplar attribute mem_0_0 MEM_INIT_FILE (0-15)(0-3)
    // exemplar attribute mem_0_0 MEM_LPC_FILE module_top.lpc
    // exemplar attribute mem_0_0 COMP mem_0_0
    // exemplar attribute mem_0_1 MEM_INIT_FILE (0-15)(4-7)
    // exemplar attribute mem_0_1 MEM_LPC_FILE module_top.lpc
    // exemplar attribute mem_0_1 COMP mem_0_1
    // exemplar attribute mem_1_0 MEM_INIT_FILE (16-31)(0-3)
    // exemplar attribute mem_1_0 MEM_LPC_FILE module_top.lpc
    // exemplar attribute mem_1_0 COMP mem_1_0
    // exemplar attribute mem_1_1 MEM_INIT_FILE (16-31)(4-7)
    // exemplar attribute mem_1_1 MEM_LPC_FILE module_top.lpc
    // exemplar attribute mem_1_1 COMP mem_1_1
    // exemplar end

endmodule
