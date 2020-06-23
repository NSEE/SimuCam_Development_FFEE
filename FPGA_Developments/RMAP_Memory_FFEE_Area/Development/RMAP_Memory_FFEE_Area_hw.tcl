# TCL File Generated by Component Editor 18.1
# Sat Apr 04 23:17:08 BRT 2020
# DO NOT MODIFY


# 
# RMAP_Memory_FFEE_Area "RMAP_Memory_FFEE_Area" v1
# rfranca 2020.04.04.23:17:08
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module RMAP_Memory_FFEE_Area
# 
set_module_property DESCRIPTION ""
set_module_property NAME RMAP_Memory_FFEE_Area
set_module_property VERSION 1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR rfranca
set_module_property DISPLAY_NAME RMAP_Memory_FFEE_Area
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL frme_rmap_memory_ffee_area_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file frme_avalon_mm_rmap_ffee_pkg.vhd VHDL PATH RMAP_Memory_FFEE_Area/AVALON_RMAP_REGISTERS/frme_avalon_mm_rmap_ffee_pkg.vhd
add_fileset_file frme_rmap_mem_area_ffee_pkg.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_RMAP_MEMORY/frme_rmap_mem_area_ffee_pkg.vhd
add_fileset_file frme_rmap_mem_area_ffee_arbiter_ent.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_RMAP_MEMORY/frme_rmap_mem_area_ffee_arbiter_ent.vhd
add_fileset_file frme_rmap_mem_area_ffee_read_ent.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_RMAP_MEMORY/frme_rmap_mem_area_ffee_read_ent.vhd
add_fileset_file frme_rmap_mem_area_ffee_write_ent.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_RMAP_MEMORY/frme_rmap_mem_area_ffee_write_ent.vhd
add_fileset_file frme_avm_rmap_ffee_pkg.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_AVALON_MM_RMAP_MASTER/frme_avm_rmap_ffee_pkg.vhd
add_fileset_file frme_avm_rmap_ffee_read_ent.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_AVALON_MM_RMAP_MASTER/frme_avm_rmap_ffee_read_ent.vhd
add_fileset_file frme_avm_rmap_ffee_write_ent.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_AVALON_MM_RMAP_MASTER/frme_avm_rmap_ffee_write_ent.vhd
add_fileset_file frme_rmap_memory_ffee_area_top.vhd VHDL PATH RMAP_Memory_FFEE_Area/frme_rmap_memory_ffee_area_top.vhd TOP_LEVEL_FILE

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL frme_rmap_memory_ffee_area_top
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file frme_avalon_mm_rmap_ffee_pkg.vhd VHDL PATH RMAP_Memory_FFEE_Area/AVALON_RMAP_REGISTERS/frme_avalon_mm_rmap_ffee_pkg.vhd
add_fileset_file frme_rmap_mem_area_ffee_pkg.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_RMAP_MEMORY/frme_rmap_mem_area_ffee_pkg.vhd
add_fileset_file frme_rmap_mem_area_ffee_arbiter_ent.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_RMAP_MEMORY/frme_rmap_mem_area_ffee_arbiter_ent.vhd
add_fileset_file frme_rmap_mem_area_ffee_read_ent.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_RMAP_MEMORY/frme_rmap_mem_area_ffee_read_ent.vhd
add_fileset_file frme_rmap_mem_area_ffee_write_ent.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_RMAP_MEMORY/frme_rmap_mem_area_ffee_write_ent.vhd
add_fileset_file frme_avm_rmap_ffee_pkg.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_AVALON_MM_RMAP_MASTER/frme_avm_rmap_ffee_pkg.vhd
add_fileset_file frme_avm_rmap_ffee_read_ent.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_AVALON_MM_RMAP_MASTER/frme_avm_rmap_ffee_read_ent.vhd
add_fileset_file frme_avm_rmap_ffee_write_ent.vhd VHDL PATH RMAP_Memory_FFEE_Area/FFEE_AVALON_MM_RMAP_MASTER/frme_avm_rmap_ffee_write_ent.vhd
add_fileset_file frme_rmap_memory_ffee_area_top.vhd VHDL PATH RMAP_Memory_FFEE_Area/frme_rmap_memory_ffee_area_top.vhd TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink_100mhz
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink reset_i reset Input 1


