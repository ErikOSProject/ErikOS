#!/bin/bash

ldev=$(losetup --partscan --show -f ./erikos.img)
mkdir -p ./oshd
mount ${ldev}p1 ./oshd
mkdir -p ./oshd/EFI/BOOT
tar cvf ./ErikOSInitrd.tar -C ./build/x86_64/init init
cp ./build/x86_64/boot/ErikBoot.efi ./oshd/EFI/BOOT/BOOTX64.EFI
cp ./build/x86_64/kernel/KERNEL.ERIK ./oshd/KERNEL.ERIK
cp ./ErikOSInitrd.tar ./oshd/INITRD.TAR
umount ./oshd
losetup -d ${ldev}
