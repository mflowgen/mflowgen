Assertions
==========================================================================

Similar to how assertions can catch run-time exceptions in software,
mflowgen allows you to define Python snippets that assert preconditions
and postconditions before and after nodes to catch unexpected situations
at build time. Assertions are in Python to keep them concise and yet
powerful. The assertions are collected and run with `pytest`_ to allow
customization and user extensibility.

.. _pytest: https://docs.pytest.org/en/latest

.. My dream here is that as you guys run into stupid mistakes, you can
.. STOP, think about an assertion to prevent it from happening ever again,
.. and put that thing in.

.. We can now add assertions throughout our PD flows. This can be a very powerful time saver. Each bug takes hours or days of detective work. I think if we intelligently put effort into certain assertions, you can save big chunks of time over the next weeks and months.

These assertions can be statically defined in a node configuration file or
defined at graph construction time. For example, say we have a simple
synthesis node with a configuration like this:

.. code:: yaml

    name: synopsys-dc-synthesis

    inputs:
      - adk       # Technology files
      - design.v  # RTL

    outputs:
      - design.v  # gate-level netlist

    commands:
      - bash run.sh

We can assert that synthesis should not start unless it sees the
technology files and the RTL design present. If either is missing, the
build will not continue.

.. code:: python

    preconditions:
      - assert File( 'inputs/adk' )        # Technology files must exist
      - assert File( 'inputs/design.v' )   # RTL must exist

Similarly, after synthesis has completed we can assert that the gate-level
netlist exists and that there were no issues resolving references (a
common synthesis error that breaks the build). Again, the build would stop
if the postcondition were to fail.

.. code:: python

    postconditions:
      - assert File( 'outputs/design.v' )  # Gate-level netlist must exist
      - assert 'Unable to resolve' not in File( 'logs/dc.log' )

Each of these items is valid Python code and you can use Python any way
you like to build your own assertions. For convenience, mflowgen natively
provides a ``File`` class that overrides both boolean evaluation and
containment, enabling the concise syntax you see here for checking whether
or not a file exists as well as for using "in" and "not in" to search
within a file. There is also a ``Tool`` class natively available that
overrides boolean evaluation to concisely assert whether a tool exists or
not.

.. code:: python

    preconditions:
      - assert Tool( 'dc_shell-xg-t' )  # check for Design Compiler

The ``File`` Class and ``Tool`` Class
--------------------------------------------------------------------------

The ``File`` class internally handles boolean evaluation simply by calling
``os.path.exists()``, so it can be used to check for existence of both
files and directories.

Additional knobs are available to enable case sensitivity (default is
case-insensitive) and regular expression search (default is disabled):

.. code:: python

    >>> assert 'warning' in File( 'logs/dc.log', enable_case_sensitive = True )
    >>> assert 'warn.*'  in File( 'logs/dc.log', enable_regex          = True )

The ``Tool`` class handles boolean evaluation using the ``shutil.which()``
function from the shell utilities Python library. This is equivalent to
running ``% which foo`` on the command line.

.. code:: python

    >>> assert Tool( 'dc_shell-xg-t' )  # This statement is roughly
                                        # equivalent to this
    % which dc_shell-xg-t               # shell statement

Adding Assertions When Constructing Your Graph
--------------------------------------------------------------------------

The assertions defined in a node configuration file can be extended at
graph construction time, meaning you can add your own design-specific
assertions in each node. You can use the
:py:mod:`Step.extend_preconditions` and
:py:mod:`Step.extend_postconditions` methods to extend either list.

For example, say we wanted to add a check for clock-gating cells as a
postcondition in our synthesis node. We can assert that this cell appears
in the gate-level netlist like this:

.. code:: python

    dc = Step( 'synopsys-dc-synthesis', default=True )
    dc.extend_postconditions([
      "assert 'CKGATE' in File( 'outputs/design.v' )"
    ])

Escaping Special Characters
--------------------------------------------------------------------------

Certain characters are special in YAML syntax and must be escaped if you
want to use them. For example, the following postcondition in the Mentor
Calibre GDS merge node (i.e., "mentor-calibre-gdsmerge") asserts that the
report does not warn about duplicate module definitions (a dangerous
warning that can corrupt your layout):

.. code:: yaml

  postconditions:
    - assert 'WARNING: Ignoring duplicate structure' not in File( 'merge.log' )

Unfortunately, the ``:`` character is a reserved character in YAML syntax
since it is used for key-value stores (i.e., dictionaries in Python). The
easiest way to escape this is not to explicitly escape the character, but
to wrap the entire string in double quotes instead as shown below:

.. code:: yaml

  postconditions:
    - "assert 'WARNING: Ignoring duplicate structure' not in File( 'merge.log' )"

You can search for YAML syntax online to find more information on escaping
characters in YAML files.

Multiline Assertions
--------------------------------------------------------------------------

Writing Python assertions in a single line of Python code can be very
limiting. You can write assertions with multiple lines, but it requires
using the YAML syntax for a block literal (i.e., a multiline string
that preserves newline characters):

.. code:: yaml

  preconditions:
    - |
      import math
      assert math.pi > 3.0