# 
# connection point clock_sink_100mhz
# 
add_interface clock_sink_100mhz clock end
set_interface_property clock_sink_100mhz clockRate 100000000
set_interface_property clock_sink_100mhz ENABLED true
set_interface_property clock_sink_100mhz EXPORT_OF ""
set_interface_property clock_sink_100mhz PORT_NAME_MAP ""
set_interface_property clock_sink_100mhz CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink_100mhz SVD_ADDRESS_GROUP ""

add_interface_port clock_sink_100mhz clk_100_i clk Input 1


# 
# connection point avalon_rmap_slave_0
# 
add_interface avalon_rmap_slave_0 avalon end
set_interface_property avalon_rmap_slave_0 addressUnits WORDS
set_interface_property avalon_rmap_slave_0 associatedClock clock_sink_100mhz
set_interface_property avalon_rmap_slave_0 associatedReset reset_sink
set_interface_property avalon_rmap_slave_0 bitsPerSymbol 8
set_interface_property avalon_rmap_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_rmap_slave_0 burstcountUnits WORDS
set_interface_property avalon_rmap_slave_0 explicitAddressSpan 0
set_interface_property avalon_rmap_slave_0 holdTime 0
set_interface_property avalon_rmap_slave_0 linewrapBursts false
set_interface_property avalon_rmap_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_rmap_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_rmap_slave_0 readLatency 0
set_interface_property avalon_rmap_slave_0 readWaitTime 1
set_interface_property avalon_rmap_slave_0 setupTime 0
set_interface_property avalon_rmap_slave_0 timingUnits Cycles
set_interface_property avalon_rmap_slave_0 writeWaitTime 0
set_interface_property avalon_rmap_slave_0 ENABLED true
set_interface_property avalon_rmap_slave_0 EXPORT_OF ""
set_interface_property avalon_rmap_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_rmap_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_rmap_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_rmap_slave_0 avs_rmap_0_address_i address Input 12
add_interface_port avalon_rmap_slave_0 avs_rmap_0_write_i write Input 1
add_interface_port avalon_rmap_slave_0 avs_rmap_0_read_i read Input 1
add_interface_port avalon_rmap_slave_0 avs_rmap_0_readdata_o readdata Output 32
add_interface_port avalon_rmap_slave_0 avs_rmap_0_writedata_i writedata Input 32
add_interface_port avalon_rmap_slave_0 avs_rmap_0_waitrequest_o waitrequest Output 1
add_interface_port avalon_rmap_slave_0 avs_rmap_0_byteenable_i byteenable Input 4
set_interface_assignment avalon_rmap_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_rmap_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_rmap_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_rmap_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point conduit_end_rmap_mem_slave_0
# 
add_interface conduit_end_rmap_mem_slave_0 conduit end
set_interface_property conduit_end_rmap_mem_slave_0 associatedClock clock_sink_100mhz
set_interface_property conduit_end_rmap_mem_slave_0 associatedReset reset_sink
set_interface_property conduit_end_rmap_mem_slave_0 ENABLED true
set_interface_property conduit_end_rmap_mem_slave_0 EXPORT_OF ""
set_interface_property conduit_end_rmap_mem_slave_0 PORT_NAME_MAP ""
set_interface_property conduit_end_rmap_mem_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_rmap_mem_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_rmap_mem_slave_0 rms_rmap_0_wr_address_i wr_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_0 rms_rmap_0_write_i write_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_0 rms_rmap_0_writedata_i writedata_signal Input 8
add_interface_port conduit_end_rmap_mem_slave_0 rms_rmap_0_rd_address_i rd_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_0 rms_rmap_0_read_i read_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_0 rms_rmap_0_wr_waitrequest_o wr_waitrequest_signal Output 1
add_interface_port conduit_end_rmap_mem_slave_0 rms_rmap_0_readdata_o readdata_signal Output 8
add_interface_port conduit_end_rmap_mem_slave_0 rms_rmap_0_rd_waitrequest_o rd_waitrequest_signal Output 1


