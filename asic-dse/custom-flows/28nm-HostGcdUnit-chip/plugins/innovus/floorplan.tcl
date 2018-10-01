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

# Core VDD and VSS iocells

addInst -physical -cell PVDD1CDE_V_G -inst vdd_core_0_iocell; # vertical
addInst -physical -cell PVDD1CDE_V_G -inst vdd_core_1_iocell; # vertical
addInst -physical -cell PVDD1CDE_V_G -inst vdd_core_2_iocell; # vertical
addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_3_iocell; # horizontal
addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_4_iocell; # horizontal
addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_5_iocell; # horizontal
addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_6_iocell; # horizontal
addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_7_iocell; # horizontal
addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_8_iocell; # horizontal

addInst -physical -cell PVSS1CDE_V_G -inst vss_core_0_iocell; # vertical
addInst -physical -cell PVSS1CDE_V_G -inst vss_core_1_iocell; # vertical
addInst -physical -cell PVSS1CDE_V_G -inst vss_core_2_iocell; # vertical
addInst -physical -cell PVSS1CDE_H_G -inst vss_core_3_iocell; # horizontal
addInst -physical -cell PVSS1CDE_H_G -inst vss_core_4_iocell; # horizontal
addInst -physical -cell PVSS1CDE_H_G -inst vss_core_5_iocell; # horizontal
addInst -physical -cell PVSS1CDE_H_G -inst vss_core_6_iocell; # horizontal
addInst -physical -cell PVSS1CDE_H_G -inst vss_core_7_iocell; # horizontal
addInst -physical -cell PVSS1CDE_H_G -inst vss_core_8_iocell; # horizontal

# IO VDD and VSS iocells

addInst -physical -cell PVDD2CDE_V_G -inst vdd_io_0_iocell; # vertical
addInst -physical -cell PVDD2CDE_V_G -inst vdd_io_1_iocell; # vertical
addInst -physical -cell PVDD2CDE_V_G -inst vdd_io_2_iocell; # vertical
addInst -physical -cell PVDD2CDE_V_G -inst vdd_io_3_iocell; # vertical

addInst -physical -cell PVSS2CDE_V_G -inst vss_io_0_iocell; # vertical
addInst -physical -cell PVSS2CDE_V_G -inst vss_io_1_iocell; # vertical
addInst -physical -cell PVSS2CDE_V_G -inst vss_io_2_iocell; # vertical
addInst -physical -cell PVSS2CDE_V_G -inst vss_io_3_iocell; # vertical
addInst -physical -cell PVSS2CDE_V_G -inst vss_io_4_iocell; # vertical
addInst -physical -cell PVSS2CDE_V_G -inst vss_io_5_iocell; # vertical

# POC iocells

addInst -physical -cell PVDD2POCE_H_G -inst vdd_poc_0_iocell; # horizontal

# Dummy cells

addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_0_iocell; # horizontal
addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_1_iocell; # horizontal
addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_2_iocell; # horizontal
addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_3_iocell; # horizontal
addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_4_iocell; # horizontal
addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_5_iocell; # horizontal
addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_6_iocell; # horizontal
addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_7_iocell; # horizontal
addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_8_iocell; # horizontal
addInst -physical -cell PVDD2CDE_H_G -inst  vss_dummy_h_9_iocell; # horizontal
addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_10_iocell; # horizontal
addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_11_iocell; # horizontal
addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_12_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_13_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_14_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_15_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_16_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_17_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_18_iocell; # horizontal
#addInst -physical -cell PVDD2CDE_H_G -inst vss_dummy_h_19_iocell; # horizontal

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
# Routing blockages around IO rows
#-------------------------------------------------------------------------

# FIXME (pull this in from 180nm-pcosync-chip)

