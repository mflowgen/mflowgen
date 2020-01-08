#! /usr/bin/env python
#=========================================================================
# makefile_syntax.py
#=========================================================================
# Helper functions to generate Makefile syntax
#
# Author : Christopher Torng
# Date   : June 11, 2019
#

import os
import textwrap

from .utils import stamp, get_top_dir

#-------------------------------------------------------------------------
# Writer class
#-------------------------------------------------------------------------

class Writer( object ):

  def __init__( s, output, width=78 ):
    s.output = output
    s.width = width

  def newline( s ):
    s.output.write( '\n' )

  def comment( s, text ):
    lines =  textwrap.wrap(
      text, s.width-2, break_long_words=False, break_on_hyphens=False
    )
    for line in lines:
      s.output.write( '# ' + line + '\n' )

  def write( s, text ):
    s.output.write( text )

  def default( s, default_target ):
    s.output.write( 'default: ' + default_target + '\n' )

#-------------------------------------------------------------------------
# Helper functions
#-------------------------------------------------------------------------

# make_cpdir
#
# Copies a directory and handles stamping
#
# - w       : instance of Writer
# - dst     : path to copied directory
# - src     : path to source directory
# - deps    : list, additional dependencies
# - sandbox : bool, True (copies src dir), False (symlinks src contents)
#

def make_cpdir( w, dst, src, deps=None, sandbox=True ):

  if deps:
    assert type( deps ) == list, 'Expecting deps to be of type list'

  # $1 -- dst
  # $2 -- src
  # $3 -- stamp

  if sandbox:
    rule = 'cpdir-and-parameterize'
  else:
    rule = 'mkdir-and-symlink'

  target = dst + '/.stamp'

  # There may be many deps, so generate them on separate lines

  if deps:
    #deps = [ src ] + deps
    deps = [ d for d in deps if ':' not in d ] # ignore colon files

  if deps == None:
    deps = ''

  template_str = '{target}: {dep}\n'

  for dep in deps:
    w.write( template_str.format( target=target, dep=dep ) )

  # Generate the build rule

  template_str  = '{target}:\n'
  template_str += '	$(call {rule},{dst},{src},{stamp})\n'

  w.write(
    template_str.format(
      target = target,
      rule   = rule,
      dst    = dst,
      src    = src,
      stamp  = target,
    )
  )

  return target

# make_symlink
#
# Symlinks src to dst while handling stamping
#
# - w    : instance of Writer
# - dst  : path to linked file/directory
# - src  : path to source file/directory
# - deps : additional dependencies
# - src_is_symlink : boolean, flag if source is a symlink (and has stamp)
# - ignore_src_dep : boolean, does not include src in deps if True
#

def make_symlink( w, dst, src, deps=None, src_is_symlink=False,
                                          ignore_src_dep=False ):

  if deps:
    assert type( deps ) == list, 'Expecting deps to be of type list'

  # $1 -- dst
  # $2 -- src
  # $3 -- stamp

  template_str  = '{target}: {deps}\n'
  template_str += '	$(call {rule},{dst_dir},{dst},{src},{stamp})\n'

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

  # Make

  target = dst_stamp

  if not ignore_src_dep:
    deps.append( inputs )
    deps = ' '.join( deps )
  else:
    deps = ' '.join( deps )

  if deps == None:
    deps = ''

  w.write(
    template_str.format(
      target  = target,
      deps    = deps,
      rule    = 'symlink',
      dst_dir = dst_dir,
      dst     = dst_relative,
      src     = src_relative,
      stamp   = dst_stamp_relative,
    )
  )

  return target

# make_execute
#
# Runs the execute rule
#
# - w            : instance of Writer
# - outputs      : outputs of the execute rule
# - rule         : name of the execute rule
# - command      : string, command for the rule
# - deps         : additional dependencies
# - touch_target : should we touch the target?
#

