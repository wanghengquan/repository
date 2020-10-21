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
	component ddram_16x11_ecp2
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
	inst : ddram_16x11_ecp2 port map(
									WrAddress	=> WrAddress,
									Data		=> Data,
									WrClock		=> WrClock,
									WE			=> WE,
									WrClockEn	=> WrClockEn,
									RdAddress	=> RdAddress,
									Q			=> Q
									);
end rtl;
