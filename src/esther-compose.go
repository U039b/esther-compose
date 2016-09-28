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
        "./mustache"
        "encoding/json"
        "strings"
        "text/template"
        "io/ioutil"
)
func check(e error) {
    if e != nil {
        panic(e)
    }
}

func read_input() string {
    var json string = ""
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		json += scanner.Text()
	}
	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "reading standard input:", err)
	}
    return json
}

func is_piped() bool {
    stat, _ := os.Stdin.Stat()
    return (stat.Mode() & os.ModeCharDevice) == 0
}

func ReadFileContent(path string) ([]byte, error) {
    return ioutil.ReadFile(path);
}

func Process(templateFile string, outputFile string, useMustache bool, parameters interface{}) {
    if useMustache {
        t, err := mustache.ParseFile(templateFile)
        check(err)
        s, _ := t.Render(parameters)
        if strings.Compare("EMPTY", outputFile) != 0 {
            f, err := os.Create(outputFile)
            check(err)
            defer f.Close()
            w := bufio.NewWriter(f)
            _, err = w.WriteString(s)
            w.Flush()
            check(err)
            fmt.Println("Finish")
        } else {
            fmt.Printf("%s\n", s)
        }
    } else {
        // Get template content
        tpl, err := ReadFileContent(templateFile);
        check(err);

        // Create a new template and parse
	    t := template.Must(template.New("t").Parse(string(tpl)));

        if strings.Compare("EMPTY", outputFile) != 0 {
            f, err := os.Create(outputFile)
            check(err)
            defer f.Close()
            w := bufio.NewWriter(f)
            t.Execute(w, parameters);
            w.Flush()
            check(err)
            fmt.Println("Finish")
        } else {
            check(t.Execute(os.Stdout, parameters))
        }

    }
}

func main() {
    inputFilePtr := flag.String("t", "./template.txt", "the template file")
    outputFilePtr := flag.String("o", "EMPTY", "the output file")
    mustachePtr := flag.Bool("m", false, "use mustache engine")
    flag.Parse()

    fmt.Println(*mustachePtr);

    json_txt := read_input()
    var obj interface{}
    json.Unmarshal([]byte(json_txt), &obj)
    Process(*inputFilePtr, *outputFilePtr, *mustachePtr, obj)
}
