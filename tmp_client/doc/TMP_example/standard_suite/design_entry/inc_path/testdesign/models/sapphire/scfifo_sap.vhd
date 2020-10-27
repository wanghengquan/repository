-- VHDL netlist generated by SCUBA Diamond_3.0_Production (63)
-- Module  Version: 4.9
--C:\diamond3.0.0.63\diamond\3.0_x64\ispfpga\bin\nt64\scuba.exe -w -n scfifo_sap -lang vhdl -synth synplify -bus_exp 7 -bb -arch sa5p00m -type ebfifo -sync_mode -depth 16 -width 8 -no_enable -pe 2 -pf 14 -sync_reset -e 

-- Thu Jul 04 10:14:12 2013

library IEEE;
use IEEE.std_logic_1164.all;
library ECP5UM;
use ECP5UM.components.all;

entity scfifo_sap is
    port (
        Data: in  std_logic_vector(7 downto 0); 
        Clock: in  std_logic; 
        WrEn: in  std_logic; 
        RdEn: in  std_logic; 
        Reset: in  std_logic; 
        Q: out  std_logic_vector(7 downto 0); 
        Empty: out  std_logic; 
        Full: out  std_logic; 
        AlmostEmpty: out  std_logic; 
        AlmostFull: out  std_logic);
end scfifo_sap;

architecture Structure of scfifo_sap is

    -- internal signal declarations
    signal invout_2: std_logic;
    signal invout_1: std_logic;
    signal rden_i_inv: std_logic;
    signal invout_0: std_logic;
    signal r_nw_inv: std_logic;
    signal r_nw: std_logic;
    signal fcnt_en_inv: std_logic;
    signal fcnt_en: std_logic;
    signal empty_i: std_logic;
    signal empty_d: std_logic;
    signal full_i: std_logic;
    signal full_d: std_logic;
    signal ifcount_0: std_logic;
    signal ifcount_1: std_logic;
    signal bdcnt_bctr_ci: std_logic;
    signal ifcount_2: std_logic;
    signal ifcount_3: std_logic;
    signal co0: std_logic;
    signal ifcount_4: std_logic;
    signal co2: std_logic;
    signal cnt_con: std_logic;
    signal co1: std_logic;
    signal cmp_ci: std_logic;
    signal rden_i: std_logic;
    signal co0_1: std_logic;
    signal co1_1: std_logic;
    signal cmp_le_1: std_logic;
    signal cmp_le_1_c: std_logic;
    signal cmp_ci_1: std_logic;
    signal co0_2: std_logic;
    signal wren_i: std_logic;
    signal co1_2: std_logic;
    signal wren_i_inv: std_logic;
    signal cmp_ge_d1: std_logic;
    signal cmp_ge_d1_c: std_logic;
    signal iwcount_0: std_logic;
    signal iwcount_1: std_logic;
    signal w_ctr_ci: std_logic;
    signal wcount_0: std_logic;
    signal wcount_1: std_logic;
    signal iwcount_2: std_logic;
    signal iwcount_3: std_logic;
    signal co0_3: std_logic;
    signal wcount_2: std_logic;
    signal wcount_3: std_logic;
    signal iwcount_4: std_logic;
    signal co2_1: std_logic;
    signal co1_3: std_logic;
    signal wcount_4: std_logic;
    signal ircount_0: std_logic;
    signal ircount_1: std_logic;
    signal r_ctr_ci: std_logic;
    signal rcount_0: std_logic;
    signal rcount_1: std_logic;
    signal ircount_2: std_logic;
    signal ircount_3: std_logic;
    signal co0_4: std_logic;
    signal rcount_2: std_logic;
    signal rcount_3: std_logic;
    signal ircount_4: std_logic;
    signal co2_2: std_logic;
    signal co1_4: std_logic;
    signal rcount_4: std_logic;
    signal cmp_ci_2: std_logic;
    signal co0_5: std_logic;
    signal co1_5: std_logic;
    signal ae_d: std_logic;
    signal ae_d_c: std_logic;
    signal cmp_ci_3: std_logic;
    signal fcnt_en_inv_inv: std_logic;
    signal cnt_con_inv: std_logic;
    signal fcount_0: std_logic;
    signal fcount_1: std_logic;
    signal co0_6: std_logic;
    signal fcount_2: std_logic;
    signal fcount_3: std_logic;
    signal co1_6: std_logic;
    signal fcount_4: std_logic;
    signal scuba_vlo: std_logic;
    signal af_d: std_logic;
    signal scuba_vhi: std_logic;
    signal af_d_c: std_logic;

    attribute MEM_LPC_FILE : string; 
    attribute MEM_INIT_FILE : string; 
    attribute GSR : string; 
    attribute MEM_LPC_FILE of pdp_ram_0_0_0 : label is "scfifo_sap.lpc";
    attribute MEM_INIT_FILE of pdp_ram_0_0_0 : label is "";
    attribute GSR of FF_18 : label is "ENABLED";
    attribute GSR of FF_17 : label is "ENABLED";
    attribute GSR of FF_16 : label is "ENABLED";
    attribute GSR of FF_15 : label is "ENABLED";
    attribute GSR of FF_14 : label is "ENABLED";
    attribute GSR of FF_13 : label is "ENABLED";
    attribute GSR of FF_12 : label is "ENABLED";
    attribute GSR of FF_11 : label is "ENABLED";
    attribute GSR of FF_10 : label is "ENABLED";
    attribute GSR of FF_9 : label is "ENABLED";
    attribute GSR of FF_8 : label is "ENABLED";
    attribute GSR of FF_7 : label is "ENABLED";
    attribute GSR of FF_6 : label is "ENABLED";
    attribute GSR of FF_5 : label is "ENABLED";
    attribute GSR of FF_4 : label is "ENABLED";
    attribute GSR of FF_3 : label is "ENABLED";
    attribute GSR of FF_2 : label is "ENABLED";
    attribute GSR of FF_1 : label is "ENABLED";
    attribute GSR of FF_0 : label is "ENABLED";
    attribute syn_keep : boolean;
    attribute NGD_DRC_MASK : integer;
    attribute NGD_DRC_MASK of Structure : architecture is 1;

