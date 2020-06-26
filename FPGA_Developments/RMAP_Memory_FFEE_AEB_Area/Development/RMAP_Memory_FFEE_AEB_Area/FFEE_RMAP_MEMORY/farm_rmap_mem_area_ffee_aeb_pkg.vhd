library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package farm_rmap_mem_area_ffee_aeb_pkg is

	constant c_FARM_FFEE_AEB_RMAP_ADRESS_SIZE : natural := 32;
	constant c_FARM_FFEE_AEB_RMAP_DATA_SIZE   : natural := 8;
	constant c_FARM_FFEE_AEB_RMAP_SYMBOL_SIZE : natural := 8;

	type t_farm_ffee_aeb_rmap_read_in is record
		address : std_logic_vector((c_FARM_FFEE_AEB_RMAP_ADRESS_SIZE - 1) downto 0);
		read    : std_logic;
	end record t_farm_ffee_aeb_rmap_read_in;

	type t_farm_ffee_aeb_rmap_read_out is record
		readdata    : std_logic_vector((c_FARM_FFEE_AEB_RMAP_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_farm_ffee_aeb_rmap_read_out;

	type t_farm_ffee_aeb_rmap_write_in is record
		address   : std_logic_vector((c_FARM_FFEE_AEB_RMAP_ADRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((c_FARM_FFEE_AEB_RMAP_DATA_SIZE - 1) downto 0);
	end record t_farm_ffee_aeb_rmap_write_in;

	type t_farm_ffee_aeb_rmap_write_out is record
		waitrequest : std_logic;
	end record t_farm_ffee_aeb_rmap_write_out;

	constant c_FARM_FFEE_AEB_RMAP_READ_IN_RST : t_farm_ffee_aeb_rmap_read_in := (
		address => (others => '0'),
		read    => '0'
	);

	constant c_FARM_FFEE_AEB_RMAP_READ_OUT_RST : t_farm_ffee_aeb_rmap_read_out := (
		readdata    => (others => '0'),
		waitrequest => '1'
	);

	constant c_FARM_FFEE_AEB_RMAP_WRITE_IN_RST : t_farm_ffee_aeb_rmap_write_in := (
		address   => (others => '0'),
		write     => '0',
		writedata => (others => '0')
	);

	constant c_FARM_FFEE_AEB_RMAP_WRITE_OUT_RST : t_farm_ffee_aeb_rmap_write_out := (
		waitrequest => '1'
	);

	-- Address Constants

	-- Allowed Addresses
	constant c_FARM_AVALON_MM_FFEE_AEB_RMAP_MIN_ADDR : natural range 0 to 2047 := 16#000#;
	constant c_FARM_AVALON_MM_FFEE_AEB_RMAP_MAX_ADDR : natural range 0 to 2047 := 16#5BB#;

	-- Registers Types

	-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT"
	type t_aeb_crit_cfg_aeb_config_ait_wr_reg is record
		override_sw     : std_logic;    -- "OVERRIDE_SW" Field
		reserved_0      : std_logic_vector(1 downto 0); -- "RESERVED_0" Field
		sw_van3         : std_logic;    -- "SW_VAN3" Field
		sw_van2         : std_logic;    -- "SW_VAN2" Field
		sw_van1         : std_logic;    -- "SW_VAN1" Field
		sw_vclk         : std_logic;    -- "SW_VCLK" Field
		sw_vccd         : std_logic;    -- "SW_VCCD" Field
		override_vasp   : std_logic;    -- "OVERRIDE_VASP" Field
		reserved_1      : std_logic;    -- "RESERVED_1" Field
		vasp2_pix_en    : std_logic;    -- "VASP2_PIX_EN" Field
		vasp1_pix_en    : std_logic;    -- "VASP1_PIX_EN" Field
		vasp2_adc_en    : std_logic;    -- "VASP2_ADC_EN" Field
		vasp1_adc_en    : std_logic;    -- "VASP1_ADC_EN" Field
		vasp2_reset     : std_logic;    -- "VASP2_RESET" Field
		vasp1_reset     : std_logic;    -- "VASP1_RESET" Field
		override_adc    : std_logic;    -- "OVERRIDE_ADC" Field
		adc2_en_p5v0    : std_logic;    -- "ADC2_EN_P5V0" Field
		adc1_en_p5v0    : std_logic;    -- "ADC1_EN_P5V0" Field
		pt1000_cal_on_n : std_logic;    -- "PT1000_CAL_ON_N" Field
		en_v_mux_n      : std_logic;    -- "EN_V_MUX_N" Field
		adc2_pwdn_n     : std_logic;    -- "ADC2_PWDN_N" Field
		adc1_pwdn_n     : std_logic;    -- "ADC1_PWDN_N" Field
		adc_clk_en      : std_logic;    -- "ADC_CLK_EN" Field
		reserved_2      : std_logic_vector(7 downto 0); -- "RESERVED_2" Field
	end record t_aeb_crit_cfg_aeb_config_ait_wr_reg;

	-- AEB Critical Configuration Area Register "AEB_CONFIG_KEY"
	type t_aeb_crit_cfg_aeb_config_key_wr_reg is record
		key : std_logic_vector(31 downto 0); -- "KEY" Field
	end record t_aeb_crit_cfg_aeb_config_key_wr_reg;

	-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN"
	type t_aeb_crit_cfg_aeb_config_pattern_wr_reg is record
		pattern_ccdid : std_logic_vector(1 downto 0); -- "PATTERN_CCDID" Field
		pattern_cols  : std_logic_vector(13 downto 0); -- "PATTERN_COLS" Field
		reserved      : std_logic_vector(1 downto 0); -- "RESERVED" Field
		pattern_rows  : std_logic_vector(13 downto 0); -- "PATTERN_ROWS" Field
	end record t_aeb_crit_cfg_aeb_config_pattern_wr_reg;

	-- AEB Critical Configuration Area Register "AEB_CONFIG"
	type t_aeb_crit_cfg_aeb_config_wr_reg is record
		reserved_0   : std_logic_vector(5 downto 0); -- "RESERVED_0" Field
		watchdog_dis : std_logic;       -- "WATCH-DOG_DIS" Field
		int_sync     : std_logic;       -- "INT_SYNC" Field
		reserved_1   : std_logic_vector(4 downto 0); -- "RESERVED_1" Field
		vasp_cds_en  : std_logic;       -- "VASP_CDS_EN" Field
		vasp2_cal_en : std_logic;       -- "VASP2_CAL_EN" Field
		vasp1_cal_en : std_logic;       -- "VASP1_CAL_EN" Field
		reserved_2   : std_logic_vector(15 downto 0); -- "RESERVED_2" Field
	end record t_aeb_crit_cfg_aeb_config_wr_reg;

	-- AEB Critical Configuration Area Register "AEB_CONTROL"
	type t_aeb_crit_cfg_aeb_control_wr_reg is record
		reserved_0  : std_logic_vector(1 downto 0); -- "RESERVED_0" Field
		new_state   : std_logic_vector(3 downto 0); -- "NEW_STATE" Field
		set_state   : std_logic;        -- "SET_STATE" Field
		aeb_reset   : std_logic;        -- "AEB_RESET" Field
		reserved_1  : std_logic_vector(3 downto 0); -- "RESERVED_1" Field
		adc_data_rd : std_logic;        -- "ADC_DATA_RD" Field
		adc_cfg_wr  : std_logic;        -- "ADC_CFG_WR" Field
		adc_cfg_rd  : std_logic;        -- "ADC_CFG_RD" Field
		dac_wr      : std_logic;        -- "DAC_WR" Field
		reserved_2  : std_logic_vector(15 downto 0); -- "RESERVED_2" Field
	end record t_aeb_crit_cfg_aeb_control_wr_reg;

	-- AEB Critical Configuration Area Register "DAC_CONFIG_1"
	type t_aeb_crit_cfg_dac_config_1_wr_reg is record
		reserved_0 : std_logic_vector(3 downto 0); -- "RESERVED_0" Field
		dac_vog    : std_logic_vector(11 downto 0); -- "DAC_VOG" Field
		reserved_1 : std_logic_vector(3 downto 0); -- "RESERVED_1" Field
		dac_vrd    : std_logic_vector(11 downto 0); -- "DAC_VRD" Field
	end record t_aeb_crit_cfg_dac_config_1_wr_reg;

	-- AEB Critical Configuration Area Register "DAC_CONFIG_2"
	type t_aeb_crit_cfg_dac_config_2_wr_reg is record
		reserved_0 : std_logic_vector(3 downto 0); -- "RESERVED_0" Field
		dac_vod    : std_logic_vector(11 downto 0); -- "DAC_VOD" Field
		reserved_1 : std_logic_vector(15 downto 0); -- "RESERVED_1" Field
	end record t_aeb_crit_cfg_dac_config_2_wr_reg;

	-- AEB Critical Configuration Area Register "PWR_CONFIG1"
	type t_aeb_crit_cfg_pwr_config1_wr_reg is record
		time_vccd_on : std_logic_vector(7 downto 0); -- "TIME_VCCD_ON" Field
		time_vclk_on : std_logic_vector(7 downto 0); -- "TIME_VCLK_ON" Field
		time_van1_on : std_logic_vector(7 downto 0); -- "TIME_VAN1_ON" Field
		time_van2_on : std_logic_vector(7 downto 0); -- "TIME_VAN2_ON" Field
	end record t_aeb_crit_cfg_pwr_config1_wr_reg;

	-- AEB Critical Configuration Area Register "PWR_CONFIG2"
	type t_aeb_crit_cfg_pwr_config2_wr_reg is record
		time_van3_on  : std_logic_vector(7 downto 0); -- "TIME_VAN3_ON" Field
		time_vccd_off : std_logic_vector(7 downto 0); -- "TIME_VCCD_OFF" Field
		time_vclk_off : std_logic_vector(7 downto 0); -- "TIME_VCLK_OFF" Field
		time_van1_off : std_logic_vector(7 downto 0); -- "TIME_VAN1_OFF" Field
	end record t_aeb_crit_cfg_pwr_config2_wr_reg;

	-- AEB Critical Configuration Area Register "PWR_CONFIG3"
	type t_aeb_crit_cfg_pwr_config3_wr_reg is record
		time_van2_off : std_logic_vector(7 downto 0); -- "TIME_VAN2_OFF" Field
		time_van3_off : std_logic_vector(7 downto 0); -- "TIME_VAN3_OFF" Field
	end record t_aeb_crit_cfg_pwr_config3_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_20"
	type t_aeb_crit_cfg_reserved_20_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_20_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_30"
	type t_aeb_crit_cfg_reserved_30_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_30_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_34"
	type t_aeb_crit_cfg_reserved_34_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_34_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_38"
	type t_aeb_crit_cfg_reserved_38_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_38_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_3C"
	type t_aeb_crit_cfg_reserved_3c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_3c_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_40"
	type t_aeb_crit_cfg_reserved_40_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_40_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_44"
	type t_aeb_crit_cfg_reserved_44_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_44_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_48"
	type t_aeb_crit_cfg_reserved_48_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_48_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_4C"
	type t_aeb_crit_cfg_reserved_4c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_4c_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_50"
	type t_aeb_crit_cfg_reserved_50_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_50_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_54"
	type t_aeb_crit_cfg_reserved_54_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_54_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_58"
	type t_aeb_crit_cfg_reserved_58_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_58_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_5C"
	type t_aeb_crit_cfg_reserved_5c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_5c_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_60"
	type t_aeb_crit_cfg_reserved_60_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_60_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_64"
	type t_aeb_crit_cfg_reserved_64_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_64_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_68"
	type t_aeb_crit_cfg_reserved_68_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_68_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_6C"
	type t_aeb_crit_cfg_reserved_6c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_6c_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_70"
	type t_aeb_crit_cfg_reserved_70_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_70_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_74"
	type t_aeb_crit_cfg_reserved_74_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_74_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_78"
	type t_aeb_crit_cfg_reserved_78_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_78_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_7C"
	type t_aeb_crit_cfg_reserved_7c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_7c_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_80"
	type t_aeb_crit_cfg_reserved_80_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_80_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_84"
	type t_aeb_crit_cfg_reserved_84_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_84_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_88"
	type t_aeb_crit_cfg_reserved_88_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_88_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_8C"
	type t_aeb_crit_cfg_reserved_8c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_8c_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_90"
	type t_aeb_crit_cfg_reserved_90_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_90_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_94"
	type t_aeb_crit_cfg_reserved_94_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_94_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_98"
	type t_aeb_crit_cfg_reserved_98_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_98_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_9C"
	type t_aeb_crit_cfg_reserved_9c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_9c_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_A0"
	type t_aeb_crit_cfg_reserved_a0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_a0_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_A4"
	type t_aeb_crit_cfg_reserved_a4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_a4_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_A8"
	type t_aeb_crit_cfg_reserved_a8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_a8_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_AC"
	type t_aeb_crit_cfg_reserved_ac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_ac_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_B0"
	type t_aeb_crit_cfg_reserved_b0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_b0_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_B4"
	type t_aeb_crit_cfg_reserved_b4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_b4_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_B8"
	type t_aeb_crit_cfg_reserved_b8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_b8_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_BC"
	type t_aeb_crit_cfg_reserved_bc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_bc_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_C0"
	type t_aeb_crit_cfg_reserved_c0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_c0_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_C4"
	type t_aeb_crit_cfg_reserved_c4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_c4_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_C8"
	type t_aeb_crit_cfg_reserved_c8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_c8_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_CC"
	type t_aeb_crit_cfg_reserved_cc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_cc_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_D0"
	type t_aeb_crit_cfg_reserved_d0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_d0_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_D4"
	type t_aeb_crit_cfg_reserved_d4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_d4_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_D8"
	type t_aeb_crit_cfg_reserved_d8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_d8_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_DC"
	type t_aeb_crit_cfg_reserved_dc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_dc_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_E0"
	type t_aeb_crit_cfg_reserved_e0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_e0_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_E4"
	type t_aeb_crit_cfg_reserved_e4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_e4_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_E8"
	type t_aeb_crit_cfg_reserved_e8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_e8_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_EC"
	type t_aeb_crit_cfg_reserved_ec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_ec_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_F0"
	type t_aeb_crit_cfg_reserved_f0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_f0_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_F4"
	type t_aeb_crit_cfg_reserved_f4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_f4_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_F8"
	type t_aeb_crit_cfg_reserved_f8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_f8_wr_reg;

	-- AEB Critical Configuration Area Register "RESERVED_FC"
	type t_aeb_crit_cfg_reserved_fc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_crit_cfg_reserved_fc_wr_reg;

	-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL"
	type t_aeb_crit_cfg_vasp_i2c_control_wr_reg is record
		vasp_cfg_addr     : std_logic_vector(7 downto 0); -- "VASP_CFG_ADDR" Field
		vasp1_cfg_data    : std_logic_vector(7 downto 0); -- "VASP1_CFG_DATA" Field
		vasp2_cfg_data    : std_logic_vector(7 downto 0); -- "VASP2_CFG_DATA" Field
		reserved          : std_logic_vector(2 downto 0); -- "RESERVED" Field
		vasp2_select      : std_logic;  -- "VASP2_SELECT" Field
		vasp1_select      : std_logic;  -- "VASP1_SELECT" Field
		calibration_start : std_logic;  -- "CALIBRATION_START" Field
		i2c_read_start    : std_logic;  -- "I2C_READ_START" Field
		i2c_write_start   : std_logic;  -- "I2C_WRITE_START" Field
	end record t_aeb_crit_cfg_vasp_i2c_control_wr_reg;

	-- AEB General Configuration Area Register "ADC1_CONFIG_1"
	type t_aeb_gen_cfg_adc1_config_1_wr_reg is record
		reserved_0 : std_logic;         -- "RESERVED_0" Field
		spirst     : std_logic;         -- "SPIRST" Field
		muxmod     : std_logic;         -- "MUXMOD" Field
		bypas      : std_logic;         -- "BYPAS" Field
		clkenb     : std_logic;         -- "CLKENB" Field
		chop       : std_logic;         -- "CHOP" Field
		stat       : std_logic;         -- "STAT" Field
		reserved_1 : std_logic;         -- "RESERVED_1" Field
		idlmod     : std_logic;         -- "IDLMOD" Field
		dly        : std_logic_vector(2 downto 0); -- "DLY" Field
		sbcs       : std_logic_vector(1 downto 0); -- "SBCS" Field
		drate      : std_logic_vector(1 downto 0); -- "DRATE" Field
		ainp       : std_logic_vector(3 downto 0); -- "AINP" Field
		ainn       : std_logic_vector(3 downto 0); -- "AINN" Field
		diff       : std_logic_vector(7 downto 0); -- "DIFF" Field
	end record t_aeb_gen_cfg_adc1_config_1_wr_reg;

	-- AEB General Configuration Area Register "ADC1_CONFIG_2"
	type t_aeb_gen_cfg_adc1_config_2_wr_reg is record
		ain7       : std_logic;         -- "AIN7" Field
		ain6       : std_logic;         -- "AIN6" Field
		ain5       : std_logic;         -- "AIN5" Field
		ain4       : std_logic;         -- "AIN4" Field
		ain3       : std_logic;         -- "AIN3" Field
		ain2       : std_logic;         -- "AIN2" Field
		ain1       : std_logic;         -- "AIN1" Field
		ain0       : std_logic;         -- "AIN0" Field
		ain15      : std_logic;         -- "AIN15" Field
		ain14      : std_logic;         -- "AIN14" Field
		ain13      : std_logic;         -- "AIN13" Field
		ain12      : std_logic;         -- "AIN12" Field
		ain11      : std_logic;         -- "AIN11" Field
		ain10      : std_logic;         -- "AIN10" Field
		ain9       : std_logic;         -- "AIN9" Field
		ain8       : std_logic;         -- "AIN8" Field
		reserved_0 : std_logic_vector(1 downto 0); -- "RESERVED_0" Field
		ref        : std_logic;         -- "REF" Field
		gain       : std_logic;         -- "GAIN" Field
		temp       : std_logic;         -- "TEMP" Field
		vcc        : std_logic;         -- "VCC" Field
		reserved_1 : std_logic;         -- "RESERVED_1" Field
		offset     : std_logic;         -- "OFFSET" Field
		cio7       : std_logic;         -- "CIO7" Field
		cio6       : std_logic;         -- "CIO6" Field
		cio5       : std_logic;         -- "CIO5" Field
		cio4       : std_logic;         -- "CIO4" Field
		cio3       : std_logic;         -- "CIO3" Field
		cio2       : std_logic;         -- "CIO2" Field
		cio1       : std_logic;         -- "CIO1" Field
		cio0       : std_logic;         -- "CIO0" Field
	end record t_aeb_gen_cfg_adc1_config_2_wr_reg;

	-- AEB General Configuration Area Register "ADC1_CONFIG_3"
	type t_aeb_gen_cfg_adc1_config_3_wr_reg is record
		dio7     : std_logic;           -- "DIO7" Field
		dio6     : std_logic;           -- "DIO6" Field
		dio5     : std_logic;           -- "DIO5" Field
		dio4     : std_logic;           -- "DIO4" Field
		dio3     : std_logic;           -- "DIO3" Field
		dio2     : std_logic;           -- "DIO2" Field
		dio1     : std_logic;           -- "DIO1" Field
		dio0     : std_logic;           -- "DIO0" Field
		reserved : std_logic_vector(23 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_adc1_config_3_wr_reg;

	-- AEB General Configuration Area Register "ADC2_CONFIG_1"
	type t_aeb_gen_cfg_adc2_config_1_wr_reg is record
		reserved_0 : std_logic;         -- "RESERVED_0" Field
		spirst     : std_logic;         -- "SPIRST" Field
		muxmod     : std_logic;         -- "MUXMOD" Field
		bypas      : std_logic;         -- "BYPAS" Field
		clkenb     : std_logic;         -- "CLKENB" Field
		chop       : std_logic;         -- "CHOP" Field
		stat       : std_logic;         -- "STAT" Field
		reserved_1 : std_logic;         -- "RESERVED_1" Field
		idlmod     : std_logic;         -- "IDLMOD" Field
		dly        : std_logic_vector(2 downto 0); -- "DLY" Field
		sbcs       : std_logic_vector(1 downto 0); -- "SBCS" Field
		drate      : std_logic_vector(1 downto 0); -- "DRATE" Field
		ainp       : std_logic_vector(3 downto 0); -- "AINP" Field
		ainn       : std_logic_vector(3 downto 0); -- "AINN" Field
		diff       : std_logic_vector(7 downto 0); -- "DIFF" Field
	end record t_aeb_gen_cfg_adc2_config_1_wr_reg;

	-- AEB General Configuration Area Register "ADC2_CONFIG_2"
	type t_aeb_gen_cfg_adc2_config_2_wr_reg is record
		ain7       : std_logic;         -- "AIN7" Field
		ain6       : std_logic;         -- "AIN6" Field
		ain5       : std_logic;         -- "AIN5" Field
		ain4       : std_logic;         -- "AIN4" Field
		ain3       : std_logic;         -- "AIN3" Field
		ain2       : std_logic;         -- "AIN2" Field
		ain1       : std_logic;         -- "AIN1" Field
		ain0       : std_logic;         -- "AIN0" Field
		ain15      : std_logic;         -- "AIN15" Field
		ain14      : std_logic;         -- "AIN14" Field
		ain13      : std_logic;         -- "AIN13" Field
		ain12      : std_logic;         -- "AIN12" Field
		ain11      : std_logic;         -- "AIN11" Field
		ain10      : std_logic;         -- "AIN10" Field
		ain9       : std_logic;         -- "AIN9" Field
		ain8       : std_logic;         -- "AIN8" Field
		reserved_0 : std_logic_vector(1 downto 0); -- "RESERVED_0" Field
		ref        : std_logic;         -- "REF" Field
		gain       : std_logic;         -- "GAIN" Field
		temp       : std_logic;         -- "TEMP" Field
		vcc        : std_logic;         -- "VCC" Field
		reserved_1 : std_logic;         -- "RESERVED_1" Field
		offset     : std_logic;         -- "OFFSET" Field
		cio7       : std_logic;         -- "CIO7" Field
		cio6       : std_logic;         -- "CIO6" Field
		cio5       : std_logic;         -- "CIO5" Field
		cio4       : std_logic;         -- "CIO4" Field
		cio3       : std_logic;         -- "CIO3" Field
		cio2       : std_logic;         -- "CIO2" Field
		cio1       : std_logic;         -- "CIO1" Field
		cio0       : std_logic;         -- "CIO0" Field
	end record t_aeb_gen_cfg_adc2_config_2_wr_reg;

	-- AEB General Configuration Area Register "ADC2_CONFIG_3"
	type t_aeb_gen_cfg_adc2_config_3_wr_reg is record
		dio7     : std_logic;           -- "DIO7" Field
		dio6     : std_logic;           -- "DIO6" Field
		dio5     : std_logic;           -- "DIO5" Field
		dio4     : std_logic;           -- "DIO4" Field
		dio3     : std_logic;           -- "DIO3" Field
		dio2     : std_logic;           -- "DIO2" Field
		dio1     : std_logic;           -- "DIO1" Field
		dio0     : std_logic;           -- "DIO0" Field
		reserved : std_logic_vector(23 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_adc2_config_3_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_118"
	type t_aeb_gen_cfg_reserved_118_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_118_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_11C"
	type t_aeb_gen_cfg_reserved_11c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_11c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_158"
	type t_aeb_gen_cfg_reserved_158_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_158_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_15C"
	type t_aeb_gen_cfg_reserved_15c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_15c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_160"
	type t_aeb_gen_cfg_reserved_160_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_160_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_164"
	type t_aeb_gen_cfg_reserved_164_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_164_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_168"
	type t_aeb_gen_cfg_reserved_168_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_168_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_16C"
	type t_aeb_gen_cfg_reserved_16c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_16c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_170"
	type t_aeb_gen_cfg_reserved_170_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_170_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_174"
	type t_aeb_gen_cfg_reserved_174_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_174_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_178"
	type t_aeb_gen_cfg_reserved_178_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_178_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_17C"
	type t_aeb_gen_cfg_reserved_17c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_17c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_180"
	type t_aeb_gen_cfg_reserved_180_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_180_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_184"
	type t_aeb_gen_cfg_reserved_184_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_184_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_188"
	type t_aeb_gen_cfg_reserved_188_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_188_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_18C"
	type t_aeb_gen_cfg_reserved_18c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_18c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_190"
	type t_aeb_gen_cfg_reserved_190_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_190_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_194"
	type t_aeb_gen_cfg_reserved_194_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_194_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_198"
	type t_aeb_gen_cfg_reserved_198_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_198_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_19C"
	type t_aeb_gen_cfg_reserved_19c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_19c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1A0"
	type t_aeb_gen_cfg_reserved_1a0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1a0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1A4"
	type t_aeb_gen_cfg_reserved_1a4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1a4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1A8"
	type t_aeb_gen_cfg_reserved_1a8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1a8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1AC"
	type t_aeb_gen_cfg_reserved_1ac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1ac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1B0"
	type t_aeb_gen_cfg_reserved_1b0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1b0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1B4"
	type t_aeb_gen_cfg_reserved_1b4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1b4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1B8"
	type t_aeb_gen_cfg_reserved_1b8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1b8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1BC"
	type t_aeb_gen_cfg_reserved_1bc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1bc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1C0"
	type t_aeb_gen_cfg_reserved_1c0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1c0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1C4"
	type t_aeb_gen_cfg_reserved_1c4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1c4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1C8"
	type t_aeb_gen_cfg_reserved_1c8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1c8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1CC"
	type t_aeb_gen_cfg_reserved_1cc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1cc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1D0"
	type t_aeb_gen_cfg_reserved_1d0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1d0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1D4"
	type t_aeb_gen_cfg_reserved_1d4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1d4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1D8"
	type t_aeb_gen_cfg_reserved_1d8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1d8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1DC"
	type t_aeb_gen_cfg_reserved_1dc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1dc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1E0"
	type t_aeb_gen_cfg_reserved_1e0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1e0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1E4"
	type t_aeb_gen_cfg_reserved_1e4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1e4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1E8"
	type t_aeb_gen_cfg_reserved_1e8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1e8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1EC"
	type t_aeb_gen_cfg_reserved_1ec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1ec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1F0"
	type t_aeb_gen_cfg_reserved_1f0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1f0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1F4"
	type t_aeb_gen_cfg_reserved_1f4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1f4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1F8"
	type t_aeb_gen_cfg_reserved_1f8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1f8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_1FC"
	type t_aeb_gen_cfg_reserved_1fc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_1fc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_200"
	type t_aeb_gen_cfg_reserved_200_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_200_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_204"
	type t_aeb_gen_cfg_reserved_204_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_204_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_208"
	type t_aeb_gen_cfg_reserved_208_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_208_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_20C"
	type t_aeb_gen_cfg_reserved_20c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_20c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_210"
	type t_aeb_gen_cfg_reserved_210_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_210_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_214"
	type t_aeb_gen_cfg_reserved_214_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_214_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_218"
	type t_aeb_gen_cfg_reserved_218_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_218_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_21C"
	type t_aeb_gen_cfg_reserved_21c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_21c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_220"
	type t_aeb_gen_cfg_reserved_220_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_220_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_224"
	type t_aeb_gen_cfg_reserved_224_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_224_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_228"
	type t_aeb_gen_cfg_reserved_228_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_228_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_22C"
	type t_aeb_gen_cfg_reserved_22c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_22c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_230"
	type t_aeb_gen_cfg_reserved_230_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_230_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_234"
	type t_aeb_gen_cfg_reserved_234_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_234_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_238"
	type t_aeb_gen_cfg_reserved_238_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_238_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_23C"
	type t_aeb_gen_cfg_reserved_23c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_23c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_240"
	type t_aeb_gen_cfg_reserved_240_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_240_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_244"
	type t_aeb_gen_cfg_reserved_244_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_244_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_248"
	type t_aeb_gen_cfg_reserved_248_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_248_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_24C"
	type t_aeb_gen_cfg_reserved_24c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_24c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_250"
	type t_aeb_gen_cfg_reserved_250_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_250_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_254"
	type t_aeb_gen_cfg_reserved_254_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_254_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_258"
	type t_aeb_gen_cfg_reserved_258_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_258_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_25C"
	type t_aeb_gen_cfg_reserved_25c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_25c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_260"
	type t_aeb_gen_cfg_reserved_260_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_260_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_264"
	type t_aeb_gen_cfg_reserved_264_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_264_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_268"
	type t_aeb_gen_cfg_reserved_268_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_268_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_26C"
	type t_aeb_gen_cfg_reserved_26c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_26c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_270"
	type t_aeb_gen_cfg_reserved_270_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_270_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_274"
	type t_aeb_gen_cfg_reserved_274_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_274_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_278"
	type t_aeb_gen_cfg_reserved_278_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_278_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_27C"
	type t_aeb_gen_cfg_reserved_27c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_27c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_280"
	type t_aeb_gen_cfg_reserved_280_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_280_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_284"
	type t_aeb_gen_cfg_reserved_284_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_284_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_288"
	type t_aeb_gen_cfg_reserved_288_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_288_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_28C"
	type t_aeb_gen_cfg_reserved_28c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_28c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_290"
	type t_aeb_gen_cfg_reserved_290_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_290_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_294"
	type t_aeb_gen_cfg_reserved_294_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_294_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_298"
	type t_aeb_gen_cfg_reserved_298_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_298_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_29C"
	type t_aeb_gen_cfg_reserved_29c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_29c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2A0"
	type t_aeb_gen_cfg_reserved_2a0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2a0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2A4"
	type t_aeb_gen_cfg_reserved_2a4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2a4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2A8"
	type t_aeb_gen_cfg_reserved_2a8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2a8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2AC"
	type t_aeb_gen_cfg_reserved_2ac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2ac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2B0"
	type t_aeb_gen_cfg_reserved_2b0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2b0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2B4"
	type t_aeb_gen_cfg_reserved_2b4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2b4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2B8"
	type t_aeb_gen_cfg_reserved_2b8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2b8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2BC"
	type t_aeb_gen_cfg_reserved_2bc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2bc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2C0"
	type t_aeb_gen_cfg_reserved_2c0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2c0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2C4"
	type t_aeb_gen_cfg_reserved_2c4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2c4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2C8"
	type t_aeb_gen_cfg_reserved_2c8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2c8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2CC"
	type t_aeb_gen_cfg_reserved_2cc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2cc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2D0"
	type t_aeb_gen_cfg_reserved_2d0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2d0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2D4"
	type t_aeb_gen_cfg_reserved_2d4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2d4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2D8"
	type t_aeb_gen_cfg_reserved_2d8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2d8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2DC"
	type t_aeb_gen_cfg_reserved_2dc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2dc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2E0"
	type t_aeb_gen_cfg_reserved_2e0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2e0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2E4"
	type t_aeb_gen_cfg_reserved_2e4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2e4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2E8"
	type t_aeb_gen_cfg_reserved_2e8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2e8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2EC"
	type t_aeb_gen_cfg_reserved_2ec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2ec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2F0"
	type t_aeb_gen_cfg_reserved_2f0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2f0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2F4"
	type t_aeb_gen_cfg_reserved_2f4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2f4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2F8"
	type t_aeb_gen_cfg_reserved_2f8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2f8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_2FC"
	type t_aeb_gen_cfg_reserved_2fc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_2fc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_300"
	type t_aeb_gen_cfg_reserved_300_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_300_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_304"
	type t_aeb_gen_cfg_reserved_304_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_304_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_308"
	type t_aeb_gen_cfg_reserved_308_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_308_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_30C"
	type t_aeb_gen_cfg_reserved_30c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_30c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_310"
	type t_aeb_gen_cfg_reserved_310_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_310_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_314"
	type t_aeb_gen_cfg_reserved_314_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_314_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_318"
	type t_aeb_gen_cfg_reserved_318_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_318_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_31C"
	type t_aeb_gen_cfg_reserved_31c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_31c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_320"
	type t_aeb_gen_cfg_reserved_320_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_320_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_324"
	type t_aeb_gen_cfg_reserved_324_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_324_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_328"
	type t_aeb_gen_cfg_reserved_328_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_328_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_32C"
	type t_aeb_gen_cfg_reserved_32c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_32c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_330"
	type t_aeb_gen_cfg_reserved_330_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_330_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_334"
	type t_aeb_gen_cfg_reserved_334_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_334_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_338"
	type t_aeb_gen_cfg_reserved_338_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_338_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_33C"
	type t_aeb_gen_cfg_reserved_33c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_33c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_340"
	type t_aeb_gen_cfg_reserved_340_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_340_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_344"
	type t_aeb_gen_cfg_reserved_344_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_344_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_348"
	type t_aeb_gen_cfg_reserved_348_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_348_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_34C"
	type t_aeb_gen_cfg_reserved_34c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_34c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_350"
	type t_aeb_gen_cfg_reserved_350_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_350_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_354"
	type t_aeb_gen_cfg_reserved_354_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_354_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_358"
	type t_aeb_gen_cfg_reserved_358_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_358_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_35C"
	type t_aeb_gen_cfg_reserved_35c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_35c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_360"
	type t_aeb_gen_cfg_reserved_360_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_360_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_364"
	type t_aeb_gen_cfg_reserved_364_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_364_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_368"
	type t_aeb_gen_cfg_reserved_368_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_368_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_36C"
	type t_aeb_gen_cfg_reserved_36c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_36c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_370"
	type t_aeb_gen_cfg_reserved_370_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_370_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_374"
	type t_aeb_gen_cfg_reserved_374_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_374_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_378"
	type t_aeb_gen_cfg_reserved_378_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_378_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_37C"
	type t_aeb_gen_cfg_reserved_37c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_37c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_380"
	type t_aeb_gen_cfg_reserved_380_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_380_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_384"
	type t_aeb_gen_cfg_reserved_384_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_384_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_388"
	type t_aeb_gen_cfg_reserved_388_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_388_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_38C"
	type t_aeb_gen_cfg_reserved_38c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_38c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_390"
	type t_aeb_gen_cfg_reserved_390_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_390_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_394"
	type t_aeb_gen_cfg_reserved_394_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_394_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_398"
	type t_aeb_gen_cfg_reserved_398_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_398_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_39C"
	type t_aeb_gen_cfg_reserved_39c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_39c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3A0"
	type t_aeb_gen_cfg_reserved_3a0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3a0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3A4"
	type t_aeb_gen_cfg_reserved_3a4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3a4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3A8"
	type t_aeb_gen_cfg_reserved_3a8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3a8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3AC"
	type t_aeb_gen_cfg_reserved_3ac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3ac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3B0"
	type t_aeb_gen_cfg_reserved_3b0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3b0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3B4"
	type t_aeb_gen_cfg_reserved_3b4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3b4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3B8"
	type t_aeb_gen_cfg_reserved_3b8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3b8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3BC"
	type t_aeb_gen_cfg_reserved_3bc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3bc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3C0"
	type t_aeb_gen_cfg_reserved_3c0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3c0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3C4"
	type t_aeb_gen_cfg_reserved_3c4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3c4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3C8"
	type t_aeb_gen_cfg_reserved_3c8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3c8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3CC"
	type t_aeb_gen_cfg_reserved_3cc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3cc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3D0"
	type t_aeb_gen_cfg_reserved_3d0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3d0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3D4"
	type t_aeb_gen_cfg_reserved_3d4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3d4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3D8"
	type t_aeb_gen_cfg_reserved_3d8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3d8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3DC"
	type t_aeb_gen_cfg_reserved_3dc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3dc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3E0"
	type t_aeb_gen_cfg_reserved_3e0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3e0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3E4"
	type t_aeb_gen_cfg_reserved_3e4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3e4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3E8"
	type t_aeb_gen_cfg_reserved_3e8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3e8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3EC"
	type t_aeb_gen_cfg_reserved_3ec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3ec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3F0"
	type t_aeb_gen_cfg_reserved_3f0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3f0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3F4"
	type t_aeb_gen_cfg_reserved_3f4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3f4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3F8"
	type t_aeb_gen_cfg_reserved_3f8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3f8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_3FC"
	type t_aeb_gen_cfg_reserved_3fc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_3fc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_400"
	type t_aeb_gen_cfg_reserved_400_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_400_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_404"
	type t_aeb_gen_cfg_reserved_404_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_404_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_408"
	type t_aeb_gen_cfg_reserved_408_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_408_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_40C"
	type t_aeb_gen_cfg_reserved_40c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_40c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_410"
	type t_aeb_gen_cfg_reserved_410_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_410_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_414"
	type t_aeb_gen_cfg_reserved_414_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_414_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_418"
	type t_aeb_gen_cfg_reserved_418_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_418_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_41C"
	type t_aeb_gen_cfg_reserved_41c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_41c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_420"
	type t_aeb_gen_cfg_reserved_420_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_420_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_424"
	type t_aeb_gen_cfg_reserved_424_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_424_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_428"
	type t_aeb_gen_cfg_reserved_428_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_428_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_42C"
	type t_aeb_gen_cfg_reserved_42c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_42c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_430"
	type t_aeb_gen_cfg_reserved_430_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_430_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_434"
	type t_aeb_gen_cfg_reserved_434_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_434_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_438"
	type t_aeb_gen_cfg_reserved_438_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_438_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_43C"
	type t_aeb_gen_cfg_reserved_43c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_43c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_440"
	type t_aeb_gen_cfg_reserved_440_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_440_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_444"
	type t_aeb_gen_cfg_reserved_444_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_444_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_448"
	type t_aeb_gen_cfg_reserved_448_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_448_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_44C"
	type t_aeb_gen_cfg_reserved_44c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_44c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_450"
	type t_aeb_gen_cfg_reserved_450_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_450_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_454"
	type t_aeb_gen_cfg_reserved_454_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_454_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_458"
	type t_aeb_gen_cfg_reserved_458_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_458_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_45C"
	type t_aeb_gen_cfg_reserved_45c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_45c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_460"
	type t_aeb_gen_cfg_reserved_460_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_460_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_464"
	type t_aeb_gen_cfg_reserved_464_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_464_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_468"
	type t_aeb_gen_cfg_reserved_468_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_468_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_46C"
	type t_aeb_gen_cfg_reserved_46c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_46c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_470"
	type t_aeb_gen_cfg_reserved_470_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_470_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_474"
	type t_aeb_gen_cfg_reserved_474_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_474_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_478"
	type t_aeb_gen_cfg_reserved_478_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_478_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_47C"
	type t_aeb_gen_cfg_reserved_47c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_47c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_480"
	type t_aeb_gen_cfg_reserved_480_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_480_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_484"
	type t_aeb_gen_cfg_reserved_484_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_484_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_488"
	type t_aeb_gen_cfg_reserved_488_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_488_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_48C"
	type t_aeb_gen_cfg_reserved_48c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_48c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_490"
	type t_aeb_gen_cfg_reserved_490_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_490_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_494"
	type t_aeb_gen_cfg_reserved_494_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_494_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_498"
	type t_aeb_gen_cfg_reserved_498_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_498_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_49C"
	type t_aeb_gen_cfg_reserved_49c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_49c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4A0"
	type t_aeb_gen_cfg_reserved_4a0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4a0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4A4"
	type t_aeb_gen_cfg_reserved_4a4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4a4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4A8"
	type t_aeb_gen_cfg_reserved_4a8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4a8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4AC"
	type t_aeb_gen_cfg_reserved_4ac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4ac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4B0"
	type t_aeb_gen_cfg_reserved_4b0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4b0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4B4"
	type t_aeb_gen_cfg_reserved_4b4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4b4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4B8"
	type t_aeb_gen_cfg_reserved_4b8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4b8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4BC"
	type t_aeb_gen_cfg_reserved_4bc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4bc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4C0"
	type t_aeb_gen_cfg_reserved_4c0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4c0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4C4"
	type t_aeb_gen_cfg_reserved_4c4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4c4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4C8"
	type t_aeb_gen_cfg_reserved_4c8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4c8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4CC"
	type t_aeb_gen_cfg_reserved_4cc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4cc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4D0"
	type t_aeb_gen_cfg_reserved_4d0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4d0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4D4"
	type t_aeb_gen_cfg_reserved_4d4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4d4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4D8"
	type t_aeb_gen_cfg_reserved_4d8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4d8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4DC"
	type t_aeb_gen_cfg_reserved_4dc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4dc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4E0"
	type t_aeb_gen_cfg_reserved_4e0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4e0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4E4"
	type t_aeb_gen_cfg_reserved_4e4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4e4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4E8"
	type t_aeb_gen_cfg_reserved_4e8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4e8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4EC"
	type t_aeb_gen_cfg_reserved_4ec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4ec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4F0"
	type t_aeb_gen_cfg_reserved_4f0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4f0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4F4"
	type t_aeb_gen_cfg_reserved_4f4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4f4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4F8"
	type t_aeb_gen_cfg_reserved_4f8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4f8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_4FC"
	type t_aeb_gen_cfg_reserved_4fc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_4fc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_500"
	type t_aeb_gen_cfg_reserved_500_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_500_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_504"
	type t_aeb_gen_cfg_reserved_504_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_504_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_508"
	type t_aeb_gen_cfg_reserved_508_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_508_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_50C"
	type t_aeb_gen_cfg_reserved_50c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_50c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_510"
	type t_aeb_gen_cfg_reserved_510_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_510_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_514"
	type t_aeb_gen_cfg_reserved_514_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_514_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_518"
	type t_aeb_gen_cfg_reserved_518_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_518_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_51C"
	type t_aeb_gen_cfg_reserved_51c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_51c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_520"
	type t_aeb_gen_cfg_reserved_520_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_520_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_524"
	type t_aeb_gen_cfg_reserved_524_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_524_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_528"
	type t_aeb_gen_cfg_reserved_528_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_528_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_52C"
	type t_aeb_gen_cfg_reserved_52c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_52c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_530"
	type t_aeb_gen_cfg_reserved_530_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_530_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_534"
	type t_aeb_gen_cfg_reserved_534_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_534_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_538"
	type t_aeb_gen_cfg_reserved_538_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_538_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_53C"
	type t_aeb_gen_cfg_reserved_53c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_53c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_540"
	type t_aeb_gen_cfg_reserved_540_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_540_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_544"
	type t_aeb_gen_cfg_reserved_544_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_544_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_548"
	type t_aeb_gen_cfg_reserved_548_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_548_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_54C"
	type t_aeb_gen_cfg_reserved_54c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_54c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_550"
	type t_aeb_gen_cfg_reserved_550_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_550_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_554"
	type t_aeb_gen_cfg_reserved_554_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_554_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_558"
	type t_aeb_gen_cfg_reserved_558_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_558_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_55C"
	type t_aeb_gen_cfg_reserved_55c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_55c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_560"
	type t_aeb_gen_cfg_reserved_560_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_560_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_564"
	type t_aeb_gen_cfg_reserved_564_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_564_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_568"
	type t_aeb_gen_cfg_reserved_568_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_568_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_56C"
	type t_aeb_gen_cfg_reserved_56c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_56c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_570"
	type t_aeb_gen_cfg_reserved_570_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_570_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_574"
	type t_aeb_gen_cfg_reserved_574_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_574_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_578"
	type t_aeb_gen_cfg_reserved_578_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_578_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_57C"
	type t_aeb_gen_cfg_reserved_57c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_57c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_580"
	type t_aeb_gen_cfg_reserved_580_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_580_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_584"
	type t_aeb_gen_cfg_reserved_584_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_584_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_588"
	type t_aeb_gen_cfg_reserved_588_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_588_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_58C"
	type t_aeb_gen_cfg_reserved_58c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_58c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_590"
	type t_aeb_gen_cfg_reserved_590_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_590_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_594"
	type t_aeb_gen_cfg_reserved_594_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_594_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_598"
	type t_aeb_gen_cfg_reserved_598_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_598_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_59C"
	type t_aeb_gen_cfg_reserved_59c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_59c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5A0"
	type t_aeb_gen_cfg_reserved_5a0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5a0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5A4"
	type t_aeb_gen_cfg_reserved_5a4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5a4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5A8"
	type t_aeb_gen_cfg_reserved_5a8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5a8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5AC"
	type t_aeb_gen_cfg_reserved_5ac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5ac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5B0"
	type t_aeb_gen_cfg_reserved_5b0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5b0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5B4"
	type t_aeb_gen_cfg_reserved_5b4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5b4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5B8"
	type t_aeb_gen_cfg_reserved_5b8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5b8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5BC"
	type t_aeb_gen_cfg_reserved_5bc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5bc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5C0"
	type t_aeb_gen_cfg_reserved_5c0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5c0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5C4"
	type t_aeb_gen_cfg_reserved_5c4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5c4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5C8"
	type t_aeb_gen_cfg_reserved_5c8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5c8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5CC"
	type t_aeb_gen_cfg_reserved_5cc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5cc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5D0"
	type t_aeb_gen_cfg_reserved_5d0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5d0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5D4"
	type t_aeb_gen_cfg_reserved_5d4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5d4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5D8"
	type t_aeb_gen_cfg_reserved_5d8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5d8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5DC"
	type t_aeb_gen_cfg_reserved_5dc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5dc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5E0"
	type t_aeb_gen_cfg_reserved_5e0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5e0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5E4"
	type t_aeb_gen_cfg_reserved_5e4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5e4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5E8"
	type t_aeb_gen_cfg_reserved_5e8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5e8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5EC"
	type t_aeb_gen_cfg_reserved_5ec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5ec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5F0"
	type t_aeb_gen_cfg_reserved_5f0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5f0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5F4"
	type t_aeb_gen_cfg_reserved_5f4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5f4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5F8"
	type t_aeb_gen_cfg_reserved_5f8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5f8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_5FC"
	type t_aeb_gen_cfg_reserved_5fc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_5fc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_600"
	type t_aeb_gen_cfg_reserved_600_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_600_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_604"
	type t_aeb_gen_cfg_reserved_604_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_604_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_608"
	type t_aeb_gen_cfg_reserved_608_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_608_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_60C"
	type t_aeb_gen_cfg_reserved_60c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_60c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_610"
	type t_aeb_gen_cfg_reserved_610_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_610_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_614"
	type t_aeb_gen_cfg_reserved_614_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_614_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_618"
	type t_aeb_gen_cfg_reserved_618_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_618_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_61C"
	type t_aeb_gen_cfg_reserved_61c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_61c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_620"
	type t_aeb_gen_cfg_reserved_620_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_620_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_624"
	type t_aeb_gen_cfg_reserved_624_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_624_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_628"
	type t_aeb_gen_cfg_reserved_628_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_628_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_62C"
	type t_aeb_gen_cfg_reserved_62c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_62c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_630"
	type t_aeb_gen_cfg_reserved_630_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_630_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_634"
	type t_aeb_gen_cfg_reserved_634_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_634_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_638"
	type t_aeb_gen_cfg_reserved_638_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_638_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_63C"
	type t_aeb_gen_cfg_reserved_63c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_63c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_640"
	type t_aeb_gen_cfg_reserved_640_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_640_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_644"
	type t_aeb_gen_cfg_reserved_644_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_644_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_648"
	type t_aeb_gen_cfg_reserved_648_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_648_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_64C"
	type t_aeb_gen_cfg_reserved_64c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_64c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_650"
	type t_aeb_gen_cfg_reserved_650_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_650_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_654"
	type t_aeb_gen_cfg_reserved_654_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_654_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_658"
	type t_aeb_gen_cfg_reserved_658_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_658_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_65C"
	type t_aeb_gen_cfg_reserved_65c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_65c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_660"
	type t_aeb_gen_cfg_reserved_660_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_660_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_664"
	type t_aeb_gen_cfg_reserved_664_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_664_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_668"
	type t_aeb_gen_cfg_reserved_668_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_668_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_66C"
	type t_aeb_gen_cfg_reserved_66c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_66c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_670"
	type t_aeb_gen_cfg_reserved_670_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_670_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_674"
	type t_aeb_gen_cfg_reserved_674_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_674_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_678"
	type t_aeb_gen_cfg_reserved_678_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_678_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_67C"
	type t_aeb_gen_cfg_reserved_67c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_67c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_680"
	type t_aeb_gen_cfg_reserved_680_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_680_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_684"
	type t_aeb_gen_cfg_reserved_684_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_684_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_688"
	type t_aeb_gen_cfg_reserved_688_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_688_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_68C"
	type t_aeb_gen_cfg_reserved_68c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_68c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_690"
	type t_aeb_gen_cfg_reserved_690_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_690_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_694"
	type t_aeb_gen_cfg_reserved_694_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_694_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_698"
	type t_aeb_gen_cfg_reserved_698_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_698_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_69C"
	type t_aeb_gen_cfg_reserved_69c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_69c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6A0"
	type t_aeb_gen_cfg_reserved_6a0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6a0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6A4"
	type t_aeb_gen_cfg_reserved_6a4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6a4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6A8"
	type t_aeb_gen_cfg_reserved_6a8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6a8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6AC"
	type t_aeb_gen_cfg_reserved_6ac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6ac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6B0"
	type t_aeb_gen_cfg_reserved_6b0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6b0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6B4"
	type t_aeb_gen_cfg_reserved_6b4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6b4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6B8"
	type t_aeb_gen_cfg_reserved_6b8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6b8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6BC"
	type t_aeb_gen_cfg_reserved_6bc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6bc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6C0"
	type t_aeb_gen_cfg_reserved_6c0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6c0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6C4"
	type t_aeb_gen_cfg_reserved_6c4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6c4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6C8"
	type t_aeb_gen_cfg_reserved_6c8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6c8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6CC"
	type t_aeb_gen_cfg_reserved_6cc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6cc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6D0"
	type t_aeb_gen_cfg_reserved_6d0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6d0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6D4"
	type t_aeb_gen_cfg_reserved_6d4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6d4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6D8"
	type t_aeb_gen_cfg_reserved_6d8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6d8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6DC"
	type t_aeb_gen_cfg_reserved_6dc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6dc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6E0"
	type t_aeb_gen_cfg_reserved_6e0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6e0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6E4"
	type t_aeb_gen_cfg_reserved_6e4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6e4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6E8"
	type t_aeb_gen_cfg_reserved_6e8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6e8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6EC"
	type t_aeb_gen_cfg_reserved_6ec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6ec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6F0"
	type t_aeb_gen_cfg_reserved_6f0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6f0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6F4"
	type t_aeb_gen_cfg_reserved_6f4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6f4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6F8"
	type t_aeb_gen_cfg_reserved_6f8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6f8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_6FC"
	type t_aeb_gen_cfg_reserved_6fc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_6fc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_700"
	type t_aeb_gen_cfg_reserved_700_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_700_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_704"
	type t_aeb_gen_cfg_reserved_704_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_704_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_708"
	type t_aeb_gen_cfg_reserved_708_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_708_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_70C"
	type t_aeb_gen_cfg_reserved_70c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_70c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_710"
	type t_aeb_gen_cfg_reserved_710_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_710_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_714"
	type t_aeb_gen_cfg_reserved_714_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_714_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_718"
	type t_aeb_gen_cfg_reserved_718_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_718_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_71C"
	type t_aeb_gen_cfg_reserved_71c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_71c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_720"
	type t_aeb_gen_cfg_reserved_720_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_720_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_724"
	type t_aeb_gen_cfg_reserved_724_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_724_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_728"
	type t_aeb_gen_cfg_reserved_728_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_728_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_72C"
	type t_aeb_gen_cfg_reserved_72c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_72c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_730"
	type t_aeb_gen_cfg_reserved_730_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_730_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_734"
	type t_aeb_gen_cfg_reserved_734_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_734_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_738"
	type t_aeb_gen_cfg_reserved_738_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_738_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_73C"
	type t_aeb_gen_cfg_reserved_73c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_73c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_740"
	type t_aeb_gen_cfg_reserved_740_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_740_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_744"
	type t_aeb_gen_cfg_reserved_744_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_744_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_748"
	type t_aeb_gen_cfg_reserved_748_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_748_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_74C"
	type t_aeb_gen_cfg_reserved_74c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_74c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_750"
	type t_aeb_gen_cfg_reserved_750_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_750_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_754"
	type t_aeb_gen_cfg_reserved_754_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_754_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_758"
	type t_aeb_gen_cfg_reserved_758_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_758_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_75C"
	type t_aeb_gen_cfg_reserved_75c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_75c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_760"
	type t_aeb_gen_cfg_reserved_760_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_760_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_764"
	type t_aeb_gen_cfg_reserved_764_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_764_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_768"
	type t_aeb_gen_cfg_reserved_768_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_768_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_76C"
	type t_aeb_gen_cfg_reserved_76c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_76c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_770"
	type t_aeb_gen_cfg_reserved_770_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_770_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_774"
	type t_aeb_gen_cfg_reserved_774_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_774_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_778"
	type t_aeb_gen_cfg_reserved_778_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_778_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_77C"
	type t_aeb_gen_cfg_reserved_77c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_77c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_780"
	type t_aeb_gen_cfg_reserved_780_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_780_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_784"
	type t_aeb_gen_cfg_reserved_784_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_784_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_788"
	type t_aeb_gen_cfg_reserved_788_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_788_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_78C"
	type t_aeb_gen_cfg_reserved_78c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_78c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_790"
	type t_aeb_gen_cfg_reserved_790_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_790_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_794"
	type t_aeb_gen_cfg_reserved_794_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_794_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_798"
	type t_aeb_gen_cfg_reserved_798_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_798_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_79C"
	type t_aeb_gen_cfg_reserved_79c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_79c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7A0"
	type t_aeb_gen_cfg_reserved_7a0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7a0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7A4"
	type t_aeb_gen_cfg_reserved_7a4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7a4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7A8"
	type t_aeb_gen_cfg_reserved_7a8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7a8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7AC"
	type t_aeb_gen_cfg_reserved_7ac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7ac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7B0"
	type t_aeb_gen_cfg_reserved_7b0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7b0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7B4"
	type t_aeb_gen_cfg_reserved_7b4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7b4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7B8"
	type t_aeb_gen_cfg_reserved_7b8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7b8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7BC"
	type t_aeb_gen_cfg_reserved_7bc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7bc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7C0"
	type t_aeb_gen_cfg_reserved_7c0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7c0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7C4"
	type t_aeb_gen_cfg_reserved_7c4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7c4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7C8"
	type t_aeb_gen_cfg_reserved_7c8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7c8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7CC"
	type t_aeb_gen_cfg_reserved_7cc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7cc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7D0"
	type t_aeb_gen_cfg_reserved_7d0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7d0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7D4"
	type t_aeb_gen_cfg_reserved_7d4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7d4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7D8"
	type t_aeb_gen_cfg_reserved_7d8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7d8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7DC"
	type t_aeb_gen_cfg_reserved_7dc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7dc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7E0"
	type t_aeb_gen_cfg_reserved_7e0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7e0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7E4"
	type t_aeb_gen_cfg_reserved_7e4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7e4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7E8"
	type t_aeb_gen_cfg_reserved_7e8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7e8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7EC"
	type t_aeb_gen_cfg_reserved_7ec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7ec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7F0"
	type t_aeb_gen_cfg_reserved_7f0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7f0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7F4"
	type t_aeb_gen_cfg_reserved_7f4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7f4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7F8"
	type t_aeb_gen_cfg_reserved_7f8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7f8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_7FC"
	type t_aeb_gen_cfg_reserved_7fc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_7fc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_800"
	type t_aeb_gen_cfg_reserved_800_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_800_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_804"
	type t_aeb_gen_cfg_reserved_804_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_804_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_808"
	type t_aeb_gen_cfg_reserved_808_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_808_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_80C"
	type t_aeb_gen_cfg_reserved_80c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_80c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_810"
	type t_aeb_gen_cfg_reserved_810_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_810_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_814"
	type t_aeb_gen_cfg_reserved_814_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_814_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_818"
	type t_aeb_gen_cfg_reserved_818_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_818_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_81C"
	type t_aeb_gen_cfg_reserved_81c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_81c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_820"
	type t_aeb_gen_cfg_reserved_820_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_820_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_824"
	type t_aeb_gen_cfg_reserved_824_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_824_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_828"
	type t_aeb_gen_cfg_reserved_828_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_828_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_82C"
	type t_aeb_gen_cfg_reserved_82c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_82c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_830"
	type t_aeb_gen_cfg_reserved_830_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_830_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_834"
	type t_aeb_gen_cfg_reserved_834_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_834_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_838"
	type t_aeb_gen_cfg_reserved_838_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_838_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_83C"
	type t_aeb_gen_cfg_reserved_83c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_83c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_840"
	type t_aeb_gen_cfg_reserved_840_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_840_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_844"
	type t_aeb_gen_cfg_reserved_844_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_844_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_848"
	type t_aeb_gen_cfg_reserved_848_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_848_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_84C"
	type t_aeb_gen_cfg_reserved_84c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_84c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_850"
	type t_aeb_gen_cfg_reserved_850_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_850_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_854"
	type t_aeb_gen_cfg_reserved_854_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_854_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_858"
	type t_aeb_gen_cfg_reserved_858_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_858_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_85C"
	type t_aeb_gen_cfg_reserved_85c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_85c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_860"
	type t_aeb_gen_cfg_reserved_860_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_860_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_864"
	type t_aeb_gen_cfg_reserved_864_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_864_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_868"
	type t_aeb_gen_cfg_reserved_868_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_868_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_86C"
	type t_aeb_gen_cfg_reserved_86c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_86c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_870"
	type t_aeb_gen_cfg_reserved_870_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_870_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_874"
	type t_aeb_gen_cfg_reserved_874_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_874_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_878"
	type t_aeb_gen_cfg_reserved_878_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_878_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_87C"
	type t_aeb_gen_cfg_reserved_87c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_87c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_880"
	type t_aeb_gen_cfg_reserved_880_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_880_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_884"
	type t_aeb_gen_cfg_reserved_884_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_884_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_888"
	type t_aeb_gen_cfg_reserved_888_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_888_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_88C"
	type t_aeb_gen_cfg_reserved_88c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_88c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_890"
	type t_aeb_gen_cfg_reserved_890_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_890_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_894"
	type t_aeb_gen_cfg_reserved_894_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_894_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_898"
	type t_aeb_gen_cfg_reserved_898_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_898_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_89C"
	type t_aeb_gen_cfg_reserved_89c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_89c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8A0"
	type t_aeb_gen_cfg_reserved_8a0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8a0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8A4"
	type t_aeb_gen_cfg_reserved_8a4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8a4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8A8"
	type t_aeb_gen_cfg_reserved_8a8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8a8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8AC"
	type t_aeb_gen_cfg_reserved_8ac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8ac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8B0"
	type t_aeb_gen_cfg_reserved_8b0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8b0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8B4"
	type t_aeb_gen_cfg_reserved_8b4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8b4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8B8"
	type t_aeb_gen_cfg_reserved_8b8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8b8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8BC"
	type t_aeb_gen_cfg_reserved_8bc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8bc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8C0"
	type t_aeb_gen_cfg_reserved_8c0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8c0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8C4"
	type t_aeb_gen_cfg_reserved_8c4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8c4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8C8"
	type t_aeb_gen_cfg_reserved_8c8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8c8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8CC"
	type t_aeb_gen_cfg_reserved_8cc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8cc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8D0"
	type t_aeb_gen_cfg_reserved_8d0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8d0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8D4"
	type t_aeb_gen_cfg_reserved_8d4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8d4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8D8"
	type t_aeb_gen_cfg_reserved_8d8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8d8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8DC"
	type t_aeb_gen_cfg_reserved_8dc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8dc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8E0"
	type t_aeb_gen_cfg_reserved_8e0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8e0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8E4"
	type t_aeb_gen_cfg_reserved_8e4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8e4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8E8"
	type t_aeb_gen_cfg_reserved_8e8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8e8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8EC"
	type t_aeb_gen_cfg_reserved_8ec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8ec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8F0"
	type t_aeb_gen_cfg_reserved_8f0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8f0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8F4"
	type t_aeb_gen_cfg_reserved_8f4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8f4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8F8"
	type t_aeb_gen_cfg_reserved_8f8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8f8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_8FC"
	type t_aeb_gen_cfg_reserved_8fc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_8fc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_900"
	type t_aeb_gen_cfg_reserved_900_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_900_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_904"
	type t_aeb_gen_cfg_reserved_904_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_904_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_908"
	type t_aeb_gen_cfg_reserved_908_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_908_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_90C"
	type t_aeb_gen_cfg_reserved_90c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_90c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_910"
	type t_aeb_gen_cfg_reserved_910_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_910_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_914"
	type t_aeb_gen_cfg_reserved_914_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_914_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_918"
	type t_aeb_gen_cfg_reserved_918_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_918_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_91C"
	type t_aeb_gen_cfg_reserved_91c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_91c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_920"
	type t_aeb_gen_cfg_reserved_920_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_920_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_924"
	type t_aeb_gen_cfg_reserved_924_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_924_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_928"
	type t_aeb_gen_cfg_reserved_928_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_928_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_92C"
	type t_aeb_gen_cfg_reserved_92c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_92c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_930"
	type t_aeb_gen_cfg_reserved_930_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_930_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_934"
	type t_aeb_gen_cfg_reserved_934_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_934_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_938"
	type t_aeb_gen_cfg_reserved_938_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_938_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_93C"
	type t_aeb_gen_cfg_reserved_93c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_93c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_940"
	type t_aeb_gen_cfg_reserved_940_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_940_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_944"
	type t_aeb_gen_cfg_reserved_944_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_944_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_948"
	type t_aeb_gen_cfg_reserved_948_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_948_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_94C"
	type t_aeb_gen_cfg_reserved_94c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_94c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_950"
	type t_aeb_gen_cfg_reserved_950_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_950_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_954"
	type t_aeb_gen_cfg_reserved_954_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_954_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_958"
	type t_aeb_gen_cfg_reserved_958_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_958_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_95C"
	type t_aeb_gen_cfg_reserved_95c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_95c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_960"
	type t_aeb_gen_cfg_reserved_960_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_960_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_964"
	type t_aeb_gen_cfg_reserved_964_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_964_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_968"
	type t_aeb_gen_cfg_reserved_968_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_968_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_96C"
	type t_aeb_gen_cfg_reserved_96c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_96c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_970"
	type t_aeb_gen_cfg_reserved_970_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_970_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_974"
	type t_aeb_gen_cfg_reserved_974_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_974_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_978"
	type t_aeb_gen_cfg_reserved_978_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_978_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_97C"
	type t_aeb_gen_cfg_reserved_97c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_97c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_980"
	type t_aeb_gen_cfg_reserved_980_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_980_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_984"
	type t_aeb_gen_cfg_reserved_984_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_984_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_988"
	type t_aeb_gen_cfg_reserved_988_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_988_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_98C"
	type t_aeb_gen_cfg_reserved_98c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_98c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_990"
	type t_aeb_gen_cfg_reserved_990_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_990_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_994"
	type t_aeb_gen_cfg_reserved_994_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_994_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_998"
	type t_aeb_gen_cfg_reserved_998_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_998_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_99C"
	type t_aeb_gen_cfg_reserved_99c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_99c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9A0"
	type t_aeb_gen_cfg_reserved_9a0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9a0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9A4"
	type t_aeb_gen_cfg_reserved_9a4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9a4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9A8"
	type t_aeb_gen_cfg_reserved_9a8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9a8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9AC"
	type t_aeb_gen_cfg_reserved_9ac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9ac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9B0"
	type t_aeb_gen_cfg_reserved_9b0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9b0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9B4"
	type t_aeb_gen_cfg_reserved_9b4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9b4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9B8"
	type t_aeb_gen_cfg_reserved_9b8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9b8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9BC"
	type t_aeb_gen_cfg_reserved_9bc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9bc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9C0"
	type t_aeb_gen_cfg_reserved_9c0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9c0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9C4"
	type t_aeb_gen_cfg_reserved_9c4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9c4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9C8"
	type t_aeb_gen_cfg_reserved_9c8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9c8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9CC"
	type t_aeb_gen_cfg_reserved_9cc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9cc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9D0"
	type t_aeb_gen_cfg_reserved_9d0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9d0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9D4"
	type t_aeb_gen_cfg_reserved_9d4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9d4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9D8"
	type t_aeb_gen_cfg_reserved_9d8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9d8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9DC"
	type t_aeb_gen_cfg_reserved_9dc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9dc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9E0"
	type t_aeb_gen_cfg_reserved_9e0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9e0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9E4"
	type t_aeb_gen_cfg_reserved_9e4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9e4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9E8"
	type t_aeb_gen_cfg_reserved_9e8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9e8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9EC"
	type t_aeb_gen_cfg_reserved_9ec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9ec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9F0"
	type t_aeb_gen_cfg_reserved_9f0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9f0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9F4"
	type t_aeb_gen_cfg_reserved_9f4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9f4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9F8"
	type t_aeb_gen_cfg_reserved_9f8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9f8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_9FC"
	type t_aeb_gen_cfg_reserved_9fc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_9fc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A00"
	type t_aeb_gen_cfg_reserved_a00_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a00_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A04"
	type t_aeb_gen_cfg_reserved_a04_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a04_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A08"
	type t_aeb_gen_cfg_reserved_a08_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a08_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A0C"
	type t_aeb_gen_cfg_reserved_a0c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a0c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A10"
	type t_aeb_gen_cfg_reserved_a10_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a10_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A14"
	type t_aeb_gen_cfg_reserved_a14_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a14_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A18"
	type t_aeb_gen_cfg_reserved_a18_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a18_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A1C"
	type t_aeb_gen_cfg_reserved_a1c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a1c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A20"
	type t_aeb_gen_cfg_reserved_a20_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a20_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A24"
	type t_aeb_gen_cfg_reserved_a24_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a24_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A28"
	type t_aeb_gen_cfg_reserved_a28_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a28_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A2C"
	type t_aeb_gen_cfg_reserved_a2c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a2c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A30"
	type t_aeb_gen_cfg_reserved_a30_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a30_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A34"
	type t_aeb_gen_cfg_reserved_a34_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a34_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A38"
	type t_aeb_gen_cfg_reserved_a38_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a38_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A3C"
	type t_aeb_gen_cfg_reserved_a3c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a3c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A40"
	type t_aeb_gen_cfg_reserved_a40_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a40_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A44"
	type t_aeb_gen_cfg_reserved_a44_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a44_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A48"
	type t_aeb_gen_cfg_reserved_a48_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a48_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A4C"
	type t_aeb_gen_cfg_reserved_a4c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a4c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A50"
	type t_aeb_gen_cfg_reserved_a50_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a50_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A54"
	type t_aeb_gen_cfg_reserved_a54_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a54_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A58"
	type t_aeb_gen_cfg_reserved_a58_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a58_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A5C"
	type t_aeb_gen_cfg_reserved_a5c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a5c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A60"
	type t_aeb_gen_cfg_reserved_a60_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a60_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A64"
	type t_aeb_gen_cfg_reserved_a64_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a64_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A68"
	type t_aeb_gen_cfg_reserved_a68_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a68_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A6C"
	type t_aeb_gen_cfg_reserved_a6c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a6c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A70"
	type t_aeb_gen_cfg_reserved_a70_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a70_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A74"
	type t_aeb_gen_cfg_reserved_a74_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a74_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A78"
	type t_aeb_gen_cfg_reserved_a78_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a78_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A7C"
	type t_aeb_gen_cfg_reserved_a7c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a7c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A80"
	type t_aeb_gen_cfg_reserved_a80_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a80_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A84"
	type t_aeb_gen_cfg_reserved_a84_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a84_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A88"
	type t_aeb_gen_cfg_reserved_a88_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a88_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A8C"
	type t_aeb_gen_cfg_reserved_a8c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a8c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A90"
	type t_aeb_gen_cfg_reserved_a90_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a90_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A94"
	type t_aeb_gen_cfg_reserved_a94_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a94_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A98"
	type t_aeb_gen_cfg_reserved_a98_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a98_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_A9C"
	type t_aeb_gen_cfg_reserved_a9c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_a9c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AA0"
	type t_aeb_gen_cfg_reserved_aa0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_aa0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AA4"
	type t_aeb_gen_cfg_reserved_aa4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_aa4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AA8"
	type t_aeb_gen_cfg_reserved_aa8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_aa8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AAC"
	type t_aeb_gen_cfg_reserved_aac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_aac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AB0"
	type t_aeb_gen_cfg_reserved_ab0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ab0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AB4"
	type t_aeb_gen_cfg_reserved_ab4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ab4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AB8"
	type t_aeb_gen_cfg_reserved_ab8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ab8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_ABC"
	type t_aeb_gen_cfg_reserved_abc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_abc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AC0"
	type t_aeb_gen_cfg_reserved_ac0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ac0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AC4"
	type t_aeb_gen_cfg_reserved_ac4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ac4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AC8"
	type t_aeb_gen_cfg_reserved_ac8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ac8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_ACC"
	type t_aeb_gen_cfg_reserved_acc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_acc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AD0"
	type t_aeb_gen_cfg_reserved_ad0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ad0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AD4"
	type t_aeb_gen_cfg_reserved_ad4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ad4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AD8"
	type t_aeb_gen_cfg_reserved_ad8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ad8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_ADC"
	type t_aeb_gen_cfg_reserved_adc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_adc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AE0"
	type t_aeb_gen_cfg_reserved_ae0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ae0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AE4"
	type t_aeb_gen_cfg_reserved_ae4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ae4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AE8"
	type t_aeb_gen_cfg_reserved_ae8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ae8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AEC"
	type t_aeb_gen_cfg_reserved_aec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_aec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AF0"
	type t_aeb_gen_cfg_reserved_af0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_af0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AF4"
	type t_aeb_gen_cfg_reserved_af4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_af4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AF8"
	type t_aeb_gen_cfg_reserved_af8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_af8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_AFC"
	type t_aeb_gen_cfg_reserved_afc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_afc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B00"
	type t_aeb_gen_cfg_reserved_b00_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b00_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B04"
	type t_aeb_gen_cfg_reserved_b04_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b04_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B08"
	type t_aeb_gen_cfg_reserved_b08_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b08_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B0C"
	type t_aeb_gen_cfg_reserved_b0c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b0c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B10"
	type t_aeb_gen_cfg_reserved_b10_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b10_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B14"
	type t_aeb_gen_cfg_reserved_b14_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b14_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B18"
	type t_aeb_gen_cfg_reserved_b18_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b18_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B1C"
	type t_aeb_gen_cfg_reserved_b1c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b1c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B20"
	type t_aeb_gen_cfg_reserved_b20_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b20_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B24"
	type t_aeb_gen_cfg_reserved_b24_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b24_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B28"
	type t_aeb_gen_cfg_reserved_b28_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b28_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B2C"
	type t_aeb_gen_cfg_reserved_b2c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b2c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B30"
	type t_aeb_gen_cfg_reserved_b30_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b30_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B34"
	type t_aeb_gen_cfg_reserved_b34_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b34_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B38"
	type t_aeb_gen_cfg_reserved_b38_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b38_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B3C"
	type t_aeb_gen_cfg_reserved_b3c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b3c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B40"
	type t_aeb_gen_cfg_reserved_b40_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b40_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B44"
	type t_aeb_gen_cfg_reserved_b44_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b44_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B48"
	type t_aeb_gen_cfg_reserved_b48_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b48_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B4C"
	type t_aeb_gen_cfg_reserved_b4c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b4c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B50"
	type t_aeb_gen_cfg_reserved_b50_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b50_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B54"
	type t_aeb_gen_cfg_reserved_b54_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b54_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B58"
	type t_aeb_gen_cfg_reserved_b58_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b58_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B5C"
	type t_aeb_gen_cfg_reserved_b5c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b5c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B60"
	type t_aeb_gen_cfg_reserved_b60_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b60_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B64"
	type t_aeb_gen_cfg_reserved_b64_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b64_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B68"
	type t_aeb_gen_cfg_reserved_b68_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b68_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B6C"
	type t_aeb_gen_cfg_reserved_b6c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b6c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B70"
	type t_aeb_gen_cfg_reserved_b70_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b70_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B74"
	type t_aeb_gen_cfg_reserved_b74_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b74_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B78"
	type t_aeb_gen_cfg_reserved_b78_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b78_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B7C"
	type t_aeb_gen_cfg_reserved_b7c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b7c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B80"
	type t_aeb_gen_cfg_reserved_b80_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b80_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B84"
	type t_aeb_gen_cfg_reserved_b84_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b84_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B88"
	type t_aeb_gen_cfg_reserved_b88_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b88_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B8C"
	type t_aeb_gen_cfg_reserved_b8c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b8c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B90"
	type t_aeb_gen_cfg_reserved_b90_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b90_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B94"
	type t_aeb_gen_cfg_reserved_b94_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b94_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B98"
	type t_aeb_gen_cfg_reserved_b98_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b98_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_B9C"
	type t_aeb_gen_cfg_reserved_b9c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_b9c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BA0"
	type t_aeb_gen_cfg_reserved_ba0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ba0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BA4"
	type t_aeb_gen_cfg_reserved_ba4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ba4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BA8"
	type t_aeb_gen_cfg_reserved_ba8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ba8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BAC"
	type t_aeb_gen_cfg_reserved_bac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BB0"
	type t_aeb_gen_cfg_reserved_bb0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bb0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BB4"
	type t_aeb_gen_cfg_reserved_bb4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bb4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BB8"
	type t_aeb_gen_cfg_reserved_bb8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bb8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BBC"
	type t_aeb_gen_cfg_reserved_bbc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bbc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BC0"
	type t_aeb_gen_cfg_reserved_bc0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bc0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BC4"
	type t_aeb_gen_cfg_reserved_bc4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bc4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BC8"
	type t_aeb_gen_cfg_reserved_bc8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bc8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BCC"
	type t_aeb_gen_cfg_reserved_bcc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bcc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BD0"
	type t_aeb_gen_cfg_reserved_bd0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bd0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BD4"
	type t_aeb_gen_cfg_reserved_bd4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bd4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BD8"
	type t_aeb_gen_cfg_reserved_bd8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bd8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BDC"
	type t_aeb_gen_cfg_reserved_bdc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bdc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BE0"
	type t_aeb_gen_cfg_reserved_be0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_be0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BE4"
	type t_aeb_gen_cfg_reserved_be4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_be4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BE8"
	type t_aeb_gen_cfg_reserved_be8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_be8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BEC"
	type t_aeb_gen_cfg_reserved_bec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BF0"
	type t_aeb_gen_cfg_reserved_bf0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bf0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BF4"
	type t_aeb_gen_cfg_reserved_bf4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bf4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BF8"
	type t_aeb_gen_cfg_reserved_bf8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bf8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_BFC"
	type t_aeb_gen_cfg_reserved_bfc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_bfc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C00"
	type t_aeb_gen_cfg_reserved_c00_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c00_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C04"
	type t_aeb_gen_cfg_reserved_c04_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c04_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C08"
	type t_aeb_gen_cfg_reserved_c08_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c08_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C0C"
	type t_aeb_gen_cfg_reserved_c0c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c0c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C10"
	type t_aeb_gen_cfg_reserved_c10_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c10_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C14"
	type t_aeb_gen_cfg_reserved_c14_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c14_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C18"
	type t_aeb_gen_cfg_reserved_c18_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c18_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C1C"
	type t_aeb_gen_cfg_reserved_c1c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c1c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C20"
	type t_aeb_gen_cfg_reserved_c20_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c20_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C24"
	type t_aeb_gen_cfg_reserved_c24_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c24_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C28"
	type t_aeb_gen_cfg_reserved_c28_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c28_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C2C"
	type t_aeb_gen_cfg_reserved_c2c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c2c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C30"
	type t_aeb_gen_cfg_reserved_c30_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c30_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C34"
	type t_aeb_gen_cfg_reserved_c34_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c34_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C38"
	type t_aeb_gen_cfg_reserved_c38_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c38_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C3C"
	type t_aeb_gen_cfg_reserved_c3c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c3c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C40"
	type t_aeb_gen_cfg_reserved_c40_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c40_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C44"
	type t_aeb_gen_cfg_reserved_c44_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c44_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C48"
	type t_aeb_gen_cfg_reserved_c48_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c48_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C4C"
	type t_aeb_gen_cfg_reserved_c4c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c4c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C50"
	type t_aeb_gen_cfg_reserved_c50_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c50_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C54"
	type t_aeb_gen_cfg_reserved_c54_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c54_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C58"
	type t_aeb_gen_cfg_reserved_c58_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c58_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C5C"
	type t_aeb_gen_cfg_reserved_c5c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c5c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C60"
	type t_aeb_gen_cfg_reserved_c60_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c60_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C64"
	type t_aeb_gen_cfg_reserved_c64_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c64_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C68"
	type t_aeb_gen_cfg_reserved_c68_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c68_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C6C"
	type t_aeb_gen_cfg_reserved_c6c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c6c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C70"
	type t_aeb_gen_cfg_reserved_c70_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c70_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C74"
	type t_aeb_gen_cfg_reserved_c74_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c74_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C78"
	type t_aeb_gen_cfg_reserved_c78_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c78_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C7C"
	type t_aeb_gen_cfg_reserved_c7c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c7c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C80"
	type t_aeb_gen_cfg_reserved_c80_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c80_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C84"
	type t_aeb_gen_cfg_reserved_c84_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c84_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C88"
	type t_aeb_gen_cfg_reserved_c88_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c88_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C8C"
	type t_aeb_gen_cfg_reserved_c8c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c8c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C90"
	type t_aeb_gen_cfg_reserved_c90_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c90_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C94"
	type t_aeb_gen_cfg_reserved_c94_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c94_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C98"
	type t_aeb_gen_cfg_reserved_c98_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c98_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_C9C"
	type t_aeb_gen_cfg_reserved_c9c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_c9c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CA0"
	type t_aeb_gen_cfg_reserved_ca0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ca0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CA4"
	type t_aeb_gen_cfg_reserved_ca4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ca4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CA8"
	type t_aeb_gen_cfg_reserved_ca8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ca8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CAC"
	type t_aeb_gen_cfg_reserved_cac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CB0"
	type t_aeb_gen_cfg_reserved_cb0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cb0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CB4"
	type t_aeb_gen_cfg_reserved_cb4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cb4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CB8"
	type t_aeb_gen_cfg_reserved_cb8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cb8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CBC"
	type t_aeb_gen_cfg_reserved_cbc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cbc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CC0"
	type t_aeb_gen_cfg_reserved_cc0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cc0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CC4"
	type t_aeb_gen_cfg_reserved_cc4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cc4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CC8"
	type t_aeb_gen_cfg_reserved_cc8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cc8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CCC"
	type t_aeb_gen_cfg_reserved_ccc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ccc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CD0"
	type t_aeb_gen_cfg_reserved_cd0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cd0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CD4"
	type t_aeb_gen_cfg_reserved_cd4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cd4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CD8"
	type t_aeb_gen_cfg_reserved_cd8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cd8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CDC"
	type t_aeb_gen_cfg_reserved_cdc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cdc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CE0"
	type t_aeb_gen_cfg_reserved_ce0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ce0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CE4"
	type t_aeb_gen_cfg_reserved_ce4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ce4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CE8"
	type t_aeb_gen_cfg_reserved_ce8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ce8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CEC"
	type t_aeb_gen_cfg_reserved_cec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CF0"
	type t_aeb_gen_cfg_reserved_cf0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cf0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CF4"
	type t_aeb_gen_cfg_reserved_cf4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cf4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CF8"
	type t_aeb_gen_cfg_reserved_cf8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cf8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_CFC"
	type t_aeb_gen_cfg_reserved_cfc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_cfc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D00"
	type t_aeb_gen_cfg_reserved_d00_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d00_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D04"
	type t_aeb_gen_cfg_reserved_d04_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d04_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D08"
	type t_aeb_gen_cfg_reserved_d08_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d08_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D0C"
	type t_aeb_gen_cfg_reserved_d0c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d0c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D10"
	type t_aeb_gen_cfg_reserved_d10_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d10_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D14"
	type t_aeb_gen_cfg_reserved_d14_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d14_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D18"
	type t_aeb_gen_cfg_reserved_d18_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d18_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D1C"
	type t_aeb_gen_cfg_reserved_d1c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d1c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D20"
	type t_aeb_gen_cfg_reserved_d20_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d20_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D24"
	type t_aeb_gen_cfg_reserved_d24_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d24_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D28"
	type t_aeb_gen_cfg_reserved_d28_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d28_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D2C"
	type t_aeb_gen_cfg_reserved_d2c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d2c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D30"
	type t_aeb_gen_cfg_reserved_d30_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d30_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D34"
	type t_aeb_gen_cfg_reserved_d34_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d34_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D38"
	type t_aeb_gen_cfg_reserved_d38_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d38_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D3C"
	type t_aeb_gen_cfg_reserved_d3c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d3c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D40"
	type t_aeb_gen_cfg_reserved_d40_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d40_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D44"
	type t_aeb_gen_cfg_reserved_d44_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d44_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D48"
	type t_aeb_gen_cfg_reserved_d48_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d48_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D4C"
	type t_aeb_gen_cfg_reserved_d4c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d4c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D50"
	type t_aeb_gen_cfg_reserved_d50_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d50_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D54"
	type t_aeb_gen_cfg_reserved_d54_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d54_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D58"
	type t_aeb_gen_cfg_reserved_d58_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d58_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D5C"
	type t_aeb_gen_cfg_reserved_d5c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d5c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D60"
	type t_aeb_gen_cfg_reserved_d60_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d60_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D64"
	type t_aeb_gen_cfg_reserved_d64_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d64_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D68"
	type t_aeb_gen_cfg_reserved_d68_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d68_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D6C"
	type t_aeb_gen_cfg_reserved_d6c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d6c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D70"
	type t_aeb_gen_cfg_reserved_d70_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d70_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D74"
	type t_aeb_gen_cfg_reserved_d74_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d74_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D78"
	type t_aeb_gen_cfg_reserved_d78_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d78_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D7C"
	type t_aeb_gen_cfg_reserved_d7c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d7c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D80"
	type t_aeb_gen_cfg_reserved_d80_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d80_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D84"
	type t_aeb_gen_cfg_reserved_d84_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d84_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D88"
	type t_aeb_gen_cfg_reserved_d88_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d88_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D8C"
	type t_aeb_gen_cfg_reserved_d8c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d8c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D90"
	type t_aeb_gen_cfg_reserved_d90_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d90_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D94"
	type t_aeb_gen_cfg_reserved_d94_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d94_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D98"
	type t_aeb_gen_cfg_reserved_d98_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d98_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_D9C"
	type t_aeb_gen_cfg_reserved_d9c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_d9c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DA0"
	type t_aeb_gen_cfg_reserved_da0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_da0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DA4"
	type t_aeb_gen_cfg_reserved_da4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_da4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DA8"
	type t_aeb_gen_cfg_reserved_da8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_da8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DAC"
	type t_aeb_gen_cfg_reserved_dac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_dac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DB0"
	type t_aeb_gen_cfg_reserved_db0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_db0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DB4"
	type t_aeb_gen_cfg_reserved_db4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_db4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DB8"
	type t_aeb_gen_cfg_reserved_db8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_db8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DBC"
	type t_aeb_gen_cfg_reserved_dbc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_dbc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DC0"
	type t_aeb_gen_cfg_reserved_dc0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_dc0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DC4"
	type t_aeb_gen_cfg_reserved_dc4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_dc4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DC8"
	type t_aeb_gen_cfg_reserved_dc8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_dc8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DCC"
	type t_aeb_gen_cfg_reserved_dcc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_dcc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DD0"
	type t_aeb_gen_cfg_reserved_dd0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_dd0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DD4"
	type t_aeb_gen_cfg_reserved_dd4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_dd4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DD8"
	type t_aeb_gen_cfg_reserved_dd8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_dd8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DDC"
	type t_aeb_gen_cfg_reserved_ddc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ddc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DE0"
	type t_aeb_gen_cfg_reserved_de0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_de0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DE4"
	type t_aeb_gen_cfg_reserved_de4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_de4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DE8"
	type t_aeb_gen_cfg_reserved_de8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_de8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DEC"
	type t_aeb_gen_cfg_reserved_dec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_dec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DF0"
	type t_aeb_gen_cfg_reserved_df0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_df0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DF4"
	type t_aeb_gen_cfg_reserved_df4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_df4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DF8"
	type t_aeb_gen_cfg_reserved_df8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_df8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_DFC"
	type t_aeb_gen_cfg_reserved_dfc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_dfc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E00"
	type t_aeb_gen_cfg_reserved_e00_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e00_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E04"
	type t_aeb_gen_cfg_reserved_e04_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e04_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E08"
	type t_aeb_gen_cfg_reserved_e08_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e08_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E0C"
	type t_aeb_gen_cfg_reserved_e0c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e0c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E10"
	type t_aeb_gen_cfg_reserved_e10_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e10_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E14"
	type t_aeb_gen_cfg_reserved_e14_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e14_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E18"
	type t_aeb_gen_cfg_reserved_e18_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e18_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E1C"
	type t_aeb_gen_cfg_reserved_e1c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e1c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E20"
	type t_aeb_gen_cfg_reserved_e20_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e20_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E24"
	type t_aeb_gen_cfg_reserved_e24_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e24_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E28"
	type t_aeb_gen_cfg_reserved_e28_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e28_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E2C"
	type t_aeb_gen_cfg_reserved_e2c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e2c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E30"
	type t_aeb_gen_cfg_reserved_e30_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e30_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E34"
	type t_aeb_gen_cfg_reserved_e34_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e34_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E38"
	type t_aeb_gen_cfg_reserved_e38_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e38_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E3C"
	type t_aeb_gen_cfg_reserved_e3c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e3c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E40"
	type t_aeb_gen_cfg_reserved_e40_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e40_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E44"
	type t_aeb_gen_cfg_reserved_e44_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e44_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E48"
	type t_aeb_gen_cfg_reserved_e48_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e48_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E4C"
	type t_aeb_gen_cfg_reserved_e4c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e4c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E50"
	type t_aeb_gen_cfg_reserved_e50_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e50_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E54"
	type t_aeb_gen_cfg_reserved_e54_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e54_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E58"
	type t_aeb_gen_cfg_reserved_e58_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e58_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E5C"
	type t_aeb_gen_cfg_reserved_e5c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e5c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E60"
	type t_aeb_gen_cfg_reserved_e60_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e60_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E64"
	type t_aeb_gen_cfg_reserved_e64_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e64_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E68"
	type t_aeb_gen_cfg_reserved_e68_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e68_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E6C"
	type t_aeb_gen_cfg_reserved_e6c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e6c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E70"
	type t_aeb_gen_cfg_reserved_e70_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e70_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E74"
	type t_aeb_gen_cfg_reserved_e74_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e74_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E78"
	type t_aeb_gen_cfg_reserved_e78_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e78_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E7C"
	type t_aeb_gen_cfg_reserved_e7c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e7c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E80"
	type t_aeb_gen_cfg_reserved_e80_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e80_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E84"
	type t_aeb_gen_cfg_reserved_e84_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e84_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E88"
	type t_aeb_gen_cfg_reserved_e88_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e88_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E8C"
	type t_aeb_gen_cfg_reserved_e8c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e8c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E90"
	type t_aeb_gen_cfg_reserved_e90_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e90_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E94"
	type t_aeb_gen_cfg_reserved_e94_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e94_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E98"
	type t_aeb_gen_cfg_reserved_e98_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e98_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_E9C"
	type t_aeb_gen_cfg_reserved_e9c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_e9c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EA0"
	type t_aeb_gen_cfg_reserved_ea0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ea0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EA4"
	type t_aeb_gen_cfg_reserved_ea4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ea4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EA8"
	type t_aeb_gen_cfg_reserved_ea8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ea8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EAC"
	type t_aeb_gen_cfg_reserved_eac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_eac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EB0"
	type t_aeb_gen_cfg_reserved_eb0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_eb0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EB4"
	type t_aeb_gen_cfg_reserved_eb4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_eb4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EB8"
	type t_aeb_gen_cfg_reserved_eb8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_eb8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EBC"
	type t_aeb_gen_cfg_reserved_ebc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ebc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EC0"
	type t_aeb_gen_cfg_reserved_ec0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ec0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EC4"
	type t_aeb_gen_cfg_reserved_ec4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ec4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EC8"
	type t_aeb_gen_cfg_reserved_ec8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ec8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_ECC"
	type t_aeb_gen_cfg_reserved_ecc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ecc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_ED0"
	type t_aeb_gen_cfg_reserved_ed0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ed0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_ED4"
	type t_aeb_gen_cfg_reserved_ed4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ed4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_ED8"
	type t_aeb_gen_cfg_reserved_ed8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ed8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EDC"
	type t_aeb_gen_cfg_reserved_edc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_edc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EE0"
	type t_aeb_gen_cfg_reserved_ee0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ee0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EE4"
	type t_aeb_gen_cfg_reserved_ee4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ee4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EE8"
	type t_aeb_gen_cfg_reserved_ee8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ee8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EEC"
	type t_aeb_gen_cfg_reserved_eec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_eec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EF0"
	type t_aeb_gen_cfg_reserved_ef0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ef0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EF4"
	type t_aeb_gen_cfg_reserved_ef4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ef4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EF8"
	type t_aeb_gen_cfg_reserved_ef8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ef8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_EFC"
	type t_aeb_gen_cfg_reserved_efc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_efc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F00"
	type t_aeb_gen_cfg_reserved_f00_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f00_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F04"
	type t_aeb_gen_cfg_reserved_f04_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f04_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F08"
	type t_aeb_gen_cfg_reserved_f08_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f08_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F0C"
	type t_aeb_gen_cfg_reserved_f0c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f0c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F10"
	type t_aeb_gen_cfg_reserved_f10_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f10_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F14"
	type t_aeb_gen_cfg_reserved_f14_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f14_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F18"
	type t_aeb_gen_cfg_reserved_f18_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f18_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F1C"
	type t_aeb_gen_cfg_reserved_f1c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f1c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F20"
	type t_aeb_gen_cfg_reserved_f20_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f20_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F24"
	type t_aeb_gen_cfg_reserved_f24_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f24_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F28"
	type t_aeb_gen_cfg_reserved_f28_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f28_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F2C"
	type t_aeb_gen_cfg_reserved_f2c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f2c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F30"
	type t_aeb_gen_cfg_reserved_f30_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f30_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F34"
	type t_aeb_gen_cfg_reserved_f34_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f34_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F38"
	type t_aeb_gen_cfg_reserved_f38_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f38_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F3C"
	type t_aeb_gen_cfg_reserved_f3c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f3c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F40"
	type t_aeb_gen_cfg_reserved_f40_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f40_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F44"
	type t_aeb_gen_cfg_reserved_f44_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f44_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F48"
	type t_aeb_gen_cfg_reserved_f48_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f48_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F4C"
	type t_aeb_gen_cfg_reserved_f4c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f4c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F50"
	type t_aeb_gen_cfg_reserved_f50_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f50_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F54"
	type t_aeb_gen_cfg_reserved_f54_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f54_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F58"
	type t_aeb_gen_cfg_reserved_f58_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f58_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F5C"
	type t_aeb_gen_cfg_reserved_f5c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f5c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F60"
	type t_aeb_gen_cfg_reserved_f60_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f60_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F64"
	type t_aeb_gen_cfg_reserved_f64_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f64_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F68"
	type t_aeb_gen_cfg_reserved_f68_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f68_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F6C"
	type t_aeb_gen_cfg_reserved_f6c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f6c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F70"
	type t_aeb_gen_cfg_reserved_f70_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f70_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F74"
	type t_aeb_gen_cfg_reserved_f74_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f74_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F78"
	type t_aeb_gen_cfg_reserved_f78_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f78_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F7C"
	type t_aeb_gen_cfg_reserved_f7c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f7c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F80"
	type t_aeb_gen_cfg_reserved_f80_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f80_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F84"
	type t_aeb_gen_cfg_reserved_f84_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f84_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F88"
	type t_aeb_gen_cfg_reserved_f88_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f88_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F8C"
	type t_aeb_gen_cfg_reserved_f8c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f8c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F90"
	type t_aeb_gen_cfg_reserved_f90_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f90_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F94"
	type t_aeb_gen_cfg_reserved_f94_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f94_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F98"
	type t_aeb_gen_cfg_reserved_f98_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f98_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_F9C"
	type t_aeb_gen_cfg_reserved_f9c_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_f9c_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FA0"
	type t_aeb_gen_cfg_reserved_fa0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fa0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FA4"
	type t_aeb_gen_cfg_reserved_fa4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fa4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FA8"
	type t_aeb_gen_cfg_reserved_fa8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fa8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FAC"
	type t_aeb_gen_cfg_reserved_fac_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fac_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FB0"
	type t_aeb_gen_cfg_reserved_fb0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fb0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FB4"
	type t_aeb_gen_cfg_reserved_fb4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fb4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FB8"
	type t_aeb_gen_cfg_reserved_fb8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fb8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FBC"
	type t_aeb_gen_cfg_reserved_fbc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fbc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FC0"
	type t_aeb_gen_cfg_reserved_fc0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fc0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FC4"
	type t_aeb_gen_cfg_reserved_fc4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fc4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FC8"
	type t_aeb_gen_cfg_reserved_fc8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fc8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FCC"
	type t_aeb_gen_cfg_reserved_fcc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fcc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FD0"
	type t_aeb_gen_cfg_reserved_fd0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fd0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FD4"
	type t_aeb_gen_cfg_reserved_fd4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fd4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FD8"
	type t_aeb_gen_cfg_reserved_fd8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fd8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FDC"
	type t_aeb_gen_cfg_reserved_fdc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fdc_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FE0"
	type t_aeb_gen_cfg_reserved_fe0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fe0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FE4"
	type t_aeb_gen_cfg_reserved_fe4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fe4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FE8"
	type t_aeb_gen_cfg_reserved_fe8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fe8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FEC"
	type t_aeb_gen_cfg_reserved_fec_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_fec_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FF0"
	type t_aeb_gen_cfg_reserved_ff0_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ff0_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FF4"
	type t_aeb_gen_cfg_reserved_ff4_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ff4_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FF8"
	type t_aeb_gen_cfg_reserved_ff8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ff8_wr_reg;

	-- AEB General Configuration Area Register "RESERVED_FFC"
	type t_aeb_gen_cfg_reserved_ffc_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_reserved_ffc_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_1"
	type t_aeb_gen_cfg_seq_config_1_wr_reg is record
		reserved_0        : std_logic_vector(1 downto 0); -- "RESERVED_0" Field
		seq_oe_ccd_enable : std_logic;  -- "SEQ_OE_CCD_ENABLE" Field
		seq_oe_spare      : std_logic;  -- "SEQ_OE_SPARE" Field
		seq_oe_tstline    : std_logic;  -- "SEQ_OE_TSTLINE" Field
		seq_oe_tstfrm     : std_logic;  -- "SEQ_OE_TSTFRM" Field
		seq_oe_vaspclamp  : std_logic;  -- "SEQ_OE_VASPCLAMP" Field
		seq_oe_preclamp   : std_logic;  -- "SEQ_OE_PRECLAMP" Field
		seq_oe_ig         : std_logic;  -- "SEQ_OE_IG" Field
		seq_oe_tg         : std_logic;  -- "SEQ_OE_TG" Field
		seq_oe_dg         : std_logic;  -- "SEQ_OE_DG" Field
		seq_oe_rphir      : std_logic;  -- "SEQ_OE_RPHIR" Field
		seq_oe_sw         : std_logic;  -- "SEQ_OE_SW" Field
		seq_oe_rphi3      : std_logic;  -- "SEQ_OE_RPHI3" Field
		seq_oe_rphi2      : std_logic;  -- "SEQ_OE_RPHI2" Field
		seq_oe_rphi1      : std_logic;  -- "SEQ_OE_RPHI1" Field
		seq_oe_sphi4      : std_logic;  -- "SEQ_OE_SPHI4" Field
		seq_oe_sphi3      : std_logic;  -- "SEQ_OE_SPHI3" Field
		seq_oe_sphi2      : std_logic;  -- "SEQ_OE_SPHI2" Field
		seq_oe_sphi1      : std_logic;  -- "SEQ_OE_SPHI1" Field
		seq_oe_iphi4      : std_logic;  -- "SEQ_OE_IPHI4" Field
		seq_oe_iphi3      : std_logic;  -- "SEQ_OE_IPHI3" Field
		seq_oe_iphi2      : std_logic;  -- "SEQ_OE_IPHI2" Field
		seq_oe_iphi1      : std_logic;  -- "SEQ_OE_IPHI1" Field
		reserved_1        : std_logic;  -- "RESERVED_1" Field
		adc_clk_div       : std_logic_vector(6 downto 0); -- "ADC_CLK_DIV" Field
	end record t_aeb_gen_cfg_seq_config_1_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_10"
	type t_aeb_gen_cfg_seq_config_10_wr_reg is record
		lt1_enabled  : std_logic;       -- "LT1_ENABLED" Field
		reserved_0   : std_logic;       -- "RESERVED_0" Field
		lt1_loop_cnt : std_logic_vector(13 downto 0); -- "LT1_LOOP_CNT" Field
		lt2_enabled  : std_logic;       -- "LT2_ENABLED" Field
		reserved_1   : std_logic;       -- "RESERVED_1" Field
		lt2_loop_cnt : std_logic_vector(13 downto 0); -- "LT2_LOOP_CNT" Field
	end record t_aeb_gen_cfg_seq_config_10_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_11"
	type t_aeb_gen_cfg_seq_config_11_wr_reg is record
		lt3_enabled         : std_logic; -- "LT3_ENABLED" Field
		reserved            : std_logic; -- "RESERVED" Field
		lt3_loop_cnt        : std_logic_vector(13 downto 0); -- "LT3_LOOP_CNT" Field
		pix_loop_cnt_word_1 : std_logic_vector(15 downto 0); -- "PIX_LOOP_CNT_WORD_1" Field
	end record t_aeb_gen_cfg_seq_config_11_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_12"
	type t_aeb_gen_cfg_seq_config_12_wr_reg is record
		pix_loop_cnt_word_0 : std_logic_vector(15 downto 0); -- "PIX_LOOP_CNT_WORD_0" Field
		pc_enabled          : std_logic; -- "PC_ENABLED" Field
		reserved            : std_logic; -- "RESERVED" Field
		pc_loop_cnt         : std_logic_vector(13 downto 0); -- "PC_LOOP_CNT" Field
	end record t_aeb_gen_cfg_seq_config_12_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_13"
	type t_aeb_gen_cfg_seq_config_13_wr_reg is record
		reserved_0    : std_logic_vector(1 downto 0); -- "RESERVED_0" Field
		int1_loop_cnt : std_logic_vector(13 downto 0); -- "INT1_LOOP_CNT" Field
		reserved_1    : std_logic_vector(1 downto 0); -- "RESERVED_1" Field
		int2_loop_cnt : std_logic_vector(13 downto 0); -- "INT2_LOOP_CNT" Field
	end record t_aeb_gen_cfg_seq_config_13_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_14"
	type t_aeb_gen_cfg_seq_config_14_wr_reg is record
		reserved_0 : std_logic_vector(6 downto 0); -- "RESERVED_0" Field
		sphi_inv   : std_logic;         -- "SPHI_INV" Field
		reserved_1 : std_logic_vector(6 downto 0); -- "RESERVED_1" Field
		rphi_inv   : std_logic;         -- "RPHI_INV" Field
		reserved_2 : std_logic_vector(15 downto 0); -- "RESERVED_2" Field
	end record t_aeb_gen_cfg_seq_config_14_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_2"
	type t_aeb_gen_cfg_seq_config_2_wr_reg is record
		adc_clk_low_pos  : std_logic_vector(7 downto 0); -- "ADC_CLK_LOW_POS" Field
		adc_clk_high_pos : std_logic_vector(7 downto 0); -- "ADC_CLK_HIGH_POS" Field
		cds_clk_low_pos  : std_logic_vector(7 downto 0); -- "CDS_CLK_LOW_POS" Field
		cds_clk_high_pos : std_logic_vector(7 downto 0); -- "CDS_CLK_HIGH_POS" Field
	end record t_aeb_gen_cfg_seq_config_2_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_3"
	type t_aeb_gen_cfg_seq_config_3_wr_reg is record
		rphir_clk_low_pos  : std_logic_vector(7 downto 0); -- "RPHIR_CLK_LOW_POS" Field
		rphir_clk_high_pos : std_logic_vector(7 downto 0); -- "RPHIR_CLK_HIGH_POS" Field
		rphi1_clk_low_pos  : std_logic_vector(7 downto 0); -- "RPHI1_CLK_LOW_POS" Field
		rphi1_clk_high_pos : std_logic_vector(7 downto 0); -- "RPHI1_CLK_HIGH_POS" Field
	end record t_aeb_gen_cfg_seq_config_3_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_4"
	type t_aeb_gen_cfg_seq_config_4_wr_reg is record
		rphi2_clk_low_pos  : std_logic_vector(7 downto 0); -- "RPHI2_CLK_LOW_POS" Field
		rphi2_clk_high_pos : std_logic_vector(7 downto 0); -- "RPHI2_CLK_HIGH_POS" Field
		rphi3_clk_low_pos  : std_logic_vector(7 downto 0); -- "RPHI3_CLK_LOW_POS" Field
		rphi3_clk_high_pos : std_logic_vector(7 downto 0); -- "RPHI3_CLK_HIGH_POS" Field
	end record t_aeb_gen_cfg_seq_config_4_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_5"
	type t_aeb_gen_cfg_seq_config_5_wr_reg is record
		sw_clk_low_pos  : std_logic_vector(7 downto 0); -- "SW_CLK_LOW_POS" Field
		sw_clk_high_pos : std_logic_vector(7 downto 0); -- "SW_CLK_HIGH_POS" Field
		vasp_out_ctrl   : std_logic;    -- "VASP_OUT_CTRL" Field
		reserved        : std_logic;    -- "RESERVED" Field
		vasp_out_en_pos : std_logic_vector(13 downto 0); -- "VASP_OUT_EN_POS" Field
	end record t_aeb_gen_cfg_seq_config_5_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_6"
	type t_aeb_gen_cfg_seq_config_6_wr_reg is record
		vasp_out_ctrl_inv : std_logic;  -- "VASP_OUT_CTRL_INV" Field
		reserved_0        : std_logic;  -- "RESERVED_0" Field
		vasp_out_dis_pos  : std_logic_vector(13 downto 0); -- "VASP_OUT_DIS_POS" Field
		reserved_1        : std_logic_vector(15 downto 0); -- "RESERVED_1" Field
	end record t_aeb_gen_cfg_seq_config_6_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_7"
	type t_aeb_gen_cfg_seq_config_7_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_seq_config_7_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_8"
	type t_aeb_gen_cfg_seq_config_8_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_aeb_gen_cfg_seq_config_8_wr_reg;

	-- AEB General Configuration Area Register "SEQ_CONFIG_9"
	type t_aeb_gen_cfg_seq_config_9_wr_reg is record
		reserved_0   : std_logic_vector(1 downto 0); -- "RESERVED_0" Field
		ft_loop_cnt  : std_logic_vector(13 downto 0); -- "FT_LOOP_CNT" Field
		lt0_enabled  : std_logic;       -- "LT0_ENABLED" Field
		reserved_1   : std_logic;       -- "RESERVED_1" Field
		lt0_loop_cnt : std_logic_vector(13 downto 0); -- "LT0_LOOP_CNT" Field
	end record t_aeb_gen_cfg_seq_config_9_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2"
	type t_aeb_hk_adc_rd_data_adc_ref_buf_2_wr_reg is record
		new_data                   : std_logic; -- "NEW" Field
		ovf                        : std_logic; -- "OVF" Field
		supply                     : std_logic; -- "SUPPLY" Field
		chid                       : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_adc_ref_buf_2 : std_logic_vector(3 downto 0); -- "ADC_CHX_DATA_ADC_REF_BUF_2" Field
	end record t_aeb_hk_adc_rd_data_adc_ref_buf_2_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V"
	type t_aeb_hk_adc_rd_data_hk_ana_n5v_wr_reg is record
		new_data                : std_logic; -- "NEW" Field
		ovf                     : std_logic; -- "OVF" Field
		supply                  : std_logic; -- "SUPPLY" Field
		chid                    : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_hk_ana_n5v : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_HK_ANA_N5V" Field
	end record t_aeb_hk_adc_rd_data_hk_ana_n5v_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3"
	type t_aeb_hk_adc_rd_data_hk_ana_p3v3_wr_reg is record
		new_data                 : std_logic; -- "NEW" Field
		ovf                      : std_logic; -- "OVF" Field
		supply                   : std_logic; -- "SUPPLY" Field
		chid                     : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_hk_ana_p3v3 : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_HK_ANA_P3V3" Field
	end record t_aeb_hk_adc_rd_data_hk_ana_p3v3_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V"
	type t_aeb_hk_adc_rd_data_hk_ana_p5v_wr_reg is record
		new_data                : std_logic; -- "NEW" Field
		ovf                     : std_logic; -- "OVF" Field
		supply                  : std_logic; -- "SUPPLY" Field
		chid                    : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_hk_ana_p5v : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_HK_ANA_P5V" Field
	end record t_aeb_hk_adc_rd_data_hk_ana_p5v_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V"
	type t_aeb_hk_adc_rd_data_hk_ccd_p31v_wr_reg is record
		new_data                 : std_logic; -- "NEW" Field
		ovf                      : std_logic; -- "OVF" Field
		supply                   : std_logic; -- "SUPPLY" Field
		chid                     : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_hk_ccd_p31v : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_HK_CCD_P31V" Field
	end record t_aeb_hk_adc_rd_data_hk_ccd_p31v_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V"
	type t_aeb_hk_adc_rd_data_hk_clk_p15v_wr_reg is record
		new_data                 : std_logic; -- "NEW" Field
		ovf                      : std_logic; -- "OVF" Field
		supply                   : std_logic; -- "SUPPLY" Field
		chid                     : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_hk_clk_p15v : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_HK_CLK_P15V" Field
	end record t_aeb_hk_adc_rd_data_hk_clk_p15v_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3"
	type t_aeb_hk_adc_rd_data_hk_dig_p3v3_wr_reg is record
		new_data                 : std_logic; -- "NEW" Field
		ovf                      : std_logic; -- "OVF" Field
		supply                   : std_logic; -- "SUPPLY" Field
		chid                     : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_hk_dig_p3v3 : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_HK_DIG_P3V3" Field
	end record t_aeb_hk_adc_rd_data_hk_dig_p3v3_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE"
	type t_aeb_hk_adc_rd_data_hk_vode_wr_reg is record
		new_data             : std_logic; -- "NEW" Field
		ovf                  : std_logic; -- "OVF" Field
		supply               : std_logic; -- "SUPPLY" Field
		chid                 : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_hk_vode : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_HK_VODE" Field
	end record t_aeb_hk_adc_rd_data_hk_vode_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF"
	type t_aeb_hk_adc_rd_data_hk_vodf_wr_reg is record
		new_data             : std_logic; -- "NEW" Field
		ovf                  : std_logic; -- "OVF" Field
		supply               : std_logic; -- "SUPPLY" Field
		chid                 : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_hk_vodf : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_HK_VODF" Field
	end record t_aeb_hk_adc_rd_data_hk_vodf_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG"
	type t_aeb_hk_adc_rd_data_hk_vog_wr_reg is record
		new_data            : std_logic; -- "NEW" Field
		ovf                 : std_logic; -- "OVF" Field
		supply              : std_logic; -- "SUPPLY" Field
		chid                : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_hk_vog : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_HK_VOG" Field
	end record t_aeb_hk_adc_rd_data_hk_vog_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD"
	type t_aeb_hk_adc_rd_data_hk_vrd_wr_reg is record
		new_data            : std_logic; -- "NEW" Field
		ovf                 : std_logic; -- "OVF" Field
		supply              : std_logic; -- "SUPPLY" Field
		chid                : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_hk_vrd : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_HK_VRD" Field
	end record t_aeb_hk_adc_rd_data_hk_vrd_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF"
	type t_aeb_hk_adc_rd_data_s_ref_wr_reg is record
		new_data           : std_logic; -- "NEW" Field
		ovf                : std_logic; -- "OVF" Field
		supply             : std_logic; -- "SUPPLY" Field
		chid               : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_s_ref : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_S_REF" Field
	end record t_aeb_hk_adc_rd_data_s_ref_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P"
	type t_aeb_hk_adc_rd_data_t_bias_p_wr_reg is record
		new_data              : std_logic; -- "NEW" Field
		ovf                   : std_logic; -- "OVF" Field
		supply                : std_logic; -- "SUPPLY" Field
		chid                  : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_t_bias_p : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_T_BIAS_P" Field
	end record t_aeb_hk_adc_rd_data_t_bias_p_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD"
	type t_aeb_hk_adc_rd_data_t_ccd_wr_reg is record
		new_data           : std_logic; -- "NEW" Field
		ovf                : std_logic; -- "OVF" Field
		supply             : std_logic; -- "SUPPLY" Field
		chid               : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_t_ccd : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_T_CCD" Field
	end record t_aeb_hk_adc_rd_data_t_ccd_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P"
	type t_aeb_hk_adc_rd_data_t_hk_p_wr_reg is record
		new_data            : std_logic; -- "NEW" Field
		ovf                 : std_logic; -- "OVF" Field
		supply              : std_logic; -- "SUPPLY" Field
		chid                : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_t_hk_p : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_T_HK_P" Field
	end record t_aeb_hk_adc_rd_data_t_hk_p_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA"
	type t_aeb_hk_adc_rd_data_t_ref1k_mea_wr_reg is record
		new_data                 : std_logic; -- "NEW" Field
		ovf                      : std_logic; -- "OVF" Field
		supply                   : std_logic; -- "SUPPLY" Field
		chid                     : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_t_ref1k_mea : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_T_REF1K_MEA" Field
	end record t_aeb_hk_adc_rd_data_t_ref1k_mea_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA"
	type t_aeb_hk_adc_rd_data_t_ref649r_mea_wr_reg is record
		new_data                   : std_logic; -- "NEW" Field
		ovf                        : std_logic; -- "OVF" Field
		supply                     : std_logic; -- "SUPPLY" Field
		chid                       : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_t_ref649r_mea : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_T_REF649R_MEA" Field
	end record t_aeb_hk_adc_rd_data_t_ref649r_mea_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P"
	type t_aeb_hk_adc_rd_data_t_tou_1_p_wr_reg is record
		new_data               : std_logic; -- "NEW" Field
		ovf                    : std_logic; -- "OVF" Field
		supply                 : std_logic; -- "SUPPLY" Field
		chid                   : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_t_tou_1_p : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_T_TOU_1_P" Field
	end record t_aeb_hk_adc_rd_data_t_tou_1_p_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P"
	type t_aeb_hk_adc_rd_data_t_tou_2_p_wr_reg is record
		new_data               : std_logic; -- "NEW" Field
		ovf                    : std_logic; -- "OVF" Field
		supply                 : std_logic; -- "SUPPLY" Field
		chid                   : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_t_tou_2_p : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_T_TOU_2_P" Field
	end record t_aeb_hk_adc_rd_data_t_tou_2_p_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L"
	type t_aeb_hk_adc_rd_data_t_vasp_l_wr_reg is record
		new_data              : std_logic; -- "NEW" Field
		ovf                   : std_logic; -- "OVF" Field
		supply                : std_logic; -- "SUPPLY" Field
		chid                  : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_t_vasp_l : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_T_VASP_L" Field
	end record t_aeb_hk_adc_rd_data_t_vasp_l_wr_reg;

	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R"
	type t_aeb_hk_adc_rd_data_t_vasp_r_wr_reg is record
		new_data              : std_logic; -- "NEW" Field
		ovf                   : std_logic; -- "OVF" Field
		supply                : std_logic; -- "SUPPLY" Field
		chid                  : std_logic_vector(4 downto 0); -- "CHID" Field
		adc_chx_data_t_vasp_r : std_logic_vector(23 downto 0); -- "ADC_CHX_DATA_T_VASP_R" Field
	end record t_aeb_hk_adc_rd_data_t_vasp_r_wr_reg;

	-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1"
	type t_aeb_hk_adc1_rd_config_1_wr_reg is record
		spirst : std_logic;             -- "SPIRST" Field
		muxmod : std_logic;             -- "MUXMOD" Field
		bypas  : std_logic;             -- "BYPAS" Field
		clkenb : std_logic;             -- "CLKENB" Field
		chop   : std_logic;             -- "CHOP" Field
		stat   : std_logic;             -- "STAT" Field
		idlmod : std_logic;             -- "IDLMOD" Field
		dly2   : std_logic;             -- "DLY2" Field
		dly1   : std_logic;             -- "DLY1" Field
		dly0   : std_logic;             -- "DLY0" Field
		sbcs1  : std_logic;             -- "SBCS1" Field
		sbcs0  : std_logic;             -- "SBCS0" Field
		drate1 : std_logic;             -- "DRATE1" Field
		drate0 : std_logic;             -- "DRATE0" Field
		ainp3  : std_logic;             -- "AINP3" Field
		ainp2  : std_logic;             -- "AINP2" Field
		ainp1  : std_logic;             -- "AINP1" Field
		ainp0  : std_logic;             -- "AINP0" Field
		ainn3  : std_logic;             -- "AINN3" Field
		ainn2  : std_logic;             -- "AINN2" Field
		ainn1  : std_logic;             -- "AINN1" Field
		ainn0  : std_logic;             -- "AINN0" Field
		diff7  : std_logic;             -- "DIFF7" Field
		diff6  : std_logic;             -- "DIFF6" Field
		diff5  : std_logic;             -- "DIFF5" Field
		diff4  : std_logic;             -- "DIFF4" Field
		diff3  : std_logic;             -- "DIFF3" Field
		diff2  : std_logic;             -- "DIFF2" Field
		diff1  : std_logic;             -- "DIFF1" Field
		diff0  : std_logic;             -- "DIFF0" Field
	end record t_aeb_hk_adc1_rd_config_1_wr_reg;

	-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2"
	type t_aeb_hk_adc1_rd_config_2_wr_reg is record
		ain7   : std_logic;             -- "AIN7" Field
		ain6   : std_logic;             -- "AIN6" Field
		ain5   : std_logic;             -- "AIN5" Field
		ain4   : std_logic;             -- "AIN4" Field
		ain3   : std_logic;             -- "AIN3" Field
		ain2   : std_logic;             -- "AIN2" Field
		ain1   : std_logic;             -- "AIN1" Field
		ain0   : std_logic;             -- "AIN0" Field
		ain15  : std_logic;             -- "AIN15" Field
		ain14  : std_logic;             -- "AIN14" Field
		ain13  : std_logic;             -- "AIN13" Field
		ain12  : std_logic;             -- "AIN12" Field
		ain11  : std_logic;             -- "AIN11" Field
		ain10  : std_logic;             -- "AIN10" Field
		ain9   : std_logic;             -- "AIN9" Field
		ain8   : std_logic;             -- "AIN8" Field
		ref    : std_logic;             -- "REF" Field
		gain   : std_logic;             -- "GAIN" Field
		temp   : std_logic;             -- "TEMP" Field
		vcc    : std_logic;             -- "VCC" Field
		offset : std_logic;             -- "OFFSET" Field
		cio7   : std_logic;             -- "CIO7" Field
		cio6   : std_logic;             -- "CIO6" Field
		cio5   : std_logic;             -- "CIO5" Field
		cio4   : std_logic;             -- "CIO4" Field
		cio3   : std_logic;             -- "CIO3" Field
		cio2   : std_logic;             -- "CIO2" Field
		cio1   : std_logic;             -- "CIO1" Field
		cio0   : std_logic;             -- "CIO0" Field
	end record t_aeb_hk_adc1_rd_config_2_wr_reg;

	-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3"
	type t_aeb_hk_adc1_rd_config_3_wr_reg is record
		dio7 : std_logic;               -- "DIO7" Field
		dio6 : std_logic;               -- "DIO6" Field
		dio5 : std_logic;               -- "DIO5" Field
		dio4 : std_logic;               -- "DIO4" Field
		dio3 : std_logic;               -- "DIO3" Field
		dio2 : std_logic;               -- "DIO2" Field
		dio1 : std_logic;               -- "DIO1" Field
		dio0 : std_logic;               -- "DIO0" Field
	end record t_aeb_hk_adc1_rd_config_3_wr_reg;

	-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1"
	type t_aeb_hk_adc2_rd_config_1_wr_reg is record
		spirst : std_logic;             -- "SPIRST" Field
		muxmod : std_logic;             -- "MUXMOD" Field
		bypas  : std_logic;             -- "BYPAS" Field
		clkenb : std_logic;             -- "CLKENB" Field
		chop   : std_logic;             -- "CHOP" Field
		stat   : std_logic;             -- "STAT" Field
		idlmod : std_logic;             -- "IDLMOD" Field
		dly2   : std_logic;             -- "DLY2" Field
		dly1   : std_logic;             -- "DLY1" Field
		dly0   : std_logic;             -- "DLY0" Field
		sbcs1  : std_logic;             -- "SBCS1" Field
		sbcs0  : std_logic;             -- "SBCS0" Field
		drate1 : std_logic;             -- "DRATE1" Field
		drate0 : std_logic;             -- "DRATE0" Field
		ainp3  : std_logic;             -- "AINP3" Field
		ainp2  : std_logic;             -- "AINP2" Field
		ainp1  : std_logic;             -- "AINP1" Field
		ainp0  : std_logic;             -- "AINP0" Field
		ainn3  : std_logic;             -- "AINN3" Field
		ainn2  : std_logic;             -- "AINN2" Field
		ainn1  : std_logic;             -- "AINN1" Field
		ainn0  : std_logic;             -- "AINN0" Field
		diff7  : std_logic;             -- "DIFF7" Field
		diff6  : std_logic;             -- "DIFF6" Field
		diff5  : std_logic;             -- "DIFF5" Field
		diff4  : std_logic;             -- "DIFF4" Field
		diff3  : std_logic;             -- "DIFF3" Field
		diff2  : std_logic;             -- "DIFF2" Field
		diff1  : std_logic;             -- "DIFF1" Field
		diff0  : std_logic;             -- "DIFF0" Field
	end record t_aeb_hk_adc2_rd_config_1_wr_reg;

	-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2"
	type t_aeb_hk_adc2_rd_config_2_wr_reg is record
		ain7   : std_logic;             -- "AIN7" Field
		ain6   : std_logic;             -- "AIN6" Field
		ain5   : std_logic;             -- "AIN5" Field
		ain4   : std_logic;             -- "AIN4" Field
		ain3   : std_logic;             -- "AIN3" Field
		ain2   : std_logic;             -- "AIN2" Field
		ain1   : std_logic;             -- "AIN1" Field
		ain0   : std_logic;             -- "AIN0" Field
		ain15  : std_logic;             -- "AIN15" Field
		ain14  : std_logic;             -- "AIN14" Field
		ain13  : std_logic;             -- "AIN13" Field
		ain12  : std_logic;             -- "AIN12" Field
		ain11  : std_logic;             -- "AIN11" Field
		ain10  : std_logic;             -- "AIN10" Field
		ain9   : std_logic;             -- "AIN9" Field
		ain8   : std_logic;             -- "AIN8" Field
		ref    : std_logic;             -- "REF" Field
		gain   : std_logic;             -- "GAIN" Field
		temp   : std_logic;             -- "TEMP" Field
		vcc    : std_logic;             -- "VCC" Field
		offset : std_logic;             -- "OFFSET" Field
		cio7   : std_logic;             -- "CIO7" Field
		cio6   : std_logic;             -- "CIO6" Field
		cio5   : std_logic;             -- "CIO5" Field
		cio4   : std_logic;             -- "CIO4" Field
		cio3   : std_logic;             -- "CIO3" Field
		cio2   : std_logic;             -- "CIO2" Field
		cio1   : std_logic;             -- "CIO1" Field
		cio0   : std_logic;             -- "CIO0" Field
	end record t_aeb_hk_adc2_rd_config_2_wr_reg;

	-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3"
	type t_aeb_hk_adc2_rd_config_3_wr_reg is record
		dio7 : std_logic;               -- "DIO7" Field
		dio6 : std_logic;               -- "DIO6" Field
		dio5 : std_logic;               -- "DIO5" Field
		dio4 : std_logic;               -- "DIO4" Field
		dio3 : std_logic;               -- "DIO3" Field
		dio2 : std_logic;               -- "DIO2" Field
		dio1 : std_logic;               -- "DIO1" Field
		dio0 : std_logic;               -- "DIO0" Field
	end record t_aeb_hk_adc2_rd_config_3_wr_reg;

	-- AEB Housekeeping Area Register "AEB_STATUS"
	type t_aeb_hk_aeb_status_wr_reg is record
		aeb_status     : std_logic_vector(3 downto 0); -- "AEB_STATUS" Field
		vasp2_cfg_run  : std_logic;     -- "VASP2_CFG_RUN" Field
		vasp1_cfg_run  : std_logic;     -- "VASP1_CFG_RUN" Field
		dac_cfg_wr_run : std_logic;     -- "DAC_CFG_WR_RUN" Field
		adc_cfg_rd_run : std_logic;     -- "ADC_CFG_RD_RUN" Field
		adc_cfg_wr_run : std_logic;     -- "ADC_CFG_WR_RUN" Field
		adc_dat_rd_run : std_logic;     -- "ADC_DAT_RD_RUN" Field
		adc_error      : std_logic;     -- "ADC_ERROR" Field
		adc2_lu        : std_logic;     -- "ADC2_LU" Field
		adc1_lu        : std_logic;     -- "ADC1_LU" Field
		adc_dat_rd     : std_logic;     -- "ADC_DAT_RD" Field
		adc_cfg_rd     : std_logic;     -- "ADC_CFG_RD" Field
		adc_cfg_wr     : std_logic;     -- "ADC_CFG_WR" Field
		adc2_busy      : std_logic;     -- "ADC2_BUSY" Field
		adc1_busy      : std_logic;     -- "ADC1_BUSY" Field
	end record t_aeb_hk_aeb_status_wr_reg;

	-- AEB Housekeeping Area Register "REVISION_ID_1"
	type t_aeb_hk_revision_id_1_wr_reg is record
		fpga_version : std_logic_vector(15 downto 0); -- "FPGA_VERSION" Field
		fpga_date    : std_logic_vector(15 downto 0); -- "FPGA_DATE" Field
	end record t_aeb_hk_revision_id_1_wr_reg;

	-- AEB Housekeeping Area Register "REVISION_ID_2"
	type t_aeb_hk_revision_id_2_wr_reg is record
		fpga_time_h : std_logic_vector(15 downto 0); -- "FPGA_TIME_H" Field
		fpga_time_m : std_logic_vector(7 downto 0); -- "FPGA_TIME_M" Field
		fpga_svn    : std_logic_vector(15 downto 0); -- "FPGA_SVN" Field
	end record t_aeb_hk_revision_id_2_wr_reg;

	-- AEB Housekeeping Area Register "TIMESTAMP_1"
	type t_aeb_hk_timestamp_1_wr_reg is record
		timestamp_dword_1 : std_logic_vector(31 downto 0); -- "TIMESTAMP_DWORD_1" Field
	end record t_aeb_hk_timestamp_1_wr_reg;

	-- AEB Housekeeping Area Register "TIMESTAMP_2"
	type t_aeb_hk_timestamp_2_wr_reg is record
		timestamp_dword_0 : std_logic_vector(31 downto 0); -- "TIMESTAMP_DWORD_0" Field
	end record t_aeb_hk_timestamp_2_wr_reg;

	-- AEB Housekeeping Area Register "VASP_RD_CONFIG"
	type t_aeb_hk_vasp_rd_config_wr_reg is record
		vasp1_read_data : std_logic_vector(7 downto 0); -- "VASP1_READ_DATA" Field
		vasp2_read_data : std_logic_vector(7 downto 0); -- "VASP2_READ_DATA" Field
	end record t_aeb_hk_vasp_rd_config_wr_reg;

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_rmap_memory_wr_area is record
		aeb_crit_cfg_aeb_config_ait      : t_aeb_crit_cfg_aeb_config_ait_wr_reg; -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT"
		aeb_crit_cfg_aeb_config_key      : t_aeb_crit_cfg_aeb_config_key_wr_reg; -- AEB Critical Configuration Area Register "AEB_CONFIG_KEY"
		aeb_crit_cfg_aeb_config_pattern  : t_aeb_crit_cfg_aeb_config_pattern_wr_reg; -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN"
		aeb_crit_cfg_aeb_config          : t_aeb_crit_cfg_aeb_config_wr_reg; -- AEB Critical Configuration Area Register "AEB_CONFIG"
		aeb_crit_cfg_aeb_control         : t_aeb_crit_cfg_aeb_control_wr_reg; -- AEB Critical Configuration Area Register "AEB_CONTROL"
		aeb_crit_cfg_dac_config_1        : t_aeb_crit_cfg_dac_config_1_wr_reg; -- AEB Critical Configuration Area Register "DAC_CONFIG_1"
		aeb_crit_cfg_dac_config_2        : t_aeb_crit_cfg_dac_config_2_wr_reg; -- AEB Critical Configuration Area Register "DAC_CONFIG_2"
		aeb_crit_cfg_pwr_config1         : t_aeb_crit_cfg_pwr_config1_wr_reg; -- AEB Critical Configuration Area Register "PWR_CONFIG1"
		aeb_crit_cfg_pwr_config2         : t_aeb_crit_cfg_pwr_config2_wr_reg; -- AEB Critical Configuration Area Register "PWR_CONFIG2"
		aeb_crit_cfg_pwr_config3         : t_aeb_crit_cfg_pwr_config3_wr_reg; -- AEB Critical Configuration Area Register "PWR_CONFIG3"
		aeb_crit_cfg_reserved_20         : t_aeb_crit_cfg_reserved_20_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_20"
		aeb_crit_cfg_reserved_30         : t_aeb_crit_cfg_reserved_30_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_30"
		aeb_crit_cfg_reserved_34         : t_aeb_crit_cfg_reserved_34_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_34"
		aeb_crit_cfg_reserved_38         : t_aeb_crit_cfg_reserved_38_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_38"
		aeb_crit_cfg_reserved_3c         : t_aeb_crit_cfg_reserved_3c_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_3C"
		aeb_crit_cfg_reserved_40         : t_aeb_crit_cfg_reserved_40_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_40"
		aeb_crit_cfg_reserved_44         : t_aeb_crit_cfg_reserved_44_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_44"
		aeb_crit_cfg_reserved_48         : t_aeb_crit_cfg_reserved_48_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_48"
		aeb_crit_cfg_reserved_4c         : t_aeb_crit_cfg_reserved_4c_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_4C"
		aeb_crit_cfg_reserved_50         : t_aeb_crit_cfg_reserved_50_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_50"
		aeb_crit_cfg_reserved_54         : t_aeb_crit_cfg_reserved_54_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_54"
		aeb_crit_cfg_reserved_58         : t_aeb_crit_cfg_reserved_58_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_58"
		aeb_crit_cfg_reserved_5c         : t_aeb_crit_cfg_reserved_5c_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_5C"
		aeb_crit_cfg_reserved_60         : t_aeb_crit_cfg_reserved_60_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_60"
		aeb_crit_cfg_reserved_64         : t_aeb_crit_cfg_reserved_64_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_64"
		aeb_crit_cfg_reserved_68         : t_aeb_crit_cfg_reserved_68_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_68"
		aeb_crit_cfg_reserved_6c         : t_aeb_crit_cfg_reserved_6c_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_6C"
		aeb_crit_cfg_reserved_70         : t_aeb_crit_cfg_reserved_70_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_70"
		aeb_crit_cfg_reserved_74         : t_aeb_crit_cfg_reserved_74_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_74"
		aeb_crit_cfg_reserved_78         : t_aeb_crit_cfg_reserved_78_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_78"
		aeb_crit_cfg_reserved_7c         : t_aeb_crit_cfg_reserved_7c_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_7C"
		aeb_crit_cfg_reserved_80         : t_aeb_crit_cfg_reserved_80_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_80"
		aeb_crit_cfg_reserved_84         : t_aeb_crit_cfg_reserved_84_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_84"
		aeb_crit_cfg_reserved_88         : t_aeb_crit_cfg_reserved_88_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_88"
		aeb_crit_cfg_reserved_8c         : t_aeb_crit_cfg_reserved_8c_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_8C"
		aeb_crit_cfg_reserved_90         : t_aeb_crit_cfg_reserved_90_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_90"
		aeb_crit_cfg_reserved_94         : t_aeb_crit_cfg_reserved_94_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_94"
		aeb_crit_cfg_reserved_98         : t_aeb_crit_cfg_reserved_98_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_98"
		aeb_crit_cfg_reserved_9c         : t_aeb_crit_cfg_reserved_9c_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_9C"
		aeb_crit_cfg_reserved_a0         : t_aeb_crit_cfg_reserved_a0_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_A0"
		aeb_crit_cfg_reserved_a4         : t_aeb_crit_cfg_reserved_a4_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_A4"
		aeb_crit_cfg_reserved_a8         : t_aeb_crit_cfg_reserved_a8_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_A8"
		aeb_crit_cfg_reserved_ac         : t_aeb_crit_cfg_reserved_ac_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_AC"
		aeb_crit_cfg_reserved_b0         : t_aeb_crit_cfg_reserved_b0_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_B0"
		aeb_crit_cfg_reserved_b4         : t_aeb_crit_cfg_reserved_b4_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_B4"
		aeb_crit_cfg_reserved_b8         : t_aeb_crit_cfg_reserved_b8_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_B8"
		aeb_crit_cfg_reserved_bc         : t_aeb_crit_cfg_reserved_bc_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_BC"
		aeb_crit_cfg_reserved_c0         : t_aeb_crit_cfg_reserved_c0_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_C0"
		aeb_crit_cfg_reserved_c4         : t_aeb_crit_cfg_reserved_c4_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_C4"
		aeb_crit_cfg_reserved_c8         : t_aeb_crit_cfg_reserved_c8_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_C8"
		aeb_crit_cfg_reserved_cc         : t_aeb_crit_cfg_reserved_cc_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_CC"
		aeb_crit_cfg_reserved_d0         : t_aeb_crit_cfg_reserved_d0_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_D0"
		aeb_crit_cfg_reserved_d4         : t_aeb_crit_cfg_reserved_d4_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_D4"
		aeb_crit_cfg_reserved_d8         : t_aeb_crit_cfg_reserved_d8_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_D8"
		aeb_crit_cfg_reserved_dc         : t_aeb_crit_cfg_reserved_dc_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_DC"
		aeb_crit_cfg_reserved_e0         : t_aeb_crit_cfg_reserved_e0_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_E0"
		aeb_crit_cfg_reserved_e4         : t_aeb_crit_cfg_reserved_e4_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_E4"
		aeb_crit_cfg_reserved_e8         : t_aeb_crit_cfg_reserved_e8_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_E8"
		aeb_crit_cfg_reserved_ec         : t_aeb_crit_cfg_reserved_ec_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_EC"
		aeb_crit_cfg_reserved_f0         : t_aeb_crit_cfg_reserved_f0_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_F0"
		aeb_crit_cfg_reserved_f4         : t_aeb_crit_cfg_reserved_f4_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_F4"
		aeb_crit_cfg_reserved_f8         : t_aeb_crit_cfg_reserved_f8_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_F8"
		aeb_crit_cfg_reserved_fc         : t_aeb_crit_cfg_reserved_fc_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_FC"
		aeb_crit_cfg_vasp_i2c_control    : t_aeb_crit_cfg_vasp_i2c_control_wr_reg; -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL"
		aeb_gen_cfg_adc1_config_1        : t_aeb_gen_cfg_adc1_config_1_wr_reg; -- AEB General Configuration Area Register "ADC1_CONFIG_1"
		aeb_gen_cfg_adc1_config_2        : t_aeb_gen_cfg_adc1_config_2_wr_reg; -- AEB General Configuration Area Register "ADC1_CONFIG_2"
		aeb_gen_cfg_adc1_config_3        : t_aeb_gen_cfg_adc1_config_3_wr_reg; -- AEB General Configuration Area Register "ADC1_CONFIG_3"
		aeb_gen_cfg_adc2_config_1        : t_aeb_gen_cfg_adc2_config_1_wr_reg; -- AEB General Configuration Area Register "ADC2_CONFIG_1"
		aeb_gen_cfg_adc2_config_2        : t_aeb_gen_cfg_adc2_config_2_wr_reg; -- AEB General Configuration Area Register "ADC2_CONFIG_2"
		aeb_gen_cfg_adc2_config_3        : t_aeb_gen_cfg_adc2_config_3_wr_reg; -- AEB General Configuration Area Register "ADC2_CONFIG_3"
		aeb_gen_cfg_reserved_118         : t_aeb_gen_cfg_reserved_118_wr_reg; -- AEB General Configuration Area Register "RESERVED_118"
		aeb_gen_cfg_reserved_11c         : t_aeb_gen_cfg_reserved_11c_wr_reg; -- AEB General Configuration Area Register "RESERVED_11C"
		aeb_gen_cfg_reserved_158         : t_aeb_gen_cfg_reserved_158_wr_reg; -- AEB General Configuration Area Register "RESERVED_158"
		aeb_gen_cfg_reserved_15c         : t_aeb_gen_cfg_reserved_15c_wr_reg; -- AEB General Configuration Area Register "RESERVED_15C"
		aeb_gen_cfg_reserved_160         : t_aeb_gen_cfg_reserved_160_wr_reg; -- AEB General Configuration Area Register "RESERVED_160"
		aeb_gen_cfg_reserved_164         : t_aeb_gen_cfg_reserved_164_wr_reg; -- AEB General Configuration Area Register "RESERVED_164"
		aeb_gen_cfg_reserved_168         : t_aeb_gen_cfg_reserved_168_wr_reg; -- AEB General Configuration Area Register "RESERVED_168"
		aeb_gen_cfg_reserved_16c         : t_aeb_gen_cfg_reserved_16c_wr_reg; -- AEB General Configuration Area Register "RESERVED_16C"
		aeb_gen_cfg_reserved_170         : t_aeb_gen_cfg_reserved_170_wr_reg; -- AEB General Configuration Area Register "RESERVED_170"
		aeb_gen_cfg_reserved_174         : t_aeb_gen_cfg_reserved_174_wr_reg; -- AEB General Configuration Area Register "RESERVED_174"
		aeb_gen_cfg_reserved_178         : t_aeb_gen_cfg_reserved_178_wr_reg; -- AEB General Configuration Area Register "RESERVED_178"
		aeb_gen_cfg_reserved_17c         : t_aeb_gen_cfg_reserved_17c_wr_reg; -- AEB General Configuration Area Register "RESERVED_17C"
		aeb_gen_cfg_reserved_180         : t_aeb_gen_cfg_reserved_180_wr_reg; -- AEB General Configuration Area Register "RESERVED_180"
		aeb_gen_cfg_reserved_184         : t_aeb_gen_cfg_reserved_184_wr_reg; -- AEB General Configuration Area Register "RESERVED_184"
		aeb_gen_cfg_reserved_188         : t_aeb_gen_cfg_reserved_188_wr_reg; -- AEB General Configuration Area Register "RESERVED_188"
		aeb_gen_cfg_reserved_18c         : t_aeb_gen_cfg_reserved_18c_wr_reg; -- AEB General Configuration Area Register "RESERVED_18C"
		aeb_gen_cfg_reserved_190         : t_aeb_gen_cfg_reserved_190_wr_reg; -- AEB General Configuration Area Register "RESERVED_190"
		aeb_gen_cfg_reserved_194         : t_aeb_gen_cfg_reserved_194_wr_reg; -- AEB General Configuration Area Register "RESERVED_194"
		aeb_gen_cfg_reserved_198         : t_aeb_gen_cfg_reserved_198_wr_reg; -- AEB General Configuration Area Register "RESERVED_198"
		aeb_gen_cfg_reserved_19c         : t_aeb_gen_cfg_reserved_19c_wr_reg; -- AEB General Configuration Area Register "RESERVED_19C"
		aeb_gen_cfg_reserved_1a0         : t_aeb_gen_cfg_reserved_1a0_wr_reg; -- AEB General Configuration Area Register "RESERVED_1A0"
		aeb_gen_cfg_reserved_1a4         : t_aeb_gen_cfg_reserved_1a4_wr_reg; -- AEB General Configuration Area Register "RESERVED_1A4"
		aeb_gen_cfg_reserved_1a8         : t_aeb_gen_cfg_reserved_1a8_wr_reg; -- AEB General Configuration Area Register "RESERVED_1A8"
		aeb_gen_cfg_reserved_1ac         : t_aeb_gen_cfg_reserved_1ac_wr_reg; -- AEB General Configuration Area Register "RESERVED_1AC"
		aeb_gen_cfg_reserved_1b0         : t_aeb_gen_cfg_reserved_1b0_wr_reg; -- AEB General Configuration Area Register "RESERVED_1B0"
		aeb_gen_cfg_reserved_1b4         : t_aeb_gen_cfg_reserved_1b4_wr_reg; -- AEB General Configuration Area Register "RESERVED_1B4"
		aeb_gen_cfg_reserved_1b8         : t_aeb_gen_cfg_reserved_1b8_wr_reg; -- AEB General Configuration Area Register "RESERVED_1B8"
		aeb_gen_cfg_reserved_1bc         : t_aeb_gen_cfg_reserved_1bc_wr_reg; -- AEB General Configuration Area Register "RESERVED_1BC"
		aeb_gen_cfg_reserved_1c0         : t_aeb_gen_cfg_reserved_1c0_wr_reg; -- AEB General Configuration Area Register "RESERVED_1C0"
		aeb_gen_cfg_reserved_1c4         : t_aeb_gen_cfg_reserved_1c4_wr_reg; -- AEB General Configuration Area Register "RESERVED_1C4"
		aeb_gen_cfg_reserved_1c8         : t_aeb_gen_cfg_reserved_1c8_wr_reg; -- AEB General Configuration Area Register "RESERVED_1C8"
		aeb_gen_cfg_reserved_1cc         : t_aeb_gen_cfg_reserved_1cc_wr_reg; -- AEB General Configuration Area Register "RESERVED_1CC"
		aeb_gen_cfg_reserved_1d0         : t_aeb_gen_cfg_reserved_1d0_wr_reg; -- AEB General Configuration Area Register "RESERVED_1D0"
		aeb_gen_cfg_reserved_1d4         : t_aeb_gen_cfg_reserved_1d4_wr_reg; -- AEB General Configuration Area Register "RESERVED_1D4"
		aeb_gen_cfg_reserved_1d8         : t_aeb_gen_cfg_reserved_1d8_wr_reg; -- AEB General Configuration Area Register "RESERVED_1D8"
		aeb_gen_cfg_reserved_1dc         : t_aeb_gen_cfg_reserved_1dc_wr_reg; -- AEB General Configuration Area Register "RESERVED_1DC"
		aeb_gen_cfg_reserved_1e0         : t_aeb_gen_cfg_reserved_1e0_wr_reg; -- AEB General Configuration Area Register "RESERVED_1E0"
		aeb_gen_cfg_reserved_1e4         : t_aeb_gen_cfg_reserved_1e4_wr_reg; -- AEB General Configuration Area Register "RESERVED_1E4"
		aeb_gen_cfg_reserved_1e8         : t_aeb_gen_cfg_reserved_1e8_wr_reg; -- AEB General Configuration Area Register "RESERVED_1E8"
		aeb_gen_cfg_reserved_1ec         : t_aeb_gen_cfg_reserved_1ec_wr_reg; -- AEB General Configuration Area Register "RESERVED_1EC"
		aeb_gen_cfg_reserved_1f0         : t_aeb_gen_cfg_reserved_1f0_wr_reg; -- AEB General Configuration Area Register "RESERVED_1F0"
		aeb_gen_cfg_reserved_1f4         : t_aeb_gen_cfg_reserved_1f4_wr_reg; -- AEB General Configuration Area Register "RESERVED_1F4"
		aeb_gen_cfg_reserved_1f8         : t_aeb_gen_cfg_reserved_1f8_wr_reg; -- AEB General Configuration Area Register "RESERVED_1F8"
		aeb_gen_cfg_reserved_1fc         : t_aeb_gen_cfg_reserved_1fc_wr_reg; -- AEB General Configuration Area Register "RESERVED_1FC"
		aeb_gen_cfg_reserved_200         : t_aeb_gen_cfg_reserved_200_wr_reg; -- AEB General Configuration Area Register "RESERVED_200"
		aeb_gen_cfg_reserved_204         : t_aeb_gen_cfg_reserved_204_wr_reg; -- AEB General Configuration Area Register "RESERVED_204"
		aeb_gen_cfg_reserved_208         : t_aeb_gen_cfg_reserved_208_wr_reg; -- AEB General Configuration Area Register "RESERVED_208"
		aeb_gen_cfg_reserved_20c         : t_aeb_gen_cfg_reserved_20c_wr_reg; -- AEB General Configuration Area Register "RESERVED_20C"
		aeb_gen_cfg_reserved_210         : t_aeb_gen_cfg_reserved_210_wr_reg; -- AEB General Configuration Area Register "RESERVED_210"
		aeb_gen_cfg_reserved_214         : t_aeb_gen_cfg_reserved_214_wr_reg; -- AEB General Configuration Area Register "RESERVED_214"
		aeb_gen_cfg_reserved_218         : t_aeb_gen_cfg_reserved_218_wr_reg; -- AEB General Configuration Area Register "RESERVED_218"
		aeb_gen_cfg_reserved_21c         : t_aeb_gen_cfg_reserved_21c_wr_reg; -- AEB General Configuration Area Register "RESERVED_21C"
		aeb_gen_cfg_reserved_220         : t_aeb_gen_cfg_reserved_220_wr_reg; -- AEB General Configuration Area Register "RESERVED_220"
		aeb_gen_cfg_reserved_224         : t_aeb_gen_cfg_reserved_224_wr_reg; -- AEB General Configuration Area Register "RESERVED_224"
		aeb_gen_cfg_reserved_228         : t_aeb_gen_cfg_reserved_228_wr_reg; -- AEB General Configuration Area Register "RESERVED_228"
		aeb_gen_cfg_reserved_22c         : t_aeb_gen_cfg_reserved_22c_wr_reg; -- AEB General Configuration Area Register "RESERVED_22C"
		aeb_gen_cfg_reserved_230         : t_aeb_gen_cfg_reserved_230_wr_reg; -- AEB General Configuration Area Register "RESERVED_230"
		aeb_gen_cfg_reserved_234         : t_aeb_gen_cfg_reserved_234_wr_reg; -- AEB General Configuration Area Register "RESERVED_234"
		aeb_gen_cfg_reserved_238         : t_aeb_gen_cfg_reserved_238_wr_reg; -- AEB General Configuration Area Register "RESERVED_238"
		aeb_gen_cfg_reserved_23c         : t_aeb_gen_cfg_reserved_23c_wr_reg; -- AEB General Configuration Area Register "RESERVED_23C"
		aeb_gen_cfg_reserved_240         : t_aeb_gen_cfg_reserved_240_wr_reg; -- AEB General Configuration Area Register "RESERVED_240"
		aeb_gen_cfg_reserved_244         : t_aeb_gen_cfg_reserved_244_wr_reg; -- AEB General Configuration Area Register "RESERVED_244"
		aeb_gen_cfg_reserved_248         : t_aeb_gen_cfg_reserved_248_wr_reg; -- AEB General Configuration Area Register "RESERVED_248"
		aeb_gen_cfg_reserved_24c         : t_aeb_gen_cfg_reserved_24c_wr_reg; -- AEB General Configuration Area Register "RESERVED_24C"
		aeb_gen_cfg_reserved_250         : t_aeb_gen_cfg_reserved_250_wr_reg; -- AEB General Configuration Area Register "RESERVED_250"
		aeb_gen_cfg_reserved_254         : t_aeb_gen_cfg_reserved_254_wr_reg; -- AEB General Configuration Area Register "RESERVED_254"
		aeb_gen_cfg_reserved_258         : t_aeb_gen_cfg_reserved_258_wr_reg; -- AEB General Configuration Area Register "RESERVED_258"
		aeb_gen_cfg_reserved_25c         : t_aeb_gen_cfg_reserved_25c_wr_reg; -- AEB General Configuration Area Register "RESERVED_25C"
		aeb_gen_cfg_reserved_260         : t_aeb_gen_cfg_reserved_260_wr_reg; -- AEB General Configuration Area Register "RESERVED_260"
		aeb_gen_cfg_reserved_264         : t_aeb_gen_cfg_reserved_264_wr_reg; -- AEB General Configuration Area Register "RESERVED_264"
		aeb_gen_cfg_reserved_268         : t_aeb_gen_cfg_reserved_268_wr_reg; -- AEB General Configuration Area Register "RESERVED_268"
		aeb_gen_cfg_reserved_26c         : t_aeb_gen_cfg_reserved_26c_wr_reg; -- AEB General Configuration Area Register "RESERVED_26C"
		aeb_gen_cfg_reserved_270         : t_aeb_gen_cfg_reserved_270_wr_reg; -- AEB General Configuration Area Register "RESERVED_270"
		aeb_gen_cfg_reserved_274         : t_aeb_gen_cfg_reserved_274_wr_reg; -- AEB General Configuration Area Register "RESERVED_274"
		aeb_gen_cfg_reserved_278         : t_aeb_gen_cfg_reserved_278_wr_reg; -- AEB General Configuration Area Register "RESERVED_278"
		aeb_gen_cfg_reserved_27c         : t_aeb_gen_cfg_reserved_27c_wr_reg; -- AEB General Configuration Area Register "RESERVED_27C"
		aeb_gen_cfg_reserved_280         : t_aeb_gen_cfg_reserved_280_wr_reg; -- AEB General Configuration Area Register "RESERVED_280"
		aeb_gen_cfg_reserved_284         : t_aeb_gen_cfg_reserved_284_wr_reg; -- AEB General Configuration Area Register "RESERVED_284"
		aeb_gen_cfg_reserved_288         : t_aeb_gen_cfg_reserved_288_wr_reg; -- AEB General Configuration Area Register "RESERVED_288"
		aeb_gen_cfg_reserved_28c         : t_aeb_gen_cfg_reserved_28c_wr_reg; -- AEB General Configuration Area Register "RESERVED_28C"
		aeb_gen_cfg_reserved_290         : t_aeb_gen_cfg_reserved_290_wr_reg; -- AEB General Configuration Area Register "RESERVED_290"
		aeb_gen_cfg_reserved_294         : t_aeb_gen_cfg_reserved_294_wr_reg; -- AEB General Configuration Area Register "RESERVED_294"
		aeb_gen_cfg_reserved_298         : t_aeb_gen_cfg_reserved_298_wr_reg; -- AEB General Configuration Area Register "RESERVED_298"
		aeb_gen_cfg_reserved_29c         : t_aeb_gen_cfg_reserved_29c_wr_reg; -- AEB General Configuration Area Register "RESERVED_29C"
		aeb_gen_cfg_reserved_2a0         : t_aeb_gen_cfg_reserved_2a0_wr_reg; -- AEB General Configuration Area Register "RESERVED_2A0"
		aeb_gen_cfg_reserved_2a4         : t_aeb_gen_cfg_reserved_2a4_wr_reg; -- AEB General Configuration Area Register "RESERVED_2A4"
		aeb_gen_cfg_reserved_2a8         : t_aeb_gen_cfg_reserved_2a8_wr_reg; -- AEB General Configuration Area Register "RESERVED_2A8"
		aeb_gen_cfg_reserved_2ac         : t_aeb_gen_cfg_reserved_2ac_wr_reg; -- AEB General Configuration Area Register "RESERVED_2AC"
		aeb_gen_cfg_reserved_2b0         : t_aeb_gen_cfg_reserved_2b0_wr_reg; -- AEB General Configuration Area Register "RESERVED_2B0"
		aeb_gen_cfg_reserved_2b4         : t_aeb_gen_cfg_reserved_2b4_wr_reg; -- AEB General Configuration Area Register "RESERVED_2B4"
		aeb_gen_cfg_reserved_2b8         : t_aeb_gen_cfg_reserved_2b8_wr_reg; -- AEB General Configuration Area Register "RESERVED_2B8"
		aeb_gen_cfg_reserved_2bc         : t_aeb_gen_cfg_reserved_2bc_wr_reg; -- AEB General Configuration Area Register "RESERVED_2BC"
		aeb_gen_cfg_reserved_2c0         : t_aeb_gen_cfg_reserved_2c0_wr_reg; -- AEB General Configuration Area Register "RESERVED_2C0"
		aeb_gen_cfg_reserved_2c4         : t_aeb_gen_cfg_reserved_2c4_wr_reg; -- AEB General Configuration Area Register "RESERVED_2C4"
		aeb_gen_cfg_reserved_2c8         : t_aeb_gen_cfg_reserved_2c8_wr_reg; -- AEB General Configuration Area Register "RESERVED_2C8"
		aeb_gen_cfg_reserved_2cc         : t_aeb_gen_cfg_reserved_2cc_wr_reg; -- AEB General Configuration Area Register "RESERVED_2CC"
		aeb_gen_cfg_reserved_2d0         : t_aeb_gen_cfg_reserved_2d0_wr_reg; -- AEB General Configuration Area Register "RESERVED_2D0"
		aeb_gen_cfg_reserved_2d4         : t_aeb_gen_cfg_reserved_2d4_wr_reg; -- AEB General Configuration Area Register "RESERVED_2D4"
		aeb_gen_cfg_reserved_2d8         : t_aeb_gen_cfg_reserved_2d8_wr_reg; -- AEB General Configuration Area Register "RESERVED_2D8"
		aeb_gen_cfg_reserved_2dc         : t_aeb_gen_cfg_reserved_2dc_wr_reg; -- AEB General Configuration Area Register "RESERVED_2DC"
		aeb_gen_cfg_reserved_2e0         : t_aeb_gen_cfg_reserved_2e0_wr_reg; -- AEB General Configuration Area Register "RESERVED_2E0"
		aeb_gen_cfg_reserved_2e4         : t_aeb_gen_cfg_reserved_2e4_wr_reg; -- AEB General Configuration Area Register "RESERVED_2E4"
		aeb_gen_cfg_reserved_2e8         : t_aeb_gen_cfg_reserved_2e8_wr_reg; -- AEB General Configuration Area Register "RESERVED_2E8"
		aeb_gen_cfg_reserved_2ec         : t_aeb_gen_cfg_reserved_2ec_wr_reg; -- AEB General Configuration Area Register "RESERVED_2EC"
		aeb_gen_cfg_reserved_2f0         : t_aeb_gen_cfg_reserved_2f0_wr_reg; -- AEB General Configuration Area Register "RESERVED_2F0"
		aeb_gen_cfg_reserved_2f4         : t_aeb_gen_cfg_reserved_2f4_wr_reg; -- AEB General Configuration Area Register "RESERVED_2F4"
		aeb_gen_cfg_reserved_2f8         : t_aeb_gen_cfg_reserved_2f8_wr_reg; -- AEB General Configuration Area Register "RESERVED_2F8"
		aeb_gen_cfg_reserved_2fc         : t_aeb_gen_cfg_reserved_2fc_wr_reg; -- AEB General Configuration Area Register "RESERVED_2FC"
		aeb_gen_cfg_reserved_300         : t_aeb_gen_cfg_reserved_300_wr_reg; -- AEB General Configuration Area Register "RESERVED_300"
		aeb_gen_cfg_reserved_304         : t_aeb_gen_cfg_reserved_304_wr_reg; -- AEB General Configuration Area Register "RESERVED_304"
		aeb_gen_cfg_reserved_308         : t_aeb_gen_cfg_reserved_308_wr_reg; -- AEB General Configuration Area Register "RESERVED_308"
		aeb_gen_cfg_reserved_30c         : t_aeb_gen_cfg_reserved_30c_wr_reg; -- AEB General Configuration Area Register "RESERVED_30C"
		aeb_gen_cfg_reserved_310         : t_aeb_gen_cfg_reserved_310_wr_reg; -- AEB General Configuration Area Register "RESERVED_310"
		aeb_gen_cfg_reserved_314         : t_aeb_gen_cfg_reserved_314_wr_reg; -- AEB General Configuration Area Register "RESERVED_314"
		aeb_gen_cfg_reserved_318         : t_aeb_gen_cfg_reserved_318_wr_reg; -- AEB General Configuration Area Register "RESERVED_318"
		aeb_gen_cfg_reserved_31c         : t_aeb_gen_cfg_reserved_31c_wr_reg; -- AEB General Configuration Area Register "RESERVED_31C"
		aeb_gen_cfg_reserved_320         : t_aeb_gen_cfg_reserved_320_wr_reg; -- AEB General Configuration Area Register "RESERVED_320"
		aeb_gen_cfg_reserved_324         : t_aeb_gen_cfg_reserved_324_wr_reg; -- AEB General Configuration Area Register "RESERVED_324"
		aeb_gen_cfg_reserved_328         : t_aeb_gen_cfg_reserved_328_wr_reg; -- AEB General Configuration Area Register "RESERVED_328"
		aeb_gen_cfg_reserved_32c         : t_aeb_gen_cfg_reserved_32c_wr_reg; -- AEB General Configuration Area Register "RESERVED_32C"
		aeb_gen_cfg_reserved_330         : t_aeb_gen_cfg_reserved_330_wr_reg; -- AEB General Configuration Area Register "RESERVED_330"
		aeb_gen_cfg_reserved_334         : t_aeb_gen_cfg_reserved_334_wr_reg; -- AEB General Configuration Area Register "RESERVED_334"
		aeb_gen_cfg_reserved_338         : t_aeb_gen_cfg_reserved_338_wr_reg; -- AEB General Configuration Area Register "RESERVED_338"
		aeb_gen_cfg_reserved_33c         : t_aeb_gen_cfg_reserved_33c_wr_reg; -- AEB General Configuration Area Register "RESERVED_33C"
		aeb_gen_cfg_reserved_340         : t_aeb_gen_cfg_reserved_340_wr_reg; -- AEB General Configuration Area Register "RESERVED_340"
		aeb_gen_cfg_reserved_344         : t_aeb_gen_cfg_reserved_344_wr_reg; -- AEB General Configuration Area Register "RESERVED_344"
		aeb_gen_cfg_reserved_348         : t_aeb_gen_cfg_reserved_348_wr_reg; -- AEB General Configuration Area Register "RESERVED_348"
		aeb_gen_cfg_reserved_34c         : t_aeb_gen_cfg_reserved_34c_wr_reg; -- AEB General Configuration Area Register "RESERVED_34C"
		aeb_gen_cfg_reserved_350         : t_aeb_gen_cfg_reserved_350_wr_reg; -- AEB General Configuration Area Register "RESERVED_350"
		aeb_gen_cfg_reserved_354         : t_aeb_gen_cfg_reserved_354_wr_reg; -- AEB General Configuration Area Register "RESERVED_354"
		aeb_gen_cfg_reserved_358         : t_aeb_gen_cfg_reserved_358_wr_reg; -- AEB General Configuration Area Register "RESERVED_358"
		aeb_gen_cfg_reserved_35c         : t_aeb_gen_cfg_reserved_35c_wr_reg; -- AEB General Configuration Area Register "RESERVED_35C"
		aeb_gen_cfg_reserved_360         : t_aeb_gen_cfg_reserved_360_wr_reg; -- AEB General Configuration Area Register "RESERVED_360"
		aeb_gen_cfg_reserved_364         : t_aeb_gen_cfg_reserved_364_wr_reg; -- AEB General Configuration Area Register "RESERVED_364"
		aeb_gen_cfg_reserved_368         : t_aeb_gen_cfg_reserved_368_wr_reg; -- AEB General Configuration Area Register "RESERVED_368"
		aeb_gen_cfg_reserved_36c         : t_aeb_gen_cfg_reserved_36c_wr_reg; -- AEB General Configuration Area Register "RESERVED_36C"
		aeb_gen_cfg_reserved_370         : t_aeb_gen_cfg_reserved_370_wr_reg; -- AEB General Configuration Area Register "RESERVED_370"
		aeb_gen_cfg_reserved_374         : t_aeb_gen_cfg_reserved_374_wr_reg; -- AEB General Configuration Area Register "RESERVED_374"
		aeb_gen_cfg_reserved_378         : t_aeb_gen_cfg_reserved_378_wr_reg; -- AEB General Configuration Area Register "RESERVED_378"
		aeb_gen_cfg_reserved_37c         : t_aeb_gen_cfg_reserved_37c_wr_reg; -- AEB General Configuration Area Register "RESERVED_37C"
		aeb_gen_cfg_reserved_380         : t_aeb_gen_cfg_reserved_380_wr_reg; -- AEB General Configuration Area Register "RESERVED_380"
		aeb_gen_cfg_reserved_384         : t_aeb_gen_cfg_reserved_384_wr_reg; -- AEB General Configuration Area Register "RESERVED_384"
		aeb_gen_cfg_reserved_388         : t_aeb_gen_cfg_reserved_388_wr_reg; -- AEB General Configuration Area Register "RESERVED_388"
		aeb_gen_cfg_reserved_38c         : t_aeb_gen_cfg_reserved_38c_wr_reg; -- AEB General Configuration Area Register "RESERVED_38C"
		aeb_gen_cfg_reserved_390         : t_aeb_gen_cfg_reserved_390_wr_reg; -- AEB General Configuration Area Register "RESERVED_390"
		aeb_gen_cfg_reserved_394         : t_aeb_gen_cfg_reserved_394_wr_reg; -- AEB General Configuration Area Register "RESERVED_394"
		aeb_gen_cfg_reserved_398         : t_aeb_gen_cfg_reserved_398_wr_reg; -- AEB General Configuration Area Register "RESERVED_398"
		aeb_gen_cfg_reserved_39c         : t_aeb_gen_cfg_reserved_39c_wr_reg; -- AEB General Configuration Area Register "RESERVED_39C"
		aeb_gen_cfg_reserved_3a0         : t_aeb_gen_cfg_reserved_3a0_wr_reg; -- AEB General Configuration Area Register "RESERVED_3A0"
		aeb_gen_cfg_reserved_3a4         : t_aeb_gen_cfg_reserved_3a4_wr_reg; -- AEB General Configuration Area Register "RESERVED_3A4"
		aeb_gen_cfg_reserved_3a8         : t_aeb_gen_cfg_reserved_3a8_wr_reg; -- AEB General Configuration Area Register "RESERVED_3A8"
		aeb_gen_cfg_reserved_3ac         : t_aeb_gen_cfg_reserved_3ac_wr_reg; -- AEB General Configuration Area Register "RESERVED_3AC"
		aeb_gen_cfg_reserved_3b0         : t_aeb_gen_cfg_reserved_3b0_wr_reg; -- AEB General Configuration Area Register "RESERVED_3B0"
		aeb_gen_cfg_reserved_3b4         : t_aeb_gen_cfg_reserved_3b4_wr_reg; -- AEB General Configuration Area Register "RESERVED_3B4"
		aeb_gen_cfg_reserved_3b8         : t_aeb_gen_cfg_reserved_3b8_wr_reg; -- AEB General Configuration Area Register "RESERVED_3B8"
		aeb_gen_cfg_reserved_3bc         : t_aeb_gen_cfg_reserved_3bc_wr_reg; -- AEB General Configuration Area Register "RESERVED_3BC"
		aeb_gen_cfg_reserved_3c0         : t_aeb_gen_cfg_reserved_3c0_wr_reg; -- AEB General Configuration Area Register "RESERVED_3C0"
		aeb_gen_cfg_reserved_3c4         : t_aeb_gen_cfg_reserved_3c4_wr_reg; -- AEB General Configuration Area Register "RESERVED_3C4"
		aeb_gen_cfg_reserved_3c8         : t_aeb_gen_cfg_reserved_3c8_wr_reg; -- AEB General Configuration Area Register "RESERVED_3C8"
		aeb_gen_cfg_reserved_3cc         : t_aeb_gen_cfg_reserved_3cc_wr_reg; -- AEB General Configuration Area Register "RESERVED_3CC"
		aeb_gen_cfg_reserved_3d0         : t_aeb_gen_cfg_reserved_3d0_wr_reg; -- AEB General Configuration Area Register "RESERVED_3D0"
		aeb_gen_cfg_reserved_3d4         : t_aeb_gen_cfg_reserved_3d4_wr_reg; -- AEB General Configuration Area Register "RESERVED_3D4"
		aeb_gen_cfg_reserved_3d8         : t_aeb_gen_cfg_reserved_3d8_wr_reg; -- AEB General Configuration Area Register "RESERVED_3D8"
		aeb_gen_cfg_reserved_3dc         : t_aeb_gen_cfg_reserved_3dc_wr_reg; -- AEB General Configuration Area Register "RESERVED_3DC"
		aeb_gen_cfg_reserved_3e0         : t_aeb_gen_cfg_reserved_3e0_wr_reg; -- AEB General Configuration Area Register "RESERVED_3E0"
		aeb_gen_cfg_reserved_3e4         : t_aeb_gen_cfg_reserved_3e4_wr_reg; -- AEB General Configuration Area Register "RESERVED_3E4"
		aeb_gen_cfg_reserved_3e8         : t_aeb_gen_cfg_reserved_3e8_wr_reg; -- AEB General Configuration Area Register "RESERVED_3E8"
		aeb_gen_cfg_reserved_3ec         : t_aeb_gen_cfg_reserved_3ec_wr_reg; -- AEB General Configuration Area Register "RESERVED_3EC"
		aeb_gen_cfg_reserved_3f0         : t_aeb_gen_cfg_reserved_3f0_wr_reg; -- AEB General Configuration Area Register "RESERVED_3F0"
		aeb_gen_cfg_reserved_3f4         : t_aeb_gen_cfg_reserved_3f4_wr_reg; -- AEB General Configuration Area Register "RESERVED_3F4"
		aeb_gen_cfg_reserved_3f8         : t_aeb_gen_cfg_reserved_3f8_wr_reg; -- AEB General Configuration Area Register "RESERVED_3F8"
		aeb_gen_cfg_reserved_3fc         : t_aeb_gen_cfg_reserved_3fc_wr_reg; -- AEB General Configuration Area Register "RESERVED_3FC"
		aeb_gen_cfg_reserved_400         : t_aeb_gen_cfg_reserved_400_wr_reg; -- AEB General Configuration Area Register "RESERVED_400"
		aeb_gen_cfg_reserved_404         : t_aeb_gen_cfg_reserved_404_wr_reg; -- AEB General Configuration Area Register "RESERVED_404"
		aeb_gen_cfg_reserved_408         : t_aeb_gen_cfg_reserved_408_wr_reg; -- AEB General Configuration Area Register "RESERVED_408"
		aeb_gen_cfg_reserved_40c         : t_aeb_gen_cfg_reserved_40c_wr_reg; -- AEB General Configuration Area Register "RESERVED_40C"
		aeb_gen_cfg_reserved_410         : t_aeb_gen_cfg_reserved_410_wr_reg; -- AEB General Configuration Area Register "RESERVED_410"
		aeb_gen_cfg_reserved_414         : t_aeb_gen_cfg_reserved_414_wr_reg; -- AEB General Configuration Area Register "RESERVED_414"
		aeb_gen_cfg_reserved_418         : t_aeb_gen_cfg_reserved_418_wr_reg; -- AEB General Configuration Area Register "RESERVED_418"
		aeb_gen_cfg_reserved_41c         : t_aeb_gen_cfg_reserved_41c_wr_reg; -- AEB General Configuration Area Register "RESERVED_41C"
		aeb_gen_cfg_reserved_420         : t_aeb_gen_cfg_reserved_420_wr_reg; -- AEB General Configuration Area Register "RESERVED_420"
		aeb_gen_cfg_reserved_424         : t_aeb_gen_cfg_reserved_424_wr_reg; -- AEB General Configuration Area Register "RESERVED_424"
		aeb_gen_cfg_reserved_428         : t_aeb_gen_cfg_reserved_428_wr_reg; -- AEB General Configuration Area Register "RESERVED_428"
		aeb_gen_cfg_reserved_42c         : t_aeb_gen_cfg_reserved_42c_wr_reg; -- AEB General Configuration Area Register "RESERVED_42C"
		aeb_gen_cfg_reserved_430         : t_aeb_gen_cfg_reserved_430_wr_reg; -- AEB General Configuration Area Register "RESERVED_430"
		aeb_gen_cfg_reserved_434         : t_aeb_gen_cfg_reserved_434_wr_reg; -- AEB General Configuration Area Register "RESERVED_434"
		aeb_gen_cfg_reserved_438         : t_aeb_gen_cfg_reserved_438_wr_reg; -- AEB General Configuration Area Register "RESERVED_438"
		aeb_gen_cfg_reserved_43c         : t_aeb_gen_cfg_reserved_43c_wr_reg; -- AEB General Configuration Area Register "RESERVED_43C"
		aeb_gen_cfg_reserved_440         : t_aeb_gen_cfg_reserved_440_wr_reg; -- AEB General Configuration Area Register "RESERVED_440"
		aeb_gen_cfg_reserved_444         : t_aeb_gen_cfg_reserved_444_wr_reg; -- AEB General Configuration Area Register "RESERVED_444"
		aeb_gen_cfg_reserved_448         : t_aeb_gen_cfg_reserved_448_wr_reg; -- AEB General Configuration Area Register "RESERVED_448"
		aeb_gen_cfg_reserved_44c         : t_aeb_gen_cfg_reserved_44c_wr_reg; -- AEB General Configuration Area Register "RESERVED_44C"
		aeb_gen_cfg_reserved_450         : t_aeb_gen_cfg_reserved_450_wr_reg; -- AEB General Configuration Area Register "RESERVED_450"
		aeb_gen_cfg_reserved_454         : t_aeb_gen_cfg_reserved_454_wr_reg; -- AEB General Configuration Area Register "RESERVED_454"
		aeb_gen_cfg_reserved_458         : t_aeb_gen_cfg_reserved_458_wr_reg; -- AEB General Configuration Area Register "RESERVED_458"
		aeb_gen_cfg_reserved_45c         : t_aeb_gen_cfg_reserved_45c_wr_reg; -- AEB General Configuration Area Register "RESERVED_45C"
		aeb_gen_cfg_reserved_460         : t_aeb_gen_cfg_reserved_460_wr_reg; -- AEB General Configuration Area Register "RESERVED_460"
		aeb_gen_cfg_reserved_464         : t_aeb_gen_cfg_reserved_464_wr_reg; -- AEB General Configuration Area Register "RESERVED_464"
		aeb_gen_cfg_reserved_468         : t_aeb_gen_cfg_reserved_468_wr_reg; -- AEB General Configuration Area Register "RESERVED_468"
		aeb_gen_cfg_reserved_46c         : t_aeb_gen_cfg_reserved_46c_wr_reg; -- AEB General Configuration Area Register "RESERVED_46C"
		aeb_gen_cfg_reserved_470         : t_aeb_gen_cfg_reserved_470_wr_reg; -- AEB General Configuration Area Register "RESERVED_470"
		aeb_gen_cfg_reserved_474         : t_aeb_gen_cfg_reserved_474_wr_reg; -- AEB General Configuration Area Register "RESERVED_474"
		aeb_gen_cfg_reserved_478         : t_aeb_gen_cfg_reserved_478_wr_reg; -- AEB General Configuration Area Register "RESERVED_478"
		aeb_gen_cfg_reserved_47c         : t_aeb_gen_cfg_reserved_47c_wr_reg; -- AEB General Configuration Area Register "RESERVED_47C"
		aeb_gen_cfg_reserved_480         : t_aeb_gen_cfg_reserved_480_wr_reg; -- AEB General Configuration Area Register "RESERVED_480"
		aeb_gen_cfg_reserved_484         : t_aeb_gen_cfg_reserved_484_wr_reg; -- AEB General Configuration Area Register "RESERVED_484"
		aeb_gen_cfg_reserved_488         : t_aeb_gen_cfg_reserved_488_wr_reg; -- AEB General Configuration Area Register "RESERVED_488"
		aeb_gen_cfg_reserved_48c         : t_aeb_gen_cfg_reserved_48c_wr_reg; -- AEB General Configuration Area Register "RESERVED_48C"
		aeb_gen_cfg_reserved_490         : t_aeb_gen_cfg_reserved_490_wr_reg; -- AEB General Configuration Area Register "RESERVED_490"
		aeb_gen_cfg_reserved_494         : t_aeb_gen_cfg_reserved_494_wr_reg; -- AEB General Configuration Area Register "RESERVED_494"
		aeb_gen_cfg_reserved_498         : t_aeb_gen_cfg_reserved_498_wr_reg; -- AEB General Configuration Area Register "RESERVED_498"
		aeb_gen_cfg_reserved_49c         : t_aeb_gen_cfg_reserved_49c_wr_reg; -- AEB General Configuration Area Register "RESERVED_49C"
		aeb_gen_cfg_reserved_4a0         : t_aeb_gen_cfg_reserved_4a0_wr_reg; -- AEB General Configuration Area Register "RESERVED_4A0"
		aeb_gen_cfg_reserved_4a4         : t_aeb_gen_cfg_reserved_4a4_wr_reg; -- AEB General Configuration Area Register "RESERVED_4A4"
		aeb_gen_cfg_reserved_4a8         : t_aeb_gen_cfg_reserved_4a8_wr_reg; -- AEB General Configuration Area Register "RESERVED_4A8"
		aeb_gen_cfg_reserved_4ac         : t_aeb_gen_cfg_reserved_4ac_wr_reg; -- AEB General Configuration Area Register "RESERVED_4AC"
		aeb_gen_cfg_reserved_4b0         : t_aeb_gen_cfg_reserved_4b0_wr_reg; -- AEB General Configuration Area Register "RESERVED_4B0"
		aeb_gen_cfg_reserved_4b4         : t_aeb_gen_cfg_reserved_4b4_wr_reg; -- AEB General Configuration Area Register "RESERVED_4B4"
		aeb_gen_cfg_reserved_4b8         : t_aeb_gen_cfg_reserved_4b8_wr_reg; -- AEB General Configuration Area Register "RESERVED_4B8"
		aeb_gen_cfg_reserved_4bc         : t_aeb_gen_cfg_reserved_4bc_wr_reg; -- AEB General Configuration Area Register "RESERVED_4BC"
		aeb_gen_cfg_reserved_4c0         : t_aeb_gen_cfg_reserved_4c0_wr_reg; -- AEB General Configuration Area Register "RESERVED_4C0"
		aeb_gen_cfg_reserved_4c4         : t_aeb_gen_cfg_reserved_4c4_wr_reg; -- AEB General Configuration Area Register "RESERVED_4C4"
		aeb_gen_cfg_reserved_4c8         : t_aeb_gen_cfg_reserved_4c8_wr_reg; -- AEB General Configuration Area Register "RESERVED_4C8"
		aeb_gen_cfg_reserved_4cc         : t_aeb_gen_cfg_reserved_4cc_wr_reg; -- AEB General Configuration Area Register "RESERVED_4CC"
		aeb_gen_cfg_reserved_4d0         : t_aeb_gen_cfg_reserved_4d0_wr_reg; -- AEB General Configuration Area Register "RESERVED_4D0"
		aeb_gen_cfg_reserved_4d4         : t_aeb_gen_cfg_reserved_4d4_wr_reg; -- AEB General Configuration Area Register "RESERVED_4D4"
		aeb_gen_cfg_reserved_4d8         : t_aeb_gen_cfg_reserved_4d8_wr_reg; -- AEB General Configuration Area Register "RESERVED_4D8"
		aeb_gen_cfg_reserved_4dc         : t_aeb_gen_cfg_reserved_4dc_wr_reg; -- AEB General Configuration Area Register "RESERVED_4DC"
		aeb_gen_cfg_reserved_4e0         : t_aeb_gen_cfg_reserved_4e0_wr_reg; -- AEB General Configuration Area Register "RESERVED_4E0"
		aeb_gen_cfg_reserved_4e4         : t_aeb_gen_cfg_reserved_4e4_wr_reg; -- AEB General Configuration Area Register "RESERVED_4E4"
		aeb_gen_cfg_reserved_4e8         : t_aeb_gen_cfg_reserved_4e8_wr_reg; -- AEB General Configuration Area Register "RESERVED_4E8"
		aeb_gen_cfg_reserved_4ec         : t_aeb_gen_cfg_reserved_4ec_wr_reg; -- AEB General Configuration Area Register "RESERVED_4EC"
		aeb_gen_cfg_reserved_4f0         : t_aeb_gen_cfg_reserved_4f0_wr_reg; -- AEB General Configuration Area Register "RESERVED_4F0"
		aeb_gen_cfg_reserved_4f4         : t_aeb_gen_cfg_reserved_4f4_wr_reg; -- AEB General Configuration Area Register "RESERVED_4F4"
		aeb_gen_cfg_reserved_4f8         : t_aeb_gen_cfg_reserved_4f8_wr_reg; -- AEB General Configuration Area Register "RESERVED_4F8"
		aeb_gen_cfg_reserved_4fc         : t_aeb_gen_cfg_reserved_4fc_wr_reg; -- AEB General Configuration Area Register "RESERVED_4FC"
		aeb_gen_cfg_reserved_500         : t_aeb_gen_cfg_reserved_500_wr_reg; -- AEB General Configuration Area Register "RESERVED_500"
		aeb_gen_cfg_reserved_504         : t_aeb_gen_cfg_reserved_504_wr_reg; -- AEB General Configuration Area Register "RESERVED_504"
		aeb_gen_cfg_reserved_508         : t_aeb_gen_cfg_reserved_508_wr_reg; -- AEB General Configuration Area Register "RESERVED_508"
		aeb_gen_cfg_reserved_50c         : t_aeb_gen_cfg_reserved_50c_wr_reg; -- AEB General Configuration Area Register "RESERVED_50C"
		aeb_gen_cfg_reserved_510         : t_aeb_gen_cfg_reserved_510_wr_reg; -- AEB General Configuration Area Register "RESERVED_510"
		aeb_gen_cfg_reserved_514         : t_aeb_gen_cfg_reserved_514_wr_reg; -- AEB General Configuration Area Register "RESERVED_514"
		aeb_gen_cfg_reserved_518         : t_aeb_gen_cfg_reserved_518_wr_reg; -- AEB General Configuration Area Register "RESERVED_518"
		aeb_gen_cfg_reserved_51c         : t_aeb_gen_cfg_reserved_51c_wr_reg; -- AEB General Configuration Area Register "RESERVED_51C"
		aeb_gen_cfg_reserved_520         : t_aeb_gen_cfg_reserved_520_wr_reg; -- AEB General Configuration Area Register "RESERVED_520"
		aeb_gen_cfg_reserved_524         : t_aeb_gen_cfg_reserved_524_wr_reg; -- AEB General Configuration Area Register "RESERVED_524"
		aeb_gen_cfg_reserved_528         : t_aeb_gen_cfg_reserved_528_wr_reg; -- AEB General Configuration Area Register "RESERVED_528"
		aeb_gen_cfg_reserved_52c         : t_aeb_gen_cfg_reserved_52c_wr_reg; -- AEB General Configuration Area Register "RESERVED_52C"
		aeb_gen_cfg_reserved_530         : t_aeb_gen_cfg_reserved_530_wr_reg; -- AEB General Configuration Area Register "RESERVED_530"
		aeb_gen_cfg_reserved_534         : t_aeb_gen_cfg_reserved_534_wr_reg; -- AEB General Configuration Area Register "RESERVED_534"
		aeb_gen_cfg_reserved_538         : t_aeb_gen_cfg_reserved_538_wr_reg; -- AEB General Configuration Area Register "RESERVED_538"
		aeb_gen_cfg_reserved_53c         : t_aeb_gen_cfg_reserved_53c_wr_reg; -- AEB General Configuration Area Register "RESERVED_53C"
		aeb_gen_cfg_reserved_540         : t_aeb_gen_cfg_reserved_540_wr_reg; -- AEB General Configuration Area Register "RESERVED_540"
		aeb_gen_cfg_reserved_544         : t_aeb_gen_cfg_reserved_544_wr_reg; -- AEB General Configuration Area Register "RESERVED_544"
		aeb_gen_cfg_reserved_548         : t_aeb_gen_cfg_reserved_548_wr_reg; -- AEB General Configuration Area Register "RESERVED_548"
		aeb_gen_cfg_reserved_54c         : t_aeb_gen_cfg_reserved_54c_wr_reg; -- AEB General Configuration Area Register "RESERVED_54C"
		aeb_gen_cfg_reserved_550         : t_aeb_gen_cfg_reserved_550_wr_reg; -- AEB General Configuration Area Register "RESERVED_550"
		aeb_gen_cfg_reserved_554         : t_aeb_gen_cfg_reserved_554_wr_reg; -- AEB General Configuration Area Register "RESERVED_554"
		aeb_gen_cfg_reserved_558         : t_aeb_gen_cfg_reserved_558_wr_reg; -- AEB General Configuration Area Register "RESERVED_558"
		aeb_gen_cfg_reserved_55c         : t_aeb_gen_cfg_reserved_55c_wr_reg; -- AEB General Configuration Area Register "RESERVED_55C"
		aeb_gen_cfg_reserved_560         : t_aeb_gen_cfg_reserved_560_wr_reg; -- AEB General Configuration Area Register "RESERVED_560"
		aeb_gen_cfg_reserved_564         : t_aeb_gen_cfg_reserved_564_wr_reg; -- AEB General Configuration Area Register "RESERVED_564"
		aeb_gen_cfg_reserved_568         : t_aeb_gen_cfg_reserved_568_wr_reg; -- AEB General Configuration Area Register "RESERVED_568"
		aeb_gen_cfg_reserved_56c         : t_aeb_gen_cfg_reserved_56c_wr_reg; -- AEB General Configuration Area Register "RESERVED_56C"
		aeb_gen_cfg_reserved_570         : t_aeb_gen_cfg_reserved_570_wr_reg; -- AEB General Configuration Area Register "RESERVED_570"
		aeb_gen_cfg_reserved_574         : t_aeb_gen_cfg_reserved_574_wr_reg; -- AEB General Configuration Area Register "RESERVED_574"
		aeb_gen_cfg_reserved_578         : t_aeb_gen_cfg_reserved_578_wr_reg; -- AEB General Configuration Area Register "RESERVED_578"
		aeb_gen_cfg_reserved_57c         : t_aeb_gen_cfg_reserved_57c_wr_reg; -- AEB General Configuration Area Register "RESERVED_57C"
		aeb_gen_cfg_reserved_580         : t_aeb_gen_cfg_reserved_580_wr_reg; -- AEB General Configuration Area Register "RESERVED_580"
		aeb_gen_cfg_reserved_584         : t_aeb_gen_cfg_reserved_584_wr_reg; -- AEB General Configuration Area Register "RESERVED_584"
		aeb_gen_cfg_reserved_588         : t_aeb_gen_cfg_reserved_588_wr_reg; -- AEB General Configuration Area Register "RESERVED_588"
		aeb_gen_cfg_reserved_58c         : t_aeb_gen_cfg_reserved_58c_wr_reg; -- AEB General Configuration Area Register "RESERVED_58C"
		aeb_gen_cfg_reserved_590         : t_aeb_gen_cfg_reserved_590_wr_reg; -- AEB General Configuration Area Register "RESERVED_590"
		aeb_gen_cfg_reserved_594         : t_aeb_gen_cfg_reserved_594_wr_reg; -- AEB General Configuration Area Register "RESERVED_594"
		aeb_gen_cfg_reserved_598         : t_aeb_gen_cfg_reserved_598_wr_reg; -- AEB General Configuration Area Register "RESERVED_598"
		aeb_gen_cfg_reserved_59c         : t_aeb_gen_cfg_reserved_59c_wr_reg; -- AEB General Configuration Area Register "RESERVED_59C"
		aeb_gen_cfg_reserved_5a0         : t_aeb_gen_cfg_reserved_5a0_wr_reg; -- AEB General Configuration Area Register "RESERVED_5A0"
		aeb_gen_cfg_reserved_5a4         : t_aeb_gen_cfg_reserved_5a4_wr_reg; -- AEB General Configuration Area Register "RESERVED_5A4"
		aeb_gen_cfg_reserved_5a8         : t_aeb_gen_cfg_reserved_5a8_wr_reg; -- AEB General Configuration Area Register "RESERVED_5A8"
		aeb_gen_cfg_reserved_5ac         : t_aeb_gen_cfg_reserved_5ac_wr_reg; -- AEB General Configuration Area Register "RESERVED_5AC"
		aeb_gen_cfg_reserved_5b0         : t_aeb_gen_cfg_reserved_5b0_wr_reg; -- AEB General Configuration Area Register "RESERVED_5B0"
		aeb_gen_cfg_reserved_5b4         : t_aeb_gen_cfg_reserved_5b4_wr_reg; -- AEB General Configuration Area Register "RESERVED_5B4"
		aeb_gen_cfg_reserved_5b8         : t_aeb_gen_cfg_reserved_5b8_wr_reg; -- AEB General Configuration Area Register "RESERVED_5B8"
		aeb_gen_cfg_reserved_5bc         : t_aeb_gen_cfg_reserved_5bc_wr_reg; -- AEB General Configuration Area Register "RESERVED_5BC"
		aeb_gen_cfg_reserved_5c0         : t_aeb_gen_cfg_reserved_5c0_wr_reg; -- AEB General Configuration Area Register "RESERVED_5C0"
		aeb_gen_cfg_reserved_5c4         : t_aeb_gen_cfg_reserved_5c4_wr_reg; -- AEB General Configuration Area Register "RESERVED_5C4"
		aeb_gen_cfg_reserved_5c8         : t_aeb_gen_cfg_reserved_5c8_wr_reg; -- AEB General Configuration Area Register "RESERVED_5C8"
		aeb_gen_cfg_reserved_5cc         : t_aeb_gen_cfg_reserved_5cc_wr_reg; -- AEB General Configuration Area Register "RESERVED_5CC"
		aeb_gen_cfg_reserved_5d0         : t_aeb_gen_cfg_reserved_5d0_wr_reg; -- AEB General Configuration Area Register "RESERVED_5D0"
		aeb_gen_cfg_reserved_5d4         : t_aeb_gen_cfg_reserved_5d4_wr_reg; -- AEB General Configuration Area Register "RESERVED_5D4"
		aeb_gen_cfg_reserved_5d8         : t_aeb_gen_cfg_reserved_5d8_wr_reg; -- AEB General Configuration Area Register "RESERVED_5D8"
		aeb_gen_cfg_reserved_5dc         : t_aeb_gen_cfg_reserved_5dc_wr_reg; -- AEB General Configuration Area Register "RESERVED_5DC"
		aeb_gen_cfg_reserved_5e0         : t_aeb_gen_cfg_reserved_5e0_wr_reg; -- AEB General Configuration Area Register "RESERVED_5E0"
		aeb_gen_cfg_reserved_5e4         : t_aeb_gen_cfg_reserved_5e4_wr_reg; -- AEB General Configuration Area Register "RESERVED_5E4"
		aeb_gen_cfg_reserved_5e8         : t_aeb_gen_cfg_reserved_5e8_wr_reg; -- AEB General Configuration Area Register "RESERVED_5E8"
		aeb_gen_cfg_reserved_5ec         : t_aeb_gen_cfg_reserved_5ec_wr_reg; -- AEB General Configuration Area Register "RESERVED_5EC"
		aeb_gen_cfg_reserved_5f0         : t_aeb_gen_cfg_reserved_5f0_wr_reg; -- AEB General Configuration Area Register "RESERVED_5F0"
		aeb_gen_cfg_reserved_5f4         : t_aeb_gen_cfg_reserved_5f4_wr_reg; -- AEB General Configuration Area Register "RESERVED_5F4"
		aeb_gen_cfg_reserved_5f8         : t_aeb_gen_cfg_reserved_5f8_wr_reg; -- AEB General Configuration Area Register "RESERVED_5F8"
		aeb_gen_cfg_reserved_5fc         : t_aeb_gen_cfg_reserved_5fc_wr_reg; -- AEB General Configuration Area Register "RESERVED_5FC"
		aeb_gen_cfg_reserved_600         : t_aeb_gen_cfg_reserved_600_wr_reg; -- AEB General Configuration Area Register "RESERVED_600"
		aeb_gen_cfg_reserved_604         : t_aeb_gen_cfg_reserved_604_wr_reg; -- AEB General Configuration Area Register "RESERVED_604"
		aeb_gen_cfg_reserved_608         : t_aeb_gen_cfg_reserved_608_wr_reg; -- AEB General Configuration Area Register "RESERVED_608"
		aeb_gen_cfg_reserved_60c         : t_aeb_gen_cfg_reserved_60c_wr_reg; -- AEB General Configuration Area Register "RESERVED_60C"
		aeb_gen_cfg_reserved_610         : t_aeb_gen_cfg_reserved_610_wr_reg; -- AEB General Configuration Area Register "RESERVED_610"
		aeb_gen_cfg_reserved_614         : t_aeb_gen_cfg_reserved_614_wr_reg; -- AEB General Configuration Area Register "RESERVED_614"
		aeb_gen_cfg_reserved_618         : t_aeb_gen_cfg_reserved_618_wr_reg; -- AEB General Configuration Area Register "RESERVED_618"
		aeb_gen_cfg_reserved_61c         : t_aeb_gen_cfg_reserved_61c_wr_reg; -- AEB General Configuration Area Register "RESERVED_61C"
		aeb_gen_cfg_reserved_620         : t_aeb_gen_cfg_reserved_620_wr_reg; -- AEB General Configuration Area Register "RESERVED_620"
		aeb_gen_cfg_reserved_624         : t_aeb_gen_cfg_reserved_624_wr_reg; -- AEB General Configuration Area Register "RESERVED_624"
		aeb_gen_cfg_reserved_628         : t_aeb_gen_cfg_reserved_628_wr_reg; -- AEB General Configuration Area Register "RESERVED_628"
		aeb_gen_cfg_reserved_62c         : t_aeb_gen_cfg_reserved_62c_wr_reg; -- AEB General Configuration Area Register "RESERVED_62C"
		aeb_gen_cfg_reserved_630         : t_aeb_gen_cfg_reserved_630_wr_reg; -- AEB General Configuration Area Register "RESERVED_630"
		aeb_gen_cfg_reserved_634         : t_aeb_gen_cfg_reserved_634_wr_reg; -- AEB General Configuration Area Register "RESERVED_634"
		aeb_gen_cfg_reserved_638         : t_aeb_gen_cfg_reserved_638_wr_reg; -- AEB General Configuration Area Register "RESERVED_638"
		aeb_gen_cfg_reserved_63c         : t_aeb_gen_cfg_reserved_63c_wr_reg; -- AEB General Configuration Area Register "RESERVED_63C"
		aeb_gen_cfg_reserved_640         : t_aeb_gen_cfg_reserved_640_wr_reg; -- AEB General Configuration Area Register "RESERVED_640"
		aeb_gen_cfg_reserved_644         : t_aeb_gen_cfg_reserved_644_wr_reg; -- AEB General Configuration Area Register "RESERVED_644"
		aeb_gen_cfg_reserved_648         : t_aeb_gen_cfg_reserved_648_wr_reg; -- AEB General Configuration Area Register "RESERVED_648"
		aeb_gen_cfg_reserved_64c         : t_aeb_gen_cfg_reserved_64c_wr_reg; -- AEB General Configuration Area Register "RESERVED_64C"
		aeb_gen_cfg_reserved_650         : t_aeb_gen_cfg_reserved_650_wr_reg; -- AEB General Configuration Area Register "RESERVED_650"
		aeb_gen_cfg_reserved_654         : t_aeb_gen_cfg_reserved_654_wr_reg; -- AEB General Configuration Area Register "RESERVED_654"
		aeb_gen_cfg_reserved_658         : t_aeb_gen_cfg_reserved_658_wr_reg; -- AEB General Configuration Area Register "RESERVED_658"
		aeb_gen_cfg_reserved_65c         : t_aeb_gen_cfg_reserved_65c_wr_reg; -- AEB General Configuration Area Register "RESERVED_65C"
		aeb_gen_cfg_reserved_660         : t_aeb_gen_cfg_reserved_660_wr_reg; -- AEB General Configuration Area Register "RESERVED_660"
		aeb_gen_cfg_reserved_664         : t_aeb_gen_cfg_reserved_664_wr_reg; -- AEB General Configuration Area Register "RESERVED_664"
		aeb_gen_cfg_reserved_668         : t_aeb_gen_cfg_reserved_668_wr_reg; -- AEB General Configuration Area Register "RESERVED_668"
		aeb_gen_cfg_reserved_66c         : t_aeb_gen_cfg_reserved_66c_wr_reg; -- AEB General Configuration Area Register "RESERVED_66C"
		aeb_gen_cfg_reserved_670         : t_aeb_gen_cfg_reserved_670_wr_reg; -- AEB General Configuration Area Register "RESERVED_670"
		aeb_gen_cfg_reserved_674         : t_aeb_gen_cfg_reserved_674_wr_reg; -- AEB General Configuration Area Register "RESERVED_674"
		aeb_gen_cfg_reserved_678         : t_aeb_gen_cfg_reserved_678_wr_reg; -- AEB General Configuration Area Register "RESERVED_678"
		aeb_gen_cfg_reserved_67c         : t_aeb_gen_cfg_reserved_67c_wr_reg; -- AEB General Configuration Area Register "RESERVED_67C"
		aeb_gen_cfg_reserved_680         : t_aeb_gen_cfg_reserved_680_wr_reg; -- AEB General Configuration Area Register "RESERVED_680"
		aeb_gen_cfg_reserved_684         : t_aeb_gen_cfg_reserved_684_wr_reg; -- AEB General Configuration Area Register "RESERVED_684"
		aeb_gen_cfg_reserved_688         : t_aeb_gen_cfg_reserved_688_wr_reg; -- AEB General Configuration Area Register "RESERVED_688"
		aeb_gen_cfg_reserved_68c         : t_aeb_gen_cfg_reserved_68c_wr_reg; -- AEB General Configuration Area Register "RESERVED_68C"
		aeb_gen_cfg_reserved_690         : t_aeb_gen_cfg_reserved_690_wr_reg; -- AEB General Configuration Area Register "RESERVED_690"
		aeb_gen_cfg_reserved_694         : t_aeb_gen_cfg_reserved_694_wr_reg; -- AEB General Configuration Area Register "RESERVED_694"
		aeb_gen_cfg_reserved_698         : t_aeb_gen_cfg_reserved_698_wr_reg; -- AEB General Configuration Area Register "RESERVED_698"
		aeb_gen_cfg_reserved_69c         : t_aeb_gen_cfg_reserved_69c_wr_reg; -- AEB General Configuration Area Register "RESERVED_69C"
		aeb_gen_cfg_reserved_6a0         : t_aeb_gen_cfg_reserved_6a0_wr_reg; -- AEB General Configuration Area Register "RESERVED_6A0"
		aeb_gen_cfg_reserved_6a4         : t_aeb_gen_cfg_reserved_6a4_wr_reg; -- AEB General Configuration Area Register "RESERVED_6A4"
		aeb_gen_cfg_reserved_6a8         : t_aeb_gen_cfg_reserved_6a8_wr_reg; -- AEB General Configuration Area Register "RESERVED_6A8"
		aeb_gen_cfg_reserved_6ac         : t_aeb_gen_cfg_reserved_6ac_wr_reg; -- AEB General Configuration Area Register "RESERVED_6AC"
		aeb_gen_cfg_reserved_6b0         : t_aeb_gen_cfg_reserved_6b0_wr_reg; -- AEB General Configuration Area Register "RESERVED_6B0"
		aeb_gen_cfg_reserved_6b4         : t_aeb_gen_cfg_reserved_6b4_wr_reg; -- AEB General Configuration Area Register "RESERVED_6B4"
		aeb_gen_cfg_reserved_6b8         : t_aeb_gen_cfg_reserved_6b8_wr_reg; -- AEB General Configuration Area Register "RESERVED_6B8"
		aeb_gen_cfg_reserved_6bc         : t_aeb_gen_cfg_reserved_6bc_wr_reg; -- AEB General Configuration Area Register "RESERVED_6BC"
		aeb_gen_cfg_reserved_6c0         : t_aeb_gen_cfg_reserved_6c0_wr_reg; -- AEB General Configuration Area Register "RESERVED_6C0"
		aeb_gen_cfg_reserved_6c4         : t_aeb_gen_cfg_reserved_6c4_wr_reg; -- AEB General Configuration Area Register "RESERVED_6C4"
		aeb_gen_cfg_reserved_6c8         : t_aeb_gen_cfg_reserved_6c8_wr_reg; -- AEB General Configuration Area Register "RESERVED_6C8"
		aeb_gen_cfg_reserved_6cc         : t_aeb_gen_cfg_reserved_6cc_wr_reg; -- AEB General Configuration Area Register "RESERVED_6CC"
		aeb_gen_cfg_reserved_6d0         : t_aeb_gen_cfg_reserved_6d0_wr_reg; -- AEB General Configuration Area Register "RESERVED_6D0"
		aeb_gen_cfg_reserved_6d4         : t_aeb_gen_cfg_reserved_6d4_wr_reg; -- AEB General Configuration Area Register "RESERVED_6D4"
		aeb_gen_cfg_reserved_6d8         : t_aeb_gen_cfg_reserved_6d8_wr_reg; -- AEB General Configuration Area Register "RESERVED_6D8"
		aeb_gen_cfg_reserved_6dc         : t_aeb_gen_cfg_reserved_6dc_wr_reg; -- AEB General Configuration Area Register "RESERVED_6DC"
		aeb_gen_cfg_reserved_6e0         : t_aeb_gen_cfg_reserved_6e0_wr_reg; -- AEB General Configuration Area Register "RESERVED_6E0"
		aeb_gen_cfg_reserved_6e4         : t_aeb_gen_cfg_reserved_6e4_wr_reg; -- AEB General Configuration Area Register "RESERVED_6E4"
		aeb_gen_cfg_reserved_6e8         : t_aeb_gen_cfg_reserved_6e8_wr_reg; -- AEB General Configuration Area Register "RESERVED_6E8"
		aeb_gen_cfg_reserved_6ec         : t_aeb_gen_cfg_reserved_6ec_wr_reg; -- AEB General Configuration Area Register "RESERVED_6EC"
		aeb_gen_cfg_reserved_6f0         : t_aeb_gen_cfg_reserved_6f0_wr_reg; -- AEB General Configuration Area Register "RESERVED_6F0"
		aeb_gen_cfg_reserved_6f4         : t_aeb_gen_cfg_reserved_6f4_wr_reg; -- AEB General Configuration Area Register "RESERVED_6F4"
		aeb_gen_cfg_reserved_6f8         : t_aeb_gen_cfg_reserved_6f8_wr_reg; -- AEB General Configuration Area Register "RESERVED_6F8"
		aeb_gen_cfg_reserved_6fc         : t_aeb_gen_cfg_reserved_6fc_wr_reg; -- AEB General Configuration Area Register "RESERVED_6FC"
		aeb_gen_cfg_reserved_700         : t_aeb_gen_cfg_reserved_700_wr_reg; -- AEB General Configuration Area Register "RESERVED_700"
		aeb_gen_cfg_reserved_704         : t_aeb_gen_cfg_reserved_704_wr_reg; -- AEB General Configuration Area Register "RESERVED_704"
		aeb_gen_cfg_reserved_708         : t_aeb_gen_cfg_reserved_708_wr_reg; -- AEB General Configuration Area Register "RESERVED_708"
		aeb_gen_cfg_reserved_70c         : t_aeb_gen_cfg_reserved_70c_wr_reg; -- AEB General Configuration Area Register "RESERVED_70C"
		aeb_gen_cfg_reserved_710         : t_aeb_gen_cfg_reserved_710_wr_reg; -- AEB General Configuration Area Register "RESERVED_710"
		aeb_gen_cfg_reserved_714         : t_aeb_gen_cfg_reserved_714_wr_reg; -- AEB General Configuration Area Register "RESERVED_714"
		aeb_gen_cfg_reserved_718         : t_aeb_gen_cfg_reserved_718_wr_reg; -- AEB General Configuration Area Register "RESERVED_718"
		aeb_gen_cfg_reserved_71c         : t_aeb_gen_cfg_reserved_71c_wr_reg; -- AEB General Configuration Area Register "RESERVED_71C"
		aeb_gen_cfg_reserved_720         : t_aeb_gen_cfg_reserved_720_wr_reg; -- AEB General Configuration Area Register "RESERVED_720"
		aeb_gen_cfg_reserved_724         : t_aeb_gen_cfg_reserved_724_wr_reg; -- AEB General Configuration Area Register "RESERVED_724"
		aeb_gen_cfg_reserved_728         : t_aeb_gen_cfg_reserved_728_wr_reg; -- AEB General Configuration Area Register "RESERVED_728"
		aeb_gen_cfg_reserved_72c         : t_aeb_gen_cfg_reserved_72c_wr_reg; -- AEB General Configuration Area Register "RESERVED_72C"
		aeb_gen_cfg_reserved_730         : t_aeb_gen_cfg_reserved_730_wr_reg; -- AEB General Configuration Area Register "RESERVED_730"
		aeb_gen_cfg_reserved_734         : t_aeb_gen_cfg_reserved_734_wr_reg; -- AEB General Configuration Area Register "RESERVED_734"
		aeb_gen_cfg_reserved_738         : t_aeb_gen_cfg_reserved_738_wr_reg; -- AEB General Configuration Area Register "RESERVED_738"
		aeb_gen_cfg_reserved_73c         : t_aeb_gen_cfg_reserved_73c_wr_reg; -- AEB General Configuration Area Register "RESERVED_73C"
		aeb_gen_cfg_reserved_740         : t_aeb_gen_cfg_reserved_740_wr_reg; -- AEB General Configuration Area Register "RESERVED_740"
		aeb_gen_cfg_reserved_744         : t_aeb_gen_cfg_reserved_744_wr_reg; -- AEB General Configuration Area Register "RESERVED_744"
		aeb_gen_cfg_reserved_748         : t_aeb_gen_cfg_reserved_748_wr_reg; -- AEB General Configuration Area Register "RESERVED_748"
		aeb_gen_cfg_reserved_74c         : t_aeb_gen_cfg_reserved_74c_wr_reg; -- AEB General Configuration Area Register "RESERVED_74C"
		aeb_gen_cfg_reserved_750         : t_aeb_gen_cfg_reserved_750_wr_reg; -- AEB General Configuration Area Register "RESERVED_750"
		aeb_gen_cfg_reserved_754         : t_aeb_gen_cfg_reserved_754_wr_reg; -- AEB General Configuration Area Register "RESERVED_754"
		aeb_gen_cfg_reserved_758         : t_aeb_gen_cfg_reserved_758_wr_reg; -- AEB General Configuration Area Register "RESERVED_758"
		aeb_gen_cfg_reserved_75c         : t_aeb_gen_cfg_reserved_75c_wr_reg; -- AEB General Configuration Area Register "RESERVED_75C"
		aeb_gen_cfg_reserved_760         : t_aeb_gen_cfg_reserved_760_wr_reg; -- AEB General Configuration Area Register "RESERVED_760"
		aeb_gen_cfg_reserved_764         : t_aeb_gen_cfg_reserved_764_wr_reg; -- AEB General Configuration Area Register "RESERVED_764"
		aeb_gen_cfg_reserved_768         : t_aeb_gen_cfg_reserved_768_wr_reg; -- AEB General Configuration Area Register "RESERVED_768"
		aeb_gen_cfg_reserved_76c         : t_aeb_gen_cfg_reserved_76c_wr_reg; -- AEB General Configuration Area Register "RESERVED_76C"
		aeb_gen_cfg_reserved_770         : t_aeb_gen_cfg_reserved_770_wr_reg; -- AEB General Configuration Area Register "RESERVED_770"
		aeb_gen_cfg_reserved_774         : t_aeb_gen_cfg_reserved_774_wr_reg; -- AEB General Configuration Area Register "RESERVED_774"
		aeb_gen_cfg_reserved_778         : t_aeb_gen_cfg_reserved_778_wr_reg; -- AEB General Configuration Area Register "RESERVED_778"
		aeb_gen_cfg_reserved_77c         : t_aeb_gen_cfg_reserved_77c_wr_reg; -- AEB General Configuration Area Register "RESERVED_77C"
		aeb_gen_cfg_reserved_780         : t_aeb_gen_cfg_reserved_780_wr_reg; -- AEB General Configuration Area Register "RESERVED_780"
		aeb_gen_cfg_reserved_784         : t_aeb_gen_cfg_reserved_784_wr_reg; -- AEB General Configuration Area Register "RESERVED_784"
		aeb_gen_cfg_reserved_788         : t_aeb_gen_cfg_reserved_788_wr_reg; -- AEB General Configuration Area Register "RESERVED_788"
		aeb_gen_cfg_reserved_78c         : t_aeb_gen_cfg_reserved_78c_wr_reg; -- AEB General Configuration Area Register "RESERVED_78C"
		aeb_gen_cfg_reserved_790         : t_aeb_gen_cfg_reserved_790_wr_reg; -- AEB General Configuration Area Register "RESERVED_790"
		aeb_gen_cfg_reserved_794         : t_aeb_gen_cfg_reserved_794_wr_reg; -- AEB General Configuration Area Register "RESERVED_794"
		aeb_gen_cfg_reserved_798         : t_aeb_gen_cfg_reserved_798_wr_reg; -- AEB General Configuration Area Register "RESERVED_798"
		aeb_gen_cfg_reserved_79c         : t_aeb_gen_cfg_reserved_79c_wr_reg; -- AEB General Configuration Area Register "RESERVED_79C"
		aeb_gen_cfg_reserved_7a0         : t_aeb_gen_cfg_reserved_7a0_wr_reg; -- AEB General Configuration Area Register "RESERVED_7A0"
		aeb_gen_cfg_reserved_7a4         : t_aeb_gen_cfg_reserved_7a4_wr_reg; -- AEB General Configuration Area Register "RESERVED_7A4"
		aeb_gen_cfg_reserved_7a8         : t_aeb_gen_cfg_reserved_7a8_wr_reg; -- AEB General Configuration Area Register "RESERVED_7A8"
		aeb_gen_cfg_reserved_7ac         : t_aeb_gen_cfg_reserved_7ac_wr_reg; -- AEB General Configuration Area Register "RESERVED_7AC"
		aeb_gen_cfg_reserved_7b0         : t_aeb_gen_cfg_reserved_7b0_wr_reg; -- AEB General Configuration Area Register "RESERVED_7B0"
		aeb_gen_cfg_reserved_7b4         : t_aeb_gen_cfg_reserved_7b4_wr_reg; -- AEB General Configuration Area Register "RESERVED_7B4"
		aeb_gen_cfg_reserved_7b8         : t_aeb_gen_cfg_reserved_7b8_wr_reg; -- AEB General Configuration Area Register "RESERVED_7B8"
		aeb_gen_cfg_reserved_7bc         : t_aeb_gen_cfg_reserved_7bc_wr_reg; -- AEB General Configuration Area Register "RESERVED_7BC"
		aeb_gen_cfg_reserved_7c0         : t_aeb_gen_cfg_reserved_7c0_wr_reg; -- AEB General Configuration Area Register "RESERVED_7C0"
		aeb_gen_cfg_reserved_7c4         : t_aeb_gen_cfg_reserved_7c4_wr_reg; -- AEB General Configuration Area Register "RESERVED_7C4"
		aeb_gen_cfg_reserved_7c8         : t_aeb_gen_cfg_reserved_7c8_wr_reg; -- AEB General Configuration Area Register "RESERVED_7C8"
		aeb_gen_cfg_reserved_7cc         : t_aeb_gen_cfg_reserved_7cc_wr_reg; -- AEB General Configuration Area Register "RESERVED_7CC"
		aeb_gen_cfg_reserved_7d0         : t_aeb_gen_cfg_reserved_7d0_wr_reg; -- AEB General Configuration Area Register "RESERVED_7D0"
		aeb_gen_cfg_reserved_7d4         : t_aeb_gen_cfg_reserved_7d4_wr_reg; -- AEB General Configuration Area Register "RESERVED_7D4"
		aeb_gen_cfg_reserved_7d8         : t_aeb_gen_cfg_reserved_7d8_wr_reg; -- AEB General Configuration Area Register "RESERVED_7D8"
		aeb_gen_cfg_reserved_7dc         : t_aeb_gen_cfg_reserved_7dc_wr_reg; -- AEB General Configuration Area Register "RESERVED_7DC"
		aeb_gen_cfg_reserved_7e0         : t_aeb_gen_cfg_reserved_7e0_wr_reg; -- AEB General Configuration Area Register "RESERVED_7E0"
		aeb_gen_cfg_reserved_7e4         : t_aeb_gen_cfg_reserved_7e4_wr_reg; -- AEB General Configuration Area Register "RESERVED_7E4"
		aeb_gen_cfg_reserved_7e8         : t_aeb_gen_cfg_reserved_7e8_wr_reg; -- AEB General Configuration Area Register "RESERVED_7E8"
		aeb_gen_cfg_reserved_7ec         : t_aeb_gen_cfg_reserved_7ec_wr_reg; -- AEB General Configuration Area Register "RESERVED_7EC"
		aeb_gen_cfg_reserved_7f0         : t_aeb_gen_cfg_reserved_7f0_wr_reg; -- AEB General Configuration Area Register "RESERVED_7F0"
		aeb_gen_cfg_reserved_7f4         : t_aeb_gen_cfg_reserved_7f4_wr_reg; -- AEB General Configuration Area Register "RESERVED_7F4"
		aeb_gen_cfg_reserved_7f8         : t_aeb_gen_cfg_reserved_7f8_wr_reg; -- AEB General Configuration Area Register "RESERVED_7F8"
		aeb_gen_cfg_reserved_7fc         : t_aeb_gen_cfg_reserved_7fc_wr_reg; -- AEB General Configuration Area Register "RESERVED_7FC"
		aeb_gen_cfg_reserved_800         : t_aeb_gen_cfg_reserved_800_wr_reg; -- AEB General Configuration Area Register "RESERVED_800"
		aeb_gen_cfg_reserved_804         : t_aeb_gen_cfg_reserved_804_wr_reg; -- AEB General Configuration Area Register "RESERVED_804"
		aeb_gen_cfg_reserved_808         : t_aeb_gen_cfg_reserved_808_wr_reg; -- AEB General Configuration Area Register "RESERVED_808"
		aeb_gen_cfg_reserved_80c         : t_aeb_gen_cfg_reserved_80c_wr_reg; -- AEB General Configuration Area Register "RESERVED_80C"
		aeb_gen_cfg_reserved_810         : t_aeb_gen_cfg_reserved_810_wr_reg; -- AEB General Configuration Area Register "RESERVED_810"
		aeb_gen_cfg_reserved_814         : t_aeb_gen_cfg_reserved_814_wr_reg; -- AEB General Configuration Area Register "RESERVED_814"
		aeb_gen_cfg_reserved_818         : t_aeb_gen_cfg_reserved_818_wr_reg; -- AEB General Configuration Area Register "RESERVED_818"
		aeb_gen_cfg_reserved_81c         : t_aeb_gen_cfg_reserved_81c_wr_reg; -- AEB General Configuration Area Register "RESERVED_81C"
		aeb_gen_cfg_reserved_820         : t_aeb_gen_cfg_reserved_820_wr_reg; -- AEB General Configuration Area Register "RESERVED_820"
		aeb_gen_cfg_reserved_824         : t_aeb_gen_cfg_reserved_824_wr_reg; -- AEB General Configuration Area Register "RESERVED_824"
		aeb_gen_cfg_reserved_828         : t_aeb_gen_cfg_reserved_828_wr_reg; -- AEB General Configuration Area Register "RESERVED_828"
		aeb_gen_cfg_reserved_82c         : t_aeb_gen_cfg_reserved_82c_wr_reg; -- AEB General Configuration Area Register "RESERVED_82C"
		aeb_gen_cfg_reserved_830         : t_aeb_gen_cfg_reserved_830_wr_reg; -- AEB General Configuration Area Register "RESERVED_830"
		aeb_gen_cfg_reserved_834         : t_aeb_gen_cfg_reserved_834_wr_reg; -- AEB General Configuration Area Register "RESERVED_834"
		aeb_gen_cfg_reserved_838         : t_aeb_gen_cfg_reserved_838_wr_reg; -- AEB General Configuration Area Register "RESERVED_838"
		aeb_gen_cfg_reserved_83c         : t_aeb_gen_cfg_reserved_83c_wr_reg; -- AEB General Configuration Area Register "RESERVED_83C"
		aeb_gen_cfg_reserved_840         : t_aeb_gen_cfg_reserved_840_wr_reg; -- AEB General Configuration Area Register "RESERVED_840"
		aeb_gen_cfg_reserved_844         : t_aeb_gen_cfg_reserved_844_wr_reg; -- AEB General Configuration Area Register "RESERVED_844"
		aeb_gen_cfg_reserved_848         : t_aeb_gen_cfg_reserved_848_wr_reg; -- AEB General Configuration Area Register "RESERVED_848"
		aeb_gen_cfg_reserved_84c         : t_aeb_gen_cfg_reserved_84c_wr_reg; -- AEB General Configuration Area Register "RESERVED_84C"
		aeb_gen_cfg_reserved_850         : t_aeb_gen_cfg_reserved_850_wr_reg; -- AEB General Configuration Area Register "RESERVED_850"
		aeb_gen_cfg_reserved_854         : t_aeb_gen_cfg_reserved_854_wr_reg; -- AEB General Configuration Area Register "RESERVED_854"
		aeb_gen_cfg_reserved_858         : t_aeb_gen_cfg_reserved_858_wr_reg; -- AEB General Configuration Area Register "RESERVED_858"
		aeb_gen_cfg_reserved_85c         : t_aeb_gen_cfg_reserved_85c_wr_reg; -- AEB General Configuration Area Register "RESERVED_85C"
		aeb_gen_cfg_reserved_860         : t_aeb_gen_cfg_reserved_860_wr_reg; -- AEB General Configuration Area Register "RESERVED_860"
		aeb_gen_cfg_reserved_864         : t_aeb_gen_cfg_reserved_864_wr_reg; -- AEB General Configuration Area Register "RESERVED_864"
		aeb_gen_cfg_reserved_868         : t_aeb_gen_cfg_reserved_868_wr_reg; -- AEB General Configuration Area Register "RESERVED_868"
		aeb_gen_cfg_reserved_86c         : t_aeb_gen_cfg_reserved_86c_wr_reg; -- AEB General Configuration Area Register "RESERVED_86C"
		aeb_gen_cfg_reserved_870         : t_aeb_gen_cfg_reserved_870_wr_reg; -- AEB General Configuration Area Register "RESERVED_870"
		aeb_gen_cfg_reserved_874         : t_aeb_gen_cfg_reserved_874_wr_reg; -- AEB General Configuration Area Register "RESERVED_874"
		aeb_gen_cfg_reserved_878         : t_aeb_gen_cfg_reserved_878_wr_reg; -- AEB General Configuration Area Register "RESERVED_878"
		aeb_gen_cfg_reserved_87c         : t_aeb_gen_cfg_reserved_87c_wr_reg; -- AEB General Configuration Area Register "RESERVED_87C"
		aeb_gen_cfg_reserved_880         : t_aeb_gen_cfg_reserved_880_wr_reg; -- AEB General Configuration Area Register "RESERVED_880"
		aeb_gen_cfg_reserved_884         : t_aeb_gen_cfg_reserved_884_wr_reg; -- AEB General Configuration Area Register "RESERVED_884"
		aeb_gen_cfg_reserved_888         : t_aeb_gen_cfg_reserved_888_wr_reg; -- AEB General Configuration Area Register "RESERVED_888"
		aeb_gen_cfg_reserved_88c         : t_aeb_gen_cfg_reserved_88c_wr_reg; -- AEB General Configuration Area Register "RESERVED_88C"
		aeb_gen_cfg_reserved_890         : t_aeb_gen_cfg_reserved_890_wr_reg; -- AEB General Configuration Area Register "RESERVED_890"
		aeb_gen_cfg_reserved_894         : t_aeb_gen_cfg_reserved_894_wr_reg; -- AEB General Configuration Area Register "RESERVED_894"
		aeb_gen_cfg_reserved_898         : t_aeb_gen_cfg_reserved_898_wr_reg; -- AEB General Configuration Area Register "RESERVED_898"
		aeb_gen_cfg_reserved_89c         : t_aeb_gen_cfg_reserved_89c_wr_reg; -- AEB General Configuration Area Register "RESERVED_89C"
		aeb_gen_cfg_reserved_8a0         : t_aeb_gen_cfg_reserved_8a0_wr_reg; -- AEB General Configuration Area Register "RESERVED_8A0"
		aeb_gen_cfg_reserved_8a4         : t_aeb_gen_cfg_reserved_8a4_wr_reg; -- AEB General Configuration Area Register "RESERVED_8A4"
		aeb_gen_cfg_reserved_8a8         : t_aeb_gen_cfg_reserved_8a8_wr_reg; -- AEB General Configuration Area Register "RESERVED_8A8"
		aeb_gen_cfg_reserved_8ac         : t_aeb_gen_cfg_reserved_8ac_wr_reg; -- AEB General Configuration Area Register "RESERVED_8AC"
		aeb_gen_cfg_reserved_8b0         : t_aeb_gen_cfg_reserved_8b0_wr_reg; -- AEB General Configuration Area Register "RESERVED_8B0"
		aeb_gen_cfg_reserved_8b4         : t_aeb_gen_cfg_reserved_8b4_wr_reg; -- AEB General Configuration Area Register "RESERVED_8B4"
		aeb_gen_cfg_reserved_8b8         : t_aeb_gen_cfg_reserved_8b8_wr_reg; -- AEB General Configuration Area Register "RESERVED_8B8"
		aeb_gen_cfg_reserved_8bc         : t_aeb_gen_cfg_reserved_8bc_wr_reg; -- AEB General Configuration Area Register "RESERVED_8BC"
		aeb_gen_cfg_reserved_8c0         : t_aeb_gen_cfg_reserved_8c0_wr_reg; -- AEB General Configuration Area Register "RESERVED_8C0"
		aeb_gen_cfg_reserved_8c4         : t_aeb_gen_cfg_reserved_8c4_wr_reg; -- AEB General Configuration Area Register "RESERVED_8C4"
		aeb_gen_cfg_reserved_8c8         : t_aeb_gen_cfg_reserved_8c8_wr_reg; -- AEB General Configuration Area Register "RESERVED_8C8"
		aeb_gen_cfg_reserved_8cc         : t_aeb_gen_cfg_reserved_8cc_wr_reg; -- AEB General Configuration Area Register "RESERVED_8CC"
		aeb_gen_cfg_reserved_8d0         : t_aeb_gen_cfg_reserved_8d0_wr_reg; -- AEB General Configuration Area Register "RESERVED_8D0"
		aeb_gen_cfg_reserved_8d4         : t_aeb_gen_cfg_reserved_8d4_wr_reg; -- AEB General Configuration Area Register "RESERVED_8D4"
		aeb_gen_cfg_reserved_8d8         : t_aeb_gen_cfg_reserved_8d8_wr_reg; -- AEB General Configuration Area Register "RESERVED_8D8"
		aeb_gen_cfg_reserved_8dc         : t_aeb_gen_cfg_reserved_8dc_wr_reg; -- AEB General Configuration Area Register "RESERVED_8DC"
		aeb_gen_cfg_reserved_8e0         : t_aeb_gen_cfg_reserved_8e0_wr_reg; -- AEB General Configuration Area Register "RESERVED_8E0"
		aeb_gen_cfg_reserved_8e4         : t_aeb_gen_cfg_reserved_8e4_wr_reg; -- AEB General Configuration Area Register "RESERVED_8E4"
		aeb_gen_cfg_reserved_8e8         : t_aeb_gen_cfg_reserved_8e8_wr_reg; -- AEB General Configuration Area Register "RESERVED_8E8"
		aeb_gen_cfg_reserved_8ec         : t_aeb_gen_cfg_reserved_8ec_wr_reg; -- AEB General Configuration Area Register "RESERVED_8EC"
		aeb_gen_cfg_reserved_8f0         : t_aeb_gen_cfg_reserved_8f0_wr_reg; -- AEB General Configuration Area Register "RESERVED_8F0"
		aeb_gen_cfg_reserved_8f4         : t_aeb_gen_cfg_reserved_8f4_wr_reg; -- AEB General Configuration Area Register "RESERVED_8F4"
		aeb_gen_cfg_reserved_8f8         : t_aeb_gen_cfg_reserved_8f8_wr_reg; -- AEB General Configuration Area Register "RESERVED_8F8"
		aeb_gen_cfg_reserved_8fc         : t_aeb_gen_cfg_reserved_8fc_wr_reg; -- AEB General Configuration Area Register "RESERVED_8FC"
		aeb_gen_cfg_reserved_900         : t_aeb_gen_cfg_reserved_900_wr_reg; -- AEB General Configuration Area Register "RESERVED_900"
		aeb_gen_cfg_reserved_904         : t_aeb_gen_cfg_reserved_904_wr_reg; -- AEB General Configuration Area Register "RESERVED_904"
		aeb_gen_cfg_reserved_908         : t_aeb_gen_cfg_reserved_908_wr_reg; -- AEB General Configuration Area Register "RESERVED_908"
		aeb_gen_cfg_reserved_90c         : t_aeb_gen_cfg_reserved_90c_wr_reg; -- AEB General Configuration Area Register "RESERVED_90C"
		aeb_gen_cfg_reserved_910         : t_aeb_gen_cfg_reserved_910_wr_reg; -- AEB General Configuration Area Register "RESERVED_910"
		aeb_gen_cfg_reserved_914         : t_aeb_gen_cfg_reserved_914_wr_reg; -- AEB General Configuration Area Register "RESERVED_914"
		aeb_gen_cfg_reserved_918         : t_aeb_gen_cfg_reserved_918_wr_reg; -- AEB General Configuration Area Register "RESERVED_918"
		aeb_gen_cfg_reserved_91c         : t_aeb_gen_cfg_reserved_91c_wr_reg; -- AEB General Configuration Area Register "RESERVED_91C"
		aeb_gen_cfg_reserved_920         : t_aeb_gen_cfg_reserved_920_wr_reg; -- AEB General Configuration Area Register "RESERVED_920"
		aeb_gen_cfg_reserved_924         : t_aeb_gen_cfg_reserved_924_wr_reg; -- AEB General Configuration Area Register "RESERVED_924"
		aeb_gen_cfg_reserved_928         : t_aeb_gen_cfg_reserved_928_wr_reg; -- AEB General Configuration Area Register "RESERVED_928"
		aeb_gen_cfg_reserved_92c         : t_aeb_gen_cfg_reserved_92c_wr_reg; -- AEB General Configuration Area Register "RESERVED_92C"
		aeb_gen_cfg_reserved_930         : t_aeb_gen_cfg_reserved_930_wr_reg; -- AEB General Configuration Area Register "RESERVED_930"
		aeb_gen_cfg_reserved_934         : t_aeb_gen_cfg_reserved_934_wr_reg; -- AEB General Configuration Area Register "RESERVED_934"
		aeb_gen_cfg_reserved_938         : t_aeb_gen_cfg_reserved_938_wr_reg; -- AEB General Configuration Area Register "RESERVED_938"
		aeb_gen_cfg_reserved_93c         : t_aeb_gen_cfg_reserved_93c_wr_reg; -- AEB General Configuration Area Register "RESERVED_93C"
		aeb_gen_cfg_reserved_940         : t_aeb_gen_cfg_reserved_940_wr_reg; -- AEB General Configuration Area Register "RESERVED_940"
		aeb_gen_cfg_reserved_944         : t_aeb_gen_cfg_reserved_944_wr_reg; -- AEB General Configuration Area Register "RESERVED_944"
		aeb_gen_cfg_reserved_948         : t_aeb_gen_cfg_reserved_948_wr_reg; -- AEB General Configuration Area Register "RESERVED_948"
		aeb_gen_cfg_reserved_94c         : t_aeb_gen_cfg_reserved_94c_wr_reg; -- AEB General Configuration Area Register "RESERVED_94C"
		aeb_gen_cfg_reserved_950         : t_aeb_gen_cfg_reserved_950_wr_reg; -- AEB General Configuration Area Register "RESERVED_950"
		aeb_gen_cfg_reserved_954         : t_aeb_gen_cfg_reserved_954_wr_reg; -- AEB General Configuration Area Register "RESERVED_954"
		aeb_gen_cfg_reserved_958         : t_aeb_gen_cfg_reserved_958_wr_reg; -- AEB General Configuration Area Register "RESERVED_958"
		aeb_gen_cfg_reserved_95c         : t_aeb_gen_cfg_reserved_95c_wr_reg; -- AEB General Configuration Area Register "RESERVED_95C"
		aeb_gen_cfg_reserved_960         : t_aeb_gen_cfg_reserved_960_wr_reg; -- AEB General Configuration Area Register "RESERVED_960"
		aeb_gen_cfg_reserved_964         : t_aeb_gen_cfg_reserved_964_wr_reg; -- AEB General Configuration Area Register "RESERVED_964"
		aeb_gen_cfg_reserved_968         : t_aeb_gen_cfg_reserved_968_wr_reg; -- AEB General Configuration Area Register "RESERVED_968"
		aeb_gen_cfg_reserved_96c         : t_aeb_gen_cfg_reserved_96c_wr_reg; -- AEB General Configuration Area Register "RESERVED_96C"
		aeb_gen_cfg_reserved_970         : t_aeb_gen_cfg_reserved_970_wr_reg; -- AEB General Configuration Area Register "RESERVED_970"
		aeb_gen_cfg_reserved_974         : t_aeb_gen_cfg_reserved_974_wr_reg; -- AEB General Configuration Area Register "RESERVED_974"
		aeb_gen_cfg_reserved_978         : t_aeb_gen_cfg_reserved_978_wr_reg; -- AEB General Configuration Area Register "RESERVED_978"
		aeb_gen_cfg_reserved_97c         : t_aeb_gen_cfg_reserved_97c_wr_reg; -- AEB General Configuration Area Register "RESERVED_97C"
		aeb_gen_cfg_reserved_980         : t_aeb_gen_cfg_reserved_980_wr_reg; -- AEB General Configuration Area Register "RESERVED_980"
		aeb_gen_cfg_reserved_984         : t_aeb_gen_cfg_reserved_984_wr_reg; -- AEB General Configuration Area Register "RESERVED_984"
		aeb_gen_cfg_reserved_988         : t_aeb_gen_cfg_reserved_988_wr_reg; -- AEB General Configuration Area Register "RESERVED_988"
		aeb_gen_cfg_reserved_98c         : t_aeb_gen_cfg_reserved_98c_wr_reg; -- AEB General Configuration Area Register "RESERVED_98C"
		aeb_gen_cfg_reserved_990         : t_aeb_gen_cfg_reserved_990_wr_reg; -- AEB General Configuration Area Register "RESERVED_990"
		aeb_gen_cfg_reserved_994         : t_aeb_gen_cfg_reserved_994_wr_reg; -- AEB General Configuration Area Register "RESERVED_994"
		aeb_gen_cfg_reserved_998         : t_aeb_gen_cfg_reserved_998_wr_reg; -- AEB General Configuration Area Register "RESERVED_998"
		aeb_gen_cfg_reserved_99c         : t_aeb_gen_cfg_reserved_99c_wr_reg; -- AEB General Configuration Area Register "RESERVED_99C"
		aeb_gen_cfg_reserved_9a0         : t_aeb_gen_cfg_reserved_9a0_wr_reg; -- AEB General Configuration Area Register "RESERVED_9A0"
		aeb_gen_cfg_reserved_9a4         : t_aeb_gen_cfg_reserved_9a4_wr_reg; -- AEB General Configuration Area Register "RESERVED_9A4"
		aeb_gen_cfg_reserved_9a8         : t_aeb_gen_cfg_reserved_9a8_wr_reg; -- AEB General Configuration Area Register "RESERVED_9A8"
		aeb_gen_cfg_reserved_9ac         : t_aeb_gen_cfg_reserved_9ac_wr_reg; -- AEB General Configuration Area Register "RESERVED_9AC"
		aeb_gen_cfg_reserved_9b0         : t_aeb_gen_cfg_reserved_9b0_wr_reg; -- AEB General Configuration Area Register "RESERVED_9B0"
		aeb_gen_cfg_reserved_9b4         : t_aeb_gen_cfg_reserved_9b4_wr_reg; -- AEB General Configuration Area Register "RESERVED_9B4"
		aeb_gen_cfg_reserved_9b8         : t_aeb_gen_cfg_reserved_9b8_wr_reg; -- AEB General Configuration Area Register "RESERVED_9B8"
		aeb_gen_cfg_reserved_9bc         : t_aeb_gen_cfg_reserved_9bc_wr_reg; -- AEB General Configuration Area Register "RESERVED_9BC"
		aeb_gen_cfg_reserved_9c0         : t_aeb_gen_cfg_reserved_9c0_wr_reg; -- AEB General Configuration Area Register "RESERVED_9C0"
		aeb_gen_cfg_reserved_9c4         : t_aeb_gen_cfg_reserved_9c4_wr_reg; -- AEB General Configuration Area Register "RESERVED_9C4"
		aeb_gen_cfg_reserved_9c8         : t_aeb_gen_cfg_reserved_9c8_wr_reg; -- AEB General Configuration Area Register "RESERVED_9C8"
		aeb_gen_cfg_reserved_9cc         : t_aeb_gen_cfg_reserved_9cc_wr_reg; -- AEB General Configuration Area Register "RESERVED_9CC"
		aeb_gen_cfg_reserved_9d0         : t_aeb_gen_cfg_reserved_9d0_wr_reg; -- AEB General Configuration Area Register "RESERVED_9D0"
		aeb_gen_cfg_reserved_9d4         : t_aeb_gen_cfg_reserved_9d4_wr_reg; -- AEB General Configuration Area Register "RESERVED_9D4"
		aeb_gen_cfg_reserved_9d8         : t_aeb_gen_cfg_reserved_9d8_wr_reg; -- AEB General Configuration Area Register "RESERVED_9D8"
		aeb_gen_cfg_reserved_9dc         : t_aeb_gen_cfg_reserved_9dc_wr_reg; -- AEB General Configuration Area Register "RESERVED_9DC"
		aeb_gen_cfg_reserved_9e0         : t_aeb_gen_cfg_reserved_9e0_wr_reg; -- AEB General Configuration Area Register "RESERVED_9E0"
		aeb_gen_cfg_reserved_9e4         : t_aeb_gen_cfg_reserved_9e4_wr_reg; -- AEB General Configuration Area Register "RESERVED_9E4"
		aeb_gen_cfg_reserved_9e8         : t_aeb_gen_cfg_reserved_9e8_wr_reg; -- AEB General Configuration Area Register "RESERVED_9E8"
		aeb_gen_cfg_reserved_9ec         : t_aeb_gen_cfg_reserved_9ec_wr_reg; -- AEB General Configuration Area Register "RESERVED_9EC"
		aeb_gen_cfg_reserved_9f0         : t_aeb_gen_cfg_reserved_9f0_wr_reg; -- AEB General Configuration Area Register "RESERVED_9F0"
		aeb_gen_cfg_reserved_9f4         : t_aeb_gen_cfg_reserved_9f4_wr_reg; -- AEB General Configuration Area Register "RESERVED_9F4"
		aeb_gen_cfg_reserved_9f8         : t_aeb_gen_cfg_reserved_9f8_wr_reg; -- AEB General Configuration Area Register "RESERVED_9F8"
		aeb_gen_cfg_reserved_9fc         : t_aeb_gen_cfg_reserved_9fc_wr_reg; -- AEB General Configuration Area Register "RESERVED_9FC"
		aeb_gen_cfg_reserved_a00         : t_aeb_gen_cfg_reserved_a00_wr_reg; -- AEB General Configuration Area Register "RESERVED_A00"
		aeb_gen_cfg_reserved_a04         : t_aeb_gen_cfg_reserved_a04_wr_reg; -- AEB General Configuration Area Register "RESERVED_A04"
		aeb_gen_cfg_reserved_a08         : t_aeb_gen_cfg_reserved_a08_wr_reg; -- AEB General Configuration Area Register "RESERVED_A08"
		aeb_gen_cfg_reserved_a0c         : t_aeb_gen_cfg_reserved_a0c_wr_reg; -- AEB General Configuration Area Register "RESERVED_A0C"
		aeb_gen_cfg_reserved_a10         : t_aeb_gen_cfg_reserved_a10_wr_reg; -- AEB General Configuration Area Register "RESERVED_A10"
		aeb_gen_cfg_reserved_a14         : t_aeb_gen_cfg_reserved_a14_wr_reg; -- AEB General Configuration Area Register "RESERVED_A14"
		aeb_gen_cfg_reserved_a18         : t_aeb_gen_cfg_reserved_a18_wr_reg; -- AEB General Configuration Area Register "RESERVED_A18"
		aeb_gen_cfg_reserved_a1c         : t_aeb_gen_cfg_reserved_a1c_wr_reg; -- AEB General Configuration Area Register "RESERVED_A1C"
		aeb_gen_cfg_reserved_a20         : t_aeb_gen_cfg_reserved_a20_wr_reg; -- AEB General Configuration Area Register "RESERVED_A20"
		aeb_gen_cfg_reserved_a24         : t_aeb_gen_cfg_reserved_a24_wr_reg; -- AEB General Configuration Area Register "RESERVED_A24"
		aeb_gen_cfg_reserved_a28         : t_aeb_gen_cfg_reserved_a28_wr_reg; -- AEB General Configuration Area Register "RESERVED_A28"
		aeb_gen_cfg_reserved_a2c         : t_aeb_gen_cfg_reserved_a2c_wr_reg; -- AEB General Configuration Area Register "RESERVED_A2C"
		aeb_gen_cfg_reserved_a30         : t_aeb_gen_cfg_reserved_a30_wr_reg; -- AEB General Configuration Area Register "RESERVED_A30"
		aeb_gen_cfg_reserved_a34         : t_aeb_gen_cfg_reserved_a34_wr_reg; -- AEB General Configuration Area Register "RESERVED_A34"
		aeb_gen_cfg_reserved_a38         : t_aeb_gen_cfg_reserved_a38_wr_reg; -- AEB General Configuration Area Register "RESERVED_A38"
		aeb_gen_cfg_reserved_a3c         : t_aeb_gen_cfg_reserved_a3c_wr_reg; -- AEB General Configuration Area Register "RESERVED_A3C"
		aeb_gen_cfg_reserved_a40         : t_aeb_gen_cfg_reserved_a40_wr_reg; -- AEB General Configuration Area Register "RESERVED_A40"
		aeb_gen_cfg_reserved_a44         : t_aeb_gen_cfg_reserved_a44_wr_reg; -- AEB General Configuration Area Register "RESERVED_A44"
		aeb_gen_cfg_reserved_a48         : t_aeb_gen_cfg_reserved_a48_wr_reg; -- AEB General Configuration Area Register "RESERVED_A48"
		aeb_gen_cfg_reserved_a4c         : t_aeb_gen_cfg_reserved_a4c_wr_reg; -- AEB General Configuration Area Register "RESERVED_A4C"
		aeb_gen_cfg_reserved_a50         : t_aeb_gen_cfg_reserved_a50_wr_reg; -- AEB General Configuration Area Register "RESERVED_A50"
		aeb_gen_cfg_reserved_a54         : t_aeb_gen_cfg_reserved_a54_wr_reg; -- AEB General Configuration Area Register "RESERVED_A54"
		aeb_gen_cfg_reserved_a58         : t_aeb_gen_cfg_reserved_a58_wr_reg; -- AEB General Configuration Area Register "RESERVED_A58"
		aeb_gen_cfg_reserved_a5c         : t_aeb_gen_cfg_reserved_a5c_wr_reg; -- AEB General Configuration Area Register "RESERVED_A5C"
		aeb_gen_cfg_reserved_a60         : t_aeb_gen_cfg_reserved_a60_wr_reg; -- AEB General Configuration Area Register "RESERVED_A60"
		aeb_gen_cfg_reserved_a64         : t_aeb_gen_cfg_reserved_a64_wr_reg; -- AEB General Configuration Area Register "RESERVED_A64"
		aeb_gen_cfg_reserved_a68         : t_aeb_gen_cfg_reserved_a68_wr_reg; -- AEB General Configuration Area Register "RESERVED_A68"
		aeb_gen_cfg_reserved_a6c         : t_aeb_gen_cfg_reserved_a6c_wr_reg; -- AEB General Configuration Area Register "RESERVED_A6C"
		aeb_gen_cfg_reserved_a70         : t_aeb_gen_cfg_reserved_a70_wr_reg; -- AEB General Configuration Area Register "RESERVED_A70"
		aeb_gen_cfg_reserved_a74         : t_aeb_gen_cfg_reserved_a74_wr_reg; -- AEB General Configuration Area Register "RESERVED_A74"
		aeb_gen_cfg_reserved_a78         : t_aeb_gen_cfg_reserved_a78_wr_reg; -- AEB General Configuration Area Register "RESERVED_A78"
		aeb_gen_cfg_reserved_a7c         : t_aeb_gen_cfg_reserved_a7c_wr_reg; -- AEB General Configuration Area Register "RESERVED_A7C"
		aeb_gen_cfg_reserved_a80         : t_aeb_gen_cfg_reserved_a80_wr_reg; -- AEB General Configuration Area Register "RESERVED_A80"
		aeb_gen_cfg_reserved_a84         : t_aeb_gen_cfg_reserved_a84_wr_reg; -- AEB General Configuration Area Register "RESERVED_A84"
		aeb_gen_cfg_reserved_a88         : t_aeb_gen_cfg_reserved_a88_wr_reg; -- AEB General Configuration Area Register "RESERVED_A88"
		aeb_gen_cfg_reserved_a8c         : t_aeb_gen_cfg_reserved_a8c_wr_reg; -- AEB General Configuration Area Register "RESERVED_A8C"
		aeb_gen_cfg_reserved_a90         : t_aeb_gen_cfg_reserved_a90_wr_reg; -- AEB General Configuration Area Register "RESERVED_A90"
		aeb_gen_cfg_reserved_a94         : t_aeb_gen_cfg_reserved_a94_wr_reg; -- AEB General Configuration Area Register "RESERVED_A94"
		aeb_gen_cfg_reserved_a98         : t_aeb_gen_cfg_reserved_a98_wr_reg; -- AEB General Configuration Area Register "RESERVED_A98"
		aeb_gen_cfg_reserved_a9c         : t_aeb_gen_cfg_reserved_a9c_wr_reg; -- AEB General Configuration Area Register "RESERVED_A9C"
		aeb_gen_cfg_reserved_aa0         : t_aeb_gen_cfg_reserved_aa0_wr_reg; -- AEB General Configuration Area Register "RESERVED_AA0"
		aeb_gen_cfg_reserved_aa4         : t_aeb_gen_cfg_reserved_aa4_wr_reg; -- AEB General Configuration Area Register "RESERVED_AA4"
		aeb_gen_cfg_reserved_aa8         : t_aeb_gen_cfg_reserved_aa8_wr_reg; -- AEB General Configuration Area Register "RESERVED_AA8"
		aeb_gen_cfg_reserved_aac         : t_aeb_gen_cfg_reserved_aac_wr_reg; -- AEB General Configuration Area Register "RESERVED_AAC"
		aeb_gen_cfg_reserved_ab0         : t_aeb_gen_cfg_reserved_ab0_wr_reg; -- AEB General Configuration Area Register "RESERVED_AB0"
		aeb_gen_cfg_reserved_ab4         : t_aeb_gen_cfg_reserved_ab4_wr_reg; -- AEB General Configuration Area Register "RESERVED_AB4"
		aeb_gen_cfg_reserved_ab8         : t_aeb_gen_cfg_reserved_ab8_wr_reg; -- AEB General Configuration Area Register "RESERVED_AB8"
		aeb_gen_cfg_reserved_abc         : t_aeb_gen_cfg_reserved_abc_wr_reg; -- AEB General Configuration Area Register "RESERVED_ABC"
		aeb_gen_cfg_reserved_ac0         : t_aeb_gen_cfg_reserved_ac0_wr_reg; -- AEB General Configuration Area Register "RESERVED_AC0"
		aeb_gen_cfg_reserved_ac4         : t_aeb_gen_cfg_reserved_ac4_wr_reg; -- AEB General Configuration Area Register "RESERVED_AC4"
		aeb_gen_cfg_reserved_ac8         : t_aeb_gen_cfg_reserved_ac8_wr_reg; -- AEB General Configuration Area Register "RESERVED_AC8"
		aeb_gen_cfg_reserved_acc         : t_aeb_gen_cfg_reserved_acc_wr_reg; -- AEB General Configuration Area Register "RESERVED_ACC"
		aeb_gen_cfg_reserved_ad0         : t_aeb_gen_cfg_reserved_ad0_wr_reg; -- AEB General Configuration Area Register "RESERVED_AD0"
		aeb_gen_cfg_reserved_ad4         : t_aeb_gen_cfg_reserved_ad4_wr_reg; -- AEB General Configuration Area Register "RESERVED_AD4"
		aeb_gen_cfg_reserved_ad8         : t_aeb_gen_cfg_reserved_ad8_wr_reg; -- AEB General Configuration Area Register "RESERVED_AD8"
		aeb_gen_cfg_reserved_adc         : t_aeb_gen_cfg_reserved_adc_wr_reg; -- AEB General Configuration Area Register "RESERVED_ADC"
		aeb_gen_cfg_reserved_ae0         : t_aeb_gen_cfg_reserved_ae0_wr_reg; -- AEB General Configuration Area Register "RESERVED_AE0"
		aeb_gen_cfg_reserved_ae4         : t_aeb_gen_cfg_reserved_ae4_wr_reg; -- AEB General Configuration Area Register "RESERVED_AE4"
		aeb_gen_cfg_reserved_ae8         : t_aeb_gen_cfg_reserved_ae8_wr_reg; -- AEB General Configuration Area Register "RESERVED_AE8"
		aeb_gen_cfg_reserved_aec         : t_aeb_gen_cfg_reserved_aec_wr_reg; -- AEB General Configuration Area Register "RESERVED_AEC"
		aeb_gen_cfg_reserved_af0         : t_aeb_gen_cfg_reserved_af0_wr_reg; -- AEB General Configuration Area Register "RESERVED_AF0"
		aeb_gen_cfg_reserved_af4         : t_aeb_gen_cfg_reserved_af4_wr_reg; -- AEB General Configuration Area Register "RESERVED_AF4"
		aeb_gen_cfg_reserved_af8         : t_aeb_gen_cfg_reserved_af8_wr_reg; -- AEB General Configuration Area Register "RESERVED_AF8"
		aeb_gen_cfg_reserved_afc         : t_aeb_gen_cfg_reserved_afc_wr_reg; -- AEB General Configuration Area Register "RESERVED_AFC"
		aeb_gen_cfg_reserved_b00         : t_aeb_gen_cfg_reserved_b00_wr_reg; -- AEB General Configuration Area Register "RESERVED_B00"
		aeb_gen_cfg_reserved_b04         : t_aeb_gen_cfg_reserved_b04_wr_reg; -- AEB General Configuration Area Register "RESERVED_B04"
		aeb_gen_cfg_reserved_b08         : t_aeb_gen_cfg_reserved_b08_wr_reg; -- AEB General Configuration Area Register "RESERVED_B08"
		aeb_gen_cfg_reserved_b0c         : t_aeb_gen_cfg_reserved_b0c_wr_reg; -- AEB General Configuration Area Register "RESERVED_B0C"
		aeb_gen_cfg_reserved_b10         : t_aeb_gen_cfg_reserved_b10_wr_reg; -- AEB General Configuration Area Register "RESERVED_B10"
		aeb_gen_cfg_reserved_b14         : t_aeb_gen_cfg_reserved_b14_wr_reg; -- AEB General Configuration Area Register "RESERVED_B14"
		aeb_gen_cfg_reserved_b18         : t_aeb_gen_cfg_reserved_b18_wr_reg; -- AEB General Configuration Area Register "RESERVED_B18"
		aeb_gen_cfg_reserved_b1c         : t_aeb_gen_cfg_reserved_b1c_wr_reg; -- AEB General Configuration Area Register "RESERVED_B1C"
		aeb_gen_cfg_reserved_b20         : t_aeb_gen_cfg_reserved_b20_wr_reg; -- AEB General Configuration Area Register "RESERVED_B20"
		aeb_gen_cfg_reserved_b24         : t_aeb_gen_cfg_reserved_b24_wr_reg; -- AEB General Configuration Area Register "RESERVED_B24"
		aeb_gen_cfg_reserved_b28         : t_aeb_gen_cfg_reserved_b28_wr_reg; -- AEB General Configuration Area Register "RESERVED_B28"
		aeb_gen_cfg_reserved_b2c         : t_aeb_gen_cfg_reserved_b2c_wr_reg; -- AEB General Configuration Area Register "RESERVED_B2C"
		aeb_gen_cfg_reserved_b30         : t_aeb_gen_cfg_reserved_b30_wr_reg; -- AEB General Configuration Area Register "RESERVED_B30"
		aeb_gen_cfg_reserved_b34         : t_aeb_gen_cfg_reserved_b34_wr_reg; -- AEB General Configuration Area Register "RESERVED_B34"
		aeb_gen_cfg_reserved_b38         : t_aeb_gen_cfg_reserved_b38_wr_reg; -- AEB General Configuration Area Register "RESERVED_B38"
		aeb_gen_cfg_reserved_b3c         : t_aeb_gen_cfg_reserved_b3c_wr_reg; -- AEB General Configuration Area Register "RESERVED_B3C"
		aeb_gen_cfg_reserved_b40         : t_aeb_gen_cfg_reserved_b40_wr_reg; -- AEB General Configuration Area Register "RESERVED_B40"
		aeb_gen_cfg_reserved_b44         : t_aeb_gen_cfg_reserved_b44_wr_reg; -- AEB General Configuration Area Register "RESERVED_B44"
		aeb_gen_cfg_reserved_b48         : t_aeb_gen_cfg_reserved_b48_wr_reg; -- AEB General Configuration Area Register "RESERVED_B48"
		aeb_gen_cfg_reserved_b4c         : t_aeb_gen_cfg_reserved_b4c_wr_reg; -- AEB General Configuration Area Register "RESERVED_B4C"
		aeb_gen_cfg_reserved_b50         : t_aeb_gen_cfg_reserved_b50_wr_reg; -- AEB General Configuration Area Register "RESERVED_B50"
		aeb_gen_cfg_reserved_b54         : t_aeb_gen_cfg_reserved_b54_wr_reg; -- AEB General Configuration Area Register "RESERVED_B54"
		aeb_gen_cfg_reserved_b58         : t_aeb_gen_cfg_reserved_b58_wr_reg; -- AEB General Configuration Area Register "RESERVED_B58"
		aeb_gen_cfg_reserved_b5c         : t_aeb_gen_cfg_reserved_b5c_wr_reg; -- AEB General Configuration Area Register "RESERVED_B5C"
		aeb_gen_cfg_reserved_b60         : t_aeb_gen_cfg_reserved_b60_wr_reg; -- AEB General Configuration Area Register "RESERVED_B60"
		aeb_gen_cfg_reserved_b64         : t_aeb_gen_cfg_reserved_b64_wr_reg; -- AEB General Configuration Area Register "RESERVED_B64"
		aeb_gen_cfg_reserved_b68         : t_aeb_gen_cfg_reserved_b68_wr_reg; -- AEB General Configuration Area Register "RESERVED_B68"
		aeb_gen_cfg_reserved_b6c         : t_aeb_gen_cfg_reserved_b6c_wr_reg; -- AEB General Configuration Area Register "RESERVED_B6C"
		aeb_gen_cfg_reserved_b70         : t_aeb_gen_cfg_reserved_b70_wr_reg; -- AEB General Configuration Area Register "RESERVED_B70"
		aeb_gen_cfg_reserved_b74         : t_aeb_gen_cfg_reserved_b74_wr_reg; -- AEB General Configuration Area Register "RESERVED_B74"
		aeb_gen_cfg_reserved_b78         : t_aeb_gen_cfg_reserved_b78_wr_reg; -- AEB General Configuration Area Register "RESERVED_B78"
		aeb_gen_cfg_reserved_b7c         : t_aeb_gen_cfg_reserved_b7c_wr_reg; -- AEB General Configuration Area Register "RESERVED_B7C"
		aeb_gen_cfg_reserved_b80         : t_aeb_gen_cfg_reserved_b80_wr_reg; -- AEB General Configuration Area Register "RESERVED_B80"
		aeb_gen_cfg_reserved_b84         : t_aeb_gen_cfg_reserved_b84_wr_reg; -- AEB General Configuration Area Register "RESERVED_B84"
		aeb_gen_cfg_reserved_b88         : t_aeb_gen_cfg_reserved_b88_wr_reg; -- AEB General Configuration Area Register "RESERVED_B88"
		aeb_gen_cfg_reserved_b8c         : t_aeb_gen_cfg_reserved_b8c_wr_reg; -- AEB General Configuration Area Register "RESERVED_B8C"
		aeb_gen_cfg_reserved_b90         : t_aeb_gen_cfg_reserved_b90_wr_reg; -- AEB General Configuration Area Register "RESERVED_B90"
		aeb_gen_cfg_reserved_b94         : t_aeb_gen_cfg_reserved_b94_wr_reg; -- AEB General Configuration Area Register "RESERVED_B94"
		aeb_gen_cfg_reserved_b98         : t_aeb_gen_cfg_reserved_b98_wr_reg; -- AEB General Configuration Area Register "RESERVED_B98"
		aeb_gen_cfg_reserved_b9c         : t_aeb_gen_cfg_reserved_b9c_wr_reg; -- AEB General Configuration Area Register "RESERVED_B9C"
		aeb_gen_cfg_reserved_ba0         : t_aeb_gen_cfg_reserved_ba0_wr_reg; -- AEB General Configuration Area Register "RESERVED_BA0"
		aeb_gen_cfg_reserved_ba4         : t_aeb_gen_cfg_reserved_ba4_wr_reg; -- AEB General Configuration Area Register "RESERVED_BA4"
		aeb_gen_cfg_reserved_ba8         : t_aeb_gen_cfg_reserved_ba8_wr_reg; -- AEB General Configuration Area Register "RESERVED_BA8"
		aeb_gen_cfg_reserved_bac         : t_aeb_gen_cfg_reserved_bac_wr_reg; -- AEB General Configuration Area Register "RESERVED_BAC"
		aeb_gen_cfg_reserved_bb0         : t_aeb_gen_cfg_reserved_bb0_wr_reg; -- AEB General Configuration Area Register "RESERVED_BB0"
		aeb_gen_cfg_reserved_bb4         : t_aeb_gen_cfg_reserved_bb4_wr_reg; -- AEB General Configuration Area Register "RESERVED_BB4"
		aeb_gen_cfg_reserved_bb8         : t_aeb_gen_cfg_reserved_bb8_wr_reg; -- AEB General Configuration Area Register "RESERVED_BB8"
		aeb_gen_cfg_reserved_bbc         : t_aeb_gen_cfg_reserved_bbc_wr_reg; -- AEB General Configuration Area Register "RESERVED_BBC"
		aeb_gen_cfg_reserved_bc0         : t_aeb_gen_cfg_reserved_bc0_wr_reg; -- AEB General Configuration Area Register "RESERVED_BC0"
		aeb_gen_cfg_reserved_bc4         : t_aeb_gen_cfg_reserved_bc4_wr_reg; -- AEB General Configuration Area Register "RESERVED_BC4"
		aeb_gen_cfg_reserved_bc8         : t_aeb_gen_cfg_reserved_bc8_wr_reg; -- AEB General Configuration Area Register "RESERVED_BC8"
		aeb_gen_cfg_reserved_bcc         : t_aeb_gen_cfg_reserved_bcc_wr_reg; -- AEB General Configuration Area Register "RESERVED_BCC"
		aeb_gen_cfg_reserved_bd0         : t_aeb_gen_cfg_reserved_bd0_wr_reg; -- AEB General Configuration Area Register "RESERVED_BD0"
		aeb_gen_cfg_reserved_bd4         : t_aeb_gen_cfg_reserved_bd4_wr_reg; -- AEB General Configuration Area Register "RESERVED_BD4"
		aeb_gen_cfg_reserved_bd8         : t_aeb_gen_cfg_reserved_bd8_wr_reg; -- AEB General Configuration Area Register "RESERVED_BD8"
		aeb_gen_cfg_reserved_bdc         : t_aeb_gen_cfg_reserved_bdc_wr_reg; -- AEB General Configuration Area Register "RESERVED_BDC"
		aeb_gen_cfg_reserved_be0         : t_aeb_gen_cfg_reserved_be0_wr_reg; -- AEB General Configuration Area Register "RESERVED_BE0"
		aeb_gen_cfg_reserved_be4         : t_aeb_gen_cfg_reserved_be4_wr_reg; -- AEB General Configuration Area Register "RESERVED_BE4"
		aeb_gen_cfg_reserved_be8         : t_aeb_gen_cfg_reserved_be8_wr_reg; -- AEB General Configuration Area Register "RESERVED_BE8"
		aeb_gen_cfg_reserved_bec         : t_aeb_gen_cfg_reserved_bec_wr_reg; -- AEB General Configuration Area Register "RESERVED_BEC"
		aeb_gen_cfg_reserved_bf0         : t_aeb_gen_cfg_reserved_bf0_wr_reg; -- AEB General Configuration Area Register "RESERVED_BF0"
		aeb_gen_cfg_reserved_bf4         : t_aeb_gen_cfg_reserved_bf4_wr_reg; -- AEB General Configuration Area Register "RESERVED_BF4"
		aeb_gen_cfg_reserved_bf8         : t_aeb_gen_cfg_reserved_bf8_wr_reg; -- AEB General Configuration Area Register "RESERVED_BF8"
		aeb_gen_cfg_reserved_bfc         : t_aeb_gen_cfg_reserved_bfc_wr_reg; -- AEB General Configuration Area Register "RESERVED_BFC"
		aeb_gen_cfg_reserved_c00         : t_aeb_gen_cfg_reserved_c00_wr_reg; -- AEB General Configuration Area Register "RESERVED_C00"
		aeb_gen_cfg_reserved_c04         : t_aeb_gen_cfg_reserved_c04_wr_reg; -- AEB General Configuration Area Register "RESERVED_C04"
		aeb_gen_cfg_reserved_c08         : t_aeb_gen_cfg_reserved_c08_wr_reg; -- AEB General Configuration Area Register "RESERVED_C08"
		aeb_gen_cfg_reserved_c0c         : t_aeb_gen_cfg_reserved_c0c_wr_reg; -- AEB General Configuration Area Register "RESERVED_C0C"
		aeb_gen_cfg_reserved_c10         : t_aeb_gen_cfg_reserved_c10_wr_reg; -- AEB General Configuration Area Register "RESERVED_C10"
		aeb_gen_cfg_reserved_c14         : t_aeb_gen_cfg_reserved_c14_wr_reg; -- AEB General Configuration Area Register "RESERVED_C14"
		aeb_gen_cfg_reserved_c18         : t_aeb_gen_cfg_reserved_c18_wr_reg; -- AEB General Configuration Area Register "RESERVED_C18"
		aeb_gen_cfg_reserved_c1c         : t_aeb_gen_cfg_reserved_c1c_wr_reg; -- AEB General Configuration Area Register "RESERVED_C1C"
		aeb_gen_cfg_reserved_c20         : t_aeb_gen_cfg_reserved_c20_wr_reg; -- AEB General Configuration Area Register "RESERVED_C20"
		aeb_gen_cfg_reserved_c24         : t_aeb_gen_cfg_reserved_c24_wr_reg; -- AEB General Configuration Area Register "RESERVED_C24"
		aeb_gen_cfg_reserved_c28         : t_aeb_gen_cfg_reserved_c28_wr_reg; -- AEB General Configuration Area Register "RESERVED_C28"
		aeb_gen_cfg_reserved_c2c         : t_aeb_gen_cfg_reserved_c2c_wr_reg; -- AEB General Configuration Area Register "RESERVED_C2C"
		aeb_gen_cfg_reserved_c30         : t_aeb_gen_cfg_reserved_c30_wr_reg; -- AEB General Configuration Area Register "RESERVED_C30"
		aeb_gen_cfg_reserved_c34         : t_aeb_gen_cfg_reserved_c34_wr_reg; -- AEB General Configuration Area Register "RESERVED_C34"
		aeb_gen_cfg_reserved_c38         : t_aeb_gen_cfg_reserved_c38_wr_reg; -- AEB General Configuration Area Register "RESERVED_C38"
		aeb_gen_cfg_reserved_c3c         : t_aeb_gen_cfg_reserved_c3c_wr_reg; -- AEB General Configuration Area Register "RESERVED_C3C"
		aeb_gen_cfg_reserved_c40         : t_aeb_gen_cfg_reserved_c40_wr_reg; -- AEB General Configuration Area Register "RESERVED_C40"
		aeb_gen_cfg_reserved_c44         : t_aeb_gen_cfg_reserved_c44_wr_reg; -- AEB General Configuration Area Register "RESERVED_C44"
		aeb_gen_cfg_reserved_c48         : t_aeb_gen_cfg_reserved_c48_wr_reg; -- AEB General Configuration Area Register "RESERVED_C48"
		aeb_gen_cfg_reserved_c4c         : t_aeb_gen_cfg_reserved_c4c_wr_reg; -- AEB General Configuration Area Register "RESERVED_C4C"
		aeb_gen_cfg_reserved_c50         : t_aeb_gen_cfg_reserved_c50_wr_reg; -- AEB General Configuration Area Register "RESERVED_C50"
		aeb_gen_cfg_reserved_c54         : t_aeb_gen_cfg_reserved_c54_wr_reg; -- AEB General Configuration Area Register "RESERVED_C54"
		aeb_gen_cfg_reserved_c58         : t_aeb_gen_cfg_reserved_c58_wr_reg; -- AEB General Configuration Area Register "RESERVED_C58"
		aeb_gen_cfg_reserved_c5c         : t_aeb_gen_cfg_reserved_c5c_wr_reg; -- AEB General Configuration Area Register "RESERVED_C5C"
		aeb_gen_cfg_reserved_c60         : t_aeb_gen_cfg_reserved_c60_wr_reg; -- AEB General Configuration Area Register "RESERVED_C60"
		aeb_gen_cfg_reserved_c64         : t_aeb_gen_cfg_reserved_c64_wr_reg; -- AEB General Configuration Area Register "RESERVED_C64"
		aeb_gen_cfg_reserved_c68         : t_aeb_gen_cfg_reserved_c68_wr_reg; -- AEB General Configuration Area Register "RESERVED_C68"
		aeb_gen_cfg_reserved_c6c         : t_aeb_gen_cfg_reserved_c6c_wr_reg; -- AEB General Configuration Area Register "RESERVED_C6C"
		aeb_gen_cfg_reserved_c70         : t_aeb_gen_cfg_reserved_c70_wr_reg; -- AEB General Configuration Area Register "RESERVED_C70"
		aeb_gen_cfg_reserved_c74         : t_aeb_gen_cfg_reserved_c74_wr_reg; -- AEB General Configuration Area Register "RESERVED_C74"
		aeb_gen_cfg_reserved_c78         : t_aeb_gen_cfg_reserved_c78_wr_reg; -- AEB General Configuration Area Register "RESERVED_C78"
		aeb_gen_cfg_reserved_c7c         : t_aeb_gen_cfg_reserved_c7c_wr_reg; -- AEB General Configuration Area Register "RESERVED_C7C"
		aeb_gen_cfg_reserved_c80         : t_aeb_gen_cfg_reserved_c80_wr_reg; -- AEB General Configuration Area Register "RESERVED_C80"
		aeb_gen_cfg_reserved_c84         : t_aeb_gen_cfg_reserved_c84_wr_reg; -- AEB General Configuration Area Register "RESERVED_C84"
		aeb_gen_cfg_reserved_c88         : t_aeb_gen_cfg_reserved_c88_wr_reg; -- AEB General Configuration Area Register "RESERVED_C88"
		aeb_gen_cfg_reserved_c8c         : t_aeb_gen_cfg_reserved_c8c_wr_reg; -- AEB General Configuration Area Register "RESERVED_C8C"
		aeb_gen_cfg_reserved_c90         : t_aeb_gen_cfg_reserved_c90_wr_reg; -- AEB General Configuration Area Register "RESERVED_C90"
		aeb_gen_cfg_reserved_c94         : t_aeb_gen_cfg_reserved_c94_wr_reg; -- AEB General Configuration Area Register "RESERVED_C94"
		aeb_gen_cfg_reserved_c98         : t_aeb_gen_cfg_reserved_c98_wr_reg; -- AEB General Configuration Area Register "RESERVED_C98"
		aeb_gen_cfg_reserved_c9c         : t_aeb_gen_cfg_reserved_c9c_wr_reg; -- AEB General Configuration Area Register "RESERVED_C9C"
		aeb_gen_cfg_reserved_ca0         : t_aeb_gen_cfg_reserved_ca0_wr_reg; -- AEB General Configuration Area Register "RESERVED_CA0"
		aeb_gen_cfg_reserved_ca4         : t_aeb_gen_cfg_reserved_ca4_wr_reg; -- AEB General Configuration Area Register "RESERVED_CA4"
		aeb_gen_cfg_reserved_ca8         : t_aeb_gen_cfg_reserved_ca8_wr_reg; -- AEB General Configuration Area Register "RESERVED_CA8"
		aeb_gen_cfg_reserved_cac         : t_aeb_gen_cfg_reserved_cac_wr_reg; -- AEB General Configuration Area Register "RESERVED_CAC"
		aeb_gen_cfg_reserved_cb0         : t_aeb_gen_cfg_reserved_cb0_wr_reg; -- AEB General Configuration Area Register "RESERVED_CB0"
		aeb_gen_cfg_reserved_cb4         : t_aeb_gen_cfg_reserved_cb4_wr_reg; -- AEB General Configuration Area Register "RESERVED_CB4"
		aeb_gen_cfg_reserved_cb8         : t_aeb_gen_cfg_reserved_cb8_wr_reg; -- AEB General Configuration Area Register "RESERVED_CB8"
		aeb_gen_cfg_reserved_cbc         : t_aeb_gen_cfg_reserved_cbc_wr_reg; -- AEB General Configuration Area Register "RESERVED_CBC"
		aeb_gen_cfg_reserved_cc0         : t_aeb_gen_cfg_reserved_cc0_wr_reg; -- AEB General Configuration Area Register "RESERVED_CC0"
		aeb_gen_cfg_reserved_cc4         : t_aeb_gen_cfg_reserved_cc4_wr_reg; -- AEB General Configuration Area Register "RESERVED_CC4"
		aeb_gen_cfg_reserved_cc8         : t_aeb_gen_cfg_reserved_cc8_wr_reg; -- AEB General Configuration Area Register "RESERVED_CC8"
		aeb_gen_cfg_reserved_ccc         : t_aeb_gen_cfg_reserved_ccc_wr_reg; -- AEB General Configuration Area Register "RESERVED_CCC"
		aeb_gen_cfg_reserved_cd0         : t_aeb_gen_cfg_reserved_cd0_wr_reg; -- AEB General Configuration Area Register "RESERVED_CD0"
		aeb_gen_cfg_reserved_cd4         : t_aeb_gen_cfg_reserved_cd4_wr_reg; -- AEB General Configuration Area Register "RESERVED_CD4"
		aeb_gen_cfg_reserved_cd8         : t_aeb_gen_cfg_reserved_cd8_wr_reg; -- AEB General Configuration Area Register "RESERVED_CD8"
		aeb_gen_cfg_reserved_cdc         : t_aeb_gen_cfg_reserved_cdc_wr_reg; -- AEB General Configuration Area Register "RESERVED_CDC"
		aeb_gen_cfg_reserved_ce0         : t_aeb_gen_cfg_reserved_ce0_wr_reg; -- AEB General Configuration Area Register "RESERVED_CE0"
		aeb_gen_cfg_reserved_ce4         : t_aeb_gen_cfg_reserved_ce4_wr_reg; -- AEB General Configuration Area Register "RESERVED_CE4"
		aeb_gen_cfg_reserved_ce8         : t_aeb_gen_cfg_reserved_ce8_wr_reg; -- AEB General Configuration Area Register "RESERVED_CE8"
		aeb_gen_cfg_reserved_cec         : t_aeb_gen_cfg_reserved_cec_wr_reg; -- AEB General Configuration Area Register "RESERVED_CEC"
		aeb_gen_cfg_reserved_cf0         : t_aeb_gen_cfg_reserved_cf0_wr_reg; -- AEB General Configuration Area Register "RESERVED_CF0"
		aeb_gen_cfg_reserved_cf4         : t_aeb_gen_cfg_reserved_cf4_wr_reg; -- AEB General Configuration Area Register "RESERVED_CF4"
		aeb_gen_cfg_reserved_cf8         : t_aeb_gen_cfg_reserved_cf8_wr_reg; -- AEB General Configuration Area Register "RESERVED_CF8"
		aeb_gen_cfg_reserved_cfc         : t_aeb_gen_cfg_reserved_cfc_wr_reg; -- AEB General Configuration Area Register "RESERVED_CFC"
		aeb_gen_cfg_reserved_d00         : t_aeb_gen_cfg_reserved_d00_wr_reg; -- AEB General Configuration Area Register "RESERVED_D00"
		aeb_gen_cfg_reserved_d04         : t_aeb_gen_cfg_reserved_d04_wr_reg; -- AEB General Configuration Area Register "RESERVED_D04"
		aeb_gen_cfg_reserved_d08         : t_aeb_gen_cfg_reserved_d08_wr_reg; -- AEB General Configuration Area Register "RESERVED_D08"
		aeb_gen_cfg_reserved_d0c         : t_aeb_gen_cfg_reserved_d0c_wr_reg; -- AEB General Configuration Area Register "RESERVED_D0C"
		aeb_gen_cfg_reserved_d10         : t_aeb_gen_cfg_reserved_d10_wr_reg; -- AEB General Configuration Area Register "RESERVED_D10"
		aeb_gen_cfg_reserved_d14         : t_aeb_gen_cfg_reserved_d14_wr_reg; -- AEB General Configuration Area Register "RESERVED_D14"
		aeb_gen_cfg_reserved_d18         : t_aeb_gen_cfg_reserved_d18_wr_reg; -- AEB General Configuration Area Register "RESERVED_D18"
		aeb_gen_cfg_reserved_d1c         : t_aeb_gen_cfg_reserved_d1c_wr_reg; -- AEB General Configuration Area Register "RESERVED_D1C"
		aeb_gen_cfg_reserved_d20         : t_aeb_gen_cfg_reserved_d20_wr_reg; -- AEB General Configuration Area Register "RESERVED_D20"
		aeb_gen_cfg_reserved_d24         : t_aeb_gen_cfg_reserved_d24_wr_reg; -- AEB General Configuration Area Register "RESERVED_D24"
		aeb_gen_cfg_reserved_d28         : t_aeb_gen_cfg_reserved_d28_wr_reg; -- AEB General Configuration Area Register "RESERVED_D28"
		aeb_gen_cfg_reserved_d2c         : t_aeb_gen_cfg_reserved_d2c_wr_reg; -- AEB General Configuration Area Register "RESERVED_D2C"
		aeb_gen_cfg_reserved_d30         : t_aeb_gen_cfg_reserved_d30_wr_reg; -- AEB General Configuration Area Register "RESERVED_D30"
		aeb_gen_cfg_reserved_d34         : t_aeb_gen_cfg_reserved_d34_wr_reg; -- AEB General Configuration Area Register "RESERVED_D34"
		aeb_gen_cfg_reserved_d38         : t_aeb_gen_cfg_reserved_d38_wr_reg; -- AEB General Configuration Area Register "RESERVED_D38"
		aeb_gen_cfg_reserved_d3c         : t_aeb_gen_cfg_reserved_d3c_wr_reg; -- AEB General Configuration Area Register "RESERVED_D3C"
		aeb_gen_cfg_reserved_d40         : t_aeb_gen_cfg_reserved_d40_wr_reg; -- AEB General Configuration Area Register "RESERVED_D40"
		aeb_gen_cfg_reserved_d44         : t_aeb_gen_cfg_reserved_d44_wr_reg; -- AEB General Configuration Area Register "RESERVED_D44"
		aeb_gen_cfg_reserved_d48         : t_aeb_gen_cfg_reserved_d48_wr_reg; -- AEB General Configuration Area Register "RESERVED_D48"
		aeb_gen_cfg_reserved_d4c         : t_aeb_gen_cfg_reserved_d4c_wr_reg; -- AEB General Configuration Area Register "RESERVED_D4C"
		aeb_gen_cfg_reserved_d50         : t_aeb_gen_cfg_reserved_d50_wr_reg; -- AEB General Configuration Area Register "RESERVED_D50"
		aeb_gen_cfg_reserved_d54         : t_aeb_gen_cfg_reserved_d54_wr_reg; -- AEB General Configuration Area Register "RESERVED_D54"
		aeb_gen_cfg_reserved_d58         : t_aeb_gen_cfg_reserved_d58_wr_reg; -- AEB General Configuration Area Register "RESERVED_D58"
		aeb_gen_cfg_reserved_d5c         : t_aeb_gen_cfg_reserved_d5c_wr_reg; -- AEB General Configuration Area Register "RESERVED_D5C"
		aeb_gen_cfg_reserved_d60         : t_aeb_gen_cfg_reserved_d60_wr_reg; -- AEB General Configuration Area Register "RESERVED_D60"
		aeb_gen_cfg_reserved_d64         : t_aeb_gen_cfg_reserved_d64_wr_reg; -- AEB General Configuration Area Register "RESERVED_D64"
		aeb_gen_cfg_reserved_d68         : t_aeb_gen_cfg_reserved_d68_wr_reg; -- AEB General Configuration Area Register "RESERVED_D68"
		aeb_gen_cfg_reserved_d6c         : t_aeb_gen_cfg_reserved_d6c_wr_reg; -- AEB General Configuration Area Register "RESERVED_D6C"
		aeb_gen_cfg_reserved_d70         : t_aeb_gen_cfg_reserved_d70_wr_reg; -- AEB General Configuration Area Register "RESERVED_D70"
		aeb_gen_cfg_reserved_d74         : t_aeb_gen_cfg_reserved_d74_wr_reg; -- AEB General Configuration Area Register "RESERVED_D74"
		aeb_gen_cfg_reserved_d78         : t_aeb_gen_cfg_reserved_d78_wr_reg; -- AEB General Configuration Area Register "RESERVED_D78"
		aeb_gen_cfg_reserved_d7c         : t_aeb_gen_cfg_reserved_d7c_wr_reg; -- AEB General Configuration Area Register "RESERVED_D7C"
		aeb_gen_cfg_reserved_d80         : t_aeb_gen_cfg_reserved_d80_wr_reg; -- AEB General Configuration Area Register "RESERVED_D80"
		aeb_gen_cfg_reserved_d84         : t_aeb_gen_cfg_reserved_d84_wr_reg; -- AEB General Configuration Area Register "RESERVED_D84"
		aeb_gen_cfg_reserved_d88         : t_aeb_gen_cfg_reserved_d88_wr_reg; -- AEB General Configuration Area Register "RESERVED_D88"
		aeb_gen_cfg_reserved_d8c         : t_aeb_gen_cfg_reserved_d8c_wr_reg; -- AEB General Configuration Area Register "RESERVED_D8C"
		aeb_gen_cfg_reserved_d90         : t_aeb_gen_cfg_reserved_d90_wr_reg; -- AEB General Configuration Area Register "RESERVED_D90"
		aeb_gen_cfg_reserved_d94         : t_aeb_gen_cfg_reserved_d94_wr_reg; -- AEB General Configuration Area Register "RESERVED_D94"
		aeb_gen_cfg_reserved_d98         : t_aeb_gen_cfg_reserved_d98_wr_reg; -- AEB General Configuration Area Register "RESERVED_D98"
		aeb_gen_cfg_reserved_d9c         : t_aeb_gen_cfg_reserved_d9c_wr_reg; -- AEB General Configuration Area Register "RESERVED_D9C"
		aeb_gen_cfg_reserved_da0         : t_aeb_gen_cfg_reserved_da0_wr_reg; -- AEB General Configuration Area Register "RESERVED_DA0"
		aeb_gen_cfg_reserved_da4         : t_aeb_gen_cfg_reserved_da4_wr_reg; -- AEB General Configuration Area Register "RESERVED_DA4"
		aeb_gen_cfg_reserved_da8         : t_aeb_gen_cfg_reserved_da8_wr_reg; -- AEB General Configuration Area Register "RESERVED_DA8"
		aeb_gen_cfg_reserved_dac         : t_aeb_gen_cfg_reserved_dac_wr_reg; -- AEB General Configuration Area Register "RESERVED_DAC"
		aeb_gen_cfg_reserved_db0         : t_aeb_gen_cfg_reserved_db0_wr_reg; -- AEB General Configuration Area Register "RESERVED_DB0"
		aeb_gen_cfg_reserved_db4         : t_aeb_gen_cfg_reserved_db4_wr_reg; -- AEB General Configuration Area Register "RESERVED_DB4"
		aeb_gen_cfg_reserved_db8         : t_aeb_gen_cfg_reserved_db8_wr_reg; -- AEB General Configuration Area Register "RESERVED_DB8"
		aeb_gen_cfg_reserved_dbc         : t_aeb_gen_cfg_reserved_dbc_wr_reg; -- AEB General Configuration Area Register "RESERVED_DBC"
		aeb_gen_cfg_reserved_dc0         : t_aeb_gen_cfg_reserved_dc0_wr_reg; -- AEB General Configuration Area Register "RESERVED_DC0"
		aeb_gen_cfg_reserved_dc4         : t_aeb_gen_cfg_reserved_dc4_wr_reg; -- AEB General Configuration Area Register "RESERVED_DC4"
		aeb_gen_cfg_reserved_dc8         : t_aeb_gen_cfg_reserved_dc8_wr_reg; -- AEB General Configuration Area Register "RESERVED_DC8"
		aeb_gen_cfg_reserved_dcc         : t_aeb_gen_cfg_reserved_dcc_wr_reg; -- AEB General Configuration Area Register "RESERVED_DCC"
		aeb_gen_cfg_reserved_dd0         : t_aeb_gen_cfg_reserved_dd0_wr_reg; -- AEB General Configuration Area Register "RESERVED_DD0"
		aeb_gen_cfg_reserved_dd4         : t_aeb_gen_cfg_reserved_dd4_wr_reg; -- AEB General Configuration Area Register "RESERVED_DD4"
		aeb_gen_cfg_reserved_dd8         : t_aeb_gen_cfg_reserved_dd8_wr_reg; -- AEB General Configuration Area Register "RESERVED_DD8"
		aeb_gen_cfg_reserved_ddc         : t_aeb_gen_cfg_reserved_ddc_wr_reg; -- AEB General Configuration Area Register "RESERVED_DDC"
		aeb_gen_cfg_reserved_de0         : t_aeb_gen_cfg_reserved_de0_wr_reg; -- AEB General Configuration Area Register "RESERVED_DE0"
		aeb_gen_cfg_reserved_de4         : t_aeb_gen_cfg_reserved_de4_wr_reg; -- AEB General Configuration Area Register "RESERVED_DE4"
		aeb_gen_cfg_reserved_de8         : t_aeb_gen_cfg_reserved_de8_wr_reg; -- AEB General Configuration Area Register "RESERVED_DE8"
		aeb_gen_cfg_reserved_dec         : t_aeb_gen_cfg_reserved_dec_wr_reg; -- AEB General Configuration Area Register "RESERVED_DEC"
		aeb_gen_cfg_reserved_df0         : t_aeb_gen_cfg_reserved_df0_wr_reg; -- AEB General Configuration Area Register "RESERVED_DF0"
		aeb_gen_cfg_reserved_df4         : t_aeb_gen_cfg_reserved_df4_wr_reg; -- AEB General Configuration Area Register "RESERVED_DF4"
		aeb_gen_cfg_reserved_df8         : t_aeb_gen_cfg_reserved_df8_wr_reg; -- AEB General Configuration Area Register "RESERVED_DF8"
		aeb_gen_cfg_reserved_dfc         : t_aeb_gen_cfg_reserved_dfc_wr_reg; -- AEB General Configuration Area Register "RESERVED_DFC"
		aeb_gen_cfg_reserved_e00         : t_aeb_gen_cfg_reserved_e00_wr_reg; -- AEB General Configuration Area Register "RESERVED_E00"
		aeb_gen_cfg_reserved_e04         : t_aeb_gen_cfg_reserved_e04_wr_reg; -- AEB General Configuration Area Register "RESERVED_E04"
		aeb_gen_cfg_reserved_e08         : t_aeb_gen_cfg_reserved_e08_wr_reg; -- AEB General Configuration Area Register "RESERVED_E08"
		aeb_gen_cfg_reserved_e0c         : t_aeb_gen_cfg_reserved_e0c_wr_reg; -- AEB General Configuration Area Register "RESERVED_E0C"
		aeb_gen_cfg_reserved_e10         : t_aeb_gen_cfg_reserved_e10_wr_reg; -- AEB General Configuration Area Register "RESERVED_E10"
		aeb_gen_cfg_reserved_e14         : t_aeb_gen_cfg_reserved_e14_wr_reg; -- AEB General Configuration Area Register "RESERVED_E14"
		aeb_gen_cfg_reserved_e18         : t_aeb_gen_cfg_reserved_e18_wr_reg; -- AEB General Configuration Area Register "RESERVED_E18"
		aeb_gen_cfg_reserved_e1c         : t_aeb_gen_cfg_reserved_e1c_wr_reg; -- AEB General Configuration Area Register "RESERVED_E1C"
		aeb_gen_cfg_reserved_e20         : t_aeb_gen_cfg_reserved_e20_wr_reg; -- AEB General Configuration Area Register "RESERVED_E20"
		aeb_gen_cfg_reserved_e24         : t_aeb_gen_cfg_reserved_e24_wr_reg; -- AEB General Configuration Area Register "RESERVED_E24"
		aeb_gen_cfg_reserved_e28         : t_aeb_gen_cfg_reserved_e28_wr_reg; -- AEB General Configuration Area Register "RESERVED_E28"
		aeb_gen_cfg_reserved_e2c         : t_aeb_gen_cfg_reserved_e2c_wr_reg; -- AEB General Configuration Area Register "RESERVED_E2C"
		aeb_gen_cfg_reserved_e30         : t_aeb_gen_cfg_reserved_e30_wr_reg; -- AEB General Configuration Area Register "RESERVED_E30"
		aeb_gen_cfg_reserved_e34         : t_aeb_gen_cfg_reserved_e34_wr_reg; -- AEB General Configuration Area Register "RESERVED_E34"
		aeb_gen_cfg_reserved_e38         : t_aeb_gen_cfg_reserved_e38_wr_reg; -- AEB General Configuration Area Register "RESERVED_E38"
		aeb_gen_cfg_reserved_e3c         : t_aeb_gen_cfg_reserved_e3c_wr_reg; -- AEB General Configuration Area Register "RESERVED_E3C"
		aeb_gen_cfg_reserved_e40         : t_aeb_gen_cfg_reserved_e40_wr_reg; -- AEB General Configuration Area Register "RESERVED_E40"
		aeb_gen_cfg_reserved_e44         : t_aeb_gen_cfg_reserved_e44_wr_reg; -- AEB General Configuration Area Register "RESERVED_E44"
		aeb_gen_cfg_reserved_e48         : t_aeb_gen_cfg_reserved_e48_wr_reg; -- AEB General Configuration Area Register "RESERVED_E48"
		aeb_gen_cfg_reserved_e4c         : t_aeb_gen_cfg_reserved_e4c_wr_reg; -- AEB General Configuration Area Register "RESERVED_E4C"
		aeb_gen_cfg_reserved_e50         : t_aeb_gen_cfg_reserved_e50_wr_reg; -- AEB General Configuration Area Register "RESERVED_E50"
		aeb_gen_cfg_reserved_e54         : t_aeb_gen_cfg_reserved_e54_wr_reg; -- AEB General Configuration Area Register "RESERVED_E54"
		aeb_gen_cfg_reserved_e58         : t_aeb_gen_cfg_reserved_e58_wr_reg; -- AEB General Configuration Area Register "RESERVED_E58"
		aeb_gen_cfg_reserved_e5c         : t_aeb_gen_cfg_reserved_e5c_wr_reg; -- AEB General Configuration Area Register "RESERVED_E5C"
		aeb_gen_cfg_reserved_e60         : t_aeb_gen_cfg_reserved_e60_wr_reg; -- AEB General Configuration Area Register "RESERVED_E60"
		aeb_gen_cfg_reserved_e64         : t_aeb_gen_cfg_reserved_e64_wr_reg; -- AEB General Configuration Area Register "RESERVED_E64"
		aeb_gen_cfg_reserved_e68         : t_aeb_gen_cfg_reserved_e68_wr_reg; -- AEB General Configuration Area Register "RESERVED_E68"
		aeb_gen_cfg_reserved_e6c         : t_aeb_gen_cfg_reserved_e6c_wr_reg; -- AEB General Configuration Area Register "RESERVED_E6C"
		aeb_gen_cfg_reserved_e70         : t_aeb_gen_cfg_reserved_e70_wr_reg; -- AEB General Configuration Area Register "RESERVED_E70"
		aeb_gen_cfg_reserved_e74         : t_aeb_gen_cfg_reserved_e74_wr_reg; -- AEB General Configuration Area Register "RESERVED_E74"
		aeb_gen_cfg_reserved_e78         : t_aeb_gen_cfg_reserved_e78_wr_reg; -- AEB General Configuration Area Register "RESERVED_E78"
		aeb_gen_cfg_reserved_e7c         : t_aeb_gen_cfg_reserved_e7c_wr_reg; -- AEB General Configuration Area Register "RESERVED_E7C"
		aeb_gen_cfg_reserved_e80         : t_aeb_gen_cfg_reserved_e80_wr_reg; -- AEB General Configuration Area Register "RESERVED_E80"
		aeb_gen_cfg_reserved_e84         : t_aeb_gen_cfg_reserved_e84_wr_reg; -- AEB General Configuration Area Register "RESERVED_E84"
		aeb_gen_cfg_reserved_e88         : t_aeb_gen_cfg_reserved_e88_wr_reg; -- AEB General Configuration Area Register "RESERVED_E88"
		aeb_gen_cfg_reserved_e8c         : t_aeb_gen_cfg_reserved_e8c_wr_reg; -- AEB General Configuration Area Register "RESERVED_E8C"
		aeb_gen_cfg_reserved_e90         : t_aeb_gen_cfg_reserved_e90_wr_reg; -- AEB General Configuration Area Register "RESERVED_E90"
		aeb_gen_cfg_reserved_e94         : t_aeb_gen_cfg_reserved_e94_wr_reg; -- AEB General Configuration Area Register "RESERVED_E94"
		aeb_gen_cfg_reserved_e98         : t_aeb_gen_cfg_reserved_e98_wr_reg; -- AEB General Configuration Area Register "RESERVED_E98"
		aeb_gen_cfg_reserved_e9c         : t_aeb_gen_cfg_reserved_e9c_wr_reg; -- AEB General Configuration Area Register "RESERVED_E9C"
		aeb_gen_cfg_reserved_ea0         : t_aeb_gen_cfg_reserved_ea0_wr_reg; -- AEB General Configuration Area Register "RESERVED_EA0"
		aeb_gen_cfg_reserved_ea4         : t_aeb_gen_cfg_reserved_ea4_wr_reg; -- AEB General Configuration Area Register "RESERVED_EA4"
		aeb_gen_cfg_reserved_ea8         : t_aeb_gen_cfg_reserved_ea8_wr_reg; -- AEB General Configuration Area Register "RESERVED_EA8"
		aeb_gen_cfg_reserved_eac         : t_aeb_gen_cfg_reserved_eac_wr_reg; -- AEB General Configuration Area Register "RESERVED_EAC"
		aeb_gen_cfg_reserved_eb0         : t_aeb_gen_cfg_reserved_eb0_wr_reg; -- AEB General Configuration Area Register "RESERVED_EB0"
		aeb_gen_cfg_reserved_eb4         : t_aeb_gen_cfg_reserved_eb4_wr_reg; -- AEB General Configuration Area Register "RESERVED_EB4"
		aeb_gen_cfg_reserved_eb8         : t_aeb_gen_cfg_reserved_eb8_wr_reg; -- AEB General Configuration Area Register "RESERVED_EB8"
		aeb_gen_cfg_reserved_ebc         : t_aeb_gen_cfg_reserved_ebc_wr_reg; -- AEB General Configuration Area Register "RESERVED_EBC"
		aeb_gen_cfg_reserved_ec0         : t_aeb_gen_cfg_reserved_ec0_wr_reg; -- AEB General Configuration Area Register "RESERVED_EC0"
		aeb_gen_cfg_reserved_ec4         : t_aeb_gen_cfg_reserved_ec4_wr_reg; -- AEB General Configuration Area Register "RESERVED_EC4"
		aeb_gen_cfg_reserved_ec8         : t_aeb_gen_cfg_reserved_ec8_wr_reg; -- AEB General Configuration Area Register "RESERVED_EC8"
		aeb_gen_cfg_reserved_ecc         : t_aeb_gen_cfg_reserved_ecc_wr_reg; -- AEB General Configuration Area Register "RESERVED_ECC"
		aeb_gen_cfg_reserved_ed0         : t_aeb_gen_cfg_reserved_ed0_wr_reg; -- AEB General Configuration Area Register "RESERVED_ED0"
		aeb_gen_cfg_reserved_ed4         : t_aeb_gen_cfg_reserved_ed4_wr_reg; -- AEB General Configuration Area Register "RESERVED_ED4"
		aeb_gen_cfg_reserved_ed8         : t_aeb_gen_cfg_reserved_ed8_wr_reg; -- AEB General Configuration Area Register "RESERVED_ED8"
		aeb_gen_cfg_reserved_edc         : t_aeb_gen_cfg_reserved_edc_wr_reg; -- AEB General Configuration Area Register "RESERVED_EDC"
		aeb_gen_cfg_reserved_ee0         : t_aeb_gen_cfg_reserved_ee0_wr_reg; -- AEB General Configuration Area Register "RESERVED_EE0"
		aeb_gen_cfg_reserved_ee4         : t_aeb_gen_cfg_reserved_ee4_wr_reg; -- AEB General Configuration Area Register "RESERVED_EE4"
		aeb_gen_cfg_reserved_ee8         : t_aeb_gen_cfg_reserved_ee8_wr_reg; -- AEB General Configuration Area Register "RESERVED_EE8"
		aeb_gen_cfg_reserved_eec         : t_aeb_gen_cfg_reserved_eec_wr_reg; -- AEB General Configuration Area Register "RESERVED_EEC"
		aeb_gen_cfg_reserved_ef0         : t_aeb_gen_cfg_reserved_ef0_wr_reg; -- AEB General Configuration Area Register "RESERVED_EF0"
		aeb_gen_cfg_reserved_ef4         : t_aeb_gen_cfg_reserved_ef4_wr_reg; -- AEB General Configuration Area Register "RESERVED_EF4"
		aeb_gen_cfg_reserved_ef8         : t_aeb_gen_cfg_reserved_ef8_wr_reg; -- AEB General Configuration Area Register "RESERVED_EF8"
		aeb_gen_cfg_reserved_efc         : t_aeb_gen_cfg_reserved_efc_wr_reg; -- AEB General Configuration Area Register "RESERVED_EFC"
		aeb_gen_cfg_reserved_f00         : t_aeb_gen_cfg_reserved_f00_wr_reg; -- AEB General Configuration Area Register "RESERVED_F00"
		aeb_gen_cfg_reserved_f04         : t_aeb_gen_cfg_reserved_f04_wr_reg; -- AEB General Configuration Area Register "RESERVED_F04"
		aeb_gen_cfg_reserved_f08         : t_aeb_gen_cfg_reserved_f08_wr_reg; -- AEB General Configuration Area Register "RESERVED_F08"
		aeb_gen_cfg_reserved_f0c         : t_aeb_gen_cfg_reserved_f0c_wr_reg; -- AEB General Configuration Area Register "RESERVED_F0C"
		aeb_gen_cfg_reserved_f10         : t_aeb_gen_cfg_reserved_f10_wr_reg; -- AEB General Configuration Area Register "RESERVED_F10"
		aeb_gen_cfg_reserved_f14         : t_aeb_gen_cfg_reserved_f14_wr_reg; -- AEB General Configuration Area Register "RESERVED_F14"
		aeb_gen_cfg_reserved_f18         : t_aeb_gen_cfg_reserved_f18_wr_reg; -- AEB General Configuration Area Register "RESERVED_F18"
		aeb_gen_cfg_reserved_f1c         : t_aeb_gen_cfg_reserved_f1c_wr_reg; -- AEB General Configuration Area Register "RESERVED_F1C"
		aeb_gen_cfg_reserved_f20         : t_aeb_gen_cfg_reserved_f20_wr_reg; -- AEB General Configuration Area Register "RESERVED_F20"
		aeb_gen_cfg_reserved_f24         : t_aeb_gen_cfg_reserved_f24_wr_reg; -- AEB General Configuration Area Register "RESERVED_F24"
		aeb_gen_cfg_reserved_f28         : t_aeb_gen_cfg_reserved_f28_wr_reg; -- AEB General Configuration Area Register "RESERVED_F28"
		aeb_gen_cfg_reserved_f2c         : t_aeb_gen_cfg_reserved_f2c_wr_reg; -- AEB General Configuration Area Register "RESERVED_F2C"
		aeb_gen_cfg_reserved_f30         : t_aeb_gen_cfg_reserved_f30_wr_reg; -- AEB General Configuration Area Register "RESERVED_F30"
		aeb_gen_cfg_reserved_f34         : t_aeb_gen_cfg_reserved_f34_wr_reg; -- AEB General Configuration Area Register "RESERVED_F34"
		aeb_gen_cfg_reserved_f38         : t_aeb_gen_cfg_reserved_f38_wr_reg; -- AEB General Configuration Area Register "RESERVED_F38"
		aeb_gen_cfg_reserved_f3c         : t_aeb_gen_cfg_reserved_f3c_wr_reg; -- AEB General Configuration Area Register "RESERVED_F3C"
		aeb_gen_cfg_reserved_f40         : t_aeb_gen_cfg_reserved_f40_wr_reg; -- AEB General Configuration Area Register "RESERVED_F40"
		aeb_gen_cfg_reserved_f44         : t_aeb_gen_cfg_reserved_f44_wr_reg; -- AEB General Configuration Area Register "RESERVED_F44"
		aeb_gen_cfg_reserved_f48         : t_aeb_gen_cfg_reserved_f48_wr_reg; -- AEB General Configuration Area Register "RESERVED_F48"
		aeb_gen_cfg_reserved_f4c         : t_aeb_gen_cfg_reserved_f4c_wr_reg; -- AEB General Configuration Area Register "RESERVED_F4C"
		aeb_gen_cfg_reserved_f50         : t_aeb_gen_cfg_reserved_f50_wr_reg; -- AEB General Configuration Area Register "RESERVED_F50"
		aeb_gen_cfg_reserved_f54         : t_aeb_gen_cfg_reserved_f54_wr_reg; -- AEB General Configuration Area Register "RESERVED_F54"
		aeb_gen_cfg_reserved_f58         : t_aeb_gen_cfg_reserved_f58_wr_reg; -- AEB General Configuration Area Register "RESERVED_F58"
		aeb_gen_cfg_reserved_f5c         : t_aeb_gen_cfg_reserved_f5c_wr_reg; -- AEB General Configuration Area Register "RESERVED_F5C"
		aeb_gen_cfg_reserved_f60         : t_aeb_gen_cfg_reserved_f60_wr_reg; -- AEB General Configuration Area Register "RESERVED_F60"
		aeb_gen_cfg_reserved_f64         : t_aeb_gen_cfg_reserved_f64_wr_reg; -- AEB General Configuration Area Register "RESERVED_F64"
		aeb_gen_cfg_reserved_f68         : t_aeb_gen_cfg_reserved_f68_wr_reg; -- AEB General Configuration Area Register "RESERVED_F68"
		aeb_gen_cfg_reserved_f6c         : t_aeb_gen_cfg_reserved_f6c_wr_reg; -- AEB General Configuration Area Register "RESERVED_F6C"
		aeb_gen_cfg_reserved_f70         : t_aeb_gen_cfg_reserved_f70_wr_reg; -- AEB General Configuration Area Register "RESERVED_F70"
		aeb_gen_cfg_reserved_f74         : t_aeb_gen_cfg_reserved_f74_wr_reg; -- AEB General Configuration Area Register "RESERVED_F74"
		aeb_gen_cfg_reserved_f78         : t_aeb_gen_cfg_reserved_f78_wr_reg; -- AEB General Configuration Area Register "RESERVED_F78"
		aeb_gen_cfg_reserved_f7c         : t_aeb_gen_cfg_reserved_f7c_wr_reg; -- AEB General Configuration Area Register "RESERVED_F7C"
		aeb_gen_cfg_reserved_f80         : t_aeb_gen_cfg_reserved_f80_wr_reg; -- AEB General Configuration Area Register "RESERVED_F80"
		aeb_gen_cfg_reserved_f84         : t_aeb_gen_cfg_reserved_f84_wr_reg; -- AEB General Configuration Area Register "RESERVED_F84"
		aeb_gen_cfg_reserved_f88         : t_aeb_gen_cfg_reserved_f88_wr_reg; -- AEB General Configuration Area Register "RESERVED_F88"
		aeb_gen_cfg_reserved_f8c         : t_aeb_gen_cfg_reserved_f8c_wr_reg; -- AEB General Configuration Area Register "RESERVED_F8C"
		aeb_gen_cfg_reserved_f90         : t_aeb_gen_cfg_reserved_f90_wr_reg; -- AEB General Configuration Area Register "RESERVED_F90"
		aeb_gen_cfg_reserved_f94         : t_aeb_gen_cfg_reserved_f94_wr_reg; -- AEB General Configuration Area Register "RESERVED_F94"
		aeb_gen_cfg_reserved_f98         : t_aeb_gen_cfg_reserved_f98_wr_reg; -- AEB General Configuration Area Register "RESERVED_F98"
		aeb_gen_cfg_reserved_f9c         : t_aeb_gen_cfg_reserved_f9c_wr_reg; -- AEB General Configuration Area Register "RESERVED_F9C"
		aeb_gen_cfg_reserved_fa0         : t_aeb_gen_cfg_reserved_fa0_wr_reg; -- AEB General Configuration Area Register "RESERVED_FA0"
		aeb_gen_cfg_reserved_fa4         : t_aeb_gen_cfg_reserved_fa4_wr_reg; -- AEB General Configuration Area Register "RESERVED_FA4"
		aeb_gen_cfg_reserved_fa8         : t_aeb_gen_cfg_reserved_fa8_wr_reg; -- AEB General Configuration Area Register "RESERVED_FA8"
		aeb_gen_cfg_reserved_fac         : t_aeb_gen_cfg_reserved_fac_wr_reg; -- AEB General Configuration Area Register "RESERVED_FAC"
		aeb_gen_cfg_reserved_fb0         : t_aeb_gen_cfg_reserved_fb0_wr_reg; -- AEB General Configuration Area Register "RESERVED_FB0"
		aeb_gen_cfg_reserved_fb4         : t_aeb_gen_cfg_reserved_fb4_wr_reg; -- AEB General Configuration Area Register "RESERVED_FB4"
		aeb_gen_cfg_reserved_fb8         : t_aeb_gen_cfg_reserved_fb8_wr_reg; -- AEB General Configuration Area Register "RESERVED_FB8"
		aeb_gen_cfg_reserved_fbc         : t_aeb_gen_cfg_reserved_fbc_wr_reg; -- AEB General Configuration Area Register "RESERVED_FBC"
		aeb_gen_cfg_reserved_fc0         : t_aeb_gen_cfg_reserved_fc0_wr_reg; -- AEB General Configuration Area Register "RESERVED_FC0"
		aeb_gen_cfg_reserved_fc4         : t_aeb_gen_cfg_reserved_fc4_wr_reg; -- AEB General Configuration Area Register "RESERVED_FC4"
		aeb_gen_cfg_reserved_fc8         : t_aeb_gen_cfg_reserved_fc8_wr_reg; -- AEB General Configuration Area Register "RESERVED_FC8"
		aeb_gen_cfg_reserved_fcc         : t_aeb_gen_cfg_reserved_fcc_wr_reg; -- AEB General Configuration Area Register "RESERVED_FCC"
		aeb_gen_cfg_reserved_fd0         : t_aeb_gen_cfg_reserved_fd0_wr_reg; -- AEB General Configuration Area Register "RESERVED_FD0"
		aeb_gen_cfg_reserved_fd4         : t_aeb_gen_cfg_reserved_fd4_wr_reg; -- AEB General Configuration Area Register "RESERVED_FD4"
		aeb_gen_cfg_reserved_fd8         : t_aeb_gen_cfg_reserved_fd8_wr_reg; -- AEB General Configuration Area Register "RESERVED_FD8"
		aeb_gen_cfg_reserved_fdc         : t_aeb_gen_cfg_reserved_fdc_wr_reg; -- AEB General Configuration Area Register "RESERVED_FDC"
		aeb_gen_cfg_reserved_fe0         : t_aeb_gen_cfg_reserved_fe0_wr_reg; -- AEB General Configuration Area Register "RESERVED_FE0"
		aeb_gen_cfg_reserved_fe4         : t_aeb_gen_cfg_reserved_fe4_wr_reg; -- AEB General Configuration Area Register "RESERVED_FE4"
		aeb_gen_cfg_reserved_fe8         : t_aeb_gen_cfg_reserved_fe8_wr_reg; -- AEB General Configuration Area Register "RESERVED_FE8"
		aeb_gen_cfg_reserved_fec         : t_aeb_gen_cfg_reserved_fec_wr_reg; -- AEB General Configuration Area Register "RESERVED_FEC"
		aeb_gen_cfg_reserved_ff0         : t_aeb_gen_cfg_reserved_ff0_wr_reg; -- AEB General Configuration Area Register "RESERVED_FF0"
		aeb_gen_cfg_reserved_ff4         : t_aeb_gen_cfg_reserved_ff4_wr_reg; -- AEB General Configuration Area Register "RESERVED_FF4"
		aeb_gen_cfg_reserved_ff8         : t_aeb_gen_cfg_reserved_ff8_wr_reg; -- AEB General Configuration Area Register "RESERVED_FF8"
		aeb_gen_cfg_reserved_ffc         : t_aeb_gen_cfg_reserved_ffc_wr_reg; -- AEB General Configuration Area Register "RESERVED_FFC"
		aeb_gen_cfg_seq_config_1         : t_aeb_gen_cfg_seq_config_1_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_1"
		aeb_gen_cfg_seq_config_10        : t_aeb_gen_cfg_seq_config_10_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_10"
		aeb_gen_cfg_seq_config_11        : t_aeb_gen_cfg_seq_config_11_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_11"
		aeb_gen_cfg_seq_config_12        : t_aeb_gen_cfg_seq_config_12_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_12"
		aeb_gen_cfg_seq_config_13        : t_aeb_gen_cfg_seq_config_13_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_13"
		aeb_gen_cfg_seq_config_14        : t_aeb_gen_cfg_seq_config_14_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_14"
		aeb_gen_cfg_seq_config_2         : t_aeb_gen_cfg_seq_config_2_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_2"
		aeb_gen_cfg_seq_config_3         : t_aeb_gen_cfg_seq_config_3_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_3"
		aeb_gen_cfg_seq_config_4         : t_aeb_gen_cfg_seq_config_4_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_4"
		aeb_gen_cfg_seq_config_5         : t_aeb_gen_cfg_seq_config_5_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_5"
		aeb_gen_cfg_seq_config_6         : t_aeb_gen_cfg_seq_config_6_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_6"
		aeb_gen_cfg_seq_config_7         : t_aeb_gen_cfg_seq_config_7_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_7"
		aeb_gen_cfg_seq_config_8         : t_aeb_gen_cfg_seq_config_8_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_8"
		aeb_gen_cfg_seq_config_9         : t_aeb_gen_cfg_seq_config_9_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_9"
		aeb_hk_adc_rd_data_adc_ref_buf_2 : t_aeb_hk_adc_rd_data_adc_ref_buf_2_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2"
		aeb_hk_adc_rd_data_hk_ana_n5v    : t_aeb_hk_adc_rd_data_hk_ana_n5v_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V"
		aeb_hk_adc_rd_data_hk_ana_p3v3   : t_aeb_hk_adc_rd_data_hk_ana_p3v3_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3"
		aeb_hk_adc_rd_data_hk_ana_p5v    : t_aeb_hk_adc_rd_data_hk_ana_p5v_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V"
		aeb_hk_adc_rd_data_hk_ccd_p31v   : t_aeb_hk_adc_rd_data_hk_ccd_p31v_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V"
		aeb_hk_adc_rd_data_hk_clk_p15v   : t_aeb_hk_adc_rd_data_hk_clk_p15v_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V"
		aeb_hk_adc_rd_data_hk_dig_p3v3   : t_aeb_hk_adc_rd_data_hk_dig_p3v3_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3"
		aeb_hk_adc_rd_data_hk_vode       : t_aeb_hk_adc_rd_data_hk_vode_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE"
		aeb_hk_adc_rd_data_hk_vodf       : t_aeb_hk_adc_rd_data_hk_vodf_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF"
		aeb_hk_adc_rd_data_hk_vog        : t_aeb_hk_adc_rd_data_hk_vog_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG"
		aeb_hk_adc_rd_data_hk_vrd        : t_aeb_hk_adc_rd_data_hk_vrd_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD"
		aeb_hk_adc_rd_data_s_ref         : t_aeb_hk_adc_rd_data_s_ref_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF"
		aeb_hk_adc_rd_data_t_bias_p      : t_aeb_hk_adc_rd_data_t_bias_p_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P"
		aeb_hk_adc_rd_data_t_ccd         : t_aeb_hk_adc_rd_data_t_ccd_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD"
		aeb_hk_adc_rd_data_t_hk_p        : t_aeb_hk_adc_rd_data_t_hk_p_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P"
		aeb_hk_adc_rd_data_t_ref1k_mea   : t_aeb_hk_adc_rd_data_t_ref1k_mea_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA"
		aeb_hk_adc_rd_data_t_ref649r_mea : t_aeb_hk_adc_rd_data_t_ref649r_mea_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA"
		aeb_hk_adc_rd_data_t_tou_1_p     : t_aeb_hk_adc_rd_data_t_tou_1_p_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P"
		aeb_hk_adc_rd_data_t_tou_2_p     : t_aeb_hk_adc_rd_data_t_tou_2_p_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P"
		aeb_hk_adc_rd_data_t_vasp_l      : t_aeb_hk_adc_rd_data_t_vasp_l_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L"
		aeb_hk_adc_rd_data_t_vasp_r      : t_aeb_hk_adc_rd_data_t_vasp_r_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R"
		aeb_hk_adc1_rd_config_1          : t_aeb_hk_adc1_rd_config_1_wr_reg; -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1"
		aeb_hk_adc1_rd_config_2          : t_aeb_hk_adc1_rd_config_2_wr_reg; -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2"
		aeb_hk_adc1_rd_config_3          : t_aeb_hk_adc1_rd_config_3_wr_reg; -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3"
		aeb_hk_adc2_rd_config_1          : t_aeb_hk_adc2_rd_config_1_wr_reg; -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1"
		aeb_hk_adc2_rd_config_2          : t_aeb_hk_adc2_rd_config_2_wr_reg; -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2"
		aeb_hk_adc2_rd_config_3          : t_aeb_hk_adc2_rd_config_3_wr_reg; -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3"
		aeb_hk_aeb_status                : t_aeb_hk_aeb_status_wr_reg; -- AEB Housekeeping Area Register "AEB_STATUS"
		aeb_hk_revision_id_1             : t_aeb_hk_revision_id_1_wr_reg; -- AEB Housekeeping Area Register "REVISION_ID_1"
		aeb_hk_revision_id_2             : t_aeb_hk_revision_id_2_wr_reg; -- AEB Housekeeping Area Register "REVISION_ID_2"
		aeb_hk_timestamp_1               : t_aeb_hk_timestamp_1_wr_reg; -- AEB Housekeeping Area Register "TIMESTAMP_1"
		aeb_hk_timestamp_2               : t_aeb_hk_timestamp_2_wr_reg; -- AEB Housekeeping Area Register "TIMESTAMP_2"
		aeb_hk_vasp_rd_config            : t_aeb_hk_vasp_rd_config_wr_reg; -- AEB Housekeeping Area Register "VASP_RD_CONFIG"
	end record t_rmap_memory_wr_area;

	type t_rmap_memory_rd_area is record
		dummy : std_logic;
	end record t_rmap_memory_rd_area;

end package farm_rmap_mem_area_ffee_aeb_pkg;

package body farm_rmap_mem_area_ffee_aeb_pkg is
end package body farm_rmap_mem_area_ffee_aeb_pkg;
