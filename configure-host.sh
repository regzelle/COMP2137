#!/bin/bash
# configure-host.sh
# Sript to tweak hostname, IP, and hosts entries

trap "" TERM HUP INT

VERBOSE=false

msg(){
  if [ "$VERBOSE" = true ]; then
    echo "$1"
  fi
}

logit(){
  logger "host-config: $1"
}

# Manual argument parsing
while [ $# -gt 0 ]; do
  case "$1" in
    -verbose) VERBOSE=true ;;
    -name) NEW_NAME="$2"; shift ;;
    -ip) NEW_IP="$2"; shift ;;
    -hostentry) ENTRY_NAME="$2"; ENTRY_IP="$3"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

# Change hostname if different
if [ ! -z "$NEW_NAME" ]; then
  CURRENT_NAME=$(hostname)
  if [ "$CURRENT_NAME" != "$NEW_NAME" ]; then
    echo "$NEW_NAME" > /etc/hostname
    hostname "$NEW_NAME"
    sed -i "s/$CURRENT_NAME/$NEW_NAME/g" /etc/hosts
    msg "Hostname changed: $CURRENT_NAME -> $NEW_NAME"
    logit "hostname updated"
  else
    msg "Hostname already set to $NEW_NAME"
  fi
fi

# Change IP if different
if [ ! -z "$NEW_IP" ]; then
  CURRENT_IP=$(hostname -I | awk '{print $1}')
  if [ "$CURRENT_IP" != "$NEW_IP" ]; then
    NET_FILE="/etc/netplan/01-netcfg.yaml"
    cp "$NET_FILE" "$NET_FILE.bak"
    sed -i "s/$CURRENT_IP/$NEW_IP/g" "$NET_FILE"
    if netplan apply; then
      sed -i "s/$CURRENT_IP/$NEW_IP/g" /etc/hosts
      msg "IP changed: $CURRENT_IP -> $NEW_IP"
      logit "ip updated"
    else
      echo "Could not apply new IP, restoring backup"
      mv "$NET_FILE.bak" "$NET_FILE"
    fi
  else
    msg "IP already set to $NEW_IP"
  fi
fi

# Update or add host entry
if [ ! -z "$ENTRY_NAME" ] && [ ! -z "$ENTRY_IP" ]; then
  if grep -qw "$ENTRY_NAME" /etc/hosts; then
    sed -i "s/.*$ENTRY_NAME/$ENTRY_IP $ENTRY_NAME/" /etc/hosts
    msg "Updated entry for $ENTRY_NAME"
    logit "hosts entry changed"
  else
    echo "$ENTRY_IP $ENTRY_NAME" >> /etc/hosts
    msg "Added hosts entry: $ENTRY_NAME"
    logit "hosts entry added"
  fi
fi