Indentation matters in Python. Fortunately, YAML syntax uses the
indentation of the first line after the ``|`` character to derive the
indentation of all the following lines. So this entry correctly represents
the following Python code:

.. code:: python

    >>> import math
    >>> assert math.pi > 3.0

The pytest function that mflowgen generates looks like this:

.. code:: python

  def test_0_():
    import math
    assert math.pi > 3.0

Note that if you write a multiline entry without the ``|`` marker, YAML
will simply wrap the lines as if there were no newlines:

.. code:: python

  preconditions:
    - import math
      assert math.pi > 3.0

This is read as a single string, which is not valid Python:

.. code:: python

    >>> import math assert math.pi > 3.0

Defining Python Helper Functions
--------------------------------------------------------------------------

You can provide your own Python helper functions to extract information
about your build which you can use in assertions.

For example, suppose we want to assert that synthesis has successfully
clock-gated the majority of registers in the design. The clock-gating
report looks like this:

.. code::

                       Clock Gating Summary
    ------------------------------------------------------------
    |    Number of Clock gating elements    |        2         |
    |                                       |                  |
    |    Number of Gated registers          |    32 (94.12%)   |
    |                                       |                  |
    |    Number of Ungated registers        |     2 (5.88%)    |
    |                                       |                  |
    |    Total number of registers          |       34         |
    ------------------------------------------------------------

You can write a Python helper function that extracts the 94.12% figure:

.. code:: python

    # assertion_helpers.py

    # percent_clock_gated
    #
    # Reads the clock-gating report and returns a float representing the
    # percentage of registers that are clock gated.
    #

    def percent_clock_gated():

      # Read the clock-gating report

      with open( glob('reports/*clock_gating.rpt')[0] ) as fd:
        lines = fd.readlines()

      # Get the line with the clock-gating percentage, which looks like this:

      gate_line = [ l for l in lines if 'Number of Gated registers' in l ][0]

      # Extract the percentage between parentheses

      percentage = float( re.search( r'\((.*?)%\)', gate_line ).group(1) )/100

      return percentage

Then you can assert a postcondition in the node configuration for a
clock-gating percentage of at least 80%:

.. code:: python

    postconditions:

      # Check that at least 80% of registers were clock-gated

      - |
        from assertion_helpers import percent_clock_gated
        assert percent_clock_gated() > 0.80

Using Custom pytest Files
--------------------------------------------------------------------------

You can write your own pytest functions and include them in your node (or
attach them as inputs). Then you can drop them in your node configuration
file using the ``pytest:`` key as special syntax:

.. code:: yaml

  preconditions:
    - pytest: test_foo.py
    - pytest: inputs/test_bar.py

These tests will then be collected and automatically run with all the
other assertions.

Assertion Scripts in mflowgen
--------------------------------------------------------------------------

When executing a node, mflowgen generates two scripts,
``mflowgen-check-preconditions.py`` and
``mflowgen-check-postconditions.py``, puts them in the build directory,
and then runs these scripts before and after executing the node. At
run time if the postcondition check fails, re-running the node (e.g.,
``make 4``) will only re-run the postcondition check. It will **not**
re-execute the node. This gives you the chance to enter the sandbox and
fix things until the postconditions pass. The build status will not be
marked "done" until all postcondition checks pass.

.. note::

    To completely re-run a node, you should clean that node. For example
    if synthesis is node 4, ``make clean-4`` and ``make 4`` will do a
    clean rebuild of synthesis.

The two assertion scripts can also be run independently with pytest. The
example below shows a precondition assertion firing and saying that
Synopsys Design Compiler (i.e., ``dc_shell-xg-t``) is missing. You can
re-run the check yourself with default pytest options:

.. code:: bash

    % cd 4-synopsys-dc-synthesis
    % ./mflowgen-check-preconditions.py

        > Checking preconditions for step "synopsys-dc-synthesis"

    pytest -q -rA --disable-warnings --tb=no --color=no ./mflowgen-check-preconditions.py
    F...                                                                                      [100%]
    ==================================== short test summary info ====================================
    PASSED mflowgen-check-preconditions.py::test_1_
    PASSED mflowgen-check-preconditions.py::test_2_
    PASSED mflowgen-check-preconditions.py::test_3_
    FAILED mflowgen-check-preconditions.py::test_0_ - AssertionError:  assert Tool( 'dc_shell-xg-t' )
    1 failed, 3 passed in 0.05s

Or you can call pytest explicitly with your own arguments for a longer
traceback (although this traceback does not say very much):

.. code:: bash

    % cd 4-synopsys-dc-synthesis
    % pytest -q --tb=short mflowgen-check-preconditions.py

    F...                                                                                      [100%]
    =========================================== FAILURES ============================================
    ____________________________________________ test_0_ ____________________________________________
    mflowgen-check-preconditions.py:44: in test_0_
        assert Tool( 'dc_shell-xg-t' )
    E   AssertionError: assert Tool( 'dc_shell-xg-t' )
    E    +  where Tool( 'dc_shell-xg-t' ) = Tool('dc_shell-xg-t')
    ==================================== short test summary info ====================================
    FAILED mflowgen-check-preconditions.py::test_0_ - AssertionError: assert Tool( 'dc_shell-xg-t' )
    1 failed, 3 passed in 0.17s



