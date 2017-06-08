---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--      PRODUCT DETECT CONTROL MODULE
-- 
--      FOR THE LOW-END CIJ PLATFORM FPGA
--
--      VHDL DESIGN FILE :PROD11.VHD
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
-- This package describes product detect interrupt logic for a single product
-- detect input.  Inputs are provided for polarity invert control and
-- selection of lead edge or trail edge triggering.  Product detection
-- is enabled by writing a 1 to the datain port.  Writing a 0 disables
-- detection of products and clears any existing interrupt or flag bits.
-- The PD signal is filtered by 3 stage synchronizing logic.  This logic
-- clocks based on the selected encoder tick input.

-- Output signals include the PD interrupt and flag, the filtered, polarity-
-- normalized Product Detect output, the product detect edge tick that was
-- selected plus PD overlap fault and bounce warning signal.  The difference
-- relates to relative timing of successive PD edges compared to timing
-- of the interrupt routine.  If a 2nd edge occurs before the 1st edge 
-- interrupt is cleared, a bounce warning is latched.  If a 2nd edge occurs
-- after interrupt clear but before flag clear, a product print overlap
-- fault is latched.
-- 
-- The interrupt logic state machine, intstate, is instantiated as the central
-- component of the product detect interrupt logic as well as the print
-- request interrupt logic.
--
-- The Print Request logic generates print request interrupts based on input 
-- pulses from the Capture and Compare logic.  This is controlled by software
-- so as to track product detect events and print head delays in a software 
-- FIFO, coordinating with a central "selected encoder tick" counter.  This
-- counter can either be located in the same FPGA or external hardware.  In
-- this case, it will be contained in an external "8051FA" type processor
-- which contains an array of counters which will be used for this purpose.
--
-- PROD2.VHD is modified from PROD1.VHD to convert to state decoding
-- for outputs; this is to reduce the PFU (cell) count of the design.
--
-- This file used in a system where all logic is clocked by the processor
-- derived mclk (20MHz).
--
-- PROD4M.VHD reduces complexity by using state decoding in INTSTATE
-- to generate outputs instead of synchronous state outputs.
--
-- PROD5M.VHD revised to assume a register input for interrupt enable.

-- PROD6.VHD changed signal naming convention for active low to signal name
-- being preceeded by "N".

-- Modified for use with Synplicity synthesis software.

-- PROD7.VHD adds the form of prod module that generates an interrupt on both 
-- edges of the input signal.  The new entity is PROD3; PROD2 is the same as
-- before.This was added to accomodate new iologic requirements.  Also
-- simplified INTSTATE by realizing that intr and flag clear inputs do not
-- need to be clock synced; they already are.

-- PROD8.VHD revised the filtering of product detect inputs to add a
-- third filter stage.  This yields a filter time base of 2 to 3 filter
-- clock ticks, instead of 1 to 2.

-- PROD9.VHD adds another PROD4 entity, which is used for more precise
-- triggering of the main product detect input.  Whereas PROD2 had been 
-- used for this, it had a filtered output which exhibits timing variation
-- due to the free-running filter clock.  PROD4 starts a filter time 
-- interval as before, but assumes a higher frequency filter clock and
-- uses an additional filter clock cycle for each PD edge.

-- PROD11.VHD converted all BUFFER type outputs to type OUT.
library ieee;
use ieee.std_logic_1164.all;

library synplify;
use synplify.attributes.all;


ENTITY intstate1 IS				   
    PORT(mclk, edge_in, enable_in, intr_clr, flag_clr,
		Nreset : in std_logic;
		set_overlap_fault, set_bounce_warning,
		int_flag, intr : out std_logic);
END intstate1;


ARCHITECTURE archintstate1 OF intstate1 IS

    TYPE states IS (idle, enabled, interrupt, flag);
--      ATTRIBUTE syn_enum_encoding of states:type is "onehot";

    SIGNAL state : states;

	SIGNAL intrclr_del1, intrclr_del2,
		flagclr_del1, flagclr_del2 : std_logic;

	--ATTRIBUTE syn_keep of set_overlap_fault, set_bounce_warning
     --   : SIGNAL is true;

    --attribute FPGA_gsr: boolean;
    --attribute FPGA_gsr of Nreset:signal is true; -- routed using GSR.
                                                 -- (active low)
BEGIN

