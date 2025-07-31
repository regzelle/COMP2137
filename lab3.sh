#!/bin/bash
# lab3.sh
# Script to copy and run configure-host.sh on 2 servers

trap "" TERM HUP INT

# Check if verbose passed
VERBOSE_OPT=""
if [ "$1" == "-verbose" ]; then
  VERBOSE_OPT="-verbose"
fi

# Helper to deploy and run
deploy_run() {
  TARGET=$1
  HOSTNAME=$2
  TARGET_IP=$3
  OTHERNAME=$4
  OTHER_IP=$5

  echo ">>> Working on $TARGET..."
  
  # Copy script
  if ! scp configure-host.sh remoteadmin@$TARGET:/root; then
    echo "Failed to copy script to $TARGET"
    exit 1
  fi
  
  # Run script on remote
  if ! ssh remoteadmin@$TARGET "/root/configure-host.sh $VERBOSE_OPT -name $HOSTNAME -ip $TARGET_IP -hostentry $OTHERNAME $OTHER_IP"; then
    echo "Failed to run script on $TARGET"
    exit 1
  fi
}

deploy_run 172.16.1.241 loghost 192.168.16.3 webhost 192.168.16.4
deploy_run 172.16.1.242 webhost 192.168.16.4 loghost 192.168.16.3

# Uspdate local host entries
sudo ./configure-host.sh $VERBOSE_OPT -hostentry loghost 192.168.16.3
sudo ./configure-host.sh $VERBOSE_OPT -hostentry webhost 192.168.16.4

echo ">>> Lab configuration completed!"
