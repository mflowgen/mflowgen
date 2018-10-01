#=========================================================================
# setup.tcl
#=========================================================================
# This design-specific setup.tcl can overwrite any variable in the
# default innovus-flowsetup "setup.tcl" script

# Reduced-effort flow that sacrifices timing to iterate more quickly

set vars(reduced_effort_flow) false

# CPF file for power intent (causes DRC violations in route!)

# set vars(cpf_file)            $vars(plug_dir)/power_intent.cpf
# set vars(cpf_keep_rows)       TRUE
# set vars(cpf_power_domain)    FALSE
# set vars(cpf_power_switch)    FALSE
# set vars(cpf_isolation)       FALSE
# set vars(cpf_state_retention) FALSE
# set vars(cpf_level_shifter)   FALSE
#
# # Disables the generation of Conformal Low Power verification outputs.
#
# set vars(run_clp) false

# Add the PLL hierarchically

set pll_lib [glob /work/global/clt67/brgtc2-pin/*.lib]

set pll_lef [glob /work/global/clt67/brgtc2-pin/*.lef]

set vars(libs_typical,timing) [join "$vars(libs_typical,timing) $pll_lib" ]
set vars(libs_bc,timing)      [join "$vars(libs_bc,timing)      $pll_lib" ]
set vars(libs_wc,timing)      [join "$vars(libs_wc,timing)      $pll_lib" ]
set vars(lef_files)           [join "$vars(lef_files)           $pll_lef" ]

