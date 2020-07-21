library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fdrm_rmap_mem_area_ffee_deb_pkg.all;
use work.fdrm_avalon_mm_rmap_ffee_deb_pkg.all;

entity fdrm_rmap_mem_area_ffee_deb_arbiter_ent is
	port(
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		fee_0_wr_rmap_i       : in  t_fdrm_ffee_deb_rmap_write_in;
		fee_0_rd_rmap_i       : in  t_fdrm_ffee_deb_rmap_read_in;
		fee_1_wr_rmap_i       : in  t_fdrm_ffee_deb_rmap_write_in;
		fee_1_rd_rmap_i       : in  t_fdrm_ffee_deb_rmap_read_in;
		fee_2_wr_rmap_i       : in  t_fdrm_ffee_deb_rmap_write_in;
		fee_2_rd_rmap_i       : in  t_fdrm_ffee_deb_rmap_read_in;
		fee_3_wr_rmap_i       : in  t_fdrm_ffee_deb_rmap_write_in;
		fee_3_rd_rmap_i       : in  t_fdrm_ffee_deb_rmap_read_in;
		fee_4_wr_rmap_i       : in  t_fdrm_ffee_deb_rmap_write_in;
		fee_4_rd_rmap_i       : in  t_fdrm_ffee_deb_rmap_read_in;
		fee_5_wr_rmap_i       : in  t_fdrm_ffee_deb_rmap_write_in;
		fee_5_rd_rmap_i       : in  t_fdrm_ffee_deb_rmap_read_in;
		fee_6_wr_rmap_i       : in  t_fdrm_ffee_deb_rmap_write_in;
		fee_6_rd_rmap_i       : in  t_fdrm_ffee_deb_rmap_read_in;
		fee_7_wr_rmap_i       : in  t_fdrm_ffee_deb_rmap_write_in;
		fee_7_rd_rmap_i       : in  t_fdrm_ffee_deb_rmap_read_in;
		avalon_0_mm_wr_rmap_i : in  t_fdrm_avalon_mm_rmap_ffee_deb_write_in;
		avalon_0_mm_rd_rmap_i : in  t_fdrm_avalon_mm_rmap_ffee_deb_read_in;
		fee_wr_rmap_cfg_hk_i  : in  t_fdrm_ffee_deb_rmap_write_out;
		fee_rd_rmap_cfg_hk_i  : in  t_fdrm_ffee_deb_rmap_read_out;
		fee_wr_rmap_win_i     : in  t_fdrm_ffee_deb_rmap_write_out;
		fee_rd_rmap_win_i     : in  t_fdrm_ffee_deb_rmap_read_out;
		avalon_mm_wr_rmap_i   : in  t_fdrm_avalon_mm_rmap_ffee_deb_write_out;
		avalon_mm_rd_rmap_i   : in  t_fdrm_avalon_mm_rmap_ffee_deb_read_out;
		fee_0_wr_rmap_o       : out t_fdrm_ffee_deb_rmap_write_out;
		fee_0_rd_rmap_o       : out t_fdrm_ffee_deb_rmap_read_out;
		fee_1_wr_rmap_o       : out t_fdrm_ffee_deb_rmap_write_out;
		fee_1_rd_rmap_o       : out t_fdrm_ffee_deb_rmap_read_out;
		fee_2_wr_rmap_o       : out t_fdrm_ffee_deb_rmap_write_out;
		fee_2_rd_rmap_o       : out t_fdrm_ffee_deb_rmap_read_out;
		fee_3_wr_rmap_o       : out t_fdrm_ffee_deb_rmap_write_out;
		fee_3_rd_rmap_o       : out t_fdrm_ffee_deb_rmap_read_out;
		fee_4_wr_rmap_o       : out t_fdrm_ffee_deb_rmap_write_out;
		fee_4_rd_rmap_o       : out t_fdrm_ffee_deb_rmap_read_out;
		fee_5_wr_rmap_o       : out t_fdrm_ffee_deb_rmap_write_out;
		fee_5_rd_rmap_o       : out t_fdrm_ffee_deb_rmap_read_out;
		fee_6_wr_rmap_o       : out t_fdrm_ffee_deb_rmap_write_out;
		fee_6_rd_rmap_o       : out t_fdrm_ffee_deb_rmap_read_out;
		fee_7_wr_rmap_o       : out t_fdrm_ffee_deb_rmap_write_out;
		fee_7_rd_rmap_o       : out t_fdrm_ffee_deb_rmap_read_out;
		avalon_0_mm_wr_rmap_o : out t_fdrm_avalon_mm_rmap_ffee_deb_write_out;
		avalon_0_mm_rd_rmap_o : out t_fdrm_avalon_mm_rmap_ffee_deb_read_out;
		fee_wr_rmap_cfg_hk_o  : out t_fdrm_ffee_deb_rmap_write_in;
		fee_rd_rmap_cfg_hk_o  : out t_fdrm_ffee_deb_rmap_read_in;
		fee_wr_rmap_win_o     : out t_fdrm_ffee_deb_rmap_write_in;
		fee_rd_rmap_win_o     : out t_fdrm_ffee_deb_rmap_read_in;
		avalon_mm_wr_rmap_o   : out t_fdrm_avalon_mm_rmap_ffee_deb_write_in;
		avalon_mm_rd_rmap_o   : out t_fdrm_avalon_mm_rmap_ffee_deb_read_in
	);
