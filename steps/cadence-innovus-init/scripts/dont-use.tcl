#=========================================================================
# dont-use.tcl
#=========================================================================
# Although the ADK_DONT_USE_CELL_LIST variable is already applied in the 
# sythesis script, we also need to apply it here to ensure that the tool
# won't use the cells in the list as buffers/inverters.
# This is equivalent to setting the "dont_use_list" environment variable
# in setup.tcl in cadence-innovus-flowsetup. However, the commands created
# by Innovus-Foundation-Flow throw errors if a pattern is not found in the
# loaded libraries. For example, a design that only uses normal-VT cells
# will run into errors if a pattern for high-VT cells is specified in the
# ADK_DONT_USE_CELL_LIST variable.
# The solution is to implement the setDontUse here, which will only execute
# the command on found cells.
#
# Author : 
# Date   : 

if {[info exists ADK_DONT_USE_CELL_LIST]} {
    foreach_in_collection cell [get_lib_cells $ADK_DONT_USE_CELL_LIST] {
        setDontUse [get_object_name $cell] true
    }
}