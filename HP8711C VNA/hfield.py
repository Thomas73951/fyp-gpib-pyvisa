"""
Specifically HP8711C RF network analyser.
Script expects VNA to be connected via a GPIB -> USB device for VISA COM instructions.
Tested with https://github.com/xyphro/UsbGpib

Designed for measuring H field of a tuned antenna:
- requests probe in different positions and measures S21 for each
- records into csv file, for plotting

Expects antenna connected to port 1, probe connected to port 2, and MEAS2 = transmission
"""

# import os
from pathlib import Path

# import numpy as np
import pyvisa

import visafn

# setup
DEVICE = "USB0::1003::8293::_HEWLETT-PACKARD_8711C_US36360157_C.04.52::0::INSTR"
# device found with pyvisa-shell, list instead of list_resources()
rm = pyvisa.ResourceManager('@py')
# device = rm.list_resources()
inst = rm.open_resource(DEVICE)

# for "STANDARD_SWEEP"
# START = 0
# STOP = 40
# NUM_POINTS = 21
# SWEEP_DIRECTION = 'x'
# FOLDERNAME = "Coil C/Hfield/"
# FILENAME = f"{SWEEP_DIRECTION}sweep_{START}_{STOP}_{NUM_POINTS}.csv"
# setup sweep
# sweep_points = np.linspace(START,STOP,NUM_POINTS)

# for manual point entry
SWEEP_DIRECTION = 'z'
sweep_points = [4, 17, 27, 37, 50, 67, 77, 87]  # should be ALL_CAPS but nvm
FOLDERNAME = "Coil A/Hfield/"
FILENAME = f"{SWEEP_DIRECTION}sweepx0_{min(sweep_points)}_{max(sweep_points)}_{len(sweep_points)}.csv"
print("################")


# make path if doesn't exist
Path(FOLDERNAME).mkdir(parents=True, exist_ok=True)

# write a csv file
file = open(FOLDERNAME + FILENAME, 'w')

visafn.query_ID(inst)
visafn.set_freq_centre_span(inst, 13.5e6, 5e6)  # frequency setup settings.
visafn.wait_and_sweep_once(inst)


for i in sweep_points:  # take measurements at each sweep point

    # press enter to continue when probe is in position.
    input(f"Position probe at {SWEEP_DIRECTION} = {i} mm")

    visafn.wait_and_sweep_once(inst)
    result = visafn.measure_peak(inst)
    # print(f"bw: {result[0]}\nCF: {result[1]}\nQ: {result[2]}\nLoss: {result[3]}")
    result = result[3].split('\n')[0]  # removing excess \n but then adding it back
    print(result)
    file.write(result + '\n')

visafn.resume_sweep(inst)

file.close()

print("################")
