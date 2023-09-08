import os
import tempfile
import subprocess

this_dir = os.path.dirname( os.path.abspath( __file__ ) )

def configure_build_dir( construct_path, build_dir ):
  os.chdir( build_dir )
  subprocess.check_call( f"mflowgen run --design {construct_path}".split(' ') )
  
  
def test_subgraph_creation():
  construct_path = f"{this_dir}/dummy"
  with tempfile.TemporaryDirectory() as build_dir:
    configure_build_dir( construct_path, build_dir )
