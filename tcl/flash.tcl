#------------------------------------------------------------------------------
# prog_hw_vivado.tcl
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#
# modifed by Barrett Tieman to take args so that it can be used with a Makefile
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# program script for Vivado
#
# call with
# vivado -nolog -mode batch -source prog_hw_vivado.tcl


if { $argc != 1 } {
    puts [ concat "Usage: " $argv0  "BITSTREAM_PATH" ]
    puts "Please try again"
} else {
    set BITSTREAM_PATH [ lindex $argv 0 ]
    puts [ concat "BITSTREAM_PATH: " $BITSTREAM_PATH]

    open_hw_manager
    connect_hw_server
    open_hw_target [lindex [get_hw_targets] 0]
    set_property PROGRAM.FILE ${BITSTREAM_PATH} [lindex [get_hw_devices] 0]
    program_hw_devices [lindex [get_hw_devices] 0]
}
