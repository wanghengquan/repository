-- VHDL testbench template generated by SCUBA ispLever_v81_SP1_Build (36)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity tb is
end entity tb;


architecture test of tb is 

    component ddram_16x11_xo2
        port (WrAddress : in std_logic_vector(3 downto 0); 
        Data : in std_logic_vector(10 downto 0); WrClock: in std_logic; 
        WE: in std_logic; WrClockEn: in std_logic; 
        RdAddress : in std_logic_vector(3 downto 0); 
        Q : out std_logic_vector(10 downto 0)
    );
    end component;

    signal WrAddress : std_logic_vector(3 downto 0) := (others => '0');
    signal Data : std_logic_vector(10 downto 0) := (others => '0');
    signal WrClock: std_logic := '0';
    signal WE: std_logic := '0';
    signal WrClockEn: std_logic := '0';
    signal RdAddress : std_logic_vector(3 downto 0) := (others => '0');
    signal Q : std_logic_vector(10 downto 0);
begin
    u1 : ddram_16x11_xo2
        port map (WrAddress => WrAddress, Data => Data, WrClock => WrClock, 
            WE => WE, WrClockEn => WrClockEn, RdAddress => RdAddress, Q => Q
        );

    process

    begin
      WrAddress <= (others => '0') ;
      wait for 100 ns;
      wait for 10 ns;
      for i in 0 to 38 loop
        wait until WrClock'event and WrClock = '1';
        WrAddress <= WrAddress + '1' after 1 ns;
      end loop;
      wait;
    end process;

    process

    begin
      Data <= (others => '0') ;
      wait for 100 ns;
      wait for 10 ns;
      for i in 0 to 19 loop
        wait until WrClock'event and WrClock = '1';
        Data <= Data + '1' after 1 ns;
      end loop;
      wait;
    end process;

    WrClock <= not WrClock after 5.00 ns;

    process

    begin
      WE <= '0' ;
      wait for 10 ns;
      for i in 0 to 19 loop
        wait until WrClock'event and WrClock = '1';
        WE <= '1' after 1 ns;
      end loop;
      WE <= '0' ;
      wait;
    end process;

    process

    begin
      WrClockEn <= '0' ;
      wait for 100 ns;
      wait for 10 ns;
      WrClockEn <= '1' ;
      wait;
    end process;

    process

    begin
      RdAddress <= (others => '0') ;
      wait for 100 ns;
      wait for 10 ns;
      for i in 0 to 38 loop
        wait for 10 ns;
        RdAddress <= RdAddress + '1' ;
      end loop;
      wait;
    end process;

end architecture test;