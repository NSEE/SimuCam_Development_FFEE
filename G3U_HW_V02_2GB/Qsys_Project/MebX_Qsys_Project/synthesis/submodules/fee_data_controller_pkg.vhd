library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package fee_data_controller_pkg is

    -- send buffer overflow enable ccontants
    constant c_SEND_BUFFER_OVERFLOW_ENABLE  : std_logic := '0'; -- '0': send buffer does not overflow / '1': send buffer overflow
    constant c_MASKING_FIFO_OVERFLOW_ENABLE : std_logic := '0'; -- '0': masking fifo does not overflow / '1': masking fifo overflow 

    -- data packet mode constants (need to be defined as literals to be use in a case statement)
    constant c_DPKT_OFF_MODE                   : std_logic_vector(4 downto 0) := "00000"; -- d0 : F-FEE Off Mode
    constant c_DPKT_ON_MODE                    : std_logic_vector(4 downto 0) := "00001"; -- d1 : F-FEE On Mode
    constant c_DPKT_FULLIMAGE_PATTERN_DEB_MODE : std_logic_vector(4 downto 0) := "00010"; -- d2 : F-FEE Full-Image Pattern DEB Mode
    constant c_DPKT_WINDOWING_PATTERN_DEB_MODE : std_logic_vector(4 downto 0) := "00011"; -- d3 : F-FEE Windowing Pattern DEB Mode
    constant c_DPKT_STANDBY_MODE               : std_logic_vector(4 downto 0) := "00100"; -- d4 : F-FEE Standby Mode
    constant c_DPKT_FULLIMAGE_PATTERN_AEB_MODE : std_logic_vector(4 downto 0) := "00101"; -- d5 : F-FEE Full-Image Pattern AEB Mode
    constant c_DPKT_WINDOWING_PATTERN_AEB_MODE : std_logic_vector(4 downto 0) := "00110"; -- d6 : F-FEE Windowing Pattern AEB Mode
    constant c_DPKT_FULLIMAGE_MODE             : std_logic_vector(4 downto 0) := "00111"; -- d7 : F-FEE Full-Image Mode
    constant c_DPKT_WINDOWING_MODE             : std_logic_vector(4 downto 0) := "01000"; -- d8 : F-FEE Windowing Mode

    -- fee data packet header data --
    -- data packet header size [bytes]
    constant c_COMM_FFEE_DATA_PKT_HEADER_SIZE_NUMERIC : natural                       := 11; -- header size is 11 bytes
    constant c_COMM_FFEE_DATA_PKT_HEADER_SIZE         : unsigned(15 downto 0)         := x"000B"; -- header size is 11 bytes
    -- hk packet data size [bytes]
    constant c_COMM_FFEE_DEB_HK_PKT_DATA_SIZE         : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(18, 16));
    constant c_COMM_FFEE_AEB_HK_PKT_DATA_SIZE         : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(128, 16));
    -- type field, mode bits
    constant c_COMM_FFEE_INVALID_MODE                 : std_logic_vector(2 downto 0)  := (others => '1');
    constant c_COMM_FFEE_FULL_IMAGE_MODE              : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(0, 3));
    constant c_COMM_FFEE_FULL_IMAGE_PATTERN_MODE      : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(1, 3));
    constant c_COMM_FFEE_WINDOWING_MODE               : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(2, 3));
    constant c_COMM_FFEE_WINDOWING_PATTERN_MODE       : std_logic_vector(2 downto 0)  := std_logic_vector(to_unsigned(3, 3));
    -- type field, packet type bits
    constant c_COMM_FFEE_INVALID_PACKET               : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(0, 2));
    constant c_COMM_FFEE_DATA_PACKET                  : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(0, 2));
    constant c_COMM_FFEE_OVERSCAN_DATA                : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(1, 2));
    constant c_COMM_FFEE_DEB_HOUSEKEEPING_PACKET      : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(2, 2));
    constant c_COMM_FFEE_AEB_HOUSEKEEPING_PACKET      : std_logic_vector(1 downto 0)  := std_logic_vector(to_unsigned(3, 2));

    -- ccd side constants
    constant c_COMM_FFEE_CCD_SIDE_E : std_logic := '0'; -- side e = left side
    constant c_COMM_FFEE_CCD_SIDE_F : std_logic := '1'; -- side f = right side

    -- packet order constants
    constant c_PKTORDER_LEFT_PACKET  : std_logic := '1'; -- left buffer package
    constant c_PKTORDER_RIGHT_PACKET : std_logic := '0'; -- right buffer package

    -- crc size constant
    -- crc is added after the send buffer, so its size need to be disconted from the send buffer config lenght to ensure the right packet size
    constant c_COMM_DT_CRC_SIZE : unsigned(15 downto 0) := x"0002"; -- crc size is 2 bytes (1 for header crc and 1 for data crc)

    -- reserved byte field cosntant
    constant c_COMM_DPKT_RESERVED_FIELD_VAL : std_logic_vector(7 downto 0) := x"00";

    -- hk packet address range
    constant c_COMM_FFEE_DEB_HK_RMAP_RESET_BYTE_ADDR : std_logic_vector(31 downto 0) := x"00000000";
    constant c_COMM_FFEE_DEB_HK_RMAP_FIRST_BYTE_ADDR : std_logic_vector(31 downto 0) := x"00001000";
    constant c_COMM_FFEE_DEB_HK_RMAP_LAST_BYTE_ADDR  : std_logic_vector(31 downto 0) := x"00001017";
    constant c_COMM_FFEE_AEB_HK_RMAP_RESET_BYTE_ADDR : std_logic_vector(31 downto 0) := x"00000000";
    constant c_COMM_FFEE_AEB_HK_RMAP_FIRST_BYTE_ADDR : std_logic_vector(31 downto 0) := x"00001000";
    constant c_COMM_FFEE_AEB_HK_RMAP_LAST_BYTE_ADDR  : std_logic_vector(31 downto 0) := x"0000107F";
    -- offsets for rmap areas
    constant c_COMM_FFEE_RMAP_DEB_ADDR_OFFSET        : std_logic_vector(31 downto 0) := x"00000000"; -- addr offset: 0x0000XXXX
    constant c_COMM_FFEE_RMAP_AEB1_ADDR_OFFSET       : std_logic_vector(31 downto 0) := x"00010000"; -- addr offset: 0x0001XXXX
    constant c_COMM_FFEE_RMAP_AEB2_ADDR_OFFSET       : std_logic_vector(31 downto 0) := x"00020000"; -- addr offset: 0x0002XXXX
    constant c_COMM_FFEE_RMAP_AEB3_ADDR_OFFSET       : std_logic_vector(31 downto 0) := x"00040000"; -- addr offset: 0x0004XXXX
    constant c_COMM_FFEE_RMAP_AEB4_ADDR_OFFSET       : std_logic_vector(31 downto 0) := x"00080000"; -- addr offset: 0x0008XXXX

    -- housekeep writer type
    type t_comm_dpkt_hk_type is (
        e_COMM_DPKT_DEB_HK,
        e_COMM_DPKT_AEB1_HK,
        e_COMM_DPKT_AEB2_HK,
        e_COMM_DPKT_AEB3_HK,
        e_COMM_DPKT_AEB4_HK
    );

    -- fee data packet headerdata type field record
    type t_fee_dpkt_headerdata_type_field is record
        mode         : std_logic_vector(3 downto 0);
        last_packet  : std_logic;
        ccd_side     : std_logic;
        ccd_number   : std_logic_vector(1 downto 0);
        frame_number : std_logic_vector(1 downto 0);
        packet_type  : std_logic_vector(1 downto 0);
    end record t_fee_dpkt_headerdata_type_field;

    -- fee data packet headerdata record
    type t_fee_dpkt_headerdata is record
        logical_address  : std_logic_vector(7 downto 0);
        protocol_id      : std_logic_vector(7 downto 0);
        length_field     : std_logic_vector(15 downto 0);
        type_field       : t_fee_dpkt_headerdata_type_field;
        frame_counter    : std_logic_vector(15 downto 0);
        sequence_counter : std_logic_vector(15 downto 0);
    end record t_fee_dpkt_headerdata;

    -- fee data packet general control record
    type t_fee_dpkt_general_control is record
        start : std_logic;
        reset : std_logic;
    end record t_fee_dpkt_general_control;

    -- fee data packet general status record
    type t_fee_dpkt_general_status is record
        finished : std_logic;
    end record t_fee_dpkt_general_status;

    -- fee data packet image parameters record
    type t_fee_dpkt_image_params is record
        logical_addr               : std_logic_vector(7 downto 0);
        protocol_id                : std_logic_vector(7 downto 0);
        ccd_x_size                 : std_logic_vector(15 downto 0);
        ccd_y_size                 : std_logic_vector(15 downto 0);
        data_y_size                : std_logic_vector(15 downto 0);
        overscan_y_size            : std_logic_vector(15 downto 0);
        packet_length              : std_logic_vector(15 downto 0);
        fee_mode_hk                : std_logic_vector(2 downto 0);
        fee_mode_left_buffer       : std_logic_vector(2 downto 0);
        fee_mode_right_buffer      : std_logic_vector(2 downto 0);
        ccd_number_hk              : std_logic_vector(1 downto 0);
        ccd_number_left_buffer     : std_logic_vector(1 downto 0);
        ccd_number_right_buffer    : std_logic_vector(1 downto 0);
        ccd_id_left_buffer         : std_logic_vector(1 downto 0);
        ccd_id_right_buffer        : std_logic_vector(1 downto 0);
        ccd_side_hk                : std_logic;
        ccd_side_left_buffer       : std_logic;
        ccd_side_right_buffer      : std_logic;
        ccd_v_start                : std_logic_vector(15 downto 0);
        ccd_v_end                  : std_logic_vector(15 downto 0);
        ccd_img_v_end_left_buffer  : std_logic_vector(15 downto 0);
        ccd_img_v_end_right_buffer : std_logic_vector(15 downto 0);
        ccd_ovs_v_end_left_buffer  : std_logic_vector(15 downto 0);
        ccd_ovs_v_end_right_buffer : std_logic_vector(15 downto 0);
        ccd_h_start                : std_logic_vector(15 downto 0);
        ccd_h_end_left_buffer      : std_logic_vector(15 downto 0);
        ccd_h_end_right_buffer     : std_logic_vector(15 downto 0);
        ccd_img_en_left_buffer     : std_logic;
        ccd_img_en_right_buffer    : std_logic;
        ccd_ovs_en_left_buffer     : std_logic;
        ccd_ovs_en_right_buffer    : std_logic;
        ccd_img_pixels_left        : std_logic_vector(31 downto 0);
        ccd_img_pixels_right       : std_logic_vector(31 downto 0);
        ccd_ovs_pixels_left        : std_logic_vector(31 downto 0);
        ccd_ovs_pixels_right       : std_logic_vector(31 downto 0);
        start_delay                : std_logic_vector(31 downto 0);
        line_delay                 : std_logic_vector(31 downto 0);
        skip_delay                 : std_logic_vector(31 downto 0);
        adc_delay                  : std_logic_vector(31 downto 0);
    end record t_fee_dpkt_image_params;

    -- fee data packet send buffer control record
    type t_fee_dpkt_send_buffer_control is record
        rdreq  : std_logic;
        change : std_logic;
    end record t_fee_dpkt_send_buffer_control;

    -- fee data packet send buffer status record
    type t_fee_dpkt_send_buffer_status is record
        stat_empty          : std_logic;
        stat_extended_usedw : std_logic_vector(15 downto 0);
        rddata              : std_logic_vector(7 downto 0);
        rddata_type         : std_logic_vector(1 downto 0);
        rddata_end          : std_logic;
        rdready             : std_logic;
    end record t_fee_dpkt_send_buffer_status;

    -- fee data packet transmission parameters record
    type t_fee_dpkt_transmission_params is record
        windowing_en              : std_logic;
        pattern_left_buffer_en    : std_logic;
        pattern_right_buffer_en   : std_logic;
        overflow_en               : std_logic;
        left_pixels_storage_size  : std_logic_vector(31 downto 0);
        right_pixels_storage_size : std_logic_vector(31 downto 0);
    end record t_fee_dpkt_transmission_params;

    -- fee data packet spacewire error injection parameters record
    type t_fee_dpkt_spw_errinj_params is record
        eep_received : std_logic;
        sequence_cnt : std_logic_vector(15 downto 0);
        n_repeat     : std_logic_vector(15 downto 0);
    end record t_fee_dpkt_spw_errinj_params;

    -- fee data packet transmission error injection parameters record
    type t_fee_dpkt_trans_errinj_params is record
        tx_disabled  : std_logic;
        missing_pkts : std_logic;
        missing_data : std_logic;
        frame_num    : std_logic_vector(1 downto 0);
        sequence_cnt : std_logic_vector(15 downto 0);
        data_cnt     : std_logic_vector(15 downto 0);
        n_repeat     : std_logic_vector(15 downto 0);
    end record t_fee_dpkt_trans_errinj_params;

    --	-- fee windowing parameters record
    --	type t_fee_windowing_params is record
    --		packet_order_list : std_logic_vector(511 downto 0);
    --		last_left_packet  : std_logic_vector(9 downto 0);
    --		last_right_packet : std_logic_vector(9 downto 0);
    --	end record t_fee_windowing_params;

    -- fee data packet registered parameters record
    type t_fee_dpkt_registered_params is record
        image        : t_fee_dpkt_image_params;
        transmission : t_fee_dpkt_transmission_params;
        spw_errinj   : t_fee_dpkt_spw_errinj_params;
        trans_errinj : t_fee_dpkt_trans_errinj_params;
        --		windowing    : t_fee_windowing_params;
    end record t_fee_dpkt_registered_params;

end package fee_data_controller_pkg;

package body fee_data_controller_pkg is

end package body fee_data_controller_pkg;
