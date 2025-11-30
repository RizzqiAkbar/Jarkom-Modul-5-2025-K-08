# Jarkom-Modul-5-2025-K-08

Anggota : 
|Nama|NRP|
|---|---|
|Rizqi Akbar Sukirman Putra|5027241044|
|Adinda Cahya Pramesti|5027241117|

# Topologi GNS3
<img width="1230" height="761" alt="Screenshot 2025-11-30 191517" src="https://github.com/user-attachments/assets/cac12195-8b94-4454-8933-cb5511e12247" />

# Subnet Topologi

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
