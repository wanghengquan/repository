---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--      GENERAL INTERRUPT LOGIC CONTROL MODULE
-- 
--      FOR THE LOW-END CIJ PLATFORM FPGA
--
--      VHDL DESIGN FILE :GENINT8.VHD
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
-- This package describes interrupt logic for several general peripheral
-- devices of the Image Processor.  For each case, interrupts are
-- enabled by writing a 1 to the datain port for the corresponding bit.  
-- Writing a 0 disables interrupts and clears any existing interrupt or
-- flag bits.

-- Output signals include the interrupt and flag signals. 
-- If a 2nd interrupt trigger edge occurs before flag clear, an
-- interrupt overlap fault is latched.
-- 
-- The interrupt logic state machine, intstate2, is instantiated as
-- the central component of the each section interrupt logic.  It has
-- been revised to include interrupt trigger even if input is already
-- true when enabled or previous interrupt cleared.
--
-- The logic in intstate2 is replaced by intstate3 which deals with
-- the problem of syncronizing the intr and flag clear signals.
--
-- GENINT5M.VHD further simplifies the intr state machine logic
-- by converting to state decoding for outputs; this is to reduce
-- the PFU (cell) count of the design.
--
-- GENINT6.VHD changes the enable input to assume a registered
-- enable/disable bit externally latched outside this module.  Thus,
-- the input ports are revised.

-- Modified for use with Synplicity synthesis software.

-- GENINT8.VHD changed BUFFER type output to type OUT.

library ieee;
use ieee.std_logic_1164.all;

--library synopsys;  -- used by Active CAD
--use synopsys.std_logic_arith.all;
--use synopsys.std_logic_unsigned.all;

--library metamor;
--use metamor.attributes.all;

ENTITY intstate4 IS PORT(				   
		mclk, edge_in, enable_in, intr_clr, flag_clr,
		Nreset : in std_logic;
		intr_enabled, intr_flag, set_overlap_fault, intr : out std_logic);
END intstate4;


ARCHITECTURE archintstate4 OF intstate4 IS

    TYPE gintstates IS (idle, enabled, interrupt, flag);

--    ATTRIBUTE syn_encoding of gintstates:type is "onehot";

    SIGNAL state : gintstates;

	SIGNAL intrclr_del1, intrclr_del2, flagclr_del2,
		flagclr_del1, flagclr_del : std_logic;

    --attribute FPGA_gsr: boolean;
    --attribute FPGA_gsr of Nreset:signal is true; -- routed using GSR.
                                                 -- (active low)
BEGIN

----- This unit assumes that the edge_in signal is one clock tick
----- in duration from a seperate module in the same PLD running on
----- the same exact clock.

	sync4 : process (mclk, Nreset)
	BEGIN

	if(Nreset='0') then
--		flagclr_del1 <= '0';
		flagclr_del2 <= '0';
--		intrclr_del1 <= '0';
		intrclr_del2 <= '0';

	  elsif(rising_edge(mclk)) then
		intrclr_del2 <= intr_clr;
--		intrclr_del2 <= intrclr_del1;
		flagclr_del2 <= flag_clr;
--		flagclr_del2 <= flagclr_del1;

      end if;
    END process sync4;

    intr4 : process (mclk, Nreset)
	BEGIN

	  if(Nreset='0') then
	    state <= idle;

	  elsif(rising_edge(mclk)) then
	    case state is

	      when idle =>
            if(enable_in='1') then
             	state <= enabled;
            end if;

          when enabled =>
            if(enable_in='0') then
             	state <= idle;
            elsif(edge_in='1') then
             	state <= interrupt;
            end if;

          when interrupt =>
            if(enable_in='0') then
             	state <= idle;
            elsif(intrclr_del2='1') then
             	state <= flag;
            elsif(flagclr_del2='1') then
             	state <= enabled;
            end if;

          when flag =>
            if(enable_in='0') then
             	state <= idle;
            elsif(flagclr_del2='1') then
             	state <= enabled;
            end if;

          when others =>
             	state <= idle;

        end case;
      end if;
    END process intr4;

    intr_enabled <= '0' when(state=idle) else '1'; 
	intr <= '1' when(state=interrupt) else '0';
	intr_flag <= '1' when(state=interrupt OR state=flag) else '0';
    set_overlap_fault <= '1' when(state=flag AND edge_in='1') else '0';

END archintstate4;


library ieee;
use ieee.std_logic_1164.all;

--library metamor;
--use metamor.attributes.all;

ENTITY intreq2 IS PORT(
		mclk, Nreset, intr_input, enable_in,
		intr_clr, flag_clr : in std_logic;
		intr_enabled, intr_flag, set_overlap_fault, intr : out std_logic);
END intreq2;

ARCHITECTURE archintreq2 OF intreq2 IS

	SIGNAL intrdel1, intrdel2, intr_edge_tick, intr_enabled_temp, intr_temp : std_logic;

COMPONENT intstate4 PORT(
		mclk, edge_in, enable_in, intr_clr, flag_clr,
		Nreset : in std_logic;
		intr_enabled, intr_flag, set_overlap_fault, intr : out std_logic);
END COMPONENT;

    --attribute FPGA_gsr: boolean;
    --attribute FPGA_gsr of Nreset:signal is true; -- routed using GSR.
                                                 -- (active low)
BEGIN

	intr_edge_sense : process (mclk, Nreset)
	BEGIN

    if(Nreset='0') then
	    intrdel1 <= '0';
	    intrdel2 <= '0';
		intr_edge_tick <= '0';
	elsif(rising_edge(mclk)) then
		intrdel1 <= intr_input AND intr_enabled_temp AND not(intr_temp);
	 	intrdel2 <= intrdel1;
    	intr_edge_tick <= intrdel1 AND not(intrdel2); -- pos transition
	end if;
    END process intr_edge_sense;

	intr1: intstate4 PORT MAP(				   
		mclk, intr_edge_tick, enable_in, intr_clr, flag_clr,
		Nreset, intr_enabled_temp, intr_flag, set_overlap_fault, intr_temp);

	intr <= intr_temp;
	
	intr_enabled <= intr_enabled_temp;
	
END archintreq2;

