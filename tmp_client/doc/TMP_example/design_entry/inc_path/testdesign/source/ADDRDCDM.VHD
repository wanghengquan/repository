---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--      ADDRESS DECODING MODULE
-- 
--      FOR THE LOW-END CIJ PLATFORM FPGA
--
--      VHDL DESIGN FILE :ADDRDCDM.VHD
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
-- Address definitions for the total FPGA.  Later modified for a more
-- readable definition of the "hex digits" segments of each address.
-- Also changed signal naming convention for active low to signal name
-- being preceeded by "N".

-- Modified for use with Synplicity synthesis software.
--
-- ADDRDCDI.VHD revised for CIJ Low-End printer.
-- ADDRDCDJ.VHD uses addr(11) as part of CS decode,in order to allow
-- writing of Config data in the same chip select space as the main
-- logic chip select, if needed.  Also omitted more unused decodes.
--
-- ADDRDCDK.VHD is revised for support of the keyboard interface plus
-- the Analog board interface.
--
-- ADDRDCDL.VHD revised address mapping for the Videojet 1000 printer.
-- A new output, max_speed1_dcd, is used to store the upper speed limit
-- for a given print matrix; above this speed, if enabled, hardware switches
-- to internal encoding and sets a bit indicating that this has occurred.
-- Software can override by selecting external and clearing detect bit.
--
-- ADDRDCDM.VHD adds a new address decode for the software triggered beep
-- on VJ1000.
--

library ieee;
use ieee.std_logic_1164.all;

library synplify;
use synplify.attributes.all;


ENTITY addrdcdm IS
    port(addr : in  std_logic_vector(11 downto 2);
        Ncs : in std_logic;
       
        -- Common Outputs

        hdwr_config1_dcd, common_read_dcd,
		input_config1_dcd, output_config2_dcd, outsrc_config3_dcd,
        outctrl_config4_dcd, intr_in_clr_dcd, flag_in_clr_dcd,
        input_read_dcd, genint_wren_dcd, beep_dcd,

        -- Detector and Encoder related Outputs

        pd_intrpten1_dcd, pd_flagreset1_dcd, pd_intreset1_dcd,
        pd_intrpten2_dcd, pd_flagreset2_dcd, pd_intreset2_dcd,
		encodercount_read1_dcd, internal_prod_store1_dcd,

        backlash_reset1_dcd, speed_read1_dcd,
        backlash_intrpten1_dcd, backlash_intreset1_dcd,
        backlash_flagreset1_dcd, autoencode_read1_dcd,
		speed_limit1_dcd : out std_logic;

        -- Head 1 

        buffer_hdwr_config1_dcd, stroke_count_store1_dcd,
        image_intrpten1_dcd, image_intreset1_dcd, image_flagreset1_dcd,
        pr_intrpten1_dcd, pr_intreset1_dcd, pr_flagreset1_dcd,
        status_read1_dcd, fault_reset1_dcd, image_print_abortff1_dcd, 
        image_print_cmd1_dcd, internal_stroke_store1_dcd,
        compare_enable1_dcd, compare_load1_dcd, capture_read1_dcd,
        NID_reset1_dcd, NID_div_numerator1_dcd, NID_div_denom1_dcd,
        rollover_clear1_dcd, strk_trig_intreset_dcd,
        strk_trig_flagreset_dcd : out std_logic;

        -- Head 2 

--		hdwr_config2_dcd, 
		status_read2_dcd : out std_logic;

		-- Keyboard	& IO

		kbdio_intrpten1_dcd, kbdio_flagreset1_dcd, kbdio_intreset1_dcd,
        kbd_fifo_read_dcd,
 
        AN_io_read_dcd, AN_intrpten1_dcd, AN_hiflagreset1_dcd,
        AN_hiintreset1_dcd, AN_loflagreset1_dcd, AN_lointreset1_dcd
        : out std_logic);
END addrdcdm;

ARCHITECTURE archaddrdcdm OF addrdcdm IS

