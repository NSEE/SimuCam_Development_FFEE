library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

entity fee_data_controller_top is
	port(
		clk_i                                     : in  std_logic;
		rst_i                                     : in  std_logic;
		-- general inputs
		fee_sync_signal_i                         : in  std_logic;
		fee_current_timecode_i                    : in  std_logic_vector(7 downto 0);
		fee_clear_frame_i                         : in  std_logic;
		fee_left_buffer_activated_i               : in  std_logic;
		fee_right_buffer_activated_i              : in  std_logic;
		-- fee data controller control
		fee_machine_clear_i                       : in  std_logic;
		fee_machine_stop_i                        : in  std_logic;
		fee_machine_start_i                       : in  std_logic;
		fee_digitalise_en_i                       : in  std_logic;
		fee_readout_en_i                          : in  std_logic;
		fee_windowing_en_i                        : in  std_logic;
		-- fee left windowing buffer status
		fee_left_window_data_i                    : in  std_logic_vector(15 downto 0);
		fee_left_window_mask_i                    : in  std_logic;
		fee_left_window_data_valid_i              : in  std_logic;
		fee_left_window_mask_valid_i              : in  std_logic;
		fee_left_window_data_ready_i              : in  std_logic;
		fee_left_window_mask_ready_i              : in  std_logic;
		-- fee right windowing buffer status
		fee_right_window_data_i                   : in  std_logic_vector(15 downto 0);
		fee_right_window_mask_i                   : in  std_logic;
		fee_right_window_data_valid_i             : in  std_logic;
		fee_right_window_mask_valid_i             : in  std_logic;
		fee_right_window_data_ready_i             : in  std_logic;
		fee_right_window_mask_ready_i             : in  std_logic;
		-- fee housekeeping memory status
		fee_hk_mem_waitrequest_i                  : in  std_logic;
		fee_hk_mem_data_i                         : in  std_logic_vector(7 downto 0);
		-- fee spw codec tx status
		fee_spw_tx_ready_i                        : in  std_logic;
		fee_spw_link_running_i                    : in  std_logic;
		-- data packet parameters
		data_pkt_ccd_x_size_i                     : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_y_size_i                     : in  std_logic_vector(15 downto 0);
		data_pkt_data_y_size_i                    : in  std_logic_vector(15 downto 0);
		data_pkt_overscan_y_size_i                : in  std_logic_vector(15 downto 0);
		data_pkt_packet_length_i                  : in  std_logic_vector(15 downto 0);
		data_pkt_fee_mode_left_buffer_i           : in  std_logic_vector(4 downto 0);
		data_pkt_fee_mode_right_buffer_i          : in  std_logic_vector(4 downto 0);
		data_pkt_ccd_number_left_buffer_i         : in  std_logic_vector(1 downto 0);
		data_pkt_ccd_number_right_buffer_i        : in  std_logic_vector(1 downto 0);
		data_pkt_ccd_side_left_buffer_i           : in  std_logic;
		data_pkt_ccd_side_right_buffer_i          : in  std_logic;
		data_pkt_ccd_v_start_i                    : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_v_end_i                      : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_img_v_end_i                  : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_ovs_v_end_i                  : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_h_start_i                    : in  std_logic_vector(15 downto 0);
		data_pkt_ccd_h_end_i                      : in  std_logic_vector(15 downto 0);
		data_pkt_protocol_id_i                    : in  std_logic_vector(7 downto 0);
		data_pkt_logical_addr_i                   : in  std_logic_vector(7 downto 0);
		-- data packet deb parameters
		data_pkt_deb_ccd_img_v_end_i              : in  std_logic_vector(15 downto 0);
		data_pkt_deb_ccd_ovs_v_end_i              : in  std_logic_vector(15 downto 0);
		data_pkt_deb_ccd_h_end_i                  : in  std_logic_vector(15 downto 0);
		-- data packet aeb parameters
		data_pkt_aeb_ccd_img_v_end_left_buffer_i  : in  std_logic_vector(15 downto 0);
		data_pkt_aeb_ccd_h_end_left_buffer_i      : in  std_logic_vector(15 downto 0);
		data_pkt_aeb_ccd_id_left_buffer_i         : in  std_logic_vector(1 downto 0);
		data_pkt_aeb_ccd_img_v_end_right_buffer_i : in  std_logic_vector(15 downto 0);
		data_pkt_aeb_ccd_h_end_right_buffer_i     : in  std_logic_vector(15 downto 0);
		data_pkt_aeb_ccd_id_right_buffer_i        : in  std_logic_vector(1 downto 0);
		-- data delays parameters
		data_pkt_start_delay_i                    : in  std_logic_vector(31 downto 0);
		data_pkt_skip_delay_i                     : in  std_logic_vector(31 downto 0);
		data_pkt_line_delay_i                     : in  std_logic_vector(31 downto 0);
		data_pkt_adc_delay_i                      : in  std_logic_vector(31 downto 0);
		-- fee masking buffer control
		masking_buffer_overflow_i                 : in  std_logic;
		-- windowing parameters
		windowing_packet_order_list_i             : in  std_logic_vector(511 downto 0);
		windowing_last_left_packet_i              : in  std_logic_vector(9 downto 0);
		windowing_last_right_packet_i             : in  std_logic_vector(9 downto 0);
		-- error injection control
		errinj_tx_disabled_i                      : in  std_logic;
		errinj_missing_pkts_i                     : in  std_logic;
		errinj_missing_data_i                     : in  std_logic;
		errinj_frame_num_i                        : in  std_logic_vector(1 downto 0);
		errinj_sequence_cnt_i                     : in  std_logic_vector(15 downto 0);
		errinj_data_cnt_i                         : in  std_logic_vector(15 downto 0);
		errinj_n_repeat_i                         : in  std_logic_vector(15 downto 0);
		-- preset frame counter control
		preset_frame_counter_value_i              : in  std_logic_vector(15 downto 0);
		preset_frame_counter_set_i                : in  std_logic;
		-- fee machine status
		fee_machine_busy_o                        : out std_logic;
		-- fee frame status
		fee_frame_counter_o                       : out std_logic_vector(15 downto 0);
		fee_frame_number_o                        : out std_logic_vector(1 downto 0);
		-- fee left output buffer status
		fee_left_output_buffer_overflowed_o       : out std_logic;
		-- fee right output buffer status
		fee_right_output_buffer_overflowed_o      : out std_logic;
		-- fee left windowing buffer control
		fee_left_window_data_read_o               : out std_logic;
		fee_left_window_mask_read_o               : out std_logic;
		-- fee right windowing buffer control
		fee_right_window_data_read_o              : out std_logic;
		fee_right_window_mask_read_o              : out std_logic;
		-- fee housekeeping memory control
		fee_hk_mem_byte_address_o                 : out std_logic_vector(31 downto 0);
		fee_hk_mem_read_o                         : out std_logic;
		-- fee spw codec tx control
		fee_spw_tx_write_o                        : out std_logic;
		fee_spw_tx_flag_o                         : out std_logic;
		fee_spw_tx_data_o                         : out std_logic_vector(7 downto 0)
	);
