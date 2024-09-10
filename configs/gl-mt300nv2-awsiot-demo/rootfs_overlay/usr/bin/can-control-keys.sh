#!/bin/sh
case $1 in
   #KEY_PAGEUP)
   KEY_0)
	VAL=$(echo -n "speed" | nc 127.0.0.1 8080)
	VAL=$(($VAL+1))
	echo -n "speed $VAL" | nc 127.0.0.1 8080
	;;
   #KEY_PAGEDOWN)
   KEY_1)
	VAL=$(echo -n "speed" | nc 127.0.0.1 8080)
	VAL=$(($VAL-1))
	echo -n "speed $VAL" | nc 127.0.0.1 8080
	;;
   #KEY_UP)
   KEY_2)
	VAL=$(echo -n "rpm" | nc 127.0.0.1 8080)
	VAL=$(($VAL+1))
	echo -n "rpm $VAL" | nc 127.0.0.1 8080
      ;;
   #KEY_DOWN)
   KEY_3)
	VAL=$(echo -n "rpm" | nc 127.0.0.1 8080)
	VAL=$(($VAL-1))
	echo -n "rpm $VAL" | nc 127.0.0.1 8080
      ;;
   #KEY_VOLUMEUP)
   KEY_4)
	VAL=$(echo -n "flow" | nc 127.0.0.1 8080)
	VAL=$(($VAL+1))
	echo -n "flow $VAL" | nc 127.0.0.1 8080
      ;;
   #KEY_VOLUMEDOWN)
   KEY_5)
	VAL=$(echo -n "flow" | nc 127.0.0.1 8080)
	VAL=$(($VAL-1))
	echo -n "flow $VAL" | nc 127.0.0.1 8080
      ;;
   *)
     echo "invalid arg"
     ;;
esac
