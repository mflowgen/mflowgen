#=========================================================================
# floorplan.tcl
#=========================================================================
# This script is called from the Innovus init flow step.

floorPlan -coreMarginsBy die \
          -b $die_llx  $die_lly  $die_urx  $die_ury \
             $io_llx   $io_lly   $io_urx   $io_ury  \
             $core_llx $core_lly $core_urx $core_ury

setFlipping s

#-------------------------------------------------------------------------
# Physical IO cells
#-------------------------------------------------------------------------
# Add physical IO cells
#
# - Corner cells
# - Power pads
# - Bond pads

addInst -physical -cell PCORNERE_G -inst PCORNER_TOPLEFT
addInst -physical -cell PCORNERE_G -inst PCORNER_TOPRIGHT
addInst -physical -cell PCORNERE_G -inst PCORNER_BOTTOMLEFT
addInst -physical -cell PCORNERE_G -inst PCORNER_BOTTOMRIGHT

# Core VDD iocells

addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_west_0_iocell; # W, horizontal
addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_west_1_iocell; # W, horizontal

addInst -physical -cell PVDD1CDE_V_G -inst vdd_core_north_0_iocell; # N, vertical
addInst -physical -cell PVDD1CDE_V_G -inst vdd_core_north_1_iocell; # N, vertical
addInst -physical -cell PVDD1CDE_V_G -inst vdd_core_north_2_iocell; # N, vertical

addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_east_0_iocell; # E, horizontal
addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_east_1_iocell; # E, horizontal

addInst -physical -cell PVDD1CDE_V_G -inst vdd_core_south_0_iocell; # S, vertical
addInst -physical -cell PVDD1CDE_V_G -inst vdd_core_south_1_iocell; # S, vertical

# Core VSS iocells

addInst -physical -cell PVSS1CDE_H_G -inst vss_core_west_0_iocell; # W, horizontal
addInst -physical -cell PVSS1CDE_H_G -inst vss_core_west_1_iocell; # W, horizontal

addInst -physical -cell PVSS1CDE_V_G -inst vss_core_north_0_iocell; # N, vertical
addInst -physical -cell PVSS1CDE_V_G -inst vss_core_north_1_iocell; # N, vertical
addInst -physical -cell PVSS1CDE_V_G -inst vss_core_north_2_iocell; # N, vertical

addInst -physical -cell PVSS1CDE_H_G -inst vss_core_east_0_iocell; # E, horizontal
addInst -physical -cell PVSS1CDE_H_G -inst vss_core_east_1_iocell; # E, horizontal

addInst -physical -cell PVSS1CDE_V_G -inst vss_core_south_0_iocell; # S, vertical
addInst -physical -cell PVSS1CDE_V_G -inst vss_core_south_1_iocell; # S, vertical

# IO VDD iocells

addInst -physical -cell PVDD2CDE_H_G -inst vdd_io_west_0_iocell; # W, horizontal

addInst -physical -cell PVDD2CDE_V_G -inst vdd_io_north_0_iocell; # N, vertical
addInst -physical -cell PVDD2CDE_V_G -inst vdd_io_north_1_iocell; # N, vertical

addInst -physical -cell PVDD2POCE_H_G -inst vdd_poc_east_0_iocell; # E, POC horizontal
addInst -physical -cell PVDD2CDE_H_G -inst vdd_io_east_0_iocell;   # E, horizontal

addInst -physical -cell PVDD2CDE_V_G -inst vdd_io_south_0_iocell; # S, vertical

# IO VSS iocells

addInst -physical -cell PVSS2CDE_H_G -inst vss_io_west_0_iocell; # W, horizontal

addInst -physical -cell PVSS2CDE_V_G -inst vss_io_north_0_iocell; # N, vertical
addInst -physical -cell PVSS2CDE_V_G -inst vss_io_north_1_iocell; # N, vertical
addInst -physical -cell PVSS2CDE_V_G -inst vss_io_north_2_iocell; # N, vertical

addInst -physical -cell PVSS2CDE_H_G -inst vss_io_east_0_iocell; # E, horizontal
addInst -physical -cell PVSS2CDE_H_G -inst vss_io_east_1_iocell; # E, horizontal

addInst -physical -cell PVSS2CDE_V_G -inst vss_io_south_0_iocell; # S, vertical
addInst -physical -cell PVSS2CDE_V_G -inst vss_io_south_1_iocell; # S, vertical

# Dummy cells

#addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_0_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_1_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_2_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_3_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_4_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_5_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_6_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_7_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_8_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_9_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_10_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_11_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_12_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_13_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_14_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_15_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_16_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_17_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_18_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_19_iocell; # horizontal

