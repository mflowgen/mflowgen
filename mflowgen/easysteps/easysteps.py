#=========================================================================
# easysteps.py
#=========================================================================
# Author : S. Richardson
# Date   : February, 2021

import os
import inspect

from mflowgen.easysteps.parse import ParseNodes
from mflowgen.components.step import Step

# Persistent storage for todo list
_todo    = {}   ;# Connections waiting to be made, used only by easysteps
_extnodes= []   ;# List of extension nodes, used only by easysteps

def add_custom_steps(graph, nodelist_string, DBG=0):
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
    frame = inspect.stack()[1][0]
    if DBG: print("Adding custom steps")
    nodes=ParseNodes(nodelist_string)
    for n in nodes.node_array:
        if DBG: print(f"  Found '{n.name}' - '{n.step}' -> {n.successors}   ")
        step = _add_step_with_handle(graph, frame, n, is_default=False, DBG=DBG)

def extend_steps(graph, nodelist_string, DBG=0 ):
    '''
    # Add 'extension' steps whose sole purpose is to add new inputs to an existing node.
    #
    # EXAMPLE:
    #   extend_steps("custom_init - custom-init -> init")
    #
    # Is shorthand for:
    #    custom_init = Step( this_dir + '/custom-init')
    #    # Add extra input edges to innovus steps that need custom tweaks
    #    init.extend_inputs( custom_init.all_outputs() )
    #    g.add_step( custom_init )
    #    g.connect_by_name( custom_init,  init )
    #
    '''
    if DBG: print("Extending existing steps")
    frame = inspect.stack()[1][0]
    nodes=ParseNodes(nodelist_string)
    for n in nodes.node_array:
        if DBG: print(f"  Found '{n.name}' - '{n.step}' -> {n.successors}   ")
        _extnodes.append(n.name)  ;# Mark this step as an "extend" step
        step = _add_step_with_handle(graph, frame, n, is_default=False, DBG=DBG)

def add_default_steps(graph, nodelist_string, DBG=0):
    "Similar to 'add_custom_steps' but adds 'default=True' parm to Step() def"
    if DBG: print("Adding default steps")
    frame = inspect.stack()[1][0]
    nodes=ParseNodes(nodelist_string)
    for n in nodes.node_array:
        if DBG: print(f"  Found '{n.name}' - '{n.step}' -> {n.successors}   ")
        step = _add_step_with_handle(graph, frame, n, is_default=True, DBG=DBG)

def _add_step_with_handle(graph, frame, node, is_default, DBG=0):
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
      # Also: after step is built, add successors to todo list for later processing
      '''
      stepname   = node.name
      stepdir    = node.step

      # Start a todo list for connections from this node to yet-unresolved nodes
      _todo[stepname] = [] ; # Initialize todo list

      # Check for global/local collision etc
      if stepname in frame.f_locals:
        print(f'**ERROR local var "{stepname}" exists already; cannot build step via parsenode')
        print(f"rtl='{frame[0].f_locals[stepname]}'")
        assert False

      # Build the step and assign the handle
      if not is_default:
        module = inspect.getmodule(frame)
        this_dir = os.path.dirname( os.path.abspath( module.__file__ ) )
        stepdir = this_dir + '/' + stepdir
      # step = Step( this_dir + '/' + stepdir, default=is_default)
      step = Step( stepdir, default=is_default)
      frame.f_globals[stepname] = step

      # Add step to graph
      graph.add_step(step)

      # Add successors to todo list
      for succ_name in node.successors:
        if DBG: print(f"    Adding {stepname}->{succ_name} to todo list")
        _todo[stepname].append(succ_name)

      if DBG: print('')
      return step

def connect_outstanding_nodes(graph, DBG=0):
    '''
    # construct.py should call this method after all steps have been built,
    # to clear out the todo list.
    '''
    print("PROCESSING CONNECTIONS IN TODO LIST")
    frame = inspect.stack()[1][0]
    for from_name in _todo:

        # Only global vars end up on the todo list, so 'from' node must be global
        from_node = frame.f_globals[from_name]

        # Must make shallow copy b/c we may be deleting elements in situ
        to_list = _todo[from_name].copy() ;

        for to_name in to_list:
            if DBG: print(f"  CONNECTING {from_name} -> {to_name}")

            # Don't know (yet) whether to_node is local or global to calling frame (construct.py)
            to_node = _findvar(frame, to_name, DBG)

            # If "from" is an "extension" node, connect all "from" outputs as "to" inputs
            if from_name in list(_extnodes):
              if DBG: print('    Extnode: connecting all outputs to dest node')
              to_node.extend_inputs( from_node.all_outputs() )

            # Connect "from" -> "to" nodes
            graph.connect_by_name(from_node, to_node)
            # if DBG: print(f'    CONNECTED {from_name} -> {to_name}')
            if DBG: print('')
            _todo[from_name].remove(to_name)

            # if DBG: print(f'    REMOVED from todo list: {from_name} -> {to_name}\n')

def _findvar(frame, varname, DBG=0):
    "Search given frame for local or global var 'varname'"

    # print(f"Look for varname '{varname}' among list of frame's locals")
    try:
        value = frame.f_locals[varname] ;# This will fail if local not exists
        if DBG: print(f"    Found local var '{varname}'")
        return value
    except: pass

    # print(f"    {varname} not local, is it global perchance? ", end='')
    try:
        value = frame.f_globals[varname] ;# This will fail if global not exists
        if DBG: print(f"    Found global var '{varname}'")
        return value
    except: pass

    # Give up
    print(f"**ERROR Could not find '{varname}'"); assert False
