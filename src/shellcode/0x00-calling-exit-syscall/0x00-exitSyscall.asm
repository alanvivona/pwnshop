;  v1 : minimum amount of code needed stripped from the C compiled program
; This has NULLs, no good
mov ebx, 0x00
mov eax, 0x01   ; syscall 1 = exit
int 0x80

; 0:  bb 00 00 00 00          mov    ebx,0x0
; 5:  b8 01 00 00 00          mov    eax,0x1
; a:  cd 80                   int    0x80

; "\xBB\x00\x00\x00\x00\xB8\x01\x00\x00\x00\xCD\x80"

;  v2 : switching some instructions to reduce the size, also no NULLs this time
xor ebx, ebx    ; smaller than mov ebx, 0x00
xor eax, eax    ; these two instructions combined are smaller than mov eax, 0x01
inc eax         ;  syscall 1 = exit
int 0x80

; 0:  31 db                   xor    ebx,ebx
; 2:  31 c0                   xor    eax,eax
; 4:  40                      inc    eax
; 5:  cd 80                   int    0x80

; "\x31\xDB\x31\xC0\x40\xCD\x80"

;  v3 : using smaller registers. This is actually one byte bigger than V2, I'll leave it here as an example
xor ebx, ebx    ; smaller than mov ebx, 0x00
xor eax, eax    ; these two instructions combined are smaller than mov eax, 0x01
inc al         ;  syscall 1 = exit
int 0x80

; 0:  31 db                   xor    ebx,ebx
; 2:  31 c0                   xor    eax,eax
; 4:  fe c0                   inc    al
; 6:  cd 80                   int    0x80

; "\x31\xDB\x31\xC0\xFE\xC0\xCD\x80"
