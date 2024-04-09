"""
Script to interface with Keysight DSOX3014A Scope with VISA COM instructions
Keysight programming reference: https://www.keysight.com/us/en/assets/9018-06894/programming-guides/9018-06894.pdf

Designed for retreiving sweep data as file
ONLY SETUP FOR CHANNEL 2 MEASUREMENT CURRENTLY
"""

import os
from pathlib import Path

import pyvisa


# Setup
SAVE_CH2 = True
FOLDER_NAME = "keysight/taglong1"
FILE_NAME = "data"
DEVICE = "USB0::2391::6056::MY63080144::0::INSTR"  # keysight scope
# device found with pyvisa-shell, list instead of list_resources()
rm = pyvisa.ResourceManager('@py')
# device = rm.list_resources()
inst = rm.open_resource(DEVICE)

print("################")

# make path if doesn't exist
Path(FOLDER_NAME + os.path.sep).mkdir(parents=True, exist_ok=True)

print("query IDN:", inst.query("*IDN?"))

inst.write("WAV:SOURCE CHAN2")
inst.write("WAV:POINTS:MODE RAW")
# see ref doc p1006 for valid options (generally 1,2,5 per decade, eg 2000, maximum with RAW mode 8000000) - value limited by current scope settings, prints amount found below
# inst.write("WAV:POINTS 100000") # 100k is reasonable maximum, larger works but takes a significant amount of time
inst.write("WAV:POINTS 8000000")
inst.write("WAV:FORMAT ASCII;*WAI")
points_measured = inst.query('ACQ:POINTS?').split('\n')[0] # contains "\n" at end of line, split to remove
print(f"Scope measurement consists of {points_measured} points") # amount of points captured, may be lower than set value.

preamble = inst.query("WAV:PREAMBLE?")
print("Scope measurement preamble:")
print(preamble)

if (SAVE_CH2):
    data = inst.query("WAV:DATA?")
    # print(data[10:])
    with open(FOLDER_NAME + os.path.sep + FILE_NAME + "_CH2.csv", 'w') as file:
        # using [10:] below fixes "#800005599" (or similar, represents number of bytes to read) which appears before the first data point, makes first csv value valid when read back by code.
        file.write(data[10:])
    with open(FOLDER_NAME + os.path.sep + FILE_NAME + "_CH2_preamble.csv", 'w') as file:
        file.write(preamble)


print("################")
