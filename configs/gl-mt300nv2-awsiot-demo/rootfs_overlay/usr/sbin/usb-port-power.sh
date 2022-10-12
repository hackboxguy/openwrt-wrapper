#!/bin/sh

USB_NODE1=/sys/class/gpio/usb/value
USB_NODE2=/sys/class/gpio/usb-phy/value
USB_NODE="none"
[ -f  "$USB_NODE1" ] && USB_NODE=$USB_NODE1
[ -f  "$USB_NODE2" ] && USB_NODE=$USB_NODE2
[ "$USB_NODE" = "none" ] && echo "usb node not found!!!!" && return 1

#read action
if [ -z $1 ]; then
	VAL=$(cat $USB_NODE)
	[ $VAL = "0" ] && echo "off" && return 0
	[ $VAL = "1" ] && echo "on" && return 0
	echo "usb-power: unknown value" && return 1
fi

if [ -f $1 ]; then
	#check if argument $1 is a json file
	JQOBJ=$(jq type < $1)
	if [ $? = "0" ]; then #this is a valid json file
		MYARG=$(jq -r .powerstate $1)
	else
		MYARG=$1 #just take argument as on/off string
	fi
else
	MYARG=$1
fi

#write action
if [ $MYARG = "on" ]; then
	echo 1 > $USB_NODE
	return 0
elif [ $MYARG = "off" ]; then
	echo 0 > $USB_NODE
	return 0
else
	echo "usb-power: valid arguments are on/off"
	return 1
fi
