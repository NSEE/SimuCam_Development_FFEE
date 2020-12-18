library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_avm_imgt_pkg.all;

entity ftdi_imgt_controller_imagette_ent is
	port(
		clk_i                      : in  std_logic;
		rst_i                      : in  std_logic;
		ftdi_module_stop_i         : in  std_logic;
		ftdi_module_start_i        : in  std_logic;
		controller_start_i         : in  std_logic;
		controller_reset_i         : in  std_logic;
		ccd_left_initial_addr_i    : in  std_logic_vector(63 downto 0);
		ccd_right_initial_addr_i   : in  std_logic_vector(63 downto 0);
		ccd_halfwidth_pixels_i     : in  std_logic_vector(15 downto 0);
		ccd_height_pixels_i        : in  std_logic_vector(15 downto 0);
		invert_pixels_byte_order_i : in  std_logic;
		avm_master_wr_status_i     : in  t_ftdi_avm_imgt_master_wr_status;
		imgt_data_rdready_i        : in  std_logic;
		imgt_data_rddata_i         : in  std_logic_vector(31 downto 0);
		controller_finished_o      : out std_logic;
		avm_master_wr_control_o    : out t_ftdi_avm_imgt_master_wr_control;
		imgt_data_rddone_o         : out std_logic
	);
end entity ftdi_imgt_controller_imagette_ent;

architecture RTL of ftdi_imgt_controller_imagette_ent is

	type t_ftdi_imgt_controller_imagette_fsm is (
		STOPPED,                        -- imgt controller imagette is stopped
		IDLE,                           -- imgt controller imagette is in idle
		BUFFER_WAITING,                 -- waiting imagette data
		IMAGETTE_COORDINATE,            -- imagette window coordinate
		IMAGETTE_SIZE,                  -- imagette window size
		IMAGETTE_PIXEL_0,               -- imagette pixel 0 data
		IMAGETTE_PIXEL_1,               -- imagette pixel 1 data
		AVM_WAITING,                    -- waiting avm to be ready
		WRITE_START,                    -- start of an avm write
		WRITE_WAITING,                  -- wait for avm write to finish
		BUFFER_READ,                    -- read imagette data
		FINISHED                        -- imgt controller imagette is finished
	);

	signal s_ftdi_imgt_controller_imagette_state      : t_ftdi_imgt_controller_imagette_fsm;
	signal s_ftdi_imgt_controller_imagette_next_state : t_ftdi_imgt_controller_imagette_fsm;

	-- information alias
	alias a_coordinate_0 is imgt_data_rddata_i(31 downto 16);
	alias a_coordinate_1 is imgt_data_rddata_i(15 downto 0);
	alias a_imagette_width is imgt_data_rddata_i(21 downto 16);
	alias a_imagette_height is imgt_data_rddata_i(5 downto 0);
	alias a_pixel_0_msb is imgt_data_rddata_i(31 downto 24);
	alias a_pixel_0_lsb is imgt_data_rddata_i(23 downto 16);
	alias a_pixel_1_msb is imgt_data_rddata_i(15 downto 8);
	alias a_pixel_1_lsb is imgt_data_rddata_i(7 downto 0);

	-- coordinates constants
	constant c_X_COORDINATE_ID : std_logic_vector(1 downto 0) := "10";
	constant c_Y_COORDINATE_ID : std_logic_vector(1 downto 0) := "01";
	constant c_SIDE_INDEX      : natural                      := 13;
	constant c_SIDE_LEFT       : std_logic                    := '0';
	constant c_SIDE_RIGHT      : std_logic                    := '1';

	-- registered signals
	signal s_registered_side            : std_logic;
	signal s_registered_x_coordinate    : unsigned(12 downto 0);
	signal s_registered_y_coordinate    : unsigned(13 downto 0);
	signal s_registered_imagette_height : unsigned(5 downto 0);
	signal s_registered_imagette_width  : unsigned(5 downto 0);

	-- internal counters signals 
	signal s_imagette_rows_cnt       : unsigned(5 downto 0);
	signal s_imagette_columns_cnt    : unsigned(5 downto 0);
	signal s_ccd_byte_position       : unsigned(30 downto 0);
	signal s_ccd_row_offset_position : unsigned(16 downto 0);
	signal s_imagette_ended          : std_logic;

	-- avm write signals
	signal s_avm_wr_data        : std_logic_vector(15 downto 0);
	signal s_avm_wr_addr_base   : unsigned(63 downto 0);
	signal s_avm_wr_addr_offset : unsigned(30 downto 0);

