#!/bin/sh
USAGE="$0 <ssh_server_ip> <optional_rev_tunnel_port> <optional_ssh_server_port>"
if [ $# -eq 0 ]; then
	echo "No arguments supplied!!!"
	echo $USAGE
	exit 1
fi

if [ -f "$1" ]; then #check if ipaddr is in a file
	REMOTEIP=$(cat $1)
else
	REMOTEIP=$1
fi

if [ -z "$2" ]; then
	REMOTEPORT=4202
else
	if [ -f "$2" ]; then #check if remote-port is in a file
		REMOTEPORT=$(cat $2)
	else
		REMOTEPORT=$2
	fi
fi

if [ -z "$3" ]; then
	SERVERPORT=55611
else
	if [ -f "$3" ]; then #check if server-port is in a file
		SERVERPORT=$(cat $3)
	else
		SERVERPORT=$3
	fi
fi

while true
do
	ssh -p $SERVERPORT -y -i /root/.ssh/id_rsa -N -g -R $REMOTEPORT:localhost:22 admin@$REMOTEIP 1>/tmp/remote-ssh.log 2>/tmp/remote-ssh.log
	#echo "ip=$REMOTEIP : remote-port=$REMOTEPORT : server-port=$SERVERPORT"
	sleep 15
done