end entity fdrm_rmap_mem_area_ffee_deb_arbiter_ent;

architecture RTL of fdrm_rmap_mem_area_ffee_deb_arbiter_ent is

	signal s_fee_rmap_waitrequest       : std_logic;
	signal s_avalon_mm_rmap_waitrequest : std_logic;
	signal s_rmap_waitrequest           : std_logic;

	type t_master_list is (
		master_none,
		master_wr_avs_0,
		master_wr_fee_0,
		master_wr_fee_1,
		master_wr_fee_2,
		master_wr_fee_3,
		master_wr_fee_4,
		master_wr_fee_5,
		master_wr_fee_6,
		master_wr_fee_7,
		master_rd_avs_0,
		master_rd_fee_0,
		master_rd_fee_1,
		master_rd_fee_2,
		master_rd_fee_3,
		master_rd_fee_4,
		master_rd_fee_5,
		master_rd_fee_6,
		master_rd_fee_7
	);
	signal s_selected_master : t_master_list;

	subtype t_master_queue_index is natural range 0 to 18;
	type t_master_queue is array (0 to t_master_queue_index'high) of t_master_list;
	signal s_master_queue : t_master_queue;

	signal s_master_wr_avs_0_queued : std_logic;
	signal s_master_wr_fee_0_queued : std_logic;
	signal s_master_wr_fee_1_queued : std_logic;
	signal s_master_wr_fee_2_queued : std_logic;
	signal s_master_wr_fee_3_queued : std_logic;
	signal s_master_wr_fee_4_queued : std_logic;
	signal s_master_wr_fee_5_queued : std_logic;
	signal s_master_wr_fee_6_queued : std_logic;
	signal s_master_wr_fee_7_queued : std_logic;
	signal s_master_rd_avs_0_queued : std_logic;
	signal s_master_rd_fee_0_queued : std_logic;
	signal s_master_rd_fee_1_queued : std_logic;
	signal s_master_rd_fee_2_queued : std_logic;
	signal s_master_rd_fee_3_queued : std_logic;
	signal s_master_rd_fee_4_queued : std_logic;
	signal s_master_rd_fee_5_queued : std_logic;
	signal s_master_rd_fee_6_queued : std_logic;
	signal s_master_rd_fee_7_queued : std_logic;

	signal s_fee_0_wr_win_address_flag : std_logic;
	signal s_fee_1_wr_win_address_flag : std_logic;
	signal s_fee_2_wr_win_address_flag : std_logic;
	signal s_fee_3_wr_win_address_flag : std_logic;
	signal s_fee_4_wr_win_address_flag : std_logic;
	signal s_fee_5_wr_win_address_flag : std_logic;
	signal s_fee_6_wr_win_address_flag : std_logic;
	signal s_fee_7_wr_win_address_flag : std_logic;
	signal s_fee_0_rd_win_address_flag : std_logic;
	signal s_fee_1_rd_win_address_flag : std_logic;
	signal s_fee_2_rd_win_address_flag : std_logic;
	signal s_fee_3_rd_win_address_flag : std_logic;
	signal s_fee_4_rd_win_address_flag : std_logic;
	signal s_fee_5_rd_win_address_flag : std_logic;
	signal s_fee_6_rd_win_address_flag : std_logic;
	signal s_fee_7_rd_win_address_flag : std_logic;

begin

	p_fdrm_rmap_mem_area_ffee_deb_arbiter : process(clk_i, rst_i) is
		variable v_master_queue_insert_index : t_master_queue_index := 0;
		variable v_master_queue_remove_index : t_master_queue_index := 0;

	begin
		if (rst_i = '1') then
			s_selected_master           <= master_none;
			s_master_queue              <= (others => master_none);
			s_master_wr_avs_0_queued    <= '0';
			s_master_wr_fee_0_queued    <= '0';
			s_master_wr_fee_1_queued    <= '0';
			s_master_wr_fee_2_queued    <= '0';
			s_master_wr_fee_3_queued    <= '0';
			s_master_wr_fee_4_queued    <= '0';
			s_master_wr_fee_5_queued    <= '0';
			s_master_wr_fee_6_queued    <= '0';
			s_master_wr_fee_7_queued    <= '0';
			s_master_rd_avs_0_queued    <= '0';
			s_master_rd_fee_0_queued    <= '0';
			s_master_rd_fee_1_queued    <= '0';
			s_master_rd_fee_2_queued    <= '0';
			s_master_rd_fee_3_queued    <= '0';
			s_master_rd_fee_4_queued    <= '0';
			s_master_rd_fee_5_queued    <= '0';
			s_master_rd_fee_6_queued    <= '0';
			s_master_rd_fee_7_queued    <= '0';
			v_master_queue_insert_index := 0;
			v_master_queue_remove_index := 0;
		elsif (rising_edge(clk_i)) then

			-- check if master avs 0 requested a write and is not queued
			if ((avalon_0_mm_wr_rmap_i.write = '1') and (s_master_wr_avs_0_queued = '0')) then
				-- master avs 0 requested a write and is not queued
				-- put master avs 0 write in the queue
				s_master_queue(v_master_queue_insert_index) <= master_wr_avs_0;
				s_master_wr_avs_0_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 0 requested a write and is not queued
			if ((fee_0_wr_rmap_i.write = '1') and (s_master_wr_fee_0_queued = '0')) then
				-- master fee 0 requested a write and is not queued
				-- put master fee 0 write in the queue
				s_master_queue(v_master_queue_insert_index) <= master_wr_fee_0;
				s_master_wr_fee_0_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 1 requested a write and is not queued
			if ((fee_1_wr_rmap_i.write = '1') and (s_master_wr_fee_1_queued = '0')) then
				-- master fee 1 requested a write and is not queued
				-- put master fee 1 write in the queue
				s_master_queue(v_master_queue_insert_index) <= master_wr_fee_1;
				s_master_wr_fee_1_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 2 requested a write and is not queued
			if ((fee_2_wr_rmap_i.write = '1') and (s_master_wr_fee_2_queued = '0')) then
				-- master fee 2 requested a write and is not queued
				-- put master fee 2 write in the queue
				s_master_queue(v_master_queue_insert_index) <= master_wr_fee_2;
				s_master_wr_fee_2_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 3 requested a write and is not queued
			if ((fee_3_wr_rmap_i.write = '1') and (s_master_wr_fee_3_queued = '0')) then
				-- master fee 3 requested a write and is not queued
				-- put master fee 3 write in the queue
				s_master_queue(v_master_queue_insert_index) <= master_wr_fee_3;
				s_master_wr_fee_3_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 4 requested a write and is not queued
			if ((fee_4_wr_rmap_i.write = '1') and (s_master_wr_fee_4_queued = '0')) then
				-- master fee 4 requested a write and is not queued
				-- put master fee 4 write in the queue
				s_master_queue(v_master_queue_insert_index) <= master_wr_fee_4;
				s_master_wr_fee_4_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 5 requested a write and is not queued
			if ((fee_5_wr_rmap_i.write = '1') and (s_master_wr_fee_5_queued = '0')) then
				-- master fee 5 requested a write and is not queued
				-- put master fee 5 write in the queue
				s_master_queue(v_master_queue_insert_index) <= master_wr_fee_5;
				s_master_wr_fee_5_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 6 requested a write and is not queued
			if ((fee_6_wr_rmap_i.write = '1') and (s_master_wr_fee_6_queued = '0')) then
				-- master fee 6 requested a write and is not queued
				-- put master fee 6 write in the queue
				s_master_queue(v_master_queue_insert_index) <= master_wr_fee_6;
				s_master_wr_fee_6_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 7 requested a write and is not queued
			if ((fee_7_wr_rmap_i.write = '1') and (s_master_wr_fee_7_queued = '0')) then
				-- master fee 7 requested a write and is not queued
				-- put master fee 7 write in the queue
				s_master_queue(v_master_queue_insert_index) <= master_wr_fee_7;
				s_master_wr_fee_7_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master avs 0 requested a read and is not queued
			if ((avalon_0_mm_rd_rmap_i.read = '1') and (s_master_rd_avs_0_queued = '0')) then
				-- master avs 0 requested a read and is not queued
				-- put master avs read 0 in the queue
				s_master_queue(v_master_queue_insert_index) <= master_rd_avs_0;
				s_master_rd_avs_0_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 0 requested a read and is not queued
			if ((fee_0_rd_rmap_i.read = '1') and (s_master_rd_fee_0_queued = '0')) then
				-- master fee 0 requested a read and is not queued
				-- put master fee read 0 in the queue
				s_master_queue(v_master_queue_insert_index) <= master_rd_fee_0;
				s_master_rd_fee_0_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 1 requested a read and is not queued
			if ((fee_1_rd_rmap_i.read = '1') and (s_master_rd_fee_1_queued = '0')) then
				-- master fee 1 requested a read and is not queued
				-- put master fee read 1 in the queue
				s_master_queue(v_master_queue_insert_index) <= master_rd_fee_1;
				s_master_rd_fee_1_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 2 requested a read and is not queued
			if ((fee_2_rd_rmap_i.read = '1') and (s_master_rd_fee_2_queued = '0')) then
				-- master fee 2 requested a read and is not queued
				-- put master fee read 2 in the queue
				s_master_queue(v_master_queue_insert_index) <= master_rd_fee_2;
				s_master_rd_fee_2_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 3 requested a read and is not queued
			if ((fee_3_rd_rmap_i.read = '1') and (s_master_rd_fee_3_queued = '0')) then
				-- master fee 3 requested a read and is not queued
				-- put master fee read 3 in the queue
				s_master_queue(v_master_queue_insert_index) <= master_rd_fee_3;
				s_master_rd_fee_3_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 4 requested a read and is not queued
			if ((fee_4_rd_rmap_i.read = '1') and (s_master_rd_fee_4_queued = '0')) then
				-- master fee 4 requested a read and is not queued
				-- put master fee read 4 in the queue
				s_master_queue(v_master_queue_insert_index) <= master_rd_fee_4;
				s_master_rd_fee_4_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 5 requested a read and is not queued
			if ((fee_5_rd_rmap_i.read = '1') and (s_master_rd_fee_5_queued = '0')) then
				-- master fee 5 requested a read and is not queued
				-- put master fee read 5 in the queue
				s_master_queue(v_master_queue_insert_index) <= master_rd_fee_5;
				s_master_rd_fee_5_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 6 requested a read and is not queued
			if ((fee_6_rd_rmap_i.read = '1') and (s_master_rd_fee_6_queued = '0')) then
				-- master fee 6 requested a read and is not queued
				-- put master fee read 6 in the queue
				s_master_queue(v_master_queue_insert_index) <= master_rd_fee_6;
				s_master_rd_fee_6_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- check if master fee 7 requested a read and is not queued
			if ((fee_7_rd_rmap_i.read = '1') and (s_master_rd_fee_7_queued = '0')) then
				-- master fee 7 requested a read and is not queued
				-- put master fee read 7 in the queue
				s_master_queue(v_master_queue_insert_index) <= master_rd_fee_7;
				s_master_rd_fee_7_queued                    <= '1';
				-- update master queue index
				if (v_master_queue_insert_index < t_master_queue_index'high) then
					v_master_queue_insert_index := v_master_queue_insert_index + 1;
				else
					v_master_queue_insert_index := 0;
				end if;
			end if;

			-- master queue management
			-- case to handle the master queue
			case (s_master_queue(v_master_queue_remove_index)) is

				when master_none =>
					-- no master waiting at the queue
					s_selected_master <= master_none;

				when master_wr_avs_0 =>
					-- master avs 0 write at top of the queue
					s_selected_master <= master_wr_avs_0;
					-- check if the master is finished
					if (avalon_0_mm_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_wr_avs_0_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_wr_fee_0 =>
					-- master fee 0 write at top of the queue
					s_selected_master <= master_wr_fee_0;
					-- check if the master is finished
					if (fee_0_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_wr_fee_0_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_wr_fee_1 =>
					-- master fee 1 write at top of the queue
					s_selected_master <= master_wr_fee_1;
					-- check if the master is finished
					if (fee_1_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_wr_fee_1_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_wr_fee_2 =>
					-- master fee 2 write at top of the queue
					s_selected_master <= master_wr_fee_2;
					-- check if the master is finished
					if (fee_2_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_wr_fee_2_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_wr_fee_3 =>
					-- master fee 3 write at top of the queue
					s_selected_master <= master_wr_fee_3;
					-- check if the master is finished
					if (fee_3_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_wr_fee_3_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_wr_fee_4 =>
					-- master fee 4 write at top of the queue
					s_selected_master <= master_wr_fee_4;
					-- check if the master is finished
					if (fee_4_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_wr_fee_4_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_wr_fee_5 =>
					-- master fee 5 write at top of the queue
					s_selected_master <= master_wr_fee_5;
					-- check if the master is finished
					if (fee_5_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_wr_fee_5_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_wr_fee_6 =>
					-- master fee 6 write at top of the queue
					s_selected_master <= master_wr_fee_6;
					-- check if the master is finished
					if (fee_6_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_wr_fee_6_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_wr_fee_7 =>
					-- master fee 7 write at top of the queue
					s_selected_master <= master_wr_fee_7;
					-- check if the master is finished
					if (fee_7_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_wr_fee_7_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_rd_avs_0 =>
					-- master avs 0 read at top of the queue
					s_selected_master <= master_rd_avs_0;
					-- check if the master is finished
					if (avalon_0_mm_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_rd_avs_0_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_rd_fee_0 =>
					-- master fee 0 read at top of the queue
					s_selected_master <= master_rd_fee_0;
					-- check if the master is finished
					if (fee_0_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_rd_fee_0_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_rd_fee_1 =>
					-- master fee 1 read at top of the queue
					s_selected_master <= master_rd_fee_1;
					-- check if the master is finished
					if (fee_1_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_rd_fee_1_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_rd_fee_2 =>
					-- master fee 2 read at top of the queue
					s_selected_master <= master_rd_fee_2;
					-- check if the master is finished
					if (fee_2_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_rd_fee_2_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_rd_fee_3 =>
					-- master fee 3 read at top of the queue
					s_selected_master <= master_rd_fee_3;
					-- check if the master is finished
					if (fee_3_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_rd_fee_3_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_rd_fee_4 =>
					-- master fee 4 read at top of the queue
					s_selected_master <= master_rd_fee_4;
					-- check if the master is finished
					if (fee_4_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_rd_fee_4_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_rd_fee_5 =>
					-- master fee 5 read at top of the queue
					s_selected_master <= master_rd_fee_5;
					-- check if the master is finished
					if (fee_5_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_rd_fee_5_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_rd_fee_6 =>
					-- master fee 6 read at top of the queue
					s_selected_master <= master_rd_fee_6;
					-- check if the master is finished
					if (fee_6_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_rd_fee_6_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

				when master_rd_fee_7 =>
					-- master fee 7 read at top of the queue
					s_selected_master <= master_rd_fee_7;
					-- check if the master is finished
					if (fee_7_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                           <= master_none;
						-- remove master from the queue
						s_master_queue(v_master_queue_remove_index) <= master_none;
						s_master_rd_fee_7_queued                    <= '0';
						-- update master queue index
						if (v_master_queue_remove_index < t_master_queue_index'high) then
							v_master_queue_remove_index := v_master_queue_remove_index + 1;
						else
							v_master_queue_remove_index := 0;
						end if;
					end if;

			end case;

		end if;
	end process p_fdrm_rmap_mem_area_ffee_deb_arbiter;

	-- Signals assignments --

	-- Waitrequest
	s_avalon_mm_rmap_waitrequest <= (avalon_mm_wr_rmap_i.waitrequest) and (avalon_mm_rd_rmap_i.waitrequest);
	s_fee_rmap_waitrequest       <= (fee_wr_rmap_cfg_hk_i.waitrequest) and (fee_rd_rmap_cfg_hk_i.waitrequest);
	s_rmap_waitrequest           <= (s_fee_rmap_waitrequest) and (s_avalon_mm_rmap_waitrequest);

	-- Windowing Area Address Flags
	s_fee_0_wr_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_0_wr_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_1_wr_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_1_wr_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_2_wr_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_2_wr_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_3_wr_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_3_wr_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_4_wr_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_4_wr_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_5_wr_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_5_wr_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_6_wr_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_6_wr_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_7_wr_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_7_wr_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_0_rd_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_0_rd_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_1_rd_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_1_rd_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_2_rd_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_2_rd_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_3_rd_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_3_rd_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_4_rd_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_4_rd_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_5_rd_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_5_rd_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_6_rd_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_6_rd_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');
	s_fee_7_rd_win_address_flag <= ('0') when (rst_i = '1')
	                               else ('1') when (fee_7_rd_rmap_i.address(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH) = c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_MASK(31 downto c_FDRM_FFEE_DEB_RMAP_WIN_OFFSET_WIDTH))
	                               else ('0');

	-- Masters Write inputs
	avalon_mm_wr_rmap_o  <= (c_FDRM_AVALON_MM_RMAP_FFEE_DEB_WRITE_IN_RST) when (rst_i = '1')
	                        else (avalon_0_mm_wr_rmap_i) when (s_selected_master = master_wr_avs_0)
	                        else (c_FDRM_AVALON_MM_RMAP_FFEE_DEB_WRITE_IN_RST);
	fee_wr_rmap_cfg_hk_o <= (c_FDRM_FFEE_DEB_RMAP_WRITE_IN_RST) when (rst_i = '1')
	                        else (fee_0_wr_rmap_i) when ((s_selected_master = master_wr_fee_0) and (s_fee_0_wr_win_address_flag = '0'))
	                        else (fee_1_wr_rmap_i) when ((s_selected_master = master_wr_fee_1) and (s_fee_1_wr_win_address_flag = '0'))
	                        else (fee_2_wr_rmap_i) when ((s_selected_master = master_wr_fee_2) and (s_fee_2_wr_win_address_flag = '0'))
	                        else (fee_3_wr_rmap_i) when ((s_selected_master = master_wr_fee_3) and (s_fee_3_wr_win_address_flag = '0'))
	                        else (fee_4_wr_rmap_i) when ((s_selected_master = master_wr_fee_4) and (s_fee_4_wr_win_address_flag = '0'))
	                        else (fee_5_wr_rmap_i) when ((s_selected_master = master_wr_fee_5) and (s_fee_5_wr_win_address_flag = '0'))
	                        else (fee_6_wr_rmap_i) when ((s_selected_master = master_wr_fee_6) and (s_fee_6_wr_win_address_flag = '0'))
	                        else (fee_7_wr_rmap_i) when ((s_selected_master = master_wr_fee_7) and (s_fee_7_wr_win_address_flag = '0'))
	                        else (c_FDRM_FFEE_DEB_RMAP_WRITE_IN_RST);
	fee_wr_rmap_win_o    <= (c_FDRM_FFEE_DEB_RMAP_WRITE_IN_RST) when (rst_i = '1')
	                        else (fee_0_wr_rmap_i) when ((s_selected_master = master_wr_fee_0) and (s_fee_0_wr_win_address_flag = '1'))
	                        else (fee_1_wr_rmap_i) when ((s_selected_master = master_wr_fee_1) and (s_fee_1_wr_win_address_flag = '1'))
	                        else (fee_2_wr_rmap_i) when ((s_selected_master = master_wr_fee_2) and (s_fee_2_wr_win_address_flag = '1'))
	                        else (fee_3_wr_rmap_i) when ((s_selected_master = master_wr_fee_3) and (s_fee_3_wr_win_address_flag = '1'))
	                        else (fee_4_wr_rmap_i) when ((s_selected_master = master_wr_fee_4) and (s_fee_4_wr_win_address_flag = '1'))
	                        else (fee_5_wr_rmap_i) when ((s_selected_master = master_wr_fee_5) and (s_fee_5_wr_win_address_flag = '1'))
	                        else (fee_6_wr_rmap_i) when ((s_selected_master = master_wr_fee_6) and (s_fee_6_wr_win_address_flag = '1'))
	                        else (fee_7_wr_rmap_i) when ((s_selected_master = master_wr_fee_7) and (s_fee_7_wr_win_address_flag = '1'))
	                        else (c_FDRM_FFEE_DEB_RMAP_WRITE_IN_RST);

	-- Masters Write outputs
	avalon_0_mm_wr_rmap_o <= (c_FDRM_AVALON_MM_RMAP_FFEE_DEB_WRITE_OUT_RST) when (rst_i = '1')
	                         else (avalon_mm_wr_rmap_i) when (s_selected_master = master_wr_avs_0)
	                         else (c_FDRM_AVALON_MM_RMAP_FFEE_DEB_WRITE_OUT_RST);
	fee_0_wr_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST) when (rst_i = '1')
	                         else (fee_wr_rmap_cfg_hk_i) when ((s_selected_master = master_wr_fee_0) and (s_fee_0_wr_win_address_flag = '0'))
	                         else (fee_wr_rmap_win_i) when ((s_selected_master = master_wr_fee_0) and (s_fee_0_wr_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST);
	fee_1_wr_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST) when (rst_i = '1')
	                         else (fee_wr_rmap_cfg_hk_i) when ((s_selected_master = master_wr_fee_1) and (s_fee_1_wr_win_address_flag = '0'))
	                         else (fee_wr_rmap_win_i) when ((s_selected_master = master_wr_fee_1) and (s_fee_1_wr_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST);
	fee_2_wr_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST) when (rst_i = '1')
	                         else (fee_wr_rmap_cfg_hk_i) when ((s_selected_master = master_wr_fee_2) and (s_fee_2_wr_win_address_flag = '0'))
	                         else (fee_wr_rmap_win_i) when ((s_selected_master = master_wr_fee_2) and (s_fee_2_wr_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST);
	fee_3_wr_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST) when (rst_i = '1')
	                         else (fee_wr_rmap_cfg_hk_i) when ((s_selected_master = master_wr_fee_3) and (s_fee_3_wr_win_address_flag = '0'))
	                         else (fee_wr_rmap_win_i) when ((s_selected_master = master_wr_fee_3) and (s_fee_3_wr_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST);
	fee_4_wr_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST) when (rst_i = '1')
	                         else (fee_wr_rmap_cfg_hk_i) when ((s_selected_master = master_wr_fee_4) and (s_fee_4_wr_win_address_flag = '0'))
	                         else (fee_wr_rmap_win_i) when ((s_selected_master = master_wr_fee_4) and (s_fee_4_wr_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST);
	fee_5_wr_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST) when (rst_i = '1')
	                         else (fee_wr_rmap_cfg_hk_i) when ((s_selected_master = master_wr_fee_5) and (s_fee_5_wr_win_address_flag = '0'))
	                         else (fee_wr_rmap_win_i) when ((s_selected_master = master_wr_fee_5) and (s_fee_5_wr_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST);
	fee_6_wr_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST) when (rst_i = '1')
	                         else (fee_wr_rmap_cfg_hk_i) when ((s_selected_master = master_wr_fee_6) and (s_fee_6_wr_win_address_flag = '0'))
	                         else (fee_wr_rmap_win_i) when ((s_selected_master = master_wr_fee_6) and (s_fee_6_wr_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST);
	fee_7_wr_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST) when (rst_i = '1')
	                         else (fee_wr_rmap_cfg_hk_i) when ((s_selected_master = master_wr_fee_7) and (s_fee_7_wr_win_address_flag = '0'))
	                         else (fee_wr_rmap_win_i) when ((s_selected_master = master_wr_fee_7) and (s_fee_7_wr_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_WRITE_OUT_RST);

	-- Masters Read inputs
	avalon_mm_rd_rmap_o  <= (c_FDRM_AVALON_MM_RMAP_FFEE_DEB_READ_IN_RST) when (rst_i = '1')
	                        else (avalon_0_mm_rd_rmap_i) when (s_selected_master = master_rd_avs_0)
	                        else (c_FDRM_AVALON_MM_RMAP_FFEE_DEB_READ_IN_RST);
	fee_rd_rmap_cfg_hk_o <= (c_FDRM_FFEE_DEB_RMAP_READ_IN_RST) when (rst_i = '1')
	                        else (fee_0_rd_rmap_i) when ((s_selected_master = master_rd_fee_0) and (s_fee_0_rd_win_address_flag = '0'))
	                        else (fee_1_rd_rmap_i) when ((s_selected_master = master_rd_fee_1) and (s_fee_1_rd_win_address_flag = '0'))
	                        else (fee_2_rd_rmap_i) when ((s_selected_master = master_rd_fee_2) and (s_fee_2_rd_win_address_flag = '0'))
	                        else (fee_3_rd_rmap_i) when ((s_selected_master = master_rd_fee_3) and (s_fee_3_rd_win_address_flag = '0'))
	                        else (fee_4_rd_rmap_i) when ((s_selected_master = master_rd_fee_4) and (s_fee_4_rd_win_address_flag = '0'))
	                        else (fee_5_rd_rmap_i) when ((s_selected_master = master_rd_fee_5) and (s_fee_5_rd_win_address_flag = '0'))
	                        else (fee_6_rd_rmap_i) when ((s_selected_master = master_rd_fee_6) and (s_fee_6_rd_win_address_flag = '0'))
	                        else (fee_7_rd_rmap_i) when ((s_selected_master = master_rd_fee_7) and (s_fee_7_rd_win_address_flag = '0'))
	                        else (c_FDRM_FFEE_DEB_RMAP_READ_IN_RST);
	fee_rd_rmap_win_o    <= (c_FDRM_FFEE_DEB_RMAP_READ_IN_RST) when (rst_i = '1')
	                        else (fee_0_rd_rmap_i) when ((s_selected_master = master_rd_fee_0) and (s_fee_0_rd_win_address_flag = '1'))
	                        else (fee_1_rd_rmap_i) when ((s_selected_master = master_rd_fee_1) and (s_fee_1_rd_win_address_flag = '1'))
	                        else (fee_2_rd_rmap_i) when ((s_selected_master = master_rd_fee_2) and (s_fee_2_rd_win_address_flag = '1'))
	                        else (fee_3_rd_rmap_i) when ((s_selected_master = master_rd_fee_3) and (s_fee_3_rd_win_address_flag = '1'))
	                        else (fee_4_rd_rmap_i) when ((s_selected_master = master_rd_fee_4) and (s_fee_4_rd_win_address_flag = '1'))
	                        else (fee_5_rd_rmap_i) when ((s_selected_master = master_rd_fee_5) and (s_fee_5_rd_win_address_flag = '1'))
	                        else (fee_6_rd_rmap_i) when ((s_selected_master = master_rd_fee_6) and (s_fee_6_rd_win_address_flag = '1'))
	                        else (fee_7_rd_rmap_i) when ((s_selected_master = master_rd_fee_7) and (s_fee_7_rd_win_address_flag = '1'))
	                        else (c_FDRM_FFEE_DEB_RMAP_READ_IN_RST);

	-- Masters Read outputs
	avalon_0_mm_rd_rmap_o <= (c_FDRM_AVALON_MM_RMAP_FFEE_DEB_READ_OUT_RST) when (rst_i = '1')
	                         else (avalon_mm_rd_rmap_i) when (s_selected_master = master_rd_avs_0)
	                         else (c_FDRM_AVALON_MM_RMAP_FFEE_DEB_READ_OUT_RST);
	fee_0_rd_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST) when (rst_i = '1')
	                         else (fee_rd_rmap_cfg_hk_i) when ((s_selected_master = master_rd_fee_0) and (s_fee_0_rd_win_address_flag = '0'))
	                         else (fee_rd_rmap_win_i) when ((s_selected_master = master_rd_fee_0) and (s_fee_0_rd_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST);
	fee_1_rd_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST) when (rst_i = '1')
	                         else (fee_rd_rmap_cfg_hk_i) when ((s_selected_master = master_rd_fee_1) and (s_fee_1_rd_win_address_flag = '0'))
	                         else (fee_rd_rmap_win_i) when ((s_selected_master = master_rd_fee_1) and (s_fee_1_rd_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST);
	fee_2_rd_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST) when (rst_i = '1')
	                         else (fee_rd_rmap_cfg_hk_i) when ((s_selected_master = master_rd_fee_2) and (s_fee_2_rd_win_address_flag = '0'))
	                         else (fee_rd_rmap_win_i) when ((s_selected_master = master_rd_fee_2) and (s_fee_2_rd_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST);
	fee_3_rd_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST) when (rst_i = '1')
	                         else (fee_rd_rmap_cfg_hk_i) when ((s_selected_master = master_rd_fee_3) and (s_fee_3_rd_win_address_flag = '0'))
	                         else (fee_rd_rmap_win_i) when ((s_selected_master = master_rd_fee_3) and (s_fee_3_rd_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST);
	fee_4_rd_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST) when (rst_i = '1')
	                         else (fee_rd_rmap_cfg_hk_i) when ((s_selected_master = master_rd_fee_4) and (s_fee_4_rd_win_address_flag = '0'))
	                         else (fee_rd_rmap_win_i) when ((s_selected_master = master_rd_fee_4) and (s_fee_4_rd_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST);
	fee_5_rd_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST) when (rst_i = '1')
	                         else (fee_rd_rmap_cfg_hk_i) when ((s_selected_master = master_rd_fee_5) and (s_fee_5_rd_win_address_flag = '0'))
	                         else (fee_rd_rmap_win_i) when ((s_selected_master = master_rd_fee_5) and (s_fee_5_rd_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST);
	fee_6_rd_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST) when (rst_i = '1')
	                         else (fee_rd_rmap_cfg_hk_i) when ((s_selected_master = master_rd_fee_6) and (s_fee_6_rd_win_address_flag = '0'))
	                         else (fee_rd_rmap_win_i) when ((s_selected_master = master_rd_fee_6) and (s_fee_6_rd_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST);
	fee_7_rd_rmap_o       <= (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST) when (rst_i = '1')
	                         else (fee_rd_rmap_cfg_hk_i) when ((s_selected_master = master_rd_fee_7) and (s_fee_7_rd_win_address_flag = '0'))
	                         else (fee_rd_rmap_win_i) when ((s_selected_master = master_rd_fee_7) and (s_fee_7_rd_win_address_flag = '1'))
	                         else (c_FDRM_FFEE_DEB_RMAP_READ_OUT_RST);

end architecture RTL;
