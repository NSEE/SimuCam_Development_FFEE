library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_spacewire_registers_pkg.all;
use work.fee_data_controller_pkg.all;

entity comm_config_avalon_mm_stimulli is
    port(
        clk_i                       : in  std_logic;
        rst_i                       : in  std_logic;
        avs_config_rd_regs_i        : in  t_windowing_read_registers;
        avs_config_wr_regs_o        : out t_windowing_write_registers;
        avs_config_rd_readdata_o    : out std_logic_vector(31 downto 0);
        avs_config_rd_waitrequest_o : out std_logic;
        avs_config_wr_waitrequest_o : out std_logic
    );
end entity comm_config_avalon_mm_stimulli;

architecture RTL of comm_config_avalon_mm_stimulli is

    signal s_counter : natural := 0;
    signal s_times   : natural := 0;

    constant c_HEADER_ERRINJ_FIELD_ID_MODE      : std_logic_vector(3 downto 0) := x"0";
    constant c_HEADER_ERRINJ_FIELD_ID_LAST_PKT  : std_logic_vector(3 downto 0) := x"1";
    constant c_HEADER_ERRINJ_FIELD_ID_CCD_SIDE  : std_logic_vector(3 downto 0) := x"2";
    constant c_HEADER_ERRINJ_FIELD_ID_CCD_NUM   : std_logic_vector(3 downto 0) := x"3";
    constant c_HEADER_ERRINJ_FIELD_ID_FRAME_NUM : std_logic_vector(3 downto 0) := x"4";
    constant c_HEADER_ERRINJ_FIELD_ID_PKT_TYPE  : std_logic_vector(3 downto 0) := x"5";
    constant c_HEADER_ERRINJ_FIELD_ID_FRAME_CNT : std_logic_vector(3 downto 0) := x"6";
    constant c_HEADER_ERRINJ_FIELD_ID_SEQ_CNT   : std_logic_vector(3 downto 0) := x"7";
    constant c_HEADER_ERRINJ_FIELD_ID_LENGTH    : std_logic_vector(3 downto 0) := x"8";

    constant c_RMAP_ERRINJ_ERR_ID_INIT_LOG_ADDR      : std_logic_vector(3 downto 0) := x"0";
    constant c_RMAP_ERRINJ_ERR_ID_INSTRUCTIONS       : std_logic_vector(3 downto 0) := x"1";
    constant c_RMAP_ERRINJ_ERR_ID_INS_PKT_TYPE       : std_logic_vector(3 downto 0) := x"2";
    constant c_RMAP_ERRINJ_ERR_ID_INS_CMD_WRITE_READ : std_logic_vector(3 downto 0) := x"3";
    constant c_RMAP_ERRINJ_ERR_ID_INS_CMD_VERIF_DATA : std_logic_vector(3 downto 0) := x"4";
    constant c_RMAP_ERRINJ_ERR_ID_INS_CMD_REPLY      : std_logic_vector(3 downto 0) := x"5";
    constant c_RMAP_ERRINJ_ERR_ID_INS_CMD_INC_ADDR   : std_logic_vector(3 downto 0) := x"6";
    constant c_RMAP_ERRINJ_ERR_ID_INS_REPLY_ADDR_LEN : std_logic_vector(3 downto 0) := x"7";
    constant c_RMAP_ERRINJ_ERR_ID_STATUS             : std_logic_vector(3 downto 0) := x"8";
    constant c_RMAP_ERRINJ_ERR_ID_TARG_LOG_ADDR      : std_logic_vector(3 downto 0) := x"9";
    constant c_RMAP_ERRINJ_ERR_ID_TRANSACTION_ID     : std_logic_vector(3 downto 0) := x"A";
    constant c_RMAP_ERRINJ_ERR_ID_DATA_LENGTH        : std_logic_vector(3 downto 0) := x"B";
    constant c_RMAP_ERRINJ_ERR_ID_HEADER_CRC         : std_logic_vector(3 downto 0) := x"C";
    constant c_RMAP_ERRINJ_ERR_ID_HEADER_EEP         : std_logic_vector(3 downto 0) := x"D";
    constant c_RMAP_ERRINJ_ERR_ID_DATA_CRC           : std_logic_vector(3 downto 0) := x"E";
    constant c_RMAP_ERRINJ_ERR_ID_DATA_EEP           : std_logic_vector(3 downto 0) := x"F";

