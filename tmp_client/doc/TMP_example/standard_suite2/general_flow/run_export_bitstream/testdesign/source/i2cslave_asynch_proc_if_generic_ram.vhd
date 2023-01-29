----------------------------------------------------------------------------------------------------
-- Title      : Generic RAM Module
-- Project    : I2CSlave_Async_Proc_IF
----------------------------------------------------------------------------------------------------
-- File       : i2cslave_asynch_proc_if_generic_ram.vhd
-- Author     : GRJ
-- Company    : SiliconBlue Tech.
-- Last update: 2009/12/07
----------------------------------------------------------------------------------------------------
-- Description: This is the generic RAM Module
--              When i_wr_en is HIGH, it gets the data from i_wr_data and stores it in RAM_array.
--              When i_rd_en is HIGH, from the array RAM_array, it stores the data into o_rd_data
----------------------------------------------------------------------------------------------------
-- Revisions  :
-- Date          Version     Author     Description
-- 07Dec2009      1.0         GRJ        Created
----------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- Disclaimer :
-- SILICONBLUE TECHNOLOGIES PROVIDES THIS APPLICATION NOTE TO YOU "AS-IS". ALL WARRANTIES,
-- REPRESENTATIONS, OR GUARANTEES OF ANY KIND (WHETHER EXPRESS, IMPLIED, OR STATUTORY) INCLUDING,
-- WITHOUT LIMITATION, WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR A PARTICULAR
-- PURPOSE , ARE SPECIFICALLY DISCLAIMED. LIMITATION OF LIABILITY: SUBJECT TO APPLICABLE LAWS:
-- (1)IN NO EVENT WILL SILICONBLUE TECHNOLOGIES OR ITS LICENSORS BE LIABLE FOR ANY LOSS OF DATA,
-- LOST PROFITS, COST OF PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES, OR FOR ANY SPECIAL,
-- INCIDENTAL,CONSEQUENTIAL OR INDIRECT DAMAGES ARISING FROM THE USE OR IMPLEMENTATION OF THE
-- APPLICATION NOTE, IN WHOLE OR IN PART, HOWEVER CAUSED AND UNDER ANY THEORY OF LIABILITY.
--
-- (2)THIS LIMITATION WILL APPLY EVEN IF SILICONBLUE TECHNOLOGIES HAS BEEN ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGES.
--
-- (3) THIS LIMITATION SHALL APPLY NOTWITHSTANDING THE FAILURE OF THE ESSENTIAL PURPOSE OF ANY
-- LIMITED  REMEDIES HEREIN.
-------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.i2cslave_asynch_proc_if_package.all;


entity i2cslave_asynch_proc_if_generic_ram is
    port (
        i_wr_clk  : in  std_logic;
        i_rd_clk  : in  std_logic;
        i_rd_addr : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        i_wr_addr : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        i_wr_data : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        i_wr_en   : in  std_logic;
        i_rd_en   : in  std_logic;
        o_rd_data : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );

end i2cslave_asynch_proc_if_generic_ram;

architecture rtl of i2cslave_asynch_proc_if_generic_ram is

    type ram_type is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal RAM_array : ram_type                                := (others => (others => '0'));
    signal rd_data_i : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

begin  -- rtl
    ------------------------------------------------------------------------------------------------
    -- Write port definition
    ------------------------------------------------------------------------------------------------
    wr_data_proc : process (i_wr_clk)
    begin  -- process wr_data_proc
        if i_wr_clk'event and i_wr_clk = '1' then  -- rising clock edge
            if i_wr_en = '1' then
                RAM_array(CONV_integer(i_wr_addr)) <= i_wr_data;
            end if;
        end if;
    end process wr_data_proc;

    ------------------------------------------------------------------------------------------------
    -- read port definition
    ------------------------------------------------------------------------------------------------
    --  o_rd_data <= RAM_array(CONV_integer(i_rd_addr));

    rd_data_proc : process (i_rd_clk)
    begin  -- process rd_data_proc
        if i_rd_clk'event and i_rd_clk = '1' then  -- rising clock edge
            if(i_rd_en = '1')then
                o_rd_data <= RAM_array(CONV_integer(i_rd_addr));
            end if;
        end if;
    end process rd_data_proc;
----------------------------------------------------------------------------------------------------
end rtl;

