#=========================================================================
# check_handler.py
#=========================================================================
# Handler for check-related commands
#
# Author : Christopher Torng
# Date   : September 13, 2021
#

import os
import re
import subprocess
import sys

from mflowgen.utils import bold, yellow
from mflowgen.utils import read_yaml, write_yaml
from mflowgen.utils import get_top_dir

#-------------------------------------------------------------------------
# Check Management
#-------------------------------------------------------------------------

class CheckHandler:

  def __init__( s ):

    # Valid commands

    s.commands = [
      'graph',
      'here',
      'list',
      'status',
      'help',
      'enum'
    ]

  #-----------------------------------------------------------------------
  # helpers
  #-----------------------------------------------------------------------

  def execute_tcl_snippet( s, snippet ):

    # Execute the implementation code
    #
    # Hacks starting here
    # emit the impl body into a new script

    def get_shell_output( cmd ):
      try:
        output = subprocess.check_output( cmd.split(),
                                          stderr=subprocess.DEVNULL,
                                          universal_newlines=True )
        output = output.strip()
      except Exception:
        output = ''
      return output

    with open('/tmp/mflowgen-impl.tcl','w') as fd:
      x = snippet.replace('return', 'puts')
      fd.write( x )

    out = get_shell_output( 'tclsh /tmp/mflowgen-impl.tcl' )

    #print(out)

    # Check the output against each property
    #
    # Hacks again
    # the output must be space delimited
    # the expression uses a, b, c, d, etc

    _ = out.split()

    try:
      a = _[0]
    except Exception:
      a = None
    try:
      b = _[1]
    except Exception:
      b = None
    try:
      c = _[2]
    except Exception:
      c = None
    try:
      d = _[3]
    except Exception:
      d = None
    try:
      e = _[4]
    except Exception:
      e = None
    try:
      f = _[5]
    except Exception:
      f = None
    try:
      g = _[6]
    except Exception:
      g = None
    try:
      h = _[7]
    except Exception:
      h = None
    try:
      i = _[8]
    except Exception:
      i = None
    try:
      j = _[9]
    except Exception:
      j = None

    return out, a, b, c, d, e, f, g, h, i, j

  #-----------------------------------------------------------------------
  # launch
  #-----------------------------------------------------------------------
  # Dispatch function for commands
  #

  def launch( s, args, help_, step, verbose ):

    if help_ and not args:
      s.launch_help()
      return

    try:
      command = args[0]
      assert command in s.commands # valid commands only
    except Exception as e:
      print( 'check: Unrecognized commands (see "mflowgen check help")' )
      sys.exit( 1 )

    try:
      assert len( args ) <= 1 # no further positional args are allowed
    except Exception as e:
      print()
      print( 'check: Unrecognized positional args' )
      # Allow this exception to pass, but force set the "help" flag so
      # users can see what they should be doing instead.
      help_ = True

    if   command == 'graph'  : s.launch_graph ( help_, verbose )
    elif command == 'here'   : s.launch_here  ( help_, verbose )
    elif command == 'list'   : s.launch_list  ( help_, verbose, step )
    elif command == 'status' : s.launch_status( help_, verbose, step )
    elif command == 'enum'   : s.launch_enum  ( help_, verbose )
    else                     : s.launch_help  ()

  #-----------------------------------------------------------------------
  # get_all_mflowgen_procs
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Loop over all nodes in the graph
  # - Make a list of all node source directories
  # - Make a list of all tcl files in those directories
  # - Search tcl files for "proc mflowgen." and return a dict of name-body
  #   pairs (i.e., key = <file>:<procname>, value = <procbody>)
    
  def get_all_mflowgen_procs( s ):
    
    # Get all existing steps
    #
    # Currently this is done by just looking at the directory names in the
    # hidden mflowgen metadata directory, which has all the build
    # directories for the current configuration.
    #

    build_path = get_top_dir( flag='.mflowgen', relative=False )

    if build_path == '/':
      print( bold( 'Error:' ), 'Not currently within an mflowgen build' )
      sys.exit(1)

    metadata_path = build_path + '/.mflowgen'

    print( bold( 'Checking build:' ), build_path )

    existing_steps = [ _ for _ in os.listdir( metadata_path )
                           if os.path.isdir( metadata_path + '/' + _ ) ]
    existing_steps = sorted( existing_steps,
                             key = lambda x: int(x.split('-')[0] ) )

    # Get the source directory for each step from its configuration.yml

    src_dirs = {}

    for step_name in existing_steps:
      try:
        data = \
          read_yaml( metadata_path + '/' + step_name + '/configure.yml' )
      except Exception:
        print( bold( 'Error:' ), 'The mflowgen build is corrupted' )
        raise
      step = step_name.split('-')[0]
      src_dirs[step] = data['source']

    # Gather all tcl files for each step

    tcl_files = {}

    for step, src_dir in src_dirs.items():
      tcl_files[step] = set()
      for root, dirs, files in os.walk( src_dir ):
        for f in files:
          if f.endswith( '.tcl' ):
            tcl_files[step].add( root + '/' + f )

    #for k, v in tcl_files.items():
    #  print( k, v )
    
    # Search tcl files for mflowgen-annotated procs (proc mflowgen.*), and
    # return the result as a dict (i.e., key = "<file>:<procname>", value =
    # "<procbody>")

    # FIXME -- the mflowgen annotations have to be perfectly formed for
    # now ... specifically, the proc body must begin with a '{\n' and end
    # with a '\n}' to be collected. That is because we are using simple
    # regex here and not a tcl parser.

    procs = {}

    for step, files in tcl_files.items():
      procs[step] = {}
      for f in files:
        with open( f ) as fd:
          text = fd.read()
        matches = re.findall( r'proc *(mflowgen.*?) *{(.*?)} *{\n(.*?)\n}', text, re.DOTALL )
        for m in matches:
          k = f + ':' + m[0]
          v = ( m[1], m[2] )
          procs[step][k] = v

    return procs

  #-----------------------------------------------------------------------
  # launch_graph
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - From this dict, make a list of intent-implementation pairs
  #
  # - For each intent-implementation pair, parse the properties, run the
  #   implementation code, and pass the outputs through each property
  #

  def launch_graph( s, help_, verbose ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen check graph [--verbose]' )
      print()
      print( 'Inspects all nodes in the graph for tcl files with' )
      print( 'intent-property-implementation constructs and'      )
      print( 'statically checks the design intent properties.'    )
      print()

    if help_:
      print_help()
      return

    procs = s.get_all_mflowgen_procs()

    #for step in procs.keys():
    #  for k, v in procs[step].items():
    #    print( k )
    #    print( v )
    #    print()

    # Make a list of intent-implementation pairs
    #
    # We do this by grabbing the intent, substituting implementation, and
    # then getting the loop body.
    #

    check_bundles = {}

    for step, block in procs.items():
      intents    = [ k for k in procs[step].keys() if '.intent.' in k ]
      implements = [ k.replace('.intent','.implement') for k in intents ]
      check_bundles[step] = [ { 'intent'    : procs[step][x],
                                'implement' : procs[step][y] }
                                for x, y in zip( intents, implements ) ]

    #for step in check_bundles.keys():
    #  for bundle in check_bundles[step]:
    #    for k, v in bundle.items():
    #      print( k )
    #      print( v )
    #      print()

    # For each intent-implementation pair, parse the properties, run the
    # implementation code, and pass the outputs through each property

    for step in check_bundles.keys():
      for bundle in check_bundles[step]:
        intent    = bundle['intent']
        implement = bundle['implement']

        intent_args = intent[0]
        intent_body = intent[1]

        # Grab the properties

        properties = []

        matches = re.findall( r'array *set *(mflowgen.*?) *{.*?property *\"(.*?)\".*?describe *\"(.*?)\".*?}', intent_body, re.DOTALL )
        for m in matches:
          p = {}
          p['name']     = m[0]
          p['property'] = m[1]
          p['describe'] = m[2]
          properties.append( p )

        # Execute the implementation code

        out, a, b, c, d, e, f, g, h, i, j = s.execute_tcl_snippet( implement[1] )

        #print( out, a, b, c, d, e, f, g, h, i, j )

        for p in properties:
          print( 'Checking property:', p['name'] )
          print( '  - Expression:', p['property'] )
          print( '  - Output:', out )
          print( '  - Outcome: ... ', end='' )

          result = eval( p['property'] )
          print( result )
          print()

    # Handle distributed block checks
    #
    # LIMITATION -- you cannot have a distributed block check within the
    # same file ... the filename:procname is the dict key right now, so
    # they will alias if you put more than one in the same tcl file
    #

    check_distributed_bundles = {}

    for step, block in procs.items():
      d_keys  = [ k for k in procs[step].keys() if '.distributed.' in k ]
      d_names = [ re.search( r'(mflowgen\.distributed\..*?)$', k )
                   for k in d_keys ]
      d_names = [ _.group(1) for _ in d_names if _ ]
      for name, key in zip( d_names, d_keys ):
        try:
          check_distributed_bundles[name]
        except KeyError:
          check_distributed_bundles[name] = []
        check_distributed_bundles[name].append( procs[step][key] )

    #for k, v in check_distributed_bundles.items():
    #  print( k )
    #  print( v )
    #  print()

    # Execute the snippets in each distributed bundle and make sure the
    # outputs match

    results = {}

    for name, proc_list in check_distributed_bundles.items():
      for idx, p in enumerate( proc_list ):
        out, a, b, c, d, e, f, g, h, i, j = s.execute_tcl_snippet( p[1] )
        result = [ a, b, c, d, e, f, g, h, i, j ]
        # track outputs and compare new results to others
        try:
          results[name]
        except KeyError:
          results[name] = result
        #print( name, out, a, b, c, d, e, f, g, h, i, j )

        equality_property = results[name] == result

        print( 'Checking property:', name )
        print( '  - Block #:', idx )
        print( '  - Expression:', '(distributed equality)' )
        print( '  - Output:', out )
        print( '  - Outcome: ... ', end='' )

        print( equality_property )
        print()
  
  #-----------------------------------------------------------------------
  # launch_enum
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  # 
  # -x
  #

  def launch_enum( s, help_, verbose ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen check enum [--verbose]' )
      print()
      print( 'Inspects all nodes in the graph for tcl files with' )
      print( 'enum constructs and statically checks enum'         )
      print( 'properties.'                                        )
      print()

    if help_:
      print_help()
      return

    procs = s.get_all_mflowgen_procs()

    #for step in procs.keys():
    #  for k, v in procs[step].items():
    #    print( k )
    #    print( v )
    #    print()

    for step, block in procs.items():
      enums = [ k for k in procs[step].keys() if '.enum.' in k ]

    print("Check enum not implemented yet")

     

  #-----------------------------------------------------------------------
  # launch_here
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - x
  #

  def launch_here( s, help_, verbose ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen check here [--verbose]'   )
      print()
      print( 'Inspects the current directory for tcl files with'   )
      print( 'intent-property-implementation constructs and'       )
      print( 'statically checks the design intent properties.'     )
      print( 'This is a simple check without technology/design'    )
      print( 'information, restricting the flexibility.'           )
      print()

    if help_:
      print_help()
      return


  #-----------------------------------------------------------------------
  # launch_list
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - x
  #

  def launch_list( s, help_, verbose, step ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen check list',
                                  '[--step <int>]', '[--verbose]'    )
      print()
      print( 'Lists all design intent blocks and their properties.'  )
      print( 'The --step flag restricts the scope to the step, and'  )
      print( 'the --verbose flag lists property check expressions.'  )
      print()

    if help_:
      print_help()
      return

  #-----------------------------------------------------------------------
  # launch_status
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - x
  #

  def launch_status( s, help_, verbose, step ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen check status',
                                  '[--step <int>]', '[--verbose]'     )
      print()
      print( 'Lists all design intent blocks and the status of their' )
      print( 'property checks. The --step flag restricts the scope'   )
      print( 'to the step, and the --verbose flag lists property'     )
      print( 'check expressions in addition to the status.'           )
      print()

    if help_:
      print_help()
      return

  #-----------------------------------------------------------------------
  # launch_help
  #-----------------------------------------------------------------------

  def launch_help( s ):
    print()
    print( bold( 'Check Commands' ) )
    print()
    print( bold( ' - graph  :' ), 'Check design intent properties in the graph' )
    print( bold( ' - enum   :' ), 'Check enum properties in the graph' )
    print( bold( ' - here   :' ), 'Run a simple check in the current directory' )
    print()
    print( bold( ' - list   :' ), 'List all design intent properties in the graph' )
    print( bold( ' - status :' ), 'List the status of all design intent properties' )
    print()
    print( 'Run any command with -h to see more details'                 )
    print()

