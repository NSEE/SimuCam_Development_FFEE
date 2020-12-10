# TCL File Generated by Component Editor 18.1
# Wed Jun 12 14:05:05 BRT 2019
# DO NOT MODIFY


# 
# FTDI_UMFT601A_Module "FTDI_UMFT601A_Module" v2.4
#  2019.06.12.14:05:05
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module FTDI_UMFT601A_Module
# 
set_module_property DESCRIPTION ""
set_module_property NAME FTDI_UMFT601A_Module
set_module_property VERSION 2.4
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME FTDI_UMFT601A_Module
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL ftdi_usb3_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file ftdi_config_avalon_mm_registers_pkg.vhd VHDL PATH Ftdi_Usb3/REGISTERS/ftdi_config_avalon_mm_registers_pkg.vhd
add_fileset_file ftdi_config_avalon_mm_pkg.vhd VHDL PATH Ftdi_Usb3/CONFIG_AVALON_MM/ftdi_config_avalon_mm_pkg.vhd
add_fileset_file ftdi_config_avalon_mm_read_ent.vhd VHDL PATH Ftdi_Usb3/CONFIG_AVALON_MM/ftdi_config_avalon_mm_read_ent.vhd
add_fileset_file ftdi_config_avalon_mm_write_ent.vhd VHDL PATH Ftdi_Usb3/CONFIG_AVALON_MM/ftdi_config_avalon_mm_write_ent.vhd
add_fileset_file ftdi_config_avalon_mm_stimulli.vhd VHDL PATH Ftdi_Usb3/CONFIG_AVALON_MM/ftdi_config_avalon_mm_stimulli.vhd
add_fileset_file ftdi_avm_usb3_pkg.vhd VHDL PATH Ftdi_Usb3/FTDI_AVALON_MM_MASTER_USB3/ftdi_avm_usb3_pkg.vhd
add_fileset_file ftdi_avm_usb3_reader_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_AVALON_MM_MASTER_USB3/ftdi_avm_usb3_reader_ent.vhd
add_fileset_file ftdi_avm_usb3_writer_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_AVALON_MM_MASTER_USB3/ftdi_avm_usb3_writer_ent.vhd
add_fileset_file ftdi_tx_avm_reader_controller_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_AMV_CONTROLLER/ftdi_tx_avm_reader_controller_ent.vhd
add_fileset_file ftdi_rx_avm_writer_controller_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_AMV_CONTROLLER/ftdi_rx_avm_writer_controller_ent.vhd
add_fileset_file data_buffer_sc_fifo.vhd VHDL PATH Ftdi_Usb3/DATA_BUFFERS/altera_ip/scfifo/data_buffer_sc_fifo/data_buffer_sc_fifo.vhd
add_fileset_file data_buffer_ent.vhd VHDL PATH Ftdi_Usb3/DATA_BUFFERS/data_buffer_ent.vhd
add_fileset_file ftdi_avm_imgt_pkg.vhd VHDL PATH Ftdi_Usb3/FTDI_AVALON_MM_MASTER_IMGT/ftdi_avm_imgt_pkg.vhd
add_fileset_file ftdi_avm_imgt_writer_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_AVALON_MM_MASTER_IMGT/ftdi_avm_imgt_writer_ent.vhd
add_fileset_file ftdi_imgt_buffer_sc_fifo.vhd VHDL PATH Ftdi_Usb3/FTDI_IMGT_BUFFER/altera_ip/scfifo/ftdi_imgt_buffer_sc_fifo/ftdi_imgt_buffer_sc_fifo.vhd
add_fileset_file ftdi_imgt_buffer_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_IMGT_BUFFER/ftdi_imgt_buffer_ent.vhd
add_fileset_file ftdi_imgt_controller_data_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_IMGT_CONTROLLER/ftdi_imgt_controller_data_ent.vhd
add_fileset_file ftdi_imgt_controller_ccd_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_IMGT_CONTROLLER/ftdi_imgt_controller_ccd_ent.vhd
add_fileset_file ftdi_imgt_controller_imagette_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_IMGT_CONTROLLER/ftdi_imgt_controller_imagette_ent.vhd
add_fileset_file ftdi_imgt_controller_top.vhd VHDL PATH Ftdi_Usb3/FTDI_IMGT_CONTROLLER/ftdi_imgt_controller_top.vhd
add_fileset_file delay_block_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/delay_block_ent.vhd
add_fileset_file ftdi_protocol_pkg.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_protocol_pkg.vhd
add_fileset_file ftdi_protocol_top.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_protocol_top.vhd
add_fileset_file ftdi_rx_protocol_header_parser_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_rx_protocol_header_parser_ent.vhd
add_fileset_file ftdi_rx_protocol_payload_reader_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_rx_protocol_payload_reader_ent.vhd
add_fileset_file ftdi_tx_protocol_header_generator_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_tx_protocol_header_generator_ent.vhd
add_fileset_file ftdi_tx_protocol_payload_writer_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_tx_protocol_payload_writer_ent.vhd
add_fileset_file ftdi_rx_protocol_imgt_payload_reader_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_rx_protocol_imgt_payload_reader_ent.vhd
add_fileset_file ftdi_protocol_img_controller_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_protocol_img_controller_ent.vhd
add_fileset_file ftdi_protocol_lut_controller_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_protocol_lut_controller_ent.vhd
add_fileset_file ftdi_protocol_pat_controller_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_protocol_pat_controller_ent.vhd
add_fileset_file ftdi_protocol_crc_pkg.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_protocol_crc_pkg.vhd
add_fileset_file ftdi_data_dc_fifo.vhd VHDL PATH Ftdi_Usb3/FTDI_CONTROLLER/altera_ip/dcfifo/ftdi_data_dc_fifo/ftdi_data_dc_fifo.vhd
add_fileset_file ftdi_inout_io_buffer_39b.vhd VHDL PATH Ftdi_Usb3/FTDI_CONTROLLER/altera_ip/iobuffer/ftdi_inout_io_buffer_39b/ftdi_inout_io_buffer_39b.vhd
add_fileset_file ftdi_in_io_buffer_3b.vhd VHDL PATH Ftdi_Usb3/FTDI_CONTROLLER/altera_ip/iobuffer/ftdi_in_io_buffer_3b/ftdi_in_io_buffer_3b.vhd
add_fileset_file ftdi_out_io_buffer_5b.vhd VHDL PATH Ftdi_Usb3/FTDI_CONTROLLER/altera_ip/iobuffer/ftdi_out_io_buffer_5b/ftdi_out_io_buffer_5b.vhd
add_fileset_file flipflop_synchronizer_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_CONTROLLER/flipflop_synchronizer_ent.vhd
add_fileset_file ftdi_umft601a_controller_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_CONTROLLER/ftdi_umft601a_controller_ent.vhd
add_fileset_file ftdi_irq_manager_pkg.vhd VHDL PATH Ftdi_Usb3/IRQ_MANAGER/ftdi_irq_manager_pkg.vhd
add_fileset_file ftdi_rx_irq_manager_ent.vhd VHDL PATH Ftdi_Usb3/IRQ_MANAGER/ftdi_rx_irq_manager_ent.vhd
add_fileset_file ftdi_tx_irq_manager_ent.vhd VHDL PATH Ftdi_Usb3/IRQ_MANAGER/ftdi_tx_irq_manager_ent.vhd
add_fileset_file ftdi_usb3_top.vhd VHDL PATH Ftdi_Usb3/ftdi_usb3_top.vhd TOP_LEVEL_FILE

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL ftdi_usb3_top
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file ftdi_config_avalon_mm_registers_pkg.vhd VHDL PATH Ftdi_Usb3/REGISTERS/ftdi_config_avalon_mm_registers_pkg.vhd
add_fileset_file ftdi_config_avalon_mm_pkg.vhd VHDL PATH Ftdi_Usb3/CONFIG_AVALON_MM/ftdi_config_avalon_mm_pkg.vhd
add_fileset_file ftdi_config_avalon_mm_read_ent.vhd VHDL PATH Ftdi_Usb3/CONFIG_AVALON_MM/ftdi_config_avalon_mm_read_ent.vhd
add_fileset_file ftdi_config_avalon_mm_write_ent.vhd VHDL PATH Ftdi_Usb3/CONFIG_AVALON_MM/ftdi_config_avalon_mm_write_ent.vhd
add_fileset_file ftdi_config_avalon_mm_stimulli.vhd VHDL PATH Ftdi_Usb3/CONFIG_AVALON_MM/ftdi_config_avalon_mm_stimulli.vhd
add_fileset_file ftdi_avm_usb3_pkg.vhd VHDL PATH Ftdi_Usb3/FTDI_AVALON_MM_MASTER_USB3/ftdi_avm_usb3_pkg.vhd
add_fileset_file ftdi_avm_usb3_reader_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_AVALON_MM_MASTER_USB3/ftdi_avm_usb3_reader_ent.vhd
add_fileset_file ftdi_avm_usb3_writer_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_AVALON_MM_MASTER_USB3/ftdi_avm_usb3_writer_ent.vhd
add_fileset_file ftdi_tx_avm_reader_controller_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_AMV_CONTROLLER/ftdi_tx_avm_reader_controller_ent.vhd
add_fileset_file ftdi_rx_avm_writer_controller_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_AMV_CONTROLLER/ftdi_rx_avm_writer_controller_ent.vhd
add_fileset_file data_buffer_sc_fifo.vhd VHDL PATH Ftdi_Usb3/DATA_BUFFERS/altera_ip/scfifo/data_buffer_sc_fifo/data_buffer_sc_fifo.vhd
add_fileset_file data_buffer_ent.vhd VHDL PATH Ftdi_Usb3/DATA_BUFFERS/data_buffer_ent.vhd
add_fileset_file ftdi_imgt_buffer_sc_fifo.vhd VHDL PATH Ftdi_Usb3/FTDI_IMGT_BUFFER/altera_ip/scfifo/ftdi_imgt_buffer_sc_fifo/ftdi_imgt_buffer_sc_fifo.vhd
add_fileset_file ftdi_imgt_buffer_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_IMGT_BUFFER/ftdi_imgt_buffer_ent.vhd
add_fileset_file delay_block_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/delay_block_ent.vhd
add_fileset_file ftdi_protocol_pkg.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_protocol_pkg.vhd
add_fileset_file ftdi_protocol_top.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_protocol_top.vhd
add_fileset_file ftdi_rx_protocol_header_parser_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_rx_protocol_header_parser_ent.vhd
add_fileset_file ftdi_rx_protocol_payload_reader_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_rx_protocol_payload_reader_ent.vhd
add_fileset_file ftdi_tx_protocol_header_generator_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_tx_protocol_header_generator_ent.vhd
add_fileset_file ftdi_tx_protocol_payload_writer_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_tx_protocol_payload_writer_ent.vhd
add_fileset_file ftdi_rx_protocol_imgt_payload_reader_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_rx_protocol_imgt_payload_reader_ent.vhd
add_fileset_file ftdi_protocol_img_controller_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_protocol_img_controller_ent.vhd
add_fileset_file ftdi_protocol_lut_controller_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_protocol_lut_controller_ent.vhd
add_fileset_file ftdi_protocol_pat_controller_ent.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_protocol_pat_controller_ent.vhd
add_fileset_file ftdi_protocol_crc_pkg.vhd VHDL PATH Ftdi_Usb3/PROTOCOL/ftdi_protocol_crc_pkg.vhd
add_fileset_file ftdi_data_dc_fifo.vhd VHDL PATH Ftdi_Usb3/FTDI_CONTROLLER/altera_ip/dcfifo/ftdi_data_dc_fifo/ftdi_data_dc_fifo.vhd
add_fileset_file ftdi_inout_io_buffer_39b.vhd VHDL PATH Ftdi_Usb3/FTDI_CONTROLLER/altera_ip/iobuffer/ftdi_inout_io_buffer_39b/ftdi_inout_io_buffer_39b.vhd
add_fileset_file ftdi_in_io_buffer_3b.vhd VHDL PATH Ftdi_Usb3/FTDI_CONTROLLER/altera_ip/iobuffer/ftdi_in_io_buffer_3b/ftdi_in_io_buffer_3b.vhd
add_fileset_file ftdi_out_io_buffer_5b.vhd VHDL PATH Ftdi_Usb3/FTDI_CONTROLLER/altera_ip/iobuffer/ftdi_out_io_buffer_5b/ftdi_out_io_buffer_5b.vhd
add_fileset_file flipflop_synchronizer_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_CONTROLLER/flipflop_synchronizer_ent.vhd
add_fileset_file ftdi_umft601a_controller_ent.vhd VHDL PATH Ftdi_Usb3/FTDI_CONTROLLER/ftdi_umft601a_controller_ent.vhd
add_fileset_file ftdi_irq_manager_pkg.vhd VHDL PATH Ftdi_Usb3/IRQ_MANAGER/ftdi_irq_manager_pkg.vhd
add_fileset_file ftdi_rx_irq_manager_ent.vhd VHDL PATH Ftdi_Usb3/IRQ_MANAGER/ftdi_rx_irq_manager_ent.vhd
add_fileset_file ftdi_tx_irq_manager_ent.vhd VHDL PATH Ftdi_Usb3/IRQ_MANAGER/ftdi_tx_irq_manager_ent.vhd
add_fileset_file ftdi_usb3_top.vhd VHDL PATH Ftdi_Usb3/ftdi_usb3_top.vhd TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock_sink
# 
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 100000000
set_interface_property clock_sink ENABLED true
set_interface_property clock_sink EXPORT_OF ""
set_interface_property clock_sink PORT_NAME_MAP ""
set_interface_property clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink SVD_ADDRESS_GROUP ""

