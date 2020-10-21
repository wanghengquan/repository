---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--      ENCODER SIGNAL PROCESSING MODULE
-- 
--      FOR THE LOW-END CIJ PLATFORM FPGA
--
--      VHDL DESIGN FILE :ENCODR9.VHD
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
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- The shaft encoder input consists of two signals from a quadrature output
-- shaft encoder.  Each input is double buffered to synchronize it with
-- a high speed clock.  A 4 to 1 "multiply" is devised so as to produce a
-- "tick" for each transition of either input ENCA or ENCB.  The logic also
-- includes backlash compensation so as to eliminate unwanted output pulses
-- if a substrate backs up for a limited distance during normal motion.  The
-- normal direction then is a required input.

-- The intended shaft direction is input a "dir_in".  Normally, dir_out, the
-- direction sensed by the encoder tracking logic, should match.  If the
-- shaft direction reverses, the reverse pulses are counted.  No "tick"
-- pulses are output until the shaft count returns to the point of reversal.
-- The "dir_invert" signal inverts the sense or definition of the forward
-- direction.  Normal forward is considered as ENCA leading ENCB.  For
-- applications where forward is defined as ENCA lags ENCB, the dir_invert
-- input should be set to 1.  Then the logic inverts the ENCA signal to
-- restore the normal internal waveform forward relationship, where
-- ENCA(internal) leads ENCB(internal).

-- The qdrtr_enable input controls whether or not the encoder signal is
-- interpreted as a 2 channel quadrature encoder or a single channel type.
-- If signal=0, any channel pulses on whichever channel is connected, are
-- accepted and trigger encoder ticks.  No direction sensing is possible.

-- The backlash clear input can be used to clear the backlash counter.  The
-- intent is to allow sofware control of cancelation of accumulated backlash
-- that may be invalidated.  Similarly, the encoder clear signal allows
-- the clearing of any error pulses that result from set-up direction select
-- changes.  Mainly, it normalizes the encoder input delay stages.

-- OENCODR3.VHD revised to restate the encoder state machine with logic
-- using CASE instead of nested IF THEN.

-- OENCODR4.VHD uses 12 bit  ctr instead of 20 bit for backlash.

-- OENCODER7.VHD eliminates the "error" state and instead ignores double
-- changes - enca and encb changing at the same time.

-- OENCODERB.VHD has reduced encoder states and omits seperate encoder reset.

-- ENCODR4M.VHD uses the processor clock, mclk, instead of clk16mh
-- for all syncronous logic.

-- ENCODR5M.VHD increases backlash to 16 bits and adds a new signal which 
-- indicates when the backlash range has been exceeded.

-- ENCODR6.VHD changed signal naming convention for active low to signal
-- name being preceeded by "N".

-- Modified for use with Synplicity synthesis software.

-- ENCODR7.VHD modified to correct the non-quadrature operation to
-- generate only one encoder tick per encoder input cycle.  Channel
-- A is assumed and channel B is ignored.  Also, revisions to the
-- error count direction and enable control were made for more 
-- accurate tracking under varying direction control circumstances.

-- ENCODR8.VHD modified to correct error in backlash limit when
-- traveling in the "reverse" direction.

library ieee;
use ieee.std_logic_1164.all;

library synplify;
use synplify.attributes.all;

--library metamor;
--use metamor.attributes.all;

ENTITY encoder9 IS
     port(mclk, Nreset, enca_in, encb_in, dir_in, dir_invert,
		  qdrtr_enable, backlash_clr : in std_logic;
		  enc_tick, dir_out, err_tick, count_zero,
          backlash_max : out std_logic );
END encoder9;


ARCHITECTURE archencoder9 OF encoder9 IS

	type states is (idle, nanb, anb, ab, nab);

	ATTRIBUTE syn_enum_encoding of states:type is "onehot";

	SIGNAL encstate : states;

	SIGNAL reset, Nreset_enc, Nreset_bk, dir, count_dir, enc_dir,
            bl1, bl2, count_en, countlimit, encadel1, encadel2, encadel3,
            enca, encbdel1, encbdel2, encbdel3, encb, encachain_high,
            encachain_low, enca_stable, encbchain_high, encbchain_low,
            encb_stable, backlash_ctr_tick, zero_dir_up, zero_dir_dn,
            enca_eq1, enca_eq0, encb_eq1, encb_eq0, tick, tick_a,
            errtick, enctick, quad_enctick, quad_enc_tick, Ndir_match,
            dir_match, countzero, Nresetbk, err_tick_temp,
			backlash_max_temp, count_zero_temp : std_logic;

    ATTRIBUTE syn_keep of errtick, enctick, countlimit : SIGNAL IS true;

	SIGNAL backcount, backlash : std_logic_vector(15 downto 0);

    SIGNAL transition : std_logic_vector(3 downto 0);
    SIGNAL encoder : std_logic_vector(1 downto 0);

COMPONENT updncnt16
	port(en, upidn, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(15 downto 0));
