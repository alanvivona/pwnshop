# pwnshop

Notes, cheatsheets and sample exploits I'm writing while learning binary exploitation from sources like:
- live overflow
- the shellcodes handbook
- exploit-education's protostar and fusion challenges
- gynvael coldwind
- corelan
- fuzzysecurity

## Progress:
- Utility - Object/Executable file to shellcode converter script: [code](https://github.com/alanvivona/pwnshop/blob/master/utils/obj2shellcode)    
- Utility - Assembly and link script : [code](https://github.com/alanvivona/pwnshop/blob/master/utils/asm-and-link)    
- Exit syscall asm: [code](https://github.com/alanvivona/pwnshop/blob/master/src/exploits/0x00-calling-exit-syscall/0x00-exitSyscall.asm)
- Write syscall "Hello world!": [code](https://github.com/alanvivona/pwnshop/blob/master/src/exploits/0x01-calling-write-syscall/0x01-calling-write-syscall.asm)
- Execve shellcode (dynamic addressing) [code](https://github.com/alanvivona/pwnshop/blob/master/src/exploits/0x02-execve-dynamic-addressing/0x02-dynamic-addressing.asm)
- Ret2libc exploit for protostar stack6 challenge : [code](https://github.com/alanvivona/pwnshop/blob/master/src/exploits/0x03-system-for-ret2libc/pwn.py)
- Exploit for protostar stack7 challenge : [code](https://github.com/alanvivona/pwnshop/blob/master/src/exploits/0x04-simplest-rop-ever/roppwn.py)
- Writeup for protostar stack challenges: [WIP]
- Exploit for VUPlayer 2.49 (no DEP) local buffer overflow: [code](https://github.com/alanvivona/pwnshop/blob/master/src/exploits/0x07-windows-EDBID-40018-localbof/exploit.js), [writeup](https://medium.com/@0x0FFB347/windows-expliot-dev-101-e5311ac284a)
- Exploit for FreeFloat FTP, remote buffer overflow: [WIP+WRITEUP]
- Protostar format string challenges [WIP]
- Execve shellcode (stack method) [code](https://github.com/alanvivona/pwnshop/blob/master/src/exploits/0x0A-execve-stack/execvestack.nasm)  
- Execve shellcode using RIP relative addressing [WIP]  
