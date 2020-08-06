#=========================================================================
# stash_handler.py
#=========================================================================
# Handler for stash-related commands
#
# Author : Christopher Torng
# Date   : March 15, 2020
#

import os
import re
import shutil
import subprocess
import sys
import yaml

from datetime       import datetime

from mflowgen.utils import bold, yellow
from mflowgen.utils import read_yaml, write_yaml

#-------------------------------------------------------------------------
# Stash Management
#-------------------------------------------------------------------------
# Stashes are directories with (1) pre-built steps and (2) a stash
# metadata YAML. The stashed steps are both date-stamped and hash-stamped
# to prevent name conflicts:
#
#     % ls -1
#     2020-0315-synopsys-dc-synthesis-3e5ab4
#     2020-0314-synopsys-dc-synthesis-1eaab4
#
# The stash metadata YAML has an entry per stashed item:
#
#     - author: ctorng
#       date: 2020-0315
#       dir: 2020-0315-synopsys-dc-synthesis-4d7fdb
#       hash: 4d7fdb
#       msg: foo
#       step: synopsys-dc-synthesis
#
#     - author: ctorng
#       date: 2020-0314
#       dir: 2020-0314-synopsys-dc-synthesis-2e78ac
#       hash: 2e78ac
#       msg: bar
#       step: synopsys-dc-synthesis
#
# The stash can live anywhere in the file system, so in order to link a
# build directory to a particular stash, we store the path locally in a
# stash path YAML:
#
#     path: /path/to/stash/dir
#

