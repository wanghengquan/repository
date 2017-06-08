---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--      CAPTURE & COMPARE LOGIC MODULE
-- 
--      FOR THE LOW-END CIJ PLATFORM FPGA
--
--      VHDL DESIGN FILE :CCOMP10.VHD
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
-- This file replaces the capture & compare processor function with
-- hardware logic.  The registers are memory mapped for direct control
-- by the IP.  CCOMP5M brings out the encoder counter so that the
-- processor can read the present count at any time.  The purpose
-- of this is to provide a means for the processor to detect if it
-- is too late in preparing for a print image and setting the compare
-- value.  If the intended compare value (capture plus delay) has
-- already passed, then writing that value will result in a print
-- delay which is most of a full revolution of the encoder counter. 

-- CCOMP6.VHD changed signal naming convention for active low to signal
-- name being preceeded by "N".

-- Modified for use with Synplicity synthesis software.
  
-- CCOMP7.VHD revised certain processes in an attempt to reduce design
-- size.  Specifically, the compare process was changed to a state machine
-- and eliminated the separate compare enable register.

-- CCOMP8.VHD added the detection of the encoder counter wrap-around.
-- Each time that the counter wraps from max count to zero, the
-- "rollover" bit is set.  This bit is clear by action of the software,
-- after reading it.

-- CCOMP9.VHD simplified the Compare state machine by combining the
-- compare load with the compare enable functions into a single command.
-- This will result in a smaller design size.

-- CCOMP10.VHD added 20 bit capture count and encoder count

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--library synopsys;  -- used by Active CAD
--use synopsys.std_logic_arith.all;
--use synopsys.std_logic_unsigned.all;

--library metamor;
--use metamor.attributes.all;

ENTITY ccomp10 IS
    PORT(mclk, Nreset, enc_tick, pd_edge,
        Nwr, print_enable, compare_enable_dcd,
    	compare_load_dcd, rollover_clear_dcd  : in std_logic;
        data : in std_logic_vector(19 downto 0);
        Npr_match, rolloverff : out std_logic;
        capture_data : out std_logic_vector(19 downto 0);
        encoder_count : out std_logic_vector(19 downto 0));
END ccomp10;                         

ARCHITECTURE archccomp10 OF ccomp10 IS

    SIGNAL capture_load, col, high, compare_enable_m,
            compare_load, compare_out, wr_comp_en, compare_enable,
            capture_enable, wr_comp_dis, rollover, midroll, rollover_clear,
			Nprmatch : std_logic;

    SIGNAL encodercount, compare_data : std_logic_vector(19 downto 0);

    TYPE capturestates IS (idle, capture);
--    ATTRIBUTE syn_enum_encoding of capturestates:type is "onehot";

    SIGNAL capturestate : capturestates;

    TYPE comparestates IS (idle, compare);
--    ATTRIBUTE syn_enum_encoding of comparestates:type is "onehot";

    SIGNAL comparestate : comparestates;

--    ATTRIBUTE syn_keep of compare_out : SIGNAL IS true;

COMPONENT upcnt8
	port(en, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(7 downto 0));
END COMPONENT;

COMPONENT upcnt4
	port(en, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(3 downto 0));
END COMPONENT;

    --attribute FPGA_gsr: boolean;
    --attribute FPGA_gsr of Nreset:signal is true; -- routed using GSR.
                                                 -- (active low)
BEGIN

	high <= '1';

    ------------- Encoder Counter ----------------

    encctr_top : upcnt4
	port map(high, mclk, midroll, Nreset,
         rollover, encodercount(19 downto 16));

    encctr_msb : upcnt8
	port map(high, mclk, col, Nreset,
         midroll, encodercount(15 downto 8));

    encctr_lsb : upcnt8
	port map(high, mclk, enc_tick, Nreset,
	col, encodercount(7 downto 0));
	
	encoder_count <= encodercount;

    ------- Encoder Counter Rollover Latch --------

	rollover_clear <= '1' when (rollover_clear_dcd='1' AND Nwr='0') else '0';

    ctr_rollover : process (mclk, Nreset)
    BEGIN
    if(Nreset='0') then
        rolloverff <= '0';
	elsif(rising_edge(mclk)) then
        if(rollover='1') then
            rolloverff <= '1';
        elsif(rollover_clear='1') then
            rolloverff <= '0';
		end if;
    end if;
    END process ctr_rollover;


    ------------- Capture Enable ----------------

    	capture_enable <= print_enable;

    ------------- Capture Process ----------------

    capture_ctrl : process (mclk, Nreset)

    BEGIN

    if(Nreset='0') then
        capturestate <= idle;
        capture_data <= (others => '0');            
    elsif(rising_edge(mclk)) then
        case capturestate is
            when idle =>
                if(capture_enable='1') then
                    capturestate <= capture;
                end if;

            when capture =>
                if(pd_edge='1') then
                    capture_data <= encodercount;            
                    capturestate <= capture;
                elsif(capture_enable='0') then
                    capturestate <= idle;
                end if;

            when others => 
                capturestate <= idle;
          end case;
    end if;
    END process capture_ctrl;

    ------------- Compare Process -----------------

    -- Software enables a compare cycle.

--    wr_comp_en <= '1' when(compare_enable_dcd='1' AND Nwr='0'
--                            AND data(0)='1') else '0';

    -- Software disables compare cycle.

    wr_comp_dis <= '1' when(compare_enable_dcd='1' AND Nwr='0'
                            AND data(0)='0') else '0';

    compare_load <= '1' when (compare_load_dcd='1' AND Nwr='0') else '0';

    compare_out <= '1' when (compare_data=encodercount) else '0';

    compare_enablectrl : process (mclk, Nreset)

    BEGIN
    if(Nreset='0') then
        Nprmatch <= '1';
        compare_data <= (others=>'0');
        comparestate <= idle;
    elsif(rising_edge(mclk)) then
        case comparestate is
            when idle =>
                Nprmatch <= '1';
                if(compare_load='1') then
                    compare_data <= data(19 downto 0);            
                    comparestate <= compare;
                end if;

            when compare =>
                if(compare_out='1') then     
                    Nprmatch <= '0';        
                    comparestate <= idle;    
                elsif (wr_comp_dis='1') then 
                    comparestate <= idle;
                end if;

            when others => 
                comparestate <= idle;
          end case;
    end if;
    END process compare_enablectrl;

	Npr_match <= Nprmatch;

END archccomp10;


