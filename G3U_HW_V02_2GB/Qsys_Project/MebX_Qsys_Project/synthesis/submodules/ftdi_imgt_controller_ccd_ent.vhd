library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ftdi_imgt_controller_ccd_ent is
    port(
        clk_i                            : in  std_logic;
        rst_i                            : in  std_logic;
        ftdi_module_stop_i               : in  std_logic;
        ftdi_module_start_i              : in  std_logic;
        controller_start_i               : in  std_logic;
        controller_discard_i             : in  std_logic;
        inv_pixels_byte_order_i          : in  std_logic;
        imgt_data_rdready_i              : in  std_logic;
        imgt_data_rddata_i               : in  std_logic_vector(15 downto 0);
        controller_imagette_finished_i   : in  std_logic;
        fee_ccd_halfwidth_pixels_i       : in  std_logic_vector(15 downto 0);
        fee_ccd_height_pixels_i          : in  std_logic_vector(15 downto 0);
        fee_0_ccd_0_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        fee_0_ccd_0_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        fee_0_ccd_1_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        fee_0_ccd_1_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        fee_0_ccd_2_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        fee_0_ccd_2_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        fee_0_ccd_3_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        fee_0_ccd_3_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_0_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_0_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_1_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_1_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_2_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_2_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_3_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_1_ccd_3_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_0_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_0_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_1_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_1_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_2_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_2_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_3_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_2_ccd_3_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_0_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_0_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_1_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_1_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_2_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_2_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_3_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_3_ccd_3_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_0_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_0_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_1_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_1_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_2_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_2_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_3_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_4_ccd_3_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_0_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_0_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_1_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_1_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_2_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_2_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_3_left_initial_addr_i  : in  std_logic_vector(63 downto 0);
        --		fee_5_ccd_3_right_initial_addr_i : in  std_logic_vector(63 downto 0);
        controller_busy_o                : out std_logic;
        imgt_data_rddone_o               : out std_logic;
        imgt_data_word_discard_o         : out std_logic;
        controller_imagette_start_o      : out std_logic;
        controller_imagette_reset_o      : out std_logic;
        controller_data_discard_o        : out std_logic;
        ccd_half_initial_addr_o          : out std_logic_vector(63 downto 0);
        ccd_halfwidth_pixels_o           : out std_logic_vector(15 downto 0);
        ccd_height_pixels_o              : out std_logic_vector(15 downto 0);
        invert_pixels_byte_order_o       : out std_logic
    );
end entity ftdi_imgt_controller_ccd_ent;

architecture RTL of ftdi_imgt_controller_ccd_ent is

    type t_ftdi_imgt_controller_ccd_fsm is (
        STOPPED,                        -- imgt controller ccd is stopped
        IDLE,                           -- imgt controller ccd is idle
        BUFFER_WAITING,                 -- waiting imagette data
        FEE_INFO,                       -- fee information
        IMAGETTES_NUMBER,               -- number of imagettes
        CCD_INFO,                       -- ccd information
        START_CONTROLLER_IMAGETTE,      -- start the controller imagette
        WAIT_CONTROLLER_IMAGETTE,       -- wait the controller imagette to finish
        RESET_CONTROLLER_IMAGETTE,      -- reset the controller imagette
        FINISHED,                       -- imgt controller ccd is finished
        DISCARD_DATA                    -- discard imgt data

    );

    signal s_ftdi_imgt_controller_ccd_state      : t_ftdi_imgt_controller_ccd_fsm;
    signal s_ftdi_imgt_controller_ccd_next_state : t_ftdi_imgt_controller_ccd_fsm;

    -- constants
    constant c_CCD_SIDE_LEFT : std_logic_vector(7 downto 0) := x"00";

    -- information alias
    alias a_ccd_number is imgt_data_rddata_i(15 downto 8);
    alias a_ccd_side is imgt_data_rddata_i(7 downto 0);

    -- registered signals
    signal s_registered_fee_number               : unsigned(15 downto 0);
    signal s_registered_number_of_imagettes      : unsigned(15 downto 0);
    signal s_registered_ccd_number               : unsigned(7 downto 0);
    signal s_registered_ccd_side                 : unsigned(7 downto 0);
    signal s_registered_ccd_halfwidth            : std_logic_vector(15 downto 0);
    signal s_registered_ccd_height               : std_logic_vector(15 downto 0);
    signal s_registered_ccd_half_initial_addr    : std_logic_vector(63 downto 0);
    signal s_registered_invert_pixels_byte_order : std_logic;

