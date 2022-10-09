#!/bin/sh
#this script script is used for restarting the aws-iot-demo-agent application

kill $(pidof aws-iot-pubsub-agent)
sleep 3
/etc/etc/WrtPubSubDemo.sh