# 
# connection point conduit_end_rmap_mem_slave_1
# 
add_interface conduit_end_rmap_mem_slave_1 conduit end
set_interface_property conduit_end_rmap_mem_slave_1 associatedClock clock_sink_100mhz
set_interface_property conduit_end_rmap_mem_slave_1 associatedReset reset_sink
set_interface_property conduit_end_rmap_mem_slave_1 ENABLED true
set_interface_property conduit_end_rmap_mem_slave_1 EXPORT_OF ""
set_interface_property conduit_end_rmap_mem_slave_1 PORT_NAME_MAP ""
set_interface_property conduit_end_rmap_mem_slave_1 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_rmap_mem_slave_1 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_rmap_mem_slave_1 rms_rmap_1_wr_address_i wr_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_1 rms_rmap_1_write_i write_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_1 rms_rmap_1_writedata_i writedata_signal Input 8
add_interface_port conduit_end_rmap_mem_slave_1 rms_rmap_1_rd_address_i rd_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_1 rms_rmap_1_read_i read_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_1 rms_rmap_1_wr_waitrequest_o wr_waitrequest_signal Output 1
add_interface_port conduit_end_rmap_mem_slave_1 rms_rmap_1_readdata_o readdata_signal Output 8
add_interface_port conduit_end_rmap_mem_slave_1 rms_rmap_1_rd_waitrequest_o rd_waitrequest_signal Output 1


# 
# connection point conduit_end_rmap_mem_slave_2
# 
add_interface conduit_end_rmap_mem_slave_2 conduit end
set_interface_property conduit_end_rmap_mem_slave_2 associatedClock clock_sink_100mhz
set_interface_property conduit_end_rmap_mem_slave_2 associatedReset reset_sink
set_interface_property conduit_end_rmap_mem_slave_2 ENABLED true
set_interface_property conduit_end_rmap_mem_slave_2 EXPORT_OF ""
set_interface_property conduit_end_rmap_mem_slave_2 PORT_NAME_MAP ""
set_interface_property conduit_end_rmap_mem_slave_2 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_rmap_mem_slave_2 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_rmap_mem_slave_2 rms_rmap_2_wr_address_i wr_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_2 rms_rmap_2_write_i write_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_2 rms_rmap_2_writedata_i writedata_signal Input 8
add_interface_port conduit_end_rmap_mem_slave_2 rms_rmap_2_rd_address_i rd_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_2 rms_rmap_2_read_i read_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_2 rms_rmap_2_wr_waitrequest_o wr_waitrequest_signal Output 1
add_interface_port conduit_end_rmap_mem_slave_2 rms_rmap_2_readdata_o readdata_signal Output 8
add_interface_port conduit_end_rmap_mem_slave_2 rms_rmap_2_rd_waitrequest_o rd_waitrequest_signal Output 1


# 
# connection point conduit_end_rmap_mem_slave_3
# 
add_interface conduit_end_rmap_mem_slave_3 conduit end
set_interface_property conduit_end_rmap_mem_slave_3 associatedClock clock_sink_100mhz
set_interface_property conduit_end_rmap_mem_slave_3 associatedReset reset_sink
set_interface_property conduit_end_rmap_mem_slave_3 ENABLED true
set_interface_property conduit_end_rmap_mem_slave_3 EXPORT_OF ""
set_interface_property conduit_end_rmap_mem_slave_3 PORT_NAME_MAP ""
set_interface_property conduit_end_rmap_mem_slave_3 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_rmap_mem_slave_3 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_rmap_mem_slave_3 rms_rmap_3_wr_address_i wr_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_3 rms_rmap_3_write_i write_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_3 rms_rmap_3_writedata_i writedata_signal Input 8
add_interface_port conduit_end_rmap_mem_slave_3 rms_rmap_3_rd_address_i rd_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_3 rms_rmap_3_read_i read_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_3 rms_rmap_3_wr_waitrequest_o wr_waitrequest_signal Output 1
add_interface_port conduit_end_rmap_mem_slave_3 rms_rmap_3_readdata_o readdata_signal Output 8
add_interface_port conduit_end_rmap_mem_slave_3 rms_rmap_3_rd_waitrequest_o rd_waitrequest_signal Output 1


