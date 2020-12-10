library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package fdrm_rmap_mem_area_ffee_deb_pkg is

	constant c_FDRM_FFEE_DEB_RMAP_ADRESS_SIZE : natural := 32;
	constant c_FDRM_FFEE_DEB_RMAP_DATA_SIZE   : natural := 8;
	constant c_FDRM_FFEE_DEB_RMAP_SYMBOL_SIZE : natural := 8;

	type t_fdrm_ffee_deb_rmap_read_in is record
		address : std_logic_vector((c_FDRM_FFEE_DEB_RMAP_ADRESS_SIZE - 1) downto 0);
		read    : std_logic;
	end record t_fdrm_ffee_deb_rmap_read_in;

	type t_fdrm_ffee_deb_rmap_read_out is record
		readdata    : std_logic_vector((c_FDRM_FFEE_DEB_RMAP_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_fdrm_ffee_deb_rmap_read_out;

	type t_fdrm_ffee_deb_rmap_write_in is record
		address   : std_logic_vector((c_FDRM_FFEE_DEB_RMAP_ADRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((c_FDRM_FFEE_DEB_RMAP_DATA_SIZE - 1) downto 0);
	end record t_fdrm_ffee_deb_rmap_write_in;

	type t_fdrm_ffee_deb_rmap_write_out is record
		waitrequest : std_logic;
	end record t_fdrm_ffee_deb_rmap_write_out;

	constant c_FDRM_FFEE_DEB_RMAP_READ_IN_RST : t_fdrm_ffee_deb_rmap_read_in := (
		address => (others => '0'),
		read    => '0'
	);

	constant c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST : t_fdrm_ffee_deb_rmap_read_out := (
		readdata    => (others => '0'),
		waitrequest => '1'
	);

	constant c_FDRM_FFEE_DEB_RMAP_WRITE_IN_RST : t_fdrm_ffee_deb_rmap_write_in := (
		address   => (others => '0'),
		write     => '0',
		writedata => (others => '0')
	);

	constant c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST : t_fdrm_ffee_deb_rmap_write_out := (
		waitrequest => '1'
	);

	constant c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH : natural                       := 12; -- number of non-masking bits in the offset mask (0xXXX)
	constant c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK  : std_logic_vector(31 downto 0) := x"00002000"; -- addr offset: 0x00002XXX

	-- Address Constants

	-- Allowed Addresses
	constant c_FDRM_AVALON_MM_FFEE_DEB_RMAP_MIN_ADDR : natural range 0 to 255 := 16#00#;
	constant c_FDRM_AVALON_MM_FFEE_DEB_RMAP_MAX_ADDR : natural range 0 to 255 := 16#66#;

	-- Registers Types

	-- DEB Housekeeping Area Register "DEB_OVF"
	type t_deb_hk_deb_ovf_rd_reg is record
		outbuff_8 : std_logic;          -- "OUTBUFF_8" Field
		outbuff_7 : std_logic;          -- "OUTBUFF_7" Field
		outbuff_6 : std_logic;          -- "OUTBUFF_6" Field
		outbuff_5 : std_logic;          -- "OUTBUFF_5" Field
		outbuff_4 : std_logic;          -- "OUTBUFF_4" Field
		outbuff_3 : std_logic;          -- "OUTBUFF_3" Field
		outbuff_2 : std_logic;          -- "OUTBUFF_2" Field
		outbuff_1 : std_logic;          -- "OUTBUFF_1" Field
		rmap_4    : std_logic;          -- "RMAP_4" Field
		rmap_3    : std_logic;          -- "RMAP_3" Field
		rmap_2    : std_logic;          -- "RMAP_2" Field
		rmap_1    : std_logic;          -- "RMAP_1" Field
	end record t_deb_hk_deb_ovf_rd_reg;

	-- DEB Housekeeping Area Register "SPW_STATUS"
	type t_deb_hk_spw_status_rd_reg is record
		state_4 : std_logic_vector(2 downto 0); -- "STATE_4" Field
		crd_4   : std_logic;            -- "CRD_4" Field
		fifo_4  : std_logic;            -- "FIFO_4" Field
		esc_4   : std_logic;            -- "ESC_4" Field
		par_4   : std_logic;            -- "PAR_4" Field
		disc_4  : std_logic;            -- "DISC_4" Field
		state_3 : std_logic_vector(2 downto 0); -- "STATE_3" Field
		crd_3   : std_logic;            -- "CRD_3" Field
		fifo_3  : std_logic;            -- "FIFO_3" Field
		esc_3   : std_logic;            -- "ESC_3" Field
		par_3   : std_logic;            -- "PAR_3" Field
		disc_3  : std_logic;            -- "DISC_3" Field
		state_2 : std_logic_vector(2 downto 0); -- "STATE_2" Field
		crd_2   : std_logic;            -- "CRD_2" Field
		fifo_2  : std_logic;            -- "FIFO_2" Field
		esc_2   : std_logic;            -- "ESC_2" Field
		par_2   : std_logic;            -- "PAR_2" Field
		disc_2  : std_logic;            -- "DISC_2" Field
		state_1 : std_logic_vector(2 downto 0); -- "STATE_1" Field
		crd_1   : std_logic;            -- "CRD_1" Field
		fifo_1  : std_logic;            -- "FIFO_1" Field
		esc_1   : std_logic;            -- "ESC_1" Field
		par_1   : std_logic;            -- "PAR_1" Field
		disc_1  : std_logic;            -- "DISC_1" Field
	end record t_deb_hk_spw_status_rd_reg;

	-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF"
	type t_deb_crit_cfg_dtc_aeb_onoff_wr_reg is record
		aeb_idx3 : std_logic;           -- "AEB_IDX3" Field
		aeb_idx2 : std_logic;           -- "AEB_IDX2" Field
		aeb_idx1 : std_logic;           -- "AEB_IDX1" Field
		aeb_idx0 : std_logic;           -- "AEB_IDX0" Field
	end record t_deb_crit_cfg_dtc_aeb_onoff_wr_reg;

	-- DEB Critical Configuration Area Register "DTC_FEE_MOD"
	type t_deb_crit_cfg_dtc_fee_mod_wr_reg is record
		oper_mod : std_logic_vector(2 downto 0); -- "OPER_MOD" Field
	end record t_deb_crit_cfg_dtc_fee_mod_wr_reg;

	-- DEB Critical Configuration Area Register "DTC_IMM_ONMOD"
	type t_deb_crit_cfg_dtc_imm_onmod_wr_reg is record
		imm_on : std_logic;             -- "IMM_ON" Field
	end record t_deb_crit_cfg_dtc_imm_onmod_wr_reg;

	-- DEB Critical Configuration Area Register "DTC_PLL_REG_0"
	type t_deb_crit_cfg_dtc_pll_reg_0_wr_reg is record
		pfdfc    : std_logic;           -- "PFDFC" Field
		gtme     : std_logic;           -- "GTME" Field
		holdtr   : std_logic;           -- "HOLDTR" Field
		holdf    : std_logic;           -- "HOLDF" Field
		others_0 : std_logic_vector(6 downto 0); -- FOFF, "LOCK1", "LOCK0", "LOCKW1", "LOCKW0", "C1", "C0" Fields
	end record t_deb_crit_cfg_dtc_pll_reg_0_wr_reg;

	-- DEB Critical Configuration Area Register "DTC_PLL_REG_1"
	type t_deb_crit_cfg_dtc_pll_reg_1_wr_reg is record
		others_0 : std_logic_vector(31 downto 0); -- "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields
	end record t_deb_crit_cfg_dtc_pll_reg_1_wr_reg;

	-- DEB Critical Configuration Area Register "DTC_PLL_REG_2"
	type t_deb_crit_cfg_dtc_pll_reg_2_wr_reg is record
		others_0 : std_logic_vector(31 downto 0); -- 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields
	end record t_deb_crit_cfg_dtc_pll_reg_2_wr_reg;

	-- DEB Critical Configuration Area Register "DTC_PLL_REG_3"
	type t_deb_crit_cfg_dtc_pll_reg_3_wr_reg is record
		others_0 : std_logic_vector(31 downto 0); -- REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields
	end record t_deb_crit_cfg_dtc_pll_reg_3_wr_reg;

	-- DEB General Configuration Area Register "DTC_25S_DLY"
	type t_deb_gen_cfg_dtc_25s_dly_wr_reg is record
		n25s_dly : std_logic_vector(23 downto 0); -- "25S_DLY" Field
	end record t_deb_gen_cfg_dtc_25s_dly_wr_reg;

	-- DEB General Configuration Area Register "DTC_FRM_CNT"
	type t_deb_gen_cfg_dtc_frm_cnt_wr_reg is record
		pset_frm_cnt : std_logic_vector(15 downto 0); -- "PSET_FRM_CNT" Field
	end record t_deb_gen_cfg_dtc_frm_cnt_wr_reg;

	-- DEB General Configuration Area Register "DTC_IN_MOD"
	type t_deb_gen_cfg_dtc_in_mod_wr_reg is record
		t7_in_mod : std_logic_vector(2 downto 0); -- "T7_IN_MOD" Field
		t6_in_mod : std_logic_vector(2 downto 0); -- "T6_IN_MOD" Field
		t5_in_mod : std_logic_vector(2 downto 0); -- "T5_IN_MOD" Field
		t4_in_mod : std_logic_vector(2 downto 0); -- "T4_IN_MOD" Field
		t3_in_mod : std_logic_vector(2 downto 0); -- "T3_IN_MOD" Field
		t2_in_mod : std_logic_vector(2 downto 0); -- "T2_IN_MOD" Field
		t1_in_mod : std_logic_vector(2 downto 0); -- "T1_IN_MOD" Field
		t0_in_mod : std_logic_vector(2 downto 0); -- "T0_IN_MOD" Field
	end record t_deb_gen_cfg_dtc_in_mod_wr_reg;

	-- DEB General Configuration Area Register "DTC_OVS_PAT"
	type t_deb_gen_cfg_dtc_ovs_pat_wr_reg is record
		ovs_lin_pat : std_logic_vector(3 downto 0); -- "OVS_LIN_PAT" Field
	end record t_deb_gen_cfg_dtc_ovs_pat_wr_reg;

	-- DEB General Configuration Area Register "DTC_RST_CPS"
	type t_deb_gen_cfg_dtc_rst_cps_wr_reg is record
		rst_spw : std_logic;            -- "RST_SPW" Field
		rst_wdg : std_logic;            -- "RST_WDG" Field
	end record t_deb_gen_cfg_dtc_rst_cps_wr_reg;

	-- DEB General Configuration Area Register "DTC_SEL_SYN"
	type t_deb_gen_cfg_dtc_sel_syn_wr_reg is record
		syn_frq : std_logic;            -- "SYN_FRQ" Field
	end record t_deb_gen_cfg_dtc_sel_syn_wr_reg;

	-- DEB General Configuration Area Register "DTC_SEL_TRG"
	type t_deb_gen_cfg_dtc_sel_trg_wr_reg is record
		trg_src : std_logic;            -- "TRG_SRC" Field
	end record t_deb_gen_cfg_dtc_sel_trg_wr_reg;

	-- DEB General Configuration Area Register "DTC_SIZ_PAT"
	type t_deb_gen_cfg_dtc_siz_pat_wr_reg is record
		nb_lin_pat : std_logic_vector(13 downto 0); -- "NB_LIN_PAT" Field
		nb_pix_pat : std_logic_vector(12 downto 0); -- "NB_PIX_PAT" Field
	end record t_deb_gen_cfg_dtc_siz_pat_wr_reg;

	-- DEB General Configuration Area Register "DTC_SPW_CFG"
	type t_deb_gen_cfg_dtc_spw_cfg_wr_reg is record
		timecode : std_logic_vector(1 downto 0); -- "TIMECODE" Field
	end record t_deb_gen_cfg_dtc_spw_cfg_wr_reg;

	-- DEB General Configuration Area Register "DTC_TMOD_CONF"
	type t_deb_gen_cfg_dtc_tmod_conf_wr_reg is record
		reserved : std_logic_vector(31 downto 0); -- "RESERVED" Field
	end record t_deb_gen_cfg_dtc_tmod_conf_wr_reg;

	-- DEB General Configuration Area Register "DTC_TRG_25S"
	type t_deb_gen_cfg_dtc_trg_25s_wr_reg is record
		n2_5s_n_cyc : std_logic_vector(7 downto 0); -- "2_5S_N_CYC" Field
	end record t_deb_gen_cfg_dtc_trg_25s_wr_reg;

	-- DEB General Configuration Area Register "DTC_WDW_IDX"
	type t_deb_gen_cfg_dtc_wdw_idx_wr_reg is record
		wdw_idx_4 : std_logic_vector(9 downto 0); -- "WDW_IDX_4" Field
		wdw_len_4 : std_logic_vector(9 downto 0); -- "WDW_LEN_4" Field
		wdw_idx_3 : std_logic_vector(9 downto 0); -- "WDW_IDX_3" Field
		wdw_len_3 : std_logic_vector(9 downto 0); -- "WDW_LEN_3" Field
		wdw_idx_2 : std_logic_vector(9 downto 0); -- "WDW_IDX_2" Field
		wdw_len_2 : std_logic_vector(9 downto 0); -- "WDW_LEN_2" Field
		wdw_idx_1 : std_logic_vector(9 downto 0); -- "WDW_IDX_1" Field
		wdw_len_1 : std_logic_vector(9 downto 0); -- "WDW_LEN_1" Field
	end record t_deb_gen_cfg_dtc_wdw_idx_wr_reg;

	-- DEB General Configuration Area Register "DTC_WDW_SIZ"
	type t_deb_gen_cfg_dtc_wdw_siz_wr_reg is record
		w_siz_x : std_logic_vector(5 downto 0); -- "W_SIZ_X" Field
		w_siz_y : std_logic_vector(5 downto 0); -- "W_SIZ_Y" Field
	end record t_deb_gen_cfg_dtc_wdw_siz_wr_reg;

	-- DEB Housekeeping Area Register "DEB_AHK1"
	type t_deb_hk_deb_ahk1_wr_reg is record
		vdig_in : std_logic_vector(11 downto 0); -- "VDIG_IN" Field
		vio     : std_logic_vector(11 downto 0); -- "VIO" Field
	end record t_deb_hk_deb_ahk1_wr_reg;

	-- DEB Housekeeping Area Register "DEB_AHK2"
	type t_deb_hk_deb_ahk2_wr_reg is record
		vcor : std_logic_vector(11 downto 0); -- "VCOR" Field
		vlvd : std_logic_vector(11 downto 0); -- "VLVD" Field
	end record t_deb_hk_deb_ahk2_wr_reg;

	-- DEB Housekeeping Area Register "DEB_AHK3"
	type t_deb_hk_deb_ahk3_wr_reg is record
		deb_temp : std_logic_vector(11 downto 0); -- "DEB_TEMP" Field
	end record t_deb_hk_deb_ahk3_wr_reg;

	-- DEB Housekeeping Area Register "DEB_OVF"
	type t_deb_hk_deb_ovf_wr_reg is record
		row_act_list_8 : std_logic;     -- "ROW_ACT_LIST_8" Field
		row_act_list_7 : std_logic;     -- "ROW_ACT_LIST_7" Field
		row_act_list_6 : std_logic;     -- "ROW_ACT_LIST_6" Field
		row_act_list_5 : std_logic;     -- "ROW_ACT_LIST_5" Field
		row_act_list_4 : std_logic;     -- "ROW_ACT_LIST_4" Field
		row_act_list_3 : std_logic;     -- "ROW_ACT_LIST_3" Field
		row_act_list_2 : std_logic;     -- "ROW_ACT_LIST_2" Field
		row_act_list_1 : std_logic;     -- "ROW_ACT_LIST_1" Field
	end record t_deb_hk_deb_ovf_wr_reg;

	-- DEB Housekeeping Area Register "DEB_STATUS"
	type t_deb_hk_deb_status_wr_reg is record
		oper_mod             : std_logic_vector(2 downto 0); -- "OPER_MOD" Field
		edac_list_corr_err   : std_logic_vector(5 downto 0); -- "EDAC_LIST_CORR_ERR" Field
		edac_list_uncorr_err : std_logic_vector(1 downto 0); -- "EDAC_LIST_UNCORR_ERR" Field
		others_0             : std_logic_vector(2 downto 0); -- PLL_REF, "PLL_VCXO", "PLL_LOCK" Fields
		vdig_aeb_4           : std_logic; -- "VDIG_AEB_4" Field
		vdig_aeb_3           : std_logic; -- "VDIG_AEB_3" Field
		vdig_aeb_2           : std_logic; -- "VDIG_AEB_2" Field
		vdig_aeb_1           : std_logic; -- "VDIG_AEB_1" Field
		wdw_list_cnt_ovf     : std_logic_vector(1 downto 0); -- "WDW_LIST_CNT_OVF" Field
		wdg                  : std_logic; -- "WDG" Field
	end record t_deb_hk_deb_status_wr_reg;

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_rmap_memory_wr_area is record
		deb_crit_cfg_dtc_aeb_onoff : t_deb_crit_cfg_dtc_aeb_onoff_wr_reg; -- DEB Critical Configuration Area Register "DTC_AEB_ONOFF"
		deb_crit_cfg_dtc_fee_mod   : t_deb_crit_cfg_dtc_fee_mod_wr_reg; -- DEB Critical Configuration Area Register "DTC_FEE_MOD"
		deb_crit_cfg_dtc_imm_onmod : t_deb_crit_cfg_dtc_imm_onmod_wr_reg; -- DEB Critical Configuration Area Register "DTC_IMM_ONMOD"
		deb_crit_cfg_dtc_pll_reg_0 : t_deb_crit_cfg_dtc_pll_reg_0_wr_reg; -- DEB Critical Configuration Area Register "DTC_PLL_REG_0"
		deb_crit_cfg_dtc_pll_reg_1 : t_deb_crit_cfg_dtc_pll_reg_1_wr_reg; -- DEB Critical Configuration Area Register "DTC_PLL_REG_1"
		deb_crit_cfg_dtc_pll_reg_2 : t_deb_crit_cfg_dtc_pll_reg_2_wr_reg; -- DEB Critical Configuration Area Register "DTC_PLL_REG_2"
		deb_crit_cfg_dtc_pll_reg_3 : t_deb_crit_cfg_dtc_pll_reg_3_wr_reg; -- DEB Critical Configuration Area Register "DTC_PLL_REG_3"
		deb_gen_cfg_dtc_25s_dly    : t_deb_gen_cfg_dtc_25s_dly_wr_reg; -- DEB General Configuration Area Register "DTC_25S_DLY"
		deb_gen_cfg_dtc_frm_cnt    : t_deb_gen_cfg_dtc_frm_cnt_wr_reg; -- DEB General Configuration Area Register "DTC_FRM_CNT"
		deb_gen_cfg_dtc_in_mod     : t_deb_gen_cfg_dtc_in_mod_wr_reg; -- DEB General Configuration Area Register "DTC_IN_MOD"
		deb_gen_cfg_dtc_ovs_pat    : t_deb_gen_cfg_dtc_ovs_pat_wr_reg; -- DEB General Configuration Area Register "DTC_OVS_PAT"
		deb_gen_cfg_dtc_rst_cps    : t_deb_gen_cfg_dtc_rst_cps_wr_reg; -- DEB General Configuration Area Register "DTC_RST_CPS"
		deb_gen_cfg_dtc_sel_syn    : t_deb_gen_cfg_dtc_sel_syn_wr_reg; -- DEB General Configuration Area Register "DTC_SEL_SYN"
		deb_gen_cfg_dtc_sel_trg    : t_deb_gen_cfg_dtc_sel_trg_wr_reg; -- DEB General Configuration Area Register "DTC_SEL_TRG"
		deb_gen_cfg_dtc_siz_pat    : t_deb_gen_cfg_dtc_siz_pat_wr_reg; -- DEB General Configuration Area Register "DTC_SIZ_PAT"
		deb_gen_cfg_dtc_spw_cfg    : t_deb_gen_cfg_dtc_spw_cfg_wr_reg; -- DEB General Configuration Area Register "DTC_SPW_CFG"
		deb_gen_cfg_dtc_tmod_conf  : t_deb_gen_cfg_dtc_tmod_conf_wr_reg; -- DEB General Configuration Area Register "DTC_TMOD_CONF"
		deb_gen_cfg_dtc_trg_25s    : t_deb_gen_cfg_dtc_trg_25s_wr_reg; -- DEB General Configuration Area Register "DTC_TRG_25S"
		deb_gen_cfg_dtc_wdw_idx    : t_deb_gen_cfg_dtc_wdw_idx_wr_reg; -- DEB General Configuration Area Register "DTC_WDW_IDX"
		deb_gen_cfg_dtc_wdw_siz    : t_deb_gen_cfg_dtc_wdw_siz_wr_reg; -- DEB General Configuration Area Register "DTC_WDW_SIZ"
		deb_hk_deb_ahk1            : t_deb_hk_deb_ahk1_wr_reg; -- DEB Housekeeping Area Register "DEB_AHK1"
		deb_hk_deb_ahk2            : t_deb_hk_deb_ahk2_wr_reg; -- DEB Housekeeping Area Register "DEB_AHK2"
		deb_hk_deb_ahk3            : t_deb_hk_deb_ahk3_wr_reg; -- DEB Housekeeping Area Register "DEB_AHK3"
		deb_hk_deb_ovf_wr          : t_deb_hk_deb_ovf_wr_reg; -- DEB Housekeeping Area Register "DEB_OVF"
		deb_hk_deb_status          : t_deb_hk_deb_status_wr_reg; -- DEB Housekeeping Area Register "DEB_STATUS"
	end record t_rmap_memory_wr_area;

	-- Avalon MM Read-Only Registers
	type t_rmap_memory_rd_area is record
		deb_hk_deb_ovf_rd : t_deb_hk_deb_ovf_rd_reg; -- DEB Housekeeping Area Register "DEB_OVF"
		deb_hk_spw_status : t_deb_hk_spw_status_rd_reg; -- DEB Housekeeping Area Register "SPW_STATUS"
	end record t_rmap_memory_rd_area;

end package fdrm_rmap_mem_area_ffee_deb_pkg;

package body fdrm_rmap_mem_area_ffee_deb_pkg is
end package body fdrm_rmap_mem_area_ffee_deb_pkg;