add_interface_port clock_sink clock_sink_clk_i clk Input 1


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink reset_sink_reset_i reset Input 1


# 
# connection point umft601a_clock_sink
# 
add_interface umft601a_clock_sink clock end
set_interface_property umft601a_clock_sink clockRate 100000000
set_interface_property umft601a_clock_sink ENABLED true
set_interface_property umft601a_clock_sink EXPORT_OF ""
set_interface_property umft601a_clock_sink PORT_NAME_MAP ""
set_interface_property umft601a_clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property umft601a_clock_sink SVD_ADDRESS_GROUP ""

add_interface_port umft601a_clock_sink umft601a_clock_sink_clk_i clk Input 1


# 
# connection point conduit_umft601a_pins
# 
add_interface conduit_umft601a_pins conduit end
set_interface_property conduit_umft601a_pins associatedClock clock_sink
set_interface_property conduit_umft601a_pins associatedReset reset_sink
set_interface_property conduit_umft601a_pins ENABLED true
set_interface_property conduit_umft601a_pins EXPORT_OF ""
set_interface_property conduit_umft601a_pins PORT_NAME_MAP ""
set_interface_property conduit_umft601a_pins CMSIS_SVD_VARIABLES ""
set_interface_property conduit_umft601a_pins SVD_ADDRESS_GROUP ""

