----------------------------------------------------------------------------------------------------
-- Title      : Configuration register interface
-- Project    : I2CSlave_Async_Proc_IF
----------------------------------------------------------------------------------------------------
-- File       : i2cslave_asynch_proc_if.vhd
-- Author     : GRJ
-- Company    : SiliconBlue Tech.
-- Last update: 2010/02/10
----------------------------------------------------------------------------------------------------
-- Description: This is configuration and status register file. This also  generates interrupt
--              to processor.It takes the input from i_data line and puts it into different registers.
--              When config_latch_en_i is HIGH, it starts the counter and sends Slave Address LSB,
--              Slave Address MSB and Mode registers to I2C Slave module. 
--              This module gets busy,tx_done and rx_done from I2C Slave when the I2C sLave is busy in
--              data transaction,when the transmission of data is complete and when the
--              reception of data is complete respectively.

--              Interrupt Generation Logic
--              Interrupt is generated in following conditions :
--              1) Slave indicates that transmission of data is complete AND transmission interrupt 
--                 enable signal is HIGH which is sent by the processor OR
--              2) Slave indicates that reception of data is complete AND reception interrupt 
--                 enable signal is HIGH which is sent by the processor OR
--              3) TXFIFO is full OR
--              4) TXFIFO is empty OR 
--              5) RXFIFO is full OR
--              6) RXFIFO is empty 

--              FIFO Interface
--              When the Master writes the data, processor reads this through RXFIFO by i_rxfifo_rddata
--              by issuing o_rxfifo_rden and o_rxfifo_rdclk to RXFIFO.
--              When the Master reads the data, processor writes the data to TXFIFO through 
--              o_txfifo_wrdata by issuing o_txfifo_wren and o_txfifo_wrclk to TXFIFO.

--              FIFO Control signal generation
--              Processor interface sends o_txfifo_clr to TXFIFO when there is address of 
--              CONFIG_REG. 
--              It sends o_rxfifo_clr to RXFIFO when there is CONFIG_REG address.
--              This module receives i_rxfifo_full,i_rxfifo_empty and i_rxfifo_hfull from RXFIFO 
--              when the RXFIFO gets full,empty or Half full respectively.
--              Similarly this module receives i_txfifo_full,i_txfifo_empty and i_txfifo_hfull
--              from TXFIFO when the TXFIFO gets full,empty or Half full respectively.
--              

 
--  Register                         ADDRESS                  MODE
--   TXFIFO                            0000                     W
--   RXFIFO                            0001                     R
--   SLAVE_ADRLSB                      0010                     R/W
--   SLAVE_ADRMSB                      0011                     R/W
--   CONFIG_REG                        0100                     R/W
--   MODEREG                           0101                     R/W
--   CMD_STAT                          0110                     R
--   FIFO_STAT                         0111                     R
--   CLK_STR_CNT_REG                   1000                     R/W

----------------------------------------------------------------------------------------------------
-- Revisions :
-- Date Version Author Description
-- 01Dec2009 1.0 GRJ Created
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
-- LIMITED REMEDIES HEREIN.
-------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.i2cslave_asynch_proc_if_package.all;

entity i2cslave_asynch_proc_if is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        -- Processor interface

        i_addr            : in  std_logic_vector(3 downto 0);
        i_data            : in  std_logic_vector(7 downto 0);
        o_data            : out std_logic_vector(7 downto 0);
        i_cs              : in  std_logic;
        i_oe              : in  std_logic;
        i_we              : in  std_logic;
        o_intr            : out std_logic;
        o_busy            : out std_logic;
        o_data_en         : out std_logic;
        -- Tx FIFO write interface
        i_txfifo_full     : in  std_logic;
        i_txfifo_empty    : in  std_logic;
        i_txfifo_hfull    : in  std_logic;
        o_txfifo_wren     : out std_logic;
        o_txfifo_wrclk    : out std_logic;
        o_txfifo_wrdata   : out std_logic_vector(7 downto 0);
        -- Rx FIFO read interface
        i_rxfifo_full     : in  std_logic;
        i_rxfifo_empty    : in  std_logic;
        i_rxfifo_hfull    : in  std_logic;
        o_rxfifo_rden     : out std_logic;
        o_rxfifo_rdclk    : out std_logic;
        i_rxfifo_rddata   : in  std_logic_vector(7 downto 0);
        -- Status signals
        i_i2c_busy        : in  std_logic;
        i_tx_done         : in  std_logic;
        i_rx_done         : in  std_logic;
        -- Configuration signals
        o_txfifo_clr      : out std_logic;
        o_rxfifo_clr      : out std_logic;
        o_config_latch_en : out std_logic
        );

