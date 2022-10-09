#!/bin/sh

APP=aws-iot-pubsub-agent
TIMESYNC_WAIT=10 #wait 10seconds before giving up for timesync check
CONFIG_PATH=/root
#CONFIG_FILE=$CONFIG_PATH/aws-iot-pubsub-agent.conf
CONFIG_FILE=/tmp/aws-iot-pubsub-agent.conf
STARTUP_LOGFILE=/tmp/$APP.startuplog

wait_for_timesync() {
	LOOP_COUNT=$TIMESYNC_WAIT
	x=0
	while [ $x -lt $LOOP_COUNT ]; do
		SYNC_STS=$(cat /var/state/dnsmasqsec)
		if [ "$SYNC_STS" == "ntpd says time is valid" ]; then
			echo "time sync done" >> $STARTUP_LOGFILE
			break
		fi
		x=$(($x+1))
		echo "waiting for time sync" >> $STARTUP_LOGFILE
		sleep 1
	done
}

echo "Starting $APP" > $STARTUP_LOGFILE
/usr/sbin/awsiot-demo-uci-to-conf.sh $CONFIG_FILE 

#certificate and private-key files are must, without them aws-iot-pubsub-demo cannot proceed
if [ -f $CONFIG_PATH/*certificate.pem ]; then
	CERT_FILE=$(ls $CONFIG_PATH/|grep "certificate.pem")
	CERT_FILE_ARG="$CONFIG_PATH/$CERT_FILE"
else
	echo "Missing CERT_FILE!!" >> $STARTUP_LOGFILE
	return 1
fi
if [ -f $CONFIG_PATH/*private.pem.key ]; then
	KEY_FILE=$(ls $CONFIG_PATH/|grep "private.pem.key")
	KEY_FILE_ARG="$CONFIG_PATH/$KEY_FILE"
else
	echo "Missing KEY_FILE!!" >> $STARTUP_LOGFILE
	return 1
fi

#dont ask user for AmazonRootCA file, we already have it in our rootfs
if [ -f /etc/AmazonRootCA1.pem ]; then
	CA_FILE=/etc/AmazonRootCA1.pem
else
	echo "Missing CA_FILE!!" $STARTUP_LOGFILE
	return 1
fi

#check if aws-iot-pubsub-agent.conf exists
if [ ! -f "$CONFIG_FILE" ]; then
	echo "Missing $CONFIG_FILE!!" >> $STARTUP_LOGFILE
	return 1
fi
#endpoint argument must be specified in aws-iot-pubsub-agent.conf else do not start the agent
ENDPOINT=$(cat $CONFIG_FILE | grep endpoint)
if [ $? != 0 ]; then
	echo "Missing endpoint!!" >> $STARTUP_LOGFILE
	return 1
fi
ENDPOINT=$(cat $CONFIG_FILE | grep endpoint | awk '{print $2}')

#check if user has requested a custom log file for agents output
VERBOSE_FILE=$(cat $CONFIG_FILE | grep verbosefile)
if [ $? == 0 ]; then
	VERBOSE_FILE=$(cat $CONFIG_FILE | grep verbosefile | awk '{print $2}')
else
	VERBOSE_FILE="/tmp/aws-iot-pubsub-agent.log" #else use default
fi

#check if user has requested a loglevel [Trace/Debug/Info/Warn/Error/Fatal/None]
VERBOSE_ARGS=""
VERBOSITY=$(cat $CONFIG_FILE | grep verbosity)
if [ $? == 0 ]; then
	VERBOSITY=$(cat $CONFIG_FILE | grep verbosity | awk '{print $2}')
	VERBOSE_ARGS="--verbosity $VERBOSITY"
fi

#check if user has requested total number of messages to publish
COUNT_ARGS=""
COUNT=$(cat $CONFIG_FILE | grep total-publish-count)
if [ $? == 0 ]; then
	COUNT=$(cat $CONFIG_FILE | grep total-publish-count | awk '{print $2}')
	COUNT_ARGS="--count $COUNT"
fi

#check if user has requested for custom topic to publish
TOPIC_ARGS=""
TOPIC=$(cat $CONFIG_FILE | grep publish-topic)
if [ $? == 0 ]; then
	TOPIC=$(cat $CONFIG_FILE | grep publish-topic | awk '{print $2}')
	TOPIC_ARGS="--topic $TOPIC"
fi

#check if clientid is specified, if available, then use it to publish the topic
CLTID_ARGS=""
CLTID=$(cat $CONFIG_FILE | grep clientid)
if [ $? == 0 ]; then
	CLTID=$(cat $CONFIG_FILE | grep clientid | awk '{print $2}')
	CLTID_ARGS="--client_id $CLTID"
fi

#check if publish-interval-sec is specified, if available, then use it to add delay between two publish-msg
INTERVAL_ARGS=""
INTERVAL=$(cat $CONFIG_FILE | grep publish-interval-sec)
if [ $? == 0 ]; then
	INTERVAL=$(cat $CONFIG_FILE | grep publish-interval-sec | awk '{print $2}')
	INTERVAL_ARGS="--pub_interval $INTERVAL"
fi

wait_for_timesync #wait for ntp to sync

#start the agent with all required args
$APP --ca_file $CA_FILE --cert $CERT_FILE_ARG --key $KEY_FILE_ARG --endpoint $ENDPOINT $VERBOSE_ARGS $COUNT_ARGS $TOPIC_ARGS $CLTID_ARGS $INTERVAL_ARGS > $VERBOSE_FILE 2>&1 &
echo "OK" >> $STARTUP_LOGFILE

