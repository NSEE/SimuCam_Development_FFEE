library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.frme_avalon_mm_rmap_ffee_pkg.all;
use work.frme_tb_avs_pkg.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk100 : std_logic := '0';
	signal rst    : std_logic := '1';

	-- dut signals

	-- rmap_avalon_stimuli signals
	signal s_rmap_avalon_stimuli_mm_readdata    : std_logic_vector(31 downto 0);
	signal s_rmap_avalon_stimuli_mm_waitrequest : std_logic;
	signal s_rmap_avalon_stimuli_mm_address     : std_logic_vector(11 downto 0);
	signal s_rmap_avalon_stimuli_mm_write       : std_logic;
	signal s_rmap_avalon_stimuli_mm_writedata   : std_logic_vector(31 downto 0);
	signal s_rmap_avalon_stimuli_mm_read        : std_logic;

	-- fee 0 rmap stimuli signals
	signal s_fee_0_rmap_stimuli_wr_address     : std_logic_vector(31 downto 0);
	signal s_fee_0_rmap_stimuli_write          : std_logic;
	signal s_fee_0_rmap_stimuli_writedata      : std_logic_vector(7 downto 0);
	signal s_fee_0_rmap_stimuli_rd_address     : std_logic_vector(31 downto 0);
	signal s_fee_0_rmap_stimuli_read           : std_logic;
	signal s_fee_0_rmap_stimuli_wr_waitrequest : std_logic;
	signal s_fee_0_rmap_stimuli_readdata       : std_logic_vector(7 downto 0);
	signal s_fee_0_rmap_stimuli_rd_waitrequest : std_logic;

	-- avm signals
	signal s_avm_readdata    : std_logic_vector(7 downto 0);
	signal s_avm_waitrequest : std_logic;
	signal s_avm_address     : std_logic_vector(63 downto 0);
	signal s_avm_write       : std_logic;
	signal s_avm_writedata   : std_logic_vector(7 downto 0);
	signal s_avm_read        : std_logic;

	-- tb avs signals
	signal s_tb_avs_rd_waitrequest : std_logic;
	signal s_tb_avs_wr_waitrequest : std_logic;

