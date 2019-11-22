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
set ptpx_target_libraries         inputs/adk/stdcells.db

#-------------------------------------------------------------------------
# Interface to the build system
#-------------------------------------------------------------------------

set ptpx_design_name              $::env(design_name)

set ptpx_flow_dir                 .
set ptpx_plugins_dir              .
set ptpx_logs_dir                 logs
set ptpx_reports_dir              reports
set ptpx_results_dir              results

set ptpx_gl_netlist               [glob -nocomplain inputs/*.vcs.v]
set ptpx_sdc                      [glob -nocomplain inputs/*.pt.sdc]
set ptpx_spef                     [glob -nocomplain inputs/*.spef.gz]

puts "done"

