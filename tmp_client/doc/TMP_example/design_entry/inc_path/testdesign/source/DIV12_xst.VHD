---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--      ENCODER INTEGER DIVIDE MODULE
-- 
--      FOR THE LOW-END CIJ PLATFORM FPGA
--
--      VHDL DESIGN FILE :DIV12.VHD	 
--							
--		by: M. Stamer
--      VIDEOJET TECHNOLOGIES INC.
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--
-------------------------------------------------------------------------------
--
-- Copyright 2002 Videojet Technologies Inc. All Rights Reserved. 
--
-- An unpublished work of Videojet Technologies Inc. The software and 
-- documentation contained herein are copyrighted works which include 
-- confidential information and trade secrets proprietary to Videojet 
-- Technologies Inc. and shall not be copied, duplicated, disclosed or used, 
-- in whole or in part, except pursuant to the License Agreement or as 
-- otherwise expressly approved by Videojet Technologies Inc.
--
-------------------------------------------------------------------------------
--
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- This module performs a pulse rate divide by an integer amount.  The
-- inputs include an input pulse train and a 12 bit registered
-- input of the divide down number.  This is used as the reload number
-- for a down counter.  Each overflow produces an output pulse.

-- One assumption used here is that the input enc is a single clock tick
-- pulse duration for each encoder edge to be counted.  All quadrature
-- multiplying and clock syncing has already taken place in a previous
-- process.

-- Also changed signal naming convention for active low to signal name
-- being preceeded by "N".

-- Modified for use with Synplicity synthesis software.

-- Div12.vhd cleaned up text, deleted some unused signals.  To clarify
-- this function, the output is a single clock tick wide pulse.

library ieee;
use ieee.std_logic_1164.all;

--library synopsys;  -- used by Active CAD
--use synopsys.std_logic_arith.all;
--use synopsys.std_logic_unsigned.all;

--library metamor;
--use metamor.attributes.all;

       
ENTITY divide12 IS
    port(Nreset, enc_tick, mclk, inhibit : in std_logic;
        divider : in std_logic_vector(11 downto 0);
        div_enc : out std_logic );
END divide12;


ARCHITECTURE archdivide12 OF divide12 IS

COMPONENT lddncnt4
	port(d : in std_logic_vector(3 downto 0);
		 en, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(3 downto 0));
END COMPONENT;

	type states is (idle, reload, end_reload, count_enable);
--	ATTRIBUTE syn_enum_encoding of states:type is "onehot";

	SIGNAL divstate : states;
	SIGNAL high, low, reset, reload_select, reload_sig,
    set_reload_sig, clear_reload_sig, div_clear, not_count_en,
    count_en, co, co_1, co_2, count_at_zero : std_logic;
    SIGNAL ctr : std_logic_vector(11 downto 0);

    --attribute syn_keep of co_1, co_2, count_at_zero : SIGNAL IS true;

    --attribute FPGA_gsr: boolean;
    --attribute FPGA_gsr of Nreset:signal is true; -- routed using GSR.
                                                 -- (active low)
   BEGIN

    high <= '1';
    low <= '0';
	reset <= not(Nreset);

--------------- Divider Control State Machine ----------------

	div_clear <= reset OR inhibit;

	divctrl: process (mclk, div_clear)
	BEGIN
	if(div_clear='1') then
		divstate <= idle;
--		reload_sig <= '0';
--		count_en <= '0';
    elsif(mclk'event AND mclk='1') then
		case divstate is
			when idle =>
				divstate <= reload;
--				reload_sig <= '0';
--				count_en <= '0';

			when reload =>
				divstate <= end_reload;
--				reload_sig <= '1';

			when end_reload =>
				divstate <= count_enable;
--				count_en <= '1';
--				reload_sig <= '0';

			when count_enable =>
				if(count_at_zero='1')  then -- used instead of CO so 
				--if(co = '0')  then    -- that software programs N, not N-1;
					divstate <= reload; -- Lucent down counter uses
--					count_en <= '0';    -- active low carry in and out
				end if;

			when others =>
				divstate <= idle;
		end case;
	end if;
	END process divctrl;

	reload_sig <= '1' when (divstate=reload) else '0';
	count_en <= '1' when (divstate=count_enable) else '0';

    div_enc <= reload_sig;

--	count_at_zero <= '1' when(ctr="000000000000") else '0';
	count_at_zero <= '1' when(co='0') else '0';

    not_count_en <= not(count_en);

    div1 : lddncnt4
	port  map(divider(11 downto 8),
		 enc_tick, reload_sig, mclk, co_2, Nreset,
         co, ctr(11 downto 8));

    div2 : lddncnt4
	port  map(divider(7 downto 4),
		 enc_tick, reload_sig, mclk, co_1, Nreset,
         co_2, ctr(7 downto 4));

    div3 : lddncnt4
	port  map(divider(3 downto 0),
		 enc_tick, reload_sig, mclk, not_count_en, Nreset,
         co_1, ctr(3 downto 0));

END archdivide12;

