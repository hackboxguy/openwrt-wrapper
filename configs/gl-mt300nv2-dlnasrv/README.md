## dlna-server: Turn your GL-MT300NV2 pocket router as a DLNA-Server

This is a openwrt config for generating Linux image for GL-MT300NV2 pocket router. Purpose of this Linux image is to have a ready to use(pre-configured) DLNA-Server feature with minimal changes.

## Maintainer
	Albert David (albert.david@gmail.com)

## Build steps for creating openwrt dlna-server Linux image for GL-MT300NV2 HW
1. ```git clone --recursive https://github.com/hackboxguy/openwrt-wrapper.git```
2. ```cd openwrt-wrapper``` cd to cloned openwrt-wrapper directory
3. ```ln -s ~/openwrt-dl openwrt-dl``` Preserve download directory - this will help in reducing the total build time
4. ```./build-openwrt-image.sh -v 00.01 -b gl-mt300nv2-dlnasrv``` Invoke top level wrapper script to build the image(this takes a while)
5. ```ls openwrt/bin/targets/ramips/mt76x8/openwrt-ramips-mt76x8-glinet_gl-mt300n-v2-squashfs-sysupgrade.bin``` Location of output image
