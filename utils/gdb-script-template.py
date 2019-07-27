#!/usr/bin/env python3

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
