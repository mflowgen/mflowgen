#! /usr/bin/env python
#=========================================================================
# summary
#=========================================================================

import gzip
import json
import os

# Area

with open( 'reports/innovus/signoff.area.rpt', 'r' ) as fd:
  lines = fd.readlines()

area = float( lines[2].split()[3] )

# Timing

with gzip.open( 'reports/innovus/signoff_all.tarpt.gz', 'rb' ) as fd:
  lines = fd.readlines()

delay_line = [ x for x in lines if 'Phase Shift' in x ][0]
delay      = float( delay_line.split()[3] )

slack_line = [ x for x in lines if 'Slack Time' in x ][0]
slack      = float( slack_line.split()[3] )

# Power

power_rpt = [ x for x in os.listdir( 'reports/synopsys-ptpx-gl' ) \
                if x.endswith( '.power.rpt' ) ][0]

with open( 'reports/synopsys-ptpx-gl/' + power_rpt, 'r' ) as fd:
  lines = fd.readlines()

power_line = [ x for x in lines if 'Total Power' in x ][0]
power      = float( power_line.split()[3] )

# Energy
#
# The units are assumed here to be power (W) * delay (ns), so to put the
# energy into pJ, we divide by 1000.
#
# Note that we assume that every cycle has similar power across the entire
# workload. So the testbench should be sending in 1000s or more messages
# cycle after cycle with no bubbles. This way we can just take the average
# power over those 1000s of cycles and multiply by the cycle time to get
# the energy for one operation.

energy = power * delay * 1e-9 * 1e12

# Gather data

data = {
  'area'   : area,
  'power'  : power,
  'energy' : energy,
  'delay'  : delay,
  'slack'  : slack,
}

with open( 'reports/summary/summary.json', 'w' ) as fd:
  json.dump( data, fd, sort_keys=True, indent=4,
    separators=(',', ': ') )

