// main.go
package main

import "fmt"

// version is set by the build process
var version = "dev"

func main() {
	fmt.Printf("Hello from go-template-project-rendered! Version: %s\n", version)
}