# 
# connection point conduit_end_rmap_mem_slave_4
# 
add_interface conduit_end_rmap_mem_slave_4 conduit end
set_interface_property conduit_end_rmap_mem_slave_4 associatedClock clock_sink_100mhz
set_interface_property conduit_end_rmap_mem_slave_4 associatedReset reset_sink
set_interface_property conduit_end_rmap_mem_slave_4 ENABLED true
set_interface_property conduit_end_rmap_mem_slave_4 EXPORT_OF ""
set_interface_property conduit_end_rmap_mem_slave_4 PORT_NAME_MAP ""
set_interface_property conduit_end_rmap_mem_slave_4 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_rmap_mem_slave_4 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_rmap_mem_slave_4 rms_rmap_4_wr_address_i wr_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_4 rms_rmap_4_write_i write_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_4 rms_rmap_4_writedata_i writedata_signal Input 8
add_interface_port conduit_end_rmap_mem_slave_4 rms_rmap_4_rd_address_i rd_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_4 rms_rmap_4_read_i read_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_4 rms_rmap_4_wr_waitrequest_o wr_waitrequest_signal Output 1
add_interface_port conduit_end_rmap_mem_slave_4 rms_rmap_4_readdata_o readdata_signal Output 8
add_interface_port conduit_end_rmap_mem_slave_4 rms_rmap_4_rd_waitrequest_o rd_waitrequest_signal Output 1


# 
# connection point conduit_end_rmap_mem_slave_5
# 
add_interface conduit_end_rmap_mem_slave_5 conduit end
set_interface_property conduit_end_rmap_mem_slave_5 associatedClock clock_sink_100mhz
set_interface_property conduit_end_rmap_mem_slave_5 associatedReset reset_sink
set_interface_property conduit_end_rmap_mem_slave_5 ENABLED true
set_interface_property conduit_end_rmap_mem_slave_5 EXPORT_OF ""
set_interface_property conduit_end_rmap_mem_slave_5 PORT_NAME_MAP ""
set_interface_property conduit_end_rmap_mem_slave_5 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_rmap_mem_slave_5 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_rmap_mem_slave_5 rms_rmap_5_wr_address_i wr_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_5 rms_rmap_5_write_i write_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_5 rms_rmap_5_writedata_i writedata_signal Input 8
add_interface_port conduit_end_rmap_mem_slave_5 rms_rmap_5_rd_address_i rd_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_5 rms_rmap_5_read_i read_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_5 rms_rmap_5_wr_waitrequest_o wr_waitrequest_signal Output 1
add_interface_port conduit_end_rmap_mem_slave_5 rms_rmap_5_readdata_o readdata_signal Output 8
add_interface_port conduit_end_rmap_mem_slave_5 rms_rmap_5_rd_waitrequest_o rd_waitrequest_signal Output 1


# 
# connection point conduit_end_rmap_mem_slave_6
# 
add_interface conduit_end_rmap_mem_slave_6 conduit end
set_interface_property conduit_end_rmap_mem_slave_6 associatedClock clock_sink_100mhz
set_interface_property conduit_end_rmap_mem_slave_6 associatedReset reset_sink
set_interface_property conduit_end_rmap_mem_slave_6 ENABLED true
set_interface_property conduit_end_rmap_mem_slave_6 EXPORT_OF ""
set_interface_property conduit_end_rmap_mem_slave_6 PORT_NAME_MAP ""
set_interface_property conduit_end_rmap_mem_slave_6 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_rmap_mem_slave_6 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_rmap_mem_slave_6 rms_rmap_6_wr_address_i wr_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_6 rms_rmap_6_write_i write_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_6 rms_rmap_6_writedata_i writedata_signal Input 8
add_interface_port conduit_end_rmap_mem_slave_6 rms_rmap_6_rd_address_i rd_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_6 rms_rmap_6_read_i read_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_6 rms_rmap_6_wr_waitrequest_o wr_waitrequest_signal Output 1
add_interface_port conduit_end_rmap_mem_slave_6 rms_rmap_6_readdata_o readdata_signal Output 8
add_interface_port conduit_end_rmap_mem_slave_6 rms_rmap_6_rd_waitrequest_o rd_waitrequest_signal Output 1


