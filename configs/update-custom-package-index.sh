#!/bin/sh
#create soft links of custom packages which are not part of openwrt in openwrt/feeds
#sshpass
ln -s ../../../../packages/sshpass feeds/packages/utils/sshpass
cat ../packages/sshpass/pkg.index >> feeds/packages.index

#gloox
ln -s ../../../../packages/gloox feeds/packages/libs/gloox
cat ../packages/gloox/pkg.index >> feeds/packages.index

#brbox
ln -s ../../../../packages/brbox feeds/packages/utils/brbox
cat ../packages/brbox/pkg.index >> feeds/packages.index

#openwrt-base-scripts
ln -s ../../../../packages/openwrt-base-scripts feeds/packages/utils/openwrt-base-scripts
cat ../packages/openwrt-base-scripts/pkg.index >> feeds/packages.index

#aws-iot-device-sdk-cpp-v2
ln -s ../../../../packages/aws-iot-device-sdk-cpp-v2 feeds/packages/libs/ows-iot-device-sdk-cpp-v2
cat ../packages/aws-iot-device-sdk-cpp-v2/pkg.index >> feeds/packages.index
