# skill.md — Teknik & Konvensi Proyek

Kumpulan pola yang **sudah terbukti dipakai** di proyek ini. Saat menambah
fitur, tiru pola di sini supaya kode tetap konsisten.

## 1. Konvensi wajib

- Import UI: `import 'package:material_ui/material_ui.dart';`
  (Flutter 3.50+ memisahkan Material dari SDK; `flutter/material.dart` tidak
  dipakai).
- Komentar: bahasa Indonesia, berupa banner `// FILE / PERAN / KETENTUAN SOAL`
  di atas file dan doc comment `///` pada setiap kelas serta field penting.
- Urutan parameter widget: `{super.key, ...required, ...opsional}`; properti
  `child` diletakkan terakhir.
- Warna memakai `Color`/`ColorScheme` dari tema; transparansi memakai
  `withValues(alpha: ...)` (bukan `withOpacity` yang deprecated).
- Widget di `lib/widget` **tidak boleh** menyimpan state bisnis atau mengimpor
  halaman. Data masuk lewat parameter, aksi keluar lewat callback
  (`onTap`, `onLongPress`).

## 2. Resep: kartu dengan fade bersyarat yang halus

```dart
AnimatedOpacity(
  opacity: tersedia ? 1.0 : 0.4,   // 1.0 = tampil penuh, tanpa Opacity
  duration: const Duration(milliseconds: 400),
  curve: Curves.easeOut,
  child: kartu,
)
```

Aturan: **selalu** pasang `AnimatedOpacity` di tree (jangan bersyarat), karena
widget yang baru dibuat langsung memakai nilai akhir dan animasinya hilang.
Label status diletakkan di `Stack` **di luar** area fade bila harus tetap
terbaca.

## 3. Resep: Hero dengan radius yang berubah bertahap

1. Sumber & tujuan memakai satu widget media yang sama
   (`MenuArtwork.kecil` / `.besar`) agar isinya serupa saat terbang.
2. `createRectTween: (a, b) => MaterialRectArcTween(begin: a, end: b)`
   → lintasan melengkung.
3. `flightShuttleBuilder` mengembalikan widget yang **punya
   `AnimatedBuilder` sendiri**; framework membangun shuttle sekali per
   penerbangan, jadi interpolasi radius harus dekat dengan `animation.value`.
4. Durasi diatur di route: `PageRouteBuilder(transitionDuration: 600ms)`.
   `MaterialPageRoute` selalu 300 ms dan tidak bisa diubah durasinya.
5. Tag harus identik: gunakan satu fungsi `menuHeroTag(id)`.

## 4. Resep: animasi berulang yang hemat build/repaint

```dart
AnimatedBuilder(
  animation: _controller,
  child: RepaintBoundary(child: Icon(...)), // dibuat sekali
  builder: (context, child) => Transform.rotate(
    angle: _controller.value * 2 * pi,
    child: child,
  ),
)
```

Selalu `dispose()` controller. `child` mencegah subtree ikon ikut di-build ulang
tiap frame; `RepaintBoundary` memisahkan layer repaint-nya.

## 5. Resep: `BoxDecoration` aman

- Satu dekorasi boleh berisi: `gradient`, `borderRadius`, `border`,
  `boxShadow` sekaligus.
- `shape: BoxShape.circle` **tidak boleh** bersama `borderRadius`.
- `Border.all` tidak `const`; pakai
  `Border.fromBorderSide(const BorderSide(...))` bila perlu dekorasi `const`.
- Agar ripple `InkWell` mengikuti sudut membulat: `Container(clipBehavior:
  Clip.antiAlias, decoration: ...)` lalu `Material(type:
  MaterialType.transparency, child: InkWell(...))`.

## 6. Resep: ListView hemat layout

- Tinggi item tetap → set `itemExtent` (mis. `kMenuCardTinggi + kMenuCardJarak`).
- Jangan menaruh `padding` vertikal di luar hitungan `itemExtent`; masukkan ke
  dalam item atau kurangi tingginya.

## 7. Alur kerja verifikasi

```bash
flutter analyze                              # wajib bersih
flutter run                                  # uji interaksi
flutter run --profile                        # ukur dengan DevTools
```

Mesin sesi tertentu mungkin tidak punya `bash`; bila begitu, jangan mengklaim
kode "sudah teruji". Catat di `memory.md` bagian "Status verifikasi" dan minta
pengguna menjalankan perintah di atas.

## 8. Peta cepat "mau ubah X, sentuh file Y"

| Ingin mengubah | File |
| --- | --- |
| Data menu / harga / ikon | `lib/model/menu_item.dart` |
| Warna gradasi & ukuran ikon | `lib/widget/menu_artwork.dart` (`kGradienIkon`, `kIkonKecil`, `kIkonBesar`) |
| Dekorasi kartu / durasi fade | `lib/widget/menu_card.dart` |
| Perilaku Hero | `lib/widget/menu_hero.dart`, `lib/page/detail_page.dart` |
| Kecepatan putaran cangkir | `lib/widget/spinning_cup_icon.dart` (`durasiPutaran`) |
| Teks header | `lib/widget/katalog_header.dart` |
| Tema & halaman awal | `lib/main.dart` |
