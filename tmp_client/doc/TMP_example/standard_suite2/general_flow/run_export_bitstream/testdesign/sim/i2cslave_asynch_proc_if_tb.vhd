----------------------------------------------------------------------------------------------------
-- Title      : Asynchronous parallel processor interface testbench
-- Project    : I2CSlave_Async_Proc_IF
----------------------------------------------------------------------------------------------------
-- File       : i2cslave_asynch_proc_if_tb.vhd
-- Author     : GRJ
-- Company    : SiliconBlue Tech.
-- Last update: 03Jul2010
----------------------------------------------------------------------------------------------------
-- Description: This testbench covers all the following cases to test the Asynchronous parallel processor interface
-- Cases covered are :
-- 1)  Reading from empty FIFO (Before Data Transaction)
-- 2)  7 Bit Address 2 bytes Slave Write operation
-- 3)  10 Bit Address 1 byte Slave Read operation
-- 4)  10 Bit Address 2 bytes Slave Write operation
-- 5)  7 Bit Address 1 byte Slave Reads operation
-- 6)  10 Bit Address 2 bytes Slave Read operation (Changed Address)
-- 7)  7 Bit Address 10 byte Slave Read operation
-- 8)  7 Bit Address 10 byte Slave Write operation
-- 9)  10 Bit Address 8 bytes Slave Write operation
-- 10) Reading from empty FIFO (In between Data Transaction)
-- 11) 7 Bit Address 10 byte Slave Read operation with Repeated Start condition
-- 12) 7 Bit Address 10 byte Slave Write operation with Repeated Start condition
-- 13) 10 Bit Address 8 byte Slave Write operation with Repeated Start condition
-- 14) 10 Bit Address 2 byte Slave Read operation with Repeated Start condition

--     High Speed Mode
-- 15) 5 bytes Master Write (without repeated START)
-- 16) 8 bytes Master Read (without repeated START)
-- 17) 6 bytes Master Write (with repeated START) 
-- 18) 4 bytes Master Read (with repeated START)
-- 19) 10 byte Master Write 10 bit address (without repeated START) 
-- 20) 6 byte Master Read 10 bit address (without repeated START)
-- 21) 9 bytes Master Write (with repeated START)
-- 22) 8 bytes Master Read (with repeated START) 
-- 23) Reading from empty FIFO (After Data Transaction)   
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
use work.i2cslave_asynch_proc_if_tb_package.all;

entity i2cslave_asynch_proc_if_tb is
end i2cslave_asynch_proc_if_tb;

architecture i2cslave_asynch_proc_if_tb_arch of i2cslave_asynch_proc_if_tb is

   

    component i2cslave_asynch_proc_if_top
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
    end component;

