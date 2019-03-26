package cli

import (
	"errors"
	"fmt"
	"os"
)

var (
	DEFAULT_KEY = []byte(">follow @syscall59 on tt")
	ACTIONS     = []string{"encrypt", "decrypt", "run"}
)

func ParseUserInput() ([]byte, *string, *string, error) {
	if len(os.Args) != 4 {
		fmt.Printf("Usage: gocrypt {action:[encrypt|decrypt|run]} {shellcode} {key}\n")
		return nil, nil, nil, errors.New("wrong number of arguments. expected 3")
	}

	// Get action
	action := os.Args[1]
	isActionValid := false
	for _, validAction := range ACTIONS {
		if action == validAction {
			isActionValid = true
			break
		}
	}
	if !isActionValid {
		return nil, nil, nil, errors.New("action not valid")
	}

	// Get shellcode
	shellcode := []byte(os.Args[2])

	// Get key
	key := os.Args[3]
	keyLen := len(key)
	if keyLen == 0 {
		fmt.Printf("Falling into default password: %s", DEFAULT_KEY)
	} else {
		if keyLen > 0 && keyLen != 16 && keyLen != 24 && keyLen != 32 {
			return nil, nil, nil, errors.New("not a valid password. lenght should be 16, 24 or 32")
		}
	}

	return shellcode, &key, &action, nil
}

func decryptAndRun(encryptedShellcode *[]byte, password string) error {
	Decrypt(encryptedShellcode, password)
	shellcode := *encryptedShellcode
	Run(shellcode)
	return nil
}
