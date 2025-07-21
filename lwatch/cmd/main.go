package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"
	"time"

	"github.com/fatih/color"
)

var levelPriority = map[string]int{
	"TRACE": 0,
	"DEBUG": 1,
	"INFO":  2,
	"WARN":  3,
	"ERROR": 4,
}

var keywordColour = color.New(color.FgHiYellow)
var classColour = color.New(color.FgHiYellow)
var methodColour = color.New(color.FgHiGreen)
var levelColour = map[string]*color.Color{
	"TRACE": color.New(color.FgWhite),
	"DEBUG": color.New(color.FgBlue),
	"INFO":  color.New(color.FgGreen),
	"WARN":  color.New(color.FgHiMagenta),
	"ERROR": color.New(color.FgRed),
}

var timestampColor = color.New(color.FgHiGreen)

func main() {
	keyword := ""
	if len(os.Args) > 2 {
		keyword = os.Args[2]
	}

	minLevel := os.Args[1]
	minPriority := levelPriority[strings.ToUpper(minLevel)]

	logFile := os.Getenv("LOG_FILE")
	file, err := os.Open(logFile)
	if err != nil {
		fmt.Println("Error opening file", err)
		return
	}
	defer file.Close()

	file.Seek(0, os.SEEK_END)
	reader := bufio.NewReader(file)

	levelRegex := regexp.MustCompile(`\b(TRACE|DEBUG|INFO|WARN|ERROR)\b`)
	timestampRegex := regexp.MustCompile(`[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{3}`)
	classMethodRegex := regexp.MustCompile(`((?:[a-z_]+\.)*[A-Z][A-Za-z0-9_]+:)([a-zA-Z0-9_]+)`)

	for {
		line, err := reader.ReadString('\n')

		if err != nil {
			time.Sleep(250 * time.Millisecond)
			continue
		}

		match := levelRegex.FindString(line)
		if match == "" || levelPriority[match] < minPriority {
			continue
		}

		line = timestampRegex.ReplaceAllStringFunc(line, func(ts string) string {
			return timestampColor.Sprint(ts)
		})

		coloured := levelColour[match].Sprint(match)
		line = strings.Replace(line, match, coloured, 1)

		if keyword != "" && strings.Contains(strings.ToLower(line), strings.ToLower(keyword)) {
			line = strings.ReplaceAll(line, keyword, keywordColour.Sprint(keyword))
		}

		line = classMethodRegex.ReplaceAllStringFunc(line, func(match string) string {
			parts := classMethodRegex.FindStringSubmatch(match)
			classPart := parts[1]
			methodPart := parts[2]
			return classColour.Sprint(classPart) + methodColour.Sprint(methodPart)
		})

		fmt.Print(line)
	}
}
