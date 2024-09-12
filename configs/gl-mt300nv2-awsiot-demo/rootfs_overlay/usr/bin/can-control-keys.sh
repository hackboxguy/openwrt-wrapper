#!/bin/sh
case $1 in
   KEY_0)
	VAL=$(echo -n "speed" | nc 127.0.0.1 8080)
	VAL=$(($VAL+1))
	echo -n "speed $VAL" | nc 127.0.0.1 8080
	;;
   KEY_1)
	VAL=$(echo -n "speed" | nc 127.0.0.1 8080)
	VAL=$(($VAL-1))
	echo -n "speed $VAL" | nc 127.0.0.1 8080
	;;
   KEY_2)
	VAL=$(echo -n "rpm" | nc 127.0.0.1 8080)
	VAL=$(($VAL+1))
	echo -n "rpm $VAL" | nc 127.0.0.1 8080
      ;;
   KEY_3)
	VAL=$(echo -n "rpm" | nc 127.0.0.1 8080)
	VAL=$(($VAL-1))
	echo -n "rpm $VAL" | nc 127.0.0.1 8080
      ;;
   KEY_4)
	VAL=$(echo -n "flow" | nc 127.0.0.1 8080)
	VAL=$(($VAL+1))
	echo -n "flow $VAL" | nc 127.0.0.1 8080
      ;;
   KEY_5)
	VAL=$(echo -n "flow" | nc 127.0.0.1 8080)
	VAL=$(($VAL-1))
	echo -n "flow $VAL" | nc 127.0.0.1 8080
      ;;
   KEY_6)
	VAL=$(echo -n "temp" | nc 127.0.0.1 8080)
	VAL=$(($VAL+1))
	echo -n "temp $VAL" | nc 127.0.0.1 8080
      ;;
   KEY_7)
	VAL=$(echo -n "temp" | nc 127.0.0.1 8080)
	VAL=$(($VAL-1))
	echo -n "temp $VAL" | nc 127.0.0.1 8080
      ;;
   KEY_8)
        VAL=$(echo -n "load" | nc 127.0.0.1 8080)
        VAL=$(($VAL+1))
        [ $VAL -ge 255 ] && VAL=255
	echo -n "load $VAL" | nc 127.0.0.1 8080
      ;;
   KEY_9)
        VAL=$(echo -n "load" | nc 127.0.0.1 8080)
        VAL=$(($VAL-1))
        [ $VAL -le 0 ] && VAL=0
        echo -n "load $VAL" | nc 127.0.0.1 8080
      ;;
   KEY_PLUS)
        VAL=$(echo -n "intake" | nc 127.0.0.1 8080)
        VAL=$(($VAL+1))
        [ $VAL -ge 255 ] && VAL=255
        echo -n "intake $VAL" | nc 127.0.0.1 8080
      ;;
   KEY_MINUS)
        VAL=$(echo -n "intake" | nc 127.0.0.1 8080)
        VAL=$(($VAL-1))
        [ $VAL -le 0 ] && VAL=0
        echo -n "intake $VAL" | nc 127.0.0.1 8080
      ;;
   *)
     echo "invalid arg"
     ;;
esac

