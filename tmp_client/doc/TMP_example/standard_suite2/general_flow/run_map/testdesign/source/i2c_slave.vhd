----------------------------------------------------------------------------------------------------
-- Title      : I2C Slave
-- Project    : I2CSlave_Async_Proc_IF
----------------------------------------------------------------------------------------------------
-- File       : i2c_slave.vhd
-- Author     : GRJ
-- Company    : SiliconBlue Tech.
-- Last update: 03Jul2010
----------------------------------------------------------------------------------------------------
-- Description                          -- I2C Slave module.
-- Sequence of operation.

-- 7 bit addressing Multibyte
-- Slave WRITE Procedure

-- 1. I2C Master initiates data transation by sending START pulse
-- 2. I2C Master sends Address & read/write mode(1)) for Reading from I2C Slave.(Address configurable
-- through package)
-- 3. I2C Slave Acknowledges Master's request and sends a Byte on SDA line.
-- 4. Master acknowledges read by sending a LOW on 9th SCL pulse
-- 5. Repeat (3) and (4) for multiple byte reading from Slave.
-- When the Master generates Not Acknowledge the transaction stops.

-- Slave READ Procedure
-- 1. I2C Master initiates data transation by sending START pulse.
-- 2. I2C Master sends Address & read/write mode(0)) for Writing to I2C Slave.(Address configurable
-- through package)
-- 3. I2C Slave Acknowledges Master's request and receives a byte on SDA line.
-- 4. Master sends a byte and Slave acknowleges by sending a LOW on 9th SCL pulse
-- 5. Repeat (3) and (4) for multiple byte writing to Slave.
-- When the Master issues STOP signal transaction stops.

-- 7 /10 bit addressing Repeated Start
-- When the Master is Writing the data, if it wants to repeat the transaction, then it sends
-- START signal again followed by either 7 bit or 10 bit address and transaction repeats.
-- When the Slave is writing the data, if the Slave receives Not Write Acknowledge instead of
-- Acknowledge then FSM enters into bus_idle state and Master can again restart the transaction
-- by sending START signal again followed by the address.

-- 10 bit addressing Multibyte
-- Slave READ Procedure

-- 1. I2C Master initiates data transation by sending START pulse.
-- 2. I2C Master sends Address(MSB) (Address configurable through package) & write mode(0)
-- for Writing to I2C Slave.
-- 3. I2C Slave Acknowledges Master's request.
-- 4. I2C Master sends Lower 8 bits of address (Address configurable through package).
-- 5. I2C Slave Acknowledges Master's request.
-- 6. Master sends a byte and Slave acknowleges by sending a LOW on 9th SCL pulse.
-- 7. Repeat (6) for multiple byte writing to Slave.
-- When the Master issues STOP signal transaction stops.

-- Slave WRITE Procedure

-- 1. I2C Master initiates data transation by sending START pulse.
-- 2. I2C Master sends Address(MSB) (Address configurable through package) & write mode(0).
-- 3. I2C Slave Acknowledges Master's request.
-- 4. I2C Master sends Lower 8 bits of address (Address configurable through package).
-- 5. I2C Slave Acknowledges Master's request.
-- 6. I2C Master again sends START pulse.
-- 7. I2C Master sends Address (MSB) again & read mode(1)).
-- 8. I2C Slave Acknowledges Master's request.
-- 9. Slave sends a byte and Master acknowledges by sending a LOW on 9th SCL pulse.
--10. Repeat (9) for multiple byte reading from Slave.
--11. When the Master generates Not Acknowledge the transaction stops.

-- High Speed Mode Design

-- 1. When the Master wants to operate in High Speed Mode, it first sends 8 bits Master code
-- Here, it is set as "00001010".
-- 2. On detection of Master code, Slave sends Not Acknowledge signal to Master and goes back to
-- Bus Idle state and waits for Repeated START issued by the Master.
-- After this the process of Data Transaction is same as the other modes.
--

-- Asynchronous Parallel Processor Interface

-- When the Master WRITEs the data, Slave stores it in Databuffer and sends it to RXFIFO
-- through o_rxfifo_wrdata by issuing o_rxfifo_wren.
-- When the Master wants to READs data ,Slave issues o_txfifo_rden to TXFIFO and
-- gets the data through i_txfifo_rddata. This is then transferred serially over the SDA line
-- When i_config_latch_en becomes HIGH, data from i_data_in bus is wriiten to 3 registers -
-- Mode register,Slave Address LSB Register and Slave Address MSB Registers.