END COMPONENT;

    --attribute FPGA_gsr: boolean;
    --attribute FPGA_gsr of Nreset:signal is true; -- routed using GSR.
                                                 -- (active low)
    BEGIN

    reset <= not(Nreset);

--    Nresetbk <= not(reset) AND not(backlash_clr) AND qdrtr_enable;
    Nresetbk <= not(backlash_clr) AND qdrtr_enable;


    backreset : process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        Nreset_bk <= '0';
    elsif(rising_edge(mclk)) then
        Nreset_bk <= Nresetbk;
    end if;
    END process backreset;





    dir <= dir_in;

    dir_out <= enc_dir;

------------------- ENCODER FILTERING & NORMALIZING --------------------

    enca_eq1 <= encadel2 AND encadel1;     -- Allows simplification of the
    enca_eq0 <= not(encadel2 OR encadel1); -- process logic; i.e. less cells.
    encb_eq1 <= encbdel2 AND encbdel1 AND qdrtr_enable; -- suppress if no
    encb_eq0 <= not(encbdel2 OR encbdel1);              -- quadrature selected

	encafilter:process (Nreset, mclk)
	BEGIN
		if(Nreset='0') then
			encadel3 <= '0';
			encadel2 <= '0';
			encadel1 <= '0';
			enca <= '0';
	  	elsif(rising_edge(mclk)) then		
			encadel3 <= (enca_in);
			encadel2 <= encadel3;          -- 2 stage digital filter,
			encadel1 <= encadel2;          -- where input must be same
			if(enca_eq1='1') then          -- for 2 clocks before change
				enca <= not(dir_invert);   -- passes through.
			elsif (enca_eq0='1') then
				enca <= dir_invert; -- dir_invert sets "forward" = A leads B
			end if;
	  	end if;
    END process;


	encbfilter:process (Nreset, mclk)
	BEGIN
		if(Nreset='0') then
			encbdel3 <= '0';
			encbdel2 <= '0';
			encbdel1 <= '0';
			encb <= '0';
	  	elsif(rising_edge(mclk)) then      -- 2 stage digital filter, where
			encbdel3 <= encb_in;           -- input must be same for 2 clocks
			encbdel2 <= encbdel3;          -- before change passes through.
			encbdel1 <= encbdel2;
			if(encb_eq1='1') then
				encb <= '1';
			elsif (encb_eq0='1') then
				encb <= '0';
			end if;
	  	end if;
    END process;

------------------------ Backlash Counter Logic ------------------------

--    count_limit <= '1' when (backlash="10000000000000000000") else '0';
-- Next statement uses less logic and can't be fooled by exceeding the limit

    -- count down when commanded direction is opposite of sensed direction;
    -- count up when commanded direction is the same as the sensed direction.

    -- The amount of backlash provided is 32768 + 16384 + 8192
    -- + 4096 + 2048 (+1 if forward) which equals 
    -- 63,488 or 63,489 counts depending on direction.

    countlimit <= '1' when (
        backlash(15)='0' AND backlash(14)='0' AND backlash(13)='0'
         	AND backlash(12)='0' AND backlash(11)='0' AND backlash(10)='1')
         else '0';          

	Ndir_match <= enc_dir XOR dir; -- low when sensed encoder direction matches
								   -- requested direction.
        dir_match <= not(Ndir_match);
			 
    -- Lucent up/down ctrs. need invert for down at carry input;
    -- This change added when ctr. control changed to apply
    -- count pulses to the enable input instead of the Carry Input.

    -- Invert Cin (a Lucent counter requirement) to enable counting down.
	-- Thus, Cin (count_en) must be 0 to count down; it must be 1 to count up.
	
    count_dir <= not(Ndir_match);
    -- i.e. count down when sensed dir is mismatched.  

    count_en <= Ndir_match XOR (not(backlash_max_temp AND Ndir_match));

    -- count_en connects to Cin of ORCA counter; 1 for up, 0 for down to enable cnt.
	-- inhibit further error counting if at count limit AND encoder direction
	-- not the same as requested direction.  Note that count is inhibited
	-- by forcing count_en to the opposite state as count_dir.

    countzero <= '1' when (backlash="0000000000000000") else '0';

    errtick <= qdrtr_enable AND (Ndir_match OR not(count_zero_temp))
                AND tick;

    quad_enctick <= not(enc_dir XOR dir_in) AND count_zero_temp AND tick;


    ticksync1 : process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        enc_tick <= '0';
    elsif(rising_edge(mclk)) then
        if(qdrtr_enable='1') then
            enc_tick <= quad_enc_tick;
        else
            enc_tick <= tick_a;
        end if;
    end if;
    END process ticksync1;


    ticksync2 : process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        err_tick_temp <= '0';
        count_zero_temp <= '0';
        quad_enc_tick <= '0';
        backlash_max_temp <= '0';
    elsif(rising_edge(mclk)) then
        err_tick_temp <= errtick;
        count_zero_temp <= countzero;
        quad_enc_tick <= quad_enctick;
        backlash_max_temp <= countlimit;
    end if;
    END process ticksync2;
	
	count_zero <= count_zero_temp;
	err_tick <= err_tick_temp;
	backlash_max <= backlash_max_temp;
	
