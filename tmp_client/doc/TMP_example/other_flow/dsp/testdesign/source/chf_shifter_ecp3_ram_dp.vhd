-- VHDL netlist generated by SCUBA ispLever_v72_SP1_Build (24)
-- Module  Version: 6.0
--C:\ispTOOLS7_2\ispfpga\bin\nt\scuba.exe -w -lang vhdl -synth synplify -bus_exp 7 -bb -arch ep5c00 -type bram -wp 10 -rp 0011 -rdata_width 35 -data_width 35 -num_rows 32 -outdata REGISTERED -cascade -1 -e 

-- Tue Apr 14 22:42:20 2009

library IEEE;
use IEEE.std_logic_1164.all;
-- synopsys translate_off
library ecp3;
use ecp3.components.all;
-- synopsys translate_on

entity chf_shifter_ecp3_ram_dp is
    port (
        WrAddress: in  std_logic_vector(4 downto 0); 
        RdAddress: in  std_logic_vector(4 downto 0); 
        Data: in  std_logic_vector(34 downto 0); 
        WE: in  std_logic; 
        RdClock: in  std_logic; 
        RdClockEn: in  std_logic; 
        Reset: in  std_logic; 
        WrClock: in  std_logic; 
        WrClockEn: in  std_logic; 
        Q: out  std_logic_vector(34 downto 0));
end chf_shifter_ecp3_ram_dp;

architecture Structure of chf_shifter_ecp3_ram_dp is

    -- internal signal declarations
    signal scuba_vhi: std_logic;
    signal scuba_vlo: std_logic;

    -- local component declarations
    component VHI
        port (Z: out  std_logic);
    end component;
    component VLO
        port (Z: out  std_logic);
    end component;
    component PDPW16KC
        generic (GSR : in String; CSDECODE_R : in String; 
                CSDECODE_W : in String; REGMODE : in String; 
                DATA_WIDTH_R : in Integer; DATA_WIDTH_W : in Integer);
        port (DI0: in  std_logic; DI1: in  std_logic; DI2: in  std_logic; 
            DI3: in  std_logic; DI4: in  std_logic; DI5: in  std_logic; 
            DI6: in  std_logic; DI7: in  std_logic; DI8: in  std_logic; 
            DI9: in  std_logic; DI10: in  std_logic; DI11: in  std_logic; 
            DI12: in  std_logic; DI13: in  std_logic; 
            DI14: in  std_logic; DI15: in  std_logic; 
            DI16: in  std_logic; DI17: in  std_logic; 
            DI18: in  std_logic; DI19: in  std_logic; 
            DI20: in  std_logic; DI21: in  std_logic; 
            DI22: in  std_logic; DI23: in  std_logic; 
            DI24: in  std_logic; DI25: in  std_logic; 
            DI26: in  std_logic; DI27: in  std_logic; 
            DI28: in  std_logic; DI29: in  std_logic; 
            DI30: in  std_logic; DI31: in  std_logic; 
            DI32: in  std_logic; DI33: in  std_logic; 
            DI34: in  std_logic; DI35: in  std_logic; 
            ADW0: in  std_logic; ADW1: in  std_logic; 
            ADW2: in  std_logic; ADW3: in  std_logic; 
            ADW4: in  std_logic; ADW5: in  std_logic; 
            ADW6: in  std_logic; ADW7: in  std_logic; 
            ADW8: in  std_logic; BE0: in  std_logic; BE1: in  std_logic; 
            BE2: in  std_logic; BE3: in  std_logic; CEW: in  std_logic; 
            CLKW: in  std_logic; CSW0: in  std_logic; 
            CSW1: in  std_logic; CSW2: in  std_logic; 
            ADR0: in  std_logic; ADR1: in  std_logic; 
            ADR2: in  std_logic; ADR3: in  std_logic; 
            ADR4: in  std_logic; ADR5: in  std_logic; 
            ADR6: in  std_logic; ADR7: in  std_logic; 
            ADR8: in  std_logic; ADR9: in  std_logic; 
            ADR10: in  std_logic; ADR11: in  std_logic; 
            ADR12: in  std_logic; ADR13: in  std_logic; 
            CER: in  std_logic; CLKR: in  std_logic; CSR0: in  std_logic; 
            CSR1: in  std_logic; CSR2: in  std_logic; RST: in  std_logic; 
            DO0: out  std_logic; DO1: out  std_logic; 
            DO2: out  std_logic; DO3: out  std_logic; 
            DO4: out  std_logic; DO5: out  std_logic; 
            DO6: out  std_logic; DO7: out  std_logic; 
            DO8: out  std_logic; DO9: out  std_logic; 
            DO10: out  std_logic; DO11: out  std_logic; 
            DO12: out  std_logic; DO13: out  std_logic; 
            DO14: out  std_logic; DO15: out  std_logic; 
            DO16: out  std_logic; DO17: out  std_logic; 
            DO18: out  std_logic; DO19: out  std_logic; 
            DO20: out  std_logic; DO21: out  std_logic; 
            DO22: out  std_logic; DO23: out  std_logic; 
            DO24: out  std_logic; DO25: out  std_logic; 
            DO26: out  std_logic; DO27: out  std_logic; 
            DO28: out  std_logic; DO29: out  std_logic; 
            DO30: out  std_logic; DO31: out  std_logic; 
            DO32: out  std_logic; DO33: out  std_logic; 
            DO34: out  std_logic; DO35: out  std_logic);
    end component;
    attribute MEM_LPC_FILE : string; 
    attribute MEM_INIT_FILE : string; 
    attribute RESETMODE : string; 
    attribute MEM_LPC_FILE of chf_shifter_ecp3_ram_dp_0_0_0 : label is "chf_shifter_ecp3_ram_dp.lpc";
    attribute MEM_INIT_FILE of chf_shifter_ecp3_ram_dp_0_0_0 : label is "";
    attribute RESETMODE of chf_shifter_ecp3_ram_dp_0_0_0 : label is "SYNC";

