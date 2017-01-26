#!/usr/bin/env bash
mkdir -p ./pkg

export GOPATH=$PWD

ROOT_DIR=$PWD
SRC_DIR=./src/esther-compose
PKG_NAME=esther-compose
PKG_DIR=${ROOT_DIR}/pkg

sum() {
    sha512sum -b $1 > $1.sha512sum
}

install_dep() {
   export GOPATH=$PWD
   cd $SRC_DIR
   if ! glide i; then
      echo "  Unable to install dependencies" >&2
      exit 1
   fi
   cd ${ROOT_DIR}
}

build_arch() {
   export GOOS=$1
   export GOARCH=$2
   echo "  Building sources for $1_$2"
   cd $SRC_DIR
   if ! go build; then
      echo "  Unable to build the project" >&2
      exit 1
   fi
   if ! cp ./${PKG_NAME} ${PKG_DIR}/${PKG_NAME}_${GOOS}_${GOARCH}; then
      printf "  Unable to move the binary %s to %s from %s\n" "./${PKG_NAME}" "${PKG_DIR}/${PKG_NAME}_${GOOS}_${GOARCH}" "$PWD">&2
      exit 1
   fi
   cd ${PKG_DIR}
   if ! sum ${PKG_NAME}_${GOOS}_${GOARCH}; then
      echo "  Unable to compute the SHA sum" >&2
      exit 1
   fi
   cd ${ROOT_DIR}
}

build_arm() {
   export GOARM=$1
   export GOARCH=arm
   echo "  Building sources for ARM v$1"
   cd $SRC_DIR
   if ! go build; then
      echo "  Unable to build the project" >&2
      exit 1
   fi
   if ! cp ./${PKG_NAME} ${PKG_DIR}/${PKG_NAME}_${GOARCH}_${GOARM}; then
      printf "  Unable to move the binary %s to %s from %s\n" "./${PKG_NAME}" "${PKG_DIR}/${PKG_NAME}_${GOARCH}_${GOARM}" "$PWD">&2
      exit 1
   fi
   cd ${PKG_DIR}
   if ! sum ${PKG_NAME}_${GOARCH}_${GOARM}; then
      echo "  Unable to compute the SHA sum" >&2
      exit 1
   fi
   cd ${ROOT_DIR}
}

install_dep

build_arch darwin 386
build_arch darwin amd64
build_arch linux 386
build_arch linux amd64
build_arm 5
build_arm 6
build_arm 7
