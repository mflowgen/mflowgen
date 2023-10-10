import os
import tempfile
import subprocess
import glob

this_dir = os.path.dirname( os.path.abspath( __file__ ) )
dummy_construct_path = f"{this_dir}/dummy"
dummy_double_pt_construct_path = f"{this_dir}/dummy_double_passthrough"

def configure_build_dir( construct_path, build_dir ):
  os.chdir( build_dir )
  subprocess.check_call( f"mflowgen run --design {construct_path}".split(' ') )
  
 
def test_subgraph_creation():
  with tempfile.TemporaryDirectory() as build_dir:
    configure_build_dir( dummy_construct_path, build_dir )


def test_subgraph_make_subtarget():
  with tempfile.TemporaryDirectory() as build_dir:
    configure_build_dir( dummy_construct_path, build_dir )
    subprocess.check_call( 'make passthrough-passthrough'.split(' ') )


def test_subgraph_status():
  with tempfile.TemporaryDirectory() as build_dir:
    configure_build_dir( dummy_construct_path, build_dir )
    subprocess.check_call( 'make status'.split(' ') )


def test_subgraph_subgraph_status():
  with tempfile.TemporaryDirectory() as build_dir:
    configure_build_dir( dummy_construct_path, build_dir )
    subprocess.check_call( 'make passthrough-status'.split(' ') )


def test_subgraph_input_fanout():
  with tempfile.TemporaryDirectory() as build_dir:
    configure_build_dir( dummy_double_pt_construct_path, build_dir )
    subprocess.check_call( 'make dummy_output'.split(' ') )
    pt_1_inputs_dir = glob.glob( f"{build_dir}/*-double_passthrough/*-passthrough/inputs" )[0]
    pt_2_inputs_dir = glob.glob( f"{build_dir}/*-double_passthrough/*-passthrough_2/inputs" )[0]
    assert os.path.exists( f"{pt_1_inputs_dir}/i" )
    assert os.path.exists( f"{pt_2_inputs_dir}/i" )