begin
    -- component instantiation statements
    scuba_vhi_inst: VHI
        port map (Z=>scuba_vhi);

    scuba_vlo_inst: VLO
        port map (Z=>scuba_vlo);

    chf_shifter_ecp3_ram_dp_0_0_0: PDPW16KC
        generic map (CSDECODE_R=> "0b000", CSDECODE_W=> "0b001", GSR=> "DISABLED", 
        REGMODE=> "OUTREG", DATA_WIDTH_R=>  36, DATA_WIDTH_W=>  36)
        port map (DI0=>Data(0), DI1=>Data(1), DI2=>Data(2), DI3=>Data(3), 
            DI4=>Data(4), DI5=>Data(5), DI6=>Data(6), DI7=>Data(7), 
            DI8=>Data(8), DI9=>Data(9), DI10=>Data(10), DI11=>Data(11), 
            DI12=>Data(12), DI13=>Data(13), DI14=>Data(14), 
            DI15=>Data(15), DI16=>Data(16), DI17=>Data(17), 
            DI18=>Data(18), DI19=>Data(19), DI20=>Data(20), 
            DI21=>Data(21), DI22=>Data(22), DI23=>Data(23), 
            DI24=>Data(24), DI25=>Data(25), DI26=>Data(26), 
            DI27=>Data(27), DI28=>Data(28), DI29=>Data(29), 
            DI30=>Data(30), DI31=>Data(31), DI32=>Data(32), 
            DI33=>Data(33), DI34=>Data(34), DI35=>scuba_vlo, 
            ADW0=>WrAddress(0), ADW1=>WrAddress(1), ADW2=>WrAddress(2), 
            ADW3=>WrAddress(3), ADW4=>WrAddress(4), ADW5=>scuba_vlo, 
            ADW6=>scuba_vlo, ADW7=>scuba_vlo, ADW8=>scuba_vlo, 
            BE0=>scuba_vhi, BE1=>scuba_vhi, BE2=>scuba_vhi, 
            BE3=>scuba_vhi, CEW=>WrClockEn, CLKW=>WrClock, CSW0=>WE, 
            CSW1=>scuba_vlo, CSW2=>scuba_vlo, ADR0=>scuba_vlo, 
            ADR1=>scuba_vlo, ADR2=>scuba_vlo, ADR3=>scuba_vlo, 
            ADR4=>scuba_vlo, ADR5=>RdAddress(0), ADR6=>RdAddress(1), 
            ADR7=>RdAddress(2), ADR8=>RdAddress(3), ADR9=>RdAddress(4), 
            ADR10=>scuba_vlo, ADR11=>scuba_vlo, ADR12=>scuba_vlo, 
            ADR13=>scuba_vlo, CER=>RdClockEn, CLKR=>RdClock, 
            CSR0=>scuba_vlo, CSR1=>scuba_vlo, CSR2=>scuba_vlo, 
            RST=>Reset, DO0=>Q(18), DO1=>Q(19), DO2=>Q(20), DO3=>Q(21), 
            DO4=>Q(22), DO5=>Q(23), DO6=>Q(24), DO7=>Q(25), DO8=>Q(26), 
            DO9=>Q(27), DO10=>Q(28), DO11=>Q(29), DO12=>Q(30), 
            DO13=>Q(31), DO14=>Q(32), DO15=>Q(33), DO16=>Q(34), 
            DO17=>open, DO18=>Q(0), DO19=>Q(1), DO20=>Q(2), DO21=>Q(3), 
            DO22=>Q(4), DO23=>Q(5), DO24=>Q(6), DO25=>Q(7), DO26=>Q(8), 
            DO27=>Q(9), DO28=>Q(10), DO29=>Q(11), DO30=>Q(12), 
            DO31=>Q(13), DO32=>Q(14), DO33=>Q(15), DO34=>Q(16), 
            DO35=>Q(17));

end Structure;

-- synopsys translate_off
library ecp3;
configuration Structure_CON of chf_shifter_ecp3_ram_dp is
    for Structure
        for all:VHI use entity ecp3.VHI(V); end for;
        for all:VLO use entity ecp3.VLO(V); end for;
        for all:PDPW16KC use entity ecp3.PDPW16KC(V); end for;
    end for;
end Structure_CON;

-- synopsys translate_on
