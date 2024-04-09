"""
Specifically HP8711C RF network analyser.
Script expects VNA to be connected via a GPIB -> USB device for VISA COM instructions.
Tested with https://github.com/xyphro/UsbGpib

Designed for measuring resonant frequency of an antenna with S11 (on meas1):
- Finds notch in 5-20MHz sweep, zooms in, re-measures,
- Records: CF (Hz), min (dB)
- Saves S11 data CSV for 5 - 20 MHz. TODO: make this much narrower as it's not that useful, like centre span=5 MHz.
"""

import os
from pathlib import Path

import pyvisa

import visafn


# setup
NUM_POINTS = 1601  # max 1601
FOLDER_NAME = "coilA1W/3"  # without final filesep
PRECISION = 5  # in significant digits

DEVICE = "USB0::1003::8293::_HEWLETT-PACKARD_8711C_US36360157_C.04.52::0::INSTR"
# device found with pyvisa-shell, list instead of list_resources()
rm = pyvisa.ResourceManager('@py')
# device = rm.list_resources()
inst = rm.open_resource(DEVICE)

filename_base = f"data_{NUM_POINTS}"
# create folder path if it doesn't exist
Path(FOLDER_NAME).mkdir(parents=True, exist_ok=True)


print("################")

visafn.query_ID(inst)
visafn.set_freq_start_stop(inst, 10e6, 17e6)

inst.write(f"FORM:DATA ASC,{PRECISION}")
inst.write(f"SENS2:SWE:POIN {NUM_POINTS};*WAI")

visafn.wait_and_sweep_once(inst)

# temp result (zoomed out, remeasured zoomed in)
notch = visafn.measure_notch(inst)
f0 = notch[1]

# zoom in and remeasure.
visafn.resume_sweep(inst)
visafn.set_freq_centre_span(inst, 13.5e6, 2e6)
visafn.wait_and_sweep_once(inst)

# save 5-20 MHz data to CSV
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

# print result to console
print(f"Notch at {f0} Hz")
print(f"Minimum at {minimum} dB")

# save result to csv
with open(FOLDER_NAME + os.path.sep + filename_base + "_info.csv", 'w') as file:
    file.write("F0, Minimum\n")
    file.write(f"{f0}, {minimum}")

visafn.resume_sweep(inst)
# visafn.set_freq_start_stop(inst, 5e6, 20e6)

print("################")
