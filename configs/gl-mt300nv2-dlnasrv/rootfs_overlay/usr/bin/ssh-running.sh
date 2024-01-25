#!/bin/sh
RES=$(ps |grep "[s]sh -p 55611")
if [ $? = 0 ]; then
	exit 0
else
	exit 1
fi