# 
# connection point conduit_end_rmap_mem_slave_7
# 
add_interface conduit_end_rmap_mem_slave_7 conduit end
set_interface_property conduit_end_rmap_mem_slave_7 associatedClock clock_sink_100mhz
set_interface_property conduit_end_rmap_mem_slave_7 associatedReset reset_sink
set_interface_property conduit_end_rmap_mem_slave_7 ENABLED true
set_interface_property conduit_end_rmap_mem_slave_7 EXPORT_OF ""
set_interface_property conduit_end_rmap_mem_slave_7 PORT_NAME_MAP ""
set_interface_property conduit_end_rmap_mem_slave_7 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_rmap_mem_slave_7 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_rmap_mem_slave_7 rms_rmap_7_wr_address_i wr_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_7 rms_rmap_7_write_i write_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_7 rms_rmap_7_writedata_i writedata_signal Input 8
add_interface_port conduit_end_rmap_mem_slave_7 rms_rmap_7_rd_address_i rd_address_signal Input 32
add_interface_port conduit_end_rmap_mem_slave_7 rms_rmap_7_read_i read_signal Input 1
add_interface_port conduit_end_rmap_mem_slave_7 rms_rmap_7_wr_waitrequest_o wr_waitrequest_signal Output 1
add_interface_port conduit_end_rmap_mem_slave_7 rms_rmap_7_readdata_o readdata_signal Output 8
add_interface_port conduit_end_rmap_mem_slave_7 rms_rmap_7_rd_waitrequest_o rd_waitrequest_signal Output 1


# 
# connection point conduit_end_channel_0_hk_in
# 
add_interface conduit_end_channel_0_hk_in conduit end
set_interface_property conduit_end_channel_0_hk_in associatedClock clock_sink_100mhz
set_interface_property conduit_end_channel_0_hk_in associatedReset reset_sink
set_interface_property conduit_end_channel_0_hk_in ENABLED true
set_interface_property conduit_end_channel_0_hk_in EXPORT_OF ""
set_interface_property conduit_end_channel_0_hk_in PORT_NAME_MAP ""
set_interface_property conduit_end_channel_0_hk_in CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_channel_0_hk_in SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_channel_0_hk_in channel_0_hk_timecode_control_i timecode_control_signal Input 2
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_timecode_time_i timecode_time_signal Input 6
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_rmap_target_status_i rmap_target_status_signal Input 8
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_rmap_target_indicate_i rmap_target_indicate_signal Input 1
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_spw_link_escape_err_i spw_link_escape_err_signal Input 1
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_spw_link_credit_err_i spw_link_credit_err_signal Input 1
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_spw_link_parity_err_i spw_link_parity_err_signal Input 1
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_spw_link_disconnect_i spw_link_disconnect_signal Input 1
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_spw_link_running_i spw_link_running_signal Input 1
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_frame_counter_i frame_counter_signal Input 16
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_frame_number_i frame_number_signal Input 2
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_err_win_wrong_x_coord_i err_win_wrong_x_coord_signal Input 1
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_err_win_wrong_y_coord_i err_win_wrong_y_coord_signal Input 1
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_err_e_side_buffer_full_i err_e_side_buffer_full_signal Input 1
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_err_f_side_buffer_full_i err_f_side_buffer_full_signal Input 1
add_interface_port conduit_end_channel_0_hk_in channel_0_hk_err_invalid_ccd_mode_i err_invalid_ccd_mode_signal Input 1


