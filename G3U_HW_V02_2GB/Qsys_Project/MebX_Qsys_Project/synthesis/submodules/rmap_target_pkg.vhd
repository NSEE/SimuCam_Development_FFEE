--=============================================================================
--! @file rmap_target_pkg.vhd
--=============================================================================
--! Standard library
library IEEE;
--! Standard packages
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--! Specific packages
--use work.XXX.ALL;
-------------------------------------------------------------------------------
-- --
-- Instituto Mauá de Tecnologia, Núcleo de Sistemas Eletrônicos Embarcados --
-- Plato Project --
-- --
-------------------------------------------------------------------------------
--
-- unit name: RMAP Target Package (rmap_target_pkg)
--
--! @brief Package to be used for contants, type and functions declarations   
--! for the RMAP Taget Codec.
--
--! @author Rodrigo França (rodrigo.franca@maua.br)
--
--! @date 06\02\2018
--
--! @version v1.0
--
--! @details
--!
--! <b>Dependencies:</b>\n
--! None
--!
--! <b>References:</b>\n
--! SpaceWire - Remote memory access protocol, ECSS-E-ST-50-52C, 2010.02.05 \n
--!
--! <b>Modified by:</b>\n
--! Author: Rodrigo França
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 06\02\2018 RF File Creation\n
--
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
-------------------------------------------------------------------------------

