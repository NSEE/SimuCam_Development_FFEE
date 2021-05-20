library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fdrm_rmap_mem_area_ffee_deb_pkg.all;
use work.fdrm_avalon_mm_rmap_ffee_deb_pkg.all;

entity fdrm_rmap_mem_area_ffee_deb_write_ent is
    port(
        clk_i                   : in  std_logic;
        rst_i                   : in  std_logic;
        fee_rmap_i              : in  t_fdrm_ffee_deb_rmap_write_in;
        avalon_mm_rmap_i        : in  t_fdrm_avalon_mm_rmap_ffee_deb_write_in;
        memarea_idle_i          : in  std_logic;
        memarea_wrdone_i        : in  std_logic;
        fee_rmap_o              : out t_fdrm_ffee_deb_rmap_write_out;
        avalon_mm_rmap_o        : out t_fdrm_avalon_mm_rmap_ffee_deb_write_out;
        rmap_registers_wr_o     : out t_rmap_memory_wr_area;
        ram_mem_direct_access_o : out t_ram_mem_direct_access;
        memarea_wraddress_o     : out std_logic_vector(4 downto 0);
        memarea_wrbyteenable_o  : out std_logic_vector(3 downto 0);
        memarea_wrbitmask_o     : out std_logic_vector(31 downto 0);
        memarea_wrdata_o        : out std_logic_vector(31 downto 0);
        memarea_write_o         : out std_logic
    );
end entity fdrm_rmap_mem_area_ffee_deb_write_ent;

architecture RTL of fdrm_rmap_mem_area_ffee_deb_write_ent is

    signal s_write_started     : std_logic;
    signal s_write_in_progress : std_logic;
    signal s_write_finished    : std_logic;

    signal s_data_registered : std_logic;

    signal s_ram_mem_direct_access : t_ram_mem_direct_access;

