#!/usr/bin/env python3

#
# Emulation script for "crack3-by-D4RK_FL0W" from 0x555555555269 to 0x555555555328
#
# Powered by gef, unicorn-engine, and capstone-engine
#
# @_hugsy_
#
from __future__ import print_function
import collections
import capstone, unicorn

registers = collections.OrderedDict(sorted({'$rax': unicorn.x86_const.UC_X86_REG_RAX,'$rbx': unicorn.x86_const.UC_X86_REG_RBX,'$rcx': unicorn.x86_const.UC_X86_REG_RCX,'$rdx': unicorn.x86_const.UC_X86_REG_RDX,'$rsp': unicorn.x86_const.UC_X86_REG_RSP,'$rbp': unicorn.x86_const.UC_X86_REG_RBP,'$rsi': unicorn.x86_const.UC_X86_REG_RSI,'$rdi': unicorn.x86_const.UC_X86_REG_RDI,'$rip': unicorn.x86_const.UC_X86_REG_RIP,'$r8': unicorn.x86_const.UC_X86_REG_R8,'$r9': unicorn.x86_const.UC_X86_REG_R9,'$r10': unicorn.x86_const.UC_X86_REG_R10,'$r11': unicorn.x86_const.UC_X86_REG_R11,'$r12': unicorn.x86_const.UC_X86_REG_R12,'$r13': unicorn.x86_const.UC_X86_REG_R13,'$r14': unicorn.x86_const.UC_X86_REG_R14,'$r15': unicorn.x86_const.UC_X86_REG_R15,'$eflags': unicorn.x86_const.UC_X86_REG_EFLAGS,'$cs': unicorn.x86_const.UC_X86_REG_CS,'$ss': unicorn.x86_const.UC_X86_REG_SS,'$ds': unicorn.x86_const.UC_X86_REG_DS,'$es': unicorn.x86_const.UC_X86_REG_ES,'$fs': unicorn.x86_const.UC_X86_REG_FS,'$gs': unicorn.x86_const.UC_X86_REG_GS}.items(), key=lambda t: t[0]))
uc = None
verbose = False
syscall_register = "$rax"

def disassemble(code, addr):
    cs = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_64 + capstone.CS_MODE_LITTLE_ENDIAN)
    for i in cs.disasm(code, addr):
        return i

def hook_code(emu, address, size, user_data):
    code = emu.mem_read(address, size)
    insn = disassemble(code, address)
    print(">>> {:#x}: {:s} {:s}".format(insn.address, insn.mnemonic, insn.op_str))
    return

def code_hook(emu, address, size, user_data):
    code = emu.mem_read(address, size)
    insn = disassemble(code, address)
    print(">>> {:#x}: {:s} {:s}".format(insn.address, insn.mnemonic, insn.op_str))
    return

def intr_hook(emu, intno, data):
    print(" \-> interrupt={:d}".format(intno))
    return

def syscall_hook(emu, user_data):
    sysno = emu.reg_read(registers[syscall_register])
    print(" \-> syscall={:d}".format(sysno))
    return

def print_regs(emu, regs):
    for i, r in enumerate(regs):
        reg_value = emu.reg_read(regs[r])
        reg_points_to = emu.reg_read(reg_value)
        print("{:7s} = {:#016x} ==> {:#016x}".format(r, reg_value, reg_points_to,end=""))
        # if (i % 4 == 3) or (i == len(regs)-1): print("")
    return

# from https://github.com/unicorn-engine/unicorn/blob/master/tests/regress/x86_64_msr.py
SCRATCH_ADDR = 0xf000
SEGMENT_FS_ADDR = 0x5000
SEGMENT_GS_ADDR = 0x6000
FSMSR = 0xC0000100
GSMSR = 0xC0000101

def set_msr(uc, msr, value, scratch=SCRATCH_ADDR):
    buf = b"\x0f\x30"  # x86: wrmsr
    uc.mem_map(scratch, 0x1000)
    uc.mem_write(scratch, buf)
    uc.reg_write(unicorn.x86_const.UC_X86_REG_RAX, value & 0xFFFFFFFF)
    uc.reg_write(unicorn.x86_const.UC_X86_REG_RDX, (value >> 32) & 0xFFFFFFFF)
    uc.reg_write(unicorn.x86_const.UC_X86_REG_RCX, msr & 0xFFFFFFFF)
    uc.emu_start(scratch, scratch+len(buf), count=1)
    uc.mem_unmap(scratch, 0x1000)
    return

