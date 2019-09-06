# Read configure YAML and dump parameters as a shell script

import yaml

with open( 'configure.yaml', 'r' ) as fd:
  try:
    data = yaml.load( fd, Loader=yaml.FullLoader )
  except AttributeError:
    # PyYAML for python2 does not have FullLoader
    data = yaml.load( fd )

with open( 'params.sh', 'w' ) as fd:
  template_str = 'export {}={}\n'
  for k, v in data['parameters'].items():
    fd.write( template_str.format(k,v) )

