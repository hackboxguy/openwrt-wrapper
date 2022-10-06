#!/bin/sh
XMPROXYCLT=/opt/fmw/bin/xmproxyclt
TIME=$(date)
if ! ping -q -c 1 -W 10 8.8.8.8 > /dev/null; then
	killall -9 xmproxysrv
	#$XMPROXYCLT --connectsts=offline
	#/etc/init.d/WrtXmproxyStartupScr stop
	ifdown wan2 wan3 wan6 wan
	/usr/sbin/usb-port-power.sh off
	sleep 5
	/usr/sbin/usb-port-power.sh on
	sleep 20 #let the 3g/4g modem boot
	ifup wan2 wan3 wan6 wan
	sleep 5 #let the wan interface come back
	if ping -q -c 1 -W 10 8.8.8.8 > /dev/null; then
		/etc/init.d/WrtXmproxyStartupScr start
	else
		sleep 10
		if ping -q -c 1 -W 10 8.8.8.8 > /dev/null; then
			/etc/init.d/WrtXmproxyStartupScr start
		fi
	fi
	echo "check-wan:$TIME: wan reset done due to no-internet" >> /tmp/checkwan.log
else
	RES=$($XMPROXYCLT --connectsts | awk '{print $9}')
	if [ $RES = "result=offline" ]; then
		/etc/init.d/WrtXmproxyStartupScr stop
		ifdown wan2 wan3 wan6 wan
		/usr/sbin/usb-port-power.sh off
		sleep 5
		/usr/sbin/usb-port-power.sh on
		sleep 20 #let the 3g/4g modem boot
		ifup wan2 wan3 wan6 wan
		sleep 5 #let the wan interface come back
		if ping -q -c 1 -W 10 8.8.8.8 > /dev/null; then
			/etc/init.d/WrtXmproxyStartupScr start
		fi
		echo "check-wan:$TIME: wan reset done due to xmproxy-offline" >> /tmp/checkwan.log
	elif [ $RES = "result=online" ]; then
		MSG=$(echo "device-online")
	else
		killall -9 xmproxysrv
		/etc/init.d/WrtXmproxyStartupScr stop
		echo "check-wan:$TIME: looks like xmproxy is not running, restarting again.." >> /tmp/checkwan.log
	fi
fi
#echo "checking wan at: $TIME" >> /tmp/checkwan.log
