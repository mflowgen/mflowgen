#=========================================================================
# setup-timing.tcl
#=========================================================================
# Description
#
# Author : Christopher Torng
# Date   : January 30, 2020

# Set up typical delay corner (typical captable, typical cell libs) and
# read constraints
#
# - RC corner     -> models the delay due to interconnect parasitics
# - library set   -> models the delay at standard cell input/output pins
# - delay corner  -> this is a pair of (rc_corner, library set)
# - constraints   -> this is the SDC from synthesis
# - analysis_view -> this is a pair of (delay_corner, constraints)

create_rc_corner -name typical \
   -cap_table inputs/adk/rtk-typical.captable \
   -T 25

create_library_set -name libs_typical \
   -timing [list inputs/adk/stdcells.lib]

create_delay_corner -name delay_default \
   -early_library_set libs_typical \
   -late_library_set libs_typical \
   -rc_corner typical

create_constraint_mode -name constraints_default \
   -sdc_files [list inputs/design.sdc]

create_analysis_view -name analysis_default \
   -constraint_mode constraints_default \
   -delay_corner delay_default

set_analysis_view -setup [list analysis_default] -hold [list analysis_default]


