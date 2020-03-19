#=========================================================================
# helpers.py
#=========================================================================
# Author : Christopher Torng
# Date   : June 2, 2019
#

import os
import yaml

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
  try:
    return os.environ[ 'MFLOWGEN_HOME' ]
  except KeyError:
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

#-------------------------------------------------------------------------
# YAML helper functions
#-------------------------------------------------------------------------

# read_yaml
#
# Takes a path to a yaml file and returns the data
#

def read_yaml( path ):
  with open( path ) as f:
    try:
      data = yaml.load( f, Loader=yaml.FullLoader )
    except AttributeError:
      # PyYAML for python2 does not have FullLoader
      data = yaml.load( f )
  return data

# write_yaml
#
# Takes a path to a file and dumps data
#

def write_yaml( data, path ):
  with open( path, 'w' ) as f:
    yaml.dump( data, f, default_flow_style=False )

#-------------------------------------------------------------------------
# Colors
#-------------------------------------------------------------------------

RED    = '\033[31m'
GREEN  = '\033[92m'
YELLOW = '\033[93m'
BOLD   = '\033[1m'
END    = '\033[0m'

def bold( text ):
  return BOLD + text + END

def red( text ):
  return RED + text + END

def green( text ):
  return GREEN + text + END

def yellow( text ):
  return YELLOW + text + END


