#!/bin/bash
# start_pelargir.sh -- RUN ON PELARGIR
set -e
sysctl -w net.ipv4.ip_forward=1
sed -i '/^net.ipv4.ip_forward/d' /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

ip addr add 10.10.0.14/30 dev eth0 2>/dev/null || true
ip addr add 192.215.3.50/24 dev eth2 2>/dev/null || true
# for link to ArduinBanks local: also put .17 address if needed
ip addr add 10.10.0.17/30 dev eth? 2>/dev/null || true  # adjust iface if needed

ip route replace default via 10.10.0.13

iptables -F
iptables -P FORWARD ACCEPT
iptables-save > /etc/iptables.rules
echo "[PELARGIR] done"
