#=========================================================================
# ptpx.tcl
#=========================================================================
# Use Synopsys PrimeTime to extract lib and db models
#
# Author : Christopher Torng
# Date   : November 22, 2019
#

#-------------------------------------------------------------------------
# Designer interface
#-------------------------------------------------------------------------
# Source the designer interface script, which sets up variables from the
# build system, sets up ASIC design kit variables, etc.

source -echo -verbose designer_interface.tcl

#-------------------------------------------------------------------------
# Setup
#-------------------------------------------------------------------------

# Set up paths and libraries

set_app_var search_path      ". $ptpx_additional_search_path $search_path"
set_app_var target_library   $ptpx_target_libraries
set_app_var link_library     "* $ptpx_target_libraries"

#-------------------------------------------------------------------------
# Read design
#-------------------------------------------------------------------------

# Read and link the design

read_verilog   $ptpx_gl_netlist
current_design $ptpx_design_name

link_design

# Read in the SDC and parasitics

read_sdc -echo $ptpx_sdc
read_parasitics -format spef $ptpx_spef

#-------------------------------------------------------------------------
# Extract lib and db models
#-------------------------------------------------------------------------

update_timing -full

extract_model -library_cell -output ${ptpx_design_name} -format {lib db} -block_scope

file rename -force ${ptpx_design_name}_lib.db ${ptpx_design_name}.db

write_interface_timing ${ptpx_design_name}_etm_netlist_interface_timing.report

exit

