package main

import (
	"fmt"
	"os"

	"./cli"
	"./crypter"
	"./shellcoderun"
)

func main() {

	shellcode, keyString, action, err := cli.ParseUserInput()

	fmt.Printf("Input size is: %d bytes\n", len(shellcode))
	fmt.Printf("% x\n", shellcode)
	fmt.Printf("Key size is: %d bytes\n", len(keyString))
	fmt.Println(keyString)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	key := []byte(keyString)

	result := []byte{}

	// Encrypt
	if action == 0 {
		fmt.Println("Calling encrypt...")
		result, err = crypter.Encrypt(key, shellcode)
	}

	// Decrypt or decryp and run
	if action == 1 || action == 2 {
		fmt.Println("Calling decrypt...")
		result, err = crypter.Decrypt(key, shellcode)
	}

	if err != nil {
		fmt.Println("Action failed!")
		fmt.Println(err)
		os.Exit(1)
	}

	if len(result) == 0 {
		fmt.Println("error: result lenght is zero")
		os.Exit(1)
	}
	fmt.Printf("Result size is: %d bytes\n", len(result))

	// Run
	if action == 2 {
		fmt.Println("Calling run...")
		shellcoderun.Run(result)
	}

	fmt.Print("Result [Hex]:\n")
	fmt.Printf("% x\n", result)

	fmt.Print("Result [String]:\n")
	fmt.Printf("%s\n", result)
}
