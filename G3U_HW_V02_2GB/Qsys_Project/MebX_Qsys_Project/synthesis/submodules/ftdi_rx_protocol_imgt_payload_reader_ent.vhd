library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_protocol_pkg.all;
use work.ftdi_protocol_crc_pkg.all;

entity ftdi_rx_protocol_imgt_payload_reader_ent is
	generic(
		g_DELAY_DWORD_CLKDIV : natural range 0 to 65535 := 0 -- [100 MHz / 1 = 100 MHz = 10 ns]
	);
	port(
		clk_i                         : in  std_logic;
		rst_i                         : in  std_logic;
		data_rx_stop_i                : in  std_logic;
		data_rx_start_i               : in  std_logic;
		imgt_payload_reader_abort_i   : in  std_logic;
		imgt_payload_reader_start_i   : in  std_logic;
		imgt_payload_reader_reset_i   : in  std_logic;
		imgt_payload_length_bytes_i   : in  std_logic_vector(31 downto 0);
		imgt_payload_dword_delay_i    : in  std_logic_vector(15 downto 0);
		rx_dc_data_fifo_rddata_data_i : in  std_logic_vector(31 downto 0);
		rx_dc_data_fifo_rddata_be_i   : in  std_logic_vector(3 downto 0);
		rx_dc_data_fifo_rdempty_i     : in  std_logic;
		rx_dc_data_fifo_rdfull_i      : in  std_logic;
		rx_dc_data_fifo_rdusedw_i     : in  std_logic_vector(11 downto 0);
		imgt_buffer_full_i            : in  std_logic;
		imgt_buffer_usedw_i           : in  std_logic_vector(8 downto 0);
		imgt_payload_reader_busy_o    : out std_logic;
		imgt_payload_crc32_match_o    : out std_logic;
		imgt_payload_eop_error_o      : out std_logic;
		rx_dc_data_fifo_rdreq_o       : out std_logic;
		imgt_buffer_wrdata_o          : out std_logic_vector(31 downto 0);
		imgt_buffer_sclr_o            : out std_logic;
		imgt_buffer_wrreq_o           : out std_logic
	);
end entity ftdi_rx_protocol_imgt_payload_reader_ent;

-- (Rx: FTDI => FPGA)

architecture RTL of ftdi_rx_protocol_imgt_payload_reader_ent is

	signal s_imgt_payload_length_cnt  : std_logic_vector(29 downto 0);
	signal s_imgt_payload_crc32       : std_logic_vector(31 downto 0);
	signal s_imgt_payload_crc32_match : std_logic;
	signal s_imgt_payload_eop_error   : std_logic;

	type t_ftdi_tx_prot_imgt_payload_reader_fsm is (
		STOPPED,                        -- imgt_payload reader stopped
		IDLE,                           -- imgt_payload reader in idle
		WAITING_RX_DATA_SOP,            -- wait until the rx fifo have data
		PAYLOAD_RX_START_OF_PAYLOAD,    -- parse a start of imgt_payload from the rx fifo (discard all data until a sop)
		WAITING_RX_READY,               -- wait until there is data to be fetched and space to write
		FETCH_RX_DWORD,                 -- fetch rx dword data (32b)
		WRITE_RX_DWORD,                 -- write rx dword data (32b)
		WAITING_DWORD_DELAY,            -- wait until the dword delay is finished
		WRITE_DELAY,                    -- write delay
		WAITING_RX_DATA_CRC,            -- wait until there is enough data in the rx fifo for the crc
		PAYLOAD_RX_PAYLOAD_CRC,         -- fetch and parse the imgt_payload crc to the rx fifo
		WAITING_RX_DATA_EOP,            -- wait until there is enough data in the rx fifo for the eop
		PAYLOAD_RX_END_OF_PAYLOAD,      -- fetch and parse a end of imgt_payload to the rx fifo
		PAYLOAD_RX_ABORT,               -- abort a imgt_payload receival (consume all data in the rx fifo)
		FINISH_PAYLOAD_RX               -- finish the imgt_payload read
	);

	signal s_ftdi_tx_prot_imgt_payload_reader_state : t_ftdi_tx_prot_imgt_payload_reader_fsm;

	signal s_rx_dword : std_logic_vector(31 downto 0);

	signal s_dword_delay_clear    : std_logic;
	signal s_dword_delay_trigger  : std_logic;
	signal s_dword_delay_busy     : std_logic;
	signal s_dword_delay_finished : std_logic;

