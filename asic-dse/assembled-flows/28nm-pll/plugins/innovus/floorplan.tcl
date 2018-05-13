#=========================================================================
# floorplan.tcl
#=========================================================================
# This script is called from the Innovus init flow step.

floorPlan -s $core_width $core_height \
             $core_margin_l $core_margin_b $core_margin_r $core_margin_t

setFlipping s

# Arrange the pins so that inputs are on the left, spread around the
# center with 10um spacing between pins. This was done in the GUI pin
# editor and then the command was roughly copied here.

set ports_layer M4

setPinAssignMode -pinEditInBatch true
editPin -pin {in_chip_select in_clk_ref in_rstb in_scn_clk in_sdi} \
        -fixOverlap 1 -unit MICRON \
        -side Left \
        -spreadType center \
        -spreadDirection clockwise \
        -layer $ports_layer \
        -spacing 10

setPinAssignMode -pinEditInBatch true
editPin -pin {out_clk out_clk_tst out_sdo} \
        -fixOverlap 1 -unit MICRON \
        -side Right \
        -spreadType center \
        -spreadDirection clockwise \
        -layer $ports_layer \
        -spacing 10

#-------------------------------------------------------------------------
# Fences and regions
#-------------------------------------------------------------------------
# Fences and regions are hard boundaries where the instance can only be
# placed within the fence. Fences also prohibit cells from other blocks
# being placed inside, while regions allow cells from other blocks in the
# region.
#
# The PLL rough floorplan will look like this:
#
#     +--------------------------------------------------------------+
#     | +----------------------------------------------------------+ |
#     | |                                                          | |
#     | |                                                          | |
#     | |                                                          | |
#     | |  spi_top           dco_top              lfsr_25b         | |
#     | |                                                          | |
#     | |                                                          | |
#     | |                                                          | |
#     | |        fdc_top           timing_ctrl          lfsr_31b   | |
#     | |                                                          | |
#     | |                                                          | |
#     | |                                                          | |
#     | |              dlc_top                                     | |
#     | |                                                          | |
#     | |                                                          | |
#     | |                                                          | |
#     | +----------------------------------------------------------+ |
#     |                                                              |
#     | +----++----++----++----++----++----++----++----++----+       |
#     | | RO || RO || RO || RO || RO || RO || RO || RO || RO |       |
#     | | 1  || 2  || 3  || 4  || 5  || 6  || 7  || 8  || 9  | . . . |
#     | +----++----++----++----++----++----++----++----++----+       |
#     +--------------------------------------------------------------+
#
# This is how Julian's floorplan looked as well.

# Ring oscillators
#
# The ring oscillators will be placed in a long line of fences. The first
# ring oscillator on the bottom left will be placed a few row heights
# inset into the core area.

set ro_inset_x [expr $core_margin_b + 2]; # N um inset to core area
set ro_inset_y [expr $core_margin_b + 4]; # N um inset to core area

set ro_width   6.0; # width  in um
set ro_height 20.0; # height in um

set ro_gap_x  0.2; # Gap between ring oscillator fences

set ro_1_llx  $ro_inset_x
set ro_1_lly  $ro_inset_y
set ro_1_urx  [expr $ro_1_llx + $ro_width]
set ro_1_ury  [expr $ro_1_lly + $ro_height]

set ro_2_llx  [expr $ro_1_urx + $ro_gap_x]
set ro_2_lly  $ro_inset_y
set ro_2_urx  [expr $ro_2_llx + $ro_width]
set ro_2_ury  [expr $ro_2_lly + $ro_height]

set ro_3_llx  [expr $ro_2_urx + $ro_gap_x]
set ro_3_lly  $ro_inset_y
set ro_3_urx  [expr $ro_3_llx + $ro_width]
set ro_3_ury  [expr $ro_3_lly + $ro_height]

set ro_4_llx  [expr $ro_3_urx + $ro_gap_x]
set ro_4_lly  $ro_inset_y
set ro_4_urx  [expr $ro_4_llx + $ro_width]
set ro_4_ury  [expr $ro_4_lly + $ro_height]

set ro_5_llx  [expr $ro_4_urx + $ro_gap_x]
set ro_5_lly  $ro_inset_y
set ro_5_urx  [expr $ro_5_llx + $ro_width]
set ro_5_ury  [expr $ro_5_lly + $ro_height]

set ro_6_llx  [expr $ro_5_urx + $ro_gap_x]
set ro_6_lly  $ro_inset_y
set ro_6_urx  [expr $ro_6_llx + $ro_width]
set ro_6_ury  [expr $ro_6_lly + $ro_height]

set ro_7_llx  [expr $ro_6_urx + $ro_gap_x]
set ro_7_lly  $ro_inset_y
set ro_7_urx  [expr $ro_7_llx + $ro_width]
set ro_7_ury  [expr $ro_7_lly + $ro_height]

