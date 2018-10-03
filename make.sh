#!/bin/bash
mkdir mnt_system mnt_vendor
unzip update.zip
brotli --decompress system.new.dat.br --output=system.new.dat
brotli --decompress vendor.new.dat.br --output=vendor.new.dat
./sdat2img.py system.transfer.list system.new.dat system.raw.img
./sdat2img.py vendor.transfer.list vendor.new.dat vendor.raw.img
sudo mount -o rw,loop system.raw.img ./mnt_system
sudo mount -o rw,loop vendor.raw.img ./mnt_vendor
abootimg -x boot.img
abootimg-unpack-initrd
sudo dd if=mapping/26.0.cil of=./mnt_system/etc/selinux/mapping/26.0.cil
sudo dd if=mapping/27.0.cil of=./mnt_system/etc/selinux/mapping/27.0.cil
read -p "如有需要请到mnt_system下修改system，按enter继续打包"
sudo umount ./mnt_system
e2fsck -f system.raw.img
resize2fs -M -p system.raw.img
img2simg system.raw.img sGSI_System.img
echo 完成，输出文件sGSI_System.img
