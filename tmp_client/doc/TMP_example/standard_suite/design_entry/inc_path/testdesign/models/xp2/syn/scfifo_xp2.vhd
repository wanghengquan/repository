-- VHDL netlist generated by SCUBA ispLever_v70_Prod_Build (36)
-- Module  Version: 4.2
--C:\ispTOOLS7_0\ispfpga\bin\nt\scuba.exe -w -lang vhdl -synth synplify -bus_exp 7 -bb -arch mg5a00 -type ebfifo -depth 16 -width 8 -depth 16 -no_enable -pe 2 -pf 14 -e 

-- Mon Jun 18 17:08:25 2007

library IEEE;
use IEEE.std_logic_1164.all;
-- synopsys translate_off
library xp2;
use xp2.components.all;
-- synopsys translate_on

entity scfifo_xp2 is
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
end scfifo_xp2;

architecture Structure of scfifo_xp2 is

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
    signal wcount_0: std_logic;
    signal wcount_1: std_logic;
    signal w_ctr_ci: std_logic;
    signal iwcount_2: std_logic;
    signal iwcount_3: std_logic;
    signal wcount_2: std_logic;
    signal wcount_3: std_logic;
    signal co0_3: std_logic;
    signal iwcount_4: std_logic;
    signal co2_1: std_logic;
    signal wcount_4: std_logic;
    signal co1_3: std_logic;
    signal ircount_0: std_logic;
    signal ircount_1: std_logic;
    signal rcount_0: std_logic;
    signal rcount_1: std_logic;
    signal r_ctr_ci: std_logic;
    signal ircount_2: std_logic;
    signal ircount_3: std_logic;
    signal rcount_2: std_logic;
    signal rcount_3: std_logic;
    signal co0_4: std_logic;
    signal ircount_4: std_logic;
    signal co2_2: std_logic;
    signal rcount_4: std_logic;
    signal co1_4: std_logic;
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
    signal scuba_vhi: std_logic;
    signal fcount_2: std_logic;
    signal fcount_3: std_logic;
    signal co1_6: std_logic;
    signal fcount_4: std_logic;
    signal af_d: std_logic;
    signal af_d_c: std_logic;
    signal scuba_vlo: std_logic;

    -- local component declarations
    component AGEB2
        port (A0: in  std_logic; A1: in  std_logic; B0: in  std_logic; 
            B1: in  std_logic; CI: in  std_logic; GE: out  std_logic);
    end component;
    component ALEB2
        port (A0: in  std_logic; A1: in  std_logic; B0: in  std_logic; 
            B1: in  std_logic; CI: in  std_logic; LE: out  std_logic);
    end component;
    component AND2
        port (A: in  std_logic; B: in  std_logic; Z: out  std_logic);
    end component;
    component CU2
        port (CI: in  std_logic; PC0: in  std_logic; PC1: in  std_logic; 
            CO: out  std_logic; NC0: out  std_logic; NC1: out  std_logic);
    end component;
    component CB2
        port (CI: in  std_logic; PC0: in  std_logic; PC1: in  std_logic; 
            CON: in  std_logic; CO: out  std_logic; NC0: out  std_logic; 
            NC1: out  std_logic);
    end component;
    component FADD2B
        port (A0: in  std_logic; A1: in  std_logic; B0: in  std_logic; 
            B1: in  std_logic; CI: in  std_logic; COUT: out  std_logic; 
            S0: out  std_logic; S1: out  std_logic);
    end component;
    component FD1P3DX
    -- synopsys translate_off
        generic (GSR : in String);
    -- synopsys translate_on
        port (D: in  std_logic; SP: in  std_logic; CK: in  std_logic; 
            CD: in  std_logic; Q: out  std_logic);
    end component;
    component FD1S3BX
    -- synopsys translate_off
        generic (GSR : in String);
    -- synopsys translate_on
        port (D: in  std_logic; CK: in  std_logic; PD: in  std_logic; 
            Q: out  std_logic);
    end component;
    component FD1S3DX
    -- synopsys translate_off
        generic (GSR : in String);
    -- synopsys translate_on
        port (D: in  std_logic; CK: in  std_logic; CD: in  std_logic; 
            Q: out  std_logic);
    end component;
    component INV
        port (A: in  std_logic; Z: out  std_logic);
    end component;
    component ROM16X1
    -- synopsys translate_off
        generic (initval : in String);
    -- synopsys translate_on
        port (AD3: in  std_logic; AD2: in  std_logic; AD1: in  std_logic; 
            AD0: in  std_logic; DO0: out  std_logic);
    end component;
    component VHI
        port (Z: out  std_logic);
    end component;
    component VLO
        port (Z: out  std_logic);
    end component;
    component XOR2
        port (A: in  std_logic; B: in  std_logic; Z: out  std_logic);
    end component;
    component DP16KB
    -- synopsys translate_off
        generic (GSR : in String; WRITEMODE_B : in String; 
                CSDECODE_B : in std_logic_vector(2 downto 0); 
                CSDECODE_A : in std_logic_vector(2 downto 0); 
                WRITEMODE_A : in String; RESETMODE : in String; 
                REGMODE_B : in String; REGMODE_A : in String; 
                DATA_WIDTH_B : in Integer; DATA_WIDTH_A : in Integer);
    -- synopsys translate_on
        port (DIA0: in  std_logic; DIA1: in  std_logic; 
            DIA2: in  std_logic; DIA3: in  std_logic; 
            DIA4: in  std_logic; DIA5: in  std_logic; 
            DIA6: in  std_logic; DIA7: in  std_logic; 
            DIA8: in  std_logic; DIA9: in  std_logic; 
            DIA10: in  std_logic; DIA11: in  std_logic; 
            DIA12: in  std_logic; DIA13: in  std_logic; 
            DIA14: in  std_logic; DIA15: in  std_logic; 
            DIA16: in  std_logic; DIA17: in  std_logic; 
            ADA0: in  std_logic; ADA1: in  std_logic; 
            ADA2: in  std_logic; ADA3: in  std_logic; 
            ADA4: in  std_logic; ADA5: in  std_logic; 
            ADA6: in  std_logic; ADA7: in  std_logic; 
            ADA8: in  std_logic; ADA9: in  std_logic; 
            ADA10: in  std_logic; ADA11: in  std_logic; 
            ADA12: in  std_logic; ADA13: in  std_logic; 
            CEA: in  std_logic; CLKA: in  std_logic; WEA: in  std_logic; 
            CSA0: in  std_logic; CSA1: in  std_logic; 
            CSA2: in  std_logic; RSTA: in  std_logic; 
            DIB0: in  std_logic; DIB1: in  std_logic; 
            DIB2: in  std_logic; DIB3: in  std_logic; 
            DIB4: in  std_logic; DIB5: in  std_logic; 
            DIB6: in  std_logic; DIB7: in  std_logic; 
            DIB8: in  std_logic; DIB9: in  std_logic; 
            DIB10: in  std_logic; DIB11: in  std_logic; 
            DIB12: in  std_logic; DIB13: in  std_logic; 
            DIB14: in  std_logic; DIB15: in  std_logic; 
            DIB16: in  std_logic; DIB17: in  std_logic; 
            ADB0: in  std_logic; ADB1: in  std_logic; 
            ADB2: in  std_logic; ADB3: in  std_logic; 
            ADB4: in  std_logic; ADB5: in  std_logic; 
            ADB6: in  std_logic; ADB7: in  std_logic; 
            ADB8: in  std_logic; ADB9: in  std_logic; 
            ADB10: in  std_logic; ADB11: in  std_logic; 
            ADB12: in  std_logic; ADB13: in  std_logic; 
            CEB: in  std_logic; CLKB: in  std_logic; WEB: in  std_logic; 
            CSB0: in  std_logic; CSB1: in  std_logic; 
            CSB2: in  std_logic; RSTB: in  std_logic; 
            DOA0: out  std_logic; DOA1: out  std_logic; 
            DOA2: out  std_logic; DOA3: out  std_logic; 
            DOA4: out  std_logic; DOA5: out  std_logic; 
            DOA6: out  std_logic; DOA7: out  std_logic; 
            DOA8: out  std_logic; DOA9: out  std_logic; 
            DOA10: out  std_logic; DOA11: out  std_logic; 
            DOA12: out  std_logic; DOA13: out  std_logic; 
            DOA14: out  std_logic; DOA15: out  std_logic; 
            DOA16: out  std_logic; DOA17: out  std_logic; 
            DOB0: out  std_logic; DOB1: out  std_logic; 
            DOB2: out  std_logic; DOB3: out  std_logic; 
            DOB4: out  std_logic; DOB5: out  std_logic; 
            DOB6: out  std_logic; DOB7: out  std_logic; 
            DOB8: out  std_logic; DOB9: out  std_logic; 
            DOB10: out  std_logic; DOB11: out  std_logic; 
            DOB12: out  std_logic; DOB13: out  std_logic; 
            DOB14: out  std_logic; DOB15: out  std_logic; 
            DOB16: out  std_logic; DOB17: out  std_logic);
    end component;
    attribute initval : string; 
    attribute MEM_LPC_FILE : string; 
    attribute MEM_INIT_FILE : string; 
    attribute CSDECODE_B : string; 
    attribute CSDECODE_A : string; 
    attribute WRITEMODE_B : string; 
    attribute WRITEMODE_A : string; 
    attribute RESETMODE : string; 
    attribute REGMODE_B : string; 
    attribute REGMODE_A : string; 
    attribute DATA_WIDTH_B : string; 
    attribute DATA_WIDTH_A : string; 
    attribute GSR : string; 
    attribute initval of LUT4_1 : label is "0x3232";
    attribute initval of LUT4_0 : label is "0x3232";
    attribute MEM_LPC_FILE of pdp_ram_0_0_0 : label is "scfifo_xp2.lpc";
    attribute MEM_INIT_FILE of pdp_ram_0_0_0 : label is "";
    attribute CSDECODE_B of pdp_ram_0_0_0 : label is "0b000";
    attribute CSDECODE_A of pdp_ram_0_0_0 : label is "0b000";
    attribute WRITEMODE_B of pdp_ram_0_0_0 : label is "NORMAL";
    attribute WRITEMODE_A of pdp_ram_0_0_0 : label is "NORMAL";
    attribute GSR of pdp_ram_0_0_0 : label is "ENABLED";
    attribute RESETMODE of pdp_ram_0_0_0 : label is "ASYNC";
    attribute REGMODE_B of pdp_ram_0_0_0 : label is "NOREG";
    attribute REGMODE_A of pdp_ram_0_0_0 : label is "NOREG";
    attribute DATA_WIDTH_B of pdp_ram_0_0_0 : label is "9";
    attribute DATA_WIDTH_A of pdp_ram_0_0_0 : label is "9";
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

    LUT4_1: ROM16X1
        -- synopsys translate_off
        generic map (initval=> "0x3232")
        -- synopsys translate_on
        port map (AD3=>scuba_vlo, AD2=>cmp_le_1, AD1=>wren_i, 
            AD0=>empty_i, DO0=>empty_d);

    LUT4_0: ROM16X1
        -- synopsys translate_off
        generic map (initval=> "0x3232")
        -- synopsys translate_on
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

    pdp_ram_0_0_0: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "000", CSDECODE_A=> "000", WRITEMODE_B=> "NORMAL", 
        WRITEMODE_A=> "NORMAL", GSR=> "ENABLED", RESETMODE=> "ASYNC", 
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  9, 
        DATA_WIDTH_A=>  9)
        -- synopsys translate_on
        port map (DIA0=>Data(0), DIA1=>Data(1), DIA2=>Data(2), 
            DIA3=>Data(3), DIA4=>Data(4), DIA5=>Data(5), DIA6=>Data(6), 
            DIA7=>Data(7), DIA8=>scuba_vlo, DIA9=>scuba_vlo, 
            DIA10=>scuba_vlo, DIA11=>scuba_vlo, DIA12=>scuba_vlo, 
            DIA13=>scuba_vlo, DIA14=>scuba_vlo, DIA15=>scuba_vlo, 
            DIA16=>scuba_vlo, DIA17=>scuba_vlo, ADA0=>scuba_vlo, 
            ADA1=>scuba_vlo, ADA2=>scuba_vlo, ADA3=>wcount_0, 
            ADA4=>wcount_1, ADA5=>wcount_2, ADA6=>wcount_3, 
            ADA7=>scuba_vlo, ADA8=>scuba_vlo, ADA9=>scuba_vlo, 
            ADA10=>scuba_vlo, ADA11=>scuba_vlo, ADA12=>scuba_vlo, 
            ADA13=>scuba_vlo, CEA=>wren_i, CLKA=>Clock, WEA=>scuba_vhi, 
            CSA0=>scuba_vlo, CSA1=>scuba_vlo, CSA2=>scuba_vlo, 
            RSTA=>Reset, DIB0=>scuba_vlo, DIB1=>scuba_vlo, 
            DIB2=>scuba_vlo, DIB3=>scuba_vlo, DIB4=>scuba_vlo, 
            DIB5=>scuba_vlo, DIB6=>scuba_vlo, DIB7=>scuba_vlo, 
            DIB8=>scuba_vlo, DIB9=>scuba_vlo, DIB10=>scuba_vlo, 
            DIB11=>scuba_vlo, DIB12=>scuba_vlo, DIB13=>scuba_vlo, 
            DIB14=>scuba_vlo, DIB15=>scuba_vlo, DIB16=>scuba_vlo, 
            DIB17=>scuba_vlo, ADB0=>scuba_vlo, ADB1=>scuba_vlo, 
            ADB2=>scuba_vlo, ADB3=>rcount_0, ADB4=>rcount_1, 
            ADB5=>rcount_2, ADB6=>rcount_3, ADB7=>scuba_vlo, 
            ADB8=>scuba_vlo, ADB9=>scuba_vlo, ADB10=>scuba_vlo, 
            ADB11=>scuba_vlo, ADB12=>scuba_vlo, ADB13=>scuba_vlo, 
            CEB=>rden_i, CLKB=>Clock, WEB=>scuba_vlo, CSB0=>scuba_vlo, 
            CSB1=>scuba_vlo, CSB2=>scuba_vlo, RSTB=>Reset, DOA0=>open, 
            DOA1=>open, DOA2=>open, DOA3=>open, DOA4=>open, DOA5=>open, 
            DOA6=>open, DOA7=>open, DOA8=>open, DOA9=>open, DOA10=>open, 
            DOA11=>open, DOA12=>open, DOA13=>open, DOA14=>open, 
            DOA15=>open, DOA16=>open, DOA17=>open, DOB0=>Q(0), 
            DOB1=>Q(1), DOB2=>Q(2), DOB3=>Q(3), DOB4=>Q(4), DOB5=>Q(5), 
            DOB6=>Q(6), DOB7=>Q(7), DOB8=>open, DOB9=>open, DOB10=>open, 
            DOB11=>open, DOB12=>open, DOB13=>open, DOB14=>open, 
            DOB15=>open, DOB16=>open, DOB17=>open);

    FF_18: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>ifcount_0, SP=>fcnt_en, CK=>Clock, CD=>Reset, 
            Q=>fcount_0);

    FF_17: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>ifcount_1, SP=>fcnt_en, CK=>Clock, CD=>Reset, 
            Q=>fcount_1);

    FF_16: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>ifcount_2, SP=>fcnt_en, CK=>Clock, CD=>Reset, 
            Q=>fcount_2);

    FF_15: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>ifcount_3, SP=>fcnt_en, CK=>Clock, CD=>Reset, 
            Q=>fcount_3);

    FF_14: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>ifcount_4, SP=>fcnt_en, CK=>Clock, CD=>Reset, 
            Q=>fcount_4);

    FF_13: FD1S3BX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>empty_d, CK=>Clock, PD=>Reset, Q=>empty_i);

    FF_12: FD1S3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>full_d, CK=>Clock, CD=>Reset, Q=>full_i);

    FF_11: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>iwcount_0, SP=>wren_i, CK=>Clock, CD=>Reset, 
            Q=>wcount_0);

    FF_10: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>iwcount_1, SP=>wren_i, CK=>Clock, CD=>Reset, 
            Q=>wcount_1);

    FF_9: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>iwcount_2, SP=>wren_i, CK=>Clock, CD=>Reset, 
            Q=>wcount_2);

    FF_8: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>iwcount_3, SP=>wren_i, CK=>Clock, CD=>Reset, 
            Q=>wcount_3);

    FF_7: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>iwcount_4, SP=>wren_i, CK=>Clock, CD=>Reset, 
            Q=>wcount_4);

    FF_6: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>ircount_0, SP=>rden_i, CK=>Clock, CD=>Reset, 
            Q=>rcount_0);

    FF_5: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>ircount_1, SP=>rden_i, CK=>Clock, CD=>Reset, 
            Q=>rcount_1);

    FF_4: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>ircount_2, SP=>rden_i, CK=>Clock, CD=>Reset, 
            Q=>rcount_2);

    FF_3: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>ircount_3, SP=>rden_i, CK=>Clock, CD=>Reset, 
            Q=>rcount_3);

    FF_2: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>ircount_4, SP=>rden_i, CK=>Clock, CD=>Reset, 
            Q=>rcount_4);

    FF_1: FD1S3BX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>ae_d, CK=>Clock, PD=>Reset, Q=>AlmostEmpty);

    FF_0: FD1S3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>af_d, CK=>Clock, CD=>Reset, Q=>AlmostFull);

    bdcnt_bctr_cia: FADD2B
        port map (A0=>scuba_vlo, A1=>cnt_con, B0=>scuba_vlo, B1=>cnt_con, 
            CI=>scuba_vlo, COUT=>bdcnt_bctr_ci, S0=>open, S1=>open);

    bdcnt_bctr_0: CB2
        port map (CI=>bdcnt_bctr_ci, PC0=>fcount_0, PC1=>fcount_1, 
            CON=>cnt_con, CO=>co0, NC0=>ifcount_0, NC1=>ifcount_1);

    bdcnt_bctr_1: CB2
        port map (CI=>co0, PC0=>fcount_2, PC1=>fcount_3, CON=>cnt_con, 
            CO=>co1, NC0=>ifcount_2, NC1=>ifcount_3);

    bdcnt_bctr_2: CB2
        port map (CI=>co1, PC0=>fcount_4, PC1=>scuba_vlo, CON=>cnt_con, 
            CO=>co2, NC0=>ifcount_4, NC1=>open);

    e_cmp_ci_a: FADD2B
        port map (A0=>scuba_vhi, A1=>scuba_vhi, B0=>scuba_vhi, 
            B1=>scuba_vhi, CI=>scuba_vlo, COUT=>cmp_ci, S0=>open, 
            S1=>open);

    e_cmp_0: ALEB2
        port map (A0=>fcount_0, A1=>fcount_1, B0=>rden_i, B1=>scuba_vlo, 
            CI=>cmp_ci, LE=>co0_1);

    e_cmp_1: ALEB2
        port map (A0=>fcount_2, A1=>fcount_3, B0=>scuba_vlo, 
            B1=>scuba_vlo, CI=>co0_1, LE=>co1_1);

    e_cmp_2: ALEB2
        port map (A0=>fcount_4, A1=>scuba_vlo, B0=>scuba_vlo, 
            B1=>scuba_vlo, CI=>co1_1, LE=>cmp_le_1_c);

    a0: FADD2B
        port map (A0=>scuba_vlo, A1=>scuba_vlo, B0=>scuba_vlo, 
            B1=>scuba_vlo, CI=>cmp_le_1_c, COUT=>open, S0=>cmp_le_1, 
            S1=>open);

    g_cmp_ci_a: FADD2B
        port map (A0=>scuba_vhi, A1=>scuba_vhi, B0=>scuba_vhi, 
            B1=>scuba_vhi, CI=>scuba_vlo, COUT=>cmp_ci_1, S0=>open, 
            S1=>open);

    g_cmp_0: AGEB2
        port map (A0=>fcount_0, A1=>fcount_1, B0=>wren_i, B1=>wren_i, 
            CI=>cmp_ci_1, GE=>co0_2);

    g_cmp_1: AGEB2
        port map (A0=>fcount_2, A1=>fcount_3, B0=>wren_i, B1=>wren_i, 
            CI=>co0_2, GE=>co1_2);

    g_cmp_2: AGEB2
        port map (A0=>fcount_4, A1=>scuba_vlo, B0=>wren_i_inv, 
            B1=>scuba_vlo, CI=>co1_2, GE=>cmp_ge_d1_c);

    a1: FADD2B
        port map (A0=>scuba_vlo, A1=>scuba_vlo, B0=>scuba_vlo, 
            B1=>scuba_vlo, CI=>cmp_ge_d1_c, COUT=>open, S0=>cmp_ge_d1, 
            S1=>open);

    w_ctr_cia: FADD2B
        port map (A0=>scuba_vlo, A1=>scuba_vhi, B0=>scuba_vlo, 
            B1=>scuba_vhi, CI=>scuba_vlo, COUT=>w_ctr_ci, S0=>open, 
            S1=>open);

    w_ctr_0: CU2
        port map (CI=>w_ctr_ci, PC0=>wcount_0, PC1=>wcount_1, CO=>co0_3, 
            NC0=>iwcount_0, NC1=>iwcount_1);

    w_ctr_1: CU2
        port map (CI=>co0_3, PC0=>wcount_2, PC1=>wcount_3, CO=>co1_3, 
            NC0=>iwcount_2, NC1=>iwcount_3);

    w_ctr_2: CU2
        port map (CI=>co1_3, PC0=>wcount_4, PC1=>scuba_vlo, CO=>co2_1, 
            NC0=>iwcount_4, NC1=>open);

    r_ctr_cia: FADD2B
        port map (A0=>scuba_vlo, A1=>scuba_vhi, B0=>scuba_vlo, 
            B1=>scuba_vhi, CI=>scuba_vlo, COUT=>r_ctr_ci, S0=>open, 
            S1=>open);

    r_ctr_0: CU2
        port map (CI=>r_ctr_ci, PC0=>rcount_0, PC1=>rcount_1, CO=>co0_4, 
            NC0=>ircount_0, NC1=>ircount_1);

    r_ctr_1: CU2
        port map (CI=>co0_4, PC0=>rcount_2, PC1=>rcount_3, CO=>co1_4, 
            NC0=>ircount_2, NC1=>ircount_3);

    r_ctr_2: CU2
        port map (CI=>co1_4, PC0=>rcount_4, PC1=>scuba_vlo, CO=>co2_2, 
            NC0=>ircount_4, NC1=>open);

    ae_cmp_ci_a: FADD2B
        port map (A0=>scuba_vhi, A1=>scuba_vhi, B0=>scuba_vhi, 
            B1=>scuba_vhi, CI=>scuba_vlo, COUT=>cmp_ci_2, S0=>open, 
            S1=>open);

    ae_cmp_0: ALEB2
        port map (A0=>fcount_0, A1=>fcount_1, B0=>fcnt_en_inv_inv, 
            B1=>cnt_con_inv, CI=>cmp_ci_2, LE=>co0_5);

    ae_cmp_1: ALEB2
        port map (A0=>fcount_2, A1=>fcount_3, B0=>scuba_vlo, 
            B1=>scuba_vlo, CI=>co0_5, LE=>co1_5);

    ae_cmp_2: ALEB2
        port map (A0=>fcount_4, A1=>scuba_vlo, B0=>scuba_vlo, 
            B1=>scuba_vlo, CI=>co1_5, LE=>ae_d_c);

    a2: FADD2B
        port map (A0=>scuba_vlo, A1=>scuba_vlo, B0=>scuba_vlo, 
            B1=>scuba_vlo, CI=>ae_d_c, COUT=>open, S0=>ae_d, S1=>open);

    af_cmp_ci_a: FADD2B
        port map (A0=>scuba_vhi, A1=>scuba_vhi, B0=>scuba_vhi, 
            B1=>scuba_vhi, CI=>scuba_vlo, COUT=>cmp_ci_3, S0=>open, 
            S1=>open);

    af_cmp_0: AGEB2
        port map (A0=>fcount_0, A1=>fcount_1, B0=>fcnt_en_inv_inv, 
            B1=>cnt_con_inv, CI=>cmp_ci_3, GE=>co0_6);

    scuba_vhi_inst: VHI
        port map (Z=>scuba_vhi);

    af_cmp_1: AGEB2
        port map (A0=>fcount_2, A1=>fcount_3, B0=>scuba_vhi, 
            B1=>scuba_vhi, CI=>co0_6, GE=>co1_6);

    af_cmp_2: AGEB2
        port map (A0=>fcount_4, A1=>scuba_vlo, B0=>scuba_vlo, 
            B1=>scuba_vlo, CI=>co1_6, GE=>af_d_c);

    scuba_vlo_inst: VLO
        port map (Z=>scuba_vlo);

    a3: FADD2B
        port map (A0=>scuba_vlo, A1=>scuba_vlo, B0=>scuba_vlo, 
            B1=>scuba_vlo, CI=>af_d_c, COUT=>open, S0=>af_d, S1=>open);

    Empty <= empty_i;
    Full <= full_i;
end Structure;

-- synopsys translate_off
library xp2;
configuration Structure_CON of scfifo_xp2 is
    for Structure
        for all:AGEB2 use entity xp2.AGEB2(V); end for;
        for all:ALEB2 use entity xp2.ALEB2(V); end for;
        for all:AND2 use entity xp2.AND2(V); end for;
        for all:CU2 use entity xp2.CU2(V); end for;
        for all:CB2 use entity xp2.CB2(V); end for;
        for all:FADD2B use entity xp2.FADD2B(V); end for;
        for all:FD1P3DX use entity xp2.FD1P3DX(V); end for;
        for all:FD1S3BX use entity xp2.FD1S3BX(V); end for;
        for all:FD1S3DX use entity xp2.FD1S3DX(V); end for;
        for all:INV use entity xp2.INV(V); end for;
        for all:ROM16X1 use entity xp2.ROM16X1(V); end for;
        for all:VHI use entity xp2.VHI(V); end for;
        for all:VLO use entity xp2.VLO(V); end for;
        for all:XOR2 use entity xp2.XOR2(V); end for;
        for all:DP16KB use entity xp2.DP16KB(V); end for;
    end for;
end Structure_CON;

-- synopsys translate_on
