// ---------------------------------------------------------------------------
// FILE   : lib/widget/menu_hero.dart
// PERAN  : Semua "perekat" animasi Hero antara KatalogPage dan DetailPage.
//          Isinya: pembuat tag, rectTween berlintasan melengkung, shuttle
//          (tampilan saat terbang), dan perhitungan radius yang diinterpolasi.
// KETENTUAN SOAL:
//          #4  Hero 600 ms (durasi diatur di DetailPage.route),
//              ClipRRect dengan radius yang diinterpolasi,
//              createRectTween berlintasan melengkung.
// ---------------------------------------------------------------------------

import 'package:material_ui/material_ui.dart';

import 'menu_artwork.dart';

/// Tag Hero untuk satu menu. Harus sama persis di kartu (sumber) dan
/// halaman detail (tujuan) supaya framework tahu keduanya pasangan.
String menuHeroTag(String idMenu) => 'menu-hero-$idMenu';

/// Lintasan perpindahan kotak Hero.
///
/// `MaterialRectArcTween` menggerakkan kotak mengikuti BUSUR (melengkung),
/// bukan garis lurus antar dua titik. Inilah yang dimaksud "berlintasan
/// melengkung" pada soal.
RectTween menuHeroRectTween(Rect? begin, Rect? end) {
  return MaterialRectArcTween(begin: begin, end: end);
}

/// Membuat `flightShuttleBuilder` yang tahu ikon mana yang sedang terbang.
///
/// Kenapa perlu fungsi pembuat? `HeroFlightShuttleBuilder` hanya menerima
/// posisi/konteks, bukan data menu. Dengan mengikat [ikon] di sini, shuttle
/// tetap bisa menggambar ikon yang benar.
HeroFlightShuttleBuilder menuHeroFlightShuttle(IconData ikon) {
  return (
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return MenuHeroShuttle(ikon: ikon, animasi: animation);
  };
}

/// Tampilan ikon SELAMA penerbangan Hero.
///
/// Framework membangun shuttle hanya sekali per penerbangan, jadi perubahan
/// radius per frame harus berasal dari `AnimatedBuilder` di dalam widget ini.
/// Radius diinterpolasi dari [kRadiusIkonKecil] (28 -> lingkaran) menuju
/// [kRadiusIkonBesar] (16 -> persegi), sehingga bentuknya berubah bertahap,
/// bukan melompat di akhir animasi.
class MenuHeroShuttle extends StatelessWidget {
  const MenuHeroShuttle({
    super.key,
    required this.ikon,
    required this.animasi,
  });

  /// Ikon menu yang ikut terbang.
  final IconData ikon;

  /// Progres penerbangan 0..1 (diberikan oleh Hero).
  final Animation<double> animasi;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animasi,
      builder: (BuildContext context, Widget? child) {
        final progres = animasi.value;

        // Interpolasi ukuran supaya isi shuttle selalu pas dengan kotaknya.
        final ukuran = kIkonKecil + (kIkonBesar - kIkonKecil) * progres;

        // Interpolasi radius: inti ketentuan "radius yang diinterpolasi".
        final radius =
            kRadiusIkonKecil + (kRadiusIkonBesar - kRadiusIkonKecil) * progres;

        return SizedBox(
          width: ukuran,
          height: ukuran,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: kGradienIkon,
                ),
              ),
              child: Center(
                // Ikon ikut membesar mengikuti ukuran kotak.
                child: Icon(
                  ikon,
                  size: ukuran * 0.42,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