#addInst -physical -cell PVDD2CDE_V_G -inst  vss_dummy_v_0_iocell; # horizontal

#-------------------------------------------------------------------------
# Bond pads
#-------------------------------------------------------------------------
# The "dummy" is a blank entry that makes the iteration variable "i"
# increment just to make the inner/outer match up with the even/odd setup
# of my loop.

# Choose bond pad cells

set iobond_cell_outer PAD60GU
set iobond_cell_inner PAD60NU

#set iobond_cell_outer PAD50GU
#set iobond_cell_inner PAD50NU

# How many bond pads on each side and are they outer or inner staggered?

set n_iobonds_h_west_outer   7; # number of OUTER bond pads on WEST
set n_iobonds_h_west_inner   6; # number of INNER bond pads on WEST

set n_iobonds_h_east_outer   7; # number of OUTER bond pads on EAST
set n_iobonds_h_east_inner   6; # number of INNER bond pads on EAST

set n_iobonds_v_north_outer 10; # number of OUTER bond pads on NORTH
set n_iobonds_v_north_inner  9; # number of INNER bond pads on NORTH

set n_iobonds_v_south_outer 10; # number of OUTER bond pads on SOUTH
set n_iobonds_v_south_inner  9; # number of INNER bond pads on SOUTH

# Add physical bondpads on WEST

for {set bond_i 0} {$bond_i < $n_iobonds_h_west_outer} {incr bond_i} {
  addInst -physical -cell $iobond_cell_outer -inst iobond_h_west_outer_$bond_i
}

for {set bond_i 0} {$bond_i < $n_iobonds_h_west_inner} {incr bond_i} {
  addInst -physical -cell $iobond_cell_inner -inst iobond_h_west_inner_$bond_i
}

# Add physical bondpads on EAST

for {set bond_i 0} {$bond_i < $n_iobonds_h_east_outer} {incr bond_i} {
  addInst -physical -cell $iobond_cell_outer -inst iobond_h_east_outer_$bond_i
}

for {set bond_i 0} {$bond_i < $n_iobonds_h_east_inner} {incr bond_i} {
  addInst -physical -cell $iobond_cell_inner -inst iobond_h_east_inner_$bond_i
}

# Add physical bondpads on NORTH

for {set bond_i 0} {$bond_i < $n_iobonds_v_north_outer} {incr bond_i} {
  addInst -physical -cell $iobond_cell_outer -inst iobond_v_north_outer_$bond_i
}

for {set bond_i 0} {$bond_i < $n_iobonds_v_north_inner} {incr bond_i} {
  addInst -physical -cell $iobond_cell_inner -inst iobond_v_north_inner_$bond_i
}

# Add physical bondpads on SOUTH

for {set bond_i 0} {$bond_i < $n_iobonds_v_south_outer} {incr bond_i} {
  addInst -physical -cell $iobond_cell_outer -inst iobond_v_south_outer_$bond_i
}

for {set bond_i 0} {$bond_i < $n_iobonds_v_south_inner} {incr bond_i} {
  addInst -physical -cell $iobond_cell_inner -inst iobond_v_south_inner_$bond_i
}

#-------------------------------------------------------------------------
# Create IO Rows
#-------------------------------------------------------------------------
# Use the Innovus IO row flow to make the rows

setIoFlowFlag 1

foreach side [list S E N W] {
  createIoRow -site pad -beginOffset [expr $seal_ring_len + $io_chipedge_extension + $io_cell_len] \
                        -endOffset   [expr $seal_ring_len + $io_chipedge_extension + $io_cell_len] \
                        -rowMargin   [expr $seal_ring_len + $io_chipedge_extension               ] \
                        -side        $side                                                         \
                        -name        iorow_$side
}

foreach side [list BL BR TL TR] {
  createIoRow -site corner -xOffset [expr $seal_ring_len + $io_chipedge_extension] \
                           -yOffset [expr $seal_ring_len + $io_chipedge_extension] \
                           -corner  $side                                          \
                           -name    iorow_$side
}

