---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--      ENCODER SPEED MEASUREMENT LOGIC MODULE
-- 
--      FOR THE LOW-END CIJ PLATFORM FPGA
--
--      VHDL DESIGN FILE :SPEED8.VHD
--
--      by: M. Stamer
--      VIDEOJET TECHNOLOGIES INC.
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------
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
-- This module measures substrate speed by counting undivided
-- encoder pulses for a fixed amount of time.  At the end of
-- each measurement interval, the total count is latched, the
-- counter is cleared and the process repeats.  The processor
-- can read the latched value at any time to get the current
-- speed.  

-- The interval is set for 0.1 sec.  The counter and latch
-- resolution is 16 bits.  The process measurement is controlled
-- by a state machine.
 
-- This file used in a system where all logic is clocked by the processor
-- derived mclk (20MHz).

-- SPEED3M.VHD brings out one of the time interval divider stages
-- for use as a low speed pulse waveform (100 msec.).

-- SPEED4.VHD changed signal naming convention for active low to signal name
-- being preceeded by "N".

-- Modified for use with Synplicity synthesis software.

-- SPEED5.VHD modified state machine to include start control in an
-- attempt to reduce design size.

-- SPEED7.VHD was modified to use a 50 msec. time base instead of 100 msec.  
-- Also, the speed measurement counter will now self-limit at max count
-- instead of rolling over.	
--
-- SPEED8.VHD added a significant feature - speed limit detection.  This
-- will be used in the Videojet 1000 to optionally switch from external
-- to internal encoding once encountered.  Also a bit is set to indicate
-- that the limit was detected.

library ieee;
use ieee.std_logic_1164.all;

library synplify;
use synplify.attributes.all;

--library synopsys;  -- used by Active CAD
--use synopsys.std_logic_arith.all;
--use synopsys.std_logic_unsigned.all;

ENTITY speed8 IS
    PORT(mclk, Nreset, enc_tick, clk2kh_tick, overspeed_detect_enable, 
		overspeed_reset : in std_logic;
		speed_limit : in std_logic_vector(15 downto 0);
        speed_data : out std_logic_vector(15 downto 0);
        limit_detectff : out std_logic);
END speed8;                         

ARCHITECTURE archspeed8 OF speed8 IS

    SIGNAL high, col, coh, Nspeed_clr, interval_done, speed_latch,
	not_speed_max, speed_compare_en, overspeed_ff, speed_compare_bit, 
	speed_compare_ff, speed_compare_del : std_logic;

    SIGNAL speed_count, speed_data_temp : std_logic_vector(15 downto 0);
    SIGNAL int_count : std_logic_vector(7 downto 0);

    TYPE speedstates IS (idle, measure, latch, latch_settle, speed_limit_test);
--    ATTRIBUTE syn_enum_encoding of speedstates:type is "onehot";

    SIGNAL speedstate : speedstates;

COMPONENT upcnt8
	port(en, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(7 downto 0));
END COMPONENT;

COMPONENT enreg16
	port(d : in std_logic_vector(15 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(15 downto 0));
END COMPONENT;

--    attribute FPGA_gsr: boolean;
--    attribute FPGA_gsr of Nreset:signal is true; -- routed using GSR.
                                                 -- (active low)

	-- This attribute was added due to multiple reset inputs; it was
	-- needed to allow the automatic use of GSR.

BEGIN

	high <= '1';

    ------------- Encoder Counter ----------------

    -- Count the number of encoder ticks which occur in an interval
    -- of 50 msec.

    spdctr_msb : upcnt8
	port map(not_speed_max, mclk, col, Nspeed_clr,
         coh, speed_count(15 downto 8));

    spdctr_lsb : upcnt8
	port map(not_speed_max, mclk, enc_tick, Nspeed_clr,
         col, speed_count(7 downto 0));

    not_speed_max <= '0' when(coh='1' AND col='1') else '1';

    ------------- Interval Counter ----------------

    interval_ctr : upcnt8
	port map(high, mclk, clk2kh_tick, Nspeed_clr,
         open, int_count);

    -- decode count of 100 for an interval of 50 msec.

    interval_done <= int_count(6) AND int_count(5) AND int_count(2);

    ------------- Speed Capture Process ----------------

    spd_meas_ctrl : process (mclk, Nreset)

    BEGIN

    if(Nreset='0') then
        speedstate  <= idle;
        Nspeed_clr  <= '0';
        speed_latch <= '0';
		speed_compare_en <= '0';
    elsif(rising_edge(mclk)) then
        case speedstate is
            when idle =>
                speed_compare_en <= '0';
                speed_latch <= '0';
                Nspeed_clr <= '0';
                if(clk2kh_tick='1') then   -- Wait for next .5msec. tick
                    Nspeed_clr <= '1';     -- to get an exact measurement
                    speedstate <= measure; -- time interval of 50 msec.
                end if;
                    
            when measure =>
                if(interval_done='1') then
                    speedstate <= latch;
                    speed_latch <= '1';
                end if;

            when latch =>                   -- Hold latch for added insurance
                speedstate <= latch_settle; -- that value is latched

            when latch_settle =>
                speed_latch <= '0';
                Nspeed_clr <= '0';
                speedstate <= speed_limit_test;
				
			when speed_limit_test =>
                speed_compare_en <= '1';
                speedstate <= idle;

            when others => 
                speedstate <= idle;
          end case;
    end if;
    END process spd_meas_ctrl;


    ------------- Speed Data Latch ----------------

    speed_register: enreg16
	port map(speed_count, speed_latch, mclk, Nreset, speed_data_temp);

	speed_data <= speed_data_temp;
	
    ------------- Speed Compare Process ----------------
	
	speed_compare_bit <= '1' when(speed_data_temp >= speed_limit) else '0'; 
	
    spd_compare : process (mclk, Nreset, speed_compare_en, speed_compare_bit)

    BEGIN

    if(Nreset='0') then
        speed_compare_ff <= '0';
        speed_compare_del <= '0';
        overspeed_ff <= '0';
    elsif(rising_edge(mclk)) then
		speed_compare_del <= speed_compare_bit;	-- latch to simplfy comparator logic
		if(speed_compare_en='1' AND overspeed_detect_enable='1' 
				AND speed_compare_del = '1') then -- speed > or = limit
		    overspeed_ff <= '1';	 -- stays set until software clears bit
		elsif(overspeed_reset='1' OR overspeed_detect_enable='0') then
		   overspeed_ff <= '0';
		end if;
	end if;
	end process spd_compare;
	
	limit_detectff <= overspeed_ff;

END archspeed8;


