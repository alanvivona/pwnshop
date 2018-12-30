; this is the original version. it has NULL's in it

global _start

_start:
jmp short pushStringAddress
payload:
  mov rax, 4    ; syscall write
  mov rbx, 1    ; stdout file descriptor is 1
  pop rcx       ; get the address of the string from the stack
  mov rdx, 5    ; length of the string
  int 0x80
  jmp short end
pushStringAddress:
  call payload  ; put the address of the string on the stack
  db 'hello\n'
end: