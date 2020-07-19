library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fdrm_rmap_mem_area_ffee_deb_pkg.all;
use work.fdrm_avalon_mm_rmap_ffee_deb_pkg.all;

entity fdrm_rmap_mem_area_ffee_deb_read_ent is
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		fee_rmap_i          : in  t_fdrm_ffee_deb_rmap_read_in;
		avalon_mm_rmap_i    : in  t_fdrm_avalon_mm_rmap_ffee_deb_read_in;
		rmap_registers_wr_i : in  t_rmap_memory_wr_area;
		rmap_registers_rd_i : in  t_rmap_memory_rd_area;
		fee_rmap_o          : out t_fdrm_ffee_deb_rmap_read_out;
		avalon_mm_rmap_o    : out t_fdrm_avalon_mm_rmap_ffee_deb_read_out
	);
end entity fdrm_rmap_mem_area_ffee_deb_read_ent;

architecture RTL of fdrm_rmap_mem_area_ffee_deb_read_ent is

begin

	p_fdrm_rmap_mem_area_ffee_deb_read : process(clk_i, rst_i) is
		procedure p_ffee_deb_rmap_mem_rd(rd_addr_i : std_logic_vector) is
		begin

			-- MemArea Data Read
			case (rd_addr_i(31 downto 0)) is
				-- Case for access to all memory area

				when (x"00000003") =>
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_aeb_onoff.aeb_idx0;
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.deb_crit_cfg_dtc_aeb_onoff.aeb_idx1;
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.deb_crit_cfg_dtc_aeb_onoff.aeb_idx2;
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX3" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.deb_crit_cfg_dtc_aeb_onoff.aeb_idx3;

				when (x"00000004") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "PFDFC" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.pfdfc;

				when (x"00000005") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "GTME" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.gtme;

				when (x"00000006") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDF" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.holdf;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDTR" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.holdtr;

				when (x"00000007") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "C0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.c0;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "C1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.c1;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCKW0" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.lockw0;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCKW1" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.lockw1;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCK0" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.lock0;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCK1" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.lock1;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "FOFF" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.foff;

				when (x"00000008") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y3MUX" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.y3mux(2);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y4MUX" Field
					fee_rmap_o.readdata(3 downto 1) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.y4mux;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PD" Field
					fee_rmap_o.readdata(4)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.pd;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "RESHOL" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.reshol;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "RESET" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.reset;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.hold;

				when (x"00000009") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y1MUX" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.y1mux;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y2MUX" Field
					fee_rmap_o.readdata(5 downto 3) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.y2mux;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y3MUX" Field
					fee_rmap_o.readdata(7 downto 6) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.y3mux(1 downto 0);

				when (x"0000000A") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PFD" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.pfd;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "FB_MUX" Field
					fee_rmap_o.readdata(4 downto 2) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.fb_mux;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y0MUX" Field
					fee_rmap_o.readdata(7 downto 5) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.y0mux;

				when (x"0000000B") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "C0" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.c0;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "C1" Field
					fee_rmap_o.readdata(1)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.c1;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "CP_DIR" Field
					fee_rmap_o.readdata(2)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.cp_dir;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PRECP" Field
					fee_rmap_o.readdata(3)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.precp;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "CP_current" Field
					fee_rmap_o.readdata(7 downto 4) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.cp_current;

				when (x"0000000C") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y4_Mode" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y4_mode(3 downto 1);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "SREF" Field
					fee_rmap_o.readdata(3)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.sref;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "SXOIREF" Field
					fee_rmap_o.readdata(4)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.sxoiref;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "ADLOCK" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.adlock;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "90DIV4" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.n90div4;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "90DIV8" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.n90div8;

				when (x"0000000D") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y2_Mode" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y2_mode(3 downto 1);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y3_Mode" Field
					fee_rmap_o.readdata(6 downto 3) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y3_mode;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y4_Mode" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y4_mode(0);

				when (x"0000000E") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y0_Mode" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y0_mode(3 downto 1);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y1_Mode" Field
					fee_rmap_o.readdata(6 downto 3) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y1_mode;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y2_Mode" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y2_mode(0);

				when (x"0000000F") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "C0" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.c0;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "C1" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.c1;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL0" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.outsel0;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL1" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.outsel1;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL2" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.outsel2;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL3" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.outsel3;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL4" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.outsel4;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y0_Mode" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y0_mode(0);

				when (x"00000010") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "DLYM" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.dlym;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "DLYN" Field
					fee_rmap_o.readdata(5 downto 3) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.dlyn;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "MANAUT" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.manaut;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "REFDEC" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.refdec;

				when (x"00000011") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "N" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.n(11 downto 4);

				when (x"00000012") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "M" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.m(9 downto 6);
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "N" Field
					fee_rmap_o.readdata(7 downto 4) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.n(3 downto 0);

				when (x"00000013") =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "C0" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.c0;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "C1" Field
					fee_rmap_o.readdata(1)          <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.c1;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "M" Field
					fee_rmap_o.readdata(7 downto 2) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.m(5 downto 0);

				when (x"00000017") =>
					-- DEB Critical Configuration Area Register "DTC_FEE_MOD" : "OPER_MOD" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_fee_mod.oper_mod;

				when (x"0000001B") =>
					-- DEB Critical Configuration Area Register "DTC_IMM_ONMOD" : "IMM_ON" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_imm_onmod.imm_on;

				when (x"00000104") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T7_IN_MOD" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t7_in_mod;

				when (x"00000105") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T6_IN_MOD" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t6_in_mod;

				when (x"00000106") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T5_IN_MOD" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t5_in_mod;

				when (x"00000107") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T4_IN_MOD" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t4_in_mod;

				when (x"00000108") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T3_IN_MOD" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t3_in_mod;

				when (x"00000109") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T2_IN_MOD" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t2_in_mod;

				when (x"0000010A") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T1_IN_MOD" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t1_in_mod;

				when (x"0000010B") =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T0_IN_MOD" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t0_in_mod;

				when (x"0000010E") =>
					-- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_X" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_siz.w_siz_x;

				when (x"0000010F") =>
					-- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_Y" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_siz.w_siz_y;

				when (x"00000110") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_4(9 downto 8);

				when (x"00000111") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_4(7 downto 0);

				when (x"00000112") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_4(9 downto 8);

				when (x"00000113") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_4(7 downto 0);

				when (x"00000114") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_3(9 downto 8);

				when (x"00000115") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_3(7 downto 0);

				when (x"00000116") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_3(9 downto 8);

				when (x"00000117") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_3(7 downto 0);

				when (x"00000118") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_2(9 downto 8);

				when (x"00000119") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_2(7 downto 0);

				when (x"0000011A") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_2(9 downto 8);

				when (x"0000011B") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_2(7 downto 0);

				when (x"0000011C") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_1(9 downto 8);

				when (x"0000011D") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_1(7 downto 0);

				when (x"0000011E") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_1(9 downto 8);

				when (x"0000011F") =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_1(7 downto 0);

				when (x"00000123") =>
					-- DEB General Configuration Area Register "DTC_OVS_PAT" : "OVS_LIN_PAT" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_ovs_pat.ovs_lin_pat;

				when (x"00000124") =>
					-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_LIN_PAT" Field
					fee_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_siz_pat.nb_lin_pat(13 downto 8);

				when (x"00000125") =>
					-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_LIN_PAT" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_siz_pat.nb_lin_pat(7 downto 0);

				when (x"00000126") =>
					-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_PIX_PAT" Field
					fee_rmap_o.readdata(4 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_siz_pat.nb_pix_pat(12 downto 8);

				when (x"00000127") =>
					-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_PIX_PAT" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_siz_pat.nb_pix_pat(7 downto 0);

				when (x"0000012B") =>
					-- DEB General Configuration Area Register "DTC_TRG_25S" : "2_5S_N_CYC" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_trg_25s.n2_5s_n_cyc;

				when (x"0000012F") =>
					-- DEB General Configuration Area Register "DTC_SEL_TRG" : "TRG_SRC" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_sel_trg.trg_src;

				when (x"00000132") =>
					-- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_frm_cnt.pset_frm_cnt(15 downto 8);

				when (x"00000133") =>
					-- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_frm_cnt.pset_frm_cnt(7 downto 0);

				when (x"00000137") =>
					-- DEB General Configuration Area Register "DTC_SEL_SYN" : "SYN_FRQ" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_sel_syn.syn_frq;

				when (x"00000139") =>
					-- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_SPW" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_rst_cps.rst_spw;

				when (x"0000013A") =>
					-- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_WDG" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_rst_cps.rst_wdg;

				when (x"0000013D") =>
					-- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_25s_dly.n25s_dly(23 downto 16);

				when (x"0000013E") =>
					-- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_25s_dly.n25s_dly(15 downto 8);

				when (x"0000013F") =>
					-- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_25s_dly.n25s_dly(7 downto 0);

				when (x"00000140") =>
					-- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_tmod_conf.reserved(31 downto 24);

				when (x"00000141") =>
					-- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_tmod_conf.reserved(23 downto 16);

				when (x"00000142") =>
					-- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_tmod_conf.reserved(15 downto 8);

				when (x"00000143") =>
					-- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_gen_cfg_dtc_tmod_conf.reserved(7 downto 0);

				when (x"00000147") =>
					-- DEB General Configuration Area Register "DTC_SPW_CFG" : "TIMECODE" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_spw_cfg.timecode;

				when (x"00001000") =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "OPER_MOD" Field
					fee_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_hk_deb_status.oper_mod;

				when (x"00001001") =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_UNCORR_ERR" Field
					fee_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_hk_deb_status.edac_list_uncorr_err;
					-- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_CORR_ERR" Field
					fee_rmap_o.readdata(7 downto 2) <= rmap_registers_wr_i.deb_hk_deb_status.edac_list_corr_err;

				when (x"00001002") =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "PLL_LOCK" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_status.pll_lock;
					-- DEB Housekeeping Area Register "DEB_STATUS" : "PLL_VCXO" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.deb_hk_deb_status.pll_vcxo;
					-- DEB Housekeeping Area Register "DEB_STATUS" : "PLL_REF" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.deb_hk_deb_status.pll_ref;

				when (x"00001003") =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "WDG" Field
					fee_rmap_o.readdata(0)          <= rmap_registers_wr_i.deb_hk_deb_status.wdg;
					-- DEB Housekeeping Area Register "DEB_STATUS" : "WDW_LIST_CNT_OVF" Field
					fee_rmap_o.readdata(3 downto 2) <= rmap_registers_wr_i.deb_hk_deb_status.wdw_list_cnt_ovf;
					-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_1" Field
					fee_rmap_o.readdata(4)          <= rmap_registers_wr_i.deb_hk_deb_status.vdig_aeb_1;
					-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_2" Field
					fee_rmap_o.readdata(5)          <= rmap_registers_wr_i.deb_hk_deb_status.vdig_aeb_2;
					-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_3" Field
					fee_rmap_o.readdata(6)          <= rmap_registers_wr_i.deb_hk_deb_status.vdig_aeb_3;
					-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_4" Field
					fee_rmap_o.readdata(7)          <= rmap_registers_wr_i.deb_hk_deb_status.vdig_aeb_4;

				when (x"00001004") =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_1" Field
					fee_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_1;
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_2" Field
					fee_rmap_o.readdata(1) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_2;
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_3" Field
					fee_rmap_o.readdata(2) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_3;
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_4" Field
					fee_rmap_o.readdata(3) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_4;
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_5" Field
					fee_rmap_o.readdata(4) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_5;
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_6" Field
					fee_rmap_o.readdata(5) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_6;
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_7" Field
					fee_rmap_o.readdata(6) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_7;
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_8" Field
					fee_rmap_o.readdata(7) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_8;

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

				when (x"00001006") =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_1" Field
					fee_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_1;
					-- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_2" Field
					fee_rmap_o.readdata(2) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_2;
					-- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_3" Field
					fee_rmap_o.readdata(4) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_3;
					-- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_4" Field
					fee_rmap_o.readdata(6) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_4;

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

				when (x"0000100C") =>
					-- DEB Housekeeping Area Register "DEB_AHK1" : "VDIG_IN" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.deb_hk_deb_ahk1.vdig_in(11 downto 8);

				when (x"0000100D") =>
					-- DEB Housekeeping Area Register "DEB_AHK1" : "VDIG_IN" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_hk_deb_ahk1.vdig_in(7 downto 0);

				when (x"0000100E") =>
					-- DEB Housekeeping Area Register "DEB_AHK1" : "VIO" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.deb_hk_deb_ahk1.vio(11 downto 8);

				when (x"0000100F") =>
					-- DEB Housekeeping Area Register "DEB_AHK1" : "VIO" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_hk_deb_ahk1.vio(7 downto 0);

				when (x"00001010") =>
					-- DEB Housekeeping Area Register "DEB_AHK2" : "VCOR" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.deb_hk_deb_ahk2.vcor(11 downto 8);

				when (x"00001011") =>
					-- DEB Housekeeping Area Register "DEB_AHK2" : "VCOR" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_hk_deb_ahk2.vcor(7 downto 0);

				when (x"00001012") =>
					-- DEB Housekeeping Area Register "DEB_AHK2" : "VLVD" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.deb_hk_deb_ahk2.vlvd(11 downto 8);

				when (x"00001013") =>
					-- DEB Housekeeping Area Register "DEB_AHK2" : "VLVD" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_hk_deb_ahk2.vlvd(7 downto 0);

				when (x"00001016") =>
					-- DEB Housekeeping Area Register "DEB_AHK3" : "DEB_TEMP" Field
					fee_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.deb_hk_deb_ahk3.deb_temp(11 downto 8);

				when (x"00001017") =>
					-- DEB Housekeeping Area Register "DEB_AHK3" : "DEB_TEMP" Field
					fee_rmap_o.readdata <= rmap_registers_wr_i.deb_hk_deb_ahk3.deb_temp(7 downto 0);

				when others =>
					fee_rmap_o.readdata <= (others => '0');

			end case;

		end procedure p_ffee_deb_rmap_mem_rd;

		-- p_avalon_mm_rmap_read

		procedure p_avs_readdata(read_address_i : t_fdrm_avalon_mm_rmap_ffee_deb_address) is
		begin

			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_aeb_onoff.aeb_idx3;
					end if;

				when (16#01#) =>
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_aeb_onoff.aeb_idx2;
					end if;

				when (16#02#) =>
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_aeb_onoff.aeb_idx1;
					end if;

				when (16#03#) =>
					-- DEB Critical Configuration Area Register "DTC_AEB_ONOFF" : "AEB_IDX0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_aeb_onoff.aeb_idx0;
					end if;

				when (16#04#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "PFDFC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.pfdfc;
					end if;

				when (16#05#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "GTME" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.gtme;
					end if;

				when (16#06#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDTR" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.holdtr;
					end if;

				when (16#07#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "HOLDF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.holdf;
					end if;

				when (16#08#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "FOFF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.foff;
					end if;

				when (16#09#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCK1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.lock1;
					end if;

				when (16#0A#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCK0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.lock0;
					end if;

				when (16#0B#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCKW1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.lockw1;
					end if;

				when (16#0C#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "LOCKW0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.lockw0;
					end if;

				when (16#0D#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "C1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.c1;
					end if;

				when (16#0E#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_0" : "C0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_0.c0;
					end if;

				when (16#0F#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "HOLD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.hold;
					end if;

				when (16#10#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "RESET" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.reset;
					end if;

				when (16#11#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "RESHOL" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.reshol;
					end if;

				when (16#12#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.pd;
					end if;

				when (16#13#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y4MUX" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.y4mux;
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y3MUX" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(10 downto 8) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.y3mux;
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y2MUX" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(18 downto 16) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.y2mux;
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y1MUX" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(26 downto 24) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.y1mux;
					end if;

				when (16#14#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "Y0MUX" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.y0mux;
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "FB_MUX" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(10 downto 8) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.fb_mux;
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PFD" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(17 downto 16) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.pfd;
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "CP_current" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.cp_current;
					end if;

				when (16#15#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "PRECP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.precp;
					end if;

				when (16#16#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "CP_DIR" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.cp_dir;
					end if;

				when (16#17#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "C1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.c1;
					end if;

				when (16#18#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_1" : "C0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_1.c0;
					end if;

				when (16#19#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "90DIV8" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.n90div8;
					end if;

				when (16#1A#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "90DIV4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.n90div4;
					end if;

				when (16#1B#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "ADLOCK" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.adlock;
					end if;

				when (16#1C#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "SXOIREF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.sxoiref;
					end if;

				when (16#1D#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "SREF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.sref;
					end if;

				when (16#1E#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y4_Mode" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y4_mode;
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y3_Mode" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(11 downto 8) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y3_mode;
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y2_Mode" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(19 downto 16) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y2_mode;
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y1_Mode" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y1_mode;
					end if;

				when (16#1F#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "Output_Y0_Mode" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(3 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.output_y0_mode;
					end if;

				when (16#20#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.outsel4;
					end if;

				when (16#21#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.outsel3;
					end if;

				when (16#22#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.outsel2;
					end if;

				when (16#23#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.outsel1;
					end if;

				when (16#24#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "OUTSEL0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.outsel0;
					end if;

				when (16#25#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "C1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.c1;
					end if;

				when (16#26#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_2" : "C0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_2.c0;
					end if;

				when (16#27#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "REFDEC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.refdec;
					end if;

				when (16#28#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "MANAUT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.manaut;
					end if;

				when (16#29#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "DLYN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.dlyn;
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "DLYM" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(10 downto 8) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.dlym;
					end if;
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "N" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.n(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.n(11 downto 8);
					end if;

				when (16#2A#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "M" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.m(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.m(9 downto 8);
					end if;

				when (16#2B#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "C1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.c1;
					end if;

				when (16#2C#) =>
					-- DEB Critical Configuration Area Register "DTC_PLL_REG_3" : "C0" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_pll_reg_3.c0;
					end if;

				when (16#2D#) =>
					-- DEB Critical Configuration Area Register "DTC_FEE_MOD" : "OPER_MOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_fee_mod.oper_mod;
					end if;

				when (16#2E#) =>
					-- DEB Critical Configuration Area Register "DTC_IMM_ONMOD" : "IMM_ON" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_crit_cfg_dtc_imm_onmod.imm_on;
					end if;

				when (16#2F#) =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T7_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t7_in_mod;
					end if;
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T6_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(10 downto 8) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t6_in_mod;
					end if;
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T5_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(18 downto 16) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t5_in_mod;
					end if;
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T4_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(26 downto 24) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t4_in_mod;
					end if;

				when (16#30#) =>
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T3_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t3_in_mod;
					end if;
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T2_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(10 downto 8) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t2_in_mod;
					end if;
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T1_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(18 downto 16) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t1_in_mod;
					end if;
					-- DEB General Configuration Area Register "DTC_IN_MOD" : "T0_IN_MOD" Field
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(26 downto 24) <= rmap_registers_wr_i.deb_gen_cfg_dtc_in_mod.t0_in_mod;
					end if;

				when (16#31#) =>
					-- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_X" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(5 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_siz.w_siz_x;
					end if;
					-- DEB General Configuration Area Register "DTC_WDW_SIZ" : "W_SIZ_Y" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_siz.w_siz_y;
					end if;
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_4" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_4(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(25 downto 24) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_4(9 downto 8);
					end if;

				when (16#32#) =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_4(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_4(9 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_3" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_3(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(25 downto 24) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_3(9 downto 8);
					end if;

				when (16#33#) =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_3(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_3(9 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_2" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_2(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(25 downto 24) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_2(9 downto 8);
					end if;

				when (16#34#) =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_2(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_2(9 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_IDX_1" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_1(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(25 downto 24) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_idx_1(9 downto 8);
					end if;

				when (16#35#) =>
					-- DEB General Configuration Area Register "DTC_WDW_IDX" : "WDW_LEN_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_1(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(9 downto 8) <= rmap_registers_wr_i.deb_gen_cfg_dtc_wdw_idx.wdw_len_1(9 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_OVS_PAT" : "OVS_LIN_PAT" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(19 downto 16) <= rmap_registers_wr_i.deb_gen_cfg_dtc_ovs_pat.ovs_lin_pat;
					end if;

				when (16#36#) =>
					-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_LIN_PAT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_siz_pat.nb_lin_pat(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.deb_gen_cfg_dtc_siz_pat.nb_lin_pat(13 downto 8);
					end if;
					-- DEB General Configuration Area Register "DTC_SIZ_PAT" : "NB_PIX_PAT" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.deb_gen_cfg_dtc_siz_pat.nb_pix_pat(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(28 downto 24) <= rmap_registers_wr_i.deb_gen_cfg_dtc_siz_pat.nb_pix_pat(12 downto 8);
					end if;

				when (16#37#) =>
					-- DEB General Configuration Area Register "DTC_TRG_25S" : "2_5S_N_CYC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_trg_25s.n2_5s_n_cyc;
					end if;

				when (16#38#) =>
					-- DEB General Configuration Area Register "DTC_SEL_TRG" : "TRG_SRC" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_sel_trg.trg_src;
					end if;

				when (16#39#) =>
					-- DEB General Configuration Area Register "DTC_FRM_CNT" : "PSET_FRM_CNT" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_frm_cnt.pset_frm_cnt(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.deb_gen_cfg_dtc_frm_cnt.pset_frm_cnt(15 downto 8);
					end if;

				when (16#3A#) =>
					-- DEB General Configuration Area Register "DTC_SEL_SYN" : "SYN_FRQ" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_sel_syn.syn_frq;
					end if;

				when (16#3B#) =>
					-- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_SPW" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_rst_cps.rst_spw;
					end if;

				when (16#3C#) =>
					-- DEB General Configuration Area Register "DTC_RST_CPS" : "RST_WDG" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_rst_cps.rst_wdg;
					end if;

				when (16#3D#) =>
					-- DEB General Configuration Area Register "DTC_25S_DLY" : "25S_DLY" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_25s_dly.n25s_dly(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.deb_gen_cfg_dtc_25s_dly.n25s_dly(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.deb_gen_cfg_dtc_25s_dly.n25s_dly(23 downto 16);
					end if;

				when (16#3E#) =>
					-- DEB General Configuration Area Register "DTC_TMOD_CONF" : "RESERVED" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_tmod_conf.reserved(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_registers_wr_i.deb_gen_cfg_dtc_tmod_conf.reserved(15 downto 8);
					end if;
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.deb_gen_cfg_dtc_tmod_conf.reserved(23 downto 16);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_registers_wr_i.deb_gen_cfg_dtc_tmod_conf.reserved(31 downto 24);
					end if;

				when (16#3F#) =>
					-- DEB General Configuration Area Register "DTC_SPW_CFG" : "TIMECODE" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_gen_cfg_dtc_spw_cfg.timecode;
					end if;

				when (16#40#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "OPER_MOD" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_wr_i.deb_hk_deb_status.oper_mod;
					end if;
					-- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_CORR_ERR" Field
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(13 downto 8) <= rmap_registers_wr_i.deb_hk_deb_status.edac_list_corr_err;
					end if;
					-- DEB Housekeeping Area Register "DEB_STATUS" : "EDAC_LIST_UNCORR_ERR" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(17 downto 16) <= rmap_registers_wr_i.deb_hk_deb_status.edac_list_uncorr_err;
					end if;

				when (16#41#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "PLL_REF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_status.pll_ref;
					end if;

				when (16#42#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "PLL_VCXO" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_status.pll_vcxo;
					end if;

				when (16#43#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "PLL_LOCK" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_status.pll_lock;
					end if;

				when (16#44#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_status.vdig_aeb_4;
					end if;

				when (16#45#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_status.vdig_aeb_3;
					end if;

				when (16#46#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_status.vdig_aeb_2;
					end if;

				when (16#47#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "VDIG_AEB_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_status.vdig_aeb_1;
					end if;

				when (16#48#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "WDW_LIST_CNT_OVF" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(1 downto 0) <= rmap_registers_wr_i.deb_hk_deb_status.wdw_list_cnt_ovf;
					end if;

				when (16#49#) =>
					-- DEB Housekeeping Area Register "DEB_STATUS" : "WDG" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_status.wdg;
					end if;

				when (16#4A#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_8" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_8;
					end if;

				when (16#4B#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_7;
					end if;

				when (16#4C#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_6;
					end if;

				when (16#4D#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_5;
					end if;

				when (16#4E#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_4;
					end if;

				when (16#4F#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_3;
					end if;

				when (16#50#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_2;
					end if;

				when (16#51#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "ROW_ACT_LIST_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_wr_i.deb_hk_deb_ovf_wr.row_act_list_1;
					end if;

				when (16#52#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_8" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_8;
					end if;

				when (16#53#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_7" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_7;
					end if;

				when (16#54#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_6" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_6;
					end if;

				when (16#55#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_5" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_5;
					end if;

				when (16#56#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_4;
					end if;

				when (16#57#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_3;
					end if;

				when (16#58#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_2;
					end if;

				when (16#59#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "OUTBUFF_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.outbuff_1;
					end if;

				when (16#5A#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_4;
					end if;

				when (16#5B#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_3;
					end if;

				when (16#5C#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_2;
					end if;

				when (16#5D#) =>
					-- DEB Housekeeping Area Register "DEB_OVF" : "RMAP_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_deb_ovf_rd.rmap_1;
					end if;

				when (16#5E#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "STATE_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_rd_i.deb_hk_spw_status.state_4;
					end if;

				when (16#5F#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "CRD_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.crd_4;
					end if;

				when (16#60#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "FIFO_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.fifo_4;
					end if;

				when (16#61#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "ESC_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.esc_4;
					end if;

				when (16#62#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "PAR_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.par_4;
					end if;

				when (16#63#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "DISC_4" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.disc_4;
					end if;

				when (16#64#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "STATE_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_rd_i.deb_hk_spw_status.state_3;
					end if;

				when (16#65#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "CRD_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.crd_3;
					end if;

				when (16#66#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "FIFO_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.fifo_3;
					end if;

				when (16#67#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "ESC_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.esc_3;
					end if;

				when (16#68#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "PAR_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.par_3;
					end if;

				when (16#69#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "DISC_3" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.disc_3;
					end if;

				when (16#6A#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "STATE_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_rd_i.deb_hk_spw_status.state_2;
					end if;

				when (16#6B#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "CRD_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.crd_2;
					end if;

				when (16#6C#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "FIFO_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.fifo_2;
					end if;

				when (16#6D#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "ESC_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.esc_2;
					end if;

				when (16#6E#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "PAR_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.par_2;
					end if;

				when (16#6F#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "DISC_2" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.disc_2;
					end if;

				when (16#70#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "STATE_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(2 downto 0) <= rmap_registers_rd_i.deb_hk_spw_status.state_1;
					end if;

				when (16#71#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "CRD_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.crd_1;
					end if;

				when (16#72#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "FIFO_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.fifo_1;
					end if;

				when (16#73#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "ESC_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.esc_1;
					end if;

				when (16#74#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "PAR_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.par_1;
					end if;

				when (16#75#) =>
					-- DEB Housekeeping Area Register "SPW_STATUS" : "DISC_1" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(0) <= rmap_registers_rd_i.deb_hk_spw_status.disc_1;
					end if;

				when (16#76#) =>
					-- DEB Housekeeping Area Register "DEB_AHK1" : "VDIG_IN" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_hk_deb_ahk1.vdig_in(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(11 downto 8) <= rmap_registers_wr_i.deb_hk_deb_ahk1.vdig_in(11 downto 8);
					end if;
					-- DEB Housekeeping Area Register "DEB_AHK1" : "VIO" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.deb_hk_deb_ahk1.vio(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.deb_hk_deb_ahk1.vio(11 downto 8);
					end if;

				when (16#77#) =>
					-- DEB Housekeeping Area Register "DEB_AHK2" : "VCOR" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_hk_deb_ahk2.vcor(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(11 downto 8) <= rmap_registers_wr_i.deb_hk_deb_ahk2.vcor(11 downto 8);
					end if;
					-- DEB Housekeeping Area Register "DEB_AHK2" : "VLVD" Field
					if (avalon_mm_rmap_i.byteenable(2) = '1') then
						avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_registers_wr_i.deb_hk_deb_ahk2.vlvd(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(3) = '1') then
						avalon_mm_rmap_o.readdata(27 downto 24) <= rmap_registers_wr_i.deb_hk_deb_ahk2.vlvd(11 downto 8);
					end if;

				when (16#78#) =>
					-- DEB Housekeeping Area Register "DEB_AHK3" : "DEB_TEMP" Field
					if (avalon_mm_rmap_i.byteenable(0) = '1') then
						avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_registers_wr_i.deb_hk_deb_ahk3.deb_temp(7 downto 0);
					end if;
					if (avalon_mm_rmap_i.byteenable(1) = '1') then
						avalon_mm_rmap_o.readdata(11 downto 8) <= rmap_registers_wr_i.deb_hk_deb_ahk3.deb_temp(11 downto 8);
					end if;

				when others =>
					-- No register associated to the address, return with 0x00000000
					avalon_mm_rmap_o.readdata <= (others => '0');

			end case;

		end procedure p_avs_readdata;

		variable v_fee_read_address : std_logic_vector(31 downto 0)          := (others => '0');
		variable v_avs_read_address : t_fdrm_avalon_mm_rmap_ffee_deb_address := 0;
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
				p_ffee_deb_rmap_mem_rd(v_fee_read_address);
			elsif (avalon_mm_rmap_i.read = '1') then
				v_avs_read_address           := to_integer(unsigned(avalon_mm_rmap_i.address));
				avalon_mm_rmap_o.waitrequest <= '0';
				p_avs_readdata(v_avs_read_address);
			end if;

		end if;
	end process p_fdrm_rmap_mem_area_ffee_deb_read;

end architecture RTL;
