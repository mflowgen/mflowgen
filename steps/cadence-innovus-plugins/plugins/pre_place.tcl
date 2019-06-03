#=========================================================================
# pre_place.tcl
#=========================================================================
# This plug-in script is called before the corresponding Innovus flow step
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Example tasks include:
#          - Power planning related tasks which includes
#            - Power planning for power domains (ring/strap creations)
#            - Power Shut-off cell power hookup
#-------------------------------------------------------------------------

specifyCellPad *DFF* 2
reportCellPad -file $vars(rpt_dir)/$vars(step).cellpad.rpt

#-------------------------------------------------------------------------
# Global net connections for PG pins
#-------------------------------------------------------------------------

globalNetConnect VDD    -type pgpin -pin VDD    -inst * -verbose
globalNetConnect VSS    -type pgpin -pin VSS    -inst * -verbose

# Connect VNW / VPW if any cells have these pins

if { [ lindex [dbGet top.insts.cell.pgterms.name VNW] 0 ] != 0x0 } {
  globalNetConnect VDD    -type pgpin -pin VNW    -inst * -verbose
  globalNetConnect VSS    -type pgpin -pin VPW    -inst * -verbose
}

#-------------------------------------------------------------------------
# Stdcell power rail preroute
#-------------------------------------------------------------------------
# Generate horizontal stdcell preroutes

sroute -nets {VDD VSS}

#-------------------------------------------------------------------------
# Implement power strategy
#-------------------------------------------------------------------------
# Older technologies use a single coarse power mesh, but more advanced
# technologies often use a combination of a fine+coarse power mesh.
#
# Here we check the direction of M2 to decide which power strategy to use.

set M2_direction [dbGet [dbGet head.layers.name 2 -p].direction]

if { $M2_direction == "Vertical" } {
  # Vertical M2 -- Use single power mesh strategy
  puts "Info: Using coarse-only power mesh because M2 is vertical"
  source $vars(plug_dir)/power_strategy_singlemesh.tcl
} else {
  # Horizontal M2 -- Use dual power mesh strategy
  puts "Info: Using fine+coarse power mesh because M2 is horizontal"
  source $vars(plug_dir)/power_strategy_dualmesh.tcl
}

