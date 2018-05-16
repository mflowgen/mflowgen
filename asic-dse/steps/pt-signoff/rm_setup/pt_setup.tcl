# Source the designer interface script, which sets variables from the build
# system, sets up plugins, sets up ASIC design kit variables, etc.

source -echo -verbose $::env(pt_plugins_dir)/designer_interface.tcl

# Source standard-cell-library-specific TCL file. This will setup
# variables for using the standard-cell library.

source -echo -verbose ${stdcells_tcl}

# Set up common variables (pull from dc-synthesis)

source -echo -verbose $::env(pt_flow_dir)/../dc-synthesis/rm_setup/common_setup.tcl

puts "RM-Info: Running script [info script]\n"

##########################################################################################
# PrimeTime Variables PrimeTime Reference Methodology script
# Script: pt_setup.tcl
# Version: K-2015.12-SP2 (April 4, 2016)
# Copyright (C) 2008-2016 Synopsys All rights reserved.
##########################################################################################


######################################
# Report and Results Directories
######################################

# ctorng: Pulled out into designer interface
#set REPORTS "$::env(PT_REPORTS_DIR)"
#set RESULTS "$::env(PT_RESULTS_DIR)"

if { ! [file exists $REPORTS] } { file mkdir ${REPORTS} }
if { ! [file exists $RESULTS] } { file mkdir ${RESULTS} }

######################################
# PNS Variables
######################################
# ctorng: Pulled out into designer interface
#set PNS_VOLTAGE_SUPPLY      0.8
set PNS_VOLTAGE_SCALER      0.1

# Between-the-rails noise bump constraints on non-switching cell pins.
# The value is the noise height in units of percentage of supply voltage.
#
# Margin allowed above ground rail voltage, according to "vil" in cell libraries.
set NOISE_MARGIN_ABOVE_LOW        "0.25"
#
# Margin allowed below power rail voltage, according to "vih" in cell libraries.
set NOISE_MARGIN_BELOW_HIGH       "0.25"

# Beyond-the-rails noise bump constraints on non-switching cell pins.
# The value is the noise height in units of voltage.
#
#  MBT 9/12/2016: NOISE_MARGIN_BELOW_LOW and NOISE_MARGIN_ABOVE_HIGH do not appear to do anything in the flow.
#
# Margin allowed below ground rail voltage, according to "vimin" in cell libraries.
set NOISE_MARGIN_BELOW_LOW        "0.2"
#
# Margin allowed above power rail voltage, according to "vimax" in cell libraries.
set NOISE_MARGIN_ABOVE_HIGH       "0.2"


if { ${corner_case} == "max" } {
  set target_library        ${MAX_LIBRARY_SET}
  set noise_margin_above_low  [expr $NOISE_MARGIN_ABOVE_LOW  * (1 - $PNS_VOLTAGE_SCALER) * $PNS_VOLTAGE_SUPPLY]
  set noise_margin_below_high [expr $NOISE_MARGIN_BELOW_HIGH * (1 - $PNS_VOLTAGE_SCALER) * $PNS_VOLTAGE_SUPPLY]
} elseif { ${corner_case} == "min" } {
  set target_library        ${MIN_LIBRARY_SET}
  set noise_margin_above_low  [expr $NOISE_MARGIN_ABOVE_LOW  * (1 + $PNS_VOLTAGE_SCALER) * $PNS_VOLTAGE_SUPPLY]
  set noise_margin_below_high [expr $NOISE_MARGIN_BELOW_HIGH * (1 + $PNS_VOLTAGE_SCALER) * $PNS_VOLTAGE_SUPPLY]
} elseif { ${corner_case} == "typical" } {
  set target_library        $LIBRARY_SET(typical)
  set noise_margin_above_low  [expr $NOISE_MARGIN_ABOVE_LOW  * $PNS_VOLTAGE_SUPPLY]
  set noise_margin_below_high [expr $NOISE_MARGIN_BELOW_HIGH * $PNS_VOLTAGE_SUPPLY]
} elseif { ${corner_case} == "ff_typical" } {
  set target_library        $LIBRARY_SET(ff_typical)
  set noise_margin_above_low  [expr $NOISE_MARGIN_ABOVE_LOW  * $PNS_VOLTAGE_SUPPLY]
  set noise_margin_below_high [expr $NOISE_MARGIN_BELOW_HIGH * $PNS_VOLTAGE_SUPPLY]
}

######################################
# Library and Design Setup
######################################

### Mode : Generic

set search_path ". $ADDITIONAL_SEARCH_PATH $search_path"
set target_library $TARGET_LIBRARY_FILES
set link_path "* $target_library $ADDITIONAL_LINK_LIB_FILES"

# Provide list of Verilog netlist files. It can be compressed --- example "A.v B.v C.v"
# ctorng: Pulled out into designer interface
#set NETLIST_FILES               "$::env(INNOVUS_RESULTS_DIR)/${DESIGN_NAME}.pt.v"
# DESIGN_NAME is checked for existence from common_setup.tcl
#if {[string length $DESIGN_NAME] > 0} {
#} else {
#set DESIGN_NAME                   ""  ;#  The name of the top-level design
#}

#######################################
# Non-DMSA Power Analysis Setup Section
#######################################

# switching activity (VCD/SAIF) file 
set ACTIVITY_FILE ""

# strip_path setting for the activity file
set STRIP_PATH ""

## name map file
set NAME_MAP_FILE ""

######################################
# Back Annotation File Section
######################################
# The recommended order is to put the block spefs first then the top so that block spefs are read 1st then top
# For example 
# PARASITIC_FILES "blk1.gpd blk2.gpd ... top.gpd"
# PARASITIC_PATHS "u_blk1 u_blk2 ... top"
# If you are loading the node coordinates by setting read_parasitics_load_locations true, it is more efficient
# to read the top first so that block coordinates can be transformed as they are read in
# Each PARASITIC_PATH entry corresponds to the related PARASITIC_FILE for the specific block"  
# For toplevel PARASITIC file please use the toplevel design name in PARASITIC_PATHS variable."   

# ctorng: Pulled out into designer interface
#if       { ${corner_case} == "max" } {
#  set PARASITIC_FILES      "$::env(INNOVUS_RESULTS_DIR)/rcbest.spef.gz"
#} elseif { ${corner_case} == "min" } {
#  set PARASITIC_FILES      "$::env(INNOVUS_RESULTS_DIR)/rcworst.spef.gz"
#} elseif { ${corner_case} == "typ" } {
#  set PARASITIC_FILES      "$::env(INNOVUS_RESULTS_DIR)/typical.spef.gz"
#} elseif { ${corner_case} == "ff_typ_0p88v_125c" } {
#  set PARASITIC_FILES      "$::env(INNOVUS_RESULTS_DIR)/typical.spef.gz"
#}
#set PARASITIC_PATHS	 "" 

######################################
# Constraint Section Setup
######################################

# ctorng: Pulled out into designer interface
#if {[info exists scripts/pt/constraints.tcl]} {
#  set CONSTRAINT_FILES     "scripts/pt/constraints.tcl"
#} else {
#  set CONSTRAINT_FILES     "$::env(INNOVUS_RESULTS_DIR)/${DESIGN_NAME}.pt.sdc"
#}

######################################
# End
######################################

### End of PrimeTime Runtime Variables ###
puts "RM-Info: Completed script [info script]\n"
