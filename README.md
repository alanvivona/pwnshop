# pwnshop
Notes, cheatsheets, shellcode and exploits.

## Progress:
- Utility - Object/Executable file to shellcode converter script: [code](https://github.com/alanvivona/pwnshop/blob/master/utils/obj2shellcode)    
- Utility - Assembly and link script : [code](https://github.com/alanvivona/pwnshop/blob/master/utils/asm-and-link)    
- Utility - Shellcode testing skeleton generator : [code](https://github.com/alanvivona/pwnshop/blob/master/utils/gen-shellcode-test)    
- Exit syscall asm: [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x00-calling-exit-syscall/0x00-exitSyscall.asm)
- Write syscall "Hello world!": [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x01-calling-write-syscall/0x01-calling-write-syscall.asm)
- Execve shellcode (dynamic addressing) [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x02-execve-dynamic-addressing/0x02-dynamic-addressing.asm)
- Ret2libc exploit for protostar stack6 challenge : [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x03-system-for-ret2libc/pwn.py)
- Exploit for protostar stack7 challenge : [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x04-simplest-rop-ever/roppwn.py)
- Writeup for protostar stack challenges: [WIP]
- Exploit for VUPlayer 2.49 (no DEP) local buffer overflow: [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x07-windows-EDBID-40018-localbof/exploit.js), [writeup](https://medium.com/@0x0FFB347/windows-expliot-dev-101-e5311ac284a)
- Exploit for FreeFloat FTP, remote buffer overflow: [WIP+WRITEUP]
- Protostar format string challenges [WIP]
- Execve shellcode (stack method) : [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0A-execve-stack/execvestack.nasm)  
- Execve shellcode using RIP relative addressing [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0B-execve-rip-relative-addressing/execve-rip-relative.nasm)  
- Password Protected Bind Shell (Linux/x64) [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0D-SLAE64-1-tcp-bind-shell-auth/tcp-bind-shell-auth-smaller.nasm), [writeup](https://medium.com/bugbountywriteup/writing-a-password-protected-bind-shell-linux-x64-e052d2f65ff2)  
- Password Protected Reverse Shell (Linux/x64) [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0E-SLAE64-2-reverse-tcp-auth/reverse-tcp-with-auth.nasm), [writeup](https://medium.com/@0x0FFB347/writing-a-password-protected-reverse-shell-linux-x64-5f4d3a28d91a)  

### Related resources:
- live overflow
- the shellcodes handbook
- exploit-education's protostar and fusion challenges
- gynvael coldwind
- corelan
- fuzzysecurity
