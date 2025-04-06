#!/bin/sh

echo_blue() {
    echo -e "\033[1;34m$1\033[0m"
}

echo_red() {
    echo -e "\033[1;31m$1\033[0m"
}

if [ -z "$ARCH" ]; then
    ARCH=x86_64
fi

if [ -z "$TARGET" ]; then
    TARGET=erikos.img
fi

if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR=build/$ARCH
fi

echo_blue "Creating $TARGET"
rm -f $TARGET
fallocate -l 1G $TARGET

echo_blue "Setting up loop device for $TARGET"
ldev=$(losetup --partscan --show -f $TARGET)

if [ -z "$ldev" ]; then
    echo_red "Failed to set up loop device"
    exit 1
fi

echo_blue "Creating partition table on $ldev"
sfdisk $ldev <<EOF
label: gpt
unit: sectors

2048,204800,U
,,L
EOF

echo_blue "Creating filesystem on $ldev"
mkfs.vfat -n EFI ${ldev}p1
mkfs.ext4 -L rootfs ${ldev}p2

echo_blue "Mounting $ldev"
mkdir -p ${BUILD_DIR}/oshd
mount ${ldev}p1 ${BUILD_DIR}/oshd

echo_blue "Copying files to $ldev"
mkdir -p ${BUILD_DIR}/oshd/EFI/BOOT
tar cf ${BUILD_DIR}/INITRD.TAR -C ${BUILD_DIR}/sysroot/bin/ init
cp ${BUILD_DIR}/sysroot/bin/ErikBoot.efi ${BUILD_DIR}/oshd/EFI/BOOT/BOOTX64.EFI
cp ${BUILD_DIR}/sysroot/bin/KERNEL.ERIK ${BUILD_DIR}/oshd/KERNEL.ERIK
cp ${BUILD_DIR}/INITRD.TAR ${BUILD_DIR}/oshd/INITRD.TAR

echo_blue "Unmounting $ldev"
umount ${BUILD_DIR}/oshd

echo_blue "Cleaning up"
losetup -d ${ldev}
