#=========================================================================
# pre_postctshold.tcl
#=========================================================================
# This plug-in script is called before the corresponding Innovus flow step
#
# Author : Christopher Torng
# Date   : March 26, 2018

# Controls if hold fixing is limited to purely legal moves (no overlaps).
# When set to "true", hold optimization allows initial cell insertion to
# overlap cells and then refinePlace legalizes the cells placement. This
# provides optimization more opportunity to fix violations.

setOptMode -fixHoldAllowOverlap TRUE

