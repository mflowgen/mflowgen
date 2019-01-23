#=========================================================================
# always_source.tcl
#=========================================================================
# This plug-in script is called from all Innovus flow scripts after
# loading setup.tcl.
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Floorplan variables
#-------------------------------------------------------------------------

# Set the floorplan to target a reasonable placement density with a good
# aspect ratio (height:width). An aspect ratio of 2.0 here will make a
# rectangular chip with a height that is twice the width.

set core_aspect_ratio   1.0; # Aspect ratio 1.0 for a square chip
set core_density_target 0.7; # Placement density of 70% is reasonable

# Power ring

set pwr_net_list {VDD VSS}; # List of Power nets

# Power ring metal width and spacing

set M1_min_width   [dbGet [dbGetLayerByZ 1].minWidth]
set M1_min_spacing [dbGet [dbGetLayerByZ 1].minSpacing]

set p_ring_width   [expr 48 * $M1_min_width];   # Arbitrary!
set p_ring_spacing [expr 24 * $M1_min_spacing]; # Arbitrary!

# Core bounding box margins

set core_margin_t [expr ([llength $pwr_net_list] * ($p_ring_width + $p_ring_spacing)) + $p_ring_spacing]
set core_margin_b [expr ([llength $pwr_net_list] * ($p_ring_width + $p_ring_spacing)) + $p_ring_spacing]
set core_margin_r [expr ([llength $pwr_net_list] * ($p_ring_width + $p_ring_spacing)) + $p_ring_spacing]
set core_margin_l [expr ([llength $pwr_net_list] * ($p_ring_width + $p_ring_spacing)) + $p_ring_spacing]


