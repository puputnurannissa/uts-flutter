// ---------------------------------------------------------------------------
// FILE   : lib/page/katalog_page.dart
// PERAN  : Halaman pertama aplikasi (halaman besar #1).
//          Satu-satunya tempat yang memiliki state daftar menu; semua widget
//          di lib/widget tetap presentasional dan menerima data + callback.
// ALUR   :
//          1. Ambil 10 menu dari data awal (lib/model/menu_item.dart).
//          2. Tampilkan lewat ListView.builder (ketentuan #3).
//          3. Tekan lama kartu -> setState mengubah `tersedia` (ketentuan #2).
//          4. Tekan kartu -> buka DetailPage dengan transisi Hero 600 ms (#4).
// ---------------------------------------------------------------------------

import 'package:material_ui/material_ui.dart';

import '../model/menu_item.dart';
import '../widget/katalog_header.dart';
import '../widget/menu_card.dart';
import '../widget/menu_hero.dart';
import 'detail_page.dart';

/// Halaman katalog menu.
///
/// Stateful karena status ketersediaan menu bisa berubah saat aplikasi
/// berjalan (ditekan lama). Tidak ada state management eksternal supaya
/// alur data tetap mudah dipelajari: satu sumber kebenaran, satu `setState`.
class KatalogPage extends StatefulWidget {
  const KatalogPage({super.key});

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  /// Sumber kebenaran daftar menu.
  ///
  /// Disalin dari konstanta awal agar data asli tidak ikut berubah dan daftar
  /// bisa dimutasi (elemen diganti) di dalam `setState`.
  late final List<MenuItem> _daftarMenu = List<MenuItem>.of(kDaftarMenuAwal);

  /// Membalik status ketersediaan satu menu (dipanggil dari tekan lama).
  void _ubahKetersediaan(int index) {
    final menu = _daftarMenu[index];

    setState(() {
      // `copyWith` membuat objek baru -> perubahan mudah dilacak.
      _daftarMenu[index] = menu.copyWith(tersedia: !menu.tersedia);
    });
  }

  /// Membuka DetailPage dengan transisi Hero berdurasi 600 ms.
  void _bukaDetail(MenuItem menu) {
    Navigator.of(context).push<void>(DetailPage.route(menu: menu));
  }

  @override
  Widget build(BuildContext context) {
    // Dihitung setiap build; hanya angka ringkasan yang bergantung pada state.
    final jumlahHabis =
        _daftarMenu.where((MenuItem menu) => !menu.tersedia).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2ED),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Header: judul + radial berputar (ketentuan #5).
            KatalogHeader(
              totalMenu: _daftarMenu.length,
              menuHabis: jumlahHabis,
            ),
            Expanded(
              // ListView.builder hanya membangun item yang terlihat.
              // `itemExtent` membuat tinggi tiap item sudah diketahui framework,
              // sehingga scrollbar & posisi scroll dihitung tanpa mengukur isi.
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: _daftarMenu.length,
                itemExtent: kMenuCardTinggi + kMenuCardJarak,
                itemBuilder: (BuildContext context, int index) {
                  final menu = _daftarMenu[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: kMenuCardJarak),
                    child: MenuCard(
                      nama: menu.nama,
                      harga: menu.harga,
                      tersedia: menu.tersedia,
                      ikon: menu.ikon,
                      heroTag: menuHeroTag(menu.id),
                      onTap: () => _bukaDetail(menu),
                      onLongPress: () => _ubahKetersediaan(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
