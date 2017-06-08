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
	component scfifo_xp2
		port(
		    Data		: in  std_logic_vector(7 downto 0);
        	Clock		: in  std_logic;
        	WrEn		: in  std_logic;
        	RdEn		: in  std_logic;
        	Reset		: in  std_logic;
        	Q			: out  std_logic_vector(7 downto 0);
        	Empty		: out  std_logic;
        	Full		: out  std_logic;
        	AlmostEmpty	: out  std_logic;
        	AlmostFull	: out  std_logic
			);
	end component;
begin
	inst : scfifo_xp2 port map(
								Data		=> DI,
								Clock		=> CLK,
								WrEn		=> WE,
								RdEn		=> RE,
								Reset		=> RST,
								Q			=> DO,
								Empty		=> EF,
								Full		=> FF,
								AlmostEmpty	=> AE,
								AlmostFull	=> AF
								);
end rtl;
