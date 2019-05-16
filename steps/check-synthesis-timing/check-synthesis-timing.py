#! /usr/bin/env python
#=========================================================================
# check-synthesis-timing
#=========================================================================
# Reads the synthesis QoR report to see if this run failed timing or not
#
# Synthesis is zero-load timing. If we fail timing by too much here, then
# we have no chance of meeting timing in PnR, and we waste time trying.
#
# Author : Christopher Torng
# Date   : May 15, 2019
#

import os
import re

# If we have less than this threshold, then we count timing as failed

threshold_slack = -0.100

# Read the synthesis QoR report

reports_dir = 'reports/dc-synthesis'
qor_file    = [ x for x in os.listdir( reports_dir ) if 'qor' in x ][0]

with open( reports_dir + '/' + qor_file, 'r' ) as fd:
  lines = fd.readlines()
  lines = [ x.strip() for x in lines ]

# Grab the slack values for the critical paths in each path group

slack_lines  = [ x for x in lines if 'Critical Path Slack' in x ]
slack_values = [ float(x.split()[-1]) for x in slack_lines ]

# An array of booleans, did we fail timing in any path group?

failed_timing = [ x < threshold_slack for x in slack_values ]

# Print if any failed

if any( failed_timing ):
  print '  [failed]'
else:
  print '  [passed]'


