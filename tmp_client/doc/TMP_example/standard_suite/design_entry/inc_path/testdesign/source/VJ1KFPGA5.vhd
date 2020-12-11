---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--		TOP LEVEL FILE
--
--      FOR THE LOW-END CIJ PLATFORM FPGA
--
--      VHDL DESIGN FILE :VJ1KFPGA5.VHD
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
-- LEFPGA1.VHD is the first rev. of the Low-End CIJ Printer main FPGA. This design
-- starts with the IPRO FPGA as a base.  It differs with the removal of the Stroke
-- Manager logic, followed by other modifications such as reduced I/O, a single
-- product detector and revised interrupts.
--
-- This FPGA resides on the controller board and is a peripheral of the one
-- and only processor.  That processor serves as both AP, IP and PE processor.
-- No stroke data DMA or Stroke Manager logic is needed.  Likewise, no SLIPP
-- port is needed.
--
-- LEAFPGA3.VHD is a revised Altera version of the design.  It now includes
-- the keyboard interface and Analog board interface.
--
-- VJ1K_FPGA1.VHD is revised for the Videojet 1000 Controller.  Changes include
-- expanded I/O for plug-in I/O expansion board, built-in USB port, etc.
--
-- Design files common to both families:
-- 
-- VJ1KFPGA4.VHD has revised clock system to generate 2.54MHz internal encoder ref.
-- clock and correct an error in internal 64 Hz PD clock. The AN_HIINTR has been
-- added to the high priority stroke interrupt logic. Also added resync logic to 
-- the an_io inputs.  This is to insure no meta-stability issues due to timing of
-- these signals from another clock base.  In addition, the Stroke interrupt
-- and flag are now made readable by the processor in one of the status words.
--
-- VJ1KFPGA5.VHD has revised pin assignments so that the programming port
-- is located at the most significant 8 bits of the Power PC bus.  This allows
-- programming through an eight bit memory space.
--
--	VJ1KFPGA5.VHD (top level)
--	altusr1out.vhd
--	addrdcdm.vhd
--  kbd7.vhd
--	ccomp10.vhd
--	div12.vhd
--	div20.vhd
--	encodr9.vhd
--	genint8.vhd
--	intctrl9.vhd
--	iologic10.vhd
--	nid8.vhd
--	prod11.vhd
--	speed8.vhd
--	smdmak.vhd
--	dmasyso.vhd

------------ Temporary Insert for TB Probe debugging -----------
	
library ieee;
use ieee.std_logic_1164.all;

-- Debug test signals - may be substituted when needed
--package probes is
--	signal P_dirout_main1 : std_logic;
--	signal P_hdwrcfg11_regen : std_logic;
--	signal P_quadrature_enableff_main1 : std_logic;
--	signal P_str_source_selff1 : std_logic;
--	signal P_enc_tick_main1 : std_logic;
--	signal P_err_tick_main1 : std_logic;
--	
--end package probes;

-- Debug test signals - may be substituted when needed
--package probes is
--	signal P_clk_halfmh_tick : std_logic;
--	signal P_clk_1mh_tick : std_logic;
--	signal P_clk_div3 : std_logic_vector(7 downto 0);
--	signal P_clk_div3_max : std_logic;
--	
--end package probes;


----------------------------- NOTE ------------------------------
----------------------- ONLY ONE HEAD INSTALLED -----------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use work.probes.all;

library synplify;
use synplify.attributes.all;

LIBRARY lpm;
USE lpm.lpm_components.all;

ENTITY vj1kfpga1 IS 
	generic(testing :boolean := false); -- temporary use for debugging within test bench

     port(       -- common inputs
	 -- mclk is now 33.0 MHz
	 -- slowclk will now be 32.768 KHz, generated in the RTC chip.
	 
        mclkin, slowclk, Nreset, Ncs, Nrdin, Nextreset : in std_logic;

        riwr, Nwrin, Nwbe1, Nwbe2, Nwbe3 : in std_logic;

        -- The main clock for this FPGA is the peripheral clock
        -- supplied by the IBM PPC405GPr.  This clock is programmable
        -- with respect to other internal processor clocks.  The
        -- nominal frequency will be 33.0MHz.  
        
        pd1in, pd2in, enca_main1, encb_main1    -- PD & Encoder inputs
        : in std_logic;       -- Head 1 inputs

        Npd1_filtered, Npd2_filtered, -- Potential to recover 2 more IO pins if needed
		
		-- Have LEDs attached
        image_print_done1,   -- Head 1 output
		dir_out_main1, Ninternal_encoding, count_zero_led1 : out std_logic;
											
        -- external interrupts

        Nintr_req_hd1, 	   -- Head 1 output
		Nintr_kbd_io, Nintr_stroke : out std_logic;

        -- common inputs and outputs

		Ngenin: in std_logic_vector(8 downto 0);

		Ngen_out: out std_logic_vector(7 downto 0);
		
		Nexp_type_in: in std_logic_vector(2 downto 0);  
		
		Nio_reserved: in std_logic;	 -- spare input or output assert needed
		
		Ntri_red, Ntri_yel, Ntri_grn, Nsiren : out std_logic;

--        datab : inout std_logic_vector(31 downto 0);
        data : inout std_logic_vector(31 downto 0);
        addr : in std_logic_vector(11 downto 1);

	  -- Keyboard Interface

        col : out std_logic_vector(8 downto 1);
        row : in std_logic_vector(8 downto 1);
	  
        Nkbd_alt_in, Nkbd_ctrl_in, Nkbd_shift_in : in std_logic;
		Nkbd_beep_out :out std_logic;
			  		  
        -- Print Engine (Analog Board) Interface
	  
        an_io_in : in std_logic_vector(10 downto 0);

		-- Unused general input pins reserved by treating
		-- them as outputs, driven high in the logic
		
		Spare_pin: out std_logic_vector(1 downto 0);

		Nintr_req_hd2, image_print_done2, -- unused, but reserved by name

        -- Unused outputs that must be driven

        bus_req, Nextreq,
        hold_pri, per_err, drq0, drq1 : out std_logic);

--	attribute pinnum of Nreset : signal is "RESETN";
------------	attribute loc of Nreset : signal is "RESETN";

--    attribute  clock_buffer: boolean;
--    attribute  syn_isclock of clk32mh:signal  is true;
    attribute  syn_isclock of mclkin:signal is true;

	attribute  altera_chip_pin_lc of addr: signal is
"@9,@11,@12,@13,@14,@15,@17,@18,@28,@31,@189";
	attribute  altera_chip_pin_lc of slowclk: signal is "@183";
	attribute  altera_chip_pin_lc of Nextreset: signal is "@112";
-- TEMPORARY COMMENT DUE TO ALDEC NOT ACCEPTING ALTERA ATTRIBUTE FORM
--	attribute  altera_chip_pin_lc of datab: signal is  
	attribute  altera_chip_pin_lc of data: signal is  
"@166,@164,@162,@161,@159,@158,@157,@191,@133,@30,@74,@134,@85,@128,@54,@127,@139,@175,@174,@88,@143,@148,@97,@96,@163,@167,@172,@176,@116,@69,@70,@75";
	attribute  altera_chip_pin_lc of bus_req: signal is "@100";
	attribute  altera_chip_pin_lc of count_zero_led1: signal is "@40";
	attribute  altera_chip_pin_lc of dir_out_main1: signal is "@45";		
	attribute  altera_chip_pin_lc of enca_main1: signal is "@94";		
	attribute  altera_chip_pin_lc of encb_main1: signal is "@89";		
	attribute  altera_chip_pin_lc of Nextreq: signal is "@63";		
	attribute  altera_chip_pin_lc of mclkin: signal is "@79";
	attribute  altera_chip_pin_lc of Ngenin: signal is
"@197,@126,@184,@135,@136,@141,@142,@92,@104";
	attribute  altera_chip_pin_lc of Ngen_out: signal is
"@202,@29,@150,@147,@111,@115,@113,@125";

	attribute  altera_chip_pin_lc of Nio_reserved: signal is
"@203";
	attribute  altera_chip_pin_lc of Nexp_type_in: signal is 
"@122,@132,@102";
--	attribute  altera_chip_pin_lc of Nio_exp_installed: signal is "@102";
	attribute  altera_chip_pin_lc of Spare_pin: signal is 
"@16,@190";
	attribute  altera_chip_pin_lc of Nintr_req_hd2: signal is "@73"; 
	attribute  altera_chip_pin_lc of image_print_done2: signal is "@103";
	attribute  altera_chip_pin_lc of hold_pri: signal is "@26";
	attribute  altera_chip_pin_lc of image_print_done1: signal is "@87";
	attribute  altera_chip_pin_lc of Nintr_req_hd1: signal is "@8";
	attribute  altera_chip_pin_lc of drq0: signal is "@56";
	attribute  altera_chip_pin_lc of drq1: signal is "@47";
	attribute  altera_chip_pin_lc of Nintr_kbd_io: signal is "@25";
	attribute  altera_chip_pin_lc of Ncs: signal is "@208";
	attribute  altera_chip_pin_lc of Nrdin: signal is "@204";
	attribute  altera_chip_pin_lc of Nwrin: signal is "@206";
	-- Next two pins can be made available if we are short,
	-- since they are no longer wired on the board.
	attribute  altera_chip_pin_lc of Npd1_filtered: signal is "@71";
	attribute  altera_chip_pin_lc of Npd2_filtered: signal is "@140";
	attribute  altera_chip_pin_lc of pd1in: signal is "@53";
	attribute  altera_chip_pin_lc of pd2in: signal is "@160";
	attribute  altera_chip_pin_lc of per_err: signal is "@36";
	attribute  altera_chip_pin_lc of riwr: signal is "@67";
	attribute  altera_chip_pin_lc of Nintr_stroke: signal is "@68";
	attribute  altera_chip_pin_lc of Ntri_grn: signal is "@95";
	attribute  altera_chip_pin_lc of Ntri_red: signal is "@169";
	attribute  altera_chip_pin_lc of Ntri_yel: signal is "@168";
	attribute  altera_chip_pin_lc of Nsiren: signal is "@93";

	attribute  altera_chip_pin_lc of Nwbe1: signal is "@37";
	attribute  altera_chip_pin_lc of Nwbe2: signal is "@46";
	attribute  altera_chip_pin_lc of Nwbe3: signal is "@83";
	attribute  altera_chip_pin_lc of Ninternal_encoding: signal is "@199";
	attribute  altera_chip_pin_lc of Nreset: signal is "@180";
	attribute  altera_chip_pin_lc of Nkbd_alt_in: signal is "@78";
	attribute  altera_chip_pin_lc of Nkbd_ctrl_in: signal is "@80";
	attribute  altera_chip_pin_lc of Nkbd_shift_in: signal is "@182";
	attribute  altera_chip_pin_lc of Nkbd_beep_out: signal is "@205";

	attribute  altera_chip_pin_lc of row: signal is 
"@114,@101,@60,@58,@27,@24,@10,@7";

	attribute  altera_chip_pin_lc of col: signal is 
"@170,@149,@144,@131,@121,@65,@64,@38";

	attribute  altera_chip_pin_lc of an_io_in: signal is 
"@200,@198,@196,@193,@192,@187,@90,@86,@179,@177,@173";

END vj1kfpga1;

ARCHITECTURE archvj1kfpga1 OF vj1kfpga1 IS

	-- This attribute was added due to multiple reset inputs; it was
	-- needed to allow the automatic use of GSR.

