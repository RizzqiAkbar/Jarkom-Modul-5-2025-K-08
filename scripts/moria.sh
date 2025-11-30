#!/bin/bash
# start_moria.sh -- RUN ON MORIA
set -e
sysctl -w net.ipv4.ip_forward=1
sed -i '/^net.ipv4.ip_forward/d' /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

ip addr add 10.10.0.2/30 dev eth0 2>/dev/null || true
ip addr add 10.10.0.21/30 dev eth1 2>/dev/null || true

ip route replace default via 10.10.0.1

iptables -F
iptables -P FORWARD ACCEPT
iptables-save > /etc/iptables.rules
echo "[MORIA] done"
