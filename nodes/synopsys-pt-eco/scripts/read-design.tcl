#=========================================================================
# read-design.tcl
#=========================================================================
# This script reads in all the input files
#
# Author : Kartik Prabhu
# Date   : September 21, 2020

# Set up variables for this specific ASIC design kit

source -echo -verbose $pt_adk_tcl


# Set up paths and libraries

set_app_var search_path      ". $pt_additional_search_path $search_path"
set_app_var target_library   $pt_target_libraries
set_app_var link_library     "* $pt_target_libraries $pt_extra_link_libraries"

#-------------------------------------------------------------------------
# Read design
#-------------------------------------------------------------------------

# Read and link the design

read_verilog   $pt_gl_netlist
current_design $pt_design_name

link_design

# Read in the SDC and parasitics

read_sdc -echo $pt_sdc
read_parasitics -format spef $pt_spef
