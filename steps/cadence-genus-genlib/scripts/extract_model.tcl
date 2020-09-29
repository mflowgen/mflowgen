#=========================================================================
# extract_model.tcl
#=========================================================================
# Use Genus to extract lib model
#
# Author : James Thomas
# Date   : September 28, 2020
#

set_attribute innovus_executable [exec which innovus]

write_lib_lef -lib $genus_design_name

