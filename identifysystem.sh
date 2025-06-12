#!/bin/bash

# This is a script to display the current hostname, IP address and gateway IP
# This is a script to display the system stats such as 

# Find and display the hostname label
echo -n "Hostname: "
hostname
# Find and display the IP address used to reach the internet
echo -n "IP address: "
ip r s default | awk '{print $9}'
# Find an display gateway with label
echo -n "Gateway IP: "
ip r s default | awk '{print $3}'
