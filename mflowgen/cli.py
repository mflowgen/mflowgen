#=========================================================================
# mflowgen
#=========================================================================
#
#  -h --help     Display this message
#  -v --version  Version info
#
# mflowgen run (Run-related options)
#
#     --demo            --  Generate a demo design
#     --design   string --  Path to design directory with build graph
#     --update          --  Re-read the graph and update the build
#     --backend  string --  Backend build system: make, ninja
#
# mflowgen stash (Stash-related options)
#
#  -p --path     string --  Path for stash init, stash link
#  -s --step     int    --  Step number for stash push
#  -m --msg      string --  Push message for stash push
#     --hash     string --  Hash for stash pull, stash pop, stash drop
#     --all
#     --verbose
#
# mflowgen mock (Mock-related options)
#
#  -p --path     string --  Path to step directory
#

#
# Author : Christopher Torng
# Date   : March 16, 2020
#

import argparse
import os
import sys

from mflowgen           import __version__
from mflowgen.demo      import DemoHandler
from mflowgen.core      import RunHandler
from mflowgen.stash     import StashHandler
from mflowgen.mock      import MockHandler

# Path hack for now to find steps and adks

os.environ[ 'MFLOWGEN_HOME' ] = \
  os.path.abspath( os.path.dirname( os.path.dirname( __file__ ) ) )

#-------------------------------------------------------------------------
# Command line processing
#-------------------------------------------------------------------------

class ArgumentParserWithCustomError(argparse.ArgumentParser):
  def error( self, msg = "" ):
    if ( msg ): print("\n ERROR: %s" % msg)
    print("")
    file = open( __file__ )
    for ( lineno, line ) in enumerate( file ):
      if ( line[0] != '#' ): sys.exit(msg != "")
      if ( (lineno == 1) or (lineno >= 3) ): print( line[1:].rstrip("\n") )

def parse_cmdline():
  p = ArgumentParserWithCustomError( add_help=False )
  p.add_argument( "-v", "--version", action="store_true"          )
  p.add_argument( "-h", "--help",    action="store_true"          )

  # Run-related arguments
  p.add_argument(       "--demo",    action="store_true"          )
  p.add_argument(       "--design"                                )
  p.add_argument(       "--update",  action="store_true"          )
  p.add_argument(       "--backend", default="make",
                                     choices=("make", "ninja")    )

  # Stash-related arguments
  p.add_argument(       "args", type=str, nargs='*' ) # positional
  p.add_argument( "-p", "--path"                                  )
  p.add_argument( "-s", "--step", type=int                        )
  p.add_argument( "-m", "--msg"                                   )
  p.add_argument(       "--hash"                                  )
  p.add_argument(       "--all",     action="store_true"          )
  p.add_argument(       "--verbose", action="store_true"          )
  opts = p.parse_args()
  if opts.help and not opts.args: p.error() # print help only if not stash
  return opts

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

def main():

  opts = parse_cmdline()

  # Version

  if opts.version:
    print( __version__ )
    return

  # Create a demo if the option was given

  if opts.demo:
    dhandler = DemoHandler()
    dhandler.launch()
    return

  # Dispatch to StashHandler if positional arguments for stash are given

  if opts.args and opts.args[0] == 'stash':
    shandler = StashHandler()
    shandler.launch(
      args    = opts.args[1:],
      help_   = opts.help,
      path    = opts.path,
      step    = opts.step,
      msg     = opts.msg,
      hash_   = opts.hash,
      all_    = opts.all,
      verbose = opts.verbose,
    )
    return

  # Dispatch to MockHandler

  if opts.args and opts.args[0] == 'mock':
    mhandler = MockHandler()
    mhandler.launch(
      args  = opts.args[1:],
      help_ = opts.help,
      path  = opts.path,
    )
    return

  # Dispatch to RunHandler

  legacy = \
    True if os.path.basename( sys.argv[0] ) == 'configure' else False

  if legacy or opts.args and opts.args[0] == 'run':
    rhandler = RunHandler()
    rhandler.launch(
      help_   = opts.help,
      design  = opts.design,
      update  = opts.update,
      backend = opts.backend,
    )
    return

  # Need arguments

  ArgumentParserWithCustomError().error(
    'Command can be "mflowgen run" or "mflowgen stash" or "mflowgen mock"'
  )


