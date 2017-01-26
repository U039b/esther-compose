#! /bin/bash

ROOT_DIR=$PWD
LD_FLAGS="-s -w"
SRC_DIR=./src/esther-compose
PKG_NAME=esther-compose
PKG_DIR=$SRC_DIR

MAN_DIR=./debian_tpl/man
MAN_DEB_DIR=./debian/usr/share/man/man1
BIN_DEB_DIR=./debian/usr/bin

clean() {
    rm -rf ./$PKG_NAME*.deb ./debian ./pkg
}

install_dep() {
   export GOPATH=$PWD
   cd $SRC_DIR
   if ! glide i; then
      echo "  Unable to install dependencies" >&2
      cd ${ROOT_DIR}
      exit 1
   fi
   cd ${ROOT_DIR}
}

build_arch() {
   export GOOS=$1
   export GOARCH=$2
   echo "  Building sources for $1_$2"
   if ! go build -ldflags="$LD_FLAGS"; then
      echo "  Unable to build the project" >&2
      exit 1
   fi
   if [ $2 = "xamd64" ]; then
      echo "  Strip executable"
      if ! upx -q9 ./$PKG_NAME; then
         echo "  Unable to strip the binary" >&2
         exit 1
      fi
   fi
   cd $ROOT_DIR
}

sum() {
    sha512sum -b $1 > $1.sha512sum
}

build_arm() {
   export GOARM=$2
   export GOARCH=arm
   echo "  Building sources for ARM v$GOARM"
   if ! go build -ldflags="$LD_FLAGS"; then
      echo "  Unable to build the project" >&2
      exit 1
   fi
   cd ${ROOT_DIR}
}

build_deb() {
    PLAT=$1
    ARCH=$2
    VERSION=$3
    ARM_V=$4
    echo "*******************************************************"
    echo "*******************************************************"
    echo "Start building $PKG_NAME $3 for $1_$2 Debian package"
    cd $SRC_DIR
    # Build go source
    if [ $PLAT = "arm" ]; then
        build_arm $PLAT $ARM_V
    else
        build_arch $PLAT $ARCH
    fi
    mkdir -p $BIN_DEB_DIR 
    if ! mv ${PKG_DIR}/${PKG_NAME} $BIN_DEB_DIR; then
       echo "  Unable to copy the binary to debian location" >&2
       exit 1
    fi
    chmod 755 $BIN_DEB_DIR/$PKG_NAME
    # Copy man pages
    echo "  Man pages"
    mkdir -p $MAN_DEB_DIR 
    if ! cp -r $MAN_DIR/man.1 $MAN_DEB_DIR/$PKG_NAME.1; then
       echo "  Unable to copy the man pages" >&2
       exit 1
    fi
    if ! gzip -f --best $MAN_DEB_DIR/$PKG_NAME.1; then
       echo "  Unable to compress man " >&2
       exit 1
    fi
    chmod 0644 $MAN_DEB_DIR/*
    # Generate control file
    echo "  Control file"
    mkdir -p ./debian/DEBIAN/
    if ! cp ./debian_tpl/control ./debian/DEBIAN/control; then
       echo "  Unable to copy the control file" >&2
       exit 1
    fi
    sed -i "s/#ARCH/$ARCH/g" ./debian/DEBIAN/control
    sed -i "s/#VERSION/$VERSION/g" ./debian/DEBIAN/control
    # Build debian package
    echo "  Building Debian package"
    find ./debian -type d | xargs chmod 755
    mkdir -p ./pkg
    if ! dpkg-deb --build debian; then
       echo "  Unable to build the Debian package" >&2
       exit 1
    fi
    PKG_FILENAME=${PKG_NAME}_${VERSION}_${PLAT}_${ARCH}.deb
    if [ $PLAT = "arm" ]; then
        PKG_FILENAME=${PKG_NAME}_${VERSION}_${ARCH}_${ARM_V}.deb
    fi
    mv debian.deb ./pkg/${PKG_FILENAME}
    # Compute sum
    echo "  Computing SHA sum"
    cd ./pkg/
    if ! sum ${PKG_FILENAME}; then
        echo "  Unable to compute the SHA sum" >&2
        exit 1
    fi
    cd ..
}

clean
install_dep
build_deb "linux" "amd64" $1
build_deb "linux" "386" $1
build_deb "arm" "armhf" $1 "5"
build_deb "arm" "armhf" $1 "6"
build_deb "arm" "armhf" $1 "7"
exit 0
