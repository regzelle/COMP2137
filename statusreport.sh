#!/bin/bash

# Show system status report

# Show the current cpu activity label
echo -n "CPU Uptime"
uptime
# Show the available free memory
echo -n "Free Memory: "
free -h | awk '/^Mem/ {print $3}' 
# Show the available disk space
echo -n "Free disk space"
df s /dev/sda2 | awk 'NR==2 {print $3}'
