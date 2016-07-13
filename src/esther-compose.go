// This file is part of Esther-compose.
//
// Esther-compose is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Esther-compose is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Esther-compose.  If not, see <http://www.gnu.org/licenses/>.
//
// Authored by U+039b <*[at]0x39b[dot]fr>
// GPG: 29AF AD6D 8148 48FB 8147 3CEF E564 0E6E 5683 039D

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
