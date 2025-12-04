# Jarkom-Modul-5-2025-K-08

Anggota : 
|Nama|NRP|
|---|---|
|Rizqi Akbar Sukirman Putra|5027241044|
|Adinda Cahya Pramesti|5027241117|

# Topologi GNS3
<img width="1230" height="761" alt="Screenshot 2025-11-30 191517" src="https://github.com/user-attachments/assets/cac12195-8b94-4454-8933-cb5511e12247" />

# VLSM Topologi
<img width="1178" height="505" alt="Screenshot 2025-12-04 222218" src="https://github.com/user-attachments/assets/a9063bff-d158-4eb8-9426-2ef6a74fecce" />

## Misi 1
Dilakukan perencanaan jaringan menggunakan metode Variable Length Subnet Mask (VLSM).
Tujuan utamanya adalah membagi alamat jaringan 192.215.0.0 menjadi beberapa subnet sesuai kebutuhan host setiap segmen jaringan.


Hasil utama dari Misi 1:
- Identifikasi jumlah host pada setiap LAN (Elendil, Isildur, Durin, Cirdan, dst).
- Pembagian subnet secara efisien menggunakan VLSM sehingga tidak ada pemborosan alamat IP.
- Penentuan kelas subnet untuk masing-masing segmen, mencakup:
- Subnet besar untuk LAN server
- Subnet menengah untuk LAN pengguna
- Subnet kecil untuk point-to-point router (/30)

Misi ini memastikan keseluruhan topologi dapat berjalan menggunakan skema IP yang terstruktur, efisien, dan mudah dikelola.


## Misi 2
seluruh node pada topologi GNS3 — router, switch layer 3 (bila ada), dan PC — dikonfigurasi sesuai dengan hasil VLSM pada misi pertama.


Hasil utama Misi 2:
- Setiap interface router mendapatkan IP sesuai subnetnya.
- Setiap LAN memiliki gateway yang benar.
- NAT di Osgiliath berhasil dikonfigurasi sehingga seluruh jaringan internal dapat terhubung ke internet.
- Pengujian konektivitas menggunakan ping antar node untuk memastikan jaringan berjalan baik.

Hasil akhirnya adalah seluruh perangkat pada topologi dapat saling terhubung sesuai rute internal, dan node yang memerlukan akses internet bisa melewati NAT.


## Misi 3
Hasil utama Misi 3:

1. Routing
Router-router seperti Moria, Osgiliath, Minastir, Pelargir, dan ArduinBanks dibuatkan static route agar dapat mencapai semua subnet dari seluruh cabang jaringan.
Routing meliputi:

- Routes untuk jaringan LAN
- Routes untuk jaringan antar router
- Default route menuju Osgiliath untuk akses internet

Routing ini memastikan:
- Paket bergerak ke tujuan yang benar
- Tidak terjadi loop
- Setiap router mengenali posisi subnet lainnya

2. Firewall
Firewall dasar diterapkan pada router utama, terutama Osgiliath dan Pelargir.
Aturan firewall mencakup:

- Mengizinkan traffic internal
- Menolak akses dari luar yang tidak valid
- Port filtering untuk keamanan LAN
- NAT masquerading untuk internet

Dengan firewall ini, jaringan menjadi lebih aman dan hanya trafik yang diizinkan yang dapat melewati boundary router.

# Revisi

Konfigurasi IP — Ringkasan Per Perangkat

```
Router

Osgiliath (router pusat)

eth0 -> NAT (DHCP)  -> external IP 192.168.122.186
eth1 -> Osgiliath↔Minastir -> 192.215.254.9/30
eth2 -> Osgiliath↔Rivendell -> 192.215.254.5/30
eth3 -> Osgiliath↔Moria -> 192.215.254.1/30
default gw -> 192.168.122.1


Rivendell

eth0 -> server LAN -> 192.215.3.1/24
eth1 -> Osgiliath -> 192.215.254.6/30


Minastir

eth0 -> Osgiliath -> 192.215.254.10/30
eth1 -> Elendil/Isildur switch -> 192.215.0.1/24
eth2 -> Durin -> 192.215.1.193/26


Moria

eth0 -> Osgiliath -> 192.215.254.2/30
eth1 -> Wilderland -> 192.215.254.21/30


Wilderland

eth0 -> Moria -> 192.215.254.22/30
eth1 -> Durin -> 192.215.1.193/26 ? (gateway Durin)
eth2 -> Khamul switch -> 192.215.2.33/29
```


