#!/usr/bin/env python3
import re;

# Example:
#   custom_nodes = ParseNodes("""
# 
#     rtl                - ../common/rtl                  -> synth
#     constraints        - constraints                    -> synth iflow
#     testbench          - ../common/testbench            -> post_pnr_power
#     application        - ../common/application          -> post_pnr_power testbench
#     post_pnr_power     - ../common/tile-post-pnr-power
# 
#   """)
#
#   custom_nodes.addnode("custom_dc_scripts - custom-dc-scripts -> iflow")
#   for n in custom_nodes.node_array:
#       print(f'{n.name} - {n.step} -> {n.successors}')

class ParseNodes:

    # Syntax:
    # 
    #  <node> "-" <step> [ "->" <list of successor nodes> ]
    # 
    # Newlines are ignored, as are right-arrows (" -> ") and semicolons.
    # Pound-sign introduces a comment that extends to end of line.
    # 
    # Examples:
    # 
    #     info - info
    #     genlibdb     - cadence-genus-genlib         
    #     init         - cadence-innovus-init         -> power
    #     power        - cadence-innovus-power        -> place
    #     place        - cadence-innovus-place        -> cts
    #     cts          - cadence-innovus-cts          -> postcts_hold
    #     postcts_hold - cadence-innovus-postcts_hold -> route
    #     route        - cadence-innovus-route        -> postroute
    #     postroute    - cadence-innovus-postroute    -> signoff
    #     pt_signoff   - synopsys-pt-timing-signoff   -> post_pnr_power
    # 
    #     # Comment
    #     synth - cadence-genus-synthesis      
    #     -> iflow init power place cts custom_flowgen_setup debugcalibre
    # 
    #     iflow - cadence-innovus-flowsetup    
    #     -> init power place cts postcts_hold route postroute signoff debugcalibre
    # 
    #     signoff - cadence-innovus-signoff      
    #     -> drc lvs genlibdb post_pnr_power debugcalibre pt_signoff

    def __init__(self, nodestring="", DBG=0):
        self.node_array = []
        self.node_array = self.parse_nodelist(nodestring, self.node_array, DBG)


    def show_all_nodes(self):
        node_array = self.node_array

        # Calculate field widths
        wname=0; wstep=0
        for n in node_array:
            if len(n.name) > wname: wname=len(n.name)
            if len(n.step) > wstep: wstep=len(n.step)
            # print(n.step, len(n.step))

        # Print nice columns
        i=0
        for n in node_array:
            step=f"{n.step}"
            print(f"  {i:02} {n.name:{wname}} ( {step:{wstep}} ) -> {n.successors}")
            i=i+1

        return()

    def parse_error(self, errmsg):
        print(f"**ERROR {errmsg}"); assert False

    # Private data structure for nodes
    class _ParseNode:
        def __init__(self, name, step, successors):
            self.name = name
            self.step = step
            self.successors = successors

        def __repr__(self):
            s=f"({self.step})"
            w=16
            return(f"{self.name:{w}} {s:25} -> {self.successors}")

    def _canonicalize(self, nodelist, DBG=0):
        # Canonicalize the nodelist;
        # - get rid of comments (TODO)
        # - get rid of right-arrows, they're just noise
        # - make sure list begins and ends with a single space char
        # - collapse all whitespace down to a single space char

        if DBG: print(f"nodelist0='{nodelist}'")
        nodelist = re.sub(r'[#][^\n]*', ' ', nodelist); # Comments
        nodelist = nodelist.replace(" -> ", " ");       # Pesky right-arrow
        nodelist = nodelist.replace(";", " ");          # Get rid of semicolons why not
        nodelist = re.sub(r'\s+', ' ', " " + nodelist + " "); # Whitespace inc. newlines
        if DBG: print(f'nodelist1="{nodelist}"')

        return nodelist


    def parse_nodelist(s, nodelist, node_array, DBG=0):
        """
        Given a nodelist string
          - parse the string
          - add the resulting list of nodes to array "nodes"
          - return the final array
        """

        nodelist = s._canonicalize(nodelist)


        if nodelist == ' ':
            print('no nodelist')
            return []

        # Build a dictionary of nodes, steps, and successor nodes
        i=-1
        while (nodelist != ""):  # Repeat until string is empty

            # Prevent infinite loops
            i = i + 1
            max_nodes=1000
            if (i > max_nodes):
                parse_error(f"too many nodes! max = {max_nodes}")
                break

            # Little debugging
            if DBG>2: print("")
            if DBG>2: print(f"{i:03} nodelist = '{nodelist}'")

            # Grab first (word-dash-word) pair e.g. "lvs - cadence-pegasus-lvs"
            wdw_dotstar = r"^ (\S+) [-] (\S+)(.*)$"
            f = re.search(wdw_dotstar, nodelist)
            if not f: 
                s.parse_error("malformed string?")
            nodename = f.group(1)
            step     = f.group(2)
            remain   = f.group(3)
            if DBG>1: print(f"{i:02} found nodename '{nodename}', step '{step}'")
            if DBG>2: print(f"    remainder '{remain}'")

            #         node_array.append("foo"); 

            node = s._ParseNode(nodename, step, [])
            node_array.append(node)

            # Are we done?
            if (remain == " "):
                if DBG: print("DONE!")
                break

            # Not done. Look for optional successor list.
            # While remainder contains (word <not-dash>) pattern, add word to list
            ww = r'^ (\S+)( [^-].*)$'
            f = re.search(ww, remain)
            while (f):
                succ=f.group(1); node.successors.append(succ)
                if DBG>1: print(f"  found successor '{succ}'")
                remain = f.group(2)
                f = re.search(ww, remain)
                if DBG>2: print(f"    remain= '{remain}'\n    {f}")


            # If next pattern is (word - word), then it's time to loop back
            if DBG>2: print(f"  searching '{remain}' for w-w")
            if re.search(wdw_dotstar, remain):
                nodelist = remain
                continue

            # Else we might be done, or almost

            # Should be one final optional successor node in list
            f = re.search(r'^ (\S+) $', remain)
            if f:
                succ=f.group(1); node.successors.append(succ)
                if DBG>1: print(f"  found successor '{succ}' (final)")
                break

            else:
                parse_error("malformed string? missing final successor node")

        if DBG:
            print("RESULT")
            # s.show_all_nodes(node_array)
            s.show_all_nodes()
            # print(f"-- END   parse_node ----------------------------------------")

        return(node_array)
