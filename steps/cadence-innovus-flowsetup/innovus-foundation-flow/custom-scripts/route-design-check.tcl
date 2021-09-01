#=========================================================================
# route-design-check.tcl
#=========================================================================
# This plug-in script replaces the default "routeDesign" command in
# Innovus flow scripts, activated via this var in setup.tcl
#   `set vars(route,route_design,replace_tcl) <path>/route-design-check.tcl`
#
# Author : Stephen Richardson
# Date   : September 1, 2021

# FAIL routeDesign immediately if placement is bad.
# Also see garnet issue https://github.com/StanfordAHA/garnet/issues/803
# 
# ANECDOTE: without the "-placementCheck" switch in the routing step,
# glb_tile CI build went into postroute_hold with bad placement and was still
# grinding 122 hours later (takes less than one hour with correct placement).

routeDesign -placementCheck
