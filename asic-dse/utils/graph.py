#!/usr/bin/env python
#===============================================================================
# graph.py
#===============================================================================
# Prints an ASCII dependency graph of the asic flow steps.
#
# The graph is constructed by:
#
# 1. Read setup-flow.mk and extract "steps" and "dependencies" dictionary
# 2. Create a throwaway git repo and make commits matching the dependencies
# 3. Use "git log --graph" to print an ASCII dependency graph
#
#  -h --help     Display this message
#  -v --verbose  Verbose mode
#  -f --file     Path to "setup-flow.mk"
#
# Author : Christopher Torng
# Date   : May 6, 2018
#

import argparse
import os
import sys
import re

#-------------------------------------------------------------------------
# Command line processing
#-------------------------------------------------------------------------

class ArgumentParserWithCustomError(argparse.ArgumentParser):
  def error( self, msg = "" ):
    if ( msg ): print("\n ERROR: %s" % msg)
    print("")
    file = open( sys.argv[0] )
    for ( lineno, line ) in enumerate( file ):
      if ( line[0] != '#' ): sys.exit(msg != "")
      if ( (lineno == 2) or (lineno >= 4) ): print( line[1:].rstrip("\n") )

def parse_cmdline():
  p = ArgumentParserWithCustomError( add_help=False )
  p.add_argument( "-v", "--verbose", action="store_true"     )
  p.add_argument( "-h", "--help",    action="store_true"     )
  p.add_argument( "-f", "--file",    default="setup-flow.mk" )
  opts = p.parse_args()
  if opts.help: p.error()
  return opts

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

def main():
  opts = parse_cmdline()

  #-----------------------------------------------------------------------
  # Read setup-flow.mk and extract "steps" and "dependencies" dictionary
  #-----------------------------------------------------------------------
  # The high-level approach is to read in setup-flow.mk and modify it just
  # a bit to turn it into real Python code. Then we execute it to get the
  # variables out.

  # Read the setup-flow.mk

  with open( opts.file, 'r' ) as fd:
    text = fd.read()

  # Reflow the text to remove '\' newlines

  text = re.sub( r'\\\n', r'', text )

  # Convert text to lines

  lines = text.split('\n')
  lines = [ x + '\n' for x in lines ]

  # Replace a line with this form:
  #
  #     dependencies.dc-synthesis        = seed
  #     dependencies.innovus-flowsetup   = dc-synthesis
  #     dependencies.innovus-init        = innovus-flowsetup
  #     dependencies.innovus-place       = innovus-flowsetup innovus-init
  #
  # With this:
  #
  #     dependencies["dc-synthesis"] = "seed"
  #     dependencies["innovus-flowsetup"] = "dc-synthesis"
  #     dependencies["innovus-init"] = "innovus-flowsetup"
  #     dependencies["innovus-place"] = "innovus-flowsetup innovus-init"

  lines = [ re.sub( r'(?<=dependencies)\.(\S*)\s*=\s*(.*)$',
                    r'["\1"] = "\2"',
                    x ) for x in lines ]

  # Replace a line with this form:
  #
  #     steps = foo   bar baz
  #
  # With this:
  #
  #     steps = "foo   bar baz"
  #

  lines = [ re.sub( r'(?<=steps)\s*=\s*(.*)$',
                    r' = "\1"',
                    x ) for x in lines ]

  # Execute the text as python code

  dependencies = {}

  exec( "".join(lines) )

  # We should now have a "steps" string and a "dependencies" dictionary

  assert steps != ""
  assert bool(dependencies)

  # Format these a bit
  #
  # - steps        (string)                -> (list)
  # - dependencies (dictionary of strings) -> (dictionary of lists)

  steps = steps.split()

  for k, v in dependencies.iteritems():
    dependencies[k] = v.split()

  # Remove 'seed' step if it exists

  if 'seed' in steps:
    steps.remove( 'seed' )

  # Remove any steps with no dependencies

  steps = [ x for x in steps if x in dependencies ]

  #-----------------------------------------------------------------------
  # Create a throwaway git repo and make commits matching the dependencies
  #-----------------------------------------------------------------------

  # Throwaway git repo

  os.system( 'rm -rf .graph' )
  os.mkdir( '.graph' )
  os.chdir( '.graph' )

  os.system( 'git init . > /dev/null 2>&1' )

  # Make a commit for the seed

  os.system( 'git commit --allow-empty -m "seed" > /dev/null 2>&1' )
  os.system( 'git branch seed > /dev/null 2>&1'                    )

  graph = [ 'seed' ]

  # Make commits matching the dependencies
  #
  # The approach is to build the dependency graph one node at a time,
  # starting with the "seed" step node. As we add each new node to the
  # graph, we create a git branch and commit for that step to match the
  # graph. If the new node has more than one parent, we do a git merge in
  # order to draw multiple edges to properly match the graph.
  #
  # When we have popped all nodes from "steps" and placed them into the
  # graph (i.e., added to the "graph" list), we are done.

  # Iterate over steps until all steps are added to the graph

  i = 0

  while steps:

    # Consider adding this step to the graph

    new_node = steps[i]

    # Check each node currently in the graph to see if this new node
    # should attach to it

    for node in graph:

      # We will only add the new node to the graph if:
      #
      # 1. The new node is a child of a node already in the graph
      # 2. All of the new node's dependencies exist in the graph

      new_node_is_child_of_graph     = node in dependencies[new_node]
      new_node_deps_are_all_in_graph = \
          all([ True if x in graph else False for x in dependencies[new_node] ])

      if new_node_is_child_of_graph and new_node_deps_are_all_in_graph:

        # Add this new node to the graph. Make a git branch to match the
        # state of the graph.

        os.system( 'git checkout '    + node     + ' > /dev/null 2>&1' )
        os.system( 'git checkout -b ' + new_node + ' > /dev/null 2>&1' )

        # If this new node connects to the graph with a single edge, just
        # make a git commit and we are done.

        if len( dependencies[new_node] ) == 1:
          os.system( 'git commit --allow-empty -m "' + new_node + '" > /dev/null 2>&1' )

        # To draw multiple edges, we need to do a git merge that merges
        # together all of the new node's dependencies.

        else:
          os.system( 'git merge --no-ff ' +
                     ' '.join(dependencies[new_node]) +
                     ' -m "' + new_node + '" > /dev/null 2>&1' )

        # Book-keeping

        graph.append( new_node )
        steps.remove( new_node )

        break

    # Keep iterating over remaining steps

    if steps: i = ( i + 1 ) % len( steps )

  #-----------------------------------------------------------------------
  # Use "git log --graph" to print a pretty ASCII dependency graph
  #-----------------------------------------------------------------------

  git_log_cmd  = ' '.join([ "git log",
                            "--oneline",
                            "--pretty='tformat:%s'",
                            "--graph",
                            "--decorate",
                            "--all",
                            "--color",
                            "| tac | tr '/\\\\' '\\\\/'" ])

  os.system( git_log_cmd )

main()
