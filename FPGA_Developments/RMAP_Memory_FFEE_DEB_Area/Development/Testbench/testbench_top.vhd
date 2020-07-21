library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fdrm_avalon_mm_rmap_ffee_deb_pkg.all;
use work.fdrm_tb_avs_pkg.all;

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

	-- fee 1 rmap stimuli signals
	signal s_fee_1_rmap_stimuli_wr_address     : std_logic_vector(31 downto 0);
	signal s_fee_1_rmap_stimuli_write          : std_logic;
	signal s_fee_1_rmap_stimuli_writedata      : std_logic_vector(7 downto 0);
	signal s_fee_1_rmap_stimuli_rd_address     : std_logic_vector(31 downto 0);
	signal s_fee_1_rmap_stimuli_read           : std_logic;
	signal s_fee_1_rmap_stimuli_wr_waitrequest : std_logic;
	signal s_fee_1_rmap_stimuli_readdata       : std_logic_vector(7 downto 0);
	signal s_fee_1_rmap_stimuli_rd_waitrequest : std_logic;

	-- fee 2 rmap stimuli signals
	signal s_fee_2_rmap_stimuli_wr_address     : std_logic_vector(31 downto 0);
	signal s_fee_2_rmap_stimuli_write          : std_logic;
	signal s_fee_2_rmap_stimuli_writedata      : std_logic_vector(7 downto 0);
	signal s_fee_2_rmap_stimuli_rd_address     : std_logic_vector(31 downto 0);
	signal s_fee_2_rmap_stimuli_read           : std_logic;
	signal s_fee_2_rmap_stimuli_wr_waitrequest : std_logic;
	signal s_fee_2_rmap_stimuli_readdata       : std_logic_vector(7 downto 0);
	signal s_fee_2_rmap_stimuli_rd_waitrequest : std_logic;

	-- fee 3 rmap stimuli signals
	signal s_fee_3_rmap_stimuli_wr_address     : std_logic_vector(31 downto 0);
	signal s_fee_3_rmap_stimuli_write          : std_logic;
	signal s_fee_3_rmap_stimuli_writedata      : std_logic_vector(7 downto 0);
	signal s_fee_3_rmap_stimuli_rd_address     : std_logic_vector(31 downto 0);
	signal s_fee_3_rmap_stimuli_read           : std_logic;
	signal s_fee_3_rmap_stimuli_wr_waitrequest : std_logic;
	signal s_fee_3_rmap_stimuli_readdata       : std_logic_vector(7 downto 0);
	signal s_fee_3_rmap_stimuli_rd_waitrequest : std_logic;

	-- fee 4 rmap stimuli signals
	signal s_fee_4_rmap_stimuli_wr_address     : std_logic_vector(31 downto 0);
	signal s_fee_4_rmap_stimuli_write          : std_logic;
	signal s_fee_4_rmap_stimuli_writedata      : std_logic_vector(7 downto 0);
	signal s_fee_4_rmap_stimuli_rd_address     : std_logic_vector(31 downto 0);
	signal s_fee_4_rmap_stimuli_read           : std_logic;
	signal s_fee_4_rmap_stimuli_wr_waitrequest : std_logic;
	signal s_fee_4_rmap_stimuli_readdata       : std_logic_vector(7 downto 0);
	signal s_fee_4_rmap_stimuli_rd_waitrequest : std_logic;

	-- fee 5 rmap stimuli signals
	signal s_fee_5_rmap_stimuli_wr_address     : std_logic_vector(31 downto 0);
	signal s_fee_5_rmap_stimuli_write          : std_logic;
	signal s_fee_5_rmap_stimuli_writedata      : std_logic_vector(7 downto 0);
	signal s_fee_5_rmap_stimuli_rd_address     : std_logic_vector(31 downto 0);
	signal s_fee_5_rmap_stimuli_read           : std_logic;
	signal s_fee_5_rmap_stimuli_wr_waitrequest : std_logic;
	signal s_fee_5_rmap_stimuli_readdata       : std_logic_vector(7 downto 0);
	signal s_fee_5_rmap_stimuli_rd_waitrequest : std_logic;

	-- fee 6 rmap stimuli signals
	signal s_fee_6_rmap_stimuli_wr_address     : std_logic_vector(31 downto 0);
	signal s_fee_6_rmap_stimuli_write          : std_logic;
	signal s_fee_6_rmap_stimuli_writedata      : std_logic_vector(7 downto 0);
	signal s_fee_6_rmap_stimuli_rd_address     : std_logic_vector(31 downto 0);
	signal s_fee_6_rmap_stimuli_read           : std_logic;
	signal s_fee_6_rmap_stimuli_wr_waitrequest : std_logic;
	signal s_fee_6_rmap_stimuli_readdata       : std_logic_vector(7 downto 0);
	signal s_fee_6_rmap_stimuli_rd_waitrequest : std_logic;

	-- fee 7 rmap stimuli signals
	signal s_fee_7_rmap_stimuli_wr_address     : std_logic_vector(31 downto 0);
	signal s_fee_7_rmap_stimuli_write          : std_logic;
	signal s_fee_7_rmap_stimuli_writedata      : std_logic_vector(7 downto 0);
	signal s_fee_7_rmap_stimuli_rd_address     : std_logic_vector(31 downto 0);
	signal s_fee_7_rmap_stimuli_read           : std_logic;
	signal s_fee_7_rmap_stimuli_wr_waitrequest : std_logic;
	signal s_fee_7_rmap_stimuli_readdata       : std_logic_vector(7 downto 0);
	signal s_fee_7_rmap_stimuli_rd_waitrequest : std_logic;

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

	fee_1_rmap_stimuli_inst : entity work.fee_1_rmap_stimuli
		generic map(
			g_ADDRESS_WIDTH => 32,
			g_DATA_WIDTH    => 8
		)
		port map(
			clk_i                       => clk100,
			rst_i                       => rst,
			fee_1_rmap_wr_waitrequest_i => s_fee_1_rmap_stimuli_wr_waitrequest,
			fee_1_rmap_readdata_i       => s_fee_1_rmap_stimuli_readdata,
			fee_1_rmap_rd_waitrequest_i => s_fee_1_rmap_stimuli_rd_waitrequest,
			fee_1_rmap_wr_address_o     => s_fee_1_rmap_stimuli_wr_address,
			fee_1_rmap_write_o          => s_fee_1_rmap_stimuli_write,
			fee_1_rmap_writedata_o      => s_fee_1_rmap_stimuli_writedata,
			fee_1_rmap_rd_address_o     => s_fee_1_rmap_stimuli_rd_address,
			fee_1_rmap_read_o           => s_fee_1_rmap_stimuli_read
		);

	fee_2_rmap_stimuli_inst : entity work.fee_2_rmap_stimuli
		generic map(
			g_ADDRESS_WIDTH => 32,
			g_DATA_WIDTH    => 8
		)
		port map(
			clk_i                       => clk100,
			rst_i                       => rst,
			fee_2_rmap_wr_waitrequest_i => s_fee_2_rmap_stimuli_wr_waitrequest,
			fee_2_rmap_readdata_i       => s_fee_2_rmap_stimuli_readdata,
			fee_2_rmap_rd_waitrequest_i => s_fee_2_rmap_stimuli_rd_waitrequest,
			fee_2_rmap_wr_address_o     => s_fee_2_rmap_stimuli_wr_address,
			fee_2_rmap_write_o          => s_fee_2_rmap_stimuli_write,
			fee_2_rmap_writedata_o      => s_fee_2_rmap_stimuli_writedata,
			fee_2_rmap_rd_address_o     => s_fee_2_rmap_stimuli_rd_address,
			fee_2_rmap_read_o           => s_fee_2_rmap_stimuli_read
		);

	fee_3_rmap_stimuli_inst : entity work.fee_3_rmap_stimuli
		generic map(
			g_ADDRESS_WIDTH => 32,
			g_DATA_WIDTH    => 8
		)
		port map(
			clk_i                       => clk100,
			rst_i                       => rst,
			fee_3_rmap_wr_waitrequest_i => s_fee_3_rmap_stimuli_wr_waitrequest,
			fee_3_rmap_readdata_i       => s_fee_3_rmap_stimuli_readdata,
			fee_3_rmap_rd_waitrequest_i => s_fee_3_rmap_stimuli_rd_waitrequest,
			fee_3_rmap_wr_address_o     => s_fee_3_rmap_stimuli_wr_address,
			fee_3_rmap_write_o          => s_fee_3_rmap_stimuli_write,
			fee_3_rmap_writedata_o      => s_fee_3_rmap_stimuli_writedata,
			fee_3_rmap_rd_address_o     => s_fee_3_rmap_stimuli_rd_address,
			fee_3_rmap_read_o           => s_fee_3_rmap_stimuli_read
		);

	fee_4_rmap_stimuli_inst : entity work.fee_4_rmap_stimuli
		generic map(
			g_ADDRESS_WIDTH => 32,
			g_DATA_WIDTH    => 8
		)
		port map(
			clk_i                       => clk100,
			rst_i                       => rst,
			fee_4_rmap_wr_waitrequest_i => s_fee_4_rmap_stimuli_wr_waitrequest,
			fee_4_rmap_readdata_i       => s_fee_4_rmap_stimuli_readdata,
			fee_4_rmap_rd_waitrequest_i => s_fee_4_rmap_stimuli_rd_waitrequest,
			fee_4_rmap_wr_address_o     => s_fee_4_rmap_stimuli_wr_address,
			fee_4_rmap_write_o          => s_fee_4_rmap_stimuli_write,
			fee_4_rmap_writedata_o      => s_fee_4_rmap_stimuli_writedata,
			fee_4_rmap_rd_address_o     => s_fee_4_rmap_stimuli_rd_address,
			fee_4_rmap_read_o           => s_fee_4_rmap_stimuli_read
		);

	fee_5_rmap_stimuli_inst : entity work.fee_5_rmap_stimuli
		generic map(
			g_ADDRESS_WIDTH => 32,
			g_DATA_WIDTH    => 8
		)
		port map(
			clk_i                       => clk100,
			rst_i                       => rst,
			fee_5_rmap_wr_waitrequest_i => s_fee_5_rmap_stimuli_wr_waitrequest,
			fee_5_rmap_readdata_i       => s_fee_5_rmap_stimuli_readdata,
			fee_5_rmap_rd_waitrequest_i => s_fee_5_rmap_stimuli_rd_waitrequest,
			fee_5_rmap_wr_address_o     => s_fee_5_rmap_stimuli_wr_address,
			fee_5_rmap_write_o          => s_fee_5_rmap_stimuli_write,
			fee_5_rmap_writedata_o      => s_fee_5_rmap_stimuli_writedata,
			fee_5_rmap_rd_address_o     => s_fee_5_rmap_stimuli_rd_address,
			fee_5_rmap_read_o           => s_fee_5_rmap_stimuli_read
		);

	fee_6_rmap_stimuli_inst : entity work.fee_6_rmap_stimuli
		generic map(
			g_ADDRESS_WIDTH => 32,
			g_DATA_WIDTH    => 8
		)
		port map(
			clk_i                       => clk100,
			rst_i                       => rst,
			fee_6_rmap_wr_waitrequest_i => s_fee_6_rmap_stimuli_wr_waitrequest,
			fee_6_rmap_readdata_i       => s_fee_6_rmap_stimuli_readdata,
			fee_6_rmap_rd_waitrequest_i => s_fee_6_rmap_stimuli_rd_waitrequest,
			fee_6_rmap_wr_address_o     => s_fee_6_rmap_stimuli_wr_address,
			fee_6_rmap_write_o          => s_fee_6_rmap_stimuli_write,
			fee_6_rmap_writedata_o      => s_fee_6_rmap_stimuli_writedata,
			fee_6_rmap_rd_address_o     => s_fee_6_rmap_stimuli_rd_address,
			fee_6_rmap_read_o           => s_fee_6_rmap_stimuli_read
		);

	fee_7_rmap_stimuli_inst : entity work.fee_7_rmap_stimuli
		generic map(
			g_ADDRESS_WIDTH => 32,
			g_DATA_WIDTH    => 8
		)
		port map(
			clk_i                       => clk100,
			rst_i                       => rst,
			fee_7_rmap_wr_waitrequest_i => s_fee_7_rmap_stimuli_wr_waitrequest,
			fee_7_rmap_readdata_i       => s_fee_7_rmap_stimuli_readdata,
			fee_7_rmap_rd_waitrequest_i => s_fee_7_rmap_stimuli_rd_waitrequest,
			fee_7_rmap_wr_address_o     => s_fee_7_rmap_stimuli_wr_address,
			fee_7_rmap_write_o          => s_fee_7_rmap_stimuli_write,
			fee_7_rmap_writedata_o      => s_fee_7_rmap_stimuli_writedata,
			fee_7_rmap_rd_address_o     => s_fee_7_rmap_stimuli_rd_address,
			fee_7_rmap_read_o           => s_fee_7_rmap_stimuli_read
		);

	fdrm_rmap_memory_ffee_deb_area_top_inst : entity work.fdrm_rmap_memory_ffee_deb_area_top
		port map(
			reset_i                                  => rst,
			clk_100_i                                => clk100,
			avs_rmap_0_address_i                     => s_rmap_avalon_stimuli_mm_address,
			avs_rmap_0_write_i                       => s_rmap_avalon_stimuli_mm_write,
			avs_rmap_0_read_i                        => s_rmap_avalon_stimuli_mm_read,
			avs_rmap_0_readdata_o                    => s_rmap_avalon_stimuli_mm_readdata,
			avs_rmap_0_writedata_i                   => s_rmap_avalon_stimuli_mm_writedata,
			avs_rmap_0_waitrequest_o                 => s_rmap_avalon_stimuli_mm_waitrequest,
			avs_rmap_0_byteenable_i                  => "1111",
			rms_rmap_0_wr_address_i                  => s_fee_0_rmap_stimuli_wr_address,
			rms_rmap_0_write_i                       => s_fee_0_rmap_stimuli_write,
			rms_rmap_0_writedata_i                   => s_fee_0_rmap_stimuli_writedata,
			rms_rmap_0_rd_address_i                  => s_fee_0_rmap_stimuli_rd_address,
			rms_rmap_0_read_i                        => s_fee_0_rmap_stimuli_read,
			rms_rmap_0_wr_waitrequest_o              => s_fee_0_rmap_stimuli_wr_waitrequest,
			rms_rmap_0_readdata_o                    => s_fee_0_rmap_stimuli_readdata,
			rms_rmap_0_rd_waitrequest_o              => s_fee_0_rmap_stimuli_rd_waitrequest,
			rms_rmap_1_wr_address_i                  => s_fee_1_rmap_stimuli_wr_address,
			rms_rmap_1_write_i                       => s_fee_1_rmap_stimuli_write,
			rms_rmap_1_writedata_i                   => s_fee_1_rmap_stimuli_writedata,
			rms_rmap_1_rd_address_i                  => s_fee_1_rmap_stimuli_rd_address,
			rms_rmap_1_read_i                        => s_fee_1_rmap_stimuli_read,
			rms_rmap_1_wr_waitrequest_o              => s_fee_1_rmap_stimuli_wr_waitrequest,
			rms_rmap_1_readdata_o                    => s_fee_1_rmap_stimuli_readdata,
			rms_rmap_1_rd_waitrequest_o              => s_fee_1_rmap_stimuli_rd_waitrequest,
			rms_rmap_2_wr_address_i                  => s_fee_2_rmap_stimuli_wr_address,
			rms_rmap_2_write_i                       => s_fee_2_rmap_stimuli_write,
			rms_rmap_2_writedata_i                   => s_fee_2_rmap_stimuli_writedata,
			rms_rmap_2_rd_address_i                  => s_fee_2_rmap_stimuli_rd_address,
			rms_rmap_2_read_i                        => s_fee_2_rmap_stimuli_read,
			rms_rmap_2_wr_waitrequest_o              => s_fee_2_rmap_stimuli_wr_waitrequest,
			rms_rmap_2_readdata_o                    => s_fee_2_rmap_stimuli_readdata,
			rms_rmap_2_rd_waitrequest_o              => s_fee_2_rmap_stimuli_rd_waitrequest,
			rms_rmap_3_wr_address_i                  => s_fee_3_rmap_stimuli_wr_address,
			rms_rmap_3_write_i                       => s_fee_3_rmap_stimuli_write,
			rms_rmap_3_writedata_i                   => s_fee_3_rmap_stimuli_writedata,
			rms_rmap_3_rd_address_i                  => s_fee_3_rmap_stimuli_rd_address,
			rms_rmap_3_read_i                        => s_fee_3_rmap_stimuli_read,
			rms_rmap_3_wr_waitrequest_o              => s_fee_3_rmap_stimuli_wr_waitrequest,
			rms_rmap_3_readdata_o                    => s_fee_3_rmap_stimuli_readdata,
			rms_rmap_3_rd_waitrequest_o              => s_fee_3_rmap_stimuli_rd_waitrequest,
			rms_rmap_4_wr_address_i                  => s_fee_4_rmap_stimuli_wr_address,
			rms_rmap_4_write_i                       => s_fee_4_rmap_stimuli_write,
			rms_rmap_4_writedata_i                   => s_fee_4_rmap_stimuli_writedata,
			rms_rmap_4_rd_address_i                  => s_fee_4_rmap_stimuli_rd_address,
			rms_rmap_4_read_i                        => s_fee_4_rmap_stimuli_read,
			rms_rmap_4_wr_waitrequest_o              => s_fee_4_rmap_stimuli_wr_waitrequest,
			rms_rmap_4_readdata_o                    => s_fee_4_rmap_stimuli_readdata,
			rms_rmap_4_rd_waitrequest_o              => s_fee_4_rmap_stimuli_rd_waitrequest,
			rms_rmap_5_wr_address_i                  => s_fee_5_rmap_stimuli_wr_address,
			rms_rmap_5_write_i                       => s_fee_5_rmap_stimuli_write,
			rms_rmap_5_writedata_i                   => s_fee_5_rmap_stimuli_writedata,
			rms_rmap_5_rd_address_i                  => s_fee_5_rmap_stimuli_rd_address,
			rms_rmap_5_read_i                        => s_fee_5_rmap_stimuli_read,
			rms_rmap_5_wr_waitrequest_o              => s_fee_5_rmap_stimuli_wr_waitrequest,
			rms_rmap_5_readdata_o                    => s_fee_5_rmap_stimuli_readdata,
			rms_rmap_5_rd_waitrequest_o              => s_fee_5_rmap_stimuli_rd_waitrequest,
			rms_rmap_6_wr_address_i                  => s_fee_6_rmap_stimuli_wr_address,
			rms_rmap_6_write_i                       => s_fee_6_rmap_stimuli_write,
			rms_rmap_6_writedata_i                   => s_fee_6_rmap_stimuli_writedata,
			rms_rmap_6_rd_address_i                  => s_fee_6_rmap_stimuli_rd_address,
			rms_rmap_6_read_i                        => s_fee_6_rmap_stimuli_read,
			rms_rmap_6_wr_waitrequest_o              => s_fee_6_rmap_stimuli_wr_waitrequest,
			rms_rmap_6_readdata_o                    => s_fee_6_rmap_stimuli_readdata,
			rms_rmap_6_rd_waitrequest_o              => s_fee_6_rmap_stimuli_rd_waitrequest,
			rms_rmap_7_wr_address_i                  => s_fee_7_rmap_stimuli_wr_address,
			rms_rmap_7_write_i                       => s_fee_7_rmap_stimuli_write,
			rms_rmap_7_writedata_i                   => s_fee_7_rmap_stimuli_writedata,
			rms_rmap_7_rd_address_i                  => s_fee_7_rmap_stimuli_rd_address,
			rms_rmap_7_read_i                        => s_fee_7_rmap_stimuli_read,
			rms_rmap_7_wr_waitrequest_o              => s_fee_7_rmap_stimuli_wr_waitrequest,
			rms_rmap_7_readdata_o                    => s_fee_7_rmap_stimuli_readdata,
			rms_rmap_7_rd_waitrequest_o              => s_fee_7_rmap_stimuli_rd_waitrequest,
			avm_rmap_readdata_i                      => s_avm_readdata,
			avm_rmap_waitrequest_i                   => s_avm_waitrequest,
			avm_rmap_address_o                       => s_avm_address,
			avm_rmap_read_o                          => s_avm_read,
			avm_rmap_write_o                         => s_avm_write,
			avm_rmap_writedata_o                     => s_avm_writedata,
			channel_hk_0_rmap_target_status_i        => (others => '0'),
			channel_hk_0_rmap_target_indicate_i      => '0',
			channel_hk_0_spw_link_escape_err_i       => '0',
			channel_hk_0_spw_link_credit_err_i       => '0',
			channel_hk_0_spw_link_parity_err_i       => '0',
			channel_hk_0_spw_link_disconnect_i       => '0',
			channel_hk_0_spw_link_started_i          => '0',
			channel_hk_0_spw_link_connecting_i       => '0',
			channel_hk_0_spw_link_running_i          => '0',
			channel_hk_0_frame_counter_i             => (others => '0'),
			channel_hk_0_left_buffer_ccd_number_i    => (others => '0'),
			channel_hk_0_right_buffer_ccd_number_i   => (others => '0'),
			channel_hk_0_left_buffer_ccd_side_i      => '0',
			channel_hk_0_right_buffer_ccd_side_i     => '0',
			channel_hk_0_err_left_buffer_overflow_i  => '0',
			channel_hk_0_err_right_buffer_overflow_i => '0',
			channel_hk_1_rmap_target_status_i        => (others => '0'),
			channel_hk_1_rmap_target_indicate_i      => '0',
			channel_hk_1_spw_link_escape_err_i       => '0',
			channel_hk_1_spw_link_credit_err_i       => '0',
			channel_hk_1_spw_link_parity_err_i       => '0',
			channel_hk_1_spw_link_disconnect_i       => '0',
			channel_hk_1_spw_link_started_i          => '0',
			channel_hk_1_spw_link_connecting_i       => '0',
			channel_hk_1_spw_link_running_i          => '0',
			channel_hk_1_frame_counter_i             => (others => '0'),
			channel_hk_1_left_buffer_ccd_number_i    => (others => '0'),
			channel_hk_1_right_buffer_ccd_number_i   => (others => '0'),
			channel_hk_1_left_buffer_ccd_side_i      => '0',
			channel_hk_1_right_buffer_ccd_side_i     => '0',
			channel_hk_1_err_left_buffer_overflow_i  => '0',
			channel_hk_1_err_right_buffer_overflow_i => '0',
			channel_hk_2_rmap_target_status_i        => (others => '0'),
			channel_hk_2_rmap_target_indicate_i      => '0',
			channel_hk_2_spw_link_escape_err_i       => '0',
			channel_hk_2_spw_link_credit_err_i       => '0',
			channel_hk_2_spw_link_parity_err_i       => '0',
			channel_hk_2_spw_link_disconnect_i       => '0',
			channel_hk_2_spw_link_started_i          => '0',
			channel_hk_2_spw_link_connecting_i       => '0',
			channel_hk_2_spw_link_running_i          => '0',
			channel_hk_2_frame_counter_i             => (others => '0'),
			channel_hk_2_left_buffer_ccd_number_i    => (others => '0'),
			channel_hk_2_right_buffer_ccd_number_i   => (others => '0'),
			channel_hk_2_left_buffer_ccd_side_i      => '0',
			channel_hk_2_right_buffer_ccd_side_i     => '0',
			channel_hk_2_err_left_buffer_overflow_i  => '0',
			channel_hk_2_err_right_buffer_overflow_i => '0',
			channel_hk_3_rmap_target_status_i        => (others => '0'),
			channel_hk_3_rmap_target_indicate_i      => '0',
			channel_hk_3_spw_link_escape_err_i       => '0',
			channel_hk_3_spw_link_credit_err_i       => '0',
			channel_hk_3_spw_link_parity_err_i       => '0',
			channel_hk_3_spw_link_disconnect_i       => '0',
			channel_hk_3_spw_link_started_i          => '0',
			channel_hk_3_spw_link_connecting_i       => '0',
			channel_hk_3_spw_link_running_i          => '0',
			channel_hk_3_frame_counter_i             => (others => '0'),
			channel_hk_3_left_buffer_ccd_number_i    => (others => '0'),
			channel_hk_3_right_buffer_ccd_number_i   => (others => '0'),
			channel_hk_3_left_buffer_ccd_side_i      => '0',
			channel_hk_3_right_buffer_ccd_side_i     => '0',
			channel_hk_3_err_left_buffer_overflow_i  => '0',
			channel_hk_3_err_right_buffer_overflow_i => '0',
			channel_win_mem_addr_offset_i            => x"1000000000000001"
		);
	s_avm_waitrequest <= (s_tb_avs_rd_waitrequest) and (s_tb_avs_wr_waitrequest);

	fdrm_tb_avs_read_ent_inst : entity work.fdrm_tb_avs_read_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			fdrm_tb_avs_avalon_mm_i.address     => s_avm_address,
			fdrm_tb_avs_avalon_mm_i.read        => s_avm_read,
			fdrm_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			fdrm_tb_avs_avalon_mm_o.readdata    => s_avm_readdata,
			fdrm_tb_avs_avalon_mm_o.waitrequest => s_tb_avs_rd_waitrequest
		);

	fdrm_tb_avs_write_ent_inst : entity work.fdrm_tb_avs_write_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			fdrm_tb_avs_avalon_mm_i.address     => s_avm_address,
			fdrm_tb_avs_avalon_mm_i.write       => s_avm_write,
			fdrm_tb_avs_avalon_mm_i.writedata   => s_avm_writedata,
			fdrm_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			fdrm_tb_avs_avalon_mm_o.waitrequest => s_tb_avs_wr_waitrequest
		);

end architecture RTL;
