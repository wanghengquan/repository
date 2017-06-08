--
--******************************************************************************
--
--  Copyright (c) Affarii Limited, 2007-2008. All rights reserved.
--
--
-- Digital Pre-Distortion Module
--
-- ******************************************************************************/
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.shr_pack.all;
use work.shr_utils_pack.all;
use work.shr_fileio_pack.all;

entity lte_datapath_fpga is
  port (
    i_clk : in std_logic;
    i_clk_reg : in std_logic;
    i_reset_n : in std_logic;
    i_reset_reg_n : in std_logic;
    i_tx_strobe_div2 : in std_logic;
    i_tx_strobe_div4 : in std_logic;
    i_tx_strobe_div8 : in std_logic;
    i_tx_strobe_div16 : in std_logic;
    i_tx_strobe_div32 : in std_logic;
    -- filter input data
    i_datain_0_re : in signed(15 downto 0);
    i_datain_0_im : in signed(15 downto 0);
    i_datain_1_re : in signed(15 downto 0);
    i_datain_1_im : in signed(15 downto 0);
    i_datain_2_re : in signed(15 downto 0);
    i_datain_2_im : in signed(15 downto 0);
    i_datain_3_re : in signed(15 downto 0);
    i_datain_3_im : in signed(15 downto 0);
    -- filter output data
    o_dataout_re : out signed(15 downto 0);
    o_dataout_im : out signed(15 downto 0);
    -- status
    o_cfr_peak_not_cancelled : out std_logic_vector(3 downto 0);
    -- control
    i_cfr_filter_enable : in std_logic;
    i_cfr_reset_status : in std_logic;
    i_dpd_filter_enable : in std_logic;
    -- cpu interface
    i_sel : in std_logic;
    i_wren : in std_logic;
    i_addr : in std_logic_vector(9 downto 0);
    i_wrdata : in std_logic_vector(15 downto 0);
    o_rddata : out std_logic_vector(15 downto 0);
    o_done : out std_logic;
    -- Temporary outputs for additional dummy DUC4 block
    o_duc_dataout_re : out signed(17 downto 0);
    o_duc_dataout_im : out signed(17 downto 0);
    o_duc_rddata : out std_logic_vector(15 downto 0);
    o_duc_done : out std_logic);
end entity lte_datapath_fpga;