--	attribute syn_hier of archvj1kfpga1: architecture is "remove";

    SIGNAL   rdoe, reset, bus_grant, clk8mh_tick, mclk, dataoe_m,
             high, low, douten1, douten2, dataoe, Nas, del1in, nwr1in,
             datsel, datsel1, datsel2, enca1, encb1, Nrd, Nrd_del,
             Nwr_del, Nwr_del1, Nwr_del2, Nwr, clk125kh_del, clk125kh_tick,
			 clk_halfmh_tick, clk_halfmh_del, clk1kh_tick, clk1kh_del,
             clk500h_tick, clk500h_del, clk125h_tick, clk125h_del,
             clk2kh_del1, clk2kh_del2, clk2kh_tick, clk181hz_tick,
             clk181hz_toggle, dma_addr_gate, strk_trig_hd1, clk1_45kh_del,
             strk_trig_hd2,  div_tick_hd1, clk32kh_high, clk128kh_high,
			 clk5mh_del, clk5mh_tick, clk10mh_tick, clk2_9kh_high,
             clk128kh_tick, clk128kh_del1, clk128kh_del2, clk2_9kh_del,
             clk32kh_tick, clk32kh_del1, clk32kh_del2, clk2_9kh_tick,
			 clk2_9kh_del1, clk2_9kh_del2, clk1_45kh_tick, clk1_45kh_del1, 
             clk1_45kh_del2, clk1_45kh_toggle, clk1_45kh_high,
             clk362hz_tick, clk362hz_del, clk1mh_tick, clk1mh_del, 
             clk16kh_tick, clk16kh_del1, clk16kh_del2, clk362h_high,
			 clk64h_del1, clk64h_del2, clk64h_tick,
			 clk2_54mh_high, clk2_54mh_del1, clk2_54mh_del2, clk2_54mh_tick,
			 err_tick_main1, clk181h_high, overspeed_detect_enable, overspeed_reset,
             ccomp_in_tick1, internal_pd1_tick, internal_pd1_pulse,
			 interval1_50msec, interval2_50msec, limit_detectff,
			 pd1_edge_wide, char_send_ready1, internal_prod_store1_dcd,
             auto_limit1, internal_pd1_wide, pd1_select,
             pd1_filtered, pd2_filtered, reverse_printff1,
			 pr_intrpten1_dcd, pr_intreset1_dcd, pr_flagreset1_dcd,
             reverse_printff2, auto_reset1, auto_reset2,
			 spare_intr, pe_reset1_dcd, bb1, bb2, dma_rd,
		  	 input_config1_dcd, output_config2_dcd, outsrc_config3_dcd,
        	 outctrl_config4_dcd, intr_spare, spare_intrin,
			 intr_in_clr_dcd, flag_in_clr_dcd, input_read_dcd,
		  	 interrupt_read_io_dcd, pe1_ready_intr, pe1_ready_change,
             image_abort_reqff1, strokes_abortedff1, abort_start1,
             abort_set, image_print_done1_gated, image_print_done2_gated,
             image_print_abort1_in, header_done, data_done, rolloverff1,
             print_start1, total_image_done1, Ntotal_done_enable1,
			 strk_trig_intr_clr, strk_trig_flag_clr, strk_trig_intr_flag, 
			 set_strk_trig_overlap_fault, strk_trig_overlap_fault, kbdio_intr,
			 kbiod_intrpten1_dcd, kbdio_flagreset1_dcd, kbdio_intreset1_dcd,
			 pr1_int_flag, pd1_int_flag, pd2_int_flag, kbdio_intr_flag, kbdio_intr_clr,
	         kbd_fifo_read_dcd, AN_io_read_dcd, AN_intrpten1_dcd, 
			 AN_hiflagreset1_dcd, AN_hiintreset1_dcd, AN_loflagreset1_dcd, 
			 AN_lointreset1_dcd, ANintr_enable, AN_intrpt_en, kbdio_flag_clr,
			 AN_hiintr_clr, AN_hiflag_clr, AN_hiintr_flag1, 
			 AN_hiintr, set_AN_hiintr_overlap_fault, kbdio_intr_enable,
			 AN_lointr_clr, AN_loflag_clr, AN_lointr_flag1, 
			 AN_lointr, set_AN_lointr_overlap_fault,
			 stroke_ci_L, send_stop_wr, multi_stroke_done, KBD_reg_read_strobe,
			 reload_stroke_count, print_start, image_done, Nstrk_trig_hd1,
		 	 kbdio_int_trig, kbd_fifo_clr_strobe, kbdio_intrpt_en,
		 	 AN_wd_flag, AN_drop_clock, AN_hiintr_in, AN_lointr_in,
			 imageprint_done1, Nintrreq_hd1, Nintrreq_hd2, Nintrio,
			 Ngenout0, Ngenout2, Ntrired, Ntriyel, Ntrigrn, 
			 clk_div3_max, Nsiren_temp, internal_pd_typeff1, 
			 internal_pd_type_selectff1, slowclk_tick, pd1in_tick,
		     kbdsig1, kbdsig2, kbdsig3, kbdsig4, kbdsig5, kbdsig6, kbdsig7,
			 keyboard_beep_enable, key_down_click, beep_dcd, soft_beep : std_logic;

-- Head 1 Address Decode Signals --

     SIGNAL pd1_intrpt_en, Nbg1, Nbg, dipbuf1, bg1,
             pd1_intr_clr, pd1_flag_clr, strk_trig_hd1_gated,
             pr1_intrpt_en, pr1_intr_clr, pr1_flag_clr, 
             sel_data1_addr, sel_table1_addr,   
             pd_invff1, pd_invff2, pd_lead_edge_selff1, pd_lead_edge_selff2, 
			 pd_selectff2, set_pd1_overlap_fault,
 			 set_pd1_bounce_warning, set_pd2_overlap_fault,
 			 set_pd2_bounce_warning, set_pr1_overlap_fault,
 			 pd2_int_enabled, printer_readyff1, print_enableff1,

 			 image_print_abortff1, stroke_invertff1,
 			 reverse_dirff1, reverse_dirff_main1, enc_dir_invff_main1,
             str_source_selff1, quadrature_enableff1, pd_selectff1,
             encoder_selectff1, availableff1a, autoencode_mode_ff1,
             internal_pd_selectff1, genint_wren_dcd, kbdio_intrpten1_dcd,
             interrupt_read1_dcd, hdwr_config1_dcd,	speed_limit1_dcd,
			 image_print_abortff1_dcd, full_message_aborted1, speedlimit1_regen,
             coa1, fault_reset1_regen, autoencode_read1_dcd,
             autocount1, autorestart1, pd1_overlap_fault, nid_out_tick1,
             pr1_overlap_fault, pd1_bounce_warning, pd1_edge_tick,
             enc_tick1, enc_tick_main1, Nnidclear1,
             autoenable1, coauto1, enc_tick_hd1, image_int_flag1,
             pd1_filtered_del, autoenc_restart1, nid_reset1,
             hdwrcfg10_regen, hdwrcfg11_regen, count_zero1,
             count_zero_main1, nid_in_tick1, pd1_edge_pulse,
             NID_div_numer1_regen, NID_div_denom1_regen,
             quadrature_enableff_main1, quadratureenableff_main1, print_image1_intr,
             image_intrpten1_dcd, encodercount_read1_dcd,
             backlash_intrpten1_dcd, pe1_ready_to_ip_m, pe1_ready_to_ipm,
             backlash_intreset1_dcd, backlash_flagreset1_dcd,
             backlash_max1, Npr1_match,
             compare_enable1_dcd, compare_load1_dcd, capture_read1_dcd,
             speed_read1_dcd, internal_prod_store1_regen,
             internal_pd_inhibit1, 
             internal_pd1, imageintr1_enable, pd1_enable,
             pd2_enable, pr1_enable, backlash1_intrpt_en, 
             internal_stroke1_tick, internal_stroke_store1_regen,
             internal_stroke_store1_dcd, setup_transfer1,
             stroke_packet_done1, io_intr, availableff1b,
		 genintr_data0, genintr_en0, internal_enc_inhibit1,
             genintr_data1, genintr_en1, genintr1_clr, genflag1_clr,
             print_enable_gated1, image_print_abort1_dcd,
             rollover_clear1_dcd, image_print_cmd1_dcd,
             buffer_hdwr_config1_dcd, strk_trig_intr,
             hdwrbufcfg1_regen, strk_trig_intreset_dcd,
		     strk_trig_flagreset_dcd, dirout_main1 : std_logic;

-- Head 1 register data


	 SIGNAL fifo_reg_out : std_logic_vector(9 downto 0);
	 SIGNAL Nexp_type, Nexp_type_temp : std_logic_vector(2 downto 0);

     SIGNAL addr_m : std_logic_vector(9 downto 2);

     SIGNAL col_temp : std_logic_vector(16 downto 1);
	 
     SIGNAL byte_count_read1, rowtemp : std_logic_vector(7 downto 0);
     SIGNAL data_addr1, table_addr1, sendreg1, dataout, io_status,
     		status_read_input, status_read1, fault_read1
            : std_logic_vector(31 downto 0);
     SIGNAL capture_data1 : std_logic_vector(19 downto 0);
     SIGNAL speed_data1, speed_limit1, coltemp : std_logic_vector(15 downto 0);
     SIGNAL internal_prod_store1 : std_logic_vector(19 downto 0);
     SIGNAL datamuxctrl1 : std_logic_vector(12 downto 0);
	 SIGNAL intr_hd1_vector : std_logic_vector(4 downto 0);
	 
	 SIGNAL Nio_reserved_temp : std_logic;
	 SIGNAL Ngenout : std_logic_vector(7 downto 0);
	 SIGNAL intr_input_reg : std_logic_vector(9 downto 0);
	 SIGNAL input_filtered : std_logic_vector(9 downto 0);
	 SIGNAL input_flag_reg : std_logic_vector(9 downto 0);
	 SIGNAL an_io_1, an_io : std_logic_vector(10 downto 0);
     SIGNAL abortmode1, inhibitmode1 : std_logic_vector(1 downto 0);
	 SIGNAL multi_stroke_reg1 : std_logic_vector(3 downto 0);
     SIGNAL NID_div_numerator1, NID_div_num_buff1, internal_stroke_store1 
            : std_logic_vector(11 downto 0);
     SIGNAL NID_div_denom1, NID_div_denom_buff1 
            : std_logic_vector(7 downto 0);
     SIGNAL hdwr_buff_config1 : std_logic_vector(4 downto 0);			 
     SIGNAL hdwr_buff_set1 : std_logic_vector(4 downto 0);			 

     SIGNAL stroke_count_store1, stroke_count_read1
                : std_logic_vector(15 downto 0);
 
--& although autoencode1 has been declared as 20 bits
--& due to ldupcnt building blocks available, only 18 are used
     SIGNAL autoencode1 : std_logic_vector(19 downto 0);

     SIGNAL encoder_count : std_logic_vector(19 downto 0);

     SIGNAL hdwr_config1 : std_logic_vector(18 downto 0);

     SIGNAL common_read : std_logic_vector(31 downto 0);

	attribute syn_keep : boolean;
    attribute syn_keep of data : SIGNAL IS true;



-- Head 2 Address Decode Signals --

     SIGNAL pd2_intrpt_en, iwait2, ibg2, dipbuf2, bg2,
             pd2_intr_clr, pd2_flag_clr, Nbg2,
             pr2_intrpt_en, pr2_intr_clr, pr2_flag_clr,
             encoder_selectff2, fault_reset2_regen, interrupt_read2_dcd,
             hdwr_config2_dcd, coa2, autocount2, image_print_abortff2_dcd,
             autoencode_read2_dcd, autorestart2, pd2_overlap_fault,
             pr2_overlap_fault, pd2_bounce_warning, pd2_edge_tick,
             coauto2, autoenc_restart2, inidclear2,
             hdwrcfg23_regen, count_zero2, 
             count_zero_main2 : std_logic;

-- Head 2 register data

--     SIGNAL byte_count_read2 : std_logic_vector(7 downto 0);
--     SIGNAL data_addr2, table_addr2, sendreg2, status_read2,
--            fault_read2 : std_logic_vector(31 downto 0);

     SIGNAL status_read2 : std_logic_vector(31 downto 0);
     SIGNAL hdwr_config2 : std_logic_vector(18 downto 0);


--     SIGNAL intr_hd2_vector : std_logic_vector(4 downto 0);
--     SIGNAL datamuxctrl2 : std_logic_vector(4 downto 0);
--     SIGNAL SLI_baudrate2 : std_logic_vector(1 downto 0);
--     SIGNAL NID_div_numerator2 : std_logic_vector(11 downto 0);
--     SIGNAL NID_div_denom2 : std_logic_vector(7 downto 0);
--     SIGNAL intr1_vector : std_logic_vector(8 downto 0);
--
--     SIGNAL  head_store2, prod_store2 : std_logic_vector(7 downto 0);
--       
--     SIGNAL stroke_count_store2, stroke_count_read2,
--	 autoencode2 : std_logic_vector(19 downto 0);
--
-- Multiplexing Control Words

     SIGNAL slimuxctl : std_logic_vector(19 downto 0);
     SIGNAL addrout : std_logic_vector(31 downto 0);
     SIGNAL clear8, clk_div3 : std_logic_vector(7 downto 0);
     SIGNAL clk_div2 : std_logic_vector(1 downto 0);
     SIGNAL clear4, clk_div4, clk_div5, clk_div6 : std_logic_vector(3 downto 0);
     SIGNAL clk_div64 : std_logic_vector(8 downto 0);
     SIGNAL bg_reg : std_logic_vector(1 downto 0);
     SIGNAL clk_div1 : std_logic_vector(7 downto 0);

     ALIAS address: std_logic_vector(8 downto 2) is addr(8 downto 2);

 	SIGNAL   clk1mh_del1, clk1mh_del2, clk1mh_del3,
             clk_halfmh_del1, clk_halfmh_del2, clk_halfmh_del3,
             table_addr1_dcd, image_addr1_dcd, 
             stroke_count_store1_dcd,
             byte_count_read1_dcd, stroke_count_read1_dcd,
             status_read1_dcd, Fault_read1_dcd, Fault_reset1_dcd,
             NID_reset1_dcd, NID_div_numerator1_dcd, NID_div_denom1_dcd,

             pd_intrpten1_dcd, pd_flagreset1_dcd, pd_intreset1_dcd,
             backlash_reset1_dcd, backlash_clr_main1 : std_logic;

 	SIGNAL   table_addr2_dcd, image_addr2_dcd,
             byte_count_store2_dcd, stroke_count_store2_dcd,
             head_store2_dcd, prod_store2_dcd, byte_count_read2_dcd,
             stroke_count_read2_dcd, status_read2_dcd, Fault_read2_dcd,
             Fault_reset2_dcd, NID_reset2_dcd, NID_div_numerator2_dcd,
             NID_div_denom2_dcd, pd_intrpten2_dcd,
             pd_flagreset2_dcd, pd_intreset2_dcd, pr_intrpten2_dcd,
             pr_intreset2_dcd, pr_flagreset2_dcd, pe_reset2_dcd,
             backlash_reset2_dcd, backlash_clr_main2,
             image_intreset1_dcd, image_flagreset1_dcd,
             image_intreset2_dcd, image_flagreset2_dcd,
             image1_intrpt_en, image2_intrpt_en, image1_intr_clr,
             image1_flag_clr, image2_intr_clr, image2_flag_clr,
             set_image1_overlap_fault, set_image2_overlap_fault,
             backlash_max2, backlash1_intr_enable,
             backlash1_intr_clr, backlash1_flag_clr, backlash1_int_flag,
             backlash1_intr, backlash2_int_flag, backlash_max2_intr,
			 common_read_dcd, io_exp_installed : std_logic;

	SIGNAL intr_wr_enable,
        pr1_intr, pr1_intr_gated, pr1_match,
        pr2_match, pd1_intr, pd2_intr,
        image1_intr, image1_intr_gated, image2_intr_gated, image2_intr,
        backlash_max1_intr, savesum, autoencode_overflow1, 
        autoencode_overflow2, genintr0_clr, genflag0_clr,
        spare_intr_enabled, spare_intr_flag, set_overlap1_fault0,
        
        spareintr_m, ipr1match, 
        ipr2match, pr1match_m, pr2match_m, spare_fault_set : std_logic;
        
