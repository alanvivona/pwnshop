xor ebx, ebx    ; smaller than mov ebx, 0x00
xor eax, eax    ; these two instructions combined are smaller than mov eax, 0x01
inc eax         ;  syscall 1 = exit
int 0x80