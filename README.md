# Xiaomi Sales Tracker — Jodi Edition

Aplikasi web mobile-first untuk promotor Xiaomi Jodi di Erafone Summarecon Mall Bandung.

## Isi paket
- `index.html` — aplikasi HTML/CSS/JavaScript.
- `schema.sql` — tabel cloud Supabase dan Row Level Security.
- `manifest.webmanifest` — metadata PWA.
- `sw.js` — cache aplikasi dasar untuk akses offline setelah kunjungan online pertama.

## Menjalankan lokal
Untuk menguji fitur IndexedDB, jalankan melalui server lokal (bukan `file://`):
```bash
python -m http.server 8080
```
Buka `http://localhost:8080`. Untuk pemasangan PWA di Android, deploy folder ini ke hosting HTTPS (misalnya Cloudflare Pages, Netlify, atau hosting HTTPS lain), lalu pilih Add to Home Screen.

## Mengaktifkan cloud (Supabase)
1. Buat project di https://supabase.com/.
2. Buka SQL Editor dan jalankan seluruh isi `schema.sql`.
3. Buka Project Settings > API, salin Project URL dan anon/publishable key.
4. Di aplikasi buka Laporan > Cloud & akun. Masukkan URL dan key.
5. Daftar dengan email/password, verifikasi email bila diminta, lalu login.
6. Untuk sinkronisasi, masukkan password akun cloud (minimal 8 karakter) lalu tekan Sinkronkan sekarang.

**Penting:** Jangan pernah memasukkan `service_role` key ke aplikasi browser. Gunakan hanya anon/publishable key. Payload backup cloud dienkripsi AES-GCM di browser menggunakan kunci turunan PBKDF2 dari password cloud; server menyimpan ciphertext. Jika password cloud hilang, payload cloud tidak dapat didekripsi. Simpan password dan backup JSON secara aman.

## Batasan sinkronisasi versi ini
Sinkronisasi saat ini adalah **backup cloud terenkripsi satu-vault** (snapshot), bukan kolaborasi multi-user atau merge konflik otomatis. Menekan sinkronisasi akan mengganti snapshot cloud dengan data lokal saat ini. Untuk memulihkan, versi awal ini belum menyediakan tombol unduh/dekripsi snapshot cloud; gunakan backup JSON lokal sebagai jalur pemulihan. Hindari memakai dua perangkat bergantian sebelum rancangan merge/sync dua arah ditambahkan.

## Penyimpanan dan keamanan
- Transaksi lokal disimpan menggunakan IndexedDB.
- Scan OCR foto diproses di browser; foto tidak diunggah oleh fitur OCR.
- Data lokal dapat hilang jika data browser dihapus, perangkat hilang/rusak, atau browser dibersihkan. Lakukan backup JSON berkala.
- Cloud memerlukan koneksi internet dan konfigurasi Supabase.
- Data IMEI/serial number sensitif. Batasi akses perangkat, gunakan PIN perangkat, jangan bagikan backup tanpa perlindungan.
- PIN aplikasi di versi ini disimpan sebagai hash, tetapi **belum menjadi layar pengunci penuh**. Gunakan kunci layar Android untuk proteksi perangkat.
- Library OCR dimuat dari CDN sehingga pemindaian OCR memerlukan koneksi internet dan browser dapat mengakses CDN. Bila CDN tidak tersedia, input IMEI manual masih bisa digunakan.
- Harga jual disimpan sebagai nilai transaksi; diskon disimpan terpisah dan tidak otomatis mengurangi harga jual. Masukkan harga jual bersih sesuai invoice untuk laporan omzet bersih yang akurat.
- Satu baris penjualan mewakili satu unit. Untuk multi-unit, input satu baris per IMEI.

## Pengujian persistensi manual
1. Tambahkan transaksi uji dengan IMEI uji (jangan gunakan IMEI pelanggan).
2. Pastikan transaksi tampil di Dashboard dan History.
3. Tutup tab/browser, buka ulang URL yang sama.
4. Pastikan transaksi masih tampil.
5. Ekspor Backup JSON, lalu uji restore di browser uji.
6. Untuk cloud, siapkan project Supabase dan lakukan login + sinkronisasi. Periksa bahwa baris `jodi_sales_vault` ada; kolom payload berisi ciphertext, bukan data IMEI terbaca.
7. Uji RLS dengan akun lain; akun lain tidak boleh membaca vault milik pengguna.

## Status validasi
Paket ini menyediakan mekanisme pengujian manual. Belum ada klaim bahwa aplikasi telah diuji pada perangkat atau project Supabase milik pengguna. Uji di lingkungan target sebelum memasukkan data penjualan nyata.
Pemeriksaan publikasi Xiaomi Sales Tracker Jodi.
