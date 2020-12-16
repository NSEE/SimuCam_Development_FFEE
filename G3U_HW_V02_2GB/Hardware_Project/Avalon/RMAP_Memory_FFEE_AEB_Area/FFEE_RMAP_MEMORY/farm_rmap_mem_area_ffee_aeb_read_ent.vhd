library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.farm_rmap_mem_area_ffee_aeb_pkg.all;
use work.farm_avalon_mm_rmap_ffee_aeb_pkg.all;

entity farm_rmap_mem_area_ffee_aeb_read_ent is
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		fee_rmap_i          : in  t_farm_ffee_aeb_rmap_read_in;
		avalon_mm_rmap_i    : in  t_farm_avalon_mm_rmap_ffee_aeb_read_in;
		rmap_registers_wr_i : in  t_rmap_memory_wr_area;
		rmap_registers_rd_i : in  t_rmap_memory_rd_area;
		fee_rmap_o          : out t_farm_ffee_aeb_rmap_read_out;
		avalon_mm_rmap_o    : out t_farm_avalon_mm_rmap_ffee_aeb_read_out
	);
end entity farm_rmap_mem_area_ffee_aeb_read_ent;

architecture RTL of farm_rmap_mem_area_ffee_aeb_read_ent is

begin

	p_farm_rmap_mem_area_ffee_aeb_read : process(clk_i, rst_i) is
		procedure p_ffee_aeb_rmap_mem_rd(rd_addr_i : std_logic_vector) is
		begin

			-- MemArea Data Read
			case (rd_addr_i(31 downto 0)) is
				-- Case for access to all memory area

				when (x"00000000") =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "AEB_RESET" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.aeb_reset;
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "SET_STATE" Field
					fee_rmap_o.readdata(1)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.set_state;
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "NEW_STATE" Field
					fee_rmap_o.readdata(5 downto 2) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.new_state;
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED" Field
					fee_rmap_o.readdata(7 downto 6) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.reserved;

				when (x"00000001") =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.others_0(23 downto 16);

				when (x"00000002") =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.others_0(15 downto 8);

				when (x"00000003") =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.others_0(7 downto 0);

				when (x"00000004") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.others_0(31 downto 24);

				when (x"00000005") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.others_0(23 downto 16);

				when (x"00000006") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.others_0(15 downto 8);

				when (x"00000007") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.others_0(7 downto 0);

				when (x"00000008") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_key.key(31 downto 24);

				when (x"00000009") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_key.key(23 downto 16);

				when (x"0000000A") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_key.key(15 downto 8);

				when (x"0000000B") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_key.key(7 downto 0);

				when (x"0000000C") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : OVERRIDE_SW, "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.others_0(31 downto 24);

				when (x"0000000D") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : OVERRIDE_SW, "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.others_0(23 downto 16);

				when (x"0000000E") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : OVERRIDE_SW, "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.others_0(15 downto 8);

				when (x"0000000F") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : OVERRIDE_SW, "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.others_0(7 downto 0);

				when (x"00000010") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_COLS" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_cols(13 downto 8);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_CCDID" Field
					fee_rmap_o.readdata(7 downto 6) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_ccdid;

				when (x"00000011") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_COLS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_cols(7 downto 0);

				when (x"00000012") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_ROWS" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_rows(13 downto 8);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "RESERVED" Field
					fee_rmap_o.readdata(7 downto 6) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.reserved;

				when (x"00000013") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_ROWS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_rows(7 downto 0);

				when (x"00000014") =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.others_0(31 downto 24);

				when (x"00000015") =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.others_0(23 downto 16);

				when (x"00000016") =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.others_0(15 downto 8);

				when (x"00000017") =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.others_0(7 downto 0);

				when (x"00000018") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.others_0(31 downto 24);

				when (x"00000019") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.others_0(23 downto 16);

				when (x"0000001A") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.others_0(15 downto 8);

				when (x"0000001B") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.others_0(7 downto 0);

				when (x"0000001C") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : RESERVED_0, "DAC_VOD", "RESERVED_1" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.others_0(31 downto 24);

				when (x"0000001D") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : RESERVED_0, "DAC_VOD", "RESERVED_1" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.others_0(23 downto 16);

				when (x"0000001E") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : RESERVED_0, "DAC_VOD", "RESERVED_1" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.others_0(15 downto 8);

				when (x"0000001F") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : RESERVED_0, "DAC_VOD", "RESERVED_1" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.others_0(7 downto 0);

				when (x"00000020") =>
					-- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_reserved_20.reserved(31 downto 24);

				when (x"00000021") =>
					-- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_reserved_20.reserved(23 downto 16);

				when (x"00000022") =>
					-- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_reserved_20.reserved(15 downto 8);

				when (x"00000023") =>
					-- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_reserved_20.reserved(7 downto 0);

				when (x"00000024") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCCD_ON" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config1.time_vccd_on;

				when (x"00000025") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCLK_ON" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config1.time_vclk_on;

				when (x"00000026") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN1_ON" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config1.time_van1_on;

				when (x"00000027") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN2_ON" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config1.time_van2_on;

				when (x"00000028") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN3_ON" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config2.time_van3_on;

				when (x"00000029") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCCD_OFF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config2.time_vccd_off;

				when (x"0000002A") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCLK_OFF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config2.time_vclk_off;

				when (x"0000002B") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN1_OFF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config2.time_van1_off;

				when (x"0000002C") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN2_OFF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config3.time_van2_off;

				when (x"0000002D") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN3_OFF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config3.time_van3_off;

				when (x"00000100") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.others_0(31 downto 24);

				when (x"00000101") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.others_0(23 downto 16);

				when (x"00000102") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.others_0(15 downto 8);

				when (x"00000103") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.others_0(7 downto 0);

				when (x"00000104") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.others_0(31 downto 24);

				when (x"00000105") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.others_0(23 downto 16);

				when (x"00000106") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.others_0(15 downto 8);

				when (x"00000107") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.others_0(7 downto 0);

				when (x"00000108") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.others_0(31 downto 24);

				when (x"00000109") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.others_0(23 downto 16);

				when (x"0000010A") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.others_0(15 downto 8);

				when (x"0000010B") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.others_0(7 downto 0);

				when (x"0000010C") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.others_0(31 downto 24);

				when (x"0000010D") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.others_0(23 downto 16);

				when (x"0000010E") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.others_0(15 downto 8);

				when (x"0000010F") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.others_0(7 downto 0);

				when (x"00000110") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.others_0(31 downto 24);

				when (x"00000111") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.others_0(23 downto 16);

				when (x"00000112") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.others_0(15 downto 8);

				when (x"00000113") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.others_0(7 downto 0);

				when (x"00000114") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.others_0(31 downto 24);

				when (x"00000115") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.others_0(23 downto 16);

				when (x"00000116") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.others_0(15 downto 8);

				when (x"00000117") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.others_0(7 downto 0);

				when (x"00000118") =>
					-- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_reserved_118.reserved(31 downto 24);

				when (x"00000119") =>
					-- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_reserved_118.reserved(23 downto 16);

				when (x"0000011A") =>
					-- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_reserved_118.reserved(15 downto 8);

				when (x"0000011B") =>
					-- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_reserved_118.reserved(7 downto 0);

				when (x"0000011C") =>
					-- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_reserved_11c.reserved(31 downto 24);

				when (x"0000011D") =>
					-- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_reserved_11c.reserved(23 downto 16);

				when (x"0000011E") =>
					-- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_reserved_11c.reserved(15 downto 8);

				when (x"0000011F") =>
					-- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_reserved_11c.reserved(7 downto 0);

				when (x"00000120") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : RESERVED_0, "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "RESERVED_1", "ADC_CLK_DIV" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.others_0(31 downto 24);

				when (x"00000121") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : RESERVED_0, "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "RESERVED_1", "ADC_CLK_DIV" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.others_0(23 downto 16);

				when (x"00000122") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : RESERVED_0, "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "RESERVED_1", "ADC_CLK_DIV" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.others_0(15 downto 8);

				when (x"00000123") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : RESERVED_0, "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "RESERVED_1", "ADC_CLK_DIV" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.others_0(7 downto 0);

				when (x"00000124") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.others_0(31 downto 24);

				when (x"00000125") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.others_0(23 downto 16);

				when (x"00000126") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.others_0(15 downto 8);

				when (x"00000127") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.others_0(7 downto 0);

				when (x"00000128") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.others_0(31 downto 24);

				when (x"00000129") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.others_0(23 downto 16);

				when (x"0000012A") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.others_0(15 downto 8);

				when (x"0000012B") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.others_0(7 downto 0);

				when (x"0000012C") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.others_0(31 downto 24);

				when (x"0000012D") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.others_0(23 downto 16);

				when (x"0000012E") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.others_0(15 downto 8);

				when (x"0000012F") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.others_0(7 downto 0);

				when (x"00000130") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "VASP_OUT_CTRL", "RESERVED", "VASP_OUT_EN_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.others_0(31 downto 24);

				when (x"00000131") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "VASP_OUT_CTRL", "RESERVED", "VASP_OUT_EN_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.others_0(23 downto 16);

				when (x"00000132") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "VASP_OUT_CTRL", "RESERVED", "VASP_OUT_EN_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.others_0(15 downto 8);

				when (x"00000133") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "VASP_OUT_CTRL", "RESERVED", "VASP_OUT_EN_POS" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.others_0(7 downto 0);

				when (x"00000134") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : VASP_OUT_CTRL_INV, "RESERVED_0", "VASP_OUT_DIS_POS", "RESERVED_1" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.others_0(31 downto 24);

				when (x"00000135") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : VASP_OUT_CTRL_INV, "RESERVED_0", "VASP_OUT_DIS_POS", "RESERVED_1" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.others_0(23 downto 16);

				when (x"00000136") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : VASP_OUT_CTRL_INV, "RESERVED_0", "VASP_OUT_DIS_POS", "RESERVED_1" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.others_0(15 downto 8);

				when (x"00000137") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : VASP_OUT_CTRL_INV, "RESERVED_0", "VASP_OUT_DIS_POS", "RESERVED_1" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.others_0(7 downto 0);

				when (x"00000138") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_7.reserved(31 downto 24);

				when (x"00000139") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_7.reserved(23 downto 16);

				when (x"0000013A") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_7.reserved(15 downto 8);

				when (x"0000013B") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_7.reserved(7 downto 0);

				when (x"0000013C") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_8.reserved(31 downto 24);

				when (x"0000013D") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_8.reserved(23 downto 16);

				when (x"0000013E") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_8.reserved(15 downto 8);

				when (x"0000013F") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_8.reserved(7 downto 0);

				when (x"00000140") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "FT_LOOP_CNT" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.ft_loop_cnt(13 downto 8);
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_0" Field
					fee_rmap_o.readdata(7 downto 6) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.reserved_0;

				when (x"00000141") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "FT_LOOP_CNT" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.ft_loop_cnt(7 downto 0);

				when (x"00000142") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_LOOP_CNT" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.lt0_loop_cnt(13 downto 8);
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_1" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.reserved_1;
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_ENABLED" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.lt0_enabled;

				when (x"00000143") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_LOOP_CNT" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.lt0_loop_cnt(7 downto 0);

				when (x"00000144") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_LOOP_CNT" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt1_loop_cnt(13 downto 8);
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_0" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.reserved_0;
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_ENABLED" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt1_enabled;

				when (x"00000145") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_LOOP_CNT" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt1_loop_cnt(7 downto 0);

				when (x"00000146") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_LOOP_CNT" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt2_loop_cnt(13 downto 8);
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_1" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.reserved_1;
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_ENABLED" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt2_enabled;

				when (x"00000147") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_LOOP_CNT" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt2_loop_cnt(7 downto 0);

				when (x"00000148") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_LOOP_CNT" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.lt3_loop_cnt(13 downto 8);
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "RESERVED" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.reserved;
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_ENABLED" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.lt3_enabled;

				when (x"00000149") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_LOOP_CNT" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.lt3_loop_cnt(7 downto 0);

				when (x"0000014A") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "PIX_LOOP_CNT_WORD_1" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.pix_loop_cnt_word_1(15 downto 8);

				when (x"0000014B") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "PIX_LOOP_CNT_WORD_1" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.pix_loop_cnt_word_1(7 downto 0);

				when (x"0000014C") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PIX_LOOP_CNT_WORD_0" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pix_loop_cnt_word_0(15 downto 8);

				when (x"0000014D") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PIX_LOOP_CNT_WORD_0" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pix_loop_cnt_word_0(7 downto 0);

				when (x"0000014E") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_LOOP_CNT" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pc_loop_cnt(13 downto 8);
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "RESERVED" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.reserved;
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_ENABLED" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pc_enabled;

				when (x"0000014F") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_LOOP_CNT" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pc_loop_cnt(7 downto 0);

				when (x"00000150") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT1_LOOP_CNT" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.int1_loop_cnt(13 downto 8);
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_0" Field
					fee_rmap_o.readdata(7 downto 6) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.reserved_0;

				when (x"00000151") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT1_LOOP_CNT" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.int1_loop_cnt(7 downto 0);

				when (x"00000152") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT2_LOOP_CNT" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.int2_loop_cnt(13 downto 8);
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_1" Field
					fee_rmap_o.readdata(7 downto 6) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.reserved_1;

				when (x"00000153") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT2_LOOP_CNT" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.int2_loop_cnt(7 downto 0);

				when (x"00000154") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : RESERVED_0, "SPHI_INV", "RESERVED_1", "RPHI_INV", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.others_0(31 downto 24);

				when (x"00000155") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : RESERVED_0, "SPHI_INV", "RESERVED_1", "RPHI_INV", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.others_0(23 downto 16);

				when (x"00000156") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : RESERVED_0, "SPHI_INV", "RESERVED_1", "RPHI_INV", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.others_0(15 downto 8);

				when (x"00000157") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : RESERVED_0, "SPHI_INV", "RESERVED_1", "RPHI_INV", "RESERVED_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.others_0(7 downto 0);

				when (x"00001000") =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "AEB_STATUS" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_hk_aeb_status.aeb_status;

				when (x"00001001") =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_hk_aeb_status.others_1(11 downto 8);
					-- AEB Housekeeping Area Register "AEB_STATUS" : VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields
					fee_rmap_o.readdata(7 downto 6) <= rmap_registers_wr_i.aeb_hk_aeb_status.others_0;

				when (x"00001002") =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_aeb_status.others_1(7 downto 0);

				when (x"00001008") =>
					-- AEB Housekeeping Area Register "TIMESTAMP_1" : "TIMESTAMP_DWORD_1" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_timestamp_1.timestamp_dword_1(31 downto 24);

				when (x"00001009") =>
					-- AEB Housekeeping Area Register "TIMESTAMP_1" : "TIMESTAMP_DWORD_1" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_timestamp_1.timestamp_dword_1(23 downto 16);

				when (x"0000100A") =>
					-- AEB Housekeeping Area Register "TIMESTAMP_1" : "TIMESTAMP_DWORD_1" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_timestamp_1.timestamp_dword_1(15 downto 8);

				when (x"0000100B") =>
					-- AEB Housekeeping Area Register "TIMESTAMP_1" : "TIMESTAMP_DWORD_1" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_timestamp_1.timestamp_dword_1(7 downto 0);

				when (x"0000100C") =>
					-- AEB Housekeeping Area Register "TIMESTAMP_2" : "TIMESTAMP_DWORD_0" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_timestamp_2.timestamp_dword_0(31 downto 24);

				when (x"0000100D") =>
					-- AEB Housekeeping Area Register "TIMESTAMP_2" : "TIMESTAMP_DWORD_0" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_timestamp_2.timestamp_dword_0(23 downto 16);

				when (x"0000100E") =>
					-- AEB Housekeeping Area Register "TIMESTAMP_2" : "TIMESTAMP_DWORD_0" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_timestamp_2.timestamp_dword_0(15 downto 8);

				when (x"0000100F") =>
					-- AEB Housekeeping Area Register "TIMESTAMP_2" : "TIMESTAMP_DWORD_0" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_timestamp_2.timestamp_dword_0(7 downto 0);

				when (x"00001010") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.others_0(31 downto 24);

				when (x"00001011") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.others_0(23 downto 16);

				when (x"00001012") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.others_0(15 downto 8);

				when (x"00001013") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.others_0(7 downto 0);

				when (x"00001014") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.others_0(31 downto 24);

				when (x"00001015") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.others_0(23 downto 16);

				when (x"00001016") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.others_0(15 downto 8);

				when (x"00001017") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.others_0(7 downto 0);

				when (x"00001018") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.others_0(31 downto 24);

				when (x"00001019") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.others_0(23 downto 16);

				when (x"0000101A") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.others_0(15 downto 8);

				when (x"0000101B") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.others_0(7 downto 0);

				when (x"0000101C") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.others_0(31 downto 24);

				when (x"0000101D") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.others_0(23 downto 16);

				when (x"0000101E") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.others_0(15 downto 8);

				when (x"0000101F") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.others_0(7 downto 0);

				when (x"00001020") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.others_0(31 downto 24);

				when (x"00001021") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.others_0(23 downto 16);

				when (x"00001022") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.others_0(15 downto 8);

				when (x"00001023") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.others_0(7 downto 0);

				when (x"00001024") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.others_0(31 downto 24);

				when (x"00001025") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.others_0(23 downto 16);

				when (x"00001026") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.others_0(15 downto 8);

				when (x"00001027") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.others_0(7 downto 0);

				when (x"00001028") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.others_0(31 downto 24);

				when (x"00001029") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.others_0(23 downto 16);

				when (x"0000102A") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.others_0(15 downto 8);

				when (x"0000102B") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.others_0(7 downto 0);

				when (x"0000102C") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.others_0(31 downto 24);

				when (x"0000102D") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.others_0(23 downto 16);

				when (x"0000102E") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.others_0(15 downto 8);

				when (x"0000102F") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.others_0(7 downto 0);

				when (x"00001030") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.others_0(31 downto 24);

				when (x"00001031") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.others_0(23 downto 16);

				when (x"00001032") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.others_0(15 downto 8);

				when (x"00001033") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.others_0(7 downto 0);

				when (x"00001034") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.others_0(31 downto 24);

				when (x"00001035") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.others_0(23 downto 16);

				when (x"00001036") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.others_0(15 downto 8);

				when (x"00001037") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.others_0(7 downto 0);

				when (x"00001038") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.others_0(31 downto 24);

				when (x"00001039") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.others_0(23 downto 16);

				when (x"0000103A") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.others_0(15 downto 8);

				when (x"0000103B") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.others_0(7 downto 0);

				when (x"0000103C") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.others_0(31 downto 24);

				when (x"0000103D") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.others_0(23 downto 16);

				when (x"0000103E") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.others_0(15 downto 8);

				when (x"0000103F") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.others_0(7 downto 0);

				when (x"00001040") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.others_0(31 downto 24);

				when (x"00001041") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.others_0(23 downto 16);

				when (x"00001042") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.others_0(15 downto 8);

				when (x"00001043") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.others_0(7 downto 0);

				when (x"00001044") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.others_0(31 downto 24);

				when (x"00001045") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.others_0(23 downto 16);

				when (x"00001046") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.others_0(15 downto 8);

				when (x"00001047") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.others_0(7 downto 0);

				when (x"00001048") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.others_0(31 downto 24);

				when (x"00001049") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.others_0(23 downto 16);

				when (x"0000104A") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.others_0(15 downto 8);

				when (x"0000104B") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.others_0(7 downto 0);

				when (x"0000104C") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.others_0(31 downto 24);

				when (x"0000104D") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.others_0(23 downto 16);

				when (x"0000104E") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.others_0(15 downto 8);

				when (x"0000104F") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.others_0(7 downto 0);

				when (x"00001050") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.others_0(31 downto 24);

				when (x"00001051") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.others_0(23 downto 16);

				when (x"00001052") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.others_0(15 downto 8);

				when (x"00001053") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.others_0(7 downto 0);

				when (x"00001054") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.others_0(31 downto 24);

				when (x"00001055") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.others_0(23 downto 16);

				when (x"00001056") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.others_0(15 downto 8);

				when (x"00001057") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.others_0(7 downto 0);

				when (x"00001058") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.others_0(31 downto 24);

				when (x"00001059") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.others_0(23 downto 16);

				when (x"0000105A") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.others_0(15 downto 8);

				when (x"0000105B") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.others_0(7 downto 0);

				when (x"0000105C") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.others_0(31 downto 24);

				when (x"0000105D") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.others_0(23 downto 16);

				when (x"0000105E") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.others_0(15 downto 8);

				when (x"0000105F") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.others_0(7 downto 0);

				when (x"00001060") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.others_0(31 downto 24);

				when (x"00001061") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.others_0(23 downto 16);

				when (x"00001062") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.others_0(15 downto 8);

				when (x"00001063") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.others_0(7 downto 0);

				when (x"00001080") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : SPIRST, "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT" Fields
					fee_rmap_o.readdata(6 downto 1) <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_1.others_0;

				when (x"00001081") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : IDLMOD, "DLY2", "DLY1", "DLY0", "SBCS1", "SBCS0", "DRATE1", "DRATE0", "AINP3", "AINP2", "AINP1", "AINP0", "AINN3", "AINN2", "AINN1", "AINN0", "DIFF7", "DIFF6", "DIFF5", "DIFF4", "DIFF3", "DIFF2", "DIFF1", "DIFF0" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_1.others_1(23 downto 16);

				when (x"00001082") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : IDLMOD, "DLY2", "DLY1", "DLY0", "SBCS1", "SBCS0", "DRATE1", "DRATE0", "AINP3", "AINP2", "AINP1", "AINP0", "AINN3", "AINN2", "AINN1", "AINN0", "DIFF7", "DIFF6", "DIFF5", "DIFF4", "DIFF3", "DIFF2", "DIFF1", "DIFF0" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_1.others_1(15 downto 8);

				when (x"00001083") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : IDLMOD, "DLY2", "DLY1", "DLY0", "SBCS1", "SBCS0", "DRATE1", "DRATE0", "AINP3", "AINP2", "AINP1", "AINP0", "AINN3", "AINN2", "AINN1", "AINN0", "DIFF7", "DIFF6", "DIFF5", "DIFF4", "DIFF3", "DIFF2", "DIFF1", "DIFF0" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_1.others_1(7 downto 0);

				when (x"00001084") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_2.others_0(15 downto 8);

				when (x"00001085") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_2.others_0(7 downto 0);

				when (x"00001086") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : OFFSET, "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
					fee_rmap_o.readdata(0)          <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_2.others_2(8);
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : REF, "GAIN", "TEMP", "VCC" Fields
					fee_rmap_o.readdata(5 downto 2) <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_2.others_1;

				when (x"00001087") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : OFFSET, "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_2.others_2(7 downto 0);

				when (x"00001088") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_3.others_0;

				when (x"00001090") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : SPIRST, "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT" Fields
					fee_rmap_o.readdata(6 downto 1) <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_1.others_0;

				when (x"00001091") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : IDLMOD, "DLY2", "DLY1", "DLY0", "SBCS1", "SBCS0", "DRATE1", "DRATE0", "AINP3", "AINP2", "AINP1", "AINP0", "AINN3", "AINN2", "AINN1", "AINN0", "DIFF7", "DIFF6", "DIFF5", "DIFF4", "DIFF3", "DIFF2", "DIFF1", "DIFF0" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_1.others_1(23 downto 16);

				when (x"00001092") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : IDLMOD, "DLY2", "DLY1", "DLY0", "SBCS1", "SBCS0", "DRATE1", "DRATE0", "AINP3", "AINP2", "AINP1", "AINP0", "AINN3", "AINN2", "AINN1", "AINN0", "DIFF7", "DIFF6", "DIFF5", "DIFF4", "DIFF3", "DIFF2", "DIFF1", "DIFF0" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_1.others_1(15 downto 8);

				when (x"00001093") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : IDLMOD, "DLY2", "DLY1", "DLY0", "SBCS1", "SBCS0", "DRATE1", "DRATE0", "AINP3", "AINP2", "AINP1", "AINP0", "AINN3", "AINN2", "AINN1", "AINN0", "DIFF7", "DIFF6", "DIFF5", "DIFF4", "DIFF3", "DIFF2", "DIFF1", "DIFF0" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_1.others_1(7 downto 0);

				when (x"00001094") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_2.others_0(15 downto 8);

				when (x"00001095") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_2.others_0(7 downto 0);

				when (x"00001096") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : OFFSET, "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
					fee_rmap_o.readdata(0)          <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_2.others_2(8);
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : REF, "GAIN", "TEMP", "VCC" Fields
					fee_rmap_o.readdata(5 downto 2) <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_2.others_1;

				when (x"00001097") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : OFFSET, "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_2.others_2(7 downto 0);

				when (x"00001098") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0" Fields
					fee_rmap_o.readdata <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_3.others_0;

				when (x"000010A0") =>
					-- AEB Housekeeping Area Register "VASP_RD_CONFIG" : VASP1_READ_DATA, "VASP2_READ_DATA" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_vasp_rd_config.others_0(15 downto 8);

				when (x"000010A1") =>
					-- AEB Housekeeping Area Register "VASP_RD_CONFIG" : VASP1_READ_DATA, "VASP2_READ_DATA" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_vasp_rd_config.others_0(7 downto 0);

				when (x"000011F0") =>
					-- AEB Housekeeping Area Register "REVISION_ID_1" : FPGA_VERSION, "FPGA_DATE" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_1.others_0(31 downto 24);

				when (x"000011F1") =>
					-- AEB Housekeeping Area Register "REVISION_ID_1" : FPGA_VERSION, "FPGA_DATE" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_1.others_0(23 downto 16);

				when (x"000011F2") =>
					-- AEB Housekeeping Area Register "REVISION_ID_1" : FPGA_VERSION, "FPGA_DATE" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_1.others_0(15 downto 8);

				when (x"000011F3") =>
					-- AEB Housekeeping Area Register "REVISION_ID_1" : FPGA_VERSION, "FPGA_DATE" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_1.others_0(7 downto 0);

				when (x"000011F4") =>
					-- AEB Housekeeping Area Register "REVISION_ID_2" : FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_2.others_0(31 downto 24);

				when (x"000011F5") =>
					-- AEB Housekeeping Area Register "REVISION_ID_2" : FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_2.others_0(23 downto 16);

				when (x"000011F6") =>
					-- AEB Housekeeping Area Register "REVISION_ID_2" : FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_2.others_0(15 downto 8);

				when (x"000011F7") =>
					-- AEB Housekeeping Area Register "REVISION_ID_2" : FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_2.others_0(7 downto 0);

				when others =>
					fee_rmap_o.readdata <= (others => '0');

			end case;

		end procedure p_ffee_aeb_rmap_mem_rd;

		-- p_avalon_mm_rmap_read

		procedure p_avs_readdata(read_address_i : t_farm_avalon_mm_rmap_ffee_aeb_address) is
		begin

