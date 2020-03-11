ADK Paths
==========================================================================

ADKs can be located anywhere in the file system. There is a list of search paths that mflowgen uses to locate an ADK, set up to mirror how Python "sys.path" works:

    >>> from mflowgen.components import Graph
    >>> g = Graph()
    >>> print( g.sys_path )
    ['../adks']

The default search path only contains the top-level "adks" directory in the mflowgen repo.

There are two ways to add to the search path:

1. Python (i.e., in construct.py)

    >>> g = Graph()
    >>> g.sys_path.append( '/path/to/adk/search/path' )

2. With the MFLOWGEN_PATH environment variable (analagous to PYTHONPATH):

    % export MFLOWGEN_PATH=/path1:/path2:/path/to/adk/search/path

If mflowgen cannot find an adk at configure time, it will throw an OSError:

    % ../configure
    OSError: Could not find adk "foobar-45nm" in system paths: ['../adks']


