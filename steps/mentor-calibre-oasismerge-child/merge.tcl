#=========================================================================
# merge.tcl
#=========================================================================
# Merge so that oas0 has oas1 as a child cell and instantiates that cell
# at the given coordinate.
#
# Author : Christopher Torng
# Date   : May 25, 2020

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

set oas0    $env(design_oas)
set oas1    $env(child_oas)
set oasout  design_merged.oas

set coord_x $env(coord_x)
set coord_y $env(coord_y)

#-------------------------------------------------------------------------
# Checks
#-------------------------------------------------------------------------
# Check for name conflicts that have to be resolved

puts "> Checking for conflicts between $oas0 and $oas1"
layout filemerge -mode reportconflictsonly -in $oas0 -in $oas1

#-------------------------------------------------------------------------
# Merge
#-------------------------------------------------------------------------
# See "Batch Commands for Layout Manipulation" in calbr_drv_ref.pdf
#

puts "> Reading $oas0"
set L0 [ layout create $oas0 \
                -dt_expand \
                -preservePaths \
                -preserveProperties ]

puts "> Reading $oas1"
set L1 [ layout create $oas1 \
                -dt_expand \
                -preservePaths \
                -preserveProperties ]

# Import oas1 into oas0 as a child cell

puts "> Importing $L1 ($oas1) into $L0 ($oas0) in memory"
$L0 import layout $L1 FALSE append

# Create a reference in oas0's topcell which points to the new child cell

set L0_topcell [ $L0 topcell ]
set L1_topcell [ $L1 topcell ]
puts "> Creating reference for $L1_topcell in $L0_topcell at xy ($coord_x, $coord_y)"
$L0 create ref $L0_topcell $L1_topcell $coord_x $coord_y 0 0 1.0

# Flatten the child cell

puts "Info: Flatten child = $::env(flatten_child)"

if { $::env(flatten_child) } {
  $L0 flatten ref $L0_topcell $L1_topcell $coord_x $coord_y 0 0 1.0
}

# Stream out oas0

puts "> Streaming out $oasout"
$L0 oasisout $oasout $L0_topcell


