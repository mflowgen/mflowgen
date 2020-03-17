#=========================================================================
# ninja_syntax_extra.py
#=========================================================================
#
# Author : Christopher Torng
# Date   : June 2, 2019
#

import os

from mflowgen.utils         import get_top_dir
from mflowgen.utils.helpers import stamp

#-------------------------------------------------------------------------
# Extra ninja helper functions
#-------------------------------------------------------------------------

# ninja_cpdir
#
# Copies a directory and handles stamping
#
# - w       : instance of ninja_syntax Writer
# - dst     : path to copied directory
# - src     : path to source directory
# - deps    : list, additional dependencies for ninja build
# - sandbox : bool, True (copies src dir), False (symlinks src contents)
#

def ninja_cpdir( w, dst, src, deps=None, sandbox=True ):

  if deps:
    assert type( deps ) == list, 'Expecting deps to be of type list'

  if sandbox:
    rule = 'cpdir-and-parameterize'
  else:
    rule = 'mkdir-and-symlink'

  target = dst + '/.stamp'

  w.build(
    outputs   = target,
    #implicit  = [ src ] + deps,
    implicit  = deps,
    rule      = rule,
    variables = { 'dst'   : dst,
                  'src'   : src,
                  'stamp' : target },
  )

  return target

# ninja_symlink
#
# Symlinks src to dst while handling stamping
#
# - w    : instance of ninja_syntax Writer
# - dst  : path to linked file/directory
# - src  : path to source file/directory
# - deps : additional dependencies for ninja build
# - src_is_symlink : boolean, flag if source is a symlink (and has stamp)
#

def ninja_symlink( w, dst, src, deps=None, src_is_symlink=False ):

  if deps:
    assert type( deps ) == list, 'Expecting deps to be of type list'

  # Stamp files

  dst_dir   = os.path.dirname( dst )
  dst_base  = os.path.basename( dst )
  dst_stamp = stamp( dst )

  # Relative paths for symlinking after changing directories

  src_relative = os.path.relpath( src, dst_dir )
  dst_relative = dst_base
  dst_stamp_relative = os.path.basename( dst_stamp )

  # Depend on src stamp if src is also a symlink

  if src_is_symlink:
    src_stamp = stamp( src )
    inputs    = src_stamp
  else:
    inputs    = src

  # Ninja

  target = dst_stamp

  w.build(
    outputs   = target,
    implicit  = [ inputs ] + deps,
    rule      = 'symlink',
    variables = { 'dst_dir' : dst_dir,
                  'dst'     : dst_relative,
                  'src'     : src_relative,
                  'stamp'   : dst_stamp_relative },
  )

  return target

# ninja_execute
#
# Runs the execute rule
#
# - w       : instance of ninja_syntax Writer
# - outputs : outputs of the execute rule
# - rule    : name of the execute rule
# - command : string, command for the rule
# - deps    : additional dependencies for ninja build
#

def ninja_execute( w, outputs, rule, command, description='', deps=None, pool='' ):

  if deps:
    assert type( deps ) == list, 'Expecting deps to be of type list'

  rule_params = {
    'name'        : rule,
    'command'     : command,
    'description' : description,
    'pool'        : pool,
  }

  if not pool:
    del( rule_params['pool'] )

  if not description:
    del( rule_params['description'] )

  w.rule( **rule_params )

  w.newline()

  w.build(
    outputs  = outputs,
    implicit = deps,
    rule     = rule,
  )

  w.newline()

  return outputs

# ninja_stamp
#
# Stamps the given file with a '.stamp.' prefix
#
# - w       : instance of ninja_syntax Writer
# - f       : file to stamp
# - deps    : additional dependencies for ninja build
#

def ninja_stamp( w, f, deps=None ):

  if deps:
    assert type( deps ) == list, 'Expecting deps to be of type list'

  f_stamp = stamp( f )

  w.build(
    outputs   = f_stamp,
    implicit  = [ f ] + deps,
    rule      = 'stamp',
    variables = { 'stamp' : f_stamp },
  )

  w.newline()

  return f_stamp

# ninja_alias
#
# Create an alias for the given dependencies
#
# - w     : instance of ninja_syntax Writer
# - alias : alias name(s)
# - deps  : dependencies
#

def ninja_alias( w, alias, deps ):

  if deps:
    assert type( deps ) == list, 'Expecting deps to be of type list'

  w.build(
    outputs  = alias,
    implicit = deps,
    rule     = 'phony',
  )

  w.newline()

  return alias

