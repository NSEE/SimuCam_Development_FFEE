library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fdrm_rmap_mem_area_ffee_deb_pkg.all;
use work.fdrm_avalon_mm_rmap_ffee_deb_pkg.all;

entity fdrm_rmap_mem_area_ffee_deb_write_ent is
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		fee_rmap_i          : in  t_fdrm_ffee_deb_rmap_write_in;
		avalon_mm_rmap_i    : in  t_fdrm_avalon_mm_rmap_ffee_deb_write_in;
		fee_rmap_o          : out t_fdrm_ffee_deb_rmap_write_out;
		avalon_mm_rmap_o    : out t_fdrm_avalon_mm_rmap_ffee_deb_write_out;
		rmap_registers_wr_o : out t_rmap_memory_wr_area
	);
end entity fdrm_rmap_mem_area_ffee_deb_write_ent;

architecture RTL of fdrm_rmap_mem_area_ffee_deb_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_fdrm_rmap_mem_area_ffee_deb_write : process(clk_i, rst_i) is
		procedure p_ffee_deb_reg_reset is
		begin

			-- Write Registers Reset/Default State

			-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX3" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_aeb_onoff.aeb_idx3       <= '0';
			-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX2" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_aeb_onoff.aeb_idx2       <= '0';
			-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX1" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_aeb_onoff.aeb_idx1       <= '0';
			-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX0" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_aeb_onoff.aeb_idx0       <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "PFDFC" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.pfdfc          <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "GTME" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.gtme           <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDTR" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.holdtr         <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDF" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.holdf          <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "FOFF" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.foff           <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCK1" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.lock1          <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCK0" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.lock0          <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCKW1" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.lockw1         <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCKW0" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.lockw0         <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "C1" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.c1             <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "C0" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.c0             <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.hold           <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "RESET" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.reset          <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "RESHOL" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.reshol         <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PD" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.pd             <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y4MUX" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y4mux          <= "000";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y3MUX" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y3mux          <= "000";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y2MUX" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y2mux          <= "000";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y1MUX" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y1mux          <= "101";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y0MUX" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y0mux          <= "000";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "FB_MUX" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.fb_mux         <= "000";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PFD" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.pfd            <= "00";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "CP_current" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.cp_current     <= x"F";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PRECP" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.precp          <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "CP_DIR" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.cp_dir         <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "C1" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.c1             <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "C0" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.c0             <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "90DIV8" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.n90div8        <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "90DIV4" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.n90div4        <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "ADLOCK" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.adlock         <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "SXOIREF" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.sxoiref        <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "SREF" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.sref           <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y4_Mode" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y4_mode <= x"5";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y3_Mode" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y3_mode <= x"0";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y2_Mode" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y2_mode <= x"0";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y1_Mode" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y1_mode <= x"0";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y0_Mode" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y0_mode <= x"5";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL4" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel4        <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL3" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel3        <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL2" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel2        <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL1" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel1        <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL0" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel0        <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "C1" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.c1             <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "C0" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.c0             <= '1';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "REFDEC" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.refdec         <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "MANAUT" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.manaut         <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "DLYN" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.dlyn           <= "111";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "DLYM" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.dlym           <= "000";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "N" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.n              <= x"001";
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "M" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.m              <= (others => '0');
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "C1" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.c1             <= '0';
			-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "C0" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.c0             <= '0';
			-- DEB Critical Configuration Area Register "DTC_FEE_MOD" : "OPER_MOD" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_fee_mod.oper_mod         <= "111";
			-- DEB Critical Configuration Area Register "DTC_IMM_ONMOD" : "IMM_ON" Field
			rmap_registers_wr_o.deb_crit_cfg_dtc_imm_onmod.imm_on         <= '0';
			-- DEB General Configuration Area Register "DTC_IN_MOD" : "T7_IN_MOD" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t7_in_mod          <= "000";
			-- DEB General Configuration Area Register "DTC_IN_MOD" : "T6_IN_MOD" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t6_in_mod          <= "000";
			-- DEB General Configuration Area Register "DTC_IN_MOD" : "T5_IN_MOD" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t5_in_mod          <= "000";
			-- DEB General Configuration Area Register "DTC_IN_MOD" : "T4_IN_MOD" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t4_in_mod          <= "000";
			-- DEB General Configuration Area Register "DTC_IN_MOD" : "T3_IN_MOD" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t3_in_mod          <= "000";
			-- DEB General Configuration Area Register "DTC_IN_MOD" : "T2_IN_MOD" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t2_in_mod          <= "000";
			-- DEB General Configuration Area Register "DTC_IN_MOD" : "T1_IN_MOD" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t1_in_mod          <= "000";
			-- DEB General Configuration Area Register "DTC_IN_MOD" : "T0_IN_MOD" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t0_in_mod          <= "000";
			-- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_X" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_siz.w_siz_x           <= (others => '0');
			-- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_Y" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_siz.w_siz_y           <= (others => '0');
			-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_4         <= (others => '0');
			-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_4         <= (others => '0');
			-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_3         <= (others => '0');
			-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_3         <= (others => '0');
			-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_2         <= (others => '0');
			-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_2         <= (others => '0');
			-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_1         <= (others => '0');
			-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_1         <= (others => '0');
			-- DEB General Configuration Area Register "DTC_OVS_PAT" : "OVS_LIN_PAT" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_ovs_pat.ovs_lin_pat       <= (others => '0');
			-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_LIN_PAT" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_siz_pat.nb_lin_pat        <= (others => '0');
			-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_PIX_PAT" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_siz_pat.nb_pix_pat        <= (others => '0');
			-- DEB General Configuration Area Register "DTC_TRG_25S" : "2_5S_N_CYC" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_trg_25s.n2_5s_n_cyc       <= (others => '0');
			-- DEB General Configuration Area Register "DTC_SEL_TRG" : "TRG_SRC" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_sel_trg.trg_src           <= '0';
			-- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_frm_cnt.pset_frm_cnt      <= (others => '0');
			-- DEB General Configuration Area Register "DTC_SEL_SYN" : "SYN_FRQ" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_sel_syn.syn_frq           <= '0';
			-- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_SPW" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_spw           <= '0';
			-- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_WDG" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_wdg           <= '0';
			-- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_25s_dly.n25s_dly          <= (others => '0');
			-- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_tmod_conf.reserved        <= (others => '0');
			-- DEB General Configuration Area Register "DTC_SPW_CFG" : "TIMECODE" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_spw_cfg.timecode          <= "00";
			-- DEB Housekeeping Area Register "DEB_STATUS" : "OPER_MOD" Field
			rmap_registers_wr_o.deb_hk_deb_status.oper_mod                <= "111";
			-- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_CORR_ERR" Field
			rmap_registers_wr_o.deb_hk_deb_status.edac_list_corr_err      <= (others => '0');
			-- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_UNCORR_ERR" Field
			rmap_registers_wr_o.deb_hk_deb_status.edac_list_uncorr_err    <= (others => '0');
			-- DEB Housekeeping Area Register "DEB_STATUS" : "PLL_REF" Field
			rmap_registers_wr_o.deb_hk_deb_status.pll_ref                 <= '0';
			-- DEB Housekeeping Area Register "DEB_STATUS" : "PLL_VCXO" Field
			rmap_registers_wr_o.deb_hk_deb_status.pll_vcxo                <= '0';
			-- DEB Housekeeping Area Register "DEB_STATUS" : "PLL_LOCK" Field
			rmap_registers_wr_o.deb_hk_deb_status.pll_lock                <= '0';
			-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_4" Field
			rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb_4              <= '0';
			-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_3" Field
			rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb_3              <= '0';
			-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_2" Field
			rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb_2              <= '0';
			-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_1" Field
			rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb_1              <= '0';
			-- DEB Housekeeping Area Register "DEB_STATUS" : "WDG" Field
			rmap_registers_wr_o.deb_hk_deb_status.wdg                     <= '0';
			-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_8" Field
			rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_8          <= '0';
			-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_7" Field
			rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_7          <= '0';
			-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_6" Field
			rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_6          <= '0';
			-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_5" Field
			rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_5          <= '0';
			-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_4" Field
			rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_4          <= '0';
			-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_3" Field
			rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_3          <= '0';
			-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_2" Field
			rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_2          <= '0';
			-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_1" Field
			rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_1          <= '0';
			-- DEB Housekeeping Area Register "DEB_AHK1" : "VDIG_IN" Field
			rmap_registers_wr_o.deb_hk_deb_ahk1.vdig_in                   <= (others => '0');
			-- DEB Housekeeping Area Register "DEB_AHK1" : "VIO" Field
			rmap_registers_wr_o.deb_hk_deb_ahk1.vio                       <= (others => '0');
			-- DEB Housekeeping Area Register "DEB_AHK2" : "VCOR" Field
			rmap_registers_wr_o.deb_hk_deb_ahk2.vcor                      <= (others => '0');
			-- DEB Housekeeping Area Register "DEB_AHK2" : "VLVD" Field
			rmap_registers_wr_o.deb_hk_deb_ahk2.vlvd                      <= (others => '0');
			-- DEB Housekeeping Area Register "DEB_AHK3" : "DEB_TEMP" Field
			rmap_registers_wr_o.deb_hk_deb_ahk3.deb_temp                  <= (others => '0');

		end procedure p_ffee_deb_reg_reset;

		procedure p_ffee_deb_reg_trigger is
		begin

			-- Write Registers Triggers Reset

			-- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_SPW" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_spw <= '0';
			-- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_WDG" Field
			rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_wdg <= '0';

		end procedure p_ffee_deb_reg_trigger;

		procedure p_ffee_deb_mem_wr(wr_addr_i : std_logic_vector) is
		begin

			-- MemArea Write Data
			case (wr_addr_i(31 downto 0)) is
				-- Case for access to all memory area

				when (x"00000003") =>
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX0" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_aeb_onoff.aeb_idx0 <= fee_rmap_i.writedata(0);
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX1" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_aeb_onoff.aeb_idx1 <= fee_rmap_i.writedata(1);
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX2" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_aeb_onoff.aeb_idx2 <= fee_rmap_i.writedata(2);
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX3" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_aeb_onoff.aeb_idx3 <= fee_rmap_i.writedata(3);

				when (x"00000004") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "PFDFC" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.pfdfc <= fee_rmap_i.writedata(4);

				when (x"00000005") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "GTME" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.gtme <= fee_rmap_i.writedata(0);

				when (x"00000006") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDF" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.holdf  <= fee_rmap_i.writedata(1);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDTR" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.holdtr <= fee_rmap_i.writedata(3);

				when (x"00000007") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "C0" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.c0     <= fee_rmap_i.writedata(0);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "C1" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.c1     <= fee_rmap_i.writedata(1);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCKW0" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.lockw0 <= fee_rmap_i.writedata(2);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCKW1" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.lockw1 <= fee_rmap_i.writedata(3);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCK0" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.lock0  <= fee_rmap_i.writedata(4);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCK1" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.lock1  <= fee_rmap_i.writedata(5);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "FOFF" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.foff   <= fee_rmap_i.writedata(6);

				when (x"00000008") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y3MUX" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y3mux(2) <= fee_rmap_i.writedata(0);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y4MUX" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y4mux    <= fee_rmap_i.writedata(3 downto 1);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PD" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.pd       <= fee_rmap_i.writedata(4);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "RESHOL" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.reshol   <= fee_rmap_i.writedata(5);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "RESET" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.reset    <= fee_rmap_i.writedata(6);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.hold     <= fee_rmap_i.writedata(7);

				when (x"00000009") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y1MUX" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y1mux             <= fee_rmap_i.writedata(2 downto 0);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y2MUX" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y2mux             <= fee_rmap_i.writedata(5 downto 3);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y3MUX" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y3mux(1 downto 0) <= fee_rmap_i.writedata(7 downto 6);

				when (x"0000000A") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PFD" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.pfd    <= fee_rmap_i.writedata(1 downto 0);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "FB_MUX" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.fb_mux <= fee_rmap_i.writedata(4 downto 2);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y0MUX" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y0mux  <= fee_rmap_i.writedata(7 downto 5);

				when (x"0000000B") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "C0" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.c0         <= fee_rmap_i.writedata(0);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "C1" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.c1         <= fee_rmap_i.writedata(1);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "CP_DIR" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.cp_dir     <= fee_rmap_i.writedata(2);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PRECP" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.precp      <= fee_rmap_i.writedata(3);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "CP_current" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.cp_current <= fee_rmap_i.writedata(7 downto 4);

				when (x"0000000C") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y4_Mode" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y4_mode(3 downto 1) <= fee_rmap_i.writedata(2 downto 0);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "SREF" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.sref                       <= fee_rmap_i.writedata(3);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "SXOIREF" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.sxoiref                    <= fee_rmap_i.writedata(4);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "ADLOCK" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.adlock                     <= fee_rmap_i.writedata(5);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "90DIV4" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.n90div4                    <= fee_rmap_i.writedata(6);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "90DIV8" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.n90div8                    <= fee_rmap_i.writedata(7);

				when (x"0000000D") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y2_Mode" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y2_mode(3 downto 1) <= fee_rmap_i.writedata(2 downto 0);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y3_Mode" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y3_mode             <= fee_rmap_i.writedata(6 downto 3);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y4_Mode" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y4_mode(0)          <= fee_rmap_i.writedata(7);

				when (x"0000000E") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y0_Mode" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y0_mode(3 downto 1) <= fee_rmap_i.writedata(2 downto 0);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y1_Mode" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y1_mode             <= fee_rmap_i.writedata(6 downto 3);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y2_Mode" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y2_mode(0)          <= fee_rmap_i.writedata(7);

				when (x"0000000F") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "C0" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.c0                <= fee_rmap_i.writedata(0);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "C1" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.c1                <= fee_rmap_i.writedata(1);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL0" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel0           <= fee_rmap_i.writedata(2);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL1" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel1           <= fee_rmap_i.writedata(3);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL2" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel2           <= fee_rmap_i.writedata(4);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL3" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel3           <= fee_rmap_i.writedata(5);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL4" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel4           <= fee_rmap_i.writedata(6);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y0_Mode" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y0_mode(0) <= fee_rmap_i.writedata(7);

				when (x"00000010") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "DLYM" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.dlym   <= fee_rmap_i.writedata(2 downto 0);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "DLYN" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.dlyn   <= fee_rmap_i.writedata(5 downto 3);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "MANAUT" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.manaut <= fee_rmap_i.writedata(6);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "REFDEC" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.refdec <= fee_rmap_i.writedata(7);

				when (x"00000011") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "N" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.n(11 downto 4) <= fee_rmap_i.writedata;

				when (x"00000012") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "M" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.m(9 downto 6) <= fee_rmap_i.writedata(3 downto 0);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "N" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.n(3 downto 0) <= fee_rmap_i.writedata(7 downto 4);

				when (x"00000013") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "C0" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.c0            <= fee_rmap_i.writedata(0);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "C1" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.c1            <= fee_rmap_i.writedata(1);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "M" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.m(5 downto 0) <= fee_rmap_i.writedata(7 downto 2);

				when (x"00000017") =>
					-- DEB Critical Configuration Area Register "DTC_FEE_MOD" : "OPER_MOD" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_fee_mod.oper_mod <= fee_rmap_i.writedata(2 downto 0);

				when (x"0000001B") =>
					-- DEB Critical Configuration Area Register "DTC_IMM_ONMOD" : "IMM_ON" Field
					rmap_registers_wr_o.deb_crit_cfg_dtc_imm_onmod.imm_on <= fee_rmap_i.writedata(0);

				when (x"00000104") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T7_IN_MOD" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t7_in_mod <= fee_rmap_i.writedata(2 downto 0);

				when (x"00000105") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T6_IN_MOD" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t6_in_mod <= fee_rmap_i.writedata(2 downto 0);

				when (x"00000106") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T5_IN_MOD" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t5_in_mod <= fee_rmap_i.writedata(2 downto 0);

				when (x"00000107") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T4_IN_MOD" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t4_in_mod <= fee_rmap_i.writedata(2 downto 0);

				when (x"00000108") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T3_IN_MOD" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t3_in_mod <= fee_rmap_i.writedata(2 downto 0);

				when (x"00000109") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T2_IN_MOD" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t2_in_mod <= fee_rmap_i.writedata(2 downto 0);

				when (x"0000010A") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T1_IN_MOD" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t1_in_mod <= fee_rmap_i.writedata(2 downto 0);

				when (x"0000010B") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T0_IN_MOD" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t0_in_mod <= fee_rmap_i.writedata(2 downto 0);

				when (x"0000010E") =>
					-- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_X" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_siz.w_siz_x <= fee_rmap_i.writedata(5 downto 0);

				when (x"0000010F") =>
					-- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_Y" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_siz.w_siz_y <= fee_rmap_i.writedata(5 downto 0);

				when (x"00000110") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_4(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"00000111") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_4(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000112") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_4(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"00000113") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_4(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000114") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_3(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"00000115") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000116") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_3(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"00000117") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_3(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000118") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_2(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"00000119") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000011A") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_2(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"0000011B") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_2(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000011C") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_1(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"0000011D") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000011E") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_1(9 downto 8) <= fee_rmap_i.writedata(1 downto 0);

				when (x"0000011F") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_1(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000123") =>
					-- DEB General Configuration Area Register "DTC_OVS_PAT" : "OVS_LIN_PAT" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_ovs_pat.ovs_lin_pat <= fee_rmap_i.writedata(3 downto 0);

				when (x"00000124") =>
					-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_LIN_PAT" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_siz_pat.nb_lin_pat(13 downto 8) <= fee_rmap_i.writedata(5 downto 0);

				when (x"00000125") =>
					-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_LIN_PAT" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_siz_pat.nb_lin_pat(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000126") =>
					-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_PIX_PAT" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_siz_pat.nb_pix_pat(12 downto 8) <= fee_rmap_i.writedata(4 downto 0);

				when (x"00000127") =>
					-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_PIX_PAT" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_siz_pat.nb_pix_pat(7 downto 0) <= fee_rmap_i.writedata;

				when (x"0000012B") =>
					-- DEB General Configuration Area Register "DTC_TRG_25S" : "2_5S_N_CYC" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_trg_25s.n2_5s_n_cyc <= fee_rmap_i.writedata;

				when (x"0000012F") =>
					-- DEB General Configuration Area Register "DTC_SEL_TRG" : "TRG_SRC" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_sel_trg.trg_src <= fee_rmap_i.writedata(0);

				when (x"00000132") =>
					-- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_frm_cnt.pset_frm_cnt(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000133") =>
					-- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_frm_cnt.pset_frm_cnt(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000137") =>
					-- DEB General Configuration Area Register "DTC_SEL_SYN" : "SYN_FRQ" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_sel_syn.syn_frq <= fee_rmap_i.writedata(0);

				when (x"00000139") =>
					-- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_SPW" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_spw <= fee_rmap_i.writedata(0);

				when (x"0000013A") =>
					-- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_WDG" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_wdg <= fee_rmap_i.writedata(0);

				when (x"0000013D") =>
					-- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_25s_dly.n25s_dly(23 downto 16) <= fee_rmap_i.writedata;

				when (x"0000013E") =>
					-- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_25s_dly.n25s_dly(15 downto 8) <= fee_rmap_i.writedata;

				when (x"0000013F") =>
					-- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_25s_dly.n25s_dly(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000140") =>
					-- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_tmod_conf.reserved(31 downto 24) <= fee_rmap_i.writedata;

				when (x"00000141") =>
					-- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_tmod_conf.reserved(23 downto 16) <= fee_rmap_i.writedata;

				when (x"00000142") =>
					-- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_tmod_conf.reserved(15 downto 8) <= fee_rmap_i.writedata;

				when (x"00000143") =>
					-- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_tmod_conf.reserved(7 downto 0) <= fee_rmap_i.writedata;

				when (x"00000147") =>
					-- DEB General Configuration Area Register "DTC_SPW_CFG" : "TIMECODE" Field
					rmap_registers_wr_o.deb_gen_cfg_dtc_spw_cfg.timecode <= fee_rmap_i.writedata(1 downto 0);

				when others =>
					null;

			end case;

		end procedure p_ffee_deb_mem_wr;

		-- p_avalon_mm_rmap_write

		procedure p_avs_writedata(write_address_i : t_fdrm_avalon_mm_rmap_ffee_deb_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_aeb_onoff.aeb_idx3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#01#) =>
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_aeb_onoff.aeb_idx2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#02#) =>
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_aeb_onoff.aeb_idx1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#03#) =>
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_aeb_onoff.aeb_idx0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#04#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "PFDFC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.pfdfc <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#05#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "GTME" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.gtme <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#06#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDTR" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.holdtr <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#07#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.holdf <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#08#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "FOFF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.foff <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#09#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCK1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.lock1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0A#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCK0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.lock0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0B#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCKW1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.lockw1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0C#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCKW0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.lockw0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0D#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "C1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.c1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0E#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "C0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_0.c0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#0F#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.hold <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#10#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "RESET" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.reset <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#11#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "RESHOL" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.reshol <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#12#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.pd <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#13#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y4MUX" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y4mux <= avalon_mm_rmap_i.writedata(2 downto 0);
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y3MUX" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y3mux <= avalon_mm_rmap_i.writedata(10 downto 8);
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y2MUX" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y2mux <= avalon_mm_rmap_i.writedata(18 downto 16);
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y1MUX" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y1mux <= avalon_mm_rmap_i.writedata(26 downto 24);
					end if;

				when (16#14#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y0MUX" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.y0mux <= avalon_mm_rmap_i.writedata(2 downto 0);
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "FB_MUX" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.fb_mux <= avalon_mm_rmap_i.writedata(10 downto 8);
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PFD" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.pfd <= avalon_mm_rmap_i.writedata(17 downto 16);
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "CP_current" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.cp_current <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#15#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PRECP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.precp <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#16#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "CP_DIR" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.cp_dir <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#17#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "C1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.c1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#18#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "C0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_1.c0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#19#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "90DIV8" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.n90div8 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1A#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "90DIV4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.n90div4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1B#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "ADLOCK" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.adlock <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1C#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "SXOIREF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.sxoiref <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1D#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "SREF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.sref <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#1E#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y4_Mode" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y4_mode <= avalon_mm_rmap_i.writedata(3 downto 0);
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y3_Mode" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y3_mode <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y2_Mode" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y2_mode <= avalon_mm_rmap_i.writedata(19 downto 16);
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y1_Mode" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y1_mode <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#1F#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y0_Mode" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.output_y0_mode <= avalon_mm_rmap_i.writedata(3 downto 0);
					end if;

				when (16#20#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#21#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#22#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#23#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#24#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.outsel0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#25#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "C1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.c1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#26#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "C0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_2.c0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#27#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "REFDEC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.refdec <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#28#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "MANAUT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.manaut <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#29#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "DLYN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.dlyn <= avalon_mm_rmap_i.writedata(2 downto 0);
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "DLYM" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.dlym <= avalon_mm_rmap_i.writedata(10 downto 8);
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "N" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.n(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.n(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#2A#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "M" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.m(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.m(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;

				when (16#2B#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "C1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.c1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2C#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "C0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_pll_reg_3.c0 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2D#) =>
					-- DEB Critical Configuration Area Register "DTC_FEE_MOD" : "OPER_MOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_fee_mod.oper_mod <= avalon_mm_rmap_i.writedata(2 downto 0);
					end if;

				when (16#2E#) =>
					-- DEB Critical Configuration Area Register "DTC_IMM_ONMOD" : "IMM_ON" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_crit_cfg_dtc_imm_onmod.imm_on <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#2F#) =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T7_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t7_in_mod <= avalon_mm_rmap_i.writedata(2 downto 0);
					end if;
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T6_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t6_in_mod <= avalon_mm_rmap_i.writedata(10 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T5_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t5_in_mod <= avalon_mm_rmap_i.writedata(18 downto 16);
					end if;
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T4_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t4_in_mod <= avalon_mm_rmap_i.writedata(26 downto 24);
					end if;

				when (16#30#) =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T3_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t3_in_mod <= avalon_mm_rmap_i.writedata(2 downto 0);
					end if;
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T2_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t2_in_mod <= avalon_mm_rmap_i.writedata(10 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T1_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t1_in_mod <= avalon_mm_rmap_i.writedata(18 downto 16);
					end if;
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T0_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_in_mod.t0_in_mod <= avalon_mm_rmap_i.writedata(26 downto 24);
					end if;

				when (16#31#) =>
					-- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_X" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_siz.w_siz_x <= avalon_mm_rmap_i.writedata(5 downto 0);
					end if;
					-- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_Y" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_siz.w_siz_y <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_4(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_4(9 downto 8) <= avalon_mm_rmap_i.writedata(25 downto 24);
					end if;

				when (16#32#) =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_4(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_4(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_3(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_3(9 downto 8) <= avalon_mm_rmap_i.writedata(25 downto 24);
					end if;

				when (16#33#) =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_3(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_3(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_2(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_2(9 downto 8) <= avalon_mm_rmap_i.writedata(25 downto 24);
					end if;

				when (16#34#) =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_2(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_2(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_1(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_idx_1(9 downto 8) <= avalon_mm_rmap_i.writedata(25 downto 24);
					end if;

				when (16#35#) =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_1(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_wdw_idx.wdw_len_1(9 downto 8) <= avalon_mm_rmap_i.writedata(9 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_OVS_PAT" : "OVS_LIN_PAT" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_ovs_pat.ovs_lin_pat <= avalon_mm_rmap_i.writedata(19 downto 16);
					end if;

				when (16#36#) =>
					-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_LIN_PAT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_siz_pat.nb_lin_pat(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_siz_pat.nb_lin_pat(13 downto 8) <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_PIX_PAT" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_siz_pat.nb_pix_pat(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_siz_pat.nb_pix_pat(12 downto 8) <= avalon_mm_rmap_i.writedata(28 downto 24);
					end if;

				when (16#37#) =>
					-- DEB General Configuration Area Register "DTC_TRG_25S" : "2_5S_N_CYC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_trg_25s.n2_5s_n_cyc <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;

				when (16#38#) =>
					-- DEB General Configuration Area Register "DTC_SEL_TRG" : "TRG_SRC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_sel_trg.trg_src <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#39#) =>
					-- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_frm_cnt.pset_frm_cnt(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_frm_cnt.pset_frm_cnt(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;

				when (16#3A#) =>
					-- DEB General Configuration Area Register "DTC_SEL_SYN" : "SYN_FRQ" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_sel_syn.syn_frq <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3B#) =>
					-- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_SPW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_spw <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3C#) =>
					-- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_WDG" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_rst_cps.rst_wdg <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#3D#) =>
					-- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_25s_dly.n25s_dly(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_25s_dly.n25s_dly(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_25s_dly.n25s_dly(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;

				when (16#3E#) =>
					-- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_tmod_conf.reserved(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_tmod_conf.reserved(15 downto 8) <= avalon_mm_rmap_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_tmod_conf.reserved(23 downto 16) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_tmod_conf.reserved(31 downto 24) <= avalon_mm_rmap_i.writedata(31 downto 24);
					end if;

				when (16#3F#) =>
					-- DEB General Configuration Area Register "DTC_SPW_CFG" : "TIMECODE" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_gen_cfg_dtc_spw_cfg.timecode <= avalon_mm_rmap_i.writedata(1 downto 0);
					end if;

				when (16#40#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "OPER_MOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.oper_mod <= avalon_mm_rmap_i.writedata(2 downto 0);
					end if;
					-- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_CORR_ERR" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.edac_list_corr_err <= avalon_mm_rmap_i.writedata(13 downto 8);
					end if;
					-- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_UNCORR_ERR" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.edac_list_uncorr_err <= avalon_mm_rmap_i.writedata(17 downto 16);
					end if;

				when (16#41#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "PLL_REF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.pll_ref <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#42#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "PLL_VCXO" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.pll_vcxo <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#43#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "PLL_LOCK" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.pll_lock <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#44#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb_4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#45#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb_3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#46#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb_2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#47#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.vdig_aeb_1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#48#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "WDW_LIST_CNT_OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.wdw_list_cnt_ovf <= avalon_mm_rmap_i.writedata(1 downto 0);
					end if;

				when (16#49#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "WDG" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_status.wdg <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#4A#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_8" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_8 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#4B#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_7 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#4C#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_6 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#4D#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_5 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#4E#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_4 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#4F#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_3 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#50#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_2 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#51#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ovf_wr.row_act_list_1 <= avalon_mm_rmap_i.writedata(0);
					end if;

				when (16#76#) =>
					-- DEB Housekeeping Area Register "DEB_AHK1" : "VDIG_IN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk1.vdig_in(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk1.vdig_in(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					-- DEB Housekeeping Area Register "DEB_AHK1" : "VIO" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk1.vio(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk1.vio(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#77#) =>
					-- DEB Housekeeping Area Register "DEB_AHK2" : "VCOR" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk2.vcor(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk2.vcor(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;
					-- DEB Housekeeping Area Register "DEB_AHK2" : "VLVD" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk2.vlvd(7 downto 0) <= avalon_mm_rmap_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk2.vlvd(11 downto 8) <= avalon_mm_rmap_i.writedata(27 downto 24);
					end if;

				when (16#78#) =>
					-- DEB Housekeeping Area Register "DEB_AHK3" : "DEB_TEMP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk3.deb_temp(7 downto 0) <= avalon_mm_rmap_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						rmap_registers_wr_o.deb_hk_deb_ahk3.deb_temp(11 downto 8) <= avalon_mm_rmap_i.writedata(11 downto 8);
					end if;

				when (16#79#) =>
					p_ffee_deb_reg_reset;

				when others =>
					-- No register associated to the address, do nothing
					null;

			end case;

		end procedure p_avs_writedata;

		variable v_fee_write_address : std_logic_vector(31 downto 0)          := (others => '0');
		variable v_avs_write_address : t_fdrm_avalon_mm_rmap_ffee_deb_address := 0;
	begin
		if (rst_i = '1') then
			fee_rmap_o.waitrequest       <= '1';
			avalon_mm_rmap_o.waitrequest <= '1';
			s_data_acquired              <= '0';
			p_ffee_deb_reg_reset;
			v_fee_write_address          := (others => '0');
			v_avs_write_address          := 0;
		elsif (rising_edge(clk_i)) then

			fee_rmap_o.waitrequest       <= '1';
			avalon_mm_rmap_o.waitrequest <= '1';
			p_ffee_deb_reg_trigger;
			s_data_acquired              <= '0';
			if (fee_rmap_i.write = '1') then
				v_fee_write_address    := fee_rmap_i.address;
				fee_rmap_o.waitrequest <= '0';
				s_data_acquired        <= '1';
				if (s_data_acquired = '0') then
					p_ffee_deb_mem_wr(v_fee_write_address);
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
	end process p_fdrm_rmap_mem_area_ffee_deb_write;

end architecture RTL;