class StashHandler:

  def __init__( s ):

    # Valid commands

    s.commands = [
      'init',
      'link',
      'list',
      'push',
      'pull',
      'pop',
      'drop',
      'help',
    ]

    # Read YAML: Grab link path from hidden YAML

    s.link_path_yaml = '.mflowgen.stash.yml'

    try:
      data        = read_yaml( s.link_path_yaml )
      s.link_path = data[ 'path' ]
    except Exception:
      s.link_path = ''

    # Read YAML: Grab metadata about the linked stash (e.g., stash hashes,
    # authors, messages)

    s.stash_yaml_path = s.link_path + '/.mflowgen.stash.yml'

    try:
      s.stash = read_yaml( s.stash_yaml_path )
    except FileNotFoundError:
      s.stash = []

  #-----------------------------------------------------------------------
  # helpers
  #-----------------------------------------------------------------------

  # gen_unique_hash
  #
  # Generate a unique six-character hexadecimal hash that is not currently
  # in use across all steps in the currently linked stash.
  #
  # - E.g., "3e5ab4"
  #

  def gen_unique_hash( s ):

    def gen_hash():
      today = datetime.today()
      hash_ = str( hex(hash(today)) )[3:9] # 6-char hex hash
      return hash_

    def stash_has_hash( hash_ ):
      match = [ hash_ == data[ 'hash' ] for data in s.stash ]
      return any( match )

    # Loop until we get a unique hash

    hashstamp = gen_hash()

    while stash_has_hash( hashstamp ):
      hashstamp = gen_hash()

    return hashstamp

  #-----------------------------------------------------------------------
  # verify and check
  #-----------------------------------------------------------------------

  # verify_stash
  #
  # Make sure the stash directory exists
  #

  def verify_stash( s ):
    try:
      assert os.path.exists( s.link_path )
    except AssertionError:
      # Stash not found... print a useful message with directions
      stash_msg = s.link_path if s.link_path else '(no stash is linked)'
      print()
      print( 'Could not access stash directory.',
             'Please continue with one of the following:\n',
             '\n',
             '1. Create a new stash (with stash init)\n',
             '2. Relink to a new stash (with stash link)\n',
             '3. Make sure the currently linked stash directory exists\n',
             '\n',
             bold( 'Stash:' ), '{}'.format( stash_msg ) )
      print()
      sys.exit( 1 )

  # get_hash_index_in_stash
  #
  # Given a hash, returns the index of the matching stashed item in the
  # stash metadata list. This method errors out if the hash is not found.
  #

  def get_hash_index_in_stash( s, hash_ ):
    is_target = [ hash_ == data[ 'hash' ] for data in s.stash ]
    try:
      assert any( is_target )
    except AssertionError:
      print( bold( 'Error:' ), 'Stash does not contain hash',
                                  '"{}"'.format( hash_ ) )
      sys.exit( 1 )
    ind  = is_target.index( True )
    return ind

  #-----------------------------------------------------------------------
  # stash_path
  #-----------------------------------------------------------------------

  def get_stash_path( s ):
    return s.link_path

  def set_stash_path( s, path ):
    s.link_path = path
    write_yaml(
      data = { 'path' : s.link_path },
      path = s.link_path_yaml,
    )

  #-----------------------------------------------------------------------
  # update_stash
  #-----------------------------------------------------------------------
  # Update the metadata in the linked stash directory
  #

  def update_stash( s ):
    write_yaml(
      data = s.stash,
      path = s.stash_yaml_path,
    )

  #-----------------------------------------------------------------------
  # launch
  #-----------------------------------------------------------------------
  # Dispatch function for commands
  #

  def launch( s, args, help_, path, step, msg, hash_, all_, verbose ):

    if help_ and not args:
      s.launch_help()
      return

    try:
      command = args[0]
      assert command in s.commands # valid commands only
    except Exception as e:
      print( 'stash: Unrecognized commands (see "mflowgen stash help")' )
      sys.exit( 1 )

    try:
      assert len( args ) <= 1 # no further positional args are allowed
    except Exception as e:
      print()
      print( 'stash: Unrecognized positional args' )
      # Allow this exception to pass, but force set the "help" flag so
      # users can see what they should be doing instead.
      help_ = True

    if   command == 'init' : s.launch_init( help_, path )
    elif command == 'link' : s.launch_link( help_, path )
    elif command == 'list' : s.launch_list( help_, verbose, all_ )
    elif command == 'push' : s.launch_push( help_, step, msg, all_ )
    elif command == 'pull' : s.launch_pull( help_, hash_ )
    elif command == 'pop'  : s.launch_pop ( help_, hash_ )
    elif command == 'drop' : s.launch_drop( help_, hash_ )
    else                   : s.launch_help()

  #-----------------------------------------------------------------------
  # launch_init
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Creates a new stash directory
  # - Writes a local YAML that simply stores a link to the stash directory
  #

  def launch_init( s, help_, path ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen stash init',
                                 '--path/-p <path/to/store/dir>' )
      print()
      print( bold( 'Example:' ), 'mflowgen stash init',
                                    '-p /tmp' )
      print()
      print( 'Creates a subdirectory in the given directory and' )
      print( 'initializes it as an mflowgen stash.'              )
      print()

    if help_ or not path:
      print_help()
      return

    # Generate a unique stash directory name
    #
    # Combine the date (for human understanding) and a hash (for
    # uniqueness) to generate a unique directory name.
    #
    # - E.g., "2020-0315-mflowgen-stash-c55cde"
    #

    today     = datetime.today()
    datestamp = datetime.strftime( today, '%Y-%m%d' )
    hashstamp = s.gen_unique_hash()

    dirname = '{}-mflowgen-stash-{}'.format( datestamp, hashstamp )

    # Create this subdirectory in the target directory

    new_stash_path = path + '/' + dirname

    try:
      os.makedirs( new_stash_path )
    except OSError:
      if not os.path.isdir( new_stash_path ):
        raise

    # Link to this new stash

    s.launch_link( help_ = False, path = new_stash_path )

  #-----------------------------------------------------------------------
  # launch_link
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Writes a local YAML that simply stores a link to the stash directory
  #

  def launch_link( s, help_, path ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen stash link',
                                 '--path/-p <path/to/stash/dir>'         )
      print()
      print( bold( 'Example:' ), 'mflowgen stash link',
                               '-p /tmp/2020-0315-mflowgen-stash-3aef14' )
      print()
      print( 'Links the current build graph to an mflowgen stash so'     )
      print( 'that all stash commands interact with that stash.'         )
      print()

    if help_ or not path:
      print_help()
      return

    # Link

    s.set_stash_path( os.path.abspath( path ) )
    print( 'Linked to stash:', s.get_stash_path() )

  #-----------------------------------------------------------------------
  # launch_list
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Reads the metadata YAML in the stash directory to list the stash
  #

  def launch_list( s, help_, verbose, all_ ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen stash list [--verbose] [--all]' )
      print()
      print( 'Lists all pre-built steps stored in the mflowgen stash'    )
      print( 'that the current build graph is linked to. The --verbose'  )
      print( 'flag prints metadata about where each stashed step was'    )
      print( 'stashed from. Use --all to print all steps in the stash.'  )
      print()

    if help_:
      print_help()
      return

    # Sanity-check the stash

    s.verify_stash()

    # Print the list

    print()
    print( bold( 'Stash List' ) )

    template_str = \
      ' - {hash_} [ {date} ] {author} {step} -- {msg}'

    stashed_from_template_str = \
      '     > {k:30} : {v}'

    print()
    if not s.stash:
      print( ' - ( the stash is empty )' )
    else:
      s.stash.reverse()  # print in reverse chronological order
      n_print = 10       # print first N items
      to_print = s.stash[:n_print] if not all_ else s.stash
      for x in to_print:
        print( template_str.format(
          hash_  = yellow( x[ 'hash' ] ),
          date   = x[ 'date'   ],
          author = x[ 'author' ],
          step   = x[ 'step'   ],
          msg    = x[ 'msg'    ],
        ) )
        if verbose and 'stashed-from' in x.keys(): # stashed from
          for k, v in x['stashed-from'].items():
            print( stashed_from_template_str.format(k=k,v=v) )
          print()
      if not all_ and len(s.stash) > n_print:
        n_extra = len(s.stash) - n_print
        print( ' - (...) see', n_extra, 'more with --all' )
    print()
    print( bold( 'Stash:' ), s.get_stash_path() )
    print()

  #-----------------------------------------------------------------------
  # launch_push
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Copies the target step build directory to the stash
  #     - if "all_" is True, then stash the entire step, not just outputs
  # - Updates the metadata YAML in the stash directory
  #

  def launch_push( s, help_, step, msg, all_ ):

    try:
      author = os.environ[ 'USER' ]
    except KeyError:
      author = 'Unknown'

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen stash push',
                                  '--step/-s <int> --message/-m "<str>"',
                                  '[--all]'                              )
      print()
      print( bold( 'Example:' ), 'mflowgen stash push',
                                    '--step 5 -m "foo bar"'              )
      print()
      print( 'Pushes a built step to the mflowgen stash. The given step' )
      print( 'is copied to the stash, preserving all permissions and'    )
      print( 'following all symlinks. By default, only the outputs of a' )
      print( 'step are stashed, but the entire step can be stashed with' )
      print( '--all. The stashed copy is given a hash stamp and is'      )
      print( 'marked as authored by $USER (' + author + '). An optional' )
      print( 'message can also be attached to each push.'                )
      print()

    if help_ or step==None or not msg:
      print_help()
      return

    # Sanity-check the stash

    s.verify_stash()

    # Get step to push
    #
    # Check the current directory and search for a dirname matching the
    # given step number.
    #
    # - E.g., if "step" is 5 then look for any sub-directory that starts
    #   with "5-". If there is a directory called
    #   '4-synopsys-dc-synthesis' then "step_name" will be
    #   "synopsys-dc-synthesis"
    #

    build_dirs = os.listdir( '.' )
    targets = [ _ for _ in build_dirs if _.startswith( str(step)+'-' ) ]

    try:
      push_target = targets[0]
    except IndexError:
      print( bold( 'Error:' ), 'No build directory found for step',
                                  '{}'.format( step ) )
      sys.exit( 1 )

    # Create a unique name for the stashed copy of this step

    today       = datetime.today()
    datestamp   = datetime.strftime( today, '%Y-%m%d' )
    hashstamp   = s.gen_unique_hash()
    step_name   = '-'.join( push_target.split('-')[1:] )

    dst_dirname = '-'.join( [ datestamp, step_name, hashstamp ] )

    # Try to get some information to help describe "where this step came
    # from"

    def get_shell_output( cmd ):
      try:
        output = subprocess.check_output( cmd.split(),
                                          stderr=subprocess.DEVNULL,
                                          universal_newlines=True )
        output = output.strip()
      except Exception:
        output = ''
      return output

    def get_hostname():
      import socket
      return socket.gethostname()

    git_cmd  = 'git rev-parse --short HEAD'    # git commit hash
    git_hash = get_shell_output( git_cmd )

    git_cmd  = 'git rev-parse --show-toplevel' # git root dir
    git_repo = get_shell_output( git_cmd )
    git_repo = os.path.basename( git_repo )

    build_path = os.getcwd()                   # build dir path
    hostname   = get_hostname()                # hostname

    stashed_from = {
      'stashed-from-git-root-dir'      : git_repo,
      'stashed-from-git-root-dir-hash' : git_hash,
      'stashed-from-dir'               : build_path,
      'stashed-from-hostname'          : hostname,
    }

    # Helper function to ignore copying files other than the outputs

    def f_ignore( path, files ):
      # For nested subdirectories, ignore all files
      if '/' in path:
        if path.split('/')[1] == 'outputs':
          return []     # ignore nothing in outputs
        elif path.split('/')[1] in [ 'logs', 'reports' ]: # TEMPORARY
          return []     # ignore nothing                  # TEMPORARY
        else:
          return files  # ignore everything for any other directory
      # At the top level, keep the outputs and a few other misc files
      keep = [
        'outputs',
        'logs',      # TEMPORARY
        'reports',   # TEMPORARY
        'configure.yml',
        'mflowgen-run.log',
        '.time_start',
        '.time_end',
        '.stamp',
        '.execstamp',
        '.postconditions.stamp',
      ]
      ignore = [ _ for _ in files if _ not in keep ]
      return ignore

    # Now copy src to dst
    #
    # - symlinks                 = False  # Follow all symlinks
    # - ignore_dangling_symlinks = False  # Stop with error if we cannot
    #                                     #  follow a link to something
    #                                     #  we need
    # - ignore                   = (func) # Ignore all but the outputs
    #                                     #  unless "--all" was given
    #

    remote_path = s.get_stash_path() + '/' + dst_dirname

    try:
      shutil.copytree( src      = push_target,
                       dst      = remote_path,
                       symlinks = False,
                       ignore   = None if all_ else f_ignore,
                       ignore_dangling_symlinks = False )
    except shutil.Error:
      # According to online discussion, ignore_dangling_symlinks does not
      # apply recursively within sub-directories (a bug):
      #
      # - https://bugs.python.org/issue38523
      #
      # But according to more online discussion, copytree finishes copying
      # everything else before raising the exception.
      #
      # - https://bugs.python.org/issue6547
      #
      # So if we just pass here, we will have everything except dangling
      # symlinks, which is fine for our use case. Dangling symlinks can
      # happen in a few situations:
      #
      #  1. In inputs, if users cleaned earlier dependent steps. In this
      #  situation, we are just doing our best to copy what is available.
      #
      #  2. Some symlink to somewhere we do not have permission to view.
      #  It would be nice to raise an exception in this case, but that is
      #  hard to differentiate.
      #
      pass
    except Exception as e:
      print( bold( 'Error:' ), 'Failed to complete stash push' )
      shutil.rmtree( path = remote_path, ignore_errors = True ) # clean up
      raise

    # Update the metadata in the stash

    push_metadata = {
      'date'         : datestamp,
      'dir'          : dst_dirname,
      'hash'         : hashstamp,
      'author'       : author,
      'step'         : step_name,
      'msg'          : msg,
      'stashed-from' : stashed_from,
    }

    s.stash.append( push_metadata )
    s.update_stash()

    # Try adding the metadata to the stashed step itself, so that when the
    # step gets pulled somewhere, we have all of its metadata to know
    # where it came from

    try:
      data = push_metadata
      data.update( { 'stash-dir': s.link_path } ) # add stash dir
      write_yaml(
        data = data,
        path = remote_path+'/.mflowgen.stash.node.yml',
      )
    except Exception as e:
      pass

    print(
      'Stashed step {step} "{step_name}" as author "{author}"'.format(
      step      = step,
      step_name = step_name,
      author    = author,
    ) )

  #-----------------------------------------------------------------------
  # launch_pull
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Copies the stashed step to the current directory
  #

  def launch_pull( s, help_, hash_ ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen stash pull --hash <hash>'       )
      print()
      print( bold( 'Example:' ), 'mflowgen stash pull --hash 3e5ab4'     )
      print()
      print( 'Pulls a pre-built step from the stash matching the given'  )
      print( 'hash. This command copies the pre-built step from the'     )
      print( 'stash using archive mode (preserves all permissions). The' )
      print( 'new step replaces the same step in the existing graph.'    )
      print( 'For example if the existing graph marks'                   )
      print( '"synopsys-dc-synthesis" as step 4 and a pre-built'         )
      print( '"synopsys-dc-synthesis" is pulled from the stash, the'     )
      print( 'existing build directory is removed and the pre-built'     )
      print( 'version replaces it as step 4. The status of the'          )
      print( 'pre-built step is forced to be up to date until the step'  )
      print( 'is cleaned.'                                               )
      print()

    if help_ or not hash_:
      print_help()
      return

    # Sanity-check the stash

    s.verify_stash()

    # Get the step metadata

    ind  = s.get_hash_index_in_stash( hash_ )
    data = s.stash[ ind ]
    step = data[ 'step' ]

    # Get the build directory for the matching configured step
    #
    # Currently this is done by just looking at the directory names in the
    # hidden mflowgen metadata directory, which has all the build
    # directories for the current configuration.
    #

    existing_steps = os.listdir( '.mflowgen' )

    m = [ re.match( r'^(\d+)-' + step + '$', _ ) \
            for _ in existing_steps ]  # e.g., "4-synopsys-dc-synthesis"
    m = [ _ for _ in m if _ ]          # filter for successful matches
    m = [ _.group(0) for _ in m if _ ] # get build directories

    try:
      assert len( m ) > 0   # Assert for at least one match
    except AssertionError:
      print( bold( 'Error:' ), 'The currently configured graph',
              'does not contain step "{}"'.format( step ) )
      sys.exit( 1 )

    build_dir = m[0]

    # Remove the build directory if it exists

    shutil.rmtree( path = build_dir, ignore_errors = True )

    # Now copy from the stash
    #
    # - symlinks                 = False # Follow all symlinks
    # - ignore_dangling_symlinks = False # Stop with error if we cannot
    #                                    #  follow a link to something
    #                                    #  we need
    #

    remote_path = s.get_stash_path() + '/' + data[ 'dir' ]

    try:
      shutil.copytree( src      = remote_path,
                       dst      = build_dir,
                       symlinks = False,
                       ignore_dangling_symlinks = False )
    except Exception as e:
      print( bold( 'Error:' ), 'Failed to complete stash pull' )
      raise

    # Mark the new step as pre-built with a ".prebuilt" flag

    with open( build_dir + '/.prebuilt', 'w' ) as fd: # touch
      pass

    print(
      'Pulled step "{step}" from stash into "{dir_}"'.format(
      step = step,
      dir_ = build_dir,
    ) )

  #-----------------------------------------------------------------------
  # launch_pop
  #-----------------------------------------------------------------------
  # This command simply calls both launch_pull and launch_drop

  def launch_pop( s, help_, hash_ ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen stash pop --hash <hash>'       )
      print()
      print( bold( 'Example:' ), 'mflowgen stash pop --hash 3e5ab4'     )
      print()
      print( 'Pulls a pre-built step from the stash and then drops it'  )
      print( 'from the stash. This command literally runs pull and'     )
      print( 'drop one after the other.'                                )
      print()

    if help_ or not hash_:
      print_help()
      return

    s.launch_pull( help_, hash_ )
    s.launch_drop( help_, hash_ )

  #-----------------------------------------------------------------------
  # launch_drop
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Deletes a stashed step from the stash directory
  # - Updates the metadata YAML in the stash directory
  #

  def launch_drop( s, help_, hash_ ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen stash drop --hash <hash>'     )
      print()
      print( bold( 'Example:' ), 'mflowgen stash drop --hash 3e5ab4'   )
      print()
      print( 'Removes the step with the given hash from the stash.'    )
      print()

    if help_ or not hash_:
      print_help()
      return

    # Sanity-check the stash

    s.verify_stash()

    # Get the step metadata

    ind  = s.get_hash_index_in_stash( hash_ )
    data = s.stash[ ind ]

    # Now delete the target from the stash

    remote_path = s.get_stash_path() + '/' + data[ 'dir' ]

    try:
      shutil.rmtree( remote_path )
    except Exception as e:
      print( bold( 'Error:' ), 'Failed to complete stash drop' )
      raise

    # Update the metadata in the stash

    del( s.stash[ ind ] )
    s.update_stash()

    print(
      'Dropped step "{step_name}" with hash "{hash_}"'.format(
      step_name = data[ 'step' ],
      hash_     = hash_,
    ) )

  #-----------------------------------------------------------------------
  # launch_help
  #-----------------------------------------------------------------------

  def launch_help( s ):
    print()
    print( bold( 'Stash Commands' ) )
    print()
    print( bold( ' - init :' ), 'Initialize a stash'                                )
    print( bold( ' - link :' ), 'Link the current build graph to an existing stash' )
    print()
    print( bold( ' - list :' ), 'List all pre-built steps in the stash'             )
    print()
    print( bold( ' - push :' ), 'Push a built step to the stash'                    )
    print( bold( ' - pull :' ), 'Pull a built step from the stash'                  )
    print( bold( ' - drop :' ), 'Remove a built step from the stash'                )
    print()
    print( 'Run any command with -h to see more details'                 )
    print()