end entity fee_data_controller_top;

architecture RTL of fee_data_controller_top is

	-- general signals
	signal s_current_frame_number                   : std_logic_vector(1 downto 0);
	signal s_current_frame_counter                  : std_logic_vector(15 downto 0);
	-- fee data manager signals
	signal s_dataman_sync                           : std_logic;
	signal s_dataman_left_buffer_sync               : std_logic;
	signal s_dataman_right_buffer_sync              : std_logic;
	signal s_dataman_hk_only                        : std_logic;
	signal s_dataman_left_buffer_hk_only            : std_logic;
	signal s_dataman_right_buffer_hk_only           : std_logic;
	signal s_data_headerdata                        : t_fee_dpkt_headerdata;
	-- fee housekeeping data controller signals
	signal s_hkdataman_status                       : t_fee_dpkt_general_status;
	signal s_hkdataman_control                      : t_fee_dpkt_general_control;
	signal s_hkdata_send_buffer_control             : t_fee_dpkt_send_buffer_control;
	signal s_hkdata_send_buffer_status              : t_fee_dpkt_send_buffer_status;
	signal s_hkdata_send_double_buffer_empty        : std_logic;
	-- fee left image data controller signals
	signal s_left_imgdataman_status                 : t_fee_dpkt_general_status;
	signal s_left_imgdataman_control                : t_fee_dpkt_general_control;
	signal s_left_imgdata_send_buffer_control       : t_fee_dpkt_send_buffer_control;
	signal s_left_imgdata_send_buffer_status        : t_fee_dpkt_send_buffer_status;
	signal s_left_imgdata_send_double_buffer_empty  : std_logic;
	-- fee right image data controller signals
	signal s_right_imgdataman_status                : t_fee_dpkt_general_status;
	signal s_right_imgdataman_control               : t_fee_dpkt_general_control;
	signal s_right_imgdata_send_buffer_control      : t_fee_dpkt_send_buffer_control;
	signal s_right_imgdata_send_buffer_status       : t_fee_dpkt_send_buffer_status;
	signal s_right_imgdata_send_double_buffer_empty : std_logic;
	-- data transmitter signals
	signal s_data_transmitter_busy                  : std_logic;
	signal s_data_transmitter_finished              : std_logic;
	-- registered data packet parameters signals (for the entire read-out)
	signal s_registered_dpkt_params                 : t_fee_dpkt_registered_params;
	signal s_registered_left_buffer_activated       : std_logic;
	signal s_registered_right_buffer_activated      : std_logic;
	signal s_registered_windowing_left_buffer_en    : std_logic;
	signal s_registered_windowing_right_buffer_en   : std_logic;
	-- error injection spw signals
	signal s_errinj_spw_tx_write                    : std_logic;
	signal s_errinj_spw_tx_flag                     : std_logic;
	signal s_errinj_spw_tx_data                     : std_logic_vector(7 downto 0);
	signal s_errinj_spw_tx_ready                    : std_logic;
	-- spw write masking
	signal s_spw_tx_write                           : std_logic;
	signal s_spw_write_mask                         : std_logic;

