----------------------------------------------------------------------------------------------------
-- Title      : Asynchronous parallel processor interface package
-- Project    : I2CSlave_Async_Proc_IF
----------------------------------------------------------------------------------------------------
-- File       : i2cslave_asynch_proc_if_package.vhd
-- Author     : GRJ
-- Company    : SiliconBlue Tech.
-- Last update: 2010/02/09
----------------------------------------------------------------------------------------------------
-- Description: This consists of all the RTL constants declaration
----------------------------------------------------------------------------------------------------
-- Revisions  :
-- Date          Version     Author     Description
-- 01Dec2009      1.0         GRJ        Created
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

package i2cslave_asynch_proc_if_package is

    ------------------------------------------------------------------------------------------------
    -- CPU interface constants
    ------------------------------------------------------------------------------------------------
    constant TXFIFO_ADR     : std_logic_vector(3 downto 0) := "0000";
    constant RXFIFO_ADR     : std_logic_vector(3 downto 0) := "0001";
    constant SLAVE_ADRLSB   : std_logic_vector(3 downto 0) := "0010";
    constant SLAVE_ADRMSB   : std_logic_vector(3 downto 0) := "0011";
    constant CONFIG_REGADR  : std_logic_vector(3 downto 0) := "0100";
    constant MODEREG_ADR    : std_logic_vector(3 downto 0) := "0101";
    constant CMD_STAT_ADR   : std_logic_vector(3 downto 0) := "0110";
    constant FIFO_STAT_ADR  : std_logic_vector(3 downto 0) := "0111";
    constant CLK_STR_CNT_REG :std_logic_vector(3 downto 0):=  "1000";
    ------------------------------------------------------------------------------------------------
    -- RX and TX FIFO data width and address width
    ------------------------------------------------------------------------------------------------
    constant ADDR_WIDTH     : natural                      := 8;
    constant DATA_WIDTH     : natural                      := 8;
    ------------------------------------------------------------------------------------------------
    -- High Speed Mode Design constant
    ------------------------------------------------------------------------------------------------
    constant MASTER_CODE    : std_logic_vector(7 downto 0) := "00001010";



    constant CLK_STRETCH_CNT : natural := 500;
   
end i2cslave_asynch_proc_if_package;
----------------------------------------------------------------------------------------------------
package body i2cslave_asynch_proc_if_package is


end i2cslave_asynch_proc_if_package;

