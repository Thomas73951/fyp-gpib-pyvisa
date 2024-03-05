"""
Script to interface with https://github.com/xyphro/UsbGpib
Specifically Keysight DSOX3014A Scope.

Designed for retreiving sweep data as file
ONLY SETUP FOR CHANNEL 2 MEASUREMENT CURRENTLY
"""

import os
from pathlib import Path
import pyvisa
import visafn

# Setup
SAVE_CH2 = True
FOLDER_NAME = "keysight/sine"
FILE_NAME = "data"
DEVICE = "USB0::2391::6056::MY63080144::0::INSTR"  # keysight scope
# device found with pyvisa-shell, list instead of list_resources()
rm = pyvisa.ResourceManager('@py')
# device = rm.list_resources()
inst = rm.open_resource(DEVICE)

print("################")

# make path if doesn't exist
Path(FOLDER_NAME + os.path.sep).mkdir(parents=True, exist_ok=True)

visafn.query_ID(inst)

inst.write("WAV:SOURCE CHAN2")
inst.write("WAV:POINTS:MODE RAW")
inst.write("WAV:POINTS 5000;*WAI")
inst.write("WAV:FORMAT ASCII")

preamble = inst.query("WAV:PREAMBLE?")
print(preamble)

if (SAVE_CH2):
    data = inst.query("WAV:DATA?")
    with open(FOLDER_NAME + os.path.sep + FILE_NAME + "_CH2.csv", 'w') as file:
        file.write(data)
    with open(FOLDER_NAME + os.path.sep + FILE_NAME + "_CH2_preamble.csv", 'w') as file:
        file.write(preamble)


print("################")
