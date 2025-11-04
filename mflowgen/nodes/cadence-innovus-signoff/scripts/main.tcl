#=========================================================================
# main.tcl
#=========================================================================
# Run the foundation flow step
#
# Author : Christopher Torng
# Date   : January 13, 2020

# Change name rules to be case insensitive to guarantee unique names 
# even with case insensitive tools 
# ("N23" and "n23" becomes -> "N23" and "n23_<num>")

update_names -nocase

source -verbose innovus-foundation-flow/INNOVUS/run_signoff.tcl