begin

    i2c_enhancements_asynch_proc_if_tb_u1 : i2cslave_asynch_proc_if_top
        port map (
            i_clk   => clk_tb,
            i_oe    => oe_tb,
            i_we    => we_tb,
            i_cs    => cs_tb,
            i_addr  => addr_tb,
            io_data => data_tb,
            o_intr  => intr_tb,
            o_busy  => busy_tb,
            i_reset => rst_tb,
            io_sda  => i2c_sda_tb,
            io_scl  => i2c_scl_tb
            );


    ------------------------------------------------------------------------------------------------
    -- Clock and reset generation
    ------------------------------------------------------------------------------------------------
    --clk_tb <= not clk_tb after CLK_PERIOD/2;
    rst_tb <= '0'        after 10 * CLK_PERIOD;

    sys_clock : process
    begin
        wait for CLK_PERIOD/2;
        clk_tb <= not clk_tb;
    end process sys_clock;



    ------------------------------------------------------------------------------------------------
    -- Shared variables are latched under clk_tb
    ------------------------------------------------------------------------------------------------
    -- Connecting Shared variables to signals (Parallel)
    process(clk_tb)
    begin
        cs_tb   <= asynch_cs_i;
        data_tb <= asynch_data_i;
        oe_tb   <= asynch_oe_i;
        we_tb   <= asynch_we_i;
        addr_tb <= asynch_addr_i;
    end process;

    -- Connecting Shared variables to signals (Serial)
    shar_vars : process
    begin  -- connect shared variables to signals 
        for i in 0 to 2000000000 loop
            if hs_mode = '0' then
                wait for I2C_CLK_PERIOD/8;
                if i2cm_wr_i = '1' then
                    i2c_sda_tb <= sda_i;
                else
                    i2c_sda_tb <= 'H';
                end if;
                if i2cm_wr_i = '1' then
                    sda_read_i := 'H';
                else
                    sda_read_i := i2c_sda_tb;
                end if;
            else
                wait for I2C_HS_CLK_PERIOD/8;
                if i2cm_wr_i = '1' then
                    i2c_sda_tb <= sda_i;
                else
                    i2c_sda_tb <= 'H';
                end if;
                if i2cm_wr_i = '1' then
                    sda_read_i := 'H';
                else
                    sda_read_i := i2c_sda_tb;
                end if;
            end if;
        end loop;
        wait;
    end process shar_vars;

    clock : process
    begin  -- process clock generation
        wait for I2C_CLK_PERIOD/2;
        i2c_fs_scl_tb <= not i2c_fs_scl_tb;
    end process clock;

    clock_hs : process
    begin
        wait for I2C_HS_CLK_PERIOD/2;
        i2c_hs_scl_tb <= not i2c_hs_scl_tb;
    end process clock_hs;


  
    i2c_scl_tb <= i2c_hs_scl_tb when hs_mode = '1' and clk_str_enable = '0' else
                'H'            when hs_mode = '1' and clk_str_enable = '1' else
                  'H'          when hs_mode = '0' and clk_str_enable = '1' else
                i2c_fs_scl_tb  when hs_mode = '0' and clk_str_enable = '0';


    process
    begin

        -------------------------------------------------------------------     
        -- Reading from empty FIFO (Before Data Transaction)
        -------------------------------------------------------------------  
        wait_cycle(10);
        report ("Reading from empty FIFO before Data Transaction");

        wait until falling_edge(rst_tb);

        -- Reading from Read FIFO
        report ("Reading from RXFIFO");
        data_read(RXFIFO_ADR);
        wait_cycle(10);


        -- Fast Speed Mode

        ------------------------------------------------------------------- 
        -- Case 1: 7 Bit Address 2 bytes Slave Write operation
        -- Slave Address LSB : 11110100
        -- Slave Address MSB : 10011001 
        ------------------------------------------------------------------- 
        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 7 bit addressing - slave write operation- case1");
        data_write("00110000", MODEREG_ADR);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("10011001", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11111111", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write("00100100", CONFIG_REGADR);
        wait_cycle(10);

        -- Writing data to TX_FIFO
        for i in 1 to 2 loop
            data_write(wr_data(i), TXFIFO_ADR);
            wait_cycle(10);
        end loop;



        -------------------------------------------------------------------
        -- I2C Data Transaction begins

        hs_mode  <= '0';
        clk_str_enable <= '0';
        report ("I2C Slave writes - 7 bit addressing");
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("10011001");
        i2cm_ack_detect;

        -- Master Read operation

        i2cm_byte_read;
        i2cm_ack_gen;

  
        
        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_byte_read;
        i2cm_nack_gen;

        i2cm_stop_gen;
        i2cm_fs_wait_cycle(25);

        data_write("00001000", CONFIG_REGADR);
        wait_cycle(10);

        -- Reading back all the registers
        report ("Reading back all the registers after slave write operation for 7 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(10);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

        wait_cycle(1000);

       
        ------------------------------------------------------------------- 
        -- Case 2: 10 Bit Address 1 byte Slave Read operation
        -- Slave Address LSB : 10011001
        -- Slave Address MSB : 11110100 
        -------------------------------------------------------------------       
        -- Master Write operation
        ------------------------------------------------------------------- 
        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 10 bit addressing - slave read operation- case2");
        data_write("10000000", MODEREG_ADR);
        wait_cycle(5);
        data_write("10011001", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("10011010", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);
        -------------------------------------------------------------------
        -- I2C Data Transaction begins

        report ("I2C Slave reads - 10 bit addressing");
        wait until falling_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;

        i2cm_fs_wait_cycle(5);

        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("11110100");
        i2cm_ack_detect;

        
        i2cm_byte_write("10011001");
        i2cm_ack_detect;

        --Master Write operation (1 byte)

        i2cm_byte_write(master_wr_data);
        i2cm_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';
 
        i2cm_stop_gen;
        i2cm_fs_wait_cycle(5);

        wait_cycle(50);
        -- Reading data from RX_FIFO 

        data_read(RXFIFO_ADR);
        wait_cycle(15);


        report ("Reading back all the registers after slave read operation for 10 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(10);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

        wait_cycle(2000);

        
        ------------------------------------------------------------------- 
        -- Case 3: 10 Bit Address 2 bytes Slave Write operation
        -- Slave Address LSB : 10011001
        -- Slave Address MSB : 11110100 
        ------------------------------------------------------------------- 

        -- Master Read operation (2 bytes)
        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 10 bit addressing - slave write operation- case3");
        data_write("10110000", MODEREG_ADR);
        wait_cycle(5);
        data_write("10011001", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("11101010", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);

        -- Writing data to TX_FIFO
        for i in 1 to 2 loop
            data_write(wr_data(i), TXFIFO_ADR);
            wait_cycle(10);
        end loop;


        -------------------------------------------------------------------
        -- I2C Data Transaction begins

        -- Master Read operation
        report ("I2C Slave writes - 10 bit addressing");
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("11110100");
        i2cm_ack_detect;

        i2cm_byte_write("10011001");
        i2cm_ack_detect;

        i2cm_start_gen;


        i2cm_byte_write("11110101");
        i2cm_ack_detect;

        -- Master Data read (2 bytes)

        i2cm_byte_read;
        i2cm_ack_gen;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';


        i2cm_byte_read;
        i2cm_nack_gen;

        i2cm_stop_gen;
        i2cm_fs_wait_cycle(25);

        -- Reading back all the registers
        report("Reading back all the registers after slave write operation for 10 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(10);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

        wait_cycle(1000);
     
        
        ------------------------------------------------------------------- 
        -- Case 4: 7 Bit Address 1 byte Slave Reads operation
        -- Slave Address LSB : 11110100
        -- Slave Address MSB : 10011001 
        ------------------------------------------------------------------- 
        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 7 bit addressing - slave read operation- case4");
        data_write(modereg, MODEREG_ADR);
        wait_cycle(5);
        data_write(slave_address_lsb, SLAVE_ADRLSB);
        wait_cycle(5);
        data_write(slave_address_msb, SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("10101111", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);
        -------------------------------------------------------------------
        -- I2C Data Transaction begins

        report ("I2C Slave reads - 7 bit addressing");
        wait until falling_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;

        i2cm_fs_wait_cycle(5);

        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("11110100");
        i2cm_ack_detect;

        -- Master Write operation

        i2cm_byte_write(master_wr_data);
        i2cm_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';


        i2cm_stop_gen;
        i2cm_fs_wait_cycle(5);

        wait_cycle(50);

        -- Reading data from RX_FIFO 

        data_read(RXFIFO_ADR);
        wait_cycle(5);


        -- Reading back all the registers
        report ("Reading back all the registers after slave read operation for 7 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(10);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

        wait_cycle(1000);

        
        ------------------------------------------------------------------- 
        -- Case 5: 10 Bit Address 2 bytes Slave Read operation (Changed Address)
        -- Slave Address LSB : 01100110
        -- Slave Address MSB : 11110100 
        ------------------------------------------------------------------- 
        -- Master Write operation (2 byte)

        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 10 bit addressing - slave read operation- case5");
        data_write("10000000", MODEREG_ADR);
        wait_cycle(5);
        data_write("01100110", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("10101101", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);
        -------------------------------------------------------------------
        -- I2C Data Transaction begins

        report ("I2C Slave reads - 10 bit addressing");
        wait until falling_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;

        i2cm_fs_wait_cycle(5);

        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("11110100");
        i2cm_ack_detect;

        i2cm_byte_write("01100110");
        i2cm_ack_detect;

        -- Master Write operation (2 byte)
        for i in 1 to 2 loop
            i2cm_byte_write(master_wr_data);
            i2cm_ack_detect;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_stop_gen;
        i2cm_fs_wait_cycle(5);

        wait_cycle(50);

        -- Reading data from RX_FIFO 
        for i in 1 to 2 loop
            data_read(RXFIFO_ADR);
            wait_cycle(5);
        end loop;

        report ("Reading back all the registers after slave read operation for 10 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(10);
        wait_cycle(1000);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

        
        ------------------------------------------------------------------- 
        -- Case 6: 7 Bit Address 10 byte Slave Read operation
        -- Slave Address LSB : 11001100
        -- Slave Address MSB : 10111010
        ------------------------------------------------------------------- 

        -- Writing to all registers (Parallel Data) (10 bytes)

        report ("Writing to all registers for 7 bit addressing - slave read operation- case6");
        data_write(modereg, MODEREG_ADR);
        wait_cycle(5);
        data_write("11001100", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("10111010", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("10101111", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);
        -------------------------------------------------------------------
        -- I2C Data Transaction begins

        report ("I2C Slave reads - 7 bit addressing");
        wait until falling_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;

        i2cm_fs_wait_cycle(5);

        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("11001100");
        i2cm_ack_detect;

        -- Master Write operation
        for i in 1 to 10 loop
            i2cm_byte_write(master_wr_data);
            i2cm_ack_detect;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_stop_gen;
        i2cm_fs_wait_cycle(5);

        wait_cycle(50);
        -- Reading data from RX_FIFO 
        for i in 1 to 10 loop
            data_read(RXFIFO_ADR);
            wait_cycle(5);
        end loop;


        -- Reading back all the registers
        report ("Reading back all the registers after slave read operation for 7 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(10);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);
        wait_cycle(1000);

        

        ------------------------------------------------------------------- 
        -- Case 7: 7 Bit Address 10 byte Slave Write operation
        -- Slave Address LSB : 01100110
        -- Slave Address MSB : 10011001 
        ------------------------------------------------------------------- 

        -- Read operation (10 bytes)
        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 7 bit addressing - slave write operation- case7");
        data_write("00110000", MODEREG_ADR);
        wait_cycle(5);
        data_write("01100111", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("10011001", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("01101111", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write("00100100", CONFIG_REGADR);
        wait_cycle(10);

        -- Writing data to TX_FIFO
        for i in 1 to 10 loop
            data_write(wr_data(i), TXFIFO_ADR);
            wait_cycle(10);
        end loop;
        -------------------------------------------------------------------
        -- I2C Data Transaction begins


        report ("I2C Slave writes - 7 bit addressing");
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("01100111");
        i2cm_ack_detect;

        -- Master Read operation
        for i in 1 to 9 loop
            i2cm_byte_read;
            i2cm_ack_gen;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_byte_read;
        i2cm_nack_gen;

        i2cm_stop_gen;
        i2cm_fs_wait_cycle(25);

        -- Reading back all the registers
        report ("Reading back all the registers after slave write operation for 7 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(10);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

        wait_cycle(1000);


       
        ------------------------------------------------------------------- 
        -- Case 8: 10 Bit Address 8 bytes Slave Write operation
        -- Slave Address LSB : 10011001
        -- Slave Address MSB : 11110100 
        ------------------------------------------------------------------- 

        -- Master Read operation (8 bytes)
        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 10 bit addressing - slave write opeartion- case8");
        data_write("10110000", MODEREG_ADR);
        wait_cycle(5);
        data_write("10011001", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("01101111", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);

        -- Writing data to TX_FIFO
        for i in 1 to 8 loop
            data_write(wr_data(i), TXFIFO_ADR);

        end loop;

        -------------------------------------------------------------------
        -- I2C Data Transaction begins

        -- Master Read operation
        report ("I2C Slave writes - 10 bit addressing");
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("11110100");
        i2cm_ack_detect;

        i2cm_byte_write("10011001");
        i2cm_ack_detect;

        i2cm_start_gen;

        i2cm_byte_write("11110101");
        i2cm_ack_detect;

        --Master Data reads (8 bytes)
        for i in 1 to 7 loop
            i2cm_byte_read;
            i2cm_ack_gen;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_byte_read;
        i2cm_nack_gen;

        i2cm_stop_gen;
        i2cm_fs_wait_cycle(25);


        -- Reading back all the registers
        report ("Reading back all the registers after slave write operation for 10 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(10);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

        wait_cycle(1000);


       
        -------------------------------------------------------------------     
        -- Reading from empty FIFO (In between Data Transaction)
        -------------------------------------------------------------------  
        wait_cycle(10);
        report ("Reading from empty FIFO in between Data Transaction");

        data_write("11000000", CONFIG_REGADR);
        wait_cycle(5);

        -- Reading from Read FIFO
        report ("Reading from RXFIFO");
        data_read(RXFIFO_ADR);
        wait_cycle(5);

        wait_cycle(1000);


        -------------------------------------------------------------------  

        -- Case 9: 7 Bit Address 10 byte Slave Read operation with Repeated Start condition
        -- Slave Address LSB : 11001100
        -- Slave Address MSB : 10111010
        ------------------------------------------------------------------- 

        -- Writing to all registers (Parallel Data) (10 bytes)

        report ("Writing to all registers for 7 bit addressing - slave read operation- case9");
        data_write(modereg, MODEREG_ADR);
        wait_cycle(5);
        data_write("11001100", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("10111010", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("01101111", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);
        -------------------------------------------------------------------
        -- I2C Data Transaction begins

        report ("I2C Slave reads - 7 bit addressing");
        wait until falling_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;

        i2cm_fs_wait_cycle(5);

        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("11001100");
        i2cm_ack_detect;

        -- Master Write operation
        for i in 1 to 10 loop
            i2cm_byte_write(master_wr_data);
            i2cm_ack_detect;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_start_gen;

        i2cm_byte_write("11001100");
        i2cm_ack_detect;


        -- Master Write operation
        for i in 1 to 10 loop
            i2cm_byte_write(master_wr_data1);
            i2cm_ack_detect;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_stop_gen;
        i2cm_fs_wait_cycle(5);

        -- Reading data from RX_FIFO 
        for i in 1 to 20 loop
            data_read(RXFIFO_ADR);
            wait_cycle(5);
        end loop;


        -- Reading back all the registers
        report ("Reading back all the registers after slave read operation for 7 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(1000);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);


        
        -------------------------------------------------------------------------------------  

        -- Case 10: 7 Bit Address 10 byte Slave Write operation with Repeated Start condition
        -- Slave Address LSB : 11001100
        -- Slave Address MSB : 10111010
        -------------------------------------------------------------------------------------- 

        -- Read operation (10 bytes)
        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 7 bit addressing - slave write operation- case10");
        data_write("00110000", MODEREG_ADR);
        wait_cycle(5);
        data_write("01100111", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("10011001", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("01101111", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write("00100100", CONFIG_REGADR);
        wait_cycle(10);

        -- Writing data to TX_FIFO
        for i in 1 to 20 loop
            data_write(wr_data(i), TXFIFO_ADR);
            wait_cycle(10);
        end loop;
        -------------------------------------------------------------------
        -- I2C Data Transaction begins

        
        report ("I2C Slave writes - 7 bit addressing");
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("01100111");
        i2cm_ack_detect;

        -- Master Read operation
        for i in 1 to 9 loop
            i2cm_byte_read;
            i2cm_ack_gen;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_byte_read;
        i2cm_nack_gen;

        i2cm_start_gen;

        i2cm_byte_write("01100111");
        i2cm_ack_detect;

        -- Master Read operation
        for i in 1 to 9 loop
            i2cm_byte_read;
            i2cm_ack_gen;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_byte_read;
        i2cm_nack_gen;

        i2cm_stop_gen;
        i2cm_fs_wait_cycle(25);



        -- Reading back all the registers
        report ("Reading back all the registers after slave write operation for 7 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(10);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

        wait_cycle(1000);


        
        ----------------------------------------------------------------------------------------  

        -- Case 11: 10 Bit Address 8 byte Slave Write operation with Repeated Start condition
        -- Slave Address LSB : 11001100
        -- Slave Address MSB : 10111010
        ---------------------------------------------------------------------------------------- 

        -- Master Read operation (8 bytes)
        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 10 bit addressing - slave write opeartion- case11");
        data_write("10110000", MODEREG_ADR);
        wait_cycle(5);
        data_write("10011001", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("01101111", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);

        -- Writing data to TX_FIFO
        for i in 1 to 15 loop
            data_write(wr_data(i), TXFIFO_ADR);
            -- data_write("10101010",TXFIFO_ADR);
            wait_cycle(10);
        end loop;

        -------------------------------------------------------------------
        -- I2C Data Transaction begins

        -- Master Read operation
        report ("I2C Slave writes - 10 bit addressing");
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("11110100");
        i2cm_ack_detect;

        i2cm_byte_write("10011001");
        i2cm_ack_detect;

        i2cm_start_gen;

        i2cm_byte_write("11110101");
        i2cm_ack_detect;

        --Master Data reads (8 bytes)
        for i in 1 to 7 loop
            i2cm_byte_read;
            i2cm_ack_gen;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_byte_read;
        i2cm_nack_gen;

        i2cm_start_gen;

        i2cm_byte_write("11110101");
        i2cm_ack_detect;

        --Master Data reads (8 bytes)

        for i in 1 to 7 loop
            i2cm_byte_read;
            i2cm_ack_gen;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_byte_read;
        i2cm_nack_gen;

        i2cm_stop_gen;
        i2cm_fs_wait_cycle(25);


        -- Reading back all the registers
        report ("Reading back all the registers after slave write operation for 10 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(10);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

        wait_cycle(1000);


       
        ----------------------------------------------------------------------------------------  

        -- Case 12: 10 Bit Address 2 byte Slave Read operation with Repeated Start condition
        -- Slave Address LSB : 11001100
        -- Slave Address MSB : 10111010
        ---------------------------------------------------------------------------------------- 

        -- Master Write operation (2 byte)

        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 10 bit addressing - slave read operation- case12");
        data_write("11100000", MODEREG_ADR);
        wait_cycle(5);
        data_write("01100110", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("11101111", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);
        -------------------------------------------------------------------
        -- I2C Data Transaction begins

        report ("I2C Slave reads - 10 bit addressing");
        wait until falling_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;

        i2cm_fs_wait_cycle(5);

        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("11110100");
        i2cm_ack_detect;

        i2cm_byte_write("01100110");
        i2cm_ack_detect;

        -- Master Write operation (1 byte)
        for i in 1 to 2 loop
            i2cm_byte_write("10100100");
            i2cm_ack_detect;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_start_gen;

        i2cm_byte_write("11110100");
        i2cm_ack_detect;

        i2cm_byte_write("01100110");
        i2cm_ack_detect;

        -- Master Write operation (1 byte)
        for i in 1 to 2 loop
            i2cm_byte_write(master_wr_data1);
            i2cm_ack_detect;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;



        i2cm_stop_gen;
        i2cm_fs_wait_cycle(5);
        wait_cycle(50);

        -- Reading data from RX_FIFO 
        for i in 1 to 4 loop
            data_read(RXFIFO_ADR);
            wait_cycle(5);
        end loop;


        report ("Reading back all the registers after slave read operation for 10 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(20);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);


        
        -- High Speed Mode Design

        -------------------------------------------------------------------
        --Case 13: 5 bytes Master Write (without repeated START) 
        -------------------------------------------------------------------
        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 7 bit addressing - slave read operation,High Speed Mode- case13");
        data_write("00000000", MODEREG_ADR);
        wait_cycle(5);
        data_write("10011000", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("11010000", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);

        -- Write operation
        report ("5 bytes Write operation without repeated START - Case 13");
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("00001010");
        i2cm_nack_detect;


        hs_mode <= '1';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_HS_CLK_PERIOD/8;
        i2cm_hs_start_gen;

        i2cm_hs_byte_write("1001100" & '0');
        i2cm_hs_ack_detect;

        i2cm_hs_byte_write("10111010");  
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_byte_write("00101010");  
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_byte_write("10111010");  
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_byte_write("10101000");  
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_byte_write("10100010");  
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';




        i2cm_hs_stop_gen;
        hs_mode <= '0';
        i2cm_hs_wait_cycle(250);

         -- Reading data from RX_FIFO 
        for i in 1 to 5 loop
            data_read(RXFIFO_ADR);
            wait_cycle(5);
        end loop;


        report ("Reading back all the registers after slave read operation for 7 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(20);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

        
        -------------------------------------------------------------------
        --Case 14: 8 bytes Master Read (without repeated START) 
        -------------------------------------------------------------------
        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 7 bit addressing - slave write operation,High Speed Mode- case14");
        data_write("00110000", MODEREG_ADR);
        wait_cycle(5);
        data_write("10011000", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("10000110", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);


        -- Writing data to TX_FIFO
        for i in 1 to 8 loop
            data_write(wr_data(i), TXFIFO_ADR);
            wait_cycle(10);
        end loop;


        -- Read operation
        report ("8 bytes read operation Case 14");
        hs_mode <= '0';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("00001010");
        i2cm_nack_detect;


        hs_mode <= '1';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_HS_CLK_PERIOD/8;
        i2cm_hs_start_gen;


        i2cm_hs_byte_write("1001100" & '1');
        i2cm_hs_ack_detect;

        for i in 1 to 7 loop
            i2cm_hs_byte_read;
            i2cm_hs_ack_gen;
            
           -- wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        
        i2cm_hs_byte_read;
        i2cm_hs_nack_gen;


        i2cm_hs_stop_gen;
        hs_mode <= '0';
        i2cm_hs_wait_cycle(2500);

       
        report ("Reading back all the registers after slave read operation for 7 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(20);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

       
        -------------------------------------------------------------------
        --Case 15: 6 bytes Master Write (with repeated START) 
        -------------------------------------------------------------------

        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 7 bit addressing - slave read operation- case15");
        data_write("00000000", MODEREG_ADR);
        wait_cycle(5);
        data_write("10011001", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("11010000", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);


        -- Write operation
        hs_mode <= '0';
        report ("6 bytes Master Write operation with repeated START,High Speed Mode - Case 15");
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("00001010");
        i2cm_nack_detect;


        hs_mode <= '1';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_HS_CLK_PERIOD/8;
        i2cm_hs_start_gen;

        i2cm_hs_byte_write("1001100" & '0');
        i2cm_hs_ack_detect;

        for i in 1 to 6 loop
            i2cm_hs_byte_write("01010101");
            i2cm_hs_ack_detect;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_hs_start_gen;

        i2cm_hs_byte_write("1001100" & '0');
        i2cm_hs_ack_detect;

        for i in 1 to 6 loop
            i2cm_hs_byte_write("10101010");
            i2cm_hs_ack_detect;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_hs_stop_gen;
        hs_mode <= '0';
        i2cm_hs_wait_cycle(250);

          -- Reading data from RX_FIFO 
        for i in 1 to 12 loop
            data_read(RXFIFO_ADR);
            wait_cycle(5);
        end loop;


        report ("Reading back all the registers after slave read operation for 7 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(20);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);


         
        -------------------------------------------------------------------
        --Case 16: 4 bytes Master Read (with repeated START) 
        -------------------------------------------------------------------
         -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 7 bit addressing - slave write operation,High Speed Mode- case16");
        data_write("00110000", MODEREG_ADR);
        wait_cycle(5);
        data_write("10011000", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("01000111", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);


        -- Writing data to TX_FIFO
       -- for i in 1 to 4 loop
            data_write("00101010", TXFIFO_ADR);
            wait_cycle(10);
       -- end loop;

        data_write("00110011",TXFIFO_ADR);
        wait_cycle(10);

        data_write("01010101",TXFIFO_ADR);
        wait_cycle(10);

        data_write("11001100",TXFIFO_ADR);
        wait_cycle(10);


        -- Read operation
        report ("4 bytes read operation Case 16");
        hs_mode <= '0';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("00001010");
        i2cm_nack_detect;


        hs_mode <= '1';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_HS_CLK_PERIOD/8;
        i2cm_hs_start_gen;


        i2cm_hs_byte_write("1001100" & '1');
        i2cm_hs_ack_detect;

        i2cm_hs_byte_read;
        i2cm_hs_ack_gen;


        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';
       
        i2cm_hs_byte_read;
        i2cm_hs_nack_gen;
       
        i2cm_hs_start_gen;


        i2cm_hs_byte_write("1001100" & '1');
        i2cm_hs_ack_detect;


        i2cm_hs_byte_read;
        i2cm_hs_ack_gen;
        
        
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_byte_read;
        i2cm_hs_nack_gen;


        i2cm_hs_stop_gen;
        hs_mode <= '0';
        i2cm_hs_wait_cycle(2500);

        report ("Reading back all the registers after slave read operation for 7 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(20);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

       
         
        -------------------------------------------------------------------
        --Case 17: 10 byte Master Write 10 bit address (without repeated START) 
        -------------------------------------------------------------------

        -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 10 bit addressing - slave read operation- case17");
        data_write("10000000", MODEREG_ADR);
        wait_cycle(5);
        data_write("10011001", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("11010000", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);

 
        -- Write operation  
        report ("10 byte Write operation without repeated START - Case 17");
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/4;
        i2cm_start_gen;

        i2cm_byte_write("00001010");
        i2cm_nack_detect;

        hs_mode <= '1';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_HS_CLK_PERIOD/8;
        i2cm_hs_start_gen;

        i2cm_hs_byte_write("11110100");
        i2cm_hs_ack_detect;
        i2cm_hs_byte_write("10011001");
        i2cm_hs_ack_detect;

        for i in 1 to 10 loop
            i2cm_hs_byte_write("01011010");
            i2cm_hs_ack_detect;

            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;

        i2cm_hs_stop_gen;
        hs_mode <= '0';
        i2cm_hs_wait_cycle(250);


        -- Reading data from RX_FIFO 
        for i in 1 to 10 loop
            data_read(RXFIFO_ADR);
            wait_cycle(5);
        end loop;

        report ("Reading back all the registers after slave read operation for 10 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(20);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);


        
        -------------------------------------------------------------------
        --Case 18: 6 byte Master Read 10 bit address (without repeated START) 
        -------------------------------------------------------------------

         -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 10 bit addressing - slave write operation,High Speed Mode- case18");
        data_write("10110000", MODEREG_ADR);
        wait_cycle(5);
        data_write("10011000", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("10000111", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);


        -- Writing data to TX_FIFO
        for i in 1 to 6 loop
            data_write("00001010", TXFIFO_ADR);
            wait_cycle(10);
        end loop;


        -- Read operation  
        hs_mode <= '0';
        report ("6 byte read operation Case 18");
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("00001010");
        i2cm_nack_detect;

        hs_mode <= '1';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_HS_CLK_PERIOD/8;
        i2cm_hs_start_gen;

        i2cm_hs_byte_write("11110100");
        i2cm_hs_ack_detect;
        i2cm_hs_byte_write("10011000");
        i2cm_hs_ack_detect;

        i2cm_hs_start_gen;
        i2cm_hs_byte_write("11110101");
        i2cm_hs_ack_detect;

        for i in 1 to 5 loop
            i2cm_hs_byte_read;
            i2cm_hs_ack_gen;

            wait until rising_edge(i2c_scl_tb);         
            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;


        i2cm_hs_byte_read;
        i2cm_hs_nack_gen;

        i2cm_hs_stop_gen;
        hs_mode <= '0';
        i2cm_hs_wait_cycle(2500);

        report ("Reading back all the registers after slave read operation for 10 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(20);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

       
        
        -------------------------------------------------------------------
        --Case 19: 9 bytes Master Write (with repeated START) 
        -------------------------------------------------------------------

        report ("Writing to all registers for 10 bit addressing - slave read operation,High Speed Mode- case19");
        data_write("10000000", MODEREG_ADR);
        wait_cycle(5);
        data_write("10011001", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("00001000", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);

        -- Write operation 
        hs_mode <= '0';
        report ("9 bytes Write operation with repeated START - Case 19");
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("00001010");
        i2cm_nack_detect;


        hs_mode <= '1';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_HS_CLK_PERIOD/8;
        i2cm_hs_start_gen;

        i2cm_hs_byte_write("11110100");
        i2cm_hs_ack_detect;
        i2cm_hs_byte_write("10011001");
        i2cm_hs_ack_detect;

        i2cm_hs_byte_write("01001000");
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_byte_write("00001001");
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_byte_write("10001000");
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_byte_write("10001001");
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_byte_write("00001000");
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_start_gen;

        i2cm_hs_byte_write("11110100");
        i2cm_hs_ack_detect;
        i2cm_hs_byte_write("10011001");
        i2cm_hs_ack_detect;

        i2cm_hs_byte_write("00001000");
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_byte_write("00001001");
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_byte_write("10001000");
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_byte_write("10001001");
        i2cm_hs_ack_detect;

        clk_str_enable <= '1';
        wait until rising_edge(i2c_scl_tb);
        clk_str_enable <= '0';

        i2cm_hs_stop_gen;
        hs_mode <= '0'; 
        i2cm_hs_wait_cycle(250);

        report ("Reading back all the registers after slave read operation for 10 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(20);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);


        
        -------------------------------------------------------------------
        --Case 20: 8 bytes Master Read (with repeated START) 
        -------------------------------------------------------------------
         -- Writing to all registers (Parallel Data)

        report ("Writing to all registers for 10 bit addressing - slave write operation,High Speed Mode- case20");
        data_write("10110000", MODEREG_ADR);
        wait_cycle(5);
        data_write("10011000", SLAVE_ADRLSB);
        wait_cycle(5);
        data_write("11110100", SLAVE_ADRMSB);
        wait_cycle(5);
        data_write("10000111", CLK_STR_CNT_REG);
        wait_cycle(10);
        data_write(configuration_reg, CONFIG_REGADR);
        wait_cycle(10);


        -- Writing data to TX_FIFO
        for i in 1 to 8 loop
            data_write("01001010", TXFIFO_ADR);
            wait_cycle(10);
        end loop;


        -- Read operation
        report ("8 bytes read operation Case 20");
        hs_mode <= '0';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_CLK_PERIOD/8;
        i2cm_start_gen;

        i2cm_byte_write("00001010");
        i2cm_nack_detect;

        hs_mode <= '1';
        wait until rising_edge(i2c_scl_tb);
        wait for I2C_HS_CLK_PERIOD/8;
        i2cm_hs_start_gen;


        i2cm_hs_byte_write("11110100");
        i2cm_hs_ack_detect;
        i2cm_hs_byte_write("10011000");
        i2cm_hs_ack_detect;

        i2cm_hs_start_gen;
        i2cm_hs_byte_write("11110101");
        i2cm_hs_ack_detect;

        for i in 1 to 3 loop
            i2cm_hs_byte_read;
            i2cm_hs_ack_gen;
            
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;
       
        i2cm_hs_byte_read;
        i2cm_hs_nack_gen;

        i2cm_hs_start_gen;


        i2cm_hs_byte_write("11110101");
        i2cm_hs_ack_detect;

        for i in 1 to 3 loop
            i2cm_hs_byte_read;
            i2cm_hs_ack_gen;
            
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '1';
            wait until rising_edge(i2c_scl_tb);
            clk_str_enable <= '0';
            
        end loop;
       
        i2cm_hs_byte_read;
        i2cm_hs_nack_gen;

        i2cm_hs_stop_gen;
        hs_mode <= '0'; 
        i2cm_hs_wait_cycle(2500);

        report ("Reading back all the registers after slave write operation for 10 bit addressing");
        data_read(MODEREG_ADR);
        wait_cycle(5);
        data_read(SLAVE_ADRLSB);
        wait_cycle(5);
        data_read(SLAVE_ADRMSB);
        wait_cycle(5);
        data_read(CONFIG_REGADR);
        wait_cycle(5);
        data_read(CMD_STAT_ADR);
        wait_cycle(5);
        data_read(FIFO_STAT_ADR);
        wait_cycle(20);
        data_read(CLK_STR_CNT_REG);
        wait_cycle(10);

        
        -------------------------------------------------------------------     
        -- Reading from empty FIFO (After Data Transaction)
        -------------------------------------------------------------------  
        wait_cycle(10);
        report ("Reading from empty FIFO After Data Transaction");

        data_write("11000000", CONFIG_REGADR);
        wait_cycle(5);

        -- Reading from Read FIFO
        report ("Reading from RXFIFO");
        data_read(RXFIFO_ADR);
        wait_cycle(5);

        wait_cycle(20);

        test_done;
        wait;
    end process;

end i2cslave_asynch_proc_if_tb_arch;

