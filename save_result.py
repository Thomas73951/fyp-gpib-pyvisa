"""
Script to interface with https://github.com/xyphro/UsbGpib
Specifically HP8711C RF network analyser.

Designed for retreiving sweep data as file
"""

import os
from pathlib import Path
import pyvisa
import visafn

# setup
START_FREQ = 5e6 # in Hz
STOP_FREQ = 20e6 # in Hz
NUM_POINTS = 801 # max 1601
SAVE_MEAS1 = True
SAVE_MEAS2 = False
FOLDER_NAME = "1"
PRECISION = 5 # in significant digits
DEVICE = "USB0::1003::8293::_HEWLETT-PACKARD_8711C_US36360157_C.04.52::0::INSTR"
# device found with pyvisa-shell, list instead of list_resources()
rm = pyvisa.ResourceManager('@py')
# device = rm.list_resources()
inst = rm.open_resource(DEVICE)

filename_base = f"data_{NUM_POINTS}"
print("################")

Path(FOLDER_NAME).mkdir(parents=True, exist_ok=True)

visafn.query_ID(inst)
visafn.set_freq_start_stop(inst, START_FREQ, STOP_FREQ)
visafn.wait_and_sweep_once(inst)

inst.write(f"SENS2:SWE:POIN {NUM_POINTS};*WAI")
inst.write(f"FORM:DATA ASC,{PRECISION}")

if (SAVE_MEAS1):
    data = inst.query("TRAC? CH1FDATA")
    with open(FOLDER_NAME + os.path.sep + filename_base + "_MEAS1.csv", 'w') as file:
        file.write(data)

if (SAVE_MEAS2):
    data = inst.query("TRAC? CH2FDATA")
    with open(FOLDER_NAME + os.path.sep + filename_base + "_MEAS2.csv", 'w') as file:
        file.write(data)

visafn.resume_sweep(inst)

print("################")
