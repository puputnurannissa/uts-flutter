# memory.md — Memori Proyek

Dokumen ini adalah "ingatan" proyek. Baca file ini paling awal di sesi
berikutnya, sebelum menyentuh kode.

## 1. Ringkasan proyek

- Nama paket: `praktik_pembuatan_object_widget_flutter`
- Tujuan: praktik Flutter tentang **BoxDecoration, AnimatedOpacity, Hero
  (radial), dan performa (const/RepaintBoundary)**.
- Dua halaman: `KatalogPage` (daftar 10 menu) dan `DetailPage` (detail menu).
- Semua kode dan komentar ditulis dalam Bahasa Indonesia.

## 2. Lingkungan (terverifikasi dari `pubspec.lock` & `.dart_tool/package_config.json`)

| Komponen | Versi |
| --- | --- |
| Flutter | 3.50.0 (`flutterVersion` di package_config) |
| Dart SDK | 3.14 (`environment.sdk: ^3.14.0`) |
| Material | paket `material_ui` **1.11.1** (bukan `package:flutter/material.dart`) |
| Cupertino | `cupertino_ui` 1.1.7 (transitif) |
| Lints | `flutter_lints` 6.0.0 |
| Platform tersedia | android, web |

### Aturan import (PENTING)

Sejak Flutter 3.50, Material dipisah dari SDK menjadi paket `material_ui`.
**Selalu** pakai:

```dart
import 'package:material_ui/material_ui.dart';
```

Jangan menulis `import 'package:flutter/material.dart'`. Dependensi baru tidak
diperlukan untuk proyek ini (tanpa provider/riverpod/intl).

## 3. Struktur file dan tanggung jawab

```
lib/
├─ main.dart                      # composition root: MaterialApp + tema + home
├─ model/
│  └─ menu_item.dart              # domain: MenuItem, formatRupiah, kDaftarMenuAwal
├─ page/
│  ├─ katalog_page.dart           # halaman #1: pemilik state daftar menu
│  └─ detail_page.dart            # halaman #2: tujuan Hero + route 600 ms
└─ widget/
   ├─ katalog_header.dart         # header katalog (memakai SpinningCupIcon)
   ├─ menu_artwork.dart           # lingkaran 56px & persegi 220px (media ikon)
   ├─ menu_card.dart              # kartu: BoxDecoration + AnimatedOpacity
   ├─ menu_hero.dart              # tag Hero + arc tween + flight shuttle
   ├─ menu_status_badge.dart      # label "Tersedia"/"Habis"
   └─ spinning_cup_icon.dart      # radial berputar (AnimationController)
```

Arah ketergantungan: `page` → `widget` → `model`. Tidak ada `widget` yang
mengimpor `page`, dan `model` tidak mengimpor lapisan lain. Folder `model/`
ditambahkan agar halaman dan widget tidak perlu mendefinisikan data menu di
dalam kode UI.

## 4. Keputusan desain (dan alasannya)

1. **AnimatedOpacity selalu ada di tree, nilainya 1.0 saat tersedia.**
   Ketentuan #2 (transisi halus 400 ms) dan #3 (kartu tersedia tidak dibungkus
   `Opacity`) sama-sama terpenuhi: tidak ada widget `Opacity` di proyek, dan
   kartu tersedia tampil penuh (opacity 1.0). Kalau pembungkusnya dipasang
   bersyarat (`tersedia ? kartu : AnimatedOpacity(...)`), animasinya hilang
   karena widget baru langsung lahir dengan nilai akhirnya.
2. **Label "Habis" berada di luar area yang memudar.**
   Ditempatkan sebagai overlay `Stack` + `IgnorePointer` supaya tetap tajam
   saat kartu turun ke opacity 0.4, dan tidak menghalangi tap.
3. **`shape: BoxShape.circle` hanya di varian kecil.**
   `BoxDecoration` tidak boleh berisi `shape: circle` dan `borderRadius`
   sekaligus; varian besar memakai `borderRadius` 16.
4. **Hero memakai `PageRouteBuilder` 600 ms**, bukan `MaterialPageRoute`
   (durasinya tetap 300 ms). Hero mengikuti durasi transisi route.
5. **Radius saat terbang diinterpolasi di `MenuHeroShuttle`.** Framework hanya
   membangun shuttle sekali per penerbangan, sehingga interpolasi radius harus
   lewat `AnimatedBuilder` di dalam shuttle.
6. **`itemExtent` pada ListView.builder** agar tinggi item diketahui tanpa
   diukur ulang (kartu memang tinggi tetap 104 + jarak 12).
7. **Format rupiah manual**, tanpa `intl`, untuk menghindari dependency baru.

## 5. Status verifikasi

- Host sesi ini **tidak memiliki `bash`**, sehingga `flutter analyze`,
  `flutter test`, `flutter run`, dan DevTools **tidak dapat dijalankan**.
  Kode ditulis manual dan diperiksa dengan pembacaan ulang file.
- Yang belum dijalankan (harus dicek pengguna di mesin Flutter-nya):
  `flutter analyze`, `flutter run --profile`, dan pengukuran performa
  (lihat `laporan_performa.md`).
- Tidak ada folder `test/` di proyek, jadi tidak ada widget test.

## 6. Jebakan yang sudah diketahui

- Jangan menambahkan `shape` + `borderRadius` pada satu `BoxDecoration`.
- `Border.all` bukan konstruktor `const`; gunakan
  `Border.fromBorderSide(const BorderSide(...))` bila dekorasi dibuat `const`.
- Jangan memakai `withOpacity` (deprecated) — pakai `withValues(alpha: ...)`.
- Tag Hero harus unik per menu: `menuHeroTag(id)`.
- Setelah mengubah daftar menu, panggil `setState`; widget tidak menyimpan
  state sendiri.

## 7. Cara melanjutkan sesi

1. Baca `memory.md` → `agend.md` (status tugas) → `skill.md` (pola teknis).
2. Jalankan `flutter analyze` sebelum mengubah apa pun; catat baseline.
3. Setelah perubahan, jalankan ulang `flutter analyze` + uji manual:
   tekan lama 1 kartu, tekan kartu, amati Hero 600 ms, kembali.