end i2cslave_asynch_proc_if;

architecture rtl of i2cslave_asynch_proc_if is

    ------------------------------------------------------------------------------------------------
    -- Internal signals
    ------------------------------------------------------------------------------------------------

    signal cmd_stat_reg_i     : std_logic_vector(7 downto 0);
    signal fifo_stat_reg_i    : std_logic_vector(7 downto 0);
    signal txintr_en_i        : std_logic;
    signal rxintr_en_i        : std_logic;
    signal intr_clr_i         : std_logic;
    signal intr_clr_pulse_i   : std_logic;
    signal txfifo_clr_i       : std_logic;
    signal txfifo_clr_pulse_i : std_logic;
    signal rxfifo_clr_i       : std_logic;
    signal rxfifo_clr_pulse_i : std_logic;
    signal intr_clr_reg1      : std_logic;
    signal intr_clr_reg2      : std_logic;
    signal txfifo_clr_reg1    : std_logic;
    signal txfifo_clr_reg2    : std_logic;
    signal rxfifo_clr_reg1    : std_logic;
    signal rxfifo_clr_reg2    : std_logic;
    signal adr_mode_i         : std_logic;
    signal read_ack_i         : std_logic;
    signal write_ack_i        : std_logic;
    signal not_write_ack_i    : std_logic;
    signal config_latch_en_i  : std_logic;
    signal slave_addr_reg_i   : std_logic_vector(15 downto 0);
    signal rxfifo_rden_i      : std_logic;
    signal outdata_i          : std_logic_vector(7 downto 0);
    signal rxfifo_rden_reg    : std_logic;
    signal tx_done_i          : std_logic;
    signal rx_done_i          : std_logic;
    --signal rw_mode_i          : std_logic;
    signal counter_i          : std_logic_vector(1 downto 0);
    signal temp1_outdata_i    : std_logic_vector(7 downto 0);
    signal temp2_outdata_i    : std_logic_vector(7 downto 0);
    signal temp3_outdata_i    : std_logic_vector(7 downto 0);
    signal config_latch_en1_i : std_logic;
    signal data_en_i          : std_logic;
    signal transaction_done   : std_logic;
    signal clk_str_cnt_reg_i  : std_logic_vector(7 downto 0);


