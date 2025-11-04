#=========================================================================
# designer-interface.tcl
#=========================================================================
# The designer-interface.tcl file is the first script run by Genus.
# It is the interface that connects the synthesis scripts with
# the following:
#
# - Build system parameters
# - Build system inputs
# - ASIC design kit

# Author : Alex Carsello, James Thomas
# Date   : July 14, 2020

set design_name                $::env(design_name)
set clock_period               $::env(clock_period)
set gate_clock                 $::env(gate_clock)
set uniquify_with_design_name  $::env(uniquify_with_design_name)
set flatten_effort             $::env(flatten_effort)
set read_hdl_defines           $::env(read_hdl_defines)

# Here we do a weird mapping from our DC flatten_effort to genus flatten_effort
# flatten_effort=0 goes to no flattening
# flatten_effort!=0 goes to flattening to optimize for area + timing (genus default)
# For more info: help auto_ungroup
set auto_ungroup_val "both"
if { $flatten_effort == 0 } {
  puts "Disabling automatic flattening."
  set auto_ungroup_val "none"
}

set_db common_ui false

if { $gate_clock == True } {
  set_attr lp_insert_clock_gating true
}

#-------------------------------------------------------------------------
# (begin compiling library and lef lists)
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
# Library sets
#
# Steveri update Aug 2020: fixed library load ordering.
# For consistency, using code similar to what I found in
# existing step 'cadence-innovus-flowsetup/setup.tcl'
#
# Also, added "lsort" to "glob" for better determinacy.

global vars
set vars(adk_dir) inputs/adk

#-------------------------------------------------------------------------
# Typical-case libraries

# Note: For backward compatibility, keep the following postfix-free libraries:
# stdcells.lib, stdcells-lvt.lib, stdcells-ulvt.lib, stdcells-pm.lib, iocells.lib
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
    puts "WARNING: No typical-typical library is found in ADK nor inputs"
}

#-------------------------------------------------------------------------
# Best-case libraries
# - Process: ff
# - Voltage: highest
# - Temperature: highest (temperature inversion at 28nm and below)
# FIXME note this code repeats all the bc libraries in the list at
# least twice, because of the extra '*-bc-*' pattern...

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
# FIXME is there a reason this only looks for iocells???

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
# LEF files

set vars(lef_files) \
[join "
    $vars(adk_dir)/rtk-tech.lef
    [lsort [glob -nocomplain $vars(adk_dir)/stdcells.lef]]
    [lsort [glob -nocomplain $vars(adk_dir)/stdcells-pm.lef]]
    [lsort [glob -nocomplain $vars(adk_dir)/*.lef]]
    [lsort [glob -nocomplain inputs/*.lef]]
"]

puts "INFO: Found LEF files $vars(lef_files)"
foreach L $vars(lef_files) { echo "LEF    $L" }

set vars(qrcTechFile) $vars(adk_dir)/pdk-typical-qrcTechFile
set vars(capTableFile) $vars(adk_dir)/rtk-typical.captable

