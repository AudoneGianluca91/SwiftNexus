#!/usr/bin/env bash
set -e
echo "Building PyPI wheel for Swift dylib..."
swift build -c release
lib=$(find .build -name '*.dylib' -or -name '*.so' | head -1)
mkdir -p pywrap_wheel/pywrap
cp "$lib" pywrap_wheel/pywrap/
cp setup.py pywrap_wheel/
(cd pywrap_wheel && python3 -m build)
echo "Wheel created in pywrap_wheel/dist"
