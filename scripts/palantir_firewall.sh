#!/bin/bash
# run on palantir (192.215.3.30)
set -e
iptables -F
# allow established
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# time-based rules
# Elf (07:00-15:00)
iptables -A INPUT -s 192.215.1.0/25 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT
iptables -A INPUT -s 192.215.2.0/27 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT
# Human (17:00-23:00)
iptables -A INPUT -s 192.215.0.0/24 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT
iptables -A INPUT -s 192.215.1.128/26 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT

# portscan detection: >15 syns in 20s
iptables -A INPUT -p tcp --syn -m recent --name portscan --update --seconds 20 --hitcount 15 -j LOG --log-prefix "PORT_SCAN_DETECTED "
iptables -A INPUT -p tcp --syn -m recent --name portscan --update --seconds 20 --hitcount 15 -j DROP
iptables -A INPUT -p tcp --syn -m recent --name portscan --set -j ACCEPT
iptables -A INPUT -m recent --name portscan --rcheck --seconds 120 -j DROP

# default drop
iptables -A INPUT -j DROP

iptables-save > /etc/iptables.rules
echo "[palantir] firewall rules applied"
