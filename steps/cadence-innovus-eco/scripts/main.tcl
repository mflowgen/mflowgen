#=========================================================================
# main.tcl
#=========================================================================
# Author : Kartik Prabhu
# Date   : September 21, 2020

# Remove filler first
deleteFiller

setEcoMode -honorDontTouch false -refinePlace false -updateTiming false

# Implement ECOs
setEcoMode -batchMode true
source -echo inputs/innovus_eco.tcl
setEcoMode -batchMode false

ecoPlace
ecoRoute

setFillerMode -core $vars(filler_cells) -corePrefix FILL
addFiller

