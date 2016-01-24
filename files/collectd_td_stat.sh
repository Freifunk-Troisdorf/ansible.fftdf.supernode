#!/bin/bash
#Check if foldes exists
if ! [ -d /opt/freifunk/tunneldigger_interfaces ]; then
mkdir /opt/freifunk/tunneldigger_interfaces
fi
#Remove old Interfaces
rm /opt/freifunk/tunneldigger_interfaces/*
#Create Interace files
for i in `/sbin/brctl show br-nodes | grep l2tp1`;
do
        touch /opt/freifunk/tunneldigger_interfaces/$i
done
#Remove wrong file
rm /opt/freifunk/tunneldigger_interfaces/no
rm /opt/freifunk/tunneldigger_interfaces/br-*
rm /opt/freifunk/tunneldigger_interfaces/8*
