library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rmap_target_pkg.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk100 : std_logic := '0';
	signal rst    : std_logic := '1';

	-- dut signals

	-- rmap stimulli signals
	signal s_rmap_tb_spw_control              : t_rmap_target_spw_control;
	signal s_rmap_tb_mem_control              : t_rmap_target_mem_control;
	signal s_rmap_tb_mem_wr_byte_address      : std_logic_vector(31 downto 0);
	signal s_rmap_tb_mem_rd_byte_address      : std_logic_vector(31 downto 0);
	signal s_rmap_tb_stat_command_received    : std_logic;
	signal s_rmap_tb_stat_write_requested     : std_logic;
	signal s_rmap_tb_stat_write_authorized    : std_logic;
	signal s_rmap_tb_stat_write_finished      : std_logic;
	signal s_rmap_tb_stat_read_requested      : std_logic;
	signal s_rmap_tb_stat_read_authorized     : std_logic;
	signal s_rmap_tb_stat_read_finished       : std_logic;
	signal s_rmap_tb_stat_reply_sended        : std_logic;
	signal s_rmap_tb_stat_discarded_package   : std_logic;
	signal s_rmap_tb_err_early_eop            : std_logic;
	signal s_rmap_tb_err_eep                  : std_logic;
	signal s_rmap_tb_err_header_crc           : std_logic;
	signal s_rmap_tb_err_unused_packet_type   : std_logic;
	signal s_rmap_tb_err_invalid_command_code : std_logic;
	signal s_rmap_tb_err_too_much_data        : std_logic;
	signal s_rmap_tb_err_invalid_data_crc     : std_logic;
	signal s_rmap_tb_spw_flag                 : t_rmap_target_spw_flag;
	signal s_rmap_tb_mem_flag                 : t_rmap_target_mem_flag;
	signal s_rmap_tb_conf_target_enable       : std_logic;
	signal s_rmap_tb_conf_target_logical_addr : std_logic_vector(7 downto 0);
	signal s_rmap_tb_conf_target_key          : std_logic_vector(7 downto 0);
	signal s_rmap_tb_rmap_errinj_en           : std_logic;
	signal s_rmap_tb_rmap_errinj_id           : std_logic_vector(3 downto 0);
	signal s_rmap_tb_rmap_errinj_val          : std_logic_vector(31 downto 0);

begin

	-- Clocks and Reset Generation
	clk100 <= not clk100 after 5 ns; -- 100 MHz
	rst    <= '0' after 100 ns;

	-- RMAP TB Stimulli Instantiation
	rmap_tb_stimulli_inst : entity work.rmap_tb_stimulli
		port map(
			clk_i                      => clk100,
			rst_i                      => rst,
			spw_control_i              => s_rmap_tb_spw_control,
			mem_control_i              => s_rmap_tb_mem_control,
			mem_wr_byte_address_i      => s_rmap_tb_mem_wr_byte_address,
			mem_rd_byte_address_i      => s_rmap_tb_mem_rd_byte_address,
			stat_command_received_i    => s_rmap_tb_stat_command_received,
			stat_write_requested_i     => s_rmap_tb_stat_write_requested,
			stat_write_authorized_i    => s_rmap_tb_stat_write_authorized,
			stat_write_finished_i      => s_rmap_tb_stat_write_finished,
			stat_read_requested_i      => s_rmap_tb_stat_read_requested,
			stat_read_authorized_i     => s_rmap_tb_stat_read_authorized,
			stat_read_finished_i       => s_rmap_tb_stat_read_finished,
			stat_reply_sended_i        => s_rmap_tb_stat_reply_sended,
			stat_discarded_package_i   => s_rmap_tb_stat_discarded_package,
			err_early_eop_i            => s_rmap_tb_err_early_eop,
			err_eep_i                  => s_rmap_tb_err_eep,
			err_header_crc_i           => s_rmap_tb_err_header_crc,
			err_unused_packet_type_i   => s_rmap_tb_err_unused_packet_type,
			err_invalid_command_code_i => s_rmap_tb_err_invalid_command_code,
			err_too_much_data_i        => s_rmap_tb_err_too_much_data,
			err_invalid_data_crc_i     => s_rmap_tb_err_invalid_data_crc,
			spw_flag_o                 => s_rmap_tb_spw_flag,
			mem_flag_o                 => s_rmap_tb_mem_flag,
			conf_target_enable_o       => s_rmap_tb_conf_target_enable,
			conf_target_logical_addr_o => s_rmap_tb_conf_target_logical_addr,
			conf_target_key_o          => s_rmap_tb_conf_target_key,
			rmap_errinj_en_o           => s_rmap_tb_rmap_errinj_en,
			rmap_errinj_id_o           => s_rmap_tb_rmap_errinj_id,
			rmap_errinj_val_o          => s_rmap_tb_rmap_errinj_val
		);

	-- RMAP Target Codec Instantiation
	rmap_target_top_inst : entity work.rmap_target_top
		generic map(
			g_VERIFY_BUFFER_WIDTH  => 8,
			g_MEMORY_ADDRESS_WIDTH => 32,
			g_DATA_LENGTH_WIDTH    => 24,
			g_MEMORY_ACCESS_WIDTH  => 0
		)
		port map(
			clk_i                      => clk100,
			rst_i                      => rst,
			spw_flag_i                 => s_rmap_tb_spw_flag,
			mem_flag_i                 => s_rmap_tb_mem_flag,
			conf_target_enable_i       => s_rmap_tb_conf_target_enable,
			conf_target_logical_addr_i => s_rmap_tb_conf_target_logical_addr,
			conf_target_key_i          => s_rmap_tb_conf_target_key,
			rmap_errinj_en_i           => s_rmap_tb_rmap_errinj_en,
			rmap_errinj_id_i           => s_rmap_tb_rmap_errinj_id,
			rmap_errinj_val_i          => s_rmap_tb_rmap_errinj_val,
			spw_control_o              => s_rmap_tb_spw_control,
			mem_control_o              => s_rmap_tb_mem_control,
			mem_wr_byte_address_o      => s_rmap_tb_mem_wr_byte_address,
			mem_rd_byte_address_o      => s_rmap_tb_mem_rd_byte_address,
			stat_command_received_o    => s_rmap_tb_stat_command_received,
			stat_write_requested_o     => s_rmap_tb_stat_write_requested,
			stat_write_authorized_o    => s_rmap_tb_stat_write_authorized,
			stat_write_finished_o      => s_rmap_tb_stat_write_finished,
			stat_read_requested_o      => s_rmap_tb_stat_read_requested,
			stat_read_authorized_o     => s_rmap_tb_stat_read_authorized,
			stat_read_finished_o       => s_rmap_tb_stat_read_finished,
			stat_reply_sended_o        => s_rmap_tb_stat_reply_sended,
			stat_discarded_package_o   => s_rmap_tb_stat_discarded_package,
			err_early_eop_o            => s_rmap_tb_err_early_eop,
			err_eep_o                  => s_rmap_tb_err_eep,
			err_header_crc_o           => s_rmap_tb_err_header_crc,
			err_unused_packet_type_o   => s_rmap_tb_err_unused_packet_type,
			err_invalid_command_code_o => s_rmap_tb_err_invalid_command_code,
			err_too_much_data_o        => s_rmap_tb_err_too_much_data,
			err_invalid_data_crc_o     => s_rmap_tb_err_invalid_data_crc
		);

end architecture RTL;
