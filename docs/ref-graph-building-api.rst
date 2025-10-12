Reference: Graph-Building API
==========================================================================

mflowgen provides a Python library for building graphs in the
``construct.py`` for your design. In general, you will only use methods
from the ``Graph`` and ``Node`` classes. The ``Edge`` class is used
internally when you call the various methods that make connections between
nodes in your graph.

Note that for general discussion, we use the words "step" and "node"
interchangeably in the following documentation. The python code defines a
:py:mod:`Step` class and a :py:mod:`Node` class which are aliases of each
other. We recommend using the :py:mod:`Node` class. The :py:mod:`Step`
class is deprecated.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   api-graph
   api-node
   api-edge


