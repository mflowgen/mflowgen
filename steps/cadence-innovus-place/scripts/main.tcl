#=========================================================================
# main.tcl
#=========================================================================
# Run the foundation flow step
#
# Author : Christopher Torng
# Date   : January 13, 2020

#TODO: Move to correct location
setDontUse XNR4D0BWP16P90 true
setDontUse MUX2D1BWP16P90 true
setDontUse XOR4D0BWP16P90 true
setDontUse MUX2D0P75BWP16P90 true

#TODO: This constraint is needed so that the tie cells are 
# placed in the correct power domain
# This is a hidden variable that was provided by Cadence AE
# Without this variable setup, the tie cells
# are inserted in default TOP domain
# eventhough in the UPF it is specified to keep it always on


source -verbose innovus-foundation-flow/INNOVUS/run_place.tcl


