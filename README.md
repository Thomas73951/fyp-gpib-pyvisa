# fyp-gpib-pyvisa



## Operation

This currently has only been successfully tested on Linux.

### Venv setup (linux)

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
If no devices are listed the udev rules may need altering to allow communication.

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