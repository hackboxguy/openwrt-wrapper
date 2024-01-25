#!/bin/sh
#this script converts openwrt's uci data to aws-iot-pubsub-agent.conf format
DEF_OUTFILE=/tmp/aws-iot-pubsub-agent.conf
if [ -z $1 ]; then
	OUTFILE=$DEF_OUTFILE
else
	OUTFILE=$1
fi

RES=$(uci get awsiot-demo.Settings.endpoint)
echo "endpoint: $RES" > $OUTFILE

RES=$(uci get awsiot-demo.Settings.verbosity)
echo "verbosity: $RES" >> $OUTFILE

RES=$(uci get awsiot-demo.Settings.interval)
echo "publish-interval-sec: $RES" >> $OUTFILE

RES=$(uci get awsiot-demo.Settings.count)
echo "total-publish-count: $RES" >> $OUTFILE

RES=$(uci get awsiot-demo.Settings.message)
echo "publish-message: $RES" >> $OUTFILE

RES=$(uci get awsiot-demo.Settings.topic)
echo "publish-topic: $RES" >> $OUTFILE

RES=$(uci get awsiot-demo.Settings.clientid)
echo "clientid: $RES" >> $OUTFILE

echo "verbosefile: /tmp/aws-iot-pubsub-agent.log" >> $OUTFILE #keep logfile path fixed
