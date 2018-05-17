#=========================================================================
# pre_cts.tcl
#=========================================================================
# This plug-in script is called before the corresponding Innovus flow step

# Allow clock gate cloning and merging

set_ccopt_property clone_clock_gates true
set_ccopt_property clone_clock_logic true
set_ccopt_property ccopt_merge_clock_gates true
set_ccopt_property ccopt_merge_clock_logic true
set_ccopt_property cts_merge_clock_gates true
set_ccopt_property cts_merge_clock_logic true

set_interactive_constraint_modes [all_constraint_modes -active]
set_clock_uncertainty 0.03       [get_clocks core_clk]

