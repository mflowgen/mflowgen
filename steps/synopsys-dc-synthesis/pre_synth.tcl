#=========================================================================
# pre_synth.tcl
#=========================================================================
# This plug-in script is called before synthesis
#
# Author : Christopher Torng
# Date   : May 14, 2018

# Number of cores for multicore optimization

set dc_num_cores $env(nthreads)

# Add more link libraries (e.g., IO cells, hierarchical blocks)

# set dc_extra_link_libraries  [join "
#                                $dc_extra_link_libraries
#                                extra1.db
#                                extra2.db
#                                extra3.db
#                              "]

# Enable additional area optimizations (skip false = enable optimizations)

set DC_SKIP_OPTIMIZE_NETLIST true

# Enable clock-gating

set DC_GATE_CLOCK true

# DC flatten effort
#
# - Effort 0: No auto-ungrouping / boundary optimizations (strict hierarchy)
# - Effort 1: No auto-ungrouping / boundary optimizations
#             DesignWare cells are ungrouped (var compile_ultra_ungroup_dw)
# - Effort 2: Enable auto-ungrouping / boundary optimizations
#             DesignWare cells are ungrouped (var compile_ultra_ungroup_dw)
# - Effort 3: Everything ungrouped + level param for how deep to ungroup
#
# Note that even with boundary optimizations off, DC will still propagate
# constants across the boundary, although this can be disabled with a
# variable if we really wanted to disable it.

set DC_FLATTEN_EFFORT $env(flatten_effort)

# When boundary optimizations are off, set this variable to true to still
# allow unconnected registers to be removed.

set compile_optimize_unloaded_seq_logic_with_no_bound_opt true

