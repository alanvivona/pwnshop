# pwnshop
Notes, cheatsheets, shellcode and exploits.

## Contents:
- Utility - Object/Executable file to shellcode converter script: [code](https://github.com/alanvivona/pwnshop/blob/master/utils/obj2shellcode)    
- Utility - Assembly and link script : [code](https://github.com/alanvivona/pwnshop/blob/master/utils/asm-and-link)    
- Utility - Shellcode testing skeleton generator : [code](https://github.com/alanvivona/pwnshop/blob/master/utils/gen-shellcode-test)    
- Exit syscall asm: [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x00-calling-exit-syscall/0x00-exitSyscall.asm)
- Write syscall "Hello world!": [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x01-calling-write-syscall/0x01-calling-write-syscall.asm)
- Execve shellcode (dynamic addressing) [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x02-execve-dynamic-addressing/0x02-dynamic-addressing.asm)
- Ret2libc exploit for protostar stack6 challenge : [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x03-system-for-ret2libc/pwn.py)
- Exploit for protostar stack7 challenge (Smallest ROP chain): [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x04-simplest-rop-ever/roppwn.py)
- Writeup for protostar stack challenges: [WIP]
- Exploit for VUPlayer 2.49 (no DEP) local buffer overflow: [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x07-windows-EDBID-40018-localbof/exploit.js), [writeup](https://medium.com/@0x0FFB347/windows-expliot-dev-101-e5311ac284a)
- Exploit for FreeFloat FTP, remote buffer overflow: [WIP+WRITEUP]
- Protostar format string challenges [WIP]
- Execve shellcode (stack method) : [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0A-execve-stack/execvestack.nasm)  
- Execve shellcode using RIP relative addressing [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0B-execve-rip-relative-addressing/execve-rip-relative.nasm)  
- Password Protected Bind Shell (Linux/x64) [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0D-SLAE64-1-tcp-bind-shell-auth/tcp-bind-shell-auth-smaller.nasm), [writeup](https://medium.com/bugbountywriteup/writing-a-password-protected-bind-shell-linux-x64-e052d2f65ff2)  
- Password Protected Reverse Shell (Linux/x64) [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0E-SLAE64-2-reverse-tcp-auth/reverse-tcp-with-auth.nasm), [writeup](https://medium.com/@0x0FFB347/writing-a-password-protected-reverse-shell-linux-x64-5f4d3a28d91a)  
- XANAX - A custom shellcode encoder written in assembly :  
    - [encoder code](https://github.com/alanvivona/pwnshop/blob/master/src/0x10-SLAE64-4-custom-encoder/xanax-encoder.nasm)  
    - [encoder on exploit-db](https://www.exploit-db.com/shellcodes/46679)  
    - [encoder on packetstormsecurity](https://packetstormsecurity.com/files/152456/Linux-x64-XANAX-Encoder-Shellcode.html)
    - [decoder code](https://github.com/alanvivona/pwnshop/blob/master/src/0x10-SLAE64-4-custom-encoder/xanax-decoder.nasm)  
    - [decoder on exploit-db](https://www.exploit-db.com/shellcodes/46680)  
    - [decoder on packetstormsecurity](https://packetstormsecurity.com/files/152455/Linux-x64-XANAX-Decoder-Shellcode.html)
    - [writeup](https://medium.com/@0x0FFB347/writing-a-custom-shellcode-encoder-31816e767611)  
- A more generic (and somewhat extensible) encoder skeleton written in Go [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x10-SLAE64-4-custom-encoder/encoder.go)   
- Gocryper : A custom AES shellcode crypter written in Go [code](https://github.com/alanvivona/pwnshop/tree/master/src/0x14-SLAE64-crypter), [writeup](https://medium.com/syscall59/a-trinity-of-shellcode-aes-go-f6cec854f992)  
- A basic Polimorphic Engine written in Go [code](https://github.com/alanvivona/pwnshop/tree/master/src/0x12-SLAE-shellstorm-polymorph), [writeup](https://medium.com/me/stats/post/73ec56a2353e)    
- Egg-hunter shellcode (Linux/x64) [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0F-SLAE64-3-egghunter/egghunter-V1.nasm), [writeup](https://medium.com/syscall59/on-eggs-and-egg-hunters-linux-x64-305b947f792e)  
- Password Protected Reverse Shell (Linux/ARMv6)  
    - [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x15-ARM-shellcode/ARM-reverse-shell-with-auth.s)
    - [writeup](https://medium.com/syscall59/shellcode-for-iot-a-password-protected-reverse-shell-linux-arm-a18fcda4853b)
    - [payload on packetstormsecurity](https://packetstormsecurity.com/files/152602/Linux-ARM-Password-Protected-Reverse-TCP-Shell-Shellcode.html)
    - [payload on exploit-db](https://www.exploit-db.com/shellcodes/46736)
- DEFCON Qualys 2019 : Speedrun-001 exploit (Stack-based bof + ROP) [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x17-defcon-qualys-2019/speedrun-001-exploit.py)


### Resources:
There's a **LOT** of stuff out there. These are just the most useful things I've found so far. I only list stuff that I have already seen/read/used.  
- [Live overflow](https://liveoverflow.com/)
- [The shellcoder's handbook](https://www.amazon.com/Shellcoders-Handbook-Discovering-Exploiting-Security/dp/047008023X)
- [Exploit education](https://exploit.education/)
- [Gynvael coldwind](https://gynvael.coldwind.pl/)
- [Phrack](http://phrack.org/)
- [Corelan](https://www.corelan.be/index.php/articles/)
- [Fuzzysecurity](https://www.fuzzysecurity.com/index.html)
- [Packetstormsecurity](https://packetstormsecurity.com/)
- [Exploitdb](https://www.exploit-db.com/)
- [Beginners RE](https://beginners.re/)
- [Practical reverse engineering](https://www.amazon.com/Practical-Reverse-Engineering-Reversing-Obfuscation/dp/1118787315)
- [Programming linux anti-reversing techniques](https://leanpub.com/anti-reverse-engineering-linux)
- [Radare2](https://radare.org/)
- [Attacking network protocols](https://nostarch.com/networkprotocols)
- [Pentester academy](https://www.pentesteracademy.com/)
- [Penetration testing: A Hands-On introduction to hacking](https://www.amazon.com/Penetration-Testing-Hands-Introduction-Hacking/dp/1593275641)
