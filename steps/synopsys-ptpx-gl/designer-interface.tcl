#=========================================================================
# designer_interface.tcl
#=========================================================================
# The designer_interface.tcl file is the first script run by PTPX (see the
# top of ptpx.tcl) and sets up ASIC design kit variables and inputs.
#
# Author : Christopher Torng
# Date   : May 20, 2019

set ptpx_design_name        $::env(design_name)

#-------------------------------------------------------------------------
# Libraries
#-------------------------------------------------------------------------

set adk_dir                       inputs/adk

set ptpx_additional_search_path   $adk_dir
set ptpx_target_libraries         stdcells.db

set ptpx_extra_link_libraries     [join "
                                      [lsort [glob -nocomplain inputs/*.db]]
                                      [lsort [glob -nocomplain inputs/adk/*.db]]
                                  "]

#-------------------------------------------------------------------------
# Inputs
#-------------------------------------------------------------------------

set ptpx_gl_netlist         inputs/design.vcs.v
set ptpx_sdc                inputs/design.pt.sdc
set ptpx_spef               inputs/design.spef.gz
set ptpx_saif               inputs/run.saif

# The strip path must be defined!
#
#   export strip_path = th/dut
#
# There must _not_ be any quotes, or read_saif will fail. This fails:
#
#   export strip_path = "th/dut"
#

set ptpx_strip_path         $::env(strip_path)

puts "done"


