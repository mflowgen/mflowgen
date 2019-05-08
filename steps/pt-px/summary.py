import json

with open('reports/innovus/signoff.area.rpt', 'r') as fd:
  lines = fd.readlines()
area = lines[2].split()[3]

with open('reports/pt-px/signoff.pwr.rpt', 'r') as fd:
  lines = fd.readlines()
power = lines[30].split()[3]
    
data = { 'Area': area , 'Power': power}
    
with open( 'reports/pt-px/summary.json', 'w' ) as fd:
  json.dump( data, fd, sort_keys=True, indent=4,
    separators=(',', ': ') )

