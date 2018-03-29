#=========================================================================
# always_source.tcl
#=========================================================================
# This plug-in script is called from all Innovus flow scripts after
# loading setup.tcl.

#-------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------

# Function to snap to track pitch

proc snapToTrackPitch {x} {
  global t_pitch
  return [expr [tcl::mathfunc::ceil [expr $x / $t_pitch] ] *  $t_pitch]
}


set t_pitch 0.56; # Pitch between m2 tracks (track pitch)
set r_pitch 3.92; # Pitch between power rails (standard cell height)

#-------------------------------------------------------------------------
# Floorplan variables
#-------------------------------------------------------------------------

set core_width   1100; # Core area width  1000 um
set core_height  1100; # Core area height 1000 um

# Power ring

set pwr_net_list {VDD VSS}; # List of Power nets

# Power ring metal width and spacing

set p_ring_width   3.68; # 8x width of M1 which is 0.46
set p_ring_spacing 1.84; # Arbitrarily half of ring width

# Core bounding box margins

set core_margin_t [expr ([llength $pwr_net_list] * ($p_ring_width + $p_ring_spacing)) + $p_ring_spacing]
set core_margin_b [expr ([llength $pwr_net_list] * ($p_ring_width + $p_ring_spacing)) + $p_ring_spacing]
set core_margin_r [expr ([llength $pwr_net_list] * ($p_ring_width + $p_ring_spacing)) + $p_ring_spacing]
set core_margin_l [expr ([llength $pwr_net_list] * ($p_ring_width + $p_ring_spacing)) + $p_ring_spacing]


