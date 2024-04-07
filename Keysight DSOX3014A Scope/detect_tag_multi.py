"""
Script to interface with Keysight DSOX3014A Scope and Arduino uno running firmware from the "fyp_reader_control" repo.

Writes to Arduino (via serial) which produces modulated 13.56 MHz to a reader antenna. This is then recorded by a scope (controlled & processed here)

SCOPE reads on channel 2

Keysight programming reference: https://www.keysight.com/us/en/assets/9018-06894/programming-guides/9018-06894.pdf
"""

import csv
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
SAVE_DATA = True  # on channel 2
FOLDER_NAME_BASE = "keysight/tag_4apr/E/CoilA1W/2"
# /-23/z0/x20/y20/1"
FILE_NAME = "data"
POINTS_FILE = "points6.csv"  # placed within FOLDER_NAME_BASE
DEVICE = "USB0::2391::6056::MY63080144::0::INSTR"  # keysight scope
# device found with pyvisa-shell, list instead of list_resources()

with open(FOLDER_NAME_BASE + os.path.sep + POINTS_FILE, "r") as file:
    points = [[int(x) for x in rec] for rec in csv.reader(file, delimiter=',')]

# print(points)

# for point in points:
    # point.append(2)
    # print(f"x = {point[0]}")
    # print(f"y = {point[1]}")
    # print(f"z = {point[2]}")
    # print()
# print(points)

# with open(FOLDER_NAME_BASE + os.path.sep + "testsave.csv", "w") as file:
#     csvwriter = csv.writer(file)
#     csvwriter.writerows(points)

# init scope
rm = pyvisa.ResourceManager('@py')
# device = rm.list_resources()
inst = rm.open_resource(DEVICE)

print("################")

print("query IDN:", inst.query("*IDN?"))

def enter_int(msg):
    """input helper - int type.
    Retry until int is entered.

    Args:
        msg (str): text to be displayed

    Returns:
        int: answer user entered (integer)
    """
    try:
        answer = int(input(msg))
        return answer
    except ValueError:
        print("\nValue Error - Int is required - retry...\n")
        return enter_int(msg)


for point in points:
    x = point[0]
    y = point[1]
    z = point[2]

    print(f"Currently testing x{x}, y{y}, z{z} mm")

    continue_test = True
    while(continue_test):
        power = enter_int("Enter power level (dBm): ")

        FOLDER_NAME = FOLDER_NAME_BASE + os.path.sep + f"z{z}" + os.path.sep + f"y{y}" + os.path.sep + f"x{x}" + os.path.sep + str(power)

        # make path if doesn't exist
        Path(FOLDER_NAME + os.path.sep).mkdir(parents=True, exist_ok=True)


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
                # Fixes "#800005599" (or similar, represents number of bytes to read) which appears before the first data point, makes first csv value valid when read back.
                file.write(data[10:])
            with open(FOLDER_NAME + os.path.sep + FILE_NAME + "_CH2_preamble.csv", 'w') as file:
                file.write(preamble)
            print("Scope data saved.")

            # continue_input = input("Blank to continue testing, or enter minimum detectable power (dBm) to end: ")
            continue_input = input("Blank to continue testing, or 'q' to end testing at this coordinate: ")
            if continue_input == "q":
                continue_test = False
                point.append(enter_int("Enter minimum detectable power (dBm): "))
                print(points)
            

print(points)

with open(FOLDER_NAME_BASE + os.path.sep + "results.csv", "w") as file:
    csvwriter = csv.writer(file)
    csvwriter.writerows(points)
