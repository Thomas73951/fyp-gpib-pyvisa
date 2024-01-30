

import pyvisa

print("################")

DEVICE = "USB0::1003::8293::_HEWLETT-PACKARD_8711C_US36360157_C.04.52::0::INSTR"
# device found with pyvisa-shell, list instead of list_resources()


rm = pyvisa.ResourceManager('@py')
# device = rm.list_resources()

inst = rm.open_resource(DEVICE)


print("query IDN:")
# print(inst.query("*IDN?")) # both do the same thing
inst.write('*IDN?')
print(inst.read())


print("writing freq sweep settings")

inst.write("SENS2:FREQ:STAR 10 MHz;STOP 100 MHz;*OPC?")
# inst.write("SENS2:FREQ:CENT 30.75 MHz;SPAN 1 MHz;*OPC?")
print(inst.read())

print(inst.query("*IDN?")) 


print("################")
