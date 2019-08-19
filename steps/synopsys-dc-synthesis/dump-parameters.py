# Read configure YAML and dump parameters as a shell script

import yaml

with open( 'configure.yaml', 'r' ) as fd:
  data = yaml.load( fd )

with open( 'params.sh', 'w' ) as fd:
  template_str = 'export {}={}\n'
  for k, v in data['parameters'].items():
    fd.write( template_str.format(k,v) )