# 
# connection point conduit_end_channel_1_hk_in
# 
add_interface conduit_end_channel_XNUMBERX_hk_in conduit end
set_interface_property conduit_end_channel_XNUMBERX_hk_in associatedClock clock_sink_100mhz
set_interface_property conduit_end_channel_XNUMBERX_hk_in associatedReset reset_sink
set_interface_property conduit_end_channel_XNUMBERX_hk_in ENABLED true
set_interface_property conduit_end_channel_XNUMBERX_hk_in EXPORT_OF ""
set_interface_property conduit_end_channel_XNUMBERX_hk_in PORT_NAME_MAP ""
set_interface_property conduit_end_channel_XNUMBERX_hk_in CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_channel_XNUMBERX_hk_in SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_timecode_control_i timecode_control_signal Input 2
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_timecode_time_i timecode_time_signal Input 6
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_rmap_target_status_i rmap_target_status_signal Input 8
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_rmap_target_indicate_i rmap_target_indicate_signal Input 1
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_spw_link_escape_err_i spw_link_escape_err_signal Input 1
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_spw_link_credit_err_i spw_link_credit_err_signal Input 1
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_spw_link_parity_err_i spw_link_parity_err_signal Input 1
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_spw_link_disconnect_i spw_link_disconnect_signal Input 1
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_spw_link_running_i spw_link_running_signal Input 1
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_frame_counter_i frame_counter_signal Input 16
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_frame_number_i frame_number_signal Input 2
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_err_win_wrong_x_coord_i err_win_wrong_x_coord_signal Input 1
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_err_win_wrong_y_coord_i err_win_wrong_y_coord_signal Input 1
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_err_e_side_buffer_full_i err_e_side_buffer_full_signal Input 1
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_err_f_side_buffer_full_i err_f_side_buffer_full_signal Input 1
add_interface_port conduit_end_channel_XNUMBERX_hk_in channel_XNUMBERX_hk_err_invalid_ccd_mode_i err_invalid_ccd_mode_signal Input 1


# 
# connection point conduit_end_channel_2_hk_in
# 
add_interface conduit_end_channel_2_hk_in conduit end
set_interface_property conduit_end_channel_2_hk_in associatedClock clock_sink_100mhz
set_interface_property conduit_end_channel_2_hk_in associatedReset reset_sink
set_interface_property conduit_end_channel_2_hk_in ENABLED true
set_interface_property conduit_end_channel_2_hk_in EXPORT_OF ""
set_interface_property conduit_end_channel_2_hk_in PORT_NAME_MAP ""
set_interface_property conduit_end_channel_2_hk_in CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_channel_2_hk_in SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_channel_2_hk_in channel_2_hk_timecode_control_i timecode_control_signal Input 2
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_timecode_time_i timecode_time_signal Input 6
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_rmap_target_status_i rmap_target_status_signal Input 8
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_rmap_target_indicate_i rmap_target_indicate_signal Input 1
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_spw_link_escape_err_i spw_link_escape_err_signal Input 1
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_spw_link_credit_err_i spw_link_credit_err_signal Input 1
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_spw_link_parity_err_i spw_link_parity_err_signal Input 1
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_spw_link_disconnect_i spw_link_disconnect_signal Input 1
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_spw_link_running_i spw_link_running_signal Input 1
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_frame_counter_i frame_counter_signal Input 16
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_frame_number_i frame_number_signal Input 2
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_err_win_wrong_x_coord_i err_win_wrong_x_coord_signal Input 1
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_err_win_wrong_y_coord_i err_win_wrong_y_coord_signal Input 1
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_err_e_side_buffer_full_i err_e_side_buffer_full_signal Input 1
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_err_f_side_buffer_full_i err_f_side_buffer_full_signal Input 1
add_interface_port conduit_end_channel_2_hk_in channel_2_hk_err_invalid_ccd_mode_i err_invalid_ccd_mode_signal Input 1


