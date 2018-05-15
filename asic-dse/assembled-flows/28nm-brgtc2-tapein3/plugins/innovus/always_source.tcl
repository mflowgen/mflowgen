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


set t_pitch 0.10; # Pitch between m2 tracks (track pitch)
set r_pitch 0.90; # Pitch between power rails (standard cell height)
# FIXME

#-------------------------------------------------------------------------
# Floorplan variables
#-------------------------------------------------------------------------

# Seal ring requires a width of:
#
#   2 * 186.8 um (corners)    +    N * 5.4 um (side cells)
#
# The closest width to 1250 um is N=162, for a total width of 1248.4 um.

set die_width   1248.4; # Die area width  1.25 mm
set die_height  1000.0; # Die area height 1 mm

#-------------------------------------------------------------------------
# IO pad floorplan
#-------------------------------------------------------------------------

# The die edge must have space for:
#
# 1. Seal ring
# 2. IO cell height + staggered IO extension
# 3. Extra margin for power routing
#
#      25?     110  +  90    8.4
#       um       um     um    um
#     |-----|---------------|---|----->
#     ^  ^         ^          ^    ^
#     |  |         |          |    +---- Core area from here onward
#     |  |         |          +--------- Margin for power routing
#     |  |         +-------------------- IO cell height
#     |  +------------------------------ Seal ring
#     +--------------------------------- Die boundary
#
# Summing up from die boundary to core boundary:
#
#    25
# + 110
# +  90
# +   8.4
# -------
#    233.4
#
# Core width = 1000 - 233.4*2 = 533.2 um

set seal_ring_len   25; # FIXME
set io_cell_len    110; # IO cell height (IO cell databook)

#set io_chipedge_extension 29.16; # Chipedge extension for 50um staggered pad pitch
#set io_coreedge_extension 60.84; # Core extension for 50um staggered pad pitch

set io_chipedge_extension 11.66; # Chipedge extension for 60um staggered pad pitch
set io_coreedge_extension 42.34; # Core extension for 60um staggered pad pitch

# Coordinate for bottom-left IO corner cell (used for dropping text labels for LVS)

set io_corner_bl_llx [expr $seal_ring_len + $io_chipedge_extension]
set io_corner_bl_lly [expr $seal_ring_len + $io_chipedge_extension]

# Staggered IO total extension

set io_stagger_len [expr $io_chipedge_extension + $io_coreedge_extension]

set io_len         [expr $io_cell_len + $io_stagger_len]

# Power ring

set pwr_net_list {VDD VSS}; # List of Power nets

# Power ring metal width and spacing

set p_ring_width   2.4; # Arbitrary and temporary!
set p_ring_spacing 1.2; # Arbitrary and temporary!
set p_ring_offset  2.6; # TSMC bond pad requires >= 2.5um offset to avoid DRC

set core_margin_len [expr ([llength $pwr_net_list] * ($p_ring_width + $p_ring_spacing)) + $p_ring_offset]

# All boxes

set die_llx  0.00
set die_lly  0.00
set die_urx  $die_width
set die_ury  $die_height

set io_llx   $seal_ring_len
set io_lly   $seal_ring_len
set io_urx   [expr $die_width  - $seal_ring_len]
set io_ury   [expr $die_height - $seal_ring_len]

set core_llx [expr               $seal_ring_len + $io_len + $core_margin_len]
set core_lly [expr               $seal_ring_len + $io_len + $core_margin_len]
set core_urx [expr $die_width  - $seal_ring_len - $io_len - $core_margin_len]
set core_ury [expr $die_height - $seal_ring_len - $io_len - $core_margin_len]

# Memory macro variables

set mem_macros      [dbGet top.insts.cell.name sram* -p2]
set mem_macro_paths [dbGet [dbGet top.insts.cell.name sram* -p2].name]

set sram_margin [expr $r_pitch * 1]; # Halo margin around each SRAM

