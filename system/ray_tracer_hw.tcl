# TCL File Generated by Component Editor 18.0
# Fri Mar 29 20:56:39 EDT 2024
# DO NOT MODIFY


# 
# ray_tracer "ray_tracer" v1.0
#  2024.03.29.20:56:39
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module ray_tracer
# 
set_module_property DESCRIPTION ""
set_module_property NAME ray_tracer
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME ray_tracer
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL ray_tracer
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file raytracer.sv SYSTEM_VERILOG PATH raytracer.sv TOP_LEVEL_FILE
add_fileset_file avalon_sdr.sv SYSTEM_VERILOG PATH avalon_sdr.sv
add_fileset_file cache.sv SYSTEM_VERILOG PATH cache.sv
add_fileset_file fip_opts.sv SYSTEM_VERILOG PATH fip_opts.sv
add_fileset_file intersection.sv SYSTEM_VERILOG PATH intersection.sv
add_fileset_file reader.sv SYSTEM_VERILOG PATH reader.sv
add_fileset_file divider.sv SYSTEM_VERILOG PATH divider.sv


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point m0
# 
add_interface m0 avalon start
set_interface_property m0 addressUnits SYMBOLS
set_interface_property m0 associatedClock clock
set_interface_property m0 associatedReset reset
set_interface_property m0 bitsPerSymbol 8
set_interface_property m0 burstOnBurstBoundariesOnly false
set_interface_property m0 burstcountUnits WORDS
set_interface_property m0 doStreamReads false
set_interface_property m0 doStreamWrites false
set_interface_property m0 holdTime 0
set_interface_property m0 linewrapBursts false
set_interface_property m0 maximumPendingReadTransactions 0
set_interface_property m0 maximumPendingWriteTransactions 0
set_interface_property m0 readLatency 0
set_interface_property m0 readWaitTime 1
set_interface_property m0 setupTime 0
set_interface_property m0 timingUnits Cycles
set_interface_property m0 writeWaitTime 0
set_interface_property m0 ENABLED true
set_interface_property m0 EXPORT_OF ""
set_interface_property m0 PORT_NAME_MAP ""
set_interface_property m0 CMSIS_SVD_VARIABLES ""
set_interface_property m0 SVD_ADDRESS_GROUP ""

add_interface_port m0 avm_m0_read read Output 1
add_interface_port m0 avm_m0_address address Output 32
add_interface_port m0 avm_m0_readdata readdata Input 16
add_interface_port m0 avm_m0_readdatavalid readdatavalid Input 1
add_interface_port m0 avm_m0_byteenable byteenable Output 2
add_interface_port m0 avm_m0_waitrequest waitrequest Input 1
add_interface_port m0 avm_m0_write write Output 1
add_interface_port m0 avm_m0_writedata writedata Output 16


# 
# connection point end_rt
# 
add_interface end_rt conduit end
set_interface_property end_rt associatedClock clock
set_interface_property end_rt associatedReset reset
set_interface_property end_rt ENABLED true
set_interface_property end_rt EXPORT_OF ""
set_interface_property end_rt PORT_NAME_MAP ""
set_interface_property end_rt CMSIS_SVD_VARIABLES ""
set_interface_property end_rt SVD_ADDRESS_GROUP ""

add_interface_port end_rt end_rt export Output 1


# 
# connection point end_rtstat
# 
add_interface end_rtstat conduit end
set_interface_property end_rtstat associatedClock clock
set_interface_property end_rtstat associatedReset reset
set_interface_property end_rtstat ENABLED true
set_interface_property end_rtstat EXPORT_OF ""
set_interface_property end_rtstat PORT_NAME_MAP ""
set_interface_property end_rtstat CMSIS_SVD_VARIABLES ""
set_interface_property end_rtstat SVD_ADDRESS_GROUP ""

add_interface_port end_rtstat end_rtstat export Output 8


# 
# connection point start_rt
# 
add_interface start_rt conduit end
set_interface_property start_rt associatedClock clock
set_interface_property start_rt associatedReset reset
set_interface_property start_rt ENABLED true
set_interface_property start_rt EXPORT_OF ""
set_interface_property start_rt PORT_NAME_MAP ""
set_interface_property start_rt CMSIS_SVD_VARIABLES ""
set_interface_property start_rt SVD_ADDRESS_GROUP ""

add_interface_port start_rt start_rt export Input 1


# 
# connection point raytest
# 
add_interface raytest conduit end
set_interface_property raytest associatedClock clock
set_interface_property raytest associatedReset reset
set_interface_property raytest ENABLED true
set_interface_property raytest EXPORT_OF ""
set_interface_property raytest PORT_NAME_MAP ""
set_interface_property raytest CMSIS_SVD_VARIABLES ""
set_interface_property raytest SVD_ADDRESS_GROUP ""

add_interface_port raytest raytest export Output 128


# 
# connection point raytest_en
# 
add_interface raytest_en conduit end
set_interface_property raytest_en associatedClock clock
set_interface_property raytest_en associatedReset ""
set_interface_property raytest_en ENABLED true
set_interface_property raytest_en EXPORT_OF ""
set_interface_property raytest_en PORT_NAME_MAP ""
set_interface_property raytest_en CMSIS_SVD_VARIABLES ""
set_interface_property raytest_en SVD_ADDRESS_GROUP ""

add_interface_port raytest_en raytest_en export Output 1