----- Edge detection not necessary when intstate is in same device 
----- and uses the same clock as prreq or prod.  This unit assumes
----- that the edge_in signal is one clock tick induration from a
----- seperate module in the same PLD running on the same exact clock.

--	sync4 : process (mclk, Nreset)
--	BEGIN
--
--	if(Nreset='0') then
--		flagclr_del2 <= '0'; -- Used to resync clear signals in case
--		intrclr_del2 <= '0'; -- generated based on a different clock.
--	  elsif(rising_edge(mclk)) then
--		intrclr_del2 <= intr_clr;
--		flagclr_del2 <= flag_clr;
--      end if;
--    END process sync4;


    intr1 : process (mclk, Nreset, enable_in, edge_in)
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
            elsif(intr_clr='1') then
             	state <= flag;
            end if;

          when flag =>
            if(enable_in='0') then
             	state <= idle;
            elsif(flag_clr='1') then
             	state <= enabled;
            end if;

          when others =>
             	state <= idle;

        end case;
      end if;
    END process intr1;

	int_flag <= '1' when(state=interrupt OR state=flag) else '0';
	intr <= '1' when(state=interrupt) else '0';
    set_overlap_fault <= '1' when(state=flag AND edge_in='1') else '0';
    set_bounce_warning <= '1' when(state=interrupt AND edge_in='1') else '0';

END archintstate1;


library ieee;
use ieee.std_logic_1164.all;

library synplify;
use synplify.attributes.all;


ENTITY intstate2 IS				   
    PORT(mclk, edge_in, enable_in, intr_clr, flag_clr,
		Nreset : in std_logic;
--		set_overlap_fault, set_bounce_warning,
		int_flag, intr : out std_logic);
END intstate2;


ARCHITECTURE archintstate2 OF intstate2 IS

    TYPE states IS (idle, enabled, interrupt, flag);
--      ATTRIBUTE syn_enum_encoding of states:type is "onehot";

    SIGNAL state : states;

	SIGNAL intrclr_del1, intrclr_del2,
		flagclr_del1, flagclr_del2 : std_logic;

	--ATTRIBUTE syn_keep of set_overlap_fault, set_bounce_warning
     --   : SIGNAL is true;

    --attribute FPGA_gsr: boolean;
    --attribute FPGA_gsr of Nreset:signal is true; -- routed using GSR.
                                                 -- (active low)
BEGIN

----- Edge detection not necessary when intstate is in same device 
----- and uses the same clock as prreq or prod.  This unit assumes
----- that the edge_in signal is one clock tick induration from a
----- seperate module in the same PLD running on the same exact clock.

--	sync4 : process (mclk, Nreset)
--	BEGIN
--
--	if(Nreset='0') then
--		flagclr_del2 <= '0'; -- Used to resync clear signals in case
--		intrclr_del2 <= '0'; -- generated based on a different clock.
--	  elsif(rising_edge(mclk)) then
--		intrclr_del2 <= intr_clr;
--		flagclr_del2 <= flag_clr;
--      end if;
--    END process sync4;


    intr1 : process (mclk, Nreset, enable_in, edge_in)
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
            elsif(intr_clr='1') then
             	state <= flag;
            end if;

          when flag =>
            if(enable_in='0') then
             	state <= idle;
            elsif(flag_clr='1') then
             	state <= enabled;
            end if;

          when others =>
             	state <= idle;

        end case;
      end if;
    END process intr1;

	int_flag <= '1' when(state=interrupt OR state=flag) else '0';
	intr <= '1' when(state=interrupt) else '0';
--    set_overlap_fault <= '1' when(state=flag AND edge_in='1') else '0';
--    set_bounce_warning <= '1' when(state=interrupt AND edge_in='1') else '0';

END archintstate2;

library ieee;
use ieee.std_logic_1164.all;

library synplify;
use synplify.attributes.all;


ENTITY prod2 IS
    PORT(mclk, Nreset, pd, pd_inv, pd_lead_edge_sel, enc_tick_choice,
		enable_in, pd_intr_clr, pd_flag_clr : in std_logic;
		set_pd_overlap_fault, set_pd_bounce_warning,
		pd_int_flag, pd_intr, pd_filtered, pd_edge_tick : out std_logic);
END prod2;

