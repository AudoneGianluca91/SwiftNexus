#!/usr/bin/env bash
set -e
echo "Building CRAN binary for RWrap..."
SWIFT_LIB=$(swift build -c release -show-bin-path)/libPyWrapRuntime.dylib
mkdir -p rwrap/src
cp "$SWIFT_LIB" rwrap/libs/
cat > rwrap/DESCRIPTION <<EOF
Package: rwrap
Type: Package
Title: Swift-powered extensions
Version: 0.1.0
Author: You
Maintainer: You <you@example.com>
Description: R interface to Swift-compiled algorithms via RWrapRuntime.
License: MIT
Encoding: UTF-8
LazyData: true
NeedsCompilation: yes
EOF
cat > rwrap/NAMESPACE <<EOF
useDynLib(rwrap, .registration=TRUE)
EOF
R CMD build rwrap
echo "CRAN tarball dumped in current directory."