--    SIGNAL spareintrm, pr1matchm,
--        pr2matchm, image_print_done2m,
--        pr1_init : std_logic;

    SIGNAL intr1_enabled, intr1_flag, set_overlap1_fault
        : std_logic_vector(6 downto 0); 


    type autoctrlstates is (idle, restart, restart_end, count,
							 count_status);

--	ATTRIBUTE syn_enum_encoding of autoctrlstates:type is "onehot";

	SIGNAL autostate1 : autoctrlstates;
	SIGNAL autostate2 : autoctrlstates;

--    attribute syn_keep of coa1, coa2, dataoe, datsel1, datsel2,
--       autoenable1, autoenable2, pr1_init, auto_limit1, 
--       -- genintr8_clr, genintr7_clr,
--       -- genintr6_clr, genintr3_clr, genintr2_clr, genintr1_clr,
--       -- genintr0_clr, genflag8_clr, genflag7_clr,
--       -- genflag6_clr, genflag3_clr, genflag2_clr, genflag1_clr,
--       -- genflag0_clr, 
--       div_tick_hd1, char_send_ready1,
--      set_pr1_overlap_fault, set_pr2_overlap_fault,
--       set_pd1_overlap_fault, set_pd2_overlap_fault,
--       set_pd1_bounce_warning, set_pd2_bounce_warning,
--       set_overlap1_fault8, set_overlap1_fault7,
--       set_overlap1_fault6, set_overlap1_fault5,
--       set_overlap1_fault4, set_overlap1_fault3,
--       set_overlap1_fault2, set_overlap1_fault1,
--	   intr_wr_enable, image1_intrpt_en, pr1_intrpt_en,
--	   pd2_intrpt_en, pd1_intrpt_en : SIGNAL IS true;


