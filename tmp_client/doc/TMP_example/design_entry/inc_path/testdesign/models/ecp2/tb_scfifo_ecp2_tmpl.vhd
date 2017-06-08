-- VHDL testbench template generated by SCUBA ispLever_v70_Prod_Build (36)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity tb is
end entity tb;


architecture test of tb is 

    component scfifo_ecp2
        port (Data : in std_logic_vector(7 downto 0); 
        Clock: in std_logic; WrEn: in std_logic; RdEn: in std_logic; 
        Reset: in std_logic; Q : out std_logic_vector(7 downto 0); 
        Empty: out std_logic; Full: out std_logic; 
        AlmostEmpty: out std_logic; AlmostFull: out std_logic
    );
    end component;

    signal Data : std_logic_vector(7 downto 0) := (others => '0');
    signal Clock: std_logic := '0';
    signal WrEn: std_logic := '0';
    signal RdEn: std_logic := '0';
    signal Reset: std_logic := '0';
    signal Q : std_logic_vector(7 downto 0);
    signal Empty: std_logic;
    signal Full: std_logic;
    signal AlmostEmpty: std_logic;
    signal AlmostFull: std_logic;
begin
    u1 : scfifo_ecp2
        port map (Data => Data, Clock => Clock, WrEn => WrEn, RdEn => RdEn, 
            Reset => Reset, Q => Q, Empty => Empty, Full => Full, 
            AlmostEmpty => AlmostEmpty, AlmostFull => AlmostFull
        );

    process

    begin
      Data <= (others => '0') ;
      for i in 0 to 20 loop
        wait until Clock'event and Clock = '1';
        Data <= Data + '1' after 1 ns;
      end loop;
      wait;
    end process;

    Clock <= not Clock after 5.00 ns;

    process

    begin
      WrEn <= '0' ;
      wait for 100 ns;
      wait until Reset = '0';
      for i in 0 to 20 loop
        wait until Clock'event and Clock = '1';
        WrEn <= '1' after 1 ns;
      end loop;
      WrEn <= '0' ;
      wait;
    end process;

    process

    begin
      RdEn <= '0' ;
      wait until Reset = '0';
      wait until WrEn = '1';
      wait until WrEn = '0';
      for i in 0 to 18 loop
        wait until Clock'event and Clock = '1';
        RdEn <= '1' after 1 ns;
      end loop;
      RdEn <= '0' ;
      wait;
    end process;

    process

    begin
      Reset <= '1' ;
      wait for 100 ns;
      Reset <= '0' ;
      wait;
    end process;

end architecture test;
