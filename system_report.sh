#!/bin/bash


if [ "$EUID" -ne 0 ]; then
  exec sudo "$0" "$@"
fi

echo
echo "System Report for $(hostname) - $(date)"
echo

# System info
echo "OS: $(source /etc/os-release && echo "$NAME $VERSION")"

# Device Uptime
echo "Uptime: $(uptime -p)"

# CPU Information
echo "CPU: $(lshw -class processor | grep "product" | head -n 1 | cut -d: -f2 | xargs)"

# RAM Information
echo "RAM: $(free -h | awk '/Mem/ {print $2}')"

# Disk Information
echo -n "Disks: $(lshw -class disk 2>/dev/null | awk -F: '/product:/{gsub(/^[ \t]+/, "", $2); printf "%s", $2} /size:/{gsub(/^[ \t]+/, "", $2); printf " - %s\n", $2}')"

# Video card Information
echo "Video Card: $(lshw -C display 2>/dev/null | grep product | cut -d: -f2 | sed 's/^[ \t]*//')"

# Network Information
iface=$(ip route | awk '/default/ {print $5}')
ip=$(ip -4 addr show "$iface" | grep inet | awk '{print $2}' | cut -d/ -f1)
gateway=$(ip route | awk '/default/ {print $3}')
dns=$(grep nameserver /etc/resolv.conf | awk '{print $2}' | paste -sd ', ')

echo "IP Address: $ip"
echo "Gateway: $gateway"
echo "DNS: $dns"


echo

# Logged in users
echo "Users Logged In: $(who | awk '{print $1}' | sort -u | paste -sd, -)"

# Disk usage
echo "Disk Space:"
df -h | awk '/^\// {print $6, $4}'

# Current processes
echo "Process Count: $(ps aux | wc -l)"

# Current load
echo "Load Average: $(uptime | awk -F 'load average: ' '{print $2}')"

# Port information
echo "Listening Network Ports:"
ss -tuln | grep LISTEN

#  Current UFW Status
echo " UFW Status : $(ufw status | grep Status | awk '{print $2}') "

echo