def make_execute( w, outputs, rule, command, deps=None,
                                             touch_target=True ):

  if deps:
    assert type( deps ) == list, 'Expecting deps to be of type list'

  # $1 -- rule name
  # #2 -- rule command

  rule_def  = 'define {rule}\n'.format( rule=rule )
  rule_def += '	{command}\n'.format( command=command )
  rule_def += 'endef\n'

  w.write( rule_def )
  w.newline()

  template_str  = '{output}: {deps}\n'
  template_str += '	$(call {rule})\n'

  if touch_target:
    template_str += '	touch $@\n'

  if deps:
    deps = ' '.join( deps )

  if deps == None:
    deps = ''

  w.write(
    template_str.format(
      output  = outputs[0],
      deps    = deps,
      rule    = rule,
    )
  )
  w.newline()

  # Make all other outputs just depend on the first output

  template_str = '{output}: {deps}\n' + '	touch $@\n'

  if len( outputs ) > 1:
    for output in outputs[1:]:
      w.write( template_str.format( output = output, deps = outputs[0] ) )
    w.newline()

  return outputs

# make_stamp
#
# Stamps the given file with a '.stamp.' prefix
#
# - w        : instance of Writer
# - f        : file to stamp
# - deps     : additional dependencies
# - f_is_dep : should the file to be stamped also be a dependency?
#

def make_stamp( w, f, deps=None, f_is_dep=True ):

  if deps:
    assert type( deps ) == list, 'Expecting deps to be of type list'

  f_stamp = stamp( f )

  # $1 -- stamp

  template_str  = '{target}: {deps}\n'
  template_str += '	$(call {rule},{stamp})\n'

  if deps and f_is_dep:
    deps = ' '.join( [ f ] + deps )
  else:
    deps = ' '.join( deps )

  if deps == None:
    deps = ''

  w.write(
    template_str.format(
      target  = f_stamp,
      deps    = deps,
      rule    = 'stamp',
      stamp   = f_stamp,
    )
  )
  w.newline()

  return f_stamp

# make_alias
#
# Create an alias for the given dependencies
#
# - w     : instance of Writer
# - alias : alias name(s)
# - deps  : dependencies
#

def make_alias( w, alias, deps ):

  if deps:
    assert type( deps ) == list, 'Expecting deps to be of type list'

  # $1 -- stamp

  template_str  = '.PHONY: {alias}\n'
  template_str += '\n'
  template_str += '{alias}: {deps}\n'

  if deps:
    deps = ' '.join( deps )

  if deps == None:
    deps = ''

  w.write( template_str.format( alias=alias, deps=deps ) )
  w.newline()

  return deps

# make_common_rules
#
# Write out the common rules
#
# - w : instance of Writer
#

def make_common_rules( w ):

  w.write(
'''
# $1 -- $dst
# $2 -- $src
# $3 -- $stamp

define cpdir
	rm -rf ./$1
	cp -aL $2 $1 || true
	chmod -R +w $1
	touch $3
endef

# $1 -- $dst
# $2 -- $src
# $3 -- $stamp

define cpdir-and-parameterize
	rm -rf ./$1
	cp -aL $2 $1 || true
	chmod -R +w $1
	cp .mflowgen/$1/configure.yml $1
	touch $3
endef

# $1 -- $dst
# $2 -- $src
# $3 -- $stamp

define mkdir-and-symlink
	rm -rf ./$1
	mkdir -p $1
	cd $1 && ln -sf ../$2/* . && cd ..
	rm $1/configure.yml && cp .mflowgen/$1/configure.yml $1
	touch $3
endef

# $1 -- $dst_dir
# $2 -- $dst
# $3 -- $src
# $4 -- $stamp

define symlink
	mkdir -p $1
	cd $1 && ln -sf $3 $2 && touch $4
endef

# $1 -- $stamp

define stamp
	touch $1
endef

''')

# make_clean
#
# Write out rules for cleaning
#
# - w : instance of Writer
#

