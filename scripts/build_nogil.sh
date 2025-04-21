#!/usr/bin/env bash
set -e
echo "Building CPython 3.13 no‑GIL..."
git clone --depth 1 https://github.com/colesbury/nogil-cpython.git
cd nogil-cpython
./configure --disable-shared --enable-free-threaded
make -j$(nproc)
echo "Done. Set PYTHON_LIBRARY=$(pwd)/libpython3.13.a (or .so) and rebuild Swift."