ARCHITECTURE archprod2 OF prod2 IS

	SIGNAL pddel1, pddel2, pdmdel1, pdmdel2, pd_filter1, pd_filter2,
        pd_filter3, pd_filter0, pd_normalized, pd_high, pd_low, 
        pd_edge, pd_filtered_temp, pd_mclk_edge_tick, pd_edge_tick_temp : std_logic;

COMPONENT intstate1
    PORT(mclk, edge_in, enable_in, intr_clr, flag_clr,
		Nreset : in std_logic;
		set_overlap_fault, set_bounce_warning,
		int_flag, intr : out std_logic);
END COMPONENT;

    --attribute FPGA FPGA_gsr: boolean;
    --attribute FPGA FPGA_gsr of Nreset:signal is true; -- routed using GSR.

BEGIN
	
	pd_normalized <= pd XOR pd_inv;
	pd_high <= '1' when (pd_filter1='1' AND pd_filter2='1' 
                         AND pd_normalized='1')
						 else '0';
	pd_low  <= '1' when (pd_filter1='0' AND pd_filter2='0' 
                         AND pd_normalized='0')
						 else '0';
	
	pd_inv_filter:process (mclk, Nreset, enc_tick_choice, pd_high, pd_low)
	BEGIN

	  if(Nreset='0') then
		pd_filter0 <= '0';
		pd_filter1 <= '0';
		pd_filter2 <= '0';
		pd_filtered_temp <= '0';
	  elsif(rising_edge(mclk)) then
		pd_filter0 <= pd_normalized;
	    if(enc_tick_choice='1') then -- filter stepped with choice of enc tick
	 		pd_filter1 <= pd_filter0;
	 		pd_filter2 <= pd_filter1;
			if(pd_high='1') then
				pd_filtered_temp <= '1';
			elsif(pd_low='1') then
				pd_filtered_temp <= '0';
			end if;
		end if;
	  end if;
    END process pd_inv_filter;

	pd_filtered <= pd_filtered_temp;
	
	pd_edge <= (not(pd_lead_edge_sel) AND not(pddel1) AND pddel2)
			    OR (pd_lead_edge_sel AND pddel1 AND not(pddel2));

	pd_edgesense: process (mclk, Nreset)
	BEGIN
	  if(Nreset='0') then
		pddel1 <= '0';
		pddel2 <= '0';
		pd_edge_tick_temp <= '0';
	  elsif(rising_edge(mclk)) then
		pddel1 <= pd_filtered_temp;
		pddel2 <= pddel1;
		pd_edge_tick_temp <= pd_edge;
	  end if;
    END process pd_edgesense;

	pd_edge_tick <= pd_edge_tick_temp;
	
	pdintr1:intstate1 PORT MAP(				   
		mclk, pd_edge_tick_temp, enable_in,
		pd_intr_clr, pd_flag_clr,
		Nreset, set_pd_overlap_fault,
		set_pd_bounce_warning,
		pd_int_flag, pd_intr);

END archprod2;


library ieee;
use ieee.std_logic_1164.all;

library synplify;
use synplify.attributes.all;


ENTITY prod3 IS
    PORT(mclk, Nreset, pd, pd_inv, pd_lead_edge_sel, two_edge_enable, enc_tick_choice,
		enable_in, pd_intr_clr, pd_flag_clr : in std_logic;
--		set_pd_overlap_fault, set_pd_bounce_warning,
		pd_int_flag, pd_intr, pd_filtered, pd_edge_tick : out std_logic);
END prod3;

ARCHITECTURE archprod3 OF prod3 IS

	SIGNAL pddel1, pddel2, pdmdel1, pdmdel2, pd_filter1, pd_filter2,
        pd_filter3, pd_filter0, pd_normalized, pd_high, pd_low, 
        pd_edge, pd_mclk_edge_tick, pd_edge_tick_temp, pd_filtered_temp : std_logic;

COMPONENT intstate2
    PORT(mclk, edge_in, enable_in, intr_clr, flag_clr,
		Nreset : in std_logic;
--		set_overlap_fault, set_bounce_warning,
		int_flag, intr : out std_logic);
END COMPONENT;

    --attribute FPGA FPGA_gsr: boolean;
    --attribute FPGA FPGA_gsr of Nreset:signal is true; -- routed using GSR.