# 
# connection point conduit_end_channel_3_hk_in
# 
add_interface conduit_end_channel_3_hk_in conduit end
set_interface_property conduit_end_channel_3_hk_in associatedClock clock_sink_100mhz
set_interface_property conduit_end_channel_3_hk_in associatedReset reset_sink
set_interface_property conduit_end_channel_3_hk_in ENABLED true
set_interface_property conduit_end_channel_3_hk_in EXPORT_OF ""
set_interface_property conduit_end_channel_3_hk_in PORT_NAME_MAP ""
set_interface_property conduit_end_channel_3_hk_in CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_channel_3_hk_in SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_channel_3_hk_in channel_3_hk_timecode_control_i timecode_control_signal Input 2
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_timecode_time_i timecode_time_signal Input 6
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_rmap_target_status_i rmap_target_status_signal Input 8
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_rmap_target_indicate_i rmap_target_indicate_signal Input 1
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_spw_link_escape_err_i spw_link_escape_err_signal Input 1
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_spw_link_credit_err_i spw_link_credit_err_signal Input 1
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_spw_link_parity_err_i spw_link_parity_err_signal Input 1
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_spw_link_disconnect_i spw_link_disconnect_signal Input 1
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_spw_link_running_i spw_link_running_signal Input 1
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_frame_counter_i frame_counter_signal Input 16
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_frame_number_i frame_number_signal Input 2
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_err_win_wrong_x_coord_i err_win_wrong_x_coord_signal Input 1
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_err_win_wrong_y_coord_i err_win_wrong_y_coord_signal Input 1
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_err_e_side_buffer_full_i err_e_side_buffer_full_signal Input 1
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_err_f_side_buffer_full_i err_f_side_buffer_full_signal Input 1
add_interface_port conduit_end_channel_3_hk_in channel_3_hk_err_invalid_ccd_mode_i err_invalid_ccd_mode_signal Input 1


# 
# connection point avalon_mm_rmap_master
# 
add_interface avalon_mm_rmap_master avalon start
set_interface_property avalon_mm_rmap_master addressUnits SYMBOLS
set_interface_property avalon_mm_rmap_master associatedClock clock_sink_100mhz
set_interface_property avalon_mm_rmap_master associatedReset reset_sink
set_interface_property avalon_mm_rmap_master bitsPerSymbol 8
set_interface_property avalon_mm_rmap_master burstOnBurstBoundariesOnly false
set_interface_property avalon_mm_rmap_master burstcountUnits WORDS
set_interface_property avalon_mm_rmap_master doStreamReads false
set_interface_property avalon_mm_rmap_master doStreamWrites false
set_interface_property avalon_mm_rmap_master holdTime 0
set_interface_property avalon_mm_rmap_master linewrapBursts false
set_interface_property avalon_mm_rmap_master maximumPendingReadTransactions 0
set_interface_property avalon_mm_rmap_master maximumPendingWriteTransactions 0
set_interface_property avalon_mm_rmap_master readLatency 0
set_interface_property avalon_mm_rmap_master readWaitTime 1
set_interface_property avalon_mm_rmap_master setupTime 0
set_interface_property avalon_mm_rmap_master timingUnits Cycles
set_interface_property avalon_mm_rmap_master writeWaitTime 0
set_interface_property avalon_mm_rmap_master ENABLED true
set_interface_property avalon_mm_rmap_master EXPORT_OF ""
set_interface_property avalon_mm_rmap_master PORT_NAME_MAP ""
set_interface_property avalon_mm_rmap_master CMSIS_SVD_VARIABLES ""
set_interface_property avalon_mm_rmap_master SVD_ADDRESS_GROUP ""

add_interface_port avalon_mm_rmap_master avm_rmap_readdata_i readdata Input 8
add_interface_port avalon_mm_rmap_master avm_rmap_waitrequest_i waitrequest Input 1
add_interface_port avalon_mm_rmap_master avm_rmap_address_o address Output 64
add_interface_port avalon_mm_rmap_master avm_rmap_read_o read Output 1
add_interface_port avalon_mm_rmap_master avm_rmap_write_o write Output 1
add_interface_port avalon_mm_rmap_master avm_rmap_writedata_o writedata Output 8


# 
# connection point conduit_end_rmap_avm_configs_in
# 
add_interface conduit_end_rmap_avm_configs_in conduit end
set_interface_property conduit_end_rmap_avm_configs_in associatedClock clock_sink_100mhz
set_interface_property conduit_end_rmap_avm_configs_in associatedReset reset_sink
set_interface_property conduit_end_rmap_avm_configs_in ENABLED true
set_interface_property conduit_end_rmap_avm_configs_in EXPORT_OF ""
set_interface_property conduit_end_rmap_avm_configs_in PORT_NAME_MAP ""
set_interface_property conduit_end_rmap_avm_configs_in CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_rmap_avm_configs_in SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_rmap_avm_configs_in channel_win_mem_addr_offset_i win_mem_addr_offset_signal Input 64

