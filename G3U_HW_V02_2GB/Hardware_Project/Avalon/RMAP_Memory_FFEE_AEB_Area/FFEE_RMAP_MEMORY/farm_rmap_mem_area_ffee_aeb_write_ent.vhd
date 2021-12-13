library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.farm_rmap_mem_area_ffee_aeb_pkg.all;
use work.farm_avalon_mm_rmap_ffee_aeb_pkg.all;

entity farm_rmap_mem_area_ffee_aeb_write_ent is
    port(
        clk_i                   : in  std_logic;
        rst_i                   : in  std_logic;
        fee_rmap_i              : in  t_farm_ffee_aeb_rmap_write_in;
        avalon_mm_rmap_i        : in  t_farm_avalon_mm_rmap_ffee_aeb_write_in;
        memarea_idle_i          : in  std_logic;
        memarea_wrdone_i        : in  std_logic;
        fee_rmap_o              : out t_farm_ffee_aeb_rmap_write_out;
        avalon_mm_rmap_o        : out t_farm_avalon_mm_rmap_ffee_aeb_write_out;
        rmap_registers_wr_o     : out t_rmap_memory_wr_area;
        ram_mem_direct_access_o : out t_ram_mem_direct_access;
        memarea_wraddress_o     : out std_logic_vector(6 downto 0);
        memarea_wrbyteenable_o  : out std_logic_vector(3 downto 0);
        memarea_wrbitmask_o     : out std_logic_vector(31 downto 0);
        memarea_wrdata_o        : out std_logic_vector(31 downto 0);
        memarea_write_o         : out std_logic
    );
end entity farm_rmap_mem_area_ffee_aeb_write_ent;

architecture RTL of farm_rmap_mem_area_ffee_aeb_write_ent is

    signal s_write_started     : std_logic;
    signal s_write_in_progress : std_logic;
    signal s_write_finished    : std_logic;

    signal s_data_registered : std_logic;

    signal s_ram_mem_direct_access : t_ram_mem_direct_access;

