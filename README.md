# fyp-gpib-pyvisa

This repo contains scripts for automating specific tasks on various instruments. It communicates to instruments using [VISA](https://en.wikipedia.org/wiki/Virtual_instrument_software_architecture) which is a standard for communication compatible over several mediums including USB, [GPIB](https://en.wikipedia.org/wiki/GPIB), and TCP/IP.

This uses the [pyvisa](https://pyvisa.readthedocs.io/en/latest/) Python library, with the [pyvisa-py](https://pyvisa.readthedocs.io/projects/pyvisa-py/en/latest/) VISA backend. Both a functional frontend and backend are required for communication. See [alternative backends](#alternative-backends) for more information.


## Devices Used

This includes syntax for use with the following (see links for code):
- [Keysight DSOX3014A Oscilloscope](Keysight%20DSOX3014A%20Scope/README.md)
- [HP 8711C VNA](HP8711C%20VNA/README.md) (with an [adaptor](https://github.com/xyphro/UsbGpib) to convert the GPIB interface to a USB one)


For other instruments, read their programmer's manual.

## Setup

This section details the steps to successfully make a simple query - retrieving the device ID from the instrument.

> [!WARNING]
> So far communication using the pyvisa-py backend have only been successful on Linux with USB devices. This is likely due to USB rules. On Linux this may require editing udev rules for the device to appear correctly.

### Alternative Backends

Alternative backends include those from:

- [Keysight](https://www.keysight.com/en/pd-1985909/io-libraries-suite/)
- [National Instruments](https://www.ni.com/en/support/downloads/drivers/download.ni-visa.html) - [pyvisa installation notes](https://pyvisa.readthedocs.io/en/latest/faq/getting_nivisa.html)

See [pyvisa installation notes](https://pyvisa.readthedocs.io/en/latest/introduction/getting.html) for more information.


### Venv setup (linux)

> [!NOTE]
> There are no setup instructions for Windows or MAC OS currently.

```bash
python -m venv .venv
source .venv/bin/activate

pip install pyvisa pyvisa-py pyUSB
```
Potentially also need: `psutil zeroconf`


`pyUSB` needed for communicating this device, will find no devices without it.

### Testing

Look for devices:

```bash
pyvisa-shell
list
```
This will show all the instruments connected with their device ID's. At this point setup is complete if the instrument is shown. Note down the device ID and use it when writing scripts.

However, if no devices are listed the udev rules may need altering to allow communication.

Check packages installed correctly:

```bash
pyvisa-info
```

This should show:

```
USB INSTR: Available via PyUSB (1.2.1). Backend: libusb1
USB RAW: Available via PyUSB (1.2.1). Backend: libusb1
```

or similar. 

### Run 

```bash
python <script>.py
```


### Full Setup Details

These show what Python libraries are installed, and what `pyvisa-info` returns.

Pip:

```bash
Package           Version
----------------- -------
future            1.0.0
ifaddr            0.2.0
iso8601           2.1.0
numpy             1.26.4
pip               23.3.2
psutil            5.9.8
pyserial          3.5
pyusb             1.2.1
PyVISA            1.14.1
PyVISA-py         0.7.1
PyYAML            6.0.1
serial            0.0.97
setuptools        65.5.0
typing_extensions 4.9.0
zeroconf          0.131.0
```

pyvisa-info:

```bash
Machine Details:
   Platform ID:    Linux-6.1.52-valve16-1-neptune-61-x86_64-with-glibc2.38
   Processor:      

Python:
   Implementation: CPython
   Executable:     /home/deck/Documents/repos/fyp-gpib-pyvisa/.venv/bin/python
   Version:        3.11.7
   Compiler:       GCC 13.2.0
   Architecture:   ('x86', 64)
   Build:          Nov 10 2011 15:00:00 (#main)
   Unicode:        UCS4

PyVISA Version: 1.14.1

Backends:
   ivi:
      Version: 1.14.1 (bundled with PyVISA)
      Binary library: Not found
   py:
      Version: 0.7.1
      ASRL INSTR: Available via PySerial (3.5)
      USB INSTR: Available via PyUSB (1.2.1). Backend: libusb1
      USB RAW: Available via PyUSB (1.2.1). Backend: libusb1
      TCPIP INSTR: Available 
         Resource discovery:
         - VXI-11: ok
         - hislip: ok
      TCPIP SOCKET: Available 
      VICP INSTR:
         Please install PyVICP to use this resource type.
      GPIB INSTR:
         Please install linux-gpib (Linux) or gpib-ctypes (Windows, Linux) to use this resource type. Note that installing gpib-ctypes will give you access to a broader range of functionalities.
         No module named 'gpib'
      GPIB INTFC:
         Please install linux-gpib (Linux) or gpib-ctypes (Windows, Linux) to use this resource type. Note that installing gpib-ctypes will give you access to a broader range of functionalities.
         No module named 'gpib'
```