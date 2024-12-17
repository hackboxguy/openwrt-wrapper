#!/bin/sh
cp configs/raspi4-remote-kit/patches/can.mk openwrt/package/kernel/linux/modules/
cp configs/raspi4-remote-kit/rootfs_overlay/boot/config.txt openwrt/target/linux/bcm27xx/image/
cp configs/raspi4-remote-kit/rootfs_overlay/boot/cmdline.txt openwrt/target/linux/bcm27xx/image/
