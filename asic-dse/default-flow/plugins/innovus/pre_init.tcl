#=========================================================================
# pre_init.tcl
#=========================================================================
# This plug-in script is called before the corresponding Innovus flow step
#
# Author : Christopher Torng
# Date   : March 26, 2018

# Quality-of-life variables for reporting timing
#
# - Accept clocks in -to and -from
# - Enable using clocks in -to and -from

set timing_report_enable_clock_object_in_from_to true

set report_timing_format \
  "instance arc cell transition delay arrival required"

