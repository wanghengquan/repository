-- VHDL module instantiation generated by SCUBA ispLever_v81_SP1_Build (36)
-- Module  Version: 5.4
-- Thu Oct 21 10:40:55 2010

-- parameterized module component declaration
component scfifo_xo2
    port (Data: in  std_logic_vector(7 downto 0); WrClock: in  std_logic; 
        RdClock: in  std_logic; WrEn: in  std_logic; RdEn: in  std_logic; 
        Reset: in  std_logic; RPReset: in  std_logic; 
        Q: out  std_logic_vector(7 downto 0); Empty: out  std_logic; 
        Full: out  std_logic; AlmostEmpty: out  std_logic; 
        AlmostFull: out  std_logic);
end component;

-- parameterized module component instance
__ : scfifo_xo2
    port map (Data(7 downto 0)=>__, WrClock=>__, RdClock=>__, WrEn=>__, 
        RdEn=>__, Reset=>__, RPReset=>__, Q(7 downto 0)=>__, Empty=>__, 
        Full=>__, AlmostEmpty=>__, AlmostFull=>__);
