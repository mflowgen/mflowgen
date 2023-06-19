#=========================================================================
# setup.tcl
#=========================================================================
# Innovus foundation flow setup.
#
# Note that according to the Innovus foundation flow user guide, setup.tcl
# is intended to be used to define common process, technology, and library
# information. Then innovus_config.tcl is then used to define
# "block-specific" information like power and ground nets, tie and filler
# cells, welltaps and endcaps, enabling clock gating, etc.
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
# Parameters
#-------------------------------------------------------------------------

set vars(design)              $::env(design_name)

#-------------------------------------------------------------------------
# Inputs
#-------------------------------------------------------------------------

set vars(adk_dir)             inputs/adk
set vars(netlist)             inputs/design.v
set synthesis_sdc             inputs/design.sdc

#-------------------------------------------------------------------------
# Directories
#-------------------------------------------------------------------------

set vars(script_root)         SCRIPTS
set vars(design_root)         ./

set vars(step_scripts_dir)    scripts
set vars(custom_scripts_dir)  innovus-foundation-flow/custom-scripts
set vars(log_dir)             logs
set vars(rpt_dir)             reports
set vars(results_dir)         results
set vars(dbs_dir)             checkpoints

#-------------------------------------------------------------------------
# Libraries
#-------------------------------------------------------------------------
# Difference between library_sets, rc_corners, and delay_corners
#
# - A delay_corner is made by choosing an rc_corner and a library_set
# - The rc_corner is the captable/qrcTechFile, which is the wire RC
# - The library_set is the stdcell libs, etc.
#
# - Then an analysis view is made of a delay corner and a constraints mode
# - The analysis view can focus on setup or hold, depending on which
#   corner and which constraints mode is picked

# Source the setup file for the ADK

source $vars(adk_dir)/adk.tcl

# Library sets

set vars(library_sets)        "libs_typical"

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
    foreach L $vars(libs_typical,timing) { puts "L_TT    $L" }
} else {
    puts "WARNING: No typical-typical library is found in ADK nor inputs"
}

# The best case is:
#
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
    lappend vars(library_sets)  "libs_bc"
    puts "INFO: Found fast-fast libraries:"
    foreach L $vars(libs_bc,timing) { puts "L_FF    $L" }
} else {
    puts "WARNING: No fast-fast library is found in ADK nor inputs"
}

# The worst case is:
#
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
    lappend vars(library_sets)  "libs_wc"
    puts "INFO: Found slow-slow libraries:"
    foreach L $vars(libs_wc,timing) { puts "L_SS    $L" }
} else {
    puts "WARNING: No slow-slow library is found in ADK nor inputs"
}

