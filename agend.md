# agend.md — Agenda & Status Pekerjaan

Dokumen ini menjawab: "apa yang sudah selesai, apa yang belum, dan apa
langkah berikutnya". Perbarui setiap kali ada pekerjaan yang selesai.

## 1. Peta ketentuan soal → implementasi

| # | Ketentuan | Status | Lokasi |
| --- | --- | --- | --- |
| 1 | `MenuCard` (nama, harga, tersedia) dengan **satu** `BoxDecoration`: `LinearGradient`, `borderRadius` 20, border, `boxShadow`; ikon di dalam lingkaran `BoxShape.circle` | Selesai | `lib/widget/menu_card.dart` (`_dekorasiKartu`, `MenuCard`), `lib/widget/menu_artwork.dart` (`MenuArtwork.kecil`) |
| 2 | Tekan lama mengubah `tersedia`; menu habis menjadi transparan **0.4** halus (`AnimatedOpacity`, **400 ms**) + label **"Habis"** | Selesai | `lib/widget/menu_card.dart` (`AnimatedOpacity`, `kMenuCardDurasiOpacity`, overlay `MenuStatusBadge`), `lib/page/katalog_page.dart` (`_ubahKetersediaan`) |
| 3 | 10 menu di `KatalogPage` lewat `ListView.builder`; kartu tersedia **tidak** dibungkus `Opacity` | Selesai | `lib/page/katalog_page.dart`, `lib/model/menu_item.dart` (`kDaftarMenuAwal`) |
| 4 | Tekan kartu → `DetailPage`; lingkaran ikon berubah bertahap menjadi **persegi besar** (`Hero`, `ClipRRect` radius terinterpolasi, `createRectTween` melengkung, **600 ms**) | Selesai | `lib/widget/menu_hero.dart`, `lib/page/detail_page.dart` (`DetailPage.route`), `lib/widget/menu_card.dart` (`Hero`) |
| 5 | Header `KatalogPage`: ikon cangkir berputar 0–2π (`AnimationController`, `Transform.rotate`, `AnimatedBuilder` + `child` + `RepaintBoundary`, `dispose()`) | Selesai | `lib/widget/spinning_cup_icon.dart`, dipakai `lib/widget/katalog_header.dart` |
| 6 | `const` pada widget yang memungkinkan | Selesai | semua file di `lib/` |
| 7 | Ukur performa dengan DevTools (profile mode) + jelaskan sebelum/sesudah | **Belum diukur** | `laporan_performa.md` |

### Catatan pemenuhan #2 & #3 (dibahas agar tidak dianggap bug)

- Tidak ada widget `Opacity` di seluruh proyek. Yang dipakai hanya
  `AnimatedOpacity`, dan pada kartu tersedia nilainya `1.0` (tampil penuh,
  tidak diredupkan). Ini satu-satunya cara agar fade 400 ms benar-benar
  berjalan dua arah.
- Label "Habis" diletakkan di luar area fade supaya tetap terbaca saat kartu
  berada di 0.4.

## 2. Agenda berikutnya (urut prioritas)

- [ ] **P1 — Ukur performa (#7).** Ikuti langkah di `laporan_performa.md`,
      isi tabel "sebelum" dan "sesudah", lalu tulis kesimpulan di bagian 4
      dokumen tersebut.
- [ ] **P1 — Verifikasi kompilasi.** `flutter analyze` harus bersih
      (sesi ini tidak bisa menjalankan terminal).
- [ ] **P2 — Uji manual alur utama:**
  1. Tekan lama kartu #1 → kartu memudar halus ±0.4 s + muncul "Habis".
  2. Tekan lama lagi → kartu kembali penuh + label hilang.
  3. Ketuk kartu → Hero 600 ms, ikon membulat → persegi 220 px di detail.
  4. Tombol kembali → Hero berbalik ke lingkaran.
  5. Header: cangkir berputar terus tanpa patah-patah.
- [ ] **P3 (opsional) — Tambah `test/widget_test.dart`**: verifikasi 10 kartu
      tampil, label "Habis" muncul setelah `longPress`, dan `DetailPage`
      terbuka setelah `tap`.
- [ ] **P4 (opsional) — Persistensi status** (mis. `shared_preferences`) bila
      status ketersediaan perlu bertahan setelah aplikasi ditutup. Sekarang
      status kembali ke data awal setiap aplikasi dijalankan.
- [ ] **P5 (opsional) — Golden/screenshot test** untuk memastikan dekorasi
      kartu tidak berubah tanpa sengaja.

## 3. Rencana verifikasi (tanpa terminal di sesi ini)

Host sesi ini tidak punya `bash`, jadi semua perintah di bawah **belum
dijalankan** dan harus dijalankan pengguna:

```bash
flutter pub get
flutter analyze
flutter run            # debug, cek fungsi
flutter run --profile  # untuk pengukuran DevTools
```

Kriteria lulus:

- `flutter analyze` → `No issues found!`
- Tidak ada overflow saat katalog dibuka dan di-scroll.
- Hero berjalan ±0.6 detik dan tidak "melompat" bentuk di akhir animasi.

## 4. Batasan yang disepakati

- Tanpa dependency baru (tanpa provider/riverpod/bloc/intl).
- State hanya di `_KatalogPageState` (satu sumber kebenaran, `setState`).
- Semua komentar kode berbahasa Indonesia.
