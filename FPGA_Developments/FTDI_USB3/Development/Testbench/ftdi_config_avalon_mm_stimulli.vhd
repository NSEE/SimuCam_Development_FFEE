library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_config_avalon_mm_registers_pkg.all;

entity ftdi_config_avalon_mm_stimulli is
    port(
        clk_i                       : in  std_logic;
        rst_i                       : in  std_logic;
        avs_config_rd_regs_i        : in  t_ftdi_config_rd_registers;
        avs_config_wr_regs_o        : out t_ftdi_config_wr_registers;
        avs_config_rd_readdata_o    : out std_logic_vector(31 downto 0);
        avs_config_rd_waitrequest_o : out std_logic;
        avs_config_wr_waitrequest_o : out std_logic
    );
end entity ftdi_config_avalon_mm_stimulli;

architecture RTL of ftdi_config_avalon_mm_stimulli is

    signal s_counter : natural := 0;
    signal s_times   : natural := 0;

begin

    p_ftdi_config_avalon_mm_stimulli : process(clk_i, rst_i) is
        procedure p_reset_registers is
        begin

            -- Write Registers Reset/Default State

            -- FTDI Module Control Register : Stop Module Operation
            avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start                         <= '0';
            -- FTDI Module Control Register : Start Module Operation
            avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop                          <= '0';
            -- FTDI Module Control Register : Clear Module Memories
            avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear                         <= '0';
            -- FTDI IRQ Control Register : FTDI Global IRQ Enable
            avs_config_wr_regs_o.ftdi_irq_control_reg.ftdi_global_irq_en                           <= '0';
            -- FTDI Rx IRQ Control Register : Rx Half-CCD Received IRQ Flag
            avs_config_wr_regs_o.rx_irq_control_reg.rx_hccd_received_irq_en                        <= '0';
            -- FTDI Rx IRQ Control Register : Rx Half-CCD Communication Error IRQ Enable
            avs_config_wr_regs_o.rx_irq_control_reg.rx_hccd_comm_err_irq_en                        <= '0';
            -- FTDI Rx IRQ Control Register : Rx Patch Reception Error IRQ Enable
            avs_config_wr_regs_o.rx_irq_control_reg.rx_patch_rcpt_err_irq_en                       <= '0';
            -- FTDI Rx IRQ Flag Clear Register : Rx Half-CCD Received IRQ Flag Clear
            avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_hccd_received_irq_flag_clr               <= '0';
            -- FTDI Rx IRQ Flag Clear Register : Rx Half-CCD Communication Error IRQ Flag Clear
            avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_hccd_comm_err_irq_flag_clr               <= '0';
            -- FTDI Rx IRQ Flag Clear Register : Rx Patch Reception Error IRQ Flag Clear
            avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_patch_rcpt_err_irq_flag_clr              <= '0';
            -- FTDI Tx IRQ Control Register : Tx LUT Finished Transmission IRQ Enable
            avs_config_wr_regs_o.tx_irq_control_reg.tx_lut_finished_irq_en                         <= '0';
            -- FTDI Tx IRQ Control Register : Tx LUT Communication Error IRQ Enable
            avs_config_wr_regs_o.tx_irq_control_reg.tx_lut_comm_err_irq_en                         <= '0';
            -- FTDI Tx IRQ Flag Clear Register : Tx LUT Finished Transmission IRQ Flag Clear
            avs_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_finished_irq_flag_clear              <= '0';
            -- FTDI Tx IRQ Flag Clear Register : Tx LUT Communication Error IRQ Flag Clear
            avs_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_comm_err_irq_flag_clear              <= '0';
            -- FTDI Half-CCD Request Control Register : Half-CCD Request Timeout
            avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_req_timeout                         <= std_logic_vector(to_unsigned(0, 16));
            -- FTDI Half-CCD Request Control Register : Half-CCD FEE Number
            avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_fee_number                          <= std_logic_vector(to_unsigned(0, 3));
            -- FTDI Half-CCD Request Control Register : Half-CCD CCD Number
            avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_number                          <= std_logic_vector(to_unsigned(0, 2));
            -- FTDI Half-CCD Request Control Register : Half-CCD CCD Side
            avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_side                            <= '0';
            -- FTDI Half-CCD Request Control Register : Half-CCD CCD Height
            avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height                          <= std_logic_vector(to_unsigned(0, 13));
            -- FTDI Half-CCD Request Control Register : Half-CCD CCD Width
            avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_width                           <= std_logic_vector(to_unsigned(0, 12));
            -- FTDI Half-CCD Request Control Register : Half-CCD Exposure Number
            avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_exposure_number                     <= std_logic_vector(to_unsigned(0, 16));
            -- FTDI Half-CCD Request Control Register : Request Half-CCD
            avs_config_wr_regs_o.hccd_req_control_reg.req_request_hccd                             <= '0';
            -- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
            avs_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req                           <= '0';
            -- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
            avs_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller                    <= '0';
            -- FTDI LUT Transmission Control Register : LUT FEE Number
            avs_config_wr_regs_o.lut_trans_control_reg.lut_fee_number                              <= std_logic_vector(to_unsigned(0, 3));
            -- FTDI LUT Transmission Control Register : LUT CCD Number
            avs_config_wr_regs_o.lut_trans_control_reg.lut_ccd_number                              <= std_logic_vector(to_unsigned(0, 2));
            -- FTDI LUT Transmission Control Register : LUT CCD Side
            avs_config_wr_regs_o.lut_trans_control_reg.lut_ccd_side                                <= '0';
            -- FTDI LUT Transmission Control Register : LUT CCD Height
            avs_config_wr_regs_o.lut_trans_control_reg.lut_ccd_height                              <= std_logic_vector(to_unsigned(0, 13));
            -- FTDI LUT Transmission Control Register : LUT CCD Width
            avs_config_wr_regs_o.lut_trans_control_reg.lut_ccd_width                               <= std_logic_vector(to_unsigned(0, 12));
            -- FTDI LUT Transmission Control Register : LUT Exposure Number
            avs_config_wr_regs_o.lut_trans_control_reg.lut_exposure_number                         <= std_logic_vector(to_unsigned(0, 16));
            -- FTDI LUT Transmission Control Register : LUT Length [Bytes]
            avs_config_wr_regs_o.lut_trans_control_reg.lut_length_bytes                            <= std_logic_vector(to_unsigned(0, 32));
            -- FTDI LUT Transmission Control Register : LUT Request Timeout
            avs_config_wr_regs_o.lut_trans_control_reg.lut_trans_timeout                           <= std_logic_vector(to_unsigned(0, 16));
            -- FTDI LUT Transmission Control Register : Invert LUT 16-bits Words
            avs_config_wr_regs_o.lut_trans_control_reg.lut_invert_16b_words                        <= '0';
            -- FTDI LUT Transmission Control Register : Transmit LUT
            avs_config_wr_regs_o.lut_trans_control_reg.lut_transmit                                <= '0';
            -- FTDI LUT Transmission Control Register : Abort LUT Transmission
            avs_config_wr_regs_o.lut_trans_control_reg.lut_abort_transmission                      <= '0';
            -- FTDI LUT Transmission Control Register : Reset LUT Controller
            avs_config_wr_regs_o.lut_trans_control_reg.lut_reset_controller                        <= '0';
            -- FTDI Payload Configuration Register : Rx Payload Reader Force Length [Bytes]
            avs_config_wr_regs_o.payload_config_reg.rx_payload_reader_force_length_bytes           <= (others => '0');
            -- FTDI Payload Configuration Register : Rx Payload Reader Qqword Delay
            avs_config_wr_regs_o.payload_config_reg.rx_payload_reader_qqword_delay                 <= (others => '0');
            -- FTDI Payload Configuration Register : Tx Payload Writer Qqword Delay
            avs_config_wr_regs_o.payload_config_reg.tx_payload_writer_qqword_delay                 <= (others => '0');
            -- FTDI Tx Data Control Register : Tx Initial Read Address [High Dword]
            avs_config_wr_regs_o.tx_data_control_reg.tx_rd_initial_addr_high_dword                 <= (others => '0');
            -- FTDI Tx Data Control Register : Tx Initial Read Address [Low Dword]
            avs_config_wr_regs_o.tx_data_control_reg.tx_rd_initial_addr_low_dword                  <= (others => '0');
            -- FTDI Tx Data Control Register : Tx Read Data Length [Bytes]
            avs_config_wr_regs_o.tx_data_control_reg.tx_rd_data_length_bytes                       <= (others => '0');
            -- FTDI Tx Data Control Register : Tx Data Read Start
            avs_config_wr_regs_o.tx_data_control_reg.tx_rd_start                                   <= '0';
            -- FTDI Tx Data Control Register : Tx Data Read Reset
            avs_config_wr_regs_o.tx_data_control_reg.tx_rd_reset                                   <= '0';
            -- FTDI Rx Data Control Register : Rx Initial Write Address [High Dword]
            avs_config_wr_regs_o.rx_data_control_reg.rx_wr_initial_addr_high_dword                 <= (others => '0');
            -- FTDI Rx Data Control Register : Rx Initial Write Address [Low Dword]
            avs_config_wr_regs_o.rx_data_control_reg.rx_wr_initial_addr_low_dword                  <= (others => '0');
            -- FTDI Rx Data Control Register : Rx Write Data Length [Bytes]
            avs_config_wr_regs_o.rx_data_control_reg.rx_wr_data_length_bytes                       <= (others => '0');
            -- FTDI Rx Data Control Register : Rx Data Write Start
            avs_config_wr_regs_o.rx_data_control_reg.rx_wr_start                                   <= '0';
            -- FTDI Rx Data Control Register : Rx Data Write Reset
            avs_config_wr_regs_o.rx_data_control_reg.rx_wr_reset                                   <= '0';
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Window List Pointer
            avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer               <= (others => '0');
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Packet Order List Pointer
            avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer         <= (others => '0');
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Window List Length
            avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_length                <= (others => '0');
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Windows Size X
            avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_x                    <= (others => '0');
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Windows Size Y
            avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_y                    <= (others => '0');
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Last E Packet
            avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_e_packet                     <= (others => '0');
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Last F Packet
            avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_f_packet                     <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Window List Pointer
            avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer               <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Packet Order List Pointer
            avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer         <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Window List Length
            avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_length                <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Windows Size X
            avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_x                    <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Windows Size Y
            avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_y                    <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Last E Packet
            avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_e_packet                     <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Last F Packet
            avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_f_packet                     <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Window List Pointer
            avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer               <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Packet Order List Pointer
            avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer         <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Window List Length
            avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_length                <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Windows Size X
            avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_x                    <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Windows Size Y
            avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_y                    <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Last E Packet
            avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_e_packet                     <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Last F Packet
            avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_f_packet                     <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Window List Pointer
            avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer               <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Packet Order List Pointer
            avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer         <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Window List Length
            avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_length                <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Windows Size X
            avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_x                    <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Windows Size Y
            avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_y                    <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Last E Packet
            avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_e_packet                     <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Last F Packet
            avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_f_packet                     <= (others => '0');
            -- FTDI Patch Reception Control Register : Patch Reception Timeout
            avs_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_timeout                    <= (others => '0');
            -- FTDI Patch Reception Control Register : Patch Reception Enable
            avs_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_enable                     <= '0';
            -- FTDI Patch Reception Control Register : Patch Reception Discard
            avs_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_discard                    <= '0';
            -- FTDI Patch Reception Control Register : Patch Reception Invert Pixels Byte Order
            avs_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_invert_pixels_byte_order   <= '0';
            -- FTDI Patch Reception Config Register : FEEs CCDs Half-Width Pixels Size
            avs_config_wr_regs_o.patch_reception_config_reg.fees_ccds_halfwidth_pixels             <= (others => '0');
            -- FTDI Patch Reception Config Register : FEEs CCDs Height Pixels Size
            avs_config_wr_regs_o.patch_reception_config_reg.fees_ccds_height_pixels                <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Left Initial Address [High Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Left Initial Address [Low Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Right Initial Address [High Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Right Initial Address [Low Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Left Initial Address [High Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Left Initial Address [Low Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Right Initial Address [High Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Right Initial Address [Low Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Left Initial Address [High Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Left Initial Address [Low Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Right Initial Address [High Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Right Initial Address [Low Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Left Initial Address [High Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Left Initial Address [Low Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Right Initial Address [High Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Right Initial Address [Low Dword]
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_low_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Left Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_high_dword  <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Left Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_low_dword   <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Right Initial Address [High Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_high_dword <= (others => '0');
            --            -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Right Initial Address [Low Dword]
            --            avs_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_low_dword  <= (others => '0');

        end procedure p_reset_registers;

        procedure p_control_triggers is
        begin

            -- Write Registers Triggers Reset

            -- FTDI Module Control Register : Stop Module Operation
            avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start            <= '0';
            -- FTDI Module Control Register : Start Module Operation
            avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop             <= '0';
            -- FTDI Module Control Register : Clear Module Memories
            avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear            <= '0';
            -- FTDI Rx IRQ Flag Clear Register : Rx Half-CCD Received IRQ Flag Clear
            avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_hccd_received_irq_flag_clr  <= '0';
            -- FTDI Rx IRQ Flag Clear Register : Rx Half-CCD Communication Error IRQ Flag Clear
            avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_hccd_comm_err_irq_flag_clr  <= '0';
            -- FTDI Rx IRQ Flag Clear Register : Rx Patch Reception Error IRQ Flag Clear
            avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_patch_rcpt_err_irq_flag_clr <= '0';
            -- FTDI Tx IRQ Flag Clear Register : Tx LUT Finished Transmission IRQ Flag Clear
            avs_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_finished_irq_flag_clear <= '0';
            -- FTDI Tx IRQ Flag Clear Register : Tx LUT Communication Error IRQ Flag Clear
            avs_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_comm_err_irq_flag_clear <= '0';
            -- FTDI Half-CCD Request Control Register : Request Half-CCD
            avs_config_wr_regs_o.hccd_req_control_reg.req_request_hccd                <= '0';
            -- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
            avs_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req              <= '0';
            -- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
            avs_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller       <= '0';
            -- FTDI LUT Transmission Control Register : Transmit LUT
            avs_config_wr_regs_o.lut_trans_control_reg.lut_transmit                   <= '0';
            -- FTDI LUT Transmission Control Register : Abort LUT Transmission
            avs_config_wr_regs_o.lut_trans_control_reg.lut_abort_transmission         <= '0';
            -- FTDI LUT Transmission Control Register : Reset LUT Controller
            avs_config_wr_regs_o.lut_trans_control_reg.lut_reset_controller           <= '0';
            -- FTDI Tx Data Control Register : Tx Data Read Start
            avs_config_wr_regs_o.tx_data_control_reg.tx_rd_start                      <= '0';
            -- FTDI Tx Data Control Register : Tx Data Read Reset
            avs_config_wr_regs_o.tx_data_control_reg.tx_rd_reset                      <= '0';
            -- FTDI Rx Data Control Register : Rx Data Write Start
            avs_config_wr_regs_o.rx_data_control_reg.rx_wr_start                      <= '0';
            -- FTDI Rx Data Control Register : Rx Data Write Reset
            avs_config_wr_regs_o.rx_data_control_reg.rx_wr_reset                      <= '0';
            -- FTDI Patch Reception Control Register : Patch Reception Discard
            avs_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_discard       <= '0';

        end procedure p_control_triggers;

    begin
        if (rst_i = '1') then

            s_counter <= 0;
            s_times   <= 0;
            p_reset_registers;

        elsif rising_edge(clk_i) then

            s_counter <= s_counter + 1;
            p_control_triggers;

            avs_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_enable                   <= '1';
            avs_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_invert_pixels_byte_order <= '0';
            avs_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_timeout                  <= std_logic_vector(to_unsigned(0, 16));
            avs_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_data_delay               <= x"00000010";

            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_high_dword  <= x"00000000";
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_low_dword   <= x"80119200";
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_high_dword <= x"00000000";
            avs_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_low_dword  <= x"80BBAF40";

            avs_config_wr_regs_o.patch_reception_config_reg.fees_ccds_halfwidth_pixels <= x"0200";
            avs_config_wr_regs_o.patch_reception_config_reg.fees_ccds_height_pixels    <= x"0200";

            case s_counter is

                when 5 =>
                    -- Stop the ftdi module
                    avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop <= '1';

                when 10 =>
                    -- Clear the ftdi module
                    avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear <= '1';

                when 15 =>
                    -- Start the ftdi module
                    avs_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start <= '1';

--                when 20 =>
--                    -- Request Half-CCD
--                    avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_fee_number                <= std_logic_vector(to_unsigned(3, 3));
--                    avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_number                <= std_logic_vector(to_unsigned(2, 2));
--                    avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_side                  <= '1';
--                    avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height                <= std_logic_vector(to_unsigned(16, 13));
--                    avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_width                 <= std_logic_vector(to_unsigned(7, 12));
--                    avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_exposure_number           <= std_logic_vector(to_unsigned(875, 16));
--                    avs_config_wr_regs_o.hccd_req_control_reg.req_hccd_req_timeout               <= std_logic_vector(to_unsigned(0, 16));
--                    avs_config_wr_regs_o.hccd_req_control_reg.req_request_hccd                   <= '1';
--                    -- Payload Config
--                    avs_config_wr_regs_o.payload_config_reg.rx_payload_reader_force_length_bytes <= std_logic_vector(to_unsigned(864, 32));
--                    -- AMV Controller
--                    avs_config_wr_regs_o.rx_data_control_reg.rx_wr_data_length_bytes             <= std_logic_vector(to_unsigned(864 - 32, 32));
--                    avs_config_wr_regs_o.rx_data_control_reg.rx_wr_start                         <= '1';

--                when 20 =>
--                    -- Transmit LUT
--                    avs_config_wr_regs_o.lut_trans_control_reg.lut_fee_number                      <= std_logic_vector(to_unsigned(3, 3));
--                    avs_config_wr_regs_o.lut_trans_control_reg.lut_ccd_number                      <= std_logic_vector(to_unsigned(2, 2));
--                    avs_config_wr_regs_o.lut_trans_control_reg.lut_ccd_side                        <= '1';
--                    avs_config_wr_regs_o.lut_trans_control_reg.lut_ccd_height                      <= std_logic_vector(to_unsigned(16, 13));
--                    avs_config_wr_regs_o.lut_trans_control_reg.lut_ccd_width                       <= std_logic_vector(to_unsigned(7, 12));
--                    avs_config_wr_regs_o.lut_trans_control_reg.lut_exposure_number                 <= std_logic_vector(to_unsigned(875, 16));
--                    avs_config_wr_regs_o.lut_trans_control_reg.lut_length_bytes                    <= std_logic_vector(to_unsigned(512 + 512, 32));
--                    avs_config_wr_regs_o.lut_trans_control_reg.lut_trans_timeout                   <= std_logic_vector(to_unsigned(0, 16));
--                    avs_config_wr_regs_o.lut_trans_control_reg.lut_transmit                        <= '1';
--                    -- Configure Windowing Parameters
--                    avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer       <= x"01234567";
--                    avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer <= x"09ABCDEF";
--                    avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_length        <= x"0159";
--                    avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_x            <= "001100";
--                    avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_y            <= "000011";
--                    avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_e_packet             <= "0011001100";
--                    avs_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_f_packet             <= "0000110011";
--                    avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer       <= x"11234567";
--                    avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer <= x"19ABCDEF";
--                    avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_length        <= x"1159";
--                    avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_x            <= "011100";
--                    avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_y            <= "010011";
--                    avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_e_packet             <= "0111001100";
--                    avs_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_f_packet             <= "0100110011";
--                    avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer       <= x"21234567";
--                    avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer <= x"29ABCDEF";
--                    avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_length        <= x"2159";
--                    avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_x            <= "101100";
--                    avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_y            <= "100011";
--                    avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_e_packet             <= "1011001100";
--                    avs_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_f_packet             <= "1000110011";
--                    avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer       <= x"31234567";
--                    avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer <= x"39ABCDEF";
--                    avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_length        <= x"3159";
--                    avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_x            <= "111100";
--                    avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_y            <= "110011";
--                    avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_e_packet             <= "1111001100";
--                    avs_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_f_packet             <= "1100110011";

                when 25 =>
                    -- Enables IRQ
                    avs_config_wr_regs_o.ftdi_irq_control_reg.ftdi_global_irq_en    <= '1';
                    --					avs_config_wr_regs_o.rx_irq_control_reg.rx_buffer_0_rdable_irq_en    <= '1';
                    --					avs_config_wr_regs_o.rx_irq_control_reg.rx_buffer_1_rdable_irq_en    <= '1';
                    --					avs_config_wr_regs_o.rx_irq_control_reg.rx_buffer_last_rdable_irq_en <= '1';
                    avs_config_wr_regs_o.rx_irq_control_reg.rx_hccd_received_irq_en <= '1';
                    avs_config_wr_regs_o.rx_irq_control_reg.rx_hccd_comm_err_irq_en <= '1';
                    avs_config_wr_regs_o.tx_irq_control_reg.tx_lut_finished_irq_en  <= '1';
                    avs_config_wr_regs_o.tx_irq_control_reg.tx_lut_comm_err_irq_en  <= '1';

                when 450 =>
                    --					avs_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_discard <= '1';
                    --										avs_config_wr_regs_o.lut_trans_control_reg.lut_reset_controller <= '1';

                    --				when 250 =>
                    -- Reset Half-CCD
                    --					avs_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller <= '1';

                    --				when 6000 =>
                    --					-- Clear IRQ
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr    <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr    <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr  <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr           <= '1';
                    --
                    --				when 16000 =>
                    --					-- Clear IRQ
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr    <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr    <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr  <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr           <= '1';
                    --
                    --				when 25000 =>
                    --					-- Clear IRQ
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr    <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr    <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr  <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr           <= '1';
                    --
                    --				when 43000 =>
                    --					-- Clear IRQ
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_0_rdable_irq_flag_clr    <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_1_rdable_irq_flag_clr    <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_rdable_irq_flag_clr <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_buffer_last_empty_irq_flag_clr  <= '1';
                    --					avs_config_wr_regs_o.rx_irq_flag_clear_reg.rx_comm_err_irq_flag_clr           <= '1';

                when others =>
                    null;

            end case;

        end if;
    end process p_ftdi_config_avalon_mm_stimulli;

    avs_config_rd_readdata_o    <= (others => '0');
    avs_config_rd_waitrequest_o <= '1';
    avs_config_wr_waitrequest_o <= '1';

end architecture RTL;
