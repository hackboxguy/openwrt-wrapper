## AWS-IoT-Demo: aws-iot-device-sdk-cpp-v2 based pub-sub demo on openwrt pocket router - GL-MT300NV2

This is a openwrt config for generating Linux image for GL-MT300NV2 pocket router. Purpose of this Linux image is to show a pub-sub demo using aws-iot-device-sdk-cpp-v2 library, just update your pocket router, install private-key and device-certificate and after reboot, Hell-World test message would start publishing to AWS cloud

## Maintainer
	Albert David (albert.david@gmail.com)

## Build steps for creating openwrt AWS-IoT-Demo Linux image for GL-MT300NV2 HW
1. ```git clone https://github.com/hackboxguy/openwrt-wrapper.git```
2. ```cd openwrt-wrapper``` cd to cloned openwrt-wrapper directory
3. ```ln -s ~/openwrt-dl openwrt-dl``` Preserve download directory - this will help in reducing the total build time
4. ```./build-openwrt-image.sh -v 00.01 -b gl-mt300nv2-awsiot-demo -o v22.03.3``` Invoke top level wrapper script to build the image based on openwrt version 22.03.3(this takes a while)
5. ```ls openwrt/bin/targets/ramips/mt76x8/openwrt-ramips-mt76x8-glinet_gl-mt300n-v2-squashfs-sysupgrade.bin``` Location of output image
