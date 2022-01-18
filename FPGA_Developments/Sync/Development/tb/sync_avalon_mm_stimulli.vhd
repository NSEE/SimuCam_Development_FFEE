library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sync_avalon_mm_pkg.all;
use work.sync_mm_registers_pkg.all;
use work.sync_common_pkg.all;

entity sync_avalon_mm_stimulli is
    generic(
        g_SYNC_DEFAULT_STBY_POLARITY : std_logic := c_SYNC_DEFAULT_STBY_POLARITY
    );
    port(
        clk_i                       : in  std_logic;
        rst_i                       : in  std_logic;
        mm_read_reg_i               : in  t_sync_mm_read_registers;
        mm_write_reg_o              : out t_sync_mm_write_registers;
        avs_config_rd_readdata_o    : out std_logic_vector(31 downto 0);
        avs_config_rd_waitrequest_o : out std_logic;
        avs_config_wr_waitrequest_o : out std_logic
    );
end entity sync_avalon_mm_stimulli;

architecture RTL of sync_avalon_mm_stimulli is

    signal s_counter : natural := 0;

begin

    p_sync_avalon_mm_stimulli : process(clk_i, rst_i) is
        procedure p_reset_registers is
        begin

            -- Write Registers Reset/Default State

            -- Sync Interrupt Enable Register : Error interrupt enable bit
            mm_write_reg_o.sync_irq_enable_reg.error_irq_enable                        <= '0';
            -- Sync Interrupt Enable Register : Blank pulse interrupt enable bit
            mm_write_reg_o.sync_irq_enable_reg.blank_pulse_irq_enable                  <= '0';
            -- Sync Interrupt Enable Register : Master pulse interrupt enable bit
            mm_write_reg_o.sync_irq_enable_reg.master_pulse_irq_enable                 <= '0';
            -- Sync Interrupt Enable Register : Normal pulse interrupt enable bit
            mm_write_reg_o.sync_irq_enable_reg.normal_pulse_irq_enable                 <= '0';
            -- Sync Interrupt Enable Register : Last pulse interrupt enable bit
            mm_write_reg_o.sync_irq_enable_reg.last_pulse_irq_enable                   <= '0';
            -- Sync Interrupt Flag Clear Register : Error interrupt flag clear bit
            mm_write_reg_o.sync_irq_flag_clear_reg.error_irq_flag_clear                <= '0';
            -- Sync Interrupt Flag Clear Register : Blank pulse interrupt flag clear bit
            mm_write_reg_o.sync_irq_flag_clear_reg.blank_pulse_irq_flag_clear          <= '0';
            -- Sync Interrupt Flag Clear Register : Master pulse interrupt flag clear bit
            mm_write_reg_o.sync_irq_flag_clear_reg.master_pulse_irq_flag_clear         <= '0';
            -- Sync Interrupt Flag Clear Register : Normal pulse interrupt flag clear bit
            mm_write_reg_o.sync_irq_flag_clear_reg.normal_pulse_irq_flag_clear         <= '0';
            -- Sync Interrupt Flag Clear Register : Last pulse interrupt flag clear bit
            mm_write_reg_o.sync_irq_flag_clear_reg.last_pulse_irq_flag_clear           <= '0';
            -- Pre-Sync Interrupt Enable Register : Pre-Blank pulse interrupt enable bit
            mm_write_reg_o.pre_sync_irq_enable_reg.pre_blank_pulse_irq_enable          <= '0';
            -- Pre-Sync Interrupt Enable Register : Pre-Master pulse interrupt enable bit
            mm_write_reg_o.pre_sync_irq_enable_reg.pre_master_pulse_irq_enable         <= '0';
            -- Pre-Sync Interrupt Enable Register : Pre-Normal pulse interrupt enable bit
            mm_write_reg_o.pre_sync_irq_enable_reg.pre_normal_pulse_irq_enable         <= '0';
            -- Pre-Sync Interrupt Enable Register : Pre-Last pulse interrupt enable bit
            mm_write_reg_o.pre_sync_irq_enable_reg.pre_last_pulse_irq_enable           <= '0';
            -- Pre-Sync Interrupt Flag Clear Register : Pre-Blank pulse interrupt flag clear bit
            mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_blank_pulse_irq_flag_clear  <= '0';
            -- Pre-Sync Interrupt Flag Clear Register : Pre-Master pulse interrupt flag clear bit
            mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_master_pulse_irq_flag_clear <= '0';
            -- Pre-Sync Interrupt Flag Clear Register : Pre-Normal pulse interrupt flag clear bit
            mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_normal_pulse_irq_flag_clear <= '0';
            -- Pre-Sync Interrupt Flag Clear Register : Pre-Last pulse interrupt flag clear bit
            mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_last_pulse_irq_flag_clear   <= '0';
            -- Sync Master Blank Time Config Register : MBT value
            mm_write_reg_o.sync_config_reg.master_blank_time                           <= (others => '0');
            -- Sync Blank Time Config Register : BT value
            mm_write_reg_o.sync_config_reg.blank_time                                  <= (others => '0');
            -- Sync Last Blank Time Config Register : LBT value
            mm_write_reg_o.sync_config_reg.last_blank_time                             <= (others => '0');
            -- Sync Pre-Blank Time Config Register : Pre-Blank value
            mm_write_reg_o.sync_config_reg.pre_blank_time                              <= (others => '0');
            -- Sync Period Config Register : Period value
            mm_write_reg_o.sync_config_reg.period                                      <= (others => '0');
            -- Sync Last Period Config Register : Last Period value
            mm_write_reg_o.sync_config_reg.last_period                                 <= (others => '0');
            -- Sync Master Detection Time : Master Detection Time value
            mm_write_reg_o.sync_config_reg.master_detection_time                       <= std_logic_vector(to_unsigned(15000000, 32));
            -- Sync Shot Time Config Register : OST value
            mm_write_reg_o.sync_config_reg.one_shot_time                               <= (others => '0');
            -- Sync Transition Filter Register : Blank Filter Time value
            mm_write_reg_o.sync_config_reg.blank_filter_time                           <= (others => '0');
            -- Sync Transition Filter Register : Release Filter Time value
            mm_write_reg_o.sync_config_reg.release_filter_time                         <= (others => '0');
            -- Sync General Config Register : Signal polarity
            mm_write_reg_o.sync_general_config_reg.signal_polarity                     <= not g_SYNC_DEFAULT_STBY_POLARITY;
            -- Sync General Config Register : Number of cycles
            mm_write_reg_o.sync_general_config_reg.number_of_cycles                    <= (others => '0');
            -- Sync Error Injection Register : Reserved
            mm_write_reg_o.sync_error_injection_reg.error_injection                    <= (others => '0');
            -- Sync Control Register : Internal/External(n) bit
            mm_write_reg_o.sync_control_reg.int_ext_n                                  <= '0';
            -- Sync Control Register : Start bit
            mm_write_reg_o.sync_control_reg.start                                      <= '0';
            -- Sync Control Register : Reset bit
            mm_write_reg_o.sync_control_reg.reset                                      <= '0';
            -- Sync Control Register : One Shot bit
            mm_write_reg_o.sync_control_reg.one_shot                                   <= '0';
            -- Sync Control Register : Err_inj bit
            mm_write_reg_o.sync_control_reg.err_inj                                    <= '0';
            -- Sync Control Register : Hold Blank Pulse
            mm_write_reg_o.sync_control_reg.hold_blank_pulse                           <= '0';
            -- Sync Control Register : Hold Release Pulse
            mm_write_reg_o.sync_control_reg.hold_release_pulse                         <= '0';
            -- Sync Control Register : Sync_out  out enable bit
            mm_write_reg_o.sync_control_reg.out_enable                                 <= '0';
            -- Sync Control Register : Channel 1 out enable bit
            mm_write_reg_o.sync_control_reg.channel_1_enable                           <= '0';
            -- Sync Control Register : Channel 2 out enable bit
            mm_write_reg_o.sync_control_reg.channel_2_enable                           <= '0';
            -- Sync Control Register : Channel 3 out enable bit
            mm_write_reg_o.sync_control_reg.channel_3_enable                           <= '0';
            -- Sync Control Register : Channel 4 out enable bit
            mm_write_reg_o.sync_control_reg.channel_4_enable                           <= '0';
            -- Sync Control Register : Channel 5 out enable bit
            mm_write_reg_o.sync_control_reg.channel_5_enable                           <= '0';
            -- Sync Control Register : Channel 6 out enable bit
            mm_write_reg_o.sync_control_reg.channel_6_enable                           <= '0';
            -- Sync Control Register : Channel 7 out enable bit
            mm_write_reg_o.sync_control_reg.channel_7_enable                           <= '0';
            -- Sync Control Register : Channel 8 out enable bit
            mm_write_reg_o.sync_control_reg.channel_8_enable                           <= '0';
            -- Sync Test Control Register : Sync_in override enable
            mm_write_reg_o.sync_test_control_reg.sync_in_override_en                   <= '0';
            -- Sync Test Control Register : Sync_in override value
            mm_write_reg_o.sync_test_control_reg.sync_in_override_value                <= '0';
            -- Sync Test Control Register : Sync_out override enable
            mm_write_reg_o.sync_test_control_reg.sync_out_override_en                  <= '0';
            -- Sync Test Control Register : Sync_out override value
            mm_write_reg_o.sync_test_control_reg.sync_out_override_value               <= '0';

        end procedure p_reset_registers;

        procedure p_control_triggers is
        begin

            -- Write Registers Triggers Reset

            -- Sync Interrupt Flag Clear Register : Error interrupt flag clear bit
            mm_write_reg_o.sync_irq_flag_clear_reg.error_irq_flag_clear                <= '0';
            -- Sync Interrupt Flag Clear Register : Blank pulse interrupt flag clear bit
            mm_write_reg_o.sync_irq_flag_clear_reg.blank_pulse_irq_flag_clear          <= '0';
            -- Sync Interrupt Flag Clear Register : Master pulse interrupt flag clear bit
            mm_write_reg_o.sync_irq_flag_clear_reg.master_pulse_irq_flag_clear         <= '0';
            -- Sync Interrupt Flag Clear Register : Normal pulse interrupt flag clear bit
            mm_write_reg_o.sync_irq_flag_clear_reg.normal_pulse_irq_flag_clear         <= '0';
            -- Sync Interrupt Flag Clear Register : Last pulse interrupt flag clear bit
            mm_write_reg_o.sync_irq_flag_clear_reg.last_pulse_irq_flag_clear           <= '0';
            -- Pre-Sync Interrupt Flag Clear Register : Pre-Blank pulse interrupt flag clear bit
            mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_blank_pulse_irq_flag_clear  <= '0';
            -- Pre-Sync Interrupt Flag Clear Register : Pre-Master pulse interrupt flag clear bit
            mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_master_pulse_irq_flag_clear <= '0';
            -- Pre-Sync Interrupt Flag Clear Register : Pre-Normal pulse interrupt flag clear bit
            mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_normal_pulse_irq_flag_clear <= '0';
            -- Pre-Sync Interrupt Flag Clear Register : Pre-Last pulse interrupt flag clear bit
            mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_last_pulse_irq_flag_clear   <= '0';
            -- Sync Control Register : Start bit
            mm_write_reg_o.sync_control_reg.start                                      <= '0';
            -- Sync Control Register : Reset bit
            mm_write_reg_o.sync_control_reg.reset                                      <= '0';
            -- Sync Control Register : One Shot bit
            mm_write_reg_o.sync_control_reg.one_shot                                   <= '0';
            -- Sync Control Register : Err_inj bit
            mm_write_reg_o.sync_control_reg.err_inj                                    <= '0';

        end procedure p_control_triggers;

    begin
        if (rst_i = '1') then

            s_counter                   <= 0;
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
                    -- sync module configuration
                    mm_write_reg_o.sync_config_reg.master_blank_time        <= std_logic_vector(to_unsigned(312 - 20, 32));
                    mm_write_reg_o.sync_config_reg.blank_time               <= std_logic_vector(to_unsigned(312 - 20, 32));
                    mm_write_reg_o.sync_config_reg.last_blank_time          <= std_logic_vector(to_unsigned(312 - 20, 32));
                    mm_write_reg_o.sync_config_reg.pre_blank_time           <= std_logic_vector(to_unsigned(10, 32));
                    mm_write_reg_o.sync_config_reg.period                   <= std_logic_vector(to_unsigned(312, 32));
                    mm_write_reg_o.sync_config_reg.last_period              <= std_logic_vector(to_unsigned(312, 32));
                    mm_write_reg_o.sync_config_reg.master_detection_time    <= std_logic_vector(to_unsigned(15, 32));
                    mm_write_reg_o.sync_config_reg.one_shot_time            <= std_logic_vector(to_unsigned(5, 32));
                    mm_write_reg_o.sync_config_reg.blank_filter_time        <= std_logic_vector(to_unsigned(100, 32));
                    mm_write_reg_o.sync_config_reg.release_filter_time      <= std_logic_vector(to_unsigned(10, 32));
                    mm_write_reg_o.sync_general_config_reg.signal_polarity  <= '1';
                    mm_write_reg_o.sync_general_config_reg.number_of_cycles <= std_logic_vector(to_unsigned(1, 8));
                    mm_write_reg_o.sync_control_reg.int_ext_n               <= '1';
                    mm_write_reg_o.sync_control_reg.out_enable              <= '1';

                when 10 =>
                    -- start sync module
                    mm_write_reg_o.sync_control_reg.start <= '1';

                when 15 =>
                    --                when 4500 =>
                    -- enable irqs
                    mm_write_reg_o.sync_irq_enable_reg.blank_pulse_irq_enable          <= '1';
                    mm_write_reg_o.sync_irq_enable_reg.master_pulse_irq_enable         <= '1';
                    mm_write_reg_o.sync_irq_enable_reg.normal_pulse_irq_enable         <= '1';
                    mm_write_reg_o.sync_irq_enable_reg.last_pulse_irq_enable           <= '1';
                    mm_write_reg_o.pre_sync_irq_enable_reg.pre_blank_pulse_irq_enable  <= '1';
                    mm_write_reg_o.pre_sync_irq_enable_reg.pre_master_pulse_irq_enable <= '1';
                    mm_write_reg_o.pre_sync_irq_enable_reg.pre_normal_pulse_irq_enable <= '1';
                    mm_write_reg_o.pre_sync_irq_enable_reg.pre_last_pulse_irq_enable   <= '1';

                when 2000 =>
                    mm_write_reg_o.sync_irq_flag_clear_reg.blank_pulse_irq_flag_clear          <= '1';
                    mm_write_reg_o.sync_irq_flag_clear_reg.master_pulse_irq_flag_clear         <= '1';
                    mm_write_reg_o.sync_irq_flag_clear_reg.normal_pulse_irq_flag_clear         <= '1';
                    mm_write_reg_o.sync_irq_flag_clear_reg.last_pulse_irq_flag_clear           <= '1';
                    mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_blank_pulse_irq_flag_clear  <= '1';
                    mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_master_pulse_irq_flag_clear <= '1';
                    mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_normal_pulse_irq_flag_clear <= '1';
                    mm_write_reg_o.pre_sync_irq_flag_clear_reg.pre_last_pulse_irq_flag_clear   <= '1';

                when others =>
                    null;

            end case;

        end if;
    end process p_sync_avalon_mm_stimulli;

    avs_config_rd_readdata_o    <= (others => '0');
    avs_config_rd_waitrequest_o <= '1';
    avs_config_wr_waitrequest_o <= '1';

end architecture RTL;
