global start

section .text
    start:
        mov rax, 1  ; write syscall
        mov rdi, 1  ; fd stdout
        mov rsi, hello_world
        mov rdx, hello_world.lenght
        syscall

        mov rax, 60 ; exit syscall
        mov rdi, 11
        syscall

section .data
    hello_world: db "hello world"
    hello_world.lenght equ $-hello_world    ; equ = define constant value, $ current position
                                            ; hello_world.lenght = current position - hello_world tag position