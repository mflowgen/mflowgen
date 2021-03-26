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
# Author : Kartik Prabhu
# Date   : September 21, 2020


#-------------------------------------------------------------------------
# Parameters
#-------------------------------------------------------------------------

set pt_design_name              $::env(design_name)
set pt_setup_margin             $::env(setup_margin)
set pt_hold_margin              $::env(hold_margin)

#-------------------------------------------------------------------------
# Libraries
#-------------------------------------------------------------------------

set adk_dir                       inputs/adk

set pt_additional_search_path   $adk_dir
set pt_target_libraries         stdcells.db

set pt_extra_link_libraries     [join "
                                      [lsort [glob -nocomplain inputs/*.db]]
                                      [lsort [glob -nocomplain inputs/adk/*.db]]
                                  "]

set pt_adk_tcl                  $adk_dir/adk.tcl

# for leakage recovery, order cells based on substring priority, 
# with lowest leakage first
# the substring can be anywhere, like (HVT_BUF1X, BUF_HVT1X, BUF1X_HVT)
set pt_eco_leakage_pattern		"HVT SVT LVT ULVT"


#-------------------------------------------------------------------------
# Inputs
#-------------------------------------------------------------------------

set pt_gl_netlist               [lsort [glob -nocomplain inputs/*.vcs.v]]
set pt_sdc                      [lsort [glob -nocomplain inputs/*.pt.sdc]]
set pt_spef                     [lsort [glob -nocomplain inputs/*.spef.gz]]
