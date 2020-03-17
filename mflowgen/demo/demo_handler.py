#=========================================================================
# demo_handler.py
#=========================================================================
# Sets up the demo design and instructions to get started
#
# Author : Christopher Torng
# Date   : March 17, 2020
#

import os
import shutil

from mflowgen.utils import bold

class DemoHandler:

  def __init__( s ):
    s.demo_src_path = os.environ[ 'MFLOWGEN_HOME' ] + '/designs/GcdUnit'
    s.demo_dst_path = 'mflowgen-demo/GcdUnit'

  # Launch

  def launch( s ):

    try:
      os.makedirs( 'mflowgen-demo' )
    except OSError:
      if not os.path.isdir( 'mflowgen-demo' ):
        raise

    try:
      shutil.copytree( src      = s.demo_src_path,
                       dst      = s.demo_dst_path,
                       symlinks = False,
                       ignore_dangling_symlinks = False )
    except FileExistsError:
      pass
    except Exception as e:
      print( bold( 'Error:' ), 'Could not copy demo from install' )
      raise

    print()
    print( bold( 'Demo Circuit for mflowgen -- Greatest Common Divisor' ))
    print()
    print( 'A demo design has been provided for you in "mflowgen-demo"' )
    print( 'of a simple arithmetic circuit with some state. To get'     )
    print( 'started, run the following commands:'                       )
    print()
    print( bold( '  %' ), 'cd mflowgen-demo' )
    print( bold( '  %' ), 'mkdir build && cd build' )
    print( bold( '  %' ), 'mflowgen run --design ../GcdUnit' )
    print()
    print( bold( '  %' ), 'make list     # See all steps' )
    print( bold( '  %' ), 'make status   # See build status' )
    print()
    print( 'You can also generate a PDF of the graph with graphviz.' )
    print()
    print( bold( '  %' ), 'make graph' )
    print( '   (open graph.pdf)' )
    print()


