##########################################################################################
# Variables common to all RM scripts
# Script: common_setup.tcl
# Version: D-2010.03-SP1 (May 24, 2010)
# Copyright (C) 2007-2010 Synopsys, Inc. All rights reserved.
##########################################################################################
# ctorng: Updated the reference methodology to this version
# Version: L-2016.03-SP2 (July 25, 2016)
##########################################################################################

# ctorng: Pulled out into designer interface
#set DESIGN_NAME                   ""  ;#  The name of the top-level design

#  Absolute path prefix variable for library/design data. Use this variable to
#  prefix the common absolute path to the common variables defined below.
#  Absolute paths are mandatory for hierarchical reference methodology flow.
set DESIGN_REF_DATA_PATH          ""

##########################################################################################
# Hierarchical Flow Design Variables
##########################################################################################

# List of hierarchical block design names "DesignA DesignB" ...
set HIERARCHICAL_DESIGNS           ""
# List of hierarchical block cell instance names "u_DesignA u_DesignB" ...
set HIERARCHICAL_CELLS             ""

##########################################################################################
# Library Setup Variables
##########################################################################################

# For the following variables, use a blank space to separate multiple entries.
# Example: set TARGET_LIBRARY_FILES "lib1.db lib2.db lib3.db"

# Additional search path to be added to the default search path
# This should also contain the directories where all the TARGET_LIBRARY_FILES
# (*.db) files are located.

# ctorng: Pulled out into designer interface
#set ADDITIONAL_SEARCH_PATH        ""  ;

# ctorng: Pulled out into designer interface
#set TARGET_LIBRARY_FILES          ""  ;#  Target technology logical libraries

#  Extra link logical libraries not included in TARGET_LIBRARY_FILES
#set ADDITIONAL_LINK_LIB_FILES     ""  ;

#  List of max min library pairs "max1 min1 max2 min2 max3 min3"...
set MIN_LIBRARY_FILES             ""  ;

#  Milkyway reference libraries (include IC Compiler ILMs here)

# ctorng: Pulled out into designer interface
#set MW_REFERENCE_LIB_DIRS         ""  ;

#  Reference Control file to define the Milkyway reference libs
set MW_REFERENCE_CONTROL_FILE     ""  ;

# ctorng: Pulled out into designer interface
#set TECH_FILE                     ""  ;#  Milkyway technology file
#set MAP_FILE                      ""  ;#  Mapping file for TLUplus
#set TLUPLUS_MAX_FILE              ""  ;#  Max TLUplus file
#set TLUPLUS_MIN_FILE              ""  ;#  Min TLUplus file

set MW_POWER_NET                "VDD" ;#
set MW_POWER_PORT               "VDD" ;#
set MW_GROUND_NET               "VSS" ;#
set MW_GROUND_PORT              "VSS" ;#

# ctorng: Set from the ASIC design kit stdcells.tcl
# Min routing layer
set MIN_ROUTING_LAYER            $STDCELLS_MIN_ROUTING_LAYER_DC
# Max routing layer
set MAX_ROUTING_LAYER            $STDCELLS_MAX_ROUTING_LAYER_DC

# Tcl file with library modifications for dont_use
set LIBRARY_DONT_USE_FILE        ""   ;

##########################################################################################
# Multivoltage Common Variables
#
# Define the following multivoltage common variables for the reference methodology scripts
# for multivoltage flows.
# Use as few or as many of the following definitions as needed by your design.
##########################################################################################

# Name of power domain/voltage area  1
set PD1                          ""
# Coordinates for voltage area 1
set VA1_COORDINATES              {};
# Power net for voltage area 1
set MW_POWER_NET1                "VDD1"

# Name of power domain/voltage area  2
set PD2                          ""
# Coordinates for voltage area 2
set VA2_COORDINATES              {};
# Power net for voltage area 2
set MW_POWER_NET2                "VDD2"

# Name of power domain/voltage area  3
set PD3                          ""
# Coordinates for voltage area 3
set VA3_COORDINATES              {};
# Power net for voltage area 3
set MW_POWER_NET3                "VDD3"

# Name of power domain/voltage area  4
set PD4                          ""
# Coordinates for voltage area 4
set VA4_COORDINATES              {};
# Power net for voltage area 4
set MW_POWER_NET4                "VDD4"

puts "RM-Info: Completed script [info script]\n"

