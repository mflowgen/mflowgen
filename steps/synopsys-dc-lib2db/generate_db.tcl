#=========================================================================
# generate_db.tcl
#=========================================================================
# Generate db from a lib file (using Synopsys DC)
#
# For the library name, look at the top of the .lib file:
#
#     library (NangateOpenCellLibrary) (...)
#
# Author : Christopher Torng
# Date   : November 11, 2019
#

enable_write_lib_mode
read_lib ../inputs/design.lib
write_lib -format db $::env(design_name) -output ../outputs/design.db

exit

