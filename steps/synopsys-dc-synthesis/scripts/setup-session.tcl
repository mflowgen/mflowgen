#=========================================================================
# setup-session.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : September 30, 2018

# Set up variables for this specific ASIC design kit

source -echo -verbose $dc_adk_tcl

#-------------------------------------------------------------------------
# System
#-------------------------------------------------------------------------

# Multicore support -- watch how many licenses we have!

set_host_options -max_cores $dc_num_cores

# Set up alib caching for faster consecutive runs

set_app_var alib_library_analysis_path $dc_alib_dir

#-------------------------------------------------------------------------
# Message suppression
#-------------------------------------------------------------------------


if { $dc_suppress_msg } {

  foreach m $dc_suppressed_msg {
    suppress_message $m
  }

}

#-------------------------------------------------------------------------
# Libraries
#-------------------------------------------------------------------------

# Set up search path for libraries and design files

set_app_var search_path ". $dc_additional_search_path $search_path"

# Important app vars
#
# - target_library    -- DC maps the design to gates in this library (db)
# - synthetic_library -- DesignWare library (sldb)
# - link_library      -- Libraries for any other design references (e.g.,
#                        SRAMs, hierarchical blocks, macros, IO libs) (db)

set_app_var target_library     $dc_target_libraries
set_app_var synthetic_library  dw_foundation.sldb
set_app_var link_library       [join "
                                 *
                                 $target_library
                                 $dc_extra_link_libraries
                                 $synthetic_library
                               "]


# Create Milkyway library
#
# By default, Milkyway libraries only have 180 or so layers available to
# use (255 total, but some are reserved). The extend_mw_layers command
# expands the Milkyway library to accommodate up to 4095 layers.

# Only create new Milkyway design library if it doesn't already exist

set milkyway_library ${dc_design_name}_lib

if {![file isdirectory $milkyway_library ]} {

  # Create a new Milkyway library

  extend_mw_layers
  create_mw_lib -technology           $dc_milkyway_tf            \
                -mw_reference_library $dc_milkyway_ref_libraries \
                $milkyway_library

} else {

  # Reuse existing Milkyway library, but ensure that it is consistent with
  # the provided reference Milkyway libraries.

  set_mw_lib_reference $milkyway_library \
    -mw_reference_library $dc_milkyway_ref_libraries

}

open_mw_lib $milkyway_library

# Set up TLU plus (if the files exist)

if { $dc_topographical == True } {
  if {[file exists [which $dc_tluplus_max]]} {
    set_tlu_plus_files -max_tluplus  $dc_tluplus_max \
                       -min_tluplus  $dc_tluplus_min \
                       -tech2itf_map $dc_tluplus_map

    check_tlu_plus_files
  }
}

#-------------------------------------------------------------------------
# Misc
#-------------------------------------------------------------------------

# Set up tracking for Synopsys Formality

set_svf ${dc_results_dir}/${dc_design_name}.mapped.svf

# SAIF mapping

saif_map -start

# Avoiding X-propagation for synchronous reset DFFs
#
# There are two key variables that help avoid X-propagation for
# synchronous reset DFFs:
#
# - set hdlin_ff_always_sync_set_reset true
#
#     - Tells DC to use every constant 0 loaded into a DFF with a clock
#       for synchronous reset, and every constant 1 loaded into a DFF with a
#       clock for synchronous set
#
# - set compile_seqmap_honor_sync_set_reset true
#
#     - Tells DC to preserve synchronous reset or preset logic close to
#       the flip-flop
#
# So the hdlin variable first tells DC to treat resets as synchronous, and
# the compile variable tells DC that for all these synchronous reset DFFs,
# keep the logic simple and close to the DFF to avoid X-propagation. The
# hdlin variable applies to the analyze step when we read in the RTL, so
# it must be set before we read in the Verilog. The second variable
# applies to compile and must be set before we run compile_ultra.
#
# Note: Instead of setting the hdlin_ff_always_sync_set_reset variable to
# true, you can specifically tell DC about a particular DFF reset using
# the //synopsys sync_set_reset "reset, int_reset" pragma.
#
# By default, the hdlin_ff_always_async_set_reset variable is set to true,
# and the hdlin_ff_always_sync_set_reset variable is set to false.

set hdlin_ff_always_sync_set_reset      true
set compile_seqmap_honor_sync_set_reset true

# When boundary optimizations are off, set this variable to true to still
# allow unconnected registers to be removed.

set compile_optimize_unloaded_seq_logic_with_no_bound_opt true

# Remove new variable info messages from the end of the log file

set_app_var sh_new_variable_message false

# Hook to drop into interactive Design Compiler shell after setup

if {[info exists ::env(DC_EXIT_AFTER_SETUP)]} { set DC_SETUP_DONE true }


