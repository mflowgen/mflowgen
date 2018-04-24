# NOTE: Tried skipping area optimization to prevent DC from optimizing
# stuff away in the PLL that we need. But for some reason, if we skip area
# optimization, then Innovus postroute dies saying the design is not
# routed.

#set DC_SKIP_OPTIMIZE_NETLIST TRUE

