#=========================================================================
# setup.tcl
#=========================================================================
# Innovus foundation flow setup.
#
# Note that according to the Innovus foundation flow user guide, setup.tcl
# is intended to be used to define common process, technology, and library
# information. Then innovus_config.tcl is then used to define
# "block-specific" information like power and ground nets, tie and filler
# cells, welltaps and endcaps, enabling useful skew, enabling clock
# gating, etc.
#
# In our BRG flow, most of our blocks are built the same way, so most of
# the "block-specific" information is really common information. For
# example, we use the same names for power and ground, the same cells for
# tie and filler, and the same welltaps and endcaps.
#
# With this in mind, any options that are not expected to change from
# design to design will be collected into this setup file. If we want a
# different set of options, we can create a separate setup file and create
# a corresponding separate ADK view that sources that setup file.
#
# Date   : February 26, 2018
# Author : Christopher Torng
#

global vars

#-------------------------------------------------------------------------
# Design-specific overrides
#-------------------------------------------------------------------------
# FIXME: design-specific will override!!

set vars(plug_dir)            $::env(innovus_plugins_dir)

if {[file exists $vars(plug_dir)/setup.tcl]} {
  source $vars(plug_dir)/setup.tcl
  return
}

#-------------------------------------------------------------------------
#-------------------------------------------------------------------------
# ADK Setup
#-------------------------------------------------------------------------

set adk_dir                   $::env(adk_dir)
set vars(process)             $::env(process); # E.g., "28nm"

#-------------------------------------------------------------------------
# Design
#-------------------------------------------------------------------------

set vars(dc_results_dir)      $::env(innovus_ff_collect_dir)

set vars(design)              $::env(design_name)
set vars(design_root)         ./
set vars(netlist)             $vars(dc_results_dir)/$vars(design).mapped.v

#-------------------------------------------------------------------------
# Directories
#-------------------------------------------------------------------------

set vars(script_root)         $::env(innovus_ff_script_root)
#set vars(plug_dir)            $::env(innovus_plugins_dir) # Currently set up top
set vars(log_dir)             $::env(innovus_logs_dir)
set vars(rpt_dir)             $::env(innovus_reports_dir)
set vars(results_dir)         $::env(innovus_results_dir)
set vars(dbs_dir)             $::env(innovus_handoffs_dir)

#-------------------------------------------------------------------------
# Libraries
#-------------------------------------------------------------------------

# Source the setup file for the stdcells

source $adk_dir/stdcells.tcl

# Should this be slow fast only? Or more like corners?

set vars(library_sets)        libs_typical
#set vars(libs_typical,si)     libs/stdcells.cdb

