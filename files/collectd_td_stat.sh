#!/bin/bash
#Check if foldes exists
if ! [ -d /opt/freifunk/tunneldigger_interfaces ]; then
mkdir /opt/freifunk/tunneldigger_interfaces
fi
#Remove old Interfaces
rm /opt/freifunk/tunneldigger_interfaces/*
#Create Interace files
for i in `/usr/local/sbin/batctl if | grep l2tp1`;
do
        touch /opt/freifunk/tunneldigger_interfaces/$i
done
#Remove Active file
rm /opt/freifunk/tunneldigger_interfaces/active
