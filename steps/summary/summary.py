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

# Power -- GL

power_rpt = [ x for x in os.listdir( 'reports/synopsys-ptpx-gl' ) \
                if x.endswith( '.power.rpt' ) ][0]

with open( 'reports/synopsys-ptpx-gl/' + power_rpt, 'r' ) as fd:
  lines = fd.readlines()

power_line = [ x for x in lines if 'Total Power' in x ][0]
power_gl   = float( power_line.split()[3] )

# Energy -- GL
#
# The units are assumed here to be power (W) * delay (ns), so to put the
# energy into pJ, we divide by 1000.
#
# Note that we assume that every cycle has similar power across the entire
# workload. So the testbench should be sending in 1000s or more messages
# cycle after cycle with no bubbles. This way we can just take the average
# power over those 1000s of cycles and multiply by the cycle time to get
# the energy for one operation.

energy_gl = power_gl * delay * 1e-9 * 1e12

# Power -- RTL

power_rpt = [ x for x in os.listdir( 'reports/synopsys-ptpx-rtl' ) \
                if x.endswith( '.pwr.rpt' ) ][0]

with open( 'reports/synopsys-ptpx-rtl/' + power_rpt, 'r' ) as fd:
  lines = fd.readlines()

power_line = [ x for x in lines if 'Total Power' in x ][0]
power_rtl  = float( power_line.split()[3] )

# Energy -- RTL
#
# The units are assumed here to be power (W) * delay (ns), so to put the
# energy into pJ, we divide by 1000.
#
# Note that we assume that every cycle has similar power across the entire
# workload. So the testbench should be sending in 1000s or more messages
# cycle after cycle with no bubbles. This way we can just take the average
# power over those 1000s of cycles and multiply by the cycle time to get
# the energy for one operation.

energy_rtl = power_rtl * delay * 1e-9 * 1e12

# Gather data

data = {
  'area'       : area,
  'delay'      : delay,
  'slack'      : slack,
  'power-gl'   : power_gl,
  'energy-gl'  : energy_gl,
  'power-rtl'  : power_rtl,
  'energy-rtl' : energy_rtl,
}

with open( 'reports/summary/summary.json', 'w' ) as fd:
  json.dump( data, fd, sort_keys=True, indent=4,
    separators=(',', ': ') )

