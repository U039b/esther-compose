package main

import ("bufio"
        "fmt"
        "os"
        "flag"
        "runtime"
        "strings"
        "./mustache"
)
func check(e error) {
    if e != nil {
        panic(e)
    }
}

func ParseArguments(args []string) map[string]string {
    m := make(map[string]string)
    for index, entry := range args {
        vars := strings.Split(entry, "=")
        if(len(vars) != 2){
            continue
        }
        k := vars[0]
        v := vars[1]
        m[k] = v
    }
    return m
}

func Process(templateFile string, outputFile string, parameters map[string]string) {
    t, err := mustache.ParseFile(templateFile)
    check(err)
    s, _ := t.Render(parameters)
    f, err := os.Create(outputFile)
    check(err)
    defer f.Close()
    w := bufio.NewWriter(f)
    _, err = w.WriteString(s)
    w.Flush()
    check(err)
}

func main() {
    fmt.Printf("OS: %s\nArchitecture: %s\n", runtime.GOOS, runtime.GOARCH)
    inputFilePtr := flag.String("input-file", "./template.esther", "the template file")
    outputFilePtr := flag.String("output-file", "./output", "the output file")
    flag.Parse()
    m := ParseArguments(flag.Args())
    Process(*inputFilePtr, *outputFilePtr, m)
}