begin

	clk100 <= not clk100 after 5 ns;    -- 100 MHz
	rst    <= '0' after 100 ns;

	rmap_avalon_stimuli_inst : entity work.rmap_avalon_stimuli
		generic map(
			g_ADDRESS_WIDTH => 12,
			g_DATA_WIDTH    => 32
		)
		port map(
			clk_i                   => clk100,
			rst_i                   => rst,
			avalon_mm_readdata_i    => s_rmap_avalon_stimuli_mm_readdata,
			avalon_mm_waitrequest_i => s_rmap_avalon_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_rmap_avalon_stimuli_mm_address,
			avalon_mm_write_o       => s_rmap_avalon_stimuli_mm_write,
			avalon_mm_writedata_o   => s_rmap_avalon_stimuli_mm_writedata,
			avalon_mm_read_o        => s_rmap_avalon_stimuli_mm_read
		);

	fee_0_rmap_stimuli_inst : entity work.fee_0_rmap_stimuli
		generic map(
			g_ADDRESS_WIDTH => 32,
			g_DATA_WIDTH    => 8
		)
		port map(
			clk_i                       => clk100,
			rst_i                       => rst,
			fee_0_rmap_wr_waitrequest_i => s_fee_0_rmap_stimuli_wr_waitrequest,
			fee_0_rmap_readdata_i       => s_fee_0_rmap_stimuli_readdata,
			fee_0_rmap_rd_waitrequest_i => s_fee_0_rmap_stimuli_rd_waitrequest,
			fee_0_rmap_wr_address_o     => s_fee_0_rmap_stimuli_wr_address,
			fee_0_rmap_write_o          => s_fee_0_rmap_stimuli_write,
			fee_0_rmap_writedata_o      => s_fee_0_rmap_stimuli_writedata,
			fee_0_rmap_rd_address_o     => s_fee_0_rmap_stimuli_rd_address,
			fee_0_rmap_read_o           => s_fee_0_rmap_stimuli_read
		);

	frme_rmap_memory_ffee_area_top_inst : entity work.frme_rmap_memory_ffee_area_top
		port map(
			reset_i                               => rst,
			clk_100_i                             => clk100,
			avs_rmap_0_address_i                  => s_rmap_avalon_stimuli_mm_address,
			avs_rmap_0_write_i                    => s_rmap_avalon_stimuli_mm_write,
			avs_rmap_0_read_i                     => s_rmap_avalon_stimuli_mm_read,
			avs_rmap_0_readdata_o                 => s_rmap_avalon_stimuli_mm_readdata,
			avs_rmap_0_writedata_i                => s_rmap_avalon_stimuli_mm_writedata,
			avs_rmap_0_waitrequest_o              => s_rmap_avalon_stimuli_mm_waitrequest,
			avs_rmap_0_byteenable_i               => "1111",
			rms_rmap_0_wr_address_i               => s_fee_0_rmap_stimuli_wr_address,
			rms_rmap_0_write_i                    => s_fee_0_rmap_stimuli_write,
			rms_rmap_0_writedata_i                => s_fee_0_rmap_stimuli_writedata,
			rms_rmap_0_rd_address_i               => s_fee_0_rmap_stimuli_rd_address,
			rms_rmap_0_read_i                     => s_fee_0_rmap_stimuli_read,
			rms_rmap_0_wr_waitrequest_o           => s_fee_0_rmap_stimuli_wr_waitrequest,
			rms_rmap_0_readdata_o                 => s_fee_0_rmap_stimuli_readdata,
			rms_rmap_0_rd_waitrequest_o           => s_fee_0_rmap_stimuli_rd_waitrequest,
			rms_rmap_1_wr_address_i               => (others => '0'),
			rms_rmap_1_write_i                    => '0',
			rms_rmap_1_writedata_i                => (others => '0'),
			rms_rmap_1_rd_address_i               => (others => '0'),
			rms_rmap_1_read_i                     => '0',
			rms_rmap_1_wr_waitrequest_o           => open,
			rms_rmap_1_readdata_o                 => open,
			rms_rmap_1_rd_waitrequest_o           => open,
			rms_rmap_2_wr_address_i               => (others => '0'),
			rms_rmap_2_write_i                    => '0',
			rms_rmap_2_writedata_i                => (others => '0'),
			rms_rmap_2_rd_address_i               => (others => '0'),
			rms_rmap_2_read_i                     => '0',
			rms_rmap_2_wr_waitrequest_o           => open,
			rms_rmap_2_readdata_o                 => open,
			rms_rmap_2_rd_waitrequest_o           => open,
			rms_rmap_3_wr_address_i               => (others => '0'),
			rms_rmap_3_write_i                    => '0',
			rms_rmap_3_writedata_i                => (others => '0'),
			rms_rmap_3_rd_address_i               => (others => '0'),
			rms_rmap_3_read_i                     => '0',
			rms_rmap_3_wr_waitrequest_o           => open,
			rms_rmap_3_readdata_o                 => open,
			rms_rmap_3_rd_waitrequest_o           => open,
			rms_rmap_4_wr_address_i               => (others => '0'),
			rms_rmap_4_write_i                    => '0',
			rms_rmap_4_writedata_i                => (others => '0'),
			rms_rmap_4_rd_address_i               => (others => '0'),
			rms_rmap_4_read_i                     => '0',
			rms_rmap_4_wr_waitrequest_o           => open,
			rms_rmap_4_readdata_o                 => open,
			rms_rmap_4_rd_waitrequest_o           => open,
			rms_rmap_5_wr_address_i               => (others => '0'),
			rms_rmap_5_write_i                    => '0',
			rms_rmap_5_writedata_i                => (others => '0'),
			rms_rmap_5_rd_address_i               => (others => '0'),
			rms_rmap_5_read_i                     => '0',
			rms_rmap_5_wr_waitrequest_o           => open,
			rms_rmap_5_readdata_o                 => open,
			rms_rmap_5_rd_waitrequest_o           => open,
			rms_rmap_6_wr_address_i               => (others => '0'),
			rms_rmap_6_write_i                    => '0',
			rms_rmap_6_writedata_i                => (others => '0'),
			rms_rmap_6_rd_address_i               => (others => '0'),
			rms_rmap_6_read_i                     => '0',
			rms_rmap_6_wr_waitrequest_o           => open,
			rms_rmap_6_readdata_o                 => open,
			rms_rmap_6_rd_waitrequest_o           => open,
			rms_rmap_7_wr_address_i               => (others => '0'),
			rms_rmap_7_write_i                    => '0',
			rms_rmap_7_writedata_i                => (others => '0'),
			rms_rmap_7_rd_address_i               => (others => '0'),
			rms_rmap_7_read_i                     => '0',
			rms_rmap_7_wr_waitrequest_o           => open,
			rms_rmap_7_readdata_o                 => open,
			rms_rmap_7_rd_waitrequest_o           => open,
			channel_0_hk_timecode_control_i       => (others => '0'),
			channel_0_hk_timecode_time_i          => (others => '0'),
			channel_0_hk_rmap_target_status_i     => (others => '0'),
			channel_0_hk_rmap_target_indicate_i   => '0',
			channel_0_hk_spw_link_escape_err_i    => '0',
			channel_0_hk_spw_link_credit_err_i    => '0',
			channel_0_hk_spw_link_parity_err_i    => '0',
			channel_0_hk_spw_link_disconnect_i    => '0',
			channel_0_hk_spw_link_running_i       => '0',
			channel_0_hk_frame_counter_i          => (others => '0'),
			channel_0_hk_frame_number_i           => (others => '0'),
			channel_0_hk_err_win_wrong_x_coord_i  => '0',
			channel_0_hk_err_win_wrong_y_coord_i  => '0',
			channel_0_hk_err_e_side_buffer_full_i => '0',
			channel_0_hk_err_f_side_buffer_full_i => '0',
			channel_0_hk_err_invalid_ccd_mode_i   => '0',
			channel_1_hk_timecode_control_i       => (others => '0'),
			channel_1_hk_timecode_time_i          => (others => '0'),
			channel_1_hk_rmap_target_status_i     => (others => '0'),
			channel_1_hk_rmap_target_indicate_i   => '0',
			channel_1_hk_spw_link_escape_err_i    => '0',
			channel_1_hk_spw_link_credit_err_i    => '0',
			channel_1_hk_spw_link_parity_err_i    => '0',
			channel_1_hk_spw_link_disconnect_i    => '0',
			channel_1_hk_spw_link_running_i       => '0',
			channel_1_hk_frame_counter_i          => (others => '0'),
			channel_1_hk_frame_number_i           => (others => '0'),
			channel_1_hk_err_win_wrong_x_coord_i  => '0',
			channel_1_hk_err_win_wrong_y_coord_i  => '0',
			channel_1_hk_err_e_side_buffer_full_i => '0',
			channel_1_hk_err_f_side_buffer_full_i => '0',
			channel_1_hk_err_invalid_ccd_mode_i   => '0',
			channel_2_hk_timecode_control_i       => (others => '0'),
			channel_2_hk_timecode_time_i          => (others => '0'),
			channel_2_hk_rmap_target_status_i     => (others => '0'),
			channel_2_hk_rmap_target_indicate_i   => '0',
			channel_2_hk_spw_link_escape_err_i    => '0',
			channel_2_hk_spw_link_credit_err_i    => '0',
			channel_2_hk_spw_link_parity_err_i    => '0',
			channel_2_hk_spw_link_disconnect_i    => '0',
			channel_2_hk_spw_link_running_i       => '0',
			channel_2_hk_frame_counter_i          => (others => '0'),
			channel_2_hk_frame_number_i           => (others => '0'),
			channel_2_hk_err_win_wrong_x_coord_i  => '0',
			channel_2_hk_err_win_wrong_y_coord_i  => '0',
			channel_2_hk_err_e_side_buffer_full_i => '0',
			channel_2_hk_err_f_side_buffer_full_i => '0',
			channel_2_hk_err_invalid_ccd_mode_i   => '0',
			channel_3_hk_timecode_control_i       => (others => '0'),
			channel_3_hk_timecode_time_i          => (others => '0'),
			channel_3_hk_rmap_target_status_i     => (others => '0'),
			channel_3_hk_rmap_target_indicate_i   => '0',
			channel_3_hk_spw_link_escape_err_i    => '0',
			channel_3_hk_spw_link_credit_err_i    => '0',
			channel_3_hk_spw_link_parity_err_i    => '0',
			channel_3_hk_spw_link_disconnect_i    => '0',
			channel_3_hk_spw_link_running_i       => '0',
			channel_3_hk_frame_counter_i          => (others => '0'),
			channel_3_hk_frame_number_i           => (others => '0'),
			channel_3_hk_err_win_wrong_x_coord_i  => '0',
			channel_3_hk_err_win_wrong_y_coord_i  => '0',
			channel_3_hk_err_e_side_buffer_full_i => '0',
			channel_3_hk_err_f_side_buffer_full_i => '0',
			channel_3_hk_err_invalid_ccd_mode_i   => '0',
			avm_rmap_readdata_i                   => s_avm_readdata,
			avm_rmap_waitrequest_i                => s_avm_waitrequest,
			avm_rmap_address_o                    => s_avm_address,
			avm_rmap_read_o                       => s_avm_read,
			avm_rmap_write_o                      => s_avm_write,
			avm_rmap_writedata_o                  => s_avm_writedata,
			channel_win_mem_addr_offset_i         => x"1000000000000001"
		);
	s_avm_waitrequest <= (s_tb_avs_rd_waitrequest) and (s_tb_avs_wr_waitrequest);

	frme_tb_avs_read_ent_inst : entity work.frme_tb_avs_read_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			frme_tb_avs_avalon_mm_i.address     => s_avm_address,
			frme_tb_avs_avalon_mm_i.read        => s_avm_read,
			frme_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			frme_tb_avs_avalon_mm_o.readdata    => s_avm_readdata,
			frme_tb_avs_avalon_mm_o.waitrequest => s_tb_avs_rd_waitrequest
		);

	frme_tb_avs_write_ent_inst : entity work.frme_tb_avs_write_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			frme_tb_avs_avalon_mm_i.address     => s_avm_address,
			frme_tb_avs_avalon_mm_i.write       => s_avm_write,
			frme_tb_avs_avalon_mm_i.writedata   => s_avm_writedata,
			frme_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			frme_tb_avs_avalon_mm_o.waitrequest => s_tb_avs_wr_waitrequest
		);

end architecture RTL;
