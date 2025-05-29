#!/bin/bash
echo "=== Operating System ==="
lsb_release -d
echo -e "\n=== CPU Information ==="
lscpu | grep -E 'Model name|Model number'
echo -e "\n=== RAM Installed ==="
grep MemTotal /proc/meminfo
