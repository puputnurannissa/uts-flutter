// ---------------------------------------------------------------------------
// FILE   : lib/widget/katalog_header.dart
// PERAN  : Bagian atas KatalogPage: judul, ringkasan jumlah menu, petunjuk
//          interaksi, dan ikon cangkir yang berputar.
// KETENTUAN SOAL:
//          #5  header memuat radial berputar (lihat spinning_cup_icon.dart)
//          #6  const sebisa mungkin
// ---------------------------------------------------------------------------

import 'package:material_ui/material_ui.dart';

import 'spinning_cup_icon.dart';

/// Header katalog menu.
///
/// Menerima [totalMenu] dan [menuHabis] (bukan daftar menu penuh) supaya
/// widget ini tetap "bodoh"/presentasional dan mudah dipakai ulang.
class KatalogHeader extends StatelessWidget {
  const KatalogHeader({
    super.key,
    required this.totalMenu,
    required this.menuHabis,
  });

  /// Jumlah seluruh menu yang ditampilkan.
  final int totalMenu;

  /// Jumlah menu yang sedang habis.
  final int menuHabis;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF3E2723), Color(0xFF795548)],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x333E2723),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Katalog Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalMenu menu • $menuHabis sedang habis',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.touch_app,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Ketuk untuk detail • tekan lama untuk ubah status',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Radial berputar: satu-satunya bagian header yang beranimasi.
          const SpinningCupIcon(),
        ],
      ),
    );
  }
}
