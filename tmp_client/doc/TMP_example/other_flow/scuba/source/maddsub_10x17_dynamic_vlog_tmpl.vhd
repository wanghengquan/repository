-- VHDL module instantiation generated by SCUBA Diamond (64-bit) 3.5.0.98
-- Module  Version: 4.2
-- Thu Jun 04 14:45:44 2015

-- parameterized module component declaration
component maddsub_10x17_dynamic_vlog
    port (CLK0: in  std_logic; CE0: in  std_logic; RST0: in  std_logic; 
        SignA: in  std_logic; SignB: in  std_logic; 
        ADDNSUB: in  std_logic; A0: in  std_logic_vector(9 downto 0); 
        A1: in  std_logic_vector(9 downto 0); 
        B0: in  std_logic_vector(16 downto 0); 
        B1: in  std_logic_vector(16 downto 0); 
        SUM: out  std_logic_vector(27 downto 0));
end component;

-- parameterized module component instance
__ : maddsub_10x17_dynamic_vlog
    port map (CLK0=>__, CE0=>__, RST0=>__, SignA=>__, SignB=>__, ADDNSUB=>__, 
        A0(9 downto 0)=>__, A1(9 downto 0)=>__, B0(16 downto 0)=>__, B1(16 downto 0)=>__, 
        SUM(27 downto 0)=>__);