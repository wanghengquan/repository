library IEEE;
use IEEE.std_logic_1164.all;
      
entity add_16_UNSIGNED is
   
      port (DataA: in std_logic_vector(15 downto 0);
            DataB: in std_logic_vector(15 downto 0);
            Cin: in std_logic;
            Cout: out std_logic;
            Result: out std_logic_vector(15 downto 0 ));
      
end add_16_UNSIGNED;
architecture behave of add_16_UNSIGNED is
component pmi_add
         GENERIC(
                pmi_data_width   : integer := 8;
                pmi_result_width   : integer := 8;
                pmi_sign   : string := "off";
                pmi_family       : string := "ECP3";
                module_type : string := "pmi_add"
                );

          port (DataA: in std_logic_vector((pmi_data_width-1) downto 0);
              	DataB: in std_logic_vector((pmi_data_width-1) downto 0);
		      Cin: in std_logic := '0';
              	Result: out std_logic_vector((pmi_result_width-1) downto 0);
              	Cout: out std_logic);
--attribute syn_black_box of pmi_add : component is true;
end component;
    
begin 
pmi_gen: pmi_add
       generic map ( 
                   pmi_data_width => 16, 
                   pmi_result_width => 16,   
                   pmi_sign    => "off", 
                   pmi_family  => "ECP3",
                   module_type => "pmi_add" ) 
       port map ( 
                 DataA => DataA, DataB => DataB, 
                 Cin => Cin, 
                 Cout => Cout, Result => Result);
      
                 
end behave;