# ninja_common_rules
#
# Write out the common ninja rules
#
# - w : instance of ninja_syntax Writer
#

def ninja_common_rules( w ):

  # cpdir

  w.rule(
    name        = 'cpdir',
    description = 'cpdir: Copying $src to $dst',
    command     = 'rm -rf ./$dst && ' +
                  'cp -aL $src $dst || true && ' +
                  'chmod -R +w $dst && ' +
                  'touch $stamp',
  )
  w.newline()

  # cpdir-and-parameterize
  #
  # Copies a parameterized YAML into the new build directory

  w.rule(
    name        = 'cpdir-and-parameterize',
    description = 'cpdir-and-parameterize: Copying $src to $dst',
    command     = 'rm -rf ./$dst && ' +
                  'cp -aL $src $dst || true && ' +
                  'chmod -R +w $dst && ' +
                  'cp .mflowgen/$dst/configure.yml $dst && ' +
                  'touch $stamp',
  )
  w.newline()

  # mkdir-and-symlink
  #
  # Shadows the source directory contents with symlinks

  w.rule(
    name        = 'mkdir-and-symlink',
    description = 'mkdir-and-symlink: Shadowing $src to $dst',
    command     = 'rm -rf ./$dst && ' +
                  'mkdir -p $dst && ' +
                  'cd $dst && ln -sf ../$src/* . && cd .. && ' +
                  'rm $dst/configure.yml && ' +
                  'cp .mflowgen/$dst/configure.yml $dst && ' +
                  'touch $stamp',
  )
  w.newline()

  # symlink

  w.rule(
    name        = 'symlink',
    description = 'symlink: Symlinking $src to $dst',
    command     = 'cd $dst_dir && ln -sf $src $dst && touch $stamp',
  )
  w.newline()

  # stamp

  w.rule(
    name        = 'stamp',
    description = 'stamp: Stamping at $stamp',
    command     = 'touch $stamp',
  )
  w.newline()

# ninja_clean
#
# Write out ninja rules for cleaning
#
# - w : instance of ninja_syntax Writer
#

def ninja_clean( w, name, command ):

  w.rule(
    name        = name,
    description = name + ': Clean build directories',
    command     = command,
  )
  w.newline()

  w.build(
    outputs = name,
    rule    = name,
  )
  w.newline()

# ninja_diff
#
# Write out rules for diffs
#
# - w : instance of Writer
#

def ninja_diff( w, name, src, dst ):

  exclude_files = [
    'configure.yml',
    '.time_end',
    '.time_start',
    'mflowgen-run*',
    'mflowgen-debug',
    '.stamp',
    'inputs',
    'outputs',
  ]

  command = ' '.join( [
    # Newline
    'echo &&',
    # Diff the src and dst
    'diff -r -u --minimal',
    # Exclude build-system specific files
    '--exclude={' + ','.join( exclude_files ) + '}',
    src,
    dst,
    '|',
    # Try to portably colorize the outputs with grep
    "grep --color=always -e '^-.*' -e '$$' -e 'Only in " + src + ".*'",
    '|',
    "GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in " + dst + ".*'",
    # Newline
    '&& echo',
    # Ignore any issues
    '|| true',
  ] )

  w.rule(
    name    = name,
    command = command,
  )
  w.newline()

  w.build(
    outputs = name,
    rule    = name,
  )
  w.newline()

# ninja_runtimes
#
# Write out ninja rules for calculating runtimes from timestamps
#
# - w : instance of ninja_syntax Writer
#

def ninja_runtimes( w ):

  w.rule(
    name        = 'runtimes',
    description = 'runtimes: Listing runtimes for each step',
    command     = get_top_dir() + '/mflowgen/scripts/mflowgen-runtimes',
  )
  w.newline()

  w.build(
    outputs = 'runtimes',
    rule    = 'runtimes',
  )
  w.newline()

# ninja_list
#
# Write out ninja rule to list all steps
#
# - w             : instance of ninja_syntax Writer
# - build_dirs    : list of build directories
# - debug_targets : dict of debug targets with key (id) and value (target)
#

