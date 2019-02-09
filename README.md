# pwnshop

Notes, cheatsheets and sample exploits I'm writing while learning binary exploitation from sources like:
- live overflow
- the shellcodes handbook
- exploit-education's protostar and fusion challenges
- gynvael coldwind
- corelan
- fuzzysecurity

## Progress:
- Hand-crafted exit syscall asm: [code](https://github.com/alanvivona/pwnshop/blob/master/src/exploits/0x00-calling-exit-syscall/0x00-exitSyscall.asm)
- Hand-crafted write syscall "Hello world!": [code](https://github.com/alanvivona/pwnshop/blob/master/src/exploits/0x01-calling-write-syscall/0x01-calling-write-syscall.asm)
- Hand-crafted execve shellcode [WIP]
- Ret2libc exploit for protostar stack6 challenge : [code](https://github.com/alanvivona/pwnshop/blob/master/src/exploits/0x05-system-for-ret2libc/pwn.py)
- Exploit for protostar stack7 challenge : [code](https://github.com/alanvivona/pwnshop/blob/master/src/exploits/0x06-simplest-rop-ever/roppwn.py)
- Writeup for protostar stack challenges: [WIP]
- Exploit for VUPlayer 2.49 (no DEP) local buffer overflow: [code](https://github.com/alanvivona/pwnshop/blob/master/src/exploits/0x09-windows-EDBID-40018-localbof/exploit.js), [writeup](https://medium.com/@0x0FFB347/windows-expliot-dev-101-e5311ac284a)
- Exploit for FreeFloat FTP, remote buffer overflow: [WIP+WRITEUP]
- Protostar format string challenges [WIP]
