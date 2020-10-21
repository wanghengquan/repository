---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--      STROKE MANAGER DMA SYSTEM MODULE
-- 
--      FOR THE LOW-END CIJ PLATFORM FPGA
--
--      VHDL DESIGN FILE :DMASYSO.VHD
--
--      by: M. Stamer
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
--
-- This file adds the SLIPP function and reduces the external pin count.

-- Modified for use with Synplicity synthesis software.
--
-- DMASYSF.VHD adds the two abort configuration bits to the input
-- list.  This accomodates the new feature of "abort gating" of
-- print images.  The two bits describe the mode ON/OFF and
-- which of two sources of abort control signal.
--
-- DMASYSG.VHD reduces the max. number of stroke data byte to 256 (8 bit value).
-- This was done to save logic cells.  The max. size could still be reduced further
-- if necessary.  The limit to still support a 256 pixel array head would
-- be 6 bits (64 bytes, i.e. 32 print bytes plus overhead).

-- version dmasysh.vhd temporarily modified to bring out internal signals
-- to aid in debugging.

-- DMASYSI.VHD uses the multi-stroke counter to more accurately determine
-- the truely last stroke in a multi-stroked image.

-- DMASYSJ.VHD revised to include reverse print capability.  This requires
-- manipulating the data address counter to step up as well as down.

-- DMASYSK.VHD corrected to image_print_done condition for multiple
-- sub-image forms of printing, so that a single external total_image_done
-- signal is sent to the iologic.  This results in a single "image complete"
-- level or pulse instead of multiples for each sub-image.

-- Skipped dmasysl.vhd due to l looking like a 1.

-- DMASYSM.VHD revised the abort logic to more correctly set the
-- full_image_aborted bit.  This required bringing in pr_match from the
-- capture & compare logic, as well as the print start command strobe
-- from the processor.  This is needed to inhibit abort start near the
-- beginning of every image print cycle, so as to temporarily mask off
-- changes in the abort condition once it is read.
--
-- DMASYSN.VHD revised for Low-End CIJ Platform controller FPGA.  Design
-- does not require stroke data transfers; only stroke counting, multi-stroke
-- support, etc.  The "new_image_readyff" is no longer supported.
--
-- DMASYSO.VHD now supports four bit multi-stroking.

library ieee;
use ieee.std_logic_1164.all;

ENTITY dmasyso IS
	port(mclk, Nreset, 
		 Nwr, print_command, pr_match, 
         print_enableff, Ntotal_done_enable, 
         strk_trig, abort_start : in std_logic;

		 image_print_done, image_done, print_start, total_image_done, image_print_abortff,
         strokes_abortedff, full_message_aborted, setup_transfer 
		 : buffer std_logic;
         
		 data : in std_logic_vector(31 downto 0);

		------- Temporary outputs for debugging

		reload_stroke_count, send_stop_wr, multi_stroke_done : buffer std_logic; 


		---- Address decode inputs

		 stroke_count_store_dcd, image_print_abortff_dcd : in std_logic;

		 stroke_count_read : buffer std_logic_vector(15 downto 0);

		 multi_stroke_reg: in std_logic_vector (3 downto 0) );
END dmasyso;

ARCHITECTURE archdmasyso OF dmasyso IS

	-- This attribute was added due to multiple reset inputs; it was
	-- needed to allow the automatic use of GSR.

	SIGNAL reset, store_word, Nstore_ctrl_reset,
           latch_word, d0inv,  ts1, ts2, stroke_count_store_regen,
           -------reload_stroke_count, 
		   -------------------------------------send_stop_wr,
		   csas, rdoe, high, low, stroke_inc, stroke_ci_L,
           cot2l1, cot2u1, cod4l1, cod4u1, cosc4l1, cot3l1, cod5l1,
		   --image_done, 
		   stroke_count_enable, one_stroke_left, last_odd_tick,
		   word_inc, pr_edge_tick, whole_words_done,
		   one_whole_word, douten, nid_reset, inidclear,
		   qdrtr_enable1, dataoe, enc_div,
           strk_tick, nid_out_tick, niddiv_del, niddiv_tick,
           byte_tick_not, byte_inc_en, cobyte, macro_stroke_count_zero,
		   partial_stroke_count_zero, one_macro_stroke_left,
           abort_terminate, abort_set, print_enable_gated,
           ena_multi_stroke_ctr, abort_start_combined,
           abort_start_combined_in, abort_terminate_in, 
           print_start_trigger, print_start_trigger_in,
           one_macro_stroke_left_in, macro_stroke_count_zero_in,
           one_stroke_left_in, image_done_in, print_req_in,
           print_req_del, abort_start_inhibit : std_logic;

    type abortstates is(idle, last_pkt_send, abort, abort_end);
