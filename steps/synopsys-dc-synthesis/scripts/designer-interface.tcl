#=========================================================================
# designer-interface.tcl
#=========================================================================
# The designer-interface.tcl file is the first script run by Design
# Compiler. It is the interface that connects the synthesis scripts with
# the following:
#
# - Build system parameters
# - Build system inputs
# - ASIC design kit
#
# Author : Christopher Torng
# Date   : April 8, 2018

#-------------------------------------------------------------------------
# Parameters
#-------------------------------------------------------------------------

set design_name                   $::env(design_name)
set clock_period                  $::env(clock_period)
# dc_design_name and dc_clock_period kept for backwards comptability,
# prefer to use design_name and clock_period for tool independence
set dc_design_name                $::env(design_name)
set dc_clock_period               $::env(clock_period)
set dc_saif_instance              $::env(saif_instance)
set dc_flatten_effort             $::env(flatten_effort)
set dc_topographical              $::env(topographical)
set dc_num_cores                  $::env(nthreads)
set dc_high_effort_area_opt       $::env(high_effort_area_opt)
set dc_gate_clock                 $::env(gate_clock)
set dc_uniquify_with_design_name  $::env(uniquify_with_design_name)
set dc_suppress_msg 			  $::env(suppress_msg)
set dc_suppressed_msg  			  [split $::env(suppressed_msg) ","]

#-------------------------------------------------------------------------
# Inputs
#-------------------------------------------------------------------------

set dc_rtl_handoff              inputs/design.v
set adk_dir                     inputs/adk
set dc_upf                      inputs/design.upf

# Extra libraries
#
# The glob below will capture any libraries collected by the build system
# (e.g., SRAM libraries) generated from steps that synthesis depends on.
#
# To add more link libraries (e.g., IO cells, hierarchical blocks), append
# to the "dc_extra_link_libraries" variable in the pre-synthesis plugin
# like this:
#
#   set dc_extra_link_libraries  [join "
#                                  $dc_extra_link_libraries
#                                  extra1.db
#                                  extra2.db
#                                  extra3.db
#                                "]

set dc_extra_link_libraries     [join "
                                    [lsort [glob -nocomplain inputs/*.db]]
                                    [lsort [glob -nocomplain inputs/adk/*.db]]
                                "]

#-------------------------------------------------------------------------
# Interface to the ASIC design kit
#-------------------------------------------------------------------------

set dc_milkyway_ref_libraries   $adk_dir/stdcells.mwlib
set dc_milkyway_tf              $adk_dir/rtk-tech.tf
set dc_tluplus_map              $adk_dir/rtk-tluplus.map
set dc_tluplus_max              $adk_dir/rtk-max.tluplus
set dc_tluplus_min              $adk_dir/rtk-min.tluplus
set dc_adk_tcl                  $adk_dir/adk.tcl
set dc_target_libraries         stdcells.db

# Extra libraries

set dc_additional_search_path   $adk_dir

#-------------------------------------------------------------------------
# Directories
#-------------------------------------------------------------------------

set dc_reports_dir              reports
set dc_results_dir              results
set dc_alib_dir                 alib


