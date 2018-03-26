source -echo -verbose ${DC_SETUP_DIR}/common_setup.tcl
source -echo -verbose ${DC_SETUP_DIR}/dc_setup_filenames.tcl

#################################################################################
# Design Compiler Top-Down Reference Methodology Setup
# Script: dc_setup.tcl
# Version: D-2010.03-SP1 (May 24, 2010)
# Copyright (C) 2007-2010 Synopsys, Inc. All rights reserved.
#################################################################################


#################################################################################
# Setup Variables
#
# Modify settings in this section to customize your DC-RM run.
#################################################################################

# Portions of dc_setup.tcl may be used by other tools so do check for DC only commands
if {$synopsys_program_name == "dc_shell"}  {

  # Use the set_host_options command to enable multicore optimization to improve runtime.
  # Note that this feature has special usage and license requirements.  Please refer
  # to the "Support for Multicore Technology" section in the Design Compiler User Guide
  # for multicore usage guidelines.
  # Note: This is a DC Ultra feature and is not supported in DC Expert.

  # set_host_options -max_cores 4

  # Change alib_library_analysis_path to point to a central cache of analyzed libraries
  # to save some runtime and disk space.  The following setting only reflects the
  # the default value and should be changed to a central location for best results.

  set_app_var alib_library_analysis_path ${ALIB_DIR}

  # Add any additional DC variables needed here
}

#YUNSUP: this is set by make_generated_vars.tcl
#set RTL_SOURCE_FILES  ""      ;# Enter the list of source RTL files if reading from RTL

# The following variables are used by scripts in dc_scripts to direct the location
# of the output files

#YUNSUP: this is set by make_generated_vars.tcl
#set REPORTS_DIR "reports"
#set RESULTS_DIR "results"

file mkdir ${REPORTS_DIR}
file mkdir ${RESULTS_DIR}

#################################################################################
# Library Setup
#
# This section is designed to work with the settings from common_setup.tcl
# without any additional modification.
#################################################################################

# Define all the library variables shared by all the front-end tools

set_app_var search_path ". ${ADDITIONAL_SEARCH_PATH} $search_path"


# Milkyway variable settings

# Make sure to define the following Milkyway library variables
# mw_logic1_net, mw_logic0_net and mw_design_library are needed by write_milkyway

set_app_var mw_logic1_net ${MW_POWER_NET}
set_app_var mw_logic0_net ${MW_GROUND_NET}

set mw_reference_library ${MW_REFERENCE_LIB_DIRS}
set mw_design_library ${DCRM_MW_LIBRARY_NAME}

set mw_site_name_mapping [list CORE unit Core unit core unit]

# The remainder of the setup below should only be performed in Design Compiler
if {$synopsys_program_name == "dc_shell"}  {

  # Include all libraries for multi-Vth leakage power optimization

  set_app_var target_library ${TARGET_LIBRARY_FILES}
  set_app_var synthetic_library dw_foundation.sldb
  set_app_var link_library "* $target_library $ADDITIONAL_LINK_LIB_FILES $synthetic_library"

  # Set min libraries if they exist
  foreach {max_library min_library} $MIN_LIBRARY_FILES {
    set_min_library $max_library -min_version $min_library
  }

  if {[shell_is_in_topographical_mode]} {

    # Only create new Milkyway design library if it doesn't already exist
    if {![file isdirectory $mw_design_library ]} {
      extend_mw_layers
      create_mw_lib   -technology $TECH_FILE \
                      -mw_reference_library $mw_reference_library \
                      $mw_design_library
    } else {
      # If Milkyway design library already exists, ensure that it is consistent with specified Milkyway reference libraries
      set_mw_lib_reference $mw_design_library -mw_reference_library $mw_reference_library
    }

    open_mw_lib     $mw_design_library

    check_library

    set_tlu_plus_files -max_tluplus $TLUPLUS_MAX_FILE \
                       -min_tluplus $TLUPLUS_MIN_FILE \
                       -tech2itf_map $MAP_FILE

    check_tlu_plus_files

  }

  #################################################################################
  # Library Modifications
  #
  # Apply library modifications here after the libraries are loaded.
  #################################################################################

  if {[file exists [which ${LIBRARY_DONT_USE_FILE}]]} {
    source -echo -verbose ${LIBRARY_DONT_USE_FILE}
  }
}

# Source standard-cell specific TCL file. This will set a bunch of
# variables to setup the standard cell library.

set SYNOPSYS_TOOL "dc-syn"

source -echo -verbose ${CELLS_TCL}
