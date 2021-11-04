# TCL File Generated by Component Editor 18.1
# Tue Nov 02 15:52:36 BRT 2021
# DO NOT MODIFY


# 
# Avalon_MM_Master_Arbiter "Avalon_MM_Master_Arbiter" v1.0
# rfranca 2021.11.02.15:52:36
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module Avalon_MM_Master_Arbiter
# 
set_module_property DESCRIPTION ""
set_module_property NAME Avalon_MM_Master_Arbiter
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR rfranca
set_module_property DISPLAY_NAME Avalon_MM_Master_Arbiter
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL avma_avalon_mm_master_arbiter_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file avma_avm_arbiter_pkg.vhd VHDL PATH Avalon_MM_Master_Arbiter/avma_avm_arbiter_pkg.vhd
add_fileset_file avma_avm_arbiter_ent.vhd VHDL PATH Avalon_MM_Master_Arbiter/avma_avm_arbiter_ent.vhd
add_fileset_file avma_avalon_mm_master_arbiter_top.vhd VHDL PATH Avalon_MM_Master_Arbiter/avma_avalon_mm_master_arbiter_top.vhd TOP_LEVEL_FILE

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL avma_avalon_mm_master_arbiter_top
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file avma_avm_arbiter_pkg.vhd VHDL PATH Avalon_MM_Master_Arbiter/avma_avm_arbiter_pkg.vhd
add_fileset_file avma_avm_arbiter_ent.vhd VHDL PATH Avalon_MM_Master_Arbiter/avma_avm_arbiter_ent.vhd
add_fileset_file avma_avalon_mm_master_arbiter_top.vhd VHDL PATH Avalon_MM_Master_Arbiter/avma_avalon_mm_master_arbiter_top.vhd TOP_LEVEL_FILE


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
# connection point avalon_mm_master_0
# 
add_interface avalon_mm_master_0 avalon end
set_interface_property avalon_mm_master_0 addressUnits WORDS
set_interface_property avalon_mm_master_0 associatedClock clock_sink_100mhz
set_interface_property avalon_mm_master_0 associatedReset reset_sink
set_interface_property avalon_mm_master_0 bitsPerSymbol 8
set_interface_property avalon_mm_master_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_mm_master_0 burstcountUnits WORDS
set_interface_property avalon_mm_master_0 explicitAddressSpan 0
set_interface_property avalon_mm_master_0 holdTime 0
set_interface_property avalon_mm_master_0 linewrapBursts false
set_interface_property avalon_mm_master_0 maximumPendingReadTransactions 0
set_interface_property avalon_mm_master_0 maximumPendingWriteTransactions 0
set_interface_property avalon_mm_master_0 readLatency 0
set_interface_property avalon_mm_master_0 readWaitTime 1
set_interface_property avalon_mm_master_0 setupTime 0
set_interface_property avalon_mm_master_0 timingUnits Cycles
set_interface_property avalon_mm_master_0 writeWaitTime 0
set_interface_property avalon_mm_master_0 ENABLED true
set_interface_property avalon_mm_master_0 EXPORT_OF ""
set_interface_property avalon_mm_master_0 PORT_NAME_MAP ""
set_interface_property avalon_mm_master_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_mm_master_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_mm_master_0 avm_0_address_i address Input 26
add_interface_port avalon_mm_master_0 avm_0_read_i read Input 1
#add_interface_port avalon_mm_master_0 avm_0_write_i write Input 1
#add_interface_port avalon_mm_master_0 avm_0_writedata_i writedata Input 256
#add_interface_port avalon_mm_master_0 avm_0_byteenable_i byteenable Input 32
add_interface_port avalon_mm_master_0 avm_0_readdata_o readdata Output 256
add_interface_port avalon_mm_master_0 avm_0_waitrequest_o waitrequest Output 1
set_interface_assignment avalon_mm_master_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_mm_master_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_mm_master_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_mm_master_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_mm_master_1
# 
add_interface avalon_mm_master_1 avalon end
set_interface_property avalon_mm_master_1 addressUnits WORDS
set_interface_property avalon_mm_master_1 associatedClock clock_sink_100mhz
set_interface_property avalon_mm_master_1 associatedReset reset_sink
set_interface_property avalon_mm_master_1 bitsPerSymbol 8
set_interface_property avalon_mm_master_1 burstOnBurstBoundariesOnly false
set_interface_property avalon_mm_master_1 burstcountUnits WORDS
set_interface_property avalon_mm_master_1 explicitAddressSpan 0
set_interface_property avalon_mm_master_1 holdTime 0
set_interface_property avalon_mm_master_1 linewrapBursts false
set_interface_property avalon_mm_master_1 maximumPendingReadTransactions 0
set_interface_property avalon_mm_master_1 maximumPendingWriteTransactions 0
set_interface_property avalon_mm_master_1 readLatency 0
set_interface_property avalon_mm_master_1 readWaitTime 1
set_interface_property avalon_mm_master_1 setupTime 0
set_interface_property avalon_mm_master_1 timingUnits Cycles
set_interface_property avalon_mm_master_1 writeWaitTime 0
set_interface_property avalon_mm_master_1 ENABLED true
set_interface_property avalon_mm_master_1 EXPORT_OF ""
set_interface_property avalon_mm_master_1 PORT_NAME_MAP ""
set_interface_property avalon_mm_master_1 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_mm_master_1 SVD_ADDRESS_GROUP ""