begin
    -- component instantiation statements
    AND2_t4: AND2
        port map (A=>WrEn, B=>invout_2, Z=>wren_i);

    INV_8: INV
        port map (A=>full_i, Z=>invout_2);

    AND2_t3: AND2
        port map (A=>RdEn, B=>invout_1, Z=>rden_i);

    INV_7: INV
        port map (A=>empty_i, Z=>invout_1);

    AND2_t2: AND2
        port map (A=>wren_i, B=>rden_i_inv, Z=>cnt_con);

    XOR2_t1: XOR2
        port map (A=>wren_i, B=>rden_i, Z=>fcnt_en);

    INV_6: INV
        port map (A=>rden_i, Z=>rden_i_inv);

    INV_5: INV
        port map (A=>wren_i, Z=>wren_i_inv);

    LUT4_1: ROM16X1A
        generic map (initval=> X"3232")
        port map (AD3=>scuba_vlo, AD2=>cmp_le_1, AD1=>wren_i, 
            AD0=>empty_i, DO0=>empty_d);

    LUT4_0: ROM16X1A
        generic map (initval=> X"3232")
        port map (AD3=>scuba_vlo, AD2=>cmp_ge_d1, AD1=>rden_i, 
            AD0=>full_i, DO0=>full_d);

    AND2_t0: AND2
        port map (A=>rden_i, B=>invout_0, Z=>r_nw);

    INV_4: INV
        port map (A=>wren_i, Z=>invout_0);

    INV_3: INV
        port map (A=>fcnt_en, Z=>fcnt_en_inv);

    INV_2: INV
        port map (A=>cnt_con, Z=>cnt_con_inv);

    INV_1: INV
        port map (A=>r_nw, Z=>r_nw_inv);

    INV_0: INV
        port map (A=>fcnt_en_inv, Z=>fcnt_en_inv_inv);

    pdp_ram_0_0_0: DP16KD
        generic map (INIT_DATA=> "STATIC", ASYNC_RESET_RELEASE=> "SYNC", 
        CSDECODE_B=> "0b000", CSDECODE_A=> "0b000", WRITEMODE_B=> "NORMAL", 
        WRITEMODE_A=> "NORMAL", GSR=> "ENABLED", RESETMODE=> "SYNC", 
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  9, 
        DATA_WIDTH_A=>  9)
        port map (DIA17=>scuba_vlo, DIA16=>scuba_vlo, DIA15=>scuba_vlo, 
            DIA14=>scuba_vlo, DIA13=>scuba_vlo, DIA12=>scuba_vlo, 
            DIA11=>scuba_vlo, DIA10=>scuba_vlo, DIA9=>scuba_vlo, 
            DIA8=>scuba_vlo, DIA7=>Data(7), DIA6=>Data(6), DIA5=>Data(5), 
            DIA4=>Data(4), DIA3=>Data(3), DIA2=>Data(2), DIA1=>Data(1), 
            DIA0=>Data(0), ADA13=>scuba_vlo, ADA12=>scuba_vlo, 
            ADA11=>scuba_vlo, ADA10=>scuba_vlo, ADA9=>scuba_vlo, 
            ADA8=>scuba_vlo, ADA7=>scuba_vlo, ADA6=>wcount_3, 
            ADA5=>wcount_2, ADA4=>wcount_1, ADA3=>wcount_0, 
            ADA2=>scuba_vlo, ADA1=>scuba_vlo, ADA0=>scuba_vlo, 
            CEA=>wren_i, OCEA=>wren_i, CLKA=>Clock, WEA=>scuba_vhi, 
            CSA2=>scuba_vlo, CSA1=>scuba_vlo, CSA0=>scuba_vlo, 
            RSTA=>Reset, DIB17=>scuba_vlo, DIB16=>scuba_vlo, 
            DIB15=>scuba_vlo, DIB14=>scuba_vlo, DIB13=>scuba_vlo, 
            DIB12=>scuba_vlo, DIB11=>scuba_vlo, DIB10=>scuba_vlo, 
            DIB9=>scuba_vlo, DIB8=>scuba_vlo, DIB7=>scuba_vlo, 
            DIB6=>scuba_vlo, DIB5=>scuba_vlo, DIB4=>scuba_vlo, 
            DIB3=>scuba_vlo, DIB2=>scuba_vlo, DIB1=>scuba_vlo, 
            DIB0=>scuba_vlo, ADB13=>scuba_vlo, ADB12=>scuba_vlo, 
            ADB11=>scuba_vlo, ADB10=>scuba_vlo, ADB9=>scuba_vlo, 
            ADB8=>scuba_vlo, ADB7=>scuba_vlo, ADB6=>rcount_3, 
            ADB5=>rcount_2, ADB4=>rcount_1, ADB3=>rcount_0, 
            ADB2=>scuba_vlo, ADB1=>scuba_vlo, ADB0=>scuba_vlo, 
            CEB=>rden_i, OCEB=>rden_i, CLKB=>Clock, WEB=>scuba_vlo, 
            CSB2=>scuba_vlo, CSB1=>scuba_vlo, CSB0=>scuba_vlo, 
            RSTB=>Reset, DOA17=>open, DOA16=>open, DOA15=>open, 
            DOA14=>open, DOA13=>open, DOA12=>open, DOA11=>open, 
            DOA10=>open, DOA9=>open, DOA8=>open, DOA7=>open, DOA6=>open, 
            DOA5=>open, DOA4=>open, DOA3=>open, DOA2=>open, DOA1=>open, 
            DOA0=>open, DOB17=>open, DOB16=>open, DOB15=>open, 
            DOB14=>open, DOB13=>open, DOB12=>open, DOB11=>open, 
            DOB10=>open, DOB9=>open, DOB8=>open, DOB7=>Q(7), DOB6=>Q(6), 
            DOB5=>Q(5), DOB4=>Q(4), DOB3=>Q(3), DOB2=>Q(2), DOB1=>Q(1), 
            DOB0=>Q(0));

    FF_18: FD1P3DX
        port map (D=>ifcount_0, SP=>fcnt_en, CK=>Clock, CD=>Reset, 
            Q=>fcount_0);

    FF_17: FD1P3DX
        port map (D=>ifcount_1, SP=>fcnt_en, CK=>Clock, CD=>Reset, 
            Q=>fcount_1);

    FF_16: FD1P3DX
        port map (D=>ifcount_2, SP=>fcnt_en, CK=>Clock, CD=>Reset, 
            Q=>fcount_2);

    FF_15: FD1P3DX
        port map (D=>ifcount_3, SP=>fcnt_en, CK=>Clock, CD=>Reset, 
            Q=>fcount_3);

    FF_14: FD1P3DX
        port map (D=>ifcount_4, SP=>fcnt_en, CK=>Clock, CD=>Reset, 
            Q=>fcount_4);

    FF_13: FD1S3BX
        port map (D=>empty_d, CK=>Clock, PD=>Reset, Q=>empty_i);

    FF_12: FD1S3DX
        port map (D=>full_d, CK=>Clock, CD=>Reset, Q=>full_i);

    FF_11: FD1P3DX
        port map (D=>iwcount_0, SP=>wren_i, CK=>Clock, CD=>Reset, 
            Q=>wcount_0);

    FF_10: FD1P3DX
        port map (D=>iwcount_1, SP=>wren_i, CK=>Clock, CD=>Reset, 
            Q=>wcount_1);

    FF_9: FD1P3DX
        port map (D=>iwcount_2, SP=>wren_i, CK=>Clock, CD=>Reset, 
            Q=>wcount_2);

    FF_8: FD1P3DX
        port map (D=>iwcount_3, SP=>wren_i, CK=>Clock, CD=>Reset, 
            Q=>wcount_3);

    FF_7: FD1P3DX
        port map (D=>iwcount_4, SP=>wren_i, CK=>Clock, CD=>Reset, 
            Q=>wcount_4);

    FF_6: FD1P3DX
        port map (D=>ircount_0, SP=>rden_i, CK=>Clock, CD=>Reset, 
            Q=>rcount_0);

    FF_5: FD1P3DX
        port map (D=>ircount_1, SP=>rden_i, CK=>Clock, CD=>Reset, 
            Q=>rcount_1);

    FF_4: FD1P3DX
        port map (D=>ircount_2, SP=>rden_i, CK=>Clock, CD=>Reset, 
            Q=>rcount_2);

    FF_3: FD1P3DX
        port map (D=>ircount_3, SP=>rden_i, CK=>Clock, CD=>Reset, 
            Q=>rcount_3);

    FF_2: FD1P3DX
        port map (D=>ircount_4, SP=>rden_i, CK=>Clock, CD=>Reset, 
            Q=>rcount_4);

    FF_1: FD1S3BX
        port map (D=>ae_d, CK=>Clock, PD=>Reset, Q=>AlmostEmpty);

    FF_0: FD1S3DX
        port map (D=>af_d, CK=>Clock, CD=>Reset, Q=>AlmostFull);

    bdcnt_bctr_cia: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"66AA", 
        INIT0=> X"66AA")
        port map (A0=>scuba_vlo, A1=>cnt_con, B0=>scuba_vlo, B1=>cnt_con, 
            C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, D1=>scuba_vhi, 
            CIN=>'X', S0=>open, S1=>open, COUT=>bdcnt_bctr_ci);

    bdcnt_bctr_0: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"9933", 
        INIT0=> X"9933")
        port map (A0=>fcount_0, A1=>fcount_1, B0=>cnt_con, B1=>cnt_con, 
            C0=>cnt_con, C1=>cnt_con, D0=>scuba_vhi, D1=>scuba_vhi, 
            CIN=>bdcnt_bctr_ci, S0=>ifcount_0, S1=>ifcount_1, COUT=>co0);

    bdcnt_bctr_1: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"9933", 
        INIT0=> X"9933")
        port map (A0=>fcount_2, A1=>fcount_3, B0=>cnt_con, B1=>cnt_con, 
            C0=>cnt_con, C1=>cnt_con, D0=>scuba_vhi, D1=>scuba_vhi, 
            CIN=>co0, S0=>ifcount_2, S1=>ifcount_3, COUT=>co1);

    bdcnt_bctr_2: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"9933", 
        INIT0=> X"9933")
        port map (A0=>fcount_4, A1=>scuba_vlo, B0=>cnt_con, B1=>cnt_con, 
            C0=>cnt_con, C1=>cnt_con, D0=>scuba_vhi, D1=>scuba_vhi, 
            CIN=>co1, S0=>ifcount_4, S1=>open, COUT=>co2);

    e_cmp_ci_a: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"66AA", 
        INIT0=> X"66AA")
        port map (A0=>scuba_vhi, A1=>scuba_vhi, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>'X', S0=>open, S1=>open, COUT=>cmp_ci);

    e_cmp_0: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"99DD", 
        INIT0=> X"99DD")
        port map (A0=>fcount_0, A1=>fcount_1, B0=>rden_i, B1=>scuba_vlo, 
            C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, D1=>scuba_vhi, 
            CIN=>cmp_ci, S0=>open, S1=>open, COUT=>co0_1);

    e_cmp_1: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"99DD", 
        INIT0=> X"99DD")
        port map (A0=>fcount_2, A1=>fcount_3, B0=>scuba_vlo, 
            B1=>scuba_vlo, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>co0_1, S0=>open, S1=>open, COUT=>co1_1);

    e_cmp_2: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"99DD", 
        INIT0=> X"99DD")
        port map (A0=>fcount_4, A1=>scuba_vlo, B0=>scuba_vlo, 
            B1=>scuba_vlo, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>co1_1, S0=>open, S1=>open, 
            COUT=>cmp_le_1_c);

    a0: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"0000", 
        INIT0=> X"0000")
        port map (A0=>scuba_vhi, A1=>scuba_vhi, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>cmp_le_1_c, S0=>cmp_le_1, S1=>open, 
            COUT=>open);

    g_cmp_ci_a: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"66AA", 
        INIT0=> X"66AA")
        port map (A0=>scuba_vhi, A1=>scuba_vhi, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>'X', S0=>open, S1=>open, COUT=>cmp_ci_1);

    g_cmp_0: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"99AA", 
        INIT0=> X"99AA")
        port map (A0=>fcount_0, A1=>fcount_1, B0=>wren_i, B1=>wren_i, 
            C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, D1=>scuba_vhi, 
            CIN=>cmp_ci_1, S0=>open, S1=>open, COUT=>co0_2);

    g_cmp_1: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"99AA", 
        INIT0=> X"99AA")
        port map (A0=>fcount_2, A1=>fcount_3, B0=>wren_i, B1=>wren_i, 
            C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, D1=>scuba_vhi, 
            CIN=>co0_2, S0=>open, S1=>open, COUT=>co1_2);

    g_cmp_2: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"99AA", 
        INIT0=> X"99AA")
        port map (A0=>fcount_4, A1=>scuba_vlo, B0=>wren_i_inv, 
            B1=>scuba_vlo, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>co1_2, S0=>open, S1=>open, 
            COUT=>cmp_ge_d1_c);

    a1: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"0000", 
        INIT0=> X"0000")
        port map (A0=>scuba_vhi, A1=>scuba_vhi, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>cmp_ge_d1_c, S0=>cmp_ge_d1, S1=>open, 
            COUT=>open);

    w_ctr_cia: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"66AA", 
        INIT0=> X"66AA")
        port map (A0=>scuba_vlo, A1=>scuba_vhi, B0=>scuba_vlo, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>'X', S0=>open, S1=>open, COUT=>w_ctr_ci);

    w_ctr_0: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"AA00", 
        INIT0=> X"AA00")
        port map (A0=>wcount_0, A1=>wcount_1, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>w_ctr_ci, S0=>iwcount_0, S1=>iwcount_1, 
            COUT=>co0_3);

    w_ctr_1: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"AA00", 
        INIT0=> X"AA00")
        port map (A0=>wcount_2, A1=>wcount_3, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>co0_3, S0=>iwcount_2, S1=>iwcount_3, 
            COUT=>co1_3);

    w_ctr_2: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"AA00", 
        INIT0=> X"AA00")
        port map (A0=>wcount_4, A1=>scuba_vlo, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>co1_3, S0=>iwcount_4, S1=>open, 
            COUT=>co2_1);

    r_ctr_cia: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"66AA", 
        INIT0=> X"66AA")
        port map (A0=>scuba_vlo, A1=>scuba_vhi, B0=>scuba_vlo, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>'X', S0=>open, S1=>open, COUT=>r_ctr_ci);

    r_ctr_0: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"AA00", 
        INIT0=> X"AA00")
        port map (A0=>rcount_0, A1=>rcount_1, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>r_ctr_ci, S0=>ircount_0, S1=>ircount_1, 
            COUT=>co0_4);

    r_ctr_1: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"AA00", 
        INIT0=> X"AA00")
        port map (A0=>rcount_2, A1=>rcount_3, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>co0_4, S0=>ircount_2, S1=>ircount_3, 
            COUT=>co1_4);

    r_ctr_2: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"AA00", 
        INIT0=> X"AA00")
        port map (A0=>rcount_4, A1=>scuba_vlo, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>co1_4, S0=>ircount_4, S1=>open, 
            COUT=>co2_2);

    ae_cmp_ci_a: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"66AA", 
        INIT0=> X"66AA")
        port map (A0=>scuba_vhi, A1=>scuba_vhi, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>'X', S0=>open, S1=>open, COUT=>cmp_ci_2);

    ae_cmp_0: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"99DD", 
        INIT0=> X"99DD")
        port map (A0=>fcount_0, A1=>fcount_1, B0=>fcnt_en_inv_inv, 
            B1=>cnt_con_inv, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>cmp_ci_2, S0=>open, S1=>open, 
            COUT=>co0_5);

    ae_cmp_1: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"99DD", 
        INIT0=> X"99DD")
        port map (A0=>fcount_2, A1=>fcount_3, B0=>scuba_vlo, 
            B1=>scuba_vlo, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>co0_5, S0=>open, S1=>open, COUT=>co1_5);

    ae_cmp_2: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"99DD", 
        INIT0=> X"99DD")
        port map (A0=>fcount_4, A1=>scuba_vlo, B0=>scuba_vlo, 
            B1=>scuba_vlo, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>co1_5, S0=>open, S1=>open, COUT=>ae_d_c);

    a2: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"0000", 
        INIT0=> X"0000")
        port map (A0=>scuba_vhi, A1=>scuba_vhi, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>ae_d_c, S0=>ae_d, S1=>open, COUT=>open);

    af_cmp_ci_a: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"66AA", 
        INIT0=> X"66AA")
        port map (A0=>scuba_vhi, A1=>scuba_vhi, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>'X', S0=>open, S1=>open, COUT=>cmp_ci_3);

    af_cmp_0: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"99AA", 
        INIT0=> X"99AA")
        port map (A0=>fcount_0, A1=>fcount_1, B0=>fcnt_en_inv_inv, 
            B1=>cnt_con_inv, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>cmp_ci_3, S0=>open, S1=>open, 
            COUT=>co0_6);

    af_cmp_1: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"99AA", 
        INIT0=> X"99AA")
        port map (A0=>fcount_2, A1=>fcount_3, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>co0_6, S0=>open, S1=>open, COUT=>co1_6);

    scuba_vlo_inst: VLO
        port map (Z=>scuba_vlo);

    af_cmp_2: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"99AA", 
        INIT0=> X"99AA")
        port map (A0=>fcount_4, A1=>scuba_vlo, B0=>scuba_vlo, 
            B1=>scuba_vlo, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>co1_6, S0=>open, S1=>open, COUT=>af_d_c);

    scuba_vhi_inst: VHI
        port map (Z=>scuba_vhi);

    a3: CCU2C
        generic map (INJECT1_1=> "NO", INJECT1_0=> "NO", INIT1=> X"0000", 
        INIT0=> X"0000")
        port map (A0=>scuba_vhi, A1=>scuba_vhi, B0=>scuba_vhi, 
            B1=>scuba_vhi, C0=>scuba_vhi, C1=>scuba_vhi, D0=>scuba_vhi, 
            D1=>scuba_vhi, CIN=>af_d_c, S0=>af_d, S1=>open, COUT=>open);

    Empty <= empty_i;
    Full <= full_i;
end Structure;