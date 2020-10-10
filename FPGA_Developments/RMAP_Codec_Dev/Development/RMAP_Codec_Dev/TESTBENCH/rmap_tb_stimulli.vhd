library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_pkg.all;
use work.rmap_tb_stimulli_cmd_pkg.all;
use work.rmap_tb_stimulli_rly_pkg.all;

entity rmap_tb_stimulli is
	port(
		clk_i                      : in  std_logic;
		rst_i                      : in  std_logic;
		spw_control_i              : in  t_rmap_target_spw_control;
		mem_control_i              : in  t_rmap_target_mem_control;
		mem_wr_byte_address_i      : in  std_logic_vector(31 downto 0);
		mem_rd_byte_address_i      : in  std_logic_vector(31 downto 0);
		stat_command_received_i    : in  std_logic;
		stat_write_requested_i     : in  std_logic;
		stat_write_authorized_i    : in  std_logic;
		stat_write_finished_i      : in  std_logic;
		stat_read_requested_i      : in  std_logic;
		stat_read_authorized_i     : in  std_logic;
		stat_read_finished_i       : in  std_logic;
		stat_reply_sended_i        : in  std_logic;
		stat_discarded_package_i   : in  std_logic;
		err_early_eop_i            : in  std_logic;
		err_eep_i                  : in  std_logic;
		err_header_crc_i           : in  std_logic;
		err_unused_packet_type_i   : in  std_logic;
		err_invalid_command_code_i : in  std_logic;
		err_too_much_data_i        : in  std_logic;
		err_invalid_data_crc_i     : in  std_logic;
		spw_flag_o                 : out t_rmap_target_spw_flag;
		mem_flag_o                 : out t_rmap_target_mem_flag;
		conf_target_enable_o       : out std_logic;
		conf_target_logical_addr_o : out std_logic_vector(7 downto 0);
		conf_target_key_o          : out std_logic_vector(7 downto 0);
		rmap_errinj_en_o           : out std_logic;
		rmap_errinj_id_o           : out std_logic_vector(3 downto 0);
		rmap_errinj_val_o          : out std_logic_vector(31 downto 0)
	);
end entity rmap_tb_stimulli;

architecture RTL of rmap_tb_stimulli is

	-- RMAP Commands signals --

	-- RMAP Commands test counter signals
	signal s_rmap_cmd_test_cnt    : natural;
	signal s_rmap_cmd_success_cnt : natural;
	signal s_rmap_cmd_failure_cnt : natural;
	signal s_rmap_cmd_skipped_cnt : natural;

	-- RMAP Commands counter signals
	signal s_rmap_cmd_cnt : t_rmap_cmd_max_cnt;

	-- RMAP Replies signals --

	-- RMAP Replies timeout counter signals
	signal s_rmap_rly_timeout_cnt : t_rmap_rly_timeout_cnt;

	-- RMAP Replies counter signals
	signal s_rmap_rly_cnt : t_rmap_rly_max_cnt;

	-- RMAP Replies verification signals
	signal s_rmap_rly_verification : std_logic_vector((c_RMAP_RLY_MAX_LENGTH - 1) downto 0);

	-- Others signals --

	signal s_counter : natural := 0;

