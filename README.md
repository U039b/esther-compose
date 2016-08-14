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
**Esther-compose** is a command line tool which wraps [Mustache templating engine](https://mustache.github.io/). **Esther-compose** allows you to 
render any kind of template. As personal usage, I use it for `docker-compose` file generation from JSON definition.

So **Esther-compose** uses a JSON document to render the given template.

## Command line

  * `-template` path to the template 
  * `-output` path to the rendered file
  
The JSON document is read from the standard input. It could be either piped or manually typed.

## Example
**data.json**
```
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
```
cat data.json | ./pkg/esther-compose_linux_amd64 -template tpl.txt -output out.txt
```

**out.txt**
```
  * resque.hostname.org
  * hub.hostname.org
  * rip.hostname.org
```