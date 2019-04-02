global _start
section .text

sys.brk equ 12

_start:
int3
xor rdi, rdi
xor rax, rax
mov al, sys.brk
syscall
; rax = address of break (top of the data segment)
int3