--============================================================================
--! Package declaration for RMAP Target Package
--============================================================================
package rmap_target_pkg is

    constant c_WIDTH_TRANSACTION_IDENTIFIER : natural := 16;
    --	constant c_MAX_TRANSACTION_IDENTIFIER   : natural := ((2 ** c_WIDTH_TRANSACTION_IDENTIFIER) - 1);
    constant c_WIDTH_ADDRESS                : natural := 32;
    --	constant c_MAX_ADDRESS                  : natural := ((2 ** c_WIDTH_ADDRESS) - 1);
    constant c_WIDTH_EXTENDED_ADDRESS       : natural := 40;
    --	constant c_MAX_EXTENDED_ADDRESS         : natural := ((2 ** c_WIDTH_EXTENDED_ADDRESS) - 1);
    constant c_WIDTH_DATA_LENGTH            : natural := 24;
    --	constant c_MAX_DATA_LENGTH              : natural := ((2 ** c_WIDTH_DATA_LENGTH) - 1);
    constant c_WIDTH_MEMORY_ACCESS          : natural := 6; -- data width = 8 * (2 ** c_WIDTH_MEMORY_ACCESS)

    -- others

    type t_rmap_target_instructions_command is record
        write_read               : std_logic;
        verify_data_before_write : std_logic;
        reply                    : std_logic;
        increment_address        : std_logic;
    end record t_rmap_target_instructions_command;

    type t_rmap_target_instructions is record
        packet_type          : std_logic_vector(1 downto 0);
        command              : t_rmap_target_instructions_command;
        reply_address_length : std_logic_vector(1 downto 0);
    end record t_rmap_target_instructions;

    type t_rmap_target_reply_address is array (0 to 11) of std_logic_vector(7 downto 0);
    type t_rmap_target_transaction_identifier is array (0 to 1) of std_logic_vector(7 downto 0);
    type t_rmap_target_address is array (0 to 3) of std_logic_vector(7 downto 0);
    type t_rmap_target_data_length is array (0 to 2) of std_logic_vector(7 downto 0);

    -- command parsing

    type t_rmap_target_command_control is record
        user_ready    : std_logic;
        command_reset : std_logic;
    end record t_rmap_target_command_control;

    type t_rmap_target_command_flags is record
        command_received  : std_logic;
        write_request     : std_logic;
        read_request      : std_logic;
        discarded_package : std_logic;
        command_busy      : std_logic;
    end record t_rmap_target_command_flags;

    type t_rmap_target_command_error is record
        early_eop            : std_logic;
        eep                  : std_logic;
        header_crc           : std_logic;
        unused_packet_type   : std_logic;
        invalid_command_code : std_logic;
        too_much_data        : std_logic;
    end record t_rmap_target_command_error;

    type t_rmap_target_command_headerdata is record
        target_logical_address    : std_logic_vector(7 downto 0);
        instructions              : t_rmap_target_instructions;
        key                       : std_logic_vector(7 downto 0);
        reply_address             : t_rmap_target_reply_address;
        initiator_logical_address : std_logic_vector(7 downto 0);
        transaction_identifier    : t_rmap_target_transaction_identifier;
        extended_address          : std_logic_vector(7 downto 0);
        address                   : t_rmap_target_address;
        data_length               : t_rmap_target_data_length;
    end record t_rmap_target_command_headerdata;

    -- reply generation

    type t_rmap_target_reply_control is record
        send_reply  : std_logic;
        reply_reset : std_logic;
    end record t_rmap_target_reply_control;

    type t_rmap_target_reply_flags is record
        reply_finished : std_logic;
        reply_busy     : std_logic;
    end record t_rmap_target_reply_flags;

    type t_rmap_target_reply_error is record
        dummy : std_logic;
    end record t_rmap_target_reply_error;

    type t_rmap_target_reply_headerdata is record
        reply_spw_address         : t_rmap_target_reply_address;
        initiator_logical_address : std_logic_vector(7 downto 0);
        instructions              : t_rmap_target_instructions;
        status                    : std_logic_vector(7 downto 0);
        target_logical_address    : std_logic_vector(7 downto 0);
        transaction_identifier    : t_rmap_target_transaction_identifier;
        data_length               : t_rmap_target_data_length;
    end record t_rmap_target_reply_headerdata;

    -- write operation

    type t_rmap_target_write_control is record
        write_authorization  : std_logic;
        write_not_authorized : std_logic;
        write_reset          : std_logic;
    end record t_rmap_target_write_control;

    type t_rmap_target_write_flags is record
        write_data_indication      : std_logic;
        write_operation_failed     : std_logic;
        write_data_discarded       : std_logic;
        write_error_end_of_package : std_logic;
        write_busy                 : std_logic;
    end record t_rmap_target_write_flags;

    type t_rmap_target_write_error is record
        early_eop        : std_logic;
        eep              : std_logic;
        too_much_data    : std_logic;
        invalid_data_crc : std_logic;
    end record t_rmap_target_write_error;

    type t_rmap_target_write_headerdata is record
        instruction_verify_data_before_write : std_logic;
        instruction_increment_address        : std_logic;
        extended_address                     : std_logic_vector(7 downto 0);
        address                              : t_rmap_target_address;
        data_length                          : t_rmap_target_data_length;
    end record t_rmap_target_write_headerdata;

    -- read operation

    type t_rmap_target_read_control is record
        read_authorization : std_logic;
        read_reset         : std_logic;
    end record t_rmap_target_read_control;

    type t_rmap_target_read_flags is record
        read_data_indication  : std_logic;
        read_operation_failed : std_logic;
        read_busy             : std_logic;
    end record t_rmap_target_read_flags;

    type t_rmap_target_read_error is record
        dummy : std_logic;
    end record t_rmap_target_read_error;

    type t_rmap_target_read_headerdata is record
        instruction_increment_address : std_logic;
        extended_address              : std_logic_vector(7 downto 0);
        address                       : t_rmap_target_address;
        data_length                   : t_rmap_target_data_length;
    end record t_rmap_target_read_headerdata;

    -- rmap codec

    constant c_RMAP_PROTOCOL : std_logic_vector(7 downto 0) := x"01";

    type t_rmap_target_control is record
        command_parsing    : t_rmap_target_command_control;
        reply_geneneration : t_rmap_target_reply_control;
        write_operation    : t_rmap_target_write_control;
        read_operation     : t_rmap_target_read_control;
    end record t_rmap_target_control;

    type t_rmap_target_flags is record
        command_parsing    : t_rmap_target_command_flags;
        reply_geneneration : t_rmap_target_reply_flags;
        write_operation    : t_rmap_target_write_flags;
        read_operation     : t_rmap_target_read_flags;
    end record t_rmap_target_flags;

    type t_rmap_target_error is record
        command_parsing    : t_rmap_target_command_error;
        reply_geneneration : t_rmap_target_reply_error;
        write_operation    : t_rmap_target_write_error;
        read_operation     : t_rmap_target_read_error;
    end record t_rmap_target_error;

    type t_rmap_target_rmap_data is record
        target_logical_address    : std_logic_vector(7 downto 0);
        instructions              : t_rmap_target_instructions;
        key                       : std_logic_vector(7 downto 0);
        status                    : std_logic_vector(7 downto 0);
        reply_address             : t_rmap_target_reply_address;
        initiator_logical_address : std_logic_vector(7 downto 0);
        transaction_identifier    : t_rmap_target_transaction_identifier;
        extended_address          : std_logic_vector(7 downto 0);
        address                   : t_rmap_target_address;
        data_length               : t_rmap_target_data_length;
    end record t_rmap_target_rmap_data;

    type t_rmap_target_rmap_error is record
        early_eop            : std_logic;
        eep                  : std_logic;
        header_crc           : std_logic;
        unused_packet_type   : std_logic;
        invalid_command_code : std_logic;
        too_much_data        : std_logic;
        invalid_data_crc     : std_logic;
    end record t_rmap_target_rmap_error;

    -- user application

    -- RMAP reply error code
    constant c_ERROR_CODE_COMMAND_EXECUTED_SUCCESSFULLY                  : std_logic_vector(7 downto 0) := x"00";
    constant c_ERROR_CODE_GENERAL_ERROR_CODE                             : std_logic_vector(7 downto 0) := x"01";
    constant c_ERROR_CODE_UNUSED_RMAP_PACKET_TYPE_OR_COMMAND_CODE        : std_logic_vector(7 downto 0) := x"02";
    constant c_ERROR_CODE_INVALID_KEY                                    : std_logic_vector(7 downto 0) := x"03";
    constant c_ERROR_CODE_INVALID_DATA_CRC                               : std_logic_vector(7 downto 0) := x"04";
    constant c_ERROR_CODE_EARLY_EOP                                      : std_logic_vector(7 downto 0) := x"05";
    constant c_ERROR_CODE_TOO_MUCH_DATA                                  : std_logic_vector(7 downto 0) := x"06";
    constant c_ERROR_CODE_EEP                                            : std_logic_vector(7 downto 0) := x"07";
    constant c_ERROR_CODE_VERIFY_BUFFER_OVERRUN                          : std_logic_vector(7 downto 0) := x"09";
    constant c_ERROR_CODE_RMAP_COMMAND_NOT_IMPLEMENTED_OR_NOT_AUTHORISED : std_logic_vector(7 downto 0) := x"0A";
    constant c_ERROR_CODE_RMW_DATA_LENGTH_ERROR                          : std_logic_vector(7 downto 0) := x"0B";
    constant c_ERROR_CODE_INVALID_TARGET_LOGICAL_ADDRESS                 : std_logic_vector(7 downto 0) := x"0C";

    type t_rmap_target_user_codecdata is record
        target_logical_address    : std_logic_vector(7 downto 0);
        instructions              : t_rmap_target_instructions;
        key                       : std_logic_vector(7 downto 0);
        initiator_logical_address : std_logic_vector(7 downto 0);
        transaction_identifier    : t_rmap_target_transaction_identifier;
        extended_address          : std_logic_vector(7 downto 0);
        memory_address            : t_rmap_target_address;
        data_length               : t_rmap_target_data_length;
    end record t_rmap_target_user_codecdata;

    type t_rmap_target_user_configs is record
        user_key                    : std_logic_vector(7 downto 0);
        user_target_logical_address : std_logic_vector(7 downto 0);
    end record t_rmap_target_user_configs;

    -- SpW

    constant c_EOP_VALUE : std_logic_vector(7 downto 0) := x"00";
    constant c_EEP_VALUE : std_logic_vector(7 downto 0) := x"01";

    type t_rmap_target_spw_rx_control is record
        read : std_logic;
    end record t_rmap_target_spw_rx_control;

    type t_rmap_target_spw_rx_flag is record
        valid : std_logic;
        flag  : std_logic;
        data  : std_logic_vector(7 downto 0);
        error : std_logic;
    end record t_rmap_target_spw_rx_flag;

    type t_rmap_target_spw_tx_control is record
        write : std_logic;
        flag  : std_logic;
        data  : std_logic_vector(7 downto 0);
    end record t_rmap_target_spw_tx_control;

    type t_rmap_target_spw_tx_flag is record
        ready : std_logic;
        error : std_logic;
    end record t_rmap_target_spw_tx_flag;

    type t_rmap_target_spw_control is record
        receiver    : t_rmap_target_spw_rx_control;
        transmitter : t_rmap_target_spw_tx_control;
    end record t_rmap_target_spw_control;

    type t_rmap_target_spw_flag is record
        receiver    : t_rmap_target_spw_rx_flag;
        transmitter : t_rmap_target_spw_tx_flag;
    end record t_rmap_target_spw_flag;

    -- mem

    type t_rmap_target_mem_wr_control is record
        write : std_logic;
        data  : std_logic_vector(7 downto 0);
    end record t_rmap_target_mem_wr_control;

    type t_rmap_target_mem_wr_flag is record
        waitrequest : std_logic;
        error       : std_logic;
    end record t_rmap_target_mem_wr_flag;

    type t_rmap_target_mem_rd_control is record
        read : std_logic;
    end record t_rmap_target_mem_rd_control;

    type t_rmap_target_mem_rd_flag is record
        waitrequest : std_logic;
        error       : std_logic;
        data        : std_logic_vector(7 downto 0);
    end record t_rmap_target_mem_rd_flag;

    type t_rmap_target_mem_control is record
        write : t_rmap_target_mem_wr_control;
        read  : t_rmap_target_mem_rd_control;
    end record t_rmap_target_mem_control;

    type t_rmap_target_mem_flag is record
        write : t_rmap_target_mem_wr_flag;
        read  : t_rmap_target_mem_rd_flag;
    end record t_rmap_target_mem_flag;

    -- rmap error injection

    type t_rmap_errinj_control is record
        rmap_error_trg : std_logic;
        rmap_error_id  : std_logic_vector(7 downto 0);
        rmap_error_val : std_logic_vector(31 downto 0);
    end record t_rmap_errinj_control;

    type t_rmap_errinj_status is record
        rmap_error_applied : std_logic;
    end record t_rmap_errinj_status;

    constant c_RMAP_ERRINJ_CONTROL_RST : t_rmap_errinj_control := (
        rmap_error_trg => '0',
        rmap_error_id  => (others => '0'),
        rmap_error_val => (others => '0')
    );

    constant c_RMAP_ERRINJ_STATUS_RST : t_rmap_errinj_status := (
        rmap_error_applied => '0'
    );

    constant c_RMAP_ERRINJ_ERR_ID_INIT_LOG_ADDR      : std_logic_vector(7 downto 0) := x"00";
    constant c_RMAP_ERRINJ_ERR_ID_INSTRUCTIONS       : std_logic_vector(7 downto 0) := x"01";
    constant c_RMAP_ERRINJ_ERR_ID_INS_PKT_TYPE       : std_logic_vector(7 downto 0) := x"02";
    constant c_RMAP_ERRINJ_ERR_ID_INS_CMD_WRITE_READ : std_logic_vector(7 downto 0) := x"03";
    constant c_RMAP_ERRINJ_ERR_ID_INS_CMD_VERIF_DATA : std_logic_vector(7 downto 0) := x"04";
    constant c_RMAP_ERRINJ_ERR_ID_INS_CMD_REPLY      : std_logic_vector(7 downto 0) := x"05";
    constant c_RMAP_ERRINJ_ERR_ID_INS_CMD_INC_ADDR   : std_logic_vector(7 downto 0) := x"06";
    constant c_RMAP_ERRINJ_ERR_ID_INS_REPLY_ADDR_LEN : std_logic_vector(7 downto 0) := x"07";
    constant c_RMAP_ERRINJ_ERR_ID_STATUS             : std_logic_vector(7 downto 0) := x"08";
    constant c_RMAP_ERRINJ_ERR_ID_TARG_LOG_ADDR      : std_logic_vector(7 downto 0) := x"09";
    constant c_RMAP_ERRINJ_ERR_ID_TRANSACTION_ID     : std_logic_vector(7 downto 0) := x"0A";
    constant c_RMAP_ERRINJ_ERR_ID_DATA_LENGTH        : std_logic_vector(7 downto 0) := x"0B";
    constant c_RMAP_ERRINJ_ERR_ID_HEADER_CRC         : std_logic_vector(7 downto 0) := x"0C";
    constant c_RMAP_ERRINJ_ERR_ID_HEADER_EEP         : std_logic_vector(7 downto 0) := x"0D";
    constant c_RMAP_ERRINJ_ERR_ID_DATA_CRC           : std_logic_vector(7 downto 0) := x"0E";
    constant c_RMAP_ERRINJ_ERR_ID_DATA_EEP           : std_logic_vector(7 downto 0) := x"0F";
    constant c_RMAP_ERRINJ_ERR_ID_MISSING_RESPONSE   : std_logic_vector(7 downto 0) := x"10";

    -- F-FEE specific constants

    ----------------------------------------------------------------------------------
    -- Start Address | End Address | Size (bytes) | Target | Description            --
    ----------------------------------------------------------------------------------
    --   0x00000000  | 0x000000FF  |     256      |  DEB   | Critical Configuration --
    --   0x00000100  | 0x00000FFF  |     3840     |  DEB   | General Configuration  --
    --   0x00001000  | 0x00001FFF  |     4096     |  DEB   | Housekeeping           --
    --   0x00002000  | 0x00002FFF  |     4096     |  DEB   | Windowing              --
    --   0x00010000  | 0x000100FF  |     256      |  AEB1  | Critical Configuration --
    --   0x00010100  | 0x00010FFF  |     3840     |  AEB1  | General Configuration  --
    --   0x00011000  | 0x00011FFF  |     4096     |  AEB1  | Housekeeping           --
    --   0x00020000  | 0x000200FF  |     256      |  AEB2  | Critical Configuration --
    --   0x00020100  | 0x00020FFF  |     3840     |  AEB2  | General Configuration  --
    --   0x00021000  | 0x00021FFF  |     4096     |  AEB2  | Housekeeping           --
    --   0x00040000  | 0x000400FF  |     256      |  AEB3  | Critical Configuration --
    --   0x00040100  | 0x00040FFF  |     3840     |  AEB3  | General Configuration  --
    --   0x00041000  | 0x00041FFF  |     4096     |  AEB3  | Housekeeping           --
    --   0x00080000  | 0x000800FF  |     256      |  AEB4  | Critical Configuration --
    --   0x00080100  | 0x00080FFF  |     3840     |  AEB4  | General Configuration  --
    --   0x00081000  | 0x00081FFF  |     4096     |  AEB4  | Housekeeping           --
    ----------------------------------------------------------------------------------

    constant c_RMAP_FFEE_CRTCFG_FIXED_DATA_LENGTH  : unsigned(23 downto 0) := x"000004"; -- Requests to the critical configuration areas have a fixed data length of 4 bytes
    constant c_RMAP_FFEE_GENCFG_HK_MAX_DATA_LENGTH : unsigned(23 downto 0) := x"000100"; -- Requests to the general configuration and housekeeping areas have a maximum data length of 256 bytes
    constant c_RMAP_FFEE_WIN_MAX_DATA_LENGTH       : unsigned(23 downto 0) := x"001000"; -- Requests to the windowing area have a maximum data length of 4096 bytes

    constant c_RMAP_FFEE_DATA_ALIGNMENT_SIZE : natural                                                          := 2; -- The address shall be 32-bit (4 byte) aligned (last 2 bits cleared)
    constant c_RMAP_FFEE_DATA_ALIGNMENT_MASK : std_logic_vector((c_RMAP_FFEE_DATA_ALIGNMENT_SIZE - 1) downto 0) := (others => '0'); -- Bit mask for alignment verification

    constant c_RMAP_FFEE_DEB_CRTCFG_START_ADDR : unsigned(31 downto 0) := x"00000000"; -- DEB Critical Configuration Start Address
    constant c_RMAP_FFEE_DEB_CRTCFG_END_ADDR   : unsigned(31 downto 0) := x"000000FF"; -- DEB Critical Configuration End Address
    constant c_RMAP_FFEE_DEB_GENCFG_START_ADDR : unsigned(31 downto 0) := x"00000100"; -- DEB General Configuration Start Address
    constant c_RMAP_FFEE_DEB_GENCFG_END_ADDR   : unsigned(31 downto 0) := x"00000FFF"; -- DEB General Configuration End Address
    constant c_RMAP_FFEE_DEB_HK_START_ADDR     : unsigned(31 downto 0) := x"00001000"; -- DEB Housekeeping Start Address
    constant c_RMAP_FFEE_DEB_HK_END_ADDR       : unsigned(31 downto 0) := x"00001FFF"; -- DEB Housekeeping End Address
    constant c_RMAP_FFEE_DEB_WIN_START_ADDR    : unsigned(31 downto 0) := x"00002000"; -- DEB Windowing Start Address
    constant c_RMAP_FFEE_DEB_WIN_END_ADDR      : unsigned(31 downto 0) := x"00002FFF"; -- DEB Windowing End Address

    constant c_RMAP_FFEE_AEB1_CRTCFG_START_ADDR : unsigned(31 downto 0) := x"00010000"; -- AEB1 Critical Configuration Start Address
    constant c_RMAP_FFEE_AEB1_CRTCFG_END_ADDR   : unsigned(31 downto 0) := x"000100FF"; -- AEB1 Critical Configuration End Address
    constant c_RMAP_FFEE_AEB1_GENCFG_START_ADDR : unsigned(31 downto 0) := x"00010100"; -- AEB1 General Configuration Start Address
    constant c_RMAP_FFEE_AEB1_GENCFG_END_ADDR   : unsigned(31 downto 0) := x"00010FFF"; -- AEB1 General Configuration End Address
    constant c_RMAP_FFEE_AEB1_HK_START_ADDR     : unsigned(31 downto 0) := x"00011000"; -- AEB1 Housekeeping Start Address
    constant c_RMAP_FFEE_AEB1_HK_END_ADDR       : unsigned(31 downto 0) := x"00011FFF"; -- AEB1 Housekeeping End Address

    constant c_RMAP_FFEE_AEB2_CRTCFG_START_ADDR : unsigned(31 downto 0) := x"00020000"; -- AEB2 Critical Configuration Start Address
    constant c_RMAP_FFEE_AEB2_CRTCFG_END_ADDR   : unsigned(31 downto 0) := x"000200FF"; -- AEB2 Critical Configuration End Address
    constant c_RMAP_FFEE_AEB2_GENCFG_START_ADDR : unsigned(31 downto 0) := x"00020100"; -- AEB2 General Configuration Start Address
    constant c_RMAP_FFEE_AEB2_GENCFG_END_ADDR   : unsigned(31 downto 0) := x"00020FFF"; -- AEB2 General Configuration End Address
    constant c_RMAP_FFEE_AEB2_HK_START_ADDR     : unsigned(31 downto 0) := x"00021000"; -- AEB2 Housekeeping Start Address
    constant c_RMAP_FFEE_AEB2_HK_END_ADDR       : unsigned(31 downto 0) := x"00021FFF"; -- AEB2 Housekeeping End Address

    constant c_RMAP_FFEE_AEB3_CRTCFG_START_ADDR : unsigned(31 downto 0) := x"00040000"; -- AEB3 Critical Configuration Start Address
    constant c_RMAP_FFEE_AEB3_CRTCFG_END_ADDR   : unsigned(31 downto 0) := x"000400FF"; -- AEB3 Critical Configuration End Address
    constant c_RMAP_FFEE_AEB3_GENCFG_START_ADDR : unsigned(31 downto 0) := x"00040100"; -- AEB3 General Configuration Start Address
    constant c_RMAP_FFEE_AEB3_GENCFG_END_ADDR   : unsigned(31 downto 0) := x"00040FFF"; -- AEB3 General Configuration End Address
    constant c_RMAP_FFEE_AEB3_HK_START_ADDR     : unsigned(31 downto 0) := x"00041000"; -- AEB3 Housekeeping Start Address
    constant c_RMAP_FFEE_AEB3_HK_END_ADDR       : unsigned(31 downto 0) := x"00041FFF"; -- AEB3 Housekeeping End Address

    constant c_RMAP_FFEE_AEB4_CRTCFG_START_ADDR : unsigned(31 downto 0) := x"00080000"; -- AEB4 Critical Configuration Start Address
    constant c_RMAP_FFEE_AEB4_CRTCFG_END_ADDR   : unsigned(31 downto 0) := x"000800FF"; -- AEB4 Critical Configuration End Address
    constant c_RMAP_FFEE_AEB4_GENCFG_START_ADDR : unsigned(31 downto 0) := x"00080100"; -- AEB4 General Configuration Start Address
    constant c_RMAP_FFEE_AEB4_GENCFG_END_ADDR   : unsigned(31 downto 0) := x"00080FFF"; -- AEB4 General Configuration End Address
    constant c_RMAP_FFEE_AEB4_HK_START_ADDR     : unsigned(31 downto 0) := x"00081000"; -- AEB4 Housekeeping Start Address
    constant c_RMAP_FFEE_AEB4_HK_END_ADDR       : unsigned(31 downto 0) := x"00081FFF"; -- AEB4 Housekeeping End Address

end package rmap_target_pkg;

--============================================================================
-- ! package body declaration
--============================================================================
package body rmap_target_pkg is

end package body rmap_target_pkg;
--============================================================================
-- package body end
--============================================================================