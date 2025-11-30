#!/bin/bash
# start_osgiliath.sh  -- RUN ON OSGILIATH as root
# Mapping used:
# eth0 -> NAT (DHCP)
# eth3 -> link to Moria (10.10.0.1)
# eth2 -> link to Rivendell (10.10.0.5)
# eth1 -> link to Minastir (10.10.0.9)
# default GW to NAT: 192.168.122.1
# NAT external IP: 192.168.122.186 (SNAT)

set -e

echo "[OSGILIATH] enabling forwarding"
sysctl -w net.ipv4.ip_forward=1
sed -i '/^net.ipv4.ip_forward/d' /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

# ensure dhcp on eth0 (most likely already)
ip link set eth0 up
dhclient -v eth0 || true

# configure point-to-point links (idempotent)
ip addr add 10.10.0.1/30 dev eth3 2>/dev/null || true
ip addr add 10.10.0.5/30 dev eth2 2>/dev/null || true
ip addr add 10.10.0.9/30 dev eth1 2>/dev/null || true

# routing (replace to avoid duplicates)
ip route replace 192.215.3.0/24 via 10.10.0.6
ip route replace 192.215.0.0/24 via 10.10.0.10
ip route replace 192.215.1.192/26 via 10.10.0.10
ip route replace 192.215.1.0/25 via 10.10.0.14
ip route replace 192.215.1.128/26 via 10.10.0.14
ip route replace 192.215.2.0/27 via 10.10.0.18
ip route replace 192.215.2.32/29 via 10.10.0.22
ip route replace default via 192.168.122.1

echo "[OSGILIATH] setting firewall rules"

# basic forwarding policy
iptables -F
iptables -t nat -F
iptables -X

iptables -P INPUT ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Accept established on FORWARD and allow internal networks forwarding
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 192.215.0.0/16 -j ACCEPT

# SNAT (no MASQUERADE)
iptables -t nat -C POSTROUTING -s 192.215.0.0/16 -o eth0 -j SNAT --to-source 192.168.122.186 2>/dev/null || \
iptables -t nat -A POSTROUTING -s 192.215.0.0/16 -o eth0 -j SNAT --to-source 192.168.122.186

# DNAT redirect for Vilya -> Khamul -> redirect to IronHills (for testing)
iptables -t nat -C PREROUTING -s 192.215.3.20 -d 192.215.2.32/29 -j DNAT --to-destination 192.215.3.50 2>/dev/null || \
iptables -t nat -A PREROUTING -s 192.215.3.20 -d 192.215.2.32/29 -j DNAT --to-destination 192.215.3.50

# block Khamul completely (Misi 3) - FORWARD
iptables -A FORWARD -s 192.215.2.32/29 -j DROP
iptables -A FORWARD -d 192.215.2.32/29 -j DROP

# save rules
iptables-save > /etc/iptables.rules

echo "[OSGILIATH] done"