def set_gs(uc, addr):    return set_msr(uc, GSMSR, addr)
def set_fs(uc, addr):    return set_msr(uc, FSMSR, addr)



def reset():
    emu = unicorn.Uc(unicorn.UC_ARCH_X86, unicorn.UC_MODE_64 + unicorn.UC_MODE_LITTLE_ENDIAN)

    emu.mem_map(SEGMENT_FS_ADDR-0x1000, 0x3000)
    set_fs(emu, SEGMENT_FS_ADDR)
    set_gs(emu, SEGMENT_GS_ADDR)

    emu.reg_write(unicorn.x86_const.UC_X86_REG_RAX, 0x5555555583c0)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_RBX, 0x0)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_RCX, 0x400)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_RDX, 0x7ffff7dcc960)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_RSP, 0x7fffffffdc90)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_RBP, 0x7fffffffdc90)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_RSI, 0x0)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_RDI, 0x5555555583c0)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_RIP, 0x555555555269)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_R8, 0x0)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_R9, 0x5555555582b0)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_R10, 0x7ffff7dd2800)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_R11, 0x246)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_R12, 0x5555555550b0)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_R13, 0x7fffffffdd90)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_R14, 0x0)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_R15, 0x0)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_EFLAGS, 0x202)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_CS, 0x33)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_SS, 0x2b)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_DS, 0x0)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_ES, 0x0)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_FS, 0x0)
    emu.reg_write(unicorn.x86_const.UC_X86_REG_GS, 0x0)
    # Mapping /home/h3y/Downloads/crackmes/crack3-by-D4RK_FL0W: 0x555555554000-0x555555555000
    emu.mem_map(0x555555554000, 0x1000, 0o1)
    emu.mem_write(0x555555554000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x555555554000.raw', 'rb').read())

    # Mapping /home/h3y/Downloads/crackmes/crack3-by-D4RK_FL0W: 0x555555555000-0x555555556000
    emu.mem_map(0x555555555000, 0x1000, 0o5)
    emu.mem_write(0x555555555000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x555555555000.raw', 'rb').read())

    # Mapping /home/h3y/Downloads/crackmes/crack3-by-D4RK_FL0W: 0x555555556000-0x555555557000
    emu.mem_map(0x555555556000, 0x1000, 0o1)
    emu.mem_write(0x555555556000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x555555556000.raw', 'rb').read())

    # Mapping /home/h3y/Downloads/crackmes/crack3-by-D4RK_FL0W: 0x555555557000-0x555555558000
    emu.mem_map(0x555555557000, 0x1000, 0o1)
    emu.mem_write(0x555555557000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x555555557000.raw', 'rb').read())

    # Mapping /home/h3y/Downloads/crackmes/crack3-by-D4RK_FL0W: 0x555555558000-0x555555559000
    emu.mem_map(0x555555558000, 0x1000, 0o3)
    emu.mem_write(0x555555558000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x555555558000.raw', 'rb').read())

    # Mapping [heap]: 0x555555559000-0x55555557a000
    emu.mem_map(0x555555559000, 0x21000, 0o3)
    emu.mem_write(0x555555559000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x555555559000.raw', 'rb').read())

    # Mapping /lib/x86_64-linux-gnu/libc-2.27.so: 0x7ffff70a5000-0x7ffff728c000
    emu.mem_map(0x7ffff70a5000, 0x1e7000, 0o5)
    emu.mem_write(0x7ffff70a5000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff70a5000.raw', 'rb').read())

    # Mapping /lib/x86_64-linux-gnu/libc-2.27.so: 0x7ffff728c000-0x7ffff748c000
    emu.mem_map(0x7ffff728c000, 0x200000, 0o0)
    # Mapping /lib/x86_64-linux-gnu/libc-2.27.so: 0x7ffff748c000-0x7ffff7490000
    emu.mem_map(0x7ffff748c000, 0x4000, 0o1)
    emu.mem_write(0x7ffff748c000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff748c000.raw', 'rb').read())

    # Mapping /lib/x86_64-linux-gnu/libc-2.27.so: 0x7ffff7490000-0x7ffff7492000
    emu.mem_map(0x7ffff7490000, 0x2000, 0o3)
    emu.mem_write(0x7ffff7490000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7490000.raw', 'rb').read())

    # Mapping : 0x7ffff7492000-0x7ffff7496000
    emu.mem_map(0x7ffff7492000, 0x4000, 0o3)
    emu.mem_write(0x7ffff7492000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7492000.raw', 'rb').read())

    # Mapping /lib/x86_64-linux-gnu/libgcc_s.so.1: 0x7ffff7496000-0x7ffff74ad000
    emu.mem_map(0x7ffff7496000, 0x17000, 0o5)
    emu.mem_write(0x7ffff7496000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7496000.raw', 'rb').read())

    # Mapping /lib/x86_64-linux-gnu/libgcc_s.so.1: 0x7ffff74ad000-0x7ffff76ac000
    emu.mem_map(0x7ffff74ad000, 0x1ff000, 0o0)
    # Mapping /lib/x86_64-linux-gnu/libgcc_s.so.1: 0x7ffff76ac000-0x7ffff76ad000
    emu.mem_map(0x7ffff76ac000, 0x1000, 0o1)
    emu.mem_write(0x7ffff76ac000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff76ac000.raw', 'rb').read())

    # Mapping /lib/x86_64-linux-gnu/libgcc_s.so.1: 0x7ffff76ad000-0x7ffff76ae000
    emu.mem_map(0x7ffff76ad000, 0x1000, 0o3)
    emu.mem_write(0x7ffff76ad000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff76ad000.raw', 'rb').read())

    # Mapping /lib/x86_64-linux-gnu/libm-2.27.so: 0x7ffff76ae000-0x7ffff784b000
    emu.mem_map(0x7ffff76ae000, 0x19d000, 0o5)
    emu.mem_write(0x7ffff76ae000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff76ae000.raw', 'rb').read())

    # Mapping /lib/x86_64-linux-gnu/libm-2.27.so: 0x7ffff784b000-0x7ffff7a4a000
    emu.mem_map(0x7ffff784b000, 0x1ff000, 0o0)
    # Mapping /lib/x86_64-linux-gnu/libm-2.27.so: 0x7ffff7a4a000-0x7ffff7a4b000
    emu.mem_map(0x7ffff7a4a000, 0x1000, 0o1)
    emu.mem_write(0x7ffff7a4a000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7a4a000.raw', 'rb').read())

    # Mapping /lib/x86_64-linux-gnu/libm-2.27.so: 0x7ffff7a4b000-0x7ffff7a4c000
    emu.mem_map(0x7ffff7a4b000, 0x1000, 0o3)
    emu.mem_write(0x7ffff7a4b000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7a4b000.raw', 'rb').read())

    # Mapping /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.25: 0x7ffff7a4c000-0x7ffff7bc5000
    emu.mem_map(0x7ffff7a4c000, 0x179000, 0o5)
    emu.mem_write(0x7ffff7a4c000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7a4c000.raw', 'rb').read())

    # Mapping /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.25: 0x7ffff7bc5000-0x7ffff7dc5000
    emu.mem_map(0x7ffff7bc5000, 0x200000, 0o0)
    # Mapping /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.25: 0x7ffff7dc5000-0x7ffff7dcf000
    emu.mem_map(0x7ffff7dc5000, 0xa000, 0o1)
    emu.mem_write(0x7ffff7dc5000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7dc5000.raw', 'rb').read())

    # Mapping /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.25: 0x7ffff7dcf000-0x7ffff7dd1000
    emu.mem_map(0x7ffff7dcf000, 0x2000, 0o3)
    emu.mem_write(0x7ffff7dcf000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7dcf000.raw', 'rb').read())

    # Mapping : 0x7ffff7dd1000-0x7ffff7dd5000
    emu.mem_map(0x7ffff7dd1000, 0x4000, 0o3)
    emu.mem_write(0x7ffff7dd1000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7dd1000.raw', 'rb').read())

    # Mapping /lib/x86_64-linux-gnu/ld-2.27.so: 0x7ffff7dd5000-0x7ffff7dfc000
    emu.mem_map(0x7ffff7dd5000, 0x27000, 0o5)
    emu.mem_write(0x7ffff7dd5000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7dd5000.raw', 'rb').read())

    # Mapping : 0x7ffff7fc5000-0x7ffff7fcb000
    emu.mem_map(0x7ffff7fc5000, 0x6000, 0o3)
    emu.mem_write(0x7ffff7fc5000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7fc5000.raw', 'rb').read())

    # Mapping [vdso]: 0x7ffff7ffa000-0x7ffff7ffc000
    emu.mem_map(0x7ffff7ffa000, 0x2000, 0o5)
    emu.mem_write(0x7ffff7ffa000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7ffa000.raw', 'rb').read())

    # Mapping /lib/x86_64-linux-gnu/ld-2.27.so: 0x7ffff7ffc000-0x7ffff7ffd000
    emu.mem_map(0x7ffff7ffc000, 0x1000, 0o1)
    emu.mem_write(0x7ffff7ffc000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7ffc000.raw', 'rb').read())

    # Mapping /lib/x86_64-linux-gnu/ld-2.27.so: 0x7ffff7ffd000-0x7ffff7ffe000
    emu.mem_map(0x7ffff7ffd000, 0x1000, 0o3)
    emu.mem_write(0x7ffff7ffd000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7ffd000.raw', 'rb').read())

    # Mapping : 0x7ffff7ffe000-0x7ffff7fff000
    emu.mem_map(0x7ffff7ffe000, 0x1000, 0o3)
    emu.mem_write(0x7ffff7ffe000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffff7ffe000.raw', 'rb').read())

    # Mapping [stack]: 0x7ffffffde000-0x7ffffffff000
    emu.mem_map(0x7ffffffde000, 0x21000, 0o3)
    emu.mem_write(0x7ffffffde000, open('/tmp/gef-crack3-by-D4RK_FL0W-0x7ffffffde000.raw', 'rb').read())

    # Mapping [vsyscall]: 0xffffffffff600000-0xffffffffff601000
    emu.mem_map(0xffffffffff600000, 0x1000, 0o5)
    emu.mem_write(0xffffffffff600000, open('/tmp/gef-crack3-by-D4RK_FL0W-0xffffffffff600000.raw', 'rb').read())

    emu.hook_add(unicorn.UC_HOOK_CODE, code_hook)
    emu.hook_add(unicorn.UC_HOOK_INTR, intr_hook)
    emu.hook_add(unicorn.UC_HOOK_INSN, syscall_hook, None, 1, 0, unicorn.x86_const.UC_X86_INS_SYSCALL)
    return emu

def emulate(emu, start_addr, end_addr, print_debug=False):
    if print_debug:
        print("========================= Initial registers =========================")
        print_regs(emu, registers)

    try:
        if print_debug:
            print("========================= Starting emulation =========================")
        emu.emu_start(start_addr, end_addr)
    except Exception as e:
        emu.emu_stop()
        print("========================= Emulation failed =========================")
        print("[!] Error: {}".format(e))

    if print_debug:
        print("========================= Final registers =========================")
        print_regs(emu, registers)
    return

import itertools
import subprocess

logs_file = open('emu.log', 'w')

for chance in itertools.product(range(10), repeat=4):

    emu = reset()

    # [gdb] x/4w $rax
    emu.mem_write(0x5555555583c0,   b"\x00\x00\x00"+bytes.fromhex(str(chance[0]).zfill(2)))
    emu.mem_write(0x5555555583c0,   b"\x00\x00\x00"+bytes.fromhex(str(chance[1]).zfill(2)))
    emu.mem_write(0x5555555583c0,   b"\x00\x00\x00"+bytes.fromhex(str(chance[2]).zfill(2)))
    emu.mem_write(0x5555555583c0,   b"\x00\x00\x00"+bytes.fromhex(str(chance[3]).zfill(2)))

    emulate(emu, 0x555555555269, 0x555555555328)

    rax_value = emu.reg_read(unicorn.x86_const.UC_X86_REG_RAX)
    rbx_value = emu.reg_read(unicorn.x86_const.UC_X86_REG_RBX)

    print("=================================================")
    message = "RESULT for emulation "+str(chance)+"="+str(rax_value)+"|"+str(rbx_value)+"\n"
    print(message)
    logs_file.write(message)
    logs_file.flush()
    
    print("=================================================")

    if rax_value == 1 or rbx_value == 1:
        print("=================================================")
        print("FOUND CRACK CODE = "+str(chance))
        print("=================================================")
        exit()

# unicorn-engine script generated by gef
