#!/bin/bash
datum=$(date "+%b %d")
hostname=$(hostname)
clients=$(cat /var/log/syslog | grep "$(date "+%b %d")" | grep DHCPACK | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' | sort | uniq | wc -l)
echo "nc.gateways."$hostname" $clients `date +%s`" | nc -n -q 5 10.188.0.10 2003
echo "0 Uniq-Clients count=$clients - $clients Uniq Clients heute"
