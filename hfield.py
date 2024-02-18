"""
Script to interface with https://github.com/xyphro/UsbGpib
Specifically HP8711C RF network analyser.

Designed for measuring H field of a tuned antenna:
- requests probe in different positions and measures S21 for each
- records into csv file, for plotting

"""

import os
from pathlib import Path

import numpy as np
import pyvisa

import visafn

# setup
DEVICE = "USB0::1003::8293::_HEWLETT-PACKARD_8711C_US36360157_C.04.52::0::INSTR"
# device found with pyvisa-shell, list instead of list_resources()
rm = pyvisa.ResourceManager('@py')
# device = rm.list_resources()
inst = rm.open_resource(DEVICE)


START = 0
STOP = 40
NUM_POINTS = 21
FOLDERNAME = "Coil C 2/Hfield/"
FILENAME = f"xsweep_{START}_{STOP}_{NUM_POINTS}.csv"

print("################")

# setup sweep
sweep_points = np.linspace(START,STOP,NUM_POINTS)

# make path if doesn't exist
Path(FOLDERNAME).mkdir(parents=True, exist_ok=True)

# write a csv file
file = open(FOLDERNAME + FILENAME, 'w')

visafn.query_ID(inst)
visafn.set_freq_start_stop(inst, 10e6, 15e6)
visafn.wait_and_sweep_once(inst)


for i in sweep_points:
    input(f"Position probe at {i} mm")

    visafn.wait_and_sweep_once(inst)
    result = visafn.measure_peak(inst)
    # print(f"bw: {result[0]}\nCF: {result[1]}\nQ: {result[2]}\nLoss: {result[3]}")
    result = result[3].split('\n')[0] # removing excess \n but then adding it back 
    print(result)
    file.write(result + '\n')

visafn.resume_sweep(inst)

file.close()

print("################")