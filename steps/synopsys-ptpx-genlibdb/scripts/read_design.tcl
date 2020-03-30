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
set_app_var link_library     "* $ptpx_target_libraries $ptpx_extra_link_libraries"

#-------------------------------------------------------------------------
# Read design
#-------------------------------------------------------------------------

# Read and link the design

read_verilog   $ptpx_gl_netlist
current_design $ptpx_design_name

link_design

# Read in the SDC and parasitics
# Try to read the sdc constraints files

if {[ file exists $ptpx_sdc ]} {
    puts "\n  > Info: Sourcing $ptpx_sdc\"\n"
    read_sdc -echo $ptpx_sdc
}  else {
    puts "\n  > Warn: No sdc constraint file found\"\n"
}

# Try to read the spef parasitic files

if {[ file exists $ptpx_spef ]} {
    puts "\n  > Info: Sourcing $ptpx_sdc\"\n"
    read_parasitics -format spef $ptpx_spef
}  else {
    puts "\n  > Warn: No spef parasitic file found\"\n"
}
