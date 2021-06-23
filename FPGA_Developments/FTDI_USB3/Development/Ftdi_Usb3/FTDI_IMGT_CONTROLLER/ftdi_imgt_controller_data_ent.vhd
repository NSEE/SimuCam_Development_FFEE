library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftdi_imgt_controller_data_ent is
    port(
        clk_i                    : in  std_logic;
        rst_i                    : in  std_logic;
        ftdi_module_stop_i       : in  std_logic;
        ftdi_module_start_i      : in  std_logic;
        controller_discard_i     : in  std_logic;
        imgt_buffer_empty_i      : in  std_logic;
        imgt_buffer_rddata_i     : in  std_logic_vector(31 downto 0);
        imgt_buffer_usedw_i      : in  std_logic_vector(8 downto 0);
        imgt_data_rddone_i       : in  std_logic;
        imgt_data_word_discard_i : in  std_logic;
        imgt_buffer_rdreq_o      : out std_logic;
        imgt_data_rdready_o      : out std_logic;
        imgt_data_rddata_o       : out std_logic_vector(15 downto 0)
    );
end entity ftdi_imgt_controller_data_ent;

architecture RTL of ftdi_imgt_controller_data_ent is

    type t_ftdi_imgt_controller_data_fsm is (
        STOPPED,                        -- imgt controller data is stopped
        BUFFER_WAITING,                 -- wait imagette buffer to have data
        BUFFER_READ,                    -- read data from imagette buffer
        BUFFER_FETCH,                   -- fetch data from imagette buffer
        BUFFER_READY,                   -- data from imagette buffer is ready
        BUFFER_DISCARD                  -- discard data from imagette buffer
    );

    signal s_ftdi_imgt_controller_data_state : t_ftdi_imgt_controller_data_fsm;

    alias a_imgt_buffer_rddata_word1 : std_logic_vector(15 downto 0) is imgt_buffer_rddata_i(31 downto 16);
    alias a_imgt_buffer_rddata_word0 : std_logic_vector(15 downto 0) is imgt_buffer_rddata_i(15 downto 0);

    signal s_imgt_word_select : std_logic;

