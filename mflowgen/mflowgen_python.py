#=========================================================================
# mflowgen_python.py
#=========================================================================
# The main function here is meant to "alias" running python from the
# command line:
#
#     % python foo.py --option abc            # <--.
#                                             #     \ _ roughly identical
#                                             #     /
#     % mflowgen-python foo.py --option abc   # <--*
#
# mflowgen ships with python scripts that expect to be able to import from
# mflowgen or its dependencies (e.g., pytest). These dependencies _should_
# be available (after all, mflowgen can only be installed if its
# dependencies are installed). However, it is very common for users to
# have multiple versions of python installed, sometimes surprisingly
# overriding the default. For example, a vendor tool might ship with its
# own version of python3, and running "module load" will cause their
# version to take priority over yours. If we could guarantee that the user
# always runs these scripts with the same version of python in which they
# installed mflowgen, this would not be a problem, but it is difficult to
# make this guarantee.
#
# More specifically, Python portability guides nearly universally suggest
# this shebang at the top of a python script:
#
#     #! /usr/bin/env python3
#
# This shebang uses whatever "python3" corresponds to in your current
# environment and uses it to run your script:
#
#     % ./script-foo  # Runs "python3 script-foo" if shebang is as above
#
# That means if python3 suddenly points to a different version of python3
# than the one mflowgen was installed to, we cannot guarantee we will be
# able to import from mflowgen or its dependencies.
#
# Note: This is only a problem because mflowgen provides executable
#       scripts that run separately and on their own (e.g., assertion
#       scripts), but that still need to access functions from the
#       mflowgen install. Typical Python projects that live entirely in
#       one invocation of Python do not have this issue.
#
# The solution is that in addition to installing "mflowgen" as a command
# line tool, we also install "mflowgen-python" alongside it as another
# command line tool, which is essentially an alias to the version of
# python in which mflowgen was installed. Running any script using this
# "mflowgen-python" command guarantees that the dependencies are available
# and that we can import from mflowgen.
#
# The "main()" function is an entry point in setuptools for a console
# script.
#
# Author : Christopher Torng
# Date   : March 22, 2020
#

import code
import sys

def _mflowgen_python_main():

  # Arguments
  #
  # The argv contents will simply pass to the script being called. We do
  # need to snip this wrapper from the argv list first though
  #

  sys.argv = sys.argv[1:]

  # If no script was given, then drop into the interpreter

  if len( sys.argv ) == 0:
    print()
    print( '( This is an alias to the version of python in which',
           'mflowgen was installed )' )
    print()
    code.interact( local = dict( globals(), **locals() ) )

  # Run
  #
  # Try to open the given python script and execute it
  #
  # - exec is given the locals() so that __name__ is available to the
  #   script that we are running (as both globals and locals)
  #
  # - compile() gets the name of the script "sys.argv[0]" so that the
  #   debug traceback is more readable, showing the script name and line
  #   number within the script instead of some nonsense.
  #
  # - both __name__ and __file__ are set to mimic how it would look if we
  #   were really to run the script in isolation with "python3 foo.py"
  #
  # - no local variables other than __name__ and __file__ are defined here
  #   to reduce any potential conflicts with variables inside the script
  #

  else:

    __name__ = '__main__'
    __file__ = sys.argv[0]
    exec(
      compile( open( sys.argv[0] ).read(), sys.argv[0], 'exec' ),
      locals()
    )


if __name__ == '__main__':
  _mflowgen_python_main()