#-------------------------------------------------------------------------
# Floorplan IO cells and bond pads into the IO rows
#-------------------------------------------------------------------------
# If we need to start over to get an IO save file...
#
# Misc experimentation just to get a save.io file to work with (assuming
# we are not using loadIoFile since we don't have one yet)
#
# Use the IO row flow to create an IO row on all four sides in the right
# locations (offset by seal ring). Also create the IO row for the corners.
# Load up the GUI to see the rows in the right places. Then use
# snapFPlanIO to get every IO instance onto the row. Then use placePIO to
# space things out evenly along the row. Save this file and modify by
# hand.
#
# Ways to save the IO file
#
# - Sequence: this just has the order of the IO cells as well as which row
# they are in and how they are orientated, but no absolute positions. This
# is very useful to save the sequence file first and make sure all the
# cells are in the right rows and oriented as expected. Usually corner
# cells will be in the wrong corner, digital IO cells will be in the wrong
# rows, etc. This is also a good time to check that the row can contain
# all of the IO cells you want with a large enough pitch to be bonded
# (e.g., 90um pitch).
#
# - Location: once sequence is good, save with absolute locations. This
# adds the "offset" field to each instance to save where they are in that
# row.
#
# Modifications by hand
#
# - Adjust offsets if needed
#
# - Add the bond pads directly centered on top of each iocell. This can be
# done pretty easily by adding a new entry after each iocell that uses the
# space parameter with some negative value. The space parameter places the
# instance relative to the edge of the previously placed cell, so a
# negative spacing will move the bondpad on top of the previous iocell.
#
# - Indent bond pads if using staggered IO to get the expected extensions
# into the die/core area.

#snapFPlanIO -toIoRow

#placePIO

# Load in the IO cells from the saved file

loadIoFile -noAdjustDieSize $vars(plug_dir)/$vars(design).save.io

# Make sure to add fillers in order from largest width to smallest width

addIoRowFiller -cell {PFILLERE20_G PFILLERE10_G PFILLERE5_G PFILLERE1_G PFILLERE05_G PFILLERE0005_G}

# Turn off IO flow

setIoFlowFlag 0

#-------------------------------------------------------------------------
# Routing blockage/halo around IO rows
#-------------------------------------------------------------------------

# Pull this in from 180nm-pcosync-chip if needed

#-------------------------------------------------------------------------
# PLL
#-------------------------------------------------------------------------

selectInst pll
set pll_height  [dbGet selected.box_sizey]
deselectAll

set pll_extra_pad [ expr $r_pitch * 6 ]
set pll_llx       [ expr $core_llx + $pll_extra_pad ]
set pll_lly       [ expr $core_ury - $pll_height - $pll_extra_pad ]

placeInstance pll $pll_llx $pll_lly

# Cut the stdcell rows around the pll

selectInst pll
cutRow -selected -halo $pll_margin
cutRow -selected -leftGap   [expr $pll_margin + 5] \
                 -topGap    [expr $pll_margin + 5] \
                 -bottomGap [expr $pll_margin] \
                 -rightGap  [expr $pll_margin]
deselectInst *

# PLL placement halo

createPlaceBlockage -inst pll -type soft -outerRingBySide \
  $pll_extra_pad $pll_extra_pad $pll_extra_pad $pll_extra_pad

# Cover the PLL with a routing block to prevent the PG coarse mesh from
# interfering with the power inside, and also to prevent any signal
# routing since the PLL is using all the routing layers.

createRouteBlk -name pll_route_block \
               -inst pll -cover \
               -layer all \
               -spacing [expr $pll_margin]

# PLL routing halo

addRoutingHalo -inst   pll \
               -space  $pll_extra_pad \
               -bottom M1 \
               -top    M9

#-------------------------------------------------------------------------
# SRAM
#-------------------------------------------------------------------------

# Place the SRAM an inset of N stdcell row heights into the core area

set sram_inset [expr $r_pitch * 10]

# I$ SRAMs

placeInstance brgtc2/dut/icache/dpath/data_array_0/sram/mem_000_000 \
              [ expr $core_llx +               110.00 ] \
              [ expr $core_lly + $sram_inset ] \
              My

placeInstance brgtc2/dut/icache/dpath/tag_array_0/sram/mem_000_000 \
              [ expr $core_llx +               110.00 ] \
              [ expr $core_lly + $sram_inset + 436.62 ] \
              My

placeInstance brgtc2/dut/icache/dpath/data_array_1/sram/mem_000_000 \
              [ expr $core_llx +               340.00 ] \
              [ expr $core_lly + $sram_inset ] \
              R0

placeInstance brgtc2/dut/icache/dpath/tag_array_1/sram/mem_000_000 \
              [ expr $core_llx +               340.00 ] \
              [ expr $core_lly + $sram_inset + 436.62 ] \
              R0

# D$ SRAMs

placeInstance brgtc2/dut/dcache/dpath/data_array_0/sram/mem_000_000 \
              [ expr $core_llx +               448.33 ] \
              [ expr $core_lly + $sram_inset ] \
              My

