#!/usr/bin/env bash
mkdir -p ./pkg

sum() {
    sha512sum -b $1 > $1.sha512sum
}
export GOARM=7
export GOARCH=arm
echo "Building binary for $GOARCH $GOARM"
go build src/esther-compose.go
cp esther-compose pkg/esther-compose_${GOOS}_${GOARCH}
sum pkg/esther-compose_${GOOS}_${GOARCH}

export GOOS=darwin
export GOARCH=386
echo "Building binary for $GOOS $GOARCH"
go build src/esther-compose.go
cp esther-compose pkg/esther-compose_${GOOS}_${GOARCH}
sum pkg/esther-compose_${GOOS}_${GOARCH}

export GOOS=darwin
export GOARCH=amd64
echo "Building binary for $GOOS $GOARCH"
go build src/esther-compose.go
cp esther-compose pkg/esther-compose_${GOOS}_${GOARCH}
sum pkg/esther-compose_${GOOS}_${GOARCH}

export GOOS=linux
export GOARCH=386
echo "Building binary for $GOOS $GOARCH"
go build src/esther-compose.go
cp esther-compose pkg/esther-compose_${GOOS}_${GOARCH}
sum pkg/esther-compose_${GOOS}_${GOARCH}

export GOOS=linux
export GOARCH=amd64
echo "Building binary for $GOOS $GOARCH"
go build src/esther-compose.go
cp esther-compose pkg/esther-compose_${GOOS}_${GOARCH}
sum pkg/esther-compose_${GOOS}_${GOARCH}
