-- fdrm_rmap_memory_ffee_deb_area_top.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.fdrm_avalon_mm_rmap_ffee_deb_pkg.all;
use work.fdrm_rmap_mem_area_ffee_deb_pkg.all;
use work.fdrm_avm_rmap_ffee_deb_pkg.all;

entity fdrm_rmap_memory_ffee_deb_area_top is
	port(
		reset_i                                  : in  std_logic                     := '0'; --          --                      reset_sink.reset
		clk_100_i                                : in  std_logic                     := '0'; --          --               clock_sink_100mhz.clk
		avs_rmap_0_address_i                     : in  std_logic_vector(11 downto 0) := (others => '0'); --             avalon_rmap_slave_0.address
		avs_rmap_0_write_i                       : in  std_logic                     := '0'; --          --                                .write
		avs_rmap_0_read_i                        : in  std_logic                     := '0'; --          --                                .read
		avs_rmap_0_readdata_o                    : out std_logic_vector(31 downto 0); --                 --                                .readdata
		avs_rmap_0_writedata_i                   : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .writedata
		avs_rmap_0_waitrequest_o                 : out std_logic; --                                     --                                .waitrequest
--		avs_rmap_0_byteenable_i                  : in  std_logic_vector(3 downto 0)  := (others => '0'); --                                .byteenable
		rms_rmap_0_wr_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_0.wr_address_signal
		rms_rmap_0_write_i                       : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_0_writedata_i                   : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_0_rd_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_0_read_i                        : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_0_wr_waitrequest_o              : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_0_readdata_o                    : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_0_rd_waitrequest_o              : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_1_wr_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_1.wr_address_signal
		rms_rmap_1_write_i                       : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_1_writedata_i                   : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_1_rd_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_1_read_i                        : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_1_wr_waitrequest_o              : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_1_readdata_o                    : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_1_rd_waitrequest_o              : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_2_wr_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_2.wr_address_signal
		rms_rmap_2_write_i                       : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_2_writedata_i                   : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_2_rd_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_2_read_i                        : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_2_wr_waitrequest_o              : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_2_readdata_o                    : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_2_rd_waitrequest_o              : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_3_wr_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_3.wr_address_signal
		rms_rmap_3_write_i                       : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_3_writedata_i                   : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_3_rd_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_3_read_i                        : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_3_wr_waitrequest_o              : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_3_readdata_o                    : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_3_rd_waitrequest_o              : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_4_wr_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_4.wr_address_signal
		rms_rmap_4_write_i                       : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_4_writedata_i                   : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_4_rd_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_4_read_i                        : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_4_wr_waitrequest_o              : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_4_readdata_o                    : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_4_rd_waitrequest_o              : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_5_wr_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_5.wr_address_signal
		rms_rmap_5_write_i                       : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_5_writedata_i                   : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_5_rd_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_5_read_i                        : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_5_wr_waitrequest_o              : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_5_readdata_o                    : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_5_rd_waitrequest_o              : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_6_wr_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_6.wr_address_signal
		rms_rmap_6_write_i                       : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_6_writedata_i                   : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_6_rd_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_6_read_i                        : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_6_wr_waitrequest_o              : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_6_readdata_o                    : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_6_rd_waitrequest_o              : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_7_wr_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_7.wr_address_signal
		rms_rmap_7_write_i                       : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_7_writedata_i                   : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_7_rd_address_i                  : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_7_read_i                        : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_7_wr_waitrequest_o              : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_7_readdata_o                    : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_7_rd_waitrequest_o              : out std_logic; --                                     --                                .rd_waitrequest_signal
		avm_rmap_readdata_i                      : in  std_logic_vector(7 downto 0)  := (others => '0'); --           avalon_mm_rmap_master.readdata
		avm_rmap_waitrequest_i                   : in  std_logic                     := '0'; --          --                                .waitrequest
		avm_rmap_address_o                       : out std_logic_vector(63 downto 0); --                 --                                .address
		avm_rmap_read_o                          : out std_logic; --                                     --                                .read
		avm_rmap_write_o                         : out std_logic; --                                     --                                .write
		avm_rmap_writedata_o                     : out std_logic_vector(7 downto 0); --                  --                                .writedata
		channel_hk_0_rmap_target_status_i        : in  std_logic_vector(7 downto 0); --                  --     conduit_end_channel_hk_in_0.rmap_target_status_signal
		channel_hk_0_rmap_target_indicate_i      : in  std_logic; --                                     --                                .rmap_target_indicate_signal
		channel_hk_0_spw_link_escape_err_i       : in  std_logic; --                                     --                                .spw_link_escape_err_signal
		channel_hk_0_spw_link_credit_err_i       : in  std_logic; --                                     --                                .spw_link_credit_err_signal
		channel_hk_0_spw_link_parity_err_i       : in  std_logic; --                                     --                                .spw_link_parity_err_signal
		channel_hk_0_spw_link_disconnect_i       : in  std_logic; --                                     --                                .spw_link_disconnect_signal
		channel_hk_0_spw_link_started_i          : in  std_logic; --                                     --                                .spw_link_started_signal
		channel_hk_0_spw_link_connecting_i       : in  std_logic; --                                     --                                .spw_link_connecting_signal
		channel_hk_0_spw_link_running_i          : in  std_logic; --                                     --                                .spw_link_running_signal
		channel_hk_0_frame_counter_i             : in  std_logic_vector(15 downto 0); --                 --                                .frame_counter_signal
		channel_hk_0_left_buffer_ccd_number_i    : in  std_logic_vector(1 downto 0); --                  --                                .left_buffer_ccd_number_signal
		channel_hk_0_right_buffer_ccd_number_i   : in  std_logic_vector(1 downto 0); --                  --                                .right_buffer_ccd_number_signal
		channel_hk_0_left_buffer_ccd_side_i      : in  std_logic; --                                     --                                .left_buffer_ccd_side_signal
		channel_hk_0_right_buffer_ccd_side_i     : in  std_logic; --                                     --                                .right_buffer_ccd_side_signal
		channel_hk_0_err_left_buffer_overflow_i  : in  std_logic; --                                     --                                .err_left_buffer_overflow_signal
		channel_hk_0_err_right_buffer_overflow_i : in  std_logic; --                                     --                                .err_right_buffer_overflow_signal
		channel_hk_1_rmap_target_status_i        : in  std_logic_vector(7 downto 0); --                  --     conduit_end_channel_hk_in_1.rmap_target_status_signal
		channel_hk_1_rmap_target_indicate_i      : in  std_logic; --                                     --                                .rmap_target_indicate_signal
		channel_hk_1_spw_link_escape_err_i       : in  std_logic; --                                     --                                .spw_link_escape_err_signal
		channel_hk_1_spw_link_credit_err_i       : in  std_logic; --                                     --                                .spw_link_credit_err_signal
		channel_hk_1_spw_link_parity_err_i       : in  std_logic; --                                     --                                .spw_link_parity_err_signal
		channel_hk_1_spw_link_disconnect_i       : in  std_logic; --                                     --                                .spw_link_disconnect_signal
		channel_hk_1_spw_link_started_i          : in  std_logic; --                                     --                                .spw_link_started_signal
		channel_hk_1_spw_link_connecting_i       : in  std_logic; --                                     --                                .spw_link_connecting_signal
		channel_hk_1_spw_link_running_i          : in  std_logic; --                                     --                                .spw_link_running_signal
		channel_hk_1_frame_counter_i             : in  std_logic_vector(15 downto 0); --                 --                                .frame_counter_signal
		channel_hk_1_left_buffer_ccd_number_i    : in  std_logic_vector(1 downto 0); --                  --                                .left_buffer_ccd_number_signal
		channel_hk_1_right_buffer_ccd_number_i   : in  std_logic_vector(1 downto 0); --                  --                                .right_buffer_ccd_number_signal
		channel_hk_1_left_buffer_ccd_side_i      : in  std_logic; --                                     --                                .left_buffer_ccd_side_signal
		channel_hk_1_right_buffer_ccd_side_i     : in  std_logic; --                                     --                                .right_buffer_ccd_side_signal
		channel_hk_1_err_left_buffer_overflow_i  : in  std_logic; --                                     --                                .err_left_buffer_overflow_signal
		channel_hk_1_err_right_buffer_overflow_i : in  std_logic; --                                     --                                .err_right_buffer_overflow_signal
		channel_hk_2_rmap_target_status_i        : in  std_logic_vector(7 downto 0); --                  --     conduit_end_channel_hk_in_2.rmap_target_status_signal
		channel_hk_2_rmap_target_indicate_i      : in  std_logic; --                                     --                                .rmap_target_indicate_signal
		channel_hk_2_spw_link_escape_err_i       : in  std_logic; --                                     --                                .spw_link_escape_err_signal
		channel_hk_2_spw_link_credit_err_i       : in  std_logic; --                                     --                                .spw_link_credit_err_signal
		channel_hk_2_spw_link_parity_err_i       : in  std_logic; --                                     --                                .spw_link_parity_err_signal
		channel_hk_2_spw_link_disconnect_i       : in  std_logic; --                                     --                                .spw_link_disconnect_signal
		channel_hk_2_spw_link_started_i          : in  std_logic; --                                     --                                .spw_link_started_signal
		channel_hk_2_spw_link_connecting_i       : in  std_logic; --                                     --                                .spw_link_connecting_signal
		channel_hk_2_spw_link_running_i          : in  std_logic; --                                     --                                .spw_link_running_signal
		channel_hk_2_frame_counter_i             : in  std_logic_vector(15 downto 0); --                 --                                .frame_counter_signal
		channel_hk_2_left_buffer_ccd_number_i    : in  std_logic_vector(1 downto 0); --                  --                                .left_buffer_ccd_number_signal
		channel_hk_2_right_buffer_ccd_number_i   : in  std_logic_vector(1 downto 0); --                  --                                .right_buffer_ccd_number_signal
		channel_hk_2_left_buffer_ccd_side_i      : in  std_logic; --                                     --                                .left_buffer_ccd_side_signal
		channel_hk_2_right_buffer_ccd_side_i     : in  std_logic; --                                     --                                .right_buffer_ccd_side_signal
		channel_hk_2_err_left_buffer_overflow_i  : in  std_logic; --                                     --                                .err_left_buffer_overflow_signal
		channel_hk_2_err_right_buffer_overflow_i : in  std_logic; --                                     --                                .err_right_buffer_overflow_signal
		channel_hk_3_rmap_target_status_i        : in  std_logic_vector(7 downto 0); --                  --     conduit_end_channel_hk_in_3.rmap_target_status_signal
		channel_hk_3_rmap_target_indicate_i      : in  std_logic; --                                     --                                .rmap_target_indicate_signal
		channel_hk_3_spw_link_escape_err_i       : in  std_logic; --                                     --                                .spw_link_escape_err_signal
		channel_hk_3_spw_link_credit_err_i       : in  std_logic; --                                     --                                .spw_link_credit_err_signal
		channel_hk_3_spw_link_parity_err_i       : in  std_logic; --                                     --                                .spw_link_parity_err_signal
		channel_hk_3_spw_link_disconnect_i       : in  std_logic; --                                     --                                .spw_link_disconnect_signal
		channel_hk_3_spw_link_started_i          : in  std_logic; --                                     --                                .spw_link_started_signal
		channel_hk_3_spw_link_connecting_i       : in  std_logic; --                                     --                                .spw_link_connecting_signal
		channel_hk_3_spw_link_running_i          : in  std_logic; --                                     --                                .spw_link_running_signal
		channel_hk_3_frame_counter_i             : in  std_logic_vector(15 downto 0); --                 --                                .frame_counter_signal
		channel_hk_3_left_buffer_ccd_number_i    : in  std_logic_vector(1 downto 0); --                  --                                .left_buffer_ccd_number_signal
		channel_hk_3_right_buffer_ccd_number_i   : in  std_logic_vector(1 downto 0); --                  --                                .right_buffer_ccd_number_signal
		channel_hk_3_left_buffer_ccd_side_i      : in  std_logic; --                                     --                                .left_buffer_ccd_side_signal
		channel_hk_3_right_buffer_ccd_side_i     : in  std_logic; --                                     --                                .right_buffer_ccd_side_signal
		channel_hk_3_err_left_buffer_overflow_i  : in  std_logic; --                                     --                                .err_left_buffer_overflow_signal
		channel_hk_3_err_right_buffer_overflow_i : in  std_logic; --                                     --                                .err_right_buffer_overflow_signal
		channel_win_mem_addr_offset_i            : in  std_logic_vector(63 downto 0) := (others => '0') --- conduit_end_rmap_avm_configs_in.win_mem_addr_offset_signal
	);
