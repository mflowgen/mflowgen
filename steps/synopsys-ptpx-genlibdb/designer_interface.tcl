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
# Author : Christopher Torng
# Date   : May 20, 2019

#-------------------------------------------------------------------------
# Interface to the ASIC design kit
#-------------------------------------------------------------------------

set ptpx_additional_search_path   inputs/adk
set ptpx_target_libraries         \
    [join "
        [lsort [glob -nocomplain inputs/adk/stdcells.db]]
	[lsort [glob -nocomplain inputs/adk/stdcells-lvt.db]]
	[lsort [glob -nocomplain inputs/adk/stdcells-ulvt.db]]
        [lsort [glob -nocomplain inputs/adk/stdcells-pm.db]]
        [lsort [glob -nocomplain inputs/adk/iocells.db]]
        [lsort [glob -nocomplain inputs/adk/*-typical*.db]]
        [lsort [glob -nocomplain inputs/*tt*.db]]
        [lsort [glob -nocomplain inputs/*TT*.db]]
        [lsort [glob -nocomplain inputs/*-typical*.db]]
    "]
set ptpx_extra_link_libraries     [join "
                                    [lsort [glob -nocomplain inputs/*.db]]
                                    [lsort [glob -nocomplain inputs/adk/*.db]]
                                "]

# Remove any elements of target libraries froim extra_link_libraries
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

set ptpx_design_name              $::env(design_name)

set ptpx_flow_dir                 .
set ptpx_plugins_dir              .
set ptpx_logs_dir                 logs
set ptpx_reports_dir              reports
set ptpx_results_dir              results

set ptpx_gl_netlist               [lsort [glob -nocomplain inputs/*.vcs.v]]
set ptpx_sdc                      [lsort [glob -nocomplain inputs/*.pt.sdc]]
set ptpx_spef                     [lsort [glob -nocomplain inputs/*.spef.gz]]

puts "done"

