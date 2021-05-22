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
        --		avs_rmap_0_byteenable_i     : in  std_logic_vector(3 downto 0)  := (others => '0'); --                                .byteenable
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
    -- ram memory direct access
    signal s_ram_mem_direct_access     : t_ram_mem_direct_access;
    -- mem area signals
    signal s_memarea_wraddress         : std_logic_vector(6 downto 0);
    signal s_memarea_wrbyteenable      : std_logic_vector(3 downto 0);
    signal s_memarea_wrbitmask         : std_logic_vector(31 downto 0);
    signal s_memarea_wrdata            : std_logic_vector(31 downto 0);
    signal s_memarea_write             : std_logic;
    signal s_memarea_rdaddress         : std_logic_vector(6 downto 0);
    signal s_memarea_read              : std_logic;
    signal s_memarea_idle              : std_logic;
    signal s_memarea_wrdone            : std_logic;
    signal s_memarea_rdvalid           : std_logic;
    signal s_memarea_rddata            : std_logic_vector(31 downto 0);

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
            --			avalon_0_mm_wr_rmap_i.byteenable  => avs_rmap_0_byteenable_i,
            avalon_0_mm_wr_rmap_i.byteenable  => (others => '1'),
            avalon_0_mm_rd_rmap_i.address     => avs_rmap_0_address_i,
            avalon_0_mm_rd_rmap_i.read        => avs_rmap_0_read_i,
            --			avalon_0_mm_rd_rmap_i.byteenable  => avs_rmap_0_byteenable_i,
            avalon_0_mm_rd_rmap_i.byteenable  => (others => '1'),
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
            clk_i                   => a_avs_clock,
            rst_i                   => a_reset,
            fee_rmap_i              => s_fee_rd_rmap_cfg_hk_in,
            avalon_mm_rmap_i        => s_avalon_mm_rd_rmap_in,
            ram_mem_direct_access_i => s_ram_mem_direct_access,
            memarea_idle_i          => s_memarea_idle,
            memarea_rdvalid_i       => s_memarea_rdvalid,
            memarea_rddata_i        => s_memarea_rddata,
            rmap_registers_wr_i     => s_rmap_mem_wr_area,
            rmap_registers_rd_i     => s_rmap_mem_rd_area,
            fee_rmap_o              => s_fee_rd_rmap_cfg_hk_out,
            avalon_mm_rmap_o        => s_avalon_mm_rd_rmap_out,
            memarea_rdaddress_o     => s_memarea_rdaddress,
            memarea_read_o          => s_memarea_read
        );

    farm_rmap_mem_area_ffee_aeb_write_ent_inst : entity work.farm_rmap_mem_area_ffee_aeb_write_ent
        port map(
            clk_i                   => a_avs_clock,
            rst_i                   => a_reset,
            fee_rmap_i              => s_fee_wr_rmap_cfg_hk_in,
            avalon_mm_rmap_i        => s_avalon_mm_wr_rmap_in,
            memarea_idle_i          => s_memarea_idle,
            memarea_wrdone_i        => s_memarea_wrdone,
            fee_rmap_o              => s_fee_wr_rmap_cfg_hk_out,
            avalon_mm_rmap_o        => s_avalon_mm_wr_rmap_out,
            rmap_registers_wr_o     => s_rmap_mem_wr_area,
            ram_mem_direct_access_o => s_ram_mem_direct_access,
            memarea_wraddress_o     => s_memarea_wraddress,
            memarea_wrbyteenable_o  => s_memarea_wrbyteenable,
            memarea_wrbitmask_o     => s_memarea_wrbitmask,
            memarea_wrdata_o        => s_memarea_wrdata,
            memarea_write_o         => s_memarea_write
        );

    farm_mem_area_altsyncram_controller_inst : entity work.farm_mem_area_altsyncram_controller
        port map(
            clk_i                  => a_avs_clock,
            rst_i                  => a_reset,
            memarea_wraddress_i    => s_memarea_wraddress,
            memarea_wrbyteenable_i => s_memarea_wrbyteenable,
            memarea_wrbitmask_i    => s_memarea_wrbitmask,
            memarea_wrdata_i       => s_memarea_wrdata,
            memarea_write_i        => s_memarea_write,
            memarea_rdaddress_i    => s_memarea_rdaddress,
            memarea_read_i         => s_memarea_read,
            memarea_idle_o         => s_memarea_idle,
            memarea_wrdone_o       => s_memarea_wrdone,
            memarea_rdvalid_o      => s_memarea_rdvalid,
            memarea_rddata_o       => s_memarea_rddata
        );

    -- Signals Assignments --

    -- aeb housekeeping "adc1_rd_config_1" signals assignments
    s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.others_0 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.others_0(30 downto 25);
    s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_1.others_1 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_1.others_0(23 downto 0);

    -- aeb housekeeping "adc1_rd_config_2" signals assignments
    s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.others_0 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.others_0(31 downto 16);
    s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.others_1 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.others_0(13 downto 10);
    s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_2.others_2 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_2.others_0(8 downto 0);

    -- aeb housekeeping "adc1_rd_config_3" signals assignments
    s_rmap_mem_rd_area.aeb_hk_adc1_rd_config_3.others_0 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_3.others_0(31 downto 24);

    -- aeb housekeeping "adc2_rd_config_1" signals assignments
    s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.others_0 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.others_0(30 downto 25);
    s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_1.others_1 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_1.others_0(23 downto 0);

    -- aeb housekeeping "adc2_rd_config_2" signals assignments
    s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.others_0 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.others_0(31 downto 16);
    s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.others_1 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.others_0(13 downto 10);
    s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_2.others_2 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc2_config_2.others_0(8 downto 0);

    -- aeb housekeeping "adc2_rd_config_3" signals assignments
    s_rmap_mem_rd_area.aeb_hk_adc2_rd_config_3.others_0 <= s_rmap_mem_wr_area.aeb_gen_cfg_adc1_config_3.others_0(31 downto 24);

end architecture rtl;                   -- of farm_rmap_memory_ffee_aeb_area_top