add_interface_port avalon_mm_master_1 avm_1_address_i address Input 26
add_interface_port avalon_mm_master_1 avm_1_read_i read Input 1
#add_interface_port avalon_mm_master_1 avm_1_write_i write Input 1
#add_interface_port avalon_mm_master_1 avm_1_writedata_i writedata Input 256
#add_interface_port avalon_mm_master_1 avm_1_byteenable_i byteenable Input 32
add_interface_port avalon_mm_master_1 avm_1_readdata_o readdata Output 256
add_interface_port avalon_mm_master_1 avm_1_waitrequest_o waitrequest Output 1
set_interface_assignment avalon_mm_master_1 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_mm_master_1 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_mm_master_1 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_mm_master_1 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_mm_master_2
# 
add_interface avalon_mm_master_2 avalon end
set_interface_property avalon_mm_master_2 addressUnits WORDS
set_interface_property avalon_mm_master_2 associatedClock clock_sink_100mhz
set_interface_property avalon_mm_master_2 associatedReset reset_sink
set_interface_property avalon_mm_master_2 bitsPerSymbol 8
set_interface_property avalon_mm_master_2 burstOnBurstBoundariesOnly false
set_interface_property avalon_mm_master_2 burstcountUnits WORDS
set_interface_property avalon_mm_master_2 explicitAddressSpan 0
set_interface_property avalon_mm_master_2 holdTime 0
set_interface_property avalon_mm_master_2 linewrapBursts false
set_interface_property avalon_mm_master_2 maximumPendingReadTransactions 0
set_interface_property avalon_mm_master_2 maximumPendingWriteTransactions 0
set_interface_property avalon_mm_master_2 readLatency 0
set_interface_property avalon_mm_master_2 readWaitTime 1
set_interface_property avalon_mm_master_2 setupTime 0
set_interface_property avalon_mm_master_2 timingUnits Cycles
set_interface_property avalon_mm_master_2 writeWaitTime 0
set_interface_property avalon_mm_master_2 ENABLED true
set_interface_property avalon_mm_master_2 EXPORT_OF ""
set_interface_property avalon_mm_master_2 PORT_NAME_MAP ""
set_interface_property avalon_mm_master_2 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_mm_master_2 SVD_ADDRESS_GROUP ""

