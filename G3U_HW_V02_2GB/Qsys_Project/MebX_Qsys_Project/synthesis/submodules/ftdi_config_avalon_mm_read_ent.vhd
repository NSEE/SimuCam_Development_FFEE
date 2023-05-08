
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_config_avalon_mm_pkg.all;
use work.ftdi_config_avalon_mm_registers_pkg.all;

entity ftdi_config_avalon_mm_read_ent is
    port(
        clk_i                   : in  std_logic;
        rst_i                   : in  std_logic;
        ftdi_config_avalon_mm_i : in  t_ftdi_config_avalon_mm_read_in;
        ftdi_config_avalon_mm_o : out t_ftdi_config_avalon_mm_read_out;
        ftdi_config_wr_regs_i   : in  t_ftdi_config_wr_registers;
        ftdi_config_rd_regs_i   : in  t_ftdi_config_rd_registers
    );
end entity ftdi_config_avalon_mm_read_ent;

architecture rtl of ftdi_config_avalon_mm_read_ent is

begin

    p_ftdi_config_avalon_mm_read : process(clk_i, rst_i) is
        procedure p_readdata(read_address_i : t_ftdi_config_avalon_mm_address) is
        begin

            -- Registers Data Read
            case (read_address_i) is
                -- Case for access to all registers address

                when (16#00#) =>
                    -- FTDI Module Control Register : Stop Module Operation
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.ftdi_module_control_reg.ftdi_module_start;
                -- end if;

                when (16#01#) =>
                    -- FTDI Module Control Register : Start Module Operation
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.ftdi_module_control_reg.ftdi_module_stop;
                -- end if;

                when (16#02#) =>
                    -- FTDI Module Control Register : Clear Module Memories
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.ftdi_module_control_reg.ftdi_module_clear;
                -- end if;

                when (16#03#) =>
                    -- FTDI IRQ Control Register : FTDI Global IRQ Enable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.ftdi_irq_control_reg.ftdi_global_irq_en;
                -- end if;

                when (16#04#) =>
                    -- FTDI Rx IRQ Control Register : Rx Half-CCD Received IRQ Flag
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_control_reg.rx_hccd_received_irq_en;
                -- end if;

                when (16#05#) =>
                    -- FTDI Rx IRQ Control Register : Rx Half-CCD Communication Error IRQ Enable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_control_reg.rx_hccd_comm_err_irq_en;
                -- end if;

                when (16#06#) =>
                    -- FTDI Rx IRQ Control Register : Rx Patch Reception Error IRQ Enable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_control_reg.rx_patch_rcpt_err_irq_en;
                -- end if;

                when (16#07#) =>
                    -- FTDI Rx IRQ Flag Register : Rx Half-CCD Received IRQ Flag
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_irq_flag_reg.rx_hccd_received_irq_flag;
                -- end if;

                when (16#08#) =>
                    -- FTDI Rx IRQ Flag Register : Rx Half-CCD Communication Error IRQ Flag
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_irq_flag_reg.rx_hccd_comm_err_irq_flag;
                -- end if;

                when (16#09#) =>
                    -- FTDI Rx IRQ Flag Register : Rx Patch Reception Error IRQ Flag
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_irq_flag_reg.rx_patch_rcpt_err_irq_flag;
                -- end if;

                when (16#0A#) =>
                    -- FTDI Rx IRQ Flag Clear Register : Rx Half-CCD Received IRQ Flag Clear
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_flag_clear_reg.rx_hccd_received_irq_flag_clr;
                -- end if;

                when (16#0B#) =>
                    -- FTDI Rx IRQ Flag Clear Register : Rx Half-CCD Communication Error IRQ Flag Clear
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_flag_clear_reg.rx_hccd_comm_err_irq_flag_clr;
                -- end if;

                when (16#0C#) =>
                    -- FTDI Rx IRQ Flag Clear Register : Rx Patch Reception Error IRQ Flag Clear
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_irq_flag_clear_reg.rx_patch_rcpt_err_irq_flag_clr;
                -- end if;

                when (16#0D#) =>
                    -- FTDI Tx IRQ Control Register : Tx LUT Finished Transmission IRQ Enable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.tx_irq_control_reg.tx_lut_finished_irq_en;
                -- end if;

                when (16#0E#) =>
                    -- FTDI Tx IRQ Control Register : Tx LUT Communication Error IRQ Enable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.tx_irq_control_reg.tx_lut_comm_err_irq_en;
                -- end if;

                when (16#0F#) =>
                    -- FTDI Tx IRQ Flag Register : Tx LUT Finished Transmission IRQ Flag
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_irq_flag_reg.tx_lut_finished_irq_flag;
                -- end if;

                when (16#10#) =>
                    -- FTDI Tx IRQ Flag Register : Tx LUT Communication Error IRQ Flag
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_irq_flag_reg.tx_lut_comm_err_irq_flag;
                -- end if;

                when (16#11#) =>
                    -- FTDI Tx IRQ Flag Clear Register : Tx LUT Finished Transmission IRQ Flag Clear
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.tx_irq_flag_clear_reg.tx_lut_finished_irq_flag_clear;
                -- end if;

                when (16#12#) =>
                    -- FTDI Tx IRQ Flag Clear Register : Tx LUT Communication Error IRQ Flag Clear
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.tx_irq_flag_clear_reg.tx_lut_comm_err_irq_flag_clear;
                -- end if;

                when (16#13#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD Request Timeout
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_req_timeout(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_req_timeout(15 downto 8);
                -- end if;

                when (16#14#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD FEE Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(2 downto 0) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_fee_number;
                -- end if;

                when (16#15#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD CCD Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(1 downto 0) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_ccd_number;
                -- end if;

                when (16#16#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD CCD Side
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_ccd_side;
                -- end if;

                when (16#17#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD CCD Height
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_ccd_height(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(12 downto 8) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_ccd_height(12 downto 8);
                -- end if;

                when (16#18#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD CCD Width
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_ccd_width(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(11 downto 8) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_ccd_width(11 downto 8);
                -- end if;

                when (16#19#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD Exposure Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_exposure_number(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_exposure_number(15 downto 8);
                -- end if;

                when (16#1A#) =>
                    -- FTDI Half-CCD Request Control Register : Request Half-CCD
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_request_hccd;
                -- end if;

                when (16#1B#) =>
                    -- FTDI Half-CCD Request Control Register : Abort Half-CCD Request
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_abort_hccd_req;
                -- end if;

                when (16#1C#) =>
                    -- FTDI Half-CCD Request Control Register : Reset Half-CCD Controller
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_reset_hccd_controller;
                -- end if;

                when (16#1D#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD Payload Image Length [pixels]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_payload_img_length_pixels(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_payload_img_length_pixels(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_payload_img_length_pixels(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_payload_img_length_pixels(31 downto 24);
                -- end if;

                when (16#1E#) =>
                    -- FTDI Half-CCD Request Control Register : Half-CCD Payload Overscan Length [pixels]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_payload_ovs_length_pixels(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_payload_ovs_length_pixels(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_payload_ovs_length_pixels(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.hccd_req_control_reg.req_hccd_payload_ovs_length_pixels(31 downto 24);
                -- end if;

                when (16#1F#) =>
                    -- FTDI Half-CCD Reply Status Register : Half-CCD FEE Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(2 downto 0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_fee_number;
                -- end if;

                when (16#20#) =>
                    -- FTDI Half-CCD Reply Status Register : Half-CCD CCD Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(1 downto 0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ccd_number;
                -- end if;

                when (16#21#) =>
                    -- FTDI Half-CCD Reply Status Register : Half-CCD CCD Side
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ccd_side;
                -- end if;

                when (16#22#) =>
                    -- FTDI Half-CCD Reply Status Register : Half-CCD CCD Height
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ccd_height(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(12 downto 8) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ccd_height(12 downto 8);
                -- end if;

                when (16#23#) =>
                    -- FTDI Half-CCD Reply Status Register : Half-CCD CCD Width
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ccd_width(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(11 downto 8) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ccd_width(11 downto 8);
                -- end if;

                when (16#24#) =>
                    -- FTDI Half-CCD Reply Status Register : Half-CCD Exposure Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_exposure_number(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_exposure_number(15 downto 8);
                -- end if;

                when (16#25#) =>
                    -- FTDI Half-CCD Reply Status Register : Half-CCD Image Length [Bytes]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_image_length_bytes(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_image_length_bytes(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_image_length_bytes(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_image_length_bytes(31 downto 24);
                -- end if;

                when (16#26#) =>
                    -- FTDI Half-CCD Reply Status Register : Half-CCD Received
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_received;
                -- end if;

                when (16#27#) =>
                    -- FTDI Half-CCD Reply Status Register : Half-CCD Controller Busy
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_controller_busy;
                -- end if;

                when (16#28#) =>
                    -- FTDI Half-CCD Reply Status Register : Half-CCD Last Rx Buffer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_last_rx_buffer;
                -- end if;

                when (16#29#) =>
                    -- FTDI Half-CCD Reply Status Register : Half-CCD Image Mask Setted Bits
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_img_mask_setted_bits(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_img_mask_setted_bits(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_img_mask_setted_bits(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_img_mask_setted_bits(31 downto 24);
                -- end if;

                when (16#2A#) =>
                    -- FTDI Half-CCD Reply Status Register : Half-CCD Overscan Mask Setted Bits
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ovs_mask_setted_bits(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ovs_mask_setted_bits(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ovs_mask_setted_bits(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_rd_regs_i.hccd_reply_status_reg.rly_hccd_ovs_mask_setted_bits(31 downto 24);
                -- end if;

                when (16#2B#) =>
                    -- FTDI LUT Transmission Control Register : LUT FEE Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(2 downto 0) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_fee_number;
                -- end if;

                when (16#2C#) =>
                    -- FTDI LUT Transmission Control Register : LUT CCD Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(1 downto 0) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_ccd_number;
                -- end if;

                when (16#2D#) =>
                    -- FTDI LUT Transmission Control Register : LUT CCD Side
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_ccd_side;
                -- end if;

                when (16#2E#) =>
                    -- FTDI LUT Transmission Control Register : LUT CCD Height
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_ccd_height(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(12 downto 8) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_ccd_height(12 downto 8);
                -- end if;

                when (16#2F#) =>
                    -- FTDI LUT Transmission Control Register : LUT CCD Width
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_ccd_width(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(11 downto 8) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_ccd_width(11 downto 8);
                -- end if;

                when (16#30#) =>
                    -- FTDI LUT Transmission Control Register : LUT Exposure Number
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_exposure_number(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_exposure_number(15 downto 8);
                -- end if;

                when (16#31#) =>
                    -- FTDI LUT Transmission Control Register : LUT Length [Bytes]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_length_bytes(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_length_bytes(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_length_bytes(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_length_bytes(31 downto 24);
                -- end if;

                when (16#32#) =>
                    -- FTDI LUT Transmission Control Register : LUT Request Timeout
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_trans_timeout(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_trans_timeout(15 downto 8);
                -- end if;

                when (16#33#) =>
                    -- FTDI LUT Transmission Control Register : Invert LUT 16-bits Words
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_invert_16b_words;
                -- end if;

                when (16#34#) =>
                    -- FTDI LUT Transmission Control Register : Transmit LUT
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_transmit;
                -- end if;

                when (16#35#) =>
                    -- FTDI LUT Transmission Control Register : Abort LUT Transmission
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_abort_transmission;
                -- end if;

                when (16#36#) =>
                    -- FTDI LUT Transmission Control Register : Reset LUT Controller
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.lut_trans_control_reg.lut_reset_controller;
                -- end if;

                when (16#37#) =>
                    -- FTDI LUT Transmission Status Register : LUT Transmitted
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.lut_trans_status_reg.lut_transmitted;
                -- end if;

                when (16#38#) =>
                    -- FTDI LUT Transmission Status Register : LUT Controller Busy
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.lut_trans_status_reg.lut_controller_busy;
                -- end if;

                when (16#39#) =>
                    -- FTDI Payload Configuration Register : Rx Payload Reader Force Length [Bytes]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.payload_config_reg.rx_payload_reader_force_length_bytes(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.payload_config_reg.rx_payload_reader_force_length_bytes(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.payload_config_reg.rx_payload_reader_force_length_bytes(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.payload_config_reg.rx_payload_reader_force_length_bytes(31 downto 24);
                -- end if;

                when (16#3A#) =>
                    -- FTDI Payload Configuration Register : Rx Payload Reader Qqword Delay
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.payload_config_reg.rx_payload_reader_qqword_delay(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.payload_config_reg.rx_payload_reader_qqword_delay(15 downto 8);
                -- end if;

                when (16#3B#) =>
                    -- FTDI Payload Configuration Register : Tx Payload Writer Qqword Delay
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.payload_config_reg.tx_payload_writer_qqword_delay(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.payload_config_reg.tx_payload_writer_qqword_delay(15 downto 8);
                -- end if;

                when (16#3C#) =>
                    -- FTDI Tx Data Control Register : Tx Initial Read Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_initial_addr_high_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_initial_addr_high_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_initial_addr_high_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_initial_addr_high_dword(31 downto 24);
                -- end if;

                when (16#3D#) =>
                    -- FTDI Tx Data Control Register : Tx Initial Read Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_initial_addr_low_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_initial_addr_low_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_initial_addr_low_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_initial_addr_low_dword(31 downto 24);
                -- end if;

                when (16#3E#) =>
                    -- FTDI Tx Data Control Register : Tx Read Data Length [Bytes]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_data_length_bytes(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_data_length_bytes(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_data_length_bytes(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_data_length_bytes(31 downto 24);
                -- end if;

                when (16#3F#) =>
                    -- FTDI Tx Data Control Register : Tx Data Read Start
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_start;
                -- end if;

                when (16#40#) =>
                    -- FTDI Tx Data Control Register : Tx Data Read Reset
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.tx_data_control_reg.tx_rd_reset;
                -- end if;

                when (16#41#) =>
                    -- FTDI Tx Data Status Register : Tx Data Read Busy
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_data_status_reg.tx_rd_busy;
                -- end if;

                when (16#42#) =>
                    -- FTDI Rx Data Control Register : Rx Initial Write Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_initial_addr_high_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_initial_addr_high_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_initial_addr_high_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_initial_addr_high_dword(31 downto 24);
                -- end if;

                when (16#43#) =>
                    -- FTDI Rx Data Control Register : Rx Initial Write Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_initial_addr_low_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_initial_addr_low_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_initial_addr_low_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_initial_addr_low_dword(31 downto 24);
                -- end if;

                when (16#44#) =>
                    -- FTDI Rx Data Control Register : Rx Write Data Length [Bytes]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_data_length_bytes(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_data_length_bytes(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_data_length_bytes(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_data_length_bytes(31 downto 24);
                -- end if;

                when (16#45#) =>
                    -- FTDI Rx Data Control Register : Rx Data Write Start
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_start;
                -- end if;

                when (16#46#) =>
                    -- FTDI Rx Data Control Register : Rx Data Write Reset
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.rx_data_control_reg.rx_wr_reset;
                -- end if;

                when (16#47#) =>
                    -- FTDI Rx Data Status Register : Rx Data Write Busy
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_data_status_reg.rx_wr_busy;
                -- end if;

                when (16#48#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Window List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_window_list_pointer(31 downto 24);
                -- end if;

                when (16#49#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Packet Order List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_packet_order_list_pointer(31 downto 24);
                -- end if;

                when (16#4A#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Window List Length
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_window_list_length(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_window_list_length(15 downto 8);
                -- end if;

                when (16#4B#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Windows Size X
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(5 downto 0) <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_x;
                -- end if;

                when (16#4C#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Windows Size Y
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(5 downto 0) <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_windows_size_y;
                -- end if;

                when (16#4D#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Last E Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_last_e_packet(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(9 downto 8) <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_last_e_packet(9 downto 8);
                -- end if;

                when (16#4E#) =>
                    -- FTDI LUT CCD1 Windowing Configuration : CCD1 Last F Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_last_f_packet(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(9 downto 8) <= ftdi_config_wr_regs_i.lut_ccd1_windowing_cfg_reg.ccd1_last_f_packet(9 downto 8);
                -- end if;

                when (16#4F#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Window List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_window_list_pointer(31 downto 24);
                -- end if;

                when (16#50#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Packet Order List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_packet_order_list_pointer(31 downto 24);
                -- end if;

                when (16#51#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Window List Length
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_window_list_length(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_window_list_length(15 downto 8);
                -- end if;

                when (16#52#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Windows Size X
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(5 downto 0) <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_x;
                -- end if;

                when (16#53#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Windows Size Y
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(5 downto 0) <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_windows_size_y;
                -- end if;

                when (16#54#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Last E Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_last_e_packet(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(9 downto 8) <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_last_e_packet(9 downto 8);
                -- end if;

                when (16#55#) =>
                    -- FTDI LUT CCD2 Windowing Configuration : CCD2 Last F Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_last_f_packet(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(9 downto 8) <= ftdi_config_wr_regs_i.lut_ccd2_windowing_cfg_reg.ccd2_last_f_packet(9 downto 8);
                -- end if;

                when (16#56#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Window List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_window_list_pointer(31 downto 24);
                -- end if;

                when (16#57#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Packet Order List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_packet_order_list_pointer(31 downto 24);
                -- end if;

                when (16#58#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Window List Length
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_window_list_length(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_window_list_length(15 downto 8);
                -- end if;

                when (16#59#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Windows Size X
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(5 downto 0) <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_x;
                -- end if;

                when (16#5A#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Windows Size Y
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(5 downto 0) <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_windows_size_y;
                -- end if;

                when (16#5B#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Last E Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_last_e_packet(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(9 downto 8) <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_last_e_packet(9 downto 8);
                -- end if;

                when (16#5C#) =>
                    -- FTDI LUT CCD3 Windowing Configuration : CCD3 Last F Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_last_f_packet(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(9 downto 8) <= ftdi_config_wr_regs_i.lut_ccd3_windowing_cfg_reg.ccd3_last_f_packet(9 downto 8);
                -- end if;

                when (16#5D#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Window List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_window_list_pointer(31 downto 24);
                -- end if;

                when (16#5E#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Packet Order List Pointer
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_packet_order_list_pointer(31 downto 24);
                -- end if;

                when (16#5F#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Window List Length
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_window_list_length(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_window_list_length(15 downto 8);
                -- end if;

                when (16#60#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Windows Size X
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(5 downto 0) <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_x;
                -- end if;

                when (16#61#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Windows Size Y
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(5 downto 0) <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_windows_size_y;
                -- end if;

                when (16#62#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Last E Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_last_e_packet(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(9 downto 8) <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_last_e_packet(9 downto 8);
                -- end if;

                when (16#63#) =>
                    -- FTDI LUT CCD4 Windowing Configuration : CCD4 Last F Packet
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_last_f_packet(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(9 downto 8) <= ftdi_config_wr_regs_i.lut_ccd4_windowing_cfg_reg.ccd4_last_f_packet(9 downto 8);
                -- end if;

                when (16#64#) =>
                    -- FTDI Rx Communication Error Register : Rx Communication Error State
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.rx_comm_err_state;
                -- end if;

                when (16#65#) =>
                    -- FTDI Rx Communication Error Register : Rx Communication Error Code
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_rd_regs_i.rx_comm_error_reg.rx_comm_err_code(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_rd_regs_i.rx_comm_error_reg.rx_comm_err_code(15 downto 8);
                -- end if;

                when (16#66#) =>
                    -- FTDI Rx Communication Error Register : Half-CCD Request Nack Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_req_nack_err;
                -- end if;

                when (16#67#) =>
                    -- FTDI Rx Communication Error Register : Half-CCD Reply Wrong Header CRC Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_reply_header_crc_err;
                -- end if;

                when (16#68#) =>
                    -- FTDI Rx Communication Error Register : Half-CCD Reply End of Header Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_reply_eoh_err;
                -- end if;

                when (16#69#) =>
                    -- FTDI Rx Communication Error Register : Half-CCD Reply Wrong Payload CRC Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_reply_payload_crc_err;
                -- end if;

                when (16#6A#) =>
                    -- FTDI Rx Communication Error Register : Half-CCD Reply End of Payload Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_reply_eop_err;
                -- end if;

                when (16#6B#) =>
                    -- FTDI Rx Communication Error Register : Half-CCD Request Maximum Tries Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_req_max_tries_err;
                -- end if;

                when (16#6C#) =>
                    -- FTDI Rx Communication Error Register : Half-CCD Request CCD Size Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_reply_ccd_size_err;
                -- end if;

                when (16#6D#) =>
                    -- FTDI Rx Communication Error Register : Half-CCD Request Timeout Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_comm_error_reg.err_hccd_req_timeout_err;
                -- end if;

                when (16#6E#) =>
                    -- FTDI Tx LUT Communication Error Register : Tx LUT Communication Error State
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_comm_error_reg.tx_lut_comm_err_state;
                -- end if;

                when (16#6F#) =>
                    -- FTDI Tx LUT Communication Error Register : Tx LUT Communication Error Code
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_rd_regs_i.tx_comm_error_reg.tx_lut_comm_err_code(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_rd_regs_i.tx_comm_error_reg.tx_lut_comm_err_code(15 downto 8);
                -- end if;

                when (16#70#) =>
                    -- FTDI Tx LUT Communication Error Register : LUT Transmit NACK Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_comm_error_reg.err_lut_transmit_nack;
                -- end if;

                when (16#71#) =>
                    -- FTDI Tx LUT Communication Error Register : LUT Reply Wrong Header CRC Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_comm_error_reg.err_lut_reply_head_crc;
                -- end if;

                when (16#72#) =>
                    -- FTDI Tx LUT Communication Error Register : LUT Reply End of Header Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_comm_error_reg.err_lut_reply_head_eoh;
                -- end if;

                when (16#73#) =>
                    -- FTDI Tx LUT Communication Error Register : LUT Transmission Maximum Tries Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_comm_error_reg.err_lut_trans_max_tries;
                -- end if;

                when (16#74#) =>
                    -- FTDI Tx LUT Communication Error Register : LUT Payload NACK Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_comm_error_reg.err_lut_payload_nack;
                -- end if;

                when (16#75#) =>
                    -- FTDI Tx LUT Communication Error Register : LUT Transmission Timeout Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_comm_error_reg.err_lut_trans_timeout;
                -- end if;

                when (16#76#) =>
                    -- FTDI Rx Buffer Status Register : Rx Buffer Readable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_rdable;
                -- end if;

                when (16#77#) =>
                    -- FTDI Rx Buffer Status Register : Rx Buffer Empty
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_empty;
                -- end if;

                when (16#78#) =>
                    -- FTDI Rx Buffer Status Register : Rx Buffer Used [Bytes]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_used_bytes(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_used_bytes(15 downto 8);
                -- end if;

                when (16#79#) =>
                    -- FTDI Rx Buffer Status Register : Rx Buffer Full
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.rx_buffer_status_reg.rx_buffer_full;
                -- end if;

                when (16#7A#) =>
                    -- FTDI Tx Buffer Status Register : Tx Buffer Writeable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_wrable;
                -- end if;

                when (16#7B#) =>
                    -- FTDI Tx Buffer Status Register : Tx Buffer Empty
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_empty;
                -- end if;

                when (16#7C#) =>
                    -- FTDI Tx Buffer Status Register : Tx Buffer Used [Bytes]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_used_bytes(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_used_bytes(15 downto 8);
                -- end if;

                when (16#7D#) =>
                    -- FTDI Tx Buffer Status Register : Tx Buffer Full
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.tx_buffer_status_reg.tx_buffer_full;
                -- end if;

                when (16#7E#) =>
                    -- FTDI Patch Reception Control Register : Patch Reception Timeout
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.patch_reception_control_reg.patch_rcpt_timeout(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.patch_reception_control_reg.patch_rcpt_timeout(15 downto 8);
                -- end if;

                when (16#7F#) =>
                    -- FTDI Patch Reception Control Register : Patch Reception Enable
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.patch_reception_control_reg.patch_rcpt_enable;
                -- end if;

                when (16#80#) =>
                    -- FTDI Patch Reception Control Register : Patch Reception Discard
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.patch_reception_control_reg.patch_rcpt_discard;
                -- end if;

                when (16#81#) =>
                    -- FTDI Patch Reception Control Register : Patch Reception Invert Pixels Byte Order
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_wr_regs_i.patch_reception_control_reg.patch_rcpt_invert_pixels_byte_order;
                -- end if;

                when (16#82#) =>
                    -- FTDI Patch Reception Control Register : Patch Reception Data Delay
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_control_reg.patch_rcpt_data_delay(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_control_reg.patch_rcpt_data_delay(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_control_reg.patch_rcpt_data_delay(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_control_reg.patch_rcpt_data_delay(31 downto 24);
                -- end if;

                when (16#83#) =>
                    -- FTDI Patch Reception Status Register : Patch Reception Busy
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.patch_reception_status_reg.patch_reception_busy;
                -- end if;

                when (16#84#) =>
                    -- FTDI Patch Reception Config Register : FEEs CCDs Half-Width Pixels Size
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fees_ccds_halfwidth_pixels(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fees_ccds_halfwidth_pixels(15 downto 8);
                -- end if;

                when (16#85#) =>
                    -- FTDI Patch Reception Config Register : FEEs CCDs Height Pixels Size
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fees_ccds_height_pixels(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fees_ccds_height_pixels(15 downto 8);
                -- end if;

                when (16#86#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_high_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_high_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_high_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_high_dword(31 downto 24);
                -- end if;

                when (16#87#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_low_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_low_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_low_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_left_init_addr_low_dword(31 downto 24);
                -- end if;

                when (16#88#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_high_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_high_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_high_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_high_dword(31 downto 24);
                -- end if;

                when (16#89#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 0 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_low_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_low_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_low_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_0_right_init_addr_low_dword(31 downto 24);
                -- end if;

                when (16#8A#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_high_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_high_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_high_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_high_dword(31 downto 24);
                -- end if;

                when (16#8B#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_low_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_low_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_low_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_left_init_addr_low_dword(31 downto 24);
                -- end if;

                when (16#8C#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_high_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_high_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_high_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_high_dword(31 downto 24);
                -- end if;

                when (16#8D#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 1 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_low_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_low_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_low_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_1_right_init_addr_low_dword(31 downto 24);
                -- end if;

                when (16#8E#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_high_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_high_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_high_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_high_dword(31 downto 24);
                -- end if;

                when (16#8F#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_low_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_low_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_low_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_left_init_addr_low_dword(31 downto 24);
                -- end if;

                when (16#90#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_high_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_high_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_high_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_high_dword(31 downto 24);
                -- end if;

                when (16#91#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 2 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_low_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_low_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_low_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_2_right_init_addr_low_dword(31 downto 24);
                -- end if;

                when (16#92#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Left Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_high_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_high_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_high_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_high_dword(31 downto 24);
                -- end if;

                when (16#93#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Left Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_low_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_low_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_low_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_left_init_addr_low_dword(31 downto 24);
                -- end if;

                when (16#94#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Right Initial Address [High Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_high_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_high_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_high_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_high_dword(31 downto 24);
                -- end if;

                when (16#95#) =>
                    -- FTDI Patch Reception Config Register : FEE 0 CCD 3 Right Initial Address [Low Dword]
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_low_dword(7 downto 0);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_low_dword(15 downto 8);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_low_dword(23 downto 16);
                    -- end if;
                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_0_ccd_3_right_init_addr_low_dword(31 downto 24);
                -- end if;

                --                when (16#96#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#97#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#98#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#99#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 0 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_0_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#9A#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#9B#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#9C#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#9D#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 1 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_1_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#9E#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#9F#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#A0#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#A1#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 2 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_2_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#A2#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#A3#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#A4#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#A5#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 1 CCD 3 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_1_ccd_3_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#A6#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#A7#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#A8#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#A9#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 0 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_0_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#AA#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#AB#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#AC#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#AD#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 1 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_1_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#AE#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#AF#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#B0#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#B1#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 2 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_2_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#B2#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#B3#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#B4#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#B5#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 2 CCD 3 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_2_ccd_3_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#B6#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#B7#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#B8#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#B9#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 0 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_0_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#BA#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#BB#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#BC#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#BD#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 1 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_1_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#BE#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#BF#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#C0#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#C1#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 2 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_2_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#C2#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#C3#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#C4#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#C5#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 3 CCD 3 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_3_ccd_3_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#C6#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#C7#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#C8#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#C9#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 0 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_0_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#CA#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#CB#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#CC#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#CD#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 1 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_1_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#CE#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#CF#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#D0#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#D1#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 2 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_2_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#D2#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#D3#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#D4#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#D5#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 4 CCD 3 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_4_ccd_3_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#D6#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#D7#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#D8#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#D9#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 0 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_0_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#DA#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#DB#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#DC#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#DD#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 1 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_1_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#DE#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#DF#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#E0#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#E1#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 2 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_2_right_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#E2#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Left Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#E3#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Left Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_left_init_addr_low_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#E4#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Right Initial Address [High Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_high_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_high_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_high_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_high_dword(31 downto 24);
                --                -- end if;
                --
                --                when (16#E5#) =>
                --                    -- FTDI Patch Reception Config Register : FEE 5 CCD 3 Right Initial Address [Low Dword]
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(7 downto 0)   <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_low_dword(7 downto 0);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(1) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(15 downto 8)  <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_low_dword(15 downto 8);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(2) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(23 downto 16) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_low_dword(23 downto 16);
                --                    -- end if;
                --                    --  if (ftdi_config_avalon_mm_i.byteenable(3) = '1') then
                --                    ftdi_config_avalon_mm_o.readdata(31 downto 24) <= ftdi_config_wr_regs_i.patch_reception_config_reg.fee_5_ccd_3_right_init_addr_low_dword(31 downto 24);
                --                -- end if;

                when (16#E6#) =>
                    -- FTDI Patch Reception Error Register : Patch Reception Error State
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.patch_reception_error_reg.patch_rcpt_err_state;
                -- end if;

                when (16#E7#) =>
                    -- FTDI Patch Reception Error Register : Patch Reception Error Code
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(7 downto 0) <= ftdi_config_rd_regs_i.patch_reception_error_reg.patch_rcpt_err_code;
                -- end if;

                when (16#E8#) =>
                    -- FTDI Patch Reception Error Register : Patch Reception Nack Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.patch_reception_error_reg.patch_rcpt_nack_err;
                -- end if;

                when (16#E9#) =>
                    -- FTDI Patch Reception Error Register : Patch Reception Wrong Header CRC Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.patch_reception_error_reg.patch_rcpt_wrong_header_crc_err;
                -- end if;

                when (16#EA#) =>
                    -- FTDI Patch Reception Error Register : Patch Reception End of Header Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.patch_reception_error_reg.patch_rcpt_end_of_header_err;
                -- end if;

                when (16#EB#) =>
                    -- FTDI Patch Reception Error Register : Patch Reception Wrong Payload CRC Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.patch_reception_error_reg.patch_rcpt_wrong_payload_crc_err;
                -- end if;

                when (16#EC#) =>
                    -- FTDI Patch Reception Error Register : Patch Reception End of Payload Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.patch_reception_error_reg.patch_rcpt_end_of_payload_err;
                -- end if;

                when (16#ED#) =>
                    -- FTDI Patch Reception Error Register : Patch Reception Maximum Tries Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.patch_reception_error_reg.patch_rcpt_maximum_tries_err;
                -- end if;

                when (16#EE#) =>
                    -- FTDI Patch Reception Error Register : Patch Reception Timeout Error
                    --  if (ftdi_config_avalon_mm_i.byteenable(0) = '1') then
                    ftdi_config_avalon_mm_o.readdata(0) <= ftdi_config_rd_regs_i.patch_reception_error_reg.patch_rcpt_timeout_err;
                -- end if;

                when others =>
                    -- No register associated to the address, return with 0x00000000
                    ftdi_config_avalon_mm_o.readdata <= (others => '0');

            end case;

        end procedure p_readdata;

        variable v_read_address : t_ftdi_config_avalon_mm_address := 0;
    begin
        if (rst_i = '1') then
            ftdi_config_avalon_mm_o.readdata    <= (others => '0');
            ftdi_config_avalon_mm_o.waitrequest <= '1';
            v_read_address                      := 0;
        elsif (rising_edge(clk_i)) then
            ftdi_config_avalon_mm_o.readdata    <= (others => '0');
            ftdi_config_avalon_mm_o.waitrequest <= '1';
            if (ftdi_config_avalon_mm_i.read = '1') then
                v_read_address                      := to_integer(unsigned(ftdi_config_avalon_mm_i.address));
                ftdi_config_avalon_mm_o.waitrequest <= '0';
                p_readdata(v_read_address);
            end if;
        end if;
    end process p_ftdi_config_avalon_mm_read;

end architecture rtl;
