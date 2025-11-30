#!/bin/bash
# clients_setup.sh
# Usage: edit below variables per client then run as root

CLIENT_IP="192.215.0.10"
NETMASK="255.255.255.0"
GATEWAY="192.215.0.1"
DNS="192.215.3.10"
IFACE="eth0"

ip link set $IFACE up
ip addr flush dev $IFACE || true
ip addr add ${CLIENT_IP}/24 dev $IFACE
ip route replace default via ${GATEWAY}

echo "nameserver ${DNS}" > /etc/resolv.conf
echo "[client ${CLIENT_IP}] configured"