add_interface_port avalon_mm_master_2 avm_2_address_i address Input 26
add_interface_port avalon_mm_master_2 avm_2_read_i read Input 1
#add_interface_port avalon_mm_master_2 avm_2_write_i write Input 1
#add_interface_port avalon_mm_master_2 avm_2_writedata_i writedata Input 256
#add_interface_port avalon_mm_master_2 avm_2_byteenable_i byteenable Input 32
add_interface_port avalon_mm_master_2 avm_2_readdata_o readdata Output 256
add_interface_port avalon_mm_master_2 avm_2_waitrequest_o waitrequest Output 1
set_interface_assignment avalon_mm_master_2 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_mm_master_2 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_mm_master_2 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_mm_master_2 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_mm_master_3
# 
add_interface avalon_mm_master_3 avalon end
set_interface_property avalon_mm_master_3 addressUnits WORDS
set_interface_property avalon_mm_master_3 associatedClock clock_sink_100mhz
set_interface_property avalon_mm_master_3 associatedReset reset_sink
set_interface_property avalon_mm_master_3 bitsPerSymbol 8
set_interface_property avalon_mm_master_3 burstOnBurstBoundariesOnly false
set_interface_property avalon_mm_master_3 burstcountUnits WORDS
set_interface_property avalon_mm_master_3 explicitAddressSpan 0
set_interface_property avalon_mm_master_3 holdTime 0
set_interface_property avalon_mm_master_3 linewrapBursts false
set_interface_property avalon_mm_master_3 maximumPendingReadTransactions 0
set_interface_property avalon_mm_master_3 maximumPendingWriteTransactions 0
set_interface_property avalon_mm_master_3 readLatency 0
set_interface_property avalon_mm_master_3 readWaitTime 1
set_interface_property avalon_mm_master_3 setupTime 0
set_interface_property avalon_mm_master_3 timingUnits Cycles
set_interface_property avalon_mm_master_3 writeWaitTime 0
set_interface_property avalon_mm_master_3 ENABLED true
set_interface_property avalon_mm_master_3 EXPORT_OF ""
set_interface_property avalon_mm_master_3 PORT_NAME_MAP ""
set_interface_property avalon_mm_master_3 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_mm_master_3 SVD_ADDRESS_GROUP ""

add_interface_port avalon_mm_master_3 avm_3_address_i address Input 26
add_interface_port avalon_mm_master_3 avm_3_read_i read Input 1
#add_interface_port avalon_mm_master_3 avm_3_write_i write Input 1
#add_interface_port avalon_mm_master_3 avm_3_writedata_i writedata Input 256
#add_interface_port avalon_mm_master_3 avm_3_byteenable_i byteenable Input 32
add_interface_port avalon_mm_master_3 avm_3_readdata_o readdata Output 256
add_interface_port avalon_mm_master_3 avm_3_waitrequest_o waitrequest Output 1
set_interface_assignment avalon_mm_master_3 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_mm_master_3 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_mm_master_3 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_mm_master_3 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_mm_master_4
# 
add_interface avalon_mm_master_4 avalon end
set_interface_property avalon_mm_master_4 addressUnits WORDS
set_interface_property avalon_mm_master_4 associatedClock clock_sink_100mhz
set_interface_property avalon_mm_master_4 associatedReset reset_sink
set_interface_property avalon_mm_master_4 bitsPerSymbol 8
set_interface_property avalon_mm_master_4 burstOnBurstBoundariesOnly false
set_interface_property avalon_mm_master_4 burstcountUnits WORDS
set_interface_property avalon_mm_master_4 explicitAddressSpan 0
set_interface_property avalon_mm_master_4 holdTime 0
set_interface_property avalon_mm_master_4 linewrapBursts false
set_interface_property avalon_mm_master_4 maximumPendingReadTransactions 0
set_interface_property avalon_mm_master_4 maximumPendingWriteTransactions 0
set_interface_property avalon_mm_master_4 readLatency 0
set_interface_property avalon_mm_master_4 readWaitTime 1
set_interface_property avalon_mm_master_4 setupTime 0
set_interface_property avalon_mm_master_4 timingUnits Cycles
set_interface_property avalon_mm_master_4 writeWaitTime 0
set_interface_property avalon_mm_master_4 ENABLED true
set_interface_property avalon_mm_master_4 EXPORT_OF ""
set_interface_property avalon_mm_master_4 PORT_NAME_MAP ""
set_interface_property avalon_mm_master_4 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_mm_master_4 SVD_ADDRESS_GROUP ""

