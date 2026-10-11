import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/app_state.dart';
import '../theme.dart';

/// Logo "BPR VARIA" (PNG dari Figma, 150x150 dengan ruang kosong di sekelilingnya).
class BprLogo extends StatelessWidget {
  const BprLogo({super.key, this.width = 150, this.height});

  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/logo_bpr_varia.png',
    width: width,
    height: height ?? width,
    fit: BoxFit.cover,
    filterQuality: FilterQuality.medium,
  );
}

/// Ikon PNG dari Figma (ikon putih / berwarna).
class AppIcon extends StatelessWidget {
  const AppIcon(this.name, {super.key, this.size = 35, this.opacity = 1});

  final String name;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset('assets/icons/$name.png', width: size, height: size, filterQuality: FilterQuality.medium);
    return opacity == 1 ? image : Opacity(opacity: opacity, child: image);
  }
}

/// Elips biru muda yang di-blur ("Mesh Color Background" / Ellipse 27, 31-35 di Figma).
class Glow extends StatelessWidget {
  const Glow({super.key, required this.width, required this.height, required this.sigma, this.opacity = 1});

  final double width;
  final double height;
  final double sigma;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma, tileMode: TileMode.decal),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            shape: const OvalBorder(),
            color: AppColors.glow.withValues(alpha: opacity),
          ),
        ),
      ),
    );
  }
}

/// Glow yang diposisikan dengan koordinat Figma (kiri-atas elips).
Widget positionedGlow({
  double? left,
  double? top,
  double? right,
  double? bottom,
  required double width,
  required double height,
  required double sigma,
  double opacity = 1,
}) {
  // Padding ekstra agar blur tidak terpotong oleh batas widget.
  final pad = sigma * 3;
  return Positioned(
    left: left == null ? null : left - pad,
    top: top == null ? null : top - pad,
    right: right == null ? null : right - pad,
    bottom: bottom == null ? null : bottom - pad,
    child: Padding(
      padding: EdgeInsets.all(pad),
      child: Glow(width: width, height: height, sigma: sigma, opacity: opacity),
    ),
  );
}

/// Kotak berwarna dengan teks (chip label pada form pengiriman & registrasi).
class LabelBox extends StatelessWidget {
  const LabelBox(
    this.text, {
    super.key,
    this.color = AppColors.turquoise,
    this.textColor = Colors.white,
    this.width,
    this.height = 23,
    this.radius = 5,
    this.fontSize = 15,
    this.weight = FontWeight.w700,
    this.padding = const EdgeInsets.symmetric(horizontal: 9),
  });

  final String text;
  final Color color;
  final Color textColor;
  final double? width;
  final double height;
  final double radius;
  final double fontSize;
  final FontWeight weight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    // Lebar dari Figma dipakai sebagai lebar minimum agar teks tidak terpotong
    // bila font di perangkat sedikit lebih lebar.
    return Container(
      constraints: BoxConstraints(minWidth: width ?? 0),
      height: height,
      padding: padding,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius)),
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: 1,
        child: Text(
          text,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(fontSize: fontSize, fontWeight: weight, color: textColor),
        ),
      ),
    );
  }
}

/// Tombol kotak kecil ("Lanjut", "Kembali", "Saya Setuju").
class FlatButtonBox extends StatelessWidget {
  const FlatButtonBox({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.field,
    this.textColor = AppColors.teal,
    this.width = 82,
    this.height = 26,
    this.fontSize = 12,
    this.weight = FontWeight.w500,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final double width;
  final double height;
  final double fontSize;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onPressed,
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontSize: fontSize, fontWeight: weight, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tombol bulat "home" di bawah layar pengiriman uang & promo.
class HomeCircleButton extends StatelessWidget {
  const HomeCircleButton({super.key, this.color = const Color(0x8046D0C3)});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Navigator.of(context).popUntil((route) => route.settings.name == homeRouteName || route.isFirst),
        child: const SizedBox(width: 70, height: 70, child: Center(child: AppIcon('home', size: 30))),
      ),
    );
  }
}

const homeRouteName = '/home';

/// Mengatur warna ikon status bar sistem (pengganti status bar palsu di Figma).
class StatusBarStyle extends StatelessWidget {
  const StatusBarStyle({super.key, required this.light, required this.child});

  final bool light;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (light ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: child,
    );
  }
}

/// Memformat input angka dengan pemisah ribuan koma saat diketik.
class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue();
    final text = formatNumber(int.parse(digits));
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

void showComingSoon(BuildContext context, String feature) => showMessage(context, '$feature — segera hadir (mockup)');

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Pemilih dari daftar opsi dalam bottom sheet. Mengembalikan opsi terpilih atau null.
Future<String?> pickOption(BuildContext context, String title, List<String> options, {String? selected}) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          for (final option in options)
            ListTile(
              title: Text(option),
              trailing: option == selected ? const Icon(Icons.check, color: AppColors.teal) : null,
              onTap: () => Navigator.pop(context, option),
            ),
        ],
      ),
    ),
  );
}

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

String formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

Future<String?> pickDate(BuildContext context, {DateTime? initial}) async {
  final now = DateTime.now();
  final date = await showDatePicker(
    context: context,
    initialDate: initial ?? DateTime(now.year - 25),
    firstDate: DateTime(1940),
    lastDate: now,
  );
  return date == null ? null : formatDate(date);
}
