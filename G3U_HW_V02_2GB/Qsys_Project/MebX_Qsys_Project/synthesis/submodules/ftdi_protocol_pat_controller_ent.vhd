library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ftdi_protocol_pkg.all;

entity ftdi_protocol_pat_controller_ent is
    generic(
        g_DELAY_TIMEOUT_CLKDIV : natural range 0 to 65535 := 49999 -- [100 MHz / 50000 = 2 kHz = 0,5 ms]
    );
    port(
        clk_i                              : in  std_logic;
        rst_i                              : in  std_logic;
        data_stop_i                        : in  std_logic;
        data_start_i                       : in  std_logic;
        contoller_hold_i                   : in  std_logic;
        contoller_release_i                : in  std_logic;
        recpt_imgt_enable_i                : in  std_logic;
        recpt_imgt_reception_timeout_i     : in  std_logic_vector(15 downto 0);
        recpt_imgt_reception_i             : in  std_logic;
        recpt_imgt_abort_reception_i       : in  std_logic;
        header_generator_busy_i            : in  std_logic;
        header_parser_busy_i               : in  std_logic;
        header_parser_data_i               : in  t_ftdi_prot_header_fields;
        header_parser_crc32_match_i        : in  std_logic;
        header_parser_eoh_error_i          : in  std_logic;
        payload_reader_busy_i              : in  std_logic;
        payload_reader_crc32_match_i       : in  std_logic;
        payload_reader_eop_error_i         : in  std_logic;
        controller_started_o               : out std_logic;
        controller_finished_o              : out std_logic;
        patch_rcpt_err_state_o             : out std_logic;
        patch_rcpt_err_code_o              : out std_logic_vector(7 downto 0);
        patch_rcpt_nack_err_o              : out std_logic;
        patch_rcpt_wrong_header_crc_err_o  : out std_logic;
        patch_rcpt_end_of_header_err_o     : out std_logic;
        patch_rcpt_wrong_payload_crc_err_o : out std_logic;
        patch_rcpt_end_of_payload_err_o    : out std_logic;
        patch_rcpt_maximum_tries_err_o     : out std_logic;
        patch_rcpt_timeout_err_o           : out std_logic;
        header_generator_abort_o           : out std_logic;
        header_generator_start_o           : out std_logic;
        header_generator_reset_o           : out std_logic;
        header_generator_data_o            : out t_ftdi_prot_header_fields;
        header_parser_abort_o              : out std_logic;
        header_parser_start_o              : out std_logic;
        header_parser_reset_o              : out std_logic;
        payload_reader_abort_o             : out std_logic;
        payload_reader_start_o             : out std_logic;
        payload_reader_reset_o             : out std_logic;
        payload_reader_enabled_o           : out std_logic;
        payload_reader_length_bytes_o      : out std_logic_vector(31 downto 0);
        imgt_controller_start_o            : out std_logic;
        imgt_controller_discard_o          : out std_logic
    );
end entity ftdi_protocol_pat_controller_ent;

architecture RTL of ftdi_protocol_pat_controller_ent is

    type t_ftdi_prot_pat_controller_fsm is (
        STOPPED,                        -- protocol controller stopped
        IDLE,                           -- protocol controller idle
        IMGT_RCPT_START,                -- imagette reception start
        IMGT_REPLY_RECEIVE_RX_HEADER,   -- imagette reception receive reply header
        IMGT_REPLY_WAIT_RX_HEADER,      -- imagette reception wait reply header
        IMGT_REPLY_PARSE_RX_HEADER,     -- imagette reception parse reply header
        IMGT_ACK_SEND_TX_HEADER,        -- imagette reception transmit reply ack 
        IMGT_ACK_WAIT_TX_HEADER,        -- imagette reception wait reply ack
        IMGT_ACK_RESET_TX_HEADER,       -- imagette reception reset reply ack
        IMGT_NACK_SEND_TX_HEADER,       -- imagette reception transmit reply nack 
        IMGT_NACK_WAIT_TX_HEADER,       -- imagette reception wait reply nack
        IMGT_NACK_RESET_TX_HEADER,      -- imagette reception reset reply nack
        IMGT_REPLY_RECEIVE_RX_PAYLOAD,  -- imagette reception receive reply payload
        IMGT_REPLY_WAIT_RX_PAYLOAD,     -- imagette reception wait reply payload
        IMGT_REPLY_PARSE_RX_PAYLOAD,    -- imagette reception parse reply payload
        IMGT_ACK_SEND_TX_PAYLOAD,       -- imagette reception transmit payload ack
        IMGT_ACK_WAIT_TX_PAYLOAD,       -- imagette reception wait payload ack
        IMGT_ACK_RESET_TX_PAYLOAD,      -- imagette reception reset payload ack
        IMGT_NACK_SEND_TX_PAYLOAD,      -- imagette reception transmit payload nack
        IMGT_NACK_WAIT_TX_PAYLOAD,      -- imagette reception wait payload nack
        IMGT_NACK_RESET_TX_PAYLOAD,     -- imagette reception reset payload nack
        IMGT_RCPT_FINISH,               -- imagette reception finish
        CONTROLLER_ON_HOLD              -- protocol controller is on hold
    );
    signal s_ftdi_prot_pat_controller_state : t_ftdi_prot_pat_controller_fsm;

    signal s_registered_reception_data : t_ftdi_prot_header_fields;
    signal s_parsed_reply_header_data  : t_ftdi_prot_header_fields;

    signal s_reception_tries : natural range 0 to 3;

    signal s_err_imgt_reception_nack_err    : std_logic;
    signal s_err_imgt_reply_header_crc_err  : std_logic;
    signal s_err_imgt_reply_eoh_err         : std_logic;
    signal s_err_imgt_reply_payload_crc_err : std_logic;
    signal s_err_imgt_reply_eop_err         : std_logic;
    signal s_err_imgt_req_max_tries_err     : std_logic;
    signal s_err_imgt_reply_ccd_size_err    : std_logic;
    signal s_err_imgt_req_timeout_err       : std_logic;

    signal s_timeout_delay_clear    : std_logic;
    signal s_timeout_delay_trigger  : std_logic;
    signal s_timeout_delay_timer    : std_logic_vector(15 downto 0);
    signal s_timeout_delay_busy     : std_logic;
    signal s_timeout_delay_finished : std_logic;

    signal s_registered_abort : std_logic;