begin

	-- fee data manager instantiation
	fee_data_manager_ent_inst : entity work.fee_data_manager_ent
		port map(
			clk_i                                    => clk_i,
			rst_i                                    => rst_i,
			fee_clear_signal_i                       => fee_machine_clear_i,
			fee_stop_signal_i                        => fee_machine_stop_i,
			fee_start_signal_i                       => fee_machine_start_i,
			fee_manager_sync_i                       => s_dataman_sync,
			fee_manager_hk_only_i                    => s_dataman_hk_only,
			fee_left_buffer_activated_i              => s_registered_left_buffer_activated,
			fee_right_buffer_activated_i             => s_registered_right_buffer_activated,
			hkdataman_manager_i                      => s_hkdataman_status,
			left_imgdataman_manager_i                => s_left_imgdataman_status,
			right_imgdataman_manager_i               => s_right_imgdataman_status,
			data_transmitter_finished_i              => s_data_transmitter_finished,
			hkdata_send_double_buffer_empty_i        => s_hkdata_send_double_buffer_empty,
			left_imgdata_send_double_buffer_empty_i  => s_left_imgdata_send_double_buffer_empty,
			right_imgdata_send_double_buffer_empty_i => s_right_imgdata_send_double_buffer_empty,
			fee_data_manager_busy_o                  => fee_machine_busy_o,
			hkdataman_manager_o                      => s_hkdataman_control,
			left_imgdataman_manager_o                => s_left_imgdataman_control,
			right_imgdataman_manager_o               => s_right_imgdataman_control
		);

	-- fee housekeeping data manager instantiation
	fee_hkdata_controller_top_inst : entity work.fee_hkdata_controller_top
		port map(
			clk_i                             => clk_i,
			rst_i                             => rst_i,
			hkdataman_start_i                 => s_hkdataman_control.start,
			hkdataman_reset_i                 => s_hkdataman_control.reset,
			fee_manager_hk_only_i             => s_dataman_hk_only,
			fee_current_frame_number_i        => s_current_frame_number,
			fee_current_frame_counter_i       => s_current_frame_counter,
			fee_machine_clear_i               => fee_machine_clear_i,
			fee_machine_stop_i                => fee_machine_stop_i,
			fee_machine_start_i               => fee_machine_start_i,
			fee_hk_mem_waitrequest_i          => fee_hk_mem_waitrequest_i,
			fee_hk_mem_data_i                 => fee_hk_mem_data_i,
			data_pkt_packet_length_i          => x"0400", -- 0x400 = 1024 Bytes
			data_pkt_fee_mode_i(3)            => '0',
			data_pkt_fee_mode_i(2 downto 0)   => s_registered_dpkt_params.image.fee_mode_hk,
			data_pkt_ccd_number_i             => s_registered_dpkt_params.image.ccd_number_hk,
			data_pkt_ccd_side_i               => s_registered_dpkt_params.image.ccd_side_hk,
			data_pkt_protocol_id_i            => s_registered_dpkt_params.image.protocol_id,
			data_pkt_logical_addr_i           => s_registered_dpkt_params.image.logical_addr,
			hkdata_send_buffer_control_i      => s_hkdata_send_buffer_control,
			hkdataman_finished_o              => s_hkdataman_status.finished,
			hkdata_headerdata_o               => open,
			fee_hk_mem_byte_address_o         => fee_hk_mem_byte_address_o,
			fee_hk_mem_read_o                 => fee_hk_mem_read_o,
			hkdata_send_buffer_status_o       => s_hkdata_send_buffer_status,
			hkdata_send_double_buffer_empty_o => s_hkdata_send_double_buffer_empty
		);

	-- fee left image data manager instantiation
	fee_left_imgdata_controller_top_inst : entity work.fee_imgdata_controller_top
		port map(
			clk_i                              => clk_i,
			rst_i                              => rst_i,
			fee_current_timecode_i             => fee_current_timecode_i,
			dataman_sync_i                     => s_dataman_sync,
			imgdataman_start_i                 => s_left_imgdataman_control.start,
			imgdataman_reset_i                 => s_left_imgdataman_control.reset,
			fee_current_frame_number_i         => s_current_frame_number,
			fee_current_frame_counter_i        => s_current_frame_counter,
			fee_machine_clear_i                => fee_machine_clear_i,
			fee_machine_stop_i                 => fee_machine_stop_i,
			fee_machine_start_i                => fee_machine_start_i,
			fee_digitalise_en_i                => s_registered_dpkt_params.transmission.digitalise_en,
			fee_windowing_en_i                 => s_registered_dpkt_params.transmission.windowing_en,
			fee_pattern_en_i                   => s_registered_dpkt_params.transmission.pattern_left_buffer_en,
			fee_window_data_i                  => fee_left_window_data_i,
			fee_window_mask_i                  => fee_left_window_mask_i,
			fee_window_data_valid_i            => fee_left_window_data_valid_i,
			fee_window_mask_valid_i            => fee_left_window_mask_valid_i,
			fee_window_data_ready_i            => fee_left_window_data_ready_i,
			fee_window_mask_ready_i            => fee_left_window_mask_ready_i,
			data_pkt_ccd_x_size_i              => s_registered_dpkt_params.image.ccd_x_size,
			data_pkt_ccd_y_size_i              => s_registered_dpkt_params.image.ccd_y_size,
			data_pkt_data_y_size_i             => s_registered_dpkt_params.image.data_y_size,
			data_pkt_overscan_y_size_i         => s_registered_dpkt_params.image.overscan_y_size,
			data_pkt_packet_length_i           => s_registered_dpkt_params.image.packet_length,
			data_pkt_fee_mode_i(3)             => '0',
			data_pkt_fee_mode_i(2 downto 0)    => s_registered_dpkt_params.image.fee_mode_left_buffer,
			data_pkt_aeb_number_i              => s_registered_dpkt_params.image.ccd_number_left_buffer,
			data_pkt_ccd_id_i                  => s_registered_dpkt_params.image.ccd_id_left_buffer,
			data_pkt_ccd_side_i                => s_registered_dpkt_params.image.ccd_side_left_buffer,
			data_pkt_ccd_v_start_i             => s_registered_dpkt_params.image.ccd_v_start,
			data_pkt_ccd_v_end_i               => s_registered_dpkt_params.image.ccd_v_end,
			data_pkt_ccd_img_v_end_i           => s_registered_dpkt_params.image.ccd_img_v_end_left_buffer,
			data_pkt_ccd_ovs_v_end_i           => s_registered_dpkt_params.image.ccd_ovs_v_end_left_buffer,
			data_pkt_ccd_h_start_i             => s_registered_dpkt_params.image.ccd_h_start,
			data_pkt_ccd_h_end_i               => s_registered_dpkt_params.image.ccd_h_end_left_buffer,
			data_pkt_protocol_id_i             => s_registered_dpkt_params.image.protocol_id,
			data_pkt_logical_addr_i            => s_registered_dpkt_params.image.logical_addr,
			data_pkt_start_delay_i             => s_registered_dpkt_params.image.start_delay,
			data_pkt_skip_delay_i              => s_registered_dpkt_params.image.skip_delay,
			data_pkt_line_delay_i              => s_registered_dpkt_params.image.line_delay,
			data_pkt_adc_delay_i               => s_registered_dpkt_params.image.adc_delay,
			masking_buffer_overflow_i          => masking_buffer_overflow_i,
			imgdata_send_buffer_control_i      => s_left_imgdata_send_buffer_control,
			fee_output_buffer_overflowed_o     => fee_left_output_buffer_overflowed_o,
			imgdataman_finished_o              => s_left_imgdataman_status.finished,
			imgdata_headerdata_o               => open,
			fee_window_data_read_o             => fee_left_window_data_read_o,
			fee_window_mask_read_o             => fee_left_window_mask_read_o,
			imgdata_send_buffer_status_o       => s_left_imgdata_send_buffer_status,
			imgdata_send_double_buffer_empty_o => s_left_imgdata_send_double_buffer_empty
		);

	-- fee right image data manager instantiation
	fee_right_imgdata_controller_top_inst : entity work.fee_imgdata_controller_top
		port map(
			clk_i                              => clk_i,
			rst_i                              => rst_i,
			fee_current_timecode_i             => fee_current_timecode_i,
			dataman_sync_i                     => s_dataman_sync,
			imgdataman_start_i                 => s_right_imgdataman_control.start,
			imgdataman_reset_i                 => s_right_imgdataman_control.reset,
			fee_current_frame_number_i         => s_current_frame_number,
			fee_current_frame_counter_i        => s_current_frame_counter,
			fee_machine_clear_i                => fee_machine_clear_i,
			fee_machine_stop_i                 => fee_machine_stop_i,
			fee_machine_start_i                => fee_machine_start_i,
			fee_digitalise_en_i                => s_registered_dpkt_params.transmission.digitalise_en,
			fee_windowing_en_i                 => s_registered_dpkt_params.transmission.windowing_en,
			fee_pattern_en_i                   => s_registered_dpkt_params.transmission.pattern_right_buffer_en,
			fee_window_data_i                  => fee_right_window_data_i,
			fee_window_mask_i                  => fee_right_window_mask_i,
			fee_window_data_valid_i            => fee_right_window_data_valid_i,
			fee_window_mask_valid_i            => fee_right_window_mask_valid_i,
			fee_window_data_ready_i            => fee_right_window_data_ready_i,
			fee_window_mask_ready_i            => fee_right_window_mask_ready_i,
			data_pkt_ccd_x_size_i              => s_registered_dpkt_params.image.ccd_x_size,
			data_pkt_ccd_y_size_i              => s_registered_dpkt_params.image.ccd_y_size,
			data_pkt_data_y_size_i             => s_registered_dpkt_params.image.data_y_size,
			data_pkt_overscan_y_size_i         => s_registered_dpkt_params.image.overscan_y_size,
			data_pkt_packet_length_i           => s_registered_dpkt_params.image.packet_length,
			data_pkt_fee_mode_i(3)             => '0',
			data_pkt_fee_mode_i(2 downto 0)    => s_registered_dpkt_params.image.fee_mode_right_buffer,
			data_pkt_aeb_number_i              => s_registered_dpkt_params.image.ccd_number_right_buffer,
			data_pkt_ccd_id_i                  => s_registered_dpkt_params.image.ccd_id_right_buffer,
			data_pkt_ccd_side_i                => s_registered_dpkt_params.image.ccd_side_right_buffer,
			data_pkt_ccd_v_start_i             => s_registered_dpkt_params.image.ccd_v_start,
			data_pkt_ccd_v_end_i               => s_registered_dpkt_params.image.ccd_v_end,
			data_pkt_ccd_img_v_end_i           => s_registered_dpkt_params.image.ccd_img_v_end_right_buffer,
			data_pkt_ccd_ovs_v_end_i           => s_registered_dpkt_params.image.ccd_ovs_v_end_right_buffer,
			data_pkt_ccd_h_start_i             => s_registered_dpkt_params.image.ccd_h_start,
			data_pkt_ccd_h_end_i               => s_registered_dpkt_params.image.ccd_h_end_right_buffer,
			data_pkt_protocol_id_i             => s_registered_dpkt_params.image.protocol_id,
			data_pkt_logical_addr_i            => s_registered_dpkt_params.image.logical_addr,
			data_pkt_start_delay_i             => s_registered_dpkt_params.image.start_delay,
			data_pkt_skip_delay_i              => s_registered_dpkt_params.image.skip_delay,
			data_pkt_line_delay_i              => s_registered_dpkt_params.image.line_delay,
			data_pkt_adc_delay_i               => s_registered_dpkt_params.image.adc_delay,
			masking_buffer_overflow_i          => masking_buffer_overflow_i,
			imgdata_send_buffer_control_i      => s_right_imgdata_send_buffer_control,
			fee_output_buffer_overflowed_o     => fee_right_output_buffer_overflowed_o,
			imgdataman_finished_o              => s_right_imgdataman_status.finished,
			imgdata_headerdata_o               => open,
			fee_window_data_read_o             => fee_right_window_data_read_o,
			fee_window_mask_read_o             => fee_right_window_mask_read_o,
			imgdata_send_buffer_status_o       => s_right_imgdata_send_buffer_status,
			imgdata_send_double_buffer_empty_o => s_right_imgdata_send_double_buffer_empty
		);

	-- data transmitter top instantiation
	comm_data_transmitter_top_inst : entity work.comm_data_transmitter_top
		port map(
			clk_i                          => clk_i,
			rst_i                          => rst_i,
			comm_stop_i                    => fee_machine_stop_i,
			comm_start_i                   => fee_machine_start_i,
			channel_sync_i                 => fee_sync_signal_i,
			send_buffer_cfg_length_i       => s_registered_dpkt_params.image.packet_length,
			send_buffer_hkdata_status_i    => s_hkdata_send_buffer_status,
			send_buffer_leftimg_status_i   => s_left_imgdata_send_buffer_status,
			send_buffer_rightimg_status_i  => s_right_imgdata_send_buffer_status,
			spw_tx_ready_i                 => s_errinj_spw_tx_ready,
			housekeep_only_i               => s_dataman_hk_only,
			windowing_enabled_i            => s_registered_dpkt_params.transmission.windowing_en,
			windowing_packet_order_list_i  => s_registered_dpkt_params.windowing.packet_order_list,
			windowing_last_left_packet_i   => s_registered_dpkt_params.windowing.last_left_packet,
			windowing_last_right_packet_i  => s_registered_dpkt_params.windowing.last_right_packet,
			send_buffer_hkdata_control_o   => s_hkdata_send_buffer_control,
			send_buffer_leftimg_control_o  => s_left_imgdata_send_buffer_control,
			send_buffer_rightimg_control_o => s_right_imgdata_send_buffer_control,
			spw_tx_flag_o                  => s_errinj_spw_tx_flag,
			spw_tx_data_o                  => s_errinj_spw_tx_data,
			spw_tx_write_o                 => s_errinj_spw_tx_write
		);

	-- error injection instantiation
	error_injection_ent_inst : entity work.error_injection_ent
		port map(
			clk_i                 => clk_i,
			rst_i                 => rst_i,
			errinj_tx_disabled_i  => s_registered_dpkt_params.error_injection.tx_disabled,
			errinj_missing_pkts_i => s_registered_dpkt_params.error_injection.missing_pkts,
			errinj_missing_data_i => s_registered_dpkt_params.error_injection.missing_data,
			errinj_frame_num_i    => s_registered_dpkt_params.error_injection.frame_num,
			errinj_sequence_cnt_i => s_registered_dpkt_params.error_injection.sequence_cnt,
			errinj_data_cnt_i     => s_registered_dpkt_params.error_injection.data_cnt,
			errinj_n_repeat_i     => s_registered_dpkt_params.error_injection.n_repeat,
			errinj_spw_tx_write_i => s_errinj_spw_tx_write,
			errinj_spw_tx_flag_i  => s_errinj_spw_tx_flag,
			errinj_spw_tx_data_i  => s_errinj_spw_tx_data,
			fee_spw_tx_ready_i    => fee_spw_tx_ready_i,
			errinj_spw_tx_ready_o => s_errinj_spw_tx_ready,
			fee_spw_tx_write_o    => s_spw_tx_write,
			fee_spw_tx_flag_o     => fee_spw_tx_flag_o,
			fee_spw_tx_data_o     => fee_spw_tx_data_o
		);

	-- fee frame manager
	p_fee_frame_manager : process(clk_i, rst_i) is
		variable v_frame_cleared     : std_logic := '1';
		variable v_set_frame_counter : std_logic := '1';
	begin
		if (rst_i = '1') then
			s_current_frame_counter <= (others => '0');
			s_current_frame_number  <= (others => '0');
			v_frame_cleared         := '1';
			v_set_frame_counter     := '0';
		elsif rising_edge(clk_i) then

			--
			-- Definitions:
			--
			-- frame counter : full read-out cycle counter
			--   |  frame counter |
			--   |  15 downto  0  |
			--

			if (preset_frame_counter_set_i = '1') then
				v_set_frame_counter := '1';
			end if;

			s_current_frame_number <= (others => '0');
			if (fee_sync_signal_i = '1') then
				-- sync signal received
				if (v_set_frame_counter = '1') then
					v_set_frame_counter     := '0';
					v_frame_cleared         := '0';
					s_current_frame_counter <= preset_frame_counter_value_i;
				else
					if (v_frame_cleared = '1') then
						v_frame_cleared := '0';
					else
						-- update counters
						if (s_current_frame_counter = "1111111111111111") then
							s_current_frame_counter <= (others => '0');
						else
							s_current_frame_counter <= std_logic_vector(unsigned(s_current_frame_counter) + 1);
						end if;
					end if;
				end if;
			end if;

			if (fee_clear_frame_i = '1') then
				s_current_frame_counter <= (others => '0');
				v_frame_cleared         := '1';
			end if;

		end if;
	end process p_fee_frame_manager;

	-- data pkt configs register
	p_register_data_pkt_config : process(clk_i, rst_i) is
		variable v_fee_mode_left_buffer  : std_logic_vector(2 downto 0) := c_COMM_FFEE_INVALID_MODE;
		variable v_fee_mode_right_buffer : std_logic_vector(2 downto 0) := c_COMM_FFEE_INVALID_MODE;
	begin
		if (rst_i = '1') then
			s_registered_dpkt_params.image.logical_addr                   <= x"50";
			s_registered_dpkt_params.image.protocol_id                    <= x"F0";
			s_registered_dpkt_params.image.ccd_x_size                     <= std_logic_vector(to_unsigned(2295, 16));
			s_registered_dpkt_params.image.ccd_y_size                     <= std_logic_vector(to_unsigned(2265, 16));
			s_registered_dpkt_params.image.data_y_size                    <= std_logic_vector(to_unsigned(2255, 16));
			s_registered_dpkt_params.image.overscan_y_size                <= std_logic_vector(to_unsigned(10, 16));
			s_registered_dpkt_params.image.packet_length                  <= std_logic_vector(to_unsigned(4520, 16));
			s_registered_dpkt_params.image.fee_mode_hk                    <= c_COMM_FFEE_INVALID_MODE;
			s_registered_dpkt_params.image.fee_mode_left_buffer           <= c_COMM_FFEE_INVALID_MODE;
			s_registered_dpkt_params.image.fee_mode_right_buffer          <= c_COMM_FFEE_INVALID_MODE;
			s_registered_dpkt_params.image.ccd_number_hk                  <= std_logic_vector(to_unsigned(0, 2));
			s_registered_dpkt_params.image.ccd_number_left_buffer         <= std_logic_vector(to_unsigned(0, 2));
			s_registered_dpkt_params.image.ccd_number_right_buffer        <= std_logic_vector(to_unsigned(0, 2));
			s_registered_dpkt_params.image.ccd_id_left_buffer             <= std_logic_vector(to_unsigned(0, 2));
			s_registered_dpkt_params.image.ccd_id_right_buffer            <= std_logic_vector(to_unsigned(0, 2));
			s_registered_dpkt_params.image.ccd_side_hk                    <= c_COMM_FFEE_CCD_SIDE_E;
			s_registered_dpkt_params.image.ccd_side_left_buffer           <= c_COMM_FFEE_CCD_SIDE_E;
			s_registered_dpkt_params.image.ccd_side_right_buffer          <= c_COMM_FFEE_CCD_SIDE_E;
			s_registered_dpkt_params.image.ccd_v_start                    <= (others => '0');
			s_registered_dpkt_params.image.ccd_v_end                      <= (others => '0');
			s_registered_dpkt_params.image.ccd_img_v_end_left_buffer      <= (others => '0');
			s_registered_dpkt_params.image.ccd_img_v_end_right_buffer     <= (others => '0');
			s_registered_dpkt_params.image.ccd_ovs_v_end_left_buffer      <= (others => '0');
			s_registered_dpkt_params.image.ccd_ovs_v_end_right_buffer     <= (others => '0');
			s_registered_dpkt_params.image.ccd_h_start                    <= (others => '0');
			s_registered_dpkt_params.image.ccd_h_end_left_buffer          <= (others => '0');
			s_registered_dpkt_params.image.ccd_h_end_right_buffer         <= (others => '0');
			s_registered_dpkt_params.image.start_delay                    <= (others => '0');
			s_registered_dpkt_params.image.skip_delay                     <= (others => '0');
			s_registered_dpkt_params.image.line_delay                     <= (others => '0');
			s_registered_dpkt_params.image.adc_delay                      <= (others => '0');
			s_registered_dpkt_params.transmission.digitalise_en           <= '1';
			s_registered_dpkt_params.transmission.pattern_left_buffer_en  <= '0';
			s_registered_dpkt_params.transmission.pattern_right_buffer_en <= '0';
			s_registered_dpkt_params.error_injection.tx_disabled          <= '0';
			s_registered_dpkt_params.error_injection.missing_pkts         <= '0';
			s_registered_dpkt_params.error_injection.missing_data         <= '0';
			s_registered_dpkt_params.error_injection.frame_num            <= std_logic_vector(to_unsigned(0, 2));
			s_registered_dpkt_params.error_injection.sequence_cnt         <= std_logic_vector(to_unsigned(0, 16));
			s_registered_dpkt_params.error_injection.data_cnt             <= std_logic_vector(to_unsigned(0, 16));
			s_registered_dpkt_params.error_injection.n_repeat             <= std_logic_vector(to_unsigned(0, 16));
			s_registered_dpkt_params.windowing.packet_order_list          <= (others => '0');
			s_registered_dpkt_params.windowing.last_left_packet           <= (others => '0');
			s_registered_dpkt_params.windowing.last_right_packet          <= (others => '0');
			s_registered_left_buffer_activated                            <= '0';
			s_registered_right_buffer_activated                           <= '0';
			s_registered_windowing_left_buffer_en                         <= '1';
			s_registered_windowing_right_buffer_en                        <= '1';
			v_fee_mode_left_buffer                                        := c_COMM_FFEE_INVALID_MODE;
			v_fee_mode_right_buffer                                       := c_COMM_FFEE_INVALID_MODE;
		elsif rising_edge(clk_i) then
			-- check if a sync signal was received
			if (fee_sync_signal_i = '1') then
				-- register ccd side activated
				s_registered_left_buffer_activated                        <= fee_left_buffer_activated_i;
				s_registered_right_buffer_activated                       <= fee_right_buffer_activated_i;
				-- register data pkt config
				s_registered_dpkt_params.image.logical_addr               <= data_pkt_logical_addr_i;
				s_registered_dpkt_params.image.protocol_id                <= data_pkt_protocol_id_i;
				s_registered_dpkt_params.image.ccd_x_size                 <= data_pkt_ccd_x_size_i;
				s_registered_dpkt_params.image.ccd_y_size                 <= data_pkt_ccd_y_size_i;
				s_registered_dpkt_params.image.data_y_size                <= data_pkt_data_y_size_i;
				s_registered_dpkt_params.image.overscan_y_size            <= data_pkt_overscan_y_size_i;
				--				s_registered_dpkt_params.image.packet_length          <= data_pkt_packet_length_i;
				-- crc is added after the send buffer, so its size need to be disconted from the send buffer config lenght to ensure the right packet size
				s_registered_dpkt_params.image.packet_length              <= std_logic_vector(unsigned(data_pkt_packet_length_i) - c_COMM_DT_CRC_SIZE);
				s_registered_dpkt_params.image.ccd_number_left_buffer     <= data_pkt_ccd_number_left_buffer_i;
				s_registered_dpkt_params.image.ccd_number_right_buffer    <= data_pkt_ccd_number_right_buffer_i;
				s_registered_dpkt_params.image.ccd_id_left_buffer         <= data_pkt_ccd_number_left_buffer_i;
				s_registered_dpkt_params.image.ccd_id_right_buffer        <= data_pkt_ccd_number_right_buffer_i;
				s_registered_dpkt_params.image.ccd_side_left_buffer       <= data_pkt_ccd_side_left_buffer_i;
				s_registered_dpkt_params.image.ccd_side_right_buffer      <= data_pkt_ccd_side_right_buffer_i;
				s_registered_dpkt_params.image.ccd_v_start                <= data_pkt_ccd_v_start_i;
				s_registered_dpkt_params.image.ccd_v_end                  <= data_pkt_ccd_v_end_i;
				s_registered_dpkt_params.image.ccd_img_v_end_left_buffer  <= data_pkt_ccd_img_v_end_i;
				s_registered_dpkt_params.image.ccd_img_v_end_right_buffer <= data_pkt_ccd_img_v_end_i;
				s_registered_dpkt_params.image.ccd_ovs_v_end_left_buffer  <= data_pkt_ccd_ovs_v_end_i;
				s_registered_dpkt_params.image.ccd_ovs_v_end_right_buffer <= data_pkt_ccd_ovs_v_end_i;
				s_registered_dpkt_params.image.ccd_h_start                <= data_pkt_ccd_h_start_i;
				s_registered_dpkt_params.image.ccd_h_end_left_buffer      <= data_pkt_ccd_h_end_i;
				s_registered_dpkt_params.image.ccd_h_end_right_buffer     <= data_pkt_ccd_h_end_i;
				s_registered_dpkt_params.image.start_delay                <= data_pkt_start_delay_i;
				s_registered_dpkt_params.image.skip_delay                 <= data_pkt_skip_delay_i;
				s_registered_dpkt_params.image.line_delay                 <= data_pkt_line_delay_i;
				s_registered_dpkt_params.image.adc_delay                  <= data_pkt_adc_delay_i;
				-- register masking settings
				s_registered_dpkt_params.transmission.digitalise_en       <= (fee_digitalise_en_i) and (fee_readout_en_i);
				case (data_pkt_fee_mode_left_buffer_i) is
					when c_DPKT_OFF_MODE =>
						-- F-FEE Off Mode
						v_fee_mode_left_buffer                                       := c_COMM_FFEE_INVALID_MODE;
						s_registered_windowing_left_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_left_buffer_en <= '0';
					when c_DPKT_ON_MODE =>
						-- F-FEE On Mode
						v_fee_mode_left_buffer                                       := c_COMM_FFEE_INVALID_MODE;
						s_registered_windowing_left_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_left_buffer_en <= '0';
					when c_DPKT_FULLIMAGE_PATTERN_DEB_MODE =>
						-- F-FEE Full-Image Pattern DEB Mode
						v_fee_mode_left_buffer                                       := c_COMM_FFEE_FULL_IMAGE_PATTERN_MODE;
						s_registered_windowing_left_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_left_buffer_en <= '1';
						s_registered_dpkt_params.image.ccd_img_v_end_left_buffer     <= data_pkt_deb_ccd_img_v_end_i;
						s_registered_dpkt_params.image.ccd_ovs_v_end_left_buffer     <= data_pkt_deb_ccd_ovs_v_end_i;
						s_registered_dpkt_params.image.ccd_h_end_left_buffer         <= data_pkt_deb_ccd_h_end_i;
					when c_DPKT_WINDOWING_PATTERN_DEB_MODE =>
						-- F-FEE Windowing Pattern DEB Mode
						v_fee_mode_left_buffer                                       := c_COMM_FFEE_WINDOWING_PATTERN_MODE;
						s_registered_windowing_left_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_left_buffer_en <= '1';
						s_registered_dpkt_params.image.ccd_img_v_end_left_buffer     <= data_pkt_deb_ccd_img_v_end_i;
						s_registered_dpkt_params.image.ccd_ovs_v_end_left_buffer     <= data_pkt_deb_ccd_ovs_v_end_i;
						s_registered_dpkt_params.image.ccd_h_end_left_buffer         <= data_pkt_deb_ccd_h_end_i;
					when c_DPKT_STANDBY_MODE =>
						-- F-FEE Standby Mode
						v_fee_mode_left_buffer                                       := c_COMM_FFEE_INVALID_MODE;
						s_registered_windowing_left_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_left_buffer_en <= '0';
					when c_DPKT_FULLIMAGE_PATTERN_AEB_MODE =>
						-- F-FEE Full-Image Pattern AEB Mode
						v_fee_mode_left_buffer                                       := c_COMM_FFEE_FULL_IMAGE_PATTERN_MODE;
						s_registered_windowing_left_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_left_buffer_en <= '1';
						s_registered_dpkt_params.image.ccd_img_v_end_left_buffer     <= data_pkt_aeb_ccd_img_v_end_left_buffer_i;
						s_registered_dpkt_params.image.ccd_h_end_left_buffer         <= data_pkt_aeb_ccd_h_end_left_buffer_i;
						s_registered_dpkt_params.image.ccd_id_left_buffer            <= data_pkt_aeb_ccd_id_left_buffer_i;
					when c_DPKT_WINDOWING_PATTERN_AEB_MODE =>
						-- F-FEE Windowing Pattern AEB Mode
						v_fee_mode_left_buffer                                       := c_COMM_FFEE_WINDOWING_PATTERN_MODE;
						s_registered_windowing_left_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_left_buffer_en <= '1';
						s_registered_dpkt_params.image.ccd_img_v_end_left_buffer     <= data_pkt_aeb_ccd_img_v_end_left_buffer_i;
						s_registered_dpkt_params.image.ccd_h_end_left_buffer         <= data_pkt_aeb_ccd_h_end_left_buffer_i;
						s_registered_dpkt_params.image.ccd_id_left_buffer            <= data_pkt_aeb_ccd_id_left_buffer_i;
					when c_DPKT_FULLIMAGE_MODE =>
						-- F-FEE Full-Image Mode
						v_fee_mode_left_buffer                                       := c_COMM_FFEE_FULL_IMAGE_MODE;
						s_registered_windowing_left_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_left_buffer_en <= '0';
					when c_DPKT_WINDOWING_MODE =>
						-- F-FEE Windowing Mode	
						v_fee_mode_left_buffer                                       := c_COMM_FFEE_WINDOWING_MODE;
						s_registered_windowing_left_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_left_buffer_en <= '0';
					when others =>
						-- Undefined Mode
						v_fee_mode_left_buffer                                       := c_COMM_FFEE_INVALID_MODE;
						s_registered_windowing_left_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_left_buffer_en <= '0';
				end case;
				case (data_pkt_fee_mode_right_buffer_i) is
					when c_DPKT_OFF_MODE =>
						-- F-FEE Off Mode
						v_fee_mode_right_buffer                                       := c_COMM_FFEE_INVALID_MODE;
						s_registered_windowing_right_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_right_buffer_en <= '0';
					when c_DPKT_ON_MODE =>
						-- F-FEE On Mode
						v_fee_mode_right_buffer                                       := c_COMM_FFEE_INVALID_MODE;
						s_registered_windowing_right_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_right_buffer_en <= '0';
					when c_DPKT_FULLIMAGE_PATTERN_DEB_MODE =>
						-- F-FEE Full-Image Pattern DEB Mode
						v_fee_mode_right_buffer                                       := c_COMM_FFEE_FULL_IMAGE_PATTERN_MODE;
						s_registered_windowing_right_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_right_buffer_en <= '1';
						s_registered_dpkt_params.image.ccd_img_v_end_right_buffer     <= data_pkt_deb_ccd_img_v_end_i;
						s_registered_dpkt_params.image.ccd_ovs_v_end_right_buffer     <= data_pkt_deb_ccd_ovs_v_end_i;
						s_registered_dpkt_params.image.ccd_h_end_right_buffer         <= data_pkt_deb_ccd_h_end_i;
					when c_DPKT_WINDOWING_PATTERN_DEB_MODE =>
						-- F-FEE Windowing Pattern DEB Mode
						v_fee_mode_right_buffer                                       := c_COMM_FFEE_WINDOWING_PATTERN_MODE;
						s_registered_windowing_right_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_right_buffer_en <= '1';
						s_registered_dpkt_params.image.ccd_img_v_end_right_buffer     <= data_pkt_deb_ccd_img_v_end_i;
						s_registered_dpkt_params.image.ccd_ovs_v_end_right_buffer     <= data_pkt_deb_ccd_ovs_v_end_i;
						s_registered_dpkt_params.image.ccd_h_end_right_buffer         <= data_pkt_deb_ccd_h_end_i;
					when c_DPKT_STANDBY_MODE =>
						-- F-FEE Standby Mode
						v_fee_mode_right_buffer                                       := c_COMM_FFEE_INVALID_MODE;
						s_registered_windowing_right_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_right_buffer_en <= '0';
					when c_DPKT_FULLIMAGE_PATTERN_AEB_MODE =>
						-- F-FEE Full-Image Pattern AEB Mode
						v_fee_mode_right_buffer                                       := c_COMM_FFEE_FULL_IMAGE_PATTERN_MODE;
						s_registered_windowing_right_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_right_buffer_en <= '1';
						s_registered_dpkt_params.image.ccd_img_v_end_right_buffer     <= data_pkt_aeb_ccd_img_v_end_right_buffer_i;
						s_registered_dpkt_params.image.ccd_h_end_right_buffer         <= data_pkt_aeb_ccd_h_end_right_buffer_i;
						s_registered_dpkt_params.image.ccd_id_right_buffer            <= data_pkt_aeb_ccd_id_right_buffer_i;
					when c_DPKT_WINDOWING_PATTERN_AEB_MODE =>
						-- F-FEE Windowing Pattern AEB Mode
						v_fee_mode_right_buffer                                       := c_COMM_FFEE_WINDOWING_PATTERN_MODE;
						s_registered_windowing_right_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_right_buffer_en <= '1';
						s_registered_dpkt_params.image.ccd_img_v_end_right_buffer     <= data_pkt_aeb_ccd_img_v_end_right_buffer_i;
						s_registered_dpkt_params.image.ccd_h_end_right_buffer         <= data_pkt_aeb_ccd_h_end_right_buffer_i;
						s_registered_dpkt_params.image.ccd_id_right_buffer            <= data_pkt_aeb_ccd_id_right_buffer_i;
					when c_DPKT_FULLIMAGE_MODE =>
						-- F-FEE Full-Image Mode
						v_fee_mode_right_buffer                                       := c_COMM_FFEE_FULL_IMAGE_MODE;
						s_registered_windowing_right_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_right_buffer_en <= '0';
					when c_DPKT_WINDOWING_MODE =>
						-- F-FEE Windowing Mode	
						v_fee_mode_right_buffer                                       := c_COMM_FFEE_WINDOWING_MODE;
						s_registered_windowing_right_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_right_buffer_en <= '0';
					when others =>
						-- Undefined Mode
						v_fee_mode_right_buffer                                       := c_COMM_FFEE_INVALID_MODE;
						s_registered_windowing_right_buffer_en                        <= '0';
						s_registered_dpkt_params.transmission.pattern_right_buffer_en <= '0';
				end case;
				s_registered_dpkt_params.image.fee_mode_left_buffer       <= v_fee_mode_left_buffer;
				s_registered_dpkt_params.image.fee_mode_right_buffer      <= v_fee_mode_right_buffer;
				-- register housekeeping settings
				if (fee_left_buffer_activated_i = '1') and (fee_right_buffer_activated_i = '0') then
					-- only left buffer is activated
					s_registered_dpkt_params.image.ccd_number_hk <= data_pkt_ccd_number_left_buffer_i;
					s_registered_dpkt_params.image.ccd_side_hk   <= data_pkt_ccd_side_left_buffer_i;
					s_registered_dpkt_params.image.fee_mode_hk   <= v_fee_mode_left_buffer;
				elsif (fee_left_buffer_activated_i = '0') and (fee_right_buffer_activated_i = '1') then
					-- only right buffer is activated
					s_registered_dpkt_params.image.ccd_number_hk <= data_pkt_ccd_number_right_buffer_i;
					s_registered_dpkt_params.image.ccd_side_hk   <= data_pkt_ccd_side_right_buffer_i;
					s_registered_dpkt_params.image.fee_mode_hk   <= v_fee_mode_right_buffer;
				else
					-- both buffers activated or no buffer activated, hk will use the left buffer as reference
					s_registered_dpkt_params.image.ccd_number_hk <= data_pkt_ccd_number_left_buffer_i;
					s_registered_dpkt_params.image.ccd_side_hk   <= data_pkt_ccd_side_left_buffer_i;
					s_registered_dpkt_params.image.fee_mode_hk   <= v_fee_mode_left_buffer;
				end if;
				-- register error injection settings
				s_registered_dpkt_params.error_injection.tx_disabled      <= errinj_tx_disabled_i;
				s_registered_dpkt_params.error_injection.missing_pkts     <= errinj_missing_pkts_i;
				s_registered_dpkt_params.error_injection.missing_data     <= errinj_missing_data_i;
				s_registered_dpkt_params.error_injection.frame_num        <= errinj_frame_num_i;
				s_registered_dpkt_params.error_injection.sequence_cnt     <= errinj_sequence_cnt_i;
				s_registered_dpkt_params.error_injection.data_cnt         <= errinj_data_cnt_i;
				s_registered_dpkt_params.error_injection.n_repeat         <= errinj_n_repeat_i;
				-- register windowing settings
				s_registered_dpkt_params.windowing.packet_order_list      <= windowing_packet_order_list_i;
				s_registered_dpkt_params.windowing.last_left_packet       <= windowing_last_left_packet_i;
				s_registered_dpkt_params.windowing.last_right_packet      <= windowing_last_right_packet_i;
			end if;
		end if;
	end process p_register_data_pkt_config;

	p_data_manager_sync_gen : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then
			s_dataman_left_buffer_sync     <= '0';
			s_dataman_right_buffer_sync    <= '0';
			s_dataman_left_buffer_hk_only  <= '0';
			s_dataman_right_buffer_hk_only <= '0';
			s_spw_write_mask               <= '0';
		elsif rising_edge(clk_i) then
			s_dataman_left_buffer_sync  <= '0';
			s_dataman_right_buffer_sync <= '0';
			-- check if a sync signal was received
			if (fee_sync_signal_i = '1') then
				-- sync signal was received

				-- check the left side is activated
				if (fee_left_buffer_activated_i = '1') then
					-- left side is activated
					case (data_pkt_fee_mode_left_buffer_i) is
						when c_DPKT_FULLIMAGE_PATTERN_DEB_MODE =>
							-- F-FEE Full-Image Pattern DEB Mode
							s_dataman_left_buffer_sync    <= '1';
							s_dataman_left_buffer_hk_only <= '0';
						when c_DPKT_WINDOWING_PATTERN_DEB_MODE =>
							-- F-FEE Windowing Pattern DEB Mode
							s_dataman_left_buffer_sync    <= '1';
							s_dataman_left_buffer_hk_only <= '0';
						when c_DPKT_FULLIMAGE_PATTERN_AEB_MODE =>
							-- F-FEE Full-Image Pattern AEB Mode
							s_dataman_left_buffer_sync    <= '1';
							s_dataman_left_buffer_hk_only <= '0';
						when c_DPKT_WINDOWING_PATTERN_AEB_MODE =>
							-- F-FEE Windowing Pattern AEB Mode
							s_dataman_left_buffer_sync    <= '1';
							s_dataman_left_buffer_hk_only <= '0';
						when c_DPKT_FULLIMAGE_MODE =>
							-- F-FEE Full-Image Mode
							s_dataman_left_buffer_sync    <= '1';
							s_dataman_left_buffer_hk_only <= '0';
						when c_DPKT_WINDOWING_MODE =>
							-- F-FEE Windowing Mode
							s_dataman_left_buffer_sync    <= '1';
							s_dataman_left_buffer_hk_only <= '0';
						when others =>
							-- Undefined Mode
							s_dataman_left_buffer_sync    <= '0';
							s_dataman_left_buffer_hk_only <= '0';
					end case;
				else
					-- left side is not activated
					case (data_pkt_fee_mode_left_buffer_i) is
						when c_DPKT_OFF_MODE =>
							-- F-FEE Off Mode
							s_dataman_left_buffer_sync    <= '0';
							s_dataman_left_buffer_hk_only <= '0';
						when c_DPKT_ON_MODE =>
							-- F-FEE On Mode
							s_dataman_left_buffer_sync    <= '0';
							s_dataman_left_buffer_hk_only <= '0';
						when c_DPKT_STANDBY_MODE =>
							-- F-FEE Standby Mode
							s_dataman_left_buffer_sync    <= '0';
							s_dataman_left_buffer_hk_only <= '0';
						when others =>
							-- Undefined Mode
							s_dataman_left_buffer_sync    <= '0';
							s_dataman_left_buffer_hk_only <= '0';
					end case;
				end if;

				-- check the right side is activated
				if (fee_right_buffer_activated_i = '1') then
					-- right side is activated
					case (data_pkt_fee_mode_right_buffer_i) is
						when c_DPKT_FULLIMAGE_PATTERN_DEB_MODE =>
							-- F-FEE Full-Image Pattern DEB Mode
							s_dataman_right_buffer_sync    <= '1';
							s_dataman_right_buffer_hk_only <= '0';
						when c_DPKT_WINDOWING_PATTERN_DEB_MODE =>
							-- F-FEE Windowing Pattern DEB Mode
							s_dataman_right_buffer_sync    <= '1';
							s_dataman_right_buffer_hk_only <= '0';
						when c_DPKT_FULLIMAGE_PATTERN_AEB_MODE =>
							-- F-FEE Full-Image Pattern AEB Mode
							s_dataman_right_buffer_sync    <= '1';
							s_dataman_right_buffer_hk_only <= '0';
						when c_DPKT_WINDOWING_PATTERN_AEB_MODE =>
							-- F-FEE Windowing Pattern AEB Mode
							s_dataman_right_buffer_sync    <= '1';
							s_dataman_right_buffer_hk_only <= '0';
						when c_DPKT_FULLIMAGE_MODE =>
							-- F-FEE Full-Image Mode
							s_dataman_right_buffer_sync    <= '1';
							s_dataman_right_buffer_hk_only <= '0';
						when c_DPKT_WINDOWING_MODE =>
							-- F-FEE Windowing Mode
							s_dataman_right_buffer_sync    <= '1';
							s_dataman_right_buffer_hk_only <= '0';
						when others =>
							-- Undefined Mode
							s_dataman_right_buffer_sync    <= '0';
							s_dataman_right_buffer_hk_only <= '0';
					end case;
				else
					-- right side is not activated
					case (data_pkt_fee_mode_right_buffer_i) is
						when c_DPKT_OFF_MODE =>
							-- F-FEE Off Mode
							s_dataman_right_buffer_sync    <= '0';
							s_dataman_right_buffer_hk_only <= '0';
						when c_DPKT_ON_MODE =>
							-- F-FEE On Mode
							s_dataman_right_buffer_sync    <= '0';
							s_dataman_right_buffer_hk_only <= '0';
						when c_DPKT_STANDBY_MODE =>
							-- F-FEE Standby Mode
							s_dataman_right_buffer_sync    <= '0';
							s_dataman_right_buffer_hk_only <= '0';
						when others =>
							-- Undefined Mode
							s_dataman_right_buffer_sync    <= '0';
							s_dataman_right_buffer_hk_only <= '0';
					end case;
				end if;

				-- check if the spw link is running
				if (fee_spw_link_running_i = '1') then
					-- the spw link is running, do not mask the codec write
					s_spw_write_mask <= '1';
				else
					-- the spw link is not running, do mask the codec write
					s_spw_write_mask <= '0';
				end if;

			end if;
		end if;
	end process p_data_manager_sync_gen;

	-- signals assingments --

	-- registered parameters signals assingments 
	s_registered_dpkt_params.transmission.windowing_en <= (s_registered_windowing_left_buffer_en) or (s_registered_windowing_right_buffer_en);

	-- dataman signals assingments
	s_dataman_sync    <= (s_dataman_left_buffer_sync) or (s_dataman_right_buffer_sync);
	s_dataman_hk_only <= (s_dataman_left_buffer_hk_only) or (s_dataman_right_buffer_hk_only);

	-- outputs generation
	fee_frame_counter_o <= s_current_frame_counter;
	fee_frame_number_o  <= s_current_frame_number;
	fee_spw_tx_write_o  <= (s_spw_tx_write) and (s_spw_write_mask);

end architecture RTL;
