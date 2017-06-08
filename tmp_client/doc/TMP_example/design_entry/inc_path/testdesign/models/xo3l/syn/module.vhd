LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ddram_16x11 IS
	PORT(
        WrAddress           :IN    std_logic_vector(3 downto 0);
        RdAddress           :IN    std_logic_vector(3 downto 0);
        Data                :IN    std_logic_vector(10 downto 0);
        WrClock             :IN    std_logic;
        WrClockEn           :IN    std_logic;
        WE                  :IN    std_logic;
        Q                   :OUT   std_logic_vector(10 downto 0)
        );

END ddram_16x11;

ARCHITECTURE rtl OF ddram_16x11 IS
	component ddram_16x11_xo3l
		port(
        	WrAddress	: in  std_logic_vector(3 downto 0);
        	Data		: in  std_logic_vector(10 downto 0);
        	WrClock		: in  std_logic;
        	WE			: in  std_logic;
        	WrClockEn	: in  std_logic;
        	RdAddress	: in  std_logic_vector(3 downto 0);
        	Q			: out  std_logic_vector(10 downto 0)
        	);
	end component;
begin
	inst : ddram_16x11_xo3l port map(
									WrAddress	=> WrAddress,
									Data		=> Data,
									WrClock		=> WrClock,
									WE			=> WE,
									WrClockEn	=> WrClockEn,
									RdAddress	=> RdAddress,
									Q			=> Q
									);
end rtl;





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




Library IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY scfifo IS
    PORT (
        DI                  :IN    std_logic_vector(7 downto 0);
        CLK                 :IN    std_logic;
        WE                  :IN    std_logic;
        RE                  :IN    std_logic;
        RST                 :IN    std_logic;
        DO                  :OUT   std_logic_vector(7 downto 0);
        FF                  :OUT   std_logic;
        AF                  :OUT   std_logic;
        EF                  :OUT   std_logic;
        AE                  :OUT   std_logic
        );
END scfifo;

ARCHITECTURE rtl OF scfifo IS
	component scfifo_xo3l
    port (
        Data: in  std_logic_vector(7 downto 0); 
        WrClock: in  std_logic; 
        RdClock: in  std_logic; 
        WrEn: in  std_logic; 
        RdEn: in  std_logic; 
        Reset: in  std_logic; 
        RPReset: in  std_logic; 
        Q: out  std_logic_vector(7 downto 0); 
        Empty: out  std_logic; 
        Full: out  std_logic; 
        AlmostEmpty: out  std_logic; 
        AlmostFull: out  std_logic);
	end component;
begin
	inst : scfifo_xo3l port map(
								Data		=> DI,
								WrClock		=> CLK,
								RdClock     => not CLK,
								WrEn		=> WE,
								RdEn		=> RE,
								Reset		=> RST,
								RPReset     => '1',
								Q			=> DO,
								Empty		=> EF,
								Full		=> FF,
								AlmostEmpty	=> AE,
								AlmostFull	=> AF
								);
end rtl;