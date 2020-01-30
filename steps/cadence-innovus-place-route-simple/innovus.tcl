#=========================================================================
# Minimal Place-and-Route Script
#=========================================================================
# Author : Christopher Torng
# Date   : January 30, 2020

set init_mmmc_file "setup-timing.tcl"
set init_verilog "inputs/design.v"
set init_top_cell "$::env(design_name)"
set init_lef_file "inputs/adk/rtk-tech.lef inputs/adk/stdcells.lef"
set init_gnd_net "VSS"
set init_pwr_net "VDD"

init_design
floorPlan -su 1.0 0.70 4.0 4.0 4.0 4.0

globalNetConnect VDD -type pgpin -pin VDD -inst *
globalNetConnect VSS -type pgpin -pin VSS -inst *
sroute -nets {VDD VSS}
addRing -nets {VDD VSS} -width 0.6 -spacing 0.5 \
        -layer [list top 7 bottom 7 left 6 right 6]

addStripe -nets {VSS VDD} -layer 6 -direction vertical \
          -width 0.4 -spacing 0.5 -set_to_set_distance 5 -start 0.5

setAddStripeMode -stacked_via_bottom_layer 6 \
                 -stacked_via_top_layer    7

addStripe -nets {VSS VDD} -layer 7 -direction horizontal \
          -width 0.4 -spacing 0.5 -set_to_set_distance 5 -start 0.5

place_design
ccopt_design
routeDesign

setFillerMode -corePrefix FILL -core "FILLCELL_X1"
addFiller

saveNetlist post-pnr.v
streamOut post-pnr.gds.gz

exit
