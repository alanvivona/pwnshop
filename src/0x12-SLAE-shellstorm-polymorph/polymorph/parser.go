package main

import (
	"strconv"
	"strings"
)

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