placeInstance brgtc2/dut/dcache/dpath/tag_array_0/sram/mem_000_000 \
              [ expr $core_llx +               448.33 ] \
              [ expr $core_lly + $sram_inset + 436.62 ] \
              My

placeInstance brgtc2/dut/dcache/dpath/data_array_1/sram/mem_000_000 \
              [ expr $core_llx +               742.45 ] \
              [ expr $core_lly + $sram_inset ] \
              R0

placeInstance brgtc2/dut/dcache/dpath/tag_array_1/sram/mem_000_000 \
              [ expr $core_llx +               742.45 ] \
              [ expr $core_lly + $sram_inset + 436.62 ] \
              R0

# Reserve space for hold-fixing buffers right next to the SRAM pins

set sram_soft_blockage_len 2.5

createPlaceBlockage -inst brgtc2/dut/icache/dpath/data_array_0/sram/mem_000_000 \
                    -type soft -outerRingBySide 0 0 $sram_soft_blockage_len 0

createPlaceBlockage -inst brgtc2/dut/icache/dpath/tag_array_0/sram/mem_000_000 \
                    -type soft -outerRingBySide 0 0 $sram_soft_blockage_len 0

createPlaceBlockage -inst brgtc2/dut/icache/dpath/data_array_1/sram/mem_000_000 \
                    -type soft -outerRingBySide $sram_soft_blockage_len 0 0 0

createPlaceBlockage -inst brgtc2/dut/icache/dpath/tag_array_1/sram/mem_000_000 \
                    -type soft -outerRingBySide $sram_soft_blockage_len 0 0 0


createPlaceBlockage -inst brgtc2/dut/dcache/dpath/data_array_0/sram/mem_000_000 \
                    -type soft -outerRingBySide 0 0 $sram_soft_blockage_len 0

createPlaceBlockage -inst brgtc2/dut/dcache/dpath/tag_array_0/sram/mem_000_000 \
                    -type soft -outerRingBySide 0 0 $sram_soft_blockage_len 0

createPlaceBlockage -inst brgtc2/dut/dcache/dpath/data_array_1/sram/mem_000_000 \
                    -type soft -outerRingBySide $sram_soft_blockage_len 0 0 0

createPlaceBlockage -inst brgtc2/dut/dcache/dpath/tag_array_1/sram/mem_000_000 \
                    -type soft -outerRingBySide $sram_soft_blockage_len 0 0 0

# Cut the stdcell rows around the SRAM

selectInst $mem_macros
cutRow -selected -halo $sram_margin
deselectInst *

#-------------------------------------------------------------------------
# Floorplanning
#-------------------------------------------------------------------------
# Not strictly necessary, but rough floorplan

# Host region

set host_region_start_x $core_llx
set host_region_end_x   [ expr $core_llx + 110.00 ]

set host_region [list $host_region_start_x $core_lly \
                      $host_region_end_x   $core_ury ]

set host_queues [ dbGet top.hInst.allTreeInsts.name *in_q_00? ]

foreach queue $host_queues {
  createRegion $queue $host_region
}

# Icache region

set icache_region_start_x [ expr $core_llx + 215.0 ]
set icache_region_end_x   [ expr $core_llx + 345.0 ]

set icache_region [list $icache_region_start_x $core_lly \
                        $icache_region_end_x   $core_ury ]

createRegion brgtc2/dut/icache           $icache_region
createRegion brgtc2/dut/l0i_000          $icache_region
createRegion brgtc2/dut/l0i_001          $icache_region
createRegion brgtc2/dut/l0i_002          $icache_region
createRegion brgtc2/dut/l0i_003          $icache_region
createRegion brgtc2/dut/icache_coalescer $icache_region

# Dcache region

set dcache_region_start_x [ expr $core_llx + 555.0 ]
set dcache_region_end_x   [ expr $core_llx + 745.0 ]

set dcache_region [list $dcache_region_start_x $core_lly \
                        $dcache_region_end_x   $core_ury ]

createRegion brgtc2/dut/dcache $dcache_region
createRegion brgtc2/dut/fpu    $dcache_region
createRegion brgtc2/dut/mdu    $dcache_region

# Procs go into either icache or dcache regions

set proc_region_start_x $icache_region_start_x
set proc_region_end_x   $dcache_region_end_x

set proc_region [list $proc_region_start_x $core_lly \
                      $proc_region_end_x   $core_ury ]

createRegion brgtc2/dut/proc_000 $proc_region
createRegion brgtc2/dut/proc_001 $proc_region
createRegion brgtc2/dut/proc_002 $proc_region
createRegion brgtc2/dut/proc_003 $proc_region

