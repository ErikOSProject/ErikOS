#!/bin/sh

if [ -z "$ARCH" ]; then
    ARCH=x86_64
fi

if [ -z "$TARGET" ]; then
    TARGET=erikos.img
fi

if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR=build/$ARCH
fi

SOURCE_DIR=$(realpath -e -- $(dirname -- "$0"))

git submodule update --init --recursive

mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake "$SOURCE_DIR" -DTARGET_ARCH=$ARCH
make -j$(nproc) all install
cd $SOURCE_DIR

sudo $SOURCE_DIR/efi_cpy.sh
