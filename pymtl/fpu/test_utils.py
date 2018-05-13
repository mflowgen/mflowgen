#=========================================================================
# test_utils
#=========================================================================
# Simple helper test functions. This is cut-and-paste from the version in
# pclib with the key difference being this supports a new character (~) to
# identify floating point outpts. The ~ basically ignores the lsb when
# comparing the actual value to the expected value. I had to do this
# because I was having trouble getting the lsb to match for the
# DesignWare multiplier.

from   pymtl       import *
import collections
import re

class RunTestVectorSimError( Exception ):
  pass

#-------------------------------------------------------------------------
# run_test_vector_sim
#-------------------------------------------------------------------------

def run_test_vector_sim( model, test_vectors, dump_vcd=None, test_verilog=False ):

  # First row in test vectors contains port names

  if isinstance(test_vectors[0],str):
    port_names = test_vectors[0].split()
  else:
    port_names = test_vectors[0]

  # Remaining rows contain the actual test vectors

  test_vectors = test_vectors[1:]

  # Setup the model

  model.vcd_file = dump_vcd
  if test_verilog:
    model = TranslationTool( model )
  model.elaborate()

  # Create a simulator

  sim = SimulationTool( model )

  # Reset model

  sim.reset()
  print ""

  # Run the simulation

  row_num = 0
  for row in test_vectors:
    row_num += 1

    # Apply test inputs

    for port_name, in_value in zip( port_names, row ):
      if port_name[-1] != "*" and port_name[-1] != "~":

        # Special case for lists of ports
        if '[' in port_name:
          m = re.match( r'(\w+)\[(\d+)\]', port_name )
          if not m:
            raise Exception("Could not parse port name: {}".format(port_name))
          getattr( model, m.group(1) )[int(m.group(2))].value = in_value
        else:
          getattr( model, port_name ).value = in_value

    # Evaluate combinational concurrent blocks

    sim.eval_combinational()

    # Display line trace output

    sim.print_line_trace()

    # Check test outputs

    for port_name, ref_value in zip( port_names, row ):
      if port_name[-1] == "*" or port_name[-1] == "~":

        # Special case for lists of ports
        if '[' in port_name:
          m = re.match( r'(\w+)\[(\d+)\]', port_name[0:-1] )
          if not m:
            raise Exception("Could not parse port name: {}".format(port_name))
          out_value = getattr( model, m.group(1) )[int(m.group(2))]
        else:
          out_value = getattr( model, port_name[0:-1] )

        # standard case (make sure lsb matches)

        if ( port_name[-1] == '*' ) and ( ref_value != '?' ):
          if out_value != ref_value:

            error_msg = """
 run_test_vector_sim received an incorrect value!
  - row number     : {row_number}
  - port name      : {port_name}
  - expected value : {expected_msg}
  - actual value   : {actual_msg}
"""
            raise RunTestVectorSimError( error_msg.format(
              row_number   = row_num,
              port_name    = port_name,
              expected_msg = ref_value,
              actual_msg   = out_value
            ))

        # special case - we ignore the lsb by OR'ing in a one as the lsb
        # into both the expected and actual values. Since they will both
        # then have a one in the lsb it doesn't really matter what the
        # lsb really is.

        elif ( port_name[-1] == '~' ) and ( ref_value != '?' ):

          if (out_value|1) != (ref_value|1):

            error_msg = """
 run_test_vector_sim received an incorrect value!
  - row number     : {row_number}
  - port name      : {port_name}
  - expected value : {expected_msg}
  - actual value   : {actual_msg}
  - note that this comparison ignores the lsb!
"""
            raise RunTestVectorSimError( error_msg.format(
              row_number   = row_num,
              port_name    = port_name,
              expected_msg = ref_value,
              actual_msg   = out_value
            ))

    # Tick the simulation

    sim.cycle()

  # Extra ticks to make VCD easier to read

  sim.cycle()
  sim.cycle()
  sim.cycle()