add_interface_port conduit_umft601a_pins umft601a_clock_pin_i umft_clock_signal Input 1
add_interface_port conduit_umft601a_pins umft601a_txe_n_pin_i umft_txe_n_signal Input 1
add_interface_port conduit_umft601a_pins umft601a_rxf_n_pin_i umft_rxf_n_signal Input 1
add_interface_port conduit_umft601a_pins umft601a_data_bus_io umft_data_signal Bidir 32
add_interface_port conduit_umft601a_pins umft601a_be_bus_io umft_be_signal Bidir 4
add_interface_port conduit_umft601a_pins umft601a_wakeup_n_pin_io umft_wakeup_n_signal Bidir 1
add_interface_port conduit_umft601a_pins umft601a_gpio_bus_io umft_gpio_bus_signal Bidir 2
add_interface_port conduit_umft601a_pins umft601a_reset_n_pin_o umft_reset_n_signal Output 1
add_interface_port conduit_umft601a_pins umft601a_wr_n_pin_o umft_wr_n_signal Output 1
add_interface_port conduit_umft601a_pins umft601a_rd_n_pin_o umft_rd_n_signal Output 1
add_interface_port conduit_umft601a_pins umft601a_oe_n_pin_o umft_oe_n_signal Output 1
add_interface_port conduit_umft601a_pins umft601a_siwu_n_pin_o umft_siwu_n_signal Output 1