begin

    p_farm_rmap_mem_area_ffee_aeb_write : process(clk_i, rst_i) is
        procedure p_rmap_ram_wr(
            constant RMAP_ADDRESS_I     : in std_logic_vector;
            constant RMAP_BYTEENABLE_I  : in std_logic_vector;
            constant RMAP_BITMASK_I     : in std_logic_vector;
            constant RMAP_WRITEDATA_I   : in std_logic_vector;
            signal   rmap_waitrequest_o : out std_logic
        ) is
        begin
            memarea_wraddress_o    <= (others => '0');
            memarea_wrbyteenable_o <= (others => '1');
            memarea_wrbitmask_o    <= (others => '1');
            memarea_wrdata_o       <= (others => '0');
            memarea_write_o        <= '0';
            -- check if a write was finished    
            if (s_write_finished = '1') then
                -- a write was finished
                -- keep setted the write finished flag
                s_write_finished   <= '1';
                -- keep cleared the waitrequest flag
                rmap_waitrequest_o <= '0';
            else
                -- check if a write is not in progress and was not just started
                if ((s_write_in_progress = '0') and (s_write_started = '0')) then
                    -- a write is not in progress
                    -- check if the mem aerea is on idle (can receive commands)
                    if (memarea_idle_i = '1') then
                        -- the mem aerea is on idle (can receive commands)
                        -- send write to mem area
                        memarea_wraddress_o    <= RMAP_ADDRESS_I((memarea_wraddress_o'length - 1) downto 0);
                        memarea_wrbyteenable_o <= RMAP_BYTEENABLE_I((memarea_wrbyteenable_o'length - 1) downto 0);
                        memarea_wrbitmask_o    <= RMAP_BITMASK_I((memarea_wrbitmask_o'length - 1) downto 0);
                        memarea_wrdata_o       <= RMAP_WRITEDATA_I((memarea_wrdata_o'length - 1) downto 0);
                        memarea_write_o        <= '1';
                        -- set the write started flag
                        s_write_started        <= '1';
                        -- set the write in progress flag
                        s_write_in_progress    <= '1';
                    end if;
                -- check if a write is in progress and was just started    
                elsif ((s_write_in_progress = '1') and (s_write_started = '1')) then
                    -- clear the write started flag
                    s_write_started     <= '0';
                    -- keep setted the write in progress flag
                    s_write_in_progress <= '1';
                -- check if a write is in progress and was not just started    
                elsif ((s_write_in_progress = '1') and (s_write_started = '0')) then
                    -- a write is in progress
                    -- keep setted the write in progress flag
                    s_write_in_progress <= '1';
                    -- check if the write is done
                    if ((memarea_wrdone_i = '1') or (memarea_idle_i = '1')) then
                        -- the write is done
                        -- clear the write in progress flag
                        s_write_in_progress <= '0';
                        -- set the write finished flag
                        s_write_finished    <= '1';
                        -- clear the waitrequest flag
                        rmap_waitrequest_o  <= '0';
                    end if;
                end if;
            end if;
        end procedure p_rmap_ram_wr;
        --
        procedure p_ffee_aeb_reg_reset is
        begin

            -- Write Registers Reset/Default State

            -- AEB General Configuration Area Register "ADC1_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
            rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.others_0 <= x"5640003F";
            -- AEB General Configuration Area Register "ADC1_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
            rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.others_0 <= x"00F00000";
            -- AEB General Configuration Area Register "ADC1_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
            rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.others_0 <= (others => '0');
            -- AEB General Configuration Area Register "ADC2_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
            rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.others_0 <= x"5640008F";
            -- AEB General Configuration Area Register "ADC2_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
            rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.others_0 <= x"003F0000";
            -- AEB General Configuration Area Register "ADC2_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
            rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.others_0 <= (others => '0');

        end procedure p_ffee_aeb_reg_reset;
        --
        procedure p_ffee_aeb_reg_trigger is
        begin

            -- Write Registers Triggers Reset

        end procedure p_ffee_aeb_reg_trigger;
        --
        procedure p_ffee_aeb_mem_wr(wr_addr_i : std_logic_vector) is
            variable v_ram_address    : std_logic_vector(6 downto 0)  := (others => '0');
            variable v_ram_byteenable : std_logic_vector(3 downto 0)  := (others => '1');
            constant c_RAM_BITMASK    : std_logic_vector(31 downto 0) := (others => '1');
            variable v_ram_writedata  : std_logic_vector(31 downto 0) := (others => '0');
        begin

            -- MemArea Write Data
            case (wr_addr_i(31 downto 0)) is
                -- Case for access to all memory area

                when (x"00000000") =>
                    -- AEB Critical Configuration Area Register "AEB_CONTROL" : "AEB_RESET" Field
                    -- AEB Critical Configuration Area Register "AEB_CONTROL" : "SET_STATE" Field
                    -- AEB Critical Configuration Area Register "AEB_CONTROL" : "NEW_STATE" Field
                    -- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED" Field
                    v_ram_address                 := "0000000";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000001") =>
                    -- AEB Critical Configuration Area Register "AEB_CONTROL" : RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields
                    v_ram_address                 := "0000000";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000002") =>
                    -- AEB Critical Configuration Area Register "AEB_CONTROL" : RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields
                    v_ram_address                := "0000000";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000003") =>
                    -- AEB Critical Configuration Area Register "AEB_CONTROL" : RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields
                    v_ram_address               := "0000000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000004") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG" : RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields
                    v_ram_address                 := "0000001";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000005") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG" : RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields
                    v_ram_address                 := "0000001";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000006") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG" : RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields
                    v_ram_address                := "0000001";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000007") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG" : RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields
                    v_ram_address               := "0000001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000008") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
                    v_ram_address                 := "0000010";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000009") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
                    v_ram_address                 := "0000010";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000A") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
                    v_ram_address                := "0000010";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000B") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
                    v_ram_address               := "0000010";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000C") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : OVERRIDE_SW, "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields
                    v_ram_address                 := "0000011";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000D") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : OVERRIDE_SW, "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields
                    v_ram_address                 := "0000011";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000E") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : OVERRIDE_SW, "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields
                    v_ram_address                := "0000011";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000F") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : OVERRIDE_SW, "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields
                    v_ram_address               := "0000011";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000010") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_COLS" Field
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_CCDID" Field
                    v_ram_address                 := "0000100";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000011") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_COLS" Field
                    v_ram_address                 := "0000100";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000012") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_ROWS" Field
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "RESERVED" Field
                    v_ram_address                := "0000100";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000013") =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_ROWS" Field
                    v_ram_address               := "0000100";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000014") =>
                    -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields
                    v_ram_address                 := "0000101";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000015") =>
                    -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields
                    v_ram_address                 := "0000101";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000016") =>
                    -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields
                    v_ram_address                := "0000101";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000017") =>
                    -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields
                    v_ram_address               := "0000101";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000018") =>
                    -- AEB Critical Configuration Area Register "DAC_CONFIG_1" : RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields
                    v_ram_address                 := "0000110";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000019") =>
                    -- AEB Critical Configuration Area Register "DAC_CONFIG_1" : RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields
                    v_ram_address                 := "0000110";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001A") =>
                    -- AEB Critical Configuration Area Register "DAC_CONFIG_1" : RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields
                    v_ram_address                := "0000110";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001B") =>
                    -- AEB Critical Configuration Area Register "DAC_CONFIG_1" : RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields
                    v_ram_address               := "0000110";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001C") =>
                    -- AEB Critical Configuration Area Register "DAC_CONFIG_2" : RESERVED_0, "DAC_VOD", "RESERVED_1" Fields
                    v_ram_address                 := "0000111";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001D") =>
                    -- AEB Critical Configuration Area Register "DAC_CONFIG_2" : RESERVED_0, "DAC_VOD", "RESERVED_1" Fields
                    v_ram_address                 := "0000111";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001E") =>
                    -- AEB Critical Configuration Area Register "DAC_CONFIG_2" : RESERVED_0, "DAC_VOD", "RESERVED_1" Fields
                    v_ram_address                := "0000111";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001F") =>
                    -- AEB Critical Configuration Area Register "DAC_CONFIG_2" : RESERVED_0, "DAC_VOD", "RESERVED_1" Fields
                    v_ram_address               := "0000111";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000020") =>
                    -- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
                    v_ram_address                 := "0001000";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000021") =>
                    -- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
                    v_ram_address                 := "0001000";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000022") =>
                    -- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
                    v_ram_address                := "0001000";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000023") =>
                    -- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
                    v_ram_address               := "0001000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000024") =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCCD_ON" Field
                    v_ram_address                 := "0001001";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000025") =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCLK_ON" Field
                    v_ram_address                 := "0001001";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000026") =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN1_ON" Field
                    v_ram_address                := "0001001";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000027") =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN2_ON" Field
                    v_ram_address               := "0001001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000028") =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN3_ON" Field
                    v_ram_address                 := "0001010";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000029") =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCCD_OFF" Field
                    v_ram_address                 := "0001010";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000002A") =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCLK_OFF" Field
                    v_ram_address                := "0001010";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000002B") =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN1_OFF" Field
                    v_ram_address               := "0001010";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000002C") =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN2_OFF" Field
                    v_ram_address                 := "0001011";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000002D") =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN3_OFF" Field
                    v_ram_address                 := "0001011";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000100") =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.others_0(31 downto 24) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000101") =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.others_0(23 downto 16) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000102") =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.others_0(15 downto 8) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000103") =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.others_0(7 downto 0) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000104") =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.others_0(31 downto 24) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000105") =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.others_0(23 downto 16) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000106") =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.others_0(15 downto 8) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000107") =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.others_0(7 downto 0) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000108") =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.others_0(31 downto 24) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000109") =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.others_0(23 downto 16) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"0000010A") =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.others_0(15 downto 8) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"0000010B") =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.others_0(7 downto 0) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"0000010C") =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.others_0(31 downto 24) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"0000010D") =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.others_0(23 downto 16) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"0000010E") =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.others_0(15 downto 8) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"0000010F") =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.others_0(7 downto 0) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000110") =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.others_0(31 downto 24) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000111") =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.others_0(23 downto 16) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000112") =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.others_0(15 downto 8) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000113") =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.others_0(7 downto 0) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000114") =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.others_0(31 downto 24) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000115") =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.others_0(23 downto 16) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000116") =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.others_0(15 downto 8) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000117") =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.others_0(7 downto 0) <= fee_rmap_i.writedata;
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"00000118") =>
                    -- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
                    v_ram_address                 := "0010010";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000119") =>
                    -- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
                    v_ram_address                 := "0010010";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000011A") =>
                    -- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
                    v_ram_address                := "0010010";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000011B") =>
                    -- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
                    v_ram_address               := "0010010";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000011C") =>
                    -- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
                    v_ram_address                 := "0010011";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000011D") =>
                    -- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
                    v_ram_address                 := "0010011";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000011E") =>
                    -- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
                    v_ram_address                := "0010011";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000011F") =>
                    -- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
                    v_ram_address               := "0010011";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000120") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields
                    v_ram_address                 := "0010100";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000121") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields
                    v_ram_address                 := "0010100";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000122") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields
                    v_ram_address                := "0010100";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000123") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields
                    v_ram_address               := "0010100";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000124") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_2" : ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields
                    v_ram_address                 := "0010101";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000125") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_2" : ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields
                    v_ram_address                 := "0010101";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000126") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_2" : ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields
                    v_ram_address                := "0010101";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000127") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_2" : ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields
                    v_ram_address               := "0010101";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000128") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_3" : RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields
                    v_ram_address                 := "0010110";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000129") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_3" : RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields
                    v_ram_address                 := "0010110";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000012A") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_3" : RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields
                    v_ram_address                := "0010110";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000012B") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_3" : RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields
                    v_ram_address               := "0010110";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000012C") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_4" : RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields
                    v_ram_address                 := "0010111";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000012D") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_4" : RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields
                    v_ram_address                 := "0010111";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000012E") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_4" : RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields
                    v_ram_address                := "0010111";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000012F") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_4" : RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields
                    v_ram_address               := "0010111";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000130") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_5" : SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields
                    v_ram_address                 := "0011000";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000131") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_5" : SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields
                    v_ram_address                 := "0011000";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000132") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_5" : SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields
                    v_ram_address                := "0011000";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000133") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_5" : SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields
                    v_ram_address               := "0011000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000134") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields
                    v_ram_address                 := "0011001";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000135") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields
                    v_ram_address                 := "0011001";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000136") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields
                    v_ram_address                := "0011001";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000137") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields
                    v_ram_address               := "0011001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000138") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields
                    v_ram_address                 := "0011010";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000139") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields
                    v_ram_address                 := "0011010";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000013A") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields
                    v_ram_address                := "0011010";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000013B") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields
                    v_ram_address               := "0011010";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000013C") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields
                    v_ram_address                 := "0011011";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000013D") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields
                    v_ram_address                 := "0011011";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000013E") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields
                    v_ram_address                := "0011011";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000013F") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields
                    v_ram_address               := "0011011";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000140") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields
                    v_ram_address                 := "0011100";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000141") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields
                    v_ram_address                 := "0011100";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000142") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields
                    v_ram_address                := "0011100";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000143") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields
                    v_ram_address               := "0011100";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000144") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields
                    v_ram_address                 := "0011101";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000145") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields
                    v_ram_address                 := "0011101";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000146") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields
                    v_ram_address                := "0011101";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000147") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields
                    v_ram_address               := "0011101";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000148") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields
                    v_ram_address                 := "0011110";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000149") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields
                    v_ram_address                 := "0011110";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000014A") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields
                    v_ram_address                := "0011110";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000014B") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields
                    v_ram_address               := "0011110";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000014C") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields
                    v_ram_address                 := "0011111";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000014D") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields
                    v_ram_address                 := "0011111";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000014E") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields
                    v_ram_address                := "0011111";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000014F") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields
                    v_ram_address               := "0011111";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000150") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields
                    v_ram_address                 := "0100000";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000151") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields
                    v_ram_address                 := "0100000";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000152") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields
                    v_ram_address                := "0100000";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000153") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields
                    v_ram_address               := "0100000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000154") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields
                    v_ram_address                 := "0100001";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000155") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields
                    v_ram_address                 := "0100001";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000156") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields
                    v_ram_address                := "0100001";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000157") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields
                    v_ram_address               := "0100001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000158") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_15" : "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields
                    v_ram_address                 := "1010000";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000159") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_15" : "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields
                    v_ram_address                 := "1010000";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000015A") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_15" : "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields
                    v_ram_address                := "1010000";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000015B") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_15" : "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields
                    v_ram_address               := "1010000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000015C") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_16" : "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields
                    v_ram_address                 := "1010001";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000015D") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_16" : "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields
                    v_ram_address                 := "1010001";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000015E") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_16" : "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields
                    v_ram_address                := "1010001";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000015F") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_16" : "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields
                    v_ram_address               := "1010001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000160") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_17" : "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields
                    v_ram_address                 := "1010010";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000161") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_17" : "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields
                    v_ram_address                 := "1010010";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000162") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_17" : "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields
                    v_ram_address                := "1010010";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000163") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_17" : "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields
                    v_ram_address               := "1010010";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000164") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_18" : "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields
                    v_ram_address                 := "1010011";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000165") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_18" : "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields
                    v_ram_address                 := "1010011";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000166") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_18" : "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields
                    v_ram_address                := "1010011";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000167") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_18" : "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields
                    v_ram_address               := "1010011";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000168") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_19" : "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields
                    v_ram_address                 := "1010100";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000169") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_19" : "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields
                    v_ram_address                 := "1010100";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000016A") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_19" : "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields
                    v_ram_address                := "1010100";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000016B") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_19" : "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields
                    v_ram_address               := "1010100";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000016C") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_20" : "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields
                    v_ram_address                 := "1010101";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000016D") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_20" : "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields
                    v_ram_address                 := "1010101";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000016E") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_20" : "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields
                    v_ram_address                := "1010101";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000016F") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_20" : "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields
                    v_ram_address               := "1010101";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000170") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_21" : "RESERVED" Field
                    v_ram_address                 := "1010110";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000171") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_21" : "RESERVED" Field
                    v_ram_address                 := "1010110";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000172") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_21" : "RESERVED" Field
                    v_ram_address                := "1010110";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000173") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_21" : "RESERVED" Field
                    v_ram_address               := "1010110";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000174") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_22" : "RESERVED" Field
                    v_ram_address                 := "1010111";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000175") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_22" : "RESERVED" Field
                    v_ram_address                 := "1010111";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000176") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_22" : "RESERVED" Field
                    v_ram_address                := "1010111";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000177") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_22" : "RESERVED" Field
                    v_ram_address               := "1010111";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000178") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_23" : "RESERVED" Field
                    v_ram_address                 := "1011000";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000179") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_23" : "RESERVED" Field
                    v_ram_address                 := "1011000";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000017A") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_23" : "RESERVED" Field
                    v_ram_address                := "1011000";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000017B") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_23" : "RESERVED" Field
                    v_ram_address               := "1011000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000017C") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_24" : "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields
                    v_ram_address                 := "1011001";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000017D") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_24" : "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields
                    v_ram_address                 := "1011001";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000017E") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_24" : "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields
                    v_ram_address                := "1011001";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000017F") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_24" : "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields
                    v_ram_address               := "1011001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000180") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_25" : "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields
                    v_ram_address                 := "1011010";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000181") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_25" : "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields
                    v_ram_address                 := "1011010";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000182") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_25" : "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields
                    v_ram_address                := "1011010";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000183") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_25" : "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields
                    v_ram_address               := "1011010";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000184") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_26" : "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields
                    v_ram_address                 := "1011011";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000185") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_26" : "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields
                    v_ram_address                 := "1011011";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000186") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_26" : "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields
                    v_ram_address                := "1011011";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000187") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_26" : "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields
                    v_ram_address               := "1011011";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000188") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_27" : "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields
                    v_ram_address                 := "1011100";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000189") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_27" : "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields
                    v_ram_address                 := "1011100";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000018A") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_27" : "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields
                    v_ram_address                := "1011100";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000018B") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_27" : "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields
                    v_ram_address               := "1011100";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000018C") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_28" : "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields
                    v_ram_address                 := "1011101";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000018D") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_28" : "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields
                    v_ram_address                 := "1011101";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000018E") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_28" : "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields
                    v_ram_address                := "1011101";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000018F") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_28" : "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields
                    v_ram_address               := "1011101";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000190") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_29" : "RESERVED" Field
                    v_ram_address                 := "1011110";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000191") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_29" : "RESERVED" Field
                    v_ram_address                 := "1011110";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000192") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_29" : "RESERVED" Field
                    v_ram_address                := "1011110";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000193") =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_29" : "RESERVED" Field
                    v_ram_address               := "1011110";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when others =>
                    fee_rmap_o.waitrequest <= '0';

            end case;

        end procedure p_ffee_aeb_mem_wr;
        --
        procedure p_avs_writedata(write_address_i : t_farm_avalon_mm_rmap_ffee_aeb_address) is
            variable v_ram_address    : std_logic_vector(6 downto 0)  := (others => '0');
            variable v_ram_byteenable : std_logic_vector(3 downto 0)  := (others => '1');
            variable v_ram_wrbitmask  : std_logic_vector(31 downto 0) := (others => '1');
            variable v_ram_writedata  : std_logic_vector(31 downto 0) := (others => '0');
        begin

            -- Registers Write Data
            case (write_address_i) is
                -- Case for access to all registers address

                when (16#000#) =>
                    -- AEB Critical Configuration Area Register "AEB_CONTROL" : "RESERVED" Field
                    v_ram_address                 := "0000000";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 30) := (others => '1');
                    v_ram_writedata(31 downto 30) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#001#) =>
                    -- AEB Critical Configuration Area Register "AEB_CONTROL" : "NEW_STATE" Field
                    v_ram_address                 := "0000000";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(29 downto 26) := (others => '1');
                    v_ram_writedata(29 downto 26) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#002#) =>
                    -- AEB Critical Configuration Area Register "AEB_CONTROL" : "SET_STATE" Field
                    v_ram_address       := "0000000";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(25) := '1';
                    v_ram_writedata(25) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#003#) =>
                    -- AEB Critical Configuration Area Register "AEB_CONTROL" : "AEB_RESET" Field
                    v_ram_address       := "0000000";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(24) := '1';
                    v_ram_writedata(24) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#004#) =>
                    -- AEB Critical Configuration Area Register "AEB_CONTROL" : RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields
                    v_ram_address                := "0000000";
                    v_ram_byteenable             := "0111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(23 downto 0) := avalon_mm_rmap_i.writedata(23 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#005#) =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG" : RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields
                    v_ram_address                := "0000001";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#006#) =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_KEY" : "KEY" Field
                    v_ram_address                := "0000010";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#007#) =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_AIT" : OVERRIDE_SW, "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields
                    v_ram_address                := "0000011";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#008#) =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_CCDID" Field
                    v_ram_address                 := "0000100";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(31 downto 30) := (others => '1');
                    v_ram_writedata(31 downto 30) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#009#) =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_COLS" Field
                    v_ram_address                 := "0000100";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(29 downto 16) := (others => '1');
                    v_ram_writedata(29 downto 16) := avalon_mm_rmap_i.writedata(13 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#00A#) =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "RESERVED" Field
                    v_ram_address                 := "0000100";
                    v_ram_byteenable              := "0010";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(15 downto 14) := (others => '1');
                    v_ram_writedata(15 downto 14) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#00B#) =>
                    -- AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" : "PATTERN_ROWS" Field
                    v_ram_address                := "0000100";
                    v_ram_byteenable             := "0011";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(13 downto 0) := (others => '1');
                    v_ram_writedata(13 downto 0) := avalon_mm_rmap_i.writedata(13 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#00C#) =>
                    -- AEB Critical Configuration Area Register "VASP_I2C_CONTROL" : VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields
                    v_ram_address                := "0000101";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#00D#) =>
                    -- AEB Critical Configuration Area Register "DAC_CONFIG_1" : RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields
                    v_ram_address                := "0000110";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#00E#) =>
                    -- AEB Critical Configuration Area Register "DAC_CONFIG_2" : RESERVED_0, "DAC_VOD", "RESERVED_1" Fields
                    v_ram_address                := "0000111";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#00F#) =>
                    -- AEB Critical Configuration Area Register "RESERVED_20" : "RESERVED" Field
                    v_ram_address                := "0001000";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#010#) =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCCD_ON" Field
                    v_ram_address                 := "0001001";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#011#) =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VCLK_ON" Field
                    v_ram_address                 := "0001001";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#012#) =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN1_ON" Field
                    v_ram_address                := "0001001";
                    v_ram_byteenable             := "0010";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#013#) =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG1" : "TIME_VAN2_ON" Field
                    v_ram_address               := "0001001";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '1');
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#014#) =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN3_ON" Field
                    v_ram_address                 := "0001010";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#015#) =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCCD_OFF" Field
                    v_ram_address                 := "0001010";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#016#) =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VCLK_OFF" Field
                    v_ram_address                := "0001010";
                    v_ram_byteenable             := "0010";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#017#) =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG2" : "TIME_VAN1_OFF" Field
                    v_ram_address               := "0001010";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '1');
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#018#) =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN2_OFF" Field
                    v_ram_address                 := "0001011";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#019#) =>
                    -- AEB Critical Configuration Area Register "PWR_CONFIG3" : "TIME_VAN3_OFF" Field
                    v_ram_address                 := "0001011";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#01A#) =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_1.others_0 <= avalon_mm_rmap_i.writedata;
                    end if;
                    s_data_registered            <= '1';
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#01B#) =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_2.others_0 <= avalon_mm_rmap_i.writedata;
                    end if;
                    s_data_registered            <= '1';
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#01C#) =>
                    -- AEB General Configuration Area Register "ADC1_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc1_config_3.others_0 <= avalon_mm_rmap_i.writedata;
                    end if;
                    s_data_registered            <= '1';
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#01D#) =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_1" : RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_1.others_0 <= avalon_mm_rmap_i.writedata;
                    end if;
                    s_data_registered            <= '1';
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#01E#) =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_2" : AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_2.others_0 <= avalon_mm_rmap_i.writedata;
                    end if;
                    s_data_registered            <= '1';
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#01F#) =>
                    -- AEB General Configuration Area Register "ADC2_CONFIG_3" : DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.aeb_gen_cfg_adc2_config_3.others_0 <= avalon_mm_rmap_i.writedata;
                    end if;
                    s_data_registered            <= '1';
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#020#) =>
                    -- AEB General Configuration Area Register "RESERVED_118" : "RESERVED" Field
                    v_ram_address                := "0010010";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#021#) =>
                    -- AEB General Configuration Area Register "RESERVED_11C" : "RESERVED" Field
                    v_ram_address                := "0010011";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#022#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_1" : "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields
                    v_ram_address                := "0010100";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#023#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_2" : ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields
                    v_ram_address                := "0010101";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#024#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_3" : RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields
                    v_ram_address                := "0010110";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#025#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_4" : RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields
                    v_ram_address                := "0010111";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#026#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_5" : SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields
                    v_ram_address                := "0011000";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#027#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_6" : "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields
                    v_ram_address                := "0011001";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#028#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_7" : "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields
                    v_ram_address                := "0011010";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#029#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_8" : "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields
                    v_ram_address                := "0011011";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#02A#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_9" : "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields
                    v_ram_address                := "0011100";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#02B#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_10" : "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields
                    v_ram_address                := "0011101";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#02C#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_11" : "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields
                    v_ram_address                := "0011110";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#02D#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_12" : "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields
                    v_ram_address                := "0011111";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#02E#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_13" : "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields
                    v_ram_address                := "0100000";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#02F#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_14" : "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields
                    v_ram_address                := "0100001";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#030#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_15" : "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields
                    v_ram_address                := "1010000";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#031#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_16" : "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields
                    v_ram_address                := "1010001";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#032#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_17" : "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields
                    v_ram_address                := "1010010";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#033#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_18" : "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields
                    v_ram_address                := "1010011";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#034#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_19" : "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields
                    v_ram_address                := "1010100";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#035#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_20" : "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields
                    v_ram_address                := "1010101";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#036#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_21" : "RESERVED" Field
                    v_ram_address                := "1010110";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#037#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_22" : "RESERVED" Field
                    v_ram_address                := "1010111";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#038#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_23" : "RESERVED" Field
                    v_ram_address                := "1011000";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#039#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_24" : "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields
                    v_ram_address                := "1011001";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#03A#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_25" : "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields
                    v_ram_address                := "1011010";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#03B#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_26" : "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields
                    v_ram_address                := "1011011";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#03C#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_27" : "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields
                    v_ram_address                := "1011100";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#03D#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_28" : "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields
                    v_ram_address                := "1011101";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#03E#) =>
                    -- AEB General Configuration Area Register "SEQ_CONFIG_29" : "RESERVED" Field
                    v_ram_address                := "1011110";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#03F#) =>
                    -- AEB Housekeeping Area Register "AEB_STATUS" : "AEB_STATUS" Field
                    v_ram_address                 := "0100010";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(27 downto 24) := (others => '1');
                    v_ram_writedata(27 downto 24) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#040#) =>
                    -- AEB Housekeeping Area Register "AEB_STATUS" : VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields
                    v_ram_address                 := "0100010";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(23 downto 22) := (others => '1');
                    v_ram_writedata(23 downto 22) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#041#) =>
                    -- AEB Housekeeping Area Register "AEB_STATUS" : DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields
                    v_ram_address                := "0100010";
                    v_ram_byteenable             := "0110";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(19 downto 8) := (others => '1');
                    v_ram_writedata(19 downto 8) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#042#) =>
                    -- AEB Housekeeping Area Register "AEB_STATUS" : "VASP2_DELAYED", "VASP1_DELAYED", "VASP2_ERROR", "VASP1_ERROR" Fields
                    v_ram_address               := "0100010";
                    v_ram_byteenable            := "0110";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(3 downto 0) := (others => '1');
                    v_ram_writedata(3 downto 0) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#043#) =>
                    -- AEB Housekeeping Area Register "TIMESTAMP_1" : "TIMESTAMP_DWORD_1" Field
                    v_ram_address                := "0100100";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#044#) =>
                    -- AEB Housekeeping Area Register "TIMESTAMP_2" : "TIMESTAMP_DWORD_0" Field
                    v_ram_address                := "0100101";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#045#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields
                    v_ram_address                := "0100110";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#046#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields
                    v_ram_address                := "0100111";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#047#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields
                    v_ram_address                := "0101000";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#048#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields
                    v_ram_address                := "0101001";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#049#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields
                    v_ram_address                := "0101010";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#04A#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields
                    v_ram_address                := "0101011";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#04B#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields
                    v_ram_address                := "0101100";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#04C#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields
                    v_ram_address                := "0101101";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#04D#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields
                    v_ram_address                := "0101110";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#04E#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields
                    v_ram_address                := "0101111";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#04F#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields
                    v_ram_address                := "0110000";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#050#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields
                    v_ram_address                := "0110001";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#051#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields
                    v_ram_address                := "0110010";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#052#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields
                    v_ram_address                := "0110011";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#053#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields
                    v_ram_address                := "0110100";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#054#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields
                    v_ram_address                := "0110101";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#055#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields
                    v_ram_address                := "0110110";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#056#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields
                    v_ram_address                := "0110111";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#057#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields
                    v_ram_address                := "0111000";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#058#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields
                    v_ram_address                := "0111001";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#059#) =>
                    -- AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" : NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields
                    v_ram_address                := "0111010";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#069#) =>
                    -- AEB Housekeeping Area Register "VASP_RD_CONFIG" : VASP1_READ_DATA, "VASP2_READ_DATA" Fields
                    v_ram_address                 := "1001010";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '1');
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 16) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#06C#) =>
                    -- AEB Housekeeping Area Register "REVISION_ID_1" : FPGA_VERSION, "FPGA_DATE" Fields
                    v_ram_address                := "1001011";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#06D#) =>
                    -- AEB Housekeeping Area Register "REVISION_ID_2" : FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields
                    v_ram_address                := "1001100";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#070#) =>
                    -- RAM Memory Control - Address
                    if (s_data_registered = '0') then
                        s_ram_mem_direct_access.addr <= avalon_mm_rmap_i.writedata;
                    end if;
                    s_data_registered            <= '1';
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#071#) =>
                    -- RAM Memory Control - Data
                    v_ram_address    := s_ram_mem_direct_access.addr((v_ram_address'length - 1) downto 0);
                    v_ram_byteenable := (others => '1');
                    v_ram_wrbitmask  := (others => '1');
                    v_ram_writedata  := avalon_mm_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when others =>
                    -- No register associated to the address, do nothing
                    avalon_mm_rmap_o.waitrequest <= '0';

            end case;

        end procedure p_avs_writedata;
        --
        variable v_fee_write_address : std_logic_vector(31 downto 0)          := (others => '0');
        variable v_avs_write_address : t_farm_avalon_mm_rmap_ffee_aeb_address := 0;
    begin
        if (rst_i = '1') then
            fee_rmap_o.waitrequest       <= '1';
            avalon_mm_rmap_o.waitrequest <= '1';
            memarea_wraddress_o          <= (others => '0');
            memarea_wrbyteenable_o       <= (others => '1');
            memarea_wrbitmask_o          <= (others => '1');
            memarea_wrdata_o             <= (others => '0');
            memarea_write_o              <= '0';
            s_write_started              <= '0';
            s_write_in_progress          <= '0';
            s_write_finished             <= '0';
            s_data_registered            <= '0';
            s_ram_mem_direct_access      <= c_RAM_MEM_DIRECT_ACCESS_RST;
            p_ffee_aeb_reg_reset;
            v_fee_write_address          := (others => '0');
            v_avs_write_address          := 0;
        elsif (rising_edge(clk_i)) then

            fee_rmap_o.waitrequest       <= '1';
            avalon_mm_rmap_o.waitrequest <= '1';
            p_ffee_aeb_reg_trigger;
            s_write_started              <= '0';
            s_write_in_progress          <= '0';
            s_write_finished             <= '0';
            s_data_registered            <= '0';
            if (fee_rmap_i.write = '1') then
                v_fee_write_address := fee_rmap_i.address;
                --                fee_rmap_o.waitrequest <= '0';
                p_ffee_aeb_mem_wr(v_fee_write_address);
            elsif (avalon_mm_rmap_i.write = '1') then
                v_avs_write_address := to_integer(unsigned(avalon_mm_rmap_i.address));
                --                avalon_mm_rmap_o.waitrequest <= '0';
                p_avs_writedata(v_avs_write_address);
            end if;

        end if;
    end process p_farm_rmap_mem_area_ffee_aeb_write;

    -- Signals Assignments
    ram_mem_direct_access_o <= s_ram_mem_direct_access;

end architecture RTL;
