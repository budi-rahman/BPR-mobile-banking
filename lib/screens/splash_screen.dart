import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/common.dart';
import 'login_screen.dart';

/// Frame "Mobile Banking +".
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.autoNavigate = true});

  final bool autoNavigate;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoNavigate) {
      _timer = Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, _, _) => const LoginScreen(),
            transitionsBuilder: (_, animation, _, child) => FadeTransition(opacity: animation, child: child),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarStyle(
      light: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              const BprLogo(),
              // Di Figma teks menempel 19px di dalam kotak logo 150x150.
              Transform.translate(
                offset: const Offset(0, -19),
                child: const Text('Mobile Platform', style: TextStyle(fontSize: 20, color: Colors.black)),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.fromLTRB(27, 0, 17, 40),
                child: Text(
                  'All rights reserved 2013. BPR Varia Central Artha is licensed & supervised by the '
                  'Financial Authority and is an LPS guarantee participant.',
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
