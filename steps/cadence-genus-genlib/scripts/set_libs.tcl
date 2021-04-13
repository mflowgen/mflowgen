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

set vars(libs_typical,timing) \
    [join "
        $vars(adk_dir)/stdcells.lib
        [lsort [glob -nocomplain $vars(adk_dir)/stdcells-lvt.lib]]
        [lsort [glob -nocomplain $vars(adk_dir)/stdcells-ulvt.lib]]
        [lsort [glob -nocomplain $vars(adk_dir)/stdcells-pm.lib]]
        [lsort [glob -nocomplain $vars(adk_dir)/iocells.lib]]
        [lsort [glob -nocomplain inputs/*tt*.lib]]
        [lsort [glob -nocomplain inputs/*TT*.lib]]
        "]
puts "INFO: Found typical-typical libraries $vars(libs_typical,timing)"
foreach L $vars(libs_typical,timing) { echo "L_TT    $L" }

#-------------------------------------------------------------------------
# Best-case libraries
# - Process: ff
# - Voltage: highest
# - Temperature: highest (temperature inversion at 28nm and below)
# FIXME note this code repeats all the bc libraries in the list at
# least twice, because of the extra '*-bc-*' pattern...is this intentional?

if {[file exists $vars(adk_dir)/stdcells-bc.lib]} {
    set vars(libs_bc,timing) \
        [join "
            $vars(adk_dir)/stdcells-bc.lib
            [lsort [glob -nocomplain $vars(adk_dir)/stdcells-lvt-bc.lib]]
            [lsort [glob -nocomplain $vars(adk_dir)/stdcells-ulvt-bc.lib]]
            [lsort [glob -nocomplain $vars(adk_dir)/stdcells-pm-bc.lib]]
            [lsort [glob -nocomplain $vars(adk_dir)/iocells-bc.lib]]
            [lsort [glob -nocomplain $vars(adk_dir)/*-bc*.lib]]
            [lsort [glob -nocomplain inputs/*ff*.lib]]
            [lsort [glob -nocomplain inputs/*FF*.lib]]
        "]
  puts "INFO: Found fast-fast libraries $vars(libs_bc,timing)"
  foreach L $vars(libs_bc,timing) { echo "L_FF    $L" }
}

#-------------------------------------------------------------------------
# Worst-case libraries
# - Process: ss
# - Voltage: lowest
# - Temperature: lowest (temperature inversion at 28nm and below)

if {[file exists $vars(adk_dir)/stdcells-wc.lib]} {
    set vars(libs_wc,timing) \
        [join "
            $vars(adk_dir)/stdcells-wc.lib
            [lsort [glob -nocomplain $vars(adk_dir)/stdcells-lvt-wc.lib]]
            [lsort [glob -nocomplain $vars(adk_dir)/stdcells-ulvt-wc.lib]]
            [lsort [glob -nocomplain $vars(adk_dir)/stdcells-pm-wc.lib]]
            [lsort [glob -nocomplain $vars(adk_dir)/iocells-wc.lib]]
            [lsort [glob -nocomplain inputs/*ss*.lib]]
            [lsort [glob -nocomplain inputs/*SS*.lib]]
      "]
  puts "INFO: Found slow-slow libraries $vars(libs_wc,timing)"
  foreach L $vars(libs_wc,timing) { echo "L_SS    $L" }
}

#-------------------------------------------------------------------------
# 'set_attr' is legacy mode command I guess
if { [is_common_ui_mode] } { set_db common_ui false }

#-------------------------------------------------------------------------
puts "INFO: Using typical-typical libs"
set_attr library $vars(libs_typical,timing)