-- Registers Data Read
case (read_address_i) is
  -- Case for access to all registers address

  when (16#000#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.reserved;
    -- end if;

  when (16#001#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "NEW_STATE" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.new_state;
    -- end if;

  when (16#002#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "SET_STATE" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.set_state;
    -- end if;

  when (16#003#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "AEB_RESET" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.aeb_reset;
    -- end if;

  when (16#004#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.others_0(23 downto 16);
    -- end if;

  when (16#005#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG" : RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.others_0(31 downto 24);
    -- end if;

  when (16#006#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_key.key(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_key.key(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_key.key(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_key.key(31 downto 24);
    -- end if;

  when (16#007#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : OVERRIDE_SW, "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "RESERVED_2" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.others_0(31 downto 24);
    -- end if;

  when (16#008#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_CCDID" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_ccdid;
    -- end if;

  when (16#009#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_COLS" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_cols(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_cols(13 downto 8);
    -- end if;

  when (16#00A#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "RESERVED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.reserved;
    -- end if;

  when (16#00B#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_ROWS" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_rows(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_rows(13 downto 8);
    -- end if;

  when (16#00C#) =>
      -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.others_0(31 downto 24);
    -- end if;

  when (16#00D#) =>
      -- AEB Critical Configuration Area Register "DAC_CONFIG_1" : RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.others_0(31 downto 24);
    -- end if;

  when (16#00E#) =>
      -- AEB Critical Configuration Area Register "DAC_CONFIG_2" : RESERVED_0, "DAC_VOD", "RESERVED_1" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.others_0(31 downto 24);
    -- end if;

  when (16#00F#) =>
      -- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_reserved_20.reserved(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_reserved_20.reserved(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_reserved_20.reserved(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_reserved_20.reserved(31 downto 24);
    -- end if;

  when (16#010#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCCD_ON" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config1.time_vccd_on;
    -- end if;

  when (16#011#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCLK_ON" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config1.time_vclk_on;
    -- end if;

  when (16#012#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN1_ON" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config1.time_van1_on;
    -- end if;

  when (16#013#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN2_ON" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config1.time_van2_on;
    -- end if;

  when (16#014#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN3_ON" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config2.time_van3_on;
    -- end if;

  when (16#015#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCCD_OFF" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config2.time_vccd_off;
    -- end if;

  when (16#016#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCLK_OFF" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config2.time_vclk_off;
    -- end if;

  when (16#017#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN1_OFF" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config2.time_van1_off;
    -- end if;

  when (16#018#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN2_OFF" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config3.time_van2_off;
    -- end if;

  when (16#019#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN3_OFF" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config3.time_van3_off;
    -- end if;

  when (16#01A#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.others_0(31 downto 24);
    -- end if;

  when (16#01B#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.others_0(31 downto 24);
    -- end if;

  when (16#01C#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.others_0(31 downto 24);
    -- end if;

  when (16#01D#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.others_0(31 downto 24);
    -- end if;

  when (16#01E#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.others_0(31 downto 24);
    -- end if;

  when (16#01F#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.others_0(31 downto 24);
    -- end if;

  when (16#020#) =>
      -- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_118.reserved(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_118.reserved(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_118.reserved(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_118.reserved(31 downto 24);
    -- end if;

  when (16#021#) =>
      -- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_11c.reserved(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_11c.reserved(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_11c.reserved(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_11c.reserved(31 downto 24);
    -- end if;

  when (16#022#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : RESERVED_0, "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "RESERVED_1", "ADC_CLK_DIV" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.others_0(31 downto 24);
    -- end if;

  when (16#023#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_2" : ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.others_0(31 downto 24);
    -- end if;

  when (16#024#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_3" : RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.others_0(31 downto 24);
    -- end if;

  when (16#025#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_4" : RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.others_0(31 downto 24);
    -- end if;

  when (16#026#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_5" : SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "VASP_OUT_CTRL", "RESERVED", "VASP_OUT_EN_POS" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.others_0(31 downto 24);
    -- end if;

  when (16#027#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_6" : VASP_OUT_CTRL_INV, "RESERVED_0", "VASP_OUT_DIS_POS", "RESERVED_1" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.others_0(31 downto 24);
    -- end if;

  when (16#028#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_7.reserved(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_7.reserved(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_7.reserved(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_7.reserved(31 downto 24);
    -- end if;

  when (16#029#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_8.reserved(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_8.reserved(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_8.reserved(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_8.reserved(31 downto 24);
    -- end if;

  when (16#02A#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_0" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.reserved_0;
    -- end if;

  when (16#02B#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "FT_LOOP_CNT" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.ft_loop_cnt(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.ft_loop_cnt(13 downto 8);
    -- end if;

  when (16#02C#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_ENABLED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.lt0_enabled;
    -- end if;

  when (16#02D#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_1" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.reserved_1;
    -- end if;

  when (16#02E#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_LOOP_CNT" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.lt0_loop_cnt(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.lt0_loop_cnt(13 downto 8);
    -- end if;

  when (16#02F#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_ENABLED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt1_enabled;
    -- end if;

  when (16#030#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_0" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.reserved_0;
    -- end if;

  when (16#031#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_LOOP_CNT" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt1_loop_cnt(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt1_loop_cnt(13 downto 8);
    -- end if;

  when (16#032#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_ENABLED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt2_enabled;
    -- end if;

  when (16#033#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_1" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.reserved_1;
    -- end if;

  when (16#034#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_LOOP_CNT" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt2_loop_cnt(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt2_loop_cnt(13 downto 8);
    -- end if;

  when (16#035#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_ENABLED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.lt3_enabled;
    -- end if;

  when (16#036#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "RESERVED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.reserved;
    -- end if;

  when (16#037#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_LOOP_CNT" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.lt3_loop_cnt(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.lt3_loop_cnt(13 downto 8);
    -- end if;

  when (16#038#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "PIX_LOOP_CNT_WORD_1" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.pix_loop_cnt_word_1(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.pix_loop_cnt_word_1(15 downto 8);
    -- end if;

  when (16#039#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PIX_LOOP_CNT_WORD_0" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pix_loop_cnt_word_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pix_loop_cnt_word_0(15 downto 8);
    -- end if;

  when (16#03A#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_ENABLED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pc_enabled;
    -- end if;

  when (16#03B#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "RESERVED" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.reserved;
    -- end if;

  when (16#03C#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_LOOP_CNT" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pc_loop_cnt(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pc_loop_cnt(13 downto 8);
    -- end if;

  when (16#03D#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_0" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.reserved_0;
    -- end if;

  when (16#03E#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT1_LOOP_CNT" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.int1_loop_cnt(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.int1_loop_cnt(13 downto 8);
    -- end if;

  when (16#03F#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_1" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.reserved_1;
    -- end if;

  when (16#040#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT2_LOOP_CNT" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.int2_loop_cnt(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.int2_loop_cnt(13 downto 8);
    -- end if;

  when (16#041#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_14" : RESERVED_0, "SPHI_INV", "RESERVED_1", "RPHI_INV", "RESERVED_2" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.others_0(31 downto 24);
    -- end if;

  when (16#042#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "AEB_STATUS" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_hk_aeb_status.aeb_status;
    -- end if;

  when (16#043#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_hk_aeb_status.others_0;
    -- end if;

  when (16#044#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_aeb_status.others_1(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(11 downto 8) <= rmap_registers_wr_i.aeb_hk_aeb_status.others_1(11 downto 8);
    -- end if;

  when (16#045#) =>
      -- AEB Housekeeping Area Register "TIMESTAMP_1" : "TIMESTAMP_DWORD_1" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_timestamp_1.timestamp_dword_1(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_timestamp_1.timestamp_dword_1(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_timestamp_1.timestamp_dword_1(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_timestamp_1.timestamp_dword_1(31 downto 24);
    -- end if;

  when (16#046#) =>
      -- AEB Housekeeping Area Register "TIMESTAMP_2" : "TIMESTAMP_DWORD_0" Field
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_timestamp_2.timestamp_dword_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_timestamp_2.timestamp_dword_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_timestamp_2.timestamp_dword_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_timestamp_2.timestamp_dword_0(31 downto 24);
    -- end if;

  when (16#047#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.others_0(31 downto 24);
    -- end if;

  when (16#048#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.others_0(31 downto 24);
    -- end if;

  when (16#049#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.others_0(31 downto 24);
    -- end if;

  when (16#04A#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.others_0(31 downto 24);
    -- end if;

  when (16#04B#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.others_0(31 downto 24);
    -- end if;

  when (16#04C#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.others_0(31 downto 24);
    -- end if;

  when (16#04D#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.others_0(31 downto 24);
    -- end if;

  when (16#04E#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.others_0(31 downto 24);
    -- end if;

  when (16#04F#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.others_0(31 downto 24);
    -- end if;

  when (16#050#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.others_0(31 downto 24);
    -- end if;

  when (16#051#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.others_0(31 downto 24);
    -- end if;

  when (16#052#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.others_0(31 downto 24);
    -- end if;

  when (16#053#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.others_0(31 downto 24);
    -- end if;

  when (16#054#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.others_0(31 downto 24);
    -- end if;

  when (16#055#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.others_0(31 downto 24);
    -- end if;

  when (16#056#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.others_0(31 downto 24);
    -- end if;

  when (16#057#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.others_0(31 downto 24);
    -- end if;

  when (16#058#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.others_0(31 downto 24);
    -- end if;

  when (16#059#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.others_0(31 downto 24);
    -- end if;

  when (16#05A#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.others_0(31 downto 24);
    -- end if;

  when (16#05B#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.others_0(31 downto 24);
    -- end if;

  when (16#05C#) =>
      -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : SPIRST, "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(5 downto 0) <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_1.others_0;
    -- end if;

  when (16#05D#) =>
      -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : IDLMOD, "DLY2", "DLY1", "DLY0", "SBCS1", "SBCS0", "DRATE1", "DRATE0", "AINP3", "AINP2", "AINP1", "AINP0", "AINN3", "AINN2", "AINN1", "AINN0", "DIFF7", "DIFF6", "DIFF5", "DIFF4", "DIFF3", "DIFF2", "DIFF1", "DIFF0" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_1.others_1(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_1.others_1(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_1.others_1(23 downto 16);
    -- end if;

  when (16#05E#) =>
      -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_2.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_2.others_0(15 downto 8);
    -- end if;

  when (16#05F#) =>
      -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : REF, "GAIN", "TEMP", "VCC" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_2.others_1;
    -- end if;

  when (16#060#) =>
      -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : OFFSET, "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_2.others_2(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(8) <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_2.others_2(8);
    -- end if;

  when (16#061#) =>
      -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_rd_i.aeb_hk_adc1_rd_config_3.others_0;
    -- end if;

  when (16#062#) =>
      -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : SPIRST, "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(5 downto 0) <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_1.others_0;
    -- end if;

  when (16#063#) =>
      -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : IDLMOD, "DLY2", "DLY1", "DLY0", "SBCS1", "SBCS0", "DRATE1", "DRATE0", "AINP3", "AINP2", "AINP1", "AINP0", "AINN3", "AINN2", "AINN1", "AINN0", "DIFF7", "DIFF6", "DIFF5", "DIFF4", "DIFF3", "DIFF2", "DIFF1", "DIFF0" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_1.others_1(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_1.others_1(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_1.others_1(23 downto 16);
    -- end if;

  when (16#064#) =>
      -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_2.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_2.others_0(15 downto 8);
    -- end if;

  when (16#065#) =>
      -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : REF, "GAIN", "TEMP", "VCC" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_2.others_1;
    -- end if;

  when (16#066#) =>
      -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : OFFSET, "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_2.others_2(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(8) <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_2.others_2(8);
    -- end if;

  when (16#067#) =>
      -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_rd_i.aeb_hk_adc2_rd_config_3.others_0;
    -- end if;

  when (16#068#) =>
      -- AEB Housekeeping Area Register "VASP_RD_CONFIG" : VASP1_READ_DATA, "VASP2_READ_DATA" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_vasp_rd_config.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_vasp_rd_config.others_0(15 downto 8);
    -- end if;

  when (16#069#) =>
      -- AEB Housekeeping Area Register "REVISION_ID_1" : FPGA_VERSION, "FPGA_DATE" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_revision_id_1.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_revision_id_1.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_revision_id_1.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_revision_id_1.others_0(31 downto 24);
    -- end if;

  when (16#06A#) =>
      -- AEB Housekeeping Area Register "REVISION_ID_2" : FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields
    -- if (avalon_mm_rmap_i.byteenable(0) = '1') then
      avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_revision_id_2.others_0(7 downto 0);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(1) = '1') then
      avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_revision_id_2.others_0(15 downto 8);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(2) = '1') then
      avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_revision_id_2.others_0(23 downto 16);
    -- end if;
    -- if (avalon_mm_rmap_i.byteenable(3) = '1') then
      avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_revision_id_2.others_0(31 downto 24);
    -- end if;

  when others =>
  -- No register associated to the address, return with 0x00000000
    avalon_mm_rmap_o.readdata <= (others => '0');

end case;

		end procedure p_avs_readdata;

		variable v_fee_read_address : std_logic_vector(31 downto 0)          := (others => '0');
		variable v_avs_read_address : t_farm_avalon_mm_rmap_ffee_aeb_address := 0;
	begin
		if (rst_i = '1') then
			fee_rmap_o.readdata          <= (others => '0');
			fee_rmap_o.waitrequest       <= '1';
			avalon_mm_rmap_o.readdata    <= (others => '0');
			avalon_mm_rmap_o.waitrequest <= '1';
			v_fee_read_address           := (others => '0');
			v_avs_read_address           := 0;
		elsif (rising_edge(clk_i)) then

			fee_rmap_o.readdata          <= (others => '0');
			fee_rmap_o.waitrequest       <= '1';
			avalon_mm_rmap_o.readdata    <= (others => '0');
			avalon_mm_rmap_o.waitrequest <= '1';
			if (fee_rmap_i.read = '1') then
				v_fee_read_address     := fee_rmap_i.address;
				fee_rmap_o.waitrequest <= '0';
				p_ffee_aeb_rmap_mem_rd(v_fee_read_address);
			elsif (avalon_mm_rmap_i.read = '1') then
				v_avs_read_address           := to_integer(unsigned(avalon_mm_rmap_i.address));
				avalon_mm_rmap_o.waitrequest <= '0';
				p_avs_readdata(v_avs_read_address);
			end if;

		end if;
	end process p_farm_rmap_mem_area_ffee_aeb_read;

end architecture RTL;
