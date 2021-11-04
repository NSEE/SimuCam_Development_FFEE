library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_slave_stimulli_pkg.all;

entity avalon_slave_stimulli_write is
    port(
        clk_i       : in  std_logic;
        rst_i       : in  std_logic;
        avalon_mm_i : in  t_fdrm_tb_avs_avalon_mm_write_in;
        avalon_mm_o : out t_fdrm_tb_avs_avalon_mm_write_out
    );
end entity avalon_slave_stimulli_write;

architecture rtl of avalon_slave_stimulli_write is

    signal s_data_acquired : std_logic;

begin

    p_fdrm_tb_avs_write : process(clk_i, rst_i) is
        procedure p_reset_registers is
        begin

            -- Write Registers Reset/Default State

        end procedure p_reset_registers;

        procedure p_control_triggers is
        begin

            -- Write Registers Triggers Reset

        end procedure p_control_triggers;

        procedure p_writedata(write_address_i : t_fdrm_tb_avs_avalon_mm_address) is
        begin

            -- Registers Write Data
            case (write_address_i) is
                -- Case for access to all registers address

                when others =>
                    -- No register associated to the address, do nothing
                    null;

            end case;

        end procedure p_writedata;

        variable v_write_address : t_fdrm_tb_avs_avalon_mm_address := (others => '0');
    begin
        if (rst_i = '1') then
            avalon_mm_o.waitrequest <= '1';
            s_data_acquired         <= '0';
            v_write_address         := (others => '0');
            p_reset_registers;
        elsif (rising_edge(clk_i)) then
            avalon_mm_o.waitrequest <= '1';
            p_control_triggers;
            s_data_acquired         <= '0';
            if (avalon_mm_i.write = '1') then
                v_write_address         := unsigned(avalon_mm_i.address);
                avalon_mm_o.waitrequest <= '0';
                s_data_acquired         <= '1';
                if (s_data_acquired = '0') then
                    p_writedata(v_write_address);
                end if;
            end if;
        end if;
    end process p_fdrm_tb_avs_write;

end architecture rtl;
