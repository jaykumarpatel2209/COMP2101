#!/bin/bash

# Finding fully-qualified domain name using hostname command
fqdn=$(hostname -f)
echo FQDN: $fqdn


# Finding Operating System name and version by using hostnamectl and awk command 
os_name_version=$(hostnamectl | awk '/Operating System:/{print $3, $4, $5}')
echo Operating System name and version: $os_name_version


# Finding all ip address, excluding one which start with 127
ip_address=$(hostname -I)
echo IP Addresses: 
echo $ip_address


# Getting File Status here in human friendly size
echo Root Filesystem Status:
temp=$(df | awk '{print $1, $2, $3, $4, $5, $6}' | head -1)
temp1=$(df -H | awk '{print $1, $2, $3, $4, $5, $6}' | grep '/dev/sda1')
echo $temp
echo $temp1
