#!/bin/bash
exiftool -model -q -r /Picture | cut -d: -f2 | sort -u

sudo grep -iR failed /var/log

find / -type f -exec grep -li /etc/passwd {} + 2>/dev/null

getent hosts $(hostname -I)
getent passwd $(endusers.sh)
