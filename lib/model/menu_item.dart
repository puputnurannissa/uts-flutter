// ---------------------------------------------------------------------------
// FILE   : lib/model/menu_item.dart
// PERAN  : Lapisan domain / data (clean architecture).
//          Berisi "bentuk" data menu + data awal 10 menu + helper format harga.
//          File ini TIDAK tahu apa-apa soal UI (tidak ada widget di sini),
//          sehingga halaman (lib/page) dan widget (lib/widget) bisa memakainya
//          tanpa saling bergantung.
// ---------------------------------------------------------------------------

import 'package:material_ui/material_ui.dart';

/// Model data satu menu kafe.
///
/// Objek ini sengaja dibuat immutable (semua field `final`). Untuk mengubah
/// status ketersediaan, gunakan [copyWith] sehingga objek lama tidak termutasi
/// di tempat — pola ini aman untuk `setState` dan mudah dilacak.
class MenuItem {
  const MenuItem({
    required this.id,
    required this.nama,
    required this.harga,
    required this.ikon,
    this.tersedia = true,
    this.deskripsi = '',
  });

  /// Identitas unik menu; dipakai sebagai dasar `HeroTag` (lihat menu_hero.dart).
  final String id;

  /// Nama menu yang ditampilkan pada kartu dan halaman detail.
  final String nama;

  /// Harga dalam rupiah (bilangan bulat, tanpa desimal).
  final int harga;

  /// Ikon yang mewakili menu. Disimpan di model agar widget tidak perlu
  /// memetakan nama menu ke ikon secara manual.
  final IconData ikon;

  /// `true` = menu tersedia, `false` = menu habis.
  /// Ditekan lama pada kartu katalog untuk mengubah nilai ini.
  final bool tersedia;

  /// Deskripsi singkat yang hanya ditampilkan pada DetailPage.
  final String deskripsi;

  /// Harga yang sudah diformat, contoh: `Rp 18.000`.
  String get hargaRupiah => formatRupiah(harga);

  /// Menyalin objek dengan sebagian field diganti.
  ///
  /// Hanya [tersedia] yang bisa diganti karena itulah satu-satunya field yang
  /// berubah selama aplikasi berjalan (lewat tekan lama pada kartu).
  MenuItem copyWith({bool? tersedia}) {
    return MenuItem(
      id: id,
      nama: nama,
      harga: harga,
      ikon: ikon,
      tersedia: tersedia ?? this.tersedia,
      deskripsi: deskripsi,
    );
  }
}

/// Memformat angka menjadi rupiah dengan pemisah ribuan titik.
///
/// Contoh: `18000` -> `Rp 18.000`.
/// Dibuat manual (tanpa package `intl`) supaya tidak menambah dependency hanya
/// untuk satu kebutuhan tampilan.
String formatRupiah(int nominal) {
  final angka = nominal.toString();
  final buffer = StringBuffer();

  for (var i = 0; i < angka.length; i++) {
    // Sisipkan titik setiap 3 digit dari kanan, kecuali di awal angka.
    if (i > 0 && (angka.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(angka[i]);
  }

  return 'Rp $buffer';
}

/// Data awal katalog: 10 menu sesuai ketentuan soal.
///
/// Dua menu sengaja dimulai dengan status habis supaya efek
/// AnimatedOpacity + label "Habis" langsung terlihat saat aplikasi dibuka.
const List<MenuItem> kDaftarMenuAwal = <MenuItem>[
  MenuItem(
    id: 'm1',
    nama: 'Es Kopi Susu Gula Aren',
    harga: 18000,
    ikon: Icons.local_cafe,
    deskripsi:
        'Espresso robusta dengan susu segar dan gula aren cair. Menu paling '
        'laris di jam sibuk.',
  ),
  MenuItem(
    id: 'm2',
    nama: 'Kopi Tubruk Klasik',
    harga: 12000,
    ikon: Icons.emoji_food_beverage,
    deskripsi:
        'Biji kopi lokal diseduh langsung di cangkir, disajikan bersama gula '
        'batu sesuai selera.',
  ),
  MenuItem(
    id: 'm3',
    nama: 'Cappuccino',
    harga: 25000,
    ikon: Icons.local_cafe,
    deskripsi:
        'Perpaduan espresso, susu steam, dan busa susu tebal dengan taburan '
        'bubuk kayu manis.',
  ),
  MenuItem(
    id: 'm4',
    nama: 'Caramel Latte',
    harga: 28000,
    ikon: Icons.local_drink,
    deskripsi:
        'Latte lembut dengan saus karamel buatan sendiri dan sedikit garam '
        'laut di permukaan.',
  ),
  MenuItem(
    id: 'm5',
    nama: 'Matcha Latte',
    harga: 26000,
    ikon: Icons.local_drink,
    deskripsi:
        'Matcha grade upacara dari Uji dikocok dengan susu oat, tanpa pemanis '
        'tambahan.',
  ),
  MenuItem(
    id: 'm6',
    nama: 'Croissant Butter',
    harga: 22000,
    ikon: Icons.bakery_dining,
    deskripsi:
        'Pastri 27 lapis dengan mentega Prancis, dipanggang ulang setiap pagi '
        'agar renyah.',
  ),
  MenuItem(
    id: 'm7',
    nama: 'Roti Bakar Srikaya',
    harga: 15000,
    ikon: Icons.breakfast_dining,
    tersedia: false,
    deskripsi:
        'Roti gandum panggang dengan selai srikaya pandan rumah dan mentega '
        'asin.',
  ),
  MenuItem(
    id: 'm8',
    nama: 'Cheesecake Potong',
    harga: 30000,
    ikon: Icons.cake,
    deskripsi:
        'Cheesecake baked dengan krim keju impor dan dasar biskuit renyah, '
        'disajikan dingin.',
  ),
  MenuItem(
    id: 'm9',
    nama: 'Es Teh Lemon',
    harga: 14000,
    ikon: Icons.local_drink,
    tersedia: false,
    deskripsi:
        'Teh hitam seduh dingin dengan perasan lemon segar dan sirup gula '
        'rendah kalori.',
  ),
  MenuItem(
    id: 'm10',
    nama: 'Es Krim Vanila',
    harga: 20000,
    ikon: Icons.icecream,
    deskripsi:
        'Satu scoop es krim vanila Bourbon dengan topping keping cokelat '
        'hitam.',
  ),
];
