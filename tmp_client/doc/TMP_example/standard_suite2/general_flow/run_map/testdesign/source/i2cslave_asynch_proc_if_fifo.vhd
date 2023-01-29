----------------------------------------------------------------------------------------------------
-- Title      : Generic FIFO module
-- Project    : I2CSlave_Async_Proc_IF
----------------------------------------------------------------------------------------------------
-- File       : i2cslave_asynch_proc_if_fifo.vhd
-- Author     : GRJ
-- Company    : MDN
-- Last update: 07Dec2009
----------------------------------------------------------------------------------------------------
-- Description: This is generic FIFO module with empty full and half full indication.
----------------------------------------------------------------------------------------------------
-- Revisions  :
-- Date          Version     Author     Description
-- 07Dec2009      0.1         GRJ        Created
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


library work;
use work.i2cslave_asynch_proc_if_package.all;

entity i2cslave_asynch_proc_if_fifo is
    port (
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

end i2cslave_asynch_proc_if_fifo;

architecture rtl of i2cslave_asynch_proc_if_fifo is

    component i2cslave_asynch_proc_if_generic_ram
        port (
            i_wr_clk   : in  std_logic;
            i_rd_clk   : in  std_logic;
            i_rd_addr  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            i_wr_addr  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            i_wr_data  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            i_wr_en    : in  std_logic;
            i_rd_en    : in  std_logic;
            o_rd_data  : out std_logic_vector(DATA_WIDTH-1 downto 0));
    end component;

    ------------------------------------------------------------------------------------------------
    -- Internal signals
    ------------------------------------------------------------------------------------------------
    signal wr_addr_i    : std_logic_vector(ADDR_WIDTH downto 0);
    signal wr_addr_reg1 : std_logic_vector(ADDR_WIDTH downto 0);
    signal wr_addr_reg2 : std_logic_vector(ADDR_WIDTH downto 0);
    signal rd_addr_i    : std_logic_vector(ADDR_WIDTH downto 0);
    signal rd_addr_reg1 : std_logic_vector(ADDR_WIDTH downto 0);
    signal rd_addr_reg2 : std_logic_vector(ADDR_WIDTH downto 0);
    signal fifo_full_i  : std_logic;
    signal fifo_empty_i : std_logic;

    signal addr_diff_i  : std_logic_vector(ADDR_WIDTH downto 0);
    signal threshold_i  : std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal fifo_hfull_i : std_logic;


begin  -- rtl
----------------------------------------------------------------------------------------------------
    data_buffer : i2cslave_asynch_proc_if_generic_ram
        port map (
            i_wr_clk                 => i_fifo_wrclk,
            i_rd_clk                 => i_fifo_rdclk,
            i_rd_addr                => rd_addr_i(ADDR_WIDTH - 1 downto 0),
            i_wr_addr                => wr_addr_i(ADDR_WIDTH - 1 downto 0),
            i_wr_data                => i_fifo_wrdata,
            i_wr_en                  => i_fifo_wren,
            i_rd_en                  => i_fifo_rden,
            o_rd_data                => o_fifo_rddata
            );
    ------------------------------------------------------------------------------------------------
    -- Write interface signal generation
    ------------------------------------------------------------------------------------------------
    wr_adr_proc : process (i_fifo_wrclk, i_rst, i_fifo_clr)
    begin  -- process wr_adr_proc
        if i_rst = '1' or i_fifo_clr = '1' then  	      -- asynchronous reset (active high)
            wr_addr_i     <= (others => '0');
        elsif i_fifo_wrclk'event and i_fifo_wrclk = '1' then  -- rising clock edge
            if(i_fifo_wren = '1' and fifo_full_i = '0')then
                wr_addr_i <= wr_addr_i + '1';
            end if;
        end if;
    end process wr_adr_proc;

    rd_adr_sync2wrclk_proc : process (i_fifo_wrclk, i_rst)
    begin  -- process rd_adr_sync2wrclk_proc
        if i_rst = '1' then  			      -- asynchronous reset (active high)
            rd_addr_reg1 <= (others => '0');
            rd_addr_reg2 <= (others => '0');
        elsif i_fifo_wrclk'event and i_fifo_wrclk = '1' then  -- rising clock edge
            rd_addr_reg1 <= rd_addr_i;
            rd_addr_reg2 <= rd_addr_reg1;
        end if;
    end process rd_adr_sync2wrclk_proc;

    o_fifo_full  <= fifo_full_i;
    o_fifo_hfull <= fifo_hfull_i;

    fifo_full_i <= '1' when (wr_addr_i(ADDR_WIDTH - 1 downto 0) = rd_addr_reg2(ADDR_WIDTH - 1 downto 0)
                             and wr_addr_i(ADDR_WIDTH) /= rd_addr_reg2(ADDR_WIDTH)) else
                   '0';

    ------------------------------------------------------------------------------------------------
    -- FIFO half full logic
    ------------------------------------------------------------------------------------------------
    threshold_i(ADDR_WIDTH - 1)          <= '1';
    threshold_i(ADDR_WIDTH - 2 downto 0) <= (others => '0');

    half_full_gen_proc : process (i_fifo_wrclk, i_rst)
    begin  -- process half_full_gen_proc
        if i_rst = '1' then  			      -- asynchronous reset (active high)
            fifo_hfull_i     <= '0';
        elsif i_fifo_wrclk'event and i_fifo_wrclk = '1' then  -- rising clock edge
            if(addr_diff_i(ADDR_WIDTH - 1 downto 0) < threshold_i)then
                fifo_hfull_i <= '1';
            else
                fifo_hfull_i <= '0';
            end if;
        end if;
    end process half_full_gen_proc;

    addr_diff_proc : process (i_fifo_wrclk, i_rst)
    begin  -- process addr_diff_proc
        if i_rst = '1' then  			      -- asynchronous reset (active high)
            addr_diff_i <= (others => '1');
        elsif i_fifo_wrclk'event and i_fifo_wrclk = '1' then  -- rising clock edge
            addr_diff_i <= ( '1' & rd_addr_reg2(ADDR_WIDTH - 1 downto 0)) - ( '0' & wr_addr_i(ADDR_WIDTH - 1 downto 0)) - '1';
        end if;
    end process addr_diff_proc;

    ------------------------------------------------------------------------------------------------
    -- Read interface signal generation
    ------------------------------------------------------------------------------------------------
    rd_addr_proc : process (i_fifo_rdclk, i_rst, i_fifo_clr)
    begin  -- process rd_addr_proc
        if i_rst = '1' or i_fifo_clr = '1' then  	      -- asynchronous reset (active high)
            rd_addr_i     <= (others => '0');
        elsif i_fifo_rdclk'event and i_fifo_rdclk = '1' then  -- rising clock edge
            if(i_fifo_rden = '1' and fifo_empty_i = '0')then
                rd_addr_i <= rd_addr_i + '1';
            end if;
        end if;
    end process rd_addr_proc;

    wr_adr_sync2_rdclk_proc : process (i_fifo_rdclk, i_rst)
    begin  -- process wr_adr_sync2_rdclk_proc
        if i_rst = '1' then  			      -- asynchronous reset (active high)
            wr_addr_reg1 <= (others => '0');
            wr_addr_reg2 <= (others => '0');
        elsif i_fifo_rdclk'event and i_fifo_rdclk = '1' then  -- rising clock edge
            wr_addr_reg1 <= wr_addr_i;
            wr_addr_reg2 <= wr_addr_reg1;
        end if;
    end process wr_adr_sync2_rdclk_proc;

    o_fifo_empty <= fifo_empty_i;

    fifo_empty_i  <= '1' when rd_addr_i = wr_addr_reg2  else
                     '0';

----------------------------------------------------------------------------------------------------
end rtl;

