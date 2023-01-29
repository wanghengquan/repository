----------------------------------------------------------------------------------------------------
-- Title      : Asynchronous parallel processor interface top module
-- Project    : I2CSlave_Async_Proc_IF
----------------------------------------------------------------------------------------------------
-- File       : i2cslave_asynch_proc_if_top.vhd
-- Author     : GRJ
-- Company    : SiliconBlue Tech.
-- Last update: 02Jul2010
----------------------------------------------------------------------------------------------------
-- Description: This is the top module which contains all the component instantiations 
--              and port mapping of all the signals.
----------------------------------------------------------------------------------------------------
-- Revisions  :
-- Date          Version     Author     Description
-- 05Dec2009      1.0         GRJ        Created
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


library work;
use work.i2cslave_asynch_proc_if_package.all;

entity i2cslave_asynch_proc_if_top is
    port (
        i_clk   : in       std_logic;
        i_oe    : in       std_logic;
        i_we    : in       std_logic;
        i_cs    : in       std_logic;
        i_addr  : in       std_logic_vector(3 downto 0);
        io_scl  : inout    std_logic;
        i_reset : in       std_logic;
        io_sda  : inout    std_logic;
        io_data : inout    std_logic_vector(7 downto 0);
        o_intr  : out      std_logic;
        o_busy  : out      std_logic
        );
end i2cslave_asynch_proc_if_top;


architecture i2cslave_asynch_proc_if_top_arch of i2cslave_asynch_proc_if_top is  -- asynch_proc_top_arch

    signal data_in_i         : std_logic_vector(7 downto 0);
    signal data_out_i        : std_logic_vector(7 downto 0);
    signal data_en_i         : std_logic;
    signal txfifo_clr_i      : std_logic;
    signal rxfifo_clr_i      : std_logic;
    signal txfifo_full_i     : std_logic;
    signal txfifo_empty_i    : std_logic;
    signal txfifo_hfull_i    : std_logic;
    signal txfifo_wren_i     : std_logic;
    signal txfifo_wrclk_i    : std_logic;
    signal txfifo_wrdata_i   : std_logic_vector(7 downto 0);
    signal rxfifo_full_i     : std_logic;
    signal rxfifo_empty_i    : std_logic;
    signal rxfifo_hfull_i    : std_logic;
    signal rxfifo_rden_i     : std_logic;
    signal rxfifo_rdclk_i    : std_logic;
    signal rxfifo_rddata_i   : std_logic_vector(7 downto 0);
    signal i2c_busy_i        : std_logic;
    signal rxfifo_wren_i     : std_logic;
    signal rxfifo_wrdata_i   : std_logic_vector(7 downto 0);
    signal txfifo_rden_i     : std_logic;
    signal txfifo_rddata_i   : std_logic_vector(7 downto 0);
    signal tx_done_i         : std_logic;
    signal rx_done_i         : std_logic;
    signal config_latch_en_i : std_logic;
    signal sda_i0            : std_logic;
    signal sda_i1            : std_logic;


    component i2cslave_asynch_proc_if
        port (
            i_clk             : in  std_logic;
            i_rst             : in  std_logic;
            i_addr            : in  std_logic_vector(3 downto 0);
            i_data            : in  std_logic_vector(7 downto 0);
            o_data            : out std_logic_vector(7 downto 0);
            i_cs              : in  std_logic;
            i_oe              : in  std_logic;
            i_we              : in  std_logic;
            o_intr            : out std_logic;
            o_busy            : out std_logic;
            o_data_en         : out std_logic;
            i_txfifo_full     : in  std_logic;
            i_txfifo_empty    : in  std_logic;
            i_txfifo_hfull    : in  std_logic;
            o_txfifo_wren     : out std_logic;
            o_txfifo_wrclk    : out std_logic;
            o_txfifo_wrdata   : out std_logic_vector(7 downto 0);
            i_rxfifo_full     : in  std_logic;
            i_rxfifo_empty    : in  std_logic;
            i_rxfifo_hfull    : in  std_logic;
            o_rxfifo_rden     : out std_logic;
            o_rxfifo_rdclk    : out std_logic;
            i_rxfifo_rddata   : in  std_logic_vector(7 downto 0);
            i_i2c_busy        : in  std_logic;
            i_tx_done         : in  std_logic;
            i_rx_done         : in  std_logic;
            o_txfifo_clr      : out std_logic;
            o_rxfifo_clr      : out std_logic;
            o_config_latch_en : out std_logic
            );
    end component;

    component i2c_slave
        port(
            i_rst             : in     std_logic;
            io_scl            : inout  std_logic;
            i_clk             : in     std_logic;
            io_sda            : inout  std_logic;
            i_data_in         : in     std_logic_vector(7 downto 0);
            i_config_latch_en : in     std_logic;
            i_txfifo_rddata   : in     std_logic_vector(7 downto 0);
            i_rxfifo_full     : in     std_logic;
            o_rxfifo_wrdata   : out    std_logic_vector(7 downto 0);
            o_tx_done         : out    std_logic;
            o_rx_done         : out    std_logic;
            o_busy            : out    std_logic;
            o_rxfifo_wren     : out    std_logic;
            o_txfifo_rden     : out    std_logic
           -- o_sda             : out    std_logic
            );
    end component;

    component i2cslave_asynch_proc_if_fifo port (
        i_rst         : in  std_logic;
        i_fifo_clr    : in  std_logic;
        i_fifo_wren   : in  std_logic;
        i_fifo_wrclk  : in  std_logic;
        i_fifo_wrdata : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        i_fifo_rden   : in  std_logic;
        i_fifo_rdclk  : in  std_logic;
        o_fifo_rddata : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        o_fifo_full   : out std_logic;
        o_fifo_empty  : out std_logic;
        o_fifo_hfull  : out std_logic
        );
    end component;

