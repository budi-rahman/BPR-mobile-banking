import 'package:flutter/material.dart';

/// Warna & tipografi diambil dari file Figma "BPR Varia Mobile Banking".
class AppColors {
  // Beranda & promo
  static const navy = Color(0xFF002278);
  static const blue = Color(0xFF007CC7);
  static const balanceCard = Color(0xFF1C5E9D);
  static const glow = Color(0xFF00D1FF);
  static const avatarRing = Color(0xFFD9D9D9);
  static const menuLabel = Color(0xFF635959);

  // Login & registrasi
  static const beige = Color(0xFFF5EFE9);
  static const field = Color(0xFFD9D9D9);
  static const chip = Color(0xFFC9C9C9);
  static const teal = Color(0xFF00B6B6);
  static const link = Color(0xFF01287D);
  static const loginButtonText = Color(0xFF013C8C);

  // Pengiriman uang
  static const tealHeader = Color(0xFF4AD0C0);
  static const mint = Color(0xFFA3E7E1);
  static const turquoise = Color(0xFF46D0C3);
  static const pill = Color(0xFFADC7DE);
  static const tileShadow = Color(0xFF9F9B96);
  static const tileText = Color(0xFF877E7D);
  static const orange = Color(0xCCF78B28);
  static const orangeShadow = Color(0xFFE7E0D9);
  static const textMuted = Color(0x80635959);
}

class AppFonts {
  static const sans = 'Inter';
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: AppFonts.sans,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.navy, primary: AppColors.navy),
    scaffoldBackgroundColor: Colors.white,
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
