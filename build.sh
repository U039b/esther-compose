#! /bin/bash

VERSION=`git describe --abbrev=0 --tags`

# Build debian packages
sh build_deb.sh $VERSION

# Build binaries
sh build_bin.sh

# Generate changelog
previous_tag=`git tag | sort -t '-' -k 1 -V | tail -n1`
echo "Esther-compose $VERSION changelog" > ./pkg/CHANGELOG
git log --pretty=oneline HEAD...${previous_tag} | cut -d' ' -f2- | grep -v "Merge branch" | awk '{print "  * "$LINE}' >> ./pkg/CHANGELOG

