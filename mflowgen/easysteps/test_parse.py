#!/usr/bin/env python3

##############################################################################
# Capture stdout from a function call. Stolen verbatim from stackoverflow.
# To use:
#    with Capturing() as output: do_something()
#    for o in output: print(o)

from io import StringIO
import sys
class Capturing(list):
    def __enter__(self):
        self._stdout = sys.stdout
        sys.stdout = self._stringio = StringIO()
        return self
    def __exit__(self, *args):
        self.extend(self._stringio.getvalue().splitlines())
        del self._stringio # free up some memory
        sys.stdout = self._stdout

##############################################################################
# Compare node list to expected result

import re
def canonicalize(string):
    # Replace each lines leading space with canonical "  "
    # Trim trailing space on each line
    # Trim leading/trailing newlines
    string = re.sub('^( *\n *)*', '    ', string)
    string = re.sub('( *\n *)*$', '', string)
    string = re.sub(' *\n', '\n    ', string)
    string = re.sub('\n *', '\n    ', string)

    return string



# import inspect
def do_test(nodes, expect, skip_assert=0):

    # For nice output do 'pytest -v' or 'pytest -vs'
    #    pytest -vs | sed 's/^test_parse.py/------------------------------------------------------------------------\ntest_parse.py/' |& less

    # callee_name = inspect.stack()[1].function
    # print(f'\n================ TEST: {callee_name} ================')
    print('\n')

    # Capture the node array as a newline-separated string
    with Capturing() as output: nodes.show_all_nodes()
    output = '\n'.join(output)
    output = '\n' + output + '\n'

    # Canonicalize the strings
    output = canonicalize(output)
    expect = canonicalize(expect)
#     output = re.sub('\n *', '\n  ', output); output = re.sub(' *\n', '\n  ', output)
#     expect = re.sub('\n *', '\n  ', expect); expect = re.sub(' *\n', '\n  ', expect)

    # print("------------------------------------------------------------------------")
    print(f'expect=\n{expect}')
    # print("------------------------------------------------------------------------")
    print(f'output=\n{output}')
    # print("------------------------------------------------------------------------")

    if not skip_assert: assert output == expect



##############################################################################
# The tests

from mflowgen.utils           import ParseNodes
def test_e1():
    e1="""
        custom_init - custom-init     -> init
    """
    expect = """
        00 custom_init ( custom-init ) -> ['init']
    """
    # Parse the nodelist string
    nodes = ParseNodes(e1); do_test(nodes, expect)


def test_simple():
    nodelist="a - b -> c d e;a1 - b2 -> x y zz"
    expect="""
      00 a  ( b  ) -> ['c', 'd', 'e']
      01 a1 ( b2 ) -> ['x', 'y', 'zz']
    """
    nodes = ParseNodes(nodelist); do_test(nodes, expect)


def test_custom_two_parts():
    custom_nodes = ParseNodes("custom_dc_scripts - custom-dc-scripts -> iflow")
    custom_nodes = ParseNodes("""

    rtl                - ../common/rtl                  -> synth
    constraints        - constraints                    -> synth iflow
    testbench          - ../common/testbench            -> post_pnr_power
    application        - ../common/application          -> post_pnr_power testbench
    post_pnr_power     - ../common/tile-post-pnr-power

    """)
    
    # custom_nodes.show_all_nodes()
    # for n in custom_nodes.node_array:
    #     print(f'{n.name} - {n.step} -> {n.successors}')

    expect="""
      00 rtl            ( ../common/rtl                 ) -> ['synth']
      01 constraints    ( constraints                   ) -> ['synth', 'iflow']
      02 testbench      ( ../common/testbench           ) -> ['post_pnr_power']
      03 application    ( ../common/application         ) -> ['post_pnr_power', 'testbench']
      04 post_pnr_power ( ../common/tile-post-pnr-power ) -> []
    """
    do_test(custom_nodes, expect)

    
def test_extend():
    example_extend="""
        custom_init          - custom-init                           -> init
        custom_power         - ../common/custom-power-leaf           -> power
        custom_genus_scripts - custom-genus-scripts                  -> synth
        custom_flowgen_setup - custom-flowgen-setup                  -> iflow
        genlibdb_constraints - ../common/custom-genlibdb-constraints -> genlibdb

        # Provides script for fixing shorts caused by steps up to and including postroute
        short_fix - ../common/custom-short-fix -> postroute

        # Add custom timing scripts
        custom_timing_assert - ../common/custom-timing-assert -> synth postcts_hold signoff

      """
    nodes = ParseNodes(example_extend)
    expect="""
      00 custom_init          ( custom-init                           ) -> ['init']
      01 custom_power         ( ../common/custom-power-leaf           ) -> ['power']
      02 custom_genus_scripts ( custom-genus-scripts                  ) -> ['synth']
      03 custom_flowgen_setup ( custom-flowgen-setup                  ) -> ['iflow']
      04 genlibdb_constraints ( ../common/custom-genlibdb-constraints ) -> ['genlibdb']
      05 short_fix            ( ../common/custom-short-fix            ) -> ['postroute']
      06 custom_timing_assert ( ../common/custom-timing-assert        ) -> ['synth', 'postcts_hold', 'signoff']
    """
    # do_test(nodes, expect, 1)
    do_test(nodes, expect)

