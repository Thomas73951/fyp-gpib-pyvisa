"""
helper functions for pyvisa

Specifically HP8711C RF network analyser.
Script expects VNA to be connected via a GPIB -> USB device for VISA COM instructions.
Tested with https://github.com/xyphro/UsbGpib
"""

def query_ID(inst):
    """Universal function to query connected device ID and print to console

    Args:
        inst: device
    """
    print("query IDN:", inst.query("*IDN?"))

def set_freq_start_stop(inst, start, stop):
    """sets frequency range of vna

    Args:
        inst: device
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
    assumes data ready to be measured, data on meas2 TODO: arg for meas1 or 2

    Args:
        inst: device

    Returns:
        list: list of string values as: [BW, CF, Q, Loss] 
        in scientific format: ['+1.00000000000E+006', ...]
        TODO: fix leaves '\n' on last point
    """
    return inst.query("CALC2:MARK:BWID -3;FUNC:RES?").split(',')

def measure_notch(inst):
    """Measures +3dB notch in data, 
    assumes data ready to be measured, data on meas1 TODO: arg for meas1 or 2

    Args:
        inst: device

    Returns:
        list: list of string values as: [BW, CF, Q, Loss] 
        in scientific format: ['+1.00000000000E+006', ...]
        TODO: fix leaves '\n' on last point
    """
    # TODO: notch requires specific value, will constantly need to fiddle with it if wrong
    return inst.query("CALC1:MARK:NOTC -7;FUNC:RES?").split(',')

def measure_min(inst):
    """Measures min of data, 
    assumes data ready to be measured, data on meas1 TODO: arg for meas1 or 2

    Args:
        inst: device

    Returns:
        list: list of string values as: [minimum, '\n'] TODO: remove '\n' entirely 
        in scientific format: ['+1.00000000000E+006', ...]
    """
    return inst.query("CALC1:MARK:MIN;FUNC:RES?").split('\n')
