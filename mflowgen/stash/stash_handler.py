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
import sys
import yaml

from datetime import datetime

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
      'drop',
      'help',
    ]

    # Helper function

    def read_yaml( yaml_path ):
      with open( yaml_path ) as fd:
        try:
          data = yaml.load( fd, Loader=yaml.FullLoader )
        except AttributeError:
          # PyYAML for python2 does not have FullLoader
          data = yaml.load( fd )
      return data

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

    # Colors

    s.RED    = '\033[31m'
    s.GREEN  = '\033[92m'
    s.YELLOW = '\033[93m'
    s.BOLD   = '\033[1m'
    s.END    = '\033[0m'

  #-----------------------------------------------------------------------
  # helpers
  #-----------------------------------------------------------------------

  # Colors

  def bold( s, text ):
    return s.BOLD + text + s.END

  def red( s, text ):
    return s.RED + text + s.END

  def green( s, text ):
    return s.GREEN + text + s.END

  def yellow( s, text ):
    return s.YELLOW + text + s.END

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
             s.bold( 'Stash:' ), '{}'.format( stash_msg ) )
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
      print( s.bold( 'Error:' ), 'Stash does not contain hash',
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
    with open( s.link_path_yaml, 'w' ) as fd:
      yaml.dump( { 'path' : s.link_path }, fd, default_flow_style=False )

  #-----------------------------------------------------------------------
  # update_stash
  #-----------------------------------------------------------------------
  # Update the metadata in the linked stash directory

  def update_stash( s ):
    with open( s.stash_yaml_path, 'w' ) as fd:
      yaml.dump( s.stash, fd, default_flow_style=False )

  #-----------------------------------------------------------------------
  # launch
  #-----------------------------------------------------------------------
  # Dispatch function for stash-related commands

  def launch( s, args, help_, dir_, step, msg, hash_ ):

    try:
      command = args[0]
      assert command in s.commands # valid commands only
    except Exception as e:
      print( 'stash: Unrecognized commands (see "mflowgen stash help")' )
      sys.exit( 1 )

    try:
      assert len( args ) <= 1 # no further positional args are allowed
    except Exception as e:
      print( 'stash: Unrecognized positional args',
              '(see mflowgen stash {} -h)'.format( command ) )
      sys.exit( 1 )

    if   command == 'init' : s.launch_init( help_, dir_ )
    elif command == 'link' : s.launch_link( help_, dir_ )
    elif command == 'list' : s.launch_list( help_ )
    elif command == 'push' : s.launch_push( help_, step, msg )
    elif command == 'pull' : s.launch_pull( help_, hash_ )
    elif command == 'drop' : s.launch_drop( help_, hash_ )
    else                   : s.launch_help( help_ )

  #-----------------------------------------------------------------------
  # launch_init
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Creates a new stash directory
  # - Writes a local YAML that simply stores a link to the stash directory
  #

  def launch_init( s, help_, dir_ ):

    # Help message

    def print_help():
      print()
      print( s.bold( 'Usage:' ), 'mflowgen stash init',
                                  '--dir/-d <path/to/store/dir>' )
      print()
      print( s.bold( 'Example:' ), 'mflowgen stash init',
                                    '-d /tmp' )
      print()
      print( 'Creates a subdirectory in the given directory and' )
      print( 'initializes it as an mflowgen stash.'              )
      print()

    if help_ or not dir_:
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

    new_stash_path = dir_ + '/' + dirname

    try:
      os.makedirs( new_stash_path )
    except OSError:
      if not os.path.isdir( new_stash_path ):
        raise

    # Link to this new stash

    s.launch_link( help_ = False, dir_ = new_stash_path )

  #-----------------------------------------------------------------------
  # launch_link
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Writes a local YAML that simply stores a link to the stash directory
  #

  def launch_link( s, help_, dir_ ):

    # Help message

    def print_help():
      print()
      print( s.bold( 'Usage:' ), 'mflowgen stash link',
                                  '--dir/-d <path/to/stash/dir>'         )
      print()
      print( s.bold( 'Example:' ), 'mflowgen stash link',
                               '-d /tmp/2020-0315-mflowgen-stash-3aef14' )
      print()
      print( 'Links the current build graph to an mflowgen stash so'     )
      print( 'that all stash commands interact with that stash.'         )
      print()

    if help_ or not dir_:
      print_help()
      return

    # Link

    s.set_stash_path( os.path.abspath( dir_ ) )
    print( 'Linked to stash:', s.get_stash_path() )

  #-----------------------------------------------------------------------
  # launch_list
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Reads the metadata YAML in the stash directory to list the stash
  #

  def launch_list( s, help_ ):

    # Help message

    def print_help():
      print()
      print( s.bold( 'Usage:' ), 'mflowgen stash list'                )
      print()
      print( 'Lists all pre-built steps stored in the mflowgen stash' )
      print( 'that the current build graph is linked to.'             )
      print()

    if help_:
      print_help()
      return

    # Sanity-check the stash

    s.verify_stash()

    # Print the list

    print()
    print( s.bold( 'Stash List' ) )

    template_str = \
      ' - {hash_} [ {date} ] {author} {step} -- {msg}'

    print()
    if not s.stash:
      print( ' - ( the stash is empty )' )
    else:
      for x in s.stash:
        print( template_str.format(
          hash_  = s.yellow( x[ 'hash' ] ),
          date   = x[ 'date'   ],
          author = x[ 'author' ],
          step   = x[ 'step'   ],
          msg    = x[ 'msg'    ],
        ) )
    print()
    print( s.bold( 'Stash:' ), s.get_stash_path() )
    print()

  #-----------------------------------------------------------------------
  # launch_push
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Copies the target step build directory to the stash
  # - Updates the metadata YAML in the stash directory
  #

  def launch_push( s, help_, step, msg ):

    try:
      author = os.environ[ 'USER' ]
    except KeyError:
      author = 'Unknown'

    # Help message

    def print_help():
      print()
      print( s.bold( 'Usage:' ), 'mflowgen stash push',
                                  '--step/-s <int> --message/-m "<str>"' )
      print()
      print( s.bold( 'Example:' ), 'mflowgen stash push',
                                    '--step 5 -m "foo bar"'              )
      print()
      print( 'Pushes a built step to the mflowgen stash. The given step' )
      print( 'is copied to the stash using archive mode (preserves all'  )
      print( 'permissions) while following all symlinks. Then the'       )
      print( 'stashed copy is given a hash stamp and is marked as'       )
      print( 'authored by $USER (' + author + '). An optional message'   )
      print( 'can also be attached to the push.'                         )
      print()

    if help_ or not step or not msg:
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
      print( s.bold( 'Error:' ), 'No build directory found for step',
                                  '{}'.format( step ) )
      sys.exit( 1 )

    # Create a unique name for the stashed copy of this step

    today       = datetime.today()
    datestamp   = datetime.strftime( today, '%Y-%m%d' )
    hashstamp   = s.gen_unique_hash()
    step_name   = '-'.join( push_target.split('-')[1:] )

    dst_dirname = '-'.join( [ datestamp, step_name, hashstamp ] )

    # Now copy src to dst
    #
    # - symlinks                 = False # Follow all symlinks
    # - ignore_dangling_symlinks = False # Stop with error if we cannot
    #                                    #  follow a link to something
    #                                    #  we need
    #

    remote_path = s.get_stash_path() + '/' + dst_dirname

    try:
      shutil.copytree( src      = push_target,
                       dst      = remote_path,
                       symlinks = False,
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
      print( s.bold( 'Error:' ), 'Failed to complete stash push' )
      shutil.rmtree( path = remote_path, ignore_errors = True ) # clean up
      raise

    # Update the metadata in the stash

    push_metadata = {
      'date'   : datestamp,
      'dir'    : dst_dirname,
      'hash'   : hashstamp,
      'author' : author,
      'step'   : step_name,
      'msg'    : msg,
    }

    s.stash.append( push_metadata )
    s.update_stash()

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
      print( s.bold( 'Usage:' ), 'mflowgen stash pull --hash <hash>'     )
      print()
      print( s.bold( 'Example:' ), 'mflowgen stash pull --hash 3e5ab4'   )
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
      print( s.bold( 'Error:' ), 'The currently configured graph',
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
      print( s.bold( 'Error:' ), 'Failed to complete stash pull' )
      raise

    # Mark the new step as pre-built with a ".prebuilt" flag

    with open( build_dir + '/.prebuilt', 'w' ) as fd: # touch
      pass

    print(
      'Pulled step "{step}" from stash into "{dir_}"'.format(
      step      = step,
      dir_      = build_dir,
    ) )

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
      print( s.bold( 'Usage:' ), 'mflowgen stash drop --hash <hash>'   )
      print()
      print( s.bold( 'Example:' ), 'mflowgen stash drop --hash 3e5ab4' )
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
      print( s.bold( 'Error:' ), 'Failed to complete stash drop' )
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

  def launch_help( s, help_ ):
    print()
    print( s.bold( 'Stash Commands' ) )
    print()
    print( s.bold( ' - init :' ), 'Initialize a stash'                                )
    print( s.bold( ' - link :' ), 'Link the current build graph to an existing stash' )
    print()
    print( s.bold( ' - push :' ), 'Push a built step to the stash'                    )
    print( s.bold( ' - pull :' ), 'Pull a built step from the stash'                  )
    print( s.bold( ' - drop :' ), 'Remove a built step from the stash'                )
    print()
    print( s.bold( ' - list :' ), 'List all pre-built steps in the stash'             )
    print( s.bold( ' - help :' ), 'Print this help message'                           )
    print()
    print( 'Run any command with -h to see more details'                 )
    print()


