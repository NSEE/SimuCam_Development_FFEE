library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_rst_controller_pkg.all;
use work.avalon_mm_rst_controller_registers_pkg.all;

entity avalon_mm_rst_controller_read_ent is
	port(
		clk_i                            : in  std_logic;
		rst_i                            : in  std_logic;
		avalon_mm_spacewire_i            : in  t_avalon_mm_rst_controller_read_in;
		avalon_mm_spacewire_o            : out t_avalon_mm_rst_controller_read_out;
		rst_controller_write_registers_i : in  t_rst_controller_write_registers
	);
end entity avalon_mm_rst_controller_read_ent;

architecture rtl of avalon_mm_rst_controller_read_ent is

begin

	p_avalon_mm_rst_controller_read : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			null;
		end procedure p_reset_registers;

		procedure p_flags_hold is
		begin
			null;
		end procedure p_flags_hold;

		procedure p_readdata(read_address_i : t_avalon_mm_rst_controller_address) is
		begin
			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				--  SimuCam Reser Control Register                  (32 bits):
				when (c_RSTC_SIMUCAM_RESET_MM_REG_ADDRESS + c_RSTC_AVALON_MM_REG_OFFSET) =>
					--    31-31 : SimuCam Reset control bit              [R/W]
					avalon_mm_spacewire_o.readdata(31)           <= rst_controller_write_registers_i.simucam_reset.simucam_reset;
					--    30- 0 : SimuCam Reset Timer value              [R/W]
					avalon_mm_spacewire_o.readdata(30 downto 0)  <= rst_controller_write_registers_i.simucam_reset.simucam_timer;

				--  Device Reset Control Register                  (32 bits):
				when (c_RSTC_DEVICE_RESET_MM_REG_ADDRESS + c_RSTC_AVALON_MM_REG_OFFSET) =>
					--    31-12 : Reserved                               [-/-]
					avalon_mm_spacewire_o.readdata(31 downto 12) <= (others => '0');
					--    11-11 : FTDI Module Reset control bit          [R/W]
					avalon_mm_spacewire_o.readdata(11)           <= rst_controller_write_registers_i.device_reset.ftdi_reset;
					--    10-10 : Sync Module Reset control bit          [R/W]
					avalon_mm_spacewire_o.readdata(10)           <= rst_controller_write_registers_i.device_reset.sync_reset;
					--     9- 9 : RS232 Module Reset control bit         [R/W]
					avalon_mm_spacewire_o.readdata(9)            <= rst_controller_write_registers_i.device_reset.rs232_reset;
					--     8- 8 : SD Card Module Reset control bit       [R/W]
					avalon_mm_spacewire_o.readdata(8)            <= rst_controller_write_registers_i.device_reset.sd_card_reset;
					--     7- 7 : Comm Module CH8 Reset control bit      [R/W]
					avalon_mm_spacewire_o.readdata(7)            <= rst_controller_write_registers_i.device_reset.comm_ch8_reset;
					--     6- 6 : Comm Module CH7 Reset control bit      [R/W]
					avalon_mm_spacewire_o.readdata(6)            <= rst_controller_write_registers_i.device_reset.comm_ch7_reset;
					--     5- 5 : Comm Module CH6 Reset control bit      [R/W]
					avalon_mm_spacewire_o.readdata(5)            <= rst_controller_write_registers_i.device_reset.comm_ch6_reset;
					--     4- 4 : Comm Module CH5 Reset control bit      [R/W]
					avalon_mm_spacewire_o.readdata(4)            <= rst_controller_write_registers_i.device_reset.comm_ch5_reset;
					--     3- 3 : Comm Module CH4 Reset control bit      [R/W]
					avalon_mm_spacewire_o.readdata(3)            <= rst_controller_write_registers_i.device_reset.comm_ch4_reset;
					--     2- 2 : Comm Module CH3 Reset control bit      [R/W]
					avalon_mm_spacewire_o.readdata(2)            <= rst_controller_write_registers_i.device_reset.comm_ch3_reset;
					--     1- 1 : Comm Module CH2 Reset control bit      [R/W]
					avalon_mm_spacewire_o.readdata(1)            <= rst_controller_write_registers_i.device_reset.comm_ch2_reset;
					--     0- 0 : Comm Module CH1 Reset control bit      [R/W]
					avalon_mm_spacewire_o.readdata(0)            <= rst_controller_write_registers_i.device_reset.comm_ch1_reset;

				when others =>
					avalon_mm_spacewire_o.readdata <= (others => '0');
			end case;
		end procedure p_readdata;

		variable v_read_address : t_avalon_mm_rst_controller_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			v_read_address                    := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_spacewire_o.readdata    <= (others => '0');
			avalon_mm_spacewire_o.waitrequest <= '1';
			p_flags_hold;
			if (avalon_mm_spacewire_i.read = '1') then
				avalon_mm_spacewire_o.waitrequest <= '0';
				v_read_address                    := to_integer(unsigned(avalon_mm_spacewire_i.address));
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_avalon_mm_rst_controller_read;

end architecture rtl;
