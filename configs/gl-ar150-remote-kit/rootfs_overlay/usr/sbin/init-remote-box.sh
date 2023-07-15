#!/bin/sh
#this script overrides default settings of an openwrt system with provided custom data.
#custom data is used to set hostname/rootpw/wifissid/wifipw/xmppuser/xmpppw
#e.g: init-remote-box.sh --name=remote-kit-001 --xmpusr=remote-kit-001@ubuntu-jabber.de --xmppw=remote-kit-pw
USAGE="usage: $0 script user for overriding default settings of openwrt-box
usage: $0 --name=remote-kit-001 --syspw=pw --xmpusr=remote-kit-001@ubuntu-jabber.de --xmppw=remote-kit-pw --xmppadminbuddy=buddy@jabber.de --tunnelport=4000 --xmppbkupadminbuddy=bkupbuddy@jabber.de"

NOARGS="yes"
NAME="none"
XMPUSR="none"
XMPPW="none"
SYSPW="none"
ADMINBUDDY="none"
BKUPADMINBUDDY="none"
TUNNELPORT="none"
###############################################################################
optspec=":h-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                    name=*) #--name=value
                        val=${OPTARG#*=}
                        opt=${OPTARG%=$val}
                        NAME=${val}
                        NOARGS="no"
                        ;;
                    xmpuser=*)
                        val=${OPTARG#*=}
                        opt=${OPTARG%=$val}
                        XMPUSR=${val}
                        NOARGS="no"
                        ;;
                    xmppw=*)
                        val=${OPTARG#*=}
                        opt=${OPTARG%=$val}
                        XMPPW=${val}
                        NOARGS="no"
                        ;;
                    xmppadminbuddy=*)
                        val=${OPTARG#*=}
                        opt=${OPTARG%=$val}
                        ADMINBUDDY=${val}
                        NOARGS="no"
                        ;;
                    xmppbkupadminbuddy=*)
                        val=${OPTARG#*=}
                        opt=${OPTARG%=$val}
                        BKUPADMINBUDDY=${val}
                        NOARGS="no"
                        ;;
                    tunnelport=*)
                        val=${OPTARG#*=}
                        opt=${OPTARG%=$val}
                        TUNNELPORT=${val}
                        NOARGS="no"
                        ;;
                    syspw=*)
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

#incase if --xmpuser arg is not provided, then use --name arg as xmpuser
if [ $XMPUSR = "none" ]; then
    XMPUSR=$NAME
fi

#incase if --xmppw arg is not provided, then use --name arg as xmppw
if [ $XMPPW = "none" ]; then
    XMPPW=$NAME
fi
if [ $TUNNELPORT = "none" ]; then
    TUNNELPORT=4000
fi

uci set "wireless.default_radio0.ssid=$NAME"
[ $? != 0 ] && echo "Failed to set ssid" && exit 1
uci set "wireless.default_radio0.key=$SYSPW"
[ $? != 0 ] && echo "Failed to set ssidpw" && exit 1
uci set "system.@system[0].hostname=$NAME"
[ $? != 0 ] && echo "Failed to set hostname" && exit 1

echo -e "$SYSPW\n$SYSPW" | passwd root 1>/dev/nulll 2>/dev/null
[ $? != 0 ] && echo "Failed to change root pw" && exit 1
mkdir -p /etc/xmproxy/
echo "user: $XMPUSR" >/etc/xmproxy/xmpp-login.txt;
[ $? != 0 ] && echo "Failed to write xmpp username to file" && exit 1
echo "pw: $XMPPW">>/etc/xmproxy/xmpp-login.txt
[ $? != 0 ] && echo "Failed to write xmpp password to file" && exit 1
echo "adminbuddy: $ADMINBUDDY">>/etc/xmproxy/xmpp-login.txt
[ $? != 0 ] && echo "Failed to write xmpp adminbuddy to file" && exit 1
echo "bkupadminbuddy: $BKUPADMINBUDDY">>/etc/xmproxy/xmpp-login.txt
[ $? != 0 ] && echo "Failed to write xmpp backupadminbuddy to file" && exit 1

#finally set a flag so that /etc/uci-defaults doesnt trigger after sysupgrade
uci set "system.@system[0].initremotebox=yes"
uci commit
[ $? != 0 ] && echo "Failed to commit uci settings" && exit 1

