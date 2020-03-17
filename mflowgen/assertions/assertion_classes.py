#=========================================================================
# assertion_classes.py
#=========================================================================
# Classes to enable concise syntax for assertions
#
# Author : Christopher Torng
# Date   : March 12, 2020
#

#-------------------------------------------------------------------------
# File
#-------------------------------------------------------------------------
# A class that supports clean assertions for files.
#
# Properties about a File can be asserted like this:
#
#     >>> assert File('inputs/foo.txt')  # assert that this file exists
#     >>> assert 'error' not in File('inputs/foo.txt')  # check for errors
#

import os
import re

class File:

  def __init__( s, path, enable_case_sensitive=False, enable_regex=False ):
    s.path                  = path
    s.text                  = None
    s.lines                 = None
    s.enable_case_sensitive = enable_case_sensitive
    s.enable_regex          = enable_regex
    if enable_regex:
      assert not enable_case_sensitive, \
        'Cannot set "enable_regex" and "enable_case_sensitive" at once!'

  # __bool__
  #
  # Allow to assert like this:
  #
  #     >>> assert     File( 'foo.txt' )   # file exists
  #     >>> assert not File( 'bar.txt' )   # file does not exist
  #

  def __bool__( s ):
    return os.path.exists( s.path )

  # __contains__
  #
  # Allow to assert like this:
  #
  #     >>> assert 'something' in File( 'foo.txt' )
  #

  def __contains__( s, pattern ):
    # Lazy-read the file text
    if not s.text:
      with open( s.path ) as fd:
        s.text = fd.read()
    # Search for the pattern in the file
    if s.enable_regex:
      found = re.search( pattern, s.text )
    else:
      if s.enable_case_sensitive:
        found = pattern in s.text
      else:
        found = pattern.lower() in s.text.lower()
    return found

  # __iter__
  #
  # Allow to assert like this:
  #
  #     >>> for line in File( 'foo.txt' ):
  #     ...   ( ... check something about each line ... )
  #

  def __iter__( s ):
    # Lazy-read the file lines
    if not s.lines:
      with open( s.path ) as fd:
        s.lines = fd.readlines()
    # Yield line by line
    yield from s.lines

  # __str__

  def __str__( s ):
    return 'File( \'{}\' )'.format( s.path )

  # __repr__

  def __repr__( s ):
    return 'File( \'{}\' )'.format( s.path )


#-------------------------------------------------------------------------
# Tool
#-------------------------------------------------------------------------
# A class that supports clean assertions for tools.
#
# Properties about a Tool can be asserted like this:
#
#     >>> assert Tool( 'dc_shell' )  # assert that this tool exists
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




