// ---------------------------------------------------------------------------
// FILE   : lib/widget/menu_status_badge.dart
// PERAN  : Label kecil berisi status menu.
//          Dipakai di dua tempat:
//          * MenuCard  -> hanya muncul sebagai label "Habis".
//          * DetailPage -> menampilkan "Tersedia" atau "Habis".
// KETENTUAN SOAL:
//          #2  label "Habis" saat menu tidak tersedia
//          #6  widget const
// ---------------------------------------------------------------------------

import 'package:material_ui/material_ui.dart';

/// Label status menu (kapsul kecil dengan warna hijau/merah).
class MenuStatusBadge extends StatelessWidget {
  const MenuStatusBadge({super.key, required this.tersedia});

  /// `true` -> "Tersedia" (hijau), `false` -> "Habis" (merah).
  final bool tersedia;

  @override
  Widget build(BuildContext context) {
    // Warna tetap: hijau = tersedia, merah = habis.
    final warna = tersedia
        ? const Color(0xFF2E7D32)
        : const Color(0xFFC62828);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: warna,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        tersedia ? 'Tersedia' : 'Habis',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
