#!/bin/sh
# Server name ending must be a single digit number
communityname="troisdorf"
server="troisdorf1 troisdorf2 troisdorf3 troisdorf4 troisdorf5 troisdorf6"
domain="freifunk-troisdorf.de"
mtu=1500
# community MAC address, without the last Byte (:)!
communitymacaddress="a2:8c:ae:6f:f6"
# Network part of the network, without the trailing dot
communitynetwork="10.188"
# IPv6 network
communitynetworkv6="fda0:747e:ab29:7405:255::"
# Third octet from the server range
octet3rd="255"
# CIDR muss /16 sein
localserver=$(hostname)

for i in $server; do

(
        for j in $server; do

                if [ $i  != $j ]; then
                        if [ $i = $(hostname) ]; then
                                 ip link add $j type gretap local $(hostname  -I | cut -f1 -d' ') remote $(dig +short $j.$domain) dev eth0 nopmtudisc
                                 ip link set dev $j mtu $mtu
                                 ip link set address $communitymacaddress:${i#$communityname}${j#$communityname} dev $j
                                 ip link set $j up
                                 batctl if add $j
                        fi
                fi

        done
)

done

# configure bat0
ip link set address $communitymacaddress$:0${localserver#$communityname} dev bat0
ip link set up dev bat0
ip addr add $communitynetwork.$octet3rd.${localserver#$communityname}/16 broadcast $communitynetwork.255.255 dev bat0
ip -6 addr add fda0:747e:ab29:7405:255::${localserver#$communityname}/64 dev bat0
alfred -i bat0 > /dev/null 2>&1 &
batadv-vis -i bat0 -s > /dev/null 2>&1 &
service bind9 restart
