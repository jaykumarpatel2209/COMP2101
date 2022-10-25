#!/bin/bash

echo "********** Point-1 **********"
echo "Checking installation of LXD..."

# Checking LXD installation by using IF condition. If it is false then installing LXD in machine.
snap list | grep -q lxd
if [ $? -eq 0 ]; then
	echo "LXD is already installed"
else
	echo "LXD is not installed, need to install it"
	echo "Installing LXD"
	sudo snap install lxd
fi


echo ""
echo "********** Point-2 **********"
echo "Checking initialization of LXD..."

# Checking LXD initialization by using IF condition. If it is false then initializing it.
ip a | grep -q lxdbr0
if [ $? -eq 0 ]; then
	echo "LXD is already initialized"
else
	echo "LXD is not initialized. So, Initializing LXD"
	lxd init –auto
fi

echo ""
echo "Checking installation of LXC..."

# Checking LXC installation by using IF condition. If it is false then installing LXC in machine.
lxc-ls
if [ $? -eq 0 ]; then
	echo "LXC is already installed"
else
	echo "LXC is not installed. So, installing LXC"
	sudo apt install lxc-utils
fi


echo ""
echo "********** Point-3 **********"
echo "Checking 'COMP2101-S22' container..."

# Checking 'COMP2101-S22' container by using IF condition. If it is false then creating container with name 'COMP2101-S22'.
lxc list | grep -q COMP2101-S22
if [ $? -eq 0 ]; then
	echo "Container 'COMP2101-S22' already exist"
else
	echo "Container 'COMP2101-S22' doesn't exist. So, creating new container with name 'COMP2101-S22'"
	lxc launch images:ubuntu/focal/amd64 COMP2101-S22
fi


echo ""
echo "********** Point-4 **********"
echo "Checking /etc/hosts file for hostname 'COMP2101-S22' with container current IP address..."

# Using IF condition for checking /etc/hostsfile for hostname 'COMP2101-S22' with container current IP address. If it is false then adding host]name and container current IP address.
cat /etc/hosts | grep -q COMP2101-S22
if [ $? -eq 0 ]; then
	echo "'COMP2101-S22' and it's IP address is already available in /etc/hosts file"
else
	echo "'COMP2101-S22' and it's IP address is not available in /etc/hosts file. So, adding it"
	ip_address=$(lxc info COMP2101-S22 | grep inet: | grep global | awk '{print $2}')
	echo "$ip_address	COMP2101-S22" | sudo tee -a /etc/hosts
fi


echo ""
echo "********** Point-5 **********"
echo "Checking apache2 installation in container..."

# Using IF condition for checking apache2 installation. If it is false then installing apache in container.
lxc exec COMP2101-S22 -- dpkg --get-selections | grep -q apache
if [ $? -eq 0 ]; then
	echo "Apache is already installed."
else
	echo "Apache is not installed in container. So, installing it..."
	lxc exec COMP2101-S22 -- apt install apache2
fi


echo ""
echo "********** Point-6 **********"
echo "Checking curl installation in host VM..."

# Using IF condition checking curl installation in host VM. If it is false then installing curl in host VM.
curl -s http://zonzorp.net > /dev/null
if [ $? -eq 0 ]; then
	echo "Curl is already installed in 'hosting VM'"
else
	echo "Curl is not installed in 'hosting VM'. So, Installing Curl in 'hosting VM'"
	sudo apt  install curl
fi

echo ""
echo "Checking curl installation in container..."
# Using IF condition checking curl installation in container. If it is false then installing curl in container.
lxc exec COMP2101-S22 -- curl -s http://zonzorp.net > /dev/null
if [ $? -eq 0 ]; then
	echo "Curl is already installed in container 'COMP2101-S22'"
else
	echo "Curl is not installed in 'COMP2101-S22'. So, Installing Curl in container 'COMP2101-S22'"
	lxc exec COMP2101-S22 -- sudo apt  install curl
fi

echo ""
echo "Retrieving web page from the web service..."

# Retrieving web page from the web service and printing success and failed based on status.
lxc exec COMP2101-S22 -- curl http://zonzorp.net && echo "Web page retrieval Successful!" || echo "Web page retrieval Failed!"
