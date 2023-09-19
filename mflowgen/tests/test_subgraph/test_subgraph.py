import os
import tempfile
import subprocess

this_dir = os.path.dirname( os.path.abspath( __file__ ) )
dummy_construct_path = f"{this_dir}/dummy"

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
  
