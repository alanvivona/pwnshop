package main

func main(){
	filepath := "samplefile"
	for _, line := range file2lines(filepath) {
		fmt.Printf("Reading Line: '%s'", line)	
		
		fmt.Printf("Trimmed Line: '%s'", line)

		lex := parse(line)
		
		converted := polymorph(lex)

	}
}

struct Lex {
	Operand string,
	Values string[],
	OriginalString string,
	AbstractRepresentation string
}

var polymorphRules map[string]string[]{
	"xor $1, $1": string[string[]]{
		string[]{
			"mov $1, -1",
			"inc $1",
		},
		string[]{
			"or $1, -1",
			"inc $1",
		},
	},
	"mov $1, $2": string[string[]]{
		string[]{
			"xor $1, $1",
			"add $1, $2",
		},
		string[]{
			"push $2",
			"pop  $1",
		},
		string[]{
			"xchg $1, $2",
			"push $1",
			"pop  $2",
		},
	},
	"nop": string[string[]]{
		string[]{
			"and rax, rax",
		},
		string[]{
			"or rbx, rbx",
		},
	},
}

func polymorph(lex Lex) (err, Lex){



	i := polymorphRules[""]

	return nil, Lex{

	}
}

func parse(line string) (err, Lex){
	// Remove comments
	line = strings.Split(line, ";")[0]

	// Trim extra whitespaces
	line = strings.Trim(line, " ")

	lineParts := string[]{}
	for i, part := range strings.Split(line," ") {
		if part != " " && part != "," {
			lineParts = append(part, lineParts)
		}
	}

	abstractRep := lineParts[0]
	for _, values := range lineParts[1:] {
		abstractRep += values
	}

	return nil, Lex{
		OriginalString: line,
		Operand: lineParts[0],
		Values: lineParts[1:],
		AbstractRepresentation: 
	}

}

func file2lines(filepath string) (err, string[]){
	return nil, [
		"mov rax, 5",
		"xor rax, rax",
		"nop"
	]
}