add_interface_port avalon_mm_master_4 avm_4_address_i address Input 26
add_interface_port avalon_mm_master_4 avm_4_read_i read Input 1
#add_interface_port avalon_mm_master_4 avm_4_write_i write Input 1
#add_interface_port avalon_mm_master_4 avm_4_writedata_i writedata Input 256
#add_interface_port avalon_mm_master_4 avm_4_byteenable_i byteenable Input 32
add_interface_port avalon_mm_master_4 avm_4_readdata_o readdata Output 256
add_interface_port avalon_mm_master_4 avm_4_waitrequest_o waitrequest Output 1
set_interface_assignment avalon_mm_master_4 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_mm_master_4 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_mm_master_4 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_mm_master_4 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_mm_master_5
# 
add_interface avalon_mm_master_5 avalon end
set_interface_property avalon_mm_master_5 addressUnits WORDS
set_interface_property avalon_mm_master_5 associatedClock clock_sink_100mhz
set_interface_property avalon_mm_master_5 associatedReset reset_sink
set_interface_property avalon_mm_master_5 bitsPerSymbol 8
set_interface_property avalon_mm_master_5 burstOnBurstBoundariesOnly false
set_interface_property avalon_mm_master_5 burstcountUnits WORDS
set_interface_property avalon_mm_master_5 explicitAddressSpan 0
set_interface_property avalon_mm_master_5 holdTime 0
set_interface_property avalon_mm_master_5 linewrapBursts false
set_interface_property avalon_mm_master_5 maximumPendingReadTransactions 0
set_interface_property avalon_mm_master_5 maximumPendingWriteTransactions 0
set_interface_property avalon_mm_master_5 readLatency 0
set_interface_property avalon_mm_master_5 readWaitTime 1
set_interface_property avalon_mm_master_5 setupTime 0
set_interface_property avalon_mm_master_5 timingUnits Cycles
set_interface_property avalon_mm_master_5 writeWaitTime 0
set_interface_property avalon_mm_master_5 ENABLED true
set_interface_property avalon_mm_master_5 EXPORT_OF ""
set_interface_property avalon_mm_master_5 PORT_NAME_MAP ""
set_interface_property avalon_mm_master_5 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_mm_master_5 SVD_ADDRESS_GROUP ""

add_interface_port avalon_mm_master_5 avm_5_address_i address Input 26
add_interface_port avalon_mm_master_5 avm_5_read_i read Input 1
#add_interface_port avalon_mm_master_5 avm_5_write_i write Input 1
#add_interface_port avalon_mm_master_5 avm_5_writedata_i writedata Input 256
#add_interface_port avalon_mm_master_5 avm_5_byteenable_i byteenable Input 32
add_interface_port avalon_mm_master_5 avm_5_readdata_o readdata Output 256
add_interface_port avalon_mm_master_5 avm_5_waitrequest_o waitrequest Output 1
set_interface_assignment avalon_mm_master_5 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_mm_master_5 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_mm_master_5 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_mm_master_5 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_mm_master_6
# 
add_interface avalon_mm_master_6 avalon end
set_interface_property avalon_mm_master_6 addressUnits WORDS
set_interface_property avalon_mm_master_6 associatedClock clock_sink_100mhz
set_interface_property avalon_mm_master_6 associatedReset reset_sink
set_interface_property avalon_mm_master_6 bitsPerSymbol 8
set_interface_property avalon_mm_master_6 burstOnBurstBoundariesOnly false
set_interface_property avalon_mm_master_6 burstcountUnits WORDS
set_interface_property avalon_mm_master_6 explicitAddressSpan 0
set_interface_property avalon_mm_master_6 holdTime 0
set_interface_property avalon_mm_master_6 linewrapBursts false
set_interface_property avalon_mm_master_6 maximumPendingReadTransactions 0
set_interface_property avalon_mm_master_6 maximumPendingWriteTransactions 0
set_interface_property avalon_mm_master_6 readLatency 0
set_interface_property avalon_mm_master_6 readWaitTime 1
set_interface_property avalon_mm_master_6 setupTime 0
set_interface_property avalon_mm_master_6 timingUnits Cycles
set_interface_property avalon_mm_master_6 writeWaitTime 0
set_interface_property avalon_mm_master_6 ENABLED true
set_interface_property avalon_mm_master_6 EXPORT_OF ""
set_interface_property avalon_mm_master_6 PORT_NAME_MAP ""
set_interface_property avalon_mm_master_6 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_mm_master_6 SVD_ADDRESS_GROUP ""