set vars(lef_files) [join "
                      $vars(adk_dir)/rtk-tech.lef
                      [lsort [glob -nocomplain $vars(adk_dir)/stdcells.lef]]
                      [lsort [glob -nocomplain $vars(adk_dir)/stdcells-pm.lef]]
                      [lsort [glob -nocomplain $vars(adk_dir)/*.lef]]
                      [lsort [glob -nocomplain inputs/*.lef]]
                    "]

#-------------------------------------------------------------------------
# RC Corners
#-------------------------------------------------------------------------

set vars(rc_corners) ""

if {[file exists $vars(adk_dir)/rtk-typical.captable]} {
  lappend vars(rc_corners)        "typical"
  set vars(typical,cap_table)     $vars(adk_dir)/rtk-typical.captable
  set vars(typical,T)             25
}

# RC best corner

if {[file exists $vars(adk_dir)/rtk-rcbest.captable]} {
  set vars(rcbest,cap_table)      $vars(adk_dir)/rtk-rcbest.captable
  #set vars(rcbest,T)              25
  lappend vars(rc_corners)        "rcbest"
}

# RC worst corner

if {[file exists $vars(adk_dir)/rtk-rcworst.captable]} {
  set vars(rcworst,cap_table)     $vars(adk_dir)/rtk-rcworst.captable
  #set vars(rcworst,T)             25
  lappend vars(rc_corners)        "rcworst"
}

# Source QRC tech files if they exist

set captable_only_mode false

if {[file exists $vars(adk_dir)/pdk-typical-qrcTechFile]} {
  set vars(typical,qx_tech_file)    $vars(adk_dir)/pdk-typical-qrcTechFile
  set vars(typical,T)               25
  if {[lsearch -exact $vars(rc_corners) "typical"] == -1} {
    lappend vars(rc_corners)        "typical"
  }
} else {
  set captable_only_mode true
}

if {[file exists $vars(adk_dir)/pdk-rcbest-qrcTechFile]} {
  set vars(rcbest,qx_tech_file)     $vars(adk_dir)/pdk-rcbest-qrcTechFile
  #set vars(rcbest,T)                25
  if {[lsearch -exact $vars(rc_corners) "rcbest"] == -1} {
    lappend vars(rc_corners)        "rcbest"
  }
}

if {[file exists $vars(adk_dir)/pdk-rcworst-qrcTechFile]} {
  set vars(rcworst,qx_tech_file)    $vars(adk_dir)/pdk-rcworst-qrcTechFile
  #set vars(rcworst,T)               25
  if {[lsearch -exact $vars(rc_corners) "rcworst"] == -1} {
    lappend vars(rc_corners)        "rcworst"
  }
}

#-------------------------------------------------------------------------
# Delay Corners (OCV style)
#-------------------------------------------------------------------------

set vars(delay_corners)                      "delay_default"

set vars(delay_default,early_library_set)    libs_typical
set vars(delay_default,late_library_set)     libs_typical
set vars(delay_default,rc_corner)            typical

if {[lsearch -exact $vars(rc_corners) "rcbest"] != -1} {
  lappend vars(delay_corners) "delay_best"
  set vars(delay_best,early_library_set)    libs_typical
  set vars(delay_best,late_library_set)     libs_typical
  set vars(delay_best,rc_corner)            rcbest
}

# Use the best case for hold instead if the files are available

if {[file exists $vars(adk_dir)/stdcells-bc.lib]} {
  set vars(delay_default,early_library_set)    libs_bc
  if {[lsearch -exact $vars(delay_corners) "delay_best"] != -1} {
    set vars(delay_best,early_library_set)    libs_bc
  }
}



#-------------------------------------------------------------------------
# Delay Corners (old bc_wc style)
#-------------------------------------------------------------------------
# set vars(delay_corners)                     "delay_typical delay_bc_typical delay_bc_rcbest delay_wc_rcworst"
#
# set vars(delay_typical,library_set)         libs_typical
# set vars(delay_typical,rc_corner)           typical
#
# set vars(delay_bc_typical,library_set)      libs_bc
# set vars(delay_bc_typical,rc_corner)        typical
#
# set vars(delay_bc_rcbest,library_set)       libs_bc
# set vars(delay_bc_rcbest,rc_corner)         rcbest
#
# set vars(delay_wc_rcworst,library_set)      libs_wc
# set vars(delay_wc_rcworst,rc_corner)        rcworst
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
# Constraint Modes
#-------------------------------------------------------------------------

set vars(constraint_modes)                  constraints_default

set vars(constraints_default,pre_cts_sdc)   $synthesis_sdc
set vars(constraints_default,post_cts_sdc)  $synthesis_sdc

#-------------------------------------------------------------------------
# Analysis Views (OCV style)
#-------------------------------------------------------------------------

set vars(analysis_views)                       "analysis_default"

set vars(analysis_default,delay_corner)        delay_default
set vars(analysis_default,constraint_mode)     constraints_default

if {[lsearch -exact $vars(delay_corners) "delay_best"] != -1} {
  lappend vars(analysis_views)                   "analysis_hold"
  set vars(analysis_hold,delay_corner)           delay_best
  set vars(analysis_hold,constraint_mode)        constraints_default
}

# Analysis views for setup and hold
#
# Notes:
#
# - P: We don't have much control over whether we get tt/ff/ss/fs/sf
# - V: We expect to carefully control voltage in the lab testing setup
# - T: Our research chips do not actually have to function at -40C and 125C
#
# - For our research chips, we don't worry too much about meeting any
#   particular clock target
#
# With this in mind:
#
# - Setup: typical process is enough, and typical voltage/temp is
#   expected, so we do _not_ turn on corners for setup views
#
# - Hold: typical + ff process, and then typical voltage/temp is expected,
#   so we enable typical corner, and we enable best case process + typical
#   voltage/temp corner (analysis_bc_typical).
#
# This basically means that our chip will not work perfectly for extreme
# environments, but we will only run in a normal environment anyway, and
# we will report our numbers for that case.

set vars(default_setup_view)                   "analysis_default"
set vars(setup_analysis_views)                 "analysis_default"
set vars(active_setup_views)                   "analysis_default"

set vars(default_hold_view)                    "analysis_default"
set vars(hold_analysis_views)                  "analysis_default"
set vars(active_hold_views)                    "analysis_default"

if {[lsearch -exact $vars(analysis_views) "analysis_hold"] != -1} {
  set vars(default_hold_view)                    "analysis_hold"
  set vars(hold_analysis_views)                  "analysis_hold"
  set vars(active_hold_views)                    "analysis_hold"
}

# Misc

set vars(power_analysis_view)                  analysis_default

#-------------------------------------------------------------------------
# Analysis Views (old bc_wc style)
#-------------------------------------------------------------------------
# set vars(analysis_views)                       "analysis_default analysis_bc_typical analysis_bc_rcbest analysis_wc_rcworst"
#
# set vars(analysis_default,delay_corner)        delay_typical
# set vars(analysis_default,constraint_mode)     constraints_default
#
# set vars(analysis_bc_typical,delay_corner)     delay_bc_typical
# set vars(analysis_bc_typical,constraint_mode)  constraints_default
#
# set vars(analysis_bc_rcbest,delay_corner)      delay_bc_rcbest
# set vars(analysis_bc_rcbest,constraint_mode)   constraints_default
#
# set vars(analysis_wc_rcworst,delay_corner)     delay_wc_rcworst
# set vars(analysis_wc_rcworst,constraint_mode)  constraints_default
#
# # Analysis views for setup and hold
#
# set vars(default_setup_view)                   "analysis_default"
# set vars(setup_analysis_views)                 "analysis_default"
# set vars(active_setup_views)                   "analysis_default"
#
# set vars(default_hold_view)                    "analysis_default"
# set vars(hold_analysis_views)                  "analysis_default analysis_bc_typical"
# set vars(active_hold_views)                    "analysis_default analysis_bc_typical"
#
# # Misc
#
# set vars(power_analysis_view)                  analysis_default
#
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
# Power-related
#-------------------------------------------------------------------------

#set vars(cpf_file)                                 $vars(plug_dir)/power_intent.cpf
#set vars(cpf_keep_rows)                            TRUE
#set vars(cpf_power_domain)                         FALSE
#set vars(cpf_power_switch)                         FALSE
#set vars(cpf_isolation)                            FALSE
#set vars(cpf_state_retention)                      FALSE
#set vars(cpf_level_shifter)                        FALSE

#-------------------------------------------------------------------------
# Process information
#-------------------------------------------------------------------------

set vars(process)                           $ADK_PROCESS
set vars(max_route_layer)                   $ADK_MAX_ROUTING_LAYER_INNOVUS

#-------------------------------------------------------------------------
# User Plugins
#-------------------------------------------------------------------------

set vars(always_source_tcl)           $vars(custom_scripts_dir)/always-source.tcl

#set vars(pre_init_tcl)                $vars(step_scripts_dir)/pre-init.tcl
#set vars(post_init_tcl)               $vars(step_scripts_dir)/post-init.tcl
#set vars(pre_place_tcl)               $vars(step_scripts_dir)/pre-place.tcl
#set vars(post_place_tcl)              $vars(step_scripts_dir)/post-place.tcl
##set vars(pre_prects_tcl)              $vars(step_scripts_dir)/pre-prects.tcl
##set vars(post_prects_tcl)             $vars(step_scripts_dir)/post-prects.tcl
#set vars(pre_cts_tcl)                 $vars(step_scripts_dir)/pre-cts.tcl
#set vars(post_cts_tcl)                $vars(step_scripts_dir)/post-cts.tcl
##set vars(pre_postcts_tcl)             $vars(step_scripts_dir)/pre-postcts.tcl
##set vars(post_postcts_tcl)            $vars(step_scripts_dir)/post-postcts.tcl
#set vars(pre_postcts_hold_tcl)        $vars(step_scripts_dir)/pre-postctshold.tcl
#set vars(post_postcts_hold_tcl)       $vars(step_scripts_dir)/post-postctshold.tcl
#set vars(pre_route_tcl)               $vars(step_scripts_dir)/pre-route.tcl
#set vars(post_route_tcl)              $vars(step_scripts_dir)/post-route.tcl
#set vars(pre_postroute_tcl)           $vars(step_scripts_dir)/pre-postroute.tcl
#set vars(post_postroute_tcl)          $vars(step_scripts_dir)/post-postroute.tcl
##set vars(pre_postroute_hold_tcl)      $vars(step_scripts_dir)/pre-postroute_hold.tcl
##set vars(post_postroute_hold_tcl)     $vars(step_scripts_dir)/post-postroute_hold.tcl
##set vars(pre_postroute_si_hold_tcl)   $vars(step_scripts_dir)/pre-postroute_si_hold.tcl
##set vars(post_postroute_si_hold_tcl)  $vars(step_scripts_dir)/post-postroute_si_hold.tcl
##set vars(pre_postroute_si_tcl)        $vars(step_scripts_dir)/pre-postroute_si.tcl
##set vars(post_postroute_si_tcl)       $vars(step_scripts_dir)/post-postroute_si.tcl
#set vars(pre_signoff_tcl)             $vars(step_scripts_dir)/pre-signoff.tcl
#set vars(post_signoff_tcl)            $vars(step_scripts_dir)/post-signoff.tcl

# Skip saving and restoring design, since we plan to manage this ourselves

set vars(init,save_design,replace_tcl)          $vars(custom_scripts_dir)/embed-return.tcl
set vars(place,save_design,replace_tcl)         $vars(custom_scripts_dir)/embed-return.tcl
set vars(cts,save_design,replace_tcl)           $vars(custom_scripts_dir)/embed-return.tcl
set vars(postcts_hold,save_design,replace_tcl)  $vars(custom_scripts_dir)/embed-return.tcl
set vars(route,save_design,replace_tcl)         $vars(custom_scripts_dir)/embed-return.tcl
set vars(postroute,save_design,replace_tcl)     $vars(custom_scripts_dir)/embed-return.tcl
set vars(signoff,save_design,replace_tcl)       $vars(custom_scripts_dir)/embed-return.tcl

set vars(place,restore_design,skip)             true
set vars(cts,restore_design,skip)               true
set vars(postcts_hold,restore_design,skip)      true
set vars(route,restore_design,skip)             true
set vars(postroute,restore_design,skip)         true
set vars(signoff,restore_design,skip)           true

# Replace "routeDesign" command with contents of "route-design-check.tcl"

set vars(route,route_design,replace_tcl)      $vars(custom_scripts_dir)/route-design-check.tcl

# Custom GDS stream out tcl

set vars(gds_layer_map)                       $vars(adk_dir)/rtk-stream-out.map
set vars(signoff,stream_out,replace_tcl)      $vars(custom_scripts_dir)/stream-out.tcl

# Custom summary report tcl
#
# - Select text-only (non-HTML) report and change the output directory

set vars(signoff,summary_report,replace_tcl)  $vars(custom_scripts_dir)/summary-report.tcl

# CCOPT mode options are all during cts

set vars(cts,set_ccopt_mode,skip) true

#-------------------------------------------------------------------------
# Misc
#-------------------------------------------------------------------------

# Abort setting for generating the Innovus foundation flow scripts
#
# - Enable to abort when there are setup errors
# - Leave 0 to continue on setup error

set vars(abort) 0

# Power nets
#
# - VDD VNW     : from stdcells
# - VSS VPW     : from stdcells
# - VDDPST POC  : from iocells
# - VSSPST      : from iocells
# - VDDCE VDDPE : from srams
# - VSSE        : from srams

set vars(power_nets)  "VDD VNW VDDPST POC VDDCE VDDPE"
set vars(ground_nets) "VSS VPW VSSPST VSSE"

# Tie cells
#
# - The maximum distance allowed (in microns) can be tweaked if needed
# - The maximum fanout can be tweaked if needed

set vars(tie_cells)              $ADK_TIE_CELLS

set vars(tie_cells,max_distance) 20
set vars(tie_cells,max_fanout)   8

# Filler cells

set vars(filler_cells)           $ADK_FILLER_CELLS

# Welltaps and End Caps
#
# - Commented this section out
#
# Well taps are now explicitly handled by the user in the init step, since
# the foundation flow does not nicely support the many special ways each
# technology requires these cells to be placed (e.g., different cells
# along top, bottom, edges).

# if { $ADK_WELL_TAP_CELL != "" } {
#   set vars(welltaps)               $ADK_WELL_TAP_CELL
#   set vars(welltaps,checkerboard)  true
#   set vars(welltaps,verify_rule)   60
#   set vars(welltaps,cell_interval) 120
# }
#
# if { $ADK_END_CAP_CELL != "" } {
#   set vars(pre_endcap)             $ADK_END_CAP_CELL
#   set vars(post_endcap)            $ADK_END_CAP_CELL
# }

# Antenna

set vars(antenna_diode)          $ADK_ANTENNA_CELL

# Clock-gate aware

set vars(clock_gate_aware) true

# DFM

set vars(postroute_spread_wires)       true
set vars(litho_driven_routing)         true

# OCV (on-chip variation)

set vars(enable_ocv)    pre_place
set vars(enable_cppr)   both

# Metal fill is performed using the Calibre fill utility
# Disabling metal density check at signoff

set vars(signoff,verify_metal_density,skip) true

# Multithreading (and maybe distributed processing)

set vars(local_cpus) $::env(nthreads)

# Hold fixing
#
# - Controls when hold optimization is enabled
# - (false | postcts | postroute | postroute_si)
#
# - Allow TNS degradation to try to prevent postroute from fixing hold,
#   and then fixing setup again, creating additional (unfixed) hold
#   violations

set vars(fix_hold)                       postcts
set vars(fix_hold_allow_tns_degradation) true
set vars(fix_fanout_load)                true

# Variables for skipping time_design

set vars(place,time_design,skip)       true
set vars(cts,time_design,skip)         true
set vars(route,time_design,skip)       true

# More time_design options

set vars(time_design_options,setup)    -expandedViews
set vars(time_design_options,hold)     -expandedViews

# Flow efforts

set vars(flow_effort)                  standard
set vars(congestion_effort)            medium
set vars(power_effort)                 high
set vars(multi_cut_effort)             high

# Extraction efforts

set vars(postroute_extraction_effort)  high
set vars(signoff_extraction_effort)    high

# Cap tables can only be used with low-effort extraction

if {$captable_only_mode} {
  set vars(postroute_extraction_effort)  low
  set vars(signoff_extraction_effort)    low
}

# Verbosity

set vars(tags,verbose)                 true
set vars(tags,verbosity_level)         high

# Skip verifyConnectivity to avoid out-of-memory crash on some large designs

if { $::env(skip_verify_connectivity) } {
  set vars(signoff,verify_connectivity,skip) true
}

#-------------------------------------------------------------------------
# Reduced-effort flow that sacrifices timing to iterate more quickly
#-------------------------------------------------------------------------

if { $::env(express_flow) } {
  set vars(flow_effort)                 express
  set vars(congestion_effort)           low
  set vars(power_effort)                low
  set vars(multi_cut_effort)            low
  set vars(postroute_extraction_effort) medium

  # Skipping (see "Tags for Innovus Flow")
  #
  # set vars(step,command,skip) true

  # Route: Skip routing because express flow does not require route

  set vars(route,route_design,skip) true
  set vars(route,spread_wires,skip) true

  # PostRoute: Skip postroute setup and hold fixing

  set vars(postroute,opt_design,skip) true

  # Signoff: Skip verification steps

  set vars(signoff,verify_connectivity,skip) true
  set vars(signoff,verify_geometry,skip) true
  set vars(signoff,verify_process_antenna,skip) true

#  set vars(signoff,extract_rc,skip) true
#  set vars(signoff,dump_spef,skip) true
#  set vars(signoff,time_design_setup,skip) true
#  set vars(signoff,time_design_hold,skip) true
}

# Allows user to override any of the defaults in this file
if [file exists inputs/setup.tcl] {
  source inputs/setup.tcl
}
