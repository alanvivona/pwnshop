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
	"bufio"
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"strings"
	"time"
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

	lines, err := file2lines()
	exitIfError(err)

	loadPolymorphicRules()
	loadArchitectureRegisters()

	for _, line := range lines {
		//fmt.Printf("Reading Line: '%s'\n", line)
		lexer, err := parse(line)
		exitIfError(err)
		//fmt.Printf("Lexer: '%+v'\n", lexer)

		converted := polymorph(lexer)
		// fmt.Printf("Converted: '%+v'\n", converted)

		for _, piece := range converted {
			fmt.Printf("%s\n", piece)
		}
	}
}

func loadArchitectureRegisters() {
	archRegisters = map[string]bool{
		"rax":  true,
		"eax":  true,
		"ax":   true,
		"al":   true,
		"rbx":  true,
		"ebx":  true,
		"bx":   true,
		"bl":   true,
		"rcx":  true,
		"ecx":  true,
		"cx":   true,
		"cl":   true,
		"rdx":  true,
		"edx":  true,
		"dx":   true,
		"dl":   true,
		"rsi":  true,
		"esi":  true,
		"si":   true,
		"sil":  true,
		"rdi":  true,
		"edi":  true,
		"di":   true,
		"dil":  true,
		"rbp":  true,
		"ebp":  true,
		"bp":   true,
		"bpl":  true,
		"rsp":  true,
		"esp":  true,
		"sp":   true,
		"spl":  true,
		"r8":   true,
		"r8d":  true,
		"r8w":  true,
		"r8b":  true,
		"r9":   true,
		"r9d":  true,
		"r9w":  true,
		"r9b":  true,
		"r10":  true,
		"r10d": true,
		"r10w": true,
		"r10b": true,
		"r11":  true,
		"r11d": true,
		"r11w": true,
		"r11b": true,
		"r12":  true,
		"r12d": true,
		"r12w": true,
		"r12b": true,
		"r13":  true,
		"r13d": true,
		"r13w": true,
		"r13b": true,
		"r14":  true,
		"r14d": true,
		"r14w": true,
		"r14b": true,
		"r15":  true,
		"r15d": true,
		"r15w": true,
		"r15b": true,
	}
}

func loadPolymorphicRules() {
	polymorphRules = map[string][]equivalence{
		"xor $1 $1": []equivalence{
			equivalence{
				"mov $1, -1",
				"inc $1",
			},
			equivalence{
				"or $1, -1",
				"inc $1",
			},
			equivalence{
				"lea $1,[0]",
			},
			equivalence{
				"mov $1,0",
			},
			equivalence{
				"and $1,0",
			},
			equivalence{
				"sub $1,$1",
			},
			equivalence{
				"push 0",
				"pop $1",
			},
		},
		"mov $1 $2": []equivalence{
			equivalence{
				"xor $1, $1",
				"add $1, $2",
			},
			equivalence{
				"push $2",
				"pop $1",
			},
			equivalence{
				"xchg $1, $2",
				"push $1",
				"pop $2",
			},
		},
		"nop": []equivalence{
			equivalence{
				"and rax, rax",
			},
			equivalence{
				"or rbx, rbx",
			},
		},
		"xchg $1 $2": []equivalence{
			equivalence{
				"xor $1, $2",
				"xor $2, $1",
				"xor $1, $2",
			},
		},
	}
}

func polymorph(lexer lex) equivalence {
	equivalences := polymorphRules[lexer.AbstractRepresentation]

	if len(equivalences) == 0 {
		// fmt.Printf("No equivalences found. Returning original string\n")
		return equivalence{lexer.OriginalString}
	}

	rand.Seed(time.Now().UnixNano())

	choiceIndex := rand.Intn(len(equivalences))

	choice := equivalences[choiceIndex]
	// fmt.Printf("Found %d equivalences. Will use n %d : %+v\n", len(equivalences), choiceIndex, choice)

	result := choice
	for valueIndex, value := range lexer.Values {
		for pieceIndex, piece := range choice {
			result[pieceIndex] = strings.Replace(piece, "$"+strconv.Itoa(valueIndex+1), value, -1)
		}
	}
	// fmt.Printf("Converted %s into %s\n", lexer.AbstractRepresentation, result)
	return result
}

func updateLineParts(lineParts []string, part string) (updatedLineParts []string) {
	if len(part) > 0 && part != " " && part != "," {
		// fmt.Printf("Found part: '%s'\n", part)
		return append(lineParts, part)
	}
	return lineParts
}

func updateAbstractRep(abstractRep string, part string, lineParts []string) (updatedAbstractRep string) {
	if len(part) > 0 && part != " " {
		if len(lineParts) > 1 {
			if part == "," {
				abstractRep += part
			} else {
				abstractRepIndex := 0
				found := false
				for i, linePart := range lineParts {
					if linePart == part && i != len(linePart)-1 {
						abstractRepIndex = i
						found = true
						break
					}
				}
				if found {
					abstractRep += " " + "$" + strconv.Itoa(abstractRepIndex)
				} else {
					abstractRep += " " + "$" + strconv.Itoa(len(lineParts)-1)
				}
			}
		} else {
			// part 1 is the operand
			abstractRep += part
		}
	}
	return abstractRep
}

func parse(line string) (lex, error) {
	// Remove comments
	line = strings.ToLower(line)
	line = strings.Split(line, ";")[0]
	line = strings.Trim(line, " ")
	line = strings.Replace(line, ",", " , ", -1)
	line = strings.Replace(line, "  ", " ", -1)

	if len(line) == 0 {
		return lex{
			AbstractRepresentation: "",
			OriginalString:         line,
		}, nil
	}

	lineParts := []string{}
	archRegisterCount := 0
	for _, part := range strings.Split(line, " ") {
		if len(part) > 0 && part != " " && part != "," {
			// fmt.Printf("Found part: '%s'\n", part)
			lineParts = updateLineParts(lineParts, part)
			if archRegisters[part] {
				archRegisterCount++
			}
		}
	}

	abstractRep := ""
	//fmt.Printf("archRegisterCount : %d, len(lineParts)-1: %d\n", archRegisterCount, len(lineParts)-1)
	if archRegisterCount == len(lineParts)-1 {
		tempLineParts := []string{}
		for _, part := range lineParts {
			tempLineParts = append(tempLineParts, part)
			abstractRep = updateAbstractRep(abstractRep, part, tempLineParts)
		}
	}

	return lex{
		Values:                 lineParts[1:],
		Operand:                lineParts[0],
		AbstractRepresentation: abstractRep,
		OriginalString:         line,
	}, nil

}

func file2lines() ([]string, error) {

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
