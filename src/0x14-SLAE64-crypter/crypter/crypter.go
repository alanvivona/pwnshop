package crypter

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"errors"
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

	return ciphertext, nil
}

// Decrypt ...
func Decrypt(key []byte, text []byte) ([]byte, error) {

	// Init decipher
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	if (len(text) % aes.BlockSize) != 0 {
		return nil, errors.New("wrong blocksize")
	}

	// Getting the IV
	iv := text[:aes.BlockSize]

	// Actual decryption
	decodedCipherMsg := text[aes.BlockSize:]
	cfbDecrypter := cipher.NewCFBDecrypter(block, iv)
	cfbDecrypter.XORKeyStream(decodedCipherMsg, decodedCipherMsg)

	// Removing Padding
	length := len(decodedCipherMsg)
	paddingLen := int(decodedCipherMsg[length-1])
	result := decodedCipherMsg[:(length - paddingLen)]
	return result, nil
}
