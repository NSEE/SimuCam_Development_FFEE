library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fdrm_rmap_mem_area_ffee_deb_pkg.all;
use work.fdrm_avalon_mm_rmap_ffee_deb_pkg.all;

entity fdrm_rmap_mem_area_ffee_deb_read_ent is
    port(
        clk_i                   : in  std_logic;
        rst_i                   : in  std_logic;
        fee_rmap_i              : in  t_fdrm_ffee_deb_rmap_read_in;
        avalon_mm_rmap_i        : in  t_fdrm_avalon_mm_rmap_ffee_deb_read_in;
        ram_mem_direct_access_i : in  t_ram_mem_direct_access;
        memarea_idle_i          : in  std_logic;
        memarea_rdvalid_i       : in  std_logic;
        memarea_rddata_i        : in  std_logic_vector(31 downto 0);
        rmap_registers_wr_i     : in  t_rmap_memory_wr_area;
        rmap_registers_rd_i     : in  t_rmap_memory_rd_area;
        fee_rmap_o              : out t_fdrm_ffee_deb_rmap_read_out;
        avalon_mm_rmap_o        : out t_fdrm_avalon_mm_rmap_ffee_deb_read_out;
        memarea_rdaddress_o     : out std_logic_vector(4 downto 0);
        memarea_read_o          : out std_logic
    );
end entity fdrm_rmap_mem_area_ffee_deb_read_ent;

architecture RTL of fdrm_rmap_mem_area_ffee_deb_read_ent is

    signal s_read_started     : std_logic;
    signal s_read_in_progress : std_logic;
    signal s_read_finished    : std_logic;

