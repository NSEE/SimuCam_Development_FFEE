-- farm_rmap_memory_ffee_aeb_area_top.vhd

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

use work.farm_avalon_mm_rmap_ffee_aeb_pkg.all;
use work.farm_rmap_mem_area_ffee_aeb_pkg.all;

entity farm_rmap_memory_ffee_aeb_area_top is
	port(
		reset_i                     : in  std_logic                     := '0'; --          --                      reset_sink.reset
		clk_100_i                   : in  std_logic                     := '0'; --          --               clock_sink_100mhz.clk
		avs_rmap_0_address_i        : in  std_logic_vector(11 downto 0) := (others => '0'); --             avalon_rmap_slave_0.address
		avs_rmap_0_write_i          : in  std_logic                     := '0'; --          --                                .write
		avs_rmap_0_read_i           : in  std_logic                     := '0'; --          --                                .read
		avs_rmap_0_readdata_o       : out std_logic_vector(31 downto 0); --                 --                                .readdata
		avs_rmap_0_writedata_i      : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .writedata
		avs_rmap_0_waitrequest_o    : out std_logic; --                                     --                                .waitrequest
		avs_rmap_0_byteenable_i     : in  std_logic_vector(3 downto 0)  := (others => '0'); --                                .byteenable
		rms_rmap_0_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_0.wr_address_signal
		rms_rmap_0_write_i          : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_0_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_0_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_0_read_i           : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_0_wr_waitrequest_o : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_0_readdata_o       : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_0_rd_waitrequest_o : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_1_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_1.wr_address_signal
		rms_rmap_1_write_i          : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_1_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_1_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_1_read_i           : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_1_wr_waitrequest_o : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_1_readdata_o       : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_1_rd_waitrequest_o : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_2_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_2.wr_address_signal
		rms_rmap_2_write_i          : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_2_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_2_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_2_read_i           : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_2_wr_waitrequest_o : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_2_readdata_o       : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_2_rd_waitrequest_o : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_3_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_3.wr_address_signal
		rms_rmap_3_write_i          : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_3_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_3_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_3_read_i           : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_3_wr_waitrequest_o : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_3_readdata_o       : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_3_rd_waitrequest_o : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_4_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_4.wr_address_signal
		rms_rmap_4_write_i          : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_4_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_4_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_4_read_i           : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_4_wr_waitrequest_o : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_4_readdata_o       : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_4_rd_waitrequest_o : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_5_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_5.wr_address_signal
		rms_rmap_5_write_i          : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_5_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_5_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_5_read_i           : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_5_wr_waitrequest_o : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_5_readdata_o       : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_5_rd_waitrequest_o : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_6_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_6.wr_address_signal
		rms_rmap_6_write_i          : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_6_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_6_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_6_read_i           : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_6_wr_waitrequest_o : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_6_readdata_o       : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_6_rd_waitrequest_o : out std_logic; --                                     --                                .rd_waitrequest_signal
		rms_rmap_7_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --    conduit_end_rmap_mem_slave_7.wr_address_signal
		rms_rmap_7_write_i          : in  std_logic                     := '0'; --          --                                .write_signal
		rms_rmap_7_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                .writedata_signal
		rms_rmap_7_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                                .rd_address_signal
		rms_rmap_7_read_i           : in  std_logic                     := '0'; --          --                                .read_signal
		rms_rmap_7_wr_waitrequest_o : out std_logic; --                                     --                                .wr_waitrequest_signal
		rms_rmap_7_readdata_o       : out std_logic_vector(7 downto 0); --                  --                                .readdata_signal
		rms_rmap_7_rd_waitrequest_o : out std_logic ---                                     --                                .rd_waitrequest_signal
	);
end entity farm_rmap_memory_ffee_aeb_area_top;

architecture rtl of farm_rmap_memory_ffee_aeb_area_top is

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
	signal s_fee_wr_rmap_cfg_hk_in     : t_farm_ffee_aeb_rmap_write_in;
	signal s_fee_wr_rmap_cfg_hk_out    : t_farm_ffee_aeb_rmap_write_out;
	signal s_fee_rd_rmap_cfg_hk_in     : t_farm_ffee_aeb_rmap_read_in;
	signal s_fee_rd_rmap_cfg_hk_out    : t_farm_ffee_aeb_rmap_read_out;
	-- avs rmap signals
	signal s_avalon_mm_wr_rmap_in      : t_farm_avalon_mm_rmap_ffee_aeb_write_in;
	signal s_avalon_mm_wr_rmap_out     : t_farm_avalon_mm_rmap_ffee_aeb_write_out;
	signal s_avalon_mm_rd_rmap_in      : t_farm_avalon_mm_rmap_ffee_aeb_read_in;
	signal s_avalon_mm_rd_rmap_out     : t_farm_avalon_mm_rmap_ffee_aeb_read_out;

