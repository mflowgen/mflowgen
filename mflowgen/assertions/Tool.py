#=========================================================================
# Tool
#=========================================================================
# A class that supports clean assertions for tools.
#
# Properties about a Tool can be asserted like this:
#
#     >>> assert Tool( 'dc_shell' )  # assert that this tool exists
#
# Author : Christopher Torng
# Date   : March 12, 2020
#

import shutil

class Tool:

  def __init__( s, tool ):
    s.tool = tool

  # __bool__
  #
  # Allow to assert like this:
  #
  #     >>> assert     Tool( 'dc_shell' )   # tool exists
  #     >>> assert not Tool( 'dc_shell' )   # tool does not exist
  #

  def __bool__( s ):
    if shutil.which( s.tool ):
      return True
    else:
      return False

  # __str__

  def __str__( s ):
    return 'Tool( \'{}\' )'.format( s.tool )

  # __repr__

  def __repr__( s ):
    return 'Tool( \'{}\' )'.format( s.tool )



