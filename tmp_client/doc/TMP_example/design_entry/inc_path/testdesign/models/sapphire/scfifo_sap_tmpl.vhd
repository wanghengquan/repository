-- VHDL module instantiation generated by SCUBA Diamond_3.0_Production (63)
-- Module  Version: 4.9
-- Thu Jul 04 10:14:12 2013

-- parameterized module component declaration
component scfifo_sap
    port (Data: in  std_logic_vector(7 downto 0); Clock: in  std_logic; 
        WrEn: in  std_logic; RdEn: in  std_logic; Reset: in  std_logic; 
        Q: out  std_logic_vector(7 downto 0); Empty: out  std_logic; 
        Full: out  std_logic; AlmostEmpty: out  std_logic; 
        AlmostFull: out  std_logic);
end component;

-- parameterized module component instance
__ : scfifo_sap
    port map (Data(7 downto 0)=>__, Clock=>__, WrEn=>__, RdEn=>__, Reset=>__, 
        Q(7 downto 0)=>__, Empty=>__, Full=>__, AlmostEmpty=>__, 
        AlmostFull=>__);