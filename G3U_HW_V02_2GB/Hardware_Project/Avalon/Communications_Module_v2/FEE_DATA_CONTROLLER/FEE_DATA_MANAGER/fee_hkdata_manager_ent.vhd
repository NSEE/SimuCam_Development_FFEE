library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fee_data_controller_pkg.all;

entity fee_hkdata_manager_ent is
    port(
        clk_i                         : in  std_logic;
        rst_i                         : in  std_logic;
        -- fee data manager inputs --
        -- general inputs
        sync_signal_i                 : in  std_logic;
        fee_clear_signal_i            : in  std_logic;
        fee_stop_signal_i             : in  std_logic;
        fee_start_signal_i            : in  std_logic;
        fee_manager_hk_only_i         : in  std_logic;
        current_frame_number_i        : in  std_logic_vector(1 downto 0);
        current_frame_counter_i       : in  std_logic_vector(15 downto 0);
        -- hk data manager parameters
        fee_logical_addr_i            : in  std_logic_vector(7 downto 0);
        fee_protocol_id_i             : in  std_logic_vector(7 downto 0);
        fee_packet_length_i           : in  std_logic_vector(15 downto 0);
        fee_fee_mode_i                : in  std_logic_vector(3 downto 0);
        fee_ccd_number_i              : in  std_logic_vector(1 downto 0);
        fee_ccd_side_i                : in  std_logic;
        -- hk data delays parameters
        fee_start_delay_i             : in  std_logic_vector(31 downto 0);
        -- housekeeping data manager control
        hkdata_manager_i              : in  t_fee_dpkt_general_control;
        -- header generator status
        header_gen_i                  : in  t_fee_dpkt_general_status;
        -- housekeeping writer status
        housekeeping_wr_i             : in  t_fee_dpkt_general_status;
        -- hk data manager outputs --
        -- general outputs
        -- housekeeping data manager status
        hkdata_manager_o              : out t_fee_dpkt_general_status;
        -- header data
        headerdata_o                  : out t_fee_dpkt_headerdata;
        -- header generator control		
        header_gen_o                  : out t_fee_dpkt_general_control;
        -- housekeeping writer control
        housekeeping_wr_o             : out t_fee_dpkt_general_control;
        housekeeping_wr_hk_type_o     : out t_comm_dpkt_hk_type;
        -- send buffer control
        send_buffer_fee_data_loaded_o : out std_logic
    );
end entity fee_hkdata_manager_ent;

