import os
import inspect

from mflowgen.components.step import Step
# from mflowgen.components.edge import Edge
# from mflowgen.utils           import get_top_dir
from mflowgen.utils           import ParseNodes


def add_custom_steps(self, frame, nodelist_string, DBG=0):
    '''
    # Add custom steps
    #
    # EXAMPLE:
    #     g.add_custom_steps("rtl - ../common/rtl -> synth")
    #
    # does this:
    #     rtl = Step( this_dir + '/../common/rtl' )
    #     g.add_step( rtl )
    #     g.connect_by_name( rtl, synth )
    #
    # BIGGER EXAMPLE:
    #   g.add_custom_steps("""
    #     rtl                - ../common/rtl          -> synth
    #     constraints        -    constraints         -> synth iflow
    #     custom_dc_scripts  -    custom-dc-scripts   -> iflow
    #     testbench          - ../common/testbench    -> post_pnr_power
    #     application        - ../common/application  -> post_pnr_power testbench
    #     post_pnr_power     - ../common/tile-post-pnr-power
    #   """)
    '''
    if DBG: print("Adding custom steps")
    module = inspect.getmodule(frame); print(f"foofile {module.__file__}")
    nodes=ParseNodes(nodelist_string)
    for n in nodes.node_array:
        if DBG: print(f"  Found '{n.name}' - '{n.step}' -> {n.successors}   ")
        step = self._add_step_with_handle(frame, n, is_default=False, DBG=DBG)
        self._build_todo_list(frame, n, DBG)
        if DBG: print('')


def extend_steps(self, frame, nodelist_string, DBG=0 ):
  """
    # EXAMPLE:
          #   extend_steps("custom_init - custom-init -> init")
          # Does this:
          #    custom_init = Step( this_dir + '/custom-init')
          #    # Add extra input edges to innovus steps that need custom tweaks
          #    init.extend_inputs( custom_init.all_outputs() )
          #    g.add_step( custom_init )
          #    g.connect_by_name( custom_init,  init )
    """
  if DBG: print("Extending existing steps")
  nodes=ParseNodes(nodelist_string)
  # frame = inspect.stack()[1][0]
  for n in nodes.node_array:
    if DBG: print(f"  Found '{n.name}' - '{n.step}' -> {n.successors}   ")
    self._extnodes.append(n.name)  ;# Mark this step as an "extend" step
    step = self._add_step_with_handle(frame, n, is_default=False, DBG=DBG)
    self._build_todo_list(frame, n, DBG)
    if DBG: print('')

        
def add_default_steps(self, frame, nodelist_string, DBG=0):
    "Similar to 'add_custom_steps' but adds 'default=True' parm to Step() def"
    if DBG: print("Adding default steps")
#     frame = inspect.stack()[1][0]
    nodes=ParseNodes(nodelist_string)
    for n in nodes.node_array:
      if DBG: print(f"  Found '{n.name}' - '{n.step}' -> {n.successors}   ")
      step = self._add_step_with_handle(frame, n, is_default=True, DBG=DBG)
      self._build_todo_list(frame, n, DBG)
      if DBG: print('')

def _add_step_with_handle(self, frame, node, is_default, DBG=0):
      '''
      # Given a node with a stepname and associated dir, build the
      # step and make a handle for the step in the calling frame
      # Nota bene: the handle will be a GLOBAL variable!
      #
      # Example:
      #     frame = inspect.stack()[0]
      #     g.add_step_with_handle( 'rtl',  '/../common/rtl' )
      #
      # Does this:
      #     rtl = Step( this_dir + '/../common/rtl' )
      #     g.add_step( rtl )
      #
      # Also: after step is built, checks todo list to see if
      # anyone is waiting to connect to this step.
      '''
      stepname   = node.name
      stepdir    = node.step

      # Start a todo list for connections from this node to yet-unresolved nodes
      self._todo[stepname] = [] ; # Initialize todo list

      # Check for global/local collision etc
      if stepname in frame.f_locals:
        print(f'**ERROR local var "{stepname}" exists already; cannot build step via parsenode')
        print(f"rtl='{frame[0].f_locals[stepname]}'")
        exit(13)

      # Build the step and assign the handle
      if not is_default:
        module = inspect.getmodule(frame)
        this_dir = os.path.dirname( os.path.abspath( module.__file__ ) )
        stepdir = this_dir + '/' + stepdir
      # step = Step( this_dir + '/' + stepdir, default=is_default)
      step = Step( stepdir, default=is_default)
      frame.f_globals[stepname] = step

      # Add step to graph
      self.add_step(step)
      return step

def _build_todo_list(self, frame, node, DBG=0):
      '''
      Given a node containing a list of successors, check each successor
      to see if it exists in the calling frame yet. If so, connect them; 
      otherwise, add it to a todo-list for later.
      '''
      node_name = node.name
      for succ_name in node.successors:
        if DBG: print(f"    Adding {node_name}->{succ_name} to todo list")
        self._todo[node_name].append(succ_name)

def connect_outstanding_nodes(self, frame, DBG=0):
    '''
    # construct.py should call this method after all steps have been built,
    # to clear out the todo list.
    '''
#     frame = inspect.stack()[1][0]
    print("PROCESSING CONNECTIONS IN TODO LIST")
    for from_name in self._todo:

      # Must make shallow copy b/c we may be deleting elements in situ
      to_list = self._todo[from_name].copy() ;
      for to_name in to_list:
        if DBG: print(f"  CONNECTING {from_name} -> {to_name}")
        self._connect_from_to(frame, from_name, to_name, DBG)
        self._todo[from_name].remove(to_name)
        # if DBG: print(f'    REMOVED from todo list: {from_name} -> {to_name}\n')

def _connect_from_to(self, frame, from_name, to_name, DBG=0):
      '''
      Given names for "from" and "to" nodes, try and connect the two.
      If the "to" node does not exist (yet) in the given calling frame,
      return "False".
      '''
      # Only global vars end up on the todo list, so 'from' node must be global
      from_node = frame.f_globals[from_name]
      to_node   = self._findvar(frame, to_name, DBG)

      # If it's an "extension" node, connect all "from" outputs as "to" inputs
      if from_name in list(self._extnodes):
        if DBG: print(f'    Extnode: connecting all outputs to dest node')
        to_node.extend_inputs( from_node.all_outputs() )

      # Connect "from" -> "to" nodes
      self.connect_by_name(from_node, to_node)
      # if DBG: print(f'    CONNECTED {from_name} -> {to_name}')
      if DBG: print('')


def _findvar(self, frame, varname, DBG=0):
    """Search given frame for local or global var with called 'varname'"""
    try:
      value = frame.f_locals[varname] ;# This will fail if local not exists
      if DBG: print(f"    Found local var '{varname}'")
      return value
    except: pass

    # if DBG: print(f"    {varname} not local, is it global perchance? ", end='')
    try:
      value = frame.f_globals[varname] ;# This will fail if global not exists
      if DBG: print(f"    Found global var '{varname}'")
      return value
    except: pass

#     if DBG: print('')
    print(f"**ERROR Could not find '{varname}'"); exit(13)
# 
# 
#     if DBG: print("\n    not global either; guess it's not plugged in yet")
#     return None






##############################################################################
# OLD CODE see ~/tmpdir/easysteps.py.old
