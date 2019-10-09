# pwnshop
> Reverse Engineering and Exploitation.

Check out my [blog](http://medium.syscall59.com), follow me on [Twitter](https://twitter.com/syscall59)!  
### Support the project :  
<a href="https://www.buymeacoffee.com/syscall59" target="_blank"><img src="https://bmc-cdn.nyc3.digitaloceanspaces.com/BMC-button-images/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>

## Contents:
- Reverse engineering a simple crackme called “Just see”: [writeup](https://medium.com/@0x0FFB347/crackme-just-see-c6dda1edb9fb)
- Reverse engineering a level 1 crackme "Easy_firstCrackme-by-D4RK_FL0W": [writeup](https://medium.com/syscall59/reverse-engineering-easy-firstcrackme-by-d4rk-fl0w-73dd4412bca5?source=your_stories_page---------------------------)  
- Utility - Object/Executable file to shellcode converter script: [code](https://github.com/alanvivona/pwnshop/blob/master/utils/obj2shellcode)    
- Utility - Assembly and link script : [code](https://github.com/alanvivona/pwnshop/blob/master/utils/asm-and-link)    
- Utility - Shellcode testing skeleton generator : [code](https://github.com/alanvivona/pwnshop/blob/master/utils/gen-shellcode-test)    
- Utility - GDB python script template : [code](https://github.com/alanvivona/pwnshop/blob/master/utils/gdb-script-template.py)  
- Exit syscall asm: [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x00-calling-exit-syscall/0x00-exitSyscall.asm)
- Write syscall "Hello world!": [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x01-calling-write-syscall/0x01-calling-write-syscall.asm)
- Execve shellcode (dynamic addressing) [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x02-execve-dynamic-addressing/0x02-dynamic-addressing.asm)
- Ret2libc exploit for protostar stack6 challenge : [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x03-system-for-ret2libc/pwn.py)
- Exploit for protostar stack7 challenge (Smallest ROP chain): [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x04-simplest-rop-ever/roppwn.py)
- Exploit for VUPlayer 2.49 (no DEP) local buffer overflow: [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x07-windows-EDBID-40018-localbof/exploit.js), [writeup](https://medium.com/@0x0FFB347/windows-expliot-dev-101-e5311ac284a)
- Execve shellcode (stack method) : [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0A-execve-stack/execvestack.nasm)  
- Execve shellcode using RIP relative addressing [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0B-execve-rip-relative-addressing/execve-rip-relative.nasm)  
- Password Protected Bind Shell (Linux/x64) [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0D-SLAE64-1-tcp-bind-shell-auth/tcp-bind-shell-auth-smaller.nasm), [writeup](https://medium.com/bugbountywriteup/writing-a-password-protected-bind-shell-linux-x64-e052d2f65ff2)  
- Password Protected Reverse Shell (Linux/x64) [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x0E-SLAE64-2-reverse-tcp-auth/reverse-tcp-with-auth.nasm), [writeup](https://medium.com/@0x0FFB347/writing-a-password-protected-reverse-shell-linux-x64-5f4d3a28d91a), [Featured in the 1st number of Paged-Out](https://pagedout.institute/download/PagedOut_001_beta1.pdf)  
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
- MalwareTech's String Challenges crackmes: [writeup](https://medium.com/syscall59/solving-malwaretech-string-challenges-with-some-radare2-magic-98ebd8ff0b88)
- MalwareTech's Shellcode Challenges crackmes: [writeup](http://medium.syscall59.com/solving-malwaretech-shellcode-challenges-with-some-radare2-magic-b91c85babe4b)  
- DEFCON Qualys 2019 : Speedrun-001 exploit (Stack-based bof + ROP): [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x17-defcon-qualys-2019/speedrun-001-exploit.py)
- Solution for the crackme "Crackme2-be-D4RK_FL0W" [writeup](https://medium.com/syscall59/reverse-engineering-crackme2-be-d4rk-fl0w-walkthrough-ea50b851b5f0)  
- Solution for the crackme "Crack3-by-D4RK_FL0W" :
    - Option 1 - Using r2 macros to extract the PIN: [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x19-crackme-darkflow-3/r2.commands)  
    - Option 2 - Using GEF and unicorn-engine emulation to bruteforce the PIN: [code](https://github.com/alanvivona/pwnshop/blob/master/src/0x19-crackme-darkflow-3/emu.py)
    - Blog post exploring both options: [writeup](https://medium.com/syscall59/re-using-macros-emulation-voodo-to-solve-a-crackme-a90566e9c7c9)  
- Utility - r2frida Cheatsheet: [writeup](https://github.com/alanvivona/pwnshop/blob/master/utils/r2frida-cheatsheet.md)  

## Useful links:

### Tools:
A non-exhaustive list of tools I like to use
- [radare2](https://rada.re) (+[Cutter](https://github.com/radareorg/cutter) +[r2frida](https://github.com/nowsecure/r2frida) +[r2pipe](https://github.com/radare/radare2-r2pipe))
- [Ghidra](https://ghidra-sre.org/)
- [x64dbg](https://x64dbg.com)
- [frida](https://www.frida.re/)
- [gdb](https://www.gnu.org/software/gdb/) (+[gdb-dashboard](https://github.com/cyrus-and/gdb-dashboard) +[GEF](https://github.com/hugsy/gef))
- [Valgrind](http://www.valgrind.org/)
- [Pwntools](http://pwntools.com)
- [Wireshark](https://www.wireshark.org/)
- [Binwalk](https://github.com/ReFirmLabs/binwalk)
- strace
- ltrace
- hexdump
- xxd
- [rappel](https://github.com/yrp604/rappel)
- nasm
- gas
- [Unicorn Engine](https://www.unicorn-engine.org/)
- [IDA](https://www.hex-rays.com/products/ida/index.shtml)  



### Resources:
There's a **LOT** of stuff out there. These are just the most useful things I've found so far.    
- :computer: [Live overflow](https://liveoverflow.com/)
- :book: [The shellcoder's handbook](https://amzn.to/2LXi0KH)
- :computer: [Exploit education](https://exploit.education/)
- :computer: [Gynvael coldwind](https://gynvael.coldwind.pl/)
- :computer: [Azeria labs](https://azeria-labs.com/)
- :computer: [Phrack](http://phrack.org/)
- :computer: [Corelan](https://www.corelan.be/index.php/articles/)
- :computer: [Fuzzysecurity](https://www.fuzzysecurity.com/index.html)
- :computer: [Packetstormsecurity](https://packetstormsecurity.com/)
- :computer: [Exploitdb](https://www.exploit-db.com/)
- :book: [Beginners RE](https://beginners.re/)
- :book: [Practical reverse engineering](https://amzn.to/35lKNQy)
- :book: [Programming linux anti-reversing techniques](https://leanpub.com/anti-reverse-engineering-linux)
- :book: [Attacking network protocols](https://amzn.to/35jFO2S)
- :book: [Penetration testing: A Hands-On introduction to hacking](https://amzn.to/2IzzlHy)
- :computer: [Malware Unicorn](https://malwareunicorn.org/#/workshops)  
- :book: [Radare2 Book](https://radare.gitbooks.io/radare2book/)  
- :computer: [Paged-Out!](https://pagedout.institute)  
- :book: [PoC||GTFO I](https://amzn.to/2MDgz3l)  
- :book: [PoC||GTFO II](https://amzn.to/2AS4uBP)  
- :book: [The IDA Pro Book](https://amzn.to/2LXnKUE)  