# 
# connection point avalon_slave_config
# 
add_interface avalon_slave_config avalon end
set_interface_property avalon_slave_config addressUnits WORDS
set_interface_property avalon_slave_config associatedClock clock_sink
set_interface_property avalon_slave_config associatedReset reset_sink
set_interface_property avalon_slave_config bitsPerSymbol 8
set_interface_property avalon_slave_config burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_config burstcountUnits WORDS
set_interface_property avalon_slave_config explicitAddressSpan 0
set_interface_property avalon_slave_config holdTime 0
set_interface_property avalon_slave_config linewrapBursts false
set_interface_property avalon_slave_config maximumPendingReadTransactions 0
set_interface_property avalon_slave_config maximumPendingWriteTransactions 0
set_interface_property avalon_slave_config readLatency 0
set_interface_property avalon_slave_config readWaitTime 1
set_interface_property avalon_slave_config setupTime 0
set_interface_property avalon_slave_config timingUnits Cycles
set_interface_property avalon_slave_config writeWaitTime 0
set_interface_property avalon_slave_config ENABLED true
set_interface_property avalon_slave_config EXPORT_OF ""
set_interface_property avalon_slave_config PORT_NAME_MAP ""
set_interface_property avalon_slave_config CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_config SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_config avalon_slave_config_address_i address Input 8
#add_interface_port avalon_slave_config avalon_slave_config_byteenable_i byteenable Input 4
add_interface_port avalon_slave_config avalon_slave_config_write_i write Input 1
add_interface_port avalon_slave_config avalon_slave_config_writedata_i writedata Input 32
add_interface_port avalon_slave_config avalon_slave_config_read_i read Input 1
add_interface_port avalon_slave_config avalon_slave_config_readdata_o readdata Output 32
add_interface_port avalon_slave_config avalon_slave_config_waitrequest_o waitrequest Output 1
set_interface_assignment avalon_slave_config embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_config embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_config embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_config embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_master_data
# 
add_interface avalon_master_data avalon start
set_interface_property avalon_master_data addressUnits SYMBOLS
set_interface_property avalon_master_data associatedClock clock_sink
set_interface_property avalon_master_data associatedReset reset_sink
set_interface_property avalon_master_data bitsPerSymbol 8
set_interface_property avalon_master_data burstOnBurstBoundariesOnly false
set_interface_property avalon_master_data burstcountUnits WORDS
set_interface_property avalon_master_data doStreamReads false
set_interface_property avalon_master_data doStreamWrites false
set_interface_property avalon_master_data holdTime 0
set_interface_property avalon_master_data linewrapBursts false
set_interface_property avalon_master_data maximumPendingReadTransactions 0
set_interface_property avalon_master_data maximumPendingWriteTransactions 0
set_interface_property avalon_master_data readLatency 0
set_interface_property avalon_master_data readWaitTime 1
set_interface_property avalon_master_data setupTime 0
set_interface_property avalon_master_data timingUnits Cycles
set_interface_property avalon_master_data writeWaitTime 0
set_interface_property avalon_master_data ENABLED true
set_interface_property avalon_master_data EXPORT_OF ""
set_interface_property avalon_master_data PORT_NAME_MAP ""
set_interface_property avalon_master_data CMSIS_SVD_VARIABLES ""
set_interface_property avalon_master_data SVD_ADDRESS_GROUP ""

