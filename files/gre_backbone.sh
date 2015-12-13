#!/bin/sh
# Server name ending must be a single digit number
communityname="troisdorf"
server="troisdorf1 troisdorf2 troisdorf3 troisdorf4 troisdorf5 troisdorf6 troisdorf9"
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
localserver=$(/bin/hostname)
# files
batadv=/usr/local/sbin/batadv-vis
alfred=/usr/local/sbin/alfred
batctl=/usr/local/sbin/batctl

for i in $server; do

(
        for j in $server; do

                if [ $i  != $j ]; then
                        if [ $i = $(/bin/hostname) ]; then
                                 /sbin/ip link add $j type gretap local $(/bin/hostname  -I | /usr/bin/cut -f1 -d' ') remote $(/usr/bin/dig +short $j.$domain) dev eth0 nopmtudisc
                                 /sbin/ip link set dev $j mtu $mtu
                                 /sbin/ip link set address $communitymacaddress:${i#$communityname}${j#$communityname} dev $j
                                 /sbin/ip link set $j up
                                 $batctl if add $j
                        fi
                fi

        done
)

done

# configure bat0
/sbin/ip link set address $communitymacaddress$:0${localserver#$communityname} dev bat0
/sbin/ip link set up dev bat0
/sbin/ip addr add $communitynetwork.$octet3rd.${localserver#$communityname}/16 broadcast $communitynetwork.255.255 dev bat0
/sbin/ip -6 addr add fda0:747e:ab29:7405:255::${localserver#$communityname}/64 dev bat0

/usr/bin/killall alfred
/usr/bin/killall batadv-vis
/bin/sleep 5
$alfred -i bat0 > /dev/null 2>&1 &
/bin/sleep 15
$batadv -i bat0 -s > /dev/null 2>&1 &
/usr/sbin/service bind9 restart
