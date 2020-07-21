library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.farm_rmap_mem_area_ffee_aeb_pkg.all;
use work.farm_avalon_mm_rmap_ffee_aeb_pkg.all;

entity farm_rmap_mem_area_ffee_aeb_write_ent is
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		fee_rmap_i          : in  t_farm_ffee_aeb_rmap_write_in;
		avalon_mm_rmap_i    : in  t_farm_avalon_mm_rmap_ffee_aeb_write_in;
		fee_rmap_o          : out t_farm_ffee_aeb_rmap_write_out;
		avalon_mm_rmap_o    : out t_farm_avalon_mm_rmap_ffee_aeb_write_out;
		rmap_registers_wr_o : out t_rmap_memory_wr_area
	);
end entity farm_rmap_mem_area_ffee_aeb_write_ent;

architecture RTL of farm_rmap_mem_area_ffee_aeb_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_farm_rmap_mem_area_ffee_aeb_write : process(clk_i, rst_i) is
		procedure p_ffee_aeb_reg_reset is
		begin

-- Write Registers Reset/Default State

-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_control.reserved_0 <= (others => '0');
-- AEB Critical Configuration Area Register "AEB_CONTROL" : "NEW_STATE" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_control.new_state <= "0000";
-- AEB Critical Configuration Area Register "AEB_CONTROL" : "SET_STATE" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_control.set_state <= '0';
-- AEB Critical Configuration Area Register "AEB_CONTROL" : "AEB_RESET" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_control.aeb_reset <= '0';
-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_control.reserved_1 <= (others => '0');
-- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_DATA_RD" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_control.adc_data_rd <= '0';
-- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_CFG_WR" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_control.adc_cfg_wr <= '0';
-- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_CFG_RD" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_control.adc_cfg_rd <= '0';
-- AEB Critical Configuration Area Register "AEB_CONTROL" : "DAC_WR" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_control.dac_wr <= '0';
-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_2" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_control.reserved_2 <= (others => '0');
-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config.reserved_0 <= (others => '0');
-- AEB Critical Configuration Area Register "AEB_CONFIG" : "WATCH-DOG_DIS" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config.watchdog_dis <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG" : "INT_SYNC" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config.int_sync <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config.reserved_1 <= (others => '0');
-- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP_CDS_EN" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config.vasp_cds_en <= '1';
-- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP2_CAL_EN" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config.vasp2_cal_en <= '1';
-- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP1_CAL_EN" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config.vasp1_cal_en <= '1';
-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_2" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config.reserved_2 <= (others => '0');
-- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_key.key <= (others => '0');
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_SW" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.override_sw <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.reserved_0 <= (others => '0');
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN3" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_van3 <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN2" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_van2 <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN1" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_van1 <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VCLK" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_vclk <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VCCD" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_vccd <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_VASP" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.override_vasp <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.reserved_1 <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_PIX_EN" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp2_pix_en <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_PIX_EN" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp1_pix_en <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_ADC_EN" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp2_adc_en <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_ADC_EN" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp1_adc_en <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_RESET" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp2_reset <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_RESET" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp1_reset <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_ADC" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.override_adc <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC2_EN_P5V0" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc2_en_p5v0 <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC1_EN_P5V0" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc1_en_p5v0 <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "PT1000_CAL_ON_N" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.pt1000_cal_on_n <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "EN_V_MUX_N" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.en_v_mux_n <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC2_PWDN_N" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc2_pwdn_n <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC1_PWDN_N" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc1_pwdn_n <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC_CLK_EN" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc_clk_en <= '0';
-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_2" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.reserved_2 <= (others => '0');
-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_CCDID" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_ccdid <= "00";
-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_COLS" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_cols <= std_logic_vector(to_unsigned(32, 14));
-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "RESERVED" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.reserved <= (others => '0');
-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_ROWS" Field
rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_rows <= std_logic_vector(to_unsigned(32, 14));
-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP_CFG_ADDR" Field
rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp_cfg_addr <= (others => '0');
-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP1_CFG_DATA" Field
rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp1_cfg_data <= (others => '0');
-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP2_CFG_DATA" Field
rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp2_cfg_data <= (others => '0');
-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "RESERVED" Field
rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.reserved <= (others => '0');
-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP2_SELECT" Field
rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp2_select <= '0';
-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP1_SELECT" Field
rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp1_select <= '0';
-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "CALIBRATION_START" Field
rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.calibration_start <= '0';
-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "I2C_READ_START" Field
rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.i2c_read_start <= '0';
-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "I2C_WRITE_START" Field
rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.i2c_write_start <= '0';
-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.reserved_0 <= (others => '0');
-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VOG" Field
rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.dac_vog <= x"800";
-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.reserved_1 <= (others => '0');
-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VRD" Field
rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.dac_vrd <= x"800";
-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.reserved_0 <= (others => '0');
-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "DAC_VOD" Field
rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.dac_vod <= x"800";
-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.reserved_1 <= (others => '0');
-- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
rmap_registers_wr_o.aeb_crit_cfg_reserved_20.reserved <= (others => '0');
-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCCD_ON" Field
rmap_registers_wr_o.aeb_crit_cfg_pwr_config1.time_vccd_on <= x"00";
-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCLK_ON" Field
rmap_registers_wr_o.aeb_crit_cfg_pwr_config1.time_vclk_on <= x"63";
-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN1_ON" Field
rmap_registers_wr_o.aeb_crit_cfg_pwr_config1.time_van1_on <= x"C8";
-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN2_ON" Field
rmap_registers_wr_o.aeb_crit_cfg_pwr_config1.time_van2_on <= x"C8";
-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN3_ON" Field
rmap_registers_wr_o.aeb_crit_cfg_pwr_config2.time_van3_on <= x"C8";
-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCCD_OFF" Field
rmap_registers_wr_o.aeb_crit_cfg_pwr_config2.time_vccd_off <= x"C8";
-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCLK_OFF" Field
rmap_registers_wr_o.aeb_crit_cfg_pwr_config2.time_vclk_off <= x"63";
-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN1_OFF" Field
rmap_registers_wr_o.aeb_crit_cfg_pwr_config2.time_van1_off <= x"00";
-- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN2_OFF" Field
rmap_registers_wr_o.aeb_crit_cfg_pwr_config3.time_van2_off <= x"00";
-- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN3_OFF" Field
rmap_registers_wr_o.aeb_crit_cfg_pwr_config3.time_van3_off <= x"00";
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.reserved_0 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "SPIRST" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.spirst <= '1';
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "MUXMOD" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.muxmod <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "BYPAS" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.bypas <= '1';
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "CLKENB" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.clkenb <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "CHOP" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.chop <= '1';
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "STAT" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.stat <= '1';
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.reserved_1 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "IDLMOD" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.idlmod <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DLY" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.dly <= "100";
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "SBCS" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.sbcs <= (others => '0');
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DRATE" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.drate <= (others => '0');
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "AINP" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.ainp <= (others => '0');
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "AINN" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.ainn <= (others => '0');
-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DIFF" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.diff <= x"3F";
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN7" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain7 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN6" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain6 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN5" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain5 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN4" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain4 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN3" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain3 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN2" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain2 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN1" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain1 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN0" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain0 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN15" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain15 <= '1';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN14" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain14 <= '1';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN13" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain13 <= '1';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN12" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain12 <= '1';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN11" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain11 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN10" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain10 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN9" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain9 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN8" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain8 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.reserved_0 <= (others => '0');
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "REF" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ref <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "GAIN" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.gain <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "TEMP" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.temp <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "VCC" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.vcc <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.reserved_1 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "OFFSET" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.offset <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO7" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio7 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO6" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio6 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO5" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio5 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO4" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio4 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO3" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio3 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO2" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio2 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO1" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio1 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO0" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio0 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO7" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio7 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO6" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio6 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO5" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio5 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO4" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio4 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO3" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio3 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO2" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio2 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO1" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio1 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO0" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio0 <= '0';
-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "RESERVED" Field
rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.reserved <= (others => '0');
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.reserved_0 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "SPIRST" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.spirst <= '1';
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "MUXMOD" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.muxmod <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "BYPAS" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.bypas <= '1';
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "CLKENB" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.clkenb <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "CHOP" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.chop <= '1';
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "STAT" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.stat <= '1';
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.reserved_1 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "IDLMOD" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.idlmod <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DLY" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.dly <= "100";
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "SBCS" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.sbcs <= (others => '0');
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DRATE" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.drate <= (others => '0');
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "AINP" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.ainp <= (others => '0');
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "AINN" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.ainn <= (others => '0');
-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DIFF" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.diff <= x"8F";
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN7" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain7 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN6" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain6 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN5" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain5 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN4" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain4 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN3" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain3 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN2" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain2 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN1" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain1 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN0" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain0 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN15" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain15 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN14" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain14 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN13" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain13 <= '1';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN12" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain12 <= '1';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN11" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain11 <= '1';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN10" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain10 <= '1';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN9" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain9 <= '1';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN8" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain8 <= '1';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.reserved_0 <= (others => '0');
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "REF" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ref <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "GAIN" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.gain <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "TEMP" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.temp <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "VCC" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.vcc <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.reserved_1 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "OFFSET" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.offset <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO7" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio7 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO6" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio6 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO5" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio5 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO4" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio4 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO3" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio3 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO2" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio2 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO1" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio1 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO0" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio0 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO7" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio7 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO6" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio6 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO5" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio5 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO4" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio4 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO3" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio3 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO2" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio2 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO1" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio1 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO0" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio0 <= '0';
-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "RESERVED" Field
rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.reserved <= (others => '0');
-- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
rmap_registers_wr_o.aeb_gen_cfg_reserved_118.reserved <= (others => '0');
-- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
rmap_registers_wr_o.aeb_gen_cfg_reserved_11c.reserved <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.reserved_0 <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_CCD_ENABLE" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_ccd_enable <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPARE" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_spare <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TSTLINE" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_tstline <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TSTFRM" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_tstfrm <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_VASPCLAMP" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_vaspclamp <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_PRECLAMP" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_preclamp <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IG" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_ig <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TG" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_tg <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_DG" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_dg <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHIR" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_rphir <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SW" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sw <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI3" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_rphi3 <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI2" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_rphi2 <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI1" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_rphi1 <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI4" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sphi4 <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI3" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sphi3 <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI2" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sphi2 <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI1" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sphi1 <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI4" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_iphi4 <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI3" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_iphi3 <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI2" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_iphi2 <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI1" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_iphi1 <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.reserved_1 <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "ADC_CLK_DIV" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.adc_clk_div <= "0011111";
-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "ADC_CLK_LOW_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_2.adc_clk_low_pos <= x"0E";
-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "ADC_CLK_HIGH_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_2.adc_clk_high_pos <= x"1F";
-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "CDS_CLK_LOW_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_2.cds_clk_low_pos <= x"00";
-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "CDS_CLK_HIGH_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_2.cds_clk_high_pos <= x"11";
-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHIR_CLK_LOW_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_3.rphir_clk_low_pos <= x"00";
-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHIR_CLK_HIGH_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_3.rphir_clk_high_pos <= x"00";
-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHI1_CLK_LOW_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_3.rphi1_clk_low_pos <= x"00";
-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHI1_CLK_HIGH_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_3.rphi1_clk_high_pos <= x"00";
-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI2_CLK_LOW_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_4.rphi2_clk_low_pos <= x"00";
-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI2_CLK_HIGH_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_4.rphi2_clk_high_pos <= x"00";
-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI3_CLK_LOW_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_4.rphi3_clk_low_pos <= x"00";
-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI3_CLK_HIGH_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_4.rphi3_clk_high_pos <= x"00";
-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "SW_CLK_LOW_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.sw_clk_low_pos <= x"00";
-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "SW_CLK_HIGH_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.sw_clk_high_pos <= x"00";
-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "VASP_OUT_CTRL" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.vasp_out_ctrl <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "RESERVED" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.reserved <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "VASP_OUT_EN_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.vasp_out_en_pos <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "VASP_OUT_CTRL_INV" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.vasp_out_ctrl_inv <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.reserved_0 <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "VASP_OUT_DIS_POS" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.vasp_out_dis_pos <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.reserved_1 <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_7.reserved <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_8.reserved <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.reserved_0 <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "FT_LOOP_CNT" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.ft_loop_cnt <= "00100011000101";
-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_ENABLED" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.lt0_enabled <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.reserved_1 <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_LOOP_CNT" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.lt0_loop_cnt <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_ENABLED" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt1_enabled <= '1';
-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.reserved_0 <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_LOOP_CNT" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt1_loop_cnt <= "00100011000101";
-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_ENABLED" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt2_enabled <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.reserved_1 <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_LOOP_CNT" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt2_loop_cnt <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_ENABLED" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.lt3_enabled <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "RESERVED" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.reserved <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_LOOP_CNT" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.lt3_loop_cnt <= "00101000000000";
-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "PIX_LOOP_CNT_WORD_1" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.pix_loop_cnt_word_1 <= x"0000";
-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PIX_LOOP_CNT_WORD_0" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pix_loop_cnt_word_0 <= x"08C5";
-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_ENABLED" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pc_enabled <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "RESERVED" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.reserved <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_LOOP_CNT" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pc_loop_cnt <= "01000110001010";
-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.reserved_0 <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT1_LOOP_CNT" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.int1_loop_cnt <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.reserved_1 <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT2_LOOP_CNT" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.int2_loop_cnt <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_0" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.reserved_0 <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "SPHI_INV" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.sphi_inv <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_1" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.reserved_1 <= (others => '0');
-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RPHI_INV" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.rphi_inv <= '0';
-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_2" Field
rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.reserved_2 <= (others => '0');
-- AEB Housekeeping Area Register "AEB_STATUS" : "AEB_STATUS" Field
rmap_registers_wr_o.aeb_hk_aeb_status.aeb_status <= (others => '0');
-- AEB Housekeeping Area Register "AEB_STATUS" : "VASP2_CFG_RUN" Field
rmap_registers_wr_o.aeb_hk_aeb_status.vasp2_cfg_run <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "VASP1_CFG_RUN" Field
rmap_registers_wr_o.aeb_hk_aeb_status.vasp1_cfg_run <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "DAC_CFG_WR_RUN" Field
rmap_registers_wr_o.aeb_hk_aeb_status.dac_cfg_wr_run <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_RD_RUN" Field
rmap_registers_wr_o.aeb_hk_aeb_status.adc_cfg_rd_run <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_WR_RUN" Field
rmap_registers_wr_o.aeb_hk_aeb_status.adc_cfg_wr_run <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_DAT_RD_RUN" Field
rmap_registers_wr_o.aeb_hk_aeb_status.adc_dat_rd_run <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_ERROR" Field
rmap_registers_wr_o.aeb_hk_aeb_status.adc_error <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC2_LU" Field
rmap_registers_wr_o.aeb_hk_aeb_status.adc2_lu <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC1_LU" Field
rmap_registers_wr_o.aeb_hk_aeb_status.adc1_lu <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_DAT_RD" Field
rmap_registers_wr_o.aeb_hk_aeb_status.adc_dat_rd <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_RD" Field
rmap_registers_wr_o.aeb_hk_aeb_status.adc_cfg_rd <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_WR" Field
rmap_registers_wr_o.aeb_hk_aeb_status.adc_cfg_wr <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC2_BUSY" Field
rmap_registers_wr_o.aeb_hk_aeb_status.adc2_busy <= '0';
-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC1_BUSY" Field
rmap_registers_wr_o.aeb_hk_aeb_status.adc1_busy <= '0';
-- AEB Housekeeping Area Register "TIMESTAMP_1" : "TIMESTAMP_DWORD_1" Field
rmap_registers_wr_o.aeb_hk_timestamp_1.timestamp_dword_1 <= (others => '0');
-- AEB Housekeeping Area Register "TIMESTAMP_2" : "TIMESTAMP_DWORD_0" Field
rmap_registers_wr_o.aeb_hk_timestamp_2.timestamp_dword_0 <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_l.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_l.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_l.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_l.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "ADC_CHX_DATA_T_VASP_L" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_l.adc_chx_data_t_vasp_l <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_r.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_r.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_r.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_r.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "ADC_CHX_DATA_T_VASP_R" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_r.adc_chx_data_t_vasp_r <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_bias_p.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_bias_p.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_bias_p.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_bias_p.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "ADC_CHX_DATA_T_BIAS_P" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_bias_p.adc_chx_data_t_bias_p <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_hk_p.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_hk_p.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_hk_p.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_hk_p.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "ADC_CHX_DATA_T_HK_P" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_hk_p.adc_chx_data_t_hk_p <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_1_p.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_1_p.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_1_p.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_1_p.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "ADC_CHX_DATA_T_TOU_1_P" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_1_p.adc_chx_data_t_tou_1_p <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_2_p.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_2_p.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_2_p.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_2_p.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "ADC_CHX_DATA_T_TOU_2_P" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_2_p.adc_chx_data_t_tou_2_p <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vode.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vode.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vode.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vode.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "ADC_CHX_DATA_HK_VODE" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vode.adc_chx_data_hk_vode <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vodf.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vodf.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vodf.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vodf.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "ADC_CHX_DATA_HK_VODF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vodf.adc_chx_data_hk_vodf <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vrd.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vrd.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vrd.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vrd.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "ADC_CHX_DATA_HK_VRD" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vrd.adc_chx_data_hk_vrd <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vog.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vog.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vog.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vog.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "ADC_CHX_DATA_HK_VOG" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vog.adc_chx_data_hk_vog <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ccd.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ccd.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ccd.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ccd.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "ADC_CHX_DATA_T_CCD" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ccd.adc_chx_data_t_ccd <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref1k_mea.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref1k_mea.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref1k_mea.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref1k_mea.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "ADC_CHX_DATA_T_REF1K_MEA" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref1k_mea.adc_chx_data_t_ref1k_mea <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref649r_mea.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref649r_mea.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref649r_mea.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref649r_mea.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "ADC_CHX_DATA_T_REF649R_MEA" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref649r_mea.adc_chx_data_t_ref649r_mea <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_n5v.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_n5v.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_n5v.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_n5v.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "ADC_CHX_DATA_HK_ANA_N5V" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_n5v.adc_chx_data_hk_ana_n5v <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_s_ref.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_s_ref.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_s_ref.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_s_ref.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "ADC_CHX_DATA_S_REF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_s_ref.adc_chx_data_s_ref <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ccd_p31v.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ccd_p31v.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ccd_p31v.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ccd_p31v.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "ADC_CHX_DATA_HK_CCD_P31V" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ccd_p31v.adc_chx_data_hk_ccd_p31v <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_clk_p15v.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_clk_p15v.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_clk_p15v.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_clk_p15v.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "ADC_CHX_DATA_HK_CLK_P15V" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_clk_p15v.adc_chx_data_hk_clk_p15v <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p5v.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p5v.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p5v.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p5v.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "ADC_CHX_DATA_HK_ANA_P5V" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p5v.adc_chx_data_hk_ana_p5v <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p3v3.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p3v3.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p3v3.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p3v3.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "ADC_CHX_DATA_HK_ANA_P3V3" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p3v3.adc_chx_data_hk_ana_p3v3 <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_dig_p3v3.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_dig_p3v3.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_dig_p3v3.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_dig_p3v3.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "ADC_CHX_DATA_HK_DIG_P3V3" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_dig_p3v3.adc_chx_data_hk_dig_p3v3 <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "NEW" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_adc_ref_buf_2.new_data <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "OVF" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_adc_ref_buf_2.ovf <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "SUPPLY" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_adc_ref_buf_2.supply <= '0';
-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "CHID" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_adc_ref_buf_2.chid <= (others => '0');
-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "ADC_CHX_DATA_ADC_REF_BUF_2" Field
rmap_registers_wr_o.aeb_hk_adc_rd_data_adc_ref_buf_2.adc_chx_data_adc_ref_buf_2 <= (others => '0');
-- AEB Housekeeping Area Register "VASP_RD_CONFIG" : "VASP1_READ_DATA" Field
rmap_registers_wr_o.aeb_hk_vasp_rd_config.vasp1_read_data <= (others => '0');
-- AEB Housekeeping Area Register "VASP_RD_CONFIG" : "VASP2_READ_DATA" Field
rmap_registers_wr_o.aeb_hk_vasp_rd_config.vasp2_read_data <= (others => '0');
-- AEB Housekeeping Area Register "REVISION_ID_1" : "FPGA_VERSION" Field
rmap_registers_wr_o.aeb_hk_revision_id_1.fpga_version <= (others => '0');
-- AEB Housekeeping Area Register "REVISION_ID_1" : "FPGA_DATE" Field
rmap_registers_wr_o.aeb_hk_revision_id_1.fpga_date <= (others => '0');
-- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_TIME_H" Field
rmap_registers_wr_o.aeb_hk_revision_id_2.fpga_time_h <= (others => '0');
-- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_TIME_M" Field
rmap_registers_wr_o.aeb_hk_revision_id_2.fpga_time_m <= (others => '0');
-- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_SVN" Field
rmap_registers_wr_o.aeb_hk_revision_id_2.fpga_svn <= (others => '0');

		end procedure p_ffee_aeb_reg_reset;

		procedure p_ffee_aeb_reg_trigger is
		begin

			-- Write Registers Triggers Reset

		end procedure p_ffee_aeb_reg_trigger;

		procedure p_ffee_aeb_mem_wr(wr_addr_i : std_logic_vector) is
		begin

			-- MemArea Write Data
			case (wr_addr_i(31 downto 0)) is
				-- Case for access to all memory area

				when (x"00000000") =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "AEB_RESET" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_control.aeb_reset  <= fee_rmap_i.writedata(0);
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "SET_STATE" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_control.set_state  <= fee_rmap_i.writedata(1);
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "NEW_STATE" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_control.new_state  <= fee_rmap_i.writedata(5 downto 2);
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_control.reserved_0 <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000001") =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "DAC_WR" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_control.dac_wr      <= fee_rmap_i.writedata(0);
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_CFG_RD" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_control.adc_cfg_rd  <= fee_rmap_i.writedata(1);
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_CFG_WR" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_control.adc_cfg_wr  <= fee_rmap_i.writedata(2);
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_DATA_RD" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_control.adc_data_rd <= fee_rmap_i.writedata(3);
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_control.reserved_1  <= fee_rmap_i.writedata(7 downto 4);

				when (x"00000002") =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_2" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_control.reserved_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000003") =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_2" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_control.reserved_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000004") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "INT_SYNC" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config.int_sync     <= fee_rmap_i.writedata(0);
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "WATCH-DOG_DIS" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config.watchdog_dis <= fee_rmap_i.writedata(1);
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config.reserved_0   <= fee_rmap_i.writedata(7 downto 2);

				when (x"00000005") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP1_CAL_EN" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config.vasp1_cal_en <= fee_rmap_i.writedata(0);
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP2_CAL_EN" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config.vasp2_cal_en <= fee_rmap_i.writedata(1);
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP_CDS_EN" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config.vasp_cds_en  <= fee_rmap_i.writedata(2);
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config.reserved_1   <= fee_rmap_i.writedata(7 downto 3);

				when (x"00000006") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_2" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config.reserved_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000007") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_2" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config.reserved_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000008") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_key.key(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000009") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_key.key(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000000A") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_key.key(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000000B") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_key.key(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000000C") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VCCD" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_vccd     <= fee_rmap_i.writedata(0);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VCLK" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_vclk     <= fee_rmap_i.writedata(1);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN1" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_van1     <= fee_rmap_i.writedata(2);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN2" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_van2     <= fee_rmap_i.writedata(3);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN3" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_van3     <= fee_rmap_i.writedata(4);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.reserved_0  <= fee_rmap_i.writedata(6 downto 5);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_SW" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.override_sw <= fee_rmap_i.writedata(7);

				when (x"0000000D") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_RESET" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp1_reset   <= fee_rmap_i.writedata(0);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_RESET" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp2_reset   <= fee_rmap_i.writedata(1);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_ADC_EN" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp1_adc_en  <= fee_rmap_i.writedata(2);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_ADC_EN" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp2_adc_en  <= fee_rmap_i.writedata(3);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_PIX_EN" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp1_pix_en  <= fee_rmap_i.writedata(4);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_PIX_EN" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp2_pix_en  <= fee_rmap_i.writedata(5);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.reserved_1    <= fee_rmap_i.writedata(6);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_VASP" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.override_vasp <= fee_rmap_i.writedata(7);

				when (x"0000000E") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC_CLK_EN" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc_clk_en      <= fee_rmap_i.writedata(0);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC1_PWDN_N" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc1_pwdn_n     <= fee_rmap_i.writedata(1);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC2_PWDN_N" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc2_pwdn_n     <= fee_rmap_i.writedata(2);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "EN_V_MUX_N" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.en_v_mux_n      <= fee_rmap_i.writedata(3);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "PT1000_CAL_ON_N" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.pt1000_cal_on_n <= fee_rmap_i.writedata(4);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC1_EN_P5V0" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc1_en_p5v0    <= fee_rmap_i.writedata(5);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC2_EN_P5V0" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc2_en_p5v0    <= fee_rmap_i.writedata(6);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_ADC" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.override_adc    <= fee_rmap_i.writedata(7);

				when (x"0000000F") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_2" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.reserved_2 <= fee_rmap_i.writedata;

				when (x"00000010") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_COLS" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_cols(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_CCDID" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_ccdid             <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000011") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_COLS" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_cols(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000012") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_ROWS" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_rows(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "RESERVED" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.reserved                  <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000013") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_ROWS" Field
					rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_rows(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000014") =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP_CFG_ADDR" Field
					rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp_cfg_addr <= fee_rmap_i.writedata;

				when (x"00000015") =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP1_CFG_DATA" Field
					rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp1_cfg_data <= fee_rmap_i.writedata;

				when (x"00000016") =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP2_CFG_DATA" Field
					rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp2_cfg_data <= fee_rmap_i.writedata;

				when (x"00000017") =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "I2C_WRITE_START" Field
					rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.i2c_write_start   <= fee_rmap_i.writedata(0);
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "I2C_READ_START" Field
					rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.i2c_read_start    <= fee_rmap_i.writedata(1);
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "CALIBRATION_START" Field
					rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.calibration_start <= fee_rmap_i.writedata(2);
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP1_SELECT" Field
					rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp1_select      <= fee_rmap_i.writedata(3);
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP2_SELECT" Field
					rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp2_select      <= fee_rmap_i.writedata(4);
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "RESERVED" Field
					rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.reserved          <= fee_rmap_i.writedata(7 downto 5);

				when (x"00000018") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VOG" Field
					rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.dac_vog(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.reserved_0           <= fee_rmap_i.writedata(7 downto 4);

				when (x"00000019") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VOG" Field
					rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.dac_vog(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000001A") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VRD" Field
					rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.dac_vrd(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.reserved_1           <= fee_rmap_i.writedata(7 downto 4);

				when (x"0000001B") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VRD" Field
					rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.dac_vrd(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000001C") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "DAC_VOD" Field
					rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.dac_vod(11 downto 8) <= fee_rmap_i.writedata(3 downto 0);
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.reserved_0           <= fee_rmap_i.writedata(7 downto 4);

				when (x"0000001D") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "DAC_VOD" Field
					rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.dac_vod(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000001E") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.reserved_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000001F") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.reserved_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000020") =>
					-- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
					rmap_registers_wr_o.aeb_crit_cfg_reserved_20.reserved(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000021") =>
					-- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
					rmap_registers_wr_o.aeb_crit_cfg_reserved_20.reserved(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00000022") =>
					-- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
					rmap_registers_wr_o.aeb_crit_cfg_reserved_20.reserved(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000023") =>
					-- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
					rmap_registers_wr_o.aeb_crit_cfg_reserved_20.reserved(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000024") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCCD_ON" Field
					rmap_registers_wr_o.aeb_crit_cfg_pwr_config1.time_vccd_on <= fee_rmap_i.writedata;

				when (x"00000025") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCLK_ON" Field
					rmap_registers_wr_o.aeb_crit_cfg_pwr_config1.time_vclk_on <= fee_rmap_i.writedata;

				when (x"00000026") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN1_ON" Field
					rmap_registers_wr_o.aeb_crit_cfg_pwr_config1.time_van1_on <= fee_rmap_i.writedata;

				when (x"00000027") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN2_ON" Field
					rmap_registers_wr_o.aeb_crit_cfg_pwr_config1.time_van2_on <= fee_rmap_i.writedata;

				when (x"00000028") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN3_ON" Field
					rmap_registers_wr_o.aeb_crit_cfg_pwr_config2.time_van3_on <= fee_rmap_i.writedata;

				when (x"00000029") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCCD_OFF" Field
					rmap_registers_wr_o.aeb_crit_cfg_pwr_config2.time_vccd_off <= fee_rmap_i.writedata;

				when (x"0000002A") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCLK_OFF" Field
					rmap_registers_wr_o.aeb_crit_cfg_pwr_config2.time_vclk_off <= fee_rmap_i.writedata;

				when (x"0000002B") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN1_OFF" Field
					rmap_registers_wr_o.aeb_crit_cfg_pwr_config2.time_van1_off <= fee_rmap_i.writedata;

				when (x"0000002C") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN2_OFF" Field
					rmap_registers_wr_o.aeb_crit_cfg_pwr_config3.time_van2_off <= fee_rmap_i.writedata;

				when (x"0000002D") =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN3_OFF" Field
					rmap_registers_wr_o.aeb_crit_cfg_pwr_config3.time_van3_off <= fee_rmap_i.writedata;

				when (x"00000100") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.reserved_1 <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "STAT" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.stat       <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "CHOP" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.chop       <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "CLKENB" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.clkenb     <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "BYPAS" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.bypas      <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "MUXMOD" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.muxmod     <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "SPIRST" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.spirst     <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.reserved_0 <= fee_rmap_i.writedata(7);

				when (x"00000101") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DRATE" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.drate  <= fee_rmap_i.writedata(1 downto 0);
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "SBCS" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.sbcs   <= fee_rmap_i.writedata(3 downto 2);
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DLY" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.dly    <= fee_rmap_i.writedata(6 downto 4);
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "IDLMOD" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.idlmod <= fee_rmap_i.writedata(7);

				when (x"00000102") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "AINN" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.ainn <= fee_rmap_i.writedata(3 downto 0);
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "AINP" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.ainp <= fee_rmap_i.writedata(7 downto 4);

				when (x"00000103") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DIFF" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.diff <= fee_rmap_i.writedata;

				when (x"00000104") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN0" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain0 <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN1" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain1 <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN2" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain2 <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN3" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain3 <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN4" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain4 <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN5" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain5 <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN6" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain6 <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN7" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain7 <= fee_rmap_i.writedata(7);

				when (x"00000105") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN8" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain8  <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN9" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain9  <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN10" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain10 <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN11" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain11 <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN12" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain12 <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN13" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain13 <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN14" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain14 <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN15" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain15 <= fee_rmap_i.writedata(7);

				when (x"00000106") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "OFFSET" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.offset     <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.reserved_1 <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "VCC" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.vcc        <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "TEMP" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.temp       <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "GAIN" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.gain       <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "REF" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ref        <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.reserved_0 <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000107") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO0" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio0 <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO1" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio1 <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO2" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio2 <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO3" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio3 <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO4" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio4 <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO5" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio5 <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO6" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio6 <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO7" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio7 <= fee_rmap_i.writedata(7);

				when (x"00000108") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO0" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio0 <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO1" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio1 <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO2" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio2 <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO3" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio3 <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO4" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio4 <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO5" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio5 <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO6" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio6 <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO7" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio7 <= fee_rmap_i.writedata(7);

				when (x"00000109") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.reserved(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000010A") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.reserved(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000010B") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.reserved(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000010C") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.reserved_1 <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "STAT" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.stat       <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "CHOP" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.chop       <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "CLKENB" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.clkenb     <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "BYPAS" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.bypas      <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "MUXMOD" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.muxmod     <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "SPIRST" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.spirst     <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.reserved_0 <= fee_rmap_i.writedata(7);

				when (x"0000010D") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DRATE" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.drate  <= fee_rmap_i.writedata(1 downto 0);
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "SBCS" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.sbcs   <= fee_rmap_i.writedata(3 downto 2);
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DLY" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.dly    <= fee_rmap_i.writedata(6 downto 4);
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "IDLMOD" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.idlmod <= fee_rmap_i.writedata(7);

				when (x"0000010E") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "AINN" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.ainn <= fee_rmap_i.writedata(3 downto 0);
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "AINP" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.ainp <= fee_rmap_i.writedata(7 downto 4);

				when (x"0000010F") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DIFF" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.diff <= fee_rmap_i.writedata;

				when (x"00000110") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN0" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain0 <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN1" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain1 <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN2" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain2 <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN3" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain3 <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN4" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain4 <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN5" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain5 <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN6" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain6 <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN7" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain7 <= fee_rmap_i.writedata(7);

				when (x"00000111") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN8" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain8  <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN9" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain9  <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN10" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain10 <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN11" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain11 <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN12" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain12 <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN13" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain13 <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN14" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain14 <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN15" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain15 <= fee_rmap_i.writedata(7);

				when (x"00000112") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "OFFSET" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.offset     <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.reserved_1 <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "VCC" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.vcc        <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "TEMP" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.temp       <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "GAIN" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.gain       <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "REF" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ref        <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.reserved_0 <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000113") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO0" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio0 <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO1" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio1 <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO2" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio2 <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO3" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio3 <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO4" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio4 <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO5" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio5 <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO6" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio6 <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO7" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio7 <= fee_rmap_i.writedata(7);

				when (x"00000114") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO0" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio0 <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO1" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio1 <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO2" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio2 <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO3" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio3 <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO4" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio4 <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO5" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio5 <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO6" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio6 <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO7" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio7 <= fee_rmap_i.writedata(7);

				when (x"00000115") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.reserved(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00000116") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.reserved(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000117") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.reserved(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000118") =>
					-- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_reserved_118.reserved(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000119") =>
					-- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_reserved_118.reserved(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000011A") =>
					-- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_reserved_118.reserved(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000011B") =>
					-- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_reserved_118.reserved(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000011C") =>
					-- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_reserved_11c.reserved(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0000011D") =>
					-- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_reserved_11c.reserved(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000011E") =>
					-- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_reserved_11c.reserved(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000011F") =>
					-- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_reserved_11c.reserved(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000120") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_PRECLAMP" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_preclamp   <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_VASPCLAMP" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_vaspclamp  <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TSTFRM" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_tstfrm     <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TSTLINE" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_tstline    <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPARE" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_spare      <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_CCD_ENABLE" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_ccd_enable <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.reserved_0        <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000121") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI1" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_rphi1 <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI2" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_rphi2 <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI3" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_rphi3 <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SW" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sw    <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHIR" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_rphir <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_DG" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_dg    <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TG" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_tg    <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IG" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_ig    <= fee_rmap_i.writedata(7);

				when (x"00000122") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI1" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_iphi1 <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI2" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_iphi2 <= fee_rmap_i.writedata(1);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI3" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_iphi3 <= fee_rmap_i.writedata(2);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI4" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_iphi4 <= fee_rmap_i.writedata(3);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI1" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sphi1 <= fee_rmap_i.writedata(4);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI2" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sphi2 <= fee_rmap_i.writedata(5);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI3" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sphi3 <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI4" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sphi4 <= fee_rmap_i.writedata(7);

				when (x"00000123") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "ADC_CLK_DIV" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.adc_clk_div <= fee_rmap_i.writedata(6 downto 0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.reserved_1  <= fee_rmap_i.writedata(7);

				when (x"00000124") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "ADC_CLK_LOW_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_2.adc_clk_low_pos <= fee_rmap_i.writedata;

				when (x"00000125") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "ADC_CLK_HIGH_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_2.adc_clk_high_pos <= fee_rmap_i.writedata;

				when (x"00000126") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "CDS_CLK_LOW_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_2.cds_clk_low_pos <= fee_rmap_i.writedata;

				when (x"00000127") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "CDS_CLK_HIGH_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_2.cds_clk_high_pos <= fee_rmap_i.writedata;

				when (x"00000128") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHIR_CLK_LOW_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_3.rphir_clk_low_pos <= fee_rmap_i.writedata;

				when (x"00000129") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHIR_CLK_HIGH_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_3.rphir_clk_high_pos <= fee_rmap_i.writedata;

				when (x"0000012A") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHI1_CLK_LOW_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_3.rphi1_clk_low_pos <= fee_rmap_i.writedata;

				when (x"0000012B") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHI1_CLK_HIGH_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_3.rphi1_clk_high_pos <= fee_rmap_i.writedata;

				when (x"0000012C") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI2_CLK_LOW_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_4.rphi2_clk_low_pos <= fee_rmap_i.writedata;

				when (x"0000012D") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI2_CLK_HIGH_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_4.rphi2_clk_high_pos <= fee_rmap_i.writedata;

				when (x"0000012E") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI3_CLK_LOW_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_4.rphi3_clk_low_pos <= fee_rmap_i.writedata;

				when (x"0000012F") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI3_CLK_HIGH_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_4.rphi3_clk_high_pos <= fee_rmap_i.writedata;

				when (x"00000130") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "SW_CLK_LOW_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.sw_clk_low_pos <= fee_rmap_i.writedata;

				when (x"00000131") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "SW_CLK_HIGH_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.sw_clk_high_pos <= fee_rmap_i.writedata;

				when (x"00000132") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "VASP_OUT_EN_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.vasp_out_en_pos(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.reserved                     <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "VASP_OUT_CTRL" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.vasp_out_ctrl                <= fee_rmap_i.writedata(7);

				when (x"00000133") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "VASP_OUT_EN_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.vasp_out_en_pos(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000134") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "VASP_OUT_DIS_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.vasp_out_dis_pos(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.reserved_0                    <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "VASP_OUT_CTRL_INV" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.vasp_out_ctrl_inv             <= fee_rmap_i.writedata(7);

				when (x"00000135") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "VASP_OUT_DIS_POS" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.vasp_out_dis_pos(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000136") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.reserved_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000137") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.reserved_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000138") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_7.reserved(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000139") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_7.reserved(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000013A") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_7.reserved(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000013B") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_7.reserved(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000013C") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_8.reserved(31 downto 24) <= fee_rmap_i.writedata;

				when (x"0000013D") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_8.reserved(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000013E") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_8.reserved(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000013F") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_8.reserved(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000140") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "FT_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.ft_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.reserved_0               <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000141") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "FT_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.ft_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000142") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.lt0_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.reserved_1                <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_ENABLED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.lt0_enabled               <= fee_rmap_i.writedata(7);

				when (x"00000143") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.lt0_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000144") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt1_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.reserved_0                <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_ENABLED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt1_enabled               <= fee_rmap_i.writedata(7);

				when (x"00000145") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt1_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000146") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt2_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.reserved_1                <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_ENABLED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt2_enabled               <= fee_rmap_i.writedata(7);

				when (x"00000147") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt2_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000148") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.lt3_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.reserved                  <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_ENABLED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.lt3_enabled               <= fee_rmap_i.writedata(7);

				when (x"00000149") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.lt3_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000014A") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "PIX_LOOP_CNT_WORD_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.pix_loop_cnt_word_1(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000014B") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "PIX_LOOP_CNT_WORD_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.pix_loop_cnt_word_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000014C") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PIX_LOOP_CNT_WORD_0" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pix_loop_cnt_word_0(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000014D") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PIX_LOOP_CNT_WORD_0" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pix_loop_cnt_word_0(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000014E") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pc_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "RESERVED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.reserved                 <= fee_rmap_i.writedata(6);
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_ENABLED" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pc_enabled               <= fee_rmap_i.writedata(7);

				when (x"0000014F") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pc_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000150") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT1_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.int1_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.reserved_0                 <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000151") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT1_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.int1_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000152") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT2_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.int2_loop_cnt(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.reserved_1                 <= fee_rmap_i.writedata(7 downto 6);

				when (x"00000153") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT2_LOOP_CNT" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.int2_loop_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000154") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "SPHI_INV" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.sphi_inv   <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_0" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.reserved_0 <= fee_rmap_i.writedata(7 downto 1);

				when (x"00000155") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RPHI_INV" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.rphi_inv   <= fee_rmap_i.writedata(0);
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_1" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.reserved_1 <= fee_rmap_i.writedata(7 downto 1);

				when (x"00000156") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_2" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.reserved_2(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000157") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_2" Field
					rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.reserved_2(7 downto 0) <= fee_rmap_i.writedata;

				when others =>
					null;

			end case;

		end procedure p_ffee_aeb_mem_wr;

		-- p_avalon_mm_rmap_write

		procedure p_avs_writedata(write_address_i : t_farm_avalon_mm_rmap_ffee_aeb_address) is
		begin

-- Registers Write Data
case (write_address_i) is
  -- Case for access to all registers address

  when (16#000#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_control.reserved_0 <= avalon_mm_rmap_i.writedata(1 downto 0);
    end if;
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "NEW_STATE" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_control.new_state <= avalon_mm_rmap_i.writedata(11 downto 8);
    end if;

  when (16#001#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "SET_STATE" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_control.set_state <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#002#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "AEB_RESET" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_control.aeb_reset <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#003#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_control.reserved_1 <= avalon_mm_rmap_i.writedata(3 downto 0);
    end if;

  when (16#004#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_DATA_RD" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_control.adc_data_rd <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#005#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_CFG_WR" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_control.adc_cfg_wr <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#006#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_CFG_RD" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_control.adc_cfg_rd <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#007#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "DAC_WR" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_control.dac_wr <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#008#) =>
      -- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_control.reserved_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_control.reserved_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;

  when (16#009#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config.reserved_0 <= avalon_mm_rmap_i.writedata(5 downto 0);
    end if;

  when (16#00A#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG" : "WATCH-DOG_DIS" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config.watchdog_dis <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#00B#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG" : "INT_SYNC" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config.int_sync <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#00C#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config.reserved_1 <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#00D#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP_CDS_EN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config.vasp_cds_en <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#00E#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP2_CAL_EN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config.vasp2_cal_en <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#00F#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP1_CAL_EN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config.vasp1_cal_en <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#010#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config.reserved_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config.reserved_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;

  when (16#011#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_key.key(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_key.key(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_key.key(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_key.key(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#012#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_SW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.override_sw <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#013#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.reserved_0 <= avalon_mm_rmap_i.writedata(1 downto 0);
    end if;

  when (16#014#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN3" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_van3 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#015#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_van2 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#016#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_van1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#017#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VCLK" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_vclk <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#018#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VCCD" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.sw_vccd <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#019#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_VASP" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.override_vasp <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#01A#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.reserved_1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#01B#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_PIX_EN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp2_pix_en <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#01C#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_PIX_EN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp1_pix_en <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#01D#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_ADC_EN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp2_adc_en <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#01E#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_ADC_EN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp1_adc_en <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#01F#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_RESET" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp2_reset <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#020#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_RESET" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.vasp1_reset <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#021#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_ADC" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.override_adc <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#022#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC2_EN_P5V0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc2_en_p5v0 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#023#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC1_EN_P5V0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc1_en_p5v0 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#024#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "PT1000_CAL_ON_N" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.pt1000_cal_on_n <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#025#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "EN_V_MUX_N" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.en_v_mux_n <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#026#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC2_PWDN_N" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc2_pwdn_n <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#027#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC1_PWDN_N" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc1_pwdn_n <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#028#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC_CLK_EN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.adc_clk_en <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#029#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_ait.reserved_2 <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;

  when (16#02A#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_CCDID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_ccdid <= avalon_mm_rmap_i.writedata(1 downto 0);
    end if;
      -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_COLS" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_cols(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_cols(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
    end if;

  when (16#02B#) =>
      -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "RESERVED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.reserved <= avalon_mm_rmap_i.writedata(1 downto 0);
    end if;
      -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_ROWS" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_rows(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_aeb_config_pattern.pattern_rows(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
    end if;

  when (16#02C#) =>
      -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP_CFG_ADDR" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp_cfg_addr <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
      -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP1_CFG_DATA" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp1_cfg_data <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
      -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP2_CFG_DATA" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp2_cfg_data <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
      -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "RESERVED" Field
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.reserved <= avalon_mm_rmap_i.writedata(26 downto 24);
    end if;

  when (16#02D#) =>
      -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP2_SELECT" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp2_select <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#02E#) =>
      -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP1_SELECT" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.vasp1_select <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#02F#) =>
      -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "CALIBRATION_START" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.calibration_start <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#030#) =>
      -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "I2C_READ_START" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.i2c_read_start <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#031#) =>
      -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "I2C_WRITE_START" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_vasp_i2c_control.i2c_write_start <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#032#) =>
      -- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.reserved_0 <= avalon_mm_rmap_i.writedata(3 downto 0);
    end if;
      -- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VOG" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.dac_vog(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.dac_vog(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
    end if;

  when (16#033#) =>
      -- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.reserved_1 <= avalon_mm_rmap_i.writedata(3 downto 0);
    end if;
      -- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VRD" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.dac_vrd(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_dac_config_1.dac_vrd(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
    end if;

  when (16#034#) =>
      -- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.reserved_0 <= avalon_mm_rmap_i.writedata(3 downto 0);
    end if;
      -- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "DAC_VOD" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.dac_vod(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.dac_vod(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
    end if;

  when (16#035#) =>
      -- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.reserved_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_dac_config_2.reserved_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;

  when (16#036#) =>
      -- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_reserved_20.reserved(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_reserved_20.reserved(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_reserved_20.reserved(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_reserved_20.reserved(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#037#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCCD_ON" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_pwr_config1.time_vccd_on <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
      -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCLK_ON" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_pwr_config1.time_vclk_on <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
      -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN1_ON" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_pwr_config1.time_van1_on <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
      -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN2_ON" Field
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_pwr_config1.time_van2_on <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#038#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN3_ON" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_pwr_config2.time_van3_on <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
      -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCCD_OFF" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_pwr_config2.time_vccd_off <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
      -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCLK_OFF" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_pwr_config2.time_vclk_off <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
      -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN1_OFF" Field
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_pwr_config2.time_van1_off <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#039#) =>
      -- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN2_OFF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_pwr_config3.time_van2_off <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
      -- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN3_OFF" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_crit_cfg_pwr_config3.time_van3_off <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;

  when (16#03A#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.reserved_0 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#03B#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "SPIRST" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.spirst <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#03C#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "MUXMOD" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.muxmod <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#03D#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "BYPAS" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.bypas <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#03E#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "CLKENB" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.clkenb <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#03F#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "CHOP" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.chop <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#040#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "STAT" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.stat <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#041#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.reserved_1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#042#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "IDLMOD" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.idlmod <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#043#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.dly <= avalon_mm_rmap_i.writedata(2 downto 0);
    end if;
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "SBCS" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.sbcs <= avalon_mm_rmap_i.writedata(9 downto 8);
    end if;
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DRATE" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.drate <= avalon_mm_rmap_i.writedata(17 downto 16);
    end if;
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "AINP" Field
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.ainp <= avalon_mm_rmap_i.writedata(27 downto 24);
    end if;

  when (16#044#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "AINN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.ainn <= avalon_mm_rmap_i.writedata(3 downto 0);
    end if;
      -- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DIFF" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.diff <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;

  when (16#045#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN7" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain7 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#046#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN6" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain6 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#047#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN5" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain5 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#048#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN4" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain4 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#049#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN3" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain3 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#04A#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain2 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#04B#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#04C#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain0 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#04D#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN15" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain15 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#04E#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN14" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain14 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#04F#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN13" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain13 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#050#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN12" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain12 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#051#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN11" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain11 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#052#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN10" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain10 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#053#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN9" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain9 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#054#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN8" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ain8 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#055#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.reserved_0 <= avalon_mm_rmap_i.writedata(1 downto 0);
    end if;

  when (16#056#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "REF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.ref <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#057#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "GAIN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.gain <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#058#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "TEMP" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.temp <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#059#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "VCC" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.vcc <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#05A#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.reserved_1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#05B#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "OFFSET" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.offset <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#05C#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO7" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio7 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#05D#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO6" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio6 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#05E#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO5" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio5 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#05F#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO4" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio4 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#060#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO3" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio3 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#061#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio2 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#062#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#063#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.cio0 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#064#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO7" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio7 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#065#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO6" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio6 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#066#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO5" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio5 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#067#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO4" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio4 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#068#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO3" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio3 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#069#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio2 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#06A#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#06B#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.dio0 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#06C#) =>
      -- AEB General Configuration Area Register "ADC1_CONFIG_3" : "RESERVED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.reserved(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.reserved(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.reserved(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#06D#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.reserved_0 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#06E#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "SPIRST" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.spirst <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#06F#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "MUXMOD" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.muxmod <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#070#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "BYPAS" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.bypas <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#071#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "CLKENB" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.clkenb <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#072#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "CHOP" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.chop <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#073#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "STAT" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.stat <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#074#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.reserved_1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#075#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "IDLMOD" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.idlmod <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#076#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.dly <= avalon_mm_rmap_i.writedata(2 downto 0);
    end if;
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "SBCS" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.sbcs <= avalon_mm_rmap_i.writedata(9 downto 8);
    end if;
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DRATE" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.drate <= avalon_mm_rmap_i.writedata(17 downto 16);
    end if;
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "AINP" Field
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.ainp <= avalon_mm_rmap_i.writedata(27 downto 24);
    end if;

  when (16#077#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "AINN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.ainn <= avalon_mm_rmap_i.writedata(3 downto 0);
    end if;
      -- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DIFF" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.diff <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;

  when (16#078#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN7" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain7 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#079#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN6" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain6 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#07A#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN5" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain5 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#07B#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN4" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain4 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#07C#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN3" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain3 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#07D#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain2 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#07E#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#07F#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain0 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#080#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN15" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain15 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#081#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN14" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain14 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#082#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN13" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain13 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#083#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN12" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain12 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#084#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN11" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain11 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#085#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN10" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain10 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#086#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN9" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain9 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#087#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN8" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ain8 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#088#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.reserved_0 <= avalon_mm_rmap_i.writedata(1 downto 0);
    end if;

  when (16#089#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "REF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.ref <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#08A#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "GAIN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.gain <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#08B#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "TEMP" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.temp <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#08C#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "VCC" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.vcc <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#08D#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.reserved_1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#08E#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "OFFSET" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.offset <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#08F#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO7" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio7 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#090#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO6" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio6 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#091#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO5" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio5 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#092#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO4" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio4 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#093#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO3" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio3 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#094#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio2 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#095#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#096#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.cio0 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#097#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO7" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio7 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#098#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO6" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio6 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#099#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO5" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio5 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#09A#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO4" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio4 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#09B#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO3" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio3 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#09C#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio2 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#09D#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#09E#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.dio0 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#09F#) =>
      -- AEB General Configuration Area Register "ADC2_CONFIG_3" : "RESERVED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.reserved(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.reserved(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.reserved(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#0A0#) =>
      -- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_reserved_118.reserved(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_reserved_118.reserved(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_reserved_118.reserved(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_reserved_118.reserved(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#0A1#) =>
      -- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_reserved_11c.reserved(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_reserved_11c.reserved(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_reserved_11c.reserved(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_reserved_11c.reserved(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#0A2#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.reserved_0 <= avalon_mm_rmap_i.writedata(1 downto 0);
    end if;

  when (16#0A3#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_CCD_ENABLE" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_ccd_enable <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0A4#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPARE" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_spare <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0A5#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TSTLINE" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_tstline <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0A6#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TSTFRM" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_tstfrm <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0A7#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_VASPCLAMP" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_vaspclamp <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0A8#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_PRECLAMP" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_preclamp <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0A9#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IG" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_ig <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0AA#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TG" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_tg <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0AB#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_DG" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_dg <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0AC#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHIR" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_rphir <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0AD#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sw <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0AE#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI3" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_rphi3 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0AF#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_rphi2 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0B0#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_rphi1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0B1#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI4" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sphi4 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0B2#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI3" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sphi3 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0B3#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sphi2 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0B4#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_sphi1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0B5#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI4" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_iphi4 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0B6#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI3" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_iphi3 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0B7#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_iphi2 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0B8#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.seq_oe_iphi1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0B9#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.reserved_1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0BA#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "ADC_CLK_DIV" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_1.adc_clk_div <= avalon_mm_rmap_i.writedata(6 downto 0);
    end if;

  when (16#0BB#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_2" : "ADC_CLK_LOW_POS" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_2.adc_clk_low_pos <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_2" : "ADC_CLK_HIGH_POS" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_2.adc_clk_high_pos <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_2" : "CDS_CLK_LOW_POS" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_2.cds_clk_low_pos <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_2" : "CDS_CLK_HIGH_POS" Field
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_2.cds_clk_high_pos <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#0BC#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHIR_CLK_LOW_POS" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_3.rphir_clk_low_pos <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHIR_CLK_HIGH_POS" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_3.rphir_clk_high_pos <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHI1_CLK_LOW_POS" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_3.rphi1_clk_low_pos <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHI1_CLK_HIGH_POS" Field
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_3.rphi1_clk_high_pos <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#0BD#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI2_CLK_LOW_POS" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_4.rphi2_clk_low_pos <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI2_CLK_HIGH_POS" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_4.rphi2_clk_high_pos <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI3_CLK_LOW_POS" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_4.rphi3_clk_low_pos <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI3_CLK_HIGH_POS" Field
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_4.rphi3_clk_high_pos <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#0BE#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_5" : "SW_CLK_LOW_POS" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.sw_clk_low_pos <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_5" : "SW_CLK_HIGH_POS" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.sw_clk_high_pos <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;

  when (16#0BF#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_5" : "VASP_OUT_CTRL" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.vasp_out_ctrl <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0C0#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_5" : "RESERVED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.reserved <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0C1#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_5" : "VASP_OUT_EN_POS" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.vasp_out_en_pos(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_5.vasp_out_en_pos(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
    end if;

  when (16#0C2#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_6" : "VASP_OUT_CTRL_INV" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.vasp_out_ctrl_inv <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0C3#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.reserved_0 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0C4#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_6" : "VASP_OUT_DIS_POS" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.vasp_out_dis_pos(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.vasp_out_dis_pos(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.reserved_1(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_6.reserved_1(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#0C5#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_7.reserved(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_7.reserved(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_7.reserved(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_7.reserved(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#0C6#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_8.reserved(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_8.reserved(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_8.reserved(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_8.reserved(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#0C7#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.reserved_0 <= avalon_mm_rmap_i.writedata(1 downto 0);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "FT_LOOP_CNT" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.ft_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.ft_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
    end if;

  when (16#0C8#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_ENABLED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.lt0_enabled <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0C9#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.reserved_1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0CA#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_LOOP_CNT" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.lt0_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_9.lt0_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
    end if;

  when (16#0CB#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_ENABLED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt1_enabled <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0CC#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.reserved_0 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0CD#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_LOOP_CNT" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt1_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt1_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
    end if;

  when (16#0CE#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_ENABLED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt2_enabled <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0CF#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.reserved_1 <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0D0#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_LOOP_CNT" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt2_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_10.lt2_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
    end if;

  when (16#0D1#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_ENABLED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.lt3_enabled <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0D2#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "RESERVED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.reserved <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0D3#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_LOOP_CNT" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.lt3_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.lt3_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "PIX_LOOP_CNT_WORD_1" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.pix_loop_cnt_word_1(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_11.pix_loop_cnt_word_1(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#0D4#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PIX_LOOP_CNT_WORD_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pix_loop_cnt_word_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pix_loop_cnt_word_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;

  when (16#0D5#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_ENABLED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pc_enabled <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0D6#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "RESERVED" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.reserved <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0D7#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_LOOP_CNT" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pc_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_12.pc_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
    end if;

  when (16#0D8#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.reserved_0 <= avalon_mm_rmap_i.writedata(1 downto 0);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT1_LOOP_CNT" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.int1_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.int1_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
    end if;

  when (16#0D9#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.reserved_1 <= avalon_mm_rmap_i.writedata(1 downto 0);
    end if;
      -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT2_LOOP_CNT" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.int2_loop_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_13.int2_loop_cnt(13 downto 8) <= avalon_mm_rmap_i.writedata(29 downto 24);
    end if;

  when (16#0DA#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.reserved_0 <= avalon_mm_rmap_i.writedata(6 downto 0);
    end if;

  when (16#0DB#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_14" : "SPHI_INV" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.sphi_inv <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0DC#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.reserved_1 <= avalon_mm_rmap_i.writedata(6 downto 0);
    end if;

  when (16#0DD#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RPHI_INV" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.rphi_inv <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0DE#) =>
      -- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_2" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.reserved_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_gen_cfg_seq_config_14.reserved_2(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;

  when (16#0DF#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "AEB_STATUS" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.aeb_status <= avalon_mm_rmap_i.writedata(3 downto 0);
    end if;

  when (16#0E0#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "VASP2_CFG_RUN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.vasp2_cfg_run <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0E1#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "VASP1_CFG_RUN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.vasp1_cfg_run <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0E2#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "DAC_CFG_WR_RUN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.dac_cfg_wr_run <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0E3#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_RD_RUN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.adc_cfg_rd_run <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0E4#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_WR_RUN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.adc_cfg_wr_run <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0E5#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_DAT_RD_RUN" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.adc_dat_rd_run <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0E6#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_ERROR" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.adc_error <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0E7#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "ADC2_LU" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.adc2_lu <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0E8#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "ADC1_LU" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.adc1_lu <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0E9#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_DAT_RD" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.adc_dat_rd <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0EA#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_RD" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.adc_cfg_rd <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0EB#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_WR" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.adc_cfg_wr <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0EC#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "ADC2_BUSY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.adc2_busy <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0ED#) =>
      -- AEB Housekeeping Area Register "AEB_STATUS" : "ADC1_BUSY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_aeb_status.adc1_busy <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0EE#) =>
      -- AEB Housekeeping Area Register "TIMESTAMP_1" : "TIMESTAMP_DWORD_1" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_timestamp_1.timestamp_dword_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_timestamp_1.timestamp_dword_1(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_timestamp_1.timestamp_dword_1(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_hk_timestamp_1.timestamp_dword_1(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#0EF#) =>
      -- AEB Housekeeping Area Register "TIMESTAMP_2" : "TIMESTAMP_DWORD_0" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_timestamp_2.timestamp_dword_0(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_timestamp_2.timestamp_dword_0(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_timestamp_2.timestamp_dword_0(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_hk_timestamp_2.timestamp_dword_0(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#0F0#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_l.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0F1#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_l.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0F2#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_l.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0F3#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_l.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#0F4#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "ADC_CHX_DATA_T_VASP_L" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_l.adc_chx_data_t_vasp_l(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_l.adc_chx_data_t_vasp_l(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_l.adc_chx_data_t_vasp_l(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#0F5#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_r.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0F6#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_r.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0F7#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_r.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0F8#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_r.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#0F9#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "ADC_CHX_DATA_T_VASP_R" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_r.adc_chx_data_t_vasp_r(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_r.adc_chx_data_t_vasp_r(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_vasp_r.adc_chx_data_t_vasp_r(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#0FA#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_bias_p.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0FB#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_bias_p.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0FC#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_bias_p.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#0FD#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_bias_p.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#0FE#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "ADC_CHX_DATA_T_BIAS_P" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_bias_p.adc_chx_data_t_bias_p(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_bias_p.adc_chx_data_t_bias_p(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_bias_p.adc_chx_data_t_bias_p(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#0FF#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_hk_p.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#100#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_hk_p.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#101#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_hk_p.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#102#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_hk_p.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#103#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "ADC_CHX_DATA_T_HK_P" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_hk_p.adc_chx_data_t_hk_p(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_hk_p.adc_chx_data_t_hk_p(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_hk_p.adc_chx_data_t_hk_p(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#104#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_1_p.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#105#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_1_p.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#106#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_1_p.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#107#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_1_p.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#108#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "ADC_CHX_DATA_T_TOU_1_P" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_1_p.adc_chx_data_t_tou_1_p(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_1_p.adc_chx_data_t_tou_1_p(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_1_p.adc_chx_data_t_tou_1_p(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#109#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_2_p.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#10A#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_2_p.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#10B#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_2_p.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#10C#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_2_p.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#10D#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "ADC_CHX_DATA_T_TOU_2_P" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_2_p.adc_chx_data_t_tou_2_p(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_2_p.adc_chx_data_t_tou_2_p(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_tou_2_p.adc_chx_data_t_tou_2_p(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#10E#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vode.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#10F#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vode.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#110#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vode.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#111#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vode.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#112#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "ADC_CHX_DATA_HK_VODE" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vode.adc_chx_data_hk_vode(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vode.adc_chx_data_hk_vode(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vode.adc_chx_data_hk_vode(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#113#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vodf.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#114#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vodf.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#115#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vodf.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#116#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vodf.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#117#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "ADC_CHX_DATA_HK_VODF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vodf.adc_chx_data_hk_vodf(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vodf.adc_chx_data_hk_vodf(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vodf.adc_chx_data_hk_vodf(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#118#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vrd.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#119#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vrd.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#11A#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vrd.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#11B#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vrd.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#11C#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "ADC_CHX_DATA_HK_VRD" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vrd.adc_chx_data_hk_vrd(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vrd.adc_chx_data_hk_vrd(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vrd.adc_chx_data_hk_vrd(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#11D#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vog.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#11E#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vog.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#11F#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vog.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#120#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vog.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#121#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "ADC_CHX_DATA_HK_VOG" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vog.adc_chx_data_hk_vog(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vog.adc_chx_data_hk_vog(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_vog.adc_chx_data_hk_vog(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#122#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ccd.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#123#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ccd.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#124#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ccd.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#125#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ccd.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#126#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "ADC_CHX_DATA_T_CCD" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ccd.adc_chx_data_t_ccd(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ccd.adc_chx_data_t_ccd(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ccd.adc_chx_data_t_ccd(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#127#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref1k_mea.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#128#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref1k_mea.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#129#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref1k_mea.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#12A#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref1k_mea.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#12B#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "ADC_CHX_DATA_T_REF1K_MEA" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref1k_mea.adc_chx_data_t_ref1k_mea(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref1k_mea.adc_chx_data_t_ref1k_mea(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref1k_mea.adc_chx_data_t_ref1k_mea(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#12C#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref649r_mea.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#12D#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref649r_mea.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#12E#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref649r_mea.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#12F#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref649r_mea.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#130#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "ADC_CHX_DATA_T_REF649R_MEA" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref649r_mea.adc_chx_data_t_ref649r_mea(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref649r_mea.adc_chx_data_t_ref649r_mea(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_t_ref649r_mea.adc_chx_data_t_ref649r_mea(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#131#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_n5v.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#132#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_n5v.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#133#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_n5v.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#134#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_n5v.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#135#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "ADC_CHX_DATA_HK_ANA_N5V" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_n5v.adc_chx_data_hk_ana_n5v(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_n5v.adc_chx_data_hk_ana_n5v(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_n5v.adc_chx_data_hk_ana_n5v(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#136#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_s_ref.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#137#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_s_ref.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#138#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_s_ref.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#139#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_s_ref.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#13A#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "ADC_CHX_DATA_S_REF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_s_ref.adc_chx_data_s_ref(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_s_ref.adc_chx_data_s_ref(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_s_ref.adc_chx_data_s_ref(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#13B#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ccd_p31v.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#13C#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ccd_p31v.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#13D#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ccd_p31v.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#13E#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ccd_p31v.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#13F#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "ADC_CHX_DATA_HK_CCD_P31V" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ccd_p31v.adc_chx_data_hk_ccd_p31v(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ccd_p31v.adc_chx_data_hk_ccd_p31v(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ccd_p31v.adc_chx_data_hk_ccd_p31v(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#140#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_clk_p15v.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#141#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_clk_p15v.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#142#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_clk_p15v.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#143#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_clk_p15v.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#144#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "ADC_CHX_DATA_HK_CLK_P15V" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_clk_p15v.adc_chx_data_hk_clk_p15v(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_clk_p15v.adc_chx_data_hk_clk_p15v(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_clk_p15v.adc_chx_data_hk_clk_p15v(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#145#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p5v.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#146#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p5v.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#147#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p5v.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#148#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p5v.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#149#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "ADC_CHX_DATA_HK_ANA_P5V" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p5v.adc_chx_data_hk_ana_p5v(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p5v.adc_chx_data_hk_ana_p5v(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p5v.adc_chx_data_hk_ana_p5v(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#14A#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p3v3.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#14B#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p3v3.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#14C#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p3v3.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#14D#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p3v3.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#14E#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "ADC_CHX_DATA_HK_ANA_P3V3" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p3v3.adc_chx_data_hk_ana_p3v3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p3v3.adc_chx_data_hk_ana_p3v3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_ana_p3v3.adc_chx_data_hk_ana_p3v3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#14F#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_dig_p3v3.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#150#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_dig_p3v3.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#151#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_dig_p3v3.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#152#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_dig_p3v3.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;

  when (16#153#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "ADC_CHX_DATA_HK_DIG_P3V3" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_dig_p3v3.adc_chx_data_hk_dig_p3v3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_dig_p3v3.adc_chx_data_hk_dig_p3v3(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_hk_dig_p3v3.adc_chx_data_hk_dig_p3v3(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;

  when (16#154#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "NEW" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_adc_ref_buf_2.new_data <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#155#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "OVF" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_adc_ref_buf_2.ovf <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#156#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "SUPPLY" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_adc_ref_buf_2.supply <= avalon_mm_rmap_i.writedata(0);
    end if;

  when (16#157#) =>
      -- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "CHID" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_adc_ref_buf_2.chid <= avalon_mm_rmap_i.writedata(4 downto 0);
    end if;
      -- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "ADC_CHX_DATA_ADC_REF_BUF_2" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_adc_rd_data_adc_ref_buf_2.adc_chx_data_adc_ref_buf_2 <= avalon_mm_rmap_i.writedata(11 downto 8);
    end if;

  when (16#1DE#) =>
      -- AEB Housekeeping Area Register "VASP_RD_CONFIG" : "VASP1_READ_DATA" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_vasp_rd_config.vasp1_read_data <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
      -- AEB Housekeeping Area Register "VASP_RD_CONFIG" : "VASP2_READ_DATA" Field
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_vasp_rd_config.vasp2_read_data <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
      -- AEB Housekeeping Area Register "REVISION_ID_1" : "FPGA_VERSION" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_revision_id_1.fpga_version(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_hk_revision_id_1.fpga_version(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#1DF#) =>
      -- AEB Housekeeping Area Register "REVISION_ID_1" : "FPGA_DATE" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_revision_id_1.fpga_date(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
    if (avalon_mm_rmap_i.byteenable(1) = '1') then
      rmap_registers_wr_o.aeb_hk_revision_id_1.fpga_date(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
    end if;
      -- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_TIME_H" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_revision_id_2.fpga_time_h(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_hk_revision_id_2.fpga_time_h(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when (16#1E0#) =>
      -- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_TIME_M" Field
    if (avalon_mm_rmap_i.byteenable(0) = '1') then
      rmap_registers_wr_o.aeb_hk_revision_id_2.fpga_time_m <= avalon_mm_rmap_i.writedata(7 downto 0);
    end if;
      -- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_SVN" Field
    if (avalon_mm_rmap_i.byteenable(2) = '1') then
      rmap_registers_wr_o.aeb_hk_revision_id_2.fpga_svn(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
    end if;
    if (avalon_mm_rmap_i.byteenable(3) = '1') then
      rmap_registers_wr_o.aeb_hk_revision_id_2.fpga_svn(15 downto 8) <= avalon_mm_rmap_i.writedata(31 downto 24);
    end if;

  when others =>
  -- No register associated to the address, do nothing
    null;

end case;

		end procedure p_avs_writedata;

		variable v_fee_write_address : std_logic_vector(31 downto 0)          := (others => '0');
		variable v_avs_write_address : t_farm_avalon_mm_rmap_ffee_aeb_address := 0;
	begin
		if (rst_i = '1') then
			fee_rmap_o.waitrequest       <= '1';
			avalon_mm_rmap_o.waitrequest <= '1';
			s_data_acquired              <= '0';
			p_ffee_aeb_reg_reset;
			v_fee_write_address          := (others => '0');
			v_avs_write_address          := 0;
		elsif (rising_edge(clk_i)) then

			fee_rmap_o.waitrequest       <= '1';
			avalon_mm_rmap_o.waitrequest <= '1';
			p_ffee_aeb_reg_trigger;
			s_data_acquired              <= '0';
			if (fee_rmap_i.write = '1') then
				v_fee_write_address    := fee_rmap_i.address;
				fee_rmap_o.waitrequest <= '0';
				s_data_acquired        <= '1';
				if (s_data_acquired = '0') then
					p_ffee_aeb_mem_wr(v_fee_write_address);
				end if;
			elsif (avalon_mm_rmap_i.write = '1') then
				v_avs_write_address          := to_integer(unsigned(avalon_mm_rmap_i.address));
				avalon_mm_rmap_o.waitrequest <= '0';
				s_data_acquired              <= '1';
				if (s_data_acquired = '0') then
					p_avs_writedata(v_avs_write_address);
				end if;
			end if;

		end if;
	end process p_farm_rmap_mem_area_ffee_aeb_write;

end architecture RTL;