begin

	p_rmap_tb_stimulli : process(clk_i, rst_i) is
		procedure p_reset_outputs is
		begin

			spw_flag_o.receiver.valid    <= '0';
			spw_flag_o.receiver.flag     <= '0';
			spw_flag_o.receiver.data     <= x"00";
			spw_flag_o.receiver.error    <= '0';
			spw_flag_o.transmitter.ready <= '0';
			spw_flag_o.transmitter.error <= '0';
			mem_flag_o.write.waitrequest <= '1';
			mem_flag_o.write.error       <= '0';
			mem_flag_o.read.waitrequest  <= '1';
			mem_flag_o.read.error        <= '0';
			mem_flag_o.read.data         <= x"AA";
			conf_target_enable_o         <= '1';
			conf_target_logical_addr_o   <= x"51";
			conf_target_key_o            <= x"D1";
			rmap_errinj_en_o             <= '0';
			rmap_errinj_id_o             <= (others => '0');
			rmap_errinj_val_o            <= (others => '0');

		end procedure p_reset_outputs;

		procedure p_outputs_triggers is
		begin

			spw_flag_o.receiver.valid    <= '0';
			spw_flag_o.receiver.flag     <= '0';
			spw_flag_o.receiver.data     <= x"00";
			spw_flag_o.receiver.error    <= '0';
			spw_flag_o.transmitter.ready <= '0';
			spw_flag_o.transmitter.error <= '0';
			mem_flag_o.write.waitrequest <= '0';
			mem_flag_o.write.error       <= '0';
			mem_flag_o.read.waitrequest  <= '0';
			mem_flag_o.read.error        <= '0';
			mem_flag_o.read.data         <= x"AA";
			conf_target_enable_o         <= '1';
			conf_target_logical_addr_o   <= x"51";
			conf_target_key_o            <= x"D1";
			rmap_errinj_en_o             <= '0';
			rmap_errinj_id_o             <= (others => '0');
			rmap_errinj_val_o            <= (others => '0');

		end procedure p_outputs_triggers;

	begin
		if (rst_i = '1') then

			s_rmap_cmd_test_cnt    <= 0;
			s_rmap_cmd_success_cnt <= 0;
			s_rmap_cmd_failure_cnt <= 0;
			s_rmap_cmd_skipped_cnt <= 0;

			s_rmap_cmd_cnt <= 0;

			s_rmap_rly_timeout_cnt  <= 0;
			s_rmap_rly_cnt          <= 0;
			s_rmap_rly_verification <= (others => '0');

			s_counter <= 0;

			p_reset_outputs;

		elsif rising_edge(clk_i) then

			s_counter <= s_counter + 1;
			p_outputs_triggers;

			case (s_counter) is

				-- Test Case 1.1 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Correct Protocol ID = 0x01 RMAP Protocol --

				-- Test Case 1.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_01_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_01_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_01_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_01_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_01_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_01_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_01_01_TIME;
						end if;
					end if;

				-- Test Case 1.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_01_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_01_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_01_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_01_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_01_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_01_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_01_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_01_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_01_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 1.2 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Wrong protocol ID = 0x02 CCSDS Packet Encapsulation Protocol --

				-- Test Case 1.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_01_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_01_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_01_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_01_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_01_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_01_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_01_02_TIME;
						end if;
					end if;

				-- Test Case 1.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_01_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_01_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_01_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_01_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_01_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_01_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_01_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_01_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_01_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 1.3 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Wrong protocol ID = 0x00 Extended Protocol Identifier --

				-- Test Case 1.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_01_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_01_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_01_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_01_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_01_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_01_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_01_03_TIME;
						end if;
					end if;

				-- Test Case 1.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_01_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_01_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_01_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_01_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_01_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_01_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_01_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_01_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_01_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 1.4 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Wrong protocol ID = 0x03 --

				-- Test Case 1.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_01_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_01_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_01_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_01_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_01_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_01_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_01_04_TIME;
						end if;
					end if;

				-- Test Case 1.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_01_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_01_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_01_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_01_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_01_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_01_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_01_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_01_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_01_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 1.5 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Wrong protocol ID = 0x11 --

				-- Test Case 1.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_01_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_01_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_01_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_01_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_01_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_01_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_01_05_TIME;
						end if;
					end if;

				-- Test Case 1.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_01_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_01_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_01_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_01_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_01_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_01_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_01_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_01_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_01_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 1.6 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Wrong protocol ID = 0xEE GOES-R Reliable Data Delivery Protocol --

				-- Test Case 1.6 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_01_06_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_01_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_06_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_01_06_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_01_06_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_01_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_06_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_01_06_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_01_06_TIME;
						end if;
					end if;

				-- Test Case 1.6 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_01_06_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_01_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_06_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_01_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_01_06_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_01_06_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_01_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_01_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_06_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_01_06_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_06_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_06_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_01_06_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 1.7 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Wrong protocol ID = 0xEF Serial Transfer Universal Protocol --

				-- Test Case 1.7 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_01_07_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_01_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_07_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_01_07_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_01_07_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_01_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_07_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_01_07_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_01_07_TIME;
						end if;
					end if;

				-- Test Case 1.7 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_01_07_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_01_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_01_07_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_01_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_01_07_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_01_07_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_01_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_01_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_01_07_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_01_07_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_07_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_01_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_01_07_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_01_07_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 2.1 (PLATO-DLR-PL-ICD-0007 4.1): Correct reply address length --

				-- Test Case 2.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_02_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_02_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_02_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_02_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_02_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_02_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_02_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_02_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_02_01_TIME;
						end if;
					end if;

				-- Test Case 2.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_02_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_02_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_02_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_02_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_02_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_02_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_02_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_02_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_02_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_02_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_02_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_02_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_02_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 2.2 (PLATO-DLR-PL-ICD-0007 4.1): Reply Address length check = 1 --

				-- Test Case 2.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_02_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_02_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_02_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_02_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_02_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_02_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_02_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_02_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_02_02_TIME;
						end if;
					end if;

				-- Test Case 2.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_02_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_02_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_02_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_02_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_02_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_02_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_02_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_02_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_02_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_02_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_02_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_02_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_02_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 2.3 (PLATO-DLR-PL-ICD-0007 4.1): Reply Address length check = 2 --

				-- Test Case 2.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_02_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_02_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_02_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_02_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_02_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_02_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_02_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_02_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_02_03_TIME;
						end if;
					end if;

				-- Test Case 2.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_02_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_02_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_02_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_02_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_02_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_02_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_02_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_02_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_02_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_02_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_02_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_02_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_02_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 2.4 (PLATO-DLR-PL-ICD-0007 4.1): Reply Address length check = 3 --

				-- Test Case 2.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_02_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_02_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_02_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_02_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_02_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_02_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_02_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_02_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_02_04_TIME;
						end if;
					end if;

				-- Test Case 2.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_02_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_02_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_02_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_02_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_02_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_02_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_02_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_02_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_02_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_02_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_02_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_02_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_02_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_02_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 3.1 (PLATO-DLR-PL-ICD-0007 4.5.1.5): Valid read packet with EOP --

				-- Test Case 3.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_03_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_03_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_03_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_03_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_03_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_03_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_03_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_03_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_03_01_TIME;
						end if;
					end if;

				-- Test Case 3.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_03_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_03_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_03_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_03_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_03_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_03_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_03_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_03_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_03_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_03_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_03_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_03_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_03_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_03_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 3.2 (PLATO-DLR-PL-ICD-0007 4.5.1.5): Invalid read packet with EEP --

				-- Test Case 3.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_03_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_03_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_03_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_03_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_03_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_03_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_03_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_03_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_03_02_TIME;
						end if;
					end if;

				-- Test Case 3.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_03_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_03_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_03_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_03_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_03_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_03_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_03_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_03_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_03_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_03_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_03_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_03_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_03_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_03_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 3.3 (PLATO-DLR-PL-ICD-0007 4.5.1.5): Invalid write packet with EEP --

				-- Test Case 3.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_03_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_03_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_03_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_03_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_03_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_03_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_03_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_03_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_03_03_TIME;
						end if;
					end if;

				-- Test Case 3.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_03_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_03_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_03_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_03_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_03_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_03_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_03_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_03_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_03_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_03_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_03_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_03_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_03_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_03_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 4.1 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Valid command code 0x4C --

				-- Test Case 4.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_04_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_04_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_04_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_04_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_04_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_04_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_04_01_TIME;
						end if;
					end if;

				-- Test Case 4.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_04_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_04_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_04_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_04_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_04_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_04_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_04_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_04_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_04_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 4.2 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Valid command code 0x6C --

				-- Test Case 4.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_04_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_04_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_04_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_04_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_04_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_04_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_04_02_TIME;
						end if;
					end if;

				-- Test Case 4.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_04_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_04_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_04_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_04_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_04_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_04_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_04_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_04_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_04_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 4.3 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 0x6C to critical memory 0x00000014 --

				-- Test Case 4.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_04_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_04_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_04_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_04_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_04_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_04_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_04_03_TIME;
						end if;
					end if;

				-- Test Case 4.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_04_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_04_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_04_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_04_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_04_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_04_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_04_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_04_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_04_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 4.4 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 0x6C to housekeeping memory 0x00001000 --

				-- Test Case 4.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_04_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_04_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_04_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_04_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_04_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_04_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_04_04_TIME;
						end if;
					end if;

				-- Test Case 4.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_04_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_04_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_04_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_04_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_04_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_04_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_04_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_04_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_04_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 4.5 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Valid command code 0x7C --

				-- Test Case 4.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_04_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_04_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_04_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_04_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_04_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_04_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_04_05_TIME;
						end if;
					end if;

				-- Test Case 4.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_04_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_04_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_04_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_04_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_04_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_04_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_04_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_04_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_04_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 4.6 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 0x7C to housekeeping memory 0x00001000 --

				-- Test Case 4.6 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_04_06_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_04_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_06_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_04_06_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_04_06_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_04_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_06_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_04_06_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_04_06_TIME;
						end if;
					end if;

				-- Test Case 4.6 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_04_06_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_04_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_06_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_04_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_04_06_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_04_06_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_04_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_04_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_06_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_04_06_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_06_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_06_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_04_06_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 4.7 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 0 --

				-- Test Case 4.7 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_04_07_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_04_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_07_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_04_07_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_04_07_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_04_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_07_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_04_07_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_04_07_TIME;
						end if;
					end if;

				-- Test Case 4.7 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_04_07_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_04_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_07_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_04_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_04_07_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_04_07_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_04_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_04_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_07_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_04_07_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_07_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_07_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_04_07_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 4.8 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 1 --

				-- Test Case 4.8 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_04_08_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_04_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_08_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_04_08_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_04_08_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_04_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_08_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_04_08_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_04_08_TIME;
						end if;
					end if;

				-- Test Case 4.8 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_04_08_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_04_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_08_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_04_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_04_08_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_04_08_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_04_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_04_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_08_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_04_08_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_08_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_08_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_04_08_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 4.9 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 4 --

				-- Test Case 4.9 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_04_09_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_04_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_09_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_04_09_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_04_09_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_04_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_09_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_04_09_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_04_09_TIME;
						end if;
					end if;

				-- Test Case 4.9 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_04_09_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_04_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_09_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_04_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_04_09_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_04_09_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_04_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_04_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_09_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_04_09_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_09_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_09_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_04_09_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 4.10 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 5 --

				-- Test Case 4.10 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_04_10_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_04_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_10_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_04_10_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_04_10_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_04_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_10_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_04_10_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_04_10_TIME;
						end if;
					end if;

				-- Test Case 4.10 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_04_10_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_04_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_10_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_04_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_04_10_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_04_10_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_04_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_04_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_10_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_04_10_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_10_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_10_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_04_10_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 4.11 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 6 --

				-- Test Case 4.11 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_04_11_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_04_11_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_11_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_04_11_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_04_11_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_04_11_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_11_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_04_11_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_04_11_TIME;
						end if;
					end if;

				-- Test Case 4.11 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_04_11_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_04_11_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_11_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_04_11_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_04_11_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_04_11_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_04_11_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_04_11_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_11_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_04_11_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_11_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_11_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_11_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_04_11_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 4.12 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 7 --

				-- Test Case 4.12 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_04_12_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_04_12_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_12_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_04_12_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_04_12_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_04_12_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_12_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_04_12_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_04_12_TIME;
						end if;
					end if;

				-- Test Case 4.12 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_04_12_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_04_12_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_04_12_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_04_12_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_04_12_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_04_12_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_04_12_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_04_12_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_04_12_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_04_12_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_12_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_04_12_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_04_12_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_04_12_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 5.1 (PLATO-DLR-PL-ICD-0007 4.5.1.12): No data characters in read command --

				-- Test Case 5.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_05_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_05_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_05_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_05_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_05_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_05_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_05_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_05_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_05_01_TIME;
						end if;
					end if;

				-- Test Case 5.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_05_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_05_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_05_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_05_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_05_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_05_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_05_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_05_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_05_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_05_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_05_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_05_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_05_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_05_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 5.2 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Data characters in read command --

				-- Test Case 5.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_05_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_05_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_05_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_05_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_05_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_05_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_05_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_05_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_05_02_TIME;
						end if;
					end if;

				-- Test Case 5.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_05_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_05_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_05_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_05_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_05_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_05_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_05_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_05_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_05_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_05_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_05_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_05_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_05_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_05_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 6.1 (PLATO-DLR-PL-ICD-0007 4.5.1.7): Valid Key = 0xD1 --

				-- Test Case 6.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_06_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_06_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_06_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_06_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_06_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_06_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_06_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_06_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_06_01_TIME;
						end if;
					end if;

				-- Test Case 6.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_06_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_06_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_06_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_06_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_06_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_06_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_06_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_06_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_06_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_06_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_06_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_06_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_06_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 6.2 (PLATO-DLR-PL-ICD-0007 4.5.1.7): Invalid Key = 0xD0 --

				-- Test Case 6.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_06_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_06_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_06_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_06_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_06_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_06_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_06_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_06_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_06_02_TIME;
						end if;
					end if;

				-- Test Case 6.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_06_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_06_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_06_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_06_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_06_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_06_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_06_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_06_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_06_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_06_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_06_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_06_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_06_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 6.3 (PLATO-DLR-PL-ICD-0007 4.5.1.7): Invalid Key = 0xD2 --

				-- Test Case 6.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_06_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_06_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_06_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_06_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_06_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_06_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_06_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_06_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_06_03_TIME;
						end if;
					end if;

				-- Test Case 6.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_06_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_06_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_06_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_06_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_06_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_06_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_06_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_06_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_06_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_06_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_06_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_06_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_06_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 6.4 (PLATO-DLR-PL-ICD-0007 4.5.1.7): Invalid Key = 0x00 --

				-- Test Case 6.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_06_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_06_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_06_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_06_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_06_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_06_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_06_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_06_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_06_04_TIME;
						end if;
					end if;

				-- Test Case 6.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_06_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_06_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_06_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_06_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_06_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_06_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_06_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_06_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_06_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_06_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_06_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_06_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_06_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 6.5 (PLATO-DLR-PL-ICD-0007 4.5.1.7): Invalid Key = 0xFF --

				-- Test Case 6.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_06_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_06_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_06_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_06_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_06_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_06_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_06_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_06_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_06_05_TIME;
						end if;
					end if;

				-- Test Case 6.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_06_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_06_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_06_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_06_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_06_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_06_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_06_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_06_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_06_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_06_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_06_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_06_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_06_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_06_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 7.1 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Valid logical target address = 0x51 --

				-- Test Case 7.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_07_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_07_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_07_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_07_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_07_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_07_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_07_01_TIME;
						end if;
					end if;

				-- Test Case 7.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_07_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_07_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_07_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_07_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_07_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_07_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_07_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_07_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_07_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 7.2 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x00 --

				-- Test Case 7.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_07_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_07_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_07_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_07_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_07_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_07_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_07_02_TIME;
						end if;
					end if;

				-- Test Case 7.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_07_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_07_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_07_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_07_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_07_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_07_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_07_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_07_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_07_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 7.3 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0xFF --

				-- Test Case 7.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_07_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_07_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_07_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_07_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_07_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_07_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_07_03_TIME;
						end if;
					end if;

				-- Test Case 7.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_07_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_07_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_07_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_07_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_07_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_07_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_07_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_07_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_07_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 7.4 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x61 --

				-- Test Case 7.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_07_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_07_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_07_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_07_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_07_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_07_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_07_04_TIME;
						end if;
					end if;

				-- Test Case 7.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_07_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_07_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_07_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_07_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_07_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_07_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_07_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_07_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_07_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 7.5 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x41 --

				-- Test Case 7.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_07_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_07_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_07_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_07_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_07_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_07_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_07_05_TIME;
						end if;
					end if;

				-- Test Case 7.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_07_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_07_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_07_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_07_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_07_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_07_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_07_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_07_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_07_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 7.6 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0xFE --

				-- Test Case 7.6 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_07_06_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_07_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_06_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_07_06_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_07_06_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_07_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_06_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_07_06_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_07_06_TIME;
						end if;
					end if;

				-- Test Case 7.6 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_07_06_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_07_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_06_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_07_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_07_06_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_07_06_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_07_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_07_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_06_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_07_06_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_06_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_06_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_07_06_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 7.7 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x11 --

				-- Test Case 7.7 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_07_07_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_07_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_07_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_07_07_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_07_07_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_07_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_07_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_07_07_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_07_07_TIME;
						end if;
					end if;

				-- Test Case 7.7 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_07_07_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_07_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_07_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_07_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_07_07_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_07_07_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_07_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_07_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_07_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_07_07_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_07_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_07_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_07_07_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 7.8 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x99 --

				-- Test Case 7.8 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_07_08_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_07_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_08_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_07_08_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_07_08_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_07_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_08_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_07_08_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_07_08_TIME;
						end if;
					end if;

				-- Test Case 7.8 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_07_08_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_07_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_08_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_07_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_07_08_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_07_08_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_07_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_07_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_08_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_07_08_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_08_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_08_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_07_08_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 7.9 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x50 --

				-- Test Case 7.9 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_07_09_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_07_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_09_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_07_09_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_07_09_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_07_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_09_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_07_09_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_07_09_TIME;
						end if;
					end if;

				-- Test Case 7.9 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_07_09_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_07_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_09_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_07_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_07_09_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_07_09_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_07_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_07_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_09_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_07_09_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_09_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_09_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_07_09_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 7.10 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x52 --

				-- Test Case 7.10 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_07_10_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_07_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_10_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_07_10_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_07_10_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_07_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_10_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_07_10_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_07_10_TIME;
						end if;
					end if;

				-- Test Case 7.10 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_07_10_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_07_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_07_10_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_07_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_07_10_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_07_10_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_07_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_07_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_07_10_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_07_10_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_10_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_07_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_07_10_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_07_10_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 8.1 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from valid address --

				-- Test Case 8.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_08_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_08_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_08_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_08_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_08_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_08_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_08_01_TIME;
						end if;
					end if;

				-- Test Case 8.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_08_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_08_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_08_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_08_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_08_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_08_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_08_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_08_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_08_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 8.2 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused address 0x00090000 --

				-- Test Case 8.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_08_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_08_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_08_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_08_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_08_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_08_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_08_02_TIME;
						end if;
					end if;

				-- Test Case 8.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_08_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_08_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_08_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_08_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_08_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_08_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_08_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_08_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_08_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 8.3 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused address 0x10000000 --

				-- Test Case 8.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_08_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_08_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_08_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_08_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_08_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_08_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_08_03_TIME;
						end if;
					end if;

				-- Test Case 8.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_08_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_08_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_08_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_08_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_08_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_08_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_08_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_08_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_08_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 8.4 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused DEB address 0x00008000 --

				-- Test Case 8.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_08_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_08_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_08_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_08_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_08_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_08_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_08_04_TIME;
						end if;
					end if;

				-- Test Case 8.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_08_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_08_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_08_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_08_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_08_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_08_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_08_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_08_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_08_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 8.5 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused AEB1 address 0x00018000 --

				-- Test Case 8.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_08_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_08_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_08_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_08_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_08_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_08_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_08_05_TIME;
						end if;
					end if;

				-- Test Case 8.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_08_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_08_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_08_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_08_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_08_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_08_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_08_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_08_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_08_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 8.6 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused AEB2 address 0x00028000 --

				-- Test Case 8.6 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_08_06_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_08_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_06_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_08_06_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_08_06_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_08_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_06_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_08_06_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_08_06_TIME;
						end if;
					end if;

				-- Test Case 8.6 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_08_06_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_08_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_06_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_08_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_08_06_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_08_06_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_08_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_08_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_06_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_08_06_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_06_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_06_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_08_06_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 8.7 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused AEB3 address 0x00048000 --

				-- Test Case 8.7 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_08_07_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_08_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_07_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_08_07_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_08_07_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_08_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_07_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_08_07_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_08_07_TIME;
						end if;
					end if;

				-- Test Case 8.7 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_08_07_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_08_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_07_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_08_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_08_07_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_08_07_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_08_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_08_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_07_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_08_07_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_07_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_07_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_08_07_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 8.8 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused AEB4 address 0x00088000 --

				-- Test Case 8.8 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_08_08_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_08_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_08_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_08_08_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_08_08_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_08_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_08_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_08_08_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_08_08_TIME;
						end if;
					end if;

				-- Test Case 8.8 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_08_08_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_08_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_08_08_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_08_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_08_08_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_08_08_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_08_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_08_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_08_08_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_08_08_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_08_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_08_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_08_08_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_08_08_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 9.1 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Valid header --

				-- Test Case 9.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_09_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_09_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_09_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_09_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_09_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_09_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_09_01_TIME;
						end if;
					end if;

				-- Test Case 9.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_09_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_09_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_09_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_09_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_09_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_09_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_09_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_09_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_09_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 9.2 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Header CRC Error - overwrite header crc to 0x00 --

				-- Test Case 9.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_09_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_09_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_09_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_09_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_09_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_09_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_09_02_TIME;
						end if;
					end if;

				-- Test Case 9.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_09_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_09_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_09_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_09_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_09_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_09_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_09_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_09_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_09_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 9.3 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Header CRC Error - overwrite header crc to 0xFF --

				-- Test Case 9.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_09_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_09_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_09_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_09_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_09_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_09_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_09_03_TIME;
						end if;
					end if;

				-- Test Case 9.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_09_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_09_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_09_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_09_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_09_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_09_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_09_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_09_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_09_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 9.4 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Incomplete header - remove protocol ID --

				-- Test Case 9.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_09_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_09_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_09_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_09_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_09_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_09_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_09_04_TIME;
						end if;
					end if;

				-- Test Case 9.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_09_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_09_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_09_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_09_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_09_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_09_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_09_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_09_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_09_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 9.5 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Incomplete header - remove key --

				-- Test Case 9.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_09_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_09_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_09_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_09_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_09_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_09_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_09_05_TIME;
						end if;
					end if;

				-- Test Case 9.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_09_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_09_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_09_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_09_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_09_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_09_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_09_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_09_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_09_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 9.6 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Incomplete header - remove first address byte (MSB) --

				-- Test Case 9.6 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_09_06_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_09_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_06_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_09_06_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_09_06_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_09_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_06_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_09_06_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_09_06_TIME;
						end if;
					end if;

				-- Test Case 9.6 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_09_06_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_09_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_06_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_09_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_09_06_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_09_06_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_09_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_09_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_06_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_09_06_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_06_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_06_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_09_06_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 9.7 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Incomplete header - remove all address bytes --

				-- Test Case 9.7 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_09_07_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_09_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_07_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_09_07_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_09_07_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_09_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_07_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_09_07_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_09_07_TIME;
						end if;
					end if;

				-- Test Case 9.7 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_09_07_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_09_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_07_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_09_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_09_07_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_09_07_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_09_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_09_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_07_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_09_07_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_07_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_07_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_09_07_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 9.8 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Invalid header - Unused packet type = 0 --

				-- Test Case 9.8 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_09_08_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_09_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_08_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_09_08_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_09_08_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_09_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_08_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_09_08_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_09_08_TIME;
						end if;
					end if;

				-- Test Case 9.8 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_09_08_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_09_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_08_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_09_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_09_08_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_09_08_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_09_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_09_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_08_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_09_08_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_08_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_08_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_09_08_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 9.9 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Invalid header - Unused packet type = 2 --

				-- Test Case 9.9 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_09_09_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_09_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_09_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_09_09_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_09_09_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_09_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_09_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_09_09_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_09_09_TIME;
						end if;
					end if;

				-- Test Case 9.9 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_09_09_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_09_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_09_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_09_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_09_09_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_09_09_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_09_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_09_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_09_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_09_09_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_09_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_09_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_09_09_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 9.10 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Invalid header - Unused packet type = 3 --

				-- Test Case 9.10 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_09_10_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_09_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_10_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_09_10_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_09_10_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_09_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_10_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_09_10_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_09_10_TIME;
						end if;
					end if;

				-- Test Case 9.10 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_09_10_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_09_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_09_10_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_09_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_09_10_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_09_10_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_09_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_09_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_09_10_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_09_10_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_10_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_09_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_09_10_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_09_10_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 10.1 (PLATO-DLR-PL-ICD-0007 4.5.1.6): Valid Data CRC --

				-- Test Case 10.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_10_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_10_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_10_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_10_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_10_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_10_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_10_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_10_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_10_01_TIME;
						end if;
					end if;

				-- Test Case 10.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_10_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_10_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_10_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_10_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_10_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_10_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_10_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_10_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_10_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_10_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_10_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_10_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_10_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_10_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 10.2 (PLATO-DLR-PL-ICD-0007 4.5.1.6): Invalid Data CRC 0x00 --

				-- Test Case 10.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_10_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_10_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_10_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_10_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_10_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_10_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_10_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_10_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_10_02_TIME;
						end if;
					end if;

				-- Test Case 10.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_10_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_10_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_10_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_10_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_10_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_10_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_10_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_10_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_10_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_10_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_10_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_10_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_10_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_10_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 10.3 (PLATO-DLR-PL-ICD-0007 4.5.1.6): Invalid Data CRC 0xFF --

				-- Test Case 10.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_10_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_10_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_10_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_10_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_10_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_10_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_10_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_10_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_10_03_TIME;
						end if;
					end if;

				-- Test Case 10.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_10_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_10_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_10_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_10_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_10_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_10_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_10_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_10_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_10_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_10_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_10_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_10_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_10_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_10_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 11.1 (PLATO-DLR-PL-ICD-0007 4.5.1.1): Write to valid address 0x00000130 --

				-- Test Case 11.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_11_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_11_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_11_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_11_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_11_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_11_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_11_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_11_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_11_01_TIME;
						end if;
					end if;

				-- Test Case 11.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_11_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_11_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_11_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_11_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_11_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_11_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_11_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_11_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_11_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_11_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_11_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_11_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_11_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 11.2 (PLATO-DLR-PL-ICD-0007 4.5.1.1): Write 8 Bytes across memory border starting at address 0x000000FC --

				-- Test Case 11.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_11_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_11_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_11_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_11_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_11_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_11_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_11_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_11_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_11_02_TIME;
						end if;
					end if;

				-- Test Case 11.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_11_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_11_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_11_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_11_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_11_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_11_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_11_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_11_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_11_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_11_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_11_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_11_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_11_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 11.3 (PLATO-DLR-PL-ICD-0007 4.5.1.1): Write 8 Bytes across memory border starting at address 0x00000FFC --

				-- Test Case 11.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_11_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_11_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_11_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_11_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_11_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_11_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_11_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_11_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_11_03_TIME;
						end if;
					end if;

				-- Test Case 11.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_11_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_11_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_11_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_11_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_11_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_11_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_11_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_11_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_11_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_11_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_11_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_11_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_11_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 11.4 (PLATO-DLR-PL-ICD-0007 4.5.1.1): Write 8 Bytes across memory border starting at address 0x00001FFC --

				-- Test Case 11.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_11_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_11_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_11_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_11_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_11_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_11_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_11_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_11_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_11_04_TIME;
						end if;
					end if;

				-- Test Case 11.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_11_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_11_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_11_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_11_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_11_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_11_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_11_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_11_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_11_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_11_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_11_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_11_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_11_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_11_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 12.1 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to valid address 0x00000130 --

				-- Test Case 12.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_12_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_12_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_12_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_12_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_12_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_12_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_12_01_TIME;
						end if;
					end if;

				-- Test Case 12.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_12_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_12_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_12_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_12_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_12_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_12_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_12_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_12_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_12_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 12.2 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to unused address 0x10000000 --

				-- Test Case 12.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_12_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_12_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_12_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_12_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_12_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_12_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_12_02_TIME;
						end if;
					end if;

				-- Test Case 12.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_12_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_12_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_12_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_12_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_12_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_12_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_12_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_12_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_12_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 12.3 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to unused DEB address 0x00008000 --

				-- Test Case 12.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_12_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_12_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_12_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_12_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_12_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_12_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_12_03_TIME;
						end if;
					end if;

				-- Test Case 12.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_12_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_12_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_12_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_12_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_12_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_12_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_12_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_12_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_12_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 12.4 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to unused AEB1 address 0x00018000 --

				-- Test Case 12.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_12_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_12_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_12_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_12_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_12_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_12_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_12_04_TIME;
						end if;
					end if;

				-- Test Case 12.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_12_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_12_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_12_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_12_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_12_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_12_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_12_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_12_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_12_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 12.5 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to unused AEB2 address 0x00028000 --

				-- Test Case 12.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_12_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_12_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_12_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_12_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_12_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_12_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_12_05_TIME;
						end if;
					end if;

				-- Test Case 12.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_12_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_12_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_12_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_12_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_12_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_12_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_12_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_12_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_12_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 12.6 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to unused AEB3 address 0x00048000 --

				-- Test Case 12.6 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_12_06_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_12_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_06_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_12_06_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_12_06_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_12_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_06_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_12_06_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_12_06_TIME;
						end if;
					end if;

				-- Test Case 12.6 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_12_06_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_12_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_06_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_12_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_12_06_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_12_06_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_12_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_12_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_06_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_12_06_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_06_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_06_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_12_06_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 12.7 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to unused AEB4 address 0x00088000 --

				-- Test Case 12.7 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_12_07_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_12_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_07_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_12_07_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_12_07_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_12_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_07_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_12_07_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_12_07_TIME;
						end if;
					end if;

				-- Test Case 12.7 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_12_07_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_12_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_12_07_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_12_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_12_07_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_12_07_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_12_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_12_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_12_07_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_12_07_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_07_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_12_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_12_07_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_12_07_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 13.1 (PLATO-DLR-PL-ICD-0007 4.5.1.11): Correct amount of data --

				-- Test Case 13.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_13_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_13_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_13_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_13_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_13_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_13_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_13_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_13_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_13_01_TIME;
						end if;
					end if;

				-- Test Case 13.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_13_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_13_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_13_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_13_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_13_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_13_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_13_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_13_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_13_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_13_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_13_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_13_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_13_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 13.2 (PLATO-DLR-PL-ICD-0007 4.5.1.11): Less data than expected (expected 8 Bytes; provided 4 Bytes) --

				-- Test Case 13.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_13_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_13_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_13_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_13_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_13_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_13_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_13_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_13_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_13_02_TIME;
						end if;
					end if;

				-- Test Case 13.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_13_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_13_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_13_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_13_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_13_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_13_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_13_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_13_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_13_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_13_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_13_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_13_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_13_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 13.3 (PLATO-DLR-PL-ICD-0007 4.5.1.11): Less data than expected (expected 260 Bytes; provided 4 Bytes) --

				-- Test Case 13.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_13_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_13_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_13_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_13_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_13_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_13_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_13_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_13_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_13_03_TIME;
						end if;
					end if;

				-- Test Case 13.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_13_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_13_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_13_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_13_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_13_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_13_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_13_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_13_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_13_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_13_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_13_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_13_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_13_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 13.4 (PLATO-DLR-PL-ICD-0007 4.5.1.11): Less data than expected (expected 16777212 Bytes; provided 4 Bytes) --

				-- Test Case 13.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_13_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_13_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_13_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_13_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_13_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_13_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_13_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_13_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_13_04_TIME;
						end if;
					end if;

				-- Test Case 13.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_13_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_13_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_13_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_13_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_13_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_13_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_13_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_13_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_13_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_13_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_13_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_13_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_13_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 13.5 (PLATO-DLR-PL-ICD-0007 4.5.1.11): More data than expected (expected 4 Bytes; provided 8 Bytes) --

				-- Test Case 13.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_13_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_13_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_13_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_13_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_13_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_13_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_13_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_13_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_13_05_TIME;
						end if;
					end if;

				-- Test Case 13.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_13_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_13_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_13_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_13_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_13_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_13_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_13_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_13_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_13_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_13_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_13_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_13_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_13_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 13.6 (PLATO-DLR-PL-ICD-0007 4.5.1.11): More data than expected (expected 0 Bytes; provided 4 Bytes) --

				-- Test Case 13.6 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_13_06_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_13_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_13_06_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_13_06_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_13_06_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_13_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_13_06_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_13_06_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_13_06_TIME;
						end if;
					end if;

				-- Test Case 13.6 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_13_06_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_13_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_13_06_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_13_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_13_06_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_13_06_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_13_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_13_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_13_06_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_13_06_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_13_06_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_13_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_13_06_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_13_06_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.1 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 bytes to DEB critical configuration are (0x00000014) --

				-- Test Case 14.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_01_TIME;
						end if;
					end if;

				-- Test Case 14.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.2 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 8 Bytes to DEB critical configuration area (0x00000014) --

				-- Test Case 14.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_02_TIME;
						end if;
					end if;

				-- Test Case 14.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.3 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to DEB critical configuration area (0x00000014) --

				-- Test Case 14.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_03_TIME;
						end if;
					end if;

				-- Test Case 14.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.4 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 4 Bytes from DEB critical configuration area (0x00000014) --

				-- Test Case 14.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_04_TIME;
						end if;
					end if;

				-- Test Case 14.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.5 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 8 Bytes from DEB critical configuration area (0x00000014) --

				-- Test Case 14.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_05_TIME;
						end if;
					end if;

				-- Test Case 14.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.6 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 0 Bytes from DEB critical configuration area (0x00000014) --

				-- Test Case 14.6 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_06_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_06_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_06_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_06_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_06_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_06_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_06_TIME;
						end if;
					end if;

				-- Test Case 14.6 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_06_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_06_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_06_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_06_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_06_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_06_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_06_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_06_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_06_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.7 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 Bytes to DEB general configuration area (0x00000130) --

				-- Test Case 14.7 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_07_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_07_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_07_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_07_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_07_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_07_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_07_TIME;
						end if;
					end if;

				-- Test Case 14.7 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_07_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_07_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_07_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_07_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_07_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_07_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_07_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_07_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_07_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.8 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 256 Bytes to DEB general configuration area (0x00000130) --

				-- Test Case 14.8 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_08_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_08_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_08_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_08_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_08_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_08_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_08_TIME;
						end if;
					end if;

				-- Test Case 14.8 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_08_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_08_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_08_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_08_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_08_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_08_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_08_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_08_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_08_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.9 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 260 Bytes to DEB general configuration area (0x00000130) --

				-- Test Case 14.9 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_09_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_09_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_09_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_09_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_09_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_09_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_09_TIME;
						end if;
					end if;

				-- Test Case 14.9 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_09_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_09_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_09_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_09_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_09_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_09_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_09_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_09_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_09_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.10 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to DEB general configuration area (0x00000130) --

				-- Test Case 14.10 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_10_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_10_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_10_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_10_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_10_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_10_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_10_TIME;
						end if;
					end if;

				-- Test Case 14.10 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_10_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_10_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_10_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_10_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_10_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_10_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_10_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_10_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_10_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.11 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from DEB general configuration area (0x00000130) --

				-- Test Case 14.11 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_11_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_11_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_11_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_11_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_11_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_11_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_11_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_11_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_11_TIME;
						end if;
					end if;

				-- Test Case 14.11 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_11_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_11_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_11_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_11_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_11_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_11_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_11_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_11_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_11_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_11_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_11_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_11_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_11_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_11_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.12 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from DEB general configuration area (0x00000130) --

				-- Test Case 14.12 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_12_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_12_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_12_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_12_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_12_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_12_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_12_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_12_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_12_TIME;
						end if;
					end if;

				-- Test Case 14.12 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_12_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_12_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_12_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_12_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_12_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_12_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_12_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_12_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_12_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_12_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_12_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_12_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_12_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_12_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.13 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from DEB general configuration area (0x00000130) --

				-- Test Case 14.13 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_13_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_13_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_13_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_13_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_13_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_13_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_13_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_13_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_13_TIME;
						end if;
					end if;

				-- Test Case 14.13 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_13_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_13_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_13_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_13_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_13_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_13_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_13_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_13_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_13_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_13_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_13_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_13_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_13_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_13_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.14 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from DEB general configuration area (0x00000130) --

				-- Test Case 14.14 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_14_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_14_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_14_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_14_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_14_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_14_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_14_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_14_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_14_TIME;
						end if;
					end if;

				-- Test Case 14.14 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_14_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_14_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_14_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_14_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_14_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_14_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_14_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_14_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_14_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_14_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_14_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_14_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_14_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_14_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.15 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from DEB housekeeping area (0x00001000) --

				-- Test Case 14.15 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_15_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_15_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_15_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_15_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_15_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_15_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_15_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_15_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_15_TIME;
						end if;
					end if;

				-- Test Case 14.15 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_15_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_15_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_15_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_15_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_15_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_15_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_15_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_15_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_15_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_15_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_15_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_15_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_15_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_15_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.16 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from DEB housekeeping area (0x00001000) --

				-- Test Case 14.16 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_16_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_16_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_16_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_16_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_16_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_16_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_16_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_16_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_16_TIME;
						end if;
					end if;

				-- Test Case 14.16 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_16_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_16_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_16_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_16_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_16_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_16_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_16_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_16_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_16_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_16_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_16_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_16_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_16_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_16_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.17 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from DEB housekeeping area (0x00001000) --

				-- Test Case 14.17 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_17_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_17_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_17_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_17_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_17_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_17_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_17_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_17_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_17_TIME;
						end if;
					end if;

				-- Test Case 14.17 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_17_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_17_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_17_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_17_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_17_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_17_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_17_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_17_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_17_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_17_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_17_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_17_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_17_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_17_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.18 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from DEB housekeeping area (0x00001000) --

				-- Test Case 14.18 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_18_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_18_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_18_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_18_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_18_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_18_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_18_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_18_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_18_TIME;
						end if;
					end if;

				-- Test Case 14.18 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_18_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_18_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_18_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_18_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_18_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_18_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_18_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_18_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_18_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_18_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_18_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_18_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_18_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_18_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.19 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 Bytes to DEB windowing area (0x00002000) --

				-- Test Case 14.19 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_19_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_19_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_19_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_19_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_19_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_19_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_19_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_19_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_19_TIME;
						end if;
					end if;

				-- Test Case 14.19 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_19_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_19_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_19_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_19_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_19_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_19_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_19_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_19_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_19_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_19_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_19_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_19_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_19_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_19_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.20 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4096 Bytes to DEB windowing area (0x00002000) --

				-- Test Case 14.20 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_20_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_20_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_20_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_20_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_20_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_20_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_20_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_20_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_20_TIME;
						end if;
					end if;

				-- Test Case 14.20 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_20_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_20_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_20_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_20_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_20_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_20_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_20_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_20_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_20_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_20_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_20_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_20_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_20_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_20_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.21 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4100 Bytes to DEB windowing area (0x00002000) --

				-- Test Case 14.21 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_21_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_21_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_21_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_21_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_21_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_21_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_21_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_21_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_21_TIME;
						end if;
					end if;

				-- Test Case 14.21 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_21_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_21_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_21_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_21_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_21_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_21_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_21_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_21_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_21_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_21_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_21_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_21_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_21_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_21_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.22 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to DEB windowing area (0x00002000) --

				-- Test Case 14.22 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_22_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_22_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_22_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_22_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_22_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_22_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_22_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_22_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_22_TIME;
						end if;
					end if;

				-- Test Case 14.22 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_22_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_22_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_22_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_22_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_22_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_22_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_22_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_22_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_22_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_22_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_22_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_22_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_22_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_22_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.23 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from DEB windowing area (0x00002000) --

				-- Test Case 14.23 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_23_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_23_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_23_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_23_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_23_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_23_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_23_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_23_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_23_TIME;
						end if;
					end if;

				-- Test Case 14.23 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_23_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_23_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_23_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_23_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_23_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_23_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_23_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_23_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_23_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_23_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_23_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_23_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_23_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_23_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.24 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4096 Bytes from DEB windowing area (0x00002000) --

				-- Test Case 14.24 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_24_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_24_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_24_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_24_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_24_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_24_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_24_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_24_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_24_TIME;
						end if;
					end if;

				-- Test Case 14.24 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_24_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_24_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_24_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_24_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_24_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_24_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_24_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_24_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_24_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_24_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_24_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_24_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_24_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_24_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.25 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4100 Bytes from DEB windowing area (0x00002000) --

				-- Test Case 14.25 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_25_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_25_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_25_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_25_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_25_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_25_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_25_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_25_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_25_TIME;
						end if;
					end if;

				-- Test Case 14.25 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_25_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_25_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_25_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_25_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_25_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_25_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_25_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_25_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_25_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_25_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_25_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_25_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_25_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_25_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 14.26 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from DEB windowing area (0x00002000) --

				-- Test Case 14.26 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_14_26_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_14_26_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_26_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_14_26_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_14_26_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_14_26_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_26_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_14_26_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_14_26_TIME;
						end if;
					end if;

				-- Test Case 14.26 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_14_26_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_14_26_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_14_26_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_14_26_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_14_26_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_14_26_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_14_26_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_14_26_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_14_26_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_14_26_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_26_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_14_26_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_14_26_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_14_26_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 15.1 (PLATO-DLR-PL-ICD-0007 4.5.1.13): Valid 4-Byte aligned data length field --

				-- Test Case 15.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_15_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_15_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_15_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_15_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_15_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_15_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_15_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_15_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_15_01_TIME;
						end if;
					end if;

				-- Test Case 15.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_15_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_15_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_15_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_15_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_15_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_15_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_15_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_15_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_15_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_15_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_15_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_15_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_15_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 15.2 (PLATO-DLR-PL-ICD-0007 4.5.1.13): Invalid aligned data length field: 3 Bytes --

				-- Test Case 15.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_15_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_15_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_15_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_15_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_15_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_15_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_15_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_15_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_15_02_TIME;
						end if;
					end if;

				-- Test Case 15.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_15_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_15_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_15_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_15_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_15_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_15_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_15_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_15_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_15_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_15_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_15_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_15_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_15_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 15.3 (PLATO-DLR-PL-ICD-0007 4.5.1.13): Invalid aligned data length field: 5 Bytes --

				-- Test Case 15.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_15_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_15_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_15_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_15_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_15_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_15_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_15_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_15_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_15_03_TIME;
						end if;
					end if;

				-- Test Case 15.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_15_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_15_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_15_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_15_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_15_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_15_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_15_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_15_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_15_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_15_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_15_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_15_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_15_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 15.4 (PLATO-DLR-PL-ICD-0007 4.5.1.13): Invalid aligned data length field: 6 Bytes --

				-- Test Case 15.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_15_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_15_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_15_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_15_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_15_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_15_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_15_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_15_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_15_04_TIME;
						end if;
					end if;

				-- Test Case 15.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_15_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_15_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_15_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_15_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_15_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_15_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_15_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_15_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_15_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_15_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_15_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_15_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_15_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 15.5 (PLATO-DLR-PL-ICD-0007 4.5.1.13): Invalid aligned data length field: 14 Bytes --

				-- Test Case 15.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_15_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_15_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_15_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_15_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_15_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_15_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_15_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_15_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_15_05_TIME;
						end if;
					end if;

				-- Test Case 15.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_15_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_15_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_15_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_15_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_15_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_15_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_15_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_15_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_15_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_15_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_15_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_15_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_15_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_15_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 16.1 (PLATO-DLR-PL-ICD-0007 4.1 / 4.5.1.10): Valid read with incrementing address --

				-- Test Case 16.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_16_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_16_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_16_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_16_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_16_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_16_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_16_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_16_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_16_01_TIME;
						end if;
					end if;

				-- Test Case 16.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_16_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_16_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_16_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_16_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_16_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_16_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_16_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_16_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_16_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_16_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_16_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_16_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_16_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 16.2 (PLATO-DLR-PL-ICD-0007 4.1 / 4.5.1.10): Invalid read without incrementing address --

				-- Test Case 16.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_16_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_16_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_16_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_16_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_16_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_16_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_16_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_16_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_16_02_TIME;
						end if;
					end if;

				-- Test Case 16.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_16_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_16_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_16_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_16_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_16_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_16_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_16_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_16_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_16_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_16_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_16_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_16_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_16_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 16.3 (PLATO-DLR-PL-ICD-0007 4.1 / 4.5.1.10): Invalid verified write without incrementing address --

				-- Test Case 16.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_16_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_16_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_16_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_16_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_16_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_16_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_16_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_16_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_16_03_TIME;
						end if;
					end if;

				-- Test Case 16.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_16_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_16_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_16_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_16_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_16_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_16_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_16_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_16_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_16_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_16_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_16_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_16_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_16_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 16.4 (PLATO-DLR-PL-ICD-0007 4.1 / 4.5.1.10): Invalid unverified write without incrementing address --

				-- Test Case 16.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_16_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_16_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_16_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_16_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_16_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_16_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_16_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_16_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_16_04_TIME;
						end if;
					end if;

				-- Test Case 16.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_16_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_16_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_16_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_16_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_16_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_16_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_16_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_16_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_16_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_16_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_16_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_16_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_16_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_16_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.1 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 bytes to AEB1 critical configuration are (0x00010014) --

				-- Test Case 17.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_01_TIME;
						end if;
					end if;

				-- Test Case 17.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.2 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 8 Bytes to AEB1 critical configuration area (0x00010014) --

				-- Test Case 17.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_02_TIME;
						end if;
					end if;

				-- Test Case 17.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.3 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB1 critical configuration area (0x00010014) --

				-- Test Case 17.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_03_TIME;
						end if;
					end if;

				-- Test Case 17.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.4 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 4 Bytes from AEB1 critical configuration area (0x00010014) --

				-- Test Case 17.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_04_TIME;
						end if;
					end if;

				-- Test Case 17.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.5 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 8 Bytes from AEB1 critical configuration area (0x00010014) --

				-- Test Case 17.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_05_TIME;
						end if;
					end if;

				-- Test Case 17.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.6 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 0 Bytes from AEB1 critical configuration area (0x00010014) --

				-- Test Case 17.6 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_06_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_06_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_06_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_06_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_06_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_06_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_06_TIME;
						end if;
					end if;

				-- Test Case 17.6 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_06_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_06_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_06_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_06_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_06_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_06_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_06_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_06_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_06_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.7 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 Bytes to AEB1 general configuration area (0x00010130) --

				-- Test Case 17.7 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_07_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_07_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_07_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_07_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_07_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_07_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_07_TIME;
						end if;
					end if;

				-- Test Case 17.7 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_07_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_07_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_07_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_07_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_07_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_07_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_07_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_07_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_07_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.8 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 256 Bytes to AEB1 general configuration area (0x00010130) --

				-- Test Case 17.8 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_08_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_08_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_08_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_08_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_08_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_08_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_08_TIME;
						end if;
					end if;

				-- Test Case 17.8 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_08_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_08_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_08_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_08_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_08_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_08_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_08_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_08_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_08_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.9 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 260 Bytes to AEB1 general configuration area (0x00010130) --

				-- Test Case 17.9 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_09_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_09_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_09_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_09_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_09_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_09_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_09_TIME;
						end if;
					end if;

				-- Test Case 17.9 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_09_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_09_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_09_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_09_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_09_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_09_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_09_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_09_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_09_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.10 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB1 general configuration area (0x00010130) --

				-- Test Case 17.10 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_10_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_10_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_10_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_10_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_10_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_10_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_10_TIME;
						end if;
					end if;

				-- Test Case 17.10 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_10_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_10_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_10_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_10_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_10_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_10_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_10_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_10_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_10_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.11 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB1 general configuration area (0x00010130) --

				-- Test Case 17.11 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_11_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_11_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_11_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_11_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_11_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_11_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_11_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_11_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_11_TIME;
						end if;
					end if;

				-- Test Case 17.11 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_11_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_11_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_11_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_11_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_11_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_11_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_11_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_11_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_11_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_11_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_11_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_11_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_11_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_11_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.12 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB1 general configuration area (0x00010130) --

				-- Test Case 17.12 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_12_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_12_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_12_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_12_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_12_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_12_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_12_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_12_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_12_TIME;
						end if;
					end if;

				-- Test Case 17.12 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_12_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_12_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_12_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_12_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_12_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_12_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_12_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_12_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_12_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_12_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_12_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_12_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_12_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_12_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.13 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB1 general configuration area (0x00010130) --

				-- Test Case 17.13 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_13_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_13_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_13_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_13_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_13_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_13_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_13_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_13_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_13_TIME;
						end if;
					end if;

				-- Test Case 17.13 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_13_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_13_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_13_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_13_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_13_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_13_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_13_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_13_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_13_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_13_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_13_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_13_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_13_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_13_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.14 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB1 general configuration area (0x00010130) --

				-- Test Case 17.14 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_14_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_14_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_14_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_14_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_14_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_14_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_14_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_14_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_14_TIME;
						end if;
					end if;

				-- Test Case 17.14 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_14_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_14_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_14_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_14_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_14_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_14_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_14_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_14_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_14_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_14_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_14_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_14_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_14_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_14_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.15 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB1 housekeeping area (0x00011000) --

				-- Test Case 17.15 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_15_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_15_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_15_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_15_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_15_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_15_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_15_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_15_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_15_TIME;
						end if;
					end if;

				-- Test Case 17.15 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_15_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_15_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_15_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_15_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_15_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_15_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_15_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_15_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_15_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_15_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_15_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_15_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_15_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_15_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.16 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB1 housekeeping area (0x00011000) --

				-- Test Case 17.16 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_16_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_16_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_16_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_16_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_16_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_16_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_16_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_16_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_16_TIME;
						end if;
					end if;

				-- Test Case 17.16 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_16_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_16_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_16_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_16_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_16_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_16_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_16_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_16_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_16_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_16_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_16_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_16_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_16_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_16_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.17 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB1 housekeeping area (0x00011000) --

				-- Test Case 17.17 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_17_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_17_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_17_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_17_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_17_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_17_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_17_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_17_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_17_TIME;
						end if;
					end if;

				-- Test Case 17.17 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_17_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_17_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_17_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_17_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_17_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_17_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_17_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_17_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_17_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_17_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_17_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_17_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_17_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_17_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 17.18 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB1 housekeeping area (0x00011000) --

				-- Test Case 17.18 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_17_18_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_17_18_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_18_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_17_18_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_17_18_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_17_18_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_18_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_17_18_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_17_18_TIME;
						end if;
					end if;

				-- Test Case 17.18 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_17_18_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_17_18_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_17_18_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_17_18_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_17_18_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_17_18_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_17_18_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_17_18_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_17_18_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_17_18_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_18_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_17_18_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_17_18_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_17_18_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.1 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 bytes to AEB2 critical configuration are (0x00020014) --

				-- Test Case 18.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_01_TIME;
						end if;
					end if;

				-- Test Case 18.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.2 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 8 Bytes to AEB2 critical configuration area (0x00020014) --

				-- Test Case 18.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_02_TIME;
						end if;
					end if;

				-- Test Case 18.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.3 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB2 critical configuration area (0x00020014) --

				-- Test Case 18.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_03_TIME;
						end if;
					end if;

				-- Test Case 18.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.4 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 4 Bytes from AEB2 critical configuration area (0x00020014) --

				-- Test Case 18.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_04_TIME;
						end if;
					end if;

				-- Test Case 18.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.5 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 8 Bytes from AEB2 critical configuration area (0x00020014) --

				-- Test Case 18.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_05_TIME;
						end if;
					end if;

				-- Test Case 18.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.6 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 0 Bytes from AEB2 critical configuration area (0x00020014) --

				-- Test Case 18.6 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_06_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_06_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_06_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_06_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_06_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_06_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_06_TIME;
						end if;
					end if;

				-- Test Case 18.6 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_06_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_06_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_06_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_06_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_06_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_06_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_06_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_06_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_06_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.7 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 Bytes to AEB2 general configuration area (0x00020130) --

				-- Test Case 18.7 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_07_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_07_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_07_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_07_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_07_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_07_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_07_TIME;
						end if;
					end if;

				-- Test Case 18.7 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_07_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_07_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_07_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_07_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_07_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_07_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_07_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_07_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_07_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.8 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 256 Bytes to AEB2 general configuration area (0x00020130) --

				-- Test Case 18.8 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_08_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_08_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_08_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_08_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_08_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_08_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_08_TIME;
						end if;
					end if;

				-- Test Case 18.8 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_08_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_08_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_08_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_08_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_08_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_08_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_08_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_08_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_08_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.9 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 260 Bytes to AEB2 general configuration area (0x00020130) --

				-- Test Case 18.9 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_09_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_09_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_09_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_09_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_09_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_09_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_09_TIME;
						end if;
					end if;

				-- Test Case 18.9 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_09_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_09_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_09_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_09_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_09_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_09_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_09_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_09_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_09_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.10 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB2 general configuration area (0x00020130) --

				-- Test Case 18.10 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_10_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_10_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_10_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_10_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_10_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_10_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_10_TIME;
						end if;
					end if;

				-- Test Case 18.10 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_10_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_10_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_10_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_10_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_10_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_10_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_10_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_10_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_10_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.11 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB2 general configuration area (0x00020130) --

				-- Test Case 18.11 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_11_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_11_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_11_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_11_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_11_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_11_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_11_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_11_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_11_TIME;
						end if;
					end if;

				-- Test Case 18.11 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_11_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_11_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_11_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_11_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_11_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_11_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_11_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_11_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_11_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_11_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_11_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_11_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_11_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_11_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.12 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB2 general configuration area (0x00020130) --

				-- Test Case 18.12 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_12_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_12_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_12_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_12_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_12_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_12_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_12_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_12_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_12_TIME;
						end if;
					end if;

				-- Test Case 18.12 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_12_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_12_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_12_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_12_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_12_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_12_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_12_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_12_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_12_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_12_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_12_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_12_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_12_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_12_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.13 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB2 general configuration area (0x00020130) --

				-- Test Case 18.13 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_13_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_13_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_13_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_13_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_13_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_13_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_13_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_13_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_13_TIME;
						end if;
					end if;

				-- Test Case 18.13 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_13_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_13_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_13_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_13_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_13_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_13_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_13_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_13_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_13_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_13_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_13_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_13_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_13_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_13_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.14 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB2 general configuration area (0x00020130) --

				-- Test Case 18.14 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_14_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_14_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_14_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_14_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_14_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_14_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_14_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_14_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_14_TIME;
						end if;
					end if;

				-- Test Case 18.14 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_14_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_14_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_14_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_14_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_14_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_14_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_14_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_14_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_14_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_14_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_14_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_14_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_14_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_14_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.15 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB2 housekeeping area (0x00021000) --

				-- Test Case 18.15 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_15_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_15_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_15_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_15_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_15_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_15_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_15_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_15_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_15_TIME;
						end if;
					end if;

				-- Test Case 18.15 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_15_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_15_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_15_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_15_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_15_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_15_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_15_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_15_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_15_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_15_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_15_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_15_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_15_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_15_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.16 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB2 housekeeping area (0x00021000) --

				-- Test Case 18.16 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_16_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_16_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_16_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_16_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_16_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_16_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_16_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_16_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_16_TIME;
						end if;
					end if;

				-- Test Case 18.16 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_16_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_16_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_16_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_16_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_16_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_16_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_16_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_16_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_16_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_16_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_16_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_16_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_16_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_16_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.17 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB2 housekeeping area (0x00021000) --

				-- Test Case 18.17 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_17_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_17_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_17_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_17_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_17_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_17_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_17_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_17_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_17_TIME;
						end if;
					end if;

				-- Test Case 18.17 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_17_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_17_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_17_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_17_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_17_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_17_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_17_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_17_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_17_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_17_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_17_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_17_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_17_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_17_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 18.18 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB2 housekeeping area (0x00021000) --

				-- Test Case 18.18 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_18_18_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_18_18_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_18_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_18_18_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_18_18_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_18_18_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_18_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_18_18_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_18_18_TIME;
						end if;
					end if;

				-- Test Case 18.18 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_18_18_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_18_18_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_18_18_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_18_18_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_18_18_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_18_18_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_18_18_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_18_18_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_18_18_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_18_18_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_18_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_18_18_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_18_18_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_18_18_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.1 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 bytes to AEB3 critical configuration are (0x00040014) --

				-- Test Case 19.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_01_TIME;
						end if;
					end if;

				-- Test Case 19.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.2 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 8 Bytes to AEB3 critical configuration area (0x00040014) --

				-- Test Case 19.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_02_TIME;
						end if;
					end if;

				-- Test Case 19.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.3 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB3 critical configuration area (0x00040014) --

				-- Test Case 19.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_03_TIME;
						end if;
					end if;

				-- Test Case 19.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.4 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 4 Bytes from AEB3 critical configuration area (0x00040014) --

				-- Test Case 19.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_04_TIME;
						end if;
					end if;

				-- Test Case 19.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.5 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 8 Bytes from AEB3 critical configuration area (0x00040014) --

				-- Test Case 19.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_05_TIME;
						end if;
					end if;

				-- Test Case 19.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.6 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 0 Bytes from AEB3 critical configuration area (0x00040014) --

				-- Test Case 19.6 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_06_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_06_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_06_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_06_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_06_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_06_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_06_TIME;
						end if;
					end if;

				-- Test Case 19.6 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_06_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_06_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_06_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_06_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_06_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_06_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_06_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_06_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_06_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.7 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 Bytes to AEB3 general configuration area (0x00040130) --

				-- Test Case 19.7 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_07_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_07_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_07_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_07_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_07_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_07_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_07_TIME;
						end if;
					end if;

				-- Test Case 19.7 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_07_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_07_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_07_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_07_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_07_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_07_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_07_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_07_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_07_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.8 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 256 Bytes to AEB3 general configuration area (0x00040130) --

				-- Test Case 19.8 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_08_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_08_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_08_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_08_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_08_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_08_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_08_TIME;
						end if;
					end if;

				-- Test Case 19.8 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_08_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_08_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_08_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_08_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_08_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_08_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_08_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_08_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_08_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.9 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 260 Bytes to AEB3 general configuration area (0x00040130) --

				-- Test Case 19.9 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_09_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_09_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_09_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_09_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_09_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_09_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_09_TIME;
						end if;
					end if;

				-- Test Case 19.9 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_09_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_09_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_09_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_09_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_09_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_09_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_09_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_09_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_09_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.10 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB3 general configuration area (0x00040130) --

				-- Test Case 19.10 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_10_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_10_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_10_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_10_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_10_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_10_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_10_TIME;
						end if;
					end if;

				-- Test Case 19.10 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_10_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_10_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_10_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_10_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_10_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_10_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_10_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_10_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_10_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.11 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB3 general configuration area (0x00040130) --

				-- Test Case 19.11 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_11_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_11_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_11_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_11_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_11_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_11_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_11_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_11_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_11_TIME;
						end if;
					end if;

				-- Test Case 19.11 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_11_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_11_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_11_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_11_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_11_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_11_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_11_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_11_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_11_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_11_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_11_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_11_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_11_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_11_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.12 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB3 general configuration area (0x00040130) --

				-- Test Case 19.12 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_12_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_12_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_12_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_12_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_12_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_12_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_12_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_12_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_12_TIME;
						end if;
					end if;

				-- Test Case 19.12 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_12_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_12_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_12_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_12_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_12_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_12_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_12_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_12_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_12_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_12_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_12_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_12_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_12_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_12_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.13 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB3 general configuration area (0x00040130) --

				-- Test Case 19.13 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_13_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_13_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_13_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_13_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_13_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_13_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_13_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_13_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_13_TIME;
						end if;
					end if;

				-- Test Case 19.13 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_13_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_13_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_13_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_13_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_13_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_13_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_13_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_13_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_13_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_13_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_13_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_13_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_13_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_13_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.14 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB3 general configuration area (0x00040130) --

				-- Test Case 19.14 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_14_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_14_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_14_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_14_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_14_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_14_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_14_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_14_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_14_TIME;
						end if;
					end if;

				-- Test Case 19.14 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_14_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_14_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_14_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_14_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_14_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_14_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_14_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_14_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_14_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_14_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_14_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_14_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_14_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_14_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.15 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB3 housekeeping area (0x00041000) --

				-- Test Case 19.15 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_15_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_15_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_15_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_15_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_15_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_15_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_15_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_15_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_15_TIME;
						end if;
					end if;

				-- Test Case 19.15 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_15_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_15_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_15_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_15_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_15_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_15_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_15_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_15_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_15_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_15_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_15_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_15_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_15_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_15_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.16 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB3 housekeeping area (0x00041000) --

				-- Test Case 19.16 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_16_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_16_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_16_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_16_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_16_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_16_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_16_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_16_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_16_TIME;
						end if;
					end if;

				-- Test Case 19.16 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_16_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_16_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_16_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_16_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_16_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_16_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_16_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_16_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_16_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_16_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_16_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_16_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_16_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_16_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.17 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB3 housekeeping area (0x00041000) --

				-- Test Case 19.17 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_17_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_17_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_17_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_17_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_17_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_17_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_17_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_17_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_17_TIME;
						end if;
					end if;

				-- Test Case 19.17 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_17_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_17_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_17_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_17_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_17_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_17_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_17_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_17_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_17_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_17_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_17_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_17_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_17_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_17_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 19.18 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB3 housekeeping area (0x00041000) --

				-- Test Case 19.18 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_19_18_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_19_18_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_18_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_19_18_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_19_18_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_19_18_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_18_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_19_18_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_19_18_TIME;
						end if;
					end if;

				-- Test Case 19.18 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_19_18_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_19_18_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_19_18_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_19_18_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_19_18_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_19_18_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_19_18_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_19_18_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_19_18_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_19_18_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_18_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_19_18_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_19_18_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_19_18_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.1 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 bytes to AEB4 critical configuration are (0x00080014) --

				-- Test Case 20.1 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_01_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_01_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_01_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_01_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_01_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_01_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_01_TIME;
						end if;
					end if;

				-- Test Case 20.1 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_01_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_01_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_01_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_01_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_01_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_01_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_01_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_01_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_01_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_01_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_01_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_01_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_01_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.2 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 8 Bytes to AEB4 critical configuration area (0x00080014) --

				-- Test Case 20.2 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_02_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_02_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_02_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_02_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_02_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_02_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_02_TIME;
						end if;
					end if;

				-- Test Case 20.2 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_02_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_02_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_02_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_02_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_02_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_02_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_02_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_02_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_02_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_02_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_02_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_02_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_02_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.3 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB4 critical configuration area (0x00080014) --

				-- Test Case 20.3 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_03_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_03_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_03_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_03_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_03_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_03_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_03_TIME;
						end if;
					end if;

				-- Test Case 20.3 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_03_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_03_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_03_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_03_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_03_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_03_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_03_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_03_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_03_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_03_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_03_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_03_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_03_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.4 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 4 Bytes from AEB4 critical configuration area (0x00080014) --

				-- Test Case 20.4 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_04_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_04_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_04_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_04_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_04_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_04_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_04_TIME;
						end if;
					end if;

				-- Test Case 20.4 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_04_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_04_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_04_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_04_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_04_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_04_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_04_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_04_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_04_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_04_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_04_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_04_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_04_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.5 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 8 Bytes from AEB4 critical configuration area (0x00080014) --

				-- Test Case 20.5 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_05_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_05_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_05_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_05_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_05_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_05_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_05_TIME;
						end if;
					end if;

				-- Test Case 20.5 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_05_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_05_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_05_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_05_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_05_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_05_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_05_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_05_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_05_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_05_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_05_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_05_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_05_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.6 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 0 Bytes from AEB4 critical configuration area (0x00080014) --

				-- Test Case 20.6 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_06_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_06_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_06_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_06_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_06_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_06_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_06_TIME;
						end if;
					end if;

				-- Test Case 20.6 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_06_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_06_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_06_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_06_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_06_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_06_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_06_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_06_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_06_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_06_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_06_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_06_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_06_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.7 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 Bytes to AEB4 general configuration area (0x00080130) --

				-- Test Case 20.7 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_07_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_07_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_07_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_07_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_07_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_07_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_07_TIME;
						end if;
					end if;

				-- Test Case 20.7 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_07_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_07_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_07_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_07_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_07_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_07_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_07_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_07_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_07_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_07_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_07_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_07_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_07_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.8 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 256 Bytes to AEB4 general configuration area (0x00080130) --

				-- Test Case 20.8 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_08_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_08_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_08_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_08_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_08_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_08_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_08_TIME;
						end if;
					end if;

				-- Test Case 20.8 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_08_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_08_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_08_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_08_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_08_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_08_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_08_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_08_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_08_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_08_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_08_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_08_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_08_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.9 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 260 Bytes to AEB4 general configuration area (0x00080130) --

				-- Test Case 20.9 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_09_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_09_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_09_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_09_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_09_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_09_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_09_TIME;
						end if;
					end if;

				-- Test Case 20.9 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_09_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_09_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_09_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_09_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_09_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_09_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_09_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_09_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_09_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_09_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_09_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_09_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_09_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.10 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB4 general configuration area (0x00080130) --

				-- Test Case 20.10 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_10_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_10_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_10_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_10_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_10_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_10_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_10_TIME;
						end if;
					end if;

				-- Test Case 20.10 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_10_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_10_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_10_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_10_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_10_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_10_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_10_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_10_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_10_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_10_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_10_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_10_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_10_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.11 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB4 general configuration area (0x00080130) --

				-- Test Case 20.11 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_11_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_11_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_11_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_11_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_11_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_11_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_11_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_11_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_11_TIME;
						end if;
					end if;

				-- Test Case 20.11 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_11_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_11_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_11_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_11_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_11_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_11_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_11_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_11_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_11_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_11_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_11_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_11_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_11_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_11_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.12 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB4 general configuration area (0x00080130) --

				-- Test Case 20.12 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_12_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_12_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_12_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_12_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_12_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_12_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_12_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_12_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_12_TIME;
						end if;
					end if;

				-- Test Case 20.12 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_12_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_12_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_12_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_12_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_12_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_12_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_12_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_12_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_12_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_12_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_12_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_12_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_12_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_12_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.13 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB4 general configuration area (0x00080130) --

				-- Test Case 20.13 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_13_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_13_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_13_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_13_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_13_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_13_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_13_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_13_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_13_TIME;
						end if;
					end if;

				-- Test Case 20.13 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_13_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_13_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_13_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_13_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_13_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_13_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_13_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_13_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_13_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_13_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_13_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_13_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_13_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_13_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.14 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB4 general configuration area (0x00080130) --

				-- Test Case 20.14 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_14_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_14_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_14_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_14_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_14_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_14_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_14_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_14_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_14_TIME;
						end if;
					end if;

				-- Test Case 20.14 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_14_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_14_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_14_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_14_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_14_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_14_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_14_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_14_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_14_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_14_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_14_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_14_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_14_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_14_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.15 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB4 housekeeping area (0x00081000) --

				-- Test Case 20.15 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_15_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_15_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_15_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_15_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_15_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_15_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_15_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_15_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_15_TIME;
						end if;
					end if;

				-- Test Case 20.15 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_15_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_15_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_15_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_15_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_15_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_15_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_15_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_15_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_15_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_15_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_15_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_15_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_15_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_15_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.16 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB4 housekeeping area (0x00081000) --

				-- Test Case 20.16 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_16_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_16_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_16_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_16_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_16_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_16_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_16_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_16_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_16_TIME;
						end if;
					end if;

				-- Test Case 20.16 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_16_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_16_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_16_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_16_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_16_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_16_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_16_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_16_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_16_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_16_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_16_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_16_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_16_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_16_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.17 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB4 housekeeping area (0x00081000) --

				-- Test Case 20.17 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_17_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_17_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_17_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_17_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_17_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_17_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_17_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_17_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_17_TIME;
						end if;
					end if;

				-- Test Case 20.17 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_17_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_17_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_17_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_17_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_17_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_17_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_17_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_17_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_17_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_17_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_17_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_17_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_17_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_17_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Case 20.18 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB4 housekeeping area (0x00081000) --

				-- Test Case 20.18 - RMAP Command

				when (c_RMAP_CMD_TEST_CASE_20_18_TIME - 1) =>
					s_rmap_cmd_cnt <= 0;

				when (c_RMAP_CMD_TEST_CASE_20_18_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_18_ENABLE = '1') then
						if (spw_control_i.receiver.read = '0') then
							spw_flag_o.receiver.flag  <= c_RMAP_CMD_TEST_CASE_20_18_DATA(s_rmap_cmd_cnt)(8);
							spw_flag_o.receiver.data  <= c_RMAP_CMD_TEST_CASE_20_18_DATA(s_rmap_cmd_cnt)(7 downto 0);
							spw_flag_o.receiver.valid <= '1';
							s_counter                 <= s_counter;
						end if;
					end if;

				when (c_RMAP_CMD_TEST_CASE_20_18_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_18_ENABLE = '1') then
						if (s_rmap_cmd_cnt < (c_RMAP_CMD_TEST_CASE_20_18_DATA'length - 1)) then
							s_rmap_cmd_cnt <= s_rmap_cmd_cnt + 1;
							s_counter      <= c_RMAP_CMD_TEST_CASE_20_18_TIME;
						end if;
					end if;

				-- Test Case 20.18 - RMAP Reply

				when (c_RMAP_RLY_TEST_CASE_20_18_TIME - 1) =>
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');

				when (c_RMAP_RLY_TEST_CASE_20_18_TIME) =>
					if (c_RMAP_CMD_TEST_CASE_20_18_ENABLE = '1') then
						if (s_rmap_rly_timeout_cnt < (c_RMAP_RLY_TIMEOUT - 1)) then
							s_rmap_rly_timeout_cnt       <= s_rmap_rly_timeout_cnt + 1;
							spw_flag_o.transmitter.ready <= '1';
							if (c_RMAP_RLY_TEST_CASE_20_18_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_timeout_cnt <= 0;
									if ((spw_control_i.transmitter.flag = c_RMAP_RLY_TEST_CASE_20_18_DATA(s_rmap_rly_cnt)(8)) and (spw_control_i.transmitter.data = c_RMAP_RLY_TEST_CASE_20_18_DATA(s_rmap_rly_cnt)(7 downto 0))) then
										s_rmap_rly_verification(s_rmap_rly_cnt) <= '1';
									end if;
								else
									s_counter <= s_counter;
								end if;
							else
								if (spw_control_i.transmitter.write = '1') then
									s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1) downto 0);
								else
									s_counter <= s_counter;
								end if;
							end if;
						else
							s_rmap_rly_cnt <= c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1;
							if (c_RMAP_RLY_TEST_CASE_20_18_DATA(0) /= c_RMAP_RLY_INVALID_DATA) then
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_FAILURE((c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1) downto 0);
							else
								s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1) downto 0) <= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1) downto 0);
							end if;
						end if;
					end if;

				when (c_RMAP_RLY_TEST_CASE_20_18_TIME + 1) =>
					if (c_RMAP_CMD_TEST_CASE_20_18_ENABLE = '1') then
						if (s_rmap_rly_cnt < (c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1)) then
							s_rmap_rly_cnt <= s_rmap_rly_cnt + 1;
							s_counter      <= c_RMAP_RLY_TEST_CASE_20_18_TIME;
						else
							s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
							if (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1) downto 0)) then
								s_rmap_cmd_success_cnt <= s_rmap_cmd_success_cnt + 1;
							else
								s_rmap_cmd_failure_cnt <= s_rmap_cmd_failure_cnt + 1;
							end if;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1) downto 0) = c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_18_TEXT & " - SUCCESS" severity note;
							assert not (s_rmap_rly_verification((c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1) downto 0) /= c_RMAP_RLY_MAX_SUCCESS((c_RMAP_RLY_TEST_CASE_20_18_DATA'length - 1) downto 0)) report c_RMAP_CMD_TEST_CASE_20_18_TEXT & " - FAILURE" severity error;
						end if;
					else
						s_rmap_cmd_test_cnt <= s_rmap_cmd_test_cnt + 1;
						s_rmap_cmd_skipped_cnt <= s_rmap_cmd_skipped_cnt + 1;
						assert (false) report c_RMAP_CMD_TEST_CASE_20_18_TEXT & " - SKIPPED" severity note;
					end if;

				-- Test Finish --

				when (c_RMAP_CMD_TEST_FINISH_TIME) =>
					s_rmap_cmd_cnt          <= 0;
					s_rmap_rly_timeout_cnt  <= 0;
					s_rmap_rly_cnt          <= 0;
					s_rmap_rly_verification <= (others => '0');
					assert not (s_rmap_cmd_failure_cnt = 0) report "RMAP Tests Status - PASSED" severity note;
					assert not (s_rmap_cmd_failure_cnt > 0) report "RMAP Tests Status - FAILED" severity error;
					assert (false) report "RMAP Successful Tests - " & integer'image(s_rmap_cmd_success_cnt) & "/" & integer'image(s_rmap_cmd_test_cnt) severity note;
					assert (false) report "RMAP Failed Tests - " & integer'image(s_rmap_cmd_failure_cnt) & "/" & integer'image(s_rmap_cmd_test_cnt) severity note;
					assert (false) report "RMAP Skipped Tests - " & integer'image(s_rmap_cmd_skipped_cnt) & "/" & integer'image(s_rmap_cmd_test_cnt) severity note;

				-- Others --

				when others =>
					null;

			end case;

		end if;
	end process p_rmap_tb_stimulli;

end architecture RTL;