end entity fdrm_rmap_memory_ffee_deb_area_top;

architecture rtl of fdrm_rmap_memory_ffee_deb_area_top is

	-- alias --
	alias a_avs_clock is clk_100_i;
	alias a_reset is reset_i;

	-- signals --

	-- rmap memory signals
	signal s_rmap_mem_wr_area          : t_rmap_memory_wr_area;
	signal s_rmap_mem_rd_area          : t_rmap_memory_rd_area;
	-- avs 0 signals
	signal s_avs_0_rmap_wr_waitrequest : std_logic;
	signal s_avs_0_rmap_rd_waitrequest : std_logic;
	-- fee rmap cfg & hk signals
	signal s_fee_wr_rmap_cfg_hk_in     : t_fdrm_ffee_deb_rmap_write_in;
	signal s_fee_wr_rmap_cfg_hk_out    : t_fdrm_ffee_deb_rmap_write_out;
	signal s_fee_rd_rmap_cfg_hk_in     : t_fdrm_ffee_deb_rmap_read_in;
	signal s_fee_rd_rmap_cfg_hk_out    : t_fdrm_ffee_deb_rmap_read_out;
	-- avs rmap signals
	signal s_avalon_mm_wr_rmap_in      : t_fdrm_avalon_mm_rmap_ffee_deb_write_in;
	signal s_avalon_mm_wr_rmap_out     : t_fdrm_avalon_mm_rmap_ffee_deb_write_out;
	signal s_avalon_mm_rd_rmap_in      : t_fdrm_avalon_mm_rmap_ffee_deb_read_in;
	signal s_avalon_mm_rd_rmap_out     : t_fdrm_avalon_mm_rmap_ffee_deb_read_out;
	-- avm rmap & fee rmap win signals
	signal s_avm_rmap_rd_address       : std_logic_vector((c_FDRM_AVM_ADRESS_SIZE - 1) downto 0);
	signal s_avm_rmap_wr_address       : std_logic_vector((c_FDRM_AVM_ADRESS_SIZE - 1) downto 0);
	signal s_fee_wr_rmap_win_in        : t_fdrm_ffee_deb_rmap_write_in;
	signal s_fee_wr_rmap_win_out       : t_fdrm_ffee_deb_rmap_write_out;
	signal s_fee_rd_rmap_win_in        : t_fdrm_ffee_deb_rmap_read_in;
	signal s_fee_rd_rmap_win_out       : t_fdrm_ffee_deb_rmap_read_out;

