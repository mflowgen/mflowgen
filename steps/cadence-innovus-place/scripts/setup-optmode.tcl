#=========================================================================
# setup-optmode.tcl
#=========================================================================
# Useful knobs for setOptMode
#
# Author : Christopher Torng
# Date   : May 15, 2020

# Useful skew
#
# setOptMode -usefulSkew [ true | false ]
#
# - This enables/disables all other -usefulSkew* options (e.g.,
#   -usefulSkewCCOpt, -usefulSkewPostRoute, and -usefulSkewPreCTS)
#
# setOptMode -usefulSkewPreCTS [ true | false ]
#
# - If setOptMode -usefulSkew is false, then this entire option is ignored
#

puts "Info: Useful skew = $::env(useful_skew)"

if { $::env(useful_skew) } {
  setOptMode -usefulSkew       true
  setOptMode -usefulSkewPreCTS true
} else {
  setOptMode -usefulSkew      false
}


