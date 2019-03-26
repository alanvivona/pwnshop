package shellcoderun

/*
#include <stdio.h>
#include <sys/mman.h>
#include <string.h>
#include <unistd.h>
void execute(char *shellcode, size_t length) {
	unsigned char *ptr;
	ptr = (unsigned char *) mmap(0, length, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
	memcpy(ptr, shellcode, length);
	( *(void(*) ()) ptr)();
}
*/
import "C"
import (
	"unsafe"
)

// Run ...
func Run(shellcode []byte) {
	ptr := &shellcode[0]
	size := len(shellcode)
	C.execute((*C.char)(unsafe.Pointer(ptr)), (C.size_t)(size))
}
