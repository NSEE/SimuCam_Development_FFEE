# TCL File Generated by Component Editor 18.1
# Sat Apr 04 23:17:08 BRT 2020
# DO NOT MODIFY


# 
# Signal_Filter_Latch "Signal_Filter_Latch" v1.0
# rfranca 2020.04.04.23:17:08
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module Signal_Filter_Latch
# 
set_module_property DESCRIPTION ""
set_module_property NAME Signal_Filter_Latch
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR rfranca
set_module_property DISPLAY_NAME Signal_Filter_Latch
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sgfl_signal_filter_latch_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file sgfl_signal_filter_latch_top.vhd VHDL PATH Signal_Filter_Latch/sgfl_signal_filter_latch_top.vhd TOP_LEVEL_FILE

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL sgfl_signal_filter_latch_top
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file sgfl_signal_filter_latch_top.vhd VHDL PATH Signal_Filter_Latch/sgfl_signal_filter_latch_top.vhd TOP_LEVEL_FILE


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
set_interface_property reset_sink associatedClock clock_sink_50mhz
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink reset_i reset Input 1


# 
# connection point clock_sink_50mhz
# 
add_interface clock_sink_50mhz clock end
set_interface_property clock_sink_50mhz clockRate 50000000
set_interface_property clock_sink_50mhz ENABLED true
set_interface_property clock_sink_50mhz EXPORT_OF ""
set_interface_property clock_sink_50mhz PORT_NAME_MAP ""
set_interface_property clock_sink_50mhz CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink_50mhz SVD_ADDRESS_GROUP ""

add_interface_port clock_sink_50mhz clk_50_i clk Input 1


# 
# connection point clock_sink_200mhz
# 
add_interface clock_sink_200mhz clock end
set_interface_property clock_sink_200mhz clockRate 200000000
set_interface_property clock_sink_200mhz ENABLED true
set_interface_property clock_sink_200mhz EXPORT_OF ""
set_interface_property clock_sink_200mhz PORT_NAME_MAP ""
set_interface_property clock_sink_200mhz CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink_200mhz SVD_ADDRESS_GROUP ""

add_interface_port clock_sink_200mhz clk_200_i clk Input 1


# 
# connection point conduit_end_unfiltered_sig
# 
add_interface conduit_end_unfiltered_sig conduit end
set_interface_property conduit_end_unfiltered_sig associatedClock clock_sink_200mhz
set_interface_property conduit_end_unfiltered_sig associatedReset reset_sink
set_interface_property conduit_end_unfiltered_sig ENABLED true
set_interface_property conduit_end_unfiltered_sig EXPORT_OF ""
set_interface_property conduit_end_unfiltered_sig PORT_NAME_MAP ""
set_interface_property conduit_end_unfiltered_sig CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_unfiltered_sig SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_unfiltered_sig unfiltered_sig_i unfiltered_sig_signal Input 1


# 
# connection point conduit_end_filtered_sig
# 
add_interface conduit_end_filtered_sig conduit end
set_interface_property conduit_end_filtered_sig associatedClock clock_sink_50mhz
set_interface_property conduit_end_filtered_sig associatedReset reset_sink
set_interface_property conduit_end_filtered_sig ENABLED true
set_interface_property conduit_end_filtered_sig EXPORT_OF ""
set_interface_property conduit_end_filtered_sig PORT_NAME_MAP ""
set_interface_property conduit_end_filtered_sig CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_filtered_sig SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_filtered_sig filtered_sig_o filtered_sig_signal Output 1
