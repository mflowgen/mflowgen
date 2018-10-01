#=========================================================================
# read_design.tcl
#=========================================================================
# This script performs a custom read design

if { ![analyze -format sverilog $dc_rtl_handoff] } {
  exit 1
}
elaborate $dc_design_name

# Change link for pll

change_link [get_cells *pll] pll_lib/pll


