"""
Script to interface with https://github.com/xyphro/UsbGpib
Specifically HP8711C RF network analyser.

Designed for measuring resonant frequency of a coil:
- Finds max frequency in large sweep
- Zooms to peak and remeasures, prints result.
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
visafn.set_freq_start_stop(inst, 10e6, 100e6)
visafn.wait_and_sweep_once(inst)

result = visafn.measure_peak(inst)

visafn.resume_sweep(inst)
visafn.set_freq_centre_span(inst, result[1], 1e6)
visafn.wait_and_sweep_once(inst)

new_result = visafn.measure_peak(inst)

visafn.resume_sweep(inst)

print(f"bw: {result[0]}\nCF: {result[1]}\nQ: {result[2]}\nLoss: {result[3]}")

print("################")