begin

    p_comm_config_avalon_mm_stimulli : process(clk_i, rst_i) is
        procedure p_reset_registers is
        begin

            -- Write Registers Reset/Default State

            -- Comm Device Address Register : Comm Device Base Address
            avs_config_wr_regs_o.comm_dev_addr_reg.comm_dev_base_addr                                            <= (others => '0');
            -- Comm IRQ Control Register : Comm Global IRQ Enable
            avs_config_wr_regs_o.comm_irq_control_reg.comm_global_irq_en                                         <= '0';
            -- SpaceWire Device Address Register : SpaceWire Device Base Address
            avs_config_wr_regs_o.spw_dev_addr_reg.spw_dev_base_addr                                              <= (others => '0');
            -- SpaceWire Link Config Register : SpaceWire Link Config Enable
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_enable                                           <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_disconnect                                       <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_linkstart                                        <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config Autostart
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_autostart                                        <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_txdivcnt                                         <= x"01";
            -- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
            avs_config_wr_regs_o.spw_timecode_config_reg.timecode_clear                                          <= '0';
            -- SpaceWire Timecode Config Register : SpaceWire Timecode Transmission Enable
            avs_config_wr_regs_o.spw_timecode_config_reg.timecode_trans_en                                       <= '1';
            -- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Trigger Enable
            avs_config_wr_regs_o.spw_timecode_config_reg.timecode_sync_trigger_en                                <= '1';
            -- SpaceWire Timecode Config Register : SpaceWire Timecode Time Offset
            avs_config_wr_regs_o.spw_timecode_config_reg.timecode_time_offset                                    <= (others => '0');
            -- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Delay Trigger Enable
            avs_config_wr_regs_o.spw_timecode_config_reg.timecode_sync_delay_trigger_en                          <= '0';
            -- SpaceWire Timecode Config Register : SpaceWire Timecode Sync Delay Value
            avs_config_wr_regs_o.spw_timecode_config_reg.timecode_sync_delay_value                               <= (others => '0');
            -- FEE Buffers Device Address Register : FEE Buffers Device Base Address
            avs_config_wr_regs_o.fee_buffers_dev_addr_reg.fee_buffers_dev_base_addr                              <= (others => '0');
            -- FEE Machine Config Register : FEE Machine Clear
            avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_clear                                        <= '0';
            -- FEE Machine Config Register : FEE Machine Stop
            avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_stop                                         <= '0';
            -- FEE Machine Config Register : FEE Machine Start
            avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_start                                        <= '0';
            -- FEE Machine Config Register : FEE Buffer Overflow Enable
            avs_config_wr_regs_o.fee_machine_config_reg.fee_buffer_overflow_en                                   <= '1';
            -- FEE Machine Config Register : FEE Left Pixel Storage Size
            avs_config_wr_regs_o.fee_machine_config_reg.left_pixels_storage_size                                 <= (others => '0');
            -- FEE Machine Config Register : FEE Right Pixel Storage Size
            avs_config_wr_regs_o.fee_machine_config_reg.right_pixels_storage_size                                <= (others => '0');
            -- FEE Machine Config Register : FEE Digitalise Enable
            avs_config_wr_regs_o.fee_machine_config_reg.fee_digitalise_en                                        <= '1';
            -- FEE Machine Config Register : FEE Readout Enable
            avs_config_wr_regs_o.fee_machine_config_reg.fee_readout_en                                           <= '1';
            -- FEE Machine Config Register : FEE Window List Enable
            avs_config_wr_regs_o.fee_machine_config_reg.fee_window_list_en                                       <= '1';
            -- FEE Machine Config Register : FEE Statistics Clear
            avs_config_wr_regs_o.fee_machine_config_reg.fee_statistics_clear                                     <= '0';
            --            -- FEE Buffers Config Register : Windowing Right Buffer Size Config
            --            avs_config_wr_regs_o.fee_buffers_config_reg.fee_right_buffer_size                                    <= (others => '1');
            --            -- FEE Buffers Config Register : Windowing Left Buffer Size Config
            --            avs_config_wr_regs_o.fee_buffers_config_reg.fee_left_buffer_size                                     <= (others => '1');
            -- FEE Buffers Data Control Register : Right Initial Read Address [High Dword]
            avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_initial_addr_high_dword                   <= (others => '0');
            -- FEE Buffers Data Control Register : Right Initial Read Address [Low Dword]
            avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_initial_addr_low_dword                    <= (others => '0');
            -- FEE Buffers Data Control Register : Right Read Data Length [Bytes]
            avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_data_length_bytes                         <= (others => '0');
            -- FEE Buffers Data Control Register : Right Data Read Start
            avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_start                                     <= '0';
            -- FEE Buffers Data Control Register : Right Data Read Reset
            avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_reset                                     <= '0';
            -- FEE Buffers Data Control Register : Left Initial Read Address [High Dword]
            avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_initial_addr_high_dword                    <= (others => '0');
            -- FEE Buffers Data Control Register : Left Initial Read Address [Low Dword]
            avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_initial_addr_low_dword                     <= (others => '0');
            -- FEE Buffers Data Control Register : Left Read Data Length [Bytes]
            avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_data_length_bytes                          <= (others => '0');
            -- FEE Buffers Data Control Register : Left Data Read Start
            avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_start                                      <= '0';
            -- FEE Buffers Data Control Register : Left Data Read Reset
            avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_reset                                      <= '0';
            -- FEE Buffers IRQ Control Register : FEE Right Buffer Empty IRQ Enable
            avs_config_wr_regs_o.fee_buffers_irq_control_reg.fee_right_buffer_controller_finished_en             <= '0';
            -- FEE Buffers IRQ Control Register : FEE Left Buffer Empty IRQ Enable
            avs_config_wr_regs_o.fee_buffers_irq_control_reg.fee_left_buffer_controller_finished_en              <= '0';
            -- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
            avs_config_wr_regs_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_controller_finished_flag_clear <= '0';
            -- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
            avs_config_wr_regs_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_controller_finished_flag_clear  <= '0';
            -- RMAP Device Address Register : RMAP Device Base Address
            avs_config_wr_regs_o.rmap_dev_addr_reg.rmap_dev_base_addr                                            <= (others => '0');
            -- RMAP Echoing Mode Config Register : RMAP Echoing Mode Enable
            avs_config_wr_regs_o.rmap_echoing_mode_config_reg.rmap_echoing_mode_enable                           <= '0';
            -- RMAP Echoing Mode Config Register : RMAP Echoing ID Enable
            avs_config_wr_regs_o.rmap_echoing_mode_config_reg.rmap_echoing_id_enable                             <= '0';
            -- RMAP Codec Config Register : RMAP Target Enable
            avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_enable                                        <= '1';
            -- RMAP Codec Config Register : RMAP Target Logical Address
            avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_logical_addr                                  <= x"51";
            -- RMAP Codec Config Register : RMAP Target Key
            avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_key                                           <= x"D1";
            -- RMAP Memory Config Register : RMAP Windowing Area Offset (High Dword)
            avs_config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_high_dword                          <= (others => '0');
            -- RMAP Memory Config Register : RMAP Windowing Area Offset (Low Dword)
            avs_config_wr_regs_o.rmap_memory_config_reg.rmap_win_area_offset_low_dword                           <= (others => '0');
            -- RMAP Memory Area Pointer Register : RMAP DEB Memory Area Pointer
            avs_config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_deb_area_ptr                                     <= (others => '0');
            -- RMAP Memory Area Pointer Register : RMAP AEB 1 Memory Area Pointer
            avs_config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_aeb1_area_ptr                                    <= (others => '0');
            -- RMAP Memory Area Pointer Register : RMAP AEB 2 Memory Area Pointer
            avs_config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_aeb2_area_ptr                                    <= (others => '0');
            -- RMAP Memory Area Pointer Register : RMAP AEB 3 Memory Area Pointer
            avs_config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_aeb3_area_ptr                                    <= (others => '0');
            -- RMAP Memory Area Pointer Register : RMAP AEB 4 Memory Area Pointer
            avs_config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_aeb4_area_ptr                                    <= (others => '0');
            -- RMAP IRQ Control Register : RMAP Write Config IRQ Enable
            avs_config_wr_regs_o.rmap_irq_control_reg.rmap_write_config_en                                       <= '0';
            -- RMAP IRQ Control Register : RMAP Write Window IRQ Enable
            avs_config_wr_regs_o.rmap_irq_control_reg.rmap_write_window_en                                       <= '0';
            -- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
            avs_config_wr_regs_o.rmap_irq_flags_clear_reg.rmap_write_config_flag_clear                           <= '0';
            -- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
            avs_config_wr_regs_o.rmap_irq_flags_clear_reg.rmap_write_window_flag_clear                           <= '0';
            -- Data Packet Device Channel Address Register : Data Packet Device Base Address
            avs_config_wr_regs_o.data_packet_dev_addr_reg.data_packet_dev_base_addr                              <= (others => '0');
            -- Data Packet Config Register : Data Packet CCD X Size
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_x_size                                      <= std_logic_vector(to_unsigned(2295, 16));
            -- Data Packet Config Register : Data Packet CCD Y Size
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_y_size                                      <= std_logic_vector(to_unsigned(2265, 16));
            -- Data Packet Config Register : Data Packet Data Y Size
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_data_y_size                                     <= std_logic_vector(to_unsigned(2255, 16));
            -- Data Packet Config Register : Data Packet Overscan Y Size
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_overscan_y_size                                 <= std_logic_vector(to_unsigned(10, 16));
            -- Data Packet Config Register : Data Packet CCD V-Start
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_v_start                                     <= std_logic_vector(to_unsigned(0, 16));
            -- Data Packet Config Register : Data Packet CCD V-End
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_v_end                                       <= std_logic_vector(to_unsigned(2264, 16));
            -- Data Packet Config Register : Data Packet CCD Image V-End
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_v_end                                   <= std_logic_vector(to_unsigned(2254, 16));
            -- Data Packet Config Register : Data Packet CCD Overscan V-End
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_v_end                                   <= std_logic_vector(to_unsigned(9, 16));
            -- Data Packet Config Register : Data Packet CCD H-Start
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_h_start                                     <= std_logic_vector(to_unsigned(0, 16));
            -- Data Packet Config Register : Data Packet CCD H-End
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_h_end                                       <= std_logic_vector(to_unsigned(2294, 16));
            -- Data Packet Config Register : Data Packet CCD Image Enable
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_en                                      <= '1';
            -- Data Packet Config Register : Data Packet CCD Overscan Enable
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_en                                      <= '1';
            -- Data Packet Config Register : Data Packet Packet Length
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_packet_length                                   <= std_logic_vector(to_unsigned(4522, 16));
            -- Data Packet Config Register : Data Packet Logical Address
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_logical_addr                                    <= x"50";
            -- Data Packet Config Register : Data Packet Protocol ID
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_protocol_id                                     <= x"F0";
            -- Data Packet Config Register : Data Packet FEE Mode for Left Buffer
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_left_buffer                            <= std_logic_vector(to_unsigned(0, 5));
            -- Data Packet Config Register : Data Packet FEE Mode for Right Buffer
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_right_buffer                           <= std_logic_vector(to_unsigned(0, 5));
            -- Data Packet Config Register : Data Packet CCD Number for Left Buffer
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_number_left_buffer                          <= std_logic_vector(to_unsigned(0, 2));
            -- Data Packet Config Register : Data Packet CCD Number for Right Buffer
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_number_right_buffer                         <= std_logic_vector(to_unsigned(0, 2));
            -- Data Packet Config Register : Data Packet CCD Side for Left Buffer
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_side_left_buffer                            <= '0';
            -- Data Packet Config Register : Data Packet CCD Side for Right Buffer
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_side_right_buffer                           <= '0';
            -- Data Packet Config Register : Data Packet CCD Image Pixels for Left Buffer
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_pixels_left_buffer                      <= (others => '0');
            -- Data Packet Config Register : Data Packet CCD Image Pixels for Right Buffer
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_pixels_right_buffer                     <= (others => '0');
            -- Data Packet Config Register : Data Packet CCD Overscan Pixels for Left Buffer
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_pixels_left_buffer                      <= (others => '0');
            -- Data Packet Config Register : Data Packet CCD Overscan Pixels for Right Buffer
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_pixels_right_buffer                     <= (others => '0');
            --            -- Data Packet Errors Register : Data Packet Invalid CCD Mode Error
            --            avs_config_wr_regs_o.data_packet_errors_reg.data_pkt_invalid_ccd_mode                                <= '0';
            -- Data Packet DEB Config Register : Data Packet DEB CCD Image V-End
            avs_config_wr_regs_o.data_packet_deb_config_reg.data_pkt_deb_ccd_img_v_end                           <= std_logic_vector(to_unsigned(2254, 16));
            -- Data Packet DEB Config Register : Data Packet DEB CCD Overscan V-End
            avs_config_wr_regs_o.data_packet_deb_config_reg.data_pkt_deb_ccd_ovs_v_end                           <= std_logic_vector(to_unsigned(9, 16));
            -- Data Packet DEB Config Register : Data Packet DEB CCD H-End
            avs_config_wr_regs_o.data_packet_deb_config_reg.data_pkt_deb_ccd_h_end                               <= std_logic_vector(to_unsigned(2294, 16));
            -- Data Packet DEB Config Register : Data Packet DEB CCD Image Enable
            avs_config_wr_regs_o.data_packet_deb_config_reg.data_pkt_deb_ccd_img_en                              <= '1';
            -- Data Packet DEB Config Register : Data Packet DEB CCD Overscan Enable
            avs_config_wr_regs_o.data_packet_deb_config_reg.data_pkt_deb_ccd_ovs_en                              <= '1';
            -- Data Packet AEB Config Register : Data Packet AEB CCD Image V-End for Left Buffer
            avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_img_v_end_left_buffer               <= std_logic_vector(to_unsigned(2254, 16));
            -- Data Packet AEB Config Register : Data Packet AEB CCD H-End for Left Buffer
            avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_h_end_left_buffer                   <= std_logic_vector(to_unsigned(2294, 16));
            -- Data Packet AEB Config Register : Data Packet AEB CCD Image Enable for Left Buffer
            avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_img_en_left_buffer                  <= '1';
            -- Data Packet AEB Config Register : Data Packet AEB CCD Overscan Enable for Left Buffer
            avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_ovs_en_left_buffer                  <= '1';
            -- Data Packet AEB Config Register : Data Packet AEB CCD ID for Left Buffer
            avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_id_left_buffer                      <= std_logic_vector(to_unsigned(0, 2));
            -- Data Packet AEB Config Register : Data Packet AEB CCD Image V-End for Right Buffer
            avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_img_v_end_right_buffer              <= std_logic_vector(to_unsigned(2254, 16));
            -- Data Packet AEB Config Register : Data Packet AEB CCD H-End for Right Buffer
            avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_h_end_right_buffer                  <= std_logic_vector(to_unsigned(2294, 16));
            -- Data Packet AEB Config Register : Data Packet AEB CCD Image Enable for Right Buffer
            avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_img_en_right_buffer                 <= '1';
            -- Data Packet AEB Config Register : Data Packet AEB CCD Overscan Enable for Right Buffer
            avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_ovs_en_right_buffer                 <= '1';
            -- Data Packet AEB Config Register : Data Packet AEB CCD ID for Right Buffer
            avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_id_right_buffer                     <= std_logic_vector(to_unsigned(0, 2));
            -- Data Packet Pixel Delay Register : Data Packet Start Delay
            avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_start_delay                                <= std_logic_vector(to_unsigned(20000000, 32));
            -- Data Packet Pixel Delay Register : Data Packet Skip Delay
            avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_skip_delay                                 <= std_logic_vector(to_unsigned(11000, 32));
            -- Data Packet Pixel Delay Register : Data Packet Line Delay
            avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_line_delay                                 <= std_logic_vector(to_unsigned(9000, 32));
            -- Data Packet Pixel Delay Register : Data Packet ADC Delay
            avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_adc_delay                                  <= std_logic_vector(to_unsigned(33, 32));
            -- Preset Frame Counter Register : Preset Frame Counter Value
            avs_config_wr_regs_o.preset_frame_counter_reg.preset_frame_counter_value                             <= (others => '0');
            -- Preset Frame Counter Register : Preset Frame Counter Set
            avs_config_wr_regs_o.preset_frame_counter_reg.preset_frame_counter_set                               <= '0';
            -- SpaceWire Error Injection Control Register : Enable for "EEP Received" SpaceWire Error
            avs_config_wr_regs_o.spw_error_injection_control_reg.spw_errinj_eep_received                         <= '0';
            -- SpaceWire Error Injection Control Register : Sequence Counter of SpaceWire Error
            avs_config_wr_regs_o.spw_error_injection_control_reg.spw_errinj_sequence_cnt                         <= std_logic_vector(to_unsigned(0, 16));
            -- SpaceWire Error Injection Control Register : Number of Times the SpaceWire Error Repeats
            avs_config_wr_regs_o.spw_error_injection_control_reg.spw_errinj_n_repeat                             <= std_logic_vector(to_unsigned(0, 16));
            -- SpaceWire Codec Error Injection Control Register : Start SpaceWire Codec Error Injection
            avs_config_wr_regs_o.spw_codec_errinj_control_reg.errinj_ctrl_start_errinj                           <= '0';
            -- SpaceWire Codec Error Injection Control Register : Reset SpaceWire Codec Error Injection
            avs_config_wr_regs_o.spw_codec_errinj_control_reg.errinj_ctrl_reset_errinj                           <= '0';
            -- SpaceWire Codec Error Injection Control Register : SpaceWire Codec Error Injection Error Code
            avs_config_wr_regs_o.spw_codec_errinj_control_reg.errinj_ctrl_errinj_code                            <= (others => '0');
            -- RMAP Error Injection Control Register : Reset RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_reset                              <= '0';
            -- RMAP Error Injection Control Register : Trigger RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_trigger                            <= '0';
            -- RMAP Error Injection Control Register : Error ID of RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_err_id                             <= (others => '0');
            -- RMAP Error Injection Control Register : Value of RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_value                              <= (others => '0');
            -- RMAP Error Injection Control Register : Repetitions of RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_repeats                            <= (others => '0');
            -- Transmission Error Injection Control Register : Enable for "Tx Disabled" Transmission Error
            avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_tx_disabled                      <= '0';
            -- Transmission Error Injection Control Register : Enable for "Missing Packets" Transmission Error
            avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_missing_pkts                     <= '0';
            -- Transmission Error Injection Control Register : Enable for "Missing Data" Transmission Error
            avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_missing_data                     <= '0';
            -- Transmission Error Injection Control Register : Frame Number of Transmission Error
            avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_frame_num                        <= std_logic_vector(to_unsigned(0, 2));
            -- Transmission Error Injection Control Register : Sequence Counter of Transmission Error
            avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_sequence_cnt                     <= std_logic_vector(to_unsigned(0, 16));
            -- Transmission Error Injection Control Register : Data Counter of Transmission Error
            avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_data_cnt                         <= std_logic_vector(to_unsigned(0, 16));
            -- Transmission Error Injection Control Register : Number of Times the Transmission Error Repeats
            avs_config_wr_regs_o.trans_error_injection_control_reg.trans_errinj_n_repeat                         <= std_logic_vector(to_unsigned(0, 16));
            -- Left Content Error Injection Control Register : Open the Left Content Error List
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_open               <= '0';
            -- Left Content Error Injection Control Register : Close the Left Content Error List
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_close              <= '0';
            -- Left Content Error Injection Control Register : Clear Left Content Error List
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_clear              <= '0';
            -- Left Content Error Injection Control Register : Write to Left Content Error List
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_write              <= '0';
            -- Left Content Error Injection Control Register : Start Injection of Left Content Errors
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_start              <= '0';
            -- Left Content Error Injection Control Register : Stop Injection of Left Content Errors
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_stop               <= '0';
            -- Left Content Error Injection Control Register : Start Frame of Left Content Error
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_start_frame        <= (others => '0');
            -- Left Content Error Injection Control Register : Stop Frame of Left Content Error
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_stop_frame         <= (others => '0');
            -- Left Content Error Injection Control Register : Pixel Column (x-position) of Left Content Error
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_pixel_col          <= (others => '0');
            -- Left Content Error Injection Control Register : Pixel Row (y-position) of Left Content Error
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_pixel_row          <= (others => '0');
            -- Left Content Error Injection Control Register : Pixel Value of Left Content Error
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_pixel_value        <= (others => '0');
            -- Right Content Error Injection Control Register : Open the Right Content Error List
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_open             <= '0';
            -- Right Content Error Injection Control Register : Close the Right Content Error List
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_close            <= '0';
            -- Right Content Error Injection Control Register : Clear Right Content Error List
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_clear            <= '0';
            -- Right Content Error Injection Control Register : Write to Right Content Error List
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_write            <= '0';
            -- Right Content Error Injection Control Register : Start Injection of Right Content Errors
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_start            <= '0';
            -- Right Content Error Injection Control Register : Stop Injection of Right Content Errors
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_stop             <= '0';
            -- Right Content Error Injection Control Register : Start Frame of Right Content Error
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_start_frame      <= (others => '0');
            -- Right Content Error Injection Control Register : Stop Frame of Right Content Error
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_stop_frame       <= (others => '0');
            -- Right Content Error Injection Control Register : Pixel Column (x-position) of Right Content Error
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_col        <= (others => '0');
            -- Right Content Error Injection Control Register : Pixel Row (y-position) of Right Content Error
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_row        <= (others => '0');
            -- Right Content Error Injection Control Register : Pixel Value of Right Content Error
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_value      <= (others => '0');
            -- Header Error Injection Control Register : Open the Header Error List
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_open                           <= '0';
            -- Header Error Injection Control Register : Close the Header Error List
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_close                          <= '0';
            -- Header Error Injection Control Register : Clear Header Error List
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_clear                          <= '0';
            -- Header Error Injection Control Register : Write to Header Error List
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_write                          <= '0';
            -- Header Error Injection Control Register : Start Injection of Header Errors
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_start                          <= '0';
            -- Header Error Injection Control Register : Stop Injection of Header Errors
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_stop                           <= '0';
            -- Header Error Injection Control Register : Frame Number of Header Error
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_frame_num                      <= (others => '0');
            -- Header Error Injection Control Register : Sequence Counter of Header Error
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_sequence_cnt                   <= (others => '0');
            -- Header Error Injection Control Register : Field ID of Header Error
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_field_id                       <= (others => '0');
            -- Header Error Injection Control Register : Value of Header Error
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_value                          <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 15
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_15                         <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 14
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_14                         <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 13
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_13                         <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 12
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_12                         <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 11
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_11                         <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 10
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_10                         <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 9
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_9                          <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 8
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_8                          <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 7
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_7                          <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 6
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_6                          <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 5
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_5                          <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 4
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_4                          <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 3
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_3                          <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 2
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_2                          <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 1
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_1                          <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Packet Order List Dword 0
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_packet_order_list_0                          <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Last E Packet
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_last_e_packet                                <= (others => '0');
            --            -- Windowing Parameters Register : Windowing Last F Packet
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_last_f_packet                                <= (others => '0');
            --            -- Windowing Parameters Register : Windowing X-Coordinate Error
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_x_coordinate_error                           <= '0';
            --            -- Windowing Parameters Register : Windowing Y-Coordinate Error
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_y_coordinate_error                           <= '0';

        end procedure p_reset_registers;

        procedure p_control_triggers is
        begin

            -- Write Registers Triggers Reset

            -- SpaceWire Timecode Config Register : SpaceWire Timecode Clear
            avs_config_wr_regs_o.spw_timecode_config_reg.timecode_clear                                          <= '0';
            -- FEE Machine Config Register : FEE Machine Clear
            avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_clear                                        <= '0';
            -- FEE Machine Config Register : FEE Machine Stop
            avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_stop                                         <= '0';
            -- FEE Machine Config Register : FEE Machine Start
            avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_start                                        <= '0';
            -- FEE Machine Config Register : FEE Statistics Clear
            avs_config_wr_regs_o.fee_machine_config_reg.fee_statistics_clear                                     <= '0';
            -- FEE Buffers Data Control Register : Right Data Read Start
            avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_start                                     <= '0';
            -- FEE Buffers Data Control Register : Right Data Read Reset
            avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_reset                                     <= '0';
            -- FEE Buffers Data Control Register : Left Data Read Start
            avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_start                                      <= '0';
            -- FEE Buffers Data Control Register : Left Data Read Reset
            avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_reset                                      <= '0';
            -- FEE Buffers IRQ Flags Clear Register : FEE Right Buffer 0 Empty IRQ Flag Clear
            avs_config_wr_regs_o.fee_buffers_irq_flags_clear_reg.fee_right_buffer_controller_finished_flag_clear <= '0';
            -- FEE Buffers IRQ Flags Clear Register : FEE Left Buffer 0 Empty IRQ Flag Clear
            avs_config_wr_regs_o.fee_buffers_irq_flags_clear_reg.fee_left_buffer_controller_finished_flag_clear  <= '0';
            -- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
            avs_config_wr_regs_o.rmap_irq_flags_clear_reg.rmap_write_config_flag_clear                           <= '0';
            -- RMAP IRQ Flags Clear Register : RMAP Write Config IRQ Flag Clear
            avs_config_wr_regs_o.rmap_irq_flags_clear_reg.rmap_write_window_flag_clear                           <= '0';
            --            -- Data Packet Errors Register : Data Packet Invalid CCD Mode Error
            --            avs_config_wr_regs_o.data_packet_errors_reg.data_pkt_invalid_ccd_mode                                <= '0';
            -- Preset Frame Counter Register : Preset Frame Counter Set
            avs_config_wr_regs_o.preset_frame_counter_reg.preset_frame_counter_set                               <= '0';
            -- SpaceWire Codec Error Injection Control Register : Start SpaceWire Codec Error Injection
            avs_config_wr_regs_o.spw_codec_errinj_control_reg.errinj_ctrl_start_errinj                           <= '0';
            -- SpaceWire Codec Error Injection Control Register : Reset SpaceWire Codec Error Injection
            avs_config_wr_regs_o.spw_codec_errinj_control_reg.errinj_ctrl_reset_errinj                           <= '0';
            -- RMAP Error Injection Control Register : Reset RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_reset                              <= '0';
            -- RMAP Error Injection Control Register : Trigger RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_trigger                            <= '0';
            -- Left Content Error Injection Control Register : Open the Left Content Error List
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_open               <= '0';
            -- Left Content Error Injection Control Register : Close the Left Content Error List
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_close              <= '0';
            -- Left Content Error Injection Control Register : Clear Left Content Error List
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_clear              <= '0';
            -- Left Content Error Injection Control Register : Write to Left Content Error List
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_write              <= '0';
            -- Left Content Error Injection Control Register : Start Injection of Left Content Errors
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_start              <= '0';
            -- Left Content Error Injection Control Register : Stop Injection of Left Content Errors
            avs_config_wr_regs_o.left_content_error_injection_control_reg.left_content_errinj_stop               <= '0';
            -- Right Content Error Injection Control Register : Open the Right Content Error List
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_open             <= '0';
            -- Right Content Error Injection Control Register : Close the Right Content Error List
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_close            <= '0';
            -- Right Content Error Injection Control Register : Clear Right Content Error List
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_clear            <= '0';
            -- Right Content Error Injection Control Register : Write to Right Content Error List
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_write            <= '0';
            -- Right Content Error Injection Control Register : Start Injection of Right Content Errors
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_start            <= '0';
            -- Right Content Error Injection Control Register : Stop Injection of Right Content Errors
            avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_stop             <= '0';
            -- Header Error Injection Control Register : Open the Header Error List
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_open                           <= '0';
            -- Header Error Injection Control Register : Close the Header Error List
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_close                          <= '0';
            -- Header Error Injection Control Register : Clear Header Error List
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_clear                          <= '0';
            -- Header Error Injection Control Register : Write to Header Error List
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_write                          <= '0';
            -- Header Error Injection Control Register : Start Injection of Header Errors
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_start                          <= '0';
            -- Header Error Injection Control Register : Stop Injection of Header Errors
            avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_stop                           <= '0';
            --            -- Windowing Parameters Register : Windowing X-Coordinate Error
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_x_coordinate_error                           <= '0';
            --            -- Windowing Parameters Register : Windowing Y-Coordinate Error
            --            avs_config_wr_regs_o.windowing_parameters_reg.windowing_y_coordinate_error                           <= '0';

        end procedure p_control_triggers;

    begin
        if (rst_i = '1') then

            s_counter                   <= 0;
            s_times                     <= 0;
            p_reset_registers;
            avs_config_rd_readdata_o    <= (others => '0');
            avs_config_rd_waitrequest_o <= '1';
            avs_config_wr_waitrequest_o <= '1';

        elsif rising_edge(clk_i) then

            s_counter                   <= s_counter + 1;
            p_control_triggers;
            avs_config_rd_readdata_o    <= (others => '0');
            avs_config_rd_waitrequest_o <= '1';
            avs_config_wr_waitrequest_o <= '1';

            case s_counter is

                when 5 =>
                    -- stop the comm module
                    avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_stop <= '1';

                when 10 =>
                    -- clear the comm module
                    avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_clear <= '1';

                when 15 =>
                    -- start the comm module
                    avs_config_wr_regs_o.fee_machine_config_reg.fee_machine_start <= '1';

                when 20 =>
                    -- configure simulation parameters
                    -- data packet parameters
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_x_size                         <= std_logic_vector(to_unsigned(25, 16));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_y_size                         <= std_logic_vector(to_unsigned(50, 16));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_data_y_size                        <= std_logic_vector(to_unsigned(35, 16));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_overscan_y_size                    <= std_logic_vector(to_unsigned(15, 16));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_v_start                        <= std_logic_vector(to_unsigned(0, 16));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_v_end                          <= std_logic_vector(to_unsigned(49, 16));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_v_end                      <= std_logic_vector(to_unsigned(34, 16));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_v_end                      <= std_logic_vector(to_unsigned(14, 16));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_h_start                        <= std_logic_vector(to_unsigned(0, 16));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_h_end                          <= std_logic_vector(to_unsigned(24, 16));
                    --					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_packet_length                      <= std_logic_vector(to_unsigned(128, 16));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_packet_length                      <= std_logic_vector(to_unsigned(128 + 13, 16));
