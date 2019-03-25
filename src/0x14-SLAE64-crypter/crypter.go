package main

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"errors"
	"fmt"
	"io"
)

func encrypt(key []byte, text []byte) ([]byte, error) {

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

	// base64 padding
	base64Ciphertext := []byte(base64.URLEncoding.EncodeToString(ciphertext))
	result := []byte(bytes.Replace(base64Ciphertext, []byte("="), []byte(""), -1))

	return result, nil
}

func decrypt(key []byte, text []byte) ([]byte, error) {

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
	decodedCipherText, err := base64.URLEncoding.DecodeString(string(textAfterPadding))
	if err != nil {
		return nil, err
	}

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

	return decodedCipherMsg[:(length - paddingLen)], nil
}

func main() {
	key := []byte("LKHlhb899Y09olUi")
	text := []byte("Hello World")
	encryptMsg, _ := encrypt(key, text)
	msg, _ := decrypt(key, encryptMsg)
	fmt.Println(msg)
}
