#=========================================================================
# main.tcl
#=========================================================================
# Run the foundation flow step
#
# Author : Christopher Torng
# Date   : January 13, 2020

#TODO: Find the correct place for this 
##Route secondary power pins for AON Buf/Invs
routePGPinUseSignalRoute -all
source -verbose innovus-foundation-flow/INNOVUS/run_signoff.tcl


