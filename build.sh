mkdir ./pkg

export GOOS=darwin
export GOARCH=386
go build src/esther-compose.go
cp esther-compose pkg/esther-compose_${GOOS}_${GOARCH}

export GOOS=darwin
export GOARCH=amd64
go build src/esther-compose.go
cp esther-compose pkg/esther-compose_${GOOS}_${GOARCH}

export GOOS=linux
export GOARCH=386
go build src/esther-compose.go
cp esther-compose pkg/esther-compose_${GOOS}_${GOARCH}

export GOOS=linux
export GOARCH=amd64
go build src/esther-compose.go
cp esther-compose pkg/esther-compose_${GOOS}_${GOARCH}