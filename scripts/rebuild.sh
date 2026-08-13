#!/bin/bash
set -e

echo "=== TurtleWoW Core Fast Incremental Rebuild ==="
cd /src

mkdir -p build && cd build

echo "[Builder] Running CMake configuration..."
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DUSE_STD_MALLOC=ON \
    -DUSE_ANTICHEAT=ON \
    -DUSE_SCRIPTS=ON \
    -DUSE_EXTRACTORS=OFF \
    -DCMAKE_INSTALL_PREFIX=/app

echo "[Builder] Compiling binaries..."
make -j$(nproc)

echo "[Builder] Installing binaries to /app..."
make install

echo "=== Incremental Rebuild Finished Successfully! ==="
