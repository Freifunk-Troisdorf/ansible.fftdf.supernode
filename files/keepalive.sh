#!/bin/bash
# Version 1.4
# Parameter setzen
GATEWAY1=185.66.193.105
GATEWAY2=185.66.193.106
GATEWAY1v6=2a03:2260:121::255:5
GATEWAY2v6=2a03:2260:121::255:6
IP=/sbin/ip
PING=/bin/ping
BATCTL=/usr/local/sbin/batctl

if [ "hostname = troisdorf1 | troisdorf2" ]
    then
        DEFAULT_GATEWAY=$GATEWAY1
        FALLBACK_GATEWAY=$GATEWAY2
	DEFAULT_GATEWAYv6=$GATEWAY1v6
	FALLBACK_GATEWAYv6=$GATEWAY2v6
    else
        DEFAULT_GATEWAY=$GATEWAY2
        FALLBACK_GATEWAY=$GATEWAY1
        DEFAULT_GATEWAYv6=$GATEWAY2v6
        FALLBACK_GATEWAYv6=$GATEWAY1v6

fi

if $PING -c 1 $DEFAULT_GATEWAY
        then
                $IP route replace default via $DEFAULT_GATEWAY table 42
                $IP -6 route replace default via $DEFAULT_GATEWAYv6 table 42
                $BATCTL gw server 100Mbit/100Mbit
                echo "Gateway erreichbar"
        else
        if $PING -c 1 $FALLBACK_GATEWAY
            then
                $IP route replace default via $FALLBACK_GATEWAY table 42
                $IP -6 route replace default via $FALLBACK_GATEWAYv6 table 42
                $BATCTL gw server 80Mbit/80Mbit
                echo "Nun FALLBACK_GATEWAY"
            else
                $BATCTL gw off
                #Kein Gateway erreichbar, batctl gw off
        fi
fi