add_interface_port avalon_master_data avalon_master_data_readdata_i readdata Input 256
add_interface_port avalon_master_data avalon_master_data_waitrequest_i waitrequest Input 1
add_interface_port avalon_master_data avalon_master_data_address_o address Output 64
add_interface_port avalon_master_data avalon_master_data_read_o read Output 1
add_interface_port avalon_master_data avalon_master_data_write_o write Output 1
add_interface_port avalon_master_data avalon_master_data_writedata_o writedata Output 256


# 
# connection point avalon_imgt_master_data
# 
add_interface avalon_imgt_master_data avalon start
set_interface_property avalon_imgt_master_data addressUnits SYMBOLS
set_interface_property avalon_imgt_master_data associatedClock clock_sink
set_interface_property avalon_imgt_master_data associatedReset reset_sink
set_interface_property avalon_imgt_master_data bitsPerSymbol 8
set_interface_property avalon_imgt_master_data burstOnBurstBoundariesOnly false
set_interface_property avalon_imgt_master_data burstcountUnits WORDS
set_interface_property avalon_imgt_master_data doStreamReads false
set_interface_property avalon_imgt_master_data doStreamWrites false
set_interface_property avalon_imgt_master_data holdTime 0
set_interface_property avalon_imgt_master_data linewrapBursts false
set_interface_property avalon_imgt_master_data maximumPendingReadTransactions 0
set_interface_property avalon_imgt_master_data maximumPendingWriteTransactions 0
set_interface_property avalon_imgt_master_data readLatency 0
set_interface_property avalon_imgt_master_data readWaitTime 1
set_interface_property avalon_imgt_master_data setupTime 0
set_interface_property avalon_imgt_master_data timingUnits Cycles
set_interface_property avalon_imgt_master_data writeWaitTime 0
set_interface_property avalon_imgt_master_data ENABLED true
set_interface_property avalon_imgt_master_data EXPORT_OF ""
set_interface_property avalon_imgt_master_data PORT_NAME_MAP ""
set_interface_property avalon_imgt_master_data CMSIS_SVD_VARIABLES ""
set_interface_property avalon_imgt_master_data SVD_ADDRESS_GROUP ""

