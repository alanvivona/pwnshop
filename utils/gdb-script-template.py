#!/usr/bin/env python3

# dependencies: 
# - gdb
# - GEF (https://github.com/hugsy/gef)

# usage :
# sample binary taken from : https://crackmes.one/crackme/5c79727733c5d4776a837d80
# gdb --command gdb-script-template.py ../crackmes/Sh4ll9/sh4ll9.bin

import gdb

commands = [
    f"break main",
    f"run",
    f"checksec",
    f"search-pattern 'Hey'",
    f"patch string 0x489d38 'Example of how easy it is to automate gdb sessions using the python api'",
    f"continue",
]

for command in commands:
    if len(command):
        print("="*20)
        print(f"Executing => {command}")
        gdb.execute(command)
