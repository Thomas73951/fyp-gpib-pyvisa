"""
Script to interface with https://github.com/xyphro/UsbGpib
Specifically HP8711C RF network analyser.

Designed for measuring resonant frequency of an antenna with S11 (on meas1):
- Finds notch in 5-20MHz sweep
- Records: CF, min
"""

import os
from pathlib import Path

import pyvisa

import visafn


# setup
NUM_POINTS = 801 # max 1601
FOLDER_NAME = "coilC/5"
PRECISION = 5 # in significant digits
DEVICE = "USB0::1003::8293::_HEWLETT-PACKARD_8711C_US36360157_C.04.52::0::INSTR"
# device found with pyvisa-shell, list instead of list_resources()
rm = pyvisa.ResourceManager('@py')
# device = rm.list_resources()
inst = rm.open_resource(DEVICE)

filename_base = f"data_{NUM_POINTS}"
Path(FOLDER_NAME).mkdir(parents=True, exist_ok=True)


print("################")

visafn.query_ID(inst)
visafn.set_freq_start_stop(inst, 5e6, 20e6)

inst.write(f"FORM:DATA ASC,{PRECISION}")
inst.write(f"SENS2:SWE:POIN {NUM_POINTS};*WAI")

visafn.wait_and_sweep_once(inst)

# temp result (zoomed out, remeasured zoomed in)
notch = visafn.measure_notch(inst)
f0 = notch[1]

data = inst.query("TRAC? CH1FDATA")
with open(FOLDER_NAME + os.path.sep + filename_base + "_MEAS1.csv", 'w') as file:
    file.write(data)

# zoom in and remeasure.
visafn.resume_sweep(inst) 
visafn.set_freq_centre_span(inst, f0, 500e3)
visafn.wait_and_sweep_once(inst)

minimum = visafn.measure_min(inst)[0]
notch = visafn.measure_notch(inst)
f0 = notch[1]

print(f"Notch at {f0} Hz")
print(f"Minimum at {minimum} dB")

with open(FOLDER_NAME + os.path.sep + filename_base + "_info.csv", 'w') as file:
    file.write("F0, Minimum\n")
    file.write(f"{f0}, {minimum}")

visafn.resume_sweep(inst)
# visafn.set_freq_start_stop(inst, 5e6, 20e6)

print("################")
