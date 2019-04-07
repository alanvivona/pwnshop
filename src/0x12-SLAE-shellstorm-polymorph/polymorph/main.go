package main

//	Basic Polymorphic Engine
//  Author : Alan Vivona
//  Build: go build
//	Test:
//	echo "mov rax, 5" | ./polymorph
//  echo "   mov    rax   ,    5   ;   comment   ,   asd   ;   asd   " | ./polymorph
//  echo "   xor    rax   ,    rax  ;   comment   ,   asd   ;   asd   " | ./polymorph
//  echo " no rule exists for thi one " | ./polymorph
//  echo "xor rax, rax" | ./polymorph
//  echo "nop" | ./polymorph
//  echo "   nop   ;     , , , " | ./polymorph

import (
	"fmt"
	"os"
)

type lex struct {
	Operand                string
	Values                 []string
	AbstractRepresentation string
	OriginalString         string
}

type equivalence []string

var polymorphRules map[string][]equivalence
var archRegisters map[string]bool

func exitIfError(err error) {
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func main() {

	lines, err := readLines()
	exitIfError(err)

	loadPolymorphicRules()
	loadArchitectureRegisters()

	for _, line := range lines {
		//fmt.Printf("Reading Line: '%s'\n", line)
		lexer, err := parse(line)
		exitIfError(err)
		//fmt.Printf("Lexer: '%+v'\n", lexer)

		converted := polymorph(lexer)
		//fmt.Printf("Converted: '%+v'\n", converted)

		for _, piece := range converted {
			fmt.Printf("%s\n", piece)
		}
	}
}
