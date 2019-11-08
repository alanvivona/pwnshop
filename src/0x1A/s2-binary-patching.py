#!/usr/bin/env python3

import r2pipe
import subprocess

subprocess.call(["cp", "./Untitled1.exe", "Cracked.exe"])

r = r2pipe.open("Cracked.exe", ['-w'])

r.cmd('aa')

def print_addr_content(addr):
    r.cmd(f"s {addr}")
    print(f"Current disas of line at {addr}: {r.cmd('pd 1 ~[3-6]')}")
    print(f"Current bytecode of line at {addr}: {r.cmd('pd 1 ~[2]')}")
    out = list(map(hex, eval(r.cmd("pxj 6"))))
    print(f"Values at {addr}: {out}")
    r.cmd(f"s -")

print_addr_content(0x00401642)

print("[!] PATCHING BINARY")
r.cmd("s 0x00401642+4")
r.cmd("px 1")
r.cmd("w1- 1")
r.cmd("px 1")
r.cmd("s 0x00401642")
print("[!] BINARY PATCHED")

print_addr_content(0x00401642)

print("Executing cracked binary...")

subprocess.call(["wine", "Cracked.exe"])
