import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';

/// Template layar "Halo Variers" (frame "Registration KTP Found" & "On boarding e-KYC").
class _GreetingScreen extends StatelessWidget {
  const _GreetingScreen({
    required this.message,
    required this.textWidth,
    required this.buttonLabel,
    required this.onPressed,
    required this.illustration,
    required this.illustrationOffset,
  });

  final String message;
  final double textWidth;
  final String buttonLabel;
  final VoidCallback onPressed;
  final String illustration;

  /// Posisi ilustrasi (200x200, opacity 20%) relatif terhadap tombol, sesuai Figma.
  final Offset illustrationOffset;

  @override
  Widget build(BuildContext context) {
    return StatusBarStyle(
      light: false,
      child: Scaffold(
        backgroundColor: AppColors.beige,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 90, 28, 240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: BprLogo(width: 125)),
                const SizedBox(height: 98),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: textWidth),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.teal),
                      children: [
                        const TextSpan(
                          text: 'Halo Variers',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const TextSpan(text: ',\n\n'),
                        TextSpan(text: message),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 26,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      FlatButtonBox(label: buttonLabel, onPressed: onPressed),
                      Positioned(
                        left: illustrationOffset.dx,
                        top: illustrationOffset.dy,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.2,
                            child: Image.asset('assets/images/$illustration', width: 200, height: 200),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Frame "Registration KTP Found".
class KtpFoundScreen extends StatelessWidget {
  const KtpFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _GreetingScreen(
      message:
          'KTP kamu sudah terdaftar di sistem kami, mohon untuk melanjutkan pengisian data untuk aktivasi '
          'Mobile Banking Varia kamu.',
      textWidth: 307,
      buttonLabel: 'Lanjut',
      illustration: 'door.png',
      illustrationOffset: const Offset(187, 2),
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EkycOnboardingScreen())),
    );
  }
}

/// Frame "On boarding e-KYC".
class EkycOnboardingScreen extends StatelessWidget {
  const EkycOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _GreetingScreen(
      message: 'Check email kamu Sekarang untuk melanjutkan e-KYC dan Tanda Tangan Digital',
      textWidth: 280,
      buttonLabel: 'Kembali',
      illustration: 'face_scan.png',
      illustrationOffset: const Offset(165, 20),
      // Kembali ke layar login.
      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
    );
  }
}
