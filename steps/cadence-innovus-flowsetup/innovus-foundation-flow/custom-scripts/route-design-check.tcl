#=========================================================================
# route-design-check.tcl
#=========================================================================
# This plug-in script replaces the default "routeDesign" command in
# Innovus flow scripts, activated via this var in setup.tcl
#   `set vars(route,route_design,replace_tcl) <path>/route-design-check.tcl`

# Author : Stephen Richardson
# Update : February 17, 2022
# Issue  : https://github.com/mflowgen/mflowgen/issues/119

# Optionally FAIL routeDesign if it e.g. creates short circuits. Note
# that this is the default behavior, but only for technologies below 20nm
# [Innovus Text Command Reference v. 19.10 p. 3204:
# "-drouteAutoStop is false by default for 20nm designs and below."]

# ANECDOTE:  without "-drouteAutoStop", garnet Tile_PE route step failed
# silently, and the error only surfaced much later when LVS failed, see
# https://github.com/StanfordAHA/garnet/issues/833

# Failure mode can now be controlled by way of an environment variable,
# e.g. "export stop_on_failed_routing true"

if {[info exists ::env(stop_on_failed_routing)]} {
    setNanoRouteMode -drouteAutoStop $::env(stop_on_failed_routing)
}

# Author : Stephen Richardson
# Date   : September 1, 2021

# FAIL routeDesign immediately if placement is bad.
# Also see garnet issue https://github.com/StanfordAHA/garnet/issues/803
# 
# ANECDOTE: without the "-placementCheck" switch in the routing step,
# glb_tile CI build went into postroute_hold with bad placement and was still
# grinding 122 hours later (takes less than one hour with correct placement).

routeDesign -placementCheck