SIGNAL 	cs,  X0, X4, X8, XC,
		XX0,XX1,XX2,XX3,XX4,XX5,XX6,XX7,XX8,
		XX9,XXA,XXB,XXC,XXD,XXE,XXF,
		XXX0,XXX1,XXX2,XXX3,XXX4,XXX5,XXX6,XXX7,XXX8,
		XXX9,XXXA,XXXB,XXXC,XXXD,XXXE,XXXF: std_logic;

	attribute syn_keep of 	cs,  X0, X4, X8, XC,
		XX0,XX1,XX2,XX3,XX4,XX5,XX6,XX7,XX8,
		XX9,XXA,XXB,XXC,XXD,XXE,XXF,
		XXX0,XXX1,XXX2,XXX3,XXX4,XXX5,XXX6,XXX7,XXX8,
		XXX9,XXXA,XXXB,XXXC,XXXD,XXXE,XXXF: SIGNAL IS true;


--------------------------------- Common Address Definitions -----------------------------------------------

BEGIN
			   	
    X0 <= '1'  	when (addr(3 downto 2)="00") else '0';
    X4 <= '1'  	when (addr(3 downto 2)="01") else '0';
    X8 <= '1'  	when (addr(3 downto 2)="10") else '0';
    XC <= '1'  	when (addr(3 downto 2)="11") else '0';
    XX0 <='1'  	when (addr(7 downto 4)="0000") else '0';
    XX1 <='1'  	when (addr(7 downto 4)="0001") else '0';
    XX2 <='1'  	when (addr(7 downto 4)="0010") else '0';
    XX3 <='1'  	when (addr(7 downto 4)="0011") else '0';
    XX4 <='1'  	when (addr(7 downto 4)="0100") else '0';
    XX5 <='1'  	when (addr(7 downto 4)="0101") else '0';
    XX6 <='1'  	when (addr(7 downto 4)="0110") else '0';
    XX7 <='1'  	when (addr(7 downto 4)="0111") else '0';
    XX8 <='1'  	when (addr(7 downto 4)="1000") else '0';
    XX9 <='1'  	when (addr(7 downto 4)="1001") else '0';
    XXA <='1'  	when (addr(7 downto 4)="1010") else '0';
    XXB <='1' 	when (addr(7 downto 4)="1011") else '0';
    XXC <='1'  	when (addr(7 downto 4)="1100") else '0';
    XXD <='1'  	when (addr(7 downto 4)="1101") else '0';
    XXE <='1'  	when (addr(7 downto 4)="1110") else '0';
    XXF <='1'  	when (addr(7 downto 4)="1111") else '0';
    XXX0 <='1'  when (addr(9 downto 8)="00") else '0';
    XXX1 <='1'  when (addr(9 downto 8)="01") else '0';
    XXX2 <='1'  when (addr(9 downto 8)="10") else '0';
    XXX3 <='1'  when (addr(9 downto 8)="11") else '0';

	cs <= '1' when (Ncs='0' AND addr(11)='0') else '0';

----------------- Common Address Definitions ----------------------

     hdwr_config1_dcd			<= cs AND XXX0 AND XXA AND X8; -- 0A8h
     buffer_hdwr_config1_dcd    <= cs AND XXX0 AND XXB AND XC; -- 0BCh 

--     hdwr_config2_dcd			<= cs AND XXX1 AND XXA AND X8; -- 1A8h
--     buffer_hdwr_config2_dcd    <= cs AND XXX1 AND XXB AND XC; -- 1BCh 

--     hdwr_config3_dcd			<= cs AND XXX2 AND XXA AND X8; -- 2A8h
--     buffer_hdwr_config3_dcd    <= cs AND XXX2 AND XXB AND XC; -- 2BCh 

