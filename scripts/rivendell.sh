#!/bin/bash
# start_rivendell.sh  -- RUN ON RIVENDELL
set -e
sysctl -w net.ipv4.ip_forward=1
sed -i '/^net.ipv4.ip_forward/d' /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

# setup interfaces (idempotent)
ip addr add 10.10.0.6/30 dev eth1 2>/dev/null || true
ip addr add 192.215.3.1/24 dev eth0 2>/dev/null || true

# default via Osgiliath
ip route replace default via 10.10.0.5

# accept forwarding to/from internal
iptables -F
iptables -P FORWARD ACCEPT
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

iptables-save > /etc/iptables.rules
echo "[RIVENDELL] done"
