# fyp-gpib-pyvisa



## Operation

### Venv setup (linux)

```bash
python -m venv .venv
source .venv/bin/activate

pip install pyvisa pyvisa-py pyUSB
```

`pyUSB` needed for communicating this device, will find no devices without it.

### Testing

Look for devices:

```bash
pyvisa-shell
list
```

Check packages installed correctly:

```bash
pyvisa-info
```

### Run 

```bash
python main.py
```