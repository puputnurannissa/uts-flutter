// ---------------------------------------------------------------------------
// FILE   : lib/widget/menu_artwork.dart
// PERAN  : "Media" ikon menu yang dipakai bersama oleh kartu katalog dan
//          halaman detail, supaya Hero bisa melakukan transisi dari bentuk
//          LINGKARAN (kartu) ke PERSEGI BESAR (detail).
// KETENTUAN SOAL:
//          #1  ikon di dalam lingkaran (BoxShape.circle)
//          #4  lingkaran -> persegi besar (ukuran & radius jadi patokan)
//          #6  konstanta & widget const sebisa mungkin
// ---------------------------------------------------------------------------

import 'package:material_ui/material_ui.dart';

/// Diameter ikon pada kartu katalog (sumber animasi Hero).
const double kIkonKecil = 56.0;

/// Sisi persegi ikon pada DetailPage (tujuan animasi Hero).
const double kIkonBesar = 220.0;

/// Radius sudut persegi pada DetailPage. Kecil, jadi terlihat seperti persegi.
const double kRadiusIkonBesar = 16.0;

/// Radius lingkaran kartu = setengah diameter, hasilnya bulat sempurna.
const double kRadiusIkonKecil = kIkonKecil / 2;

/// Gradasi yang dipakai ikon, kartu, shuttle Hero, dan header katalog.
const List<Color> kGradienIkon = <Color>[Color(0xFF4E342E), Color(0xFF8D6E63)];

/// Media ikon menu.
///
/// Ada dua varian resmi:
/// * [MenuArtwork.kecil]  -> lingkaran 56px untuk kartu katalog.
/// * [MenuArtwork.besar]  -> persegi 220px untuk DetailPage.
///
/// Catatan belajar: `BoxDecoration` tidak boleh memakai `shape: BoxShape.circle`
/// dan `borderRadius` sekaligus (ada assert di framework), karena itu kedua
/// properti itu disetel bersyarat lewat [berbentukLingkaran].
class MenuArtwork extends StatelessWidget {
  /// Varian kecil: lingkaran untuk kartu katalog.
  const MenuArtwork.kecil({super.key, required this.ikon})
      : ukuran = kIkonKecil,
        radius = kRadiusIkonKecil,
        berbentukLingkaran = true;

  /// Varian besar: persegi bersudut membulat untuk DetailPage.
  const MenuArtwork.besar({super.key, required this.ikon})
      : ukuran = kIkonBesar,
        radius = kRadiusIkonBesar,
        berbentukLingkaran = false;

  /// Ikon yang mewakili menu.
  final IconData ikon;

  /// Sisi kotak pembungkus ikon (diameter bila lingkaran).
  final double ukuran;

  /// Radius sudut; diabaikan saat [berbentukLingkaran] bernilai `true`.
  final double radius;

  /// `true` -> `BoxShape.circle` (lingkaran), `false` -> persegi membulat.
  final bool berbentukLingkaran;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(
        // Lingkaran memakai shape, persegi memakai borderRadius.
        shape: berbentukLingkaran ? BoxShape.circle : BoxShape.rectangle,
        borderRadius:
            berbentukLingkaran ? null : BorderRadius.circular(radius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: kGradienIkon,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x334E342E),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        ikon,
        // Ukuran ikon selalu proporsional terhadap kotaknya.
        size: ukuran * 0.42,
        color: Colors.white,
      ),
    );
  }
}
