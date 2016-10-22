# Esther-compose
```
Esther-compose is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Esther-compose is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Esther-compose.  If not, see <http://www.gnu.org/licenses/>.

Authored by U+039b <*[at]0x39b[dot]fr>
GPG: 29AF AD6D 8148 48FB 8147 3CEF E564 0E6E 5683 039D
```

Prefer browsing the code and cloning using this address: http://xb3wzgc3rfq5fv7w.onion/lambda/esther-compose/

## Introduction
**Esther-compose** is a command line tool which wraps [Mustache templating engine](https://mustache.github.io/) and [Go template](https://golang.org/pkg/text/template/). 
**Esther-compose** allows you to 
render any kind of text template. As personal usage, I use it to generate `docker-compose` file from JSON definition.

So **Esther-compose** uses a JSON document as data to render the given template.

## Command line
**Esther-compose** offers these command line options:

  * `-t` path to the template file
  * `-o` path to the rendered file
  * `-m` to use Mustache format, Go template will be used otherwise
  
The JSON document is read from the standard input. It could be either piped or manually typed.

## Debian and binary packages
A packaged version for Debian and Ubuntu is available in the [artifacts folder](https://gitlab.s1.0x39b.fr/lambda/esther-compose/builds/48/artifacts/file/pkg/): 
Or click on following links:

  * [<img src="https://www.debian.org/logos/openlogo-nd-25.png" height="20px"/> `esther-compose_2.2_386.deb`](https://gitlab.s1.0x39b.fr/lambda/esther-compose/builds/48/artifacts/file/pkg/esther-compose_2.2_386.deb) 
    ```bash
    wget https://gitlab.s1.0x39b.fr/lambda/esther-compose/builds/48/artifacts/file/pkg/esther-compose_2.2_386.deb
    sudo dpkg -i esther-compose_2.2_386.deb
    ```
  * [<img src="https://www.debian.org/logos/openlogo-nd-25.png" height="20px"/> `esther-compose_2.2_amd64.deb`](https://gitlab.s1.0x39b.fr/lambda/esther-compose/builds/48/artifacts/file/pkg/esther-compose_2.2_amd64.deb)
    ```bash
    wget https://gitlab.s1.0x39b.fr/lambda/esther-compose/builds/48/artifacts/file/pkg/esther-compose_2.2_amd64.deb
    sudo dpkg -i esther-compose_2.2_amd64.deb
    ```
    
These packages are not compliant with Debian package policy. For more information, run `lintian` on `.deb`.

### Manual
A `man` page is available, simply type:
```bash
man esther-compose
```


## Binary distribution
A compiled version is available in the [artifacts folder](https://gitlab.s1.0x39b.fr/lambda/esther-compose/builds/48/artifacts/file/pkg/):

  * `darwin 386`
  * `darwin amd64`
  * `linux 386`
  * `linux amd64`

## Example with Mustache template
**data.json**
```json
{
  "subdomain": [
    { "name": "resque" },
    { "name": "hub" },
    { "name": "rip" }
  ]
}

```
**tpl.txt**
```
{{#subdomain}}
  * {{name}}.hostname.org
{{/subdomain}}
```

**Execution**
```bash
cat data.json | ./pkg/esther-compose_linux_amd64 -t tpl.txt -o out.txt
```

**out.txt**
```
  * resque.hostname.org
  * hub.hostname.org
  * rip.hostname.org
```

## Versions 
### v2.2
  * Packaging for Debian 
   
Download [binary or `.deb`](https://gitlab.s1.0x39b.fr/lambda/esther-compose/builds/48/artifacts/browse/pkg/) distribution. 

### v2.1
  * Fix wrong output format due to nasty debug trace
   
Download [binary](https://gitlab.s1.0x39b.fr/lambda/esther-compose/builds/45/artifacts/browse/pkg/) distribution. 

### v2.0
  * Support **Go template** and **Mustache template** format
  * Rename option `-template` by `-t`
  * Rename option `-output` by `-o`
   
Download [binary](https://gitlab.s1.0x39b.fr/lambda/esther-compose/builds/29/artifacts/browse/pkg/) distribution. 

### v1.0
  * Support **Mustache** templates
  * Read input data from pipe or `stdin`
   
Download [binary](https://gitlab.s1.0x39b.fr/lambda/esther-compose/builds/27/artifacts/browse/pkg/) distribution. 