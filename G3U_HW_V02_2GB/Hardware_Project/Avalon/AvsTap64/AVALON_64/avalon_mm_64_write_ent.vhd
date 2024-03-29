library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_64_pkg.all;
use work.avalon_mm_32_registers_pkg.all;

entity avalon_mm_64_write_ent is
	port(
		clk_i             : in  std_logic;
		rst_i             : in  std_logic;
		avalon_mm_64_i    : in  t_avalon_mm_64_write_in;
		avstap_clear_i    : in  std_logic;
		avalon_mm_64_o    : out t_avalon_mm_64_write_out;
		write_registers_o : out t_avstap_read_registers
	);
end entity avalon_mm_64_write_ent;

architecture rtl of avalon_mm_64_write_ent is

	signal s_waitrequest : std_logic;

begin

	p_avalon_mm_64_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			write_registers_o.avstap_data_reg.avstap_data <= (others => x"00000000");
			s_waitrequest                                 <= '0';
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_64_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when 0 to ((c_AVSTAP_DATA_SIZE_DWORDS / 2) - 1) =>
					-- check if the waitrequested is still active
					if (s_waitrequest = '1') then
						-- waitrequest active, execute write operation
						write_registers_o.avstap_data_reg.avstap_data((write_address_i * 2) + 0) <= avalon_mm_64_i.writedata(31 downto 0);
						write_registers_o.avstap_data_reg.avstap_data((write_address_i * 2) + 1) <= avalon_mm_64_i.writedata(63 downto 32);
					end if;

				when others =>
					null;
			end case;

		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_64_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_64_o.waitrequest <= '1';
			s_waitrequest              <= '1';
			v_write_address            := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_64_o.waitrequest <= '1';
			s_waitrequest              <= '1';
			p_control_triggers;
			if (avalon_mm_64_i.write = '1') then
				avalon_mm_64_o.waitrequest <= '0';
				s_waitrequest              <= '0';
				v_write_address            := to_integer(unsigned(avalon_mm_64_i.address));
				p_writedata(v_write_address);
			else
				-- check if a clear was received
				if (avstap_clear_i = '1') then
					write_registers_o.avstap_data_reg.avstap_data <= (others => x"00000000");
				end if;
			end if;
		end if;
	end process p_avalon_mm_64_write;

end architecture rtl;
