#=========================================================================
# globalnetconnect.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : January 13, 2020

#-------------------------------------------------------------------------
# Global net connections for PG pins
#-------------------------------------------------------------------------

globalNetConnect VDD    -type pgpin -pin VPWR    -inst * -verbose
globalNetConnect VSS    -type pgpin -pin VGND    -inst * -verbose
globalNetConnect VSS    -type pgpin -pin VNB    -inst * -verbose
globalNetConnect VDD    -type pgpin -pin VPB    -inst * -verbose
