package main

import (
	"fmt"
	"os"
	"bufio"
	"io"
	"github.com/fatih/color"
)

func main() {
	run()
}

	func run() {
		var previousOffset int64 = 0
	
		file, err := os.Open("file.txt")
		if err != nil {
			fmt.Println("Error opening file", err)
			return
		}
		defer file.Close()

		reader := bufio.NewReader(file)

		lastLineSize := 0

		for {
			line, _, err := reader.ReadLine()

			if err == io.EOF {
				break
			}

			lastLineSize = len(line)
		}

		fileInfo, err := os.Stat("file.txt")

		buffer := make([]byte, lastLineSize)

		offset := fileInfo.Size() - int64(lastLineSize + 1)
		numRead, err := file.ReadAt(buffer, offset)

		c := color.New(color.FgHiGreen)

		if previousOffset != offset {
			buffer = buffer[:numRead]
			c.Printf("%s \n", buffer)

			previousOffset = offset
		}
	}
