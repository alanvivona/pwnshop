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


char code[] = "\xb0\x01\x31\xdb\xcd\x80";
int main(int argc, char **argv)
{
  int (*func)();
  func = (int (*)()) code;
  (int)(*func)();
}