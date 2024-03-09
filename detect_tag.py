

import serial

COM_PORT = "/dev/ttyACM1"

SER_MESSAGE = b"AZZXXYZXYZYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYZZXXYZXYZYYYY\n"


ser_arduino = serial.Serial(COM_PORT, 115200)


print(ser_arduino.readline())

ser_arduino.write(SER_MESSAGE)

# don't bother reading it all back.
# while True:
#     print(ser_arduino.readline())

ser_arduino.close()