begin

    i2cslave_asynch_proc_if_u1 : i2cslave_asynch_proc_if
        port map (
            i_clk             => i_clk,
            i_rst             => i_reset,
            i_addr            => i_addr,
            i_data            => data_in_i,
            o_data            => data_out_i,
            i_cs              => i_cs,
            i_oe              => i_oe,
            i_we              => i_we,
            o_intr            => o_intr,
            o_busy            => o_busy,
            o_data_en         => data_en_i,
            i_txfifo_full     => txfifo_full_i,
            i_txfifo_empty    => txfifo_empty_i,
            i_txfifo_hfull    => txfifo_hfull_i,
            o_txfifo_wren     => txfifo_wren_i,
            o_txfifo_wrclk    => txfifo_wrclk_i,
            o_txfifo_wrdata   => txfifo_wrdata_i,
            i_rxfifo_full     => rxfifo_full_i,
            i_rxfifo_empty    => rxfifo_empty_i,
            i_rxfifo_hfull    => rxfifo_hfull_i,
            o_rxfifo_rden     => rxfifo_rden_i,
            o_rxfifo_rdclk    => rxfifo_rdclk_i,
            i_rxfifo_rddata   => rxfifo_rddata_i,
            i_i2c_busy        => i2c_busy_i,
            i_tx_done         => tx_done_i,
            i_rx_done         => rx_done_i,
            o_txfifo_clr      => txfifo_clr_i,
            o_rxfifo_clr      => rxfifo_clr_i,
            o_config_latch_en => config_latch_en_i
            );

    read_fifo_u2 : i2cslave_asynch_proc_if_fifo
        port map (
            i_rst         => i_reset,
            i_fifo_clr    => rxfifo_clr_i,
            i_fifo_wren   => rxfifo_wren_i,
            i_fifo_wrclk  => io_scl,
            i_fifo_wrdata => rxfifo_wrdata_i,
            i_fifo_rden   => rxfifo_rden_i,
            i_fifo_rdclk  => rxfifo_rdclk_i,
            o_fifo_rddata => rxfifo_rddata_i,
            o_fifo_full   => rxfifo_full_i,
            o_fifo_empty  => rxfifo_empty_i,
            o_fifo_hfull  => rxfifo_hfull_i
            );

    write_fifo_u3 : i2cslave_asynch_proc_if_fifo
        port map (
            i_rst         => i_reset,
            i_fifo_clr    => txfifo_clr_i,
            i_fifo_wren   => txfifo_wren_i,
            i_fifo_wrclk  => txfifo_wrclk_i,
            i_fifo_wrdata => txfifo_wrdata_i,
            i_fifo_rden   => txfifo_rden_i,
            i_fifo_rdclk  => txfifo_wrclk_i,
            o_fifo_rddata => txfifo_rddata_i,
            o_fifo_full   => txfifo_full_i,
            o_fifo_empty  => txfifo_empty_i,
            o_fifo_hfull  => txfifo_hfull_i
            );

    i2c_slave_u4 : i2c_slave
        port map (
            i_rst             => i_reset,
            io_scl            => io_scl,
            i_clk             => i_clk,
            io_sda            => io_sda,--sda_i0,
           -- o_sda             => sda_i1,
            i_data_in         => data_out_i,
            i_config_latch_en => config_latch_en_i,
            i_txfifo_rddata   => txfifo_rddata_i,
            i_rxfifo_full     => rxfifo_full_i,
            o_rxfifo_wrdata   => rxfifo_wrdata_i,
            o_tx_done         => tx_done_i,
            o_rx_done         => rx_done_i,
            o_busy            => i2c_busy_i,
            o_rxfifo_wren     => rxfifo_wren_i,
            o_txfifo_rden     => txfifo_rden_i
            );


    io_data <= data_out_i when data_en_i = '1' else
               (others => 'Z');

    data_in_i <= io_data;

   -- io_sda <= '0' when sda_i1 = '0' else 'Z';
   -- sda_i0 <= io_sda;


end i2cslave_asynch_proc_if_top_arch;
