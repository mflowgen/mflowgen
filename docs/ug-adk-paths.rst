ADK Paths
==========================================================================

ADKs can be located anywhere in the file system. Mflowgen uses a list of
search paths to locate an ADK. For those familiar with how Python handles
imports, this is nearly identical to how Python uses "sys.path" to locate
Python packages. The default search path only contains the top-level
"adks" directory in the mflowgen repo:

.. code:: python

    >>> from mflowgen.components import Graph
    >>> g = Graph()
    
    >>> print( g.sys_path )
    ['../adks']

mflowgen iterates through this list to locate the ADK you specify. For
example, say this list had three search paths:

.. code:: python

    [ '../adks', '/path/to/foo', '/path/to/bar' ]

And say we had set the adk to be "freepdk-45nm":

.. code:: python

    >>> g.set_adk( 'freepdk-45nm' )

Trying to locate the 'freepdk-45nm' ADK will result in mflowgen checking
``../adks/freepdk-45nm``, ``/path/to/foo/freepdk-45nm``, and
``/path/to/bar/freepdk-45nm`` in that order.

If mflowgen cannot find an adk at configure time, it will throw an OSError:

.. code:: bash

    % mflowgen run --design ../designs/GcdUnit
    OSError: Could not find adk "foobar-45nm" in system paths: ['../adks']

There are two simple ways to add to the search path:

1. Using Python (i.e., in your construct.py)

.. code:: python

    >>> g = Graph()
    >>> g.sys_path.append( '/path/to/adk/search/path' )

2. Using the $MFLOWGEN_PATH environment variable (this is analagous to
   how Python uses the $PYTHONPATH environment variable):

.. code:: bash

    % export MFLOWGEN_PATH=/path1:/path2:/path/to/adk/search/path


