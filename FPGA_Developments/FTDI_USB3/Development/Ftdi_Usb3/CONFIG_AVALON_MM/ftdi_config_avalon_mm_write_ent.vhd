library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_config_avalon_mm_pkg.all;
use work.ftdi_config_avalon_mm_registers_pkg.all;

entity ftdi_config_avalon_mm_write_ent is
    port(
        clk_i                   : in  std_logic;
        rst_i                   : in  std_logic;
        ftdi_config_avalon_mm_i : in  t_ftdi_config_avalon_mm_write_in;
        ftdi_config_avalon_mm_o : out t_ftdi_config_avalon_mm_write_out;
        ftdi_config_wr_regs_o   : out t_ftdi_config_wr_registers
    );
end entity ftdi_config_avalon_mm_write_ent;

architecture rtl of ftdi_config_avalon_mm_write_ent is

    signal s_data_acquired : std_logic;

begin

    p_ftdi_config_avalon_mm_write : process(clk_i, rst_i) is
        procedure p_reset_registers is
        begin

            -- Write Registers Reset/Default State

            -- FTDI Module Control Register : Stop Module Operation
            ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start                         <= '0';
            -- FTDI Module Control Register : Start Module Operation
            ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop                          <= '0';
            -- FTDI Module Control Register : Clear Module Memories
            ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear                         <= '0';
            -- FTDI IRQ Control Register : FTDI Global IRQ Enable
            ftdi_config_wr_regs_o.ftdi_irq_control_reg.ftdi_global_irq_en                           <= '0';
            -- FTDI Rx IRQ Control Register : Rx Half-CCD Received IRQ Flag
            ftdi_config_wr_regs_o.rx_irq_control_reg.rx_hccd_received_irq_en                        <= '0';
            -- FTDI Rx IRQ Control Register : Rx Half-CCD Communication Error IRQ Enable
            ftdi_config_wr_regs_o.rx_irq_control_reg.rx_hccd_comm_err_irq_en                        <= '0';
            -- FTDI Rx IRQ Control Register : Rx Patch Reception Error IRQ Enable
            ftdi_config_wr_regs_o.rx_irq_control_reg.rx_patch_rcpt_err_irq_en                       <= '0';
            -- FTDI Rx IRQ Flag Clear Register : Rx Half-CCD Received IRQ Flag Clear
            ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_hccd_received_irq_flag_clr               <= '0';
            -- FTDI Rx IRQ Flag Clear Register : Rx Half-CCD Communication Error IRQ Flag Clear
            ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_hccd_comm_err_irq_flag_clr               <= '0';
            -- FTDI Rx IRQ Flag Clear Register : Rx Patch Reception Error IRQ Flag Clear
            ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_patch_rcpt_err_irq_flag_clr              <= '0';
            -- FTDI Tx IRQ Control Register : Tx LUT Finished Transmission IRQ Enable
            ftdi_config_wr_regs_o.tx_irq_control_reg.tx_lut_finished_irq_en                         <= '0';
            -- FTDI Tx IRQ Control Register : Tx LUT Communication Error IRQ Enable
            ftdi_config_wr_regs_o.tx_irq_control_reg.tx_lut_comm_err_irq_en                         <= '0';
            -- FTDI Tx IRQ Flag Clear Register : Tx LUT Finished Transmission IRQ Flag Clear
            ftdi_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_finished_irq_flag_clear              <= '0';
            -- FTDI Tx IRQ Flag Clear Register : Tx LUT Communication Error IRQ Flag Clear
            ftdi_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_comm_err_irq_flag_clear              <= '0';
            -- FTDI Half-CCD Request Control Register : Half-CCD Request Timeout
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_req_timeout                         <= std_logic_vector(to_unsigned(0, 16));
            -- FTDI Half-CCD Request Control Register : Half-CCD FEE Number
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_fee_number                          <= std_logic_vector(to_unsigned(0, 3));
            -- FTDI Half-CCD Request Control Register : Half-CCD CCD Number
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_number                          <= std_logic_vector(to_unsigned(0, 2));
            -- FTDI Half-CCD Request Control Register : Half-CCD CCD Side
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_side                            <= '0';
            -- FTDI Half-CCD Request Control Register : Half-CCD CCD Height
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height                          <= std_logic_vector(to_unsigned(0, 13));
            -- FTDI Half-CCD Request Control Register : Half-CCD CCD Width
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_width                           <= std_logic_vector(to_unsigned(0, 12));
            -- FTDI Half-CCD Request Control Register : Half-CCD Exposure Number
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_exposure_number                     <= std_logic_vector(to_unsigned(0, 16));
            -- FTDI Half-CCD Request Control Register : Request Half-CCD
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_request_hccd                             <= '0';
            -- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req                           <= '0';
            -- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller                    <= '0';
            -- FTDI LUT Transmission Control Register : LUT FEE Number
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_fee_number                              <= std_logic_vector(to_unsigned(0, 3));
            -- FTDI LUT Transmission Control Register : LUT CCD Number
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_number                              <= std_logic_vector(to_unsigned(0, 2));
            -- FTDI LUT Transmission Control Register : LUT CCD Side
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_side                                <= '0';
            -- FTDI LUT Transmission Control Register : LUT CCD Height
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_height                              <= std_logic_vector(to_unsigned(0, 13));
            -- FTDI LUT Transmission Control Register : LUT CCD Width
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_width                               <= std_logic_vector(to_unsigned(0, 12));
            -- FTDI LUT Transmission Control Register : LUT Exposure Number
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_exposure_number                         <= std_logic_vector(to_unsigned(0, 16));
            -- FTDI LUT Transmission Control Register : LUT Length [Bytes]
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_length_bytes                            <= std_logic_vector(to_unsigned(0, 32));
            -- FTDI LUT Transmission Control Register : LUT Request Timeout
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_trans_timeout                           <= std_logic_vector(to_unsigned(0, 16));
            -- FTDI LUT Transmission Control Register : Invert LUT 16-bits Words
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_invert_16b_words                        <= '0';
            -- FTDI LUT Transmission Control Register : Transmit LUT
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_transmit                                <= '0';
            -- FTDI LUT Transmission Control Register : Abort LUT Transmission
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_abort_transmission                      <= '0';
            -- FTDI LUT Transmission Control Register : Reset LUT Controller
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_reset_controller                        <= '0';
            -- FTDI Payload Configuration Register : Rx Payload Reader Force Length [Bytes]
            ftdi_config_wr_regs_o.payload_config_reg.rx_payload_reader_force_length_bytes           <= (others => '0');
            -- FTDI Payload Configuration Register : Rx Payload Reader Qqword Delay
            ftdi_config_wr_regs_o.payload_config_reg.rx_payload_reader_qqword_delay                 <= (others => '0');
            -- FTDI Payload Configuration Register : Tx Payload Writer Qqword Delay
            ftdi_config_wr_regs_o.payload_config_reg.tx_payload_writer_qqword_delay                 <= (others => '0');
            -- FTDI Tx Data Control Register : Tx Initial Read Address [High Dword]
            ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_initial_addr_high_dword                 <= (others => '0');
            -- FTDI Tx Data Control Register : Tx Initial Read Address [Low Dword]
            ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_initial_addr_low_dword                  <= (others => '0');
            -- FTDI Tx Data Control Register : Tx Read Data Length [Bytes]
            ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_data_length_bytes                       <= (others => '0');
            -- FTDI Tx Data Control Register : Tx Data Read Start
            ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_start                                   <= '0';
            -- FTDI Tx Data Control Register : Tx Data Read Reset
            ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_reset                                   <= '0';
            -- FTDI Rx Data Control Register : Rx Initial Write Address [High Dword]
            ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_initial_addr_high_dword                 <= (others => '0');
            -- FTDI Rx Data Control Register : Rx Initial Write Address [Low Dword]
            ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_initial_addr_low_dword                  <= (others => '0');
            -- FTDI Rx Data Control Register : Rx Write Data Length [Bytes]
            ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_data_length_bytes                       <= (others => '0');
            -- FTDI Rx Data Control Register : Rx Data Write Start
            ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_start                                   <= '0';
            -- FTDI Rx Data Control Register : Rx Data Write Reset
            ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_reset                                   <= '0';
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Window List Pointer
            ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer               <= (others => '0');
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Packet Order List Pointer
            ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer         <= (others => '0');
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Window List Length
            ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_length                <= (others => '0');
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Windows Size X
            ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_x                    <= (others => '0');
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Windows Size Y
            ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_y                    <= (others => '0');
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Last E Packet
            ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_e_packet                     <= (others => '0');
            -- FTDI LUT CCD1 Windowing Configuration : CCD1 Last F Packet
            ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_f_packet                     <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Window List Pointer
            ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer               <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Packet Order List Pointer
            ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer         <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Window List Length
            ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_length                <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Windows Size X
            ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_x                    <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Windows Size Y
            ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_y                    <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Last E Packet
            ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_e_packet                     <= (others => '0');
            -- FTDI LUT CCD2 Windowing Configuration : CCD2 Last F Packet
            ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_f_packet                     <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Window List Pointer
            ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer               <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Packet Order List Pointer
            ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer         <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Window List Length
            ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_length                <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Windows Size X
            ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_x                    <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Windows Size Y
            ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_y                    <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Last E Packet
            ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_e_packet                     <= (others => '0');
            -- FTDI LUT CCD3 Windowing Configuration : CCD3 Last F Packet
            ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_f_packet                     <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Window List Pointer
            ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer               <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Packet Order List Pointer
            ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer         <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Window List Length
            ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_length                <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Windows Size X
            ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_x                    <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Windows Size Y
            ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_y                    <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Last E Packet
            ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_e_packet                     <= (others => '0');
            -- FTDI LUT CCD4 Windowing Configuration : CCD4 Last F Packet
            ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_f_packet                     <= (others => '0');
            -- FTDI Patch Reception Control Register : Patch Reception Timeout
            ftdi_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_timeout                    <= (others => '0');
            -- FTDI Patch Reception Control Register : Patch Reception Enable
            ftdi_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_enable                     <= '0';
            -- FTDI Patch Reception Control Register : Patch Reception Discard
            ftdi_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_discard                    <= '0';
            -- FTDI Patch Reception Control Register : Patch Reception Invert Pixels Byte Order
            ftdi_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_invert_pixels_byte_order   <= '0';
            -- FTDI Patch Reception Config Register : FEEs CCDs Half-Width Pixels Size
            ftdi_config_wr_regs_o.patch_reception_config_reg.fees_ccds_halfwidth_pixels             <= (others => '0');
            -- FTDI Patch Reception Config Register : FEEs CCDs Height Pixels Size
            ftdi_config_wr_regs_o.patch_reception_config_reg.fees_ccds_height_pixels                <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_low_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Left Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_high_dword  <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Left Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_low_dword   <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Right Initial Address [High Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_high_dword <= (others => '0');
            -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Right Initial Address [Low Dword]
            ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_low_dword  <= (others => '0');

        end procedure p_reset_registers;

        procedure p_control_triggers is
        begin

            -- Write Registers Triggers Reset

            -- FTDI Module Control Register : Stop Module Operation
            ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start            <= '0';
            -- FTDI Module Control Register : Start Module Operation
            ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop             <= '0';
            -- FTDI Module Control Register : Clear Module Memories
            ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear            <= '0';
            -- FTDI Rx IRQ Flag Clear Register : Rx Half-CCD Received IRQ Flag Clear
            ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_hccd_received_irq_flag_clr  <= '0';
            -- FTDI Rx IRQ Flag Clear Register : Rx Half-CCD Communication Error IRQ Flag Clear
            ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_hccd_comm_err_irq_flag_clr  <= '0';
            -- FTDI Rx IRQ Flag Clear Register : Rx Patch Reception Error IRQ Flag Clear
            ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_patch_rcpt_err_irq_flag_clr <= '0';
            -- FTDI Tx IRQ Flag Clear Register : Tx LUT Finished Transmission IRQ Flag Clear
            ftdi_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_finished_irq_flag_clear <= '0';
            -- FTDI Tx IRQ Flag Clear Register : Tx LUT Communication Error IRQ Flag Clear
            ftdi_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_comm_err_irq_flag_clear <= '0';
            -- FTDI Half-CCD Request Control Register : Request Half-CCD
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_request_hccd                <= '0';
            -- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req              <= '0';
            -- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
            ftdi_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller       <= '0';
            -- FTDI LUT Transmission Control Register : Transmit LUT
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_transmit                   <= '0';
            -- FTDI LUT Transmission Control Register : Abort LUT Transmission
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_abort_transmission         <= '0';
            -- FTDI LUT Transmission Control Register : Reset LUT Controller
            ftdi_config_wr_regs_o.lut_trans_control_reg.lut_reset_controller           <= '0';
            -- FTDI Tx Data Control Register : Tx Data Read Start
            ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_start                      <= '0';
            -- FTDI Tx Data Control Register : Tx Data Read Reset
            ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_reset                      <= '0';
            -- FTDI Rx Data Control Register : Rx Data Write Start
            ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_start                      <= '0';
            -- FTDI Rx Data Control Register : Rx Data Write Reset
            ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_reset                      <= '0';
            -- FTDI Patch Reception Control Register : Patch Reception Discard
            ftdi_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_discard       <= '0';

        end procedure p_control_triggers;

        procedure p_writedata(write_address_i : t_ftdi_config_avalon_mm_address) is
        begin

            -- Registers Write Data
            case (write_address_i) is
                -- Case for access to all registers address

                when (16#00#) =>
                    -- FTDI Module Control Register : Stop Module Operation
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_start <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#01#) =>
                    -- FTDI Module Control Register : Start Module Operation
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_stop <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#02#) =>
                    -- FTDI Module Control Register : Clear Module Memories
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.ftdi_module_control_reg.ftdi_module_clear <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#03#) =>
                    -- FTDI IRQ Control Register : FTDI Global IRQ Enable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.ftdi_irq_control_reg.ftdi_global_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#04#) =>
                    -- FTDI Rx IRQ Control Register : Rx Half-CCD Received IRQ Flag
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.rx_irq_control_reg.rx_hccd_received_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#05#) =>
                    -- FTDI Rx IRQ Control Register : Rx Half-CCD Communication Error IRQ Enable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.rx_irq_control_reg.rx_hccd_comm_err_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#06#) =>
                    -- FTDI Rx IRQ Control Register : Rx Patch Reception Error IRQ Enable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.rx_irq_control_reg.rx_patch_rcpt_err_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#0A#) =>
                    -- FTDI Rx IRQ Flag Clear Register : Rx Half-CCD Received IRQ Flag Clear
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_hccd_received_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#0B#) =>
                    -- FTDI Rx IRQ Flag Clear Register : Rx Half-CCD Communication Error IRQ Flag Clear
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_hccd_comm_err_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#0C#) =>
                    -- FTDI Rx IRQ Flag Clear Register : Rx Patch Reception Error IRQ Flag Clear
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.rx_irq_flag_clear_reg.rx_patch_rcpt_err_irq_flag_clr <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#0D#) =>
                    -- FTDI Tx IRQ Control Register : Tx LUT Finished Transmission IRQ Enable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.tx_irq_control_reg.tx_lut_finished_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#0E#) =>
                    -- FTDI Tx IRQ Control Register : Tx LUT Communication Error IRQ Enable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.tx_irq_control_reg.tx_lut_comm_err_irq_en <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#11#) =>
                    -- FTDI Tx IRQ Flag Clear Register : Tx LUT Finished Transmission IRQ Flag Clear
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_finished_irq_flag_clear <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#12#) =>
                    -- FTDI Tx IRQ Flag Clear Register : Tx LUT Communication Error IRQ Flag Clear
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.tx_irq_flag_clear_reg.tx_lut_comm_err_irq_flag_clear <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#13#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD Request Timeout
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_req_timeout(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_req_timeout(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#14#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD FEE Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_fee_number <= ftdi_config_avalon_mm_i.writedata(2 downto 0);
                -- end if;

                when (16#15#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD CCD Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_number <= ftdi_config_avalon_mm_i.writedata(1 downto 0);
                -- end if;

                when (16#16#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD CCD Side
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_side <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#17#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD CCD Height
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_height(12 downto 8) <= ftdi_config_avalon_mm_i.writedata(12 downto 8);
                -- end if;

                when (16#18#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD CCD Width
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_width(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_ccd_width(11 downto 8) <= ftdi_config_avalon_mm_i.writedata(11 downto 8);
                -- end if;

                when (16#19#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD Exposure Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_exposure_number(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_hccd_exposure_number(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#1A#) =>
                    -- FTDI Half-CCD Request Control Register : Request Half-CCD
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_request_hccd <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#1B#) =>
                    -- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_abort_hccd_req <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#1C#) =>
                    -- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.hccd_req_control_reg.req_reset_hccd_controller <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#27#) =>
                    -- FTDI LUT Transmission Control Register : LUT FEE Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_fee_number <= ftdi_config_avalon_mm_i.writedata(2 downto 0);
                -- end if;

                when (16#28#) =>
                    -- FTDI LUT Transmission Control Register : LUT CCD Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_number <= ftdi_config_avalon_mm_i.writedata(1 downto 0);
                -- end if;

                when (16#29#) =>
                    -- FTDI LUT Transmission Control Register : LUT CCD Side
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_side <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#2A#) =>
                    -- FTDI LUT Transmission Control Register : LUT CCD Height
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_height(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_height(12 downto 8) <= ftdi_config_avalon_mm_i.writedata(12 downto 8);
                -- end if;

                when (16#2B#) =>
                    -- FTDI LUT Transmission Control Register : LUT CCD Width
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_width(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_ccd_width(11 downto 8) <= ftdi_config_avalon_mm_i.writedata(11 downto 8);
                -- end if;

                when (16#2C#) =>
                    -- FTDI LUT Transmission Control Register : LUT Exposure Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_exposure_number(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_exposure_number(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#2D#) =>
                    -- FTDI LUT Transmission Control Register : LUT Length [Bytes]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_length_bytes(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_length_bytes(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_length_bytes(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_length_bytes(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#2E#) =>
                    -- FTDI LUT Transmission Control Register : LUT Request Timeout
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_trans_timeout(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_trans_timeout(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#2F#) =>
                    -- FTDI LUT Transmission Control Register : Invert LUT 16-bits Words
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_invert_16b_words <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#30#) =>
                    -- FTDI LUT Transmission Control Register : Transmit LUT
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_transmit <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#31#) =>
                    -- FTDI LUT Transmission Control Register : Abort LUT Transmission
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_abort_transmission <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#32#) =>
                    -- FTDI LUT Transmission Control Register : Reset LUT Controller
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_trans_control_reg.lut_reset_controller <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#35#) =>
                    -- FTDI Payload Configuration Register : Rx Payload Reader Force Length [Bytes]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.payload_config_reg.rx_payload_reader_force_length_bytes(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.payload_config_reg.rx_payload_reader_force_length_bytes(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.payload_config_reg.rx_payload_reader_force_length_bytes(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.payload_config_reg.rx_payload_reader_force_length_bytes(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#36#) =>
                    -- FTDI Payload Configuration Register : Rx Payload Reader Qqword Delay
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.payload_config_reg.rx_payload_reader_qqword_delay(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.payload_config_reg.rx_payload_reader_qqword_delay(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#37#) =>
                    -- FTDI Payload Configuration Register : Tx Payload Writer Qqword Delay
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.payload_config_reg.tx_payload_writer_qqword_delay(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.payload_config_reg.tx_payload_writer_qqword_delay(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#38#) =>
                    -- FTDI Tx Data Control Register : Tx Initial Read Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_initial_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_initial_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_initial_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_initial_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#39#) =>
                    -- FTDI Tx Data Control Register : Tx Initial Read Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_initial_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_initial_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_initial_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_initial_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#3A#) =>
                    -- FTDI Tx Data Control Register : Tx Read Data Length [Bytes]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_data_length_bytes(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_data_length_bytes(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_data_length_bytes(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_data_length_bytes(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#3B#) =>
                    -- FTDI Tx Data Control Register : Tx Data Read Start
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_start <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#3C#) =>
                    -- FTDI Tx Data Control Register : Tx Data Read Reset
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.tx_data_control_reg.tx_rd_reset <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#3E#) =>
                    -- FTDI Rx Data Control Register : Rx Initial Write Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_initial_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_initial_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_initial_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_initial_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#3F#) =>
                    -- FTDI Rx Data Control Register : Rx Initial Write Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_initial_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_initial_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_initial_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_initial_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#40#) =>
                    -- FTDI Rx Data Control Register : Rx Write Data Length [Bytes]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_data_length_bytes(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_data_length_bytes(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_data_length_bytes(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_data_length_bytes(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#41#) =>
                    -- FTDI Rx Data Control Register : Rx Data Write Start
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_start <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#42#) =>
                    -- FTDI Rx Data Control Register : Rx Data Write Reset
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.rx_data_control_reg.rx_wr_reset <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#44#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Window List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#45#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Packet Order List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#46#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Window List Length
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_length(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_window_list_length(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#47#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Windows Size X
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_x <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
                -- end if;

                when (16#48#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Windows Size Y
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_y <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
                -- end if;

                when (16#49#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Last E Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_e_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_e_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
                -- end if;

                when (16#4A#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Last F Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_f_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd1_windowing_cfg_reg.ccd1_last_f_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
                -- end if;

                when (16#4B#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Window List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#4C#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Packet Order List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#4D#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Window List Length
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_length(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_window_list_length(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#4E#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Windows Size X
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_x <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
                -- end if;

                when (16#4F#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Windows Size Y
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_y <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
                -- end if;

                when (16#50#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Last E Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_e_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_e_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
                -- end if;

                when (16#51#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Last F Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_f_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd2_windowing_cfg_reg.ccd2_last_f_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
                -- end if;

                when (16#52#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Window List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#53#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Packet Order List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#54#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Window List Length
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_length(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_window_list_length(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#55#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Windows Size X
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_x <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
                -- end if;

                when (16#56#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Windows Size Y
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_y <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
                -- end if;

                when (16#57#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Last E Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_e_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_e_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
                -- end if;

                when (16#58#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Last F Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_f_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd3_windowing_cfg_reg.ccd3_last_f_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
                -- end if;

                when (16#59#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Window List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#5A#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Packet Order List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#5B#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Window List Length
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_length(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_window_list_length(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#5C#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Windows Size X
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_x <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
                -- end if;

                when (16#5D#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Windows Size Y
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_y <= ftdi_config_avalon_mm_i.writedata(5 downto 0);
                -- end if;

                when (16#5E#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Last E Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_e_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_e_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
                -- end if;

                when (16#5F#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Last F Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_f_packet(7 downto 0) <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.lut_ccd4_windowing_cfg_reg.ccd4_last_f_packet(9 downto 8) <= ftdi_config_avalon_mm_i.writedata(9 downto 8);
                -- end if;

                when (16#7A#) =>
                    -- FTDI Patch Reception Control Register : Patch Reception Timeout
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_timeout(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_timeout(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#7B#) =>
                    -- FTDI Patch Reception Control Register : Patch Reception Enable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_enable <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#7C#) =>
                    -- FTDI Patch Reception Control Register : Patch Reception Discard
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_discard <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#7D#) =>
                    -- FTDI Patch Reception Control Register : Patch Reception Invert Pixels Byte Order
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_control_reg.patch_rcpt_invert_pixels_byte_order <= ftdi_config_avalon_mm_i.writedata(0);
                -- end if;

                when (16#7F#) =>
                    -- FTDI Patch Reception Config Register : FEEs CCDs Half-Width Pixels Size
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fees_ccds_halfwidth_pixels(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fees_ccds_halfwidth_pixels(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#80#) =>
                    -- FTDI Patch Reception Config Register : FEEs CCDs Height Pixels Size
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fees_ccds_height_pixels(7 downto 0)  <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fees_ccds_height_pixels(15 downto 8) <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                -- end if;

                when (16#81#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#82#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#83#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#84#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#85#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#86#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#87#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#88#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#89#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#8A#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#8B#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#8C#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#8D#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#8E#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#8F#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#90#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#91#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#92#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#93#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#94#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#95#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#96#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#97#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#98#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#99#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#9A#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#9B#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#9C#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#9D#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#9E#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#9F#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#A0#) =>
                    -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#A1#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#A2#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#A3#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#A4#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#A5#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#A6#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#A7#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#A8#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#A9#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#AA#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#AB#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#AC#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#AD#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#AE#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#AF#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#B0#) =>
                    -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#B1#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#B2#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#B3#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#B4#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#B5#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#B6#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#B7#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#B8#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#B9#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#BA#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#BB#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#BC#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#BD#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#BE#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#BF#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#C0#) =>
                    -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#C1#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#C2#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#C3#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#C4#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#C5#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#C6#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#C7#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#C8#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#C9#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#CA#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#CB#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#CC#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#CD#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#CE#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#CF#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#D0#) =>
                    -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#D1#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#D2#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#D3#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#D4#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#D5#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#D6#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#D7#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#D8#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#D9#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#DA#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#DB#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#DC#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#DD#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#DE#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#DF#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_high_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_high_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_high_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_high_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when (16#E0#) =>
                    -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_low_dword(7 downto 0)   <= ftdi_config_avalon_mm_i.writedata(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_low_dword(15 downto 8)  <= ftdi_config_avalon_mm_i.writedata(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_low_dword(23 downto 16) <= ftdi_config_avalon_mm_i.writedata(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_wr_regs_o.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_low_dword(31 downto 24) <= ftdi_config_avalon_mm_i.writedata(31 downto 24);
                -- end if;

                when others =>
                    -- No register associated to the address, do nothing
                    null;

            end case;

        end procedure p_writedata;

        variable v_write_address : t_ftdi_config_avalon_mm_address := 0;
    begin
        if (rst_i = '1') then
            ftdi_config_avalon_mm_o.waitrequest <= '1';
            s_data_acquired                     <= '0';
            v_write_address                     := 0;
            p_reset_registers;
        elsif (rising_edge(clk_i)) then
            ftdi_config_avalon_mm_o.waitrequest <= '1';
            p_control_triggers;
            s_data_acquired                     <= '0';
            if (ftdi_config_avalon_mm_i.write = '1') then
                v_write_address                     := to_integer(unsigned(ftdi_config_avalon_mm_i.address));
                ftdi_config_avalon_mm_o.waitrequest <= '0';
                s_data_acquired                     <= '1';
                if (s_data_acquired = '0') then
                    p_writedata(v_write_address);
                end if;
            end if;
        end if;
    end process p_ftdi_config_avalon_mm_write;

end architecture rtl;