begin

    p_fdrm_rmap_mem_area_ffee_deb_write : process(clk_i, rst_i) is
        procedure p_rmap_ram_wr(
            constant RMAP_ADDRESS_I    : in std_logic_vector;
            constant RMAP_BYTEENABLE_I : in std_logic_vector;
            constant RMAP_BITMASK_I    : in std_logic_vector;
            constant RMAP_WRITEDATA_I  : in std_logic_vector;
            signal rmap_waitrequest_o  : out std_logic
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
        procedure p_ffee_deb_reg_reset is
        begin

            -- Write Registers Reset/Default State

            -- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_SPW" Field
            rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_spw <= '0';
            -- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_WDG" Field
            rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_wdg <= '0';

        end procedure p_ffee_deb_reg_reset;
        --
        procedure p_ffee_deb_reg_trigger is
        begin

            -- Write Registers Triggers Reset

            -- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_SPW" Field
            rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_spw <= '0';
            -- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_WDG" Field
            rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_wdg <= '0';

        end procedure p_ffee_deb_reg_trigger;
        --
        procedure p_ffee_deb_mem_wr(wr_addr_i : std_logic_vector) is
            variable v_ram_address    : std_logic_vector(4 downto 0)  := (others => '0');
            variable v_ram_byteenable : std_logic_vector(3 downto 0)  := (others => '1');
            constant c_RAM_BITMASK    : std_logic_vector(31 downto 0) := (others => '1');
            variable v_ram_writedata  : std_logic_vector(31 downto 0) := (others => '0');
        begin

            -- MemArea Write Data

            case (wr_addr_i(31 downto 0)) is
                -- Case for access to all memory area

                when (x"00000003") =>
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX0" Field
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX1" Field
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX2" Field
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX3" Field
                    v_ram_address               := "00000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(3 downto 0) := fee_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000004") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "PFDFC" Field
                    v_ram_address       := "00001";
                    v_ram_byteenable    := "1000";
                    v_ram_writedata     := (others => '0');
                    v_ram_writedata(28) := fee_rmap_i.writedata(4);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000005") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "GTME" Field
                    v_ram_address       := "00001";
                    v_ram_byteenable    := "0100";
                    v_ram_writedata     := (others => '0');
                    v_ram_writedata(16) := fee_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000006") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDF" Field
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDTR" Field
                    v_ram_address       := "00001";
                    v_ram_byteenable    := "0010";
                    v_ram_writedata     := (others => '0');
                    v_ram_writedata(9)  := fee_rmap_i.writedata(1);
                    v_ram_writedata(11) := fee_rmap_i.writedata(3);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000007") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : FOFF, "LOCK1", "LOCK0", "LOCKW1", "LOCKW0", "C1", "C0" Fields
                    v_ram_address               := "00001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(6 downto 0) := fee_rmap_i.writedata(6 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000008") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields
                    v_ram_address                 := "00010";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000009") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields
                    v_ram_address                 := "00010";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000A") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields
                    v_ram_address                := "00010";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000B") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields
                    v_ram_address               := "00010";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000C") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields
                    v_ram_address                 := "00011";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000D") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields
                    v_ram_address                 := "00011";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000E") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields
                    v_ram_address                := "00011";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000000F") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields
                    v_ram_address               := "00011";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000010") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields
                    v_ram_address                 := "00100";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000011") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields
                    v_ram_address                 := "00100";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000012") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields
                    v_ram_address                := "00100";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000013") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields
                    v_ram_address               := "00100";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000017") =>
                    -- DEB Critical Configuration Area Register "DTC_FEE_MOD" : "OPER_MOD" Field
                    v_ram_address               := "00101";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(2 downto 0) := fee_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000001B") =>
                    -- DEB Critical Configuration Area Register "DTC_IMM_ONMOD" : "IMM_ON" Field
                    v_ram_address      := "00110";
                    v_ram_byteenable   := "0001";
                    v_ram_writedata    := (others => '0');
                    v_ram_writedata(0) := fee_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000104") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T7_IN_MOD" Field
                    v_ram_address                 := "01000";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(26 downto 24) := fee_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000105") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T6_IN_MOD" Field
                    v_ram_address                 := "01000";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(18 downto 16) := fee_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000106") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T5_IN_MOD" Field
                    v_ram_address                := "01000";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(10 downto 8) := fee_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000107") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T4_IN_MOD" Field
                    v_ram_address               := "01000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(2 downto 0) := fee_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000108") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T3_IN_MOD" Field
                    v_ram_address                 := "01001";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(26 downto 24) := fee_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000109") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T2_IN_MOD" Field
                    v_ram_address                 := "01001";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(18 downto 16) := fee_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000010A") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T1_IN_MOD" Field
                    v_ram_address                := "01001";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(10 downto 8) := fee_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000010B") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T0_IN_MOD" Field
                    v_ram_address               := "01001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(2 downto 0) := fee_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000010E") =>
                    -- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_X" Field
                    v_ram_address                := "01010";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(13 downto 8) := fee_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000010F") =>
                    -- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_Y" Field
                    v_ram_address               := "01010";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(5 downto 0) := fee_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000110") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
                    v_ram_address                 := "01011";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(25 downto 24) := fee_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000111") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
                    v_ram_address                 := "01011";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000112") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
                    v_ram_address               := "01011";
                    v_ram_byteenable            := "0010";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(9 downto 8) := fee_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000113") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
                    v_ram_address               := "01011";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000114") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
                    v_ram_address                 := "01100";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(25 downto 24) := fee_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000115") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
                    v_ram_address                 := "01100";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000116") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
                    v_ram_address               := "01100";
                    v_ram_byteenable            := "0010";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(9 downto 8) := fee_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000117") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
                    v_ram_address               := "01100";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000118") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
                    v_ram_address                 := "01101";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(25 downto 24) := fee_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000119") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
                    v_ram_address                 := "01101";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000011A") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
                    v_ram_address               := "01101";
                    v_ram_byteenable            := "0010";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(9 downto 8) := fee_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000011B") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
                    v_ram_address               := "01101";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000011C") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
                    v_ram_address                 := "01110";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(25 downto 24) := fee_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000011D") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
                    v_ram_address                 := "01110";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000011E") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
                    v_ram_address               := "01110";
                    v_ram_byteenable            := "0010";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(9 downto 8) := fee_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000011F") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
                    v_ram_address               := "01110";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000123") =>
                    -- DEB General Configuration Area Register "DTC_OVS_PAT" : "OVS_LIN_PAT" Field
                    v_ram_address               := "01111";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(3 downto 0) := fee_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000124") =>
                    -- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_LIN_PAT" Field
                    v_ram_address                 := "10000";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(29 downto 24) := fee_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000125") =>
                    -- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_LIN_PAT" Field
                    v_ram_address                 := "10000";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000126") =>
                    -- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_PIX_PAT" Field
                    v_ram_address                := "10000";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(12 downto 8) := fee_rmap_i.writedata(4 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000127") =>
                    -- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_PIX_PAT" Field
                    v_ram_address               := "10000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000012B") =>
                    -- DEB General Configuration Area Register "DTC_TRG_25S" : "2_5S_N_CYC" Field
                    v_ram_address               := "10001";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000012F") =>
                    -- DEB General Configuration Area Register "DTC_SEL_TRG" : "TRG_SRC" Field
                    v_ram_address      := "10010";
                    v_ram_byteenable   := "0001";
                    v_ram_writedata    := (others => '0');
                    v_ram_writedata(0) := fee_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000132") =>
                    -- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
                    v_ram_address                := "10011";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000133") =>
                    -- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
                    v_ram_address               := "10011";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000137") =>
                    -- DEB General Configuration Area Register "DTC_SEL_SYN" : "SYN_FRQ" Field
                    v_ram_address      := "10100";
                    v_ram_byteenable   := "0001";
                    v_ram_writedata    := (others => '0');
                    v_ram_writedata(0) := fee_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000139") =>
                    -- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_SPW" Field
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_spw <= fee_rmap_i.writedata(0);
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"0000013A") =>
                    -- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_WDG" Field
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_wdg <= fee_rmap_i.writedata(0);
                    end if;
                    s_data_registered      <= '1';
                    fee_rmap_o.waitrequest <= '0';

                when (x"0000013D") =>
                    -- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
                    v_ram_address                 := "10110";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000013E") =>
                    -- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
                    v_ram_address                := "10110";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"0000013F") =>
                    -- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
                    v_ram_address               := "10110";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000140") =>
                    -- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
                    v_ram_address                 := "10111";
                    v_ram_byteenable              := "1000";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(31 downto 24) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000141") =>
                    -- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
                    v_ram_address                 := "10111";
                    v_ram_byteenable              := "0100";
                    v_ram_writedata               := (others => '0');
                    v_ram_writedata(23 downto 16) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000142") =>
                    -- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
                    v_ram_address                := "10111";
                    v_ram_byteenable             := "0010";
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 8) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000143") =>
                    -- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
                    v_ram_address               := "10111";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := fee_rmap_i.writedata;
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when (x"00000147") =>
                    -- DEB General Configuration Area Register "DTC_SPW_CFG" : "TIMECODE" Field
                    v_ram_address               := "11000";
                    v_ram_byteenable            := "0001";
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(1 downto 0) := fee_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, c_RAM_BITMASK, v_ram_writedata, fee_rmap_o.waitrequest);

                when others =>
                    fee_rmap_o.waitrequest <= '0';

            end case;

        end procedure p_ffee_deb_mem_wr;
        --
        procedure p_avs_writedata(write_address_i : t_fdrm_avalon_mm_rmap_ffee_deb_address) is
            variable v_ram_address    : std_logic_vector(4 downto 0)  := (others => '0');
            variable v_ram_byteenable : std_logic_vector(3 downto 0)  := (others => '1');
            variable v_ram_wrbitmask  : std_logic_vector(31 downto 0) := (others => '1');
            variable v_ram_writedata  : std_logic_vector(31 downto 0) := (others => '0');
        begin

            -- Registers Write Data
            case (write_address_i) is
                -- Case for access to all registers address

                when (16#00#) =>
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX3" Field
                    v_ram_address      := "00000";
                    v_ram_byteenable   := "0001";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(3) := '1';
                    v_ram_writedata(3) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#01#) =>
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX2" Field
                    v_ram_address      := "00000";
                    v_ram_byteenable   := "0001";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(2) := '1';
                    v_ram_writedata(2) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#02#) =>
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX1" Field
                    v_ram_address      := "00000";
                    v_ram_byteenable   := "0001";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(1) := '1';
                    v_ram_writedata(1) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#03#) =>
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX0" Field
                    v_ram_address      := "00000";
                    v_ram_byteenable   := "0001";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(0) := '1';
                    v_ram_writedata(0) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#04#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "PFDFC" Field
                    v_ram_address       := "00001";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(28) := '1';
                    v_ram_writedata(28) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#05#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "GTME" Field
                    v_ram_address       := "00001";
                    v_ram_byteenable    := "0100";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(16) := '1';
                    v_ram_writedata(16) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#06#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDTR" Field
                    v_ram_address       := "00001";
                    v_ram_byteenable    := "0010";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(11) := '1';
                    v_ram_writedata(11) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#07#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDF" Field
                    v_ram_address      := "00001";
                    v_ram_byteenable   := "0010";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(9) := '1';
                    v_ram_writedata(9) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#08#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : FOFF, "LOCK1", "LOCK0", "LOCKW1", "LOCKW0", "C1", "C0" Fields
                    v_ram_address               := "00001";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(6 downto 0) := (others => '1');
                    v_ram_writedata(6 downto 0) := avalon_mm_rmap_i.writedata(6 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#09#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields
                    v_ram_address                := "00010";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#0A#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields
                    v_ram_address                := "00011";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#0B#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields
                    v_ram_address                := "00100";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#0C#) =>
                    -- DEB Critical Configuration Area Register "DTC_FEE_MOD" : "OPER_MOD" Field
                    v_ram_address               := "00101";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(2 downto 0) := (others => '1');
                    v_ram_writedata(2 downto 0) := avalon_mm_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#0D#) =>
                    -- DEB Critical Configuration Area Register "DTC_IMM_ONMOD" : "IMM_ON" Field
                    v_ram_address      := "00110";
                    v_ram_byteenable   := "0001";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(0) := '1';
                    v_ram_writedata(0) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#0E#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T7_IN_MOD" Field
                    v_ram_address                 := "01000";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(26 downto 24) := (others => '1');
                    v_ram_writedata(26 downto 24) := avalon_mm_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#0F#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T6_IN_MOD" Field
                    v_ram_address                 := "01000";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(18 downto 16) := (others => '1');
                    v_ram_writedata(18 downto 16) := avalon_mm_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#10#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T5_IN_MOD" Field
                    v_ram_address                := "01000";
                    v_ram_byteenable             := "0010";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(10 downto 8) := (others => '1');
                    v_ram_writedata(10 downto 8) := avalon_mm_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#11#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T4_IN_MOD" Field
                    v_ram_address               := "01000";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(2 downto 0) := (others => '1');
                    v_ram_writedata(2 downto 0) := avalon_mm_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#12#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T3_IN_MOD" Field
                    v_ram_address                 := "01001";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(26 downto 24) := (others => '1');
                    v_ram_writedata(26 downto 24) := avalon_mm_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#13#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T2_IN_MOD" Field
                    v_ram_address                 := "01001";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(18 downto 16) := (others => '1');
                    v_ram_writedata(18 downto 16) := avalon_mm_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#14#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T1_IN_MOD" Field
                    v_ram_address                := "01001";
                    v_ram_byteenable             := "0010";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(10 downto 8) := (others => '1');
                    v_ram_writedata(10 downto 8) := avalon_mm_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#15#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T0_IN_MOD" Field
                    v_ram_address               := "01001";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(2 downto 0) := (others => '1');
                    v_ram_writedata(2 downto 0) := avalon_mm_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#16#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_X" Field
                    v_ram_address                := "01010";
                    v_ram_byteenable             := "0010";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(13 downto 8) := (others => '1');
                    v_ram_writedata(13 downto 8) := avalon_mm_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#17#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_Y" Field
                    v_ram_address               := "01010";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(5 downto 0) := (others => '1');
                    v_ram_writedata(5 downto 0) := avalon_mm_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#18#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
                    v_ram_address                 := "01011";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(25 downto 16) := (others => '1');
                    v_ram_writedata(25 downto 16) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#19#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
                    v_ram_address               := "01011";
                    v_ram_byteenable            := "0011";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(9 downto 0) := (others => '1');
                    v_ram_writedata(9 downto 0) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#1A#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
                    v_ram_address                 := "01100";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(25 downto 16) := (others => '1');
                    v_ram_writedata(25 downto 16) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#1B#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
                    v_ram_address               := "01100";
                    v_ram_byteenable            := "0011";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(9 downto 0) := (others => '1');
                    v_ram_writedata(9 downto 0) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#1C#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
                    v_ram_address                 := "01101";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(25 downto 16) := (others => '1');
                    v_ram_writedata(25 downto 16) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#1D#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
                    v_ram_address               := "01101";
                    v_ram_byteenable            := "0011";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(9 downto 0) := (others => '1');
                    v_ram_writedata(9 downto 0) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#1E#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
                    v_ram_address                 := "01110";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(25 downto 16) := (others => '1');
                    v_ram_writedata(25 downto 16) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#1F#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
                    v_ram_address               := "01110";
                    v_ram_byteenable            := "0011";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(9 downto 0) := (others => '1');
                    v_ram_writedata(9 downto 0) := avalon_mm_rmap_i.writedata(9 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#20#) =>
                    -- DEB General Configuration Area Register "DTC_OVS_PAT" : "OVS_LIN_PAT" Field
                    v_ram_address               := "01111";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(3 downto 0) := (others => '1');
                    v_ram_writedata(3 downto 0) := avalon_mm_rmap_i.writedata(3 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#21#) =>
                    -- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_LIN_PAT" Field
                    v_ram_address                 := "10000";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(29 downto 16) := (others => '1');
                    v_ram_writedata(29 downto 16) := avalon_mm_rmap_i.writedata(13 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#22#) =>
                    -- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_PIX_PAT" Field
                    v_ram_address                := "10000";
                    v_ram_byteenable             := "0011";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(12 downto 0) := (others => '1');
                    v_ram_writedata(12 downto 0) := avalon_mm_rmap_i.writedata(12 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#23#) =>
                    -- DEB General Configuration Area Register "DTC_TRG_25S" : "2_5S_N_CYC" Field
                    v_ram_address               := "10001";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '1');
                    v_ram_writedata             := (others => '0');
                    v_ram_writedata(7 downto 0) := avalon_mm_rmap_i.writedata(7 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#24#) =>
                    -- DEB General Configuration Area Register "DTC_SEL_TRG" : "TRG_SRC" Field
                    v_ram_address      := "10010";
                    v_ram_byteenable   := "0001";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(0) := '1';
                    v_ram_writedata(0) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#25#) =>
                    -- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
                    v_ram_address                := "10011";
                    v_ram_byteenable             := "0011";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(15 downto 0) := avalon_mm_rmap_i.writedata(15 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#26#) =>
                    -- DEB General Configuration Area Register "DTC_SEL_SYN" : "SYN_FRQ" Field
                    v_ram_address      := "10100";
                    v_ram_byteenable   := "0001";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(0) := '1';
                    v_ram_writedata(0) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#27#) =>
                    -- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_SPW" Field
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_spw <= avalon_mm_rmap_i.writedata(0);
                    end if;
                    s_data_registered            <= '1';
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#28#) =>
                    -- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_WDG" Field
                    if (s_data_registered = '0') then
                        rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_wdg <= avalon_mm_rmap_i.writedata(0);
                    end if;
                    s_data_registered            <= '1';
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#29#) =>
                    -- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
                    v_ram_address                := "10110";
                    v_ram_byteenable             := "0111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(23 downto 0) := avalon_mm_rmap_i.writedata(23 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#2A#) =>
                    -- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
                    v_ram_address                := "10111";
                    v_ram_byteenable             := "1111";
                    v_ram_wrbitmask              := (others => '1');
                    v_ram_writedata              := (others => '0');
                    v_ram_writedata(31 downto 0) := avalon_mm_rmap_i.writedata(31 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#2B#) =>
                    -- DEB General Configuration Area Register "DTC_SPW_CFG" : "TIMECODE" Field
                    v_ram_address               := "11000";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(1 downto 0) := (others => '1');
                    v_ram_writedata(1 downto 0) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#2C#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "OPER_MOD" Field
                    v_ram_address                 := "11001";
                    v_ram_byteenable              := "1000";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(26 downto 24) := (others => '1');
                    v_ram_writedata(26 downto 24) := avalon_mm_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#2D#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_CORR_ERR" Field
                    v_ram_address                 := "11001";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(23 downto 18) := (others => '1');
                    v_ram_writedata(23 downto 18) := avalon_mm_rmap_i.writedata(5 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#2E#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_UNCORR_ERR" Field
                    v_ram_address                 := "11001";
                    v_ram_byteenable              := "0100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(17 downto 16) := (others => '1');
                    v_ram_writedata(17 downto 16) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#2F#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : PLL_REF, "PLL_VCXO", "PLL_LOCK" Fields
                    v_ram_address                := "11001";
                    v_ram_byteenable             := "0010";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(10 downto 8) := (others => '1');
                    v_ram_writedata(10 downto 8) := avalon_mm_rmap_i.writedata(2 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#30#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_4" Field
                    v_ram_address      := "11001";
                    v_ram_byteenable   := "0001";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(7) := '1';
                    v_ram_writedata(7) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#31#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_3" Field
                    v_ram_address      := "11001";
                    v_ram_byteenable   := "0001";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(6) := '1';
                    v_ram_writedata(6) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#32#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_2" Field
                    v_ram_address      := "11001";
                    v_ram_byteenable   := "0001";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(5) := '1';
                    v_ram_writedata(5) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#33#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_1" Field
                    v_ram_address      := "11001";
                    v_ram_byteenable   := "0001";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(4) := '1';
                    v_ram_writedata(4) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#34#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "WDW_LIST_CNT_OVF" Field
                    v_ram_address               := "11001";
                    v_ram_byteenable            := "0001";
                    v_ram_wrbitmask             := (others => '0');
                    v_ram_writedata             := (others => '0');
                    v_ram_wrbitmask(3 downto 2) := (others => '1');
                    v_ram_writedata(3 downto 2) := avalon_mm_rmap_i.writedata(1 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#35#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "WDG" Field
                    v_ram_address      := "11001";
                    v_ram_byteenable   := "0001";
                    v_ram_wrbitmask    := (others => '0');
                    v_ram_writedata    := (others => '0');
                    v_ram_wrbitmask(0) := '1';
                    v_ram_writedata(0) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#36#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_8" Field
                    v_ram_address       := "11010";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(31) := '1';
                    v_ram_writedata(31) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#37#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_7" Field
                    v_ram_address       := "11010";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(30) := '1';
                    v_ram_writedata(30) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#38#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_6" Field
                    v_ram_address       := "11010";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(29) := '1';
                    v_ram_writedata(29) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#39#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_5" Field
                    v_ram_address       := "11010";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(28) := '1';
                    v_ram_writedata(28) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#3A#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_4" Field
                    v_ram_address       := "11010";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(27) := '1';
                    v_ram_writedata(27) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#3B#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_3" Field
                    v_ram_address       := "11010";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(26) := '1';
                    v_ram_writedata(26) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#3C#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_2" Field
                    v_ram_address       := "11010";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(25) := '1';
                    v_ram_writedata(25) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#3D#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_1" Field
                    v_ram_address       := "11010";
                    v_ram_byteenable    := "1000";
                    v_ram_wrbitmask     := (others => '0');
                    v_ram_writedata     := (others => '0');
                    v_ram_wrbitmask(24) := '1';
                    v_ram_writedata(24) := avalon_mm_rmap_i.writedata(0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#62#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK1" : "VDIG_IN" Field
                    v_ram_address                 := "11100";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(27 downto 16) := (others => '1');
                    v_ram_writedata(27 downto 16) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#63#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK1" : "VIO" Field
                    v_ram_address                := "11100";
                    v_ram_byteenable             := "0011";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(11 downto 0) := (others => '1');
                    v_ram_writedata(11 downto 0) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#64#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK2" : "VCOR" Field
                    v_ram_address                 := "11101";
                    v_ram_byteenable              := "1100";
                    v_ram_wrbitmask               := (others => '0');
                    v_ram_writedata               := (others => '0');
                    v_ram_wrbitmask(27 downto 16) := (others => '1');
                    v_ram_writedata(27 downto 16) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#65#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK2" : "VLVD" Field
                    v_ram_address                := "11101";
                    v_ram_byteenable             := "0011";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(11 downto 0) := (others => '1');
                    v_ram_writedata(11 downto 0) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#66#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK3" : "DEB_TEMP" Field
                    v_ram_address                := "11110";
                    v_ram_byteenable             := "0011";
                    v_ram_wrbitmask              := (others => '0');
                    v_ram_writedata              := (others => '0');
                    v_ram_wrbitmask(11 downto 0) := (others => '1');
                    v_ram_writedata(11 downto 0) := avalon_mm_rmap_i.writedata(11 downto 0);
                    p_rmap_ram_wr(v_ram_address, v_ram_byteenable, v_ram_wrbitmask, v_ram_writedata, avalon_mm_rmap_o.waitrequest);

                when (16#67#) =>
                    -- RAM Memory Control - Address
                    if (s_data_registered = '0') then
                        s_ram_mem_direct_access.addr <= avalon_mm_rmap_i.writedata;
                    end if;
                    s_data_registered            <= '1';
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#68#) =>
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
        variable v_avs_write_address : t_fdrm_avalon_mm_rmap_ffee_deb_address := 0;
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
            p_ffee_deb_reg_reset;
            v_fee_write_address          := (others => '0');
            v_avs_write_address          := 0;
        elsif (rising_edge(clk_i)) then

            fee_rmap_o.waitrequest       <= '1';
            avalon_mm_rmap_o.waitrequest <= '1';
            p_ffee_deb_reg_trigger;
            s_write_started              <= '0';
            s_write_in_progress          <= '0';
            s_write_finished             <= '0';
            s_data_registered            <= '0';
            if (fee_rmap_i.write = '1') then
                v_fee_write_address := fee_rmap_i.address;
                --                fee_rmap_o.waitrequest <= '0';
                p_ffee_deb_mem_wr(v_fee_write_address);
            elsif (avalon_mm_rmap_i.write = '1') then
                v_avs_write_address := to_integer(unsigned(avalon_mm_rmap_i.address));
                --                avalon_mm_rmap_o.waitrequest <= '0';
                p_avs_writedata(v_avs_write_address);
            end if;

        end if;
    end process p_fdrm_rmap_mem_area_ffee_deb_write;

    -- Signals Assignments
    ram_mem_direct_access_o <= s_ram_mem_direct_access;

end architecture RTL;