add_interface_port avalon_imgt_master_data avalon_imgt_master_data_waitrequest_i waitrequest Input 1
add_interface_port avalon_imgt_master_data avalon_imgt_master_data_address_o address Output 64
add_interface_port avalon_imgt_master_data avalon_imgt_master_data_write_o write Output 1
add_interface_port avalon_imgt_master_data avalon_imgt_master_data_writedata_o writedata Output 16


# 
# connection point rx_interrupt_sender
# 
add_interface rx_interrupt_sender interrupt end
set_interface_property rx_interrupt_sender associatedAddressablePoint ""
set_interface_property rx_interrupt_sender associatedClock clock_sink
set_interface_property rx_interrupt_sender associatedReset reset_sink
set_interface_property rx_interrupt_sender bridgedReceiverOffset ""
set_interface_property rx_interrupt_sender bridgesToReceiver ""
set_interface_property rx_interrupt_sender ENABLED true
set_interface_property rx_interrupt_sender EXPORT_OF ""
set_interface_property rx_interrupt_sender PORT_NAME_MAP ""
set_interface_property rx_interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property rx_interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port rx_interrupt_sender rx_interrupt_sender_irq_o irq Output 1


# 
# connection point tx_interrupt_sender
# 
add_interface tx_interrupt_sender interrupt end
set_interface_property tx_interrupt_sender associatedAddressablePoint ""
set_interface_property tx_interrupt_sender associatedClock clock_sink
set_interface_property tx_interrupt_sender associatedReset reset_sink
set_interface_property tx_interrupt_sender bridgedReceiverOffset ""
set_interface_property tx_interrupt_sender bridgesToReceiver ""
set_interface_property tx_interrupt_sender ENABLED true
set_interface_property tx_interrupt_sender EXPORT_OF ""
set_interface_property tx_interrupt_sender PORT_NAME_MAP ""
set_interface_property tx_interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property tx_interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port tx_interrupt_sender tx_interrupt_sender_irq_o irq Output 1