#init other settings
mkdir -p /root/.ssh
dropbearkey -f /root/.ssh/id_rsa -t rsa -s 2048 1>/dev/null 2>/dev/null
echo "switch1=ipoftasmota" > /etc/xmproxy/xmpp-alias-list.txt
echo "tunnelport=$TUNNELPORT" >> /etc/xmproxy/xmpp-alias-list.txt
echo "sshport=22" >> /etc/xmproxy/xmpp-alias-list.txt
echo "sship=remotekit.duckdns.org" >> /etc/xmproxy/xmpp-alias-list.txt
echo "sshuser=root" >> /etc/xmproxy/xmpp-alias-list.txt
echo "remotehost=localhost" >> /etc/xmproxy/xmpp-alias-list.txt
echo "remoteport=22" >> /etc/xmproxy/xmpp-alias-list.txt
echo "dataiface=br-lan" >> /etc/xmproxy/xmpp-alias-list.txt
echo "on=sonoff \$switch1 on" >> /etc/xmproxy/xmpp-alias-list.txt
echo "off=sonoff \$switch1 off" >> /etc/xmproxy/xmpp-alias-list.txt
echo "sshstop=shellcmd /usr/bin/ssh-stop.sh \$sshport" >> /etc/xmproxy/xmpp-alias-list.txt
echo "sshstatus=shellcmd /usr/bin/ssh-running.sh \$sshport" >> /etc/xmproxy/xmpp-alias-list.txt
echo "sshstart=shellcmd /usr/bin/ssh-start.sh \$sship \$tunnelport \$sshport \$remoteport \$remotehost \$sshuser &" >> /etc/xmproxy/xmpp-alias-list.txt
echo "sshkey=shellcmd dropbearkey -y -f /root/.ssh/id_rsa;sleep 2;shellcmdresp" >> /etc/xmproxy/xmpp-alias-list.txt
echo "sshkeyclean=shellcmd rm -rf /root/.ssh/id_rsa" >> /etc/xmproxy/xmpp-alias-list.txt
echo "sshkeynew=shellcmdtrig rm -rf /root/.ssh/;shellcmdtrig mkdir -p /root/.ssh/;shellcmdtrig dropbearkey -f /root/.ssh/id_rsa -t rsa -s 2048" >> /etc/xmproxy/xmpp-alias-list.txt
echo "dropbearon=shellcmdtrig /etc/init.d/dropbear start" >> /etc/xmproxy/xmpp-alias-list.txt
echo "dropbearoff=shellcmdtrig /etc/init.d/dropbear stop" >> /etc/xmproxy/xmpp-alias-list.txt
echo "dropbearsts=shellcmd /usr/bin/dropbear-running.sh" >> /etc/xmproxy/xmpp-alias-list.txt
echo "dhcplist=shellcmd /usr/bin/dhcp-list.sh;sleep 2;shellcmdresp" >> /etc/xmproxy/xmpp-alias-list.txt
echo "datacount=shellcmd /usr/sbin/data-usage.sh \$dataiface ;sleep 1;shellcmdresp" >> /etc/xmproxy/xmpp-alias-list.txt
echo "interfaces=shellcmd /usr/sbin/show-interfaces.sh;sleep 2;shellcmdresp" >> /etc/xmproxy/xmpp-alias-list.txt
echo "usbon=shellcmdtrig /usr/sbin/usb-port-power.sh on" >> /etc/xmproxy/xmpp-alias-list.txt
echo "usboff=shellcmdtrig /usr/sbin/usb-port-power.sh off" >> /etc/xmproxy/xmpp-alias-list.txt
echo "usbsts=shellcmd /usr/sbin/usb-port-power.sh;sleep 1;shellcmdresp" >> /etc/xmproxy/xmpp-alias-list.txt
echo "wanhttpon=shellcmdtrig /usr/sbin/wan-http-access.sh on" >> /etc/xmproxy/xmpp-alias-list.txt
echo "wanhttpoff=shellcmdtrig /usr/sbin/wan-http-access.sh off" >> /etc/xmproxy/xmpp-alias-list.txt
echo "wanhttpsts=shellcmd /usr/sbin/wan-http-access.sh;sleep 1;shellcmdresp" >> /etc/xmproxy/xmpp-alias-list.txt
echo "wansshon=shellcmdtrig /usr/sbin/wan-ssh-access.sh on" >> /etc/xmproxy/xmpp-alias-list.txt
echo "wansshoff=shellcmdtrig /usr/sbin/wan-ssh-access.sh off" >> /etc/xmproxy/xmpp-alias-list.txt
echo "wansshsts=shellcmd /usr/sbin/wan-ssh-access.sh;sleep 1;shellcmdresp" >> /etc/xmproxy/xmpp-alias-list.txt
echo "intnetwifion=shellcmdtrig /usr/sbin/wifi-control.sh internet on" >> /etc/xmproxy/xmpp-alias-list.txt
echo "intnetwifioff=shellcmdtrig /usr/sbin/wifi-control.sh internet off" >> /etc/xmproxy/xmpp-alias-list.txt
echo "intnetwifi=shellcmd /usr/sbin/wifi-control.sh internet;sleep 1;shellcmdresp" >> /etc/xmproxy/xmpp-alias-list.txt
echo "locnetwifion=shellcmdtrig /usr/sbin/wifi-control.sh localnet on" >> /etc/xmproxy/xmpp-alias-list.txt
echo "locnetwifioff=shellcmdtrig /usr/sbin/wifi-control.sh localnet off" >> /etc/xmproxy/xmpp-alias-list.txt
echo "locnetwifi=shellcmd /usr/sbin/wifi-control.sh localnet;sleep 1;shellcmdresp" >> /etc/xmproxy/xmpp-alias-list.txt
echo "intnetwificfg=shellcmd /usr/sbin/wifi-config.sh internet;sleep 1;shellcmdresp" >> /etc/xmproxy/xmpp-alias-list.txt
echo "locnetwificfg=shellcmd /usr/sbin/wifi-config.sh localnet;sleep 1;shellcmdresp" >> /etc/xmproxy/xmpp-alias-list.txt
echo "intnetwifiset=shellcmdtrig /usr/sbin/wifi-switch-over.sh internet \$intnetssid \$intnetkey" >> /etc/xmproxy/xmpp-alias-list.txt
echo "locnetwifiset=shellcmdtrig /usr/sbin/wifi-config.sh localnet \$locnetssid \$locnetkey" >> /etc/xmproxy/xmpp-alias-list.txt

#usboff=shellcmdtrig echo 0 > /sys/class/gpio/usb/value
#usbon=shellcmdtrig echo 1 > /sys/class/gpio/usb/value
#xmpoff=shellcmdtrig /opt/fmw/bin/xmproxyclt --shutdown

echo "Result: Success"
