package main

import (
	"bufio"
	"fmt"
	"os"
)

func readLines() ([]string, error) {

	scanner := bufio.NewScanner(os.Stdin)

	lines := []string{}

	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		fmt.Println(err)
		return lines, err
	}

	return lines, nil
}
