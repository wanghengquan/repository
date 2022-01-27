LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

	COMPONENT vhdl_misc_resrcshr_on
	PORT(
		a : IN std_logic_vector(7 downto 0);
		b : IN std_logic_vector(7 downto 0);
		add_sub : in std_logic;
		result : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	SIGNAL a :  std_logic_vector(7 downto 0);
	SIGNAL b :  std_logic_vector(7 downto 0);
	SIGNAL add_sub :  std_logic;
	SIGNAL result :  std_logic_vector(7 downto 0);

BEGIN

	uut: vhdl_misc_resrcshr_on PORT MAP(
		a => a,
		b => b,
		add_sub => add_sub,
		result => result
	);

   input_gen: process
   begin
      a   <= (others => '0');
      b   <= (others => '0');
      add_sub <= '1';
      wait for 20 ns;
      a   <= "00000001";
      b   <= "00000010";
      wait for 20 ns;
      a   <= "00000010";
      b   <= "00000011";
      wait for 20 ns;
      a   <= "00000011";
      b   <= "00000100";
      wait for 20 ns;
      a   <= "00000100";
      b   <= "00000101";
      wait for 20 ns;
      a   <= "00000101";
      b   <= "00000110";
      wait for 20 ns;
      a   <= "00000110";
      b   <= "00000111";
      wait for 20 ns;
      a   <= "00000111";
      b   <= "00001000";
      wait for 20 ns;
      a   <= "00001000";
      b   <= "00001001";
      wait for 20 ns;
      a   <= "00101001";
      b   <= "00001010";
      wait for 20 ns;
	  add_sub <= '0';
      a   <= "10000001";
      b   <= "10000010";
      wait for 20 ns;
      a   <= "11000010";
      b   <= "11000011";
      wait for 20 ns;
      a   <= "10000011";
      b   <= "10000100";
      wait for 20 ns;
      a   <= "11000100";
      b   <= "11000101";
      wait for 20 ns;
      a   <= "10000101";
      b   <= "10000110";
      wait for 20 ns;
      a   <= "11000110";
      b   <= "11000111";
      wait for 20 ns;
      a   <= "10000111";
      b   <= "10001000";
      wait for 20 ns;
      a   <= "11001000";
      b   <= "11001001";
      wait for 20 ns;
      a   <= "10101001";
      b   <= "10001010";
      wait for 20 ns;

   end process;


END;

