#=========================================================================
# ptpx.tcl
#=========================================================================
# Use Synopsys PrimeTime to extract lib and db models
#
# Author : Christopher Torng
# Date   : November 22, 2019
#


#-------------------------------------------------------------------------
# Extract lib and db models
#-------------------------------------------------------------------------

update_timing -full

extract_model -library_cell -output ${ptpx_design_name} -format {lib db}

file rename -force ${ptpx_design_name}_lib.db ${ptpx_design_name}.db

