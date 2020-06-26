library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package fdrm_tb_avs_pkg is

	constant c_FDRM_TB_AVS_AVALON_MM_ADRESS_SIZE : natural := 64;
	constant c_FDRM_TB_AVS_AVALON_MM_DATA_SIZE   : natural := 8;
	constant c_FDRM_TB_AVS_AVALON_MM_SYMBOL_SIZE : natural := 8;

	subtype t_fdrm_tb_avs_avalon_mm_address is unsigned((c_FDRM_TB_AVS_AVALON_MM_ADRESS_SIZE - 1) downto 0);

	type t_fdrm_tb_avs_avalon_mm_read_in is record
		address    : std_logic_vector((c_FDRM_TB_AVS_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		read       : std_logic;
		byteenable : std_logic_vector(((c_FDRM_TB_AVS_AVALON_MM_DATA_SIZE / c_FDRM_TB_AVS_AVALON_MM_SYMBOL_SIZE) - 1) downto 0);
	end record t_fdrm_tb_avs_avalon_mm_read_in;

	type t_fdrm_tb_avs_avalon_mm_read_out is record
		readdata    : std_logic_vector((c_FDRM_TB_AVS_AVALON_MM_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_fdrm_tb_avs_avalon_mm_read_out;

	type t_fdrm_tb_avs_avalon_mm_write_in is record
		address    : std_logic_vector((c_FDRM_TB_AVS_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		write      : std_logic;
		writedata  : std_logic_vector((c_FDRM_TB_AVS_AVALON_MM_DATA_SIZE - 1) downto 0);
		byteenable : std_logic_vector(((c_FDRM_TB_AVS_AVALON_MM_DATA_SIZE / c_FDRM_TB_AVS_AVALON_MM_SYMBOL_SIZE) - 1) downto 0);
	end record t_fdrm_tb_avs_avalon_mm_write_in;

	type t_fdrm_tb_avs_avalon_mm_write_out is record
		waitrequest : std_logic;
	end record t_fdrm_tb_avs_avalon_mm_write_out;

end package fdrm_tb_avs_pkg;
