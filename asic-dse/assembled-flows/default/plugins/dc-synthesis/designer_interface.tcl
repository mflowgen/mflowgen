#=========================================================================
# designer_interface.tcl
#=========================================================================
# The designer_interface.tcl file is the first script run by Design
# Compiler (see the top of dc.tcl). It is the interface that connects the
# dc-synthesis scripts with the following:
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
# Date   : April 8, 2018

#-------------------------------------------------------------------------
# Interface to the build system
#-------------------------------------------------------------------------

set DESIGN_NAME                 $::env(design_name)

set dc_flow_dir                 $::env(dc_flow_dir)
set dc_plugins_dir              $::env(dc_plugins_dir)
set dc_logs_dir                 $::env(dc_logs_dir)
set REPORTS                     $::env(dc_reports_dir)
set RESULTS                     $::env(dc_results_dir)

set RTL_SOURCE_FILES            $::env(dc_rtl_handoff)
set dc_clock_period             $::env(dc_clock_period)

#-------------------------------------------------------------------------
# Interface to plugins
#-------------------------------------------------------------------------

set DCRM_CONSTRAINTS_INPUT_FILE ${dc_plugins_dir}/constraints.tcl

set pre_synthesis_plugin        ${dc_plugins_dir}/pre_synth.tcl
set post_synthesis_plugin       ${dc_plugins_dir}/post_synth.tcl

set read_design_plugin          ${dc_plugins_dir}/read_design.tcl

#-------------------------------------------------------------------------
# Interface to the ASIC design kit
#-------------------------------------------------------------------------

set TARGET_LIBRARY_FILES        [join "
                                  stdcells.db
                                  [glob -nocomplain $::env(dc_collect_dir)/*.db]
                                "]

set ADDITIONAL_SEARCH_PATH      $::env(adk_dir)
set ADDITIONAL_LINK_LIB_FILES   ""
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

#-------------------------------------------------------------------------
# Misc
#-------------------------------------------------------------------------

# Number of cores for multicore optimization (used in dc_setup.tcl)

set dc_num_cores 16