begin
----------------------------------------------------------------------------------------------------

    transaction_done <= i_tx_done and i_rx_done;

    --Enabling txfifo write
    o_txfifo_wren <= i_we when i_addr = TXFIFO_ADR and i_cs = '1' else
                     '0';

    o_rxfifo_rden <= rxfifo_rden_i;


    o_txfifo_wrclk  <= i_clk;
    o_txfifo_wrdata <= i_data;
    o_rxfifo_rdclk  <= i_clk;

    data_en_i <= '1' when i_oe = '1' and i_cs = '1' else
                 '0';

    process(i_clk, i_rst)
    begin
        if (i_rst = '1') then
            o_data_en <= '0';
        elsif (i_clk'event and i_clk = '1') then
            o_data_en <= data_en_i;
        end if;
    end process;

    process (i_addr,i_oe,i_cs,adr_mode_i,read_ack_i,write_ack_i,not_write_ack_i,slave_addr_reg_i,
             rxfifo_clr_i,txfifo_clr_i,txintr_en_i,rxintr_en_i,intr_clr_i,config_latch_en_i,i_i2c_busy,
             tx_done_i,rx_done_i,i_rxfifo_full,i_rxfifo_empty,i_rxfifo_hfull,i_txfifo_full,
             i_txfifo_empty,i_txfifo_hfull,clk_str_cnt_reg_i)
    begin
        if (i_oe = '1' and i_cs = '1') then
            case i_addr is
                when MODEREG_ADR =>
                    temp2_outdata_i <= adr_mode_i & read_ack_i & write_ack_i & not_write_ack_i & "0000";
                when SLAVE_ADRLSB =>
                    temp2_outdata_i <= slave_addr_reg_i(7 downto 0);
                when SLAVE_ADRMSB =>
                    temp2_outdata_i <= slave_addr_reg_i(15 downto 8);
                when CONFIG_REGADR =>
                    temp2_outdata_i <= rxfifo_clr_i & txfifo_clr_i & txintr_en_i & rxintr_en_i & 
                                       intr_clr_i & config_latch_en_i & "00";
                when CMD_STAT_ADR =>
                    temp2_outdata_i <= i_i2c_busy & tx_done_i & rx_done_i & "00000";
                when FIFO_STAT_ADR =>
                    temp2_outdata_i <= i_rxfifo_full & i_rxfifo_empty & i_rxfifo_hfull &
                                       i_txfifo_full & i_txfifo_empty & i_txfifo_hfull & "00";
                when CLK_STR_CNT_REG =>
                    temp2_outdata_i <= clk_str_cnt_reg_i(7 downto 0);
                when others =>
                    temp2_outdata_i <= (others => '0');
            end case;
        else
            temp2_outdata_i <= (others => '0');
        end if;
    end process;

    process (i_clk, i_rst)
    begin
        if (i_rst = '1') then
            temp3_outdata_i <= (others => '0');
        elsif (i_clk'event and i_clk = '1' ) then
            temp3_outdata_i <= temp2_outdata_i;
        end if;
    end process;


    outdata_i <= temp1_outdata_i when config_latch_en_i = '1' else
                 temp3_outdata_i;

    ------------------------------------------------------------------------------------------------
    -- Configuration registers
    ------------------------------------------------------------------------------------------------

    -- Storing the data from input bus to SLAVE_ADDRLSB Register and SLAVE ADDRMSB Register 
    slave_addr_reg_proc : process (i_clk, i_rst)
    begin  -- process slave_addr_reg_proc
        if i_rst = '1' then                     -- asynchronous reset (active high)
            slave_addr_reg_i                  <= (others => '0');
        elsif i_clk'event and i_clk = '1' then  -- rising clock edge
            if(i_addr = SLAVE_ADRLSB and i_we = '1' and i_cs = '1')then
                slave_addr_reg_i(7 downto 0)  <= i_data;
            elsif(i_addr = SLAVE_ADRMSB and i_we = '1' and i_cs = '1')then
                slave_addr_reg_i(15 downto 8) <= i_data;
            end if;
        end if;
    end process slave_addr_reg_proc;

    ------------------------------------------------------------------------------------------------
    -- Command status register
    ------------------------------------------------------------------------------------------------
    -- Indicating completion of data transmission and reception by making tx_done and 
    -- rx_done signals HIGH.
    status_latch_proc : process (i_clk, i_rst)
    begin  -- process status_latch_proc
        if i_rst = '1' then                     -- asynchronous reset (active high)
            tx_done_i     <= '0';
            rx_done_i     <= '0';
        elsif i_clk'event and i_clk = '1' then  -- rising clock edge
            if(i_tx_done = '1')then
                tx_done_i <= '1';
            elsif(intr_clr_pulse_i = '1')then
                tx_done_i <= '0';
            end if;
            if(i_rx_done = '1')then
                rx_done_i <= '1';
            elsif(intr_clr_pulse_i = '1')then
                rx_done_i <= '0';
            end if;
        end if;
    end process status_latch_proc;

    -- Writing to Command Status Register
    cmd_stat_reg_i <= i_i2c_busy & tx_done_i & rx_done_i & "00000";

    -- Writing to FIFO Status Register
    fifo_stat_reg_i <= i_rxfifo_full & i_rxfifo_empty & i_rxfifo_hfull &
                       i_txfifo_full & i_txfifo_empty & i_txfifo_hfull & "00";

    ------------------------------------------------------------------------------------------------
    -- Configuration bits
    ------------------------------------------------------------------------------------------------

    latch_config_bit_proc : process (i_clk, i_rst)
    begin  -- process latch_config_bit_proc
        if i_rst = '1' then                     -- asynchronous reset (active high)
            o_txfifo_clr <= '0';
            o_rxfifo_clr <= '0';
        elsif i_clk'event and i_clk = '1' then  -- rising clock edge
            o_txfifo_clr <= txfifo_clr_i;
            o_rxfifo_clr <= rxfifo_clr_i;
        end if;
    end process latch_config_bit_proc;


    -- Storing Transmission Interrupt Enable,Reception Interrupt Enable and
    -- Config_latch_en from i_data bus.
    txi_rxi_config_latch_en_proc : process (i_clk, i_rst)
    begin  -- process txi_rxi_en_proc
        if i_rst = '1' then                     -- asynchronous reset (active high)
            txintr_en_i           <= '0';
            rxintr_en_i           <= '0';
            config_latch_en_i     <= '0';
        elsif i_clk'event and i_clk = '1' then  -- rising clock edge
            if(i_addr = CONFIG_REGADR and i_we = '1' and i_cs = '1')then
                txintr_en_i       <= i_data(5);
                rxintr_en_i       <= i_data(4);
                config_latch_en_i <= i_data(2);
            elsif (transaction_done = '0') then
                config_latch_en_i <= '0';
            end if;
        end if;
    end process txi_rxi_config_latch_en_proc;


    -- Storing Interrupt Clear signal from i_data bus.
    intr_clr_reset_proc : process (i_clk, i_rst, intr_clr_pulse_i)
    begin  -- process intr_clr_reset_proc
        if i_rst = '1' or intr_clr_pulse_i = '1'then  -- asynchronous reset (active high)
            intr_clr_i     <= '0';
        elsif i_clk'event and i_clk = '1' then        -- rising clock edge
            if(i_addr = CONFIG_REGADR and i_we = '1' and i_cs = '1')then
                intr_clr_i <= i_data(3);
            end if;
        end if;
    end process intr_clr_reset_proc;

    -- Storing TXFIFO Clear signal from i_data bus.
    txfifo_clr_reset_proc : process (i_clk, i_rst, txfifo_clr_pulse_i)
    begin  -- process txfifo_clr_reset_proc
        if i_rst = '1' or txfifo_clr_pulse_i = '1'then  -- asynchronous reset (active high)
            txfifo_clr_i     <= '0';
        elsif i_clk'event and i_clk = '1' then          -- rising clock edge
            if(i_addr = CONFIG_REGADR and i_we = '1' and i_cs = '1')then
                txfifo_clr_i <= i_data(6);
            end if;
        end if;
    end process txfifo_clr_reset_proc;

    -- Storing RXFIFO Clear signal from i_data bus.
    rxfifo_clr_reset_proc : process (i_clk, i_rst, rxfifo_clr_pulse_i)
    begin  -- process rxfifo_clr_reset_proc
        if i_rst = '1' or rxfifo_clr_pulse_i = '1'then  -- asynchronous reset (active high)
            rxfifo_clr_i     <= '0';
        elsif i_clk'event and i_clk = '1' then          -- rising clock edge
            if(i_addr = CONFIG_REGADR and i_we = '1' and i_cs = '1')then
                rxfifo_clr_i <= i_data(7);
            end if;
        end if;
    end process rxfifo_clr_reset_proc;

    -- Process for getting pulse for Interrupt Clear,TXFIFO Clear and RXFIFO Clear.
    sync2_sys_clk_proc : process (i_clk, i_rst)
    begin  -- process sync2_sys_clk_proc
        if i_rst = '1' then                     -- asynchronous reset (active high)
            intr_clr_reg1   <= '0';
            intr_clr_reg2   <= '0';
            txfifo_clr_reg1 <= '0';
            txfifo_clr_reg2 <= '0';
            rxfifo_clr_reg1 <= '0';
            rxfifo_clr_reg2 <= '0';
        elsif i_clk'event and i_clk = '1' then  -- rising clock edge
            intr_clr_reg1   <= intr_clr_i;
            intr_clr_reg2   <= intr_clr_reg1;
            txfifo_clr_reg1 <= txfifo_clr_i;
            txfifo_clr_reg2 <= txfifo_clr_reg1;
            rxfifo_clr_reg1 <= rxfifo_clr_i;
            rxfifo_clr_reg2 <= rxfifo_clr_reg1;
        end if;
    end process sync2_sys_clk_proc;

    intr_clr_pulse_i   <= intr_clr_reg1 and not intr_clr_reg2;
    txfifo_clr_pulse_i <= txfifo_clr_reg1 and not txfifo_clr_reg2;
    rxfifo_clr_pulse_i <= rxfifo_clr_reg1 and not rxfifo_clr_reg2;

    ------------------------------------------------------------------------------------------------
    -- Mode register
    ------------------------------------------------------------------------------------------------

    -- Storing Mode register bits from i_data bus.
    i2c_mode_proc : process (i_clk, i_rst)
    begin  -- process i2c_mode_proc
        if i_rst = '1' then                     -- asynchronous reset (active high)
            adr_mode_i      <= '0';
            read_ack_i      <= '0';
            write_ack_i     <= '0';
            not_write_ack_i <= '0';
        elsif i_clk'event and i_clk = '1' then  -- rising clock edge
            if(i_addr = MODEREG_ADR and i_we = '1' and i_cs = '1')then
                adr_mode_i      <= i_data(7);
                read_ack_i      <= i_data(6);
                write_ack_i     <= i_data(5);
                not_write_ack_i <= i_data(4);
            end if;
        end if;
    end process i2c_mode_proc;


    ------------------------------------------------------------------------------------------------
    -- Clk Stretch Counter register
    ------------------------------------------------------------------------------------------------

    clk_str_cnt_reg_proc : process (i_clk, i_rst)
    begin  -- process clk_str_cnt_reg_proc
        if i_rst = '1' then                     -- asynchronous reset (active high)
            clk_str_cnt_reg_i                  <= (others => '0');
        elsif i_clk'event and i_clk = '1' then  -- rising clock edge
            if(i_addr = CLK_STR_CNT_REG and i_we = '1' and i_cs = '1')then
                clk_str_cnt_reg_i(7 downto 0)  <= i_data;
            end if;
        end if;
    end process clk_str_cnt_reg_proc;

    ------------------------------------------------------------------------------------------------
    -- Configuration register read interface. Status registers are read only.
    ------------------------------------------------------------------------------------------------
    o_data <= i_rxfifo_rddata when rxfifo_rden_reg = '1' else
              outdata_i;

    -- As the counter advances store Mode register,Slave Address LSB Register and 
    -- Slave Address MSB Registers which are to be sent to Slave module.    
    process (i_clk, i_rst, counter_i)
    begin
        if (i_rst = '1') then
            temp1_outdata_i         <= (others => '0');
        elsif (i_clk = '1' and i_clk'event) then
            case counter_i is
                when "00"                      =>
                    temp1_outdata_i <= adr_mode_i & read_ack_i & write_ack_i & not_write_ack_i & "0000";
                when "01"                      =>
                    temp1_outdata_i <= slave_addr_reg_i(7 downto 0);
                when "10"                      =>
                    temp1_outdata_i <= slave_addr_reg_i(15 downto 8);
                when "11"                      =>
                    temp1_outdata_i <= clk_str_cnt_reg_i(7 downto 0);
                when others                    => null;
            end case;
        end if;
    end process;

    o_config_latch_en <= config_latch_en_i and config_latch_en1_i;

    -- Start the counter when the config_latch_en_i is HIGH.
    process (i_clk, i_rst, transaction_done)
    begin
        if (i_rst = '1' or transaction_done = '0') then
            config_latch_en1_i         <= '0';
        elsif (i_clk = '1' and i_clk'event) then
            if (config_latch_en_i = '1') then
                if (counter_i = "11") then
                    config_latch_en1_i <= '0';
                else
                    config_latch_en1_i <= '1';
                end if;
            end if;
        end if;
    end process;

    process (i_clk, i_rst)
    begin
        if (i_rst = '1') then
            counter_i         <= "00";
        elsif (i_clk = '1' and i_clk'event) then
            if (config_latch_en_i = '1') then
                if (counter_i = "11") then
                    counter_i <= (others => '1');
                else
                    counter_i <= counter_i + '1';
                end if;
            else
                counter_i     <= (others => '0');
            end if;
        end if;
    end process;


    -- Enabling RXFIFO Read
    rxfifo_rden_i <= i_oe when i_addr = RXFIFO_ADR and i_cs = '1' else
                     '0';

    rdfifo_rden_reg_proc : process (i_clk, i_rst)
    begin  -- process rdfifo_rden_reg_proc
        if i_rst = '1' then                     -- asynchronous reset (active high)
            rxfifo_rden_reg <= '0';
        elsif i_clk'event and i_clk = '1' then  -- rising clock edge
            rxfifo_rden_reg <= rxfifo_rden_i;
        end if;
    end process rdfifo_rden_reg_proc;

    ------------------------------------------------------------------------------------------------
    -- Interrupt generation logic
    ------------------------------------------------------------------------------------------------
    -- Generation of Interrupt
    intr_gen_proc : process (i_clk, i_rst)
    begin  -- process intr_gen_proc
        if i_rst = '1' then                     -- asynchronous reset (active high)
            o_intr     <= '0';
        elsif i_clk'event and i_clk = '1' then  -- rising clock edge
            if(intr_clr_i = '1')then
                o_intr <= '0';
            elsif( (i_tx_done = '1' and txintr_en_i = '1' ) or (i_txfifo_full = '1') or
                   (i_txfifo_empty = '1') or (i_rx_done = '1' and rxintr_en_i = '1' ) or
                   (i_rxfifo_full = '1') or (i_rxfifo_empty = '1')) then
                o_intr <= '1';
            end if;
        end if;
    end process intr_gen_proc;

    o_busy <= i_i2c_busy;

----------------------------------------------------------------------------------------------------
end rtl;
