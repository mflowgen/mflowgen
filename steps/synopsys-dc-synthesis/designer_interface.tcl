#=========================================================================
# designer_interface.tcl
#=========================================================================
# The designer_interface.tcl file is the first script run by Design
# Compiler (see the top of dc.tcl). It is the interface that connects the
# dc-synthesis scripts with the following:
#
# - Build system parameters
# - Build system inputs
# - ASIC design kit
# - Plugin scripts
#
# Author : Christopher Torng
# Date   : April 8, 2018

#-------------------------------------------------------------------------
# Parameters
#-------------------------------------------------------------------------

set dc_design_name              $::env(design_name)
set dc_clock_period             $::env(clock_period)
set dc_flatten_effort           $::env(flatten_effort)
set dc_topographical            $::env(topographical)

#-------------------------------------------------------------------------
# Inputs
#-------------------------------------------------------------------------

set dc_rtl_handoff              inputs/design.v
set adk_dir                     inputs/adk

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
                                    [glob -nocomplain inputs/*.db]
                                    [glob -nocomplain inputs/adk/*.db]
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

set dc_flow_dir                 .
set dc_plugins_dir              .
set dc_logs_dir                 logs
set dc_reports_dir              reports
set dc_results_dir              results
set dc_alib_dir                 alib

#-------------------------------------------------------------------------
# Interface to plugins
#-------------------------------------------------------------------------

set dc_pre_synthesis_plugin     pre_synth.tcl
set dc_read_design_plugin       read_design.tcl
set dc_constraints_plugin       inputs/constraints.tcl
set dc_post_synthesis_plugin    post_synth.tcl