begin

	p_ftdi_imgt_controller_imagette : process(clk_i, rst_i) is
		function f_calculate_initial_ccd_byte_position(ccd_row_y_i : unsigned; ccd_column_x_i : unsigned; ccd_halfwidth_pixels_i : unsigned) return unsigned is
			variable v_initial_ccd_byte_position : unsigned(30 downto 0) := (others => '0');
			variable v_row_doubled               : unsigned(14 downto 0) := (others => '0');
			variable v_row_offset                : unsigned(30 downto 0) := (others => '0');
			variable v_column_offset             : unsigned(14 downto 0) := (others => '0');
		begin

			-- v_initial_ccd_byte_position = (ccd_row_y_i * ccd_halfwidth_pixels_i + ccd_column_x_i) * 2

			-- v_row_doubled = ccd_row_y_i * 2
			v_row_doubled(14 downto 1) := ccd_row_y_i;
			v_row_doubled(0)           := '0';

			-- v_row_offset = v_row_doubled * ccd_halfwidth_pixels_i
			v_row_offset := v_row_doubled * ccd_halfwidth_pixels_i;

			-- v_column_offset = ccd_column_x_i * 2
			v_column_offset(13 downto 1) := ccd_column_x_i;
			v_column_offset(0)           := '0';

			-- v_initial_ccd_byte_position = v_row_offset + v_column_offset
			v_initial_ccd_byte_position := v_row_offset + v_column_offset;

			return v_initial_ccd_byte_position;
		end function f_calculate_initial_ccd_byte_position;

		function f_calculate_addr_offset(ccd_byte_position_i : unsigned) return unsigned is
			variable v_addr_offset      : unsigned(30 downto 0) := (others => '0');
			variable v_mask_byte_offset : unsigned(26 downto 0) := (others => '0');
		begin

			-- v_mask_byte_offset is (ccd_byte_position_i/128)*8
			v_mask_byte_offset(26 downto 3) := ccd_byte_position_i(30 downto 7);
			v_mask_byte_offset(2 downto 0)  := (others => '0');

			v_addr_offset := ccd_byte_position_i + v_mask_byte_offset;

			return v_addr_offset;
		end function f_calculate_addr_offset;

		variable v_ftdi_imgt_controller_imagette_state : t_ftdi_imgt_controller_imagette_fsm := STOPPED;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_ftdi_imgt_controller_imagette_state      <= STOPPED;
			v_ftdi_imgt_controller_imagette_state      := STOPPED;
			s_ftdi_imgt_controller_imagette_next_state <= STOPPED;
			-- internal signals reset
			s_registered_side                          <= '0';
			s_registered_x_coordinate                  <= (others => '0');
			s_registered_y_coordinate                  <= (others => '0');
			s_registered_imagette_height               <= (others => '0');
			s_registered_imagette_width                <= (others => '0');
			s_imagette_rows_cnt                        <= (others => '0');
			s_imagette_columns_cnt                     <= (others => '0');
			s_ccd_byte_position                        <= (others => '0');
			s_ccd_row_offset_position                  <= (others => '0');
			s_imagette_ended                           <= '0';
			s_avm_wr_data                              <= (others => '0');
			s_avm_wr_addr_base                         <= (others => '0');
			s_avm_wr_addr_offset                       <= (others => '0');
			-- outputs reset
			controller_finished_o                      <= '0';
			avm_master_wr_control_o                    <= c_FTDI_AVM_IMGT_MASTER_WR_CONTROL_RST;
			imgt_data_rddone_o                         <= '0';
		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_ftdi_imgt_controller_imagette_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- imgt controller imagette is stopped
					-- default state transition
					s_ftdi_imgt_controller_imagette_state      <= STOPPED;
					v_ftdi_imgt_controller_imagette_state      := STOPPED;
					s_ftdi_imgt_controller_imagette_next_state <= STOPPED;
					-- default internal signal values
					s_registered_side                          <= '0';
					s_registered_x_coordinate                  <= (others => '0');
					s_registered_y_coordinate                  <= (others => '0');
					s_registered_imagette_height               <= (others => '0');
					s_registered_imagette_width                <= (others => '0');
					s_imagette_rows_cnt                        <= (others => '0');
					s_imagette_columns_cnt                     <= (others => '0');
					s_ccd_byte_position                        <= (others => '0');
					s_ccd_row_offset_position                  <= (others => '0');
					s_imagette_ended                           <= '0';
					s_avm_wr_data                              <= (others => '0');
					s_avm_wr_addr_base                         <= (others => '0');
					s_avm_wr_addr_offset                       <= (others => '0');
					-- conditional state transition
					-- check if a start was issued
					if (ftdi_module_start_i = '1') then
						-- start issued, go to idle
						s_ftdi_imgt_controller_imagette_state <= IDLE;
						v_ftdi_imgt_controller_imagette_state := IDLE;
					end if;

				-- state "IDLE"
				when IDLE =>
					-- imgt controller imagette is in idle
					-- default state transition
					s_ftdi_imgt_controller_imagette_state      <= IDLE;
					v_ftdi_imgt_controller_imagette_state      := IDLE;
					s_ftdi_imgt_controller_imagette_next_state <= STOPPED;
					-- default internal signal values
					s_registered_side                          <= '0';
					s_registered_x_coordinate                  <= (others => '0');
					s_registered_y_coordinate                  <= (others => '0');
					s_registered_imagette_height               <= (others => '0');
					s_registered_imagette_width                <= (others => '0');
					s_imagette_rows_cnt                        <= (others => '0');
					s_imagette_columns_cnt                     <= (others => '0');
					s_ccd_byte_position                        <= (others => '0');
					s_ccd_row_offset_position                  <= (others => '0');
					s_imagette_ended                           <= '0';
					s_avm_wr_data                              <= (others => '0');
					s_avm_wr_addr_base                         <= (others => '0');
					s_avm_wr_addr_offset                       <= (others => '0');
					-- conditional state transition
					-- check if a write start was requested
					if (controller_start_i = '1') then
						-- write start requested
						-- go to buffer waiting
						s_ftdi_imgt_controller_imagette_state      <= BUFFER_WAITING;
						v_ftdi_imgt_controller_imagette_state      := BUFFER_WAITING;
						s_ftdi_imgt_controller_imagette_next_state <= IMAGETTE_COORDINATE;
					end if;

				-- state "BUFFER_WAITING"
				when BUFFER_WAITING =>
					-- waiting imagette data
					-- default state transition
					s_ftdi_imgt_controller_imagette_state <= BUFFER_WAITING;
					v_ftdi_imgt_controller_imagette_state := BUFFER_WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the imagette data is ready
					if (imgt_data_rdready_i = '1') then
						-- the imagette data is ready
						-- go to next state
						s_ftdi_imgt_controller_imagette_state <= s_ftdi_imgt_controller_imagette_next_state;
						v_ftdi_imgt_controller_imagette_state := s_ftdi_imgt_controller_imagette_next_state;
					end if;

				-- state "IMAGETTE_COORDINATE"
				when IMAGETTE_COORDINATE =>
					-- imagette window coordinate
					-- default state transition
					s_ftdi_imgt_controller_imagette_state      <= BUFFER_WAITING;
					v_ftdi_imgt_controller_imagette_state      := BUFFER_WAITING;
					s_ftdi_imgt_controller_imagette_next_state <= IMAGETTE_SIZE;
					-- default internal signal values
					-- conditional state transition
					-- check if coordinate 0 is a x coordinate and coordinate 1 is a y coordinate
					if ((a_coordinate_0(15 + 16 downto 14 + 16) = c_X_COORDINATE_ID) and (a_coordinate_1(15 downto 14) = c_Y_COORDINATE_ID)) then
						-- coordinate 0 is a x coordinate and coordinate 1 is a y coordinate
						s_registered_side         <= a_coordinate_0(c_SIDE_INDEX + 16);
						s_registered_x_coordinate <= unsigned(a_coordinate_0(12 + 16 downto 0 + 16));
						s_registered_y_coordinate <= unsigned(a_coordinate_1(13 downto 0));
					else
						-- coordinate 0 is a y coordinate and coordinate 1 is a x coordinate
						s_registered_y_coordinate <= unsigned(a_coordinate_0(13 + 16 downto 0 + 16));
						s_registered_side         <= a_coordinate_1(c_SIDE_INDEX);
						s_registered_x_coordinate <= unsigned(a_coordinate_1(12 downto 0));
					end if;

				-- state "IMAGETTE_SIZE"
				when IMAGETTE_SIZE =>
					-- imagette window size
					-- default state transition
					s_ftdi_imgt_controller_imagette_state      <= BUFFER_WAITING;
					v_ftdi_imgt_controller_imagette_state      := BUFFER_WAITING;
					s_ftdi_imgt_controller_imagette_next_state <= IMAGETTE_PIXEL_0;
					-- default internal signal values
					s_registered_imagette_height               <= unsigned(a_imagette_height);
					s_registered_imagette_width                <= unsigned(a_imagette_width);
					s_imagette_rows_cnt                        <= unsigned(a_imagette_height) - 1;
					s_imagette_columns_cnt                     <= unsigned(a_imagette_width) - 1;
					s_ccd_byte_position                        <= f_calculate_initial_ccd_byte_position(s_registered_y_coordinate, s_registered_x_coordinate, unsigned(ccd_halfwidth_pixels_i));
					s_ccd_row_offset_position(15 downto 1)     <= unsigned(ccd_halfwidth_pixels_i(14 downto 0));
					s_ccd_row_offset_position(0)               <= '0';
					-- conditional state transition
					-- check if the imagette side is left
					if (s_registered_side = c_SIDE_LEFT) then
						-- the imagette side is left
						s_avm_wr_addr_base <= unsigned(ccd_left_initial_addr_i);
					else
						-- the imagette side is rigth
						s_avm_wr_addr_base <= unsigned(ccd_right_initial_addr_i);
					end if;

				-- state "IMAGETTE_PIXEL_0"
				when IMAGETTE_PIXEL_0 =>
					-- imagette pixel 0 data
					-- default state transition
					s_ftdi_imgt_controller_imagette_state      <= AVM_WAITING;
					v_ftdi_imgt_controller_imagette_state      := AVM_WAITING;
					s_ftdi_imgt_controller_imagette_next_state <= IMAGETTE_PIXEL_1;
					-- default internal signal values
					-- check if the pixels byte order need to be inverted
					if (invert_pixels_byte_order_i = '1') then
						s_avm_wr_data(15 downto 8) <= a_pixel_0_lsb;
						s_avm_wr_data(7 downto 0)  <= a_pixel_0_msb;
					else
						s_avm_wr_data(15 downto 8) <= a_pixel_0_msb;
						s_avm_wr_data(7 downto 0)  <= a_pixel_0_lsb;
					end if;
					s_avm_wr_addr_offset                       <= f_calculate_addr_offset(s_ccd_byte_position);
					-- conditional state transition
					-- check if reached the end of the imagette columns
					if (s_imagette_columns_cnt = 0) then
						-- reached the end of the imagette columns
						-- check if reached the end of the imagette rows
						if (s_imagette_rows_cnt = 0) then
							-- reached the end of the imagette rows
							-- end of the imagette, set imagette ended flag
							s_imagette_ended <= '1';
						else
							-- not reached the end of the imagette rows yet
							-- decrement imagette rows counter
							s_imagette_rows_cnt                    <= s_imagette_rows_cnt - 1;
							-- reset the imagette columns counter
							s_imagette_columns_cnt                 <= s_registered_imagette_width - 1;
							-- update ccd byte position
							s_ccd_byte_position                    <= s_ccd_byte_position + s_ccd_row_offset_position;
							-- update ccd row offset position
							s_ccd_row_offset_position(15 downto 1) <= unsigned(ccd_halfwidth_pixels_i(14 downto 0));
							s_ccd_row_offset_position(0)           <= '0';
						end if;
					else
						-- not reached the end of the imagette columns yet
						-- decrement imagette columns counter
						s_imagette_columns_cnt    <= s_imagette_columns_cnt - 1;
						-- update ccd byte position
						s_ccd_byte_position       <= s_ccd_byte_position + 2;
						-- update ccd row offset position
						s_ccd_row_offset_position <= s_ccd_row_offset_position - 2;
					end if;

				-- state "IMAGETTE_PIXEL_1"
				when IMAGETTE_PIXEL_1 =>
					-- imagette pixel 1 data
					-- default state transition
					s_ftdi_imgt_controller_imagette_state      <= AVM_WAITING;
					v_ftdi_imgt_controller_imagette_state      := AVM_WAITING;
					s_ftdi_imgt_controller_imagette_next_state <= BUFFER_READ;
					-- default internal signal values
					-- check if the pixels byte order need to be inverted
					if (invert_pixels_byte_order_i = '1') then
						s_avm_wr_data(15 downto 8) <= a_pixel_1_lsb;
						s_avm_wr_data(7 downto 0)  <= a_pixel_1_msb;
					else
						s_avm_wr_data(15 downto 8) <= a_pixel_1_msb;
						s_avm_wr_data(7 downto 0)  <= a_pixel_1_lsb;
					end if;
					s_avm_wr_addr_offset                       <= f_calculate_addr_offset(s_ccd_byte_position);
					-- conditional state transition
					-- check if reached the end of the imagette
					if (s_imagette_ended = '1') then
						-- reached the end of the imagette
						-- go to finished
						s_ftdi_imgt_controller_imagette_state      <= BUFFER_READ;
						v_ftdi_imgt_controller_imagette_state      := BUFFER_READ;
						s_ftdi_imgt_controller_imagette_next_state <= FINISHED;
					else
						-- not reached the end of the imagette yet
						-- check if reached the end of the imagette columns
						if (s_imagette_columns_cnt = 0) then
							-- reached the end of the imagette columns
							-- check if reached the end of the imagette rows
							if (s_imagette_rows_cnt = 0) then
								-- reached the end of the imagette rows
								-- end of the imagette, set imagette ended flag
								s_imagette_ended <= '1';
							else
								-- not reached the end of the imagette rows yet
								-- decrement imagette rows counter
								s_imagette_rows_cnt                    <= s_imagette_rows_cnt - 1;
								-- reset the imagette columns counter
								s_imagette_columns_cnt                 <= s_registered_imagette_width - 1;
								-- update ccd byte position
								s_ccd_byte_position                    <= s_ccd_byte_position + s_ccd_row_offset_position;
								-- update ccd row offset position
								s_ccd_row_offset_position(15 downto 1) <= unsigned(ccd_halfwidth_pixels_i(14 downto 0));
								s_ccd_row_offset_position(0)           <= '0';
							end if;
						else
							-- not reached the end of the imagette columns yet
							-- decrement imagette columns counter
							s_imagette_columns_cnt    <= s_imagette_columns_cnt - 1;
							-- update ccd byte position
							s_ccd_byte_position       <= s_ccd_byte_position + 2;
							-- update ccd row offset position
							s_ccd_row_offset_position <= s_ccd_row_offset_position - 2;
						end if;
					end if;

				-- state "AVM_WAITING"
				when AVM_WAITING =>
					-- waiting avm to be ready
					-- default state transition
					s_ftdi_imgt_controller_imagette_state <= AVM_WAITING;
					v_ftdi_imgt_controller_imagette_state := AVM_WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the avm write can start
					if (avm_master_wr_status_i.wr_ready = '1') then
						-- the avm write can start
						-- go to write start
						s_ftdi_imgt_controller_imagette_state <= WRITE_START;
						v_ftdi_imgt_controller_imagette_state := WRITE_START;
					end if;

				-- state "WRITE_START"
				when WRITE_START =>
					-- start of an avm write
					-- default state transition
					s_ftdi_imgt_controller_imagette_state <= WRITE_WAITING;
					v_ftdi_imgt_controller_imagette_state := WRITE_WAITING;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_WAITING"
				when WRITE_WAITING =>
					-- wait for avm write to finish
					-- default state transition
					s_ftdi_imgt_controller_imagette_state <= WRITE_WAITING;
					v_ftdi_imgt_controller_imagette_state := WRITE_WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the avm write is done
					if (avm_master_wr_status_i.wr_done = '1') then
						-- avm write is done
						-- go to next state
						s_ftdi_imgt_controller_imagette_state      <= s_ftdi_imgt_controller_imagette_next_state;
						v_ftdi_imgt_controller_imagette_state      := s_ftdi_imgt_controller_imagette_next_state;
						s_ftdi_imgt_controller_imagette_next_state <= IMAGETTE_PIXEL_0;
					end if;

				-- state "BUFFER_READ"
				when BUFFER_READ =>
					-- read imagette data
					-- default state transition
					s_ftdi_imgt_controller_imagette_state      <= BUFFER_WAITING;
					v_ftdi_imgt_controller_imagette_state      := BUFFER_WAITING;
					s_ftdi_imgt_controller_imagette_next_state <= IMAGETTE_PIXEL_0;
					-- default internal signal values
					-- conditional state transition
					-- check if reached the end of the imagette
					if (s_imagette_ended = '1') then
						-- reached the end of the imagette
						-- go to finished
						s_ftdi_imgt_controller_imagette_state      <= FINISHED;
						v_ftdi_imgt_controller_imagette_state      := FINISHED;
						s_ftdi_imgt_controller_imagette_next_state <= STOPPED;
					end if;

				-- state "FINISHED"
				when FINISHED =>
					-- imgt controller imagette is finished
					-- default state transition
					s_ftdi_imgt_controller_imagette_state      <= FINISHED;
					v_ftdi_imgt_controller_imagette_state      := FINISHED;
					s_ftdi_imgt_controller_imagette_next_state <= STOPPED;
				-- default internal signal values
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_ftdi_imgt_controller_imagette_state <= STOPPED;
					v_ftdi_imgt_controller_imagette_state := STOPPED;

			end case;

			-- check if a stop was issued
			if (ftdi_module_stop_i = '1') then
				-- a stop was issued
				-- go to stopped
				s_ftdi_imgt_controller_imagette_state      <= STOPPED;
				v_ftdi_imgt_controller_imagette_state      := STOPPED;
				s_ftdi_imgt_controller_imagette_next_state <= STOPPED;
			-- check if a reset was requested
			elsif (controller_reset_i = '1') then
				-- a reset was requested
				-- go to idle
				s_ftdi_imgt_controller_imagette_state <= IDLE;
				v_ftdi_imgt_controller_imagette_state := IDLE;
			end if;

			-- Output Generation --
			-- Default output generation
			controller_finished_o   <= '0';
			avm_master_wr_control_o <= c_FTDI_AVM_IMGT_MASTER_WR_CONTROL_RST;
			imgt_data_rddone_o      <= '0';
			-- Output generation FSM
			case (v_ftdi_imgt_controller_imagette_state) is

				-- state "STOPPED"
				when STOPPED =>
					-- imgt controller imagette is stopped
					-- default output signals
					null;
				-- conditional output signals

				-- state "IDLE"
				when IDLE =>
					-- imgt controller imagette is in idle
					-- default output signals
					null;
				-- conditional output signals

				-- state "BUFFER_WAITING"
				when BUFFER_WAITING =>
					-- waiting imagette data
					-- default output signals
					null;
				-- conditional output signals

				-- state "IMAGETTE_COORDINATE"
				when IMAGETTE_COORDINATE =>
					-- imagette window coordinate
					-- default output signals
					null;
					imgt_data_rddone_o <= '1';
				-- conditional output signals

				-- state "IMAGETTE_SIZE"
				when IMAGETTE_SIZE =>
					-- imagette window size
					-- default output signals
					null;
					imgt_data_rddone_o <= '1';
				-- conditional output signals

				-- state "IMAGETTE_PIXEL_0"
				when IMAGETTE_PIXEL_0 =>
					-- imagette pixel 0 data
					-- default output signals
					null;
				-- conditional output signals

				-- state "IMAGETTE_PIXEL_1"
				when IMAGETTE_PIXEL_1 =>
					-- imagette pixel 1 data
					-- default output signals
					null;
				-- conditional output signals

				-- state "AVM_WAITING"
				when AVM_WAITING =>
					-- waiting avm to be ready
					-- default output signals
					null;
				-- conditional output signals

				-- state "WRITE_START"
				when WRITE_START =>
					-- start of an avm write
					-- default output signals
					avm_master_wr_control_o.wr_req     <= '1';
					avm_master_wr_control_o.wr_address <= std_logic_vector(s_avm_wr_addr_base + s_avm_wr_addr_offset);
					avm_master_wr_control_o.wr_data    <= s_avm_wr_data;
				-- conditional output signals

				-- state "WRITE_WAITING"
				when WRITE_WAITING =>
					-- wait for avm write to finish
					-- default output signals
					null;
				-- conditional output signals

				-- state "BUFFER_READ"
				when BUFFER_READ =>
					-- read imagette data
					-- default output signals
					imgt_data_rddone_o <= '1';
				-- conditional output signals

				-- state "FINISHED"
				when FINISHED =>
					-- imgt controller imagette is finished
					-- default output signals
					controller_finished_o <= '1';
					-- conditional output signals

			end case;

		end if;
	end process p_ftdi_imgt_controller_imagette;

end architecture RTL;
