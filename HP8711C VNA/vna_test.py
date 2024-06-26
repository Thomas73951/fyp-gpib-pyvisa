"""
Specifically HP8711C RF network analyser.
Script expects VNA to be connected via a GPIB -> USB device for VISA COM instructions.
Tested with https://github.com/xyphro/UsbGpib


Queries device ID to test link
"""

import pyvisa
import visafn

# setup
DEVICE = "USB0::1003::8293::_HEWLETT-PACKARD_8711C_US36360157_C.04.52::0::INSTR"
# device found with pyvisa-shell, list instead of list_resources()
rm = pyvisa.ResourceManager('@py')
# device = rm.list_resources()
inst = rm.open_resource(DEVICE)

print("################")

visafn.query_ID(inst)

print("################")
