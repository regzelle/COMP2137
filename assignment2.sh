#!/bin/bash
# COMP2137 - Assignment 2 Script
# Author: Reggie Birondo

echo "Running assignment 2 setup..."

# check if script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "You need to run this script as root."
  exit 1
fi

# netplan static IP config
echo "Setting up IP address..."
NETPLAN_FILE="/etc/netplan/00-installer-config.yaml"
IP_ADDR="192.168.16.21/24"

# update IP if it's not already in the file
grep "$IP_ADDR" $NETPLAN_FILE > /dev/null
if [ $? -eq 0 ]; then
  echo "IP already set."
else
  sed -i "s/addresses: \[.*\]/addresses: [$IP_ADDR]/" $NETPLAN_FILE
  netplan apply
fi

# update hosts file
echo "Adding entry to /etc/hosts..."
sed -i '/server1/d' /etc/hosts
echo "192.168.16.21 server1" >> /etc/hosts

# install apache2 and squid
echo "Installing apache2 and squid..."
apt update
dpkg -l | grep apache2 > /dev/null
if [ $? -ne 0 ]; then
  apt install apache2 -y
fi
dpkg -l | grep squid > /dev/null
if [ $? -ne 0 ]; then
  apt install squid -y
fi

# add users
echo "Creating user accounts..."
USERS="dennis aubrey captain snibbles brownie scooter sandy perrier cindy tiger yoda"

for u in $USERS; do
  id $u > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "$u exists"
  else
    useradd -m -s /bin/bash $u
    echo "$u added"
  fi

  su - $u -c "
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    if [ ! -f ~/.ssh/id_rsa ]; then
      ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
    fi
    if [ ! -f ~/.ssh/id_ed25519 ]; then
      ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
    fi
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
  "
done

# give dennis extra SSH key and sudo
echo "Updating dennis user..."
EXTRA_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4rT3vTt99Ox5kndS4HmgTrKBT8SKzhK4rhGkEVGlCI student@generic-vm"
AUTH_FILE="/home/dennis/.ssh/authorized_keys"
grep "$EXTRA_KEY" $AUTH_FILE > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "$EXTRA_KEY" >> $AUTH_FILE
fi

groups dennis | grep sudo > /dev/null
if [ $? -ne 0 ]; then
  usermod -aG sudo dennis
fi

echo "Setup complete."
