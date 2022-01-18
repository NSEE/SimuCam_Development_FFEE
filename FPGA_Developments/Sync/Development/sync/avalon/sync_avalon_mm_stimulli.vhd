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

            null;

        end procedure p_reset_registers;

        procedure p_control_triggers is
        begin

            -- Write Registers Triggers Reset

            null;

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

                when others =>
                    null;

            end case;

        end if;
    end process p_sync_avalon_mm_stimulli;

    avs_config_rd_readdata_o    <= (others => '0');
    avs_config_rd_waitrequest_o <= '1';
    avs_config_wr_waitrequest_o <= '1';

end architecture RTL;