--     hdwr_config4_dcd			<= cs AND XXX3 AND XXA AND X8; -- 3A8h
--     buffer_hdwr_config4_dcd    <= cs AND XXX3 AND XXB AND XC; -- 3BCh 

     common_read_dcd			<= cs AND XXX1 AND XXB AND X4; -- 1B4h

     -- I/O Configuration and Control

	 input_config1_dcd	 		<= cs AND XXX0 AND XXC AND X0; -- 0C0h
     output_config2_dcd 		<= cs AND XXX0 AND XXC AND X4; -- 0C4h
     outsrc_config3_dcd 		<= cs AND XXX0 AND XXC AND X8; -- 0C8h
     outctrl_config4_dcd 		<= cs AND XXX0 AND XXC AND XC; -- 0CCh

	 input_read_dcd 	 		<= cs AND XXX0 AND XXB AND X4; -- 0B4h
--	 interrupt_read_io_dcd 		<= cs AND XXX0 AND XXB AND X8; -- 0B8h

	-- Keyboard Control

     kbdio_intrpten1_dcd     	<= cs AND XXX0 AND XXF AND X4; -- 0F4h
     kbdio_flagreset1_dcd     	<= cs AND XXX0 AND XXF AND X8; -- 0F8h
     kbdio_intreset1_dcd		<= cs AND XXX0 AND XXF AND XC; -- 0FCh
     kbd_fifo_read_dcd		 	<= cs AND XXX0 AND XX9 AND XC; -- 09Ch

	 -- software driven beep, resides on controller board of VJ1000.
	 beep_dcd					<= cs AND XXX0 AND XX0 AND X8; -- 008h

	-- Analog Board IO Control

     AN_io_read_dcd		 		<= cs AND XXX1 AND XXC AND X0; -- 1C0h
     AN_intrpten1_dcd     		<= cs AND XXX1 AND XXC AND X4; -- 1C4h
     AN_hiflagreset1_dcd     	<= cs AND XXX1 AND XXC AND X8; -- 1C8h
     AN_hiintreset1_dcd			<= cs AND XXX1 AND XXC AND XC; -- 1CCh
     AN_loflagreset1_dcd     	<= cs AND XXX1 AND XXF AND X8; -- 1F8h
     AN_lointreset1_dcd			<= cs AND XXX1 AND XXF AND XC; -- 1FCh

     -- PD and Encoder Related Addresses

     PD_intrpten1_dcd      		<= cs AND XXX0 AND XX2 AND X4; -- 024h
     PD_flagreset1_dcd     		<= cs AND XXX0 AND XX2 AND X8; -- 028h
     PD_intreset1_dcd			<= cs AND XXX0 AND XX2 AND XC; -- 02Ch
     encodercount_read1_dcd 	<= cs AND XXX0 AND XX4 AND X8; -- 048h
     rollover_clear1_dcd        <= cs AND XXX0 AND XX4 AND XC; -- 04Ch
     internal_prod_store1_dcd 	<= cs AND XXX0 AND XX7 AND XC; -- 07Ch

     PD_intrpten2_dcd			<= cs AND XXX1 AND XX2 AND X4; -- 124h
     PD_flagreset2_dcd     		<= cs AND XXX1 AND XX2 AND X8; -- 128h
     PD_intreset2_dcd       	<= cs AND XXX1 AND XX2 AND XC; -- 12Ch
--     encodercount_read2_dcd 	<= cs AND XXX1 AND XX4 AND X8; -- 148h
--     rollover_clear2_dcd        <= cs AND XXX1 AND XX4 AND XC; -- 14Ch
--     internal_prod_store2_dcd 	<= cs AND XXX1 AND XX7 AND XC; -- 17Ch
	   
--     pd_aux_intreset_dcd   		<= cs AND XXX2 AND XX2 AND XC; -- 22Ch

     backlash_reset1_dcd    	<= cs AND XXX0 AND XX8 AND X0; -- 080h
     speed_read1_dcd        	<= cs AND XXX0 AND XX8 AND X4; -- 084h
     backlash_intrpten1_dcd  	<= cs AND XXX0 AND XX9 AND X0; -- 090h
     backlash_intreset1_dcd  	<= cs AND XXX0 AND XX9 AND X4; -- 094h
     backlash_flagreset1_dcd 	<= cs AND XXX0 AND XX9 AND X8; -- 098h

     speed_limit1_dcd 	        <= cs AND XXX0 AND XXA AND X4; -- 0A4h

     autoencode_read1_dcd  		<= cs AND XXX0 AND XXB AND X0; -- 0B0h