----------------------------------------------------------------------------------------------------
-- Revisions :
-- Date Version Author Description
-- 26Nov09 1.0 GRJ Created
--------------------------------------------------------------------------------------------------
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


entity i2c_slave is
  port(
    i_rst             : in    std_logic;
    io_scl            : inout std_logic;
    i_clk             : in    std_logic;
    io_sda            : inout std_logic;
    i_data_in         : in    std_logic_vector(7 downto 0);
    i_config_latch_en : in    std_logic;
    i_txfifo_rddata   : in    std_logic_vector(7 downto 0);
    i_rxfifo_full     : in    std_logic;
    o_rxfifo_wrdata   : out   std_logic_vector(7 downto 0);
    o_tx_done         : out   std_logic;
    o_rx_done         : out   std_logic;
    o_busy            : out   std_logic;
    o_rxfifo_wren     : out   std_logic;
    o_txfifo_rden     : out   std_logic
   -- o_sda             : out   std_logic
    );
end i2c_slave;

architecture i2c_slave_rtl of i2c_slave is


  signal sda_data_i, sda_wr_data_i, start_detect_i, stop_detect_i, sda_int_i : std_logic;
  signal reset_bus_i, read_ack_i, write_ack_i, rw_mode_i                     : std_logic;
  signal count_i                                                             : integer range 0 to 8;
  signal data_buffer_i                                                       : std_logic_vector(8 downto 0);

  type bus_states is (bus_idle, read_addr_byte1_state, read_addr_byte2_state, repeat_sr_detect_state,
                      repeat_addr_byte1_state, read_data_state, write_data_state,dummy_state);
  signal current_state_i, next_state_i : bus_states;

  signal not_write_ack_i                    : std_logic;
  signal addr_ack_byte2_i, addr_ack_byte1_i : std_logic;
  signal repeat_addr_ack_byte1_i            : std_logic;

  signal slave_addr_lsb_reg : std_logic_vector(7 downto 0);
  signal slave_addr_msb_reg : std_logic_vector(7 downto 0);
  signal mode_reg           : std_logic_vector(7 downto 0);
  signal clk_str_cnt_reg    : std_logic_vector(7 downto 0);

  signal tx_done_i, rx_done_i, busy_i, rxfifo_wren_i, rxfifo_wren_reg_i : std_logic;
  signal rxfifo_wrdata_i                                                : std_logic_vector( 7 downto 0);

  signal counter_i, counter_reg_i            : std_logic_vector(1 downto 0) := "00";
  signal transaction_done, config_latch_en_i : std_logic;
  signal config_latch_en1_i                  : std_logic;
  signal duplicate_txfifo_rden_i             : std_logic;
  signal txfifo_rden1_i, txfifo_rden_i       : std_logic;

  signal mastercode_not_ack_i : std_logic;


  signal scl_i : std_logic;

  type clk_stretch_states is (idle_state, clk_stretch_en_state,wait_state);
  signal nextstate_i : clk_stretch_states;

  signal cnt_i        : integer;
  signal clk_str_en_i : std_logic;

  signal read_ack_pulse_i  : std_logic;
  signal write_ack_pulse_i : std_logic;
  signal read_ack_reg1     : std_logic;
  signal read_ack_reg2     : std_logic;
  signal write_ack_reg1    : std_logic;
  signal write_ack_reg2    : std_logic;

  signal read_ack_pulse1_i  : std_logic;
  signal write_ack_pulse1_i : std_logic;

  signal clk_str_wr_i  : std_logic;
  signal clk_str_en1_i : std_logic;

  signal read_ack_temp_i : std_logic;
  signal write_ack_temp_i : std_logic;

--   signal rden : std_logic;
  --  signal wr_ack : std_logic;
  signal wrack : std_logic;