set vars(libs_typical,timing) [join "$adk_dir/stdcells.lib
                                     $adk_dir/iocells.lib"]

set vars(lef_files) [join "$adk_dir/rtk-tech.lef
                           $adk_dir/iocells.lef
                           $adk_dir/iocells-bondpads.lef
                           $adk_dir/stdcells.lef" ]

# Difference between library_sets, rc_corners, and delay_corners?
#
# - A delay_corner is made by choosing an rc_corner and a library_set
# - The rc_corner is the qrcTechFile, which is the wire RC
# - The library_set is the standard cells
#
# - Then an analysis view is made of a delay corner and a constraints mode
# - The analysis view can focus on setup or hold, depending on which
#   corner and which constraints mode you pick

#-------------------------------------------------------------------------
# RC Corners
#-------------------------------------------------------------------------

set vars(rc_corners)                        "typical"

set vars(typical,cap_table)                 $adk_dir/rtk-typical.captable
#set vars(typical,qx_tech_file)              $adk_dir/pdk-typical-qrcTechFile
set vars(typical,T)                         25

#set vars(rcbest,qx_tech_file)               $adk_dir/pdk-rcbest-qrcTechFile
#set vars(rcbest,T)                          0

#set vars(rcworst,qx_tech_file)              $adk_dir/pdk-rcworst-qrcTechFile
#set vars(rcworst,T)                         125

#-------------------------------------------------------------------------
# Delay Corners
#-------------------------------------------------------------------------

set vars(delay_corners)                     delay_typical
set vars(delay_typical,library_set)         libs_typical
set vars(delay_typical,rc_corner)           typical

# FIXME
# There is some "early check" and "late check" options I'm not using...
# also some setup derating and hold derating I'm not using

#-------------------------------------------------------------------------
# Constraint Modes
#-------------------------------------------------------------------------

set vars(constraint_modes)                  constraints_default

set vars(constraints_default,pre_cts_sdc)   $vars(dc_results_dir)/$vars(design).mapped.sdc
set vars(constraints_default,post_cts_sdc)  $vars(dc_results_dir)/$vars(design).mapped.sdc

#-------------------------------------------------------------------------
# Analysis Views
#-------------------------------------------------------------------------

set vars(analysis_views)                    analysis_default
set vars(analysis_default,delay_corner)     delay_typical
set vars(analysis_default,constraint_mode)  constraints_default

set vars(setup_analysis_views)              analysis_default
set vars(default_setup_view)                analysis_default
set vars(active_setup_views)                analysis_default

set vars(hold_analysis_views)               analysis_default
set vars(default_hold_view)                 analysis_default
set vars(active_hold_views)                 analysis_default

set vars(power_analysis_view)               analysis_default

#-------------------------------------------------------------------------
# Scripts
#-------------------------------------------------------------------------

set vars(fp_tcl_file)                       $vars(plug_dir)/floorplan.tcl

#-------------------------------------------------------------------------
# Process information
#-------------------------------------------------------------------------

# The top routing layer is 7 usually.. but it will depend on the design
# FIXME: This clearly belongs in stdcells.tcl

set vars(max_route_layer)                   7

#-------------------------------------------------------------------------
# User Plugins
#-------------------------------------------------------------------------

set vars(always_source_tcl)           $vars(plug_dir)/always_source.tcl
set vars(pre_init_tcl)                $vars(plug_dir)/pre_init.tcl
set vars(post_init_tcl)               $vars(plug_dir)/post_init.tcl
set vars(pre_place_tcl)               $vars(plug_dir)/pre_place.tcl
set vars(post_place_tcl)              $vars(plug_dir)/post_place.tcl
#set vars(pre_prects_tcl)              $vars(plug_dir)/pre_prects.tcl
#set vars(post_prects_tcl)             $vars(plug_dir)/post_prects.tcl
#set vars(pre_cts_tcl)                 $vars(plug_dir)/pre_cts.tcl
#set vars(post_cts_tcl)                $vars(plug_dir)/post_cts.tcl
#set vars(pre_postcts_tcl)             $vars(plug_dir)/pre_postcts.tcl
#set vars(post_postcts_tcl)            $vars(plug_dir)/post_postcts.tcl
#set vars(pre_postcts_hold_tcl)        $vars(plug_dir)/pre_postcts_hold.tcl
#set vars(post_postcts_hold_tcl)       $vars(plug_dir)/post_postcts_hold.tcl
#set vars(pre_route_tcl)               $vars(plug_dir)/pre_route.tcl
#set vars(post_route_tcl)              $vars(plug_dir)/post_route.tcl
#set vars(pre_postroute_tcl)           $vars(plug_dir)/pre_postroute.tcl
#set vars(post_postroute_tcl)          $vars(plug_dir)/post_postroute.tcl
#set vars(pre_postroute_hold_tcl)      $vars(plug_dir)/pre_postroute_hold.tcl
#set vars(post_postroute_hold_tcl)     $vars(plug_dir)/post_postroute_hold.tcl
#set vars(pre_postroute_si_hold_tcl)   $vars(plug_dir)/pre_postroute_si_hold.tcl
#set vars(post_postroute_si_hold_tcl)  $vars(plug_dir)/post_postroute_si_hold.tcl
#set vars(pre_postroute_si_tcl)        $vars(plug_dir)/pre_postroute_si.tcl
#set vars(post_postroute_si_tcl)       $vars(plug_dir)/post_postroute_si.tcl
#set vars(pre_signoff_tcl)             $vars(plug_dir)/pre_signoff.tcl
set vars(post_signoff_tcl)            $vars(plug_dir)/post_signoff.tcl

# Special options for saving and restoring design

set vars(init,save_design,replace_tcl)            $vars(plug_dir)/save_design.tcl
set vars(place,save_design,replace_tcl)           $vars(plug_dir)/save_design.tcl
set vars(cts,save_design,replace_tcl)             $vars(plug_dir)/save_design.tcl
set vars(postcts_hold,save_design,replace_tcl)    $vars(plug_dir)/save_design.tcl
set vars(route,save_design,replace_tcl)           $vars(plug_dir)/save_design.tcl
set vars(postroute,save_design,replace_tcl)       $vars(plug_dir)/save_design.tcl
set vars(signoff,save_design,replace_tcl)         $vars(plug_dir)/save_design.tcl

#set vars(init,restore_design,replace_tcl)         $vars(plug_dir)/restore_design.tcl
#set vars(place,restore_design,replace_tcl)        $vars(plug_dir)/restore_design.tcl
#set vars(cts,restore_design,replace_tcl)          $vars(plug_dir)/restore_design.tcl
#set vars(postcts_hold,restore_design,replace_tcl) $vars(plug_dir)/restore_design.tcl
#set vars(route,restore_design,replace_tcl)        $vars(plug_dir)/restore_design.tcl
#set vars(postroute,restore_design,replace_tcl)    $vars(plug_dir)/restore_design.tcl
#set vars(signoff,restore_design,replace_tcl)      $vars(plug_dir)/restore_design.tcl

## Skipping (see "Tags for Innovus Flow")
#
##  set vars(step,command,skip) true
##  set vars(postroute,opt_design,skip) true
#
##set vars(place,time_design_hold,skip) false
##set vars(cts,time_design_setup,skip) false
#
#-------------------------------------------------------------------------
# Misc
#-------------------------------------------------------------------------

# Abort setting for generating the Innovus foundation flow scripts
#
# - Enable to abort when there are setup errors
# - Leave 0 to continue on setup error

set vars(abort) 0

# Power nets

set vars(power_nets)  "VDD VNW VDDPST POC"
set vars(ground_nets) "VSS VPW VSSPST"

# Tie cells
#
# - The maximum distance allowed (in microns) can be tweaked if needed
# - The maximum fanout can be tweaked if needed

set vars(tie_cells) $STDCELLS_TIE_CELLS

set vars(tie_cells,max_distance) 20
set vars(tie_cells,max_fanout)   8

# Filler cells

set vars(filler_cells) $STDCELLS_FILLER_CELLS

# Welltaps
# FIXME: need to check the DRC requirements for well tap max spacing

set vars(welltaps)               $STDCELLS_WELL_TAP_CELL
set vars(welltaps,checkerboard)  true
set vars(welltaps,verify_rule)   30
set vars(welltaps,cell_interval) 60
#set vars(welltaps,max_gap) 60

# Endcaps

set vars(pre_endcap)             $STDCELLS_END_CAP_CELL
set vars(post_endcap)            $STDCELLS_END_CAP_CELL

# Antenna

set vars(antenna_diode)          $STDCELLS_ANTENNA_CELL

# List of buffers to use during useful skew

#set vars(useful_skew)  true
#set vars(skew_buffers) ""

# Verbosity

#set vars(verbose) false

# Multithreading and distributed processing
# FIXME

set vars(local_cpus) 8

# Flow control
# - Controls when hold optimization is enabled
# - (false | postcts | postroute | postroute_si)

set vars(fix_hold)                       postcts
set vars(fix_hold_allow_tns_degradation) true

set vars(postroute_spread_wires)  true

# Extraction efforts

set vars(congestion_effort)            medium
set vars(postroute_extraction_effort)  low
set vars(signoff_extraction_effort)    low
#set vars(flow_effort)                  medium
set vars(power_effort)                 high

set vars(multi_cut_effort)             medium

set vars(leakage_power_effort)         none
set vars(dynamic_power_effort)         none

# CTS variables

set vars(ccopt_effort)                 medium

# Metal fill is performed using the Calibre fill utility
# Disabling metal density check at signoff

set vars(signoff,verify_metal_density,skip) true

#-------------------------------------------------------------------------
# Custom tcl
#-------------------------------------------------------------------------

# Custom GDS stream out tcl

set vars(gds_layer_map)                  $adk_dir/rtk-stream-out.map
set vars(signoff,stream_out,replace_tcl) $vars(plug_dir)/stream_out.tcl

# Custom check design tcl
#
# - Select text-only (non-HTML) report and change the output directory

set vars(init,check_design,replace_tcl)  $vars(plug_dir)/check_design.tcl

# Custom summary report tcl
#
# - Select text-only (non-HTML) report and change the output directory

set vars(signoff,summary_report,replace_tcl)  $vars(plug_dir)/summary_report.tcl

#-------------------------------------------------------------------------
# Design-specific overrides
#-------------------------------------------------------------------------
# Here we source the design-specific setup.tcl in the plugin directory,
# which can overwrite any variable in this file.

#if {[file exists $vars(plug_dir)/setup.tcl]} {
#  source $vars(plug_dir)/setup.tcl
#}

#-------------------------------------------------------------------------
# Unsure
#-------------------------------------------------------------------------

##set vars(cell_check_early) 1.0
##set vars(cell_check_late)  1.0
##set vars(critical_range)   ??
#
## There is a hier_flow_type: Enables the new two-pass hierarchical flow. The
## valid types are 1pass (default) and 2pass.
#
#set vars(report_power)                          true
#
## Reduced effort flow. Sacrifices timing
##if {[info exists vars(reduced_effort_flow)] && $vars(reduced_effort_flow)} {
##  set vars(flow_effort) express
##  #Place
##  set vars(congestion_effort) low
##  #CTS
##  set vars(ccopt_effort) low
##  #Route
##  set vars(postroute_extraction_effort) medium
##  #PostRoute: Skipping PostRoute setup and hold fixing
##  set vars(postroute,opt_design,skip) true
#
##  set vars(skip_verify) true
##}
#
## Skipping some verify steps at signoff that take too long
##if {[info exists vars(skip_verify)] && $vars(skip_verify)} {
##  # set vars(signoff,extract_rc,skip) true
##  # set vars(signoff,dump_spef,skip) true
##  # set vars(signoff,time_design_setup,skip) true
##  # set vars(signoff,time_design_hold,skip) true
##  set vars(signoff,verify_connectivity,skip) true
##  set vars(signoff,verify_geometry,skip) true
##  set vars(signoff,verify_process_antenna,skip) true
##}