--     backlash_reset2_dcd    	<= cs AND XXX1 AND XX8 AND X0; -- 180h
--     speed_read2_dcd        	<= cs AND XXX1 AND XX8 AND X4; -- 184h
--     backlash_intrpten2_dcd  	<= cs AND XXX1 AND XX9 AND X0; -- 190h
--     backlash_intreset2_dcd  	<= cs AND XXX1 AND XX9 AND X4; -- 194h
--     backlash_flagreset2_dcd 	<= cs AND XXX1 AND XX9 AND X8; -- 198h
--     interrupt_read2_dcd    	<= cs AND XXX1 AND XXA AND X4; -- 1A4h
--     autoencode_read2_dcd   	<= cs AND XXX1 AND XXB AND X0; -- 1B0h

--     PD_intrpten_aux_dcd    	<= cs AND XXX2 AND XX2 AND X4; -- 224h
--     PD_flagreset_aux_dcd   	<= cs AND XXX2 AND XX2 AND X8; -- 228h
--     PD_intreset_aux_dcd    	<= cs AND XXX2 AND XX2 AND XC; -- 22Ch
--     watchdog_kick_dcd     	<= cs AND XXX1 AND XX9 AND XC; -- 19Ch

     -- General Puropose Interrupts

--     gen_flagreset0_dcd         <= cs AND XXX0 AND XXD AND X0; -- 0D0h
     flag_in_clr_dcd            <= cs AND XXX0 AND XXD AND X0; -- 0D0h

--     gen_flagreset1_dcd         <= cs AND XXX0 AND XXD AND X4; -- 0D4h
--     gen_flagreset2_dcd         <= cs AND XXX0 AND XXD AND X8; -- 0D8h
--     gen_flagreset3_dcd         <= cs AND XXX0 AND XXD AND XC; -- 0DCh
--     gen_flagreset4_dcd         <= cs AND XXX0 AND XXE AND X0; -- 0E0h
--     gen_flagreset5_dcd         <= cs AND XXX0 AND XXE AND X4; -- 0E4h
--     gen_flagreset6_dcd         <= cs AND XXX0 AND XXE AND X8; -- 0E8h
--     gen_flagreset7_dcd         <= cs AND XXX0 AND XXE AND XC; -- 0ECh
--     gen_flagreset8_dcd         <= cs AND XXX0 AND XXF AND X0; -- 0F0h
      
--     gen_intreset0_dcd          <= cs AND XXX1 AND XXD AND X0; -- 1D0h
     intr_in_clr_dcd            <= cs AND XXX1 AND XXD AND X0; -- 1D0h

--     gen_intreset1_dcd          <= cs AND XXX1 AND XXD AND X4; -- 1D4h
--     gen_intreset2_dcd          <= cs AND XXX1 AND XXD AND X8; -- 1D8h
--     gen_intreset3_dcd          <= cs AND XXX1 AND XXD AND XC; -- 1DCh
--     gen_intreset4_dcd          <= cs AND XXX1 AND XXD AND X0; -- 1E0h
--     gen_intreset5_dcd          <= cs AND XXX1 AND XXD AND X4; -- 1E4h
--     gen_intreset6_dcd          <= cs AND XXX1 AND XXD AND X8; -- 1E8h
--     gen_intreset7_dcd          <= cs AND XXX1 AND XXD AND XC; -- 1ECh
--     gen_intreset8_dcd          <= cs AND XXX1 AND XXD AND X0; -- 1F0h

     genint_wren_dcd            <= cs AND XXX1 AND XXF AND X4; -- 1F4h

------------------------- Head 1 Addresses ---------------------------

