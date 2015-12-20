#!/bin/sh
# Version 5
# Der servername muss mit einer einstelligen Zahl aufhoeren!!!!!
communityname="troisdorf"
#server="troisdorf0 troisdorf1 troisdorf2 troisdorf3 troisdorf4 troisdorf5 troisdorf6 troisdorf7 troisdorf8 troisdorf9 "
server="troisdorf0 troisdorf9"
domain="freifunk-troisdorf.de"
mtu=1400
# community MAC address, without the last Byte (:)!
communitymacaddress="a2:8c:ae:6f:f6"
tunnelPrefix=10
sessionPrefix=1
# Netzwerkteil des Netzes, ohne abschliessenden Punkt
communitynetwork="10.188"
# IPv6 network
communitynetworkv6="fda0:747e:ab29:7405:255::"
# Drittes Octet des serverbereichs
octet3rd="255"
# CIDR muss /16 sein
localserver=$(/bin/hostname)
batadv=/usr/local/sbin/batadv-vis
alfred=/usr/local/sbin/alfred
batctl=/usr/local/sbin/batctl
ip=/sbin/ip
dig=/usr/bin/dig

for i in $server; do
(
        for j in $server; do
                if [ $i  != $j ]; then
                        if [ $i = $localserver ]; then
                                 ip l2tp add tunnel remote $($dig +short $j.$domain) local $(/bin/hostname  -I | /usr/bin/cut -f1 -d' ') tunnel_id $tunnelPrefix${i#$communityname}${j#$communityname} peer_tunnel_id $tunnelPrefix${j#$communityname}${i#$communityname} encap udp udp_sport 300${i#$communityname}${j#$communityname} udp_dport 300${j#$communityname}${i#$communityname}
                                 ip l2tp add session name l2tp-$j tunnel_id $tunnelPrefix${i#$communityname}${j#$communityname} session_id $sessionPrefix${i#$communityname}${j#$communityname} peer_session_id $sessionPrefix${j#$communityname}${i#$communityname}
                                 #ip link set address $communitymacaddress:${i#$communityname}${j#$communityname} dev l2tp-$j
                                 ip link set dev l2tp-$j mtu $mtu
                                 ip link set up l2tp-$j
                                 $batctl if add l2tp-$j
                        fi
                fi
        done
)
done

# Rest starten
$ip link set address $communitymacaddress:0${localserver#$communityname} dev bat0
#$ip link set address $communitymacaddress:ff dev bat0
$ip link set up dev bat0
$ip addr add $communitynetwork.$octet3rd.${localserver#$communityname}/16 broadcast $communitynetwork.255.255 dev bat0
$ip -6 addr add $communitynetworkv6${localserver#$communityname}/64 dev bat0

/usr/bin/killall alfred
/usr/bin/killall batadv-vis
/bin/sleep 5
$alfred -i bat0 > /dev/null 2>&1 &
/bin/sleep 15
$batadv -i bat0 -s > /dev/null 2>&1 &