--            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_pixels_left_buffer                      <= std_logic_vector(to_unsigned(256+1, 32));
--            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_pixels_right_buffer                     <= std_logic_vector(to_unsigned(256+1, 32));
--            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_pixels_left_buffer                      <= std_logic_vector(to_unsigned(64+1, 32));
--            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_pixels_right_buffer                     <= std_logic_vector(to_unsigned(64+1, 32));
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_pixels_left_buffer                      <= std_logic_vector(to_unsigned(256, 32));
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_img_pixels_right_buffer                     <= std_logic_vector(to_unsigned(256, 32));
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_pixels_left_buffer                      <= std_logic_vector(to_unsigned(64, 32));
            avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_ovs_pixels_right_buffer                     <= std_logic_vector(to_unsigned(64, 32));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_logical_addr                       <= x"25";
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_protocol_id                        <= x"02";
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_number_left_buffer             <= std_logic_vector(to_unsigned(3, 2));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_side_left_buffer               <= c_COMM_FFEE_CCD_SIDE_E;
                    --                    					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_left_buffer        <= c_DPKT_OFF_MODE; --                -- F-FEE Off Mode
                    --                    					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_left_buffer        <= c_DPKT_ON_MODE; --                 -- F-FEE On Mode
                    --					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_left_buffer               <= c_DPKT_FULLIMAGE_PATTERN_DEB_MODE; -- F-FEE Full-Image Pattern DEB Mode
                    --                    					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_left_buffer        <= c_DPKT_WINDOWING_PATTERN_DEB_MODE; -- F-FEE Windowing Pattern DEB Mode
                    --                    					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_left_buffer        <= c_DPKT_STANDBY_MODE; --            -- F-FEE Standby Mode
                    --					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_left_buffer        <= c_DPKT_FULLIMAGE_PATTERN_AEB_MODE; -- F-FEE Full-Image Pattern AEB Mode
                    --					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_left_buffer        <= c_DPKT_WINDOWING_PATTERN_AEB_MODE; -- F-FEE Windowing Pattern AEB Mode
                    --                    					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_left_buffer        <= c_DPKT_FULLIMAGE_MODE; --          -- F-FEE Full-Image Mode
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_left_buffer               <= c_DPKT_WINDOWING_MODE; --          -- F-FEE Windowing Mode
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_number_right_buffer            <= std_logic_vector(to_unsigned(3, 2));
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_ccd_side_right_buffer              <= c_COMM_FFEE_CCD_SIDE_F;
                    --                    					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_right_buffer        <= c_DPKT_OFF_MODE; --                -- F-FEE Off Mode
                    --                    					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_right_buffer        <= c_DPKT_ON_MODE; --                 -- F-FEE On Mode
                    --					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_right_buffer              <= c_DPKT_FULLIMAGE_PATTERN_DEB_MODE; -- F-FEE Full-Image Pattern DEB Mode
                    --                    					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_right_buffer        <= c_DPKT_WINDOWING_PATTERN_DEB_MODE; -- F-FEE Windowing Pattern DEB Mode
                    --                    					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_right_buffer        <= c_DPKT_STANDBY_MODE; --            -- F-FEE Standby Mode
                    --					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_right_buffer        <= c_DPKT_FULLIMAGE_PATTERN_AEB_MODE; -- F-FEE Full-Image Pattern AEB Mode
                    --					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_right_buffer        <= c_DPKT_WINDOWING_PATTERN_AEB_MODE; -- F-FEE Windowing Pattern AEB Mode
                    --                    					avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_right_buffer        <= c_DPKT_FULLIMAGE_MODE; --          -- F-FEE Full-Image Mode
                    avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_right_buffer              <= c_DPKT_WINDOWING_MODE; --          -- F-FEE Windowing Mode
                    -- data packet deb parameters
                    avs_config_wr_regs_o.data_packet_deb_config_reg.data_pkt_deb_ccd_img_v_end              <= std_logic_vector(to_unsigned(34, 16));
                    avs_config_wr_regs_o.data_packet_deb_config_reg.data_pkt_deb_ccd_ovs_v_end              <= std_logic_vector(to_unsigned(14, 16));
                    avs_config_wr_regs_o.data_packet_deb_config_reg.data_pkt_deb_ccd_h_end                  <= std_logic_vector(to_unsigned(24, 16));
                    -- data packet aeb parameters		
                    avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_img_v_end_left_buffer  <= std_logic_vector(to_unsigned(34, 16));
                    avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_h_end_left_buffer      <= std_logic_vector(to_unsigned(24, 16));
                    avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_id_left_buffer         <= std_logic_vector(to_unsigned(0, 2));
                    avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_img_v_end_right_buffer <= std_logic_vector(to_unsigned(34, 16));
                    avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_h_end_right_buffer     <= std_logic_vector(to_unsigned(24, 16));
                    avs_config_wr_regs_o.data_packet_aeb_config_reg.data_pkt_aeb_ccd_id_right_buffer        <= std_logic_vector(to_unsigned(0, 2));
                    -- pixel delays parameters
                    --					avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_start_delay        <= std_logic_vector(to_unsigned(1000, 32));
                    --					avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_skip_delay         <= std_logic_vector(to_unsigned(500, 32));
                    --					avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_line_delay         <= std_logic_vector(to_unsigned(100, 32));
                    --					avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_adc_delay          <= std_logic_vector(to_unsigned(50, 32));
                    avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_start_delay                   <= std_logic_vector(to_unsigned(10, 32));
                    avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_skip_delay                    <= std_logic_vector(to_unsigned(50, 32));
                    avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_line_delay                    <= std_logic_vector(to_unsigned(100, 32));
                    avs_config_wr_regs_o.data_packet_pixel_delay_reg.data_pkt_adc_delay                     <= std_logic_vector(to_unsigned(50, 32));
                    -- fee machine parameters
                    avs_config_wr_regs_o.fee_machine_config_reg.fee_buffer_overflow_en                      <= '1';
                    avs_config_wr_regs_o.fee_machine_config_reg.left_pixels_storage_size                    <= std_logic_vector(to_unsigned(10, 32));
                    avs_config_wr_regs_o.fee_machine_config_reg.right_pixels_storage_size                   <= std_logic_vector(to_unsigned(10, 32));
                    avs_config_wr_regs_o.fee_machine_config_reg.fee_digitalise_en                           <= '1';
                    avs_config_wr_regs_o.fee_machine_config_reg.fee_readout_en                              <= '1';
                    -- buffers data control
                    avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_data_length_bytes             <= (others => '1');
                    avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_start                         <= '1';
                    avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_data_length_bytes            <= (others => '1');
                    avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_start                        <= '1';

                --				when 50 =>
                --					avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_enable <= '1';
                --					avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_err_id <= c_RMAP_ERRINJ_ERR_ID_DATA_CRC;
                --					avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_value  <= x"AABBCCDD";

                --				when 50 =>
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_open <= '1';
                --
                --				when 60 =>
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_write       <= '1';
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_start_frame <= std_logic_vector(to_unsigned(2, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_stop_frame  <= std_logic_vector(to_unsigned(2, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_col   <= std_logic_vector(to_unsigned(0, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_row   <= std_logic_vector(to_unsigned(0, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_value <= x"AAAA";
                --
                --				when 70 =>
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_write       <= '1';
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_start_frame <= std_logic_vector(to_unsigned(1, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_stop_frame  <= std_logic_vector(to_unsigned(1, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_col   <= std_logic_vector(to_unsigned(1, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_row   <= std_logic_vector(to_unsigned(5, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_value <= x"BBBB";
                --
                --				when 80 =>
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_write       <= '1';
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_start_frame <= std_logic_vector(to_unsigned(0, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_stop_frame  <= std_logic_vector(to_unsigned(0, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_col   <= std_logic_vector(to_unsigned(2, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_row   <= std_logic_vector(to_unsigned(15, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_value <= x"CCCC";
                --
                --				when 90 =>
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_write       <= '1';
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_start_frame <= std_logic_vector(to_unsigned(0, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_stop_frame  <= std_logic_vector(to_unsigned(2, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_col   <= std_logic_vector(to_unsigned(2, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_row   <= std_logic_vector(to_unsigned(30, 16));
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_pixel_value <= x"DDDD";
                --
                --				when 100 =>
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_close <= '1';
                --
                --				when 110 =>
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_start <= '1';
                --
                --				when 60000 =>
                --					avs_config_wr_regs_o.right_content_error_injection_control_reg.right_content_errinj_stop <= '1';

                --				when 50 =>
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_open <= '1';
                --
                --				when 60 =>
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_write        <= '1';
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_frame_num    <= std_logic_vector(to_unsigned(0, 2));
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_sequence_cnt <= std_logic_vector(to_unsigned(0, 16));
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_field_id     <= c_HEADER_ERRINJ_FIELD_ID_FRAME_NUM;
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_value        <= x"FFFF";
                --
                --				when 70 =>
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_write        <= '1';
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_frame_num    <= std_logic_vector(to_unsigned(0, 2));
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_sequence_cnt <= std_logic_vector(to_unsigned(1, 16));
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_field_id     <= c_HEADER_ERRINJ_FIELD_ID_FRAME_CNT;
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_value        <= x"AAAA";
                --
                --				when 80 =>
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_write        <= '1';
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_frame_num    <= std_logic_vector(to_unsigned(0, 2));
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_sequence_cnt <= std_logic_vector(to_unsigned(2, 16));
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_field_id     <= c_HEADER_ERRINJ_FIELD_ID_SEQ_CNT;
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_value        <= x"BBBB";
                --
                --				when 90 =>
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_write        <= '1';
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_frame_num    <= std_logic_vector(to_unsigned(0, 2));
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_sequence_cnt <= std_logic_vector(to_unsigned(3, 16));
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_field_id     <= c_HEADER_ERRINJ_FIELD_ID_LENGTH;
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_value        <= x"CCCC";
                --
                --				when 100 =>
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_close <= '1';
                --
                --				when 110 =>
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_start <= '1';
                --
                --				when 60000 =>
                --					avs_config_wr_regs_o.header_error_injection_control_reg.header_errinj_stop <= '1';

                --                when 120000 =>
                --                    -- buffers data control
                --                    --					avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_start              <= '1';
                --                    avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_start <= '1';
                --                                      avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_left_buffer        <= c_DPKT_OFF_MODE; --                -- F-FEE Off Mode
                --                                      avs_config_wr_regs_o.data_packet_config_reg.data_pkt_fee_mode_right_buffer        <= c_DPKT_OFF_MODE; --                -- F-FEE Off Mode

                --
                --                when 230000 =>
                --                    -- buffers data control
                --                    --					avs_config_wr_regs_o.fee_buffers_data_control_reg.left_rd_start              <= '1';
                --                    avs_config_wr_regs_o.fee_buffers_data_control_reg.right_rd_start <= '1';

                when others =>
                    null;

            end case;

        end if;
    end process p_comm_config_avalon_mm_stimulli;

    avs_config_rd_readdata_o    <= (others => '0');
    avs_config_rd_waitrequest_o <= '1';
    avs_config_wr_waitrequest_o <= '1';

end architecture RTL;
