#!/bin/sh
#this script overrides default settings of an openwrt system with provided custom data.
#custom data is used to set hostname/rootpw/wifissid/wifipw
#e.g: init-remote-box.sh --ssidhostname=aws-iot-demo-001 --systempw=supersecretpw
USAGE="usage: $0 script user for overriding default settings of openwrt-box
usage: $0 --ssidhostname=aws-iot-demo-001 --systempw=supersecretpw
Note: reboot is required after invoking this script"

NOARGS="yes"
NAME="none"
SYSPW="none"
###############################################################################
optspec=":h-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                    ssidhostname=*) #--name=value
                        val=${OPTARG#*=}
                        opt=${OPTARG%=$val}
                        NAME=${val}
                        NOARGS="no"
                        ;;
                    systempw=*)
                        val=${OPTARG#*=}
                        opt=${OPTARG%=$val}
                        SYSPW=${val}
                        NOARGS="no"
                        ;;
                    help)
                        echo "${USAGE}"
                        exit 1
                        ;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option:"
                        echo -n "${USAGE}";echo ""
                        exit 1
                    fi
                    ;;
            esac;;
        h)
                echo "${USAGE}"
                exit 1
            ;;
        *)
                echo "Unknown option:"
                echo "${USAGE}"
                exit 1
            ;;
    esac
done

#if no args are povided, then just print and exit
if [ $NOARGS = "yes" ]; then
    echo "${USAGE}"
    exit 1
fi

#--name arg is a must
if [ $NAME = "none" ]; then
    echo "${USAGE}"
    exit 1
fi

#--syspw arg is a must
if [ $SYSPW = "none" ]; then
    echo "${USAGE}"
    exit 1
fi

#set wifi ssid
uci set "wireless.default_radio0.ssid=$NAME"
[ $? != 0 ] && echo "Failed to set ssid" && exit 1

#set wifi password
uci set "wireless.default_radio0.key=$SYSPW"
[ $? != 0 ] && echo "Failed to set ssidpw" && exit 1

#set hostname
uci set "system.@system[0].hostname=$NAME"
[ $? != 0 ] && echo "Failed to set hostname" && exit 1

#set root-password
echo -e "$SYSPW\n$SYSPW" | passwd root 1>/dev/nulll 2>/dev/null
[ $? != 0 ] && echo "Failed to change root pw" && exit 1

#finally set a flag so that /etc/uci-defaults doesnt get invoked again after sysupgrade
uci set "system.@system[0].initremotebox=yes"
uci commit
[ $? != 0 ] && echo "Failed to commit uci settings" && exit 1

#create dropbear-authorized-key incase of secure-reverse-tunneling required from a remote server
mkdir -p /root/.ssh
dropbearkey -f /root/.ssh/id_rsa -t rsa -s 2048 1>/dev/null 2>/dev/null

echo "Result: Success"
