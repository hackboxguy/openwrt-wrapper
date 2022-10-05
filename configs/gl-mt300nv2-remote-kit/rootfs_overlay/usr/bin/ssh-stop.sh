#!/bin/sh
while true
do
	RES=$(ps | grep "[s]sh-start.sh")
	if [ $? = 0 ]; then
		MYPID=$(echo $RES | awk '{print $1}')
		kill $MYPID
	fi
        RES=$(ps | grep "[s]sh -p 55611")
        if [ $? = 0 ]; then
		MYPID=$(echo $RES | awk '{print $1}')
		kill $MYPID
        else
		break
        fi
done