architecture rtl of lte_datapath_fpga is
  constant c_complex_tfilter  : integer :=   1;   -- 0 => real, 1 => complex Null Filters
  constant c_cfr_cmult_type   : integer :=   3;   -- Number of mults in cmult architecture (2 or 3)
  constant c_tfilter_length_0 : integer := 256;   -- Length of Null Filters in CFR stage 0
  constant c_tfilter_length_1 : integer := 256;   -- Length of Null Filters in CFR stage 1
  constant c_tfilter_length_2 : integer := 256;   -- Length of Null Filters in CFR stage 2
  constant c_tfilter_length_3 : integer := 256;   -- Length of Null Filters in CFR stage 3
  constant c_size_tfilter_0   : integer :=  20;   -- Number of Null Filters in CFR stage 0
  constant c_size_tfilter_1   : integer :=  10;   -- Number of Null Filters in CFR stage 1
  constant c_size_tfilter_2   : integer :=   7;   -- Number of Null Filters in CFR stage 2
  constant c_size_tfilter_3   : integer :=   3;   -- Number of Null Filters in CFR stage 3
  constant c_num_equ_coeffs   : natural :=   9;   -- Number of Equaliser Coefficients
  
  signal tx_strobe_div2_pipe : std_logic_vector(7 downto 0);
  signal tx_strobe_div4_pipe : std_logic_vector(7 downto 0);
  signal tx_strobe_div8_pipe : std_logic_vector(7 downto 0);
  signal tx_strobe_div16_pipe : std_logic_vector(7 downto 0);
  signal tx_strobe_div32_pipe : std_logic_vector(7 downto 0);
  attribute syn_maxfan : integer;
  attribute syn_maxfan of tx_strobe_div2_pipe : signal is 50;
  attribute syn_maxfan of tx_strobe_div4_pipe : signal is 50;
  attribute syn_maxfan of tx_strobe_div8_pipe : signal is 50;
  attribute syn_maxfan of tx_strobe_div16_pipe : signal is 50;
  attribute syn_maxfan of tx_strobe_div32_pipe : signal is 50;
  attribute syn_keep : boolean;
  attribute syn_keep of tx_strobe_div2_pipe : signal is true;
  attribute syn_keep of tx_strobe_div4_pipe : signal is true;
  attribute syn_keep of tx_strobe_div8_pipe : signal is true;
  attribute syn_keep of tx_strobe_div16_pipe : signal is true;
  attribute syn_keep of tx_strobe_div32_pipe : signal is true;
  
  signal datain_0_re : signed(15 downto 0);
  signal datain_0_im : signed(15 downto 0);
  signal datain_1_re : signed(15 downto 0);
  signal datain_1_im : signed(15 downto 0);
  signal datain_2_re : signed(15 downto 0);
  signal datain_2_im : signed(15 downto 0);
  signal datain_3_re : signed(15 downto 0);
  signal datain_3_im : signed(15 downto 0);
  signal cfr_filter_enable : std_logic;
  signal cfr_reset_status : std_logic;
  signal dpd_filter_enable : std_logic;  
  signal rt_datain_0_re : signed(15 downto 0);
  signal rt_datain_0_im : signed(15 downto 0);
  signal rt_datain_1_re : signed(15 downto 0);
  signal rt_datain_1_im : signed(15 downto 0);
  signal rt_datain_2_re : signed(15 downto 0);
  signal rt_datain_2_im : signed(15 downto 0);
  signal rt_datain_3_re : signed(15 downto 0);
  signal rt_datain_3_im : signed(15 downto 0);
  signal rt_cfr_filter_enable : std_logic;
  signal rt_cfr_reset_status : std_logic;
  signal rt_dpd_filter_enable : std_logic;  
  signal rt2_datain_0_re : signed(15 downto 0);
  signal rt2_datain_0_im : signed(15 downto 0);
  signal rt2_datain_1_re : signed(15 downto 0);
  signal rt2_datain_1_im : signed(15 downto 0);
  signal rt2_datain_2_re : signed(15 downto 0);
  signal rt2_datain_2_im : signed(15 downto 0);
  signal rt2_datain_3_re : signed(15 downto 0);
  signal rt2_datain_3_im : signed(15 downto 0);
  signal rt2_cfr_filter_enable : std_logic;
  signal rt2_cfr_reset_status : std_logic;
  signal rt2_dpd_filter_enable : std_logic;  
  signal rt3_datain_0_re : signed(15 downto 0);
  signal rt3_datain_0_im : signed(15 downto 0);
  signal rt3_datain_1_re : signed(15 downto 0);
  signal rt3_datain_1_im : signed(15 downto 0);
  signal rt3_datain_2_re : signed(15 downto 0);
  signal rt3_datain_2_im : signed(15 downto 0);
  signal rt3_datain_3_re : signed(15 downto 0);
  signal rt3_datain_3_im : signed(15 downto 0);
  signal rt3_cfr_filter_enable : std_logic;
  signal rt3_cfr_reset_status : std_logic;
  signal rt3_dpd_filter_enable : std_logic;
  
  signal dataout_re : signed(15 downto 0);
  signal dataout_im : signed(15 downto 0);
  signal cfr_peak_not_cancelled : std_logic_vector(3 downto 0);
  signal duc_dataout_re : signed(17 downto 0);
  signal duc_dataout_im : signed(17 downto 0);  
  signal rt_dataout_re : signed(15 downto 0);
  signal rt_dataout_im : signed(15 downto 0);
  signal rt_cfr_peak_not_cancelled : std_logic_vector(3 downto 0);
  signal rt_duc_dataout_re : signed(17 downto 0);
  signal rt_duc_dataout_im : signed(17 downto 0);  
  signal rt2_dataout_re : signed(15 downto 0);
  signal rt2_dataout_im : signed(15 downto 0);
  signal rt2_cfr_peak_not_cancelled : std_logic_vector(3 downto 0);
  signal rt2_duc_dataout_re : signed(17 downto 0);
  signal rt2_duc_dataout_im : signed(17 downto 0);  
  signal rt3_dataout_re : signed(15 downto 0);
  signal rt3_dataout_im : signed(15 downto 0);
  signal rt3_cfr_peak_not_cancelled : std_logic_vector(3 downto 0);
  signal rt3_duc_dataout_re : signed(17 downto 0);
  signal rt3_duc_dataout_im : signed(17 downto 0);
  
  signal sel : std_logic;
  signal wren : std_logic;
  signal addr : std_logic_vector(9 downto 0);
  signal wrdata : std_logic_vector(15 downto 0);  
  signal rt_sel : std_logic;
  signal rt_wren : std_logic;
  signal rt_addr : std_logic_vector(9 downto 0);
  signal rt_wrdata : std_logic_vector(15 downto 0);  
  signal rt2_sel : std_logic;
  signal rt2_wren : std_logic;
  signal rt2_addr : std_logic_vector(9 downto 0);
  signal rt2_wrdata : std_logic_vector(15 downto 0);  
  signal rt3_sel : std_logic;
  signal rt3_wren : std_logic;
  signal rt3_addr : std_logic_vector(9 downto 0);
  signal rt3_wrdata : std_logic_vector(15 downto 0);
  
  signal rddata : std_logic_vector(15 downto 0);
  signal done : std_logic;
  signal duc_rddata : std_logic_vector(15 downto 0);
  signal duc_done : std_logic;  
  signal rt_rddata : std_logic_vector(15 downto 0);
  signal rt_done : std_logic;
  signal rt_duc_rddata : std_logic_vector(15 downto 0);
  signal rt_duc_done : std_logic;  
  signal rt2_rddata : std_logic_vector(15 downto 0);
  signal rt2_done : std_logic;
  signal rt2_duc_rddata : std_logic_vector(15 downto 0);
  signal rt2_duc_done : std_logic;  
  signal rt3_rddata : std_logic_vector(15 downto 0);
  signal rt3_done : std_logic;
  signal rt3_duc_rddata : std_logic_vector(15 downto 0);
  signal rt3_duc_done : std_logic;

  attribute syn_srlstyle : string;
  attribute syn_srlstyle of rt_datain_0_re : signal is "registers";
  attribute syn_srlstyle of rt_datain_0_im : signal is "registers";
  attribute syn_srlstyle of rt_datain_1_re : signal is "registers";
  attribute syn_srlstyle of rt_datain_1_im : signal is "registers";
  attribute syn_srlstyle of rt_datain_2_re : signal is "registers";
  attribute syn_srlstyle of rt_datain_2_im : signal is "registers";
  attribute syn_srlstyle of rt_datain_3_re : signal is "registers";
  attribute syn_srlstyle of rt_datain_3_im : signal is "registers";
  attribute syn_srlstyle of rt_cfr_filter_enable : signal is "registers";
  attribute syn_srlstyle of rt_cfr_reset_status : signal is "registers";
  attribute syn_srlstyle of rt_dpd_filter_enable : signal is "registers";
  attribute syn_srlstyle of rt2_datain_0_re : signal is "registers";
  attribute syn_srlstyle of rt2_datain_0_im : signal is "registers";
  attribute syn_srlstyle of rt2_datain_1_re : signal is "registers";
  attribute syn_srlstyle of rt2_datain_1_im : signal is "registers";
  attribute syn_srlstyle of rt2_datain_2_re : signal is "registers";
  attribute syn_srlstyle of rt2_datain_2_im : signal is "registers";
  attribute syn_srlstyle of rt2_datain_3_re : signal is "registers";
  attribute syn_srlstyle of rt2_datain_3_im : signal is "registers";
  attribute syn_srlstyle of rt2_cfr_filter_enable : signal is "registers";
  attribute syn_srlstyle of rt2_cfr_reset_status : signal is "registers";
  attribute syn_srlstyle of rt2_dpd_filter_enable : signal is "registers";
  attribute syn_srlstyle of rt3_datain_0_re : signal is "registers";
  attribute syn_srlstyle of rt3_datain_0_im : signal is "registers";
  attribute syn_srlstyle of rt3_datain_1_re : signal is "registers";
  attribute syn_srlstyle of rt3_datain_1_im : signal is "registers";
  attribute syn_srlstyle of rt3_datain_2_re : signal is "registers";
  attribute syn_srlstyle of rt3_datain_2_im : signal is "registers";
  attribute syn_srlstyle of rt3_datain_3_re : signal is "registers";
  attribute syn_srlstyle of rt3_datain_3_im : signal is "registers";
  attribute syn_srlstyle of rt3_cfr_filter_enable : signal is "registers";
  attribute syn_srlstyle of rt3_cfr_reset_status : signal is "registers";
  attribute syn_srlstyle of rt3_dpd_filter_enable : signal is "registers";
  attribute syn_srlstyle of rt_dataout_re : signal is "registers";
  attribute syn_srlstyle of rt_dataout_im : signal is "registers";
  attribute syn_srlstyle of rt_cfr_peak_not_cancelled : signal is "registers";
  attribute syn_srlstyle of rt_duc_dataout_re : signal is "registers";
  attribute syn_srlstyle of rt_duc_dataout_im : signal is "registers";
  attribute syn_srlstyle of rt2_dataout_re : signal is "registers";
  attribute syn_srlstyle of rt2_dataout_im : signal is "registers";
  attribute syn_srlstyle of rt2_cfr_peak_not_cancelled : signal is "registers";
  attribute syn_srlstyle of rt2_duc_dataout_re : signal is "registers";
  attribute syn_srlstyle of rt2_duc_dataout_im : signal is "registers";
  attribute syn_srlstyle of rt3_dataout_re : signal is "registers";
  attribute syn_srlstyle of rt3_dataout_im : signal is "registers";
  attribute syn_srlstyle of rt3_cfr_peak_not_cancelled : signal is "registers";
  attribute syn_srlstyle of rt3_duc_dataout_re : signal is "registers";
  attribute syn_srlstyle of rt3_duc_dataout_im : signal is "registers";
  attribute syn_srlstyle of rt_sel : signal is "registers";
  attribute syn_srlstyle of rt_wren : signal is "registers";
  attribute syn_srlstyle of rt_addr : signal is "registers";
  attribute syn_srlstyle of rt_wrdata : signal is "registers";
  attribute syn_srlstyle of rt2_sel : signal is "registers";
  attribute syn_srlstyle of rt2_wren : signal is "registers";
  attribute syn_srlstyle of rt2_addr : signal is "registers";
  attribute syn_srlstyle of rt2_wrdata : signal is "registers";
  attribute syn_srlstyle of rt3_sel : signal is "registers";
  attribute syn_srlstyle of rt3_wren : signal is "registers";
  attribute syn_srlstyle of rt3_addr : signal is "registers";
  attribute syn_srlstyle of rt3_wrdata : signal is "registers";
  attribute syn_srlstyle of rt_rddata : signal is "registers";
  attribute syn_srlstyle of rt_done : signal is "registers";
  attribute syn_srlstyle of rt_duc_rddata : signal is "registers";
  attribute syn_srlstyle of rt_duc_done : signal is "registers";
  attribute syn_srlstyle of rt2_rddata : signal is "registers";
  attribute syn_srlstyle of rt2_done : signal is "registers";
  attribute syn_srlstyle of rt2_duc_rddata : signal is "registers";
  attribute syn_srlstyle of rt2_duc_done : signal is "registers";
  attribute syn_srlstyle of rt3_rddata : signal is "registers";
  attribute syn_srlstyle of rt3_done : signal is "registers";
  attribute syn_srlstyle of rt3_duc_rddata : signal is "registers";
  attribute syn_srlstyle of rt3_duc_done : signal is "registers";
  attribute syn_srlstyle of tx_strobe_div2_pipe : signal is "registers";
  attribute syn_srlstyle of tx_strobe_div4_pipe : signal is "registers";
  attribute syn_srlstyle of tx_strobe_div8_pipe : signal is "registers";
  attribute syn_srlstyle of tx_strobe_div16_pipe : signal is "registers";
  attribute syn_srlstyle of tx_strobe_div32_pipe : signal is "registers";
  
  component lte_datapath is
    generic (
      g_complex_tfilter  : integer;   -- 0 => real, 1 => complex Null Filters
      g_cfr_cmult_type   : integer;   -- Number of mults in cmult architecture (2 or 3)
      g_tfilter_length_0 : integer;   -- Length of Null Filters in CFR stage 0
      g_tfilter_length_1 : integer;   -- Length of Null Filters in CFR stage 1
      g_tfilter_length_2 : integer;   -- Length of Null Filters in CFR stage 2
      g_tfilter_length_3 : integer;   -- Length of Null Filters in CFR stage 3
      g_size_tfilter_0   : integer;   -- Number of Null Filters in CFR stage 0
      g_size_tfilter_1   : integer;   -- Number of Null Filters in CFR stage 1
      g_size_tfilter_2   : integer;   -- Number of Null Filters in CFR stage 2
      g_size_tfilter_3   : integer;   -- Number of Null Filters in CFR stage 3
      g_num_equ_coeffs   : natural);  -- Number of Equaliser Coefficients
    port (
      i_clk : in std_logic;
      i_clk_reg : in std_logic;
      i_reset_n : in std_logic;
      i_reset_reg_n : in std_logic;
      i_tx_strobe_div2 : in std_logic;
      i_tx_strobe_div4 : in std_logic;
      i_tx_strobe_div8 : in std_logic;
      i_tx_strobe_div16 : in std_logic;
      i_tx_strobe_div32 : in std_logic;
      -- filter input data
      i_datain_0_re : in signed(15 downto 0);
      i_datain_0_im : in signed(15 downto 0);
      i_datain_1_re : in signed(15 downto 0);
      i_datain_1_im : in signed(15 downto 0);
      i_datain_2_re : in signed(15 downto 0);
      i_datain_2_im : in signed(15 downto 0);
      i_datain_3_re : in signed(15 downto 0);
      i_datain_3_im : in signed(15 downto 0);
      -- filter output data
      o_dataout_re : out signed(15 downto 0);
      o_dataout_im : out signed(15 downto 0);
      -- status
      o_cfr_peak_not_cancelled : out std_logic_vector(3 downto 0);
      -- control
      i_cfr_filter_enable : in std_logic;
      i_cfr_reset_status : in std_logic;
      i_dpd_filter_enable : in std_logic;
      -- cpu interface
      i_sel : in std_logic;
      i_wren : in std_logic;
      i_addr : in std_logic_vector(9 downto 0);
      i_wrdata : in std_logic_vector(15 downto 0);
      o_rddata : out std_logic_vector(15 downto 0);
      o_done : out std_logic);
  end component lte_datapath;

