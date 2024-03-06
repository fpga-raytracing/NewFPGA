# TCL File Generated by Component Editor 18.1
# Sun Mar 03 16:55:10 EST 2024
# DO NOT MODIFY


# 
# avalon_sdr "avalon_sdr" v1.0
#  2024.03.03.16:55:10
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module avalon_sdr
# 
set_module_property DESCRIPTION ""
set_module_property NAME avalon_sdr
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME avalon_sdr
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL avalon_sdr
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file avalon_sdr.sv SYSTEM_VERILOG PATH avalon_sdr.sv


# 
# parameters
# 
add_parameter MAX_NREAD INTEGER 64
set_parameter_property MAX_NREAD DEFAULT_VALUE 64
set_parameter_property MAX_NREAD DISPLAY_NAME MAX_NREAD
set_parameter_property MAX_NREAD TYPE INTEGER
set_parameter_property MAX_NREAD UNITS None
set_parameter_property MAX_NREAD ALLOWED_RANGES -2147483648:2147483647
set_parameter_property MAX_NREAD HDL_PARAMETER true
add_parameter MAX_NWRITE INTEGER 64
set_parameter_property MAX_NWRITE DEFAULT_VALUE 64
set_parameter_property MAX_NWRITE DISPLAY_NAME MAX_NWRITE
set_parameter_property MAX_NWRITE TYPE INTEGER
set_parameter_property MAX_NWRITE UNITS None
set_parameter_property MAX_NWRITE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property MAX_NWRITE HDL_PARAMETER true


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
add_interface_port m0 avm_m0_write write Output 1
add_interface_port m0 avm_m0_writedata writedata Output 16
add_interface_port m0 avm_m0_address address Output 32
add_interface_port m0 avm_m0_readdata readdata Input 16
add_interface_port m0 avm_m0_readdatavalid readdatavalid Input 1
add_interface_port m0 avm_m0_byteenable byteenable Output 2
add_interface_port m0 avm_m0_waitrequest waitrequest Input 1


# 
# connection point sdr_readdata
# 
add_interface sdr_readdata conduit end
set_interface_property sdr_readdata associatedClock clock
set_interface_property sdr_readdata associatedReset reset
set_interface_property sdr_readdata ENABLED true
set_interface_property sdr_readdata EXPORT_OF ""
set_interface_property sdr_readdata PORT_NAME_MAP ""
set_interface_property sdr_readdata CMSIS_SVD_VARIABLES ""
set_interface_property sdr_readdata SVD_ADDRESS_GROUP ""

add_interface_port sdr_readdata sdr_readdata export Output 32*MAX_NREAD


# 
# connection point sdr_readstart
# 
add_interface sdr_readstart conduit end
set_interface_property sdr_readstart associatedClock clock
set_interface_property sdr_readstart associatedReset reset
set_interface_property sdr_readstart ENABLED true
set_interface_property sdr_readstart EXPORT_OF ""
set_interface_property sdr_readstart PORT_NAME_MAP ""
set_interface_property sdr_readstart CMSIS_SVD_VARIABLES ""
set_interface_property sdr_readstart SVD_ADDRESS_GROUP ""

add_interface_port sdr_readstart sdr_readstart export Input 1


# 
# connection point sdr_readend
# 
add_interface sdr_readend conduit end
set_interface_property sdr_readend associatedClock clock
set_interface_property sdr_readend associatedReset reset
set_interface_property sdr_readend ENABLED true
set_interface_property sdr_readend EXPORT_OF ""
set_interface_property sdr_readend PORT_NAME_MAP ""
set_interface_property sdr_readend CMSIS_SVD_VARIABLES ""
set_interface_property sdr_readend SVD_ADDRESS_GROUP ""

add_interface_port sdr_readend sdr_readend export Output 1


# 
# connection point sdr_writedata
# 
add_interface sdr_writedata conduit end
set_interface_property sdr_writedata associatedClock clock
set_interface_property sdr_writedata associatedReset reset
set_interface_property sdr_writedata ENABLED true
set_interface_property sdr_writedata EXPORT_OF ""
set_interface_property sdr_writedata PORT_NAME_MAP ""
set_interface_property sdr_writedata CMSIS_SVD_VARIABLES ""
set_interface_property sdr_writedata SVD_ADDRESS_GROUP ""

add_interface_port sdr_writedata sdr_writedata export Input 32*MAX_NWRITE


# 
# connection point sdr_writestart
# 
add_interface sdr_writestart conduit end
set_interface_property sdr_writestart associatedClock clock
set_interface_property sdr_writestart associatedReset reset
set_interface_property sdr_writestart ENABLED true
set_interface_property sdr_writestart EXPORT_OF ""
set_interface_property sdr_writestart PORT_NAME_MAP ""
set_interface_property sdr_writestart CMSIS_SVD_VARIABLES ""
set_interface_property sdr_writestart SVD_ADDRESS_GROUP ""

add_interface_port sdr_writestart sdr_writestart export Input 1


# 
# connection point sdr_writeend
# 
add_interface sdr_writeend conduit end
set_interface_property sdr_writeend associatedClock clock
set_interface_property sdr_writeend associatedReset reset
set_interface_property sdr_writeend ENABLED true
set_interface_property sdr_writeend EXPORT_OF ""
set_interface_property sdr_writeend PORT_NAME_MAP ""
set_interface_property sdr_writeend CMSIS_SVD_VARIABLES ""
set_interface_property sdr_writeend SVD_ADDRESS_GROUP ""

add_interface_port sdr_writeend sdr_writeend export Output 1


# 
# connection point sdr_nelems
# 
add_interface sdr_nelems conduit end
set_interface_property sdr_nelems associatedClock clock
set_interface_property sdr_nelems associatedReset ""
set_interface_property sdr_nelems ENABLED true
set_interface_property sdr_nelems EXPORT_OF ""
set_interface_property sdr_nelems PORT_NAME_MAP ""
set_interface_property sdr_nelems CMSIS_SVD_VARIABLES ""
set_interface_property sdr_nelems SVD_ADDRESS_GROUP ""

add_interface_port sdr_nelems sdr_nelems export Input 30


# 
# connection point sdr_baseaddr
# 
add_interface sdr_baseaddr conduit end
set_interface_property sdr_baseaddr associatedClock clock
set_interface_property sdr_baseaddr associatedReset reset
set_interface_property sdr_baseaddr ENABLED true
set_interface_property sdr_baseaddr EXPORT_OF ""
set_interface_property sdr_baseaddr PORT_NAME_MAP ""
set_interface_property sdr_baseaddr CMSIS_SVD_VARIABLES ""
set_interface_property sdr_baseaddr SVD_ADDRESS_GROUP ""

add_interface_port sdr_baseaddr sdr_baseaddr export Input 32


# 
# connection point interrupt_sender
# 
add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint ""
set_interface_property interrupt_sender associatedClock clock
set_interface_property interrupt_sender bridgedReceiverOffset ""
set_interface_property interrupt_sender bridgesToReceiver ""
set_interface_property interrupt_sender ENABLED true
set_interface_property interrupt_sender EXPORT_OF ""
set_interface_property interrupt_sender PORT_NAME_MAP ""
set_interface_property interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port interrupt_sender irq irq Output 1

