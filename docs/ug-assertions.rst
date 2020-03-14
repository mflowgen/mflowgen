Assertions
==========================================================================

Similar to how assertions can catch runtime exceptions in software,
mflowgen allows you to define Python snippets that assert preconditions
and postconditions before and after steps to catch unexpected situations
at build time. These snippets are collected and run with `pytest`_ to
enable customization and user extensibility.

.. _pytest: https://docs.pytest.org/en/latest

These assertions can be statically defined in a step configuration file or
defined at graph construction time. For example, say we have a simple
synthesis node with a configuration like this:

.. code:: yaml

    name: synopsys-dc-synthesis

    inputs:
      - adk
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
if the post-condition were to fail.

.. code:: python

    postconditions:
      - assert File( 'outputs/design.v' )  # Gate-level netlist must exist
      - assert 'Unable to resolve' not in File( 'logs/dc.log' )

Each of these items is valid Python code and you can use Python any way
you like to build your own assertions. For convenience, mflowgen natively
provides a ``File`` class that overrides both boolean evaluation and
containment, enabling the concise syntax you see here for checking whether
or not a file exists as well as for using "in" and "not in" to search
within a file.

The ``shutil`` module is also available by default to allow you to quickly
check whether tools exist:

.. code:: python

    >>> assert shutil.which( 'dc_shell-xg-t' )   # check for Design Compiler

The ``File`` Class
--------------------------------------------------------------------------

The ``File`` class internally handles boolean evaluation simply by calling
``os.path.exists()``, so it can be used to check for existence of both
files and directories.

Additional API is available for case sensitivity (default is
case-insensitive) and regular expression (default is disabled) search:

.. code:: python

    >>> assert 'warning' in File( 'logs/dc.log', enable_case_sensitive = True )
    >>> assert 'warn.*'  in File( 'logs/dc.log', enable_regex          = True )

Adding Assertions When Constructing Your Graph
--------------------------------------------------------------------------

The assertions defined in a step configuration file can be extended at
graph construction time, meaning you can add your own design-specific
assertions to each step. You can use the
:py:mod:`Step.extend_preconditions` and
:py:mod:`Step.extend_postconditions` to extend either list.

For example, say we wanted to add a check for clock-gating cells as a
post-condition in our synthesis step. We can assert that this cell appears
in the gate-level netlist like this:

.. code:: python

    dc = Step( 'synopsys-dc-synthesis', default=True )
    dc.extend_postconditions([
      '''assert 'CK_GATE' in File( 'outputs/design.v' )'''
    ])

Escaping Special Characters
--------------------------------------------------------------------------

Certain characters are special in YAML syntax and must be escaped if you
want to use them. For example, the following postcondition in the Mentor
Calibre GDS merge step (i.e., "mentor-calibre-gdsmerge") asserts that
duplicate module definitions are not reported (a dangerous warning that
can corrupt your layout):

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
indentation of all the following lines. So this entry represents correctly
turns into the following Python code:

.. code:: python

    >>> import math
    >>> assert math.pi > 3.0

The pytest function this generates looks like this:

.. code:: python

  def test_7_():
    try:
      import math
      assert math.pi > 3.0
    except AssertionError as e:
      e.args = ( """ import math  ->  assert math.pi > 3.0 """, )
      raise

Note that if you write a multiline entry without the ``|`` marker, YAML
will simply wrap the lines as if there were no newlines:

.. code:: python

  - import math
    assert math.pi > 3.0

This is read as a single string, which is not valid Python:

.. code:: python

    >>> import math assert math.pi > 3.0

Using Custom pytest Files
--------------------------------------------------------------------------

You can write your own pytest functions and include them in your Step (or
attach them as inputs). Then you can drop them in your step configuration
file using the ``pytest:`` key as special syntax:

.. code:: yaml

  preconditions:
    - pytest: test_foo.py
    - pytest: inputs/test_bar.py

These tests will then be collected and automatically run with all the
other assertions.

Assertion Scripts in mflowgen
--------------------------------------------------------------------------

When executing a step, mflowgen generates two scripts,
``mflowgen-check-preconditions.py`` and
``mflowgen-check-postconditions.py``, puts them in the build directory,
and then runs these scripts before and after running the commands for the
step. At runtime, if the post-condition check fails, re-running the step
(e.g., ``make 4``) will only re-run the post-condition check. It will
**not** trigger a complete rebuild of the step. The build status will not
be marked "done" until all post-condition checks pass.

The two assertion scripts can also be run independently with ``pytest``.
You can re-run the check yourself with default pytest options:

.. code:: bash

    % cd 4-synopsys-dc-synthesis
    % ./mflowgen-check-preconditions.py

Or you can call pytest explicitly with your own arguments:

.. code:: bash

    % cd 4-synopsys-dc-synthesis
    % pytest -v --tb=short mflowgen-check-preconditions.py