--     PE_reset1_dcd          	<= cs AND XXX0 AND XX0 AND X0; -- 000h
--     table_1_dcd            	<= cs AND XXX0 AND XX0 AND X4; -- 004h
--     image_addr1_dcd         	<= cs AND XXX0 AND XX0 AND XC; -- 00Ch
--     unused               	<= cs AND XXX0 AND XX1 AND X0; -- 010h
--     byte_count_store1_dcd  	<= cs AND XXX0 AND XX1 AND X4; -- 014h
     stroke_count_store1_dcd 	<= cs AND XXX0 AND XX1 AND X8; -- 018h
--     head_store1_dcd        	<= cs AND XXX0 AND XX1 AND XC; -- 01Ch
--     prod_store1_dcd        	<= cs AND XXX0 AND XX2 AND X0; -- 020h

     strk_trig_intreset_dcd   	<= cs AND XXX0 AND XXA AND X0; -- 0A0h
     strk_trig_flagreset_dcd  	<= cs AND XXX0 AND XXA AND XC; -- 0ACh

     image_intrpten1_dcd    	<= cs AND XXX0 AND XX3 AND X0; -- 030h
     image_intreset1_dcd    	<= cs AND XXX0 AND XX3 AND X4; -- 034h
     image_flagreset1_dcd   	<= cs AND XXX0 AND XX3 AND X8; -- 038h
     PR_intrpten1_dcd       	<= cs AND XXX0 AND XX3 AND XC; -- 03Ch
     PR_intreset1_dcd       	<= cs AND XXX0 AND XX4 AND X0; -- 040h
     PR_flagreset1_dcd     		<= cs AND XXX0 AND XX4 AND X4; -- 044h

     status_read1_dcd       	<= cs AND XXX0 AND XX5 AND X0; -- 050h
--     fault_read1_dcd        	<= cs AND XXX0 AND XX5 AND X4; -- 054h
     fault_reset1_dcd       	<= cs AND XXX0 AND XX5 AND X8; -- 058h
     NID_reset1_dcd         	<= cs AND XXX0 AND XX5 AND XC; -- 05Ch
     internal_stroke_store1_dcd <= cs AND XXX0 AND XX6 AND X0; -- 060h
--     message_tagbit1_dcd    	<= cs AND XXX0 AND XX6 AND X4; -- 064h
     image_print_abortff1_dcd 	<= cs AND XXX0 AND XX6 AND X8; -- 068h
     image_print_cmd1_dcd       <= cs AND XXX0 AND XX6 AND XC; -- 06Ch

     compare_enable1_dcd   		<= cs AND XXX0 AND XX7 AND X0; -- 070h
     compare_load1_dcd     		<= cs AND XXX0 AND XX7 AND X4; -- 074h
     capture_read1_dcd     		<= cs AND XXX0 AND XX7 AND X8; -- 078h

     NID_div_numerator1_dcd		<= cs AND XXX0 AND XX8 AND X8; -- 088h
     NID_div_denom1_dcd     	<= cs AND XXX0 AND XX8 AND XC; -- 08Ch


--     signal_led1_dcd        	<= cs AND XXX0 AND XXA AND XC; -- 0ACh

------------------------- Head 2 Addresses ---------------------------

--     PE_reset2_dcd          	<= cs AND XXX1 AND XX0 AND X0; -- 100h
--     table_2_dcd           	<= cs AND XXX1 AND XX0 AND X4; -- 104h
--     image_addr2_dcd           <= cs AND XXX1 AND XX0 AND XC; -- 10Ch 
--     unused               	<= cs AND XXX1 AND XX1 AND X0; -- 110h
--     byte_count_store2_dcd  	<= cs AND XXX1 AND XX1 AND X4; -- 114h
--     stroke_count_store2_dcd 	<= cs AND XXX1 AND XX1 AND X8; -- 118h
--     head_store2_dcd        	<= cs AND XXX1 AND XX1 AND XC; -- 11Ch
--     prod_store2_dcd        	<= cs AND XXX1 AND XX2 AND X0; -- 120h

