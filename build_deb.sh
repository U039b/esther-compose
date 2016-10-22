#! /bin/bash

LD_FLAGS="-s -w"
SRC_DIR="./src"
PKG_NAME="esther-compose"

MAN_DIR=./debian_tpl/man
MAN_DEB_DIR=./debian/usr/share/man/man1
BIN_DEB_DIR=./debian/usr/bin

clean() {
    rm -rf ./$PKG_NAME*.deb ./debian ./pkg
}

build_arch() {
   export GOOS=$1
   export GOARCH=$2
   echo "  Building sources for $1_$2"
   go build -ldflags="$LD_FLAGS" $SRC_DIR/$PKG_NAME.go
   echo "  Strip executable"
   upx -q9 ./$PKG_NAME
}

sum() {
    sha512sum -b $1 > $1.sha512sum
}

build_deb() {
    OS=$1
    ARCH=$2
    VERSION=$3
    echo "Start building $PKG_NAME v$3 for $1_$2 platform Debian package"
    # Build go source
    build_arch $1 $2
    mkdir -p $BIN_DEB_DIR 
    mv $PKG_NAME $BIN_DEB_DIR 
    chmod 755 $BIN_DEB_DIR/$PKG_NAME
    # Copy man pages
    echo "  Man pages"
    mkdir -p $MAN_DEB_DIR 
    cp -r $MAN_DIR/man.1 $MAN_DEB_DIR/$PKG_NAME.1 
    gzip -f --best $MAN_DEB_DIR/$PKG_NAME.1
    chmod 0644 $MAN_DEB_DIR/*
    # Generate control file
    echo "  Control file"
    mkdir -p ./debian/DEBIAN/
    cp ./debian_tpl/control ./debian/DEBIAN/control
    sed -i "s/#ARCH/$ARCH/g" ./debian/DEBIAN/control
    sed -i "s/#VERSION/$VERSION/g" ./debian/DEBIAN/control
    # Build debian package
    echo "  Building Debian package"
    find ./debian -type d | xargs chmod 755
    mkdir -p ./pkg
    dpkg-deb --build debian
    mv debian.deb ./pkg/${PKG_NAME}_${VERSION}_${ARCH}.deb
    # Compute sum
    echo "  Computing SHA sum"
    sum ./pkg/${PKG_NAME}_${VERSION}_${ARCH}.deb
}

clean
build_deb "linux" "amd64" $1 
build_deb "linux" "386" $1 
