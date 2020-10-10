library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_crc_pkg.all;
use work.fee_data_controller_pkg.all;
use work.comm_data_transmitter_pkg.all;

entity comm_data_transmitter_crc_ent is
	port(
		clk_i                  : in  std_logic;
		rst_i                  : in  std_logic;
		comm_stop_i            : in  std_logic;
		comm_start_i           : in  std_logic;
		spw_tx_trans_control_i : in  t_comm_data_trans_spw_tx_control;
		spw_tx_codec_status_i  : in  t_comm_data_trans_spw_tx_status;
		spw_tx_trans_status_o  : out t_comm_data_trans_spw_tx_status;
		spw_tx_codec_control_o : out t_comm_data_trans_spw_tx_control
	);
end entity comm_data_transmitter_crc_ent;

architecture RTL of comm_data_transmitter_crc_ent is

	type t_comm_data_transmitter_crc_fsm is (
		STOPPED,                        -- data transmitter is stopped
		IDLE,                           -- data transmitter is in idle
		WAIT_HEADER_TRANS_FINISH,       -- wait the header transmission to finish
		WAITING_SPW_READY_HEADER_CRC,   -- wait spw to be ready for a header crc transmission
		TRANSMIT_SPW_HEADER_CRC,        -- transmit header crc on the spw
		WAIT_DATA_TRANS_FINISH,         -- wait the data transmission to finish
		WAITING_SPW_READY_DATA_CRC,     -- wait spw to be ready for a data crc transmission
		TRANSMIT_SPW_DATA_CRC,          -- transmit data crc on the spw
		FINISHED                        -- data transmitter is finished
	);

	signal s_comm_data_transmitter_crc_state : t_comm_data_transmitter_crc_fsm;

	-- header counter
	signal s_header_cnt             : natural range 0 to c_PKT_HEADER_SIZE_NUMERIC;
	-- header data
	signal s_data_length_cnt        : unsigned(15 downto 0);
	constant c_DATA_LENGTH_FINISHED : unsigned((s_data_length_cnt'length - 1) downto 0) := x"0001";

	signal s_header_crc : std_logic_vector(7 downto 0);
	signal s_data_crc   : std_logic_vector(7 downto 0);

	signal s_crc_spw_tx_control : t_comm_data_trans_spw_tx_control;
	signal s_spw_tx_status_mask : t_comm_data_trans_spw_tx_status;

begin

	p_comm_data_transmitter_crc : process(clk_i, rst_i) is
		variable v_comm_data_transmitter_crc_state : t_comm_data_transmitter_crc_fsm;
	begin
		if (rst_i = '1') then

			-- fsm state reset
			s_comm_data_transmitter_crc_state <= STOPPED;
			v_comm_data_transmitter_crc_state := STOPPED;

			-- internal signals reset
			s_header_cnt      <= 0;
			s_data_length_cnt <= (others => '0');
			s_header_crc      <= x"00";
			s_data_crc        <= x"00";

			-- outputs reset
			s_crc_spw_tx_control          <= c_COMM_DATA_TRANS_SPW_TX_CONTROL_RST;
			s_spw_tx_status_mask.tx_ready <= '1';

		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_comm_data_transmitter_crc_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- data transmitter is stopped
					-- default state transition
					s_comm_data_transmitter_crc_state <= STOPPED;
					v_comm_data_transmitter_crc_state := STOPPED;
					-- default internal signal values
					s_header_cnt                      <= 0;
					s_data_length_cnt                 <= (others => '0');
					s_header_crc                      <= x"00";
					s_data_crc                        <= x"00";
					-- conditional state transition
					-- check if a start was issued
					if (comm_start_i = '1') then
						-- start issued, go to idle
						s_comm_data_transmitter_crc_state <= IDLE;
						v_comm_data_transmitter_crc_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- data transmitter is in idle
					-- default state transition
					s_comm_data_transmitter_crc_state <= IDLE;
					v_comm_data_transmitter_crc_state := IDLE;
					-- default internal signal values
					s_header_cnt                      <= 0;
					s_data_length_cnt                 <= (others => '0');
					s_header_crc                      <= x"00";
					s_data_crc                        <= x"00";
					-- conditional state transition
					-- check if the first header byte was written (header transmission started)
					if (spw_tx_trans_control_i.tx_write = '1') then
						-- the first header byte was written (header transmission started)
						-- increment header counter
						s_header_cnt                      <= s_header_cnt + 1;
						-- go to wait header trans finish
						s_comm_data_transmitter_crc_state <= WAIT_HEADER_TRANS_FINISH;
						v_comm_data_transmitter_crc_state := WAIT_HEADER_TRANS_FINISH;
					end if;

				-- state "WAIT_HEADER_TRANS_FINISH"
				when WAIT_HEADER_TRANS_FINISH =>
					-- wait the header transmission to finish
					-- default state transition
					s_comm_data_transmitter_crc_state <= WAIT_HEADER_TRANS_FINISH;
					v_comm_data_transmitter_crc_state := WAIT_HEADER_TRANS_FINISH;
					-- default internal signal values
					-- conditional state transition
					-- check if a header byte was written
					if (spw_tx_trans_control_i.tx_write = '1') then
						-- a header byte was written
						-- update header crc calculation
						s_header_crc <= RMAP_CalculateCRC(s_header_crc, spw_tx_trans_control_i.tx_data);
						-- increment header counter
						s_header_cnt <= s_header_cnt + 1;
						-- check if the packet length msb was written
						if (s_header_cnt = c_PKT_HEADER_LENGTH_MSB) then
							-- the packet length msb was written
							-- update data length counter msb
							s_data_length_cnt(15 downto 8) <= unsigned(spw_tx_trans_control_i.tx_data);
						-- check if the packet length lsb was written
						elsif (s_header_cnt = c_PKT_HEADER_LENGTH_LSB) then
							-- the packet length msb was written
							-- update data length counter msb
							s_data_length_cnt(7 downto 0) <= unsigned(spw_tx_trans_control_i.tx_data);
						-- check if the last header byte was written (header transmission finished)
						elsif (s_header_cnt = (c_PKT_HEADER_SIZE_NUMERIC - 1)) then
							-- the last header byte was written (header transmission finished)
							-- go to waiting spw ready header crc
							s_comm_data_transmitter_crc_state <= WAITING_SPW_READY_HEADER_CRC;
							v_comm_data_transmitter_crc_state := WAITING_SPW_READY_HEADER_CRC;
						end if;
					end if;

				-- state "WAITING_SPW_READY_HEADER_CRC"
				when WAITING_SPW_READY_HEADER_CRC =>
					-- wait spw to be ready for a header crc transmission
					-- default state transition
					s_comm_data_transmitter_crc_state <= WAITING_SPW_READY_HEADER_CRC;
					v_comm_data_transmitter_crc_state := WAITING_SPW_READY_HEADER_CRC;
					-- default internal signal values
					-- conditional state transition
					-- check if spw tx is ready for a write (codec can receive header crc)
					if (spw_tx_codec_status_i.tx_ready = '1') then
						-- spw tx is ready for a write (codec can receive header crc)
						-- go to transmit spw header crc
						s_comm_data_transmitter_crc_state <= TRANSMIT_SPW_HEADER_CRC;
						v_comm_data_transmitter_crc_state := TRANSMIT_SPW_HEADER_CRC;
					end if;

				-- state "TRANSMIT_SPW_HEADER_CRC"
				when TRANSMIT_SPW_HEADER_CRC =>
					-- transmit header crc on the spw
					-- default state transition
					s_comm_data_transmitter_crc_state <= WAIT_DATA_TRANS_FINISH;
					v_comm_data_transmitter_crc_state := WAIT_DATA_TRANS_FINISH;
				-- default internal signal values
				-- conditional state transition
				-- check if a start was issued

				-- state "WAIT_DATA_TRANS_FINISH"
				when WAIT_DATA_TRANS_FINISH =>
					-- wait the data transmission to finish
					-- default state transition
					s_comm_data_transmitter_crc_state <= WAIT_DATA_TRANS_FINISH;
					v_comm_data_transmitter_crc_state := WAIT_DATA_TRANS_FINISH;
					-- default internal signal values
					-- conditional state transition
					-- check if a start was issued
					-- check if a data byte was written
					if (spw_tx_trans_control_i.tx_write = '1') then
						-- a data byte was written
						-- update data crc calculation
						s_data_crc        <= RMAP_CalculateCRC(s_data_crc, spw_tx_trans_control_i.tx_data);
						-- decrement data length counter
						s_data_length_cnt <= s_data_length_cnt - 1;
						-- check if the last data byte was written
						if (s_data_length_cnt = c_DATA_LENGTH_FINISHED) then
							-- the last data byte was written
							-- go to waiting spw ready data crc
							s_comm_data_transmitter_crc_state <= WAITING_SPW_READY_DATA_CRC;
							v_comm_data_transmitter_crc_state := WAITING_SPW_READY_DATA_CRC;
						end if;
					end if;

				-- state "WAITING_SPW_READY_DATA_CRC"
				when WAITING_SPW_READY_DATA_CRC =>
					-- wait spw to be ready for a data crc transmission
					-- default state transition
					s_comm_data_transmitter_crc_state <= WAITING_SPW_READY_DATA_CRC;
					v_comm_data_transmitter_crc_state := WAITING_SPW_READY_DATA_CRC;
					-- default internal signal values
					-- conditional state transition
					-- check if spw tx is ready for a write (codec can receive data crc)
					if (spw_tx_codec_status_i.tx_ready = '1') then
						-- spw tx is ready for a write (codec can receive data crc)
						-- go to transmit spw data crc
						s_comm_data_transmitter_crc_state <= TRANSMIT_SPW_DATA_CRC;
						v_comm_data_transmitter_crc_state := TRANSMIT_SPW_DATA_CRC;
					end if;

				-- state "TRANSMIT_SPW_DATA_CRC"
				when TRANSMIT_SPW_DATA_CRC =>
					-- transmit data crc on the spw
					-- default state transition
					s_comm_data_transmitter_crc_state <= FINISHED;
					v_comm_data_transmitter_crc_state := FINISHED;
				-- default internal signal values
				-- conditional state transition
				-- check if a start was issued

				-- state "FINISHED"
				when FINISHED =>
					-- data transmitter is finished
					-- default state transition
					s_comm_data_transmitter_crc_state <= FINISHED;
					v_comm_data_transmitter_crc_state := FINISHED;
				-- default internal signal values
				-- conditional state transition
				-- check if a start was issued

				-- all the other states (not defined)
				when others =>
					s_comm_data_transmitter_crc_state <= STOPPED;
					v_comm_data_transmitter_crc_state := STOPPED;

			end case;

			-- check if a stop was issued
			if (comm_stop_i = '1') then
				-- a stop was issued
				-- go to stopped
				s_comm_data_transmitter_crc_state <= STOPPED;
				v_comm_data_transmitter_crc_state := STOPPED;
			-- check if an end of packet was written
			elsif ((spw_tx_trans_control_i.tx_write = '1') and (spw_tx_trans_control_i.tx_flag = '1')) then
				-- an end of packet was written
				-- check if the transmitter crc is not stopped
				if (s_comm_data_transmitter_crc_state /= STOPPED) then
					-- the transmitter crc is not stopped
					-- go to idle
					s_comm_data_transmitter_crc_state <= IDLE;
					v_comm_data_transmitter_crc_state := IDLE;
				end if;
			end if;

			-- Output Generation --
			-- Default output generation
			s_crc_spw_tx_control          <= c_COMM_DATA_TRANS_SPW_TX_CONTROL_RST;
			s_spw_tx_status_mask.tx_ready <= '1';
			-- Output generation FSM
			case (v_comm_data_transmitter_crc_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- data transmitter is stopped
					-- default output signals
					null;
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- data transmitter is in idle
					-- default output signals
					null;
				-- conditional output signals

				-- state "WAIT_HEADER_TRANS_FINISH"
				when WAIT_HEADER_TRANS_FINISH =>
					-- wait the header transmission to finish
					-- default output signals
					null;
				-- conditional output signals

				-- state "WAITING_SPW_READY_HEADER_CRC"
				when WAITING_SPW_READY_HEADER_CRC =>
					-- wait spw to be ready for a header crc transmission
					-- default output signals
					-- keep data transmitter tx ready masked
					s_spw_tx_status_mask.tx_ready <= '0';
				-- conditional output signals

				-- state "TRANSMIT_SPW_HEADER_CRC"
				when TRANSMIT_SPW_HEADER_CRC =>
					-- transmit header crc on the spw
					-- default output signals
					-- write header crc to spw codec
					s_crc_spw_tx_control.tx_flag  <= c_SPW_CODEC_DATA_ID_FLAG;
					s_crc_spw_tx_control.tx_data  <= s_header_crc;
					s_crc_spw_tx_control.tx_write <= '1';
					-- keep data transmitter tx ready masked
					s_spw_tx_status_mask.tx_ready <= '0';
				-- conditional output signals

				-- state "WAIT_DATA_TRANS_FINISH"
				when WAIT_DATA_TRANS_FINISH =>
					-- wait the data transmission to finish
					-- default output signals
					null;
				-- conditional output signals

				-- state "WAITING_SPW_READY_DATA_CRC"
				when WAITING_SPW_READY_DATA_CRC =>
					-- wait spw to be ready for a data crc transmission
					-- default output signals
					-- keep data transmitter tx ready masked
					s_spw_tx_status_mask.tx_ready <= '0';
				-- conditional output signals

				-- state "TRANSMIT_SPW_DATA_CRC"
				when TRANSMIT_SPW_DATA_CRC =>
					-- transmit data crc on the spw
					-- default output signals
					-- write data crc to spw codec
					s_crc_spw_tx_control.tx_flag  <= c_SPW_CODEC_DATA_ID_FLAG;
					s_crc_spw_tx_control.tx_data  <= s_data_crc;
					s_crc_spw_tx_control.tx_write <= '1';
					-- keep data transmitter tx ready masked
					s_spw_tx_status_mask.tx_ready <= '0';
				-- conditional output signals

				-- state "FINISHED"
				when FINISHED =>
					-- data transmitter is finished
					-- default output signals
					null;
					-- conditional output signals

			end case;

		end if;
	end process p_comm_data_transmitter_crc;

	-- Outputs Generation --
	-- spw tx trans status generation
	spw_tx_trans_status_o.tx_ready  <= (spw_tx_codec_status_i.tx_ready) and (s_spw_tx_status_mask.tx_ready);
	-- spw tx codec control generation
	spw_tx_codec_control_o.tx_flag  <= (spw_tx_trans_control_i.tx_flag) or (s_crc_spw_tx_control.tx_flag);
	spw_tx_codec_control_o.tx_data  <= (spw_tx_trans_control_i.tx_data) or (s_crc_spw_tx_control.tx_data);
	spw_tx_codec_control_o.tx_write <= (spw_tx_trans_control_i.tx_write) or (s_crc_spw_tx_control.tx_write);

end architecture RTL;
