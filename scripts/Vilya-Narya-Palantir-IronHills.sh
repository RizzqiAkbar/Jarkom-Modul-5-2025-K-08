#!/bin/bash
# setup_servers.sh  -- run on each server node, script auto-detects hostname
set -e
HOST=$(hostname -s)

echo "[${HOST}] starting server setup"

# common: ensure nettools present (for testing)
apt-get update
apt-get install -y netcat iproute2 iputils-ping bind9 isc-dhcp-server apache2

if [ "$HOST" = "vilya" ] || [ "$HOST" = "Vilya" ]; then
  cat > /etc/dhcp/dhcpd.conf <<'EOF'
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 192.215.0.0 netmask 255.255.255.0 {
  range 192.215.0.10 192.215.0.200;
  option routers 192.215.0.1;
  option domain-name-servers 192.215.3.10;
}

subnet 192.215.1.0 netmask 255.255.255.128 {
  range 192.215.1.10 192.215.1.100;
  option routers 192.215.1.1;
  option domain-name-servers 192.215.3.10;
}

subnet 192.215.1.128 netmask 255.255.255.192 {
  range 192.215.1.130 192.215.1.180;
  option routers 192.215.1.129;
  option domain-name-servers 192.215.3.10;
}

subnet 192.215.1.192 netmask 255.255.255.192 {
  range 192.215.1.194 192.215.1.240;
  option routers 192.215.1.193;
  option domain-name-servers 192.215.3.10;
}

subnet 192.215.2.0 netmask 255.255.255.224 {
  range 192.215.2.2 192.215.2.30;
  option routers 192.215.2.1;
  option domain-name-servers 192.215.3.10;
}

subnet 192.215.2.32 netmask 255.255.255.248 {
  range 192.215.2.34 192.215.2.38;
  option routers 192.215.2.33;
  option domain-name-servers 192.215.3.10;
}
EOF
  # start dhcpd without systemctl
  killall dhcpd 2>/dev/null || true
  /usr/sbin/dhcpd -4 -cf /etc/dhcp/dhcpd.conf eth0 || true
  echo "[vilya] dhcpd started (eth0)"
fi

if [ "$HOST" = "narya" ] || [ "$HOST" = "Narya" ]; then
  # minimal bind9 config: use system defaults, ensure forwarder to Internet
  sed -i '/forwarders /,$d' /etc/bind/named.conf.options 2>/dev/null || true
  cat > /etc/bind/named.conf.options <<'EOF'
options {
    directory "/var/cache/bind";
    recursion yes;
    allow-query { any; };
    forwarders { 8.8.8.8; 1.1.1.1; };
    dnssec-validation no;
    auth-nxdomain no;
    listen-on { any; };
};
EOF
  /etc/init.d/bind9 restart || (named -c /etc/bind/named.conf -g &)
  echo "[narya] bind9 started"
fi

if [ "$HOST" = "palantir" ] || [ "$HOST" = "Palantir" ]; then
  echo "Welcome to palantir" > /var/www/html/index.html
  apache2ctl restart || /etc/init.d/apache2 restart
  echo "[palantir] apache started"
fi

if [ "$HOST" = "ironhills" ] || [ "$HOST" = "IronHills" ]; then
  echo "Welcome to ironhills" > /var/www/html/index.html
  apache2ctl restart || /etc/init.d/apache2 restart
  echo "[ironhills] apache started"
fi

echo "[${HOST}] server setup complete"
