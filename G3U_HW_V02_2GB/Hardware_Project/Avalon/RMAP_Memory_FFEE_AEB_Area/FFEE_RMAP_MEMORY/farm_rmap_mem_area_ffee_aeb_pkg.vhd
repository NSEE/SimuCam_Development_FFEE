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

    -- RAM Memory Direct Access
    type t_ram_mem_direct_access is record
        addr : std_logic_vector(31 downto 0);
    end record t_ram_mem_direct_access;

    constant c_RAM_MEM_DIRECT_ACCESS_RST : t_ram_mem_direct_access := (
        addr => (others => '0')
    );

    -- Address Constants

    -- Allowed Addresses
    constant c_FARM_AVALON_MM_FFEE_AEB_RMAP_MIN_ADDR : natural range 0 to 511 := 16#000#;
    --    constant c_FARM_AVALON_MM_FFEE_AEB_RMAP_MAX_ADDR : natural range 0 to 511 := 16#06F#;
    constant c_FARM_AVALON_MM_FFEE_AEB_RMAP_MAX_ADDR : natural range 0 to 511 := 16#071#;

    -- Registers Types

    -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1"
    type t_aeb_hk_adc1_rd_config_1_rd_reg is record
        others_0 : std_logic_vector(5 downto 0); -- SPIRST, "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT" Fields
        others_1 : std_logic_vector(23 downto 0); -- IDLMOD, "DLY2", "DLY1", "DLY0", "SBCS1", "SBCS0", "DRATE1", "DRATE0", "AINP3", "AINP2", "AINP1", "AINP0", "AINN3", "AINN2", "AINN1", "AINN0", "DIFF7", "DIFF6", "DIFF5", "DIFF4", "DIFF3", "DIFF2", "DIFF1", "DIFF0" Fields
    end record t_aeb_hk_adc1_rd_config_1_rd_reg;

    -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2"
    type t_aeb_hk_adc1_rd_config_2_rd_reg is record
        others_0 : std_logic_vector(15 downto 0); -- AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8" Fields
        others_1 : std_logic_vector(3 downto 0); -- REF, "GAIN", "TEMP", "VCC" Fields
        others_2 : std_logic_vector(8 downto 0); -- OFFSET, "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
    end record t_aeb_hk_adc1_rd_config_2_rd_reg;

    -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3"
    type t_aeb_hk_adc1_rd_config_3_rd_reg is record
        others_0 : std_logic_vector(7 downto 0); -- DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0" Fields
    end record t_aeb_hk_adc1_rd_config_3_rd_reg;

    -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1"
    type t_aeb_hk_adc2_rd_config_1_rd_reg is record
        others_0 : std_logic_vector(5 downto 0); -- SPIRST, "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT" Fields
        others_1 : std_logic_vector(23 downto 0); -- IDLMOD, "DLY2", "DLY1", "DLY0", "SBCS1", "SBCS0", "DRATE1", "DRATE0", "AINP3", "AINP2", "AINP1", "AINP0", "AINN3", "AINN2", "AINN1", "AINN0", "DIFF7", "DIFF6", "DIFF5", "DIFF4", "DIFF3", "DIFF2", "DIFF1", "DIFF0" Fields
    end record t_aeb_hk_adc2_rd_config_1_rd_reg;

    -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2"
    type t_aeb_hk_adc2_rd_config_2_rd_reg is record
        others_0 : std_logic_vector(15 downto 0); -- AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8" Fields
        others_1 : std_logic_vector(3 downto 0); -- REF, "GAIN", "TEMP", "VCC" Fields
        others_2 : std_logic_vector(8 downto 0); -- OFFSET, "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
    end record t_aeb_hk_adc2_rd_config_2_rd_reg;

    -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3"
    type t_aeb_hk_adc2_rd_config_3_rd_reg is record
        others_0 : std_logic_vector(7 downto 0); -- DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0" Fields
    end record t_aeb_hk_adc2_rd_config_3_rd_reg;

    --    -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_4"
    --    type t_aeb_hk_adc2_rd_config_4_rd_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED" Field
    --    end record t_aeb_hk_adc2_rd_config_4_rd_reg;

    -- AEB Housekeeping Area Register "SYNC_PERIOD_1" and "SYNC_PERIOD_2"
    type t_aeb_hk_sync_period_1_2_rd_reg is record
        sync_period : std_logic_vector(63 downto 0); -- "SYNC_PERIOD" Field
    end record t_aeb_hk_sync_period_1_2_rd_reg;

    --	-- AEB Critical Configuration Area Register "AEB_CONFIG_AIT"
    --	type t_aeb_crit_cfg_aeb_config_ait_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- OVERRIDE_SW, "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields
    --	end record t_aeb_crit_cfg_aeb_config_ait_wr_reg;
    --
    --	-- AEB Critical Configuration Area Register "AEB_CONFIG_KEY"
    --	type t_aeb_crit_cfg_aeb_config_key_wr_reg is record
    --		key : std_logic_vector(31 downto 0); -- "KEY" Field
    --	end record t_aeb_crit_cfg_aeb_config_key_wr_reg;
    --
    --	-- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN"
    --	type t_aeb_crit_cfg_aeb_config_pattern_wr_reg is record
    --		pattern_ccdid : std_logic_vector(1 downto 0); -- "PATTERN_CCDID" Field
    --		pattern_cols  : std_logic_vector(13 downto 0); -- "PATTERN_COLS" Field
    --		reserved      : std_logic_vector(1 downto 0); -- "RESERVED" Field
    --		pattern_rows  : std_logic_vector(13 downto 0); -- "PATTERN_ROWS" Field
    --	end record t_aeb_crit_cfg_aeb_config_pattern_wr_reg;
    --
    --	-- AEB Critical Configuration Area Register "AEB_CONFIG"
    --	type t_aeb_crit_cfg_aeb_config_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields
    --	end record t_aeb_crit_cfg_aeb_config_wr_reg;
    --
    --	-- AEB Critical Configuration Area Register "AEB_CONTROL"
    --	type t_aeb_crit_cfg_aeb_control_wr_reg is record
    --		reserved  : std_logic_vector(1 downto 0); -- "RESERVED" Field
    --		new_state : std_logic_vector(3 downto 0); -- "NEW_STATE" Field
    --		set_state : std_logic;          -- "SET_STATE" Field
    --		aeb_reset : std_logic;          -- "AEB_RESET" Field
    --		others_0  : std_logic_vector(23 downto 0); -- RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields
    --	end record t_aeb_crit_cfg_aeb_control_wr_reg;
    --
    --	-- AEB Critical Configuration Area Register "DAC_CONFIG_1"
    --	type t_aeb_crit_cfg_dac_config_1_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields
    --	end record t_aeb_crit_cfg_dac_config_1_wr_reg;
    --
    --	-- AEB Critical Configuration Area Register "DAC_CONFIG_2"
    --	type t_aeb_crit_cfg_dac_config_2_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- RESERVED_0, "DAC_VOD", "RESERVED_1" Fields
    --	end record t_aeb_crit_cfg_dac_config_2_wr_reg;
    --
    --	-- AEB Critical Configuration Area Register "PWR_CONFIG1"
    --	type t_aeb_crit_cfg_pwr_config1_wr_reg is record
    --		time_vccd_on : std_logic_vector(7 downto 0); -- "TIME_VCCD_ON" Field
    --		time_vclk_on : std_logic_vector(7 downto 0); -- "TIME_VCLK_ON" Field
    --		time_van1_on : std_logic_vector(7 downto 0); -- "TIME_VAN1_ON" Field
    --		time_van2_on : std_logic_vector(7 downto 0); -- "TIME_VAN2_ON" Field
    --	end record t_aeb_crit_cfg_pwr_config1_wr_reg;
    --
    --	-- AEB Critical Configuration Area Register "PWR_CONFIG2"
    --	type t_aeb_crit_cfg_pwr_config2_wr_reg is record
    --		time_van3_on  : std_logic_vector(7 downto 0); -- "TIME_VAN3_ON" Field
    --		time_vccd_off : std_logic_vector(7 downto 0); -- "TIME_VCCD_OFF" Field
    --		time_vclk_off : std_logic_vector(7 downto 0); -- "TIME_VCLK_OFF" Field
    --		time_van1_off : std_logic_vector(7 downto 0); -- "TIME_VAN1_OFF" Field
    --	end record t_aeb_crit_cfg_pwr_config2_wr_reg;
    --
    --	-- AEB Critical Configuration Area Register "PWR_CONFIG3"
    --	type t_aeb_crit_cfg_pwr_config3_wr_reg is record
    --		time_van2_off : std_logic_vector(7 downto 0); -- "TIME_VAN2_OFF" Field
    --		time_van3_off : std_logic_vector(7 downto 0); -- "TIME_VAN3_OFF" Field
    --	end record t_aeb_crit_cfg_pwr_config3_wr_reg;
    --
    --	-- AEB Critical Configuration Area Register "RESERVED_20"
    --	type t_aeb_crit_cfg_reserved_20_wr_reg is record
    --		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
    --	end record t_aeb_crit_cfg_reserved_20_wr_reg;
    --
    --	-- AEB Critical Configuration Area Register "VASP_I2C_CONTROL"
    --	type t_aeb_crit_cfg_vasp_i2c_control_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields
    --	end record t_aeb_crit_cfg_vasp_i2c_control_wr_reg;

    -- AEB General Configuration Area Register "ADC1_CONFIG_1"
    type t_aeb_gen_cfg_adc1_config_1_wr_reg is record
        others_0 : std_logic_vector(31 downto 0); -- RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
    end record t_aeb_gen_cfg_adc1_config_1_wr_reg;

    -- AEB General Configuration Area Register "ADC1_CONFIG_2"
    type t_aeb_gen_cfg_adc1_config_2_wr_reg is record
        others_0 : std_logic_vector(31 downto 0); -- AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
    end record t_aeb_gen_cfg_adc1_config_2_wr_reg;

    -- AEB General Configuration Area Register "ADC1_CONFIG_3"
    type t_aeb_gen_cfg_adc1_config_3_wr_reg is record
        others_0 : std_logic_vector(31 downto 0); -- DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
    end record t_aeb_gen_cfg_adc1_config_3_wr_reg;

    -- AEB General Configuration Area Register "ADC2_CONFIG_1"
    type t_aeb_gen_cfg_adc2_config_1_wr_reg is record
        others_0 : std_logic_vector(31 downto 0); -- RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
    end record t_aeb_gen_cfg_adc2_config_1_wr_reg;

    -- AEB General Configuration Area Register "ADC2_CONFIG_2"
    type t_aeb_gen_cfg_adc2_config_2_wr_reg is record
        others_0 : std_logic_vector(31 downto 0); -- AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
    end record t_aeb_gen_cfg_adc2_config_2_wr_reg;

    -- AEB General Configuration Area Register "ADC2_CONFIG_3"
    type t_aeb_gen_cfg_adc2_config_3_wr_reg is record
        others_0 : std_logic_vector(31 downto 0); -- DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
    end record t_aeb_gen_cfg_adc2_config_3_wr_reg;

    --	-- AEB General Configuration Area Register "RESERVED_118"
    --	type t_aeb_gen_cfg_reserved_118_wr_reg is record
    --		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
    --	end record t_aeb_gen_cfg_reserved_118_wr_reg;
    --
    --	-- AEB General Configuration Area Register "RESERVED_11C"
    --	type t_aeb_gen_cfg_reserved_11c_wr_reg is record
    --		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
    --	end record t_aeb_gen_cfg_reserved_11c_wr_reg;
    --
    --	-- AEB General Configuration Area Register "SEQ_CONFIG_1"
    --	type t_aeb_gen_cfg_seq_config_1_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields
    --	end record t_aeb_gen_cfg_seq_config_1_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_2"
    --    type t_aeb_gen_cfg_seq_config_2_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_2_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_3"
    --    type t_aeb_gen_cfg_seq_config_3_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_3_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_4"
    --    type t_aeb_gen_cfg_seq_config_4_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_4_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_5"
    --    type t_aeb_gen_cfg_seq_config_5_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields
    --    end record t_aeb_gen_cfg_seq_config_5_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_6"
    --    type t_aeb_gen_cfg_seq_config_6_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_6_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_7"
    --    type t_aeb_gen_cfg_seq_config_7_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_7_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_8"
    --    type t_aeb_gen_cfg_seq_config_8_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_8_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_9"
    --    type t_aeb_gen_cfg_seq_config_9_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_9_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_10"
    --    type t_aeb_gen_cfg_seq_config_10_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_10_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_11"
    --    type t_aeb_gen_cfg_seq_config_11_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_11_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_12"
    --    type t_aeb_gen_cfg_seq_config_12_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_12_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_13"
    --    type t_aeb_gen_cfg_seq_config_13_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_13_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_14"
    --    type t_aeb_gen_cfg_seq_config_14_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_14_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_15"
    --    type t_aeb_gen_cfg_seq_config_15_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_15_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_16"
    --    type t_aeb_gen_cfg_seq_config_16_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_16_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_17"
    --    type t_aeb_gen_cfg_seq_config_17_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_17_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_18"
    --    type t_aeb_gen_cfg_seq_config_18_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_18_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_19"
    --    type t_aeb_gen_cfg_seq_config_19_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields
    --    end record t_aeb_gen_cfg_seq_config_19_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_20"
    --    type t_aeb_gen_cfg_seq_config_20_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields
    --    end record t_aeb_gen_cfg_seq_config_20_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_21"
    --    type t_aeb_gen_cfg_seq_config_21_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED" Field
    --    end record t_aeb_gen_cfg_seq_config_21_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_22"
    --    type t_aeb_gen_cfg_seq_config_22_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED" Field
    --    end record t_aeb_gen_cfg_seq_config_22_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_23"
    --    type t_aeb_gen_cfg_seq_config_23_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED" Field
    --    end record t_aeb_gen_cfg_seq_config_23_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_24"
    --    type t_aeb_gen_cfg_seq_config_24_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields
    --    end record t_aeb_gen_cfg_seq_config_24_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_25"
    --    type t_aeb_gen_cfg_seq_config_25_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields
    --    end record t_aeb_gen_cfg_seq_config_25_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_26"
    --    type t_aeb_gen_cfg_seq_config_26_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields
    --    end record t_aeb_gen_cfg_seq_config_26_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_27"
    --    type t_aeb_gen_cfg_seq_config_27_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields
    --    end record t_aeb_gen_cfg_seq_config_27_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_28"
    --    type t_aeb_gen_cfg_seq_config_28_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields
    --    end record t_aeb_gen_cfg_seq_config_28_wr_reg;
    --
    --    -- AEB General Configuration Area Register "SEQ_CONFIG_29"
    --    type t_aeb_gen_cfg_seq_config_29_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED" Field
    --    end record t_aeb_gen_cfg_seq_config_29_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2"
    --	type t_aeb_hk_adc_rd_data_adc_ref_buf_2_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields
    --	end record t_aeb_hk_adc_rd_data_adc_ref_buf_2_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V"
    --	type t_aeb_hk_adc_rd_data_hk_ana_n5v_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields
    --	end record t_aeb_hk_adc_rd_data_hk_ana_n5v_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3"
    --	type t_aeb_hk_adc_rd_data_hk_ana_p3v3_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields
    --	end record t_aeb_hk_adc_rd_data_hk_ana_p3v3_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V"
    --	type t_aeb_hk_adc_rd_data_hk_ana_p5v_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields
    --	end record t_aeb_hk_adc_rd_data_hk_ana_p5v_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V"
    --	type t_aeb_hk_adc_rd_data_hk_ccd_p31v_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields
    --	end record t_aeb_hk_adc_rd_data_hk_ccd_p31v_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V"
    --	type t_aeb_hk_adc_rd_data_hk_clk_p15v_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields
    --	end record t_aeb_hk_adc_rd_data_hk_clk_p15v_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3"
    --	type t_aeb_hk_adc_rd_data_hk_dig_p3v3_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields
    --	end record t_aeb_hk_adc_rd_data_hk_dig_p3v3_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE"
    --	type t_aeb_hk_adc_rd_data_hk_vode_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields
    --	end record t_aeb_hk_adc_rd_data_hk_vode_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF"
    --	type t_aeb_hk_adc_rd_data_hk_vodf_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields
    --	end record t_aeb_hk_adc_rd_data_hk_vodf_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG"
    --	type t_aeb_hk_adc_rd_data_hk_vog_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields
    --	end record t_aeb_hk_adc_rd_data_hk_vog_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD"
    --	type t_aeb_hk_adc_rd_data_hk_vrd_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields
    --	end record t_aeb_hk_adc_rd_data_hk_vrd_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF"
    --	type t_aeb_hk_adc_rd_data_s_ref_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields
    --	end record t_aeb_hk_adc_rd_data_s_ref_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P"
    --	type t_aeb_hk_adc_rd_data_t_bias_p_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields
    --	end record t_aeb_hk_adc_rd_data_t_bias_p_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD"
    --	type t_aeb_hk_adc_rd_data_t_ccd_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields
    --	end record t_aeb_hk_adc_rd_data_t_ccd_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P"
    --	type t_aeb_hk_adc_rd_data_t_hk_p_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields
    --	end record t_aeb_hk_adc_rd_data_t_hk_p_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA"
    --	type t_aeb_hk_adc_rd_data_t_ref1k_mea_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields
    --	end record t_aeb_hk_adc_rd_data_t_ref1k_mea_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA"
    --	type t_aeb_hk_adc_rd_data_t_ref649r_mea_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields
    --	end record t_aeb_hk_adc_rd_data_t_ref649r_mea_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P"
    --	type t_aeb_hk_adc_rd_data_t_tou_1_p_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields
    --	end record t_aeb_hk_adc_rd_data_t_tou_1_p_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P"
    --	type t_aeb_hk_adc_rd_data_t_tou_2_p_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields
    --	end record t_aeb_hk_adc_rd_data_t_tou_2_p_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L"
    --	type t_aeb_hk_adc_rd_data_t_vasp_l_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields
    --	end record t_aeb_hk_adc_rd_data_t_vasp_l_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R"
    --	type t_aeb_hk_adc_rd_data_t_vasp_r_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields
    --	end record t_aeb_hk_adc_rd_data_t_vasp_r_wr_reg;
    --
    -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3"
    --    type t_aeb_hk_adc1_rd_config_3_wr_reg is record
    --        others_1 : std_logic_vector(7 downto 0); -- "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields
    --    end record t_aeb_hk_adc1_rd_config_3_wr_reg;
    --
    --    -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3"
    --    type t_aeb_hk_adc2_rd_config_3_wr_reg is record
    --        others_1 : std_logic_vector(7 downto 0); -- "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields
    --    end record t_aeb_hk_adc2_rd_config_3_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "AEB_STATUS"
    --	type t_aeb_hk_aeb_status_wr_reg is record
    --		aeb_status : std_logic_vector(3 downto 0); -- "AEB_STATUS" Field
    --		others_0   : std_logic_vector(1 downto 0); -- VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields
    --		others_1   : std_logic_vector(11 downto 0); -- DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields
    --      others_2   : std_logic_vector(3 downto 0); -- "VASP2_DELAYED", "VASP1_DELAYED", "VASP2_ERROR", "VASP1_ERROR" Fields
    --	end record t_aeb_hk_aeb_status_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "REVISION_ID_1"
    --	type t_aeb_hk_revision_id_1_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- FPGA_VERSION, "FPGA_DATE" Fields
    --	end record t_aeb_hk_revision_id_1_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "REVISION_ID_2"
    --	type t_aeb_hk_revision_id_2_wr_reg is record
    --		others_0 : std_logic_vector(31 downto 0); -- FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields
    --	end record t_aeb_hk_revision_id_2_wr_reg;
    --
    --    -- AEB Housekeeping Area Register "REVISION_ID_3"
    --    type t_aeb_hk_revision_id_3_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED" Field
    --    end record t_aeb_hk_revision_id_3_wr_reg;
    --
    --    -- AEB Housekeeping Area Register "REVISION_ID_4"
    --    type t_aeb_hk_revision_id_4_wr_reg is record
    --        others_0 : std_logic_vector(31 downto 0); -- "RESERVED" Field
    --    end record t_aeb_hk_revision_id_4_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "TIMESTAMP_1"
    --	type t_aeb_hk_timestamp_1_wr_reg is record
    --		timestamp_dword_1 : std_logic_vector(31 downto 0); -- "TIMESTAMP_DWORD_1" Field
    --	end record t_aeb_hk_timestamp_1_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "TIMESTAMP_2"
    --	type t_aeb_hk_timestamp_2_wr_reg is record
    --		timestamp_dword_0 : std_logic_vector(31 downto 0); -- "TIMESTAMP_DWORD_0" Field
    --	end record t_aeb_hk_timestamp_2_wr_reg;
    --
    --	-- AEB Housekeeping Area Register "VASP_RD_CONFIG"
    --	type t_aeb_hk_vasp_rd_config_wr_reg is record
    --		others_0 : std_logic_vector(15 downto 0); -- VASP1_READ_DATA, "VASP2_READ_DATA" Fields
    --	end record t_aeb_hk_vasp_rd_config_wr_reg;

    -- Avalon MM Types

    -- Avalon MM Read/Write Registers
    type t_rmap_memory_wr_area is record
        --		aeb_crit_cfg_aeb_config_ait      : t_aeb_crit_cfg_aeb_config_ait_wr_reg; -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT"
        --		aeb_crit_cfg_aeb_config_key      : t_aeb_crit_cfg_aeb_config_key_wr_reg; -- AEB Critical Configuration Area Register "AEB_CONFIG_KEY"
        --		aeb_crit_cfg_aeb_config_pattern  : t_aeb_crit_cfg_aeb_config_pattern_wr_reg; -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN"
        --		aeb_crit_cfg_aeb_config          : t_aeb_crit_cfg_aeb_config_wr_reg; -- AEB Critical Configuration Area Register "AEB_CONFIG"
        --		aeb_crit_cfg_aeb_control         : t_aeb_crit_cfg_aeb_control_wr_reg; -- AEB Critical Configuration Area Register "AEB_CONTROL"
        --		aeb_crit_cfg_dac_config_1        : t_aeb_crit_cfg_dac_config_1_wr_reg; -- AEB Critical Configuration Area Register "DAC_CONFIG_1"
        --		aeb_crit_cfg_dac_config_2        : t_aeb_crit_cfg_dac_config_2_wr_reg; -- AEB Critical Configuration Area Register "DAC_CONFIG_2"
        --		aeb_crit_cfg_pwr_config1         : t_aeb_crit_cfg_pwr_config1_wr_reg; -- AEB Critical Configuration Area Register "PWR_CONFIG1"
        --		aeb_crit_cfg_pwr_config2         : t_aeb_crit_cfg_pwr_config2_wr_reg; -- AEB Critical Configuration Area Register "PWR_CONFIG2"
        --		aeb_crit_cfg_pwr_config3         : t_aeb_crit_cfg_pwr_config3_wr_reg; -- AEB Critical Configuration Area Register "PWR_CONFIG3"
        --		aeb_crit_cfg_reserved_20         : t_aeb_crit_cfg_reserved_20_wr_reg; -- AEB Critical Configuration Area Register "RESERVED_20"
        --		aeb_crit_cfg_vasp_i2c_control    : t_aeb_crit_cfg_vasp_i2c_control_wr_reg; -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL"
        aeb_gen_cfg_adc1_config_1 : t_aeb_gen_cfg_adc1_config_1_wr_reg; -- AEB General Configuration Area Register "ADC1_CONFIG_1"
        aeb_gen_cfg_adc1_config_2 : t_aeb_gen_cfg_adc1_config_2_wr_reg; -- AEB General Configuration Area Register "ADC1_CONFIG_2"
        aeb_gen_cfg_adc1_config_3 : t_aeb_gen_cfg_adc1_config_3_wr_reg; -- AEB General Configuration Area Register "ADC1_CONFIG_3"
        aeb_gen_cfg_adc2_config_1 : t_aeb_gen_cfg_adc2_config_1_wr_reg; -- AEB General Configuration Area Register "ADC2_CONFIG_1"
        aeb_gen_cfg_adc2_config_2 : t_aeb_gen_cfg_adc2_config_2_wr_reg; -- AEB General Configuration Area Register "ADC2_CONFIG_2"
        aeb_gen_cfg_adc2_config_3 : t_aeb_gen_cfg_adc2_config_3_wr_reg; -- AEB General Configuration Area Register "ADC2_CONFIG_3"
        --		aeb_gen_cfg_reserved_118         : t_aeb_gen_cfg_reserved_118_wr_reg; -- AEB General Configuration Area Register "RESERVED_118"
        --		aeb_gen_cfg_reserved_11c         : t_aeb_gen_cfg_reserved_11c_wr_reg; -- AEB General Configuration Area Register "RESERVED_11C"
        --      aeb_gen_cfg_seq_config_1         : t_aeb_gen_cfg_seq_config_1_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_1"
        --      aeb_gen_cfg_seq_config_2         : t_aeb_gen_cfg_seq_config_2_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_2"
        --      aeb_gen_cfg_seq_config_3         : t_aeb_gen_cfg_seq_config_3_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_3"
        --      aeb_gen_cfg_seq_config_4         : t_aeb_gen_cfg_seq_config_4_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_4"
        --      aeb_gen_cfg_seq_config_5         : t_aeb_gen_cfg_seq_config_5_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_5"
        --      aeb_gen_cfg_seq_config_6         : t_aeb_gen_cfg_seq_config_6_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_6"
        --      aeb_gen_cfg_seq_config_7         : t_aeb_gen_cfg_seq_config_7_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_7"
        --      aeb_gen_cfg_seq_config_8         : t_aeb_gen_cfg_seq_config_8_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_8"
        --      aeb_gen_cfg_seq_config_9         : t_aeb_gen_cfg_seq_config_9_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_9"
        --      aeb_gen_cfg_seq_config_10        : t_aeb_gen_cfg_seq_config_10_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_10"
        --      aeb_gen_cfg_seq_config_11        : t_aeb_gen_cfg_seq_config_11_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_11"
        --      aeb_gen_cfg_seq_config_12        : t_aeb_gen_cfg_seq_config_12_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_12"
        --      aeb_gen_cfg_seq_config_13        : t_aeb_gen_cfg_seq_config_13_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_13"
        --      aeb_gen_cfg_seq_config_14        : t_aeb_gen_cfg_seq_config_14_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_14"
        --      aeb_gen_cfg_seq_config_15        : t_aeb_gen_cfg_seq_config_15_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_15"
        --      aeb_gen_cfg_seq_config_16        : t_aeb_gen_cfg_seq_config_16_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_16"
        --      aeb_gen_cfg_seq_config_17        : t_aeb_gen_cfg_seq_config_17_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_17"
        --      aeb_gen_cfg_seq_config_18        : t_aeb_gen_cfg_seq_config_18_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_18"
        --      aeb_gen_cfg_seq_config_19        : t_aeb_gen_cfg_seq_config_19_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_19"
        --      aeb_gen_cfg_seq_config_20        : t_aeb_gen_cfg_seq_config_20_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_20"
        --      aeb_gen_cfg_seq_config_21        : t_aeb_gen_cfg_seq_config_21_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_21"
        --      aeb_gen_cfg_seq_config_22        : t_aeb_gen_cfg_seq_config_22_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_22"
        --      aeb_gen_cfg_seq_config_23        : t_aeb_gen_cfg_seq_config_23_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_23"
        --      aeb_gen_cfg_seq_config_24        : t_aeb_gen_cfg_seq_config_24_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_24"
        --      aeb_gen_cfg_seq_config_25        : t_aeb_gen_cfg_seq_config_25_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_25"
        --      aeb_gen_cfg_seq_config_26        : t_aeb_gen_cfg_seq_config_26_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_26"
        --      aeb_gen_cfg_seq_config_27        : t_aeb_gen_cfg_seq_config_27_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_27"
        --      aeb_gen_cfg_seq_config_28        : t_aeb_gen_cfg_seq_config_28_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_28"
        --      aeb_gen_cfg_seq_config_29        : t_aeb_gen_cfg_seq_config_29_wr_reg; -- AEB General Configuration Area Register "SEQ_CONFIG_29"
        --		aeb_hk_adc_rd_data_adc_ref_buf_2 : t_aeb_hk_adc_rd_data_adc_ref_buf_2_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2"
        --		aeb_hk_adc_rd_data_hk_ana_n5v    : t_aeb_hk_adc_rd_data_hk_ana_n5v_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V"
        --		aeb_hk_adc_rd_data_hk_ana_p3v3   : t_aeb_hk_adc_rd_data_hk_ana_p3v3_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3"
        --		aeb_hk_adc_rd_data_hk_ana_p5v    : t_aeb_hk_adc_rd_data_hk_ana_p5v_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V"
        --		aeb_hk_adc_rd_data_hk_ccd_p31v   : t_aeb_hk_adc_rd_data_hk_ccd_p31v_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V"
        --		aeb_hk_adc_rd_data_hk_clk_p15v   : t_aeb_hk_adc_rd_data_hk_clk_p15v_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V"
        --		aeb_hk_adc_rd_data_hk_dig_p3v3   : t_aeb_hk_adc_rd_data_hk_dig_p3v3_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3"
        --		aeb_hk_adc_rd_data_hk_vode       : t_aeb_hk_adc_rd_data_hk_vode_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE"
        --		aeb_hk_adc_rd_data_hk_vodf       : t_aeb_hk_adc_rd_data_hk_vodf_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF"
        --		aeb_hk_adc_rd_data_hk_vog        : t_aeb_hk_adc_rd_data_hk_vog_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG"
        --		aeb_hk_adc_rd_data_hk_vrd        : t_aeb_hk_adc_rd_data_hk_vrd_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD"
        --		aeb_hk_adc_rd_data_s_ref         : t_aeb_hk_adc_rd_data_s_ref_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF"
        --		aeb_hk_adc_rd_data_t_bias_p      : t_aeb_hk_adc_rd_data_t_bias_p_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P"
        --		aeb_hk_adc_rd_data_t_ccd         : t_aeb_hk_adc_rd_data_t_ccd_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD"
        --		aeb_hk_adc_rd_data_t_hk_p        : t_aeb_hk_adc_rd_data_t_hk_p_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P"
        --		aeb_hk_adc_rd_data_t_ref1k_mea   : t_aeb_hk_adc_rd_data_t_ref1k_mea_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA"
        --		aeb_hk_adc_rd_data_t_ref649r_mea : t_aeb_hk_adc_rd_data_t_ref649r_mea_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA"
        --		aeb_hk_adc_rd_data_t_tou_1_p     : t_aeb_hk_adc_rd_data_t_tou_1_p_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P"
        --		aeb_hk_adc_rd_data_t_tou_2_p     : t_aeb_hk_adc_rd_data_t_tou_2_p_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P"
        --		aeb_hk_adc_rd_data_t_vasp_l      : t_aeb_hk_adc_rd_data_t_vasp_l_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L"
        --		aeb_hk_adc_rd_data_t_vasp_r      : t_aeb_hk_adc_rd_data_t_vasp_r_wr_reg; -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R"
        --		aeb_hk_aeb_status                : t_aeb_hk_aeb_status_wr_reg; -- AEB Housekeeping Area Register "AEB_STATUS"
        --      aeb_hk_adc1_rd_config_3          : t_aeb_hk_adc1_rd_config_3_wr_reg; -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3"
        --      aeb_hk_adc2_rd_config_3          : t_aeb_hk_adc2_rd_config_3_wr_reg; -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3"
        --		aeb_hk_revision_id_1             : t_aeb_hk_revision_id_1_wr_reg; -- AEB Housekeeping Area Register "REVISION_ID_1"
        --		aeb_hk_revision_id_2             : t_aeb_hk_revision_id_2_wr_reg; -- AEB Housekeeping Area Register "REVISION_ID_2"
        --      aeb_hk_revision_id_3             : t_aeb_hk_revision_id_3_wr_reg; -- AEB Housekeeping Area Register "REVISION_ID_3"
        --      aeb_hk_revision_id_4             : t_aeb_hk_revision_id_4_wr_reg; -- AEB Housekeeping Area Register "REVISION_ID_4"
        --		aeb_hk_timestamp_1               : t_aeb_hk_timestamp_1_wr_reg; -- AEB Housekeeping Area Register "TIMESTAMP_1"
        --		aeb_hk_timestamp_2               : t_aeb_hk_timestamp_2_wr_reg; -- AEB Housekeeping Area Register "TIMESTAMP_2"
        --		aeb_hk_vasp_rd_config            : t_aeb_hk_vasp_rd_config_wr_reg; -- AEB Housekeeping Area Register "VASP_RD_CONFIG"
    end record t_rmap_memory_wr_area;

    -- Avalon MM Read-Only Registers
    type t_rmap_memory_rd_area is record
        aeb_hk_adc1_rd_config_1 : t_aeb_hk_adc1_rd_config_1_rd_reg; -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_1"
        aeb_hk_adc1_rd_config_2 : t_aeb_hk_adc1_rd_config_2_rd_reg; -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_2"
        aeb_hk_adc1_rd_config_3 : t_aeb_hk_adc1_rd_config_3_rd_reg; -- AEB Housekeeping Area Register "ADC1_RD_CONFIG_3"
        aeb_hk_adc2_rd_config_1 : t_aeb_hk_adc2_rd_config_1_rd_reg; -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_1"
        aeb_hk_adc2_rd_config_2 : t_aeb_hk_adc2_rd_config_2_rd_reg; -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_2"
        aeb_hk_adc2_rd_config_3 : t_aeb_hk_adc2_rd_config_3_rd_reg; -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_3"
        --        aeb_hk_adc2_rd_config_4 : t_aeb_hk_adc2_rd_config_4_rd_reg; -- AEB Housekeeping Area Register "ADC2_RD_CONFIG_4"
        aeb_hk_sync_period_1_2  : t_aeb_hk_sync_period_1_2_rd_reg; -- AEB Housekeeping Area Register "SYNC_PERIOD_1" and "SYNC_PERIOD_2" 
    end record t_rmap_memory_rd_area;

end package farm_rmap_mem_area_ffee_aeb_pkg;

package body farm_rmap_mem_area_ffee_aeb_pkg is
end package body farm_rmap_mem_area_ffee_aeb_pkg;
