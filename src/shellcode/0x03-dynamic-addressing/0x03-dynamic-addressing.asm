; this is the first impl. it has null bytes
;
; global _start

; _start:
;         jmp short pushStringAddress
;         payload:
;             mov rax, 4    ; syscall write
;             mov rbx, 1    ; stdout file descriptor is 1
;             pop rcx       ; get the address of the string from the stack
;             mov rdx, 5    ; length of the string
;             int 0x80
;             jmp short end
;         pushStringAddress:
;             call payload  ; put the address of the string on the stack
;             db 'hello\n'
;         end:

global _start
_start:
  jmp short pushStringAddress
payload:
  xor rax, rax  ; zero out rax
  inc rax       ; rax = 1
  shl rax, 2    ; rax = 1 * 2 * 2 = 4
  
  xor rbx, rbx  ; zero out rbx
  inc rbx       ; rbx = 1 (stdout file descriptor is 1)
  
  pop rcx       ; get the address of the string from the stack
  
  inc rdx       ; rdx = 1
  shl rdx, 2    ; rdx = 1 * 2 * 2 = 4
  inc rdx       ; length of the string
  
  int 0x80      ; syscall
  jmp short end
pushStringAddress:
  call payload  ; put the address of the string on the stack
  db 'hello\n'
end:
        