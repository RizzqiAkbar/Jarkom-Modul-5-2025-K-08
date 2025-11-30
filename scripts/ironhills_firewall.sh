#!/bin/bash
# run on ironhills (192.215.3.51)
set -e
iptables -F
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# weekend-only access from allowed subnets
iptables -A INPUT -s 192.215.1.192/26 -m time --weekdays Sat,Sun -j ACCEPT
iptables -A INPUT -s 192.215.2.32/29 -m time --weekdays Sat,Sun -j ACCEPT
iptables -A INPUT -s 192.215.0.0/24 -m time --weekdays Sat,Sun -j ACCEPT
iptables -A INPUT -s 192.215.1.128/26 -m time --weekdays Sat,Sun -j ACCEPT

# limit 3 concurrent connections per IP to port 80
iptables -A INPUT -p tcp --dport 80 --syn -m connlimit --connlimit-above 3 --connlimit-mask 32 -j DROP

iptables -A INPUT -j REJECT

iptables-save > /etc/iptables.rules
echo "[ironhills] firewall rules applied"
