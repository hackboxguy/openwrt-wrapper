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
ln -s ../../../../packages/aws-iot-device-sdk-cpp-v2 feeds/packages/libs/aws-iot-device-sdk-cpp-v2
cat ../packages/aws-iot-device-sdk-cpp-v2/pkg.index >> feeds/packages.index

#aws-iot-pubsub-agent
ln -s ../../../../packages/aws-iot-pubsub-agent feeds/packages/utils/aws-iot-pubsub-agent
cat ../packages/aws-iot-pubsub-agent/pkg.index >> feeds/packages.index

#usb-tempered
ln -s ../../../../packages/usb-tempered feeds/packages/utils/usb-tempered
cat ../packages/usb-tempered/pkg.index >> feeds/packages.index

#brbox-minimal
ln -s ../../../../packages/brbox-minimal feeds/packages/utils/brbox-minimal
cat ../packages/brbox-minimal/pkg.index >> feeds/packages.index

#awsiot-openwrt-extensions
ln -s ../../../../packages/awsiot-openwrt-extensions feeds/packages/utils/awsiot-openwrt-extensions
cat ../packages/awsiot-openwrt-extensions/pkg.index >> feeds/packages.index

#sd-mux-ctrl
ln -s ../../../../packages/sd-mux-ctrl feeds/packages/utils/sd-mux-ctrl
cat ../packages/sd-mux-ctrl/pkg.index >> feeds/packages.index
