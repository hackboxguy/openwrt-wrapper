#!/bin/sh
LOOPCOUNT=1
SLEEP=1
USAGE="$0 <eth-interface-name> <loop-count-to-read> <sleep-between-reads>"
[ -z $1 ] && echo $USAGE && return 1
[ ! -z $2 ] && LOOPCOUNT=$2
[ ! -z $3 ] && SLEEP=$3

#echo "" #output of shellcmdresp will print the list from 2nd line onwards

x=1
while [ $x -le $LOOPCOUNT ]; do
	RXBYTES=$(cat /sys/class/net/$1/statistics/rx_bytes)
	TXBYTES=$(cat /sys/class/net/$1/statistics/tx_bytes)

	if [ $RXBYTES -le 1023 ]; then
		RXDATA="$RXBYTES Bytes"
	else
		RXBYTES=$(($RXBYTES/1024))
		RXDATA="$RXBYTES KB"
	fi

	if [ $TXBYTES -le 1023 ]; then
		TXDATA="$TXBYTES Bytes"
	else
		TXBYTES=$(($TXBYTES/1024))
		TXDATA="$TXBYTES KB"
	fi
	echo "Rx-$RXDATA : Tx-$TXDATA"

	[ $LOOPCOUNT -gt 1 ] && sleep $SLEEP
	x=$(($x+1))
done
