---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--      GENERAL REGISTER & OTHER COMPONENTS
--       
--      VHDL DESIGN FILE :ALTUSR1OUT.VHD - Specifically modified for Altera
--									  ACEX applications; uses some Altera
--									  library component instantiations.
--										(OUT version modified for only OUT
--										type of outputs; no buffer types.)
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
-- USR2.VHD changed signal naming convention for active low to signal name
-- being preceeded by "N".

-- Modified for use with Synplicity synthesis software.

library ieee;
use ieee.std_logic_1164.all;

PACKAGE user1_pkg IS

COMPONENT enreg1
	port(d, en, clk, Nreset : in std_logic;
		 q : out std_logic);
END COMPONENT;

COMPONENT enreg2
	port(d : in std_logic_vector(1 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(1 downto 0));
END COMPONENT;

COMPONENT enreg4
	port(d : in std_logic_vector(3 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(3 downto 0));
END COMPONENT;

COMPONENT enreg8
	port(d : in std_logic_vector(7 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(7 downto 0));
END COMPONENT;

COMPONENT enreg9
	port(d : in std_logic_vector(8 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(8 downto 0));
END COMPONENT;

COMPONENT enreg10
	port(d : in std_logic_vector(9 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(9 downto 0));
END COMPONENT;

COMPONENT enreg11
	port(d : in std_logic_vector(10 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(10 downto 0));
END COMPONENT;

COMPONENT enreg16
	port(d : in std_logic_vector(15 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(15 downto 0));
END COMPONENT;

COMPONENT updncnt1
	port(d : in std_logic;
		 en, upidn, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic);
END COMPONENT;

COMPONENT updncnt8
	port(d : in std_logic_vector(7 downto 0);
		 en, upidn, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(7 downto 0));
END COMPONENT;

COMPONENT updncnt12
	port(en, upidn, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(11 downto 0));
END COMPONENT;

COMPONENT updncnt16
	port(en, upidn, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(15 downto 0));
END COMPONENT;

COMPONENT updncnt20
	port(en, upidn, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(19 downto 0));
END COMPONENT;

COMPONENT lddncnt4
	port(d : in std_logic_vector(3 downto 0);
		 en, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(3 downto 0));
END COMPONENT;

COMPONENT lddncnt8
	port(d : in std_logic_vector(7 downto 0);
		 en, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(7 downto 0));
END COMPONENT;

COMPONENT upcnt4
	port(en, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(3 downto 0));
END COMPONENT;

COMPONENT ldupcnt4
	port(d : in std_logic_vector(3 downto 0);
		 en, ld, clk, cin, Nreset : in std_logic;
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

COMPONENT acc4
	port(d : in std_logic_vector(3 downto 0);
		 cin, en, clk, reset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(3 downto 0));
END COMPONENT;

COMPONENT selector_2 IS PORT(mclk, Nreset, enable, 
        input0, input1, selector: in std_logic;
		sel_out : out std_logic);
END COMPONENT;

COMPONENT selector_4
    PORT(mclk, Nreset, enable, 
        input0, input1, input2, input3: in std_logic;
        selector :std_logic_vector(1 downto 0);
		sel_out : out std_logic);
END COMPONENT;

--&
component mux_32
	port (a,b: in std_logic_vector (31 downto 0); 
		y: out std_logic_vector(31 downto 0);
		Nreset, mclk, sel: in std_logic);
END COMPONENT;


COMPONENT pulse1us
	PORT (mclk, Nreset, clk1mh_tick, pulse_in : in std_logic;
		pulse_out : out std_logic);
    END COMPONENT;

COMPONENT pulse_5 
    PORT(mclk, Nreset, clk_tick, pulse_in : in std_logic;
		pulse_out : out std_logic);
END COMPONENT;

COMPONENT pulse_1ms 
	PORT(mclk, Nreset, clk16kh_tick, pulse_in : in std_logic;
		pulse_out : out std_logic);
END COMPONENT;

COMPONENT pulse_rt_1ms 
	PORT(mclk, Nreset, clk16kh_tick, pulse_in : in std_logic;
		pulse_out : out std_logic);
END COMPONENT;


END user1_pkg;


library ieee;
use ieee.std_logic_1164.all;

ENTITY enreg1 IS
	port(d, en, clk, Nreset : in std_logic;
		 q : out std_logic);

END enreg1;

ARCHITECTURE archenreg1 OF enreg1 IS

	BEGIN

	reg1: process (clk, Nreset)
	BEGIN

	if(Nreset='0') then
		q <= '0';
	elsif rising_edge(clk) then
		if (en='1') then
		   q <= d;
        end if;
	end if;
	END process reg1;

END archenreg1;


library ieee;
use ieee.std_logic_1164.all;

ENTITY enreg2 IS
	port(d : in std_logic_vector(1 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(1 downto 0));
END enreg2;

ARCHITECTURE archenreg2 OF enreg2 IS

	BEGIN

	reg2: process (clk, Nreset)
	BEGIN

	if(Nreset='0') then
		q <= (others=> '0');
	elsif rising_edge(clk) then
		if (en='1') then
		   q <= d;
        end if;
	end if;
	END process reg2;


END archenreg2;


library ieee;
use ieee.std_logic_1164.all;

ENTITY enreg4 IS
	port(d : in std_logic_vector(3 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(3 downto 0));
END enreg4;

ARCHITECTURE archenreg4 OF enreg4 IS

	BEGIN

	reg4: process (clk, Nreset)
	BEGIN

	if(Nreset='0') then
		q <= (others=> '0');
	elsif rising_edge(clk) then
		if (en='1') then
		   q <= d;
        end if;
	end if;
	END process reg4;

 
END archenreg4;

library ieee;
use ieee.std_logic_1164.all;


ENTITY enreg8 IS
	port(d : in std_logic_vector(7 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(7 downto 0));
END enreg8;

ARCHITECTURE archenreg8 OF enreg8 IS

	BEGIN

	reg8: process (clk, Nreset)
	BEGIN

	if(Nreset='0') then
		q <= (others=> '0');
	elsif rising_edge(clk) then
		if (en='1') then
		   q <= d;
        end if;
	end if;
	END process reg8;


END archenreg8;

library ieee;
use ieee.std_logic_1164.all;


ENTITY enreg9 IS
	port(d : in std_logic_vector(8 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(8 downto 0));
END enreg9;

ARCHITECTURE archenreg9 OF enreg9 IS

	BEGIN

	reg9: process (clk, Nreset)
	BEGIN

	if(Nreset='0') then
		q <= (others=> '0');
	elsif rising_edge(clk) then
		if (en='1') then
		   q <= d;
        end if;
	end if;
	END process reg9;


END archenreg9;

library ieee;
use ieee.std_logic_1164.all;

ENTITY enreg10 IS
	port(d : in std_logic_vector(9 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(9 downto 0));
END enreg10;

ARCHITECTURE archenreg10 OF enreg10 IS

	BEGIN

	reg10: process (clk, Nreset)
	BEGIN

	if(Nreset='0') then
		q <= (others=> '0');
	elsif rising_edge(clk) then
		if (en='1') then
		   q <= d;
        end if;
	end if;
	END process reg10;


END archenreg10;

library ieee;
use ieee.std_logic_1164.all;

ENTITY enreg11 IS
	port(d : in std_logic_vector(10 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(10 downto 0));
END enreg11;

ARCHITECTURE archenreg11 OF enreg11 IS

	BEGIN

	reg11: process (clk, Nreset)
	BEGIN

	if(Nreset='0') then
		q <= (others=> '0');
	elsif rising_edge(clk) then
		if (en='1') then
		   q <= d;
        end if;
	end if;
	END process reg11;


END archenreg11;


library ieee;
use ieee.std_logic_1164.all;

ENTITY enreg16 IS
	port(d : in std_logic_vector(15 downto 0);
		 en, clk, Nreset : in std_logic;
		 q : out std_logic_vector(15 downto 0));
END enreg16;

ARCHITECTURE archenreg16 OF enreg16 IS

	BEGIN

	reg16: process (clk, Nreset)
	BEGIN

	if(Nreset='0') then
		q <= (others=> '0');
	elsif rising_edge(clk) then
		if (en='1') then
		   q <= d;
        end if;
	end if;
	END process reg16;


END archenreg16;


-------------------------------- Counters -----------------------------

library ieee;
use ieee.std_logic_1164.all;

ENTITY updncnt1 IS
	port(d : in std_logic;
		 en, upidn, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic);
END updncnt1;

ARCHITECTURE archupdncnt1 OF updncnt1 IS

    SIGNAL qtemp, qnext, dniup : std_logic;

	BEGIN

    dniup <= not(upidn);
    
    udcnt1: process (clk, Nreset)
    BEGIN

	if(Nreset='0') then
        qtemp <= '0';
	elsif rising_edge(clk) then
        if(ld='1') then
            qtemp  <= d;
        else
            qtemp  <= qnext;
        end if;
    end if;
    END process udcnt1;

    ldcarry1: process (en, cin, dniup, qtemp)
    BEGIN

    if(en='0' OR cin=dniup) then -- emulate Lucent w/ down count
        qnext <= qtemp;			   -- using active low cin
    else
        qnext <= not(qtemp);
    end if;

    END process ldcarry1;

    co <= '0'; -- co unused, so logic omitted.

	q <= qtemp;
	
END archupdncnt1;

    
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY updncnt16 IS
	port(en, upidn, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(15 downto 0));
END updncnt16;

ARCHITECTURE archupdncnt16 OF updncnt16 IS

    SIGNAL qtemp : std_logic_vector(15 downto 0);

BEGIN

    udcnt16: process (clk, Nreset, en, cin, upidn)
    BEGIN

	if(Nreset='0') then
        qtemp <= (others=> '0');
	elsif rising_edge(clk) then
		if(en='1' AND cin='1' AND upidn='1') then -- count up
		    qtemp <= qtemp + 1;
		elsif(en='1' AND cin='0' AND upidn='0') then -- count down
		    qtemp <= qtemp - 1; -- emulate Lucent w/ down count using active low cin
        end if;
    end if;
    END process udcnt16;

	q <= qtemp;

    co <= '0'; -- co unused, so logic omitted.

END archupdncnt16;
    
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY updncnt20 IS
	port(en, upidn, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(19 downto 0));
END updncnt20;

ARCHITECTURE archupdncnt20 OF updncnt20 IS

--      The SP input must be true for load and count enable functions.
--
--       Also, cin and co polarity vary with direction input based
--       on Lucent macro design.

    SIGNAL qtemp : std_logic_vector(19 downto 0);

	BEGIN

    udcnt20: process (clk, Nreset, en, cin, upidn)
    BEGIN

	if(Nreset='0') then
        qtemp <= (others=> '0');
	elsif rising_edge(clk) then
		if(en='1' AND cin='1' AND upidn='1') then -- count up
		    qtemp <= qtemp + 1;
		elsif(en='1' AND cin='0' AND upidn='0') then -- count down
		    qtemp <= qtemp - 1; -- emulate Lucent w/ down count using active low cin
        end if;
    end if;
    END process udcnt20;

	q <= qtemp;

    co <= '0'; -- co unused, so logic omitted.

END archupdncnt20;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY lddncnt4 IS
	port(d : in std_logic_vector(3 downto 0);
		 en, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(3 downto 0));
END lddncnt4;

ARCHITECTURE archlddncnt4 OF lddncnt4 IS

-- NOTE: The instantiation of this Lucent counter does NOT include
--		 the "clear" or reset input.  In the application design,
--		 the counter must be syncronously loaded with 0's if needed
--		 to be held at zero.
--      Also, the SP input must be true for load and count enable functions.
--
--       Also, cin and co polarity vary with direction input based
--       on Lucent macro design.

    SIGNAL qtemp : std_logic_vector(3 downto 0);

    BEGIN

    ldncnt4: process (clk, Nreset, ld, en, cin)
    BEGIN

	if(Nreset='0') then
        qtemp <= (others=> '0');
	elsif rising_edge(clk) then
	    if(ld='1') then
		    qtemp <= d;
		elsif(en='1' AND cin='0') then -- count down
		    qtemp <= qtemp - 1; -- emulate Lucent w/ down count using active low cin
        end if;
    end if;
    END process ldncnt4;

    co <= '0' when qtemp="0000" AND cin='0' else '1'; -- active low for down count

	q <= qtemp;
	
END archlddncnt4;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY lddncnt8 IS
	port(d : in std_logic_vector(7 downto 0);
		 en, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(7 downto 0));
END lddncnt8;

ARCHITECTURE archlddncnt8 OF lddncnt8 IS

-- NOTE: The instantiation of this Lucent counter does NOT include
--		 the "clear" or reset input.  In the application design,
--		 the counter must be syncronously loaded with 0's if needed
--		 to be held at zero.
--
--       Also, cin and co polarity vary with direction input based
--       on Lucent macro design.

    SIGNAL qtemp : std_logic_vector(7 downto 0);

	BEGIN

    ldncnt8: process (clk, Nreset, ld, en, cin)
    BEGIN

	if(Nreset='0') then
        qtemp <= (others=> '0');
	elsif rising_edge(clk) then
	    if(ld='1') then
		    qtemp <= d;
		elsif(en='1' AND cin='0') then -- count down
		    qtemp <= qtemp - 1; -- emulate Lucent w/ down count using active low cin
        end if;
    end if;
    END process ldncnt8;

    co <= '0' when qtemp="00000000" AND cin='0' else '1'; -- active low for down count

	q <= qtemp;

END archlddncnt8;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY upcnt4 IS
	port(en, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(3 downto 0));
END upcnt4;

ARCHITECTURE archupcnt4 OF upcnt4 IS

--      The SP input must be true for count enable function.
--
--       Also, cin and co polarity vary with direction input based
--       on Lucent macro design.

    SIGNAL qtemp : std_logic_vector(3 downto 0);

BEGIN

    upcount4: process (clk, Nreset, en, cin)
    BEGIN

	if(Nreset='0') then
        qtemp <= (others=> '0');
	elsif rising_edge(clk) then
		if(en='1' AND cin='1') then -- count up
		    qtemp <= qtemp + 1; -- emulate Lucent w/ up count using active high cin
        end if;
    end if;
    END process upcount4;

    co <= '1' when (qtemp="1111" AND cin='1') else '0';

	q <= qtemp;

END archupcnt4;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY ldupcnt4 IS
	port(d : in std_logic_vector(3 downto 0);
		 en, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(3 downto 0));
END ldupcnt4;

ARCHITECTURE archldupcnt4 OF ldupcnt4 IS
-- NOTE: The instantiation of this Lucent counter does NOT include
--		 the "clear" or reset input.  In the application design,
--		 the counter must be syncronously loaded with 0's if needed
--		 to be held at zero.
--      Also, the SP input must be true for load and count enable functions.
--
--       Also, cin and co polarity vary with direction input based
--       on Lucent macro design.

    SIGNAL qtemp : std_logic_vector(3 downto 0);

	BEGIN

    ldupcount4: process (clk, ld, en, cin, Nreset, qtemp)
    BEGIN

	if(Nreset='0') then
        qtemp <= (others=> '0');
	elsif rising_edge(clk) then
	    if(ld='1') then
		    qtemp <= d;
		elsif(en='1' AND cin='1') then -- count up
		    qtemp <= qtemp + 1; -- emulate Lucent w/ up count using active high cin
        end if;
    end if;
    END process ldupcount4;

    co <= '1' when (qtemp="1111" AND cin='1') else '0';

	q <= qtemp;

END archldupcnt4;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY upcnt8 IS
	port(en, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(7 downto 0));
END upcnt8;

ARCHITECTURE archupcnt8 OF upcnt8 IS

--      The SP input must be true for count enable function.
--
--       Also, cin and co polarity vary with direction input based
--       on Lucent macro design.

    SIGNAL qtemp : std_logic_vector(7 downto 0);

	BEGIN

    upcount8: process (clk, Nreset, en, cin, qtemp)
    BEGIN

	if(Nreset='0') then
        qtemp <= (others=> '0');
	elsif rising_edge(clk) then
		if(en='1' AND cin='1') then -- count up
		    qtemp <= qtemp + 1; -- emulate Lucent w/ up count using active high cin
        end if;
    end if;
    END process upcount8;

    co <= '1' when (qtemp="11111111" AND cin='1') else '0';

	q <= qtemp;
		
END archupcnt8;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY ldupcnt8 IS
	port(d : in std_logic_vector(7 downto 0);
		 en, ld, clk, cin, Nreset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(7 downto 0));
END ldupcnt8;

ARCHITECTURE archldupcnt8 OF ldupcnt8 IS

-- NOTE: The instantiation of this Lucent counter does NOT include
--		 the "clear" or reset input.  In the application design,
--		 the counter must be syncronously loaded with 0's if needed
--		 to be held at zero.
--
--       Also, cin and co polarity vary with direction input based
--       on Lucent macro design.

    SIGNAL qtemp : std_logic_vector(7 downto 0);

	BEGIN

    ldupcount8: process (clk, en, cin, Nreset, qtemp)
    BEGIN

	if(Nreset='0') then
		qtemp <= (others=> '0');
	elsif rising_edge(clk) then
	    if(ld='1') then
		    qtemp <= d;
		elsif(en='1' AND cin='1') then -- count up
		    qtemp <= qtemp + 1; -- emulate Lucent w/ up count using active high cin
        end if;
    end if;
    END process ldupcount8;

    co <= '1' when (qtemp="11111111" AND cin='1') else '0';

	q <= qtemp;
		
END archldupcnt8;



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY acc4 IS
	PORT(d : in std_logic_vector(3 downto 0);
		 cin, enable, clk, reset : in std_logic;
         co : out std_logic;
		 q : out std_logic_vector(3 downto 0));
END acc4;

ARCHITECTURE archacc4 OF acc4 IS

    SIGNAL qtemp : std_logic_vector(3 downto 0);
    SIGNAL tempsum : std_logic_vector(4 downto 0);

BEGIN


	tempsum <= ('0' & d) + ('0' & qtemp) + cin;


    accumreg : process(clk, reset)
    BEGIN
    if(reset='1') then
        qtemp <= "0000";
    elsif(rising_edge(clk)) then
        if(enable='1') then
            qtemp <= tempsum(3 downto 0);
        end if;
    end if;
    END process accumreg;

    co <= tempsum(4);

	q <= qtemp;
	
END archacc4;


library ieee;
use ieee.std_logic_1164.all;

ENTITY pulse1us IS PORT(mclk, Nreset, clk1mh_tick, pulse_in : in std_logic;
		pulse_out : out std_logic);
END pulse1us;

ARCHITECTURE archpulse1us OF pulse1us is
    type pulsestates is (idle, pulse1, pulse2, pulse3);
	SIGNAL pulsestate : pulsestates;
	SIGNAL pulse_on, count_tick : std_logic;

BEGIN
-- Generates a 1.0 to 2.0 microsecond pulse, when driven by
-- an 1 MHz clock tick, (16MHz master clk) and triggered by a rising
-- edge of the input pulse.

    pulsecount1: process (mclk, Nreset)
    BEGIN
	if(Nreset='0') then
        pulsestate <= idle;
--        pulse_on <= '0';
	elsif(rising_edge(mclk)) then
        case pulsestate is
            when idle =>
--                pulse_on <= '0';
	        	if(pulse_in='1') then
                	pulsestate <= pulse1;
--               		pulse_on <= '1';
            	else
                	pulsestate <= idle;
            	end if;
            when pulse1 =>
				if(clk1mh_tick='1') then
                	pulsestate <= pulse2;
				end if;
			when pulse2 =>
				if(clk1mh_tick='1') then
                	pulsestate <= idle;
--                	pulse_on <= '0';
				end if; 
            when others =>
                pulsestate <= idle;
        end case;
      end if;
    END process pulsecount1;

    pulse_on <= '1' when (pulsestate /= idle) else '0';

	pulse_out <= pulse_on;

END archpulse1us;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY pulse_5 IS PORT(mclk, Nreset, clk_tick, pulse_in : in std_logic;
		pulse_out : out std_logic);
END pulse_5;

ARCHITECTURE archpulse_5 OF pulse_5 is
    type countstates is (idle, count_run); -- , count_rst);
	SIGNAL countstate : countstates;
	SIGNAL count_reset, count_enable, pulsecount_out, low : std_logic;
	SIGNAL counter8 :std_logic_vector(2 downto 0);

    --attribute FPGA_gsr: boolean;
    --attribute FPGA_gsr of Nreset:signal is true; -- routed using GSR. (active low)
BEGIN
-- Generates a pulse with a width of five clock periods of the
-- input clock tick.  The pulse is triggered by the input pulse.

-------------------- Five Pulse Counter --------------------

	count5: process (mclk, Nreset)
	BEGIN
	if(Nreset='0') then
		counter8 <= "000";
		pulsecount_out <= '0';
	elsif(rising_edge(mclk)) then
			if(count_reset='1') then
				counter8 <= "000";
				pulsecount_out <= '0';
			elsif(clk_tick='1') then
				counter8 <= counter8 + 1;
				if(counter8>="100") then
					pulsecount_out <= '1';
				else
					pulsecount_out <= '0';
				end if;
			end if;
	end if;
	END process count5;
				

    make_pulse: process (mclk, Nreset)
    BEGIN
	if(Nreset='0') then
        countstate <= idle;
--        count_reset <= '1';
	elsif(rising_edge(mclk)) then
        case countstate is
            when idle =>
--                count_reset <= '1';
		    	if(pulse_in='1') then
       	        	countstate <= count_run;
--           	    	count_reset <= '0';
           		else
               		countstate <= idle;
           		end if;
            when count_run =>
				if(pulsecount_out='1') then
--	            	count_reset <= '1';
                	countstate <= idle;
				end if;
            when others =>
                countstate <= idle;
        end case;
    end if;
    END process make_pulse;

    count_reset <= '1' when (countstate = idle) else '0';

--	count_enable <= not(count_reset);
	pulse_out 	 <= not(count_reset);

END archpulse_5;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY pulse_1ms IS PORT(mclk, Nreset, clk16kh_tick, pulse_in : in std_logic;
		pulse_out : out std_logic);
END pulse_1ms;

ARCHITECTURE archpulse_1ms OF pulse_1ms is
    type countstates is (idle, count_run); -- , count_rst);
	SIGNAL countstate : countstates;
	SIGNAL count_reset, count_enable, pulsecount_out, low : std_logic;
	SIGNAL counter16 :std_logic_vector(3 downto 0);

BEGIN
-- Generates a pulse, approximately 1ms, when driven by
-- an 1/64 MHz clock, and triggered by a short, active-high
-- input pulse, intended to be from a processor write strobe.
-- The  clock clk16kh is actually 15.625KHz when derived from a system
-- mclk of 16MHz.  If that clock is increased to 20MHz, then clk16kh
-- is actually 19.5KHz and the generated pulse  width becomes about .8 msec.

-------------------- 1 Millisecond Pulse Counter --------------------

	count16: process (mclk, Nreset)
	BEGIN
	if(Nreset='0') then
		counter16 <= "0000";
		pulsecount_out <= '0';
	elsif(rising_edge(mclk)) then
			if(count_reset='1') then
				counter16 <= "0000";
				pulsecount_out <= '0';
			elsif(clk16kh_tick='1') then  --62 uS tick
				counter16 <= counter16 + 1;
--				if(counter16="1111") then
--					pulsecount_out <= '1';
--				else
--					pulsecount_out <= '0';
--				end if;
			end if;
	end if;
	END process count16;
				

    make_1ms_pulse: process (mclk, Nreset)
    BEGIN
	if(Nreset='0') then
        countstate <= idle;
--        count_reset <= '1';
	elsif(rising_edge(mclk)) then
        case countstate is
            when idle =>
--                count_reset <= '1';
		    	if(pulse_in='1') then
       	        	countstate <= count_run;
--           	    	count_reset <= '0';
           		else
               		countstate <= idle;
           		end if;
            when count_run =>						
				if(counter16 = "1111") then
--				if(pulsecount_out='1') then
--	            	count_reset <= '1';
                	countstate <= idle;
				end if;
            when others =>
                countstate <= idle;
        end case;
    end if;
    END process make_1ms_pulse;

    count_reset <= '1' when (countstate = idle) else '0';

--	count_enable <= not(count_reset);
	pulse_out 	 <= not(count_reset);

END archpulse_1ms;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY pulse_rt_1ms IS PORT(mclk, Nreset, clk16kh_tick, pulse_in : in std_logic;
		pulse_out : out std_logic);
END pulse_rt_1ms;

ARCHITECTURE archpulse_rt_1ms OF pulse_rt_1ms is
    type countstates is (idle, count_run); -- , count_rst);
	SIGNAL countstate : countstates;
	SIGNAL count_reset, count_enable, pulsecount_out, low : std_logic;
	SIGNAL counter16 :std_logic_vector(3 downto 0);

BEGIN
-- Generates a retriggerable pulse, approximately 1mS, when driven by
-- an 1/64 MHz clock, and triggered by a short, active-high
-- input pulse, intended to be from a processor write strobe.
-- The  clock clk16kh is actually 15.625KHz when derived from a system
-- mclk of 16MHz.  If that clock is increased to 20MHz, then clk16kh
-- is actually 19.5KHz and the generated pulse  width becomes about .8 msec.

-------------------- 1 Millisecond Pulse Counter --------------------

	count16: process (mclk, Nreset)
	BEGIN
	if(Nreset='0') then
		counter16 <= "0000";
		pulsecount_out <= '0';
	elsif(rising_edge(mclk)) then
			if(count_reset='1' OR pulse_in='1') then --retriggers here
				counter16 <= "0000";
				pulsecount_out <= '0';
			elsif(clk16kh_tick='1') then
				counter16 <= counter16 + 1;
			end if;
	end if;
	END process count16;
				

    make_1ms_pulse: process (mclk, Nreset)
    BEGIN
	if(Nreset='0') then
        countstate <= idle;
--        count_reset <= '1';
	elsif(rising_edge(mclk)) then
        case countstate is
            when idle =>
--                count_reset <= '1';
		    	if(pulse_in='1') then
       	        	countstate <= count_run;
--           	    	count_reset <= '0';
           		else
               		countstate <= idle;
           		end if;
            when count_run =>
				if(counter16 = "1111" 
				AND pulse_in = '0') then -- the AND condition 
										 -- avoids missing retrigger
										 -- on last clock cycle of a
										 -- 1ms pulse
--	            	count_reset <= '1';
                	countstate <= idle;
				else
				end if;
            when others =>
                countstate <= idle;
        end case;
    end if;
    END process make_1ms_pulse;

    count_reset <= '1' when (countstate = idle) else '0';

--	count_enable <= not(count_reset);
	pulse_out 	 <= not(count_reset);

END archpulse_rt_1ms;


library ieee;
use ieee.std_logic_1164.all;

ENTITY selector_2 IS PORT(mclk, Nreset, enable, 
        input0, input1, selector: in std_logic;
		sel_out : out std_logic);
END selector_2;

ARCHITECTURE archselector_2 OF selector_2 is

    --attribute FPGA_gsr: boolean;
    --attribute FPGA_gsr of Nreset:signal is true; -- routed using GSR. (active low)
BEGIN
    two_selector: process (mclk, Nreset)
    BEGIN
    if (Nreset='0') then
        sel_out  <= '0';
	elsif(rising_edge (mclk)) then
		if(enable='1') then
		    case selector is
		
		        when '1' =>
		            sel_out <= input1;
		
		        when '0' =>
		            sel_out <= input0;
		
				when others =>
					sel_out <= '0';
		    end case;
		else
			sel_out <= '0';
		end if;
	end if;
    END process two_selector;

END archselector_2;


library ieee;
use ieee.std_logic_1164.all;

ENTITY selector_4 IS PORT(mclk, Nreset, enable, 
        input0, input1, input2, input3: in std_logic;
        selector :std_logic_vector(1 downto 0);
		sel_out : out std_logic);
END selector_4;

ARCHITECTURE archselector_4 OF selector_4 is

BEGIN
    four_selector: process (mclk, Nreset)
    BEGIN
    if (Nreset='0') then
        sel_out  <= '0';
	elsif(rising_edge (mclk)) then
		if(enable='1') then
		    case selector is
		
		        when "11" =>
		            sel_out <= input3;
		
		        when "10" =>
		            sel_out <= input2;
		
		        when "01" =>
		            sel_out <= input1;
		
		        when "00" =>
		            sel_out <= input0;
		
				when others =>
					sel_out <= '0';
		    end case;
		else
			sel_out <= '0';
		end if;
	end if;
    END process four_selector;

END archselector_4;

library ieee;
use ieee.std_logic_1164.all;

ENTITY mux_32 IS
	port (a,b: in std_logic_vector (31 downto 0); 
		y: out std_logic_vector(31 downto 0);
		Nreset, mclk, sel: in std_logic);
END mux_32;

ARCHITECTURE arch_mux_32 OF mux_32 is

BEGIN
    stroke_mux: process (a, b, Nreset, mclk, sel)
    BEGIN
    if (Nreset='0') then
        y  <= (others => '0');
	elsif(rising_edge (mclk)) then
		if (sel = '0') then y <= a;
		else y <= b;
		end if;
	end if;
    END process stroke_mux;

END arch_mux_32;

