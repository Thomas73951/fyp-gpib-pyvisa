"""
Script to interface with Keysight DSOX3014A Scope and Arduino uno running the "fyp_reader_control" repo.

Writes to Arduino (via serial) which produces modulated 13.56 MHz to a reader antenna. This is then recorded by a scope (controlled & processed here)

Keysight programming reference: https://www.keysight.com/us/en/assets/9018-06894/programming-guides/9018-06894.pdf
"""

import serial

COM_PORT = "/dev/ttyACM1"
SER_MESSAGE = b"AZZXXYZXYZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYZZXXYZXYZYYYY\n"
# b'' notation needed ^

# Setup Scope


# Send data
ser_arduino = serial.Serial(COM_PORT, 115200)  # no timeout specified, breaks stuff

print(ser_arduino.readline())  # prints "Serial Initialised."

ser_arduino.write(SER_MESSAGE)  # write message

# don't bother reading serial (Arduino sends message back)
# while True:
#     print(ser_arduino.readline())

ser_arduino.close() # finished with arduino.


