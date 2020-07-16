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
	constant c_FARM_AVALON_MM_FFEE_AEB_RMAP_MIN_ADDR : natural range 0 to 511 := 16#000#;
	constant c_FARM_AVALON_MM_FFEE_AEB_RMAP_MAX_ADDR : natural range 0 to 511 := 16#1DB#;

	-- Registers Types

	-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1"
	type t_aeb_hk_adc1_rd_config_1_rd_reg is record
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
	end record t_aeb_hk_adc1_rd_config_1_rd_reg;

	-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2"
	type t_aeb_hk_adc1_rd_config_2_rd_reg is record
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
	end record t_aeb_hk_adc1_rd_config_2_rd_reg;

	-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3"
	type t_aeb_hk_adc1_rd_config_3_rd_reg is record
		dio7 : std_logic;               -- "DIO7" Field
		dio6 : std_logic;               -- "DIO6" Field
		dio5 : std_logic;               -- "DIO5" Field
		dio4 : std_logic;               -- "DIO4" Field
		dio3 : std_logic;               -- "DIO3" Field
		dio2 : std_logic;               -- "DIO2" Field
		dio1 : std_logic;               -- "DIO1" Field
		dio0 : std_logic;               -- "DIO0" Field
	end record t_aeb_hk_adc1_rd_config_3_rd_reg;

	-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1"
	type t_aeb_hk_adc2_rd_config_1_rd_reg is record
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
	end record t_aeb_hk_adc2_rd_config_1_rd_reg;

	-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2"
	type t_aeb_hk_adc2_rd_config_2_rd_reg is record
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
	end record t_aeb_hk_adc2_rd_config_2_rd_reg;

	-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3"
	type t_aeb_hk_adc2_rd_config_3_rd_reg is record
		dio7 : std_logic;               -- "DIO7" Field
		dio6 : std_logic;               -- "DIO6" Field
		dio5 : std_logic;               -- "DIO5" Field
		dio4 : std_logic;               -- "DIO4" Field
		dio3 : std_logic;               -- "DIO3" Field
		dio2 : std_logic;               -- "DIO2" Field
		dio1 : std_logic;               -- "DIO1" Field
		dio0 : std_logic;               -- "DIO0" Field
	end record t_aeb_hk_adc2_rd_config_3_rd_reg;

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
		aeb_crit_cfg_vasp_i2c_control    : t_aeb_crit_cfg_vasp_i2c_control_wr_reg; -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL"
		aeb_gen_cfg_adc1_config_1        : t_aeb_gen_cfg_adc1_config_1_wr_reg; -- AEB General Configuration Area Register "ADC1_CONFIG_1"
		aeb_gen_cfg_adc1_config_2        : t_aeb_gen_cfg_adc1_config_2_wr_reg; -- AEB General Configuration Area Register "ADC1_CONFIG_2"
		aeb_gen_cfg_adc1_config_3        : t_aeb_gen_cfg_adc1_config_3_wr_reg; -- AEB General Configuration Area Register "ADC1_CONFIG_3"
		aeb_gen_cfg_adc2_config_1        : t_aeb_gen_cfg_adc2_config_1_wr_reg; -- AEB General Configuration Area Register "ADC2_CONFIG_1"
		aeb_gen_cfg_adc2_config_2        : t_aeb_gen_cfg_adc2_config_2_wr_reg; -- AEB General Configuration Area Register "ADC2_CONFIG_2"
		aeb_gen_cfg_adc2_config_3        : t_aeb_gen_cfg_adc2_config_3_wr_reg; -- AEB General Configuration Area Register "ADC2_CONFIG_3"
		aeb_gen_cfg_reserved_118         : t_aeb_gen_cfg_reserved_118_wr_reg; -- AEB General Configuration Area Register "RESERVED_118"
		aeb_gen_cfg_reserved_11c         : t_aeb_gen_cfg_reserved_11c_wr_reg; -- AEB General Configuration Area Register "RESERVED_11C"
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
		aeb_hk_aeb_status                : t_aeb_hk_aeb_status_wr_reg; -- AEB Housekeeping Area Register "AEB_STATUS"
		aeb_hk_revision_id_1             : t_aeb_hk_revision_id_1_wr_reg; -- AEB Housekeeping Area Register "REVISION_ID_1"
		aeb_hk_revision_id_2             : t_aeb_hk_revision_id_2_wr_reg; -- AEB Housekeeping Area Register "REVISION_ID_2"
		aeb_hk_timestamp_1               : t_aeb_hk_timestamp_1_wr_reg; -- AEB Housekeeping Area Register "TIMESTAMP_1"
		aeb_hk_timestamp_2               : t_aeb_hk_timestamp_2_wr_reg; -- AEB Housekeeping Area Register "TIMESTAMP_2"
		aeb_hk_vasp_rd_config            : t_aeb_hk_vasp_rd_config_wr_reg; -- AEB Housekeeping Area Register "VASP_RD_CONFIG"
	end record t_rmap_memory_wr_area;

	-- Avalon MM Read-Only Registers
	type t_rmap_memory_rd_area is record
		aeb_hk_adc1_rd_config_1 : t_aeb_hk_adc1_rd_config_1_rd_reg; -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1"
		aeb_hk_adc1_rd_config_2 : t_aeb_hk_adc1_rd_config_2_rd_reg; -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2"
		aeb_hk_adc1_rd_config_3 : t_aeb_hk_adc1_rd_config_3_rd_reg; -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3"
		aeb_hk_adc2_rd_config_1 : t_aeb_hk_adc2_rd_config_1_rd_reg; -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1"
		aeb_hk_adc2_rd_config_2 : t_aeb_hk_adc2_rd_config_2_rd_reg; -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2"
		aeb_hk_adc2_rd_config_3 : t_aeb_hk_adc2_rd_config_3_rd_reg; -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3"
	end record t_rmap_memory_rd_area;

end package farm_rmap_mem_area_ffee_aeb_pkg;

package body farm_rmap_mem_area_ffee_aeb_pkg is
end package body farm_rmap_mem_area_ffee_aeb_pkg;
