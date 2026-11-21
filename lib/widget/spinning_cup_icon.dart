// ---------------------------------------------------------------------------
// FILE   : lib/widget/spinning_cup_icon.dart
// PERAN  : Ikon cangkir yang berputar terus-menerus (radial berputar) pada
//          header KatalogPage.
// KETENTUAN SOAL:
//          #5  AnimationController + Transform.rotate 0..2pi,
//              AnimatedBuilder dengan parameter `child`, RepaintBoundary,
//              dan dispose() pada controller.
// KETENTUAN PERFORMA (#6):
//          Ikon yang berputar diberikan sebagai `child` AnimatedBuilder
//          sehingga TIDAK dibangun ulang setiap frame; hanya Transform yang
//          diperbarui.
// ---------------------------------------------------------------------------

import 'dart:math' show pi;

import 'package:material_ui/material_ui.dart';

/// Ikon cangkir berputar 360 derajat tanpa henti.
///
/// Widget ini stateful karena memiliki [AnimationController] yang harus
/// dihentikan dan dibuang pada [dispose] agar tidak bocor memorinya.
class SpinningCupIcon extends StatefulWidget {
  const SpinningCupIcon({
    super.key,
    this.ukuran = 34.0,
    this.warna = Colors.white,
    this.durasiPutaran = const Duration(seconds: 4),
  });

  /// Ukuran sisi ikon.
  final double ukuran;

  /// Warna ikon.
  final Color warna;

  /// Lama satu putaran penuh (360 derajat).
  final Duration durasiPutaran;

  @override
  State<SpinningCupIcon> createState() => _SpinningCupIconState();
}

class _SpinningCupIconState extends State<SpinningCupIcon>
    with SingleTickerProviderStateMixin {
  /// Controller animasi berulang. `late final` karena baru bisa dibuat di
  /// [initState] (butuh `vsync` dari mixin ticker).
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.durasiPutaran,
    )..repeat(); // berputar terus-menerus.
  }

  @override
  void dispose() {
    // WAJIB: hentikan & buang controller saat widget tidak dipakai lagi.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      // `child` dibuat SEKALI lalu dipakai ulang setiap frame (hemat build).
      child: RepaintBoundary(
        child: Icon(
          Icons.local_cafe,
          size: widget.ukuran,
          color: widget.warna,
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        // 0..1 dari controller dipetakan menjadi 0..2pi radian (satu putaran).
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
    );
  }
}
