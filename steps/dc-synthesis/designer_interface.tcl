#=========================================================================
# designer_interface.tcl
#=========================================================================
# The designer_interface.tcl file is the first script run by Design
# Compiler (see the top of dc.tcl). It is the interface that connects the
# dc-synthesis scripts with the following:
#
# - ASIC design kit
# - Build system variables
# - Plugin scripts
#
# Author : Christopher Torng
# Date   : April 8, 2018

#-------------------------------------------------------------------------
# Interface to the ASIC design kit
#-------------------------------------------------------------------------

set dc_additional_search_path   $::env(adk_dir)
set dc_milkyway_ref_libraries   $::env(adk_dir)/stdcells.mwlib
set dc_milkyway_tf              $::env(adk_dir)/rtk-tech.tf
set dc_tluplus_map              $::env(adk_dir)/rtk-tluplus.map
set dc_tluplus_max              $::env(adk_dir)/rtk-max.tluplus
set dc_tluplus_min              $::env(adk_dir)/rtk-min.tluplus
set dc_adk_tcl                  $::env(adk_dir)/adk.tcl

set dc_target_libraries         stdcells.db

#-------------------------------------------------------------------------
# Interface to the build system
#-------------------------------------------------------------------------

set dc_design_name              $::env(design_name)

set dc_flow_dir                 $::env(dc_flow_dir)
set dc_plugins_dir              $::env(dc_plugins_dir)
set dc_logs_dir                 $::env(dc_logs_dir)
set dc_reports_dir              $::env(dc_reports_dir)
set dc_results_dir              $::env(dc_results_dir)
set dc_collect_dir              $::env(dc_collect_dir)

set dc_rtl_handoff              $::env(dc_rtl_handoff)
set dc_clock_period             $::env(dc_clock_period)
set dc_alib_dir                 $::env(dc_alib_dir)

# The glob below will capture any libraries collected by the build system
# (e.g., SRAM libraries) generated from steps that synthesis depends on.

set dc_extra_link_libraries [glob -nocomplain $dc_collect_dir/*.db]

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

#-------------------------------------------------------------------------
# Interface to plugins
#-------------------------------------------------------------------------

set dc_pre_synthesis_plugin     ${dc_plugins_dir}/pre_synth.tcl
set dc_read_design_plugin       ${dc_plugins_dir}/read_design.tcl
set dc_constraints_plugin       ${dc_plugins_dir}/constraints.tcl
set dc_post_synthesis_plugin    ${dc_plugins_dir}/post_synth.tcl