--      ATTRIBUTE syn_enum_encoding of abortstates:type is "onehot";

    SIGNAL abortstate : abortstates;

	SIGNAL image_regen, user_output_regen,
		   NID_div_numeratorupper_regen, NID_div_numeratorlower_regen,
           NID_div_ratio_regen,
		   NID_div_denom_regen, new_image_readyff_regen,
	       image_print_abortff_regen, not_strk_invert, ----------------------multi_stroke_done,
		   multi_stroke_mode, single_stroke_mode,
		   last_multi_stroke_startedff, strk_trig_end_tick,
           trig_del1, trig_del2, strk_trig_tick, print_end_del1,
		   print_end_del2, print_end, total_done_enable,
           total_done_enable_regen : std_logic;

	SIGNAL niddiv, clear4 : std_logic_vector(3 downto 0);
 
	SIGNAL strokecount_read, stroke_count_store : std_logic_vector(15 downto 0);
	SIGNAL NID_div_numerator, NID_div_denom : std_logic_vector(7 downto 0);
	SIGNAL multi_stroke_ctr : std_logic_vector (3 downto 0);

COMPONENT smdma7
	port(mclk, Nreset, strk_trig, print_enable, print_command, 
	     image_done : in std_logic;

		 reload_stroke_count, image_print_done, print_start, 
		 ena_multi_stroke_ctr, send_stop_wr, multi_stroke_done : buffer std_logic;
		 multi_stroke_reg : in std_logic_vector(3 downto 0);
		 multi_stroke_ctr : buffer std_logic_vector(3 downto 0));
END COMPONENT;

