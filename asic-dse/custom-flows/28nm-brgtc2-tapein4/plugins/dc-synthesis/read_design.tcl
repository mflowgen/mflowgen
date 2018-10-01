#=========================================================================
# read_design.tcl
#=========================================================================
# This script performs a custom read design

if { ![analyze -format sverilog ${RTL_SOURCE_FILES}] } {
  exit 1
}
elaborate ${DESIGN_NAME}

# Change link for pll

change_link [get_cells *pll] pll_lib/pll


