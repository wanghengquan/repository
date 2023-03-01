---------------------------------------------------------------------------------------------------
-- Title      : Testbench package for Asynchronous Parallel Processor Interface
-- Project    : I2CSlave_Async_Proc_IF
----------------------------------------------------------------------------------------------------
-- File       : i2cslave_asynch_proc_if_tb_pkg.vhd
-- Author     : GRJ
-- Company    : SiliconBlue Tech.
-- Last update: 03Jul2010
----------------------------------------------------------------------------------------------------
-- Description: This package consists of procedures required for testing Asynchronous
--              Parallel Processor Interface for the I2C Slave design.       
----------------------------------------------------------------------------------------------------
-- Revisions  :
-- Date          Version     Author     Description
-- 03Dec09        1.0         GRJ        Created
---------------------------------------------------------------------------------------------------
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

package i2cslave_asynch_proc_if_tb_package is

    signal clk_tb       : std_logic                    := '0';
    signal rst_tb       : std_logic                    := '1';
    signal cs_tb        : std_logic                    := '1';
    signal we_tb        : std_logic                    := '1';
    signal oe_tb        : std_logic                    := '0';
    signal intr_tb      : std_logic                    := '1';
    signal addr_tb      : std_logic_vector(3 downto 0) := (others => '0');
    signal data_tb      : std_logic_vector(7 downto 0) := (others => '0');
    signal asynch_cs_tb : std_logic                    := '1';

    shared variable sda_i         : std_logic                     := '1';
    shared variable scl_i         : std_logic                     := '1';
    shared variable asynch_cs_i   : std_logic                     := '0';
    shared variable asynch_data_i : std_logic_vector(7 downto 0)  := (others => 'Z');
    shared variable asynch_oe_i   : std_logic                     := '0';
    shared variable asynch_we_i   : std_logic                     := '0';
    shared variable asynch_addr_i : std_logic_vector (3 downto 0) := (others => '0');

    type buffer_i is array (0 to 255) of std_logic_vector(7 downto 0);
    shared variable rd_wr_buffer_i : buffer_i := (others => (others => '0'));

    constant I2C_CLK_PERIOD : time      := 10 us;  -- 100Khz I2C Clk
    constant CLK_PERIOD     : time      := 32 ns;  -- 31.25MHz System Clk
    constant I2C_HS_CLK_PERIOD : time   := 1000 ns;

    signal i2c_scl_tb : std_logic := '1';
    signal busy_tb    : std_logic := '0';
    signal tb_reset   : std_logic := '0';

    signal i2c_hs_scl_tb : std_logic := '1';
    signal hs_mode       : std_logic := '1';
    signal i2c_fs_scl_tb : std_logic := '1';

    signal clk_str_enable : std_logic := '1';
     signal i2c_sda_tb : std_logic;

    shared variable sda_read_i : std_logic := '1';
    shared variable wr_ack_i   : std_logic := '0';
    shared variable i2cm_wr_i  : std_logic := '0';


    shared variable rd_data_i : std_logic_vector(7 downto 0) := "HHHHHHHH";

    constant slave_address_lsb : std_logic_vector(7 downto 0) := "11110100";
    constant slave_address_msb : std_logic_vector(7 downto 0) := "10011001";

    constant modereg           : std_logic_vector(7 downto 0) := "00000000";
    constant data_write_fifo   : std_logic_vector(7 downto 0) := "10110011";
    constant configuration_reg : std_logic_vector(7 downto 0) := "00010100";


    constant master_wr_data  : std_logic_vector(7 downto 0) := "01010101";
    constant master_wr_data1 : std_logic_vector(7 downto 0) := "01011110";

    type fifo_wr_data is array (1 to 20) of std_logic_vector(7 downto 0);
    signal wr_data : fifo_wr_data := ("10101010", "11110000", "01010101", "11001100", "11100001",
                                      "00010001", "11000011", "11111111", "00000001", "11111011",
                                      "10101010", "11110000", "01010101", "11001100", "11100001",
                                      "00010001", "11000011", "11111111", "00000001", "11111011");

    ------------------------------------------------------------------------------------------------
    -- CPU interface constants
    ------------------------------------------------------------------------------------------------
    constant TXFIFO_ADR    : std_logic_vector(3 downto 0) := "0000";
    constant RXFIFO_ADR    : std_logic_vector(3 downto 0) := "0001";
    constant SLAVE_ADRLSB  : std_logic_vector(3 downto 0) := "0010";
    constant SLAVE_ADRMSB  : std_logic_vector(3 downto 0) := "0011";
    constant CONFIG_REGADR : std_logic_vector(3 downto 0) := "0100";
    constant MODEREG_ADR   : std_logic_vector(3 downto 0) := "0101";
    constant CMD_STAT_ADR  : std_logic_vector(3 downto 0) := "0110";
    constant FIFO_STAT_ADR : std_logic_vector(3 downto 0) := "0111";
    constant CLK_STR_CNT_REG : std_logic_vector(3 downto 0) := "1000";
    ------------------------------------------------------------------------------------------------
    -- RX and TX FIFO data width and address width
    ------------------------------------------------------------------------------------------------
    constant ADDR_WIDTH    : natural                      := 8;
    constant DATA_WIDTH    : natural                      := 8;
    ------------------------------------------------------------------------------------------------



    ------------------------------------------------------------------------------------------------
    -- Procedure Declaration
    ------------------------------------------------------------------------------------------------
    --Parallel Data Write
    procedure data_write (
        asynch_data : std_logic_vector(7 downto 0);
        asynch_addr : std_logic_vector(3 downto 0)
        );
    --Parallel Data Read
    procedure data_read (
        asynch_addr : std_logic_vector(3 downto 0)
        );

    -- Serial Data Write
    procedure i2cm_byte_write (
        data : std_logic_vector(7 downto 0)
        );
    -- Serial Data Read
    procedure i2cm_byte_read;
    procedure i2cm_ack_gen;
    procedure i2cm_nack_gen;
    procedure i2cm_ack_detect;
    procedure i2cm_start_gen;
    procedure i2cm_stop_gen;

    --procedure i2cm_wait_cycle (
       -- count : natural);


    procedure wait_cycle (
        count : natural);

    procedure i2cm_hs_start_gen;
    procedure i2cm_hs_stop_gen;
    procedure i2cm_hs_byte_write (
        data : std_logic_vector(7 downto 0)
        );
    procedure i2cm_hs_byte_read;
    procedure i2cm_hs_ack_gen;
    procedure i2cm_hs_nack_gen;
    procedure i2cm_hs_ack_detect;
    procedure i2cm_nack_detect;


    procedure i2cm_fs_wait_cycle (
        count : natural);
    procedure i2cm_hs_wait_cycle (
        count : natural);


    procedure test_done;

