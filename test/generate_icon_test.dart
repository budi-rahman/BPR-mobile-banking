// Membuat PNG sumber logo aplikasi di assets/launcher/ dari logo_source.png
// (potongan logo BPR VARIA dari screenshot yang diberikan).
// Jalankan: flutter test test/generate_icon_test.dart
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

const _size = 1024.0;

final Uint8List _logo = File('assets/launcher/logo_source.png').readAsBytesSync();

Widget _logoImage(double width) => Image.memory(_logo, width: width, fit: BoxFit.contain, filterQuality: FilterQuality.high);

Future<void> _render(WidgetTester tester, Widget child, String path) async {
  final key = GlobalKey();
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: RepaintBoundary(
          key: key,
          child: SizedBox(width: _size, height: _size, child: child),
        ),
      ),
    ),
  );
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 200)));
    await tester.pump();
  }
  await tester.runAsync(() async {
    final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(png!.buffer.asUint8List());
  });
}

void main() {
  setUp(() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(_size, _size);
    view.devicePixelRatio = 1;
  });

  testWidgets('icon penuh (legacy)', (tester) async {
    await _render(
      tester,
      ColoredBox(
        color: Colors.white,
        child: Center(child: _logoImage(_size * 0.84)),
      ),
      'assets/launcher/icon.png',
    );
  });

  testWidgets('foreground adaptive icon', (tester) async {
    // Area aman adaptive icon = 66% tengah, logo dibuat lebih kecil.
    await _render(tester, Center(child: _logoImage(_size * 0.62)), 'assets/launcher/foreground.png');
  });
}
