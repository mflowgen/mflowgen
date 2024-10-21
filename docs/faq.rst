Frequently Asked Questions
==========================================================================

My builds are continuing on to the next node despite errors in this node?
--------------------------------------------------------------------------

Builds will stop for errors if the shell exit status (i.e., ``$?``) is
detected to be non-zero. This is standard shell behavior and a Makefile
will automatically stop if any command fails.

You can check the exit status like this:

.. code:: bash

    % bash -c "exit 0"
    % echo $?
    0

    % bash -c "exit 1"
    % echo $?
    1

    % bash -c "non_existent_command"
    bash: non_existent_command: command not found
    % echo $?
    127

    % bash -c "echo abc"
    abc
    % echo $?
    0

If you add the command ``exit 1`` to a node (i.e., exiting with an error)
then the entire build will error out and will certainly not continue to
the next nodes. For example, say we added this to the synthesis node:

.. code::

    name: synopsys-dc-synthesis

    (...)

    commands:
      - exit 1
      - (...)

There would be an error and the build would not continue:

.. code:: bash

    % make 4
    make: *** [4-synopsys-dc-synthesis/.execstamp] Error 1

Remember you can check ``make status`` to see whether a node will build or
not. By adding ``exit 1``, the synthesis status will never be "done"
(in green). It will always show "build" (in red):

.. code:: bash

    % make status
    (...)
     - build -> 4  : synopsys-dc-synthesis

Most issues arise when you are calling a script which has errors but does
not propagate the exit code to the caller. For example, say the synthesis
node runs a script called ``run.sh``:

.. code::

    name: synopsys-dc-synthesis

    (...)

    commands:
      - bash run.sh  # <-- errors inside but does not propagate exit code

The script has the following contents:

.. code:: bash

    % non_existent_command
    % echo "hi"  # <-- valid with no errors... masks exit status of script

Upon running this node, you will see the error but the script will continue on to
print "hi" and execute future nodes:

.. code::

    % make 4
    run.sh: line 1: non_existent_command: command not found
    hi

You can instead have the script exit with an error exit status like this:

.. code:: bash

    % non_existent_command || exit 1
    % echo "hi"  # we never get here because we exit after the error

You will see the error, but the following commands will not run, and the
build will also stop:

.. code::

    % make 4
    run.sh: line 1: non_existent_command: command not found
    make: *** [4-synopsys-dc-synthesis/.execstamp] Error 1

There are many ways to propagate exit status properly in a shell script.
We recommend explicitly controlling exits for errors on the commands you
know are sensitive as shown above. Because mflowgen run scripts have error
checking flags enabled, we recommend sourcing scripts instead of calling
them in a subshell:

.. code::

    name: synopsys-dc-synthesis

    (...)

    commands:
      - bash   run.sh  # <-- not recommended.. you must propagate error
                       #     exit status flags on your own
      - source run.sh  # <-- we recommend to source in the existing shell

Related options for bash are available to `exit on non-zero exit status
<https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html#The-Set-Builtin>`__
(``set -e``:) and for `enabling pipefail
<https://www.gnu.org/software/bash/manual/html_node/Pipelines>`__ (``set
-o pipefail``).