begin

	fdrm_rmap_mem_area_ffee_deb_arbiter_ent_inst : entity work.fdrm_rmap_mem_area_ffee_deb_arbiter_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			fee_0_wr_rmap_i.address           => rms_rmap_0_wr_address_i,
			fee_0_wr_rmap_i.write             => rms_rmap_0_write_i,
			fee_0_wr_rmap_i.writedata         => rms_rmap_0_writedata_i,
			fee_0_rd_rmap_i.address           => rms_rmap_0_rd_address_i,
			fee_0_rd_rmap_i.read              => rms_rmap_0_read_i,
			fee_1_wr_rmap_i.address           => rms_rmap_1_wr_address_i,
			fee_1_wr_rmap_i.write             => rms_rmap_1_write_i,
			fee_1_wr_rmap_i.writedata         => rms_rmap_1_writedata_i,
			fee_1_rd_rmap_i.address           => rms_rmap_1_rd_address_i,
			fee_1_rd_rmap_i.read              => rms_rmap_1_read_i,
			fee_2_wr_rmap_i.address           => rms_rmap_2_wr_address_i,
			fee_2_wr_rmap_i.write             => rms_rmap_2_write_i,
			fee_2_wr_rmap_i.writedata         => rms_rmap_2_writedata_i,
			fee_2_rd_rmap_i.address           => rms_rmap_2_rd_address_i,
			fee_2_rd_rmap_i.read              => rms_rmap_2_read_i,
			fee_3_wr_rmap_i.address           => rms_rmap_3_wr_address_i,
			fee_3_wr_rmap_i.write             => rms_rmap_3_write_i,
			fee_3_wr_rmap_i.writedata         => rms_rmap_3_writedata_i,
			fee_3_rd_rmap_i.address           => rms_rmap_3_rd_address_i,
			fee_3_rd_rmap_i.read              => rms_rmap_3_read_i,
			fee_4_wr_rmap_i.address           => rms_rmap_4_wr_address_i,
			fee_4_wr_rmap_i.write             => rms_rmap_4_write_i,
			fee_4_wr_rmap_i.writedata         => rms_rmap_4_writedata_i,
			fee_4_rd_rmap_i.address           => rms_rmap_4_rd_address_i,
			fee_4_rd_rmap_i.read              => rms_rmap_4_read_i,
			fee_5_wr_rmap_i.address           => rms_rmap_5_wr_address_i,
			fee_5_wr_rmap_i.write             => rms_rmap_5_write_i,
			fee_5_wr_rmap_i.writedata         => rms_rmap_5_writedata_i,
			fee_5_rd_rmap_i.address           => rms_rmap_5_rd_address_i,
			fee_5_rd_rmap_i.read              => rms_rmap_5_read_i,
			fee_6_wr_rmap_i.address           => rms_rmap_6_wr_address_i,
			fee_6_wr_rmap_i.write             => rms_rmap_6_write_i,
			fee_6_wr_rmap_i.writedata         => rms_rmap_6_writedata_i,
			fee_6_rd_rmap_i.address           => rms_rmap_6_rd_address_i,
			fee_6_rd_rmap_i.read              => rms_rmap_6_read_i,
			fee_7_wr_rmap_i.address           => rms_rmap_7_wr_address_i,
			fee_7_wr_rmap_i.write             => rms_rmap_7_write_i,
			fee_7_wr_rmap_i.writedata         => rms_rmap_7_writedata_i,
			fee_7_rd_rmap_i.address           => rms_rmap_7_rd_address_i,
			fee_7_rd_rmap_i.read              => rms_rmap_7_read_i,
			avalon_0_mm_wr_rmap_i.address     => avs_rmap_0_address_i,
			avalon_0_mm_wr_rmap_i.write       => avs_rmap_0_write_i,
			avalon_0_mm_wr_rmap_i.writedata   => avs_rmap_0_writedata_i,