--     image_intrpten2_dcd    	<= cs AND XXX1 AND XX3 AND X0; -- 130h
--     image_intreset2_dcd    	<= cs AND XXX1 AND XX3 AND X4; -- 134h
--     image_flagreset2_dcd   	<= cs AND XXX1 AND XX3 AND X8; -- 138h
--     PR_intrpten2_dcd       	<= cs AND XXX1 AND XX3 AND XC; -- 13Ch
--     PR_intreset2_dcd       	<= cs AND XXX1 AND XX4 AND X0; -- 140h
--     PR_flagreset2_dcd        <= cs AND XXX1 AND XX4 AND X4; -- 144h

     status_read2_dcd       	<= cs AND XXX1 AND XX5 AND X0; -- 150h
--     fault_read2_dcd        	<= cs AND XXX1 AND XX5 AND X4; -- 154h
--     fault_reset2_dcd       	<= cs AND XXX1 AND XX5 AND X8; -- 158h
--     NID_reset2_dcd         	<= cs AND XXX1 AND XX5 AND XC; -- 15Ch
--     internal_stroke_store2_dcd <= cs AND XXX1 AND XX6 AND X0; -- 160h
--     message_tagbit2_dcd    	<= cs AND XXX1 AND XX6 AND X4; -- 164h
--     image_print_abortff2_dcd <= cs AND XXX1 AND XX6 AND X8; -- 168h
--     image_print_cmd2_dcd     <= cs AND XXX1 AND XX6 AND XC; -- 16Ch

--     compare_enable2_dcd      <= cs AND XXX1 AND XX7 AND X0; -- 170h
--     compare_load2_dcd        <= cs AND XXX1 AND XX7 AND X4; -- 174h
--     capture_read2_dcd        <= cs AND XXX1 AND XX7 AND X8; -- 178h

--     NID_div_numerator2_dcd   <= cs AND XXX1 AND XX8 AND X8; -- 188h
--     NID_div_denom2_dcd     	<= cs AND XXX1 AND XX8 AND XC; -- 18Ch

--     signal_led2_dcd        	<= cs AND XXX1 AND XXA AND XC; -- 1ACh

