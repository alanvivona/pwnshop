package main

import "os"

func main() {

	shellcode, key, action, err := cli.ParseUserInput()
	if err != nil {
		os.Exit(1)
	}

	// Encrypt
	if action == cli.ACTIONS[0] {
		crypter.Encrypt()
	}

	// Decrypt
	if action == cli.ACTIONS[1] {
		crypter.Decrypt()
	}

	// Decrypt and run
	if action == cli.ACTIONS[2] {
		crypter.Run()
	}
}
