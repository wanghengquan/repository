library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity tb_b is
end tb_b;


architecture simulate of tb_b is

component add_16_UNSIGNED
port (
     DataA: in std_logic_vector(15 downto 0);
     DataB: in std_logic_vector(15 downto 0);
     Cin: in std_logic;
     Cout: out std_logic;
     Result: out std_logic_vector(15 downto 0));
end component;

signal DataA: std_logic_vector(15 downto 0);
signal DataB: std_logic_vector(15 downto 0);
signal Cin: std_logic;
signal Cout: std_logic;
signal Result: std_logic_vector(15 downto 0);
signal Clock: std_logic := '0';
signal done: std_logic := '0';

constant PERIOD: time := 200 ns;

file vectorin : text is in "test.in";
file out_file : text is out "test_out";

function bb(LL : in character) return std_logic is
  begin
    if LL='1' then
        return '1';
    else
        return '0';
    end if;
end bb;

begin

DUT: add_16_UNSIGNED  port map (
              DataA => DataA,
              DataB => DataB,
              Cin => Cin,
              Cout => Cout,
              Result => Result);
CLK: process
    variable c: std_logic :='0';
 begin
    while (done = '0') loop
          wait for PERIOD/2;
          c := not c;
          Clock <= c;
    end loop;
 end process CLK;

test: process
variable L : line;
variable L1 : line;
begin
while not endfile(vectorin) loop

     readline(vectorin,L);

     DataA(15) <= bb(L(1));
     DataA(14) <= bb(L(2));
     DataA(13) <= bb(L(3));
     DataA(12) <= bb(L(4));
     DataA(11) <= bb(L(5));
     DataA(10) <= bb(L(6));
     DataA(9) <= bb(L(7));
     DataA(8) <= bb(L(8));
     DataA(7) <= bb(L(9));
     DataA(6) <= bb(L(10));
     DataA(5) <= bb(L(11));
     DataA(4) <= bb(L(12));
     DataA(3) <= bb(L(13));
     DataA(2) <= bb(L(14));
     DataA(1) <= bb(L(15));
     DataA(0) <= bb(L(16));
     DataB(15) <= bb(L(17));
     DataB(14) <= bb(L(18));
     DataB(13) <= bb(L(19));
     DataB(12) <= bb(L(20));
     DataB(11) <= bb(L(21));
     DataB(10) <= bb(L(22));
     DataB(9) <= bb(L(23));
     DataB(8) <= bb(L(24));
     DataB(7) <= bb(L(25));
     DataB(6) <= bb(L(26));
     DataB(5) <= bb(L(27));
     DataB(4) <= bb(L(28));
     DataB(3) <= bb(L(29));
     DataB(2) <= bb(L(30));
     DataB(1) <= bb(L(31));
     DataB(0) <= bb(L(32));
     Cin <= bb(L(33));
     wait until ( Clock'event and Clock = '0' );

     write( L1, Result, right,4);

     writeline(out_file,L1);


end loop;

done <= '1';


  assert false report "*** Test Finished ***" severity note;

wait;


end process test;


end simulate;


