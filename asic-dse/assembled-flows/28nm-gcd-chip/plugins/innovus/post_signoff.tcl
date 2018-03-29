#=========================================================================
# post_signoff.tcl
#=========================================================================
# This plug-in script is called after the corresponding Innovus flow step

# Write SDF for back-annotated gate-level simulation

write_sdf $vars(results_dir)/$vars(design).sdf

# Write netlist for LVS
# Exclude physical cells that have no devices in them

set lvs_exclude_list "[dbGet -u -e top.physInsts.cell.name FILL1*] \
                      [dbGet -u -e top.physInsts.cell.name FILL2*] \
                      [dbGet -u -e top.physInsts.cell.name FILLTIE*] \
                      [dbGet -u -e top.physInsts.cell.name ENDCAPTIE*] \
                      [dbGet -u -e top.physInsts.cell.name PAD*] \
                      [dbGet -u -e top.physInsts.cell.name PCORNERE*] \
                      [dbGet -u -e top.physInsts.cell.name PFILLERE*]"

saveNetlist -excludeLeafCell -phys -excludeCellInst $lvs_exclude_list $vars(results_dir)/$vars(design).lvs.v

# Write netlist for GL simulation

saveNetlist -excludeLeafCell $vars(results_dir)/$vars(design).vcs.v

# Write LEF for hierarchical bottom-up design

write_lef_abstract -specifyTopLayer $vars(max_route_layer) \
                   -PGPinLayers {8 9}                      \
                   -noCutObs -stripePin                    \
                   $vars(results_dir)/$vars(design).lef

# Save DEF for use in running DC again

defOut $vars(results_dir)/$vars(design).def.gz

