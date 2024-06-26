"""
Script to interface with Keysight DSOX3014A Scope and Arduino uno running firmware from the "fyp_reader_control" repo.
Keysight programming reference: https://www.keysight.com/us/en/assets/9018-06894/programming-guides/9018-06894.pdf

Writes to Arduino (via serial) which produces modulated 13.56 MHz to a reader antenna. This is then recorded by a scope (controlled & processed here)

SCOPE reads on channel 2
"""

import os
from pathlib import Path
import time

import pyvisa
import serial


# setup (message & serial)
COM_PORT = "/dev/ttyACM1"
SER_MESSAGE = b"AZZXXYZXYZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYZZXXYZXYZYYYY\n"
# b'' notation needed ^

# setup (scope & data storage)
SAVE_DATA = False  # on channel 2
FOLDER_NAME = "keysight/tag_5apr/E/CoilA1W/test"#-23/z0/x20/y20/1"
FILE_NAME = "data"
DEVICE = "USB0::2391::6056::MY63080144::0::INSTR"  # keysight scope
# device found with pyvisa-shell, list instead of list_resources()


# make scope ready
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
inst.write("WAV:POINTS 100000")  # 100k is reasonable maximum, larger works but takes a significant amount of time
# inst.write("WAV:POINTS 8000000")
inst.write("WAV:FORMAT ASCII;*WAI")
points_measured = inst.query('ACQ:POINTS?').split('\n')[0]  # contains "\n" at end of line, split to remove
# amount of points captured, may be lower than set value.
print(f"Scope measurement consists of {points_measured} points")

preamble = inst.query("WAV:PREAMBLE?")
print("Scope measurement preamble:")
print(preamble)

inst.write("SINGLE")  # scope mode single, waiting for trigger...

# Send data
print("################")
print("Sending data...")
ser_arduino = serial.Serial(COM_PORT, 115200)  # no timeout specified, breaks stuff

print(ser_arduino.readline())  # prints "Serial Initialised."

ser_arduino.write(SER_MESSAGE)  # write message

# don't bother reading serial (Arduino sends message back)
# while True:
#     print(ser_arduino.readline())

ser_arduino.close()  # finished with arduino.
print("Data send complete")

# process and store data
time.sleep(2)
if (SAVE_DATA):
    print("Saving scope data...")
    data = inst.query("WAV:DATA?")
    # print(data[10:])
    with open(FOLDER_NAME + os.path.sep + FILE_NAME + "_CH2.csv", 'w') as file:
        # using [10:] below fixes "#800005599" (or similar, represents number of bytes to read) which appears before the first data point, makes first csv value valid when read back by code.
        file.write(data[10:])
    with open(FOLDER_NAME + os.path.sep + FILE_NAME + "_CH2_preamble.csv", 'w') as file:
        file.write(preamble)
    print("Scope data saved.")
