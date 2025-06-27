#!/bin/bash

set -e

# Check for root
if [[ $EUID -ne 0 ]]; then
  echo "❌ This script must be run as root."
  exit 1
fi

echo "🔧 Setting up dnsmasq for local DNS..."

# Ask for LAN IP
read -rp "📥 Enter the server's local IP address (e.g., 192.168.1.10): " SERVER_IP
if [[ -z "$SERVER_IP" ]]; then
  echo "❌ IP cannot be empty"
  exit 1
fi

# Install dnsmasq if not present
if ! command -v dnsmasq &>/dev/null; then
  echo "📦 Installing dnsmasq..."
  apt update && apt install -y dnsmasq
else
  echo "✅ dnsmasq already installed"
fi

# Ask for domain names to configure
read -rp "📥 Enter the local domain (e.g., vault.lan): " DOMAIN
if [[ -z "$DOMAIN" ]]; then
  echo "❌ Domain cannot be empty"
  exit 1
fi

# Create config file
CONF_FILE="/etc/dnsmasq.d/lan.conf"

echo "📝 Writing config to $CONF_FILE..."

cat > "$CONF_FILE" <<EOF
# Local DNS for LAN services
address=/$DOMAIN/$SERVER_IP
listen-address=127.0.0.1,$SERVER_IP
domain-needed
bogus-priv
EOF

# Restart dnsmasq
echo "🔄 Restarting dnsmasq..."
systemctl restart dnsmasq
systemctl enable dnsmasq

# Test
echo "🧪 Testing DNS resolution..."
apt install -y dnsutils &>/dev/null
dig +short "$DOMAIN" @"127.0.0.1"

echo "✅ dnsmasq setup complete!"
echo "💡 Make sure other devices use $SERVER_IP as their DNS server."
