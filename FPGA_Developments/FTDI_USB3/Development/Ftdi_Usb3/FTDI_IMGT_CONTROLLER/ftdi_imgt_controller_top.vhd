library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_avm_imgt_pkg.all;

entity ftdi_imgt_controller_top is
    port(
        clk_i                             : in  std_logic;
        rst_i                             : in  std_logic;
        ftdi_module_stop_i                : in  std_logic;
        ftdi_module_start_i               : in  std_logic;
        imgt_controller_start_i           : in  std_logic;
        imgt_controller_discard_i         : in  std_logic;
        imgt_inv_pixels_byte_order_i      : in  std_logic;
        imgt_buffer_empty_i               : in  std_logic;
        imgt_buffer_rddata_i              : in  std_logic_vector(31 downto 0);
        imgt_buffer_usedw_i               : in  std_logic_vector(8 downto 0);
        fee_ccd_halfwidth_pixels_i        : in  std_logic_vector(15 downto 0);
        fee_ccd_height_pixels_i           : in  std_logic_vector(15 downto 0);
        fee_0_ccd_0_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        fee_0_ccd_0_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        fee_0_ccd_1_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        fee_0_ccd_1_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        fee_0_ccd_2_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        fee_0_ccd_2_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        fee_0_ccd_3_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        fee_0_ccd_3_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_0_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_0_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_1_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_1_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_2_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_2_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_3_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_3_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_0_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_0_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_1_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_1_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_2_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_2_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_3_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_3_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_0_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_0_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_1_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_1_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_2_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_2_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_3_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_3_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_0_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_0_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_1_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_1_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_2_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_2_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_3_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_3_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_0_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_0_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_1_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_1_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_2_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_2_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_3_left_initial_addr_i   : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_3_right_initial_addr_i  : in  std_logic_vector(63 downto 0);
        ftdi_avm_imgt_master_wr_status_i  : in  t_ftdi_avm_imgt_master_wr_status;
        imgt_controller_busy_o            : out std_logic;
        imgt_buffer_rdreq_o               : out std_logic;
        ftdi_avm_imgt_master_wr_control_o : out t_ftdi_avm_imgt_master_wr_control
    );
end entity ftdi_imgt_controller_top;

architecture RTL of ftdi_imgt_controller_top is

    -- FTDI Imagette Controller Data Signals
    signal s_controller_data_discard : std_logic;
    signal s_imgt_data_rddone        : std_logic;
    signal s_imgt_data_rdready       : std_logic;
    signal s_imgt_data_rddata        : std_logic_vector(31 downto 0);

    -- FTDI Imagette Controller CCD Signals
    signal s_ccd_imgt_data_rddone     : std_logic;
    signal s_ccd_left_initial_addr    : std_logic_vector(63 downto 0);
    signal s_ccd_right_initial_addr   : std_logic_vector(63 downto 0);
    signal s_ccd_halfwidth_pixels     : std_logic_vector(15 downto 0);
    signal s_ccd_height_pixels        : std_logic_vector(15 downto 0);
    signal s_invert_pixels_byte_order : std_logic;

    -- FTDI Imagette Controller Imagette Signals
    signal s_controller_imagette_imgt_data_rddone : std_logic;
    signal s_controller_imagette_start            : std_logic;
    signal s_controller_imagette_reset            : std_logic;
    signal s_controller_imagette_finished         : std_logic;

