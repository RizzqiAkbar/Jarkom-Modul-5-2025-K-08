#!/bin/bash
# start_minastir.sh  -- RUN ON MINASTIR
set -e
sysctl -w net.ipv4.ip_forward=1
sed -i '/^net.ipv4.ip_forward/d' /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

ip addr add 10.10.0.10/30 dev eth0 2>/dev/null || true
ip addr add 192.215.0.1/24 dev eth1 2>/dev/null || true
ip addr add 192.215.1.193/26 dev eth2 2>/dev/null || true

# default via Osgiliath
ip route replace default via 10.10.0.9

iptables -F
iptables -P FORWARD ACCEPT
iptables-save > /etc/iptables.rules
echo "[MINASTIR] done"
