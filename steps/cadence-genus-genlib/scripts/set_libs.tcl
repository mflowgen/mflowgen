#=========================================================================
# set_libs.tcl
#=========================================================================
# Load tech libs in a precise order to avoid ambiguities
#
# Author : Stephen Richardson
# Date   : December 2020

set vars(adk_dir) inputs/adk

#-------------------------------------------------------------------------
# Typical-case libraries

set list_libs_tt \
    [join "
        [lsort [glob -nocomplain $vars(adk_dir)/stdcells.lib]]
        [lsort [glob -nocomplain $vars(adk_dir)/stdcells-lvt.lib]]
        [lsort [glob -nocomplain $vars(adk_dir)/stdcells-ulvt.lib]]
        [lsort [glob -nocomplain $vars(adk_dir)/stdcells-pm.lib]]
        [lsort [glob -nocomplain $vars(adk_dir)/iocells.lib]]
        [lsort [glob -nocomplain $vars(adk_dir)/*-typical*.lib]]
        [lsort [glob -nocomplain inputs/*tt*.lib]]
        [lsort [glob -nocomplain inputs/*TT*.lib]]
    "]

if {[llength $list_libs_tt] > 0} {
    set vars(libs_typical,timing) $list_libs_tt
    puts "INFO: Found typical-typical libraries:"
    foreach L $vars(libs_typical,timing) { echo "L_TT    $L" }
} else {
    puts "ERROR: No typical-typical library is found in ADK nor inputs"
}

#-------------------------------------------------------------------------
# Best-case libraries
# - Process: ff
# - Voltage: highest
# - Temperature: highest (temperature inversion at 28nm and below)

set list_libs_bc \
    [join "
        [lsort [glob -nocomplain $vars(adk_dir)/*-bc*.lib]]
        [lsort [glob -nocomplain inputs/*ff*.lib]]
        [lsort [glob -nocomplain inputs/*FF*.lib]]
    "]

if {[llength $list_libs_bc] > 0} {
    set vars(libs_bc,timing) $list_libs_bc
    puts "INFO: Found fast-fast libraries:"
    foreach L $vars(libs_bc,timing) { echo "L_FF    $L" }
} else {
    puts "WARNING: No fast-fast library is found in ADK nor inputs"
}

#-------------------------------------------------------------------------
# Worst-case libraries
# - Process: ss
# - Voltage: lowest
# - Temperature: lowest (temperature inversion at 28nm and below)

set list_libs_wc \
    [join "
        [lsort [glob -nocomplain $vars(adk_dir)/*-wc*.lib]]
        [lsort [glob -nocomplain inputs/*ss*.lib]]
        [lsort [glob -nocomplain inputs/*SS*.lib]]
    "]

if {[llength $list_libs_wc] > 0} {
    set vars(libs_wc,timing) $list_libs_wc
    puts "INFO: Found slow-slow libraries:"
    foreach L $vars(libs_wc,timing) { echo "L_SS    $L" }
} else {
    puts "WARNING: No slow-slow library is found in ADK nor inputs"
}

#-------------------------------------------------------------------------
# 'set_attr' is legacy mode command I guess
if { [is_common_ui_mode] } { set_db common_ui false }

#-------------------------------------------------------------------------
puts "INFO: Using typical-typical libs"
set_attr library $vars(libs_typical,timing)