def test_default():
    example="""
        info         - info
        init         - cadence-innovus-init          -> power
        power        - cadence-innovus-power         -> place
        place        - cadence-innovus-place         -> cts
        cts          - cadence-innovus-cts           -> postcts_hold
        postcts_hold - cadence-innovus-postcts_hold  -> route
        route        - cadence-innovus-route         -> postroute
        postroute    - cadence-innovus-postroute     -> signoff
        pt_signoff   - synopsys-pt-timing-signoff    -> post_pnr_power
        genlibdb     - cadence-genus-genlib

        synth - cadence-genus-synthesis       
             -> iflow init power place cts custom_flowgen_setup debugcalibre

        iflow - cadence-innovus-flowsetup     
             -> init power place cts postcts_hold route postroute signoff debugcalibre

        signoff - cadence-innovus-signoff       
               -> drc lvs genlibdb post_pnr_power debugcalibre pt_signoff
    """
    expect="""
      00 info         ( info                         ) -> []
      01 init         ( cadence-innovus-init         ) -> ['power']
      02 power        ( cadence-innovus-power        ) -> ['place']
      03 place        ( cadence-innovus-place        ) -> ['cts']
      04 cts          ( cadence-innovus-cts          ) -> ['postcts_hold']
      05 postcts_hold ( cadence-innovus-postcts_hold ) -> ['route']
      06 route        ( cadence-innovus-route        ) -> ['postroute']
      07 postroute    ( cadence-innovus-postroute    ) -> ['signoff']
      08 pt_signoff   ( synopsys-pt-timing-signoff   ) -> ['post_pnr_power']
      09 genlibdb     ( cadence-genus-genlib         ) -> []
      10 synth        ( cadence-genus-synthesis      ) -> ['iflow', 'init', 'power', 'place', 'cts', 'custom_flowgen_setup', 'debugcalibre']
      11 iflow        ( cadence-innovus-flowsetup    ) -> ['init', 'power', 'place', 'cts', 'postcts_hold', 'route', 'postroute', 'signoff', 'debugcalibre']
      12 signoff      ( cadence-innovus-signoff      ) -> ['drc', 'lvs', 'genlibdb', 'post_pnr_power', 'debugcalibre', 'pt_signoff']
    """
    # do_test(nodes, expect, 1)
    nodes = ParseNodes(example); do_test(nodes, expect)

def test_quickies():
    e1="drc - mentor-calibre-drc  -> debugcalibre"
    e2="lvs - mentor-calibre-lvs  -> debugcalibre"
    e3="drc - cadence-pegasus-drc -> debugcalibre"
    e4="lvs - cadence-pegasus-lvs"
    
    r1="00 drc ( mentor-calibre-drc ) -> ['debugcalibre']\n"
    r2="\n00 lvs ( mentor-calibre-lvs ) -> ['debugcalibre']\n"
    r3="\n00 drc ( cadence-pegasus-drc ) -> ['debugcalibre']\n"
    r4="00 lvs ( cadence-pegasus-lvs ) -> []\n"

    dic = { e1:r1, e2:r2, e3:r3, e4:r4 }
    for key in dic:
        nodes=ParseNodes(key); do_test(nodes, dic[key])

#     for example in [ ex1, ex2, ex3, ex4 ]:
#         nodes = ParseNodes(example); do_test(nodes, expect)













##############################################################################


# with Capturing() as output:
#     test_custom()
#     
# 
# print("FOOJ")
# output = '\n'.join(output); print(output)
# output = '\n' + output + '\n'
# 
# expect = """
#   00 rtl            ( ../common/rtl                 ) -> ['synth']
#   01 constraints    ( constraints                   ) -> ['synth', 'iflow']
#   02 testbench      ( ../common/testbench           ) -> ['post_pnr_power']
#   03 application    ( ../common/application         ) -> ['post_pnr_power', 'testbench']
#   04 post_pnr_power ( ../common/tile-post-pnr-power ) -> []
# """
# 
# print("------------------------------------------------------------------------")
# print(f'expect=.{expect}.')
# print("------------------------------------------------------------------------")
# print(f'output=.{output}.')
# print("------------------------------------------------------------------------")
# 
# 
# assert output == expect




##############################################################################
# OLD
# def do_test():
#     P = ParseNodes();
#     P.do_all_tests()
# 
# 
# def test_answer():
#     assert 1 == 1
#     assert 0 == 1
#     assert do_test() == 5
# 
# def test_test():
#     assert 4 == 4
# 
# 
# def do_test(nodelist, DBG=1):
#     P = ParseNodes();
#     print("\n------------------------------------------------------------------------")
#     # global NODES; NODES = []
#     node_array = []
#     P.parse_nodelist(nodelist, node_array, DBG)
#     print("------------------------------------------------------------------------\n")
#     return node_array


    # print('\n========================================================================')
    # print(callee_name)

    # print("-1-----------------------------------------------------------------------\n")
    # print("\n-1.1---------------------------------------------------------------------\n")
    # print("\n-1.2---------------------------------------------------------------------\n")
    # print("-2----------------------------------------------------------------------")
