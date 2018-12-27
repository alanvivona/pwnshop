; Define variables in the data section
section .data
	message:    db 'Hello world!',10
	msgLen:     equ $-message

; Code goes in the text section
section .text
	global _start 

_start:
	mov eax,4           ; 'write' system call = 4
	mov ebx,1           ; file descriptor 1 = STDOUT
	mov ecx,message     ; string to write
	mov edx,msgLen      ; length of string to write
	int 80h             ; call the kernel

	; Terminate program
	mov eax,1            ; 'exit' system call = 1
	mov ebx,0            ; exit with error code 0
	int 80h              ; call the kernel