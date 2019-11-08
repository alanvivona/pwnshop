#!/usr/bin/env python3

import r2pipe

r = r2pipe.open("Untitled1.exe")

r.cmd("aa")
r.cmd("s sym.flag")
r.cmd("pdf")
r.cmd("e search.from = 0x00401500")
r.cmd("e search.to = 0x0040162b")
r.cmd("/x c600")

flag = bytearray()
for byte_trplet in r.cmd("pxj 3 @@hit0").split('\n'):
    try:
        byte_trplet = eval(byte_trplet)
        flag.append(byte_trplet[2])
    except Exception as e:
        pass
print(f"FLAG: {flag}")
