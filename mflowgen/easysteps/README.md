# EASYSTEPS - Simpler step  creation

So...for some time now I have thought it would be useful to simplify the way we build `construct.py` scripts for new flows...it seemed to me that there was a lot of duplicated/unnecessary extra effort involved for various simple tasks. So I built the "easysteps" package.

Without easysteps, adding a node/step involves modifying your `construct.py` script in three separate places, once to define the node, once to add the node to the graph, and once to connect it to the other nodes in the graph. For example, adding a couple of default nodes `iflow` and `init` currently looks like the code below (all "before" examples are taken from [Tile_PE/construct.py](https://github.com/StanfordAHA/garnet/blob/master/mflowgen/Tile_PE/construct.py) in StanfordAHA's `garnet` repo).

```
  # Adding default nodes BEFORE:

  iflow  = Step( 'cadence-innovus-flowsetup',  default=True )
  init   = Step( 'cadence-innovus-init',       default=True )
  power  = Step( 'cadence-innovus-power',      default=True )

  ...
  g.add_step( iflow )
  g.add_step( init  )
  g.add_step( power )
  ...
  g.connect_by_name( iflow,    init         )
  g.connect_by_name( iflow,    power        )
  g.connect_by_name( iflow,    place        )
  g.connect_by_name( iflow,    cts          )
  g.connect_by_name( iflow,    postcts_hold )
  g.connect_by_name( iflow,    route        )
  g.connect_by_name( iflow,    postroute    )
  g.connect_by_name( iflow,    signoff      )
  g.connect_by_name( init,     power        )
  ...
  g.connect_by_name( power,        place        )
```

Easysteps combines all these steps in a single place in the script, e.g.
```
  # Adding default nodes AFTER:

  g.add_default_steps('''
    init  - cadence-innovus-init  -> power
    power - cadence-innovus-power -> place
    iflow - cadence-innovus-flowsetup
          -> init power place cts postcts_hold
          -> route postroute signoff debugcalibre
    ''')
```
The string passed to this new function `add_default_steps()`, yaml-like in simplicity, gets parsed and expanded, invisibly to the user, into the full `Step()/add_step()/connect_by_name()` sequence.

Similarly, code for custom nodes changes as follows
```
  # Custom nodes BEFORE

  rtl          = Step( this_dir + '/../common/rtl' )
  constraints  = Step( this_dir + '/constraints'   )
  ...
  g.add_step( rtl         )
  g.add_step( constraints )
  ...
  g.connect_by_name( rtl,         synth )
  g.connect_by_name( constraints, synth )
  g.connect_by_name( constraints, iflow )
  ...

---
  # Custom nodes AFTER

  g.add_custom_steps('''
    rtl         - ../common/rtl -> synth
    constraints - constraints   -> synth iflow
    ''')
```
...and then this, for something I call "custom extend-only nodes,"
where a custom extend-only step is a new node whose only purpose is to
supply extra custom inputs to an existing node.
```
  # Custom extend-only nodes BEFORE

  custom_init  = Step( this_dir + '/custom-init'                           )
  custom_power = Step( this_dir + '/../common/custom-power-leaf'           )
  ...
  init.extend_inputs( custom_init.all_outputs() )
  power.extend_inputs( custom_power.all_outputs() )
  ...
  g.add_step( custom_init  )
  g.add_step( custom_power )
  ...
  g.connect_by_name( custom_init,  init  )
  g.connect_by_name( custom_power, power )

---
  # Custom extend-only steps AFTER

  g.extend_steps('''
     custom_init    custom-init                 -> init
     custom_power - ../common/custom-power-leaf -> power
     ''')
---
  # Or, could be done as two separate calls
  
  g.extend_steps('custom-init                 custom_init  -> init')
  g.extend_steps('../common/custom-power-leaf custom_power -> power')
```