def ninja_list( w, build_dirs, debug_targets ):

  # Split the build ID and step name from the build_dir
  #
  # For example, this:
  #
  #     4-synopsys-dc-synthesis
  #
  # turns into this:
  #
  #     ( '4', 'synopsys-dc-synthesis' )
  #

  steps = []

  for _ in sorted( build_dirs.values(), \
                     key = lambda x: int(x.split('-')[0]) ):
    tokens = _.split('-')
    steps.append( ( tokens[0], '-'.join(tokens[1:]) ) )

  steps_str = \
    [ '"{: >3} : {}"'.format(x,y) for x, y in ( steps ) ]

  generic = [
    '"list      -- List all steps"',
    '"status    -- Print build status for each step"',
    '"runtimes  -- Print runtimes for each step"',
    '"graph     -- Generate a PDF of the step dependency graph"',
    '"clean-all -- Remove all build directories"',
    '"clean-N   -- Clean target N"',
    '"info-N    -- Print configured info for step N"',
    '"diff-N    -- Diff target N"',
  ]

  debug_str = \
    [ '"debug-{: <2} : {}"'.format(i,tup) \
      for i, tup in sorted( debug_targets.items(), key=lambda x:int(x[0]) ) ]

  commands = [
    r'echo',
    r'echo Generic Targets: && echo && ' + \
      r'printf " - %s\\n" ' + ' '.join( generic ),
    r'echo',
    r'echo Targets: && echo && ' + \
      r'printf " - %s\\n" ' + ' '.join( steps_str ),
    r'echo',
    r'echo Debug Targets: && echo && ' + \
      r'printf " - %s\\n" ' + ' '.join( debug_str ),
    r'echo',
  ]

  command = ' && '.join( commands )

  w.rule(
    name        = 'list',
    description = 'list: Listing all targets',
    command     = command,
  )
  w.newline()

  w.build(
    outputs = 'list',
    rule    = 'list',
  )
  w.newline()

# ninja_graph
#
# Write out ninja rule to generate a PDF of the user-defined graph
#
# - w : instance of ninja_syntax Writer
#

def ninja_graph( w ):

  command = 'dot -Tpdf .mflowgen/graph.dot > graph.pdf'

  w.rule(
    name        = 'graph',
    description = 'graph: Generating a PDF of the user-defined graph',
    command     = command,
  )
  w.newline()

  w.build(
    outputs = 'graph',
    rule    = 'graph',
  )
  w.newline()

# ninja_graph_detailed
#
# Write out ninja rule to generate a PDF of the build system's dependency
# graph.
#
# - w          : instance of ninja_syntax Writer
# - build_dirs : list of build directories
#
# The build directories are used to create subgraphs in the default ninja
# build graph.. otherwise the graph is too messy to see anything in.
#

def ninja_graph_detailed( w, build_dirs ):

  build_dirs_commas = ','.join( build_dirs )

  python_graph_cmd = ' '.join([
    get_top_dir() + '/mflowgen/scripts/mflowgen-graph',
    '-t ' + build_dirs_commas,
    '-g .graph.dot',
    '-o .graph.subgraph.dot',
  ])

  command = ' && '.join([
    'ninja -t graph > .graph.dot',
    python_graph_cmd,
    'dot -Tps2 .graph.subgraph.dot > .graph.ps2',
    'ps2pdf .graph.ps2 graph.pdf',
  ])

  w.rule(
    name        = 'graph',
    description = 'graph: Generating the build graph',
    command     = command,
  )
  w.newline()

  w.build(
    outputs = 'graph',
    rule    = 'graph',
  )
  w.newline()

# ninja_status
#
# Write out rules for printing build status
#
# - w : instance of ninja_syntax Writer
# - steps : list of step names to print status for
#

def ninja_status( w, steps ):

  steps_comma_separated = ','.join( steps )

  w.rule(
    name        = 'status',
    description = 'status: Listing status for each step',
    command     = get_top_dir() + '/mflowgen/scripts/mflowgen-status' \
                  ' --backend ninja -s ' + steps_comma_separated
  )
  w.newline()

  w.build(
    outputs = 'status',
    rule    = 'status',
  )
  w.newline()

# ninja_info
#
# Write out rules for printing step info
#
# - w         : instance of Writer
# - build_dir : build_dir for this info target
#

def ninja_info( w, build_dir ):

  build_id      = build_dir.split('-')[0]              # <- first number
  step_name     = '-'.join( build_dir.split('-')[1:])  # <- remainder
  target        = 'info-' + build_id

  command = get_top_dir() + '/mflowgen/scripts/mflowgen-letters' \
      + ' -c -t ' + step_name

  command = command + ' && ' + get_top_dir() \
      + '/mflowgen/scripts/mflowgen-info'    \
      + ' -y .mflowgen/' + build_dir + '/configure.yml'

  w.rule(
    name        = target,
    description = 'List info for the step',
    command     = command
  )
  w.newline()

  w.build(
    outputs = target,
    rule    = target,
  )
  w.newline()