begin

    p_fdrm_rmap_mem_area_ffee_deb_read : process(clk_i, rst_i) is
        --
        procedure p_rmap_ram_rd(
            constant RMAP_ADDRESS_I   : in std_logic_vector;
            signal rmap_waitrequest_o : out std_logic;
            variable rmap_readdata_o  : out std_logic_vector
        ) is
        begin
            memarea_rdaddress_o <= (others => '0');
            memarea_read_o      <= '0';
            -- check if a read was finished    
            if (s_read_finished = '1') then
                -- a read was finished
                -- read the memory data
                rmap_readdata_o((memarea_rddata_i'length - 1) downto 0) := memarea_rddata_i;
                -- keep setted the read finished flag
                s_read_finished                                         <= '1';
                -- keep cleared the waitrequest flag
                rmap_waitrequest_o                                      <= '0';
            else
                -- a read was not finished
                -- check if a read is not in progress and was not just started
                if ((s_read_in_progress = '0') and (s_read_started = '0')) then
                    -- a read is not in progress
                    -- check if the mem aerea is on idle (can receive commands)
                    if (memarea_idle_i = '1') then
                        -- the mem aerea is on idle (can receive commands)
                        -- send read to mem area
                        memarea_rdaddress_o <= RMAP_ADDRESS_I((memarea_rdaddress_o'length - 1) downto 0);
                        memarea_read_o      <= '1';
                        -- set the read started flag
                        s_read_started      <= '1';
                        -- set the read in progress flag
                        s_read_in_progress  <= '1';
                    end if;
                -- check if a read is in progress and was just started    
                elsif ((s_read_in_progress = '1') and (s_read_started = '1')) then
                    -- clear the read started flag
                    s_read_started     <= '0';
                    -- keep setted the read in progress flag
                    s_read_in_progress <= '1';
                -- check if a read is in progress and was not just started    
                elsif ((s_read_in_progress = '1') and (s_read_started = '0')) then
                    -- a read is in progress
                    -- keep setted the read in progress flag
                    s_read_in_progress <= '1';
                    -- check if the read data is valid
                    if ((memarea_rdvalid_i = '1') or (memarea_idle_i = '1')) then
                        -- the read data is valid
                        -- read the memory data
                        rmap_readdata_o((memarea_rddata_i'length - 1) downto 0) := memarea_rddata_i;
                        -- clear the read in progress flag
                        s_read_in_progress                                      <= '0';
                        -- set the read finished flag
                        s_read_finished                                         <= '1';
                        -- clear the waitrequest flag
                        rmap_waitrequest_o                                      <= '0';
                    end if;
                end if;
            end if;
        end procedure p_rmap_ram_rd;
        --
        procedure p_ffee_deb_rmap_mem_rd(rd_addr_i : std_logic_vector) is
            variable v_ram_address  : std_logic_vector(4 downto 0)  := (others => '0');
            variable v_ram_readdata : std_logic_vector(31 downto 0) := (others => '0');
        begin

            -- MemArea Data Read
            case (rd_addr_i(31 downto 0)) is
                -- Case for access to all memory area

                when (x"00000003") =>
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX1" Field
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX2" Field
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX3" Field
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX4" Field
                    v_ram_address       := "00000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000004") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "PFDFC" Field
                    v_ram_address       := "00001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000005") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "GTME" Field
                    v_ram_address       := "00001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000006") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDF" Field
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDTR" Field
                    v_ram_address       := "00001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000007") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : FOFF, "LOCK1", "LOCK0", "LOCKW1", "LOCKW0", "C1", "C0" Fields
                    v_ram_address       := "00001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000008") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields
                    v_ram_address       := "00010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000009") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields
                    v_ram_address       := "00010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000000A") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields
                    v_ram_address       := "00010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000000B") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields
                    v_ram_address       := "00010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000000C") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields
                    v_ram_address       := "00011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000000D") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields
                    v_ram_address       := "00011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000000E") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields
                    v_ram_address       := "00011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000000F") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields
                    v_ram_address       := "00011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000010") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields
                    v_ram_address       := "00100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000011") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields
                    v_ram_address       := "00100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000012") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields
                    v_ram_address       := "00100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000013") =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields
                    v_ram_address       := "00100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000017") =>
                    -- DEB Critical Configuration Area Register "DTC_FEE_MOD" : "OPER_MOD" Field
                    v_ram_address       := "00101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000001B") =>
                    -- DEB Critical Configuration Area Register "DTC_IMM_ONMOD" : "IMM_ON" Field
                    v_ram_address       := "00110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000104") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T7_IN_MOD" Field
                    v_ram_address       := "01000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000105") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T6_IN_MOD" Field
                    v_ram_address       := "01000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000106") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T5_IN_MOD" Field
                    v_ram_address       := "01000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000107") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T4_IN_MOD" Field
                    v_ram_address       := "01000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000108") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T3_IN_MOD" Field
                    v_ram_address       := "01001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000109") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T2_IN_MOD" Field
                    v_ram_address       := "01001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000010A") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T1_IN_MOD" Field
                    v_ram_address       := "01001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000010B") =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T0_IN_MOD" Field
                    v_ram_address       := "01001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000010E") =>
                    -- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_X" Field
                    v_ram_address       := "01010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000010F") =>
                    -- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_Y" Field
                    v_ram_address       := "01010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000110") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
                    v_ram_address       := "01011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000111") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
                    v_ram_address       := "01011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000112") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
                    v_ram_address       := "01011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000113") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
                    v_ram_address       := "01011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000114") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
                    v_ram_address       := "01100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000115") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
                    v_ram_address       := "01100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000116") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
                    v_ram_address       := "01100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000117") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
                    v_ram_address       := "01100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000118") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
                    v_ram_address       := "01101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000119") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
                    v_ram_address       := "01101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000011A") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
                    v_ram_address       := "01101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000011B") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
                    v_ram_address       := "01101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000011C") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
                    v_ram_address       := "01110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000011D") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
                    v_ram_address       := "01110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000011E") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
                    v_ram_address       := "01110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000011F") =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
                    v_ram_address       := "01110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000123") =>
                    -- DEB General Configuration Area Register "DTC_OVS_DEB" : "OVS_LIN_DEB" Field
                    v_ram_address       := "01111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000124") =>
                    -- DEB General Configuration Area Register "DTC_SIZ_DEB" : "NB_LIN_DEB" Field
                    v_ram_address       := "10000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000125") =>
                    -- DEB General Configuration Area Register "DTC_SIZ_DEB" : "NB_LIN_DEB" Field
                    v_ram_address       := "10000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000126") =>
                    -- DEB General Configuration Area Register "DTC_SIZ_DEB" : "NB_PIX_DEB" Field
                    v_ram_address       := "10000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000127") =>
                    -- DEB General Configuration Area Register "DTC_SIZ_DEB" : "NB_PIX_DEB" Field
                    v_ram_address       := "10000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000012B") =>
                    -- DEB General Configuration Area Register "DTC_TRG_25S" : "2_5S_N_CYC" Field
                    v_ram_address       := "10001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"0000012F") =>
                    -- DEB General Configuration Area Register "DTC_SEL_TRG" : "TRG_SRC" Field
                    v_ram_address       := "10010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000132") =>
                    -- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
                    v_ram_address       := "10011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000133") =>
                    -- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
                    v_ram_address       := "10011";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000137") =>
                    -- DEB General Configuration Area Register "DTC_SEL_SYN" : "SYN_FRQ" Field
                    v_ram_address       := "10100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000139") =>
                    -- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_SPW" Field
                    fee_rmap_o.readdata    <= (others => '0');
                    fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_rst_cps.rst_spw;
                    fee_rmap_o.waitrequest <= '0';

                when (x"0000013A") =>
                    -- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_WDG" Field
                    fee_rmap_o.readdata    <= (others => '0');
                    fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_rst_cps.rst_wdg;
                    fee_rmap_o.waitrequest <= '0';

                when (x"0000013D") =>
                    -- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
                    v_ram_address       := "10110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000013E") =>
                    -- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
                    v_ram_address       := "10110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000013F") =>
                    -- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
                    v_ram_address       := "10110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000140") =>
                    -- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
                    v_ram_address       := "10111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00000141") =>
                    -- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
                    v_ram_address       := "10111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00000142") =>
                    -- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
                    v_ram_address       := "10111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00000143") =>
                    -- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
                    v_ram_address       := "10111";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00000147") =>
                    -- DEB General Configuration Area Register "DTC_SPW_CFG" : "TIMECODE" Field
                    v_ram_address       := "11000";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00001000") =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "OPER_MOD" Field
                    v_ram_address       := "11001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00001001") =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_UNCORR_ERR" Field
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_CORR_ERR" Field
                    v_ram_address       := "11001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00001002") =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "NB_PLLPERIOD", "PLL_REF", "PLL_VCXO", "PLL_LOCK" Fields
                    v_ram_address       := "11001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00001003") =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "WDG" Field
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "WDW_LIST_CNT_OVF" Field
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_1" Field
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_2" Field
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_3" Field
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_4" Field
                    v_ram_address       := "11001";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00001004") =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_1" Field
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_2" Field
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_3" Field
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_4" Field
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_5" Field
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_6" Field
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_7" Field
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_8" Field
                    v_ram_address       := "11010";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00001005") =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_1" Field
                    fee_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_1;
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_2" Field
                    fee_rmap_o.readdata(1) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_2;
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_3" Field
                    fee_rmap_o.readdata(2) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_3;
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_4" Field
                    fee_rmap_o.readdata(3) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_4;
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_5" Field
                    fee_rmap_o.readdata(4) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_5;
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_6" Field
                    fee_rmap_o.readdata(5) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_6;
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_7" Field
                    fee_rmap_o.readdata(6) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_7;
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_8" Field
                    fee_rmap_o.readdata(7) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_8;
                    fee_rmap_o.waitrequest <= '0';

                when (x"00001006") =>
                    fee_rmap_o.readdata    <= (others => '0');
                    -- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_1" Field
                    fee_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_1;
                    -- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_2" Field
                    fee_rmap_o.readdata(2) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_2;
                    -- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_3" Field
                    fee_rmap_o.readdata(4) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_3;
                    -- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_4" Field
                    fee_rmap_o.readdata(6) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_4;
                    fee_rmap_o.waitrequest <= '0';

                when (x"00001008") =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "DISC_4" Field
                    fee_rmap_o.readdata(0)          <= rmap_registers_rd_i.deb_hk_spw_status.disc_4;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "PAR_4" Field
                    fee_rmap_o.readdata(1)          <= rmap_registers_rd_i.deb_hk_spw_status.par_4;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "ESC_4" Field
                    fee_rmap_o.readdata(2)          <= rmap_registers_rd_i.deb_hk_spw_status.esc_4;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "FIFO_4" Field
                    fee_rmap_o.readdata(3)          <= rmap_registers_rd_i.deb_hk_spw_status.fifo_4;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "CRD_4" Field
                    fee_rmap_o.readdata(4)          <= rmap_registers_rd_i.deb_hk_spw_status.crd_4;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "STATE_4" Field
                    fee_rmap_o.readdata(7 downto 5) <= rmap_registers_rd_i.deb_hk_spw_status.state_4;
                    fee_rmap_o.waitrequest          <= '0';

                when (x"00001009") =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "DISC_3" Field
                    fee_rmap_o.readdata(0)          <= rmap_registers_rd_i.deb_hk_spw_status.disc_3;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "PAR_3" Field
                    fee_rmap_o.readdata(1)          <= rmap_registers_rd_i.deb_hk_spw_status.par_3;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "ESC_3" Field
                    fee_rmap_o.readdata(2)          <= rmap_registers_rd_i.deb_hk_spw_status.esc_3;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "FIFO_3" Field
                    fee_rmap_o.readdata(3)          <= rmap_registers_rd_i.deb_hk_spw_status.fifo_3;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "CRD_3" Field
                    fee_rmap_o.readdata(4)          <= rmap_registers_rd_i.deb_hk_spw_status.crd_3;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "STATE_3" Field
                    fee_rmap_o.readdata(7 downto 5) <= rmap_registers_rd_i.deb_hk_spw_status.state_3;
                    fee_rmap_o.waitrequest          <= '0';

                when (x"0000100A") =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "DISC_2" Field
                    fee_rmap_o.readdata(0)          <= rmap_registers_rd_i.deb_hk_spw_status.disc_2;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "PAR_2" Field
                    fee_rmap_o.readdata(1)          <= rmap_registers_rd_i.deb_hk_spw_status.par_2;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "ESC_2" Field
                    fee_rmap_o.readdata(2)          <= rmap_registers_rd_i.deb_hk_spw_status.esc_2;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "FIFO_2" Field
                    fee_rmap_o.readdata(3)          <= rmap_registers_rd_i.deb_hk_spw_status.fifo_2;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "CRD_2" Field
                    fee_rmap_o.readdata(4)          <= rmap_registers_rd_i.deb_hk_spw_status.crd_2;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "STATE_2" Field
                    fee_rmap_o.readdata(7 downto 5) <= rmap_registers_rd_i.deb_hk_spw_status.state_2;
                    fee_rmap_o.waitrequest          <= '0';

                when (x"0000100B") =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "DISC_1" Field
                    fee_rmap_o.readdata(0)          <= rmap_registers_rd_i.deb_hk_spw_status.disc_1;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "PAR_1" Field
                    fee_rmap_o.readdata(1)          <= rmap_registers_rd_i.deb_hk_spw_status.par_1;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "ESC_1" Field
                    fee_rmap_o.readdata(2)          <= rmap_registers_rd_i.deb_hk_spw_status.esc_1;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "FIFO_1" Field
                    fee_rmap_o.readdata(3)          <= rmap_registers_rd_i.deb_hk_spw_status.fifo_1;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "CRD_1" Field
                    fee_rmap_o.readdata(4)          <= rmap_registers_rd_i.deb_hk_spw_status.crd_1;
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "STATE_1" Field
                    fee_rmap_o.readdata(7 downto 5) <= rmap_registers_rd_i.deb_hk_spw_status.state_1;
                    fee_rmap_o.waitrequest          <= '0';

                when (x"0000100C") =>
                    -- DEB Housekeeping Area Register "DEB_AHK1" : "DEB_TEMP" Field
                    v_ram_address       := "11100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"0000100D") =>
                    -- DEB Housekeeping Area Register "DEB_AHK1" : "DEB_TEMP" Field
                    v_ram_address       := "11100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"0000100E") =>
                    -- DEB Housekeeping Area Register "DEB_AHK1" : "VIO" Field
                    v_ram_address       := "11100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"0000100F") =>
                    -- DEB Housekeeping Area Register "DEB_AHK1" : "VIO" Field
                    v_ram_address       := "11100";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00001010") =>
                    -- DEB Housekeeping Area Register "DEB_AHK2" : "VLVD" Field
                    v_ram_address       := "11101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);

                when (x"00001011") =>
                    -- DEB Housekeeping Area Register "DEB_AHK2" : "VLVD" Field
                    v_ram_address       := "11101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);

                when (x"00001012") =>
                    -- DEB Housekeeping Area Register "DEB_AHK2" : "VCOR" Field
                    v_ram_address       := "11101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00001013") =>
                    -- DEB Housekeeping Area Register "DEB_AHK2" : "VCOR" Field
                    v_ram_address       := "11101";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when (x"00001014") =>
                    -- DEB Housekeeping Area Register "DEB_AHK3" : "STATUS_AEB4" Field
                    v_ram_address       := "11110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(31 downto 24);
                    
                when (x"00001015") =>
                    -- DEB Housekeeping Area Register "DEB_AHK3" : "STATUS_AEB3" Field
                    v_ram_address       := "11110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(23 downto 16);
                    
                when (x"00001016") =>
                    -- DEB Housekeeping Area Register "DEB_AHK3" : "STATUS_AEB2" Field
                    v_ram_address       := "11110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(15 downto 8);

                when (x"00001017") =>
                    -- DEB Housekeeping Area Register "DEB_AHK3" : "STATUS_AEB1" Field
                    v_ram_address       := "11110";
                    p_rmap_ram_rd(v_ram_address, fee_rmap_o.waitrequest, v_ram_readdata);
                    fee_rmap_o.readdata <= v_ram_readdata(7 downto 0);

                when others =>
                    fee_rmap_o.readdata    <= (others => '0');
                    fee_rmap_o.waitrequest <= '0';

            end case;

        end procedure p_ffee_deb_rmap_mem_rd;
        --
        procedure p_avs_readdata(read_address_i : t_fdrm_avalon_mm_rmap_ffee_deb_address) is
            variable v_ram_address  : std_logic_vector(4 downto 0)  := (others => '0');
            variable v_ram_readdata : std_logic_vector(31 downto 0) := (others => '0');
        begin

            -- Registers Data Read
            case (read_address_i) is
                -- Case for access to all registers address

                when (16#00#) =>
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX4" Field
                    v_ram_address                := "00000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(3);

                when (16#01#) =>
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX3" Field
                    v_ram_address                := "00000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(2);

                when (16#02#) =>
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX2" Field
                    v_ram_address                := "00000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(1);

                when (16#03#) =>
                    -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX1" Field
                    v_ram_address                := "00000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(0);

                when (16#04#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "PFDFC" Field
                    v_ram_address                := "00001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(28);

                when (16#05#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "GTME" Field
                    v_ram_address                := "00001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(16);

                when (16#06#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDTR" Field
                    v_ram_address                := "00001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(11);

                when (16#07#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDF" Field
                    v_ram_address                := "00001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(9);

                when (16#08#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : FOFF, "LOCK1", "LOCK0", "LOCKW1", "LOCKW0", "C1", "C0" Fields
                    v_ram_address                         := "00001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(6 downto 0) <= v_ram_readdata(6 downto 0);

                when (16#09#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields
                    v_ram_address                          := "00010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(31 downto 0) <= v_ram_readdata(31 downto 0);

                when (16#0A#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields
                    v_ram_address                          := "00011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(31 downto 0) <= v_ram_readdata(31 downto 0);

                when (16#0B#) =>
                    -- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields
                    v_ram_address                          := "00100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(31 downto 0) <= v_ram_readdata(31 downto 0);

                when (16#0C#) =>
                    -- DEB Critical Configuration Area Register "DTC_FEE_MOD" : "OPER_MOD" Field
                    v_ram_address                         := "00101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(2 downto 0) <= v_ram_readdata(2 downto 0);

                when (16#0D#) =>
                    -- DEB Critical Configuration Area Register "DTC_IMM_ONMOD" : "IMM_ON" Field
                    v_ram_address                := "00110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(0);

                when (16#0E#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T7_IN_MOD" Field
                    v_ram_address                         := "01000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(2 downto 0) <= v_ram_readdata(26 downto 24);

                when (16#0F#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T6_IN_MOD" Field
                    v_ram_address                         := "01000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(2 downto 0) <= v_ram_readdata(18 downto 16);

                when (16#10#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T5_IN_MOD" Field
                    v_ram_address                         := "01000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(2 downto 0) <= v_ram_readdata(10 downto 8);

                when (16#11#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T4_IN_MOD" Field
                    v_ram_address                         := "01000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(2 downto 0) <= v_ram_readdata(2 downto 0);

                when (16#12#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T3_IN_MOD" Field
                    v_ram_address                         := "01001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(2 downto 0) <= v_ram_readdata(26 downto 24);

                when (16#13#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T2_IN_MOD" Field
                    v_ram_address                         := "01001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(2 downto 0) <= v_ram_readdata(18 downto 16);

                when (16#14#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T1_IN_MOD" Field
                    v_ram_address                         := "01001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(2 downto 0) <= v_ram_readdata(10 downto 8);

                when (16#15#) =>
                    -- DEB General Configuration Area Register "DTC_IN_MOD" : "T0_IN_MOD" Field
                    v_ram_address                         := "01001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(2 downto 0) <= v_ram_readdata(2 downto 0);

                when (16#16#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_X" Field
                    v_ram_address                         := "01010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(5 downto 0) <= v_ram_readdata(13 downto 8);

                when (16#17#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_Y" Field
                    v_ram_address                         := "01010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(5 downto 0) <= v_ram_readdata(5 downto 0);

                when (16#18#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
                    v_ram_address                         := "01011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(25 downto 16);

                when (16#19#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
                    v_ram_address                         := "01011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(9 downto 0);

                when (16#1A#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
                    v_ram_address                         := "01100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(25 downto 16);

                when (16#1B#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
                    v_ram_address                         := "01100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(9 downto 0);

                when (16#1C#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
                    v_ram_address                         := "01101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(25 downto 16);

                when (16#1D#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
                    v_ram_address                         := "01101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(9 downto 0);

                when (16#1E#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
                    v_ram_address                         := "01110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(25 downto 16);

                when (16#1F#) =>
                    -- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
                    v_ram_address                         := "01110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(9 downto 0) <= v_ram_readdata(9 downto 0);

                when (16#20#) =>
                    -- DEB General Configuration Area Register "DTC_OVS_DEB" : "OVS_LIN_DEB" Field
                    v_ram_address                         := "01111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(3 downto 0) <= v_ram_readdata(3 downto 0);

                when (16#21#) =>
                    -- DEB General Configuration Area Register "DTC_SIZ_DEB" : "NB_LIN_DEB" Field
                    v_ram_address                          := "10000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(13 downto 0) <= v_ram_readdata(29 downto 16);

                when (16#22#) =>
                    -- DEB General Configuration Area Register "DTC_SIZ_DEB" : "NB_PIX_DEB" Field
                    v_ram_address                          := "10000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(12 downto 0) <= v_ram_readdata(12 downto 0);

                when (16#23#) =>
                    -- DEB General Configuration Area Register "DTC_TRG_25S" : "2_5S_N_CYC" Field
                    v_ram_address                         := "10001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(7 downto 0) <= v_ram_readdata(7 downto 0);

                when (16#24#) =>
                    -- DEB General Configuration Area Register "DTC_SEL_TRG" : "TRG_SRC" Field
                    v_ram_address                := "10010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(0);

                when (16#25#) =>
                    -- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
                    v_ram_address                          := "10011";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(15 downto 0) <= v_ram_readdata(15 downto 0);

                when (16#26#) =>
                    -- DEB General Configuration Area Register "DTC_SEL_SYN" : "SYN_FRQ" Field
                    v_ram_address                := "10100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(0);

                when (16#27#) =>
                    -- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_SPW" Field
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_rst_cps.rst_spw;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#28#) =>
                    -- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_WDG" Field
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_rst_cps.rst_wdg;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#29#) =>
                    -- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
                    v_ram_address                          := "10110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(23 downto 0) <= v_ram_readdata(23 downto 0);

                when (16#2A#) =>
                    -- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
                    v_ram_address                          := "10111";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(31 downto 0) <= v_ram_readdata(31 downto 0);

                when (16#2B#) =>
                    -- DEB General Configuration Area Register "DTC_SPW_CFG" : "TIMECODE" Field
                    v_ram_address                         := "11000";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(1 downto 0);

                when (16#2C#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "OPER_MOD" Field
                    v_ram_address                         := "11001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(2 downto 0) <= v_ram_readdata(26 downto 24);

                when (16#2D#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_CORR_ERR" Field
                    v_ram_address                         := "11001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(5 downto 0) <= v_ram_readdata(23 downto 18);

                when (16#2E#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_UNCORR_ERR" Field
                    v_ram_address                         := "11001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(17 downto 16);

                when (16#2F#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "NB_PLLPERIOD", "PLL_REF", "PLL_VCXO", "PLL_LOCK" Fields
                    v_ram_address                         := "11001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(6 downto 0) <= v_ram_readdata(14 downto 8);

                when (16#30#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_4" Field
                    v_ram_address                := "11001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(7);

                when (16#31#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_3" Field
                    v_ram_address                := "11001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(6);

                when (16#32#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_2" Field
                    v_ram_address                := "11001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(5);

                when (16#33#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_1" Field
                    v_ram_address                := "11001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(4);

                when (16#34#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "WDW_LIST_CNT_OVF" Field
                    v_ram_address                         := "11001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata             <= (others => '0');
                    avalon_mm_rmap_o.readdata(1 downto 0) <= v_ram_readdata(3 downto 2);

                when (16#35#) =>
                    -- DEB Housekeeping Area Register "DEB_STATUS" : "WDG" Field
                    v_ram_address                := "11001";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(0);

                when (16#36#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_8" Field
                    v_ram_address                := "11010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(31);

                when (16#37#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_7" Field
                    v_ram_address                := "11010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(30);

                when (16#38#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_6" Field
                    v_ram_address                := "11010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(29);

                when (16#39#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_5" Field
                    v_ram_address                := "11010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(28);

                when (16#3A#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_4" Field
                    v_ram_address                := "11010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(27);

                when (16#3B#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_3" Field
                    v_ram_address                := "11010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(26);

                when (16#3C#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_2" Field
                    v_ram_address                := "11010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(25);

                when (16#3D#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_1" Field
                    v_ram_address                := "11010";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.readdata(0) <= v_ram_readdata(24);

                when (16#3E#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_8" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_8;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#3F#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_7" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_7;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#40#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_6" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_6;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#41#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_5" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_5;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#42#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_4" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_4;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#43#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_3" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_3;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#44#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_2" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_2;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#45#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_1" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_1;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#46#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_4" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_4;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#47#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_3" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_3;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#48#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_2" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_2;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#49#) =>
                    -- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_1" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_1;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#4A#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "STATE_4" Field
                    avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_rd_i.deb_hk_spw_status.state_4;
                    avalon_mm_rmap_o.waitrequest          <= '0';

                when (16#4B#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "CRD_4" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.crd_4;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#4C#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "FIFO_4" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.fifo_4;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#4D#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "ESC_4" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.esc_4;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#4E#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "PAR_4" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.par_4;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#4F#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "DISC_4" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.disc_4;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#50#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "STATE_3" Field
                    avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_rd_i.deb_hk_spw_status.state_3;
                    avalon_mm_rmap_o.waitrequest          <= '0';

                when (16#51#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "CRD_3" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.crd_3;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#52#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "FIFO_3" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.fifo_3;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#53#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "ESC_3" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.esc_3;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#54#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "PAR_3" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.par_3;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#55#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "DISC_3" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.disc_3;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#56#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "STATE_2" Field
                    avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_rd_i.deb_hk_spw_status.state_2;
                    avalon_mm_rmap_o.waitrequest          <= '0';

                when (16#57#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "CRD_2" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.crd_2;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#58#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "FIFO_2" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.fifo_2;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#59#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "ESC_2" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.esc_2;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#5A#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "PAR_2" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.par_2;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#5B#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "DISC_2" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.disc_2;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#5C#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "STATE_1" Field
                    avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_rd_i.deb_hk_spw_status.state_1;
                    avalon_mm_rmap_o.waitrequest          <= '0';

                when (16#5D#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "CRD_1" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.crd_1;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#5E#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "FIFO_1" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.fifo_1;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#5F#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "ESC_1" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.esc_1;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#60#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "PAR_1" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.par_1;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#61#) =>
                    -- DEB Housekeeping Area Register "SPW_STATUS" : "DISC_1" Field
                    avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.disc_1;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#62#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK1" : "DEB_TEMP" Field
                    v_ram_address                          := "11100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(27 downto 16);

                when (16#63#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK1" : "VIO" Field
                    v_ram_address                          := "11100";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(11 downto 0);

                when (16#64#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK2" : "VLVD" Field
                    v_ram_address                          := "11101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(27 downto 16);

                when (16#65#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK2" : "VCOR" Field
                    v_ram_address                          := "11101";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(11 downto 0) <= v_ram_readdata(11 downto 0);

                when (16#66#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK3" : "STATUS_AEB4" Field
                    v_ram_address                          := "11110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(7 downto 0) <= v_ram_readdata(31 downto 24);
                    
                when (16#67#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK3" : "STATUS_AEB3" Field
                    v_ram_address                          := "11110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(7 downto 0) <= v_ram_readdata(23 downto 16);
                    
                when (16#68#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK3" : "STATUS_AEB2" Field
                    v_ram_address                          := "11110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(7 downto 0) <= v_ram_readdata(15 downto 8);
                    
                when (16#69#) =>
                    -- DEB Housekeeping Area Register "DEB_AHK3" : "STATUS_AEB1" Field
                    v_ram_address                          := "11110";
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata              <= (others => '0');
                    avalon_mm_rmap_o.readdata(7 downto 0) <= v_ram_readdata(7 downto 0);

                when (16#6A#) =>
                    -- RAM Memory Control - Address
                    avalon_mm_rmap_o.readdata    <= ram_mem_direct_access_i.addr;
                    avalon_mm_rmap_o.waitrequest <= '0';

                when (16#6B#) =>
                    -- RAM Memory Control - Data
                    v_ram_address             := ram_mem_direct_access_i.addr((v_ram_address'length - 1) downto 0);
                    p_rmap_ram_rd(v_ram_address, avalon_mm_rmap_o.waitrequest, v_ram_readdata);
                    avalon_mm_rmap_o.readdata <= v_ram_readdata;

                when others =>
                    -- No register associated to the address, return with 0x00000000
                    avalon_mm_rmap_o.readdata    <= (others => '0');
                    avalon_mm_rmap_o.waitrequest <= '0';

            end case;

        end procedure p_avs_readdata;
        --
        variable v_fee_read_address : std_logic_vector(31 downto 0)          := (others => '0');
        variable v_avs_read_address : t_fdrm_avalon_mm_rmap_ffee_deb_address := 0;
    begin
        if (rst_i = '1') then
            fee_rmap_o.readdata          <= (others => '0');
            fee_rmap_o.waitrequest       <= '1';
            avalon_mm_rmap_o.readdata    <= (others => '0');
            avalon_mm_rmap_o.waitrequest <= '1';
            s_read_started               <= '0';
            s_read_in_progress           <= '0';
            s_read_finished              <= '0';
            v_fee_read_address           := (others => '0');
            v_avs_read_address           := 0;
        elsif (rising_edge(clk_i)) then

            fee_rmap_o.readdata          <= (others => '0');
            fee_rmap_o.waitrequest       <= '1';
            avalon_mm_rmap_o.readdata    <= (others => '0');
            avalon_mm_rmap_o.waitrequest <= '1';
            s_read_started               <= '0';
            s_read_in_progress           <= '0';
            s_read_finished              <= '0';
            if (fee_rmap_i.read = '1') then
                v_fee_read_address := fee_rmap_i.address;
                --                fee_rmap_o.waitrequest <= '0';
                p_ffee_deb_rmap_mem_rd(v_fee_read_address);
            elsif (avalon_mm_rmap_i.read = '1') then
                v_avs_read_address := to_integer(unsigned(avalon_mm_rmap_i.address));
                --                avalon_mm_rmap_o.waitrequest <= '0';
                p_avs_readdata(v_avs_read_address);
            end if;

        end if;
    end process p_fdrm_rmap_mem_area_ffee_deb_read;

end architecture RTL;