def make_clean( w, name, command ):

  template_str  = '.PHONY: ' + name + '\n'
  template_str += '\n'
  template_str += name + ':\n'
  template_str += '	{command}\n'

  w.write( template_str.format( command=command ) )
  w.newline()

# make_diff
#
# Write out rules for diffs
#
# - w : instance of Writer
#

def make_diff( w, name, src, dst ):

  exclude_files = [
    'configure.yml',
    '.time_end',
    '.time_start',
    'mflowgen-run.*',
    'mflowgen-debug.*',
    '.stamp',
    'inputs',
    'outputs',
  ]

  command = ' '.join( [
    # Newline
    '@echo &&',
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

  template_str  = '.PHONY: ' + name + '\n'
  template_str += '\n'
  template_str += name + ':\n'
  template_str += '	{command}\n'

  w.write( template_str.format( command=command ) )
  w.newline()

# make_runtimes
#
# Write out rules for calculating runtimes from timestamps
#
# - w : instance of Writer
#

def make_runtimes( w ):

  template_str  = '.PHONY: runtimes\n'
  template_str += '\n'
  template_str += 'runtimes:\n'
  template_str += '	{command}\n'

  command = '@python ' + get_top_dir() + '/utils/runtimes.py'

  w.write( template_str.format( command=command ) )
  w.newline()

# make_list
#
# Write out rule to list all steps
#
# - w             : instance of Writer
# - order         : list of steps in order
# - debug_targets : dict of debug targets with key (id) and value (target)
#

def make_list( w, order, debug_targets ):

  steps_str = \
    [ '"{: >2} : {}"'.format(i,x) for i, x in enumerate( order ) ]

  generic = [
    '"list      -- List all steps"',
    '"status    -- Print build status for each step"',
    '"runtimes  -- Print runtimes for each step"',
    '"graph     -- Generate a PDF of the step dependency graph"',
    '"clean-all -- Remove all build directories"',
    '"clean-N   -- Clean target N"',
    '"diff-N    -- Diff target N"',
  ]

  debug_str = \
    [ '"debug-{: <2} : {}"'.format(i,tup) \
      for i, tup in sorted( debug_targets.items(), key=lambda x:int(x[0]) ) ]

  template_str  = '.PHONY: list\n'
  template_str += '\n'
  template_str += 'list:\n'
  template_str += '	{command}\n'

  commands = [
    'echo',
    'echo Generic Targets\: && echo && ' + \
      'printf " - %s\\n" ' + ' '.join( generic ),
    'echo',
    'echo Targets\: && echo && ' + \
      'printf " - %s\\n" ' + ' '.join( steps_str ),
    'echo',
    'echo Debug Targets\: && echo && ' + \
      'printf " - %s\\n" ' + ' '.join( debug_str ),
    'echo',
  ]

  command = '@' + ' && '.join( commands )

  w.write( template_str.format( command=command ) )
  w.newline()

# make_graph
#
# Write out rule to generate a PDF of the user-defined graph
#
# - w : instance of Writer
#

def make_graph( w ):

  command = 'dot -Tpdf .mflowgen/graph.dot > graph.pdf'

  template_str  = '.PHONY: graph\n'
  template_str += '\n'
  template_str += 'graph:\n'
  template_str += '	{command}\n'

  w.write( template_str.format( command=command ) )
  w.newline()

# make_status
#
# Write out rules for printing build status
#
# - w     : instance of Writer
# - steps : list of step names to print status for
#

def make_status( w, steps ):

  steps_comma_separated = ','.join( steps )

  template_str  = '.PHONY: status\n'
  template_str += '\n'
  template_str += 'status:\n'
  template_str += '	{command}\n'

  command = '@python ' + get_top_dir() + '/utils/status.py -s ' \
                                       + steps_comma_separated

  w.write( template_str.format( command=command ) )
  w.newline()


