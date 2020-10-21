---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--      MULTIPLE SOURCE INTERRUPT LOGIC MODULE
-- 
--      FOR THE LOW-END CIJ PLATFORM FPGA
--
--      VHDL DESIGN FILE :INTCTRL9.VHD
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
-- This interrupt logic is significantly simplified as compared to 
-- previous versions.  For each of the two interrupt systems, one for
-- each of the two processor interrupt inputs, the set of inputs
-- is ORed and clock syncronized.  The "vector" output is a word
-- in which each interrupt sets a bit high when true.  Multiple
-- simultaneous input will cause multiple bits to be set.  The
-- processor will sort out the priorities.

-- This file is a modification from IPRO file, intctrld.vhd, with one logic 
-- input instead of ten. 
--
-- INTCTRL6.VHD is revised for Low-End CIJ Platform controller FPGA.  The 
-- design does not support two product detects or encoders, etc.  There are 
-- no plans, for now, to support two heads or two nozzles.  A new interrupt
-- for stroke triggering is now included.  The print engine is the same
-- processor as the IP, so no pe_ready interrupts.  There may eventually
-- be some added cij-related faults interrupts added.  The present version 
-- will be adapted for use in an IPRO to test various functionality.
--
-- INTCTRL7.VHD is revised for low-end so as to include the "Print Engine"
-- interrupts, high and low priority.  These are ORed in the IO interrupt
-- output.
--
-- INTCTRL8.VHD is revised for Videojet 1000 with expanded inputs, single 
-- printhead, etc.  The keyboard and IO interrupts are combined in a single
-- interrupt output.
--
-- INTCTRL9.VHD is revised so that the AN_intr input is ORed into the
-- high priority "stroke" interrupt called Nintr_req_hd1.
--
library ieee;
use ieee.std_logic_1164.all;

library synplify;
use synplify.attributes.all;

ENTITY intr_control9 IS
    PORT(mclk, Nreset, pr1_intr, pd1_intr, 
		image1_intr, backlash_max1_intr, AN_hiintr, AN_lointr,
		strk_trig_intr, kbdio_intr : in std_logic; 
		
		intr_input_reg : in std_logic_vector(9 downto 0);

        Nintr_req_hd1, Nintr_kbd_io, Nintr_stroke : out std_logic);
END intr_control9;                         


ARCHITECTURE archintr_control9 OF intr_control9 IS

    --attribute FPGA_gsr: boolean;
    --attribute FPGA_gsr of Nreset:signal is true; -- routed using GSR.
                                                 -- (active low)

        SIGNAL intr_req_hd1, intr_req_kbd_an, intr_req_kbdan,
		intr_reqio,intr_req_io,  Nintr_req_hd1_temp, Nintr_kbdio_temp,
		Nintr_stroke_temp : std_logic;
		
BEGIN

    intr_req_hd1 <= (pr1_intr OR pd1_intr OR image1_intr
                OR backlash_max1_intr);

--    intr_req_kbdan <= kbdio_intr OR AN_hiintr OR AN_lointr;
    intr_req_kbdan <= kbdio_intr OR AN_lointr;

    intr_reqio <= intr_input_reg(9) OR intr_input_reg(8) OR intr_input_reg(7)
        OR intr_input_reg(6) OR intr_input_reg(5) OR intr_input_reg(4) OR intr_input_reg(3)
        OR intr_input_reg(2) OR intr_input_reg(1) OR intr_input_reg(0);
	
intrctrl1: process  (mclk, Nreset)

    BEGIN
      if(Nreset='0') then
        Nintr_req_hd1_temp <= '1';
        Nintr_kbdio_temp <= '1';
		Nintr_stroke_temp <= '1';
		intr_req_kbd_an <= '0';
		intr_req_io <= '0';
      elsif(rising_edge(mclk)) then
        Nintr_req_hd1_temp <= not(intr_req_hd1);
		Nintr_stroke_temp <= not(strk_trig_intr OR AN_hiintr); 
		Nintr_kbdio_temp <= not(intr_req_io OR intr_req_kbd_an);
		intr_req_io <= intr_reqio;
		intr_req_kbd_an <= intr_req_kbdan;
      end if;
   END process intrctrl1;

   Nintr_kbd_io <= Nintr_kbdio_temp;

   Nintr_req_hd1 <= Nintr_req_hd1_temp;
   
   Nintr_stroke <= Nintr_stroke_temp;
   
END archintr_control9;