Server
```
Narya (DNS) = 192.215.3.10/24 (gateway 192.215.3.1)

Vilya (DHCP) = 192.215.3.20/24 (gateway 192.215.3.1)

Palantir (Web) = 192.215.3.30/24

IronHills (Web) = 192.215.3.51/24
```

Sample clients
```
Elendil host example = 192.215.0.10/24, gw 192.215.0.1

Gilgalad client example = 192.215.1.10/25, gw 192.215.1.1

Isildur client example = 192.215.1.130/26, gw 192.215.1.129

Cirdan host example = 192.215.2.2/27, gw 192.215.2.1

Khamul host example = 192.215.2.34/29, gw 192.215.2.33
```

Routing Statis — Perintah yang dipasang di Osgiliath (router pusat)

jalankan sebagai root:
```
# default via NAT gateway (host side)
ip route replace default via 192.168.122.1

# routes to LANs via next-hop router IPs (next-hops are the peer IP on the /30 links)
ip route replace 192.215.3.0/24 via 192.215.254.6    # server network (via Rivendell)
ip route replace 192.215.0.0/24 via 192.215.254.10   # Elendil (via Minastir)
ip route replace 192.215.1.192/26 via 192.215.254.10 # Durin (via Minastir)
ip route replace 192.215.1.0/25 via 192.215.254.14   # Gilgalad (via Pelargir→ArduinBanks)
ip route replace 192.215.1.128/26 via 192.215.254.10 # Isildur (via Minastir)
ip route replace 192.215.2.0/27 via 192.215.254.18   # Cirdan (via ArduinBanks)
ip route replace 192.215.2.32/29 via 192.215.254.22  # Khamul (via Wilderland)
```

Untuk router lain, buat default route ke arah Osgiliath dan beberapa route spesifik jika perlu. 
```
Rivendell:

ip route replace default via 192.215.254.5

DHCP / DHCP Relay / DNS / Web — ringkasan & contoh
DHCP (Vilya) — /etc/dhcp/dhcpd.conf (potongan penting)
default-lease-time 600;
max-lease-time 7200;
authoritative;

# Elendil
subnet 192.215.0.0 netmask 255.255.255.0 {
  range 192.215.0.10 192.215.0.200;
  option routers 192.215.0.1;
  option domain-name-servers 192.215.3.10;
}

# Gilgalad (/25)
subnet 192.215.1.0 netmask 255.255.255.128 {
  range 192.215.1.10 192.215.1.100;
  option routers 192.215.1.1;
  option domain-name-servers 192.215.3.10;
}

# Isildur (/26)
subnet 192.215.1.128 netmask 255.255.255.192 {
  range 192.215.1.130 192.215.1.180;
  option routers 192.215.1.129;
  option domain-name-servers 192.215.3.10;
}

# Durin (/26)
subnet 192.215.1.192 netmask 255.255.255.192 {
  range 192.215.1.194 192.215.1.240;
  option routers 192.215.1.193;
  option domain-name-servers 192.215.3.10;
}

# Cirdan (/27)
subnet 192.215.2.0 netmask 255.255.255.224 {
  range 192.215.2.2 192.215.2.30;
  option routers 192.215.2.1;
  option domain-name-servers 192.215.3.10;
}

# Khamul (/29)
subnet 192.215.2.32 netmask 255.255.255.248 {
  range 192.215.2.34 192.215.2.38;
  option routers 192.215.2.33;
  option domain-name-servers 192.215.3.10;
}
```
```
DHCP Relay (contoh /etc/default/isc-dhcp-relay)
SERVERS="192.215.3.20"
INTERFACES="eth0 eth1 eth2"  # sesuaikan interface pada router relay
```