begin

  lte_datapath_1 : lte_datapath
    generic map (
      g_complex_tfilter  => c_complex_tfilter,
      g_cfr_cmult_type   => c_cfr_cmult_type,
      g_tfilter_length_0 => c_tfilter_length_0,
      g_tfilter_length_1 => c_tfilter_length_1,
      g_tfilter_length_2 => c_tfilter_length_2,
      g_tfilter_length_3 => c_tfilter_length_3,
      g_size_tfilter_0   => c_size_tfilter_0,
      g_size_tfilter_1   => c_size_tfilter_1,
      g_size_tfilter_2   => c_size_tfilter_2,
      g_size_tfilter_3   => c_size_tfilter_3,
      g_num_equ_coeffs   => c_num_equ_coeffs)
    port map (
      i_clk => i_clk,
      i_clk_reg => i_clk_reg,
      i_reset_n => i_reset_n,
      i_reset_reg_n => i_reset_reg_n,
      i_tx_strobe_div2 => tx_strobe_div2_pipe(7),
      i_tx_strobe_div4 => tx_strobe_div4_pipe(7),
      i_tx_strobe_div8 => tx_strobe_div8_pipe(7),
      i_tx_strobe_div16 => tx_strobe_div16_pipe(7),
      i_tx_strobe_div32 => tx_strobe_div32_pipe(7),
      -- filter input data
      i_datain_0_re => rt3_datain_0_re,
      i_datain_0_im => rt3_datain_0_im,
      i_datain_1_re => rt3_datain_1_re,
      i_datain_1_im => rt3_datain_1_im,
      i_datain_2_re => rt3_datain_2_re,
      i_datain_2_im => rt3_datain_2_im,
      i_datain_3_re => rt3_datain_3_re,
      i_datain_3_im => rt3_datain_3_im,
      -- filter output data
      o_dataout_re => dataout_re,
      o_dataout_im => dataout_im,
      -- status
      o_cfr_peak_not_cancelled => cfr_peak_not_cancelled,
      -- control
      i_cfr_filter_enable => rt3_cfr_filter_enable,
      i_cfr_reset_status => rt3_cfr_reset_status,
      i_dpd_filter_enable => rt3_dpd_filter_enable,
      -- cpu interface
      i_sel => rt3_sel,
      i_wren => rt3_wren,
      i_addr => rt3_addr,
      i_wrdata => rt3_wrdata,
      o_rddata => rddata,
      o_done => done);

  -- Instantate a second DUC4 Datapath block to model downconversion gates
  duc4_datapath_wrap_1 : entity work.duc4_datapath_wrap
    port map (
      i_clk => i_clk,
      i_clk_reg => i_clk_reg,
      i_reset_n => i_reset_n,
      i_reset_reg_n => i_reset_reg_n,
      i_tx_strobe_div2 => tx_strobe_div2_pipe(7),
      i_tx_strobe_div4 => tx_strobe_div4_pipe(7),
      i_tx_strobe_div8 => tx_strobe_div8_pipe(7),
      i_tx_strobe_div16 => tx_strobe_div16_pipe(7),
      i_tx_strobe_div32 => tx_strobe_div32_pipe(7),
      -- filter input data
      i_datain_0_re => rt3_datain_0_re,
      i_datain_0_im => rt3_datain_0_im,
      i_datain_1_re => rt3_datain_1_re,
      i_datain_1_im => rt3_datain_1_im,
      i_datain_2_re => rt3_datain_2_re,
      i_datain_2_im => rt3_datain_2_im,
      i_datain_3_re => rt3_datain_3_re,
      i_datain_3_im => rt3_datain_3_im,
      -- filter output data
      o_dataout_re => duc_dataout_re,
      o_dataout_im => duc_dataout_im,
      -- cpu interface
      i_sel => rt3_sel,
      i_wren => rt3_wren,
      i_addr => rt3_addr,
      i_wrdata => rt3_wrdata,
      o_rddata => duc_rddata,
      o_done => duc_done);

  
 
  p_retime_io : process (i_clk)
  begin
    if i_clk'event and i_clk = '1' then
      -- inputs
      tx_strobe_div2_pipe <= tx_strobe_div2_pipe(tx_strobe_div2_pipe'high-1 downto 0) & i_tx_strobe_div2;
      tx_strobe_div4_pipe <= tx_strobe_div4_pipe(tx_strobe_div4_pipe'high-1 downto 0) & i_tx_strobe_div4;
      tx_strobe_div8_pipe <= tx_strobe_div8_pipe(tx_strobe_div8_pipe'high-1 downto 0) & i_tx_strobe_div8;
      tx_strobe_div16_pipe <= tx_strobe_div16_pipe(tx_strobe_div16_pipe'high-1 downto 0) & i_tx_strobe_div16;
      tx_strobe_div32_pipe <= tx_strobe_div32_pipe(tx_strobe_div32_pipe'high-1 downto 0) & i_tx_strobe_div32;
      
      datain_0_re <= i_datain_0_re;
      datain_0_im <= i_datain_0_im;
      datain_1_re <= i_datain_1_re;
      datain_1_im <= i_datain_1_im;
      datain_2_re <= i_datain_2_re;
      datain_2_im <= i_datain_2_im;
      datain_3_re <= i_datain_3_re;
      datain_3_im <= i_datain_3_im;
      cfr_filter_enable <= i_cfr_filter_enable;
      cfr_reset_status <= i_cfr_reset_status;
      dpd_filter_enable <= i_dpd_filter_enable;
      rt_datain_0_re <= datain_0_re;
      rt_datain_0_im <= datain_0_im;
      rt_datain_1_re <= datain_1_re;
      rt_datain_1_im <= datain_1_im;
      rt_datain_2_re <= datain_2_re;
      rt_datain_2_im <= datain_2_im;
      rt_datain_3_re <= datain_3_re;
      rt_datain_3_im <= datain_3_im;
      rt_cfr_filter_enable <= cfr_filter_enable;
      rt_cfr_reset_status <= cfr_reset_status;
      rt_dpd_filter_enable <= dpd_filter_enable;
      rt2_datain_0_re <= rt_datain_0_re;
      rt2_datain_0_im <= rt_datain_0_im;
      rt2_datain_1_re <= rt_datain_1_re;
      rt2_datain_1_im <= rt_datain_1_im;
      rt2_datain_2_re <= rt_datain_2_re;
      rt2_datain_2_im <= rt_datain_2_im;
      rt2_datain_3_re <= rt_datain_3_re;
      rt2_datain_3_im <= rt_datain_3_im;
      rt2_cfr_filter_enable <= rt_cfr_filter_enable;
      rt2_cfr_reset_status <= rt_cfr_reset_status;
      rt2_dpd_filter_enable <= rt_dpd_filter_enable;
      rt3_datain_0_re <= rt2_datain_0_re;
      rt3_datain_0_im <= rt2_datain_0_im;
      rt3_datain_1_re <= rt2_datain_1_re;
      rt3_datain_1_im <= rt2_datain_1_im;
      rt3_datain_2_re <= rt2_datain_2_re;
      rt3_datain_2_im <= rt2_datain_2_im;
      rt3_datain_3_re <= rt2_datain_3_re;
      rt3_datain_3_im <= rt2_datain_3_im;
      rt3_cfr_filter_enable <= rt2_cfr_filter_enable;
      rt3_cfr_reset_status <= rt2_cfr_reset_status;
      rt3_dpd_filter_enable <= rt2_dpd_filter_enable;

      -- outputs
      rt_dataout_re <= dataout_re;
      rt_dataout_im <= dataout_im;
      rt_cfr_peak_not_cancelled <= cfr_peak_not_cancelled;
      rt_duc_dataout_re <= duc_dataout_re;
      rt_duc_dataout_im <= duc_dataout_im;      
      rt2_dataout_re <= rt_dataout_re;
      rt2_dataout_im <= rt_dataout_im;
      rt2_cfr_peak_not_cancelled <= rt_cfr_peak_not_cancelled;
      rt2_duc_dataout_re <= rt_duc_dataout_re;
      rt2_duc_dataout_im <= rt_duc_dataout_im;
      rt3_dataout_re <= rt2_dataout_re;
      rt3_dataout_im <= rt2_dataout_im;
      rt3_cfr_peak_not_cancelled <= rt2_cfr_peak_not_cancelled;
      rt3_duc_dataout_re <= rt2_duc_dataout_re;
      rt3_duc_dataout_im <= rt2_duc_dataout_im;      
      o_dataout_re <= rt3_dataout_re;
      o_dataout_im <= rt3_dataout_im;
      o_cfr_peak_not_cancelled <= rt3_cfr_peak_not_cancelled;
      o_duc_dataout_re <= rt3_duc_dataout_re;
      o_duc_dataout_im <= rt3_duc_dataout_im;
    end if;
  end process p_retime_io;

  p_regs : process (i_clk_reg)
  begin
    if i_clk_reg'event and i_clk_reg = '1' then
      -- inputs
      sel <= i_sel;
      wren <= i_wren;
      addr <= i_addr;
      wrdata <= i_wrdata;
      rt_sel <= sel;
      rt_wren <= wren;
      rt_addr <= addr;
      rt_wrdata <= wrdata;
      rt2_sel <= rt_sel;
      rt2_wren <= rt_wren;
      rt2_addr <= rt_addr;
      rt2_wrdata <= rt_wrdata;
      rt3_sel <= rt2_sel;
      rt3_wren <= rt2_wren;
      rt3_addr <= rt2_addr;
      rt3_wrdata <= rt2_wrdata;

      -- outputs
      rt_rddata <= rddata;
      rt_done <= done;
      rt_duc_rddata <= duc_rddata;
      rt_duc_done <= duc_done;      
      rt2_rddata <= rt_rddata;
      rt2_done <= rt_done;
      rt2_duc_rddata <= rt_duc_rddata;
      rt2_duc_done <= rt_duc_done;      
      rt3_rddata <= rt2_rddata;
      rt3_done <= rt2_done;
      rt3_duc_rddata <= rt2_duc_rddata;
      rt3_duc_done <= rt2_duc_done;      
      o_rddata <= rt3_rddata;
      o_done <= rt3_done;
      o_duc_rddata <= rt3_duc_rddata;
      o_duc_done <= rt3_duc_done;
    end if;
  end process p_regs;
  
end architecture rtl;