architecture RTL of fee_hkdata_manager_ent is

    -- fee data manager fsm type
    type t_fee_data_manager_fsm is (
        STOPPED,
        IDLE,
        WAITING_START_DLY,
        AEB_HK_HEADER_START,
        WAITING_AEB_HK_HEADER_FINISH,
        AEB_HK_DATA_START,
        WAITING_AEB_HK_DATA_FINISH,
        DEB_HK_HEADER_START,
        WAITING_DEB_HK_HEADER_FINISH,
        DEB_HK_DATA_START,
        WAITING_DEB_HK_DATA_FINISH,
        FINISH_HKDATA_OPERATION
    );

    -- fee data manager fsm state signal
    signal s_fee_data_manager_state : t_fee_data_manager_fsm;

    -- delay signals
    signal s_delay_cnt        : unsigned((fee_start_delay_i'length - 1) downto 0);
    constant c_DELAY_FINISHED : unsigned((fee_start_delay_i'length - 1) downto 0) := (others => '0');
    signal s_delay_finished   : std_logic;

begin

    p_fee_data_manager : process(clk_i, rst_i) is
    begin
        if (rst_i = '1') then
            -- signals
            s_fee_data_manager_state             <= STOPPED;
            s_delay_cnt                          <= (others => '0');
            s_delay_finished                     <= '1';
            -- outputs
            hkdata_manager_o.finished            <= '0';
            headerdata_o.logical_address         <= (others => '0');
            headerdata_o.protocol_id             <= (others => '0');
            headerdata_o.length_field            <= (others => '0');
            headerdata_o.type_field.mode         <= (others => '0');
            headerdata_o.type_field.last_packet  <= '0';
            headerdata_o.type_field.ccd_side     <= '0';
            headerdata_o.type_field.ccd_number   <= (others => '0');
            headerdata_o.type_field.frame_number <= (others => '0');
            headerdata_o.type_field.packet_type  <= (others => '0');
            headerdata_o.frame_counter           <= (others => '0');
            headerdata_o.sequence_counter        <= (others => '0');
            header_gen_o.start                   <= '0';
            header_gen_o.reset                   <= '1';
            housekeeping_wr_o.start              <= '0';
            housekeeping_wr_hk_type_o            <= e_COMM_DPKT_DEB_HK;
            housekeeping_wr_o.reset              <= '1';
            send_buffer_fee_data_loaded_o        <= '0';
        elsif rising_edge(clk_i) then

            -- standart signal/outputs values
            hkdata_manager_o.finished            <= '0';
            headerdata_o.logical_address         <= (others => '0');
            headerdata_o.protocol_id             <= (others => '0');
            headerdata_o.length_field            <= (others => '0');
            headerdata_o.type_field.mode         <= (others => '0');
            headerdata_o.type_field.last_packet  <= '0';
            headerdata_o.type_field.ccd_side     <= '0';
            headerdata_o.type_field.ccd_number   <= (others => '0');
            headerdata_o.type_field.frame_number <= (others => '0');
            headerdata_o.type_field.packet_type  <= (others => '0');
            headerdata_o.frame_counter           <= (others => '0');
            headerdata_o.sequence_counter        <= (others => '0');
            header_gen_o.start                   <= '0';
            header_gen_o.reset                   <= '0';
            housekeeping_wr_o.start              <= '0';
            housekeeping_wr_hk_type_o            <= e_COMM_DPKT_DEB_HK;
            housekeeping_wr_o.reset              <= '0';
            send_buffer_fee_data_loaded_o        <= '0';

            case (s_fee_data_manager_state) is

                when STOPPED =>
                    -- stopped state, do nothing and reset hk data manager
                    s_fee_data_manager_state <= STOPPED;
                    -- check if a start was issued
                    if (fee_start_signal_i = '1') then
                        -- start issued, go to idle
                        s_fee_data_manager_state <= IDLE;
                    end if;

                when IDLE =>
                    -- do nothing until a sync signal is received
                    s_fee_data_manager_state <= IDLE;
                    -- check if a hk data manager start was issued
                    if (hkdata_manager_i.start = '1') then
                        -- sync signal received
                        -- go to waiting start delay
                        s_fee_data_manager_state <= WAITING_START_DLY;
                    end if;

                when WAITING_START_DLY =>
                    -- wait ultil the start delay is finished
                    s_fee_data_manager_state <= WAITING_START_DLY;
                    -- check if the start delay is finished
                    if (s_delay_finished = '1') then
                        -- start delay is finished
                        -- go to aeb hk header start
                        s_fee_data_manager_state <= AEB_HK_HEADER_START;
                    end if;

                when AEB_HK_HEADER_START =>
                    -- start the aeb hk header generation
                    s_fee_data_manager_state             <= WAITING_AEB_HK_HEADER_FINISH;
                    -- configure the hk header data
                    headerdata_o.logical_address         <= fee_logical_addr_i;
                    headerdata_o.protocol_id             <= fee_protocol_id_i;
                    headerdata_o.length_field            <= fee_packet_length_i;
                    headerdata_o.type_field.mode         <= fee_fee_mode_i;
                    headerdata_o.type_field.last_packet  <= '0';
                    if (fee_manager_hk_only_i = '1') then
                        headerdata_o.type_field.ccd_side   <= '0';
                        headerdata_o.type_field.ccd_number <= "00";
                    else
                        headerdata_o.type_field.ccd_side   <= fee_ccd_side_i;
                        headerdata_o.type_field.ccd_number <= fee_ccd_number_i;
                    end if;
                    headerdata_o.type_field.frame_number <= current_frame_number_i;
                    headerdata_o.type_field.packet_type  <= c_COMM_FFEE_AEB_HOUSEKEEPING_PACKET;
                    headerdata_o.frame_counter           <= current_frame_counter_i;
                    headerdata_o.sequence_counter        <= (others => '0');
                    -- start the header generator
                    header_gen_o.start                   <= '1';

                when WAITING_AEB_HK_HEADER_FINISH =>
                    -- wait for the aeb hk header generation to finish
                    s_fee_data_manager_state             <= WAITING_AEB_HK_HEADER_FINISH;
                    -- configure the hk header data
                    headerdata_o.logical_address         <= fee_logical_addr_i;
                    headerdata_o.protocol_id             <= fee_protocol_id_i;
                    headerdata_o.length_field            <= fee_packet_length_i;
                    headerdata_o.type_field.mode         <= fee_fee_mode_i;
                    headerdata_o.type_field.last_packet  <= '0';
                    if (fee_manager_hk_only_i = '1') then
                        headerdata_o.type_field.ccd_side   <= '0';
                        headerdata_o.type_field.ccd_number <= "00";
                    else
                        headerdata_o.type_field.ccd_side   <= fee_ccd_side_i;
                        headerdata_o.type_field.ccd_number <= fee_ccd_number_i;
                    end if;
                    headerdata_o.type_field.frame_number <= current_frame_number_i;
                    headerdata_o.type_field.packet_type  <= c_COMM_FFEE_AEB_HOUSEKEEPING_PACKET;
                    headerdata_o.frame_counter           <= current_frame_counter_i;
                    headerdata_o.sequence_counter        <= (others => '0');
                    -- check if the header generator is finished
                    if (header_gen_i.finished = '1') then
                        -- header generator finished
                        -- reset the header generator
                        header_gen_o.reset       <= '1';
                        -- go to hk data start
                        s_fee_data_manager_state <= AEB_HK_DATA_START;
                    end if;

                when AEB_HK_DATA_START =>
                    -- start the aeb hk writer
                    s_fee_data_manager_state <= WAITING_AEB_HK_DATA_FINISH;
                    -- start the hk writer
                    housekeeping_wr_o.start  <= '1';
                    -- set the aeb hk based on the ccd number
                    case (fee_ccd_number_i) is
                        when "00" =>
                            -- ccd 0 = aeb 1
                            housekeeping_wr_hk_type_o <= e_COMM_DPKT_AEB1_HK;
                        when "01" =>
                            -- ccd 1 = aeb 2 
                            housekeeping_wr_hk_type_o <= e_COMM_DPKT_AEB2_HK;
                        when "10" =>
                            -- ccd 2 = aeb 3
                            housekeeping_wr_hk_type_o <= e_COMM_DPKT_AEB3_HK;
                        when others =>
                            -- ccd 3 = aeb 4
                            housekeeping_wr_hk_type_o <= e_COMM_DPKT_AEB4_HK;
                    end case;

                when WAITING_AEB_HK_DATA_FINISH =>
                    -- wait for the aeb hk writer to finish
                    s_fee_data_manager_state <= WAITING_AEB_HK_DATA_FINISH;
                    -- check if the hk writer is finished
                    if (housekeeping_wr_i.finished = '1') then
                        -- hk writer finished
                        -- reset the hk writer
                        housekeeping_wr_o.reset       <= '1';
                        -- signal send buffer that all the current packet data is loaded
                        send_buffer_fee_data_loaded_o <= '1';
                        -- go to deb hk header start
                        s_fee_data_manager_state      <= DEB_HK_HEADER_START;
                    end if;

                when DEB_HK_HEADER_START =>
                    -- start the deb hk header generation
                    s_fee_data_manager_state             <= WAITING_DEB_HK_HEADER_FINISH;
                    -- configure the hk header data
                    headerdata_o.logical_address         <= fee_logical_addr_i;
                    headerdata_o.protocol_id             <= fee_protocol_id_i;
                    headerdata_o.length_field            <= fee_packet_length_i;
                    headerdata_o.type_field.mode         <= fee_fee_mode_i;
                    headerdata_o.type_field.last_packet  <= '0';
                    if (fee_manager_hk_only_i = '1') then
                        headerdata_o.type_field.ccd_side   <= '0';
                        headerdata_o.type_field.ccd_number <= "00";
                    else
                        headerdata_o.type_field.ccd_side   <= fee_ccd_side_i;
                        headerdata_o.type_field.ccd_number <= fee_ccd_number_i;
                    end if;
                    headerdata_o.type_field.frame_number <= current_frame_number_i;
                    headerdata_o.type_field.packet_type  <= c_COMM_FFEE_DEB_HOUSEKEEPING_PACKET;
                    headerdata_o.frame_counter           <= current_frame_counter_i;
                    headerdata_o.sequence_counter        <= (others => '0');
                    -- start the header generator
                    header_gen_o.start                   <= '1';

                when WAITING_DEB_HK_HEADER_FINISH =>
                    -- wait for the deb hk header generation to finish
                    s_fee_data_manager_state             <= WAITING_DEB_HK_HEADER_FINISH;
                    -- configure the hk header data
                    headerdata_o.logical_address         <= fee_logical_addr_i;
                    headerdata_o.protocol_id             <= fee_protocol_id_i;
                    headerdata_o.length_field            <= fee_packet_length_i;
                    headerdata_o.type_field.mode         <= fee_fee_mode_i;
                    headerdata_o.type_field.last_packet  <= '0';
                    if (fee_manager_hk_only_i = '1') then
                        headerdata_o.type_field.ccd_side   <= '0';
                        headerdata_o.type_field.ccd_number <= "00";
                    else
                        headerdata_o.type_field.ccd_side   <= fee_ccd_side_i;
                        headerdata_o.type_field.ccd_number <= fee_ccd_number_i;
                    end if;
                    headerdata_o.type_field.frame_number <= current_frame_number_i;
                    headerdata_o.type_field.packet_type  <= c_COMM_FFEE_DEB_HOUSEKEEPING_PACKET;
                    headerdata_o.frame_counter           <= current_frame_counter_i;
                    headerdata_o.sequence_counter        <= (others => '0');
                    -- check if the header generator is finished
                    if (header_gen_i.finished = '1') then
                        -- header generator finished
                        -- reset the header generator
                        header_gen_o.reset       <= '1';
                        -- go to hk data start
                        s_fee_data_manager_state <= DEB_HK_DATA_START;
                    end if;

                when DEB_HK_DATA_START =>
                    -- start the deb hk writer
                    s_fee_data_manager_state  <= WAITING_DEB_HK_DATA_FINISH;
                    -- start the hk writer
                    housekeeping_wr_o.start   <= '1';
                    housekeeping_wr_hk_type_o <= e_COMM_DPKT_DEB_HK;

                when WAITING_DEB_HK_DATA_FINISH =>
                    -- wait for the deb hk writer to finish
                    s_fee_data_manager_state <= WAITING_DEB_HK_DATA_FINISH;
                    -- check if the hk writer is finished
                    if (housekeeping_wr_i.finished = '1') then
                        -- hk writer finished
                        -- reset the hk writer
                        housekeeping_wr_o.reset       <= '1';
                        -- signal send buffer that all the current packet data is loaded
                        send_buffer_fee_data_loaded_o <= '1';
                        -- last packet, finish operation
                        s_fee_data_manager_state      <= FINISH_HKDATA_OPERATION;
                    end if;

                when FINISH_HKDATA_OPERATION =>
                    -- finish the fee operation
                    hkdata_manager_o.finished <= '1';
                    -- return to idle to wait another start
                    s_fee_data_manager_state  <= IDLE;

            end case;

            -- check if a stop was issued
            if (fee_stop_signal_i = '1') then
                -- stop issued, go to stopped
                s_fee_data_manager_state <= STOPPED;
            end if;

            -- start delay management --
            -- check if a sync signal was received
            if (sync_signal_i = '1') then
                -- a sync signal was received
                -- set start delay counter
                if (fee_start_delay_i /= std_logic_vector(c_DELAY_FINISHED)) then
                    s_delay_cnt <= unsigned(fee_start_delay_i) - 1;
                else
                    s_delay_cnt <= (others => '0');
                end if;
                -- clear delay finished flag
                s_delay_finished <= '0';
            else
                -- a sync signal was not received
                -- check if the start delay ended
                if (s_delay_cnt = c_DELAY_FINISHED) then
                    -- start delay ended
                    -- clear delay counter
                    s_delay_cnt      <= (others => '0');
                    -- set delay finished flag
                    s_delay_finished <= '1';
                else
                    -- start delay not ended
                    -- decrement delay counter
                    s_delay_cnt      <= s_delay_cnt - 1;
                    -- clear delay finished flag
                    s_delay_finished <= '0';
                end if;
            end if;

        end if;
    end process p_fee_data_manager;

end architecture RTL;
