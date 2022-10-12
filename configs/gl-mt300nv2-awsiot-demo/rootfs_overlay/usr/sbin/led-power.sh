#!/bin/sh
LED_NODE=/sys/class/leds/green:power/brightness

if [ ! -f  "$LED_NODE" ]; then
	echo "led node not found!!!!"
	return 1
fi

if [ -z $1 ]; then
	VAL=$(cat $LED_NODE)
	if [ $VAL = "0" ]; then
	       echo "off"
	       return 0
       else
	       echo "on"
	       return 0
	fi
elif [ $1 = "on" ]; then
	echo 1 > $LED_NODE
	return 0
elif [ $1 = "off" ]; then
	echo 0 > $LED_NODE
	return 0
else
	echo "led-control: valid arguments are on/off"
	return 1
fi
