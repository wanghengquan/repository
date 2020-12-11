// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.5.0.98
// Netlist written on Wed Jun 24 17:25:14 2015
//
// Verilog Description of module module_top
//

module module_top (Din, Addr, Clock, ClockEn, Reset, Q) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(8[8:18])
    input [11:0]Din;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(9[23:26])
    input [3:0]Addr;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(10[22:26])
    input Clock;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(11[16:21])
    input ClockEn;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(12[16:23])
    input Reset;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(13[16:21])
    output [11:0]Q;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(14[24:25])
    
    wire Clock /* synthesis is_clock=1, SET_AS_NETWORK=Clock */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(11[16:21])
    
    wire Reset_inv, ishreg_addr_w0, ishreg_addr_w1, sreg_0_ctr_1_ci, 
        ishreg_addr_w2, ishreg_addr_w3, co0, shreg_addr_r0, high_inv, 
        shreg_addr_w0, precin, shreg_addr_r1, shreg_addr_r2, shreg_addr_w2, 
        shreg_addr_w1, co0_1, shreg_addr_r3, scuba_vhi, scuba_vlo, 
        shreg_addr_w3, co1_1;
    
    FD1P3DX FF_3 (.D(ishreg_addr_w0), .SP(ClockEn), .CK(Clock), .CD(Reset), 
            .Q(shreg_addr_w0)) /* synthesis GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(72[13] 73[27])
    defparam FF_3.GSR = "ENABLED";
    FD1P3DX FF_2 (.D(ishreg_addr_w1), .SP(ClockEn), .CK(Clock), .CD(Reset), 
            .Q(shreg_addr_w1)) /* synthesis GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(76[13] 77[27])
    defparam FF_2.GSR = "ENABLED";
    FD1P3DX FF_1 (.D(ishreg_addr_w2), .SP(ClockEn), .CK(Clock), .CD(Reset), 
            .Q(shreg_addr_w2)) /* synthesis GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(80[13] 81[27])
    defparam FF_1.GSR = "ENABLED";
    FD1P3DX FF_0 (.D(ishreg_addr_w3), .SP(ClockEn), .CK(Clock), .CD(Reset), 
            .Q(shreg_addr_w3)) /* synthesis GSR="ENABLED", syn_instantiated=1 */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(84[13] 85[27])
    defparam FF_0.GSR = "ENABLED";
    CCU2C sreg_0_ctr_1_cia (.A0(scuba_vlo), .B0(scuba_vlo), .C0(scuba_vhi), 
          .D0(scuba_vhi), .A1(scuba_vhi), .B1(scuba_vhi), .C1(scuba_vhi), 
          .D1(scuba_vhi), .COUT(sreg_0_ctr_1_ci)) /* synthesis syn_instantiated=1 */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(92[11] 94[70])
    defparam sreg_0_ctr_1_cia.INIT0 = 16'b0110011010101010;
    defparam sreg_0_ctr_1_cia.INIT1 = 16'b0110011010101010;
    defparam sreg_0_ctr_1_cia.INJECT1_0 = "NO";
    defparam sreg_0_ctr_1_cia.INJECT1_1 = "NO";
    CCU2C sreg_0_ctr_1_0 (.A0(shreg_addr_w0), .B0(scuba_vlo), .C0(scuba_vhi), 
          .D0(scuba_vhi), .A1(shreg_addr_w1), .B1(scuba_vlo), .C1(scuba_vhi), 
          .D1(scuba_vhi), .CIN(sreg_0_ctr_1_ci), .COUT(co0), .S0(ishreg_addr_w0), 
          .S1(ishreg_addr_w1)) /* synthesis syn_instantiated=1 */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(100[11] 103[20])
    defparam sreg_0_ctr_1_0.INIT0 = 16'b0110011010101010;
    defparam sreg_0_ctr_1_0.INIT1 = 16'b0110011010101010;
    defparam sreg_0_ctr_1_0.INJECT1_0 = "NO";
    defparam sreg_0_ctr_1_0.INJECT1_1 = "NO";
    CCU2C sreg_0_ctr_1_1 (.A0(shreg_addr_w2), .B0(scuba_vlo), .C0(scuba_vhi), 
          .D0(scuba_vhi), .A1(shreg_addr_w3), .B1(scuba_vlo), .C1(scuba_vhi), 
          .D1(scuba_vhi), .CIN(co0), .S0(ishreg_addr_w2), .S1(ishreg_addr_w3)) /* synthesis syn_instantiated=1 */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(109[11] 112[20])
    defparam sreg_0_ctr_1_1.INIT0 = 16'b0110011010101010;
    defparam sreg_0_ctr_1_1.INIT1 = 16'b0110011010101010;
    defparam sreg_0_ctr_1_1.INJECT1_0 = "NO";
    defparam sreg_0_ctr_1_1.INJECT1_1 = "NO";
    CCU2C precin_inst50 (.A0(scuba_vhi), .B0(scuba_vhi), .C0(scuba_vhi), 
          .D0(scuba_vhi), .A1(scuba_vhi), .B1(scuba_vhi), .C1(scuba_vhi), 
          .D1(scuba_vhi), .COUT(precin)) /* synthesis syn_instantiated=1 */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(118[11] 120[61])
    defparam precin_inst50.INIT0 = 16'b0000000000000000;
    defparam precin_inst50.INIT1 = 16'b0000000000000000;
    defparam precin_inst50.INJECT1_0 = "NO";
    defparam precin_inst50.INJECT1_1 = "NO";
    CCU2C raddr_sub_1_0 (.A0(scuba_vhi), .B0(high_inv), .C0(scuba_vhi), 
          .D0(scuba_vhi), .A1(shreg_addr_w0), .B1(Addr[0]), .C1(scuba_vhi), 
          .D1(scuba_vhi), .CIN(precin), .COUT(co0_1), .S1(shreg_addr_r0)) /* synthesis syn_instantiated=1 */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(126[11] 128[63])
    defparam raddr_sub_1_0.INIT0 = 16'b1001100110101010;
    defparam raddr_sub_1_0.INIT1 = 16'b1001100110101010;
    defparam raddr_sub_1_0.INJECT1_0 = "NO";
    defparam raddr_sub_1_0.INJECT1_1 = "NO";
    CCU2C raddr_sub_1_1 (.A0(shreg_addr_w1), .B0(Addr[1]), .C0(scuba_vhi), 
          .D0(scuba_vhi), .A1(shreg_addr_w2), .B1(Addr[2]), .C1(scuba_vhi), 
          .D1(scuba_vhi), .CIN(co0_1), .COUT(co1_1), .S0(shreg_addr_r1), 
          .S1(shreg_addr_r2)) /* synthesis syn_instantiated=1 */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(134[11] 136[75])
    defparam raddr_sub_1_1.INIT0 = 16'b1001100110101010;
    defparam raddr_sub_1_1.INIT1 = 16'b1001100110101010;
    defparam raddr_sub_1_1.INJECT1_0 = "NO";
    defparam raddr_sub_1_1.INJECT1_1 = "NO";
    VHI scuba_vhi_inst (.Z(scuba_vhi));
    VLO scuba_vlo_inst (.Z(scuba_vlo));
    CCU2C raddr_sub_1_2 (.A0(shreg_addr_w3), .B0(Addr[3]), .C0(scuba_vhi), 
          .D0(scuba_vhi), .A1(scuba_vlo), .B1(scuba_vlo), .C1(scuba_vhi), 
          .D1(scuba_vhi), .CIN(co1_1), .S0(shreg_addr_r3)) /* synthesis syn_instantiated=1 */ ;   // c:/users/jwang1/desktop/temp/model/module_top/module_top.v(146[11] 148[73])
    defparam raddr_sub_1_2.INIT0 = 16'b1001100110101010;
    defparam raddr_sub_1_2.INIT1 = 16'b1001100110101010;
    defparam raddr_sub_1_2.INJECT1_0 = "NO";
    defparam raddr_sub_1_2.INJECT1_1 = "NO";
    GSR GSR_INST (.GSR(scuba_vhi));
    INV INV_1 (.A(Reset), .Z(Reset_inv));
    INV INV_0 (.A(scuba_vhi), .Z(high_inv));
    PDPW8KE sram_1_0_0_0 (.DI0(Din[0]), .DI1(Din[1]), .DI2(Din[2]), .DI3(Din[3]), 
            .DI4(Din[4]), .DI5(Din[5]), .DI6(Din[6]), .DI7(Din[7]), 
            .DI8(Din[8]), .DI9(Din[9]), .DI10(Din[10]), .DI11(Din[11]), 
            .DI12(scuba_vlo), .DI13(scuba_vlo), .DI14(scuba_vlo), .DI15(scuba_vlo), 
            .DI16(scuba_vlo), .DI17(scuba_vlo), .ADW0(shreg_addr_w0), 
            .ADW1(shreg_addr_w1), .ADW2(shreg_addr_w2), .ADW3(shreg_addr_w3), 
            .ADW4(scuba_vlo), .ADW5(scuba_vlo), .ADW6(scuba_vlo), .ADW7(scuba_vlo), 
            .ADW8(scuba_vlo), .BE0(scuba_vhi), .BE1(scuba_vhi), .CEW(ClockEn), 
            .CLKW(Clock), .CSW0(Reset_inv), .CSW1(scuba_vlo), .CSW2(scuba_vlo), 
            .ADR0(scuba_vlo), .ADR1(scuba_vlo), .ADR2(scuba_vlo), .ADR3(scuba_vlo), 
            .ADR4(shreg_addr_r0), .ADR5(shreg_addr_r1), .ADR6(shreg_addr_r2), 
            .ADR7(shreg_addr_r3), .ADR8(scuba_vlo), .ADR9(scuba_vlo), 
            .ADR10(scuba_vlo), .ADR11(scuba_vlo), .ADR12(scuba_vlo), .CER(ClockEn), 
            .OCER(ClockEn), .CLKR(Clock), .CSR0(scuba_vlo), .CSR1(scuba_vlo), 
            .CSR2(scuba_vlo), .RST(Reset), .DO0(Q[9]), .DO1(Q[10]), 
            .DO2(Q[11]), .DO9(Q[0]), .DO10(Q[1]), .DO11(Q[2]), .DO12(Q[3]), 
            .DO13(Q[4]), .DO14(Q[5]), .DO15(Q[6]), .DO16(Q[7]), .DO17(Q[8])) /* synthesis MEM_LPC_FILE="module_top.lpc", MEM_INIT_FILE="", syn_instantiated=1 */ ;
    defparam sram_1_0_0_0.DATA_WIDTH_W = 18;
    defparam sram_1_0_0_0.DATA_WIDTH_R = 18;
    defparam sram_1_0_0_0.REGMODE = "OUTREG";
    defparam sram_1_0_0_0.CSDECODE_W = "0b001";
    defparam sram_1_0_0_0.CSDECODE_R = "0b000";
    defparam sram_1_0_0_0.GSR = "ENABLED";
    defparam sram_1_0_0_0.RESETMODE = "ASYNC";
    defparam sram_1_0_0_0.ASYNC_RESET_RELEASE = "SYNC";
    defparam sram_1_0_0_0.INIT_DATA = "STATIC";
    defparam sram_1_0_0_0.INITVAL_00 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_01 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_02 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_03 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_04 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_05 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_06 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_07 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_08 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_09 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_0A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_0B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_0C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_0D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_0E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_0F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_10 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_11 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_12 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_13 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_14 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_15 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_16 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_17 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_18 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_19 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_1A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_1B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_1C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_1D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_1E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam sram_1_0_0_0.INITVAL_1F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    PUR PUR_INST (.PUR(scuba_vhi));
    defparam PUR_INST.RST_PULSE = 1;
    
endmodule
//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

