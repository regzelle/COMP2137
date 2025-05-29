#!/bin/bash
echo "=== Interface Names and Model/NIC Descriptions ==="
for iface in $(ls /sys/class/net); do
    echo -n "$iface: "
    ethtool $iface 2>/dev/null | grep 'Settings for\|Speed\|Duplex' || echo "No ethtool info"
done
echo -e "\n=== IP Addresses for Each Interface ==="
ip -o -4 addr show | awk '{print $2, $4}'
echo -e "\n=== Default Route Gateway ==="
ip route | grep default | awk '{print $3}'
