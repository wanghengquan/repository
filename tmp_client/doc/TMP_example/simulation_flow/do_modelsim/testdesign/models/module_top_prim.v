// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.5.0.91
// Netlist written on Tue May 12 10:07:42 2015
//
// Verilog Description of module module_top
//

module module_top (Address, Data, Clock, WE, ClockEn, Q) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/jwang1/desktop/snow_module/spram/module_top/module_top.v(8[8:18])
    input [4:0]Address;   // c:/users/jwang1/desktop/snow_module/spram/module_top/module_top.v(9[22:29])
    input [7:0]Data;   // c:/users/jwang1/desktop/snow_module/spram/module_top/module_top.v(10[22:26])
    input Clock;   // c:/users/jwang1/desktop/snow_module/spram/module_top/module_top.v(11[16:21])
    input WE;   // c:/users/jwang1/desktop/snow_module/spram/module_top/module_top.v(12[16:18])
    input ClockEn;   // c:/users/jwang1/desktop/snow_module/spram/module_top/module_top.v(13[16:23])
    output [7:0]Q;   // c:/users/jwang1/desktop/snow_module/spram/module_top/module_top.v(14[23:24])
    
    wire Clock /* synthesis is_clock=1 */ ;   // c:/users/jwang1/desktop/snow_module/spram/module_top/module_top.v(11[16:21])
    
    wire addr4_inv, mdL0_0_7, mdL0_0_6, mdL0_0_5, mdL0_0_4, mdL0_0_3, 
        mdL0_0_2, mdL0_0_1, mdL0_0_0, dec0_wre3, mdL0_1_7, mdL0_1_6, 
        mdL0_1_5, mdL0_1_4, mdL0_1_3, mdL0_1_2, mdL0_1_1, mdL0_1_0, 
        dec1_wre7, GND_net, VCC_net;
    
    ROM16X1A LUT4_0 (.AD0(VCC_net), .AD1(Address[4]), .AD2(ClockEn), .AD3(WE), 
            .DO0(dec1_wre7)) /* synthesis syn_instantiated=1 */ ;
    defparam LUT4_0.initval = 16'b1000000000000000;
    SPR16X4C mem_0_1 (.DI0(Data[0]), .DI1(Data[1]), .DI2(Data[2]), .DI3(Data[3]), 
            .AD0(Address[0]), .AD1(Address[1]), .AD2(Address[2]), .AD3(Address[3]), 
            .CK(Clock), .WRE(dec0_wre3), .DO0(mdL0_0_0), .DO1(mdL0_0_1), 
            .DO2(mdL0_0_2), .DO3(mdL0_0_3)) /* synthesis MEM_INIT_FILE="(0-15)(4-7)", MEM_LPC_FILE="module_top.lpc", COMP="mem_0_1", syn_instantiated=1 */ ;
    defparam mem_0_1.initval = "0x0000000000000000";
    SPR16X4C mem_1_0 (.DI0(Data[4]), .DI1(Data[5]), .DI2(Data[6]), .DI3(Data[7]), 
            .AD0(Address[0]), .AD1(Address[1]), .AD2(Address[2]), .AD3(Address[3]), 
            .CK(Clock), .WRE(dec1_wre7), .DO0(mdL0_1_4), .DO1(mdL0_1_5), 
            .DO2(mdL0_1_6), .DO3(mdL0_1_7)) /* synthesis MEM_INIT_FILE="(16-31)(0-3)", MEM_LPC_FILE="module_top.lpc", COMP="mem_1_0", syn_instantiated=1 */ ;
    defparam mem_1_0.initval = "0x0000000000000000";
    SPR16X4C mem_1_1 (.DI0(Data[0]), .DI1(Data[1]), .DI2(Data[2]), .DI3(Data[3]), 
            .AD0(Address[0]), .AD1(Address[1]), .AD2(Address[2]), .AD3(Address[3]), 
            .CK(Clock), .WRE(dec1_wre7), .DO0(mdL0_1_0), .DO1(mdL0_1_1), 
            .DO2(mdL0_1_2), .DO3(mdL0_1_3)) /* synthesis MEM_INIT_FILE="(16-31)(4-7)", MEM_LPC_FILE="module_top.lpc", COMP="mem_1_1", syn_instantiated=1 */ ;
    defparam mem_1_1.initval = "0x0000000000000000";
    VHI i5 (.Z(VCC_net));
    INV INV_0 (.A(Address[4]), .Z(addr4_inv));
    ROM16X1A LUT4_1 (.AD0(VCC_net), .AD1(addr4_inv), .AD2(ClockEn), .AD3(WE), 
            .DO0(dec0_wre3)) /* synthesis syn_instantiated=1 */ ;
    defparam LUT4_1.initval = 16'b1000000000000000;
    GSR GSR_INST (.GSR(VCC_net));
    MUX21 mux_7 (.D0(mdL0_0_7), .D1(mdL0_1_7), .SD(Address[4]), .Z(Q[7])) /* synthesis syn_instantiated=1 */ ;
    MUX21 mux_6 (.D0(mdL0_0_6), .D1(mdL0_1_6), .SD(Address[4]), .Z(Q[6])) /* synthesis syn_instantiated=1 */ ;
    MUX21 mux_5 (.D0(mdL0_0_5), .D1(mdL0_1_5), .SD(Address[4]), .Z(Q[5])) /* synthesis syn_instantiated=1 */ ;
    MUX21 mux_4 (.D0(mdL0_0_4), .D1(mdL0_1_4), .SD(Address[4]), .Z(Q[4])) /* synthesis syn_instantiated=1 */ ;
    MUX21 mux_3 (.D0(mdL0_0_3), .D1(mdL0_1_3), .SD(Address[4]), .Z(Q[3])) /* synthesis syn_instantiated=1 */ ;
    MUX21 mux_2 (.D0(mdL0_0_2), .D1(mdL0_1_2), .SD(Address[4]), .Z(Q[2])) /* synthesis syn_instantiated=1 */ ;
    MUX21 mux_1 (.D0(mdL0_0_1), .D1(mdL0_1_1), .SD(Address[4]), .Z(Q[1])) /* synthesis syn_instantiated=1 */ ;
    MUX21 mux_0 (.D0(mdL0_0_0), .D1(mdL0_1_0), .SD(Address[4]), .Z(Q[0])) /* synthesis syn_instantiated=1 */ ;
    SPR16X4C mem_0_0 (.DI0(Data[4]), .DI1(Data[5]), .DI2(Data[6]), .DI3(Data[7]), 
            .AD0(Address[0]), .AD1(Address[1]), .AD2(Address[2]), .AD3(Address[3]), 
            .CK(Clock), .WRE(dec0_wre3), .DO0(mdL0_0_4), .DO1(mdL0_0_5), 
            .DO2(mdL0_0_6), .DO3(mdL0_0_7)) /* synthesis MEM_INIT_FILE="(0-15)(0-3)", MEM_LPC_FILE="module_top.lpc", COMP="mem_0_0", syn_instantiated=1 */ ;
    defparam mem_0_0.initval = "0x0000000000000000";
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    VLO i51 (.Z(GND_net));
    
endmodule
//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

