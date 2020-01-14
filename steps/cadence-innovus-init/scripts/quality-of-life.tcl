#=========================================================================
# quality-of-life.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : January 13, 2020

#-------------------------------------------------------------------------
# Quality of life settings
#-------------------------------------------------------------------------

# When reporting timing
#
# - Accept clocks in -to and -from
# - Enable using clocks in -to and -from

set timing_report_enable_clock_object_in_from_to true

set report_timing_format \
  "instance arc cell transition delay arrival required"

# Do not compress timing reports that dump from timeDesign and optDesign
# (basically do not create any *.tarpt.gz files)

setOptMode -timeDesignCompressReports false