BEGIN
	
	pd_normalized <= pd XOR pd_inv;
	pd_high <= '1' when (pd_filter1='1' AND pd_filter2='1' 
                         AND pd_normalized='1')
						 else '0';
	pd_low  <= '1' when (pd_filter1='0' AND pd_filter2='0' 
                         AND pd_normalized='0')
						 else '0';
	
	pd_inv_filter:process (mclk, Nreset, enc_tick_choice, pd_high, pd_low)
	BEGIN

	  if(Nreset='0') then
		pd_filter0 <= '0';
		pd_filter1 <= '0';
		pd_filter2 <= '0';
		pd_filtered_temp <= '0';
	  elsif(rising_edge(mclk)) then
		pd_filter0 <= pd_normalized;
	    if(enc_tick_choice='1') then -- filter stepped with choice of enc tick
	 		pd_filter1 <= pd_filter0;
	 		pd_filter2 <= pd_filter1;
			if(pd_high='1') then
				pd_filtered_temp <= '1';
			elsif(pd_low='1') then
				pd_filtered_temp <= '0';
			end if;
		end if;
	  end if;
    END process pd_inv_filter;

	pd_filtered <= pd_filtered_temp;

--	pd_edge <= (not(pd_lead_edge_sel) AND not(pddel1) AND pddel2)
--			    OR (pd_lead_edge_sel AND pddel1 AND not(pddel2));

	pd_edge <= ((not(pd_lead_edge_sel) OR two_edge_enable) AND not(pddel1) AND pddel2)
			    OR ((pd_lead_edge_sel OR two_edge_enable) AND pddel1 AND not(pddel2));


	pd_edgesense: process (mclk, Nreset)
	BEGIN
	  if(Nreset='0') then
		pddel1 <= '0';
		pddel2 <= '0';
		pd_edge_tick_temp <= '0';
	  elsif(rising_edge(mclk)) then
		pddel1 <= pd_filtered_temp;
		pddel2 <= pddel1;
		pd_edge_tick_temp <= pd_edge;
	  end if;
    END process pd_edgesense;

	pd_edge_tick <= pd_edge_tick_temp;
	
	pdintr1:intstate2 PORT MAP(				   
		mclk, pd_edge_tick_temp, enable_in,
		pd_intr_clr, pd_flag_clr,
		Nreset, -- set_pd_overlap_fault, set_pd_bounce_warning,
		pd_int_flag, pd_intr);

END archprod3;


library ieee;
use ieee.std_logic_1164.all;

library synplify;
use synplify.attributes.all;


-- This entity, PROD4, is identical to PROD2 except for the additional
-- input, called bypass_filter.  This input will connect the PD input
-- directly to the interrupt logic instead of delaying it.  With
-- lead edge triggering selected, this allows very precise PD interrupt
-- timing, provided that the source is also precise.  This is the case
-- with the internal PD feature.  Also, basic PD filtering has added
-- one more filter clock sample.  This extends the number of samples in
-- a row that must match, but asumes a faster sample clock.  The effect
-- is to reduce edge timing variation (faster sample clock) while
-- maintaining filter time.


ENTITY prod4 IS
    PORT(mclk, Nreset, pd, pd_inv, pd_lead_edge_sel, enc_tick_choice,
		enable_in, pd_intr_clr, pd_flag_clr, bypass_filter : in std_logic;
		set_pd_overlap_fault, set_pd_bounce_warning,
		pd_int_flag, pd_intr, pd_filtered, pd_edge_tick : out std_logic);
END prod4;

ARCHITECTURE archprod4 OF prod4 IS

	SIGNAL pddel1, pddel2, pdmdel1, pdmdel2, pd_filter1, pd_filter2,
        pd_filter3, pd_filter0, pd_normalized, pd_high, pd_low, 
        pd_edge, pd_mclk_edge_tick, pd_edge_tick_temp, pd_filtered_temp : std_logic;

COMPONENT intstate1
    PORT(mclk, edge_in, enable_in, intr_clr, flag_clr,
		Nreset : in std_logic;
		set_overlap_fault, set_bounce_warning,
		int_flag, intr : out std_logic);
END COMPONENT;

    --attribute FPGA FPGA_gsr: boolean;
    --attribute FPGA FPGA_gsr of Nreset:signal is true; -- routed using GSR.

