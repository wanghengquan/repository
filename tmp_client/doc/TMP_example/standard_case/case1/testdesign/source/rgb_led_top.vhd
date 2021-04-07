--   ==================================================================
--   >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
--   ------------------------------------------------------------------
--   Copyright (c) 2017 by Lattice Semiconductor Corporation
--   ALL RIGHTS RESERVED  
--   ------------------------------------------------------------------
--
--   Permission:
--
--      Lattice SG Pte. Ltd. grants permission to use this code
--      pursuant to the terms of the Lattice Reference Design License Agreement. 
--
--
--   Disclaimer:
--
--      This VHDL or Verilog source code is intended as a design reference
--      which illustrates how these types of functions can be implemented.
--      It is the user's responsibility to verify their design for
--      consistency and functionality through the use of formal
--      verification methods.  Lattice provides no warranty
--      regarding the use or functionality of this code.
--
--   --------------------------------------------------------------------
--
--                  Lattice SG Pte. Ltd.
--                  101 Thomson Road, United Square #07-02 
--                  Singapore 307591
--
--
--                  TEL: 1-800-Lattice (USA and Canada)
--                       +65-6631-2000 (Singapore)
--                       +1-503-268-8001 (other locations)
--
--                  web: http://www.latticesemi.com/
--                  email: techsupport@latticesemi.com
--
-- --------------------------------------------------------------------
--
--  Project:           iCE5UP 5K RGB LED Tutorial 
--  File:              rgb_led_top.vhd
--  Title:             LED PWM control
--  Description:       Top Module
--                 
--
-- --------------------------------------------------------------------
--
--------------------------------------------------------------
-- Notes:
--
--
--------------------------------------------------------------
-- Development History:
--
--   __DATE__ _BY_ _REV_ _DESCRIPTION___________________________
--   04/05/17  RK  1.0    Initial tutorial design for Lattice Radiant
--
--------------------------------------------------------------
-- Dependencies:
--
-- 
--
--------------------------------------------------------------




library ieee;
use ieee.std_logic_1164.all;

--library sb_ice40_components_syn;                     --library files for iCE40 component
--use sb_ice40_components_syn.components.all;
library ice40up;
use ice40up.components.all;

------------------------------------------------------------------------------
--                                                                          --
--                         ENTITY DECLARATION                               --
--                                                                          --
------------------------------------------------------------------------------

entity led_top is          
port(
	clk12M:   in std_logic;
	rst: in std_logic;
	color_sel: in std_logic_vector(1 downto 0);
	RGB_Blink_En: in std_logic;
	
	REDn:      out std_logic;
	BLUn:      out std_logic;
	GRNn:      out std_logic;
	RED:      out std_logic;
	BLU:      out std_logic;
	GRN:      out std_logic
	);
end led_top;


------------------------------------------------------------------------------
--                                                                          --
--                       ARCHITECTURE DEFINITION                            --
--                                                                          --
------------------------------------------------------------------------------
architecture Dataflow of led_top is

--------------------------------
-- INTERNAL SIGNAL DECLARATIONS: 
--------------------------------
signal red_pwm,grn_pwm,blu_pwm: std_logic;

--------------------------------
-- LED COMPONENT INSTANTIATION: 
--------------------------------
component LED_control 
Generic
(
		Brightness :std_logic_vector(3 downto 0) := "0111"; --50% Brightness
		BreatheRamp :std_logic_vector(3 downto 0) := "0110"; --2x
		BlinkRate :std_logic_vector(3 downto 0) := "0101" --1sec
);
port (
  clk12M : in std_logic;
  rst: in std_logic;
  color_sel : in std_logic_vector(1 downto 0);
  RGB_Blink_En: in std_logic;  
  red_pwm   :  out std_logic;
  blu_pwm  : out std_logic;
  grn_pwm   : out std_logic
);
end component;

-----------------------------------------------------
-- RGB Driver Primitive COMPONENT INSTANTIATION: 
-----------------------------------------------------
component RGB
Generic 
(
		

  		--CURRENT_MODE :string := "0b0";
		RGB0_CURRENT :string:="0b111111";
 		RGB1_CURRENT :string:="0b111111" ;
 		RGB2_CURRENT :string:="0b111111"

);
port (
        CURREN : in std_logic;
		 RGB0PWM : in std_logic;
		 RGB1PWM : in std_logic;
		 RGB2PWM : in std_logic;
		 RGBLEDEN : in std_logic;
        RGB0 : out std_logic;
		 RGB1 : out std_logic;
		 RGB2 : out std_logic
	);	 
END COMPONENT;

begin
U1:LED_control               --LED Component Mapping
port map(
  clk12M => clk12M,
  rst=>rst,
  color_sel => color_sel,
  RGB_Blink_En=>RGB_Blink_En,  
  red_pwm  => red_pwm,
  grn_pwm  => grn_pwm,
  blu_pwm => blu_pwm
  );
  
 U2: RGB            --RGB Driver Primitive Mapping
 generic map (RGB0_CURRENT => "0b111111" ,RGB1_CURRENT => "0b111111" ,RGB2_CURRENT => "0b111111" )
 port map(
          		CURREN => '1',
		RGB0PWM => blu_pwm,
		 RGB1PWM => grn_pwm,
		 RGB2PWM => red_pwm,
		 RGBLEDEN => '1', 
        RGB0 => BLUn,
		 RGB1 => GRNn,
		 RGB2 => REDn
	);
RED<=red_pwm;
GRN<=grn_pwm;
BLU<=blu_pwm;
           
end Dataflow;













