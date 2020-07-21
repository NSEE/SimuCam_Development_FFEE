library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.nrme_avalon_mm_rmap_nfee_pkg.all;

entity fee_7_rmap_stimuli is
	generic(
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 64
	);
	port(
		clk_i                       : in  std_logic;
		rst_i                       : in  std_logic;
		fee_7_rmap_wr_waitrequest_i : in  std_logic;
		fee_7_rmap_readdata_i       : in  std_logic_vector((g_DATA_WIDTH - 1) downto 0);
		fee_7_rmap_rd_waitrequest_i : in  std_logic;
		fee_7_rmap_wr_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0);
		fee_7_rmap_write_o          : out std_logic;
		fee_7_rmap_writedata_o      : out std_logic_vector((g_DATA_WIDTH - 1) downto 0);
		fee_7_rmap_rd_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0);
		fee_7_rmap_read_o           : out std_logic
	);
end entity fee_7_rmap_stimuli;

architecture RTL of fee_7_rmap_stimuli is

	signal s_wr_counter : natural := 0;
	signal s_rd_counter : natural := 0;

begin

	p_fee_7_rmap_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			fee_7_rmap_wr_address_o <= (others => '0');
			fee_7_rmap_write_o      <= '0';
			fee_7_rmap_writedata_o  <= (others => '0');
			fee_7_rmap_rd_address_o <= (others => '0');
			fee_7_rmap_read_o       <= '0';
			s_wr_counter            <= 0;
			s_rd_counter            <= 0;

		elsif rising_edge(clk_i) then

			fee_7_rmap_wr_address_o <= (others => '0');
			fee_7_rmap_write_o      <= '0';
			fee_7_rmap_writedata_o  <= (others => '0');
			fee_7_rmap_rd_address_o <= (others => '0');
			fee_7_rmap_read_o       <= '0';
			s_wr_counter            <= s_wr_counter + 1;
			s_rd_counter            <= s_rd_counter + 1;

			case s_wr_counter is

				when (500) =>
					-- rmap write
					if (fee_7_rmap_wr_waitrequest_i = '1') then
						fee_7_rmap_wr_address_o <= std_logic_vector(to_unsigned(16#0000013D#, g_ADDRESS_WIDTH));
						fee_7_rmap_write_o      <= '1';
						fee_7_rmap_writedata_o  <= x"B3";
						s_wr_counter            <= s_wr_counter;
					end if;

				when others =>
					null;

			end case;

			case s_rd_counter is

				when (1000) =>
					-- rmap read
					if (fee_7_rmap_rd_waitrequest_i = '1') then
						fee_7_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#0000013D#, g_ADDRESS_WIDTH));
						fee_7_rmap_read_o       <= '1';
						s_rd_counter            <= s_rd_counter;
					end if;
					
				when (1010) =>
					-- rmap read
					if (fee_7_rmap_rd_waitrequest_i = '1') then
						fee_7_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#0000013D#, g_ADDRESS_WIDTH));
						fee_7_rmap_read_o       <= '1';
						s_rd_counter            <= s_rd_counter;
					end if;

				when (1020) =>
					-- rmap read
					if (fee_7_rmap_rd_waitrequest_i = '1') then
						fee_7_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#0000013D#, g_ADDRESS_WIDTH));
						fee_7_rmap_read_o       <= '1';
						s_rd_counter            <= s_rd_counter;
					end if;
					
				when (1030) =>
					-- rmap read
					if (fee_7_rmap_rd_waitrequest_i = '1') then
						fee_7_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#0000013D#, g_ADDRESS_WIDTH));
						fee_7_rmap_read_o       <= '1';
						s_rd_counter            <= s_rd_counter;
					end if;
					
				when (1040) =>
					-- rmap read
					if (fee_7_rmap_rd_waitrequest_i = '1') then
						fee_7_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#0000013D#, g_ADDRESS_WIDTH));
						fee_7_rmap_read_o       <= '1';
						s_rd_counter            <= s_rd_counter;
					end if;
					
				when (1050) =>
					-- rmap read
					if (fee_7_rmap_rd_waitrequest_i = '1') then
						fee_7_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#0000013D#, g_ADDRESS_WIDTH));
						fee_7_rmap_read_o       <= '1';
						s_rd_counter            <= s_rd_counter;
					end if;
					
				when (1060) =>
					-- rmap read
					if (fee_7_rmap_rd_waitrequest_i = '1') then
						fee_7_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#0000013D#, g_ADDRESS_WIDTH));
						fee_7_rmap_read_o       <= '1';
						s_rd_counter            <= s_rd_counter;
					end if;
					
				when (1070) =>
					-- rmap read
					if (fee_7_rmap_rd_waitrequest_i = '1') then
						fee_7_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#0000013D#, g_ADDRESS_WIDTH));
						fee_7_rmap_read_o       <= '1';
						s_rd_counter            <= s_rd_counter;
					end if;
					
				when (1080) =>
					-- rmap read
					if (fee_7_rmap_rd_waitrequest_i = '1') then
						fee_7_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#0000013D#, g_ADDRESS_WIDTH));
						fee_7_rmap_read_o       <= '1';
						s_rd_counter            <= s_rd_counter;
					end if;
					
				when (1090) =>
					-- rmap read
					if (fee_7_rmap_rd_waitrequest_i = '1') then
						fee_7_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#0000013D#, g_ADDRESS_WIDTH));
						fee_7_rmap_read_o       <= '1';
						s_rd_counter            <= s_rd_counter;
					end if;
					
				when (1100) =>
					-- rmap read
					if (fee_7_rmap_rd_waitrequest_i = '1') then
						fee_7_rmap_rd_address_o <= std_logic_vector(to_unsigned(16#0000013D#, g_ADDRESS_WIDTH));
						fee_7_rmap_read_o       <= '1';
						s_rd_counter            <= s_rd_counter;
					end if;
				when others =>
					null;

			end case;

		end if;
	end process p_fee_7_rmap_stimuli;

end architecture RTL;