begin

	dword_delay_block_ent_inst : entity work.delay_block_ent
		generic map(
			g_CLKDIV      => std_logic_vector(to_unsigned(g_DELAY_DWORD_CLKDIV, 16)),
			g_TIMER_WIDTH => imgt_payload_dword_delay_i'length
		)
		port map(
			clk_i            => clk_i,
			rst_i            => rst_i,
			clr_i            => s_dword_delay_clear,
			delay_trigger_i  => s_dword_delay_trigger,
			delay_timer_i    => imgt_payload_dword_delay_i,
			delay_busy_o     => s_dword_delay_busy,
			delay_finished_o => s_dword_delay_finished
		);

	p_ftdi_tx_prot_imgt_payload_reader : process(clk_i, rst_i) is
		variable v_ftdi_tx_prot_imgt_payload_reader_state : t_ftdi_tx_prot_imgt_payload_reader_fsm := STOPPED;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_ftdi_tx_prot_imgt_payload_reader_state <= STOPPED;
			v_ftdi_tx_prot_imgt_payload_reader_state := STOPPED;
			-- internal signals reset
			s_imgt_payload_length_cnt                <= (others => '0');
			s_imgt_payload_crc32_match               <= '0';
			s_imgt_payload_eop_error                 <= '0';
			s_dword_delay_clear                      <= '0';
			s_dword_delay_trigger                    <= '0';
			-- outputs reset
			imgt_payload_reader_busy_o               <= '0';
			s_imgt_payload_crc32                     <= (others => '0');
			imgt_payload_crc32_match_o               <= '0';
			imgt_payload_eop_error_o                 <= '0';
			rx_dc_data_fifo_rdreq_o                  <= '0';
			imgt_buffer_wrdata_o                     <= (others => '0');
			imgt_buffer_sclr_o                       <= '1';
			imgt_buffer_wrreq_o                      <= '0';
			s_rx_dword                               <= (others => '0');
		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_ftdi_tx_prot_imgt_payload_reader_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- imgt_payload reader stopped
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= STOPPED;
					v_ftdi_tx_prot_imgt_payload_reader_state := STOPPED;
					-- default internal signal values
					s_imgt_payload_length_cnt                <= (others => '0');
					s_imgt_payload_crc32_match               <= '0';
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if a start command was issued
					if (data_rx_start_i = '1') then
						s_ftdi_tx_prot_imgt_payload_reader_state <= IDLE;
						v_ftdi_tx_prot_imgt_payload_reader_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- imgt_payload reader in idle
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= IDLE;
					v_ftdi_tx_prot_imgt_payload_reader_state := IDLE;
					-- default internal signal values
					s_imgt_payload_length_cnt                <= (others => '0');
					s_imgt_payload_crc32_match               <= '0';
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if a imgt_payload writer start was issued
					if (imgt_payload_reader_start_i = '1') then
						s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_RX_DATA_SOP;
						v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_RX_DATA_SOP;
						if (unsigned(imgt_payload_length_bytes_i) >= 4) then
							-- 1 dword = 4 bytes
							s_imgt_payload_length_cnt <= imgt_payload_length_bytes_i(31 downto 2);
						else
							s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_RX_DATA_EOP;
							v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_RX_DATA_EOP;
						end if;
					end if;

				-- state "WAITING_RX_DATA_SOP"
				when WAITING_RX_DATA_SOP =>
					-- wait until the rx fifo have data
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_RX_DATA_SOP;
					v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_RX_DATA_SOP;
					-- default internal signal values
					s_imgt_payload_crc32_match               <= '0';
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if the rx dc data fifo is not empty 
					if (rx_dc_data_fifo_rdempty_i = '0') then
						s_ftdi_tx_prot_imgt_payload_reader_state <= PAYLOAD_RX_START_OF_PAYLOAD;
						v_ftdi_tx_prot_imgt_payload_reader_state := PAYLOAD_RX_START_OF_PAYLOAD;
					end if;

				-- state "PAYLOAD_RX_START_OF_PAYLOAD"
				when PAYLOAD_RX_START_OF_PAYLOAD =>
					-- parse a start of imgt_payload from the rx fifo (discard all data until a sop)
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_RX_DATA_SOP;
					v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_RX_DATA_SOP;
					-- default internal signal values
					s_imgt_payload_crc32_match               <= '0';
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if a start of package was detected
					if (rx_dc_data_fifo_rddata_data_i = c_FTDI_PROT_START_OF_PAYLOAD) then
						s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_RX_READY;
						v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_RX_READY;
					end if;

				-- state "WAITING_RX_READY"
				when WAITING_RX_READY =>
					-- wait until there is data to be fetched and space to write
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_RX_READY;
					v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_RX_READY;
					-- default internal signal values
					s_imgt_payload_crc32_match               <= '0';
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if the rx dc data fifo have data and the rx data buffer is not full 
					if (((rx_dc_data_fifo_rdfull_i = '1') or (rx_dc_data_fifo_rdusedw_i /= x"000")) and ((imgt_buffer_full_i = '0'))) then
						s_ftdi_tx_prot_imgt_payload_reader_state <= FETCH_RX_DWORD;
						v_ftdi_tx_prot_imgt_payload_reader_state := FETCH_RX_DWORD;
					end if;

				-- state "FETCH_RX_DWORD"
				when FETCH_RX_DWORD =>
					-- fetch rx dword data (32b)
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= WRITE_RX_DWORD;
					v_ftdi_tx_prot_imgt_payload_reader_state := WRITE_RX_DWORD;
					-- default internal signal values
					s_imgt_payload_crc32_match               <= '0';
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if there is still imgt_payload to be fetched
					if (unsigned(s_imgt_payload_length_cnt) > 1) then
						s_imgt_payload_length_cnt <= std_logic_vector(unsigned(s_imgt_payload_length_cnt) - 1);
					else
						s_imgt_payload_length_cnt <= std_logic_vector(to_unsigned(0, s_imgt_payload_length_cnt'length));
					end if;

				-- state "WRITE_RX_DWORD"
				when WRITE_RX_DWORD =>
					-- write rx dword data (32b)
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= WRITE_DELAY;
					v_ftdi_tx_prot_imgt_payload_reader_state := WRITE_DELAY;
					-- default internal signal values
					s_imgt_payload_crc32_match               <= '0';
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if a dword delay was specified
					if (imgt_payload_dword_delay_i /= std_logic_vector(to_unsigned(0, imgt_payload_dword_delay_i'length))) then
						-- a dword delay was specified
						s_dword_delay_trigger                    <= '1';
						s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_DWORD_DELAY;
						v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_DWORD_DELAY;
					end if;

				-- state "WAITING_DWORD_DELAY"
				when WAITING_DWORD_DELAY =>
					-- wait until the dword delay is finished
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_DWORD_DELAY;
					v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_DWORD_DELAY;
					-- default internal signal values
					s_imgt_payload_crc32_match               <= '0';
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if the dword delay is over
					if (s_dword_delay_finished = '1') then
						-- delay finished
						s_ftdi_tx_prot_imgt_payload_reader_state <= WRITE_DELAY;
						v_ftdi_tx_prot_imgt_payload_reader_state := WRITE_DELAY;
					end if;

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_RX_READY;
					v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_RX_READY;
					-- default internal signal values
					s_imgt_payload_crc32_match               <= '0';
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '1';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					if (unsigned(s_imgt_payload_length_cnt) = 0) then
						s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_RX_DATA_CRC;
						v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_RX_DATA_CRC;
						s_imgt_payload_length_cnt                <= (others => '0');
					end if;

				-- state "WAITING_RX_DATA_CRC"
				when WAITING_RX_DATA_CRC =>
					-- wait until there is enough data in the rx fifo for the crc
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_RX_DATA_CRC;
					v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_RX_DATA_CRC;
					-- default internal signal values
					s_imgt_payload_length_cnt                <= (others => '0');
					s_imgt_payload_crc32_match               <= '0';
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if there is data in the rx fifo for the crc
					if (rx_dc_data_fifo_rdempty_i = '0') then
						s_ftdi_tx_prot_imgt_payload_reader_state <= PAYLOAD_RX_PAYLOAD_CRC;
						v_ftdi_tx_prot_imgt_payload_reader_state := PAYLOAD_RX_PAYLOAD_CRC;
					end if;

				-- state "PAYLOAD_RX_PAYLOAD_CRC"
				when PAYLOAD_RX_PAYLOAD_CRC =>
					-- fetch and parse the imgt_payload crc to the rx fifo
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_RX_DATA_EOP;
					v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_RX_DATA_EOP;
					-- default internal signal values
					s_imgt_payload_length_cnt                <= (others => '0');
					s_imgt_payload_crc32_match               <= '0';
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if the received imgt_payload crc32 match the calculated crc32
					if (rx_dc_data_fifo_rddata_data_i = f_ftdi_protocol_finish_crc32(s_imgt_payload_crc32)) then
						s_imgt_payload_crc32_match <= '1';
					end if;

				-- state "WAITING_RX_DATA_EOP"
				when WAITING_RX_DATA_EOP =>
					-- wait until there is enough data in the rx fifo for the eop
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= WAITING_RX_DATA_EOP;
					v_ftdi_tx_prot_imgt_payload_reader_state := WAITING_RX_DATA_EOP;
					-- default internal signal values
					s_imgt_payload_length_cnt                <= (others => '0');
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if there is data in the rx fifo for the eop
					if (rx_dc_data_fifo_rdempty_i = '0') then
						s_ftdi_tx_prot_imgt_payload_reader_state <= PAYLOAD_RX_END_OF_PAYLOAD;
						v_ftdi_tx_prot_imgt_payload_reader_state := PAYLOAD_RX_END_OF_PAYLOAD;
					end if;

				-- state "PAYLOAD_RX_END_OF_PAYLOAD"
				when PAYLOAD_RX_END_OF_PAYLOAD =>
					-- fetch and parse a end of imgt_payload to the rx fifo
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= FINISH_PAYLOAD_RX;
					v_ftdi_tx_prot_imgt_payload_reader_state := FINISH_PAYLOAD_RX;
					-- default internal signal values
					s_imgt_payload_length_cnt                <= (others => '0');
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if a imgt_payload end of imgt_payload was not received
					if (rx_dc_data_fifo_rddata_data_i /= c_FTDI_PROT_END_OF_PAYLOAD) then
						s_imgt_payload_eop_error <= '1';
					end if;

				-- state "PAYLOAD_RX_ABORT"
				when PAYLOAD_RX_ABORT =>
					-- abort a imgt_payload receival (consume all data in the rx fifo)
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= PAYLOAD_RX_ABORT;
					v_ftdi_tx_prot_imgt_payload_reader_state := PAYLOAD_RX_ABORT;
					-- default internal signal values
					s_imgt_payload_crc32_match               <= '0';
					s_imgt_payload_eop_error                 <= '0';
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if the rx fifo is empty
					if (rx_dc_data_fifo_rdempty_i = '1') then
						-- rx fifo is empty, go to finish
						s_ftdi_tx_prot_imgt_payload_reader_state <= FINISH_PAYLOAD_RX;
						v_ftdi_tx_prot_imgt_payload_reader_state := FINISH_PAYLOAD_RX;
					end if;

				-- state "FINISH_PAYLOAD_RX"
				when FINISH_PAYLOAD_RX =>
					-- finish the imgt_payload read
					-- default state transition
					s_ftdi_tx_prot_imgt_payload_reader_state <= FINISH_PAYLOAD_RX;
					v_ftdi_tx_prot_imgt_payload_reader_state := FINISH_PAYLOAD_RX;
					-- default internal signal values
					s_imgt_payload_length_cnt                <= (others => '0');
					s_dword_delay_clear                      <= '0';
					s_dword_delay_trigger                    <= '0';
					-- conditional state transition
					-- check if a imgt_payload writer reset was issued
					if (imgt_payload_reader_reset_i = '1') then
						s_ftdi_tx_prot_imgt_payload_reader_state <= IDLE;
						v_ftdi_tx_prot_imgt_payload_reader_state := IDLE;
						s_imgt_payload_crc32_match               <= '0';
						s_imgt_payload_eop_error                 <= '0';
					end if;

				-- all the other states (not defined)
				when others =>
					s_ftdi_tx_prot_imgt_payload_reader_state <= STOPPED;
					v_ftdi_tx_prot_imgt_payload_reader_state := STOPPED;

			end case;

			-- check if a stop command was received
			if (data_rx_stop_i = '1') then
				s_ftdi_tx_prot_imgt_payload_reader_state <= STOPPED;
				v_ftdi_tx_prot_imgt_payload_reader_state := STOPPED;
			-- check if an abort was received and the header is not stopped or in idle or in abort or finished
			elsif ((imgt_payload_reader_abort_i = '1') and ((s_ftdi_tx_prot_imgt_payload_reader_state /= STOPPED) and (s_ftdi_tx_prot_imgt_payload_reader_state /= IDLE) and (s_ftdi_tx_prot_imgt_payload_reader_state /= PAYLOAD_RX_ABORT) and (s_ftdi_tx_prot_imgt_payload_reader_state /= FINISH_PAYLOAD_RX))) then
				s_ftdi_tx_prot_imgt_payload_reader_state <= PAYLOAD_RX_ABORT;
				v_ftdi_tx_prot_imgt_payload_reader_state := PAYLOAD_RX_ABORT;
			end if;

			-- Output generation FSM
			case (v_ftdi_tx_prot_imgt_payload_reader_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- imgt_payload reader stopped
					-- default output signals
					imgt_payload_reader_busy_o <= '0';
					s_imgt_payload_crc32       <= (others => '0');
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '0';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- imgt_payload reader in idle
					-- default output signals
					imgt_payload_reader_busy_o <= '0';
					s_imgt_payload_crc32       <= c_FTDI_PROT_CRC32_START;
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '0';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
				-- conditional output signals

				-- state "WAITING_RX_DATA_SOP"
				when WAITING_RX_DATA_SOP =>
					-- wait until the rx fifo have data
					-- default output signals
					imgt_payload_reader_busy_o <= '1';
					s_imgt_payload_crc32       <= c_FTDI_PROT_CRC32_START;
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '0';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
				-- conditional output signals

				-- state "PAYLOAD_RX_START_OF_PAYLOAD"
				when PAYLOAD_RX_START_OF_PAYLOAD =>
					-- parse a start of imgt_payload from the rx fifo (discard all data until a sop)
					-- default output signals
					imgt_payload_reader_busy_o <= '1';
					s_imgt_payload_crc32       <= c_FTDI_PROT_CRC32_START;
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '1';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
				-- conditional output signals

				-- state "WAITING_RX_READY"
				when WAITING_RX_READY =>
					-- wait until there is data to be fetched and space to write
					-- default output signals
					imgt_payload_reader_busy_o <= '1';
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '0';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
				-- conditional output signals

				-- state "FETCH_RX_DWORD"
				when FETCH_RX_DWORD =>
					-- fetch rx dword data (32b)
					-- default output signals
					imgt_payload_reader_busy_o <= '1';
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					rx_dc_data_fifo_rdreq_o    <= '1';
					s_rx_dword                 <= rx_dc_data_fifo_rddata_data_i;
				-- conditional output signals

				-- state "WRITE_RX_DWORD"
				when WRITE_RX_DWORD =>
					-- write rx dword data (32b)
					-- default output signals
					imgt_payload_reader_busy_o <= '1';
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '0';
					imgt_buffer_wrdata_o       <= s_rx_dword;
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '1';
					s_imgt_payload_crc32       <= f_ftdi_protocol_calculate_crc32_dword(s_imgt_payload_crc32, s_rx_dword);
				-- conditional output signals

				-- state "WAITING_DWORD_DELAY"
				when WAITING_DWORD_DELAY =>
					-- wait until the dword delay is finished
					-- default output signals
					imgt_payload_reader_busy_o <= '1';
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '0';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
				-- conditional output signals

				-- state "WRITE_DELAY"
				when WRITE_DELAY =>
					-- write delay
					-- default output signals
					imgt_payload_reader_busy_o <= '1';
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '0';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
				-- conditional output signals

				-- state "WAITING_RX_DATA_CRC"
				when WAITING_RX_DATA_CRC =>
					-- wait until there is enough data in the rx fifo for the crc
					-- default output signals
					imgt_payload_reader_busy_o <= '1';
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '0';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
				-- conditional output signals

				-- state "PAYLOAD_RX_PAYLOAD_CRC"
				when PAYLOAD_RX_PAYLOAD_CRC =>
					-- fetch and parse the imgt_payload crc to the rx fifo
					-- default output signals
					imgt_payload_reader_busy_o <= '1';
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '1';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
				-- conditional output signals

				-- state "WAITING_RX_DATA_EOP"
				when WAITING_RX_DATA_EOP =>
					-- wait until there is enough data in the rx fifo for the eop
					-- default output signals
					imgt_payload_reader_busy_o <= '1';
					s_imgt_payload_crc32       <= (others => '0');
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '0';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
				-- conditional output signals

				-- state "PAYLOAD_RX_END_OF_PAYLOAD"
				when PAYLOAD_RX_END_OF_PAYLOAD =>
					-- fetch and parse a end of imgt_payload to the rx fifo
					-- default output signals
					imgt_payload_reader_busy_o <= '1';
					s_imgt_payload_crc32       <= (others => '0');
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '1';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
				-- conditional output signals

				-- state "PAYLOAD_RX_ABORT"
				when PAYLOAD_RX_ABORT =>
					-- abort a imgt_payload receival (consume all data in the rx fifo)
					-- default output signals
					imgt_payload_reader_busy_o <= '1';
					s_imgt_payload_crc32       <= (others => '0');
					imgt_payload_crc32_match_o <= '0';
					imgt_payload_eop_error_o   <= '0';
					rx_dc_data_fifo_rdreq_o    <= '1';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
				-- conditional output signals

				-- state "FINISH_PAYLOAD_RX"
				when FINISH_PAYLOAD_RX =>
					-- finish the imgt_payload read
					-- default output signals
					imgt_payload_reader_busy_o <= '0';
					s_imgt_payload_crc32       <= (others => '0');
					imgt_payload_crc32_match_o <= s_imgt_payload_crc32_match;
					imgt_payload_eop_error_o   <= s_imgt_payload_eop_error;
					rx_dc_data_fifo_rdreq_o    <= '0';
					imgt_buffer_wrdata_o       <= (others => '0');
					imgt_buffer_sclr_o         <= '0';
					imgt_buffer_wrreq_o        <= '0';
					s_rx_dword                 <= (others => '0');
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_tx_prot_imgt_payload_reader;

end architecture RTL;