begin

    timeout_delay_block_ent_inst : entity work.delay_block_ent
        generic map(
            g_CLKDIV      => std_logic_vector(to_unsigned(g_DELAY_TIMEOUT_CLKDIV, 16)),
            g_TIMER_WIDTH => s_timeout_delay_timer'length
        )
        port map(
            clk_i            => clk_i,
            rst_i            => rst_i,
            clr_i            => s_timeout_delay_clear,
            delay_trigger_i  => s_timeout_delay_trigger,
            delay_timer_i    => s_timeout_delay_timer,
            delay_busy_o     => s_timeout_delay_busy,
            delay_finished_o => s_timeout_delay_finished
        );

    p_ftdi_protocol_controller : process(clk_i, rst_i) is
        variable v_ftdi_prot_pat_controller_state : t_ftdi_prot_pat_controller_fsm := STOPPED;
    begin
        if (rst_i = '1') then
            -- fsm state reset
            s_ftdi_prot_pat_controller_state <= STOPPED;
            v_ftdi_prot_pat_controller_state := STOPPED;
            -- internal signals reset
            s_registered_reception_data      <= c_FTDI_PROT_HEADER_RESET;
            s_parsed_reply_header_data       <= c_FTDI_PROT_HEADER_RESET;
            s_reception_tries                <= 0;
            s_err_imgt_reception_nack_err    <= '0';
            s_err_imgt_reply_header_crc_err  <= '0';
            s_err_imgt_reply_eoh_err         <= '0';
            s_err_imgt_reply_payload_crc_err <= '0';
            s_err_imgt_reply_eop_err         <= '0';
            s_err_imgt_req_max_tries_err     <= '0';
            s_err_imgt_reply_ccd_size_err    <= '0';
            s_err_imgt_req_timeout_err       <= '0';
            s_timeout_delay_clear            <= '0';
            s_timeout_delay_trigger          <= '0';
            s_timeout_delay_timer            <= (others => '0');
            s_registered_abort               <= '0';
            -- outputs reset
            controller_started_o             <= '0';
            controller_finished_o            <= '0';
            header_generator_abort_o         <= '0';
            header_generator_start_o         <= '0';
            header_generator_reset_o         <= '0';
            header_generator_data_o          <= c_FTDI_PROT_HEADER_RESET;
            header_parser_abort_o            <= '0';
            header_parser_start_o            <= '0';
            header_parser_reset_o            <= '0';
            payload_reader_abort_o           <= '0';
            payload_reader_start_o           <= '0';
            payload_reader_reset_o           <= '0';
            payload_reader_enabled_o         <= '0';
            payload_reader_length_bytes_o    <= (others => '0');
            imgt_controller_start_o          <= '0';
            imgt_controller_discard_o        <= '0';
        elsif rising_edge(clk_i) then

            -- States transitions FSM
            case (s_ftdi_prot_pat_controller_state) is

                -- state "STOPPED"
                when STOPPED =>
                    -- protocol controller stopped
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= STOPPED;
                    v_ftdi_prot_pat_controller_state := STOPPED;
                    -- default internal signal values
                    s_registered_reception_data      <= c_FTDI_PROT_HEADER_RESET;
                    s_parsed_reply_header_data       <= c_FTDI_PROT_HEADER_RESET;
                    s_reception_tries                <= 0;
                    s_err_imgt_reception_nack_err    <= '0';
                    s_err_imgt_reply_header_crc_err  <= '0';
                    s_err_imgt_reply_eoh_err         <= '0';
                    s_err_imgt_reply_payload_crc_err <= '0';
                    s_err_imgt_reply_eop_err         <= '0';
                    s_err_imgt_req_max_tries_err     <= '0';
                    s_err_imgt_reply_ccd_size_err    <= '0';
                    s_err_imgt_req_timeout_err       <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                    s_timeout_delay_clear            <= '0';
                    s_registered_abort               <= '0';
                    -- conditional state transition
                    -- check if a start command was issued
                    if (data_start_i = '1') then
                        s_ftdi_prot_pat_controller_state <= IDLE;
                        v_ftdi_prot_pat_controller_state := IDLE;
                    end if;

                -- state "IDLE"
                when IDLE =>
                    -- protocol controller idle
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IDLE;
                    v_ftdi_prot_pat_controller_state := IDLE;
                    -- default internal signal values
                    s_registered_reception_data      <= c_FTDI_PROT_HEADER_RESET;
                    s_parsed_reply_header_data       <= c_FTDI_PROT_HEADER_RESET;
                    s_reception_tries                <= 0;
                    s_err_imgt_reception_nack_err    <= '0';
                    s_err_imgt_reply_header_crc_err  <= '0';
                    s_err_imgt_reply_eoh_err         <= '0';
                    s_err_imgt_reply_payload_crc_err <= '0';
                    s_err_imgt_reply_eop_err         <= '0';
                    s_err_imgt_req_max_tries_err     <= '0';
                    s_err_imgt_reply_ccd_size_err    <= '0';
                    s_err_imgt_req_timeout_err       <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                    s_timeout_delay_clear            <= '0';
                    s_registered_abort               <= '0';
                    -- conditional state transition
                    -- check if a imagette transmission was issued
                    if (recpt_imgt_reception_i = '1') then
                        s_ftdi_prot_pat_controller_state <= IMGT_RCPT_START;
                        v_ftdi_prot_pat_controller_state := IMGT_RCPT_START;
                        -- check if a timeout was requestioned
                        if (recpt_imgt_reception_timeout_i /= std_logic_vector(to_unsigned(0, recpt_imgt_reception_timeout_i'length))) then
                            s_timeout_delay_trigger <= '1';
                            s_timeout_delay_timer   <= recpt_imgt_reception_timeout_i;
                        end if;
                    -- check if a controller hold was requestioned
                    elsif (contoller_hold_i = '1') then
                        -- a controller hold was requestioned, go to controller on hold
                        s_ftdi_prot_pat_controller_state <= CONTROLLER_ON_HOLD;
                        v_ftdi_prot_pat_controller_state := CONTROLLER_ON_HOLD;
                    end if;

                -- state "IMGT_RCPT_START"
                when IMGT_RCPT_START =>
                    -- imagette reception start
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_REPLY_RECEIVE_RX_HEADER;
                    v_ftdi_prot_pat_controller_state := IMGT_REPLY_RECEIVE_RX_HEADER;
                    -- default internal signal values
                    s_reception_tries                <= 2;
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                -- conditional state transition

                -- state "IMGT_REPLY_RECEIVE_RX_HEADER"
                when IMGT_REPLY_RECEIVE_RX_HEADER =>
                    -- imagette reception receive reply header
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_REPLY_WAIT_RX_HEADER;
                    v_ftdi_prot_pat_controller_state := IMGT_REPLY_WAIT_RX_HEADER;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                -- conditional state transition

                -- state "IMGT_REPLY_WAIT_RX_HEADER"
                when IMGT_REPLY_WAIT_RX_HEADER =>
                    -- imagette reception wait reply header
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_REPLY_WAIT_RX_HEADER;
                    v_ftdi_prot_pat_controller_state := IMGT_REPLY_WAIT_RX_HEADER;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                    -- conditional state transition
                    -- check if the receival of the reception reply is finished
                    if (header_parser_busy_i = '0') then
                        s_ftdi_prot_pat_controller_state <= IMGT_REPLY_PARSE_RX_HEADER;
                        v_ftdi_prot_pat_controller_state := IMGT_REPLY_PARSE_RX_HEADER;
                    end if;

                -- state "IMGT_REPLY_PARSE_RX_HEADER"
                when IMGT_REPLY_PARSE_RX_HEADER =>
                    -- imagette reception parse reply header
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_RCPT_FINISH;
                    v_ftdi_prot_pat_controller_state := IMGT_RCPT_FINISH;
                    -- default internal signal values
                    s_reception_tries                <= 3;
                    s_parsed_reply_header_data       <= header_parser_data_i;
                    s_err_imgt_reply_header_crc_err  <= '0';
                    s_err_imgt_reply_eoh_err         <= '0';
                    s_err_imgt_reply_ccd_size_err    <= '0';
                    s_timeout_delay_clear            <= '1';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                    -- conditional state transition
                    -- check if an abort command was not received
                    if (s_registered_abort = '0') then
                        -- an abort command was not received, normal operation
                        -- check if a complete header arrived and the CRC matched
                        if ((header_parser_eoh_error_i = '0') and (header_parser_crc32_match_i = '1')) then
                            -- CRC matched and End of Header error not ocurred, package is reliable
                            -- check if a Half-CCD Reply was received
                            if (header_parser_data_i.package_id = c_FTDI_PROT_PKG_ID_IMAGETTE_TRANSMISSION) then
                                -- Half-CCD Reply received
                                --                                -- send a ACK
                                --                                s_ftdi_prot_pat_controller_state <= IMGT_ACK_SEND_TX_HEADER;
                                --                                v_ftdi_prot_pat_controller_state := IMGT_ACK_SEND_TX_HEADER;
                                -- no need to send ACK, go to ack reset tx header
                                s_ftdi_prot_pat_controller_state <= IMGT_ACK_RESET_TX_HEADER;
                                v_ftdi_prot_pat_controller_state := IMGT_ACK_RESET_TX_HEADER;
                                s_timeout_delay_clear            <= '0';
                            -- check if a Wrong Image Size was received
                            elsif (header_parser_data_i.package_id = c_FTDI_PROT_PKG_ID_WRONG_IMG_SIZE) then
                                -- Wrong Image Size received
                                -- send a NACK
                                s_ftdi_prot_pat_controller_state <= IMGT_NACK_SEND_TX_HEADER;
                                v_ftdi_prot_pat_controller_state := IMGT_NACK_SEND_TX_HEADER;
                                s_reception_tries                <= s_reception_tries - 1;
                                s_err_imgt_reply_ccd_size_err    <= '1';
                                s_timeout_delay_clear            <= '0';
                            else
                                -- Unknown package received
                                -- send a NACK
                                s_ftdi_prot_pat_controller_state <= IMGT_NACK_SEND_TX_HEADER;
                                v_ftdi_prot_pat_controller_state := IMGT_NACK_SEND_TX_HEADER;
                                s_reception_tries                <= s_reception_tries - 1;
                                s_timeout_delay_clear            <= '0';
                            end if;
                        else
                            -- send a NACK
                            s_ftdi_prot_pat_controller_state <= IMGT_NACK_SEND_TX_HEADER;
                            v_ftdi_prot_pat_controller_state := IMGT_NACK_SEND_TX_HEADER;
                            s_reception_tries                <= s_reception_tries - 1;
                            s_err_imgt_reply_header_crc_err  <= not (header_parser_crc32_match_i);
                            s_err_imgt_reply_eoh_err         <= header_parser_eoh_error_i;
                            s_timeout_delay_clear            <= '0';
                        end if;
                    end if;

                -- state "IMGT_ACK_SEND_TX_HEADER"
                when IMGT_ACK_SEND_TX_HEADER =>
                    -- imagette reception transmit reply ack
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_ACK_WAIT_TX_HEADER;
                    v_ftdi_prot_pat_controller_state := IMGT_ACK_WAIT_TX_HEADER;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                -- conditional state transition

                -- state "IMGT_ACK_WAIT_TX_HEADER"
                when IMGT_ACK_WAIT_TX_HEADER =>
                    -- imagette reception wait reply ack
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_ACK_WAIT_TX_HEADER;
                    v_ftdi_prot_pat_controller_state := IMGT_ACK_WAIT_TX_HEADER;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                    -- conditional state transition
                    -- check if the reception of the reply ack/nack is finished
                    if (header_generator_busy_i = '0') then
                        s_ftdi_prot_pat_controller_state <= IMGT_ACK_RESET_TX_HEADER;
                        v_ftdi_prot_pat_controller_state := IMGT_ACK_RESET_TX_HEADER;
                    end if;

                -- state "IMGT_ACK_RESET_TX_HEADER"
                when IMGT_ACK_RESET_TX_HEADER =>
                    -- imagette reception reset reply ack
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_REPLY_RECEIVE_RX_PAYLOAD;
                    v_ftdi_prot_pat_controller_state := IMGT_REPLY_RECEIVE_RX_PAYLOAD;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                -- conditional state transition

                -- state "IMGT_NACK_SEND_TX_HEADER"
                when IMGT_NACK_SEND_TX_HEADER =>
                    -- imagette reception transmit reply nack
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_NACK_WAIT_TX_HEADER;
                    v_ftdi_prot_pat_controller_state := IMGT_NACK_WAIT_TX_HEADER;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                -- conditional state transition

                -- state "IMGT_NACK_WAIT_TX_HEADER"
                when IMGT_NACK_WAIT_TX_HEADER =>
                    -- imagette reception wait reply nack
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_NACK_WAIT_TX_HEADER;
                    v_ftdi_prot_pat_controller_state := IMGT_NACK_WAIT_TX_HEADER;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                    -- conditional state transition
                    -- check if the reception of the reply ack/nack is finished
                    if (header_generator_busy_i = '0') then
                        s_ftdi_prot_pat_controller_state <= IMGT_NACK_RESET_TX_HEADER;
                        v_ftdi_prot_pat_controller_state := IMGT_NACK_RESET_TX_HEADER;
                    end if;

                -- state "IMGT_NACK_RESET_TX_HEADER"
                when IMGT_NACK_RESET_TX_HEADER =>
                    -- imagette reception reset reply nack
                    -- default state transition
                    --                    s_ftdi_prot_pat_controller_state <= IMGT_REPLY_RECEIVE_RX_HEADER;
                    --                    v_ftdi_prot_pat_controller_state := IMGT_REPLY_RECEIVE_RX_HEADER;
                    s_ftdi_prot_pat_controller_state <= IMGT_RCPT_FINISH;
                    v_ftdi_prot_pat_controller_state := IMGT_RCPT_FINISH;
                    -- default internal signal values
                    s_err_imgt_req_max_tries_err     <= '0';
                    s_timeout_delay_clear            <= '1';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                -- conditional state transition
                --                    -- check if the number of requiest tries ended
                --                    if (s_reception_tries = 0) then
                --                        -- no more tries, go to finish
                --                        s_ftdi_prot_pat_controller_state <= IMGT_RCPT_FINISH;
                --                        v_ftdi_prot_pat_controller_state := IMGT_RCPT_FINISH;
                --                        s_err_imgt_req_max_tries_err     <= '1';
                --                        s_timeout_delay_clear            <= '1';
                --                    end if;

                -- state "IMGT_REPLY_RECEIVE_RX_PAYLOAD"
                when IMGT_REPLY_RECEIVE_RX_PAYLOAD =>
                    -- imagette reception receive reply payload
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_REPLY_WAIT_RX_PAYLOAD;
                    v_ftdi_prot_pat_controller_state := IMGT_REPLY_WAIT_RX_PAYLOAD;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                -- conditional state transition

                -- state "IMGT_REPLY_WAIT_RX_PAYLOAD"
                when IMGT_REPLY_WAIT_RX_PAYLOAD =>
                    -- imagette reception wait reply payload
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_REPLY_WAIT_RX_PAYLOAD;
                    v_ftdi_prot_pat_controller_state := IMGT_REPLY_WAIT_RX_PAYLOAD;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                    -- conditional state transition
                    -- check if the receival of the reply payload is finished
                    if (payload_reader_busy_i = '0') then
                        s_ftdi_prot_pat_controller_state <= IMGT_REPLY_PARSE_RX_PAYLOAD;
                        v_ftdi_prot_pat_controller_state := IMGT_REPLY_PARSE_RX_PAYLOAD;
                    end if;

                -- state "IMGT_REPLY_PARSE_RX_PAYLOAD"
                when IMGT_REPLY_PARSE_RX_PAYLOAD =>
                    -- imagette reception parse reply payload
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_ACK_SEND_TX_PAYLOAD;
                    v_ftdi_prot_pat_controller_state := IMGT_ACK_SEND_TX_PAYLOAD;
                    -- default internal signal values
                    s_err_imgt_reply_payload_crc_err <= '0';
                    s_err_imgt_reply_eop_err         <= '0';
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                    -- conditional state transition
                    -- check if an abort command was not received
                    if (s_registered_abort = '0') then
                        -- an abort command was not received, normal operation
                        -- check if a full package arrived and the CRC matched
                        if ((payload_reader_eop_error_i = '0') and (payload_reader_crc32_match_i = '1')) then
                            -- send an ACK
                            s_ftdi_prot_pat_controller_state <= IMGT_ACK_SEND_TX_PAYLOAD;
                            v_ftdi_prot_pat_controller_state := IMGT_ACK_SEND_TX_PAYLOAD;
                        else
                            -- send a NACK
                            s_ftdi_prot_pat_controller_state <= IMGT_NACK_SEND_TX_PAYLOAD;
                            v_ftdi_prot_pat_controller_state := IMGT_NACK_SEND_TX_PAYLOAD;
                            -- get errors flags
                            s_err_imgt_reply_payload_crc_err <= not (payload_reader_crc32_match_i);
                            s_err_imgt_reply_eop_err         <= payload_reader_eop_error_i;
                        end if;
                    else
                        -- an abort command was received, send nack
                        -- send a NACK
                        s_ftdi_prot_pat_controller_state <= IMGT_NACK_SEND_TX_PAYLOAD;
                        v_ftdi_prot_pat_controller_state := IMGT_NACK_SEND_TX_PAYLOAD;
                    end if;

                -- state "IMGT_ACK_SEND_TX_PAYLOAD"
                when IMGT_ACK_SEND_TX_PAYLOAD =>
                    -- imagette reception transmit payload ack
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_ACK_WAIT_TX_PAYLOAD;
                    v_ftdi_prot_pat_controller_state := IMGT_ACK_WAIT_TX_PAYLOAD;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                -- conditional state transition

                -- state "IMGT_ACK_WAIT_TX_PAYLOAD"
                when IMGT_ACK_WAIT_TX_PAYLOAD =>
                    -- imagette reception wait payload ack
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_ACK_WAIT_TX_PAYLOAD;
                    v_ftdi_prot_pat_controller_state := IMGT_ACK_WAIT_TX_PAYLOAD;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                    -- conditional state transition
                    -- check if the reception of the payload ack/nack is finished
                    if (header_generator_busy_i = '0') then
                        s_ftdi_prot_pat_controller_state <= IMGT_ACK_RESET_TX_PAYLOAD;
                        v_ftdi_prot_pat_controller_state := IMGT_ACK_RESET_TX_PAYLOAD;
                    end if;

                -- state "IMGT_ACK_RESET_TX_PAYLOAD"
                when IMGT_ACK_RESET_TX_PAYLOAD =>
                    -- imagette reception reset payload ack
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_RCPT_FINISH;
                    v_ftdi_prot_pat_controller_state := IMGT_RCPT_FINISH;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '1';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                -- conditional state transition

                -- state "IMGT_NACK_SEND_TX_PAYLOAD"
                when IMGT_NACK_SEND_TX_PAYLOAD =>
                    -- imagette reception transmit payload nack
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_NACK_WAIT_TX_PAYLOAD;
                    v_ftdi_prot_pat_controller_state := IMGT_NACK_WAIT_TX_PAYLOAD;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                -- conditional state transition

                -- state "IMGT_NACK_WAIT_TX_PAYLOAD"
                when IMGT_NACK_WAIT_TX_PAYLOAD =>
                    -- imagette reception wait payload nack
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_NACK_WAIT_TX_PAYLOAD;
                    v_ftdi_prot_pat_controller_state := IMGT_NACK_WAIT_TX_PAYLOAD;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                    -- conditional state transition
                    -- check if the reception of the payload ack/nack is finished
                    if (header_generator_busy_i = '0') then
                        s_ftdi_prot_pat_controller_state <= IMGT_NACK_RESET_TX_PAYLOAD;
                        v_ftdi_prot_pat_controller_state := IMGT_NACK_RESET_TX_PAYLOAD;
                    end if;

                -- state "IMGT_NACK_RESET_TX_PAYLOAD"
                when IMGT_NACK_RESET_TX_PAYLOAD =>
                    -- imagette reception reset payload nack
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IMGT_RCPT_FINISH;
                    v_ftdi_prot_pat_controller_state := IMGT_RCPT_FINISH;
                    -- default internal signal values
                    s_timeout_delay_clear            <= '1';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                -- conditional state transition

                -- state "IMGT_RCPT_FINISH"
                when IMGT_RCPT_FINISH =>
                    -- imagette reception finish
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= IDLE;
                    v_ftdi_prot_pat_controller_state := IDLE;
                    -- default internal signal values
                    s_reception_tries                <= 0;
                    s_timeout_delay_clear            <= '1';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                    s_registered_abort               <= '0';
                -- conditional state transition

                -- state "CONTROLLER_ON_HOLD"
                when CONTROLLER_ON_HOLD =>
                    -- protocol controller is on hold
                    -- default state transition
                    s_ftdi_prot_pat_controller_state <= CONTROLLER_ON_HOLD;
                    v_ftdi_prot_pat_controller_state := CONTROLLER_ON_HOLD;
                    -- default internal signal values
                    s_parsed_reply_header_data       <= c_FTDI_PROT_HEADER_RESET;
                    s_reception_tries                <= 0;
                    s_err_imgt_reception_nack_err    <= '0';
                    s_err_imgt_reply_header_crc_err  <= '0';
                    s_err_imgt_reply_eoh_err         <= '0';
                    s_err_imgt_reply_payload_crc_err <= '0';
                    s_err_imgt_reply_eop_err         <= '0';
                    s_err_imgt_req_max_tries_err     <= '0';
                    s_err_imgt_reply_ccd_size_err    <= '0';
                    s_err_imgt_req_timeout_err       <= '0';
                    s_timeout_delay_trigger          <= '0';
                    s_timeout_delay_timer            <= (others => '0');
                    s_timeout_delay_clear            <= '0';
                    s_registered_abort               <= '0';
                    -- conditional state transition
                    -- check if an abort command was received
                    if (s_registered_abort = '1') then
                        -- an abort command was received, go to finish
                        s_ftdi_prot_pat_controller_state <= IMGT_RCPT_FINISH;
                        v_ftdi_prot_pat_controller_state := IMGT_RCPT_FINISH;
                    -- check if a controller release was issued
                    elsif (contoller_release_i = '1') then
                        -- release the controller, return to idle
                        s_ftdi_prot_pat_controller_state <= IDLE;
                        v_ftdi_prot_pat_controller_state := IDLE;
                    end if;

                -- all the other states (not defined)
                when others =>
                    s_ftdi_prot_pat_controller_state <= STOPPED;
                    v_ftdi_prot_pat_controller_state := STOPPED;

            end case;

            -- check if a stop command was received
            if (data_stop_i = '1') then
                s_ftdi_prot_pat_controller_state <= STOPPED;
                v_ftdi_prot_pat_controller_state := STOPPED;
                s_timeout_delay_clear            <= '1';
            -- check if an abort command was received
            elsif (recpt_imgt_abort_reception_i = '1') then
                -- register an abort command
                s_registered_abort    <= '1';
                -- clear the timeout delay
                s_timeout_delay_clear <= '1';
            -- check if the timeout delay is finished	
            elsif (s_timeout_delay_finished = '1') then
                -- the timeout delay is finished
                -- register an abort command
                s_registered_abort         <= '1';
                -- set the timeout error flag
                s_err_imgt_req_timeout_err <= '1';
            end if;

            -- Output Generation --
            -- Default output generation
            controller_started_o          <= '0';
            controller_finished_o         <= '0';
            header_generator_abort_o      <= '0';
            header_generator_start_o      <= '0';
            header_generator_reset_o      <= '0';
            header_generator_data_o       <= c_FTDI_PROT_HEADER_RESET;
            header_parser_abort_o         <= '0';
            header_parser_start_o         <= '0';
            header_parser_reset_o         <= '0';
            payload_reader_abort_o        <= '0';
            payload_reader_start_o        <= '0';
            payload_reader_reset_o        <= '0';
            payload_reader_enabled_o      <= '0';
            payload_reader_length_bytes_o <= (others => '0');
            imgt_controller_start_o       <= '0';
            imgt_controller_discard_o     <= '0';
            -- Output generation FSM
            case (v_ftdi_prot_pat_controller_state) is

                -- state "STOPPED"
                when STOPPED =>
                    -- protocol controller stopped
                    -- default output signals
                    null;
                -- conditional output signals

                -- state "IDLE"
                when IDLE =>
                    -- protocol controller idle
                    -- default output signals
                    null;
                -- conditional output signals

                -- state "IMGT_RCPT_START"
                when IMGT_RCPT_START =>
                    -- imagette reception start
                    -- default output signals
                    controller_started_o      <= '1';
                    header_generator_abort_o  <= s_registered_abort;
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_REPLY_RECEIVE_RX_HEADER"
                when IMGT_REPLY_RECEIVE_RX_HEADER =>
                    -- imagette reception receive reply header
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_parser_abort_o     <= s_registered_abort;
                    header_parser_start_o     <= '1';
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_REPLY_WAIT_RX_HEADER"
                when IMGT_REPLY_WAIT_RX_HEADER =>
                    -- imagette reception wait reply header
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_REPLY_PARSE_RX_HEADER"
                when IMGT_REPLY_PARSE_RX_HEADER =>
                    -- imagette reception parse reply header
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_parser_abort_o     <= s_registered_abort;
                    header_parser_reset_o     <= '1';
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_ACK_SEND_TX_HEADER"
                when IMGT_ACK_SEND_TX_HEADER =>
                    -- imagette reception transmit reply ack
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_generator_start_o  <= '1';
                    header_generator_data_o   <= c_FTDI_PROT_HEADER_ACK_OK;
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_ACK_WAIT_TX_HEADER"
                when IMGT_ACK_WAIT_TX_HEADER =>
                    -- imagette reception wait reply ack
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_ACK_RESET_TX_HEADER"
                when IMGT_ACK_RESET_TX_HEADER =>
                    -- imagette reception reset reply ack
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    --                    header_generator_reset_o  <= '1';
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_start_o   <= '1';
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_NACK_SEND_TX_HEADER"
                when IMGT_NACK_SEND_TX_HEADER =>
                    -- imagette reception transmit reply nack
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_generator_start_o  <= '1';
                    header_generator_data_o   <= c_FTDI_PROT_HEADER_NACK_ERROR;
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_NACK_WAIT_TX_HEADER"
                when IMGT_NACK_WAIT_TX_HEADER =>
                    -- imagette reception wait reply nack
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_NACK_RESET_TX_HEADER"
                when IMGT_NACK_RESET_TX_HEADER =>
                    -- imagette reception reset reply nack
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_generator_reset_o  <= '1';
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_REPLY_RECEIVE_RX_PAYLOAD"
                when IMGT_REPLY_RECEIVE_RX_PAYLOAD =>
                    -- imagette reception receive reply payload
                    -- default output signals
                    header_generator_abort_o      <= s_registered_abort;
                    header_parser_abort_o         <= s_registered_abort;
                    payload_reader_abort_o        <= s_registered_abort;
                    payload_reader_start_o        <= '1';
                    payload_reader_enabled_o      <= recpt_imgt_enable_i;
                    payload_reader_length_bytes_o <= s_parsed_reply_header_data.payload_length;
                    imgt_controller_discard_o     <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_REPLY_WAIT_RX_PAYLOAD"
                when IMGT_REPLY_WAIT_RX_PAYLOAD =>
                    -- imagette reception wait reply payload
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_REPLY_PARSE_RX_PAYLOAD"
                when IMGT_REPLY_PARSE_RX_PAYLOAD =>
                    -- imagette reception parse reply payload
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    payload_reader_reset_o    <= '1';
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_ACK_SEND_TX_PAYLOAD"
                when IMGT_ACK_SEND_TX_PAYLOAD =>
                    -- imagette reception transmit payload ack
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_generator_start_o  <= '1';
                    header_generator_data_o   <= c_FTDI_PROT_HEADER_ACK_OK;
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_ACK_WAIT_TX_PAYLOAD"
                when IMGT_ACK_WAIT_TX_PAYLOAD =>
                    -- imagette reception wait payload ack
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_ACK_RESET_TX_PAYLOAD"
                when IMGT_ACK_RESET_TX_PAYLOAD =>
                    -- imagette reception reset payload ack
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_generator_reset_o  <= '1';
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_NACK_SEND_TX_PAYLOAD"
                when IMGT_NACK_SEND_TX_PAYLOAD =>
                    -- imagette reception transmit payload nack
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_generator_start_o  <= '1';
                    header_generator_data_o   <= c_FTDI_PROT_HEADER_NACK_ERROR;
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_NACK_WAIT_TX_PAYLOAD"
                when IMGT_NACK_WAIT_TX_PAYLOAD =>
                    -- imagette reception wait payload nack
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_NACK_RESET_TX_PAYLOAD"
                when IMGT_NACK_RESET_TX_PAYLOAD =>
                    -- imagette reception reset payload nack
                    -- default output signals
                    header_generator_abort_o  <= s_registered_abort;
                    header_generator_reset_o  <= '1';
                    header_parser_abort_o     <= s_registered_abort;
                    payload_reader_abort_o    <= s_registered_abort;
                    imgt_controller_discard_o <= s_registered_abort;
                -- conditional output signals

                -- state "IMGT_RCPT_FINISH"
                when IMGT_RCPT_FINISH =>
                    -- imagette reception finish
                    -- default output signals
                    controller_finished_o <= '1';
                -- conditional output signals

                -- state "CONTROLLER_ON_HOLD"
                when CONTROLLER_ON_HOLD =>
                    -- protocol controller is on hold
                    -- default output signals
                    null;
                    -- conditional output signals

            end case;

        end if;
    end process p_ftdi_protocol_controller;

    -- Signals Assignments --

    -- Error State Assignments
    patch_rcpt_err_state_o             <= (s_err_imgt_reception_nack_err) or (s_err_imgt_reply_header_crc_err) or (s_err_imgt_reply_eoh_err) or (s_err_imgt_reply_payload_crc_err) or (s_err_imgt_reply_eop_err) or (s_err_imgt_req_max_tries_err) or (s_err_imgt_req_timeout_err);
    -- Error Code Assignments
    patch_rcpt_err_code_o(0)           <= s_err_imgt_reception_nack_err;
    patch_rcpt_err_code_o(1)           <= s_err_imgt_reply_header_crc_err;
    patch_rcpt_err_code_o(2)           <= s_err_imgt_reply_eoh_err;
    patch_rcpt_err_code_o(3)           <= s_err_imgt_reply_payload_crc_err;
    patch_rcpt_err_code_o(4)           <= s_err_imgt_reply_eop_err;
    patch_rcpt_err_code_o(5)           <= s_err_imgt_req_max_tries_err;
    patch_rcpt_err_code_o(6)           <= s_err_imgt_req_timeout_err;
    patch_rcpt_err_code_o(7)           <= '0';
    -- Error Signals Assigments
    patch_rcpt_nack_err_o              <= s_err_imgt_reception_nack_err;
    patch_rcpt_wrong_header_crc_err_o  <= s_err_imgt_reply_header_crc_err;
    patch_rcpt_end_of_header_err_o     <= s_err_imgt_reply_eoh_err;
    patch_rcpt_wrong_payload_crc_err_o <= s_err_imgt_reply_payload_crc_err;
    patch_rcpt_end_of_payload_err_o    <= s_err_imgt_reply_eop_err;
    patch_rcpt_maximum_tries_err_o     <= s_err_imgt_req_max_tries_err;
    patch_rcpt_timeout_err_o           <= s_err_imgt_req_timeout_err;

end architecture RTL;
