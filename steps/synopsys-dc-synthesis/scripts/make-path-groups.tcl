#=========================================================================
# make-path-groups.tcl
#=========================================================================
# Set up common path groups to help the timing engine focus individually
# on different sets of paths.
#
# Author : Christopher Torng
# Date   : May 14, 2018
#

set ports_clock_root [filter_collection \
                       [get_attribute [get_clocks] sources] \
                       object_class==port]

group_path -name REGOUT \
           -to   [all_outputs]

group_path -name REGIN \
           -from [remove_from_collection [all_inputs] $ports_clock_root]

group_path -name FEEDTHROUGH \
           -from [remove_from_collection [all_inputs] $ports_clock_root] \
           -to   [all_outputs]


