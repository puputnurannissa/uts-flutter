# laporan_performa.md — Laporan Performa (Ketentuan #7)

## 0. Status pengukuran

> **Belum diukur.** Host sesi ini tidak memiliki `bash`, sehingga
> `flutter run --profile` dan DevTools tidak bisa dijalankan. Dokumen ini berisi
> metode pengukuran yang siap dipakai, tabel kosong untuk diisi, dan penjelasan
> **apa yang berubah** antara versi sebelum dan sesudah optimasi. Angka pada
> tabel **harus** diisi dari hasil pengukuran nyata — jangan diisi perkiraan.

## 1. Metrik yang dipakai

| Metrik | Arti | Ambang sehat (60 fps) |
| --- | --- | --- |
| UI (build) time | waktu menyusun widget per frame | < 8 ms |
| Raster time | waktu GPU menggambar per frame | < 8 ms |
| Frame total | build + raster | ≤ 16,7 ms |
| Jank / frame lambat | frame > 16,7 ms | 0 idealnya |
| Frame terburuk (99th) | frame paling lambat saat skenario | ≤ 16,7 ms |

## 2. Cara mengukur (langkah pasti)

1. Hubungkan perangkat/emulator, lalu jalankan aplikasi dalam **profile mode**
   (bukan debug — angka debug bisa 2–5× lebih lambat karena tidak ada AOT):

   ```bash
   flutter run --profile
   ```

2. Buka **DevTools → Performance** (atau `flutter run --profile
   --profile-memory` bila ingin memantau memori).
3. Nyalakan **Record**, lalu lakukan skenario berikut, masing-masing 10 detik:
   - **S1** — scroll katalog dari atas ke bawah dan kembali.
   - **S2** — tekan lama satu kartu (fade 400 ms) lalu tekan lama lagi.
   - **S3** — ketuk kartu untuk membuka detail (Hero 600 ms), lalu kembali.
4. Hentikan Record. Baca panel **Frame Chart** dan **Frame Analysis**:
   catat rata-rata *UI*, rata-rata *Raster*, jumlah frame jank, dan frame
   terburuk.
5. Ulangi 3× per skenario, pakai nilai median agar stabil.

## 3. Skenario "sebelum" vs "sesudah"

"Sebelum" = versi naif yang setara fungsi tetapi tanpa optimasi:

| Aspek | Sebelum (naif) | Sesudah (kode sekarang) |
| --- | --- | --- |
| Fade kartu | `Opacity(0.4)` statis membungkus **semua** kartu (tanpa animasi) | `AnimatedOpacity` 400 ms, nilai 1.0 untuk kartu tersedia |
| Ikon berputar | `Icon` dibuat ulang di dalam `builder` tiap frame | `child:` + `RepaintBoundary` → subtree ikon dibuat sekali |
| Dekorasi & widget | `BoxDecoration`, `TextStyle`, `Padding` dibuat ulang tiap build | `const` / konstanta level atas (`_dekorasiKartu`, `kGradienIkon`) |
| Layout daftar | `ListView.builder` tanpa `itemExtent` (tinggi item diukur tiap layout) | `itemExtent` tetap (104 + 12) |

## 4. Hasil pengukuran (isi setelah diukur)

Perangkat: ______________________ · Mode: profile · Tanggal: ____________

| Metrik | Sebelum (S1 scroll) | Sesudah (S1 scroll) | Sebelum (S3 Hero) | Sesudah (S3 Hero) |
| --- | --- | --- | --- | --- |
| Rata-rata UI time (ms) | | | | |
| Rata-rata raster time (ms) | | | | |
| Frame jank (> 16,7 ms) | | | | |
| Frame terburuk (ms) | | | | |

## 5. Penjelasan singkat (isi setelah tabel terisi)

Tulis 3–5 kalimat dengan pola:

1. **Perubahan yang paling berpengaruh** — bandingkan angka S1 sebelum/sesudah
   dan kaitkan dengan penyebabnya (mis. "waktu build turun karena X").
2. **Skenario Hero** — Hero memang menambah beban sementara selama 600 ms
   (dua subtree + shuttle digambar), tetapi hanya 1 frame berat per transisi;
   jelaskan apakah jank muncul di awal transisi atau tidak.
3. **Animasi berulang** — tunjukkan bahwa putaran cangkir menghasilkan raster
   time rendah karena `RepaintBoundary` membatasi area repaint.
4. **Kesimpulan** — apakah semua frame ≤ 16,7 ms pada perangkat uji.

### Hipotesis yang perlu dibuktikan (bukan hasil ukur)

- `const` menurunkan *UI time* karena objek dekorasi/teks tidak dialokasikan
  ulang setiap frame scroll.
- `child` + `RepaintBoundary` menurunkan *raster time* pada header karena
  hanya layer `Transform` yang berubah, bukan seluruh subtree ikon.
- `itemExtent` menstabilkan *UI time* saat scroll karena framework tidak perlu
  mengukur tinggi tiap item.
- Membungkus semua kartu dengan `Opacity` statis (versi "sebelum") memaksa
  setiap kartu punya compositing layer tambahan → raster time naik dan memori
  GPU bertambah; ini alasan ketentuan #3 melarangnya.

## 6. Keterbatasan pengukuran

- Angka dari emulator berbeda dari perangkat fisik; sebutkan perangkatnya.
- Pengukuran wajib mode profile. Mode debug menghasilkan angka yang tidak
  mewakili performa rilis.
- Bila DevTools tidak bisa membuka jendela (host tanpa browser), gunakan
  `flutter run --profile` lalu tekan tombol "open DevTools" pada terminal, atau
  `dart devtools --machine`.