--------------------------- Head 3 Addresses ---------------------------
--
--     PE_reset3_dcd          	<= cs AND XXX2 AND XX0 AND X0; -- 200h
--     table_3_dcd             	<= cs AND XXX2 AND XX0 AND X4; -- 204h
--     image_addr3_dcd          <= cs AND XXX2 AND XX0 AND XC; -- 20Ch 
--     unused               	<= cs AND XXX2 AND XX1 AND X0; -- 210h
--     byte_count_store3_dcd  	<= cs AND XXX2 AND XX1 AND X4; -- 214h
--     stroke_count_store3_dcd 	<= cs AND XXX2 AND XX1 AND X8; -- 218h
--     head_store3_dcd        	<= cs AND XXX2 AND XX1 AND XC; -- 21Ch
--     prod_store3_dcd        	<= cs AND XXX2 AND XX2 AND X0; -- 220h
--
--     image_intrpten3_dcd    	<= cs AND XXX2 AND XX3 AND X0; -- 230h
--     image_intreset3_dcd    	<= cs AND XXX2 AND XX3 AND X4; -- 234h
--     image_flagreset3_dcd   	<= cs AND XXX2 AND XX3 AND X8; -- 238h
--     PR_intrpten3_dcd       	<= cs AND XXX2 AND XX3 AND XC; -- 23Ch
--     PR_intreset3_dcd       	<= cs AND XXX2 AND XX4 AND X0; -- 240h
--     PR_flagreset3_dcd     	<= cs AND XXX2 AND XX4 AND X4; -- 244h
--
--     status_read3_dcd       	<= cs AND XXX2 AND XX5 AND X0; -- 250h
--     fault_read3_dcd        	<= cs AND XXX2 AND XX5 AND X4; -- 254h
--     fault_reset3_dcd       	<= cs AND XXX2 AND XX5 AND X8; -- 258h
--     NID_reset3_dcd         	<= cs AND XXX2 AND XX5 AND XC; -- 25Ch
--     internal_stroke_store3_dcd <= cs AND XXX2 AND XX6 AND X0; -- 260h
--     message_tagbit3_dcd    	<= cs AND XXX2 AND XX6 AND X4; -- 264h
--     image_print_abortff3_dcd <= cs AND XXX2 AND XX6 AND X8; -- 268h
--     image_print_cmd3_dcd 	<= cs AND XXX2 AND XX6 AND XC; -- 26Ch
--
--     compare_enable3_dcd   	<= cs AND XXX2 AND XX7 AND X0; -- 270h
--     compare_load3_dcd     	<= cs AND XXX2 AND XX7 AND X4; -- 274h
--     capture_read3_dcd     	<= cs AND XXX2 AND XX7 AND X8; -- 278h
--
--     NID_div_numerator3_dcd	<= cs AND XXX2 AND XX8 AND X8; -- 288h
--     NID_div_denom3_dcd     	<= cs AND XXX2 AND XX8 AND XC; -- 28Ch
--
--     signal_led3_dcd        	<= cs AND XXX2 AND XXA AND XC; -- 2ACh
--
--------------------------- Head 4 Addresses ---------------------------
--
--     PE_reset4_dcd          	<= cs AND XXX3 AND XX0 AND X0; -- 300h
--     table_4_dcd           	<= cs AND XXX3 AND XX0 AND X4; -- 304h
--     image_addr4_dcd          <= cs AND XXX3 AND XX0 AND XC; -- 30Ch 
--     unused                	<= cs AND XXX3 AND XX1 AND X0; -- 310h
--     byte_count_store4_dcd  	<= cs AND XXX3 AND XX1 AND X4; -- 314h
--     stroke_count_store4_dcd 	<= cs AND XXX3 AND XX1 AND X8; -- 318h
--     head_store4_dcd        	<= cs AND XXX3 AND XX1 AND XC; -- 31Ch
--     prod_store4_dcd        	<= cs AND XXX3 AND XX2 AND X0; -- 320h
--
--     image_intrpten4_dcd    	<= cs AND XXX3 AND XX3 AND X0; -- 330h
--     image_intreset4_dcd    	<= cs AND XXX3 AND XX3 AND X4; -- 334h
--     image_flagreset4_dcd   	<= cs AND XXX3 AND XX3 AND X8; -- 338h
--     PR_intrpten4_dcd       	<= cs AND XXX3 AND XX3 AND XC; -- 33Ch
--     PR_intreset4_dcd       	<= cs AND XXX3 AND XX4 AND X0; -- 340h
--     PR_flagreset4_dcd     	<= cs AND XXX3 AND XX4 AND X4; -- 344h
--
--     status_read4_dcd       	<= cs AND XXX3 AND XX5 AND X0; -- 350h
--     fault_read4_dcd        	<= cs AND XXX3 AND XX5 AND X4; -- 354h
--     fault_reset4_dcd       	<= cs AND XXX3 AND XX5 AND X8; -- 358h
--     NID_reset4_dcd         	<= cs AND XXX3 AND XX5 AND XC; -- 35Ch
--     internal_stroke_store4_dcd <= cs AND XXX3 AND XX6 AND X0; -- 360h
--     message_tagbit4_dcd    	<= cs AND XXX3 AND XX6 AND X4; -- 364h
--     image_print_abortff4_dcd <= cs AND XXX3 AND XX6 AND X8; -- 368h
--     image_print_cmd4_dcd 	<= cs AND XXX3 AND XX6 AND XC; -- 36Ch
--
--     compare_enable4_dcd   	<= cs AND XXX3 AND XX7 AND X0; -- 370h
--     compare_load4_dcd     	<= cs AND XXX3 AND XX7 AND X4; -- 374h
--     capture_read4_dcd     	<= cs AND XXX3 AND XX7 AND X8; -- 378h
--
--     NID_div_numerator4_dcd	<= cs AND XXX3 AND XX8 AND X8; -- 388h
--     NID_div_denom4_dcd     	<= cs AND XXX3 AND XX8 AND XC; -- 38Ch
--
--     signal_led4_dcd        	<= cs AND XXX3 AND XXA AND XC; -- 3ACh

END archaddrdcdm;
