#!/bin/bash
echo "=== Disk Models and Sizes ==="
sudo lsblk -d -o NAME,MODEL,SIZE
echo -e "\n=== ext4 Filesystem Size and Utilization ==="
df -hT | grep ext4 | awk '{print $1, $2, $3, $4, $5, $6}'
