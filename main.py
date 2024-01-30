"""
Script to interface with https://github.com/xyphro/UsbGpib
Specifically HP8711C RF network analyser.

Designed for measuring resonant frequency of a coil:
- Finds max frequency in large sweep
- Zooms to peak and remeasures, prints result.
"""

import pyvisa


# setup
DEVICE = "USB0::1003::8293::_HEWLETT-PACKARD_8711C_US36360157_C.04.52::0::INSTR"
# device found with pyvisa-shell, list instead of list_resources()
rm = pyvisa.ResourceManager('@py')
# device = rm.list_resources()
inst = rm.open_resource(DEVICE)



def query_ID(inst):
    print("query IDN:", inst.query("*IDN?"))

def set_freq_start_stop(inst, start, stop):
    """sets frequency range of vna

    Args:
        inst (_type_): device
        start (string or int, float?): in Hz
        stop (string or int, float?): in Hz
    """
    inst.write(f"SENS2:FREQ:STAR {start} Hz;STOP {stop} Hz;*WAI")

def set_freq_centre_span(inst, centre, span):
    """sets frequency range of VNA (center / span)

    Args:
        inst: device
        centre (string or int, float?): in Hz
        span (string or int, float?): in Hz
    """
    inst.write(f"SENS2:FREQ:CENT {centre} Hz;SPAN {span} Hz;*WAI")

def wait_and_sweep_once(inst):
    """Waits for previous commands to finish running, 
    turns off continuous operaition, runs one sweep. Leaves "paused"

    Args:
        inst: device
    """
    inst.write("ABOR;:INIT:CONT OFF;:INIT;*WAI")

def resume_sweep(inst):
    """Resumes continuous operation.

    Args:
        inst: device
    """
    inst.write("INIT:CONT ON;*WAI")


def measure_peak(inst):
    """Measures -3dB peak of data, 
    assumes data ready to be measured

    Args:
        inst: device

    Returns:
        list: list of string values as: [BW, CF, Q, Loss] 
        in scientific format: ['+1.00000000000E+006', ...]
    """
    return inst.query("CALC2:MARK:BWID -3;FUNC:RES?").split(',')


print("################")

query_ID(inst)
set_freq_start_stop(inst, 10e6, 100e6)
wait_and_sweep_once(inst)
result = measure_peak(inst)
resume_sweep(inst)
set_freq_centre_span(inst, result[1], 1e6)
wait_and_sweep_once(inst)
new_result = measure_peak(inst)
resume_sweep(inst)

print(f"bw: {result[0]}\nCF: {result[1]}\nQ: {result[2]}\nLoss: {result[3]}")

print("################")
