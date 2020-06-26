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
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_0" Field
					fee_rmap_o.readdata(7 downto 6) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.reserved_0;

				when (x"00000001") =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "DAC_WR" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.dac_wr;
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_CFG_RD" Field
					fee_rmap_o.readdata(1)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.adc_cfg_rd;
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_CFG_WR" Field
					fee_rmap_o.readdata(2)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.adc_cfg_wr;
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_DATA_RD" Field
					fee_rmap_o.readdata(3)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.adc_data_rd;
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_1" Field
					fee_rmap_o.readdata(7 downto 4) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.reserved_1;

				when (x"00000002") =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_2" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.reserved_2(15 downto 8);

				when (x"00000003") =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_2" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.reserved_2(7 downto 0);

				when (x"00000004") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "INT_SYNC" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.int_sync;
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "WATCH-DOG_DIS" Field
					fee_rmap_o.readdata(1)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.watchdog_dis;
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_0" Field
					fee_rmap_o.readdata(7 downto 2) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.reserved_0;

				when (x"00000005") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP1_CAL_EN" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.vasp1_cal_en;
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP2_CAL_EN" Field
					fee_rmap_o.readdata(1)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.vasp2_cal_en;
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP_CDS_EN" Field
					fee_rmap_o.readdata(2)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.vasp_cds_en;
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_1" Field
					fee_rmap_o.readdata(7 downto 3) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.reserved_1;

				when (x"00000006") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_2" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.reserved_2(15 downto 8);

				when (x"00000007") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_2" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.reserved_2(7 downto 0);

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
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VCCD" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.sw_vccd;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VCLK" Field
					fee_rmap_o.readdata(1)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.sw_vclk;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN1" Field
					fee_rmap_o.readdata(2)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.sw_van1;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN2" Field
					fee_rmap_o.readdata(3)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.sw_van2;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN3" Field
					fee_rmap_o.readdata(4)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.sw_van3;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_0" Field
					fee_rmap_o.readdata(6 downto 5) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.reserved_0;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_SW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.override_sw;

				when (x"0000000D") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_RESET" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.vasp1_reset;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_RESET" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.vasp2_reset;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_ADC_EN" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.vasp1_adc_en;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_ADC_EN" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.vasp2_adc_en;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_PIX_EN" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.vasp1_pix_en;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_PIX_EN" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.vasp2_pix_en;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_1" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.reserved_1;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_VASP" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.override_vasp;

				when (x"0000000E") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC_CLK_EN" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.adc_clk_en;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC1_PWDN_N" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.adc1_pwdn_n;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC2_PWDN_N" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.adc2_pwdn_n;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "EN_V_MUX_N" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.en_v_mux_n;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "PT1000_CAL_ON_N" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.pt1000_cal_on_n;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC1_EN_P5V0" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.adc1_en_p5v0;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC2_EN_P5V0" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.adc2_en_p5v0;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_ADC" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.override_adc;

				when (x"0000000F") =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_2" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.reserved_2;

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
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP_CFG_ADDR" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.vasp_cfg_addr;

				when (x"00000015") =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP1_CFG_DATA" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.vasp1_cfg_data;

				when (x"00000016") =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP2_CFG_DATA" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.vasp2_cfg_data;

				when (x"00000017") =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "I2C_WRITE_START" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.i2c_write_start;
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "I2C_READ_START" Field
					fee_rmap_o.readdata(1)          <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.i2c_read_start;
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "CALIBRATION_START" Field
					fee_rmap_o.readdata(2)          <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.calibration_start;
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP1_SELECT" Field
					fee_rmap_o.readdata(3)          <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.vasp1_select;
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP2_SELECT" Field
					fee_rmap_o.readdata(4)          <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.vasp2_select;
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "RESERVED" Field
					fee_rmap_o.readdata(7 downto 5) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.reserved;

				when (x"00000018") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VOG" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.dac_vog(11 downto 8);
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "RESERVED_0" Field
					fee_rmap_o.readdata(7 downto 4) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.reserved_0;

				when (x"00000019") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VOG" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.dac_vog(7 downto 0);

				when (x"0000001A") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VRD" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.dac_vrd(11 downto 8);
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "RESERVED_1" Field
					fee_rmap_o.readdata(7 downto 4) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.reserved_1;

				when (x"0000001B") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VRD" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.dac_vrd(7 downto 0);

				when (x"0000001C") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "DAC_VOD" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.dac_vod(11 downto 8);
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "RESERVED_0" Field
					fee_rmap_o.readdata(7 downto 4) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.reserved_0;

				when (x"0000001D") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "DAC_VOD" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.dac_vod(7 downto 0);

				when (x"0000001E") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "RESERVED_1" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.reserved_1(15 downto 8);

				when (x"0000001F") =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "RESERVED_1" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.reserved_1(7 downto 0);

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
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "RESERVED_1" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.reserved_1;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "STAT" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.stat;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "CHOP" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.chop;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "CLKENB" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.clkenb;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "BYPAS" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.bypas;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "MUXMOD" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.muxmod;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "SPIRST" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.spirst;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "RESERVED_0" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.reserved_0;

				when (x"00000101") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DRATE" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.drate;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "SBCS" Field
					fee_rmap_o.readdata(3 downto 2) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.sbcs;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DLY" Field
					fee_rmap_o.readdata(6 downto 4) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.dly;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "IDLMOD" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.idlmod;

				when (x"00000102") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "AINN" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.ainn;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "AINP" Field
					fee_rmap_o.readdata(7 downto 4) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.ainp;

				when (x"00000103") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DIFF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.diff;

				when (x"00000104") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain0;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain1;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain2;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain3;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain4;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain5;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain6;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain7;

				when (x"00000105") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN8" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain8;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN9" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain9;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN10" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain10;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN11" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain11;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN12" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain12;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN13" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain13;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN14" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain14;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN15" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain15;

				when (x"00000106") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "OFFSET" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.offset;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "RESERVED_1" Field
					fee_rmap_o.readdata(1)          <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.reserved_1;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "VCC" Field
					fee_rmap_o.readdata(2)          <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.vcc;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "TEMP" Field
					fee_rmap_o.readdata(3)          <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.temp;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "GAIN" Field
					fee_rmap_o.readdata(4)          <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.gain;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "REF" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ref;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "RESERVED_0" Field
					fee_rmap_o.readdata(7 downto 6) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.reserved_0;

				when (x"00000107") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio0;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio1;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio2;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio3;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio4;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio5;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio6;
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio7;

				when (x"00000108") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio0;
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio1;
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio2;
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio3;
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio4;
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio5;
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio6;
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio7;

				when (x"00000109") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.reserved(23 downto 16);

				when (x"0000010A") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.reserved(15 downto 8);

				when (x"0000010B") =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.reserved(7 downto 0);

				when (x"0000010C") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "RESERVED_1" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.reserved_1;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "STAT" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.stat;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "CHOP" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.chop;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "CLKENB" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.clkenb;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "BYPAS" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.bypas;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "MUXMOD" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.muxmod;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "SPIRST" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.spirst;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "RESERVED_0" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.reserved_0;

				when (x"0000010D") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DRATE" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.drate;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "SBCS" Field
					fee_rmap_o.readdata(3 downto 2) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.sbcs;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DLY" Field
					fee_rmap_o.readdata(6 downto 4) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.dly;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "IDLMOD" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.idlmod;

				when (x"0000010E") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "AINN" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.ainn;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "AINP" Field
					fee_rmap_o.readdata(7 downto 4) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.ainp;

				when (x"0000010F") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DIFF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.diff;

				when (x"00000110") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain0;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain1;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain2;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain3;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain4;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain5;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain6;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain7;

				when (x"00000111") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN8" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain8;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN9" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain9;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN10" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain10;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN11" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain11;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN12" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain12;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN13" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain13;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN14" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain14;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN15" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain15;

				when (x"00000112") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "OFFSET" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.offset;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "RESERVED_1" Field
					fee_rmap_o.readdata(1)          <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.reserved_1;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "VCC" Field
					fee_rmap_o.readdata(2)          <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.vcc;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "TEMP" Field
					fee_rmap_o.readdata(3)          <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.temp;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "GAIN" Field
					fee_rmap_o.readdata(4)          <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.gain;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "REF" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ref;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "RESERVED_0" Field
					fee_rmap_o.readdata(7 downto 6) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.reserved_0;

				when (x"00000113") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio0;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio1;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio2;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio3;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio4;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio5;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio6;
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio7;

				when (x"00000114") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio0;
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio1;
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio2;
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio3;
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio4;
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio5;
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio6;
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio7;

				when (x"00000115") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.reserved(23 downto 16);

				when (x"00000116") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.reserved(15 downto 8);

				when (x"00000117") =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.reserved(7 downto 0);

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
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_PRECLAMP" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_preclamp;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_VASPCLAMP" Field
					fee_rmap_o.readdata(1)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_vaspclamp;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TSTFRM" Field
					fee_rmap_o.readdata(2)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_tstfrm;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TSTLINE" Field
					fee_rmap_o.readdata(3)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_tstline;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPARE" Field
					fee_rmap_o.readdata(4)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_spare;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_CCD_ENABLE" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_ccd_enable;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED_0" Field
					fee_rmap_o.readdata(7 downto 6) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.reserved_0;

				when (x"00000121") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI1" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_rphi1;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI2" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_rphi2;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI3" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_rphi3;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SW" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_sw;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHIR" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_rphir;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_DG" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_dg;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TG" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_tg;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IG" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_ig;

				when (x"00000122") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI1" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_iphi1;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI2" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_iphi2;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI3" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_iphi3;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI4" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_iphi4;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI1" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_sphi1;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI2" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_sphi2;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI3" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_sphi3;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI4" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_sphi4;

				when (x"00000123") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "ADC_CLK_DIV" Field
					fee_rmap_o.readdata(6 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.adc_clk_div;
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED_1" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.reserved_1;

				when (x"00000124") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "ADC_CLK_LOW_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.adc_clk_low_pos;

				when (x"00000125") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "ADC_CLK_HIGH_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.adc_clk_high_pos;

				when (x"00000126") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "CDS_CLK_LOW_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.cds_clk_low_pos;

				when (x"00000127") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "CDS_CLK_HIGH_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.cds_clk_high_pos;

				when (x"00000128") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHIR_CLK_LOW_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.rphir_clk_low_pos;

				when (x"00000129") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHIR_CLK_HIGH_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.rphir_clk_high_pos;

				when (x"0000012A") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHI1_CLK_LOW_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.rphi1_clk_low_pos;

				when (x"0000012B") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHI1_CLK_HIGH_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.rphi1_clk_high_pos;

				when (x"0000012C") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI2_CLK_LOW_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.rphi2_clk_low_pos;

				when (x"0000012D") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI2_CLK_HIGH_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.rphi2_clk_high_pos;

				when (x"0000012E") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI3_CLK_LOW_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.rphi3_clk_low_pos;

				when (x"0000012F") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI3_CLK_HIGH_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.rphi3_clk_high_pos;

				when (x"00000130") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "SW_CLK_LOW_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.sw_clk_low_pos;

				when (x"00000131") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "SW_CLK_HIGH_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.sw_clk_high_pos;

				when (x"00000132") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "VASP_OUT_EN_POS" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.vasp_out_en_pos(13 downto 8);
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "RESERVED" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.reserved;
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "VASP_OUT_CTRL" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.vasp_out_ctrl;

				when (x"00000133") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "VASP_OUT_EN_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.vasp_out_en_pos(7 downto 0);

				when (x"00000134") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "VASP_OUT_DIS_POS" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.vasp_out_dis_pos(13 downto 8);
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_0" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.reserved_0;
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "VASP_OUT_CTRL_INV" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.vasp_out_ctrl_inv;

				when (x"00000135") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "VASP_OUT_DIS_POS" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.vasp_out_dis_pos(7 downto 0);

				when (x"00000136") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_1" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.reserved_1(15 downto 8);

				when (x"00000137") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_1" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.reserved_1(7 downto 0);

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
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "SPHI_INV" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.sphi_inv;
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_0" Field
					fee_rmap_o.readdata(7 downto 1) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.reserved_0;

				when (x"00000155") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RPHI_INV" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.rphi_inv;
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_1" Field
					fee_rmap_o.readdata(7 downto 1) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.reserved_1;

				when (x"00000156") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_2" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.reserved_2(15 downto 8);

				when (x"00000157") =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_2" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.reserved_2(7 downto 0);

				when (x"00001000") =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "AEB_STATUS" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_hk_aeb_status.aeb_status;

				when (x"00001001") =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_DAT_RD_RUN" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_dat_rd_run;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_WR_RUN" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_cfg_wr_run;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_RD_RUN" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_cfg_rd_run;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "DAC_CFG_WR_RUN" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_aeb_status.dac_cfg_wr_run;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "VASP1_CFG_RUN" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_aeb_status.vasp1_cfg_run;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "VASP2_CFG_RUN" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_aeb_status.vasp2_cfg_run;

				when (x"00001002") =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC1_BUSY" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc1_busy;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC2_BUSY" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc2_busy;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_WR" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_cfg_wr;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_RD" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_cfg_rd;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_DAT_RD" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_dat_rd;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC1_LU" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc1_lu;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC2_LU" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc2_lu;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_ERROR" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_error;

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
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.new_data;

				when (x"00001011") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "ADC_CHX_DATA_T_VASP_L" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.adc_chx_data_t_vasp_l(23 downto 16);

				when (x"00001012") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "ADC_CHX_DATA_T_VASP_L" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.adc_chx_data_t_vasp_l(15 downto 8);

				when (x"00001013") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "ADC_CHX_DATA_T_VASP_L" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.adc_chx_data_t_vasp_l(7 downto 0);

				when (x"00001014") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.new_data;

				when (x"00001015") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "ADC_CHX_DATA_T_VASP_R" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.adc_chx_data_t_vasp_r(23 downto 16);

				when (x"00001016") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "ADC_CHX_DATA_T_VASP_R" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.adc_chx_data_t_vasp_r(15 downto 8);

				when (x"00001017") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "ADC_CHX_DATA_T_VASP_R" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.adc_chx_data_t_vasp_r(7 downto 0);

				when (x"00001018") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.new_data;

				when (x"00001019") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "ADC_CHX_DATA_T_BIAS_P" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.adc_chx_data_t_bias_p(23 downto 16);

				when (x"0000101A") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "ADC_CHX_DATA_T_BIAS_P" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.adc_chx_data_t_bias_p(15 downto 8);

				when (x"0000101B") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "ADC_CHX_DATA_T_BIAS_P" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.adc_chx_data_t_bias_p(7 downto 0);

				when (x"0000101C") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.new_data;

				when (x"0000101D") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "ADC_CHX_DATA_T_HK_P" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.adc_chx_data_t_hk_p(23 downto 16);

				when (x"0000101E") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "ADC_CHX_DATA_T_HK_P" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.adc_chx_data_t_hk_p(15 downto 8);

				when (x"0000101F") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "ADC_CHX_DATA_T_HK_P" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.adc_chx_data_t_hk_p(7 downto 0);

				when (x"00001020") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.new_data;

				when (x"00001021") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "ADC_CHX_DATA_T_TOU_1_P" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.adc_chx_data_t_tou_1_p(23 downto 16);

				when (x"00001022") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "ADC_CHX_DATA_T_TOU_1_P" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.adc_chx_data_t_tou_1_p(15 downto 8);

				when (x"00001023") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "ADC_CHX_DATA_T_TOU_1_P" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.adc_chx_data_t_tou_1_p(7 downto 0);

				when (x"00001024") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.new_data;

				when (x"00001025") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "ADC_CHX_DATA_T_TOU_2_P" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.adc_chx_data_t_tou_2_p(23 downto 16);

				when (x"00001026") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "ADC_CHX_DATA_T_TOU_2_P" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.adc_chx_data_t_tou_2_p(15 downto 8);

				when (x"00001027") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "ADC_CHX_DATA_T_TOU_2_P" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.adc_chx_data_t_tou_2_p(7 downto 0);

				when (x"00001028") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.new_data;

				when (x"00001029") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "ADC_CHX_DATA_HK_VODE" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.adc_chx_data_hk_vode(23 downto 16);

				when (x"0000102A") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "ADC_CHX_DATA_HK_VODE" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.adc_chx_data_hk_vode(15 downto 8);

				when (x"0000102B") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "ADC_CHX_DATA_HK_VODE" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.adc_chx_data_hk_vode(7 downto 0);

				when (x"0000102C") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.new_data;

				when (x"0000102D") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "ADC_CHX_DATA_HK_VODF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.adc_chx_data_hk_vodf(23 downto 16);

				when (x"0000102E") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "ADC_CHX_DATA_HK_VODF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.adc_chx_data_hk_vodf(15 downto 8);

				when (x"0000102F") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "ADC_CHX_DATA_HK_VODF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.adc_chx_data_hk_vodf(7 downto 0);

				when (x"00001030") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.new_data;

				when (x"00001031") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "ADC_CHX_DATA_HK_VRD" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.adc_chx_data_hk_vrd(23 downto 16);

				when (x"00001032") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "ADC_CHX_DATA_HK_VRD" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.adc_chx_data_hk_vrd(15 downto 8);

				when (x"00001033") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "ADC_CHX_DATA_HK_VRD" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.adc_chx_data_hk_vrd(7 downto 0);

				when (x"00001034") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.new_data;

				when (x"00001035") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "ADC_CHX_DATA_HK_VOG" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.adc_chx_data_hk_vog(23 downto 16);

				when (x"00001036") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "ADC_CHX_DATA_HK_VOG" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.adc_chx_data_hk_vog(15 downto 8);

				when (x"00001037") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "ADC_CHX_DATA_HK_VOG" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.adc_chx_data_hk_vog(7 downto 0);

				when (x"00001038") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.new_data;

				when (x"00001039") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "ADC_CHX_DATA_T_CCD" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.adc_chx_data_t_ccd(23 downto 16);

				when (x"0000103A") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "ADC_CHX_DATA_T_CCD" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.adc_chx_data_t_ccd(15 downto 8);

				when (x"0000103B") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "ADC_CHX_DATA_T_CCD" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.adc_chx_data_t_ccd(7 downto 0);

				when (x"0000103C") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.new_data;

				when (x"0000103D") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "ADC_CHX_DATA_T_REF1K_MEA" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.adc_chx_data_t_ref1k_mea(23 downto 16);

				when (x"0000103E") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "ADC_CHX_DATA_T_REF1K_MEA" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.adc_chx_data_t_ref1k_mea(15 downto 8);

				when (x"0000103F") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "ADC_CHX_DATA_T_REF1K_MEA" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.adc_chx_data_t_ref1k_mea(7 downto 0);

				when (x"00001040") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.new_data;

				when (x"00001041") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "ADC_CHX_DATA_T_REF649R_MEA" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.adc_chx_data_t_ref649r_mea(23 downto 16);

				when (x"00001042") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "ADC_CHX_DATA_T_REF649R_MEA" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.adc_chx_data_t_ref649r_mea(15 downto 8);

				when (x"00001043") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "ADC_CHX_DATA_T_REF649R_MEA" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.adc_chx_data_t_ref649r_mea(7 downto 0);

				when (x"00001044") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.new_data;

				when (x"00001045") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "ADC_CHX_DATA_HK_ANA_N5V" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.adc_chx_data_hk_ana_n5v(23 downto 16);

				when (x"00001046") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "ADC_CHX_DATA_HK_ANA_N5V" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.adc_chx_data_hk_ana_n5v(15 downto 8);

				when (x"00001047") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "ADC_CHX_DATA_HK_ANA_N5V" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.adc_chx_data_hk_ana_n5v(7 downto 0);

				when (x"00001048") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.new_data;

				when (x"00001049") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "ADC_CHX_DATA_S_REF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.adc_chx_data_s_ref(23 downto 16);

				when (x"0000104A") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "ADC_CHX_DATA_S_REF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.adc_chx_data_s_ref(15 downto 8);

				when (x"0000104B") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "ADC_CHX_DATA_S_REF" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.adc_chx_data_s_ref(7 downto 0);

				when (x"0000104C") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.new_data;

				when (x"0000104D") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "ADC_CHX_DATA_HK_CCD_P31V" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.adc_chx_data_hk_ccd_p31v(23 downto 16);

				when (x"0000104E") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "ADC_CHX_DATA_HK_CCD_P31V" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.adc_chx_data_hk_ccd_p31v(15 downto 8);

				when (x"0000104F") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "ADC_CHX_DATA_HK_CCD_P31V" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.adc_chx_data_hk_ccd_p31v(7 downto 0);

				when (x"00001050") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.new_data;

				when (x"00001051") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "ADC_CHX_DATA_HK_CLK_P15V" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.adc_chx_data_hk_clk_p15v(23 downto 16);

				when (x"00001052") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "ADC_CHX_DATA_HK_CLK_P15V" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.adc_chx_data_hk_clk_p15v(15 downto 8);

				when (x"00001053") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "ADC_CHX_DATA_HK_CLK_P15V" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.adc_chx_data_hk_clk_p15v(7 downto 0);

				when (x"00001054") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.new_data;

				when (x"00001055") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "ADC_CHX_DATA_HK_ANA_P5V" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.adc_chx_data_hk_ana_p5v(23 downto 16);

				when (x"00001056") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "ADC_CHX_DATA_HK_ANA_P5V" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.adc_chx_data_hk_ana_p5v(15 downto 8);

				when (x"00001057") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "ADC_CHX_DATA_HK_ANA_P5V" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.adc_chx_data_hk_ana_p5v(7 downto 0);

				when (x"00001058") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.new_data;

				when (x"00001059") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "ADC_CHX_DATA_HK_ANA_P3V3" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.adc_chx_data_hk_ana_p3v3(23 downto 16);

				when (x"0000105A") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "ADC_CHX_DATA_HK_ANA_P3V3" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.adc_chx_data_hk_ana_p3v3(15 downto 8);

				when (x"0000105B") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "ADC_CHX_DATA_HK_ANA_P3V3" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.adc_chx_data_hk_ana_p3v3(7 downto 0);

				when (x"0000105C") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.ovf;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "NEW" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.new_data;

				when (x"0000105D") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "ADC_CHX_DATA_HK_DIG_P3V3" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.adc_chx_data_hk_dig_p3v3(23 downto 16);

				when (x"0000105E") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "ADC_CHX_DATA_HK_DIG_P3V3" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.adc_chx_data_hk_dig_p3v3(15 downto 8);

				when (x"0000105F") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "ADC_CHX_DATA_HK_DIG_P3V3" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.adc_chx_data_hk_dig_p3v3(7 downto 0);

				when (x"00001060") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "CHID" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.chid;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "SUPPLY" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.supply;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "OVF" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.ovf;

				when (x"00001063") =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "ADC_CHX_DATA_ADC_REF_BUF_2" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.adc_chx_data_adc_ref_buf_2;

				when (x"00001080") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "STAT" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.stat;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "CHOP" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.chop;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "CLKENB" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.clkenb;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "BYPAS" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.bypas;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "MUXMOD" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.muxmod;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "SPIRST" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.spirst;

				when (x"00001081") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DRATE0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.drate0;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DRATE1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.drate1;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "SBCS0" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.sbcs0;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "SBCS1" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.sbcs1;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DLY0" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.dly0;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DLY1" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.dly1;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DLY2" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.dly2;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "IDLMOD" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.idlmod;

				when (x"00001082") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINN0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainn0;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINN1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainn1;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINN2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainn2;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINN3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainn3;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINP0" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainp0;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINP1" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainp1;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINP2" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainp2;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINP3" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainp3;

				when (x"00001083") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff0;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff1;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff2;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff3;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff4;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff5;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff6;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff7;

				when (x"00001084") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain0;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain1;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain2;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain3;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain4;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain5;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain6;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain7;

				when (x"00001085") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN8" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain8;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN9" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain9;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN10" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain10;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN11" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain11;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN12" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain12;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN13" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain13;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN14" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain14;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN15" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain15;

				when (x"00001086") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "OFFSET" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.offset;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "VCC" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.vcc;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "TEMP" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.temp;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "GAIN" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.gain;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "REF" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ref;

				when (x"00001087") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio0;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio1;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio2;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio3;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio4;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio5;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio6;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio7;

				when (x"00001088") =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio0;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio1;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio2;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio3;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio4;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio5;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio6;
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio7;

				when (x"00001090") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "STAT" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.stat;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "CHOP" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.chop;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "CLKENB" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.clkenb;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "BYPAS" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.bypas;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "MUXMOD" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.muxmod;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "SPIRST" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.spirst;

				when (x"00001091") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DRATE0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.drate0;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DRATE1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.drate1;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "SBCS0" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.sbcs0;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "SBCS1" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.sbcs1;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DLY0" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.dly0;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DLY1" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.dly1;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DLY2" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.dly2;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "IDLMOD" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.idlmod;

				when (x"00001092") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINN0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainn0;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINN1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainn1;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINN2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainn2;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINN3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainn3;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINP0" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainp0;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINP1" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainp1;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINP2" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainp2;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINP3" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainp3;

				when (x"00001093") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff0;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff1;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff2;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff3;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff4;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff5;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff6;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff7;

				when (x"00001094") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain0;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain1;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain2;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain3;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain4;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain5;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain6;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain7;

				when (x"00001095") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN8" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain8;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN9" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain9;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN10" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain10;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN11" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain11;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN12" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain12;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN13" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain13;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN14" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain14;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN15" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain15;

				when (x"00001096") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "OFFSET" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.offset;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "VCC" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.vcc;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "TEMP" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.temp;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "GAIN" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.gain;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "REF" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ref;

				when (x"00001097") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio0;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio1;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio2;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio3;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio4;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio5;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio6;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio7;

				when (x"00001098") =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio0;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio1;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio2;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio3;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO4" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio4;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO5" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio5;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO6" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio6;
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO7" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio7;

				when (x"000010A0") =>
					-- AEB Housekeeping Area Register "VASP_RD_CONFIG" : "VASP1_READ_DATA" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_vasp_rd_config.vasp1_read_data;

				when (x"000010A1") =>
					-- AEB Housekeeping Area Register "VASP_RD_CONFIG" : "VASP2_READ_DATA" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_vasp_rd_config.vasp2_read_data;

				when (x"000011F0") =>
					-- AEB Housekeeping Area Register "REVISION_ID_1" : "FPGA_VERSION" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_1.fpga_version(15 downto 8);

				when (x"000011F1") =>
					-- AEB Housekeeping Area Register "REVISION_ID_1" : "FPGA_VERSION" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_1.fpga_version(7 downto 0);

				when (x"000011F2") =>
					-- AEB Housekeeping Area Register "REVISION_ID_1" : "FPGA_DATE" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_1.fpga_date(15 downto 8);

				when (x"000011F3") =>
					-- AEB Housekeeping Area Register "REVISION_ID_1" : "FPGA_DATE" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_1.fpga_date(7 downto 0);

				when (x"000011F4") =>
					-- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_TIME_H" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_2.fpga_time_h(15 downto 8);

				when (x"000011F5") =>
					-- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_TIME_H" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_2.fpga_time_h(7 downto 0);
					-- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_TIME_M" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_2.fpga_time_m;

				when (x"000011F6") =>
					-- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_SVN" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_2.fpga_svn(15 downto 8);

				when (x"000011F7") =>
					-- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_SVN" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.aeb_hk_revision_id_2.fpga_svn(7 downto 0);

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
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.reserved_0;
					end if;

				when (16#001#) =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "NEW_STATE" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.new_state;
					end if;

				when (16#002#) =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "SET_STATE" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.set_state;
					end if;

				when (16#003#) =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "AEB_RESET" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.aeb_reset;
					end if;

				when (16#004#) =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.reserved_1;
					end if;

				when (16#005#) =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_DATA_RD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.adc_data_rd;
					end if;

				when (16#006#) =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_CFG_WR" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.adc_cfg_wr;
					end if;

				when (16#007#) =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "ADC_CFG_RD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.adc_cfg_rd;
					end if;

				when (16#008#) =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "DAC_WR" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.dac_wr;
					end if;

				when (16#009#) =>
					-- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.reserved_2(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_control.reserved_2(15 downto 8);
					end if;
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(21 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.reserved_0;
					end if;

				when (16#00A#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "WATCH-DOG_DIS" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.watchdog_dis;
					end if;

				when (16#00B#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "INT_SYNC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.int_sync;
					end if;

				when (16#00C#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.reserved_1;
					end if;

				when (16#00D#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP_CDS_EN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.vasp_cds_en;
					end if;

				when (16#00E#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP2_CAL_EN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.vasp2_cal_en;
					end if;

				when (16#00F#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "VASP1_CAL_EN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.vasp1_cal_en;
					end if;

				when (16#010#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG" : "RESERVED_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.reserved_2(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config.reserved_2(15 downto 8);
					end if;

				when (16#011#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_key.key(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_key.key(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_key.key(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_key.key(31 downto 24);
					end if;

				when (16#012#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_SW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.override_sw;
					end if;

				when (16#013#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.reserved_0;
					end if;

				when (16#014#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.sw_van3;
					end if;

				when (16#015#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.sw_van2;
					end if;

				when (16#016#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VAN1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.sw_van1;
					end if;

				when (16#017#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VCLK" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.sw_vclk;
					end if;

				when (16#018#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "SW_VCCD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.sw_vccd;
					end if;

				when (16#019#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_VASP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.override_vasp;
					end if;

				when (16#01A#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.reserved_1;
					end if;

				when (16#01B#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_PIX_EN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.vasp2_pix_en;
					end if;

				when (16#01C#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_PIX_EN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.vasp1_pix_en;
					end if;

				when (16#01D#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_ADC_EN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.vasp2_adc_en;
					end if;

				when (16#01E#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_ADC_EN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.vasp1_adc_en;
					end if;

				when (16#01F#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP2_RESET" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.vasp2_reset;
					end if;

				when (16#020#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "VASP1_RESET" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.vasp1_reset;
					end if;

				when (16#021#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "OVERRIDE_ADC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.override_adc;
					end if;

				when (16#022#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC2_EN_P5V0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.adc2_en_p5v0;
					end if;

				when (16#023#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC1_EN_P5V0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.adc1_en_p5v0;
					end if;

				when (16#024#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "PT1000_CAL_ON_N" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.pt1000_cal_on_n;
					end if;

				when (16#025#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "EN_V_MUX_N" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.en_v_mux_n;
					end if;

				when (16#026#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC2_PWDN_N" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.adc2_pwdn_n;
					end if;

				when (16#027#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC1_PWDN_N" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.adc1_pwdn_n;
					end if;

				when (16#028#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "ADC_CLK_EN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.adc_clk_en;
					end if;

				when (16#029#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : "RESERVED_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_ait.reserved_2;
					end if;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_CCDID" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_ccdid;
					end if;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_COLS" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_cols(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(29 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_cols(13 downto 8);
					end if;

				when (16#02A#) =>
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.reserved;
					end if;
					-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_ROWS" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_rows(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(29 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_aeb_config_pattern.pattern_rows(13 downto 8);
					end if;

				when (16#02B#) =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP_CFG_ADDR" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.vasp_cfg_addr;
					end if;
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP1_CFG_DATA" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.vasp1_cfg_data;
					end if;
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP2_CFG_DATA" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.vasp2_cfg_data;
					end if;
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(26 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.reserved;
					end if;

				when (16#02C#) =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP2_SELECT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.vasp2_select;
					end if;

				when (16#02D#) =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "VASP1_SELECT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.vasp1_select;
					end if;

				when (16#02E#) =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "CALIBRATION_START" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.calibration_start;
					end if;

				when (16#02F#) =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "I2C_READ_START" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.i2c_read_start;
					end if;

				when (16#030#) =>
					-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : "I2C_WRITE_START" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_crit_cfg_vasp_i2c_control.i2c_write_start;
					end if;

				when (16#031#) =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.reserved_0;
					end if;
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VOG" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.dac_vog(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.dac_vog(11 downto 8);
					end if;

				when (16#032#) =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.reserved_1;
					end if;
					-- AEB Critical Configuration Area Register "DAC_CONFIG_1" : "DAC_VRD" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.dac_vrd(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_1.dac_vrd(11 downto 8);
					end if;

				when (16#033#) =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.reserved_0;
					end if;
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "DAC_VOD" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.dac_vod(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.dac_vod(11 downto 8);
					end if;

				when (16#034#) =>
					-- AEB Critical Configuration Area Register "DAC_CONFIG_2" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.reserved_1(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_dac_config_2.reserved_1(15 downto 8);
					end if;

				when (16#035#) =>
					-- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_reserved_20.reserved(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_reserved_20.reserved(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_reserved_20.reserved(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_reserved_20.reserved(31 downto 24);
					end if;

				when (16#036#) =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCCD_ON" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config1.time_vccd_on;
					end if;
					-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCLK_ON" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config1.time_vclk_on;
					end if;
					-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN1_ON" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config1.time_van1_on;
					end if;
					-- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN2_ON" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config1.time_van2_on;
					end if;

				when (16#037#) =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN3_ON" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config2.time_van3_on;
					end if;
					-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCCD_OFF" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config2.time_vccd_off;
					end if;
					-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCLK_OFF" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config2.time_vclk_off;
					end if;
					-- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN1_OFF" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config2.time_van1_off;
					end if;

				when (16#038#) =>
					-- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN2_OFF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config3.time_van2_off;
					end if;
					-- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN3_OFF" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_crit_cfg_pwr_config3.time_van3_off;
					end if;

				when (16#039#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.reserved_0;
					end if;

				when (16#03A#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "SPIRST" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.spirst;
					end if;

				when (16#03B#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "MUXMOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.muxmod;
					end if;

				when (16#03C#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "BYPAS" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.bypas;
					end if;

				when (16#03D#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "CLKENB" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.clkenb;
					end if;

				when (16#03E#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "CHOP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.chop;
					end if;

				when (16#03F#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "STAT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.stat;
					end if;

				when (16#040#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.reserved_1;
					end if;

				when (16#041#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "IDLMOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.idlmod;
					end if;

				when (16#042#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.dly;
					end if;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "SBCS" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.sbcs;
					end if;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DRATE" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(17 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.drate;
					end if;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "AINP" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.ainp;
					end if;

				when (16#043#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "AINN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.ainn;
					end if;
					-- AEB General Configuration Area Register "ADC1_CONFIG_1" : "DIFF" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_1.diff;
					end if;

				when (16#044#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain7;
					end if;

				when (16#045#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain6;
					end if;

				when (16#046#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain5;
					end if;

				when (16#047#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain4;
					end if;

				when (16#048#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain3;
					end if;

				when (16#049#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain2;
					end if;

				when (16#04A#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain1;
					end if;

				when (16#04B#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain0;
					end if;

				when (16#04C#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN15" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain15;
					end if;

				when (16#04D#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN14" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain14;
					end if;

				when (16#04E#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN13" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain13;
					end if;

				when (16#04F#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN12" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain12;
					end if;

				when (16#050#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN11" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain11;
					end if;

				when (16#051#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN10" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain10;
					end if;

				when (16#052#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN9" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain9;
					end if;

				when (16#053#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "AIN8" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ain8;
					end if;

				when (16#054#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.reserved_0;
					end if;

				when (16#055#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "REF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.ref;
					end if;

				when (16#056#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "GAIN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.gain;
					end if;

				when (16#057#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "TEMP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.temp;
					end if;

				when (16#058#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "VCC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.vcc;
					end if;

				when (16#059#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.reserved_1;
					end if;

				when (16#05A#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "OFFSET" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.offset;
					end if;

				when (16#05B#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio7;
					end if;

				when (16#05C#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio6;
					end if;

				when (16#05D#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio5;
					end if;

				when (16#05E#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio4;
					end if;

				when (16#05F#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio3;
					end if;

				when (16#060#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio2;
					end if;

				when (16#061#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio1;
					end if;

				when (16#062#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_2" : "CIO0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_2.cio0;
					end if;

				when (16#063#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio7;
					end if;

				when (16#064#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio6;
					end if;

				when (16#065#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio5;
					end if;

				when (16#066#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio4;
					end if;

				when (16#067#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio3;
					end if;

				when (16#068#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio2;
					end if;

				when (16#069#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio1;
					end if;

				when (16#06A#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "DIO0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.dio0;
					end if;

				when (16#06B#) =>
					-- AEB General Configuration Area Register "ADC1_CONFIG_3" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.reserved(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.reserved(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_adc1_config_3.reserved(23 downto 16);
					end if;

				when (16#06C#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.reserved_0;
					end if;

				when (16#06D#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "SPIRST" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.spirst;
					end if;

				when (16#06E#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "MUXMOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.muxmod;
					end if;

				when (16#06F#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "BYPAS" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.bypas;
					end if;

				when (16#070#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "CLKENB" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.clkenb;
					end if;

				when (16#071#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "CHOP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.chop;
					end if;

				when (16#072#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "STAT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.stat;
					end if;

				when (16#073#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.reserved_1;
					end if;

				when (16#074#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "IDLMOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.idlmod;
					end if;

				when (16#075#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.dly;
					end if;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "SBCS" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.sbcs;
					end if;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DRATE" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(17 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.drate;
					end if;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "AINP" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.ainp;
					end if;

				when (16#076#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "AINN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.ainn;
					end if;
					-- AEB General Configuration Area Register "ADC2_CONFIG_1" : "DIFF" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_1.diff;
					end if;

				when (16#077#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain7;
					end if;

				when (16#078#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain6;
					end if;

				when (16#079#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain5;
					end if;

				when (16#07A#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain4;
					end if;

				when (16#07B#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain3;
					end if;

				when (16#07C#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain2;
					end if;

				when (16#07D#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain1;
					end if;

				when (16#07E#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain0;
					end if;

				when (16#07F#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN15" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain15;
					end if;

				when (16#080#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN14" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain14;
					end if;

				when (16#081#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN13" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain13;
					end if;

				when (16#082#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN12" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain12;
					end if;

				when (16#083#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN11" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain11;
					end if;

				when (16#084#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN10" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain10;
					end if;

				when (16#085#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN9" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain9;
					end if;

				when (16#086#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "AIN8" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ain8;
					end if;

				when (16#087#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.reserved_0;
					end if;

				when (16#088#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "REF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.ref;
					end if;

				when (16#089#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "GAIN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.gain;
					end if;

				when (16#08A#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "TEMP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.temp;
					end if;

				when (16#08B#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "VCC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.vcc;
					end if;

				when (16#08C#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.reserved_1;
					end if;

				when (16#08D#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "OFFSET" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.offset;
					end if;

				when (16#08E#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio7;
					end if;

				when (16#08F#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio6;
					end if;

				when (16#090#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio5;
					end if;

				when (16#091#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio4;
					end if;

				when (16#092#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio3;
					end if;

				when (16#093#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio2;
					end if;

				when (16#094#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio1;
					end if;

				when (16#095#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_2" : "CIO0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_2.cio0;
					end if;

				when (16#096#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio7;
					end if;

				when (16#097#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio6;
					end if;

				when (16#098#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio5;
					end if;

				when (16#099#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio4;
					end if;

				when (16#09A#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio3;
					end if;

				when (16#09B#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio2;
					end if;

				when (16#09C#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio1;
					end if;

				when (16#09D#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "DIO0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.dio0;
					end if;

				when (16#09E#) =>
					-- AEB General Configuration Area Register "ADC2_CONFIG_3" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.reserved(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.reserved(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_adc2_config_3.reserved(23 downto 16);
					end if;

				when (16#09F#) =>
					-- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_118.reserved(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_118.reserved(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_118.reserved(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_118.reserved(31 downto 24);
					end if;

				when (16#0A0#) =>
					-- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_11c.reserved(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_11c.reserved(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_11c.reserved(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_reserved_11c.reserved(31 downto 24);
					end if;

				when (16#0A1#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.reserved_0;
					end if;

				when (16#0A2#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_CCD_ENABLE" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_ccd_enable;
					end if;

				when (16#0A3#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPARE" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_spare;
					end if;

				when (16#0A4#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TSTLINE" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_tstline;
					end if;

				when (16#0A5#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TSTFRM" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_tstfrm;
					end if;

				when (16#0A6#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_VASPCLAMP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_vaspclamp;
					end if;

				when (16#0A7#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_PRECLAMP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_preclamp;
					end if;

				when (16#0A8#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IG" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_ig;
					end if;

				when (16#0A9#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_TG" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_tg;
					end if;

				when (16#0AA#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_DG" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_dg;
					end if;

				when (16#0AB#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHIR" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_rphir;
					end if;

				when (16#0AC#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_sw;
					end if;

				when (16#0AD#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_rphi3;
					end if;

				when (16#0AE#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_rphi2;
					end if;

				when (16#0AF#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_RPHI1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_rphi1;
					end if;

				when (16#0B0#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_sphi4;
					end if;

				when (16#0B1#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_sphi3;
					end if;

				when (16#0B2#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_sphi2;
					end if;

				when (16#0B3#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_SPHI1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_sphi1;
					end if;

				when (16#0B4#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_iphi4;
					end if;

				when (16#0B5#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_iphi3;
					end if;

				when (16#0B6#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_iphi2;
					end if;

				when (16#0B7#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "SEQ_OE_IPHI1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.seq_oe_iphi1;
					end if;

				when (16#0B8#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.reserved_1;
					end if;

				when (16#0B9#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_1" : "ADC_CLK_DIV" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(6 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_1.adc_clk_div;
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "ADC_CLK_LOW_POS" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.adc_clk_low_pos;
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "ADC_CLK_HIGH_POS" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.adc_clk_high_pos;
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "CDS_CLK_LOW_POS" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.cds_clk_low_pos;
					end if;

				when (16#0BA#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_2" : "CDS_CLK_HIGH_POS" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_2.cds_clk_high_pos;
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHIR_CLK_LOW_POS" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.rphir_clk_low_pos;
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHIR_CLK_HIGH_POS" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.rphir_clk_high_pos;
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHI1_CLK_LOW_POS" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.rphi1_clk_low_pos;
					end if;

				when (16#0BB#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_3" : "RPHI1_CLK_HIGH_POS" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_3.rphi1_clk_high_pos;
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI2_CLK_LOW_POS" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.rphi2_clk_low_pos;
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI2_CLK_HIGH_POS" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.rphi2_clk_high_pos;
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI3_CLK_LOW_POS" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.rphi3_clk_low_pos;
					end if;

				when (16#0BC#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_4" : "RPHI3_CLK_HIGH_POS" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_4.rphi3_clk_high_pos;
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "SW_CLK_LOW_POS" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.sw_clk_low_pos;
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "SW_CLK_HIGH_POS" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.sw_clk_high_pos;
					end if;

				when (16#0BD#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "VASP_OUT_CTRL" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.vasp_out_ctrl;
					end if;

				when (16#0BE#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.reserved;
					end if;

				when (16#0BF#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_5" : "VASP_OUT_EN_POS" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.vasp_out_en_pos(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_5.vasp_out_en_pos(13 downto 8);
					end if;

				when (16#0C0#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "VASP_OUT_CTRL_INV" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.vasp_out_ctrl_inv;
					end if;

				when (16#0C1#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.reserved_0;
					end if;

				when (16#0C2#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "VASP_OUT_DIS_POS" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.vasp_out_dis_pos(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.vasp_out_dis_pos(13 downto 8);
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.reserved_1(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_6.reserved_1(15 downto 8);
					end if;

				when (16#0C3#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_7.reserved(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_7.reserved(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_7.reserved(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_7.reserved(31 downto 24);
					end if;

				when (16#0C4#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_8.reserved(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_8.reserved(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_8.reserved(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_8.reserved(31 downto 24);
					end if;

				when (16#0C5#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.reserved_0;
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "FT_LOOP_CNT" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.ft_loop_cnt(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(29 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.ft_loop_cnt(13 downto 8);
					end if;

				when (16#0C6#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_ENABLED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.lt0_enabled;
					end if;

				when (16#0C7#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.reserved_1;
					end if;

				when (16#0C8#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_9" : "LT0_LOOP_CNT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.lt0_loop_cnt(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_9.lt0_loop_cnt(13 downto 8);
					end if;

				when (16#0C9#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_ENABLED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt1_enabled;
					end if;

				when (16#0CA#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.reserved_0;
					end if;

				when (16#0CB#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT1_LOOP_CNT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt1_loop_cnt(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt1_loop_cnt(13 downto 8);
					end if;

				when (16#0CC#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_ENABLED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt2_enabled;
					end if;

				when (16#0CD#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.reserved_1;
					end if;

				when (16#0CE#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_10" : "LT2_LOOP_CNT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt2_loop_cnt(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_10.lt2_loop_cnt(13 downto 8);
					end if;

				when (16#0CF#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_ENABLED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.lt3_enabled;
					end if;

				when (16#0D0#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.reserved;
					end if;

				when (16#0D1#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "LT3_LOOP_CNT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.lt3_loop_cnt(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.lt3_loop_cnt(13 downto 8);
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_11" : "PIX_LOOP_CNT_WORD_1" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.pix_loop_cnt_word_1(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_11.pix_loop_cnt_word_1(15 downto 8);
					end if;

				when (16#0D2#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PIX_LOOP_CNT_WORD_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pix_loop_cnt_word_0(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pix_loop_cnt_word_0(15 downto 8);
					end if;

				when (16#0D3#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_ENABLED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pc_enabled;
					end if;

				when (16#0D4#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.reserved;
					end if;

				when (16#0D5#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_12" : "PC_LOOP_CNT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pc_loop_cnt(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_12.pc_loop_cnt(13 downto 8);
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(17 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.reserved_0;
					end if;

				when (16#0D6#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT1_LOOP_CNT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.int1_loop_cnt(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.int1_loop_cnt(13 downto 8);
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(17 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.reserved_1;
					end if;

				when (16#0D7#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_13" : "INT2_LOOP_CNT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.int2_loop_cnt(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_13.int2_loop_cnt(13 downto 8);
					end if;
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_0" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(22 downto 16) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.reserved_0;
					end if;

				when (16#0D8#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "SPHI_INV" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.sphi_inv;
					end if;

				when (16#0D9#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(6 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.reserved_1;
					end if;

				when (16#0DA#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RPHI_INV" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.rphi_inv;
					end if;

				when (16#0DB#) =>
					-- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.reserved_2(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_gen_cfg_seq_config_14.reserved_2(15 downto 8);
					end if;
					-- AEB Housekeeping Area Register "AEB_STATUS" : "AEB_STATUS" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(19 downto 16) <= rmap_registers_wr_i.aeb_hk_aeb_status.aeb_status;
					end if;

				when (16#0DC#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "VASP2_CFG_RUN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.vasp2_cfg_run;
					end if;

				when (16#0DD#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "VASP1_CFG_RUN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.vasp1_cfg_run;
					end if;

				when (16#0DE#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "DAC_CFG_WR_RUN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.dac_cfg_wr_run;
					end if;

				when (16#0DF#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_RD_RUN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_cfg_rd_run;
					end if;

				when (16#0E0#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_WR_RUN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_cfg_wr_run;
					end if;

				when (16#0E1#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_DAT_RD_RUN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_dat_rd_run;
					end if;

				when (16#0E2#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_ERROR" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_error;
					end if;

				when (16#0E3#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC2_LU" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc2_lu;
					end if;

				when (16#0E4#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC1_LU" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc1_lu;
					end if;

				when (16#0E5#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_DAT_RD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_dat_rd;
					end if;

				when (16#0E6#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_RD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_cfg_rd;
					end if;

				when (16#0E7#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC_CFG_WR" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc_cfg_wr;
					end if;

				when (16#0E8#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC2_BUSY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc2_busy;
					end if;

				when (16#0E9#) =>
					-- AEB Housekeeping Area Register "AEB_STATUS" : "ADC1_BUSY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_aeb_status.adc1_busy;
					end if;

				when (16#0EA#) =>
					-- AEB Housekeeping Area Register "TIMESTAMP_1" : "TIMESTAMP_DWORD_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_timestamp_1.timestamp_dword_1(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_timestamp_1.timestamp_dword_1(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_timestamp_1.timestamp_dword_1(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_timestamp_1.timestamp_dword_1(31 downto 24);
					end if;

				when (16#0EB#) =>
					-- AEB Housekeeping Area Register "TIMESTAMP_2" : "TIMESTAMP_DWORD_0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_timestamp_2.timestamp_dword_0(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_timestamp_2.timestamp_dword_0(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_timestamp_2.timestamp_dword_0(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_timestamp_2.timestamp_dword_0(31 downto 24);
					end if;

				when (16#0EC#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.new_data;
					end if;

				when (16#0ED#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.ovf;
					end if;

				when (16#0EE#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.supply;
					end if;

				when (16#0EF#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.chid;
					end if;

				when (16#0F0#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : "ADC_CHX_DATA_T_VASP_L" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.adc_chx_data_t_vasp_l(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.adc_chx_data_t_vasp_l(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_l.adc_chx_data_t_vasp_l(23 downto 16);
					end if;

				when (16#0F1#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.new_data;
					end if;

				when (16#0F2#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.ovf;
					end if;

				when (16#0F3#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.supply;
					end if;

				when (16#0F4#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.chid;
					end if;

				when (16#0F5#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : "ADC_CHX_DATA_T_VASP_R" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.adc_chx_data_t_vasp_r(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.adc_chx_data_t_vasp_r(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_vasp_r.adc_chx_data_t_vasp_r(23 downto 16);
					end if;

				when (16#0F6#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.new_data;
					end if;

				when (16#0F7#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.ovf;
					end if;

				when (16#0F8#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.supply;
					end if;

				when (16#0F9#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.chid;
					end if;

				when (16#0FA#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : "ADC_CHX_DATA_T_BIAS_P" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.adc_chx_data_t_bias_p(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.adc_chx_data_t_bias_p(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_bias_p.adc_chx_data_t_bias_p(23 downto 16);
					end if;

				when (16#0FB#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.new_data;
					end if;

				when (16#0FC#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.ovf;
					end if;

				when (16#0FD#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.supply;
					end if;

				when (16#0FE#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.chid;
					end if;

				when (16#0FF#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : "ADC_CHX_DATA_T_HK_P" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.adc_chx_data_t_hk_p(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.adc_chx_data_t_hk_p(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_hk_p.adc_chx_data_t_hk_p(23 downto 16);
					end if;

				when (16#100#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.new_data;
					end if;

				when (16#101#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.ovf;
					end if;

				when (16#102#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.supply;
					end if;

				when (16#103#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.chid;
					end if;

				when (16#104#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : "ADC_CHX_DATA_T_TOU_1_P" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.adc_chx_data_t_tou_1_p(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.adc_chx_data_t_tou_1_p(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_1_p.adc_chx_data_t_tou_1_p(23 downto 16);
					end if;

				when (16#105#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.new_data;
					end if;

				when (16#106#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.ovf;
					end if;

				when (16#107#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.supply;
					end if;

				when (16#108#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.chid;
					end if;

				when (16#109#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : "ADC_CHX_DATA_T_TOU_2_P" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.adc_chx_data_t_tou_2_p(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.adc_chx_data_t_tou_2_p(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_tou_2_p.adc_chx_data_t_tou_2_p(23 downto 16);
					end if;

				when (16#10A#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.new_data;
					end if;

				when (16#10B#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.ovf;
					end if;

				when (16#10C#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.supply;
					end if;

				when (16#10D#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.chid;
					end if;

				when (16#10E#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : "ADC_CHX_DATA_HK_VODE" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.adc_chx_data_hk_vode(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.adc_chx_data_hk_vode(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vode.adc_chx_data_hk_vode(23 downto 16);
					end if;

				when (16#10F#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.new_data;
					end if;

				when (16#110#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.ovf;
					end if;

				when (16#111#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.supply;
					end if;

				when (16#112#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.chid;
					end if;

				when (16#113#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : "ADC_CHX_DATA_HK_VODF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.adc_chx_data_hk_vodf(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.adc_chx_data_hk_vodf(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vodf.adc_chx_data_hk_vodf(23 downto 16);
					end if;

				when (16#114#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.new_data;
					end if;

				when (16#115#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.ovf;
					end if;

				when (16#116#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.supply;
					end if;

				when (16#117#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.chid;
					end if;

				when (16#118#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : "ADC_CHX_DATA_HK_VRD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.adc_chx_data_hk_vrd(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.adc_chx_data_hk_vrd(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vrd.adc_chx_data_hk_vrd(23 downto 16);
					end if;

				when (16#119#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.new_data;
					end if;

				when (16#11A#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.ovf;
					end if;

				when (16#11B#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.supply;
					end if;

				when (16#11C#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.chid;
					end if;

				when (16#11D#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : "ADC_CHX_DATA_HK_VOG" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.adc_chx_data_hk_vog(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.adc_chx_data_hk_vog(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_vog.adc_chx_data_hk_vog(23 downto 16);
					end if;

				when (16#11E#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.new_data;
					end if;

				when (16#11F#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.ovf;
					end if;

				when (16#120#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.supply;
					end if;

				when (16#121#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.chid;
					end if;

				when (16#122#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : "ADC_CHX_DATA_T_CCD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.adc_chx_data_t_ccd(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.adc_chx_data_t_ccd(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ccd.adc_chx_data_t_ccd(23 downto 16);
					end if;

				when (16#123#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.new_data;
					end if;

				when (16#124#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.ovf;
					end if;

				when (16#125#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.supply;
					end if;

				when (16#126#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.chid;
					end if;

				when (16#127#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : "ADC_CHX_DATA_T_REF1K_MEA" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.adc_chx_data_t_ref1k_mea(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.adc_chx_data_t_ref1k_mea(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref1k_mea.adc_chx_data_t_ref1k_mea(23 downto 16);
					end if;

				when (16#128#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.new_data;
					end if;

				when (16#129#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.ovf;
					end if;

				when (16#12A#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.supply;
					end if;

				when (16#12B#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.chid;
					end if;

				when (16#12C#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : "ADC_CHX_DATA_T_REF649R_MEA" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.adc_chx_data_t_ref649r_mea(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.adc_chx_data_t_ref649r_mea(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_t_ref649r_mea.adc_chx_data_t_ref649r_mea(23 downto 16);
					end if;

				when (16#12D#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.new_data;
					end if;

				when (16#12E#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.ovf;
					end if;

				when (16#12F#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.supply;
					end if;

				when (16#130#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.chid;
					end if;

				when (16#131#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : "ADC_CHX_DATA_HK_ANA_N5V" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.adc_chx_data_hk_ana_n5v(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.adc_chx_data_hk_ana_n5v(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_n5v.adc_chx_data_hk_ana_n5v(23 downto 16);
					end if;

				when (16#132#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.new_data;
					end if;

				when (16#133#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.ovf;
					end if;

				when (16#134#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.supply;
					end if;

				when (16#135#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.chid;
					end if;

				when (16#136#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : "ADC_CHX_DATA_S_REF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.adc_chx_data_s_ref(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.adc_chx_data_s_ref(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_s_ref.adc_chx_data_s_ref(23 downto 16);
					end if;

				when (16#137#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.new_data;
					end if;

				when (16#138#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.ovf;
					end if;

				when (16#139#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.supply;
					end if;

				when (16#13A#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.chid;
					end if;

				when (16#13B#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : "ADC_CHX_DATA_HK_CCD_P31V" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.adc_chx_data_hk_ccd_p31v(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.adc_chx_data_hk_ccd_p31v(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ccd_p31v.adc_chx_data_hk_ccd_p31v(23 downto 16);
					end if;

				when (16#13C#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.new_data;
					end if;

				when (16#13D#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.ovf;
					end if;

				when (16#13E#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.supply;
					end if;

				when (16#13F#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.chid;
					end if;

				when (16#140#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : "ADC_CHX_DATA_HK_CLK_P15V" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.adc_chx_data_hk_clk_p15v(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.adc_chx_data_hk_clk_p15v(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_clk_p15v.adc_chx_data_hk_clk_p15v(23 downto 16);
					end if;

				when (16#141#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.new_data;
					end if;

				when (16#142#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.ovf;
					end if;

				when (16#143#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.supply;
					end if;

				when (16#144#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.chid;
					end if;

				when (16#145#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : "ADC_CHX_DATA_HK_ANA_P5V" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.adc_chx_data_hk_ana_p5v(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.adc_chx_data_hk_ana_p5v(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p5v.adc_chx_data_hk_ana_p5v(23 downto 16);
					end if;

				when (16#146#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.new_data;
					end if;

				when (16#147#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.ovf;
					end if;

				when (16#148#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.supply;
					end if;

				when (16#149#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.chid;
					end if;

				when (16#14A#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : "ADC_CHX_DATA_HK_ANA_P3V3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.adc_chx_data_hk_ana_p3v3(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.adc_chx_data_hk_ana_p3v3(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_ana_p3v3.adc_chx_data_hk_ana_p3v3(23 downto 16);
					end if;

				when (16#14B#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.new_data;
					end if;

				when (16#14C#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.ovf;
					end if;

				when (16#14D#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.supply;
					end if;

				when (16#14E#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.chid;
					end if;

				when (16#14F#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : "ADC_CHX_DATA_HK_DIG_P3V3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.adc_chx_data_hk_dig_p3v3(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.adc_chx_data_hk_dig_p3v3(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_hk_dig_p3v3.adc_chx_data_hk_dig_p3v3(23 downto 16);
					end if;

				when (16#150#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "NEW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.new_data;
					end if;

				when (16#151#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.ovf;
					end if;

				when (16#152#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "SUPPLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.supply;
					end if;

				when (16#153#) =>
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "CHID" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.chid;
					end if;
					-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : "ADC_CHX_DATA_ADC_REF_BUF_2" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(11 downto 8) <= rmap_registers_wr_i.aeb_hk_adc_rd_data_adc_ref_buf_2.adc_chx_data_adc_ref_buf_2;
					end if;

				when (16#154#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "SPIRST" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.spirst;
					end if;

				when (16#155#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "MUXMOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.muxmod;
					end if;

				when (16#156#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "BYPAS" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.bypas;
					end if;

				when (16#157#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "CLKENB" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.clkenb;
					end if;

				when (16#158#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "CHOP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.chop;
					end if;

				when (16#159#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "STAT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.stat;
					end if;

				when (16#15A#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "IDLMOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.idlmod;
					end if;

				when (16#15B#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DLY2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.dly2;
					end if;

				when (16#15C#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DLY1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.dly1;
					end if;

				when (16#15D#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DLY0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.dly0;
					end if;

				when (16#15E#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "SBCS1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.sbcs1;
					end if;

				when (16#15F#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "SBCS0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.sbcs0;
					end if;

				when (16#160#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DRATE1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.drate1;
					end if;

				when (16#161#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DRATE0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.drate0;
					end if;

				when (16#162#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINP3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainp3;
					end if;

				when (16#163#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINP2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainp2;
					end if;

				when (16#164#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINP1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainp1;
					end if;

				when (16#165#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINP0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainp0;
					end if;

				when (16#166#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINN3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainn3;
					end if;

				when (16#167#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINN2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainn2;
					end if;

				when (16#168#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINN1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainn1;
					end if;

				when (16#169#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "AINN0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.ainn0;
					end if;

				when (16#16A#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff7;
					end if;

				when (16#16B#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff6;
					end if;

				when (16#16C#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff5;
					end if;

				when (16#16D#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff4;
					end if;

				when (16#16E#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff3;
					end if;

				when (16#16F#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff2;
					end if;

				when (16#170#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff1;
					end if;

				when (16#171#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" : "DIFF0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_1.diff0;
					end if;

				when (16#172#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain7;
					end if;

				when (16#173#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain6;
					end if;

				when (16#174#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain5;
					end if;

				when (16#175#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain4;
					end if;

				when (16#176#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain3;
					end if;

				when (16#177#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain2;
					end if;

				when (16#178#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain1;
					end if;

				when (16#179#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain0;
					end if;

				when (16#17A#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN15" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain15;
					end if;

				when (16#17B#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN14" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain14;
					end if;

				when (16#17C#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN13" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain13;
					end if;

				when (16#17D#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN12" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain12;
					end if;

				when (16#17E#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN11" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain11;
					end if;

				when (16#17F#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN10" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain10;
					end if;

				when (16#180#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN9" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain9;
					end if;

				when (16#181#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "AIN8" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ain8;
					end if;

				when (16#182#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "REF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.ref;
					end if;

				when (16#183#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "GAIN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.gain;
					end if;

				when (16#184#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "TEMP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.temp;
					end if;

				when (16#185#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "VCC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.vcc;
					end if;

				when (16#186#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "OFFSET" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.offset;
					end if;

				when (16#187#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio7;
					end if;

				when (16#188#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio6;
					end if;

				when (16#189#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio5;
					end if;

				when (16#18A#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio4;
					end if;

				when (16#18B#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio3;
					end if;

				when (16#18C#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio2;
					end if;

				when (16#18D#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio1;
					end if;

				when (16#18E#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" : "CIO0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_2.cio0;
					end if;

				when (16#18F#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio7;
					end if;

				when (16#190#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio6;
					end if;

				when (16#191#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio5;
					end if;

				when (16#192#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio4;
					end if;

				when (16#193#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio3;
					end if;

				when (16#194#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio2;
					end if;

				when (16#195#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio1;
					end if;

				when (16#196#) =>
					-- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" : "DIO0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc1_rd_config_3.dio0;
					end if;

				when (16#197#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "SPIRST" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.spirst;
					end if;

				when (16#198#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "MUXMOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.muxmod;
					end if;

				when (16#199#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "BYPAS" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.bypas;
					end if;

				when (16#19A#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "CLKENB" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.clkenb;
					end if;

				when (16#19B#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "CHOP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.chop;
					end if;

				when (16#19C#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "STAT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.stat;
					end if;

				when (16#19D#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "IDLMOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.idlmod;
					end if;

				when (16#19E#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DLY2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.dly2;
					end if;

				when (16#19F#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DLY1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.dly1;
					end if;

				when (16#1A0#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DLY0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.dly0;
					end if;

				when (16#1A1#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "SBCS1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.sbcs1;
					end if;

				when (16#1A2#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "SBCS0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.sbcs0;
					end if;

				when (16#1A3#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DRATE1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.drate1;
					end if;

				when (16#1A4#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DRATE0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.drate0;
					end if;

				when (16#1A5#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINP3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainp3;
					end if;

				when (16#1A6#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINP2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainp2;
					end if;

				when (16#1A7#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINP1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainp1;
					end if;

				when (16#1A8#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINP0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainp0;
					end if;

				when (16#1A9#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINN3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainn3;
					end if;

				when (16#1AA#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINN2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainn2;
					end if;

				when (16#1AB#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINN1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainn1;
					end if;

				when (16#1AC#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "AINN0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.ainn0;
					end if;

				when (16#1AD#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff7;
					end if;

				when (16#1AE#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff6;
					end if;

				when (16#1AF#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff5;
					end if;

				when (16#1B0#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff4;
					end if;

				when (16#1B1#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff3;
					end if;

				when (16#1B2#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff2;
					end if;

				when (16#1B3#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff1;
					end if;

				when (16#1B4#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" : "DIFF0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_1.diff0;
					end if;

				when (16#1B5#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain7;
					end if;

				when (16#1B6#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain6;
					end if;

				when (16#1B7#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain5;
					end if;

				when (16#1B8#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain4;
					end if;

				when (16#1B9#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain3;
					end if;

				when (16#1BA#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain2;
					end if;

				when (16#1BB#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain1;
					end if;

				when (16#1BC#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain0;
					end if;

				when (16#1BD#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN15" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain15;
					end if;

				when (16#1BE#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN14" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain14;
					end if;

				when (16#1BF#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN13" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain13;
					end if;

				when (16#1C0#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN12" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain12;
					end if;

				when (16#1C1#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN11" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain11;
					end if;

				when (16#1C2#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN10" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain10;
					end if;

				when (16#1C3#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN9" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain9;
					end if;

				when (16#1C4#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "AIN8" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ain8;
					end if;

				when (16#1C5#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "REF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.ref;
					end if;

				when (16#1C6#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "GAIN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.gain;
					end if;

				when (16#1C7#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "TEMP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.temp;
					end if;

				when (16#1C8#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "VCC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.vcc;
					end if;

				when (16#1C9#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "OFFSET" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.offset;
					end if;

				when (16#1CA#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio7;
					end if;

				when (16#1CB#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio6;
					end if;

				when (16#1CC#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio5;
					end if;

				when (16#1CD#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio4;
					end if;

				when (16#1CE#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio3;
					end if;

				when (16#1CF#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio2;
					end if;

				when (16#1D0#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio1;
					end if;

				when (16#1D1#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" : "CIO0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_2.cio0;
					end if;

				when (16#1D2#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio7;
					end if;

				when (16#1D3#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio6;
					end if;

				when (16#1D4#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio5;
					end if;

				when (16#1D5#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio4;
					end if;

				when (16#1D6#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio3;
					end if;

				when (16#1D7#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio2;
					end if;

				when (16#1D8#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio1;
					end if;

				when (16#1D9#) =>
					-- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" : "DIO0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.aeb_hk_adc2_rd_config_3.dio0;
					end if;

				when (16#1DA#) =>
					-- AEB Housekeeping Area Register "VASP_RD_CONFIG" : "VASP1_READ_DATA" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_vasp_rd_config.vasp1_read_data;
					end if;
					-- AEB Housekeeping Area Register "VASP_RD_CONFIG" : "VASP2_READ_DATA" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_vasp_rd_config.vasp2_read_data;
					end if;
					-- AEB Housekeeping Area Register "REVISION_ID_1" : "FPGA_VERSION" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_revision_id_1.fpga_version(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_revision_id_1.fpga_version(15 downto 8);
					end if;

				when (16#1DB#) =>
					-- AEB Housekeeping Area Register "REVISION_ID_1" : "FPGA_DATE" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_revision_id_1.fpga_date(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.aeb_hk_revision_id_1.fpga_date(15 downto 8);
					end if;
					-- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_TIME_H" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_revision_id_2.fpga_time_h(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_revision_id_2.fpga_time_h(15 downto 8);
					end if;

				when (16#1DC#) =>
					-- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_TIME_M" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.aeb_hk_revision_id_2.fpga_time_m;
					end if;
					-- AEB Housekeeping Area Register "REVISION_ID_2" : "FPGA_SVN" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.aeb_hk_revision_id_2.fpga_svn(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.aeb_hk_revision_id_2.fpga_svn(15 downto 8);
					end if;

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