BEGIN
	
	pd_normalized <= pd XOR pd_inv;
	pd_high <= '1' when (pd_filter1='1' AND pd_filter2='1' AND pd_filter3='1') 
    --                     AND pd_normalized='1')
						 else '0';
	pd_low  <= '1' when (pd_filter1='0' AND pd_filter2='0' AND pd_filter3='0') 
    --                     AND pd_normalized='0')
						 else '0';

	pd_inv_filter:process (mclk, Nreset, enc_tick_choice, pd_high, pd_low, bypass_filter)
	BEGIN
                                  -- filter is stepped with chosen
	  if(Nreset='0') then         -- input clock time base, unless
        pd_filter0  <= '0';
        pd_filter1  <= '0';       -- bypass = '1'; then the filter
		pd_filter2  <= '0';       -- is changed to mclk, effectively
		pd_filter3  <= '0';       -- eliminated. 
		pd_filtered_temp <= '0';       
	  elsif(rising_edge(mclk)) then
		pd_filter0 <= pd_normalized;
        if(bypass_filter='1') then
            pd_filtered_temp <= pd_filter0;
	    elsif(enc_tick_choice='1') then 
	 		pd_filter1 <= pd_filter0;
	 		pd_filter2 <= pd_filter1;
	 		pd_filter3 <= pd_filter2;
			if(pd_high='1') then
				pd_filtered_temp <= '1';
			elsif(pd_low='1') then
				pd_filtered_temp <= '0';
			end if;
		end if;
	  end if;
    END process pd_inv_filter;

	pd_filtered <= pd_filtered_temp;
	
	pd_edge <= (not(pd_lead_edge_sel) AND not(pddel1) AND pddel2)
			    OR (pd_lead_edge_sel AND pddel1 AND not(pddel2));

	pd_edgesense: process (mclk, Nreset)
	BEGIN
	  if(Nreset='0') then
		pddel1 <= '0';
		pddel2 <= '0';
		pd_edge_tick_temp <= '0';
	  elsif(rising_edge(mclk)) then
		pddel1 <= pd_filtered_temp;
		pddel2 <= pddel1;
		pd_edge_tick_temp <= pd_edge;
	  end if;
    END process pd_edgesense;

	pd_edge_tick <= pd_edge_tick_temp;
	
	pdintr1:intstate1 PORT MAP(				   
		mclk, pd_edge_tick_temp, enable_in,
		pd_intr_clr, pd_flag_clr,
		Nreset, set_pd_overlap_fault,
		set_pd_bounce_warning,
		pd_int_flag, pd_intr);

END archprod4;

library ieee;
use ieee.std_logic_1164.all;

library synplify;
use synplify.attributes.all;


ENTITY prreq2 IS
    PORT(mclk, Nreset, pr_match, enable_in,
		pr_intr_clr, pr_flag_clr : in std_logic;
		pr_int_flag, pr_intr, set_pr_overlap_fault : out std_logic);
END prreq2;

ARCHITECTURE archprreq2 OF prreq2 IS

	SIGNAL prmdel1, prmdel2, pr_mclk_edge_tick, pr_intr_temp : std_logic;

COMPONENT intstate1				   
    PORT(mclk, edge_in, enable_in, intr_clr, flag_clr,
		Nreset : in std_logic;
		set_overlap_fault, set_bounce_warning,
		int_flag, intr : out std_logic);
END COMPONENT;

    --attribute FPGA FPGA_gsr: boolean;
    --attribute FPGA FPGA_gsr of Nreset:signal is true; -- routed using GSR.

BEGIN

	pr_mclk_edge_sense : process (mclk, Nreset)
	BEGIN

  if(Nreset='0') then
	    prmdel1 <= '0';
	    prmdel2 <= '0';
		pr_mclk_edge_tick <= '0';
	  elsif(rising_edge(mclk)) then
		prmdel1 <= pr_match AND not(pr_intr_temp);
	 	prmdel2 <= prmdel1;
    	pr_mclk_edge_tick <= prmdel1 AND not(prmdel2); -- pos transition
	  end if;
    END process pr_mclk_edge_sense;

	printr1:intstate1 PORT MAP(				   
		mclk, pr_mclk_edge_tick, enable_in,
		pr_intr_clr, pr_flag_clr,
		Nreset, set_pr_overlap_fault,
		open, pr_int_flag, pr_intr_temp);

		pr_intr <= pr_intr_temp;
		
END archprreq2;


