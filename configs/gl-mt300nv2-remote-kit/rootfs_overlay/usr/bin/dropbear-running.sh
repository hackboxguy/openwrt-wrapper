#!/bin/sh
RES=$(netstat -tan |grep 0.0.0.0:22)
if [ $? = 0 ]; then
	exit 0
else
	exit 1
fi
