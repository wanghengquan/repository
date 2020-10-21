---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--      STROKE MANAGER DMA CONTROL MODULE
-- 
--      FOR THE LOW-END CIJ PLATFORM FPGA
--
--      VHDL DESIGN FILE :SMDMAK.VHD
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
-- This file is modified from SMDMA1.VHD to accomodate the bus structure
-- of the MPC801 and QP1700.  Some state sequences are faster (fewer states
-- needed) also due to the hardware features and timing of these two chips.
-- Specifically, this includes the table address sequence and the data
-- address sequence, smtable2 and smdat1.

-- The design has been further modified to use a single clock except
-- for the slipp interface which must clock at 32 MHz.

-- SMDMAB2.VHD has been revised from the Atlas project file, SMDMA9G.VHD.
-- It has also been modified for active low naming convention as starting
-- the signal name with "N".

-- Modified for use with Synplicity synthesis software.

-- SMDMAD.VHD uses revised write strobe resync (in dmasysh.vhd); cleaned
-- up state machine logic and char ready latching.

-- SMDMAE.VHD added the condition of char_send_ready to enable sending
-- the stop character dmactrl1.  Also, in smdat1, the condition for
-- completion of str_data_transfer state was revised.  

-- SMDMAF.VHD added Hardware Multi-stroking.

-- SMDMAG.VHD added reverse print direction capability.
-- Also, modified to take into account the use of the "Abort Print" function.
-- This requires that certain state machines test for the abort signal
-- so as not to wait for communication related hand-shakes with SLIPP
-- logic which will not happen during Abort.  Also, revised to terminate
-- the print process if print_enable goes inactive during a print image.
-- This requires forcing an abort cycle so as to issue a "last stroke"
-- prior to ending the image.

-- SMDMAH.VHD revised the timing of (in smdma4) image_print_done now set
-- to go false prior to the transfer of setup parameters near the start
-- of the image sending process.

-- SMDMAI.VHD revised the main control state machine to more carefully
-- transfer starting register values for initial stroke data pointer and
-- to account for added syncronization delays in dmasys.  A diagram was
-- added to show the hardware relationship of various registers which
-- are at the core of the stroke manager system.
--
-- SMDMAJ.VHD is revised for use on the CIJ Low-End controller FPGA.  This
-- design does not need to generate packet data to send stroke information
-- to another processor, since the same processor supports both the IP and
-- print engine functions.
--
-- SMDMAK.VHD changes the multi-stroke register input to a four bit number.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY smdma7 IS
	port(mclk, Nreset, strk_trig, print_enable, print_command, 
	     image_done : in std_logic;

		 reload_stroke_count, image_print_done, print_start, 
		 ena_multi_stroke_ctr, send_stop_wr, multi_stroke_done : buffer std_logic;
		 multi_stroke_reg : in std_logic_vector(3 downto 0);
		 multi_stroke_ctr : buffer std_logic_vector(3 downto 0) );
END smdma7;

ARCHITECTURE archsmdma7 OF smdma7 IS

	type states is (idle, image_start, data_transfer_settle1, 
					data_transfer_settle2, data_transfer_settle3,
                    test_image_done, send_stop, hold_stop, trig_wait, 
                    trig_wait_end, test_multistroke_done, load_stroke_address, 
                    stroke_start_settle, multistroke_count_ena_start, 
					multistroke_count_ena_end);

--	ATTRIBUTE syn_enum_encoding of states:type is "onehot";

	SIGNAL dmastate : states;
    SIGNAL print_start_trigger,
        startclr_del1_m, startclr_del2_m,
        send_latch_in, send_latch,
        latch_reset, ld_multi_stroke_ctr : std_logic;


BEGIN   

--------------- Start Control for State Machine ----------------


    print_start_trigger <= print_command AND print_enable 
                            AND image_print_done;


    startctl: process(mclk, Nreset, print_start_trigger, reload_stroke_count)
    BEGIN
    if(Nreset='0') then
        print_start <= '0';
	elsif(rising_edge(mclk)) then
        if(print_start_trigger='1') then
            print_start <= '1';
        elsif(reload_stroke_count='1' OR print_enable='0') then
            print_start <= '0';
        end if;
    end if;
    end process startctl;

----------------------- Multi-Stroke Counter ------------------------

--& The multi_stroke_reg is loaded by software to specify the number of times
-- to repeat a given stroke.

-- The multi_stroke_ctr, after being loaded from the multi_stroke_reg by the 
-- ld_multi_stroke_ctr signal, counts down with each multi-stroke. 
--
	multi_stroke_counter: process (multi_stroke_reg,  
								Nreset, mclk, ld_multi_stroke_ctr, 
								ena_multi_stroke_ctr)
    BEGIN
    if (Nreset='0') then
        multi_stroke_ctr  <= "0000";
		multi_stroke_done <= '1';
	elsif(rising_edge (mclk)) then
		if (ld_multi_stroke_ctr = '1') 
			then multi_stroke_ctr <= multi_stroke_reg;
		elsif ena_multi_stroke_ctr ='1' AND multi_stroke_ctr /= "0000" then
			multi_stroke_ctr <= multi_stroke_ctr-1;
			end if;
		if multi_stroke_ctr = "0000" 
			then multi_stroke_done <= '1';
		else multi_stroke_done <= '0';
		end if;
	end if;
    END process multi_stroke_counter;