begin

    p_ftdi_imgt_controller_ccd : process(clk_i, rst_i) is
        variable v_ftdi_imgt_controller_ccd_state : t_ftdi_imgt_controller_ccd_fsm := STOPPED;
    begin
        if (rst_i = '1') then
            -- fsm state reset
            s_ftdi_imgt_controller_ccd_state      <= STOPPED;
            v_ftdi_imgt_controller_ccd_state      := STOPPED;
            s_ftdi_imgt_controller_ccd_next_state <= STOPPED;
            -- internal signals reset
            s_registered_fee_number               <= (others => '0');
            s_registered_number_of_imagettes      <= (others => '0');
            s_registered_ccd_number               <= (others => '0');
            s_registered_ccd_side                 <= (others => '0');
            s_registered_ccd_halfwidth            <= (others => '0');
            s_registered_ccd_height               <= (others => '0');
            s_registered_ccd_half_initial_addr    <= (others => '0');
            s_registered_invert_pixels_byte_order <= '0';
            -- outputs reset
            controller_busy_o                     <= '0';
            imgt_data_rddone_o                    <= '0';
            imgt_data_word_discard_o              <= '0';
            controller_imagette_start_o           <= '0';
            controller_imagette_reset_o           <= '0';
            controller_data_discard_o             <= '0';
            ccd_half_initial_addr_o               <= (others => '0');
            ccd_halfwidth_pixels_o                <= (others => '0');
            ccd_height_pixels_o                   <= (others => '0');
            invert_pixels_byte_order_o            <= '0';
        elsif rising_edge(clk_i) then

            -- States Transition --
            -- States transitions FSM
            case (s_ftdi_imgt_controller_ccd_state) is

                -- state "STOPPED"
                when STOPPED =>
                    -- rx avm writer controller is stopped
                    -- default state transition
                    s_ftdi_imgt_controller_ccd_state      <= STOPPED;
                    v_ftdi_imgt_controller_ccd_state      := STOPPED;
                    s_ftdi_imgt_controller_ccd_next_state <= STOPPED;
                    -- default internal signal values
                    s_registered_fee_number               <= (others => '0');
                    s_registered_number_of_imagettes      <= (others => '0');
                    s_registered_ccd_number               <= (others => '0');
                    s_registered_ccd_side                 <= (others => '0');
                    s_registered_ccd_halfwidth            <= (others => '0');
                    s_registered_ccd_height               <= (others => '0');
                    s_registered_ccd_half_initial_addr    <= (others => '0');
                    -- conditional state transition
                    -- check if a start was issued
                    if (ftdi_module_start_i = '1') then
                        -- start issued, go to idle
                        s_ftdi_imgt_controller_ccd_state <= IDLE;
                        v_ftdi_imgt_controller_ccd_state := IDLE;
                    end if;

                -- state "IDLE"
                when IDLE =>
                    -- imgt controller ccd is idle
                    -- default state transition
                    s_ftdi_imgt_controller_ccd_state      <= IDLE;
                    v_ftdi_imgt_controller_ccd_state      := IDLE;
                    s_ftdi_imgt_controller_ccd_next_state <= STOPPED;
                    -- default internal signal values
                    s_registered_fee_number               <= (others => '0');
                    s_registered_number_of_imagettes      <= (others => '0');
                    s_registered_ccd_number               <= (others => '0');
                    s_registered_ccd_side                 <= (others => '0');
                    s_registered_ccd_halfwidth            <= (others => '0');
                    s_registered_ccd_height               <= (others => '0');
                    s_registered_ccd_half_initial_addr    <= (others => '0');
                    -- conditional state transition
                    -- check if a controller start was issued
                    if (controller_start_i = '1') then
                        -- controller start issued, go to buffer waiting
                        s_ftdi_imgt_controller_ccd_state      <= BUFFER_WAITING;
                        v_ftdi_imgt_controller_ccd_state      := BUFFER_WAITING;
                        s_ftdi_imgt_controller_ccd_next_state <= FEE_INFO;
                    end if;

                -- state "BUFFER_WAITING"
                when BUFFER_WAITING =>
                    -- waiting imagette data
                    -- default state transition
                    s_ftdi_imgt_controller_ccd_state <= BUFFER_WAITING;
                    v_ftdi_imgt_controller_ccd_state := BUFFER_WAITING;
                    -- default internal signal values
                    -- conditional state transition
                    -- check if the imagette data is ready to be read
                    if (imgt_data_rdready_i = '1') then
                        -- the imagette data is ready to be read
                        -- go to next field
                        s_ftdi_imgt_controller_ccd_state      <= s_ftdi_imgt_controller_ccd_next_state;
                        v_ftdi_imgt_controller_ccd_state      := s_ftdi_imgt_controller_ccd_next_state;
                        s_ftdi_imgt_controller_ccd_next_state <= STOPPED;
                    end if;

                -- state "FEE_INFO"
                when FEE_INFO =>
                    -- fee information
                    -- default state transition
                    s_ftdi_imgt_controller_ccd_state      <= BUFFER_WAITING;
                    v_ftdi_imgt_controller_ccd_state      := BUFFER_WAITING;
                    s_ftdi_imgt_controller_ccd_next_state <= IMAGETTES_NUMBER;
                    -- default internal signal values
                    s_registered_fee_number               <= unsigned(imgt_data_rddata_i);
                    -- conditional state transition
                    s_registered_ccd_halfwidth            <= fee_ccd_halfwidth_pixels_i;
                    s_registered_ccd_height               <= fee_ccd_height_pixels_i;
                    s_registered_invert_pixels_byte_order <= inv_pixels_byte_order_i;

                -- state "IMAGETTES_NUMBER"
                when IMAGETTES_NUMBER =>
                    -- number of imagettes
                    -- default state transition
                    s_ftdi_imgt_controller_ccd_state      <= BUFFER_WAITING;
                    v_ftdi_imgt_controller_ccd_state      := BUFFER_WAITING;
                    s_ftdi_imgt_controller_ccd_next_state <= CCD_INFO;
                    -- default internal signal values
                    s_registered_number_of_imagettes      <= unsigned(imgt_data_rddata_i);
                -- conditional state transition

                -- state "CCD_INFO"
                when CCD_INFO =>
                    -- ccd information
                    -- default state transition
                    s_ftdi_imgt_controller_ccd_state      <= START_CONTROLLER_IMAGETTE;
                    v_ftdi_imgt_controller_ccd_state      := START_CONTROLLER_IMAGETTE;
                    s_ftdi_imgt_controller_ccd_next_state <= STOPPED;
                    -- default internal signal values
                    s_registered_ccd_number               <= unsigned(a_ccd_number);
                    s_registered_ccd_side                 <= unsigned(a_ccd_side);
                    -- conditional state transition
                    case (s_registered_fee_number) is
                        when x"0000" =>
                            case (a_ccd_number) is
                                when x"00" =>
                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                                        s_registered_ccd_half_initial_addr <= fee_0_ccd_0_left_initial_addr_i;
                                    else
                                        s_registered_ccd_half_initial_addr <= fee_0_ccd_0_right_initial_addr_i;
                                    end if;
                                when x"01" =>
                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                                        s_registered_ccd_half_initial_addr <= fee_0_ccd_1_left_initial_addr_i;
                                    else
                                        s_registered_ccd_half_initial_addr <= fee_0_ccd_1_right_initial_addr_i;
                                    end if;
                                when x"02" =>
                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                                        s_registered_ccd_half_initial_addr <= fee_0_ccd_2_left_initial_addr_i;
                                    else
                                        s_registered_ccd_half_initial_addr <= fee_0_ccd_2_right_initial_addr_i;
                                    end if;
                                when x"03" =>
                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                                        s_registered_ccd_half_initial_addr <= fee_0_ccd_3_left_initial_addr_i;
                                    else
                                        s_registered_ccd_half_initial_addr <= fee_0_ccd_3_right_initial_addr_i;
                                    end if;
                                when others =>
                                    s_registered_ccd_half_initial_addr <= (others => '0');
                            end case;
                        --                        when x"0001" =>
                        --                            case (a_ccd_number) is
                        --                                when x"00" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_1_ccd_0_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_1_ccd_0_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"01" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_1_ccd_1_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_1_ccd_1_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"02" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_1_ccd_2_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_1_ccd_2_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"03" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_1_ccd_3_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_1_ccd_3_right_initial_addr_i;
                        --                                    end if;
                        --                                when others =>
                        --                                    s_registered_ccd_half_initial_addr <= (others => '0');
                        --                            end case;
                        --                        when x"0002" =>
                        --                            case (a_ccd_number) is
                        --                                when x"00" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_2_ccd_0_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_2_ccd_0_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"01" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_2_ccd_1_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_2_ccd_1_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"02" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_2_ccd_2_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_2_ccd_2_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"03" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_2_ccd_3_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_2_ccd_3_right_initial_addr_i;
                        --                                    end if;
                        --                                when others =>
                        --                                    s_registered_ccd_half_initial_addr <= (others => '0');
                        --                            end case;
                        --                        when x"0003" =>
                        --                            case (a_ccd_number) is
                        --                                when x"00" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_3_ccd_0_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_3_ccd_0_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"01" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_3_ccd_1_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_3_ccd_1_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"02" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_3_ccd_2_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_3_ccd_2_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"03" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_3_ccd_3_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_3_ccd_3_right_initial_addr_i;
                        --                                    end if;
                        --                                when others =>
                        --                                    s_registered_ccd_half_initial_addr <= (others => '0');
                        --                            end case;
                        --                        when x"0004" =>
                        --                            case (a_ccd_number) is
                        --                                when x"00" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_4_ccd_0_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_4_ccd_0_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"01" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_4_ccd_1_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_4_ccd_1_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"02" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_4_ccd_2_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_4_ccd_2_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"03" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_4_ccd_3_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_4_ccd_3_right_initial_addr_i;
                        --                                    end if;
                        --                                when others =>
                        --                                    s_registered_ccd_half_initial_addr <= (others => '0');
                        --                            end case;
                        --                        when x"0005" =>
                        --                            case (a_ccd_number) is
                        --                                when x"00" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_5_ccd_0_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_5_ccd_0_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"01" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_5_ccd_1_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_5_ccd_1_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"02" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_5_ccd_2_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_5_ccd_2_right_initial_addr_i;
                        --                                    end if;
                        --                                when x"03" =>
                        --                                    if (a_ccd_side = c_CCD_SIDE_LEFT) then
                        --                                        s_registered_ccd_half_initial_addr <= fee_5_ccd_3_left_initial_addr_i;
                        --                                    else
                        --                                        s_registered_ccd_half_initial_addr <= fee_5_ccd_3_right_initial_addr_i;
                        --                                    end if;
                        --                                when others =>
                        --                                    s_registered_ccd_half_initial_addr <= (others => '0');
                        --                            end case;
                        when others =>
                            s_registered_ccd_half_initial_addr <= (others => '0');
                    end case;

                -- state "START_CONTROLLER_IMAGETTE"
                when START_CONTROLLER_IMAGETTE =>
                    -- start the controller imagette
                    -- default state transition
                    s_ftdi_imgt_controller_ccd_state      <= WAIT_CONTROLLER_IMAGETTE;
                    v_ftdi_imgt_controller_ccd_state      := WAIT_CONTROLLER_IMAGETTE;
                    s_ftdi_imgt_controller_ccd_next_state <= STOPPED;
                    -- default internal signal values
                    s_registered_number_of_imagettes      <= s_registered_number_of_imagettes - 1;
                -- conditional state transition

                -- state "WAIT_CONTROLLER_IMAGETTE"
                when WAIT_CONTROLLER_IMAGETTE =>
                    -- wait the controller imagette to finish
                    -- default state transition
                    s_ftdi_imgt_controller_ccd_state      <= WAIT_CONTROLLER_IMAGETTE;
                    v_ftdi_imgt_controller_ccd_state      := WAIT_CONTROLLER_IMAGETTE;
                    s_ftdi_imgt_controller_ccd_next_state <= STOPPED;
                    -- default internal signal values
                    -- conditional state transition
                    -- check if the controller imagette is finished
                    if (controller_imagette_finished_i = '1') then
                        -- the controller imagette is finished
                        -- go to reset controller imagette
                        s_ftdi_imgt_controller_ccd_state <= RESET_CONTROLLER_IMAGETTE;
                        v_ftdi_imgt_controller_ccd_state := RESET_CONTROLLER_IMAGETTE;
                    end if;

                -- state "RESET_CONTROLLER_IMAGETTE"
                when RESET_CONTROLLER_IMAGETTE =>
                    -- reset the controller imagette
                    -- default state transition
                    s_ftdi_imgt_controller_ccd_state      <= FINISHED;
                    v_ftdi_imgt_controller_ccd_state      := FINISHED;
                    s_ftdi_imgt_controller_ccd_next_state <= STOPPED;
                    -- default internal signal values
                    -- conditional state transition
                    -- check if there are more imagettes to be processed
                    if (s_registered_number_of_imagettes /= 0) then
                        -- there are more imagettes to be processed
                        --                        -- go to start waiting buffer, then to ccd info
                        s_ftdi_imgt_controller_ccd_state      <= BUFFER_WAITING;
                        v_ftdi_imgt_controller_ccd_state      := BUFFER_WAITING;
                        s_ftdi_imgt_controller_ccd_next_state <= CCD_INFO;
                    end if;

                -- state "FINISHED"
                when FINISHED =>
                    -- rx avm writer controller is finished
                    -- default state transition
                    s_ftdi_imgt_controller_ccd_state      <= IDLE;
                    v_ftdi_imgt_controller_ccd_state      := IDLE;
                    s_ftdi_imgt_controller_ccd_next_state <= STOPPED;
                -- default internal signal values
                -- conditional state transition

                -- state "DISCARD_DATA"
                when DISCARD_DATA =>
                    -- discard imgt data
                    -- default state transition
                    s_ftdi_imgt_controller_ccd_state      <= IDLE;
                    v_ftdi_imgt_controller_ccd_state      := IDLE;
                    s_ftdi_imgt_controller_ccd_next_state <= STOPPED;
                -- default internal signal values
                -- conditional state transition			

                -- all the other states (not defined)
                when others =>
                    s_ftdi_imgt_controller_ccd_state      <= STOPPED;
                    v_ftdi_imgt_controller_ccd_state      := STOPPED;
                    s_ftdi_imgt_controller_ccd_next_state <= STOPPED;

            end case;

            -- check if a stop was issued
            if (ftdi_module_stop_i = '1') then
                -- a stop was issued
                -- go to stopped
                s_ftdi_imgt_controller_ccd_state      <= STOPPED;
                v_ftdi_imgt_controller_ccd_state      := STOPPED;
                s_ftdi_imgt_controller_ccd_next_state <= STOPPED;
            -- check if a discard was requested
            elsif (controller_discard_i = '1') then
                -- a discard was requested
                -- go to idle
                s_ftdi_imgt_controller_ccd_state      <= DISCARD_DATA;
                v_ftdi_imgt_controller_ccd_state      := DISCARD_DATA;
                s_ftdi_imgt_controller_ccd_next_state <= STOPPED;
            end if;

            -- Output Generation --
            -- Default output generation
            controller_busy_o           <= '0';
            imgt_data_rddone_o          <= '0';
            imgt_data_word_discard_o    <= '0';
            controller_imagette_start_o <= '0';
            controller_imagette_reset_o <= '0';
            controller_data_discard_o   <= '0';
            ccd_half_initial_addr_o     <= (others => '0');
            ccd_halfwidth_pixels_o      <= (others => '0');
            ccd_height_pixels_o         <= (others => '0');
            invert_pixels_byte_order_o  <= '0';
            -- Output generation FSM
            case (v_ftdi_imgt_controller_ccd_state) is

                -- state "STOPPED"
                when STOPPED =>
                    -- imgt controller ccd is stopped
                    -- default output signals
                    null;
                -- conditional output signals

                -- state "STOPPED"
                when IDLE =>
                    -- imgt controller ccd is stopped
                    -- default output signals
                    null;
                -- conditional output signals

                -- state "BUFFER_WAITING"
                when BUFFER_WAITING =>
                    -- waiting imagette data
                    -- default output signals
                    controller_busy_o <= '1';
                -- conditional output signals

                -- state "FEE_INFO"
                when FEE_INFO =>
                    -- fee information
                    -- default output signals
                    controller_busy_o  <= '1';
                    imgt_data_rddone_o <= '1';
                -- conditional output signals

                -- state "IMAGETTES_NUMBER"
                when IMAGETTES_NUMBER =>
                    -- number of imagettes
                    -- default output signals
                    controller_busy_o  <= '1';
                    imgt_data_rddone_o <= '1';
                -- conditional output signals

                -- state "CCD_INFO"
                when CCD_INFO =>
                    -- ccd information
                    -- default output signals
                    controller_busy_o  <= '1';
                    imgt_data_rddone_o <= '1';
                -- conditional output signals

                -- state "START_CONTROLLER_IMAGETTE"
                when START_CONTROLLER_IMAGETTE =>
                    -- start the controller imagette
                    -- default output signals
                    controller_busy_o           <= '1';
                    controller_imagette_start_o <= '1';
                    ccd_half_initial_addr_o     <= s_registered_ccd_half_initial_addr;
                    ccd_halfwidth_pixels_o      <= s_registered_ccd_halfwidth;
                    ccd_height_pixels_o         <= s_registered_ccd_height;
                    invert_pixels_byte_order_o  <= s_registered_invert_pixels_byte_order;
                -- conditional output signals

                -- state "WAIT_CONTROLLER_IMAGETTE"
                when WAIT_CONTROLLER_IMAGETTE =>
                    -- wait the controller imagette to finish
                    -- default output signals
                    controller_busy_o          <= '1';
                    ccd_half_initial_addr_o    <= s_registered_ccd_half_initial_addr;
                    ccd_halfwidth_pixels_o     <= s_registered_ccd_halfwidth;
                    ccd_height_pixels_o        <= s_registered_ccd_height;
                    invert_pixels_byte_order_o <= s_registered_invert_pixels_byte_order;
                -- conditional output signals

                -- state "RESET_CONTROLLER_IMAGETTE"
                when RESET_CONTROLLER_IMAGETTE =>
                    -- reset the controller imagette
                    -- default output signals
                    controller_busy_o           <= '1';
                    controller_imagette_reset_o <= '1';
                -- conditional output signals

                -- state "FINISHED"
                when FINISHED =>
                    -- imgt controller ccd is finished
                    -- default output signals
                    controller_busy_o        <= '1';
                    imgt_data_word_discard_o <= '1';
                -- conditional output signals

                -- state "DISCARD_DATA"
                when DISCARD_DATA =>
                    -- discard imgt data
                    -- default output signals
                    controller_imagette_reset_o <= '1';
                    controller_data_discard_o   <= '1';
                    -- conditional output signals		

            end case;

        end if;
    end process p_ftdi_imgt_controller_ccd;

end architecture RTL;
