library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftdi_imgt_buffer_ent is
	port(
		clk_i                : in  std_logic;
		rst_i                : in  std_logic;
		imgt_buffer_wrdata_i : in  std_logic_vector(31 downto 0);
		imgt_buffer_rdreq_i  : in  std_logic;
		imgt_buffer_sclr_i   : in  std_logic;
		imgt_buffer_wrreq_i  : in  std_logic;
		imgt_buffer_empty_o  : out std_logic;
		imgt_buffer_full_o   : out std_logic;
		imgt_buffer_rddata_o : out std_logic_vector(31 downto 0);
		imgt_buffer_usedw_o  : out std_logic_vector(8 downto 0)
	);
end entity ftdi_imgt_buffer_ent;

architecture RTL of ftdi_imgt_buffer_ent is

	-- FTDI Imagette SC FIFO Signals
	signal s_imgt_fifo_full  : std_logic;
	signal s_imgt_fifo_usedw : std_logic_vector(7 downto 0);

begin

	-- Entities Instantiations --

	-- FTDI Imagette SC FIFO Instantiation
	ftdi_imgt_buffer_sc_fifo_inst : entity work.ftdi_imgt_buffer_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => imgt_buffer_wrdata_i,
			rdreq => imgt_buffer_rdreq_i,
			sclr  => imgt_buffer_sclr_i,
			wrreq => imgt_buffer_wrreq_i,
			empty => imgt_buffer_empty_o,
			full  => s_imgt_fifo_full,
			q     => imgt_buffer_rddata_o,
			usedw => s_imgt_fifo_usedw
		);

	-- Signals Assignments --

	-- Outputs Generation --

	-- FTDI Imagette SC FIFO Outputs
	imgt_buffer_full_o              <= s_imgt_fifo_usedw(7);
	imgt_buffer_usedw_o(8)          <= '0';
	imgt_buffer_usedw_o(7)          <= s_imgt_fifo_full;
	imgt_buffer_usedw_o(6 downto 0) <= s_imgt_fifo_usedw(6 downto 0);

end architecture RTL;
