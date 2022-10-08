#!/bin/sh
#this script will be called by crontab periodically for checking internet connection
#incase of break in the internet, restart usb-modem and restart the app
APP_NAME=aws-iot-pubsub-agent
APP_SCRIPT=/etc/WrtPubSubDemo.sh
TIME=$(date)
if ! ping -q -c 1 -W 10 8.8.8.8 > /dev/null; then
	kill $(pidof $APP_NAME)
	ifdown wan2 wan3 wan6 wan
	/usr/sbin/usb-port-power.sh off
	sleep 5
	/usr/sbin/usb-port-power.sh on
	sleep 20 #let the 3g/4g modem boot
	ifup wan2 wan3 wan6 wan
	sleep 5 #let the wan interface come back
	if ping -q -c 1 -W 10 8.8.8.8 > /dev/null; then
		$APP_SCRIPT #/etc/init.d/WrtXmproxyStartupScr start
	else
		sleep 10
		if ping -q -c 1 -W 10 8.8.8.8 > /dev/null; then
			$APP_SCRIPT #/etc/init.d/WrtXmproxyStartupScr start
		fi
	fi
	echo "check-wan:$TIME: wan reset done due to no-internet" >> /tmp/checkwan.log
fi
#echo "checking wan at: $TIME" >> /tmp/checkwan.log
