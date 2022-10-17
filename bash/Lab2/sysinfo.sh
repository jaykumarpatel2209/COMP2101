#!/bin/bash

# Using echo for blank line
echo


# Finding hostname
hostname=$(hostname)
echo Report for $hostname


# Using echo to print seperator
echo ======================


# Finding fully-qualified domain name by using hostname command
fqdn=$(hostname -f)
echo FQDN: $fqdn


# Finding Operating System name and version by using hostnamectl and awk command 
os_name_version=$(hostnamectl | awk '/Operating System:/{print $3, $4, $5}')
echo Operating System name and version: $os_name_version


# Finding IP address which is used for sending and receiving data.
ip_address=$(hostname -I)
echo IP Address: $ip_address


# Finding free space of root filesystem space ('/') and modifying it in human-friendly size.
free_space=$(df -h / | grep dev | awk '{print $4}')
echo Root Filesystem Free Space: $free_space


# Using echo to print seperator
echo ======================


# Using echo for blank line
echo
