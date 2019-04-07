package main

import (
	"fmt"
	"math/rand"
	"strconv"
	"strings"
	"time"
)

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

func polymorph(lexer lex) equivalence {
	equivalences := polymorphRules[lexer.AbstractRepresentation]

	if len(equivalences) == 0 {
		// fmt.Printf("No equivalences found. Returning original string\n")
		return equivalence{lexer.OriginalString}
	}

	rand.Seed(time.Now().UnixNano())
	choiceIndex := rand.Intn(len(equivalences))
	choice := equivalences[choiceIndex]
	fmt.Printf("Found %d equivalences. Will use n %d : %+v\n", len(equivalences), choiceIndex, choice)

	result := equivalence{}
	for _, piece := range choice {
		resultPiece := strings.Replace(piece, "", "", -1)
		result = append(result, resultPiece)
	}

	for valueIndex, value := range lexer.Values {
		for resultIndex, resultPiece := range result {
			//fmt.Printf("valueIndex: %d, value: %s, resultIndex: %d, resultPiece: %s, replaceString: %s\n", valueIndex, value, resultIndex, resultPiece, "$"+strconv.Itoa(valueIndex+1))
			result[resultIndex] = strings.Replace(resultPiece, "$"+strconv.Itoa(valueIndex+1), value, -1)
			//fmt.Printf("result: %+v\n", result)

		}
	}
	//fmt.Printf("Converted %s into %s\n", lexer.AbstractRepresentation, result)
	return result
}
