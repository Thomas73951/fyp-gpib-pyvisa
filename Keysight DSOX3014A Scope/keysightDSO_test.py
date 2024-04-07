"""
Script to interface with Keysight DSOX3014A Scope with VISA COM instructions
Keysight programming reference: https://www.keysight.com/us/en/assets/9018-06894/programming-guides/9018-06894.pdf

Tests link. 
Setup connection to scope with a USB cable to the USB B port on the back labelled "DEVICE"
"""

import pyvisa

# setup
DEVICE = "USB0::2391::6056::MY63080144::0::INSTR" # keysight scope
# device found with pyvisa-shell, list instead of list_resources()
rm = pyvisa.ResourceManager('@py')
# device = rm.list_resources()
inst = rm.open_resource(DEVICE)

print("################")

print("query IDN:", inst.query("*IDN?"))

print("################")
