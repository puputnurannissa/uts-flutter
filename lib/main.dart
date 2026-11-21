// ---------------------------------------------------------------------------
// FILE   : lib/main.dart
// PERAN  : Titik masuk aplikasi (composition root).
//          Di sini hanya ada: konfigurasi MaterialApp + tema + halaman awal.
//          Tidak ada logika bisnis, tidak ada widget UI besar.
// CATATAN: Proyek ini memakai paket `material_ui` (Material resmi Flutter yang
//          sudah dipisah dari SDK sejak Flutter 3.50), bukan
//          `package:flutter/material.dart`.
// ---------------------------------------------------------------------------

import 'package:material_ui/material_ui.dart';

import 'page/katalog_page.dart';

void main() {
  runApp(const MainApp());
}

/// Akar aplikasi.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katalog Menu Kafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6D4C41),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F2ED),
      ),
      home: const KatalogPage(),
    );
  }
}