add_interface_port avalon_mm_master_6 avm_6_address_i address Input 26
add_interface_port avalon_mm_master_6 avm_6_read_i read Input 1
#add_interface_port avalon_mm_master_6 avm_6_write_i write Input 1
#add_interface_port avalon_mm_master_6 avm_6_writedata_i writedata Input 256
#add_interface_port avalon_mm_master_6 avm_6_byteenable_i byteenable Input 32
add_interface_port avalon_mm_master_6 avm_6_readdata_o readdata Output 256
add_interface_port avalon_mm_master_6 avm_6_waitrequest_o waitrequest Output 1
set_interface_assignment avalon_mm_master_6 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_mm_master_6 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_mm_master_6 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_mm_master_6 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_mm_master_7
# 
add_interface avalon_mm_master_7 avalon end
set_interface_property avalon_mm_master_7 addressUnits WORDS
set_interface_property avalon_mm_master_7 associatedClock clock_sink_100mhz
set_interface_property avalon_mm_master_7 associatedReset reset_sink
set_interface_property avalon_mm_master_7 bitsPerSymbol 8
set_interface_property avalon_mm_master_7 burstOnBurstBoundariesOnly false
set_interface_property avalon_mm_master_7 burstcountUnits WORDS
set_interface_property avalon_mm_master_7 explicitAddressSpan 0
set_interface_property avalon_mm_master_7 holdTime 0
set_interface_property avalon_mm_master_7 linewrapBursts false
set_interface_property avalon_mm_master_7 maximumPendingReadTransactions 0
set_interface_property avalon_mm_master_7 maximumPendingWriteTransactions 0
set_interface_property avalon_mm_master_7 readLatency 0
set_interface_property avalon_mm_master_7 readWaitTime 1
set_interface_property avalon_mm_master_7 setupTime 0
set_interface_property avalon_mm_master_7 timingUnits Cycles
set_interface_property avalon_mm_master_7 writeWaitTime 0
set_interface_property avalon_mm_master_7 ENABLED true
set_interface_property avalon_mm_master_7 EXPORT_OF ""
set_interface_property avalon_mm_master_7 PORT_NAME_MAP ""
set_interface_property avalon_mm_master_7 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_mm_master_7 SVD_ADDRESS_GROUP ""

add_interface_port avalon_mm_master_7 avm_7_address_i address Input 26
add_interface_port avalon_mm_master_7 avm_7_read_i read Input 1
#add_interface_port avalon_mm_master_7 avm_7_write_i write Input 1
#add_interface_port avalon_mm_master_7 avm_7_writedata_i writedata Input 256
#add_interface_port avalon_mm_master_7 avm_7_byteenable_i byteenable Input 32
add_interface_port avalon_mm_master_7 avm_7_readdata_o readdata Output 256
add_interface_port avalon_mm_master_7 avm_7_waitrequest_o waitrequest Output 1
set_interface_assignment avalon_mm_master_7 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_mm_master_7 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_mm_master_7 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_mm_master_7 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_mm_slave
# 
add_interface avalon_mm_slave avalon start
set_interface_property avalon_mm_slave addressUnits SYMBOLS
set_interface_property avalon_mm_slave associatedClock clock_sink_100mhz
set_interface_property avalon_mm_slave associatedReset reset_sink
set_interface_property avalon_mm_slave bitsPerSymbol 8
set_interface_property avalon_mm_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_mm_slave burstcountUnits WORDS
set_interface_property avalon_mm_slave doStreamReads false
set_interface_property avalon_mm_slave doStreamWrites false
set_interface_property avalon_mm_slave holdTime 0
set_interface_property avalon_mm_slave linewrapBursts false
set_interface_property avalon_mm_slave maximumPendingReadTransactions 0
set_interface_property avalon_mm_slave maximumPendingWriteTransactions 0
set_interface_property avalon_mm_slave readLatency 0
set_interface_property avalon_mm_slave readWaitTime 1
set_interface_property avalon_mm_slave setupTime 0
set_interface_property avalon_mm_slave timingUnits Cycles
set_interface_property avalon_mm_slave writeWaitTime 0
set_interface_property avalon_mm_slave ENABLED true
set_interface_property avalon_mm_slave EXPORT_OF ""
set_interface_property avalon_mm_slave PORT_NAME_MAP ""
set_interface_property avalon_mm_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_mm_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_mm_slave avs_readdata_i readdata Input 256
add_interface_port avalon_mm_slave avs_waitrequest_i waitrequest Input 1
add_interface_port avalon_mm_slave avs_address_o address Output 64
add_interface_port avalon_mm_slave avs_read_o read Output 1
#add_interface_port avalon_mm_slave avs_write_o write Output 1
#add_interface_port avalon_mm_slave avs_writedata_o writedata Output 256
#add_interface_port avalon_mm_slave avs_byteenable_i byteenable Output 32