set ro_8_llx  [expr $ro_7_urx + $ro_gap_x]
set ro_8_lly  $ro_inset_y
set ro_8_urx  [expr $ro_8_llx + $ro_width]
set ro_8_ury  [expr $ro_8_lly + $ro_height]

set ro_9_llx  [expr $ro_8_urx + $ro_gap_x]
set ro_9_lly  $ro_inset_y
set ro_9_urx  [expr $ro_9_llx + $ro_width]
set ro_9_ury  [expr $ro_9_lly + $ro_height]

set ro_10_llx  [expr $ro_9_urx + $ro_gap_x]
set ro_10_lly  $ro_inset_y
set ro_10_urx  [expr $ro_10_llx + $ro_width]
set ro_10_ury  [expr $ro_10_lly + $ro_height]

set ro_11_llx  [expr $ro_10_urx + $ro_gap_x]
set ro_11_lly  $ro_inset_y
set ro_11_urx  [expr $ro_11_llx + $ro_width]
set ro_11_ury  [expr $ro_11_lly + $ro_height]

set ro_12_llx  [expr $ro_11_urx + $ro_gap_x]
set ro_12_lly  $ro_inset_y
set ro_12_urx  [expr $ro_12_llx + $ro_width]
set ro_12_ury  [expr $ro_12_lly + $ro_height]

set ro_13_llx  [expr $ro_12_urx + $ro_gap_x]
set ro_13_lly  $ro_inset_y
set ro_13_urx  [expr $ro_13_llx + $ro_width]
set ro_13_ury  [expr $ro_13_lly + $ro_height]

set ro_14_llx  [expr $ro_13_urx + $ro_gap_x]
set ro_14_lly  $ro_inset_y
set ro_14_urx  [expr $ro_14_llx + $ro_width]
set ro_14_ury  [expr $ro_14_lly + $ro_height]

set ro_15_llx  [expr $ro_14_urx + $ro_gap_x]
set ro_15_lly  $ro_inset_y
set ro_15_urx  [expr $ro_15_llx + $ro_width]
set ro_15_ury  [expr $ro_15_lly + $ro_height]

set ro_16_llx  [expr $ro_15_urx + $ro_gap_x]
set ro_16_lly  $ro_inset_y
set ro_16_urx  [expr $ro_16_llx + $ro_width]
set ro_16_ury  [expr $ro_16_lly + $ro_height]

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n1  \
  $ro_1_llx $ro_1_lly $ro_1_urx $ro_1_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n2  \
  $ro_2_llx $ro_2_lly $ro_2_urx $ro_2_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n3  \
  $ro_3_llx $ro_3_lly $ro_3_urx $ro_3_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n4  \
  $ro_4_llx $ro_4_lly $ro_4_urx $ro_4_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n5  \
  $ro_5_llx $ro_5_lly $ro_5_urx $ro_5_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n6  \
  $ro_6_llx $ro_6_lly $ro_6_urx $ro_6_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n7  \
  $ro_7_llx $ro_7_lly $ro_7_urx $ro_7_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n8  \
  $ro_8_llx $ro_8_lly $ro_8_urx $ro_8_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n9  \
  $ro_9_llx $ro_9_lly $ro_9_urx $ro_9_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n10 \
  $ro_10_llx $ro_10_lly $ro_10_urx $ro_10_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n11 \
  $ro_11_llx $ro_11_lly $ro_11_urx $ro_11_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n12 \
  $ro_12_llx $ro_12_lly $ro_12_urx $ro_12_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n13 \
  $ro_13_llx $ro_13_lly $ro_13_urx $ro_13_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n14 \
  $ro_14_llx $ro_14_lly $ro_14_urx $ro_14_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n15 \
  $ro_15_llx $ro_15_lly $ro_15_urx $ro_15_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n16 \
  $ro_16_llx $ro_16_lly $ro_16_urx $ro_16_ury

# Regions for all the other main blocks

set ro_yoffset 4; # Offset between top of ring oscillator to other blocks

set main_llx $ro_1_llx
set main_lly [expr $ro_1_ury + $ro_yoffset]
set main_urx [expr $core_margin_l + $core_width  - $ro_inset_x]
set main_ury [expr $core_margin_b + $core_height - $ro_inset_y]

createRegion spi_top              $main_llx $main_lly $main_urx $main_ury
createRegion pll_loop/fdc_top     $main_llx $main_lly $main_urx $main_ury
createRegion pll_loop/dlc_top     $main_llx $main_lly $main_urx $main_ury
createRegion pll_loop/dco_top     $main_llx $main_lly $main_urx $main_ury
createRegion pll_loop/timing_ctrl $main_llx $main_lly $main_urx $main_ury
createRegion pll_loop/lfsr_25b    $main_llx $main_lly $main_urx $main_ury
createRegion pll_loop/lfsr_31b    $main_llx $main_lly $main_urx $main_ury

# By default, fences are not honored by CTS or optDesign, so make sure
# that these are honored

setPlaceMode -hardFence  true
setCTSMode   -honorFence true
setOptMode   -honorFence true