COMPONENT enreg8
	port(d : in std_logic_vector(7 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(7 downto 0));
END COMPONENT;

COMPONENT lddncnt8
	port(d : in std_logic_vector(7 downto 0);
		 en, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(7 downto 0));
END COMPONENT;

BEGIN

---------------------------- Miscellaneous -------------------------------

	reset <= not(Nreset);

	high <= '1';
	low  <= '0';
    clear4 <= (others => '0');

	dmactrl1: smdma7 port map(
		 mclk, Nreset, strk_trig, print_enableff, print_command, image_done, 
		 
		 reload_stroke_count, image_print_done, print_start, ena_multi_stroke_ctr,
		 send_stop_wr, multi_stroke_done,

		 multi_stroke_reg, multi_stroke_ctr);

    setup_transfer <= reload_stroke_count; -- renamed for clarity


---------------------- Registers & Counters --------------------------

    strk_trig_tick <= trig_del2 AND not(trig_del1);

    strk_trig_end: process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        strk_trig_end_tick <= '0';
		trig_del1 <= '0';
		trig_del2 <= '0';
    elsif(rising_edge(mclk)) then
        trig_del1 <= strk_trig;
        trig_del2 <= trig_del1;
        strk_trig_end_tick <= strk_trig_tick;
	end if;
    END process strk_trig_end;

---------- Image Print Abort FF ----------

    -- Address write to terminate an abort under software control.
	
	image_print_abortff_regen <= '1' when(image_print_abortff_dcd='1'	
						AND Nwr='0') else '0';

    -- Terminate abort either from software, or after print disable,
    -- provided that an image was in process when print disable key
    -- was pressed.  In that case, hardware must generate an artificial
    -- abort cycle to truncate printing and then self-terminate
    -- that abort cycle.  This case is handled by the second product
    -- term below.  This term is now unused since it was decided that
    -- upon print disable, the print engine will ignore subsequent
    -- strokes anyway.  So we are not generating a last stroke packet
    -- at that time.

    -- The expression is now set so that software can only succeed in
    -- terminating the abort while the image_print_complete is true.

    -- A new output called full_message_aborted indicates that
    -- a complete image has been gated off, i.e. not even a stroke
    -- of the message was printed.  Therefore, software
    -- will be able to detect this condition and adjust the product
    -- index register (prod_store).  If some part of a message was printed,
    -- then that counts as the product index being sent and print
    -- is also counted by software.

    -- In case the abort occurred at the very beginning
    -- of a print image, we would send a start as well as an end stroke.
    -- This is accomplished by revising the timing of the assertion
    -- of image_print_done going to '0' to be at the exact same time as 
    -- the first stroke_done going to '0'.  Then there must be at least
    -- one packet sent before sending the last packet; i.e. two packets.

    -- If the abort start signal occurs near the end of the image, 
    -- the logic is constructed so as to enter the abort state without
    -- requiring an added stroke at the beginning of a subsequent image.

-- Detect end of print enable and generate an end tick.
						
--	printend: process (mclk, Nreset)
--	BEGIN
--	if(Nreset='0') then
--		print_end_del1 <= '0';
--		print_end_del2 <= '0';
--		print_end <= '0';
--	elsif(rising_edge(mclk)) then
--		print_end_del1 <= print_enableff;
--		print_end_del2 <= print_end_del1;
--		print_end <= print_end_del2 AND not(print_end_del1);
--	end if;
--	END process printend;


-- We will handle the abort_inhibit condition within the abort state
-- machine.  There is a problem with Synplicity synthesis not creating
-- the abort_inhibit FF as a separate process.

    -- abort_start_inhibit needed to guarantee that the abort condition does not
    -- change from the time the software attempts to clear the abort
    -- condition until start of print.  This is tricky because the 
    -- START of Abort gets masked by abort_start_inhibit.  Yet, the TERMINATION
    -- is not gated.  This logic is necessary so that an abort condition
    -- which was already latched can be tested.  If the abort input is
    -- still true, it will not terminate.  However, a new input true
    -- occurrence must not allow abort to be set until print starts.
    --
    -- This is so that software can confidently increment the product
    -- index and know that it will be printed, not aborted at the
    -- last instant.

    abort_mask_proc: process(mclk, Nreset, print_req_del, image_print_done, print_enableff)
    BEGIN
    if(Nreset='0') then
        abort_start_inhibit <= '0';
    elsif(rising_edge(mclk)) then
        if(print_req_del='1') then
            abort_start_inhibit <= '1';
       elsif(image_print_done='0' OR print_enableff='0') then
            abort_start_inhibit <= '0';
        end if;
    end if;
    END process abort_mask_proc;


    abort_start_combined_in <= (abort_start AND not(abort_start_inhibit) 
                                AND (print_enableff));

    abort_terminate_in <= (image_print_abortff_regen AND not(abort_start))
                        OR (not(print_enableff));

    print_req_in <= pr_match AND print_enableff;

    abort_ctrl_sync: process (mclk, Nreset, abort_start_combined_in, 
                              abort_terminate_in)
    BEGIN
    if(Nreset='0') then
        abort_start_combined <= '0';
        abort_terminate <= '0';
        print_req_del <= '0';
    elsif(rising_edge(mclk)) then
        abort_start_combined <= abort_start_combined_in;
        abort_terminate <= abort_terminate_in;
        print_req_del <= print_req_in;
    end if;
    END process abort_ctrl_sync;


	abortctrl1: process (mclk, Nreset, abort_start_combined, image_print_done, 
                       print_enableff, strk_trig_end_tick)
	BEGIN
	if(Nreset='0') then
	    abortstate    <= idle;
        full_message_aborted <= '0';
        image_print_abortff <= '0';
	elsif(rising_edge(mclk)) then
		case abortstate is
			when idle =>
                image_print_abortff <= '0';
                full_message_aborted <= '0';
				if(abort_start_combined='1') then
                    if(image_print_done='1') then
                        abortstate  <= abort;
                        full_message_aborted <= '1';
												  -- state set even if
                	else                          -- abort_start signal
						abortstate  <= last_pkt_send; -- is momentary.
					end if;
				end if;                      
--
--                  ______                                              ____
-- image_print_done       |______________________________ ... _________|
--                  ______    ____    ____    ____    ___ ... _    _________
-- stroke_packet_done     |__|    |__|    |__|    |__|         |__|    |
--                                                                |    |Image
--                                                                |    | End
-- For the Abort Logic, the lead-in to the image end Condition -->|    |<---
--                                                                     

            when last_pkt_send =>
                if(print_enableff='0') then -- immediate image done if false
                    abortstate <= idle;
                elsif(strk_trig_end_tick='1') then -- wait for last trigger
					abortstate  <= abort;       
                end if;

            -- By this useage, abort_terminate, from the processor,
            -- is intended to be written only just prior to an image
            -- print cycle, not at any arbitrary time.

			when abort =>
                image_print_abortff <= '1';
                if(abort_terminate='1') then
					abortstate  <= abort_end; -- processor write to end abort
				end if;
                                               -- temporary mask of abort
            when abort_end =>                  -- signal until end of current
                image_print_abortff <= '0';    -- image print (if mid-print).
                if(image_print_done='1' OR print_enableff='0') then  
					abortstate  <= idle;       
                end if;

			when others =>
					abortstate <= idle;

			end case;
		end if;
		END process abortctrl1;
        
    abort_sense : process (mclk, Nreset, image_print_abortff, 
                           image_done, abort_terminate)
	BEGIN
	if(Nreset='0') then
        strokes_abortedff <= '0';
	elsif(rising_edge(mclk)) then
		if(image_print_abortff='1' AND image_done='0') then 
            strokes_abortedff <= '1';
        elsif(abort_terminate='1') then 
            strokes_abortedff <= '0';
		end if;
	end if;
	END process abort_sense;


---------- Stroke Count Store register ----------

	stroke_count_store_regen <= '1' when(stroke_count_store_dcd='1'
		       				 				AND Nwr='0') else '0';

	stroke_count_storeupper_reg7: enreg8
	port map(data(15 downto 8), stroke_count_store_regen, mclk,
            Nreset,	stroke_count_store(15 downto 8));

	stroke_count_storelower_reg7: enreg8
	port map(data(7 downto 0), stroke_count_store_regen, mclk,
            Nreset,	stroke_count_store(7 downto 0));


----------Stroke Counter - decrements after each macro-stroke sent.

--& stroke_ci_L is the carry-in to the strokecount_read counter and 
--& permits decrementing of stroke count by going active after the 
--& stroke data has been sent. In the case of multi-stroking, 
--& stroke_ci_L is not active until all multi-strokes (which comprise
--& the macro stroke) have been sent out. This occurs when the stop 
--& character is sent for the last stroke packet.

	partial_stroke_count_zero <= '1' when 
		(strokecount_read(15 downto 1)="000000000000000") else '0';
--
	one_macro_stroke_left_in <= '1' 
	  when
		(partial_stroke_count_zero='1' AND strokecount_read(0)='1') 
	  else '0';
--
	macro_stroke_count_zero_in <= '1' when 
		(partial_stroke_count_zero='1' AND strokecount_read(0)='0') 
	  else '0';
--
	one_stroke_left_in <= '1' 
	when (single_stroke_mode='1' AND one_macro_stroke_left_in = '1'
		   AND multi_stroke_done = '1') OR
		 (last_multi_stroke_startedff='1')
	else '0';
--
	image_done_in <= '1' 
	
--	  when (macro_stroke_count_zero = '1' 
	  when (macro_stroke_count_zero_in = '1' 
	  				AND
		    multi_stroke_done='1')  -- may not be necessary to AND this.
            OR                      --print ended mid-image
            (image_print_abortff='1' AND print_enableff='0') 
                                     	-- Why is this term needed?					 
										-- It seems to need polarity
										-- of print_enableff='1'.
--			OR (print_enableff='0')	    -- new feature over IPRO.
			else '0';

    stroke_count_sync: process (mclk, Nreset, one_macro_stroke_left_in,
								one_stroke_left_in, image_done_in)
    BEGIN
    if(Nreset='0') then
    	one_macro_stroke_left <= '0'; 
--        macro_stroke_count_zero <= '1';
        one_stroke_left <= '0';
        image_done <= '1';
    elsif(rising_edge(mclk)) then
    	one_macro_stroke_left <= one_macro_stroke_left_in; 
--        macro_stroke_count_zero <= macro_stroke_count_zero_in;
        one_stroke_left <= one_stroke_left_in;
        image_done <= image_done_in;
    end if;
    END process stroke_count_sync;

--& The one_stroke_left signal is used by the stroke_header_select state machine
--& to return itself to the idle state where, for the last stroke packet
--$ it will control the sending of the SOF_L (last stroke) header.

	multi_stroke_mode <= '0' when(multi_stroke_reg="0000") else '1';
	single_stroke_mode <= '1' when(multi_stroke_reg="0000") else '0';

    last_multi_stroke_mem: process(mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        last_multi_stroke_startedff <= '0';
	elsif(rising_edge(mclk)) then
        if(one_macro_stroke_left='1' AND multi_stroke_ctr="0001") then
			last_multi_stroke_startedff <= '1';
		elsif(image_print_done='1') then
			last_multi_stroke_startedff <= '0';
		end if;
    end if;
    end process last_multi_stroke_mem;
		
-- modified for Lucent --& enables strokecount_read down counter

	stroke_count_enable <= '1' when(image_done='0') else '0';

	stroke_ci_L <= not(send_stop_wr AND multi_stroke_done); 


--& The strokecount_read register is decremented when stroke_ci_L goes
--& active. This happens after the final multi-stroke is sent comprising
--& the macro-stroke. The value in strokecount_read is, therefore, 
--& the 'macro' stroke count.

	strokecount_read_15to8: lddncnt8
	port map(stroke_count_store(15 downto 8), stroke_count_enable,
			reload_stroke_count, mclk,
			cosc4l1, Nreset, open,
			strokecount_read(15 downto 8));

	strokecount_read_7to0: lddncnt8
	port map(stroke_count_store(7 downto 0), stroke_count_enable,
			reload_stroke_count, mclk,
			stroke_ci_L, Nreset, cosc4l1,
			strokecount_read(7 downto 0));

	stroke_count_read <= strokecount_read;
			
---------- Total Message Complete Gate Register ----------

-- This register is used to gate the "image_done" condition to
-- the IO logic module.  The purpose is to distinguish between
-- images which are complete with a single "image" and those
-- that are constructed out of a series of partial images, such
-- as the image repeat case.  In these cases, software will only
-- enable the image complete gate for the last "image".  So only
-- the last image done will cause the total image done to go true.
-- The only risk with this plan is that, if software forgets to
-- enable this bit, the total image done signal will never go true.
--
-- For normal, single copy, image printing, the enable bit always
-- causes image_done to produce total_image_done.
-- 
-- Also, this bit is double buffered so that this parameter can also
-- be loaded ahead of time.

    total_done_enable_proc : process (mclk, Nreset, print_enableff, image_print_done,
	                                   Ntotal_done_enable)
    BEGIN
    if(Nreset='0') then
        total_image_done <= '1';
    elsif(rising_edge(mclk)) then
        if(print_enableff='0') then        -- print_enableff='0' forces done.
            total_image_done <= '1';
        elsif(image_print_done='0') then   -- Image_print starting always
            total_image_done <= '0';       -- negates total image done 
        elsif(Ntotal_done_enable='0') then -- condition.  Total_image_done can
            total_image_done <= '1';     -- only go true when image_print_done
        end if;                          -- is true AND total_done is
    end if;                              -- enabled.  Software writes a '1' to
    END process total_done_enable_proc;  -- Ntotal_done_enable to inhibit 
                                         -- the "total done" condition.


END archdmasyso;
