-- VHDL netlist generated by SCUBA Diamond_3.0_Production (63)
-- Module  Version: 3.6
--C:\diamond3.0.0.63\diamond\3.0_x64\ispfpga\bin\nt64\scuba.exe -w -n ddram_16x11_sap -lang vhdl -synth synplify -bus_exp 7 -bb -arch sa5p00m -type sdpram -rdata_width 11 -data_width 11 -num_rows 16 -outData UNREGISTERED -e 

-- Thu Jul 04 10:14:12 2013

library IEEE;
use IEEE.std_logic_1164.all;
library ECP5UM;
use ECP5UM.components.all;

entity ddram_16x11_sap is
    port (
        WrAddress: in  std_logic_vector(3 downto 0); 
        Data: in  std_logic_vector(10 downto 0); 
        WrClock: in  std_logic; 
        WE: in  std_logic; 
        WrClockEn: in  std_logic; 
        RdAddress: in  std_logic_vector(3 downto 0); 
        Q: out  std_logic_vector(10 downto 0));
end ddram_16x11_sap;

architecture Structure of ddram_16x11_sap is

    -- internal signal declarations
    signal scuba_vhi: std_logic;
    signal dec0_wre3: std_logic;

    attribute MEM_INIT_FILE : string; 
    attribute MEM_LPC_FILE : string; 
    attribute COMP : string; 
    attribute MEM_INIT_FILE of mem_0_0 : label is "(0-15)(0-3)";
    attribute MEM_LPC_FILE of mem_0_0 : label is "ddram_16x11_sap.lpc";
    attribute COMP of mem_0_0 : label is "mem_0_0";
    attribute MEM_INIT_FILE of mem_0_1 : label is "(0-15)(4-7)";
    attribute MEM_LPC_FILE of mem_0_1 : label is "ddram_16x11_sap.lpc";
    attribute COMP of mem_0_1 : label is "mem_0_1";
    attribute MEM_INIT_FILE of mem_0_2 : label is "(0-15)(8-11)";
    attribute MEM_LPC_FILE of mem_0_2 : label is "ddram_16x11_sap.lpc";
    attribute COMP of mem_0_2 : label is "mem_0_2";
    attribute NGD_DRC_MASK : integer;
    attribute NGD_DRC_MASK of Structure : architecture is 1;

begin
    -- component instantiation statements
    LUT4_0: ROM16X1A
        generic map (initval=> X"8000")
        port map (AD3=>WE, AD2=>WrClockEn, AD1=>scuba_vhi, 
            AD0=>scuba_vhi, DO0=>dec0_wre3);

    scuba_vhi_inst: VHI
        port map (Z=>scuba_vhi);

    mem_0_0: DPR16X4C
        generic map (initval=> "0x0000000000000000")
        port map (DI0=>Data(8), DI1=>Data(9), DI2=>Data(10), 
            DI3=>scuba_vhi, WCK=>WrClock, WRE=>dec0_wre3, 
            RAD0=>RdAddress(0), RAD1=>RdAddress(1), RAD2=>RdAddress(2), 
            RAD3=>RdAddress(3), WAD0=>WrAddress(0), WAD1=>WrAddress(1), 
            WAD2=>WrAddress(2), WAD3=>WrAddress(3), DO0=>Q(8), DO1=>Q(9), 
            DO2=>Q(10), DO3=>open);

    mem_0_1: DPR16X4C
        generic map (initval=> "0x0000000000000000")
        port map (DI0=>Data(4), DI1=>Data(5), DI2=>Data(6), DI3=>Data(7), 
            WCK=>WrClock, WRE=>dec0_wre3, RAD0=>RdAddress(0), 
            RAD1=>RdAddress(1), RAD2=>RdAddress(2), RAD3=>RdAddress(3), 
            WAD0=>WrAddress(0), WAD1=>WrAddress(1), WAD2=>WrAddress(2), 
            WAD3=>WrAddress(3), DO0=>Q(4), DO1=>Q(5), DO2=>Q(6), 
            DO3=>Q(7));

    mem_0_2: DPR16X4C
        generic map (initval=> "0x0000000000000000")
        port map (DI0=>Data(0), DI1=>Data(1), DI2=>Data(2), DI3=>Data(3), 
            WCK=>WrClock, WRE=>dec0_wre3, RAD0=>RdAddress(0), 
            RAD1=>RdAddress(1), RAD2=>RdAddress(2), RAD3=>RdAddress(3), 
            WAD0=>WrAddress(0), WAD1=>WrAddress(1), WAD2=>WrAddress(2), 
            WAD3=>WrAddress(3), DO0=>Q(0), DO1=>Q(1), DO2=>Q(2), 
            DO3=>Q(3));

end Structure;