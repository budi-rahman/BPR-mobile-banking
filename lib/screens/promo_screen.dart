import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Frame "Promo 2" - "Promo 5".
class PromoScreen extends StatelessWidget {
  const PromoScreen({super.key, required this.promo});

  final Promo promo;

  @override
  Widget build(BuildContext context) {
    const white = TextStyle(fontSize: 16, color: Colors.white);
    final left = promo.wide ? 12.0 : 47.0;
    return StatusBarStyle(
      light: true,
      child: Scaffold(
        backgroundColor: AppColors.navy,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // "Ellipse 31/32/33" di Figma.
            positionedGlow(left: -34, top: -10, width: 418, height: 111, sigma: 100),
            positionedGlow(left: 17, top: 599, width: 418, height: 111, sigma: 100),
            positionedGlow(left: 295, top: 144, width: 98, height: 37, sigma: 50),
            positionedGlow(left: 348, top: 711, width: 98, height: 37, sigma: 50),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final imageWidth = math.min(promo.wide ? 370.0 : 300.0, constraints.maxWidth - left * 2);
                        final imageHeight = promo.wide ? imageWidth * 202.267 / 370 : imageWidth / promo.imageAspect;
                        final scale = imageWidth / 370;
                        return SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(left, 100, left, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(promo.code, style: white),
                              const SizedBox(height: 32),
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      promo.image,
                                      width: imageWidth,
                                      height: imageHeight,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (promo.wide)
                                    Positioned(
                                      left: 9 * scale,
                                      top: 136 * scale,
                                      child: BprLogo(width: 82 * scale, height: 54 * scale),
                                    ),
                                ],
                              ),
                              SizedBox(height: promo.wide ? 32 : 15),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: promo.wide ? 341 : 285),
                                child: Text.rich(
                                  TextSpan(
                                    style: white,
                                    children: [
                                      const TextSpan(
                                        text: 'Hi ',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                      ),
                                      const TextSpan(
                                        text: 'Variers',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                      ),
                                      const TextSpan(
                                        text: ',\n\n',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                      ),
                                      TextSpan(text: promo.paragraphs.join('\n')),
                                      TextSpan(text: '\n\n${promo.closingPrefix}'),
                                      TextSpan(
                                        text: promo.closing,
                                        style: const TextStyle(fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 19),
                    child: HomeCircleButton(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
