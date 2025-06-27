#!/bin/bash

set -e

DOMAINS_FILE="domains.txt"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
  echo "❌ Please run as root (e.g., sudo ./add_lan_hosts.sh)"
  exit 1
fi

# Ask for server IP
read -rp "📥 Enter the LAN server IP (e.g., 192.168.1.10): " SERVER_IP
if [[ -z "$SERVER_IP" ]]; then
  echo "❌ Server IP is required."
  exit 1
fi

# Check domains.txt
if [[ ! -f "$DOMAINS_FILE" ]]; then
  echo "❌ '$DOMAINS_FILE' not found!"
  exit 1
fi

# Backup /etc/hosts
cp /etc/hosts /etc/hosts.bak.$(date +%s)

echo "🛠 Adding LAN domains to /etc/hosts..."

while IFS= read -r line || [[ -n "$line" ]]; do
  DOMAIN=$(echo "$line" | awk '{print $1}')
  [[ -n "$DOMAIN" ]] || continue

  # Remove existing entry
  sed -i "/[[:space:]]$DOMAIN$/d" /etc/hosts

  # Add new one
  echo "$SERVER_IP $DOMAIN" >> /etc/hosts
done < "$DOMAINS_FILE"

echo "✅ /etc/hosts updated with LAN domains."
