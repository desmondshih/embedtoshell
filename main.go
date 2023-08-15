package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	var rc int
	if len(os.Args) == 2 {
		r, err := strconv.Atoi(os.Args[1])
		if err != nil {
			panic("args should be integer for return code, err: %s")
		}
		rc = r
	} else {
		rc = 0
	}
	fmt.Println("Hello go bin")
	os.Exit(rc)
}
