#=========================================================================
# read-design.tcl
#=========================================================================
# Author : Alex Carsello
# Date   : September 28, 2020

read_hdl -define $read_hdl_defines -sv [lsort [glob -directory inputs -type f *.v *.sv]]

# Prevent backslashes from being prepended to signal names...
# this causes SAIF files to be invalid...needs to be before elaboration.

set_attribute hdl_array_naming_style %s_%d
set_attribute hdl_bus_wire_naming_style %s_%d
set_attribute bit_blasted_port_style %s_%d /

elaborate $design_name

