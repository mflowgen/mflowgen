#! /usr/bin/env python
#=========================================================================
# check-pnr-timing
#=========================================================================
# Reads the PnR timing report to see if this run failed timing or not
#
# Author : Christopher Torng
# Date   : May 20, 2019
#

import gzip

# If we have less than this threshold, then we count timing as failed

threshold_slack = -0.010

# Read the timing report

with gzip.open( 'reports/innovus/signoff_all.tarpt.gz', 'rb' ) as fd:
  lines = fd.readlines()

slack_line = [ x for x in lines if 'Slack Time' in x ][0]
slack      = float( slack_line.split()[3] )

# An array of booleans, did we fail timing in any path group?

failed_timing = slack < threshold_slack

# Print if any failed

if failed_timing:
  print '  [failed]'
else:
  print '  [passed] -- with', slack, 'slack',
  print '( threshold: ', threshold_slack, ')'