begin

    p_ftdi_imgt_controller_data : process(clk_i, rst_i) is
        variable v_ftdi_imgt_controller_data_state : t_ftdi_imgt_controller_data_fsm := STOPPED;
    begin
        if (rst_i = '1') then
            -- fsm state reset
            s_ftdi_imgt_controller_data_state <= STOPPED;
            v_ftdi_imgt_controller_data_state := STOPPED;
            -- internal signals reset
            s_imgt_word_select                <= '1';
            -- outputs reset
            imgt_buffer_rdreq_o               <= '0';
            imgt_data_rdready_o               <= '0';
            imgt_data_rddata_o                <= (others => '0');
        elsif rising_edge(clk_i) then

            -- States Transition --
            -- States transitions FSM
            case (s_ftdi_imgt_controller_data_state) is

                -- state "STOPPED"
                when STOPPED =>
                    -- imgt controller data is stopped
                    -- default state transition
                    s_ftdi_imgt_controller_data_state <= STOPPED;
                    v_ftdi_imgt_controller_data_state := STOPPED;
                    -- default internal signal values
                    s_imgt_word_select                <= '1';
                    -- conditional state transition
                    -- check if a start was issued
                    if (ftdi_module_start_i = '1') then
                        -- start issued, go to buffer waiting
                        s_ftdi_imgt_controller_data_state <= BUFFER_WAITING;
                        v_ftdi_imgt_controller_data_state := BUFFER_WAITING;
                    end if;

                -- state "BUFFER_WAITING"
                when BUFFER_WAITING =>
                    -- wait imagette buffer to have data
                    -- default state transition
                    s_ftdi_imgt_controller_data_state <= BUFFER_WAITING;
                    v_ftdi_imgt_controller_data_state := BUFFER_WAITING;
                    -- default internal signal values
                    s_imgt_word_select                <= '1';
                    -- conditional state transition
                    -- check if the imagette buffer is not empty
                    if (imgt_buffer_empty_i = '0') then
                        -- the imagette buffer is not empty
                        -- go to buffer read
                        s_ftdi_imgt_controller_data_state <= BUFFER_READ;
                        v_ftdi_imgt_controller_data_state := BUFFER_READ;
                    end if;

                -- state "BUFFER_READ"
                when BUFFER_READ =>
                    -- read data from imagette buffer
                    s_imgt_word_select                <= '1';
                    -- default state transition
                    s_ftdi_imgt_controller_data_state <= BUFFER_FETCH;
                    v_ftdi_imgt_controller_data_state := BUFFER_FETCH;
                -- default internal signal values
                -- conditional state transition

                -- state "BUFFER_FETCH"
                when BUFFER_FETCH =>
                    -- fetch data from imagette buffer
                    -- default state transition
                    s_ftdi_imgt_controller_data_state <= BUFFER_READY;
                    v_ftdi_imgt_controller_data_state := BUFFER_READY;
                -- default internal signal values
                -- conditional state transition

                -- state "BUFFER_READY"
                when BUFFER_READY =>
                    -- data from imagette buffer is ready
                    -- default state transition
                    s_ftdi_imgt_controller_data_state <= BUFFER_READY;
                    v_ftdi_imgt_controller_data_state := BUFFER_READY;
                    -- default internal signal values
                    -- conditional state transition
                    -- check if a word discard was issued and there is part of a word to be read
                    if ((imgt_data_word_discard_i = '1') and (s_imgt_word_select = '0')) then
                        -- a word discard was issued and there is part of a word to be read
                        -- discard current word data and fetch new word
                        -- select high word of the imgt data
                        s_imgt_word_select                <= '1';
                        -- go to buffer waiting
                        s_ftdi_imgt_controller_data_state <= BUFFER_WAITING;
                        v_ftdi_imgt_controller_data_state := BUFFER_WAITING;
                    -- check if the data read is done
                    elsif (imgt_data_rddone_i = '1') then
                        -- the data read is done
                        -- check if all imgt data words were read
                        if (s_imgt_word_select = '0') then
                            -- all imgt data words were read
                            -- select high word of the imgt data
                            s_imgt_word_select                <= '1';
                            -- go to buffer waiting
                            s_ftdi_imgt_controller_data_state <= BUFFER_WAITING;
                            v_ftdi_imgt_controller_data_state := BUFFER_WAITING;
                        else
                            -- not all imgt data words were read
                            -- select low word of the imgt data
                            s_imgt_word_select                <= '0';
                            -- go to buffer fetch
                            s_ftdi_imgt_controller_data_state <= BUFFER_FETCH;
                            v_ftdi_imgt_controller_data_state := BUFFER_FETCH;
                        end if;
                    end if;

                -- state "BUFFER_DISCARD"
                when BUFFER_DISCARD =>
                    -- discard data from imagette buffer
                    -- default state transition
                    s_ftdi_imgt_controller_data_state <= BUFFER_DISCARD;
                    v_ftdi_imgt_controller_data_state := BUFFER_DISCARD;
                    -- default internal signal values
                    -- conditional state transition
                    -- check if the imagette buffer is empty
                    if (imgt_buffer_empty_i = '1') then
                        -- the imagette buffer is empty
                        -- go to buffer waiting
                        s_ftdi_imgt_controller_data_state <= BUFFER_WAITING;
                        v_ftdi_imgt_controller_data_state := BUFFER_WAITING;
                    end if;

                -- all the other states (not defined)
                when others =>
                    s_ftdi_imgt_controller_data_state <= STOPPED;
                    v_ftdi_imgt_controller_data_state := STOPPED;

            end case;

            -- check if a stop was issued
            if (ftdi_module_stop_i = '1') then
                -- a stop was issued
                -- go to stopped
                s_ftdi_imgt_controller_data_state <= STOPPED;
                v_ftdi_imgt_controller_data_state := STOPPED;
            -- check if a controller discard was requested
            elsif (controller_discard_i = '1') then
                -- a controller discard was requested
                -- go to buffer discard
                s_ftdi_imgt_controller_data_state <= BUFFER_DISCARD;
                v_ftdi_imgt_controller_data_state := BUFFER_DISCARD;
            end if;

            -- Output Generation --
            -- Default output generation
            imgt_buffer_rdreq_o <= '0';
            imgt_data_rdready_o <= '0';
            imgt_data_rddata_o  <= (others => '0');
            -- Output generation FSM
            case (v_ftdi_imgt_controller_data_state) is

                -- state "STOPPED"
                when STOPPED =>
                    -- imgt controller data is stopped
                    -- default output signals
                    null;
                -- conditional output signals

                -- state "BUFFER_WAITING"
                when BUFFER_WAITING =>
                    -- wait imagette buffer to have data
                    -- default output signals
                    null;
                -- conditional output signals

                -- state "BUFFER_READ"
                when BUFFER_READ =>
                    -- read data from imagette buffer
                    -- default output signals
                    imgt_buffer_rdreq_o <= '1';
                -- conditional output signals

                -- state "BUFFER_FETCH"
                when BUFFER_FETCH =>
                    -- fetch data from imagette buffer
                    -- default output signals
                    null;
                -- conditional output signals

                -- state "BUFFER_READY"
                when BUFFER_READY =>
                    -- data from imagette buffer is ready
                    -- default output signals
                    imgt_data_rdready_o <= '1';
                    -- check if the high word is selected
                    if (s_imgt_word_select = '1') then
                        -- the high word is selected
                        imgt_data_rddata_o <= a_imgt_buffer_rddata_word1;
                    else
                        -- the low word is selected
                        imgt_data_rddata_o <= a_imgt_buffer_rddata_word0;
                    end if;
                -- conditional output signals

                -- state "BUFFER_DISCARD"
                when BUFFER_DISCARD =>
                    -- discard data from imagette buffer
                    -- default output signals
                    imgt_buffer_rdreq_o <= '1';
                    -- conditional output signals

            end case;

        end if;
    end process p_ftdi_imgt_controller_data;

end architecture RTL;
