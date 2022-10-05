#!/bin/sh
#this scripts lists down active network interfaces and their ipv4 address

IFDATA=$(ifconfig)
LOOPCOUNT=$(ifconfig|grep "inet "|awk '{print $1,$2}' | wc -l)
echo ""
x=1
while [ $x -le $LOOPCOUNT ]; do
	IPADDR=$(ifconfig|grep "inet "|awk '{print $1,$2}'|head -n $x | tail -n 1)
	IFACE=$(ifconfig|grep -B1 "$IPADDR" | head -n 1 | awk '{print $1}')
	echo "$IFACE $IPADDR"
	x=$(($x+1))
done