COMPONENT enreg4
	port(d : in std_logic_vector(3 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(3 downto 0));
END COMPONENT;

COMPONENT enreg1
	port(d : in std_logic;
		 en, clk, Nreset : in std_logic;
		 q : out std_logic);
END COMPONENT;

COMPONENT enreg2
	port(d : in std_logic_vector(1 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(1 downto 0));
END COMPONENT;

COMPONENT enreg8
	port(d : in std_logic_vector(7 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(7 downto 0));
END COMPONENT;

COMPONENT enreg16
	port(d : in std_logic_vector(15 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(15 downto 0));
END COMPONENT;

COMPONENT upcnt4
	port(en, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(3 downto 0));
END COMPONENT;

COMPONENT upcnt8
	port(en, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(7 downto 0));
END COMPONENT;

COMPONENT ldupcnt8
	port(d : in std_logic_vector(7 downto 0);
		 en, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(7 downto 0));
END COMPONENT;

COMPONENT ldupcnt4
	port(d : in std_logic_vector(3 downto 0);
		 en, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(3 downto 0));
END COMPONENT;
                   
COMPONENT addrdcdm
    port(addr : in  std_logic_vector(11 downto 2);
        Ncs : in std_logic;
       
        -- Common Outputs

        hdwr_config1_dcd, common_read_dcd,
		input_config1_dcd, output_config2_dcd, outsrc_config3_dcd,
        outctrl_config4_dcd, intr_in_clr_dcd, flag_in_clr_dcd,
        input_read_dcd,	genint_wren_dcd, beep_dcd,

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
END COMPONENT;

COMPONENT dmasyso
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
END COMPONENT;


COMPONENT prod2
    PORT(mclk, Nreset, pd, pd_inv, pd_lead_edge_sel, enc_tick_choice,
		enable_in, pd_intr_clr, pd_flag_clr : in std_logic;
		set_pd_overlap_fault, set_pd_bounce_warning,
		pd_int_flag, pd_intr, pd_filtered, pd_edge_tick : out std_logic);
END COMPONENT;

COMPONENT prod4
    PORT(mclk, Nreset, pd, pd_inv, pd_lead_edge_sel, enc_tick_choice,
		enable_in, pd_intr_clr, pd_flag_clr, bypass_filter : in std_logic;
		set_pd_overlap_fault, set_pd_bounce_warning,
		pd_int_flag, pd_intr, pd_filtered, pd_edge_tick : out std_logic);
END COMPONENT;

COMPONENT prreq2
    PORT(mclk, Nreset, pr_match, enable_in,
		pr_intr_clr, pr_flag_clr : in std_logic;
		pr_int_flag, pr_intr, set_pr_overlap_fault : out std_logic);
END COMPONENT;

COMPONENT encoder9
     port(mclk, Nreset, enca_in, encb_in, dir_in, dir_invert,
		  qdrtr_enable, backlash_clr : in std_logic;
		  enc_tick, dir_out, err_tick, count_zero,
          backlash_max : out std_logic );
END COMPONENT;

COMPONENT nid8
    port(Nreset, enc_tick, mclk : in std_logic;
        enc_rate : in std_logic_vector(11 downto 0);
        out_rate_in : in std_logic_vector(7 downto 0);
        div_enc : out std_logic );
END COMPONENT;

COMPONENT intreq2 PORT(
		mclk, Nreset, intr_input, enable_in,
		intr_clr, flag_clr : in std_logic;
		intr_enabled, intr_flag, set_overlap_fault, intr : out std_logic);
END COMPONENT;

COMPONENT intr_control9
    PORT(mclk, Nreset, pr1_intr, pd1_intr, 
		image1_intr, backlash_max1_intr, AN_hiintr, AN_lointr,
		strk_trig_intr, kbdio_intr : in std_logic; 
		
		intr_input_reg : in std_logic_vector(9 downto 0);

        Nintr_req_hd1, Nintr_kbd_io, Nintr_stroke : out std_logic);
END COMPONENT;

COMPONENT divide12
    port(Nreset, enc_tick, mclk, inhibit : in std_logic;
        divider : in std_logic_vector(11 downto 0);
        div_enc : out std_logic );
END COMPONENT;

COMPONENT divide20
    port(Nreset, enc_tick, mclk, inhibit : in std_logic;
        divider : in std_logic_vector(19 downto 0);
        div_enc : out std_logic );
END COMPONENT;

COMPONENT pulse1us
	PORT (mclk, Nreset, clk1mh_tick, pulse_in : in std_logic;
		pulse_out : out std_logic);
    END COMPONENT;

COMPONENT pulse_1ms
	PORT (mclk, Nreset, clk16kh_tick, pulse_in : in std_logic;
		pulse_out : out std_logic);
	END COMPONENT;

COMPONENT GSR IS
    PORT(GSR: std_logic);
END COMPONENT;

COMPONENT ccomp10 IS
    PORT(mclk, Nreset, enc_tick, pd_edge,
        Nwr, print_enable, compare_enable_dcd,
    	compare_load_dcd, rollover_clear_dcd  : in std_logic;
        data : in std_logic_vector(19 downto 0);
        Npr_match, rolloverff : out std_logic;
        capture_data, encoder_count : out std_logic_vector(19 downto 0));
END COMPONENT;                         

COMPONENT speed8 IS
    PORT(mclk, Nreset, enc_tick, clk2kh_tick, overspeed_detect_enable, 
		overspeed_reset : in std_logic;
		speed_limit : in std_logic_vector(15 downto 0);
        speed_data : out std_logic_vector(15 downto 0);
        limit_detectff : out std_logic);
END COMPONENT;                         

COMPONENT iologic10 IS
    PORT(mclk, Nwr, Nreset, input_config1_dcd,
        output_config2_dcd,	outsrc_config3_dcd, outctrl_config4_dcd,
        intr_in_clr_dcd, flag_in_clr_dcd,
		clk1mh_tick, clk2kh_tick, clk2_9kh_tick, clk1_45kh_tick,
        clk362hz_tick, clk181hz_tick, print_enable1,
        image_done1 : in std_logic;

        Ngenin : in std_logic_vector(8 downto 0);

        data : in std_logic_vector(31 downto 0);

        Ngen_out : out std_logic_vector(7 downto 0);
        Ntri_red, Ntri_yel, Ntri_grn, Nsiren : out std_logic;
        
        input_filtered : out std_logic_vector(8 downto 0);
        intr_input_reg : out std_logic_vector(8 downto 0);
        input_flag_reg : out std_logic_vector(8 downto 0) );
END COMPONENT;                         

COMPONENT selector_4
    PORT(mclk, Nreset, enable, 
        input0, input1, input2, input3: in std_logic;
        selector :std_logic_vector(1 downto 0);
		sel_out : out std_logic);
END COMPONENT;

COMPONENT kbd7 IS
	port(mclk, Nreset, scan_col_tick, kbd_intr, kbd_intr_flag,
		Nkbd_alt_in, Nkbd_ctrl_in, Nkbd_shift_in : in std_logic;

		kbd_int_trig, key_down_click : out std_logic;

		col : out std_logic_vector(7 downto 0);

		rowin : in std_logic_vector(7 downto 0);

		KBD_reg_read_strobe, KBD_fifo_clr_strobe : in std_logic;

		-- debug outputs

		kbdsig1, kbdsig2, kbdsig3, kbdsig4, kbdsig5, kbdsig6, kbdsig7 : out std_logic;

	    fifo_reg_out : out std_logic_vector(9 downto 0));
END COMPONENT;

------------------------- Common Constants ---------------------------

     CONSTANT revision_code : std_logic_vector(15 downto 0) 
                            := "0000000000000010"; -- 0002h

    BEGIN  
		------------------------Temporary Debugging -------------------------------

-- Debug test signals - may be substituted when needed

--	test: if(testing) generate	
--		P_dirout_main1 <= dirout_main1;
--		P_hdwrcfg11_regen <= hdwrcfg11_regen;
--		P_quadrature_enableff_main1 <= hdwr_config1(3);
--		P_str_source_selff1 <= str_source_selff1;
--		P_enc_tick_main1 <= enc_tick_main1;
--		P_err_tick_main1 <= err_tick_main1;
--	end generate test;
		
---------------------------- Miscellaneous -------------------------------

	 reset <= not(Nreset);
     mclk <= mclkin;

	 spare_intrin <= '0'; -- spare interrupt source, unused at present;

     clear8 <= (others=> '0');
     clear4 <= (others=> '0');

     high <= '1';
     low  <= '0';

-- Add input pull up resistors to DIP option jumpers by instantiating
-- a Lucent IBMPU, an input buffer with pull up resistor.


----------------------- UNUSED OUTPUTS ------------------------------------

	hold_pri <= '0';
	per_err  <= '0';
	drq0  <= '0';
	drq1  <= '0';

	Spare_pin <= "11";
	Nintr_req_hd2 <= '1'; 
	image_print_done2 <= '1';

--------------------- Expansion Board Type Input Resync -----------------

	exp_sync : process (mclk, Nreset)
	BEGIN
	if(Nreset='0') then
		Nexp_type <= "111"; -- assumes active low signals
		Nexp_type_temp <= "111"; -- assumes active low signals
	elsif(rising_edge(mclk)) then
		Nexp_type_temp <= Nexp_type_in;
		Nexp_type <= Nexp_type_temp;
	end if;
	END process exp_sync;

----------------------- Clock Sync of inputs -----------------------------

    del1in <= Nwrin OR riwr; 

    nwr1in  <= del1in OR not(Nwr_del1); -- DeMorganized lead edge detect of
                                          -- an active low pulse.

    sync2mclk : process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
		Nrd  <= '1';
		Nwr  <= '1';
        Nwr_del1 <= '1';
	elsif(rising_edge(mclk)) then
        Nrd <= Nrdin;          
        Nwr_del1 <= del1in;   
        Nwr <= nwr1in;
    end if;
    END process sync2mclk;

----------------------- Master Clock Divide ------------------------------

    -- Allow for the possibility of deriving a 64 MHz clock using
    -- the 3T series internal phase-locked loop, using 32 MHz input.
    -- Then 32 MHz clock should actually be derived by dividing the
    -- 64 MHz clock by two.  This is necessary unless the phase
    -- relationship between 64 MH and 32 MH is useable for the SLIPP
    -- logic module.

--	masterclk2: process(mclk, Nreset)
--    BEGIN
--	if(Nreset='0') then
--		Nrd  <= '1';
--		Nwr  <= '1';
--        Nwr_del1 <= '1';
----        Nwr_del2 <= '1';
--	elsif(rising_edge(mclk)) then       -- used to resync. mclk to uP CLK1
--        Nrd <= Nrdin;                   -- which rises prior to each read
--        Nwr_del1 <= del1in;             -- or write strobe edge.  Above
----        Nwr_del2 <= Nwr_del1;
--        Nwr <= nwr1in;
--	end if;                             -- condition produces pos. edge
--	END process masterclk2;             -- 1/2 clk into delayed write strobes.

    
--------------------- Timing Clock Divide Chain ---------------------------

-- NOTE: Eventually for CIJ Low-End, 32.768 KHz clock is available at input.
-- This will simplify some of the clock divide logic and provide good accuracy.


    clk_divide1 : process (mclk, Nreset)
    BEGIN
        if(Nreset='0') then
            clk_div1 <= (others=>'0');
        elsif(rising_edge(mclk)) then
            if(clk_div1="11111011") then	   -- divide 33MHz by 252 gets close to ideal 
                clk_div1 <= (others=>'0'); -- freq of 128KH (131072 H; 130952 actual)
            else
                clk_div1 <= clk_div1 + 1;
            end if;
        end if;
    END process clk_divide1;    

	
-------------------------------------------

    clk128kh_high <= '1' when(clk128kh_del2='1' AND clk128kh_del1='0') else '0';

	clk128khtick: process(mclk, Nreset)
    BEGIN
	if(Nreset='0') then
        clk128kh_del1 <= '0';
        clk128kh_del2 <= '0';
		clk128kh_tick <= '0';
	elsif(rising_edge(mclk)) then  
		clk128kh_del1 <= clk_div1(7);
		clk128kh_del2 <= clk128kh_del1;
		if(clk128kh_high='1') then 
			clk128kh_tick <= '1';
		else
			clk128kh_tick <= '0';
		end if;
	end if;
	END process clk128khtick;

	
    clk_divide2 : process (mclk, Nreset)
    BEGIN
        if(Nreset='0') then
            clk_div2 <= (others=>'0');
        elsif(rising_edge(mclk)) then
            if(clk128kh_tick='1') then
				if(clk_div2="11") then
                	clk_div2 <= "00";
            	else
                	clk_div2 <= clk_div2 + 1;
				end if;
            end if;
        end if;
    END process clk_divide2;    


 clk32kh_high <= '1' when(clk32kh_del2='1' AND clk32kh_del1='0') else '0';

	clk32khtick: process(mclk, Nreset)
    BEGIN
	if(Nreset='0') then
        clk32kh_del1 <= '0';
        clk32kh_del2 <= '0';
		clk32kh_tick <= '0';
	elsif(rising_edge(mclk)) then  
		clk32kh_del1 <= clk_div2(1);
		clk32kh_del2 <= clk32kh_del1;
		if(clk32kh_high='1') then 
			clk32kh_tick <= '1';
		else
			clk32kh_tick <= '0';
		end if;
	end if;
	END process clk32khtick;

	
-------------------------------------------


	clk1mhtick: process(mclk, Nreset)
-- This process creates several clock ticks synchronized to mclk
    BEGIN
	if(Nreset='0') then
        clk1mh_del1 <= '0';
        clk1mh_del2 <= '0';
	    clk1mh_tick <= '0';
	elsif(rising_edge(mclk)) then
		clk1mh_del1 <= clk_div1(4);
		clk1mh_del2 <= clk1mh_del1;
		if(clk1mh_del2 ='1' AND clk1mh_del1='0') then
			clk1mh_tick <= '1';	 -- this tick interval is now slightly irregular
		else					 -- due to how clk_div1 divides, but is sufficient
			clk1mh_tick <= '0';	 -- for where it is used.
		end if;
	end if;
	END process clk1mhtick;	

-------------------------------------------


	clk_halfmhtick: process(mclk, Nreset)
-- This process creates several clock ticks synchronized to mclk
    BEGIN
	if(Nreset='0') then
	    clk_halfmh_del1 <= '0';
	    clk_halfmh_del2 <= '0';
	    clk_halfmh_tick <= '0';
	elsif(rising_edge(mclk)) then
----	elsif(falling_edge(mclk)) then
        clk_halfmh_del1 <= clk_div1(5);
        clk_halfmh_del2 <= clk_halfmh_del1;
        if(clk_halfmh_del2='1' AND clk_halfmh_del1='0') then
----        if(clk_halfmh_del2='0' AND clk_halfmh_del1='1') then -- sense rising edge instead
            clk_halfmh_tick <= '1';
		else
			clk_halfmh_tick <= '0';
		end if;
	end if;
	END process clk_halfmhtick;	


-------------------------------------------

    clk_divide4 : process (mclk, Nreset)
    BEGIN
        if(Nreset='0') then
            clk_div4 <= (others=>'0');
        elsif(rising_edge(mclk)) then
            if(clk_div4="1100") then	      -- divide 33MHz by 13 gets close to ideal 
                clk_div4 <= (others=>'0');    -- freq of 2.54MHz (2.5385MHz actual)
            else
                clk_div4 <= clk_div4 + 1;
            end if;
        end if;
    END process clk_divide4;    

	
    clk2_54mh_high <= '1' when(clk2_54mh_del2='1' AND clk2_54mh_del1='0') else '0';

	clk2_54mhtick: process(mclk, Nreset)
    BEGIN
	if(Nreset='0') then
        clk2_54mh_del1 <= '0';
        clk2_54mh_del2 <= '0';
		clk2_54mh_tick <= '0';
	elsif(rising_edge(mclk)) then  
		clk2_54mh_del1 <= clk_div4(3);
		clk2_54mh_del2 <= clk2_54mh_del1;
		if(clk2_54mh_high='1') then 
			clk2_54mh_tick <= '1';
		else
			clk2_54mh_tick <= '0';
		end if;
	end if;
	END process clk2_54mhtick;

	
-------------------------------------------

	clk_div3_max <= '1' when(clk_div3(7 downto 0)="11111001") else '0';
		
    clk_divide3 : process (mclk, Nreset)
    BEGIN								
        if(Nreset='0') then				
            clk_div3 <= (others=>'0'); 
        elsif(rising_edge(mclk)) then     -- 1/2 MHz/250 = 2KHz
            if(clk_halfmh_tick='1') then  -- max = 249 to divide by 250
                if(clk_div3_max='1') then
                    clk_div3(7 downto 0) <= "00000000";
                else
                    clk_div3(7 downto 0) <= clk_div3(7 downto 0) + 1;
                end if;
            end if;
        end if;
    END process clk_divide3;    


	clk2khtick: process(mclk, Nreset)
    BEGIN
	if(Nreset='0') then
        clk2kh_del1 <= '0';
        clk2kh_del2 <= '0';
		clk2kh_tick <= '0';
	elsif(rising_edge(mclk)) then  
		clk2kh_del1 <= clk_div3(7);
		clk2kh_del2 <= clk2kh_del1;
		if(clk2kh_del2='1' AND clk2kh_del1='0') then
			clk2kh_tick <= '1';
		else
			clk2kh_tick <= '0';
		end if;
	end if;
	END process clk2khtick;

-------------------------------------------
	
    divide11 : process (mclk, Nreset)
    BEGIN
	if(Nreset='0') then
        clk_div5 <= "0000";
	elsif(rising_edge (mclk)) then
        if(clk32kh_tick='1') then
            if(clk_div5="1010") then -- divide by 11 to generate 2.9 KHz
                clk_div5 <= "0000";
            else
                clk_div5  <= clk_div5 + 1;
            end if;
        end if;
    end if;
    END process divide11;

	
    clk2_9kh_high <= '1' when (clk2_9kh_del2='1' AND clk2_9kh_del1='0') else '0';

	clk2_9htick: process(mclk, Nreset)
    BEGIN
	if(Nreset='0') then
        clk2_9kh_del1 <= '0';
        clk2_9kh_del2 <= '0';
		clk2_9kh_tick <= '0';
	elsif(rising_edge(mclk)) then
		clk2_9kh_del1 <= clk_div5(3);
        clk2_9kh_del2 <= clk2_9kh_del1;
		if(clk2_9kh_high='1') then
			clk2_9kh_tick <= '1';
		else
			clk2_9kh_tick <= '0';
		end if;
	end if;
	END process clk2_9htick;

-------------------------------------------

    divide04 : process (mclk, Nreset)
    BEGIN
	if(Nreset='0') then
        clk_div6 <= "0000";
	elsif(rising_edge (mclk)) then
        if(clk2_9kh_tick='1') then
            clk_div6 <= clk_div6 + 1;
        end if;
    end if;
    END process divide04;

    clk1_45kh_high <= '1' when (clk1_45kh_del='1' AND clk_div6(0)='0') else '0';

    clk362h_high <= '1' when (clk1_45kh_tick='1' AND clk_div6(1)='0' 
                              AND clk_div6(2)='0') else '0';

    clk181h_high <= '1' when (clk362hz_tick='1' AND clk_div6(3)='0') else '0';

    divide02 : process (mclk, Nreset)
    BEGIN
	if(Nreset='0') then
        clk1_45kh_del <= '0';
		clk1_45kh_tick <= '0';
		clk362hz_tick <= '0';
		clk181hz_tick <= '0';
	elsif(rising_edge (mclk)) then
        clk1_45kh_del <= clk_div6(0);
        if(clk1_45kh_high='1') then
		    clk1_45kh_tick <= '1';
		else
		    clk1_45kh_tick <= '0';
        end if;

        if(clk362h_high='1') then
            clk362hz_tick <= '1';
        else
            clk362hz_tick <= '0';
        end if;

        if(clk181h_high='1') then
            clk181hz_tick <= '1';
        else
            clk181hz_tick <= '0';
        end if;
    end if;
    END process divide02;


--------------------- Analog Board Input Resync -----------------

	an_sync : process (mclk, Nreset)
	BEGIN
	if(Nreset='0') then
		an_io_1 <= "11111111111"; -- assumes active low signals
		an_io   <= "11111111111";
	elsif(rising_edge(mclk)) then
		an_io_1 <= an_io_in;
		an_io <= an_io_1;
	end if;
	END process an_sync;

--------------------- Bus Control Logic -------------------------

    bus_req <= '0';

----------------------- Address Decode --------------------------

-- address strobe true and not a bus_grant, now uses resynced
-- bus_grant signal to help reduce routing constraints.
-- Even further simplified by omitting the bus_grant gate; the chip
-- select is enough of a safeguard gate.

    addrdecode : addrdcdm
    port map(addr(11 downto 2),
        Ncs,
       
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
		speed_limit1_dcd,

        -- Head 1 

        buffer_hdwr_config1_dcd, stroke_count_store1_dcd,
        image_intrpten1_dcd, image_intreset1_dcd, image_flagreset1_dcd,
        pr_intrpten1_dcd, pr_intreset1_dcd, pr_flagreset1_dcd,
        status_read1_dcd, fault_reset1_dcd, image_print_abortff1_dcd, 
        image_print_cmd1_dcd, internal_stroke_store1_dcd,
        compare_enable1_dcd, compare_load1_dcd, capture_read1_dcd,
        NID_reset1_dcd, NID_div_numerator1_dcd, NID_div_denom1_dcd,
        rollover_clear1_dcd, strk_trig_intreset_dcd, strk_trig_flagreset_dcd,

		status_read2_dcd,

		-- Keyboard	& IO

		kbdio_intrpten1_dcd, kbdio_flagreset1_dcd, kbdio_intreset1_dcd,
        kbd_fifo_read_dcd,
	    
		AN_io_read_dcd, AN_intrpten1_dcd, AN_hiflagreset1_dcd,
        AN_hiintreset1_dcd, AN_loflagreset1_dcd, AN_lointreset1_dcd);

------------------------ Speed Measurement ----------------------------

    speed_meas1 : speed8
    PORT MAP(mclk, Nreset, nid_in_tick1, clk2kh_tick, overspeed_detect_enable, 
		overspeed_reset, speed_limit1, speed_data1, limit_detectff);

	overspeed_reset <= '1' when(speed_limit1_dcd='1' AND Nwr='0') else '0';
		
		
----------------------- Speed Limit Register --------------------------

	-- Max. Speed Compare - Switch to Internal Encode, if enabled and if sensed
	-- speed equals or exceeds stored value.
	
    speedlimit1_regen <= '1' when(speed_limit1_dcd='1' AND Nwr='0') else '0';

    speedlimitreg1: enreg16
	port map(data(15 downto 0), speedlimit1_regen, mclk, Nreset,
    speed_limit1(15 downto 0));
	

--    NEW FORM
-- STATUS READ - HEAD 1

    status_read1(31) <= strk_trig_overlap_fault;
    status_read1(30) <= total_image_done1;
    status_read1(29) <= full_message_aborted1;
    status_read1(28) <= '0'; -- multi_stroke_reg1(1);
    status_read1(27) <= '0'; -- multi_stroke_reg1(0);
    status_read1(26) <= AN_lointr;
    status_read1(25) <= AN_lointr_flag1; 
    status_read1(24) <= AN_hiintr; 
    status_read1(23) <= AN_hiintr_flag1; 
    status_read1(22) <= strk_trig_intr; -- pe_reset1
    status_read1(21) <= strk_trig_intr_flag; -- message_tagbit1
    status_read1(20) <= autoencode_overflow1;
    status_read1(19) <= AN_wd_flag; 
    status_read1(18) <= AN_drop_clock; 
    status_read1(17) <= dirout_main1;
    status_read1(16) <= count_zero_main1;
    status_read1(15) <= '0'; -- obsolete - image_abort_reqff1;
    status_read1(14) <= image_print_abortff1;
    status_read1(13) <= strokes_abortedff1;
    status_read1(12) <= imageprint_done1;
    status_read1(11) <= rolloverff1;
    status_read1(10) <= backlash_max1_intr;
    status_read1(9)  <= backlash1_int_flag;
    status_read1(8)  <= image1_intr_gated;
    status_read1(7)  <= image_int_flag1;
    status_read1(6)  <= pr1_intr_gated;
    status_read1(5)  <= pr1_int_flag;
    status_read1(4)  <= pr1_overlap_fault;
    status_read1(3)  <= pd1_intr;
    status_read1(2)  <= pd1_filtered;
    status_read1(1)  <= pd1_int_flag;
    status_read1(0)  <= pd1_overlap_fault;


--    NEW FORM
-- STATUS READ - HEAD 2

    status_read2(31) <= limit_detectff;
    status_read2(30) <= '1'; -- total_image_done2
    status_read2(29) <= '0';
    status_read2(28) <= '0';
    status_read2(27) <= '0';
    status_read2(26) <= '0'; -- pe2_ready_to_ip_m;
    status_read2(25) <= '0'; -- pe2_ready_intr;
    status_read2(24) <= '0'; -- pe2_ready_intr_flag; 
    status_read2(23) <= '0'; -- pe2_ready_intr_enabled;
    status_read2(22) <= '0'; -- pe_reset2;
    status_read2(21) <= '0'; -- message_tagbit2;
    status_read2(20) <= '0'; -- autoencode_overflow2;
    status_read2(19) <= '0'; -- image_ready_fault2;
    status_read2(18) <= '0'; -- new_image_readyff2;
    status_read2(17) <= '1'; -- dir_out_main2;
    status_read2(16) <= '1'; -- count_zero_main2;
    status_read2(15) <= '0'; -- image_abort_reqff2;
    status_read2(14) <= '0'; -- image_print_abortff2;
    status_read2(13) <= '0'; -- strokes_abortedff2;
    status_read2(12) <= '1'; -- image_print_done2;
    status_read2(11) <= '0'; -- rolloverff2;
    status_read2(10) <= '0'; -- backlash_max2_intr;
    status_read2(9)  <= '0'; -- backlash2_int_flag;
    status_read2(8)  <= '0'; -- image2_intr_gated;
    status_read2(7)  <= '0'; -- image_int_flag2;
    status_read2(6)  <= '0'; -- pr2_intr_gated;
    status_read2(5)  <= '0'; -- pr2_int_flag;
    status_read2(4)  <= '0'; -- pr2_overlap_fault;
    status_read2(3)  <= pd2_intr;
    status_read2(2)  <= pd2_filtered;
    status_read2(1)  <= pd2_int_flag;
    status_read2(0)  <= pd2_overlap_fault;

-- COMMON READ STATUS - OUTPUTS AND REVISION CODE

    common_read(31 downto 16) <= revision_code;

    common_read(15) <= '0';  
    common_read(14) <= kbdio_intr_flag;            
    common_read(13) <= kbdio_intr;  
    common_read(12) <= not(Nsiren_temp);
    common_read(11) <= not(Ntrired);
    common_read(10) <= not(Ntriyel);
    common_read(9)  <= not(Ntrigrn); 
    common_read(8)  <= not(Nexp_type(2));    
    common_read(7)  <= not(Nexp_type(1));   
    common_read(6)  <= not(Nexp_type(0));    
    common_read(5)  <= not(Ngenout(5)); 		    
    common_read(4)  <= not(Ngenout(4));    -- General Purpose Outputs  
    common_read(3)  <= not(Ngenout(3));    -- Allows processor to monitor		    
    common_read(2)  <= not(Ngenout(2));    -- the exact output state,
    common_read(1)  <= not(Ngenout(1));    -- even for pulse-mode outputs.		     
    common_read(0)  <= not(Ngenout(0));     

                        
-- GENERAL PURPOSE INPUTS, INTERRUPTS AND FLAGS
     
    status_read_input(0)  <= input_filtered(0);
    status_read_input(1)  <= input_filtered(1);
    status_read_input(2)  <= input_filtered(2);
    status_read_input(3)  <= input_filtered(3);
    status_read_input(4)  <= input_filtered(4);
    status_read_input(5)  <= input_filtered(5);
    status_read_input(6)  <= input_filtered(6);
    status_read_input(7)  <= input_filtered(7);
    status_read_input(8)  <= input_filtered(8);
    status_read_input(9)  <= '0';
    status_read_input(10) <= intr_input_reg(0);
    status_read_input(11) <= intr_input_reg(1);
    status_read_input(12) <= intr_input_reg(2);
    status_read_input(13) <= intr_input_reg(3);
    status_read_input(14) <= intr_input_reg(4);
    status_read_input(15) <= intr_input_reg(5);
    status_read_input(16) <= intr_input_reg(6);
    status_read_input(17) <= intr_input_reg(7);
    status_read_input(18) <= intr_input_reg(8);
    status_read_input(19) <= '0';
    status_read_input(20) <= input_flag_reg(0);
    status_read_input(21) <= input_flag_reg(1);
    status_read_input(22) <= input_flag_reg(2);
    status_read_input(23) <= input_flag_reg(3);
    status_read_input(24) <= input_flag_reg(4);   
    status_read_input(25) <= input_flag_reg(5);   
    status_read_input(26) <= input_flag_reg(6);   
    status_read_input(27) <= input_flag_reg(7);   
    status_read_input(28) <= input_flag_reg(8);   
    status_read_input(29) <= not(Nio_reserved);
    status_read_input(30) <= not(Ngenout(6));
    status_read_input(31) <= not(Ngenout(7));
                        
---------------------------------------------------------------------------
------------------------ Internal Data Read MUX ---------------------------

-- This version used only for devices that support internal tristate buffers


---------------------------------------------------------------------------
           dataout(31 downto 16) <= (others=>'0') 
             when(stroke_count_store1_dcd='1')
                else (others=>'Z');

           dataout(15 downto 0) <= stroke_count_read1 
            when(stroke_count_store1_dcd='1')
                else (others=>'Z');
---------------------------------------------------------------------------
            dataout(31 downto 0) <= status_read1 
              when(status_read1_dcd='1')
                 else (others=>'Z');
---------------------------------------------------------------------------
            dataout(31 downto 0) <= status_read2 
              when(status_read2_dcd='1')
                 else (others=>'Z');
---------------------------------------------------------------------------
            dataout(31 downto 0) <= status_read_input 
              when(input_read_dcd='1')
                 else (others=>'Z');
---------------------------------------------------------------------------
            dataout(31 downto 5) <= (others=>'0')
              when(buffer_hdwr_config1_dcd='1') 
                else (others=>'Z');

            dataout(4 downto 0) <= hdwr_buff_config1(4 downto 0)
              when(buffer_hdwr_config1_dcd='1') 
                else (others=>'Z');
---------------------------------------------------------------------------

            dataout(31 downto 15) <= (others=>'0')
              when(hdwr_config1_dcd='1') 
                else (others=>'Z');

            dataout(14 downto 12) <= hdwr_config1(14 downto 12)
              when(hdwr_config1_dcd='1') 
                else (others=>'Z');

            dataout(11 downto 8) <= (others=>'0')
              when(hdwr_config1_dcd='1') 
                else (others=>'Z');

            dataout(7 downto 0) <= hdwr_config1(7 downto 0)
              when(hdwr_config1_dcd='1') 
                else (others=>'Z');

---------------------------------------------------------------------------
-- temp reg to force Altera data pins to bidir
--            dataout(31 downto 0) <= hdwr_config2(31 downto 0)
--              when(hdwr_config2_dcd='1') 
--                else (others=>'Z');

---------------------------------------------------------------------------
            dataout(31 downto 16) <= (others=>'0') 
              when(speed_read1_dcd='1')
                else (others=>'Z');

            dataout(15 downto 0) <= speed_data1 
              when(speed_read1_dcd='1')
                else (others=>'Z');
---------------------------------------------------------------------------
			dataout(31 downto 19) <= (others=>'0') 
              when(autoencode_read1_dcd='1')
                else (others=>'Z');

            dataout(18 downto 0) <= autoencode1(18 downto 0)
              when(autoencode_read1_dcd='1') 
                else (others=>'Z');
---------------------------------------------------------------------------

            -- Changed decoder use to allow read of encoder
            -- counter so software can check whether or not it took
            -- too long computing the image, thus being past the trip
            -- point by the time it would load the compare reg.  This
            -- would cause a complete revolution of the encoder counter
            -- before printing.

            dataout(31 downto 20) <= (others=>'0') 
              when(encodercount_read1_dcd='1')
                else (others=>'Z');

            dataout(19 downto 0) <= encoder_count 
              when(encodercount_read1_dcd='1')
                else (others=>'Z');
------------------------------------------------------------------
            dataout(31 downto 20) <= (others=>'0') 
              when(capture_read1_dcd='1')
                else (others=>'Z');

            dataout(19 downto 0) <= capture_data1 
              when(capture_read1_dcd='1')
                else (others=>'Z');
------------------------------------------------------------------
--            dataout(31 downto 8) <= (others=>'0')
--              when(hdwr_config2_dcd='1') 
--                else (others=>'Z');

--            dataout(7 downto 6) <= hdwr_config2(7 downto 6)
--              when(hdwr_config2_dcd='1') 
--                else (others=>'Z');

--            dataout(5 downto 0) <= (others=>'0')
--              when(hdwr_config2_dcd='1') 
--                else (others=>'Z');
------------------------------------------------------------------
            dataout(31 downto 0) <= common_read
              when(common_read_dcd='1')
                else (others=>'Z');
------------------------------------------------------------------
            dataout(31 downto 10) <= (others=>'0')
              when(kbd_fifo_read_dcd='1') 
                else (others=>'Z');

            dataout(9 downto 0) <= fifo_reg_out
              when(kbd_fifo_read_dcd='1') 
                else (others=>'Z');

------------------------------------------------------------------
-- temporary logic just to use Analog IO pins.

            dataout(31 downto 11) <= (others=>'0')
              when(AN_io_read_dcd='1') 
                else (others=>'Z');

            dataout(10 downto 0) <= an_io
              when(AN_io_read_dcd='1') 
                else (others=>'Z');

------------------------- Data Read Output ----------------------

    datsel <= '1' when(
    AN_io_read_dcd='1' OR
    kbd_fifo_read_dcd='1' OR
    stroke_count_store1_dcd='1' OR
    status_read1_dcd='1' OR
    speed_read1_dcd='1' OR
    hdwr_config1_dcd='1' OR
    buffer_hdwr_config1_dcd='1' OR
    autoencode_read1_dcd='1' OR
    encodercount_read1_dcd='1' OR
    capture_read1_dcd='1' OR
    status_read2_dcd='1' OR
    common_read_dcd='1' OR
    input_read_dcd='1') else '0';

    dataoe <= (datsel) AND riwr AND not(Nrdin);

    -- Terminate abort either from software, or after print disable,
    -- provided that an image was in process when print disable key
    -- was pressed.  In that case, hardware must generate an artificial
    -- abort cycle to truncate printing and then self-terminate
    -- that abort cycle.  This case is handled by the second product
    -- term below  (a write to the print_enableff OFF (data(5)=0).

    image_print_abort1_in <= image_print_abortff1_dcd 
                            OR (hdwrcfg11_regen AND not(data(5)));

    syncdataoe : process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        image_print_abort1_dcd <= '0';
        dataoe_m <= '0';
--		data <= (others=>'Z');
	elsif(rising_edge(mclk)) then
        dataoe_m <= dataoe;
        image_print_abort1_dcd <= image_print_abort1_in;
--        if(dataoe='1') then
--            data <= dataout;
--        else
--            data <= (others=>'Z'); 
--        end if;
    end if;
    END process syncdataoe;

--     datab <= dataout when (dataoe_m='1') 
     data <= dataout when (dataoe_m='1') 

--     data <= dataout when (dataoe_m='1' AND dataoe='1') -- included dataoe
--     data <= dataout when (dataoe='1')   --  so that disable is not delayed 
            else (others=>'Z');            --  by a clock cycle.
                                          
--	 data <= datab;	-- tmp version used to allow syn_keep attribute & prevent
	 					-- converting bidirectional bus to mixed inout/out types.

--------------------- Bus Grant Address Control ----------------------

    Nextreq <= '1';

------------------ Hardware Configuration Registers -----------------------

--   Head 1 Configuration Register

    -- hdwr_config1 is intended to store stable values, which do not change
    -- very often.

    -- buffer_hdwr_config1 is intended for values that may need to change
    -- for every print image (or sub-image).  These are also double buffered
    -- to support back to back printing, even with parameters changing for
    -- each image.

    hdwrcfg11_regen <= '1' when(hdwr_config1_dcd='1' AND Nwr='0') else '0';

    cfgreg2: enreg1
	port map(data(16), hdwrcfg11_regen, mclk, Nreset,
    hdwr_config1(16));

	keyboard_beep_enable <= hdwr_config1(16);
	
     cfgreg1: enreg8
	port map(data(15 downto 8), hdwrcfg11_regen, mclk, Nreset,
    hdwr_config1(15 downto 8));

	overspeed_detect_enable <= hdwr_config1(15);
    abortmode1(1)    	  <= hdwr_config1(14);
    abortmode1(0)         <= hdwr_config1(13);
    internal_pd_selectff1 <= hdwr_config1(12);
    pd_invff2             <= hdwr_config1(11); 
    pd_lead_edge_selff2   <= hdwr_config1(10);
	
	-- internal_pd_type_selectff1
	
    autoencode_mode_ff1   <= hdwr_config1(9); 
    pd_selectff1          <= hdwr_config1(8);
    
    cfgreg0: enreg8
	port map(data(7 downto 0), hdwrcfg11_regen, mclk, Nreset,
    hdwr_config1(7 downto 0));

    pd_invff1            <= hdwr_config1(7); 
    pd_lead_edge_selff1  <= hdwr_config1(6);
    print_enableff1      <= hdwr_config1(5);
    reverse_dirff_main1  <= hdwr_config1(4);
    quadrature_enableff_main1 <= hdwr_config1(3);
    enc_dir_invff_main1  <= hdwr_config1(2);
    str_source_selff1    <= hdwr_config1(1);
    internal_pd_type_selectff1  <= hdwr_config1(0);

--   Head 1 Configuration Buffer Register

    hdwrbufcfg1_regen <= '1' when(buffer_hdwr_config1_dcd='1' AND Nwr='0')
                            else '0';

    cfgbufstorreg1a: enreg1
	port map(data(4), hdwrbufcfg1_regen, mclk, Nreset,
    hdwr_buff_config1(4));

    cfgbufstorreg1b: enreg4
	port map(data(3 downto 0), hdwrbufcfg1_regen, mclk, Nreset,
    hdwr_buff_config1(3 downto 0));
    -- Hardware Buffer Reg. Active - loaded upon each image start process

    -- Setup_transfer loads the active buffer registers at the start
    -- of each print image.


    cfgbufreg1a: enreg1
	port map(hdwr_buff_config1(4), setup_transfer1, mclk, Nreset,
    hdwr_buff_set1(4));

    cfgbufreg1b: enreg4
	port map(hdwr_buff_config1(3 downto 0), setup_transfer1, mclk, Nreset,
    hdwr_buff_set1(3 downto 0));

    Ntotal_done_enable1  <= hdwr_buff_set1(4);
    multi_stroke_reg1(3) <= hdwr_buff_set1(3);
    multi_stroke_reg1(2) <= hdwr_buff_set1(2);
    multi_stroke_reg1(1) <= hdwr_buff_set1(1);
    multi_stroke_reg1(0) <= hdwr_buff_set1(0);


--   Head 2 Configuration Register

--    hdwrcfg23_regen <= '1' when(hdwr_config2_dcd='1' AND Nwr='0') else '0';

--    cfgreg2a: enreg8
--	port map(data(7 downto 0), hdwrcfg23_regen, mclk, Nreset,
--    hdwr_config2(7 downto 0));

--    cfgreg2b: enreg8
--	port map(data(23 downto 16), hdwrcfg23_regen, mclk, Nreset,
--    hdwr_config2(23 downto 16));

--    cfgreg2c: enreg8
--	port map(data(31 downto 24), hdwrcfg23_regen, mclk, Nreset,
--    hdwr_config2(31 downto 24));

--    cfgreg2: enreg8
--	port map(data(15 downto 8), hdwrcfg23_regen, mclk, Nreset,
--    hdwr_config2(15 downto 8));

--    abortmode2(1)    <= hdwr_config2(14);
--    abortmode2(0)    <= hdwr_config2(13);
--    internal_pd_selectff2 <= hdwr_config2(12);
--    SLI_baudrate2(1)    <= hdwr_config2(11);
--    SLI_baudrate2(0)    <= hdwr_config2(10);
--    availableff2b       <= hdwr_config2(9);

--    pd_selectff2        <= hdwr_config2(8); -- not used

--    cfgreg3: enreg2
--	port map(data(7 downto 6), hdwrcfg23_regen, mclk, Nreset,
--    hdwr_config2(7 downto 6));


--    print_enableff2     <= hdwr_config2(5);
--    reverse_dirff_main2  <= hdwr_config2(4);
--    quadrature_enableff_main2 <= hdwr_config2(3);
--    enc_dir_invff_main2 <= hdwr_config2(2);
--    str_source_selff2   <= hdwr_config2(1);
--    encoder_selectff2   <= hdwr_config2(0);

-------------------- Product Detect 1 Input Logic ----------------------

-- Requires previous selection of which PD input is directed to which head.

     pd1_intrpt_en <= '1' when(pd_intrpten1_dcd='1' AND Nwr='0')
                                    else '0';

    pdintr1_ctrl : process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        pd1_enable <= '0';
	elsif(rising_edge(mclk)) then
        if(pd1_intrpt_en='1') then
            pd1_enable <= data(0);
        end if;
    end if;
    END process pdintr1_ctrl;

     pd1_intr_clr <= '1' when(pd_intreset1_dcd='1' AND Nwr='0') else '0';
     pd1_flag_clr <= '1' when(pd_flagreset1_dcd='1' AND Nwr='0') else '0';

     pd1: prod4 PORT MAP(
          mclk, Nreset, pd1_select, pd_invff1, pd_lead_edge_selff1,
          clk128kh_tick, pd1_enable, pd1_intr_clr, pd1_flag_clr,
          internal_pd_selectff1,
          set_pd1_overlap_fault, set_pd1_bounce_warning,
          pd1_int_flag, pd1_intr, pd1_filtered, pd1_edge_tick);

          Npd1_filtered <= not(pd1_filtered);

     pd2_intrpt_en <= '1' when(pd_intrpten2_dcd='1' AND Nwr='0')
                                    else '0';

     pd2_intr_clr <= '1' when(pd_intreset2_dcd='1' AND Nwr='0') else '0';
     pd2_flag_clr <= '1' when(pd_flagreset2_dcd='1' AND Nwr='0') else '0';

-- Not done with second PD yet.  Review IPro for logic.

     pd2: prod4 PORT MAP(
          mclk, Nreset, pd2in, pd_invff2, pd_lead_edge_selff2,
          clk128kh_tick, pd1_enable, pd2_intr_clr, pd2_flag_clr, low,
          set_pd2_overlap_fault, set_pd2_bounce_warning,
          pd2_int_flag, pd2_intr, pd2_filtered, pd2_edge_tick);

          Npd2_filtered <= not(pd2_filtered);


-------------------- Internal Product Detect 1 ----------------------

-- This section instantiates an encoder divider which generates
-- an internal Product Detect pulse repeatedly if selected.  This
-- is used in continuous material feed applications such as web
-- material, tubing, wire or cable, etc.

	internal_prod_store1_regen <= '1' when(internal_prod_store1_dcd='1'
		       				 				AND Nwr='0') else '0';

	internal_prod_store1_upper_reg: enreg4
	port map(data(19 downto 16), internal_prod_store1_regen, mclk, Nreset,
			q=>internal_prod_store1(19 downto 16));

	internal_prod_store1_mid_reg: enreg8
	port map(data(15 downto 8), internal_prod_store1_regen, mclk, Nreset,
			q=>internal_prod_store1(15 downto 8));

	internal_prod_store1_lower_reg: enreg8
	port map(data(7 downto 0), internal_prod_store1_regen, mclk, Nreset,
			q=>internal_prod_store1(7 downto 0));

    -- Restart the Internal PD interval at the new rate whenever a new value
    -- is written or when Print is enabled.

    internal_pd_inhibit1 <= not(print_enableff1) OR internal_prod_store1_regen;

------------------------ 64 Hz CLOCK -------------------------------

	-- To support the alternate mode for internal PD, where 64 Hz pulses
	-- rather than encoder ticks are counted, more logic is needed here.
	-- internal_pd_typeff1 - 0 = encoder based, 1 = time based.

	-- slowclk_tick
	-- clk2kh_tick
	
	clk_divide64 : process (mclk, Nreset)
    BEGIN
        if(Nreset='0') then
            clk_div64 <= (others=>'0');
        elsif(rising_edge(mclk)) then
			if(clk32kh_tick='1') then          -- 32KHz (32786Hz actual,
            	if(clk_div64="111111111") then -- divided by 512 = 64.035Hz
               		clk_div64 <="000000000";
            	else
                	clk_div64 <= clk_div64 + 1;
            	end if;
			end if;
        end if;
    END process clk_divide64;    


	clk64tick: process(mclk, Nreset)
-- This process creates several clock ticks synchronized to mclk
    BEGIN
	if(Nreset='0') then
        clk64h_del1 <= '0';
        clk64h_del2 <= '0';
	    clk64h_tick <= '0';
	elsif(rising_edge(mclk)) then
		clk64h_del1 <= clk_div64(8);
		clk64h_del2 <= clk64h_del1;
		if(clk64h_del2 ='1' AND clk64h_del1='0') then
			clk64h_tick <= '1';
		else
			clk64h_tick <= '0';
		end if;
	end if;
	END process clk64tick;	
	
-------------- Internal Product Detect -----------------------	

-- Choose encoder or time based PD

	-- clk64h_tick OR nid_in_tick1; 
	-- internal_pd_type_selectff1='0' => encoder based
	-- internal_pd_type_selectff1='1' => time (64Hz) based

    pdtype_select: process (mclk, Nreset, internal_pd_type_selectff1)
    BEGIN
    if(Nreset='0') then
		pd1in_tick <= '0';
	elsif(rising_edge(mclk)) then
        if(internal_pd_type_selectff1='1') then
			pd1in_tick <= nid_in_tick1;
        else
			pd1in_tick <= clk64h_tick;
        end if;
    end if;
    END process pdtype_select;

	
    pd_divider1 : divide20 
    port map(Nreset, pd1in_tick, mclk, internal_pd_inhibit1,
        internal_prod_store1, internal_pd1_tick);

    -- Pulsegen below used to generate a wider internal PD pulse; 
    -- the width is 16 cycles of nid_in_tick1

	pulsegen5: pulse_1ms
	PORT MAP(mclk, Nreset, clk32kh_tick, internal_pd1_tick,
			internal_pd1_wide);

------------------- PD Select Logic --------------------------

-- Logic support using either external PD as the primary product detector,
-- as well as internal PD.

    pd_select: process (mclk, Nreset, internal_pd_selectff1, pd_selectff1)
    BEGIN
    if(Nreset='0') then
		pd1_select <= '0';
	elsif(rising_edge(mclk)) then
        if(internal_pd_selectff1='1') then
			pd1_select <= internal_pd1_wide;
        elsif(pd_selectff1='0') then
			pd1_select <= pd1in;
        else
			pd1_select <= pd2in;
        end if;
    end if;
    END process pd_select;


------------------- Capture & Compare Logic ------------------

-- Due to the addition of internal stroke clock divide, ccomp and
-- nid get the same input.  This simplifies software control of
-- various print configurations.

    cc1: ccomp10
    PORT MAP(mclk, Nreset, nid_in_tick1, pd1_edge_tick,
        Nwr, print_enableff1, compare_enable1_dcd,
    	compare_load1_dcd, rollover_clear1_dcd, data(19 downto 0),
        Npr1_match, rolloverff1, capture_data1, encoder_count);


-------------------- Print Request 1 Input Logic ----------------------

     pr1_intrpt_en <= '1' when(pr_intrpten1_dcd='1' AND Nwr='0')
                                    else '0';

    printr1_ctrl : process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        pr1_enable <= '0';
	elsif(rising_edge(mclk)) then
        if(pr1_intrpt_en='1') then
            pr1_enable <= data(0);
        end if;
    end if;
    END process printr1_ctrl;

     pr1_intr_clr <= '1' when(pr_intreset1_dcd='1' AND Nwr='0') else '0';
     pr1_flag_clr <= '1' when(pr_flagreset1_dcd='1' AND Nwr='0') else '0';

     pr1_match <= not(Npr1_match);

     pr1: prreq2 PORT MAP(
          mclk, Nreset, pr1_match, pr1_enable,
          pr1_intr_clr, pr1_flag_clr,
          pr1_int_flag, pr1_intr, set_pr1_overlap_fault);

-- The following gating function was added to suppress the print request
-- interrupt under the condition that print is disabled.  However, due
-- to concerns over software impact, it was decided not to actually
-- disable the control ff itself, just gate off the prreq output.  In
-- other words, software can still disable the interrupt control register
-- by writing a '0' to the assigned address.  But if it did not, it
-- also does not need to write to this register to re-enable it.  Activating
-- print enable will place the interrupt state where it was left.

          pr1_intr_gated <= pr1_intr AND print_enableff1;

-------------------- Print Request 2 Input Logic ----------------------

------------------ Image Done 1 Interrupt Input Logic ----------------

     image1_intrpt_en <= '1' when(image_intrpten1_dcd='1' AND Nwr='0')
                                    else '0';

    imagedn_ctrl : process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        imageintr1_enable <= '0';
	elsif(rising_edge(mclk)) then
        if(image1_intrpt_en='1') then
            imageintr1_enable <= data(0);
        end if;
    end if;
    END process imagedn_ctrl;

     image1_intr_clr <= '1' when(image_intreset1_dcd='1' AND Nwr='0') else '0';
     image1_flag_clr <= '1' when(image_flagreset1_dcd='1' AND Nwr='0') else '0';

     imagedn_intr1: prreq2 PORT MAP(
          mclk, Nreset, imageprint_done1, imageintr1_enable,
          image1_intr_clr, image1_flag_clr,
          image_int_flag1, image1_intr, set_image1_overlap_fault);

-- The following gating function was added to suppress the image done
-- interrupt under the condition that print is disabled.  However, due
-- to concerns over software impact, it was decided not to actually
-- disable the control ff itself, just gate off the prreq output.  In
-- other words, software can still disable the interrupt control register
-- by writing a '0' to the assigned address.  But if it did not, it
-- also does not need to write to this register to re-enable it.  Activating
-- print enable will place the interrupt state where it was left.

    image1_intr_gated <= image1_intr AND print_enableff1;

------------------ Image Done 2 Interrupt Input Logic ----------------

-------------------- Backlash 1 Interrupt Logic ----------------------

     backlash1_intrpt_en <= '1' when(backlash_intrpten1_dcd='1' AND Nwr='0')
                                    else '0';

    backlashintr1_ctrl : process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        backlash1_intr_enable <= '0';
	elsif(rising_edge(mclk)) then
        if(backlash1_intrpt_en='1') then
            backlash1_intr_enable <= data(0);
        end if;
    end if;
    END process backlashintr1_ctrl;

     backlash1_intr_clr <= '1' when(backlash_intreset1_dcd='1' AND Nwr='0') 
                        else '0';
     backlash1_flag_clr <= '1' when(backlash_flagreset1_dcd='1' AND Nwr='0')
                        else '0';


     backlashintr1: prreq2 PORT MAP(
          mclk, Nreset, backlash_max1, backlash1_intr_enable,
          backlash1_intr_clr, backlash1_flag_clr,
          backlash1_int_flag, backlash_max1_intr, open);


-------------------- Backlash 2 Interrupt Logic ----------------------

--     backlash2_intrpt_en <= '1' when(backlash_intrpten2_dcd='1' AND Nwr='0')
--                                    else '0';

--    backlashintr2_ctrl : process (mclk, Nreset)
--    BEGIN
--    if(Nreset='0') then
--        backlash2_intr_enable <= '0';
--	elsif(rising_edge(mclk)) then
--        if(backlash2_intrpt_en='1') then
--            backlash2_intr_enable <= data(0);
--        end if;
--    end if;
--    END process backlashintr2_ctrl;

--     backlash2_intr_clr <= '1' when(backlash_intreset2_dcd='1' AND Nwr='0') 
--                        else '0';
--    backlash2_flag_clr <= '1' when(backlash_flagreset2_dcd='1' AND Nwr='0')
--                        else '0';

--     backlashintr2: prreq2 PORT MAP(
--          mclk, Nreset, backlash_max2, backlash2_intr_enable,
--          backlash2_intr_clr, backlash2_flag_clr,

    backlash2_int_flag <= '0';
    backlash_max2_intr <= '0';


------------------- Encoder Backlash and Tick Logic ------------------

	backlash_clr_main1 <= '1' when(backlash_reset1_dcd='1' AND Nwr='0') else '0';


	enc1: encoder9  -- 16 bit backlash
	 port map(mclk, Nreset, enca_main1, encb_main1, reverse_dirff_main1,
          enc_dir_invff_main1, quadrature_enableff_main1, backlash_clr_main1,
          enc_tick_main1, dirout_main1, err_tick_main1, count_zero_main1,
          backlash_max1);

----- temp for debug
-----	dir_out_main1 <= not(kbdsig7);

	dir_out_main1 <= dirout_main1;
          -- enc2 not used


----- temp for debug

-----    count_zero_led1 <= not(kbdsig5);

	count_zero_led1 <= count_zero_main1;


---------------------------------------------------------------------------

-------------------- Internal Stroke Divide 1 ----------------------

-- This section instantiates an internal stroke divider which generates
-- an internal stroke pulse

	internal_stroke_store1_regen <= '1' when(internal_stroke_store1_dcd='1'
		       				 				AND Nwr='0') else '0';

	internal_stroke_store1upper_reg: enreg4
	port map(data(11 downto 8), internal_stroke_store1_regen, mclk, Nreset,
			q=>internal_stroke_store1(11 downto 8));

	internal_stroke_store1lower_reg: enreg8
	port map(data(7 downto 0), internal_stroke_store1_regen, mclk, Nreset,
			q=>internal_stroke_store1(7 downto 0));

    -- Restart internal encoder interval whenever a new value is written.

    internal_enc_inhibit1 <= internal_stroke_store1_regen;

    stroke_divider1 : divide12 
    port map(Nreset, clk2_54mh_tick, mclk, internal_enc_inhibit1,
        internal_stroke_store1, internal_stroke1_tick);

-------------- Internal/External NID & Trigger Source Select ---------------
                    ----- Head 1 ------

	enc_sel1 : process (Nreset, mclk, str_source_selff1, limit_detectff)

	BEGIN
	if(Nreset='0') then
        ccomp_in_tick1 <= '0';
        nid_in_tick1 <= '0';
	elsif(rising_edge(mclk)) then
	 -- 1=external, 0=internal;	-- and not at speed limit
		if(str_source_selff1='1' AND limit_detectff='0') then 
	 -- External encoder
			nid_in_tick1 <= enc_tick_hd1;
		else
	 -- Internal encoder
			nid_in_tick1 <= internal_stroke1_tick;
		end if;
	end if;
	END process enc_sel1;

	
	-- Add support for Ninternal_encoding output, LED drive, which will indicate
	-- that hardware auto-selected internal stroking, due to overspeed
	-- on external encoder.

----- temp for debug

-----    Ninternal_encoding <= not(kbdsig6);

	Ninternal_encoding <= '0' when(str_source_selff1='0' OR 
							(overspeed_detect_enable='1' AND limit_detectff='1'))
							else '1';  

--------------------- Non-Integer Divide Logic1 ----------------------

-- The input to NID divide has been modified to allow it to run
-- continuously.  The output trigger pulses are gated with image
-- not done instead of holding the divider cleared.  The nid divider
-- must then also be zeroed at the instant that print request occurs.

	nid_reset1 <= '1' when(nid_reset1_dcd='1' AND Nwr='0') else '0';

    Nnidclear1 <= '0' when (Nreset='0' OR nid_reset1='1' 
                             OR imageprint_done1='1') else '1';
--                             OR print_start1='1') else '1';

                     -- print_start1 from processor avoids
                     -- too close timing of packet to stroke trigger
                     -- for print engine when processor response slow

                          -- OR pr1_init='1') else '1';
                          -- OR ipr1_match='0') else '1';
           
    nonintdiv1: nid8 PORT MAP(
    	Nnidclear1, nid_in_tick1, mclk,
	    NID_div_numerator1(11 downto 0),
    	NID_div_denom1(7 downto 0),
    	nid_out_tick1);

    div_tick_hd1 <= nid_out_tick1 AND not(imageprint_done1);


--------------------- Stroke Trigger Pulse Stretch ---------------------

	trigplsegen1: pulse1us	PORT MAP(
		mclk, Nreset, clk1mh_tick, div_tick_hd1, strk_trig_hd1);

	Nstrk_trig_hd1 <= not(strk_trig_hd1 AND not(image_print_abortff1));

	strk_trig_hd1_gated <= not(Nstrk_trig_hd1);

--------------------- Stroke Trigger Interrupt ---------------------

	strk_trig_intr_clr <= '1' when(strk_trig_intreset_dcd='1' AND Nwr='0') else '0';
	strk_trig_flag_clr <= '1' when(strk_trig_flagreset_dcd='1' AND Nwr='0') else '0';

     stroke_trig_intr1: prreq2 PORT MAP(
          mclk, Nreset, strk_trig_hd1_gated, imageintr1_enable,
          strk_trig_intr_clr, strk_trig_flag_clr,
          strk_trig_intr_flag, strk_trig_intr, set_strk_trig_overlap_fault);


--	stroke_trig_intr1: intreq2 PORT MAP(
--		mclk, Nreset, strk_trig_hd1_gated, imageintr1_enable,
--		strk_trig_intr_clr, strk_trig_flag_clr,
--		strk_trig_intr_enabled, strk_trig_int_flag1, 
--		set_strk_trig_overlap_fault, strk_trig_intr);


-------------- Internal/External NID & Trigger Source Select ---------------
                    ----- Head 2 ------


--------------------- Non-Integer Divide Logic2 ----------------------


----------------- Encoder Select Logic, Head 1 & 2 ----------------------

            enc_tick_hd1 <= enc_tick_main1;
    		reverse_dirff1 <= reverse_dirff_main1;

------------------- Head 1 NID Reg -------------------

------------- NID Numerator Buffer Register -----------------

	NID_div_numer1_regen <= '1' when(NID_div_numerator1_dcd='1'
					   					   AND Nwr='0') else '0';

	NID_div_numbuf1a: enreg4
	port map(data(11 downto 8), NID_div_numer1_regen, mclk, Nreset,
			q=>NID_div_num_buff1(11 downto 8));

	NID_div_numbuf1b: enreg8
	port map(data(7 downto 0), NID_div_numer1_regen, mclk, Nreset,
			q=>NID_div_num_buff1(7 downto 0));


------------- NID Numerator Active Register -----------------

	NID_div_numreg1a: enreg4
	port map(NID_div_num_buff1(11 downto 8), setup_transfer1, mclk, Nreset,
			q=>NID_div_numerator1(11 downto 8));

	NID_div_numreg1b: enreg8
	port map(NID_div_num_buff1(7 downto 0), setup_transfer1, mclk, Nreset,
			q=>NID_div_numerator1(7 downto 0));



------------- NID Denominator Buffer Register ---------------

	NID_div_denom1_regen <= '1' when(NID_div_denom1_dcd='1'
					   					   AND Nwr='0') else '0';

	NID_div_denombuf1: enreg8
	port map(data(7 downto 0), NID_div_denom1_regen, mclk, Nreset,
			NID_div_denom_buff1);


------------- NID Denominator Active Register ---------------

	NID_div_denomreg1: enreg8
	port map(NID_div_denom_buff1(7 downto 0), setup_transfer1, mclk, Nreset,
			NID_div_denom1);


-------------------- PD & PR Fault Logic ----------------------

     fault_reset1_regen <= '1' when(fault_reset1_dcd='1'
                                                  AND Nwr='0') else '0';

    fault_reg0 : process(mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        pd1_overlap_fault <= '0';
	elsif(mclk'event AND mclk='1') then
        if(fault_reset1_regen='1') then
            pd1_overlap_fault <= '0';
        elsif(set_pd1_overlap_fault='1') then
            pd1_overlap_fault <= '1';
        end if;
    end if;
    END process fault_reg0;        


    fault_reg1 : process(mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        pd2_overlap_fault <= '0';
	elsif(mclk'event AND mclk='1') then
        if(fault_reset1_regen='1') then
            pd2_overlap_fault <= '0';
        elsif(set_pd2_overlap_fault='1') then
            pd2_overlap_fault <= '1';
        end if;
    end if;
    END process fault_reg1;        

    fault_reg2 : process(mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        pr1_overlap_fault <= '0';
	elsif(mclk'event AND mclk='1') then
        if(fault_reset1_regen='1') then
            pr1_overlap_fault <= '0';
        elsif(set_pr1_overlap_fault='1') then
            pr1_overlap_fault <= '1';
        end if;
    end if;
    END process fault_reg2;        

--    fault_reg3 : process(mclk, Nreset)
--    BEGIN
--    if(Nreset='0') then
--        pr2_overlap_fault <= '0';
--	elsif(mclk'event AND mclk='1') then
--        if(fault_reset1_regen='1') then
--            pr2_overlap_fault <= '0';
--        elsif(set_pr2_overlap_fault='1') then
--            pr2_overlap_fault <= '1';
--        end if;
--    end if;
--    END process fault_reg3;        


--    image_ready_fault1_en <= print_start1 AND not(new_image_readyff1);

--    fault_reg4 : process(mclk, Nreset)
--    BEGIN
--    if(Nreset='0') then
--        image_ready_fault1 <= '0';
--	elsif(mclk'event AND mclk='1') then
--        if(fault_reset1_regen='1') then
--            image_ready_fault1 <= '0';
--        elsif(image_ready_fault1_en='1') then
--            image_ready_fault1 <= '1';
--        end if;
--    end if;
--    END process fault_reg4;        


-------------------- Stroke Fault Logic ----------------------

    fault_reg5 : process(mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        strk_trig_overlap_fault <= '0';
	elsif(mclk'event AND mclk='1') then
        if(fault_reset1_regen='1') then
            strk_trig_overlap_fault <= '0';
        elsif(set_strk_trig_overlap_fault='1') then
            strk_trig_overlap_fault <= '1';
        end if;
    end if;
    END process fault_reg5;        



-------------------- General Interrupt Logic ----------------------

-- Currently, this spare interrupt structure is not used.  A group of
-- these were used in the original IPRO FPGA, for various interrupt
-- inputs from external devices such as UARTS, etc.  The basic 
-- design is included here to ease expansion in a similar interrupt
-- need arises.

-- This interrupt is directly connected to a 405 interrrupt input.

    intr_wr_enable <= '1' when(genint_wren_dcd='1' AND Nwr='0')
                                    else '0';

-- Processor write data for interrupt enable/disable

-- General interrupt reg. can be enlarged to handle more interrupt
-- bits.  IPRO originally used nine of these, i.e. data(8 downto 0).

-- Spare intr omitted for now to save cells.
    
--	genintr_reg: enreg1
--	port map(data(0), intr_wr_enable, mclk, Nreset,
--			genintr_en0);
--
--
--    genintr0_clr <= '1' when(gen_intreset0_dcd='1' AND Nwr='0')
--                                    else '0';
--    genflag0_clr <= '1' when(gen_flagreset0_dcd='1' AND Nwr='0')
--                                    else '0';
--
--    Nintr_stroke <= not(strk_trig_intr);

--    Nintr_spare <= '1';

--
--    gint0 : intreq2 PORT MAP(
--		mclk, Nreset, spare_intrin, genintr_en0,
--		genintr0_clr, genflag0_clr,
--		spare_intr_enabled, spare_intr_flag, set_overlap1_fault0, 
--        intr_spare);

--	genintr_reg1: enreg1
--	port map(data(1), intr_wr_enable, mclk, Nreset,
--			genintr_en1);

--    genintr1_clr <= '1' when(gen_intreset1_dcd='1' AND Nwr='0')
--                                    else '0';
--    genflag1_clr <= '1' when(gen_flagreset1_dcd='1' AND Nwr='0')
--                                    else '0';

--    gint1 : intreq2 PORT MAP(
--		mclk, Nreset, pe1_ready_intrin, genintr_en1, genintr1_clr,
--        genflag1_clr, pe1_ready_intr_enabled, pe1_ready_intr_flag,
--        set_pe1_rdy_overlap1_fault1, pe1_ready_intr);

--------------- Keyboard Beep - Software Driven ---------------------------

--	Software now has the ability to trigger a beep due to user input errors
--  or other criteria as needed.  The one-shot timer used here has a pulse
--  duration of about 16 cycles of the input tick rate.  The initial request
--  by software developers was for about a 1/32 second duration.  The use of
--  the 362 Hz tick will yield about a 42 msec. beep duration.

	pulsegenbeep: pulse_1ms
	PORT MAP(mclk, Nreset, clk362hz_tick, beep_dcd,
			soft_beep);

------------ Keyboard Scanning and Interrupt Logic ------------------------

	KBD_reg_read_strobe <= '1' when(kbd_fifo_read_dcd='1'
					   				AND riwr='1' AND Nrdin='0') else '0';

	kbd_fifo_clr_strobe <= '1' when(kbd_fifo_read_dcd='1' AND Nwr='0') else '0';


	kbdinst : kbd7
	port map(mclk, Nreset, clk362hz_tick, kbdio_intr, kbdio_intr_flag, 
		Nkbd_alt_in, Nkbd_ctrl_in, Nkbd_shift_in, kbdio_int_trig,
		key_down_click, col, row, KBD_reg_read_strobe, kbd_fifo_clr_strobe,
		-- debug outputs

		kbdsig1, kbdsig2, kbdsig3, kbdsig4, kbdsig5, kbdsig6, kbdsig7,

		 fifo_reg_out);

	Nkbd_beep_out <= '0' when (keyboard_beep_enable='1' 
							AND (key_down_click='1' OR soft_beep='1')) else '1';

--	Nkbd_beep_out <= '1';
		 
    kbdio_intrpt_en <= '1' when(kbdio_intrpten1_dcd='1' AND Nwr='0')
                                    else '0';

    kbdintr_ctrl : process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        kbdio_intr_enable <= '0';
	elsif(rising_edge(mclk)) then
        if(kbdio_intrpt_en='1') then
            kbdio_intr_enable <= data(0);
        end if;
    end if;
    END process kbdintr_ctrl;

     kbdio_intr_clr <= '1' when(kbdio_intreset1_dcd='1' AND Nwr='0') else '0';
     kbdio_flag_clr <= '1' when(kbdio_flagreset1_dcd='1' AND Nwr='0') else '0';

     kbdintr: prreq2 PORT MAP(
          mclk, Nreset, kbdio_int_trig, kbdio_intr_enable,
          kbdio_intr_clr, kbdio_flag_clr,
          kbdio_intr_flag, kbdio_intr, open);

------------------- Interrupt Control Logic -------------------------------

-- This unit probably needs significant revision.  The I/O interrupt
-- logic may be set up in a separate, but similar module, since the
-- 405 has a sufficient number of external interrupt inputs.

    interrupt1 : intr_control9 PORT MAP(
		mclk, Nreset, pr1_intr_gated, pd1_intr, 
		image1_intr_gated, backlash_max1_intr, AN_hiintr, AN_lointr, 
        strk_trig_intr, kbdio_intr,
		
		intr_input_reg,

        Nintr_req_hd1, Nintr_kbd_io, Nintr_stroke);


------------------------- Autoencoder Timer 1 -----------------------------

    auto_reset1 <= fault_reset1_regen OR not(Nreset);

    -- NOTE: Autoencode logic has been revised over IPRO-1 only when
    --       two product detectors are used.  Then PD2 is assumed
    --       to be upsteam from PD1.  Thus PD1 is always the print
    --       trigger and PD2 allows the alternate method of PD gap
    --       timing to measure velocity.  Also, edge triggering is
    --       now used for mode 1.

    autoctrl1: process (mclk, auto_reset1)
    BEGIN
	if(auto_reset1='1') then
        autostate1 <= idle;
--        autocount1 <= '0';	  -- Lucent counters need syncronous load
--		autorestart1 <= '1';  -- of 0's to clear; Nreset input ignored.
        autoencode_overflow1 <= '0';
	elsif(rising_edge(mclk)) then
        case autostate1 is

            when idle =>
--			    if(autoencode_mode_ff1='0' AND pd1_filtered='1') then
			    if(pd1_filtered='1') then
                    autostate1 <= restart;
--	 				autorestart1 <= '1';		
--                elsif(autoencode_mode_ff1='1' AND pd2_edge_tick='1') then -- not used for low-end
--                    autostate1 <= restart;
----	 				autorestart1 <= '1';		
                else
                    autostate1 <= idle;
                end if;

			when restart =>
                autostate1 <= restart_end;
-- 				autorestart1 <= '0';		
 
            when restart_end =>
                autostate1 <= count;
--				autocount1 <= '1';

            when count =>
--               if(autoencode_mode_ff1='0' AND pd1_filtered='0') then
               if(pd1_filtered='0') then
                    autostate1 <= count_status;
--                    autocount1 <= '0';
--                elsif(autoencode_mode_ff1='1' AND pd1_edge_tick='1') then -- not used for low-end
--                    autostate1 <= count_status;
--                    autocount1 <= '0';
               else
                    autostate1 <= count;
                end if;

            when count_status =>
                if(auto_limit1='1') then  -- autoencode count exceeded max.
                    autoencode_overflow1 <= '1'; -- it stays set until next
                    autostate1 <= idle;          -- end of cycle test.
                else                   
                    autoencode_overflow1 <= '0';
                    autostate1 <= idle;
                end if;

            when others =>
                    autostate1 <= idle;
--                    autocount1 <= '0';
--					autorestart1 <= '1';		
                    autoencode_overflow1 <= '0';
            end  case;
    end if;            
    END process autoctrl1;

    autocount1 <= '1' when (autostate1 = count) else '0';	
    autorestart1 <= '1' when (autostate1 = restart) else '0';

-- Max. autoencode PD length count of 262,144 clock ticks.
-- This gives a range of 2**18, at which count the upcounter
-- will stop counting.
    auto_limit1 <= autoencode1(18);

    autoenable1 <= not(auto_limit1) AND autocount1;

--& Upper bit of autoencode1 is not used
	autoencoderreghi: ldupcnt4
	port map(clear4, en=>autoenable1, ld=>autorestart1, clk=>mclk,
			cin=>coauto1, Nreset=>Nreset, co=>coauto2,
            q=>autoencode1(19 downto 16));

	autoencoderregmid: ldupcnt8
	port map(clear8, en=>autoenable1, ld=>autorestart1, clk=>mclk,
			cin=>coa1, Nreset=>Nreset, co=>coauto1,
            q=>autoencode1(15 downto 8));

	autoencoderreglow: ldupcnt8
	port map(clear8, en=>autoenable1, ld=>autorestart1, clk=>mclk,
			cin=>clk2kh_tick, Nreset=>Nreset, co=>coa1,
            q=>autoencode1(7 downto 0));


------------------------- Autoencoder Timer 2 -----------------------------

    -- Single head only uses one Autoencode counter

--  autoencode2(19 downto 0) <= (others => '0');
--	autoencode_overflow2 <= '0';
	
------------------------- I/O LOGIC -----------------------------

    image_print_done1_gated <= total_image_done1 OR image_print_abortff1;
--    image_print_done2_gated <= total_image_done2 OR image_print_abortff2;

-- This unit instantiates the new parallel I/Ologic of the IPRO-2

    iounit1:iologic10 port map(
		mclk, Nwr, Nreset, input_config1_dcd,
        output_config2_dcd,	outsrc_config3_dcd, outctrl_config4_dcd,
        intr_in_clr_dcd, flag_in_clr_dcd,
		clk1mh_tick, clk2kh_tick, clk2_9kh_tick, clk1_45kh_tick,
        clk362hz_tick, clk181hz_tick, print_enableff1, 
		image_print_done1_gated,

		Ngenin(8 downto 0),

        data,

        Ngenout(7 downto 0), 
		Ntrired, Ntriyel, Ntrigrn, Nsiren_temp,
        
		input_filtered(8 downto 0),
		intr_input_reg(8 downto 0),
		input_flag_reg(8 downto 0));

		Ngen_out(7 downto 0) <= Ngenout(7 downto 0);
		
		input_filtered(9) <= '0'; -- unused register bit in this version.
		intr_input_reg(9) <= '0'; -- unused register bit in this version.
		input_flag_reg(9) <= '0'; -- unused register bit in this version.


----- TEMP DEBUG

		Ntri_red <= Ntrired;
		Ntri_yel <= Ntriyel;
		Ntri_grn <= Ntrigrn;
		Nsiren   <= Nsiren_temp; -- mod for troubleshooting


------------------------- TEMPORARY DEBUG OUTPUTS ---------------------
		------- Temporary outputs for debugging

--	fifo_reg_out(9) <= fifo_buffer_overflow;
--	fifo_reg_out(8) <= fifoempty;

-----	Ntri_red <= not(clk32kh_tick);
-----    Ntri_yel <= not(clk128kh_tick);
-----    Ntri_grn <= not(clk_div64(8));
-----    Nsiren   <= not(clk2_54mh_tick); 

-----    Ntri_red <= not(kbdsig1);
-----    Ntri_yel <= not(kbdsig2);
-----    Ntri_grn <= not(kbdsig3);
-----    Nsiren   <= not(kbdsig4); 

------------------------- ABORT SELECT LOGIC ---------------------

-- On IPRO, general inputs 8 and 9 are opto-isolated; 
-- inputs 0 through 7 are logic referenced.

--   abortmode1(1)   abortmode1(0)

--      0               0           Abort disabled
--      0               1           Abort enabled, using PD2_filtered
--      1               0           Abort enabled, using logic input 2
--      1               1           Abort enabled, using isolated input 0

    abort_mux : selector_4 
    PORT MAP(mclk, Nreset, high, 
        low, PD2_filtered, input_filtered(1), input_filtered(1),
        abortmode1, abort_start1);

		
------------------ Analog Board Interface Logic ----------------------------

-- All Analog Board interface signals are now active low.  Thus, the renaming
-- and inversions.

	AN_drop_clock <= not(AN_io(10));
	AN_hiintr_in <= not(AN_io(9));
	AN_lointr_in <= not(AN_io(8));
	AN_wd_flag <= not(AN_io(7));


------------------ Analog Board Interrupt Logic ----------------------------

     AN_intrpt_en <= '1' when(AN_intrpten1_dcd='1' AND Nwr='0')
                                    else '0';

    anintr_ctrl : process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        ANintr_enable <= '0';
	elsif(rising_edge(mclk)) then
        if(AN_intrpt_en='1') then
            ANintr_enable <= data(0);
        end if;
    end if;
    END process anintr_ctrl;

     AN_hiintr_clr <= '1' when(AN_hiintreset1_dcd='1' AND Nwr='0') else '0';
     AN_hiflag_clr <= '1' when(AN_hiflagreset1_dcd='1' AND Nwr='0') else '0';

     ANhiintr: prreq2 PORT MAP(
          mclk, Nreset, AN_hiintr_in, ANintr_enable,
          AN_hiintr_clr, AN_hiflag_clr,
          AN_hiintr_flag1, AN_hiintr, set_AN_hiintr_overlap_fault);

-- The following gating function was added to suppress the image done
-- interrupt under the condition that print is disabled.  However, due
-- to concerns over software impact, it was decided not to actually
-- disable the control ff itself, just gate off the prreq output.  In
-- other words, software can still disable the interrupt control register
-- by writing a '0' to the assigned address.  But if it did not, it
-- also does not need to write to this register to re-enable it.  Activating
-- print enable will place the interrupt state where it was left.

--    AN_hiintr_gated <= AN_hiintr AND print_enableff1; -- check if we want this gating
--    AN_lointr_gated <= AN_lointr AND print_enableff1; -- check if we want this gating

     AN_lointr_clr <= '1' when(AN_lointreset1_dcd='1' AND Nwr='0') else '0';
     AN_loflag_clr <= '1' when(AN_loflagreset1_dcd='1' AND Nwr='0') else '0';

     ANlointr: prreq2 PORT MAP(
          mclk, Nreset, AN_lointr_in, ANintr_enable,
          AN_lointr_clr, AN_loflag_clr,
          AN_lointr_flag1, AN_lointr, set_AN_lointr_overlap_fault);



------------------------------------------------------------------

    -- IP print command decode during write cycle.

    print_start1 <= image_print_cmd1_dcd AND not(Nwr); 
                                                       
	image_print_done1 <= imageprint_done1;
	
    strmgr1:dmasyso
  
		port map(mclk, Nreset, 
		 Nwr, print_start1, pr1_match, 
         print_enableff1, Ntotal_done_enable1, 
         strk_trig_hd1, abort_start1,

		 imageprint_done1, image_done, print_start, total_image_done1, image_print_abortff1,
         strokes_abortedff1, full_message_aborted1, setup_transfer1,
         
		 data,

		------- Temporary outputs for debugging

		reload_stroke_count, send_stop_wr, multi_stroke_done, 

		---- Address decode inputs

		 stroke_count_store1_dcd, image_print_abort1_dcd,

		 stroke_count_read1,

		 multi_stroke_reg1);


END archvj1kfpga1;

