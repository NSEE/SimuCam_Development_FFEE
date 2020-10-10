library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package rmap_tb_stimulli_rly_pkg is

	-- RMAP Replies constants, subtypes and types --

	-- RMAP Replies timeout constants
	constant c_RMAP_RLY_TIMEOUT : natural := 50;

	-- RMAP Replies invalid data constants
	constant c_RMAP_RLY_INVALID_DATA : std_logic_vector(11 downto 0) := x"FFF";

	-- RMAP Replies length constants
	constant c_RMAP_RLY_NO_REPLY_LENGTH : natural := 2;
	constant c_RMAP_RLY_9_LENGTH        : natural := 9;
	constant c_RMAP_RLY_13_LENGTH       : natural := 13;
	constant c_RMAP_RLY_17_LENGTH       : natural := 17;
	constant c_RMAP_RLY_18_LENGTH       : natural := 18;
	constant c_RMAP_RLY_19_LENGTH       : natural := 19;
	constant c_RMAP_RLY_20_LENGTH       : natural := 20;
	constant c_RMAP_RLY_22_LENGTH       : natural := 22;
	constant c_RMAP_RLY_58_LENGTH       : natural := 58;
	constant c_RMAP_RLY_270_LENGTH      : natural := 270;
	constant c_RMAP_RLY_274_LENGTH      : natural := 274;
	constant c_RMAP_RLY_4110_LENGTH     : natural := 4110;
	constant c_RMAP_RLY_4114_LENGTH     : natural := 4114;
	constant c_RMAP_RLY_4400_LENGTH     : natural := 4400;
	constant c_RMAP_RLY_MAX_LENGTH      : natural := 4500;

	-- RMAP Replies failures constants
	constant c_RMAP_RLY_NO_REPLY_FAILURE : std_logic_vector((c_RMAP_RLY_NO_REPLY_LENGTH - 1) downto 0) := (others => '0');
	constant c_RMAP_RLY_9_FAILURE        : std_logic_vector((c_RMAP_RLY_9_LENGTH - 1) downto 0)        := (others => '0');
	constant c_RMAP_RLY_13_FAILURE       : std_logic_vector((c_RMAP_RLY_13_LENGTH - 1) downto 0)       := (others => '0');
	constant c_RMAP_RLY_17_FAILURE       : std_logic_vector((c_RMAP_RLY_17_LENGTH - 1) downto 0)       := (others => '0');
	constant c_RMAP_RLY_18_FAILURE       : std_logic_vector((c_RMAP_RLY_18_LENGTH - 1) downto 0)       := (others => '0');
	constant c_RMAP_RLY_19_FAILURE       : std_logic_vector((c_RMAP_RLY_19_LENGTH - 1) downto 0)       := (others => '0');
	constant c_RMAP_RLY_20_FAILURE       : std_logic_vector((c_RMAP_RLY_20_LENGTH - 1) downto 0)       := (others => '0');
	constant c_RMAP_RLY_22_FAILURE       : std_logic_vector((c_RMAP_RLY_22_LENGTH - 1) downto 0)       := (others => '0');
	constant c_RMAP_RLY_58_FAILURE       : std_logic_vector((c_RMAP_RLY_58_LENGTH - 1) downto 0)       := (others => '0');
	constant c_RMAP_RLY_270_FAILURE      : std_logic_vector((c_RMAP_RLY_270_LENGTH - 1) downto 0)      := (others => '0');
	constant c_RMAP_RLY_274_FAILURE      : std_logic_vector((c_RMAP_RLY_274_LENGTH - 1) downto 0)      := (others => '0');
	constant c_RMAP_RLY_4110_FAILURE     : std_logic_vector((c_RMAP_RLY_4110_LENGTH - 1) downto 0)     := (others => '0');
	constant c_RMAP_RLY_4114_FAILURE     : std_logic_vector((c_RMAP_RLY_4114_LENGTH - 1) downto 0)     := (others => '0');
	constant c_RMAP_RLY_4400_FAILURE     : std_logic_vector((c_RMAP_RLY_4400_LENGTH - 1) downto 0)     := (others => '0');
	constant c_RMAP_RLY_MAX_FAILURE      : std_logic_vector((c_RMAP_RLY_MAX_LENGTH - 1) downto 0)      := (others => '0');

	-- RMAP Replies success constants
	constant c_RMAP_RLY_NO_REPLY_SUCCESS : std_logic_vector((c_RMAP_RLY_NO_REPLY_LENGTH - 1) downto 0) := (others => '1');
	constant c_RMAP_RLY_9_SUCCESS        : std_logic_vector((c_RMAP_RLY_9_LENGTH - 1) downto 0)        := (others => '1');
	constant c_RMAP_RLY_13_SUCCESS       : std_logic_vector((c_RMAP_RLY_13_LENGTH - 1) downto 0)       := (others => '1');
	constant c_RMAP_RLY_17_SUCCESS       : std_logic_vector((c_RMAP_RLY_17_LENGTH - 1) downto 0)       := (others => '1');
	constant c_RMAP_RLY_18_SUCCESS       : std_logic_vector((c_RMAP_RLY_18_LENGTH - 1) downto 0)       := (others => '1');
	constant c_RMAP_RLY_19_SUCCESS       : std_logic_vector((c_RMAP_RLY_19_LENGTH - 1) downto 0)       := (others => '1');
	constant c_RMAP_RLY_20_SUCCESS       : std_logic_vector((c_RMAP_RLY_20_LENGTH - 1) downto 0)       := (others => '1');
	constant c_RMAP_RLY_22_SUCCESS       : std_logic_vector((c_RMAP_RLY_22_LENGTH - 1) downto 0)       := (others => '1');
	constant c_RMAP_RLY_58_SUCCESS       : std_logic_vector((c_RMAP_RLY_58_LENGTH - 1) downto 0)       := (others => '1');
	constant c_RMAP_RLY_270_SUCCESS      : std_logic_vector((c_RMAP_RLY_270_LENGTH - 1) downto 0)      := (others => '1');
	constant c_RMAP_RLY_274_SUCCESS      : std_logic_vector((c_RMAP_RLY_274_LENGTH - 1) downto 0)      := (others => '1');
	constant c_RMAP_RLY_4110_SUCCESS     : std_logic_vector((c_RMAP_RLY_4110_LENGTH - 1) downto 0)     := (others => '1');
	constant c_RMAP_RLY_4114_SUCCESS     : std_logic_vector((c_RMAP_RLY_4114_LENGTH - 1) downto 0)     := (others => '1');
	constant c_RMAP_RLY_4400_SUCCESS     : std_logic_vector((c_RMAP_RLY_4400_LENGTH - 1) downto 0)     := (others => '1');
	constant c_RMAP_RLY_MAX_SUCCESS      : std_logic_vector((c_RMAP_RLY_MAX_LENGTH - 1) downto 0)      := (others => '1');

	-- RMAP Replies timeout counter subtypes
	subtype t_rmap_rly_timeout_cnt is natural range 0 to (c_RMAP_RLY_TIMEOUT - 1);

	-- RMAP Replies counter subtypes
	subtype t_rmap_rly_no_reply_cnt is natural range 0 to (c_RMAP_RLY_NO_REPLY_LENGTH - 1);
	subtype t_rmap_rly_9_cnt is natural range 0 to (c_RMAP_RLY_9_LENGTH - 1);
	subtype t_rmap_rly_13_cnt is natural range 0 to (c_RMAP_RLY_13_LENGTH - 1);
	subtype t_rmap_rly_17_cnt is natural range 0 to (c_RMAP_RLY_17_LENGTH - 1);
	subtype t_rmap_rly_18_cnt is natural range 0 to (c_RMAP_RLY_18_LENGTH - 1);
	subtype t_rmap_rly_19_cnt is natural range 0 to (c_RMAP_RLY_19_LENGTH - 1);
	subtype t_rmap_rly_20_cnt is natural range 0 to (c_RMAP_RLY_20_LENGTH - 1);
	subtype t_rmap_rly_22_cnt is natural range 0 to (c_RMAP_RLY_22_LENGTH - 1);
	subtype t_rmap_rly_58_cnt is natural range 0 to (c_RMAP_RLY_58_LENGTH - 1);
	subtype t_rmap_rly_270_cnt is natural range 0 to (c_RMAP_RLY_270_LENGTH - 1);
	subtype t_rmap_rly_274_cnt is natural range 0 to (c_RMAP_RLY_274_LENGTH - 1);
	subtype t_rmap_rly_4110_cnt is natural range 0 to (c_RMAP_RLY_4110_LENGTH - 1);
	subtype t_rmap_rly_4114_cnt is natural range 0 to (c_RMAP_RLY_4114_LENGTH - 1);
	subtype t_rmap_rly_4400_cnt is natural range 0 to (c_RMAP_RLY_4400_LENGTH - 1);
	subtype t_rmap_rly_max_cnt is natural range 0 to (c_RMAP_RLY_MAX_LENGTH - 1);

	-- RMAP Replies data types
	type t_rmap_rly_no_reply is array (0 to (c_RMAP_RLY_NO_REPLY_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_9_data is array (0 to (c_RMAP_RLY_9_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_13_data is array (0 to (c_RMAP_RLY_13_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_17_data is array (0 to (c_RMAP_RLY_17_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_18_data is array (0 to (c_RMAP_RLY_18_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_19_data is array (0 to (c_RMAP_RLY_19_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_20_data is array (0 to (c_RMAP_RLY_20_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_22_data is array (0 to (c_RMAP_RLY_22_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_58_data is array (0 to (c_RMAP_RLY_58_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_270_data is array (0 to (c_RMAP_RLY_270_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_274_data is array (0 to (c_RMAP_RLY_274_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_4110_data is array (0 to (c_RMAP_RLY_4110_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_4114_data is array (0 to (c_RMAP_RLY_4114_LENGTH - 1)) of std_logic_vector(11 downto 0);
	type t_rmap_rly_4400_data is array (0 to (c_RMAP_RLY_4400_LENGTH - 1)) of std_logic_vector(11 downto 0);

	-- RMAP Replies test case constants --

	-- RMAP Replies test case times constants --	
	constant c_RMAP_RLY_TEST_CASE_01_01_TIME : natural := 150;
	constant c_RMAP_RLY_TEST_CASE_01_02_TIME : natural := 250;
	constant c_RMAP_RLY_TEST_CASE_01_03_TIME : natural := 350;
	constant c_RMAP_RLY_TEST_CASE_01_04_TIME : natural := 450;
	constant c_RMAP_RLY_TEST_CASE_01_05_TIME : natural := 550;
	constant c_RMAP_RLY_TEST_CASE_01_06_TIME : natural := 650;
	constant c_RMAP_RLY_TEST_CASE_01_07_TIME : natural := 750;
	constant c_RMAP_RLY_TEST_CASE_02_01_TIME : natural := 850;
	constant c_RMAP_RLY_TEST_CASE_02_02_TIME : natural := 950;
	constant c_RMAP_RLY_TEST_CASE_02_03_TIME : natural := 1050;
	constant c_RMAP_RLY_TEST_CASE_02_04_TIME : natural := 1150;
	constant c_RMAP_RLY_TEST_CASE_03_01_TIME : natural := 1250;
	constant c_RMAP_RLY_TEST_CASE_03_02_TIME : natural := 1350;
	constant c_RMAP_RLY_TEST_CASE_03_03_TIME : natural := 1450;
	constant c_RMAP_RLY_TEST_CASE_04_01_TIME : natural := 1550;
	constant c_RMAP_RLY_TEST_CASE_04_02_TIME : natural := 1650;
	constant c_RMAP_RLY_TEST_CASE_04_03_TIME : natural := 1750;
	constant c_RMAP_RLY_TEST_CASE_04_04_TIME : natural := 1850;
	constant c_RMAP_RLY_TEST_CASE_04_05_TIME : natural := 1950;
	constant c_RMAP_RLY_TEST_CASE_04_06_TIME : natural := 2050;
	constant c_RMAP_RLY_TEST_CASE_04_07_TIME : natural := 2150;
	constant c_RMAP_RLY_TEST_CASE_04_08_TIME : natural := 2250;
	constant c_RMAP_RLY_TEST_CASE_04_09_TIME : natural := 2350;
	constant c_RMAP_RLY_TEST_CASE_04_10_TIME : natural := 2450;
	constant c_RMAP_RLY_TEST_CASE_04_11_TIME : natural := 2550;
	constant c_RMAP_RLY_TEST_CASE_04_12_TIME : natural := 2650;
	constant c_RMAP_RLY_TEST_CASE_05_01_TIME : natural := 2750;
	constant c_RMAP_RLY_TEST_CASE_05_02_TIME : natural := 2850;
	constant c_RMAP_RLY_TEST_CASE_06_01_TIME : natural := 2950;
	constant c_RMAP_RLY_TEST_CASE_06_02_TIME : natural := 3050;
	constant c_RMAP_RLY_TEST_CASE_06_03_TIME : natural := 3150;
	constant c_RMAP_RLY_TEST_CASE_06_04_TIME : natural := 3250;
	constant c_RMAP_RLY_TEST_CASE_06_05_TIME : natural := 3350;
	constant c_RMAP_RLY_TEST_CASE_07_01_TIME : natural := 3450;
	constant c_RMAP_RLY_TEST_CASE_07_02_TIME : natural := 3550;
	constant c_RMAP_RLY_TEST_CASE_07_03_TIME : natural := 3650;
	constant c_RMAP_RLY_TEST_CASE_07_04_TIME : natural := 3750;
	constant c_RMAP_RLY_TEST_CASE_07_05_TIME : natural := 3850;
	constant c_RMAP_RLY_TEST_CASE_07_06_TIME : natural := 3950;
	constant c_RMAP_RLY_TEST_CASE_07_07_TIME : natural := 4050;
	constant c_RMAP_RLY_TEST_CASE_07_08_TIME : natural := 4150;
	constant c_RMAP_RLY_TEST_CASE_07_09_TIME : natural := 4250;
	constant c_RMAP_RLY_TEST_CASE_07_10_TIME : natural := 4350;
	constant c_RMAP_RLY_TEST_CASE_08_01_TIME : natural := 4450;
	constant c_RMAP_RLY_TEST_CASE_08_02_TIME : natural := 4550;
	constant c_RMAP_RLY_TEST_CASE_08_03_TIME : natural := 4650;
	constant c_RMAP_RLY_TEST_CASE_08_04_TIME : natural := 4750;
	constant c_RMAP_RLY_TEST_CASE_08_05_TIME : natural := 4850;
	constant c_RMAP_RLY_TEST_CASE_08_06_TIME : natural := 4950;
	constant c_RMAP_RLY_TEST_CASE_08_07_TIME : natural := 5050;
	constant c_RMAP_RLY_TEST_CASE_08_08_TIME : natural := 5150;
	constant c_RMAP_RLY_TEST_CASE_09_01_TIME : natural := 5250;
	constant c_RMAP_RLY_TEST_CASE_09_02_TIME : natural := 5350;
	constant c_RMAP_RLY_TEST_CASE_09_03_TIME : natural := 5450;
	constant c_RMAP_RLY_TEST_CASE_09_04_TIME : natural := 5550;
	constant c_RMAP_RLY_TEST_CASE_09_05_TIME : natural := 5650;
	constant c_RMAP_RLY_TEST_CASE_09_06_TIME : natural := 5750;
	constant c_RMAP_RLY_TEST_CASE_09_07_TIME : natural := 5850;
	constant c_RMAP_RLY_TEST_CASE_09_08_TIME : natural := 5950;
	constant c_RMAP_RLY_TEST_CASE_09_09_TIME : natural := 6050;
	constant c_RMAP_RLY_TEST_CASE_09_10_TIME : natural := 6150;
	constant c_RMAP_RLY_TEST_CASE_10_01_TIME : natural := 6250;
	constant c_RMAP_RLY_TEST_CASE_10_02_TIME : natural := 6350;
	constant c_RMAP_RLY_TEST_CASE_10_03_TIME : natural := 6450;
	constant c_RMAP_RLY_TEST_CASE_11_01_TIME : natural := 6550;
	constant c_RMAP_RLY_TEST_CASE_11_02_TIME : natural := 6650;
	constant c_RMAP_RLY_TEST_CASE_11_03_TIME : natural := 6750;
	constant c_RMAP_RLY_TEST_CASE_11_04_TIME : natural := 6850;
	constant c_RMAP_RLY_TEST_CASE_12_01_TIME : natural := 6950;
	constant c_RMAP_RLY_TEST_CASE_12_02_TIME : natural := 7050;
	constant c_RMAP_RLY_TEST_CASE_12_03_TIME : natural := 7150;
	constant c_RMAP_RLY_TEST_CASE_12_04_TIME : natural := 7250;
	constant c_RMAP_RLY_TEST_CASE_12_05_TIME : natural := 7350;
	constant c_RMAP_RLY_TEST_CASE_12_06_TIME : natural := 7450;
	constant c_RMAP_RLY_TEST_CASE_12_07_TIME : natural := 7550;
	constant c_RMAP_RLY_TEST_CASE_13_01_TIME : natural := 7650;
	constant c_RMAP_RLY_TEST_CASE_13_02_TIME : natural := 7750;
	constant c_RMAP_RLY_TEST_CASE_13_03_TIME : natural := 7850;
	constant c_RMAP_RLY_TEST_CASE_13_04_TIME : natural := 7950;
	constant c_RMAP_RLY_TEST_CASE_13_05_TIME : natural := 8050;
	constant c_RMAP_RLY_TEST_CASE_13_06_TIME : natural := 8150;
	constant c_RMAP_RLY_TEST_CASE_14_01_TIME : natural := 8250;
	constant c_RMAP_RLY_TEST_CASE_14_02_TIME : natural := 8350;
	constant c_RMAP_RLY_TEST_CASE_14_03_TIME : natural := 8450;
	constant c_RMAP_RLY_TEST_CASE_14_04_TIME : natural := 8550;
	constant c_RMAP_RLY_TEST_CASE_14_05_TIME : natural := 8650;
	constant c_RMAP_RLY_TEST_CASE_14_06_TIME : natural := 8750;
	constant c_RMAP_RLY_TEST_CASE_14_07_TIME : natural := 8850;
	constant c_RMAP_RLY_TEST_CASE_14_08_TIME : natural := 8950;
	constant c_RMAP_RLY_TEST_CASE_14_09_TIME : natural := 9050;
	constant c_RMAP_RLY_TEST_CASE_14_10_TIME : natural := 9150;
	constant c_RMAP_RLY_TEST_CASE_14_11_TIME : natural := 9250;
	constant c_RMAP_RLY_TEST_CASE_14_12_TIME : natural := 9350;
	constant c_RMAP_RLY_TEST_CASE_14_13_TIME : natural := 9450;
	constant c_RMAP_RLY_TEST_CASE_14_14_TIME : natural := 9550;
	constant c_RMAP_RLY_TEST_CASE_14_15_TIME : natural := 9650;
	constant c_RMAP_RLY_TEST_CASE_14_16_TIME : natural := 9750;
	constant c_RMAP_RLY_TEST_CASE_14_17_TIME : natural := 9850;
	constant c_RMAP_RLY_TEST_CASE_14_18_TIME : natural := 9950;
	constant c_RMAP_RLY_TEST_CASE_14_19_TIME : natural := 10050;
	constant c_RMAP_RLY_TEST_CASE_14_20_TIME : natural := 10150;
	constant c_RMAP_RLY_TEST_CASE_14_21_TIME : natural := 10250;
	constant c_RMAP_RLY_TEST_CASE_14_22_TIME : natural := 10350;
	constant c_RMAP_RLY_TEST_CASE_14_23_TIME : natural := 10450;
	constant c_RMAP_RLY_TEST_CASE_14_24_TIME : natural := 10550;
	constant c_RMAP_RLY_TEST_CASE_14_25_TIME : natural := 10650;
	constant c_RMAP_RLY_TEST_CASE_14_26_TIME : natural := 10750;
	constant c_RMAP_RLY_TEST_CASE_15_01_TIME : natural := 10850;
	constant c_RMAP_RLY_TEST_CASE_15_02_TIME : natural := 10950;
	constant c_RMAP_RLY_TEST_CASE_15_03_TIME : natural := 11050;
	constant c_RMAP_RLY_TEST_CASE_15_04_TIME : natural := 11150;
	constant c_RMAP_RLY_TEST_CASE_15_05_TIME : natural := 11250;
	constant c_RMAP_RLY_TEST_CASE_16_01_TIME : natural := 11350;
	constant c_RMAP_RLY_TEST_CASE_16_02_TIME : natural := 11450;
	constant c_RMAP_RLY_TEST_CASE_16_03_TIME : natural := 11550;
	constant c_RMAP_RLY_TEST_CASE_16_04_TIME : natural := 11650;
	constant c_RMAP_RLY_TEST_CASE_17_01_TIME : natural := 11750;
	constant c_RMAP_RLY_TEST_CASE_17_02_TIME : natural := 11850;
	constant c_RMAP_RLY_TEST_CASE_17_03_TIME : natural := 11950;
	constant c_RMAP_RLY_TEST_CASE_17_04_TIME : natural := 12050;
	constant c_RMAP_RLY_TEST_CASE_17_05_TIME : natural := 12150;
	constant c_RMAP_RLY_TEST_CASE_17_06_TIME : natural := 12250;
	constant c_RMAP_RLY_TEST_CASE_17_07_TIME : natural := 12350;
	constant c_RMAP_RLY_TEST_CASE_17_08_TIME : natural := 12450;
	constant c_RMAP_RLY_TEST_CASE_17_09_TIME : natural := 12550;
	constant c_RMAP_RLY_TEST_CASE_17_10_TIME : natural := 12650;
	constant c_RMAP_RLY_TEST_CASE_17_11_TIME : natural := 12750;
	constant c_RMAP_RLY_TEST_CASE_17_12_TIME : natural := 12850;
	constant c_RMAP_RLY_TEST_CASE_17_13_TIME : natural := 12950;
	constant c_RMAP_RLY_TEST_CASE_17_14_TIME : natural := 13050;
	constant c_RMAP_RLY_TEST_CASE_17_15_TIME : natural := 13150;
	constant c_RMAP_RLY_TEST_CASE_17_16_TIME : natural := 13250;
	constant c_RMAP_RLY_TEST_CASE_17_17_TIME : natural := 13350;
	constant c_RMAP_RLY_TEST_CASE_17_18_TIME : natural := 13450;
	constant c_RMAP_RLY_TEST_CASE_18_01_TIME : natural := 13550;
	constant c_RMAP_RLY_TEST_CASE_18_02_TIME : natural := 13650;
	constant c_RMAP_RLY_TEST_CASE_18_03_TIME : natural := 13750;
	constant c_RMAP_RLY_TEST_CASE_18_04_TIME : natural := 13850;
	constant c_RMAP_RLY_TEST_CASE_18_05_TIME : natural := 13950;
	constant c_RMAP_RLY_TEST_CASE_18_06_TIME : natural := 14050;
	constant c_RMAP_RLY_TEST_CASE_18_07_TIME : natural := 14150;
	constant c_RMAP_RLY_TEST_CASE_18_08_TIME : natural := 14250;
	constant c_RMAP_RLY_TEST_CASE_18_09_TIME : natural := 14350;
	constant c_RMAP_RLY_TEST_CASE_18_10_TIME : natural := 14450;
	constant c_RMAP_RLY_TEST_CASE_18_11_TIME : natural := 14550;
	constant c_RMAP_RLY_TEST_CASE_18_12_TIME : natural := 14650;
	constant c_RMAP_RLY_TEST_CASE_18_13_TIME : natural := 14750;
	constant c_RMAP_RLY_TEST_CASE_18_14_TIME : natural := 14850;
	constant c_RMAP_RLY_TEST_CASE_18_15_TIME : natural := 14950;
	constant c_RMAP_RLY_TEST_CASE_18_16_TIME : natural := 15050;
	constant c_RMAP_RLY_TEST_CASE_18_17_TIME : natural := 15150;
	constant c_RMAP_RLY_TEST_CASE_18_18_TIME : natural := 15250;
	constant c_RMAP_RLY_TEST_CASE_19_01_TIME : natural := 15350;
	constant c_RMAP_RLY_TEST_CASE_19_02_TIME : natural := 15450;
	constant c_RMAP_RLY_TEST_CASE_19_03_TIME : natural := 15550;
	constant c_RMAP_RLY_TEST_CASE_19_04_TIME : natural := 15650;
	constant c_RMAP_RLY_TEST_CASE_19_05_TIME : natural := 15750;
	constant c_RMAP_RLY_TEST_CASE_19_06_TIME : natural := 15850;
	constant c_RMAP_RLY_TEST_CASE_19_07_TIME : natural := 15950;
	constant c_RMAP_RLY_TEST_CASE_19_08_TIME : natural := 16050;
	constant c_RMAP_RLY_TEST_CASE_19_09_TIME : natural := 16150;
	constant c_RMAP_RLY_TEST_CASE_19_10_TIME : natural := 16250;
	constant c_RMAP_RLY_TEST_CASE_19_11_TIME : natural := 16350;
	constant c_RMAP_RLY_TEST_CASE_19_12_TIME : natural := 16450;
	constant c_RMAP_RLY_TEST_CASE_19_13_TIME : natural := 16550;
	constant c_RMAP_RLY_TEST_CASE_19_14_TIME : natural := 16650;
	constant c_RMAP_RLY_TEST_CASE_19_15_TIME : natural := 16750;
	constant c_RMAP_RLY_TEST_CASE_19_16_TIME : natural := 16850;
	constant c_RMAP_RLY_TEST_CASE_19_17_TIME : natural := 16950;
	constant c_RMAP_RLY_TEST_CASE_19_18_TIME : natural := 17050;
	constant c_RMAP_RLY_TEST_CASE_20_01_TIME : natural := 17150;
	constant c_RMAP_RLY_TEST_CASE_20_02_TIME : natural := 17250;
	constant c_RMAP_RLY_TEST_CASE_20_03_TIME : natural := 17350;
	constant c_RMAP_RLY_TEST_CASE_20_04_TIME : natural := 17450;
	constant c_RMAP_RLY_TEST_CASE_20_05_TIME : natural := 17550;
	constant c_RMAP_RLY_TEST_CASE_20_06_TIME : natural := 17650;
	constant c_RMAP_RLY_TEST_CASE_20_07_TIME : natural := 17750;
	constant c_RMAP_RLY_TEST_CASE_20_08_TIME : natural := 17850;
	constant c_RMAP_RLY_TEST_CASE_20_09_TIME : natural := 17950;
	constant c_RMAP_RLY_TEST_CASE_20_10_TIME : natural := 18050;
	constant c_RMAP_RLY_TEST_CASE_20_11_TIME : natural := 18150;
	constant c_RMAP_RLY_TEST_CASE_20_12_TIME : natural := 18250;
	constant c_RMAP_RLY_TEST_CASE_20_13_TIME : natural := 18350;
	constant c_RMAP_RLY_TEST_CASE_20_14_TIME : natural := 18450;
	constant c_RMAP_RLY_TEST_CASE_20_15_TIME : natural := 18550;
	constant c_RMAP_RLY_TEST_CASE_20_16_TIME : natural := 18650;
	constant c_RMAP_RLY_TEST_CASE_20_17_TIME : natural := 18750;
	constant c_RMAP_RLY_TEST_CASE_20_18_TIME : natural := 18850;

	-- RMAP Replies test case data constants

	-- Test Case 1.1 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Correct Protocol ID = 0x01 RMAP Protocol 
	constant c_RMAP_RLY_TEST_CASE_01_01_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"001", x"000", x"000", x"000", x"004", x"036", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 1.2 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Wrong protocol ID = 0x02 CCSDS Packet Encapsulation Protocol 
	constant c_RMAP_RLY_TEST_CASE_01_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 1.3 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Wrong protocol ID = 0x00 Extended Protocol Identifier 
	constant c_RMAP_RLY_TEST_CASE_01_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 1.4 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Wrong protocol ID = 0x03 
	constant c_RMAP_RLY_TEST_CASE_01_04_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 1.5 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Wrong protocol ID = 0x11 
	constant c_RMAP_RLY_TEST_CASE_01_05_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 1.6 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Wrong protocol ID = 0xEE GOES-R Reliable Data Delivery Protocol 
	constant c_RMAP_RLY_TEST_CASE_01_06_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 1.7 (PLATO-DLR-PL-ICD-0007 4.5.1.9): Wrong protocol ID = 0xEF Serial Transfer Universal Protocol 
	constant c_RMAP_RLY_TEST_CASE_01_07_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 2.1 (PLATO-DLR-PL-ICD-0007 4.1): Correct reply address length
	constant c_RMAP_RLY_TEST_CASE_02_01_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"001", x"000", x"000", x"000", x"004", x"036", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 2.2 (PLATO-DLR-PL-ICD-0007 4.1): Reply Address length check = 1
	constant c_RMAP_RLY_TEST_CASE_02_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 2.3 (PLATO-DLR-PL-ICD-0007 4.1): Reply Address length check = 2
	constant c_RMAP_RLY_TEST_CASE_02_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 2.4 (PLATO-DLR-PL-ICD-0007 4.1): Reply Address length check = 3
	constant c_RMAP_RLY_TEST_CASE_02_04_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 3.1 (PLATO-DLR-PL-ICD-0007 4.5.1.5): Valid read packet with EOP
	constant c_RMAP_RLY_TEST_CASE_03_01_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"001", x"000", x"000", x"000", x"004", x"036", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 3.2 (PLATO-DLR-PL-ICD-0007 4.5.1.5): Invalid read packet with EEP
	constant c_RMAP_RLY_TEST_CASE_03_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 3.3 (PLATO-DLR-PL-ICD-0007 4.5.1.5): Invalid write packet with EEP
	constant c_RMAP_RLY_TEST_CASE_03_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 4.1 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Valid command code 0x4C
	constant c_RMAP_RLY_TEST_CASE_04_01_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"001", x"000", x"000", x"000", x"004", x"036", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 4.2 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Valid command code 0x6C
	constant c_RMAP_RLY_TEST_CASE_04_02_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"002", x"0B4", x"100");
	-- Test Case 4.3 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 0x6C to critical memory 0x00000014
	constant c_RMAP_RLY_TEST_CASE_04_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 4.4 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 0x6C to housekeeping memory 0x00001000
	constant c_RMAP_RLY_TEST_CASE_04_04_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 4.5 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Valid command code 0x7C
	constant c_RMAP_RLY_TEST_CASE_04_05_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"03C", x"000", x"051", x"000", x"005", x"059", x"100");
	-- Test Case 4.6 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 0x7C to housekeeping memory 0x00001000
	constant c_RMAP_RLY_TEST_CASE_04_06_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 4.7 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 0
	constant c_RMAP_RLY_TEST_CASE_04_07_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 4.8 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 1
	constant c_RMAP_RLY_TEST_CASE_04_08_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 4.9 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 4
	constant c_RMAP_RLY_TEST_CASE_04_09_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 4.10 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 5
	constant c_RMAP_RLY_TEST_CASE_04_10_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 4.11 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 6
	constant c_RMAP_RLY_TEST_CASE_04_11_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 4.12 (PLATO-DLR-PL-ICD-0007 4.5.1.10): Invalid command code 7
	constant c_RMAP_RLY_TEST_CASE_04_12_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 5.1 (PLATO-DLR-PL-ICD-0007 4.5.1.12): No data characters in read command
	constant c_RMAP_RLY_TEST_CASE_05_01_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"001", x"000", x"000", x"000", x"004", x"036", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 5.2 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Data characters in read command
	constant c_RMAP_RLY_TEST_CASE_05_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 6.1 (PLATO-DLR-PL-ICD-0007 4.5.1.7): Valid Key = 0xD1
	constant c_RMAP_RLY_TEST_CASE_06_01_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"001", x"000", x"000", x"000", x"004", x"036", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 6.2 (PLATO-DLR-PL-ICD-0007 4.5.1.7): Invalid Key = 0xD0
	constant c_RMAP_RLY_TEST_CASE_06_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 6.3 (PLATO-DLR-PL-ICD-0007 4.5.1.7): Invalid Key = 0xD2
	constant c_RMAP_RLY_TEST_CASE_06_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 6.4 (PLATO-DLR-PL-ICD-0007 4.5.1.7): Invalid Key = 0x00
	constant c_RMAP_RLY_TEST_CASE_06_04_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 6.5 (PLATO-DLR-PL-ICD-0007 4.5.1.7): Invalid Key = 0xFF
	constant c_RMAP_RLY_TEST_CASE_06_05_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 7.1 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Valid logical target address = 0x51
	constant c_RMAP_RLY_TEST_CASE_07_01_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"001", x"000", x"000", x"000", x"004", x"036", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 7.2 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x00
	constant c_RMAP_RLY_TEST_CASE_07_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 7.3 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0xFF
	constant c_RMAP_RLY_TEST_CASE_07_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 7.4 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x61
	constant c_RMAP_RLY_TEST_CASE_07_04_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 7.5 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x41
	constant c_RMAP_RLY_TEST_CASE_07_05_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 7.6 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0xFE
	constant c_RMAP_RLY_TEST_CASE_07_06_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 7.7 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x11
	constant c_RMAP_RLY_TEST_CASE_07_07_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 7.8 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x99
	constant c_RMAP_RLY_TEST_CASE_07_08_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 7.9 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x50
	constant c_RMAP_RLY_TEST_CASE_07_09_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 7.10 (PLATO-DLR-PL-ICD-0007 4.5.1.8): Invalid logical target address = 0x52
	constant c_RMAP_RLY_TEST_CASE_07_10_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 8.1 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from valid address
	constant c_RMAP_RLY_TEST_CASE_08_01_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"001", x"000", x"000", x"000", x"004", x"036", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 8.2 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused address 0x00090000
	constant c_RMAP_RLY_TEST_CASE_08_02_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"002", x"000", x"000", x"000", x"004", x"0CC", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 8.3 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused address 0x10000000
	constant c_RMAP_RLY_TEST_CASE_08_03_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"003", x"000", x"000", x"000", x"004", x"025", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 8.4 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused DEB address 0x00008000
	constant c_RMAP_RLY_TEST_CASE_08_04_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"004", x"000", x"000", x"000", x"004", x"0F9", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 8.5 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused AEB1 address 0x00018000
	constant c_RMAP_RLY_TEST_CASE_08_05_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"005", x"000", x"000", x"000", x"004", x"010", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 8.6 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused AEB2 address 0x00028000
	constant c_RMAP_RLY_TEST_CASE_08_06_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"006", x"000", x"000", x"000", x"004", x"0EA", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 8.7 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused AEB3 address 0x00048000
	constant c_RMAP_RLY_TEST_CASE_08_07_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"007", x"000", x"000", x"000", x"004", x"003", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 8.8 (PLATO-DLR-PL-ICD-0007 4.5.1.3): Read from unused AEB4 address 0x00088000
	constant c_RMAP_RLY_TEST_CASE_08_08_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"008", x"000", x"000", x"000", x"004", x"093", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 9.1 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Valid header
	constant c_RMAP_RLY_TEST_CASE_09_01_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"001", x"000", x"000", x"000", x"004", x"036", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 9.2 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Header CRC Error - overwrite header crc to 0x00
	constant c_RMAP_RLY_TEST_CASE_09_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 9.3 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Header CRC Error - overwrite header crc to 0xFF
	constant c_RMAP_RLY_TEST_CASE_09_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 9.4 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Incomplete header - remove protocol ID
	constant c_RMAP_RLY_TEST_CASE_09_04_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 9.5 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Incomplete header - remove key
	constant c_RMAP_RLY_TEST_CASE_09_05_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 9.6 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Incomplete header - remove first address byte (MSB)
	constant c_RMAP_RLY_TEST_CASE_09_06_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 9.7 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Incomplete header - remove all address bytes
	constant c_RMAP_RLY_TEST_CASE_09_07_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 9.8 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Invalid header - Unused packet type = 0
	constant c_RMAP_RLY_TEST_CASE_09_08_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 9.9 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Invalid header - Unused packet type = 2
	constant c_RMAP_RLY_TEST_CASE_09_09_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 9.10 (PLATO-DLR-PL-ICD-0007 4.5.1.4): Invalid header - Unused packet type = 3
	constant c_RMAP_RLY_TEST_CASE_09_10_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 10.1 (PLATO-DLR-PL-ICD-0007 4.5.1.6): Valid Data CRC
	constant c_RMAP_RLY_TEST_CASE_10_01_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"001", x"0C6", x"100");
	-- Test Case 10.2 (PLATO-DLR-PL-ICD-0007 4.5.1.6): Invalid Data CRC 0x00
	constant c_RMAP_RLY_TEST_CASE_10_02_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"004", x"051", x"000", x"002", x"0C7", x"100");
	-- Test Case 10.3 (PLATO-DLR-PL-ICD-0007 4.5.1.6): Invalid Data CRC 0xFF
	constant c_RMAP_RLY_TEST_CASE_10_03_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"004", x"051", x"000", x"003", x"056", x"100");
	-- Test Case 11.1 (PLATO-DLR-PL-ICD-0007 4.5.1.1): Write to valid address 0x00000130
	constant c_RMAP_RLY_TEST_CASE_11_01_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"001", x"0C6", x"100");
	-- Test Case 11.2 (PLATO-DLR-PL-ICD-0007 4.5.1.1): Write 8 Bytes across memory border starting at address 0x000000FC
	constant c_RMAP_RLY_TEST_CASE_11_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 11.3 (PLATO-DLR-PL-ICD-0007 4.5.1.1): Write 8 Bytes across memory border starting at address 0x00000FFC
	constant c_RMAP_RLY_TEST_CASE_11_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 11.4 (PLATO-DLR-PL-ICD-0007 4.5.1.1): Write 8 Bytes across memory border starting at address 0x00001FFC
	constant c_RMAP_RLY_TEST_CASE_11_04_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 12.1 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to valid address 0x00000130
	constant c_RMAP_RLY_TEST_CASE_12_01_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"001", x"0C6", x"100");
	-- Test Case 12.2 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to unused address 0x10000000
	constant c_RMAP_RLY_TEST_CASE_12_02_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"002", x"0B4", x"100");
	-- Test Case 12.3 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to unused DEB address 0x00008000
	constant c_RMAP_RLY_TEST_CASE_12_03_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"003", x"025", x"100");
	-- Test Case 12.4 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to unused AEB1 address 0x00018000
	constant c_RMAP_RLY_TEST_CASE_12_04_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"004", x"050", x"100");
	-- Test Case 12.5 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to unused AEB2 address 0x00028000
	constant c_RMAP_RLY_TEST_CASE_12_05_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"005", x"0C1", x"100");
	-- Test Case 12.6 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to unused AEB3 address 0x00048000
	constant c_RMAP_RLY_TEST_CASE_12_06_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"006", x"0B3", x"100");
	-- Test Case 12.7 (PLATO-DLR-PL-ICD-0007 4.5.1.2): Write to unused AEB4 address 0x00088000
	constant c_RMAP_RLY_TEST_CASE_12_07_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"007", x"022", x"100");
	-- Test Case 13.1 (PLATO-DLR-PL-ICD-0007 4.5.1.11): Correct amount of data
	constant c_RMAP_RLY_TEST_CASE_13_01_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"001", x"0C6", x"100");
	-- Test Case 13.2 (PLATO-DLR-PL-ICD-0007 4.5.1.11): Less data than expected (expected 8 Bytes; provided 4 Bytes)
	constant c_RMAP_RLY_TEST_CASE_13_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 13.3 (PLATO-DLR-PL-ICD-0007 4.5.1.11): Less data than expected (expected 260 Bytes; provided 4 Bytes)
	constant c_RMAP_RLY_TEST_CASE_13_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 13.4 (PLATO-DLR-PL-ICD-0007 4.5.1.11): Less data than expected (expected 16777212 Bytes; provided 4 Bytes)
	constant c_RMAP_RLY_TEST_CASE_13_04_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 13.5 (PLATO-DLR-PL-ICD-0007 4.5.1.11): More data than expected (expected 4 Bytes; provided 8 Bytes)
	constant c_RMAP_RLY_TEST_CASE_13_05_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 13.6 (PLATO-DLR-PL-ICD-0007 4.5.1.11): More data than expected (expected 0 Bytes; provided 4 Bytes)
	constant c_RMAP_RLY_TEST_CASE_13_06_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.1 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 bytes to DEB critical configuration are (0x00000014)
	constant c_RMAP_RLY_TEST_CASE_14_01_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"03C", x"000", x"051", x"000", x"001", x"05E", x"100");
	-- Test Case 14.2 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 8 Bytes to DEB critical configuration area (0x00000014)
	constant c_RMAP_RLY_TEST_CASE_14_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.3 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to DEB critical configuration area (0x00000014)
	constant c_RMAP_RLY_TEST_CASE_14_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.4 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 4 Bytes from DEB critical configuration area (0x00000014)
	constant c_RMAP_RLY_TEST_CASE_14_04_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"004", x"000", x"000", x"000", x"004", x"0F9", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 14.5 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 8 Bytes from DEB critical configuration area (0x00000014)
	constant c_RMAP_RLY_TEST_CASE_14_05_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.6 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 0 Bytes from DEB critical configuration area (0x00000014)
	constant c_RMAP_RLY_TEST_CASE_14_06_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.7 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 Bytes to DEB general configuration area (0x00000130)
	constant c_RMAP_RLY_TEST_CASE_14_07_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"007", x"022", x"100");
	-- Test Case 14.8 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 256 Bytes to DEB general configuration area (0x00000130)
	constant c_RMAP_RLY_TEST_CASE_14_08_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"008", x"059", x"100");
	-- Test Case 14.9 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 260 Bytes to DEB general configuration area (0x00000130)
	constant c_RMAP_RLY_TEST_CASE_14_09_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.10 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to DEB general configuration area (0x00000130)
	constant c_RMAP_RLY_TEST_CASE_14_10_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.11 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from DEB general configuration area (0x00000130)
	constant c_RMAP_RLY_TEST_CASE_14_11_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"00B", x"000", x"000", x"000", x"004", x"069", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 14.12 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from DEB general configuration area (0x00000130)
	constant c_RMAP_RLY_TEST_CASE_14_12_DATA : t_rmap_rly_270_data  := (x"050", x"001", x"00C", x"000", x"051", x"000", x"00C", x"000", x"000", x"001", x"000", x"0DF", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"087", x"100");
	-- Test Case 14.13 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from DEB general configuration area (0x00000130)
	constant c_RMAP_RLY_TEST_CASE_14_13_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.14 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from DEB general configuration area (0x00000130)
	constant c_RMAP_RLY_TEST_CASE_14_14_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.15 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from DEB housekeeping area (0x00001000)
	constant c_RMAP_RLY_TEST_CASE_14_15_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"00F", x"000", x"000", x"000", x"004", x"04F", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 14.16 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from DEB housekeeping area (0x00001000)
	constant c_RMAP_RLY_TEST_CASE_14_16_DATA : t_rmap_rly_270_data  := (x"050", x"001", x"00C", x"000", x"051", x"000", x"010", x"000", x"000", x"001", x"000", x"02D", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"087", x"100");
	-- Test Case 14.17 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from DEB housekeeping area (0x00001000)
	constant c_RMAP_RLY_TEST_CASE_14_17_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.18 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from DEB housekeeping area (0x00001000)
	constant c_RMAP_RLY_TEST_CASE_14_18_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.19 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 Bytes to DEB windowing area (0x00002000)
	constant c_RMAP_RLY_TEST_CASE_14_19_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"013", x"039", x"100");
	-- Test Case 14.20 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4096 Bytes to DEB windowing area (0x00002000)
	constant c_RMAP_RLY_TEST_CASE_14_20_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"014", x"04C", x"100");
	-- Test Case 14.21 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4100 Bytes to DEB windowing area (0x00002000)
	constant c_RMAP_RLY_TEST_CASE_14_21_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.22 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to DEB windowing area (0x00002000)
	constant c_RMAP_RLY_TEST_CASE_14_22_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.23 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from DEB windowing area (0x00002000)
	constant c_RMAP_RLY_TEST_CASE_14_23_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"017", x"000", x"000", x"000", x"004", x"09B", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 14.24 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4096 Bytes from DEB windowing area (0x00002000)
	constant c_RMAP_RLY_TEST_CASE_14_24_DATA : t_rmap_rly_4110_data := (x"050", x"001", x"00C", x"000", x"051", x"000", x"018", x"000", x"000", x"010", x"000", x"019", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"05F", x"100");
	-- Test Case 14.25 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4100 Bytes from DEB windowing area (0x00002000)
	constant c_RMAP_RLY_TEST_CASE_14_25_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 14.26 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from DEB windowing area (0x00002000)
	constant c_RMAP_RLY_TEST_CASE_14_26_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 15.1 (PLATO-DLR-PL-ICD-0007 4.5.1.13): Valid 4-Byte aligned data length field
	constant c_RMAP_RLY_TEST_CASE_15_01_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"001", x"000", x"000", x"000", x"004", x"036", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 15.2 (PLATO-DLR-PL-ICD-0007 4.5.1.13): Invalid aligned data length field: 3 Bytes
	constant c_RMAP_RLY_TEST_CASE_15_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 15.3 (PLATO-DLR-PL-ICD-0007 4.5.1.13): Invalid aligned data length field: 5 Bytes
	constant c_RMAP_RLY_TEST_CASE_15_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 15.4 (PLATO-DLR-PL-ICD-0007 4.5.1.13): Invalid aligned data length field: 6 Bytes
	constant c_RMAP_RLY_TEST_CASE_15_04_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 15.5 (PLATO-DLR-PL-ICD-0007 4.5.1.13): Invalid aligned data length field: 14 Bytes
	constant c_RMAP_RLY_TEST_CASE_15_05_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 16.1 (PLATO-DLR-PL-ICD-0007 4.1 / 4.5.1.10): Valid read with incrementing address
	constant c_RMAP_RLY_TEST_CASE_16_01_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"001", x"000", x"000", x"000", x"004", x"036", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 16.2 (PLATO-DLR-PL-ICD-0007 4.1 / 4.5.1.10): Invalid read without incrementing address
	constant c_RMAP_RLY_TEST_CASE_16_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 16.3 (PLATO-DLR-PL-ICD-0007 4.1 / 4.5.1.10): Invalid verified write without incrementing address
	constant c_RMAP_RLY_TEST_CASE_16_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 16.4 (PLATO-DLR-PL-ICD-0007 4.1 / 4.5.1.10): Invalid unverified write without incrementing address
	constant c_RMAP_RLY_TEST_CASE_16_04_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 17.1 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 bytes to AEB1 critical configuration are (0x00010014)
	constant c_RMAP_RLY_TEST_CASE_17_01_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"03C", x"000", x"051", x"000", x"01B", x"0AF", x"100");
	-- Test Case 17.2 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 8 Bytes to AEB1 critical configuration area (0x00010014)
	constant c_RMAP_RLY_TEST_CASE_17_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 17.3 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB1 critical configuration area (0x00010014)
	constant c_RMAP_RLY_TEST_CASE_17_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 17.4 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 4 Bytes from AEB1 critical configuration area (0x00010014)
	constant c_RMAP_RLY_TEST_CASE_17_04_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"01E", x"000", x"000", x"000", x"004", x"03E", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 17.5 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 8 Bytes from AEB1 critical configuration area (0x00010014)
	constant c_RMAP_RLY_TEST_CASE_17_05_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 17.6 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 0 Bytes from AEB1 critical configuration area (0x00010014)
	constant c_RMAP_RLY_TEST_CASE_17_06_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 17.7 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 Bytes to AEB1 general configuration area (0x00010130)
	constant c_RMAP_RLY_TEST_CASE_17_07_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"021", x"0FE", x"100");
	-- Test Case 17.8 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 256 Bytes to AEB1 general configuration area (0x00010130)
	constant c_RMAP_RLY_TEST_CASE_17_08_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"022", x"08C", x"100");
	-- Test Case 17.9 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 260 Bytes to AEB1 general configuration area (0x00010130)
	constant c_RMAP_RLY_TEST_CASE_17_09_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 17.10 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB1 general configuration area (0x00010130)
	constant c_RMAP_RLY_TEST_CASE_17_10_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 17.11 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB1 general configuration area (0x00010130)
	constant c_RMAP_RLY_TEST_CASE_17_11_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"025", x"000", x"000", x"000", x"004", x"0E1", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 17.12 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB1 general configuration area (0x00010130)
	constant c_RMAP_RLY_TEST_CASE_17_12_DATA : t_rmap_rly_270_data  := (x"050", x"001", x"00C", x"000", x"051", x"000", x"026", x"000", x"000", x"001", x"000", x"071", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"087", x"100");
	-- Test Case 17.13 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB1 general configuration area (0x00010130)
	constant c_RMAP_RLY_TEST_CASE_17_13_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 17.14 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB1 general configuration area (0x00010130)
	constant c_RMAP_RLY_TEST_CASE_17_14_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 17.15 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB1 housekeeping area (0x00011000)
	constant c_RMAP_RLY_TEST_CASE_17_15_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"029", x"000", x"000", x"000", x"004", x"08B", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 17.16 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB1 housekeeping area (0x00011000)
	constant c_RMAP_RLY_TEST_CASE_17_16_DATA : t_rmap_rly_270_data  := (x"050", x"001", x"00C", x"000", x"051", x"000", x"02A", x"000", x"000", x"001", x"000", x"01B", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"087", x"100");
	-- Test Case 17.17 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB1 housekeeping area (0x00011000)
	constant c_RMAP_RLY_TEST_CASE_17_17_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 17.18 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB1 housekeeping area (0x00011000)
	constant c_RMAP_RLY_TEST_CASE_17_18_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 18.1 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 bytes to AEB2 critical configuration are (0x00020014)
	constant c_RMAP_RLY_TEST_CASE_18_01_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"03C", x"000", x"051", x"000", x"02D", x"06F", x"100");
	-- Test Case 18.2 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 8 Bytes to AEB2 critical configuration area (0x00020014)
	constant c_RMAP_RLY_TEST_CASE_18_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 18.3 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB2 critical configuration area (0x00020014)
	constant c_RMAP_RLY_TEST_CASE_18_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 18.4 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 4 Bytes from AEB2 critical configuration area (0x00020014)
	constant c_RMAP_RLY_TEST_CASE_18_04_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"030", x"000", x"000", x"000", x"004", x"0B6", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 18.5 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 8 Bytes from AEB2 critical configuration area (0x00020014)
	constant c_RMAP_RLY_TEST_CASE_18_05_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 18.6 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 0 Bytes from AEB2 critical configuration area (0x00020014)
	constant c_RMAP_RLY_TEST_CASE_18_06_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 18.7 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 Bytes to AEB2 general configuration area (0x00020130)
	constant c_RMAP_RLY_TEST_CASE_18_07_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"033", x"001", x"100");
	-- Test Case 18.8 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 256 Bytes to AEB2 general configuration area (0x00020130)
	constant c_RMAP_RLY_TEST_CASE_18_08_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"034", x"074", x"100");
	-- Test Case 18.9 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 260 Bytes to AEB2 general configuration area (0x00020130)
	constant c_RMAP_RLY_TEST_CASE_18_09_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 18.10 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB2 general configuration area (0x00020130)
	constant c_RMAP_RLY_TEST_CASE_18_10_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 18.11 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB2 general configuration area (0x00020130)
	constant c_RMAP_RLY_TEST_CASE_18_11_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"037", x"000", x"000", x"000", x"004", x"06A", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 18.12 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB2 general configuration area (0x00020130)
	constant c_RMAP_RLY_TEST_CASE_18_12_DATA : t_rmap_rly_270_data  := (x"050", x"001", x"00C", x"000", x"051", x"000", x"038", x"000", x"000", x"001", x"000", x"090", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"087", x"100");
	-- Test Case 18.13 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB2 general configuration area (0x00020130)
	constant c_RMAP_RLY_TEST_CASE_18_13_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 18.14 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB2 general configuration area (0x00020130)
	constant c_RMAP_RLY_TEST_CASE_18_14_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 18.15 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB2 housekeeping area (0x00021000)
	constant c_RMAP_RLY_TEST_CASE_18_15_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"03B", x"000", x"000", x"000", x"004", x"000", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 18.16 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB2 housekeeping area (0x00021000)
	constant c_RMAP_RLY_TEST_CASE_18_16_DATA : t_rmap_rly_270_data  := (x"050", x"001", x"00C", x"000", x"051", x"000", x"03C", x"000", x"000", x"001", x"000", x"0B6", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"087", x"100");
	-- Test Case 18.17 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB2 housekeeping area (0x00021000)
	constant c_RMAP_RLY_TEST_CASE_18_17_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 18.18 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB2 housekeeping area (0x00021000)
	constant c_RMAP_RLY_TEST_CASE_18_18_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 19.1 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 bytes to AEB3 critical configuration are (0x00040014)
	constant c_RMAP_RLY_TEST_CASE_19_01_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"03C", x"000", x"051", x"000", x"03F", x"090", x"100");
	-- Test Case 19.2 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 8 Bytes to AEB3 critical configuration area (0x00040014)
	constant c_RMAP_RLY_TEST_CASE_19_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 19.3 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB3 critical configuration area (0x00040014)
	constant c_RMAP_RLY_TEST_CASE_19_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 19.4 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 4 Bytes from AEB3 critical configuration area (0x00040014)
	constant c_RMAP_RLY_TEST_CASE_19_04_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"042", x"000", x"000", x"000", x"004", x"0EF", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 19.5 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 8 Bytes from AEB3 critical configuration area (0x00040014)
	constant c_RMAP_RLY_TEST_CASE_19_05_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 19.6 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 0 Bytes from AEB3 critical configuration area (0x00040014)
	constant c_RMAP_RLY_TEST_CASE_19_06_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 19.7 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 Bytes to AEB3 general configuration area (0x00040130)
	constant c_RMAP_RLY_TEST_CASE_19_07_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"045", x"0B1", x"100");
	-- Test Case 19.8 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 256 Bytes to AEB3 general configuration area (0x00040130)
	constant c_RMAP_RLY_TEST_CASE_19_08_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"046", x"0C3", x"100");
	-- Test Case 19.9 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 260 Bytes to AEB3 general configuration area (0x00040130)
	constant c_RMAP_RLY_TEST_CASE_19_09_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 19.10 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB3 general configuration area (0x00040130)
	constant c_RMAP_RLY_TEST_CASE_19_10_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 19.11 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB3 general configuration area (0x00040130)
	constant c_RMAP_RLY_TEST_CASE_19_11_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"049", x"000", x"000", x"000", x"004", x"059", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 19.12 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB3 general configuration area (0x00040130)
	constant c_RMAP_RLY_TEST_CASE_19_12_DATA : t_rmap_rly_270_data  := (x"050", x"001", x"00C", x"000", x"051", x"000", x"04A", x"000", x"000", x"001", x"000", x"0C9", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"087", x"100");
	-- Test Case 19.13 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB3 general configuration area (0x00040130)
	constant c_RMAP_RLY_TEST_CASE_19_13_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 19.14 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB3 general configuration area (0x00040130)
	constant c_RMAP_RLY_TEST_CASE_19_14_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 19.15 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB3 housekeeping area (0x00041000)
	constant c_RMAP_RLY_TEST_CASE_19_15_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"04D", x"000", x"000", x"000", x"004", x"07F", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 19.16 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB3 housekeeping area (0x00041000)
	constant c_RMAP_RLY_TEST_CASE_19_16_DATA : t_rmap_rly_270_data  := (x"050", x"001", x"00C", x"000", x"051", x"000", x"04E", x"000", x"000", x"001", x"000", x"0EF", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"087", x"100");
	-- Test Case 19.17 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB3 housekeeping area (0x00041000)
	constant c_RMAP_RLY_TEST_CASE_19_17_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 19.18 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB3 housekeeping area (0x00041000)
	constant c_RMAP_RLY_TEST_CASE_19_18_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 20.1 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 bytes to AEB4 critical configuration are (0x00080014)
	constant c_RMAP_RLY_TEST_CASE_20_01_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"03C", x"000", x"051", x"000", x"051", x"032", x"100");
	-- Test Case 20.2 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 8 Bytes to AEB4 critical configuration area (0x00080014)
	constant c_RMAP_RLY_TEST_CASE_20_02_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 20.3 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB4 critical configuration area (0x00080014)
	constant c_RMAP_RLY_TEST_CASE_20_03_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 20.4 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 4 Bytes from AEB4 critical configuration area (0x00080014)
	constant c_RMAP_RLY_TEST_CASE_20_04_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"054", x"000", x"000", x"000", x"004", x"042", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 20.5 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 8 Bytes from AEB4 critical configuration area (0x00080014)
	constant c_RMAP_RLY_TEST_CASE_20_05_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 20.6 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Read 0 Bytes from AEB4 critical configuration area (0x00080014)
	constant c_RMAP_RLY_TEST_CASE_20_06_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 20.7 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 4 Bytes to AEB4 general configuration area (0x00080130)
	constant c_RMAP_RLY_TEST_CASE_20_07_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"057", x"04E", x"100");
	-- Test Case 20.8 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 256 Bytes to AEB4 general configuration area (0x00080130)
	constant c_RMAP_RLY_TEST_CASE_20_08_DATA : t_rmap_rly_9_data    := (x"050", x"001", x"02C", x"000", x"051", x"000", x"058", x"035", x"100");
	-- Test Case 20.9 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 260 Bytes to AEB4 general configuration area (0x00080130)
	constant c_RMAP_RLY_TEST_CASE_20_09_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 20.10 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Writing 0 Bytes to AEB4 general configuration area (0x00080130)
	constant c_RMAP_RLY_TEST_CASE_20_10_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 20.11 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB4 general configuration area (0x00080130)
	constant c_RMAP_RLY_TEST_CASE_20_11_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"05B", x"000", x"000", x"000", x"004", x"0D2", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 20.12 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB4 general configuration area (0x00080130)
	constant c_RMAP_RLY_TEST_CASE_20_12_DATA : t_rmap_rly_270_data  := (x"050", x"001", x"00C", x"000", x"051", x"000", x"05C", x"000", x"000", x"001", x"000", x"064", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"087", x"100");
	-- Test Case 20.13 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB4 general configuration area (0x00080130)
	constant c_RMAP_RLY_TEST_CASE_20_13_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 20.14 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB4 general configuration area (0x00080130)
	constant c_RMAP_RLY_TEST_CASE_20_14_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 20.15 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 4 Bytes from AEB4 housekeeping area (0x00081000)
	constant c_RMAP_RLY_TEST_CASE_20_15_DATA : t_rmap_rly_18_data   := (x"050", x"001", x"00C", x"000", x"051", x"000", x"05F", x"000", x"000", x"000", x"004", x"0F4", x"0AA", x"0AA", x"0AA", x"0AA", x"0ED", x"100");
	-- Test Case 20.16 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 256 Bytes from AEB4 housekeeping area (0x00081000)
	constant c_RMAP_RLY_TEST_CASE_20_16_DATA : t_rmap_rly_270_data  := (x"050", x"001", x"00C", x"000", x"051", x"000", x"060", x"000", x"000", x"001", x"000", x"067", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"0AA", x"087", x"100");
	-- Test Case 20.17 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 260 Bytes from AEB4 housekeeping area (0x00081000)
	constant c_RMAP_RLY_TEST_CASE_20_17_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);
	-- Test Case 20.18 (PLATO-DLR-PL-ICD-0007 4.5.1.12): Reading 0 Bytes from AEB4 housekeeping area (0x00081000)
	constant c_RMAP_RLY_TEST_CASE_20_18_DATA : t_rmap_rly_no_reply  := (c_RMAP_RLY_INVALID_DATA, c_RMAP_RLY_INVALID_DATA);

end package rmap_tb_stimulli_rly_pkg;

package body rmap_tb_stimulli_rly_pkg is

end package body rmap_tb_stimulli_rly_pkg;
