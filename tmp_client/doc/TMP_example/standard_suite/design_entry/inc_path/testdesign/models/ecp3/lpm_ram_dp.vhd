Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE WORK.ALL;

ENTITY lpm_ram_dp IS

        PORT (
        WrAddress           :IN    std_logic_vector(2 downto 0);
        RdAddress           :IN    std_logic_vector(2 downto 0);
        Data                :IN    std_logic_vector(10 downto 0);
        RdClock             :IN    std_logic;
        WrClock             :IN    std_logic;
        RdClockEn           :IN    std_logic;
        WrClockEn           :IN    std_logic;
        WE                  :IN    std_logic;
        Reset               :IN    std_logic;
        Q                   :OUT   std_logic_vector(10 downto 0));

END lpm_ram_dp;

ARCHITECTURE V OF lpm_ram_dp IS
component ddram_16x11
        PORT (
        WrAddress           :IN    std_logic_vector(3 downto 0);
        RdAddress           :IN    std_logic_vector(3 downto 0);
        Data                :IN    std_logic_vector(10 downto 0);
        WrClock             :IN    std_logic;
        WrClockEn           :IN    std_logic;
        WE                  :IN    std_logic;
        Q                   :OUT   std_logic_vector(10 downto 0));

END component;
signal wadr : std_logic_vector(3 downto 0);
signal radr : std_logic_vector(3 downto 0);
BEGIN
wadr <= '0' & WrAddress(2 downto 0);
radr <= '0' & RdAddress(2 downto 0);

ram_inst: ddram_16x11
          port map(
                 WrAddress   => wadr      ,
                 RdAddress   => radr      ,
                 Data        => Data      ,
                 WrClock     => WrClock   ,
                 WrClockEn   => WrClockEn ,
                 WE          => WE        ,
                 Q           => Q         );

END V;