begin

       
  scl_i <= io_scl;

  transaction_done <= tx_done_i and rx_done_i;
  sda_int_i        <= io_sda;


  o_rxfifo_wrdata <= rxfifo_wrdata_i;
  rxfifo_wrdata_i <= data_buffer_i(8 downto 1);

  -- Start Detection
  process(sda_int_i, reset_bus_i, i_rst)
  begin
    if (reset_bus_i = '1' or i_rst = '1') then
      start_detect_i   <= '0';
    elsif (sda_int_i'event and sda_int_i = '0') then
      if (scl_i = '1') then
        start_detect_i <= '1';
      else
        start_detect_i <= '0';
      end if;
    end if;
  end process;

  -- Stop Detection
  process(sda_int_i, reset_bus_i, i_rst)
  begin
    if (reset_bus_i = '1' or i_rst = '1') then
      stop_detect_i   <= '0';
    elsif (sda_int_i'event and sda_int_i = '1') then
      if (scl_i = '1') then
        stop_detect_i <= '1';
      else
        stop_detect_i <= '0';
      end if;
    end if;
  end process;

  process(scl_i, i_rst)
  begin
    if (i_rst = '1') then
      rxfifo_wren_reg_i <= '0';
    elsif(scl_i'event and scl_i = '0') then
      rxfifo_wren_reg_i <= rxfifo_wren_i;
    end if;
  end process;


  o_tx_done <= tx_done_i;
  o_rx_done <= rx_done_i;
  o_busy    <= busy_i;


  busy_i <= '1' when (next_state_i = read_data_state and count_i >= 0) or
            (next_state_i = write_data_state and (write_ack_i = mode_reg(5) or count_i >= 0))
            else '0';


  -- Main Slave FSM. Operates on SCL falling edge so that data on SDA line is stable 
  -- when SCL HIGH.
  process (scl_i, i_rst)
  begin
    if (i_rst = '1') then
      sda_wr_data_i                <= '1';
      next_state_i                 <= bus_idle;
      count_i                      <= 0;
      reset_bus_i                  <= '0';
      tx_done_i                    <= '1';
      rx_done_i                    <= '1';
      rxfifo_wren_i                <= '0';
    elsif (falling_edge(scl_i)) then
      sda_wr_data_i                <= '1';
      rxfifo_wren_i                <= '0';
      tx_done_i                    <= '1';
      rx_done_i                    <= '1';
      case (next_state_i) is
        when bus_idle                =>
          if (start_detect_i = '1') then
            reset_bus_i            <= '1';
            count_i                <= 8;
            next_state_i           <= read_addr_byte1_state;
            data_buffer_i(count_i) <= sda_int_i;
          elsif (stop_detect_i = '1') then
            reset_bus_i            <= '1';
            count_i                <= 0;
            next_state_i           <= bus_idle;
          else
            reset_bus_i            <= '0';
            count_i                <= 0;
            next_state_i           <= bus_idle;
          end if;
        when read_addr_byte1_state   =>
          reset_bus_i              <= '0';
          --7 bit address matches and Master wants to write
          if (addr_ack_byte1_i = '1' and rw_mode_i = '0' and mode_reg(7) = '0')then
            next_state_i           <= read_data_state;
            reset_bus_i            <= '0';
            count_i                <= 8;
            data_buffer_i(count_i) <= sda_int_i;
            -- 7 bit address matches and Master wants to read
          elsif (addr_ack_byte1_i = '1' and rw_mode_i = '1' and mode_reg(7) = '0') then
            next_state_i           <= write_data_state;
            reset_bus_i            <= '0';
            count_i                <= 8;
            sda_wr_data_i          <= i_txfifo_rddata(7);
            -- 10 bit address matches and RW_MODE = 0
          elsif (addr_ack_byte1_i = '1' and rw_mode_i = '0' and mode_reg(7) = '1') then
            next_state_i           <= read_addr_byte2_state;
            reset_bus_i            <= '0';
            count_i                <= 8;
            data_buffer_i(count_i) <= sda_int_i;
            -- 10 bit address matches and RW_MODE = 1
          elsif (addr_ack_byte1_i = '1' and rw_mode_i = '1' and mode_reg(7) = '1') then
            next_state_i           <= write_data_state;
            reset_bus_i            <= '0';
            count_i                <= 8;
            sda_wr_data_i          <= i_txfifo_rddata(7);
            -- Check for Master code not ack for High Speed Mode  
          elsif (mastercode_not_ack_i = '1') then
            next_state_i           <= bus_idle;
            reset_bus_i            <= '0';
            count_i                <= 0;
            data_buffer_i(count_i) <= sda_int_i;
          elsif count_i = 0 then
            next_state_i           <= bus_idle;
          else
            next_state_i           <= read_addr_byte1_state;
            count_i                <= count_i - 1;
            reset_bus_i            <= '0';
            data_buffer_i(count_i) <= sda_int_i;
          end if;
          --  For 10 bit addressing, Check lower byte of address
        when read_addr_byte2_state   =>
          reset_bus_i              <= '0';
          -- If the lower address matches
          if (addr_ack_byte2_i = '1') then
            next_state_i           <= repeat_sr_detect_state;
            reset_bus_i            <= '0';
            count_i                <= 8;
            data_buffer_i(count_i) <= sda_int_i;
          elsif count_i = 0 then
            next_state_i           <= bus_idle;
          else
            next_state_i           <= read_addr_byte2_state;
            count_i                <= count_i - 1;
            reset_bus_i            <= '0';
            data_buffer_i(count_i) <= sda_int_i;
          end if;
          -- If there is repeated START condition
        when repeat_sr_detect_state  =>
          if (start_detect_i = '1') then
            next_state_i           <= repeat_addr_byte1_state;
            reset_bus_i            <= '1';
            count_i                <= 8;
            data_buffer_i(count_i) <= sda_int_i;
          else
            count_i                <= count_i - 1;
            data_buffer_i(count_i) <= sda_int_i;
            next_state_i           <= read_data_state;
          end if;
          -- Check the upper byte of address once again
        when repeat_addr_byte1_state =>
          -- If the upper byte matches and RW_MODE =1
          if (repeat_addr_ack_byte1_i = '1' and rw_mode_i = '1') then
            next_state_i           <= write_data_state;
            reset_bus_i            <= '0';
            count_i                <= 8;
            sda_wr_data_i          <= i_txfifo_rddata(7);
          elsif (count_i = 0) then
            next_state_i           <= bus_idle;
          else
            next_state_i           <= repeat_addr_byte1_state;
            count_i                <= count_i - 1;
            reset_bus_i            <= '0';
            data_buffer_i(count_i) <= sda_int_i;
          end if;
        when read_data_state         =>
          -- Until STOP condition is generated
          -- continuously read Data
          rxfifo_wren_i            <= '0';
          if (stop_detect_i = '1') then
            next_state_i           <= bus_idle;
            count_i                <= 0;
            rx_done_i              <= '1';
            rxfifo_wren_i          <= '0';
          elsif (start_detect_i = '1') then
            reset_bus_i            <= '1';
            count_i                <= 8;
            next_state_i           <= read_addr_byte1_state;
            data_buffer_i(count_i) <= sda_int_i;
          elsif count_i = 0 then
            rxfifo_wren_i          <= '1';
            next_state_i           <= read_data_state;
            count_i                <= 8;
            reset_bus_i            <= '0';
            data_buffer_i(count_i) <= sda_int_i;
            rx_done_i              <= '0';
          else
            next_state_i           <= read_data_state;
            count_i                <= count_i - 1;
            data_buffer_i(count_i) <= sda_int_i;
            rx_done_i              <= '0';
            rxfifo_wren_i          <= '0';
          end if;
        when write_data_state        =>
          -- As long as Not Write Acknowledgement comes continuously
          -- write Data
          if (not_write_ack_i = mode_reg(4)) then
            next_state_i           <= bus_idle;
            reset_bus_i            <= '0';
            count_i                <= 0;
            tx_done_i              <= '1';
          elsif (write_ack_i = mode_reg(5)) then
            next_state_i           <= dummy_state;--write_data_state;
            count_i                <= 0;--8;
            reset_bus_i            <= '0';
          --  sda_wr_data_i          <= i_txfifo_rddata(7);
            tx_done_i              <= '0';
          elsif count_i = 0 then
            next_state_i           <= write_data_state;
            
          else
            next_state_i           <= write_data_state;
            count_i                <= count_i - 1;
            if (count_i > 1) then
              sda_wr_data_i        <= i_txfifo_rddata(count_i - 2);
              tx_done_i            <= '0';
            end if;
          end if;
        when dummy_state =>
          next_state_i <= write_data_state;
          count_i <= 8;
          reset_bus_i <= '0';
          sda_wr_data_i <= i_txfifo_rddata(7);
          tx_done_i <= '0';

        when others =>
          next_state_i <= bus_idle;
          reset_bus_i  <= '0';
      end case;
    end if;
  end process;

  process(i_clk, i_rst)
  begin
    if (i_rst = '1') then
      config_latch_en_i <= '0';
    elsif (i_clk'event and i_clk = '1') then
      config_latch_en_i <= i_config_latch_en;
    end if;
  end process;

  config_latch_en1_i <= config_latch_en_i or i_config_latch_en;


  -- When config_latch_en1_i is HIGH, as the counter advances, store the data from 
  -- i_data_in bus into Mode Register,Slave Address LSB Register and Slave Address MSB Registers.
  process (i_clk, i_rst)
  begin
    if (i_rst = '1') then
      slave_addr_lsb_reg       <= (others => '0');
      slave_addr_msb_reg       <= (others => '0');
      mode_reg                 <= (others => '0');
      clk_str_cnt_reg          <= (others => '0');
    elsif (i_clk'event and i_clk = '1') then
      if (config_latch_en1_i = '1')then
        case counter_i is
          when "00"                       =>
            mode_reg           <= i_data_in(7 downto 0);
          when "01"                       =>
            slave_addr_lsb_reg <= i_data_in(7 downto 0);
          when "10"                       =>
            slave_addr_msb_reg <= i_data_in(7 downto 0);
          when "11"                       =>
            clk_str_cnt_reg    <= i_data_in(7 downto 0);
          when others                     => null;
        end case;
      end if;
    end if;
  end process;

  -- Start the counter when i_config_latch_en is HIGH.
  process (i_clk, i_rst)
  begin
    if (i_rst = '1') then
      counter_i     <= "00";
    elsif (i_clk'event and i_clk = '1') then
      counter_reg_i <= counter_i;
      if (i_config_latch_en = '1') then
        if (counter_i = "11") then
          counter_i <= (others => '1');
        else
          counter_i <= counter_i + '1';
        end if;
      else
        counter_i   <= (others => '0');
      end if;
    end if;
  end process;


  -- Generation of TXFIFO RDEN 
  process (scl_i, i_rst)
  begin
    if (i_rst = '1') then
      duplicate_txfifo_rden_i   <= '0';
    elsif (scl_i'event and scl_i = '1') then
      if (next_state_i = read_addr_byte1_state and
          data_buffer_i(8 downto 2) = slave_addr_lsb_reg(7 downto 1)
          and count_i = 0 and mode_reg(7) = '0' and data_buffer_i(1) = '1') then
        duplicate_txfifo_rden_i <= '1';
      elsif (next_state_i = repeat_addr_byte1_state and
             data_buffer_i(8 downto 2) = slave_addr_msb_reg(7 downto 1) and count_i = 0
             and data_buffer_i(1) = '1') then
        duplicate_txfifo_rden_i <= '1';
      elsif (next_state_i = write_data_state and count_i = 0 and sda_int_i = not mode_reg(5) and clk_str_en_i = '0' ) then
        duplicate_txfifo_rden_i <= '1';
      else
        duplicate_txfifo_rden_i <= '0';
      end if;
    end if;
  end process;

   wrack_proc: process (scl_i, i_rst)
   begin  -- process rden
     if i_rst = '1' then                 -- asynchronous reset (active low)
       wrack <= '0';
     elsif scl_i'event and scl_i = '1' then  -- rising clock edge
       wrack <= write_ack_i;
     end if;
   end process wrack_proc;

  process (i_clk, i_rst)
  begin  -- process
    if i_rst = '1' then                     -- asynchronous reset (active high)
      txfifo_rden_i  <= '0';
      txfifo_rden1_i <= '0';
    elsif i_clk'event and i_clk = '1' then  -- rising clock edge
      txfifo_rden_i  <= duplicate_txfifo_rden_i;
      txfifo_rden1_i <= txfifo_rden_i;
    end if;
  end process;

  o_txfifo_rden <= txfifo_rden_i and not txfifo_rden1_i;
  o_rxfifo_wren <= rxfifo_wren_i;

  --  Generate control signals
  process (scl_i, reset_bus_i, i_rst)
  begin
    if (reset_bus_i = '1' or i_rst = '1') then
      addr_ack_byte1_i          <= '0';
      addr_ack_byte2_i          <= '0';
      read_ack_i                <= '0';
      write_ack_i               <= '0';
      not_write_ack_i           <= '0';
      rw_mode_i                 <= '0';
      repeat_addr_ack_byte1_i   <= '0';
      mastercode_not_ack_i      <= '0';
      read_ack_temp_i           <= '0';
      write_ack_temp_i          <= '0';
    elsif (rising_edge(scl_i)) then
      addr_ack_byte1_i          <= '0';
      addr_ack_byte2_i          <= '0';
      write_ack_i               <= '0';
      not_write_ack_i           <= '0';
      repeat_addr_ack_byte1_i   <= '0';
      mastercode_not_ack_i      <= '0';
      read_ack_temp_i           <= '0';
      write_ack_temp_i          <= '0';
      if (next_state_i = read_addr_byte1_state and count_i = 0) then
        rw_mode_i               <= data_buffer_i(1);
      end if;
      if (next_state_i = repeat_addr_byte1_state and count_i = 0) then
        rw_mode_i               <= data_buffer_i(1);
      end if;
      if (next_state_i = write_data_state and count_i = 0 and sda_int_i = '0') then
        write_ack_i             <= mode_reg(5);
        write_ack_temp_i        <= '1';
        not_write_ack_i         <= not mode_reg(4);
      elsif (next_state_i = write_data_state and count_i = 0 and sda_int_i = '1') then
        write_ack_i             <= not mode_reg(5);
        not_write_ack_i         <= mode_reg(4);
      end if;
       if (next_state_i = read_addr_byte1_state and
           data_buffer_i(8 downto 2) = slave_addr_lsb_reg(7 downto 1) and count_i = 0 and
           mode_reg(7) = '0' ) or (next_state_i = read_addr_byte1_state and
                                   data_buffer_i(8 downto 2) = slave_addr_msb_reg(7 downto 1) and count_i = 0
                                   and mode_reg(7) = '1') then
         addr_ack_byte1_i        <= '1';
       else
         addr_ack_byte1_i        <= '0';
       end if;
      if (next_state_i = repeat_addr_byte1_state and
          data_buffer_i(8 downto 2) = slave_addr_msb_reg(7 downto 1) and count_i = 0) then
        repeat_addr_ack_byte1_i <= '1';
      else
        repeat_addr_ack_byte1_i <= '0';
      end if;
      if (next_state_i = read_addr_byte2_state and
          (data_buffer_i(8 downto 1) = slave_addr_lsb_reg) and count_i = 0) then
        addr_ack_byte2_i        <= '1';
      else
        addr_ack_byte2_i        <= '0';
      end if;
      if (next_state_i = read_data_state and count_i = 0) then
        if i_rxfifo_full = '1' then
          read_ack_i            <= mode_reg(6);
          read_ack_temp_i       <= '1';
        else
          read_ack_i            <= '0';
          read_ack_temp_i       <= '1';
        end if;
      end if;
      if next_state_i = read_addr_byte1_state and
        data_buffer_i(8 downto 1) = MASTER_CODE and count_i = 0 then
        mastercode_not_ack_i    <= '1';
      else
        mastercode_not_ack_i    <= '0';
      end if;
    end if;
  end process;


--   process (i_clk, i_rst)
--   begin  -- process
--     if i_rst = '0' then                 -- asynchronous reset (active low)
--         wr_ack <= '0';
--     elsif i_clk'event and i_clk = '1' then  -- rising clock edge
--         wr_ack <= write_ack_temp_i;
--     end if;
--   end process;

  process (i_clk, i_rst)
  begin
    if (i_rst = '1') then
      read_ack_reg1  <= '1';
      read_ack_reg2  <= '1';
      write_ack_reg1 <= '1';
      write_ack_reg2 <= '1';
    elsif (i_clk'event and i_clk = '1') then
      read_ack_reg1  <= read_ack_temp_i;--read_ack_i;
      read_ack_reg2  <= read_ack_reg1;
      write_ack_reg1 <= write_ack_temp_i;--write_ack_i;
      write_ack_reg2 <= write_ack_reg1;
    end if;
  end process;

  read_ack_pulse_i  <= read_ack_reg1 and not read_ack_reg2;
  write_ack_pulse_i <= write_ack_i and not write_ack_reg1;
 -- clk_str_wr_i      <= write_ack_pulse_i;

  read_ack_pulse1_i <= read_ack_reg1 and not read_ack_reg2;

  process (i_clk, i_rst)
  begin
    if (i_rst = '1') then
      write_ack_pulse1_i <= '0';
    elsif (i_clk'event and i_clk = '1') then
      write_ack_pulse1_i <= write_ack_pulse_i;
    end if;
  end process;

 -- FSM for enabling Clock Stretching
  process (i_clk, i_rst)
  begin
    if (i_rst = '1') then
      clk_str_en1_i       <= '0';
      cnt_i               <= 0;
      clk_str_wr_i        <= '0';
    elsif (i_clk = '1' and i_clk'event) then
      case nextstate_i is
        when idle_state           =>
          cnt_i           <= 0;
          clk_str_en1_i   <= '0';
          if (read_ack_pulse_i = '1') then
            nextstate_i   <= clk_stretch_en_state;
            clk_str_en1_i <= '1';
          elsif (write_ack_pulse_i = '1') then
            nextstate_i   <= clk_stretch_en_state;
            clk_str_en1_i <= '1';
            clk_str_wr_i  <= '1';
          else
            nextstate_i   <= idle_state;
          end if;
        when clk_stretch_en_state =>
          if (cnt_i /= conv_integer(clk_str_cnt_reg) ) then
            cnt_i         <= cnt_i + 1;
            clk_str_en1_i <= '1';
            nextstate_i   <= clk_stretch_en_state;
            clk_str_wr_i  <= '1';
          else
            clk_str_en1_i <= '0';
            cnt_i         <= 0;
            nextstate_i   <= wait_state;  -- idle_state;
            clk_str_wr_i  <= '0';
          end if;
        when wait_state           =>
          if (read_ack_i = '1' or write_ack_i = '1') then
            nextstate_i   <= wait_state;
            clk_str_en1_i <= '0';
          else
            nextstate_i   <= idle_state;

          end if;
        when others =>
          clk_str_en1_i <= '0';
          cnt_i         <= 0;
      end case;
    end if;
  end process;


 -- Generate Address Acknowledge and Read acknowledge from Slave
--   sda_data_i <= read_ack_i when (next_state_i = read_addr_byte1_state and addr_ack_byte1_i <= '1'
--                                  and count_i = 0) or (next_state_i = read_addr_byte2_state and
--                                                       addr_ack_byte2_i <= '1' and count_i = 0) or
--                 (next_state_i = repeat_addr_byte1_state and
--                  repeat_addr_ack_byte1_i <= '1' and count_i = 0)
--                 or (next_state_i = read_data_state and count_i = 0)
--                 else not read_ack_i;
  
   -- Generate Address Acknowledge and Read acknowledge from Slave
   sda_data_i <= '0' when (next_state_i = read_addr_byte1_state and count_i = 0) else
                 '0' when (next_state_i = read_addr_byte2_state and count_i = 0) else
                 '0' when (next_state_i = repeat_addr_byte1_state and count_i = 0) else
                  read_ack_i  when (next_state_i = read_data_state and count_i = 0)
                 else '1';--not read_ack_i;

  

--     ack_gen: process (scl_i, i_rst)
--     begin  -- process ack_gen
--         if i_rst = '1' then                 -- asynchronous reset (active low)
--             sda_data_i <= '1';
--         elsif scl_i'event and scl_i = '0' then  -- rising clock edge
--             if (next_state_i = read_addr_byte1_state and addr_ack_byte1_i = '1' and count_i = 1) then
--                 sda_data_i <= '0';--addr_ack_byte1_i;--read_ack_i;
--             elsif (next_state_i = read_addr_byte2_state and addr_ack_byte2_i = '1' and count_i = 0) then
--                 sda_data_i <= '0';--addr_ack_byte2_i ;--read_ack_i;
--             elsif (next_state_i = repeat_addr_byte1_state and repeat_addr_ack_byte1_i = '1' and count_i = 0) then
--                 sda_data_i <= '0';--repeat_addr_ack_byte1_i ;-- read_ack_i;
--             elsif (next_state_i = read_data_state and count_i = 0) then
--                 sda_data_i <= read_ack_i;
--             else
--                 sda_data_i <=  '1';
--             end if;   
--         end if;
--     end process ack_gen;



  -- SDA signal generation logic
  io_sda <= '0' when sda_data_i = '0' or sda_wr_data_i = '0' else
           'Z';

  
  clk_str_en_i <= read_ack_i or clk_str_wr_i when clk_str_en1_i = '1'                     else
                  '0';

  
--   clk_str_en: process (clk_str_en1_i)
--   begin  -- process clk_str_en
--        if clk_str_en1_i = '1' then
--            clk_str_en_i <= read_ack_i or clk_str_wr_i;
--        else
--          clk_str_en_i <= '0';
--        end if;
--   end process clk_str_en;

  

  io_scl <= 'Z' when clk_str_en_i = '0' else
                  '0';

end i2c_slave_rtl;