DNS (Narya — bind9)
```
Edit /etc/bind/named.conf.options untuk menambahkan forwarders (agar resolv ke internet):

options {
  directory "/var/cache/bind";
  recursion yes;
  allow-query { any; };
  forwarders { 8.8.8.8; 1.1.1.1; };
  listen-on { any; };
};
```

Web Server (Palantir / IronHills)
```
Install apache2 atau nginx lalu echo "Welcome" > /var/www/html/index.html
```
Test: ```curl http://192.215.3.30 (Palantir), curl http://192.215.3.51 (IronHills)```

Firewall & NAT (iptables)`

Semua rule dijalankan di node yang relevan.

```
1) Aktifkan IP forwarding
sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

2) SNAT (tidak menggunakan MASQUERADE) 
# pastikan eth0 adalah interface ke NAT (external)
iptables -t nat -A POSTROUTING -s 192.215.0.0/16 -o eth0 -j SNAT --to-source 192.168.122.186
# allow forwarding established
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 192.215.0.0/16 -j ACCEPT

3) Blokir ping ke Vilya (192.215.3.20) 
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A OUTPUT -p icmp -j ACCEPT

4) Hanya Vilya yang boleh akses Narya (DNS 192.215.3.10)
iptables -A INPUT -p tcp --dport 53 ! -s 192.215.3.20 -j DROP
iptables -A INPUT -p udp --dport 53 ! -s 192.215.3.20 -j DROP

5) IronHills — weekend access only (allow subnets on Sat & Sun) — jalankan di IronHills
iptables -F
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# allow only Sat,Sun from allowed subnets
iptables -A INPUT -s 192.215.1.192/26 -m time --weekdays Sat,Sun -j ACCEPT  # Durin
iptables -A INPUT -s 192.215.2.32/29 -m time --weekdays Sat,Sun -j ACCEPT   # Khamul
iptables -A INPUT -s 192.215.0.0/24 -m time --weekdays Sat,Sun -j ACCEPT    # Elendil & Isildur
iptables -A INPUT -s 192.215.1.128/26 -m time --weekdays Sat,Sun -j ACCEPT  # Isildur
iptables -A INPUT -j REJECT

6) Palantir — time based + portscan detection — jalankan di Palantir
# time-based access
iptables -F
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Elf (07:00-15:00)
iptables -A INPUT -s 192.215.1.0/25 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT
iptables -A INPUT -s 192.215.2.0/27 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT

# Human (17:00-23:00)
iptables -A INPUT -s 192.215.0.0/24 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT
iptables -A INPUT -s 192.215.1.128/26 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT

# portscan detection (>15 SYN in 20s)
iptables -N PORTSCAN
iptables -A INPUT -p tcp --syn -m recent --name portscan --update --seconds 20 --hitcount 15 -j LOG --log-prefix "PORT_SCAN_DETECTED "
iptables -A INPUT -p tcp --syn -m recent --name portscan --update --seconds 20 --hitcount 15 -j DROP
iptables -A INPUT -p tcp --syn -m recent --name portscan --set -j ACCEPT
iptables -A INPUT -m recent --name portscan --rcheck --seconds 120 -j DROP

iptables -A INPUT -j DROP

7) Limit concurrent connections to IronHills (max 3 per IP) — jalankan di IronHills
iptables -A INPUT -p tcp --dport 80 --syn -m connlimit --connlimit-above 3 --connlimit-mask 32 -j DROP

8) DNAT: redirect traffic dari Vilya → Khamul ke IronHills — jalankan di Osgiliath
iptables -t nat -A PREROUTING -s 192.215.3.20 -d 192.215.2.32/29 -j DNAT --to-destination 192.215.3.51
iptables -A FORWARD -d 192.215.3.51 -j ACCEPT

9) Isolasi total Khamul (Misi 3) — jalankan di Wilderland (gateway Khamul) dan/atau Osgiliath
# block forwarding to/from Khamul
iptables -A FORWARD -s 192.215.2.32/29 -j DROP
iptables -A FORWARD -d 192.215.2.32/29 -j DROP
```