------------------ Main Stroke Manager State Machine ------------------

	dmactrl1: process (mclk, Nreset, print_start, image_done, print_enable, 
						strk_trig, multi_stroke_done)
	BEGIN
	if(Nreset='0') then
		dmastate <= idle;
		reload_stroke_count <= '0';
		send_stop_wr <= '0';
--		image_print_done   <= '1';
		ld_multi_stroke_ctr <= '0';
		ena_multi_stroke_ctr <= '0';
	elsif(rising_edge(mclk)) then -- during reverse print.
		case dmastate is
			when idle =>
    			reload_stroke_count <= '0';
--    			image_print_done   <= '1';
				send_stop_wr <= '0';
				ld_multi_stroke_ctr <= '0'; -- at stroke_addr_mux, initially
				ena_multi_stroke_ctr <= '0';-- select image_addr input 
											
				if(print_start='1') then      -- added new state to allow
--				 image_print_done <= '0';	  -- image_print_done to clear	
    			 dmastate <= image_start;	  -- before loading "done enable".
	    		ld_multi_stroke_ctr <= '1';	 --& start multi-stroke load pulse
				reload_stroke_count <= '1';	--& Start reload_stroke_count
              end if;						  -- (reload_stroke_count).
                                              -- *** See diagram at end of section.
            when image_start =>
			    ld_multi_stroke_ctr <= '0';	--& end multi-stroke load pulse
				reload_stroke_count <= '0'; --& end reload_stroke_count
			                                --& load pulse
										    -- load pulse.  This also loads
										    -- data_addr register and starts 
										    -- stroke_header_select.
				dmastate <= data_transfer_settle1;

            when data_transfer_settle1 =>
				dmastate <= data_transfer_settle2;

            when data_transfer_settle2 =>
				dmastate <= data_transfer_settle3;

            when data_transfer_settle3 =>        
                dmastate <= test_image_done; -- The long settling time is
				                                   -- needed due to the 	
                                                   -- pipelining added to 
                                                   -- image_done for better
                                                   -- routing of synchronous
                                                   -- design.

            when test_image_done =>  -- immediately done if print_enable false
				if(image_done = '1' OR print_enable='0') then -- all strokes
					dmastate <= idle;           --  or all multi-strokes sent
--   				image_print_done   <= '1';	-- All triggers sent
				else                     
					dmastate <= send_stop;
--				    image_print_done <= '0';
				end if;

			when send_stop =>
				    send_stop_wr <= '1';	 -- Has side effect of
											 -- decrementing the
				    dmastate <= hold_stop;   -- stroke_count_read down counter

			when hold_stop =>
				dmastate <= trig_wait;
				send_stop_wr <= '0';

			when trig_wait =>
                if(print_enable='0') then -- immediate image done if false
                    dmastate <= idle;
				elsif(strk_trig = '1') then
					dmastate <= trig_wait_end;
				end if;

			when trig_wait_end =>
				if(strk_trig = '0') then
					dmastate <= test_multistroke_done;
				end if;

			when test_multistroke_done =>
				if(multi_stroke_done = '1') then
                    dmastate <= load_stroke_address;
				else dmastate <= multistroke_count_ena_start; -- repeat
                end if;                                       -- the stroke.

            when load_stroke_address =>
										 -- start stroke_start_addr load pulse
										 -- to save address of next stroke
										 -- addr_mux was previously steered
										 -- to data_addr input
				ld_multi_stroke_ctr <= '1';	-- start multi-stroke load pulse
				dmastate <= stroke_start_settle;
				
            when stroke_start_settle =>
											-- stop stroke_start_addr load pulse
				ld_multi_stroke_ctr <= '0';	-- end multi-stroke load pulse
				dmastate <= test_image_done;

            when multistroke_count_ena_start =>
				ena_multi_stroke_ctr <= '1';   --& start ena_multi_stroke_ctr
				dmastate <= multistroke_count_ena_end; -- count enable pulse

            when multistroke_count_ena_end =>
				ena_multi_stroke_ctr <= '0';   --& end ena_multi_stroke_ctr 
				dmastate <= test_image_done;   --  count enable pulse

			when others =>
				dmastate <= idle;

		end case;
	end if;
	END process dmactrl1;


	image_print_done <= '1' when(dmastate=idle) else '0' ;


-------------- DIAGRAM OF STROKE & DATA ADDRESS LOGIC ---------------

-- The register and counter logic necessary to support multi-stroke
-- printing involves the latching of the stroke address at key points
-- in the print process.  It also involves retrieving and reloading
-- it to repeat the strokes.  The crude diagram below is intended to
-- serve as a reminder of the basic register/counter logic structure.
--
--                                  DATA BUS
--                                      |
--    Processor Write            ______\|/________
--              image_regen---> | image_addr reg. |
--                              |_________________|
--                                  |        _________
--                                  |       |         |
--                               __\|/_____\|/____    |
--         sel_image_addr_L---> | stroke addr mux |   |
--                              |_________________|   |
--                                      |             |
--                               ______\|/________    |
--           ld_stroke_addr---> | stroke_addr reg.|   |
--                              |_________________|   |
--                                      |             |
--                               ______\|/________    |
--             ld_data_addr---> |  data_addr ctr  |   |
--                              |_________________|   |
--                                       |____________|
--                                       |
--                            __________\|/__________
--                           | Address used to fetch |
--                           |   stroke data bytes   |
--                           |_______________________|
--
----------------------------------------------------------------------

END archsmdma7;



