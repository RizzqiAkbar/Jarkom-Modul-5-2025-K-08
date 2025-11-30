#!/bin/bash
# start_wilderland.sh -- RUN ON WILDERLAND
set -e
sysctl -w net.ipv4.ip_forward=1
sed -i '/^net.ipv4.ip_forward/d' /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

ip addr add 10.10.0.22/30 dev eth0 2>/dev/null || true
ip addr add 10.10.0.25/30 dev eth2 2>/dev/null || true
# also Khamul LAN (gateway on Wilderland)
ip addr add 192.215.2.33/29 dev eth2 2>/dev/null || true  # if eth2 is the LAN link; adjust if different

ip route replace default via 10.10.0.21

iptables -F
iptables -P FORWARD ACCEPT
iptables-save > /etc/iptables.rules
echo "[WILDERLAND] done"
