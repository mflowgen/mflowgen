This node: 
* Accepts an additional file of SVRF statements as an input (rules.svrf). The most common use case here would be to add LVS BOX commands to blackbox hard macros present in the design

* Globs for all *.spi files in input directory. These files need to be included for all hard macros in design.

* Outputs spice file, for use in downstream hierarchical LVS.