--------------------------- BACKLASH COUNTER ---------------------------

--    backlash1: updncnt16
--    port map(en=>count_en, upidn=>count_dir, clk=>mclk,
--        cin=>backlash_ctr_tick, Nreset=>Nreset_bk, co=>open, q=>backlash);

-- Testing a more accurate turnaround logic by using the previous
-- Carry input as the count enable and the previous count enable as
-- the carry input.  This may have a minor affect on providing more
-- accurate accounting during direction turn around.

    backlash1: updncnt16
    port map(en=>err_tick_temp, upidn=>count_dir, clk=>mclk,
        cin=>count_en, Nreset=>Nreset_bk, co=>open, q=>backlash);


-------------------- ENCODER/BACKLASH STATE MACHINE --------------------

-- In this system, when encoder channel A leads channel B, the direction
-- is considered "forward" and enc_dir =0.  The direction-invert bit is
-- used to convert signals to this convention when the shaft encoder
-- installation causes A to lag B when the conveyor runs "forward.  So,
-- with the direction invert bit set properly, A still leads B when
-- going forward.

    transition(3) <= enca;  -- used to simplify decoding of error state
    transition(2) <= encadel1;      -- exit transitions
    transition(1) <= encb;
    transition(0) <= encbdel1;

--	encachain_high <= (encadel1 AND encadel2 AND encadel3);
--	encachain_low <= not(encadel1 OR encadel2 OR encadel3);
--	enca_stable <= encachain_high OR encachain_low;
	
--	encbchain_high <= (encbdel1 AND encbdel2 AND encbdel3);
--	encbchain_low <= not(encbdel1 OR encbdel2 OR encbdel3);
--	encb_stable <= encbchain_high OR encbchain_low;

	encoder <= enca & encb;  -- concatinate encoder channels for
                             -- evaluation in case statements.

	
	enclogic1: process (mclk, Nreset)
	BEGIN
	if(Nreset='0') then     -- Enc_tick is a legitimate encoder pulse in
                            -- the selected direction when backlash error
		encstate <= idle;   -- is zero.  Err_tick is an encoder pulse while
		tick <= '0';        -- the backlash error is non-zero, whether
        enc_dir  <= '0';    -- going in the selected or the opposite
                            -- direction.  Noise_tick is an attempt to
                            -- monitor and reject erroneous signals,
                            -- i.e. noise on encoder channels A or B, and
                            -- thus also not miscount these as backlash
                            -- increments.
		tick_a <= '0';
	elsif(rising_edge(mclk)) then
		case encstate is

			when idle =>
            tick <= '0';     -- tick used for quadrature application
            tick_a <= '0';   -- tick_a used for single channel apps. where
			enc_dir  <= '0'; -- only one pulse is output per encoder cycle.

            CASE encoder IS
                WHEN "00" =>
					encstate <= nanb;
                WHEN "10" =>
					encstate <= anb;
                WHEN "01" =>
					encstate <= nab;
                WHEN "11" =>
					encstate <= ab;
                WHEN others =>
					encstate <= idle;

                END CASE;

			when nanb =>
            tick <= '0';

            CASE encoder IS
                WHEN "10" =>
						encstate <= anb;
						enc_dir <= '0';
						tick_a <= '1';
						tick <= '1';

                WHEN "01" =>
						encstate <= nab;
						enc_dir <= '1';
						tick <= '1';

                WHEN "00" =>
					encstate <= nanb;

                WHEN "11" =>
					encstate <= nanb;

                WHEN others =>
					encstate <= nanb;

                END CASE;

			when anb =>
            tick <= '0';
			tick_a <= '0';

            CASE encoder IS
                WHEN "00" =>
						encstate <= nanb;
						enc_dir <= '1';
						tick <= '1';

                WHEN "11" =>
						encstate <= ab;
						enc_dir <= '0';
						tick <= '1';

                WHEN "10" =>
					encstate <= anb;

                WHEN "01" =>
					encstate <= anb;

                WHEN others =>
					encstate <= anb;

                END CASE;

			when ab =>
            tick <= '0';
			tick_a <= '0';

            CASE encoder IS
                WHEN "01" =>
						encstate <= nab;
						enc_dir <= '0';
						tick <= '1';

                WHEN "10" =>
						encstate <= anb;
						enc_dir <= '1';
						tick <= '1';

                WHEN "11" =>
					encstate <= ab;

                WHEN "00" =>
					encstate <= ab;

                WHEN others =>
					encstate <= ab;

                END CASE;

			when nab =>
            tick <= '0';

            CASE encoder IS
                WHEN "00" =>
						encstate <= nanb;
						enc_dir <= '0';
						tick <= '1';

                WHEN "11" =>
						encstate <= ab;
						enc_dir <= '1';
						tick <= '1';

                WHEN "01" =>
					encstate <= nab;

                WHEN "10" =>
					encstate <= nab;

                WHEN others =>
					encstate <= nab;

                END CASE;

			when others =>
				encstate <= idle;

		end case;
	end if;
	END process enclogic1;

END archencoder9;

