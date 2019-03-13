BITS 64

global _start

section .text

_start:
    mov rax, 0x15   ; Syscall access number
    mov rdi, 0x00   ; Address to check : 0x00
    mov rsi, 0x00   ; Mode
    syscall