end i2cslave_asynch_proc_if_tb_package;

package body i2cslave_asynch_proc_if_tb_package is

    ---------------------------------------------------------------------------
    -- Data write procedure (Parallel)
    ---------------------------------------------------------------------------
    procedure data_write (
        asynch_data : std_logic_vector(7 downto 0);
        asynch_addr : std_logic_vector(3 downto 0)
        ) is
    begin
        wait until rising_edge(clk_tb);
        asynch_data_i := asynch_data;
        asynch_addr_i := asynch_addr;
        wait for CLK_PERIOD/8;
        asynch_cs_i   := '1';  
        asynch_we_i   := '1';
        asynch_oe_i   := '0';
        wait until rising_edge(clk_tb);
        asynch_data_i := (others => 'Z');
        asynch_cs_i   := '0';
        asynch_we_i   := '0';
        asynch_oe_i   := '0';
    end data_write;

    ---------------------------------------------------------------------------
    -- Data read procedure (Parallel)
    ---------------------------------------------------------------------------
    procedure data_read (
        asynch_addr : std_logic_vector(3 downto 0)
        ) is
    begin
        wait until rising_edge(clk_tb);
        asynch_addr_i := asynch_addr;
        wait for CLK_PERIOD/8;
        asynch_cs_i   := '1';
        asynch_we_i   := '0';
        asynch_oe_i   := '1';
        wait until rising_edge(clk_tb);
        asynch_cs_i   := '0';
        asynch_we_i   := '0';
        asynch_oe_i   := '0';
    end data_read;

    ----------------------------------------------------------------------------------------------------
    -- wait_cycle procedure (Parallel) 
    ----------------------------------------------------------------------------------------------------

    procedure wait_cycle (
        count : natural
        )is
    begin
        for i in 1 to count loop
            wait until rising_edge(clk_tb);
        end loop;  -- i
    end procedure;


    ------------------------------------------------------------------------------------------------
    -- ACK Gen (Serial)
    ------------------------------------------------------------------------------------------------
    procedure i2cm_ack_gen is
    begin  -- ack_gen
        wait until falling_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;
        sda_i     := '0';
        i2cm_wr_i := '1';
        wait until rising_edge(i2c_scl_tb);
        report "*** Master Generated Acknowledge ***" severity warning;
        sda_i     := '1';
        i2cm_wr_i := '0';
    end i2cm_ack_gen;


    ------------------------------------------------------------------------------------------------
    -- ACK Gen High Speed Mode 
    ------------------------------------------------------------------------------------------------
    procedure i2cm_hs_ack_gen is
    begin  -- ack_gen
        wait until falling_edge(i2c_hs_scl_tb);
        wait for I2C_HS_CLK_PERIOD/4;
        sda_i     := '0';
        i2cm_wr_i := '1';
        wait until rising_edge(i2c_hs_scl_tb);
       -- wait for I2C_HS_CLK_PERIOD/4;
        report "*** Master Generated Acknowledge for High Speed Mode ***" severity warning;
        sda_i     := '1';
        i2cm_wr_i := '0';
       -- wait until rising_edge(i2c_hs_scl_tb);
    end i2cm_hs_ack_gen;


    ------------------------------------------------------------------------------------------------
    -- Not ACK Gen 
    ------------------------------------------------------------------------------------------------
    procedure i2cm_nack_gen is
    begin  -- ack_gen
        wait until falling_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;
        sda_i     := '1';
        i2cm_wr_i := '1';
        wait until falling_edge(i2c_scl_tb);
        report "*** Master Generated NAcknowledge ***" severity warning;
        sda_i     := '0';
        i2cm_wr_i := '0';
    end i2cm_nack_gen;


    ------------------------------------------------------------------------------------------------
    -- Not ACK Gen High Speed Mode
    ------------------------------------------------------------------------------------------------
    procedure i2cm_hs_nack_gen is
    begin  -- ack_gen
        wait until falling_edge(i2c_hs_scl_tb);
        wait for I2C_HS_CLK_PERIOD/4;
        sda_i     := '1';
        i2cm_wr_i := '1';
        wait until falling_edge(i2c_hs_scl_tb);
        report "*** Master Generated NAcknowledge for High Speed Mode ***" severity warning;
        sda_i     := '0';
        i2cm_wr_i := '0';
    end i2cm_hs_nack_gen;

    ------------------------------------------------------------------------------------------------
    -- ACK Detect 
    ------------------------------------------------------------------------------------------------
    procedure i2cm_ack_detect is
    begin  -- ack-detect
        wait until rising_edge(i2c_scl_tb);
        i2cm_wr_i    := '0';
        wait for I2C_CLK_PERIOD/4;
        if sda_read_i = '0' then
            wr_ack_i := '1';
            report "*** Slave Acknowledge Successfull ***" severity warning;
        else
            wr_ack_i := '0';
            report "*** Slave Failed to Acknowledge ***" severity error;
        end if;
    end i2cm_ack_detect;


    ------------------------------------------------------------------------------------------------
    -- NACK Detect 
    ------------------------------------------------------------------------------------------------
    procedure i2cm_nack_detect is
    begin  -- ack-detect
        wait until rising_edge(i2c_fs_scl_tb);
        i2cm_wr_i    := '1';
        wait for I2C_CLK_PERIOD/4;
        if sda_read_i = 'H' then
            wr_ack_i := '0';
            report "*** Slave Not Acknowledge Successfull ***" severity warning;
        else
            wr_ack_i := '1';
            report "*** Slave Failed to Not Acknowledge ***" severity error;
        end if;
    end i2cm_nack_detect;


    ------------------------------------------------------------------------------------------------
    -- ACK Detect High Speed Mode 
    ------------------------------------------------------------------------------------------------
    procedure i2cm_hs_ack_detect is
    begin  -- ack-detect
        wait until rising_edge(i2c_hs_scl_tb);
        i2cm_wr_i    := '0';
        wait for I2C_HS_CLK_PERIOD/4;
        if sda_read_i = '0' then
            wr_ack_i := '1';
            report "*** Slave Acknowledge Successfull for High Speed Mode***" severity warning;
        else
            wr_ack_i := '0';
            report "*** Slave Failed to Acknowledge for High Speed Mode***" severity error;
        end if;
    end i2cm_hs_ack_detect;



    ------------------------------------------------------------------------------------------------
    -- Start condition generate
    ------------------------------------------------------------------------------------------------
    procedure i2cm_start_gen is
    begin  -- start_gen
        wait until falling_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;
        sda_i     := '1';
        i2cm_wr_i := '1';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;
        sda_i     := '0';
        i2cm_wr_i := '1';
        report "*** Master generated START ***" severity warning;
        wait for I2C_CLK_PERIOD/8;
    end i2cm_start_gen;


    ------------------------------------------------------------------------------------------------
    -- Start condition generate for High Speed Mode
    ------------------------------------------------------------------------------------------------
    procedure i2cm_hs_start_gen is
    begin  -- start_gen
        wait until falling_edge(i2c_hs_scl_tb);
        wait for I2C_HS_CLK_PERIOD/4;
        sda_i     := '1';
        i2cm_wr_i := '1';
        wait until rising_edge(i2c_hs_scl_tb);
        wait for I2C_HS_CLK_PERIOD/4;
        sda_i     := '0';
        i2cm_wr_i := '1';
        report "*** Master generated START for High Speed Mode ***" severity warning;
        wait for I2C_HS_CLK_PERIOD/8;
    end i2cm_hs_start_gen;

    ------------------------------------------------------------------------------------------------
    -- Stop condition generate
    ------------------------------------------------------------------------------------------------
    procedure i2cm_stop_gen is
    begin  -- stop_gen
        sda_i     := '0';
        i2cm_wr_i := '1';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;
        sda_i     := '1';
        i2cm_wr_i := '1';
        report "*** Master generated STOP ***" severity warning;
        wait until falling_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;
        i2cm_wr_i := '1';
        sda_i     := 'H';
    end i2cm_stop_gen;


    ------------------------------------------------------------------------------------------------
    -- Stop condition generate for High Speed Mode 
    ------------------------------------------------------------------------------------------------
    procedure i2cm_hs_stop_gen is
    begin  -- stop_gen
        sda_i     := '0';
        i2cm_wr_i := '1';
        wait until rising_edge(i2c_hs_scl_tb);
        wait for I2C_HS_CLK_PERIOD/4;
        sda_i     := '1';
        i2cm_wr_i := '1';
        report "*** Master generated STOP for High Speed Mode***" severity warning;
        wait until falling_edge(i2c_hs_scl_tb);
        wait for I2C_HS_CLK_PERIOD/4;
        i2cm_wr_i := '1';
        sda_i     := 'H';
    end i2cm_hs_stop_gen;

    ------------------------------------------------------------------------------------------------
    -- I2CM Byte WRITE (Serial Data Write)
    ------------------------------------------------------------------------------------------------
    procedure i2cm_byte_write (data : std_logic_vector(7 downto 0)) is

        variable tmp : std_logic_vector(7 downto 0);
    begin  -- I2C Byte write
        for i in 7 downto 0 loop
            wait until falling_edge(i2c_scl_tb);
            wait for I2C_CLK_PERIOD/8;
            sda_i     := data(i);
            i2cm_wr_i := '1';
        end loop;  -- i
        wait until falling_edge(i2c_scl_tb);
        sda_i         := 'H';
        report "*** Master Byte Write Successful ***" severity warning;
    end i2cm_byte_write;


    ------------------------------------------------------------------------------------------------
    -- I2CM Byte WRITE High Speed Mode
    ------------------------------------------------------------------------------------------------
    procedure i2cm_hs_byte_write (data : std_logic_vector(7 downto 0)) is

        variable tmp : std_logic_vector(7 downto 0);
    begin  -- I2C Byte write
        for i in 7 downto 0 loop
            wait until falling_edge(i2c_hs_scl_tb);
            wait for I2C_HS_CLK_PERIOD/8;
            sda_i     := data(i);
            i2cm_wr_i := '1';
        end loop;  -- i
        wait until falling_edge(i2c_hs_scl_tb);
        sda_i         := 'H';
        report "*** Master Byte Write Successful for High Speed Mode ***" severity warning;
    end i2cm_hs_byte_write;



    ------------------------------------------------------------------------------------------------
    -- Byte read procedure (Serial Data Read)
    ------------------------------------------------------------------------------------------------
    procedure i2cm_byte_read is
    begin  -- I2C Byte read
        for i in 0 to 7 loop
            wait until rising_edge(i2c_scl_tb);
            wait for I2C_CLK_PERIOD/4;
            rd_data_i(7-i) := sda_read_i;
            i2cm_wr_i      := '0';
        end loop;  -- i
        report "*** Master Byte Read Successful ***" severity warning;
    end i2cm_byte_read;


    ------------------------------------------------------------------------------------------------
    -- Byte read procedure High Speed Mode
    ------------------------------------------------------------------------------------------------
    procedure i2cm_hs_byte_read is
    begin  -- I2C Byte read

        for i in 0 to 7 loop
            wait until rising_edge(i2c_hs_scl_tb);
            wait for I2C_HS_CLK_PERIOD/4;
            rd_data_i(7-i) := sda_read_i;
            i2cm_wr_i      := '0';
        end loop;  -- i
        report "*** Master Byte Read Successful for High Speed Mode ***" severity warning;
    end i2cm_hs_byte_read;

   -------------------------------------------------------------------------------------------------
    -- wait cycle
    -------------------------------------------------------------------------------------------------
    procedure i2cm_fs_wait_cycle (
        count : natural
        )is
    begin
        for i in 1 to count loop
            wait until rising_edge(i2c_fs_scl_tb);
            i2cm_wr_i := '1';
        end loop;  -- i
    end procedure;


    -------------------------------------------------------------------------------------------------
    -- wait cycle for High Speed Mode
    -------------------------------------------------------------------------------------------------
    procedure i2cm_hs_wait_cycle (
        count : natural
        )is
    begin
        for i in 1 to count loop
            wait until rising_edge(i2c_hs_scl_tb);
            i2cm_wr_i := '1';
        end loop;  -- i
    end procedure;

    ----------------------------------------------------------------------------------------------------
    -- test done procedure
    ----------------------------------------------------------------------------------------------------
    procedure test_done is
    begin
        wait_cycle(200);
        assert(false)
            report "*** Simulation Completed ***" severity failure;
    end procedure;


end i2cslave_asynch_proc_if_tb_package;

-------------------------------------------------------------------------------------------------
