library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.farm_tb_avs_pkg.all;

entity farm_tb_avs_read_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		farm_tb_avs_avalon_mm_i : in  t_farm_tb_avs_avalon_mm_read_in;
		farm_tb_avs_avalon_mm_o : out t_farm_tb_avs_avalon_mm_read_out
	);
end entity farm_tb_avs_read_ent;

architecture rtl of farm_tb_avs_read_ent is

begin

	p_farm_tb_avs_read : process(clk_i, rst_i) is
		procedure p_readdata(read_address_i : t_farm_tb_avs_avalon_mm_address) is
		begin

			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when others =>
					-- No register associated to the address, return with 0x00000000
					farm_tb_avs_avalon_mm_o.readdata <= (others => '1');

			end case;

		end procedure p_readdata;

		variable v_read_address : t_farm_tb_avs_avalon_mm_address := (others => '0');
	begin
		if (rst_i = '1') then
			farm_tb_avs_avalon_mm_o.readdata    <= (others => '0');
			farm_tb_avs_avalon_mm_o.waitrequest <= '1';
			v_read_address                      := (others => '0');
		elsif (rising_edge(clk_i)) then
			farm_tb_avs_avalon_mm_o.readdata    <= (others => '0');
			farm_tb_avs_avalon_mm_o.waitrequest <= '1';
			if (farm_tb_avs_avalon_mm_i.read = '1') then
				v_read_address                      := unsigned(farm_tb_avs_avalon_mm_i.address);
				farm_tb_avs_avalon_mm_o.waitrequest <= '0';
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_farm_tb_avs_read;

end architecture rtl;
