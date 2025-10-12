#=========================================================================
# designer_interface.tcl
#=========================================================================
# The designer_interface.tcl file is the first script run by PTPX (see the
# top of ptpx.tcl). It is the interface that connects the scripts with
# the following:
#
# - ASIC design kit
# - Build system variables
#
# Author : Alex Carsello
# Date   : January 31, 2020

#-------------------------------------------------------------------------
# Interface to the ASIC design kit
#-------------------------------------------------------------------------

set ptpx_additional_search_path inputs/adk

set ptpx_target_libraries [join "
  [lsort [glob -nocomplain inputs/adk/stdcells*-$::env(corner_setup).db]]
  [lsort [glob -nocomplain inputs/adk/stdcells*-$::env(corner_hold).db]]
"]

set ptpx_extra_link_libraries [join "
  [lsort [glob -nocomplain inputs/adk/*-$::env(corner_setup).db]]
  [lsort [glob -nocomplain inputs/*-$::env(corner_setup).db]]
  [lsort [glob -nocomplain inputs/adk/*-$::env(corner_hold).db]]
  [lsort [glob -nocomplain inputs/*-$::env(corner_hold).db]]
"]

# Remove any elements of target libraries from extra_link_libraries

set exclusion_result {}

foreach elem $ptpx_extra_link_libraries {
  if { [lsearch -exact $ptpx_target_libraries $elem] == -1 } {
    lappend exclusion_result $elem
  }
}

set ptpx_extra_link_libraries $exclusion_result

#-------------------------------------------------------------------------
# Interface to the build system
#-------------------------------------------------------------------------

set ptpx_design_name $::env(design_name)

set ptpx_gl_netlist  [lsort [glob -nocomplain inputs/*.vcs.v]]
set ptpx_sdc         [lsort [glob -nocomplain inputs/*.pt.sdc]]
set ptpx_spef        [lsort [glob -nocomplain inputs/*.spef.gz]]

puts "done"

