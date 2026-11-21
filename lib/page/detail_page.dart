// ---------------------------------------------------------------------------
// FILE   : lib/page/detail_page.dart
// PERAN  : Halaman kedua (halaman besar #2) yang menampilkan satu menu secara
//          lengkap. Halaman ini adalah TUJUAN animasi Hero.
// KETENTUAN SOAL:
//          #4  ikon lingkaran dari kartu berubah menjadi persegi besar di sini
//              (MenuArtwork.besar), Hero 600 ms lewat [DetailPage.route],
//              lintasan melengkung dari menu_hero.dart
//          #6  const sebisa mungkin
// ---------------------------------------------------------------------------

import 'package:material_ui/material_ui.dart';

import '../model/menu_item.dart';
import '../widget/menu_artwork.dart';
import '../widget/menu_hero.dart';
import '../widget/menu_status_badge.dart';

/// Halaman detail satu menu.
///
/// Stateless karena hanya menampilkan data yang sudah diberikan; status
/// ketersediaan tampil sebagai informasi, bukan sebagai kontrol.
class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.menu});

  /// Menu yang sedang dilihat.
  final MenuItem menu;

  /// Membuat route khusus halaman ini.
  ///
  /// Kenapa bukan `MaterialPageRoute`? Durasi transisi `MaterialPageRoute`
  /// tetap 300 ms, sedangkan soal meminta Hero berjalan 600 ms. Hero mengikuti
  /// durasi transisi route, jadi durasinya diatur di sini. Fade tipis dipakai
  /// agar perpindahan halaman tidak terasa kaku di sekitar Hero.
  static Route<void> route({required MenuItem menu}) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return DetailPage(menu: menu);
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2ED),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Baris atas: tombol kembali + status ketersediaan.
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    tooltip: 'Kembali',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4E342E),
                    ),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  MenuStatusBadge(tersedia: menu.tersedia),
                ],
              ),
              const SizedBox(height: 16),

              // TUJUAN Hero: lingkaran kecil -> persegi besar 220 px.
              // Tag, rectTween, dan shuttle harus identik dengan sisi kartu.
              Center(
                child: Hero(
                  tag: menuHeroTag(menu.id),
                  createRectTween: menuHeroRectTween,
                  flightShuttleBuilder: menuHeroFlightShuttle(menu.ikon),
                  child: MenuArtwork.besar(ikon: menu.ikon),
                ),
              ),
              const SizedBox(height: 28),

              // Identitas menu.
              Text(
                menu.nama,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2B211D),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                menu.hargaRupiah,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8D6E63),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1, color: Color(0x1F4E342E)),
              const SizedBox(height: 20),

              // Deskripsi singkat.
              const Text(
                'Tentang menu ini',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: Color(0xFF8D6E63),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                menu.deskripsi,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.55,
                  color: Color(0xFF5D4037),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