begin

    -- FTDI Imagette Controller Data Instantiation
    ftdi_imgt_controller_data_ent_inst : entity work.ftdi_imgt_controller_data_ent
        port map(
            clk_i                => clk_i,
            rst_i                => rst_i,
            ftdi_module_stop_i   => ftdi_module_stop_i,
            ftdi_module_start_i  => ftdi_module_start_i,
            controller_discard_i => s_controller_data_discard,
            imgt_buffer_empty_i  => imgt_buffer_empty_i,
            imgt_buffer_rddata_i => imgt_buffer_rddata_i,
            imgt_buffer_usedw_i  => imgt_buffer_usedw_i,
            imgt_data_rddone_i   => s_imgt_data_rddone,
            imgt_buffer_rdreq_o  => imgt_buffer_rdreq_o,
            imgt_data_rdready_o  => s_imgt_data_rdready,
            imgt_data_rddata_o   => s_imgt_data_rddata
        );

    -- FTDI Imagette Controller CCD Instantiation
    ftdi_imgt_controller_ccd_ent_inst : entity work.ftdi_imgt_controller_ccd_ent
        port map(
            clk_i                            => clk_i,
            rst_i                            => rst_i,
            ftdi_module_stop_i               => ftdi_module_stop_i,
            ftdi_module_start_i              => ftdi_module_start_i,
            controller_start_i               => imgt_controller_start_i,
            controller_discard_i             => imgt_controller_discard_i,
            inv_pixels_byte_order_i          => imgt_inv_pixels_byte_order_i,
            imgt_data_rdready_i              => s_imgt_data_rdready,
            imgt_data_rddata_i               => s_imgt_data_rddata,
            controller_imagette_finished_i   => s_controller_imagette_finished,
            fee_ccd_halfwidth_pixels_i       => fee_ccd_halfwidth_pixels_i,
            fee_ccd_height_pixels_i          => fee_ccd_height_pixels_i,
            fee_0_ccd_0_left_initial_addr_i  => fee_0_ccd_0_left_initial_addr_i,
            fee_0_ccd_0_right_initial_addr_i => fee_0_ccd_0_right_initial_addr_i,
            fee_0_ccd_1_left_initial_addr_i  => fee_0_ccd_1_left_initial_addr_i,
            fee_0_ccd_1_right_initial_addr_i => fee_0_ccd_1_right_initial_addr_i,
            fee_0_ccd_2_left_initial_addr_i  => fee_0_ccd_2_left_initial_addr_i,
            fee_0_ccd_2_right_initial_addr_i => fee_0_ccd_2_right_initial_addr_i,
            fee_0_ccd_3_left_initial_addr_i  => fee_0_ccd_3_left_initial_addr_i,
            fee_0_ccd_3_right_initial_addr_i => fee_0_ccd_3_right_initial_addr_i,
            --			fee_1_ccd_0_left_initial_addr_i  => fee_1_ccd_0_left_initial_addr_i,
            --			fee_1_ccd_0_right_initial_addr_i => fee_1_ccd_0_right_initial_addr_i,
            --			fee_1_ccd_1_left_initial_addr_i  => fee_1_ccd_1_left_initial_addr_i,
            --			fee_1_ccd_1_right_initial_addr_i => fee_1_ccd_1_right_initial_addr_i,
            --			fee_1_ccd_2_left_initial_addr_i  => fee_1_ccd_2_left_initial_addr_i,
            --			fee_1_ccd_2_right_initial_addr_i => fee_1_ccd_2_right_initial_addr_i,
            --			fee_1_ccd_3_left_initial_addr_i  => fee_1_ccd_3_left_initial_addr_i,
            --			fee_1_ccd_3_right_initial_addr_i => fee_1_ccd_3_right_initial_addr_i,
            --			fee_2_ccd_0_left_initial_addr_i  => fee_2_ccd_0_left_initial_addr_i,
            --			fee_2_ccd_0_right_initial_addr_i => fee_2_ccd_0_right_initial_addr_i,
            --			fee_2_ccd_1_left_initial_addr_i  => fee_2_ccd_1_left_initial_addr_i,
            --			fee_2_ccd_1_right_initial_addr_i => fee_2_ccd_1_right_initial_addr_i,
            --			fee_2_ccd_2_left_initial_addr_i  => fee_2_ccd_2_left_initial_addr_i,
            --			fee_2_ccd_2_right_initial_addr_i => fee_2_ccd_2_right_initial_addr_i,
            --			fee_2_ccd_3_left_initial_addr_i  => fee_2_ccd_3_left_initial_addr_i,
            --			fee_2_ccd_3_right_initial_addr_i => fee_2_ccd_3_right_initial_addr_i,
            --			fee_3_ccd_0_left_initial_addr_i  => fee_3_ccd_0_left_initial_addr_i,
            --			fee_3_ccd_0_right_initial_addr_i => fee_3_ccd_0_right_initial_addr_i,
            --			fee_3_ccd_1_left_initial_addr_i  => fee_3_ccd_1_left_initial_addr_i,
            --			fee_3_ccd_1_right_initial_addr_i => fee_3_ccd_1_right_initial_addr_i,
            --			fee_3_ccd_2_left_initial_addr_i  => fee_3_ccd_2_left_initial_addr_i,
            --			fee_3_ccd_2_right_initial_addr_i => fee_3_ccd_2_right_initial_addr_i,
            --			fee_3_ccd_3_left_initial_addr_i  => fee_3_ccd_3_left_initial_addr_i,
            --			fee_3_ccd_3_right_initial_addr_i => fee_3_ccd_3_right_initial_addr_i,
            --			fee_4_ccd_0_left_initial_addr_i  => fee_4_ccd_0_left_initial_addr_i,
            --			fee_4_ccd_0_right_initial_addr_i => fee_4_ccd_0_right_initial_addr_i,
            --			fee_4_ccd_1_left_initial_addr_i  => fee_4_ccd_1_left_initial_addr_i,
            --			fee_4_ccd_1_right_initial_addr_i => fee_4_ccd_1_right_initial_addr_i,
            --			fee_4_ccd_2_left_initial_addr_i  => fee_4_ccd_2_left_initial_addr_i,
            --			fee_4_ccd_2_right_initial_addr_i => fee_4_ccd_2_right_initial_addr_i,
            --			fee_4_ccd_3_left_initial_addr_i  => fee_4_ccd_3_left_initial_addr_i,
            --			fee_4_ccd_3_right_initial_addr_i => fee_4_ccd_3_right_initial_addr_i,
            --			fee_5_ccd_0_left_initial_addr_i  => fee_5_ccd_0_left_initial_addr_i,
            --			fee_5_ccd_0_right_initial_addr_i => fee_5_ccd_0_right_initial_addr_i,
            --			fee_5_ccd_1_left_initial_addr_i  => fee_5_ccd_1_left_initial_addr_i,
            --			fee_5_ccd_1_right_initial_addr_i => fee_5_ccd_1_right_initial_addr_i,
            --			fee_5_ccd_2_left_initial_addr_i  => fee_5_ccd_2_left_initial_addr_i,
            --			fee_5_ccd_2_right_initial_addr_i => fee_5_ccd_2_right_initial_addr_i,
            --			fee_5_ccd_3_left_initial_addr_i  => fee_5_ccd_3_left_initial_addr_i,
            --			fee_5_ccd_3_right_initial_addr_i => fee_5_ccd_3_right_initial_addr_i,
            controller_busy_o                => imgt_controller_busy_o,
            imgt_data_rddone_o               => s_ccd_imgt_data_rddone,
            controller_imagette_start_o      => s_controller_imagette_start,
            controller_imagette_reset_o      => s_controller_imagette_reset,
            controller_data_discard_o        => s_controller_data_discard,
            ccd_left_initial_addr_o          => s_ccd_left_initial_addr,
            ccd_right_initial_addr_o         => s_ccd_right_initial_addr,
            ccd_halfwidth_pixels_o           => s_ccd_halfwidth_pixels,
            ccd_height_pixels_o              => s_ccd_height_pixels,
            invert_pixels_byte_order_o       => s_invert_pixels_byte_order
        );

    -- FTDI Imagette Controller Imagette Instantiation
    ftdi_imgt_controller_imagette_ent_inst : entity work.ftdi_imgt_controller_imagette_ent
        port map(
            clk_i                      => clk_i,
            rst_i                      => rst_i,
            ftdi_module_stop_i         => ftdi_module_stop_i,
            ftdi_module_start_i        => ftdi_module_start_i,
            controller_start_i         => s_controller_imagette_start,
            controller_reset_i         => s_controller_imagette_reset,
            ccd_left_initial_addr_i    => s_ccd_left_initial_addr,
            ccd_right_initial_addr_i   => s_ccd_right_initial_addr,
            ccd_halfwidth_pixels_i     => s_ccd_halfwidth_pixels,
            ccd_height_pixels_i        => s_ccd_height_pixels,
            invert_pixels_byte_order_i => s_invert_pixels_byte_order,
            avm_master_wr_status_i     => ftdi_avm_imgt_master_wr_status_i,
            imgt_data_rdready_i        => s_imgt_data_rdready,
            imgt_data_rddata_i         => s_imgt_data_rddata,
            controller_finished_o      => s_controller_imagette_finished,
            avm_master_wr_control_o    => ftdi_avm_imgt_master_wr_control_o,
            imgt_data_rddone_o         => s_controller_imagette_imgt_data_rddone
        );

    -- Signals Assignments --

    -- Imagette Buffer Signals Assignments
    s_imgt_data_rddone <= (s_ccd_imgt_data_rddone) or (s_controller_imagette_imgt_data_rddone);

end architecture RTL;
