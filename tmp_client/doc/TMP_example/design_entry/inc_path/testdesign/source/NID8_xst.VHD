---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--      ENCODER NON-INTEGER DIVIDE MODULE
-- 
--      FOR THE LOW-END CIJ PLATFORM FPGA
--
--      VHDL DESIGN FILE : NID8.VHD	 
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
-- Uses two input numbers - enc_rate(12 bit) and out_rate(8 bit)
-- Output rate = Input rate x out_rate/enc_rate

-- One assumption used here is that the input enc is a single clock tick
-- pulse duration for each encoder edge to be counted.  All quadrature
-- multiplying and clock syncing has already taken place in a previous
-- process.

-- This file latches the carry bit and uses
-- this to control the reload.  Also, previous versions added a carry-in
-- to avoid dividing by zero.  This required software to subtract one
-- from the denominator value.  This version eliminates that possible 
-- confusion.  If a denominator zero is entered, no output pulses will
-- result.

-- Also changed signal naming convention for active low to signal name
-- being preceeded by "N".

-- Modified for use with Synplicity synthesis software.
--
-- NID6.VHD modified to add pipelining to the acc_latch.  This had been a 
-- significant factor in routing dificulties for meeting timing.
	
-- NID7.VHD revised to instantiate a VHDL accumulator within this file.
-- Previously, a 4 bit entity was instantiated 3 times.  This prevents
-- routing optimization of carry logic (speculation).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY nid8 IS
    port(Nreset, enc_tick, mclk : in std_logic;
        enc_rate : in std_logic_vector(11 downto 0);
        out_rate_in : in std_logic_vector(7 downto 0);
        div_enc : out std_logic );
END nid8;


ARCHITECTURE archnid8 OF nid8 IS

	-- This attribute was added due to multiple reset inputs; it was
	-- needed to allow the automatic use of GSR.

	type states is (idle, select_settle1, select_settle2, setup_reload, 
				reload,	end_reload, count_enable, count_settle1, count_settle2,
				latch_next_value);
--	ATTRIBUTE syn_enum_encoding of states:type is "onehot";

	SIGNAL nidstate : states;
	SIGNAL high, low, reset, reload_select, reload_sig,
		acc_latch, co_low, co_mid, co_over, co_over_latch,
		acc_latch_enable : std_logic;

	SIGNAL out_rate, mr : std_logic_vector(11 downto 0);
	SIGNAL tempsumtemp, tempsum, qtemp : std_logic_vector(12 downto 0);

-- b_data register is the latched sum data after
-- each encoder input clock cycle; b_data(12) is the
-- latched carry bit - the output tick.

   BEGIN

    high <= '1';
    low <= '0';
	reset <= not(Nreset);
	out_rate(11 downto 8) <= (others =>'0');
	out_rate(7 downto 0) <= out_rate_in(7 downto 0);

	
------------------- Multiplex Input to Adder ---------------------

mux1:process (Nreset, mclk, reload_select)

	BEGIN

    if(Nreset='0') then
		mr <= (others=>'0');    
	elsif(rising_edge(mclk)) then
		if(reload_select = '1') then
		   mr <= not(enc_rate);
		else
		   mr <= out_rate;
		end if;
	end if;

	END process mux1;

    ------------------- Encoder Rate Divide Process ------------------

    -- The rate divider value N, as in a divide by N counter, is
    -- composed of the ratio of two numbers, 12 bit/8 bit.  These two
    -- nymbers are called the numerator and denominator of the divide
    -- ratio.  Any two correct bit count numbers which describe the desired
    -- ratio can be used to generate the output pulse train.  For
    -- example, if the desired output ratio is 5.333 (5 1/3), the values
    -- binary values for 16 over 3, or 160 over 30 or 64 over 12,
    -- or any other pair with the desired ratio will produce the same 
    -- output rate.

    -- The two's complement of the numerator (output rate) is reloaded
    -- after each overflow, thus the reload_select signal at carry-in
    -- adds one to  the complement of output rate multiplexed in.  The
    -- residue value is retained.  The succeeding counts each cause an 
    -- addition of the numerator value to the accumulating sum until
    -- overflow occurs and the process repeats.

	-- NOTE: When reload_select = '1', the selector, mr, provides
	-- the complement of enc_rate.  Since the carry-in is also
	-- reload_select, the net result is to provide a two's
	-- complement of the encoder rate (numerator).	This is
	-- a key part of generating a modulo (enc_rate) accumulator
	-- system.	With each input pulse, the value of out_rate
	-- (denominator) is added to the accumulator.  When this
	-- addition finally causes an overflow (modulo enc_rate wrap),
	-- the "divided" output pule rate is generated.


--  Generate a 13 bit sum including carry out (tempsum(12)
--  by summing two 13 bit input values plus a carry in bit.
--  qtemp is the 12 bit accumulator register.

	tempsumtemp <= ('0' & mr) + ('0' & qtemp(11 downto 0)) + reload_select;

-- Too many gate prop delays to rely on direct registering into qtemp,
-- which feeds the adder.  Therefore, based on timing simulator results,
-- the register, tempsum, is added; the adder putput is renamed as above.

--	tempsum <= ('0' & mr) + ('0' & qtemp(11 downto 0)) + reload_select;

    accumreg : process(mclk, Nreset, acc_latch)
    BEGIN
    if(Nreset='0') then
        qtemp <= (others=>'0');
        tempsum <= (others=>'0');
    elsif(rising_edge(mclk)) then
		tempsum <= tempsumtemp;
        if(acc_latch='1') then
            qtemp <= tempsum;
        end if;
    end if;
    END process accumreg;


    co_over <= qtemp(12);

	
----------- Divided Encoder Output -------------------

--	div_enc is generated by the div1 state machine 

--------------- NID Control State Machine ----------------

	div1: process (mclk, Nreset, enc_tick, co_over)
	BEGIN
	if(Nreset='0') then
		nidstate <= idle;
		acc_latch <= '0';
        div_enc <= 	'0';
		reload_select <= '1';
    elsif(rising_edge(mclk)) then
		case nidstate is
			when idle =>
                div_enc  <= '0';
				reload_select <= '1';
				nidstate <= select_settle1;

			when select_settle1 =>
                div_enc   <= '0';
				nidstate <= select_settle2;
			
			when select_settle2 =>
				nidstate <= setup_reload;
			
			when setup_reload =>
				acc_latch <= '1'; -- add 2's complement of out_rate_in
				nidstate <= reload;

			when reload =>
				acc_latch <= '0';
				nidstate <= end_reload;

			when end_reload =>
				reload_select <= '0';
				nidstate <= count_enable;

			when count_enable =>
				if(enc_tick='1')  then
					nidstate <= count_settle1;
				else
					nidstate <= count_enable;
				end if;

			when count_settle1 =>
				acc_latch <= '1';
				nidstate <= count_settle2;
				
			when count_settle2 =>
				acc_latch <= '0';
				nidstate <= latch_next_value;
				
			when latch_next_value =>
				if(co_over='1') then 
	                div_enc  <= '1';
					reload_select <= '1';
					nidstate <= select_settle1;
				else
					nidstate <= count_enable;
				end if;

				
			when others =>
				nidstate <= idle;
		end case;
	end if;
	END process div1;

END archnid8;

