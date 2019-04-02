section .text
	global _start 

_start:
    push 1
	pop rax             ; 'write' system call = 1
	push 1              ; file descriptor 1 = STDOUT
    pop rdi
    push 'DONE'
	pop rsi             ; string to write
	push 8
    pop rdx             ; length of string to write
	syscall             ; call the kernel