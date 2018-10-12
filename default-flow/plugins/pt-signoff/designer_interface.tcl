#=========================================================================
# designer_interface.tcl
#=========================================================================
# The designer_interface.tcl file is the first script run by the tool (see
# the top of pt.tcl). It is the interface that connects the tool scripts
# with the following:
#
# - Build system variables
# - Plugin scripts
# - ASIC design kit
#
# Notes:
#
# - The CAPITALIZED_VARIABLES are usually Synopsys Design Compiler's
#   reference methodology variables.
#
# Author : Christopher Torng
# Date   : May 16, 2018

#-------------------------------------------------------------------------
# Interface to the build system
#-------------------------------------------------------------------------

set DESIGN_NAME                 $::env(design_name)

set pt_flow_dir                 $::env(pt_flow_dir)
set pt_plugins_dir              $::env(pt_plugins_dir)
set pt_logs_dir                 $::env(pt_logs_dir)
set REPORTS                     $::env(pt_reports_dir)
set RESULTS                     $::env(pt_results_dir)

set pt_clock_period             $::env(pt_clock_period)

set NETLIST_FILES               $::env(pt_netlist_handoff)
set PARASITIC_FILES             $::env(pt_typical_spef)
set CONSTRAINT_FILES            $::env(pt_sdc_input)

#-------------------------------------------------------------------------
# Interface to plugins
#-------------------------------------------------------------------------

#set pre_pt_plugin        ${pt_plugins_dir}/pre_pt.tcl
#set post_pt_plugin       ${pt_plugins_dir}/post_pt.tcl

#-------------------------------------------------------------------------
# Interface to the ASIC design kit
#-------------------------------------------------------------------------

set LIBRARY_SET(typical)    [join "
                              stdcells.db
                              iocells.db
                              [glob -nocomplain $::env(pt_collect_dir)/*tt*.db]
                            "]

set LIBRARY_SET(ff_typical) [join "
                              stdcells-bc.db
                              iocells-bc.db
                              [glob -nocomplain $::env(pt_collect_dir)/*ff*.db]
                            "]

set corner_case "[string tolower [getenv CORNER_CASE]]"

if { ${corner_case} == "typical" } {
  set TARGET_LIBRARY_FILES      $LIBRARY_SET(typical)
} elseif { ${corner_case} == "ff_typical" } {
  set TARGET_LIBRARY_FILES      $LIBRARY_SET(ff_typical)
}

set ADDITIONAL_SEARCH_PATH      $::env(adk_dir)
set MW_REFERENCE_LIB_DIRS       $::env(adk_dir)/stdcells.mwlib
set TECH_FILE                   $::env(adk_dir)/rtk-tech.tf
set MAP_FILE                    $::env(adk_dir)/rtk-tluplus.map
set TLUPLUS_MAX_FILE            $::env(adk_dir)/rtk-max.tluplus
set TLUPLUS_MIN_FILE            $::env(adk_dir)/rtk-min.tluplus

set stdcells_tcl                $::env(adk_dir)/stdcells.tcl

# alib_dir
#
# Design Compiler caches analyzed libraries to improve performance using
# ".alib" directories. The alib takes a while to generate but is reused on
# subsequent runs. It is useful to store a centralized copy of the alib to
# avoid re-generating the alib (usually only several minutes but can be
# annoying) on every new clone of the ASIC repo.
#
# However, if DC sees a .db that does not have an associated .alib it will
# try to automatically create one. This is not usually a problem when
# students just use standard cells, but if a student is trying to use
# SRAMs, then they will be using new .db files that DC has not seen yet.
# The problem is that students do not have write permissions to the
# centralized copy of the alib.
#
# The alibs are stored in a directory that holds a ".db.alib" file for
# each db file:
#
# - alib
#   - alib-52
#     - iocells.db.alib
#     - stdcells.db.alib
#
# The current solution is to make a new alib directory in the build
# directory that "shadows" the directory hierarchy of the ADK's alib, and
# that contains symbolic links to each saved alib in the ADK. This can be
# done simply by using "cp -sr" of the ADK alib to the build directory,
# which generates symbolic links to each file instead of copying. This
# way, the student can access the master copy of the saved alibs in the
# ADK, and if there are any additional db's specified, their alibs will
# be saved in the local build directory.

set alib_dir ./alib

# Voltage: This should go into adk.tcl

set PNS_VOLTAGE_SUPPLY      0.9

