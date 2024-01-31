"""
Script to interface with https://github.com/xyphro/UsbGpib
Specifically HP8711C RF network analyser.

Designed for measuring resonant frequency of an antenna with S11 (on meas1):
- FFinds notch in 5-20MHz sweep
- Records: CF, min
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
visafn.set_freq_start_stop(inst, 5e6, 20e6)
visafn.wait_and_sweep_once(inst)

notch = visafn.measure_notch(inst)

minimum = visafn.measure_min(inst)

print(f"Notch at {notch[1]} Hz")
print(f"Minimum at {minimum} dB")

print("################")
