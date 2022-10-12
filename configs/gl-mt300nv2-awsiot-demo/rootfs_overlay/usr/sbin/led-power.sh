#!/bin/sh
LED_NODE=/sys/class/leds/green:power/brightness

if [ ! -f  "$LED_NODE" ]; then
	echo "led node not found!!!!"
	return 1
fi

#read action
if [ -z $1 ]; then
	VAL=$(cat $LED_NODE)
	if [ $VAL = "0" ]; then
	       echo "off"
	       return 0
       else
	       echo "on"
	       return 0
	fi
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
	echo 1 > $LED_NODE
	return 0
elif [ $MYARG = "off" ]; then
	echo 0 > $LED_NODE
	return 0
else
	echo "led-control: valid arguments are on/off"
	return 1
fi
