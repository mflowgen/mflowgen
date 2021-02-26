#=========================================================================
# ninja_backend.py
#=========================================================================
# Backend that generates ninja build files from a BuildOrchestrator
#
# Author : Christopher Torng
# Date   : June 2, 2019
#

import datetime as dt
import os

from mflowgen.backends.ninja_syntax       import Writer as NinjaWriter
from mflowgen.backends.ninja_syntax_extra import ninja_cpdir, ninja_symlink
from mflowgen.backends.ninja_syntax_extra import ninja_execute, ninja_stamp, ninja_alias
from mflowgen.backends.ninja_syntax_extra import ninja_common_rules, ninja_clean
from mflowgen.backends.ninja_syntax_extra import ninja_diff
from mflowgen.backends.ninja_syntax_extra import ninja_runtimes, ninja_list
from mflowgen.backends.ninja_syntax_extra import ninja_graph, ninja_status, ninja_info

class NinjaBackend:

  def __init__( s ):
    s.fd = open( 'build.ninja', 'w' )
    s.w = NinjaWriter( s.fd )
    # Track debug targets for list command
    s.debug_targets = {}

  def __del__( s ):
    s.fd.close()

  # save

  def save( s, order, build_dirs, step_dirs ):
    s.order      = order
    s.build_dirs = build_dirs
    s.step_dirs  = step_dirs

  # gen_header

  def gen_header( s ):

    date = dt.datetime.strftime( dt.datetime.today(), '%B %d, %Y - %H:%M' )
    gen  = os.path.abspath( __file__ ).rstrip('c')

    s.fd.write( '#' + '='*73 + '\n' )
    s.fd.write( '# build.ninja\n' )
    s.fd.write( '#' + '='*73 + '\n' )
    #s.fd.write( '# Generated : ' + date + '\n' )
    s.fd.write( '# Generator : ' + gen + '\n' )
    s.fd.write( '\n' )

  # gen_prologue

  def gen_prologue( s ):
    ninja_common_rules( s.w )

  # gen_step_header

  def gen_step_header( s, step_name ):

    s.w.comment( '-'*72 )
    s.w.comment( step_name )
    s.w.comment( '-'*72 )
    s.w.newline()

  # gen_step_directory_pre
  #
  # This runs at the very start of generating rules for the step directory

  def gen_step_directory_pre( s ):

    s.w.comment( 'build dir' )
    s.w.newline()

  # gen_step_directory
  #
  # Expected semantics
  #
  # - Remove the {dst}
  # - Copy the {src} to the {dst}
  # - Parameterize using the saved YAML in the metadata directory
  # - This rule depends on {deps}
  # - {sandbox} True (copies src dir), False (symlinks src contents)
  #
  # Expected return
  #
  # - Return a list that can pass to another backend call as extra_deps
  #

  def gen_step_directory( s, dst, src, deps, extra_deps, sandbox ):

    all_deps = deps + extra_deps

    # Rules

    target = ninja_cpdir(
      w       = s.w,
      dst     = dst,
      src     = src,
      deps    = all_deps,
      sandbox = sandbox,
    )
    s.w.newline()

    return [ target ]

  # gen_step_collect_inputs_pre
  #
  # This runs at the very start of generating rules for collecting inputs

  def gen_step_collect_inputs_pre( s ):

    s.w.comment( 'collect inputs' )
    s.w.newline()

  # gen_step_collect_inputs
  #
  # Expected semantics
  #
  # - Symlink the {src} to the {dst}
  # - This rule depends on {deps}
  #
  # Expected return
  #
  # - Return a list that can pass to another backend call as extra_deps
  #

  def gen_step_collect_inputs( s, dst, src, deps, extra_deps ):

    all_deps = deps + extra_deps

    # Rules

    target = ninja_symlink(
      w    = s.w,
      dst  = dst,
      src  = src,
      deps = all_deps,
      src_is_symlink = True,
    )
    s.w.newline()

    return [ target ]

  # gen_step_execute_pre
  #
  # This runs at the very start of generating rules for execute

  def gen_step_execute_pre( s ):

    s.w.comment( 'execute' )
    s.w.newline()

  # gen_step_execute
  #
  # Expected semantics
  #
  # - Run the {command}
  # - Generate the {outputs}
  # - This rule depends on {deps}
  #
  # Expected return
  #
  # - Return a list that can pass to another backend call as extra_deps
  #

  def gen_step_execute( s, outputs, command, deps, extra_deps,
                                                     phony=False ):

    all_deps = deps + extra_deps

    # Extract the build directory from the command so we can create a
    # unique rule name

    tokens    = command.split()
    cd_idx    = tokens.index( 'cd' )
    build_dir = tokens[ cd_idx + 1 ]

    rule = build_dir + '-commands-rule'
    rule = rule.replace( '-', '_' )

    description = build_dir + ': Executing...'

    # Update timestamps for pre-existing outputs so timestamp-based
    # dependency checking works

    command = command + ' && touch -c ' + build_dir + '/outputs/*'

    # Stamp the build directory

    command = command + ' && touch ' + build_dir + '/.execstamp'

    # Rules

    targets = ninja_execute(
      w           = s.w,
      outputs     = outputs,
      rule        = rule,
      command     = command,
      description = description,
      deps        = all_deps,
    )

    return targets

  # gen_step_collect_outputs_pre
  #
  # This runs at the very start of generating rules for collecting outputs

  def gen_step_collect_outputs_pre( s ):

    s.w.comment( 'collect outputs' )
    s.w.newline()

  # gen_step_collect_outputs_tagged
  #
  # Expected semantics
  #
  # - Symlink the {src} to the {dst}
  # - This rule depends on {deps}
  #
  # Expected return
  #
  # - Return a list that can pass to another backend call as extra_deps
  #

  def gen_step_collect_outputs_tagged( s, dst, src, deps, extra_deps ):

    all_deps = deps + extra_deps

    # Rules

    target = ninja_symlink(
      w    = s.w,
      dst  = dst,
      src  = src,
      deps = all_deps,
    )

    return [ target ]

  # gen_step_collect_outputs_untagged
  #
  # Expected semantics
  #
  # - Do whatever is necessary to the untagged output {f}
  # - This rule depends on {deps}
  #
  # Expected return
  #
  # - Return a list that can pass to another backend call as extra_deps
  #

  def gen_step_collect_outputs_untagged( s, f, deps, extra_deps ):

    all_deps = deps + extra_deps

    # Rules

    target = ninja_stamp(
      w    = s.w,
      f    = f,
      deps = all_deps,
    )

    return [ target ]

  # gen_step_post_conditions_pre
  #
  # This runs at the very start of generating rules for post-conditions

  def gen_step_post_conditions_pre( s ):

    s.w.comment( 'post-conditions' )
    s.w.newline()

  # gen_step_post_conditions
  #
  # Expected semantics
  #
  # - Run the {command}
  # - This rule depends on {deps}
  #
  # Expected return
  #
  # - Return a list that can pass to another backend call as extra_deps
  #

  def gen_step_post_conditions( s, command, deps, extra_deps ):

    all_deps = deps + extra_deps

    # Extract the build directory from the command so we can create a
    # unique rule name

    tokens    = command.split()
    cd_idx    = tokens.index( 'cd' )
    build_dir = tokens[ cd_idx + 1 ]

    rule = build_dir + '-post-conditions-commands-rule'
    rule = rule.replace( '-', '_' )

    description = build_dir + ': Checking post-conditions...'

    # Stamp the build directory

    outputs = [ build_dir + '/.postconditions.stamp' ]

    command = \
      command + ' && touch ' + build_dir + '/.postconditions.stamp'

    # Rules

    targets = ninja_execute(
      w           = s.w,
      outputs     = outputs,
      rule        = rule,
      command     = command,
      description = description,
      deps        = all_deps,
    )

    return targets

  # gen_step_alias_pre
  #
  # This runs at the very start of generating rules for aliases

  def gen_step_alias_pre( s ):

    s.w.comment( 'alias' )
    s.w.newline()

  # gen_step_alias
  #
  # Expected semantics
  #
  # - Create an alias called {alias} for this step
  # - This rule depends on {deps}
  #
  # Expected return
  #
  # - Return a list that can pass to another backend call as extra_deps
  #

  def gen_step_alias( s, alias, deps, extra_deps ):

    all_deps = deps + extra_deps

    # Rules

    target = ninja_alias(
      w     = s.w,
      alias = alias,
      deps  = all_deps,
    )

    return [ target ]

  # gen_step_debug_pre
  #
  # This runs at the very start of generating rules for debug commands

  def gen_step_debug_pre( s ):

    s.w.comment( 'debug' )
    s.w.newline()

  # gen_step_debug
  #
  # Expected semantics
  #
  # - Run the {command}
  # - Generate the {target}
  # - Use {build_id} to guarantee uniqueness
  #
  # Expected return
  #
  # - None
  #

  def gen_step_debug( s, target, command, build_id ):

    # Rules

    debug_rule = build_id + '-debug-rule'
    debug_rule = debug_rule.replace( '-', '_' )

    ninja_execute(
      w       = s.w,
      outputs = [ target ],
      rule    = debug_rule,
      command = command,
      pool    = 'console',
    )

    # Track debug targets for list command

    s.debug_targets.update( { build_id : target } )

  # gen_epilogue
  #
  # Miscellaneous targets for quality of life, etc.
  #

  def gen_epilogue( s ):

    s.w.comment( '-'*72 )
    s.w.comment( 'Misc' )
    s.w.comment( '-'*72 )
    s.w.newline()

    # Default target -- build everything

    s.w.comment( 'Default' )
    s.w.newline()

    s.w.default( ' '.join( s.order ) )
    s.w.newline()

    # Clean target

    s.w.comment( 'Clean' )
    s.w.newline()

    command = \
      'find . -maxdepth 1 ! -name build.ninja' \
      r' ! -name .mflowgen\*' \
      r' ! -name \. ! -name \.\. -exec rm -rf {} +'

    ninja_clean( s.w, name='clean-all', command=command )

    # Diff target

    s.w.comment( 'Diff' )
    s.w.newline()

    for step_name in s.order:
      src     = s.step_dirs[ step_name ]
      dst     = s.build_dirs[ step_name ]
      idx     = dst.split('-')[0].lstrip('./')
      name    = 'diff-' + idx
      ninja_diff( s.w, name=name, src=src, dst=dst )

    # Clean subtargets (e.g., clean-0, clean-1)

    for step_name, d in sorted( s.build_dirs.items(),
                                  key=lambda x: x[1] ):
      idx     = d.split('-')[0]
      name_n  = 'clean-' + idx
      name_s  = 'clean-' + step_name
      command = 'rm -rf ./' + d
      ninja_clean( s.w, name=name_n, command=command )
      # Named clean subtargets (e.g., clean-foo, clean-bar)
      ninja_alias( s.w, alias=name_s, deps=[name_n] )

    # Info target

    s.w.comment( 'Info' )
    s.w.newline()

    for step_name in s.order:
      ninja_info( s.w, build_dir=s.build_dirs[ step_name ] )

    # Runtime target

    s.w.comment( 'Runtimes' )
    s.w.newline()

    ninja_runtimes( s.w )

    # List target

    s.w.comment( 'List' )
    s.w.newline()

    ninja_list( s.w, s.build_dirs, s.debug_targets )

    # Graph target

    s.w.comment( 'Graph' )
    s.w.newline()

    ninja_graph( s.w )

    # Status target

    s.w.comment( 'Status' )
    s.w.newline()

    ninja_status( s.w, s.build_dirs.values() )



