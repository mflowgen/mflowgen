#=========================================================================
# read-design.tcl
#=========================================================================
# Author : Alex Carsello
# Date   : September 28, 2020

read_hdl -sv [lsort [glob -directory inputs -type f *.v *.sv]]
elaborate $design_name

