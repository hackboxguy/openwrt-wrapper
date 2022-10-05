## Remote-Kit: Xmpp based remote access device for GL-MT300NV2 openwrt router

This is a openwrt config for generating Linux image for GM-MT300NV2 pocket router. Purpose of this Linux image is to provide remote accessibility to on-prem networked devices. Jabber client daemon(written in c/c++ using gloox library) acts as a chat bot and provides a set of commands which can be triggered from a remote-users's instant messaging app like xabber on android.

## Maintainer
	Albert David (albert.david@gmail.com)

## Build steps for creating openwrt Remote-Kit Linux image for GL-MT300NV2 HW
1. ```git clone https://github.com/hackboxguy/openwrt-wrapper.git```
2. ```cd openwrt-wrapper``` cd to cloned openwrt-wrapper directory
3. ```ln -s ~/openwrt-dl openwrt-dl``` Preserve download directory - this will help in reducing the total build time
4. ```ln -s ~/openwrt-packages openwrt-packages``` Preserve packages directory
5. ```./build-openwrt-image.sh -v 00.01 -b gl-mt300nv2-remote-kit``` Invoke top level wrapper script to build the image(this takes a while)
6. ```ls openwrt/bin/targets/ramips/mt76x8/openwrt-ramips-mt76x8-glinet_gl-mt300n-v2-squashfs-sysupgrade.bin``` Location of output image
