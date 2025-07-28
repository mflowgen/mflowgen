# this is just a test
import yaml
import shutil
import os

with open( './configure.yml' ) as fd:
    try:
      data = yaml.load( fd, Loader=yaml.FullLoader )
    except AttributeError:
      # PyYAML for python2 does not have FullLoader
      data = yaml.load( fd )

current_step = data['name']
next_step = data['edges_o']['flow-checkpoint.tar.gz'][0]['step']
print(f"Neighbouring node: {next_step}")

RESULTS_DIR = './flow/results/nangate45/gcd/base'

# Extract the last word from the current and next step name
current_step_suffix = current_step.split('-')[-1]
next_step_suffix = next_step.split('-')[-1]

# Define output variables based on current_step
if "synth" in current_step:
    STEP_OUTPUT_V   = './synth-output.v'
    STEP_OUTPUT_SDC = './synth-output.sdc'
    STEP_OUTPUT_ODB = None  # STEP_OUTPUT_ODB is not assigned any value
elif "custom" in current_step:
    STEP_OUTPUT_V = None  # Only needed for 'synth', so set to None otherwise
    STEP_OUTPUT_SDC = f"./custom-{current_step_suffix}-output.sdc"
    STEP_OUTPUT_ODB = f"./custom-{current_step_suffix}-output.odb"
else:
    STEP_OUTPUT_V = None  # Only needed for 'synth', so set to None otherwise
    STEP_OUTPUT_SDC = f"./{current_step_suffix}-output.sdc"
    STEP_OUTPUT_ODB = f"./{current_step_suffix}-output.odb"

if "orfs" in next_step:
    # Define inputs based on the next step type
    if next_step_suffix == "floorplan":
        NEXT_INPUT_V = RESULTS_DIR + f'/{next_step_suffix}-input.v'
        NEXT_INPUT_SDC = RESULTS_DIR + f'/{next_step_suffix}-input.sdc'
        
        # Copy synthesized files to floorplan inputs
        os.symlink(STEP_OUTPUT_V, NEXT_INPUT_V)
        print(f"linked {STEP_OUTPUT_V} to {NEXT_INPUT_V}")
        
        os.symlink(STEP_OUTPUT_SDC, NEXT_INPUT_SDC)
        print(f"linked {STEP_OUTPUT_SDC} to {NEXT_INPUT_SDC}")
    
    elif "custom" in next_step:
        NEXT_INPUT_ODB = RESULTS_DIR + f'/custom-{next_step_suffix}-input.odb'
        NEXT_INPUT_SDC = RESULTS_DIR + f'/custom-{next_step_suffix}-input.sdc'
        
        # Copy synthesized SDC file to CTS input (ODB assumed to be generated)
        os.symlink(STEP_OUTPUT_SDC, NEXT_INPUT_SDC)
        print(f"linked {STEP_OUTPUT_SDC} to {NEXT_INPUT_SDC}")

        os.symlink(STEP_OUTPUT_ODB, NEXT_INPUT_ODB)
        print(f"linked {STEP_OUTPUT_ODB} to {NEXT_INPUT_ODB}")
        
    else:
        NEXT_INPUT_ODB = RESULTS_DIR + f'/{next_step_suffix}-input.odb'
        NEXT_INPUT_SDC = RESULTS_DIR + f'/{next_step_suffix}-input.sdc'
        
        # Copy synthesized SDC file to CTS input (ODB assumed to be generated)
        os.symlink(STEP_OUTPUT_SDC, NEXT_INPUT_SDC)
        print(f"linked {STEP_OUTPUT_SDC} to {NEXT_INPUT_SDC}")

        os.symlink(STEP_OUTPUT_ODB, NEXT_INPUT_ODB)
        print(f"linked {STEP_OUTPUT_ODB} to {NEXT_INPUT_ODB}")