Reference: Graph-Building API
==========================================================================

mflowgen provides a Python library for building graphs in the
``construct.py`` for your design. In general, you will only use methods
from the ``Graph`` and ``Step`` classes. The ``Edge`` class is used
internally when you call the various methods that make connections between
nodes in your graph.

Note that for general discussion, we use the words "step" and "node"
interchangeably in the following documentation. However, the python code
defines a :py:mod:`Step` class.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   api-graph
   api-step
   api-edge