begin

	farm_rmap_mem_area_ffee_aeb_arbiter_ent_inst : entity work.farm_rmap_mem_area_ffee_aeb_arbiter_ent
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
			avalon_mm_wr_rmap_o               => s_avalon_mm_wr_rmap_in,
			avalon_mm_rd_rmap_o               => s_avalon_mm_rd_rmap_in
		);
	avs_rmap_0_waitrequest_o <= (s_avs_0_rmap_wr_waitrequest) and (s_avs_0_rmap_rd_waitrequest);

	farm_rmap_mem_area_ffee_aeb_read_ent_inst : entity work.farm_rmap_mem_area_ffee_aeb_read_ent
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

	farm_rmap_mem_area_ffee_aeb_write_ent_inst : entity work.farm_rmap_mem_area_ffee_aeb_write_ent
		port map(
			clk_i               => a_avs_clock,
			rst_i               => a_reset,
			fee_rmap_i          => s_fee_wr_rmap_cfg_hk_in,
			avalon_mm_rmap_i    => s_avalon_mm_wr_rmap_in,
			fee_rmap_o          => s_fee_wr_rmap_cfg_hk_out,
			avalon_mm_rmap_o    => s_avalon_mm_wr_rmap_out,
			rmap_registers_wr_o => s_rmap_mem_wr_area
		);

	-- Signals Assignments --
	
	-- aeb housekeeping "adc1_rd_config_1" signals assignments
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.spirst <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.spirst;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.muxmod <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.muxmod;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.bypas  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.bypas;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.clkenb <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.clkenb;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.chop   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.chop;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.stat   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.stat;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.idlmod <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.idlmod;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.dly2   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.dly(2);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.dly1   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.dly(1);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.dly0   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.dly(0);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.sbcs1  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.sbcs(1);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.sbcs0  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.sbcs(0);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.drate1 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.drate(1);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.drate0 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.drate(0);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.ainp3  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.ainp(3);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.ainp2  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.ainp(2);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.ainp1  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.ainp(1);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.ainp0  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.ainp(0);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.ainn3  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.ainn(3);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.ainn2  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.ainn(2);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.ainn1  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.ainn(1);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.ainn0  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.ainn(0);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.diff7  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.diff(7);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.diff6  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.diff(6);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.diff5  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.diff(5);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.diff4  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.diff(4);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.diff3  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.diff(3);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.diff2  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.diff(2);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.diff1  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.diff(1);
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.diff0  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.diff(0);

	-- aeb housekeeping "adc1_rd_config_2" signals assignments
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain7   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain7;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain6   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain6;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain5   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain5;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain4   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain4;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain3   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain3;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain2   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain2;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain1   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain1;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain0   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain0;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain15  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain15;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain14  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain14;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain13  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain13;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain12  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain12;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain11  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain11;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain10  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain10;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain9   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain9;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ain8   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ain8;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.ref    <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.ref;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.gain   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.gain;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.temp   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.temp;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.vcc    <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.vcc;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.offset <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.offset;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.cio7   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.cio7;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.cio6   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.cio6;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.cio5   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.cio5;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.cio4   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.cio4;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.cio3   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.cio3;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.cio2   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.cio2;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.cio1   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.cio1;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.cio0   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.cio0;

	-- aeb housekeeping "adc1_rd_config_3" signals assignments
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_3.dio7 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_3.dio7;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_3.dio6 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_3.dio6;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_3.dio5 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_3.dio5;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_3.dio4 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_3.dio4;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_3.dio3 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_3.dio3;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_3.dio2 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_3.dio2;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_3.dio1 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_3.dio1;
	s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_3.dio0 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_3.dio0;

	-- aeb housekeeping "adc2_rd_config_1" signals assignments
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.spirst <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.spirst;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.muxmod <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.muxmod;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.bypas  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.bypas;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.clkenb <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.clkenb;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.chop   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.chop;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.stat   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.stat;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.idlmod <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.idlmod;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.dly2   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.dly(2);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.dly1   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.dly(1);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.dly0   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.dly(0);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.sbcs1  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.sbcs(1);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.sbcs0  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.sbcs(0);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.drate1 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.drate(1);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.drate0 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.drate(0);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.ainp3  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.ainp(3);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.ainp2  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.ainp(2);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.ainp1  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.ainp(1);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.ainp0  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.ainp(0);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.ainn3  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.ainn(3);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.ainn2  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.ainn(2);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.ainn1  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.ainn(1);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.ainn0  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.ainn(0);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.diff7  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.diff(7);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.diff6  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.diff(6);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.diff5  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.diff(5);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.diff4  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.diff(4);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.diff3  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.diff(3);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.diff2  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.diff(2);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.diff1  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.diff(1);
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.diff0  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.diff(0);

	-- aeb housekeeping "adc2_rd_config_2" signals assignments
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain7   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain7;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain6   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain6;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain5   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain5;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain4   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain4;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain3   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain3;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain2   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain2;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain1   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain1;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain0   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain0;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain15  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain15;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain14  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain14;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain13  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain13;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain12  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain12;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain11  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain11;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain10  <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain10;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain9   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain9;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ain8   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ain8;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.ref    <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.ref;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.gain   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.gain;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.temp   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.temp;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.vcc    <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.vcc;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.offset <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.offset;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.cio7   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.cio7;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.cio6   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.cio6;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.cio5   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.cio5;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.cio4   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.cio4;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.cio3   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.cio3;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.cio2   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.cio2;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.cio1   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.cio1;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.cio0   <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.cio0;

	-- aeb housekeeping "adc2_rd_config_3" signals assignments
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_3.dio7 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_3.dio7;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_3.dio6 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_3.dio6;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_3.dio5 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_3.dio5;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_3.dio4 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_3.dio4;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_3.dio3 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_3.dio3;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_3.dio2 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_3.dio2;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_3.dio1 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_3.dio1;
	s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_3.dio0 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_3.dio0;

end architecture rtl;                   -- of farm_rmap_memory_ffee_aeb_area_top