--			avalon_0_mm_wr_rmap_i.byteenable  => avs_rmap_0_byteenable_i,
			avalon_0_mm_wr_rmap_i.byteenable  => (others => '1'),
			avalon_0_mm_rd_rmap_i.address     => avs_rmap_0_address_i,
			avalon_0_mm_rd_rmap_i.read        => avs_rmap_0_read_i,
--			avalon_0_mm_rd_rmap_i.byteenable  => avs_rmap_0_byteenable_i,
			avalon_0_mm_rd_rmap_i.byteenable  => (others => '1'),
			fee_wr_rmap_cfg_hk_i              => s_fee_wr_rmap_cfg_hk_out,
			fee_rd_rmap_cfg_hk_i              => s_fee_rd_rmap_cfg_hk_out,
			fee_wr_rmap_win_i                 => s_fee_wr_rmap_win_out,
			fee_rd_rmap_win_i                 => s_fee_rd_rmap_win_out,
			avalon_mm_wr_rmap_i               => s_avalon_mm_wr_rmap_out,
			avalon_mm_rd_rmap_i               => s_avalon_mm_rd_rmap_out,
			fee_0_wr_rmap_o.waitrequest       => rms_rmap_0_wr_waitrequest_o,
			fee_0_rd_rmap_o.readdata          => rms_rmap_0_readdata_o,
			fee_0_rd_rmap_o.waitrequest       => rms_rmap_0_rd_waitrequest_o,
			fee_1_wr_rmap_o.waitrequest       => rms_rmap_1_wr_waitrequest_o,
			fee_1_rd_rmap_o.readdata          => rms_rmap_1_readdata_o,
			fee_1_rd_rmap_o.waitrequest       => rms_rmap_1_rd_waitrequest_o,
			fee_2_wr_rmap_o.waitrequest       => rms_rmap_2_wr_waitrequest_o,
			fee_2_rd_rmap_o.readdata          => rms_rmap_2_readdata_o,
			fee_2_rd_rmap_o.waitrequest       => rms_rmap_2_rd_waitrequest_o,
			fee_3_wr_rmap_o.waitrequest       => rms_rmap_3_wr_waitrequest_o,
			fee_3_rd_rmap_o.readdata          => rms_rmap_3_readdata_o,
			fee_3_rd_rmap_o.waitrequest       => rms_rmap_3_rd_waitrequest_o,
			fee_4_wr_rmap_o.waitrequest       => rms_rmap_4_wr_waitrequest_o,
			fee_4_rd_rmap_o.readdata          => rms_rmap_4_readdata_o,
			fee_4_rd_rmap_o.waitrequest       => rms_rmap_4_rd_waitrequest_o,
			fee_5_wr_rmap_o.waitrequest       => rms_rmap_5_wr_waitrequest_o,
			fee_5_rd_rmap_o.readdata          => rms_rmap_5_readdata_o,
			fee_5_rd_rmap_o.waitrequest       => rms_rmap_5_rd_waitrequest_o,
			fee_6_wr_rmap_o.waitrequest       => rms_rmap_6_wr_waitrequest_o,
			fee_6_rd_rmap_o.readdata          => rms_rmap_6_readdata_o,
			fee_6_rd_rmap_o.waitrequest       => rms_rmap_6_rd_waitrequest_o,
			fee_7_wr_rmap_o.waitrequest       => rms_rmap_7_wr_waitrequest_o,
			fee_7_rd_rmap_o.readdata          => rms_rmap_7_readdata_o,
			fee_7_rd_rmap_o.waitrequest       => rms_rmap_7_rd_waitrequest_o,
			avalon_0_mm_wr_rmap_o.waitrequest => s_avs_0_rmap_wr_waitrequest,
			avalon_0_mm_rd_rmap_o.readdata    => avs_rmap_0_readdata_o,
			avalon_0_mm_rd_rmap_o.waitrequest => s_avs_0_rmap_rd_waitrequest,
			fee_wr_rmap_cfg_hk_o              => s_fee_wr_rmap_cfg_hk_in,
			fee_rd_rmap_cfg_hk_o              => s_fee_rd_rmap_cfg_hk_in,
			fee_wr_rmap_win_o                 => s_fee_wr_rmap_win_in,
			fee_rd_rmap_win_o                 => s_fee_rd_rmap_win_in,
			avalon_mm_wr_rmap_o               => s_avalon_mm_wr_rmap_in,
			avalon_mm_rd_rmap_o               => s_avalon_mm_rd_rmap_in
		);
	avs_rmap_0_waitrequest_o <= (s_avs_0_rmap_wr_waitrequest) and (s_avs_0_rmap_rd_waitrequest);

	fdrm_rmap_mem_area_ffee_deb_read_ent_inst : entity work.fdrm_rmap_mem_area_ffee_deb_read_ent
		port map(
			clk_i               => a_avs_clock,
			rst_i               => a_reset,
			fee_rmap_i          => s_fee_rd_rmap_cfg_hk_in,
			avalon_mm_rmap_i    => s_avalon_mm_rd_rmap_in,
			rmap_registers_wr_i => s_rmap_mem_wr_area,
			rmap_registers_rd_i => s_rmap_mem_rd_area,
			fee_rmap_o          => s_fee_rd_rmap_cfg_hk_out,
			avalon_mm_rmap_o    => s_avalon_mm_rd_rmap_out
		);

	fdrm_rmap_mem_area_ffee_deb_write_ent_inst : entity work.fdrm_rmap_mem_area_ffee_deb_write_ent
		port map(
			clk_i               => a_avs_clock,
			rst_i               => a_reset,
			fee_rmap_i          => s_fee_wr_rmap_cfg_hk_in,
			avalon_mm_rmap_i    => s_avalon_mm_wr_rmap_in,
			fee_rmap_o          => s_fee_wr_rmap_cfg_hk_out,
			avalon_mm_rmap_o    => s_avalon_mm_wr_rmap_out,
			rmap_registers_wr_o => s_rmap_mem_wr_area
		);

	fdrm_avm_rmap_ffee_deb_read_ent_inst : entity work.fdrm_avm_rmap_ffee_deb_read_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			fee_rmap_rd_i                     => s_fee_rd_rmap_win_in,
			avm_slave_rd_status_i.readdata    => avm_rmap_readdata_i,
			avm_slave_rd_status_i.waitrequest => avm_rmap_waitrequest_i,
			avm_rmap_mem_addr_offset_i        => channel_win_mem_addr_offset_i,
			fee_rmap_rd_o                     => s_fee_rd_rmap_win_out,
			avm_slave_rd_control_o.address    => s_avm_rmap_rd_address,
			avm_slave_rd_control_o.read       => avm_rmap_read_o
		);

	fdrm_avm_rmap_ffee_deb_write_ent_inst : entity work.fdrm_avm_rmap_ffee_deb_write_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			fee_rmap_wr_i                     => s_fee_wr_rmap_win_in,
			avm_slave_wr_status_i.waitrequest => avm_rmap_waitrequest_i,
			avm_rmap_mem_addr_offset_i        => channel_win_mem_addr_offset_i,
			fee_rmap_wr_o                     => s_fee_wr_rmap_win_out,
			avm_slave_wr_control_o.address    => s_avm_rmap_wr_address,
			avm_slave_wr_control_o.write      => avm_rmap_write_o,
			avm_slave_wr_control_o.writedata  => avm_rmap_writedata_o
		);

	avm_rmap_address_o <= (s_avm_rmap_rd_address) or (s_avm_rmap_wr_address);

	-- fdrm nfee rmap error clear manager
	p_fdrm_nfee_rmap_error_clear_manager : process(a_avs_clock, a_reset) is
	begin
		if (a_reset) = '1' then
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_8 <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_7 <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_6 <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_5 <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_4 <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_3 <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_2 <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_1 <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.rmap_4    <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.rmap_3    <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.rmap_2    <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.rmap_1    <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.crd_4     <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.fifo_4    <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.esc_4     <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.par_4     <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.disc_4    <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.crd_3     <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.fifo_3    <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.esc_3     <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.par_3     <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.disc_3    <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.crd_2     <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.fifo_2    <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.esc_2     <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.par_2     <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.disc_2    <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.crd_1     <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.fifo_1    <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.esc_1     <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.par_1     <= '0';
			s_rmap_mem_rd_area.deb_hk_spw_status.disc_1    <= '0';
		elsif rising_edge(a_avs_clock) then
			-- get error values to the rmap memory area
			-- check if a rising edge happened in any of the errors flags and register the error
			if (((channel_hk_3_err_left_buffer_overflow_i = '1') and (channel_hk_3_left_buffer_ccd_number_i = "11") and (channel_hk_3_left_buffer_ccd_side_i = '1')) or ((channel_hk_3_err_right_buffer_overflow_i = '1') and (channel_hk_3_right_buffer_ccd_number_i = "11") and (channel_hk_3_right_buffer_ccd_side_i = '1')) or ((channel_hk_2_err_left_buffer_overflow_i = '1') and (channel_hk_2_left_buffer_ccd_number_i = "11") and (channel_hk_2_left_buffer_ccd_side_i = '1')) or ((channel_hk_2_err_right_buffer_overflow_i = '1') and (channel_hk_2_right_buffer_ccd_number_i = "11") and (channel_hk_2_right_buffer_ccd_side_i = '1')) or ((channel_hk_1_err_left_buffer_overflow_i = '1') and (channel_hk_1_left_buffer_ccd_number_i = "11") and (channel_hk_1_left_buffer_ccd_side_i = '1')) or ((channel_hk_1_err_right_buffer_overflow_i = '1') and (channel_hk_1_right_buffer_ccd_number_i = "11") and (channel_hk_1_right_buffer_ccd_side_i = '1')) or ((channel_hk_0_err_left_buffer_overflow_i = '1') and (channel_hk_0_left_buffer_ccd_number_i = "11") and (channel_hk_0_left_buffer_ccd_side_i = '1')) or ((channel_hk_0_err_right_buffer_overflow_i = '1') and (channel_hk_0_right_buffer_ccd_number_i = "11") and (channel_hk_0_right_buffer_ccd_side_i = '1'))) then
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_8 <= '1';
			end if;
			if (((channel_hk_3_err_left_buffer_overflow_i = '1') and (channel_hk_3_left_buffer_ccd_number_i = "11") and (channel_hk_3_left_buffer_ccd_side_i = '0')) or ((channel_hk_3_err_right_buffer_overflow_i = '1') and (channel_hk_3_right_buffer_ccd_number_i = "11") and (channel_hk_3_right_buffer_ccd_side_i = '0')) or ((channel_hk_2_err_left_buffer_overflow_i = '1') and (channel_hk_2_left_buffer_ccd_number_i = "11") and (channel_hk_2_left_buffer_ccd_side_i = '0')) or ((channel_hk_2_err_right_buffer_overflow_i = '1') and (channel_hk_2_right_buffer_ccd_number_i = "11") and (channel_hk_2_right_buffer_ccd_side_i = '0')) or ((channel_hk_1_err_left_buffer_overflow_i = '1') and (channel_hk_1_left_buffer_ccd_number_i = "11") and (channel_hk_1_left_buffer_ccd_side_i = '0')) or ((channel_hk_1_err_right_buffer_overflow_i = '1') and (channel_hk_1_right_buffer_ccd_number_i = "11") and (channel_hk_1_right_buffer_ccd_side_i = '0')) or ((channel_hk_0_err_left_buffer_overflow_i = '1') and (channel_hk_0_left_buffer_ccd_number_i = "11") and (channel_hk_0_left_buffer_ccd_side_i = '0')) or ((channel_hk_0_err_right_buffer_overflow_i = '1') and (channel_hk_0_right_buffer_ccd_number_i = "11") and (channel_hk_0_right_buffer_ccd_side_i = '0'))) then
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_7 <= '1';
			end if;
			if (((channel_hk_3_err_left_buffer_overflow_i = '1') and (channel_hk_3_left_buffer_ccd_number_i = "10") and (channel_hk_3_left_buffer_ccd_side_i = '1')) or ((channel_hk_3_err_right_buffer_overflow_i = '1') and (channel_hk_3_right_buffer_ccd_number_i = "10") and (channel_hk_3_right_buffer_ccd_side_i = '1')) or ((channel_hk_2_err_left_buffer_overflow_i = '1') and (channel_hk_2_left_buffer_ccd_number_i = "10") and (channel_hk_2_left_buffer_ccd_side_i = '1')) or ((channel_hk_2_err_right_buffer_overflow_i = '1') and (channel_hk_2_right_buffer_ccd_number_i = "10") and (channel_hk_2_right_buffer_ccd_side_i = '1')) or ((channel_hk_1_err_left_buffer_overflow_i = '1') and (channel_hk_1_left_buffer_ccd_number_i = "10") and (channel_hk_1_left_buffer_ccd_side_i = '1')) or ((channel_hk_1_err_right_buffer_overflow_i = '1') and (channel_hk_1_right_buffer_ccd_number_i = "10") and (channel_hk_1_right_buffer_ccd_side_i = '1')) or ((channel_hk_0_err_left_buffer_overflow_i = '1') and (channel_hk_0_left_buffer_ccd_number_i = "10") and (channel_hk_0_left_buffer_ccd_side_i = '1')) or ((channel_hk_0_err_right_buffer_overflow_i = '1') and (channel_hk_0_right_buffer_ccd_number_i = "10") and (channel_hk_0_right_buffer_ccd_side_i = '1'))) then
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_6 <= '1';
			end if;
			if (((channel_hk_3_err_left_buffer_overflow_i = '1') and (channel_hk_3_left_buffer_ccd_number_i = "10") and (channel_hk_3_left_buffer_ccd_side_i = '0')) or ((channel_hk_3_err_right_buffer_overflow_i = '1') and (channel_hk_3_right_buffer_ccd_number_i = "10") and (channel_hk_3_right_buffer_ccd_side_i = '0')) or ((channel_hk_2_err_left_buffer_overflow_i = '1') and (channel_hk_2_left_buffer_ccd_number_i = "10") and (channel_hk_2_left_buffer_ccd_side_i = '0')) or ((channel_hk_2_err_right_buffer_overflow_i = '1') and (channel_hk_2_right_buffer_ccd_number_i = "10") and (channel_hk_2_right_buffer_ccd_side_i = '0')) or ((channel_hk_1_err_left_buffer_overflow_i = '1') and (channel_hk_1_left_buffer_ccd_number_i = "10") and (channel_hk_1_left_buffer_ccd_side_i = '0')) or ((channel_hk_1_err_right_buffer_overflow_i = '1') and (channel_hk_1_right_buffer_ccd_number_i = "10") and (channel_hk_1_right_buffer_ccd_side_i = '0')) or ((channel_hk_0_err_left_buffer_overflow_i = '1') and (channel_hk_0_left_buffer_ccd_number_i = "10") and (channel_hk_0_left_buffer_ccd_side_i = '0')) or ((channel_hk_0_err_right_buffer_overflow_i = '1') and (channel_hk_0_right_buffer_ccd_number_i = "10") and (channel_hk_0_right_buffer_ccd_side_i = '0'))) then
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_5 <= '1';
			end if;
			if (((channel_hk_3_err_left_buffer_overflow_i = '1') and (channel_hk_3_left_buffer_ccd_number_i = "01") and (channel_hk_3_left_buffer_ccd_side_i = '1')) or ((channel_hk_3_err_right_buffer_overflow_i = '1') and (channel_hk_3_right_buffer_ccd_number_i = "01") and (channel_hk_3_right_buffer_ccd_side_i = '1')) or ((channel_hk_2_err_left_buffer_overflow_i = '1') and (channel_hk_2_left_buffer_ccd_number_i = "01") and (channel_hk_2_left_buffer_ccd_side_i = '1')) or ((channel_hk_2_err_right_buffer_overflow_i = '1') and (channel_hk_2_right_buffer_ccd_number_i = "01") and (channel_hk_2_right_buffer_ccd_side_i = '1')) or ((channel_hk_1_err_left_buffer_overflow_i = '1') and (channel_hk_1_left_buffer_ccd_number_i = "01") and (channel_hk_1_left_buffer_ccd_side_i = '1')) or ((channel_hk_1_err_right_buffer_overflow_i = '1') and (channel_hk_1_right_buffer_ccd_number_i = "01") and (channel_hk_1_right_buffer_ccd_side_i = '1')) or ((channel_hk_0_err_left_buffer_overflow_i = '1') and (channel_hk_0_left_buffer_ccd_number_i = "01") and (channel_hk_0_left_buffer_ccd_side_i = '1')) or ((channel_hk_0_err_right_buffer_overflow_i = '1') and (channel_hk_0_right_buffer_ccd_number_i = "01") and (channel_hk_0_right_buffer_ccd_side_i = '1'))) then
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_4 <= '1';
			end if;
			if (((channel_hk_3_err_left_buffer_overflow_i = '1') and (channel_hk_3_left_buffer_ccd_number_i = "01") and (channel_hk_3_left_buffer_ccd_side_i = '0')) or ((channel_hk_3_err_right_buffer_overflow_i = '1') and (channel_hk_3_right_buffer_ccd_number_i = "01") and (channel_hk_3_right_buffer_ccd_side_i = '0')) or ((channel_hk_2_err_left_buffer_overflow_i = '1') and (channel_hk_2_left_buffer_ccd_number_i = "01") and (channel_hk_2_left_buffer_ccd_side_i = '0')) or ((channel_hk_2_err_right_buffer_overflow_i = '1') and (channel_hk_2_right_buffer_ccd_number_i = "01") and (channel_hk_2_right_buffer_ccd_side_i = '0')) or ((channel_hk_1_err_left_buffer_overflow_i = '1') and (channel_hk_1_left_buffer_ccd_number_i = "01") and (channel_hk_1_left_buffer_ccd_side_i = '0')) or ((channel_hk_1_err_right_buffer_overflow_i = '1') and (channel_hk_1_right_buffer_ccd_number_i = "01") and (channel_hk_1_right_buffer_ccd_side_i = '0')) or ((channel_hk_0_err_left_buffer_overflow_i = '1') and (channel_hk_0_left_buffer_ccd_number_i = "01") and (channel_hk_0_left_buffer_ccd_side_i = '0')) or ((channel_hk_0_err_right_buffer_overflow_i = '1') and (channel_hk_0_right_buffer_ccd_number_i = "01") and (channel_hk_0_right_buffer_ccd_side_i = '0'))) then
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_3 <= '1';
			end if;
			if (((channel_hk_3_err_left_buffer_overflow_i = '1') and (channel_hk_3_left_buffer_ccd_number_i = "00") and (channel_hk_3_left_buffer_ccd_side_i = '1')) or ((channel_hk_3_err_right_buffer_overflow_i = '1') and (channel_hk_3_right_buffer_ccd_number_i = "00") and (channel_hk_3_right_buffer_ccd_side_i = '1')) or ((channel_hk_2_err_left_buffer_overflow_i = '1') and (channel_hk_2_left_buffer_ccd_number_i = "00") and (channel_hk_2_left_buffer_ccd_side_i = '1')) or ((channel_hk_2_err_right_buffer_overflow_i = '1') and (channel_hk_2_right_buffer_ccd_number_i = "00") and (channel_hk_2_right_buffer_ccd_side_i = '1')) or ((channel_hk_1_err_left_buffer_overflow_i = '1') and (channel_hk_1_left_buffer_ccd_number_i = "00") and (channel_hk_1_left_buffer_ccd_side_i = '1')) or ((channel_hk_1_err_right_buffer_overflow_i = '1') and (channel_hk_1_right_buffer_ccd_number_i = "00") and (channel_hk_1_right_buffer_ccd_side_i = '1')) or ((channel_hk_0_err_left_buffer_overflow_i = '1') and (channel_hk_0_left_buffer_ccd_number_i = "00") and (channel_hk_0_left_buffer_ccd_side_i = '1')) or ((channel_hk_0_err_right_buffer_overflow_i = '1') and (channel_hk_0_right_buffer_ccd_number_i = "00") and (channel_hk_0_right_buffer_ccd_side_i = '1'))) then
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_2 <= '1';
			end if;
			if (((channel_hk_3_err_left_buffer_overflow_i = '1') and (channel_hk_3_left_buffer_ccd_number_i = "00") and (channel_hk_3_left_buffer_ccd_side_i = '0')) or ((channel_hk_3_err_right_buffer_overflow_i = '1') and (channel_hk_3_right_buffer_ccd_number_i = "00") and (channel_hk_3_right_buffer_ccd_side_i = '0')) or ((channel_hk_2_err_left_buffer_overflow_i = '1') and (channel_hk_2_left_buffer_ccd_number_i = "00") and (channel_hk_2_left_buffer_ccd_side_i = '0')) or ((channel_hk_2_err_right_buffer_overflow_i = '1') and (channel_hk_2_right_buffer_ccd_number_i = "00") and (channel_hk_2_right_buffer_ccd_side_i = '0')) or ((channel_hk_1_err_left_buffer_overflow_i = '1') and (channel_hk_1_left_buffer_ccd_number_i = "00") and (channel_hk_1_left_buffer_ccd_side_i = '0')) or ((channel_hk_1_err_right_buffer_overflow_i = '1') and (channel_hk_1_right_buffer_ccd_number_i = "00") and (channel_hk_1_right_buffer_ccd_side_i = '0')) or ((channel_hk_0_err_left_buffer_overflow_i = '1') and (channel_hk_0_left_buffer_ccd_number_i = "00") and (channel_hk_0_left_buffer_ccd_side_i = '0')) or ((channel_hk_0_err_right_buffer_overflow_i = '1') and (channel_hk_0_right_buffer_ccd_number_i = "00") and (channel_hk_0_right_buffer_ccd_side_i = '0'))) then
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_1 <= '1';
			end if;
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.rmap_4 <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.rmap_3 <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.rmap_2 <= '0';
			s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.rmap_1 <= '0';
			if (channel_hk_3_spw_link_credit_err_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.crd_4 <= '1';
			end if;
			s_rmap_mem_rd_area.deb_hk_spw_status.fifo_4 <= '0';
			if (channel_hk_3_spw_link_escape_err_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.esc_4 <= '1';
			end if;
			if (channel_hk_3_spw_link_parity_err_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.par_4 <= '1';
			end if;
			if (channel_hk_3_spw_link_disconnect_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.disc_4 <= '1';
			end if;
			if (channel_hk_2_spw_link_credit_err_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.crd_3 <= '1';
			end if;
			s_rmap_mem_rd_area.deb_hk_spw_status.fifo_3 <= '0';
			if (channel_hk_2_spw_link_escape_err_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.esc_3 <= '1';
			end if;
			if (channel_hk_2_spw_link_parity_err_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.par_3 <= '1';
			end if;
			if (channel_hk_2_spw_link_disconnect_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.disc_3 <= '1';
			end if;
			if (channel_hk_1_spw_link_credit_err_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.crd_2 <= '1';
			end if;
			s_rmap_mem_rd_area.deb_hk_spw_status.fifo_2 <= '0';
			if (channel_hk_1_spw_link_escape_err_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.esc_2 <= '1';
			end if;
			if (channel_hk_1_spw_link_parity_err_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.par_2 <= '1';
			end if;
			if (channel_hk_1_spw_link_disconnect_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.disc_2 <= '1';
			end if;
			if (channel_hk_0_spw_link_credit_err_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.crd_1 <= '1';
			end if;
			s_rmap_mem_rd_area.deb_hk_spw_status.fifo_1 <= '0';
			if (channel_hk_0_spw_link_escape_err_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.esc_1 <= '1';
			end if;
			if (channel_hk_0_spw_link_parity_err_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.par_1 <= '1';
			end if;
			if (channel_hk_0_spw_link_disconnect_i = '1') then
				s_rmap_mem_rd_area.deb_hk_spw_status.disc_1 <= '1';
			end if;

			-- check if a error clear was requested
			if (s_rmap_mem_wr_area.deb_gen_cfg_dtc_rst_cps.rst_spw = '1') then
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_8 <= '0';
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_7 <= '0';
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_6 <= '0';
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_5 <= '0';
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_4 <= '0';
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_3 <= '0';
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_2 <= '0';
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.outbuff_1 <= '0';
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.rmap_4    <= '0';
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.rmap_3    <= '0';
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.rmap_2    <= '0';
				s_rmap_mem_rd_area.deb_hk_deb_ovf_rd.rmap_1    <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.crd_4     <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.fifo_4    <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.esc_4     <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.par_4     <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.disc_4    <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.crd_3     <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.fifo_3    <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.esc_3     <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.par_3     <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.disc_3    <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.crd_2     <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.fifo_2    <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.esc_2     <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.par_2     <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.disc_2    <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.crd_1     <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.fifo_1    <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.esc_1     <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.par_1     <= '0';
				s_rmap_mem_rd_area.deb_hk_spw_status.disc_1    <= '0';
			end if;
		end if;
	end process p_fdrm_nfee_rmap_error_clear_manager;

	-- Signals Assignments --

	-- deb housekeeping "spw_status" signals assignments
	s_rmap_mem_rd_area.deb_hk_spw_status.state_4 <= ("000") when (a_reset = '1')
	                                                else ("011") when (channel_hk_3_spw_link_started_i = '1')
	                                                else ("100") when (channel_hk_3_spw_link_connecting_i = '1')
	                                                else ("101") when (channel_hk_3_spw_link_running_i = '1')
	                                                else ("010");
	s_rmap_mem_rd_area.deb_hk_spw_status.state_3 <= ("000") when (a_reset = '1')
	                                                else ("011") when (channel_hk_2_spw_link_started_i = '1')
	                                                else ("100") when (channel_hk_2_spw_link_connecting_i = '1')
	                                                else ("101") when (channel_hk_2_spw_link_running_i = '1')
	                                                else ("010");
	s_rmap_mem_rd_area.deb_hk_spw_status.state_2 <= ("000") when (a_reset = '1')
	                                                else ("011") when (channel_hk_1_spw_link_started_i = '1')
	                                                else ("100") when (channel_hk_1_spw_link_connecting_i = '1')
	                                                else ("101") when (channel_hk_1_spw_link_running_i = '1')
	                                                else ("010");
	s_rmap_mem_rd_area.deb_hk_spw_status.state_1 <= ("000") when (a_reset = '1')
	                                                else ("011") when (channel_hk_0_spw_link_started_i = '1')
	                                                else ("100") when (channel_hk_0_spw_link_connecting_i = '1')
	                                                else ("101") when (channel_hk_0_spw_link_running_i = '1')
	                                                else ("010");

end architecture rtl;                   -- of fdrm_rmap_memory_ffee_deb_area_top
