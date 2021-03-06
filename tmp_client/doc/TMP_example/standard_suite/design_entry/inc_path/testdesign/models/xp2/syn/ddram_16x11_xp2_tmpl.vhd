-- VHDL module instantiation generated by SCUBA ispLever_v70_Prod_Build (36)
-- Module  Version: 3.1
-- Mon Jun 18 17:08:12 2007

-- parameterized module component declaration
component ddram_16x11_xp2
    port (WrAddress: in  std_logic_vector(3 downto 0); 
        Data: in  std_logic_vector(10 downto 0); WrClock: in  std_logic; 
        WE: in  std_logic; WrClockEn: in  std_logic; 
        RdAddress: in  std_logic_vector(3 downto 0); 
        Q: out  std_logic_vector(10 downto 0));
end component;

-- parameterized module component instance
__ : ddram_16x11_xp2
    port map (WrAddress(3 downto 0)=>__, Data(10 downto 0)=>__, WrClock=>__, 
        WE=>__, WrClockEn=>__, RdAddress(3 downto 0)=>__, Q(10 downto 0)=>__);
