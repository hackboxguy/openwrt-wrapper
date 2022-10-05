#!/bin/sh
LEASEFILE=/tmp/dhcp.leases
LOOPCOUNT=$(cat $LEASEFILE | wc -l)

echo "" #output of shellcmdresp will print the list from 2nd line onwards

x=1
while [ $x -le $LOOPCOUNT ]; do
	IPADDR=$(head -n $x $LEASEFILE | tail -n 1|awk '{print$3}')
	PRINTVAL=$(head -n $x $LEASEFILE | tail -n 1|awk '{print$3,$4}')
	ping -c 1 -i 0.2 -w 2 $IPADDR >/dev/null
	[ $? = "0" ] && echo $PRINTVAL #IPADDR
	x=$(($x+1))
done
