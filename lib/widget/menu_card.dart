// ---------------------------------------------------------------------------
// FILE   : lib/widget/menu_card.dart
// PERAN  : Kartu menu pada KatalogPage (widget presentasional).
//          Kartu TIDAK menyimpan state; ia hanya menampilkan data dan
//          meneruskan aksi ke halaman lewat callback `onTap` / `onLongPress`.
// KETENTUAN SOAL:
//          #1  satu BoxDecoration: LinearGradient + borderRadius 20 +
//              border + boxShadow; ikon di dalam lingkaran (menu_artwork.dart)
//          #2  tekan lama -> status tersedia berubah; menu habis menjadi
//              transparan 0.4 lewat AnimatedOpacity 400 ms + label "Habis"
//          #3  kartu yang tersedia TIDAK dibungkus widget `Opacity`
//          #4  kartu adalah sumber animasi Hero
//          #6  const sebisa mungkin
// ---------------------------------------------------------------------------

import 'package:material_ui/material_ui.dart';

import '../model/menu_item.dart';
import 'menu_artwork.dart';
import 'menu_hero.dart';
import 'menu_status_badge.dart';

/// Tinggi tetap kartu; dipakai juga sebagai `itemExtent` ListView supaya
/// posisi tiap item bisa dihitung tanpa mengukur ulang isinya.
const double kMenuCardTinggi = 104.0;

/// Jarak antar kartu.
const double kMenuCardJarak = 12.0;

/// Durasi animasi transparansi & label (sesuai soal: 400 ms).
const Duration kMenuCardDurasiOpacity = Duration(milliseconds: 400);

/// Satu-satunya dekorasi kartu: gradasi, sudut 20, garis tepi, dan bayangan.
///
/// Dibuat sebagai konstanta supaya objek dekorasi tidak dibuat ulang setiap
/// kali kartu di-build (hemat alokasi memori).
const BoxDecoration _dekorasiKartu = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(20)),
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: kGradienIkon,
  ),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0x33FFFFFF), width: 1.2),
  ),
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Color(0x334E342E),
      blurRadius: 18,
      offset: Offset(0, 10),
    ),
  ],
);

/// Kartu menu katalog.
///
/// Atribut wajib sesuai soal: [nama], [harga], dan [tersedia].
/// Atribut tambahan ([ikon], [heroTag]) dibutuhkan agar animasi Hero dan
/// tampilan ikon bisa bekerja tanpa kartu perlu tahu data menu lengkap.
class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.nama,
    required this.harga,
    required this.tersedia,
    required this.ikon,
    required this.heroTag,
    this.onTap,
    this.onLongPress,
  });

  /// Nama menu.
  final String nama;

  /// Harga menu dalam rupiah.
  final int harga;

  /// Status ketersediaan. `false` -> kartu transparan + label "Habis".
  final bool tersedia;

  /// Ikon menu (ditampilkan di dalam lingkaran).
  final IconData ikon;

  /// Tag Hero; harus sama dengan tag di DetailPage.
  final String heroTag;

  /// Aksi saat kartu ditekan (buka halaman detail).
  final VoidCallback? onTap;

  /// Aksi saat kartu ditekan lama (ubah status ketersediaan).
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kMenuCardTinggi,
      child: Stack(
        // Tumpukan: kartu (bisa memudar) + label "Habis" (tetap tajam).
        children: <Widget>[
          Positioned.fill(
            // CATATAN PENTING soal ketentuan #3:
            // Kartu yang TERSEDIA bernilai opacity 1.0 dan tidak dibungkus
            // widget `Opacity` sama sekali. `AnimatedOpacity` dipakai justru
            // supaya perubahan 1.0 <-> 0.4 berjalan halus 400 ms; kalau
            // pembungkusnya dipasang bersyarat, animasinya tidak akan terlihat
            // karena widget baru langsung lahir dengan nilai akhirnya.
            child: AnimatedOpacity(
              opacity: tersedia ? 1.0 : 0.4,
              duration: kMenuCardDurasiOpacity,
              curve: Curves.easeOut,
              child: _PermukaanKartu(
                nama: nama,
                harga: harga,
                ikon: ikon,
                heroTag: heroTag,
                onTap: onTap,
                onLongPress: onLongPress,
              ),
            ),
          ),
          // Label "Habis" diletakkan DI LUAR fade kartu agar tetap terbaca
          // jelas saat kartu memudar, lalu memudar masuk sendiri.
          Positioned(
            bottom: 10,
            right: 12,
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: tersedia ? 0.0 : 1.0,
                duration: kMenuCardDurasiOpacity,
                curve: Curves.easeOut,
                child: const MenuStatusBadge(tersedia: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Permukaan kartu: dekorasi + area sentuh + isi (ikon, nama, harga).
///
/// Dipisah dari [MenuCard] agar bagian dekoratif mudah dibaca dan tidak
/// bercampur dengan logika transparansi.
class _PermukaanKartu extends StatelessWidget {
  const _PermukaanKartu({
    required this.nama,
    required this.harga,
    required this.ikon,
    required this.heroTag,
    required this.onTap,
    required this.onLongPress,
  });

  final String nama;
  final int harga;
  final IconData ikon;
  final String heroTag;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      // clipBehavior + decoration radius membuat ripple InkWell ikut terpotong
      // rapi di sudut 20.
      clipBehavior: Clip.antiAlias,
      decoration: _dekorasiKartu,
      child: Material(
        // Transparan supaya gradasi kartu tetap terlihat di balik ripple.
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: <Widget>[
                // Sumber animasi Hero: lingkaran ikon berubah menjadi persegi
                // besar di DetailPage.
                Hero(
                  tag: heroTag,
                  createRectTween: menuHeroRectTween,
                  flightShuttleBuilder: menuHeroFlightShuttle(ikon),
                  child: MenuArtwork.kecil(ikon: ikon),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatRupiah(harga),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Petunjuk bahwa kartu bisa ditekan.
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
