#!/bin/bash

set -e

# Prompt user for server IP
read -p "🔧 Enter the Vaultwarden server IP address (e.g. 192.168.1.100): " SERVER_IP

# Define hostnames to map
DOMAINS=("vault.lan" "jelly.lan" "trans.lan" "file.lan")

echo
echo "🛠️  Updating /etc/hosts with:"
echo "    IP     : $SERVER_IP"
echo "    Domains: ${DOMAINS[*]}"
echo

# Require root permissions
if [[ $EUID -ne 0 ]]; then
   echo "❌ This script must be run as root (use sudo)" 
   exit 1
fi

# Backup /etc/hosts
cp /etc/hosts /etc/hosts.bak

# Add each domain if not already present
for DOMAIN in "${DOMAINS[@]}"; do
    if grep -q "[[:space:]]$DOMAIN" /etc/hosts; then
        echo "🔁 $DOMAIN already exists in /etc/hosts — skipping"
    else
        echo "$SERVER_IP    $DOMAIN" >> /etc/hosts
        echo "✅ Added: $DOMAIN → $SERVER_IP"
    fi
done

echo
echo "🎉 All done. You can now access:"
for DOMAIN in "${DOMAINS[@]}"; do
    echo "   → https://$DOMAIN"
done

