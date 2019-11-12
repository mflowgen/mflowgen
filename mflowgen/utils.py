#! /usr/bin/env python
#=========================================================================
# utils.py
#=========================================================================
#
# Author : Christopher Torng
# Date   : June 2, 2019
#

import os

#-------------------------------------------------------------------------
# Utility functions
#-------------------------------------------------------------------------

# get_top_dir
#
# Returns the path to the top directory containing the flag
#
# - flag     : a filename that marks the top of the tree
# - relative : boolean, return relative path to current working directory
#

def get_top_dir( flag='.MFLOWGEN_TOP', relative=True ):
  tmp = os.getcwd()
  while tmp != '/':
    tmp = os.path.dirname( tmp )
    if flag in os.listdir( tmp ):
      break

  if not relative:
    return tmp
  else:
    return os.path.relpath( tmp, os.getcwd() )

# get_files_in_dir
#
# Returns a list of all files in the directory tree
#
# - p : path to a directory
#

def get_files_in_dir( p ):
  file_list = []
  for root, subfolders, files in os.walk( p ):
    for f in files:
      file_list.append( os.path.join( root, f ) )
  return file_list

# stamp
#
# Returns a path with the basename prefixed with '.stamp.'
#
# - p : path to a file or directory
#

def stamp( p, stamp='.stamp.' ):
  p_dirname  = os.path.dirname( p )
  p_basename = os.path.basename( p )
  p_stamp    = stamp + p_basename
  if p_dirname : return p_dirname + '/' + p_stamp
  else         : return p_stamp


