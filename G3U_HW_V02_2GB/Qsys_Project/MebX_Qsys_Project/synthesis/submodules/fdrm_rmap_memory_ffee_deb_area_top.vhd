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
		reset_i                       : in  std_logic                     := '0'; --          --                      reset_sink.reset
		clk_100_i                     : in  std_logic                     := '0'; --          --               clock_sink_100mhz.clk
		avs_rmap_0_address_i          : in  std_logic_vector(11 downto 0) := (others => '0'); --             avalon_rmap_slave_0.address
		avs_rmap_0_write_i            : in  std_logic                     := '0'; --          --                                .write
		avs_rmap_0_read_i             : in  std_logic                     := '0'; --          --                                .read
		avs_rmap_0_readdata_o         : out std_logic_vector(31 downto 0); --                 --                                .readdata
		avs_rmap_0_writedata_i        : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .writedata
		avs_rmap_0_waitrequest_o      : out std_logic; --                                     --                                .waitrequest
		avs_rmap_0_byteenable_i       : in  std_logic_vector(3 downto 0)  := (others => '0'); --                                .byteenable
		rms_rmap_0_wr_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_0.wr_address_signal
		rms_rmap_0_write_i            : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_0_writedata_i        : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_0_rd_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_0_read_i             : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_0_wr_waitrequest_o   : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_0_readdata_o         : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_0_rd_waitrequest_o   : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_1_wr_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_1.wr_address_signal
		rms_rmap_1_write_i            : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_1_writedata_i        : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_1_rd_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_1_read_i             : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_1_wr_waitrequest_o   : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_1_readdata_o         : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_1_rd_waitrequest_o   : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_2_wr_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_2.wr_address_signal
		rms_rmap_2_write_i            : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_2_writedata_i        : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_2_rd_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_2_read_i             : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_2_wr_waitrequest_o   : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_2_readdata_o         : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_2_rd_waitrequest_o   : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_3_wr_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_3.wr_address_signal
		rms_rmap_3_write_i            : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_3_writedata_i        : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_3_rd_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_3_read_i             : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_3_wr_waitrequest_o   : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_3_readdata_o         : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_3_rd_waitrequest_o   : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_4_wr_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_4.wr_address_signal
		rms_rmap_4_write_i            : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_4_writedata_i        : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_4_rd_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_4_read_i             : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_4_wr_waitrequest_o   : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_4_readdata_o         : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_4_rd_waitrequest_o   : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_5_wr_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_5.wr_address_signal
		rms_rmap_5_write_i            : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_5_writedata_i        : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_5_rd_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_5_read_i             : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_5_wr_waitrequest_o   : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_5_readdata_o         : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_5_rd_waitrequest_o   : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_6_wr_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_6.wr_address_signal
		rms_rmap_6_write_i            : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_6_writedata_i        : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_6_rd_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_6_read_i             : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_6_wr_waitrequest_o   : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_6_readdata_o         : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_6_rd_waitrequest_o   : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_7_wr_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_7.wr_address_signal
		rms_rmap_7_write_i            : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_7_writedata_i        : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_7_rd_address_i       : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_7_read_i             : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_7_wr_waitrequest_o   : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_7_readdata_o         : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_7_rd_waitrequest_o   : out std_logic; --                                     --                                .rd_waitrequest_signal
		avm_rmap_readdata_i           : in  std_logic_vector(7 downto 0)  := (others => '0'); --           avalon_mm_rmap_master.readdata
		avm_rmap_waitrequest_i        : in  std_logic                     := '0'; --          --                                .waitrequest
		avm_rmap_address_o            : out std_logic_vector(63 downto 0); --                 --                                .address
		avm_rmap_read_o               : out std_logic; --                                     --                                .read
		avm_rmap_write_o              : out std_logic; --                                     --                                .write
		avm_rmap_writedata_o          : out std_logic_vector(7 downto 0); --                  --                                .writedata
		channel_win_mem_addr_offset_i : in  std_logic_vector(63 downto 0) := (others => '0') --- conduit_end_rmap_avm_configs_in.win_mem_addr_offset_signal
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
			avalon_0_mm_wr_rmap_i.byteenable  => avs_rmap_0_byteenable_i,
			avalon_0_mm_rd_rmap_i.address     => avs_rmap_0_address_i,
			avalon_0_mm_rd_rmap_i.read        => avs_rmap_0_read_i,
			avalon_0_mm_rd_rmap_i.byteenable  => avs_rmap_0_byteenable_i,
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

end architecture rtl;                   -- of fdrm_rmap_memory_ffee_deb_area_top
