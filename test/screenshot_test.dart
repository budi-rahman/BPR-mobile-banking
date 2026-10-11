// Render setiap layar ke PNG untuk dibandingkan dengan Figma.
// Jalankan: flutter test test/screenshot_test.dart --update-goldens
import 'dart:io';

import 'package:bpr_mobile_banking/data/dummy_data.dart';
import 'package:bpr_mobile_banking/screens/home_screen.dart';
import 'package:bpr_mobile_banking/screens/login_screen.dart';
import 'package:bpr_mobile_banking/screens/onboarding_screens.dart';
import 'package:bpr_mobile_banking/screens/promo_screen.dart';
import 'package:bpr_mobile_banking/screens/registration_form_screen.dart';
import 'package:bpr_mobile_banking/screens/registration_screen.dart';
import 'package:bpr_mobile_banking/screens/splash_screen.dart';
import 'package:bpr_mobile_banking/screens/transfer_screens.dart';
import 'package:bpr_mobile_banking/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _loadFont(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final f in files) {
    final bytes = File(f).readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

void main() {
  setUpAll(() async {
    await _loadFont('Inter', [
      for (final w in ['Light', 'Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) 'assets/fonts/Inter-$w.ttf',
    ]);
    final flutterRoot =
        Platform.environment['FLUTTER_ROOT'] ??
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent.path;
    final iconFont = File('$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
    if (iconFont.existsSync()) await _loadFont('MaterialIcons', [iconFont.path]);
  });

  const transfer = TransferData(
    type: TransferType.bank,
    bank: 'BANK BCA',
    accountNumber: '1234567890',
    recipient: 'JONNY TAK ABET',
    amount: 2000000,
    fee: 2500,
    method: 'BI FAST',
  );
  const draft = RegistrationDraft(fullName: 'Ilham Joenoes', birthDate: '17 Agu 1975', phone: '081299998888');

  final screens = <String, Widget Function()>{
    'splash': () => const SplashScreen(autoNavigate: false),
    'login': () => const LoginScreen(),
    'registration': () => const RegistrationScreen(),
    'ktp_found': () => const KtpFoundScreen(),
    'ekyc': () => const EkycOnboardingScreen(),
    'form_1': () => const RegistrationFormScreen(initial: draft),
    'form_2': () => const RegistrationFormScreen(initial: draft, initialStep: 1),
    'form_3': () => const RegistrationFormScreen(initial: draft, initialStep: 2),
    'home': () => const HomeScreen(),
    'home_accounts': () => const HomeScreen(initialTab: 1),
    'home_settings': () => const HomeScreen(initialTab: 3),
    'transfer_menu': () => const TransferMenuScreen(),
    'transfer_account': () => const TransferFormScreen(type: TransferType.account),
    'transfer_bank': () => const TransferFormScreen(type: TransferType.bank),
    'receipt_query': () => const TransferReceiptScreen(transfer: transfer),
    'receipt_status': () => const TransferReceiptScreen(transfer: transfer, success: true),
    for (var i = 0; i < DummyData.promos.length; i++) 'promo_${i + 2}': () => PromoScreen(promo: DummyData.promos[i]),
  };

  for (final entry in screens.entries) {
    testWidgets(entry.key, (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.75;
      tester.view.padding = const FakeViewPadding(top: 66);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(debugShowCheckedModeBanner: false, theme: buildTheme(), home: entry.value()));
      // Biarkan aset PNG selesai di-decode.
      for (var i = 0; i < 5; i++) {
        await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 200)));
        await tester.pump(const Duration(milliseconds: 100));
      }
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('screenshots/${entry.key}.png'));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });
  }
}
